---
tags: [Admin, Security, Privacy, GDPR, CCPA, Consent, Individual, DataProtection, 개인정보, 동의관리]
source: help.salesforce.com — Data Protection and Privacy / Understand the Salesforce Consent Data Model / Fields in Data Privacy Records + developer.salesforce.com Object Reference (Individual, ContactPointConsent, ContactPointTypeConsent, AuthorizationForm) — Tier 2, 확인 2026-07-12
created: 2026-07-12
aliases: [Data Protection and Privacy, Individual object, Consent Management, 개인정보 보호, 동의 관리, ContactPointConsent, Right to be Forgotten, GDPR Salesforce, CCPA Salesforce]
---

# Data Protection & Privacy (개인정보 보호 · 동의 관리)

> Salesforce가 GDPR·CCPA 등 개인정보 규제 **대응을 돕기 위해** 제공하는 플랫폼 기능 — Individual 오브젝트로 개인의 프라이버시 선호를 저장하고, Consent 오브젝트군으로 채널·목적별 동의를 추적한다.

> [!note] 관점 한정 — 법률 조언 아님
> 이 노트는 **Salesforce 플랫폼 기능** 관점만 다룬다. 어떤 필드를 켜야 GDPR/CCPA를 "준수"하는지는 규제·법률 판단 영역이며 Salesforce도 이를 단정하지 않는다. 여기서는 "규제 대응을 위해 Salesforce가 제공하는 도구"만 설명한다. Setup 메뉴 라벨·필드 라벨은 릴리스에 따라 바뀔 수 있다(확인 기준 2026-07-12).

---

## 1. 개념 — Data Protection and Privacy 기능

Salesforce의 **Data Protection and Privacy**는 개인정보를 담은 레코드(Lead·Contact·Person Account 등)에 대해 개인의 데이터 프라이버시 선호를 **저장·추적**하고, 마케팅·처리·프로파일링 동의를 관리하도록 돕는 선언적 기능이다. 두 축으로 구성된다.

| 축 | 담는 것 | 핵심 오브젝트 |
|---|---|---|
| **Data Privacy (프라이버시 선호)** | 한 개인 전체에 적용되는 글로벌 선호 (추적 금지·처리 금지·삭제 요청 등) | `Individual` |
| **Consent Management (동의 관리)** | 채널·연락처·목적·양식 단위의 세분화된 동의 | `ContactPointTypeConsent`, `ContactPointConsent`, `DataUsePurpose`, `AuthorizationForm*` 등 |

### 활성화 — Make Data Protection Details Available in Records

레코드에서 데이터 프라이버시 상세를 사용하려면 조직 설정에서 기능을 켠다.

```
// 구조 예시 — 실제 Setup 네비게이션 경로 (라벨은 릴리스별 상이 가능)
Setup
 └─ Data Protection and Privacy   (빠른 찾기: "Data Protection")
     └─ Edit
         └─ ☑ Make data protection details available in records
             └─ Save
```

- 저장하면 이후 **Individual** lookup 필드를 Lead·Contact·Person Account **페이지 레이아웃**에 추가해 각 레코드에서 프라이버시 선호를 연결할 수 있다.
- Individual 탭을 사용자에게 노출하려면: `Setup → Profiles → (프로파일) → Object Settings → Individuals → Tab Settings → Default On → Save`.
- 이 기능은 Spring '18 릴리스에서 "Store Customers' Data Privacy Preferences"로 도입됐다.

---

## 2. Individual 오브젝트 — 개인 프라이버시 선호의 홈

**Individual**은 한 개인(person)의 데이터 프라이버시·보호 선호를 담는 **표준 오브젝트**다. Individual 레코드(= "Data Privacy Record")를 Lead·Contact·Person Account·User와 **lookup으로 연결**해, 그 사람과 소통할 때 참조할 글로벌 선호를 한곳에 보관한다. 커스텀 오브젝트를 포함해 개인정보를 담는 어떤 오브젝트에도 연결할 수 있다.

### 주요 필드 (Fields in Data Privacy Records)

공식 "Fields in Data Privacy Records"에 정의된 표준 필드 라벨과 확인된 API명:

| 필드 라벨 | 의미 | API명(확인분) |
|---|---|---|
| **Don't Process** | 이 개인의 데이터를 처리하지 않음 | `HasOptedOutProcessing` |
| **Don't Track** | 이 개인의 활동을 추적하지 않음 | `HasOptedOutTracking` |
| **Block Geolocation Tracking** | 위치정보 추적 차단 | `HasOptedOutGeoTracking` |
| **Forget this Individual** | 삭제(잊혀질 권리) 요청 표시 | `ShouldForget` |
| **Export Individual's Data** | 개인 데이터 내보내기(제3자 전달/이동성) 표시 | `SendIndividualData` |
| **Don't Profile** | 프로파일링 금지 선호 | (프로파일링 opt-out 필드) |
| **Don't Market** | 마케팅 대상 제외 선호 | (마케팅/권유 opt-out 필드) |
| **OK to Store PII Data Elsewhere** | PII를 외부에 저장해도 됨 | (PII 저장 허용 필드) |
| **Individual's Age** / **Individual's Age Verified** | 연령 및 연령 확인 여부(미성년자 동의 판단용) | (연령 필드) |

> 위 표에서 API명이 확인된 5개(`HasOptedOutProcessing`·`HasOptedOutTracking`·`HasOptedOutGeoTracking`·`ShouldForget`·`SendIndividualData`)는 오브젝트 레퍼런스로 실재 확인했다. 나머지 라벨은 공식 help의 필드 목록에 존재하나, 정확한 API명 1:1 매핑은 org 스키마(Setup → Object Manager → Individual → Fields)에서 확인할 것.

- 이 필드들은 **선호를 기록할 뿐**, 자동으로 처리를 차단하지 않는다. 실제 마케팅·자동화가 이 값을 존중하도록 만드는 것은 관리자·개발자(Flow·Apex·리스트뷰 필터 등)의 몫이다.

---

## 3. Consent Management — 동의 데이터 모델

Individual이 "개인 전체"의 글로벌 선호라면, **Consent 오브젝트군**은 **더 세분화된** 동의(어떤 채널로 · 어떤 연락처로 · 어떤 목적에 · 어떤 양식에 동의했는지)를 추적한다. Salesforce는 이를 **4계층**으로 설계했다.

```
// 구조 예시 — 실제 원본 ERD 다이어그램 아님 (동의 계층 개념도)
Individual ────────────────── (글로벌 선호: Don't Track / Don't Process ...)
   │  (선택) 개인 ↔ 동의 연결
   ▼
ContactPointTypeConsent ───── 채널 단위 동의 (Email 전체 / Phone 전체)
   │
   ▼
ContactPointConsent ───────── 특정 연락처 단위 동의 (work@x.com 은 OK, home@x.com 은 거부)
   │
   ▼
DataUsePurpose ────────────── 목적 단위 (뉴스레터 / 주문 알림 / 프로모션 ...)
        │
        └─ DataUseLegalBasis  목적별 처리의 법적 근거 기록

AuthorizationForm ─┬─ AuthorizationFormText  (약관·개인정보처리방침 버전 텍스트)
                   ├─ AuthorizationFormConsent (개인이 언제·어떻게 동의했는지)
                   └─ AuthorizationFormDataUse (양식 ↔ 데이터 사용 목적 연결)

BusinessBrand ─────────────── 멀티 브랜드 조직에서 브랜드별 동의 구분 (선택)
CommSubscription / CommSubscriptionConsent ── 구독(뉴스레터 등) 동의
```

### 3.1 Consent 오브젝트 레퍼런스

| 오브젝트 | 추적 대상 | 도입 API |
|---|---|---|
| **ContactPointTypeConsent** | **채널 타입** 단위 동의 (Email·Phone 등 유형 전체) | v45.0+ |
| **ContactPointConsent** | **특정 연락처**(개별 이메일/전화번호) 단위 동의 — 같은 사람이라도 연락처별로 다른 선호 반영 | v48.0+ |
| **ContactPointEmail / ContactPointPhone** | 개인의 이메일·전화 연락처 자체(동의를 붙일 대상) | — |
| **DataUsePurpose** | 커뮤니케이션 **목적/사유**별 동의 (예: 마케팅, 주문 확인). ContactPointTypeConsent·ContactPointConsent와 연결 | — |
| **DataUseLegalBasis** | 데이터 처리의 **법적 근거** 기록 | — |
| **PartyConsent** | 개인(party) 수준의 동의 결정 기록 | — |
| **AuthorizationForm** | 동의에 결부된 **양식의 버전·발효일**(개인정보처리방침, 약관 등) | v46.0+ |
| **AuthorizationFormConsent** | 개인이 **언제·어떻게** 그 양식에 동의했는지 | v46.0+ |
| **AuthorizationFormText** | 양식의 실제 **텍스트 버전** | v46.0+ |
| **AuthorizationFormDataUse** | 양식 ↔ 데이터 사용 목적 연결 | v46.0+ |
| **CommSubscription / CommSubscriptionConsent** | **구독**(뉴스레터 등)과 그 동의 | — |
| **BusinessBrand** | 멀티 브랜드 조직에서 브랜드별 프라이버시·동의 구분 (엄밀히는 동의 모델 외곽) | — |

### 3.2 핵심 필드 — PrivacyConsentStatus

`ContactPointConsent`·`ContactPointTypeConsent`의 핵심 필드는 **PrivacyConsentStatus**로, 개인의 동의 상태를 담는다.

| 필드 | 의미 |
|---|---|
| **PrivacyConsentStatus** | 동의 상태 — 확인된 값: **Opt In** / **Opt Out** (org·릴리스에 따라 Seen·Not Set 등 추가 상태 존재 가능; org 스키마에서 확인) |
| **ConsentCapturedDateTime** | 동의를 캡처한 일시 |
| **ConsentCapturedSource / SourceType** | 동의를 캡처한 위치·경로 |
| **EffectiveFrom / EffectiveTo** | 동의 발효·만료 일자 |
| **DataUsePurpose** (lookup) | 이 동의가 적용되는 목적 |
| **CaptureContactPointType** | 캡처된 연락처 타입 |

> PrivacyConsentStatus의 **정확한 picklist 값 전체**는 이번 소싱에서 공식 필드 레퍼런스 SPA가 렌더링되지 않아 Opt In / Opt Out 외 값을 전수 확정하지 못했다. org에서 `Setup → Object Manager → Contact Point Consent → Fields → Privacy Consent Status`로 값 목록을 확인할 것.

### 3.3 동의 조회·존중 (Consent API / Contact Point Filtering)

- 캡처한 동의는 위 오브젝트에 SOQL로 조회하거나, 마케팅·자동화 로직에서 참조해 발송 대상을 필터링한다(“Contact Point Filtering” 패턴).

```apex
// 구조 예시 — 실제 동작 코드 아님 (동의 조회 SOQL 개념)
// 특정 연락처의 이메일 채널 마케팅 목적 opt-in 여부 확인
List<ContactPointConsent> optIns = [
    SELECT Id, PrivacyConsentStatus, EffectiveFrom, EffectiveTo,
           ContactPointId, DataUsePurpose.Name
    FROM   ContactPointConsent
    WHERE  PrivacyConsentStatus = 'OptIn'
    AND    DataUsePurpose.Name = 'Marketing'
];
// 실제 필드/피클리스트 API 값은 org 스키마로 확인 후 사용
```

---

## 4. Right to be Forgotten — 데이터 삭제·익명화

GDPR "잊혀질 권리(Right to Erasure)"·CCPA "삭제 요청" 대응은 Salesforce에서 **표시 → 처리**의 2단계로 접근한다.

1. **표시(선언):** Individual 레코드의 **Forget this Individual**(`ShouldForget`) 필드를 체크해 삭제 요청 대상임을 기록한다. **Export Individual's Data**(`SendIndividualData`)는 데이터 이동성/내보내기 요청 표시에 쓴다.
2. **실제 처리(수동·기능적):** Salesforce는 이 표시를 근거로 **자동 하드삭제를 수행하지 않는다.** 관리자·개발자가 다음을 조합해 삭제·익명화를 실행한다.
   - 레코드 삭제(Delete) 또는 대량 삭제/이전 → [[Mass Transfer & Mass Delete (대량 이전·삭제)]]
   - 개인정보 필드를 익명값으로 덮어쓰기(익명화)
   - Data Loader·Flow·Apex로 관련 레코드 정리
   - 백업/내보내기에서의 제거 고려 → [[Data Export & Storage (데이터 내보내기·스토리지)]]

> ⚠️ 하드삭제(휴지통 비우기 포함)·권한 변경 등 되돌릴 수 없는 작업은 관리자가 직접 수행·검증해야 한다. Individual의 필드는 "요청됨"을 나타내는 **선언적 표시**일 뿐 실제 삭제 트리거가 아니다.

---

## 5. 범위 밖 — Shield 데이터 보호는 별개

암호화·감사 기반의 데이터 **보호**는 이 기능(Data Protection and Privacy)과 별개인 **Salesforce Shield** 영역이다.

- 저장 데이터 암호화 → [[Platform Encryption]] · [[민감 데이터 저장]]
- 필드 변경 이력 보존(단기) → [[Field History Tracking (필드 이력 추적)]] (장기 보존 Field Audit Trail은 Shield)

Data Protection and Privacy(동의·프라이버시 선호)와 Shield(암호화·감사)는 함께 쓰이지만, 활성화·라이선스·오브젝트가 서로 다르다.

---

## 관련 노트
- [[Platform Encryption]] — Shield 저장 데이터 암호화 (별개 기능)
- [[민감 데이터 저장]] — 민감 데이터 저장·보호 패턴
- [[Field History Tracking (필드 이력 추적)]] — 필드 변경 이력(감사)
- [[Mass Transfer & Mass Delete (대량 이전·삭제)]] — 삭제 요청 처리 시 대량 삭제
- [[Data Export & Storage (데이터 내보내기·스토리지)]] — 데이터 내보내기·이동성
- [[Core CRM Objects]] — Lead·Contact·Person Account(프라이버시 선호 연결 대상)
- [[Salesforce 어드민 종합 개요]] — 어드민 기능 허브
