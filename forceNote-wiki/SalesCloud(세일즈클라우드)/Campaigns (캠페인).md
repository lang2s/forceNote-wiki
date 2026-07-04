---
tags: [sales-cloud, campaigns, campaign-members, campaign-influence, marketing]
source: help.salesforce.com (Salesforce Help — Sales Basics; Get to Know Salesforce Campaigns + Campaign Influence; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · help.salesforce.com (Enable Customizable Campaign Influence — campaigns_influence_customizable_setup.htm; Understanding Customizable Campaign Influence — campaigns_influence_customizable_understanding.htm; Tier 2, 접속 2026-07-04)
official_doc: https://help.salesforce.com/s/articleView?id=sales.campaigns_def.htm&type=5
created: 2026-07-03
aliases: [Campaigns, 캠페인, Campaign Members, Campaign Hierarchy, Campaign Influence, First-Touch, Last-Touch, Even-Distribution]
---

# Campaigns (캠페인)

> 마케팅과 영업을 잇는 Sales Cloud 오브젝트. 캠페인 유형·에셋·멤버·계층을 구성하고, Campaign Influence로 캠페인이 open opportunity에 준 매출 기여(attribution)를 추적한다.

---

## 개념 — 마케팅과 영업의 다리

Salesforce campaign은 **마케팅과 영업 사이의 간극을 메우는** 오브젝트다. 캠페인으로 할 수 있는 일:

- 캠페인 **유형(type)** 을 정의한다.
- 캠페인 **에셋(asset)** 을 정리한다.
- 캠페인에 **멤버(member)** 를 추가한다.
- 캠페인 **계층(hierarchy)** 을 생성한다.
- 캠페인의 **성과를 추적하고 리포팅**한다.

## Campaign Members (캠페인 멤버)

캠페인에 멤버를 추가하고 각 멤버의 **member status**를 업데이트한다.

**ABM(account-based marketing) 지원:** account 또는 person account를 campaign member로 추가할 수 있다. 리포트, 관련 목록 등 **캠페인 멤버를 추가하는 어디에서든** account를 campaign member로 추가할 수 있다.

## Campaign Hierarchy (캠페인 계층)

캠페인을 **계층 구조**로 조직한다 (상위-하위 캠페인). 이를 통해 관련 캠페인들을 묶어 성과를 롤업해 볼 수 있다.

## Campaign Influence (캠페인 영향도)

Campaign Influence는 member status와 **무관하게 모든 campaign member**를 고려한다. influence 모델은 **active 캠페인을 스캔**해, **open opportunity에서 contact role이 부여된 멤버**를 식별한다.

> Campaign Influence가 참조하는 open opportunity와 contact role은 [[Opportunities (기회)]]를 참조한다.

### Customizable Campaign Influence — 표준 attribution 모델

**Customizable Campaign Influence**는 표준 및 커스텀 attribution 모델로 캠페인의 **revenue share(매출 기여)** 를 식별한다. revenue share는 수동 또는 자동 프로세스로 업데이트할 수 있다.

표준 attribution 모델 3종:

| 모델 | attribution 규칙 |
|---|---|
| **First-Touch** | prospect가 **처음 touch**한 캠페인에 influence·revenue **100%** 할당 |
| **Even-Distribution** | prospect가 touch한 **모든** 캠페인에 **균등(even) %** 할당 |
| **Last-Touch** | deal이 close되기 **직전 마지막 touch** 캠페인에 **100%** 할당 |

> 원조 모델인 **Campaign Influence 1.0** 도 존재한다.

### ⚠️ 전제조건 — 모델이 동작하기 전에 켜야 할 설정

위 attribution 모델은 **기본 상태에서 자동으로 동작하지 않는다.** 다음 셋업이 선행돼야 한다.

- **Customizable Campaign Influence 활성화:** Setup에서 먼저 활성화해야 한다. 활성화 전에는 표준/커스텀 attribution 모델 기능을 사용할 수 없다.
- **자동 매출 기여(auto-association)는 기본 꺼짐:** 캠페인이 opportunity에 자동으로 revenue share를 기여하게 하려면 **Auto-Association Settings**에서 상태를 **Enabled**로 켜야 한다. 켜기 전에는 revenue share를 수동으로만 추가할 수 있다.
- **Opportunity Contact Roles 선행:** influence는 opportunity에 **contact role이 부여된 멤버만** 잡는다. 따라서 Opportunity Contact Roles 설정이 먼저 돼 있어야 하며, contact role이 없는 opportunity에는 campaign influence가 생성되지 않는다.

## 구조 개념도

```
// 구조 예시 — Campaign 구조(실제 원본 다이어그램 아님)
Campaign (유형·에셋·계층)
  ├─ Campaign Members (Lead/Contact/Account[ABM]) + Member Status
  ├─ Campaign Hierarchy (상위-하위 캠페인)
  └─ Campaign Influence → open opportunity의 contact role 멤버 식별
       attribution 모델: First-Touch(100% 첫) · Even-Distribution(균등) · Last-Touch(100% 마지막)
```

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Opportunities (기회)]] — Campaign Influence가 참조하는 open opportunity·contact role
- [[Leads (리드)]] — lead를 campaign member로 연결
