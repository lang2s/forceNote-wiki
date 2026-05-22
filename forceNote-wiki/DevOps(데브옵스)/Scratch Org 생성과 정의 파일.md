---
tags: [devops, scratch-org, scratch-org-definition, dev-hub, features, editions, allocations, source-tracking]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 6
created: 2026-05-22
aliases: [Scratch Org 정의 파일, project-scratch-def.json, Scratch Org 생성, Scratch Org Features, edition, org create scratch]
---

# Scratch Org 생성과 정의 파일

> Scratch Org의 개념, Editions/Allocations, 생성 명령 전수, Definition File 옵션 전수, Features 전수 목록.

---

## Scratch Org란

- Dev Hub org에서 생성하는 disposable(일시적) 개발 org
- Source-driven 개발 전용으로 설계됨
- 수명: 최대 30일, 기본 7일. 만료 후 자동 삭제 (복구 불가)
- Source tracking 기본 활성화 (변경 사항을 로컬 ↔ org 간 자동 추적)
- 설정 파일(JSON)로 팀 전체에서 동일 환경 재현
- 코드, 메타데이터, 패키지, 샘플 데이터 설치 가능. 단, 개인 데이터 금지
- Scratch org는 sandbox 인스턴스에 생성됨 (Dev Hub 생성 시 사용된 국가 정보에 따라 인스턴스 결정)

### Scratch Org가 비어있는 이유

기본적으로 scratch org는 빈 상태로 생성됨. 일반 Developer Edition 등과 달리 아래 항목이 기본 포함되지 않음:
- Custom objects, fields, indexes, tabs, entity definitions
- Sample data, Sample Chatter feeds
- Dashboards and reports, Workflows, Picklists
- Profiles and permission sets
- Apex classes, triggers, pages

---

## Source Tracking

Source tracking이란 로컬 소스 파일과 org의 메타데이터 변경을 추적하고 양측을 동기화하는 기능.

- Scratch org에 기본 활성화
- `--no-track-source` 플래그로 생성 시 비활성화 가능 (로컬 설정만 영향, org 자체는 변경 없음)
- 로그아웃 후 재로그인 시 source tracking이 다시 활성화됨

Source tracking을 비활성화하기 좋은 시나리오:
- CI 스크립트에서 scratch org 생성 → 소스 배포 → 테스트 → 삭제 (단순 검증)
- 데모나 UAT, 디버깅용 scratch org
- 메타데이터 변경 없이 테스트 데이터만 바꾸는 경우
- 패키지 설치/검증용 scratch org
- 코드를 변경하지 않고 PR을 테스트할 때

---

## Supported Editions and Allocations

### Scratch Org Editions

| 값 | 설명 |
|---|---|
| `Developer` | 가장 일반적 |
| `Enterprise` | Enterprise 기능 포함 |
| `Group` | Group 에디션 |
| `Professional` | Professional 에디션 |
| `Partner Developer` | 파트너 전용 (파트너 비즈니스 org Dev Hub 필요) |
| `Partner Enterprise` | 파트너 전용 |
| `Partner Group` | 파트너 전용 |
| `Partner Professional` | 파트너 전용 |

스토리지 한도:
- 데이터: 500 MB
- 파일: 50 MB
- 메타데이터 타입으로 정의된 엔티티는 스토리지 계산에서 제외

### Dev Hub Edition별 Scratch Org 할당량

| Dev Hub Edition | 동시 활성 (Active) | 일 생성 (Daily) |
|---|---|---|
| Developer Edition / trial | 3 | 6 |
| Enterprise Edition | 40 | 80 |
| Unlimited Edition | 100 | 200 |
| Performance Edition | 100 | 200 |

- Active allocation: 특정 시점에 유지할 수 있는 최대 scratch org 수 (삭제/만료 시 해제)
- Daily allocation: 24시간 슬라이딩 윈도우 기준 최대 생성 수

할당량 확인:
```bash
sf limits api display --target-org <Dev Hub username or alias>
# 출력 예:
# Name                            Remaining  Max
# ──────────────────────────────  ─────────  ─────
# ActiveScratchOrgs               198        200
# DailyScratchOrgs                400        400

# 특정 scratch org의 한도 확인
sf limits api display --target-org <scratch org username or alias>
```

---

## Scratch Org Definition File (정의 파일)

Scratch org의 청사진(blueprint). org의 shape — edition, features, settings, licenses, limits를 정의.

### 파일 위치 및 이름

- CLI: 경로/이름 자유
- VS Code Extensions: 반드시 `config/` 폴더에 위치, 파일명 `*scratch-def.json`으로 끝나야 함
- 권장: `config/project-scratch-def.json` (팀 공용), 개별 파일 별도 생성 가능
- VCS에 커밋 권장

### Definition File 옵션 전수

| 필드명 | 필수 | 기본값 | 설명 |
|---|---|---|---|
| `orgName` | 아니오 | `Company` | 조직 이름 |
| `country` | 아니오 | Dev Hub 국가 | ISO-3166 2자리 대문자 코드 (예: US, KR). locale 설정에 영향 |
| `username` | 아니오 | `test-<unique_id>@example.com` | 자동 생성 |
| `adminEmail` | 아니오 | Dev Hub 사용자의 이메일 | scratch org 생성 요청한 Dev Hub 사용자 이메일 |
| `edition` | **필수** | 없음 | Developer / Enterprise / Group / Professional / Partner 변형들 |
| `description` | 아니오 | 없음 | 최대 2000자 자유 텍스트. Dev Hub의 Scratch Org Info에서 확인/수정 가능 |
| `hasSampleData` | 아니오 | `false` | `true`/`false`. 샘플 데이터 포함 여부 |
| `language` | 아니오 | 국가 기본 언어 | 기본 언어 코드 |
| `features` | 아니오 | 없음 | 활성화할 add-on features 배열 (상세는 아래 Features 섹션 참조) |
| `release` | 아니오 | Dev Hub와 동일 버전 | `preview` 또는 `previous` (릴리즈 전환 기간에만 사용) |
| `settings` | 아니오 | 없음 | Metadata API settings 블록. 상세는 `[[Scratch Org Settings 레퍼런스]]` |
| `objectSettings` | 아니오 | 없음 | 오브젝트별 공유 모델·기본 레코드 타입 설정 (패키지 설치 전 필요시) |
| `snapshot` | 아니오 | 없음 | 스냅샷 이름. 스냅샷 기반 생성 시 사용. `edition` 대신 사용 |
| `sourceOrg` | 아니오 | 없음 | 15자리 source org ID. Org Shape 기반 생성 시 사용 |
| `<custom_field__c>` | 아니오 | 없음 | ScratchOrgInfo 오브젝트의 커스텀 필드 API 명. DevOps 트래킹용 |

### objectSettings 상세

공유 모델과 기본 레코드 타입 설정. 일부 패키지 설치 전 필수.

```json
{
  "orgName": "MyCompany",
  "edition": "Developer",
  "objectSettings": {
    "opportunity": {
      "sharingModel": "private",
      "defaultRecordType": "default"
    },
    "account": {
      "defaultRecordType": "default"
    }
  }
}
```

**sharingModel 가능 값:**
- `private`
- `read`
- `readWrite`
- `readWriteTransfer`
- `fullAccess`
- `controlledByParent`
- `controlledByCampaign`
- `controlledByLeadOrContent`

`defaultRecordType` 값은 소문자 알파벳으로 시작하는 영숫자 문자열.

### ScratchOrgInfo 커스텀 필드 사용

```json
{
  "orgName": "MyCompany",
  "edition": "Developer",
  "workitem__c": "W-12345678",
  "release__c": "June 2024 pilot",
  "settings": {
    "omniChannelSettings": {
      "enableOmniChannel": true
    }
  }
}
```

커스텀 필드 생성 절차:
1. Dev Hub org → Setup → Object Manager → Scratch Org Info
2. Fields & Relationships → New → 필드 정의 → Save
3. 정의 파일에서 API 명으로 참조

---

## 샘플 정의 파일

```json
{
  "orgName": "Acme",
  "edition": "Enterprise",
  "features": ["Communities", "ServiceCloud", "Chatbot"],
  "settings": {
    "communitiesSettings": {
      "enableNetworksEnabled": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": true
    },
    "omniChannelSettings": {
      "enableOmniChannel": true
    },
    "caseSettings": {
      "systemUserEmail": "support@acme.com"
    }
  }
}
```

---

## Scratch Org 생성 명령 전수

### 기본 생성

```bash
# 정의 파일 사용, 별칭 지정, 기본 org로 설정
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --alias MyScratchOrg \
  --set-default \
  --target-dev-hub MyHub

# 정의 파일 옵션 일부를 CLI에서 오버라이드 (adminEmail, edition)
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --admin-email me@email.com \
  --edition developer

# 정의 파일 없이 edition만 지정
sf org create scratch --edition developer

# 스냅샷 기반 생성
sf org create scratch \
  --snapshot dhsnapshot \
  --wait 10 \
  --target-dev-hub MyHub

# Org Shape 기반 생성 (15자리 sourceOrg ID)
sf org create scratch --source-org 00DB1230000Ifx5

# 네임스페이스 없이 생성 (UAT/패키지 테스트용)
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --no-namespace \
  --duration-days 30

# Preview 릴리즈로 생성
sf org create scratch \
  --edition developer \
  --release preview

# 비동기 생성 (--async: 완료를 기다리지 않음)
sf org create scratch --edition developer --async
# 출력된 job ID로 상태 확인:
sf org resume scratch --job-id 2SRB0000CSqdJOAT

# Source tracking 비활성화
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --no-track-source
```

### 생성 진행 상황 출력 예시

```
────────────── Creating Scratch Org ──────────────
Prepare Request 11ms
Send Request    11.73s
Wait For Org    - Skipped
Available       12ms
Authenticate    1.51s
Deploy Settings 2.14s
Done            0ms
Request Id: 2SRWs000003y7mUOAQ
OrgId:      00DE200000DHqsM
Username:   test-lvsbbdryeaxn@example.com
Alias:      myscratch
Elapsed Time: 15.40s
Your scratch org is ready.
```

### Org 관리 명령

```bash
# 목록 확인
sf org list

# 브라우저에서 열기
sf org open --target-org MyScratchOrg

# 상세 정보
sf org display --target-org MyScratchOrg

# 삭제
sf org delete scratch --target-org MyScratchOrg --no-prompt

# Permission Set 할당
sf org assign permset --name MyPermSet --target-org MyScratchOrg
```

### 문제 해결용 SOQL (생성 실패 시)

```bash
sf data query \
  --query "SELECT ID, Name, Status FROM ScratchOrgInfo WHERE CreatedBy.Name = 'Jane Doe' AND CreatedDate = TODAY" \
  --target-org DevHub
```

---

## Release 전환 기간 처리

Salesforce는 연 3회 주요 릴리즈. 전환 기간에 preview/previous 지정 가능.

| Release | Preview Start | Preview End |
|---|---|---|
| Spring '26 | 2026-01-11 | 2026-02-21 |
| Summer '26 | 2026-05-10 | 2026-06-13 |
| Winter '27 | 2026-08-30 | 2026-10-10 |

| Dev Hub 버전 | `release: preview` 결과 | `release: previous` 결과 |
|---|---|---|
| 최신 버전으로 업그레이드됨 | 오류 (이미 최신) | 이전 버전 |
| 아직 GA 버전 | 다음 버전 (새 릴리즈) | 오류 (이전 버전 없음) |

```bash
# preview 릴리즈로 생성
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --alias PreviewOrg \
  --target-dev-hub DevHub \
  --release preview

# API 버전 맞추기
sf config set org-api-version 59.0 --global
# 또는
SF_ORG_API_VERSION=59.0 sf org create scratch --definition-file ... --release preview
```

---

## Scratch Org Features 전수 목록

Features는 대소문자 구분 없음. `<value>` 표시는 숫자 값 필요.

```json
"features": ["ServiceCloud", "API", "AuthorApex"]
```

| Feature | 설명 |
|---|---|
| `AccountInspection` | Account Intelligence view 활성화 (계정 메트릭·활동·관련 영업기회/케이스 대시보드) |
| `AccountingSubledgerGrowthEdition` | Accounting Subledger Growth 기능 권한 세트 3개 제공 |
| `AccountingSubledgerStarterEdition` | Accounting Subledger Starter 기능 권한 세트 3개 제공 |
| `AccountingSubledgerUser` | 패키지 설치 시 Accounting Subledger Growth 조직 전체 접근 활성화 |
| `AddCustomApps:<value>` | 커스텀 앱 최대 수 증가. 값 범위: 1–30 |
| `AddCustomObjects:<value>` | 커스텀 오브젝트 최대 수 증가. 값 범위: 1–30 |
| `AddCustomRelationships:<value>` | 오브젝트당 커스텀 관계 최대 수 증가. 값 범위: 1–10 (배수: 5) |
| `AddCustomTabs:<value>` | 커스텀 탭 최대 수 증가. 값 범위: 1–30 |
| `AddDataComCRMRecordCredit:<value>` | 사용자당 레코드 임포트 크레딧 증가. 값 범위: 1–30 |
| `AddInsightsQueryLimit:<value>` | CRM Analytics 쿼리 결과 크기 증가. 값 범위: 1–30 (배수: 10) |
| `AdditionalFieldHistory:<value>` | 히스토리 추적 필드 수 증가 (기본 20개 초과분). 값 범위: 1–40 |
| `AdmissionsConnectUser` | Admissions Connect 컴포넌트 활성화 |
| `AdvisorLinkFeature` | Student Success Hub 컴포넌트 활성화 |
| `AdvisorLinkPathwaysFeature` | Pathways 컴포넌트 활성화 |
| `AIAttribution` | Marketing Cloud Account Engagement용 Einstein Attribution 접근 |
| `AllUserIdServiceAccess` | 모든 사용자가 user ID 서비스를 통해 모든 사용자 정보 접근 |
| `AnalyticsAdminPerms` | CRM Analytics 플랫폼 관리에 필요한 모든 권한 활성화 |
| `AnalyticsAppEmbedded` | CRM Analytics Embedded App 라이선스 1개 제공 |
| `ApexGuruCodeAnalyzer` | ApexGuru의 생성형 AI 기반 런타임 인사이트(Code Analyzer) 활성화 |
| `ApexIntegrationTests` (Developer Preview) | Agentforce/Data 360 callout을 허용하는 엔드-투-엔드 Apex 테스트 활성화 |
| `API` | Professional/Group 에디션에서 추가 API(SOAP·Streaming·Bulk·Bulk 2.0) 접근 |
| `ArcGraphCommunity` | Experience Cloud 페이지에 ARC 컴포넌트 추가 가능 |
| `Assessments` | 동적 Assessments 기능 활성화 (Assessment Questions·Assessment Question Sets) |
| `AssetScheduling:<value>` | Asset Scheduling 라이선스. 값 범위: 1–10 |
| `AssociationEngine` | Association Engine 활성화 (신규 계정을 현재 지점에 자동 연결) |
| `AuthorApex` | Apex 코드 접근/수정 활성화. Enterprise/Developer 에디션 기본 활성화. Group/Professional은 기본 비활성 |
| `B2BCommerce` | B2B Commerce 라이선스 제공 |
| `B2BLoyaltyManagement` | B2B Loyalty Management 라이선스 활성화 |
| `B2CCommerceGMV` | B2B2C Commerce 라이선스 제공 |
| `B2CLoyaltyManagement` | Loyalty Management - Growth 라이선스 활성화 |
| `B2CLoyaltyManagementPlus` | Loyalty Management - Advanced 라이선스 활성화 |
| `BatchManagement` | Batch Management 라이선스 활성화 |
| `BenefitManagement` | Public Sector Solutions 혜택 관리 오브젝트·기능·권한 활성화 |
| `BigObjectsBulkAPI` | BigObjects에서 Bulk API 사용 활성화 |
| `BillingAdvanced` | Revenue Cloud Billing 라이선스 기능·오브젝트 접근 |
| `Briefcase` | Briefcase Builder 사용 활성화 (오프라인 레코드 접근) |
| `BudgetManagement` | 예산 관리 기능·오브젝트 접근 |
| `BusinessRulesEngine` | Business Rules Engine 활성화 (expression sets·lookup tables). Designer/Runtime 라이선스 10개씩 제공 |
| `BYOCCaaS` | CCaaS 파트너 연락 센터 설정/테스트 활성화 (`ServiceCloud` + `Scrt2Conversation` 함께 필요) |
| `BYOOTT` | Bring Your Own Channel for Messaging 활성화 (`ServiceCloud` + `Scrt2Conversation` 함께 필요) |
| `CacheOnlyKeys` | Cache-Only Key Service 활성화 (키 외부 저장) |
| `CalloutSizeMB:<value>` | Apex callout 최대 크기 증가. 값 범위: 3–12 MB |
| `CampaignInfluence2` | Customizable Campaign Influence 접근 (Sales Cloud·Marketing Cloud Account Engagement) |
| `CascadeDelete` | lookup 관계에 master-detail 수준 cascading delete 제공 |
| `CaseClassification` | Einstein Case Classification 활성화 |
| `CaseWrapUp` | Einstein Case Wrap-Up 활성화 |
| `CGAnalytics` | Consumer Goods Analytics org 권한 활성화 |
| `ChangeDataCapture` | Change Data Capture 활성화 (에디션이 자동 활성화하지 않는 경우) |
| `Chatbot` | Bot 메타데이터 배포·봇 생성/편집 활성화. Dev Hub에서 Enable Einstein Features 필요 |
| `ChatterEmailFooterLogo` | Chatter 이메일에 로고 이미지(Document ID) 사용 |
| `ChatterEmailFooterText` | Chatter 이메일 푸터 텍스트 커스터마이즈 |
| `ChatterEmailSenderName` | Chatter 이메일 발신자 이름 커스터마이즈 |
| `CloneApplication` | 기존 Lightning 앱 복제 후 커스터마이즈 |
| `CMSMaxContType` | Salesforce CMS 콘텐츠 타입 최대 수를 21로 제한 |
| `CMSMaxNodesPerContType` | 콘텐츠 타입당 자식 노드(필드) 최대 수를 15로 제한 |
| `CMSUnlimitedUse` | Salesforce CMS 콘텐츠 레코드·콘텐츠 타입·대역폭 무제한 |
| `Communities` | Experience Cloud 사이트 생성 허용. `communitiesSettings > enableNetworksEnabled: true` 설정 함께 필요 |
| `CompareReportsOrgPerm` | Lightning Reports 비교 org 권한 활성화 |
| `ConAppPluginExecuteAsUser` | ConnectedApp 메타데이터의 `pluginExecutionUser` 필드 활성화 |
| `ConcStreamingClients:<value>` | API v36.0 이하 전체 채널 동시 클라이언트 최대 수 증가. 범위: 20–4,000 |
| `ConnectedAppCustomNotifSubscription` | Connected app이 커스텀 알림 타입 구독 가능 |
| `ConnectedAppToolingAPI` | Connected app과 Tooling API 함께 사용 |
| `ConsentEventStream` | Consent Event Stream 권한 활성화 |
| `ConsolePersistenceInterval:<value>` | 콘솔 데이터 자동 저장 주기(분). 범위: 0–500. 0은 자동 저장 비활성 |
| `ContactsToMultipleAccounts` | 하나의 연락처를 여러 계정에 연결 |
| `ContractApprovals` | 계약 승인 프로세스 추적 |
| `ContractManagement` | Contract Lifecycle Management 기능 활성화 |
| `ContractMgmtInd` | Industries용 CLM 기능 활성화 |
| `CoreCpq` | Revenue Cloud 기능·오브젝트 읽기/쓰기 접근 (`revenueManagementSettings > enableCoreCPQ` 필요) |
| `CPQ` | Salesforce CPQ 관리 패키지 설치에 필요한 라이선스 활성화 (패키지 자동 설치 아님) |
| `CustomerDataPlatform` | CustomerDataPlatform 라이선스 활성화 |
| `CustomerDataPlatformLite` | Data Cloud 라이선스 활성화 (`CustomerDataPlatform` 피처 + `enableCustomerDataPlatform` 설정 함께 필요) |
| `CustomerExperienceAnalytics` | Customer Lifecycle Analytics org 권한 활성화 |
| `CustomFieldDataTranslation` | Work Type Group·Service Territory·Service Resource 오브젝트 커스텀 필드 데이터 번역 |
| `CustomNotificationType` | 커스텀 알림 타입 생성 (데스크탑·모바일 알림) |
| `DataComDnbAccounts` | Data.com 계정 기능 라이선스 |
| `DataComFullClean` | Data.com 데이터 정제 기능 라이선스 |
| `DataMaskUser` | Data Mask 권한 세트 라이선스 30개 제공 |
| `DataProcessingEngine` | Data Processing Engine 라이선스 (데이터 변환·기록 작성) |
| `DebugApex` | Apex Interactive Debugger 활성화 (브레이크포인트·체크포인트) |
| `DecisionTable` | Decision Table 라이선스 (비즈니스 규칙 기반 결과 결정) |
| `DefaultWorkflowUser` | Scratch org 어드민을 기본 워크플로 사용자로 설정 |
| `DeferSharingCalc` | 어드민이 그룹 멤버십·공유 규칙 계산을 일시 중지/재개 |
| `DevelopmentWave` | CRM Analytics 개발 활성화. 플랫폼 라이선스 5개·CRM Analytics 플랫폼 라이선스 5개 할당 |
| `DeviceTrackingEnabled` | Device Tracking 활성화 |
| `DevOpsCenter` | 파트너가 DevOps Center를 확장하는 2GP 관리 패키지 생성 |
| `DisableManageIdConfAPI` | LoginIP·ClientBrowser API 오브젝트 접근을 보기/삭제만으로 제한 |
| `DisclosureFramework` | Disclosure and Compliance Hub 구성을 위한 권한 세트 라이선스 제공 |
| `Division` | Manage Divisions 기능 활성화 (데이터를 논리 섹션으로 분리) |
| `DocGen` | Document Generation 기능 활성화 |
| `DocGenDesigner` | 문서 템플릿 생성/구성을 위한 디자이너 기능 |
| `DocGenInd` | Industries Document Generation 기능 활성화 |
| `DocumentChecklist` | Document Tracking and Approval 기능 활성화 |
| `DocumentReaderPageLimit` | 데이터 추출을 위한 최대 페이지 수를 5로 제한 |
| `DSARPortability` | Privacy Center의 DSARPortability 기능 접근 |
| `DurableClassicStreamingAPI` | API v37.0 이상에서 Durable PushTopic Streaming API 활성화 |
| `DurableGenericStreamingAPI` | API v37.0 이상에서 Durable Generic Streaming API 활성화 |
| `DynamicClientCreationLimit` | 동적 클라이언트 등록 엔드포인트를 통해 최대 100개 OAuth 2.0 connected app 등록 |
| `EAndUDigitalSales` | Energy and Utilities Digital Sales 기능 활성화 |
| `EAndUSelfServicePortal` | Digital Experience 사용자를 위한 Self Service Portal 기능 활성화 |
| `EAOutputConnectors` | CRM Analytics Output Connectors 활성화 |
| `EASyncOut` | CRM Analytics SyncOut 활성화 |
| `EdPredictionM3Threshold` | Einstein Discovery 예측에서 M3 사용 페이로드 레코드 수를 10으로 설정 |
| `EdPredictionTimeout` | Einstein Discovery 예측 최대 지속 시간 100밀리초로 설정 |
| `EdPredictionTimeoutBulk` | 대량 실행 시 Einstein Discovery 예측 최대 지속 시간 10밀리초로 설정 |
| `EdPredictionTimeoutByomBulk` | BYOM Einstein Discovery 예측 최대 지속 시간 100밀리초로 설정 |
| `EducationCloud:<value>` | Education Cloud 사용 활성화 |
| `Einstein1AIPlatform` | Agentforce·Prompt Builder·Model Builder·Models API 등 생성형 AI 기능 접근 (`einsteinGptSettings > enableEinsteinGptPlatform` 설정 필요) |
| `EinsteinAnalyticsPlus` | CRM Analytics Plus 라이선스 1개 제공 |
| `EinsteinArticleRecommendations` | Einstein Article Recommendations 라이선스 제공 |
| `EinsteinBuilderFree` | Einstein Prediction Builder로 1개 예측 생성 허용 |
| `EinsteinDocReader` | Intelligent Form Reader 라이선스 (Amazon Textract 기반 OCR) |
| `EinsteinRecommendationBuilder` | Einstein Recommendation Builder 라이선스 |
| `EinsteinSalesRepFdbk` | Agentforce Sales Coach 기능 + Einstein for Sales 생성형 AI 기능 다수 활성화 |
| `EinsteinSearch` | Einstein Search 기능 라이선스 |
| `EinsteinVisits` | Consumer Goods Cloud 활성화 |
| `EinsteinVisitsED` | Einstein Discovery를 사용한 매장 방문 추천 |
| `EmbeddedLoginForIE` | IE11에서 Embedded Login을 지원하는 JavaScript 파일 제공 |
| `EmpPublishRateLimit:<value>` | 시간당 표준 볼륨 플랫폼 이벤트 알림 최대 발행 수 증가. 범위: 1,000–10,000 |
| `EnablePRM` | 파트너 관계 관리 권한 활성화 |
| `EnableManageIdConfUI` | UI에서 LoginIP·ClientBrowser API 오브젝트 접근 활성화 |
| `Enablement` | Enablement 기능 활성화 (영업 프로그램 생성·수강·추적) |
| `EnableSetPasswordInApi` | 이전 비밀번호 없이 `sf org generate password`로 비밀번호 변경 가능 |
| `EncryptionStatisticsInterval:<value>` | 암호화 통계 수집 주기(초) 정의. 최대 604,800초(7일), 기본 86,400초(24시간) |
| `EncryptionSyncInterval:<value>` | 활성 키 재료와 데이터 동기화 주기(초) 정의. 기본/최대 604,800초(7일) |
| `EnergyAndUtilitiesCloud` | Energy and Utilities Cloud 기능 활성화 |
| `Entitlements` | Entitlements 활성화 (고객 지원 단위, 서비스 계약 조건) |
| `ERMAnalytics` | ERM Analytics org 권한 활성화 |
| `EventLogFile` | org 이벤트 로그 파일 API 접근 활성화 |
| `EntityTranslation` | Work Type Group·Service Territory·Service Resource 필드 데이터 번역 |
| `ExcludeSAMLSessionIndex` | SAML SSO·SLO 흐름에서 Session Index 제외 |
| `Explainability` | Decision Explainer 기능 활성화 |
| `ExpressionSetMaxExecPerHour` | Connect REST API로 시간당 최대 500,000 expression set 실행 |
| `ExternalIdentityLogin` | External Identity 라이선스와 관련된 Salesforce Customer Identity 기능 |
| `FieldAuditTrail` | Field Audit Trail 활성화. 총 60개 필드 추적 (기본 20 + 추가 40) |
| `FieldService:<value>` | Field Service 라이선스. 범위: 1–25 |
| `FieldServiceAppointmentAssistantUser:<value>` | Field Service Appointment Assistant 권한 세트 라이선스. 범위: 1–25 |
| `FieldServiceDispatcherUser:<value>` | Field Service Dispatcher 권한 세트 라이선스. 범위: 1–25 |
| `FieldServiceLastMileUser:<value>` | Field Service Last Mile 권한 세트 라이선스. 범위: 1–25 |
| `FieldServiceMobileExtension` | Field Service Mobile Extension 권한 세트 라이선스 |
| `FieldServiceMobileUser:<value>` | Field Service Mobile 권한 세트 라이선스. 범위: 1–25 |
| `FieldServiceSchedulingUser:<value>` | Field Service Scheduling 권한 세트 라이선스. 범위: 1–25 |
| `FinanceLogging` | Finance Logging 오브젝트 추가 (Finance Logging 필수) |
| `FinancialServicesCommunityUser:<value>` | Financial Services Insurance Community 권한 세트 라이선스. 범위: 1–10 |
| `FinancialServicesInsuranceUser` | Financial Services Insurance 권한 세트 라이선스 |
| `FinancialServicesUser:<value>` | Financial Services Cloud Standard 권한 세트 라이선스. 범위: 1–10 |
| `FlowSites` | Salesforce Sites·고객 포털에서 Flow 사용 |
| `ForceComPlatform` | Salesforce Platform 사용자 라이선스 1개 추가 |
| `ForecastEnableCustomField` | 영업기회 기반 예측에서 커스텀 통화·숫자 필드 사용 |
| `FSCAlertFramework` | Financial Services Cloud Record Alert 엔티티 접근 |
| `FSCServiceProcess` | Financial Service Cloud의 Service Process Studio 기능 활성화 |
| `Fundraising` | Nonprofit Cloud Fundraising 기능·오브젝트 접근 |
| `GenericStreaming` | API v36.0 이하 Generic Streaming API 활성화 |
| `GenStreamingEventsPerDay:<value>` | API v36.0 이하 24시간 Generic Streaming 이벤트 최대 수 증가. 범위: 10,000–50,000 |
| `Grantmaking` | Grantmaking 기능·오브젝트 접근 (Salesforce·Experience Cloud) |
| `GuidanceHubAllowed` | Lightning Experience Guidance Center 패널 활성화 |
| `HealthCloudAddOn` | Health Cloud 사용 활성화 |
| `HealthCloudEOLOverride` | 은퇴한 Health Cloud CandidatePatient 오브젝트 재접근 허용 |
| `HealthCloudForCmty` | Experience Cloud Sites용 Health Cloud 활성화 |
| `HealthCloudMedicationReconciliation` | Medication Management에서 Medication Reconciliation 지원 |
| `HealthCloudPNMAddOn` | Provider Network Management 활성화 |
| `HealthCloudUser` | Health Cloud 권한 세트 라이선스 1명 상당의 기능 |
| `HighVelocitySales` | Sales Engagement 라이선스 + Salesforce Inbox 활성화 |
| `HighVolumePlatformEventAddOn` | 고볼륨 플랫폼 이벤트/CDC 이벤트 일일 할당량 100,000건 증가 |
| `HLSAnalytics` | HLS Analytics org 권한 활성화 |
| `HoursBetweenCoverageJob:<value>` | 공유 상속 커버리지 보고서 실행 주기(시간). 범위: 1–24 |
| `IdentityProvisioningFeatures` | Salesforce Identity User Provisioning 활성화 |
| `IgnoreQueryParamWhitelist` | URL 쿼리 파라미터 필터 규칙 허용 목록 무시 |
| `IndustriesActionPlan` | Action Plans 라이선스 (비즈니스 프로세스 완료를 위한 작업/문서 체크리스트) |
| `IndustriesBranchManagement` | Financial Services Cloud Branch Management 활성화 |
| `IndustriesCompliantDataSharing` | 참여자 관리 및 데이터 공유 고급 구성 접근 |
| `IndustriesMfgAdvncdAccFrcs` | Advanced Account Forecasting 활성화 |
| `IndustriesMfgPartnerVisitMgmt` | Partner Visit Management 활성화 |
| `IndustriesMfgProgram` | Program Based Business 활성화 |
| `IndustriesMfgRebates` | Rebate Management 활성화 |
| `IndustriesMfgTargets` | Sales Agreements 활성화 |
| `IndustriesManufacturingCmty` | Manufacturing Sales Agreement for Community 권한 세트 라이선스 |
| `IndustriesMfgAccountForecast` | Account Forecast 활성화 |
| `InsightsPlatform` | CRM Analytics Plus 라이선스 활성화 |
| `InsuranceCalculationUser` | Insurance 계산 기능 활성화 |
| `InsuranceClaimMgmt` | 클레임 관리 기능 활성화 |
| `InsurancePolicyAdmin` | 보험 정책 관리 기능 활성화 |
| `IntelligentDocumentReader` | Intelligent Document Reader 라이선스 (Amazon Textract + AWS 계정) |
| `InvestigativeCaseManagement` | Public Sector Solutions 수사 케이스 관리 기능 활성화 |
| `InvoiceManagement` | Revenue Cloud Advanced 라이선스 기능·오브젝트 접근 |
| `Interaction` | Flow 활성화 (screen flows, autolaunched flows) |
| `InvocableActionExt` | InvocableActionExtension 메타데이터로 Apex invocable action 입력 커스터마이즈 |
| `IoT` | IoT 활성화 (플랫폼 이벤트 소비·오케스트레이션·컨텍스트) |
| `JigsawUser` | Jigsaw 기능 라이선스 1개 |
| `Knowledge` | Salesforce Knowledge 활성화 (지식 베이스, 아티클) |
| `LegacyLiveAgentRouting` | Chat용 Legacy Live Agent 라우팅 활성화 (Salesforce Classic) |
| `LightningSalesConsole` | Lightning Sales Console 사용자 라이선스 1개 추가 |
| `LightningScheduler` | Lightning Scheduler 활성화 (예약 관리) |
| `LightningServiceConsole` | Lightning Service Console 라이선스 할당 |
| `LiveAgent` | Service Cloud용 Chat 활성화 |
| `LiveMessage` | Service Cloud용 Messaging 활성화 (SMS·Facebook Messenger 등) |
| `LongLayoutSectionTitles` | 페이지 레이아웃 섹션 제목 최대 80자 허용 |
| `LoyaltyAnalytics` | Analytics for Loyalty 라이선스 활성화 |
| `LoyaltyEngine` | Loyalty Management Promotion Setup 라이선스 활성화 |
| `LoyaltyManagementStarter` | Loyalty Management - Starter 라이선스 활성화 |
| `LoyaltyMaximumPartners:<value>` | Loyalty Management Starter org의 파트너 최대 수. 기본/최대: 1 |
| `LoyaltyMaximumPrograms:<value>` | Loyalty Management Starter org의 프로그램 최대 수. 기본/최대: 1 |
| `LoyaltyMaxOrderLinePerHour:<value>` | 시간당 Loyalty 프로세스가 처리하는 주문 라인 최대 수. 범위: 1–3,500,000 |
| `LoyaltyMaxProcExecPerHour:<value>` | 시간당 Loyalty 프로세스가 처리하는 트랜잭션 저널 최대 수. 범위: 1–500,000 |
| `LoyaltyMaxTransactions:<value>` | 처리 가능한 Transaction Journal 레코드 최대 수. 범위: 1–50,000,000 |
| `LoyaltyMaxTrxnJournals:<value>` | Loyalty Management Starter org에 저장되는 Transaction Journal 레코드 최대 수 |
| `Macros` | Macros 활성화 (Lightning Console에서 반복 작업 자동화) |
| `MarketingCloud` | Marketing Cloud Growth 에디션 라이선스. 하루 20통 이메일 발송 가능 |
| `MarketingUser` | Campaigns 오브젝트 편집 접근 |
| `MaterialityAssessment` | Net Zero Cloud의 materiality assessment 구성 권한 세트 라이선스 |
| `MaxActiveDPEDefs:<value>` | 활성화 가능한 Data Processing Engine 정의 최대 수 증가. 범위: 1–50 |
| `MaxApexCodeSize:<value>` | 비테스트 비관리 Apex 코드 크기 제한(MB). 기본 10MB 초과 시 Salesforce 지원 필요 |
| `MaxAudTypeCriterionPerAud` | 대상별 최대 audience type 기준 수. 기본값: 10 |
| `MaxCustomLabels:<value>` | 커스텀 레이블 최대 수(천 단위). 값 10 = 10,000개. 범위: 1–15 |
| `MaxDatasetLinksPerDT:<value>` | Decision Table당 데이터셋 링크 최대 수. 범위: 1–3 |
| `MaxDataSourcesPerDPE:<value>` | Data Processing Engine 정의 내 Source Object 노드 최대 수. 범위: 1–50 |
| `MaxDecisionTableAllowed:<value>` | org에서 생성 가능한 Decision Table 규칙 최대 수. 범위: 1–30 |
| `MaxFavoritesAllowed:<value>` | 사용자별 즐겨찾기 최대 수. 범위: 0–200 |
| `MaxFieldsPerNode:<value>` | Data Processing Engine 정의 내 노드당 필드 최대 수. 범위: 1–500 |
| `MaxInputColumnsPerDT:<value>` | Decision Table의 입력 필드 최대 수. 범위: 1–10 |
| `MaxLoyaltyProcessRules:<value>` | Loyalty 프로그램 프로세스 규칙 최대 수. 범위: 1–20 |
| `MaxNodesPerDPE:<value>` | Data Processing Engine 정의 내 노드 최대 수. 범위: 1–500 |
| `MaxNoOfLexThemesAllowed:<value>` | 테마 최대 수. 범위: 0–300 |
| `MaxOutputColumnsPerDT:<value>` | Decision Table의 출력 필드 최대 수. 범위: 1–5 |
| `MaxSourceObjectPerDSL:<value>` | Decision Table 데이터셋 링크의 소스 오브젝트 최대 수. 범위: 1–5 |
| `MaxStreamingTopics:<value>` | 24시간 PushTopic 이벤트 알림 최대 수. 범위: 40–100 |
| `MaxUserNavItemsAllowed:<value>` | 사용자가 네비게이션 바에 추가할 수 있는 항목 최대 수. 범위: 0–500 |
| `MaxUserStreamingChannels:<value>` | Generic Streaming용 사용자 정의 채널 최대 수. 범위: 20–1,000 |
| `MaxWishlistsItemsPerWishlist` | 위시리스트당 항목 최대 수. 기본: 500 |
| `MaxWishlistsPerStoreAccUsr` | 스토어/계정/사용자당 위시리스트 최대 수. 기본: 100 |
| `MaxWritebacksPerDPE:<value>` | Data Processing Engine 정의 내 Writeback Object 노드 최대 수. 범위: 1–50 |
| `MedVisDescriptorLimit:<value>` | 공유 상속 적용 레코드당 공유 정의 최대 수. 범위: 150–1,600 |
| `MinKeyRotationInterval` | 암호화 키 재료 교체 주기를 60초로 설정 |
| `MobileExtMaxFileSizeMB:<value>` | Field Service Mobile 확장 파일 크기 증가(MB). 범위: 1–2,000 |
| `MobileSecurity` | Enhanced Mobile Security 활성화 (OS 버전·앱 버전·기기/네트워크 보안 정책) |
| `MobileVoiceAndLLM` | 모바일 앱에서 LLM 및 음성 모델 오프라인 다운로드 |
| `MultiLevelMasterDetail` | 오브젝트 간 다단계 master-detail 관계 생성 |
| `MutualAuthentication` | 상호 인증(mTLS)을 위한 클라이언트 인증서 검증 필수화 |
| `MyTrailhead` | myTrailhead enablement 사이트 접근 |
| `NonprofitCloudCaseManagementUser` | Nonprofit Cloud Case Management 관리 패키지 설치에 필요한 권한 세트 라이선스 |
| `NumPlatformEvents:<value>` | 생성 가능한 플랫폼 이벤트 정의 최대 수. 범위: 5–20 |
| `ObjectLinking` | 채널 인터랙션을 연락처·잠재고객·개인 계정에 자동 연결 규칙 생성 (Beta) |
| `OmnistudioMetadata` | OmniStudio 메타데이터 API 활성화 (OmniScript·DataMapper·FlexCard 배포/검색) |
| `OmnistudioRuntime` | OmniScript·DataMapper·FlexCard 등 실행 활성화 |
| `OmnistudioDesigner` | OmniScript·DataMapper·Integration Procedure 생성 활성화 |
| `OrderManagement` | Salesforce Order Management 라이선스 |
| `OrderSaveLogicEnabled` | New Order Save Behavior 지원 |
| `OrderSaveBehaviorBoth` | New/Old Order Save Behavior 모두 지원 |
| `OutboundMessageHTTPSession` | HTTP 엔드포인트 URL을 가진 outbound message에서 Send Session ID 활성화 |
| `OutcomeManagement` | Outcome Management 기능·오브젝트 접근 |
| `PardotScFeaturesCampaignInfluence` | Pardot 사용자를 위한 추가 Campaign Influence 모델 (first touch·last touch·even distribution) |
| `PersonAccounts` | Person Accounts 활성화 |
| `PipelineInspection` | Pipeline Inspection 활성화 (파이프라인 뷰·메트릭·변경사항 하이라이트) |
| `PlatformCache` | Platform Cache 활성화·3MB 캐시 할당 |
| `PlatformConnect:<value>` | Salesforce Connect 활성화 (외부 데이터 조회/검색/수정). 범위: 1–5 |
| `PlatformEncryption` | Shield Platform Encryption 활성화 (미사용 데이터 암호화) |
| `PlatformEventsPerDay:<value>` | 24시간 표준 볼륨 플랫폼 이벤트 알림 최대 수. 범위: 10,000–50,000 |
| `ProcessBuilder` | Process Builder 활성화 |
| `ProductsAndSchedules` | 제품 일정(Product Schedules) 활성화 |
| `ProductCatalogManagementAddOn` | Product Catalog Management 기능·오브젝트 읽기/쓰기 접근 |
| `ProductCatalogManagementViewerAddOn` | Product Catalog Management 기능·오브젝트 읽기 접근 |
| `ProductCatalogManagementPCAddOn` | 파트너 커뮤니티 사용자를 위한 Product Catalog Management 읽기 접근 |
| `ProgramManagement` | Program Management·Case Management 기능·오브젝트 전체 접근 |
| `ProviderFreePlatformCache` | 보안 검토된 관리 패키지를 위한 무료 Platform Cache 3MB 제공 |
| `ProviderManagement` | Public Sector Solutions 공급자 네트워크·케어 플랜·서비스 제공 관리 |
| `PSSAssetManagement` | Public Sector Solutions 자산 관리 |
| `PublicSectorAccess` | Public Sector 전체 기능·오브젝트 접근 |
| `PublicSectorApplicationUsageCreditsAddOn` | Public Sector 애플리케이션 추가 사용량 |
| `PublicSectorSiteTemplate` | Public Sector 사용자를 위한 Experience Cloud 사이트 템플릿 접근 |
| `RateManagement` | Rate Management 활성화 (사용량 기반 제품 요금 설정·관리·최적화) |
| `RecordTypes` | Record Type 기능 활성화 (비즈니스 프로세스·피클리스트·페이지 레이아웃 다양화) |
| `RefreshOnInvalidSession` | 세션 만료 시 Lightning 페이지 자동 갱신 |
| `RevSubscriptionManagement` | Subscription Management 활성화 (B2B 구독·일회성 판매 API-first 솔루션) |
| `S1ClientComponentCacheSize` | Lightning Components 캐싱 최대 5페이지 허용 |
| `SalesCloudEinstein` | Sales Cloud Einstein 기능 + Salesforce Inbox 활성화 |
| `SalesforceContentUser` | Salesforce 콘텐츠 기능 접근 |
| `SalesforceFeedbackManagementStarter` | Salesforce Feedback Management - Starter 기능 라이선스 |
| `SalesforceHostedMCP` | org에서 호스팅 MCP 서버 활성화 |
| `SalesforceIdentityForCommunities` | Experience Builder에 Salesforce Identity 컴포넌트 추가 (Aura 컴포넌트 필수) |
| `SalesforcePricing` | Salesforce Pricing 활성화 (전체 제품 포트폴리오 가격 설정·관리) |
| `SalesUser` | Sales Cloud 기능 라이선스 |
| `SAML20SingleLogout` | SAML 2.0 single logout 활성화 |
| `SCIMProtocol` | SCIM 프로토콜 base API 지원 접근 |
| `ScvMultipartyAndConsult` | Service Cloud Voice with Partner Telephony의 다자 통화·상담 통화 활성화 |
| `SecurityEventEnabled` | Event Monitoring에서 보안 이벤트 접근 |
| `SentimentInsightsFeature` | Sentiment Insights 라이선스 (고객 감정 분석) |
| `ServiceCatalog` | Employee Service Catalog 활성화 |
| `ServiceCloud` | Service Cloud 라이선스 할당 |
| `ServiceCloudVoicePartnerTelephony` | Service Cloud Voice with Partner Telephony 추가 라이선스. 범위: 1–50 |
| `ServiceUser` | Service Cloud User 라이선스 1개 추가 |
| `SessionIdInLogEnabled` | Apex 디버그 로그에 세션 ID 포함 (비활성화 시 "SESSION_ID_REMOVED"로 대체) |
| `SFDOInsightsDataIntegrityUser` | Salesforce.org Insights Platform Data Integrity 관리 패키지 라이선스 |
| `SharedActivities` | 여러 연락처를 작업·이벤트에 연결 |
| `Sites` | Salesforce Sites 활성화 (로그인 없는 공개 웹사이트·애플리케이션) |
| `SocialCustomerService` | Social Customer Service 활성화 |
| `StateAndCountryPicklist` | 주/국가 피클리스트 활성화 |
| `StreamingAPI` | Streaming API 활성화 |
| `StreamingEventsPerDay:<value>` | API v36.0 이하 24시간 PushTopic 이벤트 알림 최대 수. 범위: 10,000–50,000 |
| `SubPerStreamingChannel:<value>` | API v36.0 이하 채널당 동시 클라이언트 최대 수. 범위: 20–4,000 |
| `SubPerStreamingTopic:<value>` | API v36.0 이하 PushTopic 채널당 동시 클라이언트 최대 수. 범위: 20–4,000 |
| `SurveyAdvancedFeatures` | Salesforce Feedback Management - Growth 라이선스 기능 활성화 |
| `SustainabilityCloud` | Sustainability Cloud 설치/구성 권한 세트 라이선스 |
| `SustainabilityApp` | Net Zero Cloud 구성 권한 세트 라이선스 |
| `TalentRecruitmentManagement` | Public Sector Solutions 채용 관리 활성화 |
| `TCRMforSustainability` | Net Zero Analytics 앱 관리 권한 (Tableau CRM 활성화) |
| `TimelineConditionsLimit` | 이벤트 타입당 타임라인 레코드 표시 조건 최대 수를 3으로 제한 |
| `TimelineEventLimit` | 타임라인에 표시되는 이벤트 타입 최대 수를 5로 제한 |
| `TimelineRecordTypeLimit` | 이벤트 타입당 관련 오브젝트 레코드 타입 최대 수를 3으로 제한 |
| `TimeSheetTemplateSettings` | Time Sheet Templates 활성화 (자동 타임시트 생성 설정) |
| `TransactionFinalizers` | Queueable Apex에 Apex Finalizer 구현·첨부 활성화 |
| `UsageManagement` | Usage Management 활성화 (사용량 기반 제품 소비 추적·관리) |
| `VolunteerManagement` | Volunteer Management 기능·오브젝트 접근 |
| `WaveMaxCurrency:<value>` | CRM Analytics 지원 통화 최대 수. 범위: 1–5 |
| `WavePlatform` | Wave Platform 라이선스 활성화 |
| `Workflow` | Workflow 활성화 (내부 프로세스 자동화) |
| `WorkflowFlowActionFeature` | Workflow 액션에서 Flow 실행 |
| `WorkplaceCommandCenterUser` | Workplace Command Center 기능·오브젝트 접근 (Employee·Crisis·EmployeeCrisisAssessment) |
| `WorkThanksPref` | Chatter의 감사 기능(give thanks) 활성화 |

---

## 관련 노트

- [[Scratch Org 패턴]] — Scratch Org 개요·활용 시나리오 (요약 수준)
- [[Scratch Org Settings 레퍼런스]] — settings 블록 전수 옵션
- [[Org Shape와 Snapshot]] — Org Shape 생성·사용, Snapshot 전수 관리
- [[Scratch Org 배포·유저·에러코드]] — Deploy/Retrieve, Users 관리, Error Codes
- [[Salesforce DX 개요]] — sf CLI, sfdx-project.json 설정
- [[Unlocked Package 패턴]] — Scratch Org 기반 패키징
