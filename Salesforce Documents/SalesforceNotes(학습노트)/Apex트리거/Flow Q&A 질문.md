---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Flow Interview]
---

# Flow Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Salesforce Flow란 무엇인가요?**

Salesforce Flow는 코딩 기술 없이도 비즈니스 프로세스를 쉽게 만들고 최적화할 수 있는 자동화 도구입니다. Flow로 데이터를 수집·업데이트하고, 승인 워크플로우를 자동화하며, 레코드를 생성하고, 다양한 작업을 매끄럽게 수행할 수 있습니다.

**Flow를 언제 사용하나요?**

다음과 같은 간단한 자동화가 필요할 때 사용합니다:
- 특정 기준에 따라 필드 업데이트
- 이메일 경고 전송
- 기본 계산 수행
- 레코드 생성, 업데이트, 삭제 자동화

**Flow를 사용하지 않는 경우**

다음과 같은 요구사항에는 적합하지 않습니다:
- **복잡한 비즈니스 로직:** Flow는 깊게 중첩된 루프, 재귀, Apex 수준 처리가 필요한 고급 알고리즘을 잘 처리하지 못합니다.
- **대용량 데이터:** 거버너 한도의 제약을 받으며, 단일 실행에서 수천 개의 레코드를 처리하는 대량 데이터 작업에는 이상적이지 않습니다.
- **통합 요구:** Flow는 외부 서비스를 지원하지만, 동적 통합이나 고급 API 처리에 있어 Apex만큼 유연하지 않습니다.
- **고급 오류 처리:** Flow는 기본적인 fault path를 제공하지만, 상세한 오류 로깅이나 재시도 메커니즘은 Apex로 구현하는 것이 좋습니다.
- **복잡한 데이터 조작:** JSON 파싱, 고급 문자열 조작, 다중 오브젝트 순회 같은 작업은 Apex에 더 적합합니다.

**Flow는 Salesforce의 어디에 배치할 수 있나요?**

Lightning 페이지, 홈 페이지, Experience Builder 페이지, 커스텀 Lightning 컴포넌트, Visualforce 페이지, 웹 탭, 커스텀 버튼 및 링크 등 여러 위치에 배치할 수 있습니다.

**Salesforce의 Flow 유형은?**

- **Screen Flow:** 사용자 입력을 수집하거나 데이터를 표시하는 대화형 Flow
- **Record-Triggered Flow:** 레코드가 생성, 업데이트, 삭제될 때 자동으로 실행
- **Schedule-Triggered Flow:** 특정 시간 또는 반복 일정에 따라 실행
- **Platform Event-Triggered Flow:** 플랫폼 이벤트 메시지를 수신할 때 실행
- **Autolaunched Flow:** 트리거, Apex, Process Builder 같은 다른 프로세스에 의해 호출될 때 자동 실행
- **Flow Orchestration:** 여러 사용자나 시스템이 관여하는 복잡한 다단계 비즈니스 프로세스를 자동화

**Before-save Flow와 After-save Flow의 차이는?**

Before-save Flow는 삽입, 업데이트, 삭제 등의 작업 *전에* 수행되는 트리거입니다. 데이터가 데이터베이스에 업데이트/삽입되기 전에 값을 확인하거나 변경하는 데 사용합니다.

After-save Flow는 작업 *후에* 실행됩니다. 관련 오브젝트의 데이터를 업데이트하거나 이메일 경고를 보내는 데 사용합니다.

**Process Builder를 Flow로 어떻게 마이그레이션하나요?**

Salesforce에는 Process Builder 프로세스를 Flow로 변환하는 데 도움을 주는 "Migrate to Flow" 도구가 있습니다.

**Subflow란?**

Subflow는 기본 Flow 내에서 형성되는 또 다른 Flow입니다. 재사용 가능한 컴포넌트와 로직을 별도의 Flow에 캡슐화하고 subflow로 관리함으로써 모듈식 설계를 촉진합니다. 복잡한 로직을 매번 다시 만들 필요 없이 여러 Record-Triggered Flow에서 재사용할 수 있게 해줍니다.

**Before-save Flow에서 subflow를 호출할 수 있나요?**

아니요, after-save Flow에서만 사용 가능합니다.

**Flow의 주요 구성 요소는?**

- **요소(Elements):** 상호작용 요소(Screen), 논리 요소(Assignment, Loop, Decision), 액션 요소(get, create, update, subflow, delete)
- **리소스(Resources):** Flow 내에서 데이터를 저장하는 데 사용 — 수식, 변수, 상수, 컬렉션, 텍스트 템플릿
- **커넥터(Connectors):** 요소들이 어떻게 연결되어 경로를 완성하는지 정의

**Apex 대비 Flow의 장점은?**

드래그 앤 드롭 기능, 로우코드 플랫폼, 사전 구축된 요소와 템플릿, 쉬운 개발 및 배포, 코딩 지식 불필요, 코드 유지보수 걱정 불필요, 테스트 클래스 작성 불필요.

**Flow의 모든 제한 사항은?**

- 트랜잭션당 총 SOQL 쿼리 (한도: 100)
- 트랜잭션당 총 DML 문 (한도: 150)
- SOQL 쿼리로 조회되는 총 레코드 (한도: 50,000)
- DML로 처리되는 총 레코드 수 (10,000)
- Salesforce 서버의 최대 CPU 시간 (10초)
- Flow당 런타임 시 실행되는 최대 요소 수 (20,000)
- Flow당 최대 50개 버전
- Flow 유형당 활성 Flow 2,000개

**Flow에서 따라야 할 모범 사례는?**

- 루프 안에 DML 문 넣지 않기
- Subflow 활용하기
- ID 하드코딩하지 않기
- get, update, create, delete 요소 다음에 항상 fault path 두기
- get 요소 다음에는 항상 null 체크하기

**Flow에서 오류를 어떻게 처리하나요?**

Fault path를 사용해 오류를 처리합니다. 오류 발생 시 Flow가 fault path로 이동하여 이메일 전송이나 커스텀 오류 메시지 같은 처리 방법을 정의할 수 있습니다. `{!$Flow.FaultMessage}`를 사용해 오류 메시지를 가져올 수 있습니다.

**삭제된 Flow를 복원할 수 있나요?**

아니요. Flow가 삭제되면 Salesforce 조직에서 영구적으로 제거됩니다.

**Flow는 어떤 모드로 실행되나요?**

기본적으로 Screen Flow는 사용자 모드(user mode)에서 실행됩니다. 단, Salesforce는 시스템 모드로 실행하는 기능도 제공합니다. Record-Triggered Flow는 항상 시스템 모드로 실행됩니다. Scheduled-Triggered Flow도 항상 시스템 모드로 실행됩니다.

**Screen Flow의 컨텍스트를 어떻게 변경하나요?**

Show Advanced > How to Run the Flow를 클릭하면 추가 옵션 두 가지(공유 포함/미포함 System Context)가 나타납니다.

**다른 사용자로 Flow를 디버그할 수 있나요?**

해당 사용자로 로그인하지 않고도 다른 사용자로 Flow를 테스트하거나 문제를 해결할 수 있습니다. 먼저 Process Automation Settings에서 "Enable Let admins debug flows as other users" 기능을 활성화해야 합니다. (참고: Flow 디버그 실행 중 다른 사용자를 가장하려면 Manage Flow와 View All Data 권한이 필요합니다.) 그런 다음 "Run flow as another user" 옵션을 체크하고 가장할 사용자를 선택합니다.

**Salesforce에서 실패한 Flow를 어떻게 확인하나요?**

Setup → Process Automation → 'All Failed Flow Interviews List View'를 사용합니다. 이 목록 뷰는 문제가 발생한 Screen Flow, Record-Triggered Flow, Schedule-Triggered Flow와 트리거되지 않은 Autolaunched Flow의 목록을 보여줍니다.

**Collection Filter란?**

Collection Filter는 원본 컬렉션 내용의 필터링된 하위 집합을 포함하는 새 컬렉션 변수를 생성하는 데 사용됩니다.

**Flow의 $Record와 $Record__Prior란?**

$Record는 레코드의 현재 값을 나타내고, $Record__Prior는 업데이트 전 레코드 값을 보유합니다. 이전 값과 $Record의 새 값을 비교하는 데 유용합니다.

**Lightning 레코드 페이지에서 Flow로 레코드 ID를 어떻게 전달하나요?**

Flow 변수를 만들고 "Pass all field values from the record into this flow variable" 옵션을 선택합니다.
1. New Resource 클릭
2. 리소스 타입으로 Variable 선택
3. API 이름 입력
4. 레코드 ID를 전달할 오브젝트 선택
5. "Available for Input" 체크박스 선택
6. Done 클릭

App Builder 페이지에서 Flow 요소를 드래그 앤 드롭하고, 표시할 Flow를 선택한 뒤 "Pass all field values from the record into this flow variable"을 선택합니다. (App Page나 Home Page에서는 변수를 사용할 수 없습니다.)

**Salesforce Flow의 Transform 요소란?**

Transform 요소는 소스 데이터를 타겟 데이터로 매핑하고 변환하는 데 사용됩니다. Screen Flow, 트리거 없는 Autolaunched Flow, Record-Triggered Flow에서 활용할 수 있습니다.

**특정 로직에 따라 화면 컴포넌트를 어떻게 표시하나요?**

모든 Screen Flow 컴포넌트는 "Set component visibility" 옵션을 사용해 커스터마이징된 로직에 따라 가시성을 설정할 수 있습니다.

**Flow에서 Apex를 호출할 수 있나요?**

네, 가능합니다:
1. Apex 클래스에 invocable 메서드 생성
2. 메서드에 @InvocableMethod 어노테이션 추가
3. Flow에 Apex Action 추가
4. invocable 메서드 선택
5. 입력 및 출력 파라미터 설정

**Flow에서 Apex를 호출할 때 유의할 핵심 사항은?**

- 각 클래스는 invocable 메서드를 하나만 가질 수 있음
- 메서드는 static이며 public 또는 global이어야 함
- 메서드의 클래스는 외부 클래스(outer class)여야 함
- 메서드는 파라미터를 하나만 가질 수 있음
- 파라미터의 데이터 타입은 list여야 함
- 메서드의 반환 데이터 타입도 list여야 함

**Apex가 Autolaunched Flow를 호출할 수 있나요?**

네. Apex에서 Flow를 호출하려면 `Flow.Interview.flowName` 구문으로 FlowInterview 객체의 인스턴스를 생성합니다. 그런 다음 start() 메서드로 Flow를 트리거합니다. Flow.Interview Apex 클래스의 getVariableValue 메서드를 사용해 특정 Flow의 변수를 가져올 수 있습니다.

**LWC에서 Flow를 호출할 수 있나요?**

네:
1. 새 Flow를 만들거나 기존 Flow 사용
2. LWC 컴포넌트 생성
3. `<lightning-flow>` 태그에 Flow 이름 전달

**Flow에서 LWC를 호출할 수 있나요?**

네, Winter 2023 릴리스부터 Flow에서 LWC를 호출할 수 있습니다. LWC의 meta 파일에 `lightning__FlowScreen` 타겟을 추가합니다. LWC의 JavaScript에서 @api를 사용해 속성을 노출할 수도 있습니다.

**Flow에서 HTTP 콜아웃을 할 수 있나요?**

네, 가능합니다:
1. 권한 집합 생성
2. External Credential 생성
3. External Credential Principal 생성
4. Named Credential 생성
5. External Credential Principal과 권한 집합 매핑
6. "Create HTTP callout" 요소를 사용해 Flow 생성
7. Flow를 테스트해 HTTP 콜아웃 확인

**Send Email 액션으로 보낸 이메일을 기록할 수 있나요?**

네, 이제 "Send Email" 액션으로 이메일을 보낼 수 있으며, 이 이메일은 수신자 레코드의 Activity Timeline에 자동으로 기록됩니다. 수신자 레코드에는 Lead, Contact, Person Account가 포함됩니다.

**Screen Flow의 Repeater 컴포넌트란?**

Summer '24 릴리스로, Repeater는 여러 데이터 입력 컴포넌트를 담는, 화면 요소에 추가할 수 있는 컴포넌트입니다. Add와 Remove 두 버튼이 있습니다. Add를 클릭하면 또 다른 입력 필드 세트가 표시되고, Remove를 클릭하면 맨 아래 필드 세트 하나가 제거됩니다. 사용자가 같은 화면에서 여러 레코드 필드에 정보를 입력할 수 있습니다. (사용 사례: 여러 Contact 레코드 생성)

**Flow의 주소 필드에 Google Map을 추가할 수 있나요?**

네, 가능합니다. Summer '24 릴리스입니다.

**Schedule-Triggered Flow에서 어떤 빈도를 설정할 수 있나요?**

한 번(once), 매일(daily), 매주(weekly) 빈도로 트리거할 수 있습니다.
