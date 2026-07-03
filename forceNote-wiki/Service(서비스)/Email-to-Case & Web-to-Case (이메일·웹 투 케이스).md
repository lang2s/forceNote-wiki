---
tags: [service-cloud, email-to-case, web-to-case, case-channels, case-creation]
source: help.salesforce.com (Salesforce Help — Service; Set Up Email-to-Case / Web-to-Case; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.setting_up_web-to-case.htm&type=5
created: 2026-07-03
aliases: [Email-to-Case, Web-to-Case, 이메일 투 케이스, 웹 투 케이스, 케이스 자동 생성]
---

# Email-to-Case & Web-to-Case (이메일·웹 투 케이스)

> 인바운드 채널에서 case를 자동 생성하는 기능. **Email-to-Case**는 지원 이메일을, **Web-to-Case**는 웹사이트 폼 제출을 case로 변환한다.

---

## 개요

Email-to-Case와 Web-to-Case는 고객의 인바운드 요청을 **자동으로 새 case로 변환**하는 Service Cloud 채널이다. 두 기능 모두 고객이 별도 로그인 없이 지원 요청을 보낼 수 있게 하고, 접수된 요청을 Salesforce case 레코드로 만들어 지원 팀이 추적·처리하도록 한다.

```
// 구조 예시 — Email/Web-to-Case(실제 원본 다이어그램 아님)
고객 이메일  → Email-to-Case → Case  (라우팅: Omni-Channel flow 권장)
웹사이트 폼  → Web-to-Case  → Case  (활성화 → 폼 생성 → 사이트 삽입)
```

---

## Email-to-Case

고객이 보낸 **지원 이메일을 case로 자동 생성**한다.

### 설정
- Setup → Quick Find에 **"Email-to-Case"** 입력 → **Email-to-Case** 선택.

### 라우팅 권장
- Email-to-Case를 사용할 때는 record-triggered flow보다 **Omni-Channel flow**로 case를 목적지에 라우팅하는 것을 권장한다.

---

## Web-to-Case

회사 웹사이트에서 **고객 지원 요청을 직접 수집해 새 case를 자동 생성**한다.

### 설정 단계
1. 기능 **활성화**
2. **웹 폼 생성·커스터마이즈**
3. 폼을 **웹사이트에 추가**

경로: Setup → Quick Find에 **"Web-to-Case"** 입력 → **Web-to-Case** → 필드 작성 → 저장.

---

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — 생성 결과 레코드
