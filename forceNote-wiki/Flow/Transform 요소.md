---
tags: [flow, transform, element, data-mapping, collection, formula, reference]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Transform Element, Flow Transform, 트랜스폼 요소, 데이터 변환 요소, Transform Data in a Flow, EachItem, 플로우 데이터 매핑]
---

# Transform 요소

> 소스 데이터를 타깃 데이터로 매핑·변환하는 Flow 요소. 컬렉션 간 필드 매핑, 수식 변환, Sum/Count 집계를 캔버스에서 선언적으로 처리한다.

---

## 개요

**Transform 요소**는 Salesforce와 외부 시스템 간 데이터 변환을 자동화한다. **소스와 타깃 데이터 간 매핑을 만들거나, 타깃 데이터에 고정값을 설정**할 수 있다.

- 사용 가능한 Flow 종류: **Screen Flow, 트리거 없는 Autolaunched Flow, Record-Triggered Flow**
- 에디션: Salesforce Classic(일부 org 제외)·Lightning Experience / Essentials, Professional, Enterprise, Performance, Unlimited, Developer
- 필요 권한: Flow 열기·편집·생성 = **Manage Flow**
- 시작 전에 소스·타깃 데이터의 구조(컬렉션 안에 컬렉션이 있는 다층 구조인지)를 파악해야 한다 — 컬렉션 필드 매핑에는 데이터 무결성 보존 규칙이 적용된다(아래 "컬렉션 매핑 무결성 규칙")

> 소스 특이사항: PDF 원문에 데모 영상 링크("Transform Your Data with Flow Builder", 영어)와 매핑 UI 스크린샷이 있으나 본 노트는 텍스트 설명만 담는다.

---

## 요소 구성 필드 (Flow Element: Transform 레퍼런스)

| 필드 | 설명 |
|---|---|
| **Source Data** | 변환할 데이터. **Resource** — Flow에서 사용 가능한 리소스. **여러 리소스를 추가할 수 있다** |
| **Target Data** | 변환된 후의 데이터. **Allow multiple values (collection)** — 타깃이 컬렉션이면 선택(이때 소스 데이터에 컬렉션이 1개 이상 있어야 함). **Apex Class** — 타깃 데이터 구조로 쓸 Apex 클래스. **Data Type** — 타깃 리소스의 데이터 타입. **Object** — 타깃 데이터 구조로 쓸 객체 |
| **Formula** | 데이터를 변환하는 수식. ① 타깃 필드에 **고정값** 설정 가능. ② **서로 중첩된 소스 컬렉션을 최대 2개까지 참조** 가능(예: 소스 필드가 컬렉션 A를 담고, A가 컬렉션 B를 담는 구조). 컬렉션을 참조하지 않는 추가 Flow 리소스도 소스로 참조 가능. ③ 수식 결과는 타깃 필드 데이터 타입과 호환돼야 함 |

수식에서 `[$EachItem]` merge field 문법은 **컬렉션의 각 항목**을 나타낸다. 원문 예시 — orders 컬렉션의 각 항목이 Customers 필드를 갖고, 각 Customers가 Name 필드를 가질 때:

```
{!Orders[$EachItem].Customers[$EachItem].Name}
```

---

## 절차 1 — 데이터 매핑·변환 (Transform Data in a Flow)

1. **Transform 요소를 Flow에 추가**
   - a. Label·API 이름·설명 입력
   - b. **Source Data** — Add Resource 버튼 클릭 후 변환할 Flow 리소스 선택
   - c. **Target Data** — Add Resource 버튼 클릭 후 데이터 타입 선택
   - d. 타깃이 컬렉션이면 **Allow multiple values (collection)** 선택
   - e. 데이터 타입이 record 또는 Apex-defined면 Transform 요소가 생성할 타깃 데이터의 **Apex 클래스 또는 객체 선택**. 예: 타깃을 컬렉션 + Account 객체로 지정하면 account 컬렉션이 생성되고, 컬렉션을 지정하지 않으면 단일 account가 타깃
2. **소스와 타깃 데이터 매핑**
   - a. 소스 데이터 필드에 마우스를 올리고 **Map 버튼** 클릭
   - b. 타깃 데이터 필드 옆의 Map 버튼 클릭. **Map 버튼이 없는 타깃 필드에는 매핑할 수 없다**
   - c. 매핑 불가한 타깃 필드·컬렉션의 팁을 보려면 해당 필드에 마우스를 올린 뒤 오류 아이콘에 호버
   - d. 설정 오류(misconfiguration)의 매핑 팁은 타깃 필드·컬렉션 옆 오류 아이콘에 호버
   - 접힌(collapsed) 객체·컬렉션 내부의 매핑은 **대시선(dashed line)**으로, 매핑된 필드를 담은 컬렉션은 **점선(dotted line)**으로 표시돼 양쪽 리소스 구조에서 컬렉션을 쉽게 식별할 수 있다
3. **수식으로 변환** — 매핑된 필드 이름 클릭 → **Formula** 클릭
4. **매핑 삭제** — 필드 이름 클릭 → Delete 버튼

### 변환 결과 저장

| 저장 대상 | 방법 |
|---|---|
| **Salesforce** | Update Records 요소를 추가하고 **Transform 요소와 같은 이름의 리소스**를 참조하도록 구성. 예: Transform 요소의 API 이름이 `Return_Order`면 Update Records의 Record/Record Collection에서 `Return_Order` 선택 |
| **외부 시스템** | **POST 같은 메서드를 쓰는 HTTP 콜아웃 액션** 생성 → [[Flow HTTP Callout 빌더]] |

### 원문 예시 — 반품 주문 (restocking fee 수식)

영업 담당자가 Screen Flow로 주문 2건을 스토어 크레딧 반품 처리한다. 고객 계정은 Salesforce에, 주문 데이터는 외부 시스템에 있다. Flow가 외부 시스템에서 최신 주문 데이터를 가져와 변환한 뒤 Salesforce에 저장한다.

- Transform 요소에서 소스 필드 `amount`·`customerId`·`status`를 타깃 필드에 매핑
- `amount` → `Amount__c` 매핑에 수식 사용: 소스 amount에서 **재입고 수수료로 고정 금액을 차감**. merge field가 2XX(콜아웃 응답) 컬렉션을 참조하고, 각 2XX 항목의 amount 필드에서 5를 뺌 — `[$EachItem]`이 컬렉션 각 항목을 대표
- 이후 Update Records 요소가 변경을 DB에 저장하고, 마지막 Action 요소가 HTTP 콜아웃으로 외부 시스템의 주문 상태를 업데이트

```
<!-- 구조 예시 — 실제 원본 다이어그램 아님 -->
[HTTP Callout (GET 주문)] → [Transform: 2XX 응답 → Order 레코드 매핑 (amount-5 수식)]
    → [Update Records: Transform 결과 저장] → [HTTP Callout (POST 상태 업데이트)]
```

---

## 절차 2 — 컬렉션 Sum·Count 집계 (Sum or Count Items in Collections)

소스 컬렉션의 데이터를 집계해 **항목 수(count) 또는 합계(sum)를 계산**하고 결과를 타깃 데이터 필드에 할당한다.

1. Transform 요소 추가 — Label·API 이름·설명 입력, Source Data에서 **집계할 컬렉션을 참조하는 리소스** 선택, Target Data 타입 선택(컬렉션이면 Allow multiple values, record/Apex-defined면 클래스·객체 선택)
2. **소스 컬렉션을 Number 데이터 타입의 타깃 필드에 매핑** — 소스 컬렉션에 호버해 Map 버튼 → Number 타입 타깃 필드 옆 Map 버튼. 컬렉션 필드 매핑 시 소스·타깃 필드는 각자 리소스에서 **같은 계층 레벨**이어야 함
3. **Aggregate Type**에서 **Count 또는 Sum** 선택
4. **Field to Transform**에서 소스 컬렉션 각 항목에서 계산할 필드 선택 — **Sum 집계 타입에서만 사용 가능**
5. Flow 저장

원문 예시: 외부 시스템에서 회사 지점(locations)·지점별 직원 수 데이터를 가져오는 Flow. `CompanyDetails` 소스 컬렉션을 `NumberOfLocations` 타깃 필드에 매핑해 **지점 수를 Count**, 같은 컬렉션을 `NumberOfEmployees` 타깃 필드에 매핑해 **전 지점 직원 수를 Sum**.

---

## 제약·규칙 (Usage)

### 일반 제약

- 컬렉션 변환에 **조인(joining)·정렬(sorting)·필터링(filtering)은 포함할 수 없다.** 컬렉션 필터·정렬은 **Collection Filter 또는 Collection Sort 요소**를 대신 사용
- 소스·타깃 데이터의 **리치 인터랙티브 디버그 상세**는 트리거 없는 Autolaunched Flow와 Record-Triggered Flow에서만 지원
- 타깃 데이터 리소스가 **external service 등록에서 온 Apex 클래스**면 Flow Builder 디버그 상세에 변경된 필드 이름이 표시됨:
  - 필드가 Apex 예약어를 쓰면 이름 앞에 `z0`이 붙음 (예: `z0type`) — 실제 콜아웃 시엔 원래 이름(`type`) 사용
  - `_set`이 붙는 필드(예: `name_set`)는 dynamic Apex 클래스에 자동 추가됨 — Flow 디버그 상세와 dynamic Apex 클래스 조회 시에만 표시 (원문 SEE ALSO: Apex Reserved Keywords·External Service Registrations in Apex → [[External Services]])
- 표준·커스텀·외부 객체의 **lookup 필드를 통한 관련 레코드 접근 미지원**
- **Checkbox Group·Picklist·Choice Lookup 화면 컴포넌트**는 소스·타깃 데이터의 Flow 리소스로 미지원
- **Repeater 컴포넌트의 출력은 Transform(·Collection Filter·Collection Sort) 요소에서 미지원** (Flow Screen Input "Repeater" considerations)

### 컬렉션 매핑 무결성 규칙

- 소스 컬렉션 필드 ↔ 타깃 컬렉션 필드 매핑 시 두 컬렉션은 **각자 리소스에서 같은 계층 레벨**이어야 함. 예: 소스의 컬렉션 A와 타깃의 컬렉션 A가 모두 다른 컬렉션 안에 있지 않은 최상위 컬렉션이면 서로 필드 매핑 가능
- **중첩 컬렉션의 필드를 매핑하기 전에 부모 컬렉션의 필드를 먼저 매핑**해야 함. 예: 소스·타깃 리소스가 각각 같은 구조의 컬렉션 A를 갖고 A가 컬렉션 B를 담을 때 — A의 필드를 먼저 매핑한 뒤 B의 필드를 매핑
- 런타임에 **매핑되지 않았거나 null인 타깃 필드는 Transform 요소가 생성하는 Flow 리소스에서 제거**됨

### 한도 (Limits)

| 항목 | 한도 |
|---|---|
| 중첩 컬렉션 매핑 | **최대 1개** |
| Apex-defined 리소스 필드의 Apex-defined 필드 중첩 참조 | **최대 10레벨** (CollectionA의 Name 필드 = 1레벨, CollectionB의 필드 = 2레벨 …) |
| 디버그 상세의 컬렉션 표시 | **최대 20 레코드** |
| Transform 요소 안의 수식 길이 | **255자** (초과분은 잘림). 255자를 넘겨야 하면 Flow에 **formula 리소스**를 만들어 — formula 리소스는 255자 초과 가능 — Transform 요소에서 그 리소스를 선택 |

---

## 활용 패턴

### 시스템 컨텍스트 Screen Flow의 필드 노출 최소화 (Experience Cloud)

시스템 컨텍스트로 실행되는 Experience Cloud 사이트의 Screen Flow에서 record 변수/컬렉션을 Create·Update·Delete Records 요소에 써야 한다면, **Transform 요소를 먼저 사용해 편집을 원치 않는 필드를 걸러낸(filter out) 뒤** Transform이 생성한 record 변수/컬렉션을 해당 DML 요소에서 선택한다 (ECA "Distribute a Flow" 권고).

### HTTP Callout과의 조합

Flow에서 Salesforce↔외부 시스템 간 데이터 변환에 Transform 요소를 쓴다. POST·PUT·PATCH·DELETE 콜아웃은 Transform과 별도로 액션 앞 Assignment 요소로 Apex-defined 변수 필드를 채운다 → 절차·Apex 클래스 네이밍은 [[Flow HTTP Callout 빌더]] 소관.

### 표준 Transform vs 커스텀 Invocable 액션

[[Flow 레코드 컬렉션 조작]]의 Apex `@InvocableMethod` 액션들(AggregateRecordList·FilterRecordsWithFieldValue 등)과 역할이 겹친다. 선택 기준:

| 작업 | 표준 Transform 요소 | 커스텀 액션 ([[Flow 레코드 컬렉션 조작]]) |
|---|---|---|
| 필드 매핑·구조 변환 (record↔Apex-defined) | ✅ 전용 기능 | ❌ 별도 구현 필요 |
| Sum·Count 집계 | ✅ Aggregate Type 내장 | AggregateRecordList (SUM·**AVERAGE·MIN·MAX**까지) |
| 필터·정렬·조인·중복 제거 | ❌ 미지원 (필터·정렬은 Collection Filter/Sort 요소) | FilterRecords·JoinRecordLists·DedupeRecordList |
| 수식 기반 값 변환·고정값 | ✅ Formula (255자, formula 리소스로 확장) | Apex 코드 자유 |
| 배포물 | 없음 (표준 요소) | Apex 클래스 배포 필요 |

> Winter '26부터는 별도 Transform 요소 없이 **액션 설정 안에서 인라인 변환**도 가능하다 — [[Flow 설계 베스트 프랙티스]] §10 참조.

---

## 관련 노트

- [[Flow HTTP Callout 빌더]] — 외부 시스템 연동 시 Transform의 짝 (응답 매핑·POST body)
- [[Flow 레코드 컬렉션 조작]] — 필터·조인·중복 제거 등 Transform 미지원 작업의 커스텀 액션 대안
- [[Flow 설계 베스트 프랙티스]] — §10 인라인 Transform (Winter '26)
- [[Flow 요소 참조]] — Flow 요소 XML 구조 전반
- [[Flow 종류와 변수]] — Apex-Defined 변수 (Transform 타깃 타입)
- [[External Services]] — external service 등록 Apex 클래스의 `z0`·`_set` 필드 배경
