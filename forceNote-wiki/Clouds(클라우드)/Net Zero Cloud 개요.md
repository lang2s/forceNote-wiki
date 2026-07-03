---
tags: [net-zero-cloud, agentforce-net-zero, sustainability, carbon-accounting, esg, overview]
source: help.salesforce.com (Salesforce Help — Net Zero Cloud (Agentforce Net Zero); 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=ind.netzero_manager_intro.htm&type=5
created: 2026-07-03
aliases: [Net Zero Cloud, Agentforce Net Zero, 넷제로 클라우드, 탄소 회계, Sustainability, ESG, Carbon Footprint]
---

# Net Zero Cloud 개요

> 기업의 탄소 발자국을 보고·감축해 net zero를 달성하도록 돕는 지속가능성 제품. scope 1·2·3 전체 value chain을 글로벌 감축 궤적에 맞춘다. **현재 명칭은 Agentforce Net Zero.**

---

> [!note] 브랜딩 변경
> 공식 문서 기준 **"Net Zero Cloud is now Agentforce Net Zero."** — 제품명이 **Agentforce Net Zero**로 변경되었다. 이 노트는 두 명칭을 함께 다룬다.

## 개념

**Net Zero Cloud**(현 **Agentforce Net Zero**)는 기업이 **net zero를 달성**하도록 돕는 지속가능성(sustainability) 제품이다. 단순 측정에 그치지 않고 **배출 감축(emission reduction) 우선순위화**를 지원하며, 기업의 **전체 value chain(scope 1·2·3)**을 글로벌 감축 궤적에 정렬한다.

정렬 대상 궤적(target trajectory):

- **2030년까지 배출 ~50% 감축**
- **2040년까지 near-zero**

## 주요 기능 (개요)

- **탄소 발자국(carbon footprint) 보고** — value chain 전반의 배출을 보고한다.
- **탄소 발자국 감축** — 측정된 배출을 감축한다.
- **배출 감축 우선순위화** — 어떤 배출부터 줄일지 우선순위를 정한다.

배출 범위(scope)는 다음 세 갈래를 모두 포함한다.

- **Scope 1** — 직접 배출.
- **Scope 2** — 구매한 에너지 관련 배출.
- **Scope 3** — 간접 배출(value chain 상·하류).

> 배출 계산 로직·데이터 모델 등 기술 세부는 이 개요의 범위 밖이다 → 공식 문서에 위임한다.

## 분석

**Net Zero Cloud Analytics** 대시보드는 **CRM Analytics for Net Zero Cloud add-on 라이선스**가 있는 사용자에게만 제공된다.

## 구성

```
// 구조 예시 — Net Zero Cloud / Agentforce Net Zero(실제 원본 다이어그램 아님)
Value Chain 배출: Scope 1(직접) · Scope 2(에너지) · Scope 3(간접)
  → 보고(carbon footprint) → 감축 우선순위화
  목표: 2030 ~50% 감축 · 2040 near-zero
분석: Net Zero Cloud Analytics(= CRM Analytics for Net Zero add-on)
```

## 관련 노트

- [[Salesforce 제품 클라우드 개요]] — 전체 클라우드 지도 허브.
- [[CRM Analytics 개요]] — Net Zero Cloud Analytics의 기반.
