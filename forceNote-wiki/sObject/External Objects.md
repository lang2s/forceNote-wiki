---
title: External Objects
tags: [salesforce, sobject, external-objects, salesforce-connect, odata]
source: object_reference.pdf v67.0 — Ch1 pp.29–31 (물리 pp.71–73) · [Tier 2] help.salesforce.com platform_connect_license (Salesforce Connect Adapters Included per Add-On License)
created: 2026-05-22
aliases: [External Object, __x suffix, Salesforce Connect, OData, External Lookup, 외부 오브젝트]
---

# External Objects

## 개요

외부 오브젝트는 **Salesforce 조직 외부에 저장된 데이터**에 접근하는 오브젝트.  
API v32.0 이상에서 지원.

커스텀 오브젝트와 유사하지만 레코드 데이터가 외부 시스템(예: ERP, 레거시 DB)에 저장된다.  
Salesforce Connect나 Files Connect를 통해 웹 서비스 콜아웃으로 **실시간** 접근한다.

> 데이터 복사본을 Salesforce에 유지하지 않아도 되므로 저장 공간과 동기화 비용 절약.

**적합한 상황:**
- 대용량 데이터를 Salesforce에 저장하기 어렵거나 원하지 않을 때
- 한 번에 소량의 데이터만 사용하면 될 때

---

## ⚠️ 전제조건 — Salesforce Connect 라이선스

External Object를 만들려면 **먼저 Salesforce Connect add-on을 확보·설정**해야 한다. Salesforce Connect는 기본 포함 기능이 아니라 **별도 유료 add-on 라이선스**다.

- **한 라이선스 = 하나의 외부 데이터 소스(엔드포인트)에 대응.** 여러 외부 시스템에 연결하려면 그만큼의 add-on 라이선스가 필요하다.
- 라이선스가 없는 org에서는 **External Data Source 생성 자체가 막힌다** → External Object도 만들 수 없다.
- 어떤 어댑터(Cross-org / OData 2.0 / OData 4.0 / Custom Apex)가 add-on 라이선스에 포함되는지는 라이선스 종류에 따라 다르다 (근거: help.salesforce.com — *Salesforce Connect Adapters Included per Add-On License*).

> Files Connect(Google Drive·Box·SharePoint 등) 기반 외부 오브젝트도 마찬가지로 Files Connect 활성화가 선행되어야 한다.

---

## 아키텍처

```
외부 시스템 (ERP, 레거시 DB 등)
        ↕ (외부 데이터 소스 정의)
Salesforce Connect / Files Connect
        ↕
외부 데이터 소스 (External Data Source)
        ↕
외부 오브젝트 (External Object __x)
        ↕
사용자 / Lightning Platform
```

각 외부 오브젝트는 Salesforce 조직 내의 **외부 데이터 소스 정의**와 연결된다.  
외부 데이터 소스는 외부 시스템에 접근하는 방법을 지정한다.

---

## 네이밍 컨벤션

- API 이름: 두 언더스코어 + 소문자 `x` 접미사 `__x`
  - 예: `ExtraLogInfo` → `ExtraLogInfo__x`
- 오브젝트 이름은 **표준·커스텀·외부 오브젝트 모두 통틀어 고유**해야 한다.
- 오브젝트 레이블도 고유하게 권장.

---

## 외부 오브젝트 관계 타입

외부 오브젝트는 3가지 관계만 지원 (다른 관계 타입 불가):

| 관계 타입 | 설명 |
|---|---|
| **Standard Lookup** | 18자리 Salesforce 레코드 ID 기반 연결 |
| **External Lookup** | 외부 데이터에 Salesforce ID가 없을 때 사용 — 외부 ID로 연결 |
| **Indirect Lookup** | 외부 오브젝트를 Salesforce 오브젝트의 External ID 필드로 연결 |

> 외부 시스템에는 18자리 Salesforce 레코드 ID가 없는 경우가 많으므로, External Lookup과 Indirect Lookup이 별도 지원된다.

---

## Salesforce Connect 어댑터

Salesforce Connect는 프로토콜별 어댑터로 외부 시스템에 연결한다:

| 어댑터 | 설명 | 사용 케이스 |
|---|---|---|
| **Cross-org** | Lightning Platform REST API로 다른 Salesforce org 데이터 접근 | 여러 Salesforce org 간 데이터 통합 |
| **OData 2.0** | OData 2.0 프로토콜로 외부 시스템 접근 | SAP, Microsoft, Oracle 등 OData 지원 레거시 시스템 |
| **OData 4.0** | OData 4.0 프로토콜로 외부 시스템 접근 | 최신 OData 기반 외부 시스템 |
| **Custom (Apex)** | Apex Connector Framework으로 개발한 커스텀 어댑터 | REST API 콜아웃 등 다른 어댑터로 불가한 상황 |

---

## Files Connect 어댑터

Files Connect는 서드파티 콘텐츠 시스템에 접근한다:

- Google Drive
- Box
- SharePoint Online
- OneDrive for Business

---

## 제약사항

- 외부 오브젝트 레코드 데이터는 **항상 실시간으로 외부 시스템에서 조회** — 항상 최신 상태 반영
- Salesforce Connect와 Files Connect를 통해서만 사용 가능 (Salesforce Connect는 **유료 add-on 라이선스** — 위 "⚠️ 전제조건" 참조)
- 관계 타입: Lookup, External Lookup, Indirect Lookup만 지원

---

## 관련 노트

- [[1 Overview]] — Chapter 1 전체 구조 요약
- [[Object Relationships]] — External Lookup·Indirect Lookup 관계 타입 상세
- [[Custom Objects]] — 외부 오브젝트와 커스텀 오브젝트 비교
- [[Big Objects]] — 대용량 데이터 처리를 위한 또 다른 옵션
- [[Object Groups]] — External Data Objects 그룹 분류
- [[Object Types Reference]] — __x suffix 및 Zero Copy Objects Cheatsheet
