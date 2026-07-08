---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Administrator Interview Q & A]
---

# Salesforce 관리자(Administrator) Q&A 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. Salesforce란?**

Salesforce.com은 영업, 서비스, 마케팅, 협업, 분석, 커머스 등을 위한 클라우드 기반 고객 관계 관리(CRM) 소프트웨어 솔루션입니다.

**2. 다양한 Salesforce 에디션은?**

주요 에디션 네 가지가 있습니다: Essentials, Professional, Enterprise, Unlimited.

**3. 연간 출시되는 Salesforce 릴리스 수는?**

Salesforce는 연간 3번의 주요 릴리스를 합니다.

**4. Salesforce.com과 Force.com의 차이는?**

Salesforce는 SaaS 제품이고 Force.com은 PaaS 제품입니다. SaaS에서는 Lead, Opportunity, Account 같은 기본 제공 기능을 받지만, PaaS에서는 모든 것을 직접 개발해야 합니다. Salesforce.com은 Force.com 플랫폼 위에 구축되었습니다.

**5. Database.com이란?**

Database.com은 Salesforce의 기본 엔터프라이즈 데이터베이스 스토리지입니다. 클라우드를 통해 데이터를 저장하도록 구축되었습니다.

**6. Salesforce에는 몇 가지 유형의 포털이 있나요?**

3가지 포털이 있었습니다: Salesforce Customer Portal, Salesforce Partner Portal, Self Service Portal.

**7. Salesforce의 App이란?**

App은 특정 기능을 수행하기 위해 함께 작동하는 항목들의 모음입니다. Salesforce 앱에는 Classic과 Lightning 두 가지 형태가 있습니다.

**8. Salesforce.com의 다양한 오브젝트 유형은?**

표준 오브젝트(Standard), 커스텀 오브젝트(Custom), 외부 오브젝트(External), 플랫폼 이벤트(Platform Events), BigObjects 등 여러 유형을 지원합니다.

**9. Salesforce의 오브젝트(Object)란?**

오브젝트는 조직에 특화된 데이터를 저장할 수 있는 데이터베이스 테이블입니다. Salesforce에는 표준(Standard)과 커스텀(Custom) 두 가지 유형이 있습니다.

**10. Salesforce의 TAB이란?**

Salesforce의 Tab은 사용자가 정보를 한눈에 볼 수 있도록 돕습니다. 오브젝트의 데이터와 기타 웹 콘텐츠를 애플리케이션에 표시합니다.

**11. 커스텀 필드 유형의 예를 들면?**

AutoNumber, Checkbox, Currency, Date, Date/Time, Formula, Email, Number, Percent, Phone, Picklist, Text, Lookup 관계, Master-Detail 관계 등.

**12. Salesforce의 표준 필드와 커스텀 필드란?**

- **표준 필드(Standard Fields):** 모든 커스텀 오브젝트에는 Created By, Last Modified By, Owner와 오브젝트 생성 시 만들어지는 필드, 이 네 가지 표준 필드가 있습니다. 삭제하거나 편집할 수 없으며 항상 필수입니다. 표준 오브젝트의 경우 기본적으로 존재하며 삭제할 수 없는 필드가 표준 필드입니다.
- **커스텀 필드(Custom Fields):** 조직의 비즈니스 요구사항을 충족하기 위해 관리자/개발자가 추가하는 필드입니다. 필수일 수도 아닐 수도 있습니다.

**13. 오브젝트에 커스텀 필드를 몇 개까지 만들 수 있나요?**

Salesforce 에디션에 따라 다릅니다. 최대 한도는 Essential 및 Professional 에디션 100개, Enterprise 500개, Unlimited 800개, Developer 에디션 500개입니다.

**14. 프로필(Profile)이란?**

프로필은 사용자가 오브젝트와 데이터에 어떻게 접근하는지, 애플리케이션 내에서 무엇을 할 수 있는지 정의합니다. 사용자를 생성할 때 각 사용자에게 프로필을 할당합니다.

**15. 역할(Role)이란?**

역할은 특정 사용자가 갖는 데이터 가시성을 높이기 위해 정의됩니다. 역할 계층은 상위 수준에 있는 사용자가 계층에서 하위에 있는 사용자가 소유한 레코드에 접근할 수 있게 합니다.

**16. 역할과 프로필의 차이는?**

| 역할(Role) | 프로필(Profile) |
|---|---|
| 특정 사용자의 데이터 가시성을 정의하는 데 도움 | 사용자가 조직에서 할 수 있는 것에 대한 제한을 설정 |
| 계층에 따라 어떤 사용자 데이터를 볼 수 있는지 정의 | 권한을 정의 |
| 사용자에게 역할 정의는 필수 아님 | 프로필 정의는 필수 |
| 리포트에 영향을 주어 레코드 접근을 제어(예: "My Teams" 필터). OWD가 private일 때 작동 | 레코드 권한(보기, 편집, 삭제 등)과 데이터 내보내기, 대량 이메일 같은 시스템 권한을 결정 |

**17. Salesforce.com의 표준 프로필 수는?**

Contract Manager, Marketing User, Read Only, Solution Manager, Standard User, System Administrator.

**18. 프로필에서 "Transfer Record"라는 용어를 어떻게 사용하나요?**

Transfer Record는 Salesforce의 권한 유형입니다. 사용자에게 레코드 이전 권한이 부여되면, 읽기(Read) 접근 권한이 있는 레코드를 이전할 수 있게 됩니다.

**19. Company Profile(회사 프로필)이란?**

회사 프로필은 Salesforce 내 조직의 핵심 정보를 담고 있으며, 일부는 초기 시스템 가입 시 수집됩니다. 회사 정보 및 주요 연락처 세부 정보, 기본 언어·로케일·시간대, 라이선스 정보, 회계 연도 설정 등을 포함합니다.

**20. Salesforce.com에서 보안 토큰(Security Token)을 어떻게 얻나요?**

비밀번호와 연결된 대소문자를 구분하는 영숫자 코드입니다. 비밀번호가 재설정될 때마다 보안 토큰도 재설정됩니다.

**21. Salesforce의 Fiscal Year(회계 연도)란?**

Salesforce는 조직 고유의 회계 연도 시작 월을 수용할 수 있습니다. 회계 연도는 분기별·연간 예측 및 리포트에 포함되는 월을 결정하는 데 사용됩니다.

**22. 종속 선택 목록(Dependent Picklist)이란?**

종속 선택 목록은 유효한 값이 제어 필드(controlling field)라는 다른 필드의 값에 따라 달라지는 커스텀 또는 다중 선택 선택 목록입니다.

**23. 페이지 레이아웃과 Record Type이란?**

페이지 레이아웃은 레코드에서 사용자에게 어떤 필드가 표시되는지 결정합니다. 필드, 섹션, 링크, 커스텀 버튼 등을 추가할 수 있습니다.
Record Type은 사용자에 따라 서로 다른 비즈니스 프로세스, 선택 목록 값, 페이지 레이아웃을 제공할 수 있게 합니다.

**24. Salesforce에서 사용자를 어떻게 삭제하나요?**

Salesforce에서는 사용자를 삭제할 수 없습니다. 라이선스를 제거하거나 비활성화하여 시스템 접근을 막을 수 있지만, 여전히 레코드를 소유하고 있을 수 있어 삭제할 수 없습니다.

**25. Salesforce에서 두 사용자가 같은 프로필을 가질 수 있나요?**

네.

**26. 레코드에서 수식 필드(Formula Field) 값을 편집할 수 있나요?**

아니요.

**27. 어떤 필드를 커스텀 인덱스로 추가할 수 없나요?**

수식 필드(Formula field).

**28. Salesforce의 거버너 한도(Governor Limits)란?**

거버너 한도는 공유 데이터베이스에 얼마나 많은 데이터나 레코드를 저장할 수 있는지 제어합니다. 그 이유는 Salesforce가 멀티테넌트 아키텍처 개념을 기반으로 하기 때문입니다.

**29. 샌드박스 조직이란? Salesforce의 샌드박스 유형은?**

샌드박스는 테스트 및 개발 목적으로 사용되는 운영 환경/조직의 사본입니다. 유형은 다음과 같습니다: Developer, Developer Pro, Partial Copy, Full.

**30. 운영 환경에서 Apex 트리거/클래스를 편집할 수 있나요? Visualforce 페이지는?**

아니요, 운영 환경에서 Apex 클래스와 트리거를 직접 편집할 수 없습니다.

**31. 표준 필드 Record Name이 가질 수 있는 데이터 타입은?**

Record Name 표준 필드는 Auto Number 또는 80자 제한의 텍스트 필드 데이터 타입을 가질 수 있습니다.

**32. 리포트의 Bucket Field란?**

Bucket Field는 복잡한 수식이나 커스텀 필드 없이 범위와 세그먼트별로 관련 레코드를 그룹화할 수 있게 합니다. 따라서 리포트 데이터를 그룹화, 필터링, 정렬하는 데 사용할 수 있습니다.

**33. Dynamic Dashboard란? 예약할 수 있나요?**

Dynamic Dashboard는 특정 사용자에 맞춘 정보를 표시하는 데 사용됩니다. 개인 할당량과 매출, Case 종료 수, 전환된 Lead 수 등 특정 사용자별 데이터를 보여줄 때 사용합니다.

**34. Salesforce의 리포트 유형은? 리포트를 대량 삭제할 수 있나요?**

| 리포트 유형 | 설명 |
|---|---|
| Tabular | 항목 목록과 총합을 제공하는 단순한 Excel 형식의 표 |
| Summary | Tabular와 유사하지만 행 그룹화, 소계 보기, 차트 생성 기능 추가 |
| Matrix | 행과 열로 레코드를 그룹화할 수 있는 2차원 리포트 |
| Joined | 동일하거나 다른 리포트 유형을 기반으로 여러 블록의 데이터를 보여줌 |

**35. Salesforce에서 사용할 수 있는 앱 유형을 설명하세요.**

두 가지 유형의 앱을 만들 수 있습니다:
- **커스텀 앱(Custom app):** 비즈니스 요구사항에 맞는 앱을 구축하려는 사업주가 주로 사용합니다. 시장에서 널리 사용됩니다.
- **콘솔 앱(Console app):** 클라이언트의 문제 해결에 집중하는 클라이언트 서비스 비즈니스에서만 사용할 수 있습니다. 커스텀 앱에 비해 시장에서 널리 사용되지는 않습니다.

**36. 공유 규칙(Sharing Rule)이란?**

공유 규칙은 사용자가 Public Group, 역할, 영역(territory) 같은 다른 사용자에게 접근을 허용하려 할 때 적용됩니다. 조직 전체 공유 설정에 자동 예외를 만들어 특정 사용자에게 더 큰 접근을 부여합니다.

**37. Salesforce의 Audit Trail이란?**

Audit Trail은 사용자와 다른 관리자가 조직에서 수행한 변경 사항을 추적하는 데 도움을 주는 기능입니다. 누가 마지막으로 수정했는지 항상 알 수 있습니다. 관리자가 많은 조직에 유용합니다.

**38. Salesforce의 Dashboard란?**

Dashboard는 리포트를 그림으로 표현한 것입니다. 소스 리포트의 데이터를 시각적 컴포넌트로 표시합니다.

**39. Static과 Dynamic Dashboard의 차이는?**

| Static Dashboard | Dynamic Dashboard |
|---|---|
| 어떤 사용자에게나 보이는 기본 대시보드 | 특정 사용자에 맞춘 데이터를 표시 |
| 사용자 집합에 조직 전체 데이터를 보여줌 | 성사된 매출 수, 전환된 Lead 수 등 단일 사용자의 데이터를 보여줌 |
| 자동으로 데이터를 새로 고치도록 예약 가능 | 예약 불가 — 대시보드를 열면 실시간 생성 데이터를 표시하기 때문 |

**40. Salesforce의 트리거(Trigger)란?**

트리거는 Salesforce에서 레코드에 대한 insert, update, delete 같은 수정 전후에 커스텀 액션을 수행하기 위해 실행되는 Apex 코드입니다.

**41. Salesforce의 검증 규칙(Validation Rule)이란?**

검증 규칙은 사용자가 레코드를 저장하기 전에 지정한 기준을 충족하는지 하나 이상의 필드 데이터를 평가하는 수식이나 표현식으로 구성됩니다. 데이터 평가에 따라 "True" 또는 "False" 값을 반환합니다. 유효하지 않은 값으로 인해 조건이 "True"일 때 사용자에게 오류 메시지를 표시합니다.

**42. Salesforce의 Record Type이란?**

Record Type을 사용하면 사용자 프로필에 따라 서로 다른 비즈니스 프로세스를 연결하고, 서로 다른 선택 목록 값과 페이지 레이아웃을 표시할 수 있습니다.

**43. 레코드를 공유하는 방법은 몇 가지인가요?**

다음 방법으로 레코드를 공유할 수 있습니다: 역할 계층(Role Hierarchy), 수동 공유(Manual Sharing), OWD, Apex 공유(Apex sharing), 기준 기반 공유 규칙(Criteria-based sharing rules).

**44. Salesforce Lightning이란?**

Salesforce Lightning은 애플리케이션 개발을 위한 컴포넌트 기반 프레임워크로, Salesforce 플랫폼 성능을 효과적으로 향상시키는 것을 목표로 하는 도구와 기술의 모음입니다. 완전히 새로운 버전의 프레임워크, 시각적 업그레이드, 새롭고 최적화된 인터페이스 등을 포함합니다. 프로그래밍 경험이 없는 비즈니스 사용자를 위한 프로세스 단순화를 목표로 설계되었습니다.
