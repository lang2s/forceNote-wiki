---
tags: [index, devops, metadata-api, deploy, retrieve]
created: 2026-05-22
---

# MetadataAPI — 로컬 인덱스

> Salesforce Metadata API v67.0 (Summer '26) — 메타데이터 배포·검색·CRUD 전체 레퍼런스

**상위:** [[DevOps(데브옵스)/index]] | [[Metadata API 개요]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Metadata API 개요]] | API 개념·에디션·권한·버전 생명주기·호출 목록 | #overview |
| [[Metadata API Quick Start]] | WSDL/WSC Java 클라이언트 연결·deploy/retrieve 빠른 시작 | #quickstart |
| [[Metadata API File-Based 호출]] | deploy·checkDeployStatus·cancelDeploy·deployRecentValidation·retrieve·checkRetrieveStatus + package.xml | #reference |
| [[Metadata API CRUD 호출]] | createMetadata·readMetadata·updateMetadata·upsertMetadata·deleteMetadata·renameMetadata | #reference |
| [[Metadata API REST]] | deployRequest REST 엔드포인트 (POST/GET/PATCH) + curl 예제 | #reference |
| [[Metadata API Utility Calls]] | describeMetadata·describeValueType·listMetadata·checkStatus | #reference |
| [[Metadata API Result Objects]] | DeployResult·RetrieveResult·RunTestsResult·SaveResult·DeleteResult·UpsertResult·Error | #reference |
| [[Metadata API Headers]] | AllOrNoneHeader·CallOptions·DebuggingHeader·SessionHeader | #reference |
| [[Metadata API 에러 처리]] | SOAP fault·비동기 CRUD 오류·동기 CRUD 오류·deploy/retrieve 오류·세션 만료 처리 | #reference |
| [[Metadata API MCP Tool]] | Salesforce 호스팅 MCP 서버(Beta)·5개 도구·Cursor·Claude·Agentforce Vibes 설정 | #reference |
| [[Metadata Types — 개요 및 분류]] | 300+ 타입 전체 알파벳 목록·그룹 분류·Type Limits·MetadataWithContent 개념 | #reference |
| [[Metadata Types — Apex & Code]] | ApexClass·ApexTrigger·ApexPage·LightningComponentBundle·AuraDefinitionBundle·StaticResource 필드 정의 | #reference |
| [[Metadata Types — Objects & Fields]] | CustomObject·CustomLabels·GlobalValueSet·StandardValueSet·ContentAsset 필드 정의 | #reference |
| [[Metadata Types — Automation]] | Flow·ApprovalProcess·AssignmentRules·WorkflowRule·DuplicateRule·CustomNotificationType 필드 정의 | #reference |
| [[Metadata Types — Security & Access]] | PermissionSet·Profile·SharingRules·ConnectedApp·Certificate·RestrictionRule·TransactionSecurityPolicy 필드 정의 | #reference |
| [[Metadata Types — UI & Layout]] | Layout·FlexiPage·CustomApplication·CustomTab·QuickAction·ExperienceBundle 필드 정의 | #reference |
| [[Metadata Types — Integration & Platform]] | NamedCredential·RemoteSiteSetting·PlatformEventChannel·InstalledPackage·Settings 필드 정의 | #reference |
| [[Metadata Types — Einstein & Analytics]] | WaveApplication·GenAiPlanner·Bot·DiscoveryAIModel·AiAuthoringBundle 필드 정의 | #reference |
| [[Metadata Types — Other]] | Metadata·MetadataWithContent 기본 클래스·FuelType·Scontrol(Deprecated) 정의 | #reference |

---

## 빠른 선택

- 처음 연결 설정? → [[Metadata API Quick Start]]
- 전체 개념 파악? → [[Metadata API 개요]]
- .zip 배포하기? → [[Metadata API File-Based 호출]] → deploy()
- REST로 배포? → [[Metadata API REST]]
- 코드에서 단일 컴포넌트 생성/삭제? → [[Metadata API CRUD 호출]]
- 지원 타입 목록 확인? → [[Metadata API Utility Calls]] → describeMetadata()
- 배포 결과 파싱? → [[Metadata API Result Objects]] → DeployResult
- CRUD 결과 오류 처리? → [[Metadata API Result Objects]] → Error
- AllOrNone 설정? → [[Metadata API Headers]] → AllOrNoneHeader
- 디버그 로그 활성화? → [[Metadata API Headers]] → DebuggingHeader
- 오류 코드 처리? → [[Metadata API 에러 처리]]
- AI 코딩 도구에서 타입 조회? → [[Metadata API MCP Tool]]
- 전체 메타데이터 타입 목록? → [[Metadata Types — 개요 및 분류]]
- ApexClass/LWC 메타데이터 필드? → [[Metadata Types — Apex & Code]]
- CustomObject/CustomField 메타데이터? → [[Metadata Types — Objects & Fields]]
- Flow/Approval 메타데이터 필드? → [[Metadata Types — Automation]]
- Profile/PermissionSet 메타데이터? → [[Metadata Types — Security & Access]]
- FlexiPage/Layout 메타데이터? → [[Metadata Types — UI & Layout]]
- NamedCredential/RemoteSiteSetting 메타데이터? → [[Metadata Types — Integration & Platform]]
- Agentforce/Bot/Wave 메타데이터? → [[Metadata Types — Einstein & Analytics]]

---

## 관련 섹션

- [[Salesforce DX 개요]] — sf CLI로 deploy/retrieve 래핑
- [[CI CD 패턴]] — Metadata API 기반 자동화 배포
- [[Unlocked Package 패턴]] — 패키지 기반 배포
