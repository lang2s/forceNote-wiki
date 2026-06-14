---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Top 10 Salesforce Apex Interview Questions & Answers for Freshers]
---

# 신입을 위한 Salesforce Apex 면접 질문과 답변 TOP 10

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. Salesforce에서 Apex란 무엇인가요?**

Apex는 Salesforce에서 비즈니스 로직을 개발하고 커스터마이징하는 데 사용되는 강타입(strongly-typed) 객체 지향 프로그래밍 언어입니다. Salesforce 서버에서 실행되며 멀티테넌트(multi-tenant) 환경에 최적화되어 있습니다.

**2. Apex의 주요 특징은 무엇인가요?**

- Salesforce 플랫폼과 통합됨
- DML 작업 및 SOQL 쿼리 지원
- 멀티테넌트 아키텍처를 따름
- 내장 보안 및 거버너 한도(governor limits) 보유

**3. 트리거(trigger)와 클래스(class)의 차이는 무엇인가요?**

트리거는 Salesforce에서 데이터 변경 전후에 실행되는 Apex 스크립트이고, 클래스는 특정 작업을 수행하기 위해 변수와 메서드를 정의하는 재사용 가능한 코드 블록입니다.

**4. Apex의 거버너 한도(Governor Limits)란?**

거버너 한도는 멀티테넌트 환경에서 효율적인 리소스 사용을 보장하기 위해 Salesforce가 부과한 실행 제약입니다. 예: 트랜잭션당 SOQL 쿼리 100개 제한.

**5. SOQL과 SOSL의 차이는 무엇인가요?**

- **SOQL (Salesforce Object Query Language):** 필터 조건을 사용해 단일 또는 여러 관련 오브젝트에서 레코드를 조회합니다.
- **SOSL (Salesforce Object Search Language):** 여러 오브젝트와 필드에 걸쳐 텍스트를 검색합니다.

**6. Apex의 컬렉션(Collection) 유형을 설명해 주세요.**

Apex는 세 가지 컬렉션 유형을 지원합니다:

- **List:** 순서가 있는 요소 모음 (`List<String> myList = new List<String>();`)
- **Set:** 고유한(중복 없는) 순서 없는 요소 (`Set<String> mySet = new Set<String>();`)
- **Map:** 키-값 쌍 (`Map<Id, Account> myMap = new Map<Id, Account>();`)

**7. Apex의 트리거 유형에는 어떤 것이 있나요?**

- **Before 트리거:** 레코드가 삽입, 업데이트, 삭제되기 *전에* 실행됩니다.
- **After 트리거:** 레코드가 삽입, 업데이트, 삭제된 *후에* 실행됩니다.

**8. Batch Apex란 무엇이며 언제 사용하나요?**

Batch Apex는 대량의 레코드를 비동기적으로 처리하는 데 사용됩니다. 청크(배치) 단위로 실행되며, 거버너 한도를 초과하는 대량 데이터 작업을 처리하는 데 이상적입니다.

**9. Apex의 Future Method란?**

Future Method(`@future` 어노테이션)는 백그라운드에서 비동기적으로 실행되며, 콜아웃(callout)이나 무거운 DML 작업 같은 장시간 실행 작업에 사용됩니다.

**10. Apex의 Test Class란 무엇이며 왜 중요한가요?**

Test Class는 Apex 코드 품질을 보장하고 플랫폼 안정성을 유지합니다. Salesforce는 운영 환경(production)에 배포하기 전에 테스트 클래스로부터 최소 75%의 코드 커버리지를 요구합니다.

> **Pro Tip:** Apex 코드를 직접 작성해 보고 Salesforce 거버너 한도 내에서 최적화하는 방법을 이해하세요!
