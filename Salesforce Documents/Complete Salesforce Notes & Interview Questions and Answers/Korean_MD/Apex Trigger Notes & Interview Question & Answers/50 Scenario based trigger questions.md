# 시나리오 기반 트리거 문제 50선

1. Case가 origin=email로 생성되면 status를 New, Priority를 Medium으로 설정.
2. Lead가 LeadSource=Web으로 생성되면 rating을 Cold, 아니면 Hot.
3. 새 Account 레코드 생성 시 연관 Contact 레코드 자동 생성.
4. Account가 Industry=Banking으로 생성되면 Contact 생성(LastName=Account명, phone=account phone).
5. Account의 "Number of Locations" 필드에 입력한 수만큼 Contact 생성.
6. Account 생성 시 Industry가 'Media'면 Rating을 Hot으로.
7. Opportunity 생성 시 Amount > 100000이면 description에 'Hot Opportunity'.
8. Account 삽입 시 CopyBillingToShipping 체크박스가 체크되면 청구→배송 주소 자동 복사.
9. Position(커스텀) 생성 시 New Position이고 Open Date·Min Pay·Max Pay 미입력이면 기본값(Open Date=오늘, Min Pay=10000, Max Pay=15000).
10. Account 생성 시 관련 Contact 생성.
11. Account 생성 시 관련 Opportunity 생성.
12. Account에 Case 생성 시 'Latest Case Number' 필드에 최근 case 번호 기록.
13. 'Recent Opportunity Amount' 필드에 최근 생성된 Opportunity 금액 기록.
14. Account에 Contact·Opportunity 체크박스 두 개. 체크 시 해당 레코드 생성(Opportunity는 Active picklist=Yes일 때만).
15. Account phone 업데이트 시 description에 "Phone is Updated!".
16. Account 삽입·업데이트 시 CopyBillingToShipping 체크되면 청구→배송 주소 복사.
17. Opportunity Stage 업데이트 시 description에 'Closed Lost'/'Closed Won'/'Open'.
18. Account phone 업데이트 시 phone 번호 채우기.
19. Account phone 업데이트 시 모든 관련 Contact의 Home Phone에 채우기(Parent-Child SOQL).
20. Account 청구 주소 업데이트 시 관련 Contact 우편 주소 업데이트(Map).
21. 동일(Parent-Child SOQL).
22. Opportunity Stage 변경 시 Task 레코드 생성·할당.
23. Account Active가 'Yes'→'No'로 업데이트되면 관련 Opportunity를 Closed Lost로(Closed Won 제외).
24. Active가 Yes면 Account 삭제 불가.
25. 7일 전 생성된 레코드 편집 방지.
26. addError()로 Opportunity 생성 시 Amount가 null이면 오류.
27. Opportunity가 Closed Lost인데 Closed Lost Reason 미입력이면 검증 오류(before update).
28. System Administrator 프로필만 Account 삭제 가능.
29. Opportunity가 closed면 System Administrator만 삭제 가능.
30. 관련 Opportunity가 있으면 Account 삭제 방지.
31. 관련 Case가 있으면 Account 삭제 방지.
32. Employee 레코드 삭제 시 Account의 'Left Employee Count' 업데이트.
33. Employee 레코드 복원 시 Active=true.
34. Employee 삽입·삭제·복원 시 'Present Employee Count' 업데이트(Parent-Child SOQL).
35. Contact 생성 시 지정 템플릿으로 이메일 전송.
36. Case에 "Partner Case"·"Customer Case" 레코드 타입 생성.
37. Opportunity 생성/금액 업데이트 시 관련 Opportunity 총액을 Account의 Annual Revenue에(롤업 요약). 삭제·복원 시도 업데이트.
38. Account 소유자 변경 시 관련 Contact 소유자도 업데이트(Map).
39. "System Administrator" 프로필의 활성 User 삽입 시 "Admins" Public Group에 추가.
40. Contact Email 기반 중복 방지.
41. Account OWD=Private. Account 생성 시 Standard User 프로필 사용자에게 자동 공유.
42. Lead 생성 시 Account·Contact·Opportunity로 자동 전환.
43. Contact Email & Phone 기반 중복 방지.
44. System Admin만 Task 삭제 가능.
45. PDF를 Document에 업로드, Lead 생성 시 이메일 첨부로 전송.
46. Account와 연관된 OpportunityLineItem 생성 시 Asset 생성.
47. Account·Opportunity에 다중 선택 목록(A,B,C,D,F) 추가. Opportunity 업데이트 시 Account도 같은 값으로 업데이트.
48. OpportunityLineItem 생성 시 견적(quotation) 삽입.
49. OpportunityLineItem 삭제 시 Opportunity도 삭제.
50. Account의 type 변경 시 모든 Contact에 이메일 전송(Subject: Account Update Info).
