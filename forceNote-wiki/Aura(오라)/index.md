---
tags: [index, aura, lightning-components]
created: 2026-05-19
---

# Aura(오라) — 로컬 인덱스

> Lightning Aura Components 개발 가이드 — 컴포넌트 구조, 이벤트, LWC 마이그레이션

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Aura 컴포넌트 구조]] | Bundle 파일 구성, Markup, Attribute, Controller/Helper | #structure |
| [[Aura 이벤트]] | Component Event vs Application Event, fire/handle 패턴 | #event |
| [[Aura vs LWC]] | 기능 비교표, 신규 개발 방향, 마이그레이션 가이드 | #decision |
| [[Aura → LWC 마이그레이션]] | 번들 파일 매핑(cmp→html, controller/helper/renderer→js), aura:attribute→@api, 상호운용, 마이그레이션 치트시트 | #migration |
| [[ui 네임스페이스 Deprecated — lightning 대체 매핑]] | `ui:*` 39종 deprecated(Winter '20 발표·2021-05-01 지원 종료) — 각 컴포넌트의 `lightning:*`(Aura)·`lightning-*`(LWC) 등가 대체 전수 매핑 | #migration |
| [[Quick Action·Publisher JS API 레퍼런스]] | lightning:quickActionAPI · Sfdc.canvas.publisher — 퀵액션/케이스피드 JS API | #api |
| [[Case Feed Visualforce 커스터마이즈]] | apex:emailPublisher·support:caseArticles 등 케이스피드 VF 컴포넌트로 커스터마이즈 | #visualforce |
| [[Experience Builder Aura 사이트 개발]] | forceCommunity 인터페이스 4종·테마 레이아웃·Aura expression·검색/프로필 메뉴 스왑·PII 가시성 | #experiencecloud |
| [[Experience Builder 사이트 — Pardot·CMS·Deflection]] | Pardot 추적(head markup+Relaxed CSP)·Salesforce CMS/CMS Connect·lightningcommunity:deflectionSignal 케이스 deflection | #experiencecloud |
| [[Aura 데이터 연동 — 서버 Apex 액션 · Lightning Data Service]] | `@AuraEnabled` 서버 액션(action state·setStorable 캐시·setBackground·Continuation)·`force:recordData` Lightning Data Service 선언적 CRUD | #server-action #lds #reference |

---

## 빠른 선택

- Aura 컴포넌트 처음 만들기? → [[Aura 컴포넌트 구조]]
- 컴포넌트 간 데이터 전달? → [[Aura 이벤트]]
- Aura vs LWC 무엇을 쓸지? → [[Aura vs LWC]]
- Aura 컴포넌트를 LWC로 전환하려면? → [[Aura → LWC 마이그레이션]]
- `ui:*` 컴포넌트를 무엇으로 바꿔야 하나(deprecated)? → [[ui 네임스페이스 Deprecated — lightning 대체 매핑]]
- 퀵액션/Publisher를 JS로 제어? → [[Quick Action·Publisher JS API 레퍼런스]]
- 케이스피드를 Visualforce로 커스터마이즈? → [[Case Feed Visualforce 커스터마이즈]]
- Aura 컴포넌트를 Experience Builder용으로 개발? → [[Experience Builder Aura 사이트 개발]]
- Experience 사이트에 Pardot/CMS/케이스 deflection 붙이기? → [[Experience Builder 사이트 — Pardot·CMS·Deflection]]
- Aura에서 Apex를 호출하거나 옛 데이터(캐시) 문제를 겪는다면? / 선언적 레코드 CRUD? → [[Aura 데이터 연동 — 서버 Apex 액션 · Lightning Data Service]]

---

## 관련 폴더

- LWC 개발 → [[LWC/LWC MOC|LWC]]
- LWC 이벤트 → [[LWC/Events(이벤트)/index|LWC Events]]
