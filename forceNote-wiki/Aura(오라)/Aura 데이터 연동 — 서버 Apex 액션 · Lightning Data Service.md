---
tags: [aura, lightning-components, apex, auraEnabled, server-side-action, lightning-data-service, force-recordData, data-access]
source: lightningAura.pdf (Lightning Aura Components Developer Guide, v67.0 Summer '26)
created: 2026-07-11
aliases: [Aura 서버 액션, Aura Apex 연동, AuraEnabled, cacheable, force:recordData, Lightning Data Service Aura, enqueueAction, action state, setStorable, setBackground, AuraHandledException, recordUpdated, saveRecord, getNewRecord, deleteRecord, 서버측 컨트롤러, 옛 데이터가 오나]
---

# Aura 데이터 연동 — 서버 Apex 액션 · Lightning Data Service

> Aura에서 Salesforce 데이터를 다루는 두 축 — 커스텀 로직이 필요하면 `@AuraEnabled` Apex 서버 액션(SOQL·트랜잭션·미지원 객체)을, 선언적 CRUD면 `force:recordData`(Lightning Data Service)를 쓴다. LWC의 `@salesforce/apex`(wire/imperative)와 `@wire(getRecord)`의 Aura 짝.

---

## 언제 Apex vs Lightning Data Service

> PDF 원문(Using Apex): *"Use Apex only if you need to customize your user interface to do more than what Lightning Data Service allows, such as using a SOQL query to select certain records. Apex provisions data that's not managed and you must handle data refresh on your own."*

Apex를 쓰는 시나리오(PDF 전수):

- User Interface API가 지원하지 않는 객체(예: **Task, Event**)를 다룰 때
- User Interface API가 지원하지 않는 연산 — 조건으로 레코드 목록 로드(예: Amount > $1M인 Account 상위 200개)
- 트랜잭션 연산 — 예: Account 생성 후 연결된 Opportunity 생성, 하나라도 실패하면 전체 롤백
- 메서드를 명령형(imperative)으로 호출 — 버튼 클릭 응답, 또는 임계 경로 밖으로 로딩 지연

그 외에는 `force:recordData` / `lightning:record*Form`이 더 쉽다. LDS는 **필드 레벨 보안·공유·데이터 로딩/리프레시를 자동 관리**하지만, Apex로 provision한 데이터는 **직접 리프레시**해야 한다(Apex 메서드 재호출).

---

# 파트 A — 서버 Apex 액션 (Using Apex)

## Server-Side Controller Overview

이벤트는 항상 클라이언트측(JavaScript) 컨트롤러 액션에 연결되고, 그것이 다시 Apex 서버측 컨트롤러 액션을 호출할 수 있다. 서버측 액션은 클라이언트→서버→클라이언트로 왕복하므로 클라이언트측 액션보다 느리다.

`@AuraEnabled`로 **명시적으로 어노테이션한 메서드만** 노출된다. 서버측 액션 호출은 org의 **API 한도에 카운트되지 않지만**, Apex로 작성되므로 모든 일반 Apex 한도가 **액션당** 적용된다.

```apex
public with sharing class SimpleServerSideController {
    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static String serverEcho(String firstName) {
        return ('Hello from the server, ' + firstName);
    }
}
```

`@AuraEnabled` 컨트롤러 요구사항(PDF 전수):

- 메서드는 **static**이어야 하며 **public 또는 global**로 표시. 비-static 메서드는 지원 안 됨.
- 메서드가 객체를 반환하면, 그 객체의 인스턴스 필드 값을 조회하는 인스턴스 메서드는 **public**이어야 한다.
- 클라이언트측·서버측 액션에 **고유한 이름**을 쓴다. Apex 메서드와 같은 이름의 JS 함수는 디버그하기 어려운 문제를 유발한다(debug 모드에서 브라우저 콘솔 경고).

> Tip(PDF): 컨트롤러(클라·서버 양쪽)에 컴포넌트 상태를 저장하지 말고, 컴포넌트의 클라이언트측 attribute에 저장한다.

Developer Console에서 생성 → `<aura:component controller="SimpleServerSideController">`로 `controller` 시스템 attribute를 통해 컴포넌트에 연결한다.

## `@AuraEnabled` 어노테이션 — 두 용도 (오버로드)

`@AuraEnabled`는 오버로드되어 별개의 두 목적에 쓰인다:

- **Apex 클래스 static 메서드**에 붙여 Lightning 컴포넌트의 원격 컨트롤러 액션으로 접근 가능하게 함
- **Apex 인스턴스 메서드·프로퍼티**에 붙여, 클래스 인스턴스가 서버측 액션 데이터로 반환될 때 **직렬화(serializable)** 되게 함

Important 제약(PDF 전수):

- 같은 Apex 클래스에서 두 용도를 **혼용(mix-and-match)하지 말 것**
- **static `@AuraEnabled` 메서드만** 클라이언트측 코드에서 호출 가능. Visualforce식 인스턴스 프로퍼티·getter/setter는 사용 불가 — 클라이언트측 컴포넌트 attribute를 대신 쓴다.
- Aura 컴포넌트가 호출하는 Apex 메서드의 **파라미터·반환값으로 Apex inner class를 쓸 수 없다**
- Aura 컴포넌트에서 참조하는 `@AuraEnabled` Apex 메서드에는 **`@NamespaceAccessible` 어노테이션을 쓸 수 없다**

> 보안: `@AuraEnabled` 메서드는 **모두 웹 서비스 인터페이스처럼 취급**하라 — 공격자가 임의 파라미터로 호출할 수 있다고 가정한다. **API 버전 50.0 이상**에서는 `@AuraEnabled` 메서드를 담은 Apex 클래스에 대해 **어떤 사용자가 접근 가능한지 반드시 지정**해야 한다(프로필 또는 권한 세트).

## `@AuraEnabled(cacheable=true)` — 결과 캐싱 ("왜 옛 데이터가 오나")

런타임 성능 개선을 위해 메서드 결과를 클라이언트에 캐시한다. `cacheable=true`로 설정하려면 메서드는 **데이터를 가져오기만(get)** 해야 하며 **데이터를 변경할 수 없다**.

```apex
@AuraEnabled(cacheable=true)
public static Account getAccount(Id accountId) {
    // your code here
}
```

- **API 버전 44.0 이상**의 컴포넌트에서 Apex 결과를 캐시하려면 메서드에 `@AuraEnabled(cacheable=true)`를 어노테이션해야 한다.
- 44.0 **이전**에는 그 메서드를 호출하는 **모든 액션마다 JS에서 `setStorable()`을 호출**해야 했다. 44.0 이상에서는 Apex 메서드를 storable로 표시하고 JS의 `setStorable()` 호출을 제거할 수 있다 — 캐싱 표기를 Apex 클래스에 중앙화하므로 어노테이션 방식이 더 낫다.
- 클라이언트측 저장소는 Lightning Experience·Salesforce 모바일 앱에서 자동 구성된다. 컴포넌트는 **캐시 지속 시간을 가정하면 안 된다**(플랫폼 최적화에 따라 변할 수 있음).

> 캐시된 데이터가 stale이면 프레임워크가 서버에서 최신 데이터를 다시 가져온다 → **콜백이 두 번 호출될 수 있다**(먼저 캐시 데이터, 다음에 서버 최신 데이터). "왜 옛 데이터가 먼저 오나"의 원인. 상세는 아래 [Storable Actions](#storable-actions--setstorable) 참조.

## 클라이언트에서 서버 액션 호출하기

호출 흐름: `component.get("c.method")` → `action.setParams(...)` → `action.setCallback(...)` → `$A.enqueueAction(action)`.

```javascript
// SimpleServerSideController의 serverEcho를 호출하는 클라이언트측 컨트롤러 (PDF 발췌)
({
    "echo" : function(cmp) {
        // create a one-time use instance of the serverEcho action
        var action = cmp.get("c.serverEcho");
        action.setParams({ firstName : cmp.get("v.firstName") });
        // Create a callback that is executed after the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // value returned from the server
                alert("From server: " + response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // optionally set storable, abortable, background flag here
        $A.enqueueAction(action);
    }
})
```

각 호출의 의미(PDF):

| 호출 | 역할 |
|---|---|
| `cmp.get("c.serverEcho")` | `serverEcho` 서버측 메서드를 가리키는 액션 생성. `c.` 뒤 이름이 Apex 메서드명과 정확히 일치해야 함 |
| `action.setParams({ firstName: ... })` | 서버측 컨트롤러에 전달할 데이터 설정. 페이로드는 JSON으로 직렬화됨 |
| `action.setCallback(this, fn)` | 서버측 액션 반환 후 호출될 콜백 설정 |
| `response.getState()` | 서버에서 반환된 액션 상태 |
| `response.getReturnValue()` | 서버가 반환한 값 |
| `response.getError()` | 에러 배열(`errors[0].message`) |
| `$A.enqueueAction(action)` | 실행 큐에 액션 추가. 이벤트 루프 끝에 실행되며, 여러 액션을 **boxcar**로 묶어 요청 수를 줄임 |

- 액션은 서버로 **비동기 전송**되며 **임의 순서로 실행·반환**될 수 있다. 콜백도 비동기이며 액션과 다른 순서로 실행될 수 있다.
- 콜백 안에서 그 클라이언트측 컨트롤러에 연결된 컴포넌트를 참조할 때는 **`cmp.isValid()` 체크가 불필요**하다 — 프레임워크가 유효성을 자동 확인한다.
- `action.setParams()`는 원시 타입(BLOB 제외 primitive)·Object·sObject·List·Map·Date/DateTime/Time 등 다양한 타입을 전달할 수 있고 프레임워크가 대응 Apex 타입으로 역직렬화한다.

### action state 전수 — 콜백 분기 처리

`response.getState()`가 가질 수 있는 상태(PDF 전수):

| 상태 | 의미 |
|---|---|
| `NEW` | 액션이 생성되었으나 아직 진행 전 |
| `RUNNING` | 액션 진행 중 |
| `SUCCESS` | 액션이 성공적으로 실행됨 |
| `ERROR` | 서버가 에러를 반환함 |
| `INCOMPLETE` | 서버가 응답을 반환하지 않음. 서버 다운 또는 클라이언트 오프라인일 수 있음. 소켓이 열리지 않거나 갑자기 닫히거나 네트워크 에러가 나면 XHR이 resolve되며 콜백이 `INCOMPLETE` 상태로 호출됨. 프레임워크는 **컴포넌트가 유효한 한 콜백이 항상 호출됨을 보장**한다 |
| `ABORTED` | 액션이 중단됨. **이 상태는 deprecated.** aborted 액션의 콜백은 **명시적으로 핸들러를 추가한 경우에만** 실행됨 |

> 실무 콜백은 보통 `SUCCESS` / `INCOMPLETE` / `ERROR` 세 분기를 처리한다. `NEW`·`RUNNING`은 진행 중 내부 상태, `ABORTED`는 deprecated이므로 필요 시에만 별도 핸들러로 처리한다.

## 서버 에러 반환 — `AuraHandledException`

Apex 컨트롤러 코드에서 에러가 나면 (1) `catch` 블록으로 Apex에서 처리하거나 (2) 에러가 컨트롤러 응답에 담겨 클라이언트로 반환된다. 시스템 예외를 그대로 반환하면 보안상 세부가 제거되어 **"An internal server error has occurred…"** 라는 무의미한 메시지가 뜬다. 대신 `System.AuraHandledException`을 생성·throw하면 **커스텀 메시지**를 클라이언트에 전달할 수 있다.

```apex
public with sharing class SimpleErrorController {
    static final List<String> BAD_WORDS = new List<String> { 'bad', 'words', 'here' };
    @AuraEnabled
    public static String helloOrThrowAnError(String name) {
        for(String badWordStem : BAD_WORDS) {
            if(name.containsIgnoreCase(badWordStem)) {
                // Gracefully return an error...
                throw new AuraHandledException('NSFW name detected.');
            }
        }
        return ('Hello ' + name + '!');
    }
}
```

Apex가 `AuraHandledException`을 throw하면 JS 콜백에서 상태가 `ERROR`가 되고, `response.getError()`로 메시지를 얻는다(`errors[0].message`). UI에 에러 프롬프트를 띄우려면 `lightning:notificationsLibrary`를 쓴다. 특히 DML 예외를 catch해 `AuraHandledException`으로 다시 던지면 원시 DML 예외가 클라이언트로 전파되는 것을 막을 수 있다.

## Apex 오브젝트/커스텀 클래스 반환

반환 데이터는 JSON 직렬화 가능해야 한다. 반환 가능 타입: Simple(String/Integer 등)·sObject(표준·커스텀)·Apex 클래스 인스턴스·이들의 Collection. **Apex inner class는 반환값으로 쓸 수 없다.**

인스턴스가 반환되면 **`@AuraEnabled`가 붙은 public 인스턴스 프로퍼티·메서드의 값만** 직렬화된다.

```apex
public class SimpleAccount {
    @AuraEnabled public String Id { get; set; }
    @AuraEnabled public String Name { get; set; }
    public String Phone { get; set; }   // @AuraEnabled 없음 → 직렬화 안 됨, 클라이언트로 반환 안 됨
    public SimpleAccount(String id, String name, String phone) {
        this.Id = id; this.Name = name; this.Phone = phone;
    }
    public SimpleAccount() {}  // client→server용 no-arg 생성자
}
```

커스텀 클래스를 **파라미터**로 받을 때도 각 프로퍼티에 `@AuraEnabled` + getter/setter가 필요하다.

> 표준 Apex 한도(예: SOQL 최대 레코드 수)가 서버측 컨트롤러 데이터 반환 시에도 적용된다. Lightning Web Security 활성 시 Apex inner class를 파라미터·반환값으로 쓸 수 없다.

## Storable Actions — `setStorable()`

액션을 storable(cacheable)로 표시하면 서버 왕복 없이 클라이언트 저장소의 캐시 데이터를 즉시 보여준다. 3G 같은 고지연·불안정 연결에서 특히 유리하다.

```javascript
action.setStorable();
```

> Warning(PDF 전수):
> - storable 액션은 **서버 호출이 아예 없을 수 있다**. **데이터를 update/delete하는 액션은 절대 storable로 표시하지 말 것.**
> - 캐시에 있는 storable 액션은 프레임워크가 캐시 응답을 즉시 반환하고 stale이면 리프레시한다 → **콜백이 한 번 이상 호출될 수 있다**(먼저 캐시, 다음 서버 최신).

storable 액션의 "동일 액션" 판별 키 = **Apex 컨트롤러명 + 메서드명 + 메서드 파라미터 값** 조합. 대부분의 서버 요청은 read-only·idempotent라 캐시 가능하다.

`setStorable()`은 선택적 설정 맵을 받는다. 설정 가능한 프로퍼티는 **`ignoreExisting`** 하나 — `true`로 두면 캐시를 우회한다(기본 `false`). 레코드 수정 직후처럼 캐시가 무효임을 알 때 유용하나, 캐싱을 무력화하므로 드물게만 쓴다.

> 캐시 히트/미스 시퀀스(PDF, Lifecycle of Storable Actions): **Cache Miss** → 서버 전송 → SUCCESS면 저장소에 추가 → 콜백 실행. **Cache Hit** → 캐시 응답으로 콜백 실행 → refresh 시간 초과 시 저장소 갱신 → 서버 전송 → SUCCESS면 저장 → 갱신 응답이 캐시와 다르면 **콜백 2번째 실행**.

## Foreground / Background Actions — `setBackground()`

액션은 기본적으로 **foreground**로 실행된다. 몇 초 이상 걸리는 저우선·장시간 액션은 background로 돌려 앱이 사용자에게 반응성을 유지하게 한다.

```javascript
var action = cmp.get("c.serverEcho");
action.setBackground();
```

- boxcar로 묶여 전송될 때 foreground 액션이 먼저, background가 뒤에 처리된다. 서버에서는 병렬 실행되며 응답은 어느 순서로도 올 수 있다.
- **background 액션은 다시 foreground로 되돌릴 수 없다.** `setBackground()`는 인자를 받지 않고 여러 번 호출해도 효과 없다.
- 프레임워크가 foreground·background 요청을 분리 관리·throttle한다. background로 설정하는 것 외에 요청 처리를 제어할 수 없다.

## Abortable Actions — `setAbortable()`

큐에 대기 중인 액션을 abortable로 표시하면, 그 액션을 만든 컴포넌트가 더 이상 유효하지 않을 때(`cmp.isValid() == false`) **서버로 전송되지 않을 수 있다**. 컴포넌트는 unrender될 때 자동으로 파괴·invalid 처리된다.

```javascript
var action = cmp.get("c.serverEcho");
action.setAbortable();
```

- abortable 액션은 컴포넌트가 전송 전 invalid가 되지 않는 한 정상 전송·실행된다. non-abortable 액션은 **항상 서버로 전송**되며 큐에서 중단될 수 없다.
- 액션 응답이 서버에서 돌아왔는데 연관 컴포넌트가 invalid면, 서버 로직은 실행됐지만 **콜백은 실행되지 않는다**(abortable 여부와 무관).
- abortable 액션은 서버 전송이 보장되지 않으므로 **read-only 연산에만** 권장.

## Action 한도·고려사항 (PDF 전수)

- **Client Payload Data Limit** — 큐의 액션들을 하나의 서버 요청으로 batch하며, 페이로드는 모든 액션·데이터를 JSON 직렬화한 것. **요청 페이로드 한도는 4 MB.**
- **Action Limit in a Boxcar Request** — boxcar 요청에 액션이 **250개**를 초과하면 프레임워크가 **HTTP 413** 응답 코드를 반환한다.
- **Actions and the Component Lifecycle** — 액션이 실행되지 않으면 프레임워크의 정상 렌더링 라이프사이클 밖에서 코드를 실행 중일 수 있다. 예: `window.setTimeout()`으로 지연 실행하는 경우 코드를 `$A.getCallback()`으로 감싼다.

## Continuations — 장시간 콜아웃

`Continuation` 클래스로 외부 웹 서비스에 **장시간 요청**을 보내고 응답을 콜백 메서드에서 처리한다. 콜아웃을 병렬로 만들 수 있는 등의 이점이 있어 **콜아웃 관리의 권장 방식**이다.

```apex
@AuraEnabled(continuation=true)
// continuation을 반환하는 컨트롤러 메서드

@AuraEnabled(continuation=true cacheable=true)
// continuation 액션 결과를 캐시하려면 콜백 메서드 어노테이션에 cacheable=true
```

> Note(PDF): `continuation=true cacheable=true` 사이는 **콤마(,)가 아니라 공백**이다.

- continuation은 장시간 요청일 수 있으므로 프레임워크가 사실상 **background 액션처럼** 취급한다. 다른 요청과 boxcar로 묶이지 않아 실행 중 다른 액션을 막지 않는다.
- continuation으로 만든 비동기 콜아웃은 5초 초과 동기 요청의 Apex 한도에 카운트되지 않는다. **Winter '20 이후 모든 콜아웃이 long-running 요청 한도에서 제외**되어, 한도 측면의 이점은 사라졌지만 **UX 개선을 위해 여전히 continuation을 권장**한다.

> Apex 콜아웃의 HTTP 요청/응답 세부는 [[Http·HttpRequest·HttpResponse 레퍼런스]] 참조. Apex 콘텐츠 깊이는 그쪽 소관이며 이 노트는 Aura 연동 관점만 다룬다.

## Apex 컨트롤러 보안 (요약 — 상세는 Apex 노트 위임)

Apex는 기본적으로 **system mode**로 실행되어 대부분의 권한과 필드·오브젝트 접근이 부여된 것처럼 동작한다. Salesforce UI처럼 보안이 강제되지 않으므로 **직접 코드로 강제**해야 한다.

- **공유 규칙** — 클래스 선언 시 `with sharing` 지정 권장. `@AuraEnabled` 클래스가 공유 키워드를 명시하지 않거나 `inherited sharing`이면 기본값은 `with sharing`. → 상세 [[Sharing 키워드 (with·without·inherited sharing)]]
- **오브젝트·필드 권한(CRUD·FLS)** — 가장 쉬운 방법은 SOQL에 `WITH USER_MODE` 절 → [[WITH USER_MODE]]. 우아한 저하가 필요하면 `Security.stripInaccessible()` → [[StripInaccessible]].

> `with sharing`은 **레코드 레벨** 보안만 강제하며 오브젝트·필드 레벨은 강제하지 않는다 — 별도로 처리해야 한다. 이들 메커니즘의 본문 깊이는 위 Apex 보안 노트가 소관이므로 이 노트에서는 포인터만 둔다.

## Apex 테스트 (요약 — 위임)

관리 패키지 업로드 전 Apex 코드에 대한 테스트를 작성·실행해야 한다. **단위 테스트가 Apex 코드의 최소 75%를 커버**해야 하고 모두 성공해야 하며, 모든 트리거는 일부 테스트 커버리지가 필요하다.

```apex
@isTest
class TestExpenseController {
    static testMethod void test() {
        Expense__c exp = new Expense__c(name='My New Expense',
            amount__c=20, client__c='ABC', reimbursed__c=false, date__c=null);
        ExpenseController.saveExpense(exp);
        System.assertEquals('My New Expense',
            ExpenseController.getExpenses()[0].Name, 'Name does not match');
        System.assertEquals(exp, ExpenseController.saveExpense(exp));
    }
}
```

> 테스트 전략·커버리지 심화는 Apex Testing 노트 소관. 이 노트는 Aura 컨트롤러 테스트가 일반 Apex 테스트와 동일함을 명시하는 선에서만 다룬다.

---

# 파트 B — Lightning Data Service / `force:recordData`

> LWC의 `@wire(getRecord)` / `getRecord`의 Aura 짝. Apex 없이 선언적으로 레코드를 로드·생성·편집·삭제하며, **공유 규칙·필드 레벨 보안을 자동 처리**한다.

LDS는 UI API 위에 얹혀 있고, 로드된 레코드는 **모든 사용 컴포넌트가 공유하는 고효율 로컬 저장소**에 캐시된다. 같은 레코드는 몇 개 컴포넌트가 쓰든 **한 번만 로드**되어 성능·UI 일관성이 좋아진다. 한 컴포넌트가 레코드를 업데이트하면 그 레코드를 쓰는 다른 컴포넌트가 통지받아 대부분 자동 리프레시된다.

LDS를 사용하는 컴포넌트(PDF 전수):

| 컴포넌트 | 용도 |
|---|---|
| `lightning:recordForm` | 레코드 표시·생성·편집 |
| `lightning:recordViewForm` | `lightning:outputField`로 레코드 표시(읽기 전용) |
| `lightning:recordEditForm` | `lightning:inputField`로 레코드 생성·편집 |
| `force:recordData` | **커스텀 UI 컴포넌트**로 레코드 데이터 생성·편집·삭제 (UI 요소 없음 — 순수 로직·서버 통신) |

form 기반 컴포넌트가 가장 쉽지만, UI 요소·레이아웃 없이 raw 레코드 데이터만 필요하거나 세밀한 제어가 필요하면 `force:recordData`를 쓴다.

## `force:recordData` 속성 (전수)

```xml
<force:recordData aura:id="recordLoader"
    recordId="{!v.recordId}"
    fields="Name,BillingCity,BillingState,Industry"
    targetRecord="{!v.record}"
    targetFields="{!v.simpleRecord}"
    targetError="{!v.recordError}"
    mode="EDIT"
    recordUpdated="{!c.handleRecordUpdated}" />
```

| 속성 | 의미 |
|---|---|
| `recordId` | 로드할 레코드의 ID. **생략하면 새 레코드 생성 모드**(getNewRecord 대상) |
| `fields` | 로드할 필드 목록(예: `"Name,BillingCity,BillingState"`). **권장 방식** — 필요한 필드만 조회 |
| `layoutType` | 레이아웃 지정 로드. 유효 값 **`FULL` · `COMPACT`**. 프로필의 페이지 레이아웃 할당에 의존해 유연성이 낮음 — 관리자가 필드를 통제해야 할 때만 사용 |
| `targetRecord` | 요청한 layoutType/fields에 해당하는 필드를 담은 **현재 레코드**로 채워짐 |
| `targetFields` | 로드된 레코드의 **단순화된 뷰**. 예: `v.targetRecord.fields.Name.value` ≡ `v.targetFields.Name` |
| `targetError` | LDS 에러 메시지 대상 |
| `mode` | `VIEW`(기본) 또는 `EDIT`. EDIT 모드는 편집·저장 대상 로드 |
| `recordUpdated` | 레코드 로드·변경·삭제·에러 시 발생하는 이벤트 핸들러 |

> `fields` 사용 시 `targetFields`에는 요청 필드 외에 레코드의 **`Id`와 `SystemModstamp`** 필드도 반환된다. `layoutType`보다 `fields`가 권장됨.

## 로딩 (Loading a Record)

```xml
<!-- ldsLoad.cmp (PDF 발췌) -->
<aura:component implements="flexipage:availableForRecordHome,
    force:lightningQuickActionWithoutHeader, force:hasRecordId">
    <aura:attribute name="record" type="Object"/>
    <aura:attribute name="simpleRecord" type="Object"/>
    <aura:attribute name="recordError" type="String"/>
    <force:recordData aura:id="recordLoader"
        fields="Name,BillingCity,BillingState,Industry"
        recordId="{!v.recordId}"
        targetFields="{!v.simpleRecord}"
        targetError="{!v.recordError}"
        recordUpdated="{!c.handleRecordUpdated}" />
    <lightning:card iconName="standard:account" title="{!v.simpleRecord.Name}">
        <lightning:formattedText value="{!v.simpleRecord.BillingCity}" />
    </lightning:card>
</aura:component>
```

`force:recordData`는 서버에서 데이터를 가져올 수 있어 **비동기로 로드**한다. 로드/변경 추적은 `recordUpdated` 이벤트를 쓰거나 `targetRecord`/`targetFields`에 change 핸들러를 둔다. JS에서 필드 접근은 `component.get("v.simpleRecord.fieldName")`.

## 편집 (Editing a Record) — `saveRecord`

기존 레코드를 편집·저장하려면 **`mode="EDIT"`로 로드** 후 `saveRecord`를 호출한다. `saveRecord`는 인자 하나 — 완료 후 호출될 콜백 — 를 받으며, 콜백은 **`SaveRecordResult`** 를 유일 파라미터로 받는다. `SaveRecordResult`의 `state` attribute가 성공/에러를 나타낸다.

```javascript
// ldsSaveController.js (PDF 발췌)
({
    handleSaveRecord: function(component, event, helper) {
        component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                    JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state);
            }
        }));
    }
})
```

> EDIT 모드 주의(PDF): LDS 레코드는 컴포넌트 간 공유되므로 로드 시 **직접 참조가 아니라 복사본**을 준다. VIEW 모드로 로드하면 레코드 변경 시 복사본이 최신본으로 자동 덮어써진다. **EDIT 모드로 로드하면 변경돼도 갱신되지 않는다** — 편집 중 미저장 변경이 덮어써지는 것을 막기 위해서다. 통지는 두 모드 모두에서 전송된다. EDIT 모드에서 강제로 갱신하려면 핸들러에서 `reloadRecord()`를 호출한다(현재 레코드·변경분을 잃음).

## 생성 (Creating a Record) — `getNewRecord` + `saveRecord`

`recordId`를 생략하고, `getNewRecord`로 레코드 템플릿에서 빈 레코드를 만든 뒤 값을 채우고 `saveRecord`로 커밋한다.

`getNewRecord` 인자(PDF 전수):

| 인자 | 타입 | 설명 |
|---|---|---|
| `objectApiName` | String | 새 레코드의 오브젝트 API 이름 |
| `recordTypeId` | String | 새 레코드 레코드 타입의 18자 ID. 미지정 시 사용자 프로필에 정의된 기본 레코드 타입 사용 |
| `skipCache` | Boolean | 클라이언트측 LDS 캐시 대신 서버에서 템플릿을 로드할지. 기본 `false` |
| `callback` | Function | 빈 레코드 생성 후 호출되는 함수. 인자 없음 |

```javascript
// ldsCreateController.js (PDF 발췌)
({
    doInit: function(component, event, helper) {
        component.find("contactRecordCreator").getNewRecord(
            "Contact", // objectApiName
            null,      // recordTypeId
            false,     // skipCache
            $A.getCallback(function() {
                var rec = component.get("v.newContact");
                var error = component.get("v.newContactError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
            })
        );
    },
    handleSaveContact: function(component, event, helper) {
        component.set("v.simpleNewContact.AccountId", component.get("v.recordId"));
        component.find("contactRecordCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving contact, error: ' +
                    JSON.stringify(saveResult.error));
            }
        });
    }
})
```

- `getNewRecord`는 결과를 반환하지 않는다 — 빈 레코드를 준비해 `targetRecord`에 할당할 뿐.
- **`getNewRecord`의 콜백은 반드시 `$A.getCallback()`으로 감싸야 한다** — 감싸지 않으면 컴포넌트의 private attribute 접근 시 access check 실패가 발생한다. private 접근이 없어도 항상 감싸는 것이 best practice.

## 삭제 (Deleting a Record) — `deleteRecord`

`force:recordData`에서 `deleteRecord`를 호출하고 완료 후 호출될 콜백을 넘긴다. 콜백은 `SaveRecordResult`를 받는다. **form 기반 컴포넌트(`lightning:recordForm` 등)는 현재 레코드 삭제를 지원하지 않는다.**

삭제만 할 거면 `force:recordData`에 `recordId`와 **`fields="Id"`(최소한)** 만 두면 되고, mode는 아무거나 써도 된다.

```javascript
// ldsDeleteController.js (PDF 발췌)
({
    handleDeleteRecord: function(component, event, helper) {
        component.find("recordHandler").deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                console.log("Record is deleted.");
            } else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                console.log('Problem deleting record, error: ' +
                    JSON.stringify(deleteResult.error));
            }
        }));
    }
})
```

> 레코드 삭제 후에는 레코드 페이지에서 다른 곳으로 navigate해야 한다 — 그렇지 않으면 컴포넌트 리프레시 시 "record not found" 에러가 뜬다.

## `recordUpdated` 이벤트 — changeType 전수

`force:recordData`로 레코드가 바뀔 때 더 고급 작업을 하려면 `recordUpdated` 이벤트를 처리한다. `event.getParams().changeType`으로 변경 유형을 분기한다.

```javascript
// (PDF 발췌) recordUpdated 핸들러
({
    recordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR")        { /* handle error; do this first! */ }
        else if (changeType === "LOADED")  { /* record is loaded in the cache */ }
        else if (changeType === "REMOVED") { /* record is deleted/removed from cache */ }
        else if (changeType === "CHANGED") { /* record is changed */ }
    }
})
```

| `changeType` | 의미 |
|---|---|
| `LOADED` | 레코드가 캐시에 로드됨 |
| `CHANGED` | 레코드가 변경됨 (`event.getParams().changedFields`로 변경 필드 확인 가능) |
| `REMOVED` | 레코드가 삭제되어 캐시에서 제거됨 |
| `ERROR` | 레코드 로드·저장·삭제 중 에러 발생 |

> LDS는 **변경된 필드가 리스너의 `fields`/layout에 포함될 때만** 리스너에 데이터 변경을 통지한다. `CHANGED`에서 최신 데이터로 갱신하려면(특히 EDIT 모드) `component.find("...").reloadRecord()`를 쓴다.

## Handling Errors

LDS는 리소스(레코드·오브젝트)가 서버에서 접근 불가일 때 에러를 반환한다 — 잘못된 recordId, 필수 필드 누락, 캐시에 없는데 서버 오프라인, 삭제/공유·가시성 변경 등. form 기반 컴포넌트는 필드 레벨 에러와 LDS 에러를 자동 처리하며, `onerror` 이벤트 핸들러로 추가 처리할 수 있다. `force:recordData`는 `targetError` attribute로 에러를 노출한다.

---

## LWC 대응 (짝)

Aura의 데이터 연동은 LWC에서 다음으로 대체된다. 신규 개발은 LWC를 쓰며, 이관 절차 자체는 [[Aura → LWC 마이그레이션]] 소관이다.

| Aura | LWC 대응 |
|---|---|
| `@AuraEnabled` Apex + `component.get("c.method")` | `@salesforce/apex` import (wire / imperative) |
| `@AuraEnabled(cacheable=true)` + storable | `@wire(apexMethod)` (cacheable 필수) |
| `action.setParams` + `$A.enqueueAction` (명령형) | imperative Apex 호출 |
| `force:recordData` 로딩 | `@wire(getRecord)` / `getFieldValue` |
| `force:recordData` CRUD | `createRecord` / `updateRecord` / `deleteRecord` (uiRecordApi) |
| `lightning:recordForm` 등 | `lightning-record-form` 등(동일 base 컴포넌트 계열) |

---

## 관련 노트

- [[Aura 컴포넌트 구조]] — 번들·마크업·클라이언트 컨트롤러/헬퍼 기초. 그 노트의 인라인 서버 액션 조각(`saveRecord`/`getContacts`)의 **심화판이 이 노트**다.
- [[Aura → LWC 마이그레이션]] — `@AuraEnabled` Apex → `@salesforce/apex` 등 Apex 연동 이관 소관
- [[Aura vs LWC]] — 두 컴포넌트 모델 비교(신규 개발 방향)
- [[getRecord 패턴]] — `force:recordData` 로딩의 LWC 짝(`@wire(getRecord)`)
- [[LDS 개념 (Lightning Data Service)]] — LDS 공유 캐시 개념(LWC 관점)
- [[uiRecordApi]] — `createRecord`·`updateRecord`·`deleteRecord` (LWC의 명령형 CRUD 짝)
- [[Wire 패턴]] — `@wire`로 Apex/cacheable 메서드 바인딩(LWC)
- [[Imperative 호출 패턴]] — `setParams`+`enqueueAction` 명령형 호출의 LWC 짝
- [[@salesforce Modules 레퍼런스]] — `@salesforce/apex` import 레퍼런스
- [[WITH USER_MODE]] · [[StripInaccessible]] · [[Sharing 키워드 (with·without·inherited sharing)]] — Apex 컨트롤러 보안(오브젝트·필드·공유)
- [[Http·HttpRequest·HttpResponse 레퍼런스]] — Continuation이 감싸는 Apex 콜아웃 HTTP 세부
