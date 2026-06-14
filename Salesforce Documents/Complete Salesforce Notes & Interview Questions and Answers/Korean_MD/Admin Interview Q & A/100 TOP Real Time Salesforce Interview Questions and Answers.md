---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [100 TOP Real Time Salesforce Interview Questions and Answers]
---

# 실시간(Real Time) Salesforce 면접 질문과 답변 TOP 100

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Q1. Force.com과 Salesforce.com의 차이는?**

Force.com은 코드, 데이터베이스 조회, UI 개발의 기반을 형성하는 PaaS 영역입니다. Salesforce.com은 그 상위 집합으로, CRM 기능(영업, 서비스, 마케팅)을 가리키는 SaaS 영역입니다.

**Q2. IsNull과 IsBlank의 차이는?**

IsBlank()는 표현식에 값이 있는지 확인하는 함수로, 값이 없으면 TRUE, 있으면 False를 반환합니다. 텍스트를 포함한 모든 필드 타입을 지원합니다. IsNull()은 유사하지만 숫자 필드만 지원합니다.

**Q3. SFDC의 다양한 관계를 설명하세요.**

- **Lookup 관계:** 두 오브젝트를 연결하며 최대 25개까지 연결 가능합니다. 부모 필드가 필수가 아니며 여러 계층 깊이로 가능합니다. 보안이나 삭제에 영향이 없습니다.
- **Master-Detail 관계:** 부모-자식 관계여야 하며 Master가 부모, Detail이 자식입니다. 최대 2개 오브젝트를 연결할 수 있고, 부모 삭제 시 자식이 자동 삭제됩니다. 한 관계의 자식은 다른 관계의 부모가 될 수 없습니다.

**Q4. SOQL과 SOSL의 차이는?**

- **SOQL(Salesforce Object Query Language):** 한 번에 하나의 오브젝트만 검색, 트리거와 클래스에서 사용 가능, DML 작업 수행 가능, 모든 필드 타입 포함.
- **SOSL(Salesforce Object Search Language):** 한 번에 여러 오브젝트 검색, 트리거에서 사용 불가, DML 작업 불가, email·text·phone 타입에만 작동.

**Q5. Salesforce의 리포트 유형은 몇 가지인가요?**

오브젝트 정보를 요약하는 4가지 유형: Tabular(표 형식 총합 표시), Matrix(행과 열 기준 그룹화), Summary(열 기준 그룹화), Joined(둘 이상의 리포트 결합).

**Q6. Audit Trail이란?**

지난 6개월간 여러 관리자가 조직에 수행한 모든 변경을 추적하는 기능입니다. 변경 날짜, 변경한 사용자명, 변경 세부 정보를 다룹니다.

**Q7. Salesforce에서 수행할 수 있는 Workflow 액션은?**

- **이메일 경고(Email Alert):** Workflow 규칙으로 개발한 템플릿을 통해 수신자 목록에 이메일 발송.
- **필드 업데이트(Field Update):** 계산된 값, 빈 값, 특정 값으로 필드 값을 자동 업데이트.
- **작업(Task):** 제목, 상태, 우선순위, 마감일을 지정해 사용자에게 작업 할당.
- **아웃바운드 메시지(Outbound message):** SOAP 메시지를 통해 외부 서비스로 특정 정보 전송.

**Q8. 권한 집합(Permission Set)이란?**

프로필을 변경하지 않고 사용자에게 확장된 접근을 부여합니다. 탭/오브젝트/필드 권한, Apex 클래스 접근, 시스템 권한, Visualforce 접근 등을 설정합니다.

**Q9. Dashboard란? 다양한 컴포넌트는?**

대시보드는 리포트를 보는 페이지입니다. 최대 20개의 리포트를 분석할 수 있습니다. 컴포넌트: Chart(그래픽 표현), Gauge(값 범위 내 특정 값 표시), Metric(핵심 값), Visual Page(커스텀 컴포넌트 및 값 표시), Custom S-Control(Java Applet, ActiveX 등 브라우저 콘텐츠 표시).

**Q10. Dependent Field란?**

필터를 첨부할 수 있는 필드로, 필드에 값을 표시하기 위한 조건을 설정할 수 있습니다.

**Q11. Workflow란?**

평가 기준과 규칙 기준에 따라 액션을 실행하는 자동화 프로세스입니다. DML 작업을 수행할 수 있으며, 오브젝트 전반에서 접근할 수 있습니다.

**Q12. OWD란?**

Organization-Wide Sharing Defaults는 조직의 기준 설정을 정의합니다. 사용자가 다른 사용자의 레코드를 볼 수 있는 접근 수준에 따라 달라지며, Private, Public Read Only, Public Read and Write가 될 수 있습니다.

**Q13. 프로필과 역할의 차이는?**

- **프로필:** 오브젝트 수준 및 필드 수준 접근이며, 모든 사용자에게 필수입니다.
- **역할:** 레코드 수준 접근이며, 모든 사용자에게 필수는 아닙니다.

**Q14. Apex Data Loader란?**

데이터 삽입, 업데이트, upsert, 내보내기에 사용됩니다. Salesforce 외부에서 데이터를 가져올 수도 있습니다.

**Q15. Salesforce의 트리거 유형은?**

트리거는 레코드가 삽입되거나 업데이트되기 전후에 실행되는 코드입니다. 두 가지 유형:
- **Before Trigger:** 데이터베이스에 저장되기 전 레코드 값을 업데이트하거나 검증.
- **After Trigger:** 시스템이 설정한 필드 값에 접근하고 다른 레코드의 변경을 감지(감사 테이블 로깅, 비동기 이벤트 등). After 트리거의 레코드는 읽기 전용입니다.

**Q16. SOQL과 SOSL의 차이 (재정리)**

- **SOQL:** 단일 오브젝트 검색, 레코드 반환, 트리거/클래스에서 사용, 쿼리 결과에 DML 수행 가능.
- **SOSL:** 여러 오브젝트 검색, 필드 반환, 트리거/클래스에서 사용, 검색 결과에 DML 불가.

**Q17. Salesforce의 리포트 유형은?**

Tabular(표 형식 총합), Matrix(행과 열 기준 그룹화 상세 리포트), Summary(열 기준 그룹화 상세 리포트), Joined(둘 이상의 리포트 결합).

**Q18. Junction Object란 무엇이며 용도는?**

오브젝트 간 다대다 관계를 구축하는 데 사용됩니다. 채용 애플리케이션 예: 한 직무 포지션이 여러 후보자와 연결되고, 한 후보자가 여러 포지션과 연결됩니다. 이 데이터 모델을 연결하려면 제3의 오브젝트(junction object)가 필요합니다. 여기서 "job application"이 junction object입니다.

**Q19. Visualforce 페이지에서 몇 개의 컨트롤러를 사용할 수 있나요?**

Salesforce는 SaaS이므로 하나의 컨트롤러와 여러 개의 확장 컨트롤러를 사용할 수 있습니다.

**Q20. Workflow에서 사용 가능한 액션은?**

Email Alert, Task, Field Update, Outbound Message.

**Q21. 필드 수준 보안(FLS)을 왜 사용하나요?**

여러 페이지 레이아웃을 만드는 대신 FLS를 사용해 데이터 보안을 강제합니다. 사용자는 자신의 직무에 관련된 데이터를 봅니다. 문제 해결 도구: Field Accessibility 뷰(Setup | Administration Setup | Security Controls | Field Accessibility).
참고: FLS는 PE(Professional Edition)에서 사용 불가. FLS로 필드를 필수로 만들 수 없음(페이지 레이아웃에서 수행). FLS와 페이지 레이아웃 중 더 제한적인 설정이 항상 적용됨. FLS로 필드를 숨기면 List View, 검색 결과, 리포트에서도 숨겨짐.

**Q22. Login Hours와 Login IP Ranges란?**

특정 프로필 사용자가 시스템을 사용할 수 있는 시간과 로그인할 수 있는 IP 주소를 설정합니다. 제한 시간 전에 로그인한 사용자는 제한 시간이 시작되면 세션이 종료됩니다. IP 범위 제한 옵션: 1) 전체 조직에 Trusted IP Ranges 추가, 2) 프로필별로 Trusted IP Ranges 추가.

**Q23. User Record란?**

사용자에 대한 핵심 정보입니다. 각자 고유한 username을 가지며, username과 password로 로그인합니다. 활성/비활성일 수 있고(활성 사용자는 라이선스 사용), 프로필과 연결되며, 보통 역할과 연결됩니다.

**Q24. Record Owner란?**

특정 데이터 레코드를 제어하거나 권한을 가진 사용자(Case와 Lead의 경우 Queue)입니다. 소유자는 보기/편집, 이전(소유권 변경), 삭제 권한을 가집니다(오브젝트 권한이 활성화된 경우). Account/Opportunity/Case 소유자는 같은 사용자일 수도 아닐 수도 있습니다.

**Q25. Organization Wide Defaults란?**

조직 내 모든 사용자에 대한 데이터 레코드의 기준 접근 수준을 정의합니다(사용자 소유 레코드나 역할 계층으로 상속된 레코드는 제외). 접근 제한에 사용됩니다. 접근 수준: Private, Public Read/Write, Public Read/Write/Transfer, Controlled by Parent, Public Read Only.

**Q26. Role과 Role Hierarchy란?**

- **Role:** 사용자가 조직 데이터에 대해 갖는 가시성 수준을 제어합니다. 사용자는 하나의 역할과 연결될 수 있습니다.
- **Role Hierarchy:** 데이터 가시성과 레코드 롤업(예측 및 리포팅)을 제어합니다. 사용자는 계층에서 자기 아래 사용자가 소유하거나 공유한 데이터의 특별 권한을 상속합니다. 회사 조직도와 반드시 같지는 않습니다.

참고: 최대 500개 역할 생성 가능. "Grant Access Using Hierarchies"로 역할/영역 계층의 기본 공유 접근을 비활성화할 수 있음(Controlled by Parent가 아닌 커스텀 오브젝트에 한해).

**Q27. Role 수준의 접근이란?**

역할 생성 시 정의됩니다. 역할이 소유한 Account에 연결된 Opportunity/Contact/Case에 대한 접근 수준을 정의하며, 접근 수준 옵션은 OWD에 따라 달라집니다.
참고: 모든 사용자는 역할에 할당되어야 하며, 그렇지 않으면 역할 기반 표시에 데이터가 나타나지 않습니다. 전체 조직 가시성이 필요한 사용자는 계층의 최상위에 있어야 합니다.

**Q28. Sharing Rule이란?**

사용자 그룹에 접근을 부여하는 자동화 규칙으로, OWD에 대한 예외입니다. Public Read/Write 조직에는 무의미합니다. 부여 가능한 접근 수준: Read Only, Read/Write. 공유 규칙은 접근을 개방하고 OWD는 제한합니다. OWD 수준 아래로 접근을 제한할 수는 없습니다. 활성/비활성 사용자 모두에 적용되며, 새/기존 레코드 모두에 적용됩니다.

**Q29. Sharing Rule의 유형은?**

- **Account Sharing Rules:** Account 소유자 기반. Account와 관련 Case·Contact·Contract·Opportunity의 기본 공유 접근 설정.
- **Contact Sharing Rules:** Contact 소유자 기반(Account와 연결되어야 함). Territory Management 및 Person Account 활성 조직에서는 사용 불가.
- **Opportunity Sharing Rules(EE/UE):** Opportunity 소유자 기반.
- **Case Sharing Rules(EE/UE):** Case 소유자 기반.
- **Lead Sharing Rules(EE/UE):** Lead 소유자 기반.
- **Custom Object Sharing Rules(EE/UE):** 커스텀 오브젝트 소유자 기반.

**Q30. Sharing Rule의 사용 사례는?**

OWD가 Public Read Only 또는 Private인 조직은 공유 규칙으로 특정 사용자에게 다른 사용자 소유 데이터 접근을 부여할 수 있습니다. 예: 고객 지원 사용자가 Case 작업 시 Account/Contact에 읽기 접근이 필요할 때 Account 공유 규칙 생성. 예: 서부/동부 지역 디렉터가 서로의 영업 담당자가 만든 모든 Account를 봐야 할 때 Public Group과 공유 규칙 활용.

**Q31. Contact Sharing Rule 생성 모범 사례는?**

Contact OWD를 "Public Read/Write"로 설정하려면 Account OWD가 최소 "Public Read Only"여야 합니다. 모든 Contact를 공유하려면 "All Internal Users"(또는 "Entire Organization") public group을 owned by 옵션으로 사용. 공유 규칙 수를 최소화하기 위해 가능한 한 "Roles" 대신 "Roles and Subordinates" 사용.

**Q32. Public Group이란?**

사용자, Public Group(중첩), 역할, 역할 및 하위 역할의 그룹화입니다. 공유 규칙 단순화(여러 역할에 공유 필요 시)에 사용되며, 폴더와 List View 접근 정의에도 사용됩니다.

**Q33. Manual Sharing이란?**

일회성으로 레코드 접근을 부여합니다. 소유자, 역할 계층상 소유자 위의 사람, 관리자가 수동으로 레코드를 공유할 수 있습니다. Contact, Lead, Case, Account, Opportunity 레코드 및 커스텀 오브젝트에서 사용 가능. Public Read/Write 조직에는 무의미합니다.

**Q34. Sales Team이란? (EE/UE)**

협업 영업에 사용되며 공유 및 리포팅 목적으로 사용됩니다. 즉석 또는 기본 Sales Team(사용자별 정의)을 사용할 수 있습니다. 추가 가능자: 소유자, 역할 계층상 소유자 위의 사람, 관리자. Professional Edition에서는 Team Selling 기능에 접근 불가.

**Q35. Account Team이란? (EE/UE)**

협업 Account 관리에 사용되며 공유 및 리포팅 목적으로 사용됩니다. Account 레코드에 수동 추가됩니다. Professional Edition에서는 사용 불가.

**Q36. Case Team이란? (EE/UE)**

고객 문제 해결에 대한 완전한 소통과 협업을 가능하게 합니다. Case에 사용자 팀 추가, Case Team용 워크플로우 생성, 사용자용 Case Team 사전 정의, 접근 수준 결정이 가능합니다. 경로: Setup | Customize | Cases | Case Teams.

**Q37. Folder란?**

이메일 템플릿, 문서, 리포트, 대시보드를 정리하는 데 사용됩니다. 접근은 Read 또는 Read/Write로 정의되며 명시적입니다(역할 계층으로 롤업되지 않음). 업로드 문서 크기 제한 5MB, 문서명 255자(확장자 포함).

**Q38. Workflow란?**

이메일 경고 자동 생성·발송, 작업 생성·할당, 필드 값 업데이트(특정 값 또는 수식 기반), 아웃바운드 API 메시지 생성·발송, 시간 종속 액션 생성·실행 기능을 제공합니다.

**Q39. Workflow의 구성 요소는?**

Workflow Rules(액션 수행을 위한 트리거 기준), Workflow Tasks(대상 사용자에게 작업 할당), Workflow Email Alerts(대상 수신자에게 이메일), Workflow Field Updates(필드 값 자동 업데이트), Workflow Outbound Messages(지정 리스너에게 XML 형식 API 메시지 전송).

**Q40. Workflow Rule이란?**

비즈니스 요구사항에 기반한 트리거 기준을 정의합니다. 레코드 생성 시, 생성/업데이트 시, 또는 생성/업데이트되어 이전에 기준을 충족하지 않았을 때 평가됩니다. 기준 충족 시 이메일 경고, 작업, 필드 업데이트, 아웃바운드 메시지 등의 액션이 생성됩니다.

**Q41. Workflow Task란?**

Workflow Rule 충족 시 지정 사용자에게 비즈니스 조건에 응답하도록 작업을 할당합니다. 사용자, 역할, 레코드 소유자, 레코드 생성자, 영업팀 역할, Account 팀에 할당 가능. Activity History에서 추적되고 리포팅 가능. 즉시 또는 시간 종속일 수 있습니다.

**Q42. Workflow Alert란?**

특정 비즈니스 액션이 규칙을 트리거할 때 생성되는 이메일입니다. 사용자, 역할, Contact 필드의 고객, 페이지 레이아웃의 이메일 필드로 발송 가능. Activity History에서 추적되지 않음. 즉시 또는 시간 종속.

**Q43. Workflow Field Update란?**

필드 값을 지정한 값으로 자동 변경합니다. 필드 유형에 따라 특정 값 적용, 빈 값으로 만들기, 수식 기반 계산이 가능합니다. 즉시 또는 시간 종속.

**Q44. Time-Dependent Workflow란?**

레코드의 날짜 전후로 시간 민감 액션을 실행하고, 여러 시점에 일련의 액션을 수행하며, Workflow Queue로 대기 중 액션을 관리할 수 있게 합니다. 예: 고가치 Opportunity가 마감 10일 전까지 열려 있으면 Account 팀에 이메일 리마인더 발송.

**Q45. Time-Dependent Workflow의 Time Trigger 작업**

Time Trigger는 레코드에 관련된 시간 값으로 시간 종속 액션을 시작하는 데 사용됩니다. Time-Dependent Action은 관련 time trigger가 있는 workflow 액션으로, 규칙이 트리거될 때마다 큐에 들어가고, 레코드가 더 이상 규칙 기준을 충족하지 않으면 큐에서 제거되며, 레코드 필드 업데이트 시 큐에서 동적으로 업데이트됩니다.

**Q46. Time-Dependent Workflow 고려사항**

규칙당 최대 10개 time trigger, time trigger당 최대 40개 액션(10×4 유형), workflow 규칙당 80개 액션. 시간 기반 규칙 생성 전에 workflow 기본 사용자를 설정해야 함. 정밀도는 시간 또는 일로 제한. "레코드가 생성되고 편집될 때마다" 트리거 유형의 규칙에는 시간 종속 액션 생성 불가.

**Q47. Add Time Trigger 버튼을 사용할 수 없는 경우?**

평가 기준이 "레코드가 생성되고 편집될 때마다"로 설정된 경우, 규칙이 활성화된 경우, 규칙이 비활성화되었지만 큐에 대기 중 액션이 있는 경우.

**Q48. Time-Dependent Workflow 제한**

Time trigger는 분/초를 지원하지 않음. TODAY/NOW 같은 자동 파생 함수가 포함된 DATE/DATETIME 필드, 관련 오브젝트 병합 필드가 포함된 수식 필드를 참조할 수 없음. 규칙이 활성, 큐에 대기 중 액션이 있거나, "생성되고 편집될 때마다" 평가 기준이거나, 패키지에 포함된 경우 time trigger 추가/제거 불가.

**Q49. Approval Processing(승인 처리)란?**

조직이 Salesforce에서 레코드를 승인하는 데 사용하는 자동화된 비즈니스 프로세스입니다. 레코드 승인에 필요한 단계, 각 단계의 승인자, 승인/거부/최초 제출 시 취할 액션을 지정합니다.

**Q50. 승인 용어**

- **Approval Request:** 레코드가 승인을 위해 제출되었고 승인이 요청됨을 알리는 이메일.
- **Approval Steps:** 승인 요청을 여러 사용자에게 할당하고 승인 체인을 정의.
- **Assigned Approver:** 승인 요청 승인 책임 사용자.
- **Initial Submission Actions:** 레코드를 처음 제출할 때 발생하는 액션(예: 레코드 잠금).
- **Final Approval Actions:** 모든 승인 요청이 승인될 때 발생하는 액션.
- **Final Rejection Actions:** 모든 승인 요청이 거부될 때 발생하는 액션.
- **Record Locking:** 필드 수준 보안이나 공유 설정과 무관하게 레코드 편집을 막는 과정. 승인 대기 레코드는 자동 잠금. "Modify All Data" 권한이 있어야 잠긴 레코드 편집 가능.
- **Outbound Messages:** 지정 엔드포인트로 정보 전송.

**Q51. 승인 프로세스 체크리스트**

승인 요청 이메일 준비, 발신자 결정, 지정 승인자 결정, 위임 승인자 결정, 필터 필요 여부 결정, 최초 제출 액션 결정, 무선 기기 승인 허용 여부, 승인 대기 레코드 편집 가능 여부, 자동 승인/거부 여부, 단계 수, 승인/거부 시 액션 결정.

**Q52. Jump Start Wizard vs Standard Wizard**

- **Jump Start Wizard:** 몇 분 만에 한 단계 승인 프로세스를 만드는 단순 프로세스용.
- **Standard Wizard:** 복잡한 승인 프로세스용. 프로세스 정의 마법사와 각 단계 정의 마법사로 구성.

**Q53. Parallel Approval Routing(병렬 승인 라우팅)**

한 단계에서 여러 승인자에게 승인 요청 발송. 모든 승인자의 승인을 기다리거나 한 명의 승인을 기다림. 각 단계에서 최대 25명의 병렬 승인자 구성 가능.

**Q54. Data Validation Rule의 구성**

하나 이상의 필드 데이터를 "True"/"False"로 평가하는 불리언 수식/표현식과, 규칙이 "True"를 반환할 때 표시되는 사용자 정의 오류 메시지를 포함합니다. 사용자가 레코드를 저장할 때, 레코드 임포트 전, Data Loader 및 API 사용 시 실행됩니다.

**Q55. Import Wizard란?**

새 Account, Contact, Lead, 커스텀 오브젝트, Solution을 임포트하는 사용하기 쉬운 다단계 마법사입니다. 매칭 ID 기반 업데이트 가능, Contact/Lead는 매칭 이메일 주소로 업데이트 가능. 표준 사용자는 세션당 최대 500개, 조직 전체 임포트(관리자)는 세션당 최대 50,000개. (CSV 파일: 값이 쉼표로 구분되고 각 행이 데이터 레코드를 나타내는 파일.) 오브젝트와 필드를 먼저 만들어야 하며 관리자만 사용 가능.

**Q56. External ID란?**

Text, Number, Email 타입 커스텀 필드의 플래그입니다. Report와 API SOQL 성능 향상, 외부 시스템의 레코드 ID를 Import와 API("Upsert" 호출)에서 사용 가능하게 함. 대소문자 구분 안 함, 오브젝트당 3개 ID 필드, 커스텀 필드만 가능.

**Q57. Force.com Data Loader 기능**

사용하기 쉬운 마법사 인터페이스, 대체 명령줄 인터페이스, 데이터베이스 연결 배치 모드 인터페이스, 수백만 행의 대용량 파일 지원, 드래그 앤 드롭 필드 매핑, 모든 오브젝트 지원, CSV 형식 성공/오류 로그, 내장 CSV 뷰어, Java로 작성되어 플랫폼 독립적. 데이터 대량 임포트/익스포트 애플리케이션으로 insert, update, delete, extract, upsert 가능.

**Q58. Data Loader를 사용해야 하는 경우**

50,000개 이상 레코드 로드, 웹 기반 임포트가 지원하지 않는 오브젝트, 야간 임포트 같은 정기 데이터 로드 예약, 매핑 파일 저장, 백업용 데이터 내보내기. (웹 기반 임포트: 50,000개 미만, 지원 오브젝트, Account 이름·Contact 이메일·Lead 이메일로 중복 방지 시.)

**Q59. Recycle Bin이란?**

삭제된 데이터를 약 30일간 보관하며, 이 기간 동안 복구 가능합니다. 저장 한도에 포함되지 않음. Recycle Bin 한도에 도달하면 최소 2시간 이상 있던 가장 오래된 레코드를 자동 제거. Opportunity에 사용된 제품, Standard Price Book, Opportunity의 price book은 삭제 불가.

**Q60. Standard Report와 Custom Report란?**

- **Standard Report:** Account/Contact 리포트 같은 기본 제공 리포트. Custom Report의 시작점으로 사용 가능, 삭제 불가(폴더 숨김 가능).
- **Custom Report:** 특정 기준으로 생성. My Personal Folder, Public folder, 커스텀 폴더에 저장(Standard Folder는 불가). 편집/삭제 가능.
- **Report Wizard:** 커스텀 리포트를 만드는 다단계 마법사. 단계 수는 선택한 Report Type에 따라 다름.

**Q61. Tabular Report란?**

소계 없이 데이터를 단순 나열. 예: Contact 메일링 리스트 리포트.

**Q62. Summary Report란?**

Tabular Report에 데이터 정렬과 소계를 더한 것. 예: Stage별로 그룹화된 현재 분기 Opportunity 리포트.

**Q63. Matrix Report란?**

가로/세로 기준에 대해 그리드로 데이터를 요약. 관련 합계 비교에 사용. Excel의 피벗 테이블과 유사. 예: 현재 분기 팀 Opportunity를 Stage와 Owner로 소계.

**Q64. Trend Report란?**

"as of" 날짜로 필터링해 Opportunity 이력 데이터를 리포팅. 월별 "as of" 날짜만 가능.

**Q65. Chart란?**

단일 Summary 또는 Matrix Report 데이터의 그래픽 표현. 유형: 가로 막대, 세로 막대, 선, 파이. "Grouped" 또는 "Stacked" 차트 생성 가능.

**Q66. Relative Date란?**

뷰와 리포트의 필터링에 사용되는, 현재 날짜 기반 동적 날짜 범위. 예: This Week, Next Month, Last 90 Days. 사용 가능한 필터: Today, Yesterday, Tomorrow, This/Last/Next Week, This/Last/Next Month, Last/Next x Days, Quarter, Year, Fiscal Quarter, Fiscal Year.

**Q67. Custom Report Type이란?**

리포트 마법사에서 사용자가 리포트를 만들고 커스터마이징할 프레임워크를 구축합니다. 오브젝트 간 관계(master-detail, lookup)로 구축하여, 표시할 표준/커스텀 오브젝트 선택, 오브젝트 간 관계 정의, 리포트 열로 사용할 필드 선택이 가능합니다.

**Q68. Conditional Highlighting(조건부 강조)란?**

리포트 분석을 위한 임계값 설정. 리포트당 최대 3개 조건, 요약 행에만 적용, 숫자 분석만. Summary와 Matrix 리포트에 사용 가능. 최대 3개 숫자 범위와 색상을 선택해 요약 데이터를 조건부 강조.

**Q69. Dashboard란?**

핵심 비즈니스 정보의 시각적 표현으로, 여러 리포트의 정보를 보여줍니다. 컴포넌트로 구성되며 Custom Report(Matrix, Summary)를 소스로 사용. Running User가 대시보드 데이터 접근 수준을 결정. 새로 고침 예약 및 이메일 발송 가능.

**Q70. Dashboard 컴포넌트**

Chart(리포트 결과의 그래픽 표현), Table(리포트 상위/하위 레코드 나열), Metric(단일 데이터 값 — 리포트 총합), Gauge(정의된 스펙트럼의 한 점으로 표시되는 단일 데이터 값).

**Q71. Campaign이란?**

특정 마케팅 프로그램/전술로 인지도를 높이고 Lead를 생성합니다. Campaign Member는 캠페인에 연결된 Lead/Contact(캠페인에 응답한 개인). 모든 사용자가 캠페인을 볼 수 있지만, Marketing User 권한이 있는 지정 사용자만 캠페인을 생성/편집/삭제할 수 있습니다. Enterprise, Unlimited, Developer 에디션에 포함, Professional은 추가 비용.

**Q72. Lead란?**

마케팅 대상 잠재 고객으로, 명함 정보를 캡처하고 제품/서비스에 관심을 표한 개인입니다. 수동 또는 할당 규칙으로 소유권 할당.
- **Contact:** Account에 연결된 개인.
- **Lead Conversion:** 비즈니스 프로세스에 따라 Lead 자격 판단, Lead 정보를 Account/Contact/Opportunity에 매핑. 표준 Lead 필드는 자동 매핑, 커스텀 필드는 관리자가 매핑 지정.
- **Web-to-Lead:** 웹사이트에 게시되어 Lead 정보를 캡처하는 온라인 양식.
- **Email Template:** 표준화된 텍스트/HTML로 일관된 이메일 메시지 제공.
- **Auto-Response Rule:** Web-to-Lead로 생성된 Lead에 보낼 이메일 템플릿 결정.

**Q73. Case란?**

기록된 이슈/문제입니다. 계층으로 유사 Case를 그룹화 가능. 전화/이메일에서 수동 입력, Email-to-Case로 자동 생성, Web-to-Case로 자동 캡처. 수동 또는 할당 규칙으로 할당, Contact 및 Account에 연결.
- **Case Queue:** 기술 요구사항, 제품 카테고리, 고객 유형, 서비스 수준 등으로 Case를 그룹화하는 가상 저장소.
- **Case Assignment Rule:** Case가 사용자/Queue로 자동 라우팅되는 방식 결정.
- **Web-to-Case:** 웹사이트에 게시되어 고객이 온라인으로 문의를 제출하는 웹 양식.
- **Email-to-Case:** 회사 이메일 주소로 이메일이 발송될 때 자동으로 Case 생성.
- **Escalation Rule:** 일정 기간 내 해결되지 않은 Case를 사전 정의된 기준에 따라 자동 에스컬레이션.
- **Business Hours:** 조직의 운영 시간 설정. Escalation Rule이 Case 에스컬레이션 시점 결정에 사용.

**Q74. Solution이란?**

일반적인 질문/문제에 대한 답변입니다. 고객 지원 사용자가 빠르게 적응하고 일관되게 답변할 수 있게 하며, 고객이 게시된 Solution을 검색해 자가 지원할 수 있습니다.
- **Category:** Solution을 정리하는 메커니즘. Solution은 하나 이상의 카테고리에 연결 가능.
- **Suggested Solutions:** Case를 해결하는 데 도움이 될 수 있는 관련 Solution을 최대 10개 표시.

**Q75. Self-Service Portal이란?**

인증된 포털로 24/7 온라인 지원을 제공합니다. Public Knowledge Base, Suggested Solutions, Web-to-Case 기능을 포함합니다.

**Q76. AppExchange란?**

salesforce.com이 소유·운영하는 웹사이트로, 파트너와 고객이 커스텀 앱, 컴포넌트(대시보드, 리포트, 문서, 프로필, S-Control 등)를 다운로드·설치할 수 있게 합니다. 공개 및 비공개 공유, 게시 및 다운로드 무료(파트너는 서비스에 요금 부과 가능).

**Q77. Roll-up Summary 필드란?**

자식 레코드의 특정 필드의 Count, Sum, Min, Max를 계산합니다. Master 오브젝트에서만 생성할 수 있습니다.

**Q78. Salesforce의 관계 필드 유형은 몇 가지인가요?**

4가지: 1) Master-Detail, 2) Many-to-Many, 3) Lookup, 4) Hierarchical(User 오브젝트에서만 사용 가능, 다른 SFDC 오브젝트에는 생성 불가).

**Q79. Account가 삭제되면 어떻게 되나요?**

Account가 삭제되면 그에 관련된 Contact, Opportunity도 삭제됩니다.

**Q80. Salesforce의 이메일 템플릿 유형은?**

1) Text(모든 사용자 생성 가능), 2) HTML with Letterhead("Edit HTML Templates" 권한 필요), 3) Custom HTML(HTML 지식 필요), 4) Visualforce(관리자/개발자, 여러 레코드 정보를 포함한 고급 병합 가능).

**Q81. Salesforce 트리거 순서와 실행 순서(Order of Execution)**

레코드 생성/업데이트 시:
1) DB에서 원본 레코드 로드 또는 upsert용 초기화
2) 요청에서 새 필드 값 로드, 기존 값 덮어쓰기 (표준 UI 편집 시 시스템 검증: 필수 값, 필드 형식, 최대 길이)
3) 모든 before 트리거 실행
4) 시스템 검증 재실행 및 사용자 정의 검증 규칙 실행
5) 레코드를 DB에 저장(아직 커밋 안 함)
6) 모든 after 트리거 실행
7) 할당 규칙 실행
8) 자동 응답 규칙 실행
9) 워크플로우 규칙 실행
10) 워크플로우 필드 업데이트가 있으면 레코드 재업데이트
11) 워크플로우 필드 업데이트로 레코드가 업데이트되면 before/after 트리거를 한 번 더 실행(단 한 번, 표준 검증 포함, 커스텀 검증 규칙은 재실행 안 함)
12) 에스컬레이션 규칙 실행
13) 롤업 요약 필드/크로스 오브젝트 워크플로우 계산 및 부모 레코드 업데이트
14) 조부모 레코드 롤업 요약 계산 및 업데이트
15) Criteria Based Sharing 평가 실행
16) 모든 DML 작업을 DB에 커밋
17) 이메일 전송 같은 커밋 후 로직 실행

**Q82. Salesforce에서 사용자를 어떻게 삭제하나요?**

사용자 삭제는 허용되지 않으며 비활성화만 가능합니다. Mass Delete Record(Setup → Administration Setup → Data Management → Mass Delete Record)를 사용해 사용자 관련 데이터를 삭제할 수 있습니다.

**Q83-1. 사용자가 특정 레코드(예: CASES)를 보지 못하게 제한하려면?**

Case 공유를 private으로 설정합니다. 단, 두 사용자가 모두 관리자이거나 Case에 view all records가 있으면 private 공유를 무시합니다.

**Q83-2. Task/Event 데이터 모델에서 WhoId와 WhatId의 차이는?**

WhoID — Lead ID 또는 Contact ID. WhatID — Account ID, Opportunity ID, 또는 커스텀 오브젝트 ID.

**Q84. Master-Detail 관계와 Lookup 관계란?**

Master-Detail은 부모-자식 관계로, 부모 삭제 시 자식도 삭제됩니다. 롤업 요약 필드는 Master 레코드에서만 생성 가능. Lookup은 "has-a"(containership) 관계로, 한 레코드가 다른 레코드를 참조합니다. 한 레코드 삭제 시 다른 레코드에 영향 없음.

**Q85. Lookup을 Master-Detail로 변환할 수 있나요?**

네, 모든 기존 레코드가 유효한 lookup 필드 값을 가진 경우에만 변환할 수 있습니다.

**Q86. 기존 레코드에 Master-Detail 관계를 만들 수 있나요?**

아니요. 먼저 Lookup 관계를 만들고 모든 기존 레코드에 값을 채운 뒤 변환해야 합니다.

**Q87. Apex 클래스를 호출하는 방법은 몇 가지인가요?**

1) Visualforce 페이지, 2) 트리거, 3) 웹 서비스, 4) 이메일 서비스.

**Q88. Custom Settings란?**

커스텀 오브젝트와 유사하며, 조직·프로필·특정 사용자에 대한 커스텀 데이터를 생성·연결할 수 있게 합니다. 모든 데이터가 애플리케이션 캐시에 노출되어 반복 쿼리 비용 없이 효율적으로 접근 가능. 수식 필드, 검증 규칙, Apex, 웹 서비스 API에서 사용 가능.

**Q89. Custom Settings의 유형은?**

- **List Custom Settings:** 조직 전반에서 접근 가능한 재사용 가능한 정적 데이터 세트. 프로필/사용자에 따라 달라지지 않음. 예: 주 약어, 국제 전화 접두사, 제품 카탈로그 번호. 캐시되어 거버너 한도에 포함되는 SOQL 불필요.
- **Hierarchy Custom Settings:** 내장 계층 로직으로 특정 프로필/사용자에 맞게 설정을 "개인화". 조직 < 프로필 < 사용자 순으로 더 구체적인(낮은) 값 반환.

**Q90. Master 레코드가 삭제되면 detail 레코드는 어떻게 되나요?**

Master 레코드가 삭제되면 detail 레코드도 삭제됩니다.

**Q91. Lookup 관계에서 master 레코드가 삭제되면 자식 레코드는 어떻게 되나요?**

자식 레코드는 삭제되지 않습니다.

**Q92. 레코드가 있는 커스텀 오브젝트에 Master-Detail 관계 필드를 만들려면?**

직접 Master-Detail을 만들 수 없습니다. 먼저 Lookup 관계를 만들고 모든 부모 레코드에 lookup 필드를 연결한 뒤 Master-Detail로 변환합니다.
