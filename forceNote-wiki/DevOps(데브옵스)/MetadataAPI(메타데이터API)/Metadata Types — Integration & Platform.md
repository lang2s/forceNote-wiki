---
tags: [devops, metadata-api, metadata-types, named-credential, remote-site, connected-app, platform-event, settings, multi-currency, v67, v68]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types) + Winter27-v68-Docs/api_meta.pdf v68.0 Winter '27 (PREVIEW, 2026-08-21) pp.2082–2085
created: 2026-05-22
aliases: [NamedCredential 메타데이터, RemoteSiteSetting 메타데이터, PlatformEventChannel 메타데이터, ConnectedApp 메타데이터, 통합 플랫폼 메타데이터 타입, CurrencySettings, Currency 서브타입, enableMultiCurrency, corporateCurrency, 다중 통화 배포, 다중 통화 비가역, Currency.settings]
---

# Metadata Types — Integration & Platform

> NamedCredential, RemoteSiteSetting, ConnectedApp, PlatformEvent, InstalledPackage, Settings(CurrencySettings 포함) 등 통합·플랫폼 관련 메타데이터 타입.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 |
|---|---|
| AccountingFieldMapping | 회계 필드 매핑 (Data 360) |
| AccountingModelConfig | 회계 모델 설정 (Data 360) |
| AppFrameworkTemplateBundle | Data 360 및 Tableau Next 앱 프레임워크 템플릿 |
| BillingSettings | Salesforce Billing 설정 |
| CallCenter | CTI 시스템 연동 콜센터 |
| CallCenterRoutingMap | 콜센터 라우팅 맵 |
| CareBenefitVerifySettings | 보험 혜택 검증 설정 |
| CareSystemFieldMapping | 소스 시스템 → Salesforce 필드 매핑 |
| CatalogedApi | API Catalog 외부 API |
| CatalogedApiArtifactVersionInfo | API Catalog API 버전 정보 |
| CatalogedApiVersion | API Catalog 소비 가능 API 버전 |
| ChatterExtension | Rich Publisher App (Chatter) |
| ClaimFinancialSettings | 보험 청구 금융 서비스 설정 |
| CleanDataService | 표준 오브젝트 데이터 서비스 |
| CMSConnectSource | 외부 CMS 연결 정보 |
| CommerceSettings | Commerce 기능 설정 |
| ContextDefinition | Context Service 컨텍스트 정의 |
| ConversationMessageDefinition | Enhanced Messaging / MIAW 메시징 컴포넌트 |
| ConversationMessageDefinitionTranslation | 메시징 컴포넌트 번역 |
| ConversationVendorInfo | 파트너 벤더 시스템 연결 |
| DataObjectSearchIndexConf | Data 360 DMO 검색 인덱스 |
| DgtAssetMgmtProvider | 외부 DAM 시스템 통합 |
| DgtAssetMgmtPrvdLghtCpnt | DAM 시스템 LWC 설정 |
| EmbeddedServiceConfig | Embedded Service for Web 설정 |
| EmbeddedServiceFieldService | Appointment Management 임베디드 배포 |
| EmbeddedServiceFlowConfig | 임베디드 플로우 배포 |
| EmbeddedServiceLiveAgent | 임베디드 Chat 배포 |
| EmbeddedServiceMenuSettings | Channel 메뉴 배포 |
| EventDelivery | 이벤트 전달 매핑 (v46.0에서 삭제됨) |
| EventRelayConfig | 이벤트 릴레이 설정 (Amazon EventBridge) |
| EventSubscription | 이벤트 구독 (v46.0에서 삭제됨) |
| ExternalServiceRegistration | 외부 서비스 설정 |
| FeatureParameterBoolean | 기능 파라미터 Boolean (FMA) |
| FeatureParameterDate | 기능 파라미터 Date (FMA) |
| FeatureParameterInteger | 기능 파라미터 Integer (FMA) |
| GatewayProviderPaymentMethodType | 결제 게이트웨이 공급자 결제 방법 타입 |
| GoogleAppsSettings | Google Apps 설정 |
| InboundNetworkConnection | 서드파티 → Salesforce 인바운드 연결 |
| IndustriesPricingSettings | Salesforce Pricing 설정 |
| IndustriesRatingSettings | Rate Management 설정 |
| IndustriesUnifiedInventorySettings | Industries Unified Inventory 설정 |
| InstalledPackage | 1GP 관리 패키지 설치/제거 |
| IntegArtifactDef | Internal use only |
| IntegrationProviderDef | 서비스 프로세스 통합 정의 |
| LiveChatAgentConfig | Chat 에이전트 설정 |
| LiveChatButton | Chat 버튼 설정 |
| LiveChatDeployment | Chat 배포 설정 |
| ManagedEventSubscription | Pub/Sub API 관리 이벤트 구독 (Beta) |
| MarketingAppExtension | 서드파티 마케팅 앱 연동 |
| MessagingChannel | Embedded Service Messaging 채널 |
| MobileApplicationDetail | 모바일 연결 앱 패키징 속성 |
| NamedCredential | Named Credential |
| OcrSampleDocument | OCR 샘플 문서 |
| OcrTemplate | Intelligent Form Reader 매핑 |
| OmniSupervisorConfig | Omni-Channel 슈퍼바이저 설정 |
| OutboundNetworkConnection | Salesforce → 서드파티 아웃바운드 연결 |
| Package | 메타데이터 패키지 정의 |
| PaymentGatewayProvider | 결제 게이트웨이 공급자 |
| PlatformCachePartition | Platform Cache 파티션 |
| PlatformEventChannel | Platform Event 채널 |
| PlatformEventChannelMember | Change Data Capture 엔티티 선택 |
| PlatformEventMigration | 플랫폼 이벤트 마이그레이션 설정 |
| PlatformEventSubscriberConfig | 플랫폼 이벤트 Apex 트리거 설정 |
| PresenceDeclineReason | Omni-Channel 거부 사유 |
| PresenceUserConfig | Omni-Channel 현재 상태 사용자 설정 |
| RegisteredExternalService | 등록된 외부 서비스 |
| RemoteSiteSetting | 원격 사이트 설정 |
| ServiceChannel | Omni-Channel 작업 채널 |
| ServicePresenceStatus | Omni-Channel 현재 상태 |
| Settings | 조직 설정 |
| Skill | Field Service / Chat 라우팅 스킬 |
| VirtualVisitConfig | 외부 비디오 공급자 설정 |
| WebStoreBundle | Internal use only |
| WebStoreTemplate | Commerce Store 생성 설정 |
| WorkSkillRouting | Omni-Channel 스킬 라우팅 설정 |

---

## NamedCredential

Named Credential. 외부 엔드포인트 URL과 인증 파라미터를 하나의 정의로 통합.

**파일 경로:** `namedCredentials/CredentialName.namedCredential`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `allowMergeFieldsInBody` | boolean | - | 요청 본문에 병합 필드 허용 여부 |
| `allowMergeFieldsInHeader` | boolean | - | 요청 헤더에 병합 필드 허용 여부 |
| `authProvider` | string | - | 인증 공급자 이름 (OAuth 인증 시) |
| `authTokenEndpointUrl` | string | - | 토큰 엔드포인트 URL |
| `authenticateWithNamedPrincipal` | boolean | - | Named Principal 인증 여부 |
| `certificate` | string | - | 클라이언트 인증서 이름 |
| `endpoint` | string | Required | 외부 서비스 URL |
| `fullName` | string | - | Named Credential API 이름 |
| `generateAuthorizationHeader` | boolean | - | 인증 헤더 자동 생성 여부 |
| `jwtAudience` | string | - | JWT audience 값 |
| `jwtFormulaSubject` | string | - | JWT subject 수식 |
| `jwtIssuer` | string | - | JWT issuer |
| `jwtTextSubject` | string | - | JWT subject 텍스트 |
| `jwtValidityPeriodSeconds` | int | - | JWT 유효 기간 (초) |
| `label` | string | Required | 표시 레이블 |
| `oauthRefreshToken` | string | - | OAuth 리프레시 토큰 |
| `oauthScope` | string | - | OAuth 스코프 |
| `oauthToken` | string | - | OAuth 액세스 토큰 |
| `password` | string | - | 암호 (Password 인증 시) |
| `principalType` | ExternalPrincipalType (enum) | Required | `Anonymous` / `NamedUser` / `PerUser` |
| `protocol` | AuthenticationProtocol (enum) | Required | `NoAuthentication` / `Oauth` / `Password` / `Jwt` / `JwtExchange` / `AwsSv4` |
| `username` | string | - | 사용자 이름 |

---

## RemoteSiteSetting

원격 사이트 설정. Apex callout, XHR, Visualforce에서 외부 사이트 호출 전 등록 필요.

**파일 경로:** `remoteSiteSettings/SettingName.remoteSite`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `description` | string | - | 설명 |
| `disableProtocolSecurity` | boolean | - | HTTPS 프로토콜 보안 비활성화 여부 |
| `fullName` | string | - | 설정 이름 |
| `isActive` | boolean | Required | 활성화 여부 |
| `url` | string | Required | 원격 사이트 URL |

---

## PlatformEventChannel

Platform Event 채널. v46.0 이하: CDC 이벤트 기본 표준 채널. v47.0+: CDC 이벤트 커스텀 채널.

---

## PlatformEventChannelMember

CDC(Change Data Capture) 알림 엔티티 선택. 표준/커스텀 채널의 플랫폼 이벤트 선택.

---

## PlatformCachePartition

Platform Cache 파티션. `Metadata` 타입을 extends.

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `description` | string | - | 설명 |
| `fullName` | string | - | 파티션 이름 |
| `isDefaultPartition` | boolean | - | 기본 파티션 여부 |
| `masterLabel` | string | Required | 마스터 레이블 |
| `platformCachePartitionTypes` | PlatformCachePartitionType[] | - | 파티션 타입 목록 (Org / Session) |

---

## InstalledPackage

1GP 관리 패키지 설치/제거. 신규 버전 배포 시 업그레이드.

**주의:** 한 번에 최대 20개 1GP 패키지 설치. 2GP 설치는 `sf package install` CLI 사용.

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `activateRSS` | boolean | - | Remote Site Settings 자동 활성화 여부 |
| `fullName` | string | Required | 패키지 네임스페이스 프리픽스 |
| `password` | string | - | 패키지 설치 암호 |

---

## Settings

조직 설정 메타데이터. SecuritySettings(암호 정책, 세션 설정, 네트워크 접근), AccountSettings 등.

**파일 경로:** `settings/SettingName.settings`

**주의:** 와일드카드(`*`) 미지원. 개별 설정은 "Settings" 이름으로 package.xml에서 접근.

```xml
<!-- package.xml - 모든 Settings 검색 -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>Settings</name>
  </types>
  <version>60.0</version>
</Package>
```

```xml
<!-- package.xml - 개별 Setting 검색 (Security 이름 사용) -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>Security</members>
    <name>Settings</name>
  </types>
  <version>60.0</version>
</Package>
```

### CurrencySettings — 다중 통화 설정 (v68.0에서 대폭 확장)

> 출처: `Winter27-v68-Docs/api_meta.pdf` v68.0 Winter '27 (**PREVIEW**) pp.2082–2085.

조직의 **통화 설정** — 다중 통화 켜기, 활성 통화 구성, 법인(corporate) 통화 설정, 통화 유효일자(effective dates) 활성화. `Metadata` 타입을 extends하고 `fullName`을 상속한다.

**파일 경로:** `settings/Currency.settings` — package manifest에서는 다른 조직 설정과 마찬가지로 **`Settings` 이름**으로 접근한다 (`<members>Currency</members>` + `<name>Settings</name>`).

**Version 원문(p.2082):** *"CurrencySettings is available in API version 47.0 and later. The corporateCurrency and currency fields, and the deploy behavior for enableMultiCurrency, are available in API version 68.0 and later."*
→ 타입 자체는 v47.0부터, **`corporateCurrency`·`currency` 필드와 `enableMultiCurrency`의 배포 동작이 v68.0 신규**다.

#### Fields (pp.2082–2084)

| Field Name | Field Type | Description |
|---|---|---|
| `corporateCurrency` | string | **v68.0+.** org 법인 통화의 ISO 4217 코드(`USD`, `EUR` 등). 법인 통화의 환율은 **1.0으로 고정**되며 나머지 모든 통화가 이 통화를 기준으로 표시된다. 배포에서 이 필드를 설정하면 org의 법인 통화가 **전환**되어 기존 법인 통화가 강등되고 환율이 재기준화(rebase)된다. 새 법인 통화는 **이미 org에 등록돼 있고 active여야 한다.** `enableMultiCurrency`가 (이전에든 같은 배포에서든) `true`가 아니면 효과 없음 |
| `currency` | Currency[] | **v68.0+.** 하나 이상의 통화 엔트리. **새 통화는 삽입되고, `isoCode`로 기존 통화와 매칭되는 엔트리는 그 `active`·`scale`·`conversionRate` 값을 갱신**한다. `enableMultiCurrency`가 (이전에든 같은 배포에서든) `true`가 아니면 효과 없음 |
| `enableCurrencyEffectiveDates` | boolean | 유효일자 기반 통화(effective dated currency) 활성화 여부. 기본값 `false`. 이 설정을 켜려면 `enableMultiCurrency`가 `true`여야 한다 |
| `enableCurrencySymbolWithMultiCurrency` | boolean | 다중 통화 org에서 **통화 기호(`true`)** 를 표시할지 **ISO 코드(`false`)** 를 표시할지. 기본값 `false`. `enableMultiCurrency`가 `false`면 효과 없음 |
| `enableMultiCurrency` | boolean | 다중 통화 활성화 여부. 기본값 `false`. **API 68.0부터**, 다중 통화가 켜져 있지 않은 org에 `true`를 배포하면 **해당 org의 다중 통화가 켜진다.** 이미 켜져 있는 org에 `true`를 배포하면 no-op. 다중 통화가 켜질 때 법인 통화는 같은 배포에 `corporateCurrency`가 있으면 그 값에서 가져오고, 없으면 org의 **로케일 파생 통화**로 기본 설정된다 |
| `isMultiCurrencyActivationAllowed` | boolean | **API 49.0 이상에서 Deprecated.** 이 필드 값과 무관하게 Salesforce 관리자가 다중 통화를 활성화할 수 있다. API 48.0 이하에서는, Customizable Forecasting이 활성화된 경우 Salesforce Customer Support가 다중 통화를 활성화할 수 있는지(`true`) 아니면 기능을 활성화할 수 없는지(`false`)를 나타냈다. 이 필드는 다중 통화가 비활성일 때만 보이며, Customizable Forecasting이 켜진 상태에서 실수로 다중 통화를 켜는 것을 막는 추가 보호 장치로 기본값이 `false`였다. API 48.0 이하에서 org에 Customizable Forecasting이 켜진 고객은 다중 통화 활성화를 위해 Salesforce Customer Support에 문의해야 했고, Support가 요청 검증을 위해 요구할 때 이 필드를 `true`로 설정했다. ⓘ Customizable Forecasting은 **Summer '20에 은퇴**했다 — 사용자는 UI·API로 이 기능과 기반 데이터에 접근할 수 없으며, 파이프라인 기반 매출·수량 예측에는 Salesforce Forecasting을 쓴다 |
| `isParenCurrencyConvDisabled` | boolean | 괄호 통화 환산(parenthetical currency conversion) 비활성화 여부. **기본값 `true`.** `false`로 설정하면, 보고 있는 레코드의 통화와 개인 통화가 다른 사용자에게 Salesforce가 환산된 통화 금액을 표시한다 |

#### 🚨 다중 통화 전환은 되돌릴 수 없다 (p.2083 Important)

> PDF 원문: *"**Important:** Turning on multi-currency is irreversible. After you deploy `enableMultiCurrency=true`, the org can't return to single-currency operation through Metadata API. Deploying `enableMultiCurrency=false` against an org that has multi-currency enabled **returns an error**. See Considerations for Enabling Multiple Currencies for more information."*

| 상황 | 결과 |
|---|---|
| 다중 통화 **꺼진** org에 `true` 배포 | 다중 통화가 **켜진다** (v68.0+ 신규 배포 동작) |
| 다중 통화 **켜진** org에 `true` 배포 | **no-op** (아무 일도 일어나지 않음) |
| 다중 통화 **켜진** org에 `false` 배포 | **에러 반환** — 단일 통화로 되돌릴 수 없다 |

#### Currency 서브타입 (v68.0 신규, p.2084)

org의 **통화 타입 목록의 한 엔트리**를 나타낸다. `CurrencySettings.currency` 컬렉션의 **요소 타입**이다. *"Available in API version 68.0 and later."*

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `active` | boolean | Optional | 사용자가 이 통화를 레코드에 할당할 수 있는지(`true`) 여부. **비활성 통화는 법인 통화로 설정할 수 없다.** 새 통화는 기본값 `true` |
| `conversionRate` | double | 새 통화에는 Required | 이 통화 → 법인 통화 환율. 이 엔트리가 **법인 통화면 반드시 `1.0`** 이어야 한다 |
| `isoCode` | string | **Required** | 통화의 ISO 4217 코드(`USD`, `JPY`, `EUR` 등). **Salesforce가 지원하는 ISO 코드 중 하나여야 하며, 지원하지 않는 코드는 에러를 반환**한다 |
| `scale` | int | Optional | 이 통화에 사용할 소수 자릿수. 유효 값은 **0 ~ 6** |

#### Declarative Metadata 예시 (p.2084–2085 원문 발췌)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CurrencySettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <enableMultiCurrency>true</enableMultiCurrency>
    <corporateCurrency>USD</corporateCurrency>
    <currency>
        <isoCode>USD</isoCode>
        <active>true</active>
        <conversionRate>1.0</conversionRate>
        <scale>2</scale>
    </currency>
    <currency>
        <isoCode>JPY</isoCode>
        <active>true</active>
        <conversionRate>110.0</conversionRate>
        <scale>0</scale>
    </currency>
    <enableCurrencyEffectiveDates>false</enableCurrencyEffectiveDates>
    <enableCurrencySymbolWithMultiCurrency>false</enableCurrencySymbolWithMultiCurrency>
    <isParenCurrencyConvDisabled>false</isParenCurrencyConvDisabled>
</CurrencySettings>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>Currency</members>
        <name>Settings</name>
    </types>
    <version>47.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 기능 설정 메타데이터 타입에는 와일드카드가 **적용되지 않는다.** 와일드카드는 개별 설정이 아니라 **모든 설정을 retrieve할 때만** 적용된다 (p.2085).

---

## EventRelayConfig

이벤트 릴레이 설정. Salesforce → Amazon EventBridge로 플랫폼 이벤트 및 CDC 이벤트 릴레이.

---

## ExternalServiceRegistration

외부 서비스 설정. OpenAPI 스펙 등록으로 외부 REST API를 Flow/Apex에서 호출 가능하게 함.

---

## PlatformEventSubscriberConfig

플랫폼 이벤트 Apex 트리거 설정. 배치 크기, 실행 사용자 구성.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록
- [[Metadata Types — Security & Access]] — ConnectedApp, CspTrustedSite, CorsWhitelistOrigin
- [[Metadata API File-Based 호출]] — package.xml Settings 배포
- [[CI CD 패턴]] — 통합 타입 CI/CD 자동화
- [[2GP — Components - Integration & Platform]] — 같은 타입의 2GP 패키징 동작 (Manageability Rules·Editable Properties)
- [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]] — ExternalDataSource(Salesforce Connect adapter) 등 Knowledge 통합 메타데이터 타입 상세
- [[integration-eventing-cdc-configure]] (sf-skill — 실행형) — PlatformEventChannel(CDC) 메타데이터 구성 실행형 스킬
- [[Winter '27/Development]] — `CurrencySettings`의 `corporateCurrency`·`currency`·`Currency` 서브타입을 포함한 v68.0 Metadata API 변경 릴리즈 노트 원문
