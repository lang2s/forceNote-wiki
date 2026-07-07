---
tags: [apex, testing, stub, mock, pattern]
source: apex-recipes/TestDouble.cls, StubExample.cls
created: 2026-05-17
aliases: [System.StubProvider, handleMethodCall, Test.createStub, TestDouble, 외부 의존성 모킹]
---

# StubProvider — 외부 의존성 모킹

> `System.StubProvider` 구현으로 외부 서비스, 복잡한 클래스를 실제 호출 없이 모킹. `@isTest(SeeAllData=true)` 없이 테스트 가능.

---

## TestDouble 구현 구조

```apex
@isTest
public class TestDouble implements System.StubProvider {

    private List<Method> methods = new List<Method>();
    private Type objectType;

    public TestDouble(Type objectType) {
        this.objectType = objectType;
    }

    // 스텁할 메서드 등록 (Fluent)
    public TestDouble track(Method toTrack) {
        this.methods.add(toTrack);
        return this;
    }

    // 실제 스텁 객체 생성
    public Object generate() {
        return Test.createStub(this.objectType, this);
    }

    // StubProvider 필수 구현 — 메서드 호출 인터셉트
    public Object handleMethodCall(
            Object stubbedObject,
            String stubbedMethodName,
            Type returnType,
            List<System.Type> paramTypes,
            List<String> paramNames,
            List<Object> args) {

        for (Method method : methods) {
            if (method.name.equalsIgnoreCase(stubbedMethodName)) {
                return method.handleCall(); // 호출 횟수 증가 + 반환값 반환
            }
        }
        return null; // 미등록 메서드 → null 반환
    }

    // 메서드별 스텁 명세
    public class Method {
        public String name;
        public Object returnValue;
        public Integer hasBeenCalledXTimes = 0; // 호출 횟수 추적

        public Method(String methodName) { this.name = methodName; }

        // 반환값 설정 (Fluent)
        public Method returning(Object value) {
            this.returnValue = value;
            return this;
        }

        // 예외 throw 설정
        public Method throwing(Exception e) { ... return this; }

        public Object handleCall() {
            hasBeenCalledXTimes++;
            return returnValue;
        }
    }
}
```

---

## 사용 예시

```apex
@isTest
static void getBooks_callsApiOnce() {
    // 1. 스텁할 메서드 정의
    List<BookModel> fakeBooks = new List<BookModel>{ new BookModel('Test Book') };
    TestDouble.Method searchMethod =
        new TestDouble.Method('searchBooks').returning(fakeBooks);

    // 2. 스텁 객체 생성
    TestDouble stub = new TestDouble(BookApiService.class);
    stub.track(searchMethod);
    BookApiService fakeService = (BookApiService) stub.generate();

    // 3. 스텁을 주입해서 테스트
    BookController controller = new BookController(fakeService);
    Test.startTest();
    List<BookModel> result = controller.getBooks('salesforce');
    Test.stopTest();

    // 4. 결과 + 호출 횟수 검증
    Assert.areEqual(1, result.size());
    Assert.areEqual(1, searchMethod.hasBeenCalledXTimes, '정확히 1번 호출되어야 함');
}
```

---

## 공식 인터페이스 레퍼런스 (Stub API)

> Stub API = `System.StubProvider` 인터페이스 + `System.Test.createStub()` 메서드. StubProvider는 **콜백 인터페이스**로 단 하나의 메서드 `handleMethodCall()`만 구현하면 된다. 스텁된 메서드가 호출될 때마다 `handleMethodCall()`이 대신 호출된다.

### `System.StubProvider.handleMethodCall(...)`

```apex
// 공식 시그니처 (salesforce_apex_developer_guide — Build a Mocking Framework with the Stub API)
public Object handleMethodCall(
        Object       stubbedObject,       // 스텁된 객체
        String       stubbedMethodName,   // 호출된 메서드 이름
        Type         returnType,          // 호출된 메서드의 반환 타입
        List<Type>   listOfParamTypes,    // 호출된 메서드의 파라미터 타입 목록
        List<String> listOfParamNames,    // 호출된 메서드의 파라미터 이름 목록
        List<Object> listOfArgs)          // 런타임에 실제 전달된 인자 값 목록
```

| 파라미터 | 타입 | 의미 |
|---|---|---|
| `stubbedObject` | `Object` | 스텁된 객체 자체 |
| `stubbedMethodName` | `String` | 호출된(스텁된) 메서드의 이름 |
| `returnType` | `Type` | 호출된 메서드의 반환 타입 |
| `listOfParamTypes` | `List<Type>` | 호출된 메서드의 파라미터 타입 목록 |
| `listOfParamNames` | `List<String>` | 호출된 메서드의 파라미터 이름 목록 |
| `listOfArgs` | `List<Object>` | 런타임에 실제 전달된 인자 값 목록 |

- **반환:** `Object` — 스텁 메서드가 반환할 값. 이 값들(메서드명·반환타입·파라미터)을 조합해 어떤 메서드가 호출됐는지 식별하고 그에 맞는 동작을 정의한다.
- 위 [[#TestDouble 구현 구조]]의 `handleMethodCall`은 이 공식 시그니처에서 파라미터명만 줄인 것(`listOfParamTypes` → `paramTypes` 등)이다.

### `System.Test.createStub(Type, StubProvider)`

```apex
// 반환: stubbedTypeToMock 타입의 스텁 객체
Object stub = Test.createStub(Type typeToMock, System.StubProvider provider);
// 사용 시 대상 타입으로 캐스팅
DateHelper mockDH = (DateHelper) Test.createStub(DateHelper.class, new MockProvider());
```

- 첫 인자는 스텁할 Apex 클래스 타입, 둘째 인자는 위에서 구현한 StubProvider 인스턴스. 반환된 스텁 객체를 테스트에서 mock으로 주입한다.
- **네임스페이스 제약:** 스텁 대상 객체는 `Test.createStub()` 호출과 **같은 네임스페이스**에 있어야 한다. 단, StubProvider 구현체는 다른 네임스페이스에 있어도 된다.

### 스텁 가능 / 불가 대상

| 스텁 가능 (O) | 스텁 불가 (X) |
|---|---|
| 일반 (public/global) 클래스 | `static` 메서드 (future 메서드 포함) |
| 인터페이스 | `private` 메서드 |
| `virtual` / `abstract` 메서드 | 프로퍼티 (getter/setter) |
| | 트리거(Trigger) |
| | 이너 클래스(Inner class) |
| | System 타입 (`SObject`, `Database` 등 시스템 클래스) |
| | `Batchable` 인터페이스 구현 클래스 |
| | `private` 생성자만 가진 클래스 |

- 추가로 **Iterator는 반환 타입·파라미터 타입으로 사용 불가.**
- (참고) SOQL 쿼리 결과 모킹은 별도 `System.SoqlStubProvider` + `Test.createSoqlStub()` / `Test.createStubQueryRow(s)` 사용.

---

## Test.createStub 제약 사항

> [!warning] 스텁 불가 대상
> - `static` 메서드
> - `SObject` 타입
> - Salesforce 시스템 클래스 (`Database`, `System` 등)
> - `final` 클래스
>
> → 이런 경우 [[testVisible 회로차단기]] 또는 래퍼 클래스 패턴 사용

---

## ConnectApi 래퍼 — SeeAllData 우회

```apex
// ConnectApi는 @isTest(SeeAllData=true) 없이 직접 호출 불가
// 해결: 얇은 래퍼 클래스로 감싸서 TestDouble로 모킹

public class ConnectApiWrapper {
    public virtual ConnectApi.ExternalCredential createExternalCredential(
            ConnectApi.ExternalCredentialInput input) {
        return ConnectApi.NamedCredentials.createExternalCredential(input);
    }
}

// 테스트
TestDouble.Method createCred =
    new TestDouble.Method('createExternalCredential')
        .returning(new ConnectApi.ExternalCredential());
TestDouble stub = new TestDouble(ConnectApiWrapper.class);
stub.track(createCred);
ConnectApiWrapper fakeWrapper = (ConnectApiWrapper) stub.generate();
```

---

## HttpCalloutMock (HTTP 호출 모킹)

```apex
// HTTP 호출은 StubProvider 대신 HttpCalloutMock 사용
@isTest
public class SuccessMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"result": "ok"}');
        return res;
    }
}

// 테스트에서
Test.setMock(HttpCalloutMock.class, new SuccessMock());
```

---

## 관련 노트

- [[HttpCalloutMock]]
- [[testVisible 회로차단기]]
- [[테스트 전략]]
- [[platform-apex-test-generate]] (sf-skill — 실행형) — Stub/mock 포함 Apex 테스트 생성 실행형 스킬
