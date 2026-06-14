---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Cloud Computing Interview Q & A]
---

# Salesforce CRM & 클라우드 컴퓨팅 입문 Q & A

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Salesforce 소개

**Salesforce란?**

1. 1999년 Marc Benioff가 설립한 클라우드 컴퓨팅 회사로, 본사는 미국 캘리포니아 샌프란시스코에 있습니다.
2. Salesforce CRM(Salesforce.com)이라는 CRM 제품으로 잘 알려져 있습니다.
3. 즉, Salesforce는 기업과 고객을 연결하는 클라우드 기반 CRM 솔루션입니다.
4. 세계 1위 CRM 플랫폼으로, 마케팅·영업·커머스·서비스·IT 팀이 어디서나 하나처럼 일할 수 있게 해 고객을 어디서나 만족시킬 수 있습니다.

**Salesforce의 버전:** 1) Lightning(현재 사용하는 최신 버전), 2) Classic(이전 버전).

**Salesforce가 1위 CRM인 이유는?**

소규모 비즈니스와 대기업 모두에게 매우 간단하고 사용하기 쉽습니다. 영업·서비스·마케팅 등을 관리하는 클라우드 기반 애플리케이션으로, IT 전문가가 아니어도 자신의 Salesforce 인스턴스를 설정하고 고객 문의를 처리할 수 있습니다. 주요 이점: 1) 매출 증대, 2) 고객 우선 접근, 3) CRM 비용, 4) 거의 없는 유지보수, 5) 우수한 고객 지원, 6) 모바일 우선 CRM.

**Salesforce의 제품은? (smscc)**

1. Salesforce Sales Cloud
2. Salesforce Marketing Cloud
3. Salesforce Service Cloud
4. Salesforce Community Cloud
5. Salesforce Commerce Cloud 등

**CRM이란?**

Customer Relationship Management(고객 관계 관리). CRM = 마케팅 + 영업 + 서비스. 회사의 모든 고객 및 잠재 고객과의 관계와 상호작용을 관리하는 기술/도구입니다. 여기서 고객 = 기존 고객(제품을 사용 중인 사람), 잠재 고객 = 미래 고객(제품을 살 수 있는 사람). CRM의 목표는 기존 고객을 유지하고 새 고객을 비즈니스로 끌어들이는 것입니다.

**클라우드 컴퓨팅이란?**

인터넷을 통한 컴퓨팅 서비스/IT 서비스의 제공입니다. 쉽게 말해, 필요한 모든 IT 서비스를 벤더 회사(클라우드 제공자)가 제공하고, 사용자는 그 서비스에 접근하기 위해 '인터넷 연결'만 있으면 됩니다.

- IT 서비스 = 하드웨어 / 소프트웨어
- 하드웨어 — 네트워크, 서버, 메모리 공간 등
- 소프트웨어 — 운영 체제, 프로그래밍 언어, 데이터베이스 등

클라우드 컴퓨팅을 사용하면 사용자가 직접 물리적 서버를 관리하거나 자신의 머신에서 소프트웨어를 실행할 필요가 없습니다. 사용한 만큼 비용을 내는 온디맨드 서비스(pay per use)입니다.

- **클라우드(Cloud)란:** 인터넷을 통해 접근하는 서버와, 그 서버에서 실행되는 소프트웨어 및 데이터베이스를 의미합니다. (예: 인쇄 설비를 직접 갖추는 것보다 인터넷 카페에서 출력하는 것이 저렴한 것처럼, 모든 하드웨어·소프트웨어를 직접 유지하는 것보다 필요에 따라 제공하는 클라우드 제공자를 사용하는 것이 쉽습니다.)
- **컴퓨팅(Computing)이란:** 컴퓨터를 사용해 정보를 관리·처리·전달하는 모든 활동으로, 하드웨어와 소프트웨어를 모두 포함합니다.

**클라우드 컴퓨팅의 장점:** 1) 비용, 2) 속도, 3) 성능, 4) 보안.

## 클라우드 서비스의 전달 모델/유형

1. **IaaS – Infrastructure as a Service** (예: 건물 짓는 땅만 제공)
2. **PaaS – Platform as a Service** (예: 애플리케이션 구축에 필요한 모든 것 제공)
3. **SaaS – Software as a Service** (예: 완성된 건물을 직접 제공)

- **IaaS:** 회사가 필요한 서버와 스토리지를 클라우드 제공자로부터 임대해 그 인프라로 애플리케이션을 구축합니다. 땅을 임대해 원하는 것을 짓는 것과 같습니다. 포함 서비스: 서버, 네트워킹, 스토리지.
- **PaaS:** 호스팅된 애플리케이션 대신 자체 애플리케이션을 구축하는 데 필요한 것에 대해 비용을 냅니다. 개발 도구, 인프라, 운영 체제 등 애플리케이션 구축에 필요한 모든 것을 인터넷을 통해 제공합니다. 포함 서비스: 서버, 네트워킹, 스토리지, 운영 체제, 데이터베이스 관리, 개발 도구.
- **SaaS:** 사용자가 기기에 애플리케이션을 설치하는 대신, 클라우드 서버에 호스팅된 애플리케이션을 인터넷을 통해 접근합니다. 포함 서비스: 서버, 네트워킹, 스토리지, 운영 체제, 데이터베이스 관리, 개발 도구, 클라우드 호스팅 애플리케이션.

**Salesforce는 PaaS와 SaaS를 모두 제공합니다.**

**Salesforce.com과 Force.com의 차이는?**

Salesforce.com은 Force.com(PaaS) 플랫폼 위에 구축된 소프트웨어입니다. Salesforce.com은 플랫폼을 제공하여 커스터마이징을 할 수 있게 하는 소프트웨어입니다. Salesforce.com은 소프트웨어, Force.com은 플랫폼입니다. Salesforce.com은 SaaS(표준 앱 사용 가능), Force.com은 PaaS(자체 앱 구축 가능)입니다.

---

## 관리자 파트 (구성) — 데이터 모델링, 오브젝트, 필드, 관계

**Data(데이터)란?**

데이터는 정보의 작은 단위들의 모음, 또는 어떤 목적을 위해 수집·변환된 문자 집합입니다. 텍스트, 숫자, 그림 등이 될 수 있습니다. 예: 모든 학생의 성적 데이터가 있으면 상위권과 평균 점수를 도출할 수 있습니다.

**Database(데이터베이스)란?**

쉽게 접근하고 관리할 수 있도록 조직화된 데이터의 모음입니다. 주 목적은 데이터를 저장·검색·관리하여 대량의 정보를 다루는 것입니다. 데이터는 테이블, 행, 열, 인덱스 형태로 저장됩니다.

Salesforce에서 데이터베이스를 생각하면:
- 테이블(Table) => 오브젝트(Object)
- 열(Column) => 필드(Field)
- 행(Row) => 레코드(Record)
- Primary Key(Id) => 각 레코드의 고유 식별자

**Salesforce의 오브젝트**

오브젝트는 조직에 특화된 데이터를 저장할 수 있는 데이터베이스 테이블입니다. 두 가지 유형이 있고, 세 가지 차이(생성, 삭제, API 이름)가 있습니다.

- **표준 오브젝트(Standard Object):** Salesforce가 기본 제공하는 오브젝트(모든 비즈니스를 위해 공통적으로 만든 것). 예: Account, Contact, Opportunity. 삭제할 수 없습니다.
- **커스텀 오브젝트(Custom Object):** 사용자/개발자가 만드는 오브젝트. 예: Student, Employee. 생성 후 삭제할 수 있습니다.

**표준 vs 커스텀 오브젝트**

| 항목 | 표준 오브젝트 | 커스텀 오브젝트 |
|---|---|---|
| Label | Account | Student |
| Plural Label | Accounts | Students |
| API Name | Account | Student__c |

- **Label:** Object Manager에서 오브젝트를 검색하는 데 사용
- **Plural Label:** 오브젝트 레코드에 접근하는 탭에 사용
- **API Name:** 워크플로우나 Apex 같은 기능에서 사용 (표준 오브젝트는 API 이름이 Label과 같고, 커스텀은 Label 이름 + `__c`)

커스텀 오브젝트는 Object Manager에서 Create > Custom Object로 생성합니다. 오브젝트 생성 시 4개의 표준 필드(CreatedById, LastModifiedById, OwnerId, Name)가 기본 제공됩니다. (Name의 데이터 타입은 Text 또는 Auto Number 가능). 나머지 필드는 개발자가 커스텀 필드로 만듭니다.

> 참고: 커스텀 오브젝트 생성 시 "Launch New Custom Tab Wizard" 선택을 잊었다면, Home 탭에서 Quick Find에 Tabs를 검색해 New 옵션으로 탭을 만들 수 있습니다.

**Salesforce의 탭(Tab)**

Salesforce 페이지 상단에 표시되며, 표준/커스텀 오브젝트와 기타 웹 콘텐츠 등 애플리케이션의 여러 영역에 접근하게 해줍니다. 예: Account, Contact, Student.

**Salesforce의 필드(Field)**

데이터베이스 열과 같습니다. 다양한 데이터 타입이 있으며, 필드에 값을 입력해 레코드를 만듭니다. 예: Text, Phone, Email.

**Field Dependency(필드 종속성)란?**

다른 필드의 값에 따라 선택 목록의 내용을 바꿀 수 있게 하는 필터입니다. 한 선택 목록 필드의 값을 다른 선택 목록/체크박스 필드의 값에 따라 사용 가능하게 하고 싶을 때 사용합니다.
- 제어 필드(Controlling field) => 선택 목록 또는 체크박스만 가능 (예: 주(state))
- 종속 필드(Dependent field) => 선택 목록 또는 다중 선택 목록만 가능 (예: 도시(city), state 값에 종속)

구현 방법: 1) Object Manager에서 오브젝트 선택(Label 이름으로), 2) Fields and Relationships 선택, 3) Field Dependencies에서 New 선택, 4) 제어 필드 선택, 5) 종속 필드 선택. 장점: 제어 필드 값을 선택하지 않으면 종속 필드를 선택할 수 없습니다.

**Salesforce의 App이란?**

모든 오브젝트, 탭, 기타 기능의 컨테이너입니다. 예: Sales, Service, Marketing. 생성: 기어 아이콘 > Setup > Quick Find에서 App Manager 검색.

## Salesforce의 관계(Relationships)

데이터 중복(redundancy)과 데이터 불일치(inconsistency) 문제를 해결하기 위해 관계를 사용합니다. 예를 들어 각 학생이 같은 강좌 정보(강좌명, 수강료, 기간)를 중복 저장하면 데이터 중복이 발생하고, 강좌 수강료 변경 시 모든 학생 레코드를 업데이트해야 하는 데이터 불일치 문제가 생깁니다. RDBMS(관계형 데이터베이스)를 사용해 반복 데이터를 위한 별도 오브젝트를 만들고 두 오브젝트 간 관계를 설정해 이 문제를 해결합니다.

하나의 강좌(Course)는 여러 학생(Student)을 가질 수 있습니다. 여기서 Course는 부모(one 쪽), Student는 자식(many 쪽)입니다. 관계 필드(부모 오브젝트의 Primary Key를 가리키는 Foreign Key)는 자식 오브젝트에만 생성됩니다.

**관계가 필요한 이유?**

1. 데이터 중복(반복)
2. 데이터 불일치(같은 데이터가 여러 번 반복되어, 변경 시 모든 레코드를 업데이트해야 함)

**관계(Relationship)란?**

두 오브젝트 간의 양방향 연관입니다. 관계를 사용해 오브젝트를 서로 연결하고 다른 관련 오브젝트의 데이터를 표시할 수 있습니다. 예: 학생과 강좌, 직원과 부서. 관계형 DB에서는 Primary Key(Id)와 Foreign Key(관계 필드) 개념을 사용합니다. 관계 필드는 항상 자식/many 쪽(detail) 오브젝트에 생성됩니다.

Salesforce에는 기본적으로 두 가지 관계 필드 유형이 있습니다:

1. **Lookup 관계:** 이 오브젝트를 다른 오브젝트에 연결하는 관계를 만듭니다. 사용자가 lookup 아이콘을 클릭해 팝업 목록에서 값을 선택할 수 있습니다.
2. **Master-Detail 관계:** 이 오브젝트(자식/detail)와 다른 오브젝트(부모/master) 간의 특별한 부모-자식 관계를 만듭니다.
   - 모든 detail 레코드에 관계 필드가 필수입니다.
   - detail(자식) 레코드의 소유권과 공유는 master 레코드에 의해 결정됩니다.
   - master 레코드를 삭제하면 모든 해당 detail 레코드가 삭제됩니다.
   - master 레코드에 롤업 요약 필드를 만들어 요약할 수 있습니다.

### Lookup vs Master-Detail의 차이

(1) 종속성: 느슨한 결합이며 관계 필드가 비어 있을 수 있음, (2) 소유권 및 공유 설정, (3) 롤업 요약, (4) 부모 레코드 삭제 시 동작.

**Lookup 관계:**
1. 두 오브젝트 간 관계는 필요하지만 직접적 종속성은 없을 때 사용합니다.
2. 느슨한 결합. 부모 레코드 삭제 시 자식 레코드는 삭제되지 않습니다.
3. 기본적으로 필수가 아니어서 부모 없이도 자식 레코드가 존재할 수 있습니다(관계 필드가 비어 있을 수 있음).
4. 각 자식 레코드는 자체 소유자를 가지며 부모 레코드와 관련되지 않습니다.
5. 롤업 요약이 불가능합니다.

**Master-Detail 관계:**
1. 두 오브젝트 간 직접적 종속성이 있는 강하게 결합된 관계입니다.
2. master 레코드 삭제 시 관련 자식/detail 레코드가 자동으로 삭제됩니다.
3. 기본적으로 관계 필드가 필수여서 부모 없이 자식 레코드를 만들 수 없습니다.
4. 자식 레코드는 소유자가 없습니다(부모 오브젝트가 필수).
5. 롤업 요약이 가능합니다.

두 관계 모두 일대다 관계 유형입니다.

Lookup 관계 생성 단계: 1) Object Manager에서 many 쪽/자식 오브젝트 검색, Fields and Relationships > Lookup Relationship 선택 > 관련 오브젝트(부모) 선택, 2) Label과 이름 입력 후 Next, 3) Next 후 저장.

## Roll-Up Summary 필드

(Master-Detail 관계에서만, master 오브젝트에 생성)

자식(detail) 레코드 집합의 데이터를 요약해 master 레코드에 자동 표시합니다. 자식 오브젝트의 필드의 합계·최대·최소값, 또는 특정 부모에 대한 자식 레코드 개수를 표시할 수 있습니다. Master-Detail 관계의 master 오브젝트에서만 사용 가능합니다. 롤업 요약 필드를 만든 후에는 Master-Detail을 Lookup으로 변환할 수 없습니다.

롤업 요약 함수(관련 목록 변경에 따라 자동 업데이트되는 읽기 전용 필드):
1. **Count:** 부모 레코드의 관련 레코드 총 수 계산
2. **Sum:** 관련 레코드의 선택 필드 값 합계
3. **Min:** 관련 레코드 선택 필드의 최저값
4. **Max:** 선택 필드의 최고값

**롤업 요약 필드 값을 레코드에서 편집할 수 있나요?**

아니요. 읽기 전용 필드라 수동으로 편집할 수 없습니다.

**이미 레코드가 있는 오브젝트에 Master-Detail 관계 필드를 만들려면?**

자식 오브젝트에 이미 레코드가 있으면 Master-Detail을 직접 만들 수 없습니다. 시도하면 오류가 발생합니다. 해결책:
1. 먼저 Lookup 관계 필드를 만듭니다.
2. 모든 자식 레코드에 대해 lookup 필드를 부모 레코드와 연결합니다.
3. 필드 데이터 타입을 Lookup에서 Master-Detail로 변경합니다.
(또는 자식 오브젝트의 모든 레코드를 삭제한 후 생성)

**Lookup을 Master-Detail로 변환할 수 있나요?**

네, 모든 레코드의 lookup 필드에 값이 있으면(모든 자식 레코드에 부모가 연결되어 있으면) 변환할 수 있습니다.

**Master-Detail을 Lookup으로 변환할 수 있나요?**

네, 단 master 오브젝트에 롤업 요약 필드가 없어야 합니다. 있다면 삭제해야 하며, 삭제된 롤업 필드도 영구 삭제해야 합니다. 이는 'Deleted Fields'가 Lightning에 나타나지 않으므로 Salesforce Classic에서만 가능합니다.

**detail 오브젝트에 Owner 필드를 설정할 수 있나요?**

detail 오브젝트의 Owner 필드는 사용할 수 없으며, 연결된 master 레코드의 소유자로 자동 설정됩니다.

**Master-Detail 관계에서 기본적으로 Re-Parenting(부모 변경)을 허용하나요?**

기본적으로 Master-Detail 관계에서는 레코드를 재배치(re-parent)할 수 없습니다. 단, 관리자는 Master-Detail 관계 정의에서 "Allow re-parenting" 옵션을 선택해 커스텀 오브젝트의 자식 레코드를 다른 부모로 재배치하도록 허용할 수 있습니다.

**Lookup Filter란?**

오브젝트 관계 내에서 어떤 레코드를 연관시킬 수 있는지 제한합니다. 특정 기준에 따라 lookup 필드에서 선택할 부모 레코드를 필터링하는 데 사용됩니다. Lookup 및 Master-Detail 관계 모두에서 사용할 수 있습니다.

필터 유형:
- **Required:** 사용자가 입력한 값이 필터 기준과 일치해야 합니다. 일치하지 않으면 저장 시 오류 메시지를 표시합니다.
- **Optional:** 사용자가 필터를 제거하거나 기준과 일치하지 않는 값을 입력할 수 있습니다.

단계: 1) 관계 필드 선택(자식 오브젝트), 2) Edit Field 클릭, 3) Show Filter Settings 클릭해 필터 기준 정의, 4) 정의 후 저장.

## Schema Builder

Salesforce.com의 모든 오브젝트, 필드, 관계를 그림으로 표현한 것입니다. 모든 오브젝트와 관계를 보고 수정할 수 있는 동적 환경을 제공합니다. 생성: Object Manager > Schema Builder.

## Self-Relationship (Self Lookup)이란?

오브젝트가 자기 자신과 관련된 것입니다. 단 Lookup 관계여야 하며, 단일 레코드가 자기 자신에 연결될 수는 없습니다. (Master-Detail은 자기 관계에서 불가능 — 부모가 필수라 부모-자식의 무한 루프가 생기기 때문). 예: Account 오브젝트가 자기 자신과 관련됨, 직원이 다른 직원에게 추천받은 경우.

**Self-relationship에 Master-Detail 관계 필드를 사용할 수 있나요?**

아니요. Master-Detail 정의상 자식 레코드는 부모 레코드가 필요합니다. 자기 자신과 Master-Detail이 되면 부모-자식의 무한 루프가 생깁니다. 즉, 레코드 "A"를 만들 때 부모가 없어 만들 수 없습니다.

## Salesforce의 Many-to-Many 관계

두 오브젝트가 모두 many 쪽이어서 자식 오브젝트를 정할 수 없을 때 사용합니다. 이 경우 세 번째 오브젝트를 자식 오브젝트(Junction Object, 정션 오브젝트)로 만듭니다.

예: Employee와 Project 간 다대다 관계 (한 직원이 여러 프로젝트, 한 프로젝트에 여러 직원). 정션 오브젝트로 Project Task를 만듭니다.
1. 정션 오브젝트(Project Task)는 항상 자식(detail/many) 오브젝트입니다.
2. 정션 오브젝트는 자식이므로 Project와 Employee를 부모로 하는 Master-Detail 관계 필드를 만들 수 있습니다.
3. 롤업 요약은 Master-Detail 관계의 부모(Project, Employee)에 각각 만들어 자식(정션) 오브젝트 데이터를 요약할 수 있습니다.

**Junction Object란?**

서로 다른 두 부모 오브젝트와 Master-Detail 관계를 가지는 자식 오브젝트입니다.

다대다 관계 구현 핵심 포인트(면접 질문):
1. 하나의 오브젝트는 최대 두 개의 Master-Detail 관계만 가질 수 있습니다.
2. 레코드 A(첫 번째 Master-Detail 관계는 항상 primary)를 삭제하면 자식 레코드 C가 삭제됩니다.
3. 레코드 B를 삭제해도 자식 레코드 C가 삭제됩니다.
4. 자식 레코드 C를 삭제하면 C만 삭제되고 master 레코드는 삭제되지 않습니다.
5. 자식 C가 두 master(A, B)를 가지고 A가 primary 관계라면, 자식 C는 부모 A의 룩앤필(look and feel)을 상속합니다.

## 검증 규칙(Validation Rules)

> 구현 시 "언제 데이터를 저장하지 않을지(TRUE)"를 생각하세요. 그 외에는 데이터를 저장합니다. 새 레코드 입력이나 편집 시 저장 전에 발동합니다.

검증 규칙은 사용자가 레코드를 저장하기 전에 입력한 데이터가 지정한 기준을 충족하는지 확인합니다. 하나 이상의 필드 데이터를 평가해 "True" 또는 "False" 값을 반환하는 수식/표현식을 포함할 수 있습니다.
- True 반환 시: 오류 메시지 표시
- False 반환 시: 레코드 저장

검증 규칙은 저장 버튼을 클릭할 때(레코드 저장 또는 기존 레코드 편집 시)만 발동합니다. 수식 작성에 사용할 수 있는 함수: ISBLANK(expression), ISCHANGED(field), ISPICKVAL(picklist_field, text_literal), AND(logical1, logical2, ...) 등.

**구현 예시:**

1) 수강료 검증: `Total_Fees__c < 10000 || Total_Fees__c > 50000` (또는 `OR(Total_Fees__c < 10000, Total_Fees__c > 50000)`) — 둘 중 하나라도 참이면 오류.
2) 입학 일시가 미래일 수 없음: `Admission__c > NOW()` (NOW()는 현재 일시, TODAY()는 현재 날짜만 반환)
3) 휴대폰 번호 길이 10자리: `LEN(Mobile_No__c) <> 10`
4) ISPICKVAL()로 빈 값 또는 특정 값 확인: `ISPICKVAL(Qualification__c, '') || ISPICKVAL(Qualification__c, 'OTHER')`
5) 필드 필수 확인(비어 있으면 오류): `ISBLANK(Address__c)`
6) 선택 목록 필수(None 선택 시 오류): `ISPICKVAL(State__c, '')`
7) 필드 값이 한 번 설정되면 변경 불가: `ISCHANGED(Name)`
8) ISNEW()로 새 레코드 여부 확인:
```
AND(ISBLANK(AnnualRevenue), ISNEW())
```
→ 레코드가 생성 중이고 AnnualRevenue가 비어 있을 때만 발동.
```
AND(ISBLANK(AnnualRevenue), NOT(ISNEW()))
```
→ 레코드가 편집되고 AnnualRevenue가 비어 있을 때 발동.
```
OR(ISBLANK(AnnualRevenue), ISNEW())
```
→ 레코드가 새것이거나 AnnualRevenue가 비어 있으면 발동.

9) **ISBLANK vs ISNULL:** ISBLANK는 공백(" ")을 값 없음으로 간주하여 True 반환. ISNULL은 공백을 값으로 간주해 False 반환. 새 수식에서는 ISNULL 대신 ISBLANK 사용 권장(ISBLANK는 텍스트 필드도 지원).

10) **TEXT():** 백분율, 숫자, 날짜, 일시, 선택 목록, 통화 필드를 텍스트로 변환. 서식·쉼표·통화 기호 없이 반환. 날짜/일시 값은 항상 GMT로 반환됩니다(끝의 Z가 GMT를 의미).

11) `RecordType.Name == 'Fresher'` — 특정 Record Type에만 검증을 적용하려는 경우. 기본적으로 검증은 모든 Record Type에 적용됩니다.

12) IF(logical_test, value_if_true, value_if_false): 예) `if(ISBLANK(AnnualRevenue), true, false)` — AnnualRevenue가 비어 있으면 true가 반환되어 검증이 발동.

**AND vs OR 사용 시점:** OR는 둘 중 하나라도 참이면 오류, AND는 두 조건이 모두 충족될 때 오류.
