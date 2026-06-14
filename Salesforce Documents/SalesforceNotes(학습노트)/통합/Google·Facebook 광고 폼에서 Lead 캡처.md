---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Lead Capture by google lead form]
---

# Google·Facebook 광고 폼에서 Lead 캡처

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Facebook·Google 광고 폼에서 Salesforce로 Lead를 캡처하는 2가지 방법: ① 통합(Integration), ② Lead Capture 앱.

## 1. 통합 사용
서드파티 시스템(ZAPIER)으로 Facebook·Google 광고 폼에서 Lead 캡처.

## 2. Lead Capture 앱 사용
AppExchange에서 Lead Capture 앱(Sales Cloud) 다운로드.

### 접근 허용 2단계
**① OAuth 설정 변경:**

Setup → "Manage Connected Apps" → Salesforce Lead Capture App → Edit → OAuth policies에서 "Admin approved users are pre-authorised" 선택.

**② 권한 집합 할당:**

Setup → "Permission Sets" → "Salesforce Lead Capture" → Manage Assignment → 사용자 추가.

### 사용
App Launcher → "Lead Capture" → New Task → Lead Source 선택:
- **Facebook Lead Form:** Facebook 로그인 → 페이지·폼 선택 → 폼 필드를 Lead 오브젝트 필드와 매핑.
- **Google Lead Form:** Google 로그인 → 필드 매핑.

Sales Cloud Campaign 선택 → Create the Lead Capture Task. 이제 Facebook·Google 광고에서 Lead 캡처.
