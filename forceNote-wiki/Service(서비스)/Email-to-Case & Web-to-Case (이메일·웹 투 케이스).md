---
tags: [service-cloud, email-to-case, web-to-case, case-channels, case-creation]
source: help.salesforce.com (Salesforce Help — Service; Set Up Email-to-Case / Web-to-Case; 라이브 공식 문서, Tier 2, 접속 2026-07-03); Web-to-Case Guidelines and Limits (service.customizesupport_web_to_case_notes, Tier 2); Add Routing Addresses for Email-to-Case (service.customizesupport_configuring_routing_addresses, Tier 2); Email-to-Case FAQ (service.faq_cases_email, Tier 2)
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

#### 필수 설정 단계 (누락 시 케이스 미생성)
1. **Email-to-Case 활성화** — Email-to-Case Settings에서 **Enable Email-to-Case** 체크박스와 **On-Demand Service** 체크박스를 활성화한다.
2. **Routing Address(라우팅 주소) 추가 + 검증** — 라우팅 주소를 추가하면 Salesforce가 해당 주소로 **검증(verification) 이메일**을 보낸다. 그 주소를 **verify(검증)하기 전에는 케이스가 생성되지 않는다.**

> ⚠️ **가장 흔한 블로커:** "Email-to-Case가 케이스를 안 만든다"의 대표 원인은 **라우팅 주소 검증(verification) 누락**이다. 검증 이메일 링크로 주소를 활성화해야 인바운드 이메일이 case로 변환된다.

#### On-Demand Service 하드 한도
- **25MB 초과** 이메일은 거부된다.
- 이메일 **본문·헤더는 32,000자**를 초과하면 절삭된다.

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

> ⚠️ **전제조건:** 폼 설정 시 **Default Case Owner(기본 케이스 소유자)** 지정이 필수다. 유입된 요청이 할당될 소유자가 지정돼야 case가 정상 생성된다.

### 한도·주의
- **하루 최대 5,000건**의 Web-to-Case 요청만 생성된다.
- 5,000건을 **초과한 요청은 pending(보류) 상태**로 대기했다가 한도가 리셋되면 처리된다.
- **24시간 넘게** 초과가 지속되면 초과분은 **폐기**되거나, 지정한 **Default Email 계정으로 전송**된다.

> ⚠️ 대량 유입(예: 마케팅 캠페인·장애 상황) 시 이 한도로 인해 **케이스 유실**이 발생할 수 있는 대표적 하드 한도다. 초과 대비 Default Email 계정을 지정해 두는 것이 안전하다.

---

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — 생성 결과 레코드
