---
tags: [release, winter_24, clouds, industries]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Industries, 윈터 24 인더스트리, Outcome Management Context Service GA]
---

# Winter '24 — Clouds (Industries)

> 허브: [[Winter '24]] · 형제: [[Winter '24/Clouds]]
> Winter '24(API v59.0) Industries 영역의 **GA/Beta 인벤토리** — Outcome Management(GA), Context Service(GA), 그리고 산업별 클라우드(Automotive·Communications·Consumer Goods·Education·Energy & Utilities·Financial Services·Grantmaking·Health·Loyalty·Manufacturing·Media·Net Zero·Nonprofit·Public Sector·Salesforce Contracts·Trade Promotion Management)의 주요 변경.

---

## 개요

이 노트는 Winter '24 릴리즈 노트의 **Industries 챕터**(physical p.344~477, 약 133페이지)를 다룬다. 분량이 매우 커서 [[Winter '24/Clouds]] 본 노트에서 분리했으며, 작업 지시에 따라 **GA/Beta 인벤토리 수준**으로 정리한다(각 기능의 full prose 깊이는 후속 추출 패스가 필요하다 — physical p.344~477).

**챕터 개요(verbatim):** *"Outcome Management and Context Service are now generally available. Improve engagement with stores and plan better promotions with Consumer Goods Cloud. Financial Services Cloud can now organize both internal and external data better with Data Cloud. Track grant recipients' budgets with Grantmaking. Health Cloud can now bring its CRM data into Marketing Cloud with Marketing Cloud Engagements. Automate and improve warranty claim adjudication processes with Manufacturing Cloud. Plan your company's social impact with materiality assessments in Net Zero Cloud. Manage the end-to-end lifecycle of contracts with Salesforce Contracts. We also have plenty of changes for Education Cloud, Nonprofit Cloud, Media Cloud, Industries common features, and many more."*

> 범례: **GA**=Generally Available · **Beta** · **변경**=Enhancement

---

## Industries Common — GA 핵심

- **Outcome Management (Generally Available)** — **GA.**
- **Context Service (Generally Available)** — **GA.** 새 `ContextDefinition` metadata type(Customization/Metadata 참조). 관련: **Increase Scalability of Your DPE Definitions with a Custom Node (Generally Available)** — GA, 그리고 **New Context Service Metadata Type.**
- **Create Richly Formatted Service Documents with Document Builder (Beta)** — **Beta.**
- **DocumentReader Namespace** (Industries Common) — 신규 Apex 클래스.

---

## 산업별 클라우드 (GA/Beta 인벤토리)

| 클라우드 | 주요 변경 |
|---|---|
| **Automotive Cloud** | 산업 기능 업데이트 |
| **Communications Cloud** | 산업 기능 업데이트 |
| **Consumer Goods Cloud** | store engagement 개선, 더 나은 promotion 계획 |
| **Education Cloud** | 다수 변경 |
| **Energy & Utilities Cloud** | 산업 기능 업데이트 |
| **Financial Services Cloud** | Data Cloud 통합(내부·외부 데이터 정리), retail banking service process, Prebuilt Service Processes |
| **Grantmaking** | grant 수령인 예산 추적, Compliant Data Sharing comment 암호화 |
| **Health Cloud** | Marketing Cloud Engagement for Health Cloud, Behavioral Health App, Provider Relationship Management 데이터 모델, 신규/변경 object·Health Cloud metadata type·invocable action(`scheduleHomeVisit`, `scheduleRecurringHomeVisit`, `handleResourceAbsence`, `processReceivedDocument`) |
| **Loyalty Management** | 산업 기능 업데이트 |
| **Manufacturing Cloud** | warranty claim adjudication 자동화·개선 |
| **Media Cloud** | 산업 기능 업데이트 |
| **Net Zero Cloud** | materiality assessment로 사회적 영향 계획 |
| **Nonprofit Cloud** | 다수 변경 |
| **Public Sector Solutions** | `PublicSectrSltn` Namespace 신규 Apex 클래스 |
| **Salesforce Contracts** | 계약의 end-to-end lifecycle 관리, Document Builder(Beta) |
| **Trade Promotion Management** | 산업 기능 업데이트 |

> Industries 챕터는 매우 방대하다. 각 산업 클라우드의 세부 prose가 필요하면 physical p.344~477을 후속 추출 패스로 처리한다. 본 노트는 작업 지시에 따라 GA/Beta 인벤토리 수준만 담는다.

---

## 신규 Apex Namespace (Industries 관련)

직접 동작 코드는 PDF에서 발췌하지 않았으므로, 카탈로그 수준에서 이름만 기록한다.

```text
// 구조 예시 — 실제 PDF 다이어그램 아님
// Industries 관련 신규 Apex namespace/클래스 카탈로그 (이름만)
DocumentReader Namespace      — Industries Common, 신규 Apex 클래스
PublicSectrSltn Namespace     — Public Sector Solutions, 신규 Apex 클래스
Health Cloud invocable action — scheduleHomeVisit / scheduleRecurringHomeVisit /
                                handleResourceAbsence / processReceivedDocument
```

> 위 카탈로그는 이름·소속만 정리한 구조 예시다. 각 클래스의 메서드·시그니처는 본 PDF에서 전수 추출되지 않았으며, 필요 시 physical p.344~477 후속 추출이 필요하다.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Clouds]] — 형제 노트(Sales·Service·Data Cloud·Experience·Commerce·Analytics·Revenue 등)
- [[Winter '24/Platform]] — Shield Platform Encryption for Health Cloud 등 플랫폼 보안
- [[Winter '24/Einstein]] — Health Cloud 등 산업별 AI 맥락
- [[Release MOC]]
