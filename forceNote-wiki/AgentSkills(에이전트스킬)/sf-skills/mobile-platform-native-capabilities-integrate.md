---
tags: [agent-skill, sf-skills, mobile, lwc, mobileCapabilities]
source: forcedotcom/sf-skills (skills/mobile-platform-native-capabilities-integrate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [mobile-platform-native-capabilities-integrate, 모바일 네이티브 기능 통합, lightning/mobileCapabilities, Nimbus, 바코드 스캐너 생체인증 위치 LWC]
---

# mobile-platform-native-capabilities-integrate — LWC 모바일 네이티브 기능 통합

> `lightning/mobileCapabilities` 모듈로 바코드 스캐너·생체인증·위치·NFC·캘린더·연락처·문서 스캐너·지오펜싱·AR 공간 캡처·앱 리뷰·결제 등 네이티브 디바이스 기능을 LWC에 올바른 가용성 게이팅·에러 처리·deprecation 인지 API 선택으로 연결하는 스킬.

---

## 목적과 활성화 조건

`lightning/mobileCapabilities` 모듈은 네이티브 디바이스 기능용 서비스 객체를 반환하는 factory 함수 집합을 노출한다. 각 서비스는 공통 `BaseCapability`(`isAvailable()` 메서드 보유)를 확장하므로, 기능이 없는 표면(desktop, mobile web)에서 LWC가 graceful하게 degrade할 수 있다.

이 스킬은 에이전트를 (1) 올바른 기능 선택, (2) 권위 있는 타입 정의 로드, (3) 올바른 가용성 게이팅·에러 처리·deprecation 인지 API 선택으로 서비스를 LWC에 와이어링하는 과정으로 라우팅한다.

**사용 시점:**
- 사용자가 capability 인덱스에 있는 디바이스 기능을 쓰는 LWC를 요청할 때
- `lightning/mobileCapabilities`, "mobile capability", "Nimbus"를 이름으로 언급할 때
- 어떤 모바일 네이티브 API가 있는지, 또는 어느 것이 기능에 맞는지 알고 싶을 때

**사용 금지:**
- LWC의 모바일 오프라인 리뷰(lwc:if, inline GraphQL, Komaci 프라이밍 위반) → `mobile-platform-offline-validate` 사용
- 일반 Lightning Base Components 선택 → `using-lightning-base-components` 사용

**전제조건:**
- LWC가 지원되는 모바일 컨테이너(Salesforce Mobile App, Field Service Mobile App) 안에서 실행됨을 알 것. 이 기능들은 desktop·mobile web에서는 불가하므로 **모든 호출을 `isAvailable()` 뒤에 게이트**한다.
- `lightning/mobileCapabilities` 모듈 선언 익숙할 것.

---

## 워크플로 / 단계

### Capability Index

| Capability | One-line use |
|---|---|
| App Review | 사용자에게 네이티브 in-app 리뷰 요청. |
| AR Space Capture | AR로 물리 공간의 3D 스캔 캡처. |
| Barcode Scanner | 카메라로 QR / UPC / EAN / Code-128 등 읽기. |
| Biometrics | Face ID / 지문으로 인증. |
| Calendar | 디바이스 캘린더 이벤트 읽기/생성. |
| Contacts | 디바이스 주소록 항목 읽기/생성. |
| Document Scanner | 카메라 + 엣지 감지로 종이 문서 스캔. |
| Geofencing | 디바이스가 지리적 경계를 넘을 때 로직 트리거. |
| Location | GPS 좌표 읽기 및 업데이트 watch. |
| NFC | NFC 태그 읽기/쓰기. |
| Payments | Apple Pay / Google Pay 결제 수령. |

### Step 1 — 기능 식별
사용자의 기능 요청을 capability 인덱스의 한 행에 매핑한다. 요청이 여러 기능에 걸치면(예: "바코드 스캔 후 연락처에 저장") **각 기능을 따로** 계획한다 — 기능당 factory 함수 하나다.

### Step 2 — 공유 + 기능별 reference 로드
세션당 **한 번** 공유 reference 두 개를 읽는다 (모든 기능에 적용, 기능별 파일에 중복 안 됨):
- `BaseCapability` — 모든 서비스가 확장하는 `isAvailable()` 공통 인터페이스.
- `mobile-capabilities` — 재내보낸 모든 서비스를 보여주는 `lightning/mobileCapabilities` 모듈 선언.

그다음 표에서 기능의 reference 파일을 연다. 각 기능별 reference는 서비스 특화 TypeScript API(factory 함수, 서비스 인터페이스, options/result/error 타입)를 담으며 위 두 공유 reference가 이미 컨텍스트에 있다고 가정한다. **기억으로 API를 추론하지 말고 읽는다** — 서비스는 진화하며 일부 메서드는 `@deprecated`로 명시돼 있다.

### Step 3 — 서비스를 LWC에 와이어링

기본 와이어링 골격:

```js
import { getBarcodeScanner } from 'lightning/mobileCapabilities';

const scanner = getBarcodeScanner();
if (!scanner.isAvailable()) {
  // graceful fallback or user message
  return;
}
try {
  const result = await scanner.scan({ enableMultiScan: false });
  // result[0].value 사용
} catch (error) {
  // error.code를 BarcodeScannerFailureCode와 대조
}
```

각 기능마다:
1. `lightning/mobileCapabilities`에서 factory를 import:
   ```js
   import { getBarcodeScanner } from 'lightning/mobileCapabilities';
   ```
2. 인스턴스 획득: `const scanner = getBarcodeScanner();`
3. `isAvailable()` 뒤에 호출 게이트:
   ```js
   if (!scanner.isAvailable()) {
     // graceful fallback or user message
     return;
   }
   ```
4. **non-deprecated** 진입점 호출. 여러 서비스가 권장 메서드 옆에 구버전을 `@deprecated`로 둔다 — 항상 reference의 권장 메서드를 선호한다.
5. promise를 `try/catch`로 감싸고 서비스가 노출하는 typed failure code(예: `BarcodeScannerFailureCode`, `LocationServiceFailureCode`)를 처리한다. user-cancelled vs. permission-denied vs. service-unavailable은 구별되는 UX 상태다.

### Step 4 — 실패 모드를 사용자에게 노출
각 서비스는 자체 failure-code enum을 정의한다. 코드를 사용자 행동 가능 메시지로 번역한다: `USER_DENIED_PERMISSION`은 권한 부여를 요청, `USER_DISABLED_PERMISSION`은 OS 설정으로 안내, `SERVICE_NOT_ENABLED`는 사용자에게 표시하지 않는 개발자용 에러여야 한다.

### Step 5 — 지원 표면 안에 머무르기
모바일 기능은 LWC가 지원되는 Salesforce 모바일 앱 안에서 실행될 때**만** 가용하다. 동일 컴포넌트가 desktop·mobile web에 렌더되면 factory는 여전히 객체를 반환하지만 `isAvailable()`이 `false`를 반환한다. 가용성을 절대 가정하지 말고 모든 호출을 게이트한다.

### 예시 — "바코드 스캔 후 필드에 기록"
1. Barcode Scanner에 매핑.
2. Barcode Scanner reference 읽기.
3. deprecated `beginCapture` / `resumeCapture` / `endCapture` 삼총사 대신 `scan(options)` 사용.
4. options에서 `barcodeTypes`를 필요한 symbology로 설정(기본은 모든 지원 타입), 단일 읽기는 `enableMultiScan: false`.
5. resolve 시 `result[0].value`를 바인딩 필드에 기록. reject 시 `error.code`를 `BarcodeScannerFailureCode`와 대조.

### 예시 — "주문 총액에 대해 Apple Pay 결제"
1. Payments에 매핑.
2. Payments reference 읽기.
3. `isAvailable()` 게이트.
4. reference대로 결제 요청 객체 구성.
5. resolve 시 transaction id를 호출 flow에 노출. reject 시 user-cancelled와 payment-failed 경로를 따로 처리.

---

## 핵심 규칙·가드레일

**Verification Checklist:**
- [ ] 모든 기능 호출 앞에 `isAvailable()`이 선행한다.
- [ ] non-deprecated 진입점 사용 (barcode에 `beginCapture` / `resumeCapture` / `endCapture` 없음).
- [ ] 각 rejection 경로가 typed failure code enum에 매핑된다.
- [ ] import는 private 경로가 아니라 `lightning/mobileCapabilities`에서 온다.
- [ ] 기능이 desktop·mobile web에서 실행된다는 가정 없음.

**Troubleshooting:**
- **실제 디바이스에서 `isAvailable()`이 `false`** — 디바이스가 미지원 앱 표면(Salesforce Mobile/Field Service Mobile 아님)을 실행 중이거나, 서비스가 org 레벨 설정으로 게이트됨. 코드가 아니라 org 구성 수정이 답.
- **TypeScript가 import를 못 찾음** — LWC가 `lightning/mobileCapabilities`에 접근 가능한지 확인. 모듈은 Salesforce 모바일 컨테이너 안에서 전역 선언되며, 밖에서는 타입을 별도 설치해야 함.
- **deprecated barcode 메서드가 여전히 동작** — 그렇지만 새 코드는 `scan()`과 `dismiss()`를 써야 함. 받은 샘플 코드를 반환 전에 리팩터.
- **한 컴포넌트에 여러 기능** — 기능당 별도 인스턴스 획득(독립 서비스 객체); 그들 사이에 상태 공유 시도 금지.

---

## 번들 파일

- `SKILL.md` — 워크플로 본문
- `references/` — 13개 reference 파일:
  - 공유: `base-capability.md`, `mobile-capabilities.md`
  - 기능별: `app-review.md`, `ar-space-capture.md`, `barcode-scanner.md`, `biometrics.md`, `calendar.md`, `contacts.md`, `document-scanner.md`, `geofencing.md`, `location.md`, `nfc.md`, `payments.md`

각 기능별 reference는 서비스 특화 TypeScript API(factory 함수, 서비스 인터페이스, options/result/error 타입)의 source of truth다.

---

## 관련 노트
- [[mobile-apps-create]]
- [[mobile-platform-offline-validate]]
