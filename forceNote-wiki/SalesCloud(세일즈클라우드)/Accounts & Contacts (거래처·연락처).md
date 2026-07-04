---
tags: [sales-cloud, accounts, contacts, person-accounts, relationships]
source: help.salesforce.com (Salesforce Help — Sales Basics; Manage Accounts and Contacts + Contacts to Multiple Accounts + Person Accounts; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · help.salesforce.com — Enable Person Accounts (sales.account_person_enable.htm) + Cannot disable Person Accounts (000387315), Tier 2
official_doc: https://help.salesforce.com/s/articleView?id=sales.sales_core_manage_accounts_contacts.htm&type=5
created: 2026-07-03
aliases: [Accounts, Contacts, 거래처, 연락처, Business Account, Person Account, Contacts to Multiple Accounts, Primary Account, 거래처 계층]
---

# Accounts & Contacts (거래처·연락처)

> **Account**는 거래하는 회사/개인 정보를, **Contact**는 거래 상대 사람 정보를 저장하는 Sales Cloud 핵심 오브젝트. business/person account 두 유형과 Contacts to Multiple Accounts로 사람-회사 관계를 중복 없이 추적한다.

---

## Accounts (거래처)

**Account**는 비즈니스를 하는 대상 — 고객·개인 — 의 정보를 저장하는 오브젝트다. Account에는 두 가지 유형이 있다.

| 유형 | 저장 대상 |
|---|---|
| **Business Account** | 회사(company) 정보를 저장 |
| **Person Account** | 개별 사람(individual person) 정보를 저장 |

Business account는 회사 단위로 거래하는 B2B 시나리오에, person account는 개인 소비자를 직접 고객으로 다루는 B2C 시나리오에 쓰인다.

### ⚠️ 전제조건 — Person Accounts 활성화 (비가역)

Person account는 조직에 **기본 제공되지 않는다.** 사용하려면 먼저 Salesforce가 기능을 **명시적으로 활성화(enable)** 해야 하며, 활성화 전에 아래 전제조건을 충족해야 한다.

- **계정 record type이 1개 이상** 존재해야 한다 (Person account를 위한 record type 구성이 필요).

> [!warning] 한 번 활성화하면 되돌릴 수 없다 — 영구적
> Person Accounts는 **한 번 활성화하면 비활성화(disable)할 수 없다.** 이 변경은 영구적이므로, 프로덕션 조직에서 활성화하기 전 반드시 데이터 모델·보안·통합 영향을 검토하고 sandbox에서 먼저 테스트한다. (근거: Salesforce Help — Enable Person Accounts / Cannot disable Person Accounts)

## Contacts (연락처)

**Contact**는 비즈니스를 함께 하는 **사람**의 정보를 저장한다. Contact는 보통 하나의 account에 연결되지만, opportunity 등 다른 레코드에도 연결될 수 있다.

> Contact가 opportunity에 연결되는 방식(contact role)은 [[Opportunities (기회)]] 참조.

## Contacts to Multiple Accounts (여러 거래처에 연결된 연락처)

한 사람이 여러 회사와 관계를 맺는 경우가 있다. **Contacts to Multiple Accounts** 기능은 단일 contact를 **여러 account에 연결**해, 중복 레코드를 만들지 않고 사람-회사 관계를 추적하게 한다.

이때 관계는 두 종류로 나뉜다.

- **Primary account (직접, direct 관계):** 각 contact는 여전히 **primary account**가 필요하다. 이는 contact의 **Account Name** 필드로 지정되며, contact와 primary account 사이는 **직접(direct)** 관계다.
- **Secondary account (간접, indirect 관계):** primary account 외에 추가로 연결한 account와 contact 사이의 관계는 **간접(indirect)** 관계다.

이 구조 덕분에 예를 들어 한 컨설턴트가 A사(고용주, primary)에 소속되면서 B사·C사(고객사, secondary)와도 관계를 맺는 상황을 하나의 contact 레코드로 표현할 수 있다.

## Person Accounts + Contacts to Multiple Accounts

Person account와 Contacts to Multiple Accounts는 **함께 동작한다.** Person account는 다음이 될 수 있다.

- business account의 **related contact**
- 다른 contact의 **related account**

단, person account를 연결할 때 그 관계는 **항상 간접(indirect)** 이다. Person account는 **primary account가 없기 때문에** business account에 직접(direct) 관계로 연결될 수 없다.

## 관계 구조도

아래는 지금까지의 관계를 한눈에 정리한 그림이다.

```
// 구조 예시 — Accounts & Contacts 관계(실제 원본 다이어그램 아님)
Account
  ├─ Business Account (회사)
  └─ Person Account (개인 — primary account 없음)
Contact ── primary account(Account Name, 직접) ──▶ Business Account
        └─ 추가 account(secondary, 간접) ──▶ 다른 Account   [Contacts to Multiple Accounts]
Person Account ↔ Account/Contact 연결은 항상 indirect
```

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Opportunities (기회)]] — contact가 opportunity의 contact role로 연결
- [[Territory Management (영역 관리)]] — account가 배정되는 영업 territory
- [[Leads (리드)]] — lead 전환 시 생성되는 산출물(신규 account면 contact도 함께 생성)
