---
tags: [Domain, Enhanced-Domains, My-Domain, URL, Security, Experience-Cloud, Cookies]
source: external-knowledge
created: 2026-05-23
aliases: [Enhanced Domains, 향상된 도메인, My Domain 강화, 서드파티 쿠키 대응, Salesforce URL 변경]
---

# Enhanced Domains

> Winter '24부터 모든 Salesforce org에 강제 적용된 도메인 정책 — 모든 URL에 My Domain 이름이 포함되어 서드파티 쿠키 차단 브라우저를 지원한다

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.
> 공식 문서: https://help.salesforce.com/s/articleView?id=sf.domain_name_enhanced.htm

---

## 개념 설명

Enhanced Domains는 **모든 Salesforce 서비스 URL에 My Domain 이름을 포함**시키는 도메인 정책이다. 기존에는 일부 URL(Visualforce, Experience Cloud 등)에 My Domain이 반영되지 않았으나, Enhanced Domains 활성화 후에는 모든 URL 형식이 변경된다.

### 배경

- 주요 브라우저(Chrome, Safari, Firefox)의 **서드파티 쿠키 차단** 정책 대응
- Enhanced Domains 없이는 Salesforce의 일부 기능이 서드파티 쿠키에 의존해 동작하지 않을 수 있음
- **Winter '24(2023년 10월)부터 모든 org에 강제 적용**

---

## URL 형식 변경

### 변경 전 / 변경 후 비교

| URL 유형 | 기존 형식 | Enhanced Domains 형식 |
|---|---|---|
| **Org URL** | `mycompany.my.salesforce.com` | 동일 (변경 없음) |
| **Visualforce** | `mycompany.visualforce.com` | `mycompany.vf.force.com` → `mycompany--namespace.vf.force.com` |
| **Experience Cloud 사이트** | `mycompany.my.site.com` | `mycompany.my.site.com` (My Domain 포함) |
| **Lightning 도메인** | `mycompany.lightning.force.com` | `mycompany.lightning.force.com` |
| **Content 도메인** | `mycompany.file.force.com` | `mycompany.file.force.com` |
| **Sandbox** | `mycompany--sandboxname.sandbox.my.salesforce.com` | 동일 (이미 포함) |

### 서브도메인 패턴

```
# 표준 형식
<myDomainName>.<instance>.salesforce.com

# Visualforce (Enhanced Domains)
<myDomainName>--<namespace>.vf.force.com

# Experience Cloud (Enhanced Domains)  
<myDomainName>.my.site.com/<sitePath>
```

---

## 적용 영향 및 점검 항목

### 반드시 업데이트해야 하는 항목

```
1. 하드코딩된 URL
   - Apex 코드에서 URL 문자열로 domain을 명시한 경우
   - 커스텀 메타데이터, 커스텀 설정의 URL 값
   - Email Template의 링크

2. Connected App / External App 콜백 URL
   - OAuth Callback URL 목록에 새 도메인 추가 필요

3. CORS 허용 목록 (Remote Site Settings, CORS)
   - 새 Visualforce/Experience Cloud URL을 허용 목록에 추가

4. Hardcoded Visualforce URL
   - 이메일, S-Control, 외부 시스템의 VF 페이지 링크

5. CSP (Content Security Policy) Trusted Site
   - 임베디드 iFrame, 외부 자원 로드 설정 재검토
```

---

## Sandbox에서 테스트

Winter '24부터 Sandbox org에서 Experience Cloud CDN 비활성화를 직접 테스트 가능. 기존에는 지원팀에 요청해야 했다.

```bash
# Sandbox에서 Enhanced Domains 확인
# Setup > My Domain > Enhanced Domain 상태 확인

# CLI로 도메인 정보 조회
sf org display --target-org sandbox@mycompany.com
```

---

## Apex에서 올바른 URL 생성 방법

Enhanced Domains 적용 후 Apex에서 URL을 하드코딩하는 것은 위험하다. 아래 방법을 사용한다.

```apex
// ❌ 하드코딩 금지
String badUrl = 'https://mycompany.visualforce.com/apex/MyPage';

// ✅ 올바른 방법 — 동적 URL 생성
// 현재 org 기본 URL
String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();

// Org 도메인 URL (Enhanced Domains에서 권장)
String orgUrl = URL.getOrgDomainUrl().toExternalForm();
// 결과 예: https://mycompany.my.salesforce.com

// Visualforce 페이지 URL 동적 생성 (ApexPages 활용)
// PageReference를 통해 현재 도메인 기준 생성
PageReference ref = Page.MyVFPage;
String vfUrl = ref.getUrl();
```

---

## 설정 절차

### 활성화 (이미 Winter '24에 강제 적용됨)

```
1. Setup > My Domain > Enhanced Domains 섹션
2. 'Deploy Enhanced Domains' 버튼 클릭 (아직 활성화하지 않은 경우)
3. URL 변경 사항 확인 및 영향 받는 기능 점검
4. 사용자에게 캐시 삭제 및 새 URL 사용 안내
```

### 영향 진단 도구

```
Setup > My Domain > Enhanced Domains > Impact Check
- 영향 받는 Visualforce 페이지 목록
- 영향 받는 Experience Cloud 사이트 목록
- 변경이 필요한 Connected App 목록
```

---

## 비교표 (도입 전/후 영향)

| 항목 | 도입 전 | 도입 후 |
|---|---|---|
| 서드파티 쿠키 의존 | 있음 | 없음 (퍼스트파티 도메인) |
| Cross-origin 로그인 | 가능 | 제한됨 |
| Experience Cloud CDN | 별도 도메인 | My Domain 기반 |
| Visualforce URL | 별도 서브도메인 | My Domain 기반 |
| 브라우저 호환성 | 일부 문제 | 향상됨 |

---

## 관련 노트
- [[Salesforce 플랫폼 개요]]
- [[CSP와 RemoteSite]]
- [[Site Namespace]]
