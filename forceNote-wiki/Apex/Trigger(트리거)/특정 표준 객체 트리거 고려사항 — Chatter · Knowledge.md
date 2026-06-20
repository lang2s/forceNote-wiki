---
tags: [apex, trigger, chatter, feeditem, feedcomment, knowledge, KnowledgeArticleVersion, standard-object-trigger]
source: salesforce_apex_developer_guide.pdf (Apex Developer Guide v67.0 Summer '26 — Triggers for Chatter Objects; Trigger Considerations for Knowledge Articles)
created: 2026-06-20
aliases: [FeedItem trigger, FeedComment trigger, Chatter trigger, Triggers for Chatter Objects, FeedAttachment, KnowledgeArticleVersion trigger, KAV trigger, Knowledge article trigger, 게시물 트리거, 채터 트리거, 피드 트리거, 지식 문서 트리거, 아티클 트리거, FeedItem에 트리거 되나, Chatter 객체 트리거 작성, FeedAttachment 트리거, Knowledge 액션별 트리거 발화, 지식 아티클 저장 트리거, KAV before insert, CollaborationGroup 트리거, Knowledge 마이그레이션 트리거]
---

# 특정 표준 객체 트리거 고려사항 — Chatter · Knowledge

> FeedItem·FeedComment(Chatter)와 KnowledgeArticleVersion(KAV) 같은 표준 객체에 트리거를 작성할 때의 객체 고유 제약·발화 규칙.

---

## 개요

표준 객체 중 일부는 트리거를 작성할 수 있지만, 일반 sObject 트리거와 다른 **객체 고유 제약**이 붙는다. Chatter 객체(FeedItem·FeedComment)는 어떤 게시물 타입만 삽입 트리거를 발화하는지, before insert에서 어떤 필드를 못 쓰는지, 첨부(FeedAttachment)는 트리거 대상이 아니라 SOQL로만 접근한다는 식의 제약이 있다. Knowledge 아티클(KnowledgeArticleVersion)은 UI 액션(Save·Edit·Publish·Archive 등)이 내부적으로 어떤 DML로 변환되는지에 따라 발화 여부가 달라지며, 일부 액션은 트리거를 아예 발화하지 못한다.

이 객체별 제약을 모르면 "트리거를 작성했는데 발화하지 않는다"거나 "before insert에서 필드 값이 null이다" 같은 함정에 빠진다. 트리거의 문법·컨텍스트 변수·이벤트별 가용성은 [[Trigger 컨텍스트 변수와 이벤트]], 벌크 관용구·미발생 작업은 [[Trigger 벌크 관용구·미발생 작업·예외]] 참조. 이 노트는 **Chatter·Knowledge 객체 고유 제약**만 다룬다.

---

## Chatter 객체 트리거 (Triggers for Chatter Objects)

FeedItem과 FeedComment 객체에 트리거를 작성할 수 있다.

### Triggerable 객체와 제약

- **FeedItem · FeedComment** — 트리거 작성 가능.
- **FeedAttachment** — 트리거 대상이 **아니다**. 피드 첨부는 FeedItem **update 트리거**에서 SOQL 쿼리로 접근한다(아래 코드 예제 참조).
- FeedPost 객체는 API 버전 18.0·19.0·20.0에서 지원됐으나, **21.0 이전 버전에 대해 저장된 insert·delete 트리거는 사용하지 말 것.**

### 삽입 가능한 FeedItem Type (6종)

다음 타입의 FeedItem만 삽입할 수 있고, 따라서 before/after insert 트리거를 발화시킨다.

- `TextPost`
- `QuestionPost`
- `LinkPost`
- `HasLink`
- `ContentPost`
- `HasContent`

> 사용자 상태 업데이트(User status updates)는 FeedItem 트리거를 발화시키지 **않는다.**

### before insert에서 사용 불가한 필드

FeedItem의 다음 필드는 **before insert 트리거에서 사용할 수 없다.**

- `ContentSize`
- `ContentType`

또한 `ContentData` 필드는 **어떤 delete 트리거에서도** 사용할 수 없다.

FeedComment의 경우, **before insert·after insert 트리거**에서는 `FeedComment.RelatedRecordId`로 얻는 FeedComment 연관 ContentVersion의 필드들을 사용할 수 없다.

### FeedItem update 발화 조건

FeedItem 트리거는 첨부·capabilities 정보가 저장되기 **전에** 실행된다. 즉 트리거 안에서는 `ConnectApi.FeedItem.attachment` 정보와 `ConnectApi.FeedElement.capabilities` 정보를 아직 못 받을 수 있다.

피드 첨부 연산과 FeedItem update 트리거 발화 관계:

- 피드 아이템을 첨부와 함께 **insert**하면 FeedItem이 먼저 삽입되고 그 다음 FeedAttachment 레코드가 생성된다. 피드 아이템을 첨부와 함께 **update**하면 FeedAttachment 레코드가 먼저 삽입되고 그 다음 FeedItem이 업데이트된다.
  - 이 연산 순서 때문에, **Salesforce Classic**에서는 FeedAttachment를 Update·AfterInsert 트리거에서 사용할 수 있다.
  - **Lightning Experience**에서 첨부하면 Update·AfterInsert 양쪽에서 사용 가능하지만, AfterInsert 트리거에서는 FeedAttachment에 접근할 때 future 메서드를 써야 한다.
- 다음 첨부 연산은 **FeedItem update 트리거를 발화시킨다.**
  - FeedAttachment가 FeedItem에 추가되어 FeedItem 타입이 **변경**되는 경우.
  - FeedAttachment가 FeedItem에서 제거되어 FeedItem 타입이 **변경**되는 경우.
- 연관 FeedItem에 변화를 일으키지 않는 FeedAttachment의 insert·update는 FeedItem 트리거를 발화시키지 **않는다.**
- **before update·after update FeedItem 트리거**에서는 FeedAttachment를 insert·update·delete 할 수 **없다.**

### ConnectApi 영향 + 연쇄 트리거

FeedItem 트리거가 첨부·capabilities 저장 전에 실행되므로, 다음 ConnectApi 메서드에서 첨부·capabilities 정보를 받지 못할 수 있다.

- `ConnectApi.ChatterFeeds.getFeedItem`
- `ConnectApi.ChatterFeeds.getFeedElement`
- `ConnectApi.ChatterFeeds.getFeedPoll`
- `ConnectApi.ChatterFeeds.getFeedElementPoll`
- `ConnectApi.ChatterFeeds.postFeedItem`
- `ConnectApi.ChatterFeeds.postFeedElement`
- `ConnectApi.ChatterFeeds.shareFeedItem`
- `ConnectApi.ChatterFeeds.shareFeedElement`
- `ConnectApi.ChatterFeeds.voteOnFeedPoll`
- `ConnectApi.ChatterFeeds.voteOnFeedElementPoll`

**기타 Chatter 트리거 고려사항:**

- Apex 코드가 Chatter 컨텍스트에서 실행될 때는 추가 보안이 적용된다. **private group에 게시하려면** 코드를 실행하는 사용자가 그 그룹의 멤버여야 한다. 실행 사용자가 멤버가 아니면, FeedItem 레코드의 `CreatedById` 필드를 그룹 멤버로 설정할 수 있다.
- `CollaborationGroupMember`가 업데이트되면, 멤버 수를 정확히 유지하기 위해 `CollaborationGroup`도 자동으로 업데이트된다. 그 결과 **CollaborationGroupMember의 update·delete 트리거가 실행되면 CollaborationGroup update 트리거도 함께 실행된다.**

### 코드 예제 — FeedItemTrigger

FeedAttachment는 트리거 대상이 아니므로, FeedItem update 트리거에서 SOQL 쿼리로 접근한다.

```apex
trigger FeedItemTrigger on FeedItem (after update) {

    List<FeedAttachment> attachments = [SELECT Id, Title, Type, FeedEntityId
                                        FROM FeedAttachment
                                        WHERE FeedEntityId IN :Trigger.new ];

    for (FeedAttachment attachment : attachments) {
        System.debug(attachment.Type);
    }
}
```

> **SEE ALSO (Salesforce 공식 Object Reference):** FeedItem · FeedAttachment · FeedComment · CollaborationGroup · CollaborationGroupMember; Entity and Field Considerations in Triggers (Apex Developer Guide). 위키 내부에서는 `Entity and Field Considerations in Triggers`는 [[Trigger 벌크 관용구·미발생 작업·예외]] §4 참조.

---

## Knowledge 아티클 트리거 (Trigger Considerations for Knowledge Articles)

KnowledgeArticleVersion 객체에 트리거를 작성할 수 있다. 트리거를 언제 쓸 수 있는지, 그리고 아티클 보관(archiving)처럼 어떤 액션이 트리거를 발화시키지 않는지를 이해해야 한다.

### KnowledgeArticleVersion(KAV) 트리거 매핑

일반적으로 KnowledgeArticleVersion(KAV) 레코드는 다음 트리거를 사용할 수 있다.

- **KAV 레코드 생성** → `before insert`·`after insert` 호출. 여기에는 아티클 생성과, **Restore·Edit as Draft·Submit for Translation** 액션으로 archived·published·master-language 아티클에서 draft를 생성하는 것이 포함된다.
- **기존 KAV 레코드 편집** → `before update`·`after update` 호출.
- **KAV 레코드 삭제** → `before delete`·`after delete` 호출.
- **아티클 import** → `before insert`·`after insert` 호출. 번역과 함께 import하면 `before update`·`after update`도 호출된다.

> **Publish·Archive처럼 KAV 레코드의 publication status를 변경하는 액션은 Apex·flow 트리거를 발화시키지 않는다.** 다만 UI에서 아티클을 publish할 때 때때로 아티클이 저장되는데, 그런 경우에는 `before update`·`after update` 트리거가 호출된다.

### Knowledge 액션 ↔ 트리거 발화 매트릭스

다음은 KnowledgeArticleVersion 액션별 발화 트리거를 산문 원문 기준으로 정리한 보조 표다. 정본은 아래 산문 설명(`Knowledge Actions and Apex Triggers`)이며, 표는 빠른 조회용이다.

| 액션 | 발화 트리거 | 조건 / 단서 (원문) |
|---|---|---|
| **Save, Save and Close** | before/after **update** | 아티클이 저장될 때 |
| **Save, Save and Close** (최초 저장) | before/after **insert** | 새 아티클이 처음 저장될 때는 update 대신 insert가 발화 (*work instead*) |
| **Edit, Edit as Draft** — draft translation 편집 | before/after **update** | draft 번역을 편집할 때 |
| **Edit, Edit as Draft** — Edit as Draft (published → draft) | before/after **insert** | Edit as Draft가 published 아티클로부터 draft를 만들므로 insert 발화 |
| **Edit, Edit as Draft** — Classic에서 draft master-language 편집 | **미발화** | Salesforce Classic에서 draft master-language 아티클을 편집하면 트리거가 발화하지 않음 (*no triggers fire*) |
| **Edit, Edit as Draft** — Classic, Article Management 탭에서 archived 아티클 편집 | before/after **insert** | draft KAV 레코드를 생성하므로 insert 발화 |
| **Cancel, Delete** — translation draft 삭제 | before/after **delete** | translation draft를 삭제할 때 |
| **Cancel, Delete** — Classic에서 published 편집 후 Cancel | before/after **delete** | Classic의 Article Management·Knowledge 탭에서 published 아티클 편집 후 Cancel 클릭 → 새 draft가 삭제됨 |
| **Submit for Translation** | before/after **insert** | draft 번역을 생성하므로 일반적으로 insert 사용 |
| **Submit for Translation** — Classic 특정 경로 | before/after **update** | Classic에서 Knowledge 탭으로 새 아티클을 만들어 저장한 뒤 submit for translation 하면 update 사용 가능. master-language 아티클이 현재 편집 중일 때 update 발화 — 단 list view나 아티클 조회 시에는 아님 |
| **Assign** | before/after **update** | record save가 먼저 일어나는 경우에만 호출. 즉 Assign 버튼 클릭 전에 아티클이 편집 중일 때 (*called only when*) |
| **Undelete from recycle bin** | **미발화** | 트리거를 발화시킬 수 없음 (*can't fire*) |
| **Preview, Archive** | **미발화** | 트리거를 발화시킬 수 없음 (*can't fire*) |

> 셀별 원문 대조 unique 값: `are called` / `work instead` / `fire` / `no triggers fire` / `called only when` / `can't fire`. 압축 기호 없이 원문 동사를 셀에 보존했다.

### 트리거를 발화하지 않는 액션

다음 액션은 Apex 트리거를 발화시킬 수 **없다.**

- recycle bin에서 아티클 **undelete**(복구).
- 아티클 **preview·archive**.

### Lightning 마이그레이션 영향

Salesforce Classic의 Knowledge에서 Lightning Knowledge로 마이그레이션하는 것은 Apex 트리거에 영향을 준다.

- KnowledgeArticleVersion 객체에 Apex 트리거를 작성하면 **의존성(dependency)이 생기고, KAV 객체가 삭제되는 것을 막는다.**
- 여러 article type을 가진 org를 Lightning Knowledge로 마이그레이션할 때는 **해당 KAV article type을 참조하는 Apex 트리거를 모두 제거해야 한다.**
- 마이그레이션 중에 Apex 트리거가 여전히 (마이그레이션 중 삭제되는) article type KAV 객체를 참조하면, 어드민에게 오류 메시지가 표시된다.
- 새 KAV 객체를 참조하는 Apex 트리거가 존재하는 상태에서 Lightning Knowledge 마이그레이션을 취소하면, 어드민에게 통지되고 해당 Apex 코드를 제거해야 한다.

### 코드 예제 — KAVTrigger

아티클 생성 시 요약 텍스트를 입력하는 트리거를 정의할 수 있다.

```apex
trigger KAVTrigger on KAV_Type__kav (before insert) {
    for (KAV_Type__kav kav : Trigger.New) {
        kav.Summary__c = 'Updated article summary before insert';
    }
}
```

---

## 관련 노트
- [[Trigger 컨텍스트 변수와 이벤트]] — 트리거 문법·컨텍스트 변수·이벤트별 가용성(일반 메커니즘)
- [[Trigger 벌크 관용구·미발생 작업·예외]] — 벌크 관용구·트리거 미발생 작업·addError 예외
- [[Trigger Order of Execution]] — 저장 순서 lifecycle
- [[ConnectApi Chatter 패턴]] — ConnectApi 피드 게시(Chatter 트리거의 ConnectApi 영향과 연결)
- [[KbManagement Namespace]] — Knowledge 아티클 액션(게시·번역·보관)의 Apex API
- [[Knowledge 데이터 모델 & API 개요]] — KnowledgeArticleVersion(KAV) 객체 모델 배경
