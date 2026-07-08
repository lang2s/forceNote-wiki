---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Scenario based interview Questions]
---

# 시나리오 기반 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. Account 오브젝트에서 첫 번째 Opportunity가 언제 생성되었는지 표시하려면?**

롤업 요약(Rollup Summary)을 사용하고, 집계 함수(생성 날짜 필드의 최소값)를 사용합니다.

**2. 삭제된 레코드를 복원(undelete)하면 레코드의 ID가 변경되나요?**

ID 필드는 레코드 생성 시점에 생성되며 절대 변경되지 않습니다.

**3. 관리자가 사용자에게 View All Data, Modify All Data를 포함한 광범위한 권한을 부여했습니다. 그런데도 사용자가 일부 필드에 접근하거나 수정하지 못합니다. 이유가 무엇일까요?**

View All Data, Modify All Data, View All, Modify All 권한은 필드 수준 보안(field-level security)을 무시(override)하지 않습니다. 사용자는 오브젝트의 각 필드를 읽거나 편집하려면 여전히 필드 권한을 가지고 있어야 합니다.

**4. IT 부서가 모든 Salesforce 사용자가 Account 레코드에 대해 표준 명명 규칙을 준수하도록 보장하려고 합니다. 이 명명 규칙을 어떻게 적용하나요?**

검증 규칙(Validation Rule)을 사용해 사용자가 입력한 이름을 미리 정의된 명명 규칙 기준과 비교합니다.

**5. 사용자 A는 자신의 Account 레코드 10개를, 사용자 B는 모든 Account 레코드 30개를 가지고 있으며, 사용자 C는 어떤 레코드도 볼 수 없고 오브젝트의 탭조차 볼 수 없습니다. (참고: 세 사용자 모두 같은 프로필입니다.)**

- 프로필: 탭 숨김(Tab hidden)
- OWD: Private
- 권한 집합 1: 탭 표시(Tab visible) → 사용자 A와 B에게 할당
- 권한 집합 2: View All → 사용자 B에게 할당

**6. 사용자가 프로필에서 Contract 오브젝트에 대한 오브젝트 수준 CRUD 접근 권한을 가지고 있는데도 Contract 레코드를 삭제할 수 없습니다. 이유가 무엇인가요?**

프로필 수준에서 "Delete Activated Contracts" 시스템 권한이 필요합니다.
경로: Setup → Profiles → [사용자 프로필] → System Permissions → Contract: Delete Activated Contracts

**7. 사용자가 40,000개의 레코드를 삭제하되 누구도 복구할 수 없게 하려고 합니다. 어떻게 달성하나요?**

대량 레코드를 영구적으로 삭제하려면 Hard Delete를 사용합니다. 이를 활성화하려면 사용자 프로필에서 "Bulk API Hard Delete"를 활성화하고, Data Loader 같은 도구를 사용해 하드 삭제합니다(Data Loader 설정에서 Enable Bulk API와 Enable Hard Delete 체크).

**8. 팀이 Account 오브젝트의 일부 중요한 필드 업데이트를 이전 값과 새 값과 함께 모니터링해야 한다는 것을 알게 되었습니다. 어떻게 달성하나요?**

이전 값과 새 값을 추적하려는 필드에 대해 필드 추적 이력(field tracking history)을 활성화합니다.

**9. Service Request 오브젝트에 Service Type과 Priority Level 두 필드가 있습니다. Priority Level 필드 옵션이 선택된 Service Type에 따라 달라집니다. 어떻게 구현하나요?**

종속 선택 목록(dependent picklist)을 사용해 이 요구사항을 구현할 수 있습니다.

**10. 배치 클래스 3개가 있고 실행할 때 서로 겹치지 않도록 하려면 어떻게 하나요?**

각 배치 클래스의 finish() 메서드를 사용해 현재 배치가 완료된 후 다음 배치 클래스를 시작합니다.

**11. 운영 환경(production)에서 트리거를 수정하거나 비활성화할 수 있나요?**

아니요, 운영 환경에서 트리거를 직접 수정하거나 비활성화할 수 없습니다.

**12. 'with sharing'으로 주석 처리된 Apex 클래스에 custom 필드 status__c에 대한 SOQL 쿼리가 포함되어 있습니다. 이 필드에 접근 권한이 없는 사용자가 코드를 실행하면 어떤 오류가 발생하나요?**

"with sharing" 키워드는 레코드 수준 보안만 적용합니다. 필드 수준 보안은 명시적으로 지정하지 않는 한 자동으로 적용되지 않습니다. 따라서 이 경우 오류가 발생하지 않습니다.

**13. 사용자가 동결(frozen)되고 이메일 경고가 그 이메일 주소와 연결되어 있다면, 여전히 이메일을 받나요?**

사용자를 동결하는 것은 Salesforce 로그인만 막습니다. 이메일 경고가 발송되는 것은 막지 못합니다.

**14. 같은 플로우 내에서 User와 Account 오브젝트 모두에 DML을 수행하려고 합니다. 이 플로우에서 Mixed DML 오류를 어떻게 피하나요?**

Schedule path(예약 경로)를 사용해 그 경로에서 둘 중 하나의 DML을 수행하면 Mixed DML 예외를 피할 수 있습니다.

**15. 서로 관련 없는 두 컴포넌트가 있습니다. 한 컴포넌트에서 다른 컴포넌트로 데이터를 전달하려면 어떻게 하나요?**

서로 관련 없는 두 컴포넌트 간 통신을 처리하려면 Lightning Message Service가 이상적인 솔루션입니다.

**16. 10,000개의 레코드가 있고 배치 크기가 200이면 몇 개의 배치가 실행되나요?**

배치 수 = 레코드 수 / 배치 크기 = 10,000 / 200 = 50개의 배치가 실행됩니다.

**17. Anonymous Window(익명 실행 창)에서 작성된 코드는 기본적으로 User 모드와 System 모드 중 어디에서 실행되나요?**

Anonymous Window는 기본적으로 User 모드에서 실행됩니다.

**18. Test Class에서 private 메서드에 어떻게 접근하나요?**

메서드를 @TestVisible로 주석 처리하여 접근합니다.

**19. 관련된 Contact와 Opportunity가 하나도 없는 Account를 조회하세요.**

```sql
SELECT Id, Name FROM Account
WHERE Id NOT IN (SELECT AccountId FROM Contact) AND
Id NOT IN (SELECT AccountId FROM Opportunity)
```

**20. Case Owner가 활성 상태인 Contact와 연결된 모든 Case를 조회하세요.**

```sql
SELECT Id, CaseNumber, Owner.Name, ContactId, Contact.LastName
FROM Case
WHERE ContactId != NULL AND
Owner.IsActive = TRUE
```
