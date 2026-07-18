---
tags: [admin, security, session-settings, session-timeout, security-controls]
source: help.salesforce.com (Salesforce Help — Modify Session Security Settings; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=xcloud.admin_sessions.htm&type=5
created: 2026-07-03
aliases: [Session Settings, 세션 설정, Session Timeout, 세션 타임아웃, High Assurance, Session Security]
---

# Session Settings (세션 설정)

> 조직의 세션 보안(타임아웃·로그인 보안 수준·IP 잠금 등)을 정하는 설정. Setup → Session Settings.

---

## 접근 경로

Setup → **Session Settings** (Security Controls 하위).

여기서 조직 전체에 적용되는 세션 보안 정책을 설정한다.

## 주요 설정

### Session Timeout (세션 타임아웃)

사용자 인증 세션이 만료되기까지의 **비활동(inactivity) 시간**(분/시간)을 정한다. 세션이 만료되면 사용자는 다시 로그인해야 한다.

> [!warning] 타임아웃 동작 주의 — 후반부(halfway)에만 활동 검사
> 활성 세션은 **타임아웃 기간의 후반부에서야** 활동을 검사한다. 예를 들어 타임아웃이 **30분**이면 마지막 **15분** 동안에만 활동을 체크하며, 그 후반부에 활동이 없으면 세션이 만료된다. **전반부의 활동은 만료 판정에 영향을 주지 않는다.**

### Session Security Level Required at Login (로그인 시 요구되는 세션 보안 수준)

**High Assurance**로 설정하면 로그인 시 **MFA(다중 인증)로 본인 확인**을 요구한다.

> High Assurance가 요구하는 MFA 메커니즘은 [[Salesforce ID 인증]] 참조.

### Lock sessions to the origin IP (세션을 시작 IP에 잠금)

세션을 **시작한 IP 주소에 잠근다.**

> [!warning] 권장: 꺼두기
> 단일 IP로 세션을 유지하지 않는 사용자(예: 네트워크 전환·모바일 등)를 로그아웃시킬 수 있어, **꺼두는 것이 권장**된다.

### 추가 옵션

clickjack 보호·강제 로그아웃 등 그 밖의 세션 보안 옵션도 이 화면에서 제공된다. (세부 옵션은 공식 문서 위임.)

## 설정 구조 (개념)

```
// 구조 예시 — Session Settings(실제 동작 코드 아님)
Setup → Session Settings
  Session Timeout(비활동 X분) — 후반부에만 활동 검사
  Session Security Level Required at Login: High Assurance → MFA 요구
  Lock sessions to origin IP (권장: 끔)
```

## 관련 노트
- [[Salesforce ID 인증]] — High Assurance가 요구하는 MFA
- [[Security Health Check (보안 상태 점검)]] — 세션 설정을 baseline과 비교 점검
- [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]] — Group·Personal Edition에서는 Login IP Ranges를 이 화면에서 관리
