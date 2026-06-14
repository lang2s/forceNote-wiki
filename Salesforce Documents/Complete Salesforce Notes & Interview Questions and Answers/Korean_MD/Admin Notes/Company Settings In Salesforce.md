# Salesforce의 회사 설정(Company Settings)

회사 설정은 Salesforce를 사용하는 조직을 설명하는 전역 속성의 모음입니다. 회사, 통화, 회계 연도, 지원, 로케일 설정으로 구성됩니다.

## 1. 회사 정보 업데이트

회사 정보 페이지에는 회사 주소, 연락처, 기업 통화(corporate currency), 조직 기본 시간대, 언어·로케일 설정이 있습니다.

경로: Setup | Administer | Company Profile | Company Information → Edit → 조직명·주 연락처·연락처·회사 정보 업데이트 → Save.

**주요 필드:**
- **Organization Name:** 조직 이름(최대 80자)
- **Primary Contact:** 조직의 주 연락처/관리자(최대 80자)
- **Division:** 서비스를 사용하는 그룹·부서(최대 40자)
- **Fax/Phone:** 팩스·전화번호(최대 40자)
- **Address:** Street, City, State/Province, Zip, Country

## 2. 로케일 설정(Locale Setting)

Locale Setting 탭에서 Default Locale, Default Language, Default Time Zone, Currency Locale 필드를 업데이트할 수 있습니다. 경로: Setup → Administer | Company Profile | Company Information → Edit → Local Settings 탭에서 조직 정책에 맞게 변경 → Save.

## 3. 통화 설정(Currency Settings)

**Corporate Currency(기업 통화):** 조직 본사가 보고하는 매출 통화입니다. 다중 통화를 사용하는 조직에서 활성화되며, 그렇지 않으면 조직의 로컬 통화를 표시합니다(예: 호주는 AUD). 조직이 거래하는 통화를 결정하는 중요한 기능입니다.

**기업 통화 변경:** Setup | Administer | Company Profile | Manage Currencies → Change Corporate → 새 기업 통화 선택.

**다중 통화(Multiple Currencies):** Salesforce의 고급 기능. 활성화하면 영업 담당자가 Opportunity 필드에 자신의 로컬 통화로 금액을 입력할 수 있습니다. Opportunity, 예측, 리포트, 견적 등에서 다중 통화 사용 가능. 관리자는 본사 통화를 반영하는 기업 통화를 설정하고 활성 통화 목록과 환율을 유지합니다.

**다중 통화 활성화의 영향:**
- 한 번 활성화하면 비활성화 불가.
- 모든 레코드에 활성화 시 지정한 기본 통화가 찍힘.
- Opportunity, Opportunity Product 등은 다중 통화 호환 필드 포함.
- 활성화 후 모든 통화 필드에 ISO 코드 표시(예: $50 → USD 50).
- 지원 통화 목록에 추가된 통화는 비활성화해도 제거 불가.
- 사용자가 개인 기본 통화(secondary currency) 설정 가능.

**다중 통화 활성화 방법:** Help and Training → Contact Support → Open a Case → Product Topics에서 "Limits & Feature Activations" 선택 → 사유 입력 → 제출. 이후 조직 관리자가 Organization ID, 기본 통화, 비활성화 불가 이해 확인, 권한 있는 시스템 관리자 확인 등을 이메일로 제공하면 Salesforce가 활성화.

**새 통화 추가:** Setup | Administer | Company Profile | Manage Currencies → Add New → Currency Type, Conversion Rate, Decimal places 선택.

## 4. 회계 연도(Fiscal Year)와 커스터마이징

회계 연도는 연간 재무제표 계산에 사용되는 기간입니다. 두 유형 지원: 표준, 커스텀.

**표준 회계 연도(Standard Fiscal Year):** 기본은 그레고리력. 조직에 따라 시작 월 변경 필요(예: 4월 시작). 아무 월의 첫날에 시작 가능. 선택한 월의 시작/끝 기준 정의 가능.
경로: Setup | Administer | Company Profile | Fiscal Year → Standard Fiscal Year 선택 → 시작 월 선택 → 월의 시작/끝 기준 선택 → (선택) Apply to all Forecasts and Quotas → Save.

**커스텀 회계 연도(Custom Fiscal Year):** 표준이 요구를 충족하지 못할 때 사용. 활성화해야 함. 복잡한 회계 연도 구조 구현 가능. 활성화 후 모든 커스텀 회계 연도를 직접 정의해야 함.
활성화: Fiscal Year → Custom Fiscal Year 선택 → 영향 이해 체크박스 선택 → Enable Custom Fiscal Years → OK.
새 정의: Fiscal Year → New → 템플릿 유형 선택 → Continue → 회계 연도 이름·시작 요일 설정 → Save.

## 5. 영업 시간(Business Hours) 설정과 효과

영업 시간은 비즈니스가 일반적으로 수행되는 시간입니다. 특히 고객 지원팀의 운영 시간 추적에 적용됩니다. 케이스 에스컬레이션 규칙과 엔타이틀먼트 프로세스의 케이스 마일스톤에 적용됩니다.

예: 근무 시간이 오전 8시~오후 5시이고 오후 4시에 케이스가 발생, 에스컬레이션 시간이 2시간이면, 영업 시간이 설정되지 않으면 오후 6시에 에스컬레이션됨. 기본값은 24시간/주 7일.

설정: Setup | Administer | Company Profile | Business Hours → New Business Hour → 이름 입력·Active 체크 → (선택) 기본값으로 사용 → Time Zone 선택, 일~토 근무 시간 정의. 참고: Salesforce가 일광 절약 시간을 자동 계산.

## 6. 휴일 설정(Holiday Settings)

조직이 해당 날에 근무하지 않음을 정의합니다. 그날 발생한 케이스는 근무일로 계산되지 않아 에스컬레이션되지 않습니다.

설정: Setup | Administer | Company Profile | Holidays → New → Holiday Name, Description, Date, Time 입력. 반복 휴일 설정 가능(Recurring Holiday 체크, Frequency·시작·종료일).

**영업 시간과 휴일 연결:** Salesforce가 관련 에스컬레이션 규칙을 일시 중단하도록 연결.
- 방법 1: Holidays에서 휴일 선택 → Add/Remove → 영업 시간 추가(하나의 휴일을 여러 영업 시간에 연결).
- 방법 2: Business Hours에서 영업 시간 선택 → Holidays 목록 Add/Remove(여러 휴일을 하나의 영업 시간에 연결).

## 7. 언어 설정(Language Settings)과 중요성

Salesforce는 전 세계에서 사용되어 다중 언어를 지원합니다.

**개인 설정:** 사용자가 기본 언어를 로컬 언어로 변경 가능. 경로: Name | My Settings | Personal | Language & Time zone → Language 드롭다운에서 선택.

**조직 기본 언어 설정:** 관리자가 여러 언어를 활성화하면 사용자가 선호 언어를 선택 가능. 세 가지 지원 수준:
- **완전 지원 언어(Fully supported):** 사용자 기능과 도움말 페이지가 완전히 번역됨(태국어, 러시아어, 영어, 덴마크어 등).
- **End User Languages(EUL):** 다국어 조직에서 본사와 다른 언어를 쓰는 사용자용. 앱은 그 언어로 접근하되 Setup 메뉴는 접근하지 않음. 활성화: Language Settings → Enable End User Languages 체크 → Save.
- **Platform-Only Languages:** Salesforce 플랫폼에서 만든 커스텀 기능(앱)을 현지화. Salesforce가 번역을 제공하지 않는 언어에 대해 Translation Workbench로 자체 번역 제공. 활성화: Language Settings → Enable Platform Only Languages 체크 → Save. (활성화 시 End User Language도 자동 활성화됨.)
