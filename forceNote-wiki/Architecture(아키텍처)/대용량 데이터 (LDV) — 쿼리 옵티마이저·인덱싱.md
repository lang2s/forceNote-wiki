---
tags: [architecture, large-data-volumes, ldv, query-optimizer, selectivity, indexing, skinny-tables, soql, performance]
source: salesforce_large_data_volumes_bp.pdf (Best Practices for Deployments with Large Data Volumes, Spring '26, Tier 2)
created: 2026-06-17
aliases: [Large Data Volumes, LDV, 대용량 데이터, Query Optimizer, 쿼리 옵티마이저, Selectivity, 선택도, non-selective query, 비선택적 쿼리, Skinny Table, 스키니 테이블, Custom Index, 커스텀 인덱스, Two-Column Index, Database Statistics, 리포트가 느려요, 리스트뷰가 느려요, SOQL이 느려요, 쿼리 타임아웃, query timeout, full table scan, 풀 테이블 스캔, 인덱스가 안 먹어요, 인덱스 임계값, Divisions, 디비전]
---

# 대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱

> 대용량 데이터(LDV) 환경에서 **읽기 경로**(쿼리·리포트·리스트뷰)의 성능을 결정하는 Lightning Platform 쿼리 옵티마이저·선택도(selectivity)·인덱스·스키니 테이블·Divisions·SOQL/SOSL 작성 원칙. 쓰기 경로(로드·삭제·추출)는 [[대용량 데이터 (LDV) — 대량 로드·삭제]] 참조.

---

## 개요

**Large Data Volume(LDV)** 은 정확한 경계가 없는 탄력적 용어다. 백서 정의: 배포 환경에 **수만 명의 사용자, 수천만 개의 레코드, 또는 수백 GB의 총 레코드 스토리지**가 있으면 LDV로 본다. 데이터가 커질수록 특정 작업의 소요 시간이 늘어나며, 아키텍트의 데이터 구조·작업 설계 방식에 따라 그 시간이 **수 자릿수(orders of magnitude)** 차이로 늘거나 줄 수 있다.

성능에 영향을 받는 주요 프로세스는 두 가지다.

- **로드/업데이트** — 직접 또는 통합을 통한 대량 레코드 적재·갱신 (쓰기 경로 → [[대용량 데이터 (LDV) — 대량 로드·삭제]])
- **추출** — 리포트·쿼리·뷰를 통한 데이터 읽기 (**이 노트의 범위**)

> 이 백서는 standard/custom 객체에 저장된 LDV 최적화에 초점을 맞춘다. **Big Objects**(1백만~10억 레코드까지 일관된 성능)는 별도 기술이며, 더 큰 데이터셋을 Big Object로 옮길 때는 Bulk API 또는 Batch Apex를 사용한다.

이 노트의 범위(읽기 경로):
- Lightning Platform 쿼리 옵티마이저의 동작
- 선택도(selectivity) 판정 — 인덱스 사용 임계값
- 인덱스(기본/Custom/External ID/Two-Column/Cross-object)
- Skinny Tables
- Divisions
- SOQL·SOSL 쿼리 작성 원칙
- 읽기 관련 케이스 스터디

> **Data Skew 위임:** account/ownership skew, 1만 건 소유·자식 임계값의 *메커니즘*, Rendering Related Lists 케이스 스터디는 본 노트에서 재서술하지 않는다. [[Data Skew]] 참조.

---

## Lightning Platform Query Optimizer

Salesforce 멀티테넌트 아키텍처는 기반 데이터베이스를 사용하는 방식 때문에 DB 자체의 옵티마이저가 검색 쿼리를 효과적으로 최적화할 수 없다. **Lightning Platform 쿼리 옵티마이저**는 효율적인 데이터 접근을 제공해 DB 옵티마이저가 효과적인 쿼리를 생성하도록 돕는다.

쿼리 옵티마이저는 **리포트·리스트뷰·SOQL 쿼리를 처리하는 자동 생성 쿼리**, 그리고 이 생성 쿼리에 의존하는 다른 쿼리에 작동한다.

옵티마이저의 동작(전수, 6가지):

1. 쿼리의 필터를 기준으로, 가능하면 **쿼리를 구동할 최적 인덱스**를 결정한다.
2. 좋은 인덱스가 없으면 **쿼리를 구동할 최적 테이블**을 결정한다.
3. 비용을 최소화하도록 **나머지 테이블의 정렬 순서**를 결정한다.
4. 효율적인 조인 경로 생성에 필요한 **custom foreign key value table**을 주입한다.
5. sharing 조인을 포함한 나머지 조인의 **실행 계획**에 영향을 주어 DB I/O를 최소화한다.
6. **통계(statistics)를 갱신**한다.

### Database Statistics (야간 수집)

현대 DB는 저장된 데이터의 양·유형 통계를 수집해 쿼리를 효율적으로 실행한다. Salesforce는 멀티테넌트 구조 때문에 **자체 통계 정보 집합**을 유지해야 한다. 따라서 API로 대량 데이터를 생성·갱신·삭제하면, 애플리케이션이 데이터를 효율적으로 접근하기 전에 DB가 통계를 다시 수집해야 한다. **이 통계 수집 프로세스는 현재 야간(nightly) 단위로 실행된다.**

---

## 선택도(Selectivity) 판정

대용량 데이터에서는 selectivity와 인덱스에 의존하는 효율적인 SOQL·리포트·리스트뷰를 만드는 것이 중요하다. 쿼리 옵티마이저는 SOQL/리포트/리스트뷰의 **필터 조건 selectivity**를 판정한다. 간단한 SOQL로 특정 필터 조건이 선택적인지 판단할 통계를 얻을 수 있다.

### Determine Selectivity — 통계 얻기 방법

기본 단항(unary) WHERE 조건의 selectivity 통계를 얻으려면 `GROUP BY ROLLUP`을 사용한다.

LDV 백서 예시 — 단일 picklist 필드(Stagename)의 분포 통계:

```sql
SELECT Stagename, COUNT(id) FROM Opportunity
GROUP BY ROLLUP (Stagename)
```

결과 집합은 Stagename picklist 값별 레코드 분포와 객체 총 레코드 수를 보여준다.

복합 조건(date 필드 + AND)의 통계 — LDV 백서 예시:

```sql
SELECT WEEK_IN_YEAR(CloseDate), CALENDAR_YEAR(CloseDate), COUNT(id)
FROM Opportunity
GROUP BY ROLLUP(WEEK_IN_YEAR(CloseDate),CALENDAR_YEAR(CloseDate))
ORDER BY CALENDAR_YEAR(CloseDate), WEEK_IN_YEAR(CloseDate)
```

삭제 레코드 영향: selectivity 통계를 모을 때 `IsDeleted` Boolean 필드(모든 standard/custom 객체에 존재)로 삭제 레코드를 포함하거나 제외할 수 있다. `ROLLUP` 쿼리는 `IsDeleted` 값과 무관하게 모든 레코드를 집계한다. 삭제 레코드를 명시적으로 제외하려면 — LDV 백서 예시:

```sql
SELECT Stagename, COUNT(id) FROM Opportunity WHERE IsDeleted=false GROUP BY Stagename
```

### AND 복합 조건의 selectivity

두 개 이상의 조건을 AND로 결합할 때, 옵티마이저는 다음 중 하나보다 작으면 전체 필터 조건을 선택적으로 본다.

- **각 필터 selectivity 임계값의 2배** 미만, 또는
- **두 필드 교집합(intersection)의 selectivity 임계값** 미만

> LDV 백서 예시 (임계값 150,000 기준):
> - `Status = 'Closed Won'` 은 선택적 (49,899 < 150,000)
> - `CloseDate = THIS_WEEK` 은 선택적 (~3000 < 150,000)
> - 따라서 전체 조건 선택적.
>
> 만약 `Status='Closed Won'` 이 250,000 레코드로 비선택적이라면, 다음 둘 중 하나로 전체가 선택적이 될 수 있다.
> - 각 필터 조건이 **300,000 레코드 미만**(각 필터 임계값의 2배), 또는
> - `Status='Closed Won' AND CloseDate = THIS_WEEK` 교집합이 **150,000 레코드 미만**.
> - 예시 조건은 300,000 미만이므로 전체가 선택적.

> **OR 연산자:** 각 필터가 **개별적으로** 임계값을 충족해야 한다.

### ★ 인덱스 selectivity 임계값 표 (원문 수치 그대로)

| 구분 | 인덱스 사용 조건 | 최대 | 백서 예시 |
|---|---|---|---|
| **Standard Indexed** | 첫 100만 레코드의 **30% 미만** + 추가분의 **15% 미만** | 최대 **100만** | 200만 행 → **450,000 이하**, 500만 행 → **900,000 이하** |
| **Custom Indexed** | 전체 레코드의 **10% 미만** | 최대 **333,333** | 50만 행 → **50,000 이하**, 500만 행 → **333,333 이하** |
| **pre-query 컷오프** | 통계 테이블 pre-query 결과가 **10% 또는 333,333 초과** 시 custom index 미사용 | — | — |
| **AND** | 인덱스 중 **하나라도 20% 또는 666,666 초과** 반환 시 그 index 미사용 | — | — |
| **OR** | **모든** 인덱스가 **10% 또는 333,333 초과** 반환 시 미사용. **OR의 모든 필드가 인덱스**여야 어떤 인덱스든 사용 | — | — |
| **LIKE** | 내부 통계 테이블 미사용 — 실제 데이터를 **최대 100,000건 샘플링**해 custom index 사용 여부 결정 | — | — |

> pre-query 동작: 옵티마이저는 각 인덱스의 데이터 분포 통계 테이블을 유지하고, **pre-query**로 인덱스가 쿼리를 빠르게 할지 판정한다. 예: `Account_Type__c = 'Large'` 의 레코드 수가 객체 총 레코드의 **10% 또는 333,333 초과**면 custom index를 쓰지 않는다.
>
> 인덱스 필드 기준이 충족되지 않으면 **그 인덱스만** 쿼리에서 제외된다. WHERE에 있고 임계값을 충족하는 다른 인덱스는 사용될 수 있다.

---

## 인덱스(Indexes)

Salesforce는 쿼리 가속을 위해 custom index를 지원한다. **두 가지 생성 방법:**

1. Salesforce Customer Support에 문의
2. **Metadata API로 custom index XML 파일 배포**

> Customer Support가 production에 만든 custom index는 그 production에서 만드는 **모든 sandbox로 복사**된다.

### 기본 인덱스 필드 (대부분 객체에서 유지, 전수)

- **RecordTypeId**
- **Division**
- **CreatedDate**
- **Systemmodstamp (LastModifiedDate)**
- **Name**
- **Email** (contacts와 leads)
- **Foreign key relationships** (lookup·master-detail)
- **고유 Salesforce record ID** — 각 객체의 primary key

> custom 필드의 custom index는 지원되나, **text areas (long), text areas (rich), 비결정적 formula 필드, encrypted text 필드는 제외**된다.

### External ID — 인덱스 자동 생성 (4필드)

External ID는 해당 필드에 인덱스를 생성하고, 옵티마이저가 그 필드를 고려한다. External ID는 **다음 4개 필드 타입에만** 만들 수 있다.

- **Auto Number**
- **Email**
- **Number**
- **Text**

> 그 외 필드 타입(standard 필드 포함)의 custom index는 Customer Support에 문의.

### Index Tables — null 제외 기본 동작

멀티테넌트 구조상 custom 필드의 기반 데이터 테이블은 인덱싱에 부적합하다. 플랫폼은 데이터 사본과 타입 정보를 담은 **index table**을 만들고 그 위에 표준 DB 인덱스를 만든다. index table은 인덱스 검색이 효과적으로 반환할 수 있는 레코드 수에 상한을 둔다.

> **기본적으로 index table은 null(빈 값) 레코드를 포함하지 않는다.** Customer Support와 작업해 null 행을 포함하는 custom index를 만들 수 있다. 이미 custom 필드에 custom index가 있어도, 빈 값 행을 인덱싱하려면 **명시적으로 활성화하고 rebuild**해야 한다.

### Two-Column Custom Indexes

특수 기능. **한 필드로 표시할 레코드를 선택하고 다른 필드로 정렬**하는 리스트뷰 등에 유용하다. 예: State로 선택하고 City로 정렬하는 Account 리스트뷰는 첫 컬럼 State, 둘째 컬럼 City인 two-column index를 사용할 수 있다.

LDV 백서 예시 — 두 필드 조합이 흔한 필터일 때, `f1__c,f2__c` two-column index가 단일 인덱스보다 효율적:

```sql
SELECT Name
FROM Account
WHERE f1__c = 'foo'
AND f2__c = 'bar'
```

> **null 예외:** two-column index는 단일 컬럼 인덱스와 동일한 제약을 받지만 **한 가지 예외**가 있다. **two-column index는 둘째 컬럼에 null을 가질 수 있다.** 반면 단일 컬럼 인덱스는 Customer Support가 null 포함 옵션을 명시적으로 활성화하지 않는 한 null을 가질 수 없다.

### Cross-Object Indexes

cross-object notation으로 지정하면 cross-object index가 일반적으로 사용된다. 다른 객체를 참조해 custom-index가 불가능한 formula 필드를 대체할 수 있다. **참조된 필드가 인덱스이면 cross-object notation은 다중 레벨**을 가질 수 있다.

LDV 백서 예시:

```sql
SELECT Id
FROM Score__c
WHERE CrossObject1__r.CrossObject2__r.IndexedField__c
```

### 비결정적 formula 필드 — 인덱스 불가 (전체 목록)

custom index는 **결정적(deterministic) formula 필드**에만 만들 수 있다. 값이 시간에 따라 변하거나 관련 엔티티 트랜잭션으로 변하는 **비결정적 formula는 인덱싱 불가**다. (formula가 인덱스 생성 후 수정되면 인덱스는 rebuild된다.)

비결정적으로 만드는 요소 — 전수:

- **다른 엔티티 참조** (lookup 필드로 접근하는 필드 등)
- **다른 엔티티를 span하는 formula 필드 포함**
- **동적 날짜·시간 함수** (예: `TODAY`, `NOW`)
- **Owner, autonumber, divisions, audit 필드** (단 **CreatedDate·CreatedByID 예외**)
  - Lightning Platform이 인덱싱할 수 없는 필드 참조
  - **multi-select picklist**
  - **multicurrency 조직의 Currency 필드**
  - **long text area 필드**
  - **binary 필드** (blob, file, encrypted text)
- **특수 기능을 가진 standard 필드:**
  - **Opportunity:** Amount, TotalOpportunityQuantity, ExpectedRevenue, IsClosed, IsWon
  - **Case:** ClosedDate, IsClosed
  - **Product:** ProductFamily, IsActive, IsArchived
  - **Solution:** Status
  - **Lead:** Status
  - **Activity:** Subject, TaskStatus, TaskPriority

---

## Skinny Tables

Salesforce는 자주 쓰는 필드를 담아 조인을 피하는 **skinny table**을 만들 수 있어 특정 **읽기 전용(read-only)** 작업 성능을 개선한다. skinny table은 source table이 수정되면 동기화된다.

> **자가 생성 불가:** skinny table을 쓰려면 Customer Support에 문의해야 한다. 활성화되면 적절한 곳에 자동 생성·사용된다. **사용자가 직접 생성·접근·수정할 수 없다.** 최적화하려는 리포트·리스트뷰·쿼리가 바뀌면(예: 새 필드 추가) skinny table 정의 갱신을 Customer Support에 요청해야 한다.

동작 원리: Salesforce는 각 객체 테이블에 대해 standard 필드와 custom 필드를 DB 레벨의 **별도 테이블**로 유지한다(고객에게 비가시). 쿼리가 두 종류 필드를 모두 포함하면 보통 조인이 필요하다. skinny table은 **두 종류 필드를 모두 담고 soft-delete된 레코드를 생략**한다. skinny table 내 필드만 참조하는 read-only 작업은 추가 조인이 필요 없어 성능이 좋다. **수백만 레코드 테이블의 read-only 작업(리포트 등)에 가장 유용**하다.

> [!important] skinny table은 만능이 아니다. 라이브 데이터 사본을 담는 별도 테이블 유지에 오버헤드가 있다. 부적절한 컨텍스트에서 쓰면 성능이 **악화**될 수 있다.

**대상 객체:** custom 객체, 그리고 **Account, Contact, Opportunity, Lead, Case**. 리포트·리스트뷰·SOQL 성능을 개선한다.

**허용 필드 타입 (13종 전수):**

- Checkbox
- Currency
- Date
- Date and time
- Email
- Number
- Percent
- Phone
- Picklist (multi-select)
- Text
- Text area
- Text area (long)
- URL

> skinny table과 skinny index는 **encrypted data**도 담을 수 있다.

활용 예: `01/01/11 ~ 12/31/11` 같은 날짜 범위(연간·YTD 리포트마다 비싼 반복 계산 유발) 대신, skinny table에 Year 필드를 두고 `Year = '2011'` 로 필터.

**Considerations (제약 전수):**

- skinny table은 **최대 200 컬럼**.
- skinny table은 **다른 객체의 필드를 담을 수 없다**.
- **Full sandbox:** skinny table이 Full sandbox 조직으로 복사된다.
- **그 외 sandbox 타입:** 복사되지 **않는다**. Full 외 sandbox 타입에서 production skinny table을 활성화하려면 Customer Support에 문의.

### Skinny Table 구조 다이어그램

> [!note] LDV 백서에는 Skinny Table 구조 다이어그램(Account view + 대응 DB 테이블 + skinny table)이 포함되나 pdftotext로 추출되지 않았다. 본 노트는 텍스트 정의·제약만 수록한다. (백서 원문: "This table shows an Account view, a corresponding database table, and a skinny table that can speed up Account queries.")

---

## Divisions

Divisions는 대규모 배포의 데이터를 분할(partitioning)해 쿼리·리포트가 반환하는 레코드 수를 줄이는 수단이다. 예: 많은 고객 레코드를 가진 배포가 US, EMEA, APAC division을 만들어 상호 연관이 적은 더 작은 그룹으로 고객을 분리.

> **사용 조건 (둘 다 충족):** 조직이 **단일 객체에 100만 레코드 초과** + **35개 초과 라이선스**.

Salesforce는 division별 데이터 분할을 특별 지원하며, Customer Support에 문의해 활성화한다.

---

## SOQL·SOSL 쿼리 작성

SOQL 쿼리는 `SELECT` SQL 문에 해당하고, SOSL 쿼리는 텍스트 기반 검색을 프로그래밍적으로 수행한다.

| | SOQL | SOSL |
|---|---|---|
| 실행 위치 | Database | Search indexes |
| 사용 호출 | `query()` call | `search()` call |

**SOQL 사용 시점:**
- 데이터가 어떤 객체·필드에 있는지 안다.
- 단일/다중(상호 관련) 객체에서 데이터 조회, 조건 충족 레코드 수 카운트, 쿼리 내 정렬, number/date/checkbox 필드 조회.

**SOSL 사용 시점:**
- 데이터가 어떤 객체·필드에 있는지 모르고 가장 효율적으로 찾고 싶다.
- 상호 관련이 있을 수도 없을 수도 있는 다중 객체·필드를 효율적으로 조회, divisions 기능으로 특정 division 데이터를 효율적으로 조회.

고려 사항:
- 두 언어 모두 검색할 텍스트를 지정할 수 있으나, **`CONTAINS` 표현을 쓰면 SOSL이 일반적으로 SOQL보다 빠르다**.
- SOSL은 필드 내 여러 용어(공백 구분 단어)를 토큰화해 검색 인덱스를 만든다. 필드 내 존재하는 특정 distinct 용어를 찾을 때 SOSL이 SOQL보다 빠를 수 있다(예: "Paul and John Company" 값에서 "John" 검색).
- SOQL에서 다중 WHERE 필터 사용 시, WHERE 절 필드가 인덱스 가능해도 인덱스를 못 쓰는 경우가 있다. 이때는 **단일 쿼리를 여러 쿼리로 분해**(각 한 개 WHERE)한 뒤 결과를 결합한다.
- **picklist·foreign key 필드에 null 값을 가진 WHERE 필터로 쿼리를 실행하면 인덱스를 쓰지 못하므로 피해야 한다.**

### 선택 기준 — 효율적 SOQL 작성

- **selective filter 사용** — Query Optimizer가 스캔할 행을 줄인다. 인덱스 필드, 값 범위가 넓은 필드를 참조. 필터가 선택적이지 않으면 옵티마이저는 인덱스 컬럼을 쓰지 않는다.
- FirstName·LastName 필터링 대신 **`Name` 필드** 사용. LDV 백서 예시: `Select id, Email from Lead where Name='Sam Kennedy'`
- **negative filter 회피.** 예: `status !='failed'`, `status != NULL`
- 큰 OR 목록 대신 **`IN` 사용.** 예: `id in ('001xxx','001xxy','001xxz')`
- **cross-object reference formula 필드 회피** — 인덱싱 불가하므로 필터하지 않는다.

### SOSL 작성

- selective filter로 무관한 결과를 줄인다. 필터가 선택적이지 않고 검색 용어 매치가 2,000 레코드 초과면 **search crowding**으로 결과가 영향받는다.
- 검색하지 않을 custom 객체는 인덱싱하지 않는다(search crowding 유발).
- 검색하지 않을 객체는 필터로 제외, 구체적 검색어 사용.
- **targeted search group** 사용 — search group은 NAME, EMAIL, PHONE 필드 포함. 예: `FIND 'Avery Smith' IN NAME FIELDS RETURNING Account(Id,Name), Lead(Id,Name)`

### 큰 SOQL 쿼리 timeout 회피

쿼리 튜닝·범위 축소·selective filter. **Bulk API 2.0 + Bulk API 2.0 Query** 고려. 그래도 timeout이면 **`LIMIT` 절 추가(100,000 레코드부터 시작)**. batch Apex를 쓰면 chaining으로 `LIMIT` 단위 레코드 집합을 가져오거나 필터 로직을 execute 메서드로 옮긴다.

---

## 케이스 스터디 (읽기 경로)

### Data Aggregation

**상황:** 표준 리포트로 월간·연간 메트릭을 집계해야 했음. 월간·연간 상세가 각각 **4백만·9백만 레코드**의 custom 객체에 저장. 두 객체에 걸쳐 수백만 레코드를 집계해 성능 저하.

**해법:** 필요한 리포트 포맷으로 월간·연간 값을 요약하는 **aggregation custom 객체** 생성. 리포트는 집계 객체에서 실행. 요약 객체는 **batch Apex**로 채움.

### Custom Search Functionality

**상황:** 여러 객체에서 특정 값·와일드카드로 대용량 검색 필요. 사용자가 1~20개 필드를 입력해 그 조합으로 SOQL 검색하는 custom Visualforce 페이지. 어려움: 값이 많으면 WHERE 절이 커져 튜닝 곤란(와일드카드 시 더 느림), 다중 객체 쿼리로 검색 연장, SOQL이 모든 쿼리 유형에 적합하지 않음.

**해법:**
- 필수 검색 필드만 사용해 검색 가능 필드 수 축소 — 동시 사용 필드를 흔한 use case로 제한해 인덱스 튜닝 가능.
- 다중 객체 데이터를 단일 custom 객체로 **de-normalize**해 다중 쿼리 회피.
- 검색 필드 수·입력 값 유형에 따라 **SOQL/SOSL을 동적으로 선택**. 매우 구체적인 값(와일드카드 없음)은 SOQL로 쿼리해 인덱스 활용.

### Indexing with Nulls

**상황:** 필드에 null을 허용하면서 null로 쿼리 필요. picklist·foreign key의 단일 컬럼 인덱스는 index 컬럼이 null인 행을 제외하므로 null 쿼리에 인덱스 사용 불가.

**해법:** best practice는 애초에 null을 쓰지 않는 것(예: `N/A` 같은 문자열로 대체). 이미 null 레코드가 있으면, null에 텍스트를 표시하는 **formula 필드를 만들고 그것을 인덱싱**한다.

LDV 백서 예시 — `Status` 가 인덱스이고 null을 포함할 때, 다음은 인덱스 사용을 막는다:

```sql
SELECT Name
FROM Object
WHERE Status__c = ''
```

대신 formula `Status_Value`를 만든다:

```
Status_Value__c = IF(ISBLANK(Status__c), "blank", Status__c)
```

이 formula 필드는 인덱싱 가능하며 null 값 쿼리에 사용:

```sql
SELECT Name
FROM Object
WHERE Status_Value__c = 'blank'
```

다중 필드로 확장 가능:

```sql
SELECT Name
FROM Object
WHERE Status_Value__c = '' OR Email = ''
```

### Sort Optimization on a Query

**상황:** LDV 백서 예시 — 다음 쿼리가 최근 3일 생성 레코드를 찾으나, 객체 데이터가 standard index 임계값(전체의 30%, 최대 100만)을 초과해 성능 저하:

```sql
SELECT Id,Product_Code__c
FROM Customer_Product__c
WHERE CreatedDate = Last_N_Days:3
```

**해법:** LDV 백서 예시 — `ORDER BY` 인덱스 필드 + 100,000 미만 `LIMIT` 으로 재작성:

```sql
SELECT Id,Product_Code__c
FROM Customer_Product__c
WHERE CreatedDate = Last_N_Days:3
ORDER BY CreatedDate LIMIT 99999
```

이 쿼리는 임계값 검사를 하지 않고 **CreatedDate 인덱스**로 레코드를 찾는다. 최근 3일 내 생성 레코드를 최대 99,999건(생성 순서)으로 반환한다(해당 기간 레코드가 99,999 이하라고 가정).

> 일반적으로 `Last_N_Days` 로 추가된 데이터를 쿼리할 때, **인덱스 필드에 `ORDER BY` + 100,000 미만 `LIMIT`** 를 지정하면 ORDER BY 인덱스가 쿼리에 사용된다.

### Multi-Join Report Performance

**상황:** 4개 관련 객체를 사용한 리포트 — Accounts(314,000), Sales Orders(769,000), Sales Details(2.3백만), Account Ownership(1.2백만). 필터가 거의 없어 최적화 필요.

**해법:**
- 쿼리를 더 선택적으로 만들 **추가 필터** 적용, 가능한 한 많은 필터를 인덱싱 가능하게.
- 가능하면 각 객체 데이터량 축소.
- **Recycle Bin을 비워 둠** — 휴지통 데이터는 쿼리 성능에 영향.
- 4개 관련 객체에 **복잡한 sharing rule이 없도록** 보장 — 복잡한 sharing rule은 성능에 눈에 띄는 영향.

---

## 관련 노트

- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — LDV 쓰기 경로(Bulk 로드·삭제·추출)
- [[Data Skew]] — account/ownership skew, 1만 건 임계값 메커니즘, Rendering Related Lists
- [[SOQL 패턴]] — 선택적 쿼리·필터 패턴 일반
- [[SOSL 패턴]] — 텍스트 검색 패턴 일반
- [[Governor Limits]] — 쿼리·행 제한 일반
- [[Salesforce 플랫폼 개요]] — 멀티테넌트·메타데이터 아키텍처
- [[레코드 액세스 설계 (Enterprise Scale)]] — sharing·access 대규모 설계
