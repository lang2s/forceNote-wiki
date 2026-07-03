---
tags: [admin, security, password-policies, lockout, security-controls]
source: help.salesforce.com (Salesforce Help — Set Password Policies; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.admin_password.htm&type=5
created: 2026-07-03
aliases: [Password Policies, 비밀번호 정책, 암호 정책, Lockout, 계정 잠금, Password Expiration]
---

# Password Policies (비밀번호 정책)

> 조직·프로파일의 비밀번호 요구사항(복잡도·만료·이력·로그인 실패 잠금 등)을 정하는 설정. 프로파일별 정책은 조직 전체 정책을 override한다.

---

## 개념

**Password Policies**는 사용자 비밀번호가 지켜야 할 요구사항과, 로그인 실패 시 계정 잠금(lockout) 동작을 정의하는 조직 보안 설정이다. Salesforce는 조직 전체(org-wide) 기본 정책을 제공하며, 필요 시 프로파일 단위로 더 엄격한(또는 다른) 정책을 별도로 설정할 수 있다.

정책으로 지정하는 비밀번호 요구사항의 범주:

- **최소 길이·복잡도** — 비밀번호가 가져야 할 최소 문자 수와 문자 종류(대소문자·숫자·특수문자 등) 조합 요건.
- **만료(expiration)** — 비밀번호를 일정 기간마다 변경하도록 강제.
- **비밀번호 이력(password history)** — 이전에 사용한 비밀번호의 재사용을 제한.
- **최대 로그인 실패 횟수(lockout)** — 지정 횟수만큼 로그인에 실패하면 계정을 잠금.
- **잠금 기간(lockout period)** — 계정이 잠긴 뒤 자동 해제되기까지의 시간.
- **비밀번호 힌트 제한** — 힌트에 비밀번호 자체를 포함하지 못하도록 제한.

> 개별 필드의 선택 가능한 값·범위(예: 만료 주기 옵션, 최대 실패 허용 횟수 목록 등) 세부는 공식 문서에 위임한다 — 위 `official_doc` 링크 참조.

---

## 접근 경로

Setup → **Password Policies**.

이 화면에서 위의 조직 전체 비밀번호 요구사항과 lockout 동작을 지정한다.

```
// 구조 예시 — Password Policies(실제 동작 코드 아님)
Setup → Password Policies (org-wide)
  복잡도·최소 길이 · 만료(expiration) · history(재사용 제한)
  최대 로그인 실패(lockout) · 잠금 기간 · 힌트 제한
프로파일별 정책 → org-wide override(프로파일 정책 우선)
```

---

## 프로파일 override

조직 전체(org-wide) password policy를 변경해도, **자체 password policy를 가진 프로파일에 속한 사용자에게는 그 변경이 적용되지 않는다.** 해당 프로파일의 정책이 우선(override)하기 때문이다.

즉, 특정 프로파일에 별도의 비밀번호 정책이 설정되어 있으면 그 사용자들은 조직 전체 정책이 아니라 프로파일 정책을 따른다. 조직 전체 정책 변경이 모든 사용자에게 반영될 것이라고 가정하지 않도록 주의한다 — 프로파일별 정책을 가진 사용자 그룹은 별도로 관리해야 한다.

---

## 관련 노트
- [[Salesforce ID 인증]] — 로그인·MFA 인증 흐름과 연계되는 자격 증명 정책.
- [[Profiles (프로파일)]] — 프로파일별 password policy가 org-wide 정책을 override한다.
- [[Security Health Check (보안 상태 점검)]] — password policy 설정을 보안 baseline과 비교·평가.
