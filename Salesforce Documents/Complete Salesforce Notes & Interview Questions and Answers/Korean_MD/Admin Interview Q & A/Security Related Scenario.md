# 보안 관련 시나리오 (접근 권한 판단)

> 약어: CRED = Create/Read/Edit/Delete (생성/읽기/편집/삭제), P'set = Permission Set(권한 집합), OWD = 조직 전체 기본값

**시나리오 1**
- 오브젝트: Accounts / 사용자: Priya, Rohan / OWD: Private
- 프로필(Priya): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Priya): Edit Accounts = Yes
- 역할: Priya는 역할 계층에서 Rohan보다 아래
- **질문:** Priya가 Rohan의 Account 레코드를 편집할 수 있나요?
- **답변:** ❌ 아니요. OWD가 Private이고 Priya에게 "View All" 또는 "Modify All" 권한이 없기 때문입니다.

**시나리오 2**
- 오브젝트: Cases / 사용자: Sam, Arjun / OWD: Public Read-Only
- 프로필(Sam): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Sam): 없음
- 역할: Sam은 Arjun과 같은 계층 수준
- **질문:** Sam이 Arjun의 Case 레코드를 편집할 수 있나요?
- **답변:** ❌ 아니요. OWD가 Public Read-Only이고 Sam에게 "Modify All" 권한이 없기 때문입니다.

**시나리오 3**
- 오브젝트: Opportunities / 사용자: Neha, Amit / OWD: Private
- 프로필(Neha): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Neha): Modify All = Yes
- 역할: Neha는 Amit보다 아래
- **질문:** Neha가 Amit의 Opportunity 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. Neha가 권한 집합에서 "Modify All" 권한을 가지고 있기 때문입니다.

**시나리오 4**
- 오브젝트: Contacts / 사용자: Ravi, Sneha / OWD: Public Read-Only
- 프로필(Ravi): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Ravi): 없음
- 역할: Ravi는 Sneha보다 위
- **질문:** Ravi가 Sneha의 Contact 레코드를 편집할 수 있나요?
- **답변:** ❌ 아니요. OWD가 Public Read-Only이고 Ravi에게 "Modify All" 권한이 없기 때문입니다.

**시나리오 5**
- 오브젝트: 커스텀 오브젝트 Invoices / 사용자: Karan, Pooja / OWD: Private
- 프로필(Karan): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Karan): 없음
- 역할: 역할 계층 없음
- **질문:** Karan이 Pooja의 Invoice 레코드를 볼 수 있나요?
- **답변:** ❌ 아니요. OWD가 Private이고 "View All" 권한이 없기 때문입니다.

**시나리오 6**
- 오브젝트: Cases / 사용자: Manish, Riya / OWD: Public Read/Write
- 프로필(Manish): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Manish): 없음
- 역할: 역할 미할당
- **질문:** Manish가 Riya의 Case 레코드를 삭제할 수 있나요?
- **답변:** ❌ 아니요. Public Read/Write는 편집은 허용하지만 삭제는 허용하지 않기 때문입니다.

**시나리오 7**
- 오브젝트: Tasks / 사용자: Akash, Meena / OWD: Private
- 프로필(Akash): CRED = Yes | View All = Yes | Modify All = No
- 권한 집합(Akash): Modify All = Yes
- 역할: Akash는 Meena보다 아래
- **질문:** Akash가 Meena의 Task 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. 권한 집합을 통해 "Modify All" 권한을 가지고 있기 때문입니다.

**시나리오 8**
- 오브젝트: Orders / 사용자: Aditya, Simran / OWD: Private
- 프로필(Aditya): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Aditya): View All = Yes
- 역할: 역할 미할당
- **질문:** Aditya가 Simran의 Order 레코드를 볼 수 있나요?
- **답변:** ✅ 예. 권한 집합을 통해 "View All" 권한을 가지고 있기 때문입니다.

**시나리오 9**
- 오브젝트: 커스텀 오브젝트 Training Sessions / 사용자: Vivek, Anjali / OWD: Public Read-Only
- 프로필(Vivek): CRED = Yes | View All = Yes | Modify All = No
- 권한 집합(Vivek): Modify All = Yes
- 역할: Vivek은 Anjali보다 아래
- **질문:** Vivek이 Anjali의 Training Session 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. 권한 집합을 통해 "Modify All" 권한을 가지고 있기 때문입니다.

**시나리오 10**
- 오브젝트: Quotes / 사용자: Rohan, Priyanka / OWD: Private
- 프로필(Rohan): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Rohan): Edit Quotes = Yes
- 역할: Rohan은 Priyanka보다 위
- **질문:** Rohan이 Priyanka의 Quote 레코드를 편집할 수 있나요?
- **답변:** ❌ 아니요. OWD가 Private이고 "Modify All" 권한이 없기 때문입니다.

**시나리오 11**
- 오브젝트: Leads / 사용자: Aditi, Suresh / OWD: Private
- 프로필(Aditi): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Aditi): View All = Yes
- 역할: 역할 미할당
- **질문:** Aditi가 Suresh의 Lead 레코드를 볼 수 있나요?
- **답변:** ✅ 예. 권한 집합을 통해 "View All" 권한을 가지고 있기 때문입니다.

**시나리오 12**
- 오브젝트: Opportunities / 사용자: Harsh, Divya / OWD: Private
- 프로필(Harsh): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Harsh): Modify All = Yes
- 역할: Harsh는 Divya보다 아래
- **질문:** Harsh가 Divya의 Opportunity 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. "Modify All" 권한은 해당 오브젝트의 모든 레코드 편집을 허용하기 때문입니다.

**시나리오 13**
- 오브젝트: Cases / 사용자: Tanmay, Juhi / OWD: Public Read-Only
- 프로필(Tanmay): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Tanmay): 없음
- 역할: Tanmay는 Juhi보다 아래
- **질문:** Tanmay가 Juhi의 Case 레코드를 편집할 수 있나요?
- **답변:** ❌ 아니요. OWD가 Public Read-Only이고 "Modify All" 권한이 없기 때문입니다.

**시나리오 14**
- 오브젝트: 커스텀 오브젝트 Subscriptions / 사용자: Rohit, Natasha / OWD: Private
- 프로필(Rohit): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Rohit): View All = Yes
- 역할: 역할 미할당
- **질문:** Rohit이 Natasha의 Subscription 레코드를 볼 수 있나요?
- **답변:** ✅ 예. 권한 집합에서 "View All" 권한을 가지고 있기 때문입니다.

**시나리오 15**
- 오브젝트: Tasks / 사용자: Alok, Ishita / OWD: Private
- 프로필(Alok): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Alok): Modify All = Yes
- 역할: Alok은 Ishita보다 아래
- **질문:** Alok이 Ishita의 Task 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. "Modify All"은 해당 오브젝트의 모든 레코드 편집을 허용하기 때문입니다.

**시나리오 16**
- 오브젝트: Accounts / 사용자: Vikram, Sneha / OWD: Public Read-Only
- 프로필(Vikram): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Vikram): Modify All = Yes
- 역할: Vikram은 Sneha보다 위
- **질문:** Vikram이 Sneha의 Account 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. 권한 집합을 통해 "Modify All" 권한을 가지고 있기 때문입니다.

**시나리오 17**
- 오브젝트: Orders / 사용자: Ramesh, Anjali / OWD: Private
- 프로필(Ramesh): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Ramesh): View All = Yes
- 역할: 역할 미할당
- **질문:** Ramesh가 Anjali의 Order 레코드를 볼 수 있나요?
- **답변:** ✅ 예. 권한 집합을 통해 "View All" 권한을 가지고 있기 때문입니다.

**시나리오 18**
- 오브젝트: Leads / 사용자: Meera, Rahul / OWD: Public Read-Only
- 프로필(Meera): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Meera): 없음
- 역할: Meera는 Rahul보다 아래
- **질문:** Meera가 Rahul의 Lead 레코드를 편집할 수 있나요?
- **답변:** ❌ 아니요. OWD가 Public Read-Only이고 "Modify All" 권한이 없기 때문입니다.

**시나리오 19**
- 오브젝트: 커스텀 오브젝트 Assignments / 사용자: Kunal, Priya / OWD: Private
- 프로필(Kunal): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Kunal): Modify All = Yes
- 역할: 역할 미할당
- **질문:** Kunal이 Priya의 Assignment 레코드를 편집할 수 있나요?
- **답변:** ✅ 예. 오브젝트에 대해 "Modify All" 권한을 가지고 있기 때문입니다.

**시나리오 20**
- 오브젝트: Cases / 사용자: Mohan, Jyoti / OWD: Public Read/Write
- 프로필(Mohan): CRED = Yes | View All = No | Modify All = No
- 권한 집합(Mohan): 없음
- 역할: 역할 미할당
- **질문:** Mohan이 Jyoti의 Case 레코드를 삭제할 수 있나요?
- **답변:** ❌ 아니요. Public Read/Write는 편집은 허용하지만 삭제는 허용하지 않기 때문입니다.
