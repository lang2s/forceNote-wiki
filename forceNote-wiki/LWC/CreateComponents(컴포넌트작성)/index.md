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

---

## 빠른 선택

- 컴포넌트가 언제 생성·삽입·렌더·제거·에러되는지 훅 시점을 찾을 때? → [[Lifecycle Hooks]]
- 컴포넌트 CSS 스타일링·`:host`·shadow DOM 스코핑·static stylesheet를 찾을 때? → [[CSS 스타일시트와 스코핑]]

---

## 관련 폴더

- HTML 템플릿 directive·config XML 등 레퍼런스 → [[LWC/Reference(레퍼런스)/index|Reference(레퍼런스)]]
- 컴포넌트 API·컴포지션 패턴 → [[LWC/ComponentAPI(컴포넌트API)/index|ComponentAPI(컴포넌트API)]]
- LWC 섹션 전체 목차 → [[LWC MOC]]
