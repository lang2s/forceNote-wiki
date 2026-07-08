---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [LifeCycle Hooks in LWC Part -1]
---

# LWC 라이프사이클 훅 (Part 1)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

라이프사이클 훅은 컴포넌트 생애 단계를 정의하고, @wire는 컴포넌트를 Salesforce 데이터에 반응형 연결해 데이터 변경 시 UI 업데이트.

## @wire vs Imperative Apex
@wire는 매개변수 변경 시 자동 조회·업데이트. 단, 반응형 매개변수가 undefined면 wire 핸들러 미실행(연쇄 렌더링).

**@wire 시퀀스:**

constructor → @wire(빈 데이터 {data: undefined, error: undefined}) → connectedCallback → render → renderedCallback → @wire 서버 데이터 제공(추가 렌더링 가능). 최소 2번 렌더링.

**Imperative Apex 시퀀스:**

constructor → connectedCallback(콜아웃 실행) → render → renderedCallback → Apex 반환(DOM 영향 시 추가 렌더링). connectedCallback에 두고 promise로 비동기 제어.

## 3개 컴포넌트 예 (A 부모, B 자식, C 손자)
**실행 순서:**

A constructor → A @wire(no data) → A connectedCallback → B constructor → B @wire(no data) → B connectedCallback → C constructor → C @wire(no data) → C connectedCallback → C renderedCallback → B renderedCallback → A renderedCallback → (이후 @wire 데이터 제공으로 추가 사이클).

## 핵심
- @wire는 빈 데이터 객체 생성, 반응형 매개변수 정의 전 미실행. 데이터 업데이트 시 다중 render·renderedCallback.
- Imperative Apex는 constructor 대신 connectedCallback에서 초기화(DOM 준비 후).
- 라이프사이클은 부모→자식, 렌더링은 자식→부모(renderedCallback).

## Pro Tip: @wire + Imperative 결합
```javascript
async connectedCallback() {
    await Promise.resolve();
    let apexResults = await Promise.all([method1(params), method2(params)]);
    // 결과 처리
}
```
wire 메서드를 한 서버 왕복으로 큐잉 후 Apex를 다른 왕복으로 호출해 반응성 향상.
