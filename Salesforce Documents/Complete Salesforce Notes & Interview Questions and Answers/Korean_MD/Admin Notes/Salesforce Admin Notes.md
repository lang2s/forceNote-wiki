# Salesforce 관리자(Admin) 노트 (Day 1~9)

## DAY 1 — 오브젝트(Objects)

오브젝트는 조직에 특화된 데이터를 저장하는 데이터베이스 테이블입니다. 생성: Setup → Object Manager → Create New Object.

**오브젝트 한도:** Developer 200개, Enterprise/Unlimited/Performance 2,000개. Professional은 커스텀 오브젝트 생성 불가(기존 표준·커스텀 오브젝트 사용).

**두 가지 유형:**
- **표준 오브젝트:** Salesforce 제공(Account, Contact, Lead, Opportunity, Case). 커스터마이징 가능하나 제거 불가.
- **커스텀 오브젝트:** 관리자/개발자가 비즈니스 요구에 따라 생성. 제거·커스터마이징 가능. API 이름이 `__c`로 끝남.

커스텀 오브젝트 생성 시 기본 3개 계층 제공: 테이블(5개 표준 필드: Id, Name, Owner, Created By, Last Modified By), 탭(레코드 관리 UI), 비즈니스 로직(페이지 레이아웃). 표준+커스텀 오브젝트를 통칭 sObject(Salesforce Object)라 합니다.

**생성 옵션:** Singular/Plural Label 입력 → Save. Optional Features(Allow Reports, Allow Activities, Track Field History, Allow in Chatter Groups), Deployment Status(In Development/Deployed), Object Creation Options(Notes & Attachments 관련 목록 추가, Launch New Custom Tab Wizard).

> 참고: "Launch New Custom Tab Wizard" 체크박스를 선택하지 않으면 탭이 생성되지 않으며 이후 3단계가 진행되지 않습니다(나중에 Tabs 섹션에서 별도 생성).

## DAY 2 — 필드(Fields)와 데이터 타입

필드는 테이블의 열로, 애플리케이션 데이터를 저장합니다. 경로: Setup → Object Manager → Fields & Relationships.

- **표준 필드:** 기본 제공(Id, Name, Owner 등). 라벨 변경 가능, 제거 불가.
- **커스텀 필드:** 관리자/개발자가 추가(`__c`). 커스터마이징·제거 가능.

**필드 한도:** Developer 100, Enterprise 500, Unlimited/Performance 800, Professional 100(오브젝트별 상이).

### 데이터 타입

1. **Text:** 영숫자·특수문자 최대 255자. 속성: Field Label, Field Name(API Name), Description, Help Text, Length, Required, Unique, External ID, Auto add to custom report type, Default Value.
2. **Text Area:** 여러 줄, 최대 255자.
3. **Text Area (Long):** 최대 131,072자.
4. **Text Area (Rich):** 최대 131,072자 + 서식(폰트·스타일·색상·이미지·링크).
5. **Text Area (Encrypted):** 민감 데이터 암호화·마스킹. 속성: Data Owner, Field Usage, Data Sensitivity Level, Compliance Categorization(HIPAA, GDPR, CCPA, COPPA, PCI, PII 등), Mask Type(전체/마지막 4자/신용카드/주민번호 등), Mask Character(*, X).
6. **Checkbox:** Boolean(TRUE/FALSE). 기본 옵션 Unchecked.
7. **Date:** 팝업 캘린더로 날짜.
8. **Time:** 12/24시간 형식(HH:MM:SS, 1초=1000밀리초).
9. **DateTime:** 날짜+시간(예: Created By, LastModifiedBy).
10. **Number:** 숫자(소수 포함), 최대 18자리.
11. **Percent:** 숫자 + "%", 최대 18자리.
12. **Currency:** 통화값(통화 기호 접두), 최대 18자리. Company Information에서 통화 기호 변경.
13. **URL:** 웹사이트 경로(하이퍼링크).
14. **Email:** 이메일 주소(형식 검증 내장).
15. **Picklist:** 컬렉션에서 하나 선택.
16. **Picklist (Multi-Select):** 여러 개 선택(세미콜론 구분).
17. **Geo Location:** 위도·경도.
18. **Auto Number:** 자동 번호.
19. **Phone:** 전화번호.

**필드를 필수로 만드는 5가지 방법:** 필드 생성 시 Required 체크, Page Layout 커스터마이징, Validation Rule, Apex Trigger, Visualforce/Aura/LWC.

## DAY 3 — 탭, Schema Builder, List View

**Tab:** Salesforce 앱에서 오브젝트에 접근하는 UI 요소. 경로: Quick Find에서 "Tabs" → Custom Object Tabs → New → 오브젝트 선택.

**Schema Builder:** 오브젝트를 만드는 또 다른 방법. 단점: 탭을 제공하지 않음(별도 생성 필요), 필수 필드만 페이지 레이아웃에 표시, global picklist 값 불가, 필드 수준 보안 불가.

**List View:** 오브젝트 내 필터·정렬된 레코드 목록. 표시할 열·필드를 정의. 모든 오브젝트에서 사용 가능. 표준 List View(Salesforce 제공, 일부 편집 불가)와 커스텀 List View(관리자/개발팀 생성).

## DAY 4 — 오브젝트 관계(Relationships)

두 개 이상의 오브젝트를 연결합니다. 항상 자식 오브젝트에서 정의하고 부모를 참조합니다. 유형: Lookup, Master-Detail, Many-to-Many, Self, Hierarchical, External Lookup.

### Lookup 관계
느슨하게 결합(부모·자식 간 종속성 없음). 복잡한 공유나 cascade 삭제 없이 연결할 때. 부모 삭제 시 자식은 삭제되지 않고 값만 제거. 오브젝트당 최대 40개. Required면 부모 삭제 불가(자식 제거 또는 reparent 필요). 공유·보안 독립. 롤업 요약·cascade 삭제 불가. 표준 오브젝트를 자식으로 가능. Reparent 기본 가능.

### Master-Detail 관계
강하게 결합(자식이 부모에 종속). 부모가 자식 동작 제어. 부모 삭제 시 자식도 삭제(cascade). 자식에 레코드가 있으면 직접 생성 불가(Lookup 먼저 후 변환). 롤업 요약 가능, 오브젝트당 최대 2개. 자식의 공유·보안은 부모에 종속. 자식이 커스텀 오브젝트일 때만 가능(표준 오브젝트는 자식 불가). 커스텀→커스텀, 커스텀→표준(부모) 가능.

### Many-to-Many (Junction Object)
두 오브젝트 간 직접 다대다 불가. 정션 오브젝트(자식)로 구현. 정션은 두 부모와 각각 Master-Detail(또는 Lookup) 관계. 부모 삭제 시 관련 정션 레코드 자동 삭제(다른 부모 레코드는 유지, 연결만 제거).

### Self-Relationship
오브젝트가 자기 자신을 참조하는 Lookup. 단일 오브젝트 내 계층/부모-자식 모델링.

### Hierarchical Relationship
User 오브젝트 전용. 한 사용자를 다른 사용자에 연결(같은 오브젝트 내 부모-자식).

### External Lookup Relationship
Salesforce 레코드를 외부 시스템 레코드와 연결. External Object는 커스텀 오브젝트지만 데이터는 외부 시스템에 저장. 단계: External Data Source 생성 → External Object 생성(Validate Sync 시).
- External Object의 두 관계: External Lookup(부모가 외부 오브젝트), Indirect Lookup(외부 데이터에 Salesforce ID가 없을 때, 자식 외부 오브젝트를 부모 표준/커스텀에 연결).

### 특수 Lookup 관계
- **Account-Contact:** Lookup이지만 Account 삭제 시 Contact도 삭제(Cascade Delete 속성 — 내부적으로 Master-Detail처럼).
- **Account-Opportunity:** Lookup이나 Account에 Opportunity 롤업 요약 생성 가능, Account 삭제 시 Opportunity도 삭제.
- **Account-Case:** 관련 Case가 있으면 Account 삭제 불가("부모 삭제 방지" 기능과 유사).

## DAY 5 — Lookup Dialog 구성과 Lookup Filter

**Lookup Dialog:** 기본적으로 부모 레코드 이름 표시. Classic은 필요한 열 표시, Lightning은 두 필드(기본 Name + 두 번째 줄 정보(Text/Number만)). 기본 최대 200개 레코드. 경로: Object Manager → 부모 오브젝트 → Fields & Relationships → Search Layouts → 편집.

**Lookup Filter:** 자식 레코드 생성 시 lookup 아이콘 클릭 시 표시되는 부모 레코드를 사용자 정의 조건으로 제한. 예: `Position.Location == HiringManager.Location`. 경로: 자식 오브젝트 → Lookup 관계 필드 Edit → Show Filter Settings → 필터 지정 → Enable the Filter 체크 → Save. 필터 유형: Required(일치해야 저장), Optional(필터 제거 가능).

## Rollup Summary

Master-Detail 관계에서 자식 레코드 값을 계산해 부모에 표시하는 커스텀 필드. 부모 오브젝트에만, 읽기 전용(시스템 생성). 오브젝트당 최대 25개. 연산: Count, Sum, Max, Min.

## DAY 6 — 수식 필드(Formula Fields)

지정된 수식으로 계산을 수행하는 읽기 전용 시스템 생성 필드. 데이터 타입으로 "Formula" 선택. 소스 필드 변경 시 재계산. 상세 페이지에 표시. 결과 타입 8가지: Number, Checkbox, Percent, Currency, Text, Date, Time, DateTime. 함수 카테고리: Date & Time, Logical, Math, Text, Advanced. Simple/Advanced 두 방식.

**Date & Time 함수:** ADDMONTHS, MONTH, DAY, TODAY, YEAR.
**Logical 함수:** ISBLANK(숫자·텍스트 지원), ISNULL(숫자만), CASE, IF.
**Math 함수:** ABS, ROUND, CEILING, FLOOR, POWER, SQRT, EXP, LOG, MAX, MIN.
**Text 함수:** CONCATENATE, LEFT/RIGHT 등으로 문자열 연결·조작.
**Advanced 함수:** 여러 논리·수학·텍스트 함수 결합(중첩 수식, 조건부 로직).

예: 이름 길이가 10자리 초과면 REVERSE로 역순 출력, 아니면 "No Reverse Function" (IF + LEN + REVERSE 사용).

## DAY 7 — 검증 규칙(Validation Rules)

레코드 생성·수정 시 특정 조건에 따라 오류 메시지를 페이지 상단이나 필드 아래에 표시. 유효하지 않은 데이터 저장을 방지. 레코드 저장 시 실행. 함수: AND, OR, ISBLANK, ISPICKVAL, ISCHANGED, IF, PRIORVALUE, REGEX, ISNEW, BEGINS, CONTAINS, ADDMONTHS, DATE, TIME, DATEVALUE, DATETIMEVALUE, DAYOFYEAR, CASE, ISNUMBER, LEN 등.

경로: Setup → Object Manager → 오브젝트 → Validation Rules → 이름 입력 → 수식 작성 → 오류 메시지·위치 → Save.

예: Account Number 필수 — `ISBLANK(AccountNumber)`, 빈 값이면 오류 메시지 표시.

## DAY 8 — 사용자(Users)

Salesforce에 로그인하는 자격 증명을 가진 사람. 모든 사용자는 사용자 계정을 가지며, 정확히 하나의 User License를 가짐(접근 가능 기능 결정).

**생성:** Setup → Administer → Manage Users → New User → 필수 필드 입력 → Profile 선택 → Save.

**비활성화(Deactivate):** 사용자 삭제 불가, 비활성화로 로그인 차단. 비활성화된 사용자는 모든 레코드 접근 상실(데이터는 다른 사용자에게 이전 가능). 경로: Users → Edit → Active 체크 해제 → Save.

**동결(Freeze):** 즉시 비활성화할 수 없을 때(커스텀 계층 필드에 선택된 경우 등) 로그인 차단. 경로: Users → 사용자명 → Freeze.

**비밀번호 정책:** 만료 기간, 복잡성, 비밀번호 재설정, 로그인 시도·잠금 기간 설정.

**IP 주소로 로그인 제한:** Setup → Profiles → 프로필 → Login IP Ranges → New → 신뢰 IP 범위 시작·끝 입력 → Save.

**시간으로 로그인 제한:** Profiles → 프로필 → Login Hours → Edit → 로그인 가능 요일·시간 설정.

## DAY 9 — 보안 모델(Security Models)

- **조직 수준 보안:** 최고 수준. 승인된 사용자 목록, 비밀번호 정책, 시간·위치 로그인 제한, IP 제한.
- **오브젝트 수준 보안:** 특정 오브젝트의 보기·편집·삭제·생성 제어. Profiles와 Permission Sets로 지정.
- **필드 수준 보안:** 특정 필드의 보기·편집·삭제·생성 제어. Profile·Permission Set로 제어.
- **레코드 수준 보안:** 1) OWD(모두에 대한 기본값), 2) Role Hierarchy(관리자·하위 역할), 3) Sharing Rules(조건에 따라 그룹·역할·하위 역할), 4) Manual Sharing.
