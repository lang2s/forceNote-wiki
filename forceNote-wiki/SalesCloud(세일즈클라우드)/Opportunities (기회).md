---
tags: [sales-cloud, opportunities, sales-process, opportunity-products, pipeline]
source: help.salesforce.com (Salesforce Help — Sales Basics; Opportunities; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.opportunities.htm&type=5
created: 2026-07-03
aliases: [Opportunities, 기회, 영업기회, Opportunity Products, Sales Stage, 영업 단계, Competitors]
---

# Opportunities (기회)

> 진행 중이거나 잠재적인 거래(deal)를 추적·관리하는 Sales Cloud 핵심 오브젝트. 영업 단계(stage)로 파이프라인을 이동시키고 opportunity product로 무엇을 얼마에 파는지 관리한다.

---

## 개념 — Opportunity란

**Opportunity**는 진행 중이거나 잠재적인 **거래(deal)를 추적·관리**하는 레코드다. 각 opportunity는 하나의 잠재 매출 건을 나타내며, 영업 단계(stage)를 따라 파이프라인을 이동한다.

### Available in

| 항목 | 내용 |
|---|---|
| 인터페이스 | Lightning Experience + Salesforce Classic |
| Summer '09 **이전** 생성 org | all editions |
| Summer '09 **이후** 생성 org | Essentials, Group, Professional, Enterprise, Performance, Unlimited, Developer |

> 모든 Lightning Experience 기능이 mobile 앱에 존재하는 것은 아니다(인터페이스 간 차이 존재).

---

## Sales cycle 동안 opportunity 레코드에 캡처하는 것

거래가 sales cycle을 진행하는 동안, opportunity 레코드에는 다음을 기록해 대화·활동 가시성을 확보한다.

- **Product 추가 및 파일 첨부** — contract, data sheet 등 관련 파일을 첨부.
- **Call 로그 기록** — 건 통화를 기록해 대화 가시성 확보.
- **Notes** — 고객 미팅 중 메모 작성.
- **Task / Calendar event** — key 활동에는 task, 고객 미팅에는 calendar event 생성.
- **Email** — opportunity contact 및 핵심 의사결정자에게 email 전송.

협상 중에는 동료와 영업 전략을 공유하거나, 매니저에게 targeted 가이드를 요청할 수 있다.

---

## 관리·설정 (하위 기능)

opportunity와 관련해 설정·수행할 수 있는 작업은 다음과 같다.

- **커스터마이즈** — reps가 빠르게 거래를 close하도록 opportunity와 판매 product 옵션을 커스터마이즈.
- **레코드 관리** — opportunity 생성·공유·복제(clone)·영업 프로세스 이동.
- **Product 추가** — opportunity에 product를 추가하면 opportunity product는 **관련 목록(related list)** 으로 표시된다.
- **경쟁사(Competitors) 추적** — pending sale의 경쟁사를 추적(경쟁사명 나열).
- **필드 세부** — opportunity fields 및 opportunity product fields의 세부 정의는 공식 문서에 위임(아래 `official_doc` 링크 참조).

---

## 파이프라인 구조

```
// 구조 예시 — Opportunity 파이프라인(실제 원본 다이어그램 아님)
Opportunity (deal)
  ├─ Stage(영업 단계) 이동 → 파이프라인 진행
  ├─ Opportunity Products(관련 목록): 무엇을 · 얼마에 (Price Book 기반)
  ├─ Competitors · Contact Roles · 파일/Notes/Task/Event/Email
  └─ 커스터마이즈: 세일즈 프로세스·단계·big deal alert
생성·공유·복제(clone)·프로세스 이동 가능
```

---

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브.
- [[Products & Price Books (제품·가격표)]] — opportunity product의 가격 소스.
- [[Accounts & Contacts (거래처·연락처)]] — contact가 opportunity의 contact role로 연결.
- [[Quotes (견적)]] — opportunity에서 생성·양방향 sync되는 제안 가격.
- [[Activities — Tasks & Events (활동)]] — opportunity에 task·calendar event 연결.
- [[Leads (리드)]] — lead 전환 시 생성되는 산출물.
- [[Campaigns (캠페인)]] — campaign influence로 opportunity에 연결되는 마케팅 소스.
- [[Collaborative Forecasts (예측)]] — opportunity amount·forecast category가 예측 집계의 소스.
