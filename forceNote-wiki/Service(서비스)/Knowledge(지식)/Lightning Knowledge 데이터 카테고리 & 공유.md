---
tags: [Service, Knowledge, LightningKnowledge, 데이터카테고리, DataCategory, Sharing, 공유, CategoryGroup, Visibility, SharingRules, Admin]
source: lightning_knowledge_guide.pdf (Spring '26, p.75–86)
created: 2026-06-17
aliases: [Knowledge 데이터 카테고리, Data Categories, Category Group, Data Category Visibility, Lightning Knowledge Sharing, Standard Salesforce Sharing, Data Category Mapping, Sharing Considerations, 데이터 카테고리 만들기, 카테고리 그룹 만들기, 데이터 카테고리 가시성 설정, 누가 아티클 볼 수 있어, 아티클 접근 제어, Knowledge 공유 규칙, 데이터 카테고리 매핑, 카테고리로 아티클 분류]
---

# Lightning Knowledge 데이터 카테고리 & 공유

> 데이터 카테고리로 아티클을 분류·접근 제어하고, Lightning Knowledge sharing(표준 Salesforce 공유 모델)으로 필드 기반 접근을 제어하는 방법.

> [!note] Pattern C — 시각 자료
> 이 가이드의 일부 항목(sheet 81–82의 figure caption "An Article About Laptop Deals on the Article Management Tab" / "…on the Articles Tab")은 PDF에 이미지로만 존재하며 추출되지 않았다. 본 위키는 caption만 참조하고 스크린샷을 재현하지 않는다. 아래 카테고리 계층 트리는 직접 그린 구조 예시다.

---

## 데이터 카테고리 정의 개요

> **Editions (deviation — distinct):** Available in: Salesforce Classic, Lightning Experience. Salesforce Knowledge는 Performance와 Developer Editions, 그리고 Unlimited Edition with the Service Cloud에서 사용 가능. 추가 비용으로 Professional, Enterprise, Unlimited Editions.

데이터 카테고리와 data category group을 만들어 Knowledge 사용자와 고객이 필요한 것을 찾도록 돕는다. 일부 데이터 카테고리 정보는 Lightning Knowledge에 적용되지 않는다.

하위 단계: Work with Data Categories; Create and Modify Category Groups; Add Data Categories to Category Groups; Filter Articles with Data Category Mapping; Data Category Visibility.

> [!note] 위임 메모
> Data Category **Metadata API type schema**는 본 노트 범위 밖이며 [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]]에 있다. 여기서는 declarative setup how-to만 다룬다.

---

## 데이터 카테고리 작업 (Work with Data Categories)

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Data categories are available in all editions with Knowledge except Professional Edition.** Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.

- 데이터 카테고리는 Salesforce Knowledge(아티클과 아티클 translation), Ideas, Answers, Chatter Answers에서 아티클·질문·아이디어를 분류·검색하는 데 쓰인다. 아티클·질문·아이디어 집합에 대한 접근을 제어하는 데도 쓴다.
> [!note] Note (verbatim)
> **Summer '20** 릴리스부터 Lightning Knowledge용 표준 Salesforce 공유가 사용 가능하다. 표준 공유로 전환하면 데이터 카테고리 작업 방식과 사용자의 아티클 접근 방식이 바뀐다. Sharing Considerations for Lightning Knowledge 참조.
- **데이터 카테고리의 default 최대 수는 100이다.** 더 필요하면 Salesforce Support에 (active) data category group 수와 group 내 데이터 카테고리 수의 한도 증가를 요청하라.
- 예: 영업 지역과 제품별로 분류 → 두 category group(Sales Regions, Products). Sales Regions는 최상위에 "All Sales Regions", 2단계에 North America, Europe, Asia. Products는 최상위에 "All Products", 2단계에 Phones, Computers, Printers.

### Data Category 한계표 (전수)

| Data Category Limits | Details |
|---|---|
| Maximum number of data category groups and active data category groups | **5 category groups, with 3 active at a time** |
| Maximum number of categories per data category group | **100 categories in a data category group** |
| Maximum number of levels in data category group hierarchy | **5 levels in a data category group hierarchy** |
| Maximum number of data categories from a data category group assigned to an article | **8 data categories from a data category group assigned to an article** |
| Data category assignments for translated articles | Data categories can be added only to the primary article. Data categories for translations are inherited from the primary article and can't be added. |

- answers zone에서, 데이터 카테고리는 질문을 조직한다; 각 answers zone은 하나의 category group을 지원한다. 예: 4개 sibling 카테고리(Performance Laptops, Portable Laptops, Gaming Desktops, Enterprise Desktops)가 있는 Products group; 멤버가 각 질문에 하나씩 배정하고 답을 찾아본다.

### 개념적 사용 (Conceptual uses, 전수)

- **Logical Classification of Articles** — 아티클을 논리적 계층으로 조직하고 중요 속성으로 태그.
- **Easy Access to Questions** — answers admin이 Answers 탭에 어떤 카테고리가 보일지 선택; 멤버가 질문을 카테고리로 태그.
- **Control of Article and Question Visibility** — role, permission set, profile을 카테고리에 매핑하여 visibility를 중앙 제어. 분류된 아티클/질문은 visibility가 있는 사용자에게 자동으로 보인다.
- **Article Filtering** — 카테고리별 필터링은 그 카테고리의 상위·하위 친족을 포함하는 **expansive results**를 갖는다. 예: 계층 All Products > Computers > Laptops > Gaming Laptops; **Laptops**로 필터링하면 Laptops, Computers, All Products, Gaming Laptops로 분류된 아티클을 반환한다. (카테고리 필터링은 sibling/cousin 같은 nonlineal 친족은 반환하지 않는다 — Laptops의 sibling인 Desktops 아티클은 표시되지 않는다.)
- **Article and Question Navigation** — end user가 Articles 탭이나 Answers 탭에서 카테고리를 탐색.
- **Managing Category Groups for Articles and Questions** — Knowledge + answers community가 있으면 별도 category group을 만들거나 둘 다에 같은 group을 쓴다.
- **Data Categories in Articles** — category group은 카테고리 집합의 container다; Knowledge에서는 카테고리 드롭다운 메뉴의 이름에 해당한다. 예: Setup의 Data Categories 페이지(Quick Find에 `Data Category` 입력 후 `Data Category Setup` 선택)에서 **Products** group을 만들고 활성화 → Article Management 탭, 아티클 edit 페이지, 모든 채널의 Articles 탭, public knowledge base에 Products 메뉴가 표시된다.
- *(figure caption만, 이미지 미추출): "An Article About Laptop Deals on the Article Management Tab"; "An Article About Laptop Deals on the Articles Tab")*
- group에 카테고리를 추가하면 최대 **5 levels of depth와 최대 100 categories**까지 계층을 구축한다. 각 카테고리는 하나의 parent, 많은 sibling, 많은 child를 가질 수 있다. 기본적으로 모든 사용자가 모든 카테고리에 접근한다; role, permission set, profile로 제한할 수 있다.

데이터 카테고리 계층 예시:

```
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF 본문 서술 기반으로 직접 그린 카테고리 트리)
All Products
 ├─ Computers
 │   ├─ Laptops
 │   │   └─ Gaming Laptops
 │   └─ Desktops          (Laptops의 sibling — Laptops 필터에 미포함)
 ├─ Phones
 └─ Printers
```

### Data Category Implementation Tips (전수)

- 각 group에 최대 **5 hierarchy levels**로 최대 **3 category groups**를 만들 수 있다; 각 group은 총 **100 categories**를 포함할 수 있다.
- Answers와 함께 데이터 카테고리를 쓰려면, group 생성 후 Setup에서 배정(Quick Find에 `Data Category Assignments` 입력 후 Answers 아래 `Data Category Assignments`). answers community에는 **하나의 category group만** 배정할 수 있다. Knowledge는 여러 category group을 지원한다.
- category group은 **활성화 전까지 사용자에게 숨겨진다.** 카테고리와 접근 설정(visibility 포함)을 모두 정의하기 전에는 활성화하지 마라.
- 아티클에 카테고리를 배정할 때, category group에서 최대 **8개** 카테고리를 선택한다.
- 아티클에 카테고리가 없으면, 카테고리 드롭다운에서 **No Filter** 옵션을 선택할 때만 표시된다.
- 검색 시, 카테고리를 선택하면 parent, children, grandparent를 최상위까지 자동 포함한다. **sibling 카테고리는 포함되지 않는다.** 예: All Products, Switches, Optical Networks, Metro Core 레벨; "Optical Networks"를 선택하면 네 개 중 어느 것의 아티클이든 반환한다. Switches에 Routers라는 sibling이 있으면, "Optical Networks" 선택은 Routers를 반환하지 않는다. Category visibility 설정이 결과를 제한할 수 있다.
- visibility 설정이 선택되면:
  - visibility가 배정되지 않은 사용자는 default category visibility가 셋업되지 않는 한 uncategorized 아티클/질문만 볼 수 있다.
  - role 기반 visibility의 경우, Customer Portal과 partner portal 사용자는 기본적으로 그들의 account manager에게 배정된 category group visibility 설정을 상속한다. portal role별로 변경할 수 있다.
  - category group에서 하나의 카테고리에만 접근권이 있으면, 그 group의 카테고리 드롭다운은 Articles 탭에 표시되지 않는다.
- **Translation Workbench**로 카테고리와 category group의 레이블을 번역할 수 있다.

### Best Practices for Data Categories (전수)

- 데이터 카테고리를 빠르게 관리하려면 **keyboard shortcut**을 쓴다.
- 카테고리 생성/업데이트 후, category group visibility 규칙을 셋업한다.
- 변경을 자주 저장하라. Save 클릭 전 액션이 많을수록 시간이 더 걸린다.

**SEE ALSO:** Sharing Considerations for Lightning Knowledge.

---

## Category Group 생성·수정

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Data categories are available in all editions with Knowledge except Professional Edition.** Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.
> **USER PERMISSIONS:** Data Categories 페이지 보기 — **View Data Categories in Setup**. 데이터 카테고리 생성/편집/삭제 — **Manage Data Categories**.

**Steps (전수):**

1. From Setup, Quick Find에 `Data Category`를 입력하고 `Data Category Setup`을 선택.
2. category group을 만들려면 Category Groups 섹션에서 **New**를 클릭. (기본적으로 최대 **5 category groups, 3 active**.) 기존 group을 편집하려면 이름 위에 호버하여 **Edit Category Group** 아이콘을 클릭.
3. **Group Name**을 지정(최대 **80자**). Article Management와 Articles 탭의 카테고리 드롭다운 제목으로 나타나고, 해당되면 public knowledge base에도 나타난다. Group Name은 Answers 탭에는 나타나지 않는다.
4. 선택적으로 **Group Unique Name**(category group을 **SOAP API**에서 식별하는 unique name)을 수정.
5. 선택적으로 description을 입력.
6. **Save**를 클릭. save 프로세스 완료 후 이메일을 받는다.

### Category Group 활성화 (전수)

- category group을 추가하면 **기본적으로 비활성화**되어 Data Categories, Roles, Permission Sets, Profiles의 관리 setup 페이지에만 표시된다. 계층을 셋업하고 visibility를 배정하는 동안 group을 비활성화 상태로 둔다. 수동으로 활성화하기 전까지는 Salesforce Knowledge나 answers community에 표시되지 않는다. answers community의 경우, Answers 탭에 카테고리가 보이려면 group을 zone에도 배정해야 한다.
- 활성화하려면: group 이름 위에 마우스를 올리고 **Activate Category Group** 아이콘을 클릭.
- category group을 만들면, Salesforce가 **All**이라는 최상위 카테고리를 자동 생성한다. 선택적으로 **All**을 더블클릭하여 이름을 바꿀 수 있다.

---

## Category Group에 데이터 카테고리 추가

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Data categories are available in all editions with Knowledge except Professional Edition.** Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.
> **USER PERMISSIONS:** Data Categories 페이지 보기 — **View Data Categories in Setup**. 데이터 카테고리 생성/편집/삭제 — **Manage Data Categories**.

기본적으로, group에 최대 **100 categories**, 계층에 최대 **5 levels**를 만든다. 더 요청하려면 Salesforce에 연락하라.

> [!note] Note
> Answers 탭에는 first-level 데이터 카테고리만 표시된다. portal/community용 카테고리를 만들 때, 보이는 카테고리가 parent-child가 아니라 **sibling** 관계인지 확인하라.

**Steps (전수):**

1. From Setup, Quick Find에 `Data Category`를 입력하고 `Data Category Setup`을 선택.
2. category group 이름을 클릭.
3. 추가하려는 위치 바로 위(parent)나 같은 레벨(sibling)의 카테고리를 클릭.
4. **Actions**를 클릭하고 **Add Child Category** 또는 **Add Sibling Category**를 선택.
5. 카테고리 이름을 입력(최대 **40자**). 가능하면 Salesforce가 그 이름을 **Category Unique Name**(SOAP API가 요구하는 system 필드)으로 자동 재사용한다.
6. **Add**를 클릭(또는 Enter).
7. **Save**를 클릭. 자주 저장하라.

> [!tip] Tip
> 기본적으로 모든 사용자와 zone 멤버가 active group 내 모든 카테고리를 본다. 카테고리 셋업 후 visibility를 제한하라.

---

## 데이터 카테고리 매핑으로 아티클 필터링

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Data categories are available in all editions with Knowledge except Professional Edition.** Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.
> **USER PERMISSIONS:** data category group 매핑 — **Customize Application AND Manage Salesforce Knowledge.**

case를 해결할 때 suggested article을 더 관련성 있게 만든다. case 필드를 데이터 카테고리에 매핑하여 그 카테고리에 배정된 아티클을 필터링한다. 예: case가 어떤 제품에 관한 것인지 나타내는 필드를 그 제품의 데이터 카테고리에 매핑하면, 그 카테고리가 배정된 아티클이 suggested article 목록 상단으로 필터링된다.

> [!important] Important (전수)
> - case 정보 기반 아티클 필터링은 **text와 picklist 필드에서만 지원된다.**
> - 필터는 **case가 저장된 후** Knowledge 결과에 적용된다.
> - 필터는 **Knowledge 검색 후** 적용되며 검색에서 반환된 아티클에만 적용된다.
> - 필터 사용은 기준에 맞는 **모든 아티클 목록을 반환하지 않는다**; 필터는 반환된 초기 아티클 풀에 적용된다.
> - 결과는 검색 후 필터링될 수 있다.
> - category group은 data category mapping에서 **한 번만** 쓸 수 있다.
> - **Suggest articles for cases considering case content**가 활성화되면 suggested article이 반환된다. suggested articles가 비활성화되면, 검색은 data category mapping을 쓴다. data category mapping이 없으면 case subject 필드가 쓰인다.

**Steps (전수):**

1. From Setup, Quick Find에 `Data Category Mappings`를 입력하고 `Data Category Mappings`를 선택.
2. **Case Field** 컬럼에서 드롭다운으로 필드를 추가.
3. **Data Category Group** 컬럼에서 드롭다운으로 lookup 필드의 정보를 데이터 카테고리에 매핑.
4. **Default Data Category** 컬럼에서 드롭다운으로 필드 값이 어떤 카테고리와도 일치하지 않을 때 배정할 데이터 카테고리를 지정.
5. **Add**를 클릭.

---

## Data Category Visibility

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Data categories are available in all editions with Knowledge except Professional Edition.** Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.

- visibility는 **role, permission set, permission set group, profile**로 설정할 수 있다. 볼 수 있는 개별 데이터 카테고리, 분류된 아티클, 분류된 질문을 결정한다.
> [!note] Note (verbatim)
> **Summer '20** 릴리스부터 Lightning Knowledge용 표준 Salesforce 공유가 사용 가능하다. 표준 공유로 전환하면 데이터 카테고리 작업 방식과 사용자의 아티클 접근 방식이 바뀐다. **View All Records 권한은 Knowledge에 표준 공유가 활성화된 경우에만 동작한다.** Sharing Considerations for Lightning Knowledge 참조.
- 세 가지 visibility 유형 (custom의 경우, role/permission set/profile이 허용하는 카테고리만 본다):
  - **All Categories:** 모든 카테고리가 visible.
  - **None:** 카테고리가 visible하지 않음.
  - **Custom:** 선택된 카테고리가 visible.
- **Visibility Setting Enforcement:** category group visibility는 broadly 해석된다. 카테고리를 visible로 설정하면 그 카테고리와 직접 관련된 전체 family line — 조상, 직속 부모, 직속 자식, 기타 후손 — 이 visible해진다. 예: 최상위에 대륙(Asia, Europe), 2단계에 국가, 3단계에 도시가 있는 Geography group. France만 유일한 visible 카테고리로 선택되면, Europe, France, 모든 프랑스 도시(직접 수직 관계)로 분류된 아티클은 볼 수 있지만, Asia와 다른 대륙 이하로 분류된 아티클은 볼 수 없다.
  > Note: Answers 탭에는 first-level 카테고리만 나타난다. Geography 예시에서 Answers 탭에는 대륙만 나타난다; France가 visible하면 zone 멤버는 Europe으로 분류된 질문을 볼 수 있다.
- category group visibility 설정은 Answers 탭, Article Management 탭, 모든 채널의 Articles 탭(internal app, partner portal, Salesforce.com Community, Customer Portal), public knowledge base에서 enforce된다. 사용자는 설정이 허용하는 카테고리만 본다: 생성/편집 시 Article Management 탭; Article Management와 Articles 탭에서 아티클을 찾는 카테고리 드롭다운; Answers 탭의 zone 이름 아래 나열된 카테고리.
- **Initial Visibility Settings:** role/permission set/profile visibility가 셋업되지 않았으면 모든 사용자가 모든 데이터 카테고리를 본다. visibility가 설정되면, visibility가 없는 사용자는 연관 카테고리를 default로 visible하게 만들지 않는 한 uncategorized 아티클/질문만 본다. Role, permission set, profile visibility 설정은 default visibility 설정을 **제한**한다. 예: 카테고리가 default로 visible해도, role이 접근을 제한하는 사용자에게는 보이지 않는다.
  > Note: visibility가 role, permission set, profile로 정의되면, Salesforce는 정의 사이에 논리 **OR**를 써서 각 사용자에 대한 visibility 규칙을 만든다.
- **Role-Based Visibility Setting Inheritance:** child role은 parent의 설정을 상속하고 parent 변경과 동기화된다. child role의 visibility를 줄일 수 있지만 parent를 넘어 늘릴 수는 없다. Customer Portal과 partner portal 사용자는 account manager에 배정된 category group visibility를 상속한다; portal role별로 변경할 수 있다. high-volume portal 사용자는 role이 없으므로, permission set이나 profile로 visibility를 지정해야 한다.
- **Categorized Article Visibility:** 사용자는 아티클의 category group당 최소 하나의 카테고리를 볼 수 있으면 그 아티클을 볼 수 있다. California+Ohio(Geography)와 Desktop(Products) 예시:
  - Ohio와 Desktop에 visibility(California는 아님) → 볼 수 있다.
  - California나 Ohio에 visibility 없고 Desktop에 visibility → 보지 못한다.
  - California에 visibility 있고 Desktop은 아님 → 보지 못한다.
- **Revoked Visibility:** group에 대해 visibility를 revoke(None으로 설정)할 수 있다. target role/permission set/profile의 사용자는 그 group의 카테고리로 분류되지 않은 아티클/질문만 본다. 예: Geography가 revoke되고 Products visibility만 있으면, Products로 분류된 아티클만 본다. answer zone에는 하나의 category group만 배정할 수 있다; 멤버의 그 group visibility를 revoke하면 → 멤버는 uncategorized 질문만 본다. 자세한 예시는 Category Group Article Visibility Settings Examples 참조.

**SEE ALSO:** Sharing Considerations for Lightning Knowledge.

---

## Sharing for Lightning Knowledge 개요

> **Editions (deviation):** Available in: Lightning Experience. Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.

Lightning Experience에서 organization-wide defaults, owner role hierarchy 기반 접근, sharing rule로 아티클 접근을 제어한다. article 공유가 데이터 카테고리 기반인 Classic과 달리, **Lightning Knowledge sharing은 아티클 내 필드 기반이다.** **record type** 필드를 포함한 대부분의 표준·custom 필드 기반으로 접근을 수정하는 규칙을 만든다. 예: 한 그룹은 FAQ만 보게 하고 다른 그룹은 여러 record type을 보게 하거나; Review Status 필드가 "Needs Review"일 때 reviewer와 공유.

하위 단계: Choose the Sharing or Access Model for Lightning Knowledge; Sharing Considerations for Lightning Knowledge.

---

## Sharing / Access Model 선택

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

표준 Salesforce sharing 모델은 Knowledge의 default(객체 권한을 넘어 접근을 제어하는 데 데이터 카테고리를 쓰는 것)와 대조된다. **표준 sharing을 쓰면 데이터 카테고리가 더 이상 record 접근을 제어하지 않는다.** 지식베이스는 계속 데이터 카테고리로 아티클을 분류하고; 데이터 카테고리는 검색과 쿼리에 영향을 주며 필터로 쓸 수 있다.

**Salesforce sharing 모델을 쓰는 Steps (전수):**

1. From Setup, Quick Find에 `knowledge`를 입력하고 `Knowledge Settings`를 선택.
2. `Edit`를 클릭.
3. **Sharing Settings** 아래에서 **Use standard Salesforce sharing**을 선택.
4. 변경을 저장.
5. sharing 설정을 보려면, From Setup에서 `sharing`을 입력하고 `Sharing Settings`를 선택. 기본적으로 knowledge 객체는 **internal user에게 Public Read/Write, 외부 접근에는 Private**를 쓴다.
6. sharing rule을 추가하려면 **Knowledge Sharing Rules** 아래에서 **New**를 클릭.

- **Use standard Salesforce sharing**을 해제하여 데이터 카테고리 sharing으로 다시 전환할 수 있다. 다시 전환하기 전에 knowledge 아티클의 모든 sharing rule을 삭제할 것을 권장. 표준 sharing을 끄기 전에, internal과 external 사용자의 org-wide default access가 **Public Read/Write**인지 확인하라. sharing recalculation이 끝날 때까지 기다려라(계산 진행 중에는 모델을 바꿀 수 없다).

---

## Sharing Considerations for Lightning Knowledge

> **Editions (deviation):** Available in: Lightning Experience. Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.

> (verbatim) Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

sharing은 org-wide defaults, owner-based sharing, criteria-based rule로 제어/유연성을 준다. 객체 권한, app 권한(예: draft 아티클 보기), 관리자 접근, 그리고 아티클이 internal/external/public으로 사용 가능한지와 함께 동작한다.

### How Do Data Categories Fit In?

표준 sharing으로 전환하면, 데이터 카테고리는 여전히 분류·필터링·검색에 쓰인다. 표준 sharing에서는 데이터 카테고리가 더 이상 접근을 제어하지 않는다 — 단순화하거나 제거할 수 있는지 확인하라. 이전에 (필터가 아니라) 주로 접근 제어를 위해 데이터 카테고리 그룹을 만들었다면, 제거/비활성화를 고려하라. 아티클의 language나 record type을 쓰는 sharing rule이 language, region, record type에 맞는 카테고리 그룹을 대체할 수 있다.

### Article Access with Salesforce Sharing

sharing 모델을 바꾸면 권한과 접근을 다시 생각해야 한다. user profile에 배정된 데이터 카테고리 대신, 표준 sharing은 ownership, defaults, rules를 쓴다.

### Sharing과 아티클 버전

> [!note] API 객체 — 자세한 데이터 모델은 [[Knowledge SOAP API 객체 — 핵심 아티클 객체]] / [[Knowledge 데이터 모델 & API 개요]] 참조.

- sharing은 **아티클 버전(`Knowledge__kav` 객체)** 수준에서 동작하고 primary 아티클(**`Knowledge__ka` 객체**)에서는 아니다. 사용자가 일부 버전에 접근하지만 다른 버전에는 못 하도록 규칙/설정을 구성할 수 있다. (primary 아티클에 영향을 주는) category sharing에서는 버전이 항상 primary 버전과 같은 category 기반 접근을 갖는다. 이는 language 기반 버전과 연속 버전에 적용된다.
- 예: 버전 간 값을 바꾸면 sharing rule의 결과가 바뀌어 접근을 부여/제거할 수 있다. 사용자는 profile에 draft와 archived 아티클 보기 권한이 없으면 published 아티클만 볼 수 있다.

### Object and App Permissions

- 아티클을 **Create, Read, Edit, Delete**하는 Knowledge 객체 권한(profile 권한으로 부여)이 baseline 접근을 제어한다. sharing 설정은 접근을 정제하지만, 사용자가 달리 볼/편집할 수 없는 아티클에 접근을 줄 수는 없다. **현재 object-level `View All Records`와 `Modify All Records`는 더 많은 접근을 부여하지 않는다.**
- Knowledge용 app 권한(예: **View Draft Articles, View Archived Articles**)은 sharing과 무관하게 enforce된다.
- 사용자가 `Knowledge__ka` 객체에 접근권이 없으면, `Knowledge__kav`와 관련된 모든 코드가 에러를 던진다. `Knowledge__kav`와 관련된 것을 구현하기 전에, Schema describe method로 사용자가 `Knowledge__ka` 객체에 접근권이 있는지 확인하라. 예: `Schema.sObjectType.Knowledge__ka.isAccessible()` → Learn More About Enforcing Object and Field Permissions.

### Article Owners and Translations

- knowledge 아티클을 만든 사용자가 primary 아티클의 owner이며, 기본적으로 모든 버전의 owner다. 아티클을 번역에 제출한 사용자가 translation 버전의 owner다. translation이 있으면, sharing 설정이 번역자에게 translation과 primary-language 아티클 버전 접근을 주는지 확인하라. 예: primary-language 아티클의 sharing이 **Private**로 설정되면, 번역자가 primary-language 아티클에 접근하는 것을 막을 수 있다.

### Access for Article Authors

- org-wide default를 **Public Read Only**로 설정하면 non-owner가 editing이나 archived 아티클 restoring 같은 authoring action을 수행하는 것을 막는다. **sharing으로 부여된 Write 접근이 다음 액션 사용에 필요하다: Edit, Publish, Delete Draft, Assign, Edit as Draft, Archive, Submit for Translation, Restore, Delete Archived Article.** **Modify All Data** 권한(sharing을 override)이 있는 admin 사용자는 여전히 아티클을 편집할 수 있다.

### Fields Available for Sharing Rules

custom 필드와 대부분의 표준 필드를 기준으로 규칙을 만들 수 있다. 하지만 다음 필드는 **sharing rule에서 쓸 수 없다:**

- Article Type
- Assignment Date
- Assignment Due Date
- Assignment Note
- File fields
- Is Latest Version
- Is Master Language
- Publication Status
- Translation Completed Date
- Translation Exported Date
- Version Number

> "The Article Type field differentiates articles in Knowledge for Salesforce Classic, while Lightning Knowledge uses Record Type."

### Limitations

다음 Sharing 기능은 Knowledge에서 사용 불가:

- **Manual sharing**
- **Apex sharing**

---

## 관련 노트

- [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]]
- [[Knowledge 데이터 모델 & API 개요]]
- [[Lightning Knowledge 개요 — 계획·비교·한계]]
