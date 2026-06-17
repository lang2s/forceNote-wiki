---
tags: [Service, Knowledge, 지식, UI-API, LinkedArticle, CaseArticle, 제약, limitation, RecordTypeId]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch7 PDF p204–207)
created: 2026-06-17
aliases: [Knowledge UI API, UI API Limitations, LinkedArticle UI API, CaseArticle UI API, RecordTypeId null, optionalFields, related list UI API, Knowledge UI API 제약, ui-api Knowledge]
---

# Knowledge UI API 제약

> UI API로 Lightning Knowledge 레코드의 데이터·metadata를 조회·갱신해 Lightning Experience UI(모바일·custom web app)를 만든다. 단 Lightning Knowledge에는 4가지 알려진 제약이 있다. UI API는 Classic Knowledge를 지원하지 않는다.

---

## Chapter 7 개요 — Salesforce Knowledge UI API

UI API로 Salesforce Knowledge 레코드의 데이터·metadata를 조회·갱신해 모바일/custom web app용 Lightning Experience UI를 만든다.

> **Note:** UI API는 Classic Knowledge를 지원하지 않는다.

UI API 사용법과 지원 Knowledge 객체는 *User Interface API Developer Guide*의 Supported Objects 섹션 참조.

| 구분 | 지원 객체 |
|---|---|
| **All Supported Objects** | CaseArticle, KnowledgeArticleVersion, LinkedArticle |
| **List View Supported Objects** | KnowledgeArticleVersion |
| **Most Recently Used List View Supported Objects** | KnowledgeArticleVersion |

> 위 객체들의 SOAP API field 상세는 [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]](CaseArticle·LinkedArticle) · [[Knowledge SOAP API 객체 — 핵심 아티클 객체]](KnowledgeArticleVersion) 참조.

---

## UI API Limitations (4개 항목)

UI API with Lightning Knowledge에는 다음 제약이 있다. 아래 모든 항목은 **API v57.0+** 에 적용된다.

### 1. RecordTypeId of Linked Record Shows as Null When It Shouldn't

**Get a Record** UI API로 `LinkedArticle.LinkedEntity` 레코드의 `recordTypeId`를 조회하려면 `Id`를 `RecordTypeId`로 바꾼다.

```
// This code doesn't retrieve the correct recordTypeId.
GET
/services/data/v57.0/ui-api/records/{LinkedArticleId}?fields=LinkedArticle.LinkedEntity.Id
// This code retrieves the correct recordTypeId.
GET
/services/data/v57.0/ui-api/records/{LinkedArticleId}?fields=LinkedArticle.LinkedEntity.RecordTypeId
```

응답은 record type ID를 두 곳에 표시한다:
- `LinkedEntity | value | fields | RecordTypeId | value` — **올바른** record type ID 표시.
- `LinkedEntity | value | recordTypeId` — 연관 record type이 있어도 **null** 표시.

응답 JSON 예시(원문 전체):

```json
{
    "apiName": "LinkedArticle",
    "childRelationships": {},
    "eTag": "0a4b81f3e165e7feefcc2f0e0f30e6da",
    "fields": {
        "LinkedEntity": {
            "displayValue": "00000001",
            "value": {
                "apiName": "Name",
                "childRelationships": {},
                "eTag": "0917224c30df4322d4e5abbda36a9c25",
                "fields": {
                    "Id": {
                        "displayValue": null,
                        "value": "0WORM0000006nan4AA"
                    },
                    "RecordTypeId": {
                        "displayValue": null,
                        "value": "012RM0000005Yl2YAE"
                    }
                },
                "id": "0WORM0000006nan4AA",
                "lastModifiedById": null,
                "lastModifiedDate": null,
                "recordTypeId": null,
                "recordTypeInfo": null,
                "systemModstamp": null,
                "weakEtag": 0
            }
        },
        "LinkedEntityId": {
            "displayValue": null,
            "value": "0WORM0000006nan4AA"
        }
    },
    "id": "1WKRM0000004MKA4A2",
    "lastModifiedById": "005RM000002Z4dkYAC",
    "lastModifiedDate": "2022-09-28T18:12:10.000Z",
    "recordTypeId": "012000000000000AAA",
    "recordTypeInfo": null,
    "systemModstamp": "2022-09-28T18:12:10.000Z",
    "weakEtag": 1664388730000
}
```

### 2. object-info UI API Returns an Error

Object Manager에서 Knowledge object의 Object Name을 변경하면, `LinkedArticle` 또는 `CaseArticle`에 대해 **Get Object Metadata** UI API를 실행할 때 오류가 난다. Knowledge object 이름을 변경하지 말 것.

예: Knowledge object 이름을 변경하고 다음 UI API를 실행하면:

```
GET /services/data/v57.0/ui-api/object-info/LinkedArticle
GET /services/data/v57.0/ui-api/object-info/CaseArticle
```

INSUFFICIENT_ACCESS 오류를 받는다:

```json
{
    "errorCode":"INSUFFICIENT_ACCESS",
    "message":"You don't have access to this record. Ask your administrator for help or
        to request access."
}
```

### 3. Retrieving KnowledgeArticleVersion.RecordTypeId Fails

**Get a Record** UI API로 `LinkedArticle` 또는 `CaseArticle` 레코드의 `KnowledgeArticleVersion.RecordTypeId`를 조회하려면 `fields`가 아닌 `optionalFields` request parameter를 쓴다.

> PDF 원문 본문에는 이 parameter가 `optionaFields`(l 누락)로 표기되어 있으나, 정확한 parameter명은 `optionalFields`이며 코드 예제도 `optionalFields`를 쓴다.

```
GET
/services/data/v57.0/ui-api/records/{LinkedArticleId}?optionalFields=LinkedArticle.KnowledgeArticleVersion.RecordTypeId
GET
/services/data/v57.0/ui-api/records/{CaseArticleId}?optionalFields=CaseArticle.KnowledgeArticleVersion.RecordTypeId
```

`fields` request parameter로 이 RecordTypeId를 조회하려 하면 받는 오류:

```json
{
    "errorCode": "INVALID_FIELD",
    "message": "INVALID_FIELD: \nSELECT LastModifiedDate,
        KnowledgeArticleVersion.RecordTypeId\n
        ^\nERROR at
        Row:1:Column:26\nNo such column 'RecordTypeId' on entity 'KnowledgeArticleVersion'. If you
        are attempting to use a custom field, be sure to append the '__c' after the custom field
        name. Please reference your WSDL or the describe call for the appropriate names."
}
```

### 4. Record Data and Metadata of Related Lists Don't Show Up

related object가 부모 레코드의 page layout에 추가되지 않으면, UI API는 related list의 레코드 데이터·metadata를 반환하지 않는다.

영향받는 엔드포인트:
- Get Related List Records with URL Parameters
- Get Related List Records with a Request Body
- Get Related List Metadata

related object가 page layout에 없으면 다음 중 하나가 발생한다:
- `NVALID_TYPE` 오류 코드 *(PDF 원문 그대로 — 'I' 누락. 정상은 `INVALID_TYPE`으로 추정)*
- `UNKNOWN_EXCEPTION` 오류 코드
- UI API가 잘못된 레코드를 반환(예: Article 대신 LinkedArticle 레코드)

related list UI API 엔드포인트로 올바른 데이터·metadata를 조회하려면, related object를 부모 객체의 page layout에 추가한다:

```
/ui-api/related-list-records/{parentRecordId}/{relatedListId}
/ui-api/related-list-info/{parentObjectApiName}/{relatedListId}
```

related list object 추가: **Object Manager | {PARENT_OBJECT} | Page Layouts | Related Lists**.

예: 다음 UI API 호출로 Articles related list를 조회하려면 Articles related list를 WorkOrder, WorkOrderLineItem, Case page layout에 추가한다. Articles가 연관되는 다른 부모 객체 유형에도 동일하게 적용한다:

```
GET /services/data/v57.0/ui-api/related-list-records/{WorkOrderId}/LinkedArticles
GET /services/data/v57.0/ui-api/related-list-records/{WorkOrderLineItemId}/LinkedArticles
```

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]
- [[Knowledge REST API — Actions & Manage]]
- [[Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]] — 액션·검색·채널 사용 가이드 (이 UI API 제약이 적용되는 LEX 환경)
