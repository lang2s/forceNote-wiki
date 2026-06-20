---
tags: [service, lightning-flow-for-service, actions-recommendations, recordaction, deployment, flow, next-best-action, open-cti]
source: salesforce_guided_engagement.pdf (Lightning Flow for Service Developer Guide, Spring '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.guided_engagement.meta/guided_engagement/
created: 2026-06-20
aliases: [Actions and Recommendations, Lightning Flow for Service, Salesforce Flow for Service, RecordAction, RecordActionDeployment, RecordActionHistory, guided engagement, guided action, 가이드 인게이지먼트, 액션 추천 컴포넌트, 액션 권장 사항]
---

# Lightning Flow for Service (Actions & Recommendations)

> **Actions & Recommendations 컴포넌트**로 레코드 페이지에 논리적 다음 단계(플로우·퀵액션·NBA 추천) 목록을 띄우는 Service Cloud 기능. 핵심은 **RecordAction 정션 객체**와 deployment. (`salesforce_guided_engagement.pdf` = Lightning Flow for Service Developer Guide, Spring '26)

---

## 개요 — Actions & Recommendations 컴포넌트

Salesforce Flow for Service와 **Actions & Recommendations 컴포넌트**는 사용자에게 "논리적 다음 단계" 목록을 보여준다. 액션을 레코드 페이지에 연결하는 방법은 세 갈래다 — **Actions & Recommendations deployment**, Salesforce 자동화 도구(Process Builder), **API**(SOAP·Apex·Metadata). 채널(phone·chat)별 기본 액션을 구성하고, 사용자가 먼저/마지막에 완료할 액션을 지정할 수 있다.

컴포넌트는 **RecordAction 정션 객체**의 목록을 표시한다. 하나의 RecordAction은 액션(스크린 플로우·필드 서비스 모바일 플로우·autolaunched 플로우·퀵액션)을 부모 레코드와 연결한다. 사용자가 Next Best Action 추천을 수락할 때도 RecordAction이 생성되어, 추천 안의 플로우를 레코드와 연결한다.

사용자가 목록의 한 단계를 클릭하면 해당 RecordAction의 액션이 실행된다. 첫 액션은 레코드 페이지가 열릴 때 **auto-launch**되도록 설정할 수도 있다.
- 스크린 플로우 → 콘솔 앱의 subtab, 표준 navigation 앱의 window에서 시작
- autolaunched 플로우 → 사용자가 시작을 확인하면 백그라운드 실행
- 퀵액션 → window에서 열림

컴포넌트가 돕는 일:
- 특정 레코드에 대해 어떤 단계를, 어떤 순서로 완료할지 식별
- Einstein Next Best Action 전략에서 나온 맞춤 액션·오퍼(할인·수리·부가 서비스 등) 고려
- 사용자가 일시정지한 플로우 재시작 + (stage가 정의됐다면) 활성 플로우의 stage 확인
- mandatory 플로우 식별·완료
- 구성된 subset에서 다른 액션을 찾아 시작
- 레코드에 대해 취해진 액션 히스토리(시작·일시정지·재개·완료 시점과 주체) 이해

> EDITIONS: Lightning Experience에서 사용 가능. Essentials, Professional, Enterprise, Performance, Unlimited, Developer Edition. (Lightning console 앱은 일부 제품의 Salesforce Platform user license 사용자에게 추가 비용으로 제공 — 일부 제한 있음.)

**설정 순서:** 컴포넌트를 페이지에 추가하기 전에 먼저 보여줄 플로우·퀵액션을 설정한다(추천을 포함하려면 Next Best Action 전략도 먼저 구성). 그다음 Actions & Recommendations deployment를 생성한다. deployment는 여러 페이지에서 재사용 가능한 설정을 담는다. 컴포넌트를 Lightning 페이지에 배치하고 component properties에서 deployment를 선택한다.

> recordId 입력 변수, stage, 일시정지/재개 등 플로우 자체의 메커니즘은 [[Screen Flow 설계]] · [[Autolaunched Flow 패턴]] · [[Flow 종류와 변수]] 참조.

### 지원 앱·채널·액션·객체

Lightning Flow for Service는 **Lightning console 앱과 standard navigation 앱**에서 지원된다. phone 통합(unknown caller 지원 포함)을 위해 Open CTI와, chat 통합을 위해 Lightning Experience의 Chat과 함께 동작하도록 설정할 수 있다.

컴포넌트에 포함 가능한 액션 유형:
- **Active screen flows, field service mobile flows, autolaunched flows**
  > autolaunched 플로우는 사용자 입력 없이 백그라운드 실행. 시간 간격이나 조건이 성립할 때까지 일시정지하도록 설계 가능. autolaunched 플로우가 일시정지하면 "플로우가 완료됨" 메시지를 보여주지만, 재개되면 아직 할 일이 남아 있는 상태다.
- **Quick actions** — 레코드 페이지 레이아웃에서 사용 가능한 것
- **Recommendations** — Next Best Action 전략 적용 결과

컴포넌트는 커스텀 Lightning 페이지를 포함한 대부분의 Lightning 페이지에서 지원된다. (커스텀 sharing rule이 일부 Lightning 페이지에서 지원을 제한한다.)

**지원하지 않는 페이지 (예시):** ContentDocuments · Events · Knowledge · Notes · Scorecard Associations · Scorecard Metrics · Tasks

**검증되지 않은(HAVEN'T VALIDATED) 객체:** AiDataset · AiVisionModel · CustomPersonAccountChild__p · CustomPersonChild__p · CustomPerson__p · LiveAgentSession · LiveChatVisitor · OpportunityLineItem · OpportunityLineItemSchedule · OrderItem · OrderItemTaxLineItem

### 동작 흐름

```
// 구조 예시 — 실제 PDF 다이어그램 아님
[Lightning 레코드 페이지 열림]
        │
        ▼
[Actions & Recommendations 컴포넌트] ── 선택된 deployment
        │
        │  표시 대상 = 부모 레코드와 연결된 RecordAction 목록
        │  (RecordAction 없으면 → 해당 채널의 channel defaults 표시)
        ▼
[사용자가 한 단계 클릭]
        │
        ├─ screen flow      → subtab(console) / window(standard nav)
        ├─ autolaunched     → 확인 후 백그라운드 실행
        ├─ quick action     → window
        └─ NBA 추천 수락     → RecordAction 생성 + 연결된 flow 실행
```

런타임에 에이전트는 **Add**를 눌러 구성된 subset에서 다른 액션을 검색·시작할 수 있고, **History** 탭에서 상태 변화를 확인한다. mandatory 액션 옆에는 asterisk(\*)가 표시된다.

---

## RecordAction 정션 객체

RecordAction은 하나의 **액션과 부모 레코드를 연결**하는 정션 객체다. 컴포넌트는 부모 레코드에 연결된 RecordAction 목록을 표시한다.

- **API version 42.0 이상**에서 사용 가능
- Apex에서는 **standard object**로 노출된다
- sObject 측면 정리는 [[Service Cloud Objects]] 참조

### RecordAction 필드 (관찰된 필드만)

> 이 가이드는 RecordAction의 전체 스키마를 제공하지 않는다. 아래는 가이드 본문·예제에서 **관찰된 필드만** 정리한 것이다. 전체 필드 reference는 **SOAP API Developer Guide의 RecordAction** 및 **Object Reference for Salesforce and Lightning Platform**을 참조.

| 필드 | 타입 | 설명 |
|---|---|---|
| `RecordId` | Id (Field Reference) | 부모 레코드 Id. 액션이 연결되는 레코드. (Process Builder UI 명칭은 "Parent Record ID") |
| `ActionDefinition` | String | 액션 정의 — 활성 플로우의 developer name 등 (예: `'New_Customer_Flow'`) |
| `Order` | Number | 같은 region(pinned/unpinned) 내 액션 정렬 순서. Order가 같으면 last modified date로 정렬 |
| `ActionType` | Picklist | 액션이 flow인지 quick action인지 (Apex 예제에서는 `'Flow'`) |
| `Pinned` | Picklist | `Top` / `Bottom` / `None`(unpinned region) |
| `Is Mandatory` (API: `mandatory`) | Boolean | True면 플로우가 required |
| `Hide Remove Action in UI` | Boolean | True면 사용자가 컴포넌트에서 Remove 옵션을 볼 수 없음 (단 API로는 여전히 삭제 가능) |

> Process Builder UI / API / Apex에서 같은 필드를 부르는 명칭이 다를 수 있다(예: `Is Mandatory` ↔ `mandatory`, `RecordId` ↔ `Parent Record ID`). 각 경로별 명칭은 아래 "액션을 레코드에 연결하기" 표 참조.

### Sharing — parent record 접근 기반

RecordAction 객체 접근 권한은 **연결된 부모 레코드에 대한 사용자의 접근**으로 결정된다. 이 sharing model은 user interface, API, Bulk API, Bulk API 2.0 접근에 모두 적용된다.

- 사용자가 액션이 연결된 레코드에 **read 접근**이 있으면, 대응하는 RecordAction에 대해 **모든 작업(create/read/update/delete)** 수행 가능
- 사용자가 플로우가 연결된 레코드에 read 접근이 **없으면**, 연결된 RecordAction에도 접근 불가

> SOQL 사용 시: **Modify All Data 권한이 없는 사용자**는 부모 레코드 기준 WHERE 절로 필터링해야 한다. 그러지 않으면 쿼리가 동작하지 않는다. Modify All Data가 있으면 WHERE 절 불필요.
>
> ```soql
> SELECT fields FROM RecordAction WHERE RecordId=ENTITY_ID
> ```
>
> RecordAction 대상 SOQL 패턴·필터 일반 원칙은 [[SOQL 패턴]] 참조.

---

## Deployment (Actions & Recommendations deployment)

deployment는 **여러 페이지에서 재사용 가능한 컴포넌트 설정**을 담는다. Setup에서 정의하거나, metadata type **`RecordActionDeployment`**로 프로그래밍적으로 정의할 수 있다.

### Deployment 설정 항목

deployment를 구성할 때 정의하는 설정:

| 설정 | 내용 |
|---|---|
| Type of guidance | 최소 하나 선택 — `Flows and quick actions` 또는 `Recommendations`. (편집 시 한 유형을 해제하면 관련 설정이 삭제됨) |
| Context objects | object-specific 퀵액션·action strategy에 쓸 객체 지정. **최대 10개**. 선택 객체 페이지가 열리면 global + object-specific 액션·추천 표시, 그 외 페이지는 global만 표시 |
| Channel defaults | 채널별로, 레코드가 그 채널에서 열리고 **다른 RecordAction 연결이 없을 때** 나타나는 기본 액션 정의 |
| Additional actions | 런타임에 사용자가 Add로 시작할 수 있는 액션 정의. Add 후 선택하면 해당 액션이 시작되고, 현재 레코드와 연결하는 RecordAction이 생성됨 |
| Recommendation settings | NBA 추천 표시 방법, 표시 개수(**1~4**), 사용할 action strategy 지정 |

설정 절차(Setup):
1. Quick Find → "Actions & Recommendations" 선택
2. **New Deployment** → 이름 지정 → guidance 유형 선택
3. context 객체 선택(최대 10). object-specific 퀵액션을 쓰려면 해당 객체의 레코드 페이지 레이아웃에 추가해야 함
4. (Flows and quick actions 선택 시) 각 채널의 default 목록 구성:
   - 탭에서 채널 선택(Chat / Phone / Default)
   - "All Actions"에서 preview 영역으로 액션 드래그. preview 영역은 **Top Pinned / Unpinned / Bottom Pinned** 세 region
   - 중요 액션 선택 후 **Mark Mandatory** (퀵액션·autolaunched 플로우는 reminder 없음)
   - Remove 막을 액션 선택 후 **Unmark Removable** (기본은 모두 removable)
   - 레코드 페이지 열릴 때 첫 액션 auto-launch 여부 지정 → Save
5. (Flows and quick actions 선택 시) Add로 시작 가능한 액션 subset 좁히기
6. (Recommendations 선택 시) General Settings 탭에서 표시 방식·default strategy 설정(최대 추천 수 1~4), Strategy Settings 탭에서 페이지별 object-specific strategy override → Save
7. Lightning App Builder에서 컴포넌트를 페이지에 추가하고 deployment 선택

> deployment를 선택하지 않으면 Add 클릭 시 액션이 나타나지 않고, 다른 RecordAction이 없는 한 컴포넌트는 빈 상태다.

### 채널·region·기본값 우선순위

**채널 3종:**
- **Chat** — Lightning Experience의 Chat(Omni-Channel routing). 사용하려면 chat transcript 레코드 페이지에 컴포넌트 추가
- **Phone** — Open CTI. 사용하려면 softphone screen pop 설정(no matching / single-matching) 갱신
- **Default** — list view·related record에서 레코드가 열릴 때

(Chat·Phone 채널은 해당 기능이 org에 없어도 탭에 표시된다. Open CTI는 보통 Phone + Default 채널을 함께 구성.)

**channel defaults 적용 우선순위 (중요):**
- 컴포넌트는 **다른 RecordAction이 전혀 없고 AND 레코드 페이지가 그 채널에서 열렸을 때만** channel defaults를 표시한다.
- Process Builder/API로 RecordAction을 만들면, 컴포넌트는 channel defaults 대신 **그 RecordAction들**을 표시한다 → channel defaults는 보이지 않는다.
- 기존 deployment에 default 액션을 추가하면, 사용자는 **새 레코드에서만** 그 액션을 본다.

**Pinned region 3종:** Top Pinned(먼저 완료) / Unpinned(레코드 생애 동안) / Bottom Pinned(마지막 완료). 각 단계의 pulldown 메뉴 Move Up·Move Down은 **같은 region 안에서만** 재정렬한다.

---

## 사용자 경험 강화 (Enhance) — 7개 옵션

컴포넌트 목록 사용 방식을 미세 조정하는 7가지 옵션. 각 옵션은 보통 **deployment(channel defaults) / Process Builder / API** 세 경로로 설정한다. 아래 표가 세 경로를 통합한다.

| 옵션 | 효과 | Deployment (channel defaults) | Process Builder | API |
|---|---|---|---|---|
| **Show Top Recommendations** | Einstein NBA 전략의 top 추천 표시 | deployment에서 Recommendations 구성 (전략 선택·표시 방식) | — (deployment 또는 API 필요) | metadata type `RecordActionDeployment`로 구성 |
| **Resume Paused Flows** | 현재 레코드에 연결된 일시정지 플로우 표시·재개 | Process Automation Settings에서 pause 허용 후, 컴포넌트가 자동 표시 | — | — |
| **Pin Steps (First/Last)** | 액션을 top/bottom에 pin | preview 영역에서 region으로 드래그 | `Pinned` 속성에 Top/Bottom/None 지정 | `Pinned` 속성 설정 |
| **Complete Mandatory Steps** | required 단계 강조(닫으려 하면 reminder) | preview에서 액션 선택 → mandatory 표시 | `Is Mandatory` = True | `mandatory` 필드 = True |
| **Hide Remove Option** | Remove 옵션 숨김(완료 전 제거 불가) | preview에서 not removable로 표시 | `Hide Remove Action in UI` = True | RecordAction의 해당 속성 설정 |
| **Find Another Action** | Add로 subset에서 다른 액션 검색·시작 | Setup deployment에서 Add 시 보일 액션 선택 | — | Metadata API로 deployment의 액션 정의 |
| **View Action History** | 어떤 액션이 누가·언제 시작했는지 History 탭 | (컴포넌트 기본 제공) | — | `RecordActionHistory` 객체로 조회 |

세부 동작 메모:
- **Recommendations:** accept/reject 버튼 라벨은 **10자 미만**으로 — 그래야 버튼이 나란히 표시됨. NBA 자체 개념은 본 노트 범위 밖(아래 "채널 통합" 외 간략 서술).
- **Resume Paused Flows:** 컴포넌트는 목록에서 시작하지 않은 플로우를 포함해 현재 레코드에 연결된 **모든** 일시정지 플로우를 표시. 재개하면 목록에 추가됨(pinned region에서 시작됐으면 그 region 끝에, 아니면 unpinned region 하단). 플로우는 `Flow.CurrentRecord` 변수로 현재 레코드를 추적하며, 레코드 컨텍스트가 바뀌면(예: lead → contact 전환) 일시정지 플로우는 원래 레코드 목록에 안 나타나고, 새 레코드로 안내하는 메시지가 표시됨. (pause/resume·CurrentRecord 메커니즘 일반론은 [[Flow 종류와 변수]] 참조)
- **Mandatory reminder:** **screen flow·field service mobile flow**에만 reminder가 나타남. **퀵액션·autolaunched 플로우**는 mandatory여도 reminder 없음. 런타임에 mandatory screen flow를 완료 전 닫으려 하면 메시지 표시 → Cancel(경고 무시·계속) 또는 Finish Later(탭/window 닫음, 나중에 새 인스턴스 시작).
- **Hide Remove Option:** Remove를 숨겨도 **API로는 여전히 제거 가능**.
- **Find Another Action:** 추가된 액션은 시작되고, bottom-pinned 액션 위에 추가됨.

### 액션 히스토리

History 탭은 레코드에 연결된 액션의 **상태 변화(started/paused/resumed/completed)**를 나열한다. 핸드오프·에스컬레이션 시 갭을 파악하고 다음 단계를 결정하는 데 쓰인다.

- 최근 **20개** 상태 변화를 최신순으로 표시. **View More**로 다음 20개 확인
- 상태별 필터 가능 — 단, 필터는 **마지막 200개** 액션에만 적용

**API로 조회 — `RecordActionHistory` (big object):**
- **read-only**, **API version 44.0 이상**에서 사용 가능
- synchronous·asynchronous 쿼리 모두 지원 (SOQL/SOAP/REST/Bulk/Apex)
- synchronous 쿼리는 특정 패턴을 따라야 하며(아니면 실패), 패턴·예제는 Object Reference 참조
- Analytics 접근 권한이 있으면 RecordActionHistory를 쿼리해 대시보드 구성 가능(기간별 started/paused/resumed/completed 비교 등)

> RecordActionHistory가 big object로서 갖는 동기/비동기 쿼리 제약·인덱스 패턴 일반론은 [[Big Objects]] 참조.

---

## 액션을 레코드에 연결하기

선언적으로 연결 → deployment의 channel defaults 또는 Process Builder. 프로그래밍적으로 연결 → SOAP 또는 Apex. 모든 방법이 결국 **RecordAction을 생성**한다.

> NBA 추천을 보여주려면 deployment 또는 API를 써야 한다 — Process Builder로는 추천을 표시할 수 없다(트리거 조건이 있을 때 flow·quick action만 표시).

### Deployment로 연결

phone screen popup, chat, list view, related record에서 레코드가 열릴 때의 default 액션을 보여준다. NBA 추천도 deployment로 표시 가능. 설정 절차는 위 "Deployment 설정 항목" 참조.

### Process Builder로 연결 (필드값 표)

Process Builder는 새/수정 레코드가 기준을 충족할 때 시작되는 프로세스를 설계하는 point-and-click 도구다. 트리거 시 **RecordAction을 생성**하는 프로세스를 만든다.

> Process Builder로 액션을 연결하면 deployment의 channel defaults를 **override**한다.

절차:
1. 프로세스 속성 정의
2. 프로세스 트리거 구성
3. 프로세스 criteria 추가
4. 프로세스에 액션 추가 → **"Create a Record"** 액션으로 레코드 생성 (액션은 Process Builder에 나타난 순서로 실행)
   - **Action Type: `Create a Record`**
   - **Record Type: `RecordAction`**
5. 프로세스 활성화

> **주의 — "Flows" Action Type ≠ RecordAction 생성:** Process Builder의 Action Type `Flows`는 화면 없는(screenless) 플로우만 지원하고, 프로세스 트리거 시 **즉시 invoke**된다. RecordAction을 생성하는 것은 플로우를 invoke하지 않고, 레코드와 플로우를 **연결**해 사용자가 나중에 실행하게 한다. **플로우·퀵액션을 레코드에 연결하려면 반드시 RecordAction을 생성해야 한다.**

**"Create a Record" 액션의 필드값 (전수):**

| Field | Type | Value |
|---|---|---|
| Action | Picklist | 레코드와 연결할 액션을 지정 |
| Action Type | Picklist | 액션이 flow인지 quick action인지 지정 |
| Order | Number | 이 레코드에 연결된 모든 액션 중 순서 지정. pinned/unpinned region 내 다른 액션과 비교해 정렬. Order가 같으면 last modified date로 정렬 |
| Parent Record ID | Field Reference | 액션이 연결될 레코드 지정. 대부분 프로세스 트리거 객체의 ID 선택 (예: contact 객체 사용 시 `[Contact].Id`) |
| Is Mandatory | Boolean | True면 플로우 required. mandatory screen flow 실행 후 사용자가 탭/window를 닫으려 하면 완료 reminder 메시지 표시. 퀵액션·autolaunched 플로우는 reminder 안 나타남 |
| Hide Remove Action in UI | Boolean | True면 사용자가 컴포넌트에서 액션의 Remove 옵션을 못 봄. 단 API로는 여전히 삭제 가능 |
| Pinned | Picklist | 액션을 top/bottom 중 어디에 pin할지 지정. unpinned region에 표시하려면 None 사용 |

예시(개념): contact의 `MobilePhone` 필드가 변경될 때, 정보 확인용 `Verify_Information` 플로우를 required로 연결하는 프로세스. 활성화 후 MobilePhone이 바뀌면 Verify Information 플로우가 contact 레코드의 subtab으로 열리고, mandatory를 나타내는 asterisk가 표시된다. (Process Builder "Create a Record" 자체의 일반 사용법은 본 가이드 범위 밖.)

### SOAP로 연결

Salesforce 플랫폼 밖에서 코드를 유지하는 경우, **SOAP API**로 RecordAction을 create·retrieve·update·delete할 수 있다.
- RecordAction은 **API version 42.0 이상**에서 사용 가능
- 요청 body 예제는 이 가이드에 없음 — **SOAP API Developer Guide: RecordAction** 참조

### Apex로 연결

RecordAction 생성 트리거 방식을 제어하려면 Apex 사용. RecordAction 객체는 Apex에서 standard object로 노출되며, **DML 전(before) / delete·undelete 시** 트리거할 수 있고 커스텀 에러 핸들링도 가능하다 (API version 42.0 이상).

Apex가 더 적합한 시나리오:
- after가 아니라 **before DML**에 트리거
- **delete·undelete** DML 작업에 트리거
- 액션 실행 전 데이터 검증
- 커스텀 에러 핸들링
- complete failure가 아니라 partial completion

아래 예제는 Apex class + trigger 쌍으로, 특정 기준(type == Customer)을 만족하는 새 account에 플로우를 연결한다. class의 메서드는 account 리스트를 받아 각각에 대해 RecordAction을 생성하고, 새 account를 `RecordId`로, 활성 플로우를 `ActionDefinition`으로 설정한다. trigger는 account insert 후(after insert) 호출된다.

```apex
public class RecordActionHandler {
    public static void addNewCustomerFlow(Account[] accts) {
        RecordAction[] recordActions = new List<RecordAction>();
        for (Account a : accts) {
            RecordAction ra = new RecordAction(RecordId=a.Id,
ActionDefinition='New_Customer_Flow', Order=1, ActionType='Flow');
            recordActions.add(ra);
        }

            try {
                insert recordActions;
            } catch (DMLException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
      }
}
```

```apex
trigger RecordActionTrigger on Account (after insert) {
    Account[] customerAccounts = new List<Account>();
    for (Account a : Trigger.new) {
        if (a.Type == 'Customer') {
            customerAccounts.add(a);
        }
    }
    RecordActionHandler.addNewCustomerFlow(customerAccounts);
}
```

> 위 trigger는 일반적인 trigger handler 형태다 — trigger ↔ handler 분리, bulk DML, `DMLException` 처리 패턴 일반론은 [[TriggerHandler 패턴]] 참조.

---

## 컴포넌트로 Lightning 페이지 커스터마이즈

Actions & Recommendations 컴포넌트는 부모 레코드에 연결된 RecordAction을 표시한다. 컴포넌트는 대부분의 객체에 대해 Lightning console·standard navigation 페이지에 추가할 수 있다(지원 객체는 위 "지원 앱·채널·액션·객체" 참조).

먼저 사용자 경험을 계획한다(언제 컴포넌트를 보여줄지, 어떤 레코드 페이지인지, 함께 보여줄 정보는 무엇인지). 레코드 페이지를 정한 뒤 Lightning App Builder의 **pinned region template**으로 커스텀 Lightning 페이지를 만든다. pinned region 페이지는 console 앱에서 플로우가 subtab으로 열리는 동안 컴포넌트를 계속 표시할 수 있게 한다.

1. 컴포넌트 추가 전 Actions & Recommendations deployment 생성
2. Lightning App Builder에서 컴포넌트를 페이지의 pinned region으로 드래그 (Service Console 앱은 **왼쪽 pinned sidebar** 권장)
3. component properties에서 deployment 선택 (선택 안 하면 Add 시 액션이 안 나타나고, 다른 RecordAction이 없는 한 컴포넌트가 빈 상태)
4. Lightning 페이지 저장 → 필요 시 활성화·앱 할당

> 컴포넌트가 부모 레코드 ID를 플로우로 넘길 때, 플로우는 **case-sensitive**한 `recordId` 입력 변수를 정의해야 한다.
>
> ```
> // 구조 예시 — 실제 동작 코드 아님
> Flow text input variable
>   Name:  recordId      ← 정확히 이 철자 (case-sensitive)
>   Type:  Text
> ```
>
> 부모 레코드 ID를 플로우로 넘기려면 **`recordId`라는 이름의 flow text input variable**을 만든다. 이름은 **case-sensitive**다. 컴포넌트에서 플로우를 실행하면 부모 레코드 ID가 이 변수로 전달된다. (recordId 변수 설계 일반론은 [[Screen Flow 설계]] 참조.)

---

## 채널 통합

### Chat 통합

Lightning Flow for Service는 **Lightning Experience의 Chat**(Omni-Channel routing)을 지원한다. 액션은 Chat Transcript primary 탭의 **subtab**으로 표시되어, 에이전트가 chat 맥락에서 비즈니스 프로세스를 볼 수 있다.

1. 액션 설정 — Flow Builder로 플로우 생성, 퀵액션 생성 후 레코드 페이지 레이아웃에 추가
2. deployment 생성 — **Chat 채널** 설정에서 default 액션 지정(먼저/마지막 완료, 첫 플로우 auto-launch 여부, Add 시 보일 액션)
3. Lightning console 레코드 페이지 생성:
   - Chat Transcript 객체에 대해 **"Console: Pinned Left and Right Sidebars"** 페이지 템플릿으로 레코드 페이지 생성
   - 왼쪽 컬럼에 Actions & Recommendations 컴포넌트 추가 + component properties에 deployment 이름 지정
   - 오른쪽 컬럼에 Chat Body 컴포넌트 배치

### Open CTI 통합

Open CTI는 third-party 텔레포니 서비스를 Salesforce와 통합하는 API 집합이다. Lightning Flow for Service는 **세 개의 Open CTI 메서드**를 활용한다: `getSoftphoneLayout()`, `screenPop()`, `searchAndScreenPop()`.

1. Open CTI 구현을 갱신해 incoming call이 플로우로 screen-pop되게 한다. 전화번호·고객명 등 call data를 screen-pop 시 플로우로 직접 넘길 수 있다.
   - **Open CTI API version 42.0 이상** 사용, 메서드: `getSoftphoneLayout()` · `screenPop()` · `searchAndScreenPop()`
   - 플로우는 input variable(= argument)을 받을 수 있다. 컴포넌트는 레코드 페이지에서 자동으로 부모 레코드 ID를 플로우로 넘기려 시도하며, 이를 쓰려면 플로우가 `Text` 타입 `recordId` 입력 변수를 정의한다.
   - 더 복잡한 변수 전달: 단일 변수와 collection 변수(list·array 등)는 `screenPop`·`searchAndScreenPop` 메서드의 **`flowArgs` 파라미터**로 넘길 수 있다.
2. 플로우 생성 — 예: Salesforce에 caller 매치가 없을 때의 **Unknown Caller** screen flow (First Name·Last Name·Phone Number·Address 입력 화면 → Create Records 요소로 contact 생성)
3. softphone 레이아웃에서 screen-pop 설정 (Setup → Softphone Layouts):
   - **No matching records** → "Pop to flow" 선택 → Unknown Caller 플로우 선택 (이때 플로우는 console의 **primary 탭**으로 열림)
   - **Single-matching records** → "Pop detail page" 선택 (예: contact 레코드 페이지 pop)
4. deployment 생성 + **phone 채널** default 액션 구성
5. 레코드 페이지에 컴포넌트 추가 + deployment 선택. 통화가 레코드와 매치되어 사용자가 그 페이지로 popped되면, 해당 통화에 완료할 액션을 본다

> Open CTI 메서드 시그니처·argument 전달 세부는 **Open CTI Developer Guide** 참조. (현재 위키에 Open CTI 전용 노트 없음 — 외부 가이드 참조.)

---

## Considerations (Packaging · Change Sets · Sharing)

### Packaging

패키지에는 Actions & Recommendations **deployment 설정**이 포함된다. RecordAction을 통해 플로우를 참조하는 process·flow도 함께 포함된다(예: Flow A가 Flow B를 참조하는 RecordAction을 만들면, Flow A를 패키지에 추가하면 Flow B도 추가됨).

앱을 패키지에 추가할 때 포함되는 것:
- 앱의 모든 객체
- 각 객체의 page layout, Lightning 페이지(컴포넌트가 있는 페이지 포함), active process, quick action. deployment와 그 설정 포함
- deployment가 flow action을 참조하면 그 플로우들 포함
  > 패키지 생성 전 deployment의 플로우가 **active**인지 확인. inactive 플로우는 패키지 설치 실패를 유발할 수 있다.
- process가 flow action을 포함하면 그 플로우들 포함
- 객체가 flow quick action을 포함하면 그 플로우들 포함

### Change Sets

change set에 **"RecordAction Deployment"** 컴포넌트를 추가할 수 있다. Process Automation Settings의 "Deploy processes and flows as active" 옵션이 플로우를 active/inactive 중 무엇으로 배포할지 결정한다. 이 옵션이 설정되지 않으면 플로우는 inactive로 배포된다. change set으로 sandbox→production 이동 후 플로우가 active인지 확인할 것.

> Packaging·Change Sets·active/inactive 배포 일반론은 [[2GP Managed Package 개념과 1GP 비교]] 참조.

### Sharing Model

RecordAction 접근은 부모 레코드 접근 기반이다 — 위 "Sharing — parent record 접근 기반" 참조.

---

## 구현 체크리스트 & 권한

권장 사전 지식: process automation 도구(Process Builder·Flow Builder), (추천을 보여줄 경우) Einstein Next Best Action, Lightning App Builder, Lightning console·standard navigation 앱.

> 아래 권한표는 PDF 렌더 이미지 대비 검증됨. **일부 셀은 PDF에서 의도적으로 BLANK**(권한 명시 없음)이며, 그대로 보존한다.

**TABLE A — User Permissions Needed (end-to-end 구현)**

| Task | Permission(s) |
|---|---|
| To create flows in Flow Builder: | Manage Flow |
| To create quick actions: | Customize Application |
| To manage deployments in Setup that include flows and quick actions: | _(PDF에서 BLANK — 권한 명시 없음)_ |
| To manage deployments in Setup that include recommendations: | Modify All Data OR Manage Next Best Action Strategies |
| To view Actions & Recommendations deployments in component properties: | View Setup and Configuration |
| To create a process in Process Builder: | Manage Flow AND View All Data |
| To create and save pages in the Lightning App Builder: | Customize Application |
| To create or manage Lightning apps: | _(PDF에서 BLANK — 권한 명시 없음)_ |
| To set up and configure Chat: | _(PDF에서 BLANK — 권한 명시 없음)_ |
| To set up and configure Open CTI: | Manage Call Centers |

**TABLE B — User Permission Needed (플로우 실행)**
> 데이터를 변경하는 플로우는 관련 레코드·필드에 대한 create/read/edit/delete 권한이 필요하다.

| Task | Permission(s) |
|---|---|
| To run flows: | Flow User OR (user detail 페이지에서 Flow User 필드 활성화) OR Manage Flow OR (개별 플로우에 "Override default behavior and restrict access to enabled profiles or permission sets"가 선택된 경우, 해당 플로우 접근은 profile/permission set 단위로 부여) |

**TABLE C — User Permission Needed (추천 설정)**

| Task | Permission(s) |
|---|---|
| Display Recommendations as a tab: | Default On for Tab Setting for Recommendations object |
| Create and manage recommendations: | Modify all data OR Manage Next Best Action Recommendations |

**TABLE D — User Permission Needed (action strategies)**

| Task | Permission(s) |
|---|---|
| To create or manage action strategies: | Modify All Data OR Manage Next Best Action Strategies |
| To run an action strategy: | Run Flows OR (user detail 페이지에서 Flow User 필드 활성화) |

**TABLE E — 개별 setup task ("Complete If...")**

| Task | Complete If... |
|---|---|
| Create Actions to Show | 컴포넌트에 보일 flow·quick action·recommendation을 만들려 함 |
| Associate Actions to Records with a Deployment | 컴포넌트 설정(guidance 유형·channel defaults·런타임 추가 액션)을 정의하려 함. Metadata API로도 deployment 생성 가능 |
| Associate Actions to Records with Process Builder | Process Builder로 선언적 프로세스를 만들려 함. 레코드가 기준을 충족할 때 자동으로 액션 연결 |
| Associate Actions to Records with SOAP | SOAP API로 프로그래밍적으로 액션을 레코드에 연결하려 함 |
| Associate Actions to Records with Apex | Apex로 프로그래밍적으로 액션을 레코드에 연결하려 함 |
| Customize Your Lightning Pages with the Actions & Recommendations Component | 앱의 레코드 페이지에 컴포넌트를 추가하려 함 |
| Integrate Chat with Lightning Flow for Service | Chat과 통합하려 함 |
| Integrate Open CTI with Lightning Flow for Service | Open CTI와 통합하고 softphone screen pop 설정을 구성하려 함 |

---

## 관련 노트
- [[Screen Flow 설계]]
- [[Autolaunched Flow 패턴]]
- [[Flow 종류와 변수]]
- [[TriggerHandler 패턴]]
- [[SOQL 패턴]]
- [[Big Objects]]
- [[Service Cloud Objects]]
- [[2GP Managed Package 개념과 1GP 비교]]
