---
tags: [lwc, reference, api-modules, wire-adapters, ui-api, graphql, lightning-console]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Reference > LWC API Modules; 라이브 공식 문서, Tier 2, 사용자 제공 원문, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reference-api-modules.html
created: 2026-07-04
aliases: [LWC API modules, lightning/uiRecordApi, lightning/graphql, lightning/uiObjectInfoApi, lightning/uiListsApi, lightning/uiRelatedListApi, lightning/empApi, lightning/mobileCapabilities, lightning/analyticsWaveApi, lightning/platformWorkspaceApi, lightning/platformUtilityBarApi, experience/cmsDeliveryApi, wire adapter 모듈]
---

# LWC API Modules 레퍼런스

> record 데이터·Salesforce API에 접근하는 wire adapter·함수를 제공하는 `lightning/*`·`experience/*` 스코프 API 모듈 23종의 목록과 각 모듈의 First API Version 전수.

---

## 개요

- 이 모듈들은 **record 데이터와 Salesforce API 접근**을 위한 wire adapter와 함수를 제공한다.
- 네임스페이스는 `lightning/*` 또는 `experience/*`이며, `@salesforce`로 스코프되지 않는다.
- **`@salesforce/*`(런타임 리소스) 모듈과 구분:** `@salesforce/apex`·`@salesforce/schema` 등은 LWC에 런타임 기능(Apex 호출·스키마 참조 등)을 추가하는 리소스다. LWC API 모듈은 그와 달리 UI API·GraphQL·이벤트 스트리밍 등 **API 데이터 접근**을 담당한다. 런타임 리소스 모듈은 [[@salesforce Modules 레퍼런스]] 참조.
- 각 모듈이 제공하는 개별 wire adapter·함수의 상세 시그니처는 해당 모듈의 reference 페이지 소관이다. 이 노트는 **모듈 카탈로그**(어떤 모듈이 있고 어느 API 버전부터 제공되는가)를 다룬다.

아래 세 그룹으로 분류된다: **Record Data**(9), **Lightning Console API**(3), **Other Salesforce APIs**(11).

---

## Record Data

record·layout·list view·object·related list 등 UI API 계열 데이터에 접근하는 모듈.

| API 모듈 | 제공 (wire adapter·함수) | First API Version |
|---|---|---|
| `lightning/uiAppsApi` | Salesforce UI에 표시되는 앱의 데이터·메타데이터 | 50.0 |
| `lightning/graphql` | GraphQL API로 record 데이터 조회·관리. optional field·동적 쿼리 구성 지원 | 65.0 |
| `lightning/uiGraphQLApi` | GraphQL API로 record 데이터 조회·관리. Mobile Offline 유스케이스 지원 | 57.0 |
| `lightning/uiLayoutApi` | record layout 메타데이터·데이터 | 62.0 |
| `lightning/uiListApi` **(Deprecated)** | `lightning/uiListsApi`로 대체됨(superseded) | 45.0 |
| `lightning/uiListsApi` | list view 메타데이터 | 52.0 |
| `lightning/uiObjectInfoApi` | object 메타데이터·picklist 값 | 45.0 |
| `lightning/uiRecordApi` | record 데이터 | 46.0 |
| `lightning/uiRelatedListApi` | related list 메타데이터·record 데이터 | 53.0 |

> `lightning/uiListApi`(45.0)는 **Deprecated**이며 `lightning/uiListsApi`(52.0)로 superseded 되었다. 신규 개발에는 `lightning/uiListsApi`를 사용한다.

> UI API 및 `lightning/uiRecordApi`의 wire adapter(`getRecord` 등) 심화는 [[UI API 개요]]·[[uiRecordApi]]·[[getRecord 패턴]]·[[UI API 리소스 레퍼런스]]로 위임한다.

---

## Lightning Console API

Lightning Console 앱의 workspace 탭·utility bar·메시징 채널 등에 접근하는 모듈.

| API 모듈 | 제공 | First API Version |
|---|---|---|
| `lightning/conversationToolkitApi` | Enhanced Messaging 채널 | 60.0 |
| `lightning/platformUtilityBarApi` | utility bar (Lightning Console API의 일부) | 61.0 |
| `lightning/platformWorkspaceApi` | workspace 탭 (Lightning Console API의 일부) | 59.0 |

> `platformWorkspaceApi`·`platformUtilityBarApi`를 사용한 Console 조작 패턴은 [[Lightning Console JS API]] 참조.

---

## Other Salesforce APIs

CMS·CRM Analytics·플랫폼 이벤트·모바일 기능·Service Cloud Voice·Knowledge·Industries 등 그 외 API 접근 모듈.

| API 모듈 | 제공 | First API Version |
|---|---|---|
| `experience/blockBuilderApi` | Marketing Cloud Next 콘텐츠·CMS 확장의 컴포넌트 | 66.0 |
| `experience/cmsDeliveryApi` | enhanced CMS workspace의 콘텐츠 | 54.0 |
| `experience/cmsEditorApi` | enhanced CMS workspace의 콘텐츠 에디터 | 54.0 |
| `lightning/analyticsWaveApi` | CRM Analytics 에셋 데이터·메타데이터, 쿼리 실행, recipe/dataflow/data connector 데이터 sync 스케줄 | 52.0 |
| `lightning/cmsDeliveryApi` | Salesforce CMS 콘텐츠 | 52.0 |
| `lightning/empApi` | 플랫폼 이벤트 (streaming 채널 구독 등) | 45.0 |
| `lightning/industriesEducationPublicApi` | Education Cloud (Benefit Assignment 레코드 업데이트 등) | 60.0 |
| `lightning/mobileCapabilities` | 모바일 기능 (바코드 스캔·연락처 접근 등) | 48.0 |
| `lightning/serviceCloudVoiceToolkitApi` | Service Cloud Voice (Service Cloud Voice Toolkit API의 일부) | 52.0 |
| `lightning/serviceKnowledgeApi` | Knowledge 기사 (view count 통계 조회 등) | 60.0 |
| `lightning/uiLearningPlatformApi` | Enablement 프로그램 learning item 관련 데이터 | 62.0 |

> ⚠️ **`experience/cmsDeliveryApi`와 `lightning/cmsDeliveryApi`는 서로 다른 모듈이다.** 네임스페이스와 First API Version이 다르다: `experience/cmsDeliveryApi`(54.0)는 enhanced CMS workspace의 콘텐츠를, `lightning/cmsDeliveryApi`(52.0)는 Salesforce CMS 콘텐츠를 제공한다. import 시 네임스페이스를 정확히 지정한다.

> `lightning/mobileCapabilities`(바코드 스캔·연락처 접근 등)의 사용 패턴은 [[모바일 기능 패턴]] 참조.

---

## import 예시

```javascript
// 구조 예시 — 실제 동작 코드 아님 (모듈별 import 문법 참고용)

// Record Data — uiRecordApi의 getRecord wire adapter
import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class RecordViewer extends LightningElement {
    @wire(getRecord, { recordId: '$recordId', fields: ['Account.Name'] })
    account;
}
```

```javascript
// 구조 예시 — 실제 동작 코드 아님

// Record Data — GraphQL wire adapter (lightning/graphql, 65.0+)
import { LightningElement, wire } from 'lwc';
import { gql, graphql } from 'lightning/graphql';

export default class GraphqlExample extends LightningElement {
    @wire(graphql, { query: gql`...` })
    graphqlResult;
}
```

```javascript
// 구조 예시 — 실제 동작 코드 아님

// Other — 플랫폼 이벤트 구독 (lightning/empApi)
import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class EventSubscriber extends LightningElement {
    connectedCallback() {
        subscribe('/event/MyEvent__e', -1, (response) => {
            // 이벤트 수신 처리
        });
    }
}
```

> 위 세 블록은 모듈별 import 진입점 형태를 보여주는 예시다. 각 wire adapter/함수의 파라미터·반환 타입 전수는 해당 모듈의 공식 reference 페이지를 따른다.

---

## 관련 노트
- [[uiRecordApi]] — `lightning/uiRecordApi` 모듈 심화
- [[getRecord 패턴]] — Record Data wire adapter 사용 패턴
- [[UI API 개요]] — UI API 계열 모듈 개요
- [[UI API 리소스 레퍼런스]] — UI API 리소스 전수
- [[모바일 기능 패턴]] — `lightning/mobileCapabilities`
- [[Lightning Console JS API]] — `platformWorkspaceApi`·`platformUtilityBarApi`
- [[@salesforce Modules 레퍼런스]] — 런타임 리소스 모듈(`@salesforce/*`, 구분)
