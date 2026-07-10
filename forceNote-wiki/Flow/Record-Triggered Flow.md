---
tags: [flow, record-triggered, before-save, after-save, fast-field-update, scheduled-path, asynchronous-path, trigger-order, entry-condition, automation]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26) — Flow Types p.27 · Triggers for Autolaunched Flows pp.30–38 · Record-Triggered Flow Considerations pp.273–275 · $Record 레퍼런스 p.293 · Switch to Flow Builder pp.885–890; XML enum 보강 = Metadata API Developer Guide v67.0 (Summer '26) Flow 타입 pp.1298–1300
created: 2026-07-10
aliases: [Record-Triggered Flow, 레코드 트리거 플로우, before-save flow, after-save flow, Fast Field Update, 패스트 필드 업데이트, Scheduled Path, 스케줄드 패스, Asynchronous Path, 비동기 경로, Trigger Order, 트리거 순서, Flow Trigger Explorer, 진입 조건, entry condition, $Record, $Record__Prior]
---

# Record-Triggered Flow

> 레코드 생성·수정·삭제 시 자동 실행되는 가장 많이 쓰이는 Flow 타입의 허브 노트 — 4가지 하위 타입, before-save(Fast Field Update) vs after-save vs Run Asynchronously 실행 모델, Start 요소 트리거·진입 조건 옵션 전수, `$Record`/`$Record__Prior`, Scheduled Path(한도·재시도·배칭), Trigger Order(1–2,000 정렬 규칙), Flow Trigger Explorer.

---

> **소관 분리** — 이 노트는 Record-Triggered Flow **자체의 메커니즘·레퍼런스**를 다룬다.
> - Flow로 할지 Apex Trigger로 할지 **결정 기준**(자동화 밀도·하이브리드 패턴) → [[Record-Triggered Flow vs Apex Trigger 선택]]
> - Fast Field Update 우선 원칙·진입 조건 최적화·바이패스·거버너 한도 등 **설계 원칙** → [[Flow 설계 베스트 프랙티스]]
> - processType·변수(XML `<variables>`)·전역 변수 일반 → [[Flow 종류와 변수]]
> - 저장 트랜잭션 내 before-save flow → Apex trigger → after-save flow의 **전체 실행 순서(20단계)** → [[Trigger Order of Execution]]

**Editions** (PDF 원문): Available in Essentials, Professional, Enterprise, Performance, Unlimited, and Developer Editions — Salesforce Classic(일부 org 제외)·Lightning Experience 모두.

---

## 1. Record-Triggered 계열 4가지 타입 (Flow Types 매트릭스 발췌, p.27)

| 타입 | 설명 (원문 요지) | 실행 특성 |
|---|---|---|
| **Record-Triggered Before Save Flow** | 레코드가 생성·수정된 **직후, 아직 저장되기 전** 실행. 지원 요소는 **Assignment · Decision · Get Records · Loop 4개뿐** | **트리거된 레코드 자신만** 변경 가능. 백그라운드 실행, 사용자 상호작용 없음 |
| **Record-Triggered After Save Flow** | 레코드 변경이 **저장된 후** 또는 레코드 삭제 시 실행 | 트리거 레코드의 **관련 레코드**를 변경 가능. 백그라운드 실행 |
| **Record-Triggered Before Delete Flow** | 레코드가 삭제될 때 실행 — 레코드가 **삭제 플래그(flagged for deletion)** 된 시점에 동작 | 백그라운드 실행 |
| **Record-Triggered After Save Orchestration** | 레코드 생성·수정 시 실행되는 **다단계·다사용자 프로세스**(오케스트레이션). 레코드 트리거 오케스트레이션은 생성·수정 시에만 실행 | 배포: Autolaunched orchestration은 커스텀 Apex 클래스·커스텀 버튼/링크로도 실행 |

> after-delete·after-undelete 컨텍스트는 Flow Types 매트릭스에 **존재하지 않는다** — 해당 요구는 Apex Trigger 영역 ([[Record-Triggered Flow vs Apex Trigger 선택]]의 하이브리드 한계 절 참조).

---

## 2. 실행 모델 — 3가지 최적화 옵션 (원문 표, p.889)

Start 요소에서 flow를 어느 시점에 실행할지 최적화 옵션을 고른다. PDF "Optimize Your Record-Triggered Automations" 표 전수:

| 옵션 | 실행 시점 (When the Flow Runs) | 용도 (When to Use It) | 이점 (Benefit) |
|---|---|---|---|
| **Fast Field Update** (before-save) | 트리거한 레코드 업데이트 **도중, 저장 전** | 트랜잭션을 트리거한 **그 레코드**를 업데이트할 때 | 트리거 레코드 업데이트로 한정되므로 **최적 성능** |
| **Related Records and Actions** (after-save) | 트리거한 레코드 업데이트 도중, **저장 후** | 다른 레코드 생성·수정·삭제 / Subflow 호출 / 액션 호출(이메일 얼럿·Chatter 포스트 등) | 레코드 변경으로 촉발되는 일반 프로세스 자동화 |
| **Run Asynchronously** (비동기 경로) | 트리거한 레코드 업데이트가 **완료된 직후** 별도 실행 | 외부 시스템 요청 전송, 장기 실행 프로세스 등 고급 시나리오 | 트리거한 레코드 업데이트를 **지연·차단하지 않음** |

### 2-1. Before-Save (Fast Field Update) 상세 (pp.32–33)

- 레코드 생성·수정이 flow를 트리거해 **DB 저장 전에 그 레코드를 추가 업데이트**한다. record-change process(Process Builder) 대비 **10배 빠르다**.
- 저장을 반복하지 않으므로 assignment rules·auto-response rules·workflow rules 등 **또 한 바퀴의 커스터마이제이션 실행을 건너뛴다**.
- 저장 순서(save procedure)상 **Apex before trigger 직전(immediately before)에 실행**된다.
- 빌드가 단순한 이유:
  - `$Record` 전역 변수에 트리거 레코드 값이 이미 들어 있음 → Get Records·변수 생성 불필요
  - `$Record` 값을 바꾸면 **Salesforce가 자동으로 레코드에 적용** → Update Records 요소 불필요
  - 지원 요소는 **Assignment · Decision · Get Records · Loop** 4개뿐
- **before-save로 못 하는 것** — 이때는 after-save(또는 record-change process/Apex after trigger)를 쓴다 (원문 3항목):
  1. 저장 후에만 세팅되는 필드 값 접근 (예: Last Modified Date, 신규 레코드의 ID)
  2. 관련 레코드 생성·수정
  3. 트리거 레코드 업데이트 이외의 액션 수행
- **Fast Field Update 고려사항** (p.274): 트리거 레코드 필드 업데이트 외의 액션 불가 · 관련 레코드 값 업데이트 불가 · 지원 4요소 한정 · **트리거 있는 autolaunched flow 활성화에는 View All Data 권한 필요**.

> before-save vs after-save **선택 기준 비교표**는 [[Flow 설계 베스트 프랙티스]] §1 참조 — 여기서는 재서술하지 않는다.

### 2-2. Run Asynchronously (비동기 경로) — 소스 내 명시 사실 전수

- 실행 시점·용도·이점은 위 표(p.889) 그대로.
- **isChanged 연산자는 비동기 경로에서 미지원** (p.273).
- Scheduled path와 asynchronous path는 **배칭 방식이 다르다** (p.37 — scheduled path는 같은 1분 내 처리 예정 레코드를 배치 크기까지 묶음).
- **비동기 flow가 호출한 동기 Apex 트랜잭션은 동기 per-transaction Apex 한도에 계상**된다. "비동기 flow"에는 scheduled flow와 scheduled/asynchronous path를 가진 flow가 포함된다 (p.37).
- Flow Trigger Explorer에서 같은 객체·트리거에 연결된 비동기 경로를 확인할 수 있다 (p.31).
- Custom Error 요소는 record-triggered flow의 before-save/after-save 경로에서만 생성 가능 — **에러 메시지를 비동기로 실행할 수 없다** (Flow Reference p.326).

---

## 3. Start 요소 구성 — 트리거·진입 조건 옵션 전수

Start 요소(Configure Start)에서 ① Object 선택 → ② 트리거 시점 → ③ 진입 조건 → ④ 최적화 옵션 순으로 구성한다. (트리거를 지정하지 않은 autolaunched flow는 커스텀 버튼·프로세스·Apex 클래스·Einstein Bots 등으로만 실행 가능 — Flow Element: Start, p.368)

### 3-1. Trigger the Flow When (트리거 시점 — 4옵션, p.37 매트릭스)

| 옵션 | 의미 |
|---|---|
| **A record is created** | 레코드 생성 시 |
| **A record is updated** | 레코드 수정 시 |
| **A record is created or updated** | 생성 또는 수정 시 |
| **A record is deleted** | 삭제 시 (before-delete) |

### 3-2. Set Entry Conditions (진입 조건)

- **Condition Requirements** — ECA 원문에 등장하는 설정값: 조건 없음(No Condition) · **All Conditions Are Met (AND)** (p.885) · OR 조건 결합 (scheduled path OR 예제, p.36) · **Formula Evaluates to True** (p.885, 수식 진입 조건 예제 다수).
- **Is Changed 연산자** — Flow 조건 연산자로 존재한다 (WFR→Flow 연산자 매핑 표, p.887: WFR엔 없고 Flow에 **Is Changed** 있음). 진입 조건에 "필드가 특정 값으로 **IS CHANGED** 됐을 때"를 걸 수 있다 (p.890). 단 **비동기 경로에서는 미지원** (p.273).
- **Run When Conditions Met 설정** — 레코드 생성·수정 시 필드가 "어떤 값으로 바뀌었는지"를 확인하는 진입 조건을 만들려면 이 설정을 활성화한다. 반복 실행을 막고 일관성을 유지한다 (p.890 원문).

### 3-3. When to Run the Flow for Updated Records (업데이트 트리거 시 실행 시점 — 2옵션)

| 옵션 | 의미 |
|---|---|
| **Every time a record is updated and meets the condition requirements** | 업데이트될 때마다, 조건을 충족하면 매번 실행 |
| **Only when a record is updated to meet the condition requirements** | 업데이트로 조건이 **미충족 → 충족으로 바뀔 때만** 실행 |

**"Only when..." 의미론** (p.273 원문): 전체 조건 요건이 **false → true로 바뀔 때만** 트리거된다. 업데이트 전에 이미 true였고 업데이트 후에도 true면 flow는 실행되지 않는다. Scheduled path도 같은 규칙 — 이전 버전 레코드가 조건을 못 만족했고 업데이트된 레코드가 만족할 때만 예약된다.

> WFR 대응 관계 (p.885): WFR `created` = "A record is created" / `created, and any time it's edited to subsequently meet criteria` = "created or updated" + "Only when..." / `created, and every time it's edited` = "created or updated" + "Every time...".

#### 시나리오 표 1 — 단일 조건 (p.273 원문 전수)

트리거 = A record is created or updated, 조건 = `Industry Equals Agriculture`, 실행 = **Only when a record is updated to meet the condition requirements**:

| 시나리오 | 결과 |
|---|---|
| 신규 Account, Industry = Agriculture | **트리거됨.** Scheduled path 예약됨 |
| 신규 Account, Industry = Finance | 트리거 안 됨. 예약 안 됨 |
| 기존 Account(Industry = Agriculture)를 Industry = Agriculture + Billing State = CA로 업데이트 | 트리거 안 됨 — 업데이트 전에 이미 조건 충족. 새 예약 없음, **이미 예약된 path는 유지** |
| 기존 Account를 Industry = Finance → Agriculture로 업데이트 | **트리거됨** — 이전엔 미충족, 업데이트 후 충족. 예약됨 |
| 기존 Account를 Industry = Agriculture → Finance로 업데이트 | 트리거 안 됨 — 업데이트 후 미충족. **기존 예약된 path도 취소됨** (업데이트마다 조건이 재평가됨) |

#### 시나리오 표 2 — OR 조건 (p.274 원문 전수)

조건 = `Industry equals Agriculture` **OR** `Billing State equals CA`, 실행 = Only when...:

| 원래 레코드 | 업데이트 후 | 결과 |
|---|---|---|
| Industry = Agriculture, Billing State = NJ | Industry = Agriculture, Billing State = CA | 트리거 안 됨 — 조건식이 업데이트 전에도 이미 충족. 예약 안 됨, 기존 예약 유지 |
| Industry = Finance, Billing State = NJ | Industry = Agriculture, Billing State = NJ | **트리거됨** — 이전 미충족 → 충족. 예약됨 |
| Industry = Finance, Billing State = CA | Industry = Finance, Billing State = NJ | 트리거 안 됨 — 업데이트 후 미충족. 기존 예약 취소 |

---

## 4. $Record와 $Record__Prior (전역 변수 레퍼런스, p.293)

| 전역 변수 | 라벨 | 내용 (원문 요지) |
|---|---|---|
| **`$Record`** | Triggering Object (예: Triggering Account) | flow를 트리거한 레코드. **트리거 있는 autolaunched flow에서만** 사용 가능. flow 전체에서 값을 참조·변경 가능. ① **저장 전(before-save)에 실행되는 flow**면 변경된 `$Record` 값을 Salesforce가 **자동으로 DB 레코드에 적용**. ② **저장 후(after-save)** 실행이면 변경 값을 적용하려면 **Update Records 요소** 필요 |
| **`$Record__Prior`** | Prior Values of Triggering Object | **변경 직전(immediately before the flow started)의 트리거 레코드 값**. "A record is updated" 또는 "A record is created or updated"로 구성된 record-triggered flow에서만 사용 가능. **읽기 전용**(값 변경 불가). **신규 생성 레코드로 트리거되면 모든 `$Record__Prior` 값은 null** |

```text
재귀 방지용 신·구 값 비교 게이트 (진입 조건 formula 예):
$Record.Amount != $Record__Prior.Amount
```

> `$Record`를 Update Records 요소에서 "ID + 모든 필드 값"으로 쓰려면 Process Automation Settings의 **Filter inaccessible fields from flow requests**를 켜야 한다 — 아니면 시스템 필드·읽기 전용 필드까지 세팅하려다 flow가 실패한다 (p.293).

---

## 5. Scheduled Paths (스케줄드 패스, pp.34–38)

트리거 이벤트 이후 **동적으로 계산된 시점**에 flow의 일부를 실행하는 경로. Time-dependent Workflow Rule의 후계 기능 (p.890).

### 5-1. 실행 컨텍스트와 사전 요건

- Scheduled path는 **system context**로 실행 — 모든 데이터에 접근·수정 권한을 가진다. 단 flow 액션의 **running user는 원래 레코드를 변경한 사용자**.
- 생성 전에 org의 **Default Workflow User**를 정의해 둔다(Setup → Process Automation Settings) — 트리거한 사용자가 비활성일 때 대신 쓸 사용자.

### 5-2. 구성 절차 (원문 5단계)

1. Start 요소에서 **Add Scheduled Paths (Optional)** 클릭 (이미 있으면 **Edit**)
2. **Path Label** 입력 — API Name은 자동 생성
3. **Time Source** 지정 — 트리거 이벤트 기준, 또는 레코드의 날짜/일시 필드 기준
4. **Offset Number + Offset Option** — Time Source 전/후 얼마나 떨어져 실행할지. 오프셋 없으면 0 입력
5. **Batch Size** — 기본값이자 최대값 **200**, 최소 **1**. path가 동시에 처리하는 레코드 수 (예: 배치 크기 2 + 같은 시간대 7건 → 4개 배치). Apex governor limit 회피용

대기 중인 scheduled path는 Setup → **Time-Based Workflow** 페이지에서 확인.

### 5-3. 배칭 규칙

- 조건을 충족하고 **같은 1분 내에 처리 예정**인 레코드들이 배치 크기까지 한 배치로 묶인다. 10분 간격으로 예약된 path들은 배치되지 않는다.
- Batch Size는 Advanced features에서 설정 — 미설정 시 기본 200.
- Scheduled path에는 **비동기 한도(asynchronous limits)** 가 적용된다.

### 5-4. Time Source = "When Record is Created or Updated"일 때 필수 조건 (p.35)

이 Time Source를 쓰려면 flow의 조건 요건이 다음 중 **하나 이상**을 포함해야 한다:

- Trigger the Flow When = **A record is created**
- When to Run the Flow for Updated Records = **Only when the record is updated to meet the conditions**
- 조건에 **ISCHANGED 연산자** 사용

### 5-5. Scheduled Path vs Schedule-Triggered Flow (원문 비교표, p.37)

| 비교 항목 | Scheduled Paths | Schedule-Triggered Flows |
|---|---|---|
| Flow Type | Record-Triggered | Schedule-Triggered |
| Trigger | 레코드 생성·수정·삭제 | 특정 날짜·시각 |
| What Time | 트리거 후 지정 시간 뒤, **또는** 트리거 레코드의 날짜 필드 기준 전/후 지정 시간 | 특정 날짜·시각 |
| Frequency | 트리거될 때마다 1회 실행 | 1회·매일·매주 |

**Scheduled path 사용 가능 조합** (원문 매트릭스, p.37 — 이미지로 셀 대조 완료):

| Trigger | No Condition — Every time a record is updated and meets condition requirements | A Condition Exists — Only when a record is updated to meet the condition requirements |
|---|---|---|
| A record is created | X | X |
| A record is updated | | X |
| A record is created or updated | | X |
| A record is deleted | | X |

### 5-6. 한도·재시도·특이 동작 (원문 전수, pp.37–38)

- **24시간당 scheduled-path 인터뷰 최대 250,000건, 또는 org 사용자 라이선스 수 × 200 중 큰 값.** 실행된 scheduled path 1건 = 인터뷰 1건. **즉시 실행되는 path는 이 한도에 계상되지 않음.**
- Time Source가 `dueDate` 같은 **필드 값 기준**이고 조건 충족 상태에서 그 필드가 미래 시각으로 바뀌면, **이미 실행됐더라도 새 시각에 다시 실행**된다 → 날짜 필드 업데이트로 **반복 액션 예약** 패턴 가능.
- Scheduled path가 있는 flow를 **비활성화하면 대기 중 자동화는 취소**된다 — 목록엔 예약 시각까지 남아 있다가, 그 시각에 활성 상태를 확인해 비활성이면 취소.
- (배칭 차이·동기 Apex 한도 계상 — §2-2에 기술)
- **재시도**: scheduled path 인터뷰가 1회 실패하면 에러 이메일 발송 후 **15분 뒤 재시도. 최대 5회** — 15, 30, 60, 120, 240분 후. 재시도 횟수는 Time-Based Workflow 페이지에 표시되지 않지만 Scheduled Date 열에 다음 시도 시각이 보인다.
- **벌크 실행 중 일부 인터뷰만 실패**하면 트랜잭션이 롤백되고 성공했던 인터뷰가 즉시 재시도된다. 이 시나리오의 최대 재시도는 **2회**.
- 예약 시각에 실행되지 않았다면: path 실행 실패(flow 자체 문제 — 에러 이메일 수신) 또는 **rolling 24시간 한도 초과** — 후자는 재예약되어 다시 시도된다.
- **디버그 로그 이벤트**: `FLOW_SCHEDULED_PATH_QUEUED`(레코드 생성·수정 후 path가 큐에 추가될 때) · `FLOW_VALUE_ASSIGNMENT`(path 실행 시).
- "Every time... and meets the condition requirements" + **필드 기반 실행 시각**(예: Opportunity.CloseDate 1시간 전) 조합은 **"Only when a record is updated to meet..."과 완전히 동일하게 동작**한다 — 진입 조건이 어느 쪽으로 설정돼 있든 무관.
- 기존 예약은 **조건이 TRUE로 유지되고 Time Source+Offset 시각이 아직 안 지났으면** 계속 예약 상태로 남는다.
- **Time Source 필드 값이 바뀌면** (미래 날짜인 한) 현재 예약 여부와 무관하게 새 날짜로 재예약된다.

---

## 6. Trigger Order — 같은 객체 flow들의 실행 순서 (pp.33–34)

같은 객체의 before-save 또는 after-save flow들의 실행 순서를 **trigger order 값(1 ~ 2,000)** 으로 선언적으로 지정한다. 저장 시 지정하거나, 이미 저장된 flow면 버전 속성에서 지정.

**정렬 규칙 (원문 전수):**

1. trigger order **1–1,000**인 flow가 **오름차순**으로 먼저 실행 (1, 2, 3, ...). 같은 값이면 **flow API 이름의 알파벳순**
2. **값이 없는 flow**가 다음 — **활성화 날짜 순**. Winter '22 이전에 만든 flow는 값을 지정하지 않는 한 이 구간에서 실행
3. **1,001–2,000**인 flow가 마지막 — 오름차순, 같은 값이면 API 이름 알파벳순

**가이드라인 (원문 전수):**

- trigger order는 **before-save 또는 after-save flow에만** 정의 가능하며, **같은 객체 + 같은 트리거 타입** flow들 사이에서만 유효하다.
- trigger order 값은 **항상 실행 순서(order of execution) 규칙에 종속** — after-save flow를 다른 after-save flow보다 먼저 실행시킬 순 있어도, 값이 아무리 낮아도 **before-save flow나 Apex trigger보다 먼저 실행시킬 수는 없다**.
- 다수 flow를 정렬할 때는 **10, 20, 30 (또는 100, 200, 300)처럼 간격을 띄우는 것**이 베스트 프랙티스 — 나중에 사이(예: 10과 20 사이)에 새 flow를 끼워 넣기 쉽고 기존 값 변경을 피할 수 있다.
- 한 flow의 활성화·비활성화·순서 변경이 **다른 flow들의 순서를 자동 갱신**시킬 수 있다.
- flow 정렬은 연결된 **scheduled path·asynchronous path에는 직접 영향 없음**.

### Flow Trigger Explorer (pp.31–32)

지정 객체에 연결된 record-triggered flow 전체를 보고·관리·재정렬·필터링하는 도구. UI 구성 (원문 번호 그대로):

1. **객체 선택** → 2. **트리거 선택**(created/updated/deleted) → 3. **before-save flow 목록** → 4. **after-save flow 목록** → 5. **연결된 asynchronous path** → 6. flow 라벨 클릭 = Flow Builder 새 탭 → 7. 드롭다운 **Flow Details and Versions** = 상세·버전 활성/비활성 → 8. **필터 패널**(status, package state, process type) → 9. **Edit Order** — 드래그로 순서 변경 = Trigger Order 값 변경 → 10. **New Flow** — 같은 객체·트리거 타입의 새 flow 생성

**제한**: **Standard flow**는 다른 flow들과의 상대 실행 위치를 볼 수만 있고 **재정렬 불가**. **flow 템플릿으로 만든 record-triggered flow는 Flow Trigger Explorer에 표시되지 않음**.

---

## 7. 일반 고려사항 (Record-Triggered Flow Considerations, pp.273–275)

- Record-triggered flow는 **커스텀 validation rule을 실행**시킨다.
- Autolaunched flow에서 **screen flow를 (subflow로) 참조할 수 없다**.
- **isChanged 연산자는 비동기 경로 미지원**.
- 실행 순서(order of execution)상 위치 때문에 record-triggered flow는 **유사한 workflow rule과 다르게 동작할 수 있다**.
- "Only when a record is updated to meet the condition requirements" 의미론과 시나리오 표 → §3-3.
- **디버그 모드에서 `ISCLONE()` 수식 함수는 항상 FALSE** — 복제 레코드로 디버그해도 진입 조건·Decision의 ISCLONE()은 FALSE로 평가된다.
- (Fast Field Update 고려사항 → §2-1, View All Data 활성화 권한 포함)

---

## 8. Start 요소 XML 구조 (.flow-meta.xml)

필드·enum 값은 **Metadata API Developer Guide v67.0 (Summer '26)** Flow 타입(pp.1298–1300) 대조:

- `triggerType` (FlowTriggerType) — record trigger 관련 값: **`RecordBeforeSave`**(API v48.0+, 생성·수정 시 저장 전) · **`RecordAfterSave`**(v49.0+, 저장 후) · **`RecordBeforeDelete`**(v50.0+, DB에서 삭제되기 전). processType이 `AutoLaunchedFlow`(또는 `PromptFlow`)일 때만 사용 가능하며, 이 필드를 생략하면 트리거 없는 flow.
- `recordTriggerType` (RecordTriggerType) — **`Create`** · **`Update`** · **`CreateAndUpdate`** · **`Delete`**(v50.0+) · **`None`**(v55.0+, record-triggered가 아닌 flow용). v48.0+.
- `doesRequireRecordChangedToMeetCriteria` (boolean, v50.0+) — true면 "업데이트 전 조건 미충족 → 업데이트 후 충족"일 때만 조건이 true로 평가 = UI의 **Only when a record is updated to meet the condition requirements**.
- `triggerOrder` (int, v54.0+) — **1 ~ 2,000** (§6의 run order 값).
- `scheduledPaths` (FlowScheduledPath[], v51.0+) — scheduled path 정의.

```xml
<!-- 구조 예시 — 실제 동작 XML 아님 (필드명·enum은 Metadata API Guide v67.0 대조, 조합은 직접 작성) -->
<?xml version="1.0" encoding="UTF-8"?>
<Flow xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>67.0</apiVersion>
    <processType>AutoLaunchedFlow</processType>
    <triggerOrder>10</triggerOrder>
    <start>
        <object>Account</object>
        <triggerType>RecordAfterSave</triggerType>          <!-- RecordBeforeSave | RecordAfterSave | RecordBeforeDelete -->
        <recordTriggerType>CreateAndUpdate</recordTriggerType> <!-- Create | Update | CreateAndUpdate | Delete -->
        <doesRequireRecordChangedToMeetCriteria>true</doesRequireRecordChangedToMeetCriteria>
        <filterLogic>and</filterLogic>
        <filters>
            <field>Industry</field>
            <operator>EqualTo</operator>
            <value>
                <stringValue>Agriculture</stringValue>
            </value>
        </filters>
        <connector>
            <targetReference>첫_요소_API이름</targetReference>
        </connector>
    </start>
</Flow>
```

---

## 관련 노트

- [[Record-Triggered Flow vs Apex Trigger 선택]] — Flow로 할지 Apex Trigger로 할지 결정 기준 (자동화 밀도·역량 매트릭스·하이브리드)
- [[Flow 설계 베스트 프랙티스]] — before-save 우선·진입 조건 최적화·바이패스·거버너 한도 등 설계 원칙
- [[Flow 종류와 변수]] — processType 전체와 변수(XML) 일반
- [[Trigger Order of Execution]] — 저장 트랜잭션 내 before-save flow·Apex trigger·after-save flow의 전체 실행 순서
- [[Flow 요소 참조]] — Assignment·Decision·Get Records·Custom Error 등 개별 요소 레퍼런스
- [[Flow 에러 처리]] — Fault 경로 설계 (scheduled path 실패·재시도와 연계)
- [[Autolaunched Flow 패턴]] — 트리거 없는 autolaunched flow 설계
- [[Trigger 재귀 방지]] — $Record vs $Record__Prior 비교 게이트 등 재귀 제어 상세
