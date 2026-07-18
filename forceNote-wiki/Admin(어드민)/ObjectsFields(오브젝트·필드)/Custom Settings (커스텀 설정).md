---
tags: [admin, customization, custom-settings, list-custom-setting, hierarchy-custom-setting]
source: help.salesforce.com (Salesforce Help — Create Custom Settings; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.cs_about.htm&type=5
created: 2026-07-03
aliases: [Custom Settings, 커스텀 설정, List Custom Setting, Hierarchy Custom Setting, 커스텀 세팅]
---

# Custom Settings (커스텀 설정)

> SOQL 없이 앱 캐시에서 접근하는 커스텀 구성 데이터. **List**(정적 org 데이터)와 **Hierarchy**(org<profile<user 우선순위로 사용자별 다른 값) 두 유형이 있다.

---

## 개념

Custom setting은 **커스텀 오브젝트와 유사한 데이터**를 다루되, 그 데이터를 **애플리케이션 캐시에서 SOQL 쿼리 없이 접근**하게 해준다. 쿼리를 거치지 않으므로 빠르고 효율적인 접근이 가능하다.

용도는 formula field, validation rule, flow, Apex 등 여러 곳에서 **반복적으로 참조하는 재사용 구성 데이터**를 저장하는 것이다. 예를 들어 국가 코드·매핑값·기능 토글 같은 값을 한 곳에 모아두고 여러 자동화·로직에서 끌어 쓴다.

---

## 두 가지 유형

### List Custom Setting

조직 전역의 **정적(static) 데이터**를 담는다. 예를 들어 국가 코드나 우편번호·매핑 테이블처럼 자주 바뀌지 않고 **모든 사용자에게 동일**한 값이다. 사용자·프로파일에 따라 값이 달라지지 않는다.

### Hierarchy Custom Setting

**org < profile < user** 계층 우선순위로 값을 결정한다. 더 낮은(= 더 구체적인) 수준에 설정된 값이 상위 수준의 값을 **이긴다(override)**.

- org 수준: 기본값(default) 역할
- profile 수준: 특정 프로파일에 대한 값
- user 수준: 특정 사용자에 대한 값 — 가장 우선

이 계층 덕분에 사용자·프로파일별로 동작을 **개인화**할 수 있다. 어떤 사용자에게는 org 기본값이, 다른 사용자에게는 프로파일/사용자 수준에서 재정의된 값이 적용된다.

```
// 구조 예시 — Custom Settings(실제 원본 다이어그램 아님)
List Custom Setting: 정적 org 전역 데이터(모두 동일)
Hierarchy Custom Setting: org < profile < user (낮은 수준이 우선)
접근: 앱 캐시(SOQL 불필요) — formula·validation·flow·Apex에서 참조
```

---

## 생성 방법

1. **Setup → Quick Find**에서 `Custom Settings` 검색
2. **Custom Settings** 선택
3. **New** — 유형(List / Hierarchy)과 오브젝트 정의를 지정
4. **Manage**로 데이터(레코드/필드 값) 입력

---

## Custom Metadata Types와의 구분

Custom setting은 **데이터**를 저장한다 — 조직 안에서 관리하며 그 자체는 패키지·배포 대상이 아니다. 반면 유사하게 구성값을 담는 **Custom Metadata Types**는 **메타데이터**로 취급되어 **배포·패키지가 가능**하다.

> 배포·패키지 가능한 구성 데이터가 필요하면 [[Custom Metadata Types]] 참조.

---

## 관련 노트
- [[Custom Metadata Types]] — 유사한 config 저장이나 배포·패키지 가능(Custom Settings는 데이터, Custom Metadata는 메타데이터/배포). 구분용 링크.
- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] — custom setting은 커스텀 오브젝트형 데이터.
- [[Custom Labels (커스텀 레이블)]] — 또 다른 커스텀 구성(데이터 구성 vs 텍스트 구성).
