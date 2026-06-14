# Apex Mock Callout 마스터하기

> 마법 테마로 설명하는 실시간 예시.

**비유:** 전투(Apex 메서드 작성)를 훈련할 때 항상 실제 적과 싸울(실제 API 콜아웃) 수는 없습니다. 그래서 마법 책(Mock 클래스)으로 홀로그램 적을 만들어 안전하게 훈련합니다.

## 비교표

| 개념 | 마법 테마 | Apex |
|---|---|---|
| Test Class | 훈련장(통제된 환경에서 연습) | @isTest |
| Mock Callout Class | 마법 책(적의 환영 생성) | HttpCalloutMock 구현, respond() 메서드 |
| Mock Response | 홀로그램 적(가짜 적과 훈련) | respond() 메서드가 가짜 API 응답 생성 |
| Test.setMock() | 마법 지팡이(훈련 홀로그램 소환) | `Test.setMock(HttpCalloutMock.class, new MockClass());` |
| Actual Method | 진짜 군인(배포 시 실제 API 호출) | 실제 콜아웃을 수행하는 메서드 |
| Real API Callout | 실제 전투 | `HttpResponse response = http.send(request);` |

## 시나리오 단계

1. 실제 콜아웃 클래스 생성(진짜 군인)
2. Mock 콜아웃 클래스 생성(마법 책)
3. 테스트 클래스에서 Test.setMock으로 mock 활성화 후 실제 메서드 테스트
