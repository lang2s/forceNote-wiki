# Salesforce 개발자 위키

Salesforce 공식 오픈소스 프로젝트 7개를 직접 분석해 추출한 검증된 패턴 모음.  
[Obsidian](https://obsidian.md)에서 열면 `[[wikilink]]` 연결과 그래프 뷰를 활용할 수 있습니다.

---

## 분석 소스 프로젝트

| 프로젝트 | 분석 대상 | 추출 패턴 |
|---|---|---|
| [apex-recipes](https://github.com/trailheadapps/apex-recipes) | Apex 클래스 74개 | 보안, 비동기, 통합, 테스트 |
| [lwc-recipes](https://github.com/trailheadapps/lwc-recipes) | LWC 컴포넌트 133개 | Wire/Imperative, LDS, 이벤트, 보안 |
| [automation-components](https://github.com/trailheadapps/automation-components) | Flow Action 30개 | @InvocableMethod, Flow Screen LWC |
| [dreamhouse-lwc](https://github.com/trailheadapps/dreamhouse-lwc) | Flow XML | Screen Flow 설계, 오류 처리 |
| [agent-script-recipes](https://github.com/trailheadapps/agent-script-recipes) | Flow XML | Autolaunched Flow, Agent Action |

---

## 구조

```
Salesforce wiki/
├── 00 Home.md              ← 전체 진입점
├── Apex/                   ← 31개 노트
│   ├── 보안/               Safely, CanTheUser, WITH USER_MODE
│   ├── 비동기/             Future, Queueable, Batch, Scheduled
│   ├── 데이터/             SOQL, DML, Dynamic SOQL
│   ├── 통합/               RestClient, Custom REST Endpoint
│   ├── 테스트/             StubProvider, HttpCalloutMock, SOSL
│   ├── 아키텍처/           서비스 레이어, TriggerHandler
│   ├── 컬렉션/             Comparator, Iterable, CollectionUtils
│   ├── 실행컨텍스트/       QuiddityGuard, OrgShape
│   ├── 플랫폼이벤트/       Platform Event
│   └── 플랫폼캐시/         Platform Cache
├── LWC/                    ← 18개 노트
│   ├── Apex통합/           Wire vs Imperative, @wire, async/await
│   ├── 컴포넌트API/        @api, 컴포지션 패턴
│   ├── 이벤트/             CustomEvent, LMS, 상태 관리
│   ├── LDS/                Record Form, uiRecordApi, getRecord
│   ├── 네비게이션/         NavigationMixin
│   ├── UI패턴/             Toast, 모달, 에러 패널, 공유 JS
│   └── 보안/               customPermission, CSP, DOM XSS
├── Flow/                   ← 8개 노트
│   ├── Flow 종류와 변수    processType, isInput/isOutput
│   ├── Flow 요소 참조      XML 요소 전체 (recordLookups, decisions 등)
│   ├── Screen Flow 설계    flowruntime:, LWC 삽입, 오류 처리
│   ├── Autolaunched Flow   헤드리스, Apex/Agent에서 호출
│   ├── @InvocableMethod    bulkInvoke, Input/Output 파라미터
│   ├── Flow Screen LWC     FlowAttributeChangeEvent, validate()
│   └── 멀티 패키지 구조    sfdx-project.json
└── 통합/
    └── Named Credential    External Credential, callout:

Salesforce Documents/       ← 공식 레퍼런스 PDF 18개
```

---

## Obsidian에서 열기

1. Obsidian 실행 → **Open folder as vault**
2. 이 저장소의 루트 폴더 선택
3. `00 Home.md` 를 시작점으로 탐색
4. **Graph View** (Ctrl/Cmd + G) 에서 노트 연결망 확인

---

## 공식 레퍼런스 PDF (`Salesforce Documents/`)

| 파일 | 내용 |
|---|---|
| `salesforce_apex_developer_guide.pdf` | Apex 개발자 가이드 |
| `salesforce_apex_reference_guide.pdf` | Apex API 레퍼런스 |
| `api_rest.pdf` | REST API |
| `api_meta.pdf` | Metadata API |
| `api_asynch.pdf` | Bulk / Async API |
| `api_action.pdf` | Actions API |
| `lightning.pdf` | Lightning 컴포넌트 가이드 |
| `exp_cloud_lwr.pdf` | Experience Cloud / LWR |
| `pkg2_dev.pdf` | Unlocked Package 개발 |
| `sfdx_dev.pdf` | Salesforce CLI 개발 |
