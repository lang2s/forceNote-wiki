---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [How can you Test Apex Trigger In SF]
---

# Salesforce에서 Apex 트리거를 테스트하는 방법

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

다양한 시나리오를 다루는 Apex 테스트 클래스를 작성합니다.

**테스트 단계:**
1. @testSetup 또는 테스트 메서드 내에서 테스트 데이터 생성.
2. 레코드 삽입/업데이트/삭제로 트리거 발동.
3. System.assertEquals()로 예상 동작 검증.
4. 배포를 위해 최소 75% 코드 커버리지 확보.

**모범 사례:**
- @testSetup으로 재사용 가능한 테스트 데이터 생성.
- 긍정·부정 시나리오(유효·무효 데이터) 테스트.
- System.assertEquals()로 결과 검증.
- Test.startTest()와 Test.stopTest()로 대량 실행 시뮬레이션.
