# Apex 트리거 해결 시나리오 모음

> Salesforce 개발 스킬 향상을 위한 트리거 사용 사례.

1. Account 생성 시 Industry='Media'면 Rating을 Hot으로.
2. Opportunity 생성 시 Amount > 100000이면 description에 'Hot Opportunity'.
3. Account 삽입 시 CopyBillingToShipping 체크되면 청구→배송 주소 복사.
4. Position 생성 시 New Position이고 Open Date·Min Pay·Max Pay 미입력이면 기본값(오늘, 10000, 15000).
5. Account 생성 시 관련 Contact 생성.
6. Account 생성 시 관련 Opportunity 생성.
7. Account에 Case 생성 시 'Latest Case Number'에 최근 case 번호.
8. 'Recent Opportunity Amount'에 최근 생성 Opportunity 금액.
9. Account에 Contact·Opportunity 체크박스. 체크 시 관련 레코드 생성(Opportunity는 Active=Yes일 때만).
10. Account phone 업데이트 시 description에 이전·새 값 기록.
11. Account 삽입·업데이트 시 CopyBillingToShipping 체크되면 주소 복사.
12. Account 생성·업데이트 시 Industry='Media'면 Rating을 Hot.
13. Opportunity Stage 업데이트 시 description을 'Closed Lost'/'Closed Won'/'Open'으로.
14. Account phone 업데이트 시 모든 관련 Contact Home Phone에 채우기(Map).
15. 동일(Parent-Child SOQL).
16. Account 청구 주소 업데이트 시 관련 Contact 우편 주소(Map).
17. 동일(Parent-Child SOQL).
18. Opportunity Stage 변경 시 Task 생성·할당.
19. Account Active 'Yes'→'No' 시 관련 Opportunity를 Closed Lost로(Closed Won 제외).
20. Active가 Yes면 Account 삭제 불가.
21. 7일 전 생성 레코드 편집 방지.
22. addError()로 Opportunity 생성 시 Amount null이면 오류.
23. Opportunity가 Closed Lost인데 Reason 미입력이면 검증 오류.
24. System Administrator만 Account 삭제 가능.
25. Closed Opportunity는 System Administrator만 삭제 가능.
26. 관련 Opportunity가 있으면 Account 삭제 방지.
27. 관련 Case가 있으면 Account 삭제 방지.
28. Employee 삭제 시 Account의 'Left Employee Count' 업데이트.
29. Employee 복원 시 Active=true.
30. Employee 복원 시 'Left Employee Count' 업데이트.
31. Employee 삽입·삭제·복원 시 'Present Employee Count' 업데이트(Parent-Child SOQL).
32. Contact 생성 시 지정 템플릿으로 이메일 전송.
33. Case에 "Partner Case"·"Customer Case" 레코드 타입. 레코드 타입별 총 수를 Account에 채우기.
34. Opportunity 생성/금액 업데이트 시 Account Annual Revenue에 총액(롤업). 삭제·복원 시도 업데이트.
35. Database 클래스와 addError() 사용.
36. Opportunity가 closed won/lost 시 description 업데이트(재귀 주의).
37. Account 소유자 변경 시 관련 Contact 소유자 업데이트(Map 없이).
38. 동일(Map 사용).
39. "System Administrator" 활성 User 삽입 시 "Admins" Public Group에 추가.
40. Contact Email 기반 중복 방지.
41. Account OWD=Private. 생성 시 Standard User 프로필 사용자에게 자동 공유.
42. Trigger.isExecuting 컨텍스트 변수 데모.
