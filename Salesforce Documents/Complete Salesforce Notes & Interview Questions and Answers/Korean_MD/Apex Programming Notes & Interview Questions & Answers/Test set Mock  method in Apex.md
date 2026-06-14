# Apex의 Test.setMock() 메서드

## Test.setMock()이란?

테스트 클래스에서 HTTP 콜아웃 동작을 시뮬레이션("mock")하는 데 사용되는 메서드입니다. Salesforce는 테스트 메서드에서 실제 HTTP 콜아웃을 할 수 없도록 규정하지만, Test.setMock()을 사용하면 외부 시스템의 응답을 시뮬레이션하여 콜아웃 로직을 테스트할 수 있습니다.

## 작동 방식

1. HttpCalloutMock 인터페이스를 구현하는 클래스를 정의합니다. 이 클래스가 HTTP 요청에 대한 mock 응답을 지정합니다.
2. 테스트 메서드에서 콜아웃 전에 Test.setMock()을 호출해 이 mock 클래스를 사용합니다.

## 언제 사용하나요?

- Apex 코드가 외부 시스템으로 HTTP 콜아웃을 할 때.
- 외부 API의 다양한 응답(성공, 오류, 타임아웃)을 시뮬레이션해 코드가 이를 어떻게 처리하는지 테스트할 때.
- 콜아웃을 하는 Future나 Queueable 같은 비동기 메서드 동작을 테스트할 때.

(구성: Apex 클래스(HTTP 콜아웃 수행) + Mock 클래스(HttpCalloutMock 인터페이스 구현) + Test 클래스.)
