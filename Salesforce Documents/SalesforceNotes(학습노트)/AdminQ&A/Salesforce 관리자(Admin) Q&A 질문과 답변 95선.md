---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [95 Salesforce Admin Interview Questions and Answers]
---

# Salesforce 관리자(Admin) Q&A 질문과 답변 95선

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Salesforce란?**

Salesforce는 세계에서 가장 인기 있는 CRM 시스템입니다. 많은 기업과 고객이 이 역동적이고 웹 기반이며 저비용인 CRM 플랫폼에 의존합니다. 1999년 3월 전 Oracle 임원이었던 Marc Benioff가 설립했습니다. 마케팅, 영업, 서비스, 헬스, 비영리, 교육, 파트너 및 커뮤니티 관리 등을 위한 완전한 기능의 솔루션을 제공합니다.

**CRM이란?**

Customer Relationship Management(고객 관계 관리)의 약자입니다. 넓게 정의하면, CRM은 회사와 고객 및 영업 잠재 고객 간의 상호작용을 관리하고 관계 전반에 걸쳐 '연결'이 지속되도록 보장하는 전략입니다.

**Salesforce의 에디션은?**

Personal, Group, Professional, Enterprise, Performance, Unlimited, Developer, Contact Manager 에디션.

**Salesforce의 라이선스는?**

- Salesforce Users
- Salesforce Platform 및 Lightning Platform Users
- Chatter Plus Users(Chatter Only), Chatter Free Users, Chatter External Users
- Customer Community, Customer Community Plus, Partner Community External Users
- Salesforce Community 멤버인 Portal Users

**오브젝트(Object)란?**

오브젝트는 정보를 저장할 수 있는 Salesforce의 데이터베이스 테이블과 유사합니다.

**필드(Field)란?**

- 필드는 데이터베이스 열(column)과 같습니다.
- Salesforce에는 필드를 만들 수 있는 다양한 데이터 타입이 있습니다.
- 필드에 값을 입력함으로써 레코드를 생성합니다.
- 필드는 표준일 수도 커스텀일 수도 있습니다.

**탭(Tab)이란?**

- 탭을 클릭해 앱 내에서 탐색할 수 있습니다.
- 모든 탭은 특정 오브젝트의 정보를 보고, 편집하고, 입력하는 시작점 역할을 합니다.
- 탭을 클릭하면 해당 오브젝트의 홈 페이지가 나타납니다.
- 예: Accounts 탭을 클릭하면 Accounts 탭 홈 페이지가 나타나 모든 Account 레코드에 접근할 수 있습니다.

**앱(App)이란?**

- 앱은 모든 오브젝트, 탭, 기타 기능의 컨테이너입니다.
- 모든 코드 파일을 보관하는 프로그래밍 프로젝트와 유사합니다.
- Salesforce에서 앱은 이름, 로고, 정렬된 탭 세트로 구성됩니다.

**레코드(Record)란?**

- 레코드는 오브젝트의 행(항목)으로, ID로 고유하게 식별됩니다.
- 오브젝트의 필드에 값을 입력해 레코드를 생성합니다.
- Salesforce에서 레코드를 생성, 편집, 조회, 삭제할 수 있습니다.

**Standard Navigation과 Console Navigation 앱은?**

Standard Navigation은 페이지에서 한 번에 하나의 레코드를 엽니다. Console Navigation은 둘 이상의 레코드를 열면 하위 탭(sub tab)으로 함께 엽니다.

**Lookup 관계란?**

한 오브젝트를 다른 오브젝트에 연결하는 관계를 만듭니다. 관계 필드를 통해 사용자가 lookup 아이콘을 클릭해 팝업 목록에서 값을 선택할 수 있습니다.

**Master-Detail 관계란?**

두 오브젝트 간에 특별한 유형의 부모-자식 관계를 만듭니다. 하나는 자식/detail(master-detail 관계 필드를 만드는 쪽)이고 다른 하나는 부모/master입니다.
- 모든 detail 레코드에 필수입니다.
- detail 레코드의 소유권과 공유는 master 레코드에 의해 결정됩니다.
- master 레코드를 삭제하면 모든 detail 레코드가 삭제됩니다.
- master 레코드에 롤업 요약 필드를 만들어 detail 레코드를 요약할 수 있습니다.

**Rollup Summary Field란?**

- 관련 목록(related list)에 있는 필드의 합계, 최소값, 최대값을 표시하는 읽기 전용 필드입니다.
- 관련 목록에 있는 모든 레코드를 셀(count) 수도 있습니다.
- 롤업 요약 필드는 항상 부모 오브젝트에 생성됩니다.

**Lookup을 Master-Detail로 변환할 수 있나요?**

네, 단 먼저 오브젝트의 각 레코드에서 lookup 필드에 값을 채워야 합니다.

**Master-Detail을 Lookup으로 변환할 수 있나요?**

네, 단 롤업 요약 필드를 만들었다면 변환 전에 해당 필드를 삭제해야 합니다.

**Many-to-Many 관계란?**

정션 오브젝트(Junction Object)의 도움으로 구현할 수 있습니다. 예: 오브젝트1=Class, 오브젝트2=Student, 정션 오브젝트=Class와 Student 각각에 관련된 lookup/master-detail 필드를 생성.

**Formula Field란?**

정의한 수식 표현식에서 값을 도출하는 읽기 전용 필드입니다. 소스 필드가 변경되면 수식 필드가 업데이트됩니다.

**Picklist와 Multi-select Picklist의 차이는?**

- Picklist: 사용자가 하나의 옵션을 선택할 수 있습니다.
- Multi-Select Picklist: 사용자가 하나 이상의 옵션을 함께 선택할 수 있습니다.

**Global Picklist Value Set이란?**

전역 선택 목록 값 세트는 어떤 오브젝트의 어떤 선택 목록이나 다중 선택 목록에서도 사용할 수 있습니다.

**Field Dependency(필드 종속성)란?**

선택 목록이나 다중 선택 목록의 값이 다른 필드에서 사용자가 선택한 값에 따라 동적으로 필터링되도록 하는 종속 관계를 만듭니다.
- 필터링을 주도하는 필드를 "제어 필드(controlling field)"라고 합니다. 1개 이상 300개 미만의 값을 가진 표준/커스텀 체크박스와 선택 목록이 제어 필드가 될 수 있습니다.
- 값이 필터링되는 필드를 "종속 필드(dependent field)"라고 합니다. 커스텀 선택 목록과 다중 선택 목록이 종속 필드가 될 수 있습니다.

**Page Layout이란?**

페이지 레이아웃은 레코드의 필드 값을 표시하는 데 사용됩니다. 관련 목록도 제어할 수 있습니다.

**Compact Layout이란?**

Compact Layout은 페이지에 선택된 필드와 버튼을 표시하는 데 사용됩니다. lookup 관계 필드에 마우스를 올렸을 때도 표시됩니다.

**Related List란?**

lookup 및 master-detail 관계 필드가 생성되면 부모 오브젝트에 관련 목록이 표시됩니다. 관련 목록을 통해 부모 오브젝트에서 자식 오브젝트 레코드를 볼 수 있습니다.

**Lightning Page의 유형은?**

App Page, Home Page, Record Page.

**Component Visibility란?**

컴포넌트가 페이지에 표시될지 여부를 제어하는 필터 기준을 적용하도록 돕습니다.

**Validation Rule이란?**

커스텀 검증을 적용하기 위해 검증 규칙을 만들 수 있습니다. 레코드 삽입/업데이트 시 정의된 기준이 일치하면 검증 규칙이 발동합니다.

**Feed Tracking이란?**

선택된 필드와 관련 레코드 필드의 변경을 추적할 수 있게 합니다. 변경 사항은 chatter 컴포넌트에 표시됩니다. 이전 값, 새 값, 변경한 사람을 보여줍니다.

**Field History Tracking이란?**

- 선택된 필드의 변경을 추적할 수 있게 합니다.
- 변경 사항은 History 관련 목록에 표시됩니다.
- 이전 값, 새 값, 변경한 사람을 보여줍니다.

**Activity Component란?**

다음 액션을 사용할 수 있게 합니다: Event, Task, Email, Log a Call.

**Chatter Component란?**

피드를 추적하는 데 사용됩니다. 사용자는 레코드에 콘텐츠를 게시하고 다른 사용자를 멘션할 수 있습니다.

**Duplicate Rule과 Matching Rule이란?**

- Duplicate Rule: 중복 레코드 생성을 방지합니다. 중복 발생 시 경고를 표시하거나 레코드 생성/업데이트를 차단합니다. 중복 레코드에 대한 리포트도 만들 수 있습니다.
- Matching Rule: 중복 검사 기준을 설정합니다.

**List View란?**

- 오브젝트에 있는 레코드 목록을 보여줍니다. 어떤 필드를 표시할지 선택할 수 있습니다.
- 공유와 필터를 적용할 수도 있습니다.

**Record Type이란?**

서로 다른 페이지 레이아웃을 실행하고 레이아웃마다 다른 선택 목록 값을 표시할 수 있게 합니다.

**Schema Builder란?**

- 오브젝트를 그림으로 표현해 볼 수 있게 돕습니다.
- 여러 오브젝트 간의 관계를 볼 수 있습니다.
- Schema Builder를 통해 오브젝트와 필드를 만들 수도 있습니다.

**Email Template이란?**

이메일 템플릿은 flow나 trigger 같은 자동화 도구를 통해 보낼 수 있는 메시지와 병합 필드(merge fields)를 포함합니다.
유형: Classic Email Template(Text, HTML, Custom, VF), Lightning Email Template.

**Global Action vs Object Specific Action?**

- Global Action: 오브젝트의 레코드를 열지 않고도 액션을 실행할 수 있습니다.
- Object Specific Action: 오브젝트의 레코드를 통해서만 실행할 수 있습니다.

**Sales Process란?**

Record Type을 통해 Opportunity 오브젝트의 Stage 선택 목록 값을 제어할 수 없습니다. 따라서 Sales Process를 만들어 Record Type별로 Opportunity의 Stage 선택 목록 값을 제어할 수 있습니다.

**Support Process란?**

Record Type을 통해 Case 오브젝트의 Status 선택 목록 값을 제어할 수 없습니다. 따라서 Support Process를 만들어 Record Type별로 Case의 Status 선택 목록 값을 제어합니다.

**Lead Process란?**

Record Type을 통해 Lead 오브젝트의 Status 선택 목록 값을 제어할 수 없습니다. 따라서 Lead Process를 만들어 Record Type별로 Lead의 Status 선택 목록 값을 제어합니다.

**Setup Audit Trail이란?**

- 조직에서 사용자가 여러 컴포넌트에 수행한 변경 목록을 보여줍니다.
- 지난 6개월간의 변경 사항을 다운로드할 수 있습니다.

**필드를 필수로 만드는 다양한 방법은?**

필드 자체, Page Layout, Validation Rule, Trigger.

**필드를 읽기 전용으로 만드는 다양한 방법은?**

FLS(필드 수준 보안), Page Layout, Validation Rule, Trigger.

**Help Text란?**

필드에 대한 추가 정보를 보여줍니다. 필드에 도움말 텍스트를 두는 것은 선택 사항입니다.

**Data Import Wizard란?**

- Excel/CSV 형식의 데이터를 Salesforce로 가져오는 데 도움을 줍니다.
- Setup에서 찾을 수 있습니다.
- 한 번에 최대 50,000개의 레코드를 가져올 수 있습니다.
- Insert, Update, Upsert 작업을 수행할 수 있습니다.

**Data Loader란?**

- Excel/CSV 형식의 데이터를 Salesforce로 가져오는 데 도움을 줍니다.
- Setup을 통해 컴퓨터에 설치해야 합니다.
- 한 번에 최대 5,000,000개의 레코드를 가져올 수 있습니다.

**Data Loader의 작업(Operations)은?**

Insert, Update, Upsert, Delete, Export, Export All(삭제된 레코드 포함).

**Salesforce의 공유와 보안이란?**

- 데이터 보안은 조직이나 앱에서 사용자(또는 사용자 그룹)가 무엇을 볼 수 있는지 제어해야 하므로 중요합니다.
- Salesforce는 계층화된 공유 모델을 제공합니다.
- 서로 다른 데이터 세트를 서로 다른 사용자 그룹에 쉽게 할당할 수 있습니다.
- 전체 조직, 특정 오브젝트, 필드, 레코드에 대한 접근을 제어할 수 있습니다.

**공유 및 보안 모델**

조직 수준 보안(Organization Level), 오브젝트 수준 보안(Object Level), 필드 수준 보안(Field Level), 레코드 수준 보안(Record Level).

**조직 수준 보안(Organization Level Security)**

- 승인된 사용자 목록 유지
- 비밀번호 정책 설정
- 특정 시간과 위치로 로그인 제한 (로그인 가능한 IP 주소 제한, 로그인 가능한 시간 제한)

**오브젝트 수준 보안(Object Level Security)**

- 표준 및 커스텀 오브젝트 모두에 대해 오브젝트 수준 권한을 제어할 수 있습니다.
- 특정 오브젝트에 대한 권한을 설정할 수 있습니다.
- 해당 오브젝트의 레코드를 보기, 생성, 편집, 삭제하는 권한을 부여할 수 있습니다.
- 프로필과 권한 집합을 사용해 오브젝트 권한을 제어합니다.

**필드 수준 보안(Field Level Security)**

- 사용자가 오브젝트 수준 접근 권한이 있더라도 특정 필드에 대한 접근을 제한할 수 있습니다.
- 특정 사용자에게는 필드를 보이게 하고 다른 사용자에게는 숨길 수 있습니다.
- 필드에 Read 또는 Edit 권한을 부여할 수 있으며, 둘 다 부여하지 않으면 해당 필드는 보이지 않습니다.
- 프로필과 권한 집합으로 제어합니다.

**프로필(Profile)이란?**

- 프로필은 설정과 권한의 모음입니다.
- 프로필 설정은 사용자가 어떤 데이터를 볼 수 있는지를, 권한은 그 데이터로 무엇을 할 수 있는지를 결정합니다.
- 프로필은 여러 사용자에게 할당될 수 있지만, 사용자는 한 번에 하나의 프로필만 가질 수 있습니다.

**프로필을 통해 제어할 수 있는 것은?**

할당된 앱 및 연결된 앱, 오브젝트 설정, 앱 권한, Apex 클래스 및 VF 페이지 접근, 외부 데이터 소스 접근, Named Credential 접근, Flow 접근, 커스텀 권한 및 Custom Metadata Type, Custom Setting 정의, 시스템 권한.

**Enhanced Profile User Interface란?**

- Setup > User Management Settings를 통해 Enhanced Profile User Interface로 전환할 수 있습니다.
- 활성화하면 간소화된 UI를 통해 프로필의 설정과 권한을 찾아보고, 검색하고, 수정할 수 있습니다.

**권한 집합(Permission Set)이란?**

- 권한 집합은 사용자에게 다양한 도구와 기능에 대한 접근을 부여하는 설정과 권한의 모음입니다.
- 프로필을 변경하지 않고 사용자의 기능 접근을 확장합니다.
- 권한을 부여할 수 있고 언제든 회수할 수도 있습니다.
- 사용자는 프로필을 하나만 가질 수 있지만, 여러 권한 집합을 할당받을 수 있습니다.

**권한 집합을 통해 추가할 수 있는 것은?**

할당된 앱 및 연결된 앱, 오브젝트 설정, 앱 권한, Apex 클래스 및 VF 페이지 접근, 외부 데이터 소스 접근, Named Credential 접근, Flow 접근, 커스텀 권한 및 Custom Metadata Type, Custom Setting 정의, 시스템 권한.

**Permission Set Group이란?**

- 사람에 따라 서로 다른 권한 집합을 함께 묶습니다.
- 권한 집합에서 사용 가능한 모든 권한을 포함합니다.
- 하나의 권한 집합이 둘 이상의 권한 집합 그룹에 포함될 수 있습니다.
- 사용자는 하나 이상의 권한 집합 그룹을 할당받을 수 있습니다.
- 권한 집합과 권한 집합 그룹을 함께 할당할 수도 있습니다.

**Permission Set Group의 MUTE란?**

- 권한 집합 그룹에서 일부 권한을 음소거(mute)하여 사용자에게 부여되지 않게 할 수 있습니다.
- 권한 집합 그룹에서 특정 권한을 음소거해도 개별 권한 집합에는 영향을 주지 않으며 그대로 유지됩니다.
- 언제든 권한 집합 그룹에서 권한 음소거를 해제할 수 있습니다.

**사용자에게 몇 개의 프로필을 할당할 수 있나요?** 하나.

**사용자에게 몇 개의 권한 집합을 할당할 수 있나요?** 0개 또는 임의의 개수.

**레코드 수준 보안(Record Level Security)**

- 사용자가 오브젝트 수준 권한이 있더라도 레코드 접근을 제한할 수 있습니다.
- 예: 사용자가 자신의 레코드는 볼 수 있지만 다른 사람의 레코드는 볼 수 없게 합니다.
- 다음 방법으로 관리합니다: 조직 전체 기본값(OWD), 역할 계층, 공유 규칙, 수동 공유.

**OWD란?**

- 레코드의 기본 접근 수준을 지정합니다.
- 조직 전체 공유 설정은 데이터를 가장 제한적인 수준으로 잠급니다.
- 세 가지 접근 수준이 있습니다: Private, Public Read-Only, Public Read/Write.
- 다른 레코드 수준 보안 및 공유 도구를 사용해 레코드 공유를 개방할 수 있습니다.

**역할 계층(Role Hierarchy)이란?**

- 계층에서 상위에 있는 사용자에게 접근을 부여합니다.
- 그 사용자는 계층에서 자기 아래에 있는 사용자가 소유한 모든 레코드에 접근할 수 있습니다.
- 계층의 각 역할은 사용자(또는 사용자 그룹)가 필요로 하는 데이터 접근 수준을 나타내야 합니다.
- 역할 계층이나 사용자 상세 페이지를 통해 사용자를 역할에 할당할 수 있습니다.

**Grant Access Using Hierarchies란?**

- 역할 계층에서 상위에 있는 사용자가 하위 사용자의 레코드에 접근할 수 있는지 여부를 제어합니다.
- 모든 표준 오브젝트에 대해 기본적으로 체크되어 있습니다.
- 커스텀 오브젝트에 대해서는 제어할 수 있습니다.

**공유 규칙(Sharing Rule)이란?**

- 공유 규칙은 조직 전체 기본값에 대한 예외입니다.
- 공유 규칙을 통해 레코드를 사용자 그룹, 역할, 역할 및 하위 역할(roles & subordinates)에 공유할 수 있습니다.
- 그래서 소유하지 않거나 수동으로 볼 수 없는 레코드에 접근할 수 있게 됩니다.

**공유 규칙을 만드는 두 가지 방법은?**

소유권 기반 공유(Owner Based Sharing), 기준 기반 공유(Criteria Based Sharing).

**수동 공유(Manual Sharing)란?**

- 특정 레코드의 소유자가 다른 사용자와 레코드를 공유할 수 있게 합니다.
- 조직 전체 기본값, 역할 계층, 공유 규칙처럼 자동화되어 있지 않습니다.
- 특정 레코드를 다른 사용자와 수동으로 공유하려는 상황에서 유용합니다.

**Public Group이란?**

- 사용자 그룹입니다.
- 언제든 Public Group에서 사용자를 추가하거나 제거할 수 있습니다.
- 멤버가 될 수 있는 것: Public Group, 역할, 역할 및 하위 역할, 사용자.
- Public Group을 만들 때 Grant Access using Hierarchies도 제어할 수 있습니다.

**오브젝트에 EDIT 권한이 없지만 OWD가 Public Read/Write인 경우?**

사용자는 레코드를 편집할 수 없습니다.

**View All & Modify All?**

- 공유 및 보안 설정에 관계없이 오브젝트의 모든 레코드에 접근을 부여합니다.
- View All과 Modify All 권한은 공유 모델, 역할, 공유 규칙을 무시합니다.

**Salesforce의 데이터 분석 도구는?**

Report, Dashboard.

**Report란?**

- 정의된 기준을 충족하는 오브젝트 관련 레코드의 목록입니다.
- 필터링, 그룹화, 계산을 할 수 있습니다.
- 차트를 통해 그래픽으로 표시할 수 있습니다.
- 모든 리포트는 폴더에 저장됩니다.
- 리포트 폴더는 리포트를 보기/편집/관리하는 접근 방식을 결정합니다.
- 리포트 폴더는 public, hidden, shared일 수 있습니다.

**Report Type이란?**

- 리포트의 템플릿과 같습니다.
- 리포트를 만들 때 사용할 수 있는 필드와 레코드를 결정합니다.
- 기본 오브젝트(primary object)와 관련 오브젝트 간의 관계를 기반으로 합니다.
- 예: "Accounts with Contact" 리포트 타입에서 Account가 기본 오브젝트, Contact가 관련 오브젝트입니다.
- 리포트는 리포트 타입에 정의된 기준을 충족하는 레코드를 표시합니다.
- 형태: 관련 오브젝트가 있는 기본 오브젝트 / 관련 오브젝트가 있거나 없는 기본 오브젝트.

**리포트의 유형은?**

- Tabular Report: 목록 작성
- Summary Report: 행으로 그룹화
- Matrix Report: 행과 열로 그룹화
- Joined Report: 둘 이상의 리포트를 함께

**Tabular Report란?**

- 가장 단순한 리포트 형식입니다.
- 행은 레코드를, 열은 필드를 표시합니다.
- 필터와 정렬을 적용할 수 있습니다.
- 차트는 지원되지 않습니다.

**Summary Report란?**

- 행을 기준으로 레코드를 그룹화할 수 있습니다.
- 특정 필드를 기준으로 리포트를 요약할 수 있습니다.
- 차트를 지원합니다.
- 필터와 정렬을 적용할 수 있습니다.
- 숫자 필드에 대해 소계도 표시합니다.

**Matrix Report란?**

- 행과 열을 기준으로 레코드를 요약합니다.
- 그리드를 만들어 행과 열의 그룹화를 기반으로 레코드 수를 보여줍니다.
- 차트를 지원합니다.

**Joined Report란?**

- 서로 다른 유형의 리포트로 구성된 여러 블록을 만들 수 있습니다.
- 각 블록은 하위 리포트(sub report)로 정의되며 서로 다른 리포트 타입을 가질 수 있습니다.
- 각 블록은 자체 필드, 필터 기준, 차트 등을 가집니다.

**리포트의 필터는?**

- Standard Filter: Show Me & Created Date
- Field Filter: 필드별
- Filter Logic: Field Filter를 제어하는 불리언 조건
- Cross Filter: With/Without 조건을 사용해 자식 오브젝트로 리포트 필터링

**어떤 유형의 리포트에 차트를 추가할 수 있나요?**

Summary Report, Matrix Report, Joined Report.

**리포트에서 사용 가능한 차트 유형은?**

Bar, Column, Stacked Bar, Stacked Column, Line, Donut, Funnel, Scatter Plot.

**리포트의 Bucket Field란?**

- 리포트 자체에서 생성됩니다.
- 오브젝트의 특정 필드 값을 그룹화하는 데 사용됩니다.
- Picklist, Number, Text 타입 필드를 지원합니다.

**리포트 폴더에 대해:**

- 리포트 폴더는 리포트를 보기/편집/관리하는 접근 방식을 결정합니다.
- public, hidden, shared일 수 있습니다.
- 역할, 권한, public group, 영역(territory), 라이선스 타입을 기반으로 폴더 콘텐츠 접근을 제어할 수 있습니다.

**리포트를 사용자나 그룹과 공유할 수 있나요?**

네, 리포트 폴더를 공유할 수 있습니다. 개별 리포트는 공유할 수 없습니다.

**리포트 폴더 공유 시 접근 수준은?**

View, Edit, Manage.

**Lightning Page에 리포트를 배치할 수 있나요?**

네, Home Page, App Page, Record Page에 배치할 수 있습니다. 단, 리포트가 private 폴더에 있으면 안 됩니다.

**Dashboard란?**

- 조직의 레코드에 대한 핵심 지표와 추세를 시각적으로 표시합니다.
- 대시보드의 소스는 리포트입니다.
- 단일 대시보드의 여러 컴포넌트에 하나의 리포트를 배치할 수 있습니다.
- 단일 대시보드 페이지에 여러 리포트를 두면 강력한 시각적 표시 도구가 됩니다.

**Lightning Page에 대시보드를 배치할 수 있나요?**

네, Home Page, App Page, Record Page에 배치할 수 있습니다. 단, 대시보드가 private 폴더에 있으면 안 됩니다.

**대시보드에 필터를 적용할 수 있나요?** 네.

**대시보드 폴더에 대해:**

- 대시보드 폴더는 콘텐츠에 누가 접근할 수 있는지 제어합니다.
- 폴더에 접근할 수 있어야만 대시보드에 접근할 수 있습니다.
- 단, 대시보드 컴포넌트를 보려면 기반 리포트에 대한 접근도 필요합니다.

**대시보드를 사용자나 그룹과 공유할 수 있나요?**

네, 대시보드 폴더를 공유할 수 있습니다. 개별 대시보드는 공유할 수 없습니다.

**대시보드 폴더 공유 시 접근 수준은?**

View, Edit, Manage.

**대시보드에 대한 중요 사항?**

- 각 대시보드에는 실행 사용자(running user)가 있습니다.
- 실행 사용자의 보안 설정이 대시보드에 표시할 데이터를 결정합니다.
- 실행 사용자가 특정 사용자라면, 모든 대시보드 조회자는 자신의 보안 설정과 무관하게 그 사용자의 보안 설정 기반 데이터를 봅니다.
- Dynamic Dashboard는 실행 사용자가 항상 로그인한 사용자인 대시보드입니다. 여기서 각 사용자는 자신의 보안 설정에 따라 대시보드를 봅니다.
