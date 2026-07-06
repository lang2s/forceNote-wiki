---
tags: [data-cloud, data-360, identity-resolution, unified-profile, match-rules]
source: help.salesforce.com (Salesforce Help — Identity Resolution; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · Salesforce Help — Identity Resolution Match Rules · Reconciliation Rules (c360_a_identity_resolution 하위 문서, Tier 2) · Salesforce Help — Data 360 Limits and Guidelines (c360_a_limits_and_guidelines.htm, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_identity_resolution.htm&type=5
created: 2026-07-03
aliases: [Identity Resolution, 아이덴티티 해석, 신원 해석, Unified Profile, 통합 프로파일, Match Rules, Reconciliation Rules, 조정 규칙, Ruleset]
---

# Identity Resolution (아이덴티티 해석)

> 여러 소스에 흩어진 프로파일을 **매칭·통합해 unified profile(단일 고객 뷰)**로 만드는 Data Cloud 기능. identity resolution ruleset의 match rule·reconciliation rule로 동일 개인을 식별한다.

---

## 개념

**Identity resolution ruleset**은 여러 data source의 프로파일을 **매칭·통합(unify)**해 **unified profile**(통합 개인 프로파일, 단일 고객 뷰)을 만든다. 같은 사람이 여러 소스(웹, 이메일, POS 등)에 서로 다른 레코드로 존재할 때, 이를 하나의 개인으로 묶어 일관된 고객 뷰를 제공한다.

ruleset은 두 종류의 규칙으로 구성된다:

| 규칙 | 역할 |
|---|---|
| **Match rule** | 동일 개인을 식별하는 조건(어떤 프로파일들이 같은 사람인가) |
| **Reconciliation rule** | 매칭된 프로파일 중 어떤 값을 unified profile에 살릴지 결정 |

---

## Match Rule — 매치 방식 (Exact vs Fuzzy)

match rule은 **match criteria**(비교할 필드 + 매치 방식)의 조합이다. 매치 방식은 두 가지:

| 매치 방식 | 동작 | 적용 필드 |
|---|---|---|
| **Exact** | **정규화(normalization) 후 값이 완전히 일치**해야 매치 | Last Name·Email·Phone·Address 등 대부분의 필드 |
| **Fuzzy** | 철자 변형·오타·애칭(nickname)류 **유사 값까지 매치**. 정밀도(precision)를 선택해 허용 범위 조절 | **First Name** (이름 필드) |

- **정규화(normalization):** 비교 전에 값이 표준 형태로 정규화된다 — **Email**(대소문자·공백 정리), **Phone**(국가코드·구분자 형식 통일), **Address**(주소 표준화). 즉 "Exact"도 원문 문자열 그대로가 아니라 **정규화된 값 기준**의 일치다.
- **대표 조합(파티 매칭 기본형):** 이름은 fuzzy로, contact point는 정규화 exact로 짝을 이룬다.

```
// 구조 예시 — match rule 대표 조합(실제 설정 화면 아님)
Fuzzy Name + Normalized Email      (이름 유사 + 이메일 정규화 일치)
Fuzzy Name + Normalized Phone      (이름 유사 + 전화 정규화 일치)
Fuzzy Name + Normalized Address    (이름 유사 + 주소 정규화 일치)
```

> 한 rule 안의 criteria는 **AND**(모두 충족해야 매치), rule 여러 개는 **OR**(하나라도 충족하면 같은 개인)로 동작한다.

---

## Reconciliation Rule — 기본값(default value) 선택 기준 3종

매칭된 프로파일들이 같은 필드에 **서로 다른 값**을 가질 때, unified profile에 살릴 값을 고르는 기준:

| 기준 | 선택 방식 |
|---|---|
| **Last Updated** | 가장 **최근에 업데이트**된 소스 레코드의 값 |
| **Most Frequent** | 매칭된 프로파일들에서 **가장 자주 등장**하는 값 |
| **Source Sequence** | **data source 우선순위(sequence)를 직접 지정**해 두고, 값이 있는 **최상위 소스**의 값 |

ruleset 수준의 기본 기준을 정한 뒤, 필요한 필드에는 **필드 단위로 다른 기준을 override**할 수 있다 (예: 전체는 Last Updated, 주소 필드만 Source Sequence).

---

## 입력

ruleset은 **DMO**(Data Model Object)를 입력으로 실행한다. 필요 시 **batch data transform**의 결과인 **DLO**(Data Lake Object)도 입력으로 쓸 수 있다.

> DLO·DMO의 정의와 매핑은 [[Data Lake Objects & Data Model Objects (DLO·DMO)]] 참조.

---

## 통합 흐름

```
// 구조 예시 — Identity Resolution(실제 원본 다이어그램 아님)
DMO(여러 소스 프로파일) ──▶ Identity Resolution Ruleset
   match rule(동일 개인 식별) + reconciliation rule(값 선택)
   → Unified Profile(단일 고객 뷰)
품질: Consolidation Rate · Outlier · Contributing Contact Points (Calculated Insights)
```

---

## 품질 점검 (Calculated Insights 연계)

identity resolution 결과의 품질은 **calculated insight**로 진단한다. 대표 지표:

| 지표 | 시점 | 용도 |
|---|---|---|
| **Consolidation Rates for Unified Profiles** | unified profile 생성 후 | 각 data source의 매칭된 프로파일 **통합률** 점검 |
| **Outlier Unified Profiles** | unified profile 생성 후 | unified profile당 매칭된 **contact point 수**가 지나치게 많으면 데이터 품질/소스 문제 신호 |
| **Contributing Contact Points** | 수집 후·ruleset 생성 **전** | Contact Point Address/Email/Phone·Party Identification의 **반복 값** 점검(데이터 품질) |

> calculated insight의 정의·작성 방법은 [[Calculated Insights (계산된 인사이트)]] 참조.

---

## 한도·주의

> [!warning] Ruleset 개수 하드 한도 — 최대 2개
> 한 Data Cloud org에서 **데이터 모델·data space당 identity resolution ruleset은 최대 2개까지만** 생성할 수 있다. ruleset을 자유롭게 여러 개 만들 수 있는 것처럼 보이지만 실제로는 이 하드 한도에 자주 막힌다.
>
> - **3번째 ruleset을 만들려면** 기존 ruleset 하나를 **먼저 삭제**해야 한다.
> - 삭제 시 해당 ruleset의 **종속 오브젝트(dependent objects)까지 함께 삭제**해야 한다.

---

## 관련 노트
- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Data Lake Objects & Data Model Objects (DLO·DMO)]] — ruleset 입력 DMO
- [[Calculated Insights (계산된 인사이트)]] — 결과 품질 진단
