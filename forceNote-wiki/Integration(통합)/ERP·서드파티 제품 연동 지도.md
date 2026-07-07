---
tags: [integration, erp, sap, oracle, netsuite, informatica, mulesoft, salesforce-connect, odata, api-led, routing-map]
source: Salesforce Integration Patterns and Practices (architect.salesforce.com atlas.en-us.integration_patterns_and_practices, Tier 2) + Data Integration Decision Guide (architect.salesforce.com/docs/architect/decision-guides/guide/data-integration, Tier 2) + What Is API-led Connectivity (salesforce.com/blog, Tier 2). 벤더 제품 특정 서술은 external-knowledge(Tier 3, 각 블록에 경고)
official_doc: https://architect.salesforce.com/docs/architect/decision-guides/guide/data-integration
created: 2026-07-07
aliases: [ERP 연동 지도, 서드파티 제품 연동, SAP Salesforce 연동, Oracle ERP Salesforce, NetSuite Salesforce 연동, Informatica IICS Salesforce, MuleSoft API-led connectivity, 제품별 통합 라우팅, 실시간 vs 배치 통합]
---

# ERP·서드파티 제품 연동 지도

> "제품 X(SAP·Oracle·NetSuite·Informatica·MuleSoft)를 Salesforce와 어떻게 잇나"를 **Salesforce 측 메커니즘**(OData/Salesforce Connect·REST/Bulk·Platform Event·미들웨어 경유)으로 라우팅하는 지도. **제품 내부 설정(SAP IDoc·NetSuite SuiteScript·Informatica 매핑 등)은 범위 밖** — 각 벤더 문서를 따른다. 이 노트는 "Salesforce 쪽에서 무엇을 켜고 어떤 위키 노트로 가야 하나"만 답한다.

> [!note] 범위 선언
> 이 지도는 **Salesforce 플랫폼이 노출하는 진입점**을 기준으로 제품을 라우팅한다. 어떤 제품이든 Salesforce가 보는 것은 결국 (a) **인바운드 API 호출**(REST/Bulk/SOAP), (b) **아웃바운드 콜아웃/이벤트**(Named Credential·Platform Event), (c) **가상 데이터 페더레이션**(Salesforce Connect/OData External Objects) 셋 중 하나다. 제품별 커넥터가 어느 쪽을 쓰느냐만 알면 나머지 설정은 해당 Salesforce 노트로 위임된다.

---

## 1. 제품 → Salesforce 측 접근법 매핑

아래 표의 "Salesforce 측 방식"은 **Salesforce에서 켜고 설정하는 부분**이다. 제품(왼쪽) 내부에서 무엇을 하는지는 각 벤더 문서 소관이다.

| 제품 | 대표 시나리오 | 권장 Salesforce 측 방식 | 위키 노트 |
|---|---|---|---|
| **SAP** (ECC·S/4HANA) | ERP 마스터/트랜잭션을 SF에서 조회·동기화 | ① 복제 불필요·라이브 조회 → **Salesforce Connect + OData External Objects** (미들웨어가 OData 엔드포인트 노출) ② 실제 동기화 → **미들웨어(MuleSoft) 경유 REST/Bulk** | [[External Objects]] · [[Bulk API 2.0]] · [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] |
| **Oracle ERP** (EBS·Fusion/ERP Cloud) | 회계·주문 데이터를 SF와 양방향 | ① 대량 배치 → **Bulk API 2.0**(인바운드) / **Queueable+Callout**(아웃바운드) ② 이벤트 → **Platform Event / CDC** | [[Bulk API 2.0]] · [[Queueable + Callout 패턴]] · [[Platform Event 통합 패턴]] |
| **Oracle NetSuite** | CRM(SF)↔ERP(NetSuite) 주문·고객 동기화 | ① iPaaS/커넥터 경유 → **REST API**(표준 CRUD/Composite) 또는 **Bulk API 2.0** ② 이벤트 알림 → **Platform Event** | [[REST API]] · [[Bulk API 2.0]] · [[Platform Event 통합 패턴]] |
| **Informatica** (IICS / IDMC) | ETL/iPaaS로 대량 적재·정제 | **Bulk API 2.0**(대량 ingest/query) — Informatica 커넥터가 Bulk를 내부 호출. 소량 실시간은 **REST API** | [[Bulk API 2.0]] · [[REST API]] |
| **MuleSoft** (Anypoint) | 여러 시스템을 허브로 오케스트레이션 | **미들웨어 위상 자체.** SF는 MuleSoft와만 대화 → 아웃바운드는 **Named Credential+REST/Queueable**, 인바운드는 **REST API/Composite**, 페더레이션은 MuleSoft가 노출한 **OData → External Objects** | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] · [[Named Credential]] · [[External Objects]] |

> **읽는 법:** "제품이 데이터를 **밀어 넣나**(inbound to SF)" → REST/Bulk 인바운드. "SF가 **가져오나**(outbound)" → Named Credential+콜아웃/Queueable. "복제 없이 **라이브로 보나**" → Salesforce Connect+OData(External Objects). "이벤트로 **느슨히 결합**하나" → Platform Event/CDC + [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]].

### 공통 원칙 — 복제하지 말지, 페더레이션할지 먼저 결정

Salesforce **Data Integration Decision Guide**의 핵심 지침: *"데이터가 반드시 Salesforce 안에 있어야 하는 게 아니라면, 불필요한 복제 대신 Salesforce Connect 데이터 가상화(virtualization)를 먼저 고려하라."* 즉 제품 라우팅에 앞서 **"이 데이터를 SF에 복사할 것인가, 원격 조회만 할 것인가"**를 정한다 (근거: [Data Integration Decision Guide](https://architect.salesforce.com/docs/architect/decision-guides/guide/data-integration)).

- **가상화(페더레이션)** → [[External Objects]] (Salesforce Connect·OData). 데이터는 소스에 남고 SF는 쿼리 시점에 조회.
- **복제(replication)** → [[Bulk API 2.0]]·[[REST API]]로 SF 내부 오브젝트에 적재.

---

## 2. MuleSoft API-led connectivity — 3계층 (개요)

MuleSoft(Salesforce 소유)의 표준 통합 아키텍처. 통합 로직을 하나의 흐름에 뭉치지 않고 **역할별 API 3계층**으로 나눠 재사용·확장한다. 상세 MuleSoft 설정(Anypoint·DataWeave 등)은 범위 밖 — 여기서는 Salesforce 아키텍트가 위상을 이해하는 수준만 다룬다.

| 계층 | 역할 | Salesforce 관점 예시 |
|---|---|---|
| **System API** (기반) | ERP·DB·CRM 등 **시스템에 직접 연결**해 사일로된 데이터/기능을 노출. 시스템별 1개, 재사용 단위. | SAP를 감싸는 System API, Salesforce를 감싸는 System API(고객 데이터를 CRM 부하 없이 노출) |
| **Process API** (중간) | 여러 System API를 **오케스트레이션·변환·집계**해 비즈니스 로직 구현. 소스 시스템에 독립적. | SF 고객 + eCommerce 주문을 합쳐 "통합 고객 뷰" 생성 |
| **Experience API** (상단) | 소비 채널(모바일·대시보드·파트너)에 **맞춘 포맷**으로 Process API 결과를 노출. | 모바일 앱용/파트너 포털용으로 같은 데이터를 다른 형태로 제공 |

- 이 3계층은 [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]]의 **hub-spoke(미들웨어) 위상**을 API로 구조화한 것이다. Salesforce는 보통 최하단 System API의 소스(또는 소비자)로 참여한다.
- 이점: 모듈화·재사용(한 System API를 여러 Process가 재사용), 소스 변경이 상위로 전파되지 않음(관심사 분리).
- 근거: [What Is API-led Connectivity? (Salesforce Blog)](https://www.salesforce.com/blog/api-led-connectivity/) · [Understanding API-Led Connectivity (Trailhead)](https://trailhead.salesforce.com/content/learn/modules/application-networks-and-api-led-connectivity-in-mulesoft/explore-api-led-connectivity)

```text
// 구조 예시 — 실제 원본 다이어그램 아님
[모바일][대시보드][파트너]      ← 소비 채널
        │
   Experience API  (채널별 포맷)
        │
   Process API     (오케스트레이션·변환·집계)
        │
   System API      (시스템 직결)
   ┌────┼────┐
  SAP  SF  eCommerce            ← 소스 시스템 (Salesforce는 여기 참여)
```

---

## 3. 실시간(real-time) vs 배치(batch) 결정 프레임

제품을 어느 방식으로 잇든, **각 데이터 흐름마다** 실시간/배치를 따로 정한다. 한 통합 안에서도 "주문 생성=실시간, 마스터 동기화=야간 배치"처럼 혼재하는 게 정상이다.

| 축 | 실시간 (Platform Event·CDC·동기 REST 콜아웃) | 배치 (Bulk API 2.0·스케줄 동기화) |
|---|---|---|
| **지연(latency)** | 초 이하 ~ 수 초 | 수 분 ~ 수 시간(스케줄 간격) |
| **데이터 신선도** | 항상 최신(변경 즉시 반영) | 마지막 배치 시점까지만 신선 |
| **API 소모** | 이벤트/레코드마다 호출 → 건수 많으면 한도 압박 | 레코드를 묶어 소수 잡으로 → **API 콜 절약** |
| **처리량(volume)** | 소량·산발적 트랜잭션에 적합 | 대량 마스터/이력 적재에 적합 |
| **복잡도·신뢰성** | 순서·중복·재생(replay) 관리 필요([[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] flow control/replay) | 잡 상태·실패 배치 재처리, 멱등 upsert로 중복 방지 |
| **결합도** | 느슨한 결합(이벤트 기반, 소비자 독립) | 강한 스케줄 결합(양쪽 배치 창 맞춤) |
| **대표 시나리오** | 주문 생성 알림, 재고 변경, 상태 전이 | 야간 고객/제품 마스터 동기화, 대량 초기 적재 |

> **결정 규칙:** ① 사용자가 **즉시 봐야** 하거나 하류 프로세스를 **트리거**하면 → 실시간(Platform Event/CDC). ② **대량**이고 **지연 허용**이면 → 배치(Bulk API 2.0) — API 한도를 아낀다. ③ **복제 자체가 불필요**하면 어느 쪽도 아니라 **가상화**([[External Objects]]). ④ 신뢰성은 방식과 무관하게 **멱등성(External Id upsert)·재시도**로 확보 → [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]].

> 근거: [Data Integration Decision Guide](https://architect.salesforce.com/docs/architect/decision-guides/guide/data-integration) — 실시간 패턴(Platform Events·CDC·Streaming), 배치 복제, 가상화 구분.

---

## 4. 벤더 제품 특정 세부 (Salesforce 소스로 미검증)

아래는 각 제품 **내부** 메커니즘이라 Salesforce 공식 소스로 대조되지 않는다. **정확한 커넥터 설정·버전·프로토콜은 반드시 각 벤더 공식 문서**를 확인한다. 여기서는 "Salesforce 측 방식이 왜 그 선택인지" 맥락만 제공한다.

> [!warning] 이 섹션은 외부/벤더 지식 기반으로 Salesforce 공식 소스와 대조되지 않았습니다.
> **SAP** — MuleSoft는 SAP에 **IDoc·BAPI over RFC** 또는 S/4HANA의 **OData/SOAP** 커넥터로 접속하고, 그 결과를 **OData API로 노출**해 Salesforce Connect의 External Object로 페더레이션하거나 REST/Bulk로 SF에 적재한다. SAP 측 RFC 사용자·IDoc 설정은 SAP Basis 소관.
> 근거(벤더): [MuleSoft SAP Integration](https://www.mulesoft.com/integration/sap) · [Expose External Data to Salesforce via OData in MuleSoft](https://blogs.mulecraft.com/expose-external-data-to-salesforce-via-odata-in-mulesoft/)

> [!warning] 이 섹션은 외부/벤더 지식 기반으로 Salesforce 공식 소스와 대조되지 않았습니다.
> **Oracle NetSuite** — NetSuite는 **SuiteTalk(SOAP Web Services)** REST/SOAP API로 레코드(customer·order·invoice 등)를 노출한다. Celigo·Boomi·MuleSoft·Workato 등 iPaaS가 SuiteTalk를 내부 호출해 Salesforce **REST/Bulk API**로 매핑한다. Oracle 제공 **NetSuite Connector SuiteApp**과 **Data 360 Oracle NetSuite Connector**도 있다. NetSuite 측 SuiteScript·역할 권한은 NetSuite 소관.
> 근거(벤더/Oracle): [Oracle NetSuite Connector — Data 360 (Salesforce Developers)](https://developer.salesforce.com/docs/data/data-cloud-int/guide/c360-a-oraclenetsuite-connector.html) · [NetSuite Salesforce Connector Setup (Oracle Docs)](https://docs.oracle.com/en/cloud/saas/netsuite/ns-online-help/article_2155722791.html)

> [!warning] 이 섹션은 외부/벤더 지식 기반으로 Salesforce 공식 소스와 대조되지 않았습니다.
> **Informatica IICS (IDMC)** — Informatica는 iPaaS로 **Salesforce Bulk API 2.0**(대량)과 **REST/SOAP API**(소량 실시간)를 커넥터로 감싼다. 매핑·변환·스케줄은 Informatica 측에서 정의한다. Salesforce는 Bulk 잡·API 한도만 관리하면 된다.
> 근거(벤더): Informatica Cloud 커넥터 문서(각 커넥터 가이드) — 예 [Informatica Cloud NetSuite Connector](https://www.suiteapp.com/Informatica-Cloud-NetSuite-Integration)

> [!warning] 이 섹션은 외부/벤더 지식 기반으로 Salesforce 공식 소스와 대조되지 않았습니다.
> **Oracle ERP (EBS·Fusion)** — 표준 Salesforce 커넥터가 없어 대개 미들웨어(MuleSoft·Informatica·Boomi) 경유. Oracle 측은 REST/SOAP 또는 DB 레벨 접근을 노출하고, 미들웨어가 이를 Salesforce **Bulk/REST/Platform Event**로 변환한다.

**제품 커넥터 상세(버전·인증·필드 매핑·에러 코드)는 각 벤더 문서를 정본으로 한다.** 이 위키는 Salesforce 측 진입점만 다룬다.

---

## 관련 노트

- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — point-to-point vs ESB/MuleSoft 위상 + 재시도·멱등성 (이 지도의 위상 결정 근거)
- [[External Objects]] — Salesforce Connect·OData 데이터 가상화(복제 없이 라이브 조회)
- [[Bulk API 2.0]] — 대량 배치 ingest/query (ERP 마스터 동기화·iPaaS 적재)
- [[REST API]] — 표준 동기 CRUD/Composite (소량 실시간)
- [[Queueable + Callout 패턴]] — SF→외부 아웃바운드 콜아웃(DML+Callout 조합)
- [[Platform Event 통합 패턴]] — 이벤트 기반 느슨한 결합
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] — 외부 시스템의 이벤트 구독/발행(flow control·replay)
- [[Named Credential]] — 아웃바운드 인증·URL을 코드 밖에서 관리
- [[통합 MOC]] — 통합 패턴 전체 인덱스
