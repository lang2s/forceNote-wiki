---
tags: [service-cloud, service-console, agent-workspace, lightning-console]
source: help.salesforce.com (Salesforce Help — Service; Lightning Service Console; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.console_lex_service_intro.htm&type=5
created: 2026-07-03
aliases: [Service Console, 서비스 콘솔, Lightning Service Console, Agent Workspace, Utility Bar]
---

# Service Console (서비스 콘솔)

> 서비스 담당자(agent)가 case·고객을 한 화면에서 처리하는 Lightning 워크스페이스 앱. utility bar에 Macros·Omni-Channel·Open CTI Softphone 등 도구를 붙여 생산성을 높인다.

---

## 정의

**Lightning Service Console**은 서비스 rep(담당자)를 위한 **에이전트 워크스페이스 앱**이다. 여러 레코드·case를 효율적으로 처리하도록 설계된 **콘솔형 네비게이션**을 제공해, 담당자가 화면을 옮겨 다니지 않고 한 워크스페이스에서 고객 응대를 이어갈 수 있게 한다.

## Utility Bar

콘솔의 **utility bar**를 커스터마이즈하면 담당자가 상시 접근하는 생산성 도구를 붙일 수 있다. 대표 도구:

- **Macros** — 반복 작업(필드 갱신·이메일 발송 등)을 한 번에 실행. 세부는 [[Macros (매크로)]] 참조.
- **Omni-Channel** — 담당자에게 작업(case·chat 등)을 실시간 라우팅.
- **Open CTI Softphone** — 브라우저 내 전화 통합. 세부는 [[Open CTI & Telephony (전화 통합)]] 참조.

> 탭·split view·하이라이트 패널 등 콘솔 세부 구성과 utility bar 전체 컴포넌트 목록은 공식 문서에 위임한다 — 이 노트는 개요 수준이다.

## 콘솔 구성 (구조 개요)

```
// 구조 예시 — Lightning Service Console(실제 원본 다이어그램 아님)
[콘솔 앱] 워크스페이스 탭(여러 case/레코드 동시)
   Utility Bar: Macros · Omni-Channel · Open CTI Softphone
   + Knowledge · Milestone Tracker 등
```

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Macros (매크로)]] — utility bar 도구
- [[Open CTI & Telephony (전화 통합)]] — utility bar softphone
