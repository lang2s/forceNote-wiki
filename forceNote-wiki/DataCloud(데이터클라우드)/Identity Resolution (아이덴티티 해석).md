---
tags: [data-cloud, data-360, identity-resolution, unified-profile, match-rules]
source: help.salesforce.com (Salesforce Help — Identity Resolution; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · Salesforce Help — Data 360 Limits and Guidelines (c360_a_limits_and_guidelines.htm, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_identity_resolution.htm&type=5
created: 2026-07-03
aliases: [Identity Resolution, 아이덴티티 해석, 신원 해석, Unified Profile, 통합 프로파일, Match Rules, Ruleset]
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

> match rule·reconciliation rule의 세부 설정(연산자·우선순위 등)은 개요 범위 밖 — [공식 문서](https://help.salesforce.com/s/articleView?id=sf.c360_a_identity_resolution.htm&type=5)에 위임.

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
