---
tags: [admin, security, login-ip-ranges, login-hours, trusted-ip, network-access]
source: help.salesforce.com (Salesforce Help — Restrict Login IP Addresses in Profiles / Set Trusted IP Ranges; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.login_ip_ranges.htm&type=5
created: 2026-07-03
aliases: [Login IP Ranges, 로그인 IP 범위, Login Hours, 로그인 시간, Trusted IP Ranges, 신뢰 IP, Network Access, IP 제한]
---

# Login IP Ranges & Login Hours (로그인 IP·시간 제한)

> 로그인 접근을 제한하는 두 축: **Login IP Ranges(프로파일)**는 허용 범위 밖 IP를 **거부(deny)**하고, **Trusted IP Ranges(org)**는 신뢰 밖 IP에 **본인 확인 챌린지**만 건다. **Login Hours(프로파일)**는 로그인 가능 시간대를 제한한다.

---

## 세 가지 제어의 한눈 비교

| 제어 | 적용 수준 | 관리 위치 | 범위 밖 IP·시간의 동작 |
|---|---|---|---|
| **Login IP Ranges** | 프로파일 | 프로파일 (Enterprise·Performance·Unlimited·Developer) / Session Settings (Group·Personal) | **로그인 거부(denied) — 하드 차단** |
| **Login Hours** | 프로파일 | 프로파일 | 지정 시간대 밖 로그인 **불가** |
| **Trusted IP Ranges** | org (Network Access) | Setup → Network Access | **본인 확인(verify identity) 챌린지** — 거부 아님 |

**핵심 구분:** 프로파일 **Login IP Ranges = 범위 밖 하드 거부** vs org **Trusted IP Ranges = 범위 밖 챌린지(MFA)**.

---

## 1. Login IP Ranges (프로파일 수준, 하드 거부)

프로파일에 **허용 IP 범위**를 지정하면, **그 외 IP에서의 로그인은 거부(denied)**된다. 범위 안에서만 로그인을 허용하는 화이트리스트 방식이며, 범위를 벗어난 접속은 챌린지가 아니라 곧바로 차단된다.

### 관리 위치 (Edition별)

- **Enterprise · Performance · Unlimited · Developer Edition** — **프로파일**에서 관리한다.
- **Group · Personal Edition** — **Session Settings** 페이지에서 관리한다.

### Winter '26 개수 한도 (신규)

> ⚠️ **Winter '26부터** 프로파일당 login IP range **개수 한도**가 적용된다. 한도는 **IPv4/IPv6 유형별로 다르며**, 한도를 초과하면 추가로 range를 등록할 수 없다.

기존에 대량의 range를 등록해 온 org은 이 한도로 인해 신규 추가가 막힐 수 있으므로, 업그레이드 전에 프로파일별 등록 개수를 점검한다.

---

## 2. Login Hours (프로파일 수준)

프로파일에 속한 사용자가 **로그인할 수 있는 시간대**를 제한한다. 지정한 시간대 밖에서는 로그인이 불가하며, 요일·시간 단위로 접근 창(window)을 정의한다. Login IP Ranges와 함께 같은 프로파일 화면에서 관리한다.

---

## 3. Trusted IP Ranges (org 수준, Network Access, 챌린지)

org 전역의 **신뢰 IP 범위**를 지정하면, **신뢰 범위 밖 IP에서 로그인할 때 본인 확인(verify identity) 챌린지**가 걸린다. 프로파일 Login IP Ranges와 달리 **로그인을 거부하지 않고**, 추가 인증(MFA/본인 확인)을 요구할 뿐이다. Setup의 **Network Access**에서 관리한다.

- 신뢰 범위 **안** IP → 별도 챌린지 없이 로그인.
- 신뢰 범위 **밖** IP → 본인 확인 챌린지 후 로그인 가능.

---

## 동작 요약 (구조 예시)

```
// 구조 예시 — Login IP / Hours(실제 동작 코드 아님)
프로파일 Login IP Ranges: 범위 밖 IP → 로그인 거부(deny)  [Winter'26 개수 한도]
프로파일 Login Hours:     지정 시간대 밖 → 로그인 불가
org Trusted IP Ranges:    범위 밖 IP → 본인 확인 챌린지(challenge, MFA)  (거부 아님)
```

---

## 관련 노트
- [[Profiles (프로파일)]] — Login IP Ranges·Login Hours는 프로파일 설정
- [[Session Settings (세션 설정)]] — Group·Personal Edition의 Login IP Ranges 관리 위치
- [[Salesforce ID 인증]] — Trusted IP 챌린지가 요구하는 본인 확인·MFA
- [[Security Health Check (보안 상태 점검)]] — login IP range를 baseline과 비교
