---
tags: [apex, quickaction, email-action, case-feed, describe-layout, quick-action]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-18
aliases: [QuickAction namespace, performQuickAction, describeAvailableQuickActions, QuickActionRequest, QuickActionResult, QuickActionDefaultsHandler, SendEmailQuickActionDefaults]
---

# QuickAction Namespace

> Apex에서 Quick Action을 프로그래밍적으로 실행·조회하고, Case Feed 이메일 액션의 기본값을 커스터마이징하는 API.

---

## QuickAction 클래스 (정적 메서드)

### 기본 사용 예제

```apex
// 1. 전역 액션 실행 (Contact 생성)
QuickAction.QuickActionRequest req = new QuickAction.QuickActionRequest();
req.quickActionName = QuickAction.CreateContact; // 전역 액션
Contact c = new Contact();
c.LastName = 'Smith';
req.record = c;
QuickAction.QuickActionResult res = QuickAction.performQuickAction(req);
if (res.isSuccess()) {
    System.debug('Created: ' + res.getIds());
}

// 2. 객체 레벨 액션 실행 (Account에 Contact 생성)
QuickAction.QuickActionRequest req2 = new QuickAction.QuickActionRequest();
req2.setQuickActionName(Schema.Account.QuickAction.AccountCreateContact);
req2.setContextId('001xx000003DGcO'); // 부모 Account ID
Contact c2 = new Contact();
c2.LastName = 'Jones';
req2.setRecord(c2);
QuickAction.QuickActionResult res2 = QuickAction.performQuickAction(req2);
```

### 정적 메서드 목록

| 메서드 | 서명 | 설명 |
|---|---|---|
| `performQuickAction(request)` | `QuickActionRequest → QuickActionResult` | 단일 액션 실행 (allOrNothing=true) |
| `performQuickAction(request, allOrNothing)` | `QuickActionRequest, Boolean → QuickActionResult` | 단일 액션 실행, 부분 성공 옵션 |
| `performQuickActions(requests)` | `List<QuickActionRequest> → List<QuickActionResult>` | 복수 액션 실행 |
| `performQuickActions(requests, allOrNothing)` | `List<QuickActionRequest>, Boolean → List<QuickActionResult>` | 복수 액션 실행, 부분 성공 옵션 |
| `describeAvailableQuickActions(parentType)` | `String → List<DescribeAvailableQuickActionResult>` | 지정 오브젝트의 사용 가능 액션 목록 |
| `describeQuickActions(names)` | `List<String> → List<DescribeQuickActionResult>` | 지정 액션들의 상세 메타데이터 |

```apex
// 사용 가능한 액션 목록 조회
List<QuickAction.DescribeAvailableQuickActionResult> available =
    QuickAction.describeAvailableQuickActions('Account');
// 전역 레벨: 'Global'
List<QuickAction.DescribeAvailableQuickActionResult> global =
    QuickAction.describeAvailableQuickActions('Global');

// 특정 액션의 상세 메타데이터 조회
List<QuickAction.DescribeQuickActionResult> details =
    QuickAction.describeQuickActions(new List<String>{
        'Account.QuickCreateContact',
        'Opportunity.Update1',
        'Global.CreateNewContact'
    });
```

### allOrNothing 파라미터

| 값 | 동작 |
|---|---|
| `true` (기본) | 하나라도 실패하면 전체 롤백 |
| `false` | 부분 성공 허용, 결과를 `QuickActionResult`로 확인 |

---

## QuickActionRequest 클래스

Quick Action 실행 시 입력 정보를 담는 컨테이너.

```apex
QuickAction.QuickActionRequest qar = new QuickAction.QuickActionRequest();
```

### 메서드

| 메서드 | 서명 | 설명 |
|---|---|---|
| `setQuickActionName(name)` | `String → void` | 액션 이름 설정 (예: `'Account.QuickCreateContact'`) |
| `setContextId(contextId)` | `Id → void` | 컨텍스트 레코드 ID 설정 (부모 레코드) |
| `setRecord(record)` | `SObject → void` | 액션으로 생성·수정할 레코드 설정 |
| `getQuickActionName()` | `→ String` | 설정된 액션 이름 반환 |
| `getContextId()` | `→ Id` | 설정된 컨텍스트 ID 반환 |
| `getRecord()` | `→ SObject` | 설정된 레코드 반환 |

> **참고**: API v28.0 이하에서는 `contextId` 대신 `parentId`가 사용되었음.

---

## QuickActionResult 클래스

Quick Action 실행 결과 처리용 클래스.

```apex
QuickAction.QuickActionResult res = QuickAction.performQuickAction(req);

if (res.isSuccess()) {
    System.debug('생성된 ID 목록: ' + res.getIds());
    System.debug('성공 메시지: ' + res.getSuccessMessage());
} else {
    for (Database.Error err : res.getErrors()) {
        System.debug('오류: ' + err.getMessage());
    }
}
```

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `isSuccess()` | `Boolean` | 성공 여부 |
| `isCreated()` | `Boolean` | 새 레코드 생성 여부 |
| `getIds()` | `List<Id>` | 처리된 레코드 ID 목록 |
| `getErrors()` | `List<Database.Error>` | 오류 목록 (실패 시) |
| `getSuccessMessage()` | `String` | 성공 메시지 |

---

## DescribeAvailableQuickActionResult 클래스

`describeAvailableQuickActions()` 반환값. 사용 가능한 액션의 기본 메타데이터.

```apex
List<QuickAction.DescribeAvailableQuickActionResult> results =
    QuickAction.describeAvailableQuickActions('Case');
for (QuickAction.DescribeAvailableQuickActionResult r : results) {
    System.debug(r.getName() + ' / ' + r.getLabel() + ' / ' + r.getType());
}
```

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getName()` | `String` | 액션 API 이름 |
| `getLabel()` | `String` | 액션 표시 레이블 |
| `getType()` | `String` | 액션 타입 |
| `getActionEnumOrId()` | `String` | 액션 고유 ID (없으면 API 이름) |

---

## DescribeQuickActionResult 클래스

`describeQuickActions()` 반환값. 액션의 전체 메타데이터.

### 프로퍼티 (직접 접근 가능)

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `contextsobjecttype` | `String` | 액션 컨텍스트 오브젝트 타입 (API v30+에서 `sourceSobjectType` 대체) |
| `targetsobjecttype` | `String` | 액션 대상 오브젝트 타입 |
| `targetparentfield` | `String` | 대상-부모 연결 필드 (예: Contact→Account면 `'Account'`) |
| `targetrecordtypeid` | `String` | 대상 레코드의 Record Type ID |
| `defaultvalues` | `List<DescribeQuickActionDefaultValue>` | 액션 기본값 목록 |
| `layout` | `DescribeLayoutSection` | 액션이 위치한 레이아웃 섹션 |
| `flowdevname` | `String` | 호출하는 Flow의 완전한 이름 |
| `flowrecordidvar` | `String` | Flow에 전달되는 레코드 ID 변수 (`null` 또는 `'recordId'`) |
| `height` | `Integer` | 액션 패널 높이 (px) |
| `width` | `Integer` | 액션 패널 너비 (px) |
| `iconname` | `String` | 아이콘 이름 (커스텀 아이콘 없으면 null) |
| `iconurl` | `String` | 32x32 아이콘 URL |
| `miniiconurl` | `String` | 16x16 아이콘 URL |
| `icons` | `List<Schema.DescribeIconResult>` | 테마별 아이콘 배열 |
| `colors` | `List<Schema.DescribeColorResult>` | 테마별 색상 배열 |
| `canvasapplicationname` | `String` | Canvas 앱 이름 |
| `visualforcepagename` | `String` | Visualforce 페이지 이름 |
| `visualforcepageurl` | `String` | Visualforce 페이지 URL |
| `lightningcomponentbundleid` | `String` | Aura 컴포넌트 번들 ID |
| `lightningcomponentbundlename` | `String` | Aura 컴포넌트 번들 이름 |
| `lightningcomponentqualifiedname` | `String` | Aura 컴포넌트 완전 이름 |
| `lightningwebcomponentbundleid` | `String` | LWC 번들 ID |
| `lightningwebcomponentbundlename` | `String` | LWC 번들 이름 |
| `lightningwebcomponentqualifiedname` | `String` | LWC 완전 이름 |
| `showquickactionlcheader` | `Boolean` | LC 액션 헤더/푸터 표시 여부 |
| `showquickactionvfheader` | `Boolean` | VF 액션 헤더/푸터 표시 여부 |

### 주요 게터 메서드 (프로퍼티와 동일한 값)

| 메서드 | 반환 타입 |
|---|---|
| `getName()` | `String` |
| `getLabel()` | `String` |
| `getType()` | `String` |
| `getActionEnumOrId()` | `String` |
| `getContextSobjectType()` | `String` |
| `getTargetSobjectType()` | `String` |
| `getTargetParentField()` | `String` |
| `getTargetRecordTypeId()` | `String` |
| `getDefaultValues()` | `List<DescribeQuickActionDefaultValue>` |
| `getLayout()` | `DescribeLayoutSection` |
| `getFlowDevName()` | `String` |
| `getHeight()` / `getWidth()` | `Integer` |
| `getIconName()` / `getIconUrl()` / `getMiniIconUrl()` | `String` |
| `getLightningWebComponentBundleName()` | `String` |
| `getLightningWebComponentQualifiedName()` | `String` |

---

## DescribeQuickActionDefaultValue 클래스

액션 기본값 항목 하나를 나타냄.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getField()` | `String` | 필드 API 이름 |
| `getDefaultValue()` | `String` | 해당 필드의 기본값 |

---

## DescribeQuickActionParameter 클래스

Quick Action과 연결된 파라미터 정보 (예: 에이전트 액션의 User Utterance).

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `parametername` | `String` | 파라미터 이름 |
| `parametertype` | `String` | 파라미터 타입 (`Input` 또는 `Output`) |
| `parametervalue` | `String` | 파라미터 값 |

### 메서드

| 메서드 | 반환 타입 |
|---|---|
| `getParameterName()` | `String` |
| `getParameterType()` | `String` |
| `getParameterValue()` | `String` |

---

## 레이아웃 관련 클래스

### DescribeLayoutSection

액션이 위치한 레이아웃 섹션.

| 프로퍼티 | 타입 |
|---|---|
| `collapsed` | `Boolean` |
| `layoutsectionid` | `Id` |

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getColumns()` | `Integer` | 컬럼 수 |
| `getRows()` | `Integer` | 행 수 |
| `getHeading()` | `String` | 섹션 제목 |
| `getLayoutRows()` | `List<DescribeLayoutRow>` | 행 목록 |
| `getLayoutSectionId()` | `Id` | 섹션 ID |
| `getParentLayoutId()` | `Id` | 부모 레이아웃 ID |
| `isCollapsed()` | `Boolean` | 접힌 상태 여부 |
| `isUseCollapsibleSection()` | `Boolean` | 접기 가능 여부 |
| `isUseHeading()` | `Boolean` | 헤딩 사용 여부 |

### DescribeLayoutRow

레이아웃 섹션 내 한 행.

| 메서드 | 반환 타입 |
|---|---|
| `getLayoutItems()` | `List<DescribeLayoutItem>` |
| `getNumItems()` | `Integer` |

### DescribeLayoutItem

레이아웃 행 내 하나의 아이템 (필드 또는 빈 자리).

| 메서드 | 반환 타입 |
|---|---|
| `getLabel()` | `String` |
| `getLayoutComponents()` | `List<DescribeLayoutComponent>` |
| `isEditableForNew()` | `Boolean` |
| `isEditableForUpdate()` | `Boolean` |
| `isPlaceholder()` | `Boolean` |
| `isRequired()` | `Boolean` |

### DescribeLayoutComponent

레이아웃의 최소 단위 (필드 또는 구분자).

| 메서드 | 반환 타입 |
|---|---|
| `getType()` | `String` |
| `getValue()` | `String` |
| `getDisplayLines()` | `Integer` |
| `getTabOrder()` | `Integer` |

---

## Case Feed 이메일 액션 기본값 커스터마이징

### 구조

```
QuickActionDefaultsHandler (인터페이스)
  └─ onInitDefaults(QuickActionDefaults[] actionDefaults)

QuickActionDefaults (추상 클래스, 확장 불가)
  └─ SendEmailQuickActionDefaults (구현 클래스, 인스턴스화 불가)
```

### QuickActionDefaultsHandler 인터페이스

Case Feed 이메일 액션(`Case.Email`)의 기본값을 프로그래밍적으로 지정.

```apex
global class EmailPublisherLoader implements QuickAction.QuickActionDefaultsHandler {

    global EmailPublisherLoader() {} // 반드시 빈 생성자 필요

    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = null;

        // Case.Email 액션인지 확인
        for (Integer j = 0; j < defaults.size(); j++) {
            if (defaults.get(j) instanceof QuickAction.SendEmailQuickActionDefaults
                && defaults.get(j).getTargetSObject().getSObjectType() == EmailMessage.sObjectType
                && defaults.get(j).getActionName().equals('Case.Email')
                && defaults.get(j).getActionType().equals('Email')) {
                sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(j);
                break;
            }
        }

        if (sendEmailDefaults != null) {
            Case c = [SELECT Status, Reason FROM Case
                      WHERE Id = :sendEmailDefaults.getContextId()];
            EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject();

            // BCC 주소를 케이스 사유에 따라 설정
            emailMessage.BccAddress = getBccAddress(c.Reason);

            // Reply가 아닌 경우 (페이지 최초 로드): 이메일 수 확인 후 템플릿 결정
            if (sendEmailDefaults.getInReplyToId() == null) {
                Integer emailCount = [SELECT count() FROM EmailMessage
                                      WHERE ParentId = :sendEmailDefaults.getContextId()];
                if (emailCount != null && emailCount > 0) {
                    sendEmailDefaults.setTemplateId(getTemplateId('Automatic_Response'));
                } else {
                    sendEmailDefaults.setTemplateId(getTemplateId('New_Case_Created'));
                }
                sendEmailDefaults.setInsertTemplateBody(false);
                sendEmailDefaults.setIgnoreTemplateSubject(false);
            } else {
                // Reply/Reply All: 기존 제목 유지
                sendEmailDefaults.setTemplateId(getTemplateId('Default_reply_template'));
                sendEmailDefaults.setInsertTemplateBody(false);
                sendEmailDefaults.setIgnoreTemplateSubject(true);
            }
        }
    }

    private Id getTemplateId(String apiName) {
        try {
            return [SELECT Id FROM EmailTemplate WHERE DeveloperName = :apiName].Id;
        } catch (Exception e) { return null; }
    }

    private String getBccAddress(String reason) {
        if ('Technical'.equals(reason))   return 'support_technical@mycompany.com';
        if ('Billing'.equals(reason))     return 'support_billing@mycompany.com';
        return 'support@mycompany.com';
    }
}
```

### QuickActionDefaults 메서드 (읽기 전용)

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getActionName()` | `String` | 액션 이름 (예: `'Case.Email'`, `'EmailMessage._Reply'`) |
| `getActionType()` | `String` | 액션 타입 (예: `'Email'`) |
| `getContextId()` | `Id` | 컨텍스트 Case ID |
| `getTargetSObject()` | `SObject` | 대상 SObject (EmailMessage) |

### SendEmailQuickActionDefaults 메서드

| 메서드 | 서명 | 설명 |
|---|---|---|
| `getFromAddressList()` | `→ List<String>` | From 드롭다운에 표시되는 주소 목록 |
| `getInReplyToId()` | `→ Id` | 원본 이메일 메시지 ID (Reply 시), null이면 페이지 로드 |
| `setTemplateId(id)` | `Id → void` | 로드할 이메일 템플릿 ID 설정 |
| `setInsertTemplateBody(bool)` | `Boolean → void` | `true`: 템플릿 본문을 원본 위에 삽입, `false`: 전체 대체 |
| `setIgnoreTemplateSubject(bool)` | `Boolean → void` | `true`: 원본 제목 유지, `false`: 템플릿 제목으로 대체 |

> **Lightning Experience 제한**: 이메일 첨부파일, 커스텀 이메일 필드, Visualforce 템플릿 미지원. Merge field는 Preview/Send 시 resolve됨.

---

## Trigger에서 QuickAction 감지

```apex
trigger accTrig on Contact (before insert) {
    for (Contact c : Trigger.new) {
        if (c.getQuickActionName() == QuickAction.CreateContact) {
            c.WhereFrom__c = 'GlobalAction';
        } else if (c.getQuickActionName() == Schema.Account.QuickAction.CreateContact) {
            c.WhereFrom__c = 'AccountAction';
        } else if (c.getQuickActionName() == null) {
            c.WhereFrom__c = 'NoAction';
        }
    }
}
```

---

## 관련 노트

- [[Process Namespace]] — 레거시 Flow 플러그인 (deprecated)
- [[@InvocableMethod 패턴]] — Apex를 Flow Action으로 노출하는 현행 방식
- [[Invocable Namespace]] — Apex에서 Flow Action 동적 호출
