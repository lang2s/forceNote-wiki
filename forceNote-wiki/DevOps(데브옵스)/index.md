---
tags: [index, devops, salesforce-dx, ci-cd, packaging, metadata-api]
created: 2026-05-18
---

# DevOps(데브옵스) — 로컬 인덱스

> Salesforce DX — 소스 중심 개발, Scratch Org, Unlocked Package, CI/CD 자동화, Metadata API 배포

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce DX 개요]] | sfdx-project.json, sf CLI 기본 명령, Source Format, .forceignore, JWT 인증 | #overview |
| [[Scratch Org 패턴]] | Scratch Org 생성·관리, project-scratch-def.json, Org Shape, Snapshot | #pattern |
| [[Unlocked Package 패턴]] | sf package create/version create/install, 2GP, Org-Dependent, packageAliases | #pattern |
| [[CI CD 패턴]] | Jenkins Jenkinsfile, CircleCI, JWT 인증 자동화, 패키지 빌드 파이프라인 | #pattern |

### Metadata API (서브폴더 → [[MetadataAPI/index]])

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[MetadataAPI/Metadata API 개요]] | API 개념·에디션·권한·버전 생명주기·호출 목록 | #overview |
| [[MetadataAPI/Metadata API Quick Start]] | WSDL/WSC Java 클라이언트 연결·빠른 시작 | #quickstart |
| [[MetadataAPI/Metadata API File-Based 호출]] | deploy·retrieve·package.xml·DeployOptions 전체 | #reference |
| [[MetadataAPI/Metadata API CRUD 호출]] | createMetadata·readMetadata·updateMetadata·deleteMetadata | #reference |
| [[MetadataAPI/Metadata API REST]] | deployRequest REST 엔드포인트 + curl 예제 | #reference |
| [[MetadataAPI/Metadata API Utility Calls]] | describeMetadata·listMetadata·checkStatus | #reference |
| [[MetadataAPI/Metadata API Result Objects]] | DeployResult·RetrieveResult·RunTestsResult·Error 전수 | #reference |
| [[MetadataAPI/Metadata API Headers]] | AllOrNoneHeader·DebuggingHeader·SessionHeader | #reference |
| [[MetadataAPI/Metadata API 에러 처리]] | SOAP fault·비동기/동기 CRUD 오류·세션 만료 처리 | #reference |
| [[MetadataAPI/Metadata API MCP Tool]] | MCP 서버(Beta)·5개 도구·Cursor/Claude/Agentforce 설정 | #reference |
| [[MetadataAPI/Metadata Types — 개요 및 분류]] | 300+ 타입 전체 목록·그룹 분류·Type Limits | #reference |
| [[MetadataAPI/Metadata Types — Apex & Code]] | ApexClass·ApexTrigger·LightningComponentBundle·StaticResource | #reference |
| [[MetadataAPI/Metadata Types — Objects & Fields]] | CustomObject·CustomField·RecordType·ValidationRule | #reference |
| [[MetadataAPI/Metadata Types — Automation]] | Flow·ApprovalProcess·WorkflowRule·DuplicateRule | #reference |
| [[MetadataAPI/Metadata Types — Security & Access]] | PermissionSet·Profile·SharingRules·ConnectedApp | #reference |
| [[MetadataAPI/Metadata Types — UI & Layout]] | Layout·FlexiPage·CustomApplication·ExperienceBundle | #reference |
| [[MetadataAPI/Metadata Types — Integration & Platform]] | NamedCredential·RemoteSiteSetting·PlatformEventChannel | #reference |
| [[MetadataAPI/Metadata Types — Einstein & Analytics]] | WaveApplication·GenAiPlanner·Bot·DiscoveryAIModel | #reference |
| [[MetadataAPI/Metadata Types — Other]] | Metadata·MetadataWithContent·FuelType·기타 타입 | #reference |

---

## 빠른 선택

- DX 프로젝트 생성부터 배포까지? → [[Salesforce DX 개요]]
- Scratch Org 만들고 스냅샷 찍기? → [[Scratch Org 패턴]]
- Unlocked Package 버전 만들고 설치하기? → [[Unlocked Package 패턴]]
- Jenkins/CircleCI로 자동화 파이프라인 구성? → [[CI CD 패턴]]
- JWT 인증 설정? → [[Salesforce DX 개요]] → Authorization
- Org Shape vs Snapshot 차이? → [[Scratch Org 패턴]] → Org Shape
- Metadata API 전체 둘러보기? → [[MetadataAPI/index]]
- .zip 파일로 배포하기? → [[MetadataAPI/Metadata API File-Based 호출]]
- REST API로 배포? → [[MetadataAPI/Metadata API REST]]
- 단일 컴포넌트 생성/삭제(CRUD)? → [[MetadataAPI/Metadata API CRUD 호출]]
- 배포 오류 원인 파악? → [[MetadataAPI/Metadata API 에러 처리]]
- AI 코딩 도구에서 메타데이터 타입 조회? → [[MetadataAPI/Metadata API MCP Tool]]
- CustomObject/CustomField 메타데이터 필드 정의? → [[MetadataAPI/Metadata Types — Objects & Fields]]
- Flow/ApprovalProcess 메타데이터 필드 정의? → [[MetadataAPI/Metadata Types — Automation]]
- PermissionSet/Profile 메타데이터 필드 정의? → [[MetadataAPI/Metadata Types — Security & Access]]

---

## 관련 섹션

- [[Apex MOC]] — Apex 코드 개발
- [[LWC MOC]] — LWC 컴포넌트 개발
- [[Flow MOC]] — Flow 자동화
