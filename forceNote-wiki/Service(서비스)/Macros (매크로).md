---
tags: [service-cloud, macros, agent-productivity, automation]
source: help.salesforce.com (Salesforce Help — Service; Create Macros in Lightning Experience; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.macros_create_lightning.htm&type=5
created: 2026-07-03
aliases: [Macros, 매크로, Macro Builder, Agent Productivity]
---

# Macros (매크로)

> 서비스 담당자가 반복 수행하는 작업(이메일 템플릿 선택·전송·case 필드 업데이트 등)을 한 번에 실행하는 자동화. utility bar의 Macros에서 접근하며 point-and-click **Macro Builder**로 만든다.

---

## 개념

**Macro**는 에이전트(서비스 담당자)가 반복해서 수행하는 작업들을 자동화한다. 여러 단계를 하나로 묶어 **한 번에 실행**하므로, 매번 같은 절차를 손으로 반복하지 않아도 된다.

대표적인 반복 작업 예:

- 이메일 템플릿 선택
- 선택한 템플릿 전송
- case 필드(예: status) 업데이트

이런 단계들을 macro 하나에 정의해 두면, 담당자는 클릭 한 번으로 전체 흐름을 실행할 수 있다.

## 접근 — Utility Bar

macro는 **utility bar**에서 **Macros**를 클릭해 접근한다. 담당자는 콘솔 하단의 utility bar에 노출된 Macros 유틸리티를 열어 실행할 macro를 고른다.

## 생성 — Macro Builder

Lightning Experience에서는 **Macro Builder**로 macro를 만든다. Macro Builder는 쉬운 **point-and-click** 빌더로, 코드 없이 클릭만으로 macro의 단계를 구성한다.

```
// 구조 예시 — Macro(실제 원본 다이어그램 아님)
Utility Bar → Macros → 실행
Macro Builder(point-and-click): 여러 단계 정의(예: 이메일 템플릿 선택 → 전송 → case status 업데이트)
반복 작업을 한 번에 자동화
```

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Service Console (서비스 콘솔)]] — macro를 실행하는 워크스페이스
