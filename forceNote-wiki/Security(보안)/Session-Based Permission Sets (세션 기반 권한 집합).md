---
tags: [security, permissions, session-based-permission-sets, access-control]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Session-Based Permission Sets; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.perm_sets_session_use.htm&type=5
created: 2026-07-03
aliases: [Session-Based Permission Sets, 세션 기반 권한 집합, SessionPermSetActivation, Session Activation Required]
---

# Session-Based Permission Sets (세션 기반 권한 집합)

> **특정 user session 동안만** 권한을 부여하는 permission set. 할당만으로는 부족하고 세션마다 **활성화(activate)**해야 하며, 민감 기능을 필요한 순간에만 여는 step-up 접근에 쓴다.

---

## 정의

A session-based permission set applies to a **specific user session** to grant someone functional access to permissions.

일반 permission set은 사용자에게 할당하는 순간부터 권한이 상시 유효하다. 반면 session-based permission set은 사용자에게 **할당**하는 것만으로는 권한이 부여되지 않는다. 사용자가 로그인한 **각 세션마다 별도로 활성화(activate)** 되어야 비로소 그 세션 동안 권한이 유효해지고, **세션이 끝나면 권한이 소멸**한다. 이 때문에 민감한 기능을 사용자가 실제로 필요로 하는 순간에만 열어주는 **step-up 접근** 패턴에 적합하다.

> permission set / permission set group 자체의 개념·할당 메커니즘은 [[Permission Sets (권한 집합)]] 참조. 이 노트는 그중 "세션 기반" 유형에 한정한다.

### Available in

- Salesforce Classic 및 Lightning Experience
- Essentials, Contact Manager, Professional, Group, Enterprise, Performance, Unlimited, Developer, Database.com 에디션

---

## 유스케이스 (원문 예시)

- **커스텀 오브젝트 + 모바일 앱** — 예: "Conference Room" 커스텀 오브젝트와 이를 사용하는 모바일 앱(Conference Room Sync 류)에서, 세션 동안만 해당 오브젝트에 접근을 부여.
- **기밀 정보에 접근하는 web application** — 보안상의 이유로 상시 권한이 아니라 세션 기반으로 접근을 부여.
- **Flow Builder** — Flow Builder에서도 session-based permission set을 사용할 수 있다(예: flow로 활성화).

---

## 제한

> [!warning] 비동기 프로세스 미지원
> Session-based permission set은 **비동기 프로세스(asynchronous processes)를 지원하지 않는다.** 예를 들어 메타데이터 배포(metadata deployment) 같은 비동기 작업에는 세션 기반 권한이 적용되지 않는다.

---

## 활성화 방법

할당 후, 각 세션마다 다음 중 한 방법으로 활성화해야 한다.

- **REST API / SOAP API** — **SessionPermSetActivation** 오브젝트를 사용해 활성화한다(자세한 내용은 Object Reference 참조).
- **Flow** — 사용자가 실행하는 Flow를 만들어, 그 Flow가 세션 기반 권한을 활성화/비활성화하게 할 수 있다.

### 활성화 흐름

```
// 구조 예시 — 세션 기반 권한 집합 활성화 흐름(실제 동작 코드 아님)
1) permission set 생성 시 "Session Activation Required" 지정
2) 사용자에 할당 → User detail: "Permission Set Assignments: Activation Required"
3) 세션 중 활성화:
     · Flow (사용자 실행)  또는
     · REST/SOAP API → SessionPermSetActivation 오브젝트
4) 세션 종료 시 권한 소멸
제한: 비동기 프로세스(메타데이터 배포 등) 미지원
```

---

## 할당 · 확인

- **User detail 페이지** — 사용자 detail 페이지에서 **"Permission Set Assignments: Activation Required"** 관련 목록으로 활성화가 필요한(세션 기반) 할당을 확인한다.
- **List view 컬럼** — permission set list view에 **"Session Activation Required"** 컬럼을 추가하면 어떤 permission set이 세션 기반인지 한눈에 확인할 수 있다.
- **할당 전 확인** — 할당하기 전에, 대상 사용자가 활성화 요건을 실제로 충족할 수 있는지 확인한다.

> 참고: **session-based permission set group**도 존재한다. permission set group 역시 특정 세션에 적용되도록 세션 기반으로 구성할 수 있다.

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브
- [[Permission Sets (권한 집합)]] — 세션 기반은 permission set의 한 유형
