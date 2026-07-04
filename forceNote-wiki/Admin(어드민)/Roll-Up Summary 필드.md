---
tags: [admin, roll-up-summary, custom-field, master-detail, customization]
source: help.salesforce.com (Salesforce Help — Extend Salesforce with Clicks, Not Code; Roll-Up Summary Field; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · help.salesforce.com 000386702 (Increase the Maximum Limit of Roll-Up Summary Fields on an Object, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=platform.fields_about_roll_up_summary_fields.htm&type=5
created: 2026-07-03
aliases: [Roll-Up Summary Field, 롤업 요약 필드, 집계 필드, COUNT SUM MIN MAX, Master-Detail 집계]
---

# Roll-Up Summary 필드

> master-detail 관계의 **master 오브젝트**에 두어, 관련 detail 레코드를 **COUNT·SUM·MIN·MAX**로 집계하는 자동 계산 필드.

---

## 개념

Roll-Up Summary 필드는 **관련(related) 레코드로부터 값을 계산**하는 커스텀 필드다. master 레코드의 관련 목록(related list)에 있는 detail 레코드들을 집계해 하나의 값으로 요약한다.

예: Account에 연결된 관련 invoice 커스텀 오브젝트(`Invoice__c`)의 금액을 합산해 Account 위에 총액을 표시.

필드는 값을 **자동으로 계산·유지**하므로, detail 레코드가 추가·수정·삭제되면 master의 roll-up 값이 갱신된다.

### 필수 조건

- **master-detail 관계의 master 측** 오브젝트에만 정의할 수 있다. (lookup 관계에서는 불가 — detail 측이 master에 종속돼야 집계가 성립)

### Available in

Contact Manager, Group, Professional, Enterprise, Performance, Unlimited, Developer, Database.com Edition. (Salesforce Classic + Lightning Experience 양쪽)

---

## 계산 유형 (4)

| 유형 | 집계 내용 |
|---|---|
| **COUNT** | detail 레코드의 **개수** |
| **SUM** | 지정한 필드 값의 **합계** |
| **MIN** | 지정한 필드 값의 **최솟값** |
| **MAX** | 지정한 필드 값의 **최댓값** |

### 유형별 집계 가능 필드 타입

| 계산 유형 | 사용 가능한 필드 타입 |
|---|---|
| **SUM** | number, currency, percent |
| **MIN / MAX** | number, currency, percent, **date, date/time** |

> COUNT는 레코드 수만 세므로 대상 필드 타입 제약이 없다. SUM은 날짜형을 지원하지 않고, MIN/MAX만 date·date/time을 집계할 수 있다.

---

## 집계 대상으로 쓸 수 없는 필드

다음 필드는 roll-up summary의 **집계 대상 필드나 필터 조건으로 사용할 수 없다**:

- long text area
- multi-select picklist
- Description 필드
- 시스템 필드 (예: Last Activity)
- cross-object formula 필드
- lookup 필드
- **Auto number** 필드 (집계 대상 필드로 사용 불가)

또한 **current date·current user** 같이 자동으로 파생되는 값을 가진 필드는 집계에 사용할 수 없다.

---

## 한도 · 주의

- **오브젝트당 roll-up summary 필드 개수:** 기본 **오브젝트당 최대 25개**. Salesforce 지원(support) 요청으로 **최대 40개**까지만 증설 가능하다.
- 복잡한 데이터 모델에서 자주 부딪히는 하드 한도이며, 40개를 초과해야 하면 **DLRS(Declarative Lookup Rollup Summaries)** 또는 **Flow** 같은 우회책이 필요하다.

> 출처: Salesforce Help — *Increase the Maximum Limit of Roll-Up Summary Fields on an Object* (기본 25, 최대 40). https://help.salesforce.com/s/articleView?id=000386702&type=1

---

## 구조 변경 제약

- roll-up summary 필드를 **만든 뒤에는** 그 오브젝트의 master-detail 관계를 lookup 관계로 **변환할 수 없다**.
- 변환된 lead의 필드 매핑(lead conversion field mapping)에는 roll-up summary 필드를 사용할 수 없다.

---

## 재계산 (Management)

- roll-up summary 값이 변경되면 **mass recalculation**이 유발되고, assignment rule을 트리거할 수 있다.
- 계산은 레코드 수에 따라 **최대 30분** 소요될 수 있다.
- **campaign roll-up**은 관련 lead/contact가 변경돼도 자동으로 재계산되지 않는다 → **"Force a mass recalculation of this field"** 옵션을 사용해 수동 재계산한다.
- invalid 값이 되는 roll-up summary라도 필드 **생성 자체는 차단되지 않는다**.

---

## 통화 (멀티 통화 org)

- 멀티 통화 org에서는 **master 레코드의 통화**가 roll-up 통화를 결정한다.
- conversion rate(환율)가 변경되면 값이 재계산된다.
- **advanced currency management**는 currency roll-up을 invalidate(무효화)한다.
- Metadata API로 삭제할 때 `purgeOnDelete=true`이면 휴지통에 저장되지 않는다.

---

## Best Practices

- 노출을 원치 않는 값이면 **field-level security**를 적용한다.
- **validation rule 영향**을 고려한다 — roll-up summary는 edit 페이지에 나타나지 않으므로 validation rule에 활용할 수 있다.
- child(detail) 레코드에서 roll-up summary를 참조하는 것은 피한다.
- **current date·current user** 같은 자동 파생 필드는 집계에 사용할 수 없다.
- list view·report에서 roll-up summary를 참조하면 일부 연산자를 사용할 수 없다.
- roll-up summary 필드는 생성 전 **신중히 계획**한다 (구조 변경 제약 때문).

---

## 구조 예시

```
// 구조 예시 — Roll-Up Summary 개념(실제 원본 다이어그램 아님)
Master(Account)  ◀── master-detail ──  Detail(Invoice__c)
  Roll-Up Summary 필드:
     COUNT(Invoice__c)          // detail 레코드 수
     SUM(Invoice__c.Amount__c)  // 금액 합계 (number/currency/percent)
     MAX(Invoice__c.DueDate__c) // 최대 날짜 (date/date-time)
  재계산: 최대 30분 · master 통화 기준 · 자동파생필드 불가
```

---

## 관련 노트
- [[Formula 필드]] — 또 다른 자동 계산 커스텀 필드(파생 값). roll-up이 관련 레코드를 집계하는 반면 formula는 같은 레코드 내(또는 cross-object)의 값을 계산.
- [[Object Relationships]] — master-detail/lookup 관계(roll-up summary의 전제 구조).
- [[Multiple Currencies (멀티 통화)]] — 멀티통화 org에서 master 레코드 통화가 roll-up 통화를 결정하고, advanced currency management는 currency roll-up을 무효화한다.
