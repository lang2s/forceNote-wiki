---
tags: [integration, salesforce-connect, external-objects, cross-org-adapter, writable-external-objects, external-cdc, odata, limits]
source: help.salesforce.com — Salesforce Connect (platform.platform_connect_adapters.htm · platform_connect_writable_external_objects.htm · platform_connect_general_limits.htm · platform_connect_considerations.htm · platform_connect_license.htm · xorg_adapter_about.htm · external_object_change_tracking_intro.htm, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [Salesforce Connect adapters, Cross-Org adapter, 크로스오르그 어댑터, writable external objects, 쓰기 가능 외부 객체, External Change Data Capture, 외부 변경 데이터 캡처, Salesforce Connect 한도, OData 4.0 adapter, GraphQL adapter, SQL adapter, DynamoDB adapter, Salesforce Connect limits]
---

# Salesforce Connect — 어댑터·Cross-Org·writable·External CDC

> Salesforce Connect 심화: 어댑터 카탈로그 전수·Cross-Org 어댑터·쓰기 가능 외부 객체·External Change Data Capture·하드 한도·라이선스 connection 수.

---

## 범위 안내

이 노트는 **Salesforce Connect 심화 계층**이다 — 어댑터별 상세, Cross-Org 어댑터, writable external objects, External Change Data Capture, 하드 한도, 라이선스를 다룬다.

기초 개념은 이미 [[External Objects]]에 있으니 그쪽으로 위임한다:

- external object(`__x`)의 개념과 커스텀 오브젝트 대비
- 관계 3종(lookup / external lookup / indirect lookup)
- OData no-code 셋업 절차
- OData Tracer
- High Data Volume(HDV) external data source
- 라이선스 기초

여기서는 그 내용을 재서술하지 않고, 위 항목이 필요하면 [[External Objects]]를 참조한다.

Salesforce Connect는 protocol-specific 어댑터로 외부 시스템에 연결해 데이터에 접근한다. org에서 external data source를 정의할 때 **Type** 필드에 어댑터를 지정한다.

**Required Editions**
- Salesforce Classic·Lightning Experience 모두 사용 가능 (high-data-volume external objects는 제외)
- Developer Edition에서 사용 가능
- Enterprise, Performance, Unlimited Edition에서 추가 비용(extra cost)으로 사용 가능

---

## 어댑터 카탈로그 (전수)

Salesforce Connect에서 사용 가능한 어댑터 전체.

| 어댑터 | 설명 (transport) | 언제 사용 |
|---|---|---|
| **Cross-org** | Lightning Platform REST API를 사용해 **다른 Salesforce org**에 저장된 데이터에 접근. 예: 여러 Salesforce org의 데이터를 통합해 서비스 담당자에게 고객 트랜잭션의 통합 뷰를 제공. | 서로 다른 Salesforce org 간 데이터를 통합할 때. |
| **OData 2.0 / OData 4.0 / OData 4.01** | Open Data Protocol을 사용해 Salesforce 외부에 저장된 데이터에 접근. 외부 데이터는 **OData producer**를 통해 노출돼야 함. | ODATA 프로토콜을 지원하고 OData provider를 게시하는 외부 데이터 소스를 통합할 때. 예: SAP·Microsoft 같은 레거시 시스템의 데이터를 실시간으로 끌어와 account executive에게 통합 데이터 뷰 제공. |
| **Custom adapter created via Apex** | **Apex Connector Framework**([[DataSource Namespace]])를 사용해 다른 어댑터가 적합하지 않을 때 직접 커스텀 어댑터를 개발. 커스텀 어댑터는 **어디서든** 데이터를 가져올 수 있음 — 일부는 callout으로 인터넷 어디서든 조회, 다른 일부는 프로그래밍적으로 조작·생성 가능. | 다른 어댑터가 부적합할 때 Apex Connector Framework로 직접 어댑터 개발. 예: REST API에서 callout으로 데이터를 조회하려는 경우. |
| **Salesforce Connect Adapter for Amazon DynamoDB** | Amazon DynamoDB 데이터 소스를 external object를 통해 Salesforce에 연결. DynamoDB의 유연한 데이터 저장 옵션과 Salesforce Platform 역량을 함께 사용 가능. | AWS 데이터를 Salesforce 비즈니스 애플리케이션과 네이티브하게 통합할 때. |
| **Salesforce Connect Adapter for SQL** | REST API로 역량을 노출하고 **SQL로 query·DML** 연산을 제공하는 외부 데이터 소스에 Salesforce를 연결. **Snowflake**와 **Amazon Athena** 외부 데이터 소스를 지원. | 외부 데이터를 Salesforce와 네이티브하게 통합하고 SQL로 대화형 on-demand 쿼리를 실행할 때. |
| **Salesforce Connect Adapter for GraphQL** | GraphQL API를 사용해 애플리케이션을 통합하는 현대적 방식 제공. | GraphQL로 역량을 노출하는 외부 소스의 데이터에 접근·통합할 때 — **AWS AppSync를 통한 Amazon RDS** 포함. |

---

## Cross-Org 어댑터

여러 Salesforce org에 걸친 데이터를 연결해 프로세스를 개선한다. Cross-org 어댑터로 Salesforce Connect는 **Lightning Platform REST API 콜**을 사용해 다른 Salesforce org의 레코드에 접근한다. 셋업은 point-and-click 도구만으로 빠르고 간단하다.

사용자와 Lightning Platform은 external object를 통해 다른 org의 데이터와 상호작용하며, cross-org 어댑터는 그 각각의 상호작용을 하나의 Lightning Platform REST API 콜로 변환한다.

### API 콜을 발생시키는 9개 트리거 이벤트 (전수)

Cross-org 어댑터는 다음의 **매 순간마다** Lightning Platform REST API 콜을 만든다:

1. 사용자가 external object 탭을 클릭해 list view를 볼 때
2. 사용자가 external object의 record detail 페이지를 볼 때
3. 사용자가 **child external object 레코드의 related list를 표시하는 parent object의 record detail 페이지**를 볼 때
4. 사용자가 Salesforce global search를 수행할 때
5. 사용자가 external object 레코드를 **create, edit, 또는 delete** 할 때
6. 사용자가 report를 실행할 때
7. **report builder에서 preview가 로드**될 때
8. external object가 **flows, processes, APIs, Apex, SOQL, 또는 SOSL**을 통해 접근될 때
9. external data source를 **validate 또는 sync** 할 때

Cross-org 어댑터로 Salesforce Connect를 셋업하려면 **point-and-click 도구만** 사용한다. (상세 셋업 스텝은 별도 help 페이지 "Set Up Salesforce Connect to Access Data in Another Org with the Cross-Org Adapter"로 위임 — 이 노트에는 재서술하지 않음.)

### Provider org vs Subscriber org

| 구분 | 역할 |
|---|---|
| **Provider org** | 데이터를 **저장**하는 org. |
| **Subscriber org** | 데이터에 **접근**하는 org. |

- **API 이름**: subscriber org에서 syncing으로 external object·custom field가 생성되면, 그 API 이름은 provider org의 대응 API 이름에서 파생된다.
- **Record ID / External ID**: external object의 record ID는 provider org의 대응 record ID에서 파생된다. external object 레코드의 External ID 값은 provider org의 record ID와 일치한다.
- **사용자 접근**: external data에 대한 사용자 접근은 **subscriber org와 provider org 양쪽의 설정**에 의해 결정된다.

---

## Writable External Objects (쓰기 가능 외부 객체)

External object는 **기본적으로 read-only**다. external data source를 정의할 때 **Writable External Objects**를 선택하면, Salesforce Connect external object로 데이터를 **create, update, delete** 할 수 있다.

관련 개념(모두 external data source 구성 시 결정):

- **Identity Type** — external data source의 Identity Type 필드는 org가 외부 시스템에 접근할 때 **한 세트**의 credential을 쓰는지 **여러 세트**를 쓰는지 지정한다. 각 credential 세트는 외부 시스템의 로그인 계정 하나에 대응한다.
- **Sync의 의미** — external data source를 validate·sync 하면 외부 시스템의 스키마에 매핑되는 Salesforce external object가 **생성되거나 덮어써진다**. Sync는 Salesforce org로 데이터를 복사하지 않으며, org의 데이터를 외부 시스템으로 쓰지도 않는다. (즉 sync = 스키마 매핑, writable = 데이터 CRUD로 별개 개념.)
- **External object 동작** — external object는 커스텀 오브젝트와 유사하게 동작하지만, external data source의 외부 데이터에 매핑된다는 점이 다르다. 각 external object는 하나의 데이터 테이블에, object field는 접근 가능한 테이블 컬럼에 매핑된다.

인증 credential은 [[Named Credential]]을 통해 관리할 수 있다.

---

## External Change Data Capture (외부 변경 데이터 캡처)

> [!warning] 내부 Change Data Capture와 다른 기능 — 혼동 주의
> **External** Change Data Capture는 *외부* 시스템에 저장된 데이터의 변경을 추적한다. Salesforce 내부 레코드(Account·Contact 등)의 create/update/delete/undelete 이벤트를 발행하는 **내부 Change Data Capture**([[Change Data Capture — 개요·채널 구독]])와는 **완전히 다른 기능**이다. 둘 다 change event를 발행하고 Streaming API/Apex 트리거로 구독한다는 점이 비슷해 혼동하기 쉬우니, 대상이 *외부 데이터*인지 *내부 Salesforce 레코드*인지로 구분한다.

External Change Data Capture로 **OData 4.0 및 4.01 어댑터**를 사용할 때 Salesforce org 외부에 저장된 데이터의 변경을 추적할 수 있다(OData 4.0/4.01 어댑터 **전용** 기능). 변경에 대응하는 automation을 만들어 생산성을 높이거나 고객 경험을 개선할 수 있다.

외부 데이터 변경 추적 기능은 **설정 가능한 간격(5–30분)**으로 외부 시스템을 폴링해 추적된 변경을 확인한다. 이 기능이 활성화된 각 external object마다 **topic channel과 연관된 change event entity**가 생성되고, 여기에 change event 알림이 발행된다. 각 topic channel에 subscriber를 추가하고 **Streaming API**를 통해 데이터 변경을 처리한다. 또는 change event 알림 발행 시 호출되는 **Apex 트리거**를 추가할 수도 있다.

### 폴링 간격

- **기본값: 30분** — 기본적으로 외부 시스템을 30분마다 폴링.
- **최소: 5분** — 최대 5분까지 자주 폴링하도록 간격 변경 가능.

### 하위 페이지 (help.salesforce.com)

External CDC는 다음 하위 페이지들로 문서화돼 있다(이 노트는 개요만 담으며, 상세 절차는 각 help 페이지 참조):

- **External Change Data Capture Considerations** — 사용 시 고려사항.
- **Enable External Change Data Capture and Tracking** — 데이터 소스와 모니터링할 각 external object에서 external change data capture 활성화.
- **Subscribe to Change Events** — Apex 트리거로 구독하거나, Bayeux 클라이언트로 publication channel의 Streaming API를 구독.
- **Check the External Change Data Capture Status for an External Object** — external object의 detail 페이지에서 change-tracking 상태 확인(상세 모니터링도 가능).
- **Change the Polling Interval for External Change Data Capture** — 폴링 간격 변경(기본 30분, 최소 5분).
- **Monitor and Troubleshoot External Change Data Capture** — change tracking 문제 해결 팁.
- **Example: How Codey Outfitters Uses External Change Data Capture** — 가상 회사 예시.

구독은 Apex 트리거 또는 Bayeux 클라이언트로 이뤄진다. 아래는 발행 채널을 Streaming API로 구독하는 개념 구조다.

```apex
// 구조 예시 — 실제 동작 코드 아님
// External CDC change event를 Apex 트리거로 구독 (개념 구조)
// change event entity 이름은 enable 시 external object 기준으로 생성됨
trigger ExternalOrderChangeTrigger on ExternalOrder__ChangeEvent (after insert) {
    for (ExternalOrder__ChangeEvent evt : Trigger.new) {
        EventBus.ChangeEventHeader header = evt.ChangeEventHeader;
        // header.changeType, header.recordIds 등을 이용해 외부 변경에 대응하는 automation 실행
    }
}
```

---

## 한도 (General Limits)

모든 Salesforce Connect 어댑터에 적용되는 한도.

| 한도 항목 | 값 |
|---|---|
| 시간당 최대 **새 row retrieve 또는 create** 수 | **100,000** |
| org당 최대 external object 수 | **200** |
| external object 및 기타 오브젝트 유형 간 **쿼리당 최대 join 수** | **4** |
| 외부 시스템이 발급하는 **OAuth 토큰의 최대 길이** | **4,000 characters** |
| **server-driven paging의 최대 page size** | **2,000 rows** |

**세부 주석:**

- **100,000 rows/hour 예외** — 이 한도는 다음에는 적용되지 않는다: ① **Hyperforce에 호스팅된 org**(Spring '25 릴리스부터 rolling basis로 제공), ② **High data volume external data source**.
- **200 external objects** — org의 external object 기본값이 **100**이면, support case를 열어 org 한도를 **200**으로 상향할 수 있다. external object와 custom object는 별도 한도를 가지며, **external object는 custom object 사용량에 카운트되지 않는다**.
- **4 joins** — 이 한도는 **report와 dashboard에 영향**을 줄 수 있다.
- **빈 문자열 쿼리** — Salesforce Connect 어댑터가 어떤 필드 값이 빈 문자열(empty string)과 같은지 쿼리를 보내면, 그 쿼리는 외부 시스템에서 **null 값 필터로 변환**된다.

### Callout 한도 (어댑터별)

Salesforce Connect는 web service callout으로 외부 데이터에 실시간 접근하며 **자체적인 callout 한도는 없다**. 단, 외부 데이터 소스가 일정 기간에 받을 수 있는 callout 수는 제한될 수 있으니 외부 시스템이 강제하는 API 한도를 염두에 둔다.

| 어댑터 | Callout 한도 |
|---|---|
| **OData 2.0 / 4.0 / 4.01** | callout 한도 없음. 단 외부 시스템 자체의 트래픽 한도가 있을 수 있음. |
| **Custom adapter** | **Developer Edition org에서는 callout이 제한**됨. Apex Developer Guide의 Callout Limits and Limitations, Execution Governors and Limits 참조. |
| **Amazon DynamoDB / GraphQL / SQL(Amazon Athena·Snowflake 둘 다)** | callout 한도 없음. 단 외부 데이터 소스의 호스팅 provider가 callout에 요금을 부과할 수 있음. |
| **Cross-org** | **각 callout이 provider org의 API 사용 한도에 카운트**됨. API Request Limits and Allocations 참조. |

---

## 지원 플랫폼 기능

Salesforce Connect는 Salesforce Platform과 매끄럽게 통합돼 사용자가 external object 데이터를 보고·검색하고·수정할 수 있게 한다. 어댑터별 고려사항을 검토해 플랫폼 기능 지원을 확인한다.

- **Reports** — external object를 포함한 report는 **네트워크 지연과 외부 시스템 가용성에 따라 실행에 오래 걸릴 수 있다**.
- **Record Feeds (Chatter)** — 팔로우한 external object 레코드의 Chatter feed를 봐서 레코드 업데이트를 확인할 수 있다. 레코드를 팔로우하면 external object의 중요한 변경을 놓치지 않는다.
- **Quick Actions** — external object는 quick action을 지원한다. 단 external object와 호환되지 않는 기능·동작이 관여된 action은 제외.
- **Flows and Processes** — external object를 포함한 flow와 process를 만들어 반복 업무를 자동화할 수 있다.
- **Salesforce 모바일 앱** — Salesforce 모바일 앱에서 external object를 **보고 검색**할 수 있다.
- **Salesforce Console** — external object는 **Salesforce Classic의 Salesforce console에서만** 접근 가능. **Lightning Experience의 Salesforce console 등 다른 console은 지원하지 않는다**.
- **기타 지원 기능** — external object는 Salesforce **API, SOQL 쿼리, SOSL·Salesforce 검색, packages, Metadata API, change sets, Lightning Experience 앱**에서 사용 가능하다.

---

## 라이선스

Salesforce Connect로 org에서 외부 데이터에 접근하려면 하나 이상의 **Salesforce Connect add-on 라이선스**가 필요하다. 각 add-on 라이선스는 어댑터 유형별로 정해진 수의 connection을 포함하며, 하나의 add-on 라이선스는 **단일 Salesforce org**에 연결된다.

| Salesforce Connect 어댑터 | 라이선스당 connection 수 |
|---|---|
| **Cross-org** | **5** |
| **OData 2.0, OData 4.0, OData 4.01, custom adapter, Amazon DynamoDB 어댑터, SQL 어댑터, GraphQL 어댑터** | **1** |

필요한 add-on 라이선스 수는 데이터가 어디에 저장되는지와 어떤 유형의 connection이 필요한지에 따라 달라진다. 일반적인 데이터 통합 시나리오와 필요한 라이선스 수:

- **primary org이 다른 6개 Salesforce org의 데이터에 접근** → **2개** add-on 라이선스 필요(둘 다 primary org에 할당). *(cross-org은 라이선스당 5 connection이므로 6 org에는 2 라이선스)*
- **primary org이 1개 secondary org의 데이터에 접근하고, secondary org도 primary org의 데이터에 접근** → **2개** add-on 라이선스 필요(각 org마다 1개).
- **primary org이 다른 5개 Salesforce org + 1개 external data source에 접근** → **1개** add-on 라이선스 필요(primary org에 할당). *(cross-org 5 connection으로 5 org 커버; external data source는 별도 유형이지만 시나리오상 1 라이선스로 충족)*

---

## 관련 노트
- [[External Objects]] — 기초: external object `__x`·관계 3종(lookup/external lookup/indirect lookup)·OData no-code 셋업·OData Tracer·HDV
- [[DataSource Namespace]] — Custom 어댑터(Apex Connector Framework) 코드
- [[Named Credential]] — 외부 시스템 인증 credential
- [[Change Data Capture — 개요·채널 구독]] — **내부** CDC(Salesforce 레코드 이벤트) — External CDC와 혼동 주의
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — Salesforce Connect(실시간 연동) vs 데이터 복제 선택 기준
- [[External Services]] — disambiguation: OpenAPI 기반 액션은 Salesforce Connect와 별개 기능
