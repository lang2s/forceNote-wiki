---
tags: [lwc, security, lws, lightning-locker, migration, session-settings, distortion, procedure]
source: developer.salesforce.com (Security for Lightning Components — Enable LWS in an Org / When to Enable LWS / Delayed Enabling or Disabling / Evaluate JavaScript in LWS Console / Troubleshoot Issues / Debug with Distortions Disabled; 라이브 공식 문서, Tier 2, 접속 2026-07-08)
official_doc: https://developer.salesforce.com/docs/platform/lightning-components-security/guide/lws-enable.html
created: 2026-07-08
aliases: [LWS 활성화, LWS 활성화 절차, enable Lightning Web Security, Use Lightning Web Security for Lightning web components and Aura components, Locker to LWS migration, Locker 마이그레이션, LWS Console, distortion 디버깅, LWS 롤백, Session Settings LWS, LWS 호환성 테스트]
---

# LWS 활성화·Locker 마이그레이션 절차

> Setup의 Session Settings 토글 하나로 org 전체에 Lightning Web Security를 켜고, Locker에서 넘어올 때의 호환성 테스트·distortion 진단·롤백까지 다루는 실무 절차 노트.

---

## 1. 활성화 절차 (Setup → Session Settings)

LWS는 **org 단위 설정**이다. 컴포넌트별 설정이 아니라 org 전체(LWC + Aura 컴포넌트 모두)에 한 번에 적용된다.

```
1. Setup 진입
2. Quick Find 박스에 "Session" 입력 → Session Settings 선택
3. "Use Lightning Web Security for Lightning web components and Aura components" 체크
4. Save
5. 브라우저 캐시 삭제 (활성화·비활성화 후 필수 — 아래 4절 참조)
```

- **토글 정확 명칭:** `Use Lightning Web Security for Lightning web components and Aura components`
- **적용 범위:** org의 **모든 LWC와 Aura 컴포넌트**. 개별 컴포넌트 옵트인/아웃은 없다.
- **CSP 연동:** LWS는 보안을 완전히 구현하기 위해 Stricter CSP에 의존한다. LWS 사용 시 Content Security Policy 설정을 켠 상태로 유지하는 것이 권장된다.

### 조직 기본값 (신규 org vs 기존 org)

| org 유형 | LWS 기본 상태 |
|---|---|
| **신규 org** (Winter '23 이후 생성) | **기본 활성화** (enabled by default) |
| 템플릿에서 생성된 org | 템플릿의 LWS 설정을 상속 |
| **기존 org** (그 이전) | 과거엔 Lightning Locker가 기본. Summer '23에 LWS가 모든 org에 GA되어 위 토글로 전환 가능 |

---

## 2. 언제 켜야 하나 — 사전 판단

먼저 org에 어떤 컴포넌트가 있는지로 테스트 필요 여부를 판단한다.

| org 상태 | 조치 |
|---|---|
| 컴포넌트 없음 | 즉시 활성화 가능, 별도 테스트 불필요 |
| LWC만 있음 / Aura만 있음 | **샌드박스에서 먼저 테스트** 후 프로덕션 |
| Aura + LWC 둘 다 | **샌드박스에서 먼저 테스트** 후 프로덕션 |

권장 워크플로: **샌드박스 스테이징 환경에서 LWS를 먼저 켜고** → 컴포넌트가 정상 동작하는지 검증 → 문제없으면 프로덕션 전개. 사전 패키지/설치 컴포넌트가 있는 신규 org를 채울 계획이면, 그 전에 반드시 LWS 켠 샌드박스에서 테스트한다.

---

## 3. Locker → LWS 마이그레이션

### 3-1. 리팩터링은 대체로 불필요

기존 코드는 이미 Lightning Locker가 요구하던 보안 관행을 지키고 있으므로, LWS도 같은 관행을 요구한다 → **대부분의 기존 Lightning 컴포넌트는 LWS를 켜도 그대로 동작한다.** 즉 대량 리팩터링이 아니라 **호환성 테스트 + 소수의 distortion 대응**이 마이그레이션의 핵심이다.

### 3-2. 흔한 차이·distortion (Locker와 달라지는 지점)

LWS는 객체를 wrapper로 감싸지 않고, 네임스페이스별 **분리된 JavaScript 샌드박스**에서 실행하며 비보안 API만 **distortion**으로 선택적으로 수정한다. Locker에서 넘어올 때 자주 부딪히는 차이:

| 영역 | Locker에서 | LWS에서 (distortion 동작) |
|---|---|---|
| **global 객체** (`window`·`document`·`element`) | 접근 차단 | **접근 허용** (샌드박스 내). 서드파티 JS 라이브러리 호환성이 크게 향상 |
| **네임스페이스 격리** | wrapper 기반 | 네임스페이스별 분리 샌드박스. 다른 네임스페이스가 설정한 값은 **보이지 않음** (차단이 아니라 "빈 네임스페이스"를 보는 것) |
| **localStorage / sessionStorage** | — | **키를 네임스페이스로 파티셔닝.** 네임스페이스 밖에서 설정된 키 값은 접근 불가 (LWS가 네임스페이스 고유 키명을 생성) |
| **cookies** | — | getter는 **자기 샌드박스의 쿠키만** 반환, setter는 새 쿠키 키에 **샌드박스 prefix** 부여. 플랫폼 쿠키·타 네임스페이스 쿠키는 비가시 |
| **custom elements** | `customElements` 차단 | API를 virtualize해 네임스페이스 내 custom element 사용 허용 |
| **`eval()`** | global scope로 제한 | 차단하지 않고 샌드박스 distortion으로 비안전 활동 방지 |
| **Blob MIME 타입** | 허용 리스트 사용 | 같은 MIME 허용하되 **Blob 생성 시 MIME 타입 명시 필수** |
| **HTML/SVG** | — | LWS가 공유 DOM 요소의 HTML/SVG를 **sanitize** |

> distortion은 "API를 무조건 막는 것"이 아니다. 저장소를 네임스페이스로 분리하고, 공유 DOM의 HTML을 sanitize하고, 코드 평가를 샌드박스화하며, **샌드박스를 탈출할 수 있는 극소수 API만** 실제로 차단한다. "막혔다"고 보이는 대부분은 실제로는 빈 네임스페이스를 보고 있는 것이다.

### 3-3. 마이그레이션에서 자주 깨지는 증상

- 프로퍼티가 예기치 않게 `undefined` 반환
- static resource 내 비동기 함수가 일관되지 않게 동작
- 복제(cloned) 객체가 Locker와 다르게 동작
- 서드파티 라이브러리 / 애널리틱스 라이브러리 / Aura 엔드포인트 / global 변수 접근 관련 문제

---

## 4. 활성화/비활성화 지연 — 캐싱 주의

LWS를 켜거나 끈 직후 브라우저 캐시 때문에 **이전 환경이 계속 적용**되어 기대와 다르게 보일 수 있다(막혀야 할 게 열려 보이거나 그 반대).

```
① 기본: 브라우저 새로고침 + 캐시 수동 삭제
② 개발 중 반복 토글 시: DevTools > Network 패널 > "Disable Cache" 체크 (DevTools 열려 있는 동안 캐시 미사용)
③ 샌드박스/Developer Edition에서 지속되면:
   Setup > Session Settings > "Enable secure and persistent browser caching to improve performance" 체크 해제 → Save
```

> ⚠️ ③번(캐싱 비활성화)은 성능에 큰 영향을 주므로 **프로덕션에서는 반드시 다시 켠다.** 개발/테스트 org에서만 임시로 끈다.

---

## 5. LWS Console — 브라우저에서 사전 진단

org를 건드리기 전, LWS 시뮬레이션 환경에서 JavaScript 스니펫을 빠르게 검증하는 도구.

- **URL:** `https://developer.salesforce.com/tools/lws-console` (DX Developer Center / LWC Developer Center의 Tools 영역에도 있음)
- **동작:** 코드를 붙여넣고 LWS Enable/Disable 선택 → **Evaluate** 클릭 → LWS 하에서 실행 결과 표시. distortion이 실행을 막으면 그 distortion이 생성한 **에러 메시지를 그대로 보여준다.** 성공하면 `Success`만 표시(어떤 distortion이 적용됐는지는 표시 안 함).
- **한계:** org의 완전한 실행 환경을 재현하지 못한다 → **프로덕션 전 샌드박스 기능 테스트는 여전히 필수.** import/export 구문이나 LWC 데코레이터가 든 코드는 평가하지 못하고 **순수 JavaScript만** 평가한다.

---

## 6. distortion 플래그로 원인 진단 (실행 중 org)

실제 org에서 특정 distortion이 문제인지 확인하려면 브라우저 개발자 콘솔에서 distortion 플래그를 껐다 켜 본다.

```javascript
// 전제: org에서 해당 username에 debug mode 활성화

// 사용 가능한 네임스페이스 목록
$LWS.namespaces

// 기본 네임스페이스(c)의 distortion 플래그 목록
$LWS.namespaces.c.distortions

// 특정 플래그 현재 값 확인 (예: xhr)
$LWS.namespaces.c.distortions.xhr

// 의심되는 distortion 끄기
$LWS.namespaces.c.distortions.xhr = false

// 다시 켜기
$LWS.namespaces.c.distortions.xhr = true
```

- 문법: `$LWS.namespaces.<ns>.distortions.<flag>` (ns=네임스페이스, flag=distortion 플래그명)
- 모든 플래그 기본값은 `true`. **페이지를 새로고침하면 전부 기본값으로 리셋**된다.
- 워크플로: 코드에 breakpoint 설정 → 새로고침해 breakpoint 도달 → 멈춘 상태에서 의심 distortion을 `false`로 → 실행 재개하고 동작 변화 관찰.

---

## 7. 롤백 (다시 Locker로)

- **같은 토글로 비활성화한다:** Setup > Session Settings에서 `Use Lightning Web Security for Lightning web components and Aura components` **체크 해제** → Save.
- 비활성화 후에도 **브라우저 캐시 삭제**(4절과 동일)를 해야 이전(Locker) 환경이 즉시 반영된다.
- 마이그레이션이 막히면 스크래치 org에서 임시로 LWS를 끄는 것은 허용되나, **원인 해결 후 신속히 재활성화**하도록 안내된다.
- 참고: **Locker API Version 설정은 LWS에 무효**다 — LWS는 Locker의 버전 롤백 메커니즘을 쓰지 않는다(→ [[Lightning Web Security vs Lightning Locker]] 비교표).

---

## 8. 마이그레이션 테스트 체크리스트

```
□ org 컴포넌트 구성 파악 (없음 / LWC만 / Aura만 / 둘 다) → 테스트 필요 여부 결정
□ 샌드박스 스테이징 org에 LWS 먼저 활성화 (프로덕션 직접 금지)
□ 활성화 후 브라우저 캐시 삭제 (반복 테스트 시 DevTools Disable Cache)
□ 서드파티/애널리틱스 라이브러리 로드·동작 확인 (window/document 접근 경로)
□ localStorage·sessionStorage·cookie 의존 로직 확인 (네임스페이스 파티셔닝 영향)
□ Blob 생성 코드에 MIME 타입 명시했는지 확인
□ undefined 반환·cloned 객체·static resource 비동기 함수 회귀 점검
□ 의심 지점은 LWS Console(순수 JS) 또는 $LWS.namespaces distortion 플래그로 원인 격리
□ 정상 확인 후 프로덕션 전개 → 문제 시 같은 토글로 비활성화(롤백) + 캐시 삭제
```

---

## 관련 노트

- [[Lightning Web Security vs Lightning Locker]] — 두 아키텍처 9개 항목 비교(wrapper vs distortion, 개념 배경)
- [[LWC 보안 패턴]] — CSP·권한·DOM 등 LWC 보안 일반 패턴
- [[LWC MOC]]
