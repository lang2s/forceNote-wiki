---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Admin Interview questions and Answers 👇]
---

# Salesforce 관리자(Admin) Q&A 완벽 가이드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 개요

이 면접 가이드는 다음 Salesforce 면접 준비를 돕기 위한 100개 이상의 질문으로 구성되어 있습니다. 질문은 일반적으로 Salesforce 개념에 대한 지식과 이를 비즈니스 사용 사례 해결에 적용하는 능력을 평가하도록 설계되었습니다.

**1. 클라우드 컴퓨팅이란?**

데이터베이스, 서버, 소프트웨어 등 컴퓨팅 서비스를 인터넷을 통해 온디맨드(on-demand)로 제공하는 것입니다.

**2. SaaS란?**

Software as a Service의 약자입니다. 소프트웨어가 인터넷을 통해 서비스로 제공되는 클라우드 컴퓨팅 모델입니다.

**3. PaaS란?**

Platform as a Service의 약자입니다. 서드파티 제공자가 고객이 인프라 유지의 복잡성 없이 애플리케이션을 배포하고 유지할 수 있는 플랫폼을 제공하는 클라우드 컴퓨팅 모델입니다.

**4. Salesforce란?**

Marketing Cloud, Service Cloud, Sales Cloud 등 다양한 클라우드 애플리케이션을 제공하는 클라우드 기반 CRM 도구입니다. Force.com 플랫폼 위에 개발되었습니다.

**5. Salesforce의 오브젝트(Object)란?**

특정 유형의 레코드에 대한 데이터를 저장하는 데이터베이스 테이블처럼 작동합니다. 표준 오브젝트(Account, Contact, Lead 등)는 조직에 기본으로 제공됩니다. 커스텀 오브젝트는 비즈니스 요구사항을 충족하기 위해 사용자가 만듭니다. 커스텀 오브젝트의 API 이름은 `__c`로 끝납니다.

**6. 외부 오브젝트(External Object)란?**

Salesforce 조직 외부에 저장된 데이터를 매핑하기 위해 만드는 오브젝트입니다.

**7. Salesforce의 필드(Field)란?**

오브젝트나 레코드 타입의 일부로 저장되는 데이터를 나타냅니다. 비즈니스 요구사항에 따라 통화, 백분율, 날짜 등 다양한 유형의 데이터를 저장하는 데 사용할 수 있습니다.

**8. Salesforce의 TAB이란?**

특정 오브젝트에 대한 접근을 제공하는 사용자 인터페이스 요소입니다. 각 탭은 하나의 오브젝트를 나타냅니다.

**9. Salesforce의 레코드(Record)란?**

오브젝트 내 필드의 모음입니다. 적절한 권한이 있는 사용자가 생성, 편집, 삭제할 수 있습니다. Record Type을 통해 프로필에 따라 특정 필드를 사용자에게 표시할 수 있습니다.

**10. Salesforce의 다양한 관계 유형은?**

- **Lookup 관계(일대다):** 두 오브젝트 간의 느슨하게 결합된 관계로, 부모 레코드가 삭제되어도 자식 레코드는 시스템에 남습니다.
- **Master-Detail 관계(일대다):** 두 오브젝트 간의 강하게 결합된 관계로, 부모 레코드가 삭제되면 연결된 자식 레코드도 삭제됩니다.
- **Many-to-Many 관계:** 정션 오브젝트를 사용해 다대다 관계를 만듭니다. 일반적인 부모-자식 또는 일대다 관계가 적합하지 않을 때 사용합니다.

**11. 표준 오브젝트가 Master-Detail 관계의 detail 쪽에 올 수 있나요?**

아니요, 커스텀 오브젝트를 Master-Detail의 master로 둔 경우 표준 오브젝트는 detail 쪽에 올 수 없습니다.

**12. Salesforce 레코드의 표준 필드란?**

미리 정의된 Salesforce 필드입니다. 필수가 아닌 표준 필드가 아닌 한 삭제할 수 없습니다. 일반적인 표준 필드 예: Created By, Owner, Last Modified By.

**13. 오브젝트당 커스텀 필드를 몇 개 만들 수 있나요?**

에디션에 따라 다릅니다. Personal 5, Contact Manager 25, Group 100, Essentials 100, Professional 100, Enterprise 500, Unlimited 및 Performance 800, Developer 500.

**14. 오브젝트에 최대 몇 개의 필드 관계를 만들 수 있나요?**

최대 40개의 관계를 만들 수 있습니다.

**15. 오브젝트에 Lookup 관계 필드를 몇 개 만들 수 있나요?**

38개의 Lookup과 2개의 Master-Detail 관계 필드를 만들거나, 요구사항에 따라 40개 모두 Lookup 필드로 만들 수 있습니다.

**16. Salesforce의 샌드박스란?**

운영 조직의 복제본입니다. 실제 데이터와 프로세스에 영향을 주지 않고 기능을 구성, 커스터마이징, 테스트할 수 있게 합니다.

**17. Salesforce 샌드박스의 유형을 설명하세요.**

- **Developer Sandbox:** 개별 개발자나 소규모 팀용. 저장 한도 200MB.
- **Developer Pro Sandbox:** Developer Sandbox와 유사하지만 더 큰 저장 용량과 커스터마이징 허용. 저장 한도 1GB.
- **Partial Copy Sandbox:** 운영 환경의 부분 복사본. 운영 데이터의 일부를 복사 가능. 저장 한도 5GB.
- **Full Sandbox:** 모든 메타데이터를 포함한 운영 환경의 정확한 복제본. 저장 한도는 운영 조직과 동일.

**18. Roll-Up Summary 필드란?**

관련 자식 레코드 그룹의 데이터를 요약하여 master 레코드에 출력을 표시합니다. SUM, COUNT, MIN, MAX, AVG 등 다양한 함수를 선택할 수 있습니다.

**19. 오브젝트당 롤업 요약 필드를 몇 개 만들 수 있나요?**

오브젝트당 최대 40개.

**20. Master-Detail 관계를 Lookup으로 변환할 수 있나요?**

네, 가능합니다. 단, 변환 전에 master 레코드에 롤업 요약 필드를 만든 경우 해당 필드를 삭제해야 합니다.

**21. Salesforce의 프로필이란?**

사용자가 조직에서 무엇을 보고 구성할 수 있는지 결정하는 권한과 설정의 모음입니다. Setup >> Quick Find에 "Profiles" 입력 >> Profiles 선택으로 확인할 수 있습니다.

**22. Salesforce의 페이지 레이아웃이란?**

레코드의 필드를 사용자에게 표시하는 역할을 합니다. 필드, 섹션, 링크, 커스텀 버튼 등 다양한 요소를 포함해 사용자 경험을 향상시킵니다.

**23. 두 사용자가 같은 프로필을 가질 수 있나요?**

네, 단 한 사용자가 여러 프로필을 가질 수는 없습니다.

**24. Salesforce의 역할(Role)이란?**

조직에서 사용자가 계층 내에서 서로 어떻게 관련되는지 정의하는 데 사용됩니다.

**25. 역할 계층(Role Hierarchy)이란?**

사용자의 역할을 기반으로 Salesforce 오브젝트의 데이터 접근성을 제어하는 방법입니다.

**26. 거버너 한도(Governor Limits)란?**

Salesforce 플랫폼의 사전 정의된 제한 집합입니다. 위반되면 예외 메시지가 발생합니다.

**27. Setup Audit Trail이란?**

Salesforce 조직에서 수행한 설정 변경을 추적합니다. 지난 180일간의 전체 이력을 다운로드할 수 있습니다. Setup >> Quick Find에 "Setup Audit Trail" 입력 >> "View Setup Audit Trail" 선택.

**28. Salesforce의 자동화 도구는?**

로우코드/노코드 접근 방식으로 복잡한 비즈니스 요구사항을 해결할 수 있게 합니다. 예: Workflow, Process Builder, Flow.

**29. Flow란?**

코딩 기술 없이 비즈니스 프로세스를 구축하고 자동화할 수 있는 자동화 도구입니다. 데이터 수집·업데이트, 승인 자동화, 레코드 생성 등 다양한 작업에 사용됩니다.

**30. Salesforce의 Flow 유형은?**

Screen Flow, Auto-launched Flow, Record-Triggered Flow, Schedule-Triggered Flow, Platform Event-Triggered Flow.

**31. Flow당 최대 몇 개의 버전이 있을 수 있나요?**

50개. 더 많은 버전을 만들려면 이전 버전을 삭제해야 합니다.

**32. Flow 템플릿이란?**

비즈니스가 Flow 구조를 활용하고 요구사항에 맞게 수정할 수 있도록 미리 설계된 Flow입니다.

**33. Salesforce의 Report란?**

사용자가 설정한 매개변수를 충족하는 데이터의 모음입니다. 행과 열의 표 형식으로 표시됩니다. 필터 적용, 데이터 그룹화, 그래픽 차트 시각화로 추가 커스터마이징할 수 있습니다.

**34. Salesforce의 리포트 유형은?**

Tabular, Summary, Joined, Matrix 리포트.

**35. Salesforce의 Dashboard란?**

리포트의 시각적 표현입니다.

**36. 대시보드 컴포넌트에 사용할 수 있는 리포트 유형은?**

Summary 리포트와 Matrix 리포트.

**37. Salesforce 리포트의 Bucket Field란?**

기존 필드의 값을 특정 기준에 따라 여러 버킷으로 분류할 수 있는 커스텀 필드입니다. 버킷을 만드는 데 사용하는 필드를 기반으로 각 버킷의 기준을 정의할 수 있습니다. 리포트 타입당 최대 5개의 bucket field를 추가할 수 있습니다.

**38. Dynamic Dashboard란?**

각 사용자가 접근 권한이 있는 데이터를 볼 수 있게 하여 개인화된 데이터 가시성을 제공합니다. Dynamic Dashboard는 개인 폴더에 저장할 수 없습니다.

**39. 이메일 템플릿이란?**

커스터마이징된 헤더, 버튼, HTML 태그 등을 포함한 동적 이메일 템플릿을 만들 수 있게 합니다.

**40. 15자리 레코드 ID를 18자리로 어떻게 변환하나요?**

CASESAFEID() 사용.

**41. Formula 필드란?**

특정 수식과 매개변수를 기반으로 결정된 값을 제공하는 커스텀 필드입니다. 읽기 전용이므로 값을 편집하거나 입력할 수 없습니다.

**42. 사용자의 로그인 이력을 어떻게 추적하나요?**

Setup 메뉴의 Login History 기능을 사용합니다. 지난 6개월간의 로그인 이력을 접근하고 다운로드할 수 있습니다.

**43. Login History로 몇 개의 로그인 이력 레코드를 추적할 수 있나요?**

지난 6개월의 20,000개 레코드를 추적할 수 있습니다.

**44. SOSL이란?**

Salesforce Object Search Language로, 단일 쿼리에서 여러 오브젝트에 걸쳐 레코드를 검색하는 효율적인 방법입니다. SOSL 쿼리 실행 시 sObject 목록이 반환되며, 여러 오브젝트에 걸쳐 동시에 검색할 수 있습니다.

**45. SOQL이란?**

Salesforce Object Query Language로, 특정 오브젝트와 조건을 기반으로 Salesforce 데이터베이스에서 데이터를 가져옵니다. 데이터가 어떤 오브젝트에서 쿼리되어야 하는지 확실할 때만 SOQL을 사용합니다.

**46. Data Import Wizard란?**

Account, Contact, Lead, Solution, Campaign Member, Person Account 등 다양한 표준 오브젝트와 커스텀 오브젝트의 데이터를 쉽게 가져올 수 있게 합니다. 한 번에 최대 50,000개의 레코드를 가져올 수 있습니다. Data Import Wizard로는 Opportunity 오브젝트 레코드를 가져올 수 없습니다.

**47. Data Loader란?**

대량으로 데이터를 효율적으로 가져오고 내보내도록 설계된 도구입니다. 한 번에 최대 5,000,000개의 레코드를 가져올 수 있습니다.

**48. Salesforce Inspector란?**

Salesforce 환경에서 문제를 해결하고 디버깅하는 데 사용되는 크롬 확장 프로그램입니다. 특정 레코드와 관련 필드를 검사하여 더 빠르고 효율적인 문제 식별과 해결을 가능하게 합니다.

**49. Flow Interview란?**

플로우의 특정 실행을 의미하며, 해당 플로우의 완전한 한 번의 실행을 나타냅니다.

**50. Salesforce Flow의 fault connector란?**

플로우 실행 중 발생할 수 있는 오류와 예외 관리를 용이하게 하는 커넥터입니다. 이메일 알림 전송이나 사용자에게 오류 메시지 표시 같은 액션을 수행해 다양한 오류 유형에 대응하도록 돕습니다.

**51. Salesforce의 Apex 프로그래밍 언어란?**

Salesforce 플랫폼에서 사용 가능한 객체 지향 프로그래밍 언어로, 개발자가 커스텀 기능을 개발할 수 있게 합니다. Java와 매우 유사한 구문을 사용합니다.

**52. 비동기 Apex 작업의 유형은?**

Future 메서드, Batch Apex, Queueable Apex, Scheduled Apex.

**53. Batch Apex란?**

단일 작업을 더 작고 관리하기 쉬운 부분으로 나누어 독립적으로 처리할 수 있게 합니다. Database.Batchable 인터페이스를 구현하는 global 클래스로 수행됩니다. 최대 배치 크기는 2,000개 레코드입니다.

**54. Trigger란?**

레코드 삽입이나 업데이트 전후에 실행되는 코드 블록입니다.

**55. Salesforce의 두 가지 트리거 유형은?**

- **Before Trigger:** 데이터베이스에 저장되기 전에 업데이트하거나 검증하는 데 사용됩니다.
- **After Trigger:** 시스템이 설정한 필드 값을 가져오고 레코드 변경을 수정하는 데 사용됩니다. 즉, 다른 레코드에 삽입된 데이터를 기반으로 값을 수정하는 역할을 합니다.

**56. Lookup 관계에서 롤업 요약 필드를 만들 수 있나요?**

아니요, Master-Detail 관계에서만 가능합니다.

**57. 조직에서 사용자를 삭제할 수 있나요?**

사용자를 비활성화할 수는 있지만 삭제할 수는 없습니다.

**58. Custom Settings란?**

커스텀 오브젝트처럼 커스터마이징된 데이터 세트를 생성하는 데 사용됩니다. 조직, 프로필, 개별 사용자와 연결될 수 있습니다. 접근성 관리를 위해 public 또는 protected로 지정할 수 있습니다.

**59. Custom Settings의 유형은?**

List Custom Settings와 Hierarchy Custom Settings.

**60. 검증 규칙(Validation Rule)을 설명하세요.**

레코드에 입력한 정보가 특정 기준을 충족하는지 확인하는 규칙 집합입니다. 정보가 저장되기 전에 올바른지 확인합니다.

**61. Cascade Delete란?**

부모 레코드가 삭제되면 연결된 자식 레코드도 삭제되는 것입니다.

**62. Queue를 설명하세요.**

소유자가 없는(unowned) 레코드로 구성됩니다. Queue에 접근할 수 있는 사용자는 모든 레코드를 검토하고 원하는 것의 소유권을 가져갈 수 있습니다. 목적은 작업 책임을 공유하는 팀에 레코드를 할당, 분배, 우선순위 지정하는 것입니다. 레코드 소유자를 변경하여 수동으로 Queue에 추가할 수 있습니다.

**63. Public Group이란?**

조직의 모든 멤버가 접근하고 사용할 수 있도록 의도된 집단에 리소스나 항목을 할당하는 기능을 합니다.

**64. Apex의 Future Annotation이란?**

Apex 메서드를 비동기적으로 실행하려 할 때 사용됩니다.

**65. Static Resource란?**

이미지, 문서, zip 파일, JavaScript 파일, CSS 파일 등 다양한 유형의 파일을 저장하고 업로드하는 데 유용합니다. 저장 용량은 250MB로 제한됩니다.

**66. 시간 종속 플로우를 트리거할 수 있나요?**

네, Scheduled Flow를 사용해 수행할 수 있습니다.

**67. 공유 규칙(Sharing Rule)이란?**

특정 조건에 따라 레코드를 공유하도록 돕습니다.

**68. 공유 규칙의 유형은?**

소유권 기반 공유 규칙(Owner-based), 기준 기반 공유 규칙(Criteria-based).

**69. Classic 이메일 템플릿의 유형은?**

Text, Letterhead가 있는 HTML, Custom, Visualforce.

**70. Custom Metadata Type이란?**

커스텀 오브젝트와 유사하지만 다른 API 네임스페이스 접미사(`__mdt`)로 지정됩니다. 레코드를 메모리 캐시에 저장하여 쿼리 실행 시 더 빠른 데이터 조회가 가능합니다.

**71. Batch Apex 클래스의 메서드를 설명하세요.**

각 배치는 세 가지 메서드를 구현합니다: start(), execute(), finish().
- **start:** 작업 시작 시 가장 먼저 실행됩니다. execute 메서드가 처리할 레코드나 오브젝트를 수집합니다.
- **execute:** 전달된 각 레코드 세트에 대해 실행됩니다. 각 데이터 그룹에 필요한 모든 처리를 담당합니다.
- **finish:** 모든 배치 처리 후 확인 이메일 전송이나 추가 작업 실행 같은 후처리 작업에 사용됩니다. 모든 배치가 완료된 후 한 번 호출됩니다.

**72. Deployment(배포)란?**

한 샌드박스에서 다른 곳으로 변경(노코드 및 코드)을 마이그레이션하는 프레임워크입니다.

**73. 배포에 사용할 수 있는 도구는?**

Gearset, Ant migration tool, Copado, Flosum.

**74. Freeze User와 Deactivate User의 차이는?**

- **동결(Freeze):** Salesforce 라이선스는 여전히 할당된 채로 조직 접근이 제한됩니다.
- **비활성화(Deactivate):** 조직 접근 제한에 더해 라이선스를 다른 사용자에게 할당할 수 있게 합니다.

**75. 권한 집합(Permission Set)이란?**

Salesforce 조직에서 사용자의 접근을 확장하기 위해 할당된 설정과 권한의 모음입니다.

**76. Debug Log란?**

Salesforce 플랫폼에서 절차가 어떻게 수행되는지에 대한 데이터를 추적하는 시스템 로그입니다. 실행 중 발생하는 예외나 실패에 대한 정보를 제공할 수 있습니다.

**77. 클래스 배포에 필요한 최소 테스트 커버리지는?** 75%.

**78. Apex 테스트 클래스의 @isTest 어노테이션이란?**

이 어노테이션을 추가하면 클래스가 테스트 클래스로 표시되고 Salesforce 테스트 프레임워크 내에서 실행할 수 있게 됩니다.

**79. Flow Builder란?**

Salesforce에서 Flow를 만드는 데 사용되는 사용자 인터페이스입니다. Canvas, Toolbox, Button bar의 세 가지 주요 컴포넌트로 구성됩니다.

**80. Change Set이란?**

한 Salesforce 인스턴스에서 다른 인스턴스로 커스터마이징을 마이그레이션하는 데 사용됩니다. 두 가지 유형이 있습니다: outbound change set과 inbound change set.

**81. Salesforce 에디션은?**

Essential, Professional, Enterprise, Unlimited, Performance, Personal, Contact Manager, Developer 에디션.

**82. Global Picklist Value Set이란?**

여러 오브젝트의 여러 커스텀 선택 목록 필드에서 사용할 수 있는 재사용 가능한 선택 목록 값 세트입니다.

**83. Field Tracking이란?**

특정 필드와 관련 레코드 필드에 대한 변경을 모니터링할 수 있게 합니다.

**84. Salesforce의 보안 수준은?**

조직 수준, 오브젝트 수준, 필드 수준, 레코드 수준 보안.

**85. Account와 Contact 사이에는 어떤 관계가 존재하나요?**

Lookup 관계입니다. 이 표준 오브젝트들은 Master-Detail 관계를 가지지 않지만, Contact의 레코드 접근 방식이 부모 레코드에 의해 제어될 수 있어 유사하게 동작합니다.

**86. 특정 시간 외에 사용자의 로그인을 제한하는 Salesforce 기능은?**

Login Hours 기능이 특정 시간 외의 로그인을 방지합니다.

**87. Joined Report란?**

서로 다른 유형의 여러 리포트를 단일 뷰로 병합하여, 하나의 리포트처럼 보이는 포괄적인 데이터 뷰를 만듭니다.

**88. 다른 Salesforce 애플리케이션으로 어떻게 탐색하나요?**

App Launcher를 사용해 조직에 있는 다양한 Salesforce 애플리케이션을 찾을 수 있습니다.

**89. Salesforce의 데이터 접근 수준은?**

조직 전체 기본값(OWD), 오브젝트 수준, 레코드 수준, 필드 수준 보안.

**90. Inline Editing이란?**

레코드를 열지 않고 필드 값을 수정할 수 있는 기능입니다. List View나 리포트 등 다양한 곳에서 레코드 페이지로 이동하지 않고 편집할 수 있습니다.

**91. Manual Sharing이란?**

레코드의 share 버튼을 사용해 사용자와 레코드를 공유하는 방법입니다.

**92. 권한 집합으로 사용자의 권한을 제한할 수 있나요?**

아니요, 권한 집합은 항상 권한을 확장하는 데 사용되며 제한하는 데 사용되지 않습니다.

**93. OWD 설정이란?**

Organization Wide Defaults의 약자로, Salesforce 레코드의 기준 접근을 정의합니다.

**94. 표준 프로필을 삭제할 수 있나요?**

아니요, 표준 프로필은 삭제할 수 없지만 특정 필드는 수정할 수 있습니다.

**95. Salesforce 대시보드에 컴포넌트를 몇 개 추가할 수 있나요?**

각 대시보드에 최대 20개의 컴포넌트를 추가할 수 있습니다.

**96. 각 커스텀 리포트 타입에 필드를 몇 개 추가할 수 있나요?** 1,000개.

**97. Salesforce의 멀티테넌트 아키텍처란?**

여러 사용자가 시스템의 하나의 인스턴스에 접근하는 설계 방식을 말합니다.

**98. AppExchange란?**

Salesforce 구현을 확장하는 데 사용할 수 있는 Salesforce 애플리케이션 마켓플레이스입니다. 무료 및 유료 앱이 많이 제공됩니다.

**99. Managed Package란?**

커스텀 오브젝트, 필드, 워크플로우, Apex 코드 같은 사전 구축된 구성 요소의 모음입니다. 패키지 제작자가 각 구성 요소의 접근 및 권한 수준(어떤 오브젝트, 필드, Apex 클래스가 설치된 조직의 사용자에게 보이고 편집 가능한지)을 제어할 수 있습니다.

**100. Salesforce Flow 디버깅 중 오류 이메일을 받도록 어떻게 구성하나요?**

Setup >> Process Automation >> Process Automation Settings >> Send Process or Flow Error Email to.

**101. fault connector를 사용해 오류 메시지를 사용자에게 표시하려면?**

Screen Flow 컴포넌트에서 `{!$Flow.FaultMessage}` 사용.
