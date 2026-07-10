---
tags: [flow, version, activation, deployment, run-context, packaging, change-set, lifecycle, test-coverage]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Activation, Flow Version, Deploy as Active, Flow Run Context, Flow Test Coverage, 플로우 활성화, 플로우 버전 관리, 플로우 실행 컨텍스트, 배포 시 비활성, Flow 패키징, Flow Change Set]
---

# Flow 버전 관리와 활성화 — 배포 수명주기

> Flow는 버전 단위로 관리되며 **Flow당 활성 버전은 항상 1개**다. 어떤 버전이 실행되는지, 어떤 컨텍스트(user/system)로 실행되는지, 다른 조직으로 옮길 때 왜 Inactive로 도착하는지(테스트 커버리지 게이트 포함)까지 — 배포 수명주기 전체를 다룬다.

---

## 버전 수명주기 핵심 규칙

| 규칙 | 내용 |
|---|---|
| **활성 버전 1개** | 한 Flow는 여러 버전을 가질 수 있지만 **동시에 활성일 수 있는 버전은 1개뿐**. 새 버전을 활성화하면 기존 활성 버전(있다면)은 자동 비활성화된다 |
| **버전 상한 50** | 한 Flow는 최대 **50개 버전**까지 가질 수 있다 |
| **실행 중 인터뷰는 시작 버전 유지** | 이미 실행 중인 flow interview는 **자기가 시작한 버전으로 계속 실행**된다 — 새 버전 활성화의 영향을 받지 않는다 |
| **Sandbox → Production 이동 시** | sandbox에서 활성화한 Flow를 production으로 옮기면 **새 버전으로 저장하기 전까지 Activate 버튼이 비활성화**된다. sandbox와 production은 속성·ID가 다를 수 있으므로, 이동 후엔 항상 **rollback 모드로 디버그**할 것 |
| **버전 삭제와 paused 인터뷰** | 실행 중이거나 paused 상태인 인터뷰가 있으면 해당 버전을 업데이트/삭제할 수 없다 — 먼저 인터뷰를 삭제해야 한다 ([[Flow 배포 위치 가이드]]의 "Paused 인터뷰" 절 참조) |

### 활성화/비활성화 절차

1. Flow Builder를 연다 — Setup Quick Find에 `Flows` 입력 → **Flows** 선택, 또는 Automation Lightning 앱의 **Flows** 탭, 또는 아무 Lightning 앱의 Flows 탭
2. 활성화/비활성화할 **버전**을 연다
3. 버튼 바에서 **Activate** 또는 **Deactivate** 클릭

**필요 권한:**

| 작업 | 권한 |
|---|---|
| Flow 활성화/비활성화 | Manage Flow |
| 트리거가 있는 autolaunched flow 활성화 | View All Data |

지원 에디션: Essentials, Professional, Enterprise, Performance, Unlimited, Developer (Classic + Lightning Experience).

---

## 어떤 버전이 실행되는가

autolaunched flow를 기동할 때 실행되는 버전은 **누가 기동하느냐**에 따라 다르다.

| 기동 주체 | 실행되는 버전 |
|---|---|
| Flow **user** (일반 사용자) | **활성(Active) 버전**. 활성 버전이 없으면 **최신(latest) 버전** |
| Flow **admin** (관리자) | 항상 **최신(latest) 버전** |

- 링크·버튼·탭으로 flow를 실행하는 최종 사용자는 활성 버전을 본다 — 관리자에게 더 최신 버전이 있을 수 있다.
- **inactive flow는 Manage Flow 권한이 있는 사용자만 실행**할 수 있다.
- 브라우저의 뒤로/앞으로 버튼으로 flow 화면을 이동하지 말 것 — flow와 Salesforce 간 데이터 불일치가 생길 수 있다.

---

## Flow 실행 접근 제한 (Limit User Access to Execute Flows)

사용자 레코드·프로필·권한 집합 기준으로 flow 실행 가능 사용자를 제한할 수 있다.

### 프로필·권한 집합으로 개별 Flow 접근 제한

직접 생성하거나 복제(clone)한 개별 flow에 대해 기본 동작을 오버라이드하고, 활성화된 프로필/권한 집합 보유자만 접근하도록 제한한다. 이 옵션을 켜면 **인터뷰를 resume하는 사용자도 그 flow에 대한 권한이 있어야** 한다.

1. Setup Quick Find에 `Flows` 입력 → **Flows** 선택
2. 대상 flow의 액션 메뉴에서 **Edit Access** 클릭
3. Apps에서 **Flow Access** 클릭
4. **Edit** 클릭
5. **Override default behavior and restrict access to enabled profiles or permission sets** 선택
6. 사용 가능한 프로필을 enabled profiles에 추가
7. 저장

### Guest User 프로필 — Flow Interview 공유 규칙

기본적으로 flow interview는 **시작한 사용자만 resume**할 수 있다. 다른 사용자에게 인터뷰 접근을 주려면 flow interview sharing rule을 쓴다. **Guest User 프로필의 개별 flow 접근은 프로필 페이지를 통해서만 제어**할 수 있다.

1. Guest User 프로필과 연결된 사이트의 Experience Builder에서 **Settings > General**
2. Guest User Profile 아래에서 프로필 이름 클릭
3. **Enabled Flow Access > Edit** 클릭
4. Guest User 프로필에서 flow를 추가/제거
5. 저장

### 접근 권한 체크 시점의 특성

- 권한은 **진입점(entry point)에서만** 체크된다 — flow가 시작(start)하거나 재개(resume)될 때.
- 권한은 **최상위(top level)에서만** 체크된다. 예: flow A가 flow B를 호출할 때, 사용자 X의 프로필이 A에는 접근 가능하고 B에는 불가능하면 — X는 **A를 통해서는 B를 실행할 수 있지만** B를 직접 실행할 수는 없다.

---

## Flow 실행 컨텍스트 (Flow Run Context)

Flow는 **user context** 또는 **system context**로 실행된다.

- **User context**: 실행 사용자(running user)의 프로필·권한 집합이 flow의 오브젝트 권한·필드 수준 접근을 결정한다.
- **System context**: flow의 접근 범위는 **with sharing / without sharing** 여부로 결정된다.

컨텍스트는 다음 flow 요소가 Salesforce 데이터로 할 수 있는 일에 영향을 준다: Action, Create Records, Delete Records, Get Records, Subflow, Update Records, 그 외 레코드 필드에 접근하는 모든 요소.

### 기동 방식별 기본 컨텍스트

기본적으로 flow는 **어떻게 기동됐느냐**에 따라 user 또는 system context로 실행된다. system context로 실행되는 flow는 Guest User 프로필 사용자를 포함한 **모든 사용자에 대해** 그 컨텍스트로 실행된다.

| Flow 기동 방식 | 기본 컨텍스트 |
|---|---|
| Apex | 코드에 따라 다름 (Depends on code) |
| Experience Cloud site | User |
| 커스텀 Aura 컴포넌트 안에 visual component로 임베드 | User |
| Visualforce 페이지 안에 visual component로 임베드 | User |
| Custom button | User |
| Custom link | User |
| Direct link | User |
| Flow action | User |
| Lightning page | User |
| Platform event | System context without sharing |
| Process (Process Builder) | System context without sharing |
| Record-triggered | System context without sharing |
| Rest API | User |
| 커스텀 Aura 컴포넌트 컨트롤러의 Apex 메서드에서 실행 | 코드에 따라 다름 (Depends on code) |
| Visualforce 컨트롤러의 Apex 메서드에서 실행 | 코드에 따라 다름 (Depends on code) |
| Schedule-triggered | System context without sharing |
| Web tab | User |

### Running User (실행 사용자)

Flow의 running user는 **flow를 기동한 사용자**다. user context flow에서는:

- running user의 프로필·권한 집합이 오브젝트 권한·FLS를 결정한다. flow가 데이터를 생성/조회/수정/삭제할 때 running user의 권한과 FLS를 강제한다. 예: running user에게 Account 오브젝트 edit 권한이 없는데 flow가 account 레코드를 업데이트하려 하면 에러. Account의 Rating 필드 edit 권한이 없는데 그 필드를 업데이트하려 해도 에러.
- **OWD, 역할 계층, 공유 규칙, 수동 공유, 팀, 테리토리**도 user context flow가 접근 가능한 데이터에 영향을 준다. 예: Opportunity OWD가 Private이고 running user에게 공유된 opportunity가 없으면 flow는 opportunity 레코드를 읽거나 수정할 수 없다.

### 제한사항 (Limitations)

- Screen component·local action 같은 Lightning 컴포넌트는 LWC 지원 API로 직접 데이터를 조회할 때 **항상 user context**로 실행된다.
- 컨텍스트가 "코드에 따라 다름"인 경우, Apex는 `with sharing` / `without sharing` 키워드로 OWD·역할 계층·공유 규칙·수동 공유·팀·테리토리 강제 여부를 지정한다. **Apex가 호출한 flow는 오브젝트·FLS 권한을 항상 무시**한다.
- record-triggered flow·schedule-triggered flow·process가 `inherited sharing` 선언 Apex 클래스의 invocable method를 호출하면, 그 invocable method는 **system context with sharing**으로 실행된다 (flow/process 자체는 system context without sharing).
- process가 flow를 기동하는 경우 process를 트리거한 사용자에게 추가 권한이 필요할 수 있다. 예: flow가 permission set license 할당을 저장하려는데 running user에게 Assign Permission Sets 권한이 없으면 에러.
- **Post to Chatter 액션을 실행할 때 flow는 항상 user context**로 실행된다.

### 실행 컨텍스트 변경 (Change the Flow Run Context)

일부 flow 버전은 **항상 system context로 실행**되도록 오버라이드할 수 있다.

1. Flow Builder에서 flow를 연다
2. 설정(기어) 아이콘 클릭
3. **Show Advanced** 클릭
4. **How to Run the Flow** 드롭다운에서 컨텍스트 선택 — 드롭다운이 없으면 해당 flow 타입은 컨텍스트 변경 불가

| 값 | 의미 |
|---|---|
| **User or system context** | 기동 방식에 따라 컨텍스트 결정 (기본) |
| **System Context with Sharing** | OWD·역할 계층·공유 규칙·수동 공유·팀·테리토리는 존중. 그러나 오브젝트 권한·FLS 등 running user 권한은 무시 |
| **System Context without Sharing** | **모든 데이터에 접근 가능** |

필요 권한: Manage Flow (Flow Builder에서 flow 열기/편집/생성).

### 시스템 컨텍스트 데이터 안전 가이드

Screen flow와 트리거 없는 autolaunched flow는 의도보다 많은 데이터를 노출할 수 있다. 외부 사용자가 접근하는 **Experience Cloud 사이트의 screen flow가 주된 위험 지점**이다. system context를 지름길로 쓰지 말고 FLS·레코드 수준 보안 권한을 제대로 구성하라. 불가피하게 system context로 실행해야 하면 **필요 최소한의 필드·레코드만** 사용한다.

**① Screen flow의 사용자 데이터 접근 제한**
- 가능하면 screen flow는 user context로 실행한다. system context(특히 without sharing)는 권한을 강제하지 않아 의도치 않은 데이터 공유 가능성이 커진다.
- screen flow 전체를 system context로 돌리지 말고, **권한이 필요한 작업만 수행하는 flow를 Subflow 요소로 기동**한다. 예: screen flow에서 permission set 할당이 필요하면 — system context로 실행되는 트리거 없는 autolaunched flow를 만들어 할당을 처리하고, screen flow(user context)에서 Subflow로 호출한다.

**② Get Records에서 특정 필드만 저장**
- system context로 오버라이드된 flow에서 Get Records 결과를 screen component·action·다른 flow로 넘길 때는 **Automatically store all fields 대신 Choose fields and let Salesforce do the rest**를 선택해 필드를 지정한다. 레코드 변수/컬렉션을 통째로 넘기면 flow는 어떤 필드가 필요한지 몰라 **사용자가 접근 가능한 모든 필드를 조회**한다.
- 예: Data Table 컴포넌트에 쓸 레코드 컬렉션은 Data Table에 표시하거나 화면에서 참조할 필드만 저장한다.

**③ Experience Cloud 사이트 flow에서 필드·레코드 지정**
- system context로 실행되는 Experience Cloud 사이트의 screen flow에서 Create/Update/Delete Records 요소를 쓸 때, 사용자가 편집하도록 의도한 필드·레코드로만 제한한다:
  - **Create Records**: How to set record field values에서 **Manually** 선택, 필드를 개별 지정
  - **Update Records**: **Specify conditions to identify records, and set fields individually** 선택 — 필터 조건으로 레코드를 찾고 업데이트 필드를 지정
  - **Delete Records**: **Specify conditions** 선택 — 필터 조건으로 삭제 레코드를 찾기
- 레코드 변수/컬렉션을 꼭 써야 하면 **Transform 요소로 먼저 편집 불가 필드를 걸러낸 뒤** 그 결과를 사용한다.

**④ Action Button이 트리거하는 screen action 점검**
- action button이 호출하는 autolaunched flow의 실행 컨텍스트를 확인한다 — screen flow와 다른 컨텍스트로 실행되어 데이터를 더 노출할 수 있다. 가능하면 user context 유지.
- action button이 호출하는 autolaunched flow는 **데이터 조회·계산에만** 사용한다. 레코드 생성/수정/삭제는 screen flow 본문 또는 Subflow로 기동한 별도 flow의 Create/Update/Delete Records 요소로 처리한다.
- screen action은 **그것이 구성된 Screen 요소 안에서만 참조**한다. 다른 곳에서 출력이 필요하면 그 autolaunched flow를 Subflow 요소로 다시 실행해 Subflow의 출력을 참조한다.

**⑤ Subflow로 기동되는 flow의 입출력 점검** (system context로 실행되는 참조 flow)
- 입력/출력 가용 변수는 **실제로 쓸 것만** 노출한다 — 안 쓰는 입출력 변수는 불필요한 데이터 노출 경로다.
- **추측하기 쉬운 입력값을 넘기지 않는다.** 예: `firstname.lastname@company.com` 패턴의 회사 이메일을 입력으로 쓰면 다른 레코드의 이메일을 추측해 접근할 수 있다.
- 참조 flow의 출력은 호출한 flow에서 직접 쓰는 값만 포함한다. 예: 연락처 생일 컬렉션만 필요하면 연락처 전체 정보나 계정 정보를 반환하지 않는다.

---

## Lightning Runtime vs Classic Runtime

배포 방식에 따라 사용자는 Classic runtime 또는 Lightning runtime UI로 flow를 실행한다. Lightning runtime은 Lightning Experience와 같은 look & feel이다.

- Visualforce 컴포넌트에서 실행되는 flow는 **항상 Classic runtime**.
- Lightning page·flow action·커스텀 Aura 컴포넌트에서 실행되는 flow는 **항상 Lightning runtime**.
- 그 외 방식은 조직의 Process Automation Settings에서 **Enable Lightning runtime for flows** 활성화 여부에 따른다 (설정 절차는 [[Flow 배포 위치 가이드]]의 URL 배포 절 참조).

| 배포 방식 | 설정 OFF 시 | 설정 ON 시 |
|---|---|---|
| Visualforce component | Classic runtime | Classic runtime |
| Custom button | Classic runtime | Lightning runtime |
| Custom link | Classic runtime | Lightning runtime |
| Web tab | Classic runtime | Lightning runtime |
| Direct link | Classic runtime | Lightning runtime |
| Flow action | Lightning runtime | Lightning runtime |
| Lightning page | Lightning runtime | Lightning runtime |
| Custom Aura component | Lightning runtime | Lightning runtime |

---

## 다른 조직으로 배포 (Distribute Flows to Other Orgs)

Flow는 **Lightning Bolt Solution, change set, 패키지**에 포함할 수 있다. **수신 조직에 flow가 활성화되어 있어야** 한다.

에디션: Bolt = Enterprise, Performance, Unlimited, Developer / Change set = Professional 이상 / 패키지 = Essentials 포함 전 에디션.

### Lightning Bolt Solutions

자동화 비즈니스 프로세스 배포 또는 Experience Builder 사이트 부트스트랩용. flow, 커스텀 Lightning 앱, Experience Builder 템플릿/페이지를 포함할 수 있다.

1. flow를 **flow category**에 추가한다 — **활성 flow만 추가 가능**
2. Lightning Bolt Solution 생성 — flow category, 커스텀 Lightning 앱, Lightning Community 템플릿/페이지 추가
3. 솔루션을 패키징해 자사 조직에 배포하거나 AppExchange에 공유/판매

필요 권한: flow category 생성 = Customize Application. Bolt Solution 생성 = Customize Application + View Setup and Configuration.

### Deploy as Active — 배포 시 Inactive로 오는 이유와 해제

**기본 동작:** sandbox·비프로덕션 조직에서 활성(Active) 상태인 process와 flow는 **production 조직에 Inactive로 배포**된다. 배포 후 새 버전을 **수동으로 재활성화**해야 한다.

production 조직에서는 change set 또는 Metadata API로 **새 활성 버전을 바로 배포하는 설정**을 켤 수 있다 — CI/CD 모델로 메타데이터를 배포한다면 이 옵션을 활성화한다.

- 이 설정은 **change set과 Metadata API로 배포되는 process·autolaunched flow**에 적용된다.
- developer·sandbox 등 **비프로덕션 조직에는 이 설정이 없다** — 그런 조직에는 언제나 새 활성 버전을 배포할 수 있기 때문.
- 에디션: Enterprise, Performance, Unlimited.

**설정 절차:**

1. Setup Quick Find에 `Automation` 입력 → **Process Automation Settings** 선택
2. **Deploy processes and flows as active** 선택
3. **flow 테스트 커버리지 퍼센트** 입력
4. 저장

필요 권한: Customize Application (process automation 설정 편집), Manage Flow (flow list view 생성/수정/삭제).

### Flow 테스트 커버리지 게이트

process·autolaunched flow를 active로 배포하려면 먼저 **flow 테스트 커버리지 요건을 충족**해야 한다. **최소 1개의 Apex 테스트**가 활성 process·autolaunched flow의 설정된 커버리지 퍼센트를 충족해야 한다. **화면(screen)이 있는 flow에는 테스트 커버리지 요건이 적용되지 않는다.**

**계산 방법:** ① 커버리지 유무와 무관한 모든 활성 flow 버전 수 + inactive이면서 최신 버전이고 커버리지가 있는 flow 버전 수를 구한다:

```sql
SELECT count_distinct(Id)
FROM Flow
WHERE Status = 'Active' AND Id NOT IN (
    SELECT FlowVersionId
    FROM FlowTestCoverage
)
+
SELECT count_distinct(FlowVersionId)
FROM FlowTestCoverage
```

② 커버리지가 있는 모든 최신 flow 버전 수는 전체 테스트 실행 후 **Tooling API `FlowTestCoverage` 오브젝트**로 구한다:

```sql
SELECT count_distinct(FlowVersionId)
FROM FlowTestCoverage
```

③ **② ÷ ① = flow 테스트 커버리지**.

**예시 (PDF 원문 그대로):** flow 총 10개. Flow A는 버전 2개 — 최신 버전은 inactive + 커버리지 있음, 첫 버전은 active + 커버리지 없음. Flow B–E는 각 1버전, inactive + 커버리지 있음. Flow F–J는 각 1버전, active + 커버리지 있음. → 커버리지 **90%**.

| Flow Label | Version | Status | Test Coverage |
|---|---|---|---|
| Flow A | 2 | Inactive | Yes |
| Flow A | 1 | Active | No |
| Flow B | 1 | Inactive | Yes |
| Flow C | 1 | Inactive | Yes |
| Flow D | 1 | Inactive | Yes |
| Flow E | 1 | Inactive | Yes |
| Flow F | 1 | Active | Yes |
| Flow G | 1 | Active | Yes |
| Flow H | 1 | Active | Yes |
| Flow I | 1 | Active | Yes |
| Flow J | 1 | Active | Yes |

커버리지가 있는 flow 이름 확인:

```sql
SELECT FlowVersion.Definition.DeveloperName
FROM FlowTestCoverage
GROUP BY FlowVersion.Definition.DeveloperName
```

커버리지가 **없는** 활성 autolaunched flow·process 이름 확인:

```sql
SELECT Definition.DeveloperName
FROM Flow
WHERE Status = 'Active'
AND (ProcessType = 'AutolaunchedFlow'
    OR ProcessType = 'Workflow'
    OR ProcessType = 'CustomEvent'
    OR ProcessType = 'InvocableProcess')
AND Id NOT IN (SELECT FlowVersionId FROM FlowTestCoverage)
```

### 패키징 고려사항 (Considerations for Packaging Flows)

flow는 managed/unmanaged 패키지에 포함할 수 있다.

**패키지 생성 시:**
- flow가 참조하는 모든 컴포넌트·필드는 **같은 패키지 또는 의존 패키지에 존재**해야 한다.
- **Post to Chatter, Send Email, Submit for Approval** 요소가 참조하는 패키징 가능 컴포넌트는 자동으로 패키지에 포함되지 않는다 — **수동으로 추가**해야 배포에 성공한다. 예: 특정 Chatter 그룹에 게시하는 flow면 그 그룹을 수동 추가.
- flow가 **CSP Trusted Site에 의존하는 Lightning 컴포넌트**를 참조하면, trusted site는 자동 포함되지 않는다.
- 패키지/패키지 버전 업로드 시 **활성 버전이 포함**된다. 활성 버전이 없으면 **최신 버전**이 패키징된다.

**패키지 업데이트 시:**
- managed 패키지를 다른 flow 버전으로 업데이트하려면: 그 버전을 활성화하고 패키지를 업로드하거나, 모든 버전을 비활성화하고 배포할 버전을 최신으로 만든 뒤 업로드한다. **실수로 잘못된 버전을 활성화한 채 업로드하면 그 버전이 모두에게 배포**된다.
- 같은 API 이름의 flow를 **unlocked 패키지**에서 설치하면 대상 조직의 기존 flow를 **덮어쓴다**.
- **패키지 패치(patch)에는 flow를 포함할 수 없다.**

**기타:**
- Flow Builder는 managed 패키지의 Apex 액션 중 **메서드가 `global`로 표시된 것만** 표시한다.
- Flow Builder는 managed 패키지의 email alert 중 **protected가 아닌 것만** 표시한다.
- Visualforce 페이지나 Apex 코드에서 flow를 참조한 **뒤에 네임스페이스를 등록**했다면, 패키지 설치 전에 flow 이름에 네임스페이스를 추가한다.
- managed 패키지에서 설치된 flow의 인터뷰 에러 이메일에는 **개별 flow 요소 상세가 포함되지 않는다.** 이메일은 flow를 설치한 사용자 또는 Apex exception email 수신자에게 발송된다.
- **flow trigger(workflow 액션)는 패키징할 수 없다.**
- 패키징 조직에서, released/beta **1GP managed 패키지에 업로드한 뒤에는 flow를 삭제할 수 없다.** flow **버전**은 다음 조건을 모두 충족하면 삭제 가능: ① Salesforce 고객 지원이 Managed Component Deletion 권한을 활성화함 ② 그 버전이 가장 최근에 패키징된 버전이 아님 ③ 그 버전이 active가 아님 ④ 그 버전이 유일한 버전이 아님
- 화면의 rich text 안 **이미지는 패키지에서 지원되지 않는다.**

### Change Set 고려사항

**Change set 생성 시:**
- change set에는 flow가 참조하는 **모든 컴포넌트를 포함**해야 한다.
- Component Dependencies 페이지는 **모든 버전의 의존성**을 나열한다 — 배포할 버전에 해당하는 상호 의존 컴포넌트를 outbound change set에 추가한다.
- **Post to Chatter, Send Email, Submit for Approval**이 참조하는 컴포넌트는 Component Dependencies 페이지에 표시되지 않는다 — 수동 추가 필요. 예: Submit for Approval 요소가 있으면 참조된 승인 프로세스를 수동 추가.
- CSP Trusted Site에 의존하는 Lightning 컴포넌트 참조 시, trusted site는 자동 포함되지 않는다.

**Change set 배포 시:**
- change set에는 **flow 버전을 1개만** 포함할 수 있다.
- change set의 **active flow는 대상 조직에 inactive로 배포**된다 — 배포 후 수동 활성화 (위 "Deploy as Active" 설정으로 해제 가능).
- outbound change set 업로드 시 flow에 활성 버전이 없으면 **최신 inactive 버전**이 사용된다.
- change set으로 flow를 배포/재배포하면 대상 조직에 **새 버전이 생성**된다.

**Flow trigger:** flow trigger(workflow 액션)는 change set에서 사용할 수 없다.

### 패키지에서 설치된 Flow 고려사항

- Flow Builder는 managed 패키지에서 설치된 flow를 **열 수 없다** — 단, flow가 **template**이거나 **overridable**이면 예외. template flow는 구독자가 보고 새 편집 가능 flow로 저장할 수 있다. non-template flow는 활성화/비활성화만 가능.
- 여러 flow 버전이 든 managed 패키지를 **새 조직에 설치하면 최신 버전만 배포**된다.
- unmanaged 패키지에서 설치한 flow가 조직 내 flow와 **이름은 같고 버전 번호가 다르면** 기존 flow의 최신 버전이 된다. **이름과 버전 번호가 모두 같으면 설치가 실패**한다 — flow는 덮어쓸 수 없다 (unlocked 패키지는 예외: 같은 이름이면 덮어씀).

**상태(Status):** 패키지 안에서 active인 flow는 **설치 후에도 active**다. 대상 조직의 기존 활성 버전은 새로 설치된 버전에 밀려 비활성화된다. 비활성화된 기존 버전으로 진행 중이던 flow는 **중단 없이 계속 실행**되지만 이전 버전의 내용을 반영한다.

**설치된 flow 배포:**
- managed 패키지에서 설치된 flow의 커스텀 버튼/링크/웹탭 URL 형식: `/flow/namespace/flowuniquename`
- Visualforce 임베드 시 name 속성 형식: `namespace.flowuniquename`

**업그레이드:** managed 패키지 업그레이드는 개발자 쪽에 더 새로운 flow 버전이 있을 때만 새 버전을 설치한다. 여러 번 업그레이드하면 **여러 flow 버전이 누적**될 수 있다.

**제거:**
- 설치된 패키지의 flow는 삭제할 수 없다 — 제거하려면 **비활성화 후 패키지를 언인스톨**한다.
- (패키징 조직 측 1GP flow 버전 삭제 조건은 위 "패키징 고려사항"과 동일)

---

## Flow Version Properties (버전 속성)

flow 버전의 속성은 flow 상세 페이지의 필드 값을 결정한다. 변경하려면 Flow Builder에서 버전을 열고 설정(기어) 아이콘을 클릭한다.

| 속성 | 설명 |
|---|---|
| **Flow Label** | 버전의 레이블. 상세 페이지·리스트 뷰에 표시되고 실행 시 헤더에 표시된다. **inactive flow·버전만 편집 가능** |
| **Flow API Name** | 다른 곳(URL, LWC 등)에서 이 flow를 참조하는 API 이름. 밑줄·영숫자만, 공백 불가, 문자로 시작, 밑줄로 끝나거나 연속 밑줄 불가. **저장 후 편집 불가** |
| **Description** | 다른 버전과의 차이 설명. inactive flow·버전만 편집 가능 |
| **Template** | template 여부. managed 패키지로 설치된 template은 구독자가 보고 새 편집 가능 flow로 저장 가능 (non-template은 활성/비활성만). 국가별 변형 flow의 베이스 식별 용도로도 사용 |
| **How to Run the Flow** | 실행 컨텍스트 (위 "실행 컨텍스트 변경" 참조) |
| **Type** | flow에서 지원되는 요소·리소스와 구현 방식 결정. **새 버전을 다른 타입으로 저장하는 것은 미지원** — 타입을 바꾸려면 새 flow로 저장. 타입별 상세는 [[Flow 종류와 변수]] 참조 |
| **API Version for Running the Flow** | flow가 채택하는 버전별 런타임 동작 개선을 결정. 변경에는 Manage Flow 권한 필요. 새 flow는 기본적으로 최신 API 버전으로 실행. 기존 flow를 새 flow/버전으로 저장하면 기존 run-time API 버전이 유지된다. **릴리스가 나와도 자동으로 바뀌지 않는다** — flow별로 원하는 시점에(또는 영원히 안) 올릴 수 있다 |
| **Interview Label** | 인터뷰(실행 인스턴스)의 레이블. Setup의 paused interview 리스트 뷰, Home/Experience Builder 사이트의 Paused Interviews 컴포넌트, 모바일 앱 Paused Interviews 항목, Lightning 페이지의 Actions & Recommendations 컴포넌트에 표시. 기본값은 flow 이름 + `{!$Flow.CurrentDateTime}`. text template으로 여러 리소스 참조 가능 — 예: `Flow Name - {!Account.Name} - {!$Flow.CurrentDateTime}` |

> Flow 메타데이터 타입의 XML 필드 정의(Metadata API 관점)는 [[Metadata Types — Automation]] 참조.

---

## 관련 노트

- [[Flow 배포 위치 가이드]] — 액션·URL·Lightning 페이지·Visualforce·Aura·외부 사이트 등 **어디에 심는가** (이 노트는 그 배포물의 버전·컨텍스트 수명주기)
- [[Flow 종류와 변수]] — processType(Type 속성)별 특성
- [[Metadata Types — Automation]] — Flow/FlowDefinition/FlowTest 메타데이터 필드 정의
- [[Change Sets 배포]] — change set 배포 절차 일반 (이 노트는 flow 특화 고려사항)
- [[Flow Interview API]] — Apex `Flow.Interview`로 flow 기동
- [[Flow 설계 베스트 프랙티스]]
