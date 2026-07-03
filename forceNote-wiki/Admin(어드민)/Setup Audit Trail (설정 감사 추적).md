---
tags: [admin, org-setup, setup-audit-trail, monitoring, compliance]
source: help.salesforce.com (Salesforce Help — Monitor Setup Changes with Setup Audit Trail; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.admin_monitorsetup.htm&type=5
created: 2026-07-03
aliases: [Setup Audit Trail, 설정 감사 추적, 감사 추적, Audit Trail, Setup Changes]
---

# Setup Audit Trail (설정 감사 추적)

> 조직의 Setup 변경 이력을 **누가·무엇을·언제** 바꿨는지 추적하는 감사 로그. 여러 관리자가 있는 조직에서 구성 변경을 진단·감사한다.

---

## 개념

**Setup Audit Trail**은 조직의 **Setup 변경(configuration changes)**을 추적하는 감사 로그다. 각 변경에 대해 다음을 기록한다.

- **누가(Who)** — 변경을 수행한 사용자
- **무엇을(What)** — 변경된 내용
- **언제(When)** — 변경 일시

여러 관리자가 있는 조직에서 특히 유용하다. 누가 어떤 구성을 바꿨는지 진단할 수 있고, 규정 준수(compliance)·감사 목적으로 활용한다. 예를 들어 **멀티 통화 활성화** 같은 조직 수준의 구성 변경도 여기에 기록된다.

## 접근 방법

Setup에서 감사 추적을 조회한다. 최근 변경 내역은 UI에서 바로 볼 수 있고, 전체 이력은 파일로 **다운로드(CSV/Excel)** 할 수 있다.

```
// 구조 예시 — Setup Audit Trail(실제 동작 코드 아님)
Setup → Quick Find "View Setup Audit Trail" → View Setup Audit Trail
   기록: 변경한 사용자 · 변경 내용 · 일시(누가·무엇을·언제)
   최근 내역 UI 조회 + 전체 이력 다운로드(CSV/Excel)
   용도: 다중 관리자 진단 · 규정 준수 · 감사
```

> 보존 기간·UI 표시 건수 등 세부 사항은 공식 문서([Monitor Setup Changes with Setup Audit Trail](https://help.salesforce.com/s/articleView?id=sf.admin_monitorsetup.htm&type=5))를 참조한다.

## 활용 시나리오

- **다중 관리자 진단** — 예기치 않은 구성 변경의 원인 사용자·시점을 추적
- **규정 준수/감사** — 조직 설정 변경 이력을 감사 근거로 확보
- **되돌릴 수 없는 변경 추적** — 멀티 통화 활성화 등 조직 수준 변경도 기록됨

## 관련 노트
- [[Multiple Currencies (멀티 통화)]] — 멀티통화 활성화 등 되돌릴 수 없는 변경이 기록됨
- [[Field History Tracking (필드 이력 추적)]] — 레코드 **필드 데이터 변경** 추적. Setup Audit Trail의 **설정(Setup) 변경** 추적과 대비
