---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SALESFORCE FLOW INTERVIEW QUESTIONS]
---

# SALESFORCE FLOW 면접 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 개요

이 면접 가이드는 다음 Salesforce 면접 준비를 돕기 위한 45개 이상의 질문으로 구성되어 있습니다. 질문은 일반적으로 Salesforce Flow 개념에 대한 지식과 이를 비즈니스 사용 사례 해결에 적용하는 능력을 평가하도록 설계되었습니다.

**1. Salesforce란 무엇인가요?**

Salesforce는 Marketing Cloud, Service Cloud, Sales Cloud 등 다양한 클라우드 애플리케이션을 제공하는 클라우드 기반 CRM(고객 관계 관리) 도구입니다. Force.com 플랫폼 위에 개발되었습니다.

**2. Flow란?**

코딩 기술 없이 비즈니스 프로세스를 구축하고 자동화할 수 있는 자동화 도구입니다. 데이터 수집·업데이트, 승인 자동화, 레코드 생성 등 다양한 작업에 사용할 수 있습니다.

**3. Flow Builder란?**

Salesforce에서 Flow를 만드는 데 사용되는 사용자 인터페이스입니다. Canvas, Toolbox, Button bar의 세 가지 주요 컴포넌트로 구성됩니다.

**4. Salesforce의 Flow 유형은?**

Screen Flow, Auto-launched Flow, Record-Triggered Flow, Schedule-Triggered Flow, Platform Event-Triggered Flow.

**5. Flow당 최대 몇 개의 버전이 있을 수 있나요?**

50개. 더 많은 버전을 만들려면 이전 버전을 삭제해야 합니다.

**6. Flow 템플릿이란?**

비즈니스가 Flow 구조를 활용하고 요구사항에 맞게 수정할 수 있도록 미리 설계된 Flow입니다.

**7. Flow Interview란?**

Flow의 특정 실행을 의미하며, 해당 Flow의 완전한 한 번의 실행을 나타냅니다.

**8. Salesforce Flow의 fault connector란?**

Flow 실행 중 발생할 수 있는 오류와 예외 관리를 용이하게 하는 커넥터입니다.

**9. Pause 요소는 어떤 유형의 Flow와 함께 사용할 수 있나요?**

Auto-launched Flow와 Scheduled Flow.

**10. 시간 종속 Flow를 트리거할 수 있나요?**

네, Scheduled Flow를 사용해 이 작업을 수행할 수 있습니다.

**11. fault connector를 사용해 오류 메시지를 사용자에게 표시하려면 어떻게 저장하나요?**

Screen Flow 컴포넌트에서 `{!$Flow.FaultMessage}`를 사용합니다.

**12. Flow당 허용되는 최대 테스트 수는?**

200개.

**13. Flow 테스트는 어떤 유형의 Flow에서 사용 가능한가요?**

Record-triggered Flow와 Data Cloud-triggered Flow에서만 Flow 테스트를 실행할 수 있습니다.

**14. Salesforce Flow에서 사용되는 최신 API 버전은?**

60.

**15. Salesforce Flow에서 한 배치에 허용되는 총 중복 업데이트 수는?**

12.

**16. 권장 모범 사례에 따르면 오브젝트당 같은 Flow를 몇 개 만들어야 하나요?**

하나.

**17. 관리형 패키지(managed package)에서 설치된 Salesforce Flow를 열 수 있나요?**

아니요.

**18. 삭제된 요소가 포함된 비활성 Flow를 테스트하면 어떻게 되나요?**

삭제(Delete) 작업이 트리거됩니다.

**19. Salesforce에서 Flow를 어떻게 트리거하나요?**

레코드 생성, 레코드 업데이트, 버튼 클릭, 커스텀 Apex 코드 등 다양한 이벤트로 트리거할 수 있습니다.

**20. Flow 내 서로 다른 요소 간에 데이터를 어떻게 전송하나요?**

변수를 활용해 요소 간에 정보를 교환합니다. 변수는 레코드 ID, 필드 값, 사용자 입력 등 다양한 데이터를 저장하는 컨테이너 역할을 하며, Flow의 여러 요소 전반에서 데이터에 접근할 수 있게 합니다.

**21. Flow에서 Screen 요소의 목적은?**

Flow 실행 중 사용자가 데이터 입력이나 선택을 통해 능동적으로 기여할 수 있게 합니다. 필드, 선택 목록, 라디오 버튼, 체크박스 등 다양한 인터페이스 요소를 제시할 수 있습니다.

**22. Flow의 Decision 요소를 설명하세요.**

조건을 평가하고 적절한 조치 방향을 결정할 수 있게 해줍니다. "if-else" 문과 유사하며, Flow 내 분기 로직을 구성하는 강력한 도구입니다.

**23. Flow의 Loop 요소란 무엇이며 어떻게 사용하나요?**

레코드 컬렉션을 반복하거나 일련의 액션을 반복 실행할 수 있게 해줍니다. Flow 내에서 작업을 반복적으로 수행해야 할 때 유용합니다.

**24. Salesforce Flow에서 시간당 실행되는 예약된 액션의 총 수는?**

1,000.

**25. Salesforce Flow 수식 필드에서 VLOOKUP 함수가 지원되나요?**

아니요.

**26. Salesforce 조직에서 특정 시점에 대기 중일 수 있는 Flow Interview는 몇 개인가요?**

Salesforce는 더 이상 일시 중지 및 대기 중인 Flow Interview에 대해 조직당 한도를 적용하지 않습니다. 다만, 조직 내 이러한 인터뷰 수는 이제 사용 가능한 저장 용량에 따라 달라집니다.

**27. Flow를 사용해 레코드를 어떻게 생성하나요?**

"Create Records" 요소를 사용합니다. 오브젝트, 필드 값, 필요한 관계를 지정할 수 있습니다.

**28. Flow를 사용해 기존 레코드를 업데이트할 수 있나요?**

네, "Update Records" 요소로 레코드를 수정할 수 있습니다. 대상 오브젝트를 지정하고, 업데이트할 레코드를 식별하는 조건을 설정하고, 원하는 새 필드 값을 제공합니다.

**29. Flow에서 레코드를 어떻게 쿼리하나요?**

"Get Records" 요소를 사용합니다. 오브젝트, 필드, 조건을 지정해 원하는 레코드를 조회합니다.

**30. Subflow란?**

다른 Flow 내에서 호출할 수 있는 재사용 가능한 Flow입니다.

**31. Flow에서 Action 요소의 사용을 설명하세요.**

Action 요소는 이메일 전송, 레코드 업데이트, Apex 코드 호출 등 특정 액션을 수행합니다.

**32. "Record-Triggered Flow"의 목적은?**

레코드가 생성되거나 업데이트될 때 자동으로 시작됩니다.

**33. Flow에서 레코드를 수정하는 동안 다른 사람이 업데이트하지 못하게 하려면?**

Action 요소의 Lock Record 액션을 사용해 레코드를 잠그거나 풀 수 있고, 잠긴 동안 누가 편집할 수 있는지 지정할 수 있습니다.

**34. 더 나은 사용자 경험을 위해 Screen Flow의 오류 처리를 어떻게 개선하나요?**

Spring '25부터 Screen Flow는 즉시 입력 검증(immediate input validation)을 지원합니다. 즉, "Next"를 클릭할 때까지 기다리지 않고 사용자가 필드와 상호작용하는 즉시 오류가 표시되어 더 빠른 오류 수정이 가능합니다.

**35. Flow와 Flow 템플릿의 차이는?**

Flow는 사용자가 만든 맞춤형 비즈니스 솔루션입니다. Flow 템플릿은 Salesforce가 제공하는, 특정 요구사항에 맞게 커스터마이징할 수 있는 사전 구축된 재사용 가능한 Flow입니다.

**36. "Before Save" Flow의 목적은?**

레코드가 데이터베이스에 저장되기 전에 실행되는 Record-Triggered Flow입니다.

**37. Salesforce Flow에서 쿼리되는 레코드 수를 제한할 수 있나요?**

네, Get Records 요소에서 레코드 한도를 지정해 조회되는 레코드 수를 직접 제한할 수 있습니다(SOQL의 LIMIT와 유사). 별도의 정렬이나 필터링 요소가 필요 없습니다. 고정 값(2~20,000) 또는 숫자 변수를 사용해 컬렉션 크기를 동적으로 제어할 수 있습니다.

**38. Flow가 가질 수 있는 최대 요소 수는?**

API 버전 57.0부터 Salesforce는 2,000개 Flow 요소 한도를 제거했습니다. API 버전 56.0 이하에서는 최대 2,000개 요소로 제한되었습니다.

**39. LWC 컴포넌트에서 Flow를 어떻게 트리거하나요?**

Salesforce는 `<lightning-flow>` 기본 컴포넌트를 제공하여 LWC에서 직접 Flow를 임베드하고 실행할 수 있게 합니다. Flow에 커스텀 LWC나 Aura 컴포넌트가 포함되어 있으면, Lightning Web Runtime에서 실행되는 Experience Cloud 사이트에서는 `<lightning-flow>`를 사용할 수 없습니다.

**40. Salesforce Flow에서 Apex 클래스를 어떻게 호출하나요?**

Apex 클래스 안에 Invocable Method를 만들어야 합니다. `@InvocableMethod` 어노테이션을 추가하면 Flow가 접근할 수 있습니다.

**41. Salesforce Flow의 Transform 요소란?**

소스 데이터를 타겟 데이터로 매핑하고 변환할 수 있게 해줍니다. Screen Flow, 트리거 없는 Auto-launched Flow, Record-Triggered Flow와 호환됩니다.

**42. Enterprise, Unlimited, Developer 에디션에서 Flow 유형당 허용되는 최대 활성 Flow 수는?**

2,000.

**43. Enterprise, Unlimited, Developer 에디션에서 Flow 유형당 허용되는 최대 총 Flow 수는?**

4,000.

**44. Salesforce Flow의 schedule path란?**

Record-Triggered Flow에서 이벤트 발생 후 설정된 기간만큼 액션을 지연시킬 수 있게 해줍니다. 예를 들어 Opportunity가 Closed Won으로 표시되면 14일 후에 자동으로 후속 이메일을 보낼 수 있습니다.

**45. Salesforce에서 Flow Interview가 실패하면 누가 이메일을 받나요?**

프로세스나 Flow Interview가 실패하면, 해당 프로세스나 Flow를 마지막으로 수정한 관리자에게 상세 이메일이 전송됩니다.

**46. Salesforce Flow의 모범 사례는?**

- 항상 Flow를 테스트하기
- Subflow 사용 고려하기
- 루프 안에서 DML 문 수행하지 않기
- Flow를 문서화하기
- ID를 하드코딩하지 않기
- fault 처리 계획하기
