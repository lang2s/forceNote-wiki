---
tags: [index, apex, testing]
created: 2026-05-17
---

# Testing(테스트) — 로컬 인덱스

> Apex 테스트 패턴 — 단위·통합·모킹·격리 전략

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[테스트 전략]] | @isTest, TestSetup, Given-When-Then 구조 | #decision |
| [[HttpCalloutMock]] | HTTP 외부 호출 모킹, Test.setMock | #pattern |
| [[WebServiceMock]] | SOAP 콜아웃(wsdl2apex 스텁) 모킹 — WebServiceMock.doInvoke, Test.setMock | #pattern |
| [[StubProvider]] | System.StubProvider, Test.createStub 클래스 모킹 | #pattern |
| [[testVisible 회로차단기]] | @testVisible Boolean/Exception 회로 차단기 | #pattern |
| [[SOSL 테스트 패턴]] | Test.setFixedSearchResults, SOSL 고정 결과 | #pattern |
| [[Flowtesting Namespace]] | Flow Builder 생성 flow test 실행 — flowtesting 동적 namespace, sf flow run test CLI | #reference |
| [[Test Data Factory 패턴]] | 재사용 팩토리 클래스·@TestSetup·Test.loadData(정적 리소스 CSV)로 결정적 테스트 데이터 생성 | #pattern |
| [[System.runAs (테스트 실행 컨텍스트)]] | 테스트에서 다른 사용자 컨텍스트 실행(공유·FLS·권한 검증), Mixed DML 우회, 패키지 버전 컨텍스트 | #pattern |
| [[코드 커버리지 규칙]] | 배포·패키지 커버리지 요건(조직 75%·트리거 최소), 커버리지 계산·확인, 커버리지 ≠ 품질 | #reference |

---

## 빠른 선택

- 테스트 구조를 처음 잡을 때? → [[테스트 전략]]
- HTTP callout 이 있는 메서드 테스트? → [[HttpCalloutMock]]
- SOAP 웹서비스 callout(wsdl2apex 스텁) 테스트? → [[WebServiceMock]]
- 외부 클래스 의존성 격리? → [[StubProvider]]
- private 로직에 테스트 전용 플래그? → [[testVisible 회로차단기]]
- SOSL 검색 결과 고정? → [[SOSL 테스트 패턴]]
- Flow Builder에서 만든 flow test 실행? → [[Flowtesting Namespace]]
- 테스트 데이터를 재사용 가능하게 만들기? → [[Test Data Factory 패턴]]
- 다른 사용자 권한·공유로 테스트? → [[System.runAs (테스트 실행 컨텍스트)]]
- 배포 커버리지 75%·트리거 커버리지 확인? → [[코드 커버리지 규칙]]
