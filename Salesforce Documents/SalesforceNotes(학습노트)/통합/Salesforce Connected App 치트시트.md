---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Connected App Cheatsheet]
---

# Salesforce Connected App 치트시트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## 소개
Connected App은 외부 애플리케이션이 Salesforce에 연결·상호작용하는 다리. 외부 앱이 Salesforce 데이터·기능에 안전하게 접근.

## 용어
1. **Connected App Name:** 고유 이름.
2. **API Name:** 고유 API 식별자(자동 생성).
3. **Contact Email:** 담당자 이메일.
4. **OAuth Settings:** Enable OAuth, Callback URL(인증 후 리디렉션), Selected OAuth Scopes(api·refresh_token·full 등).
5. **Permitted Users:** 사용 가능 사용자(전체, Admin만).
6. **IP Relaxation:** 신뢰 IP 범위.
7. **Start URL:** 로그인 시 이동 URL.
8. **Custom Attributes:** 추가 속성.
9. **Client ID:** 고유 식별자.
10. **Client Secret:** 비밀 키(비밀번호 역할).

## 단계
**1.** Setup → Quick Find → App Manager.
**2.** New Connected App 클릭·세부 입력.
**3.** 강조 링크 클릭으로 Client ID·Client Secret 획득.
**4.** OAuth 토큰 POST 요청:
```
https://login.salesforce.com/services/oauth2/token?grant_type=password
&client_id={CLIENT_ID}&client_secret={CLIENT_SECRET}
&username={USERNAME}&password={PASSWORD + SECURITY_TOKEN}
```
**5.** OAuth 토큰으로 데이터 조회:
```
https://YOUR_INSTANCE_URL.salesforce.com/services/data/v53.0/sobjects/account
```
외부 앱에서 OAuth 토큰으로 콜아웃해 org 데이터 획득.
