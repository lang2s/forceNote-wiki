---
tags: [security, connected-apps, oauth, monitoring, session-management, admin, audit]
source: https://help.salesforce.com/s/articleView?id=sf.connected_app_manage_oauth.htm (Salesforce Help — Monitor Usage for an OAuth Connected App, Tier 2, 2026-07-12)
created: 2026-07-12
aliases: [Connected Apps OAuth Usage, OAuth Usage, OAuth 사용 모니터링, connected app 사용 현황, connected app 차단, Block Connected App, Install Connected App, Uninstall Connected App, OAuth 토큰 감사]
---

# Connected Apps OAuth Usage (OAuth 사용 모니터링)

> Setup의 **Connected Apps OAuth Usage** 페이지 — org에서 실제로 OAuth로 인증·사용 중인 connected app 목록과 사용 현황(사용자 수·설치 상태·세션)을 한눈에 보고, 앱별로 **Install / Block / Uninstall** 액션을 취하는 OAuth 토큰 감사·거버넌스 화면이다.

---

## 개념 — 정의(Connected App)와 사용 모니터링(OAuth Usage)의 구분

Salesforce는 connected app을 두 관점에서 다룬다. 이 둘을 혼동하기 쉽다.

| 관점 | 화면 | 목적 |
|---|---|---|
| **정의(Definition)** | Setup > App Manager / Connected Apps | connected app을 **만들고** OAuth 클라이언트 설정(Consumer Key·Scope·Callback URL·OAuth Policies)을 정의 — [[Connected App (연결된 앱) — OAuth 클라이언트]] |
| **사용 모니터링(Usage)** | Setup > **Connected Apps OAuth Usage** | 이미 org에서 **사용 중인** 앱(직접 만든 것 + 외부에서 사용자가 승인한 것)을 감사하고 액션 |

즉 **Connected Apps OAuth Usage는 "누가 어떤 OAuth 앱을 실제로 쓰고 있는가"를 감사하는 런타임/사후 관점**이고, connected app 정의 화면은 "앱을 어떻게 만들고 정책을 거는가"의 설계 관점이다. OAuth Usage 페이지에는 org에 정식으로 **설치(install)되지 않았어도** 사용자가 OAuth로 승인해 토큰을 발급받은 앱까지 나타난다.

> [!note] Setup 라벨 캐비엇 (2026-07-12)
> 아래 페이지 위치·컬럼·버튼 라벨은 공식 Salesforce Help(Tier 2)와 교차 소스로 확인했으나, help.salesforce.com은 SPA로 렌더링돼 라벨을 verbatim으로 추출하지 못한 항목이 있다. org 버전에 따라 표시 문구가 다를 수 있으니 실제 org에서 최종 확인을 권장한다.

---

## 접근 경로 (Setup)

```
# 구조 예시 — 실제 원본 UI 캡처 아님 (Setup 네비게이션 구조)
Setup
 └─ Quick Find: "Connected Apps OAuth Usage"
     └─ Connected Apps OAuth Usage
         ├─ 행별: Connected App(앱 이름) | User Count(사용자 수) | Action(액션)
         ├─ Action 컬럼:
         │    ├─ Install     ← 아직 org에 설치되지 않은 앱을 정식 설치
         │    ├─ Uninstall   ← 설치된 앱을 제거
         │    └─ Block / Unblock ← 앱 접근 차단/해제
         └─ User Count 클릭 → 앱별 사용 상세(사용자별 세션·Use Count)
```

- **Quick Find 검색어:** `Connected Apps OAuth Usage`
- 각 행은 org에서 OAuth를 통해 사용된 connected app 1개를 나타낸다.

---

## 페이지가 보여주는 것

| 정보 | 설명 |
|---|---|
| **Connected App (앱 이름)** | OAuth로 사용된 connected app 이름 |
| **User Count (사용자 수)** | 그 앱을 사용(OAuth 승인)한 사용자 수. 클릭하면 사용자별 상세로 드릴다운 |
| **설치 상태** | Action 컬럼의 버튼으로 구분 — `Install` 버튼이 있으면 **미설치(uninstalled)** 앱, `Uninstall`이 있으면 **설치됨** |
| **사용자별 세션 / Use Count** | User Count 드릴다운에서 사용자별로 발급된 OAuth 세션(토큰)과 사용 횟수를 확인·개별 revoke |

이 화면은 **OAuth 토큰 감사** 용도로 쓴다: org에 어떤 서드파티/내부 앱이 토큰을 들고 있는지, 몇 명이 승인했는지, 미설치인데 널리 쓰이는 앱은 없는지 점검한다.

---

## 액션 — Install / Block / Uninstall

### Install (설치)

- Action 컬럼에 **Install** 버튼이 있는 행 = 아직 org에 정식 설치되지 않았지만 사용자가 OAuth로 승인해 사용 중인 앱.
- 신뢰하는 앱을 계속 쓰려면 **Install**을 눌러 정식 설치한다. 설치 시 org 차원의 접근 정책(승인 사용자·IP·권한)을 관리할 수 있게 된다.
- **설치 시 권장 설정:** OAuth Policies의 **Permitted Users**를 `Admin approved users are pre-authorized`로 지정한다. `All users may self-authorize`로 두면 모든 사용자가 스스로 승인 가능해 통제가 무의미해진다. → 프로파일/권한 집합으로만 접근 부여(최소 권한 원칙).

### Block (차단)

- 앱 접근을 즉시 차단한다.
- **Block하면 그 앱의 모든 활성 세션이 끊기고(disconnect all active sessions)**, Unblock할 때까지 사용자가 앱에 접근할 수 없다.
- 정의되지 않았거나 신뢰할 수 없는 앱, 사고 대응 시 긴급 차단에 사용. 차단은 되돌릴 수 있다(Unblock).

### Uninstall (제거)

- 설치된 connected app을 org에서 제거한다.

---

## 설치 앱의 접근 관리 — 프로파일 / 권한 집합 승인

Install한 앱에 대해서는 **누가 쓸 수 있는지**를 두 축으로 통제한다.

1. **Permitted Users (OAuth Policies)**
   - `All users may self-authorize` — 모든 사용자가 개별적으로 앱을 스스로 승인·연결(느슨함, 권장 안 함).
   - `Admin approved users are pre-authorized` — 관리자가 사전 승인한 사용자만. 가장 제한적(권장).
2. **프로파일 / 권한 집합 지정** — `Admin approved users are pre-authorized`를 선택하면, 앱 접근을 부여할 **Profiles** 또는 **Permission Sets**를 명시적으로 연결한다. 이렇게 하면 명시적으로 승인된 사용자만 앱에 접근한다(최소 권한, principle of least privilege).

> 참고: 최근 Salesforce는 미설치 connected app에 대해 **"기본 거부(deny by default)"** 모델로 강화하는 방향으로 usage restriction을 바꿔왔다 — 정식 설치되지 않은 앱은 일반 사용자가 승인할 수 없도록 제한하는 흐름. OAuth Usage 페이지의 Install/Block 액션이 이 거버넌스의 실무 접점이다.

---

## 관련 감사 관점 — Transaction Security와의 연계

Connected Apps OAuth Usage가 **사후/현황 감사**라면, [[TxnSecurity Namespace]]와 Setup의 Transaction Security Policies는 **실시간 차단**이다. connected app을 통한 리소스 접근·데이터 내보내기 이벤트(`AccessResource`, `ApiEvent`, `DataExport`)를 실시간으로 감시해 조건에 맞으면 Block/MFA/Notify한다. 레거시 Transaction Security 이벤트의 `ConnectedAppId`·`resourceType = Connected Application` 필드가 이 연결점이다. 두 기능을 함께 쓰면 "누가 쓰는지 감사(OAuth Usage) + 위험 접근 실시간 차단(Transaction Security)"의 이중 방어가 된다.

---

## 관련 노트

- [[Connected App (연결된 앱) — OAuth 클라이언트]] — connected app **정의**·OAuth 클라이언트 설정(정의 vs 사용 모니터링의 짝)
- [[Login Flows · OAuth Custom Scopes (로그인 흐름·커스텀 스코프)]] — OAuth 스코프·로그인 흐름
- [[Integration User & API-Only User (통합 사용자)]] — 통합용 OAuth 접근 주체
- [[Permission Sets (권한 집합)]] — 앱 접근을 부여하는 권한 집합
- [[Profiles (프로파일)]] — 앱 접근을 부여하는 프로파일
- [[Salesforce 권한 모델 개요]] — org 접근 통제 전체 그림
- [[TxnSecurity Namespace]] — connected app 접근 이벤트의 실시간 차단(Transaction Security)
