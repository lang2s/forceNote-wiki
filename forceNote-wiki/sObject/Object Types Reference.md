---
tags: [sobject-reference, object-types, object-suffix, object-cheatsheet, object-behavior]
source: object_reference.pdf p.51-54 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Object Types Reference, Object Suffix, Object Cheatsheet, 오브젝트 타입, 오브젝트 접미어, 오브젝트 치트시트, suffix 표]
---

# Object Types Reference — Suffix 전수 표 및 Cheatsheet

> Salesforce Platform의 모든 Object 타입을 API suffix로 식별하는 전체 표 + 타입별 비교 Cheatsheet

---

## Salesforce Object Types 개요

Salesforce Platform에서 Object 타입은 원래 표준(standard)·커스텀(custom) 구분에 사용되었다. 플랫폼 진화에 따라 현재는 더 많은 타입이 존재한다.

이 표의 Object들은 Salesforce에서 식별·접근되는 방식으로 그룹화되어 있다. Org나 API를 통해 보이는 Object는 내부 목적 Object도 포함한다.

### Object 타입 식별 방법

- Developer API Name의 suffix로 Object 타입을 식별한다
- Object Manager에서 suffix와 Object 타입을 확인할 수 있다
- **Data Cloud Object**: 여러 타입이 같은 suffix를 공유한다. 타입 구분은 Data Cloud Data Explorer에서 Object 타입 필터로 확인

### Object 접근 권한

접근 가능 여부는 다음으로 결정된다:
- 라이센스된 제품·기능
- 관련 사용자 및 Object 권한
- 일부 기능은 여러 Cloud의 권한이 모두 필요 (예: Sales Cloud org + Data Cloud 권한 → Data Cloud-powered Sales Cloud 기능)
- Org 보안 모델과 Data Cloud 보안 모델은 다름 (Object 저장 방식이 다르기 때문)

---

## Object Types 전수 표 (28개 suffix)

| Suffix | Object 타입 | Object 그룹 |
|---|---|---|
| `__b` | Big object | High Scale |
| `__c` | Custom object | Common |
| `__ChangeEvent` | Custom Object Change Event | Common |
| `__chn` | PlatformEventChannel | Common |
| `__cio` | Calculated insight object | High Scale |
| `__dg` | Data graph | High Scale |
| `__DataCategorySelection` | Knowledge__DataCategorySelection | Common |
| `__dlm` | Data Model Object (DMO — 쿼리용 확장자) | High Scale |
| `__dlo` | Data Lake Object | High Scale |
| `__dmo` | Data Model Object | High Scale |
| `__dso` | Data source object | High Scale |
| `__e` | Platform event | Common |
| `__Feed` | Knowledge article feed 또는 custom object feed | Common |
| `__hd` | Historical data | Common |
| `__History` | Field History Tracking (custom objects) | Common |
| `_hst` | 커스텀 보고서 유형의 historical 필드 | Common |
| `__ka` | Knowledge article | Common |
| `__kav` | Knowledge article version | Common |
| `__latitude__s` | Geolocation custom field (위도 좌표) | Common |
| `__longitude__s` | Geolocation custom field (경도 좌표) | Common |
| `__mdt` | Custom metadata type | Common |
| `__pc` | Custom person account field | Common |
| `__pr` | Person account relationship field | Common |
| `__r` | SOQL 관계 탐색 custom relationship field | Common |
| `__Share` | Custom object sharing object | Common |
| `__Tag` | Salesforce tags | Common |
| `__ViewStat` | KnowledgeArticleViewStat | Common |
| `__VoteStat` | KnowledgeArticleVoteStat | Common |
| `__x` | External object | Common |
| `__xo` | Salesforce-to-Salesforce (S2S) spoke/proxy object | Common |
| `ChangeEvent` | Standard object change event | Common |
| `Feed` | Standard object feed | Common |

---

## Object Cheatsheet

### Object Groups 요약

| 그룹 | 용도 | 최적화 | 스토리지 |
|---|---|---|---|
| **Common Objects** | 모든 표준 Org에서 사용 가능한 데이터 저장 | ACID 트랜잭션 | 수백만 건까지 스케일하는 관계형·트랜잭션 DB |
| **High-Scale Objects** | 대용량 트랜잭션·장기 데이터 보관 | OLTP·OLAP | 분산 DB (Big) / Data Cloud (DLO·DMO 등) |
| **External Objects** | Salesforce 외부에 저장된 데이터 표현 | — | 외부 시스템 |

### Object Types Cheatsheet (전체 비교)

| Object 타입 | 그룹 | 설명 | Customizable | Cloud | Packaging | Documentation | Reference |
|---|---|---|---|---|---|---|---|
| **Base Platform Objects** | Common | 대부분의 Org에 공통인 데이터 저장용 Object | Yes | Common | Data Kit 제외 모든 형태 | DX and Developer Tools | Object Reference for the Platform |
| **Big Objects** | High-Scale | 대용량 트랜잭션·장기 데이터 보관 | Yes | org 제공 Cloud (추가 라이센스) | deploy/retrieve .zip (AppExchange 불가) | Big Objects Implementation Guide | Object Reference for the Platform |
| **Calculated Insight Objects (CIO)** | High-Scale | DMO에서 집계·계산된 데이터 | Yes | Data Cloud | Data kits | Calculated Insights in Help | N/A |
| **Custom Objects** | Common | 사용자 정의 Object | N/A | Common | Object에 따라 다름 | Create a Custom Object in Help | N/A |
| **Data Graphs (DG)** | High-Scale | 고속 쿼리용 Materialized View (JSON blob) | Yes | Data Cloud | Data kits | Create a Data Graph in Help | N/A |
| **Data Lake Objects (DLO)** | High-Scale | Data Cloud로 수집된 데이터 저장 | Yes | Data Cloud | DLO·데이터 스트림 Data Kit 패키징 가능 | Data Objects in Data Cloud in Help | N/A |
| **Data Model Objects (DMO)** | High-Scale | C360 Data Model 기반 공통 데이터 표현 | Yes | Data Cloud | Data kits (권장) | Data Objects in Data Cloud in Help | Data Cloud Reference Guide |
| **External Objects** | External | Salesforce 외부 저장 데이터 표현 | N/A | N/A | N/A | N/A | 데이터 저장 시스템 레퍼런스 |
| **High-Scale Order Objects** | High-Scale | OLTP 최적화 주문 Object | N/A | N/A | N/A | Order Management Implementation Guides in Help | Object Reference for the Platform |
| **Setup Platform Objects** | Common | Setup 설정 정보 저장용 Object | Yes | Common | Cloud·제품·기능에 따라 다름 | DX and Developer Tools | N/A |
| **Unified Objects** | High-Scale | Identity Resolution으로 생성된 골든 레코드 | Yes | Data Cloud | Data kits | Unify Source Profiles in Help | N/A |
| **Unstructured Data Lake Objects (UDLO)** | High-Scale | Data Cloud 비정형 데이터 참조. 수동 생성 | Yes | Data Cloud | 불가 (수집용 connection은 패키징 가능) | Unstructured Data Lake Objects in Help | N/A |
| **Unstructured Data Model Objects (UDMO)** | High-Scale | 비정형 데이터 소스 데이터 표현 | Yes | Data Cloud | Data kits (권장) | Data Objects in Data Cloud in Help | N/A |
| **Zero Copy Objects** | External | 외부 데이터 소스와 Deep Integration (데이터 동기화 불필요) | N/A | N/A | N/A | N/A | Object Reference for the Platform |

---

## 코드 예시 — Object API Name으로 타입 판별

```apex
// 구조 예시 — 실제 동작 코드 아님

// Object suffix로 타입 판별 예시
String apiName = 'CustomerEngagement__dlm'; // → DMO
// String apiName = 'SalesData__dlo';       // → DLO
// String apiName = 'Revenue__cio';         // → CIO
// String apiName = 'AccountProfile__dg';   // → Data Graph

// DescribeSObjectResult로 Object 정보 조회
Schema.DescribeSObjectResult descResult = Schema.describeSObjects(
    new List<String>{ apiName }
)[0];
System.debug('Object Type: ' + descResult.getName());
System.debug('Queryable: ' + descResult.isQueryable());
System.debug('Createable: ' + descResult.isCreateable());

// 예: __b (Big Object) — Insert·Query만 지원
// Messaging.MassEmailMessage 같은 일부 Object는 CRUD 제한
```

---

## 관련 노트

- [[2 Object Behavior]] — Object Behavior 챕터 개요
- [[Object Groups]] — Object 그룹 분류 기준
- [[Data Cloud Objects]] — DLO·DMO·CIO·DG·UDLO·UDMO 상세
- [[Big Objects]] — Big Object 구현 및 쿼리 방법
- [[External Objects]] — External Object OData 연결 방법
- [[Custom Objects]] — __c 커스텀 Object 생성 규칙
- [[System Fields]] — OwnerId·CreatedDate 등 공통 시스템 필드
