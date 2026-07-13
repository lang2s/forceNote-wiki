---
title: External Objects
tags: [salesforce, sobject, external-objects, salesforce-connect, odata]
source: object_reference.pdf v67.0 — Ch1 pp.29–31 (물리 pp.71–73) · [Tier 2] help.salesforce.com platform_connect_license (Salesforce Connect Adapters Included per Add-On License) · [Tier 2] help.salesforce.com odata_adapter_about / platform_connect_add_external_data_source / rn_forcecom_general_odata_tracer · [Tier 2] help.salesforce.com analytics.rd_reports_dashboards_limits (External Object Report Limits — primary object fetch 최대 20,000 records) + platform.platform_connect_general_limits (server-driven paging 최대 페이지 2,000행) · architect.salesforce.com Data Integration Decision Guide
created: 2026-05-22
aliases: [External Object, __x suffix, Salesforce Connect, OData, External Data Source, OData Tracer, High Data Volume, Named Principal, 외부 오브젝트, 외부 데이터 소스, 데이터 복제 비교, 데이터 페더레이션]
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

## Salesforce Connect(External Objects) vs 데이터 복제(replication) — 결정표

같은 외부 데이터라도 **실시간 페더레이션(External Objects)** 으로 가져올지, **Salesforce로 복제(ETL·미들웨어·Change Event 등으로 표준/커스텀 오브젝트에 저장)** 할지는 접근 패턴에 따라 갈린다. Salesforce의 [Data Integration Decision Guide](https://architect.salesforce.com/docs/architect/decision-guides/guide/data-integration.html)는 "데이터를 **볼** 것인가, **가지고 작업**할 것인가"를 1차 판단 기준으로 제시한다.

| 판단 기준 | Salesforce Connect · External Objects (실시간 페더레이션) | 데이터 복제 (표준/커스텀 오브젝트에 저장) |
|---|---|---|
| **데이터 위치** | 외부 시스템에 그대로 둠 — 복사본 없음 | Salesforce로 복사·저장 |
| **최신성** | 항상 실시간 조회 → 항상 최신 | 동기화 주기만큼 지연(실시간 아님) |
| **저장 공간** | Salesforce 데이터 저장량 소비 안 함 | 저장량 소비(대량이면 비용·한도 압박) |
| **데이터 볼륨 적합** | 총량은 크지만 **한 번에 소량만 조회**할 때 (예: 1천만 건 중 계정별 최근 20건) | 전체를 반복 스캔·집계·대량 조회할 때 |
| **조회 성능** | 매 접근이 콜아웃 → 지연·콜아웃 한도(OData 2.0/4.0 기본 **시간당 20,000 콜아웃**) 영향 | 로컬 인덱스 조회 → 빠름, 콜아웃 없음 |
| **리포팅** | 제약 큼 — 외부 오브젝트 포함 리포트는 **primary 오브젝트를 최대 20,000 records** 페치(그 과정에서 콜아웃 한도), **리포트 표시·리스트뷰는 2,000행** 상한, 버킷·크로스필터 불가, High Data Volume 시 리포트 불가(§아래) | 표준 리포트·대시보드 전 기능 |
| **오프라인 / 모바일** | 실시간 콜아웃 의존 → 오프라인 캐시 안 됨 | 로컬 데이터라 오프라인·모바일 캐시 가능 |
| **자동화 트리거** | Apex 트리거·Flow·워크플로우/롤업 등 대부분 미지원(레코드가 org에 저장되지 않음) | 트리거·Flow·롤업·검증규칙 등 전체 자동화 사용 |
| **관계** | Lookup / External Lookup / Indirect Lookup **3종만**(마스터-디테일·롤업 불가) | 표준 관계(마스터-디테일 포함) 전부 |
| **공유·소유권** | 외부 시스템에 Owner 개념이 없어 표준 공유 규칙 적용 제한 | 표준 레코드 소유·공유·역할 계층 사용 |
| **쓰기** | Writable External Objects로 가능하나 High Data Volume과 상호 배타(§아래) | 표준 DML 자유 |

**한 줄 선택 기준**
- **External Objects 유리** — 실시간성이 중요하고, 저장 공간을 아껴야 하며, 한 번에 소량만 보면 되고, 사용자가 데이터를 **주로 조회(read-heavy)** 할 때 (예: 상담원이 ERP 주문 이력 열람).
- **복제 유리** — 대량 조회·집계·표준 리포팅이 필요하거나, 오프라인/모바일 캐시가 필요하거나, org 자동화(트리거·Flow·롤업)를 태워야 하거나, 마스터-디테일 등 표준 관계 제약을 우회해야 할 때.

> 절충안: 자주 안 바뀌는 참조 데이터는 복제하고, 방대하지만 가끔만 보는 트랜잭션 데이터는 External Object로 페더레이션하는 **하이브리드**도 흔하다.

---

## 노코드 OData 경로 & 트러블슈팅

Apex Connector Framework(커스텀 어댑터, `[[DataSource Namespace]]` 참조)를 짜지 않고도, 외부 시스템이 **표준 OData 2.0/4.0 서비스**를 노출하면 코드 없이 External Data Source → External Object를 구성할 수 있다.

### 1) External Data Source 등록 (노코드)

**Setup → External Data Sources → New External Data Source**

| 필드 | 값 |
|---|---|
| **Type** | `Salesforce Connect: OData 2.0` 또는 `Salesforce Connect: OData 4.0` |
| **URL** | OData 프로듀서 서비스 루트 URL (Salesforce 앱 서버에서 인터넷으로 도달 가능해야 함) |
| **High Data Volume** | 초대용량 데이터셋일 때만 체크 (효과는 아래 참조) |
| **Identity Type** | `Named Principal`(모든 사용자가 단일 자격증명 공유) 또는 `Per User`(사용자별 자격증명) |
| **Authentication Protocol** | `Anonymous` / `Password Authentication` / `OAuth 2.0` |

- **인증 옵션**
  - `Anonymous` — 외부 시스템이 인증을 요구하지 않을 때만.
  - `Password Authentication` — 외부 시스템 사용자명/비밀번호 입력.
  - `OAuth 2.0` — Auth Provider 지정. **refresh token(offline access)을 요청**하도록 구성해야 토큰 만료 시 접근이 끊기지 않는다.
  - `Per User`를 고르면 각 사용자가 자기 자격증명을 별도로 인증해야 하며, 사용자에게 인증 설정 접근 권한을 부여해야 한다.

### 2) External Object 생성 — 자동 vs 수동

- **자동(권장):** External Data Source 저장 후 **Validate and Sync** 클릭 → 노출된 테이블 목록에서 원하는 것 선택 → **Sync** → 각 테이블에 대응하는 External Object(`__x`)와 필드가 자동 생성된다.
- **수동:** External Object를 직접 만들고 필드를 손수 매핑(외부 스키마와 이름이 어긋날 때).

### 3) 검증

- **Validate and Sync**가 성공하면 연결·메타데이터 조회가 정상.
- External Object 탭/리스트뷰 또는 관련 레코드에서 실제 행이 보이는지 확인.

### 실전 이슈

| 증상 | 진단 / 조치 |
|---|---|
| **"no rows returned"(행이 안 나옴)** | ① **OData Tracer 활성화** — External Data Source에서 트레이서를 켜면 Salesforce가 외부로 보낸 **요청과 받은 응답 원문**을 캡처해, 쿼리가 실제로 나갔는지·응답이 비었는지 확인할 수 있다([Troubleshoot OData Connections with OData Tracer](https://help.salesforce.com/s/articleView?id=release-notes.rn_forcecom_general_odata_tracer.htm)). ② 엔드포인트가 Salesforce 앱 서버에서 인터넷으로 도달 가능한지(방화벽에 Salesforce IP 허용). ③ 리포트라면 필터를 조정해 관련 외부 행이 결과에 들어오게 함. |
| **인증 실패** | Identity Type/Protocol 재확인. OAuth면 refresh token 없이 액세스 토큰이 만료됐을 가능성 → offline access 재요청. Named Principal 자격증명 만료 여부 확인. |
| **리포트·리스트뷰가 일부만 보임** | 두 한도를 구분한다: ① 외부 오브젝트를 포함한 리포트는 **primary 오브젝트를 최대 20,000 records**까지 페치한다(그 과정에서 콜아웃 한도에 걸릴 수 있음). ② **리포트 표시·리스트뷰는 2,000행** 상한(Salesforce Connect 서버 드리븐 페이징의 최대 페이지 크기도 2,000행). 즉 페치 상한(20,000)과 표시 상한(2,000)은 별개다. 대량 분석은 CRM Analytics/Tableau 등으로 우회. |
| **High Data Volume 옵션 부작용** | 초대용량 데이터셋용 옵션. 켜면 Salesforce가 원격 레코드에 **18자리 SF ID를 매핑하지 않는다**(평소엔 시간당 최대 100,000건 ID 매핑 생성). 그 대가로 **리포트 불가**(cross-org 어댑터 제외 — 리포트하려면 이 옵션을 **꺼야** 함)이고 **Writable External Objects와 상호 배타**(쓰기·양방향 업데이트 불가)다. 리포팅·쓰기가 필요하면 끄고, 순수 대량 읽기 전용일 때만 켠다. |

> 커스텀 REST 등 OData가 아닌 소스는 이 노코드 경로가 아니라 Apex Connector Framework(`Custom (Apex)` 어댑터)로 어댑터를 구현한다 — 코드 측 상세는 `[[DataSource Namespace]]`.

---

## 제약사항

- 외부 오브젝트 레코드 데이터는 **항상 실시간으로 외부 시스템에서 조회** — 항상 최신 상태 반영
- Salesforce Connect와 Files Connect를 통해서만 사용 가능 (Salesforce Connect는 **유료 add-on 라이선스** — 위 "⚠️ 전제조건" 참조)
- 관계 타입: Lookup, External Lookup, Indirect Lookup만 지원

---

## 관련 노트

- [[1 Overview]] — Chapter 1 전체 구조 요약
- [[Object Relationships]] — External Lookup·Indirect Lookup 관계 타입 상세
- [[DataSource Namespace]] — Apex Connector Framework(커스텀 OData 아닌 어댑터) 코드 측 구현
- [[Custom Objects]] — 외부 오브젝트와 커스텀 오브젝트 비교
- [[Big Objects]] — 대용량 데이터 처리를 위한 또 다른 옵션
- [[Object Groups]] — External Data Objects 그룹 분류
- [[Object Types Reference]] — __x suffix 및 Zero Copy Objects Cheatsheet
- [[Salesforce Connect — 어댑터·Cross-Org·writable·External CDC]] — 심화(이 노트의 상위 짝): 어댑터 상세·Cross-Org·writable external objects·External CDC·한도
