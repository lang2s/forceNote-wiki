---
tags: [index, lwc, create-components]
created: 2026-07-04
---

# Create Components (컴포넌트 작성) — 로컬 인덱스

> LWC Developer Guide의 **Create Components 섹션** 기초 갭을 채우는 노트 폴더 — 컴포넌트 라이프사이클 훅, CSS 스타일시트·스코핑 등 "컴포넌트를 만들 때 알아야 할 기본기"가 여기 모인다.

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Lifecycle Hooks]] | LWC 라이프사이클 훅 전수(constructor·connectedCallback·disconnectedCallback·renderedCallback·errorCallback) + hasRendered·isConnected·error boundary 패턴 | #pattern |
| [[CSS 스타일시트와 스코핑]] | LWC CSS 스타일시트·scoped CSS·shadow DOM 스코핑·`:host` 셀렉터·static stylesheets·cascade/specificity/inheritance·미지원(`::part`/`:host-context`) | #reference |
| [[컴포넌트 접근성 (ARIA·label)]] | LWC 접근성(a11y) — ARIA 속성·camel-case 프로퍼티(ariaLabel)·기본 ARIA·role 고정·ID 기반 ARIA 링크·label·screen reader·WCAG | #reference |
| [[컴포넌트 번들 구조와 첫 컴포넌트 만들기]] | 번들 파일 구성·camelCase 폴더→`c-kebab-case` 명명·SFDX CLI로 첫 컴포넌트 생성·노출·배포·페이지 배치 | #pattern |
| [[LWC 템플릿 기초 (데이터 바인딩·표현식)]] | `{property}` 중괄호 데이터 바인딩·getter·이벤트 핸들러 바인딩(표현식 불가, 계산값은 getter) | #reference |
| [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]] | 필드 재할당→재렌더, 객체/배열 mutate 시 재렌더 안 됨, immutable 교체·`@track` 필요 시점(개발자 멘털모델) | #reference |
| [[LWC Slots (기본·named·scoped)]] | `<slot>` 자리표시자 — default·named(`name`)·scoped(`lwc:slot-data`/`lwc:slot-bind`) 마크업 전달 | #reference |

---

## 빠른 선택

- 컴포넌트가 언제 생성·삽입·렌더·제거·에러되는지 훅 시점을 찾을 때? → [[Lifecycle Hooks]]
- 컴포넌트 CSS 스타일링·`:host`·shadow DOM 스코핑·static stylesheet를 찾을 때? → [[CSS 스타일시트와 스코핑]]
- ARIA·aria-label·스크린리더 등 컴포넌트 접근성을 찾을 때? → [[컴포넌트 접근성 (ARIA·label)]]
- 컴포넌트 번들이 어떤 파일로 구성되고 첫 컴포넌트를 어떻게 만드나? → [[컴포넌트 번들 구조와 첫 컴포넌트 만들기]]
- 템플릿에서 `{property}` 데이터 바인딩·getter·이벤트 핸들러를 찾을 때? → [[LWC 템플릿 기초 (데이터 바인딩·표현식)]]
- 언제 재렌더되나·`@track`이 필요한가? → [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]]
- 부모가 자식 body로 마크업을 넘기는 slot(named·scoped)? → [[LWC Slots (기본·named·scoped)]]

---

## 관련 폴더

- HTML 템플릿 directive·config XML 등 레퍼런스 → [[LWC/Reference(레퍼런스)/index|Reference(레퍼런스)]]
- 컴포넌트 API·컴포지션 패턴 → [[LWC/ComponentAPI(컴포넌트API)/index|ComponentAPI(컴포넌트API)]]
- LWC 섹션 전체 목차 → [[LWC MOC]]
