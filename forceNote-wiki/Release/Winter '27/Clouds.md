---
tags: [release, winter_27, clouds, sales, service, commerce, data360, analytics, industries]
api_version: v68.0
release_date: 2026-10
created: 2026-08-25
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2)
aliases: [Winter '27 Clouds, 윈터27 클라우드, Agentforce Sales, Agentforce Revenue Management, Agentforce Commerce, Agentforce Contact Center, Partner Contact Center, Service Assistant 동적 서비스 플랜, Knowledge Blocks, Workforce Management, Marketing Cloud Next, Data 360 Engagement Timeline, Loyalty Management Winter 27, Industries Winter 27, 15000 line items, Agentforce IT Service, IT Service Management, ITSM Winter 27, 아이티 서비스, Hardware Asset Management, HAM, IT Asset Management, ITAM, CMDB Service Graph, Dynamic Discovery Splunk, IT Compliance, Employee Services 포털, Broadcast Communications, Incident Owner, Assigned User API 불가, Assigned Group 공개 그룹]
---

# Winter '27 — Clouds (Sales · Revenue · Service · Commerce · Marketing · Analytics · Data 360 · Industries 등)

> Winter '27(v68.0) 클라우드 영역 **988페이지 중 317페이지를 전문 추출**했고 나머지 **671페이지는 제목만** 확보했다 — 이 노트는 두 계층을 **끝까지 분리해** 적는다. 상세 계층의 핵심은 대규모 제품 리브랜드(Sales Cloud→Agentforce Sales 등), Revenue의 15,000 라인 대형 트랜잭션, Service Assistant 동적 서비스 플랜, Workforce Management 전면 확장, **Agentforce IT Service 51페이지 전수**다.

---

## ⚠️ 이 노트의 커버리지 — 두 계층을 섞지 않는다

Winter '27 릴리즈 노트의 Clouds 영역은 **988페이지**다. 이 노트는 그중 일부만 본문까지 확보했다.

| 계층 | 페이지 수 | 이 노트에 실린 것 | 이 노트에 **없는** 것 |
|---|---|---|---|
| **Tier 상세** (전문 추출) | **317** (배치1 133 + 배치2 133 + Agentforce IT Service 51) | 기능 설명 + Where(에디션·라이선스) + How(Setup 경로) + Who(권한 세트) + When(가용 시점) | — |
| **Tier 랜딩요약** (부모 허브가 담은 자식 요약) | **약 229** — 아래 671의 **부분집합**(합계에 따로 더하지 않는다) | **1~3문장 설명뿐.** 리프 페이지는 미추출이지만 **부모 허브 페이지가 자식 요약을 본문에 담고 있어** 그 요약은 확보됐다 — 아래 클라우드별 상세 섹션에 실려 있다 | **Where(에디션·라이선스)·How(Setup 경로)·Who(권한)·When(가용 시점) 전부 없음** |
| **Tier 제목만** (미추출) | **671** | **릴리즈 노트 제목과 page id뿐** (그중 약 229건은 위 랜딩요약도 함께 확보) | 랜딩요약조차 없는 나머지는 본문·에디션·Setup 경로·권한·가용 시점 **전부 없음** |
| 합계 | **988** (317 + 671) | | |

> **"약 229"의 성격:** 원문이 밝힌 수치가 아니라 **이 노트의 상세 섹션 ↔ 카탈로그 page id를 대조해 센 값**이다. 어떤 블록이 랜딩요약 계층인지는 각 섹션에 붙은 **`랜딩 요약(리프 미추출)`** 표시로 판단한다. **Agentforce IT Service 51건은 이 229에 포함되지 않는다** — 이 노트가 그 51건의 랜딩요약을 갖고 있던 적이 없고(허브 요약은 [[Winter '27/Agentforce]] 소관이었다) 지금은 아예 Tier 상세로 올라갔으므로, 제목 계층이 722→671로 줄어도 **229는 그대로다**.

> [!warning] 제목만 있는 항목을 상세 항목처럼 읽지 말 것
> 아래 **클라우드별 상세 섹션**(`## Sales` ~ `## 그 밖의 영역`)의 내용 중 **`랜딩 요약(리프 미추출)`으로 표시되지 않은 것만** Where/How 수준의 근거가 있다. `랜딩 요약` 표시가 붙은 블록은 **부모 허브가 담은 1~3문장 설명뿐**이고 에디션·Setup 경로·권한·가용 시점이 없다. 아래 **`## 제목 카탈로그 — 미추출 671건`** 섹션의 항목은 원칙적으로 *"이런 제목의 변경이 있었다"* 이상을 말하지 않는다 — **단 그중 약 229건은 위 상세 섹션에 랜딩 요약이 함께 실려 있으므로, 카탈로그에서 제목을 찾았으면 상세 섹션도 한 번 찾아보는 편이 낫다.** 카탈로그 항목에 대해 에디션·설정 절차·동작을 추정해 채우지 않았고, 읽는 쪽에서도 추정하면 안 된다. 확인이 필요하면 page id로 원문을 다시 열어야 한다(`https://help.salesforce.com/s/articleView?id=release-notes.<page_id>.htm&language=en_US&release=264&type=5`).
>
> 카탈로그의 제목 일부는 소스 목록에서 `...`로 잘려 있다. **자르지 않고 원문 그대로** 옮겼으므로, `...`로 끝나는 제목은 그 자체가 불완전한 상태다.

### Tier 상세 안에서도 부분 추출인 페이지 4개

전문 추출된 317페이지 중 **아래 4개는 소스 덤프가 앞부분만 담고 절단됐다**(앞 3개는 원문이 너무 길고 반복적이어서, 네 번째는 월별 change log stub 지점에서). 이 노트에서도 전수가 아니다. (**Agentforce IT Service 51페이지는 절단 없이 전수 확보**됐다 — 실패 0·차단 0.)

| page id | 원문 크기 | 상태 |
|---|---|---|
| `rn_feature_impact` — How and When Do Features Become Available? | **85,351자** | 전 제품의 *기능 × 활성화 방식(Enabled for users / for admins / Requires setup / Contact Salesforce)* 매트릭스. **앞부분 약 3,600자만 확보** — 이 노트는 이 매트릭스를 옮기지 않는다. 개별 기능의 활성화 방식이 필요하면 원문을 직접 봐야 한다 |
| `rn_fieldservice_desktop_updates` — Field Service Desktop Monthly Patch Notes | **22,201자** | 월별 개별 버그 수정 목록. **앞부분 약 1,800자만 확보**(아래 Field Service 절에 확인분만 기재) |
| `rn_fieldservice_mobile_patch_notes` — Field Service Mobile Monthly Patch Notes | **17,344자** | 동일. **앞부분 약 1,800자만 확보** |
| `rn_communications_cloud` — Communications (Industries 랜딩) | **≥1,921자** (절단 지점까지만 확인) | 덤프가 `[truncated at ~1,921 chars total; remaining content is the monthly change log stub]` 로 끝난다. **산업 축 요약(Agentforce for Enterprise Quoting · Communications Insights · Enterprise Sales Management · Revenue Cloud for Communications)은 확보**됐고 잘린 나머지는 **Communications Release Note Changes by Month(월별 change log) stub** 이라 기능 정보 손실은 사실상 없다 |

### Agentforce IT Service(`rn_it_*`) 51페이지 — 전수 추출 완료 (구 최대 공백)

**이 51페이지는 더 이상 제목 계층이 아니다.** `rn_it_service_*` 19 + `rn_it_srvcs_*` 32 = **51페이지 전부를 본문까지 추출**해 아래 **`## Agentforce IT Service`** 절에 실었다. 이전 판이 이 자리에 적었던 *"기능 상세는 위키 어디에도 없다"* 는 서술은 **폐기됐다**.

| 구분 | 상태 |
|---|---|
| `rn_agentforce_it` 허브 (9개 하위 섹션 요약) | [[Winter '27/Agentforce]]에 있음 (상위 라우팅 전용) |
| `rn_it_service_*` (19페이지) + `rn_it_srvcs_*` (32페이지) = **51페이지** | **본문 전수(Tier 상세)** — 이 노트 `## Agentforce IT Service` 절 |
| 결론 | **Agentforce IT Service 기능 상세의 단일 출처 = 이 노트의 해당 절** |

> **이 51건이 다른 상세 항목과 다른 점 두 가지:** ① **GA·Beta·Pilot·Developer Preview·Release Update 마커가 51건 전체에 하나도 없다**(원문에 없는 것이지 추출 유실이 아니다). ② **에디션이 id 계열마다 갈린다** — `rn_it_service_*`는 Enterprise·Unlimited·**Developer**, `rn_it_srvcs_*`는 Enterprise·**Performance**·Unlimited(반례 1건). 근거는 해당 절 참조.

---

## 개요 — 상위/형제 라우팅

| 라우팅 | 노트 |
|---|---|
| 상위 허브 | [[Winter '27]] |
| 형제 — 릴리즈 업데이트 | [[Winter '27/Release Updates]] — **강제 적용 시점의 단일 출처**. 이 노트는 Release Update를 "있다"고만 기록하고 날짜를 다시 쓰지 않는다 |
| 형제 — 개발자 | [[Winter '27/Development]] (Apex·LWC·API·Connect REST) |
| 형제 — 플랫폼 | [[Winter '27/Platform]] |
| 형제 — AI 에이전트 | [[Winter '27/Agentforce]] (Agentforce & Generative AI 영역) |
| 직전 릴리즈 | [[Summer '26/Clouds]] · [[Winter '26/Clouds]] |

### 릴리즈 노트 구조 자체의 변경 (Winter '27)

`salesforce_release_notes` 랜딩 페이지가 밝힌 변경이다. 이 노트의 섹션 경계가 [[Winter '26/Clouds]]와 다른 이유이기도 하다.

- **Features Released Monthly 페이지가 없어졌다.** 월별 출시 정보는 각 제품의 **Release Note Changes**로 이동.
- Release Note Changes가 **월별 그룹 + 불릿**으로 재구성됐고, **제품별 Release Note Changes**가 신설됐다(제품 랜딩 페이지에서 확인).
- **섹션 통합:** *Platform* 이 **Customization · Deployment · Development · Experience Cloud · Mobile & Salesforce CMS** 를 흡수했다. 그래서 Clouds 추출 배치에도 Platform 소관 페이지가 섞여 들어왔다(→ 아래 `### Platform·Development로 위임한 항목` 표).

### 제품 리브랜드 — Winter '27에서 확인된 것 전수

이번 릴리즈는 리브랜드가 많다. 원문이 "You may see references to \<옛 이름\>"이라고 밝힌 것만 적는다.

| 옛 이름 | 새 이름 | 원문 근거 |
|---|---|---|
| Sales Cloud | **Agentforce Sales** | *"Sales Cloud is now Agentforce Sales."* |
| Revenue Cloud | **Agentforce Revenue Management** | *"Revenue Cloud is now Agentforce Revenue Management."* |
| Commerce | **Agentforce Commerce** | *"Commerce is now Agentforce Commerce."* |
| Financial Services Cloud | **Agentforce Financial Services** | *"Financial Services Cloud is now Agentforce Financial Services."* |
| Manufacturing Cloud | **Agentforce Manufacturing** | *"Manufacturing Cloud is now Agentforce Manufacturing."* |
| Net Zero Cloud | **Agentforce Net Zero** | *"Net Zero Cloud is now Agentforce Net Zero."* |
| Nonprofit Cloud | **Agentforce Nonprofit** | *"Nonprofit Cloud is now Agentforce Nonprofit."* |
| Education Cloud | **Agentforce Education** | *"Agentforce Education (formerly Education Cloud)"* |
| Salesforce Voice with Telephony Providers (구 Service Cloud Voice) | **Partner Contact Center** | *"Salesforce Voice with Telephony Providers (formerly Service Cloud Voice) is now Partner Contact Center."* |
| Agentforce Lead Nurturing | **Agentforce Engagement** | 2026-08-24부터. *"The new name better describes the range of work the agent can perform."* |
| Messaging for In-App and Web | **Enhanced Chat** | Self Service 절의 괄호 표기 *"Enhanced Chat (formerly Messaging for In-App and Web)"* |
| Global Promotions Management 데이터 킷 | **Real-Time Offer Management** 데이터 킷 | 데이터 킷 **이름만** 변경 |
| Data Cloud | **Data 360** | 2025-10-14부 리브랜드가 계속 유지됨(Winter '27 원문 재확인) |

> 리브랜드는 **표기만** 바뀐다. 원문 공통 문구: *"functionality and content remains unchanged"* / *"You may see references to \<옛 이름\> in our application and documentation."*

### 등급 마커 일람 — 계층별로 분리

**Tier 상세(317p) 안에서 확인된 마커 전수**와, **제목에 마커가 박혀 있어 제목만으로도 등급을 알 수 있는 항목**을 나눠 적는다. 제목 계층 671건 중 마커가 제목에 없는 항목의 등급은 **알 수 없다**. **Agentforce IT Service 51페이지는 본문까지 확보했는데도 마커가 0건**이라 아래 어느 표에도 오르지 않는다 — 그 절의 `### 등급 마커` 항목 참조.

**A. Tier 상세(317p) — 본문까지 확인된 마커**

| 등급 | 항목 | 영역 |
|---|---|---|
| **GA** | Protect Your Work with a Dedicated CRM Analytics Recycle Bin | CRM Analytics |
| **GA** | Boost Win Rates with Request for Proposal Management | Media Cloud |
| **GA** | Reuse Autolaunched Flow Logic Across Your Flexcards | Omnistudio |
| **GA** | Use Complex Template Expressions in Your Lightning Web Components | *(Development 소관 → 위임)* |
| **GA** | Use Third-Party Web Components in LWC (`lwc:external`) | *(Development 소관 → 위임)* |
| **Beta** | Advisements — 위험 탐지 14→**21종** 확대 + 알림 트레이 통지 | Salesforce Overall |
| **Beta** | Work in Arabic in the Field Service Mobile App | Field Service Mobile |
| **Beta** | Optimize Ad Targeting with Data 360 Audience Segments | Media Cloud |
| **Beta** | Request App Installs and Updates From Your Admin | AgentExchange |
| **Beta** | Enhanced Case Merge · Case Merge for Omni-Channel (Case Merge 설정 통합 페이지 안의 두 Beta) | Service — Case Management |
| **Beta** | Setup with Agentforce | Partner Contact Center 설정 전제 |
| **Pilot** | Keep an Audit Trail of Voice Call Record Changes — `VoiceCall` 필드 **최대 20개** 추적 | Voice / Partner Contact Center |
| **Developer Preview** | Customize Components with the SLDS 2 Styling API and Component-Level Hooks | *(Platform 소관 → 위임)* |

> 위 표의 마커는 **이 노트가 실제로 확보한 원문 산문 안에 박혀 있던 것**이다 — 리프 본문에서 온 것도 있고, 부모 허브의 자식 요약 문장(예: Media Cloud 2건은 `rn_media_cloud` 허브 요약의 *"(Generally Available)"* · *"(Beta)"*)에서 온 것도 있다. 어느 쪽이든 **제목 문자열이 아니라 확보한 본문 텍스트가 근거**라는 점에서 아래 A-2·B와 구분된다.

**A-2. 본문 없이 *기능 가용성 매트릭스 행*에서만 확인된 마커**

아래 항목은 **본문(Where/How)이 덤프 어디에도 없다.** 유일한 출처는 `rn_feature_impact`(How and When Do Features Become Available?)의 **매트릭스 행 제목**이며, 이 노트는 위에서 밝혔듯 **그 매트릭스를 옮기지 않는다**. 등급 마커 자체는 행 제목에 박혀 있으므로 유효하지만, **본문까지 확인된 A 표와 구분해 둔다.**

| 등급 | 매트릭스 행 제목 (원문) | page id | 영역 |
|---|---|---|---|
| **Beta** | Preview Records from Lightning Reports Without Losing Context (Beta) | `rn_rd_reports_record_preview` | Reports & Dashboards |
| **Beta** | Embed Lightning Dashboards in Your Lightning Web Runtime Experience Cloud Sites (Beta) | `rn_rd_dashboards_lwr` | Reports & Dashboards |
| **Beta** | Embed Lightning Reports in Your Lightning Web Runtime Experience Cloud Sites (Beta) | `rn_rd_embed_reports_lwr` | Reports & Dashboards |
| **Beta** | Show Only Matching Records Across Blocks in Joined Reports (Beta) | `rn_rd_joined_reports_show_common_rows` | Reports & Dashboards |

> 네 건 모두 **제목 계층(671건)에도 등재**돼 있다. 매트릭스 행이 밝힌 활성화 방식은 이 노트에 옮기지 않았다 — 필요하면 `rn_feature_impact` 원문을 직접 봐야 한다.

**B. Tier 제목만(671p) — 제목에 마커가 있는 항목 전수**

| 등급 | 제목 | page id |
|---|---|---|
| **GA** | Build Targeted Client Lists with Data Model Objects (Generally... | `rn_actionable_list_dmo` |
| **GA** | Enable Field History Tracking for Users | `rn_field_history_tracking_ga` |
| **GA** | Enable Voice-Based Visit Logging | `rn_lsc_customer_engagement_execution_visit_agent` |
| **Beta** | Identify Customer Sentiment in Data 360 Reports | `rn_data360_reports_customer_sentiment` |
| **Beta** | Find the Right Report Type Faster with Improved Report Search | `rn_data360_reports_improved_report_search` |
| **Beta** | Get Data-Driven Recommendations for Campaign Performance | `rn_mc_mi_campaign_performance` |
| **Pilot** | Track Supplier Risk Across Your Multi-Tier Supply Chain | `rn_supply_chain_resiliency_pilot` |
| **Beta 은퇴** | Work Summaries for Case (Beta) Is Being Retired | `rn_work_summaries_case_beta_retirement` |

> 나머지 **657건의 등급은 미상**이다(제목 계층이 722→671로 줄면서 708에서 51 감소 — 빠져나간 51건은 위 어느 마커 표에도 없던 항목이다). 제목에 마커가 없다고 GA인 것도 아니고 Beta가 아닌 것도 아니다.

### 구조 맵

```text
// 구조 예시 — 실제 동작 코드 아님 (Winter '27 Clouds 영역 커버리지 지도)
Winter '27 Clouds 영역 (988 페이지)
├── Tier 상세 317p ─ 이 노트의 "## <클라우드>" 섹션들
│   ├── Sales            Revenue          Service(+FieldService·Voice·Knowledge)
│   ├── Commerce         Marketing        Analytics         Data 360
│   ├── Industries       MuleSoft         Slack             Loyalty·RTOM·Referral
│   ├── 기타(Partner Cloud·AgentExchange·Suites·Scheduler·Advisements)
│   └── Agentforce IT Service(rn_it_* 51p, 허브 9 + 리프 42)
│
├── Tier 제목만 671p ─ 이 노트의 "## 제목 카탈로그" 섹션
│   └── rn_it_* 51p는 여기서 빠져나가 Tier 상세로 이동 (2026-08 추출 완료)
│
└── 소관 밖(위임)
    ├── Release Update 강제 시점 ......... [[Winter '27/Release Updates]]
    ├── Apex·LWC·Connect REST·External Services  [[Winter '27/Development]]
    ├── SLDS·Lightning App Builder·권한/공유·라이선싱  [[Winter '27/Platform]]
    └── Agentforce & Generative AI 영역 ... [[Winter '27/Agentforce]]
```

### Platform·Development로 위임한 항목

Clouds 추출 배치에 섞여 들어왔지만 **이 노트 소관이 아닌** 페이지들이다(위 "섹션 통합" 참조). 여기서는 **한 줄 포인터만** 남기고 메커니즘을 다시 서술하지 않는다.

| 배치에서 나온 항목 | 소관 |
|---|---|
| Lightning Components(LWC API v68.0 · 복합 템플릿 표현식 GA · `lwc:external` GA · `lightning/platformNavigationItemApi` · state manager `refresh()` · LWC Skills) | [[Winter '27/Development]] |
| Connect REST API(Winter '27부터 릴리즈 노트가 Connect REST API Developer Guide로 이동) · ConnectApi 신규/변경 클래스·enum | [[Winter '27/Development]] |
| External Services `schema: {}` any type 지원 | [[Winter '27/Development]] |
| Scalability(Scale Test·Scale Center·ApexGuru) | [[Winter '27/Development]] |
| Platform Licensing·Digital Wallet(Unified Employee License 커스텀 오브젝트 제한 등) | [[Winter '27/Development]] |
| Experience Cloud(커스텀 도메인 target host name · Aura/LWR · 게스트 사용자 민감 필드 숨김) | [[Winter '27/Development]] |
| CRM Analytics REST API 리소스·요청/응답 바디 변경 | [[Winter '27/Development]] |
| Permissions and Sharing(수동 공유 유지 · Profile Filtering · 공유 재계산 비동기화) | [[Winter '27/Platform]] · [[Winter '27/Release Updates]] |
| Salesforce Lightning Design System(SLDS 2 Styling API Developer Preview · 컴포넌트 블루프린트 접근성 수정 · SLDS AI Skills) | [[Winter '27/Platform]] |
| Lightning App Builder(Dynamic Highlights Panel의 Follow 버튼) | [[Winter '27/Platform]] |
| Globalization(12개 언어 라벨 번역 갱신 · ICU 로케일 Release Update) | [[Winter '27/Platform]] · [[Winter '27/Release Updates]] |
| Salesforce Functions 은퇴(신규 구매·갱신 불가) | [[Winter '27/Platform]] |
| Enterprise Messaging(CDC · Event Bus · Platform Events 변경) | [[Winter '27/Platform]] |

---

## Sales (Agentforce Sales)

> *"Sales Cloud is now Agentforce Sales. … Sales features are released as often as monthly."* Winter '27 Sales의 축은 ① 에이전트 3종(Engagement·Prospecting·Sales Management)의 **새 Agentforce Builder(Agent Script) 이관**, ② Sales Workspace 시그널 확장, ③ **이메일 도메인 검증 체계 전면 정비**와 Microsoft EWS→Graph 이관·레거시 제품 은퇴다.

### AI Agents for Sales

| 항목 | 등급 | 내용 |
|---|---|---|
| **Agentforce Lead Nurturing → Agentforce Engagement 개명** | — | **2026-08-24부터.** Enterprise·Performance·Unlimited + Sales Cloud + **Agentforce Engagement 애드온**. 에이전트 설정은 데스크톱 사이트에서만. 전파에 시간이 걸려 옛 이름이 일부 화면에 남는다 |
| **Create More Flexible Engagement Agents with the New AgentForce Builder** | — | **2026-08-24부터.** Setup의 Agentforce Builder에서 **New Agent 버튼이 2026-07-13에 제거**됐다. 새 빌더는 **Agentforce Studio 앱** 안에 있고 **Agent Script 기반** |
| **Exert Greater Control over Manual Review of Lead Nurturing Emails** | — | **2026-07-13부터.** 검토 대상을 *전체 이메일 / 최초 아웃리치만 / 커스텀 플로우로 레코드 기준 지정* 중 선택 |

**새 빌더 전환 시 이동한 설정 (원문 그대로):** Salesforce Go의 가이드 설정이 여전히 Engagement 에이전트 관리의 **주 위치**다(생성·활성화, 지시문·아웃리치·가드레일 구성, 버전 빌드/편집). 다만 Agent Script 기반 **새 Engagement 템플릿**으로 만든 에이전트는

- **Send as Seller**, **Require Manual Approval** → 에이전트 생성 **후** 에이전트 상세의 **Cadence Settings** 섹션으로 이동(이전엔 Salesforce Go의 가이드 구성에 있었다)
- **Agent Working Hours** → **Cadence Settings** 섹션
- 테스트 → **Agentforce Studio 앱 → Tests 탭**

**Engagement (Legacy) 템플릿**(구 Lead Nurturing)으로 만든 에이전트는 여전히 **모듈형 서브에이전트·액션·프롬프트 템플릿** 기반이며, 심화 커스터마이즈는 **Setup의 옛 Agentforce Builder**에서 한다. Salesforce Go에서 두 템플릿 중 선택 가능.

### Agentforce Prospecting (4건 — 모두 2026년 8월 중순부터)

에디션 공통: Enterprise·Performance·Unlimited·Developer + **Agentforce for Sales 또는 Agentforce for an Industry 애드온**, 또는 Agentforce 1 Sales/Industry 에디션. **액션 사용에는 사용자별 애드온이 필요**하다.

| 항목 | How |
|---|---|
| **Automate When Your Prospecting Agent Runs** | Assign Prospects 페이지 → *Distribute equally amongst sales reps* 선택 → rep별 최대 오픈 프로스펙트 수, 실행 주기·요일·시각 입력 |
| **Prioritize Prospects with Recent Engagements** | 최근 **12개월** 내 상호작용 컨택을 부스트. Add Sources 페이지 → Advanced Settings → *Boost Contacts with Past Engagement* → 대상 engagement 레벨 선택 |
| **Select Additional Users for Prospecting** | Assign Prospects → Advanced Prospecting Settings에서 비-prospecting 사용자 소유 계정을 조사 대상으로 지정 → *Route Prospects from Unassigned Accounts* 에서 수신 prospecting 사용자 지정 |
| **View Prospecting Agent Activity** | Prospecting 페이지 **Agent Activity 탭**. 세션별로 에이전트가 검색한 레코드 수와 적격/부적격 판정 사유까지 확인. 이전엔 노출된 프로스펙트만 보였다 |

### Agentforce Sales Management

**Set Up Pipeline Management Faster with the Pipeline Management Configuration Skill** — 자연어 프롬프트로 Agentforce Pipeline Management 설정을 대신 수행하는 **구성 스킬**.

- **Where:** Enterprise·Performance·Unlimited·Developer + Agentforce for Sales 애드온, Agentforce 1 Sales 에디션
- **Who:** 관리자 — *View Setup and Modify Metadata* · *Manage AI Agents* · *Manage Agentforce Employee Agents* · *Assign Permission Sets*. 영업 담당 — Pipeline Inspection 접근 권한
- **How:** 공개 Git 저장소의 **`sales-agentforce-pipeline-management-configure`** 스킬을 AI 코딩 어시스턴트에서 호출. 예: *"Configure Agentforce Pipeline Management for my Sales org for Next Step and Risk fields."*
- rep이 Pipeline Inspection에서 제안을 검토·승인하거나, 관리자가 **autonomous 모드**를 켜면 에이전트가 직접 적용

### Sales Fundamentals — Sales Workspace 시그널

공통 Where: **Enterprise·Unlimited·Agentforce 1 Sales** 에디션 + **Sales Foundation 애드온**.

| 항목 | How |
|---|---|
| **Show Custom Signals** | Flow/Apex로 recommendation 레코드를 쓰고 액션을 연결한 뒤 signal definition 활성화. Setup → *Workspace Signals* → Create Signal Types |
| **Open Agentforce Assist from Sales Workspace Recommendations** | Agent Quick Action 생성 후 **Sales Workspace Actions** 설정 페이지에서 시그널 타입에 배정 |
| **Spot Escalated Cases That Put Deals and Accounts at Risk** | 중요 opportunity·북마크된 account에 연결된 **에스컬레이션된 오픈 케이스**를 우선 시그널로 표시. All Signals 섹션에서 확인, **Post in Slack** 으로 공유 |
| **Report On Actions Taken and Dismissed in Sales Workspace** | **90일 보존 기간** 동안 시그널 타입별 실행/무시 집계. Administrative Reports의 **Home Page Recommendations** 리포트 타입, 또는 Prioritized Recommendation + Prioritized Recommendation Item 커스텀 리포트 타입 |

### Call Coaching · Sales Engagement · Forecasting

| 항목 | 내용 |
|---|---|
| **Use Call Coaching on Video Calls** | **Einstein Conversation Insights 필수**. Enterprise·Performance·Unlimited·Agentforce 1 Sales. 비디오 콜 레코드의 **Coaching 탭**에서 역량별 평가·검토 노트 확인. Salesforce Go → Features → **Agentforce for Sales** 페이지에서 Call Coaching 활성화 → 역량(competency) 선택·커스터마이즈. **활성 역량 최대 8개.** Agentforce for Sales가 있으면 코칭 에이전트가 자동 평가하고, 없으면 **3점 척도 수동 평가**(제출 후 수정 불가). **Agentforce for Sales가 있는 조직에서는 수동 평가가 불가** |
| **View Updated Sales Engagement Data** | **2026년 7월 중순부터.** Sales Engagement 데이터가 Salesforce 플랫폼에 **네이티브 저장**된다. 리포트는 *Sample Sales Reports* 폴더, 대시보드는 **Sales Engagement Sample Dashboard** |
| **Sales Engagement Performance Dashboard 은퇴** | **2026년 11월** 은퇴 예정. Sales Engagement Sample Dashboard로 이전 |
| **Review Deal Risks and Activity Trends in Pipeline Forecasting** | Enterprise·Performance·Unlimited. Opportunities 리스트에서 **에이전트 활동·딜 리스크 경보·활동 히트맵** 컬럼 선택 |
| **Assess Deal Health More Accurately with Enhanced Opportunity Scoring** | **Data 360 AI 모델** 기반. 표준 opportunity 필드에 더해 **실제 대화 데이터·인게이지먼트 시그널**을 반영. Performance·Unlimited + Sales Cloud, **Enterprise는 Agentforce 또는 Revenue Intelligence 애드온 필요**. Salesforce Go → Opportunity Score |

### Email·Calendar — 이메일 도메인 검증 체계 정비

Winter '27 Sales에서 분량이 가장 큰 축이다. 원문 논리: Salesforce는 **사용자 수준 + 도메인 수준** 이메일 검증을 모두 요구하고, 도메인 검증은 **활성 DKIM 키 또는 검증된 Authorized Email Domain**으로 한다. 반환 이메일 주소를 따로 설정했다면 **그 주소와 도메인도** 검증 대상이다. 모든 요건이 충족돼야 Salesforce가 그 사용자 주소로 메일을 보낸다.

| 항목 | 내용 |
|---|---|
| **Track Email Address Verification Across User Domains** | Database.com 제외 전 에디션. Setup → **User Email Domains** → **List Domains** 로 활성 사용자 이메일·반환 주소의 도메인 목록과 **검증/미검증 주소 수**를 채운다 |
| **Set the From Address for Email Sent for Users with Unverified Domains** | Salesforce Free Suite·Database.com 제외 전 에디션. **Summer '26 후반**에 최초 릴리즈. Setup → Deliverability → *Use a substitute email address for unverified domains* → **Substitute Email Address** 로 조직 전체 이메일 주소 선택. 목록에 뜨려면 **도메인 검증 + 주소 검증 + "Allow All Profiles to Use this From Address" 활성화** 세 조건을 모두 만족해야 한다. 미선택 시 `email@UniqueId.sfcustomeremail.com`(UniqueId = Experience Cloud 사이트 ID 또는 조직 ID)으로 발송 |
| **Import Authorized Email Domains into a Sandbox** | **Summer '26 후반** 최초 릴리즈. 프로덕션에서 도메인 편집 → **Allow copy to sandbox** 체크 → 샌드박스의 Authorized Email Domains 페이지에서 **Import from Production** 1클릭. **DKIM 키는 샌드박스로 복사할 수 없다**(서명 보안 유지). DKIM을 쓴다면 샌드박스에서 substitute 주소 설정을 켜거나, 프로덕션에 authorized email domain을 따로 만들어 둔다 |
| **Specify Which Email Domains Require Address Verification** | 도메인별로 *Always / For Updated Addresses Only / Never* 선택. Setup → Authorized Email Domains → Edit → **Require Address Verification to Send Email**. 대상은 사용자 이메일·사용자 반환 이메일·**공유 이메일 주소**(조직 전체 주소, Email-to-Case 라우팅 주소, Experience Cloud 사이트 발신 주소). **Never를 하나라도 선택하면** 사칭 방지를 위해 이메일 주소 수정이 **Manage Users 또는 Modify All Data 권한 보유자로 제한**된다. 로그인·계정 검증에는 영향 없다 |
| **Maintain Your Email Verification Exception (Release Update)** | 과거 Salesforce 고객지원을 통해 사용자 이메일 검증을 껐다면 **authorized email domain 설정으로 예외를 유지**해야 한다. 적용 시 기존 도메인 allowlist가 제거된다. **강제 시점 → [[Winter '27/Release Updates]]** |
| **Adopt Authorized Email Domains (Release Update)** | **취소됨.** 위 *Maintain Your Email Verification Exception* 로 대체 |

### Einstein Activity Capture · Lightning Sync · Inbox · Outlook

| 항목 | 내용 |
|---|---|
| **Fine-Tune Which Emails and Events to Exclude from EAC** | Starter/Pro Suite·Professional·Enterprise·Unlimited·Einstein 1 Sales·Agentforce 1 Sales(+ Einstein for Sales·Sales Engagement·Revenue Intelligence 애드온). **키워드 제외**(단어·구·정규식) → Settings → *Don't Capture Sensitive Emails* → Manage → Add. **도메인 제외는 와일드카드 규칙** → Settings → *Excluded Addresses*. 이전엔 이메일은 민감정보 탐지만, 도메인은 완전일치만 지원 |
| **Manage Stakeholder Details and Connections in Relationship Maps** | Enterprise·Performance·Unlimited + Sales, Agentforce 1 Sales. 사이드 패널에서 **Opportunity Contact Role·부서·노트**를 직접 편집, 연결 제거(맵에서만 제거 / 완전 제거 선택), 제거한 컨택 복원 |
| **Connect Partner Portal Users' Calendars with EAC** | **PartnerEAC 애드온 라이선스** 필요, 파트너 포털 사용자에게 **PartnerEACUser 권한 세트** 배정. EAC에 Partner EAC 구성 생성 후 사용자 배정 → 파트너가 Google·Microsoft 365 계정 연결 → EAC가 OAuth 토큰을 안전 보관 → **Salesforce Scheduler가 예약 시 온디맨드로 토큰을 조회해 가용성 확인** |
| **Upgrade Microsoft 365 Authentication in EAC to Microsoft Graph** | **2026년 2월부터** 제공. Microsoft가 **2026년 10월 EWS 종료**. Azure 관리자가 Graph 동의를 부여한 뒤 업그레이드 도구로 연결 승인. **User-Level OAuth 구성이면 사용자가 직접 재연결**해야 한다. **Spring '26 이후 신규 설정은 자동으로 Graph 인증** |
| **Prepare for Activity 360 Reporting / Activity Metrics / Activities Analytics Dashboard Retirement** | Summer '25부터 EAC가 이메일을 **Task·EmailMessage 레코드로 동기화·저장**할 수 있다. 은퇴 대상 오브젝트: **UnifiedEmail, UnifiedEmailParticipant, UnifiedMeeting, UnifiedMeetingParticipant, UnifiedTask, UnifiedTaskParticipant**. 영향 범위에 **Prospecting Center·Pipeline Inspection·Einstein Conversation Insights**가 포함된다. Setup의 **Update & Migrate** 로 *Sync Email as Salesforce Activity* 를 켠다(Summer '25 이후 EAC를 켠 조직은 기본 활성) |
| **Lightning Sync — EWS→Graph (2026년 10월 전)** | Professional·Enterprise·Performance·Unlimited·Developer. **org-wide OAuth 2.0 + EWS** 로 Microsoft 365/Exchange 서비스 계정에 연결한 구성이 대상. Setup → **Outlook Integration And Sync** |
| **Lightning Sync 은퇴 (2027)** | EAC로 마이그레이션. Setup의 **Lightning Sync 마이그레이션 도구** → EAC 권한 세트 라이선스 배정 → 활성 EAC 구성 소속 확인 → Lightning Sync 끄기. **EWS 인증 상태로는 마이그레이션 불가 — Graph로 먼저 업그레이드**. 라이선스 부족 등 예외 조직은 마이그레이션 도구가 Setup에 나타나지 않는다 |
| **Salesforce for Outlook 은퇴 (2027년 12월)** | Contact Manager·Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. 은퇴 후 컨택·이벤트·태스크 동기화 중단, **사이드 패널 등 기능 접근 상실**. 대체: Outlook integration + Einstein Activity Capture |
| **Upgrade Microsoft 365 Authentication in Inbox to Microsoft Graph** | 전 에디션. **2026년 2월부터**. **사용자가 Microsoft 365 계정에 재연결해야 전환 완료.** Spring '26 이후 신규 Inbox 설정은 자동 Graph |

### Other Changes in Sales

- **Salesforce to Salesforce Is Being Retired (Release Update)** — 권장 대체 솔루션 4종: **Partner Cloud · Data Cloud One · MuleSoft Anypoint · MuleSoft for Flow**. **은퇴/강제 시점 → [[Winter '27/Release Updates]]**

### ⭐ 대표 신기능
1. **Agentforce Engagement 개명 + Agent Script 기반 새 Agentforce Builder 이관** (Setup의 New Agent 버튼 제거).
2. **이메일 도메인 검증 체계 정비 4종** (User Email Domains 페이지 · substitute From 주소 · 샌드박스 도메인 임포트 · 도메인별 검증 요구 수준).
3. **Microsoft EWS→Graph 대이동**(EAC·Lightning Sync·Inbox) + Lightning Sync/Salesforce for Outlook 은퇴 예고.

---

## Revenue (Agentforce Revenue Management)

> *"Revenue Cloud is now Agentforce Revenue Management."* Winter '27 Revenue의 단일 최대 테마는 **대형 트랜잭션 — 라인 아이템 15,000건**이다. 그 밖에 **Promotions 신규 도입**, Billing의 주간 청구·catch-up bill run·Billing Forecast, Advanced Approvals의 위임·기밀 검토가 있다.

### Revenue 랜딩 페이지가 제시한 축 (원문 전수)

| 축 | 원문 요약 |
|---|---|
| **Salesforce Go 설정** | Setup 한 곳에서 Revenue Management 기능 발견·설정. 이번 릴리즈에 **high tech order orchestration** 사전 구축 템플릿 추가. Billing의 Invoice Management·Tax Calculation·Invoice Document Delivery·**Accounting Sub-Ledger for Accounts Receivables** 를 가이드 설정으로 구성 |
| **Promotions in Revenue Management** | 가격 설계자가 프로모션을 만들고 사용자가 트랜잭션에 적용. 개발자는 오브젝트·API로 관리 |
| **Large Transactions and Quote Processing** | 라인 아이템 **최대 15,000건**을 타임아웃·성능 병목 없이 처리. 계산·동기화·문서 생성이 백그라운드 비동기 |
| **Product Catalog Management** | 레벨 간 속성 표시 순서 지정, 레코드 생성 없이 단순 제품→번들 전환, 톱니 아이콘을 텍스트 버튼으로 교체, Add 버튼 숨김, 캐시 무효화 자동화, 정가(list price) 캐싱, **Product Name·Product Code·Product SKU 부분/접두 검색** |
| **Salesforce Pricing** | 램프 딜 세그먼트 **복리(compound) 상승**, 클라우드별 pricing recipe·procedure, 재사용 list variable, **주(weekly) 단위 proration**, 가격 API 응답의 표준 십진 표기 |
| **Product Configurator** | 제약 충족 시 지정 속성·관계를 변경하지 않도록 보호, 자식 제품 수량을 **번들 인스턴스 단위**로 계산 |
| **Transaction Management** | 산업별 procedure plan, 자산 트랜잭션 소급 적용, 자산 라이프사이클 타임존 정확성, 가격 개정(price amendment), STLE 필터·자동 갱신·액션 버튼 구성, **Dynamic Forms** |
| **Ramp Deals** | 복리 가격 상승 + 수정·갱신·취소 소급 적용 |
| **Advanced Approvals** | 그룹/큐 전 활성 멤버에게 Slack DM·채널 알림, **Advanced Approval Delegation**, 다단계 승인에서 검토자 가시성 제한 |
| **Dynamic Revenue Orchestrator** | 램프 딜 오케스트레이션, 수정·갱신·취소 제출과 발효 전 롤백, **time-aware asset**, 램프 세그먼트 staged assetization, 기간별 다년 단계 순서화, **custom fulfillment scope**, fulfillment workspace 복제, 강화된 **Decomposition Viewer** |
| **Usage Management** | 사용량 구독 갱신 시점 조정 — 사업 확장 시 조기 갱신, 만료 후 서비스 복원. 표준·램프 요금 스케줄 모두에서 요율·부여 수량 조정하되 **asset continuity 유지** |
| **Billing** | 주간 청구, 신규 판매 램프 상세, 수정 중 청구 주기 변경, catch-up bill run, billing forecast, 수금 추적·시각화, 셀프서비스 디지털 지갑·지역 결제수단·LWR 컴포넌트·결제 대사·크레딧 잔액 환불, **Revenue Standard Tax Engine 확장**, **Checkout API** |
| **Salesforce Contracts** | **document playbook** 으로 기존 가이드라인·규칙을 반입, 레드라인 계약의 가이드라인 이탈 **리스크 분석**, 런타임 사용자 권한 요구 축소, 문서 봉투 수신자 서명 진행 추적, **Government Cloud 환경 지원**, clause library의 조항을 **Quote Special Terms** 로 견적에 추가 |
| **Salesforce Document Generation** | 재사용 가능한 clause. Clause Library는 **merge token·placeholder token 모두** 지원, **Quote Special Terms는 placeholder token만**. 템플릿에서 clause를 참조하면 내용 변경이 자동 반영. Word 문서에서 **rich text 표 서식 유지**(가격표·비교표·데이터 요약) |
| **Agentforce for Revenue Management** | **Approval Agent** |

### Large Transactions and Quote Processing — 숫자 전수

> 원문: *"Process quotes and orders with up to **15,000 line items** without timeouts or performance bottlenecks."*

| 항목 | 숫자·조건 |
|---|---|
| **Sync Large Quotes to Opportunities Without Interruption** | **15,000 라인**까지 비동기 동기화. **Revenue Settings**에서 표준·대형 견적 양쪽에 대해 활성화 |
| **Recover Faster from Quote and Order Calculation Errors** | 개선된 배칭 알고리즘 + 중첩 라인 아이템 지원. **REST API로 멈춘 계산 상태를 수동으로 Failed로 변경**해 재시도 |
| **Speed Up Large Quote Operations with Automatic Context Reuse** | 트랜잭션당 **단일 세션 컨텍스트** 재사용. **대형 트랜잭션에 자동 적용 — 설정 불필요** |
| **Generate Documents for Quotes with 15,000 Line Items** | CLM Document Generation이 **15,000 라인 아이템 · 1,000 번들 · 중첩 그룹핑 5단계** 까지 지원 |
| **Transform Context Data in Large Transactions** | 대형 트랜잭션의 컨텍스트 데이터에 **Data Processing Engine(DPE) transform** 적용. 이전엔 Context Service의 DPE 기반 transform이 **표준 트랜잭션에서만** 가능했다 |
| **Apply Configuration Rules Across 15,000 Line Items** | 규칙·제약을 **15,000 라인**까지 적용 |
| **Price Quotes and Orders with Up to 15,000 Lines** | 가격 계산 상한이 **기존 1,000 라인 → 15,000 라인**. 대형/표준 트랜잭션에 서로 다른 가격 기능이 필요하면 **pricing procedure를 분리 구성** |

### Product Configurator

| 항목 | 내용 |
|---|---|
| **Prevent Constraint Conflicts When Sharing Attributes and Relations** | 제약(constraint) 수준에서 **`guardrails` 애노테이션**으로 보호 대상을 정의. 개별 속성·관계마다 걸지 않으므로 같은 요소를 공유하는 다른 제약과 충돌하지 않는다 |
| **Enforce Per-Bundle Product Requirements Regardless of Order Size** | **Revenue Settings에서 Instance Quantity를 켜면** 제약 엔진이 **번들 인스턴스당 수량**으로 검증한다. 이전엔 여러 번들 주문 시 **전 번들 합산 최종 수량**으로 검증해 규칙이 실패했다 |
| **Let Constraint Rules Assign Child Product Quantities in Bundles** | **Constraint Instance Quantity** 설정이 자식 제품 인스턴스 수량을 자동 계산하도록 지시. constraint model relationship에 **`allowQuantityChange` 애노테이션**을 붙이면 제약 규칙이 자식 제품의 인스턴스 수량을 **직접 쓸 수** 있다(예: 부모 속성 기반으로 자식 수량 결정) |
| **Updates in Default Product Configurator Flow** | 기본 플로우에 신규 속성 추가. **Winter '27 이전에 복제한 플로우는 신규 속성을 수동 매핑**하거나 기본 플로우를 다시 복제해 커스터마이즈를 재적용해야 한다 |
| **Changed Object / Changed Connect REST API** | `ProductConfigurationFlow` 오브젝트 변경. Configuration API가 **Configurator 화면에 필요한 필드만** 지정해 반환하도록 축소 가능 |
| **Optimize Performance for Revenue Management (Release Update)** | Configuration API 처리 속도 최적화. **샌드박스에서 test run**으로 기존 설정과의 호환 확인 권장. **Winter '27부터 이용 가능 — 강제 시점 → [[Winter '27/Release Updates]]** |

### Transaction Management

| 항목 | 내용 |
|---|---|
| **Limit a Procedure Plan to a Specific Industry** | 신규 **Subtype 필드**로 procedure plan의 적용 산업/버티컬을 지정. Life Sciences·Commerce procedure plan 구성 시 **해당 산업용 pricing procedure만** 추가 가능 |
| **Gain Transaction Flexibility with Backdated Asset Changes** | 표준·램프 자산의 **amendment·cancellation·renewal**에 과거 발효일 적용 가능. **transfer·swap은 표준 자산만** |
| **Maintain Time Zone Accuracy for Asset Lifecycle Changes** | **Time Zone이 자산에 저장**되어 amendment·renewal·cancellation 트랜잭션에 전파. 시작·종료일이 자산 원래 로컬 타임존 기준으로 유지 |
| **Gain Pricing Flexibility with Price Amendments** | 수량·속성·번들 구성을 건드리지 않고 **견적 라인의 sales price / 주문 라인의 unit price** 만 갱신 |
| **Accelerate Transaction Updates with Advanced Filters** | 제품명·커스텀 필드·관련 레코드 필드로 견적·주문 라인 필터링 |
| **Edit Accurate Quotes and Orders in STLE with Autorefresh** | 커스텀 플로우·Apex 트리거·Agentforce 액션이 견적/주문을 바꾸면 **Sales Transaction Line Editor(STLE)와 Transaction Summary가 자동 갱신**. Refresh 탭의 STLE 재로딩 신뢰성 개선 |
| **Organize STLE Actions into Button Groups** | 텍스트 박스 대신 **시각적 관리자 UI**. 액션을 버튼 그룹으로 묶고 그룹별 노출 개수 지정. **그룹 10개가 노출되고 나머지는 오버플로 메뉴**. 기존 텍스트 박스 설정은 자동 이관 |
| **Build Focused Quote Line Item and Order Product Pages with Dynamic Forms** | quote line item·order product 레코드 페이지를 **Dynamic Forms**로 업그레이드. 이전엔 이 두 오브젝트가 **페이지 레이아웃만** 지원했다 |
| **Changed Connect REST API** | 강화된 **Read Sales Transaction API** — 사용 가능한 배치를 조회한 뒤 필요한 배치만 **병렬** 조회 |
| **New Invocable Action** | quote line item → opportunity line item 동기화(**단방향**, 역방향 아님). **Revenue Settings에서 Asynchronous Opportunity Sync를 켜야** 플로우·자동화에서 사용 가능 |

### Ramp Deals

- **Backdate Amendments, Renewals, and Cancellations for Ramp Deals** — 램프 자산의 수정·갱신·취소에 **과거 발효일** 지정. 이전엔 오늘 이후만 가능해 과거 기간 청구를 Salesforce에서 정정할 수 없었다.
- **Apply Compound Price Uplifts to Multiyear Ramp Deals** — **standard uplift** = 매 세그먼트에 **원 정가(list price)** 기준 고정 비율 적용. **compound uplift** = 각 세그먼트 가격을 **직전 세그먼트의 net price** 위에 쌓아 기업 계약의 연간 escalation 패턴에 맞춘다.

### Advanced Approvals

| 항목 | 내용 |
|---|---|
| **Extend Slack Approval Notifications to Group and Queue Members** | 배정된 그룹·큐의 **모든 활성 멤버**가 승인 요청 DM을 받는다. 채널 게시도 구성 가능. **Dynamic Approval Notifications를 켜면 DM에 AI 생성 요약 포함**. 이전엔 그룹·큐 배정 승인 단계가 Slack 알림을 아예 생성하지 않았다 |
| **Keep Approval Workflows Moving with Advanced Approval Delegation** | 검토자가 **approval delegation 레코드**를 만들어 사용자·그룹·큐에 기간 한정 또는 무기한 위임. **Advanced Approval Delegation을 켜면 검토자 사용자 레코드에 설정된 기존 위임은 더 이상 적용되지 않는다** — 검토자가 위임 레코드를 새로 만들어야 한다 |
| **Limit Approval Work Item Visibility** | 공유 모델을 **private**으로 설정해 단계별 work item 가시성을 승인 제출과 **독립적으로** 통제. 기본값은 승인 제출 접근 권한이 **연결된 모든 work item으로 확장**되는 것. 다른 사용자·그룹에 읽기 권한을 주려면 **approval work item 오브젝트에 criteria-based sharing rule** 생성 |
| **New Objects in Advanced Approvals** | 신규 오브젝트 추가(목록은 미추출 리프 소관 — `rn_adv_approvals_new_changed_objects`) |

### Billing

| 영역 | 내용 |
|---|---|
| **Customer 360** | ① **Visualize Billing Schedule Lifecycles with Timelines** — Billing Schedule Group 페이지의 타임라인 뷰로 청구 주기·금액·상태·마일스톤 추적 ② **Prioritize Collections with Invoice Aging Summaries on Accounts** — Account 페이지의 **Invoice Aging 컴포넌트**가 계정별 총/오픈/연체 인보이스와 **평균·최대 경과일** 표시 ③ **Review All Impacted Split Invoices** — Invoice 페이지의 **Split Invoices 탭**이 계정을 가로질러 연결된 인보이스를 모두 표시하고, 한 건에 대한 posting·voiding·deleting이 **연결된 전체에 동일 적용**된다 |
| **Billing Schedules and Billing Arrangements** | 기존 구독·주문의 청구 주기 변경, **주간 청구** 및 더 긴 커스텀 간격, 미래 일자 정지(suspension) 기간 요금 스킵, 신규 판매 램프 딜의 **ramp segment 식별자**를 billing schedule에 노출, 다년 램프 딜 가격 상승 자동 계산 |
| **Invoice Management** | ① **Generate Invoices Across Accounts for Owned and Billed Charges** — 계정 수준의 Generate Invoices·Preview Invoices·Invoice Scheduler가 **billing arrangement에서 그 계정을 billing account로 지정한 모든 billing schedule group**을 대상으로 실행. **기본적으로 owned + billed 그룹을 모두 포함**하며, 타 계정이 소유한 요금의 split invoice도 포함. 이전엔 **계정이 소유한 그룹만** 처리했다 ② **catch-up bill run** — 외부 시스템에서 이관한 청구를 **이미 청구된 기간의 인보이스를 만들지 않고** 목표일까지 전진 ③ 배치 실행 중 **인보이스 문서 자동 생성** ④ **Generate Context-Rich Sequence Patterns with Dynamic Fields** — invoice·credit memo 등 대상 오브젝트의 표준/커스텀 필드를 시퀀스 패턴에 삽입 ⑤ **Set Invoice Target Dates by Calendar Day or Billing Period Count** — 고정 일수 오프셋 대신 **월중 특정 일자** 또는 **청구 주기 횟수** 기준 |
| **Tax Management** | **Apex 코드 없이** 세금 계산을 업무에 맞게 조정 |
| **Payments and Refunds** | Stripe·Adyen을 통한 **Level 2 / Level 3 결제 데이터 전달**, 저장된 디지털 지갑·지역 결제수단, **LWR Experience Cloud 사이트의 Billing Self-Service 컴포넌트**, 계정으로의 **크레딧 잔액 환불**, payment advice 레코드와 은행 명세서 **자동 대사** |
| **Collections** | **Collections Specialist Console** — 장기 연체 계정을 한 화면에서 처리(수금 계획 생성·인보이스 write-off·리마인더 발송·태스크 기록). 계정·통화로 카드·차트 필터. 회수/미결 잔액·인보이스 경과일·지급 약속 추적 |
| **Checkout API** | **Orchestrate Cart-to-Cash Checkout Flow With a Single API Call** — 외부 CPQ·웹사이트·커스텀 판매 채널에서 **단일 API 요청**으로 구독 생성 + 인보이스 생성 + 결제 처리·적용까지 수행 |
| 개발자 표면 | 신규/변경 **Billing 오브젝트**, 신규/변경 **Connect REST API**(비참조 환불·통합 체크아웃 오케스트레이션·스케줄러 제어·커스텀 credit memo 필드·커스텀 billing cycle count·유연한 target-date 동작), **Metadata API로 billing forecast 조직 설정 배포/조회**, **신규 invocable action**(환불·billing schedule 워크플로) + 기존 billing schedule 생성 액션의 **비동기 실행 지원** |

**Preview Future Invoice Charges with Billing Forecast** (에디션·권한이 명시된 유일한 Billing 리프)

- **Where:** Lightning Experience — **Enterprise·Unlimited·Developer** 에디션의 Revenue Management(구 Revenue Cloud) + **Revenue Cloud Billing 라이선스**. **Billing Forecast Console을 보려면 Tableau Next Consumer 라이선스가 필요**하다
- **Who:** 활성화 — **Billing Admin** 권한 세트 / 예측 스케줄 생성·관리 — **Billing Operations User** 권한 세트
- **How:** Setup → **Billing Settings** → Billing Forecast 켜기 → App Launcher → **Billing Batch Scheduler** → **New Billing Forecast Scheduler**. 결과는 **Billing Forecast 레코드**에서 직접 보거나, Tableau 설정을 마친 뒤 **Billing Forecast Console**에서 확인
- 일회성(one-time)·구독(subscription) 요금 유형·카테고리 모두 예약 예측 가능

### Agentforce for Revenue Management

**Accelerate Approval Decisions with Approval Agent** — 영업 담당은 승인 제출·**회수(recall)** 와 대기 승인 추적을, 검토자는 제출 조회·**AI 보조 요약·코멘트 생성**·승인/반려를 에이전트로 처리한다.

### ⭐ 대표 신기능
1. **라인 아이템 15,000건 대형 트랜잭션** 전 구간(동기화·가격·구성 규칙·문서 생성·DPE transform).
2. **Promotions in Revenue Management 신규 도입** + Billing의 **주간 청구·catch-up bill run·Billing Forecast**.
3. **Advanced Approval Delegation** + 승인 work item 기밀 공유(private 모델).

---

## Service

> Service 랜딩 페이지가 나열한 축: **Contact Center · Agentforce IT Service · AI Agents for Service Cloud · AI Solutions for Service · Case Management · Entitlements and Milestones · HR Service · Knowledge · Self Service**. 이 중 **Agentforce IT Service는 51페이지 전수를 본문까지 확보**해 바로 아래 **`## Agentforce IT Service`** 절에 따로 실었다(분량이 커서 이 절에 넣지 않았다).

### Contact Center — 두 갈래로 갈라진 구조

Winter '27에서 컨택센터가 **두 제품**으로 명확히 갈렸다.

| 제품 | 정의(원문) |
|---|---|
| **Agentforce Contact Center (AFCC)** | *"a fully native, AI-first experience"* — Salesforce 안의 AI-first 컨택센터로 **내장 텔레포니**와 Workforce Engagement Management 등을 함께 제공 |
| **Partner Contact Center** | *"a flexible contact center solution that integrates a third-party CCaaS provider with Salesforce"* — **구 Salesforce Voice with Telephony Providers / 구 Service Cloud Voice**. Amazon Connect 등 서드파티 연결 |

> 원문 주의 문구: 제품·문서·릴리즈 노트에 **Salesforce Voice with Amazon Connect · Salesforce Voice with Partner Telephony · Salesforce Voice with Partner Telephony from Amazon Connect** 같은 텔레포니 모델 이름이 계속 등장한다.

**Voice 기능 — 텔레포니 모델별 적용 범위 (원문 셀 대조)**

| 기능 | Salesforce Voice (Native Telephony) | Voice with Amazon Connect | Voice with Partner Telephony | Voice with Partner Telephony from Amazon Connect |
|---|---|---|---|---|
| Find Available Reps Faster During Call Transfers | 적용 | — | — | — |
| Speed Up Rep Actions with Keyboard Shortcuts in AFCC | 적용 | — | — | — |
| Keep an Audit Trail of Voice Call Record Changes **(Pilot)** | 적용 | 적용 | 적용 | 적용 |
| Use Setup with Agentforce to Manage Contact Center Users | — | 적용 | — | 적용(수동 통합 인스턴스 포함) |
| Access Your Phone Book Anytime from the Omni-Channel Widget | — | 적용 | *이전엔 이 모델에서만 제공* | 적용(수동 통합 인스턴스 포함) |
| Sync All Amazon Connect Queue Types | — | 적용 | — | 적용 |
| Opt into Additional AI Features with Amazon Connect Customer | — | 적용 | — | — |
| Keep Reps Informed During Regional Switches (Disaster Recovery) | — | 적용 | — | 적용(수동 통합 인스턴스 포함) |
| Autonomous Phone Number Assignment | — | *이전엔 이 모델에서만 제공* | **신규 적용** | — |
| Record Personalized Voicemail Greetings | — | *이전엔 이 모델에서만 제공* | **신규 적용** | — |
| Voicemail Drop for Outbound Calls | — | *이전엔 이 모델에서만 제공* | **신규 적용** | — |
| Voice Connector Readiness Check | — | — | 적용 | — |

> 위 표는 원문의 *"This change is available in Salesforce orgs with these telephony models"* 목록을 **모델별로 전치**한 것이다. 원문이 *"Previously, this feature was available only in orgs with this telephony model"* 이라고 밝힌 칸은 **"이전엔 이 모델에서만 제공"** 으로 구분해 남겼다 — 현재 적용 대상과 과거 대상을 섞지 않기 위함이다. 각 리프는 *"View supported editions for Salesforce Voice"* 라고만 하고 에디션을 나열하지 않는다.

**주요 Voice 리프 상세**

| 항목 | 내용 |
|---|---|
| **Find Available Reps Faster During Call Transfers** | 전화 전환 시 Omni-Channel 위젯이 **수락 가능한 rep만** 필터링해 보여준다. Omni-Channel 설정에서 **Direct-to-Agent Routing**을 켜면 기본 적용 |
| **Keep an Audit Trail of Voice Call Record Changes (Pilot)** | `VoiceCall` 오브젝트 필드 **최대 20개** 추적. 로그에 **이전 값·새 값·변경 사용자·일시** 기록. **Activity 필드는 히스토리 추적 미지원.** Object Manager → VoiceCall → Fields & Relationships → Set History Tracking(또는 Setup → Field History Tracking → Voice Call). 레코드에서 보려면 **VoiceCall History 관련 목록**을 페이지 레이아웃에 추가, 리포트는 **VoiceCall History 커스텀 리포트 타입** 생성. **Pilot — Account Executive를 통해 등록** |
| **Use Setup with Agentforce to Manage Contact Center Users** | **Who: EinsteinGPTPlatformAddOn + AgentforceBuilderAddon 라이선스 구매**, `OrgPermissions.AgentforceSetupV2` 조직 권한 세트와 **Use Setup with Agentforce** 사용자 권한 세트 배정. How: Setup → Einstein Generative AI 켜기 → Agentforce Agents 페이지에서 Agentforce 켜기 → **Setup with Agentforce (Beta)** 켜기 |
| **Sync All Amazon Connect Queue Types** | voice-only·messaging-only·**mixed(voice+messaging)** 큐를 컨택센터 그룹에 동기화. 큐 추가·수정·삭제 시 채널 매핑이 voice·chat 채널을 자동 활성/해제. **메시징 큐 지원에는 contact center 버전 22.0 이상 필요.** 이전엔 voice 채널만 활성화돼 chat 채널이 고아가 되고 라우팅 프로필이 불일치했다 |
| **Opt into Additional AI Features with Amazon Connect Customer (Now Off by Default)** | Amazon Connect Customer가 **기본 켜짐 → opt-in으로 전환**. 예기치 않은 텔레포니 비용을 막기 위해 전 계정에서 선제적으로 끈다. 끈 상태에서는 **Connect Customer Basic 모델의 표준 요율**로 복귀하며 조치 불필요. **켜면 텔레포니 분(minute) 사용량이 표준 기본 요율의 2.1배로 과금**되어 Salesforce 플랫폼 분 소비가 증가한다. AWS 콘솔의 Connect 인스턴스 Customer 설정 또는 AWS CLI로 전환 |
| **Keep Reps Informed During Regional Switches for Amazon Connect Disaster Recovery** | 장애 중 실시간 알림 + Omni-Channel 위젯 설정 창에 **지역 표시기 상시 노출**. 수동 통합 컨택센터 중 **Global sign-in for Disaster Recovery** 사용 시, import XML 구성에 속성을 추가하면 지역 전환 후 rep 상태를 offline으로 바꾼다(기본은 상태 유지) |
| **Autonomous Phone Number Assignment** | rep이 관리자 없이 로컬/표준 회사 번호를 직접 조달·배정하고, 불필요해지면 해제해 반납. **Who: Manage Numbers 사용자 권한.** How: 프로필 → Settings → Voice 메뉴의 **Phone Number Assignment** |
| **Record Personalized Voicemail Greetings** | rep이 **최대 10개** 인사말 녹음. 수신 음성 메시지는 rep 개인 음성사서함에 보관. 자기 번호를 배정했다면 **번호별로 다른 인사말 연결** 가능. **Who: Manage Voicemail Greetings 사용자 권한** |
| **Voicemail Drop for Outbound Calls** | 발신이 음성사서함으로 넘어가면 사전 녹음 메시지를 남기고 끊는다. 기본 녹음 또는 여러 옵션 중 선택. 백그라운드 재생 중 rep은 다음 작업 진행. **Who: Use Voicemail Drops 사용자 권한** |
| **Voice Connector Readiness Check** | SSO 완료 + Voice 커넥터 로딩 완료 전에는 Omni-Channel이 작업을 배정하지 않는다. **검증 2단계** — ① **Voice connector readiness check**: Winter '27 신규. **blended routing**(파트너가 통화를 라우팅하고 Omni-Channel이 케이스 등 나머지를 라우팅) Partner Telephony 컨택센터의 Contact Center Details에서 켠다. **Omni-Channel Unified Routing을 쓰는 파트너 컨택센터와 Agentforce Contact Center에서는 기본 켜짐** ② **base-level check**: **Summer '26에 기본 신규 도입**. 텔레포니 모델과 무관하게 Salesforce Voice를 쓰는 **모든 컨택센터** 대상. 실패하면 rep은 voice·blended presence 상태로 전환할 수 없다 |

### Workforce Engagement Management

랜딩: *"native Workforce Engagement Management built into your CRM"* — 예측 AI 수요 예측·capacity plan·스케줄 관리, 실시간 intraday 가시성, 객관적 품질 평가.

**Workforce Management — Winter '27 최대 확장 영역 중 하나 (21건 전수)**

| 항목 | 내용 |
|---|---|
| Simplify Workforce Management Discovery and Setup | **Salesforce Go** 한 곳에서 WFM 기능 발견·구성 |
| Support Skills-Based Planning with Work Skill Groups | 개별 스킬 또는 스킬 조합으로 **work skill group** 생성. 생성 전 **최근 30일 작업량**과 해당 스킬 보유 service resource 수를 검토 |
| Expand Workload Planning Across Multiple Work Sources | **Omni-Channel 큐 기반·스킬 기반 작업 + Field Service service appointment + Mobile Workforce Management 커스텀 오브젝트**로 workload 구성. 집계 차원 선택: **service channel · work skill group · queue · region · work type** |
| Forecast Demand with Skills-Based Workloads | 완료된 workload로 예측 생성(스킬·스킬그룹 수준 수요 포함). 구간·채널·스킬그룹별 **Volume·Average Handle Time** 의 과거/예측치 검토 |
| Plan Staffing with Skills-Based Capacity Plans | 스킬그룹·채널·job profile 선택, SLA 구성, work unit 정의로 필요 인력 산출. **공유 스킬 기반으로 유효한 job profile↔skill group 조합을 자동 식별** |
| Compare Required and Available Staffing at a Glance | Capacity Plan 레코드 페이지에서 job profile별 필요/가용 capacity 차트 + job profile·채널별 상세 표. **shift template 기준의 shift requirement 표시는 없어졌고, shift 생성은 Schedule Manager로 이동** |
| Monitor Net Staffing | Job Profile·Service Resource 페이지의 **Net Staffing Grid** |
| Balance Rest and Coverage with More Scheduling Rules | **Rest Between Shifts · Rest Between Weeks · Multiple Breaks** 규칙. 연속 근무·주 간 최소 휴식 강제, 설정 시간창 내 휴게 분산, **15분 간격**으로 근무·휴게 배치 |
| Save Time Generating Shifts from Patterns or Capacity Plans | shift pattern·capacity plan에서 다건 shift 일괄 생성 + 적격 service resource 자동 배정. **자동 배정 실패분은 Tentative 상태로 남는다** |
| Create Shifts Faster with Drag-and-Drop Templates | 스케줄 그리드에 shift template·pattern을 드래그앤드롭 |
| Generate More Flexible Shift Schedules with Shift Patterns | pattern entry별 **Occurrences** 지정으로 반복. 생성 시 자동 배정, 실패분은 **Tentative 상태 카테고리** |
| Organize Shift Work with Shift Activities | Schedule Manager에서 shift를 **shift activity** 단위로 분해·추가·수정·삭제. activity는 **부모 shift의 타임존을 상속**하고 타임존 토글 전환 시 함께 이동 |
| Manage Requests Without Leaving Schedule Manager | resource absence 요청을 스케줄 맥락에서 검토하고 코멘트와 함께 승인/반려. **Salesforce Go 페이지에서 승인 플로우 생성·배포** 가능 |
| Find Shifts Faster with Advanced Search and Filters | 다중 필터 조합·레코드/필드 교차 검색·자주 쓰는 필터 조합 저장 |
| Manage Schedules with Scheduling Agent | 자연어로 배정된 shift 조회·재배정. **Worker Shift Agent** = 요청 기간의 shift 정보 반환, **Scheduling Agent** = 재배정 처리(확인 요청·모호한 요청 명확화·스케줄 충돌 방지) |
| Optimize Intraday Staffing with Real-Time Adherence | Intraday 대시보드의 동적 adherence 점수·결근 표시·색상 상태 블록이 예정 활동과 **Omni-Channel 실제 상태**를 비교. Job Profile·Service Territory로 이탈 상담원 필터, **schedule allowance** 설정으로 사소한 편차 흡수. **플랫폼 이벤트로 플로우 자동화를 트리거**해 Slack·이메일 알림까지 확장(관리자 구성 시) |
| Gain Visibility Into AI and Agent Performance | Intraday Adherence Gantt에 **AI workforce 전용 행** — 시간당 총 처리 상호작용·에스컬레이션율·containment 추세 + **다음 구간 예측 성능**. 실시간 AI containment 추세와 상담원 capacity를 견줘 채널별 자원 배분 조정 |
| Access Your Schedule Directly from Omni-Channel | Omni-Channel 작업공간에서 배정 shift·예정 활동 확인. **현재 시각으로 자동 스크롤** |
| Improve the Worker Calendar Experience | 키보드 내비게이션, 페이지 이탈 없이 이벤트 상세 미리보기, 커스텀 Lightning 페이지에 캘린더 고정, in-place 새로고침 |
| Get Real-Time Notifications About Shift Changes | **Shift Assigned · Shift Unassigned · Shift Starting Soon · Clock Out Reminder** 실시간 알림 |
| Find and Request Open Shifts to Fill Coverage Gaps | 스킬·territory·labor rule·스케줄 기준 적격 오픈 shift를 데스크톱·**Salesforce 모바일 앱**에서 조회·신청. **제출 전 시스템이 적격성 자동 확인**. 관리자 승인/거절, 신청자는 상태 추적 및 승인된 shift를 정규 스케줄·휴가와 함께 확인 |

**Quality Management — Evaluate Every Interaction:** **음성 통화·메시징 대화·email-to-case** 전 채널의 모든 상호작용을 AI로 자동 평가. 상호작용 속성에 따라 적절한 평가 양식을 매칭. QA 팀 업무량 증가 없이 전수 평가 커버리지 달성.

### Messaging

| 항목 | Where / How |
|---|---|
| **Choose Who Can Access Messaging Components** | **Enhanced messaging 채널 + Enhanced chat.** Messaging Component Builder의 Component Details에서 **Controlled by Permission Sets** 선택 후 저장·활성화 → 권한 세트 편집 → Apps → **Messaging Component Access** → 컴포넌트를 Enabled Messaging Components로 이동. 서비스 담당은 콘솔에서, 관리자는 bot builder에서, 에이전트는 LLM 경유로 **제한된 목록**을 사용. 이전엔 전원이 모든 컴포넌트에 접근했다 |
| **Initiate Customer Outreach with Apple Messages for Business** | 미참여 고객에게 초대 발송. 사전 작성 문구 *"Connect using messages"* + Yes 클릭 유도. **Apple의 필수 기능**을 이제 지원. Notification 메시징 컴포넌트 생성 시 **Apple Invitations 형식** 선택 |
| **Escalate WhatsApp Conversations to Voice on Unified Messaging Channels** | **AFCC Digital Unlimited/Enterprise**. Unified WhatsApp은 Service Cloud Enterprise·Unlimited, Marketing Cloud Next Growth·Advanced, Marketing Cloud Engagement Pro+·Corporate+·Enterprise+. WhatsApp 채널 상세의 **Create Voice Channel 배너** 또는 Messaging Settings의 토글. **Digital Engagement WhatsApp 채널에서 voice를 쓰고 있었다면 UCP 마이그레이션 전에 끄고 이전 후 다시 켠다.** UCP WhatsApp 채널에서 처음 켜는 경우 **먼저 connection refresh**로 voice 사용자를 WhatsApp Business Account에 추가 |
| **Gain a Clearer Understanding of Unified WhatsApp Capabilities and Default Routing** | 문서 재작성. Your Numbers 설정 노드 → 채널의 **Messaging Platform Key** 선택 |
| **Initiate Your Own WhatsApp Template Migrations** | 소스·타깃 WhatsApp Business Account를 직접 선택하고 진행 상태 모니터링. Your Numbers 페이지의 **Template Migration 탭** → New Migration Job. 이전엔 Salesforce 고객지원에 요청해야 했다 |
| **Present Customers with Data from External Sources in Dynamic WhatsApp Flows** | **Unified WhatsApp + Service Cloud WhatsApp.** WhatsApp Dynamic Flows가 **single-select·multi-select·dropdown·date picker 필드와 footer**에서 엔드포인트를 지원. Apex Form 컴포넌트 → Flows 형식 → **Enable Endpoint = True** + Endpoint URL 입력 → 화면 요소의 **On Select Action = Data Exchange** → JSON 페이로드 구성 |
| **Easily Access and Review Service WhatsApp Health Status** | 신규 **WhatsApp Business Profile 페이지**에서 전화번호·WABA·Business·Salesforce App 가용성 확인. 이전엔 Meta 계정이나 API 조회가 필요했다 |
| **Seamlessly Create and Troubleshoot WhatsApp Account Setup** | **2026-10-01에 Meta의 Embedded Signup Flow v2·v3 지원 중단.** Salesforce는 그 시점에 **v4**를 지원한다. Unified/Service WhatsApp 가입 플로우의 Meta 화면 UI가 바뀌며, Salesforce 플로우 안에서 WABA 생성·문제 해결 가능 |
| **Capture WhatsApp Flow Responses Submitted After a Messaging Session Ends** | 세션 종료 후 제출된 폼 응답을 폐기하지 않고 **지정 레코드에 저장**하고 Service Console에 원 폼 요청의 답장으로 표시 |
| **Inform Customers When Their Chat Is Rerouted to Another Service Rep** | **Enhanced messaging + Enhanced Chat.** auto-response 메시징 컴포넌트 생성 → Messaging Settings의 채널 → Automated Responses → **Reroute Conversation** 필드에 지정 |
| **Report on Service Reps' Time Between Session Acceptance and First Response** | `MessagingSessionMetrics` 오브젝트의 `MessagingSessionMetricType` 필드에 **Service Rep Accept to First Response Time** 값 신규 추가. 이전엔 전환(transfer) 개시 이후 최초 응답 시간만 리포팅 가능했다 |
| **Bring Your Own Channel — Find Transfer and Conference Destinations with Clearer Labels** | 전환 대상 목록에서 **Others → External contacts**, 전 메시징 채널의 전환·컨퍼런스 대상에서 **Agents → Reps** 로 용어 정리 |

### Agentforce Service Assistant

Winter '27에서 Service Assistant가 **케이스 전용 → 메시징 세션 실시간 에이전트**로 확장됐다. 공통 라이선스 축: **Lightning Experience** + Enterprise·Unlimited·Developer + **Agentforce for Service 또는 Agentforce 1 애드온**, 그리고 **Service Planner + Adaptive Experience 애드온**. **단 아래 두 예외를 이 축에 그대로 적용하면 안 된다.**

> [!note] 공통 축의 예외 2건 (원문 Where 대조)
> - **Einstein for Service도 대상인 항목:** `rn_sra_persistence`(세션 종료 후 24시간) · `rn_sra_status`(상태 표시) · `rn_sra_link`(클릭 가능 URL) · `rn_sra_ccu`(Conversation Catch-Up). 원문 Where가 *"with Einstein for Service, Agentforce for Service, and Agentforce 1"* (ccu는 *"the Einstein for Service, Agentforce for Service, or Agentforce 1 add-ons"*)로 **Einstein for Service를 함께 명시**한다 — 공통 축만 보고 자격을 좁히면 안 된다.
> - **`rn_sra_link`(Access Resources Linked in Plan Steps with Clickable URLs)는 Adaptive Experience 애드온이 필요 없다.** 원문: *"This feature requires the Service Planner Add-on license."* — **Service Planner 애드온만** 요구한다.

| 항목 | 지원 범위 / 시점 | 내용 |
|---|---|---|
| **Get Real-Time Issue Resolution with Dynamic Service Plans** | Case·Messaging / **2026-07-21** | 케이스·메시징 세션 진행을 자동 모니터링하며 **플랜 단계를 실시간 갱신**. 단계마다 **활성 레코드 데이터·서브에이전트 지시문·지식 문서·에이전트 액션을 새로 검토**해 최신 해결책 제시. **Who:** 설정=Service Planner Builder, 사용=Service Planner User. **메시징용 동적 플랜 생성 시 ServicePlanner User에게 Agent Messaging Access 커스텀 권한 세트 필요** — 앱 권한 *Access Conversations Entries*, Messaging Sessions 오브젝트 권한 **Read·View All Fields**. **케이스용 동적 플랜에는 추가 권한 불필요.** How: 일반 설정 완료 후 Service Assistant Setup 페이지의 Case/Messaging 탭에서 Dynamic Service Plans 켜기 |
| **Provide Service Reps Dynamic, Real-Time Issue Resolution Guidance for Messaging Sessions** | Messaging / **2026-07-21** | 지원 채널: **Enhanced Chat · Facebook · WhatsApp**. 설정·사용 모두 **Messaging Eligibility Flow Access 커스텀 권한 세트**(메시징 세션 적격성 플로우 접근) 추가 필요. 설정 절차: 적격성 기준 생성 → 메시징용 Service Assistant 켜기 → 메시징 세션 레코드 페이지에 컴포넌트 추가. **기존 Service Assistant 에이전트·서브에이전트·액션 재사용 가능**하고, 메시징 전용 에이전트를 따로 만들 수도 있다 |
| **Automate Service Plans with Agent Actions** | Case·Messaging / **2026-07-21** | 표준·커스텀 **에이전트 액션**으로 플랜 단계를 자동 완료. 레코드 상세와 grounding 소스(서브에이전트 지시문·지식 문서)를 액션 설명과 대조해 자동화 가능 단계를 식별하고 액션을 플랜에 노출·실행. **Salesforce는 Service Assistant용 표준 액션을 제공하지 않는다 — 업무에 맞는 액션을 직접 만들어야 한다**(가이드라인·베스트프랙티스만 제공). **Custom Lightning type 지원.** 모든 액션은 **ServicePlanner User의 권한으로 실행**되므로 그 사용자에게 프롬프트 템플릿·플로우·Apex 액션 접근 권한을 줘야 한다 |
| **Use the Service Assistant Chat** | Case·Messaging / **2026-07-21** | 컴포넌트를 벗어나지 않고 질문·지식 조회·이메일/플랜 요약 작성. 채팅은 **General CRM · General FAQ 서브에이전트**로 구동되며 각각 **Get Record Details·Draft and Revise Email** 등 표준 액션을 포함한다. **이 두 서브에이전트를 에이전트에 반드시 추가**해야 한다. 동적 플랜(Case·Messaging)은 켜면 채팅이 **기본 제공**, 케이스의 **guidance 플랜**은 Case 탭 Guidance Plans 섹션에서 **Chat with Service Assistant**를 따로 켠다. **케이스는 dynamic / guidance 중 한 번에 하나만 활성화 가능** |
| **Work With Service Assistant After a Messaging Session Ends** | Messaging / **2026-08-28** | 세션 종료 후 **약 24시간** 채팅 박스와 Service Assistant 유지 — 요약 요청·후속 이메일 작성·지식 질문·일반 도움. 모든 상호작용이 컴포넌트 피드에 저장. **세션이 끝나면 서비스 플랜도 종료되어 선제적 단계 안내는 중단**되고, 온디맨드 질문·액션 실행만 가능. **Service Assistant for Case는 케이스가 닫히는 즉시 에이전트·채팅 박스가 비활성화된다**. **기본 켜짐 — 설정 불필요** |
| **Know When Service Plan Creation is in Progress with a Status Indicator** | Case(dynamic·guidance) / **2026-07-10** | *"Service Plan Summary in Progress"* 상태 표시. **기본 켜짐 — 설정 불필요** |
| **Access Resources Linked in Plan Steps with Clickable URLs** | Case(guidance) / **2026-06-30** | 서브에이전트 지시문·지식 문서의 링크가 플랜 단계에서 **새 탭으로 열리는 하이퍼링크**로 렌더링. 이들 소스의 링크는 자동 신뢰. **조직의 Trusted URLs 목록에 명시 등록되지 않은 URL은 평문으로 표시**된다 |
| **Catch Up on Active Customer Interactions with Conversation Catch-Up** | Messaging / **Winter '27 릴리즈** | 진행 중 대화의 AI 요약 카드. 요약 카드가 뜨는 세 조건: ① 전환된 메시징 세션 수락 ② 봇·큐에서 온 세션 수락 ③ 감독자가 Omni Supervisor 대시보드에서 **Monitor** 클릭(에스컬레이션·flag raise 대응). 라이선스는 Einstein for Service / Agentforce for Service / Agentforce 1 애드온 + **Service Planner·Adaptive Experience 애드온**. **Who:** 관리자 = Service Planner Builder + **Work Summaries User** + **View Conversation Catch-Up** / 담당자 = Service Planner User + Work Summaries User + View Conversation Catch-Up. **전체 Service Assistant 설정(에이전트 생성 포함) 없이도 사용 가능** — Customize Experience by Object에서 메시징용 Service Assistant를 켜고 컴포넌트를 추가한 뒤, **Einstein Work Summaries 설정 페이지**에서 Conversation Catch-Up을 켠다 |
| **Provide Service Reps with Immediate Case and Customer Context with Case Catch-Up & Insights** | Case / **2026-07-21** | 케이스·연관 계정·고객 감정·**case health score** 의 AI 생성 요약을 하나의 카드로. 커스터마이즈 가능한 인사이트 4종: **Engagement Summary · Account Summary · Opening Sentiment · Analytics**. **Who:** 관리자 = Service Planner Builder + **Prompt Template Manager** / 담당자 = Service Planner User + **Prompt Template User** / **ServicePlanner User(에이전트 사용자)는 별도 권한 불필요**. 전체 Service Assistant 설정 없이도 가능하며, 켠 인사이트마다 **Prompt Builder에서 기본 프롬프트 템플릿을 활성화**해야 한다 |

### AI Solutions for Service

| 항목 | 내용 |
|---|---|
| **Einstein/Agentforce Article Recommendations** | 케이스 한 건 안의 **여러 이슈**를 식별·해결 |
| **Resolve Every Issue in a Case with Multi-Intent Article Recommendations** | Agentforce Article Recommendations for Cases가 **최대 3개의 서로 다른 intent**를 식별하고 각 intent별 검색을 만든 뒤 결과를 **순위 병합**. **Where: Lightning Experience** + **Data Cloud(원문 표기 그대로 — 리브랜드 후 명칭은 Data 360)가 프로비저닝**되고 Agentforce Article Recommendations for Cases가 이미 활성인 조직(원문: *"orgs with Data Cloud provisioned and Agentforce Article Recommendations for Cases already enabled"*). **이전엔** 케이스 전체로 만든 **단일 검색 쿼리** 때문에 *"가장 두드러진 주제가 고객이 언급한 다른 이슈의 문서를 밀어냈다"*(원문: *"Previously, a single search query built from the whole case let the most prominent topic crowd out articles for other issues the customer mentioned."*). **When: Salesforce가 조직에 활성화해야만 사용 가능** — Setup에 Enable Multi-Intent Detection 토글이 없으면 계정 팀에 활성화 확인 요청. **How:** Setup → Service → Einstein → Einstein Article Recommendations for Cases에서 **Get Recommendations on Cases 플로우**를 쓰고 있는지 확인 후 토글. **Get Generative AI Recommendations for Cases 플로우를 쓰는 조직에서는 사용 불가** |
| **Enhanced Summaries — Generate Enhanced Case Summaries in Five More Languages** | 기존 지원 언어에 더해 **체코어·그리스어·헝가리어·폴란드어·루마니아어** 추가. **대화가 다른 언어로 진행돼도 요약은 담당자 언어로 생성**된다 |
| **Einstein Work Summaries** | **Voice 통화와 Enhanced Messaging 세션**의 작업 요약 자동 생성·저장. 5개 언어 추가 지원. **Work Summaries for Case (Beta)는 2026-09-30 은퇴 예정** |
| **Service Replies for Email — Ground in Enterprise Knowledge** | **SharePoint·Confluence·내부 위키·PDF 매뉴얼** 등 내외부 지식 소스 기반 답장 생성. Salesforce **Enterprise Knowledge**에 연결해 인덱스에서 실시간 검색. **각 제안 답장에 출처 문서 인용 링크 포함.** Where: Enterprise·Unlimited + **Agentforce for Service 애드온 또는 Agentforce 1 에디션** |

### Case Management

> **랜딩 요약(리프 미추출)** — 아래 3건은 부모 허브 `rn_service_case_management`가 담은 **자식 요약**이다. 리프 페이지는 제목 카탈로그에 있고 **에디션·Setup 경로·권한·가용 시점은 확보되지 않았다.** (표 안의 Beta 마커는 원문 자식 요약 문장에 포함된 것이다.)

| 항목 | 내용 |
|---|---|
| **Refine Case Comments with AI-Powered Writing Tools** | 케이스 코멘트 편집기에서 초안을 다듬기·확장·요약(의미 보존). 관리자가 **Refine Case Comment 프롬프트 템플릿**에 설정한 가이드에 따라 지시문을 입력해 다듬을 수도 있다. **코멘트 전체 또는 선택 영역** 대상 |
| **Easily View Original Case Attachments Inline in Case Details** | 원본 첨부가 **Case Description 필드 바로 아래 인라인**으로 표시. **최대 3개 타일** + 추가 파일은 popover 링크. 원본 첨부 = **최초 케이스 생성 시간대에 이메일 제목 또는 케이스 설명에 추가된 파일** |
| **Simplify Case Merging with the Revamped Case Merge UI** | 통합 설정 페이지에 **Case Merge · Enhanced Case Merge (Beta) · Case Merge for Omni-Channel (Beta)** 를 모았다. **Enhanced Case Merge (Beta)는 Duplicate Rules·Matching Rules 접근을 제공** |

### Entitlements and Milestones

**Reduce Storage Bloat and Keep Records Clear by Deleting Outdated Case Milestones** — **Data Loader 또는 Apex**로 케이스 마일스톤을 일괄 삭제해 데이터 저장 용량 회수. 이전엔 마일스톤 레코드가 케이스에 **무한 누적**되며 삭제 수단이 없어 대량 조직의 저장 비용이 올라갔다. 케이스가 재분류돼 이전 마일스톤이 무의미해진 경우 등에 사용.

### Knowledge

| 항목 | Where / How |
|---|---|
| **Reuse Modular Content Across Articles with Knowledge Blocks** | **Professional·Enterprise·Performance·Unlimited·Developer + Salesforce Knowledge 애드온 라이선스.** 법적 고지·회사 주소 같은 재사용 콘텐츠를 한 번 만들어 **관리형 읽기 전용 블록**으로 문서에 삽입. **블록의 새 버전을 게시하면 그 블록을 쓰는 모든 문서에 자동 반영.** 이점 3가지(원문): 반복 콘텐츠 단일 관리 · 작성자에게 일관된 단일 진실 소스 제공 · **전 변경 이력(full version history)** 으로 감사 추적. Setup → **Enhanced Knowledge Settings** → Knowledge Blocks 켜기 |
| **Create Knowledge Articles from Any Record with Custom Prompt Templates** | **Professional·Enterprise·Performance·Unlimited·Developer + Salesforce Knowledge 애드온 라이선스.** 케이스·인시던트·작업 지시 등 **모든 레코드**에서 문서 초안 작성. Prompt Builder에서 평문 지시문 + 병합 필드로 **여러 커스텀 프롬프트 템플릿** 작성. 레코드에서 직접 또는 앱 어디서나 **Agentforce 대화형**으로 생성. 이전엔 Einstein Knowledge Creation이 **케이스·메시징 세션에 한정된 기본 템플릿 1개**만 제공했다. Setup → Einstein Knowledge Creation 켜기 → **Prompt Builder Template** 켜기 → Prompt Builder에서 **Knowledge Generation 템플릿 타입** 선택·grounding 레코드/입력 구성·활성화 |
| **Prevent Duplicate Articles with Knowledge Similarity** | **Enterprise·Performance·Unlimited·Developer + Knowledge 애드온 라이선스**(Professional 미포함 — 위 두 기능과 에디션 범위가 다르다). 초안 작성 시 유사 문서를 **백분율 유사도 점수**와 함께 노출. Setup → **AI Knowledge Settings** → Knowledge Similarity 켜기 → **Agentforce Data Library에 연결**해야 기존 지식 베이스와 비교 가능 |

### HR Service

- **Deploy HR Workflows Faster with Added Service Templates** — HR Service 워크플로 라이브러리에 **템플릿 5종** 추가(예: **shift swap · timecard correction · direct deposit update**). 요청을 올바른 시스템으로 라우팅하고 해결까지 추적하므로 **케이스 로직을 직접 만들 필요가 없다**.
- **Protect Confidential Cases with Case Visibility Policies** — **Policy Engine**으로 case 오브젝트에 직접 가시성 규칙을 정의. 배포되면 기밀 케이스 접근이 **① 케이스를 등록한 사람 ② 케이스가 배정된 큐의 멤버 ③ case team에 추가된 사용자 ④ HR Case Investigator 커스텀 권한 보유자** 로 제한된다. 이전엔 기밀 케이스 등록에 **public complaint case junction 엔터티**가 필요했으나, 이제 **case 오브젝트만으로** 처리한다.
- 랜딩 요약(상세 리프 미추출): **Cornerstone 통합**, 급여·total rewards 조회 / shift 스케줄 추적 / 온보딩 완료용 **사전 구축 Agentforce 에이전트** 확대, **Microsoft Teams 원클릭 배포**.

### Self Service

> **랜딩 요약(리프 미추출)** — 아래 5건은 부모 허브 `rn_self_service`가 담은 **자식 요약**이다. 리프 페이지는 제목 카탈로그에 있고 **에디션·Setup 경로·권한·가용 시점은 확보되지 않았다.**

| 항목 | 내용 |
|---|---|
| **Deploy Messaging Automatically During Agentic Portal Setup** | Agentic Portal 설정 중 시스템이 **Enhanced Chat(구 Messaging for In-App and Web)** 을 자동 프로비저닝·배포. 메시징 채널·embedded service deployment 수동 구성 불필요 |
| **Reach Customers with In-App Notifications for Proactive Service** | 이메일에 더해 **모바일 in-app 알림**으로 선제 서비스 아웃리치. **Salesforce Mobile Publisher**로 만든 모바일 앱 대상(예: 연결된 기기의 동반 앱) |
| **Guide Customers Through Troubleshooting Steps with a Reusable Action** | 시나리오마다 별도 Agentforce 토픽·액션을 만들지 않고 **범용 트러블슈팅 액션** 하나로 처리. 지식 문서 + 요약된 케이스 이력에 grounding해 단계별 해결 절차 제시. **대화형 확인(interactive confirmation)** 으로 고객이 자기 속도로 진행 |
| **Set Up Your Agentic Portal Faster with a Guided Setup Wizard** | Salesforce Go → 사이트 생성 → 기능 구성 → 컴포넌트 설정 → 검토 → **원클릭 배포**. 마법사 안에서 Agentforce Customer Service Portal 에이전트 또는 Help 에이전트 선택/생성, Enhanced Chat 설정, Knowledge 페이지 추가, 개인화·data graph 옵션 선택. **조정할 때마다 라이브 프리뷰가 갱신**되고 **각 단계에서 레코드가 점진적으로 생성**된다 |
| **Set Up a Help Agent in One Guided Workflow** | Service Cloud Help Agent 설정에 필요한 에이전트 구성·지식 grounding·Enhanced Chat 배포·에스컬레이션 라우팅·테스트를 **`service-helpagent-coordinate` 스킬**이 하나의 가이드 워크플로로 묶어 구성·배포한다 |

### ⭐ 대표 신기능
1. **Service Assistant의 메시징 확장** — 동적 서비스 플랜 · 에이전트 액션 자동화 · 에이전트 채팅 · 세션 종료 후 24시간 유지.
2. **Workforce Management 21건 전면 확장** — 스킬 기반 workload·capacity plan, Scheduling Agent, 실시간 adherence + **AI workforce 행**.
3. **Knowledge Blocks(모듈형 재사용 콘텐츠)** + 커스텀 프롬프트 기반 문서 생성 + Knowledge Similarity.
4. **Contact Center 2제품 분리**(Agentforce Contact Center vs Partner Contact Center) + Amazon Connect Customer **opt-in 전환(2.1배 과금)**.

---

## Agentforce IT Service

> **이 절은 51페이지 전문(全文) 추출분이다 — 제목 계층이 아니다.** `rn_it_service_*` **19**페이지 + `rn_it_srvcs_*` **32**페이지 = **51**페이지를, 소스의 **허브 9 + 리프 42** 구조 그대로 옮겼다. [[Winter '27/Agentforce]]에는 상위 `rn_agentforce_it` 허브가 쓴 9개 축 요약만 있고, **기능 상세(Where·Who·How)는 이 절이 위키 안의 단일 출처**다.

```text
// 구조 예시 — 실제 동작 코드 아님 (Agentforce IT Service 51페이지 = 허브 9 + 리프 42)
Agentforce IT Service (51p)
├── Service Management            rn_it_service_svcmgmt                        13p (허브+12)
├── IT Asset Management           rn_it_srvcs_asset_management_parent          10p (허브+9)
├── IT Compliance                 rn_it_service_it_compliance                   6p (허브+5)
├── Self-Service                  rn_it_srvcs_self_service_parent               5p (허브+4)
├── Broadcast and Notifications   rn_it_srvcs_broadcast_notifications_parent    5p (허브+4)
├── Collaboration Channels        rn_it_srvcs_collaboration_parent              4p (허브+3)
├── Discovery for CMDB & SG       rn_it_srvcs_discovery_overview                3p (허브+2)
├── AI for IT Teams and Employees rn_it_srvcs_agentforce_parent                 3p (허브+2)
└── CMDB & Service Graph          rn_it_srvcs_cmdb_overview                     2p (허브+1)
                                                                          합계  51p
```

> **소스의 배치 quirk를 그대로 둔다:** CMDB & Service Graph 허브(`rn_it_srvcs_cmdb_overview`)는 자식을 **1건**(Enhanced List Views)만 요약한다. id에 `cmdb`가 들어 있는 `rn_it_srvcs_cmdb_dynamic_discovery`와 `rn_it_srvcs_new_obj_discovery`는 **Discovery 허브 아래**에 요약돼 있다. id 접두어로 묶으면 CMDB가 3건처럼 보이지만 **원문의 실제 소속은 CMDB 2건 / Discovery 3건**이다. 정리하지 않고 원문 배치를 따랐다.

### 등급 마커 — 이 51페이지 전체에 하나도 없다

**51페이지의 제목과 본문 전체를 대소문자 무시로 훑은 결과 `GA` / `Generally Available` / `Beta` / `Pilot` / `Developer Preview` / `Release Update` 문자열이 0건이다.** 추출 과정에서 마커가 유실된 것이 아니라 **원문에 애초에 없다**. 따라서 이 51건의 등급은 *"마커가 없다"* 는 사실까지가 확인된 전부이고, 그 이상(전부 GA다 / 전부 정식 기능이다)을 단정하면 안 된다.

> 이 노트 상단 **`### 등급 마커 일람`** 의 A·A-2·B 표에 이 51건이 한 건도 올라가지 않는 이유가 이것이다. 다른 영역과 달리 **본문까지 확보했는데도** 마커가 없는 케이스이므로, "제목만 있어서 등급 미상"인 항목들과는 성격이 다르다.

### 에디션 — 두 id 계열이 서로 다르다 (한 줄로 합칠 수 없다)

51페이지 중 **Where 문장이 있는 것은 41페이지**다(나머지 10 = 허브 9 + 리프 `rn_it_srvcs_new_obj_discovery` 1 — 원문에 Where 문장 자체가 없다). 그 41을 계열별로 집계하면 아래와 같다. **Developer와 Performance가 계열마다 갈리므로 "Enterprise·Unlimited·Developer·Performance" 같은 통합 한 줄로 쓰면 오답이 된다.**

| id 계열 | Where 있는 페이지 | 에디션 | 예외 |
|---|---|---|---|
| `rn_it_service_*` | **17** | **Enterprise · Unlimited · Developer** (17/17, 예외 없음) | — |
| `rn_it_srvcs_*` | **24** | **Enterprise · Performance · Unlimited** (23/24) | **`rn_it_srvcs_knowledge_generation` 1건만 Enterprise · Unlimited · Developer** — 계열 규칙의 유일한 반례이므로 이 페이지의 에디션을 계열로 추론하면 틀린다 |
| Where 문장 없음 | **10** | 허브 9 + `rn_it_srvcs_new_obj_discovery` — 원문에 Where 자체가 없다 | 에디션 **미상**(추정 금지) |

> 결과적으로 **한 하위 축 안에서도 에디션이 갈린다.** 예: *AI for IT Teams and Employees* 는 자식 2건 중 `rn_it_service_customizable_ai_actions`가 Developer, `rn_it_srvcs_agentforce_automate_file_analysis`가 Performance다. *Self-Service* 도 자식 4건 중 `rn_it_srvcs_knowledge_generation` 하나만 Developer다. 축 단위로 에디션을 뭉뚱그리면 안 된다.

**제품 조건 문구도 세 갈래로 갈린다** (Where 문장에 박힌 표현 그대로):

| 원문 표현 | 건수 | 해당 계열 |
|---|---|---|
| *with Agentforce IT Service **Management*** | **9** | 전부 `rn_it_service_*` |
| *with Agentforce IT Service* | **17** | `rn_it_srvcs_*` 중심 |
| *with the Agentforce IT Service **add-on*** | **6** | 전부 `rn_it_srvcs_*` (HAM 계열) |
| 제품 조건 문구 없이 에디션 + 별도 요건만 | **9** | Service Request 3건 · Compliance 4건 · Notification 2건 |

### ⚠️ 활성화 전제 — Setup 토글 하나로 되는 기능이 거의 없다

이 영역은 **게이트가 겹겹이 쌓인 구조**다. add-on 라이선스 · 선행 기능 활성화 · 권한 세트 라이선스(PSL) · 권한 세트 그룹(PSG) · 사용자 권한 · 사이트 템플릿이 조합으로 걸린다. 아래는 **Where·Who·How 문장에 명시된 것만** 옮긴 표다(문장에 없는 요건은 채우지 않았다).

| page id | 기능 | 명시된 전제 조건 |
|---|---|---|
| `rn_it_srvcs_agentforce_ham` | Automate Hardware Lifecycles with Agentforce | **이 세트에서 가장 게이트가 많다.** Agentforce IT Service **add-on** · 포털 AI 기능은 **AI Agent for Employees add-on**(Enterprise·Unlimited에서 제공) · Agentforce를 켜려면 **Manage AI Agents 또는 Customize Application** 권한 · HAM 설정에 접근하려면 **Inventory Management · Inventory Count · Inventory Replenishment · Data Cloud를 먼저 켜야 한다** · 직원이 포털 AI 기능을 쓰고 요청을 올리려면 **AI for Employee Portal 권한 세트 라이선스** 부여 + **Use AI in Employee Portal** 사용자 권한 + **ITAM for Community Users** 및 **ITAM UEL** 권한 세트 부여 |
| `rn_it_srvcs_cmdb_dynamic_discovery` | Dynamic Discovery for Splunk | **Salesforce CMDB & Service Graph** 와 **Asset Discovery** 가 **둘 다** 활성 + **CMDB Enterprise add-on** 도 필요 + 타깃 생성·구성에 **IT Service Asset Discovery 권한 세트 그룹** |
| `rn_it_srvcs_cmdb_cienhanced_list` | Enhanced CI List Views | **Salesforce CMDB & Service Graph** 활성 + **CMDB 권한 세트 아무거나** 있으면 사용자가 직접 목록 뷰 구성 가능 |
| `rn_it_service_cmpl_tableau_dashboards` | Prebuilt IT Compliance Dashboards in Tableau | **IT Service Compliance Analytics 권한 세트 라이선스** |
| `rn_it_service_cmpl_automated_evidence_collection` | Automated Evidence Collection | **Evidence Management** 활성 |
| `rn_it_service_cmpl_controls_coverage` | Controls Coverage | **Control Management** 와 **Agentforce** 가 활성 |
| `rn_it_service_cmpl_ai_policy_authoring` | AI Policy Authoring | **Policy Management** 와 **Agentforce** 가 활성 |
| `rn_it_service_cmpl_bulk_clause_status` | Bulk Clause Status Update | **Regulation Management** 와 **Policy Management** 가 활성 |
| `rn_it_srvcs_notifications_custom_related_objects` | 커스텀 오브젝트·관련 레코드 알림 | **Multi-Channel Notification add-on 라이선스** + **Notifications Designer** 권한 세트 |
| `rn_it_srvcs_interactive_agent_notifications` | Interactive Agent Notifications | **Multi-Channel Notification add-on 라이선스** + **Notifications Designer** 권한 세트 (전달 채널은 Slack) |
| `rn_it_srvcs_broadcast_communications` | Broadcast Communications | **BroadcastCommsSender 권한 세트 라이선스**를 인시던트·변경 fulfiller에게 부여 |
| `rn_it_service_incident_privilege_entitlement` | VIP 엔타이틀먼트 자동 할당 | **Person Accounts가 조직에 활성화돼 있어야 한다** + 특권 부여·해제에 **Assign Service Management Privilege User** 권한 |
| `rn_it_srvcs_autonomous_sourcing` | AI Sourcing Recommendations | Agentforce IT Service **add-on** + **Manage Inventory · Customize Application · Manage Agents** 권한 + Setup에서 **Hardware Asset Management 켜기 → Generative AI 활성화 → sourcing agent preference 켜기** |
| `rn_it_srvcs_bulk_offboarding` | Bulk Reclamation | Agentforce IT Service **add-on** + 리스트뷰·CSV 오프보딩 실행에 **Hardware Asset Management - Asset Manager** 권한 |
| `rn_it_srvcs_asset_status_mappings` | Asset Status Mappings | 상태 매핑 규칙 구성에 **Hardware Asset Management - Asset Manager** 권한, 커스텀 자산 상태 생성에 **Customize Application** 권한 |
| `rn_it_srvcs_asset_eligibility_framework` | IT Hardware Asset Scope 강제 | 라이프사이클 작업 실행에 **Hardware Asset Management 권한 세트** — 원문 예시는 **Asset Manager · Inventory Manager · IT Fulfiller** |
| `rn_it_srvcs_fast_path_sourcing` | Fast Path 이행 | **Hardware Asset Management 조직** + Agentforce IT Service **add-on** (별도 Who 문장 없음) |
| `rn_it_srvcs_fulfillment_component` | Fulfillment 컴포넌트 | Agentforce IT Service **add-on** (별도 Who 문장 없음) |
| `rn_it_srvcs_return_reminders` | 자동 반납 리마인더 | Agentforce IT Service **add-on** (별도 Who 문장 없음 — How는 서비스 요청·반납 주문 양쪽의 기본 알림 템플릿과 SLA 구성) |
| `rn_it_srvcs_portal_tailor_pages`<br>`rn_it_srvcs_portal_ticket_comments_feed`<br>`rn_it_srvcs_portal_language_selector` | Employee Services 포털 3건 | **Agentforce Employee Center 템플릿을 쓰는** Employee Services 포털 사이트에서만 제공. 다른 템플릿의 사이트는 대상이 아니다 |
| `rn_it_service_svcreq_omnichannel`<br>`rn_it_service_svcreq_stagemgmt`<br>`rn_it_service_svcreq_path_card` | Service Request 3건 | **IT Service Management + (IT Asset Management 또는 Employee Service)** 조합이 필요 |

> **표에 없는 나머지 페이지**는 Where 문장의 에디션·제품 조건 외에 별도 Who/전제가 원문에 없다. "게이트가 없다"가 아니라 **원문이 밝히지 않았다**는 뜻이다.

### ⚠️ 파괴적 변경 — Assigned User 필드가 API에서 사라진다 (`rn_it_service_simplified_incident_ownership`)

> [!warning] 기존 통합이 조용히 깨질 수 있는 변경
> **Winter '26 이후에 생성된 신규 조직**에서는 레거시 **Assigned User** 필드가 **기본적으로 숨겨지고, 게다가 API로도 접근할 수 없다**(*"hidden by default and it's also inaccessible via API"*). 원문은 **기존 통합을 Incident Owner로 옮기라**고 명시한다. Assigned User를 읽거나 쓰는 외부 시스템·미들웨어는 신규 조직에서 필드를 찾지 못한 채 실패하며, UI에서만 보면 원인이 드러나지 않는다.
>
> **기존 조직**은 Assigned User를 계속 쓸 수 있으나, 원문은 향후 구현에서 새 모델로 전환할 것을 **권고**한다(강제는 아니다).

새 소유권 모델은 두 필드로 갈린다.

| 필드 | 용도 | Winter '27 변경 |
|---|---|---|
| **Incident Owner** | 개인 소유권. 원문은 이 필드로 **개별 사용자 또는 큐**에 인시던트를 배정하라고 한다 | 큐 기반 라우팅의 창구로 정리됨 |
| **Assigned Group** | 그룹(팀) 소유권 | **이제 공개 그룹(public group)만 받는다 — 큐(queue)는 받지 않는다.** 큐 기반 라우팅(Incident Owner)과 팀 단위 작업 배정(Assigned Group)의 구분을 유지하기 위한 변경 |
| **Assigned User** (레거시) | 구 개인 배정 필드 | 신규 조직에서 숨김 + **API 접근 불가** / 기존 조직은 사용 가능하되 전환 권고 |

> 큐와 공개 그룹의 차이가 이 변경의 핵심이다 — [[Queues (큐)]] · [[Public Groups (공개 그룹)]] 참조.

### Service Management (13p — 허브 `rn_it_service_svcmgmt` + 12)

> 허브 요약: 서비스 데스크 운영을 최적화해 IT 팀이 **고가치 사용자를 우선 처리**하고, **이메일과 코멘트로 인시던트를 더 빨리 해결**하며, **서비스 요청 라이프사이클을 관리**하고, **콘솔 향상으로 종합적 인사이트**를 얻게 한다.

에디션은 자식 12건 중 **11건이 Enterprise·Unlimited·Developer**(`rn_it_service_*`), **1건(`rn_it_srvcs_proactive_svc_ops`)만 Enterprise·Performance·Unlimited**다.

| 기능 (page id) | 내용 | 근거로 확보된 것 |
|---|---|---|
| **Proactive Service Operations** — 고객 서비스와 IT 서비스 연결<br>`rn_it_srvcs_proactive_svc_ops` | IT Service Management와 Customer Service Management를 연결해 고객 서비스↔IT 팀 사이의 가시성 공백을 없앤다. 고객이 신고하기 **전에** 고객 영향 인시던트·예정된 변경을 서비스 렙이 다룰 수 있게 한다. **Service Assistant의 AI 제안**으로 고객 케이스를 근본 인시던트에 연결하고, 인시던트·변경 요청에 대해 **CMDB 데이터로 영향받는 거래처·자산·고객을 자동 식별**한다. 브로드캐스트 업데이트로 고객에게 알려 인바운드 티켓량을 줄인다 | Where(E·P·U, Agentforce IT Service) · Why · How(케이스에서 Service Assistant 제안 또는 case-incident 위젯으로 인시던트 연결 / 인시던트·변경 요청에 CMDB의 configuration item을 추가해 영향 고객 노출 후 브로드캐스트 발송) |
| **Ticket Comments**<br>`rn_it_service_ticket_comments` | 인시던트·서비스 요청에 **전용 티켓 코멘트**. 사람이 의도적으로 남긴 업데이트와 시스템 생성 활동을 분리해 AI 에이전트·요청자·감사자·IT 렙에게 깔끔한 해결 서사를 남긴다. **리치 텍스트 · 파일 첨부 · 가시성 제어 · 1단계 스레딩** 지원 | Where(E·U·D, IT Service **Management**) · How(Comments 탭/패널에서 추가, **Public**(요청자에게 보임)/**Private**(내부 전용) 지정, 리치 텍스트·코드 스니펫 서식, 코멘트당 **다중 파일** 첨부, 새 코멘트 알림, 본인 코멘트 수정·삭제) |
| **Email-to-Incident 강화**<br>`rn_it_service_email_to_incident_enhancements` | 이메일로 인시던트를 만들고 응답하는 흐름에 리치 HTML · 병합 필드 이메일 템플릿 · 자동 초안 저장 · 예약 발송 · 지능형 오류 처리 추가 | Where(E·U·D, IT Service Management) · Why(라우팅 주소별 기본 이메일 템플릿 + 인시던트 전용 병합 필드, 설명에 HTML·이미지 임베드, **초안 30초마다 자동 저장**, 답장 예약 발송, 동일 이메일 중복 탐지·폴백 큐 라우팅·한도 초과 시 동작 설정·발신자 allowlist·일시 오류 자동 재시도, **이메일 주소 검증이 이제 필수**, 외부 이메일 공급자 장애 시 자동 failover) · How(Setup > Email-to-Incident에서 `Display HTML email in incidents` · `Save unfinished replies as drafts` · `Notify external senders about processing errors` · `Place user signature above the latest email` · `Enable rich text for incident descriptions` 선택/해제, `Unauthorized sender action` · `Email rate limit exceeded action` · `Default incident owner` 값 지정) |
| **VIP 엔타이틀먼트 자동 할당**<br>`rn_it_service_incident_privilege_entitlement` | VIP 같은 고우선 직원이 신고한 인시던트에 **엔타이틀먼트를 자동 부여**해 더 빠른 지원을 보장. 플로우가 신고 직원의 service management privilege를 확인하고 적절한 엔타이틀먼트를 적용한다. privilege가 **VIP로 태깅**돼 있으면 SLA 응답·해결 시간이 빨라진다 | Where(E·U·D, IT Service Management, **Person Accounts 필수**) · Who(Assign Service Management Privilege User 권한) · How(**Assign Incident Entitlement Based on Privilege** 템플릿으로 플로우 생성 → Update Incident 요소에서 부여할 Entitlement ID 지정 → 저장·활성화. 엔타이틀먼트 없는 인시던트가 생성·수정될 때 자동 실행) |
| **Simplify Incident Ownership**<br>`rn_it_service_simplified_incident_ownership` | 위 **파괴적 변경 콜아웃** 참조 | Where(E·U·D, IT Service Management) · How(신규 조직 Assigned User 숨김·API 불가 등) |
| **Console Enhancements**<br>`rn_it_service_console_enhancements` | 케이스·서비스 요청을 인시던트·문제·변경 요청에 연결해 **360도 고객 뷰**를 만든다. 변경 위험을 이력 데이터와 변경 특성으로 계산한 **정규화 위험 점수(1–100 스케일)** 로 비교해 동일 기준으로 우선순위를 매긴다 | Where(E·U·D, IT Service Management)만 — Why·How 없음 |
| **Field History 리포팅·감사 추적**<br>`rn_it_service_console_history_reporting` | **Incident History · Service Request History · Problem History · Change Request History · Release History** 같은 객체로 필드 변경 감사 리포트를 만든다. 내부·규제 요건 준수 입증과 티켓이 정체되는 지점 파악에 쓴다 | Where(E·U·D, IT Service Management)만. *원문이 "such as"로 예시를 든 목록이므로 이 5개가 전부라는 뜻은 아니다* |
| **Omni-Channel로 서비스 요청 라우팅**<br>`rn_it_service_svcreq_omnichannel` | 서비스 요청을 스킬·여력에 맞는 렙에게 자동 라우팅. **가이드형 설정 어시스턴트**로 큐 정의, 서비스 담당자 추가, 라우팅·프레즌스 설정을 몇 번의 클릭으로 구성 | Where(E·U·D, **IT Service Management + IT Asset Management 또는 Employee Service 필요**)만 |
| **Stage Transitions로 서비스 요청 라이프사이클 관리**<br>`rn_it_service_svcreq_stagemgmt` | 각 요청이 **자체 태스크·전환·승인**을 가진 정의된 단계를 거치게 해 일관된 구조적 프로세스를 강제 | Where(E·U·D, 위와 동일 조합 요건)만 |
| **Service Request에 Path + Employee Profile Card**<br>`rn_it_service_svcreq_path_card` | Service Request 레코드에 **Path 컴포넌트**로 단계와 상태 요건을 시각화. **Employee Profile Card**가 사이드바에 요청자 정보를 표시해 프로세스와 사람을 한 화면에서 본다 | Where(E·U·D, 위와 동일 조합 요건)만 |
| **Dynamic Dashboards for IT Service**<br>`rn_it_service_dynamic_dashboards` | 사용자가 접근 권한을 가진 데이터만 자동으로 보여주는 **역할 기반 대시보드**. IT 매니저용(인시던트·문제·변경·릴리즈 전반의 추세·SLA 준수·팀 성과)과 fulfiller용(배정 업무·우선순위·해결 진척)을 구성하고, 운영형·개인화 fulfiller 뷰를 **Agentic IT Service Desk 앱** 홈에 추가 | Where(E·U·D, IT Service Management)만 |
| **IT Leader Dashboard**<br>`rn_it_service_it_leader_dashboard` | 인시던트·변경 관리·CMDB 운영 지표를 하나의 경영진 뷰로 제공 | Where(E·U·D, IT Service Management) · Why(인시던트 지표 = **평균 해결 시간(MTTR) · SLA 준수율 · 메이저 인시던트 건수 · 직원 만족도**, 케이스 해결 지표와 SLA 준수, 변경 관리 효과 = **성공률 · 긴급 변경 · 인시던트를 유발한 변경**, **인시던트·문제 건수 기준 상위 configuration item** 검토) |

### IT Asset Management (10p — 허브 `rn_it_srvcs_asset_management_parent` + 9)

> 허브 요약: **Agentforce AI 에이전트**가 직원 문의·소싱 결정·폐기 정산을 대화형 인터페이스로 처리하는 하드웨어 라이프사이클 자동화. 감사 대응을 위해 모든 재고 변경을 **complete double-entry ledger**로 추적. **Fast Path 이행**으로 모든 액션을 한 페이지에 모으고, 자산 상태 매핑을 조직 프로세스에 맞게 커스터마이즈.

자식 9건 **전부 `rn_it_srvcs_*` = Enterprise · Performance · Unlimited**이며, 6건은 **Agentforce IT Service add-on**을 명시한다.

| 기능 (page id) | 내용 |
|---|---|
| **Automate Hardware Lifecycles with Agentforce**<br>`rn_it_srvcs_agentforce_ham` | 직원은 **Slack · Microsoft Teams · Agentforce Employee Portal**에서 자연어로 하드웨어를 요청하고 상태를 확인한다. 원문이 명시한 **전용 AI 에이전트 4종**:<br>· **Employee Asset Management Agent** — *"내 요청 상태는?"* · *"노트북 언제 도착해?"* 같은 자연어 질문을 분류하고 승인·배송 추적·배달 상세 데이터를 가져와 통합 제시<br>· **Sourcing Agent** — 승인된 하드웨어 요청의 최적 이행 경로를 **로컬 재고 → 내부 이전 → 외부 조달** 우선순위로 자율 판단. IT fulfiller는 **Guided Fulfillment 모드**로 Agentforce 패널에서 추천을 검토 후 배송·이전 확정<br>· **Disposal Certificate Agent** — 자산 관리자가 **PDF·JPG·PNG** 벤더 폐기 증명서를 채팅으로 업로드 → 에이전트가 파싱해 일련번호를 열린 폐기 주문과 대조 → **100% 일치면 Success Card**, 불일치면 **Exception Card**. 흔한 수정에는 human-in-the-loop 버튼, 복잡한 해결에는 **Reconciliation Hub 딥링크** 생성<br>· **User Attestation Agent** — 직원에게 대화형으로 접촉해 배정 자산의 **실물 보유 여부를 확인**, 설문 피로 없이 감사 리스크 감소<br>전제 조건은 위 **활성화 전제 표** 참조 (이 세트에서 게이트가 가장 많다) |
| **IT Hardware Asset Scope 강제**<br>`rn_it_srvcs_asset_eligibility_framework` | 하드웨어 자산 라이프사이클 프로세스가 **적격 IT 하드웨어 자산에서만** 돌도록 울타리를 친다. 흩어진 검증 체크를 중앙 메커니즘으로 대체해 모든 워크플로·API에서 일관성을 확보하고, 비-하드웨어 도메인의 우발적 대량 수정을 막고 **태깅되지 않은 자산이 미터링을 우회하는 것을 차단**한다. Why: 중앙 검증이 표준 refresh·reclaim·disposal 플로우에 직접 통합돼 **대량 작업 중 부적격 레코드를 자동으로 건너뛰고 표시**한다 |
| **Asset Status Mappings**<br>`rn_it_srvcs_asset_status_mappings` | 커스텀 자산 상태 값을 **표준 카테고리 · 재고 수량 · 라이프사이클 전환 · 검색 필터**에 중앙 Setup 인터페이스에서 매핑. 커스텀 코드 없이 각 상태가 재고 가용성·자동 상태 전환·자산 검색 필터에 어떻게 작용할지 정의. Why: 이전에는 재고 계산·라이프사이클 전환 같은 후속 기능이 **하드코딩된 상태**에 의존해 커스텀 상태를 매핑하려면 **복잡한 Metadata API 구성**이 필요했다 |
| **AI Sourcing Recommendations**<br>`rn_it_srvcs_autonomous_sourcing` | Sourcing Agent가 **로컬 재고 먼저, 그다음 다른 위치로부터의 내부 이전** 순으로 엄격한 우선순위 평가(내부 이전은 **geocode 근접도**로 계산). **Guided Fulfillment 모드**에서는 Salesforce·Slack·Microsoft Teams의 Agentforce 패널로 추천을 검토하고 배송·이전을 수동 확정하며, fulfiller가 **기반 autolaunch 플로우를 커스터마이즈해 국경 간 로직을 강제**할 수도 있다. **자율 모드**에서는 구성된 기준을 충족하는 요청에 대해 에이전트가 **이행 주문을 자동 생성**한다. 연결 실패·예약 오류는 **Proactive Assistance 인터페이스**에 바로 표시 |
| **Bulk Reclamation (대량 회수)**<br>`rn_it_srvcs_bulk_offboarding` | 퇴사 직원의 하드웨어 반납을 **단일 액션**으로 처리. 직원 레코드에서 시작하거나, 리스트 뷰에서 다중 선택하거나, **CSV 업로드로 비동기 배치 처리**. 직원은 기기별 개별 알림 대신 **모든 반납 대상 자산을 담은 통합 이메일 1통**을 받는다. 구조: 배치당 **부모 서비스 요청 1건**, 직원당 **자식 서비스 요청 1건 + 반납 주문 1건**(자산은 라인 아이템). 배치 처리 아키텍처가 **직원 100명 이상의 대규모 오프보딩**을 이전에 타임아웃을 유발하던 시스템 한도 없이 처리 |
| **Fast Path — 서비스 요청에서 이행 처리**<br>`rn_it_srvcs_fast_path_sourcing` | **단일 stockroom 조직**에서는 서비스 요청이 처리 상태에 도달하면 **이행·반납 주문이 자동 생성**된다. 서비스 요청 페이지에서 라인 아이템 상세와 액션 버튼을 보고, 페이지 이동 없이 자산 추가·재고 할당·배송 표시·배달 확인. Why: 서비스 요청이 **Processing 또는 Fulfillment** 상태로 이동할 때 주문이 자동 생성돼 수동 소싱 개시가 불필요해진다. **Fast Path가 활성화되면 표준 Sourcing·Return Planning 버튼은 숨겨지거나 꺼져** 중복 워크플로를 방지한다 |
| **Fulfillment 컴포넌트**<br>`rn_it_srvcs_fulfillment_component` | 서비스 요청 페이지에서 모든 이행 주문·반납 주문 라인 아이템을 퀵 액션 버튼과 함께 조회. **이행 클릭 수를 약 50% 감소**시킨다. 표시 항목: 제품 · 수량 · 예약 상태 · 만료일 · 자산 일련번호 · 관련 product transfer/product request 정보. 인라인 액션(원문이 *"such as"* 로 든 **예시** — 전수 목록이 아니다): **Reserve Inventory · Add Asset · Allocate Inventory · Ready for Shipment · Items Ready for Pickup · Mark Delivered · Mark Sent · Mark Received**. 컨텍스트를 자동 해석해 이행 주문 페이지에서는 현재 레코드를, 서비스 요청 페이지에서는 **구성된 이행 위치 기준의 관련 이행 주문**을 보여준다. 액션 버튼은 네이티브 이행 주문 버튼과 **동일한 검증 로직**을 써 상태 갱신·재고 트랜잭션이 일관된다 |
| **Inventory Ledger (자동 트랜잭션 로그)**<br>`rn_it_srvcs_inventory_ledger` | 자산 라이프사이클 전반의 재고 수량 변경을 자동 추적. 각 원장 항목은 **무엇이·언제 변경됐고 어떤 비즈니스 프로세스가 유발했는지** + 관련 이행 주문 라인 아이템·자산 활동·반납 주문 라인 아이템을 담는다.<br>**원문이 명시한 트랜잭션 생성 규칙 전수:** 재고 예약 → **Reserved** · 이행 주문 발송 → **Outbound Shipped** · 이행 주문 수령 → **Delivered** · 반납 주문 수령 → **Order Received** · 자산을 damaged 또는 on hold로 표시 → **Adjusted**.<br>링크는 inventory item reservation이나 product transfer로도 연결돼 **완전한 감사 체인**을 만든다. product item 재고에서 파생한 정확한 가용 수량이 **자산 중복 할당을 방지**한다. 한 작업이 여러 재고 카테고리를 바꾸면 **변경마다 독립 트랜잭션 레코드**가 생성된다.<br>**두 레코드 타입의 역할이 다르다:** **PIT(Product Item Transaction)** = **Quantity On Hand** 변경 기록 / **PIAT(Product Item Additional Transaction)** = **Quantity Allocated · Quantity Soft Reserved · Quantity Damaged · Quantity On Hold** 변경 기록 |
| **자동 반납 리마인더**<br>`rn_it_srvcs_return_reminders` | reclaim을 시작하면 시스템이 **Draft 상태의 서비스 요청**을 만들고, 직원이 배송지를 확인하고 자산을 반납할 때까지 **이메일 또는 Slack 리마인더**를 보낸다. **SLA가 리마인더 주기를 결정**하고 임계치 위반 시 **직원의 매니저 또는 HR 담당자에게 에스컬레이션**한다.<br>Draft 상태 자체가 미응답 직원을 즉시 드러내는 가시성 장치다. **서비스 요청 SLA는 요청이 Draft에 머무는 동안** 작동해 배송 정보 제출까지 리마인드하고, **반납 주문 SLA는 요청이 New 상태로 옮겨간 뒤** 작동해 발송·드롭오프까지 리마인드한다. **중복 제거 로직**이 Send 다중 클릭 시 중복 요청을 막고, 자산 관리자는 방치된 Draft 서비스 요청을 취소해 SLA를 멈추고 **무한 리마인더 루프를 방지**할 수 있다.<br>How: 서비스 요청과 반납 주문 **양쪽**의 기본 알림 템플릿과 SLA를 구성해 리마인더 주기를 설정 |

### IT Compliance (6p — 허브 `rn_it_service_it_compliance` + 5)

> 허브 요약: **지속적·자동 증거 수집**, **AI 보조 통제 커버리지**, **신뢰할 수 있는 AI 정책 작성**으로 컴플라이언스 프로그램을 강화. **대량 액션**으로 규제·정책 라이프사이클을 가속하고 **사전 구축 Tableau 대시보드**로 태세를 모니터링.

자식 5건 전부 `rn_it_service_cmpl_*` = **Enterprise · Unlimited · Developer**. 다만 **모듈 게이트가 5건 모두 서로 다르다** — 아래 표의 조건 열을 그대로 읽어야 한다.

| 기능 (page id) | 내용 | 모듈 게이트 |
|---|---|---|
| **Automated Evidence Collection**<br>`rn_it_service_cmpl_automated_evidence_collection` | 감사 직전의 수작업·시점형 증거 수집에서 **연속 자동 수집**으로 전환. **256개 이상의 사전 구축 커넥터** 중 아무거나 써서 외부 시스템을 연결하고, 정의한 쿼리를 실행해 **감사 대응 가능한 evidence artifact**를 생성한다. How: IT Compliance 앱에서 가이드형 마법사로 **Collection Schedule** 생성 → **256+ 커넥터** 중 선택해 **named credential**로 외부 시스템(원문 예시: **AWS · Splunk · Jira · Tenable**) 연결 → 실행할 쿼리(**SPL · JQL · KQL**) 정의 → 주기 설정. 활성화 후 매 실행마다 **Evidence Artifact 레코드**가 생성돼 검토 후 통제에 첨부 | **Evidence Management** 활성 |
| **Controls Coverage + AI 통제 제안**<br>`rn_it_service_cmpl_controls_coverage` | 기존 통제가 각 규제를 얼마나 커버하는지 보여주고 공백을 메울 **AI 생성 통제 추천**을 제공. Controls Coverage가 규제를 요구사항으로 분해해 통제에 매칭하고 **커버리지 등급 + 무엇이 빠졌는지 드러내는 상세 breakdown**을 표시. How: 규제를 열어 커버리지 분석 실행 → 등급과 식별된 공백 검토 → 추천 통제를 추가하거나 AI 생성 제안을 수락 | **Control Management** 와 **Agentforce** 활성 |
| **Tableau 사전 구축 대시보드**<br>`rn_it_service_cmpl_tableau_dashboards` | 대시보드 제작 없이 IT Compliance 대시보드·위젯·메트릭을 Tableau로 제공. 가이드형 설정이 **IT Compliance Data Kit**과 사전 구축 **Tableau 앱**을 배포해 **IT Compliance Analytics 앱**에서 컴플라이언스 태세·통제 유효성·감사 준비도를 본다. How: Setup의 가이드 절차로 Data Kit 배포 → 사전 구축 Tableau 앱 템플릿 설치 → Tableau를 data kit에 연결 → IT Compliance Analytics 앱에서 대시보드 열기 | **IT Service Compliance Analytics 권한 세트 라이선스** |
| **AI 정책 작성 정밀화**<br>`rn_it_service_cmpl_ai_policy_authoring` | 두 가지 개선. **regulation traceability** — AI가 생성한 모든 정책 조항을 **출처 규제 조항까지 역추적**. **조항 사전 노출** — 선택 전에 규제 조항 전문을 읽을 수 있다. 결과적으로 중복 조항이 줄고 선택이 명확해진다. How: 정책 생성 시 **최대 10개**의 적격 규제 조항 선택 가능. **Published 및 Active 조항만 선택 가능**. 조항을 펼쳐 전문을 읽은 뒤 선택하고, 생성된 각 정책 조항에는 출처 규제 조항으로 연결되는 **citation**이 표시된다 | **Policy Management** 와 **Agentforce** 활성 |
| **조항 상태 일괄 변경**<br>`rn_it_service_cmpl_bulk_clause_status` | 규제·정책 조항 버전의 상태를 **단일 액션으로 다건 변경**. 원문 예시 라이프사이클: **Draft → Review → Approved → Published**. How: Regulation Clause Versions 또는 Policy Clause Versions 리스트 뷰에서 다중 선택 → 메뉴에서 목표 상태 선택 → 대화상자에서 확인. **진행 바**가 표시되고 **유효하지 않은 전환은 차단**된다 | **Regulation Management** 와 **Policy Management** 활성 |

### Self-Service (5p — 허브 `rn_it_srvcs_self_service_parent` + 4)

> 허브 요약: 팀의 업무 방식에 맞는 **Employee Services 포털** 셀프서비스 경험. 코드 없이 티켓 목록·티켓 상세·승인 목록 페이지의 **필드와 버튼을 제어**. 직원 선호 언어로 포털 제공, 티켓에 **코멘트와 피드**를 붙여 IT와 연결 유지. 해결된 인시던트·문제·변경 요청을 **Agentforce로 재사용 가능한 Knowledge 문서**로 전환.

**에디션이 축 안에서 갈린다:** 포털 3건은 **Enterprise · Performance · Unlimited**, Knowledge 생성 1건만 **Enterprise · Unlimited · Developer**다. 그리고 **포털 3건은 모두 Agentforce Employee Center 템플릿을 쓰는 사이트에서만** 동작한다.

| 기능 (page id) | 내용 |
|---|---|
| **포털 페이지 커스터마이즈**<br>`rn_it_srvcs_portal_tailor_pages` | Employee Services 포털의 **티켓 목록 · 티켓 상세 · 승인 목록** 페이지에 무엇이 표시될지 코드 없이 제어. 예: 서비스 모델에 관련된 필드만 노출, 직원이 티켓을 닫거나 다시 열 수 있는지 제어. How: **Experience Builder**에서 해당 컴포넌트를 선택해 설정 구성. **Agentforce Employee Center 템플릿 사이트 전용** |
| **포털 티켓 코멘트·피드**<br>`rn_it_srvcs_portal_ticket_comments_feed` | **인시던트·케이스·서비스 요청**에서 직원이 **티켓 피드**로 상황을 파악. **인시던트와 케이스**에서는 직원이 **코멘트 작성·답글·삭제**까지 할 수 있고, **인시던트에는 파일 첨부**도 가능하다(객체별로 가능 범위가 다르다 — 원문 구분 그대로). Why: 티켓에 커뮤니케이션을 모아 인바운드 문의를 줄이고, 티켓 담당자가 바뀌어도 **전체 대화 이력이 티켓에 남는다**. 인시던트·서비스 요청의 티켓 피드는 **자동 게시물·시스템 메시지 없이 직원↔IT 대화만** 표시한다. **Agentforce Employee Center 템플릿 사이트 전용** |
| **포털 언어 선택기**<br>`rn_it_srvcs_portal_language_selector` | 직원이 **Language Selector 컴포넌트**로 포털 표시 언어를 스스로 전환. **인터페이스 언어만 바뀌고 레코드 데이터는 원래 언어 그대로**다. How: Experience Builder 사이트 설정에서 지원할 언어를 추가하고 사이트를 게시 → Experience Builder에서 Language Selector 컴포넌트를 페이지에 드래그. **Agentforce Employee Center 템플릿 사이트 전용** |
| **Agentforce로 Knowledge 문서 생성**<br>`rn_it_srvcs_knowledge_generation` | 인시던트·문제·변경 요청에서 **그 레코드의 상세에 grounding된 구조화 Salesforce Knowledge 문서**를 초안 생성. 진입점은 레코드의 **Enterprise Knowledge Component** 또는 **Agentforce 에이전트에게 요청**하는 방식 두 가지. Agentforce가 쓰는 내용을 조정하려면 **레코드 타입별로 grounding된 Knowledge Creation 프롬프트 템플릿**을 만든다. **이 세트에서 `rn_it_srvcs_*` 계열 중 유일하게 Enterprise · Unlimited · Developer 에디션** |

### Broadcast and Notifications (5p — 허브 `rn_it_srvcs_broadcast_notifications_parent` + 4)

> 허브 요약: 사용자가 선호하는 채널로 정보를 전달. 메이저 인시던트·변경 요청 시 **이메일·in-app·Slack·Teams로 한 번에** 브로드캐스트. 평문 Slack 알림을 **라벨 구획과 액션 버튼이 있는 구조화 알림**으로 전환. **Agentforce 에이전트를 통해 알림을 전달**해 직원이 Slack 스레드 안에서 후속 질문과 액션을 처리.

자식 4건 전부 **Enterprise · Performance · Unlimited**. 다만 **라이선스 축이 둘로 갈린다** — 2건은 Agentforce IT Service, 2건은 **Multi-Channel Notification add-on 라이선스**다.

| 기능 (page id) | 내용 | 라이선스·권한 |
|---|---|---|
| **Broadcast Communications**<br>`rn_it_srvcs_broadcast_communications` | 메이저 인시던트·변경 요청 시 흩어진 수동 업데이트 대신 브로드캐스트 발송. **이메일 · in-app · Slack · Teams**에 한 번의 액션으로 도달. **생성형 AI가 레코드 상세에 grounding된 초안**을 빠르게 작성. 어떤 채널과 어떤 객체에서 브로드캐스트를 쓸지 preference로 제어. **communications history 탭**에서 모든 메시지를 추적해 중복·상충 업데이트 방지. How: Setup > Salesforce Go > Broadcast Communications를 켜고 채널·객체 preference 설정 → 인시던트나 변경 요청 레코드에서 발송 | Agentforce IT Service + **BroadcastCommsSender 권한 세트 라이선스**(인시던트·변경 fulfiller에게) |
| **구조화 Slack 알림**<br>`rn_it_srvcs_notifications_slack_alerts_to_structured_notification` | 평문 Slack 알림을 **라벨 구획 + 액션 버튼**을 갖춘 구조화 알림으로 대체. 한 번의 클릭으로 알림 상세를 훑고 Slack 안에서 **승인 요청 · 인시던트 확인(acknowledgement) · 상태 업데이트**를 바로 수행. 관리자는 **라이브 프리뷰와 템플릿**으로 알림을 시각적으로 디자인 | Agentforce IT Service (별도 Who 없음) |
| **커스텀 오브젝트·관련 레코드 알림**<br>`rn_it_srvcs_notifications_custom_related_objects` | 고정된 표준 객체 집합을 넘어 **커스텀 오브젝트에 대한 알림** 발송. **관련 자식 레코드 변경**에도 알림 가능 — 트리거는 **부모 레코드가 업데이트될 때 · 자식 레코드가 연결(associate)되거나 해제(disassociate)될 때**. How: Setup > **Multi-channel Notifications** > New. 커스텀 오브젝트에 알리려면 **Object Manager에서 그 객체를 publish**한 뒤 **Reference Object** 필드에서 선택. 관련 자식 레코드에 알리려면 **Usage Type 필드를 Related Object로** 설정하고 관련 객체 선택 | **Multi-Channel Notification add-on 라이선스** + **Notifications Designer 권한 세트** |
| **Interactive Agent Notifications**<br>`rn_it_srvcs_interactive_agent_notifications` | 단방향 알림을 **행동 가능한 알림**으로 전환. 알림이 **Slack의 Agentforce 에이전트를 통해 전달**되면 직원이 후속 질문을 하고 **스레드 안에서 우선순위 설정 같은 액션**을 수행해 그 자리에서 해결한다. Why: 이전에는 응답하려면 Salesforce로 전환하거나 별도 답장을 기다려야 했다. 이제 알림 스레드가 작업 공간이 된다. How: Setup > Multi-channel Notifications > New로 Slack용 알림 생성 → **Notification Content and Channel 단계에서 알림을 전달할 Agentforce 에이전트를 선택** | **Multi-Channel Notification add-on 라이선스** + **Notifications Designer 권한 세트**. 선제적 에이전트 알림은 **Slack으로 전달** |

### Collaboration Channels (4p — 허브 `rn_it_srvcs_collaboration_parent` + 3)

> 허브 요약: **Slackbot**과의 자연어 대화로 비밀번호 재설정·소프트웨어 접근·계정 프로비저닝 같은 요청 처리. **Teams 통합 원클릭 배포**와 Teams 리스트 뷰 커스터마이즈.

자식 3건 전부 **Enterprise · Performance · Unlimited + Agentforce IT Service**이며, **셋 다 별도 Who/전제가 원문에 없다.**

| 기능 (page id) | 내용 |
|---|---|
| **Teams 뷰 커스터마이즈**<br>`rn_it_srvcs_collaboration_customize_teams_view` | Microsoft Teams의 리스트 뷰에서 **컬럼 추가·제거·순서 변경**. **티켓 · 서비스 카탈로그 · 승인**용 사전 구성 뷰로 빠르게 시작하고 비즈니스 성장에 맞춰 인터페이스 조정 |
| **Teams 빠른 배포**<br>`rn_it_srvcs_collaboration_quickly_deploy_teams` | Agentforce IT Service 앱을 Microsoft Teams에 설치·구성하고 **단일 클릭으로 서비스 활성화**. 로그인 화면·자격 증명 없이 IT 지원에 접근. Salesforce가 백그라운드에서 **Microsoft Entra ID(구 Azure AD) 앱 등록을 자동 생성**하고 필요한 자격 증명을 배포하며 **CORS allowlist를 갱신**한다 |
| **Slackbot을 IT 어시스턴트로**<br>`rn_it_srvcs_collaboration_slackbot_it_assistant` | Slackbot과의 자연어 대화로 복잡한 IT 이슈 해결 — **비밀번호 재설정 · 소프트웨어 접근 · 하드웨어 주문 · 계정 프로비저닝**. Agentforce가 백그라운드에서 복잡한 요청을 즉시 완료해 대기 시간과 서비스 데스크 병목을 없앤다 |

### Discovery for Salesforce CMDB & Service Graph (3p — 허브 `rn_it_srvcs_discovery_overview` + 2)

> 허브 요약: 서버·클라우드 인벤토리와 **Splunk** 운영 이벤트로 CMDB 데이터를 최신 상태로 유지. **Dynamic Discovery**로 Splunk discovery target을 만들고, 관련 리소스를 CMDB에 추가하기 전에 **불완전한 CI를 검토**. Dynamic Discovery를 지원하는 **신규 Discovery 오브젝트와 플랫폼 이벤트** 제공.

> **소스 배치 주의:** 이 허브가 요약하는 자식 2건은 id가 각각 `..._cmdb_dynamic_discovery`와 `..._new_obj_discovery`다. **id 접두어와 소속 허브가 어긋나 있으므로 id로 소속을 판단하면 안 된다.**

| 기능 (page id) | 내용 |
|---|---|
| **Dynamic Discovery for Splunk**<br>`rn_it_srvcs_cmdb_dynamic_discovery` | **예정된 인벤토리 갱신 + 운영 이벤트**를 결합해 configuration item이 현재 상태를 반영하게 한다. 관리자는 Splunk에서 발견된 **불완전 CI를 검토**한 뒤 관련 리소스를 CMDB에 추가.<br>**전제:** Salesforce CMDB & Service Graph **와** Asset Discovery가 **둘 다** 활성 + **CMDB Enterprise add-on** + **IT Service Asset Discovery 권한 세트 그룹**.<br>**How (원문 절차 전수):** Setup > **Salesforce Go** 검색·선택 → **Splunk CMDB Integration Solution** 검색 후 **Set Up** → **Get Started** → CMDB·Discovery용 Salesforce Go 설정이 완료됐는지 검증 후 **Install** → **Take the Next Steps**에서 **Turn On Splunk Integration** 찾아 **Go to Feature Page** → Discovery 기능 페이지에서 **Set Up the Basics** 펼쳐 **Enable Dynamic Discovery** 켜기 → **Automate Device Discovery and Synchronization**에서 **Integrate Splunk for Comprehensive Asset Visibility** 켜기 → 내비게이션 패널의 **Discovery & Scanning** 펼쳐 **Targets** 선택 → 새 타깃 생성 시 target category = **Observability Tools**, Probe Type = **Splunk** → 디스커버리 시작 후 CMDB and Service Graph 앱에서 **Dynamic Discovery** 펼쳐 **Discovered CI by Source** 선택 → 불완전 CI 검토 후 관련 리소스를 CMDB에 추가 |
| **신규·변경 오브젝트**<br>`rn_it_srvcs_new_obj_discovery` | **Where 문장이 없는 유일한 리프**다(에디션·라이선스 미상). 원문이 밝힌 **신규 오브젝트 3종 전수**:<br>· **Configuration Management Discovery Target Trigger Template** — 서드파티 시스템이 개시하는 트리거와, discovery target의 configuration item 업데이트 처리에 쓰이는 속성을 정의<br>· **Configuration Management Target Trigger Template Flow** — 트리거 템플릿을 **CMDB의 configuration item 업데이트를 처리·적용하는 플로우**와 연결<br>· **Configuration Management Target Trigger Template Mapping** — 트리거 템플릿 속성을 **CMDB 업데이트용 configuration item 필드에 매핑**<br>*허브는 "신규 Discovery 오브젝트와 플랫폼 이벤트"라고 썼지만, 리프 본문이 명시한 것은 위 오브젝트 3종이다. 플랫폼 이벤트의 이름은 리프 본문에 없다.* |

### AI for IT Teams and Employees (3p — 허브 `rn_it_srvcs_agentforce_parent` + 2)

> 허브 요약: IT 티켓용 **파일 분석 자동화**와, 조직 프로세스에 맞춘 **AI 프롬프트·필드 매핑 커스터마이즈**.

**에디션이 축 안에서 갈린다** — 자식 2건이 서로 다른 id 계열이다.

| 기능 (page id) | 내용 | 에디션 |
|---|---|---|
| **Customizable AI Actions**<br>`rn_it_service_customizable_ai_actions` | AI 프롬프트와 필드 매핑을 조직 고유 프로세스·용어에 맞춰 커스터마이즈해 수작업 교정을 줄인다. 기존 레코드로부터 **변경 요청·인시던트·문제**를 AI가 만드는 방식을 구성하고, **내부 팀용·요청자용 이메일 초안**을 커뮤니케이션 기준에 맞춘다. **티켓 필터링 프롬프트**도 조직 워크플로에 맞게 조정. How: Setup에서 **Prompt Templates** 검색·선택 → 템플릿 선택 후 조직 고유 용어·비즈니스 규칙·필드 요건을 담도록 프롬프트 텍스트 수정 → 저장·활성화 | **Enterprise · Unlimited · Developer** (IT Service **Management**) |
| **Automatic File Analysis**<br>`rn_it_srvcs_agentforce_automate_file_analysis` | **인시던트·문제·변경 요청**에 첨부된 **스크린샷 · 에러 로그 · 구성 파일**에서 Agentforce가 자동으로 핵심 정보를 추출해 **요약 생성 · 근본 원인 식별 · 해결책 제안**. 수동 파일 검토를 없앤다 | **Enterprise · Performance · Unlimited** (Agentforce IT Service) |

### Configuration Management Database and Service Graph (2p — 허브 `rn_it_srvcs_cmdb_overview` + 1)

> 허브 요약: 역할에 맞는 상세 정보를 표시하도록 **configuration item 리스트 뷰를 구성**. 표준·커스텀 참조 필드를 추가하고 리스트에서 관련 레코드를 직접 열어 CI를 더 효율적으로 찾고 관리.

> **이 허브가 요약하는 자식은 1건뿐이다.** Dynamic Discovery와 신규 Discovery 오브젝트는 id에 `cmdb`가 들어 있어도 **Discovery 허브 소관**이다(위 참조).

| 기능 (page id) | 내용 |
|---|---|
| **Enhanced CI List Views**<br>`rn_it_srvcs_cmdb_cienhanced_list` | 필요한 정보에 따라 configuration item 리스트 뷰에 표시할 필드를 선택. **표준·커스텀 참조 필드**를 추가하고 **리스트에서 관련 레코드를 직접 열 수 있다**. 사용자 단위 구성이라 **service owner · application owner · database administrator**가 동일한 CMDB 데이터를 각자 필요한 뷰로 본다. **전제:** Salesforce CMDB & Service Graph 활성 + **CMDB 권한 세트 아무거나** 보유. How: Salesforce CMDB & Service Graph 앱 > **All Configuration Items** → 리스트 뷰 구성 액션으로 표시할 필드 선택. 리스트 뷰의 참조 필드는 관련 레코드로 링크된다 |

### ⭐ 대표 신기능

1. **Assigned User 필드의 API 접근 차단** — Winter '26 이후 신규 조직에서 레거시 필드가 숨겨지고 **API로도 못 읽는다**. 이 51건 중 **기존 통합을 실제로 깨뜨릴 수 있는 유일한 변경**(위 콜아웃).
2. **Agentforce for Hardware Asset Management — AI 에이전트 4종**(Employee Asset Management · Sourcing · Disposal Certificate · User Attestation). 이 세트에서 게이트가 가장 많은 기능이기도 하다.
3. **Inventory Ledger의 이중 기록 구조** — PIT는 Quantity On Hand, PIAT는 Allocated·Soft Reserved·Damaged·On Hold. 재고 감사 체인의 근간.
4. **Proactive Service Operations** — CMDB를 매개로 IT 인시던트와 고객 케이스를 연결해 고객이 신고하기 전에 대응.
5. **IT Compliance의 256+ 커넥터 기반 연속 증거 수집** + Controls Coverage AI 추천 + 규제 조항까지 역추적되는 AI 정책 작성.

---

## Field Service

> 랜딩이 나열한 축: **Patch Notes · Customer Engagement · Mobile · Operations · Scheduling and Optimization**. **Field Service Operations 페이지는 제목과 한 줄 소개만 있고 하위 항목이 없다**(원문 상태 그대로).

### Patch Notes — 추출 상태 주의

`rn_fieldservice_desktop_updates`(22,201자)와 `rn_fieldservice_mobile_patch_notes`(17,344자)는 **월별 개별 버그 수정 나열**이라 소스 덤프가 앞부분 약 1,800자만 담고 나머지를 생략했다. 따라서 **패치 노트는 이 노트에서 전수가 아니다.**

- **Desktop — August '26 Platform (262.13)** 확인분: Dispatch Console의 **polygon** 이슈 다수(액션 패널 미개방·포인터 이탈, Escape/Tab 미동작, 외부 맵 polygon 메뉴의 커스텀 액션 누락), **map** 이슈 다수(live location 중복·spider가 맵 레이어 무시, 배경 대비 낮은 resource marker, 맵 예외, 저장 안 된 polygon 미삭제, Change Status polygon 액션이 hover 대신 click에서 열림), 맵이 닫힌 채 로드 후 새로고침 시 polygon 미표시, side panel 열림 시 marker 선택 상태 미표시, 맵→간트 드래그 중 popover 표시, route 검색 후 territory 선택 시 검색 결과 대신 전 리소스 경로 표시, 배정 없는 날짜 이동 시 View Route 표시기 누락, 날짜 전환 시 route 선택 초기화, 외부 맵 View Route 로딩 표시기 누락, **RTL 레이아웃 이슈 다수**
- **Mobile — July '26 iOS/Android (262.2)** 확인분: **list view 날짜 필터 확대**(this week·this quarter 등), Data Capture lookup 필드의 값 chip 중복 표시, 번들 service appointment 정렬 오류, Agentforce 액션 권한 부족 사용자 경험 개선, 주입된 record ID 입력 변수로 네이티브 모바일 플로우가 첫 화면에서 종료되던 문제. **iOS 전용**: 모바일 플로우 숫자 필드가 검증 수식에서 텍스트로 비교되던 문제, integer 필드가 소수 입력을 반올림하지 않고 거부하던 문제, 신규 레코드 편집 뷰의 time picker 간격 미반영, 로딩 중 상세 데이터 변경 시 크래시, 위젯 service appointment·알림·탭 내비게이션 크래시, 네이티브 모바일 플로우 실행 시 user ID·parent ID 입력 변수 미수신, 빈 필드를 생략하지 않고 공백 텍스트로 전송해 null 검사 분기를 오도하던 문제, 비-지리공간 맵 액션이 부모 work order ID를 못 받던 문제. **Android 전용**: 레코드 생성 시 선택한 record type 미적용, 서명 등 다이얼로그 크래시

### Field Service Customer Engagement — Visual Remote Assistant (VRA) 4건

공통 Where: **Enterprise·Unlimited·Developer + Field Service 관리형 패키지 + Visual Remote Assistant 설치.**

| 항목 | 내용 |
|---|---|
| **Record Audio-Only VRA Sessions for Privacy and Compliance** | 통화 중에는 **전체 라이브 비디오 유지**, 세션 아카이브에는 **음성 스트림만** 저장. PII를 저장 녹화에서 배제한 음성 감사 추적 확보. App Launcher → **Visual Remote Assistant Configuration** → Session Recording Settings → **Audio-Only Recording** 활성화. 켜면 **세션 오디오 토글이 기본 활성**이 되어 모든 녹화 세션이 음성만 담고 **비디오 파일은 저장되지 않는다**. 아카이브는 **Visual History 컴포넌트**에서 확인 |
| **Maintain Voice Communication When Switching to VRA Photo Capture Mode** | 라이브 비디오 → 사진 촬영 모드 전환 시에도 **음성 연결 유지**. 이전엔 모드 전환이 음성 연결을 끊어 재접속하거나 외부 전화를 써야 했다 |
| **Track Real-Time Customer Onboarding and Session Activity in VRA** | **Session Activity 패널**로 링크 전달·약관 동의·**카메라/마이크/위치 권한 부여** 등 마일스톤을 실시간 추적. 세션 시작 시 VRA 작업공간 **우측 기본 뷰**로 열리며, 고객이 모바일 브라우저에서 온보딩을 진행하면 **체크마크와 타임스탬프**가 실시간 갱신 |
| **Protect Sensitive Data by Recording Only Key VRA Moments** | **On-Demand Session Recording** — 한 세션에서 녹화를 **여러 번 수동 시작·중지**. 설치 증빙·일련번호 확인·수리 시연 등 필요한 구간만 녹화. 이전엔 **세션 전체를 녹화**했다. Visual Remote Assistant Configuration → Session Recording Settings → On-Demand Session Recording. 녹화 클립은 Salesforce **Visual History**의 세션 레코드 → **Session Recording** |

### Field Service Mobile

| 항목 | Where / How |
|---|---|
| **Send Field Service Technicians to a Custom LWC from a Push Notification** | Enterprise·Unlimited·Developer + Android/iOS 앱. 커스텀 알림이 Target ID에 더해 **Target Page Reference** 를 지원. Flow Builder의 **Send Custom Notification** 액션에서 Target Page Reference에 JSON 페이지 참조(예: 커스텀 LWC 탭의 **`standard__component`** 참조)를 설정. **둘 다 설정하면 page reference가 우선한다** |
| **Work in Arabic in the Field Service Mobile App (Beta)** | Android·iOS 모두 아랍어 제공. **Beta Services Terms 적용** |
| **Show Only Applicable Work Step Actions** | **Not Applicable 액션 숨기기.** Who: **Customize Application 권한**. Setup → Work Plans → *Hide the Not Applicable option on Work Steps*. **기본 꺼짐**. 저장 후 **다음 동기화에 모바일 반영**(로그아웃 불필요), **오프라인에서도 숨김 유지**. **Not Applicable은 여전히 유효한 Work Step 상태**로 레코드 편집·API·Apex·플로우·데이터 임포트로 설정 가능 |
| **Alert Technicians to Emergency Dispatches with a Distinct Notification** | 고유한 소리 + 강한 진동. Setup → **Field Service Mobile Settings** → *Send emergency appointment notifications on dispatch*. Salesforce는 **service appointment의 Emergency 필드**로 응급 여부를 판별. **응급 사운드는 관리자 제어** |
| **Boost Field Productivity with Native Salesforce Mobile Flows** | 모바일 앱의 플로우가 **네이티브 아키텍처**에서 실행 — 로딩 속도·내비게이션·저장 공간 개선, 오프라인 능력 강화. **플로우 화면이 표준 레코드 폼 디자인과 일치하게 되어 다수 필드·컨트롤의 UI가 바뀐다** |

**Data Capture (3건)**

| 항목 | 내용 |
|---|---|
| **Open a Cleared Form from a Deep Link** | 외부 앱이 앱을 실행하며 폼을 여는 딥링크에 **`fsl__restart=true`** 파라미터를 추가하면 **이전 입력값이 비워진** 폼이 열린다. 이전엔 앱이 값을 유지해 딥링크가 기존 입력이 남은 폼을 다시 열었다 |
| **Complete Dynamic Data Capture Forms in One Voice-to-Form Session** | 한 번 말하면 **숨겨진 필드를 드러내며 올바른 순서로 값을 매핑**. 이전엔 아직 보이지 않는 필드의 발화 값이 매핑되지 않아 분기형 폼을 여러 번 실행해야 했다 |
| **Get a Cleaner Look for Data Capture Forms** | 입력·컨테이너에 **둥근 모서리**. **설정 없이 기본 적용**되며, 기본 스타일을 오버라이드해 브랜드 색상을 덧입힐 수 있다 |

### Field Service Scheduling and Optimization — Enhanced Scheduling and Optimization

공통 Where: **Lightning Experience + Salesforce Classic**, Enterprise·Unlimited·Developer + **Field Service 관리형 패키지 설치**.

| 항목 | 내용 |
|---|---|
| **Seamlessly Book and Schedule Multiday Service Appointments** | **Schedule · Get Candidates · Optimize · Book Appointment** 액션이 arrival window commitment를 포함한 **다일(multiday) 예약을 완전 지원**. **최대 검색 지평(search horizon)은 30일**이며 **약속이 그 창 안에 완전히 들어가야** 가용 슬롯으로 표시된다 — 예: **30일 지평에서 7일짜리 약속을 검색하면 마지막 6일의 슬롯은 나오지 않는다.** Setup → Field Service Settings에서 **Field Service Enhanced Scheduling and Optimization** 활성 확인 → service appointment 레코드의 **Book Appointment** 액션(없으면 quick action을 페이지 레이아웃에 추가) |
| **Improve Productivity and Efficiency by Optimizing Multiday Service Appointments** | 최적화 엔진이 다일 약속을 **이동·드롭**할 수 있게 되어 스케줄 공백을 메운다. 이전엔 각 약속을 독립적으로 스케줄하고 **최초 배치 후 다일 배정을 고정(lock)** 해 전체 품질이 제한됐다. 동작: 스케줄 지평 전체에 최적화를 돌리면 엔진이 **같은 현장(site)의 작업을 한 작업자에게 연속 블록으로 묶고**, 이후 신규 약속을 그 클러스터로 자동 통합해 같은 방문에 처리하게 한다. **고우선순위 응급이 들어오고 여력이 없으면 낮은 우선순위 작업을 드롭하되 현장 연속성은 유지**한다. 대상 산업 예: 풍력 단지 유지보수·태양광 설치·통신 롤아웃·유틸리티 수리. 설정: Field Service Settings 활성 확인 → App Launcher의 **Field Service Admin** 앱 → Field Service Settings 탭 → Scheduling → **General Logic** → **다일 체크박스 필드 매핑 확인** |

### ⭐ 대표 신기능
1. **다일(multiday) 서비스 약속의 예약·최적화 정식 지원**(검색 지평 30일 · 현장 연속성 클러스터링).
2. **VRA 프라이버시 3종** — 오디오 전용 녹화 · 온디맨드 구간 녹화 · Session Activity 실시간 추적.
3. **모바일 플로우 네이티브 전환**(UI 변경 동반) + 커스텀 알림의 Target Page Reference.

---

## Commerce (Agentforce Commerce)

> *"Commerce is now Agentforce Commerce."* 랜딩이 커버한다고 밝힌 범위: **B2C Commerce · B2B Commerce · Omnichannel Inventory · Salesforce Order Management · Salesforce Point of Sale · Salesforce Payments**. 다만 **Winter '27 추출 범위에 실제 내용이 있는 것은 B2C 배포 일정 · B2B Commerce · Salesforce Payments 셋뿐**이다(Omnichannel Inventory·Order Management·Point of Sale은 이번 추출에서 리프가 나오지 않았다).

### B2C Commerce — 2026 배포 일정

B2C Commerce는 코어 릴리즈와 별개로 **연 10회 메이저 릴리즈(26.1~26.10)** 를 **4단계 phase**로 배포한다. **Winter '27 릴리즈 노트에 포함되는 것은 26.10 하나**다(26.1~26.5 = Spring '26, 26.6~26.9 = Summer '26).

| 26.10 단계 | 날짜 |
|---|---|
| Preview | **9월 29일 (화)** |
| Preview Update | **10월 6일 (화)** |
| Major: AUS PODs | **10월 13일 (화)** |
| Major: JAPAN PODs & PODs 283/282, 290/291, 293/292, 295/294 | **10월 15일 (목)** |
| Major: EMEA PODs (PODs 284/285, 270/271, 240/241, 330/331 제외) | **10월 22일 (목)** |
| Major: 나머지 AMER PODs & EMEA PODs 284/285, 270/271, 240/241, 330/331 | **10월 29일 (목)** |

- 배포 날짜는 변경될 수 있고 **통상 공지일로부터 1~2주 내** 진행된다.
- **프로덕션 릴리즈는 현지 POD 시각 02:00~07:00** 사이.
- **On-Demand Sandbox 릴리즈**도 02:00~07:00 창: **ODS-US = EST · ODS-AP = JST · ODS-EU = BST**.

### B2B Commerce

**Cart · Checkout · Shipping**

| 항목 | 내용 |
|---|---|
| **Let Buyers Save Orders to a Template for Reuse** | 개별 제품 또는 카트 전체를 **order template**에 저장해 재주문 시 카트를 다시 채운다. 템플릿은 **번들 옵션·수량·구독 선택**까지 유지. 주문 시 **여러 템플릿을 한 카트에** 추가 가능. **신규 B2B 스토어에는 자동 활성화**되고, **기존 스토어는 Experience Builder로 product·cart·navigation·profile 페이지에 컴포넌트를 추가**해야 한다 |
| **View When Orders Are in Pending or Failed State** | 주문 직후 pending/failed 상태를 구매자가 확인. 이전엔 확인 페이지에 주문 기록이 아예 없었다. **이번 릴리즈 이전의 pending 주문은 Order History에 나타나지 않는다.** Experience Builder → Order List 컴포넌트 → **Show Pending and Failed Orders** → 스토어 게시 |
| **Automatically Release Reserved Resources for Failed Orders** | 주문 실패 시 예약된 항목을 해제해 재고 불일치 방지. **결제 취소(payment reversal)는 별도로 구성**하며, 자체 post-order 정리 메커니즘을 쓸 수도 있다. B2B 스토어 설정 → Checkout → *Release reserved resources on failed orders* |
| **Automate Email Notifications for Failed Orders** | 카트가 **Failed** 상태면 구매자에게 **Order Creation Failure** 이메일 발송. **pending 카트에는 발송되지 않는다.** 스토어 설정 → Messaging → 해당 이메일 템플릿 활성화 |
| **Update Stores Prior to Summer '25 That Use Place Order Orchestration** | **Summer '25 이전에 만들어졌고 Place Order orchestration을 쓰는 B2B 스토어는 Order Ingestion job에서 제외**된다(Order Ingestion job = 체크아웃·카트를 주문으로 바꾸는 백그라운드 프로세스). 해당 스토어의 카트·체크아웃 세션을 job이 건너뛴다 |

**Commerce Promotions**

- **Extend Category Promotion Rules to Subcategories** — **B2B·D2C Commerce, Enterprise·Unlimited·Developer.** 카테고리 프로모션을 **하위 카테고리까지 단일 규칙으로 확장**(서브카테고리마다 규칙을 만들 필요 없음). 계층 전반의 적용 방식은 **advanced rule**로 제어. 프로모션의 Category 타입 qualifier/target 추가·편집 시 **Apply to sub-categories** 선택.

**Commerce Subscriptions (6건)**

| 항목 | Where | How |
|---|---|---|
| **Offer Configurable Subscription Products and Bundles** | B2B Commerce, Enterprise·Unlimited·Developer | product selling model 선택 → price book entry 추가 → 구독 제품을 **configurable로 표시** → bundle configurator 플로우에서 구매자가 구성할 필드 선택 후 게시. 구매자는 **selling model·구독 기간·동적 속성**을 카트 담기 전에 구성 |
| **Set Exact Prices for Subscription Products with Override Adjustments** | B2B Commerce, Enterprise·Unlimited·Developer + **Revenue Cloud Advanced Edition** | 현재가 기준 할인 계산이 아니라 **고정 판매가** 지정. Store Settings에서 **Advanced Pricing for Commerce Powered by Revenue Cloud** 켜기 → Price Adjustment Tier 생성/편집 시 tier type을 **Override** 로, 대상 product selling model 선택 |
| **Drive Subscription Sales with Promotions** | B2B Commerce, Enterprise·Unlimited·Developer | 구독 구매와 **양(positive)의 수정(amendment)** 에 프로모션 적용, **monthly·yearly 등 특정 selling model 타깃팅**. B2B Commerce가 구매·수정·갱신 시 **적용 가능한 자동 프로모션을 평가**한다 |
| **Apply Contract Pricing Across a Subscription's Lifecycle** | B2B Commerce, Enterprise·Unlimited·Developer + **Revenue Cloud Advanced** | 구독의 **amend·renew·cancel 시에도 계약 가격 적용**. 주문 후 계약이 order line item에 **스탬프**되어 이후 작업에 사용. **selling model별로 계약 item price를 따로 생성**. 계약 해석을 바꾸려면 pricing extension에서 Apex **`resolveContracts`** 메서드 구현 |
| **Extend Pricing Procedure Plans to Subscription Products** | B2B Commerce, Enterprise·Unlimited·Developer + **Revenue Cloud Advanced Edition** | Pricing Procedure Plan이 구독 제품과 amend·renew·cancel 작업을 지원. **pre-execution·post-execution Apex hook이 구독 라이프사이클과 Configurator 플로우에서도 실행**된다 |
| **Apply Pricing Adjustments to Subscription Products** | B2B Commerce, Enterprise·Unlimited·Developer + **Revenue Cloud Advanced Edition** | **volume-tiered 가격 조정**이 구매·수정·갱신 플로우의 구독 제품에 적용. 구독/비구독 혼합 카탈로그에 **동일한 가격 규칙** 사용, **표준·계약 가격 모두 지원**. price adjustment tier 생성 시 적용 대상 selling model 선택 |

### Salesforce Payments

공통 Where: **B2B Commerce, Enterprise·Unlimited·Developer + Salesforce Payments.**

| 항목 | 내용 |
|---|---|
| **Pass Custom Gateway Metadata in a Pay Now Payment Flow** | **Payment Link 오브젝트의 Custom Metadata 필드**로 인보이스 ID 등 자체 식별자를 결제 게이트웨이에 전달해 나중에 회계 시스템과 대사. Flow Builder에서 **Generate Payment Link 플로우**를 커스터마이즈 |
| **Add Amazon Pay as a Saved Payment Method** | Apple Pay·Google Pay에 이어 **Amazon Pay 저장 가능**. **Stripe 결제 게이트웨이를 통해 제공** |
| **Offer More Stripe and Adyen Payment Methods at Checkout** | **Stripe**: 캐나다 **ACH**·**PAD**(Pre-Authorized Debit) 직불, 뉴질랜드 **BECS**(Bulk Electronic Clearing System). **Adyen**: **Affirm · Klarna · Bancontact** |

### ⭐ 대표 신기능
1. **구독 커머스 6종 확장** — 구성 가능한 구독 번들, Override 가격, 프로모션, 계약 가격 라이프사이클, Pricing Procedure Plan, volume-tier 조정.
2. **실패 주문 처리 3종** — 예약 자원 자동 해제 · 실패 알림 이메일 · pending/failed 상태 노출.
3. **결제 수단 확대** — Amazon Pay 저장, Stripe ACH/PAD/BECS, Adyen Affirm/Klarna/Bancontact.

---

## Marketing

> 랜딩이 나열한 축: **Marketing Cloud Next(= Agentforce Marketing) · Marketing Cloud Account Engagement · Marketing Cloud Engagement · Marketing Intelligence · Salesforce Personalization · Loyalty Management · Real-Time Offer Management · Referral Marketing**. 이 노트는 Loyalty·RTOM·Referral을 **분량 때문에 아래 별도 섹션**으로 뺐다.

### Marketing Cloud Next — Agentforce 신규 에이전트 2종

| 에이전트 | 내용 |
|---|---|
| **Agentforce Marketing Goals Agent** | 고객 개인별로 **캠페인·채널·콘텐츠·타이밍**을 선택하는 자기 최적화 캠페인. 마케터는 에이전트의 동작을 **완전히 가시화**하고 **자율 처리 범위를 직접 정의**한다 |
| **Agentforce Content Agent** | **email·SMS·MMS·RCS** 캠페인용 개인화·온브랜드 콘텐츠와 이미지를 협업형 AI 작업공간에서 생성·다듬기·게시. **마케팅 브리프·고객 데이터·브랜드 가이드라인에 grounding**. **게시 전 팀 검토·승인** 가능 |

### Campaigns and Flows

- **Automate Follow-Up Tasks with Marketing Completion Actions** — 완료 액션으로 플로우 구성 시간 단축(예: 사용자 알림, 리드를 특정 사용자·큐에 배정). 이전엔 결과마다 **별도 플로우 로직**을 구성했다.
- **Keep Tabs on Campaign Content and Performance Metrics** — 채널을 가로지르는 **캠페인 개요** 뷰. 개요→상세로 내려가며 콘텐츠별 사용 이력 추적.
- **Use Custom Flow Templates from a Campaign** — 캠페인 레코드의 **Browse Templates** 로 커스텀 플로우 템플릿을 선택하면 플로우 생성과 캠페인 연결이 **원클릭**. 이전엔 플로우와 캠페인을 따로 만들고 수동 연결해야 했다.

### Email and Messaging (10건)

| 항목 | 내용 |
|---|---|
| **Test Personalized Content as Any Recipient** | **list·individual·campaign** 수신자 타입 × **email·SMS·WhatsApp·mobile app·RCS** 로 미리보기·테스트 확대. **activation·이벤트·Salesforce 레코드·Apex 클래스**의 샘플 Apex 입력과 콘텐츠 변수 값으로 검증하고, **렌더된 JSON 출력을 직접 검토·편집**해 발송 전 오류 수정 |
| **Fix Tracked Links with Post-Send Link Editing** | **Salesforce 고객지원이 내부 도구로** 발송 완료 이메일의 추적 링크 목적지 URL을 갱신. 재발송·엔지니어링 우회 불필요. 변경은 **해당 게시 콘텐츠 버전의 모든 발송에 적용**되고 **약 5분 내 이후 클릭부터 반영**. **병합 필드가 포함된 링크는 하나의 정적 URL로 리디렉션**된다. 모든 편집은 **사용자·타임스탬프·이전/이후 값**으로 감사 기록 |
| **Localize Emails Faster with Built-In Language Variants** | Email Builder에서 레이아웃을 깨지 않고 다국어 콘텐츠 관리. **내장 에이전트로 번역**한 뒤 component·code·text 뷰에서 변형별로 다듬는다 |
| **Choose the Best Image with Recommenders** | **objective-based Recommender** 가 수신자 프로필·인게이지먼트 이력으로 발송 시점에 최적 이미지를 풀에서 선택. **오픈·클릭으로 계속 학습**해 이후 선택 개선 |
| **Fix Email Deliverability Problems with Step-by-Step Guidance** | 전달률 지표가 악화되면 **Recommendation Details 패널**이 근본 원인·영향받은 캠페인·**영향도 순으로 번호 매긴 개선 단계**를 제시 |
| **Monitor Email Deliverability Health and Receive Automatic Alerts** | **0–100 Email Deliverability Health Score** + 주요 지표가 warning·critical 구간에 들어가면 자동 알림. 대시보드가 이슈와 영향받은 캠페인을 표시 |
| **Archive High-Volume Emails in Your Own Cloud Storage** | 발송된 마케팅 이메일 사본을 **Data 360을 통해 Amazon S3 또는 Microsoft Azure** 스토리지에 저장. **대량 발송자가 Salesforce Archiving 처리량 상한에 걸리지 않고** 모든 발송 사본을 보관하고, 자체 일정으로 조회·회수 |
| **Route Outbound Emails Through Your Own Mail Servers** | 공용 인터넷 대신 **자체 메일 서버로 라우팅**해 컴플라이언스 요구 충족. email relay 구성 + 발신 도메인 배정 + IP 승인. relay가 **bounce·reply·complaint 를 포함한 전체 전달 라이프사이클을 지원**해 전달률 유지 |
| **View an Email as a Web Page** | 보안 웹 버전 링크 추가. 링크는 **발송 시점에 브랜드 도메인으로 해석**된다 |
| **Archive Outbound Emails with Compliance BCC** | 모든 발신 이메일 사본을 지정 주소로. **조직 수준 기본 BCC 주소** 설정 + **캠페인별 오버라이드 허용 여부 제어** |

### Channels (RCS 중심)

**Do More with RCS Messaging in Marketing Cloud Next**

- **Where:** Salesforce **Enterprise·Unlimited** 에디션 + 다음 중 하나 — **Marketing Cloud Next Growth·Advanced**(+ Salesforce Foundations 및 **RCS 애드온**) / **Marketing Cloud Account Engagement Growth·Plus·Advanced·Premium**(+ Salesforce Foundations 및 RCS 애드온) / **모든 Marketing Cloud Engagement+ 에디션**(+ Salesforce Foundations 및 RCS 애드온)
- 향상 항목(원문 전수):
  - **최대 10장의 스와이프 카드** 멀티카드 캐러셀 — 카드별 이미지·설명·개인화 액션/제안
  - **view location · share location · calendar event** 액션 버튼
  - RCS **preference page·communication subscription·data space를 비즈니스 유닛별로 배정**하면서 **RCS 에이전트는 하나를 공유**
  - **Campaign 탭에서 직접** RCS 캠페인 생성·활성화·테스트·관리
  - **Send RCS Message 플로우 요소의 실시간 지표** — 총 실행 수·평균 소요시간 + RCS read·응답률·전달 실패·opt-out율
  - RCS 지원 국가 확대: **오스트리아 · 캐나다 · 콜롬비아 · 체코 · 덴마크 · 도미니카공화국 · 과테말라 · 이탈리아 · 네덜란드 · 노르웨이 · 페루 · 폴란드 · 싱가포르 · 슬로바키아 · 스페인 · 스웨덴 · 우크라이나**
  - **REST API로 On-Demand Flow를 트리거**해 OTP·주문 확인 같은 시간 민감 RCS 발송

| 그 밖의 Channels 항목 | 내용 |
|---|---|
| **Reach WhatsApp Recipients with Usernames via Business-Scoped User IDs** | WhatsApp 사용자가 사용자명으로 전화번호를 숨겨도 연속성 유지. **BSUID로 컨택 임포트**, 전화번호가 없을 때 아웃바운드 발송, **두 식별자 모두에서 인게이지먼트 추적**. Meta의 BSUID를 지원 |
| **Answer Unmatched Inbound SMS and WhatsApp Messages with a Default Response** | 동의 요청·진행 중 대화·플로우 키워드 매칭 어디에도 해당하지 않는 인바운드에 **기본 응답 자동 발신**. 응답하지 않도록 선택할 수도 있다 |
| **Send High Throughput Flash Messages to Targeted Mobile Audiences** | **90초에 최대 500만 건**. 기기 등록 시 **정치·스포츠 관심사 같은 커스텀 속성으로 세그먼트**해 구독시키고, 발송 시 타깃 오디언스를 선택 |

### Audiences · Marketing for Retail · Reporting

| 영역 | 항목 |
|---|---|
| **Audiences** | **Build and Clone Marketing Lists Directly from Your Workflow**(캠페인 레코드 또는 Actionable List 오브젝트 홈에서 임포트, 멤버 포함 복제) · **Automatically Update Consent Data in Record-Triggered Flows**(**Consent Request 플로우 액션** — 예: 신규 리드 옵트인, 연결 opportunity 종료 시 특정 구독 옵트아웃) · **Gain More Control over Preference Page Design and Subscription Content**(채널별 preference page 구축·브랜딩·게시, 메시지↔페이지 연결, 노출 구독 제어, 버튼 텍스트·스타일 변경) · **Skip the Wait When Sending Emails to Contact and Lead Lists** |
| **Marketing for Retail** | **Launch Retail Journeys Faster with Welcome Series Triggers and Flow Templates**(각 템플릿이 **콘텐츠+플로우+수신 대상 규칙**을 함께 제공) · **Notify Shoppers About New Products in a Top Category**(**New Product in High-Engagement Category** 트리거) · **Target Marketing Triggers More Precisely**(커스텀 비활성 기준, 이미 구매한 쇼퍼 제외, 제품 페이지 방문 기반 고의향 필터, 구성 가능한 engagement 값·채널 매핑) · **Distribute Unique Coupon Codes in Your Marketing Messages**(수신자 1인 1코드, 이메일 전달) |
| **Reporting and Analytics** | **Analyze B2B Marketing Impact with Ready-to-Use Dashboards** · **Track SMS Flow and Engagement Metrics in Flow Builder**(Send SMS Message 플로우 요소의 Analytics 탭 — 총 실행·평균 소요·성공/오류 분해 + SMS 발송·전달률·CTR·opt-out율) · **Measure Accurate SMS Click Rates with Bot Click Detection**(**Data Cloud의 human-verified / bot-generated 클릭 지표**로 사람 클릭과 봇 활동 분리, 실제 사람이 탭했을 때만 반응하도록 SMS·MMS 플로우 구성 가능) · **Track Mobile Push Performance in Your Content Performance Dashboard**(**Mobile Push 탭** — KPI 카드에 기간 대비 증감률, **Platform 필터로 iOS/Android 비교**, Engagement 표를 Date Range·Campaigns로 필터) |

**Analyze B2B Marketing Impact with Ready-to-Use Dashboards** — **B2B Analytics for Marketers**가 account·opportunity·campaign·engagement·attribution 데이터를 **Tableau Next 대시보드**로 통합. ABM 성과·파이프라인 영향·캠페인 수익·딜 속도·어트리뷰션을 한 곳에서 검토.
**Where:** Salesforce Enterprise·Unlimited + **Marketing Cloud Next Growth·Advanced**(+ Salesforce Foundations 애드온) / **MCAE Growth·Plus·Advanced·Premium**(+ Foundations) / **모든 Marketing Cloud Engagement+ 에디션**(+ Foundations). **When: 2026-08-10부터.** **How:** Setup → **Marketing Cloud Assistant Home** 에서 구성.

### Setup and Admin · Development & APIs

| 항목 | 내용 |
|---|---|
| **Set Up Marketing Cloud Next in One Place with Salesforce Go** | **Initial Setup 페이지**에서 마케팅 앱 설치·데이터 스트림 배포·선행 조건 완료·**Identity Resolution 구성**까지. **Channels · Einstein · Optimization · Analytics** 로 필터 |
| **Extend Marketing Cloud Next Access to Platform Plus Users** | **Platform Plus 사용자 라이선스** 마케터가 캠페인 생성·이메일 발송을 포함한 **모든 마케팅 워크플로**를 수행. **Marketing Cloud Manager + Data 360 권한 세트**를 배정하면 캠페인·컨택·리드와 **30개 이상의 커스텀 오브젝트** 접근 |
| **Republish Your Marketing Cloud Next Landing Pages (Release Update)** | 랜딩 페이지가 구버전 인프라에 호스팅돼 있을 수 있다. **재게시하면 콘텐츠가 그대로 유지된 채** 현재 지원 인프라로 이동한다. **강제 시점 → [[Winter '27/Release Updates]]** |
| **Add New Fields and Individual Records Easily to Marketing Objects** | **Data Explorer**에서 마케팅 오브젝트에 필드를 추가하고 개별 레코드를 직접 입력. **비어 있는 오브젝트와 데이터가 있는 오브젝트 모두**에 필드 추가 가능하고 **기존 데이터에 영향 없이** 필드 속성 수정. 소수 레코드는 CSV 업로드 없이 직접 입력 |
| **Manage the Sales Data Kit Independently** | sales data kit이 **선택적·온디맨드 컴포넌트**로 분리(이전엔 필수 마케팅 데이터 킷에 번들). 배포 여부·시점과 업데이트를 **독립 관리** |
| **Centralize Your Web Tracking and Consent Banner Setup** | Salesforce Go의 신규 페이지에서 랜딩 페이지·외부 사이트의 웹 트래킹 설정. 방문자 활동 추적 동의를 받는 **커스텀 배너** 생성 |
| **Create and Manage Content Programmatically Using REST API** | Marketing Cloud Next **CMS의 모든 콘텐츠 타입**을 REST API로 생성·수정·검색. 채널: **Email · SMS · WhatsApp · Mobile App**. **비디오 콘텐츠·콘텐츠 블록·추적 링크·폼**도 관리 |
| **Send Emails with Direct Email Send API** | 한 명 이상 수신자에게 프로그래밍 방식 이메일 발송 |
| **Customize Content with Newly Supported AMPscript and Handlebars Functions** | 마케팅 오브젝트에서 **rowset 구성·row 조회·row claim**, **정규식** 기반 개인화 로직, **MD5·SHA512 해시**(민감 콘텐츠 평문 발송 회피), **impression region** 생성으로 메시지 특정 영역 성능 모니터링 |

> 그 밖 Marketing Cloud Next 축(랜딩 요약만 확보, 리프 미추출): **Content Management**(폴더·콘텐츠 일괄 삭제, **Brand Center + 통합 brand kit**, 스크립팅 기반 콘텐츠 블록 개인화·리포팅, 채널 간 재사용 동적 콘텐츠) · **Distributed Marketing and Alerts**(필수 문구·글자 수 제한, 사전 구축 플로우 템플릿, 비마케팅 사용자용 템플릿 추천 에이전트, 다건 이메일 개인화 일괄 발송) · **Landing Pages and Forms**(커스텀 HTML·Handlebars·AMPscript, **Marketing Sites 탭**으로 사이트 구성 중앙 관리, 더 넓은 데이터 소스 연결).

### Marketing Cloud Account Engagement (MCAE)

- **Disable Email Open and Click Tracking** — 추적·프라이버시 규제 대응. **Account Engagement Settings 페이지에 비즈니스 유닛별 이메일 추적 설정 4종 신설** — **open · implied open · link · advanced metrics** 각각 활성/비활성 선택.
- **Next Gen Features** — MCAE 고객도 Winter '27 Marketing Cloud Next 기능군에 접근한다. 원문이 나열한 영역: Agentforce · Campaigns and Flows · Content Management · Email and Messaging · Distributed Marketing and Alerts · Channels · Landing Pages and Forms · Audiences · Reporting and Analytics · Setup and Admin · Development & APIs.

### Marketing Cloud Engagement (MCE)

랜딩이 밝힌 축(리프는 대부분 제목 계층):

| 축 | 요약 |
|---|---|
| **Marketing Cloud Engagement+** | **Salesforce Go의 단일 가이드 설정**으로 MCE를 Data 360에 연결. **Identity Resolution match rule 추가**로 더 완전한 고객 프로필. **Agentforce 에이전트를 통한 양방향 대화형 이메일** |
| **Journey Builder and Automation Studio** | Automation Studio 활동이 **대소문자와 무관하게** filename 치환 토큰 처리. Journey Builder의 **이메일 주소 중복 제거**로 중복 발송 방지. **Journey Notifications 대시보드**가 이슈·경고를 통합 표시 |
| **Messaging** | **Business-Scoped User ID**로 전화번호를 숨긴 고객 대응, **여러 MCE 계정을 하나의 Data Cloud 인스턴스에 연결**, **Direct Send 템플릿 카테고리 불일치**를 계정 제한 발생 전에 포착 |
| **Security** | 상태 점수 모니터링용 **통합 보안 대시보드**, **Advanced Audit Trail의 Data Extension 접근 로깅**, **Touch ID·Face ID 등 피싱 저항 MFA(PR-MFA)** 지원, **권장 IP 범위 기반 로그인 allowlist 관리**, 중요 보안 작업 전 **step-up 인증(재인증)**, 설치 패키지 **API client secret 요약 대시보드**, **유출 시 client secret 자동 폐기** |
| **MCP 서버 확장** | **Expand Marketing Operations Automation with New Tools for the MCP Server** — MCP 서버에 **도구 40종 추가**. MCP 호환 AI 어시스턴트가 Automation Studio 활동 생성·실행, 캠페인·Content Builder 폴더 관리, **대량 데이터 upsert**, data extension 쿼리, 컨택 삭제(erase), 이메일 추적 이벤트 조회를 수행. 이 도구들은 **코어 API 기능을 호출**한다 |
| **Archived Release Notes** | **Spring '24 이전** MCE 릴리즈 노트는 PDF 다운로드로 제공. Summer '24~직전 릴리즈는 툴바 드롭다운에서 선택 |

### Salesforce Personalization

> 원문 프레이밍: *"Salesforce Personalization in Marketing Cloud Next enhancements includes updates for **both the Salesforce Personalization and Marketing Cloud Personalization products**."* — 이 절의 변경은 **Salesforce Personalization과 Marketing Cloud Personalization 두 제품 모두**에 걸친다. 원문은 두 제품의 기능·변경이 *"released as often as monthly"* 라고도 밝힌다.
>
> 아래 두 항목은 모두 원문 Release Note Changes(August 2026)에 **"(Added the week of August 17, 2026)"** 로 기록돼 있다 — **2026-08-17 주에 릴리즈 노트에 추가**된 항목이라는 뜻이며(기능 가용 시점이 아니라 노트 등재 시점), 원문에 별도 가용 시점 표기는 없다.

- **Analyze Experiment Results with the Data Visualization Tab** *(릴리즈 노트 등재: 2026-08-17 주 — 원문 "Added the week of August 17, 2026")* — A/B 테스트 결과를 **control cohort와 비교**. 요약 카드가 **최고 성과 변형과 승리 확률(odds of winning)** 을 제시하고, 성과 차트·일별 등록 차트로 추세 표시.
- **Deliver Personalized Mobile Experiences Without Rebuilding Your App** *(릴리즈 노트 등재: 2026-08-17 주 — 원문 "Added the week of August 17, 2026")* — **로우코드 모바일 개인화**. 개발자가 컴포넌트와 콘텐츠 존을 **한 번** 정의하면 이후 현업이 코드 없이·앱 배포 없이 개인화 경험을 생성·미리보기·게시. 개인화 콘텐츠는 **앱에서 네이티브 렌더링**되고 상호작용은 **Data 360으로 전송**돼 이후 개인화를 정교화한다. 지원: **iOS · Android · React Native · Flutter**.

### Referral Marketing

- **Boost Referral Conversion in Mobile-First Markets with SMS Notifications** — advocate가 **휴대폰 번호**로 친구를 추천하면 Referral Marketing이 문자를 보낸다. 위젯에서 **휴대폰·이메일·둘 다** 중 무엇을 수집할지 구성. **문자 발송은 커뮤니케이션 방식이 Marketing Cloud Next일 때만 가능**하다.
- **Monitor Referral Promotion Performance by Using Tableau Next Dashboards** — 추천 참여·전환율·재무 성과 인사이트. advocate 참여·친구 가입·친구 활동 추적, **발생 수익과 리워드 부채(reward liability)** 측정. **이전엔 CRM Analytics에서만 제공**되던 기능.
- **Simplify Referral Widget Deployment with Lightning Out 2.0** — 자동 생성 HTML 스니펫으로 외부 사이트·Experience Cloud 사이트에 위젯 임베드. **디자인·콘텐츠·동작 변경이 코드 재배포 없이 즉시 반영**. 이전엔 수동 임베드와 변경 시마다 재임베드가 필요했다.

### ⭐ 대표 신기능
1. **Agentforce Marketing Goals Agent · Content Agent** 신규 2종(자기 최적화 캠페인 + 온브랜드 콘텐츠 생성).
2. **RCS 대폭 확장** — 10장 캐러셀·위치/캘린더 액션·Campaign 탭 관리·플로우 요소 지표·17개국 추가.
3. **이메일 전달률 운영 3종** — 0–100 Health Score·자동 알림, 단계별 개선 가이드, **발송 후 추적 링크 수정**.
4. **MCE 보안 강화 묶음**(PR-MFA·step-up 인증·client secret 자동 폐기·Data Extension 접근 감사).

---

## Analytics

> 랜딩이 밝힌 범위: **Tableau Next · Lightning Reports and Dashboards · Data 360 Reports and Dashboards · CRM Analytics · Tableau**. Winter '27에서 **본문까지 확보된 것은 CRM Analytics뿐**이고, Reports and Dashboards·Data 360 Reports의 개별 기능은 제목 계층에 있다.

### Tableau Next — Winter '27 자체 신기능은 아직 없다

원문: *"Tableau Next features and updates are **released monthly**. Check back in this section throughout Winter '27 to learn about enhancements in Tableau Next's open data layer, semantics, visualizations, integrated actions, and analytics apps."*

즉 **Winter '27 초기 발행 시점에 Tableau Next 섹션의 유일한 항목은 `Tableau Next Highlights`(직전 릴리즈 Summer '26 리캡)** 다. 하이라이트가 정리한 Summer '26 기능 영역은 **Setup and Administration · Tableau Agent · Semantics · Tableau Next MCP · Data · Marketplace · Metrics · Visualizations · Dashboards · Templates · Development · Tableau Next Apps for Salesforce** 12개이며, 각 항목은 **Salesforce Help·개발자 가이드·영상·블로그 링크 목록**이라 이 노트에 옮길 기능 본문이 없다.

> Tableau Next는 Winter '27 기간 중 월별로 추가된다 — **이 노트의 "Tableau Next 신기능 0건"은 발행 시점 기준**이며, 나중에 재확인이 필요한 열린 항목이다.

### CRM Analytics

공통 Where: **CRM Analytics in Lightning Experience — Developer Edition 제공, Enterprise·Performance·Unlimited는 추가 비용.**

| 항목 | 내용 |
|---|---|
| **Analyze Activities Across Time with Gantt Chart Visualizations** | 렌즈·대시보드에 **Gantt 차트** 추가 — 활동 일정·작업 기간·중복 추적. **필터링·faceting 등 표준 대시보드 상호작용과 통합**. Charts에서 Gantt 선택 → column-map 패널에서 **날짜 형식이 일치하는 필드**를 **Start Date(1)·End Date(2)** 에 배정하고 **category(3)** 선택 → 속성 패널에서 **Dimension Separator (Y-Axis)(4)** 로 카테고리 행 구분선, **Show Vertical Grid Lines (X-Axis)(5)** 로 타임라인 날짜 마커 |
| **Improve Chart Readability with Segment Gap and Border Controls** | 지원 차트: **Bar · Column · Stacked Bar · Stacked Column · Funnel · Pie**. **기본 꺼짐이라 기존 차트는 변하지 않는다.** Formatting에서 **Show Segment Gap(1)** — gap 크기 **1·2·4·8** 중 선택, **Show Segment Border(2)** — 색상 선택기(**기본 흰색**). Explorer 모드의 Formatter에서도 사용 가능. **Why:** 고대비·그레이스케일 출력에서 색 차이가 사라질 때 특히 중요하며, **WCAG 2.1 non-text contrast 요건과 Use of Color 지침(1.4.1)** 충족에 기여 |
| **Customize Data 360 Fields in CRM Analytics** | **data lake object · data model object · calculated insight object** 에 대해 필드 이름 변경·필드 값 편집·차트 색상 배정. **해당 데이터 소스를 쓰는 모든 렌즈·대시보드에 적용**되며 **기저 Data 360 데이터는 변경되지 않는다**. 렌즈 explorer → 데이터 소스명 옆 드롭다운 → **Show Fields Panel** → 필드 액션 메뉴 |
| **Subscribe to Data 360 Live Widgets in CRM Analytics** | Data 360 **라이브 데이터셋** 기반 대시보드·위젯의 **예약 이메일 스냅샷**. **hourly · daily · weekly · monthly** 중 선택 + 발송 시각·타임존 지정. **수신자는 기존 권한으로 접근 가능한 데이터만** 본다. 실행 모드에서 위젯 액션 메뉴 → **Subscribe** |
| **Protect Your Work with a Dedicated CRM Analytics Recycle Bin (Generally Available)** | 삭제된 대시보드·렌즈를 전용 휴지통으로 이동. 보존 기간 중 **연결된 구독·알림은 자동 일시정지**. 편집 모드의 Action 메뉴 → **Move to Recycle Bin**. 홈 페이지에서 휴지통 접근, **복원 가능 기간 30일** 후 영구 삭제 |
| **Expand Analytic Workflows with Increased Dashboard Page Limits** | 단일 대시보드 페이지 상한을 **최대 30페이지**까지 요청 가능(**이전 상한 20**). 이전엔 별도 대시보드를 연결하고 필터 구성을 중복해야 했다. **How: Salesforce Support에 상향 요청** |
| **Customize Table Column Widgets with Flexible Column Visibility** | 테이블 위젯에서 컬럼을 **동적으로 숨기고 재정렬**(대시보드 수정 없이). 작성자는 편집 모드에서 **컬럼 너비를 직접 지정**. 컬럼 헤더 액션 메뉴에서 고정(freeze)·이동 선택, 헤더 경계선을 드래그해 너비 조정. 이전엔 테이블 구조가 고정이라 사용자별로 대시보드 버전을 여러 개 만들어야 했다 |
| **Analyze Your Data More Precisely with Expanded CRM Analytics Measure Support** | measure에 **18자리 정밀도** 지원 — 값 오버플로 오류 방지. **null measure handling이 활성인 조직은 쿼리 성능도 향상**된다. **How: 레시피를 full data sync로 실행**해 데이터셋의 measure 값을 갱신. **Spring '17 이전에 생성된 조직은 null measure handling이 기본 활성이 아닐 수 있다** → Setup → Analytics → Settings → **Allow null measure handling for datasets** 활성화. (이 항목의 Where는 **Developer·Enterprise·Performance·Unlimited** 로 표기돼 다른 CRM Analytics 항목과 문구가 다르다) |

### Tableau (Tableau Cloud/Desktop/Prep/Server)

Winter '27 릴리즈 노트의 Tableau 페이지는 **제품 소개와 각 제품 릴리즈 노트 링크만** 제공한다 — Salesforce 릴리즈 노트 본문에 기능 항목이 없다.

| 제품 | 원문 설명 | 릴리즈 노트 |
|---|---|---|
| **Tableau Cloud** | 보안·완전 호스팅 클라우드 셀프서비스 플랫폼 | Tableau Cloud Release Notes |
| **Tableau Desktop** | 드래그앤드롭 데이터 시각화 도구 | Tableau Desktop and Web Authoring Release Notes |
| **Tableau Prep** | 데이터 정제·정형·결합 준비 도구 | Tableau Prep Release Notes |
| **Tableau Server** | 자체 환경 배포용 보안 온프레미스 솔루션 | Tableau Server Release Notes |

### ⭐ 대표 신기능
1. **CRM Analytics Recycle Bin GA**(복원 기간 30일, 구독·알림 자동 일시정지).
2. **Gantt 차트** + **segment gap/border**(WCAG 대응) 등 시각화 접근성 개선.
3. **Data 360 라이브 데이터 연계 강화** — 필드 라벨·색상 커스터마이즈, 라이브 위젯 이메일 구독.

---

## Data 360

> *"Data 360 features and changes are released as often as monthly… Changes included in the Winter '27 release are generally listed under **October 2026**."* 즉 Data 360은 코어 릴리즈와 다른 주기로 움직인다. **Winter '27 초기 발행 시점에 본문까지 확보된 것은 Engagement Timeline 하나**이고, 4개 축 페이지(`Get Started` · `Process and Enrich` · `Explore and Optimize` · `Segment and Act`)는 **한 줄 소개만** 있다.

### 리브랜드 재확인

> 원문: *"As of **October 14, 2025**, Data Cloud has been rebranded to Data 360. During this transition, you may see references to Data Cloud in our application and documentation. While the name is new, the functionality and content remains unchanged."*

### Data 360 Engagement Timeline (신규 위젯)

- **무엇:** 인게이지먼트 데이터를 **시간순으로 표시하는 신규 위젯**
- **어디에:** **Account · Contact · Lead · Person Account · Prospect** 레코드
- **Where(에디션):** **Data 360 Developer · Enterprise · Performance · Unlimited**
- **구성:** 관리자가 레코드 페이지를 편집해 **Lightning App Builder**로 위젯 배치. 구성하려면 **Data 360 접근 권한 + Customize Application 권한** 필요
- **조회:** 구성 후 데이터를 보려면 **Data 360 라이선스 + 구성된 data space 접근 권한** 필요

### 4개 축 — 랜딩 설명(본문 미확보)

| 축 | 원문 한 줄 |
|---|---|
| **Get Started with Data 360** | 시작 전 알아야 할 에디션·기능 가용성·가이드라인·과금, 그리고 사용자 관리·기능 활성화 같은 관리자 기능 |
| **Process and Enrich** | 지능형 처리 방식으로 검색·AI를 위한 데이터 준비. Data 360의 **비정형·정형 데이터에 검색을 grounding** 해 생성형 AI·분석·자동화에 활용 |
| **Explore and Optimize** | 클릭·자연어·SQL로 데이터 탐색. **data graph와 secondary index** 생성으로 빠른 조회 최적화 |
| **Segment and Act** | 세그먼트 생성, 외부 데이터 소스와 공유, data action·activation target·activation 생성, 플로우 구축, Data 360 데이터로 조직 강화 |

> 8월 변경 로그가 이 릴리즈 사이클에 추가됐다고 밝힌 두 건도 **제목 계층**이다: *Simplify Your Navigation with the Updated Data 360 Menu*(`rn_cdp_2026_winter_nav_resources`) · *Use the Snowflake Zero-Copy V2 Connector for Enhanced Data Sharing*(`rn_cdp_2026_summer_snowflake_v2`).

### Context Service

| 항목 | 내용 |
|---|---|
| **Track Changes to Context Definitions with Setup Audit Trail** | **Professional·Enterprise·Unlimited·Developer**(Context Service 활성 조직). Setup Audit Trail이 **context definition과 관련 구성 — context node · attribute · tag · mapping · filter** 의 생성·수정·삭제를 기록한다. **Context Service의 transform은 생성·삭제**를 기록. **변경 이력은 180일 보존.** Setup → Audit Trail → View Setup Audit Trail |
| **Hydrate Complete Data 360 Hierarchies in Context Service** | **Professional·Enterprise·Unlimited·Developer**(Context Service **및 Data 360** 활성 조직). DMO 간 부모-자식 관계를 해석해 **단일 hydration 호출로 다단계 계층 전체를 반환**한다. DMO 계층(예: member demographics·health plan enrollment·claims history)을 구성하면 Context Service가 **Data 360의 관계 메타데이터에서 조인 필드를 식별**한다. 효과 3가지: ① AI 워크플로용 완전한 다단계 프로필(누락 데이터로 인한 hallucination 방지) ② **zero-copy DMO 투명 지원** — **Google BigQuery·Databricks·Snowflake** 등 외부 웨어하우스 데이터가 **추가 구성 없이** hydration ③ 기존 Context Node 계층 모델 지원. 이전엔 자식 DMO 데이터를 못 받아 AI 에이전트·추천 엔진·자동화가 불완전한 프로필을 받았다 |

### Data Processing Engine (5건)

| 항목 | 내용 |
|---|---|
| **Control Currency Handling for DPE Definitions** | CRM Analytics 또는 Data 360에서 실행되는 정의의 다중 통화 처리 방식 선택 — **단일 통화로 전부 변환** 또는 **원 통화 유지 후 커스텀 변환 로직 적용**. 이전엔 두 런타임이 서로 달랐다: **CRM Analytics 런타임은 통합 사용자(integration user)의 통화로 변환**, **Data 360 런타임은 원 통화 유지에 목표 통화 선택 불가**. **다중 통화가 활성인 조직에서만** 이 설정이 나타난다 |
| **Reliability Changes in Data Processing Engine** | Data 360 오브젝트·Salesforce 오브젝트·CSV 등에서 더 빠르고 무결하게 실행. **부분 실패 추적** — Monitor Workflow Services에서 미처리·실패 레코드가 있으면 정의 실행과 태스크가 **Completed with Failures** 상태로 표시. **실행 중인 정의는 비활성화할 수 없다** |
| **Roll Up Only the Lowest-Tier Values in Hierarchy Nodes** | 온디맨드 정의에서 **부모 레코드 값을 계층 롤업 합계에서 제외**할지 선택. 자식이 없는 최하위 레코드 값만 집계. 이전엔 계층 집계가 **항상 모든 레코드의 자기 값을 포함**했다 |
| **Simplify Definitions with Multiple Formulas in a Single Node** | **하나의 formula node 안에서 수식을 순차 실행**해 앞선 계산 결과를 사용 |
| **Send Data Transformation Results to Virtual Objects** | CRM Analytics·Data 360 런타임 정의의 출력을 **Apache HBase 기반 virtual object**에 저장하고 조직에서 레코드로 조회. 이전엔 표준·커스텀 오브젝트로만 write-back이 가능했다 |

### ⭐ 대표 신기능
1. **Data 360 Engagement Timeline** — 5개 레코드 타입에 붙는 시간순 인게이지먼트 위젯.
2. **Context Service의 다단계 DMO hydration** — zero-copy(BigQuery·Databricks·Snowflake) 투명 지원.
3. **DPE 통화 처리 통일** + 부분 실패 추적(Completed with Failures) + virtual object write-back.

---

## Industries

> Industries 랜딩이 나열한 산업 전수: **Automotive · Communications · Consumer Goods · Education · Energy and Utilities · Financial Services · Health · Insurance · Life Sciences · Manufacturing · Media Cloud · Net Zero Cloud · Nonprofit · Industries Common Features**. (**Public Sector**는 Winter '27에서 Industries 하위가 아니라 **최상위 랜딩 항목**으로 별도 배치돼 있고, 그 하위 리프 46건은 전부 제목 계층이다.)
>
> ⚠️ **각 산업의 "랜딩 페이지 + 일부 컨테이너 페이지"만 전문 추출**됐다. 개별 기능 리프는 대부분 제목 계층에 있다 — 아래 산업별 표의 항목은 **랜딩·컨테이너가 밝힌 범위**이며, 그 아래 실제 설정 절차·에디션은 이 노트에 없다.

### 산업별 랜딩 요약 (원문 전수)

| 산업 | 랜딩이 밝힌 Winter '27 범위 |
|---|---|
| **Automotive** | 연체 계정의 **수금·차량 압류(repossession) 전 라이프사이클** 관리, 리스 만료·사고·압수 같은 **비연체 압류** 처리. **Warranty Claims Adjudication Assistant** 로 청구 처리 가속·지급 리스크 감소·판정 정확도 향상. **Agentforce Sales Concierge를 Experience Cloud 사이트의 고객에게 확장** |
| **Communications** | Agentforce가 엔터프라이즈 규모 견적 생성·구성·갱신 자동화. **Communications Sales Insights** 로 파이프라인·수익 실시간 파악. **Enterprise Sales Management** 가 중앙 가격·경고 처리·복제·멀티사이트/주문 자동화로 견적·카트 실행 단순화. **Revenue Cloud for Communications** 에 제품 관계·쿠폰 통제·기간 할인·**stackability group**·신규 REST API. **Consumer Sales** 는 delta repricing과 **카트→주문 직접 전환**으로 가속 |
| **Consumer Goods** | trade calendar·account plan 헤더 커스터마이즈로 trade planning 조정. 프로모션 계획 가속·데이터 입력 실수 감소. **최대 카테고리 배정에서도 trade calendar 안정 오픈**. **Apex에서 job chain 중단(abort)** 으로 우발적 잡 급증이 업무 처리 지연시키는 것 방지. **시스템 브라우저 인증**과 조직 단위 데이터 필터링 현대화로 모바일 보안·데이터 스코핑 효율 향상 |
| **Education** (**Agentforce Education**, 구 Education Cloud) | 모집·입학·학사 운영·학생 성공·발전(advancement)·동문 참여를 CRM + **SIS(student information system)** 역량으로 지원 |
| **Energy and Utilities** | Agentforce로 멀티사이트 **quote recipient group** 생성·요금제 비교·고객 등록. 멀티사이트 견적에 사이트 데이터 대량 업로드 시 **Slack 알림**. Tariff Comparison의 새 가격 기능에 **`ConsumerSalesContext` context definition** 사용. 멀티사이트의 견적·주문 또는 consumer sales의 카트에 프로모션 적용. **New Connections and Program Management** 로 신규 유틸리티 연결 신청 전 라이프사이클 관리. 비상 시 **union contract 요건을 만족하는 구성 가능한 callout 프로세스**로 복구 팀 배치. 유연한 timesheet 입력으로 정확도 향상 |
| **Financial Services** (**Agentforce Financial Services**) | 은행·자산관리·보험 플랫폼의 고객 데이터를 AI로 통합. 개인화 인게이지먼트·온보딩 가속·고객 충성도 향상. 신뢰 가능한 AI로 재무 계획 인사이트 제공 |
| **Health** | care gap 캠페인 성과를 **사전 구축 Health Engagement 대시보드**로 측정. Agentforce로 약제 급여 질문 응대·24/7 환자 전화 대응·제공자 청구 상세 온디맨드 조회. **Amazon S3에서 파일을 직접 처리**해 문서 추출 가속. **HIPAA 준수 개인화 리마인더**로 노쇼 감소. 면책조항부터 서명까지 통합 플로우로 **Medicare 등록 가속** |
| **Insurance** | **Digital Insurance** 로 보험 상품을 빠르게 혁신·배포·조정. Agentforce의 AI 자동화로 정책·클레임 전 라이프사이클 관리. 유연한 **Insurance Brokerage** 플랫폼에서 producer·account manager 경험 설계. 지역·사업라인을 가로질러 데이터를 통합한 **360도 고객 뷰** |
| **Life Sciences** | 현장 담당자가 **오프라인에서도** 방문 노트를 구술해 레코드 자동 채움. **Order Management** 로 store check 정확 수행 및 일관·투명한 가격의 quoted order 생성. **Event Management** 가 참가자의 계정 과다 이용 또는 예상 경비의 금액 한도 초과를 **실시간 알림** |
| **Manufacturing** (**Agentforce Manufacturing**) | AI 지원·대량 주문 관리·엔터프라이즈 가격·분석·채널 파트너 관리 전반 확장. **Slack의 Industries Sales Assistance** 와 커스텀 에이전트 구축. 내장 주문·가격 워크플로가 **ERP 수준 정확도**를 영업 담당에게 직접 제공. **Tableau Next 분석**과 **Data 360 기반 채널 관리** |
| **Media Cloud** (**Agentforce Media**) | 자동 intake와 AI 생성 요약으로 **RFP 응답** 간소화. 지도 기반 인벤토리 검색·통합 가격으로 **out-of-home(OOH)** 캠페인 기획·판매. 위치·제품·유동인구·인구통계 데이터로 **in-store 캠페인** 구축. **sponsored product** 를 media plan line item에 직접 연결. 인벤토리 **대량 예약**, media plan에 **Data 360 오디언스 세그먼트** 적용 |
| **Net Zero Cloud** (**Agentforce Net Zero**) | **Supplier Engagement** — 공급업체가 데이터를 제출하고 스코어카드를 작성하는 셀프서비스 포털로 지속가능성 보고에 직접 참여 |
| **Nonprofit** (**Agentforce Nonprofit**) | 모금·프로그램·보조금·성과·자원봉사를 최신 CRM 역량으로 지원 |
| **Public Sector** (최상위 배치) | **Taxpayer 360** 으로 납세자 데이터 통합·셀프서비스 포털 제공·**Taxpayer Advocate 에이전트** 응대. 한 신청서로 **복수 급여 프로그램 신청 + 프로그램 간 자격 확인**. 클레임 제출 양식을 워크플로에 맞게 조정, **Outbound Payments** 로 인보이스 데이터 추출. Agentforce로 **면허·허가 intake** 안내, **Inbound Payments** 로 서비스 수수료 수납. AI 셀프서비스·타깃 모집 캠페인으로 구직자 참여. 방문·검사 등 일정 수립과 위치별 담당자 배정. **Amazon S3 파일의 시맨틱 검색** |

### 산업별 세부 — 대부분 랜딩 요약(리프 미추출)

> **이 절의 성격:** 아래 산업별 블록은 대부분 **부모 허브 페이지(`rn_edu` · `rn_ins` · `rn_media_cloud` 등)가 본문에 담은 자식 요약**이다 — 항목당 **1~3문장**이 전부이고 **에디션·Setup 경로·권한·가용 시점은 없다**. 개별 리프 페이지는 제목 카탈로그에 있다. **예외적으로 리프 본문까지 확보된 것은 아래에 그렇게 표시한 블록뿐**이다(예: `rn_media_objects` — New and Changed Objects in Agentforce Media).

**Automotive** — 컨테이너 페이지가 밝힌 하위 축: **Agentforce for Automotive**(Experience Cloud 사이트에서 차량·제품 검색, opportunity·견적 생성, 시승 예약, **trade-in 감정 개시**, 이메일 초안을 자연어로) · **Managing Automotive Repossession**(사전 압류 평가 → 관리자 승인 → 실제 회수 **3단계**) · **Adjudicate Warranty Claims**(딜러 제출 보증 청구를 수동 또는 자동 프로세스로 판정, 통합 레코드 뷰와 **승인 가능성 예측**) · **Set Up Automotive Features with a Single Click**(Salesforce Go에서 Agentforce Automotive 사전 구성 솔루션 설치 — **Connected Vehicle**·**Auto Finance Service Process** 구성을 원클릭 배포) · **New and Changed Objects for Automotive Cloud**.

**Consumer Goods — Retail Execution / Trade Promotion Management**

| 항목 | 내용 |
|---|---|
| **Retail Execution 랜딩** | 배송 중 **선주문 수량 조정·제품 추가/스캔·현금 또는 부분 결제 수납**. **hybrid user persona** 로 배송 업무와 매장·선반 컴플라이언스 점검·리테일 주문 생성 같은 방문 활동을 함께 수행. **mobile linking** 으로 CG 모바일 앱↔외부 앱 양방향 데이터 공유. **3인치 Bluetooth 감열 프린터**로 문서 출력, **LWC 통합**으로 플랫폼 기능 사용 |
| **Visual Studio Code Based Modeler** | **시스템 브라우저 인증** 활성화로 모바일 보안·데이터 스코핑 효율 향상 |
| **Windows Server Based Modeler 은퇴** | **Winter '26(2025년 10월) 은퇴 예정**이며 그때까지 유지보수 모드. **VS Code based Modeler** 로 전환 권고 — 별도 Windows 서버·DB 없이 동등한 모델링 제공. **Salesforce CLI에 완전 통합된 Consumer Goods Cloud Modeler CLI 플러그인** 포함(계약 검증, 커스텀 앱 빌드, 커스텀 CG 오프라인 모바일 앱 시뮬레이션, 배포 패키지 생성) |
| **Customize Trade Planning Pages with a Developer API** | **Lightning Web Component API** 로 Trade Calendar·Account Plan 헤더를 조정. **header·toolbar slot 커스터마이즈와 toolbar 버튼 노출 제어를 관리형 코드 수정 없이** 수행. **state-change 이벤트를 수신**해 페이지 변경에 반응하고, 그리드 새로고침이나 프로모션 생성 프로세스를 **프로그래밍 방식으로 트리거** |
| **Support More Product Category Share Records** | **optimized category-loading 설정**을 켜면 Trade Calendar가 한 사용자에 대해 **최대 13,000 배정(assignment)** 까지 지원하고 초과 시 메시지를 표시한다. 이전엔 원인 표시 없이 페이지 로드가 실패하기도 했다 |
| **Manage Trade Promotions with User Experience Enhancements** | **자동 적용 3종** — ① Promotion Information·Tactic Information·Create Promotion 마법사의 **숫자 필드가 로케일에 맞춰짐** ② Promotion Comment 같은 **장문 텍스트 필드 줄바꿈·확장** ③ Volume Planning·Spend Planning 카드의 **Collapse All 을 원클릭으로 되돌리기** |
| **Changed Apex Class in Trade Promotion Management** | **Apex에서 job chain 중단** — 누적된 잡 백로그를 즉시 멈춰 하루 이상 늘어질 수 있는 큐 지연 방지 |

**Education (Agentforce Education) — 랜딩 요약(리프 미추출) · 부모 허브 `rn_edu`가 담은 자식 요약 전수**

| 항목 | 한 줄 |
|---|---|
| **Track the Complete Student Journey with the Recruitment and Admissions Funnel** | **Tableau Next Recruitment and Admissions Performance Center** 대시보드가 **Suspect · Prospect · Applicant · Admitted · Enrolled · Registered** 단계의 규모·전환율·단계 속도(stage velocity)를 추적 |
| **Accept Transfer Credit Requests from Current Students on an Experience Cloud Site** | 재학생이 **Unified Catalog 서비스**에서 편입 학점 신청서를 열어 사전 학습을 추가·제출 |
| **Configure and Localize the Dynamic Application Experience** | Application List·Application Details 페이지의 **Campus·Academic Term 등 필드 노출/숨김·라벨 지정**, 합격 결정 직접 링크 제공. academic term·learning program 같은 신청 데이터의 **번역 값 활성화**로 언어별 신청서를 따로 유지하지 않는다 |
| **Unify Attendance Signals into One Trusted Record** | 강사·학부모·기기·시스템의 출결 신호를 **학생별 단일 신뢰 결과**로 해소하는 출결 데이터 모델 |
| **Automate Refund Processing for Student Overpayments** | 수강 철회·주문 축소 시 Student Financials가 **원 인보이스 식별 → credit memo를 미결 잔액과 상계 → 환불 개시**. 감사 추적 유지 |
| **Spread Tuition Payments with Flexible Payment Plans** | **월·분기·커스텀** 분납 일정. 결제 게이트웨이 연동 자동 수납, 학생은 learner portal에서 플랜 상태·예정 자동이체 실시간 확인 |
| **Manage Proxy Access to Student Records Through Delegated Access Management** | 학생이 학부모·보호자 등 **proxy를 지정**해 학사·재정·개인 정보 접근을 부여·수정·철회. 기관은 위임 가능한 권한을 구성. **감사 추적으로 기관 거버넌스와 연방 컴플라이언스 지원** |
| **Manage Emergency Contacts and Authorized Pickups for Students** | 고등교육은 학생 본인이, **K-12는 학부모·보호자**가 비상 연락처와 **authorized pickup** 관리. 우선순위 지정 + 전 변경 감사 추적 |
| **Accelerate Proxy Experiences with a Portal Template** | proxy 전용 통합 접근점. K-12는 학부모가 가구·신청·학생 정보를 관리, 고등교육은 지정 proxy가 위임받은 작업 수행 |
| **Post Transfer Credits and Preview Degree Impact** | 승인된 편입 학점을 program plan에 배정. 성적 편집·부여 사유 선택·**일괄 작업**. **시각화 패널이 커밋 전에 잔여 학위 요건 변화**를 보여줘 필수 과목 우선 배정·중복 방지·학점 비율 이해가 가능 |
| **Automate Faculty Access to Course Data with a Standardized and Secure Model** | 강의 배정 기준으로 접근 부여·회수. 교원은 **현재 가르치는 과목만** 보고 **학기 종료 시 접근이 자동 만료**. academic role 권한을 한 번 구성하면 자동화 워크플로가 관리하고, **불변(immutable) 감사 추적** 제공. **커스텀 공유 규칙 없이** 표준화 데이터 모델 위에서 동작 |
| **Keep Student Records Accurate as Curricula Evolve with Course Versioning** | 과목명 변경·학점 조정·선수과목 변경 시 **새 버전 생성**. 학생이 이수한 버전을 진도·학위 감사에서 보존하고 **여러 버전을 동시에 운영**. **어느 버전이든 동일 프로그램 요건을 충족**하므로 program plan이 정확하게 유지 |
| **Discover and Set Up More Education Features in Salesforce Go** | Alumni and Advancement · Recruitment and Admissions · Student Financials · Delegated Access Management · Transfer Credit · Petitions and Waivers 를 한 곳에서 발견·활성화·구성 |
| **Automate HESA Regulatory Calculations** | **Calculated Insights**로 Data Cloud에서 영국 **HESA** 규제 값 산출. 운영 데이터 수집과 규제 로직을 분리해 스키마 변경 없이 계산을 발전시킨다. 프로그램 등록 시 **HESA Student Identifier 자동 채움**. **HESA Data Futures** 제출 대비 |
| **Extend Institutional Data for MortarCAPS Reporting and Intelligence** | 호주·캐나다 등의 규제 준수를 지원하는 표준 데이터 구조. **MortarCAPS Compliance and Configuration**을 켜면 기존 오브젝트에 **MortarCAPS Higher Learning Data Standards** 정합 필드·메타데이터가 추가된다. 수동 매핑·외부 데이터 웨어하우스 없이 제출 검증·분석 수행 |
| **Agentforce for Education — Share Billing Details with Your Students** | 학생이 상세 인보이스·결제 일정·분납 플랜 조회. 여러 액션을 통합 플로우로 묶어 **환불·결제·credit memo 잔액**을 한 번에 표시. 학기별 요금 내역 정확도를 위한 학기 등록 로직 강화 |
| **Agentforce for Education — Resolve Student Absences with the Attendance Management Agent** | **Marketing Cloud Next 이벤트 트리거 플로우**로 가정에 SMS 발송 → **인바운드 Omni-Channel 플로우**가 음성 에이전트와의 자연어 대화로 연결 → **Attendance Management Agent** 가 학부모 설명을 수집해 공식 출결 기록을 갱신하고 **담당 강사에게 즉시 Slack 알림** |
| **New and Changed Objects in Education** | 신규·변경 Education 오브젝트 |
| **Fundraising (공통 기능)** | 가구(household) 이름을 **수식 기반 자동 명명**으로 유지 — 가족 구성 변화에 따라 자동 재계산. **gift entry에서 직접 가구 생성** |

**Financial Services (Agentforce Financial Services)**

| 항목 | 내용 |
|---|---|
| **Set Up Agentforce Financial Services from One Place** | **Financial Services Initial Setup** 한 페이지에서 필수 역량 활성화. 필수 구성 단계를 **단일 체크리스트**로 진행, 비즈니스 목표에 맞는 기능을 **adoption path**로 확인, 설정 진행률과 **권한 세트 라이선스 사용량**을 한 곳에서 추적 |
| **Agentforce for Financial Services — Create Agents in the New Agentforce Builder** | Agentforce Studio의 **새 Agentforce Builder**에서 FS 에이전트 구축·커스터마이즈. **가이드 설정·내장 AI 지원·Agent Script 기반 워크플로**. **미리보기·테스트·trace·디버그** 지원. *"More financial services agents move to the new builder in upcoming releases."* |
| **Business Relationship Plans** | 계산 정의를 만들거나 기본 제공 정의를 사용해 **Financial Deal 레코드로 account plan 목표 진척을 자동 추적** |
| **Create Flexible Hierarchies with Rules** | 규칙으로 일치 레코드를 자동 선택·조직화. **node 관계·필터·필터 로직을 한 번 구성**해 여러 적격 root 레코드의 계층을 만든다. 생성 결과는 **graph 또는 grid 뷰**로 검토 |
| **Create Calculation and Analysis Worksheets for Origination Processes** | **Origination Worksheet** 로 front·middle·back office origination 전반의 가격·상환능력(affordability) 계산. 관계 매니저는 가격 계산을, 검토자·운영팀은 재무 안정성·현금흐름·tradeline 데이터 분석으로 적격성 평가. **생성형 AI로 계산 로직 정의·정제, 수식 작성·검증, 런타임 워크시트 요약** |
| 공통 기능 | **Discovery Framework**(업로드 문서 AI 검증·연결 필드 prefill) · **Stage Management**(규제·고객 기한 대응 온디맨드 태스크 실행) · **Action Plans**(owner·target 리포팅, **액션 플랜당 최대 200 태스크**, 부모 태스크 완료 전 종속 태스크 배정) · **Actionable List with Data 360 DMO**(통합 Data 360 데이터와 CRM 필드를 함께 필터링해 타깃 클라이언트 리스트 구성, 온디맨드 멤버십 새로고침, 아웃리치 구조 기반 배정, 커스텀 상태 추적) |

**Health — Integrated Care Management (랜딩 요약 — 리프 미추출)**

- **Optimize Response Recommendation Mapping for Assessment Questions** — **적용 가능한 평가 질문 버전만** 표시해 매핑 가속. **response recommendation을 지원하지 않는 외부 평가 질문은 제외**해 구성 오류 방지. 레코드·리스트 뷰의 **엄격한 편집 통제**로 데이터 정확도 유지.
- **Streamline Action Plan Template Assignments in Care Plan Workflows** — 템플릿 배정 시 **action plan template 버전 자동 필터링**. problem definition·goal definition·care plan template 배정을 구성 추측 없이 진행. **선택한 연관 오브젝트·usage type·target object에 정확히 맞는 템플릿 버전만** 노출.

**Health 랜딩이 나열한 축(리프 미추출):** Agentforce for Health(제공자 청구 문의 응대 서브에이전트, 정형 페이어 콜을 음성 에이전트로 디플렉션 — 발신자 확인·일반 질문 처리·케이스 기록, 회원·청구·임상 상세의 통합 AI 요약) · Health Engagement(Health Engagement Analytics 앱의 사전 구축 대시보드 — 추가 설정 없이 closure rate·추세) · Intelligent Appointment Management(자율 에이전트의 예약 관리 API 소비 추적, **HIPAA 준수 이메일·문자 리마인더**) · Referral Management(추천 전 라이프사이클 실시간 가시성, 24시간 대응 음성 에이전트, **EHR↔Agentforce Health 자동 정합**) · **Auto-populate Display Order for Action Plan Template Items** · **Speed up Medicare Plan Enrollments with a Guided Flow**(Medicare Advantage·Prescription Drug·Special Needs 플랜을 단일 플로우로. **Scope of Appointment 동의 자동 캡처로 CMS 준수**, 처방약 formulary 즉시 확인·in-network 제공자 tier 검증·**48시간 규칙 내 상담 예약**, 여러 보험사 로그인 전환 없이 면책조항→서명까지 대화형 완료) · **Upgrade Home Visit Scheduling with Dynamic Calendar and List Views**(Home Health Visits Lightning 컴포넌트 커스터마이즈, **day·week·month·year** 레이아웃 전환, **최대 10개 방문 상태에 커스텀 색상**, 캘린더에서 직접 재예약·검증) · New and Changed Objects.

**Insurance — 랜딩 요약(리프 미추출) · 부모 허브 `rn_ins`가 담은 자식 요약 (기능 5건 + 컨테이너 3건)**

| 항목 | 내용 |
|---|---|
| **Set Up Insurance Products Faster with an Agentic Advisor** | **Insurance Design Advisor** 가 견적·정책 플로우에 필요한 요소 전반을 검증 — **selling model · pricebook entry · pricing procedure · attribute · 사용자 권한 · context definition** 등. **구조화된 검증 결과 + 단계별 개선 가이드** 반환. **Agentforce 자연어 또는 원하는 MCP 클라이언트**로 요청. **검증이 독립 실행되어 한 번에 모든 문제를 확인**한다(하나씩 발견하지 않는다) |
| **Rate Complex Quotes Faster by Processing Quote Line Items in Parallel** | **의존성 그래프**를 생성해 번들 내에서 독립적으로 가격 산정 가능한 제품 그룹을 식별. 평가 시 각 그룹을 **동시 처리**한 뒤 가격을 롤업해 net unit price 산출. 예: **차량 3대 자동차 보험**에서 각 차량과 부속 담보를 순차가 아니라 **독립 그룹으로 동시 산정** |
| **Migrate More Insurance Setup Data Between Orgs** | **`sf data setup transfer`** 명령의 내장 dataset definition에 **clause · underwriting rule · surcharge · group benefits product · CML(constraint modeling language) rule** 추가. 이전엔 **보험 상품 모델만** 내장 정의가 있어 나머지는 커스텀 정의를 직접 작성해야 했다 |
| **Quote Insurance and Non-Insurance Products from One Org** | **비보험 제품 → Revenue Management 워크플로**(수량 기반 가격 + 외부 세금, 견적이 **계약·주문**으로 전환). **보험 제품 → Digital Insurance 워크플로**(리스크 기반 rating·보험료 proration·내부 세금/수수료 계산, 견적이 **정책**으로 전환). **두 워크플로가 같은 조직에 공존**하며 **quote type에 따라 적용**된다 |
| **Boost Tax and Fee Evaluation with the Constraint Rules Engine** | **CML** 로 제품 surcharge 업무 규칙을 정의. **제품 구성·언더라이팅·exclusion/clause·제품 surcharge의 CML 규칙을 단일 constraint model로 통합**해 유지보수 단순화. 평가 시 Constraint Rules Engine이 surcharge 규칙을 **더 빠르게 단일 패스로** 평가해 세금·수수료를 계산 |
| **Group Benefits (컨테이너)** | census·견적·계약·정책 라이프사이클 전반의 그룹 보험 역량 강화. 등록(enrollment), 계약·정책 **endorsement**, 갱신을 지원해 보험사·고용주가 **midterm 변경과 갱신을 대규모로** 관리 |
| **Brokerage (컨테이너)** | **커스텀 리포트 타입**으로 정책·참가자·자산·담보 속성을 세밀하게 리포팅. **정책 전 라이프사이클에서 최대 40,000 레코드**를 지원하는 brokerage policy로 대량 book of business 관리 |
| **Claims Management (컨테이너)** | **내장 financial authority 통제**로 클레임 지급 승인 가속, **자동 reserve check**로 클레임 예산 보호, **피보험 자산·개인별로 정의된 정책 조건 강제**로 지급 정확도 향상 |

**Life Sciences — 랜딩이 나열한 축 전수**

| 축 | 내용 |
|---|---|
| **Account Management** | activity plan 재사용, 모바일 앱에서 검토·조정, 복잡한 territory alignment 자동화 |
| **Enablement Coaching** | 관리자가 **Discovery Framework로 가중치 평가 템플릿** 구축. 코치는 캘린더에서 세션 예약, **현장 방문 중 오프라인 평가**, 현장 활동 레코드 연결, **현재 점수와 과거 평가 비교**. 피코치는 기대치 가시화·진척 추적·실행형 개발 로드맵 수령. **직원 자기평가**와 **공식 승인(acknowledgment)** 으로 지역 컴플라이언스 충족 |
| **Engagement Execution** | **iPad에서 음성으로 방문 상세 캡처**(회의 후 수기 입력 대신), 그룹 방문에서 참석자 전환·정보 수집 가속, **구두·종이 기반 등 더 많은 방식으로 동의 기록** |
| **Event Management** | **예상 비용을 monetary cap 검사에 포함**해 참가자 경비를 라이프사이클 초기에 계획. **구성 가능한 참석 한도**로 계정 과다 이용 방지, **계정 병합 후에도 monetary cap 합계 보존**, 관리자 제어 handler로 합계 최신 유지 |
| **Intelligent Content** | 상호작용 데이터의 **보존 기간(retention period)** 설정으로 저장 공간 관리 |
| **Order Management** | 설정부터 서명까지 end-to-end. **웹·모바일, 온라인·오프라인** 어디서나 quoted order 생성·제출·현장 마감. **Store Check** 로 일관·정확한 매장 감사(재고 공백·컴플라이언스 이슈 즉시 포착). 모든 quoted order가 **동일하게 계산된 신뢰 가격**을 반영. 설정은 **한 곳에 집중** |
| **Seamlessly Import External Remediated Content** | **Content Ingestion API** 로 외부 DAM 시스템의 remediated 콘텐츠를 반입. 소스 비종속 REST API가 **ZIP 패키지(CLM 프레젠테이션)·PDF·사전 구성 이메일 템플릿**을 로드하고 **territory 배포·활성화를 자동화** |
| **Add Tableau Next Components to Lightning Pages** | Lightning App Builder에서 **Metric·Visualization·Dashboard 컴포넌트**를 레코드·홈 페이지에 추가. 이전엔 **전용 metrics 탭에서만** 제공돼 작업 화면을 떠나야 했다 |
| **Digital Verification Setup Is Changed for Internal and Portal Users** | **Winter '27부터 내부 사용자용 connected app / external client app 구성이 불필요**해졌다(이전엔 내부 사용자에 대해 connected app 구성 필요). **포털 사용자에 대해서는 external client app을 구성할 수 있다** |
| 개발자 표면 | New and Changed Objects for Life Sciences · New and Changed Invocable Actions in Life Sciences |

**Manufacturing (Agentforce Manufacturing)**

| 항목 | 내용 |
|---|---|
| **Agentforce for Manufacturing** | **Slack의 Industries Sales Assistance 에이전트 템플릿**으로 영업 협업, **Warranty Claims Adjudication 에이전트**로 보증 청구 판정 가속. **Agentforce Studio의 새 Agentforce Builder** 로 에이전트 구축·커스터마이즈·배포 |
| **Drive Accurate Order Capture with Integrated Pricing** | 가격·할인이 통합된 가이드 워크플로로 복잡한 주문 처리. **재사용 가능한 order specification** 이 주문 동작·가용 제품·assortment·**다중 단위(multi units of measure)** 를 정의하고 가격 계산은 자동. 청구·배송 역할 정확도 확보 |
| **Calculate Advanced Pricing for Manufacturing Sales Orders** | **35종 이상의 가격 계산 타입** — 고객 계층, 다중 단위, 물량 기반 할인, 프로모션, surcharge 포함. **ERP 가격 로직을 그대로 반영하도록 구성** 가능하고 **가격이 ERP 인보이스와 정확히 일치**해 분쟁·수기 계산 제거 |
| **Accelerate Warranty Claim Refunds with Automated Parts Returns** | 가이드형 사전 구축 서비스 프로세스로 보증·리콜 부품 반품 요청 개시·관리. **유통업체가 결함 부품을 OEM에 반품**하는 표준 워크플로 |
| **Tableau Next for Manufacturing** | **Manufacturing Insights** 대시보드 — **Account Performance Insights**(수익 공백·이탈 리스크·계정 건전성으로 고가치 유지·성장 우선순위화), **Product Demand Insights**(계정별 계획 대비 실제 수요 추적으로 판매 추세 조기 포착·공급 정렬), **Pricing Insights**(가격 탄력성 평가·계정 할인 범위 분석·가격 민감도 측정으로 협상 중 마진 보호) |
| **Optimize Asset Service Management Operations** | 날짜 범위 전체에 대한 **crew timesheet 생성**, 날짜 충돌 해소, **사용자 프로필별 필드 노출·차량 선택 조정**. Agentforce 기반 upsell·cross-sell 견적. **사용 불가 재고(unusable inventory)를 별도 추적**해 가용 재고 정확도 유지 |
| **Streamline Rebate Processing with Advanced Accrual and Payout Management** | **Data 360 위의 Data Processing Engine(DPE)** 으로 실제 상거래 계약에 맞는 세밀한 계산 모델링 — **flat · tiered · growth-based** 구조. **기중(mid-period) 요율·혜택 변경을 자동 처리**해 accrual·payout을 동적 조정하고 수작업 재작업 제거. 재무팀에 accrual 요약을 한눈에 제공 |
| 개발자 표면 | New and Changed Objects for Manufacturing · **New Connect REST APIs in Manufacturing** |

**Media Cloud (Agentforce Media) — 랜딩 요약(리프 미추출) · 부모 허브 `rn_media_cloud`가 담은 자식 요약 전수**

| 항목 | 내용 |
|---|---|
| **Boost Win Rates with Request for Proposal Management (GA)** | RFP 전 라이프사이클을 Salesforce 안에 집중. **이메일로 RFP 직접 수신**, **최대 10MB 문서 업로드**, 특정 필드 추출. 생성형 AI가 **클라이언트 목표·예산·마감일**을 편집 가능한 RFP 요약으로 구조화 |
| **Drive Ad Revenue with Out-of-Home Campaigns** | **빌보드·교통 쉘터·street furniture** 같은 물리 광고 인벤토리를 **POI 근접도**로 Quote-to-Order 플로우 안에서 검색. **맵 뷰**에서 빌보드 상세·위치 확인. **실시간 capacity 관리와 제품 수준 attribution**으로 중복 예약 방지·브랜드 거버넌스 강제. **Salesforce Pricing의 옴니채널 번들 할인 + OOH 가격 모델**을 결합해 디지털·물리 미디어 패키지를 **단일 통합 카트**에서 판매 |
| **Maximize Retail Impact with In-Store Media Campaigns** | 매장 위치 매핑, **end cap 같은 광고 형식** 선택, **sponsored product**로 물리 광고 공간과 재고 상품 연결. **유동인구·인구통계 기반 매장 필터링** |
| **Increase Campaign Impact with Sponsored Products** | 광고주가 강조하려는 정확한 리테일 제품을 **media plan line item에 직접 연결**. 수기 제품 입력 제거 |
| **Accelerate Inventory Booking with Bulk Line-Item Creation** | 광고 인벤토리 캘린더에서 **여러 제품 행을 선택해 한 번에** media plan에 추가. 라인 아이템 일괄 생성 + 슬롯을 **단일 라인으로 집계하거나 주·월 단위로 분할** |
| **Expedite Media Plan Delivery with Custom Quote Line Groups** | **미디어 타입·flight 기간·크리에이티브 전략**으로 복합 converged plan을 정리. media plan 안에서 커스텀 그룹 컨테이너를 **개수 제한 없이** 생성·명명·설명·재정렬·삭제 |
| **Optimize Ad Targeting with Data 360 Audience Segments (Beta)** | **1st-party Data 360 오디언스 세그먼트**를 media plan에 직접 적용. **주문 제출 시 Data 360 Segment ID를 다운스트림 ad server ID에 자동 매핑**해 수동 메타데이터 임포트·중복 로컬 저장 제거 |
| **Discover Agentforce Media Features with Salesforce Go** | Salesforce Go 한 곳에서 Agentforce Media 기능 발견 + 큐레이션 콘텐츠·링크 접근 |
| **Model Product Dependencies Without Bundling** | **Relies On 관계 타입**으로 제품·분류 간 의존성을 모델링하되 **각 제품의 가격·기간·라이프사이클은 보존**. 견적·주문에 Relies On 규칙이 있는 제품을 추가하면 Salesforce가 적격 관련 제품에 연결하고, **복수 후보면 담당자가 선택**. 관계는 **견적→주문→자산으로 이월되고 amendment를 거쳐도 유지**된다 |
| **Drive Promotions with Coupon Codes** | 고객이 사용하면 할인이 열리는 쿠폰 코드 발행. **프로모션 하나에 복수 코드**, **구매자별 또는 전체 기준 사용 한도** 설정, 사용량 추적 |
| **Expand Subscription Sales with Partial-Term Discounts** | 구독 제품에 **부분 기간 할인**. 담당자가 **혜택 기간(benefit duration)** 을 정의하고 구독 라이프사이클 전반의 **시간 기반 조정 내역**을 확인. **commitment period** 설정으로 비-stackable 할인의 재적용·결합 방지 |
| **Protect Campaign Profitability with Promotion Groups** | 같은 제품에 공존 가능한 프로모션과 **우선순위**를 통제. 프로모션을 **그룹·서브그룹**으로 조직해 stack 여부 또는 **최초 적격 프로모션만 적용**할지 결정 |

**New and Changed Objects in Agentforce Media — 신규/변경 전수 (원문 그대로)** *(이 블록은 리프 본문 확보 — `rn_media_objects`)*

*신규 오브젝트:* `RequestForProposal`(클라이언트가 서비스 제공자에게 제출하는 제안 요건) · `RqstForPrpsSumVersion`(복수 문서에 담긴 제안 요건 요약) · `RequestForProposalTeamMbr`(RFP를 관리해 opportunity·proposal을 생성하는 팀원) · `RequestForProposalOpp`(RFP에 대응해 생성된 opportunity) · `AdQuoteLineAdSpcSpecLoc`(광고 견적 라인에 연결된 ad space specification 위치) · `AdSpaceSpecLocation`(ad space specification에 연결된 위치) · `AdQuoteLinePrmtProduct`(라인 아이템에 연결된 광고 공간에서 프로모션되는 SKU) · `AdOrderItemAdSpcSpecLoc`(ad order item ↔ ad space spec location 연결) · `AdOrderItemPrmtProduct`(ad order line item의 일부로 프로모션되는 제품) · `ProductRelationshipRule`(제품 또는 제품 분류 간 관계 규칙)

*신규 필드:* `AdSpaceSpecLocationCount`(**Ad Quote Line** — 광고 견적 라인 아이템에 연결된 ad space spec location 레코드의 **고유 위치 총 수**) · `AdSpaceSpecLocationCount`(**Ad Order Item** — ad order item에 연결된 ad space spec location **레코드 총 수**) · `PlacementZone`(Ad Space Specification — 매장의 광범위한 물리 구역) · `PlacementType`(Ad Space Specification — placement zone 내 fixture·위치 유형) · `IsPhysicalSKURequired`(Ad Space Specification — 물리 SKU 필요 여부 true/false) · `ScreenType`(Ad Space Specification — 광고 표시 화면 유형) · `Illumination`(Ad Space Specification — 광고 표시 화면의 조명 유형) · `AudienceSize`(Ad Target Segment Value — 세그먼트 필터 조건에 부합하는 **고유 개인·엔터티 총 수**) · `DataCloudSegmentIdentifier`(Ad Target Segment Value — **Data 360의 세그먼트 식별자**) · `RelationshipAction`·`ProductRelationshipRule`(기존 `QuoteLineRelationship`) · `RelationshipAction`·`ProductRelationshipRule`(기존 `OrderItemRelationship`) · `ProductRelationshipRule`(기존 `AssetRelationship`) · `AdjCommitmentEndDateTime`·`AdjEffectiveStartDateTime`·`AdjEffectiveEndDateTime`·`AdjustmentAction`·`AppliedAdjustmentAmount`(기존 `CartItemPriceAdjustment`) · 동일 5개 필드(기존 `QuoteLinePriceAdjustment`) · `AdjCommitmentEndDateTime`·`AdjEffectiveStartDateTime`·`AdjEffectiveEndDateTime`·`AppliedAdjustmentAmount` **4개**(기존 `AssetActionSrcPriceAdjustment` — **`AdjustmentAction` 없음**) · 동일 5개 필드(기존 `OrderItemAdjustmentLineItem`)

> 위 필드 묶음에서 `AssetActionSrcPriceAdjustment`만 **`AdjustmentAction`이 빠진 4개 필드**다 — 원문이 다른 세 오브젝트와 다르게 열거한 지점이므로 그대로 구분해 적는다.

**Nonprofit (Agentforce Nonprofit)**

- **Simplify Program and Case Management Feature Setup** — **Salesforce Go**에서 Program Management·Case Management·Outcome Management를 단계별 안내로 구성. **페이지 이동 없이 전 과정 완료**. 기능 사용량 추적과 콘텐츠 자료 접근.
- 공통 기능: **Fundraising**(가구 이름 수식 기반 자동 유지) · **Program and Case Management**(참가자가 프로그램·신청·등록·급여 배정/지급·추천을 **직원 문의 없이 자기 일정대로** 조회. 신규 **Program Participant Portal Experience Cloud 템플릿**이 사전 구성 페이지·내비게이션·컴포넌트 제공).

**Net Zero Cloud (Agentforce Net Zero)** — **Supplier Engagement** 공통 기능: 공급업체가 **데이터 제출·스코어카드 작성·지출/배출/리스크 추적**을 하는 셀프서비스 포털로 **Scope 3 목표 설정**을 지원.

### Industries Common Features (13개 축 — 원문 전수)

| 축 | 내용 |
|---|---|
| **Actionable List with Data 360** | Data 360 DMO의 통합 데이터 위에 actionable list를 **직접 생성** |
| **Action Plans** | *(아래 상세)* |
| **Asset Management** | 재고·예약부터 감가상각·폐기까지 자산 end-to-end 관리 — 실시간 가시성 + 감사 대응 추적성. 에이전트가 **여러 제품을 한 번에 추가하고 할인을 적용**하는 실시간 견적 갱신으로 upsell·cross-sell 전환 가속 |
| **Discovery Framework** | 생성형 AI로 업로드 문서를 검증하고 assessment form의 연결 필드를 prefill |
| **Channel Revenue Management** | **Data 360 위의 DPE 기반** 자동 accrual·payout 관리. **Rebate and Accruals Management Advanced** 가 더 많은 실제 리베이트 구조를 기본 지원하고, 기중 요율·혜택 변경 시 수작업 재작업을 줄이며, 재무팀에 accrual 요약 제공 |
| **Criteria-Based Search and Filter** | 빠른 설정 도구, 사전 구축 템플릿, **Screen Flow 통합**, 일괄 선택, **Experience Cloud 검색 액션 지원** |
| **Fundraising** | 가구 구성 변화에 자동 재계산되는 수식 기반 가구 명명 |
| **Grantmaking** | 다단계 보조금 심사 표준화 + **심사자를 자기 전문 영역 섹션으로 제한** |
| **Industries Configure, Price, Quote (CPQ)** | Industries CPQ Cart·Pricing API의 성능·유연성·신뢰성 개선. 주요 이점: **최대 50,000 라인 아이템 mass discount 지원**, **속성 필터링으로 GetCartItems 응답 가속**, **MultiEdit API의 strict validation 모드**, cart template 적격성 검사 강화, 숨겨야 할 속성이 올바르게 숨겨지는 구성 경험 |
| **Omnistudio for Industries** | *(아래 Omnistudio 절)* |
| **Outbound Engagement** | 커스텀 템플릿 기반 유연한 아웃바운드 캠페인 + **전 커뮤니케이션에 커스텀 브랜딩**. **engagement 리소스가 백그라운드에서 생성되는 동안 계속 작업** 가능. 공통 메시지용 **범용(all-purpose) 템플릿** |
| **Stage Management** | 규제·고객 기한 대응 또는 표준 프로세스 흐름 밖 업무를 위한 **온디맨드 태스크 실행** |
| **Supplier Engagement** | 지속가능성 보고용 공급업체 셀프서비스 포털(데이터 제출·스코어카드·지출/배출/리스크 추적, **Scope 3** 목표 지원) |
| **Unified Catalog** | *(아래 상세)* |

**Action Plans — Manage More Complex Business Processes**

- action plan 레코드의 **Owner·Target 필드로 리포트** 실행 → 성과·소유권 추적
- **액션 플랜당 태스크 상한 100 → 200**
- **종속 태스크의 Assigned To를 부모 태스크 완료 전에 변경 가능** (사전 리소싱 계획 유연성)

**Asset Management (컨테이너 본문)**

- **Accelerate Upsell and Cross-Sell Conversions with Efficient, Error-Free Quoting** — Asset Service Lifecycle Management의 **Agentforce Product Upsell and Cross-Sell in Service**에서 에이전트가 **여러 제품을 한 번에 견적에 추가**하고 **신규·기존 견적 라인에 직접 할인 적용**
- **Track Unusable Inventory to Maintain Accurate Available Stock Levels** — 입고·재고 이전 중 **손상·만료·분실 등 사용 불가 재고를 캡처·분류**하고 가용 수량에 반영하며, **batch·serialized 제품을 포함해 수량 변경 이력을 추적 가능하게 보존**
- **Timesheets and Labor Cost Optimization** — **crew lead가 날짜 범위 전체에 대해 timesheet 생성**(하루씩 입력하지 않음), 생성 시 **충돌 날짜 제외**, 관리자가 **입력 필드 노출을 운영에 맞게 통제**
- **New and Changed Objects for Inventory Management** — Inventory Search·Inventory Replenishment용 신규/변경 오브젝트

**Discovery Framework — Validate Documents During Upload and Prefill Assessment Forms with AI:** **AI-Powered Document Upload Validation and Prefill** 로 업로드 문서에서 정보를 추출해 assessment form의 연결 필드를 채운다. **비적합 업로드를 중단시키거나 진행 전 경고하는 검증 규칙**을 구성.

**Unified Catalog (4건)**

| 항목 | 내용 |
|---|---|
| **Build Reusable Service Intake Forms with Custom Components** | **Create Service Catalog Request 플로우 invocable action**으로 intake form을 한 번 구성하면 시스템이 **조직 간 동일하게 배포**한다(마이그레이션 시 수동 재구성 제거). **커스텀 LWC 지원**, 요청별 **속성 데이터 전수 캡처** |
| **Modify Request Details After Submission** | 서비스 프로세스 설계 시 **상태(status)별로 어떤 속성을 누가 편집할 수 있는지** 지정. 요청이 활성인 동안 정해진 범위 안에서만 갱신되도록 보장 |
| **Display Context Attribute Values on Request Records** | **부모·자식 수준 속성**을 화면 전환 없이 함께 표시(예: 고객 케이스 검토 시 케이스 우선순위와 관련 코멘트를 함께) |
| **Deploy Components on Lightning Web Runtime Experience Cloud Sites** | **LWR 사이트에 Unified Catalog 컴포넌트** 추가 — 요청자가 카탈로그 카테고리 탐색·항목 검색·요청 제출 |

**Fundraising (2건 + 오브젝트)**

- **Create Households for Person Accounts During Gift Entry** — **Gift Entry Grid 또는 Business Process API**에서 기부자를 가구에 직접 추가(별도 자동화 구축 불필요). 파트너는 **gift·commitment 페이로드로 가구를 프로그래밍 방식 대량 생성**할 수 있다. 기부자 레코드가 입력 시점부터 완전해져 리포팅 공백을 즉시 해소.
- **Automatically Generate and Maintain Household Names** — **수식 기반 명명 패턴**을 정의하면 멤버 추가·삭제·수정 시마다 가구 계정명이 자동 재계산된다. **명명 엔진이 가구 멤버십과 멤버 상세의 변경을 수신해 실시간으로 재계산**한다.
- **New and Changed Objects for Fundraising**

**Grantmaking (1건 + 오브젝트)**

- **Standardize and Secure Grant Application Evaluation Stages** — 재사용 가능한 **Action Plan Template**으로 다단계 심사를 표준화하고, **Compliant Data Sharing**을 켜서 심사자를 자기 전문 영역 섹션으로 제한. 이전엔 보조금 주기마다 수동 심사가 필요해 심사 경험이 파편화되고 **지연과 심사자 편향 위험**이 있었다.
- **Updated Objects and Fields in Grantmaking**

**Outbound Engagement (5건 + 오브젝트)**

| 항목 | 내용 |
|---|---|
| **Create Flexible Outbound Campaigns with Custom Templates** | 기존 플로우·캠페인을 선택하거나 사전 구축 템플릿에서 시작해 커스텀 아웃바운드 템플릿 구축. **리스트 뷰에서 사용자가 직접 트리거하는 플로우**를 실행해 매번 새 캠페인을 만들지 않고도 발송 |
| **Maintain Brand Consistency with Custom Branding** | 아웃바운드 인게이지먼트에 브랜드 적용. **브랜드는 Marketing Cloud Next에서 생성·관리**. **발신자 상세와 communication subscription을 outbound engagement 모달에서 직접 구성**해 플로우 편집 없이 설정 시간 단축 |
| **Run Outbound Engagements in the Background and Keep Working** | 아웃바운드 인게이지먼트·템플릿이 **백그라운드에서 비동기 생성**되고, 완료 시 자동 알림 |
| **Simplify Communications with Generic Events** | 플로우에서 **generic event**를 사용해 기본 발송 용도의 템플릿 생성. 복잡한 이벤트별 타입 정의 없이 리스트 뷰에서 발송(예: 회원이 리워드를 사용했을 때 감사 메시지) |
| **Message Multiple Customers at Once from List Views** | 지원되는 리스트 뷰의 **Send Message 액션**으로 로열티 회원·컨택 등에게 대량 발송(예: 계정 명세서·리마인더) |
| **New and Changed Objects in Outbound Engagement** | 신규·변경 오브젝트 |

**Stage Management — Run Tasks on Demand to Meet Regulatory and Customer Deadlines**

레코드의 **현재 스테이지에서 적격한 태스크를 하나 이상 선택**하고 **사유와 코멘트를 기록한 뒤 즉시 실행**한다. 규제 요건 대응·고객 요청 처리·표준 흐름 밖 오류 정정에 쓴다. **온디맨드 태스크는 1회 실행**되며, Stage Management가 **stage transition 레코드에 모든 실행을 추적**한다 — **누가 · 어떤 태스크를 · 왜 · 언제**.

**Supplier Engagement — Accelerate Scope 3 Reporting with Supplier Management**

- Supplier Engagement 안의 end-to-end **Supplier Management** 경험으로 **Scope 3 배출량 수집·추적**
- **Salesforce Go에서 원클릭 설정**으로 사전 구축 공급업체 관리 포털 생성
- 공급업체는 **브랜드가 적용된 셀프서비스 포털**에서 **가이드형 4단계 마법사**로 지속가능성 스코어카드를 작성하며, **각 단계마다 진행 상황이 저장**된다
- **Experience Builder에서 코드 없이 단계별 폼 필드 커스터마이즈**
- **`SustainabilityScorecard` 오브젝트의 표준 필드**로 지속가능성·비용·리스크·조달 데이터를 캡처 — **SBTi 목표**와 **배출량 assurance level** 포함
- **New and Changed Objects in Supplier Engagement**

### Omnistudio

| 항목 | 내용 |
|---|---|
| **Simplify Omnistudio Component Deployments with Clean Metadata** | **Clean Metadata Deployment** 로 Omnistudio 컴포넌트를 표준 Salesforce 메타데이터와 **같은 도구·프로세스**로 관리·배포 — **Salesforce CLI · change set · 1GP · 2GP 패키지**를 LWC·플로우·Apex 클래스와 **동일 파이프라인**에서. **각 컴포넌트가 단일 버전을 노출**하고 **의존성이 자동 탐지**되며 소스 파일이 **버전 비종속의 깔끔한 이름**을 쓴다. 이전엔 옛 메타데이터의 제약을 우회하는 추가 단계가 필요했다 |
| **Reuse Autolaunched Flow Logic Across Your Flexcards (Generally Available)** | 활성 **autolaunched flow를 Flexcard 데이터 소스**로 설정하거나 **Flexcard 액션에서 플로우를 직접 호출**. autolaunched flow 데이터 소스는 **Omnistudio 표준 디자이너**에서 제공 |
| **Run Flexcards and Omniscripts Offline on Mobile Devices** | 연결이 나쁘거나 없는 곳에서도 모바일 사용자가 Flexcard·Omniscript를 **완전 오프라인으로 열고 완료·제출**. **데이터 작업·입력 검증·계산이 기기에서 실행**되고, 완료된 액션은 **로컬 큐에 쌓였다가 연결 복구 후 순서대로 동기화**된다 |
| **Omnistudio Minor Releases** | **Summer '25 이후 ~ Winter '26 이전**에 이뤄진 버그 수정·소규모 업데이트·알려진 이슈 |

### ⭐ 대표 신기능
1. **Insurance Design Advisor**(에이전트형 제품 구성 검증) + **보험/비보험 견적을 한 조직에서** 처리.
2. **Media의 OOH·in-store 리테일 미디어 진출** + RFP Management GA.
3. **Omnistudio Clean Metadata Deployment**(표준 파이프라인 편입) + Flexcard/Omniscript **완전 오프라인 실행**.
4. **Education의 학생 라이프사이클 대확장**(위임 접근·course versioning·전 학점 이관·HESA/MortarCAPS 규제 대응).

---

## MuleSoft

**MuleSoft Integration Intelligence** — MuleSoft 텔레메트리를 장기 분석으로 확장한다.

- **메트릭·로그·트레이스를 Salesforce Data 360에 집중**해 실시간 모니터링을 넘는 **과거 추세·시스템적 패턴 가시성** 확보
- **Integration Intelligence Lightning 앱**에서 **사전 제작·커스텀 Tableau Next 대시보드**로 API·애플리케이션 통합 인사이트 확인
- **에이전트 보조 분석(agent-assisted analysis)** 으로 문제 원인 신속 파악
- **Anypoint Platform에서 SSO로 이 운영 인사이트에 직접 접근**

> MuleSoft 랜딩은 *"MuleSoft features and integrations span Anypoint Platform and Salesforce to provide **API, MCP server, and agent management**"* 라고만 밝히고, 제품별 릴리즈 노트와 월별 요약은 **MuleSoft Documentation 링크**로 넘긴다. 8월 변경 로그에 추가됐다고 표시된 *Anypoint Platform Command-Line Interface* · *Simplify API and MCP Server Management with the API Catalog Connect REST API* 는 **Headless 360 영역** 소관이다.

---

## Slack

> *"Use Slack and Salesforce together to connect with customers, track progress, collaborate seamlessly, and deliver team success from anywhere."* Winter '27 Slack Integrations 영역에서 확보된 항목은 1건이다.

**Sell Smarter in Slack: Agentforce Sales and the New Go Page** — **Agentforce Sales가 Slackbot에서 직접 사용 가능**해져 Sales 에이전트가 Slack 워크플로로 들어온다. 관리자용 **전용 Go 페이지**로 설정이 빨라진다.

---

## Loyalty Management · Real-Time Offer Management · Referral Marketing

### Loyalty Management (10건 전수)

> **랜딩 요약(리프 미추출)** — 아래 10건은 부모 허브 `rn_loyalty_management`가 본문에 담은 **자식 요약**이다. 개별 리프 페이지는 제목 카탈로그에 있고 **에디션·Setup 경로·권한·가용 시점은 확보되지 않았다.**

| 항목 | 내용 |
|---|---|
| **Reduce Event Consumption with Smarter Loyalty Transaction Journal Creation** | 트랜잭션이 **레코드 변경을 유발하거나 프로모션 요건을 충족할 때만** 실시간 처리 중 transaction journal 생성. **Transaction Journals Execution API를 통한 실시간 처리에만 적용**되며 **배치 처리에는 영향 없다** |
| **Optimize Storage with Just-in-Time Member Currency Record Creation** | 등록 시점이 아니라 회원이 **처음 적립·사용할 때** member currency 레코드 생성 — **최초 credit 트랜잭션**에서 생성. **음수 포인트 잔액을 켰고 레코드가 없으면 최초 debit 트랜잭션에서 생성**한다. 회원 기능에 영향 없이 저장 소비 감소·DB 성능 향상 |
| **Use Mixed Expiration Models for Subtypes of Activity-Based Currencies** | **Activity With Mixed Subcurrencies** 만료 모델 — **부모 통화는 활동 기반 만료**를 쓰고 **서브타입은 고정 또는 활동 기반**을 각각 쓸 수 있다. 이전엔 모든 서브타입이 부모 모델을 상속했다. 이 통화들에 **traceability를 구성해 사용(redemption) 트랜잭션을 원 적립(accrual) 트랜잭션과 연결**할 수도 있다 |
| **Increase Engagement by Rewarding Members at Multiple Milestone Targets** | **engagement trail 프로모션** — 단일 활동의 진척을 추적해 여러 마일스톤 도달 시 보상. **easy · moderate · hard 3개 목표**를 점증적으로 설정하고, **한 트랜잭션으로 여러 목표를 동시 충족하면 해당 마일스톤 보상을 모두** 받는다. 예측 모델로 **회원별 개인화 목표** 설정 가능 |
| **Maximize Loyalty Promotion ROI with Predictive AI** | **Salesforce Predictive AI 모델**로 개인 구매 패턴 기반 목표 설정. 원문 예시: **과거 평균 지출 $50 고객 → easy/moderate/hard = $60 / $75 / $90**, **$100 지출 고객 → $120 / $150 / $200** |
| **Apply Discounts and Issue Rewards in a Single API Call** | **Unified Execution API** 로 할인 적용과 보상 발급을 **한 요청**에 처리(기존엔 Get Eligible Promotions API + Transaction Journal API 분리 호출) |
| **Analyze Loyalty Programs with More Tableau Next Dashboards** | Tableau Next 신규 대시보드 다수. **이전엔 CRM Analytics에서만** 제공됐다 |
| **Simplify Loyalty Widget Deployment with Lightning Out 2.0** | 자동 생성 HTML 스니펫으로 외부·Experience Cloud 사이트에 위젯 임베드. **디자인·콘텐츠·동작 변경이 코드 재배포 없이 즉시 반영** |
| **Save Time with Incremental Data Kit Upgrades** | 데이터 킷이 **Starter → Growth → Advanced 순으로 누적**된다. 예: **Growth 라이선스면 Starter + Growth 데이터 킷 설치**, 이후 **Advanced로 업그레이드하면 Advanced 데이터 킷만 추가**. 이전엔 Growth·Advanced 설치가 **하위 컴포넌트를 전부 재설치**했다 |
| **New and Changed Objects in Loyalty Management** | 신규·변경 Loyalty 오브젝트 |

### Real-Time Offer Management

> **랜딩 요약(리프 미추출)** — 아래 GPM 7건 + Offer Management 6건(합 **13건**)은 부모 허브 `rn_rtom_gpm` · `rn_rtom_offers`가 담은 **자식 요약**이다. 개별 리프 페이지는 제목 카탈로그에 있고 **에디션·Setup 경로·권한·가용 시점은 확보되지 않았다.**

**Global Promotions Management (7건)**

| 항목 | 내용 |
|---|---|
| **Create Promotions That Adapt to Each Customer's Purchase Behavior** | 구매 패턴 기반 **고객별 지출 임계값** 설정 — 전체·카테고리·제품별 지출 증대. 너무 어렵지 않게 도전적인 맞춤 할인 |
| **Control How Promotions Stack by Using Custom Evaluation Groups** | 프로모션을 **커스텀 서브그룹**으로 조직하고 각 서브그룹에 **First Promotion · Highest Discount · Stacked Evaluation** 중 하나를 배정. 이전엔 같은 카테고리(예: 전 line-level 프로모션)가 **하나의 평가 방식을 공유**해야 했다. 이제 카테고리 안에 서브그룹을 만들어 일부는 최고 할인 기준, 일부는 stack으로 운영 |
| **Create Industry-Specific Promotions with Decision Tables and Custom Eligibility Rules** | 사전 정의된 리테일 템플릿 대신 **decision table**로 다중 입력 조건의 커스텀 업무 로직을 정의하고 적절한 보상을 자동 적용 |
| **Validate Coupon Codes Before Customers Apply Them** | **Coupon Validation API** 가 **쿠폰 존재 여부 · 활성 기간 · 사용 한도 · 카트 수준 적격성**을 적용 전에 평가. 수동 입력 쿠폰 코드 지원으로 복수 쿠폰 결제 경험 개선 |
| **Apply Rewards to All Eligible Products or Categories in Buy X, Get Y Promotions** | 보상을 개별 추가하는 대신 **All Eligible Products / All Eligible Categories** 선택. 이전엔 **Unit Price Discount 템플릿에서만** 가능했고, 이제 **line-level Buy X, Get Y 템플릿까지 확장**된다 — 단 **Promotion Evaluation and Execution이 꺼져 있을 때** |
| **Give External Systems Access to Promotion Details with the Promotion Summary API** | 외부 시스템이 GPM 콘솔을 열지 않고 **프로모션 규칙·적격 기준·구성 상세**를 프로그래밍 방식으로 조회 |
| **New and Changed Objects in Global Promotions Management** | 변경된 GPM 오브젝트 |

**Offer Management (6건)**

| 항목 | 내용 |
|---|---|
| **Create Offers and Promotions from Briefs with Agentforce** | 캠페인 브리프로부터 Agentforce가 **오디언스·적격 기준·보상 규칙·채널 treatment 를 포함해 오퍼/프로모션 전 요소를 초안 작성**. 생성 제안을 미리보고 이해관계자와 조정한 뒤 최종 생성 |
| **Personalize SMS, Push Notifications, and WhatsApp Messages with Offer Treatments** | **Offer Treatment Designer에서 한 번 구성**하면 SMS·푸시·WhatsApp 메시지에 상세가 반영되고, **이후 treatment를 수정하면 모든 메시지가 자동 반영**된다 |
| **Show Personalized, Real-Time Offers in Your Mobile Apps** | **Mobile SDK**로 iOS·Android 앱을 Real-Time Offer Management API에 연결해 활성 세션 중 맞춤 프로모션 표시. **갱신된 샘플 앱**을 참조 구현으로 제공 |
| **Create and Manage Promotions and Offers from Your Experience Cloud Site** | Experience Cloud 사이트 사용자에게 마케팅 매니저와 **동일한 가이드 경험** 제공. 저장하면 **Offer·Offer Treatment·Promotion 레코드 페이지**에 나타나 커뮤니티 사용자가 직접 추적·관리 |
| **Find Data Kits Easily with the New Real-Time Offer Management Name** | **Global Promotions Management 데이터 킷 → Real-Time Offer Management** 로 개명. GPM·Offer Management 오브젝트를 Data Cloud에 매핑하는 용도 |
| **New and Changed Objects in Offer Management** | 신규·변경 Offer Management 오브젝트 |

### ⭐ 대표 신기능
1. **Loyalty의 예측 AI 개인화 목표** + engagement trail 3단계 마일스톤(easy/moderate/hard).
2. **Custom Evaluation Groups** — 서브그룹별 stack 정책(First / Highest Discount / Stacked).
3. **Agentforce로 캠페인 브리프 → 오퍼·프로모션 초안 자동 생성**.
4. **Loyalty·Referral 위젯의 Lightning Out 2.0 전환**(재배포 없는 즉시 반영).

---

## 그 밖의 영역

Clouds 추출 배치에 함께 들어온, 특정 클라우드에 속하지 않는 영역들이다.

### Salesforce Suites

| 항목 | 내용 |
|---|---|
| **Skip the Wait When Sending Emails to Contact and Lead Lists** | Contact·Lead 리스트로 프로모션·트랜잭션·관계형 이메일을 **추가 처리 단계 없이** 발송. 이전엔 리스트 발송에 **Data 360 세그먼트 생성**이 필요해 지연과 간헐적 발송 실패가 있었다. 재설계된 List Sends는 **초기 메시지 구성과 오디언스 선택을 한 페이지**로 통합 |
| **Agentforce Now Included in Free Suite** | **Free Suite에 Agentforce 포함**. 평문 대화로 업무 처리·핵심 인사이트 확인 |
| **Integrate Your External App Data with Salesforce Suites Using Prebuilt Integrations** | **MuleSoft와 Flow 기반 사전 구축 통합**으로 외부 앱을 직접 연결해 데이터 동기화·수기 입력 제거 |

### Salesforce Scheduler

- **Create Salesforce Scheduler Agents in the New Agentforce Builder** — 새 Agentforce Builder가 **Salesforce Scheduler 에이전트**를 지원해 고객 셀프 예약 지원 에이전트를 만들 수 있다. 만든 에이전트는 **Agentforce Studio 앱과 Agentforce Agents Setup 페이지의 목록 뷰**에 나타나며, **어디서 실행하든 항상 Agentforce Builder에서 열린다**.
- **Check Partner Calendar Availability Before Booking** — Scheduler가 **파트너 사용자의 연결된 외부 캘린더**의 busy/free를 확인해 **실제 가능한 슬롯만** 고객에게 보여준다. 이전엔 파트너가 개인 도구로 일정을 관리해 **Salesforce 밖에서 잡힌 회의를 예약 플로우가 반영하지 못했다**.

### Advisements (Beta)

> [!note] Beta 서비스
> 원문: *"Advisements is a pilot or beta service that is subject to the Beta Services Terms… Use of this pilot or beta service is at the Customer's sole discretion."*

**무엇:** 관리자에게 조직 특화 권고안을 **단계별 개선 가이드**와 함께 인앱으로 전달하는 경험. 각 권고안은 **자동으로 추적·완료 검증**된다.

**Catch More Org Risks with an Expanded Advisements Library and In-App Notifications (Beta)**

- **Where:** Lightning Experience — **Enterprise·Performance·Unlimited + Signature Success plan**. **프로덕션 조직에서만** 제공
- 탐지 위험 **14종 → 21종**으로 확대. 신규 탐지 3축:
  - **Content Security Policy** — 커스텀 Lightning 컴포넌트를 차단하거나 차단 예정인 CSP 위반을 **코어 정책 폴백 · 스크립트 실행/API 연결 · 페이지 레이아웃/스타일 · 페이지 임베딩/프레이밍 · 미디어/자산 전달** 전반에서 탐지
  - **Outdated API versions** — **3년 이상 지난** Salesforce API 버전을 호출하는 통합을 지원 종료 전에 갱신
  - **Data Detect** — **Salesforce Shield가 프로비저닝돼 있으나 Data Detect를 쓰지 않는 조직**에서 민감 데이터·데이터 정책 위반 스캔
- **How:** 권고안이 생성·완료·조치 필요 상태가 되면 **알림 트레이에 자동 표시**(설정 불필요). Setup의 **Advisements (beta) 리스트 뷰**에서 검토·필터·해결

### Salesforce My Trust Center

**Track Salesforce My Trust Center Sandboxes, Read Translated Updates, and Extend Access**

- **Where:** `my.trust.salesforce.com`. **샌드박스 테넌트 지원 대상은 Agentforce Sales · Agentforce Service · Salesforce Industries**
- **Who:** 풀 Salesforce 라이선스 없이 테넌트 상태를 보려면 **Unified Employee 라이선스 + My Trust Center 가시성용 커스텀 프로필**
- 향상 3축: **샌드박스 지원**(샌드박스 테넌트의 인시던트·릴리즈·유지보수 조회 + 알림 구독 → 릴리즈 계획·**지역별 Hyperforce IP allowlisting**·환경 준비) / **실시간 AI 번역**(자유 형식 이벤트 업데이트가 게시되는 대로 자동 번역. **과거 게시물은 소급 번역되지 않는다**) / **가시성 확대**
- **How:** Trust.salesforce.com 또는 Status.salesforce.com → Log In → **Trailblazer 계정 자격증명**. 언어는 **페이지 하단 language picker**. 조회 전용 접근 확장은 커스텀 프로필 생성 후 **Unified Employee 라이선스와 함께 배정**

### Partner Cloud

랜딩 요약만 확보: **파트너 연결성 확대와 안전한 레코드 공유·동기화를 통한 데이터 투명성 향상**으로 사업 성장 가속. **Experience Cloud 사이트 안에서 브랜드 규정을 준수하는 마케팅 콘텐츠**로 일관된 고객 경험 제공. (개별 기능 8건은 제목 계층.)

### AgentExchange

| 항목 | 내용 |
|---|---|
| **Install AgentExchange Apps Without Leaving Your Workflow** | **Agentforce Builder 안에서** 앱을 하나 또는 여러 개 동시 설치. **진행 스트립**이 각 설치 상태를 백그라운드로 추적하며 **도킹·확장·빌더 어디서나 확인** 가능. 설치 완료와 **액션·서브에이전트·에이전트 사용 준비 완료**를 알림으로 확인 |
| **Request App Installs and Updates From Your Admin (Beta)** | 설치 권한이 없으면 **비즈니스 정당화(business justification)** 와 함께 Agentforce Builder에서 직접 요청. **관리자가 이메일로 받아 설치 또는 반려**하고, 어느 쪽이든 요청자에게 이메일 통보 |
| **Identify FDE Partner Network Consultants on AgentExchange** | **Forward Deployed Engineering(FDE) Partner Network** 소속 컨설팅 파트너를 리스팅에서 확인. FDE 배지는 Salesforce가 **Agentforce 구현 역량을 인정한 파트너**를 표시하며, **리스팅 상세 헤더와 provider achievements 섹션**에 나타난다 |
| **(파트너 측) Identify Trialforce Email-Sending Domains That Need Verification** | **Branded Email Sets 설정의 신규 Verified Email Domain 필드** 사용. 아웃바운드 이메일 보안 강화로 **Trialforce branded email set에 연결된 발신 도메인을 검증해야** 한다. 기존 email set이 있으면 **2026-11-10 전에 도메인을 검증**해야 커스텀 브랜드 주소로 시스템 환영 메일을 계속 보낼 수 있다. **이미 DKIM 키 또는 authorized email domain을 설정했다면 자동 검증되어 추가 조치가 필요 없다** |
| **(파트너 측) View the FDE Badge on Your AgentExchange Listing** | **FDE Partner Network 지위에 도달하면** 리스팅에 FDE 배지가 표시된다 |

### Other Salesforce Products and Services

**Customer Success Group — Winter '27 하이라이트**

| 항목 | 내용 |
|---|---|
| **Success Plans for Slack** | 고객을 **사람과 AI 에이전트로 구성된 팀**과 짝지어 팀이 이미 일하는 곳에서 지원. **전문가 코칭 + 선제적 건강 모니터링 + 상시 지원**을 결합해 AI 도입 가속과 건강한 시스템 운영 |
| **Salesforce Health Insights** | **Customer Success Score 데이터를 Help 포털이 아니라 고객 조직 안으로** 가져온다. **Signature Success Plan** 고객은 조직을 떠나지 않고 주요 Sales·Service 도입 지표와 Technical Health 신호를 확인 |
| **Objective Based Scoring** | 일반화된 지표 대신 **고객이 선택한 비즈니스 목표** 대비 진척 측정. 목표와 연결된 도입 항목을 버킷으로 묶어 안내하고, 실행에 따라 점수가 실제 진척과 함께 상승 |
| **Goal Based Recommendations** | **에이전틱 워크플로**로 명시된 비즈니스 목표를 진전시키는 데 더 써야 할 기능·제품을 노출. 고객 목표와 **최신 knowledge graph 규칙**을 근거로 맞춤 안내와 콘텐츠·인에이블먼트 자료 제공 |
| **Technical Health Weekly Refresh** | Technical Health 신호 재계산 주기를 **월 단위 → 주 단위**로 변경. 대상: **Core · Agentforce · Marketing Cloud Engagement · MuleSoft**. 조치를 취하면 **한 달이 아니라 일주일 내** 점수에 반영 |

**Heroku** — 신규 기능은 **Heroku Changelog** 참조. **IdeaExchange** — Trailblazer 커뮤니티·제품 매니저와 아이디어를 공유하고 **연중 상시(continuous) 투표**.

### Legal Documentation

Salesforce 법무 문서의 시즌 업데이트. 변경 전체 목록은 각 변경 로그 참조: **Trust & Compliance Documentation Change Log · Business Associate Addendum Restrictions Change Log · Acceptable Use Policy Change Log**.

---

## 제목 카탈로그 — 미추출 671건

> [!warning] 이 절의 항목은 **제목과 page id뿐**이다 — 단 일부는 위 상세 섹션에 랜딩 요약이 있다
> 릴리즈 노트 **제목 문자열**을 그대로 옮긴 것이며 본문·에디션·라이선스·Setup 경로·권한·가용 시점은 **확보하지 않았다**. 제목에서 기능을 유추해 쓰지 않았고, 읽는 쪽에서도 제목 이상을 단정하면 안 된다.
> **예외 — 랜딩요약 계층(약 229건):** 이 카탈로그 항목 중 상당수는 **부모 허브 페이지가 자식 요약을 담고 있어** 위 클라우드별 상세 섹션에 **1~3문장 설명**이 실려 있다(Loyalty · Real-Time Offer Management · Case Management · Self Service · Industries의 Education·Media·Insurance·Health 등 · Marketing Cloud Next · HR Service · Data 360 4개 축 · Partner Cloud). 그 항목들에 대해 *"본문이 전혀 없다"* 는 서술은 **틀리다** — 다만 그 요약에도 에디션·Setup 경로·권한·가용 시점은 없다. 위 절대 진술은 **랜딩 요약조차 없는 나머지 항목**에 적용된다. **Agentforce IT Service `rn_it_*` 51건은 이 카탈로그에서 빠졌다** — 제목이 아니라 본문까지 확보돼 위 `## Agentforce IT Service` 절로 올라갔기 때문이다(722 → 671).
> `...` 로 끝나는 제목은 소스 목록에서 이미 잘린 상태이며 **자르지 않고 원문 그대로** 옮겼다.
> 원문 재조회: `https://help.salesforce.com/s/articleView?id=release-notes.<page_id>.htm&language=en_US&release=264&type=5`

**그룹별 분포**

| 그룹 | 건수 |
|---|---|
| Revenue — Billing·Collections | **31** |
| Revenue — Product Catalog·Configurator | **16** |
| Revenue — Pricing·Transaction·Ramp·Usage·Orchestration | **39** |
| Revenue — Approvals·Promotions·Contracts | **9** |
| Industries — Communications | **38** |
| Industries — CPQ (공통) | **10** |
| Industries — Life Sciences | **31** |
| Industries — Insurance | **33** |
| Industries — Public Sector | **46** |
| Industries — Energy & Utilities | **26** |
| Industries — Health | **21** |
| Industries — Automotive | **21** |
| Industries — Education | **18** |
| Industries — Manufacturing | **16** |
| Industries — Media | **14** |
| Industries — Financial Services | **7** |
| Industries — Consumer Goods·Retail Execution·TPM | **8** |
| Industries — 공통 기능 (Common Features)·Omnistudio·Business Rules Engine | **54** |
| Marketing — Marketing Cloud Next · Account Engagement | **56** |
| Marketing — Marketing Cloud Engagement | **24** |
| Marketing — Marketing Intelligence | **8** |
| Marketing — Salesforce Personalization | **2** |
| Loyalty Management | **10** |
| Real-Time Offer Management (GPM · Offer Management) | **13** |
| Referral Marketing | **3** |
| Service — Workforce Management | **21** |
| Service — Service Assistant · Work Summaries | **7** |
| Service — Case·Knowledge·Messaging·HR Service·Self Service | **19** |
| Data 360 · Analytics (Reports and Dashboards 포함) | **24** |
| AI Relationship Research — `rn_airr_*` (상위 클라우드 미상) | **3** |
| Partner Cloud | **8** |
| AgentExchange | **5** |
| Salesforce Suites · Scheduler · Slack | **6** |
| Platform·Development 소관 (Clouds 배치에 섞여 들어온 항목) | **24** |
| **합계** | **671** |


### Revenue — Billing·Collections (31건)

- Accept Regional Payment Methods in the Self-Service Billing Portal... — `rn_billing_regional_payment_methods`
- Add Billing Self-Service Components in LWR Experience Cloud Sites — `rn_billing_self_service_components_lwr`
- Advance Migrated Billing Schedules Without Rebilling by Using... — `rn_billing_catch_up_bill_runs`
- Automate Compound Price Uplifts for Multiyear Ramp Deals — `rn_billing_price_uplifts_for_multiyear_ramp_dealsxml`
- Bill Every Few Weeks, Months, or Years Instead of Every Term — `rn_billing_term_units`
- Billing Schedules and Billing Arrangements — `rn_billing_schedules_arrangements`
- Change Billing Frequency on Active Subscriptions Anytime — `rn_billing_change_frequency_arc`
- Changed Metadata Types in Billing — `rn_billing_changed_metadata_types`
- Configure Billing Features Faster — `rn_billing_features_with_salesforce_go`
- Extend the Revenue Standard Tax Engine to Match Your Tax Rules — `rn_billing_extend_tax_engine`
- Generate Context-Rich Sequence Patterns with Dynamic Fields — `rn_billing_dynamic_sequence_patterns`
- Generate Invoice Documents Automatically During Invoice Batch Runs — `rn_billing_generate_invoice_documents_batch`
- Generate Invoices Across Accounts for Owned and Billed Charges — `rn_billing_generate_invoices_across_accounts`
- Honor Future-Dated Billing Suspensions During Invoicing — `rn_billing_future_dated_suspensions`
- New and Changed Connect REST APIs in Billing — `rn_billing_new_changed_connect_rest_apis`
- New and Changed Invocable Actions in Billing — `rn_billing_new_changed_invocable_actions`
- New and Changed Objects for Billing — `rn_new_changed_billing_objects`
- Orchestrate Cart-to-Cash Checkout Flow With a Single API Call — `rn_billing_api_updates`
- Payments and Refunds — `rn_billing_payments_refunds`
- Prioritize and Act on Overdue Invoices in the Collections Specialist... — `rn_billing_collections_specialist_console`
- Prioritize Collections with Invoice Aging Summaries on Accounts — `rn_billing_invoice_aging_summaries`
- Reconcile Payment Advice and Bank Data with Lockbox Processing — `rn_billing_lockbox_reconciliation`
- Refund Available Credit Balances to Customer Accounts — `rn_billing_issue_credits_as_refunds`
- Review All Impacted Split Invoices Before Posting, Voiding, or... — `rn_billing_review_split_invoices`
- Save Digital Wallets for Future Invoice Payments — `rn_billing_save_digital_wallets`
- Send Level 2 and Level 3 Payment Data Through a Native Payment Gateway — `rn_billing_send_l2_l3_data_native`
- Set Invoice Target Dates by Calendar Day or Billing Period Count — `rn_billing_target_date_flexibility`
- Support Flexible Billing With Weekly Cadences — `rn_billing_weekly_cycle`
- Tax Management — `rn_billing_tax_management`
- Track Ramp Deal Details on Billing Schedules — `rn_billing_track_ramp_deal_details`
- Visualize Billing Schedule Lifecycles with Timelines — `rn_billing_schedule_timelines`

### Revenue — Product Catalog·Configurator (16건)

- Changed Connect REST API in Product Configurator — `rn_product_configurator_changed_connect_rest_api_request_body`
- Changed Connect REST APIs in Product Catalog Management — `rn_product_catalog_changed_connect_rest_api_response_body`
- Changed Object in Product Configurator — `rn_product_configurator_changed_object`
- Discover Products Faster by Using Price Book Filters — `rn_product_catalog_discover_products_faster_using_price_book_filters`
- Enforce Per-Bundle Product Requirements Regardless of Order Size — `rn_product_configurator_instance_quantity`
- Find Products with Prefix Matching and Partial Search — `rn_product_catalog_find_products_with_prefix_matching_and_partial_search`
- Get Accurate Product Details with Automated Product Cache Management — `rn_product_catalog_get_accurate_product_details_with_automated_product_cache_management`
- Get Faster Product Pricing with List Price Caching — `rn_product_catalog_get_faster_product_pricing_with_list_price_caching`
- Guide Sales Reps Through Product Setup with Dynamic UI Controls — `rn_product_catalog_guide_sales_reps_through_product_setups_with_dynamic_ui_controls`
- Let Constraint Rules Assign Child Product Quantities in Bundles — `rn_product_configurator_allowQuantityChange`
- Prevent Constraint Conflicts When Sharing Attributes and Relations — `rn_product_configurator_guardrails_annotation`
- Product Catalog Management — `rn_product_catalog_management`
- Reuse Existing Simple Products as Bundles — `rn_product_catalog_reuse_existing_simple_products_as_bundles`
- See Instant Updates in Product Discovery While Building Quotes — `rn_product_catalog_see_instant_updates_in_product_discovery_while_building_quotes`
- Simplify Product Configuration with Custom Attribute and Category... — `rn_product_catalog_display_order_attributes`
- Updates in Default Product Configurator Flow — `rn_product_configurator_flow_updates`

### Revenue — Pricing·Transaction·Ramp·Usage·Orchestration (39건)

- Accelerate Transaction Updates with Advanced Filters — `rn_transaction_management_filter_transactions_by_product_name_in_the_sales_transaction_line_editor`
- Adapt Subscriptions When Customer Needs Change — `rn_um_renew_active_usage_assets_early`
- Align Fulfillment Dependencies by Using Custom Scopes — `rn_dro_custom_fulfillment_scopes`
- Apply Compound Price Uplifts to Multiyear Ramp Deals to Adjust... — `rn_transaction_management_ramp_deal_compound_uplift`
- Apply Configuration Rules Across 15,000 Line Items — `rn_large_txn_apply_configuration_rules`
- Automate Multiyear Ramp Deal Orchestration with Sequenced Steps — `rn_dro_optimize_multiyear_orchestration`
- Avoid Integration Parsing Errors from Pricing API Decimal Values — `rn_pricing_avoid_integration_parsing_errors_from_pricing_api_decimal_values`
- Backdate Amendments, Renewals, and Cancellations for Ramp Deals to... — `rn_transaction_management_backdated_arc_for_ramps`
- Build Focused Quote Line Item and Order Product Pages with Dynamic... — `rn_transaction_management_dynamic_forms_for_quote_line_items_and_order_products`
- Changed Connect REST API in Transaction Management — `rn_transaction_management_changed_connect_rest_apis`
- Changed Objects in Dynamic Revenue Orchestrator — `rn_dro_new_and_changed_objects`
- Clone and Reuse Fulfillment Workspaces — `rn_dro_clone_fulfillment_workspaces`
- Dynamic Revenue Orchestrator — `rn_dynamic_revenue_orchestrator`
- Edit Accurate Quotes and Orders in Sales Transaction Line Editor... — `rn_transaction_management_stle_enhance_autorefresh`
- Eliminate Fulfillment Delays by Using Staged Assetization for Ramped... — `rn_dro_staged_assetization_ramped_products`
- Gain Pricing Flexibility with Price Amendments — `rn_transaction_management_update_quote_and_order_prices_with_price_amendments`
- Gain Transaction Flexibility with Backdated Asset Changes — `rn_transaction_management_backdate_asset_transactions`
- Generate Documents for Quotes with 15,000 Line Items — `rn_large_txn_generate_documents_for_quotes_with_15_000`
- Keep Calculated Values in Context with Local List Variables — `rn_pricing_keep_calculated_values_in_context_with_local_list_variables`
- Limit a Procedure Plan to a Specific Industry — `rn_transaction_management_prevent_cross_industry_pricing_errors_with_subtype`
- Maintain Time Zone Accuracy for Asset Lifecycle Changes — `rn_transaction_managment_preserve_original_time_zones_for_asset_lifecycle_changes`
- Navigate Orders Easily with the Enhanced Decomposition Viewer — `rn_dro_enhanced_decomposition_viewer`
- New and Changed Objects in Usage Management — `rn_um_new_and_changes_objects`
- New Invocable Action in Transaction Management — `rn_transaction_management_new_invocable_action_in_transaction_management`
- Orchestrate Backdated and Future-Dated Contract Changes Automatically — `rn_dro_backdated_future_dated_amendments`
- Orchestrate High Tech Order Scenarios by Using a Prebuilt Template — `rn_dro_hightech_orch_with_salesforce_go`
- Organize Sales Transaction Line Editor Actions into Button Groups... — `rn_transaction_management_stle_enhance_button_groups`
- Prevent Usage Summary Failures by Updating Overridden Flows — `rn_um_update_overridden_flows_with_dpe_v4`
- Price Quotes and Orders with Up to 15,000 Lines — `rn_large_txn_price_quotes_and_orders`
- Recover Faster from Quote and Order Calculation Errors — `rn_large_txn_recover_faster_from_quote_and_order_calculation_errors`
- Reduce Pricing Errors and Improve Deal Transparency on Ramp Deals — `rn_pricing_reduce_pricing_errors_and_improve_deal_transparency_on_ramp_deals`
- Respond to Growth with Early Ramp Renewal — `rn_um_renew_ramped_usage_assets_early`
- Speed Up Large Quote Operations with Automatic Context Reuse — `rn_large_txn_speed_up_large_quote_operations_with_automatic_context_reuse`
- Streamline Fulfillment of Ramped Asset Amendments — `rn_dro_fulfill_ramped_asset_amendments`
- Sync Large Quotes to Opportunities Without Interruption — `rn_large_txn_sync_large_quotes_to_opportunities`
- Tailor Pricing Rules for Multiple Industry Clouds — `rn_pricing_tailor_pricing_rules_for_multiple_industry_clouds`
- Transform Context Data in Large Transactions — `rn_large_txn_transform_context_data_in_large_transactions`
- Usage Management — `rn_um_usage_management`
- Win Back Customers by Restoring Lapsed Subscriptions — `rn_um_renew_expired_usage_assets`

### Revenue — Approvals·Promotions·Contracts (9건)

- Accelerate Approval Decisions with Approval Agent — `rn_rev_agentforce_approvals_agent`
- Extend Slack Approval Notifications to Group and Queue Members — `rn_adv_approvals_slack_notifications`
- Increase Sales with Promotions in Revenue Management — `rn_revenue_increase_sales_with_promotions`
- Keep Approval Workflows Moving with Advanced Approval Delegation — `rn_adv_approvals_approval_delegation`
- Limit Approval Work Item Visibility to Keep Review Steps Confidential — `rn_adv_approvals_work_item_sharing`
- New and Changed Objects for Promotions in Revenue Management — `rn_revenue_promotions_new_changed_objects`
- New Connect REST APIs in Salesforce Contracts — `rn_contracts_new_connect_rest_apis`
- New Objects in Advanced Approvals — `rn_adv_approvals_new_changed_objects`
- Simplify Revenue Cloud Feature Discovery and Setup — `rn_rev_salesforce_go`

### Industries — Communications (38건)

- Access All Pricing Tools from One Place — `rn_comms_access_all_pricing_tools`
- Agentforce for Enterprise Quoting — `rn_comms_enterprise_quote_automation_container`
- Apply a Bundle Configuration Across Matching Quote Line Items — `rn_comms_apply_bundle_configuration`
- Apply Term-Based Promotions to Boost Sales — `rn_comms_apply_term_based_promotions_boost_sales`
- Build and Manage Quotes with Invocable Actions in Enterprise Sales... — `rn_comms_build_validate_quotes_invocable_actions`
- Communications Insights — `rn_comms_communications_insights_container`
- Consumer Sales in Revenue Cloud for Communications — `rn_comms_consumer_sales_in_revenue_cloud_for_communications`
- Contract Option in Custom Discount Allocation Type Settings Is Retired — `rn_comms_contract_discount_allocation_retired`
- Convert Customer Assets to Enterprise Orders Directly in Enterprise... — `rn_comms_convert_customer_assets_to_orders`
- Deep Clone Source Orders in Activated Status — `rn_comms_deep_clone_activated_source_orders`
- Define Product Dependencies with Linear Relationships — `rn_comms_define_product_dependencies_linear_relationships`
- Define Promotional Compatibility with Advanced Stackability Rules — `rn_comms_define_promotional_compatibility_stackability`
- Delta Pricing Accelerates Recalculations in Carts — `rn_comms_accelerate_cart_performance_delta_pricing`
- Disconnect Bundle Products with Accurate Cart Updates in Enterprise... — `rn_comms_disconnect_bundle_products`
- Distinguish Blocking Errors from Bypassable Warnings in Your Working... — `rn_comms_distinguish_cart_errors_warnings`
- Drive Customer Engagement with Coupon-Based Promotions — `rn_comms_drive_customer_engagement_coupon_promotions`
- Einstein Quick Quote for Enterprise Sales Management Is Retired — `rn_comms_einstein_quick_quote_retired`
- Enable Customer and Partner Community Access to Consumer Sales... — `rn_comms_enable_customer_and_partner_community_access_to_consumer_sales_connect_api`
- Enterprise Sales Management — `rn_comms_esm_operations_updates`
- Generate Amendment Orders from Assets with the Amend API — `rn_comms_generate_amendment_orders_from_assets_with_the_amend_api`
- Manage Customer Carts in Communications Service Console for Consumer... — `rn_comms_manage_customer_carts_in_service_console`
- Navigate High-Volume Enterprise Sales Management Records with... — `rn_comms_number_based_pagination`
- New and Changed Connect REST APIs for Consumer Sales — `rn_comms_new_and_changed_connect_rest_apis`
- New and Changed Invocable Actions in Consumer Sales — `rn_comms_new_and_changed_invocable_actions_in_consumer_sales`
- New and Changed Object for Revenue Cloud for Communications — `rn_comms_new_and_changed_objects_for_rev_cloud_for_comms`
- New Connect REST APIs for Revenue Cloud for Communications — `rn_comms_new_connect_rest_apis`
- New Invocable Actions in Enterprise Sales Management — `rn_comms_new_invocable_actions_in_enterprise_sales_management`
- Process Large Quotes at Scale with Enhanced Enterprise Sales... — `rn_comms_process_large_quotes_at_scale`
- Promotions in Revenue Cloud for Communications — `rn_comms_promotions_in_revenue_cloud_for_communications`
- Protect Quote and Order Consistency with a UI Loader for... — `rn_comms_ui_loader_asynchronous_processes`
- Provide Clear Feedback on Cart Operations with Transient Messages — `rn_comms_transient_cart_messages`
- Revenue Cloud for Communications on Salesforce Platform — `rn_comms_revenue_cloud_for_communications_on_salesforce_platform`
- Route Users Where They Need to Be with Context-Aware Custom... — `rn_comms_context_aware_bell_notifications`
- Run Custom Logic After Multi-Site Copy Completes — `rn_comms_custom_logic_after_multi_site_copy`
- Set Up Revenue Cloud for Communications Features Faster with... — `rn_comms_set_up_features_faster_salesforce_go`
- Sort Functionality on the Product Catalog Is Retired — `rn_comms_product_catalog_sort_retired`
- Track Revenue Execution Across Your Pipeline with Communications... — `rn_comms_track_revenue_with_sales_insights`
- Update Your Context Definition to ConsumerSalesContext — `rn_comms_update_your_context_definition_to_consumersalescontext`

### Industries — CPQ (공통) (10건)

- Accelerate High-Volume Cloning Operations with the cloneItems API — `rn_cpq_accelerate_high_volume_cloning_operations_with_the_cloneitems_api`
- Apply Mass Discounts to Enterprise-Scale Quotes — `rn_cpq_apply_mass_discounts_to_enterprise_scale_quotes_without_system_failures`
- Display Only Relevant Attributes during Group Cart Bulk Change... — `rn_cpq_display_only_relevant_attributes_in_group_cart_bulk_change_configuration`
- Industries Configure, Price, Quote (CPQ) — `rn_industries_configure_price_quote_cpq`
- Maintain Accurate Cart Templates by Validating Product and Promotion... — `rn_cpq_maintain_accurate_cart_templates_by_validating_product_and_promotion_eligibility`
- Maintain Data Integrity with MultiEdit API Validation and Pricing... — `rn_cpq_ensure_data_integrity_with_multiedit_api_validation_and_pricing_checks`
- New and Changed Objects in CME Managed Package — `rn_cpq_new_and_changed_objects_in_cme_managed_package`
- Optimize GetCartItems Responses by Filtering Unwanted Attributes — `rn_cpq_optimize_getcartitems_responses_by_filtering_unwanted_attribute_data`
- runtime_industries_cpq Namespace — `rn_runtime_industries_cpq_namespace`
- Stability and Accuracy Enhancements for CME Managed Package — `rn_cpq_stability_and_accuracy_enhancements_for_cme_managed_package`

### Industries — Life Sciences (31건)

- Account Management — `rn_lsc_customer_engagement_account_management`
- Add Tableau Next Components to Lightning Pages — `rn_lsc_tableau_next_lightning_page_embed`
- Build Standardized Evaluations with the Discovery Framework — `rn_lsc_enablement_coaching_build_standardized_evaluations_with_discovery_framework`
- Capture Attendee Details Faster in Group Visits — `rn_lsc_customer_engagement_execution_enhanced_group_visits`
- Capture Consent in More Ways — `rn_lsc_customer_engagement_capture_consent_more_ways`
- Clone Activity Plans Instead of Building Them from Scratch — `rn_lsc_customer_engagement_activity_plan_cloning`
- Complete Coaching Evaluations Anywhere with Offline Support — `rn_lsc_enablement_coaching_complete_evaluations_anywhere_with_offline_support`
- Conduct Faster, Accurate In-Store Execution with Store Check — `rn_lsc_customer_engagement_store_check`
- Create Consistent and Transparent Quoted Orders with Pricing... — `rn_lsc_order_management_automate_order_calculations`
- Digital Verification Setup Is Changed for Internal and Portal Users — `rn_lsc_patient_engagement_atm_digital_verification`
- Enable Voice-Based Visit Logging (Generally Available) — `rn_lsc_customer_engagement_execution_visit_agent`
- Enablement Coaching — `rn_lsc_enablement_coaching`
- Engagement Execution — `rn_lsc_customer_engagement_execution`
- Event Management — `rn_lsc_customer_engagement_event_management`
- Extend Account Merge to Include Estimated Expense Calculations — `rn_lsc_customer_engagement_event_management_extend_account_merge_estimated_expenses`
- Gain Insights into Projected Costs by Using Monetary Caps — `rn_lsc_customer_engagement_event_management_estimated_monetary_caps`
- Intelligent Content — `rn_lsc_customer_engagement_intelligent_content`
- Link Field Visits with Evaluations — `rn_lsc_enablement_coaching_link_field_visits_with_evaluations`
- Manage Complex Territory Alignments with Advanced Rules — `rn_lsc_customer_engagement_account_territory_alignment`
- Manage Data Retention for Presentation Interactions — `rn_lsc_customer_engagement_intelligent_content_data_retention`
- Manage Quoted Orders from Anywhere — `rn_lsc_order_management_create_quotes_from_anywhere`
- New and Changed Invocable Actions in Life Sciences — `rn_lsc_order_management_new_changed_invocable_actions`
- New and Changed Objects for Life Sciences — `rn_lsc_order_management_new_changed_objects`
- Order Management — `rn_lsc_order_management_release_highlights`
- Review and Adjust Activity Plans in the Mobile App — `rn_lsc_customer_engagement_activity_plan_review_mobile`
- Schedule and Track Coaching Sessions from Calendar — `rn_lsc_enablement_coaching_schedule_and_track_from_calendar`
- Seamlessly Import External Remediated Content into Life Sciences Cloud — `rn_lsc_customer_engagement_automate_content_ingestion`
- Set Up Order Management Features from a Single Location — `rn_lsc_order_management_salesforcego`
- Stay Compliant by Limiting the Number of Events Each Account Can... — `rn_lsc_customer_engagement_event_management_utilization_limits`
- Strengthen Data Monitoring by Using the New Event Management Trigger... — `rn_lsc_customer_engagement_event_management_new_trigger_handlers`
- View Historical Evaluation Scores to Track Employee Development — `rn_lsc_enablement_coaching_view_historical_evaluation_scores`

### Industries — Insurance (33건)

- Adjust Group Insurance Contracts Midterm as Customer Needs and... — `rn_insurance_group_benefits_midterm_adjustments`
- Adjust Member Policies Mid-Term for Life Events — `rn_insurance_group_benefits_adjust_member_policies_life_events`
- Automate Member Plan Assignment for Straight-Through Processing — `rn_insurance_group_benefits_automate_member_plan_assignment`
- Boost Tax and Fee Evaluation with the Constraint Rules Engine — `rn_insurance_constraint_rules_engine_tax`
- Brokerage — `rn_insurance_brokerage_container`
- Calculate Group Taxes and Fees to Meet Regulatory and Operational... — `rn_insurance_group_benefits_calculate_taxes_and_fees`
- Claims Management — `rn_insurance_claims_management`
- Clone Group Census Data to Compare Plan Configurations — `rn_insurance_group_benefits_deep_clone_census_data`
- Configure Bespoke Member Plans for Flexible Benefits — `rn_insurance_group_benefits_bespoke_member_plans_flexible_benefits`
- Generate Contract Transactions from Policy Transactions On Demand — `rn_insurance_group_benefits_generate_contract_transactions`
- Group Benefits — `rn_insurance_group_benefits_container`
- Improve Claim Payouts by Enforcing Policy Terms for an Insured Asset... — `rn_insurance_claims_policy_terms`
- Keep Member Policies Aligned with Contract Endorsements — `rn_insurance_group_benefits_contract_endorsements_member_policies`
- Manage Large Brokerage Policies with up to 40,000 Records — `rn_insurance_brokerage_manage_large_policies_40000_records`
- Migrate More Insurance Setup Data Between Orgs — `rn_insurance_setup_data_migration`
- New and Changed Objects in Insurance — `rn_insurance_new_changed_objects`
- New Connect in Apex Methods in Brokerage — `rn_ins_brokerage_connect_in_apex_methods`
- New Connect REST APIs in Brokerage — `rn_ins_brokerage_connect_api_resources`
- New Connect REST APIs in Group Benefits — `rn_insurance_group_benefits_connect_api_resources`
- New Invocable Actions in Group Benefits — `rn_insurance_group_benefits_new_invocable_actions`
- Price Group Benefits Quotes and Policies with an External Rating... — `rn_insurance_group_benefits_external_rating_engine`
- Process Group Enrollments, Endorsements, and Renewals in Parallel at... — `rn_insurance_group_benefits_operations_at_scale`
- Protect Claim Budgets with Automated Reserve Checks at Payment Time — `rn_insurance_claims_reserve_checks`
- Quote Insurance and Non-Insurance Products from One Org — `rn_insurance_non_insurance_quotes`
- Rate Complex Quotes Faster by Processing Quote Line Items in Parallel — `rn_insurance_quote_line_items_parallel`
- Renew Expiring Group Insurance Contracts for a New Term — `rn_insurance_group_benefits_renew_contract`
- Renew Member Policies for the Next Contract Term — `rn_insurance_group_benefits_renew_member_policies_contract_term`
- Report on Insurance Attributes with Custom Report Types — `rn_insurance_brokerage_report_on_attributes_with_custom_report_types`
- Review Cost Impact and Make Better Policy Lifecycle Decisions — `rn_insurance_group_benefits_review_cost_impact_lifecycle`
- Review Member-Level Premiums for Greater Pricing Transparency — `rn_insurance_group_benefits_member_premium_persistence`
- Set Up Insurance Products Faster with an Agentic Advisor — `rn_insurance_design_advisor`
- Speed Up Contract Midterm Adjustments and Renewals by Generating a... — `rn_insurance_group_benefits_generate_baseline_census`
- Streamline Claim Payment Approvals with Built-In Financial Authority... — `rn_insurance_claims_financial_authority`

### Industries — Public Sector (46건)

- Accelerate Benefit Application Intake with Automatic AI-based Data... — `rn_aps_benefit_mgmt_prefill_application_data`
- Accelerate Setup with Salesforce Go — `rn_aps_salesforce_go_setup`
- Add Ad Hoc Tasks During Visits — `rn_psc_add_ad_hoc_tasks_during_visits`
- Answer Candidate Questions Instantly with Agentic Self-Service for... — `rn_psc_answer_candidate_employee_questions_agentic_self_service_trm`
- Apply for Multiple Benefits in a Single Application — `rn_aps_benefit_mgmt_apply_multiple_benefits`
- Authorize and Track Service Delivery Access Across Benefit and... — `rn_264_authorize_track_services`
- Automate Appointment Management with the Workforce Scheduling Agent — `rn_aps_workforce_scheduling_agent`
- Automate Recruitment, Education, and Interaction Workflows with... — `rn_psc_automate_workflows_action_plans`
- Benefit Management for Agentforce Public Sector — `rn_ps_benefit_mgmt_container`
- Build a Unified Taxpayer 360 Profile — `rn_264_ps_tax_dmo`
- Capture Authorized Representatives Information — `rn_psc_capture_authorized_representatives_information`
- Capture Program-Specific Details During Benefit Applications — `rn_aps_benefit_mgmt_capture_program_details`
- Catalog Services and Pricing with Product Catalog Management — `rn_264_ps_catalog_services`
- Collect Consent from Applicants — `rn_aps_recruitment_set_up_consent`
- Collect Fees for Public Sector Services with Inbound Payments... — `rn_psc_collect_fees_inbound_payments`
- Complete Field Work Offline in the Salesforce Field Service Mobile App — `rn_aps_workforce_scheduling_mobile_offline`
- Customize Claims Submission Forms and AI-Based Invoice Extraction — `rn_264_ps_customize_claims`
- Deflect Taxpayer Inquiries Automatically with Agentforce — `rn_264_ps_taxpayer_agentforce`
- Discover Amazon S3 File Content Semantically with Agentforce — `rn_aps_external_storage_search`
- Evaluate Eligibility Across Benefit Programs Simultaneously — `rn_aps_benefit_mgmt_evaluate_eligibility`
- Field App — `rn_aps_workforce_scheduling_field_app`
- Field Scheduling — `rn_aps_workforce_scheduling_field_scheduling`
- Guide License and Permit Applicants with Agentic Application Intake — `rn_psc_guide_license_permit_applicants_agentic_intake`
- License, Permit, and Inspection Management for Agentforce Public... — `rn_ps_lpi_mgmt_container`
- Manage Onsite and Field Work — `rn_aps_workforce_scheduling_manage_field_work`
- Manage Your Workforce in the Workforce Scheduling Operations Console — `rn_aps_workforce_scheduling_operations_console`
- New and Changed Connect REST APIs in Agentforce Public Sector — `rn_aps_new_changed_connect_api`
- New and Changed Objects in Agentforce Public Sector — `rn_psc_new_changed_objects`
- New Connect in Apex Class in Benefit Management — `rn_aps_benefit_mgmt_connect_in_apex`
- New Connect REST API and Apex Methods in Tax and Revenue Management — `rn_aps_tax_rev_apis`
- Outbound Payments for Agentforce Public Sector — `rn_ps_outbound_payments_container`
- Plan Workforce Coverage with Shift Management — `rn_aps_workforce_scheduling_shift_management`
- Provide Constituents a Self-Service Tax Portal — `rn_264_ps_tax_portal`
- Public Sector — `rn_public_sector_solutions`
- Public Sector Namespace — `rn_aps_benefit_mgmt_public_sector_namespace`
- Run Targeted Recruitment Campaigns — `rn_aps_recruitment_campaigns`
- Schedule and Optimize Field Work with Workforce Scheduling — `rn_aps_workforce_scheduling_schedule_optimize_field_work`
- Schedule Onsite Interactions with Agency Employees — `rn_aps_workforce_scheduling_onsite_interactions`
- Search for Locations and Addresses by Name — `rn_aps_location_address_picker`
- Set Up Workforce Scheduling for Your Entire Workforce — `rn_aps_workforce_scheduling_setup`
- Shift Scheduling — `rn_aps_workforce_scheduling_shift_scheduling`
- Simplify Appointment Scheduling with Unified Scheduling Flows — `rn_aps_workforce_scheduling_unified_scheduling_flows`
- Talent Recruitment Management for Agentforce Public Sector — `rn_ps_trm_container`
- Tax and Revenue Management for Agentforce Public Sector — `rn_ps_tax_rev_container`
- Unified Scheduling — `rn_aps_workforce_scheduling_unified_scheduling`
- Workforce Scheduling for Agentforce Public Sector — `rn_aps_workforce_scheduling_container`

### Industries — Energy & Utilities (26건)

- Access Energy & Utilities Objects with the Integration User — `rn_energy_access_objects_with_integration_user`
- Access Energy Service Agreements from the Contract Object Page Layout — `rn_energy_access_service_agreements_from_contract`
- Agentforce for Energy & Utilities — `rn_energy_agentforce_overview`
- Assign Connection Milestones Based on Application Programs — `rn_energy_new_connections_assign_by_program`
- Assign Milestone Owners for New Connections — `rn_energy_new_connections_assign_owners`
- Automate Cart Operations with Flows and Invocable Actions — `rn_energy_agentforce_cart_operations_flows`
- Boost Sales by Applying Promotions to a Quote and an Order — `rn_energy_promotions_quote_and_order`
- Compare Tariffs and Enroll Customers with Agentforce — `rn_energy_agentforce_compare_tariffs_enroll`
- Emergency Management — `rn_energy_emergency_management_overview`
- Enable Entitlements and Milestones for New Utility Connections — `rn_energy_new_connections_enable_milestones`
- Energy and Utilities — `rn_energy_and_utilities_cloud`
- Improve Consumer Sales Efficiency with Built-In APIs — `rn_energy_consumer_sales_efficiency_apis`
- Manage Incidents, Service Outages, and Callouts in Salesforce — `rn_energy_emergency_manage_incidents_callouts`
- Manage Quote Recipient Groups with Agentforce — `rn_energy_agentforce_quote_recipient_groups`
- Monitor SLA Compliance for Connection Milestones — `rn_energy_new_connections_monitor_sla`
- New and Changed Connect APIs in Energy & Utilities — `rn_energy_new_changed_connect_apis`
- New and Changed Invocable Actions in Energy & Utilities — `rn_energy_new_changed_invocable_actions`
- New and Changed Objects in Energy & Utilities — `rn_energy_new_changed_objects`
- New and Changed Standard Platform Events in Energy & Utilities — `rn_energy_new_changed_platform_events`
- New Connections and Program Management — `rn_energy_new_connections_overview`
- Receive Slack Notifications for Site Bulk Upload in Multisite — `rn_energy_slack_notifications_site_bulk_upload`
- Send Emergency Callout Notifications to Service Resources — `rn_energy_emergency_callout_notifications`
- Simulate Tariff Comparisons Using Dynamic Runtime Usage Weights — `rn_energy_simulate_tariff_comparisons_runtime_weights`
- Track Emergency Callout Compliance with Audit Trails — `rn_energy_emergency_callout_audit_trails`
- Track Milestones for New Utility Connections — `rn_energy_new_connections_track_milestones`
- Transform Pricing Capabilities in Tariff Comparison with a New... — `rn_energy_tariff_comparison_context_definition`

### Industries — Health (21건)

- Agentforce for Health — `rn_health_agentforce_for_health`
- Answer Patient Calls Around the Clock with Agentforce Voice — `rn_health_referral_management_agentforce_voice`
- Auto-populate Display Order for Action Plan Template Items — `rn_health_auto_display_order_action_plan_template`
- Automate Payer Contact Center Call Deflection, Wrap-Up, and Case... — `rn_health_agentforce_cc_voice_assistant_agent`
- Give Members Self-Service Answers to Drug Coverage Questions — `rn_health_agentforce_health_engagement_ss_drug_coverage`
- Health Engagement — `rn_health_health_engagement`
- Intelligent Appointment Management — `rn_health_intelligent_appointment_management`
- Measure Care Gap Campaign Impact with a Prebuilt Dashboard — `rn_health_health_engagement_analytics_dashboard`
- New and Changed Objects in Agentforce Health — `rn_health_new_objects`
- Optimize Response Recommendation Mapping for Assessment Questions — `rn_health_icm_response_recommendation_mapping`
- Process Document Extractions Directly from Amazon S3 Folders — `rn_health_doc_ai_s3_support`
- Reduce No-Shows with Automated Patient Journeys — `rn_health_referral_management_marketing_journeys`
- Referral Management — `rn_health_referral_management`
- Speed up Medicare Plan Enrollments with a Guided Flow — `rn_health_dhi_medicare_sales`
- Start Every Interaction with an AI-Generated Summary — `rn_health_pcc_gen_ai_summaries`
- Streamline Action Plan Template Assignments in Care Plan Workflows — `rn_health_icm_template_assignment`
- Summarize Provider Claims on Demand in Payer Contact Center — `rn_health_pcc_provider_claim_summaries`
- Sync Referrals Automatically Between Your EHR and Agentforce Health — `rn_health_referral_management_ehr_sync`
- Track Appointment API Usage with Digital Wallet — `rn_health_appointment_management_digital_wallet`
- Track the Full Referral Lifecycle with Tableau Next Dashboards — `rn_health_referral_management_tableau_next_dashboards`
- Upgrade Home Visit Scheduling with Dynamic Calendar and List Views — `rn_health_home_health_list_calendar_views`

### Industries — Automotive (21건)

- Accelerate Automotive Warranty Claim Adjudication with Agentforce — `rn_auto_accelerate_warranty_adjudication_agentforce`
- Adjudicate Warranty Claims — `rn_auto_adjudicate_warranty_claims`
- Agentforce for Automotive — `rn_auto_agentforce_for_automotive`
- Assign and Coordinate Repossession Agencies for Vehicle Recovery — `rn_auto_assign_repossession_agencies`
- Capture Every Cost Behind a Warranty Claim — `rn_auto_capture_warranty_claim_costs`
- Capture Recovery Costs with Repossession Item Cost and Cost Books — `rn_auto_capture_recovery_costs`
- Conduct Pre-Repossession Vehicle Appraisal and Financial Viability — `rn_auto_pre_repossession_appraisal_viability`
- Conduct Structured Vehicle Repossession Assessments — `rn_auto_structured_repossession_assessments`
- Create Agents for Automotive in the New Agentforce Builder — `rn_auto_create_agents_new_agentforce_builder`
- Create Pre-Repossession Records for Delinquent Vehicle Accounts — `rn_auto_create_pre_repossession_records`
- Enforce Legal Notice Requirements During Vehicle Collections — `rn_auto_enforce_legal_notice_requirements`
- Help Customers Buy Vehicles with the Sales Concierge Agent on Your... — `rn_auto_extend_automotive_sales_concierge_experience_cloud`
- Keep Every Claim Stakeholder in One Place — `rn_auto_keep_claim_stakeholders`
- Manage and Verify Vehicle Titles Before Repossession — `rn_auto_manage_verify_vehicle_titles`
- Managing Automotive Repossession — `rn_auto_managing_automotive_repossession`
- Monitor Delinquency with Consolidated Record Views and... — `rn_auto_monitor_delinquency_record_views_alerts`
- New and Changed Objects for Automotive Cloud — `rn_auto_new_and_changed_objects`
- Pause and Resume Vehicle Repossession with Hold Management — `rn_auto_pause_resume_repossession_holds`
- Set Up Automotive Features with a Single Click — `rn_auto_set_up_features_single_click`
- Submit Pre-Repossession Assessments for Manager Review and Approval — `rn_auto_submit_assessments_manager_review`
- Track Vehicle Locations During Repossession with Telematics — `rn_auto_track_vehicle_locations_telematics`

### Industries — Education (18건)

- Accelerate Proxy Experiences with a Portal Template — `rn_edu_accelerate_proxy_experiences_portal_template`
- Accept Transfer Credit Requests from Current Students on an... — `rn_edu_request_transfer_credit_from_portal`
- Automate Faculty Access to Course Data with a Standardized and... — `rn_edu_automate_faculty_access_management`
- Automate Higher Education Statistics Agency (HESA) Regulatory... — `rn_edu_automate_hesa_calculations`
- Automate Refund Processing for Student Overpayments — `rn_edu_automate_refund_processing_student_overpayment_refunds`
- Configure and Localize the Dynamic Application Experience — `rn_edu_localize_dynamic_application_data`
- Discover and Set Up More Education Features in Salesforce Go — `rn_edu_salesforce_go_updates`
- Extend Institutional Data for MortarCAPS Reporting and Intelligence — `rn_edu_regional_data_ext_mortarcaps`
- Keep Student Records Accurate as Curricula Evolve with Course... — `rn_edu_evolve_curricula_with_course_versioning`
- Manage Emergency Contacts and Authorized Pickups for Students — `rn_edu_manage_emergency_contacts_authorized_pickups_students`
- Manage Proxy Access to Student Records Through Delegated Access... — `rn_edu_manage_proxy_access_student_records_delegated_access_management`
- New and Changed Objects in Education — `rn_edu_new_and_changed_objects`
- Post Transfer Credits and Preview Degree Impact — `rn_edu_post_transfer_credits_preview_degree_impact`
- Resolve Student Absences with the Attendance Management Agent — `rn_edu_resolve_absences_with_voice_agent`
- Share Billing Details with Your Students — `rn_edu_share_billing_details_students`
- Spread Tuition Payments with Flexible Payment Plans — `rn_edu_spread_tuition_payments_flexible_payment_plans`
- Track the Complete Student Journey with the Recruitment and... — `rn_edu_track_student_journey_with_rcrt_adms_funnel`
- Unify Attendance Signals into One Trusted Record — `rn_edu_unify_attendance_signals_into_trusted_record`

### Industries — Manufacturing (16건)

- Accelerate Manufacturing Warranty Claim Adjudication with Agentforce — `rn_mfg_warranty_claim_adjudication_agent`
- Accelerate Warranty Claim Refunds with Automated Parts Returns — `rn_mfg_warranty_parts_return`
- Agentforce for Manufacturing — `rn_mfg_agentforce_parent`
- Align Demand Plans with Product Demand Insights — `rn_mfg_tableau_product_demand`
- Assess Manufacturing Account Health and Retention Risk — `rn_mfg_tableau_account_health`
- Benchmark Manufacturing Pricing and Elasticity Across Accounts — `rn_mfg_tableau_pricing_insights`
- Build Manufacturing Ready Agents in the New Agentforce Builder — `rn_mfg_agentforce_builder`
- Calculate Advanced Pricing for Manufacturing Sales Orders — `rn_mfg_advanced_pricing_sales_orders`
- Close Deals Faster in Slack with Industries Sales Assistance — `rn_mfg_industries_sales_assistance_slack`
- Compare Planned vs. Actual Product Demand Across Manufacturing... — `rn_mfg_tableau_product_performance`
- Drive Accurate Order Capture with Integrated Pricing — `rn_mfg_order_capture_integrated_pricing`
- Keep Manufacturing Orders on Track from Booking to Fulfillment — `rn_mfg_tableau_order_status`
- New and Changed Objects for Manufacturing — `rn_mfg_new_changed_objects`
- New Connect REST APIs in Manufacturing — `rn_manufacturing_new_and_changed_connect_apis`
- Set Up Industries Sales Concierge Agent with a Single Click — `rn_mfg_single_click_setup`
- Tableau Next for Manufacturing — `rn_mfg_tableau_next_parent`

### Industries — Media (14건)

- Accelerate Inventory Booking with Bulk Line-Item Creation — `rn_media_bulk_add`
- Boost Win Rates with Request for Proposal Management (Generally... — `rn_media_rfp_management`
- Discover Agentforce Media Features with Salesforce Go — `rn_media_salesforce_go`
- Drive Ad Revenue with Out-of-Home Campaigns — `rn_media_out_of_home`
- Drive Promotions with Coupon Codes — `rn_media_slm_coupon_based_promotions`
- Expand Subscription Sales with Partial-Term Discounts — `rn_media_slm_term_based_promotions`
- Expedite Media Plan Delivery with Custom Quote Line Groups — `rn_media_quote_line_grouping`
- Increase Campaign Impact with Sponsored Products — `rn_media_sponsored_products`
- Maximize Retail Impact with In-Store Media Campaigns — `rn_media_in_store`
- Model Product Dependencies Without Bundling — `rn_media_slm_linear_relationships`
- New and Changed Connect APIs — `rn_media_new_and_changed_connect_apis`
- New Invocable Actions in Agentforce Media — `rn_media_new_invocable_actions`
- Optimize Ad Targeting with Data 360 Audience Segments (Beta) — `rn_media_targeting_data_360`
- Protect Campaign Profitability with Promotion Groups — `rn_media_slm_stackability_rules`

### Industries — Financial Services (7건)

- Business Relationship Plans — `rn_fsc_business_relationship_plans`
- Create Agents for Financial Services in the New Agentforce Builder — `rn_fsc_agentforce_builder`
- Create Calculation and Analysis Worksheets for Origination Processes — `rn_fsc_origination_worksheet`
- Create Flexible Hierarchies with Rules — `rn_fsc_flexible_hierarchies_rules`
- Measure Deal Performance in Business Relationship Plans — `rn_fsc_brp_measure_deal_performance`
- Set Up Agentforce Financial Services from One Place — `rn_fsc_agentforce_fncl_svcs_initial_setup`
- Track Financial Deals in Business Relationship Plans to Meet Revenue... — `rn_fsc_brp_track_financial_deals`

### Industries — Consumer Goods·Retail Execution·TPM (8건)

- Changed Apex Class in Trade Promotion Management — `rn_tpm_abort_job_chain`
- Consumer Goods Cloud — `rn_consumer_goods_cloud`
- Customize Trade Planning Pages with a Developer API — `rn_tpm_customize_trade_pln_pages`
- Enable External Browser Login for Consumer Goods Cloud Mobile — `rn_retail_vs_code_modeler_external_browser_login`
- Manage Trade Promotions with User Experience Enhancements — `rn_tpm_user_experience_enhancement`
- Plan for Windows Server Based Modeler’s Retirement — `rn_retail_windows_modeler_retirement`
- Support More Product Category Share Records — `rn_tpm_trade_calendar_product_category_share_record_support`
- Visual Studio Code Based Modeler — `rn_retail_vscode_modeler`

### Industries — 공통 기능 (Common Features)·Omnistudio·Business Rules Engine (54건)

- Accelerate Scope 3 Reporting with Supplier Management — `rn_accelerate_scope_reporting_with_supplier_management`
- Accelerate Upsell and Cross-Sell Conversions with Efficient,... — `rn_asset_management_agentforce_upsell_cross_sell_quote_updates`
- Actionable List with Data 360 — `rn_actionable_list_dmo_overview`
- Automatically Generate and Maintain Household Names — `rn_fundraising_auto_household_naming`
- Build Reusable Service Intake Forms with Custom Components — `rn_build_reusable_service_intake_forms_with_custom_components`
- Build Targeted Client Lists with Data Model Objects (Generally... — `rn_actionable_list_dmo`
- Business Rules Engine — `rn_business_rules_engine_intro`
- Call Decision Tables from Omniscripts — `rn_bre_omniscript_decision_table_action`
- Channel Revenue Management — `rn_channel_revenue_management`
- Control Timesheet Entry Item Field Visibility — `rn_aslm_tmsht_timesheets_control_field_visibility`
- Create Accruals that Align with Your Rebate Programs — `rn_chrm_create_accruals_rebate_programs`
- Create Flexible Outbound Campaigns with Custom Templates — `rn_outbound_engagement_custom_templates`
- Create Households for Person Accounts During Gift Entry — `rn_fundraising_automate_household_gift_entry`
- Create Timesheets for a Crew Across a Date Range — `rn_aslm_tmsht_timesheets_create_across_date_range`
- Criteria-Based Search and Filter — `rn_criteria_based_search_and_filter`
- Deploy Components on Lightning Web Runtime Experience Cloud Sites — `rn_deploy_components_on_lightning_web_runtime_lwr_experience_cloud_sites`
- Deploy Search Experiences Faster with Prebuilt Templates — `rn_deploy_search_experiences_faster_with_prebuilt_templates`
- Display Context Attribute Values on Request Records — `rn_display_context_attribute_values_on_request_records`
- Extend Criteria-Based Search Actions to Experience Cloud Users — `rn_extend_criteria_based_search_actions_to_experience_cloud_users`
- Guide Users Through Screen Flows with Criteria-Based Search and... — `rn_guide_users_through_screen_flows_with_cbsf`
- Maintain Brand Consistency Across All Outbound Communications with... — `rn_outbound_engagement_custom_branding`
- Manage More Complex Business Processes with Action Plans — `rn_manage_more_complex_business_processes`
- Message Multiple Customers at Once from List Views — `rn_outbound_engagement_list_view_mass_actions`
- Modify Request Details After Submission — `rn_modify_request_details_after_submission`
- New and Changed Objects for Fundraising — `rn_fundraising_new_changed_objects`
- New and Changed Objects for Inventory Management — `rn_new_and_changed_objects_for_inventory_management`
- New and Changed Objects in Outbound Engagement — `rn_outbound_engagement_objects`
- New and Changed Objects in Supplier Engagement — `rn_new_and_changed_objects_in_supplier_engagement`
- Omnistudio for Industries — `rn_omnistudio_for_industries`
- Omnistudio Minor Releases — `rn_omnistudio_updates_minor_releases`
- Optimize Payout Calculation with Advanced Rebate Payouts — `rn_chrm_optimize_payout_advanced_rebate_payouts`
- Process Multiple Outcomes from Decision Tables in Standard... — `rn_bre_multiple_outcomes_standard_expression_sets`
- Reduce Errors in Expression Set Conditions with Picklist Value... — `rn_bre_picklist_value_suggestions`
- Resolve Date Conflicts When Creating Timesheets Across a Date Range — `rn_aslm_tmsht_timesheets_resolve_date_conflicts`
- Reuse Autolaunched Flow Logic Across Your Flexcards (Generally... — `rn_omnistudio_flexcard_autolaunched_flow`
- Run Business Rules Engine Logic in Agentforce — `rn_bre_agentforce_actions`
- Run Flexcards and Omniscripts Offline on Mobile Devices — `rn_omnistudio_flexcard_omniscript_offline_mobile`
- Run Outbound Engagements in the Background and Keep Working — `rn_outbound_engagement_async_processing`
- Run Tasks on Demand to Meet Regulatory and Customer Deadlines — `rn_stage_management_on_demand_tasks`
- See Decision Table Status at a Glance from the List View — `rn_bre_decision_table_status_list_view`
- Simplify Communications with Generic Events — `rn_outbound_engagement_generic_events`
- Simplify Omnistudio Component Deployments with Clean Metadata — `rn_omnistudio_clean_metadata_deployment`
- Simplify Program and Case Management Feature Setup — `rn_npc_salesforce_go_configuration`
- Speed Up Bulk Actions by Selecting Entire Result Sets Instantly — `rn_speed_up_bulk_actions_by_selecting_entire_result_sets_instantly`
- Speed Up Decision Table Refreshes with Parallel Processing and... — `rn_bre_decision_table_parallel_refresh`
- Standardize and Secure Grant Application Evaluation Stages — `rn_grantmaking_evaluation_action_plan_templates`
- Tailor Vehicle Selection Options by Service Resource Profile for... — `rn_aslm_tmsht_timesheets_vehicle_selection_options`
- Timesheets and Labor Cost Optimization — `rn_aslm_tmsht_timesheets_overview`
- Track Supplier Risk Across Your Multi-Tier Supply Chain (Pilot) — `rn_supply_chain_resiliency_pilot`
- Track Unusable Inventory to Maintain Accurate Available Stock Levels — `rn_asset_management_track_unusable_inventory`
- Updated Objects and Fields in Grantmaking — `rn_grantmaking_updated_objects_and_fields_in_grantmaking`
- Use More Data Types in CSV-Based Decision Tables — `rn_bre_csv_decision_table_data_types`
- Use the Branch Element in Context-Aware Expression Sets — `rn_bre_list_branch_element`
- Validate Documents During Upload and Prefill Assessment Forms with AI — `rn_validate_uploaded_documents_prefill_assessment_forms_ai`

### Marketing — Marketing Cloud Next · Account Engagement (56건)

- Add New Fields and Individual Records Easily to Marketing Objects — `rn_mktg_add_fields_records_marketing_objects`
- Answer Unmatched Inbound SMS and WhatsApp Messages with a Default... — `rn_mktg_sms_whatsapp_default_response`
- Archive High-Volume Emails in Your Own Cloud Storage — `rn_mktg_email_archiving`
- Archive Outbound Emails with Compliance BCC — `rn_mktg_email_compliance_bcc`
- Archived Release Notes — `rn_marketing_engagement_archive`
- Automate Follow-Up Tasks with Marketing Completion Actions — `rn_mktg_marketing_actions`
- Automatically Update Consent Data in Record-Triggered Flows — `rn_mktg_consent_flow_action`
- Build and Clone Marketing Lists Directly from Your Workflow — `rn_mktg_actionable_lists`
- Build Landing Pages and Forms with Custom HTML — `rn_mktg_lp_forms_custom_html`
- Build Personalization Once and Reuse It Across Every Channel — `rn_mktg_reuse_personalization`
- Centralize Your Web Tracking and Consent Banner Setup — `rn_mktg_go_web_tracking`
- Choose the Best Image with Recommenders — `rn_mktg_choose_with_recommenders`
- Connect Forms and Landing Pages to More Data Sources — `rn_mktg_connect_lp_forms_data_sources`
- Content Management — `rn_mktg_content_management`
- Create and Manage Content Programmatically Using REST API — `rn_mktg_development_apis_content`
- Create Campaign-Ready Content Faster with Agentforce Content Agent — `rn_mktg_agentforce_ACA`
- Customize Content with Newly Supported AMPscript and Handlebars... — `rn_mktg_development_apis_ampscript_handlebars_functions`
- Define Content Requirements for Distributed Marketing and Alerts — `rn_mktg_dm_required_phrases_character_limits`
- Delete Content and Folders in Bulk in Marketing Workspaces — `rn_mktg_content_bulk_delete`
- Deliver Email Templates Faster to Non-Marketing Users — `rn_mktg_dm_scheduled_flow_template`
- Disable Email Open and Click Tracking — `rn_mcae_email_tracking`
- Distribute Unique Coupon Codes in Your Marketing Messages — `rn_mktg_distribute_unique_coupon_codes_marketing_messages`
- Distributed Marketing and Alerts — `rn_mktg_dm_alerts`
- Expand Marketing Operations Automation with New Tools for the MCP... — `rn_marketing_new_mcp_tools`
- Extend Marketing Cloud Next Access to Platform Plus Users — `rn_mktg_platform_user_license`
- Find Recommended Templates Using the Distributed Marketing Agent — `rn_mktg_dm_agent_recommended_templates`
- Fix Email Deliverability Problems with Step-by-Step Guidance — `rn_mktg_email_deliverability`
- Fix Tracked Links with Post-Send Link Editing — `rn_mktg_email_fix_tracked_links`
- Gain More Control over Preference Page Design and Subscription Content — `rn_mktg_consent_preference_pages`
- Keep Tabs on Campaign Content and Performance Metrics — `rn_mktg_campaigns_overview`
- Keep Your AI Agents and Teams on Brand with Brand Center — `rn_mktg_brand_kits`
- Landing Pages and Forms — `rn_mktg_landing_pages_forms`
- Launch Retail Journeys Faster with Welcome Series Triggers and Flow... — `rn_mktg_launch_retail_journeys_faster_welcome_series`
- Localize Emails Faster with Built-In Language Variants — `rn_mktg_translate_variants`
- Manage Landing Page Site Configuration with Marketing Sites — `rn_mktg_lp_marketing_sites`
- Manage the Sales Data Kit Independently — `rn_mktg_sales_data_kit`
- Measure Accurate SMS Click Rates with Bot Click Detection — `rn_mktg_sms_bot_click_detection`
- Monitor Email Deliverability Health and Receive Automatic Alerts — `rn_mktg_monitor_email_deliverability`
- Monitor Performance of Content Blocks with Impression Region Tracking — `rn_mktg_impression_region_tracking`
- Notify Shoppers About New Products in a Top Category — `rn_mktg_notify_shoppers_new_products_top_category`
- Personalize and Send Distributed Marketing Messages at Scale — `rn_mktg_dm_bulk_send_enhancements`
- Personalize Content in Channels with Scripting Support — `rn_mktg_scripting_in_channels`
- Personalize Landing Pages with Handlebars and AMPscript — `rn_mktg_lp_handlebars_ampscript`
- Reach WhatsApp Recipients with Usernames via Business-Scoped User IDs — `rn_mktg_reach_whatsapp_usernames`
- Route Outbound Emails Through Your Own Mail Servers — `rn_mktg_email_relay`
- Run Self-Optimizing Campaigns with Agentforce Marketing Goals Agent — `rn_mktg_agentforce_AMGA`
- Send Emails with Direct Email Send API — `rn_mktg_development_apis_direct_email_send`
- Send High Throughput Flash Messages to Targeted Mobile Audiences — `rn_mktg_flash_audiences`
- Set Up Marketing Cloud Next in One Place with Salesforce Go — `rn_mktg_go_setup_enhancement`
- Skip the Wait When Sending Emails to Contact and Lead Lists — `rn_mktg_list_sends`
- Target Marketing Triggers More Precisely with New Configuration... — `rn_mktg_triggers_new_configuration_options`
- Test Personalized Content as Any Recipient — `rn_mktg_preview_test`
- Track Mobile Push Performance in Your Content Performance Dashboard — `rn_mktg_mobile_push_performance`
- Track SMS Flow and Engagement Metrics in Flow Builder — `rn_mktg_sms_flow_metrics`
- Use Custom Flow Templates from a Campaign — `rn_mktg_flow_templates`
- View an Email as a Web Page — `rn_mktg_view_email_as_web_page`

### Marketing — Marketing Cloud Engagement (24건)

- Catch WhatsApp Direct Send Category Mismatches — `rn_mce_category_mismatches`
- Configure Your Login Allowlist Based on Recommended IP Ranges — `rn_mce_allowlist_recommended_ips_review`
- Connect Marketing Cloud Engagement to Data 360 with Salesforce Go — `rn_mce_go_setup`
- Connect Multiple Marketing Cloud Accounts to One Data Cloud Instance... — `rn_mce_connect_multiple_marketing_cloud_accounts_to_one_data_cloud_instance_for_whatsapp`
- Enable Two-Way Conversations for Marketing Cloud Engagement Emails — `rn_mce_conversational_email`
- Journey Builder and Automation Studio — `rn_mce_parent_journeys`
- Marketing Cloud Engagement+ — `rn_mce_parent_convergence`
- Messaging — `rn_mce_parent_messaging`
- Monitor Data Extension Access Events with Advanced Audit Trail — `rn_mce_data_extension_access_monitor`
- Monitor the Security Posture of Your Account with the Security... — `rn_mce_security_dashboard_view`
- Other Changes in Marketing Cloud Engagement — `rn_mce_parent_other_features`
- Prepare to Rotate Client Secrets for Installed Packages — `rn_mce_client_secrets_rotate`
- Prevent Filename Errors with Case-Insensitive Date and Time Tokens... — `rn_mce_prevent_filename_errors`
- Prevent Import API Jobs from Importing Stale Data — `rn_mce_import_maxfileagehours`
- Protect Against Phishing by Using Platform Authentication Systems — `rn_mce_platform_authenticator_login`
- Protect Your Integrations with Automatic Client Secret Revocation — `rn_mce_compromised_secrets_revoke`
- Provision and Secure Proxied Custom Domains for Your Sender... — `rn_mce_provision_secure_proxied_custom_domains_sender`
- Reach WhatsApp Users with Usernames Using Business-Scoped User IDs — `rn_mce_reach_whatsapp_usernames`
- Reauthenticate Using MFA for Security Tasks — `rn_mce_step_up_authentication`
- Reduce Duplicate Records with More Out-of-the-Box Match Rules — `rn_mce_ootb_ir_mce`
- Review Client Secret Statuses on the Installed Packages Summary Page — `rn_mce_installed_packages_summary_view`
- Review New and Upcoming Security Requirements for Marketing Cloud... — `rn_mce_upcoming_security_requirements`
- Security — `rn_mce_parent_security`
- Update Single Sign-On Accounts to Use MFA — `rn_mce_sso_mfa_amr_acc`

### Marketing — Marketing Intelligence (8건)

- Agentforce in Marketing Intelligence — `rn_mc_mi_analytics_insights`
- Backfill up to a Year of Historical Data from API Connectors — `rn_mc_mi_one_year_data_backfill`
- Data Management — `rn_mc_mi_data_management`
- Get Data-Driven Recommendations for Campaign Performance (Beta) — `rn_mc_mi_campaign_performance`
- Identify Expired Authentication Tokens in Connection Management — `rn_mc_mi_expired_tokens`
- Marketing Intelligence — `rn_mc_mi_marketing_intelligence`
- Review Recent Pipeline Run Success Rates — `rn_mc_mi_last_thirty_runs_column`
- Validate Ingested Data Faster with Pivot Tables — `rn_mc_mi_pivot_tables`

### Marketing — Salesforce Personalization (2건)

- Analyze Experiment Results with the Data Visualization Tab — `rn_persnl_data_viz_tab`
- Deliver Personalized Mobile Experiences Without Rebuilding Your App — `rn_persnl_personalize_mobile_lowcode`

### Loyalty Management (10건)

- Analyze Loyalty Programs with More Tableau Next Dashboards — `rn_loyalty_more_tableau_next_dashboards`
- Apply Discounts and Issue Rewards in a Single API Call — `rn_loyalty_unified_execution`
- Increase Engagement by Rewarding Members at Multiple Milestone... — `rn_loyalty_multiple_milestone_levels`
- Maximize Loyalty Promotion ROI with Predictive AI — `rn_loyalty_promotions_predictive_ai`
- New and Changed Objects in Loyalty Management — `rn_loyalty_new_and_changed_objects`
- Optimize Storage with Just-in-Time Member Currency Record Creation — `rn_loyalty_optimize_storage`
- Reduce Event Consumption with Smarter Loyalty Transaction Journal... — `rn_loyalty_reduce_event_consumption`
- Save Time with Incremental Data Kit Upgrades for Loyalty Management — `rn_loyalty_upgrade_tiers_faster`
- Simplify Loyalty Widget Deployment with Lightning Out 2.0 — `rn_loyalty_simplify_widget_integration`
- Use Mixed Expiration Models for Subtypes of Activity-Based Currencies — `rn_loyalty_mixed_expiration_subtypes`

### Real-Time Offer Management (GPM · Offer Management) (13건)

- Apply Rewards to All Eligible Products or Categories in Buy X, Get Y... — `rn_gpm_eligible_products_category`
- Control How Promotions Stack by Using Custom Evaluation Groups — `rn_gpm_promotion_group_subgroup`
- Create and Manage Promotions and Offers from Your Experience Cloud... — `rn_offers_experience_cloud`
- Create Industry-Specific Promotions with Decision Tables and Custom... — `rn_gpm_decision_table_template`
- Create Offers and Promotions from Briefs with Agentforce — `rn_offers_brief_agent`
- Create Promotions That Adapt to Each Customer's Purchase Behavior — `rn_gpm_personalized_promotions`
- Find Data Kits Easily with the New Real-Time Offer Management Name — `rn_offers_changed_datakit`
- Give External Systems Access to Promotion Details with the Promotion... — `rn_gpm_promotion_summary`
- New and Changed Objects in Global Promotions Management — `rn_gpm_new_and_changed_object`
- New and Changed Objects in Offer Management — `rn_offers_new_and_changed_objects`
- Personalize SMS, Push Notifications, and WhatsApp Messages with... — `rn_offers_whatsapp_and_push_notification`
- Show Personalized, Real-Time Offers in Your Mobile Apps — `rn_offers_mobile_sdk_app`
- Validate Coupon Codes Before Customers Apply Them — `rn_gpm_coupon_validation`

### Referral Marketing (3건)

- Boost Referral Conversion in Mobile-First Markets with SMS... — `rn_referral_boost_conversion_mobile_first_markets`
- Monitor Referral Promotion Performance by Using Tableau Next... — `rn_referral_monitor_promotion_performance_tableau_next`
- Simplify Referral Widget Deployment with Lightning Out 2.0 — `rn_referral_simplify_widget_integration`

### Service — Workforce Management (21건)

- Access Your Schedule Directly from Omni-Channel — `rn_workforce_mgmt_schedule_from_omni_channel`
- Balance Rest and Coverage with More Scheduling Rules — `rn_workforce_mgmt_scheduling_rules`
- Compare Required and Available Staffing at a Glance on the Capacity... — `rn_workforce_mgmt_compare_staffing_capacity_plan`
- Create Shifts Faster with Drag-and-Drop Templates — `rn_workforce_mgmt_drag_drop_shift_templates`
- Expand Workload Planning Across Multiple Work Sources — `rn_workforce_mgmt_workload_planning_sources`
- Find and Request Open Shifts to Fill Coverage Gaps — `rn_workforce_mgmt_open_shifts`
- Find Shifts Faster with Advanced Search and Filters — `rn_workforce_mgmt_advanced_search_filters`
- Forecast Demand with Skills-Based Workloads — `rn_workforce_mgmt_skills_based_workloads`
- Gain Visibility Into AI and Agent Performance — `rn_workforce_mgmt_ai_agent_performance`
- Generate More Flexible Shift Schedules with Shift Patterns — `rn_workforce_mgmt_flexible_shift_patterns`
- Get Real-Time Notifications About Shift Changes — `rn_workforce_mgmt_shift_notifications`
- Improve the Worker Calendar Experience — `rn_workforce_mgmt_worker_calendar`
- Manage Requests Without Leaving Schedule Manager — `rn_workforce_mgmt_manage_requests_schedule_manager`
- Manage Schedules with Scheduling Agent — `rn_workforce_mgmt_scheduling_agent`
- Monitor Net Staffing — `rn_workforce_mgmt_monitor_net_staffing`
- Optimize Intraday Staffing with Real-Time Adherence — `rn_workforce_mgmt_real_time_adherence`
- Organize Shift Work with Shift Activities — `rn_workforce_mgmt_shift_activities`
- Plan Staffing with Skills-Based Capacity Plans — `rn_workforce_mgmt_skills_based_capacity_plans`
- Save Time Generating Shifts from Patterns or Capacity Plans — `rn_workforce_mgmt_generate_shifts_patterns_plans`
- Simplify Workforce Management Discovery and Setup — `rn_workforce_mgmt_discovery_setup`
- Support Skills-Based Planning with Work Skill Groups — `rn_workforce_mgmt_work_skill_groups`

### Service — Service Assistant · Work Summaries (7건)

- Automate Summary Generation for Enhanced Messaging — `rn_work_summaries_auto_messaging`
- Automate Summary Generation for Voice Calls — `rn_work_summaries_auto_voice`
- Generate Work Summaries for Enhanced Messaging and Voice Calls in... — `rn_work_summaries_additional_languages`
- Respond Faster and More Accurately to Customers with Service Replies... — `rn_sra_msg_sr`
- Scale Service Assistant Across More of Your Business with Multiple... — `rn_sra_multi_agent`
- Start Messaging Service Plans Automatically — `rn_sra_msg_auto_start`
- Work Summaries for Case (Beta) Is Being Retired — `rn_work_summaries_case_beta_retirement`

### Service — Case·Knowledge·Messaging·HR Service·Self Service (19건)

- Automate HR Workflows with Prebuilt HR Agents — `rn_hr_svc_prebuilt_hr_agents`
- Capture WhatsApp Flow Responses Submitted After a Messaging Session... — `rn_messaging_wa_flow_after_session`
- Deploy HR Workflows Faster with Added Service Templates to Your HR... — `rn_hr_svc_workflow_templates`
- Deploy Messaging Automatically During Agentic Portal Setup — `rn_deploy_messaging_automatically_during_agentic_portal_setup`
- Easily Access and Review Service WhatsApp Health Status in Salesforce — `rn_wa_business_profile`
- Easily View Original Case Attachments Inline in Case Details — `rn_cases_easily_view_original_case_attachments`
- Find Transfer and Conference Destinations with Clearer Labels — `rn_messaging_byoc_transfer_conference_labels`
- Generate Enhanced Case Summaries in Five More Languages — `rn_enhanced_summaries_additional_languages`
- Guide Customers Through Troubleshooting Steps with a Reusable Action — `rn_guide_customers_through_troubleshooting_steps_with_a_reusable_action_pilot`
- Platform Events — `rn_messaging_platform_events_section`
- Protect Confidential Cases with Case Visibility Policies — `rn_hr_svc_cnfd_case_policy_engine`
- Reach Customers with In-App Notifications for Proactive Service — `rn_reach_customers_with_in_app_notifications_for_proactive_service`
- Reduce Storage Bloat and Keep Records Clear by Deleting Outdated... — `rn_entitlements_deleting_outdated_case_milestones`
- Refine Case Comments with AI-Powered Writing Tools — `rn_cases_refine_case_comments_with_ai_powered_writing_tools`
- Report on Service Reps’ Time Between Session Acceptance and First... — `rn_accept_to_first_response`
- Seamlessly Create and Troubleshoot WhatsApp Account Setup in... — `rn_wa_embedded_signup_v4`
- Set Up a Help Agent in One Guided Workflow — `rn_set_up_a_help_agent_in_one_guided_workflow`
- Set Up Your Agentic Portal Faster with a Guided Setup Wizard — `rn_set_up_your_agentic_portal_faster_with_a_guided_setup_wizard`
- Simplify Case Merging with the Revamped Case Merge UI — `rn_cases_enhanced_case_merge_updated_ui`

### Data 360 · Analytics (Reports and Dashboards 포함) (24건)

- Compare Data 360 Objects Side by Side with Data 360 Joined Reports — `rn_data360_reports_joined_reports`
- Control Currency Handling for Data Processing Engine Definitions — `rn_dpe_currency_conversion`
- Data 360 Reports and Dashboards — `rn_rd_dc_reports_dashboards`
- Embed Lightning Dashboards in Your Lightning Web Runtime Experience... — `rn_rd_dashboards_lwr`
- Embed Lightning Reports in Your Lightning Web Runtime Experience... — `rn_rd_embed_reports_lwr`
- Enhance Data Security with Granular Governance for Data Graphs — `rn_cdp_2026_winter_dg_granular_gov`
- Expand Field Type Compatibility for Copy Field Enrichments — `rn_expand_field_type_compatibility_for_copy_field_enrichments`
- Find the Right Report Type Faster with Improved Report Search (Beta) — `rn_data360_reports_improved_report_search`
- Identify Customer Sentiment in Data 360 Reports (Beta) — `rn_data360_reports_customer_sentiment`
- Match Copy Field Enrichments on More Than the Primary Key — `rn_match_copy_field_enrichments_on_more_than_the_primary_key`
- Migrate to the Data 360 Engagement Timeline — `rn_migrate_to_the_data_360_engagement_timeline`
- Perform Faster Drill-Downs with Dimensional Hierarchies in Data 360... — `rn_data360_reports_dimensional_hierarchies`
- Preview Records from Lightning Reports Without Losing Context (Beta) — `rn_rd_reports_record_preview`
- Reliability Changes in Data Processing Engine — `rn_dpe_other_improvements`
- Report on Multiple Currencies in Data 360 Reports — `rn_data360_reports_multicurrency`
- Reports and Dashboards — `rn_rd_reports_dashboards`
- Roll Up Only the Lowest-Tier Values in Hierarchy Nodes — `rn_dpe_exclude_parent_value`
- See Relevant Report Data by Using Organizational Hierarchies in Data... — `rn_data360_reports_org_hierarchies`
- Send Data Transformation Results to Virtual Objects — `rn_dpe_virtual_entity_writeback`
- Show Only Matching Records Across Blocks in Joined Reports (Beta) — `rn_rd_joined_reports_show_common_rows`
- Simplify Definitions with Multiple Formulas in a Single Node — `rn_dpe_formula_sequencing`
- Simplify Your Navigation with the Updated Data 360 Menu — `rn_cdp_2026_winter_nav_resources`
- Transform and Integrate Data with Picklist-Dependent Fields — `rn_transform_and_integrate_data_with_picklist_dependent_fields`
- Use the Snowflake Zero-Copy V2 Connector for Enhanced Data Sharing — `rn_cdp_2026_summer_snowflake_v2`

### AI Relationship Research — `rn_airr_*` (상위 클라우드 미상) (3건)

- AI Relationship Research — `rn_airr_ai_relationship_research`
- Flag and Fix Outdated Employer Data with Secondary Research Data... — `rn_airr_post_research_validation`
- Uncover More Relationships by Choosing Which CRM Objects to Search — `rn_airr_crm_search_enhancements`

### Partner Cloud (8건)

- Automate Objective Management and Link Records for Joint Business... — `rn_partner_cloud_automate_joint_business_plan_objectives`
- Book Appointments on Partner Calendars with Einstein Activity Capture — `rn_partner_cloud_connect_partner_calendars`
- Discover and Enroll in Vendor Campaigns from Campaign Marketplace — `rn_partner_cloud_campaign_marketplace`
- Enable Partners to Create Joint Business Plans — `rn_partner_cloud_partners_create_joint_business_plans`
- Enhance Partner Experiences with Loyalty and PEM Components in... — `rn_partner_cloud_loyalty_pem_components`
- Enhance Partner Experiences with PEM Components in Partner Central... — `rn_partner_cloud_pem_components_enhanced`
- Manage Marketing Development Funds with Agentforce Partner Success... — `rn_partner_cloud_agentforce_mdf`
- Track Partner Activity Across Customer Interactions — `rn_partner_cloud_track_partner_customer_activity`

### AgentExchange (5건)

- Identify FDE Partner Network Consultants on AgentExchange — `rn_identify_fde_partner_network_consultants_on_agentexchange`
- Identify Trialforce Email-Sending Domains That Need Verification — `rn_appexchange_trialforce_identify_domain_verification`
- Install AgentExchange Apps Without Leaving Your Workflow — `rn_agentexchange_track_app_installs`
- Request App Installs and Updates From Your Admin (Beta) — `rn_agentexchange_request_app_install`
- View the FDE Badge on Your AgentExchange Listing — `rn_show_the_fde_badge_on_your_agentexchange_listing`

### Salesforce Suites · Scheduler · Slack (6건)

- Agentforce Now Included in Free Suite — `rn_suites_agentforce_in_free`
- Check Partner Calendar Availability Before Booking — `rn_ls_check_partner_calendar_availability_before_booking`
- Create Salesforce Scheduler Agents in the New Agentforce Builder — `rn_ls_create_scheduler_agents_in_agentforce_builder`
- Integrate Your External App Data with Salesforce Suites Using... — `rn_suites_integrate_external_app_data`
- Sell Smarter in Slack: Agentforce Sales and the New Go Page — `rn_slack_agentforce_sales_for_slack`
- Skip the Wait When Sending Emails to Contact and Lead Lists in... — `rn_suites_list_sends`

### Platform·Development 소관 (Clouds 배치에 섞여 들어온 항목) (24건)

- Accelerate Lightning Development with SLDS AI Skills — `rn_slds_ai_skills`
- Access the Chatter Profile Page to Designate Employee Users — `rn_access_user_profile_page`
- Add Multiple Flow Approval Processes to a Record with the Request... — `rn_experience_cloud_request_approvals_component`
- Add the Follow Button to the Dynamic Highlights Panel — `rn_lab_dyhi_follow`
- Changed Connect in Apex Enums — `rn_connect_in_apex_enums`
- Changed Connect in Apex Output Classes — `rn_connect_in_apex_output_classes`
- ConnectApi (Connect in Apex): New and Changed Classes and Enums — `rn_connect_in_apex`
- Control Your Salesforce Edge Network Routing with Self-Serve Setup — `rn_control_edge_network_routing_with_self_serve`
- Customize Components with the SLDS 2 Styling API and Component-Level... — `rn_slds_c_level_hooks`
- Defer Sharing Calculations for Bulk Unified Employee License Updates — `rn_defer_sharing_calculations_UEL_upgrades`
- Enable Field History Tracking for Users (Generally Available) — `rn_field_history_tracking_ga`
- Keep Manual Shares When Transferring Records — `rn_sharing_retain_manual`
- Launch a Native Agentforce Panel in Mobile Publisher Apps — `rn_experience_mobile_native_agentforce_panel`
- Make Inline Editing in List Views More Flexible — `rn_list_views_inline`
- New Connect in Apex Classes — `rn_connect_in_apex_classes`
- Open the Next Work Item from the Same Orchestration Run in... — `rn_experience_cloud_work_guide_component_update`
- Previous Release Notes — `rn_previous_release_notes`
- Protect Custom Object Access with Unified Employee License... — `rn_protect_custom_object_access_UEL_restrictions`
- Review Updated Label Translations — `rn_globalization_review_label_translations`
- Streaming API Replay Tightening — `rn_streaming_api_replay_tightening`
- Streamline Flow Integrations with External Services Support for Any... — `rn_ext_services_any_type_support`
- Unblock Connected App OAuth Installations in Pre-2018 Developer Orgs — `rn_unblock_connected_app_install`
- Update and Customize Solutions Safely — `rn_update_and_customize_solutions_safely`
- Update Apex Code and Flows for Changed Sharing Recalculation... — `rn_sharing_apex_recalc`

---

## 관련 노트

**Winter '27 형제 노트**
- [[Winter '27]] — Winter '27 릴리즈 허브 (상위)
- [[Winter '27/Release Updates]] — **Release Update 강제 적용 시점의 단일 출처**. 이 노트가 "Release Update 있음"으로만 표시한 항목의 날짜는 전부 여기 소관
- [[Winter '27/Development]] — Apex·LWC·Connect REST·External Services·Scalability·Experience Cloud 등 개발자 표면
- [[Winter '27/Platform]] — SLDS·Lightning App Builder·권한/공유·라이선싱·Globalization 등 플랫폼 표면
- [[Winter '27/Agentforce]] — Agentforce & Generative AI 영역. **`rn_agentforce_it` 허브 요약이 그쪽에 있고, 하위 51리프의 기능 상세(Where·Who·How)는 이 노트의 `## Agentforce IT Service` 절이 단일 출처**다

**직전 릴리즈 비교**
- [[Summer '26/Clouds]] — 직전 릴리즈의 Clouds 영역
- [[Winter '26/Clouds]] — 1년 전 Winter 릴리즈의 Clouds 영역 (Data Cloud→Data 360 리브랜드 시점)
- [[Release MOC]] — 전체 릴리즈 노트 목차

**제품 기반 지식 (릴리즈 노트가 전제하는 개념)**
- [[Sales Cloud 개요]] — Agentforce Sales로 리브랜드되기 전 제품 기준선
- [[Service Cloud 개요]] · [[Service Cloud Voice]] — Partner Contact Center(구 Service Cloud Voice) 텔레포니 데이터 모델
- [[Revenue Cloud 개요]] — Agentforce Revenue Management의 PCM·Pricing·Configurator 기반
- [[Commerce Cloud 개요]] — B2B/B2C Commerce 구조
- [[Marketing Cloud 개요]] — Marketing Cloud Next·Engagement·Account Engagement 구분
- [[Data Cloud 개요]] — Data 360의 데이터 모델·data space 기반
- [[CRM Analytics 개요]] — CRM Analytics 렌즈·대시보드 개념
- [[Field Service 개요와 데이터 모델]] — Service Appointment·Work Order·ESO 기반
- [[Knowledge 데이터 모델 & API 개요]] — Knowledge Blocks·Knowledge Similarity가 얹히는 기반
- [[OmniStudio 개요·오리엔테이션]] — Flexcard·Omniscript 기반

**Agentforce IT Service 절이 전제하는 개념**
- [[Queues (큐)]] · [[Public Groups (공개 그룹)]] — Assigned Group이 **공개 그룹만** 받게 바뀌고 큐 라우팅이 Incident Owner로 이동한 변경의 기반
- [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] — 서비스 요청 Omni-Channel 라우팅(큐·스킬·여력)의 기반
- [[Entitlements & Milestones (엔타이틀먼트·마일스톤)]] — VIP 특권 기반 엔타이틀먼트 자동 할당이 얹히는 SLA 모델
- [[User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형)]] — 이 영역 게이트의 상당수가 **PSL**(AI for Employee Portal · BroadcastCommsSender · IT Service Compliance Analytics)이다
- [[Permission Set Groups (권한 집합 그룹)]] — Dynamic Discovery가 요구하는 **IT Service Asset Discovery PSG**의 개념
