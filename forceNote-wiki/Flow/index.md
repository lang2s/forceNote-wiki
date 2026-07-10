---
tags: [index, flow]
created: 2026-05-17
---

# Flow — 로컬 인덱스

> Salesforce Flow 자동화 패턴 — 개념, 타입별 설계, Apex·LWC 연동

**상위:** [[Flow MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Flow 종류와 변수]] | processType 결정, isInput/isOutput 변수, $Flow 전역 변수 | #concept |
| [[Flow 요소 참조]] | XML 요소 전체 참조 — recordLookups/decisions/assignments/actionCalls | #reference |
| [[Flow 네이밍 컨벤션]] | Flow 타입별·요소별 API 이름 패턴 — Get_, SUB_, SC01_, BI/BU/AI/AU/BD | #convention |
| [[Flow 설계 베스트 프랙티스]] | Fast Field Update, 바이패스, 하드코딩 ID 금지, 거버너, Subflow 전략 | #best-practice |
| [[Flow 에러 처리]] | faultConnector 전략, {!$Flow.FaultMessage}, 타입별 에러 처리 방법 | #pattern |
| [[Screen Flow 설계]] | 다단계 마법사 UI, flowruntime 내장 컴포넌트, LWC 삽입, faultConnector | #pattern |
| [[Autolaunched Flow 패턴]] | 헤드리스 로직, 레코드 CRUD, Apex/Agent에서 호출 | #pattern |
| [[@InvocableMethod 패턴]] | Flow Action 표준 구조, bulkInvoke, JSON 우회, Queueable 연동 | #pattern |
| [[Flow Screen LWC 패턴]] | FlowAttributeChangeEvent, @api validate(), Custom Property Editor | #pattern |
| [[멀티 패키지 구조]] | sfdx-project.json, 도메인별 독립 Unlocked Package 구성 | #pattern |
| [[Flow 레코드 컬렉션 조작]] | Aggregate/Filter/Dedupe/Join 등 컬렉션 11개 Invocable Action | #pattern |
| [[Flow 데이터 & 보안 액션]] | ExecuteSOQLQuery, SaveRecordsAsync, 레코드 잠금/해제 | #pattern |
| [[quickChoice Screen Component]] | render() 멀티 템플릿, picklist/list 소스, Custom Property Editor | #pattern |
| [[Flow 유틸리티 액션 모음]] | 영업시간 계산, CSV 처리, Chatter 게시, Flow 링크·기동 | #pattern |
| [[Flow Interview API]] | Flow.Interview — Apex에서 Autolaunched Flow 실행, createInterview, getVariableValue | #reference |
| [[Aura Flow 로컬 액션 (availableForFlowActions)]] | availableForFlowActions Aura 로컬 액션 — Screen Flow에서 클라이언트 JS 실행(페이지 이동·유틸리티바 최소화), lightning:navigation·force:utilityBarAPI, 로컬 액션 vs @InvocableMethod | #pattern |
| [[Record-Triggered Flow vs Apex Trigger 선택]] | 레코드 자동화를 Flow로 할지 Apex로 할지 — 자동화 밀도(automation density) 휴리스틱, 역량 비교 매트릭스, 하이브리드 패턴(Flow + Invocable Apex), 비동기 오프로딩 | #decision |
| [[Record-Triggered Flow]] | before/after-save 실행 모델, entry conditions, $Record/$Record__Prior, Scheduled/Asynchronous Path, Trigger Order, Flow Trigger Explorer | #concept #reference |
| [[Flow Orchestration]] | 오케스트레이션 개념, 타입 3종(interactive/background/MuleSoft), Stage·Step·Work Item, Build·Deploy | #concept #pattern |
| [[Flow Orchestration - 운영과 레퍼런스]] | Orchestration Run·Manage·Troubleshoot, 한도·Entitlements, 요소/리소스/연산자 레퍼런스 전수 | #reference |
| [[Flow HTTP Callout 빌더]] | 무코드 외부 REST 콜아웃 — 요청 구성·샘플 응답 등록, External Service·Invocable·Apex 자동 생성 | #pattern #integration |
| [[Transform 요소]] | Data Transform 요소 — 소스↔타깃 필드 매핑, 컬렉션 변환, Sum/Count 집계 | #reference #pattern |
| [[Flow Tests (플로우 테스트)]] | Flow Builder 테스트 생성·assertion, 배포 커버리지 요건, Record-Triggered 활성화 전 검증 | #pattern #testing |
| [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] | Debug/Rollback 모드, 오류 이메일 수신자, Paused/Failed Interviews 조회, Automation Lightning App | #pattern #operations |
| [[Flow 리소스 레퍼런스]] | 전역 변수 전수($Flow·$Record·$User 등), Choice 3종, Stage 리소스, Text Template·Global Constant | #reference |
| [[Flow 배포 위치 가이드]] | 퀵액션·URL(/flow/)·Lightning 페이지·유틸리티바·Experience Cloud 배포 경로 | #pattern #howto |
| [[Flow 버전 관리와 활성화 - 배포 수명주기]] | 버전 모델, 활성화, change set, 테스트 커버리지 게이트, 인터뷰-버전 관계 | #concept #howto |
| [[Flow 한도 레퍼런스]] | 인터뷰·paused·schedule-triggered·per-transaction 한도 전수, Usage-Based Entitlements | #reference |
| [[Screen Component 레퍼런스 - 입력]] | 표준 입력 스크린 컴포넌트 15종 속성 전수(Address·Currency·Date·Email·Name·Slider·Toggle·URL 등) | #reference |
| [[Screen Component 레퍼런스 - 디스플레이·선택·기타]] | 표준 디스플레이·선택·기타 컴포넌트 18종 속성 전수(Data Table·Lookup·Picklist·Radio·Repeater·Section·Slack Selector 등) | #reference |

---

## 빠른 선택

- Flow 종류를 처음 파악할 때? → [[Flow 종류와 변수]]
- XML 요소 이름이 기억 안 날 때? → [[Flow 요소 참조]]
- Flow 이름 짓는 규칙? → [[Flow 네이밍 컨벤션]]
- 설계·성능·유지보수 원칙? → [[Flow 설계 베스트 프랙티스]]
- 오류 처리 방법? → [[Flow 에러 처리]]
- 사용자 화면 있는 다단계 Flow? → [[Screen Flow 설계]]
- 레코드 처리·백그라운드 자동화? → [[Autolaunched Flow 패턴]]
- Flow에서 Apex 로직 호출? → [[@InvocableMethod 패턴]]
- Flow 화면 안에 LWC 삽입? → [[Flow Screen LWC 패턴]]
- Flow 화면 선택 UI (카드/드롭다운/라디오)? → [[quickChoice Screen Component]]
- Flow 안에서 리스트 필터/집계/정렬? → [[Flow 레코드 컬렉션 조작]]
- Flow에서 동적 SOQL 실행? → [[Flow 데이터 & 보안 액션]]
- 레코드 잠금/영업시간/Chatter? → [[Flow 유틸리티 액션 모음]]
- 멀티 패키지 프로젝트 구성? → [[멀티 패키지 구조]]
- Apex 코드에서 Flow를 직접 실행? → [[Flow Interview API]]
- Flow에서 클라이언트 액션(페이지 이동·유틸리티바 제어)? → [[Aura Flow 로컬 액션 (availableForFlowActions)]]
- 레코드 자동화를 Flow로 만들지 Apex Trigger로 만들지? → [[Record-Triggered Flow vs Apex Trigger 선택]]
- 레코드 저장 시 자동 실행(before/after-save)·스케줄 경로? → [[Record-Triggered Flow]]
- 여러 사용자·시스템이 관여하는 다단계 프로세스? → [[Flow Orchestration]] · 운영/한도는 [[Flow Orchestration - 운영과 레퍼런스]]
- 코드 없이 외부 REST API 호출? → [[Flow HTTP Callout 빌더]]
- 컬렉션 필드 매핑·데이터 변환? → [[Transform 요소]]
- Flow 화면 입력 컴포넌트 속성? → [[Screen Component 레퍼런스 - 입력]]
- Flow 화면 선택·디스플레이 컴포넌트 속성? → [[Screen Component 레퍼런스 - 디스플레이·선택·기타]]
- Flow 전역 변수·Choice·Stage 리소스? → [[Flow 리소스 레퍼런스]]
- Flow 테스트 만들고 커버리지 확보? → [[Flow Tests (플로우 테스트)]]
- Flow 오류 진단·인터뷰 모니터링? → [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]]
- 완성한 Flow를 어디에 심어 노출? → [[Flow 배포 위치 가이드]]
- Flow 버전 관리·활성화·다른 조직 배포? → [[Flow 버전 관리와 활성화 - 배포 수명주기]]
- Flow 한도·거버너 수치? → [[Flow 한도 레퍼런스]]

---

## 읽기 순서 (처음 공부할 때)

```
Flow 종류와 변수 → Flow 요소 참조 → Screen Flow 설계 or Autolaunched Flow 패턴 → @InvocableMethod 패턴
```
