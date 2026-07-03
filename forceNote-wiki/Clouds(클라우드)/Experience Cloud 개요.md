---
tags: [experience-cloud, sites, communities, digital-experience, overview]
source: help.salesforce.com (Salesforce Help — What Is Experience Cloud?; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=experience.exp_cloud_basics_what.htm&type=5
created: 2026-07-03
aliases: [Experience Cloud, 익스피리언스 클라우드, Community Cloud, 커뮤니티, Experience Builder, Salesforce CMS, Digital Experience]
---

# Experience Cloud 개요

> 고객·파트너용 디지털 경험(사이트·포털·커뮤니티·웹앱)을 만드는 플랫폼. Experience Builder·Salesforce CMS·Mobile Publisher로 no-code~pro-code 사이트를 구축한다. (구 Community Cloud.)

---

## 정의

**Experience Cloud**는 고객·파트너가 **디지털 경험 플랫폼(digital experience platform)** 을 만들 수 있게 해주는 Salesforce 제품이다. 이 플랫폼으로 다음과 같은 다양한 디지털 경험을 구축한다.

- Marketing / corporate 사이트
- Partner portal (파트너 포털)
- Support forum (지원 포럼)
- Web application (웹 애플리케이션)

과거 명칭은 **Community Cloud**이며, "커뮤니티"라는 표현으로도 불린다.

## 구축 도구

여러 도구가 결합되어 커스텀 사이트를 만든다.

| 도구 | 역할 |
|---|---|
| **Experience Builder** | 사이트/페이지를 시각적으로 구성하는 빌더 |
| **Salesforce CMS** | 콘텐츠 관리 시스템 |
| **Mobile Publisher** | 모바일 앱으로 경험을 게시 |
| 웹앱 스위트(web application suite) | 웹 애플리케이션 구축 |

## 사이트 템플릿 (예)

Experience Cloud는 prebuilt 템플릿을 제공한다. 대표 예시는 다음과 같다.

### Customer Account Portal
고객이 **계정 정보를 보고 업데이트**하는 **비공개·보안(private, secure)** 공간이다. 주요 용도:

- Invoice(청구서) 조회 및 결제
- 계정(account) 정보 업데이트
- Knowledge base 검색

### Help Center
**Knowledge base 문서를 노출**하는 **공개(public) 셀프서비스 커뮤니티**다.

- 사용자가 스스로 답을 찾도록 지원(self-service)
- 지원팀(support team)의 부하를 감소

> 위 두 템플릿은 대표 예시이며, 그 외 템플릿(`…`)도 제공된다.

## 구축 유연성 (no-code → pro-code)

Experience Cloud는 코딩 역량에 관계없이 사이트를 만들 수 있도록 여러 수준의 도구를 제공한다.

```
// 구조 예시 — Experience Cloud(실제 원본 다이어그램 아님)
디지털 경험(사이트/포털/커뮤니티/웹앱)
  도구: Experience Builder · Salesforce CMS · Mobile Publisher
  템플릿: Customer Account Portal · Help Center · …
  구축: no-code(클릭) → low-code(컴포넌트) → pro-code(CLI·Apex/LWC)
```

- **no-code:** point-and-click 도구 + prebuilt 템플릿
- **low-code:** 커스텀 컴포넌트(custom component)
- **pro-code:** 프로그래밍 방식 개발, Salesforce CLI 등

> 이 노트는 Experience Cloud의 **개요**다. 개별 도구·템플릿·컴포넌트의 세부 구성은 [공식 문서](https://help.salesforce.com/s/articleView?id=experience.exp_cloud_basics_what.htm&type=5)를 참조한다.

## 관련 노트
- [[Salesforce 제품 클라우드 개요]] — 전체 클라우드 지도 허브
