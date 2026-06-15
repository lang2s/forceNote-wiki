---
tags: [release, summer_26, release-update]
api_version: v67.0
release_date: 2026-06
created: 2026-06-15
source: salesforce_summer26_release_notes.pdf (Salesforce Summer '26 Release Notes, Tier 2)
aliases: [Summer '26 Release Updates, 서머26 릴리즈 업데이트, 릴리즈 강제 적용 항목, v67 강제 적용, 강제 시점 Enforced, Release Update 일정, 서머26 의무화]
---

# Summer '26 — Release Updates (강제 적용 항목 + 시점 매핑)

> Summer '26(API v67.0) Release Update 전수와 강제 적용 시점. **이 노트가 모든 강제 시점 표의 단일 출처(authoritative)이며**, 다른 스포크는 여기로 링크한다.

> [!warning] Setup → Release Updates 페이지에서 각 항목을 강제 시점(Enforced) 이전에 반드시 적용·테스트하라. 강제일이 지나면 자동 적용되어 미준비 시 기능 중단·UI 동작 변경이 발생할 수 있다.

이 노트는 [[Summer '26]] 릴리즈의 Release Updates 스포크다. 코드를 동반하는 개발자 항목(예: Apex Batch 결과 정렬, `USER_MODE`)의 코드는 [[Summer '26/Development]]에, 보안·Admin 맥락은 [[Summer '26/Platform]]에 있다.

---

## Summer '26에 강제 적용됨 (지금 필수)

| 항목 | 영향 | 조치 |
|---|---|---|
| **접근성: Page Headers & Modal 200%+** | 고배율(200% 이상) 확대 시 Page Header·Modal 레이아웃 동작 변경 | 200%+ 배율에서 UI 검증 |
| **접근성: Date Pickers · Popovers · Utility Bars · Record Headers** | 고배율 확대 시 해당 컴포넌트 동작 변경 | 200%+ 배율에서 UI 검증 |
| **SAML 단일구성 → 다중구성 마이그레이션** | 마이그레이션 미완료 시 SSO 설정 중단 | 다중구성 SAML 프레임워크로 마이그레이션 |
| **X(Twitter) Auth Provider 폐기** | Salesforce-Managed X 인증 공급자 중단 → Twitter SSO 중단 | 커스텀 X 앱 생성 후 SSO 재구성 |
| **Sort Apex Batch Action Results by Request Order** | Apex Batch 액션 결과가 요청 순서대로 정렬됨 | 결과 순서에 의존하는 코드 확인 (→ [[Summer '26/Development]]) |
| **Apex `Blob.toPdf()` → Visualforce PDF 렌더링 서비스** | PDF 렌더링 방식 변경 | 생성된 PDF 출력 확인 (→ [[Summer '26/Development]]) |

---

## Winter '27 강제 예정

| 항목 | 준비 사항 |
|---|---|
| **Authorized Email Domains** | 이메일 변경 인증 예외를 Authorized Email Domains로 마이그레이션 |
| **접근성: Cards · Docked · Menu · Panels (200%+)** | 고배율 확대에서 해당 컴포넌트 동작 변경 대비 — 200%+ 테스트 |
| **Profile Filtering** | View All Profiles 권한이 필요한 사용자에게 미리 권한 부여 (→ [[Summer '26/Platform]]) |
| **Modify Transaction Security Policy 권한 분리** | Transaction Security Policy 수정 권한이 별도 권한으로 분리됨 — 담당자에게 권한 부여 |
| **OAuth 2.0 Username-Password Flow 폐기** | Username-Password Flow 사용 통합을 다른 OAuth 플로(JWT 등)로 전환 |
| **Update Instanced URLs in API Traffic** | 인스턴스 기반 URL(예: `na1.salesforce.com`)을 My Domain 기반 URL로 전환 |

---

## Spring '27 강제 예정

| 항목 | 준비 사항 |
|---|---|
| **접근성: To Do · Dual Listboxes (200%+)** | 고배율 확대에서 동작 변경 대비 — 200%+ 테스트 |
| **Aura Action 비공개 필드 제거** | Aura 액션 응답에서 비공개(private) 필드 제거 — 의존 코드 확인 |
| **Salesforce to Salesforce 은퇴** | S2S 기반 외부 조직 연동을 대체 통합으로 전환 |
| **SOAP `login()` 호출 (v31.0–64.0) 은퇴** | SOAP `login()` 대신 JWT 기반 액세스 토큰 사용 (→ [[Summer '26/Development]]) |
| **Sharing Recalculation 비동기 변경** | 공유 재계산이 비동기로 동작 — 재계산 완료 타이밍 의존 로직 확인 |

---

## Summer '27 강제 예정

| 항목 | 준비 사항 |
|---|---|
| **Block Apex Anonymous Code from Managed Packages** | 관리 패키지가 익명 Apex 실행에 의존하는 경우 대체 방식으로 전환 (→ [[Summer '26/Development]]) |

---

코드 동반 항목 참고 — `WITH SECURITY_ENFORCED`는 API v67.0에서 제거되었고 `WITH USER_MODE`로 교체해야 한다(Apex 개발자 변경 → [[Summer '26/Development]]).

```apex
// PDF 원문 발췌 — salesforce_summer26_release_notes.pdf
Account acc = [SELECT Id FROM Account WHERE Name = 'Singha' WITH USER_MODE LIMIT 1];
```

---

## 강제일 미정 (참고)

| 항목 | 내용 |
|---|---|
| **ICU Locale Formats** | ICU 로케일 형식으로 전환 — 강제 시점 미정, 로케일 의존 출력 검토 |
| **No-Argument Constructor on Invocable Params** | Invocable Action 파라미터 클래스에 무인자 생성자 요구 — 강제 시점 미정 (→ [[Summer '26/Development]]) |

---

## 관련 노트

- [[Summer '26]] — Summer '26 릴리즈 허브
- [[Summer '26/Development]] — 코드 동반 개발자 항목(Batch 결과 정렬·`Blob.toPdf`·SOAP `login()`·USER_MODE)
- [[Summer '26/Platform]] — Admin·Security 맥락(Profile Filtering·X Auth·SAML)
