---
tags: [apex, anonymous-apex, executeAnonymous, execution-context, 익명실행, 권한]
source: salesforce_apex_developer_guide.pdf (Summer '26, v67.0) — Invoking Apex / Anonymous Blocks (print p.264~)
created: 2026-06-19
aliases: [Anonymous Apex, Anonymous Block, executeAnonymous, 익명 Apex, 익명 블록, 익명 Apex 실행, execute anonymous 실행, Execute Anonymous Window, 익명 코드 실행, Author Apex 권한, ExecuteAnonymousResult, anonymous block 제약, Forward reference]
---

# Anonymous Apex 실행

> Anonymous block은 메타데이터에 저장되지 않지만 컴파일·실행할 수 있는 Apex 코드다. 개발 도구나 SOAP API의 `executeAnonymous()` 호출을 통해 즉석에서 코드를 돌릴 때 사용한다.

---

## 개요

Anonymous block은 Apex를 호출하는 여러 표면 중 하나로, 메타데이터에 저장되지 않지만 컴파일·실행 가능한 Apex 코드다. org에 클래스로 저장하지 않고 임시 스크립트를 돌릴 때 쓴다.

다음 도구가 anonymous block을 컴파일·실행한다.

- Web Console (Beta)
- Salesforce Extensions for Visual Studio Code
- Agentforce Vibes IDE
- Developer Console
- **SOAP API 호출:** `ExecuteAnonymousResult executeAnonymous(String code)`

> [!important]
> anonymous block을 실행할 때마다 **그 코드와 references가 매번 재컴파일된다.** 반복 호출하는 로직은 컴파일된 클래스(예: Apex REST endpoint)로 만드는 것을 강력 권장한다.

---

## 필요 권한 (User Permissions Needed)

| 작업 | 필요 권한 |
|---|---|
| To execute anonymous Apex: (Anonymous Apex execution through the API allows restricted access without the "Author Apex" permission.) | "API Enabled" and "Author Apex" |
| If an anonymous Apex callout references a named credential as the endpoint: | Customize Application |

---

## Anonymous block 콘텐츠 제약 (전수)

1. user-defined 메서드와 예외를 포함할 수 있다.
2. user-defined 메서드는 `static` 키워드를 포함할 수 없다.
3. DB 변경을 수동으로 commit할 필요가 없다.
4. block 내 Apex trigger가 성공하면, block의 모든 작업이 성공적으로 끝난 후에만 DB에 commit된다. trigger가 실패하면 anonymous block에서 한 DB 변경 전부가 rollback된다.
5. anonymous block은 현재 사용자로 실행되며, 코드가 사용자의 object·field-level 권한을 위반하면 컴파일에 실패할 수 있다.
6. block 콘텐츠는 local scope다. 예를 들어 `global` 접근 한정자를 써도 합법이지만 의미가 없다 — 메서드의 scope는 anonymous block에 한정된다.
7. anonymous block에서 class/interface(custom type)를 정의하면, 실행될 때 기본적으로 **virtual로 간주된다**(custom type이 `virtual` 한정자로 정의되지 않았어도 동일).
8. anonymous block에 정의된 class·interface는 org에 저장되지 않는다.
9. (위 제약과 결합) anonymous block은 메타데이터에 저장되지 않으므로, 정의된 custom type 역시 org에 영속하지 않는다.

---

## Forward Reference 규칙

user-defined 메서드는 forward declaration 없이 자기 자신이나 later 메서드를 참조할 수 있다. 그러나 **변수는 실제 선언 전에 참조할 수 없다.** 아래 예제에서 `Integer int1`은 선언되어야 하지만 `myProcedure1`은 선언 순서에 구애받지 않는다.

```apex
Integer int1 = 0;

void myProcedure1() {
    myProcedure2();
}

void myProcedure2() {
    int1++;
}

myProcedure1();
```

---

## 반환 결과 (ExecuteAnonymousResult)

`executeAnonymous()`가 반환하는 결과(`ExecuteAnonymousResult`)에는 다음이 포함된다.

- compile·execute phase의 상태 정보(발생한 에러 포함)
- debug log 콘텐츠(`System.debug` 출력 포함)
- uncaught 예외의 Apex 스택 트레이스(각 콜스택 요소의 class·method·line number 포함)

> debug log의 섹션 해부·event type·로그 카테고리/레벨 상세는 [[Apex Debug Log]] 참조.

---

## API를 통한 실행과 Author Apex 권한

`executeAnonymous()` API 호출로 org에 저장된 Apex 메서드를 포함해 어떤 Apex 코드든 실행하려면 **Author Apex 권한이 필요하다.** Author Apex가 없는 사용자에게는 API가 anonymous Apex의 **제한된 실행**만 허용한다. 이 예외는 사용자가 API 또는 API를 쓰는 개발 도구를 통해 anonymous Apex를 실행할 때만 적용된다.

Author Apex가 없는 사용자가 anonymous block에서 실행할 수 있는 것:

- anonymous block에 직접 작성한 코드
- org에 저장된 Web service 메서드(`webservice` 키워드로 선언된 메서드)
- Apex 언어의 일부인 모든 built-in Apex 메서드

그 외 Apex 코드 실행은 차단된다. 예를 들어 org에 저장된 custom Apex 클래스의 메서드를 호출할 수 없고, custom 클래스를 built-in 메서드의 인자로 사용할 수 없다. Author Apex가 없는 사용자가 anonymous block에서 DML 문을 실행하면, 그 결과로 트리거가 fire될 수 있다.

> webservice 키워드 메서드를 SOAP/AJAX로 노출·호출하는 상세는 [[SOAP Web Services 노출 (webservice 키워드)]] 참조.

### 관리 패키지 차단 (Block Execute Anonymous from Managed Packages)

> [!important]
> Salesforce는 1GP·2GP 관리 패키지에서 호출된 anonymous Apex를 차단한다. 관리 패키지는 `UserInfo.getSessionId()`로 세션 ID를 얻어 anonymous Apex 실행에 사용할 수 없다. **이 변경은 Summer '26부터 구독자에게 제공되며, Summer '27에 강제된다.** (Release Update: "Block Execute Anonymous from Managed Packages" 참조.)

### See Also

- Named Credentials as Callout Endpoints (anonymous Apex callout이 named credential을 endpoint로 참조하는 경우 Customize Application 권한 필요 — 위 권한 표 참조)

---

## 관련 노트

- [[QuiddityGuard]]
- [[Apex Debug Log]]
- [[DX 개발 워크플로]]
- [[System Namespace]]
- [[ExecutionContext(실행컨텍스트)/index]]
- [[Apex MOC]]
