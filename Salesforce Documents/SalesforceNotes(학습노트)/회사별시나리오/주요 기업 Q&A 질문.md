---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Top Companies Interview Questions]
---

# 주요 기업 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## INFOSYS
1. 인시던트 이슈 처리 시 겪은 어려움?
2. Batch Apex란?
3. Batch Apex의 인터페이스?
4. isTest.start(), isTest.stop()이란?
5. 테스트 클래스가 필요한 이유?
6. System.runAs()란?
7. 이전 경험·역할?
8. 고객에게 이메일 보내는 Lightning Flow 생성 방법?
9. 동시에 실행 가능한 배치 수?
10. Batch Apex가 한 번에 처리하는 레코드 수?
11. **트리거 시나리오:** Account의 'Number of Location' 필드 값에 따라 레코드 생성하는 트리거 작성.

## DELOITTE
1. Sharing Rules란?
2. Sharing Rules 설명
3. **시나리오:** 한 프로필에 사용자 3명(A=Manager, B, C). B·C는 서로 레코드 못 보게, A는 B·C 레코드 볼 수 있게 보안 모델 설계.
4. Custom Label이란?
5. Custom Settings & Metadata란?
6. 트리거 이벤트?
7. 보안 모듈?
8. seeAllData==true/false?
9. **트리거 시나리오:** 아래 코드가 오류 없이 실행되는가? 가능성은?
```apex
trigger BillingCityUpdate on Account (after insert) {
    List<Account> newAccounts = new List<Account>();
    for (Account acc : trigger.new) {
        acc.BillingCity = 'Hyderabad';
        acc.BillingState = 'Telangana';
        newAccounts.add(acc);
    }
    if (newAccounts.size() > 0) insert newAccounts;
}
```
> 답: after insert에서 trigger.new 레코드를 다시 insert하려 하면 읽기 전용 오류 또는 재귀/중복 삽입 문제 발생. before insert에서 필드 설정이 올바른 패턴.

## SALESFORCE
1. Assignment Rules란?
2. Sharing Rules와 종류?
3. Salesforce 관계?
4. Apex 클래스 디버그 방법?
5. Annual Revenue > 50000 레코드 조회 SOQL
6. Apex 클래스 작성
7. Lightning Flow 디버그 방법?
8. 다른 사용자가 Flow에 접근 못 하게 제한?
9. Batch 클래스 테스트 클래스 작성?
10. 에스컬레이션 규칙 생성?
11. Batch 실행 중 1건 미처리. 가능성은?
12. Admin·Developer 자기 평가?
13. 우선순위 티켓 작업 중 매니저가 긴급 티켓 할당 시 무엇 먼저?
14. **트리거 시나리오:** User가 레코드 수정 시 User Name으로 Description 채우는 트리거.
15. **시나리오:** Batch 처리 중 1건 미처리. 이유·가능성?
16. 클라이언트 이슈 디버그 방법? 클래스가 예상대로 안 됨?

## TECHMATRIX
1. Multitenancy란?
2. Profile vs Role 차이?
3. Process Builder vs Workflow vs Flow 차이?
4. 거버너 한도?
5. 실행 순서?
6. 인터페이스란? 만든 적 있나? 어떻게?
7. Batch Apex에서 Future 호출 방법?
8. Queue vs Public Group 차이?
9. **트리거 시나리오:** 메인 Contact 수정 시 관련 Contact Description 업데이트.

## CAPGEMINI
1. Cascade 삭제란?
2. 동기·비동기?
3. 관계 없는 2개 오브젝트에 Master-Detail 관계 생성 방법?
4. Batch Apex에서 Future 호출 방법?
5. **시나리오:** Batch 실행 중 실패·성공 레코드 ID 얻기?
6. 트리거 이벤트
7. 트리거 컨텍스트 변수?
8. Web-to-Case 설명?
9. 비동기 유형?
