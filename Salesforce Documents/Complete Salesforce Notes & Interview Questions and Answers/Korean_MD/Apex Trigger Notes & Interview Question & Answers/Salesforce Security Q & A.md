# Salesforce 보안 (Security) Q & A

**Salesforce란 무엇인가요?**

Salesforce는 기업이 고객, 영업, 업무를 추적·관리하는 데 사용하는 도구입니다.

- 세계 1위 CRM입니다.
- 이름이나 전화번호 같은 고객 정보를 저장하는 데 도움을 줍니다. 이메일 발송이나 리마인더 같은 작업을 자동화합니다.
- 비즈니스 현황을 보여주는 리포트를 생성합니다. 팀이 함께 협업하고 업데이트를 쉽게 공유할 수 있습니다.

**오브젝트 수준 보안(Object-Level Security)이란?**

Salesforce는 프로필(Profile)과 권한 집합(Permission Set)을 통해 오브젝트 접근을 제어합니다. 사용자는 자신의 프로필이 허용하는 오브젝트만 보거나 편집할 수 있습니다.

예: Account 오브젝트에 접근 권한이 있으면 작업할 수 있지만, 프로필이 접근을 허용하지 않으면 볼 수도, 수정할 수도 없습니다.

**필드 수준 보안(Field-Level Security)이란?**

필드 수준 보안은 오브젝트의 어떤 필드를 사용자가 보거나 편집할 수 있는지 제어합니다.

예: Account 오브젝트에서 Account Name 필드는 볼 수 있지만, 프로필이 허용하지 않으면 Annual Revenue 필드는 볼 수 없습니다. 이것이 필드 수준 보안입니다.

**레코드 수준 보안(Record-Level Security)이란?**

레코드 수준 보안은 오브젝트의 어떤 레코드를 사용자가 보거나 편집할 수 있는지 제어합니다. 다음을 통해 관리됩니다: 조직 전체 기본값(OWD), 공유 규칙(Sharing Rules), 수동 공유(Manual Sharing).

예: 나와 공유된 레코드, 또는 OWD와 공유 규칙이 허용하는 레코드만 볼 수 있습니다.

**프로필(Profile)이란?**

Salesforce의 프로필은 사용자가 오브젝트와 커스텀 탭에서 무엇을 할 수 있는지(레코드 보기, 편집, 수정 등)를 정의합니다.

예: 어떤 프로필은 사용자가 Account 오브젝트의 레코드를 보고 편집할 수 있게 하지만 Opportunity 오브젝트에 대한 접근은 제한할 수 있습니다.

**권한 집합(Permission Sets)이란?**

권한 집합은 프로필을 변경하지 않고 사용자에게 추가 권한을 부여하는 데 사용됩니다.

예: 여러 사용자가 작업하는 프로젝트에서 사용자마다 다른 권한이 필요할 경우, 권한 집합을 만들어 각각 할당합니다.

**역할(Role)이란?**

Salesforce의 역할은 역할 계층(role hierarchy)을 기반으로 사용자의 접근 권한을 정의합니다.

예: 계층에서 상위 역할에 있는 사용자는 하위 역할 사용자가 소유한 레코드를 볼 수 있습니다.

**Salesforce의 오브젝트(Objects)란?**

오브젝트는 데이터베이스 테이블에 데이터를 저장합니다. 두 가지 유형이 있습니다:

- **표준 오브젝트(Standard Objects):** Account, Lead, Contact, Opportunity 등 Salesforce가 제공.
- **커스텀 오브젝트(Custom Objects):** 특정 비즈니스 요구사항에 따라 생성.

**Salesforce의 필드(Fields)란?**

필드는 레코드에 대한 정보를 저장하는 데이터베이스 테이블의 열(column)과 같습니다.

커스텀 오브젝트를 만들면 Salesforce가 Created By, Last Modified By, Owner 같은 시스템 필드를 자동으로 추가합니다. 추가 데이터를 저장하기 위해 필요에 따라 커스텀 필드도 만들 수 있습니다.

**Salesforce의 오브젝트 관계(Object Relationships)란?**

오브젝트 관계는 오브젝트가 서로 어떻게 연관되는지 정의합니다. 주요 유형은 다음과 같습니다:

- **Master-Detail 관계:** Master(부모)가 Detail(자식)을 제어하는 강하게 결합된(strongly coupled) 관계입니다. 자식 레코드는 부모 없이 존재할 수 없습니다. 부모를 삭제하면 자식도 삭제됩니다. 오브젝트당 최대 2개의 Master-Detail 관계만 만들 수 있습니다.
- **Lookup 관계:** 자식이 부모와 독립적으로 존재할 수 있는 느슨하게 결합된(loosely coupled) 관계입니다. 부모를 삭제해도 자식에 영향을 주지 않습니다. 오브젝트당 최대 40개의 Lookup 관계를 만들 수 있습니다.
- **Many-to-Many 관계:** 두 오브젝트 사이의 다리 역할을 하는 정션 오브젝트(Junction Object)를 사용해 구현합니다.

**Formula Field(수식 필드)란?**

Formula Field는 다른 필드를 사용해 값을 계산하는 읽기 전용 필드입니다. 소스 필드 값이 변경될 때마다 자동으로 업데이트됩니다.

예: Opportunity에서 Quantity와 Unit Price를 곱해 총 가격을 계산하는 수식 필드를 만들 수 있습니다.

**Validation Rule(검증 규칙)이란?**

Validation Rule은 Salesforce에 입력된 데이터가 저장되기 전에 특정 기준을 충족하도록 보장합니다.

예: Opportunity의 Close Date가 항상 미래 날짜가 되도록 검증 규칙을 만들 수 있습니다.
