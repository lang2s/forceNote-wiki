---
tags: [Flow, limits, 한도, considerations, governor-limits, reference]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Limits, Flow Limits and Considerations, Flow 한도, 플로우 한도, 플로우 제한사항, Per-Transaction Flow Limits, General Flow Limits, Flow Usage-Based Entitlements, Flow 고려사항, Versioned Updates]
---

# Flow 한도 레퍼런스

> Spring '26 "Automate Your Business Processes" PDF의 **Flow Limits and Considerations** 챕터 전수 — 사용량 엔타이틀먼트·조직/트랜잭션 한도 수치와 Builder·기능·데이터·관리·패키징·트러블슈팅 고려사항, Versioned Updates까지 한 곳에 모은 레퍼런스.

---

> **위임 경계:** 트랜잭션 거버너 한도를 **회피하는 설계 패턴**(Loop 밖 DML/Get Records 등)은 [[Flow 설계 베스트 프랙티스]] §6 참조 — 이 노트는 한도 **수치·조건 자체**의 레퍼런스다. Apex 공용 트랜잭션 한도 전체는 [[Governor Limits]], 플랫폼 전역(API·Bulk·Metadata 등) 한도는 [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] 소관.

## 1. 사용량 기반 엔타이틀먼트 (Flow Usage-Based Entitlements)

Usage-based entitlement은 기능 라이선스처럼 **기능을 제한하지 않고 추가**하는 개념이다. 허용량을 초과하면 Salesforce가 계약 증액을 논의하러 연락하지만, **그동안에도 flow 인터뷰는 평소처럼 실행된다.** 월 단위 엔타이틀먼트의 월 시작·종료는 계약이 결정하며, Setup의 Company Information 페이지에서 확인한다.

**카운트 규칙:**
- Subflow 요소로 다른 flow가 실행한 flow는 인터뷰 할당량에 **카운트되지 않는다.**
- Process Builder 프로세스가 flow를 실행하면 **프로세스와 flow 둘 다** 카운트된다.
- Process Builder 프로세스에 recursion을 켜면 레코드 평가 때마다 별도 인터뷰가 시작되어 **각각** 카운트된다.

### 에디션별 무료 할당 (조직당)

| 월별 엔타이틀먼트 | 카운트 대상 | Essentials·Professional | Performance·Developer | Enterprise·Unlimited |
|---|---|---|---|---|
| UI 있는 flow 인터뷰 최대/월 | 화면 요소를 가질 수 있는 flow 타입 인터뷰 — screen flow, user provisioning flow, Field Service flow, contact request flow, Survey Builder 설문 | 2,000 | 20,000,000 | 20,000,000 |
| UI 없는 flow 인터뷰 최대/월 | 화면 요소를 가질 수 없는 flow 타입 인터뷰 — autolaunched flow, transaction security flow, Process Builder 프로세스 | 10,000,000 | 10,000,000,000 | 10,000,000,000 |

### 구매 라이선스별 추가 할당 (조직당 — 누가 실행하든 무관)

| 월별 엔타이틀먼트 | Enterprise Edition | Unlimited Edition |
|---|---|---|
| UI 있는 flow 인터뷰 추가/월 | Service Cloud User 라이선스당 **+50**, Salesforce CRM Content User 라이선스당 **+50** | Service Cloud User 라이선스당 **+100**, Salesforce CRM Content User 라이선스당 **+100** |

## 2. 조직 단위 일반 한도 (General Flow Limits)

**인터뷰 크기 최대 1,000,000 B (약 1 MB)** — 초과하면 persist(저장)·pause 불가.

### Segment-triggered · form-triggered · automation-event triggered flow

| 조직당 한도 | Starter Edition | Marketing Cloud Growth | Marketing Cloud Advanced |
|---|---|---|---|
| flow 타입당 활성 flow | 50 | 500 | 750 |
| flow 타입당 전체 flow | 2,000 | 50,000 | 50,000 |

### 그 외 모든 flow

| 조직당 한도 | Essentials·Professional | Enterprise·Unlimited·Performance·Developer |
|---|---|---|
| flow당 버전 수 | 50 | 50 |
| flow당 런타임 실행 요소(executed elements) | 없음 | 없음¹ |
| flow 타입당 활성 flow | 5 | 2,000 |
| flow 타입당 전체 flow | 5 | 4,000 |
| 특정 시각 기반으로 시간당 실행되는 프로세스 예약 액션 그룹 | 1,000 | 1,000 |
| 레코드 필드 값 기반으로 시작·재개되는 자동화의 **합산 총계** — ① 활성 flow에 정의된 resume 이벤트 ② 활성 프로세스에 정의된 예약 액션 그룹 ③ 활성 워크플로 룰에 정의된 time trigger ④ 재개되는 비활성 flow 인터뷰 | 20,000 | 20,000 |
| Schedule-triggered flow 인터뷰 / 24시간 | **250,000 또는 조직 사용자 라이선스 수 × 200 중 큰 값**² | 좌동² |

> ¹ **API 버전 57.0에서 flow 요소 2,000개 한도가 제거**되었다. API 56.0 이전에서는 flow가 최대 2,000개 flow 요소를 가질 수 있었다.
> ² 이 한도에 카운트되는 라이선스 타입: full Salesforce·Salesforce Platform 사용자 라이선스, App Subscription 사용자 라이선스, Chatter Only 사용자, Identity 사용자, Company Communities 사용자.

## 3. 트랜잭션 단위 한도 (Per-Transaction Flow Limits)

Apex가 강제하는 per-transaction 한도가 flow를 지배한다. 어떤 요소가 거버너 한도를 초과시키면 **트랜잭션 전체가 롤백**된다 — 해당 요소에 **fault connector 경로가 있어도 롤백된다.**

| Per-Transaction 한도¹ | 값 | Flow에서 소진하는 요소 (PDF 원문 기준) |
|---|---|---|
| 발행되는 SOQL 쿼리 총수 | **100** | 모든 Get Records 실행 + 필터 조건을 쓰는 Update/Delete Records 실행 |
| SOQL 쿼리로 조회되는 레코드 총수 | **50,000** | 모든 Get Records 실행 + 필터 조건을 쓰는 Update/Delete Records 실행 |
| 발행되는 DML 문 총수 | **150** | Create/Update/Delete Records 실행 |
| DML 문 결과로 처리되는 레코드 총수 | **10,000** | — |
| Salesforce 서버 최대 CPU 시간 | **10,000 ms** | — |
| 한 배치에서 허용되는 중복 업데이트 총수 | **12** | — |

> ¹ **트랜잭션 경계 (PDF 각주 전문 요지):** Autolaunched flow는 자기를 실행한 더 큰 트랜잭션의 일부로, **그 트랜잭션의 한도를 공유**한다(예: Apex·프로세스에서 실행된 flow는 그 Apex·프로세스 액션과 같은 트랜잭션). **Screen 요소가 있는 flow는 여러 트랜잭션에 걸칠 수 있다** — 사용자가 화면에서 Next를 클릭할 때마다 새 트랜잭션이 시작된다. **Wait 요소가 있는 flow도 여러 트랜잭션에 걸친다** — 인터뷰가 이벤트 대기로 일시정지되면 트랜잭션이 끝나고, 재개 시 새 트랜잭션이 시작된다. Wait 이후의 모든 것은 다른 재개 인터뷰들과 함께 **배치 트랜잭션**으로 실행된다(같은 사용자 ID + 같은 실행 시각 + 같은 flow 버전 ID 인터뷰끼리 묶임).

> 한도 회피 설계(Loop 밖 DML·Get Records, 벌크 패턴)는 [[Flow 설계 베스트 프랙티스]] §6 참조.

## 4. Flow Builder 고려사항

- **데이터 접근** — Flow Builder는 현재 사용자의 권한·로케일을 사용한다. Builder는 열 때 존재하던 정보만 인식하므로, 조직 데이터·메타데이터를 수정했으면(커스텀 필드 추가, Apex 클래스 수정 등) **Builder를 닫았다 다시 열어야** 참조 가능.
- **Cloud Flow Designer로 저장된 flow** — CFD로 만든 버전을 Flow Builder에서 열면 Save 버튼이 비활성. 편집하려면 새 버전으로 저장.
- **텍스트 서식** — Display Text 화면 컴포넌트, Choice 리소스 레이블, help text, Pause 확인 화면, 입력 검증을 열면 기존 HTML이 rich text로 변환되고 미지원 HTML은 제거된다. 변환 지원 태그: `<a>` `<b>` `<br>` `<font>` `<i>` `<li>` `<p>` `<span>` `<u>` `<div>`. rich text 에디터에 붙여넣은 HTML은 미지원.
- **Rich text** — 에디터로 업로드한 이미지는 Files 탭에 저장되고 **조직 전원에게 보인다**. Experience Cloud 사이트에서는 보이지 않는다. Post to Chatter·Send Email·plain text 기대 커스텀 액션에 텍스트 템플릿을 쓸 때는 plain text로 토글할 것. `<` 같은 불완전한 HTML 기호는 인접 문자열과 함께 제거된다(`2<3` → `2`) — 기호 앞뒤에 공백을 넣으면 렌더링됨(`2 < 3`).
- **Date/Time** — 런타임 date/time 값은 **flow를 실행하는 사용자**의 시간대, Builder에서 보는 값은 **flow를 구성한 어드민**의 시간대를 반영한다.
- **텍스트 값** — 사용자 입력 필드 텍스트에 UTF-8 인코딩 미지원. 임베디드 폰트 지원 로케일은 7개뿐: 중국어(번체)·중국어(간체)·영어(US)·프랑스어(프랑스)·독일어(독일)·일본어(일본)·스페인어(스페인). 텍스트 필드 값으로 문자열 `null`을 입력하지 말 것.
- **출력 값** — 같은 출력 값을 여러 변수에 담으려면 한 변수에 담은 뒤 액션 다음에 Assignment 요소로 나머지 변수에 복사.
- **관리 패키지** — 관리 패키지에서 설치된 flow는 템플릿이거나 overridable이 아니면 Flow Builder로 열 수 없다 (지적재산권 보호).
- **Step 요소** — Builder에서 step 추가·수정 불가, step→screen 변환 불가. CFD에서 추가한 step은 캔버스에 남는다 — 제거 권장.
- **Action 요소** — Legacy Apex action은 플러그인 코드의 tag로 정리되지 않는다.
- **Winter '12 이전 flow 업그레이드** — Boolean decision이 다중 outcome Decision 요소로 변환된다 (기존 레이블 유지, API명에 `_switch` 부가, "True" outcome + 기본 "False" outcome).
- **용어** — 일부 경고·오류 메시지·디버그 상세의 용어는 Flow Builder/CFD에 맞게 갱신되어 있지 않다.

## 5. Salesforce 기능 고려사항

### 5-1. 보안

- **세션 만료** — 사용자 세션이 만료되면 진행 중 인터뷰는 중단되고 **재개 불가**. 이미 실행된 액션(Create Records, Post to Chatter 등)은 **롤백되지 않지만** 화면 입력 등 진행 상태는 소실. 팁: 세션 타임아웃 적절히 설정, 세션 만료 임박 알림 주의 안내, **릴리즈 업그레이드 중 flow 실행 자제**(통상 업그레이드 약 5분). Paused/waiting 인터뷰는 세션 만료의 영향을 받지 않는다.
- **Shield Platform Encryption** — 다음 요소·리소스에서 **암호화 필드로 필터·정렬 불가**: Update Records, Delete Records, Get Records, Record Choice Set.
- **Screen Flow 공개 입력** — 공개 접근 가능한 screen flow 입력 필드에서 HTML을 모두 제거할 것. rich text 필드에 매핑되는 공개 입력은 악성 URL 방지를 위해 해당 오브젝트에 HTML 제거 전용 flow(fast field update 최적화, 입력 필드가 비어 있지 않을 때 실행)를 별도로 만들거나 기존 Apex trigger를 사용. 여러 소스가 쓸 수 있으므로 **화면 레벨이 아닌 필드 레벨**에서 검사.

### 5-2. 외부 오브젝트 (External Objects)

- 외부 시스템에서 다른 데이터 타입에 매핑되는 indirect lookup 관계에 값을 설정하지 말 것 (예: Date에 매핑된 Text indirect lookup).
- indirect lookup으로 연결된 Salesforce 레코드 찾기 — 부모 오브젝트 Id를 indirect lookup 필드의 ID와 매칭. Get Records 필터 (PDF 발췌):

```
Id Equals {!socialMediaPost.indirectLookupRelationship_c__c.Id}
```

- external lookup으로 연결된 부모 외부 오브젝트 레코드 찾기 (PDF 발췌):

```
ExternalId Equals {!case.externalLookupRelationship_c__c}
```

- 같은 트랜잭션에서 조직 데이터를 생성·수정·삭제한 뒤 외부 데이터에 접근하면 **오류**. 외부 시스템 접근은 별도 트랜잭션 권장 — screen flow엔 화면·local action, autolaunched flow엔 Wait 요소로 이전 트랜잭션을 종료(단 record-based resume time 사용 금지).
- 프로세스·flow에서 External ID와 Display URL 필드를 업데이트하지 말 것.
- Record-change 프로세스 미지원.
- 같은 트랜잭션에서 외부 오브젝트를 변경하기 전에 표준·커스텀 오브젝트 변경을 먼저 커밋해야 한다 — Flow Builder에선 화면·local action 또는 flow-based time까지 일시정지하는 Wait 요소, Process Builder에선 scheduled action 추가.

### 5-3. Lightning 컴포넌트

- flow 안의 Lightning 컴포넌트는 **Lightning Locker 제약**을 준수해야 하며, Lightning 컴포넌트를 포함한 flow는 **Lightning runtime에서만** 지원.

**flow ↔ Lightning 컴포넌트 속성 타입 매핑 (지원 타입 전수):**

| Flow 데이터 타입 | 컴포넌트 속성 타입 | 유효 값 |
|---|---|---|
| Apex | Custom Apex Class | `@AuraEnabled` 필드를 정의한 Apex 클래스. 클래스에서 지원되는 데이터 타입: Boolean, Integer, Long, Decimal, Double, Date, DateTime, String (단일 값·List 모두 지원) |
| Boolean | Boolean | True: `true`, `1` 또는 동등 표현식 / False: `false`, `0` 또는 동등 표현식 |
| Currency | Number | 숫자 값 또는 동등 표현식 |
| Date | Date | `"YYYY-MM-DD"` 또는 동등 표현식 |
| Date/Time (API명 DateTime) | DateTime | `"YYYY-MM-DDThh:mm:ssZ"` 또는 동등 표현식 |
| Number | Number | 숫자 값 또는 동등 표현식 |
| Multi-Select Picklist | String | `"Blue; Green; Yellow"` 형식 문자열 |
| Picklist | String | 문자열 값 또는 동등 표현식 |
| Record (특정 오브젝트, API명 SObject) | 해당 오브젝트의 API명 (예: Account, Case) | key-value 맵 또는 동등 표현식. record 값은 **그 특정 오브젝트 타입 속성에만** 매핑 가능 — 타입이 `Object`인 속성과는 비호환 |
| Text (API명 Text) | String | 문자열 값 또는 동등 표현식 |

- **design:attribute** — Flow Builder는 `name`·`label`·`description`·`default` 속성만 지원. `min`·`max`·`required`·`placeholder` 등 나머지는 무시된다. min/max 길이 검증은 flow formula나 컴포넌트의 client-side controller로 구현.
- 컴포넌트 속성이 flow에서 참조되면 그 속성의 **타입 변경·design 리소스에서 제거 불가** — 활성 버전뿐 아니라 **모든 flow 버전**에 적용. 모든 버전에서 참조를 제거한 뒤 수정·삭제.

**Aura 컴포넌트 포함 flow의 런타임 — 배포 방법별 `force`·`lightning` 이벤트 처리** (PDF 표의 빈 셀 = 미처리, 체크 = 처리 — 페이지 이미지로 대조 확인):

| 배포 방법 | force·lightning 이벤트 처리 |
|---|---|
| 직접 flow URL | ❌ |
| Flow Builder의 Run·Debug 버튼 | ❌ |
| flow 상세 페이지·리스트 뷰의 Run 링크 | ❌ |
| Web 탭 | ❌ |
| 커스텀 버튼·링크 | ❌ |
| Lightning 페이지 | ✅ |
| Experience Builder 사이트 페이지 | 사이트에 따라 다름 — Aura 사이트는 모든 flow 처리 가능. LWR 사이트는 제약이 있고 **Aura 컴포넌트를 쓰는 flow 자체를 실행 못 함** |
| Flow 액션 | ✅ |
| 유틸리티 바 | ✅ |
| `flow:interview` Visualforce 컴포넌트 | ❌ |
| `lightning:flow` Aura 컴포넌트 | 임베드 위치 또는 컴포넌트의 이벤트 핸들러 포함 여부에 따라 다름 |

> `force:showToast` 같은 이벤트를 처리하는 방식으로 테스트하거나, 컴포넌트에 이벤트 핸들러를 직접 추가해 동작을 검증할 것.

### 5-4. Screen Flow 반응형(Reactivity)

**API 버전 57.0 이상**에서 지원.

- 컴포넌트의 **수동 출력(manual outputs)은 반응형 미지원** — 수동으로 설정한 출력 변수는 같은 화면의 다른 컴포넌트에서 참조해도 갱신되지 않는다.
- Help text와 레이블은 다른 컴포넌트 변화에 반응하지 않는다.
- 출력→입력 매핑 시 **데이터 타입이 일치**해야 반응형 지원.
- 커스텀 컴포넌트에 검증 룰이 있어도 반응형 변경은 검증을 트리거하지 않는다.
- 글로벌 변수 중 **`$Flow`만 반응형** — Custom Labels·Custom Settings·`$Organization`·`$Profile` 등 나머지는 비반응형.
- DateTime 필드를 Time에 매핑하면 값이 **GMT로 변환**되고 화면 간 이동에도 유지된다. DateTime 필드에 매핑하면 로케일이 보존된다.

## 6. Salesforce 데이터 고려사항

- **레코드 타입 설정** — 레코드 타입은 **ID**로 설정. Get Records로 이름으로 Record Type 레코드를 찾아 ID를 변수에 저장 후 사용.
- **Person Account** — person account 사용 조직은 `Account.Salutation` 대신 `Contact.Salutation`을 참조.
- **Null 값** — Get Records·Update Records의 필터 조건이 null 값을 참조하면 **flow 실패**. 필터에서 참조하기 전에 Decision 요소로 null 체크.
- **머지 필드** — flow는 flow 리소스에 저장된 값만 런타임에 참조 가능 (예: 메시징 템플릿 안의 머지 필드는 참조 불가).

### 6-1. 읽기 전용 필드와 flow 작업

flow는 실행 사용자가 권한을 가진 작업만 수행할 수 있다. 편집 불가 필드(권한 미부여 또는 항상 읽기 전용인 시스템 필드)는 **inaccessible(읽기 전용)** 취급.

**record 변수에 읽기 전용 필드가 들어오는 경로:**

| 변수를 채운 주체 | 변수에 포함되는 것 |
|---|---|
| Get Records (필드 값 함께 저장) | Id + 선택해서 포함한 다른 읽기 전용 필드 |
| Assignment 또는 Get Records (필드 값 개별 변수 저장) | 선택해서 포함한 읽기 전용 필드 |
| 프로세스·워크플로 룰·Start 요소 | 오브젝트의 **모든 시스템 필드 + 실행 사용자가 편집 권한 없는 모든 필드** (기본적으로 오브젝트의 전 필드 포함) |

**대응 절차:** ① flow가 그 필드를 쓰지 않으면 값을 저장하지 않게 수정 → ② 참조된다면 실행 사용자에게 필요한 권한 부여 → ③ 권한 부여가 불가하면 그 필드를 업데이트하지 않게 flow 수정 (쓰기 가능한 필드 값만 새 record 변수로 복사 — Update용이면 읽기 전용이어도 **Id는 반드시 포함**. 컬렉션은 Loop로 항목별 복사).

**`Filter inaccessible fields from flow requests` 환경설정** (Setup → Process Automation Settings, 편집엔 Customize Application 권한):

| | 선택(Selected) | 미선택(Not Selected — **권장**) |
|---|---|---|
| 실행 사용자가 전 필드 편집 권한이 없을 때 | **부분 성공** — 읽기 전용 필드를 걸러내고 편집 가능 필드만 업데이트. fault path 실행 안 됨 | **작업 실패** — 아무 필드도 업데이트 안 됨. fault path가 있으면 실행 |
| 일부 필드 미업데이트 시 알림 | 사용자·어드민 누구에게도 알림 없음 | 어드민이 상세 포함 flow 오류 이메일 수신 (`INVALID_FIELD_FOR_INSERT_UPDATE: Unable to create/update fields: ...`) |
| 개별 변수·리소스·리터럴을 쓰는 Create Records와 비교 | 불일치(Inconsistent) | 일치(Consistent) |
| 필드를 개별 설정하는 Update Records와 비교 | 불일치(Inconsistent) | 일치(Consistent) |

- 기본값: **Winter '17 이전 생성 조직은 활성화**, 이후 조직은 비활성화. 변경 시 sandbox에서 영향 테스트 권장 (critical update에 준하는 절차).
- Salesforce 권장: **비활성화** — flow가 기대한 필드 값을 다 설정하지 못했을 때 항상 인지할 수 있도록.

### 6-2. Apex-Defined 데이터 타입

- Cloud Flow Designer 미지원.
- Display Text 등 값 표시 컴포넌트는 Apex-defined 변수의 전 필드를 표시 (관리 패키지의 Apex 클래스면 **클래스 ID만** 표시).
- `@AuraEnabled` 클래스가 **200개 초과**인 조직은 요소·리소스 창 최초 로딩이 느려질 수 있다.
- 관리 패키지의 deprecated Apex 클래스도 Builder에 나타난다.
- flow가 Apex를 호출하면 실행 사용자의 프로파일·권한 세트에 해당 **Apex 클래스 할당**이 있어야 한다.
- Apex-defined 타입 변수 필드로 **list of lists** 미지원.
- Apex 클래스 요건: 지원 타입 Boolean·Integer·Long·Decimal·Double·Date·DateTime·String (단일·리스트) / 필드마다 `@AuraEnabled` 필수 / **인자 없는 생성자 필수** / 클래스 메서드·getter·inner class·(inner와 동명의 outer class) 미지원 / 필드 참조 무결성 미보장 — 클래스에서 필드를 수정·삭제하면 flow 실패.
- Apex-defined 변수 값은 flow 밖에 설정·저장 불가, **Subflow 요소로 전달 불가**.
- Local action으로 쓰는 Aura 컴포넌트는 Apex-defined 속성을 설정할 수 없다.

## 7. Flow 기능 고려사항

### 7-1. 조건부 표시 (Conditional Visibility)

- null은 `{!$GlobalConstant.EmptyString}`과 동일하게 평가.
- 미지원 연산자: **Was Visited, Was Set**. 미지원 데이터 타입: **Apex-defined, record 변수** (속성·필드 참조는 가능). 참조 불가: Apex-defined invocable action 결과, Subflow로 참조된 flow의 결과.
- **Manually assign variables (advanced)** 선택된 화면 입력 컴포넌트는 같은 화면의 조건부 표시 리소스로 사용 불가.
- 머지 필드가 섞인 텍스트는 값으로 미지원 (머지 필드 단독은 지원).
- 텍스트 템플릿·수식은 **초기값만** 평가 — 사용자 입력에 따른 변화는 평가되지 않는다.
- 숨겨진 화면 입력 컴포넌트는 Required가 `{!$GlobalConstant.True}`여도 필수가 아니다 (표시되는 순간 필수로 취급). 조건 미충족으로 숨겨지면 값은 **null** (Dependent Picklists 안의 숨은 picklist는 전체 컴포넌트가 숨겨지지 않는 한 null 아님).
- Update Records에서 숨겨진 컴포넌트 값으로 필드를 업데이트하면 필드가 **blank**로 설정된다. 대신 blank 체크 Formula 리소스를 사용 (PDF 발췌):

```
IF( ISBLANK( {!myTextField} ), {!myOriginalFieldValue}, {!myTextField})
```

- 표시 조건의 리소스 값 변수는 오브젝트 필드를 **최대 3단계** 탐색 가능 (예: `Contact.Account.Owner`).
- 섹션의 표시 조건이 **자기 내부 컴포넌트**를 참조하면 섹션 전체가 숨겨진다. 컴포넌트 표시 조건을 참조하고 그것이 true면 섹션이 보인다.
- 화면 초기 표시 이후에 렌더링된 컴포넌트·부분은 **포커스 불가**.
- 조건의 **순환 논리(circular logic)** 회피 — 성능 저하·이상 동작·오류 유발.
- 필드 표시 조건의 관련 레코드 필드는 화면 진입 시 값이 설정된 **Lookup 필드에만** 동작.
- 조건 값에 쉼표가 있으면 값 앞뒤에 따옴표 (예: `"Email, Phone, and Social Media"`).
- 성능: 조건부 표시 조건의 수·복잡도를 최소화 — 같은 논리는 Section 컴포넌트에 묶어서 1회 설정, 보여주되 입력만 막을 땐 Disabled 속성, 동적 기본값은 reactive formula·Screen Actions 활용.

### 7-2. Choice 컴포넌트 기본값

- 기본값(Default Value)은 choice를 1개 이상 추가하면 나타나며, picklist 값 또는 임의 flow 리소스(변수·record 변수 필드·수동 입력 등) 지정 가능.
- 런타임 매칭 규칙: 기본값이 **옵션 목록에 포함된 choice 리소스**면 → 선택된 choice의 API명 매칭 / **목록에 없는 choice 리소스**면 → 리소스의 해석된 값 매칭 / **다른 flow 리소스**(Get Records의 record 변수 참조 등)면 → 해석된 값 매칭 / **수동 입력 값**이면 → 그 값 매칭.
- 단일 선택 컴포넌트(Picklist·Radio Buttons)는 매칭되는 **첫 choice**를, 다중 선택(Multi-Select Picklist·Checkbox Group)은 매칭되는 **모든 choice**를 미리 선택.
- 다중 기본값은 세미콜론 구분 (`Red;Blue`) — 해석된 값에 세미콜론이 있으면 각각 별도 기본값으로 취급되어, 값이 정확히 `Red;Blue`인 choice는 선택되지 않는다. 다중 record면 record ID로 해석되는 변수를 세미콜론으로 구분.
- **collection choice set**의 값을 기본값으로 참조하면 화면 로드시 null — 같은 화면에서 그 값을 참조하거나 수식으로 감싸서 화면 재로드를 유도해야 표시.

### 7-3. 변수 (Variables)

- 필드·리소스 값을 비워 두면 런타임에 **null**. 빈 문자열로 취급하려면 `{!$GlobalConstant.EmptyString}` 설정.
- Boolean에서 **null ≠ false** — 체크박스 필드가 null인 레코드 검색은 0건. false로 검색할 것. 변수 사용 시 필터·조건 참조 전에 null 아님 확인.
- **퍼센트 변수** — record 변수의 percentage 필드 값을 수식에서 참조하면 **100으로 나눠진다** (Probability 100 → 수식 `{!Opportunity.Probability}` = 1).
- 기존 변수의 Input/Output 접근을 비활성화하면 그 변수를 쓰는 앱·페이지(URL 파라미터·subflow·프로세스)가 깨질 수 있다.
- 프로세스·flow가 다른 flow를 실행하며 입력 변수를 넘길 때, 컬렉션이 아닌 text·picklist·multi-select picklist 변수의 **null은 빈 문자열로 변환**된다.
- Flow 액션은 **레코드 ID만** 전달 가능 — Text 입력 변수 `recordId`가 있으면 넣어 주고, 없으면 그냥 실행 시도.
- Lightning App Builder의 Flow 컴포넌트 — 컬렉션·record·record 컬렉션 변수 미지원, 수동 입력 값만 지원, **Text 입력 변수 최대 4,000자**.
- flow 배포 시 통화 필드 값을 URL 파라미터로 currency 변수에 직접 넘기지 말 것 — 머지 필드 값에 통화 기호($)가 붙어 숫자만 받는 currency 변수에서 **런타임 실패**. 레코드 ID를 text 변수로 넘겨 flow 안에서 조회.
- Number 변수는 기본적으로 **정수(integer)** 취급.

### 7-4. 다중 선택 리소스·화면 필드 (Checkbox Group·Multi-Select Picklist·Choice Lookup)

- 기본값은 **1개만** 개별 선택 가능 — 여러 개는 기본값 필드에 세미콜론 구분으로 수동 입력.
- record choice set으로 사용자 선택 레코드의 필드 값을 변수에 할당할 때, **마지막으로 선택한 레코드**의 값만 저장. 한 화면의 여러 컴포넌트가 같은 record choice set을 쓰면 그 전체에서 마지막 선택 레코드 기준.
- 런타임 값은 사용자가 선택한 choice 값들의 **세미콜론 연결 문자열** — 선택된 choice 값 안의 세미콜론은 제거된다.
- flow 조건에서 참조하려면: 각 choice에 값이 구성돼 있어야 하고, 같은 화면의 여러 다중 선택 컴포넌트에 **같은 choice를 재사용하지 말 것**.
- 기본값이 있으면 런타임에 choice 값이 기본값과 매칭될 때 미리 선택된다.

### 7-5. 일시정지된 인터뷰 (Wait 요소)

**일반:**
- flow 버전을 비활성화해도 paused 인터뷰는 구성된 resume 이벤트를 계속 대기. **paused 인터뷰가 있는 버전은 삭제 불가.**
- 인터뷰는 Wait 요소당 **connector 1개만** 실행 — resume 이벤트 하나가 처리되면 나머지 resume 이벤트는 큐에서 제거.
- 인터뷰를 시작한 사용자가 비활성화되면 wait connector 실행 시 **재개 실패**.
- 일시정지 시 인터뷰가 **1 MB 초과**면 저장 실패·재개 불가.
- **Wait 요소가 있는 flow는 subflow로 호출 불가.**

**트랜잭션·배치 재개:**
- 인터뷰가 resume 이벤트를 대기하며 일시정지하는 순간 트랜잭션 종료, 재개 시 새 트랜잭션. Wait 이후는 다른 재개 인터뷰들과 **단일 배치**로 실행 — 첫 인터뷰가 배치에 들어온 후 1시간 이내에 재개 시작. 배치 기준: 같은 시각 재개 + 같은 flow 버전 ID + 같은 사용자 ID.
- 배치로 묶이면 재개 인터뷰의 DML·SOQL(flow 요소, Apex trigger, 즉시 워크플로 액션 포함)이 **Apex 거버너 한도 초과를 유발할 수 있다.** 대응: 사용자 1명이 Wait 사이에 한도 초과 가능한 DML·SOQL을 실행하지 않게 설계, Wait 요소를 여러 개 두어 트랜잭션 분산, fault 메시지가 `Too many SOQL queries`·`Too many DML operations`면 Wait 요소로 되돌아가는 fault path 추가.
- 재개 후 인터뷰가 실패하면: 그 배치의 앞선 인터뷰들은 성공 / 일시정지 전에 실행된 작업은 성공 / fault path가 처리하면 재개~실패 사이 작업 성공(실패 유발 작업만 실패) / fault path가 없으면 재개~실패 사이 작업 **롤백** / 배치의 나머지 인터뷰는 계속 시도.

**플랫폼 이벤트:**
- flow가 구독 가능한 표준 플랫폼 이벤트(커스텀 외): `AIPredictionEvent`, `BatchApexErrorEvent`, `FlowExecutionErrorEvent`, `FOStatusChangedEvent`, `OrderSummaryCreatedEvent`, `OrderSumStatusChangedEvent`, `PlatformStatusAlertEvent`.
- 수식에서 이벤트 참조 → Wait 요소에서 이벤트 데이터를 record 변수로 받은 뒤 그 필드 참조.
- 이벤트 메시지 필터 조건 값은 **765자 초과 불가**.
- 이벤트 상세 페이지의 Subscriptions 관련 목록 — 대기 중 flow 인터뷰가 있으면 "Process" 구독자 1개로 표시.
- 플랫폼 이벤트가 포함된 패키지 제거 전, 그 이벤트 메시지를 기다리는 인터뷰를 먼저 삭제.
- Einstein 예측 — 예측 결과마다 이벤트가 발행되므로 특정 오브젝트만 조건 필터 (예: `AIPredictionEvent.TargetId` = 현재 레코드). 예측에 쓰이는 필드를 flow가 업데이트하면 재예측→새 이벤트→**루프** 발생 가능 — 예측 미사용 필드만 업데이트.

**플랫폼 캐시:** Wait 요소 이후의 요소가 **session cache**를 읽고 쓰는 Apex를 호출하지 않게 할 것 (Apex 액션 + flow의 DB 변경으로 발화되는 Apex trigger 모두 해당).

**시간 기반 resume 이벤트:**
- **분·초 미지원.**
- 과거 시각을 기다리는 인터뷰는 가능한 한 빨리 재개 — 처리량에 따라 **1시간 이내** 실행.
- 조직당 **시간당 1,000개** 시간 기반 resume 이벤트 처리. 초과분은 다음 시간으로 이연 (예: 4~5시에 1,200개 예약 → 1,000개는 4~5시, 200개는 5~6시).
- paused 인터뷰의 resume 이벤트가 참조하는 product·price book은 보관(archive) 불가.

**Flow-based time:** 특정 시각 기반 resume 시각은 **flow를 만든 사용자의 시간대**로 평가.

**Record-based time:**
- 레코드 필드 값 기반 resume 시각은 **조직 시간대**로 평가.
- 참조 불가: `TODAY`·`NOW` 등 자동 파생 함수가 든 DATE/DATETIME 필드, 관련 오브젝트 머지 필드가 든 formula 필드.
- 미실행 resume 이벤트가 참조하는 날짜 필드를 바꾸면 resume 이벤트 **재계산** (과거로 바꾸면 저장 직후 곧 재개).
- Wait 실행 시점에 날짜 필드가 null이면 가능한 한 빨리(1시간 이내) 재개. non-null이었다가 처리 전에 null로 바뀌면 변경 후 1시간 이내 재개.
- 참조된 레코드·오브젝트가 삭제되면 resume 이벤트가 큐에서 제거되고, 기다릴 이벤트가 없으면 **인터뷰 삭제**.
- Lead convert 제약: paused 인터뷰의 resume 이벤트가 참조하는 리드는 전환 불가 / Validation and Triggers from Lead Convert 활성 시 Wait 이후의 리드 작업은 전환 중 미실행 / 리드 기반 campaign member가 관련 paused 인터뷰 종료 전에 전환돼도 인터뷰는 실행됨.

### 7-6. 스테이지 (Stage)

- 스테이지 머지 필드는 display text 등 레이블에선 스테이지 레이블로, 그 외에선 완전한 이름 `namespace.flowName:stageName` 또는 `flowName:stageName`으로 해석. 가급적 머지 필드(`{!myStage}`)로 참조하되 **subflow에서는 완전한 이름** 사용.
- Active by Default 스테이지는 오름차순 정렬로 자동 반영: **부모 flow**는 `$Flow.ActiveStages`에 오름차순 추가 + `$Flow.CurrentStage`는 최저 순서 스테이지. **참조된 flow(subflow)**는 `$Flow.ActiveStages`에 삽입만 되고 `$Flow.CurrentStage`는 자동 갱신 안 됨 — CurrentStage가 ActiveStages에 포함되면 그 뒤에 삽입, 미포함이면 끝에 추가, 중복이면 첫 등장 뒤에 삽입.
- 스테이지 있는 flow와 없는 flow를 함께 참조할 땐, 스테이지 있는 flow가 끝에서 `$Flow.ActiveStage`를 null로, 시작에서 `$Flow.CurrentStage`를 stage 1로 설정하게 구성.
- flow 오류 이메일은 인터뷰 시작 시점의 `$Flow.ActiveStages`·`$Flow.CurrentStage` 값을 알려주지 않는다 — 임시 display text 등으로 초기값 확인.

### 7-7. 2열 레이아웃 (Two-Column)

- **Winter '23부터 2열 flow 레이아웃은 무시된다** — 대안은 화면당 최대 4열 가변 폭의 Section 컴포넌트.
- (기존 동작) 레이아웃 설정은 flow 레벨 — 화면·필드 레벨 제어 불가. 필드는 홀수 번째 왼쪽·짝수 번째 오른쪽 교대 배치, Tab 이동은 왼쪽 열 전부 → 오른쪽 열. 화면 크기에 비반응형(모바일 비권장). Experience Builder·App Builder·유틸리티 바 배포 flow에서 Section 컴포넌트가 있는 화면은 Layout 속성 무시, URL 배포는 `flowLayout` URL 파라미터 무시.

### 7-8. Schedule-Triggered Flow

- 지정된 시각·빈도에만 시작 — **다른 수단으로 실행 불가**.
- Start Time은 **조직 기본 시간대** 기준.
- 트리거 있는 autolaunched flow 활성화에는 **View All Data 권한** 필요.
- 24시간당 인터뷰 최대 **250,000 또는 사용자 라이선스 × 200 중 큰 값** — 쿼리로 조회된 레코드 1건당 인터뷰 1개 생성. **배치당 레코드 최대 200.** 실행 레코드 수는 디버그 로그의 `SCHEDULED_FLOW_DETAIL` 이벤트로 추적. 한도 도달 시 flow 오류 이메일 발송.
- Setup의 Scheduled Jobs 페이지에서 삭제하면 향후 반복 실행이 전부 취소 — 재개하려면 flow를 비활성화 후 재활성화.
- 이미 지난 일시로 1회 실행 예약된 flow는 실행되지 않는다.
- 실행 주체는 **Default Workflow User**.
- Apex를 호출해야 하면 **Require User Access to Apex Classes Invoked by Flow** 릴리즈 업데이트를 활성화하지 말 것 — 활성화 시 schedule-triggered flow의 Apex 호출이 실패.
- **콜아웃은 Wait 요소 실행 후에만 가능** — Wait 없이 외부 오브젝트 접근·콜아웃 Apex 액션·External Services 액션 실행 불가. 팁: `$Flow.CurrentDateTime`을 base time으로 offset 0시간의 '특정 시각까지 일시정지' Wait를 넣으면 통상 1분 미만 일시정지로 우회 가능.
- `$Record` 글로벌 변수의 ID+전체 필드 값으로 Update Records를 구성하면 **Filter inaccessible fields from flow requests를 활성화**할 것 — 아니면 시스템 필드 등 읽기 전용 필드 설정 시도로 실패.
- 비동기 flow(scheduled flow, scheduled/async path 있는 flow)가 호출한 동기 Apex 트랜잭션은 **동기 per-transaction Apex 한도**에 카운트.
- 다건 처리하는 Create/Delete/Get/Update Records 요소에서 일부 레코드가 실패하면 전체 롤백 후 성공분 재시도. 이후 요소가 같은 실패 레코드를 다시 처리하면 모든 변경 롤백 + flow 트랜잭션 실패.
- 필터 조건 순서는 무관 — SFDC Optimizer가 전체 필터를 평가해 성능 최적화.

### 7-9. Record-Triggered Flow

- 커스텀 검증 룰(validation rules)을 실행한다.
- autolaunched flow에서 screen flow 참조 불가.
- `isChanged` 연산자는 **비동기 경로 미지원**.
- 실행 순서(order of execution) 상 위치 때문에 유사한 워크플로 룰과 다르게 동작할 수 있다.
- **"조건을 충족하도록 업데이트될 때만 실행"** 옵션: 전체 조건이 **false → true로 전환**될 때만 트리거. 이미 true였고 업데이트 후에도 true면 실행 안 됨. Scheduled path는 이전 레코드가 조건 미충족 + 갱신 레코드가 충족일 때만 예약. 예: 조건 `Industry = Agriculture`일 때 — 신규 Agriculture 생성 → 트리거○ / 기존 Agriculture에 다른 필드만 변경 → 트리거✕(기예약 path는 유지) / Finance→Agriculture 변경 → 트리거○ / Agriculture→Finance 변경 → 트리거✕ + **기예약 scheduled path 취소**. OR 조건도 동일 원리(조건 집합 전체 기준).
- **Fast Field Update(before-save)** 전용 제약: 트리거 레코드의 필드 값 업데이트 외 액션 불가, 관련 레코드 값 업데이트 불가, 지원 요소는 **Assignment·Decision·Get Records·Loop뿐**, 활성화에 View All Data 권한 필요.
- 디버그 모드에서 `ISCLONE()` 수식은 항상 **FALSE** (복제 레코드로 디버깅해도).

## 8. Flow 데이터·런타임 고려사항

### 8-1. 데이터

- Get Records·Update Records 요소는 SOQL 쿼리 최대 문자수 한도를 적용받는다 — **인터뷰당 요소별 SOQL 쿼리 100,000자**. 예: In 연산자에 Account ID 컬렉션 **약 4,700개 초과** + 기타 조건으로 100,000자를 넘기면 인터뷰 실패 가능.
- DB와 상호작용하는 flow는 사용자에게 관련 레코드·필드의 CRUD 권한 필요 — 없으면 insufficient privileges 오류.
- record 변수·record 컬렉션 변수를 삭제하면 그것을 쓰던 변수 할당은 null로 설정.
- Get Records의 **필드 값 자동 저장**은 screen flow·autolaunched flow에서만 가능.
- 런타임 date/time 값은 실행 사용자의 시간대 기준.

### 8-2. Flow Lightning Runtime

- Lightning runtime에서 일반 사용자는 **활성 버전**, Manage Flow 권한 어드민은 **최신 버전**을 실행한다 (Subflow로 참조된 flow도 어드민은 최신 버전).
- 인터뷰는 flow의 인스턴스. **연결된 트랜잭션이 완료될 때까지 액션(이메일 발송·레코드 생성/수정/삭제)을 수행하지 않는다** — 트랜잭션은 인터뷰 종료 또는 Screen·Local Action·Wait 요소 실행 시 완료. 데이터 요소 외에 Post to Chatter·Submit for Approval·Quick Actions 코어 액션도 레코드를 생성·갱신한다.
- 진행 중(in-flight) 인터뷰 데이터는 DB에 저장되지 않는다. Wait 실행·사용자 일시정지 시 인터뷰 데이터 전체가 직렬화되어 **Paused Flow Interview 레코드**로 저장, 재개 시 삭제 (프로그래매틱 접근은 [[Flow Interview API]] 참조).
- Lightning runtime 활성 시 로드되지 않는 곳 — LEX: Web 탭, 기존 창(사이드바 유무 무관) 표시로 설정된 리스트 버튼 / Classic: 기존 창 표시로 설정된 커스텀 버튼·링크.
- 숫자 입력 필드는 소수점 앞뒤 합쳐 **최대 17자리**.
- 런타임 검증 오류 메시지는 사용자가 수정해도 화면에 남는다 — 메시지가 있어도 인터뷰 완료는 가능.

### 8-3. 런타임 접근성 (Section 508·WCAG 2.0 AA 예외)

- Next/Previous 클릭 시 화면 title이 바뀌지 않아 페이지 전환이 불분명.
- 레이블 없는 화면 컴포넌트는 보조 기술이 제대로 읽지 못한다.
- ARIA alert role 등을 쓰지 않으면 감지 안 되는 커스텀 오류: 조건부 표시 텍스트 컴포넌트 오류 메시지, Validate Input 수식 false 시 표시되는 오류 메시지.
- 스크린 리더 언어 설정이 flow 언어와 다르면 정확히 읽지 못한다 — Run/Debug 버튼·URL·커스텀 버튼/링크·Web 탭 실행 flow에 영향.
- 입력 필드와 오류 메시지가 연결되지 않는 표준 컴포넌트: Dependent Picklists, Email, Lookup, Phone, Toggle, URL.
- Dependent Picklists 필수 필드 미입력 오류는 스크린 리더가 읽지 못한다 (1회 안내 후 재포커스 시 미안내 가능).
- 데스크톱(LEX) Paused Flow Interviews 컴포넌트의 Resume 창에서 Finish 클릭 시 Refresh 아이콘 버튼에 포커스가 가지 않는다.
- 화면 초기 표시 시 포커스는 첫 표시 필드 (오류 있으면 첫 오류 필드, Display Text만 있으면 flow 본문).
- 초기 표시 이후 렌더링된 컴포넌트·부분은 포커스 불가.

## 9. 관리(Management) 고려사항

- **조회** — LEX Setup의 Flows 페이지는 All Flows 리스트 뷰 Sharing Settings가 "Only I can see this list view"면 아무 flow도 표시하지 않는다.
- **활성화** — 새 버전을 활성화하면 기존 활성 버전은 자동 비활성화. **실행 중인 인터뷰는 시작한 버전으로 계속 실행**된다.
- **삭제** — 활성 버전은 먼저 비활성화해야 삭제 가능. **paused 인터뷰가 있는 flow는 인터뷰가 끝나거나 삭제될 때까지 삭제 불가.** 한 번도 활성화되지 않은 flow는 언제든 삭제 가능.
- **Flow 타입** — 버전별 타입이 다르면 활성(없으면 최신) 버전이 flow 타입을 결정.
- **배포** — 프로덕션 조직에서만 "프로세스·flow를 활성 상태로 배포" 설정이 보인다 (scratch·sandbox·developer 조직은 항상 활성 배포 가능하므로 설정 없음).

## 10. 패키징·Change Set·설치된 Flow (핵심 요약)

> 배포 절차 자체보다 **하드 제약·블로커**만 추린다.

- 패키지·change set에는 flow가 참조하는 모든 컴포넌트가 있어야 한다. 단 **Post to Chatter·Send Email·Submit for Approval**이 참조하는 컴포넌트(Chatter 그룹, 승인 프로세스 등)와 Lightning 컴포넌트가 의존하는 **CSP Trusted Site**는 자동 포함되지 않는다 — 수동 추가 필수.
- 패키지 업로드 시 **활성 버전**이 포함된다 (활성 버전이 없으면 최신 버전).
- **flow는 패키지 patch에 포함 불가.** **flow trigger는 패키징·change set 모두 불가.**
- Change set: flow당 **버전 1개만** 포함 가능 / 활성 flow도 대상 조직에는 **비활성으로 배포** — 배포 후 수동 활성화 (Metadata API·change set의 활성 배포 설정은 프로덕션 전용).
- 패키지 설치: 활성 flow가 든 패키지는 설치 후 **활성** — 대상 조직의 기존 활성 버전은 비활성화되고, 진행 중 인터뷰는 이전 버전으로 계속 실행. 관리 패키지에 여러 버전이 있어도 신규 조직엔 **최신 버전만** 배포.
- 이름 충돌: unmanaged 패키지에서 같은 이름·**같은 버전 번호**면 설치 실패 (덮어쓰기 불가), 같은 이름·다른 버전이면 기존 flow의 최신 버전이 됨. **unlocked 패키지**는 같은 API명이면 기존 flow를 **덮어쓴다**.
- 설치된 flow 제거: 설치된 패키지에서 flow만 삭제 불가 — 비활성화 후 패키지 언인스톨. 한 버전만 든 패키지를 언인스톨하면 **전체 flow(모든 버전) 삭제**. unlocked 패키지의 flow는 패키지에서 빼는 방식으로 삭제 불가 — 수동 삭제.
- 1GP 패키징 조직: released/beta 관리 패키지에 업로드한 flow는 삭제 불가. flow **버전** 삭제는 4조건 모두 충족 시에만 — ① Salesforce 지원이 Managed Component Deletion 권한 활성화 ② 가장 최근 패키징된 버전이 아님 ③ 활성 버전 아님 ④ 유일한 버전 아님.
- 관리 패키지에서 설치한 flow는 템플릿·overridable이 아니면 Builder로 열 수 없고, (비템플릿이면) 오류 이메일에 **개별 요소 상세가 빠진다** (수신자: 설치한 사용자 또는 Apex exception email recipients).
- Builder는 관리 패키지의 Apex 액션 중 **global** 메서드만, 이메일 알림 중 **비보호(unprotected)**만 표시.
- Visualforce·Apex에서 flow를 참조한 뒤 네임스페이스를 등록했다면 패키지 설치 전에 flow 이름에 네임스페이스를 추가.
- 배포 URL 형식: `/flow/namespace/flowuniquename` / Visualforce 임베드 `name` 속성: `namespace.flowuniquename`.
- 화면 rich text 안의 이미지는 패키지 미지원. flow 정의 이름 번역은 Translate 페이지에서만 가능.
- 관리 패키지 업그레이드는 개발자의 새 flow 버전이 있을 때만 새 버전을 설치 — 여러 번 업그레이드하면 버전이 누적된다.

## 11. 트러블슈팅·오류 이메일 한도

**디버깅:**
- **rollback mode 없이 디버그하면 DML·Apex 실행 등 액션이 실제 수행**된다 — 실행 중 flow를 닫거나 재시작해도 이미 실행된 액션·콜아웃·커밋은 롤백되지 않는다. **Delete 요소가 있는 flow는 비활성 상태여도 디버그 시 삭제가 실제 실행**되므로 특히 주의.
- 디버그에서 collection·record·record collection 타입 입력 변수에 값 전달 불가.
- Pause 클릭·Wait 요소 실행은 flow를 닫고 디버깅을 종료한다.
- 다른 사용자로 디버그하면 레코드 변경·액션이 그 사용자로 수행되고 그 사용자의 오브젝트 권한·FLS가 적용된다 (system context flow는 무시).
- Finish 클릭 시 디버그 상세에 "Selected Navigation Button: NEXT"로 잘못 표기된다.
- schedule-triggered flow 디버그는 **레코드 1건**으로만 시작. record-triggered flow 디버그는 flow 내부만 테스트 — 다른 트리거 flow·프로세스 영향이 빠지므로 실제 동작은 sandbox에서 검증.
- 인터뷰 추적: 인터뷰는 일시정지되어 레코드로 저장될 때만 18자리 Salesforce ID를 받는다. in-flight든 paused든 **GUID는 항상 존재** — 추가 정보를 남기려면 GUID를 참조하는 커스텀 오브젝트 활용.

**오류 이메일·실패 인터뷰 저장 한도:**
- flow를 시작한 사용자의 이름(First Name)이 없으면 null로 표기. 변수 할당 표기 패턴: `{!variable} (prior value) = field/variable (new value)` — 이전 값이 없으면 빈 괄호.
- Flow Builder **free-form 레이아웃**으로 만든 다음 flow 타입의 실패 인터뷰는 저장되어 Builder에서 열 수 있다: screen flow, record-triggered flow, schedule-triggered flow, 트리거 없는 autolaunched flow.
- 실패 인터뷰가 **저장되지 않는** 경우: 비템플릿 관리 패키지 flow / 일시정지 후 재개된 뒤 실패 / fault connector로 오류가 처리됨 / Apex 테스트 메서드 중 실패 / 표준(standard) flow / 메타데이터 status가 Draft·InvalidDraft / 인터뷰 1 MB 초과 / DB에 저장된 실패 인터뷰 총량 1 GB 초과.
- 실패 인터뷰는 데이터·파일·paused flow interview 스토리지 한도에 카운트되지 않으며, **최대 14일 보관 후 자동 삭제**.
- 실패 인터뷰 저장 한도: flow당 24시간에 **100개** / 같은 트랜잭션의 최대 200개 실패 인터뷰 배치당 **1개** 저장 / 조직 전체 24시간에 **3,000개** / **1 MB 초과 인터뷰 저장 안 함** / 누적 **1 GB 초과 시 저장 안 함**.
- Screen 요소: 비밀번호 필드가 **평문으로 표시**된다.
- Subflow 요소: 참조 flow의 변수는 머지 필드 표기(`{!variable}`)가 빠진 채 표기 / 참조 flow에서 오류가 나면 이메일은 **부모 flow 작성자**에게 가지만 제목은 참조 flow 이름 / `Entered flow ... version ...` 메시지가 `Exited ...` 없이 반복되면 사용자가 뒤로 이동한 것 — 참조 flow 첫 화면에서 Previous를 막아 방지.

> Fault path 설계·오류 이메일 수신자 설정(User Who Last Modified vs Apex Exception Email Recipients)은 [[Flow 에러 처리]] 참조.

## 12. Versioned Updates — 릴리즈·API 버전별 런타임 변경

**특정 API 버전에서 실행되도록 구성된 flow에만** 적용되는 런타임 동작 변경. flow별로 편한 시점에 테스트·채택할 수 있다. 변경 방법: Flow Builder에서 flow를 열고 **flow version properties**에서 run-time API 버전 수정.

### Winter '25 (API 버전 62.0 이상)

- **Enforce Sharing Rules when Apex Launches a Flow** — `with sharing`으로 선언된 Apex 클래스가 기본 컨텍스트로 실행되는 autolaunched flow를 실행하면 **공유 규칙을 강제**한다. 이전에는 `with sharing` Apex가 실행해도 flow가 공유 없는 시스템 컨텍스트로 돌아 모든 데이터에 접근 가능했다. 적용 후에는 Apex 실행 사용자의 공유 규칙으로 데이터 접근이 제한된다 — 쿼리 행 수가 줄거나 권한 부족으로 작업이 실패할 수 있다.
- **Set Screen Action Outputs to Null Correctly** — screen action이 실행한 flow의 출력이 Assignment 요소로 설정되지 않으면 출력이 기대대로 **null로 설정**되고, 그 출력을 쓰는 화면 컴포넌트가 자동 갱신된다.
- **Set Conditionally Hidden Screen Component Outputs to Null Correctly** — 조건부로 숨겨진 화면 컴포넌트의 출력이 컬렉션이면 출력이 기대대로 **null로 설정**된다.

### Summer '24 (API 버전 61.0 이상)

- **Evaluate Null Text Values** — null 텍스트 값이 flow에서 **null로 평가**된다 (이전에는 빈 문자열로 평가). 예: 빈 picklist 값은 61.0 이상에서 null 텍스트 값으로 평가.

---

## 관련 노트

- [[Flow 설계 베스트 프랙티스]] — §6 거버너 한도 회피 패턴 (Loop 밖 DML·Get Records) — 이 노트의 한도 수치를 회피하는 설계 소관
- [[Governor Limits]] — Apex 공용 per-transaction 거버너 한도 전체 (flow가 공유하는 상위 한도)
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — 플랫폼 전역 한도·할당량
- [[Flow 종류와 변수]] — flow 타입(processType)·변수 기초
- [[Flow 에러 처리]] — fault path 설계·오류 이메일 수신자 설정
- [[Flow Interview API]] — Paused Flow Interview 레코드의 프로그래매틱 접근
- [[Record-Triggered Flow vs Apex Trigger 선택]] — 트리거 자동화 선택 기준
- [[Screen Flow 설계]] — 화면 설계 패턴 (조건부 표시·반응형 화면의 설계 측면)
