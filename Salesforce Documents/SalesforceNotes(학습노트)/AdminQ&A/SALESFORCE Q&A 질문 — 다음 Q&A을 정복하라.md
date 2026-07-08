---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SALESFORCE INTERVIEW QUESTIONS]
---

# SALESFORCE Q&A 질문 — 다음 Q&A을 정복하라

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 이 자료는 관리자(Admin)·개발자(Developer) 영역의 광범위한 Q&A 모음입니다. (원문에 중복되는 항목은 통합 정리했습니다.)

## 관리자(Admin) 면접 질문

**1. 퍼블릭 클라우드와 프라이빗 클라우드의 차이는? Salesforce는 어느 쪽인가요?**

- **퍼블릭 클라우드:** 기반 기술 인프라에 대한 제어가 거의 없이 인터넷을 통해 "서비스로서" 제공됩니다. 둘 이상의 테넌트가 같은 리소스를 사용할 수 있습니다.
- **프라이빗 클라우드:** 역시 "서비스로서" 제공되지만 회사 인트라넷이나 호스팅 데이터센터에 배포되어 고급 보안을 제공합니다.
- **Salesforce.com**은 salesforce.com 데이터센터에 호스팅되고 여러 테넌트의 데이터가 같은 서버에 있으므로 **퍼블릭 클라우드**입니다.

**2. 리포트의 종류는?**

- **Tabular:** 가장 단순하고 빠른 형식. 스프레드시트처럼 열에 필드, 행에 레코드. 그룹이나 차트 불가, (행 제한이 없으면) 대시보드 사용 불가.
- **Summary:** Tabular와 유사하지만 행 그룹화, 소계, 차트 가능. 대시보드 소스로 사용 가능.
- **Matrix:** 행과 열로 데이터 그룹화·요약. 대량 데이터의 여러 필드 비교에 적합.
- **Joined:** 서로 다른 데이터 뷰를 제공하는 여러 리포트 블록 생성. 각 블록은 자체 필드·정렬·필터를 가진 하위 리포트.

**3. 대시보드 컴포넌트의 종류는?**

Chart(그래픽 표시), Gauge(커스텀 값 범위 내 단일 값), Metric(핵심 값 하나), Table(열 형식 리포트 데이터), Visualforce Page(커스텀 컴포넌트), Custom S-Control(Java applet, ActiveX, Excel, HTML 웹 폼 등 브라우저 콘텐츠).

**4. Workflow로 수행 가능한 액션은?**

Email Alert(이메일 템플릿으로 지정 수신자에게 발송), Field Update(특정 값/빈 값/수식 계산값으로 필드 업데이트), Task(제목·상태·우선순위·마감일 지정해 작업 할당), Outbound Message(지정 엔드포인트로 SOAP 메시지 전송).

**5. SFDC의 Group과 그 용도는?**

Group은 사용자 집합으로, 개별 사용자, 다른 그룹, 특정 역할/영역의 사용자(또는 그 하위 포함)를 포함할 수 있습니다. 두 종류: Public Group(관리자만 생성, 조직 전체 사용), Personal Group(각 사용자가 개인용으로 생성). 용도: 공유 규칙 기본 공유 설정, 레코드 공유, Contact 동기화, CRM Content 라이브러리 사용자 추가, Knowledge 작업 할당.

**6. Visualforce View State란?**

form 컴포넌트가 포함된 Visualforce 페이지는 페이지의 view state를 캡슐화하는 암호화된 숨겨진 form 필드를 포함합니다. 컴포넌트, 필드 값, 컨트롤러 상태를 보유합니다. (페이지당 form 수 최소화, SOQL은 필요한 데이터만 조회, transient 변수는 view state에 저장되지 않음.)

**7. Import Wizard로 임포트할 수 있는 오브젝트는?**

Account, Contact, Lead, Solution, 커스텀 오브젝트.

**8. Profile과 그 구성 요소는?**

프로필은 사용자가 조직 내에서 무엇을 할 수 있는지 제어하는 권한과 접근 설정의 모음입니다. 여러 사용자가 하나의 프로필을 가질 수 있지만 사용자는 하나의 프로필만 가집니다. 제어 항목: 표시 가능한 표준/커스텀 앱·탭, 사용 가능한 레코드 타입, 페이지 레이아웃, 오브젝트 권한(CRUD), 필드 보기/편집, 시스템·앱 권한, Apex 클래스·VF 페이지 접근, 데스크톱 클라이언트, 로그인 시간/IP, 서비스 제공자 접근.

**9. Permission Set이란?**

프로필을 변경하거나 재할당하지 않고 한 명 이상의 사용자에게 추가 접근을 부여하는 권한 모음입니다. 접근을 부여할 수는 있지만 거부할 수는 없습니다. 각 권한 집합은 사용자 라이선스와 연결되며, 같은 라이선스를 가진 사용자에게만 할당할 수 있습니다. 포함: 할당된 앱, 오브젝트 설정(탭·오브젝트·필드 권한), 앱 권한, Apex 클래스 접근, VF 페이지 접근, 시스템 권한, 서비스 제공자.

**10. Profile vs Permission Set의 권한 및 접근 설정**

사용자 권한과 접근 설정은 프로필과 권한 집합에서 지정됩니다. 모든 사용자는 하나의 프로필과 여러 권한 집합을 가질 수 있습니다. 모범 사례: 프로필로 최소 권한을 할당하고 권한 집합으로 추가 권한 부여.

| 권한/설정 유형 | 프로필 | 권한 집합 |
|---|---|---|
| 할당된 앱 | O | O |
| 탭 설정 | O | O |
| 레코드 타입 할당 | O | X |
| 페이지 레이아웃 할당 | O | X |
| 오브젝트 권한 | O | O |
| 필드 권한 | O | O |
| 사용자 권한(앱·시스템) | O | O |
| Apex 클래스 접근 | O | O |
| VF 페이지 접근 | O | O |
| 데스크톱 클라이언트 접근 | O | X |
| 로그인 시간 | O | X |
| 로그인 IP 범위 | O | X |

**11. Salesforce의 표준 프로필은?**

6개(EE/UE 및 PE): Standard User(자기 레코드 보기·편집·삭제), Solution Manager(Standard + 게시 솔루션·카테고리 관리), Marketing User(Standard + Lead 임포트), Contract Manager(Standard + 계약 편집·승인·활성화·삭제), Read-Only(레코드 보기만), System Administrator("슈퍼 유저", 커스터마이징·관리).

**12. Force.com 플랫폼이란?**

소프트웨어 없이 서비스로서 엔터프라이즈 애플리케이션을 커스터마이징·통합·생성합니다. 표준 앱을 커스터마이징하거나 자체 온디맨드 앱을 구축하고, 표준/커스텀 탭을 새 커스텀 앱으로 그룹화합니다.

**13. Salesforce 에디션은?**

Personal, Contact Manager, Group, Professional, Enterprise, Unlimited, Developer.

**14. 표준 비즈니스 오브젝트는?**

- **Campaign:** 계획·관리·추적하려는 마케팅 프로젝트.
- **Lead:** 제품에 관심 있을 수 있는 사람/조직(아직 고객 아님).
- **Account:** 비즈니스와 관련된 조직/개인/회사.
- **Contact:** Account에 연결된 개인.
- **Opportunity:** 추적하려는 잠재 매출 발생 이벤트(영업 거래).
- **Case:** 고객 피드백/문제/질문의 상세 설명.
- **Solution:** 고객 이슈와 해결책의 상세 설명.
- **Forecast:** 분기 매출 추정.
- **Report/Dashboard:** 데이터 요약·분석과 실시간 스냅샷.
- **Calendar & Task(Activity):** 작업과 일정 이벤트.
- **Products:** Opportunity에서 판매하는 개별 항목.

**15. Company Profile이란?**

회사 핵심 정보: 언어·로케일·시간대, 라이선스, 저장 공간, 회계 연도, 주 연락처·주소, 통화 관리.

**16. Salesforce의 Fiscal Year(회계 연도)란?**

조직의 재무 계획에 사용되며 예측·할당량·리포트에 영향을 줍니다. 두 유형: Standard Fiscal Year(그레고리력 기반, 아무 월 첫날 시작 가능), Custom Fiscal Year(재무 요구에 따라 커스텀 기간으로 분할). 예측은 Custom Fiscal Year와 함께 사용 불가(Customizable Forecasting 활성화 필요).

**17. 표준 필드와 커스텀 필드**

- **표준 필드:** Salesforce에 사전 정의됨. 삭제 불가하나 필수가 아닌 표준 필드는 페이지 레이아웃에서 제거 가능. 라벨 변경 가능(예: "Accounts"를 "Companies"로).
- **커스텀 필드:** 비즈니스 프로세스 고유 정보 캡처. 삭제된 커스텀 필드는 45일 후 영구 삭제.

**18. 기존 커스텀 필드의 데이터 타입을 변경할 수 있나요?**

네, 가능하지만 다음 경우 데이터 손실 가능: Date/Date-Time으로/에서 변경, 다른 타입에서 Number/Percent/Currency로 변경, Checkbox에서 다른 타입으로, Multi-Select Picklist에서/로 변경, Auto Number에서/로 변경 등.

**19. 종속 선택 목록(Dependent Picklist)이란?**

제어 필드(controlling field)와 함께 작동하여 값을 필터링합니다. 제어 선택 목록의 최대 값은 300개. 커스텀 다중 선택 목록은 제어 필드가 될 수 없습니다.

| 필드 유형 | 제어 필드 | 종속 필드 |
|---|---|---|
| Standard Picklist | O | X |
| Custom Picklist | O | O |
| Custom Multi-Select | X | O |
| Standard Checkbox | O | X |
| Custom Checkbox | O | X |

**20. Page Layout과 Record Type**

- **Page Layout:** 상세/편집 페이지 구성, 표시 필드·관련 목록·커스텀 링크, 필드 속성(표시·읽기 전용·필수).
- **Record Type:** 표준/커스텀 선택 목록에 대해 서로 다른 값 세트를 정의하고 커스텀 비즈니스 프로세스 구현.

**21. Business Process란?**

부서·그룹·시장 전반에 걸쳐 별도의 영업·지원·Lead 라이프사이클 추적. 종류: Sales Process(Opportunity Stage), Support Process(Case Status), Lead Process(Lead Status), Solution Process(Solution Status).

**22. Business Process가 가능한 오브젝트와 예시**

Lead, Opportunity, Case, Solution. 레코드 타입 생성 전에 비즈니스 프로세스를 먼저 만들어야 하며, 여러 비즈니스 프로세스 구현 시 여러 레코드 타입도 구현해야 합니다. 예: Lead Process(Cold Call, 캠페인 Lead), Sales Process(신규 vs 기존 비즈니스), Case Process(고객 문의, 청구 문의).

**23. Web-to-Lead와 Web-to-Case는?**

이를 통해 생성된 레코드는 기본 Lead 소유자나 자동화 Case 사용자의 레코드 타입으로 설정됩니다.

**24. 어느 탭에서 여러 레코드 타입을 만들 수 있나요?**

Home, Forecasts, Documents, Reports 탭을 제외한 모든 탭.

**25. 선택 목록 값을 추가하면?**

새 값을 포함할 레코드 타입을 선택하라는 메시지가 표시됩니다.

**26-27. 필드 수준 보안(FLS)이란/왜 사용하나?**

특정 필드의 보기·편집 접근을 정의합니다. 여러 페이지 레이아웃 대신 FLS로 데이터 보안을 강제. PE에서 사용 불가, FLS로 필드를 필수로 만들 수 없음, 더 제한적인 설정이 적용됨, FLS로 숨긴 필드는 List View·검색·리포트에서도 숨겨짐.

**28. Login Hours와 Login IP Ranges**

특정 프로필 사용자의 사용 시간과 로그인 IP를 설정합니다. 전체 조직 또는 프로필별로 Trusted IP Ranges 추가 가능.

**29-31. User Record / Record Owner / OWD**

- **User Record:** 사용자 핵심 정보, 고유 username, 활성/비활성, 프로필·역할 연결.
- **Record Owner:** 레코드를 제어하는 사용자(Case·Lead는 Queue). 보기·편집·이전·삭제 권한.
- **OWD:** 조직 내 모든 사용자의 기준 접근 수준 정의(접근 제한용). 수준: Private, Public Read/Write, Public Read/Write/Transfer, Controlled by Parent, Public Read Only.

**32-33. Role과 Role Hierarchy / Role 수준 접근**

Role은 데이터 가시성 수준을 제어하며 사용자는 하나의 역할과 연결됩니다. Role Hierarchy는 데이터 가시성과 레코드 롤업(예측·리포팅)을 제어하고, 사용자는 하위 사용자의 데이터 권한을 상속합니다. 최대 500개 역할 생성 가능. "Grant Access Using Hierarchies"로 기본 공유 비활성화 가능(Controlled by Parent가 아닌 커스텀 오브젝트).

**34-39. Sharing Rule / 유형 / 사용 사례 / Public Group / Manual Sharing**

(앞선 파일들과 동일 내용) Sharing Rule은 OWD에 대한 예외로 사용자 그룹에 접근(Read Only/Read/Write)을 부여합니다. 접근을 개방하며 OWD 아래로 제한할 수 없습니다. 유형: Account, Contact, Opportunity(EE/UE), Case(EE/UE), Lead(EE/UE), Custom Object(EE/UE). Public Group은 사용자·그룹·역할·역할 및 하위 역할의 모음. Manual Sharing은 일회성 레코드 공유로 OWD가 private일 때만 사용 가능.

**40-44. Sales Team / Account Team / Case Team / Folder**

- **Sales Team(EE/UE):** 협업 영업·공유·리포팅. PE에서 사용 불가.
- **Account Team(EE/UE):** 협업 Account 관리. PE에서 사용 불가.
- **Case Team(EE/UE):** Case 협업, 사용자 팀 추가, 접근 수준 결정.
- **Folder:** 이메일 템플릿·문서·리포트·대시보드 정리. 접근은 Read/Read/Write로 명시적(역할 계층 롤업 안 함). 문서 업로드 5MB, 파일명 255자 제한.

**45-55. Workflow 관련**

Workflow는 이메일 경고·작업·필드 업데이트·아웃바운드 API 메시지·시간 종속 액션을 자동화합니다. 구성: Workflow Rules, Tasks, Email Alerts, Field Updates, Outbound Messages. Time-Dependent Workflow는 레코드 날짜 전후로 시간 민감 액션 실행. 규칙당 최대 10개 time trigger, time trigger당 40개 액션, 규칙당 80개 액션. "생성되고 편집될 때마다" 기준에는 time trigger 추가 불가. Time trigger는 분/초 미지원, TODAY/NOW 자동 파생 함수나 관련 오브젝트 병합 필드 참조 불가.

**56-60. Approval Process 관련**

승인 프로세스는 레코드 승인 자동화 비즈니스 프로세스입니다. 용어: Approval Request, Approval Steps, Assigned Approver, Initial Submission Actions, Final Approval/Rejection Actions, Record Locking(승인 대기 시 자동 잠금, "Modify All Data" 필요), Outbound Messages. Jump Start Wizard(단순 1단계) vs Standard Wizard(복잡). Parallel Approval Routing은 한 단계에서 최대 25명 병렬 승인자.

**61. Data Validation Rule의 구성**

하나 이상의 필드를 True/False로 평가하는 불리언 수식과 True 반환 시 표시되는 오류 메시지. 레코드 저장 시, 임포트 전, Data Loader/API 사용 시 실행. Forecast·Territory를 제외한 모든 오브젝트에 적용. Record Merge에는 미적용.

**62-66. Import Wizard / External ID / Data Loader / Recycle Bin**

- **Import Wizard:** Account·Contact·Lead·커스텀 오브젝트·Solution 임포트, 매칭 ID 기반 업데이트. 표준 사용자 세션당 500개, 관리자 50,000개.
- **External ID:** Text/Number/Email 커스텀 필드 플래그. Report·API SOQL 성능 향상, Upsert 가능. 대소문자 구분 안 함, 오브젝트당 3개.
- **Data Loader:** 대량 임포트/익스포트(insert·update·delete·extract·upsert), 수백만 행, 50,000개 이상이나 야간 정기 로드·백업 시 사용. 최대 250MB Static Resources와는 별개.
- **Recycle Bin:** 삭제 데이터 약 30일 보관, 복구 가능, 저장 한도 미포함.

**67-77. Report와 Dashboard 관련**

Standard Report(기본 제공, 삭제 불가) vs Custom Report(특정 기준, 편집·삭제 가능). Tabular(소계 없음), Summary(정렬·소계), Matrix(가로/세로 그리드, 피벗 유사), Trend Report("as of" 날짜). Chart(가로/세로 막대·선·파이). Relative Date(This Week 등). Custom Report Type(오브젝트 관계 기반 프레임워크). Conditional Highlighting(리포트당 최대 3개 조건, 요약 행, 숫자만). Dashboard(여러 리포트 시각화, Running User가 접근 결정). 컴포넌트: Chart, Table, Metric, Gauge.

**78-83. Campaign / Lead / Case / Solution / Self-Service Portal / AppExchange**

(앞선 파일과 동일) Campaign(마케팅 프로그램), Lead(잠재 고객), Case(기록된 이슈), Solution(질문/문제 답변), Self-Service Portal(인증 24/7 지원), AppExchange(salesforce.com 마켓플레이스).

**84. Force.com IDE와 Sandbox의 차이는?**

Force.com IDE는 Eclipse 기반의 강력한 클라이언트 애플리케이션으로 코드 작성·컴파일·테스트·배포를 IDE 내에서 수행합니다. Sandbox는 salesforce.com 인스턴스의 정확한 사본으로, 라이브 인스턴스를 복사할 수 있습니다.

**85-88. Roll-up Summary / 관계 유형 / Account 삭제 / 이메일 템플릿**

Roll-up Summary는 자식 레코드의 Count·Sum·Min·Max 계산, Master 오브젝트에만 생성. 관계 4유형: Master-Detail, Many-to-Many, Lookup, Hierarchical(User 오브젝트만). Account 삭제 시 관련 Contact·Opportunity도 삭제. 이메일 템플릿: Text, HTML with Letterhead, Custom HTML, Visualforce.

**89. Salesforce 트리거 순서와 실행 순서(Order of Execution)**

1) 원본 레코드 로드/초기화 → 2) 새 값 덮어쓰기(표준 UI 시 시스템 검증) → 3) before 트리거 → 4) 시스템 검증 재실행 + 사용자 정의 검증 → 5) DB 저장(미커밋) → 6) after 트리거 → 7) 할당 규칙 → 8) 자동 응답 규칙 → 9) 워크플로우 규칙 → 10) 워크플로우 필드 업데이트 시 재업데이트 → 11) 필드 업데이트 시 before/after 트리거 한 번 더(커스텀 검증 제외) → 12) 에스컬레이션 규칙 → 13) 롤업 요약/크로스 오브젝트 계산(부모) → 14) 조부모 계산 → 15) Criteria Based Sharing 평가 → 16) DML 커밋 → 17) 커밋 후 로직(이메일).

**90-97. 사용자 삭제 / Case 제한 / WhoId·WhatId / 관계 / Lookup→Master 변환 / Apex 호출 / Custom Settings**

사용자 삭제 불가(비활성화만), Mass Delete Record로 데이터 삭제. Case private 공유로 접근 제한. WhoID=Lead/Contact, WhatID=Account/Opportunity/커스텀 오브젝트. Lookup을 Master-Detail로 변환은 모든 레코드에 유효 값이 있을 때만. 기존 레코드에 Master-Detail 직접 생성 불가(Lookup 먼저 후 변환). Apex 호출 방법 4가지: Visualforce 페이지, 트리거, 웹 서비스, 이메일 서비스. Custom Settings(List, Hierarchy)는 캐시되어 SOQL 없이 접근.

---

## 추가 Admin/Developer 질문 (Apex, Visualforce, SOQL)

**레코드를 공유하는 방법은?**

Role Hierarchy, OWD, Manual Sharing(OWD가 private일 때만 버튼 표시), Criteria Based Sharing Rules, Apex Sharing(각 오브젝트의 Share 오브젝트 — 예: AccountShare에 레코드 생성).

**VF의 renderAs로 생성되는 PDF의 최대 크기는?**

15MB.

**Visualforce 페이지에서 컨트롤러는 몇 개?**

하나의 컨트롤러와 여러 확장 컨트롤러.

**Action Support와 Action Function의 차이는?**

- **Action Function:** JavaScript에서 AJAX로 컨트롤러 메서드 호출, 페이지의 여러 곳에서 사용 가능.
- **Action Support:** onMouseOver, onClick 등 이벤트 발생 시 AJAX로 컨트롤러 메서드 호출, 특정 단일 Apex 컴포넌트에 사용.

**Wrapper 클래스란?**

인스턴스가 다른 오브젝트의 모음인 클래스. 같은 테이블에 서로 다른 오브젝트를 VF 페이지에 표시하는 데 사용.

**insert()와 Database.insert()의 차이는?**

insert는 한 레코드에 오류 발생 시 전체 실패. Database.insert는 부분 성공(allOrNone=false)을 허용하여 일부 레코드만 삽입 가능. rollback, 기본 할당 규칙 등 더 유연.

**Static Resource란?**

이미지·zip·jar·JavaScript·CSS 파일 업로드. 조직당 최대 250MB. VF에서 사용: `<apex:includeScript value="{!$Resource.fileName}"/>`.

**VF에서 형식화된 숫자/날짜 표시는?**

`<apex:outputText>` 컴포넌트 사용.

**암호화 필드를 apex:outputText로 표시하면?**

평문으로 표시됨(View Encrypted Data 권한 무시). 대신 `<apex:outputField>` 사용.

**`SELECT COUNT(Id), Name, Address__c FROM Opportunity GROUP BY Name`는 작동하나요?**

오류 발생. GROUP BY에서 선택된 열은 GROUP BY나 집계 함수에 사용되어야 함(Address__c가 둘 다 아니므로 "Malformed Query").

**COUNT()와 COUNT(fieldName)의 차이는?**

COUNT()는 SELECT의 유일한 요소여야 하고 ORDER BY/GROUP BY 불가. COUNT(fieldName)은 ORDER BY/GROUP BY 가능.

**GROUP BY와 함께 WHERE 절은?**

WHERE 대신 HAVING 절 사용. 예: `SELECT COUNT(Id), Name FROM Opportunity GROUP BY Name HAVING COUNT(Id) > 1 AND Name LIKE '%ABC%'`.

**Apex에서 Lead 할당 규칙을 강제하려면?**
```apex
Database.DMLOptions dmlOptn = new Database.DMLOptions();
dmlOptn.assignmentRuleHeader.useDefaultRule = true;
leadObj.setOptions(dmlOptn);
```

**Custom Controller가 필요한 이유는?**

공유 설정을 적용하지 않으려면(without sharing) Custom Controller만 가능. 표준 오브젝트가 필요 없거나 여러 표준 오브젝트가 필요한 기능에 필요.

**with sharing을 쓰지 않으면 system 모드인데 왜 without sharing이 있나요?**

classA(with sharing)가 classB를 호출하면 classB는 기본적으로 with sharing이 적용됨. 이를 피하려면 classB를 명시적으로 without sharing으로 선언.

**share 오브젝트가 생성되지 않는 경우는?**

OWD가 가장 관대한 수준(커스텀 오브젝트의 경우 Public Read/Write)으로 설정된 경우.

**Apex에서 선택 목록 값을 가져오려면?**

Dynamic Apex 사용: `getDescribe()` → `getPicklistValues()`로 반복하여 List<SelectOption> 생성.

**Visualforce 컨트롤러의 유형은?**

Standard Controller, Custom Controller.

**System.runAs()를 설명하세요.**

테스트 메서드에서 사용자 컨텍스트를 변경해 해당 사용자의 레코드 공유를 강제. 테스트 메서드에서만 사용 가능.

**Test.setPage()를 설명하세요.**

현재 페이지로 컨텍스트 설정, VF 컨트롤러 테스트에 사용.

**Apex에서 double을 소수점 2자리로 반올림하려면?**

`Decimal d = 100/3; Double ans = d.setScale(2);`

**static 변수의 범위는?**

클래스 로드 시 한 번 초기화. 요청 범위 내에서만 static(서버나 조직 전체가 아님). VF view state에 전송되지 않음.

**SOQL/SOSL 외에 Custom Settings를 가져오는 방법은?**

자체 메서드: `getInstance('INDIA')`, `getAll()` 등.

**자식이 두 master를 갖고 하나가 삭제되면?**

자식 레코드가 삭제됨.

**render, rerender, renderAs의 차이는?**

render(CSS display처럼 표시/숨김), rerender(AJAX 후 새로 고칠 컴포넌트), renderAs(페이지를 PDF/doc/excel로 렌더링).

**Dynamic Apex로 모든 sObject 목록을 가져오려면?**

`Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe();`

**sObject 인스턴스를 동적으로 생성하려면?**

`gd.get(t).newSObject();`

**Apex의 Property란?**

`public String name {get; set;}` — Java의 getter/setter를 C# 스타일로 한 줄로 캡슐화. 코드 라인 수 절약.

**Controller Extension이란?**

Custom/Standard Controller 오브젝트를 단일 인자로 받는 public 생성자를 가진 Apex 클래스. VF는 하나의 컨트롤러와 여러 확장을 가질 수 있음.

**URL에서 파라미터 값을 읽으려면?**

`Apexpages.currentPage().getParameters().get('RecordType');`

**한 오브젝트에 before insert 트리거 2개가 있으면 실행 순서를 제어할 수 있나요?**

트리거 순서는 사전 정의 불가. 모범 사례: 오브젝트당 트리거 하나, 주석으로 로직 분리.

**Trigger.new와 Trigger.old의 차이는?**
- Trigger.new: 새 버전 레코드 목록. insert·update 트리거에서만, before에서만 수정 가능.
- Trigger.old: 이전 버전 레코드 목록. update·delete 트리거에서만.

**트리거를 한 번만 실행하려면?**

정적 boolean 변수를 헬퍼 클래스에 두고 체크. (트리거는 워크플로우 전후로 두 번 발동 가능.)

**Global 변수란?**

현재 사용자/조직 정보를 참조하는 변수(예: `{!$User.Name}`). $Action, $Api, $Component, $CurrentPage, $Label, $ObjectType, $Organization, $Page, $Profile, $Resource, $Setup, $Site, $User, $UserRole 등.

**Many-to-Many 관계를 만들려면?**

직접 불가. 두 오브젝트를 만들고, 정션 오브젝트(auto number 고유 식별, 두 master 관계)를 만든 뒤 양쪽 오브젝트에 관련 목록으로 추가.

**S-Control이란?**

JavaScript 기반 위젯으로 salesforce가 호스팅하지만 클라이언트 측 실행. 현재 Visualforce로 대체됨.

**Visualforce Page란?**

Salesforce의 마크업 언어로 표준 스타일을 렌더링. 모든 태그는 "apex" 네임스페이스로 시작. 비즈니스 로직은 커스텀 컨트롤러에 작성.

**Merge Field란?**

이메일 템플릿·메일 머지·커스텀 링크·수식 필드에 넣어 레코드 값을 통합하는 필드. 예: `{!CustomObject.FieldName__c}`.

**ISNULL과 ISBLANK의 차이는?**

ISNULL은 표현식이 null이면 TRUE(텍스트 필드는 항상 false). ISBLANK는 값이 없으면 TRUE이며 텍스트 필드도 지원. 새 수식에는 ISBLANK 권장.

**Apex 클래스를 예약하려면?**

Schedulable 인터페이스 구현 후 System.schedule(작업명, cron 표현식, 클래스). 한 번에 최대 25개 클래스 예약. 예: `System.schedule('Hourly Sync', '0 0 * * * ?', sch);`

**salesforce.com의 다양한 API는?**

- **REST API:** REST 기반, 모바일·웹에 적합.
- **SOAP API:** SOAP 기반, ERP·금융 시스템 통합에 적합.
- **Chatter API:** Chatter 피드·소셜 데이터 접근 REST API.
- **Bulk API:** REST 기반, 대용량 데이터 비동기 로드/삭제.
- **Metadata API:** 커스터마이징 검색·배포·생성, 샌드박스→운영 마이그레이션.
- **Streaming API:** SOQL 쿼리와 일치하는 데이터 변경 알림 푸시.
- **Apex REST API / Apex SOAP API:** Apex 클래스·메서드를 외부에 노출(OAuth 2.0/Session ID 지원).

**VF 페이지에 오류 메시지를 표시하려면?**

`<apex:pageMessages />` 태그 + 컨트롤러에서 `ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '...'))`.

**Apex 거버너 한도란?**

Apex 런타임 엔진이 공유 멀티테넌트 환경에서 리소스 독점을 막기 위해 적용하는 런타임 한도(메모리, DB 리소스, 스크립트 문 수, 처리 레코드 수). 초과 시 런타임 예외. 모든 인스턴스(체험·개발·운영·샌드박스)에 적용되나 코드 커버리지·테스트는 운영 배포 시에만 강제.

**UI에서 Apex 코드를 작성할 수 있나요?**

Developer Edition, Enterprise 체험, 샌드박스에서만 UI로 가능. 운영에서는 Metadata API deploy, Force.com IDE, Migration Tool로만 변경.

**Apex란?**

salesforce.com의 자체 기술로 Java와 유사한 객체 지향 언어. Salesforce 서버에서 네이티브 실행되어 JavaScript/AJAX보다 강력·빠름. 트리거에 작성 가능(DB 저장 프로시저처럼), 단위 테스트 내장 지원. DML(INSERT/UPDATE/DELETE), 인라인 SOQL/SOSL, 대량 처리 루프, 레코드 잠금 구문 지원. Java와 공통점(클래스·상속·다형성, 컴파일·강타입·트랜잭션)과 차이점(멀티테넌트·거버너 한도, 대소문자 구분 안 함, 온디맨드, 비즈니스 로직 전용, 운영 배포 시 단위 테스트 필수).

**Apex DML 작업이란?**

DB에서 데이터 삽입·업데이트·삭제·복원. 두 형태: DML 문(insert sObject[]) — 오류 시 예외 발생, DML 데이터베이스 메서드(Database.insert()) — 부분 성공 허용.

**관련 오브젝트가 있는 커스텀 오브젝트 리포트의 조건은?**

두 오브젝트 모두 Reports 옵션 활성화, 관계가 Master-Detail이어야 함. 부모가 표준 오브젝트면 해당 섹션에, 둘 다 커스텀이면 "Other Reports" 섹션에 표시.

**Public Site에서 사용자 인증을 제공하려면?**

Customer Portal을 사용해 공개 사이트에 인증 제공.
