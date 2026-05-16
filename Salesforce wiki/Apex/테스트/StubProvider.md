---
tags: [apex, testing, stub, mock, pattern]
source: apex-recipes/TestDouble.cls, StubExample.cls
created: 2026-05-17
aliases: [System.StubProvider, TestDouble, 외부 의존성 모킹]
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
