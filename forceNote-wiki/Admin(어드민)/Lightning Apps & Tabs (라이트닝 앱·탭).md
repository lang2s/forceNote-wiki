---
tags: [admin, ui-customization, lightning-apps, tabs, app-manager]
source: help.salesforce.com (Salesforce Help — Lightning Apps / App Manager / Tabs; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.manage_lightning_apps.htm&type=5
created: 2026-07-03
aliases: [Lightning Apps, 라이트닝 앱, App Manager, Tabs, 탭, Custom Tab, Utility Bar]
---

# Lightning Apps & Tabs (라이트닝 앱·탭)

> **Lightning App**은 특정 업무·페르소나용으로 탭·유틸리티 바를 묶어 브랜딩한 작업 공간. **App Manager**에서 만들고 프로파일에 배정한다. **Tabs**는 오브젝트·웹·VF·컴포넌트를 여는 네비게이션 항목이다.

---

## Lightning App이란

**Lightning App**은 특정 업무나 페르소나(예: 영업 담당자, 서비스 상담원)를 위해 **네비게이션 항목(탭)과 utility bar**를 하나로 묶고, 이름·색·로고로 **브랜딩**한 작업 공간이다. 사용자는 App Launcher에서 앱을 열어 그 업무에 필요한 탭·도구만 모아 사용한다.

- **표준 앱과 커스텀 앱**이 있다. 커스텀 앱은 관리자가 직접 만든다.
- 앱 생성·편집은 **Setup → App Manager**에서 한다.
- 앱에는 **네비게이션 항목(탭)**과 **utility bar**를 구성한다. (utility bar 세부 옵션은 공식 문서 위임 — 위 `official_doc` 참조.)

### 앱 배정 (가시성)

앱을 **프로파일에 배정**해 어떤 사용자가 그 앱을 볼 수 있는지 정한다. 프로파일에 배정되지 않은 사용자는 App Launcher에서 해당 앱을 볼 수 없다. 프로파일 자체의 관리는 [[Profiles (프로파일)]] 참조.

---

## Tabs (탭)

**Tab**은 항목을 여는 네비게이션 요소로, 앱의 네비게이션 바에 노출된다. 생성은 **Setup → Tabs**에서 한다.

| 탭 유형 | 여는 대상 |
|---|---|
| **Custom Object 탭** | 커스텀 오브젝트의 레코드 목록·상세 |
| **Web 탭** | 외부 웹 URL |
| **Visualforce 탭** | Visualforce 페이지 |
| **Lightning Component 탭** | Lightning 컴포넌트 |

- 커스텀 오브젝트를 만들면, 그 오브젝트의 **탭을 추가**해 앱 네비게이션에 노출시킨다. 커스텀 오브젝트·필드 자체는 [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] 참조.
- 만든 탭은 Lightning App의 네비게이션 항목으로 배치해 사용자에게 보여준다.

---

## 구성 흐름

```
// 구조 예시 — Lightning App & Tabs(실제 동작 코드 아님)
Setup → App Manager: Lightning App(브랜딩·utility bar)
   네비게이션 항목 = Tabs
      Custom Object 탭 · Web 탭 · Visualforce 탭 · Lightning Component 탭
   → 프로파일에 배정(가시성)
Setup → Tabs: 탭 생성
```

---

## 관련 노트
- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] — 앱 안 페이지 조립
- [[Profiles (프로파일)]] — 앱·탭 가시성 배정
- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] — 커스텀 오브젝트 탭
