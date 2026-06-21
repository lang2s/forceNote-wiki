---
tags: [Security, ExperienceCloud, Communities, GuestUser, AccessControl, Sharing, SOQLInjection, Flow, Apex, 보안가이드, 게스트사용자, 접근제어]
source: communities_dev.pdf (Experience Cloud Developer Guide, v66.0 Spring '26)
created: 2026-06-21
aliases: [Experience Cloud site security, guest user security, 게스트 사용자 보안, Unauthenticated Guest User, 인증 안 된 게스트 사용자, Encrypt Record IDs, 레코드 ID 암호화, UserCryptoHelper, without sharing 게스트, system mode without sharing, declarative access control, custom access control, guest user access, 게스트 사용자 레코드 접근, Limit Declarative Access, Limit Access to Apex Classes, Flow Security, Experience Cloud SOQL injection, 게스트가 레코드 만들고 나중에 읽기, encrypted token 패턴, Secure guest user record access, 게스트 컨트롤러 with without sharing 선택]
---

# Experience Cloud 사이트 보안 — 인증·게스트 사용자

> Experience Cloud 사이트를 외부·게스트 사용자에게 안전하게 노출하는 가이드 — 선언적(declarative) vs 커스텀 접근 제어 모델 선택, 게스트 레코드 read/create/update 모드(system mode·without sharing), Encrypt Record IDs 패턴(UserCryptoHelper), Apex 클래스/Flow 접근 제한, SOQL injection 방어를 게스트 맥락에서 다룬다.

---

## 챕터 맥락

Experience Cloud 사이트가 외부·인증 안 된 게스트 사용자에게 접근될 때 고려할 보안 사항이다.

- **External user** — 사이트에 로그인 권한이 있으나 내부 Salesforce org에는 접근할 수 없다.
- **Guest user** — 인터넷상의 누구나. 사이트의 공개 페이지·컴포넌트를 방문할 수 있는 익명 사용자다.

플랫폼은 인증 안 된 게스트 사용자들을 서로 구분할 수 없다. 그래서 게스트 사용자에 대해서는 종종 **모든 객체에 대한 선언적 접근을 거부**하고 커스텀 접근 제어를 직접 구현해야 한다.

> with/without sharing·USER_MODE·CRUD/FLS의 **기초 메커니즘**은 [[권한과 접근 제어 위협]]을 참조한다. 본 노트는 그 위에서 **게스트 사용자 전용 패턴**(레코드 ID 암호화·모드별 read/create/update 가이드·게스트 컨트롤러 예제)을 깊이 다룬다.

---

## Limit Declarative Access (선언적 접근 최소화)

객체 view 권한을 부여하면 외부 사용자가 **표준 컨트롤러(standard controller)**로 그 객체를 볼 수 있다. 표준 컨트롤러는 Lightning 기능이 활성화된 Experience Builder 사이트 및 Salesforce Tabs + Visualforce 사이트에서 사용 가능하며, 오직 플랫폼의 선언적 권한에만 기반해 접근을 허용한다.

- 외부 사용자가 **컨트롤러를 거치지 않고** 직접 접근해도 되는 객체에 한해서만 create/view/modify/delete 선언적 접근을 부여한다.
- 표준 UI 컨트롤러는 sharing rules, CRUD 권한, field-level security(FLS)에 인코딩된 선언적 접근 정책을 강제한다.
- 외부 사용자에게 view/update 권한을 부여하면 그들은 그 작업을 **수행할 수 있다.** 행사되길 원치 않는 권한은 어떤 객체에도 과도하게 부여하지 않는다.

---

## Determine a Security Model (보안 모델 결정)

모든 use case마다 **커스텀 접근 제어 모델**을 구현할지, **플랫폼의 선언적 접근 제어 모델**에 의존할지 결정한다. 가능하면 선언적 모델을 권장한다. 그러나 요구사항에 따라 커스텀 모델이 필요할 때가 있다.

### 커스텀 접근 제어 모델이 필요하면

1. 컨트롤러가 접근하는 객체에 대한 선언적 데이터 권한(CRUD, FLS, sharing)을 해당 user profile·permission set에서 **제거**한다. 컨트롤러는 **without sharing**으로 선언한다.
2. 각 컨트롤러에 보안 정책이 요구하는 **절차적(procedural) 접근 제어 로직**을 구현한다.

### 플랫폼의 선언적 모델을 쓸 수 있으면

1. 컨트롤러를 **with sharing**으로 선언하고, 각 profile·permission set에 sharing·CRUD 권한·FLS를 적절히 구성한다.

### 보안 모델 선택 예 — 컨트롤러로 lead 생성

lead를 생성하는 컨트롤러를 생각해 보자. 커스텀 접근 제어가 필요한 예:

- lead 생성 전 **CAPTCHA** 요구
- lead 생성 전 **referral code** 요구
- lead 생성 전 **license agreement 동의** 요구

> 위 예시들은 선언적 sharing·CRUD·FLS로 강제할 수 없는 절차적 단계를 요구한다. 이런 경우 Apex 컨트롤러에 커스텀 로직을 작성하고, 사용자가 **컨트롤러를 통해서만** 데이터에 접근하도록 lead 객체의 선언적 접근(CRUD·FLS·sharing)을 제거해야 한다. 반대로 보안 정책이 플랫폼의 CRUD·FLS·sharing 로직으로 매핑된다면 적절히 구성한 뒤 컨트롤러를 with sharing으로 선언한다.

### without-sharing 절차적 로직에 의존할 때의 리스크

- 보안 로직을 절차적 Apex 코드로 구현한다. 구현 오류나 profile/record/stateful 접근 검사를 올바로 구현하지 못하면 **무단 데이터 접근**으로 이어진다.
- 보안 정책에 stateful 로직이 필요하면 요청 간 상태를 보존하는 **커스텀 세션 관리 로직**을 구현해야 한다.
- 절차적 접근 제어 로직은 org admin이 빠르게 유지·수정하기 어렵다.

> CRUD 권한과 FLS 접근을 제거하는 것만이, 사용자가 표준 컨트롤러로 객체에 직접 접근하지 못하고 **반드시 당신의 컨트롤러를 거치게** 보장하는 유일한 방법이다.

> (PDF 스크린샷) 인쇄 p.53에 보안 모델 선택 다이어그램이 있으나 pdftotext로 추출되지 않아 본 노트에는 위 텍스트 설명만 둔다.

---

## Unauthenticated Guest User Guidelines (게스트 사용자 가이드라인)

게스트 사용자 요청은 매번, sharing rules가 요청에 적용되는지 결정하는 **모드(mode)**에서 실행된다. 모드마다 보안 함의가 다르므로 데이터 민감도를 고려해 가장 안전한 방법을 선택한다. 별도 flow나 여러 Apex 클래스를 써서 일부 요청은 한 모드로, 다른 요청은 다른 모드로 실행할 수도 있다.

> **Warning (원문):** Summer '20 릴리즈가 게스트 사용자 레코드 접근에 대한 새 설정·가이드라인을 추가했고, **Winter '21부터 이 가이드라인이 강제(enforced)**된다. Winter '21 이후로는 본 문서에 기술된 방법 중 하나를 써야 한다 — 이전 방법은 더 이상 동작하지 않는다.

### Encrypt Record IDs for Guest Users (레코드 ID 암호화) — 핵심 패턴

> 보안상, 레코드가 공개되길 원하는 게 아니라면 게스트 사용자가 **record ID로 레코드를 조회하게 허용하지 않는다.**

게스트 사용자가 레코드를 생성하고 나중에 접근하려는 경우:

1. **record ID + record creation timestamp + 현재 timestamp**의 조합으로 암호화된 문자열(encrypted string)을 만든다.
2. 이 암호화 문자열은 레코드 생성자만 가지는 **고유 식별자** 역할을 한다.
3. 나중에 요청을 처리하는 Apex 코드는 게스트 사용자에게 이 암호화 문자열을 제출하도록 요구한다.
4. Apex 코드가 문자열을 **복호화**해 record ID와 기타 식별자를 얻고, 요청된 레코드를 조회·업데이트한다.

> **Tip (원문):** **User Encryption Decryption** AppExchange 패키지는 **`UserCryptoHelper`** 클래스를 제공한다. 이 클래스는 암복호화에 **`System.Crypto`** Apex 라이브러리를 사용하고, 관련 데이터를 저장해 주며, **두 개의 template flow**를 제공한다. 이 관리형 패키지로 커스텀 레코드 ID 암호화를 구현하거나, 유사한 자체 관리형 패키지를 만든다.

> ⚠️ `UserCryptoHelper`의 실제 `System.Crypto.*` 암복호화 구현 코드는 **이 PDF에 포함되지 않는다** — AppExchange 관리형 패키지가 제공한다. 이 가이드가 보여주는 것은 **호출 측 패턴**뿐이다: `ued.UserCryptoHelper.doEncrypt(...)` / `ued.UserCryptoHelper.doDecrypt(...)` (네임스페이스 접두사 `ued`). 해당 호출 코드는 아래 [Custom Access Control Model 예제](#custom-access-control-model-examples-create-create-records)에 전수 포함된다.

**See also (원문):** Apex Developer Guide / Apex Reference Guide: Crypto Class

### Give Guest Users Access to Read Records (읽기 접근)

게스트 사용자에게 레코드 데이터 읽기를 허용하면 데이터를 공개에 노출하는 것이다.

**민감 정보 처리:** 인증 안 된 사용자에게 데이터를 반환하기 전 **모든 민감 정보를 제거**한다. 민감 정보를 담은 레코드를 조회할 때 record ID처럼 **추측 가능한(guessable)** 정보를 사용하지 않는다.

**With sharing:** with sharing으로 실행되는 read 요청은 sharing rules가 게스트 사용자에게 접근권을 주지 않는 한 레코드에 접근할 수 없다. 다음일 때 read-only 접근용 sharing rules를 고려한다.

- 레코드를 공개해 누구나 접근하게 하고 싶다.
- 다른 레코드를 노출하지 않으면서 sharing rules로 대상 레코드를 선택할 수 있다.

**Without sharing (system mode):**

> **Warning (원문):** without sharing 요청을 구현할 때, org의 민감 데이터를 의도치 않게 노출하지 않도록 요청과 응답 데이터를 신중히 설계한다.

**system mode without sharing**로 실행되는 read 요청은 시스템 레벨 접근으로 동작하며 sharing rules를 우회한다. without sharing으로 실행하면 쿼리가 **선택된 모든 레코드를 공개에 노출**한다. 다음 중 하나라도 참이면 system mode without sharing을 고려한다.

- 게스트 사용자에게 read-only 이상의 접근이 필요하다.
- 레코드를 공개하고 싶지 않다.
- 다른 레코드를 노출하지 않고는 대상 레코드를 선택할 수 없다.
- 대상 레코드가 parent-child 관계의 일부이고, child 레코드 접근이 parent에 대한 write 접근으로 제한된다. sharing rules는 게스트 사용자에게 write 접근을 줄 수 없으므로 이 경우 요청을 without sharing으로 실행한다.

**Encrypted Record IDs for Record Selection:** 게스트가 레코드를 만들고 나중에 접근해야 하면 record creation timestamp와 함께 record ID를 암호화해 암호화 문자열을 클라이언트에 반환한다. 긴 문자열을 타이핑하지 않도록 암호화 문자열이 담긴 URL을 제공한다. read 요청 시 URL에서 문자열을 꺼내 **복호화한 record ID**로 레코드를 선택한다.

**Lightning Components:** 객체 필드와 직접 연결된 Lightning 컴포넌트는 CRUD·FLS 검사를 자동 수행해 표시 여부를 결정한다. 게스트 사용자와 공유하지 않은 레코드에서는 CRUD·FLS 검사가 실패해 컴포넌트가 표시되지 않는다. 이런 레코드를 표시하려면 값을 변수에 설정하고, Apex 코드에서 그 변수를 객체 필드와 별도로 연결한다. 이 방법은 자동 CRUD·FLS 검사를 우회하므로 다음 가이드라인으로 구현한다.

- 쿼리에는 필요한 레코드 필드만 포함한다.
- 민감 필드를 client-side 코드에 전달하지 않는다.
- 클라이언트가 요구하는 필드만 클라이언트로 전달한다. 클라이언트로 보낸 모든 데이터는 공개다.

### Give Guest Users Access to Create Records (생성 접근)

게스트 사용자가 객체 레코드를 만들 수 있게 하려면 guest user profile에 해당 객체의 **create 접근**을 포함하도록 구성한다.

- 객체에 create 접근을 부여하려면 **read 접근도 부여해야 한다.** 그 객체에 read 접근이 필요 없다면, 객체의 모든 권한을 제거하고 create 로직을 **without sharing** 컨트롤러에서 실행하길 권장한다.
- **Tip (원문):** 게스트가 생성한 데이터가 자동화 프로세스에 영향을 주지 않도록 data validation을 수행한다.

**Record IDs and Guest Users:** 레코드 생성 후 응답에 record ID를 **포함하지 않는다.** 나중 접근용 고유 식별자를 만들려면 record creation timestamp와 함께 record ID를 암호화해 클라이언트에 반환한다. 레코드를 조회하면 record ID가 객체에 자동 포함되므로, 객체에서 record ID를 제거하고 클라이언트로 전달하지 않는다.

**Record Creation and Access in Apex Methods:** 게스트 사용자 sharing rules는 **트랜잭션 완료 후에** 적용된다. with sharing Apex 코드가 레코드를 만든 뒤 같은 메서드에서 그 레코드를 요청하고 게스트가 sharing rules에 의존한다면, guest sharing rules가 아직 적용되지 않아 read 요청이 **실패**한다. 같은 메서드에서 게스트가 레코드를 만들고 읽으려면 클래스를 **without sharing**으로 정의한다.

**Record Creation and Access in Flow:** flow에서 Create Records 요소는 interview가 Screen·Local Action·Pause 요소를 실행하기 전까지 레코드를 만들지 않는다. 같은 flow에서 같은 레코드를 만들고 읽으려면 레코드 생성과 조회 사이에 **screen을 삽입**하거나, Apex action에서 레코드를 읽는다.

### Give Guest Users Access to Update Records (업데이트 접근)

게스트 사용자가 레코드를 업데이트하게 하려면 **system context without sharing**에서 작업을 수행한다. 업데이트를 허용하기 전, 이전에 사용자에게 제공한 **encrypted token을 검증**하는 것이 모범 사례다. 올바른 레코드인지 확인하려면 creator 같은 레코드 정보를 검증한다.

> **Warning (원문):** Summer '20 릴리즈가 새 설정·가이드라인을 추가했고 Winter '21부터 강제된다. Winter '21 이후로는 **without sharing 모드를 반드시 사용해야** 한다 — sharing rules로는 게스트 사용자에게 update 접근을 줄 수 없기 때문이다. *(원문 마침표 2개 그대로)*

**Lightning Components and Guest Users:** **Secure guest user record access** 설정이 활성화되어 있으면 게스트 사용자에게 update 접근을 줄 수 없다 — update 권한을 요구하는 객체 권한 검사가 실패해 컴포넌트가 표시되지 않는다. 게스트 입력을 처리하려면 변수로 컴포넌트 값을 설정한 뒤 Apex 코드에서 그 변수를 레코드 필드와 별도로 연결한다. 이 방법은 자동 객체 권한·FLS 검사를 우회하므로 다음을 지킨다.

- 업데이트 전 server-side 코드로 레코드를 조회해 원하는 레코드인지 검증한다.
- 사용자에게 보여줄 게 아니면 레코드 필드를 클라이언트로 전달하지 않는다. 클라이언트로 보낸 데이터는 모두 공개다.
- record ID를 클라이언트로 전달하거나 클라이언트로부터 받지 않는다. 고유 식별자가 필요하면 record ID를 문자열로 암호화한다.
- server-side 로직으로 update를 원하는 필드로만 제한한다. server-side 동작을 client-side 코드로 결정하지 않는다.
- update 수행 전 server-side 로직으로 클라이언트 데이터를 검증한다.

---

## Declarative Access Control Model Examples (선언적 모델 — read records)

> 아래 코드·flow 예제는 **선언적 접근 제어 모델**로 인증 안 된 게스트 사용자에게 레코드 **read** 접근을 제공한다.

### Sample Flow With Sharing — Read Records (PDF 스크린샷)

게스트 사용자가 날짜 범위를 입력하면 그 범위 내 event를 본다. 게스트는 sharing rules로 read 접근을 가지므로 guest user profile이 flow가 접근할 수 있는 필드를 결정한다.

- **Flow Configuration:** 게스트가 sharing rules로 레코드에 접근하므로 **How to Run the Flow** 설정을 **User or System Context—Depends on How Flow is Launched**로 둔다.

Flow 요소 (단계 번호는 Experience Builder 스크린샷 참조 — 텍스트 설명만):

1. **Enter Date Range** — start/end date 입력 필드를 표시하는 screen. 입력 날짜를 변수 `Start_Date`·`End_Date`에 저장.
2. **Get Events** — Get Records 쿼리. 조건: `StartDateTime` > `Start_Date`, `EndDateTime` < `End_Date`, `isPrivate` = False, `isArchived` = False. 결과를 `GetEvents` 변수에 저장.
3. **Loop Records** — `GetEvents`를 순회. 루프 안 Assignment 요소가 각 event의 `StartDateTime`·`EndDateTime`·`Subject`·`Location`을 문자열에 누적.
4. **Show Events** — 모든 event를 담은 문자열을 표시하는 최종 screen.

### Sample Code With Sharing — Read Records

게스트가 날짜 범위를 입력하고 그 범위의 event를 보는 코드 모음. sharing rules로 read 접근을 가진다.

**Aura Component — DisplayEvents.cmp**

```xml
<aura:component controller="GuestUserEventsAuraController">
    <aura:attribute name="events" type="Event[]"/>
    <aura:attribute name="StartDate" type="String" default=""/>
    <aura:attribute name="EndDate" type="String" default=""/>
    <lightning:input type="datetime" name="StartDate" value="{!v.StartDate}"
        aura:id="StartDate" label="Start after: " required="true"/>
    <lightning:input type="datetime" name="EndDate" value="{!v.EndDate}" aura:id="EndDate"
        label="End before: " required="true"/>
    <lightning:button name="Submit" variant="brand" label="Find events" title="Find events"
        onclick="{!c.handleSearch}"/>
    <lightning:card title="Events">
        <p class="slds-p-horizontal--small">
            <aura:iteration items="{!v.events}" var="event">
                {!event.Subject} ({!event.Location}) starts at {!event.StartDateTime} and
                ends at {!event.EndDateTime} <br/>
            </aura:iteration>
        </p>
    </lightning:card>
</aura:component>
```

**Component Controller — DisplayEventsController.js**

```javascript
({
    handleSearch : function(component, event, helper) {
        helper.doSearch(component, event, helper);
    }
})
```

**JavaScript Helper — DisplayEventsHelper.js**

```javascript
({
    doSearch : function(component, event, helper) {
        var start_date = component.find("StartDate").get("v.value");
        var end_date = component.find("EndDate").get("v.value");
        var action = component.get("c.searchEvents");
        action.setParams({
            "start_date": start_date,
            "end_date": end_date
        });
        action.setCallback(this, function(response){
            component.set("v.events", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})
```

**Apex Controller — GuestUserEventsAuraController.cls** (with sharing)

> **Warning (원문):** 인터넷상의 어떤 시스템·개인도 @AuraEnabled 메서드를 호출할 수 있다. 절차적 접근 검사를 구현해 메서드 실행을 보호하고, 쿼리가 원하는 레코드와 필요한 필드만 선택하게 한다.

```apex
public with sharing class GuestUserEventsAuraController {
    @AuraEnabled
    public static List<Event> searchEvents(Datetime start_date, Datetime end_date){
        List<Event> results = [SELECT Event.Subject,
                                      Event.StartDateTime,
                                      Event.EndDateTime,
                                      Event.Location
                               FROM Event
                               WHERE Event.EndDateTime<:end_date AND
                                     Event.StartDateTime>:start_date AND
                                     Event.isPrivate=False AND
                                     Event.isArchived=False];
        List<Event> filtered_events = new List<Event>();
        for (Event event : results) {
            Event new_event = new Event(Subject = event.Subject,
                                        StartDateTime = event.StartDateTime,
                                        EndDateTime = event.EndDateTime,
                                        Location = event.Location);
            filtered_events.add(new_event);
        }
        return filtered_events;
    }
}
```

---

## Custom Access Control Model Examples (커스텀 모델 — create records) {#custom-access-control-model-examples-create-create-records}

> 아래 예제는 **커스텀 접근 제어 모델**로 인증 안 된 게스트 사용자에게 레코드 **create** 접근을 제공한다. (Encrypt Record IDs 패턴의 `ued.UserCryptoHelper` 호출 코드가 여기에 등장한다.)

### Sample Code Without Sharing — Create Records and Read Them Later

두 개의 분리된 상호작용을 지원한다. 첫 상호작용에서 게스트가 case를 만들고, Apex 메서드가 record ID를 암호화 문자열로 대체한다. 나중에 게스트가 그 암호화 문자열을 입력하면 Apex가 복호화해 case를 조회한다.

**Aura Component — CreateCase.cmp**

> 데모용으로 게스트가 토큰을 직접 입력하는 필드를 둔다. 실제 구현 시에는 토큰이 담긴 링크를 제공하고 URL에서 토큰을 꺼낸다.

```xml
<aura:component controller="GuestUserCreateForLater">
    <aura:attribute name="caseID" type="String"/>
    <aura:attribute name="case_status" type="String"/>
    <aura:attribute name="subject" type="String"/>
    <aura:attribute name="description" type="String"/>
    <aura:attribute name="email" type="String"/>
    Enter details to create a new case
    <lightning:input type="email" name="email" required="true" value="{!v.email}"
        aura:id="email" label="Where should we send email updates?"/>
    <lightning:input name="subject" label="Subject" required="true" value="{!v.subject}"
        aura:id="subject"/>
    <lightning:textarea name="description" required="true" label="Description"
        value="{!v.description}" aura:id="description"/>
    <lightning:button name="submit" variant="brand" label="Create case" title="Create case"
        onclick="{!c.submitCase}"/>
    <aura:if isTrue="{!v.caseID}">
        <lightning:card title="Case">
            <p class="slds-p-horizontal--small">
                New case created:
                <p>{!v.caseID}</p>
            </p>
        </lightning:card>
    </aura:if>
    Or enter an existing case token to view the status of the case
    <lightning:textarea name="existing_case" required="false" label="Existing case token"
        aura:id="existing_case"/>
    <lightning:button name="submit" variant="brand" label="Lookup case" title="Lookup case"
        onclick="{!c.lookupCase}"/>
    <aura:if isTrue="{!v.case_status}">
        <lightning:card title="Case">
            <p class="slds-p-horizontal--small">
                Case status:
                <p>{!v.case_status}</p>
            </p>
        </lightning:card>
    </aura:if>
</aura:component>
```

**Component Controller — CreateCaseController.js**

> `[sic]` PDF 원문에 `submitCase`와 `lookupCase` 메서드 사이 쉼표(`,`)가 누락되어 있다. PDF 그대로 옮긴다.

```javascript
({
    submitCase : function(component, event, helper) {
        helper.makeCase(component, event, helper);
    }
    lookupCase : function(component,event,helper){
        helper.getCase(component,event,helper);
    }
})
```

**JavaScript Helper — DisplayCaseHelper.js** — `makeCase()`는 case 생성 async 요청 후 콜백이 새 case의 고유 토큰을 `caseID`에 저장. `getCase()`는 게스트가 입력한 토큰으로 case를 async 조회 후 값을 `case_status`에 저장.

```javascript
({
    makeCase : function(component, event, helper) {
        var subject = component.find("subject").get("v.value");
        var description = component.find("description").get("v.value");
        var email = component.find("email").get("v.value");
        var action = component.get("c.CreateCase");
        action.setParams({
            "subject": subject,
            "description": description,
            "email": email
        });
        action.setCallback(this, function(response){
            component.set("v.caseID", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getCase : function(component,event,helper){
        var case_token = component.find("existing_case").get("v.value");
        var action = component.get("c.GetCase");
        action.setParams({
            "token":case_token
        });
        action.setCallback(this, function(response){
            component.set("v.case_status", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})
```

**Apex Controller — GuestUserCreateForLater.cls** — User Encryption Decryption AppExchange 패키지(`ued` 네임스페이스)로 암복호화한다. `CreateCase()`는 case를 만든 뒤 record ID·CreatedDate·현재 timestamp로 암호화 문자열을 생성해 반환한다. `GetCase()`는 제공된 문자열을 복호화·검증한 뒤 helper로 원본 레코드를 조회한다.

> 객체 권한·플랫폼 sharing에 의존하지 않으므로 클래스를 **without sharing**으로 정의한다.
> **Warning (원문):** 인터넷상의 누구나 @AuraEnabled 메서드를 호출할 수 있다. 쿼리가 새로 만든 레코드만 조회하고 필요한 필드만 선택하게 한다.
> `[sic]` PDF 원문 클래스 선언 키워드 순서가 `public class without sharing` (비표준; 통상 `public without sharing class`). PDF 그대로 옮긴다.

```apex
public class without sharing GuestUserCreateForLater {
    @AuraEnabled
    public static String CreateCase(String subject,
                                    String description,
                                    String email){
        Case new_case = new Case(Subject=subject,
                                 Description=description,
                                 SuppliedEmail=email);
        insert new_case;
        List<Case> results = getCase(new_case.Id);

        String encryptedID = ued.UserCryptoHelper.doEncrypt(results[0].Id+'|'+
            results[0].CreatedDate.getTime() +'|'+System.DateTime.now().getTime());
        return encryptedID;
    }
    public static final Long validTimestampMinutes = 10;
    @AuraEnabled
    public static String GetCase(String token){
        String status = 'Case not found';
        String decrypted_token = '';
        try {
            decrypted_token = ued.UserCryptoHelper.doDecrypt(token);
        } catch(Exception e) {
            return status;
        }
        String[] decrypted_parts = decrypted_token.split('\\|');
        String decryptedRecordId = decrypted_parts[0];
        String created_timestamp = decrypted_parts[1];
        String original_request_timestamp = decrypted_parts[2];

        if( isTimestampValid(System.Long.valueOf(original_request_timestamp)) ){
            List<Case> caseList = getCase(decryptedRecordId, created_timestamp);
            if(caseList.size() == 1){
                status = caseList[0].Status;
            }else{
                status = 'Case not found';
            }
        }
        return status;
    }
    private static List<Case> getCase(String caseID, Datetime created_date)
    {
        List<Case> results = [SELECT Case.CaseNumber, Case.CreatedDate, Case.Status
                              FROM Case
                              WHERE Case.Id=:caseID AND Case.CreatedDate=:created_date];
        return results;
    }
    private static Boolean isTimestampValid(Long timestamp)
    {
        return ((System.now().getTime() - timestamp) / 60000) < validTimestampMinutes;
    }
}
```

> **Note (원문):** 매우 민감한 정보를 다룬다면 보안 강화를 위해 다음을 고려한다.
> - 사용자가 읽거나 수정하려는 데이터와 관련해 **본인만 아는 추가 정보**를 입력하게 한다.
> - 데이터를 읽거나 수정하려면 **로그인을 요구**한다.

### Sample Flow — Create Records (PDF 스크린샷)

게스트가 피드백을 입력하면 flow가 custom object 레코드에 저장한다. 게스트는 생성 후 레코드를 읽을 수 없다.

**Custom `Feedback__c` Object** — 필드:

- `Email__c` — Required. 게스트의 이메일. 데이터 타입 **Email**.
- `Score__c` — Required. 게스트가 입력한 피드백 점수. 가능 값 **0, 1, 2, 3, 4, 5**.
- `Additional_comments__c` — 추가 피드백. 데이터 타입 **Long Text Area**.

**Flow Configuration:** 어떤 레코드에도 read 접근이 필요 없고 객체 권한에 의존하지 않으므로 **How to Run the Flow**를 **System Context without Sharing—Access All Data**로 둔다.

Flow 요소 (텍스트만):

1. **Feedback Form** — Email 컴포넌트(이메일), Slider 컴포넌트(0~5 정수 점수), Long Text Area 컴포넌트(추가 의견)를 표시하는 screen.
2. **Create Records** — `Feedback__c` 레코드를 만드는 Create Records 요소.
3. **End Screen** — 감사 텍스트를 표시하는 최종 screen.

### Sample Code Without Sharing — Create and Read Records in the Same Transaction

게스트가 지원 이슈를 입력하면 Apex가 case를 만들고, Apex 메서드가 새 레코드를 조회해 Aura 컴포넌트가 일부를 게스트에게 표시한다. 객체 권한·플랫폼 sharing에 의존하지 않으므로 **without sharing**으로 실행한다.

**Aura Component — CreateCase.cmp** — 생성 후 `lightning:card`가 새 case의 case number와 status를 표시.

```xml
<aura:component controller="GuestUserCreateCase">
    <aura:attribute name="caseNumber" type="String"/>
    <aura:attribute name="status" type="String"/>
    <aura:attribute name="subject" type="String" default=""/>
    <aura:attribute name="description" type="String" default=""/>
    <aura:attribute name="email" type="String" default=""/>
    <aura:attribute name="name" type="String" default=""/>
    <aura:attribute name="reason" type="String"/>
    <aura:attribute name="type" type="String" default=""/>
    <lightning:select name="select" label="Reason" required="true" value="{!v.reason}"
        aura:id="reason">
        <option value="installation">Installation</option>
        <option value="equipmentcomplexity">Equipment Complexity</option>
        <option value="performance">Performance</option>
        <option value="breakdown">Breakdown</option>
        <option value="equipmentdesign">Equipment Design</option>
        <option value="feedback">Feedback</option>
        <option value="other">Other</option>
    </lightning:select>
    <lightning:select name="type" label="Type" required="true" value="{!v.type}"
        aura:id="type">
        <option value="mechanical">Mechanical</option>
        <option value="electrical">Electrical</option>
        <option value="electronic">Electronic</option>
        <option value="structural">Structural</option>
        <option value="other">Other</option>
    </lightning:select>
    <lightning:input type="email" name="email" required="true" value="{!v.email}"
        aura:id="email" label="Where should we send email updates?"/>
    <lightning:input name="name" label="Name" required="true" value="{!v.name}"
        aura:id="name"/>
    <lightning:input name="subject" label="Subject" required="true" value="{!v.subject}"
        aura:id="subject"/>
    <lightning:textarea name="description" required="true" label="Description"
        value="{!v.description}" aura:id="description"/>
    <lightning:button name="submit" variant="brand" label="Submit case" title="Submit case"
        onclick="{!c.submitCase}"/>
    <aura:if isTrue="{!v.caseNumber}">
        <lightning:card title="Case">
            <p class="slds-p-horizontal--small">
                {!v.caseNumber} has status {!v.status}.
            </p>
        </lightning:card>
    </aura:if>
</aura:component>
```

**Component Controller — CreateCaseController.js**

```javascript
({
    submitCase : function(component, event, helper) {
        helper.makeCase(component, event, helper);
    }
})
```

**JavaScript Helper — DisplayCaseHelper.js**

```javascript
({
    makeCase : function(component, event, helper) {
        var subject = component.get("v.subject");
        var description = component.get("v.description");
        var email = component.get("v.email");
        var name = component.get("v.name");
        var reason = component.get("v.reason");
        var type = component.get("v.type");

        var action = component.get("c.CreateCase");
        action.setParams({
            "subject": subject,
            "description": description,
            "email": email,
            "name": name,
            "reason": reason,
            "caseType": type
        });
        action.setCallback(this, function(response){
            component.set("v.caseNumber", response.getReturnValue()[0]);
            component.set("v.status", response.getReturnValue()[1]);
        });
        $A.enqueueAction(action);
    }
})
```

**Apex Controller — GuestUserCreateCase.apxc** (without sharing) — 레코드를 만들고 조회해 필요한 필드만 반환한다. 의도치 않은 노출을 막기 위해 `CreateCase`는 `CaseNumber`와 `Status`만 반환한다.

> **Warning (원문):** 인터넷상의 누구나 @AuraEnabled 클래스를 호출할 수 있다. 메서드가 새 레코드의 필요한 필드만 반환하게 한다.
> 참고: Aura helper의 `setParams`는 7개 인자를 보내며 `phone`을 보내지 않지만, Apex `CreateCase`는 `String phone`을 8번째 파라미터로 선언한다. PDF 원문 그대로이며 불일치는 PDF 자체의 것이다.

```apex
public without sharing class GuestUserCreateCase {
    @AuraEnabled
    public static List<String> CreateCase(String subject,
                                          String description,
                                          String email,
                                          String name,
                                          String reason,
                                          String caseType,
                                          String phone){
        Case new_case = new Case(Subject=subject,
                                 Description=description,
                                 SuppliedEmail=email,
                                 SuppliedName=name,
                                 Reason=reason,
                                 Type=caseType,
                                 SuppliedPhone=phone);
        insert new_case;
        List<Case> results = getCase(new_case.Id);
        List<String> response = new List<String>();
        response.add(results[0].CaseNumber);
        response.add(results[0].Status);
        return response;
    }
    private static List<Case> getCase(String caseID)
    {
        List<Case> results = [SELECT CaseNumber, Status
                              FROM Case
                              WHERE Case.Id=:caseID];
        return results;
    }
}
```

### Sample Flow Without Sharing — Create and Read Records in One Flow (PDF 스크린샷)

게스트가 지원 이슈를 입력하면 flow가 case를 만든다. 생성 후 default active user가 레코드 소유자가 되고 게스트는 직접 접근권이 없다. flow는 새 case를 조회해 `CaseNumber`·`Status`를 게스트에게 표시한다. 생성 후 게스트가 레코드를 소유하지 않고 flow가 레코드를 조회해야 하므로 flow를 **without sharing**으로 실행한다.

**Flow Configuration:** **How to Run the Flow**를 **System Context Without Sharing—Access All Data**로 둔다.

Flow 요소 (텍스트만):

1. **Case Form** — 입력 컴포넌트를 표시하는 screen: 회사명(Text), 제출자명(Name), 제출자 이메일(Email), 제출자 전화(Phone), record type의 `Type_Options` 필드 옵션 값을 가진 Picklist, `Reason_Options` 필드 옵션 값을 가진 Picklist, case 제목(Text), case 설명(Long Text Area).
2. **Assignment** — 입력 컴포넌트 데이터를 새 Case record 변수에 할당.
3. **Create Records** — Case record 변수로 Case를 만든다. 게스트 입력 외에 case의 origin 필드를 **Web**으로 설정.
4. **Get Records** — (Create Records가 자동 정의한) `Id` 필드로 새 레코드를 조회. 새 Case record 변수에 저장.
5. **End Screen** — Get Record 변수의 `CaseNumber`·`Status`를 표시하는 최종 screen.

### Sample Code Without Sharing — Create Records and Update Them Later

두 개의 분리된 상호작용을 지원한다. 첫 상호작용에서 게스트가 case를 만들고 Apex가 record ID를 암호화 문자열로 대체한다. 나중에 게스트가 그 문자열을 입력하면 Apex가 복호화해 record ID를 얻고, 그 ID로 case를 선택해 status를 업데이트한다.

**Aura Component — CreateCase.cmp**

> 데모용으로 게스트가 토큰을 직접 입력한다. 실제로는 토큰이 담긴 링크를 제공하고 URL에서 토큰을 꺼낸다.

```xml
<aura:component controller="GuestUserCreateForLater">
    <aura:attribute name="caseID" type="String"/>
    <aura:attribute name="case_status" type="String"/>
    <aura:attribute name="subject" type="String"/>
    <aura:attribute name="description" type="String"/>
    <aura:attribute name="email" type="String"/>
    Enter details to create a new case
    <lightning:input type="email" name="email" required="true" value="{!v.email}"
        aura:id="email" label="Where should we send email updates?"/>
    <lightning:input name="subject" label="Subject" required="true" value="{!v.subject}"
        aura:id="subject"/>
    <lightning:textarea name="description" required="true" label="Description"
        value="{!v.description}" aura:id="description"/>
    <lightning:button name="submit" variant="brand" label="Create case" title="Create case"
        onclick="{!c.submitCase}"/>
    <aura:if isTrue="{!v.caseID}">
        <lightning:card title="Case">
            <p class="slds-p-horizontal--small">
                New case created:
                <p>{!v.caseID}</p>
            </p>
        </lightning:card>
    </aura:if>
    Or enter an existing case token to close the case
    <lightning:textarea name="existing_case" required="false" label="Existing case token"
        aura:id="existing_case"/>
    <lightning:button name="submit" variant="brand" label="Close case" title="Close case"
        onclick="{!c.updateCase}"/>
    <aura:if isTrue="{!v.case_status}">
        <lightning:card title="Case">
            <p class="slds-p-horizontal--small">
                Case status:
                <p>{!v.case_status}</p>
            </p>
        </lightning:card>
    </aura:if>
</aura:component>
```

**Component Controller — CreateCaseController.js**

```javascript
({
    submitCase : function(component, event, helper) {
        helper.makeCase(component, event, helper);
    },
    updateCase : function(component,event,helper){
        helper.updateCase(component,event,helper);
    }
})
```

**JavaScript Helper — CaseHelper.js** — `makeCase()`는 case 생성 async 요청 후 새 case의 고유 토큰을 `caseID`에 저장. `updateCase()`는 게스트가 입력한 토큰으로 매칭 case를 async 업데이트 후 값을 `case_status`에 저장.

```javascript
({
    makeCase : function(component, event, helper) {
        var subject = component.find("subject").get("v.value");
        var description = component.find("description").get("v.value");
        var email = component.find("email").get("v.value");
        var action = component.get("c.CreateCase");
        action.setParams({
            "subject": subject,
            "description": description,
            "email": email
        });
        action.setCallback(this, function(response){
            component.set("v.caseID", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    updateCase : function(component,event,helper){
        var case_token = component.find("existing_case").get("v.value");
        var action = component.get("c.UpdateCase");
        action.setParams({
            "token":case_token
        });
        action.setCallback(this, function(response){
            component.set("v.case_status", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})
```

**Apex Controller — GuestUserCreateForLater.cls** — User Encryption Decryption AppExchange 패키지(`ued`)를 사용. `CreateCase()`는 case를 만들고 record ID·CreatedDate·현재 timestamp로 암호화 문자열을 생성, 새 case의 ID를 암호화 문자열로 대체한다. `UpdateCase()`는 제공된 문자열을 복호화·검증한 뒤 정보를 사용해 원본 레코드 status를 업데이트한다.

> 이 클래스는 레코드에 직접 접근하지 않으므로 **with sharing**으로 정의한다. 데이터 접근은 `GuestUserCaseHelperWS`(without sharing)에 위임한다. (PDF 원문 그대로)
> **Warning (원문):** 인터넷상의 누구나 @AuraEnabled 클래스를 호출할 수 있다. 쿼리가 올바른 레코드만 업데이트하게 한다.

```apex
public with sharing class GuestUserCreateForLater {
    @AuraEnabled
    public static String CreateCase(String subject,
                                    String description,
                                    String email){
        Case new_case = new Case(Subject=subject,
                                 Description=description,
                                 SuppliedEmail=email);
        insert new_case;
        List<Case> results = GuestUserCaseHelperWS.getCase(new_case.Id);

        String encryptedID = ued.UserCryptoHelper.doEncrypt(results[0].Id+'|'+
            results[0].CreatedDate.getTime() +'|'+System.DateTime.now().getTime());
        return encryptedID;
    }
    public static final Long validTimestampMinutes = 10;
    @AuraEnabled
    public static String UpdateCase(String token){
        String status = 'Case not found';
        String decrypted_token = '';
        try {
            decrypted_token = ued.UserCryptoHelper.doDecrypt(token);
        } catch(Exception e) {
            return status;
        }
        String[] decrypted_parts = decrypted_token.split('\\|');
        String decryptedRecordId = decrypted_parts[0];
        String created_timestamp = decrypted_parts[1];
        String original_request_timestamp = decrypted_parts[2];

        if( isTimestampValid(System.Long.valueOf(original_request_timestamp))) {
            List<Case> caseList = GuestUserCaseHelperWS.getCase(decryptedRecordId,
                created_timestamp);
            if(caseList.size() == 1){
                Case case_to_update = caseList[0];
                case_to_update.Status = 'Closed';
                try {
                    GuestUserCaseHelperWS.updateCase(case_to_update);
                    status = 'Closed';
                } catch(DmlException e){
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            }else{
                status = 'Case not found';
            }
        }
        return status;
    }
    private static Boolean isTimestampValid(Long timestamp)
    {
        return ((System.now().getTime() - timestamp) / 60000) < validTimestampMinutes;
    }
}
```

**Apex Helper Class — GuestUserCaseHelperWS.apxc** (without sharing) — ID로 레코드를 조회하고 레코드를 업데이트하는 메서드를 정의한다. without sharing이므로 sharing을 요구하지 않고 조회·업데이트할 수 있다.

```apex
public without sharing class GuestUserCaseHelperWS {
    public static List<Case> getCase(String caseID, Datetime created_date)
    {
        List<Case> results = [SELECT Case.CaseNumber, Case.CreatedDate, Case.Status
                              FROM Case
                              WHERE Case.Id=:caseID AND Case.CreatedDate=:created_date];
        return results;
    }
    public static Case updateCase(Case case_to_update)
    {
        update case_to_update;
        return case_to_update;
    }
}
```

> `[sic]` PDF 원문은 WHERE 절이 `Case.Id=:caseIDAND Case.CreatedDate`로 `caseID`와 `AND`가 공백 없이 붙은 조판 오류다(pdftoppm 이미지로 확인). 올바른 Apex는 `caseID AND`이므로 가독성을 위해 위 코드에는 띄어 표기했다.

---

## Limit Access to Apex Classes (Apex 클래스 접근 제한)

게스트·외부 사용자에게는 그들이 반드시 호출해야 하는 클래스에만 접근을 허용한다.

Apex 클래스가 **@InvocableMethod, @AuraEnabled, @RestResource, webservice** 처럼 공개 노출 메서드를 포함하면, 게스트·외부 사용자가 임의 파라미터로 이 메서드를 호출할 수 있다. 단, 그들은 Apex 클래스를 실행할 권한이 있어야 한다.

- 특정 permission set·profile을 가진 사용자로 Apex 클래스 접근을 **제한**할 것을 권장한다.
- 게스트·외부 사용자에게 Apex 클래스 전체 접근을 허용하는 것은 안전하지 않다.
- 어떤 사용자가 어떤 Apex 클래스를 호출해야 하는지 신중히 고려해 역할별 permission set을 만들고, 필요한 permission set에 대해서만 Apex 클래스를 활성화한다.

---

## Flow Security (Flow 보안)

게스트·외부 사용자가 flow를 실행해야 하면, 모든 flow 실행을 허용하지 말고 **특정 외부 user profile·permission set·site guest user profile에만** flow 접근을 부여하도록 flow 권한을 override한다. 가능하면 system context에서 flow를 실행하지 말고, subflow 접근을 제한한다. 그렇지 않으면 그 flow·subflow에 절차적 접근 제어를 구현한다.

- Flow는 객체·Apex 클래스 접근에 대한 플랫폼 보안 설정을 **override할 수 있는** 강력한 기능이다. permission set을 활성화·비활성화할 수도 있다.
- screen flow는 브라우저가 구동하며 **user-controlled input 파라미터**를 받는다. 따라서 run flow 권한을 override해 게스트·외부 사용자 profile·permission set 기준으로 특정 flow에만 접근을 부여할 것을 권장한다. 게스트 사용자의 경우 해당 사이트의 guest user profile에 flow 접근 정책을 구성한다.
- subflow 실행 권한은 제거하는 것이 좋은 보안 관행이다. 보안 관점에서 flow 두 개를 따로 만들어 사용자가 직접 실행하는 flow에만 접근을 주고 subflow로 실행되는 flow에는 주지 않는 편이 낫다. **최상위 부모 flow에만 접근을 부여**하고 subflow에는 부여하지 않는다. flow가 호출하는 invocable Apex 메서드에도 같은 권고가 적용된다.

**screen flow 실행 권한이 있는 사용자가 할 수 있는 것:**

- 언제든 원하는 파라미터로 flow를 호출.
- 언제든 flow를 취소.

**subflow(다른 flow에서 호출된 flow)에도 적용 — flow 사용자가 할 수 있는 것:**

- screen flow의 input(start) 변수를 보고 수정.
- screen subflow가 부모 flow로 반환하는 output 변수를 봄.
- subflow 실행 권한이 있으면 subflow의 input 변수를 수정.

> 위 능력 중 하나라도 보안 정책을 위반하면 subflow를 사용하지 않는다. 예를 들어 billing 정보 등 기밀 정보를 subflow가 다룬다면, 비즈니스 로직을 main flow에 둔다.

---

## SOQL Injection (게스트 맥락)

dynamic SOQL 쿼리에 전달되는 user-controlled 데이터를 sanitize한다.

SOQL/SOSL injection은 Apex 코드가 user-controlled 데이터를 적절한 sanitize 없이 dynamic SOQL/SOSL 쿼리에 삽입할 때 발생한다. 두 가지 시나리오가 있다.

- 쿼리의 전체 구조를 변경
- 쿼리 파라미터의 값을 변경

> SOQL injection의 일반 메커니즘·정의는 [[SOQL Injection 위협]]을 참조한다. 본 노트는 Experience Cloud 게스트 사용자가 @AuraEnabled 메서드를 임의 입력으로 호출하는 맥락에서 PDF가 제시하는 취약/수정 코드를 둔다.

**취약 코드 (Consider this code):**

```apex
@AuraEnabled
public static List<Account> getAccountName(string userId) {
    if (FeatureManagement.checkPermission('readAccount')) {
        string query='SELECT Name FROM Account WHERE Id=\''+ userId + '\'';
        return database.query(query);
    }
}
```

> 사용자가 쿼리를 통제하게 되어, 권한이 없는 정보까지 접근할 수 있다. 쿼리 반환값은 사용자가 접근할 수 있는 정보를 제한하지 않는다. 사용자는 다음과 같은 문자열을 제출할 수 있다.

**공격 입력 예:**

```apex
userId = '0035Y00003pPJiNQAW\' OR AnnualRevenue>100000.00 OR Name=\'a'
// 0035Y00003pPJiNQAW is any id to any object that is not an account
```

> 이 쿼리의 반환값은 연 매출 $100,000 초과인 모든 account를 나열한다 — 개발자가 호출자에게 반환하려던 것이 아니다.

**수정 가이드라인 (적절한 contextual encoding 필요):**

> 모든 user input에 `String.escapeSingleQuotes`를 적용하지 않는다. SOQL/SOSL 쿼리에서 입력이 **어디에 나타나는지**에 따라 필드를 sanitize한다.

- **WHERE (SOQL), ORDER BY (SOQL), WITH (SOSL), FIND (SOSL)** 절의 변수 → **bound variable**을 사용한다:

  ```apex
  string query='SELECT Name FROM Account WHERE Id=:userId';
  ```

- **field·table 이름** → 필드의 `describeResult`에 `isAccessible`을 호출한다. 또는 선언적 정책을 강제하려면 보안 정책이 허용하는 필드·table 이름으로 제한하는 자체 절차적 로직을 사용한다.
- **quoted string 안의 파라미터** → bind variable을 사용한다. table·field 이름이나 quoted context 밖의 파라미터를 sanitize하는 데 bind variable이나 `String.escapeSingleQuote`를 사용하지 않는다. *(원문 `String.escapeSingleQuote` — 끝 s 없음. 정확한 메서드명은 `String.escapeSingleQuotes`다.)*
- **그 외 primitive 타입** → user input을 boolean·integer·Id 등 primitive(non-string) 타입으로 캐스팅한다.

> **`WITH SECURITY_ENFORCED` 키워드는 WHERE 절을 sanitize하지 않고 SELECT·FROM 절만 sanitize하므로, SOQL/SOSL injection 공격의 sanitizer가 아니다.**

---

## 관련 노트

- [[권한과 접근 제어 위협]] — with/without sharing·USER_MODE·CRUD/FLS 기초 메커니즘
- [[SOQL Injection 위협]] — SOQL injection 일반 메커니즘과 방어
- [[Experience Cloud 사이트 — CSP·Locker·LWS]] — 같은 가이드의 CSP·Lightning Locker·LWS 사이트 보안
- [[Experience Builder Aura 사이트 개발]] — Secure Custom Components, Experience Builder 컴포넌트 개발 (형제 노트, PII 가시성 설정과 연관)
