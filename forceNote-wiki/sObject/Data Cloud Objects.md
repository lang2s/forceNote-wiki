---
tags: [sobject-reference, data-cloud, dlo, dmo, cio, data-graph, udlo, udmo, unified-objects, zero-copy, object-behavior]
source: object_reference.pdf p.44-51 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Data Cloud Objects, DLO, DMO, CIO, Data Graph, DG, UDLO, UDMO, Unified Objects, Zero Copy, 데이터클라우드 오브젝트, 데이터레이크 오브젝트, 데이터모델 오브젝트]
---

# Data Cloud Objects — Data Cloud 오브젝트 타입 완전 가이드

> Data Cloud에서 대규모 데이터를 저장·처리하는 Object 타입 — DLO·DMO·CIO·DG·UDLO·UDMO·Unified Objects·Zero Copy 전체 정의 및 생성 흐름

---

## Data Cloud Objects 개요

Data Cloud Objects는 대규모 데이터를 장기간 저장하는 High-Scale Object다.

| 속성 | 내용 |
|---|---|
| **Optimized for** | OLAP 트랜잭션 |
| **Object types** | DLO, DMO, CIO, DG |
| **Documentation** | Data Object Concepts and Schema in Data Cloud in Salesforce Help |

---

## DMO Object 생성 흐름 (8단계)

Data Cloud Object는 수집된 데이터와 그 데이터에 대한 다양한 연산으로 생성된다.

```
1. 외부 시스템 데이터 → DLO (원본 스키마 그대로 저장, 수식 필드 지원)
2. DLO → DMO 스키마로 매핑 (C360 Data Model. DMO는 데이터를 직접 저장하지 않고 DLO 참조만 유지)
3. DLO·DMO → Data Cloud Data Prep/Transform으로 새 DLO·DMO 변환 (선택)
4. DMO → Identity Resolution으로 동일 타입 레코드 매칭·병합 → Unified DMO 생성
   (Unified DMO는 보통 먼저 생성하지만 선택 사항)
5. DMO 데이터 집계/계산 → CIO (Calculated Insight Object) 생성
6. DMO 일부 데이터 → Data Graph로 사용 (near real-time 고성능 처리)
7. Data Cloud 앱으로 DMO에 Search Index Object 설정 (DMO가 아니라 Chunk Content DMO·Vector Embedding DMO 생성에 사용)
8. Search Index Object → Chunk Content DMO + Vector Embedding DMO 자동 생성
```

---

## UDMO Object 생성 흐름 (4단계)

비정형 데이터(이미지·문서·음성 등)를 RAG/GenAI에 활용하는 흐름:

```
1. 비정형 데이터 → UDLO (Unstructured Data Lake Object, blob store에서 수집)
2. UDLO → C360 Data Model 비정형 스키마로 자동 매핑 → UDMO
3. UDMO와 DMO에 Search Index Object 설정 (RAG with Gen AI용)
4. (Search) Index DMO → Chunk Content DMO + Vector Embedding DMO 생성
```

---

## Zero Copy Object 생성 흐름

일부 외부 데이터 소스는 Data Cloud와 깊이 통합되어 데이터 동기화나 수집 없이 연결 가능:

```
외부 데이터 소스 공유 → External Object 정의
→ 앱·보고서에서 사용할 레이블명 등 추가 메타데이터 설정
→ Salesforce 기능·API에서 사용 가능
```

---

## Data Cloud Object 타입별 상세

### Calculated Insight Objects (CIO)

| 속성 | 내용 |
|---|---|
| **Usage** | DMO Object에서 집계·계산된 데이터를 담는 Object |
| **Object suffix** | `__cio` |
| **Customizable** | Yes (표준 CIO 없음, 모두 커스텀) |
| **Cloud** | Data Cloud |
| **Packaging** | Data kits |
| **Documentation** | Calculated Insights in Salesforce Help |
| **Reference** | N/A |

### Data Lake Objects (DLO)

| 속성 | 내용 |
|---|---|
| **Usage** | Data Cloud로 수집(ingest)된 데이터 저장 |
| **Object suffix** | `__dlo` |
| **Customizable** | Yes |
| **Cloud** | Data Cloud |
| **Packaging** | Data Kit으로 패키징 가능. 데이터 스트림(DLO 수집용)도 패키징 가능 |
| **Documentation** | Data Object Concepts and Schema in Data Cloud in Salesforce Help |
| **Reference** | 수집 소스 시스템의 레퍼런스 문서 참조 (스키마는 데이터 스트림 원본 유지) |

표준 DLO 외에 **비정형 DLO(UDLO)**와 **외부 DLO**도 있다.

### Data Model Objects (DMO)

| 속성 | 내용 |
|---|---|
| **Usage** | C360 Data Model로 데이터의 공통 표현 제공. DLO에 저장된 데이터를 DMO로 매핑. **DMO는 데이터를 직접 저장하지 않고 DLO 위치 정보만 보유.** Data Cloud API·기능은 DMO를 통해 DLO 데이터 접근 |
| **Object suffix** | `__dlm` |
| **필드 suffix** | 표준·커스텀 필드 모두 `__c` suffix 사용 |
| **Customizable** | Yes |
| **Cloud** | Data Cloud |
| **Packaging** | Data kits (권장). Managed/Unmanaged Package는 기본 데이터 스페이스의 Data Kit 패키징만 지원. CSV 파일을 통한 DMO import도 가능 |
| **Documentation** | Data Object Concepts and Schema in Data Cloud in Salesforce Help |
| **Reference** | 단일 레퍼런스 없음. 대부분의 Salesforce DMO는 Base Platform Objects·Original Platform Objects를 미러링(일부 데이터 타입 차이 있음). Standard Data Model Objects (DMOs) 섹션(Data Cloud Reference Guide) 참조. 특정 기능·Cloud용 추가 DMO는 Data Kit·Bundle 매핑 문서에서 확인 |

DMO 외에 **Unified DMO**와 **비정형 DMO(UDMO)**도 있다.

### Data Graphs (DG)

| 속성 | 내용 |
|---|---|
| **Usage** | 여러 DMO 데이터를 결합한 JSON blob으로 구성된 사전 계산된 Materialized View. 고성능 near real-time 쿼리 가속화. 앱의 실시간 운영에 사용 |
| **Object suffix** | `__dg` |
| **Customizable** | Yes (표준 Data Graph 없음, 모두 커스텀) |
| **Cloud** | Data Cloud |
| **Packaging** | Data kits. Data Graph는 Data Kit에 추가 가능하지만 직접 패키징은 불가 |
| **Documentation** | Data Graphs in Salesforce Help |
| **Reference** | N/A |

### Unified Objects (Unified DMO)

| 속성 | 내용 |
|---|---|
| **Usage** | Identity Resolution을 통해 여러 DMO 레코드를 병합한 골든 레코드. Data Graph와 마찬가지로 여러 DMO 구조를 결합한 JSON blob 기반 Materialized View로 고성능 쿼리 제공 |
| **Customizable** | Yes (표준 Unified Object 없음, 모두 커스텀) |
| **Cloud** | Data Cloud |
| **Packaging** | Data Kit으로 패키징 가능 |
| **Documentation** | Unify Source Profiles in Help |
| **Reference** | N/A |

### Unstructured Data Lake Objects (UDLO)

| 속성 | 내용 |
|---|---|
| **Usage** | Data Cloud의 비정형 데이터를 참조. UDLO는 수동으로 생성. 비정형 데이터는 blob store에서 수집 |
| **Object suffix** | `__dlo` |
| **Customizable** | Yes |
| **Cloud** | Data Cloud |
| **Packaging** | 패키징 불가. UDLO는 패키징되지 않음. 단, UDLO 수집용 연결(connection)은 패키징 가능 |
| **Documentation** | Unstructured Data Lake Objects in Salesforce Help |
| **Reference** | 표준 DLO·UDLO·외부 DLO 문서 참조 |

### Unstructured Data Model Objects (UDMO)

| 속성 | 내용 |
|---|---|
| **Usage** | 비정형 데이터 소스에서 생성된 데이터를 표현 |
| **Object suffix** | `__dlm` |
| **필드 suffix** | 표준·커스텀 필드 모두 `__c` suffix 사용 |
| **Customizable** | Yes |
| **Cloud** | Data Cloud |
| **Packaging** | Data kits (권장). CSV 파일을 통한 import도 가능 |
| **Documentation** | Data Object Concepts and Schema in Data Cloud in Salesforce Help |
| **Reference** | N/A |

---

## External Objects (외부 Object)

Custom Object와 유사하지만 레코드 데이터가 org 외부에 저장됨. OData 및 기타 어댑터를 통해 접근.

---

## Zero Copy Objects

Snowflake·AWS 등 일부 케이스에서 Salesforce가 외부 제품 데이터와 깊이 통합되어 있어, 데이터를 Data Cloud 외부에 저장하면서도 Data Cloud를 통해 접근 가능.

---

## Data Cloud Object 타입 요약 비교

| 타입 | API 접미사 | 데이터 저장 | 용도 | 패키징 |
|---|---|---|---|---|
| **DLO** (Data Lake Object) | `__dlo` | Yes (원본 스키마) | 수집 데이터 저장 | Data Kit |
| **DMO** (Data Model Object) | `__dlm` | No (DLO 참조) | C360 모델 기반 공통 표현 | Data Kit (권장) |
| **Unified DMO** | `__dlm` (추정) | No | Identity Resolution 골든 레코드 | Data Kit |
| **CIO** (Calculated Insight Object) | `__cio` | Yes (집계 결과) | DMO 집계·계산 | Data Kit |
| **DG** (Data Graph) | `__dg` | Yes (JSON blob) | near real-time 고성능 조회 | Data Kit (직접 패키징 불가) |
| **UDLO** (Unstructured DLO) | `__dlo` | Yes (blob store) | 비정형 데이터 저장 | 불가 |
| **UDMO** (Unstructured DMO) | `__dlm` | No | 비정형 데이터 모델 (RAG/GenAI) | Data Kit (권장) |
| **Zero Copy** | — | 외부 시스템 | 수집 없이 외부 소스 직접 접근 | N/A |

---

## 코드 예시 — Data Cloud Object 쿼리

```apex
// 구조 예시 — 실제 동작 코드 아님

// DMO 쿼리 (필드에 __c suffix 사용)
List<UnifiedAccount__dlm> accounts = [
    SELECT Id__c, Name__c, Email__c
    FROM UnifiedAccount__dlm
    LIMIT 100
];

// CIO 쿼리 (Calculated Insight Object)
List<CustomerLifetimeValue__cio> insights = [
    SELECT CustomerId__c, TotalRevenue__c, EngagementScore__c
    FROM CustomerLifetimeValue__cio
    WHERE TotalRevenue__c > 1000
    LIMIT 50
];

// DLO 쿼리 (Data Lake Object — 원본 스키마)
List<SalesforceAccount__dlo> lakeDocs = [
    SELECT Id__c, AccountName__c, Industry__c
    FROM SalesforceAccount__dlo
    LIMIT 100
];
```

---

## 관련 노트

- [[2 Object Behavior]] — Object Behavior 챕터 개요
- [[Object Groups]] — Object 그룹 분류 (Common·Cloud·High-Scale·External)
- [[Object Types Reference]] — suffix 전수 표 및 Cheatsheet
- [[Big Objects]] — Big Object 구현 상세 (OLTP 대용량 오브젝트)
- [[External Objects]] — External Object OData 연결 방법
- [[1 Overview]] — Field 타입·Primitive 타입 기초
