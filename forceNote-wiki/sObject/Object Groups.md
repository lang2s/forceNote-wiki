---
tags: [sobject-reference, object-groups, object-behavior, common-objects, high-scale-objects, data-cloud, external-data]
source: object_reference.pdf p.40-44 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Object Groups, Salesforce Object Groups, Common Objects, Cloud Objects, High-Scale Objects, External Data Objects, Object 그룹, 오브젝트 그룹]
---

# Object Groups — Salesforce Object 그룹 분류

> 데이터 저장 위치·트랜잭션 유형·라이센스 요건에 따라 Salesforce Object를 4개 그룹으로 분류한다.

---

## Object 선택 기준

저장할 데이터의 특성으로 Object 타입을 결정한다.

| 기준 | 판단 질문 |
|---|---|
| **Structure (구조)** | 계층형·표 형식·비정형? |
| **Volume (볼륨)** | 대용량(수억 건)인가? |
| **Size (크기)** | 레코드 최대 크기는? |
| **Storage (보존 기간)** | 단기·장기 보관? |
| **Transaction (트랜잭션)** | ACID·OLAP·OLTP? |
| **Operation (작업)** | Create·Read·Update·Delete? |
| **Latency (레이턴시)** | 얼마나 자주 업데이트? |

---

## 데이터 흐름별 Object 분류

### Objects by Data Flow (데이터 흐름)

데이터는 다양한 소스에서 Salesforce로 유입된다. Data Cloud 추가 이후 같은 데이터를 다른 타입의 Object들이 공유하는 흐름도 생겼다.

예시 흐름: Sales Org에 Account 데이터 입력 → CRM Connector로 Data Cloud에 수집 → 외부 시스템도 Data Cloud에 연결해 DLO로 저장 → 공통 DMO 스키마로 매핑 → Unified DMO로 통합

### Objects by Data Domain (데이터 도메인)

| 도메인 | 저장 위치 | 특징 |
|---|---|---|
| **CRM Objects** | 각 Org | 라이센스가 있는 한 모든 Org에 존재. 표준·커스텀·인터페이스 Object 포함 |
| **Big Objects** | 별도 분산 DB | 라이센스나 Managed Package 필요. 모든 Org에서 접근 가능 |
| **Data Cloud Objects** | Data Cloud | Data Kit으로 패키징 |
| **External Objects** | 외부 서드파티 시스템 | Salesforce Org에 표현만 됨 |
| **Zero Copy Objects** | Zero Copy 파트너 시스템 | 별도 수집 없이 Data Cloud Object처럼 쿼리 가능 |

### Objects by Transaction Type (트랜잭션 유형)

외부 저장 데이터는 트랜잭션 유형 보장 불가. Object별 기본 분류:

| 트랜잭션 유형 | 대상 Object |
|---|---|
| **ACID** | 표준 Object, 커스텀 Object, Entity Interface, Custom External Objects |
| **OLTP** | 표준 Big Objects, Custom Big Objects |
| **OLAP** | Data Cloud Objects |

---

## Object Groups 4개

Object는 데이터 저장 위치·용도·라이센스 요건에 따라 4개 그룹으로 분류된다.

| 그룹 | 설명 | 라이센스 |
|---|---|---|
| **Salesforce Common Objects** | 모든 Org에서 사용 가능한 표준·커스텀 Object | 기본 포함 |
| **Salesforce Cloud Objects** | 특정 Cloud에서만 사용 가능 | Cloud별 라이센스 |
| **Salesforce High-Scale Objects** | 대용량 트랜잭션·장기 보관용 | 추가 구매 필요 |
| **Salesforce External Data Objects** | Salesforce 외부에 저장된 데이터 접근 | 별도 설정 |

---

## Salesforce Common Objects

Common Objects는 모든 표준 Org에서 특별 라이센스 없이 사용 가능하다.

- 최적화 대상: **ACID 트랜잭션**
- Object 타입: Original, Base, Setup
- DB Storage: 수백만 건까지 스케일하는 관계형·트랜잭션 DB
- 레퍼런스: Object Reference for the Salesforce Platform

### Original Platform Objects (Hero/Legacy Objects)

가장 오래된 Salesforce Object 계열. Hero Objects 또는 Legacy Objects라고도 불린다.

| 속성 | 내용 |
|---|---|
| **대표 Object** | Account, Contact, Lead, Opportunity |
| **Customizable** | Yes |
| **Cloud** | Common — org를 사용하는 모든 Cloud에서 사용 가능 |
| **Packaging** | Data Kit 제외 모든 패키징 형태 가능. Metadata Coverage Report 참조 |
| **Documentation** | Apex Developer Guide, Salesforce DX Developer Guide |
| **Reference** | Object Reference for the Salesforce Platform |

### Base Platform Objects (BPO)

대부분의 Salesforce Org에 공통으로 존재하는 데이터 저장용 Object.

| 속성 | 내용 |
|---|---|
| **Object Examples** | SocialPersona |
| **Customizable** | Yes |
| **Cloud** | Common — org를 사용하는 모든 Cloud에서 사용 가능 |
| **Packaging** | Data Kit 제외 모든 패키징 형태 가능 |

### Setup Platform Objects (SPO)

대부분의 Salesforce Org에 공통으로 존재하는 Setup 설정 정보 저장용 Object. Org Setup으로 생성되는 플랫폼 데이터를 저장한다.

| 속성 | 내용 |
|---|---|
| **Object Examples** | CompactLayout, CustomField |
| **Customizable** | Yes |
| **Cloud** | Common — org를 사용하는 모든 Cloud에서 사용 가능 |
| **Packaging** | Cloud·제품·기능에 따라 다름 |

### Custom Objects

사용자가 스키마를 직접 정의하는 Object.

| 속성 | 내용 |
|---|---|
| **Transaction type** | ACID |
| **Object type(s)** | 모두 사용자 정의이므로 서브타입 없음 |
| **Object suffix** | `__c` |
| **Customizable** | N/A (직접 정의) |
| **Cloud** | Common |
| **Packaging** | Object에 따라 다름 |
| **Documentation** | Manage Custom Objects in Salesforce Help |

---

## Salesforce Cloud Objects

Cloud Objects는 특정 Cloud에서만 사용되는 Object다. 표준 Common Object와 다른 제한사항·API·쿼리 동작을 가질 수 있다.

특별 라이센스나 구매가 필요한 Object는 Object Reference 페이지의 special-access 섹션에 요건이 표시된다. 대부분은 해당 Cloud의 Implementation Guide에 문서화되어 있고 Object Reference에는 없다.

---

## Salesforce High-Scale Objects

대용량 트랜잭션, 대형 Object, 또는 장기 데이터 보관이 필요할 때 사용. Common Object와 다른 제한사항·API·쿼리 동작을 가질 수 있다.

### Big Objects

| 속성 | 내용 |
|---|---|
| **Usage** | Auditing·추적·피드·히스토리 아카이브 |
| **Transaction Type** | OLTP |
| **Database Storage** | 비트랜잭션, 수평 확장 분산 DB. 수억~수십억 건 가능. Data Cloud나 표준 Object보다 큰 데이터 지원 |
| **Object Type** | BO |
| **Object Suffix** | `__b` |
| **Customizable** | Yes |
| **Cloud** | org가 있는 모든 Cloud. 단, 추가 라이센스 필요 |
| **Packaging** | deploy()/retrieve()로 .zip 파일 배포. 표준 AppExchange 패키징 불가 |
| **Object Examples** | FieldHistoryArchive |
| **Documentation** | Big Objects Implementation Guide |
| **Reference** | Object Reference for the Salesforce Platform |

### High-Scale Order Objects

| 속성 | 내용 |
|---|---|
| **Optimized for** | OLTP 트랜잭션 |
| **Objects** | PendingOrderSummary |
| **Documentation** | Order Management Implementation Guide |
| **Reference** | Object Reference for the Salesforce Platform |

### Data Cloud Objects

| 속성 | 내용 |
|---|---|
| **Optimized for** | OLAP 트랜잭션 |
| **Object types** | DLO, DMO, CIO, DG |
| **Documentation** | Data Object Concepts and Schema in Data Cloud in Salesforce Help |

Data Cloud Objects는 대규모 데이터를 장기간 저장하는 High-Scale Object. 자세한 내용은 → [[Data Cloud Objects]]

---

## Salesforce External Data Objects

Salesforce 외부에 데이터를 저장하면서도 org 또는 Data Cloud에서 접근 가능.

### External Objects

Custom Object와 유사하지만 레코드 데이터가 org 외부에 저장됨. OData 및 기타 어댑터를 통해 접근.

### Zero Copy Objects

Snowflake·AWS 등 일부 외부 데이터 소스는 Data Cloud와 Deep Integration되어 데이터 동기화·수집 없이 직접 접근 가능. Data Cloud Object처럼 사용 가능.

---

## 코드 예시 — Object 타입별 쿼리 비교

```apex
// 구조 예시 — 실제 동작 코드 아님

// Common Object (SOQL — ACID 트랜잭션)
List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 100];

// Big Object (SOQL — OLTP, 비트랜잭션)
List<FieldHistoryArchive> history = [
    SELECT ParentId, FieldName, OldValue, NewValue
    FROM FieldHistoryArchive
    WHERE CreatedDate > 2020-01-01T00:00:00Z
    LIMIT 100
];
```

---

## 관련 노트

- [[2 Object Behavior]] — Object Behavior 챕터 개요
- [[Data Cloud Objects]] — DLO·DMO·CIO·DG·UDLO·UDMO 상세
- [[Object Types Reference]] — suffix 전수 표 및 Cheatsheet
- [[Big Objects]] — Big Object 구현 상세
- [[External Objects]] — External Object 연결 방법
- [[1 Overview]] — Field 타입·Primitive 타입 기초
