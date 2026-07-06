---
tags: [lwc, navigation, mixin, pageReference, pattern]
source: lwc-recipes/navToRecord, navToNewRecord, navToListView, navToFlow
created: 2026-05-17
aliases: [NavigationMixin, pageReference, 네비게이션]
---

# NavigationMixin 패턴

> `NavigationMixin`으로 LWC에서 Salesforce 내 다양한 페이지로 이동. `pageReference` 타입에 따라 목적지 지정.

---

## 기본 구조

```javascript
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavComponent extends NavigationMixin(LightningElement) {
    navigateSomewhere() {
        this[NavigationMixin.Navigate]({ /* pageReference */ });
    }

    // URL 생성 (공유, 앵커 태그용)
    async generateUrl() {
        const url = await this[NavigationMixin.GenerateUrl]({ /* pageReference */ });
        return url;
    }
}
```

---

## GenerateUrl 활용 — 앵커 href 바인딩 & 새 탭 열기

> **왜 Promise인가:** `GenerateUrl`은 pageReference를 클라이언트 라우터가 **비동기로 URL 해석(resolve)** 하기 때문에 문자열이 아니라 Promise를 반환한다 → `await` 또는 `.then()`으로 받아야 한다.

### ① 앵커 태그 href 바인딩 (lwc-recipes navToRecord 원형)

`connectedCallback`에서 미리 URL을 생성해 프로퍼티에 저장 → 템플릿 `<a href={url}>`에 바인딩. 사용자가 우클릭 "새 탭에서 열기"·URL 복사를 할 수 있고, 일반 클릭은 `Navigate`로 SPA 내 이동 처리한다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<a href={url} onclick={handleClick}>레코드 열기</a>
```

```javascript
// 구조 예시 — 실제 동작 코드 아님
url;
recordPageRef;

connectedCallback() {
    this.recordPageRef = {
        type: 'standard__recordPage',
        attributes: { recordId: this.recordId, actionName: 'view' }
    };
    this[NavigationMixin.GenerateUrl](this.recordPageRef)
        .then((url) => { this.url = url; });   // Promise — 비동기 URL 해석
}

handleClick(event) {
    event.preventDefault();   // 브라우저 기본 이동 차단
    event.stopPropagation();
    this[NavigationMixin.Navigate](this.recordPageRef); // SPA 내 이동
}
```

### ② 새 탭으로 열기 (window.open)

이벤트 핸들러에서 URL을 `await`로 받은 뒤 `window.open(url, '_blank')`.

```javascript
// 구조 예시 — 실제 동작 코드 아님
async openInNewTab() {
    const url = await this[NavigationMixin.GenerateUrl]({
        type: 'standard__recordPage',
        attributes: { recordId: this.recordId, actionName: 'view' }
    });
    window.open(url, '_blank');   // 새 탭
}
```

> 콘솔 앱에서 "새 탭"은 브라우저 탭이 아니라 워크스페이스 탭이 자연스러울 수 있다 — 그 경우 아래 [[#Workspace API (콘솔 환경)]]의 `openTab`을 사용.

---

## pageReference 타입별 사용법

### 기존 레코드 보기

```javascript
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.recordId,
        objectApiName: 'Contact',
        actionName: 'view'  // 'view' | 'edit'
    }
});
```

### 새 레코드 생성

```javascript
this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'Contact',
        actionName: 'new'
    }
});

// 기본값 포함한 새 레코드
this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'Contact',
        actionName: 'new'
    },
    state: {
        defaultFieldValues: encodeDefaultFieldValues({ LastName: 'Test' })
    }
});
```

### 리스트 뷰

```javascript
this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'Contact',
        actionName: 'list'
    },
    state: { filterName: 'Recent' } // 선택적 초기 필터
});
```

### Flow 실행

```javascript
// 기본 Flow
this[NavigationMixin.Navigate]({
    type: 'standard__flow',
    attributes: { devName: 'SimpleGreetingFlow' }
});

// Flow 입력 변수 전달 (flow__ 접두사)
this[NavigationMixin.Navigate]({
    type: 'standard__flow',
    attributes: { devName: this.flowDevName },
    state: { flow__userName: 'Trailblazer' }
});
```

### 홈, 파일, Chatter

```javascript
// 앱 홈
this[NavigationMixin.Navigate]({ type: 'standard__namedPage', attributes: { pageName: 'home' } });

// 파일 홈
this[NavigationMixin.Navigate]({ type: 'standard__namedPage', attributes: { pageName: 'filePreview' } });

// Chatter 홈
this[NavigationMixin.Navigate]({ type: 'standard__namedPage', attributes: { pageName: 'chatter' } });
```

---

## Workspace API (콘솔 환경)

```javascript
import { IsConsoleNavigation, openTab } from 'lightning/platformWorkspaceApi';

@wire(IsConsoleNavigation)
isConsoleNavigation;

async openTabHandler() {
    if (!this.isConsoleNavigation) return; // 비콘솔 환경 가드

    await openTab({
        pageReference: {
            type: 'standard__objectPage',
            attributes: { objectApiName: 'Contact', actionName: 'list' }
        },
        focus: true,
        label: 'Contacts'
    });
}
```

---

## pageReference 타입 참조

| type | 용도 |
|---|---|
| `standard__recordPage` | 기존 레코드 view/edit |
| `standard__objectPage` | 객체 리스트, 새 레코드 |
| `standard__namedPage` | home, filePreview, chatter |
| `standard__webPage` | 외부 URL |
| `standard__flow` | Flow 실행 |
| `standard__component` | LWC 컴포넌트 페이지 |

---

## 관련 노트

- [[PageReference Types 레퍼런스]] — pageReference 타입·프로퍼티 전수 레퍼런스(이 노트는 how-to)
- [[Toast & 모달 패턴]]
- [[LWC 보안 패턴]]
- [[Screen Flow 설계]] — LWC에서 NavigationMixin으로 Screen Flow를 기동하는 패턴
- [[Aura Flow 로컬 액션 (availableForFlowActions)]] — Aura `lightning:navigation`(navService)으로 Flow에서 페이지 이동. NavigationMixin의 Aura·Flow 대응
