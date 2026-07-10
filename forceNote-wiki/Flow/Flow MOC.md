---
tags: [flow, moc, index]
created: 2026-05-17
aliases: [Flow MOC, Flow Index]
---

# Flow MOC

> Salesforce Flow 관련 패턴 인덱스. 개념 → 요소 참조 → 타입별 설계 순으로 읽기.

---

## 개념 & 기초

- [[Flow 종류와 변수]] — processType 결정, 변수 isInput/isOutput, $Flow 전역 변수, Apex에서 호출
- [[Flow 요소 참조]] — XML 요소 전체 참조 (recordLookups/Creates/Updates/decisions/assignments/actionCalls 등)
- [[Flow 리소스 레퍼런스]] — 전역 변수 전수($Flow·$Record·$User 등), Choice 3종(Record/Collection/Picklist Choice Set), Stage 리소스, Text Template·Global Constant
- [[Transform 요소]] — Data Transform 요소, 소스↔타깃 필드 매핑, 컬렉션 변환, Sum/Count 집계
- [[Flow 네이밍 컨벤션]] — Flow 타입별 이름 패턴, 요소 API 이름 접두어 (Get_, SUB_, SC01_ 등)
- [[Flow 설계 베스트 프랙티스]] — Fast Field Update, 바이패스, 하드코딩 ID 금지, 거버너, Subflow 전략
- [[Flow 에러 처리]] — faultConnector 전략, {!$Flow.FaultMessage}, 타입별 처리 방법

## 타입별 설계

- [[Screen Flow 설계]] — 다단계 마법사 UI, 내장 컴포넌트(flowruntime:address/lookup), LWC 삽입, 오류 화면
- [[Autolaunched Flow 패턴]] — 헤드리스 로직, 레코드 CRUD, Apex/Agent에서 호출
- [[Record-Triggered Flow]] — before/after-save 실행 모델, entry conditions, $Record/$Record__Prior, Scheduled/Asynchronous Path, Trigger Order, Flow Trigger Explorer
- [[Record-Triggered Flow vs Apex Trigger 선택]] — 레코드 자동화를 Flow로 할지 Apex로 할지, 자동화 밀도(automation density) 휴리스틱·역량 비교 매트릭스·하이브리드 패턴(Flow + Invocable Apex)·비동기 오프로딩
- [[Flow Orchestration]] — 오케스트레이션 개념, 타입 3종(interactive/background/MuleSoft), Stage·Step·Work Item, Build·Deploy
- [[Flow Orchestration - 운영과 레퍼런스]] — Orchestration Run·Manage·Troubleshoot, 한도·Entitlements, 요소/리소스/연산자 레퍼런스 전수

## Apex & LWC 연동

- [[@InvocableMethod 패턴]] — Flow Action Apex 표준 구조, bulkInvoke, JSON 우회, Queueable 연동
- [[Flow Screen LWC 패턴]] — FlowAttributeChangeEvent, @api validate(), Custom Property Editor
- [[Aura Flow 로컬 액션 (availableForFlowActions)]] — availableForFlowActions Aura 로컬 액션으로 Screen Flow에서 클라이언트 JS 실행(페이지 이동·유틸리티바 최소화), lightning:navigation·force:utilityBarAPI, 로컬 액션 vs @InvocableMethod
- [[Flow Interview API]] — Apex에서 Flow 기동, Interview.createInterview/start/resume, 입출력 변수
- [[quickChoice Screen Component]] — render() 멀티 템플릿, picklist/list 소스, Custom Property Editor 실전 패턴
- [[멀티 패키지 구조]] — sfdx-project.json, 도메인별 독립 패키지

## Invocable Actions — 실용 액션 모음

- [[Flow 레코드 컬렉션 조작]] — Aggregate/Filter/Dedupe/Sort/Join 등 컬렉션 11개 액션
- [[Flow 데이터 & 보안 액션]] — ExecuteSOQLQuery, SaveRecordsAsync, 레코드 잠금/해제
- [[Flow 유틸리티 액션 모음]] — 영업시간 계산, CSV 처리, Chatter 게시, Flow 링크·기동

## Screen 컴포넌트 레퍼런스

- [[Screen Component 레퍼런스 - 입력]] — 표준 입력 스크린 컴포넌트 15종(Address·Currency·Date·Email·Name·Slider·Toggle·URL 등) 속성 전수
- [[Screen Component 레퍼런스 - 디스플레이·선택·기타]] — 표준 디스플레이·선택·기타 컴포넌트 18종(Data Table·Lookup·Picklist·Radio·Repeater·Section·Slack Selector 등) 속성 전수

## 통합 (Integration)

- [[Flow HTTP Callout 빌더]] — 무코드 외부 REST 콜아웃, 요청 구성·샘플 응답 등록, External Service·Invocable·Apex 자동 생성

## 테스트·디버깅·배포·운영

- [[Flow Tests (플로우 테스트)]] — Flow Builder 테스트 생성·assertion, 배포 커버리지 요건, Record-Triggered 활성화 전 검증
- [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] — Debug/Rollback 모드, 오류 이메일 수신자, Paused/Failed Interviews 조회, Automation Lightning App
- [[Flow 배포 위치 가이드]] — 퀵액션·URL(/flow/)·Lightning 페이지·유틸리티바·Experience Cloud 배포 경로
- [[Flow 버전 관리와 활성화 - 배포 수명주기]] — 버전 모델, 활성화, change set, 테스트 커버리지 게이트, 인터뷰-버전 관계
- [[Flow 한도 레퍼런스]] — 인터뷰·paused·schedule-triggered·per-transaction 한도 전수, Usage-Based Entitlements

---

## 핵심 API 요약

| API / XML 요소 | 설명 |
|---|---|
| `processType: Flow` | Screen Flow |
| `processType: AutoLaunchedFlow` | 헤드리스 Flow |
| `isInput / isOutput` | 변수 입출력 방향 |
| `storeOutputAutomatically` | 요소 출력을 요소명으로 자동 저장 |
| `faultConnector` | DML/Action 오류 경로 |
| `actionType: apex` | @InvocableMethod 호출 |
| `FlowAttributeChangeEvent` | LWC → Flow 값 변경 통보 |
| `@api validate()` | Flow Next 클릭 시 LWC 검증 |
| `configuration_editor_input_value_changed` | Property Editor → Flow Builder |
| `Flow.Interview.createInterview()` | Apex에서 Flow 기동 |
| `Approval.isLocked / lock / unlock` | 레코드 잠금 |
| `$Flow.CurrentDate / FaultMessage` | 전역 변수 |
