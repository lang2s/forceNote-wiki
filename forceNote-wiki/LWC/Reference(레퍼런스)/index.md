---
tags: [index, lwc, reference]
created: 2026-07-04
---

# Reference (레퍼런스) — 로컬 인덱스

> LWC Developer Guide의 **Reference 섹션** 갭을 채우는 전수 레퍼런스 노트 폴더 — HTML 템플릿 directive·config XML·데코레이터·`@salesforce` 모듈·PageReference 타입 등 "표/목록으로 찾아보는" 참조 자료가 여기 모인다.

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[HTML 템플릿 Directives 레퍼런스]] | LWC HTML 템플릿 directive 전수(lwc:if/elseif/else·for:each/item/index·iterator·key·slot·lwc:ref/dom/spread/on/is) + 위치별 지원 매트릭스 | #reference |
| [[@salesforce Modules 레퍼런스]] | `@salesforce/*` 스코프드 모듈 전수(apex·schema·label·resourceUrl·contentAssetUrl·user·userPermission·customPermission·client/formFactor·community·site·messageChannel) + getSObjectValue·refreshApex | #reference |
| [[XML Config File Elements (js-meta.xml) 레퍼런스]] | 컴포넌트 설정 파일 `*.js-meta.xml` 요소 전수(targets·target·capability·isExposed·apiVersion·masterLabel·targetConfig·lightning__ 타깃) — 컴포넌트 노출 위치 정의 | #reference |
| [[PageReference Types 레퍼런스]] | NavigationMixin PageReference 타입 전수(standard__recordPage·objectPage·navItemPage·component·webPage·flow·quickAction·comm__namedPage) — 페이지 이동 대상 정의 | #reference |
| [[LWC API Modules 레퍼런스]] | record 데이터·Salesforce API 접근용 `lightning/*`·`experience/*` 스코프 API 모듈 23종 전수(uiRecordApi·graphql·uiObjectInfoApi·uiListsApi·empApi·mobileCapabilities·analyticsWaveApi·platformWorkspaceApi·cmsDeliveryApi) + 각 모듈 First API Version | #reference |

---

## 빠른 선택

- 템플릿 조건·리스트 렌더링, 슬롯, DOM 참조 directive를 찾을 때? → [[HTML 템플릿 Directives 레퍼런스]]
- Apex·schema·label·정적 리소스 등 `@salesforce/*` 모듈 임포트를 찾을 때? → [[@salesforce Modules 레퍼런스]]
- 컴포넌트를 어디에(레코드 페이지·앱 페이지·Flow 등) 노출할지 `js-meta.xml` 설정을 찾을 때? → [[XML Config File Elements (js-meta.xml) 레퍼런스]]
- NavigationMixin으로 이동할 페이지 타입(PageReference)을 찾을 때? → [[PageReference Types 레퍼런스]]
- `lightning/uiRecordApi`·`lightning/graphql` 등 어떤 wire adapter/API 모듈이 있고 언제부터 쓸 수 있는지 찾을 때? → [[LWC API Modules 레퍼런스]]

---

## 관련 폴더

- 컴포넌트 API·컴포지션 패턴 → [[LWC/ComponentAPI(컴포넌트API)/index|ComponentAPI(컴포넌트API)]]
- LWC 섹션 전체 목차 → [[LWC MOC]]
