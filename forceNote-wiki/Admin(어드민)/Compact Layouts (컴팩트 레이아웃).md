---
tags: [admin, ui-customization, compact-layouts, highlights-panel, mobile]
source: help.salesforce.com (Salesforce Help — Compact Layouts; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.compact_layout_overview.htm&type=5
created: 2026-07-03
aliases: [Compact Layouts, 컴팩트 레이아웃, Highlights Panel, 하이라이트 패널, Key Fields]
---

# Compact Layouts (컴팩트 레이아웃)

> 레코드의 핵심 필드를 **하이라이트 패널(레코드 페이지 헤더)**과 모바일 레코드 뷰에 표시하는 레이아웃. 사용자가 레코드를 한눈에 식별하게 한다.

---

## 개념

**Compact layout(컴팩트 레이아웃)**은 레코드의 **핵심 필드(key fields)**를 다음 세 위치에 압축해 노출하는 레이아웃이다.

- **하이라이트 패널(Highlights Panel)** — Lightning Experience 레코드 페이지 **상단 헤더** 영역. 레코드를 열었을 때 가장 먼저 보이는 요약 영역이다.
- **Salesforce 모바일 앱 레코드 뷰** — 모바일에서 레코드를 열면 상단에 핵심 필드가 먼저 표시된다.
- **expanded lookup 카드의 첫 필드** — 다른 레코드에서 lookup을 확장(hover/미리보기)할 때 카드에 노출되는 필드로도 쓰인다.

전체 필드 배치(상세 영역)를 다루는 것은 compact layout이 아니라 page layout의 역할이다. compact layout은 "이 레코드가 무엇인지 한눈에 식별"하게 하는 **요약 필드 집합**만 정의한다.

> 전체 레코드 필드 배치(하이라이트 vs 상세)의 차이는 [[Page Layouts (페이지 레이아웃)]] 참조.

---

## 설정

`Object Manager → (대상 오브젝트) → Compact Layouts → New` 에서 표시할 핵심 필드를 선택하고 순서를 지정한다. 생성한 여러 compact layout 중 하나를 **primary compact layout(기본 컴팩트 레이아웃)**으로 배정하면 그 오브젝트의 기본으로 사용된다.

```
// 구조 예시 — Compact Layout(실제 동작 코드 아님)
Object Manager → Compact Layouts → New(핵심 필드 선택·순서)
   표시 위치: 하이라이트 패널(레코드 헤더) · 모바일 레코드 뷰 · lookup 카드
   Primary Compact Layout = 오브젝트 기본
```

> record type별 compact layout 배정 등 세부 절차는 [공식 문서](https://help.salesforce.com/s/articleView?id=sf.compact_layout_overview.htm&type=5)에 위임한다.

---

## 관련 노트
- [[Page Layouts (페이지 레이아웃)]] — 전체 레코드 필드 배치(하이라이트 vs 상세)
- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] — 레코드 페이지 헤더에 하이라이트 표시
