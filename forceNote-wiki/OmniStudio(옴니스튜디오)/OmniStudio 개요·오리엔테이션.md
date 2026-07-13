---
tags: [omnistudio, low-code, industries, omniscript, flexcard, datamapper, integration-procedure, overview]
source: help.salesforce.com — OmniStudio (xcloud.os_omnistudio_standard·os_omnistudio_basics·os_omnistudio_landing_page·os_plan_and_prepare·os_omnistudio_for_vlocity·os_omnistudio_naming_conventions·os_omnistudio_sobject_descriptions·os_designers_common·os_omnistudio_limits·os_frequently_asked_questions·os_use_the_applications_together_8249, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [OmniStudio, 옴니스튜디오, OmniStudio 개요, Vlocity, standard vs managed package, OmniProcess, OmniUiCard, OmniDataTransformation, 로우코드, Industries, 네 가지 도구]
---

# OmniStudio 개요·오리엔테이션

> Industry Cloud 앱을 위한 로우코드 스위트 — OmniScript·FlexCard·Data Mapper·Integration Procedure 네 도구와 그 데이터 모델(OmniProcess·OmniUiCard·OmniDataTransformation)을 한눈에 정리하는 시리즈 허브.

---

> [!warning] 이름 혼동 주의 — OmniStudio ≠ Omni-Channel
> **OmniStudio**(이 노트)는 Industry Cloud용 **로우코드 앱 빌더**다 — OmniScript·FlexCard·Data Mapper·Integration Procedure로 가이드형 인터랙션과 UI를 선언적으로 만든다.
> 이는 Service Cloud의 **Omni-Channel**(케이스/작업을 상담원에게 라우팅하는 큐·워크 배분 엔진)과 **완전히 다른 기능**이다. 이름이 비슷해 검색·문서에서 자주 혼동되므로, 라우팅/큐/프레즌스를 찾는다면 Omni-Channel 문서를(이 노트가 아님) 봐야 한다.

---

## OmniStudio란

OmniStudio는 **Industry Cloud 애플리케이션을 만드는 services·components·data model objects의 스위트**다. Salesforce org 데이터와 외부 소스 데이터를 활용해 가이드형 인터랙션(guided interaction)을 만든다. select Industry Cloud 고객에게 제공된다.

> 원문: *"Omnistudio provides a suite of services, components, and data model objects that combine to create Industry Cloud applications. Create guided interactions using data from your Salesforce org and external sources."*

선언적(declarative) 환경으로, 프로그래밍 언어보다 **비즈니스 로직에 집중**하도록 설계됐다. **Lightning Web Component(LWC) 런타임** 위에 구축되어 고성능·간편 배포에 최적화되어 있다. Business Rules Engine 같은 제품과 결합하면 사용자 플로우 안에서 복잡한 로직을 강제할 수 있다.

**OmniStudio로 할 수 있는 것 (원문 4개):**
- Omniscripts로 사용자 인터랙션 로직을 담는다.
- OmniStudio Data Mappers로 Salesforce와 Omniscripts·Flexcards·Integration Procedures 도구 사이에서 데이터를 전송·변환한다.
- Integration Procedures로 서버측 데이터 통합 오퍼레이션을 효율·재사용 목적으로 번들한다.
- Flexcards로 데이터를 표시하고 액션을 실행한다.

---

## 4개 도구 (컴포넌트 맵)

OmniStudio의 핵심은 네 가지 빌딩 블록이다. 각 도구는 특정 sObject로 저장된다.

| 도구 | 역할 | 저장 sObject |
|---|---|---|
| **OmniScript** | 사용자를 복잡한 프로세스로 안내하는 가이드형 인터랙션 로직(fast·personalized·consistent 응답) | Omni Process |
| **FlexCard** | 고객 컨텍스트에 맞는 정보·액션을 표시하는 industry-specific UI 컴포넌트. 선언적 디자인 툴에서 만들어 Lightning/Experience Cloud 페이지에 추가 | Omni Ui Card |
| **Data Mapper** (OmniStudio Data Mapper) | Salesforce와 OmniScript·FlexCard·Integration Procedure 도구 사이의 데이터 전송·변환 | Omni Data Transformation |
| **Integration Procedure** | 서버측 데이터 통합 오퍼레이션을 효율·재사용 목적으로 번들. 보통 하나 이상의 Data Mapper를 호출하며 OmniScript보다 유연·강력 | Omni Process |

> **선택 기준:** OmniScript vs FlexCard는 "목적이 데이터를 **보여주기만** 하는가, 아니면 사용자가 **복잡한 인터랙션**을 요구하는가"로 가른다. 둘 다 UI이며 여러 소스에서 데이터를 끌어오고 인터랙티브할 수 있다. Integration Procedure는 보통 하나 이상의 Data Mapper를 호출하고 OmniScript보다 유연·강력하다. (원문: *"When to Use Flexcards and Omniscripts"*, *"Integration Procedure Features Not in Omniscripts"* 참조)

### Use the Applications Together — 결합 예제

네 도구를 함께 쓴다: OmniScript로 가이드형 인터랙션을 만들고, Data Mapper·Integration Procedure로 데이터를 get/post하고, FlexCard로 데이터를 표시하고 액션을 실행한다.

원문에 실린 예제 흐름:

```text
// 예제 흐름 — Salesforce Help 원문 시나리오 (직접 만든 코드 아님, 서술 재현)
1. 상담원(agent)이 카드(FlexCard)에서 주문 관련 정보·액션을 본다.
2. 카드의 "new order" 링크를 클릭 → OmniScript가 실행되어 상품 구매 가이드 프로세스 시작.
3. OmniScript가 Data Mapper를 사용해 표시할 상품 목록을 가져온다(get).
4. 상담원이 구매할 상품을 하나 이상 선택한다.
5. 구매 프로세스 종료 → OmniScript가 상담원을 Orders 카드가 있는 뷰로 되돌린다.
```

목적 요약: (1) 정보·액션에 컨텍스트 제공(FlexCard), (2) 가이드 프로세스 완료(OmniScript), (3) 프로세스에 맞는 올바른 데이터 조회(Data Mapper).

> 각 도구의 상세 노트는 [[FlexCard]] · [[OmniScript]] · [[Data Mapper (DataRaptor)]] · [[Integration Procedure]] 참조.

---

## Standard vs Managed Package OmniStudio

OmniStudio에는 **standard 런타임+objects** 방식과 **managed package 런타임+custom objects** 방식이 있다. 이 시리즈는 기본적으로 **standard runtime**(standard designer 또는 managed package designer) 기준이며, 동작·옵션 차이는 각 designer 섹션에 명시된다.

| 구분 | Standard OmniStudio | OmniStudio for Managed Packages (구 "Omnistudio for Vlocity") |
|---|---|---|
| 런타임 | standard runtime | managed package runtime |
| 데이터 objects | standard objects | custom objects |
| 권장 대상 | 신규 사용자(기본) | 기존 managed package 사용자 |
| 전용 도구 | (아래 managed 전용 도구 없음) | OmniOut · Calculation procedures/matrices · Tracking service & OmniAnalytics |

> [!important] Summer '25부터 신규 사용자는 패키지 설치 금지
> 원문: *"Starting in Summer '25, if you're a new Omnistudio user, don't install the Omnistudio package."*
> 신규 고객은 **Omnistudio License 활성화만으로** standard designer + standard runtime을 기본 제공받는다. 단, **OmniOut 기능을 쓰려면 여전히 managed package를 설치**해야 한다.

**Managed Package 전용 구성요소·도구 (standard에 없음):**
- 공통 컴포넌트: Omniscripts(인터랙션 로직) · Flexcards(사용자 인터랙션·데이터 툴 그룹) · OmniStudio Data Mappers(데이터 전송) · Integration Procedures(서버측 오퍼레이션 번들)
- **OmniOut** — LWC OmniScript·FlexCard를 서드파티 웹사이트에서 오프-플랫폼 실행
- **Calculation procedures and matrices** — 견적 자동 생성, 일련의 질문으로 고객/상담원 안내, 다양한 소스에서 데이터를 끌어와 맞춤 견적·자격 판정 제시
- **Tracking service 및 OmniAnalytics** — OmniStudio 컴포넌트·이벤트의 사용자 인터랙션·성능 데이터 추적

**신규 vs 기존 고객 정의 (FAQ 원문):**
- **New customers** — Vlocity 패키지(**vlocity_cme, vlocity_ins, vlocity_ps**)를 설치한 적 없고, Omnistudio 패키지나 Omnistudio 라이선스도 활성화되지 않은 고객.
- **Existing customers** — Vlocity 패키지(vlocity_cme, vlocity_ins, vlocity_ps), Omnistudio 패키지를 설치했거나 Omnistudio 라이선스가 활성화된 고객.

---

## 명명 규칙 (Naming Conventions)

OmniStudio 컴포넌트(Data Mapper·FlexCard·Integration Procedure·OmniScript) 생성 시 아래 규칙을 따른다. **Product → sObject → Unique Name** 매핑 전수:

| Product | sObject | Unique Name |
|---|---|---|
| **Integration Procedures** | Omni Process | **Type_SubType** — Type과 SubType을 언더스코어로 연결해 IP 호출에 쓰는 고유 식별자 생성. Type·SubType은 letters·numbers·special characters 가능하나 **공백 불가**. 예: Type=Auto, SubType=CreateUpdateQuote → `Auto_CreateUpdateQuote` |
| **Data Mappers** | Omni Data Transformation | **Interface Name** — Data Mapper Interface Name은 고유해야 하며 letters·numbers·**dashes** 가능, 공백 불가 |
| **Omniscripts** | Omni Process | **TypeSubtypeLanguage** — Type·SubType·Language를 결합해 컴파일된 OmniScript LWC의 이름이 되는 고유 식별자 생성. Type·SubType은 letters·numbers 가능하나 **공백·언더스코어 불가**, **104자 초과 불가**. 예: Type=account, SubType=Create, Language=English → LWC 이름 `accountCreateEnglish` |
| **Flexcards** | Omni Ui Card | **Name + Author** — 카드 Name+Author 조합이 org 내 고유해야 함. Name·Author는 letters·numbers·underscores만 가능, **letter로 시작**, 공백 불가, **언더스코어로 끝나면 안 됨**, **연속 언더스코어 2개 불가** |

**예약어 (Reserved Words)** — FlexCard 이름·element 이름에 사용 금지 (원문 목록 전수):
- Action
- Data-element-label
- Data-action-key
- Data-element-label
- element-label
- Data-action-element-class
- Flyout
- FlyoutType
- Tracking-obj
- Parent-Mergefields

**Metadata API 지원 제약** — Setup의 Omnistudio Settings에서 Omnistudio Metadata API support를 활성화하면, OmniStudio 컴포넌트 이름은 letters·numbers만 가능하고 공백·언더스코어 같은 특수문자 불가. OmniScript는 이름에 특수문자를 포함할 수 있으나, **Type·Subtype·Language의 고유 조합에는 특수문자 불가**. 활성화 후에는 고유 이름에 특수문자가 든 컴포넌트를 만들 수 없다.

---

## sObject 모델

OmniStudio sObjects와 설명, 그리고 고객이 컴포넌트를 보려면 read access를 부여해야 하는 객체(원문 10행 전수):

| sObject | Description | Read Access Required |
|---|---|---|
| Omni UI Card | Flexcards | Yes |
| Omni Process | Omniscripts and Integration Procedures | Yes |
| Omni Process Element | Omniscript elements | Yes |
| Omni Process Compilation | Compiled Integration Procedures and Omniscripts | Yes |
| Omni Electronic Signature Template | DocuSign signature templates used in Omniscripts | No |
| Omni Data Transformation | Omnistudio Data Mappers | Yes |
| Omni Data Transformation Item | Data Mapper metadata | Yes |
| Omni Process Transient Data | Temporarily stored data for Omniscripts' and Integration Procedures' long running processes | No |
| Omniscript Saved Session | Omniscript saved sessions | Yes |
| Omni DataPack | Collection of Omnistudio components and related functionality packaged for deploying objects from one sandbox or dev org to another, such as a production org | No |

> 요약: FlexCard=**Omni UI Card**, OmniScript·IP=**Omni Process**(요소는 Omni Process Element, 컴파일본은 Omni Process Compilation), Data Mapper=**Omni Data Transformation**(항목은 Omni Data Transformation Item). DataPack은 org 간 배포용 컴포넌트 묶음.

---

## Standard Designer

managed package designer 외에, OmniStudio는 standard runtime에서 FlexCard·OmniScript·Integration Procedure·Data Mapper용 **standard designer**를 제공한다. managed package designer의 기존 element·configuration이 모두 standard designer에서 사용 가능하며, 탐색 편의성과 성능이 개선됐다.

**활성화 조건:**
- 신규 사용자 — standard designer가 **기본 활성화**.
- 기존 standard runtime 사용자 — Summer '25 업그레이드 후 standard designer **기본 활성화**.
- Spring '25에 패키지 설치 없이 Omnistudio 라이선스를 활성화한 경우 — Salesforce Customer Support에 요청해야 standard designer 획득. 또는 Summer '25 managed package를 설치하고 관련 Omnistudio 설정을 활성화.

**컴포넌트별 성능 향상 (managed package designer 대비, 원문 수치 전수):**

| 컴포넌트 | standard designer 성능 |
|---|---|
| **FlexCard** | element 캔버스 드래그 **2배** 빠름, 탭 전환 없이 속성 동시 편집. **활성화 최대 7배 빠름** |
| **OmniScript** | 드래그 **2배** 빠름, 탭 전환 없이 속성 동시 편집. **활성화 최대 6배 빠름** |
| **Integration Procedure** | 생성 **최대 2.5배** 빠름, connector로 IP 블록 접근, 드래그 **최대 7배** 빠름 |
| **Data Mapper** | 생성 **최대 6배** 빠름, 설정 손쉬운 접근·객체 간 연결 시각화 |

> [!note] 성능 수치 면책 (원문)
> *"The performance figures in this document are provided for informational purposes only and are based on internal validation and testing under specific conditions."* — 실제 결과는 컴포넌트 설계·운영 환경 등에 따라 다를 수 있으며 성능 보장이 아니다.

**전환 시 주의:** standard designer로 만든 컴포넌트는, **managed package designer로 되돌아가면 조회·편집 불가**(단 런타임에서 참조는 가능). 반대로 standard designer로 이동 후 되돌릴 때는 호환성 차이로 컴포넌트가 올바로 안 열릴 수 있어 **새 버전 생성**이 권장된다. 운영 org 적용 전 **cloned org에서 철저히 테스트**한다.

---

## 한도·FAQ 포인터

**Recommended Limits — 하드 수치 없음, in-UI 메시지로 표면화.** OmniStudio는 Flexcard·OmniScript 사용 중 권장 한도에 **근접·도달·초과하면 OmniStudio UI에 informational/warning 메시지**를 띄운다. 정보/경고 아이콘을 클릭해 상세를 본다. 공식 문서에 구체적 수치표는 노출되지 않으며(*"See Recommended Limits"* 링크로 위임), 최적 성능·유지보수성·확장성을 위해 구현 계획 시 검토하라고 안내한다.

**FAQ 요점 (standard designer 중심):**
- **내 org가 standard/managed 중 무엇인지 확인:** Setup → Quick Find "Omnistudio Settings" → **Managed Package Runtime**·**Managed Package Designer** 설정 확인. 켜져 있으면 해당 런타임/디자이너가 managed package 쪽.
- **standard designer 이점:** 성능·UX 향상, OmniScript·IP·FlexCard **즉시 활성화(instant activation)**, 향상된 리스트 페이지, 전용 Manage Versions 페이지, 직관적 캔버스.
- **미지원 항목:** standard designer에서 **data pack으로 직접 export/import 불가** → Salesforce CLI 사용. **OmniOut 미지원** → managed package 설치 필요.
- **managed로 복귀:** 관리자가 Setup → Omnistudio Settings에서 Managed Package Designer 설정을 다시 On으로 토글. 단 standard designer로 만든 컴포넌트는 호환성 문제로 안 열릴 수 있어 새 버전 생성 권장.

---

## 관련 노트

**OmniStudio 시리즈 형제 노트:**
- [[OmniScript]] — 가이드형 인터랙션 로직 (Omni Process)
- [[FlexCard]] — 데이터 표시·액션 UI 컴포넌트 (Omni Ui Card)
- [[Data Mapper (DataRaptor)]] — 데이터 전송·변환 (Omni Data Transformation)
- [[Integration Procedure]] — 서버측 오퍼레이션 번들 (Omni Process)
- [[OmniStudio 셋업·권한·활성화]] — 라이선스·권한셋·Standard vs Managed Package·활성화
- [[OmniStudio 메타데이터·DataPack 배포]] — 메타데이터 타입·DataPack 마이그레이션·CLI
- [[OmniStudio Formula Functions 레퍼런스]] — OmniScript·FlexCard·IP 공용 수식 함수

**실재 링크:**
- [[Scratch Org Settings 레퍼런스]] — scratch org 정의의 OmniStudioSettings 활성화 등 개발 환경 설정
