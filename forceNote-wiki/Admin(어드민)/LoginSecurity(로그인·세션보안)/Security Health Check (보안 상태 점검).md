---
tags: [admin, security, health-check, baseline, security-score]
source: help.salesforce.com (Salesforce Help — Salesforce Security Health Check; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.security_health_check.htm&type=5
created: 2026-07-03
aliases: [Health Check, 보안 상태 점검, Security Health Check, Baseline Standard, Security Score, 보안 점수]
---

# Security Health Check (보안 상태 점검)

> 조직의 보안 설정이 **Salesforce Baseline Standard**(또는 커스텀 baseline)에 얼마나 부합하는지 점수로 보여주고, 위험 설정을 도구에서 바로 고치게 하는 진단 도구. Setup → Health Check.

---

## 개념

Health Check **score**는 조직의 **보안 설정이 Salesforce Baseline Standard(또는 선택한 커스텀 baseline)에 얼마나 부합하는지**를 측정하는 독점(proprietary) 공식으로 계산된다. 관리자는 이 점수를 통해 조직의 보안 취약점을 한눈에 파악하고 개선할 수 있다.

## 평가 대상

Health Check는 다음과 같은 보안 설정을 baseline과 비교 평가한다.

- Password policy (비밀번호 정책)
- Session settings (세션 설정)
- **Login IP ranges** (로그인 IP 범위)
- Network access (네트워크 액세스)

## 조치

- Health Check 도구에서 위험(risk) 설정을 확인하고 **바로 수정**할 수 있다.
- **커스텀 baseline**을 만들어(import) 조직 기준에 맞춰 평가할 수도 있다. 이 경우 Salesforce Baseline Standard 대신 선택한 커스텀 baseline과의 부합도로 점수가 계산된다.

## 접근

Setup → Quick Find에서 "Health Check" 입력 → **Health Check**.

## 동작 흐름

```
// 구조 예시 — Security Health Check(실제 동작 코드 아님)
Setup → Health Check
  현재 보안 설정 ── 비교 ──▶ Baseline(Salesforce Standard 또는 커스텀)
     평가: Password Policy · Session Settings · Login IP Ranges · Network Access …
  → Score(부합도) + Risk 목록 → 도구에서 바로 수정
```

## 관련 노트
- [[Password Policies (비밀번호 정책)]] — Health Check 평가 대상.
- [[Session Settings (세션 설정)]] — Health Check 평가 대상.
- [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]] — Health Check 평가 대상.
