---
tags: [lwc, internals, render-cycle, rerender, rehydrate, reconcile, vdom, scheduler, microtask, isDirty, isScheduled, ReactiveObserver]
source: lwc-master/packages/@lwc/engine-core/src/framework/vm.ts, component.ts (github.com/salesforce/lwc, master) | developer.salesforce.com LWC Guide — Reactivity (Tier 2, 접속 2026-07-08)
created: 2026-07-08
aliases: [LWC 렌더 사이클, LWC 재렌더 루프, rehydrate, rerenderVM, rehydration queue, scheduleRehydration, flushRehydrationQueue, patchShadowRoot, VDOM diff, reconcile, 재조정, microtask 배칭, LWC 렌더링 파이프라인]
---

# LWC 렌더·재조정 루프

> 반응형 값이 바뀐 순간부터 화면이 갱신되기까지의 흐름 — dirty 표시 → microtask 스케줄러 큐 → `rehydrate` → template 재실행 → VDOM diff(재조정) → DOM 패치 → `renderedCallback`. [[LWC VM 내부 구조]]가 나열하는 `isDirty`·`isScheduled`·`tro`·`rerenderVM` 필드를 하나의 **사이클**로 엮은 노트다.

**상위:** [[index|Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 이 노트 vs. VM 노트 (필드 vs. 흐름)

- [[LWC VM 내부 구조]] = `vm.ts`의 **필드 레퍼런스**(어떤 필드가 존재하는가).
- 이 노트 = 그 필드들이 **시간 축에서 어떻게 연결되는가**(값 변경 → DOM 갱신의 순서).
- 개발자 관점의 "무엇을 재할당해야 재렌더되나"는 [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]]가 다룬다. 이 노트는 그 아래 엔진 루프.

---

## 전체 흐름 (한 눈에)

```
// 구조 예시 — 실제 원본 다이어그램 아님 (engine-core 호출 순서를 도식화)

  [반응형 값 재할당/mutation]
          │  (tro = template ReactiveObserver 가 관찰 중이던 값)
          ▼
  tro 콜백 발화 ── if (!vm.isDirty) ───────────────┐
          │                                        │
          ▼                                        │
  markComponentAsDirty(vm)   →  vm.isDirty = true  │
          ▼                                        │
  scheduleRehydration(vm)                          │
     if (!vm.isScheduled) vm.isScheduled = true    │  ← 여러 변경이
     큐가 비어 있으면                                │    같은 tick에 쌓임
     addCallbackToNextTick(flushRehydrationQueue)  │    (배칭)
          │                                        │
   ─ ─ ─ microtask 경계 (현재 동기 코드가 끝난 뒤) ─ ─ ─
          ▼
  flushRehydrationQueue()
     큐를 idx(생성 순)로 정렬 → 부모 먼저
     각 vm 마다 rehydrate(vm)
          ▼
  rehydrate(vm)  ── if (vm.isDirty) ──┐
          ▼                           │
  renderComponent(vm)                 │  template 재실행 → 새 VNodes,
     (내부에서 isDirty=false 리셋)     │  isDirty 해제
          ▼                           │
  patchShadowRoot(vm, newVNodes)      │
     patchChildren(oldCh, newCh, …)   │  ← VDOM diff / 재조정(reconcile)
     → DOM 패치                        │
          ▼                           │
  vm.state === connected 이면          │
  runRenderedCallback(vm)  ───────────┘  → renderedCallback()
```

---

## 1단계 — 반응형 값 관찰 (tro)

렌더 중 템플릿이 읽는 모든 반응형 값은 VM의 **template reactive observer** `vm.tro`(`ReactiveObserver`)가 구독한다. `vm.ts`의 `createVM`이 이 옵저버를 만든다.

```javascript
// vm.ts — createVM 내부 (실제 소스)
vm.tro = getTemplateReactiveObserver(vm);
```

`getTemplateReactiveObserver`는 `component.ts`에서 아래 콜백을 `ReactiveObserver`에 등록한다. **관찰하던 값이 mutate되면 이 콜백이 발화**한다.

```javascript
// component.ts — getTemplateReactiveObserver 가 등록하는 콜백 (실제 소스)
() => {
    const { isDirty } = vm;
    if (isFalse(isDirty)) {          // 이미 dirty면 중복 스케줄 안 함
        markComponentAsDirty(vm);    // vm.isDirty = true
        scheduleRehydration(vm);     // 다음 tick 재렌더 예약
    }
};
```

- 값이 렌더에 실제로 쓰였을 때만 tro가 구독하므로, **템플릿에서 안 쓰는 필드**를 바꿔도 재렌더는 일어나지 않는다.
- `@track` 객체의 중첩 mutation을 tro가 잡는 경로는 [[@track 데코레이터 내부 구조]](observable-membrane proxy) 참조.

---

## 2단계 — dirty 표시 (`isDirty`)

`markComponentAsDirty(vm)`은 단순히 플래그를 세운다.

```javascript
// component.ts — markComponentAsDirty (실제 소스)
vm.isDirty = true;
```

- `isDirty`는 "이 컴포넌트는 재렌더가 필요하다"는 표식이다.
- 콜백이 `if (isFalse(isDirty))`로 가드하므로, **한 tick 안에서 값을 10번 바꿔도 스케줄은 한 번만** 걸린다(2단계 배칭의 1차 필터).
- 실제 재렌더 시 `renderComponent`가 다시 `false`로 되돌린다(4단계).

> `isDirty` 필드 자체의 정의는 [[LWC VM 내부 구조]]의 VM 인터페이스 "상태" 섹션 참조.

---

## 3단계 — microtask 스케줄러 큐 (`isScheduled` + 배칭)

`scheduleRehydration(vm)`이 VM을 **rehydration 큐**에 넣고, 큐 flush를 다음 microtask로 예약한다.

```javascript
// vm.ts — scheduleRehydration (동작 요약, 실제 소스 기반)
function scheduleRehydration(vm) {
    if (isTrue(vm.isScheduled)) {
        return;                    // 이미 큐에 있음 → 중복 방지
    }
    vm.isScheduled = true;
    // 큐가 비어 있을 때만 다음 tick에 flush 콜백을 1번 등록
    if (queue.length === 0) {
        addCallbackToNextTick(flushRehydrationQueue);
    }
    ArrayPush.call(queue, vm);     // 이 VM을 큐에 적재
}
```

**배칭(batching)이 일어나는 지점:**

| 필터 | 무엇을 막나 |
|---|---|
| `isDirty` 가드(2단계) | 같은 VM의 여러 값 변경이 dirty 표시·스케줄을 **1회로** 합침 |
| `isScheduled` 가드 | 이미 큐에 있는 VM의 **중복 적재** 방지 |
| `queue.length === 0` 조건 | 한 tick에 여러 VM이 dirty여도 flush 콜백은 **딱 1번만** 예약 |

즉, 하나의 동기 실행(이벤트 핸들러 등)에서 `this.a`, `this.b`, `this.c`를 연달아 바꿔도 **재렌더는 다음 microtask에 한 번**만 일어난다. 이것이 LWC가 "여러 상태 변경을 한 번의 재렌더로 합치는" 방식이다.

**microtask 타이밍:** `addCallbackToNextTick`은 현재 동기 코드(핸들러 전체)가 끝난 직후, 브라우저가 다음 태스크로 넘어가기 전에 콜백을 실행한다. 그래서 재렌더는 "즉시"가 아니라 "이번 동기 블록이 끝난 바로 다음"이다 — 핸들러 안에서 값을 바꾼 직후 DOM을 읽으면 **아직 갱신 전**이고, 갱신 후 DOM은 [[Lifecycle Hooks|renderedCallback]]에서 읽어야 한다.

---

## 4단계 — 큐 flush → rehydrate

microtask가 돌면 `flushRehydrationQueue`가 큐를 비우며 각 VM을 재수화(rehydrate)한다.

```javascript
// vm.ts — flushRehydrationqueue (동작 요약, 실제 소스 기반)
// 1) 큐를 생성 순 인덱스로 정렬 → 부모(작은 idx)가 자식보다 먼저
queue.sort((a, b) => a.idx - b.idx);
// 2) 각 VM 재수화
for (const vm of queue) {
    rehydrate(vm);
}
```

정렬(`a.idx - b.idx`)로 **부모를 자식보다 먼저** 재렌더한다 — 부모 렌더가 자식의 prop을 바꿀 수 있으므로 순서가 중요하다.

`rerenderVM(vm)`은 이 재수화의 얇은 진입점이다(즉시 1개 VM 재렌더).

```javascript
// vm.ts (실제 소스)
export function rerenderVM(vm) {
    rehydrate(vm);
}
```

핵심 `rehydrate`:

```javascript
// vm.ts — rehydrate (실제 소스)
function rehydrate(vm) {
    if (isTrue(vm.isDirty)) {
        const children = renderComponent(vm);   // template 재실행 → 새 VNodes
        patchShadowRoot(vm, children);           // diff + DOM 패치
    }
}
```

- `renderComponent(vm)` — 컴포넌트의 `render()`(기본은 컴파일된 템플릿 함수)를 다시 실행해 **새 VDOM(VNodes)** 을 만든다. 이 과정에서 tro가 새 구독을 다시 등록하고, `vm.isDirty`를 `false`로 리셋한다.
- 큐에 있었지만 그 사이 다시 clean해진 VM은 `if (isTrue(vm.isDirty))`에서 걸러진다.

---

## 5단계 — VDOM diff(재조정) + DOM 패치

`patchShadowRoot`가 **이전 VNodes(oldCh)** 와 **새 VNodes(newCh)** 를 비교(diff)해 바뀐 부분만 실제 DOM에 반영한다.

```javascript
// vm.ts — patchShadowRoot (실제 소스, 요약)
function patchShadowRoot(vm, newCh) {
    const { renderRoot, children: oldCh, renderer } = vm;
    resetRefVNodes(vm);
    vm.children = newCh;                         // 새 VNodes를 현재로 저장
    if (newCh.length > 0 || oldCh.length > 0) {
        if (oldCh !== newCh) {
            // 핵심: 재조정(reconciliation) 알고리즘
            patchChildren(oldCh, newCh, renderRoot, renderer);
        }
    }
    if (vm.state === VMState.connected) {
        runRenderedCallback(vm);                 // 6단계
    }
}
```

- **`patchChildren(oldCh, newCh, …)`** 가 재조정(reconcile)의 심장이다. 두 VNode 리스트를 keyed diff로 대조해 **추가·제거·이동·속성 변경**만 골라 `renderer`(DOM 조작 추상화)로 패치한다. 전체 DOM을 새로 그리지 않는다.
- `for:each` 리스트의 재사용은 `key`로, `<slot>` 콘텐츠는 diffing 알고리즘으로 결정된다(요소 재사용 규칙은 [[Lifecycle Hooks]]의 "요소 재사용 예외" 참조).
- `renderRoot`는 Shadow DOM이면 `shadowRoot`, Light DOM이면 host `elm`이다([[LWC VM 내부 구조]]).

---

## 6단계 — renderedCallback

패치가 끝나고 컴포넌트가 여전히 `connected` 상태면 `renderedCallback`을 호출한다.

```javascript
// vm.ts — runRenderedCallback (실제 소스, 요약)
function runRenderedCallback(vm) {
    // ...
    invokeComponentCallback(vm, renderedCallback);   // 컴포넌트의 renderedCallback() 실행
}
```

- 이 시점의 DOM은 **이번 재렌더 결과가 반영된 최신 상태**다 — 서드파티 라이브러리 초기화·`this.template.querySelector` 등은 여기서.
- 매 재렌더마다 실행되므로 1회성 작업은 `hasRendered` 가드로 막는다. `renderedCallback`에서 public/wire config 프로퍼티를 바꾸면 다시 dirty→재렌더→무한 루프. (상세 규칙: [[Lifecycle Hooks]])

---

## 필드 ↔ 단계 매핑 (VM 노트와의 접점)

| VM 필드 ([[LWC VM 내부 구조]]) | 이 루프에서의 역할 | 세우는 곳 → 지우는 곳 |
|---|---|---|
| `tro: ReactiveObserver` | 렌더 중 읽은 반응형 값 구독 → 변경 시 콜백 발화 | 1단계 |
| `isDirty` | "재렌더 필요" 표식 | `markComponentAsDirty`(2단계) → `renderComponent`가 리셋(4단계) |
| `isScheduled` | 큐 중복 적재 방지 | `scheduleRehydration`(3단계) → flush 시 해제 |
| `children` | 직전 렌더의 VNodes(diff 기준) | `patchShadowRoot`가 새 값으로 교체(5단계) |
| `renderRoot` | 패치 대상 루트(shadowRoot 또는 elm) | 5단계 |
| `state` | `connected`일 때만 renderedCallback | 6단계 게이트 |

---

## 관련 노트
- [[LWC VM 내부 구조]] — 이 루프가 다루는 `isDirty`·`isScheduled`·`tro`·`children` 등 필드의 레퍼런스(필드 vs. 흐름)
- [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]] — 개발자 관점: 무엇을 재할당해야 이 루프가 시작되나(primitive 재할당 · immutable 업데이트)
- [[@track 데코레이터 내부 구조]] — 객체·배열 내부 mutation을 tro가 감지하게 하는 observable-membrane proxy
- [[Lifecycle Hooks]] — 이 루프의 종착점 `renderedCallback`과 요소 재사용(`key`·slot) 규칙, 무한 루프 주의
- [[LWC 오픈소스 아키텍처]] — engine-core 전체 구조 속 vm.ts·component.ts의 위치
- [[LWC MOC]] — LWC 섹션 전체 목차
