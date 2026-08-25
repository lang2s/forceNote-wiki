---
tags: [release, winter_27, clouds, sales, revenue, service, commerce, marketing, data360, analytics, industries, publicsector, insurance, lifesciences, loyalty, partnercloud]
api_version: v68.0
release_date: 2026-10
created: 2026-08-25
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2)
aliases: [Winter '27 Clouds, 윈터27 클라우드, Agentforce Sales, Agentforce Revenue Management, Agentforce Commerce, Agentforce Contact Center, Partner Contact Center, Service Assistant 동적 서비스 플랜, Knowledge Blocks, Workforce Management, Marketing Cloud Next, Data 360 Engagement Timeline, Loyalty Management Winter 27, Industries Winter 27, 15000 line items, Agentforce IT Service, IT Service Management, ITSM Winter 27, 아이티 서비스, Hardware Asset Management, HAM, IT Asset Management, ITAM, CMDB Service Graph, Dynamic Discovery Splunk, IT Compliance, Employee Services 포털, Broadcast Communications, Incident Owner, Assigned User API 불가, Assigned Group 공개 그룹, Winter 27 Industries, Public Sector Winter 27, Taxpayer 360, Agentforce Public Sector, Workforce Scheduling Public Sector, Group Benefits Winter 27, Digital Insurance, Insurance Brokerage 40000, Agentforce Health, Payer Contact Center, Visit Agent, Life Sciences Cloud Winter 27, Whisper 632MB, Agentforce Energy Utilities, Emergency Management callout, New Connections Management, Agentforce Manufacturing, Advanced Pricing for Manufacturing, Agentforce Automotive, Repossession Management, Warranty Claims Adjudication, Enterprise Sales Management, Revenue Cloud for Communications, Industries CPQ, Agentforce Media, Out-of-Home 광고, Business Rules Engine Winter 27, Criteria-Based Search and Filter, Unified Catalog Winter 27, Outbound Engagement, Omnistudio Clean Metadata Deployment, Data 360 Reports, AI_SENTIMENT, Snowflake Zero-Copy V2, Copy Field Enrichments, Real-Time Offer Management, Global Promotions Management, Referral Marketing Winter 27, AI Relationship Research, AgentExchange Winter 27, Trialforce 도메인 검증, 2026-10-02 가용, 윈터27 산업, 윈터27 공공부문, 윈터27 보험, 윈터27 로열티]
---

# Winter '27 — Clouds (Sales · Revenue · Service · Commerce · Marketing · Analytics · Data 360 · Industries 등)

> Winter '27(v68.0) 클라우드 영역 **988페이지 전부를 본문까지 추출**해 실었다 — 제목만 있는 계층은 더 이상 없다. 핵심은 대규모 제품 리브랜드(Sales Cloud→Agentforce Sales 등), Revenue의 15,000 라인 대형 트랜잭션, Service Assistant 동적 서비스 플랜, Workforce Management 전면 확장, **Agentforce IT Service 51페이지**, 그리고 **Industries 343페이지**(Public Sector 46 · Communications 38 · Insurance 33 · Life Sciences 31 · Industries Common Features 54 등)다.

---

## ⚠️ 이 노트의 커버리지

Winter '27 릴리즈 노트의 Clouds 영역은 **988페이지**다. **그 전부를 본문까지 확보해 이 노트에 실었다.**

| 계층 | 페이지 수 | 이 노트에 실린 것 |
|---|---|---|
| **Tier 상세** (본문 전문) | **988** | 기능 설명 + **Where**(에디션·라이선스) + **How**(Setup 경로) + **Who**(권한 세트) + **When**(가용 시점) — 원문에 있는 만큼 전부 |
| 합계 | **988** | |

> **두 차례에 걸친 추출이다.** 1차로 **317페이지**(배치1 133 + 배치2 133 + Agentforce IT Service 51)를, 2차로 **롱테일 671페이지**를 본문까지 추출했다. 롱테일 671은 **실패 0 · 차단 0 · 페이지 단위 절단 0** 으로 전량 확보됐다. 이전 판이 두었던 **`Tier 랜딩요약(약 229)`** 과 **`Tier 제목만(671)`** 계층은 **모두 폐기**됐다 — 아래 `### 폐기된 계층` 참조.

### 2차 추출 671페이지의 영역별 분해 (합계 검산)

| 영역 | 페이지 | 이 노트의 위치 |
|---|---:|---|
| Industries (13개 산업 289 + Industries Common Features 54) | **343** | `## Industries` |
| Marketing (MCN·MCAE 56 · MCE 24 · Marketing Intelligence 8 · Personalization 2) | **90** | `## Marketing` |
| Revenue (Billing·Collections 31 · Pricing/Transaction/Ramp/Usage/Orchestration 39 · Product Catalog·Configurator 16 · Approvals/Promotions/Contracts 9) | **95** | `## Revenue` |
| Service (Workforce Management 21 · Case/Knowledge/Messaging/HR/Self Service 19 · Service Assistant·Work Summaries 7) | **47** | `## Service` |
| Data 360 · Analytics (Reports and Dashboards 포함) | **24** | `## Analytics` · `## Data 360` |
| Loyalty Management 10 + Real-Time Offer Management 13 | **23** | `## Loyalty Management · Real-Time Offer Management · Referral Marketing` |
| Partner Cloud | **8** | `## 그 밖의 영역` |
| Salesforce Suites 3 · Scheduler 2 · Slack 1 | **6** | `## 그 밖의 영역` · `## Slack` |
| AgentExchange | **5** | `## 그 밖의 영역` |
| Referral Marketing | **3** | `## Marketing` (원문이 Marketing 영역에 배치) |
| AI Relationship Research (`rn_airr_*`, 상위 클라우드 미상) | **3** | `## 그 밖의 영역` |
| **Platform·Development 소관 (위임)** | **24** | `### Platform·Development로 위임한 항목` — page id만 |
| **합계** | **671** | |

### 폐기된 계층 — 이전 판을 기억하는 독자를 위해

| 폐기된 계층 | 이전 정의 | 지금 |
|---|---|---|
| **Tier 제목만 (671)** | 릴리즈 노트 제목과 page id뿐 | **폐기.** 671건 전부 본문 확보 → 클라우드별 섹션에 편입. **`## 제목 카탈로그` 절도 함께 삭제**됐다 |
| **Tier 랜딩요약 (약 229)** | 리프는 미추출이지만 **부모 허브가 담은 1~3문장 자식 요약**은 확보된 항목 | **폐기.** 이 계층의 존재 이유는 *"리프 본문이 없어서 허브 요약으로 대신한다"* 였는데 **이제 모든 리프에 본문이 있으므로 대체재로서의 의미가 사라졌다.** 재정의(*"리프 본문은 있으나 허브 요약이 더 상세한 항목"*)도 검토했지만 **실제로 그런 항목이 없다** — 확인해 보면 허브 요약은 예외 없이 리프 첫 문단의 축약이고, **Where·How·Who·When은 리프에만 있다**. 성립하지 않는 계층을 이름만 남겨 두는 것이 더 해롭다고 판단해 **되살리지 않고 폐기**한다. 허브 페이지 자체의 정의문(예: `rn_ins`·`rn_edu`·`rn_media_cloud`)은 각 절 서두에 **"허브 원문"** 으로 인용해 남아 있다 |

### 본문이 부분만 확보된 페이지 4개 — 유일하게 남은 공백

**988페이지 중 984페이지는 본문 전문**이다. 아래 **4페이지만 소스 덤프가 앞부분에서 절단**됐다(앞 3개는 원문이 너무 길고 반복적이어서, 네 번째는 월별 change log stub 지점에서).

| page id | 원문 크기 | 확보량 | 상태 |
|---|---|---|---|
| `rn_feature_impact` — How and When Do Features Become Available? | **85,351자** | **약 3,600자** | 전 제품의 *기능 × 활성화 방식(Enabled for users / for admins / Requires setup / Contact Salesforce)* 매트릭스. **이 노트는 이 매트릭스를 옮기지 않는다.** 개별 기능의 활성화 방식이 필요하면 원문을 직접 봐야 한다. ⚠️ 단 **각 기능의 Where·How·Who·When은 그 기능의 리프 페이지에서 이미 확보**했으므로 이 매트릭스가 없어서 생기는 실질 공백은 "활성화 방식 4분류" 뿐이다 |
| `rn_fieldservice_desktop_updates` — Field Service Desktop Monthly Patch Notes | **22,201자** | **약 2,000자** | 월별 개별 버그 수정 목록. 아래 Field Service 절에 확인분만 기재 |
| `rn_fieldservice_mobile_patch_notes` — Field Service Mobile Monthly Patch Notes | **17,344자** | **약 2,000자** | 동일 |
| `rn_communications_cloud` — Communications (Industries 랜딩) | **≈1,921자** | **약 1,890자** | 덤프가 `[truncated at ~1,921 chars total; remaining content is the monthly change log stub]` 로 끝난다. **산업 축 요약(Agentforce for Enterprise Quoting · Communications Insights · Enterprise Sales Management · Revenue Cloud for Communications)은 확보**됐고 잘린 나머지는 **Communications Release Note Changes by Month(월별 change log) stub** 이라 기능 정보 손실은 사실상 없다 |

> **네 페이지 모두 "기능 페이지"가 아니다** — 1개는 활성화 매트릭스, 2개는 월별 버그 수정 목록, 1개는 산업 랜딩(잘린 부분이 change log). 따라서 **기능 상세가 부분만 실린 페이지는 0건**이다.

### Agentforce IT Service(`rn_it_*`) 51페이지 — 구 최대 공백, 전수 확보

`rn_it_service_*` 19 + `rn_it_srvcs_*` 32 = **51페이지 전부를 본문까지 추출**해 아래 **`## Agentforce IT Service`** 절에 실었다.

| 구분 | 상태 |
|---|---|
| `rn_agentforce_it` 허브 (9개 하위 섹션 요약) | [[Winter '27/Agentforce]]에 있음 (상위 라우팅 전용) |
| `rn_it_service_*` (19페이지) + `rn_it_srvcs_*` (32페이지) = **51페이지** | **본문 전수** — 이 노트 `## Agentforce IT Service` 절 |
| 결론 | **Agentforce IT Service 기능 상세의 단일 출처 = 이 노트의 해당 절** |

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
| Energy & Utilities Cloud | **Agentforce Energy & Utilities** | *"Energy & Utilities Cloud is now Agentforce Energy & Utilities."* (`rn_energy_and_utilities_cloud`) |
| Salesforce Voice with Telephony Providers (구 Service Cloud Voice) | **Partner Contact Center** | *"Salesforce Voice with Telephony Providers (formerly Service Cloud Voice) is now Partner Contact Center."* |
| Agentforce Lead Nurturing | **Agentforce Engagement** | 2026-08-24부터. *"The new name better describes the range of work the agent can perform."* |
| Messaging for In-App and Web | **Enhanced Chat** | Self Service 절의 괄호 표기 *"Enhanced Chat (formerly Messaging for In-App and Web)"* |
| Global Promotions Management 데이터 킷 | **Real-Time Offer Management** 데이터 킷 | 데이터 킷 **이름만** 변경 (`rn_offers_changed_datakit`) |
| Data Cloud | **Data 360** | 2025-10-14부 리브랜드가 계속 유지됨(Winter '27 원문 재확인) |

> 리브랜드는 **표기만** 바뀐다. 원문 공통 문구: *"functionality and content remains unchanged"* / *"You may see references to \<옛 이름\> in our application and documentation."*

### 등급 마커 일람 — 988페이지 본문에서 확인된 전수

**988페이지 전부의 본문을 확보했으므로 이 표는 "제목에 마커가 있는 것"이 아니라 "본문에 마커가 있는 것"의 전수다.** 이전 판이 두었던 **A(본문 확인) · A-2(매트릭스 행에서만 확인) · B(제목 문자열에서만 확인)** 3분할은 **폐기**됐다 — 근거가 모두 본문으로 통일됐기 때문이다. 특히:
- **A-2**(`rn_feature_impact` 매트릭스 행에서만 등급을 알 수 있던 Reports & Dashboards Beta 4건)는 **네 건 모두 자기 리프 본문에 Beta 고지가 있어** 아래 표로 흡수됐다.
- **B**(제목 문자열에만 마커가 있던 8건)도 **전부 본문으로 재소싱**됐다.

| 등급 | 항목 | page id | 근거·비고 |
|---|---|---|---|
| **GA** | Protect Your Work with a Dedicated CRM Analytics Recycle Bin | *(1차 추출 317 계층)* | CRM Analytics |
| **GA** | Build Targeted Client Lists with Data Model Objects | `rn_actionable_list_dmo` | Industries Common Features |
| **GA** | Perform Faster Drill-Downs with Dimensional Hierarchies in Data 360 Reports | `rn_data360_reports_dimensional_hierarchies` | **롱테일 본문에서 새로 발견** |
| **GA** | Enable Voice-Based Visit Logging (Visit Agent) | `rn_lsc_customer_engagement_execution_visit_agent` | Life Sciences — 이 릴리즈에서 전제가 가장 무거운 GA |
| **GA** | Boost Win Rates with Request for Proposal Management | `rn_media_rfp_management` | Media |
| **GA** | Reuse Autolaunched Flow Logic Across Your Flexcards | `rn_omnistudio_flexcard_autolaunched_flow` | Omnistudio |
| **GA** | Collect Fees for Public Sector Services with Inbound Payments | `rn_psc_collect_fees_inbound_payments` | **롱테일 본문에서 새로 발견** |
| **GA** | Use Complex Template Expressions in Lightning Web Components | *(1차 추출 317 계층)* | **Development 소관 → 위임** |
| **GA** | Use Third-Party Web Components in LWC (`lwc:external`) | *(1차 추출 317 계층)* | **Development 소관 → 위임** |
| **GA ⚠️ / Beta** | Enable Field History Tracking for Users | `rn_field_history_tracking_ga` | **원문 자기모순** — 제목은 *(Generally Available)*, 본문의 Setup 토글 이름은 **`Enable User Field History Tracking (Beta)`**. Platform 소관 → 위임 |
| **Beta** | Advisements — 위험 탐지 14→**21종** 확대 + 알림 트레이 통지 | *(1차 추출 317 계층)* | Salesforce Overall |
| **Beta** | Work in Arabic in the Field Service Mobile App | *(1차 추출 317 계층)* | Field Service Mobile |
| **Beta** | Setup with Agentforce | *(1차 추출 317 계층)* | Partner Contact Center 설정 전제 |
| **Beta ×2** | Enhanced Case Merge · Case Merge for Omni-Channel | `rn_cases_enhanced_case_merge_updated_ui` | **한 페이지가 두 Beta 기능을 명명**한다(페이지 제목 자체엔 마커 없음) |
| **Beta** | Optimize Ad Targeting with Data 360 Audience Segments | `rn_media_targeting_data_360` | Media |
| **Beta** | Request App Installs and Updates From Your Admin | `rn_agentexchange_request_app_install` | AgentExchange |
| **Beta** | Install AgentExchange Apps Without Leaving Your Workflow | `rn_agentexchange_track_app_installs` | ⚠️ **제목엔 마커가 없지만 본문에 pilot/beta 고지가 있다** |
| **Beta** | Identify Customer Sentiment in Data 360 Reports | `rn_data360_reports_customer_sentiment` | `AI_SENTIMENT` 함수 |
| **Beta** | Find the Right Report Type Faster with Improved Report Search | `rn_data360_reports_improved_report_search` | Data 360 Reports |
| **Beta** | See Relevant Report Data by Using Organizational Hierarchies in Data 360 | `rn_data360_reports_org_hierarchies` | **롱테일 본문에서 새로 발견** |
| **Beta** | Get Data-Driven Recommendations for Campaign Performance | `rn_mc_mi_campaign_performance` | Marketing Intelligence |
| **Beta** | Preview Records from Lightning Reports Without Losing Context | `rn_rd_reports_record_preview` | **구 A-2 → 본문 재소싱** |
| **Beta** | Embed Lightning Dashboards in Your LWR Experience Cloud Sites | `rn_rd_dashboards_lwr` | **구 A-2 → 본문 재소싱** |
| **Beta** | Embed Lightning Reports in Your LWR Experience Cloud Sites | `rn_rd_embed_reports_lwr` | **구 A-2 → 본문 재소싱** |
| **Beta** | Show Only Matching Records Across Blocks in Joined Reports | `rn_rd_joined_reports_show_common_rows` | **구 A-2 → 본문 재소싱** |
| **Beta 은퇴** | Work Summaries for Case (Beta) Is Being Retired | `rn_work_summaries_case_beta_retirement` | 유지보수 모드 → Enhanced Summaries 전환 권고 |
| **Pilot** | Keep an Audit Trail of Voice Call Record Changes — `VoiceCall` 필드 **최대 20개** 추적 | *(1차 추출 317 계층)* | Voice / Partner Contact Center |
| **Pilot** | Track Supplier Risk Across Your Multi-Tier Supply Chain | `rn_supply_chain_resiliency_pilot` | Industries Common Features — **계정 담당자 요청으로만 활성화** |
| **Developer Preview** | Customize Components with the SLDS 2 Styling API and Component-Level Hooks | `rn_slds_c_level_hooks` | **Platform 소관 → 위임** |
| **Release Update** | Update Apex Code and Flows for Changed Sharing Recalculation Behavior | `rn_sharing_apex_recalc` | **강제 시점은 [[Winter '27/Release Updates]] 소관 — 이 노트는 날짜를 쓰지 않는다** |

> **본문에는 마커가 있으나 리프 page id가 없는 2건(Omnistudio):** Public Sector 랜딩(`rn_public_sector_solutions`)의 공통 기능 요약이 **Omniscript·Flexcard의 LWR Experience Cloud 사이트 추가 (pilot)** 와 **Omnistudio Assistance AI Agent (pilot)** 를 명시한다. 이 둘은 Winter '27 Clouds 카탈로그에 독립 page id가 없어 Where·How를 확보하지 못했다 → `### Omnistudio` 절 하단 참조.

### 등급이 확인되지 않은 페이지 — 이전 판의 "미상 등급 657건"을 폐기하고 다시 센다

> **이전 판의 657은 재현되지 않는다.** 이전 판은 *"제목 계층 722 − 마커 8 − ... = 708"* 에서 51을 뺀 값이라고 적었지만 **722 − 8 − 4 = 710 ≠ 708** 이라 산식이 맞지 않았다. **그 숫자를 조정하지 않고 폐기하고, 아래처럼 처음부터 다시 센다.**

**새 산식 — "미상"의 정의부터 바뀐다.** 이전 판에서 "미상"은 *"제목만 있어서 본문을 못 봤으니 등급을 알 수 없다"* 는 뜻이었다. **지금은 984페이지의 본문을 전부 봤으므로, 본문에 마커가 없다는 것은 "모름"이 아니라 "마커가 없다"는 확정 사실**이다.

```text
// 구조 예시 — 실제 동작 코드 아님 (등급 미상 페이지 수 산출)
Clouds 총 페이지                                    988
  − 본문 전문 확보 (등급 판정 가능)                 984
  ─────────────────────────────────────────────────────
  = 본문 부분 확보 (등급 판정 불가) = 미상 등급        4
      rn_feature_impact                (활성화 매트릭스)
      rn_fieldservice_desktop_updates  (월별 패치 노트)
      rn_fieldservice_mobile_patch_notes (월별 패치 노트)
      rn_communications_cloud          (산업 랜딩 — 잘린 부분은 change log stub)

  판정 가능한 984 중
    · 마커 있음 = 위 표의 30행
        - 23행 : 2차(롱테일 671) 페이지 — page id 명시
        -  7행 : 1차(317) 페이지 — 이 노트가 page id를 남기지 않은 항목
        · 그중 rn_cases_enhanced_case_merge_updated_ui 1행은 한 페이지가 Beta 2개를 명명
          → 페이지 기준 30, 기능 기준 31
    · 마커 없음 = 나머지 954 — "미상"이 아니라 "원문에 등급 표시가 없는 표준 항목"
```

> **결론: 미상 등급 = 4페이지.** 그중 **기능 페이지는 0건**이다(1개는 활성화 매트릭스, 2개는 월별 버그 수정 목록, 1개는 잘린 부분이 change log인 산업 랜딩). 즉 **실질적으로 등급을 모르는 기능은 없다.**
>
> ⚠️ **다만 "마커 없음 = GA"로 읽지 말 것.** Salesforce 릴리즈 노트는 GA 기능에 마커를 붙이지 않는 것이 기본이지만, 원문이 명시하지 않은 것을 이 노트가 GA로 단정하지는 않는다.

### 구조 맵

```text
// 구조 예시 — 실제 동작 코드 아님 (Winter '27 Clouds 영역 커버리지 지도)
Winter '27 Clouds 영역 (988 페이지 — 전부 본문 확보)
├── ## Sales · ## Revenue · ## Service · ## Agentforce IT Service(51p)
├── ## Field Service · ## Commerce · ## Marketing(리프 90) · ## Analytics · ## Data 360
├── ## Industries (리프 343)
│   ├── Automotive 21   Communications 38   Industries CPQ 10   Consumer Goods 8
│   ├── Education 18    Energy & Utilities 26  Financial Services 7   Health 21
│   ├── Insurance 33    Life Sciences 31    Manufacturing 16   Media 14
│   ├── Nonprofit·Net Zero(랜딩만)          Public Sector 46
│   └── Industries Common Features 54 (Omnistudio 4 포함)
├── ## MuleSoft · ## Slack · ## Loyalty(10)·RTOM(13)   [Referral 3은 ## Marketing 안]
├── ## 그 밖의 영역 (Suites 3·Scheduler 2·Advisements·My Trust Center·Partner Cloud 8·AI Relationship Research 3·AgentExchange 5·CSG·Legal)
│
└── 소관 밖(위임 — page id는 `### Platform·Development로 위임한 항목` 표에)
    ├── Release Update 강제 시점 ......... [[Winter '27/Release Updates]]
    ├── Apex·LWC·Connect REST·External Services  [[Winter '27/Development]]
    ├── SLDS·Lightning App Builder·권한/공유·라이선싱  [[Winter '27/Platform]]
    └── Agentforce & Generative AI 영역 ... [[Winter '27/Agentforce]]
```

### 날짜가 박힌 항목 — 기한형 전수 + 2026-10-02 동시 가용 코호트

> ⚠️ **여기 적힌 날짜는 전부 "기능 가용·만료·은퇴" 시점이지 Release Update 강제 시점이 아니다.** Release Update의 강제 시점은 **[[Winter '27/Release Updates]]** 가 단일 출처이며 이 노트는 그 날짜를 한 건도 쓰지 않는다.

**A. 기한형 — 놓치면 동작이 바뀐다**

| 날짜 | 무슨 일이 일어나는가 | page id |
|---|---|---|
| **2026-07-30** | **MCE Step-Up Authentication이 강제(enforced)됐다** — 계정 보안 설정 변경 등 중요 작업 시 Marketing Admin 재인증 요구(**SSO 조직은 미적용**). 같은 날짜에 **플랫폼 기반 인증(Touch ID·Face ID·Windows Hello·passkey)** 과 **권장 IP 범위 기반 로그인 allowlist** 도 제공 시작 | `rn_mce_step_up_authentication` · `rn_mce_platform_authenticator_login` · `rn_mce_allowlist_recommended_ips_review` |
| **2026-09-30** | **2026-03-25 이후 교체하지 않은 MCE 설치 패키지 client secret이 만료**된다(이후 180일 주기) | `rn_mce_client_secrets_rotate` |
| **2026-09-30** | **Work Summaries for Case (Beta) 은퇴** — 그때까지 유지보수 모드, Enhanced Summaries로 전환 권고 | `rn_work_summaries_case_beta_retirement` |
| **2026-10-01** | **Meta가 Embedded Signup Flow v2·v3 지원 중단** | `rn_wa_embedded_signup_v4` |
| **2026-10-31** | **레거시 Snowflake data share target을 Snowflake V2로 마이그레이션해야 하는 기한**(레거시 target은 이미 신규 생성 불가) | `rn_cdp_2026_summer_snowflake_v2` |
| **2026-11-10** | **Trialforce branded email set의 발신 도메인 검증 기한.** 놓치면 기존 email set이 **`orgId@sf-customer-mail.com` 과 유사한 대체 주소**로 발송하며, 도메인을 검증할 때까지 그 주소를 계속 쓴다 | `rn_appexchange_trialforce_identify_domain_verification` |
| **Winter '26 (2025년 10월)** | **Windows Server Based Modeler 은퇴** — **MCP·MUP·FUP 패키지가 제공되지 않는다**. VS Code 기반 Modeler로 전환 | `rn_retail_windows_modeler_retirement` |

**B. `When: This feature is available starting October 2, 2026.` — 9건이 같은 날 열린다**

원문 문구가 **한 글자도 다르지 않게 동일한** 항목이 **9건**이며, 세 산업에 걸쳐 있다.

| 산업 | page id |
|---|---|
| **Energy & Utilities (3)** | `rn_energy_agentforce_quote_recipient_groups` · `rn_energy_agentforce_compare_tariffs_enroll` · `rn_energy_agentforce_cart_operations_flows` |
| **Health (5)** | `rn_health_agentforce_cc_voice_assistant_agent` · `rn_health_agentforce_health_engagement_ss_drug_coverage` · `rn_health_pcc_gen_ai_summaries` · `rn_health_pcc_provider_claim_summaries` · `rn_health_referral_management_agentforce_voice` |
| **Insurance (1)** | `rn_insurance_design_advisor` |

> **9건 전부가 Agentforce 계열**이다(음성 에이전트·서브에이전트·에이전트 액션·에이전틱 어드바이저). Winter '27 릴리즈 시점에는 쓸 수 없고 **2026-10-02부터** 열린다는 뜻이므로, 이 세 산업의 Agentforce 도입 계획은 이 날짜를 기준선으로 잡아야 한다.

**C. 되돌릴 수 없거나 제공되지 않는 것**

| 항목 | 제약 | page id |
|---|---|---|
| Data 360 리포트의 다중 통화 | **켜면 다시 끌 수 없다** — *"After multiple currencies are enabled, you can't turn off the setting."* | `rn_data360_reports_multicurrency` |
| Snowflake Zero-Copy V2 커넥터 | **Government Cloud에서 제공되지 않는다** | `rn_cdp_2026_summer_snowflake_v2` |
| Agentforce Voice (Taxpayer Advocate 에이전트의 전화 채널 확장) | **Government Cloud에서 제공되지 않는다** | `rn_264_ps_taxpayer_agentforce` |
| Sales Concierge Agent on Experience Cloud | **인증된 Customer Community Plus 사용자만 — 게스트 사용자 미지원** | `rn_auto_extend_automotive_sales_concierge_experience_cloud` |
| `IndividualApplication.ApplicationFormTemplateId` | **필드 제거 — 더 이상 제공되지 않는다** | `rn_psc_new_changed_objects` |
| Unified Employee 라이선스 사용자 | 제한된 커스텀 오브젝트가 포함된 **프로필·권한 세트·권한 세트 그룹을 배정할 수 없다**(소관: [[Winter '27/Development]]) | `rn_protect_custom_object_access_UEL_restrictions` |

**D. Setup 토글로 켤 수 없고 사람을 거쳐야 열리는 것**

원문이 *"available only on request"* / *"available by request"* / *"contact Salesforce Customer Support"* 라고 명시한 것만 적는다. **구매(유상 애드온) 문의와는 구분**한다.

| 유형 | 항목 | page id |
|---|---|---|
| **요청해야 열림 (account executive)** | Loyalty의 **`Activity With Mixed Subcurrencies` 만료 모델** — *"available only on request"* | `rn_loyalty_mixed_expiration_subtypes` |
| **요청해야 열림 (account executive)** | Unified Catalog의 **제출 후 요청 상세 수정** — *"available by request"* | `rn_modify_request_details_after_submission` |
| **요청해야 열림 (account executive)** | **Supply Chain Resiliency (Pilot)** — *"To enable Supply Chain Resiliency, contact your Salesforce account executive."* | `rn_supply_chain_resiliency_pilot` |
| **Customer Support 요청** | Joined Report의 **Common Rows Only (Beta)** — *"To turn on this feature, contact Salesforce Customer Support."* | `rn_rd_joined_reports_show_common_rows` |
| **Customer Support 요청 (최초 1회)** | Salesforce Edge Network의 **Global Selective Routing** — 나머지 라우팅 옵션은 셀프서비스지만 **Global Selective Routing만 최초 활성화에 Customer Support 요청이 필요**하고, 승인 후에는 My Domain Setup에서 전환 가능 *(소관: [[Winter '27/Platform]])* | `rn_control_edge_network_routing_with_self_serve` |
| **Customer Support 요청 (한도 상향)** | CRM Analytics **단일 대시보드 페이지 상한 20 → 최대 30** 요청 | *(1차 추출 317 계층 — `## Analytics` 절)* |
| ⚠️ **구매 문의 (게이트가 아님)** | MCE **Advanced Audit Trail** — **모든 MCE 에디션에서 추가 비용 애드온**으로 제공되며 구매하려면 account executive에 문의. 요청으로 "열어 주는" 기능이 아니라 **유상 애드온** 이다 | `rn_mce_data_extension_access_monitor` |

**E. "그냥 되는" 것처럼 읽히지만 관리자가 손으로 켜야 하는 것**

특히 **Industries CPQ / Enterprise Sales Management 계열**은 릴리즈 노트 본문이 기능만 설명하고 **How에서만 커스텀 설정 이름을 밝힌다.** 놓치면 기능이 조직에 나타나지 않는다.

| 설정·권한 | 어디서 | 어느 기능이 요구하나 | page id |
|---|---|---|---|
| **`CpqCartAgentInvocableAction` = `ON`** | App Launcher → **Vlocity CMT Administration** → Custom Settings → **CPQ Configuration Setup** 에 **파라미터를 직접 추가** | Energy & Utilities의 Agentforce 카트 오퍼레이션 | `rn_energy_agentforce_cart_operations_flows` |
| **`MultiEditStrictValidationMode`** | **CPQ Configuration Setup** 에서 켜기 | MultiEdit API의 검증·가격 오류 시 DB 갱신 중단 | `rn_cpq_ensure_data_integrity_with_multiedit_api_validation_and_pricing_checks` |
| **`enableApplyConfigToMatchingLines` = `true`** | Setup → Quick Find **CPQ Configuration Setup** | 번들 구성을 일치하는 quote line item 전체에 적용 | `rn_comms_apply_bundle_configuration` |
| **`ESMBulkPaginationEnabled` = `true`** | Setup → **CPQ Configuration Setup** | ESM의 번호 기반 페이지네이션 | `rn_comms_number_based_pagination` |
| **`ESMUILoaderEnabled` = `true`** | **CPQ Configuration Setup** | 비동기 대량 처리 중 차단형 UI 로더 | `rn_comms_ui_loader_asynchronous_processes` |
| **커스텀 권한 `ESMAddAssetInEnterpriseOrder`** | Setup → **Custom Permissions** → 사용자 권한 세트 또는 프로필에 활성화 | 자산 → 엔터프라이즈 주문 전환(MACD) | `rn_comms_convert_customer_assets_to_orders` |
| **`Enable_Optimized_PCS_Read` 시스템 설정** | 관리자에게 구성 **요청** | Trade Calendar의 PCS 13,000 assignment 지원 | `rn_tpm_trade_calendar_product_category_share_record_support` |
| **`Individual Application Milestone Enablement`** | Setup → **Energy & Utilities Settings** | New Connections Management 접근 자체 | `rn_energy_new_connections_enable_milestones` |
| **추천 알림 + Milestone 컴포넌트** | 관리자가 **Collection Plan 레코드 페이지에 Milestone 컴포넌트를 직접 추가·구성**하고 추천 알림을 구성 | ⚠️ **원문이 두 번 못을 박는다 — 둘 다 out of the box가 아니다** | `rn_auto_monitor_delinquency_record_views_alerts` |

---

### Platform·Development로 위임한 항목 — page id 포함 전수

Clouds 추출 배치에 섞여 들어왔지만 **이 노트 소관이 아닌** 페이지들이다(위 "섹션 통합" 참조). 여기서는 **한 줄 포인터와 page id만** 남기고 메커니즘을 다시 서술하지 않는다 — 각 항목의 Where·How·권한은 아래 소관 노트가 정본이다.

**A. 배치에서 나온 개별 page id (24건)**

| page id | 제목(원문) | 소관 |
|---|---|---|
| `rn_connect_in_apex` | ConnectApi (Connect in Apex): New and Changed Classes and Enums | [[Winter '27/Development]] |
| `rn_connect_in_apex_classes` | New Connect in Apex Classes | [[Winter '27/Development]] |
| `rn_connect_in_apex_output_classes` | Changed Connect in Apex Output Classes | [[Winter '27/Development]] |
| `rn_connect_in_apex_enums` | Changed Connect in Apex Enums | [[Winter '27/Development]] |
| `rn_ext_services_any_type_support` | Streamline Flow Integrations with External Services Support for Any... | [[Winter '27/Development]] |
| `rn_experience_cloud_request_approvals_component` | Add Multiple Flow Approval Processes to a Record with the Request... | [[Winter '27/Development]] *(Experience Cloud)* |
| `rn_experience_cloud_work_guide_component_update` | Open the Next Work Item from the Same Orchestration Run in... | [[Winter '27/Development]] *(Experience Cloud)* |
| `rn_experience_mobile_native_agentforce_panel` | Launch a Native Agentforce Panel in Mobile Publisher Apps | [[Winter '27/Development]] *(Experience Cloud·Mobile Publisher)* |
| `rn_access_user_profile_page` | Access the Chatter Profile Page to Designate Employee Users | [[Winter '27/Development]] *(Unified Employee License)* |
| `rn_protect_custom_object_access_UEL_restrictions` | Protect Custom Object Access with Unified Employee License... | [[Winter '27/Development]] *(라이선싱 — 아래 ⛔ 참조)* |
| `rn_defer_sharing_calculations_UEL_upgrades` | Defer Sharing Calculations for Bulk Unified Employee License Updates | [[Winter '27/Development]] *(라이선싱)* |
| `rn_slds_ai_skills` | Accelerate Lightning Development with SLDS AI Skills | [[Winter '27/Platform]] |
| `rn_slds_c_level_hooks` | Customize Components with the SLDS 2 Styling API and Component-Level... **(Developer Preview)** | [[Winter '27/Platform]] |
| `rn_lab_dyhi_follow` | Add the Follow Button to the Dynamic Highlights Panel | [[Winter '27/Platform]] *(Lightning App Builder)* |
| `rn_list_views_inline` | Make Inline Editing in List Views More Flexible | [[Winter '27/Platform]] |
| `rn_sharing_retain_manual` | Keep Manual Shares When Transferring Records | [[Winter '27/Platform]] |
| `rn_sharing_apex_recalc` | Update Apex Code and Flows for Changed Sharing Recalculation... **(Release Update)** | [[Winter '27/Release Updates]] — **강제 시점은 그 노트가 정본. 이 노트는 날짜를 쓰지 않는다** |
| `rn_globalization_review_label_translations` | Review Updated Label Translations | [[Winter '27/Platform]] |
| `rn_streaming_api_replay_tightening` | Streaming API Replay Tightening | [[Winter '27/Platform]] *(Enterprise Messaging)* |
| `rn_control_edge_network_routing_with_self_serve` | Control Your Salesforce Edge Network Routing with Self-Serve Setup | [[Winter '27/Platform]] *(My Domain — **Global Selective Routing 최초 활성화는 Salesforce Customer Support 요청 필요**)* |
| `rn_unblock_connected_app_install` | Unblock Connected App OAuth Installations in Pre-2018 Developer Orgs | [[Winter '27/Platform]] *(Connected Apps)* |
| `rn_update_and_customize_solutions_safely` | Update and Customize Solutions Safely | [[Winter '27/Platform]] *(Salesforce Go 솔루션 업데이트)* |
| `rn_field_history_tracking_ga` | Enable Field History Tracking for Users **(Generally Available)** | [[Winter '27/Platform]] — **아래 ⚠️ 원문 자기모순 참조** |
| `rn_previous_release_notes` | Previous Release Notes | [[Winter '27]] *(릴리즈 노트 아카이브 링크 목록 — 기능 항목이 아니다)* |

> ⛔ **소관 밖이지만 파급이 커서 존재만 기록한다:** `rn_protect_custom_object_access_UEL_restrictions` 는 **Unified Employee 라이선스 사용자에게 제한된 커스텀 오브젝트가 포함된 프로필·권한 세트·권한 세트 그룹을 배정할 수 없게 되는 파괴적 변경**이다. 조건·예외·해결 방법은 [[Winter '27/Development]] 참조.
>
> ⚠️ **원문 자기모순 1건 — `rn_field_history_tracking_ga`:** 제목은 ***(Generally Available)*** 인데 본문의 Setup 절차는 **`Enable User Field History Tracking (Beta)`** 라는 **Beta 이름의 토글**을 켜라고 한다. 어느 쪽이 맞는지 원문만으로는 판정할 수 없으므로 **양쪽을 그대로 기록**한다. 기능 상세는 [[Winter '27/Platform]] 소관.

**B. 영역 단위 위임 (배치 전반)**

| 배치에서 나온 항목 | 소관 |
|---|---|
| Lightning Components(LWC API v68.0 · 복합 템플릿 표현식 GA · `lwc:external` GA · `lightning/platformNavigationItemApi` · state manager `refresh()` · LWC Skills) | [[Winter '27/Development]] |
| Connect REST API(Winter '27부터 릴리즈 노트가 Connect REST API Developer Guide로 이동) · ConnectApi 신규/변경 클래스·enum | [[Winter '27/Development]] |
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

> *"Revenue Cloud is now Agentforce Revenue Management."* Winter '27 Revenue의 단일 최대 테마는 **대형 트랜잭션 — 라인 아이템 15,000건**이다. 그 밖에 **Promotions 신규 도입**, Billing의 주간 청구·catch-up bill run·Billing Forecast·Collections Specialist Console, Advanced Approvals의 위임·기밀 검토, Dynamic Revenue Orchestrator의 time-aware 자산이 있다.

### 이 절을 읽는 법 — Where 공통 문구

Revenue 리프 페이지의 Where 문장은 거의 전부 동일한 형태다.

> 원문 공통형: *"This change applies to Lightning Experience in **Enterprise, Unlimited, and Developer** editions of Revenue Management, formerly Revenue Cloud, with the **\<라이선스\>** license."*

따라서 아래 표에서는 **라이선스만** 적는다(에디션 = **Enterprise·Unlimited·Developer**, **Lightning Experience 전용**). 약칭: **Growth** = Revenue Cloud Growth · **Advanced** = Revenue Cloud Advanced · **Billing** = Revenue Cloud Billing. **Where 문장이 이 공통형과 다른 항목은 행에서 직접 밝힌다**(Advanced Approvals·Approval Agent 계열).

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

### Salesforce Go — Revenue 기능 발견·설정 (`rn_rev_salesforce_go`)

Setup 한 곳에서 Revenue Management 기능을 발견·설정한다. **How:** 톱니 메뉴 또는 Setup 메인 메뉴에서 **Salesforce Go** → **Revenue Cloud** 선택.

| 항목 | 내용 |
|---|---|
| **Orchestrate High Tech Order Scenarios by Using a Prebuilt Template**<br>`rn_dro_hightech_orch_with_salesforce_go` | Dynamic Revenue Orchestrator를 **사전 구성된 오케스트레이션 플랜**으로 확장 — 하이테크 주문 시나리오용. **How:** Salesforce Go → Revenue Cloud → content type 드롭다운을 **Data Packs**로 필터 → **High Tech Order Orchestration Template**. 라이선스: **Advanced 또는 Billing** |
| **Configure Billing Features Faster**<br>`rn_billing_features_with_salesforce_go` | Salesforce Go로 **Invoice Management · Tax Calculation · Invoice Document Delivery · Accounting Sub-Ledger for Accounts Receivables** 를 가이드 설정(단계·영상·도움말)으로 구성. **How:** content type을 **Feature**로 필터해 개별 설정하거나, **Feature Set → Manage Billing**으로 네 기능을 한 번에. 라이선스: **Advanced 또는 Billing** — 단 **Invoice Document Delivery는 Billing 라이선스에서만** 제공되고, **Advanced 라이선스는 Accounting Sub-Ledger for Accounts Receivables의 일부 기능만** 포함한다 |

### Promotions in Revenue Management — 신규 도입 (`rn_revenue_increase_sales_with_promotions`)

수동·자동 프로모션을 만들어 **개별 제품 또는 카테고리 전체**를 할인한다. 규칙과 판매 채널로 **적격성(eligibility)** 을 정의하고, 한 트랜잭션에 여러 프로모션이 걸릴 때의 **스태킹 평가 방식**을 지정한다. 라이선스: **Advanced**.

원문이 밝힌 사용자 관점 효과 전수:

- 제품·카탈로그를 탐색하는 중에 **적용 가능한 프로모션이 보인다** — 견적 전에 할인 기회를 포착.
- 트랜잭션에 제품을 추가하는 즉시 **자동 프로모션이 라인에 적용**돼 적격 할인을 놓치지 않는다.
- 제품 구성·라인 관리 중에 **수동 프로모션**을 적용할 수 있다.
- **price waterfall에서 적용된 할인을 추적**하고 **자산(asset)에서 적용된 프로모션을 조회**할 수 있다 — 모든 할인에 출처가 남는다.
- 자산을 **수정(amend)·갱신(renew)** 할 때도 프로모션을 적용해 할인이 자산 라이프사이클 전체로 이어진다.

**New and Changed Objects for Promotions** (`rn_revenue_promotions_new_changed_objects`) — 원문 전수

| 오브젝트 | 변경 |
|---|---|
| **`AssetActionSrcPriceAdjustment`** (신규) | 자산 ↔ 자산에 적용된 프로모션의 **junction** |
| `OrderItemAdjustmentLineItem` (기존) | 신규 **`AppliedPromotionDate`** — 주문 항목에 프로모션이 적용된 일시 / 신규 **`CouponCode`** — 주문 항목에 수동 프로모션을 적용할 쿠폰 코드 |
| `QuoteLinePriceAdjustment` (기존) | 신규 **`AppliedPromotionDate`** — 견적 라인에 프로모션이 적용된 일시 / 신규 **`CouponCode`** — 견적 라인에 수동 프로모션을 적용할 쿠폰 코드 |

### Large Transactions and Quote Processing — 숫자 전수

> 원문: *"Process quotes and orders with up to **15,000 line items** without timeouts or performance bottlenecks."*

| 항목 | 숫자·조건 | 라이선스 |
|---|---|---|
| **Sync Large Quotes to Opportunities Without Interruption**<br>`rn_large_txn_sync_large_quotes_to_opportunities` | **15,000 라인**까지 **비동기** 동기화(백그라운드 처리). **How:** Setup → **Revenue Settings** → **Asynchronous Opportunity Sync** 켜기. 표준·대형 견적 양쪽에 적용 | Growth 또는 Advanced |
| **Recover Faster from Quote and Order Calculation Errors**<br>`rn_large_txn_recover_faster_from_quote_and_order_calculation_errors` | 개선된 배칭 알고리즘 + **중첩 라인 아이템** 지원. **REST API로 멈춘 계산 상태를 수동으로 Failed로 변경**해 재시도. **Who: Large Transaction 권한 필요.** **How:** Setup → Revenue Settings → **Large Transaction Processing** 켜기 | Growth 또는 Advanced |
| **Speed Up Large Quote Operations with Automatic Context Reuse**<br>`rn_large_txn_speed_up_large_quote_operations_with_automatic_context_reuse` | 트랜잭션당 **단일 세션 컨텍스트** 재사용 → 반복 컨텍스트 생성 제거. **대형 트랜잭션에 자동 적용 — 설정 불필요** | Growth 또는 Advanced |
| **Generate Documents for Quotes with 15,000 Line Items**<br>`rn_large_txn_generate_documents_for_quotes_with_15_000` | CLM Document Generation이 **15,000 라인 아이템 · 1,000 번들 · 중첩 그룹핑 5단계** 까지 지원. **How:** 견적 문서 템플릿 설정 + Quote 페이지 레이아웃에 **Document Generation 퀵액션** 추가 → 생성된 문서는 견적 레코드의 **Quote PDFs 관련 목록**에 자동 추가 | Growth 또는 Advanced |
| **Transform Context Data in Large Transactions**<br>`rn_large_txn_transform_context_data_in_large_transactions` | 대형 트랜잭션의 컨텍스트 데이터에 **DPE transform** 적용 — 문서 병합 전에 대용량 데이터를 정형·현지화. 이전엔 Context Service의 DPE 기반 transform이 **표준 트랜잭션에서만** 가능했다. **How:** 컨텍스트 정의의 **Transform 탭**에서 DPE 변환 정의 생성 → Salesforce Document Generation에서 표준·대형 양쪽에 사용 | **Advanced 또는 Billing** |
| **Apply Configuration Rules Across 15,000 Line Items**<br>`rn_large_txn_apply_configuration_rules` | 규칙·제약을 **15,000 라인**의 모든 제품·번들에 적용 | Growth 또는 Advanced |
| **Price Quotes and Orders with Up to 15,000 Lines**<br>`rn_large_txn_price_quotes_and_orders` | 가격 계산 상한이 **기존 1,000 라인 → 15,000 라인**. 대형/표준 트랜잭션에 서로 다른 가격 기능이 필요하면 **pricing procedure를 분리 구성** | Growth 또는 Advanced |

### Product Catalog Management (`rn_product_catalog_management` 허브 + 리프 전수)

라이선스: 아래 표의 모든 항목이 **Growth · Advanced · Billing 중 하나**(세 라이선스 전부에서 사용 가능)다 — Product Configurator 절과 다른 점.

| 항목 | 내용 |
|---|---|
| **Simplify Product Configuration with Custom Attribute and Category Ordering**<br>`rn_product_catalog_display_order_attributes` | 속성 카테고리·속성의 **표시 순서**를 **Product Classification · Product Subclassification · Product** 어느 레벨에서든 지정. 제품은 분류(classification)의 순서를 **상속**하고 담당자는 Configurator UI에서 그 순서를 본다. 이전엔 카테고리 순서를 통제할 수 없었고 속성은 **이름 알파벳순**으로 나왔다 |
| **Reuse Existing Simple Products as Bundles**<br>`rn_product_catalog_reuse_existing_simple_products_as_bundles` | 제품 레코드의 **product type을 bundle로 바꾸기만** 하면 단순 제품이 번들이 된다. 이전엔 **별도 제품 레코드를 새로 만들어야** 했다 |
| **Guide Sales Reps Through Product Setup with Dynamic UI Controls**<br>`rn_product_catalog_guide_sales_reps_through_product_setups_with_dynamic_ui_controls` | 범용 **톱니 아이콘을 커스텀 텍스트 버튼으로 교체**. **static / configurable 제품 각각(또는 둘 다)에 대해 Add 버튼을 숨겨** 잘못된 추가를 막는다. 제품 추가·삭제 진행 상태도 추적. **How:** Setup의 **Discover Products 플로우**를 열어 컴포넌트 속성 편집 |
| **Discover Products Faster by Using Price Book Filters**<br>`rn_product_catalog_discover_products_faster_using_price_book_filters` | **선택한 price book에 연결된 제품만** 조기 필터링해 조회. 가격표 겹침이 적은 대형 카탈로그에서 제품이 아예 안 보이거나 몇 개만 보이던 문제 해소. **How:** Setup → **Product Discovery Settings** → **price book filtering** 켜기 |
| **Find Products with Prefix Matching and Partial Search**<br>`rn_product_catalog_find_products_with_prefix_matching_and_partial_search` | Index and Search가 **Product Name · Product Code · Product SKU**(searchable로 표시된 경우)에 **접두 매칭** 지원. **부분 검색**은 **Product Code·Product SKU**의 앞·중간·끝 어느 부분을 입력해도 찾아준다(정확한 포맷·구분자 불필요). **How:** 접두 검색은 위 필드가 searchable이면 **기본 활성**. 부분 검색은 Product Catalog Management 홈 → **Index and Search Configuration** → **Index Settings** → Search 섹션에서 켠다 |
| **See Instant Updates in Product Discovery While Building Quotes**<br>`rn_product_catalog_see_instant_updates_in_product_discovery_while_building_quotes` | **Transaction Preview · Configuration Rules · Product Recommendations · Auto Save 설정이 켜져 있을 때** Product Discovery가 **optimistic UI** 패턴으로 즉시 반응. 추가된 제품에 **배지**가 붙어 중복 선택을 막고, 견적 합계·트랜잭션 미리보기는 **페이지를 막지 않고 백그라운드에서 갱신**된다 |
| **Get Accurate Product Details with Automated Product Cache Management**<br>`rn_product_catalog_get_accurate_product_details_with_automated_product_cache_management` | 제품 상세가 바뀌면 **캐시를 자동 무효화**. PCM Cache가 영향받는 제품을 **재귀적으로** 식별해 캐시를 비운다 → 수동 캐시 갱신·관리자 개입 불필요 |
| **Get Faster Product Pricing with List Price Caching**<br>`rn_product_catalog_get_faster_product_pricing_with_list_price_caching` | price book entry의 **정가(list price)를 제품 상세와 함께 캐시에 저장**. pricing procedure로 해석하지 않고 **캐시에서 직접** 읽는다. **How:** Setup → **Product Discovery Settings** → **list price from cache** 켜기 |
| **Changed Connect REST APIs in Product Catalog Management**<br>`rn_product_catalog_changed_connect_rest_api_response_body` | 단일·벌크 **Product Detail API**의 응답 바디 **Attribute Category · Product Attribute Category** 에 신규 프로퍼티 **`sequence`**(속성 카테고리의 표시 순서) 추가 |

### Product Configurator

라이선스: 아래 항목은 **Growth 또는 Advanced**(Billing 라이선스는 해당 없음).

| 항목 | 내용 |
|---|---|
| **Prevent Constraint Conflicts When Sharing Attributes and Relations**<br>`rn_product_configurator_guardrails_annotation` | 제약(constraint) 수준에서 **`guardrails` 애노테이션**으로 보호 대상(속성·관계)을 정의. 개별 속성·관계마다 걸지 않으므로 같은 요소를 공유하는 다른 제약과 충돌하지 않는다. **How:** 제약에 guardrails 애노테이션을 붙이고 보호할 속성·관계를 나열 |
| **Enforce Per-Bundle Product Requirements Regardless of Order Size**<br>`rn_product_configurator_instance_quantity` | **Revenue Settings에서 Instance Quantity를 켜면** 제약 엔진이 **번들 인스턴스당 수량**으로 검증한다. 이전엔 여러 번들 주문 시 **전 번들 합산 최종 수량(total end quantity)** 으로 검증해 per-bundle 규칙이 실패했다 |
| **Let Constraint Rules Assign Child Product Quantities in Bundles**<br>`rn_product_configurator_allowQuantityChange` | **Constraint Instance Quantity** 설정이 자식 제품 인스턴스 수량을 자동 계산하도록 지시한다. **How:** CML 제약 모델의 관계 선언에 **`@(allowQuantityChange = true)`** 를 붙이고, 부모 타입에 자식 인스턴스 수량을 지정하는 제약 규칙을 작성. **전제:** Revenue Settings에서 **Constraint Instance Quantity**를 켜고, 그 관계의 자식 제품에 대해 **`split` 애노테이션을 false로** 설정해야 한다 |
| **Updates in Default Product Configurator Flow**<br>`rn_product_configurator_flow_updates` | 기본 플로우에 신규 속성 추가. **Winter '27 이전에 Default Product Configurator 플로우를 복제했다면 신규 속성을 수동 매핑**하거나 기본 플로우를 다시 복제해 커스터마이즈를 재적용해야 한다. 신규 속성 전수:<br>· **Context Definition**(Input·Output) — Configuration API가 조회 가능한 컨텍스트 속성을 결정하는 컨텍스트 정의 — *Product Configurator Data Manager* 컴포넌트<br>· **Context Node**(Input·Output) — 선택한 컨텍스트 정의 안에서 조회 가능한 속성을 담은 컨텍스트 노드 — 동일 컴포넌트<br>· **Context Attributes**(Input·Output) — 선택한 컨텍스트 노드에서 조회 가능한 컨텍스트 속성 — 동일 컴포넌트<br>· **Origin**(Input) — 트랜잭션 레코드 부모 오브젝트의 API 이름 — *Product Configurator Option Groups* 컴포넌트<br>· **Instant Pricing**(Input, boolean) — 즉시 가격 표시 여부 — *Product Configurator Data Manager* 플로우<br>· **Read-Only Product Name**(Input, boolean) — 옵션 카드의 제품명 필드를 읽기 전용으로 — *Product Configurator Option Groups* 컴포넌트 |
| **Changed Object in Product Configurator**<br>`rn_product_configurator_changed_object` | `ProductConfigurationFlow` 오브젝트에 신규 **`IsRequestDetailEditable`** 필드 — 생성 이후 연결된 **case·incident·service request**에서 속성·제품을 편집할 수 있는지 표시 |
| **Changed Connect REST API in Product Configurator**<br>`rn_product_configurator_changed_connect_rest_api_request_body` | **Configuration Input** 요청 바디에 신규 **`contextFieldsList`** — configurator 응답에 반환할 필드 목록 지정. Configuration API가 **화면에 필요한 필드만** 반환하도록 축소 가능 |
| **Optimize Performance for Revenue Management (Release Update)** | Configuration API 처리 속도 최적화. **샌드박스에서 test run**으로 기존 설정과의 호환 확인 권장. **Winter '27부터 이용 가능 — 강제 시점 → [[Winter '27/Release Updates]]** |

### Salesforce Pricing

| 항목 | 내용 | 라이선스 |
|---|---|---|
| **Reduce Pricing Errors and Improve Deal Transparency on Ramp Deals**<br>`rn_pricing_reduce_pricing_errors_and_improve_deal_transparency_on_ramp_deals` | 각 세그먼트의 상승률을 **원 정가가 아니라 직전 세그먼트의 상승률 위에** 계산. 원문 예시: **정가 $100 · 연 10% 상승 3년 딜**은 종전엔 매년 **$10씩** 올랐다(정가 기준 고정). **How:** App Launcher → **Pricing Procedures** → 해당 절차의 **Price Revision** 가격 요소에서 **compounding 계산 방식** 선택. 제품·지역·기간별로 상승률을 통제하려면 신규 **`UpliftCalculationMethod` 컨텍스트 태그**와 decision table 규칙을 함께 사용 | Growth 또는 Advanced |
| **Tailor Pricing Rules for Multiple Industry Clouds**<br>`rn_pricing_tailor_pricing_rules_for_multiple_industry_clouds` | **Subtype 필드**로 pricing recipe·pricing procedure를 산업 클라우드별로 분리. 각 클라우드가 **자체 기본 recipe·decision table**을 갖는다(종전엔 하나의 recipe를 공유해 무관한 가격 규칙까지 조율해야 했다). 절차의 element lookup에는 **해당 subtype 기본 recipe의 decision table만** 노출. **How:** App Launcher → Pricing Procedures 또는 Pricing Recipes → 생성 시 **Pricing Usage Sub Type** 드롭다운에서 subtype 선택 | Growth 또는 Advanced |
| **Keep Calculated Values in Context with Local List Variables**<br>`rn_pricing_keep_calculated_values_in_context_with_local_list_variables` | **pricing procedure 안에서 직접** local list variable을 정의해 계산값을 요소 간에 저장·재사용. 이전엔 Pricing Procedure Builder에서 **컨텍스트 태그나 상수를 미리** 만들어야 했다. 이제 절차를 만들면서 생성·편집·매핑하고 **Price Waterfall에서 참조**한다. **How:** App Launcher → Pricing Procedures → 절차 편집에서 list variable 추가 후 컨텍스트 태그·상수와 동일하게 매핑 | Growth 또는 Advanced |
| **Avoid Integration Parsing Errors from Pricing API Decimal Values**<br>`rn_pricing_avoid_integration_parsing_errors_from_pricing_api_decimal_values` | **Pricing Connect API가 숫자를 지수 표기가 아닌 표준 십진 표기로 반환**한다. 원문 예: **`1E+7`이 아니라 `10000000`** | Growth 또는 Advanced |

### Transaction Management

라이선스: 아래 항목 전부 **Growth 또는 Advanced**.

| 항목 | 내용 |
|---|---|
| **Limit a Procedure Plan to a Specific Industry**<br>`rn_transaction_management_prevent_cross_industry_pricing_errors_with_subtype` | 신규 **Subtype 필드**로 procedure plan의 적용 산업/버티컬을 지정 → 해당 subtype에 맞는 pricing procedure만 표시된다. Life Sciences·Commerce procedure plan 구성 시 **그 산업용 절차만** 추가 가능. **주의:** Subtype 필드는 **process type이 Default인 Revenue Cloud에만** 적용된다 |
| **Gain Transaction Flexibility with Backdated Asset Changes**<br>`rn_transaction_management_backdate_asset_transactions` | 표준·램프 자산의 **amendment·cancellation·renewal**에 과거 발효일 적용 가능. **transfer·swap은 표준 자산만.** 계약 조건·billing schedule·인보이스가 의도한 발효일과 정렬 유지 |
| **Maintain Time Zone Accuracy for Asset Lifecycle Changes**<br>`rn_transaction_managment_preserve_original_time_zones_for_asset_lifecycle_changes` | **Time Zone이 자산에 저장**되어 amendment·renewal·cancellation 트랜잭션에 전파. 시작·종료일이 자산 원래 로컬 타임존 기준으로 유지돼 수동 시간대 변환이 불필요 |
| **Gain Pricing Flexibility with Price Amendments**<br>`rn_transaction_management_update_quote_and_order_prices_with_price_amendments` | 수량·속성·번들 구성을 건드리지 않고 **견적 라인의 sales price / 주문 라인의 unit price** 만 갱신. **How:** 자산을 amend → 발효일 지정 → 견적 라인의 새 sales price(또는 주문 라인의 새 unit price) 입력 후 저장. 갱신된 가격은 표준 주문·청구 프로세스 전체에 반영 |
| **Accelerate Transaction Updates with Advanced Filters**<br>`rn_transaction_management_filter_transactions_by_product_name_in_the_sales_transaction_line_editor` | 제품명·커스텀 필드·**관련 레코드의 필드**로 견적·주문 라인 필터링. **How:** STLE의 필터 아이콘 → **Advanced Filters** → 라인 아이템/관련 레코드 필드로 조건 추가, **AND·OR 로직** 사용 |
| **Edit Accurate Quotes and Orders in STLE with Autorefresh**<br>`rn_transaction_management_stle_enhance_autorefresh` | 커스텀 플로우·Apex 트리거·Agentforce 액션이 견적/주문을 바꾸면 **STLE와 Transaction Summary가 자동 갱신**. Refresh 탭의 STLE 재로딩 신뢰성 개선. **저장하지 않은 편집이 있을 때 refresh가 발생하면 STLE가 save·discard·cancel을 먼저 묻고**, 편집 중이거나 저장 대기 중이면 들어온 업데이트를 **보류**한다(작업 덮어쓰기 없음). **How(필수 설정):** Setup → **Change Data Capture** → Available Entities에서 **Quote·Order** 를 Selected Entities로 이동 후 저장. **조직당 1회 설정이며 신규 권한·권한 세트는 추가되지 않고 기존 Apex·플로우 변경도 불필요** |
| **Organize STLE Actions into Button Groups**<br>`rn_transaction_management_stle_enhance_button_groups` | 텍스트 박스 대신 **시각적 관리자 UI**. 액션을 버튼 그룹으로 묶고 그룹별 노출 개수 지정, 그룹은 필요한 만큼 추가. **그룹 10개가 노출되고 나머지는 오버플로 메뉴.** 기존 텍스트 박스 설정은 자동 이관된다. 담당자 접근 수준이나 견적/주문 상태 때문에 어떤 액션을 못 쓰면 **헤더가 자동 조정돼 그 그룹의 다음 액션이 올라온다**. **How:** Setup → Object Manager → Quote 또는 Order → Lightning Record Pages → 레코드 페이지 Edit → App Builder에서 **STLE 컴포넌트의 action button groups** 섹션 수정 |
| **Build Focused Quote Line Item and Order Product Pages with Dynamic Forms**<br>`rn_transaction_management_dynamic_forms_for_quote_line_items_and_order_products` | quote line item·order product 레코드 페이지를 **Dynamic Forms**로 업그레이드 — 필드·필드 섹션을 자유 배치하고 **가시성 규칙** 적용. 이전엔 이 두 오브젝트가 **페이지 레이아웃만** 지원했다 |
| **Changed Connect REST API in Transaction Management**<br>`rn_transaction_management_changed_connect_rest_apis` | 강화된 **Read Sales Transaction API** — 기존 `/connect/revenue/transaction-management/sales-transactions/actions/read` 리소스에 신규 요청 파라미터 **`shouldReturnMetadataOnly`**·**`batchIndices`**. 사용 가능한 배치를 먼저 조회한 뒤 필요한 배치만 **병렬** 조회 |
| **New Invocable Action in Transaction Management**<br>`rn_transaction_management_new_invocable_action_in_transaction_management` | 신규 **`syncQuoteOpportunity`** 액션 — quote line item → opportunity line item 동기화. **단방향이며 역방향은 아니다.** **전제:** Revenue Settings에서 **Asynchronous Opportunity Sync**를 켜야 플로우·자동화에서 쓸 수 있다 |

### Ramp Deals

| 항목 | 내용 |
|---|---|
| **Backdate Amendments, Renewals, and Cancellations for Ramp Deals to Adjust Billing**<br>`rn_transaction_management_backdated_arc_for_ramps` | 램프 자산의 수정·갱신·취소에 **과거 발효일** 지정. 이전엔 **오늘 이후만** 가능해 과거 기간 청구를 Salesforce에서 정정할 수 없었다. **How:** Revenue Cloud의 램프 자산 레코드에서 amendment·renewal·cancellation 견적을 만들고, 발효일(또는 갱신 시작일)을 **자산 라이프사이클 시작일 이후의 과거 일자**로 설정. 라이선스: Growth 또는 Advanced |
| **Apply Compound Price Uplifts to Multiyear Ramp Deals**<br>`rn_transaction_management_ramp_deal_compound_uplift` | **standard uplift** = 매 세그먼트에 **원 정가(list price)** 기준 고정 비율 적용. **compound uplift** = 각 세그먼트 가격을 **직전 세그먼트의 net price** 위에 쌓아 기업 계약의 연간 escalation 패턴에 맞춘다. **price waterfall이 세그먼트별 적용 단가 상승률을 표시**한다. **How:** Setup → **Revenue Settings** → **Advanced Detail Line Pricing** 켜기 → 기본 ramp uplift type을 standard 또는 compound로 설정. 라이선스: Growth 또는 Advanced |
| **Automate Compound Price Uplifts for Multiyear Ramp Deals**(Billing 관점)<br>`rn_billing_price_uplifts_for_multiyear_ramp_dealsxml` | 동일 복리 로직이 **수정·갱신에도 그대로 이어지고**, **주문을 활성화하면 billing schedule이 복리 가격을 자동 반영**한다(별도 청구 설정 불필요). **How:** Setup → **Revenue Settings** → **Advanced Transaction Detail Line Pricing** 켜기 → **Ramp Uplift Type = Compound Uplift**. 기본값 **Standard Uplift는 바꾸기 전까지 유지**되고, **ramp schedule·segment 수준 편집 권한을 주지 않는 한 영업 담당은 이 설정을 재정의할 수 없다.** 라이선스: **Advanced** |

### Usage Management (`rn_um_usage_management` 허브 + 리프 전수)

라이선스: 아래 전부 **Advanced**.

| 항목 | 내용 |
|---|---|
| **Adapt Subscriptions When Customer Needs Change**<br>`rn_um_renew_active_usage_assets_early` | 활성 usage 자산을 **만료 전에 갱신**(취소 후 재주문 대신). 요율·부여 수량을 조정하면서 **asset continuity 유지**. **How:** 활성 usage 자산에서 갱신 견적 생성 → **Override Renewal Term** 선택 → **현재 자산 종료일 이전** 시작일 선택. **⚠️ 제약:** *"Early renewal isn't available in orgs that have both the Revenue Cloud Advanced and Revenue Cloud Billing licenses with the Usage Management add-on."* |
| **Respond to Growth with Early Ramp Renewal**<br>`rn_um_renew_ramped_usage_assets_early` | 램프 가격 고객의 조기 갱신 시 **현재 스케줄의 어느 시점(1년차·2년차 이후)에서든** 새 기간 시작. 갱신이 **원래 종료일 너머로 커버리지를 자동 연장**하고 이후 세그먼트를 **갱신된 일자와 최신 카탈로그 요율로 재생성**한다. **How:** 활성 램프 usage 자산 → 갱신 견적 → Override Renewal Term → **현재 자산 라이프사이클 중의** 시작일 선택 |
| **Win Back Customers by Restoring Lapsed Subscriptions**<br>`rn_um_renew_expired_usage_assets` | **만료된** usage 구독을 갱신 요율·부여 수량으로 복원하고 **자산 이력은 보고 연속성을 위해 보존**. **How:** 만료된 usage 자산 → 갱신 견적 → Override Renewal Term → **자산 만료일 이후(또는 당일)** 시작일 선택. **⚠️ 제약:** *"Late renewal isn't available in orgs that have both the Revenue Cloud Advanced and Revenue Cloud Billing licenses with the Usage Management add-on."* |
| **Prevent Usage Summary Failures by Updating Overridden Flows**<br>`rn_um_update_overridden_flows_with_dpe_v4` | 재정의(override)한 Usage Management 플로우를 **DPE 정의 버전 4**로 갱신해야 usage summary 실패를 막는다. **버전 3 DPE 정의는 더 이상 지원되지 않으며 열기·편집·실행이 불가능하다** |
| **New and Changed Objects in Usage Management**<br>`rn_um_new_and_changes_objects` | **제거(REMOVED) 전수** — ① `TransactionUsageEntitlement`의 **`UsageAggregationPolicy`·`ChargeForOverage`·`RatingFrequencyPolicy`·`DrawdownOrder`** 필드는 **API v65.0에서 deprecated**, 향후 버전에서 제거 → **`BindingObjectUsageResourcePolicy`** 오브젝트 사용 ② `UsageResource`의 **`UsageResourceBillingPolicy`** 필드는 v65.0 deprecated → **API v67.0 이상에서 제거됨** → `ProductUsageResourcePolicy` 또는 `UsageResourcePolicy` 사용 ③ `RatingFrequencyPolicy`의 **`UsageResource`·`Product`** 필드도 v65.0 deprecated → **v67.0 이상에서 제거됨** → 동일 대체 ④ `ProductUsageGrant`의 **`OverageChargeable`** 필드는 v65.0 deprecated → **v67.0 이상에서 제거됨** → **`UsageOveragePolicy`** 사용 |

### Dynamic Revenue Orchestrator (`rn_dynamic_revenue_orchestrator` 허브 + 리프 전수)

라이선스: 아래 전부 **Advanced**.

| 항목 | 내용 |
|---|---|
| **Orchestrate Backdated and Future-Dated Contract Changes Automatically**<br>`rn_dro_backdated_future_dated_amendments` | 과거·미래 발효일의 amendment·renewal·cancellation을 이행하고, **미래 일자 변경은 발효 전에 롤백**할 수 있다. 분해(decomposition) 시 DRO가 각 fulfillment 자산의 **미래 상태**를 평가해 액션·수량·일자가 올바른 기간을 반영하게 한다. **time-aware fulfillment asset**이 기간별 수량·속성을 담아 **제출일이 아니라 발효일 기준** 프로비저닝을 보장. **How:** 주문에 발효일을 지정하고, 미래 변경을 되돌리려면 **rollback order**를 제출 |
| **Streamline Fulfillment of Ramped Asset Amendments**<br>`rn_dro_fulfill_ramped_asset_amendments` | 램프 세그먼트를 추가하거나 미래 세그먼트를 취소하면 DRO가 **fulfillment order line item과 관련 자산을 갱신**한다 — **조직의 time-aware fulfillment 설정과 무관하게** |
| **Eliminate Fulfillment Delays by Using Staged Assetization for Ramped Products**<br>`rn_dro_staged_assetization_ramped_products` | 플랜 완료를 기다리지 않고 **플랜 실행 중에** 램프 제품을 자산화. **Staged Assetize 스텝은 order line item·fulfillment order line item 두 소스를 모두 지원**한다. **How:** Fulfillment Step Definition Group에 **Staged Assetize** 스텝을 추가하고 자산화할 제품 선택 → 주문 제출 시 DRO가 제품의 **램프 세그먼트를 소스 라인으로** 자산과 asset state period를 생성 |
| **Automate Multiyear Ramp Deal Orchestration with Sequenced Steps**<br>`rn_dro_optimize_multiyear_orchestration` | fulfillment 스텝을 램프 딜 전반에 **시간순으로 배열** — **1년차 스텝이 2년차보다 먼저 실행**된다. 시간 세그먼트를 가로지르는 의존성을 해소해 플랜 정체를 막고 다년 구독 프로비저닝을 가능하게 한다. **표준 스코프와 커스텀 스코프(램프·그룹 식별자) 모두에 적용.** 실행 시점을 더 세밀히 통제하려면 **future-dated step**을 구성 |
| **Align Fulfillment Dependencies by Using Custom Scopes**<br>`rn_dro_custom_fulfillment_scopes` | 그룹·램프 세그먼트 같은 **커스텀 스코프**로 fulfillment 스텝 의존성을 묶고 순서화. **How:** **Custom Fulfillment Scope Config** 를 만들어 **item context tag** + (선택) **asset context tag** + **fallback scope** 를 지정 → fulfillment step dependency의 scope를 **Custom**으로 두고 해당 스코프 선택 → 주문 제출 시 DRO가 그 설정대로 플랜 의존성을 구성 |
| **Clone and Reuse Fulfillment Workspaces**<br>`rn_dro_clone_fulfillment_workspaces` | fulfillment workspace를 한 번에 복제 — **step definition group·step definition·dependency가 새 workspace 레코드로 복사**된다. **How:** Setup → **Dynamic Revenue Orchestrator Settings** → **Deep Clone Settings** → 사전 구성된 컨텍스트 정의 선택 → 복제할 workspace 레코드 선택 → 액션 메뉴에서 **Deep Clone** |
| **Navigate Orders Easily with the Enhanced Decomposition Viewer**<br>`rn_dro_enhanced_decomposition_viewer` | Decomposition Viewer에서 라인 아이템이 **하위 액션(subaction)** 을 나열하고, 분해 상세가 **코드 대신 속성 이름**을 보여준다. time-awareness를 켜면 제품별 **시간 세그먼트가 시간순으로 정렬**되면서 번들 계층은 유지된다 |
| **Changed Objects in Dynamic Revenue Orchestrator**<br>`rn_dro_new_and_changed_objects` | ① `FulfillmentStepDependencyDef`에 신규 **`CustomScope`** — 의존성 스코프가 custom일 때의 커스텀 스코프 이름 ② `FulfillmentStepDefinition`에 신규 **`Description`** — 오케스트레이션 플랜에서 관리자에게 보이는 스텝 정의 설명 ③ `FulfillmentStep`에 신규 **`ScopeIdentifier`** — 스텝이 생성된 스코프 |

### Advanced Approvals

> **Where가 Revenue 공통형과 다르다.** 이 절의 항목은 *"Lightning Experience in Enterprise, Unlimited, and Developer editions **where Advanced Approvals is enabled**"* 형태다(Revenue Cloud 라이선스 문구가 아니다).

| 항목 | 내용 |
|---|---|
| **Extend Slack Approval Notifications to Group and Queue Members**<br>`rn_adv_approvals_slack_notifications` | 배정된 그룹·큐의 **모든 활성 멤버**가 승인 요청 DM을 받는다. 승인 설계자는 **Slack 채널 게시**도 구성 가능. **Dynamic Approval Notifications를 켜면 DM에 AI 생성 요약이 포함된다.** 이전엔 그룹·큐 배정 승인 단계가 Slack 알림을 아예 생성하지 않았다. **How:** Flow Builder에서 승인 워크플로를 열고 승인 스텝 속성 패널에서 **Send approval request to Slack channel** 선택 후 **Slack 채널 ID** 지정 |
| **Keep Approval Workflows Moving with Advanced Approval Delegation**<br>`rn_adv_approvals_approval_delegation` | 검토자가 **approval delegation 레코드**를 만들어 사용자·그룹·큐에 **기간 한정 또는 무기한** 위임. **⚠️ Advanced Approval Delegation을 켜면 검토자 사용자 레코드에 설정된 기존 위임은 더 이상 적용되지 않는다** — 검토자가 위임 레코드를 새로 만들어야 한다 |
| **Limit Approval Work Item Visibility to Keep Review Steps Confidential**<br>`rn_adv_approvals_work_item_sharing` | 한 스텝의 검토자가 **다른 스텝 검토자에게 배정된 work item을 보지 못하게** 한다. 공유 모델을 **private**으로 설정해 승인 제출과 **독립적으로** work item 가시성을 통제. 기본값은 승인 제출 접근 권한이 **연결된 모든 work item으로 확장**되는 것. 다른 사용자·그룹에 읽기 권한을 주려면 **approval work item 오브젝트에 criteria-based sharing rule** 생성. **Where:** *Advanced Approvals **또는 Flow Approval Processes** 가 활성화된* Enterprise·Unlimited·Developer |
| **New Objects in Advanced Approvals**<br>`rn_adv_approvals_new_changed_objects` | 신규 **`ApprovalDelegation`** 오브젝트 — 승인 책임을 **사용자·그룹·큐에 특정 기간 동안** 위임 |

### Salesforce Contracts — 개발자 표면

**New Connect REST APIs in Salesforce Contracts** (`rn_contracts_new_connect_rest_apis`) — AI 보조 리스크 검토와 playbook 표준을 계약 워크플로에 도입한다. 신규 리소스 전수:

| 메서드 | 리소스 | 요청/응답 바디 |
|---|---|---|
| **POST** | `/connect/contracts-ai/contract-document-version/{contractDocumentVersionId}/risk-analysis` | 요청 **Contract Risk Analysis Input** / 응답 **Contract Risk Analysis Run** — 계약 문서 버전에 대한 **비동기 리스크 분석 시작** |
| **GET** | `/connect/contracts-ai/contract-document-version/{contractDocumentVersionId}/risk-analysis` | 응답 **Contract Risk Analysis Run** — 리스크 분석 실행의 **상태·발견 사항 조회**(폴링) |
| **GET** | `/connect/playbook/playbook-contents` | 응답 **Playbook Content** — 쿼리 문자열에 **가장 잘 맞는 playbook 콘텐츠 청크** 조회 |
| **POST** | `/connect/playbook/playbook-version` | 요청 **Playbook Version Input** / 응답 **Playbook Version Details** — content document로부터 **playbook 버전 생성** |

### Billing

라이선스 표기: **Billing** = Revenue Cloud Billing 전용 · **Advanced 또는 Billing** = 둘 중 하나.

**① Billing Schedules and Billing Arrangements** (`rn_billing_schedules_arrangements` 허브)

| 항목 | 내용 | 라이선스 |
|---|---|---|
| **Change Billing Frequency on Active Subscriptions Anytime**<br>`rn_billing_change_frequency_arc` | 활성 구독의 청구 주기를 **어떤 주기에서 어떤 주기로든**(월↔연 등) 구독 취소·재생성 없이 변경. **수량 0(zero-quantity) amendment**로 주기를 바꾸면 Billing이 요금을 자동 **비례배분(prorate)** 하고 발효일부터 새 주기를 적용한다. **Billing 라이선스가 있으면** billing ops 팀이 **Create Standalone Billing Schedules API**로도 변경할 수 있고 **billing start month까지 지정** 가능 | Advanced 또는 Billing |
| **Support Flexible Billing With Weekly Cadences**<br>`rn_billing_weekly_cycle` | 견적·주문에서 **weekly 주기** 선택 — 매주부터 **6주마다**까지. Billing이 청구 기간 금액을 자동 비례배분하고 해당 주 단위 billing schedule을 생성. **How:** 주문 제품에 연결된 **billing treatment에서 Change Billing Frequency 선택** → 주문 제품의 **Billing Information** 섹션에서 frequency를 weekly로, **billing term을 양수로** 설정 | Advanced 또는 Billing |
| **Bill Every Few Weeks, Months, or Years Instead of Every Term**<br>`rn_billing_term_units` | **3주마다·5개월마다·2년마다** 같은 유연한 청구 기간. 원문 예: **분기 청구 = billing frequency를 monthly + billing term을 3**. Billing이 합산 기간의 금액을 자동 계산하고 다음 청구일을 설정 | Advanced 또는 Billing |
| **Honor Future-Dated Billing Suspensions During Invoicing**<br>`rn_billing_future_dated_suspensions` | 미래 일자 인보이스를 처리할 때 정지(suspension)를 **실행일이 아니라 target date 기준**으로 반영. target date가 정지 기간에 들면 그 기간의 **billing period item을 만들지 않는다** → 정지를 소급 입력할 필요가 없다. **Who:** Billing Admin **또는** Billing Operations User **또는** Billing Customer Service User 권한 세트. **How:** Account 또는 Billing Schedule Group 레코드의 퀵액션 메뉴에서 **Suspend Billing**, 또는 **Suspend·Resume Billing API** | Advanced 또는 Billing |
| **Track Ramp Deal Details on Billing Schedules**<br>`rn_billing_track_ramp_deal_details` | 신규 판매 램프 딜의 billing schedule에 **Ramp ID · Segment ID · Segment Name · Segment Type** 이 채워져 램프 세그먼트를 식별하고 가격 근거를 설명한다 | **Advanced** |
| **Visualize Billing Schedule Lifecycles with Timelines**<br>`rn_billing_schedule_timelines` | **Billing Schedule Group 페이지의 타임라인 뷰**로 청구 기간·금액·상태·주요 마일스톤 추적. **Who:** Billing Admin 또는 Billing Operations User | Advanced 또는 Billing |

**② Invoice Management**

| 항목 | 내용 | 라이선스 |
|---|---|---|
| **Generate Invoices Across Accounts for Owned and Billed Charges**<br>`rn_billing_generate_invoices_across_accounts` | 계정 수준의 **Generate Invoices·Preview Invoices·Invoice Scheduler** 가 **billing arrangement에서 그 계정을 billing account로 지정한 모든 billing schedule group** 을 대상으로 실행된다. **기본적으로 owned + billed 그룹을 모두 포함**하며 **타 계정이 소유한 요금의 split invoice까지** 포함. 이전엔 **계정이 소유한 그룹만** 처리했다. **Who:** Billing Admin 또는 Billing Operations User | Billing |
| **Advance Migrated Billing Schedules Without Rebilling by Using Catch-Up Bill Runs**<br>`rn_billing_catch_up_bill_runs` | 외부 시스템에서 이관한 청구를 **이미 청구된 기간의 인보이스를 만들지 않고** 목표일까지 전진시킨다 → 이력 인보이스 재처리·불필요한 세금 처리 없이 청구 연속성 유지. **Who:** Billing Operations User. **How:** App Launcher → **Billing Batch Scheduler** → **New Invoice Scheduler** → **Catch-Up Bill Run** 선택 | Advanced 또는 Billing |
| **Generate Invoice Documents Automatically During Invoice Batch Runs**<br>`rn_billing_generate_invoice_documents_batch` | 배치 실행 중 인보이스가 스트리밍되는 동안 **문서를 자동 생성** → 별도 문서 생성 단계 불필요. **Who:** 인보이스 실행 예약 = **Billing Operations User**, 배치 중 문서 생성 = **DocGen User**. **How:** Billing Batch Scheduler에서 draft·inactive 스케줄러를 편집해 **Generate invoice documents** 선택(신규 스케줄러 생성 시에도 포함 가능) | Billing |
| **Generate Context-Rich Sequence Patterns with Dynamic Fields**<br>`rn_billing_dynamic_sequence_patterns` | invoice·credit memo 등 대상 오브젝트의 **표준/커스텀 필드를 시퀀스 패턴에 삽입**하고 정적 텍스트와 조합해 번호 체계 구성. **Who:** Billing Admin. **How:** Setup → **Billing Settings** 에서 Billing용 **gapless sequential numbering** 구성 → App Launcher → **Sequence Policies** → 대상 오브젝트별 패턴 정의 시 포함할 필드 선택 | Billing |
| **Set Invoice Target Dates by Calendar Day or Billing Period Count**<br>`rn_billing_target_date_flexibility` | 고정 일수 오프셋 대신 **월중 특정 일자** 또는 **고정된 청구 기간 횟수** 기준으로 target date 설정 — 인보이스 배치 실행과 **Invoice API** 양쪽. **Who:** Billing Admin 또는 Billing Operations User. **How:** Billing Batch Scheduler에서 인보이스 스케줄러 생성 또는 draft·inactive 편집 | Advanced 또는 Billing |
| **Review All Impacted Split Invoices Before Posting, Voiding, or Deleting**<br>`rn_billing_review_split_invoices` | Invoice 페이지의 **Split Invoices 탭**이 **계정을 가로질러** 연결된 인보이스를 모두 표시한다. 한 건에 대한 **posting·voiding·deleting이 연결된 전체에 동일하게 적용**되므로 의도치 않은 재무 영향을 예방. **Who:** Billing Admin 또는 Billing Operations User | Billing |

**③ Collections**

| 항목 | 내용 | 라이선스 |
|---|---|---|
| **Prioritize and Act on Overdue Invoices in the Collections Specialist Console**<br>`rn_billing_collections_specialist_console` | 장기 연체 계정을 한 콘솔에서 처리 — **collection plan 생성 · 인보이스 write-off · 리마인더 발송 · 태스크 기록**을 페이지를 떠나지 않고 수행. **계정·통화로 카드와 차트 필터링.** 회수/미결 잔액·인보이스 경과일·**지급 약속(payment promise)** 추적. **Who:** **Billing Collections 및 Recovery Specialist 권한 세트**(복수). **How:** Collections 앱에서 Collections Specialist Console 열기 | Billing |
| **Prioritize Collections with Invoice Aging Summaries on Accounts**<br>`rn_billing_invoice_aging_summaries` | Account 페이지의 **Invoice Aging 컴포넌트**가 계정별 **총·오픈·연체 인보이스 + 평균·최대 경과일** 표시. **Who:** Billing Admin 또는 Billing Operations User. **How:** Lightning App Builder에서 **Invoice Aging for Account** 컴포넌트를 Account 페이지에 추가하고 **aging bucket 크기를 커스터마이즈** | Billing |

**④ Tax Management** (`rn_billing_tax_management` 허브)

**Extend the Revenue Standard Tax Engine to Match Your Tax Rules** (`rn_billing_extend_tax_engine`) — **Apex 코드 없이** 제품 카테고리·고객 속성·면세 기준 같은 **커스텀 속성 기반 세율**을 적용한다. **Revenue Standard Tax Entries decision table**을 커스텀 입력·출력 필드로 확장하고, 매칭된 값을 **invoice tax line·credit memo tax line 필드에 자동 채운다**. 라이선스: **Advanced 또는 Billing**.

- **Who:** 커스텀 메타데이터 타입·커스텀 필드 생성 = **Tax Admin** 권한 세트 / decision table 변경 = **Rule Engine Designer** 권한 세트
- **How:** tax rate에 커스텀 필드 생성 → **billing transaction 필드를 decision table 입력에 매핑하는 커스텀 메타데이터 타입** 생성 → **Revenue Standard Tax Entries decision table을 복제**하고 tax rate의 커스텀 입력·출력 컬럼 추가 → 그 decision table과 커스텀 메타데이터 타입을 **type이 Revenue Standard Tax Engine인 Tax Engine 레코드**에 연결

**⑤ Payments and Refunds** (`rn_billing_payments_refunds` 허브)

| 항목 | 내용 | 라이선스 |
|---|---|---|
| **Send Level 2 and Level 3 Payment Data Through a Native Payment Gateway**<br>`rn_billing_send_l2_l3_data_native` | **Stripe·Adyen** 네이티브 게이트웨이 요청에 **Level 2/Level 3 확장 거래 데이터** 전달. 결제 배치 실행이 그 확장 메타데이터를 **payment gateway log에 자동 포함**한다. **Who:** Payment Admin 또는 Payment Operations User. **How:** Setup → **Billing Settings** → **Level 2 and Level 3 Data Support** 켜기 | Billing |
| **Save Digital Wallets for Future Invoice Payments**<br>`rn_billing_save_digital_wallets` | **payment method set에 디지털 지갑을 추가**하면 고객이 Self-Service Billing Portal에서 **Apple Pay·Google Pay** 등을 저장해 다음 인보이스에 재사용하거나 **기본 수단으로 지정**할 수 있다. 저장된 지갑은 saved payment methods에 표시. **Who:** **Billing Experience Cloud User** 권한 세트 | Billing |
| **Accept Regional Payment Methods in the Self-Service Billing Portal Through Native Gateways**<br>`rn_billing_regional_payment_methods` | Self-Service Billing Portal에서 **지역 결제수단** 지원 — 원문 전수: **Bancontact · Klarna · Affirm · Canadian Pre-Authorized Debit · New Zealand BECS**(Stripe·Adyen 경유). **Who:** Billing Experience Cloud User | Billing |
| **Add Billing Self-Service Components in LWR Experience Cloud Sites**<br>`rn_billing_self_service_components_lwr` | **LWR 템플릿 기반** Experience Cloud 사이트에 청구 기능 추가. 팔레트에 노출되는 컴포넌트 전수: **Posted Invoices · Invoice Line Viewer · Self-Service Payment Sheet · Self-Service Payment Confirmation · Manage Saved Payment Methods**. **Who:** Billing Experience Cloud User. **How:** Experience Builder → 컴포넌트 팔레트 **Layout 섹션**에서 해당 컴포넌트를 페이지로 드래그 → 구성 후 사이트 재게시 | Billing |
| **Refund Available Credit Balances to Customer Accounts**<br>`rn_billing_issue_credits_as_refunds` | 계정에 남은 **크레딧 잔액을 환불**로 지급(환불 시 미결 크레딧 잔액이 자동 감소). 이전엔 **결제(payment)에 대한 referenced refund만** 가능했다. **credit memo 또는 credit memo line 단위**로 환불 가능. **Who:** Payment Admin 또는 Payment Operations User. **How:** Setup → Billing Settings → **Credits, Payments, and Refunds** 섹션 → **Credits, Payments, and Refunds Application** → credit memo 단위는 **Header Level**, credit memo line 단위는 **Line Level** 선택 | Billing |
| **Reconcile Payment Advice and Bank Data with Lockbox Processing**<br>`rn_billing_lockbox_reconciliation` | **Doc AI**로 payment advice 문서·수표·이메일 등에서 결제 데이터를 추출해 **은행 명세서와 자동 대사**. AR 팀이 매칭·미매칭 거래를 검토해 승인·반려. **Who:** **Data 360 기능 사용 = Data Cloud Architect 권한 세트**, 대사 레코드 검토·승인 = **Accounts Receivables Admin** 권한 세트 | Billing |
| **Orchestrate Cart-to-Cash Checkout Flow With a Single API Call**<br>`rn_billing_api_updates` | **Checkout API** — 외부 CPQ·웹사이트·커스텀 판매 채널에서 **단일 API 요청**으로 구독 생성 + 인보이스 생성 + 결제 처리·적용까지 수행(여러 번 호출할 필요 없음) | Billing |

**⑥ Billing 개발자 표면 — 전수**

**Changed Metadata Types in Billing** (`rn_billing_changed_metadata_types`) — 기존 **`BillingSettings`** 메타데이터 타입에 신규 **`enableBillingForecast`** 필드. 조직 수준 billing forecast 설정을 **Metadata API로 배포·조회**한다.

**New and Changed Connect REST APIs in Billing** (`rn_billing_new_changed_connect_rest_apis`)

| 구분 | 내용 |
|---|---|
| 신규 리소스 | **POST `/revenue/billing/credit-memos/actions/process-refund`** — credit memo에 직접 환불 발행. 요청 **Refund Credit Memo Input** / 응답 **Refund Credit Memo** |
| 신규 리소스 | **POST `/commerce/invoicing/invoices/collection/actions/checkout`** — 청구·결제를 위한 **통합 checkout 트랜잭션** 생성. 요청 **Billing Checkout Input** / 응답 **Billing Checkout** |
| 신규 리소스 | **POST `/connect/industries/collection/composite-collection-plan`** — **collection plan과 그 항목을 한 요청으로** 생성. 요청 **Composite Collection Plan Input** / 응답 **Composite Collection Plan** |
| 변경 — **Batch Invoice Scheduler Input** | 신규 프로퍼티 6개: **`jobType`**(스케줄러가 실행하는 잡 유형) · **`shouldRecalculateAllForecastLn`**(forecast 상태와 무관하게 전체 billing schedule을 선택할지, 적격 건만 선택할지) · **`shouldCatchUpBillRun`**(이전 청구 기간의 인보이스 없이 target date까지 전진할지) · **`targetDateDayOfMonth`**(target date 계산에 쓸 월중 일자 규칙) · **`targetDateMonthOffset`**(월 오프셋) · **`billingCycleCount`**(청구할 청구 주기 수) |
| 변경 — **Schedule Options Input** | 신규 **`shouldGenerateDocuments`** — 스케줄러가 트리거한 배치 처리 중 인보이스 문서를 자동 생성할지 |
| 변경 — **Standalone Credit Memo Input** | 신규 **`customFields`** — credit memo 레코드의 커스텀 필드 값 |
| 변경 — **Standalone Credit Memo Charge Input** | 신규 **`customFields`** — charges 목록의 각 credit memo line의 커스텀 필드 값 |

**New and Changed Invocable Actions in Billing** (`rn_billing_new_changed_invocable_actions`)

- 신규 **`processRefundCreditMemo`** — posted credit memo에 대한 환불 처리
- 기존 **`createBillingSchedulesFromBillingTransaction`** 에 신규 입력 파라미터 **`executeAsync`** — billing schedule 생성 요청 **비동기 처리**
- 기존 **`createBillingSchedulesFromTrxn`** 에 신규 입력 파라미터 **`executeAsync`** — standalone billing schedule 생성 요청 비동기 처리

**New and Changed Objects for Billing** (`rn_new_changed_billing_objects`) — 원문 전수

| 영역 | 신규 오브젝트 |
|---|---|
| Invoice Management | **`BillingForecast`** — 실제 청구 전에 billing schedule로부터 생성된 **예측 인보이스 라인** 정보 |
| Payments and Refunds | **`PaymentAdviceInvoiceRecile`** — payment advice line ↔ 오픈 인보이스 매칭 정보 |
| Payments and Refunds | **`PaymentAdviceReconciliation`** — payment advice ↔ 은행 거래·확정 계정의 대사 정보(**매칭 신뢰도**와 **검토자 결정** 포함) |
| Payments and Refunds | **`RefundLineCreditMemo`** — credit memo에 적용된 환불 |
| Payments and Refunds | **`RefundLineCreditMemoLine`** — credit memo **line**에 적용된 환불 |

| 영역 | 변경 오브젝트·필드 |
|---|---|
| Billing Schedules | `AssetActionSource`·`OrderItem`·`QuoteLineItem` — 신규 **`BillingTerm`**(한 billing period item에 합칠 청구 주기 단위 수) |
| Billing Schedules | `BillingPeriodItem.Status` — 신규 지원 값 **Catch-Up Processed**(catch-up bill run이 처리한 billing period item) |
| Billing Schedules | `BillingSchedule` — 신규 **`ForecastStatus`**(forecast 실행에서의 라이프사이클) · **`InvoiceBatchRun`**(예측에 사용된 인보이스 배치 실행) · **`LastForecastRunTargetDate`**(가장 최근 forecast 배치의 target date) · **`RampIdentifier`**(같은 램프 제품의 billing schedule을 묶는 램프 딜 ID) · **`SegmentIdentifier`** · **`SegmentName`** · **`SegmentType`** |
| Invoice Management | `BillingBatchScheduler` — 신규 **`ShouldGenerateInvoiceDocuments`** |
| Invoice Management | `InvoiceBatchRun` — 신규 **`DocGenerationBatchProcess`**(배치용 문서 생성 프로세스 ID) · **`ForecastEndDate`** · **`ForecastStartDate`** · **`JobType`** · **`TotalForecastedAmount`**(배치 중 생성된 전체 forecast 라인 금액) · **`TotalForecastLines`**(생성된 forecast 라인 수) |
| Invoice Management | `InvoiceBatchRun.StatusSubtype` — 신규 지원 값 4개: **Catch-Up Billing Schedules Started** · **Catch-Up Billing Schedules In Progress** · **Catch-Up Billing Schedules Completed** · **Catch-Up Billing Schedules Summarization In Progress** |
| Invoice Management | `InvoiceBatchRunCriteria` — 신규 **`BillingPeriodCount`** · **`ShouldCatchUpBillRun`** · **`ShouldRecalculateAllForecastLn`** · **`TargetDayOfMonth`** · **`TargetMonthOffset`** |
| Invoice Management | `InvoiceLineTax` — 신규 **`NetCreditsApplied`**(인보이스 라인 세금에 적용된 credit memo line 총액) · **`NetPaymentsApplied`**(적용된 결제 총액) |
| Tax Management | `TaxEngine` — 신규 **`CustomMetadataTypeApiName`**(세금 콜아웃 요청·응답의 필드 매핑을 정의하는 커스텀 메타데이터 타입 API 이름) · **`DecisionTable`**(revenue standard tax engine이 세금 계산에 쓰는 decision table) |
| Payments and Refunds | `CreditMemo` — 신규 **`CreditMemoLockedDateTime`** · **`IsCreditMemoLocked`** · **`SavedPaymentMethod`** |
| Payments and Refunds | `CreditMemoLine` — 신규 **`TotalAppliedRefundAmount`** · **`TotalUnappliedRefundAmount`** |
| Payments and Refunds | `CreditMemoLineInvoiceLine` — 신규 **`InvoiceLineTax`** · **`SettlementType`**(인보이스 라인에 적용된 credit memo line이 정산하는 금액 유형) |
| Payments and Refunds | `PaymentLineInvoiceLine` — 신규 **`InvoiceLineTax`** · **`SettlementType`** |
| Payments and Refunds | `Refund` — 신규 **`ReasonCode`**(환불 주 사유를 식별하는 고유 코드) · **`ReferenceRecord`**(환불이 발행된 대상 레코드 — 인보이스·credit memo·payment 등) |
| Collections | `CollectionPlanItem` — 신규 **`InitialInvoiceBalance`**(collection plan item 생성 시점의 관련 인보이스 잔액) |

**Preview Future Invoice Charges with Billing Forecast**

- **Where:** Lightning Experience — **Enterprise·Unlimited·Developer** 에디션의 Revenue Management(구 Revenue Cloud) + **Revenue Cloud Billing 라이선스**. **Billing Forecast Console을 보려면 Tableau Next Consumer 라이선스가 필요**하다
- **Who:** 활성화 — **Billing Admin** 권한 세트 / 예측 스케줄 생성·관리 — **Billing Operations User** 권한 세트
- **How:** Setup → **Billing Settings** → Billing Forecast 켜기 → App Launcher → **Billing Batch Scheduler** → **New Billing Forecast Scheduler**. 결과는 **Billing Forecast 레코드**에서 직접 보거나, Tableau 설정을 마친 뒤 **Billing Forecast Console**에서 확인
- 일회성(one-time)·구독(subscription) 요금 유형·카테고리 모두 예약 예측 가능

### Agentforce for Revenue Management

**Accelerate Approval Decisions with Approval Agent** (`rn_rev_agentforce_approvals_agent`)

- 영업 담당: 승인 **제출·회수(recall)**, 대기 중 승인 추적. 검토자: 제출 조회, **AI 보조 요약·코멘트 생성**, 승인/반려
- **Where:** Lightning Experience — **Enterprise·Unlimited·Developer** 에디션에서 **Advanced Approvals와 Agentforce가 모두 활성화**된 경우(Revenue Cloud 라이선스 문구가 아니다)
- **When:** **2026년 9월 14일 주(week of September 14, 2026)부터** 이용 가능

### ⭐ 대표 신기능
1. **라인 아이템 15,000건 대형 트랜잭션** 전 구간(동기화·가격·구성 규칙·문서 생성·DPE transform) — Large Transaction 권한 + Revenue Settings의 **Large Transaction Processing** 토글이 관문.
2. **Promotions in Revenue Management 신규 도입** + Billing의 **주간 청구·catch-up bill run·Billing Forecast·Collections Specialist Console**.
3. **Advanced Approval Delegation**(켜면 기존 사용자 레코드 위임이 무효화됨) + 승인 work item 기밀 공유(private 모델).

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

**Workforce Management — Winter '27 최대 확장 영역 중 하나 (21건 전수, 본문 확보)**

> **Where 공통:** *"This change applies to Lightning Experience in **Enterprise, Performance, and Unlimited** editions. **Workforce Management is available for an additional cost as an add-on license.**"* — 아래 21건 중 **19건이 이 공통형**이다. 예외 2건: **Improve the Worker Calendar Experience**는 Where에 **Salesforce 모바일 앱**이 함께 명시되고, **Simplify Workforce Management Discovery and Setup**은 **원문에 Where 문장 자체가 없다**(에디션 미상 — 추정 금지). 아래 표는 그래서 Where를 반복하지 않고 **Who(권한 세트)·How(경로)** 만 적는다.

| 항목 | 내용 · Who · How |
|---|---|
| **Simplify Workforce Management Discovery and Setup**<br>`rn_workforce_mgmt_discovery_setup` | **Salesforce Go** 한 곳에서 WFM 기능 발견·구성. **How:** 톱니 메뉴 또는 Setup 메인 메뉴 → **Salesforce Go** → **Features 탭**에서 Workforce Management 검색, 또는 **Manage an Agentforce Contact Center 기능 세트**에서 탐색. **⚠️ 이 페이지에는 Where 문장이 없다** |
| **Support Skills-Based Planning with Work Skill Groups**<br>`rn_workforce_mgmt_work_skill_groups` | 개별 스킬 또는 스킬 조합으로 **work skill group** 생성 — 들어오는 작업 패턴을 대표하게 구성. **생성 전 최근 30일 작업량**과 선택한 스킬을 **최소한 보유한** service resource 수를 검토한다. **Who:** Workforce Engagement **Analyst + Planner**. **How:** 앱에 **Work Skill Groups 탭** 추가 → 재사용 가능한 그룹을 만들고 스킬 조합별 작업량·리소스 지표 검토 |
| **Expand Workload Planning Across Multiple Work Sources**<br>`rn_workforce_mgmt_workload_planning_sources` | **Omni-Channel 큐 기반·스킬 기반 작업 + Field Service service appointment + Mobile Workforce Management 커스텀 오브젝트**로 workload 구성. 집계 차원: **service channel · work skill group · queue · region · work type**. **Who:** Analyst + Planner. **How:** New 클릭 → **보유 라이선스에 따라** workload 소스 선택 후 기간·차원 구성. **구성 옵션은 workload 타입마다 다르다** — Omni-Channel은 service channel과 skill group·queue를, Field Service·MWM은 **source object·region·work type**(**Average Handle Time 필드 포함**)을 쓴다 |
| **Forecast Demand with Skills-Based Workloads**<br>`rn_workforce_mgmt_skills_based_workloads` | 완료된 workload로 예측 생성(스킬·스킬그룹 수준 수요 포함). 구간·채널·스킬그룹별 **Volume·Average Handle Time** 의 과거/예측치 검토. **Who:** Analyst + Planner. **How:** App Launcher → **Intelligent Forecasts** → 완료된 workload·과거 데이터 범위·예측 기간·모델·구간 선택. **⚠️ 과거 기간을 workload의 보유 데이터 범위 너머로 잡으면 Salesforce가 예측 처리 전에 workload를 먼저 갱신한다** |
| **Plan Staffing with Skills-Based Capacity Plans**<br>`rn_workforce_mgmt_skills_based_capacity_plans` | 스킬그룹·채널·job profile 선택, SLA 구성, work unit 정의로 필요 인력 산출. **공유 스킬을 기준으로 유효한 job profile↔skill group 조합을 자동 식별**해 수동 매핑 오류를 막는다. **여러 스킬그룹에 같은 SLA를 일괄 적용 가능.** **Who:** 생성·편집·삭제 = **Analyst**, 조회 = **Planner** |
| **Compare Required and Available Staffing at a Glance on the Capacity Plan Page**<br>`rn_workforce_mgmt_compare_staffing_capacity_plan` | Capacity Plan 레코드 페이지에서 job profile별 **필요 capacity vs 가용 capacity** 차트 + job profile·채널별 **Capacity Details** 표. **shift template 기준의 shift requirement 표시는 없어졌고, shift 생성은 Schedule Manager로 이동했다.** **Who:** 생성·편집·삭제 = Analyst, 조회 = Planner. **How:** interval·date·filter 컨트롤로 시간 단위와 계획 기간을 조정하고 특정 job profile·채널로 좁힌다 |
| **Monitor Net Staffing**<br>`rn_workforce_mgmt_monitor_net_staffing` | Job Profile·Service Resource 페이지의 **Net Staffing Grid** 로 인력 공백 식별. **How:** Schedule Manager → **Service Resource 또는 Job Profile 뷰**로 전환. 그리드는 **Net Staffing · Scheduled Staffing · Required Staffing** 지표를 **초과=녹색 / 부족=적색**으로 표시하고, capacity plan을 선택하면 그 요구치 대비로 계산된다. **Who:** capacity plan 생성·편집·삭제 = Analyst / Net Staffing Grid 조회 = **Planner(단, capacity plan 접근 권한이 있어야 한다)** |
| **Balance Rest and Coverage with More Scheduling Rules**<br>`rn_workforce_mgmt_scheduling_rules` | **Rest Between Shifts · Rest Between Weeks · Multiple Breaks** 규칙 유형 추가. 연속 근무·주 간 최소 휴식 강제, 설정 시간창 내 휴게 분산, **15분 간격**으로 근무·휴게 배치. **Who:** Workforce Engagement **Planner 또는 Admin**(규칙 구성·스케줄 최적화). **How:** scheduling rule 생성 시 규칙 타입 선택 → 필요한 휴식 값 입력(Multiple Breaks는 **각 휴게의 길이와 유효 시간창**) |
| **Save Time Generating Shifts from Patterns or Capacity Plans**<br>`rn_workforce_mgmt_generate_shifts_patterns_plans` | shift pattern·capacity plan에서 다건 shift 일괄 생성 + 적격 service resource 자동 배정. **자동 배정 실패분은 Tentative 상태로 남는다.** **Who:** Analyst + Planner. **How:** App Launcher → Schedule Manager → 패턴·capacity plan에서 생성 → 필수 필드 지정, 자동 배정 옵션 선택 → 그리드에서 확인 |
| **Create Shifts Faster with Drag-and-Drop Templates**<br>`rn_workforce_mgmt_drag_drop_shift_templates` | 스케줄 그리드에 shift template·pattern을 드래그앤드롭해 리소스·날짜에 배치. **Who:** **Shift Scheduling Planner + Workforce Engagement Planner** 권한 세트(둘 다). **How:** Schedule Manager 우측 패널의 **Templates 탭**에서 끌어다 놓는다 — **드래그 중 유효한 위치가 그리드에 표시**되고, 놓으면 shift가 생성·배정된다 |
| **Generate More Flexible Shift Schedules with Shift Patterns**<br>`rn_workforce_mgmt_flexible_shift_patterns` | pattern entry별 **Occurrences** 지정으로 반복. 패턴에서 shift를 생성할 때 service resource **자동 배정**도 가능하며, 자동 배정 실패분은 **Tentative 상태 카테고리**가 부여된다. **Who:** **Shift Scheduling Planner 또는 Workforce Engagement Planner**. **How:** shift pattern에 Occurrences 지정 → Schedule Manager 또는 Shifts 리스트뷰에서 **New from Pattern** → 필요 시 *Automatically assign shifts to service resources* 선택 |
| **Organize Shift Work with Shift Activities**<br>`rn_workforce_mgmt_shift_activities` | Schedule Manager에서 shift를 **shift activity** 단위로 분해·추가·수정·삭제. activity는 **부모 shift의 타임존을 상속**하고 타임존 토글 전환 시 함께 이동한다. **Who:** Workforce Engagement **Planner와 Agent**. **How:** Schedule Manager를 **Day and Activity 뷰**로 전환 → shift 선택 → **Edit Shift Activities** 다이얼로그 |
| **Manage Requests Without Leaving Schedule Manager**<br>`rn_workforce_mgmt_manage_requests_schedule_manager` | resource absence 요청을 스케줄 맥락에서 검토하고 **코멘트와 함께** 승인/반려. **Salesforce Go 페이지에서 승인 플로우 생성·배포** 가능. **Who:** Planner. **How:** Schedule Manager의 **Requests 패널** → 대기·검토 완료 요청 확인 → 승인/반려 + 코멘트. 검토된 요청은 **Reviewed 탭**에 상태·코멘트와 함께 남는다 |
| **Find Shifts Faster with Advanced Search and Filters**<br>`rn_workforce_mgmt_advanced_search_filters` | 다중 필터 조합·레코드/필드 교차 검색·자주 쓰는 필터 조합 저장. **Who:** Planner. **How:** Schedule Manager 필터 패널에서 **Service Territory · Service Resource · Job Profile · Skills · Custom Objects · Shift Template · Shift Status · Request Types · Violations** 기준 값 선택 → **Smart Object Search**로 지원 레코드·필드 검색 → 검색어와 필터 조합 → **이름 붙인 뷰로 저장**하고 기본 뷰 지정 가능 |
| **Manage Schedules with Scheduling Agent**<br>`rn_workforce_mgmt_scheduling_agent` | 자연어로 배정된 shift 조회·재배정. **Worker Shift Agent** = 요청 기간의 shift 정보 반환, **Scheduling Agent** = 재배정 처리(확인 요청·모호한 요청 명확화·스케줄 충돌 방지). **Who:** Workforce Engagement **Agent** 권한 세트. **동작 세부:** 사용자에게 연결된 **worker 레코드가 없으면 Worker Shift Agent가 그 사실을 알린다**. 일치하는 shift가 여러 건이면 추가 정보를 요구한다. **대상 리소스가 같은 날짜에 충돌하는 shift를 이미 갖고 있으면 재배정은 완료되지 않는다** |
| **Optimize Intraday Staffing with Real-Time Adherence**<br>`rn_workforce_mgmt_real_time_adherence` | Intraday 대시보드의 동적 adherence 점수·결근 표시·색상 상태 블록이 예정 활동과 **Omni-Channel 실제 상태**를 비교. Job Profile·Service Territory로 이탈 상담원 필터, **schedule allowance** 설정으로 사소한 편차 흡수. **플랫폼 이벤트로 플로우 자동화를 트리거**해 Slack·이메일 알림까지 확장(**관리자가 구성한 경우에 한함**). **Who:** Planner. **How:** WEM Console App에서 **Real-Time Adherence** 켜기 → Intraday Schedule 대시보드 확인, **start-time allowance는 Setup에서 구성** |
| **Gain Visibility Into AI and Agent Performance**<br>`rn_workforce_mgmt_ai_agent_performance` | Intraday Adherence Gantt에 **AI workforce 전용 행** — 시간당 총 처리 상호작용·에스컬레이션율·containment 추세 + **다음 구간 예측 성능**. **Who:** Planner. **How:** WEM Console App의 Intraday Adherence Gantt에서 **Agentic Workforce View**를 켜면 상담원 스케줄 옆에 AI workforce 행이 표시된다 |
| **Access Your Schedule Directly from Omni-Channel**<br>`rn_workforce_mgmt_schedule_from_omni_channel` | Omni-Channel 작업공간에서 배정 shift·예정 활동 확인. **현재 시각으로 자동 스크롤.** **Who:** **Workforce Engagement Agent 권한**(권한 세트가 아니라 permission으로 표기). **How:** Omni-Channel 사이드바의 **Schedule 탭** 또는 스케줄 아이콘. **Omni-Channel utility 위젯을 쓰는 앱**에서는 위젯을 열고 Schedule 탭 선택 |
| **Improve the Worker Calendar Experience**<br>`rn_workforce_mgmt_worker_calendar` | 키보드 내비게이션, 페이지 이탈 없이 이벤트 상세 미리보기, 커스텀 Lightning 페이지에 캘린더 고정, in-place 새로고침. **Who:** **Shift Scheduling Agent 또는 Workforce Engagement Agent**. **모바일 수정 사항:** 캘린더가 **예기치 않게 스크롤되던 문제 해소**, **중복된 View Calendar 링크 제거**. **⚠️ Where에 Salesforce 모바일 앱이 함께 명시된 유일한 WFM 항목** |
| **Get Real-Time Notifications About Shift Changes**<br>`rn_workforce_mgmt_shift_notifications` | **Shift Assigned · Shift Unassigned · Shift Starting Soon · Clock Out Reminder** 실시간 알림. **Who:** Workforce Engagement Agent. **How(설정 필수):** **Workforce Notifications 조직 환경설정**을 켜면 알림 타입들과 **Send Shift Notifications 플로우 템플릿**이 생성된다 → 템플릿에서 플로우를 만들어 **활성화**하고 데스크톱·모바일 앱 전달을 구성. **발송 시점:** shift 배정·해제 시, **shift 시작 약 15분 전**, shift 종료 시 |
| **Find and Request Open Shifts to Fill Coverage Gaps**<br>`rn_workforce_mgmt_open_shifts` | 스킬·territory·labor rule·스케줄 기준 적격 오픈 shift를 데스크톱·**Salesforce 모바일 앱**에서 조회·신청. **제출 전 시스템이 적격성을 자동 확인**한다. **Who:** 조회·신청 = **Workforce Engagement Agent** / 검토·승인·거절 = **Workforce Engagement Planner**. **How:** 데스크톱은 Open Shifts 목록에서 신청, 모바일은 **Open Shifts 탭** → shift 선택 → **Request**. **My Requests**에서 대기·검토 완료 요청을 추적하고 대기 중 요청을 취소할 수 있으며, 승인된 shift는 정규 shift·휴가와 함께 개인 스케줄에 표시된다 |

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
| **Easily Access and Review Service WhatsApp Health Status in Salesforce**<br>`rn_wa_business_profile` | 신규 **WhatsApp Business Profile 페이지**에서 전화번호·WABA·Business·Salesforce App 가용성 확인. 채널에 연결된 전화번호·비즈니스 프로필 상세도 검토. 이전엔 Meta 계정이나 API 조회가 필요했다. **Where: Service WhatsApp**(원문은 에디션을 나열하지 않고 *"View required editions"* 링크로 대체). 원문이 밝힌 고객 요구 3가지: ① 전화번호의 **Two-Step Authentication 상태 확인** ② 기본 표시 전화번호 대신 **채널 이름 변경** ③ 전화번호·WABA·Business·Salesforce App 상태 확인. **How:** Messaging Settings Setup 노드에서 WhatsApp 채널 열기 → **WhatsApp Business Profile** 클릭 |
| **Seamlessly Create and Troubleshoot WhatsApp Account Setup in Salesforce and Meta**<br>`rn_wa_embedded_signup_v4` | **2026-10-01에 Meta의 Embedded Signup Flow v2·v3 지원 중단(deprecating).** Salesforce는 그 시점에 **Embedded Signup v4**를 지원한다. Unified/Service WhatsApp 가입 플로우의 **Meta 화면 UI가 달라지며**, Salesforce 플로우를 벗어나지 않고 **Meta에 직접 WABA를 만들거나 문제를 해결**할 수 있다. **Where: Unified WhatsApp 또는 Service WhatsApp 설정**(에디션은 *"View required editions"*) |
| **Capture WhatsApp Flow Responses Submitted After a Messaging Session Ends**<br>`rn_messaging_wa_flow_after_session` | 세션 종료 후 제출된 폼 응답을 폐기하지 않고 **지정 레코드에 저장**하고 Service Console에 원 폼 요청의 답장으로 표시. **Where: enhanced WhatsApp 채널(Unified Messaging으로 설정한 채널 포함).** **How: 설정 불필요 — 자동 캡처.** **⚠️ 응답이 세션 종료 후 도착하므로 서비스 담당에게 라우팅되지 않고, 담당자에게 알림도 가지 않는다**(전체 맥락 유지를 위해 원 폼 요청의 답장으로만 표시) |
| **Inform Customers When Their Chat Is Rerouted to Another Service Rep** | **Enhanced messaging + Enhanced Chat.** auto-response 메시징 컴포넌트 생성 → Messaging Settings의 채널 → Automated Responses → **Reroute Conversation** 필드에 지정 |
| **Report on Service Reps' Time Between Session Acceptance and First Response**<br>`rn_accept_to_first_response` | `MessagingSessionMetrics` 오브젝트의 `MessagingSessionMetricType` 필드에 **Service Rep Accept to First Response Time** 값 신규 추가. 이전엔 **전환(transfer)이 담당자 본인 또는 그가 속한 큐로 개시된 이후**의 최초 응답 시간만 리포팅 가능했다. **Where: Enhanced Messaging 채널 + Enhanced Chat**(에디션은 *"View required editions"*) |
| **Find Transfer and Conference Destinations with Clearer Labels** (Bring Your Own Channel)<br>`rn_messaging_byoc_transfer_conference_labels` | Transfer Conversation 대상 목록에서 **Others → External contacts**, **전 메시징 채널**의 전환·컨퍼런스 대상에서 **Agents → Reps** 로 용어 정리. **Where: Bring Your Own Channel for Messaging + Bring Your Own Channel for CCaaS**(에디션은 *"View required editions"*) |

### Agentforce Service Assistant

Winter '27에서 Service Assistant가 **케이스 전용 → 메시징 세션 실시간 에이전트**로 확장됐다. 공통 라이선스 축: **Lightning Experience** + Enterprise·Unlimited·Developer + **Agentforce for Service 또는 Agentforce 1 애드온**, 그리고 **Service Planner + Adaptive Experience 애드온**. **단 아래 두 예외를 이 축에 그대로 적용하면 안 된다.**

> [!note] 공통 축의 예외 2건 (원문 Where 대조)
> - **Einstein for Service도 대상인 항목:** `rn_sra_persistence`(세션 종료 후 24시간) · `rn_sra_status`(상태 표시) · `rn_sra_link`(클릭 가능 URL) · `rn_sra_ccu`(Conversation Catch-Up). 원문 Where가 *"with Einstein for Service, Agentforce for Service, and Agentforce 1"* (ccu는 *"the Einstein for Service, Agentforce for Service, or Agentforce 1 add-ons"*)로 **Einstein for Service를 함께 명시**한다 — 공통 축만 보고 자격을 좁히면 안 된다.
> - **`rn_sra_link`(Access Resources Linked in Plan Steps with Clickable URLs)는 Adaptive Experience 애드온이 필요 없다.** 원문: *"This feature requires the Service Planner Add-on license."* — **Service Planner 애드온만** 요구한다.
> - **`rn_sra_multi_agent`(Scale Service Assistant Across More of Your Business with Multiple Agents)도 Adaptive Experience 애드온이 필요 없다.** 원문 Where: *"…with **Einstein for Service, Agentforce for Service, and Agentforce 1** add-on licenses. This feature **also requires the Service Planner Add-on license**."* — **Einstein for Service 포함 + Service Planner 애드온만**.

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
| **Scale Service Assistant Across More of Your Business with Multiple Agents**<br>`rn_sra_multi_agent` | Case **2026-06-30** / Messaging **2026-07-21(preview)** | 서브에이전트·지시문을 특화한 **Service Assistant 에이전트를 여러 개** 만들어 사업부·제품·채널별 맞춤 지원. **이전엔 Service Assistant 에이전트가 1개로 제한**됐고, 이제 **최대 150개**까지 만들 수 있다(각각 고유 서브에이전트·지시문·데이터 라이브러리 보유). **Who:** 설정 = Service Planner Builder / 서로 다른 에이전트에 배정된 레코드에 플랜 생성 = Service Planner User / **ServicePlanner User(에이전트 사용자)는 별도 권한 불필요**. **How:** 적격성 플로우가 활성이고 서브에이전트를 가진 에이전트가 **최소 2개** 있어야 한다 → 레코드를 에이전트로 라우팅하는 **autolaunched 플로우를 직접 작성**(**Salesforce는 플로우 템플릿을 제공하지 않는다**) → Setup에서 Service Assistant에 연결하고 **기본 에이전트 지정**. **기본 에이전트는 플로우가 빈 값·null을 반환하거나 배정된 에이전트가 비활성화됐을 때 쓰인다.** **GA 이전부터 Service Assistant를 운영 중이었다면 기존 에이전트가 자동으로 기본 에이전트가 된다** |
| **Respond Faster and More Accurately to Customers with Service Replies in Service Assistant**<br>`rn_sra_msg_sr` | Messaging / **2026-07-21** | 메시징 세션 중 **Service Replies**를 Service Assistant 안에서 바로 사용 — 대화와 지식 베이스에 grounding된 문맥 인식 답장을 **서비스 플랜 단계 옆에** 표시하므로 **별도 Service Replies 컴포넌트로 전환할 필요가 없다**. **지원 채널: Enhanced Chat · Facebook · WhatsApp.** **Who:** 설정 = **Service Planner Builder + Service Replies User + Prompt Template Manager + Data Cloud Architect**(**데이터 라이브러리로 grounding할 때만** 필요) / 사용 = Service Planner User + Service Replies User / **ServicePlanner User(에이전트 사용자)** = Service Replies User + Prompt Template User. **How:** Service Assistant for Messaging 설정과 **Service Replies for Chat 설정**을 모두 끝낸 뒤 **Service Replies Setup 페이지**에서 *Service Replies for Service Assistant* 켜기 → **첫 메시지 이후부터** 컴포넌트에 답장이 생성된다 |
| **Start Messaging Service Plans Automatically**<br>`rn_sra_msg_auto_start` | Messaging / **2026-07-21** | 서비스 플랜 요약이 생성되면 **동적 서비스 플랜이 자동 실행**된다 — 담당자가 **Start Plan을 누를 필요가 없다**(켜면 컴포넌트에 Start Plan 버튼 자체가 사라진다). **지원 채널: Enhanced Chat · Facebook · WhatsApp.** **Who:** 켜기 = Service Planner Builder / 사용 = Service Planner User / **자동 시작을 위해 ServicePlanner User에게 Agent Messaging Access 커스텀 권한 세트 필요** — 앱 권한 *Access Conversations Entries*, Messaging Sessions 오브젝트 권한 **Read·View All Fields**. **How:** Service Assistant for Messaging 설정 완료 후 Service Assistant Setup 페이지 **Messaging 탭**에서 **Start Plans Automatically** 켜기 |

### AI Solutions for Service

| 항목 | 내용 |
|---|---|
| **Einstein/Agentforce Article Recommendations** | 케이스 한 건 안의 **여러 이슈**를 식별·해결 |
| **Resolve Every Issue in a Case with Multi-Intent Article Recommendations** | Agentforce Article Recommendations for Cases가 **최대 3개의 서로 다른 intent**를 식별하고 각 intent별 검색을 만든 뒤 결과를 **순위 병합**. **Where: Lightning Experience** + **Data Cloud(원문 표기 그대로 — 리브랜드 후 명칭은 Data 360)가 프로비저닝**되고 Agentforce Article Recommendations for Cases가 이미 활성인 조직(원문: *"orgs with Data Cloud provisioned and Agentforce Article Recommendations for Cases already enabled"*). **이전엔** 케이스 전체로 만든 **단일 검색 쿼리** 때문에 *"가장 두드러진 주제가 고객이 언급한 다른 이슈의 문서를 밀어냈다"*(원문: *"Previously, a single search query built from the whole case let the most prominent topic crowd out articles for other issues the customer mentioned."*). **When: Salesforce가 조직에 활성화해야만 사용 가능** — Setup에 Enable Multi-Intent Detection 토글이 없으면 계정 팀에 활성화 확인 요청. **How:** Setup → Service → Einstein → Einstein Article Recommendations for Cases에서 **Get Recommendations on Cases 플로우**를 쓰고 있는지 확인 후 토글. **Get Generative AI Recommendations for Cases 플로우를 쓰는 조직에서는 사용 불가** |
| **Generate Enhanced Case Summaries in Five More Languages**<br>`rn_enhanced_summaries_additional_languages` | Enhanced Summaries for Case에 **체코어·그리스어·헝가리어·폴란드어·루마니아어** 추가(기존 지원 언어에 더해). **대화가 다른 언어로 진행돼도 요약은 담당자 언어로 생성**된다. **Where:** Lightning Experience · **Enterprise·Unlimited** + **Agentforce for Service 애드온 또는 Agentforce 1 에디션**(구매는 계정 임원 문의). **How:** Setup의 **Enhanced Summaries** 페이지에서 **Summary in User Language** 켜기 **+ Einstein Setup 페이지에서 Global Languages 켜기** — 두 토글이 모두 필요하다 |
| **Einstein Work Summaries — Automate Summary Generation for Enhanced Messaging**<br>`rn_work_summaries_auto_messaging` | Enhanced Messaging 세션이 끝나면 작업 요약이 **자동 생성**된다. **Where:** Lightning Experience · Enterprise·Unlimited + Agentforce for Service 애드온 또는 Agentforce 1. **How:** **자동 생성은 기본 켜짐.** Setup → **Einstein Work Summaries** → **Enhanced Messaging 탭** → *Automatically Generate Summaries* 로 켜고 끈다. **`Automatically Save Summaries`는 기본 꺼짐** — 기본 동작은 요약이 콘솔에 뜨고 담당자가 검토 후 저장하는 것이며, 검토 없이 자동 저장하려면 이 토글을 켠다 |
| **Einstein Work Summaries — Automate Summary Generation for Voice Calls**<br>`rn_work_summaries_auto_voice` | Voice 통화가 끝나면 작업 요약이 **자동 생성**된다. Where는 위와 동일. **How:** 자동 생성 기본 켜짐. Setup → Einstein Work Summaries → **Voice Calls 탭** → *Automatically Generate Summaries*. **`Automatically Save Summaries`는 기본 꺼짐**(담당자 검토 후 저장이 기본) |
| **Generate Work Summaries for Enhanced Messaging and Voice Calls in Five More Languages**<br>`rn_work_summaries_additional_languages` | Enhanced Messaging·Voice 작업 요약에 **체코어·그리스어·헝가리어·폴란드어·루마니아어** 추가. **대화 언어와 무관하게 담당자 언어로 생성**. Where는 위와 동일. **How:** Setup → **Einstein Work Summaries** 페이지에서 **Summary in User Language** 켜기 **+ Einstein Setup 페이지에서 Global Languages 켜기** |
| **Work Summaries for Case (Beta) Is Being Retired**<br>`rn_work_summaries_case_beta_retirement` | **2026-09-30 은퇴 예정**이며 그때까지 **유지보수 모드(maintenance mode)** 다. 그 날짜까지는 계속 쓸 수 있으나 **Enhanced Summaries로 전환 권장**(역할별 요약과 더 많은 요약 기능 제공). **⚠️ 2026-09-30부로 제거되며 Case Summaries에 접근·사용할 수 없게 된다** — 서비스 중단을 피하려면 그 전에 전환. **Where:** Lightning Experience · Enterprise·Unlimited + **Einstein for Service 애드온 또는 Einstein 1 에디션**(위 Work Summaries 3건과 애드온 계열이 다르다). 원문 Beta 고지: Beta Services Terms 또는 서면 Unified Pilot Agreement, Product Terms Directory의 해당 조항이 적용되며 **사용 여부는 고객 재량** |
| **Service Replies for Email — Ground in Enterprise Knowledge** | **SharePoint·Confluence·내부 위키·PDF 매뉴얼** 등 내외부 지식 소스 기반 답장 생성. Salesforce **Enterprise Knowledge**에 연결해 인덱스에서 실시간 검색. **각 제안 답장에 출처 문서 인용 링크 포함.** Where: Enterprise·Unlimited + **Agentforce for Service 애드온 또는 Agentforce 1 에디션** |

### Case Management

| 항목 | 내용 |
|---|---|
| **Refine Case Comments with AI-Powered Writing Tools**<br>`rn_cases_refine_case_comments_with_ai_powered_writing_tools` | 케이스 코멘트 편집기에서 초안을 **다듬기·확장·요약**(의도한 의미는 보존). 관리자가 **Refine Case Comment 프롬프트 템플릿**에 설정한 가이드에 따라 담당자가 **직접 지시문을 입력**해 다듬을 수도 있다. **코멘트 전체 또는 선택 영역** 대상. **Where:** Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Agentforce for Service와 Einstein for Service가 모두 활성**. **Who:** **Prompt Template User** 권한 세트. **How:** ① 조직에 Einstein 켜기 ② Prompt Builder에서 기본 제공 **Refine Case Comment** 템플릿의 지시문 검토·편집 ③ **Support Settings**에서 **Agentforce Writing Tools for Case Comments** 선택 → 담당자는 편집기에서 **Revise** 또는 **Refine with Instructions** 클릭 후 제안 텍스트를 **수락·거부한 뒤 게시** |
| **Easily View Original Case Attachments Inline in Case Details**<br>`rn_cases_easily_view_original_case_attachments` | 원본 첨부가 **Case Description 필드 바로 아래 인라인**으로 표시(버튼 클릭·사이드 패널 불필요). 원본 첨부 = **최초 케이스 생성 시간대에 이메일 제목 또는 케이스 설명에 추가된 파일**. **Where:** Lightning Experience · **Essentials·Group·Professional·Enterprise·Performance·Unlimited·Developer**(이 절에서 에디션 범위가 가장 넓다). **How:** **Support Settings의 `Show Original Case Attachments` 체크박스**를 켠다. 표시 규칙 전수: **인라인 타일은 최대 3개** · 3개를 넘으면 **`+ [X] more` 링크**로 popover가 열리고 **한 번에 최대 5개**씩 스크롤 표시 · popover 하단의 **View All Attachments** 버튼으로 케이스 관련 목록의 전체 파일 이력으로 이동 |
| **Simplify Case Merging with the Revamped Case Merge UI**<br>`rn_cases_enhanced_case_merge_updated_ui` | 통합 설정 페이지에 **Case Merge · Enhanced Case Merge (Beta) · Case Merge for Omni-Channel (Beta)** 를 모았다. **Enhanced Case Merge (Beta)는 Duplicate Rules·Matching Rules 접근을 제공.** **기존 중복 탐지·매칭 로직은 그대로 적용된다.** 통합 페이지에서 할 수 있는 일 전수: 세 기능 각각 켜기/끄기 · **병합 후 중복 케이스를 보존할지 삭제할지 지정** · 해당 중복 케이스의 **기본 상태(예: Closed) 설정** · Duplicate Rules·Matching Rules 열어 중복 탐지 구성 · **요구에 맞는 커스텀 케이스 상태 생성**. **Where:** Lightning Experience · Enterprise·Performance·Unlimited·Developer. **How:** Setup → Quick Find에 **Case Merge** → **Enhanced Case Merge (Beta)** 토글 활성화 → 중복 케이스 상태 기본값·Duplicate Rules·Matching Rules 구성 |

### Entitlements and Milestones

**Reduce Storage Bloat and Keep Records Clear by Deleting Outdated Case Milestones** (`rn_entitlements_deleting_outdated_case_milestones`) — **Data Loader 또는 Apex**로 케이스 마일스톤을 일괄 삭제해 데이터 저장 용량 회수. 이전엔 마일스톤 레코드가 케이스에 **무한 누적**되며 지원되는 삭제 수단이 없어 대량 조직의 저장 비용이 올라갔다. 케이스가 재분류돼 이전 마일스톤이 무의미해진 경우 등에 사용.

- **Where:** **Lightning Experience와 Salesforce Classic 양쪽** · **Professional·Enterprise·Performance·Unlimited·Developer**
- **How:** 관리자가 **Data Loader 또는 Apex로 직접 삭제**한다 — 전용 UI가 아니다

### Knowledge

| 항목 | Where / How |
|---|---|
| **Reuse Modular Content Across Articles with Knowledge Blocks** | **Professional·Enterprise·Performance·Unlimited·Developer + Salesforce Knowledge 애드온 라이선스.** 법적 고지·회사 주소 같은 재사용 콘텐츠를 한 번 만들어 **관리형 읽기 전용 블록**으로 문서에 삽입. **블록의 새 버전을 게시하면 그 블록을 쓰는 모든 문서에 자동 반영.** 이점 3가지(원문): 반복 콘텐츠 단일 관리 · 작성자에게 일관된 단일 진실 소스 제공 · **전 변경 이력(full version history)** 으로 감사 추적. Setup → **Enhanced Knowledge Settings** → Knowledge Blocks 켜기 |
| **Create Knowledge Articles from Any Record with Custom Prompt Templates** | **Professional·Enterprise·Performance·Unlimited·Developer + Salesforce Knowledge 애드온 라이선스.** 케이스·인시던트·작업 지시 등 **모든 레코드**에서 문서 초안 작성. Prompt Builder에서 평문 지시문 + 병합 필드로 **여러 커스텀 프롬프트 템플릿** 작성. 레코드에서 직접 또는 앱 어디서나 **Agentforce 대화형**으로 생성. 이전엔 Einstein Knowledge Creation이 **케이스·메시징 세션에 한정된 기본 템플릿 1개**만 제공했다. Setup → Einstein Knowledge Creation 켜기 → **Prompt Builder Template** 켜기 → Prompt Builder에서 **Knowledge Generation 템플릿 타입** 선택·grounding 레코드/입력 구성·활성화 |
| **Prevent Duplicate Articles with Knowledge Similarity** | **Enterprise·Performance·Unlimited·Developer + Knowledge 애드온 라이선스**(Professional 미포함 — 위 두 기능과 에디션 범위가 다르다). 초안 작성 시 유사 문서를 **백분율 유사도 점수**와 함께 노출. Setup → **AI Knowledge Settings** → Knowledge Similarity 켜기 → **Agentforce Data Library에 연결**해야 기존 지식 베이스와 비교 가능 |

### HR Service

| 항목 | 내용 |
|---|---|
| **Automate HR Workflows with Prebuilt HR Agents**<br>`rn_hr_svc_prebuilt_hr_agents` | 사전 구축 Agentforce 라이브러리를 **급여(payroll)·보상(compensation)·근무시간과 스케줄(time and scheduling)·온보딩** 에이전트로 확장하고 **goals management**를 개선. 직원은 대화로 **급여명세·total rewards 조회, 스케줄·출퇴근 이력 확인, 가이드형 온보딩 과제 완료**를 한다. 에이전트는 **로스터 리스크를 표시**하고 **shift swap 대상 직원을 매칭**한다. **각 에이전트는 사전 구축된 MuleSoft for Flow 커넥터로 기존 HR 시스템에 연결**된다. **Where:** Lightning Experience · **Enterprise·Performance·Unlimited** + **Agentforce HR Service**. **Who:** **Unified Employee License + Agentforce 권한 세트 라이선스 + 애드온 2종(Agentforce Employee Agent · Employee Hub HR Service Workspace)**. **How:** App Launcher → **Agentforce Studio** → **New Agents** → 필요한 에이전트 선택 → 활성화 후 직원은 **Salesforce 채팅 인터페이스나 Salesforce 모바일 앱**에서 사용 |
| **Deploy HR Workflows Faster with Added Service Templates to Your HR Workflow Library**<br>`rn_hr_svc_workflow_templates` | HR Service 워크플로 라이브러리에 **템플릿 5종** 추가 — 원문 예시: **shift swap · timecard correction · direct deposit update**. 요청을 올바른 시스템으로 라우팅하고 해결까지 추적하므로 **밑단 케이스 로직을 직접 만들 필요가 없다**. **Where:** Lightning Experience · Enterprise·Performance·Unlimited + **Agentforce HR Service 및 Unified Catalog**. **Who:** 배포·관리 관리자·서비스 프로세스 설계자 = **Agentforce HR Service 라이선스** / 사용자 = **Employee Hub Unified Employee User 라이선스**. **How:** **Unified Catalog 앱**의 **Templates 탭** → 템플릿 선택 → 상세 검토 → **Install** |
| **Protect Confidential Cases with Case Visibility Policies**<br>`rn_hr_svc_cnfd_case_policy_engine` | **Policy Engine**으로 case 오브젝트에 직접 가시성 규칙을 정의. 배포되면 기밀 케이스 접근이 **① 케이스를 등록한 사람 ② 케이스가 배정된 큐의 멤버 ③ case team에 추가된 사용자 ④ HR Case Investigator 커스텀 권한 보유자** 로 제한된다. 이전엔 기밀 케이스 등록에 **public complaint case junction 엔터티**가 필요했으나 이제 **case 오브젝트만으로** 처리한다. **Where:** Lightning Experience · **Unlimited·Performance·Enterprise** + HR Service. **기밀 케이스 생성은 Employee Service Aura 사이트와 Unified Portal(LWR) 사이트에서 지원**된다. **Who:** 정책을 배포하는 관리자에게는 **커스텀 필드 생성 권한과 case 레코드 레이아웃 편집 권한**이 필요하다. **How(전수):** 관리자가 ① 커스텀 필드 생성 ② case 레코드 레이아웃에 필드 추가 ③ Setup의 **Employee User Settings** 페이지 카드에서 정책 배포(**커스텀 권한은 정책과 함께 자동 배포**) ④ 기밀 케이스 라우팅을 위해 **기밀 큐를 구성하고 그 커스텀 필드 기반 case assignment rule 설정**. **Employee Service Aura 사이트**는 레이아웃에 필드를 추가하면 기밀 케이스 컨트롤이 자동 표시되고, **Unified Portal 사이트**는 **플로우에 커스텀 필드를 추가**해야 기밀 잠금 체크박스가 나타난다. **⚠️ 정책은 관리자가 켜기 전까지 기본적으로 꺼져 있다** |

### Self Service

| 항목 | 내용 |
|---|---|
| **Set Up Your Agentic Portal Faster with a Guided Setup Wizard**<br>`rn_set_up_your_agentic_portal_faster_with_a_guided_setup_wizard` | Salesforce Go → 사이트 생성 → 기능 구성 → 컴포넌트 설정 → 검토 → **원클릭 배포**. 마법사 안에서 Agentforce Customer Service Portal 에이전트 또는 Help 에이전트를 선택/생성하고, Enhanced Chat 설정·Knowledge 페이지 추가·개인화 및 data graph 옵션 선택을 끝낸다. **조정할 때마다 라이브 프리뷰가 갱신**되고 **각 단계에서 레코드가 점진적으로 생성**된다. **Where:** **Aura 및 LWR Experience Cloud 사이트**(Lightning Experience 경유) · **Enterprise·Performance·Unlimited·Developer**. **How:** **Salesforce Go 페이지의 Agentic Portal 카드**에서 시작하면 **필요한 권한·환경설정·권한 세트 라이선스가 한 번에 활성화**된다 → 사이트 이름·URL 입력해 사이트 생성 → 기능을 인라인으로 구성 → **Personalized Greetings · Suggestion Themes · Chat History · Unified Catalog Actions** 같은 컴포넌트를 라이브 프리뷰 패널과 함께 설정 → 검토 후 원클릭 배포, 또는 **Edit in Builder Mode** 로 고급 편집 |
| **Deploy Messaging Automatically During Agentic Portal Setup**<br>`rn_deploy_messaging_automatically_during_agentic_portal_setup` | Agentic Portal 설정 중 시스템이 **Enhanced Chat(구 Messaging for In-App and Web)** 을 자동 프로비저닝·배포해, 설정이 끝나는 즉시 포털 에이전트가 사이트에서 동작한다. **Where:** Aura 및 LWR Experience Cloud 사이트 · Enterprise·Performance·Unlimited·Developer. **How:** **Agentic Portal 가이드 설정의 일부로 자동 실행 — Messaging Channels·Embedded Service Deployments를 따로 구성할 필요가 없다** |
| **Reach Customers with In-App Notifications for Proactive Service**<br>`rn_reach_customers_with_in_app_notifications_for_proactive_service` | 이메일에 더해 **모바일 in-app 알림**으로 선제 서비스 아웃리치. **Salesforce Mobile Publisher**로 만든 모바일 앱 대상(예: 연결된 기기의 동반 앱). **원문이 밝힌 배경: 260 릴리즈 기준으로 아웃리치 채널은 이메일뿐이었다.** **Where:** Aura 및 LWR Experience Cloud 사이트 · Enterprise·Performance·Unlimited·Developer. **How:** 알림은 **Universal Notification Service와 Salesforce Mobile Publisher의 알림 인프라**로 전달된다 — proactive service 시나리오를 구성할 때 **in-app notification을 fulfillment 채널로 추가** |
| **Guide Customers Through Troubleshooting Steps with a Reusable Action**<br>`rn_guide_customers_through_troubleshooting_steps_with_a_reusable_action_pilot` | 시나리오마다 별도 Agentforce 토픽·액션을 만들지 않고 **범용 트러블슈팅 액션** 하나로 처리. **지식 문서 + 요약된 케이스 이력에 grounding**해 단계별 해결 절차를 제시하고, **대화형 확인(interactive confirmation)** 으로 고객이 Agentforce Service Agent 대화 안에서 자기 속도로 진행한다. **Where:** Aura 및 LWR Experience Cloud 사이트 · Enterprise·Performance·Unlimited·Developer. **⚠️ Who: guided troubleshooting 파일럿에 등록된 조직만 사용 가능**(원문: *"available to orgs enrolled in the guided troubleshooting pilot"*) — 제목에는 마커가 없지만 **본문이 파일럿임을 밝힌 항목**이다. **How:** proactive service 시나리오 설정 시 전용 토픽·액션을 구성하는 대신 **트러블슈팅 액션을 트리거하는 프롬프트를 지정**한다 |
| **Set Up a Help Agent in One Guided Workflow**<br>`rn_set_up_a_help_agent_in_one_guided_workflow` | Service Cloud Help Agent 설정에 필요한 **에이전트 구성·지식 grounding·Enhanced Chat 배포·에스컬레이션 라우팅·테스트**를 **`service-helpagent-coordinate` 스킬**이 하나의 가이드 워크플로로 묶는다 — 도구를 오가지 않고 동작하는 Help Agent를 구성·배포. **Where: Service Cloud.** 스킬은 **Salesforce Skills 레포지토리에 접근할 수 있는 지원 AI 코딩 환경에서 실행**된다. **When: 스킬은 2026년 7월 31일부로 Salesforce Skills 레포지토리에서 제공.** **Who:** Help Agent를 설정하는 관리자·개발자. **How:** 지원 AI 코딩 환경에서 스킬을 실행하고 프롬프트에 답해 에이전트·지식 소스·Enhanced Chat·에스컬레이션 라우팅·**preflight check**를 구성 |

> **Platform으로 위임:** `rn_messaging_platform_events_section`(Platform Events — Event Studio가 **편집 가능한 Platform Events Subscriber Config**를 노출, 라벨은 *Apex Trigger Details*)은 Clouds 추출 배치에 섞여 들어온 **Platform 소관** 항목이다 → [[Winter '27/Platform]]. 이 노트는 메커니즘을 다시 서술하지 않는다.

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

> 이 노트 상단 **`### 등급 마커 일람`** 표에 이 51건이 한 건도 올라가지 않는 이유가 이것이다. **본문까지 확보했는데도 마커가 0건**이므로 "등급 미상"이 아니라 **"원문에 등급 표시가 없는 표준 항목"** 으로 읽어야 한다.

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

### 이 절을 읽는 법 — Where 패턴 5종

Marketing Cloud Next 리프의 Where 문장은 몇 가지 정형으로 반복된다. 아래 표에서는 **약칭**으로 부르고, 벗어나는 항목만 행에서 직접 밝힌다.

| 약칭 | 원문 Where |
|---|---|
| **[MCN-공통]** | Salesforce **Enterprise·Unlimited** 에디션 + 다음 중 하나 — **Marketing Cloud Next Growth·Advanced**(+ Salesforce Foundations 애드온) / **Marketing Cloud Account Engagement Growth·Plus·Advanced·Premium**(+ Foundations) / **모든 Marketing Cloud Engagement+ 에디션**(+ Foundations) |
| **[MCN-공통+SMS]** | 위와 같되 **Salesforce Foundations 및 SMS 애드온** 둘 다 필요 |
| **[MCN-상위]** | Salesforce Enterprise·Unlimited + **Marketing Cloud Next Advanced 에디션**(Growth 제외) / **MCAE Plus·Advanced·Premium**(Growth 제외) / 모든 MCE+ 에디션 — 각각 Foundations 애드온 |
| **[MC-G/A]** | Salesforce Enterprise·Unlimited + **Marketing Cloud Growth 및 Advanced 에디션** |
| **[MC-Adv]** | Salesforce Enterprise·Unlimited + **Marketing Cloud Advanced 에디션만** |

> **[MCN-상위]가 따로 있는 이유:** 세 항목(`rn_mktg_add_fields_records_marketing_objects` · `rn_mktg_reach_whatsapp_usernames` · `rn_mktg_agentforce_AMGA`)은 **Growth 계열을 명시적으로 제외**한다 — [MCN-공통]으로 뭉뚱그리면 자격을 잘못 넓히게 된다.

### Marketing Cloud Next — Agentforce 신규 에이전트 2종

| 에이전트 | 내용 |
|---|---|
| **Run Self-Optimizing Campaigns with Agentforce Marketing Goals Agent**<br>`rn_mktg_agentforce_AMGA` | 고객 개인별로 **캠페인·채널·콘텐츠·타이밍**을 선택하는 자기 최적화 캠페인. 마케터는 에이전트의 동작을 **완전히 가시화**하고 **자율 처리 범위를 직접 정의**한다. **Where: [MCN-상위].** **How:** 마케터가 커스텀 콘텐츠를 만들 수 있게 하려면 **신규 Agentforce Content Agent를 설정하거나 임의의 CMS 콘텐츠를 사용**한다 → 마케터가 고를 수 있도록 **해당하는 캠페인 목표 옵션을 모두 켠다**(**마케터는 캠페인당 목표 1개 선택**). **⚠️ 여러 캠페인에 동시에 적격한 개인에 대해 어느 캠페인이 최적인지 에이전트가 판단하게 하려면 AI 기반 `Adaptive Campaign Audiences (beta)` 기능을 별도로 설정해야 한다** |
| **Create Campaign-Ready Content Faster with Agentforce Content Agent**<br>`rn_mktg_agentforce_ACA` | **email·SMS·MMS·RCS** 캠페인용 개인화·온브랜드 콘텐츠와 이미지를 협업형 AI 작업공간에서 생성·다듬기·게시. **마케팅 브리프·고객 데이터·브랜드 가이드라인에 grounding**. **게시 전 팀 검토·승인** 가능. **Where: [MCN-공통].** **How:** 마케팅 앱에 **Agentforce Content Agent 내비게이션 항목 추가** → 작업공간을 만들고 캠페인을 설명하는 프롬프트 입력 → 대화를 이어가며 톤·메시지·이미지 수정(레이아웃·텍스트·**하위 코드까지 수동 편집 가능**) → **Salesforce CMS로 바로 게시**하면 Marketing Cloud Next와 Agentforce Marketing Goals Agent 캠페인에서 사용 |

### Campaigns and Flows

| 항목 | 내용 |
|---|---|
| **Automate Follow-Up Tasks with Marketing Completion Actions**<br>`rn_mktg_marketing_actions` | 완료 액션으로 플로우 구성 시간 단축(예: 사용자 알림, 리드를 특정 사용자·큐에 배정). 이전엔 결과마다 **별도 플로우 로직**을 구성했다. **Where: [MCN-공통]. When: 2026년 8월부터.** **How:** Flow Builder에서 요소를 넣을 위치의 **+** → **Elements → Action → Marketing Completion Actions** |
| **Keep Tabs on Campaign Content and Performance Metrics**<br>`rn_mktg_campaigns_overview` | 채널을 가로지르는 **캠페인 개요** 뷰. 개요→상세로 내려가며 콘텐츠별 사용 이력 추적. **Where: [MCN-공통].** **How:** **캠페인 레코드를 떠나지 않고** 핵심 성과 지표와 마케팅 콘텐츠 상태를 본다. **⚠️ 원문 How는 화면 요소를 (1)·(2) 번호로 가리키는 캡처 설명이다 — 원문에 스크린샷이 있고 이 위키는 텍스트 설명만 옮긴다** |
| **Use Custom Flow Templates from a Campaign**<br>`rn_mktg_flow_templates` | 캠페인 레코드의 **Browse Templates** 로 커스텀 플로우 템플릿을 선택하면 플로우 생성과 캠페인 연결이 **원클릭**. 이전엔 플로우와 캠페인을 따로 만들고 수동 연결해야 했다. **Where: [MCN-공통]** |

### Email and Messaging

| 항목 | 내용 |
|---|---|
| **Test Personalized Content as Any Recipient**<br>`rn_mktg_preview_test` | **list·individual·campaign** 수신자 타입 × **email·SMS·WhatsApp·mobile app·RCS** 로 미리보기·테스트 확대. **activation·이벤트·Salesforce 레코드·Apex 클래스**의 샘플 Apex 입력과 콘텐츠 변수 값으로 검증하고, **렌더된 JSON 출력을 직접 검토·편집**해 발송 전 오류 수정. **Where: [MCN-공통]** |
| **Fix Tracked Links with Post-Send Link Editing**<br>`rn_mktg_email_fix_tracked_links` | **Salesforce 고객지원이 내부 도구로** 발송 완료 이메일의 추적 링크 목적지 URL을 갱신한다(**마케터가 직접 하는 기능이 아니다**). 재발송·엔지니어링 우회 불필요. 변경은 **해당 게시 콘텐츠 버전의 모든 발송에 적용**되고 **약 5분 내 이후 클릭부터 반영**. **병합 필드가 포함된 링크는 하나의 정적 URL로 리디렉션**된다. 모든 편집은 **사용자·타임스탬프·이전/이후 값**으로 감사 기록. **Where: [MCN-공통]** |
| **Localize Emails Faster with Built-In Language Variants**<br>`rn_mktg_translate_variants` | Email Builder에서 레이아웃을 깨지 않고 다국어 콘텐츠 관리. **내장 에이전트로 번역**한 뒤 component·code·text 뷰에서 변형별로 다듬는다. **Where: [MCN-공통].** **How:** Email Builder 사이드바에서 **Language Variants 패널**을 열고 언어를 선택해 **제목 줄(subject line)까지** 미리보기·편집 → 캔버스 헤더의 **Translate Variant** 로 내장 content agent 번역 생성 → **Code View**에서 언어 변형별 속성·커스텀 스타일 조정. **⚠️ 원문에는 독일어 변형이 선택된 Language Variants 패널 figure가 있다 — 이 위키는 텍스트 설명만 옮긴다** |
| **Choose the Best Image with Recommenders**<br>`rn_mktg_choose_with_recommenders` | **objective-based Recommender** 가 수신자 프로필·인게이지먼트 이력으로 발송 시점에 **직접 정의한 이미지 풀**에서 최적 파일을 선택. **오픈·클릭으로 계속 학습**해 이후 선택 개선. **Where: [MCN-공통]** |
| **Fix Email Deliverability Problems with Step-by-Step Guidance**<br>`rn_mktg_email_deliverability` | 전달률 지표가 악화되면 **Recommendation Details 패널**이 근본 원인·영향받은 캠페인·**영향도 순으로 번호 매긴 개선 단계**를 제시 — 지원 케이스를 열거나 전달률 전문 지식 없이도 해결. **⚠️ Where가 [MCN-공통]이 아니다:** Salesforce Enterprise·Unlimited + **Marketing Cloud Next Growth·Advanced 에디션**(MCAE·MCE+ 경로 없음) |
| **Monitor Email Deliverability Health and Receive Automatic Alerts**<br>`rn_mktg_monitor_email_deliverability` | **0–100 Email Deliverability Health Score** + 주요 지표가 warning·critical 구간에 들어가면 자동 알림. 대시보드가 이슈와 영향받은 캠페인을 표시해 **메일박스 사업자가 필터링을 시작하기 전에** 대응. **Where: [MCN-공통]** |
| **Archive High-Volume Emails in Your Own Cloud Storage**<br>`rn_mktg_email_archiving` | 발송된 마케팅 이메일 사본을 **Data 360을 통해 Amazon S3 또는 Microsoft Azure** 스토리지에 저장. **대량 발송자가 Salesforce Archiving 처리량 상한(throughput ceiling)에 걸리지 않고** 모든 발송 사본을 보관하고, 자체 일정으로 조회·회수. **Where: [MC-Adv]** |
| **Route Outbound Emails Through Your Own Mail Servers**<br>`rn_mktg_email_relay` | 공용 인터넷 대신 **자체 메일 서버로 라우팅**해 컴플라이언스 요구 충족. email relay 구성 + 발신 도메인 배정 + IP 승인. relay가 **bounce·reply·complaint 를 포함한 전체 전달 라이프사이클을 지원**해 전달률 유지. **Where: [MC-Adv]** |
| **View an Email as a Web Page**<br>`rn_mktg_view_email_as_web_page` | 보안 웹 버전 링크 추가. 개인화된 링크는 **발송 시점에 브랜드 도메인으로 해석**된다. **Where: [MCN-공통]** |
| **Archive Outbound Emails with Compliance BCC**<br>`rn_mktg_email_compliance_bcc` | 모든 발신 이메일 사본을 지정 주소로. **Where: [MC-G/A].** **How:** Setup → **Unified Messaging** → **Compliance BCC** → BCC 이메일 주소 입력 후 BCC 켜기. 선택적으로 **캠페인 수준 오버라이드를 허용**하면 마케터가 플로우의 특정 발송에서 BCC를 끌 수 있다 |
| **Skip the Wait When Sending Emails to Contact and Lead Lists**<br>`rn_mktg_list_sends` | Contact·Lead 리스트로 프로모션·트랜잭션·릴레이셔널 이메일 발송. **이전엔 리스트 발송에 Data 360 세그먼트 생성이 필요해 지연과 간헐적 발송 실패가 있었다** — 이제 **Actionable Lists**가 Contact·Lead 리스트에서 직접 오디언스를 처리해 **세그먼트 생성 자체를 건너뛴다**. 초기 메시지 구성과 오디언스 선택이 **한 페이지**로 통합. **⚠️ Where가 이 절에서 유일하게 Suite 계열이다:** Lightning Experience — **Free Suite · Starter Suite · Pro Suite · Foundations · Marketing Cloud Growth · Marketing Cloud Advanced**. **When: 8월 중순부터.** **How:** Marketing 앱에서 Leads 또는 Contacts에 필터를 적용해 수신자를 고르고 **Send Email**. **에디션별 차이 2가지:** ① **Free Suite는 이메일이 즉시 발송**되고, Starter·Pro·Foundations·Marketing Cloud 에디션은 **예약 발송 옵션**이 추가된다 ② 진입점이 다르다 — Free·Starter·Pro·Foundations는 **Marketing Home**에서, Marketing Cloud 에디션은 **Contacts·Leads 리스트뷰**에서 List Sends에 접근 |

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
| **Reach WhatsApp Recipients with Usernames via Business-Scoped User IDs**<br>`rn_mktg_reach_whatsapp_usernames` | WhatsApp 사용자가 사용자명으로 전화번호를 숨겨도 연속성 유지. **BSUID로 컨택 임포트**, 전화번호가 없을 때 아웃바운드 발송, **두 식별자 모두에서 인게이지먼트 추적**. Meta의 BSUID는 **username privacy를 켠 사용자**를 식별한다. **Where: [MCN-상위]** |
| **Answer Unmatched Inbound SMS and WhatsApp Messages with a Default Response**<br>`rn_mktg_sms_whatsapp_default_response` | 동의 요청·진행 중 대화·플로우 키워드 매칭 어디에도 해당하지 않는 인바운드에 **기본 응답 자동 발신**. 다음 단계로 유도하는 폴백 메시지를 정의하거나, **요청하지 않은 메시지에 아예 응답하지 않도록** 선택할 수도 있다. **Where: [MCN-공통+SMS]** |
| **Send High Throughput Flash Messages to Targeted Mobile Audiences**<br>`rn_mktg_flash_audiences` | **90초에 최대 500만 건**. 기기 등록 시 **정치·스포츠 관심사 같은 커스텀 속성으로 세그먼트**해 구독시키고, 발송 시 타깃 오디언스를 선택. **Where: [MC-Adv]** |

### Content Management (`rn_mktg_content_management` 허브 + 리프 전수)

| 항목 | 내용 |
|---|---|
| **Delete Content and Folders in Bulk in Marketing Workspaces**<br>`rn_mktg_content_bulk_delete` | 폴더와 콘텐츠를 **게시된 콘텐츠까지 포함해** 일괄 삭제. **이전엔 콘텐츠 상세 페이지에서 미게시 콘텐츠를 한 번에 하나씩만** 삭제할 수 있었다. **Where: [MCN-공통]** |
| **Monitor Performance of Content Blocks with Impression Region Tracking**<br>`rn_mktg_impression_region_tracking` | 콘텐츠 안에 **impression region**을 정의해 특정 선택이 인게이지먼트에 미치는 영향을 측정(예: 한 문단의 성과, 같은 버튼의 문구 두 변형 비교). 추적 영역용 **커스텀 리포트** 생성 가능. **지표 전수: 발송당 impression region 수 · 영역별 총 클릭과 고유 클릭 · 영역별 클릭률.** **Where: [MCN-공통].** **How:** 지원되는 콘텐츠 블록에서 Impression Region Tracking을 켜고 **클릭·발송 이벤트 데이터에 나타날 영역 이름**을 입력. 또는 콘텐츠 편집기의 **code view**에서 **Handlebars·AMPscript로 영역 정의** — **email · SMS · RCS · WhatsApp · Mobile App** 메시지에서 사용 |
| **Personalize Content in Channels with Scripting Support**<br>`rn_mktg_scripting_in_channels` | **AMPScript·Handlebars 스크립팅**으로 **SMS · WhatsApp · RCS · in-app · push** 메시지의 동적 콘텐츠 구성. 각 채널 빌더의 텍스트 영역에 스크립트 표현식을 직접 입력하고 **개인화 문자열·data extension 필드**를 참조. **Where: [MCN-공통]** |
| **Build Personalization Once and Reuse It Across Every Channel**<br>`rn_mktg_reuse_personalization` | 데이터 소스 접근·표현식 작성·동적 콘텐츠 블록 생성을 **한 번** 하고 Content Builder의 **SMS·WhatsApp·RCS·push·in-app** 에서 재사용. **Data Sources 탭**이 Salesforce 레코드·data graph·offer·Apex·이벤트·activation을 **Inputs · Data · Expressions** 로 정리해 어느 채널에서든 같은 방식으로 찾아 적용한다. **개인화 토큰과 동적 콘텐츠 블록은 같은 수신자에 대해 채널이 달라도 같은 값으로 해석된다.** **Where: [MCN-공통]** |
| **Keep Your AI Agents and Teams on Brand with Brand Center**<br>`rn_mktg_brand_kits` | **Brand Center**에서 브랜드 정체성·보이스·톤·비주얼 스타일의 **단일 진실 소스(unified brand kit)** 구축. **활성화하면** 에이전트와 콘텐츠 제작자가 모든 상호작용을 브랜드 표준에 grounding한다. **content syndication을 통해 brand kit이 전역에서 사용 가능**해 Salesforce의 어느 workspace에서든 소비된다. **⚠️ Where: [MCN-공통]에 더해 Brand Center 애드온이 추가로 필요하다**(원문: *"with the Salesforce Foundations **and Brand Center** add-ons"*) |

### Landing Pages and Forms (`rn_mktg_landing_pages_forms` 허브 + 리프 전수)

라이선스: 아래 4건 전부 **[MC-G/A]**.

| 항목 | 내용 |
|---|---|
| **Manage Landing Page Site Configuration with Marketing Sites**<br>`rn_mktg_lp_marketing_sites` | **Marketing Sites 탭**에서 랜딩 페이지 사이트 구성을 직접 관리 — **Experience Builder를 열 필요가 없다**. 이 탭이 모든 마케팅 사이트를 보여주며 **로케일·언어·보안 설정·신뢰 스크립트 위치(trusted script locations)** 같은 사이트 수준 구성의 중앙 허브가 된다. **현재 설정은 자동 마이그레이션되므로 재게시한 페이지는 이전과 동일하게 보이고 동작한다** |
| **Personalize Landing Pages with Handlebars and AMPscript**<br>`rn_mktg_lp_handlebars_ampscript` | 이메일에서 쓰던 **Handlebars·AMPscript 로직을 랜딩 페이지에서 그대로** 실행. 콘텐츠 개인화·데이터 로직 실행·폼 데이터 수집을 **Lightning 웹 컴포넌트로 다시 만들지 않고** 처리 |
| **Build Landing Pages and Forms with Custom HTML**<br>`rn_mktg_lp_forms_custom_html` | 표준 컴포넌트를 넘어 **커스텀 HTML**로 폼·랜딩 페이지 작성. **저장 전에 시스템이 HTML을 검증하고 안전성 검사를 수행**해 안전하지 않은 코드가 게시되지 않게 한다 |
| **Connect Forms and Landing Pages to More Data Sources**<br>`rn_mktg_connect_lp_forms_data_sources` | 폼·랜딩 페이지 안에서 더 다양한 데이터 소스를 **읽고 쓴다**. 폼은 **core object · marketing object · prospect data** 에서 데이터를 가져오고 제출물을 저장할 수 있어 필드 개인화와 응답 라우팅이 가능하고, 랜딩 페이지는 이들 소스와 **data graph**에서 정보를 끌어와 방문자별 경험을 구성한다 |

### Distributed Marketing and Alerts (`rn_mktg_dm_alerts` 허브 + 리프 전수)

> **Where가 이 절만 다르다.** 원문 공통형: Salesforce Enterprise·Unlimited + **Marketing Cloud Next Growth·Advanced**(**Data 360 접근** + **Distributed Marketing and Alerts 애드온**) / **MCAE Growth·Plus·Advanced·Premium**(Data 360 접근 + **Sales Emails and Alerts 애드온** + Distributed Marketing and Alerts 애드온) / **모든 MCE+ 에디션**(Data 360 접근 + Distributed Marketing and Alerts 애드온). 아래에서는 **[DM-공통]** 이라 부른다.

| 항목 | 내용 |
|---|---|
| **Define Content Requirements for Distributed Marketing and Alerts**<br>`rn_mktg_dm_required_phrases_character_limits` | 이메일 템플릿 설정 시 **승인된 문구를 필수로 지정**해 사용자가 발송 전에 하나를 고르게 한다. **잠금 해제된 텍스트 블록의 글자 수 상한**도 강제할 수 있다. **Where: [DM-공통]** |
| **Deliver Email Templates Faster to Non-Marketing Users**<br>`rn_mktg_dm_scheduled_flow_template` | **Distributed Marketing and Alerts 자동화 이벤트와 필요한 로직이 들어 있는 사전 구축 플로우 템플릿**에서 시작해 복잡한 수동 구성을 건너뛴다. **Where: [DM-공통]** |
| **Personalize and Send Distributed Marketing Messages at Scale**<br>`rn_mktg_dm_bulk_send_enhancements` | 일괄 발송 개선 **8가지 전수**: ① **캠페인 멤버·리드·컨택을 한 번에 최대 2,000건** 선택 ② 한 번의 발송에서 **여러 이메일을 각각 커스터마이즈** ③ 이전 발송의 콘텐츠 재사용 ④ **레코드 소유자를 대신해(on behalf of) 발송** ⑤ **actionable list의 수신자**에게 발송 ⑥ **임의의 data provider에서 채워진 병합 필드 미리보기** ⑦ 자동 저장된 이메일 콘텐츠를 **모든 workspace에 추가된 전용 `Distributed Marketing Messages` 폴더**에서 접근 ⑧ **Distributed Sends 대시보드의 Bulk Email Recipient Activity 뷰**로 개별 수신자와 인게이지먼트 추적. **Where: [DM-공통]** |
| **Find Recommended Templates Using the Distributed Marketing Agent**<br>`rn_mktg_dm_agent_recommended_templates` | 비마케팅 사용자가 **키워드로 추천 이메일 템플릿을 검색**하는 신규 에이전트 액션. **⚠️ Where가 [DM-공통]보다 더 좁다** — [DM-공통]의 각 경로에 **Salesforce Foundations 애드온**과 **Einstein for Sales·Einstein for Service·Einstein Platform 애드온 중 하나**가 추가로 요구된다 |

### Audiences · Marketing for Retail · Reporting

| 항목 | 내용 |
|---|---|
| **Build and Clone Marketing Lists Directly from Your Workflow**<br>`rn_mktg_actionable_lists` | **캠페인 레코드 또는 Actionable List 오브젝트 홈**에서 리스트 임포트. 기존 리스트를 **멤버까지 함께** 복제. **Where: [MCN-공통]** |
| **Automatically Update Consent Data in Record-Triggered Flows**<br>`rn_mktg_consent_flow_action` | 레코드 트리거 플로우에서 **Consent Request 플로우 액션** 사용. 원문 예시: 신규 리드를 특정 이메일에 **옵트인**, 연결된 opportunity가 종료되면 특정 커뮤니케이션 구독에서 컨택을 **옵트아웃**. **Where: [MCN-공통]** |
| **Gain More Control over Preference Page Design and Subscription Content**<br>`rn_mktg_consent_preference_pages` | **마케팅 채널별로** preference page를 구축·브랜딩·게시하고, 메시지↔페이지를 연결, 노출할 구독 제어, 버튼 텍스트·스타일 변경. **Where: [MCN-공통].** **How:** **Content 탭**에서 생성·편집·게시하며, 만든 페이지는 **Content 탭과 Consent 탭 양쪽에** 나타난다. 메시지에서 쓰려면 **병합 필드로 링크를 삽입** |
| **Launch Retail Journeys Faster with Welcome Series Triggers and Flow Templates**<br>`rn_mktg_launch_retail_journeys_faster_welcome_series` | 대표 리테일 유스케이스용 **사전 구축 트리거**와 관련 플로우 템플릿. **각 템플릿이 콘텐츠 + 플로우 + 수신 대상 규칙을 함께 제공**한다. **Where: [MC-G/A].** **How:** Setup에서 트리거를 구성·활성화한 뒤 마케터가 플로우 템플릿으로 자동 여정을 시작. **제공되는 트리거·템플릿 전수: Birthday · Anniversary · Visitor Conversion · Reengagement · Replenishment** |
| **Notify Shoppers About New Products in a Top Category**<br>`rn_mktg_notify_shoppers_new_products_top_category` | **New Product in High-Engagement Category** 트리거를 켜면 쇼퍼가 가장 많이 관여한 카테고리에 제품이 추가될 때 자동 발송. **Where: [MC-G/A]** |
| **Target Marketing Triggers More Precisely with New Configuration Options**<br>`rn_mktg_triggers_new_configuration_options` | 원문이 밝힌 정밀화 수단 5가지: ① **이탈(abandonment) 트리거의 비활성 기준**을 직접 정의 — **미구매 · 장바구니 활동 없음 · 웹사이트 활동 없음 · 제품 페이지 미방문** ② **lookback 기간에 해당 제품 또는 아무 제품이나 구매한 쇼퍼 제외**(재입고·재고 부족·가격 인하 메시지가 이미 전환한 고객에게 가지 않게) ③ **최소 제품 페이지 방문 횟수**로 고의향 쇼퍼 필터 ④ 하드코딩 기본값 대신 **커스텀 데이터에 맞춘 engagement 값** 구성 ⑤ **Contact Point DMO를 매핑**해 각 트리거가 아웃바운드에 쓸 수 있는 채널 결정. **Where: [MC-G/A]** |
| **Distribute Unique Coupon Codes in Your Marketing Messages**<br>`rn_mktg_distribute_unique_coupon_codes_marketing_messages` | 고유 쿠폰 코드 리스트를 만들어 **수신자 1인당 1코드**를 배정해 이메일로 전달. **Where: [MC-G/A].** **How:** Marketing 앱에 **Coupons 탭** 추가 → 쿠폰 리스트(**multi-code coupon**) 생성 후 **코드 CSV 업로드** → Content Builder에서 **Coupon data provider**로 그 리스트를 선택해 **쿠폰 코드 병합 필드**를 메시지에 삽입 → **발송 시점에 시스템이 리스트에서 코드를 배정**한다 |
| **Track SMS Flow and Engagement Metrics in Flow Builder**<br>`rn_mktg_sms_flow_metrics` | **Send SMS Message 플로우 요소**의 성과를 Flow Builder를 떠나지 않고 확인. 활성 SMS 플로우를 열고 **Analytics 탭** → 총 실행·평균 소요시간·**성공 대 오류 분해**, 그리고 **SMS 발송·전달률·클릭률·opt-out율**. **Where: [MCN-공통+SMS]** |
| **Measure Accurate SMS Click Rates with Bot Click Detection**<br>`rn_mktg_sms_bot_click_detection` | **Data Cloud의 human-verified / bot-generated 클릭 지표**로 사람 클릭과 봇 활동을 분리한다. 실제 사람이 링크를 탭했을 때만 반응하도록 **SMS·MMS 플로우를 구성**할 수 있다. **Where: [MCN-공통+SMS]** |
| **Track Mobile Push Performance in Your Content Performance Dashboard**<br>`rn_mktg_mobile_push_performance` | **Mobile Push 탭**에서 push 성과를 email·SMS·WhatsApp 데이터와 한자리에서 확인. KPI 카드는 **기간 대비 증감률(period-over-period percent change)** 을 함께 표시하고, **Platform 필터로 iOS/Android 비교**, Engagement 표를 **Date Range·Campaigns** 로 필터. **Where: [MCN-공통].** **Who: `View All Reports` 또는 `Dashboard Viewer` 권한**이 있어야 Content Performance Dashboard에 접근. **How:** 콘텐츠 레코드 → **Performance 탭** → **Mobile Push 탭** |

**Analyze B2B Marketing Impact with Ready-to-Use Dashboards** — **B2B Analytics for Marketers**가 account·opportunity·campaign·engagement·attribution 데이터를 **Tableau Next 대시보드**로 통합. ABM 성과·파이프라인 영향·캠페인 수익·딜 속도·어트리뷰션을 한 곳에서 검토.
**Where:** Salesforce Enterprise·Unlimited + **Marketing Cloud Next Growth·Advanced**(+ Salesforce Foundations 애드온) / **MCAE Growth·Plus·Advanced·Premium**(+ Foundations) / **모든 Marketing Cloud Engagement+ 에디션**(+ Foundations). **When: 2026-08-10부터.** **How:** Setup → **Marketing Cloud Assistant Home** 에서 구성.

### Setup and Admin · Development & APIs

| 항목 | 내용 |
|---|---|
| **Set Up Marketing Cloud Next in One Place with Salesforce Go**<br>`rn_mktg_go_setup_enhancement` | **Initial Setup 페이지**에서 마케팅 앱 설치·데이터 스트림 배포·선행 조건 완료·**Identity Resolution 구성**까지 — 여러 설정 화면을 오갈 필요 없음. **Channels · Einstein · Optimization · Analytics** 로 필터. **Where: [MCN-공통]** |
| **Centralize Your Web Tracking and Consent Banner Setup**<br>`rn_mktg_go_web_tracking` | Salesforce Go의 신규 페이지에서 랜딩 페이지·외부 사이트의 웹 트래킹 설정. 방문자 활동 추적 동의를 받는 **커스텀 배너** 생성. **Where: [MC-G/A].** **How:** Setup → **Salesforce Go** → **Marketing Cloud Next 탭** → **Track Marketing Engagement Across the Web** |
| **Extend Marketing Cloud Next Access to Platform Plus Users**<br>`rn_mktg_platform_user_license` | **Platform Plus 사용자 라이선스** 마케터가 캠페인 생성·이메일 발송을 포함한 **모든 마케팅 워크플로**를 수행. **Marketing Cloud Manager + Data 360 권한 세트**를 배정하면 캠페인·컨택·리드와 **30개 이상의 커스텀 오브젝트** 접근. **Where: [MCN-공통]** |
| **Add New Fields and Individual Records Easily to Marketing Objects**<br>`rn_mktg_add_fields_records_marketing_objects` | **Data Explorer**에서 마케팅 오브젝트에 필드를 추가하고 개별 레코드를 직접 입력. **비어 있는 오브젝트와 데이터가 있는 오브젝트 모두**에 필드 추가 가능하고 **기존 데이터에 영향 없이** 필드 속성 수정. 소수 레코드는 CSV 업로드 없이 직접 입력. **Where: [MCN-상위]. When: 2026년 8월부터.** **Who: `Manage Marketing Objects` 와 `Modify All Marketing Objects Records` 권한** |
| **Manage the Sales Data Kit Independently**<br>`rn_mktg_sales_data_kit` | sales data kit이 Marketing Cloud Next 설정에서 **선택적·온디맨드 컴포넌트**로 분리(이전엔 필수 마케팅 데이터 킷에 번들). 배포 여부·시점과 업데이트를 **독립 관리**. **Where: [MCN-공통]. When: 2026년 8월부터 순차(rolling) 제공.** **How:** Setup → Quick Find에 **Marketing Cloud** → **Basic Settings** → sales data kit 섹션에서 배포·상태 확인·업데이트 적용 |
| **Republish Your Marketing Cloud Next Landing Pages (Release Update)** | 랜딩 페이지가 구버전 인프라에 호스팅돼 있을 수 있다. **재게시하면 콘텐츠가 그대로 유지된 채** 현재 지원 인프라로 이동한다. **강제 시점 → [[Winter '27/Release Updates]]** |
| **Create and Manage Content Programmatically Using REST API**<br>`rn_mktg_development_apis_content` | Marketing Cloud Next **CMS의 모든 콘텐츠 타입**을 REST API로 생성·수정·검색. 채널: **Email · SMS · WhatsApp · Mobile App**. **비디오 콘텐츠·콘텐츠 블록·추적 링크·폼**도 관리. **Where: [MC-G/A]** |
| **Send Emails with Direct Email Send API**<br>`rn_mktg_development_apis_direct_email_send` | 한 명 이상 수신자에게 프로그래밍 방식 이메일 발송. **이전엔 API로 발송하려면 on-demand 플로우를 만들고 API로 그 플로우를 트리거해야 했다** — 이제 **email send definition**만 만들면 플로우 없이 발송한다. **Where: [MC-G/A].** **How:** ① 콘텐츠·발신 프로필·기능 구성을 담은 **email send definition** 생성 ② Direct Email Send API로 수신자 지정 → 미리보기 → 발송 |
| **Customize Content with Newly Supported AMPscript and Handlebars Functions**<br>`rn_mktg_development_apis_ampscript_handlebars_functions` | 마케팅 오브젝트에서 **rowset 구성·row 조회·row claim**, **정규식** 기반 개인화 로직, **MD5·SHA512 해시**(민감 콘텐츠 평문 발송 회피), **impression region** 생성으로 메시지 특정 영역 성능 모니터링. **Where: [MC-G/A]** |

### Marketing Cloud Account Engagement (MCAE)

**Disable Email Open and Click Tracking** (`rn_mcae_email_tracking`) — 진화하는 추적·프라이버시 규제 대응. **Account Engagement Settings 페이지에 비즈니스 유닛별 이메일 추적 설정 4종 신설** — **open · implied open · link · advanced metrics** 각각 활성/비활성 선택.

- **Where:** 이 설정들은 **모든 Account Engagement 에디션**에서 제공된다. 단 **Advanced Email Analytics 설정은 MCAE Plus·Advanced·Premium 에디션 + 애드온을 붙인 Growth 에디션**에서만 제공된다
- **When:** **open·link·advanced metrics 추적 설정은 2026년 7월부터**, **implied open 추적 설정은 2026년 8월부터** — 두 시점이 다르다
- **How:** Account Engagement Settings 페이지의 **Email Tracking 섹션**에서 항목의 선택을 해제하면 해당 비즈니스 유닛에서 그 추적이 꺼진다

**Next Gen Features** — MCAE 고객도 Winter '27 Marketing Cloud Next 기능군에 접근한다. 원문이 나열한 영역: Agentforce · Campaigns and Flows · Content Management · Email and Messaging · Distributed Marketing and Alerts · Channels · Landing Pages and Forms · Audiences · Reporting and Analytics · Setup and Admin · Development & APIs.

### Marketing Cloud Engagement (MCE)

**① Marketing Cloud Engagement+** (`rn_mce_parent_convergence` 허브)

| 항목 | 내용 |
|---|---|
| **Connect Marketing Cloud Engagement to Data 360 with Salesforce Go**<br>`rn_mce_go_setup` | 여러 설정 플로우를 오가지 않고 MCE 계정을 Data 360에 동기화. Salesforce Go가 **데이터 스트림 배포 → Marketing Performance Intelligence 설치 → 동의(consent) 매핑 → 사용자 접근 구성**까지 전 과정을 하나의 가이드 경험으로 통합. **Where:** Lightning Experience · Salesforce **Enterprise·Unlimited** + **Marketing Cloud Engagement+ 에디션** |
| **Reduce Duplicate Records with More Out-of-the-Box Match Rules**<br>`rn_mce_ootb_ir_mce` | MCE **Identity Resolution 룰셋**에 match rule 추가 — **퍼지 이름 매칭 + 정규화된 이메일·전화·주소 필드** 조합. 오타·서식 차이·다른 철자가 있어도 동일인 레코드를 식별한다. **Where:** Lightning Experience · Enterprise·Unlimited + **Marketing Cloud Engagement+ 에디션** |
| **Enable Two-Way Conversations for Marketing Cloud Engagement Emails**<br>`rn_mce_conversational_email` | 마케팅 이메일을 **양방향 대화**로. 수신자가 이메일에 바로 답장하면 **Agentforce 에이전트가 실시간 응답**한다. 기존 여정에 **conversational sender profile을 켜서** 대화 로직 추가. **인바운드 답장은 자동으로 스레딩**돼 맥락이 보존되고, 수신자가 사람 도움을 요청하면 **Omni-Channel 인박스의 담당자에게 라우팅**돼 같은 스레드에서 답한다. **Where:** Lightning Experience · Enterprise·Unlimited + **Marketing Cloud Engagement+ 에디션** |

**② Journey Builder and Automation Studio** (`rn_mce_parent_journeys` 허브)

- 허브 요약: Automation Studio 활동이 **대소문자와 무관하게** filename 치환 토큰 처리. **Journey Builder의 이메일 주소 중복 제거**로 중복 발송 방지. **Journey Notifications 대시보드**가 이슈·경고를 통합 표시.
- **Prevent Filename Errors with Case-Insensitive Date and Time Tokens in Automation Studio** (`rn_mce_prevent_filename_errors`) — **Data Extract·File Transfer** 활동이 filename 패턴의 치환 토큰을 **대소문자 무관**하게 인식한다. `%%Year%%` · `%%year%%` · `%%YEAR%%` 어느 쪽이든 파일명에 **리터럴 텍스트로 남지 않고** 올바로 해석된다. **이미 대소문자 무관 토큰을 지원하던 Import·Export 활동과 동작을 맞춘 것**이며 파일 생성·매칭 오류를 예방한다. **⚠️ Where:** **Marketing Cloud Engagement Corporate 및 Enterprise 에디션**(*"all editions"* 이 아니다)

**③ Messaging** (`rn_mce_parent_messaging` 허브)

| 항목 | 내용 |
|---|---|
| **Connect Multiple Marketing Cloud Accounts to One Data Cloud Instance for WhatsApp**<br>`rn_mce_connect_multiple_marketing_cloud_accounts_to_one_data_cloud_instance_for_whatsapp` | Unified Messaging에서 WhatsApp을 설정할 때, **Data Cloud 인스턴스에 연결된 어느 MCE 계정의 비즈니스 유닛에든** 전화번호를 연결할 수 있다. **하나의 Data Cloud 인스턴스와 하나의 WABA를 공유하면서 서로 다른 MCE 계정에서 각기 다른 WhatsApp 여정**을 운영. 이전엔 WhatsApp 설정 중 **다른 계정의 비즈니스 유닛에 전화번호를 배정할 수 없었다**. **Where: 모든 MCE 에디션** |
| **Reach WhatsApp Users with Usernames Using Business-Scoped User IDs**<br>`rn_mce_reach_whatsapp_usernames` | MCN 쪽 `rn_mktg_reach_whatsapp_usernames`의 MCE 버전 — BSUID로 컨택 임포트·아웃바운드 발송·두 식별자 인게이지먼트 추적. **Where: 모든 MCE 에디션**(MCN 버전의 [MCN-상위]와 다르다) |
| **Catch WhatsApp Direct Send Category Mismatches**<br>`rn_mce_category_mismatches` | WhatsApp **Direct Send utility 메시지가 marketing·authentication 으로 분류**됐을 때 Meta의 카테고리 피드백을 MCE가 노출해 **계정 제한 전에** 해소하게 한다. **Direct Send API에서는 템플릿 승인 경로를 타지 않고 Meta가 카테고리를 자동 배정**한다. **⚠️ Meta가 계정을 제한하면 MCE는 제한이 풀릴 때까지 Direct Send 템플릿 생성과 여정 활성화를 차단한다.** **Where: 모든 MCE 에디션** |

**④ Security** (`rn_mce_parent_security` 허브 + 리프 전수) — **Winter '27 MCE의 최대 변경 묶음**

| 항목 | 내용 |
|---|---|
| **Monitor the Security Posture of Your Account with the Security Dashboard**<br>`rn_mce_security_dashboard_view` | 계정 보안 설정의 단일 뷰 — **전체 health score**, 카테고리별 보안 요소, 우선 개선 항목. **브랜드가 적용된 PDF 리포트로 내보내** 이해관계자와 공유. **Where: 모든 MCE 에디션.** **Who: Marketing Administrator와 Marketing Security Administrator.** **How:** 해당 역할로 로그인 후 **Platform 메뉴 → Security Dashboard** |
| **Monitor Data Extension Access Events with Advanced Audit Trail**<br>`rn_mce_data_extension_access_monitor` | Advanced Audit Trail이 **사용자·API 소비자가 Data Extension의 데이터를 조회한 시점**을 기록한다(GDPR 등 데이터 프라이버시 규제 대응). 감사 로그로 **누가 언제 구독자 데이터에 접근했는지** 확인. **⚠️ Where: Advanced Audit Trail은 모든 MCE 에디션에서 추가 비용으로 제공되는 애드온이다 — 구매하려면 Salesforce 계정 임원에게 문의해야 한다**(원문: *"available in all Marketing Cloud Engagement editions for an additional cost. To purchase the add-on, contact your Salesforce account executive."*) |
| **Protect Against Phishing by Using Platform Authentication Systems**<br>`rn_mce_platform_authenticator_login` | **Apple의 Touch ID·Face ID, Windows Hello, passkey** 로 MCE에 로그인. 이들은 **피싱 저항 다중 인증(PR-MFA)** 으로 간주된다. MCE는 **Yubikey 같은 하드웨어 기반 장치 인증**도 지원한다. **Where: 모든 MCE 에디션. When: 플랫폼 기반 인증 지원은 2026-07-30부터 제공.** **⚠️ 향후 릴리즈에서 모든 MCE 계정은 플랫폼 인증 시스템 또는 하드웨어 인증 장치 중 하나로 MFA를 쓰도록 요구된다**(하드웨어 기반 인증 지원은 Summer '20부터 제공됐다) |
| **Configure Your Login Allowlist Based on Recommended IP Ranges**<br>`rn_mce_allowlist_recommended_ips_review` | MCE가 **최근 6개월간** 계정 로그인에 쓰인 IP를 추적해 allowlist용 **권장 범위**를 제시한다. **Where: 모든 MCE 에디션. When: 2026-07-30부터 제공.** **⚠️ 향후 릴리즈에서 모든 MCE 계정은 인식되지 않은 로그인을 전부 차단하도록 login IP allowlist 사용이 요구된다 — 요건 발효 전에 이 기능으로 allowlist를 채워두라는 것이 원문의 취지이며, 인스턴스별 강제 시점이 정해지면 이메일로 통지된다.** **How:** **상위(parent) enterprise 계정**에 Marketing Admin으로 로그인 → Setup → **Login IP Allowlist** 페이지에서 권장 범위 검토 → 범위 선택 후 **Accept Selected** |
| **Reauthenticate Using MFA for Security Tasks**<br>`rn_mce_step_up_authentication` | 계정 보안 설정 변경 같은 **중요 작업 시 Marketing Admin의 재인증(step-up)** 요구. **⚠️ 단일 로그인(SSO)을 쓰는 조직에는 적용되지 않는다.** **Where: 모든 MCE 에디션. When: step-up 인증은 2026-07-30부터 강제(enforced)됐다** |
| **Update Single Sign-On Accounts to Use MFA**<br>`rn_mce_sso_mfa_amr_acc` | SSO를 쓰는 계정은 **AMR(Authentication Method Reference)·ACC(Authentication Context Class Reference) 클레임을 갖춘 MFA**를 구현해야 한다 — IdP와 MCE 사이 최고 수준 보안. **Where: 모든 MCE 에디션. When: 현재 릴리즈에서는 강제되지 않으며, 향후 릴리즈에서 SSO를 쓰는 모든 계정에 요구된다.** **How:** IdP 공급자와 협업해 표준 충족 |
| **Prepare to Rotate Client Secrets for Installed Packages**<br>`rn_mce_client_secrets_rotate` | **⚠️ 2026-03-25 이후로 교체하지 않은 설치 패키지 client secret은 2026-09-30에 만료된다.** **2026-03-25 이후 생성된 모든 client secret은 생성일부터 180일 만료 주기**를 갖는다. 만료 며칠 전부터 **이메일 알림과 MCE 내 배너 알림**을 받는다. **Where: 모든 MCE 에디션.** **When:** 마지막 교체가 2026-03-25 이전이면 **2026-09-30 만료**, 그 이후에 교체했다면 **생성 후 180일** 만료. **이 변경은 Spring '26 릴리즈 노트에서 이미 예고됐다.** **How(무중단 교체 절차):** Setup → **Installed Packages** → 대상 패키지 열기 → **Staged Secret 섹션에서 Generate** → 그 패키지에 연결되는 **모든 클라이언트 앱을 staged secret으로 갱신** → 정상 동작 확인 후 **Activate** 를 눌러 staged secret을 활성화하고 이전 secret을 폐기. 이 **stage → test → activate** 과정이 다운타임 없는 교체를 가능하게 한다 |
| **Protect Your Integrations with Automatic Client Secret Revocation**<br>`rn_mce_compromised_secrets_revoke` | 계정의 API 통합과 관련한 특정 보안 위협이 감지되면 **설치 패키지의 client secret을 자동 폐기**한다. 원문 예: **client secret이 공개 저장소에 노출된 경우** → 폐기 + 관리자 이메일 통지 + MCE 내 알림 표시. **후속 보안 검토에서 유출이 아니라고 판명되면 자동으로 복원**된다. **⚠️ 기본 활성이며 관리자가 끌 수 없다**(원문: *"This feature is enabled by default. Admins can't turn it off."*). **Where: 모든 MCE 에디션** |
| **Review Client Secret Statuses on the Installed Packages Summary Page**<br>`rn_mce_installed_packages_summary_view` | Setup의 **Installed Packages 페이지**에서 패키지별 활성·staged client secret 상태를 검토. 요약이 보여주는 것: **폐기·만료 상태 · client ID · 마지막 인증 호출로부터 경과 일수.** **Where: 모든 MCE 에디션** |
| **Review New and Upcoming Security Requirements for Marketing Cloud Engagement**<br>`rn_mce_upcoming_security_requirements` | 최신 인증·로그인 요건 안내 페이지. **When: 강제 시점은 기능마다 다르다 — MCE의 Step-Up Authentication은 2026-07-30에 강제됐고, 나머지 요건은 시간을 두고 순차 강제된다.** 원문이 묶어 가리키는 요건 4가지: client secret 교체 준비 · 권장 IP 범위 기반 로그인 allowlist 구성 · **SSO 계정의 MFA 전환** · 플랫폼 인증 시스템 기반 피싱 방어. **Where: 모든 MCE 에디션** |

**⑤ Other Changes in Marketing Cloud Engagement** (`rn_mce_parent_other_features` 허브)

| 항목 | 내용 |
|---|---|
| **Provision and Secure Proxied Custom Domains for Your Sender Authentication Package**<br>`rn_mce_provision_secure_proxied_custom_domains_sender` | MCE로 직접 라우팅되지 않고 **프록시를 경유하는** Sender Authentication Package(SAP) 커스텀 도메인을 설정·보호. MCE가 호스팅하는 도메인에 프록시를 구성하면 **종단 간 연결성과 보안이 자동 검증**돼 수동 확인이 필요 없다. **⚠️ Where: MCE Pro+ · Corporate+ · Enterprise+ 에디션**(*"all editions"* 이 아니다) |
| **Prevent Import API Jobs from Importing Stale Data**<br>`rn_mce_import_maxfileagehours` | Data Import API 오퍼레이션의 **`maxFileAgeHours`** 파라미터로 **지정 기간 안에 생성·수정되지 않은 파일의 임포트를 차단**한다. 요청에 이 파라미터가 있으면 MCE가 파일의 수정 일시를 확인해 **현재 시스템 시각과의 차이가 최대 시간 수를 넘으면 임포트를 실행하지 않는다**. **타임스탬프를 정규화하므로 타임존이 달라도 파일 나이 계산에 영향이 없다.** **Where: API 접근이 있는 모든 MCE 에디션** |

**⑥ MCP 서버 확장 · Archived Release Notes**

| 항목 | 내용 |
|---|---|
| **Expand Marketing Operations Automation with New Tools for the MCP Server**<br>`rn_marketing_new_mcp_tools` | Model Context Protocol 서버에 **도구 40종 추가** — MCP 호환 AI 어시스턴트가 자연어로 MCE 운영을 수행한다. 이 도구들은 **코어 API 기능을 호출**한다. **Where: API 접근이 있는 모든 MCE 에디션.** 원문이 밝힌 **7개 영역 전수**: ① **Automations and activities** — file transfer·script(SSJS)·import·filter 활동의 생성·수정·실행·삭제, **FTP 파일 전송 위치 관리**, schedule·file-drop 트리거 활성/비활성 ② **Campaigns** — 캠페인 생성·조회·수정·삭제, 캠페인 자산 연결·해제 ③ **Bulk and async data** — data extension·data event에 **대량 upsert**, 비동기 대량 잡의 상태·결과 확인 ④ **Content Builder** — 폴더 생성·이름변경·이동·삭제, 사용 가능한 자산 타입 조회 ⑤ **Data Extensions** — **external key로 행 쿼리**(필터·페이지네이션 포함) ⑥ **Contacts** — **GDPR·CCPA 삭제 요청**을 위해 contact key로 컨택과 속성 삭제(개별·대량) ⑦ **Tracking** — **이벤트 타입별 이메일 추적 이벤트 조회** |
| **Archived Release Notes**<br>`rn_marketing_engagement_archive` | **Spring '24 이전** MCE 릴리즈 노트는 **PDF 다운로드**로 제공. Summer '24~직전 릴리즈는 툴바 드롭다운에서 릴리즈를 선택. 원문 권고: *"Engagement에 대한 가장 정확하고 최신인 정보는 릴리즈 노트가 아니라 도움말 문서를 참조하라."* **PDF 묶음 전수:** Spring '24 / Spring '23·Summer '23·Winter '24(2023 MCE) / Spring '22·Summer '22·Winter '23(2022 MCE) / Spring '22·Summer '22·Fall '22·Winter '23(2022 Marketing Cloud Intelligence) / Fall '22·Winter '23(2022 Marketing Cloud Intelligence Data Pipelines). **⚠️ 이 페이지에는 Where 문장이 없다** |

### Marketing Intelligence (`rn_mc_mi_marketing_intelligence` 허브 + 리프 전수)

> 원문 정의: *"Marketing Intelligence is a data and analytics platform that unifies marketing performance data and measures ROI across channels."* Winter '27은 **데이터 수집 확대·과거 데이터 백필·파이프라인/연결 모니터링·데이터 검증·AI 권고**를 더했다.
>
> **⚠️ 이 절의 리프 8건 중 Where 문장이 있는 것은 `rn_mc_mi_campaign_performance` 하나뿐이고, 그마저 에디션이 아니라 Beta 약관 고지다.** 나머지는 원문에 Where가 없다 — 에디션·라이선스를 추정하지 않는다.

**Data Management** (`rn_mc_mi_data_management` 허브)

| 항목 | 내용 |
|---|---|
| **Backfill up to a Year of Historical Data from API Connectors**<br>`rn_mc_mi_one_year_data_backfill` | 지원되는 API 커넥터에 대해 **요청 1건으로 최대 1년치 연속 과거 데이터**를 수집 — **30일 단위 반복 회수를 관리할 필요가 없다**. 자동 백필이 **데이터 청킹과 공급자 rate limit을 백그라운드에서 처리**해 전년 대비 분석과 머신러닝 모델용 데이터를 준비한다. **⚠️ 사용 가능한 기간 범위는 공급자마다 다르다.** **How:** Marketing Intelligence → **Data Management 탭** → 데이터 파이프라인 행의 드롭다운 → **Reprocess** → 기간 선택 |
| **Review Recent Pipeline Run Success Rates**<br>`rn_mc_mi_last_thirty_runs_column` | 신규 **Last 30 Runs 컬럼**이 파이프라인의 최근 30회 실행 중 성공 횟수를 보여준다. **최신 실행이 성공했더라도 데이터 신선도에 영향을 주는 간헐적 실패를 식별**하는 용도. 실패 상세를 열어 검토·재처리. **How:** Data Management 탭 → **Data Pipelines** → Last 30 Runs 컬럼 |
| **Identify Expired Authentication Tokens in Connection Management**<br>`rn_mc_mi_expired_tokens` | 데이터 소스 연결의 **인증·상태(health)** 를 한 곳에서 확인. **만료된 토큰과 영향받는 파이프라인을 식별**하고 **연결을 다시 만들지 않고 재인증**한다. **How:** **Connection Management 탭**에서 상태 확인 후 만료 연결 재인증 |
| **Validate Ingested Data Faster with Pivot Tables**<br>`rn_mc_mi_pivot_tables` | 기존 데이터 파이프라인에서 열리는 **사전 필터링된 피벗 테이블**로 원시 값 탐색·수집 결과 검증. Marketing Intelligence가 **선택한 파이프라인의 데이터로 피벗 테이블을 자동 생성**하므로 스프레드시트 우회가 줄어든다 |

**Agentforce in Marketing Intelligence** (`rn_mc_mi_analytics_insights` 허브)

**Get Data-Driven Recommendations for Campaign Performance (Beta)** (`rn_mc_mi_campaign_performance`) — Marketing Intelligence의 **Budget Reallocation** 으로 캠페인 성과를 분석하고 **예산 재배분에 대한 AI 권고**를 받는다. **목표 지표(target metric)를 정하고 캠페인을 선택한 뒤 원하는 권고만 적용**한다.

- **When:** **Winter '27 릴리즈부터 순차(rolling basis) 제공되는 베타 기능**
- **Where(원문 그대로):** *"Budget Reallocation is a pilot or beta service that is subject to the Beta Services Terms … or a written Unified Pilot Agreement …, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion."* — **에디션 정보가 아니라 베타 약관 고지다**
- **How:** Setup → **Marketing Intelligence** → **Feature Manager 탭** → **Budget Reallocation (Beta)** 켜기

> 허브 `rn_mc_mi_marketing_intelligence` 는 **Marketing Intelligence Release Note Changes by Month** 도 담고 있다 — **2026년 8월 기준 "최초 게시 이후 변경 없음"**.

### Salesforce Personalization

> 원문 프레이밍: *"Salesforce Personalization in Marketing Cloud Next enhancements includes updates for **both the Salesforce Personalization and Marketing Cloud Personalization products**."* — 이 절의 변경은 **Salesforce Personalization과 Marketing Cloud Personalization 두 제품 모두**에 걸친다. 원문은 두 제품의 기능·변경이 *"released as often as monthly"* 라고도 밝힌다.
>
> 아래 두 항목은 모두 원문 Release Note Changes(August 2026)에 **"(Added the week of August 17, 2026)"** 로 기록돼 있다 — **2026-08-17 주에 릴리즈 노트에 추가**된 항목이라는 뜻이며(기능 가용 시점이 아니라 노트 등재 시점), 원문에 별도 가용 시점 표기는 없다.

| 항목 | 내용 |
|---|---|
| **Analyze Experiment Results with the Data Visualization Tab**<br>`rn_persnl_data_viz_tab` | A/B 테스트 결과를 **control cohort와 비교**해 결과를 언제 신뢰할 수 있는지 판단. 요약 카드가 **최고 성과 변형과 승리 확률(odds of winning)** 을 제시하고, **성과 차트와 일별 등록(daily enrollment) 차트**로 시간에 따른 추세를 보여준다. **Where:** Lightning Experience · **Professional·Enterprise·Unlimited·Developer** + **Salesforce Personalization 라이선스** |
| **Deliver Personalized Mobile Experiences Without Rebuilding Your App**<br>`rn_persnl_personalize_mobile_lowcode` | **로우코드 모바일 개인화**. 개발자가 컴포넌트와 콘텐츠 존을 **한 번** 정의하면 이후 현업이 코드 없이·**앱 업데이트 배포 없이** 개인화 경험을 생성·미리보기·게시. 개인화 콘텐츠는 **앱에서 네이티브 렌더링**되고 고객 상호작용은 **Data 360으로 전송**돼 이후 개인화를 정교화한다. 지원: **iOS · Android · React Native · Flutter**. **Where:** Lightning Experience · Professional·Enterprise·Unlimited·Developer + **Salesforce Personalization 애드온**(위 항목은 "라이선스", 이 항목은 "애드온"으로 원문 표기가 다르다). **How:** 개발자가 **Marketing Cloud Unified Mobile SDK의 Salesforce Personalization 모듈**을 통합한 뒤 **Data 360 Setup에서 컴포넌트와 콘텐츠 존을 등록** → 현업이 **Personalization 앱**에서 경험을 만들고 **QR 코드로 미리보기** 후 게시 |

### Referral Marketing (3건 전수)

**Where 공통:** Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Referral Marketing**(SMS 항목만 **Marketing Cloud Next도 필요**).

| 항목 | 내용 |
|---|---|
| **Boost Referral Conversion in Mobile-First Markets with SMS Notifications**<br>`rn_referral_boost_conversion_mobile_first_markets` | advocate가 **Refer A Friend 위젯에 친구의 휴대폰 번호를 입력**하면 Referral Marketing이 문자를 보낸다. 위젯에서 **휴대폰 번호 · 이메일 주소 · 둘 다** 중 무엇을 수집할지 구성해 advocate가 선호하는 방식을 쓰게 한다. ⚠️ **원문 제약: 문자 발송은 커뮤니케이션 방식이 Marketing Cloud Next일 때만 가능하다.** **Where:** 위 공통 + **Marketing Cloud Next** |
| **Monitor Referral Promotion Performance by Using Tableau Next Dashboards**<br>`rn_referral_monitor_promotion_performance_tableau_next` | 추천 참여·전환율·재무 성과 인사이트 — **advocate 인게이지먼트 · 친구 가입 · 친구 활동** 추적, **발생 수익과 리워드 부채(reward liability)** 측정. ⚠️ **이전엔 CRM Analytics에서만 제공**되던 기능이 확장성과 기능 확대를 위해 Tableau Next로도 제공된다 |
| **Simplify Referral Widget Deployment with Lightning Out 2.0**<br>`rn_referral_simplify_widget_integration` | 자동 생성 HTML 스니펫으로 외부 사이트·Experience Cloud 사이트에 위젯 임베드. **Lightning Out 2.0 기반**이라 디자인·콘텐츠·동작 변경이 **코드 재배포 없이 즉시 반영**된다. **이전엔 수동 임베드와 변경 시마다 재임베드가 필요했다.** **How:** **Widget Designer 페이지 → Embed** → 생성된 HTML을 사이트에 추가 |

> Loyalty Management·Real-Time Offer Management는 이 노트의 별도 절 `## Loyalty Management · Real-Time Offer Management · Referral Marketing` 참조.

### ⭐ 대표 신기능
1. **Agentforce Marketing Goals Agent · Content Agent** 신규 2종 — 단 Goals Agent의 캠페인 간 선택 판단에는 **`Adaptive Campaign Audiences (beta)` 별도 설정**이 전제다.
2. **RCS 대폭 확장** — 10장 캐러셀·위치/캘린더 액션·Campaign 탭 관리·플로우 요소 지표·17개국 추가.
3. **이메일 전달률 운영 3종** — 0–100 Health Score·자동 알림, 단계별 개선 가이드, **발송 후 추적 링크 수정**(단 이 수정은 Salesforce 고객지원이 수행).
4. **MCE 보안 강화 묶음** — PR-MFA·step-up 인증(**2026-07-30 강제**)·client secret 자동 폐기·**2026-09-30 client secret 만료**·Data Extension 접근 감사.

---

## Analytics

> 랜딩이 밝힌 범위 전수: **Tableau Next · Lightning Reports and Dashboards · Data 360 Reports and Dashboards · CRM Analytics · Tableau**. 이 다섯 축 중 **Tableau Next는 Winter '27 발행 시점 신기능이 0건**이고 **Tableau는 제품 링크만** 제공한다 — 실제 기능은 **CRM Analytics 8건 · Lightning Reports and Dashboards 4건(전부 Beta) · Data 360 Reports and Dashboards 6건**이다.

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

### Lightning Reports and Dashboards (`rn_rd_reports_dashboards` 허브 + 리프 4) — 전부 Beta

허브 요약: **LWR 기반 Experience Cloud 사이트에 Lightning 리포트·대시보드를 직접** 가져오고, **사이드 패널에서 레코드를 검토**해 리포트 뷰와 필터를 유지한 채 데이터를 빠르게 훑는다.

> ⚠️ **네 건 모두 Beta이며 원문의 Beta 고지가 동일하다:** *"…is a pilot or beta service that is subject to the Beta Services Terms at Agreements - Salesforce.com or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion."*

| 항목 | 내용 |
|---|---|
| **Preview Records from Lightning Reports Without Losing Context (Beta)** 🔵Beta<br>`rn_rd_reports_record_preview` | **사이드 패널에서 레코드 상세**를 보며 리포트의 필터·컬럼·레코드 목록을 그대로 유지. **Where: Lightning Experience · Enterprise·Performance·Unlimited·Developer.** **How:** Setup → Quick Find **Reports** → **Reports and Dashboards Settings** → **`Show record previews on Lightning Reports (Beta)` 선택**. 리포트 보기 모드에서 **눈 아이콘**을 클릭해 레코드 링크를 미리보기로 연다. *(원문에 (1)(2)(3) 번호가 붙은 스크린샷이 있다 — 이 노트에는 텍스트 설명만)* |
| **Embed Lightning Dashboards in Your LWR Experience Cloud Sites (Beta)** 🔵Beta<br>`rn_rd_dashboards_lwr` | 네이티브 LWC로 LWR 사이트에 대시보드 임베드 — **위젯 조회 · 필터 값 갱신 · 개별 위젯 또는 전체 대시보드 새로고침**. ⚠️ **이전엔 Lightning 대시보드가 Aura 기반 Experience Cloud 사이트에서만 제공**됐다. **Where: Lightning Experience · Professional·Enterprise·Unlimited, 그리고 이 에디션들을 통해 접근하는 LWR 사이트.** **How:** Setup → Reports and Dashboards Settings → **`Show Lightning dashboards in Lightning Web Runtime (LWR)-based Experience Cloud sites (Beta)` 선택** → Experience Builder에서 **Lightning Dashboard 컴포넌트**를 LWR 페이지로 드래그 → **대시보드 ID 입력** |
| **Embed Lightning Reports in Your LWR Experience Cloud Sites (Beta)** 🔵Beta<br>`rn_rd_embed_reports_lwr` | 네이티브 LWC로 LWR 사이트에 리포트 임베드 — 사이트를 떠나지 않고 **차트·표 생성 · 조건부 서식 적용 · 추세 리포트 조회 · Chatter 협업 · 인라인 레코드 편집**. ⚠️ **이전엔 Aura 기반 사이트에서만 제공**됐다. **Where: 위 대시보드 항목과 동일.** **How:** Setup → Reports and Dashboards Settings → **`Show Lightning reports in Lightning Web Runtime (LWR)-based Experience Cloud sites (Beta)` 선택** → Experience Builder에서 **Lightning Report 컴포넌트** 배치 → **리포트 ID 입력** |
| **Show Only Matching Records Across Blocks in Joined Reports (Beta)** 🔵Beta<br>`rn_rd_joined_reports_show_common_rows` | joined report에서 **모든 블록에 나타나는 레코드만** 표시. **원문 예시: Accounts·Opportunities joined report를 Account Name으로 그룹핑하면 opportunity가 있는 계정만 표시되고 활성 딜이 없는 계정은 빠진다.** **이전엔 한 블록에만 나타나는 레코드도 포함**됐다. **Where: Lightning Experience · Enterprise·Performance·Unlimited·Developer.** ⚠️ **How: 이 기능을 켜려면 Salesforce Customer Support에 문의해야 한다.** 그다음 리포트 편집기에서 joined report의 블록을 편집해 **`Common Rows Only`** 를 켜고 저장 |

### Data 360 Reports and Dashboards (`rn_rd_dc_reports_dashboards` 허브 + 리프 6)

**Where 공통 [D360-RPT]:** **Data 360** · **Developer·Enterprise·Performance·Unlimited** 에디션(원문에 *Lightning Experience* 문구가 없다).

| 항목 | 내용 |
|---|---|
| **Perform Faster Drill-Downs with Dimensional Hierarchies in Data 360 Reports (Generally Available)** 🟢GA<br>`rn_data360_reports_dimensional_hierarchies` | **차원 계층**으로 필드를 일일이 추가·제거하지 않고 상세 수준을 오간다. **원문 예시: 제품 카테고리별 매출을 분석하다 하위 카테고리와 개별 제품으로 드릴다운해 성과 변동 원인을 찾고, 다시 상위 그룹으로 롤업.** **How:** 리포트 편집기에서 Fields 패널의 **hierarchy 필드를 Columns 또는 Group Rows 섹션에 추가** → 드릴다운은 필드 옆 **`+`** 또는 컬럼 액션 메뉴의 **Drill Down** → 롤업은 **`X`** 또는 **Remove Group**. **Where: [D360-RPT]** |
| **Compare Data 360 Objects Side by Side with Data 360 Joined Reports**<br>`rn_data360_reports_joined_reports` | 여러 **DMO의 데이터를 하나의 joined report**에서 분석(스프레드시트로 내보낼 필요 없음). 서로 다른 DMO 기반 리포트 타입으로 **별도 블록**을 만들고 **공유 필드로 블록을 가로질러 그룹핑**한다. **원문 예시: Accounts 리포트 타입과 Opportunities 리포트 타입을 Industry로 그룹핑해 나란히 비교 — 활성 opportunity가 있는 시장 부문을 식별하고 미개척 계정을 부각.** **How:** DMO 기반 Data 360 리포트를 열고 편집 모드에서 **포맷을 Joined로 변경** → **Add Block** 으로 base block과 공통 필드를 가진 리포트 타입 추가. **Where: [D360-RPT]** |
| **Report on Multiple Currencies in Data 360 Reports**<br>`rn_data360_reports_multicurrency` | 원 통화 값과 **선택한 report currency로 환산된 값**을 함께 조회. **다중 통화 조직에서는 Data 360 리포트가 합계·정렬·필터·그룹핑에 환산 값을 사용**한다. ⚠️ **되돌릴 수 없는 설정 — 원문: *"After multiple currencies are enabled, you can't turn off the setting."*** **How:** 조직에서 다중 통화를 활성화하고 통화 필드 매핑을 확인 → 리포트 편집기에서 **환산 통화 필드를 Fields 패널에서 Columns로 드래그** → 편집기 하단에서 **report currency 선택** → 저장. *(원문에 (1)~(4) 번호 스크린샷이 있다)* **Where: [D360-RPT]** |
| **Identify Customer Sentiment in Data 360 Reports (Beta)** 🔵Beta<br>`rn_data360_reports_customer_sentiment` | **`AI_SENTIMENT` 함수**를 row-level 또는 summary-level 수식에 써서 고객 피드백의 감성 추세를 분석 — **코드 작성이나 데이터 파이프라인 구축 없이**. **지원 티켓 · 리뷰 · 통화 전사** 같은 비정형 텍스트를 **Positive · Negative · Neutral · Mixed · Unknown** 5종으로 분류한다. **How:** Setup → Reports and Dashboards Settings → **`Enable AI Sentiment Function in Data Cloud Reports (Beta)` 선택** → 리포트 편집 모드에서 수식 추가(예: **`AI_SENTIMENT(Support_Ticket_Text__c)`**). **Where: [D360-RPT].** **Beta 고지:** *"AI Sentiment Function in Data 360 Reports is a pilot or beta service…"* |
| **Find the Right Report Type Faster with Improved Report Search (Beta)** 🔵Beta<br>`rn_data360_reports_improved_report_search` | **키워드와 자연어 검색**으로 리포트 타입의 **이름·설명 의미**에 기반해 탐색. 특정 리포트 카테고리 안에서 또는 전 카테고리를 가로질러 검색. **원문 예시: "show me all leads" 로 검색하면 캠페인 성과·리드 전환 관련 리포트 타입이 나온다.** **How:** Setup → Reports and Dashboards Settings → **`Use Improved Report Type Search (Beta)` 선택** → 리포트 타입 선택기에서 키워드·자연어 입력. **Where: [D360-RPT]** |
| **See Relevant Report Data by Using Organizational Hierarchies in Data 360 (Beta)** 🔵Beta<br>`rn_data360_reports_org_hierarchies` | **Semantic Data Model 리포트**를 역할 기준으로 필터링 — **role 계층 또는 manager 계층**을 정의해 팀 단위 리포팅을 단순화하고, 관리자가 팀 레코드만 보거나 전체를 볼 수 있게 한다. ⚠️ **How — 선행 조건이 있다: `User` 와 `User Role` DMO가 사용 가능해야 한다.** **Semantic Data Model 저작 페이지**에서 리포트가 쓰는 시맨틱 모델에 role·manager 계층을 정의 → Setup → Reports and Dashboards Settings → **`Enable Organizational Hierarchy in Data Cloud Reports (Beta)` 선택** → 리포트 편집기 **Filters 탭 → Add Organizational Filter** → **Organizational Hierarchy 섹션**에서 계층 유형과 데이터 범위 선택. **Where: [D360-RPT]** |

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
4. **Lightning 리포트·대시보드가 LWR Experience Cloud 사이트로** — 임베드 2건 + 레코드 미리보기 + joined report common rows, **네 건 모두 Beta**.
5. **Data 360 리포트의 차원 계층 GA** + **`AI_SENTIMENT` 감성 분류(Beta)** + joined report + **다중 통화(켜면 되돌릴 수 없음)**.

---

## Data 360

> *"Data 360 features and changes are released as often as monthly… Changes included in the Winter '27 release are generally listed under **October 2026**."* 즉 Data 360은 코어 릴리즈와 다른 주기로 움직인다. Winter '27 Clouds 카탈로그에 등재된 Data 360 항목은 **Engagement Timeline · 데이터 그래프 거버넌스 · 내비게이션 · Snowflake V2 · Copy Field Enrichments 3건 · Data Processing Engine 5건**이며, **리포트 계열 6건은 위 `## Analytics` 절의 `### Data 360 Reports and Dashboards`** 에 있다.

### 리브랜드 재확인

> 원문: *"As of **October 14, 2025**, Data Cloud has been rebranded to Data 360. During this transition, you may see references to Data Cloud in our application and documentation. While the name is new, the functionality and content remains unchanged."*

### Data 360 Engagement Timeline (신규 위젯) + 구 위젯 은퇴

- **무엇:** 인게이지먼트 데이터를 **시간순으로 표시하는 신규 위젯**
- **어디에:** **Account · Contact · Lead · Person Account · Prospect** 레코드
- **Where(에디션):** **Data 360 Developer · Enterprise · Performance · Unlimited**
- **구성:** 관리자가 레코드 페이지를 편집해 **Lightning App Builder**로 위젯 배치. 구성하려면 **Data 360 접근 권한 + Customize Application 권한** 필요
- **조회:** 구성 후 데이터를 보려면 **Data 360 라이선스 + 구성된 data space 접근 권한** 필요

| 항목 | 내용 |
|---|---|
| **Migrate to the Data 360 Engagement Timeline**<br>`rn_migrate_to_the_data_360_engagement_timeline` | ⛔ **구 `Data Cloud Profile Engagements` 위젯이 end of life** 이며 **Data 360 Engagement Timeline** 이 그 자리를 대체한다. 신규 컴포넌트는 **Lightning App Builder에서 구성해 최대 10가지 유형의 인게이지먼트 데이터를 표시**한다. 대상 레코드는 **Account · Contact · Lead · Person Account · Prospect**. **Where: Data 360 Developer·Enterprise·Performance·Unlimited** |

### 데이터 그래프 거버넌스 · 내비게이션 · 데이터 공유

| 항목 | 내용 |
|---|---|
| **Enhance Data Security with Granular Governance for Data Graphs**<br>`rn_cdp_2026_winter_dg_granular_gov` | ⚠️ **접근 모델 자체가 바뀐다.** **이전의 all-or-nothing 접근 모델 대신** Data 360이 거버넌스 정책에 따라 **제한된 필드를 자동으로 잘라내고(prune), 데이터를 마스킹하고, 권한이 없는 자식 DMO를 제외**한다. **여러 사용자와 AI 에이전트가 같은 data graph에 안전하게 접근**하면서 각자 권한 있는 데이터만 본다. **자식 DMO에 접근 제어 정책이 걸린 data graph도 일부 자식 DMO가 제한돼 있는 상태로 계속 보인다** — **단 data graph의 출력 DMO에 명시적 deny 정책을 적용하면 예외**다. **Where: Data 360 · Developer·Enterprise·Performance·Unlimited. When: 2026년 8월부터 순차(rolling) 제공.**<br>⚠️ **How — 자동 활성화되지만 검토가 필요하다:** *"This feature is enabled automatically."* 그러나 **이전에 자식 DMO 제한으로 data graph 전체 접근을 막고 있었다면 거버넌스 정책을 재검토해 출력 DMO에 적절한 governance tag 또는 명시적 deny 정책을 적용**해야 의도치 않은 노출을 막을 수 있다 |
| **Simplify Your Navigation with the Updated Data 360 Menu**<br>`rn_cdp_2026_winter_nav_resources` | 좌측 내비게이션이 **관련 기능을 그룹으로 묶어** 탭 과부하를 줄이고, 갱신된 리소스 페이지에서 학습 자료에 바로 접근한다. **Where: Data 360 · Enterprise·Performance·Unlimited·Developer. When: 2026년 8월부터.** **How:** 기존 고객은 **Data Cloud Setup의 Feature Manager** 에서 **`Data 360 Left Side Navigation` 옆 Enable** 로 켜고 끈다. ⚠️ **내비게이션을 커스터마이즈했거나 탭을 고정해 둔 기존 사용자는 설정을 초기화해야 한다** — 연필 아이콘에서 내비게이션 설정을 열고 **Reset Navigation to Default** 선택 후 저장 |
| **Use the Snowflake Zero-Copy V2 Connector for Enhanced Data Sharing**<br>`rn_cdp_2026_summer_snowflake_v2` | **Snowflake zero-copy V2 커넥터** — **OIDC로 인증**하고 **stream과 task로 변경 데이터에 대응**한다. data share와 **Snowflake V2 data share target** 을 만들어 연결하면 **데이터를 복제하지 않고 마운트된 Snowflake 데이터베이스로 쿼리**한다. ⚠️ **이전엔 Data 360이 레거시 Snowflake data share target을 통해 username·password 기반 OAuth를 썼다.** **Where: Data 360 Developer·Enterprise·Performance·Unlimited. ⚠️ 원문 제약: *"This change isn't available in Government Cloud."*** **When: 샌드박스·프로덕션 모두 2026년 8월부터 순차 제공.**<br>⚠️ **원문 Important — 마이그레이션 기한이 있다:** **레거시 Snowflake data share target은 더 이상 만들 수 없고, 기존 data share는 2026년 10월 31일까지 Snowflake V2 data share target으로 마이그레이션해야 한다.** 레거시에서 연결을 끊기 전에 **V2 target에 연결된 data share가 정상 동작하는지 검증**해야 다운스트림 파이프라인·대시보드가 중단 없이 데이터를 계속 받는다 |

### Copy Field Enrichments (3건)

**Where 공통:** **Data 360 Developer·Enterprise·Performance·Unlimited** 에디션.

| 항목 | 내용 |
|---|---|
| **Match Copy Field Enrichments on More Than the Primary Key**<br>`rn_match_copy_field_enrichments_on_more_than_the_primary_key` | 소스↔타깃 레코드를 **항상 타깃의 primary key로만 매칭하던 방식**에서 벗어나 **원하는 필드로 매칭**한다 — **타깃의 ID · 고유 external ID 필드 · 스키마가 고유성을 강제하는 다른 필드**. **Why(원문):** 타깃 레코드의 Salesforce ID를 다른 필드에 저장하는 소스 DMO(예: **머신러닝 예측 DMO**)는 매칭이 불가능해 **실시간 스코어 등 인사이트를 CRM 레코드로 전달하지 못했고 커스텀 Apex나 수동 임포트가 필요**했다. **How:** Copy Field Enrichments 설정에서 소스·타깃 오브젝트를 고르면 **신규 Matching Criteria 섹션**이 나타나며 **기본값은 타깃 primary key 매칭**이다. **Change** 를 선택해 소스 필드와 타깃 필드를 고른다. ⚠️ **타깃 필드는 unique 또는 external ID로 표시돼 있어야 하며 아니면 저장이 차단된다.** ⚠️ **기존 Copy Field Enrichments 잡은 계속 primary key로 매칭하며 이 변경의 영향을 받지 않는다** |
| **Expand Field Type Compatibility for Copy Field Enrichments**<br>`rn_expand_field_type_compatibility_for_copy_field_enrichments` | **Number → Text**, **Integer → Percent** 같은 **더 많은 필드 타입 간 매핑**을 지원하며 **표준 Salesforce API 캐스팅이 변환을 자동 처리**한다. ⚠️ **이전엔 소스와 타깃 필드 타입이 정확히 일치해야 해서 관리자가 타입 변환용 중간 수식 필드를 만들어야 했다.** **How:** Field Mapping 컴포넌트의 **Target Field 드롭다운**이 이제 **선택한 Data Cloud 소스 필드 타입과 호환되는 모든 CRM 필드**를 나열한다. ⚠️ **소스 값이 비어 있으면 Copy Field Enrichments가 타깃 필드의 기본값을 적용하는 대신 타깃 필드를 비운다(clear).** 넓은 타입의 소스에서 매핑할 때는 **문자 길이 같은 타깃 필드 제약을 검토**해 행 단위 실패를 피한다.<br>⚠️ **원문의 `When:` 과 `Who:` 헤딩이 라이브 페이지에서 값 없이 비어 있다 — 추출 실패가 아니라 원문 자체가 비어 있는 것이다.** |
| **Transform and Integrate Data with Picklist-Dependent Fields**<br>`rn_transform_and_integrate_data_with_picklist_dependent_fields` | copy field enrichment 중 **소스 필드를 picklist 타깃 필드에 매핑**할 수 있어 picklist 종속 필드와의 데이터 변환·통합이 유연해진다 |

### Context Service

| 항목 | 내용 |
|---|---|
| **Track Changes to Context Definitions with Setup Audit Trail** | **Professional·Enterprise·Unlimited·Developer**(Context Service 활성 조직). Setup Audit Trail이 **context definition과 관련 구성 — context node · attribute · tag · mapping · filter** 의 생성·수정·삭제를 기록한다. **Context Service의 transform은 생성·삭제**를 기록. **변경 이력은 180일 보존.** Setup → Audit Trail → View Setup Audit Trail |
| **Hydrate Complete Data 360 Hierarchies in Context Service** | **Professional·Enterprise·Unlimited·Developer**(Context Service **및 Data 360** 활성 조직). DMO 간 부모-자식 관계를 해석해 **단일 hydration 호출로 다단계 계층 전체를 반환**한다. DMO 계층(예: member demographics·health plan enrollment·claims history)을 구성하면 Context Service가 **Data 360의 관계 메타데이터에서 조인 필드를 식별**한다. 효과 3가지: ① AI 워크플로용 완전한 다단계 프로필(누락 데이터로 인한 hallucination 방지) ② **zero-copy DMO 투명 지원** — **Google BigQuery·Databricks·Snowflake** 등 외부 웨어하우스 데이터가 **추가 구성 없이** hydration ③ 기존 Context Node 계층 모델 지원. 이전엔 자식 DMO 데이터를 못 받아 AI 에이전트·추천 엔진·자동화가 불완전한 프로필을 받았다 |

### Data Processing Engine (5건)

**Where 공통 [DPE]:** Lightning Experience · **Professional·Enterprise·Unlimited·Developer** — *"where Data Processing Engine is available."* (신뢰성 항목 `rn_dpe_other_improvements` 만 *"where DPE is available"* 단서 없이 에디션만 적는다.)

| 항목 | 내용 |
|---|---|
| **Control Currency Handling for Data Processing Engine Definitions**<br>`rn_dpe_currency_conversion` | CRM Analytics 또는 Data 360에서 실행되는 정의의 다중 통화 처리 방식 선택 — **단일 통화로 전부 환산**해 일관 계산하거나 **원 통화를 유지해 커스텀 변환 로직 적용**. ⚠️ **이전엔 두 런타임이 서로 달랐다: CRM Analytics 런타임은 통합 사용자(integration user)의 통화로 환산했고, Data 360 런타임은 원 통화를 유지하되 목표 통화를 선택할 방법이 없었다.** ⚠️ **이 통화 설정은 다중 통화가 활성인 조직에서만 나타난다.** **How:** Data Processing Engine 빌더 툴박스 → **Set Up** → **Currency Conversion 켜기** |
| **Reliability Changes in Data Processing Engine**<br>`rn_dpe_other_improvements` | Data 360 오브젝트·Salesforce 오브젝트·CSV 등에서 더 빠르고 무결하게 실행. **부분 실패 추적** — **Monitor Workflow Services** 에서 미처리·실패 레코드가 있으면 정의 실행과 태스크가 **`Completed with Failures`** 상태로 표시된다(예: 레코드 수준 실패가 있는 데이터 동기화). ⚠️ **실행 중인 정의는 비활성화할 수 없다.** **Where: Lightning Experience · Professional·Enterprise·Unlimited·Developer** |
| **Roll Up Only the Lowest-Tier Values in Hierarchy Nodes**<br>`rn_dpe_exclude_parent_value` | **온디맨드 정의**에서 **부모 레코드 값을 계층 롤업 합계에서 제외**할지 선택 — 자식이 없는 최하위 레코드 값만 집계한다. **계층 깊이가 제각각일 때 최하위 레코드만 값을 갖는 경우에 쓴다.** ⚠️ **이전엔 계층 집계가 항상 모든 레코드의 자기 값을 포함**했다. ⚠️ **Where: [DPE] + Data Processing Engine **On Demand** 도 사용 가능해야 한다.** **Who: `Run Data Processing Engine Definitions On Demand` 권한 세트.** **How:** 빌더에서 온디맨드 정의를 열고 **Hierarchy 노드** 추가 → 제외할 aggregate 필드마다 **`Include only the lowest-tier values`** 선택 |
| **Simplify Definitions with Multiple Formulas in a Single Node**<br>`rn_dpe_formula_sequencing` | **하나의 formula node 안에서 수식을 순차 실행**해 앞선 계산 결과를 사용하고 관련 로직을 한곳에 모은다. **Where: [DPE]** |
| **Send Data Transformation Results to Virtual Objects**<br>`rn_dpe_virtual_entity_writeback` | CRM Analytics·Data 360 런타임 정의의 출력을 **Apache HBase 기반 virtual object**에 저장하고 조직에서 레코드로 조회. ⚠️ **이전엔 표준·커스텀 오브젝트로만 write-back이 가능했다.** **How:** 정의에 **Writeback object 노드**를 추가하고 **Apache HBase 기반 virtual object를 타깃 오브젝트로 지정** → ⚠️ **레코드를 올바르게 매칭하려면 매핑 필드로 virtual object의 external ID 필드를 선택**해야 한다. **Where: [DPE]** |

### 4개 축 — 랜딩 설명 (Clouds 페이지 목록에 리프 page id 없음)

| 축 | 원문 한 줄 |
|---|---|
| **Get Started with Data 360** | 시작 전 알아야 할 에디션·기능 가용성·가이드라인·과금, 그리고 사용자 관리·기능 활성화 같은 관리자 기능 |
| **Process and Enrich** | 지능형 처리 방식으로 검색·AI를 위한 데이터 준비. Data 360의 **비정형·정형 데이터에 검색을 grounding** 해 생성형 AI·분석·자동화에 활용 |
| **Explore and Optimize** | 클릭·자연어·SQL로 데이터 탐색. **data graph와 secondary index** 생성으로 빠른 조회 최적화 |
| **Segment and Act** | 세그먼트 생성, 외부 데이터 소스와 공유, data action·activation target·activation 생성, 플로우 구축, Data 360 데이터로 조직 강화 |

> 이 네 축은 **Data 360 랜딩 페이지의 목차 항목**이며 Winter '27 Clouds 페이지 목록(988건)에 **독립 page id로 등재되지 않았다** — 따라서 축 자체에 대한 Where/How는 원문에 없다.

### ⭐ 대표 신기능
1. **Data graph 거버넌스가 all-or-nothing → 필드 단위 pruning·마스킹으로 전환**(자동 활성화이므로 기존 정책 재검토 필요).
2. **Snowflake Zero-Copy V2 커넥터**(OIDC) — **레거시 target은 2026-10-31까지 마이그레이션**, **Government Cloud 미제공**.
3. **Data 360 Engagement Timeline** — 5개 레코드 타입에 최대 10종 인게이지먼트 데이터. **구 Profile Engagements 위젯은 EOL**.
4. **Copy Field Enrichments의 매칭 키·타입 제약 완화** — primary key 외 unique/external ID 매칭 + 타입 자동 캐스팅.
5. **DPE 통화 처리 통일** + 부분 실패 추적(`Completed with Failures`) + **virtual object write-back**.

---

## Industries

> Industries 랜딩이 나열한 산업 전수: **Automotive · Communications · Consumer Goods · Education · Energy and Utilities · Financial Services · Health · Insurance · Life Sciences · Manufacturing · Media Cloud · Net Zero Cloud · Nonprofit · Industries Common Features**. (**Public Sector**는 Winter '27에서 Industries 하위가 아니라 **최상위 랜딩 항목**으로 별도 배치돼 있다 — 이 노트는 산업 성격상 여기 `### Public Sector` 절에 46건 전수를 실었다.)
>
> **산업별 리프 페이지 343건 전부를 본문까지 확보**해 아래 산업별 절에 실었다(Where·How·Who·When 포함). 각 절 서두의 **산업 랜딩 요약**은 그 산업의 범위를 훑는 용도이고, 실제 에디션·설정 절차·권한은 각 절의 항목 표에 있다. **Nonprofit·Net Zero 두 산업만 예외** — 이 둘은 Winter '27 Clouds 페이지 목록(988건)에 개별 리프 page id가 없어 랜딩 요약만 존재한다.
>
> **산업별 건수:** Public Sector 46 · Communications 38 · Insurance 33 · Life Sciences 31 · Energy & Utilities 26 · Automotive 21 · Health 21 · Education 18 · Manufacturing 16 · Media 14 · Industries CPQ 10 · Consumer Goods 8 · Financial Services 7 · **Industries Common Features 54**(Omnistudio 4 포함) = **343** *(Common Features는 특정 산업에 속하지 않는 공통 계층이므로 산업 합계 289와 분리해 읽는다)*

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

### Automotive (Agentforce Automotive) — 21건 전수

Winter '27 Automotive의 축은 세 갈래다: **압류(Repossession) 전 라이프사이클 신설** · **보증 청구(Warranty Claim) 판정 심화** · **Agentforce 에이전트의 Experience Cloud 확장**.

**Where 약칭** — 원문 문구를 그대로 세 유형으로 나눈다.

| 약칭 | 원문 Where |
|---|---|
| **[AUTO-C&R]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Automotive Cloud** + **Collections and Recovery capability** |
| **[AUTO-AF]** | Lightning Experience · **Enterprise·Performance·Unlimited** + **Agentforce Automotive 애드온 라이선스** 또는 **Agentforce 1 Automotive Edition** 포함 |
| **[AUTO-EUD]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Agentforce Automotive** |

#### Managing Automotive Repossession (`rn_auto_managing_automotive_repossession` 허브 + 리프 11)

허브 원문이 밝힌 뼈대: **3단계 라이프사이클 — pre-repossession → manager approval → active recovery.** 연체 차량 계정이 중심이지만 **lease-end · accident · impound 같은 비연체 압류에도 그대로 쓸 수 있을 만큼 유연**하다.

| 항목 | 내용 |
|---|---|
| **Monitor Delinquency with Consolidated Record Views and Recommendation Alerts**<br>`rn_auto_monitor_delinquency_record_views_alerts` | **Collection Plan 레코드**의 통합 뷰가 **계정 잔액 · days past due · 마일스톤 타임라인(예: Notice of Summoning Arrears Sent · Notice of Summoning Arrears Expired · Notice of Default Sent) · 접촉 이력 · 활성 알림**을 한 화면에 모은다. 관리자는 연체 임계값을 넘을 때 뜨는 **recommendation alert**(예: 사전 압류 평가를 시작하라)를 구성할 수 있다.<br>⚠️ **원문이 두 번 못을 박은 비-OOTB 지점 두 가지** — ① *"These alerts aren't provided out of the box."* (추천 알림은 기본 제공이 아니다) ② *"an admin first adds and configures the Milestone component on the Collection Plan record page; **it isn't set up out of the box**."* (마일스톤 타임라인을 보려면 관리자가 레코드 페이지에 Milestone 컴포넌트를 직접 추가·구성해야 한다). **Where: [AUTO-C&R].** **Who:** `Industries Repossession Management` 권한 세트(**기저 데이터 모델 자체는 Automotive Cloud만으로 제공**). 선행: `Automotive Foundation User` · `Vehicle and Asset Finance Foundation` |
| **Enforce Legal Notice Requirements During Vehicle Collections**<br>`rn_auto_enforce_legal_notice_requirements` | 지역이 요구하는 **법적 통지(legal notice)** 를 규칙으로 정의하고 발송분을 자동 추적. **Repossession Notice Rule** 이 어떤 통지를 언제 보내야 하는지 정의하고, 발송된 통지는 **collection plan 마일스톤에 묶인 Repossession Notice Log** 에 남아 방어 가능한 컴플라이언스 기록이 된다. **Where: [AUTO-C&R].** **Who:** 선행 `Automotive Foundation User`·`Vehicle and Asset Finance Foundation` + `Industries Repossession Management`. ⚠️ **문서 컴플라이언스까지 쓰려면 관리자가 Setup의 Advanced Document Validation Settings 페이지에서 `Advanced Document Validation` 을 켜고, 생성형 AI 추출을 쓰려면 `AI-Powered Document Validation` 도 켜야 한다** |
| **Create Pre-Repossession Records for Delinquent Vehicle Accounts**<br>`rn_auto_create_pre_repossession_records` | Collection 레코드를 벗어나지 않고 연체 계정을 사전 압류로 넘긴다. **Action Launcher → Start Pre-Repossession Process** 에서 추적할 금융 차량을 고르고 제출하면 **Repossession 레코드**가 생성된다. **Where: [AUTO-C&R].** **Who:** `Industries Repossession Management`(선행 2종) |
| **Conduct Pre-Repossession Vehicle Appraisal and Financial Viability**<br>`rn_auto_pre_repossession_appraisal_viability` | **감정 마법사 4단계 — Vehicle Trim and Mileage → Vehicle Condition → Vehicle Valuation → Proposed Valuation.** 차량 데이터는 미리 채워지고, 담당자가 **ownership type**과 **condition(Fair · Good · Very Good · Excellent)** 을 고르고 valuation provider를 선택한 뒤 **provider value(Clean · Average · Rough)** 를 고르고 필요하면 조정치를 적용한다. ⚠️ **원문 명시: market valuation은 내장 계산이 아니라 고객사가 직접 붙인 외부 valuation 소스 연동에서 온다**(*"come from the customer's own integrations to external valuation sources, not from a built-in calculation"*). 확정 값은 **loan·lease 잔액 · Collection Plan 마일스톤 · loan-to-value** 를 보는 **financial viability** 검토로 넘어간다. **Where: [AUTO-C&R].** **How:** Repossession Console 앱 → Repossession 레코드 → **Collateral 탭** → Create Appraisal(또는 New) |
| **Conduct Structured Vehicle Repossession Assessments**<br>`rn_auto_structured_repossession_assessments` | **Industries Assessment 프레임워크**로 차주 사정 · 차량 접근성 · 컴플라이언스 준비도 · 재무 타당성을 표준 포맷으로 수집. 결과는 규제 대응용 감사 가능 데이터가 되고 계정을 다음 액션으로 라우팅한다. **How:** Repossession 레코드 → **Add Assessments** → 템플릿을 type·sub-type으로 검색 → **압류 전체(common assessment)** 또는 **특정 repossession item** 을 대상으로 지정. 제출하면 선택한 템플릿 × 대상마다 assessment가 생성된다. **Where: [AUTO-C&R].** **Who:** 3종 권한 세트 |
| **Submit Pre-Repossession Assessments for Manager Review and Approval**<br>`rn_auto_submit_assessments_manager_review` | 활성 압류로 넘어가기 전 **거버넌스 게이트**. 평가가 모두 끝나면 **Submit for Approval** 이 검토자에게 라우팅. 관리자는 응답별로 코멘트와 함께 accept/reject하고, **반려분은 담당자에게 돌아가 재작성·재제출**된다. 레코드에 승인·반려가 계속 표시돼 의사결정 감사 추적이 남는다. **Where: [AUTO-C&R].** **Who:** `Industries Repossession Management` + **페르소나 권한**(`Repossession Analyst User` 또는 `Repossession Reviewer User`) |
| **Manage and Verify Vehicle Titles Before Repossession**<br>`rn_auto_manage_verify_vehicle_titles` | 압류 전에 **법적 소유권**을 확정. Asset Title과 관련 당사자 전원 추적, 금융 계정 상태 모니터링, 거래·수수료·명의 이전 문의를 단일 뷰에서 해소. **Collateral 탭 → Create Title Verification** 으로 lien·규제 요건 충족 여부를 검증. 업로드한 명의 문서는 **Save and Extract**(문서 데이터 판독) → **Validate Record**(검증된 명의 레코드 생성)로 자동 처리된다. ⚠️ **Agentforce가 켜진 조직에서는** 추출된 명의 데이터에 대한 **자동 검토 결과가 제시되고 담당자가 교차 검증한 뒤 accept / reject / pending** 을 지정한다. **Where: [AUTO-C&R] — 단 자동 문서 검토는 Agentforce 필요.** **Who:** `Industries Repossession Management`(선행 2종) |
| **Capture Recovery Costs with Repossession Item Cost and Cost Books**<br>`rn_auto_capture_recovery_costs` | **Repossession Item Cost** 레코드(이름·cost book·type·status)를 만들고 **cost line item**(예: 표준 cost book에 대한 운송비)으로 쪼갠다. **총액은 cost split에서 자동 계산**돼 repossession item별 회수 비용을 항목별로 본다. **Where: [AUTO-C&R].** **Who:** collections UI에서 회수 비용을 기록하려면 `Industries Repossession Management` 배정. **How:** 차량에서 **Add Repossession Item Cost** → 헤더·cost book 입력 → cost line item(name·type·cost-book entry·product·cost) 추가 → 저장 |
| **Pause and Resume Vehicle Repossession with Hold Management**<br>`rn_auto_pause_resume_repossession_holds` | 활성 압류에 **hold** 를 걸어 집행을 일시 중지. 원문이 든 사유 전수: **payment arrangement · legal proceeding · bankruptcy filing · customer dispute.** hold 레코드가 **사유·기간·승인**의 감사 추적을 보존한다. **How:** **Repossession Workbench 앱**의 압류 레코드에서 hold 설정(사유·예상 기간·해제 조건) → 조건 해소 시 해제해 워크플로 재개. **Where: [AUTO-C&R].** **Who:** 3종 권한 세트 |
| **Assign and Coordinate Repossession Agencies for Vehicle Recovery**<br>`rn_auto_assign_repossession_agencies` | 압류 오더를 **자격을 갖춘 서드파티 에이전시**에 배정하고 회수를 조율. 배정하면 **담당 에이전시·위치·상태**가 레코드에 표시되고 배정 상태·협업·감사 추적이 유지된다. **How:** 활성 압류 중 Repossession Item에서 **Assign Agency** → 회수 에이전시 검색·선택 → 제출. **Where: [AUTO-C&R].** **Who:** 3종 권한 세트 |
| **Track Vehicle Locations During Repossession with Telematics**<br>`rn_auto_track_vehicle_locations_telematics` | **asset·vehicle telematics 이벤트**에서 **타임스탬프가 붙은 위치 목격(location sighting)** 을 캡처해 자산에 기록 → 회수 조율·컴플라이언스용 위치 이력. **How:** Repossession Workbench 앱에서 차량의 **Asset Location** 레코드 확인. **Where: [AUTO-C&R].** **Who:** 3종 권한 세트 |

#### Adjudicate Warranty Claims (`rn_auto_adjudicate_warranty_claims` 허브 + 리프 3)

허브 원문: 딜러가 제출한 보증 청구를 **수동 또는 자동 프로세스**로 판정한다. 결함 자산과 **causal part** 를 조사하고 보증 커버리지를 확인하며 **labor operation · 부품 교체 · 비용** 을 검증한다. 커버리지별 상세 지급 정보 추적과 다중 이해관계자 연결이 가능하고, **Scoring Framework의 approval-likelihood 예측**(과거 승인 청구 기반 점수)으로 판정을 가속한다.

| 항목 | 내용 |
|---|---|
| **Capture Every Cost Behind a Warranty Claim**<br>`rn_auto_capture_warranty_claim_costs` | **Claim Coverage Payment Detail** 레코드로 교체 부품·작업 시간·발생 비용을 추적하고, 판정자가 지급 상세별 **adjusted amount** 를 정밀하게 산정. **How:** claim coverage에서 Claim Coverage Payment Detail 생성 — charge type은 **Expense · Labor · Replaced Part**. **Where: [AUTO-EUD]** |
| **Keep Every Claim Stakeholder in One Place**<br>`rn_auto_keep_claim_stakeholders` | **Claim Participant** 레코드로 **claimant · legal expert · involved driver** 등 다수 이해관계자를 청구에 연결해 판정 중 추가 정보·설명을 요청. **Where: [AUTO-EUD]** |
| **Accelerate Automotive Warranty Claim Adjudication with Agentforce**<br>`rn_auto_accelerate_warranty_adjudication_agentforce` | **Warranty Claims Adjudication Assistant** — 큐 물량·aging·미결 책임(pending liability)을 요약하고 미결 청구를 **가치·경과일·복잡도**로 랭킹. **중복 시리얼 번호·반복 자산 고장 같은 부정 리스크를 플래그**하고, 누락 필드·커버리지·첨부를 감사하며, 판정자가 보낼 **RFI(Request for Information) 초안**을 작성한다. 원문 명시: *"Human experts stay in full control of every decision."* **Where: [AUTO-AF].** **Who:** `Automotive Foundation User` · `Claims Management Foundation` · `Warranty Lifecycle Management` 권한 세트. **How:** Agentforce 패널에서 발화 입력(예: *"Show claim history for Acme Motors."*). **Slack에서도** `Warranty Claims Adjudication for Slack` 템플릿으로 작업 가능 |

#### Agentforce for Automotive (`rn_auto_agentforce_for_automotive` 허브 + 리프 2)

| 항목 | 내용 |
|---|---|
| **Create Agents for Automotive in the New Agentforce Builder**<br>`rn_auto_create_agents_new_agentforce_builder` | **Agentforce Studio의 새 Agentforce Builder** 로 이전된 자동차 에이전트 3종: **Asset Service Management · Sales Concierge Agent(SCA) · Dealership Navigator**. 새 빌더는 **guided setup · 내장 AI 지원 · Agent Script 기반 워크플로**를 제공하고 **preview · test · trace · debug** 를 지원한다. **나머지 자동차 에이전트는 이후 릴리즈에서 이전**된다. ⚠️ **기존 에이전트는 영향받지 않는다** — 조직에 이미 있는 에이전트는 계속 편집·활성화·관리 가능. **Where: [AUTO-AF].** **How:** Agentforce Studio 앱 **Agents 탭 → New Agent** (템플릿에서 만들거나 AI 지원으로 커스텀 빌드) |
| **Help Customers Buy Vehicles with the Sales Concierge Agent on Your Website**<br>`rn_auto_extend_automotive_sales_concierge_experience_cloud` | Sales Concierge Agent가 **Experience Cloud 사이트의 로그인 고객**을 지원 — 차량·액세서리 검색, 견적 요청, 시승 예약, **trade-in 감정 개시**, 판매 질의 응답을 자연어로. **Where:** Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + Agentforce for Automotive 애드온 또는 Agentforce 1 Automotive Edition (⚠️ 다른 [AUTO-AF] 항목과 달리 **Developer 포함**). **Who:** **인증된 Customer Community Plus 사용자만** — **게스트 사용자는 미지원**. **How:** `Automotive Sales Concierge for Customers` 에이전트 템플릿을 embedded messaging과 함께 사이트에 배포. **고객은 로그인으로 신원을 검증한 뒤에야 계정 특정 액션이 노출된다** |

#### 설정·데이터 모델

| 항목 | 내용 |
|---|---|
| **Set Up Automotive Features with a Single Click**<br>`rn_auto_set_up_features_single_click` | **Salesforce Go**에서 Agentforce Automotive **사전 구성 솔루션**을 원클릭 설치 — 설정 자동 활성화 + **샘플 데이터 적재**. 제공 솔루션 전수: **Connected Vehicle**(Actionable Event Orchestration 템플릿 + **Remote Actions — Door Lock/Unlock · Send Notifications**) · **Service Process Templates**(**Payment Deferral · Due Date Change**). **Where:** Lightning Experience · **Enterprise·Performance·Unlimited** + Agentforce Automotive. **Who:** 자동차 기능을 설정·구성하는 관리자. **How:** Setup → Salesforce Go → **Initial Setup 탭** → Automotive로 필터 → 솔루션 선택 → Install → 설치 후 배포 컴포넌트 검토 및 기능 페이지 검증 |
| **New and Changed Objects for Automotive Cloud**<br>`rn_auto_new_and_changed_objects` | **신규 오브젝트 11 + 변경 2 전수** (아래) |

**신규 오브젝트·이벤트 (원문 전수 11건)**

| 오브젝트/이벤트 | 용도(원문) |
|---|---|
| `Asset Data Sharing Participant` | 자산에 대한 참가자(사용자·그룹)의 **역할** 정보 저장 |
| `CollectionPlanMilestone` | collection plan 라이프사이클의 **이벤트** 추적 |
| `RepossessionItemVendor` | repossession item을 처리할 **서드파티 파트너 조직** 배정 |
| `RepossessionItemUser` | repossession item에 배정된 **개별 직원** 추적 |
| `AssetLocation` | 압류 자산의 **타임스탬프 위치 목격** 기록 |
| `RepossessionItemProcessHold` | repossession item의 회수 활동 **일시 중지·유예(stay)** |
| `ContactTracking` | 압류 프로세스와 연결된 **연락처** 추적 |
| `AssetTelematicsActnblEvnt` *(이벤트)* | **자산 텔레매틱스 데이터**에서 비동기 이벤트 트리거 |
| `VehicleTelematicsActnblEvnt` *(이벤트)* | **차량 텔레매틱스 데이터**에서 비동기 이벤트 트리거 |
| `RepossessionNoticeRule` | 압류 컴플라이언스 프레임워크의 **법적 통지 요건 구성** |
| `RepossessionNoticeLog` | 압류 중 발송된 법적 통지의 **감사 가능 증거** 유지 |

**변경 오브젝트 (원문 전수 2건)**

| 오브젝트 | 변경 |
|---|---|
| `Vehicle` | 신규 필드 **External System Vehicle Identifier** — 외부 시스템의 차량 고유 식별자 |
| `AssetTitle` | **명의 검증 상세**를 저장하는 신규 필드들 |

### Communications (38건 전수)

Winter '27 Communications는 **네 개의 컨테이너**로 갈린다 — **Agentforce for Enterprise Quoting** · **Communications Insights** · **Enterprise Sales Management(ESM)** · **Revenue Cloud for Communications**(그 안에 Promotions와 Consumer Sales가 다시 하위 컨테이너로 들어간다). 산업 랜딩(`rn_communications_cloud`)은 덤프가 절단됐지만 **잘린 부분이 월별 change log stub** 이라 기능 손실은 없다(위 `### Tier 상세 안에서도 부분 추출인 페이지 4개` 참조).

**Where 약칭**

| 약칭 | 원문 Where |
|---|---|
| **[ESM]** | Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Enterprise Sales Management** |
| **[CCA]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Communications Cloud Advanced** |

> ⚠️ **약칭에서 벗어나는 3건** — ① `rn_comms_generate_amendment_orders_from_assets_with_the_amend_api` 는 **Enterprise·Performance·Unlimited·Developer + Communications Cloud Advanced**(같은 Consumer Sales 계열인데 Performance가 더 있다) ② `rn_comms_set_up_features_faster_salesforce_go` 는 **Enterprise·Unlimited·Developer + Revenue Cloud for Communications**(제품명이 Communications Cloud Advanced가 아니다) ③ `rn_comms_track_revenue_with_sales_insights` 는 **에디션을 아예 명시하지 않고** *"Lightning Experience in Agentforce for Communications and Communications Cloud Advanced"* 라고만 쓴다.

#### Enterprise Sales Management (`rn_comms_esm_operations_updates` 허브 + 리프 14) — 전부 [ESM]

| 항목 | 내용 |
|---|---|
| **Access All Pricing Tools from One Place**<br>`rn_comms_access_all_pricing_tools` | ESM **Summary 페이지의 통합 Pricing Controls 모듈**에 quote-level 할인과 line-level 가격 조정을 한자리에. 탭으로 **quote-level / order-level**(카트 전체에 적용되는 할인·프로모션)과 **line-level**(특정 quote line item 조정)을 전환. **advanced selection mode** 로 선택한 라인에만 일괄 조정 적용. 가격 조정 생성 시 **discount / upcharge 를 직접 선택**하므로 **음수 부호를 수동 입력할 필요가 없다**. 할인 패널 간 가격 서식 일관화. ⚠️ **원문 How가 스크린샷 참조뿐** — *"The following screenshot shows the Pricing Controls module on the Summary page."* (원문에 이미지 있음, 이 노트에는 텍스트 설명만) |
| **Process Large Quotes at Scale with Enhanced Enterprise Sales Management Capabilities**<br>`rn_comms_process_large_quotes_at_scale` | **수백 개 번들·수천 개 라인 아이템** 규모 견적을 리소스 한도·세션 타임아웃 없이 처리. **백그라운드 클로닝**이 대량 아이템 세트를 용량 제약 없이 복제하고, **trimmed cart retrieval** 이 페이로드 크기를 줄여 리소스 한도 오류를 없앤다. **How:** `cloneItems` API에 **`noResponseNeeded: true`** 플래그를 쓰고 `getCartItems` API에서 **trim response 옵션**을 켠다. `b2bSampleAppCard` 에서는 **`b2bOfferConfig` · `b2bQuoteSummaryConfig` · `b2bOrderSummaryConfig`** 의 `getCartItems` 파라미터를 갱신 |
| **Distinguish Blocking Errors from Bypassable Warnings in Your Working Cart**<br>`rn_comms_distinguish_cart_errors_warnings` | working cart가 **필수 차단 오류와 경고를 색으로 분리** — **빨강 = 제출을 막는 오류**, **주황 = 확인 후 우회 가능한 경고**. 알림은 **카트 수준과 라인 아이템 수준 양쪽**에 뜨고, 배너가 알림 개수를 보여주며 펼치면 영향받는 제품으로 연결된다. 경고를 확인하면 불완전한 구성 상태로 진행할 수 있다. ⚠️ **원문 How가 스크린샷 참조뿐** |
| **Disconnect Bundle Products with Accurate Cart Updates in Enterprise Sales Management**<br>`rn_comms_disconnect_bundle_products` | 주문 수정 중 번들에서 **자식·손자 제품을 disconnect** 해도 카트가 남은 제품을 **중복 없이 정확히** 표시. **설정이 필요 없다**(*"with no configuration required"*). MACD 트랜잭션 후 제품 목록을 수동 검증할 필요가 사라진다 |
| **Run Custom Logic After Multi-Site Copy Completes**<br>`rn_comms_custom_logic_after_multi_site_copy` | multi-site copy가 **끝난 뒤에만** 커스텀 후처리(외부 가격 웹서비스 호출·판매자 통지·커스텀 오류 처리)를 실행. **이전엔 비동기 작업이 복사 완료를 기다리지 않고 Batch Job ID를 즉시 반환해 후처리가 조기 실행돼 실패**했다. **How:** ESM API로 **multi-site configuration batch 프로세스의 신규 post-hook** 에 연결 — 배치 완료 후 자동 실행 |
| **Convert Customer Assets to Enterprise Orders Directly in Enterprise Sales Management**<br>`rn_comms_convert_customer_assets_to_orders` | 자산을 엔터프라이즈 주문으로 전환해 **MACD(move · add · change · disconnect) 전 플로우**를 처리. Account 페이지의 **Asset Viewer** 에서 자산을 골라 새 주문을 만들거나 기존 주문에 추가. **작은 선택은 즉시, 큰 선택은 구성 가능한 임계값에 따라 비동기 처리.** ⚠️ **How: Setup → Custom Permissions 에서 `ESMAddAssetInEnterpriseOrder` 커스텀 권한을 사용자 권한 세트 또는 프로필에 활성화해야 한다** |
| **Deep Clone Source Orders in Activated Status**<br>`rn_comms_deep_clone_activated_source_orders` | **Activated 상태 소스 주문**을 deep clone invocable action으로 재생성 — **이전엔 activated 상태 소스 주문에 deep clone을 쓸 수 없었다.** 복제된 주문은 **모든 라인 아이템·가격 오버라이드·계층 관계를 유지**하고 상태는 **Draft**. **How:** **CME 관리형 패키지의 `Clone Record` invocable action** 호출 — 오브젝트·관계·처리 모드를 정의한 JSON 페이로드 전달. **작은 잡은 동기, 큰 잡은 비동기 처리** |
| **Route Users Where They Need to Be with Context-Aware Custom Notifications**<br>`rn_comms_context_aware_bell_notifications` | 커스텀 알림이 **정확한 내비게이션 의도**를 담아 클릭 시 특정 목적지로 바로 이동 — **quote summary 탭 · ESM summary · ESM location · 커스텀 링크**(원문 표기는 *"ESM loaction"* 오타 그대로). **How:** 노출된 API로 목적지 컨텍스트를 식별하는 메타데이터를 포함해 알림 발송 → 클릭 시 알림 프레임워크가 메타데이터를 해석해 설정된 페이지·탭을 연다. 비표준 UI 라우팅이 필요하면 메타데이터 규약을 확장 |
| **Apply a Bundle Configuration Across Matching Quote Line Items**<br>`rn_comms_apply_bundle_configuration` | 번들을 **한 번 수정해 엔터프라이즈 견적 전체에 적용** — 여러 위치에 동일 제품이 있는 대형 견적의 갱신을 단순화. ⚠️ **How: Setup → Quick Find `CPQ Configuration Setup` → `enableApplyConfigToMatchingLines` 를 `true` 로 설정**해야 한다. 그다음 Summary 탭에서 번들을 working cart로 옮기고 구성을 수정한 뒤 적용하면 **동일 Product ID를 가진 quote line item이 위치를 가로질러 교체**된다 |
| **Protect Quote and Order Consistency with a UI Loader for Asynchronous Processes**<br>`rn_comms_ui_loader_asynchronous_processes` | 비동기 대량 처리 중 quote·order 페이지에 **차단형 로더** 표시 — **다른 브라우저 탭·세션·에이전트·API 호출에서 처리가 시작된 경우에도** 표시된다. 처리 중 상호작용을 막아 충돌 편집·부분 상태를 예방. **로더는 사용자가 구성한 플랫폼 이벤트로 활성화되며 데이터 모델 변경이 필요 없다.** ⚠️ **How: CPQ Configuration Setup에서 `ESMUILoaderEnabled` 를 `true` 로 설정** |
| **Navigate High-Volume Enterprise Sales Management Records with Number-Based Pagination**<br>`rn_comms_number_based_pagination` | **Locations·Summary 탭**의 대형 location·subscriber 데이터셋을 **번호 기반 페이지네이션**으로 탐색 — 기존 UI 동작과 오류 처리 패턴을 보존한 채 수천 건 이동. 커스텀 구현은 기존 페이지네이션 UI 패턴을 유지하면서 백엔드 개선만 취할 수 있다. ⚠️ **How: Setup → `CPQ Configuration Setup` → `ESMBulkPaginationEnabled` 를 `true` 로 설정** |
| **Provide Clear Feedback on Cart Operations with Transient Messages**<br>`rn_comms_transient_cart_messages` | quote line item 갱신 시 **warning·error·success 커스텀 메시지**를 즉시 표시. **cardinality · attribute · validation · pricing 오류**가 나면 담당자는 상세를 보고 카트를 계속 수정할 수 있지만 **모든 오류를 해소하기 전엔 카트를 제출할 수 없다**. **How:** **pre-hook**으로 요청을 검증·차단하거나 **post-hook**으로 페이로드를 보강 — 이 훅으로 **`multiEditCartItems` API 응답의 `messages` 배열**을 채운다 |
| **Einstein Quick Quote for Enterprise Sales Management Is Retired** ⛔<br>`rn_comms_einstein_quick_quote_retired` | **Winter '27에서 은퇴** — 더 이상 제공되지 않는다 |
| **Contract Option in Custom Discount Allocation Type Settings Is Retired** ⛔<br>`rn_comms_contract_discount_allocation_retired` | **Custom Discount Allocation Type 설정의 Contract 옵션**이 ESM에서 제거. **Winter '27 은퇴** |
| **Sort Functionality on the Product Catalog Is Retired** ⛔<br>`rn_comms_product_catalog_sort_retired` | **Product Catalog의 정렬 기능**이 ESM에서 제거. **Winter '27 은퇴** |

#### Agentforce for Enterprise Quoting (`rn_comms_enterprise_quote_automation_container` 허브 + 리프 2) — 전부 [ESM]

| 항목 | 내용 |
|---|---|
| **Build and Manage Quotes with Invocable Actions in Enterprise Sales Management**<br>`rn_comms_build_validate_quotes_invocable_actions` | 견적·quote member 생성, quote/order 카트에 제품 추가, working cart의 구성 적용, quote line item의 제품·속성 상세 조회, **자산의 일괄 견적 전환**을 invocable action으로. **How:** App Launcher → **Flows** → autolaunched flow 생성 → invocable action을 **Apex Action 요소**로 캔버스에 추가 → **Agent builder에서 이 플로우를 reference source로 선택**해 Agent Action에 통합 |
| **New Invocable Actions in Enterprise Sales Management**<br>`rn_comms_new_invocable_actions_in_enterprise_sales_management` | **신규 invocable action 5종 전수** — `b2bCmexCreateQuote`(기존 opportunity ID 지정 또는 opportunity 필드로 신규 생성) · `b2bCmexCreateQuoteMembers`(다중 quote member 생성, **중복 검사 옵션**) · `b2bCmexAddProductsToCart`(속성·member·group 지원) · `b2bCmexGetQliProductDetails` · `b2bCmexAssetToQuoteInBatch`(자산을 quote line item으로 일괄 전환 + quote member 생성) |

#### Communications Insights (`rn_comms_communications_insights_container` 허브 + 리프 1)

| 항목 | 내용 |
|---|---|
| **Track Revenue Execution Across Your Pipeline with Communications Sales Insights**<br>`rn_comms_track_revenue_with_sales_insights` | opportunity·quote·order 전반의 수익 파이프라인 실시간 가시성. **closed-won 수익 추적**, **정체된 견적과 주목이 필요한 고액 딜 식별**, **실패한 주문·활성화 이슈 같은 운영 리스크 탐지**. **Where: 에디션 미명시 — Agentforce for Communications + Communications Cloud Advanced.** **Who:** 설정에는 **System Administrator 프로필**, 분석 조회에는 **Data Cloud User 라이선스 + Tableau Next Consumer 라이선스**. **How:** Setup → Communications Cloud → **Services Setup** → **Data Cloud Configurations** 섹션에서 `Data Cloud Salesforce Connector` 권한 세트 배정 + 데이터 스트림 생성 → **Communications Sales Insights** 섹션에서 **Sales Insights App 설치** → 앱의 대시보드에서 분석 확인 |

#### Revenue Cloud for Communications (`rn_comms_revenue_cloud_for_communications_on_salesforce_platform` 허브)

**설정·컨텍스트**

| 항목 | 내용 |
|---|---|
| **Set Up Revenue Cloud for Communications Features Faster with Salesforce Go**<br>`rn_comms_set_up_features_faster_salesforce_go` | **완전 자동 설정** — **Product Discovery 설정이 자동 구성**돼 초기 설정의 수동 단계가 사라진다. Salesforce Go 솔루션으로 **멀티사이트용 location-based pricing**, 제품 카탈로그·pricing procedure·커스터마이즈 가능한 프로모션을 설정. **Where: Enterprise·Unlimited·Developer + Revenue Cloud for Communications.** **How:** 기어 메뉴 또는 Setup 메뉴 → Salesforce Go → 기능명 검색 |
| **Update Your Context Definition to `ConsumerSalesContext`**<br>`rn_comms_update_your_context_definition_to_consumersalescontext` | ⚠️ **마이그레이션 작업** — **이전엔 pricing procedure와 rule library가 `SalesTransactionContext` context definition의 확장을 참조**했다. 이제 **`ConsumerSalesContext` context definition 확장**으로 **갱신해야 한다**. **Where: [CCA]** |

**Promotions in Revenue Cloud for Communications** (`rn_comms_promotions_in_revenue_cloud_for_communications` 허브 + 리프 3) — 전부 **[CCA]**

| 항목 | 내용 |
|---|---|
| **Define Promotional Compatibility with Advanced Stackability Rules**<br>`rn_comms_define_promotional_compatibility_stackability` | 같은 제품에 **어떤 프로모션이 공존할 수 있고 어떤 우선순위로 적용되는지** 정의. 프로모션을 **group·subgroup** 으로 묶고 **평가 기준(evaluation criteria)** 으로 **여러 프로모션이 스택되는지, 아니면 첫 번째 적격 프로모션만 적용되는지** 결정. 호환되지 않는 오퍼 결합을 막아 캠페인 수익성을 보호하면서 전략적 번들 할인은 허용 |
| **Apply Term-Based Promotions to Boost Sales**<br>`rn_comms_apply_term_based_promotions_boost_sales` | 구독 제품에 **부분 기간 할인**. 원문 예시 전수: **첫 3개월 100% 할인**, **6개월 25% 할인**. **commitment period** 를 설정해 같은 프로모션 재적용이나 **non-stackable 프로모션 결합을 방지**. 시간 기반 조정 내역(breakdown)을 조회하고 구독 라이프사이클 내내 프로모션 가시성 유지 |
| **Drive Customer Engagement with Coupon-Based Promotions**<br>`rn_comms_drive_customer_engagement_coupon_promotions` | 쿠폰 코드를 발행해 사용 시 프로모션 할인 적용. **하나의 프로모션에 여러 쿠폰 코드**를 만들고 **구매자별 또는 전체 구매자 기준 사용 한도(redemption limit)** 를 설정하며 사용량을 추적해 캠페인 범위를 통제 |

**Consumer Sales in Revenue Cloud for Communications** (`rn_comms_consumer_sales_in_revenue_cloud_for_communications` 허브 + 리프 6)

| 항목 | 내용 |
|---|---|
| **Manage Customer Carts in Communications Service Console for Consumer Sales**<br>`rn_comms_manage_customer_carts_in_service_console` | **Communications Service Console에서 직접** 카트 구성을 검증하고 **draft order로 전환**. 제품 호환성·가격 정확성을 확인한 뒤 전환해 편집·체크아웃을 이어간다. **디지털 셀프서비스와 상담원 지원을 잇는다.** **Where: [CCA]** |
| **Delta Pricing Accelerates Recalculations in Carts**<br>`rn_comms_accelerate_cart_performance_delta_pricing` | **delta pricing이 quote·order에 더해 cart까지 확장**. 카트를 수정하면 **변경된 카트 라인과 그 종속 라인만** 재계산하고 카트 전체를 재가격하지 않는다. 라인이 많고 가격 구성이 복잡한 대형 카트의 응답 시간이 크게 준다. **Where: [CCA]** |
| **Enable Customer and Partner Community Access to Consumer Sales Connect API**<br>`rn_comms_enable_customer_and_partner_community_access_to_consumer_sales_connect_api` | Consumer Sales Connect API를 **Customer Community · Customer Community Plus · Partner Community** 사용자에게 확장 — 제품 탐색·오퍼 구성·거래 완료 가능. **Where: [CCA]** |
| **Generate Amendment Orders from Assets with the Amend API**<br>`rn_comms_generate_amendment_orders_from_assets_with_the_amend_api` | 기존 자산에서 **amendment order**를 만들어 속성을 조정하고 프로모션을 적용. **Where: Enterprise·Performance·Unlimited·Developer + Communications Cloud Advanced**(이 절에서 유일하게 Performance 포함) |
| **New and Changed Connect REST APIs for Consumer Sales**<br>`rn_comms_new_and_changed_connect_rest_apis` | **Amend API** — 신규 리소스 **`POST /connect/consumer/initiate-amend`**. 신규 요청 바디 `Amendment Input`, 신규 응답 바디 `Amendment` |
| **New and Changed Invocable Actions in Consumer Sales**<br>`rn_comms_new_and_changed_invocable_actions_in_consumer_sales` | **신규 4종 전수** — `placeSalesTransactionConsuSls`(가격·구성이 통합된 sales transaction 실행 및 라이프사이클 관리) · `getProductDetailsConsuSls`(product ID 기준 개별 제품 또는 번들의 속성·계층·cardinality) · `getProductsConsumerSales`(지정 catalog·category·subcategory의 제품 목록) · `initiateAmendForConsumerSales`(기존 자산에서 amendment cart 또는 order 생성) |

**제품 관계 · 데이터 모델 · API**

| 항목 | 내용 |
|---|---|
| **Define Product Dependencies with Linear Relationships**<br>`rn_comms_define_product_dependencies_linear_relationships` | 제품·분류 간 실제 종속을 **번들로 묶지 않고** 모델링. **`Relies On` 관계 타입**으로 source 제품이 related 제품에 의존함을 지정하고 **각 제품은 자기 가격·기간·라이프사이클을 유지**한다. `Relies On` 규칙이 있는 제품을 견적·주문에 추가하면 시스템이 적격 related 제품에 연결하고, **후보가 여럿이면 선택하라고 프롬프트**한다. 관계는 **quote → order → asset 으로 흐르고 amendment를 거쳐도 지속**된다. **Where: [CCA]** |
| **New and Changed Object for Revenue Cloud for Communications**<br>`rn_comms_new_and_changed_objects_for_rev_cloud_for_comms` | 아래 표 전수 |
| **New Connect REST APIs for Revenue Cloud for Communications**<br>`rn_comms_new_connect_rest_apis` | 아래 표 전수 |

**신규/변경 오브젝트 (원문 전수)**

| 대상 | 변경 |
|---|---|
| **신규 `ProductRelationshipRule`** | 제품 또는 제품 분류 간 **제품 관계 규칙** 지정 |
| `QuoteLineRelationship` | 신규 필드 **`RelationshipAction`** (quote line item 관계 레코드의 관계 액션) · 신규 필드 **`ProductRelationshipRule`** |
| `OrderItemRelationship` | 신규 필드 **`RelationshipAction`** · 신규 필드 **`ProductRelationshipRule`** |
| `AssetRelationship` | 신규 필드 **`ProductRelationshipRule`** |
| `CartItemPriceAdjustment` | 신규 필드 5종 — **`AdjCommitmentEndDateTime` · `AdjEffectiveStartDateTime` · `AdjEffectiveEndDateTime` · `AdjustmentAction` · `AppliedAdjustmentAmount`** (프로모션 benefit 기간·commitment 종료일·액션 타입·적용 조정액) |
| `QuoteLinePriceAdjustment` | 신규 필드 **동일 5종** |
| `AssetActionSrcPriceAdjustment` | 신규 필드 **4종** — `AdjCommitmentEndDateTime` · `AdjEffectiveStartDateTime` · `AdjEffectiveEndDateTime` · `AppliedAdjustmentAmount` (**`AdjustmentAction` 없음**) |
| `OrderItemAdjustmentLineItem` | 신규 필드 **5종** (CartItemPriceAdjustment와 동일) |

**신규 Connect REST API (원문 전수 5종)**

| API | 리소스 · 바디 |
|---|---|
| **Get Product Relationship Rule Details** | `GET /connect/comms-sales/product-relationship-rule/{productRelationshipRuleId}` — 요청 `Product Relationship Rule Id` / 응답 `Product Relationship Rule`. **Note:** 단일 scope 필터로 목록·검색하려면 `/connect/comms-sales/product-relationship-rule` 리소스를 쓰고, **`mainProductId` · `mainProductClassificationId` · `relatedProductId` · `relatedProductClassificationId` 중 하나가 필수** |
| **Manage Product Relationship Rules** | `CRUD /connect/comms-sales/product-relationship-rule/actions/manage` — 요청 `Product Relationship Manage Payload Input` / 응답 `Manage Product Relationships` |
| **Get Linear Relationship Candidates** | `GET /connect/comms-sales/linear-relationships/{lineItemId}/candidates` — 요청 `Linear Relationship Candidates Input` / 응답 `Linear Relationship Candidates Rule`. **Note: 일괄 조회는 `/connect/comms-sales/linear-relationships/candidates`** |
| **Manage Links** | `POST /connect/comms-sales/linear-relationships/actions/manage-link` — 요청 `Manage Links Input` / 응답 `Manage Links` |
| **Get Redeemed Coupons** | `GET /connect/promotions/redeemed-coupons` — **신규 요청 파라미터 `transactionId`(필수)** / 응답 `Redeemed Coupons List Representation` |

### Industries CPQ (공통) — 10건 전수

`rn_industries_configure_price_quote_cpq` 허브가 요약한 이번 릴리즈의 골자: **최대 50,000 라인 아이템 mass discount 지원 · 속성 필터링으로 GetCartItems 응답 경량화 · MultiEdit API의 strict validation 모드 · cart template 적격성 검사 강화 · hidden 속성이 실제로 숨겨지는 구성 경험.**

**Where가 항목마다 다르다 — 원문 그대로 분해**

| 항목 | UI | 에디션 | 패키지·전제 |
|---|---|---|---|
| `..._cloneitems_api` · `..._cart_templates_...` · `..._stability_and_accuracy_...` | **Salesforce Classic + Lightning Experience** | **all editions** | CME 관리형 패키지 |
| `..._optimize_getcartitems_...` | **Classic + Lightning Experience** | **all editions** | CME 관리형 패키지 |
| `..._multiedit_api_...` | Lightning Experience | **all editions** | CME 관리형 패키지 |
| `..._group_cart_bulk_change_...` | Lightning Experience | **all editions** | CME 관리형 패키지 **+ Standard Runtime** |
| `..._mass_discounts_...` | Lightning Experience | **Enterprise·Unlimited·Developer** | CME 관리형 패키지 |
| `rn_runtime_industries_cpq_namespace` | *(원문에 Where 없음)* | — | — |

> **Who 공통:** 전부 **Industries CPQ 라이선스** 보유자. 그중 `..._mass_discounts_` · `..._optimize_getcartitems_` · `..._multiedit_api_` · `..._cart_templates_` · `..._group_cart_bulk_change_` 는 **Standard Cart API를 구성·사용할 권한**이 추가로 필요하고(그중 group cart bulk change만 **Classic + Standard Cart API 양쪽**), `..._cloneitems_api` 는 라이선스만 명시한다.

| 항목 | 내용 |
|---|---|
| **Apply Mass Discounts to Enterprise-Scale Quotes**<br>`rn_cpq_apply_mass_discounts_to_enterprise_scale_quotes_without_system_failures` | **최대 50,000 라인 아이템 · 4,000개 초과 root item** 을 가진 견적·주문에 mass discount 적용 — **이전엔 지정된 한도 때문에 대형 견적에서 실패**했다. **`CPQ_StartMassDiscountExpanded` Integration Procedure** 가 root item을 작은 청크로 슬라이스해 **반복 루핑 카운터로 여러 배치에 걸쳐 백그라운드에서 순차 처리**한다 |
| **Optimize GetCartItems Responses by Filtering Unwanted Attributes**<br>`rn_cpq_optimize_getcartitems_responses_by_filtering_unwanted_attribute_data` | 원하지 않는 속성·속성 카테고리를 카트 데이터에서 제외해 **GetCartItems API 응답을 가볍게** — **가격·검증·적격성에는 영향 없다**. 더 정밀하게는 **Skinnify 방식**으로 애플리케이션이 필요한 속성 메타데이터만 반환하며 **재컴파일이나 데이터 설정이 필요 없다**. 제어 지점 2개: **`QuoteLineItem`·`OrderItem` 의 `GCITrimFieldsToInclude` 필드 세트** 가 각 라인 아이템 루트에 나타날 제품·가격 필드를 결정하고, **`pciFields` URL 파라미터** 가 product child item 필드를 루트 수준에 포함할지 결정한다 |
| **Maintain Data Integrity with MultiEdit API Validation and Pricing Checks**<br>`rn_cpq_ensure_data_integrity_with_multiedit_api_validation_and_pricing_checks` | MultiEdit API 실행 중 **검증·가격 오류가 나면 DB 갱신을 중단**한다. ⚠️ **How: CPQ Configuration Setup에서 `MultiEditStrictValidationMode` 를 켜야 한다** — 기본 동작이 아니다. 가격 계산이나 검증 규칙이 실패하면 **상세 오류 페이로드**를 반환한다. **기존 사용자 통합을 깨지 않고 각자 속도로 이 오류 처리 동작을 채택**할 수 있고, **API posthook 구현으로 메시지 목록에 커스텀 메시지를 추가**할 수 있다 |
| **Maintain Accurate Cart Templates by Validating Product and Promotion Eligibility**<br>`rn_cpq_maintain_accurate_cart_templates_by_validating_product_and_promotion_eligibility` | 견적·주문에 cart template을 저장·적용할 때 **커밋 전에** 제품·프로모션을 검증한다. **검사 항목 전수: orderable · active · context-qualified · 유효 기간(effective date range) 내.** 부적격 제품은 **명확하고 실행 가능한 오류 메시지로 플래그**되고, **price list entry의 유효성 검사**로 유효한 항목만 가격에 적용된다 |
| **Accelerate High-Volume Cloning Operations with the `cloneItems` API**<br>`rn_cpq_accelerate_high_volume_cloning_operations_with_the_cloneitems_api` | `cloneItems` API 요청에 **`noResponseNeeded` 를 `true`** 로 설정하면 **이전에 실패하거나 타임아웃되던 큰 데이터 형태**도 처리된다. **비필수 응답 포매팅을 건너뛰어** 리소스 한도 예외를 없애고 대량 복제를 백그라운드에서 원활히 유지 |
| **Display Only Relevant Attributes during Group Cart Bulk Change Operations**<br>`rn_cpq_display_only_relevant_attributes_in_group_cart_bulk_change_configuration` | Group Cart Bulk Change 중 **Configure 페이지에서 hidden으로 표시된 속성을 실제로 숨긴다** — Group Cart Bulk Change 플로우가 **Industries CPQ의 향상된 LWC Cart와 동일하게** 동작. **How:** Account 페이지의 **Asset Viewer → bulk update 플로우** |
| **New and Changed Objects in CME Managed Package**<br>`rn_cpq_new_and_changed_objects_in_cme_managed_package` | **신규 `DiscountStatus` 오브젝트** — Quote·Order의 카트에 적용된 할인 상태 조회. **`Attribute`·`Attribute Category` 오브젝트의 신규 `ShouldIncludeInTrimMode`** — 해당 속성이 **GetCartItems Trim 모드 응답에 포함되는지** 표시. ⚠️ **기본값은 선택(Selected)** 이며, 최종 API 응답에서 빼려면 체크를 해제한다 |
| **Stability and Accuracy Enhancements for CME Managed Package**<br>`rn_cpq_stability_and_accuracy_enhancements_for_cme_managed_package` | **원문이 나열한 개선 7건 전수** (아래) |
| **`runtime_industries_cpq` Namespace**<br>`rn_runtime_industries_cpq_namespace` | **product discovery·selection의 제품 변형(variation)** 지원 Apex 표면. **원문에 Where 없음** (아래 표 전수) |

**Stability and Accuracy Enhancements — 원문 7건 전수** (Where: Salesforce Classic + Lightning Experience · **all editions** · CME 관리형 패키지)

1. **cart 로직** — 한 오퍼가 disconnect돼도 **남은 오퍼에 대해 공유 프로모션이 활성 상태로 유지**된다(동시 수정 중 의도치 않은 비활성화 방지).
2. **basket-to-cart API 플로우** — disconnect된 프로모션이 정확히 처리돼 **disconnected Order Price Adjustment 레코드로 변환**되고, **새 프로모션으로 잘못 재적용되지 않는다**.
3. **Search Template API** — **Tag ID와 Tag Value 양쪽으로 필터링** 지원. search·filter·sort 파라미터가 검증에 실패하면 **전체 레코드를 반환하는 대신 명확한 오류를 반환**한다.
4. **Delete Template API** — **safe-by-default** 워크플로 강제. **API 호출에 `ForceDelete` 파라미터를 명시하지 않는 한 Approved Template의 강제 삭제를 막는다.**
5. **`EPCProductAttribJSONBatchJob`** 실행 시 **큰 속성 세트 관리와 오퍼 교체**가 **field length 오류·null pointer 실패 없이** 동작.
6. **GetOffers·GetOfferDetails API** — **V2 Attribute Model이 켜져 있으면** `JSONAttribute__c` 가 null이어도 **`AttributeCategory` 노드를 일관되게 반환**.
7. **delta deployment** — **프로모션 속성 오버라이드가 있는 제품을 독립적으로 배포** 가능. 후처리가 **연결된 프로모션을 포함하지 않아도 override ID 참조를 자동 재구성**한다.

**`runtime_industries_cpq` 네임스페이스 — 원문 전수**

| 구분 | 항목 |
|---|---|
| **신규 클래스 3** | `ProductVariantAttributeSetOutputRepresentation`(제품의 variation attribute set 상세) · `ProductVariantAttributeOutputRepresentation`(set 안의 variation attribute 상세) · `ProductVariantAttributeValueOutputRepresentation`(variation attribute 값 상세) — 모두 **생성자와 프로퍼티** 제공 |
| **`productClass`** (제품의 variation class) | 기존 클래스 **6개**에 추가: `ProductDetailsRepresentation` · `ProductOutputRepresentation` · `ProductListRepresentation` · `BulkProductDetailsRepresentation` · `SearchProductsRepresentation` · **`GuidedSelectionRepresentation`** |
| **`childVariationIds`** (자식 변형) | 기존 클래스 **5개**: `ProductDetailsRepresentation` · `ProductOutputRepresentation` · `ProductListRepresentation` · `BulkProductDetailsRepresentation` · `SearchProductsRepresentation` (**`GuidedSelectionRepresentation` 없음**) |
| **`variationAttributeSet`** | 기존 클래스 **5개** (위 `childVariationIds` 와 동일 목록) |
| **`variationsCount`** (제품의 변형 개수) | 기존 클래스 **2개**: `ProductListRepresentation` · `SearchProductsRepresentation` |
| **`productCategories`** | 기존 클래스 **1개**: `SearchProductsRepresentation` |
| **`sequence`** (attribute category의 순서) | 기존 클래스 **1개**: `AttributeCategoryOutputRepresentation` |

> 상시 레퍼런스는 *Revenue Management Developer Guide: Product Discovery Apex Reference*. Apex 일반 변경은 이 노트 소관이 아니다 → [[Winter '27/Development]].

### Consumer Goods — Retail Execution · Trade Promotion Management (8건 전수)

산업 랜딩(`rn_consumer_goods_cloud`)이 밝힌 축은 셋 — **Retail Execution · Trade Promotion Management · Visual Studio Code Based Modeler**. 랜딩 원문은 **Consumer Goods Release Note Changes by Month** 에 *"August 2026 | No changes since the initial publication."* 라고만 적혀 있다.

**Where 약칭** — TPM 3건은 에디션 목록이 **미묘하게 다르다**(원문 그대로).

| 약칭 | 원문 Where |
|---|---|
| **[CG-TPM4]** | Lightning Experience · **Enterprise · Unlimited · Einstein 1 · Agentforce 1** + Consumer Goods Cloud **Trade Promotion Management** |
| **[CG-TPM3+]** | Lightning Experience · **Enterprise · Unlimited · Einstein 1** editions, **and Agentforce 1 editions** + Consumer Goods Cloud Trade Promotion Management *(원문이 Einstein 1까지를 한 묶음으로, Agentforce 1을 따로 적는다 — `rn_tpm_user_experience_enhancement` 전용)* |
| **[CG-MOBILE]** | **Consumer Goods Cloud 모바일 앱(iOS·Android)** · **Enterprise · Unlimited · Einstein 1 · Agentforce 1** |

#### Retail Execution (랜딩 요약)

랜딩이 밝힌 범위: 배송 중 **선주문 수량 조정 · 제품 추가/스캔 · 현금 또는 부분 결제 수납**. **hybrid user persona** 로 배송 업무와 방문 활동(매장·선반 컴플라이언스 점검, 리테일 주문 생성)을 함께 수행. **mobile linking** 으로 CG 모바일 앱↔외부 앱 양방향 데이터 공유. **3인치 Bluetooth 감열 프린터** 문서 출력, **LWC 통합**으로 플랫폼 기능 사용.

> 이 문단은 산업 랜딩 페이지가 담은 요약이다 — Retail Execution 개별 리프는 Winter '27 Clouds 페이지 목록(988건)에 별도 page id로 등재되지 않았다.

#### Trade Promotion Management (4건)

| 항목 | 내용 |
|---|---|
| **Customize Trade Planning Pages with a Developer API**<br>`rn_tpm_customize_trade_pln_pages` | **Lightning Web Component API** 로 Trade Calendar·Account Plan **헤더**를 조정. **핵심 로직을 교체하거나 대규모 Apex 변경 없이** 익숙한 워크플로를 보존한다. 가능한 것 전수: **header·toolbar slot 커스터마이즈**, **toolbar 버튼 노출 제어**(관리형 코드 수정 없이), **state-change 이벤트 수신**으로 페이지 변경에 반응, **그리드 새로고침·프로모션 생성 프로세스의 프로그래밍 방식 트리거**. **Where: [CG-TPM4].** **How:** Trade Planning 컴포넌트를 감싸는 **커스텀 래퍼 컴포넌트**를 만들어 state-change 이벤트를 수신하고 공개 메서드를 사용 → Lightning App Builder로 Lightning 페이지에 배포. ⚠️ **이전에 Trade Planning 페이지를 복제(clone)해 쓰던 조직은 업그레이드 후 복제 페이지에서 사라진 header region을 자기 래퍼로 교체해야 한다** |
| **Support More Product Category Share Records**<br>`rn_tpm_trade_calendar_product_category_share_record_support` | Trade Calendar가 **한 사용자에 대해 더 많은 Product Category Share(PCS) 레코드**를 로드. **optimized category-loading 설정**을 켜면 지원 상한이 **13,000 assignment** 가 되고 **초과 시 메시지를 표시**한다. **이전엔 원인 표시 없이 페이지 로드가 실패하기도 했다.** **Where: [CG-TPM4].** ⚠️ **How: 관리자에게 `Enable_Optimized_PCS_Read` 시스템 설정 구성을 요청**해야 한다. **언제든 데이터 마이그레이션이나 스키마 변경 없이 끌 수 있고**, **Trade Calendar의 Smart UI 두 버전 모두에 자동 적용**되며 **사용자 접근 권한은 바뀌지 않는다 — 데이터 로드 방식만 바뀐다** |
| **Manage Trade Promotions with User Experience Enhancements**<br>`rn_tpm_user_experience_enhancement` | **자동 적용 3종** — ① **Promotion Information · Tactic Information · Create Promotion 마법사**의 숫자 필드가 **로케일에 맞춰짐** ② **Promotion Comment** 같은 장문 텍스트 필드의 **줄바꿈·확장** ③ **Volume Planning·Spend Planning 카드의 Collapse All 그리드 액션을 원클릭으로 되돌리기**. **Where: [CG-TPM3+]** |
| **Changed Apex Class in Trade Promotion Management**<br>`rn_tpm_abort_job_chain` | **Apex에서 실행 중인 job chain을 직접 중단** — *"Abort Runaway Job Chains Without Filing a Support Case"*. job chain은 대체로 순차 처리되므로 예약 잡이 우발적으로 급증하면 업무 필수 잡 앞에 쌓여 **큐가 하루 넘게 걸릴 수 있다**. ⚠️ **중요한 제약 3가지:** ① **off-platform 서비스가 잡이 자기 조직 소유인지 검증**하므로 **자기 조직 잡만 중단할 수 있다** ② **중단은 처리를 즉시 멈추지만 종료된 실행의 Batch Run Status는 갱신하지 않는다** ③ 새 잡을 예약하면 새 job chain이 정상 시작된다. **How:** Apex에서 **`OffPlatformCallout` global entry point** 호출 → 먼저 **`JOBCHAINWORKER_ABORT_GET_JOB_ID`** 리소스로 해당 sales org의 실행 중인 **JobChainWorker Kubernetes job ID**를 요청 → 그 job ID를 **`JOBCHAINWORKER_ABORT_DELETE_JOB`** 리소스에 전달. **두 리소스 모두 관리형 패키지와 함께 제공되는 `Off_Platform_Endpoint_Map__mdt` 레코드를 통해 라우팅되므로 별도 설정이 필요 없다** |

#### Visual Studio Code Based Modeler (`rn_retail_vscode_modeler` 컨테이너 + 리프 1) · Windows Modeler 은퇴

| 항목 | 내용 |
|---|---|
| **Enable External Browser Login for Consumer Goods Cloud Mobile**<br>`rn_retail_vs_code_modeler_external_browser_login` | 모바일 앱 인증을 **표준 embedded WebView가 아니라 기기의 시스템 브라우저**로 수행. **WebView로는 불가능한 최신 엔터프라이즈 보안 요건 전수: Microsoft Intune Conditional Access SSO · FIDO2/Passkeys · 생체 로그인.** **Where: [CG-MOBILE].** **How:** Setup → Quick Find **My Domain** → **Authentication Configuration** → **Use the native browser for user authentication** 을 iOS·Android 또는 양쪽에 선택. **다음 로그인부터 적용.**<br>⚠️ **Note 전수 — 연결 앱 유형에 따라 절차가 갈린다.** **기본 connected app**: 앱을 내려받거나 업데이트하고 위 인증 설정만 하면 되며 **삭제·재설치가 필요 없다**. **커스텀 connected app**: ① 콜백 URL **`cgcloud://oauth/success`** 를 connected app 구성에 추가 ② **sync package를 264로 업데이트**(하지 않으면 **콜백 URL 검증이 실패**한다) ③ QR 코드 갱신 ④ **모바일 앱을 삭제하고 재설치**해야 새 구성이 동작한다. **MDM·Intune 배포**에서는 MDM 앱 구성 정책에 **`cgcloud://` URL scheme을 allowlist** 해야 한다 |
| **Plan for Windows Server Based Modeler's Retirement** ⛔<br>`rn_retail_windows_modeler_retirement` | **Windows Server 기반 Modeler는 Winter '26(2025년 10월) 은퇴 예정**이며 그때까지 유지보수 모드. **VS Code 기반 Modeler** 로 전환 권고 — 별도 Windows 서버·DB 없이 동등한 모델링을 제공하고 **Salesforce CLI에 완전 통합된 Consumer Goods Cloud Modeler CLI 플러그인**을 포함한다(계약 검증 · 커스텀 앱 빌드 · **커스텀 CG Cloud 오프라인 모바일 앱을 로컬 머신에서 시뮬레이션** · 배포 패키지 생성). ⚠️ **은퇴의 실제 파급: MCP(Modeler Contract Packages) · MUP(Modeler Update Packages) · FUP(Framework Update Packages) 가 제공되지 않는다.** 마이그레이션은 *Migrate Windows Server Based Modeler Contracts to Visual Studio Code Based Modeler* 참조 또는 Salesforce 문의 |

### Education (Agentforce Education, 구 Education Cloud) — 18건 전수

**Where 약칭**

| 약칭 | 원문 Where |
|---|---|
| **[EDU]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Education Cloud 라이선스 활성** |
| **[EDU-FIN]** | [EDU] 에디션 + **Education Cloud · Revenue Cloud Advanced · Revenue Cloud Billing** 라이선스 3종 활성 |

> **Who 기본형:** `Education Cloud Full Access` 권한 세트. 학생·지원자 쪽은 `Education Cloud for Experience Cloud`(원문 일부는 `Education Cloud Experience Cloud`로 표기). 아래에서 이보다 넓은 조합이 필요한 항목은 개별 표기했다.

#### 모집·입학 (Recruitment and Admissions)

| 항목 | 내용 |
|---|---|
| **Track the Complete Student Journey with the Recruitment and Admissions Funnel**<br>`rn_edu_track_student_journey_with_rcrt_adms_funnel` | **Tableau Next Recruitment and Admissions Performance Center** 대시보드가 **Suspect · Prospect · Applicant · Admitted · Enrolled · Registered** 6단계의 **규모 · 전환율 · 단계 속도(stage velocity)** 를 추적. ⚠️ **Where: [EDU] 에디션 + 라이선스 3종 — Education Cloud · Data 360 · Tableau Next.** **Who(설치):** `Education Cloud Full Access` + `Data Cloud Architect` + **`Tableau Unmetered Admin` 또는 `Tableau Next Admin`**. **Who(조회):** `Education Cloud Full Access` + **적절한 Tableau Next 권한 세트와 그것이 요구하는 Data 360 권한 세트**(원문: 자기 조직의 Tableau Next 권한 세트가 무엇인지는 **Salesforce Customer Support에 문의**) |
| **Configure and Localize the Dynamic Application Experience**<br>`rn_edu_localize_dynamic_application_data` | Application List·Application Details 페이지에서 **Campus · Academic Term · application deadline** 같은 필드를 노출/숨김하고 **라벨을 override**, **진행 바 노출 제어**, 합격 결정 직접 링크 제공. **How(구성):** **Experience Builder**에서 해당 페이지를 연다. ⚠️ **기존 사이트는 설정을 바꾸기 전까지 현재 표시를 그대로 유지한다.** **How(다국어):** **Data Translation을 켜고** academic term · learning program · learning course · **application stage** 같은 오브젝트에 번역 값을 만든다 — 레코드의 **Translations 관련 목록**에 직접 입력하거나 **Translation Workbench** 로 대량 번역. **표시는 지원자의 로케일 기준이며 번역이 없으면 원래 값으로 폴백**한다. **Where: [EDU].** **Who:** 구성·번역 관리는 `Education Cloud Full Access`, 조회는 `Education Cloud for Experience Cloud Access` |
| **Discover and Set Up More Education Features in Salesforce Go**<br>`rn_edu_salesforce_go_updates` | Salesforce Go 한곳에서 발견·활성화·구성 가능한 영역 **6개 전수**: **Alumni and Advancement · Recruitment and Admissions · Student Financials · Delegated Access Management · Transfer Credit · Petitions and Waivers.** 기능별 구성 단계 미리보기, 진행률 추적, 도움말 문서 열기 지원. **Where: [EDU].** **Who:** `Education Cloud Full Access`. **일부 기능에는 사용자에게 필요한 접근을 배정하는 `Manage User Access` 단계가 포함**된다 |

#### 학점·학사 운영 (Transfer Credit · Academic Operations)

| 항목 | 내용 |
|---|---|
| **Accept Transfer Credit Requests from Current Students on an Experience Cloud Site**<br>`rn_edu_request_transfer_credit_from_portal` | 재학생이 Experience Cloud 사이트에서 **Unified Catalog 서비스**로 편입 학점 신청서를 열어 사전 학습을 추가·제출. ⚠️ **How: `TransferCreditPetitionWrapper` Omniscript를 복제(clone)** 하고, 그것을 **intake form으로 사용하는 Unified Catalog 서비스**를 만든 뒤, **Unified Catalog 컴포넌트를 Experience Cloud 사이트에 추가**해야 한다. **Where: [EDU]**(재학생은 Experience Cloud 사이트에서 접근). **Who:** 설정은 `Education Cloud Full Access`, 제출은 Experience Cloud 사용자로서의 재학생 |
| **Post Transfer Credits and Preview Degree Impact**<br>`rn_edu_post_transfer_credits_preview_degree_impact` | 승인된 편입 학점을 **program plan에 직접 배정**하면서 학위 요건에 미치는 영향을 완전히 파악. **성적 편집 · posting reason 선택 · 일괄 작업(bulk action)** 지원. **시각화 패널이 커밋 전에 잔여 학위 요건 변화**를 보여줘 **일반 선택과목보다 필수 과목을 채우는 학점을 우선**하고, **중복 신청을 검증으로 방지**하며, 학점 비율(credit rate)을 미리 이해할 수 있다. **Where: [EDU]** |
| **Keep Student Records Accurate as Curricula Evolve with Course Versioning**<br>`rn_edu_evolve_curricula_with_course_versioning` | 과목명 변경·학점 조정·선수과목 갱신 시 **학생의 학사 이력을 다시 쓰거나 과목 레코드를 복제하지 않고** 다른 버전을 만든다. 학생이 이수한 버전은 진도·학위 감사 전반에서 보존되고 **여러 버전을 동시에 운영해 코호트별로 대응**할 수 있다. **어느 버전이든 동일 프로그램 요건을 충족**하므로 program plan이 정확하게 유지된다. **Where: [EDU].** **Who:** 생성·편집은 `Education Cloud Full Access`, Experience Cloud 사이트에서 조회는 `Education Cloud Experience Cloud` |
| **Unify Attendance Signals into One Trusted Record**<br>`rn_edu_unify_attendance_signals_into_trusted_record` | 출결을 고립된 행정 업무에서 **학생 참여의 신뢰할 수 있는 조기 지표**로 전환. 출결 데이터 모델이 **강사 · 학부모 · 기기 · 시스템**의 신호를 받아 **학생별 단일 신뢰 결과**로 해소한다. 직원·어드바이저는 분석과 에이전트 경험을 통해 위험군 학생에 선제 대응. **Where: [EDU]** |
| **Automate Faculty Access to Course Data with a Standardized and Secure Model**<br>`rn_edu_automate_faculty_access_management` | 강의 배정 기준으로 교원의 과목·학생 데이터 접근을 부여·회수. **교원은 현재 가르치는 과목만 보고 학기 종료 시 접근이 자동 만료**된다. **academic role 권한을 한 번 구성**하면 과목 배정 변화에 따라 자동화 워크플로가 레코드를 관리하고, 행정 직원은 **불변(immutable) 감사 추적**으로 누가 무엇에 접근 가능한지 본다. ⚠️ 원문 명시: **커스텀 공유 규칙 없이** Agentforce Education의 표준화 데이터 모델 위에서 동작. **Where: [EDU]** |

#### 학생 재무 (Student Financials)

| 항목 | 내용 |
|---|---|
| **Automate Refund Processing for Student Overpayments**<br>`rn_edu_automate_refund_processing_student_overpayment_refunds` | 수강 철회·주문 축소 시 Student Financials가 **원 인보이스 식별 → credit memo를 미결 잔액과 상계 → 결제 환불 개시**. 감사 추적 유지. **Where: [EDU-FIN].** **Who:** 어드바이저는 **`Education Cloud Full Access` + `Billing Operations User` + `Payment Operations User`**, 학생은 **`Education Cloud for Experience Cloud` + `Billing Experience Cloud User`**. **How:** Setup → **Set Up Education Cloud** → **Set Up Student Financial Account Management** 켜기 → 청구·결제 설정은 **Configure Billing and Payments** |
| **Spread Tuition Payments with Flexible Payment Plans**<br>`rn_edu_spread_tuition_payments_flexible_payment_plans` | 등록금을 **월 · 분기 · 커스텀** 일정으로 분납. **통합 게이트웨이로 수납 자동화**하고 학생은 **learner portal에서 플랜 상태와 예정 자동이체(auto-debit)를 실시간 확인**. **Where: [EDU-FIN].** **Who·How:** 위 환불 항목과 동일 |
| **Share Billing Details with Your Students** *(Agentforce for Education)*<br>`rn_edu_share_billing_details_students` | 학생이 **상세 인보이스 · 결제 일정 · 분납 플랜**을 직접 조회. 여러 액션을 통합 플로우로 묶어 **환불·결제·credit memo 잔액을 한 번에 표시**하고, **학기 등록 로직 강화로 학기별 요금 내역 정확도** 향상. ⚠️ **Where: Enterprise·Performance·Unlimited·Developer**(이 절에서 유일하게 **Performance 포함**) + **Education Cloud · Revenue Cloud Advanced · Revenue Cloud Billing 라이선스 + 해당 Agentforce 애드온 라이선스**. 원문: 추가 지원은 **Salesforce account executive에 문의**. **Who:** 어드바이저는 `Education Cloud Full Access`(Student Financials Agent 구성·사용), 학생은 **`Education Cloud for Experience Cloud` + `Billing Experience Cloud User` + `Billing Einstein Experience Cloud User`** 3종 |

#### 위임 접근·프록시 (Delegated Access Management)

세 기능 모두 **How가 동일**하다 — 기어 메뉴 또는 Setup 메뉴에서 **Salesforce Go** 선택 → **Delegated Access Management** 검색해 켠다. **Where: [EDU]**, **Who:** 어드바이저 `Education Cloud Full Access` · 학생 `Education Cloud for Experience Cloud`.

| 항목 | 내용 |
|---|---|
| **Manage Proxy Access to Student Records Through Delegated Access Management**<br>`rn_edu_manage_proxy_access_student_records_delegated_access_management` | 학생이 **학부모·보호자 등 신뢰하는 개인을 proxy로 지정**해 학사·재정·개인 정보 접근을 **부여·수정·철회**한다. 기관은 위임 가능한 권한을 구성. **Why(원문):** **FERPA·GDPR** 같은 데이터 프라이버시 규제가 엄격한 동의 관리를 요구하며, 학생은 언제든 철회할 통제권이, 기관은 컴플라이언스용 감사 추적이 필요하다 |
| **Manage Emergency Contacts and Authorized Pickups for Students**<br>`rn_edu_manage_emergency_contacts_authorized_pickups_students` | **고등교육은 학생 본인**이 비상 연락처를 유지하고, **K-12는 학부모·보호자**가 자녀의 연락처와 **authorized pickup** 을 관리. **비상 연락 순서와 authorized pickup 관계에 우선순위**를 두고 **모든 변경의 완전한 감사 추적** 유지 |
| **Accelerate Proxy Experiences with a Portal Template**<br>`rn_edu_accelerate_proxy_experiences_portal_template` | proxy를 위한 **통합 접근점 포털 템플릿** — 모든 교육 단계의 proxy 시나리오를 지원하도록 구성·확장 가능. **K-12는 학부모가 가구(household)·신청·학생 정보를 관리**, **고등교육은 지정 proxy가 학생이 위임한 작업을 안전하게 수행** |

#### 규제 보고 (지역별)

| 항목 | 내용 |
|---|---|
| **Automate Higher Education Statistics Agency (HESA) Regulatory Calculations**<br>`rn_edu_automate_hesa_calculations` | **Data Cloud의 Calculated Insights** 로 Agentforce Education 데이터에서 **영국 HESA 규제 값**을 산출. **운영 데이터 수집과 규제 로직을 분리**해 스키마 변경 없이 계산을 발전시킨다. **학습자가 프로그램에 등록하면 HESA Student Identifier가 자동으로 채워진다.** **수동 매핑 없이 HESA Data Futures 제출 준비** + 분석·AI 유스케이스 대비. **Where: [EDU]** |
| **Extend Institutional Data for MortarCAPS Reporting and Intelligence**<br>`rn_edu_regional_data_ext_mortarcaps` | **호주·캐나다 등**의 규제 준수를 지원하는 표준화 데이터 구조 배포. **MortarCAPS Compliance and Configuration** 을 켜면 기존 Agentforce Education 오브젝트에 **MortarCAPS Higher Learning Data Standards** 에 정합한 필드·메타데이터가 추가된다. **수동 데이터 매핑이나 외부 데이터 웨어하우스 없이** 제출 검증·분석 수행. **Where: [EDU]** |

#### Agentforce for Education

| 항목 | 내용 |
|---|---|
| **Resolve Student Absences with the Attendance Management Agent**<br>`rn_edu_resolve_absences_with_voice_agent` | **Marketing Cloud Next 이벤트 트리거 플로우**로 가정에 SMS 발송 → **인바운드 Omni-Channel 플로우**가 음성 에이전트와의 자연어 대화로 연결 → **Attendance Management Agent** 가 학부모 설명을 수집해 **공식 출결 기록을 갱신**하고 **담당 강사에게 즉시 Slack 알림**.<br>⚠️ **이 노트에서 가장 전제가 많은 Education 기능** — **Where(라이선스·애드온 전수):** Education Cloud · **Einstein for Education Cloud 애드온** · **Data 360** · **Marketing Cloud Next + `Salesforce Message Credits - SMS` 애드온 + 최소 1개의 `Salesforce SMS Code Lease` 애드온** · **해당 Salesforce Voice 애드온 라이선스** · **해당 Agentforce 애드온 라이선스** · **Slack**. 에디션은 [EDU]와 동일. 원문: MCN·Salesforce Voice·Agentforce 애드온 라이선스는 **Salesforce account executive에 문의**.<br>**Who(전수):** `Education Cloud Full Access` · `Education Cloud Advanced Academic Operations Admin Access` · **SMS 선행 조건 설정용 `Data Cloud Architect`** · **SMS 발송용 `Marketing Cloud Admin` 또는 `Marketing Cloud Manager`** · **인바운드 콜 라우팅 구성용 해당 `Agentforce Contact Center` 또는 `Salesforce Voice` 권한 세트**.<br>**How(순서):** ① **Advanced Academic Operations 켜기** ② Attendance Management Agent 생성 ③ SMS 발송용 MCN 이벤트 트리거 플로우 구축 ④ 수신 콜 라우팅용 인바운드 Omni-Channel 플로우 구축 ⑤ 출결 갱신·강사 통지용 Agentforce Education 플로우 구성 |

#### New and Changed Objects in Education (`rn_edu_new_and_changed_objects`) — 원문 전수

**신규 오브젝트 18**

| 오브젝트 | 용도(원문) |
|---|---|
| `DelegateAccessDef` | 특정 정보에 대한 **데이터 접근 위임 정의** 상세 |
| `DelegateAccessDataSet` | 위임 접근을 가진 사용자와 공유되는 **사용자별 오브젝트 컬렉션** |
| `DelegateAccsDataSetObj` | 위 컬렉션 안의 **개별 요소** |
| `AccessDelegationRequest` | 특정 정보에 대한 접근 위임·액션 허용을 **요청**하는 레코드 |
| `LearnerAchievement` | 학습자의 성취(자격증·학위·과목 이수)와 **해당 학기에 받은 성적** |
| `LearnerAchievementMethod` | 성취를 부여한 **출처·방법**(과목 참여·편입 학점·활동 이수) |
| `AttendanceRecording` | **한 번의 출결 기록 행위(occurrence)** |
| `AttendanceEntry` | 컨택의 **출결 상태** |
| `AttendancePolicy` | 기관 학사 환경에서 **출결을 캡처·해석·판정하는 규칙** |
| `AttendanceSourceType` | **원시 출결 신호를 캡처하는 시스템·방법의 유형** |
| `AttendanceSourceData` | 최종 출결 결과로 해소되기 **전의 원시 출결 신호** |
| `AttendancePolicySourceType` | attendance policy ↔ attendance source type **junction** |
| `AcademicRole` | 로컬 정의 role 픽리스트 값들을 **데이터 접근 관리용 공유 정체성으로 통합**한 기관 정의 중앙 role |
| `AcademicRoleMapping` | 로컬 정의 role 값 ↔ 표준 academic role **매핑** |
| `AcademicRoleObjectAccess` | academic role이 **특정 오브젝트에 갖는 접근 수준** |
| `AcademicAccessLog` | 과목 관련 데이터 접근의 **부여·회수를 추적하는 불변 로그 항목** |
| `ApplicationStageDefExt` | 신청 **단계(stage)의 번역** |
| `AcademicTarget` | 학기별 **모집 목표** — 지정 target type·scope에 대한 prospect·applicant·admit·enrollee 목표 수 |

**변경 오브젝트 5**

| 오브젝트 | 변경 |
|---|---|
| `CodeSet` | **신규 필드 8종** — `IsExcusedAbsence` · `IsCountedTowardAbsence` · `IsCountedTowardTardy` · `IsCountedTowardAttendanceRate` · `IsEarlyDeparture` · `IsRemote` · `DisplayOrder` · `ScopeType` (각 출결 코드가 어떻게 분류되고 출결 계산에 반영되는지) |
| `CourseOffering` | **`AttendancePolicyId`** — 연결된 attendance policy |
| `LearningProgram` | **`AttendancePolicyId`** |
| `LearningCourse` | **`AttendancePolicyId`** + **신규 `ChangeDescription`·`Status`**(코스 버전의 변경 내용과 현재 상태) |

### Energy and Utilities (Agentforce Energy & Utilities) — 26건 전수

> **산업 랜딩 `rn_energy_and_utilities_cloud` 가 밝힌 리브랜드(원문):** *"Energy & Utilities Cloud is now Agentforce Energy & Utilities. You may see references to Energy & Utilities Cloud in our application and documentation."*

랜딩 원문의 **Energy and Utilities Release Note Changes by Month** 절은 월별 변경 로그 스텁이다.

**Where 약칭** — 이 산업은 제품 SKU가 **세 갈래(Agentforce Energy & Utilities / Energy & Utilities - Growth / 관리형 패키지 + 애드온)** 라 에디션이 항목마다 갈린다.

| 약칭 | 원문 Where |
|---|---|
| **[AEU]** | Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Agentforce Energy & Utilities** |
| **[AEU-EPU]** | Lightning Experience · **Enterprise·Performance·Unlimited** + Agentforce Energy & Utilities (**Developer 없음**) |
| **[EU-GROWTH]** | Lightning Experience · **all editions** + **Energy & Utilities - Growth** |
| **[EU-EMER]** | Lightning Experience · **Enterprise·Performance·Unlimited** + **Energy & Utilities - Growth** + **Field Service for Energy & Utilities** + **Contractors for Energy & Utilities** |
| **[AEU-AGENT]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Agentforce for Energy & Utilities** + **Agentforce for Energy & Utilities 애드온**. 원문 명시: **Agentforce Employee Agent는 Salesforce Foundations Entitlements 모델의 Flex Credits를 소비한다** |

> ⚠️ **가용 시점 — Agentforce 계열 3건은 릴리즈 시점에 바로 쓸 수 없다.** `rn_energy_agentforce_quote_recipient_groups` · `rn_energy_agentforce_compare_tariffs_enroll` · `rn_energy_agentforce_cart_operations_flows` 는 모두 **`When: This feature is available starting October 2, 2026.`** (이는 Release Update 강제 시점이 아니라 **기능 가용 시점**이다 — 강제 시점은 [[Winter '27/Release Updates]] 소관)

#### Agentforce for Energy & Utilities (`rn_energy_agentforce_overview` 허브 + 리프 3) — 전부 **2026-10-02 가용**

| 항목 | 내용 |
|---|---|
| **Manage Quote Recipient Groups with Agentforce**<br>`rn_energy_agentforce_quote_recipient_groups` | 멀티사이트 견적의 **quote recipient group 생성을 자동화**. **오퍼를 수신자마다 복제하지 않고** 그룹에 구성·적용하며, **여러 수신자에 연결된 quote line item을 단일 표현으로 관리**해 확장성·사용성·성능을 개선. **Where: [AEU-AGENT]. When: 2026-10-02.** **How — 사용 액션 6종 전수:** `Get Group Suggestions` · `Get Quote Location Fields` · `Create Quote Recipient Groups` · `Get Recipient Grouping Criteria` · `Create Quote Line Item for Recipient Group` · `Get Energy Products` |
| **Compare Tariffs and Enroll Customers with Agentforce**<br>`rn_energy_agentforce_compare_tariffs_enroll` | 영업·서비스 담당자가 에너지 제품 오퍼링과 요금을 비교. **완전 가격이 매겨진 적격 오퍼 제안**, **고객의 사용량·위치 기반으로 더 나은 요금제 추천**, 제품 질의 응답, 신규 제품·서비스 **등록 완료**. **Where: [AEU-AGENT]. When: 2026-10-02.** **How — 사용 액션 6종 전수:** `Get Tariff Configurations` · `Get Available Service Points` · `Get Customer Service Addresses` · `Get Fully Priced Products` · `Generate Tariff Pricing Request` · `Submit Customer Enrollment` |
| **Automate Cart Operations with Flows and Invocable Actions**<br>`rn_energy_agentforce_cart_operations_flows` | **CPQ Cart API를 Agentforce와 통합**해 견적·주문 프로세스를 단순화 — **커스텀 Apex가 필요 없다**. 사전 구성 플로우와 사전 제작 invocable action으로 자기 agent action을 만들어 특정 지시와 함께 호출. ⚠️ **Where: Enterprise·Unlimited·Developer + Energy & Utilities 관리형 패키지 + Agentforce for Energy & Utilities 애드온.** **Who: Industries CPQ와 Agentforce 라이선스 모두 필요.** **When: 2026-10-02.** **How:** App Launcher → **Vlocity CMT Administration** → **Custom Settings** 섹션의 **CPQ Configuration Setup** → **`CpqCartAgentInvocableAction` 파라미터를 직접 추가하고 값을 `ON`** 으로 설정(기본 제공되는 설정이 아니다) |

#### New Connections and Program Management (`rn_energy_new_connections_overview` 허브 + 리프 5) — 전부 [EU-GROWTH]

신규 유틸리티 연결 신청 같은 **애플리케이션의 전 라이프사이클**을 **마일스톤 추적 + SLA 컴플라이언스 관리**로 처리한다. 연결 유형별로 **필수 단계·담당자·SLA를 정의한 milestone template** 을 구성하고, **Milestone Tracker 데이터 테이블**로 실시간 진행을 보며, 위험 시 알림을 받고 레코드에서 바로 소유권을 재배정한다(스프레드시트 추적 제거).

| 항목 | 내용 |
|---|---|
| **Enable Entitlements and Milestones for New Utility Connections**<br>`rn_energy_new_connections_enable_milestones` | ⚠️ **이 기능군의 활성화 전제** — **Setup → Energy & Utilities Settings → `Individual Application Milestone Enablement` 를 켜야** 담당자가 New Connections Management에 접근한다 |
| **Assign Connection Milestones Based on Application Programs**<br>`rn_energy_new_connections_assign_by_program` | **Individual Application 레코드를 만들면 연결된 프로그램 기준으로 마일스톤이 자동 생성·배정**된다 — 서비스 유형·지역·규제 분류가 달라도 올바른 마일스톤 세트가 자동 적용. **SLA policy·마일스톤·액션을 만들어 신규 유틸리티 연결에 SLA policy를 배정**할 수 있다 |
| **Assign Milestone Owners for New Connections**<br>`rn_energy_new_connections_assign_owners` | **Milestone Tracker 컴포넌트에서 직접** 마일스톤 소유자를 배정·재배정. 한 번의 액션으로 소유권을 바꾸고 **새 소유자에게 이메일 자동 통지**. **entitlement process** 로 연결 신청 생성 시 적절한 팀에 자동 배정. **How:** Individual Application 레코드 페이지의 Milestone Tracker에서 마일스톤·태스크를 선택해 소유자 변경 |
| **Monitor SLA Compliance for Connection Milestones**<br>`rn_energy_new_connections_monitor_sla` | Milestone Tracker가 마일스톤·태스크별 **경과 시간 대비 목표 SLA**를 보여주고 **at-risk·violated 마일스톤을 상태 표시로 플래그**. **작업이 막히면 마일스톤 타이머를 일시 정지·재개**해 정확한 컴플라이언스 추적 유지. **How:** entitlement process를 구성하고 **`milestoneTracker` 컴포넌트를 Individual Application 페이지 레이아웃에 추가** |
| **Track Milestones for New Utility Connections**<br>`rn_energy_new_connections_track_milestones` | Individual Application 레코드 페이지의 **대화형 Milestone Tracker** 가 마일스톤과 연관 태스크를 구성 가능한 테이블로 표시 — **시작일 · 목표 종료일 · 실제 완료일 · 현재 상태**. **How:** 레코드 페이지 레이아웃에 Milestone Tracker 컴포넌트를 **드래그해 배치** |

#### Emergency Management (`rn_energy_emergency_management_overview` 허브 + 리프 3) — 전부 [EU-EMER]

비상 시 **union contract 요건을 만족하는 구성 가능한 callout 프로세스**로 복구 팀을 배치한다. **wage classification 별 인력 가용성 확인 → 우선순위 로스터 생성 → service resource에 push 알림 → 모든 callout 결정의 감사 가능 기록 유지.** 원문: 디스패처가 **시간 단위가 아니라 분 단위로** 크루를 동원한다.

| 항목 | 내용 |
|---|---|
| **Manage Incidents, Service Outages, and Callouts in Salesforce**<br>`rn_energy_emergency_manage_incidents_callouts` | 인시던트·서비스 정전·비상 callout을 Salesforce에서 관리. callout 프로세스는 **다양한 union agreement와 지역 노동법에 맞춰 구성 가능**하다. 디스패처는 **wage classification · seniority · territory 로 그룹핑된 적격·가용 service resource 로스터**를 생성하고 응답을 실시간 추적. **template screen flow** 로 인력 가용성 확인과 callout 로스터 생성을 수행. ⚠️ **Who:** `Energy & Utilities Cloud Features` + `Emergency Management Standard` 권한 세트. **디스패처는 추가로 Field Service 관리형 패키지의 `Field Service Dispatcher` 권한 세트가 필요하다** |
| **Send Emergency Callout Notifications to Service Resources**<br>`rn_energy_emergency_callout_notifications` | **Salesforce Field Service 모바일 앱 push 알림**. 알림을 열면 callout 상세 화면에 **work order · earliest permitted start time · service address · work type · asset + 디스패처 코멘트**가 표시되고, **한 번의 탭으로 수락·거절**하거나 전체 work order를 열 수 있다. 응답은 디스패처의 callout 로스터에 반영되며, **구성된 시간 내 무응답이면 알림이 자동 만료**된다. ⚠️ **How:** **`Emergency Callout Notification` 커스텀 알림 유형을 구성**하고 **Notification Delivery Settings에서 Salesforce Field Service iOS·Android 앱에 바인딩** → 플로우 3종 **`Send Emergency Callout Notifications` · `Expire Emergency Callout Attempt` · `Initiate Call Out` 을 활성화**해야 한다 |
| **Track Emergency Callout Compliance with Audit Trails**<br>`rn_energy_emergency_callout_audit_trails` | 모든 callout 결정의 감사 추적 — **매 callout 시도마다 service resource의 seniority rank · 통지 시각 · 응답 · 응답 시각**을 기록. **적격·상위 우선순위 리소스가 누락되지 않았음을 입증**해 union grievance와 금전적 제재를 피한다 |

#### 견적·가격·프로모션

| 항목 | 내용 |
|---|---|
| **Boost Sales by Applying Promotions to a Quote and an Order**<br>`rn_energy_promotions_quote_and_order` | 프로모션의 **type · duration · eligibility** 를 구성하고 **수동 프로모션용 쿠폰** 추가. **configurator 또는 Sales Transaction Line Editor에서 직접** 견적·주문에 맞춤 프로모션을 조회·적용. **Where: [AEU].** ⚠️ **Who: `Apply Promotions on Sales Transactions` 권한 세트가 있어야 프로모션이 보이고 적용된다** |
| **Transform Pricing Capabilities in Tariff Comparison with a New Context Definition**<br>`rn_energy_tariff_comparison_context_definition` | 요금 비교의 가격 기능을 **`ConsumerSalesContext` context definition** 으로 전환. ⚠️ 원문 권고: **Winter '27 이전에 tariff comparison 구성을 구현한 조직은 새 `ConsumerSalesContext` 를 사용하라.** **Where: [AEU]** |
| **Simulate Tariff Comparisons Using Dynamic Runtime Usage Weights**<br>`rn_energy_simulate_tariff_comparisons_runtime_weights` | **Tariff Comparison 컴포넌트에서 사용량 분포를 직접 조정**해 실시간 비용 시나리오를 계산. 커스터마이즈된 플랜 변형과 표준 제품 옵션을 **나란히 비교**해 잠재 절감액 확인. **커스텀 런타임 시나리오가 추천 로직을 자동 갱신**해 가장 비용 효율적인 요금제를 부각. **Where: [AEU-EPU]** |
| **Improve Consumer Sales Efficiency with Built-In APIs**<br>`rn_energy_consumer_sales_efficiency_apis` | **API-first Cart-to-Asset 경험** 배포. Connect REST API가 판매 여정의 각 단계에 산업 특화 인터페이스를 제공한다. ⚠️ 원문 명시: **integration user 프로필을 가진 익명(anonymous) 쇼퍼**가 제품을 찾고 구성하고 구매하는 디지털 경험. **Where: [AEU]** |
| **Receive Slack Notifications for Site Bulk Upload in Multisite**<br>`rn_energy_slack_notifications_site_bulk_upload` | 멀티사이트 견적에 **사이트 데이터가 일괄 업로드되면 Slack 알림**. **Where: Enterprise·Performance·Unlimited + Agentforce Energy & Utilities + Agentforce Sales for Slack.** ⚠️ **Who: `Agentforce Sales for Slack` 권한 세트와 `Sales Cloud for Slack` 앱이 있어야 알림을 받는다** |

#### 플랫폼·데이터 접근

| 항목 | 내용 |
|---|---|
| **Access Energy & Utilities Objects with the Integration User**<br>`rn_energy_access_objects_with_integration_user` | **Integration User가 모든 Agentforce Energy & Utilities 플랫폼 오브젝트에 접근**하므로 Salesforce 앱이 속성 전반의 에너지 데이터에 안전하게 접근한다(설정 시간 절감). **Where: [AEU]** |
| **Access Energy Service Agreements from the Contract Object Page Layout**<br>`rn_energy_access_service_agreements_from_contract` | **Contract 오브젝트 관련 목록**에 **Energy Service Agreement와 그 필드**가 표시돼 계약에 묶인 협정을 한자리에서 본다. **Where: [AEU]** |

#### 신규/변경 오브젝트 (`rn_energy_new_changed_objects`) — 원문 전수 11건

| 오브젝트 | 용도(원문) |
|---|---|
| `CartItemRecipient` | 카트에서 제품·서비스를 **수령하는 service site** 저장 |
| `QuoteLineRecipientPrice` | 멀티사이트 quote group 안 **단일 quote line item의 사이트별 가격** |
| `ResourceCallOut` | **디스패처가 개시한 리소스 callout 세션** — work order 또는 service appointment에 연결. 비상·정전·인시던트·사전 계획 작업에 리소스 동원 |
| `ResourceCallOutRequirement` | callout의 **인력 요건** — pay grade 또는 resource type으로 정의 |
| `ResourceCallOutAssignment` | callout ↔ 응답 가능한 service resource 연결의 **contact priority(rank) · 마지막 접촉 시도 상세 · 최종 응답** |
| `ResourceCallOutAttempt` | service resource에 대한 **개별 통지 시도** |
| `ServiceOutage` | 유틸리티 서비스를 받지 못하는 **위치들의 집합** |
| `ServiceOutageIncident` | 인시던트(고객 신고·센서 경보) ↔ **확인된 그리드 수준 다운타임 이벤트** 연결 |
| `ServiceOutageServicePoint` | service point가 **라이프사이클 동안 겪은 모든 중단의 이력 레코드** |
| `WorkOrderSource` | work order ↔ 그것을 유발한 이벤트의 **추적성** — **반응적 유지보수 대 능동적 프로젝트에 들인 노력**을 리포팅 |
| `ObjectMilestoneTask` | 마일스톤 ↔ **그 마일스톤이 트리거하는 액션** 연결 |

#### 신규/변경 invocable action (`rn_energy_new_changed_invocable_actions`) — 원문 전수 8종

| 액션 | 용도 |
|---|---|
| `getTariffConfigurations` | **catalog code · category code · service type** 기준으로 요금 비교용 tariff 구성·속성·관련 메타데이터 조회 |
| `getFullyPricedProducts` | 비교 플로우 안에서 **완전 가격이 매겨진 오퍼링과 제품 계층 구성** 조회 |
| `calculateRecipientPrices` | quote recipient group에 연결된 **번들 quote line item의 수신자별 가격을 비동기로 계산**(대규모 견적 처리용) |
| `createEnergyAgreementFromQuote` | 수락된 견적에 대해 **energy service agreement와 agreement item + service point·location 등 관련 마스터 데이터 레코드를 비동기 생성** |
| `getExternalPrices` | 특정 quote line item과 그 수신자에 대한 **외부 가격 서비스의 실시간 가격 분해** 조회 |
| `getEnergyProducts` | Energy and Utilities 제품의 **제품 목록·가격 상세** 조회 |
| `createCustomerAccount` | 요금 비교 고객을 **person account 또는 business account + contact** 로 생성 |
| `resolveKnownCustomerAccount` | 요금 비교 등록을 위해 **기존 고객의 person/business account 상세를 해석(resolve)** |

#### 신규 Connect API (`rn_energy_new_changed_connect_apis`) — 원문 전수 6종

| 리소스 | 메서드 · 바디 |
|---|---|
| `/connect/eu-sales/fully-priced-products` | **POST** — 지정 product category의 **완전 가격 tariff 제품 목록**(제품별 가격·속성·자식 컴포넌트 가격 포함). 요청 `Fully Priced Product Input` / 응답 `Fully Priced Product Details` |
| `/connect/eu-sales/product-pricing-details` | **POST** — 지정 제품의 **완전 가격 제품 계층**. 요청 `Product Pricing Details Input` / 응답 `Product Pricing Details` |
| `/global-promotions-management` | **GET** — 프로모션 상세 조회 및 프로모션 레코드 갱신. 요청 파라미터 **`promotionId`** |
| `/global-promotions-management` | **GET** — **카트와 그 라인 아이템에 적격한 프로모션과 연관 리워드** 조회 *(원문이 같은 리소스를 두 항목으로 나눠 적는다 — 파라미터 유무로 구분)* |
| `/get-eligible-promotions` | **PUT** — 견적·주문 내 라인 아이템의 적격 프로모션. 요청 파라미터 **`salesTransactionId`** / 응답 `Get Eligible Promotions` |
| `/connect/eu-sales/tariff-configs` | **GET** — **요금 비교 구성 메타데이터**(속성·카탈로그·소비 파라미터) |

#### 신규 플랫폼 이벤트 (`rn_energy_new_changed_platform_events`) — 2종

| 이벤트 | 구독 시 통지 내용 |
|---|---|
| `ObjectMilestoneCreatedEvent` | object milestone에 대한 **상세 이벤트 레코드 생성 프로세스 완료** |
| `ObjectMilestoneCreatedDtlEvent` | object milestone에 대한 **이벤트 레코드 생성 프로세스 완료** |

### Financial Services (Agentforce Financial Services) — 7건 전수

**Where가 항목마다 다르다 — 원문 그대로**

| 항목 | 원문 Where |
|---|---|
| `rn_fsc_agentforce_fncl_svcs_initial_setup` | Lightning Experience · **Enterprise·Unlimited** + Agentforce Financial Services |
| `rn_fsc_agentforce_builder` | Lightning Experience · **Enterprise·Performance·Unlimited** + **Agentforce for Financial Services 애드온 라이선스** 또는 **Agentforce 1 Financial Services Edition** 포함 |
| `rn_fsc_brp_track_financial_deals` | Lightning Experience · **Enterprise·Unlimited** + **Agentforce Financial Services(구 Financial Services Cloud)** + **Deal Management 활성** |
| `rn_fsc_brp_measure_deal_performance` | Lightning Experience · **Enterprise·Unlimited** + **Agentforce Financial Services · Account Plans · Deal Management 활성** |
| `rn_fsc_flexible_hierarchies_rules` | Lightning Experience · **Unlimited 및 Agentforce editions** + Agentforce Financial Services *(원문 표기 그대로 — 이 절에서 유일하게 Enterprise가 없다)* |
| `rn_fsc_origination_worksheet` | Lightning Experience · **Enterprise·Unlimited** + **Digital Lending** *(제품명이 Agentforce Financial Services가 아니다)* |

| 항목 | 내용 |
|---|---|
| **Set Up Agentforce Financial Services from One Place**<br>`rn_fsc_agentforce_fncl_svcs_initial_setup` | **Financial Services Initial Setup** 한 페이지에서 필수 역량을 켠다. 필수 구성 단계를 **단일 체크리스트**로 진행하고, **adoption path** 로 비즈니스 목표에 맞는 기능을 식별하며, **설정 진행률과 권한 세트 라이선스 사용량을 한 곳에서 추적**해 라이선스 배정을 미리 계획한다. **How:** 기어 메뉴 → **Salesforce Go** → `Financial Services Initial Setup` 검색 → **Keep Going** → **Financial Services Initial Setup을 켜서** 필수 역량 활성화 후 나머지 구성 단계 완료 |
| **Create Agents for Financial Services in the New Agentforce Builder**<br>`rn_fsc_agentforce_builder` | Agentforce Studio의 **새 Agentforce Builder** — **guided setup · 내장 AI 지원 · Agent Script 기반 워크플로**, **preview · test · trace · debug** 지원. **새 빌더에서 제공되는 Financial Services 템플릿 7종 전수: Banking Relationship Assistance · Collections and Recovery Assistance · Complaint Management Assistance · Financial Advisor Assistance · Loan Product Assistance · Insurance Service Assistance · Claims Service Employee Assistance.** *"More financial services agents move to the new builder in upcoming releases."* **How:** Agentforce Studio **Agents 탭 → New Agent → 템플릿 선택**. **기존 에이전트를 새 빌더로 올리려면 `Agentforce Agents Setup` 에서 에이전트 옆 `Upgrade` 클릭.** ⚠️ **기존 에이전트는 영향받지 않으며 계속 편집·활성화·관리할 수 있다** |
| **Business Relationship Plans** *(컨테이너)*<br>`rn_fsc_business_relationship_plans` | 계산 정의를 만들거나 **기본 제공 정의**로 **Financial Deal 레코드를 이용해 account plan 목표 진척을 자동 추적**. 하위 리프 2건은 아래 |
| **Track Financial Deals in Business Relationship Plans to Meet Revenue Goals**<br>`rn_fsc_brp_track_financial_deals` | financial deal이 **자동 동기화**돼 account plan 목표에 대한 수동 갱신이 사라진다. **Why(원문):** 이전엔 수동 갱신이 필요해 **지연과 부정확한 리포팅 위험**이 있었다. **prospecting · negotiation · closed-won** 같은 단계를 거치면 **현재 값이 자동 갱신**된다. **How(관리자):** Setup의 **Account Plans** 페이지에서 **계산 정의**(financial deal 데이터가 목표 measure에 어떻게 매핑되는지 정하는 규칙)를 생성·활성화. **How(어드바이저·관계 매니저):** account 레코드에서 account plan 생성 → **Objectives 탭**에서 objective 생성 → 계산 정의 선택 + 목표값 지정 + 관련 financial deal 선택으로 measure 추가 |
| **Measure Deal Performance in Business Relationship Plans**<br>`rn_fsc_brp_measure_deal_performance` | **기본 제공(out of the box) 계산 정의 2종** — **`Financial Deal Revenue Targets`**: **활성 Financial Deal 전반의 `Transaction Value` 필드 합계**(비활성이 아닌 딜의 수익 파이프라인 추적) · **`Financial Deal Fee Growth`**: **활성 Financial Deal 전반의 `Total Expected Fee` 필드 합계**(딜 포트폴리오의 수수료 수익 추적). **How:** 관리자는 Setup **Account Plans** 페이지에서 조회·관리, 사용자는 Objectives 탭에서 measure 추가 시 두 정의 중 하나를 선택 |
| **Create Flexible Hierarchies with Rules**<br>`rn_fsc_flexible_hierarchies_rules` | **규칙**으로 일치 레코드를 자동 선택·조직화해 flexible hierarchy를 만든다. **node 관계·필터·필터 로직을 한 번 구성**하면 **여러 적격 root 레코드**의 계층을 생성할 수 있다. 결과는 **graph 또는 grid 뷰**로 검토. **How:** Setup → **Flexible Hierarchy Setup** → hierarchy type 생성 → 노드·관계 정의 → **Hierarchy Rules 탭**에서 상세 구성 → App Launcher → **Flexible Hierarchies** → New → **규칙으로 계층 생성** 옵션 선택 → 적격 root 레코드 선택. **계층 생성·검증이 끝나면 Salesforce가 알림을 보낸다** |
| **Create Calculation and Analysis Worksheets for Origination Processes**<br>`rn_fsc_origination_worksheet` | **Origination Worksheet** 로 front·middle·back office origination 전반의 **가격·상환능력(affordability) 계산**. 관계 매니저는 가격을 계산하고, 검토자·운영팀은 **재무 안정성·현금흐름·tradeline 데이터**를 분석해 적격성을 평가한다. **생성형 AI로 계산 로직 정의·정제, 수식 작성·검증, 런타임 워크시트 데이터 요약.** **How:** Setup의 **Digital Origination** 페이지에서 Origination Worksheet를 켜고 → **Origination Worksheet Definition** 페이지에서 정의 생성 → **빈 워크시트 정의로 시작해** 행과 셀을 Salesforce 데이터·수식으로 구성(예: 대출 affordability·serviceability 분석) |

> **공통 기능(Discovery Framework · Stage Management · Action Plans · Actionable List with Data 360 DMO)은 Financial Services 전용이 아니다** → 아래 `### Industries Common Features` 참조.

### Health (Agentforce Health) — 21건 전수

**Where 기본형 [HC-EU]:** Lightning Experience · **Enterprise·Unlimited** + Health Cloud (+ 항목별 애드온). 아래 표에 **애드온 조합이 항목마다 다르므로** 각 행에 그대로 적었다. **에디션이 다른 항목은 단 하나** — `rn_health_auto_display_order_action_plan_template` 는 **Unlimited만**이다.

> ⚠️ **가용 시점 — 5건이 `When: This feature is available starting October 2, 2026.`** : `rn_health_agentforce_cc_voice_assistant_agent` · `rn_health_agentforce_health_engagement_ss_drug_coverage` · `rn_health_pcc_gen_ai_summaries` · `rn_health_pcc_provider_claim_summaries` · `rn_health_referral_management_agentforce_voice`. (Release Update 강제 시점이 아니라 **기능 가용 시점**)

#### Agentforce for Health (`rn_health_agentforce_for_health` 허브 + 리프 5)

| 항목 | 내용 |
|---|---|
| **Summarize Provider Claims on Demand in Payer Contact Center**<br>`rn_health_pcc_provider_claim_summaries` | **Claims Service Assistance 서브에이전트 강화** — 담당자가 payer contact center 에이전트에게 **자연어로** 제공자 청구를 질의. 서브에이전트가 **제공자 NPI(National Provider Identifier) · claim ID · 서비스 날짜 범위**로 청구를 조회·요약하고 **지급 상태·금액·처리 오류**를 **서식이 갖춰진 요약 카드**로 제시. **Where: [HC-EU] + Agentforce for Health Cloud + Data Cloud 애드온. When: 2026-10-02.** **Who:** `Contact Center for Health Cloud` 권한 세트 + `Contact Center Agent for Health Cloud` 권한 세트 + **`Use Contact Center AI Assistive Agent` 사용자 권한**. **How:** Setup → Contact Center Settings → **Contact Center for Health Cloud 켜기** → **Agentforce for Payer Contact Center 탭** → *Configure Agentforce for Claims* 가이드 설정 |
| **Start Every Interaction with an AI-Generated Summary**<br>`rn_health_pcc_gen_ai_summaries` | Agentforce Health 오브젝트와 **Data 360에서 병렬로** 데이터를 끌어와 **회원 플랜 상세 · 청구 · 임상 정보 · 제공자 데이터**의 통합 뷰를 만든다. **Where: [HC-EU] + Agentforce for Health Cloud + Data Cloud 애드온. When: 2026-10-02.** **How:** Setup → **Health Generative AI Setup** 페이지의 가이드 설정 |
| **Automate Payer Contact Center Call Deflection, Wrap-Up, and Case Creation**<br>`rn_health_agentforce_cc_voice_assistant_agent` | **24시간 음성 에이전트**가 저위험 payer 콜을 디플렉션 — 발신자를 검증하고 **claim status · denial · prior authorization · eligibility** 관련 일반 질문을 해결한다. **모든 콜이 일관된 case 레코드로 종료**돼 리포팅·후속 조치 데이터가 남는다. ⚠️ **Where: [HC-EU] + 애드온 5종 — Health Cloud · Agentforce for Health Cloud · Salesforce Voice · Agentforce Voice · Data Cloud. When: 2026-10-02.** **How:** Setup → Contact Center Settings → **Contact Center for Health Cloud 켜기** → **Agentforce for Payer Contact Center 탭** → *Configure the Health Contact Center Assistant Agent* 가이드 설정 |
| **Give Members Self-Service Answers to Drug Coverage Questions**<br>`rn_health_agentforce_health_engagement_ss_drug_coverage` | **Agentforce for Formulary Data Queries** 구성으로 **약제 급여 · 비용 tier · 승인 요건 · 수량 한도 · 저비용 대체재** 질문에 검증된 답변 제공. **PDex FHIR 정합·CMS 준수 API** 기반의 **Drug Coverage Inquiry 서브에이전트**가 **plan-scoped formulary 데이터**를 질의하며 ⚠️ **회원 인증이나 세션 키를 요구하지 않는다**. **Where: [HC-EU] + Agentforce for Health Cloud + Data 360 애드온. When: 2026-10-02.** **Who(전수):** `Health Cloud Foundation` · `Prompt Template User` · `Data Cloud Architect` · `Data Cloud User` · `Marketing Cloud Manager` · `Member Self Service Agent Access`. **How:** Setup → **Health Engagement Settings** → **Patient and Member Self-service 켜기** → 해당 탭에서 *Configure Agentforce for Formulary Data Queries* 가이드 설정 |
| **Process Document Extractions Directly from Amazon S3 Folders**<br>`rn_health_doc_ai_s3_support` | **Document AI for Health의 지원 파일 소스에 Amazon S3 추가**. Document Extraction Request 생성 시 표준 콘텐츠 파일 외에 **S3 폴더에서 직접 파일 선택**. Document AI가 지정 폴더를 스캔해 적격 파일을 가져와 추출을 완료하므로 **Salesforce로 수동 파일 전송이 필요 없다**. **Where: [HC-EU] + Agentforce for Health Cloud 애드온.** **Who:** `Health Cloud Foundation` · `Data Cloud User` · `Document AI`. **How:** Amazon S3를 설정한 뒤 **S3에서 파일 접근을 설정** |

#### Referral Management (`rn_health_referral_management` 허브 + 리프 3)

| 항목 | 내용 |
|---|---|
| **Answer Patient Calls Around the Clock with Agentforce Voice**<br>`rn_health_referral_management_agentforce_voice` | 환자가 전화하면 **대화형 AI 음성 에이전트**가 신원을 검증하고 자연어 요청을 이해해 **예약을 잡거나 대기자 명단에 추가**한다 — 상담원 대기 없이. **Where: [HC-EU] + Health Cloud · Agentforce for Health 애드온 라이선스. When: 2026-10-02.** **How:** Setup → **Referral Management Settings** → *Configure Agentforce Voice for Referral Management* 가이드 설정 |
| **Sync Referrals Automatically Between Your EHR and Agentforce Health**<br>`rn_health_referral_management_ehr_sync` | Agentforce Health가 **EHR의 HL7 메시지를 수신해 referral 레코드를 자동 생성**하고, 예약 잡힘·완료에 따라 상태를 갱신하며, **referral을 EHR로 다시 기록(write back)** 한다. ⚠️ **Where: [HC-EU] + Health Cloud + MuleSoft.** **Who:** `Health Cloud Appointment Management` 권한 세트 + **`MuleSoft Administrator` 사용자 권한**. **How:** Setup → **MuleSoft Direct** → **`HL7 V2 ORM Process API - Implementation Template`** 과 **`HL7 V2 SIU Process API - Implementation Template`** 를 활성화·구성·배포 |
| **Track the Full Referral Lifecycle with Tableau Next Dashboards**<br>`rn_health_referral_management_tableau_next_dashboards` | 첫 접촉부터 완료 방문까지 실시간 referral 가시성 — 병목 발견, 환자 이탈 감소, 손실 수익 회복. ⚠️ **Where: Enterprise·Unlimited + Agentforce Health + Data 360, 그리고 조직에 프로비저닝된 Tableau Cloud가 필요하다.** **How:** Setup에서 **Tableau Next 활성화** → Setup의 **Referral Management Settings** 페이지에서 **Health Tableau Next for Referral Analytics 카드의 data kit 배포** → **TabNext Workspace**에서 대시보드 조회·커스터마이즈 |

#### Health Engagement · Intelligent Appointment Management

| 항목 | 내용 |
|---|---|
| **Measure Care Gap Campaign Impact with a Prebuilt Dashboard**<br>`rn_health_health_engagement_analytics_dashboard`<br>*(컨테이너 `rn_health_health_engagement`)* | **Health Engagement Analytics 애플리케이션의 사전 구축 대시보드**. **지표 전수: closure rate · average time to close · manual intervention rate · touches per closure** — 캠페인 실행 즉시, **추가 분석 설정 없이** 확인. **CMS Stars**와 **HEDIS** 리포팅 기간 최적화를 위해 **주간·월간 추세 평가**, **활성 캠페인 나란히 비교**, **plan type·health condition 으로 지표 필터**, **지리적 히트맵**으로 지역 접근 격차 발견. **Where: [HC-EU] + Health Cloud · Tableau Next Limited Consumer · Data 360 애드온.** **Who:** `Health Cloud Foundation` · `Data Cloud Admin` · `Tableau Next Limited Consumer`. **How:** Setup → **Health Engagement Settings** → **Patient and Member Outreach 켜기** → 가이드 설정에서 **Health Engagement Analytics 애플리케이션 설치** |
| **Track Appointment API Usage with Digital Wallet**<br>`rn_health_appointment_management_digital_wallet`<br>*(컨테이너 `rn_health_intelligent_appointment_management`)* | Agentforce 에이전트가 Connect REST API로 예약·슬롯·리소스를 **book · cancel · update · search** 하면 **Digital Wallet이 Flex Credits 카드의 일부로 사용량을 미터링**한다. 대시보드에서 유형별 집계 조회. ⚠️ **원문 명시 3가지:** ① 미터링은 백그라운드에서 돌며 **API 성능·신뢰성에 영향이 없다** ② **usage event에서 환자 데이터는 제외**된다 ③ **자율 에이전트(Einstein Service Agent 사용자)만 미터링하고 표준 사용자 호출은 제외**한다. **Where: [HC-EU] + Health Cloud · Data Cloud 애드온.** **How: 추가 구성이 필요 없다** — `Book Appointment` · `Cancel Appointment` · `Update Appointment` · `Get Slots` · `Get Resources` API에 대해 자동 미터링 |
| **Reduce No-Shows with Automated Patient Journeys**<br>`rn_health_referral_management_marketing_journeys` | **Marketing Journeys**로 **HIPAA 준수** 개인화 이메일·문자 리마인더를 **예약 라이프사이클 전 구간(예약·대기자 명단·완료 방문)** 에 발송. **Where: [HC-EU] + Health Cloud · Agentforce for Health · **Data Cloud for Marketing** 애드온.** **How:** **Marketing Cloud Next Gen을 켜고** 사전 구축 템플릿을 복제해 환자·예약 상세로 개인화한 뒤 활성화 |

#### Integrated Care Management · Home Health · Digital Health Insurance

| 항목 | 내용 |
|---|---|
| **Optimize Response Recommendation Mapping for Assessment Questions**<br>`rn_health_icm_response_recommendation_mapping` | **적용 가능한 assessment question 버전만 보여** response recommendation 매핑을 가속. **response recommendation을 지원하지 않는 외부 assessment question을 제외**해 구성 오류를 막고, 레코드·리스트 뷰의 **엄격한 편집 제어**로 데이터 정확도를 유지. **Where: [HC-EU] + Health Cloud.** **Who:** `Health Cloud Foundation` · `Integrated Care Management` · `Care Plans Access` · `Industries Assessment` |
| **Streamline Action Plan Template Assignments in Care Plan Workflows**<br>`rn_health_icm_template_assignment` | 템플릿 배정 시 **action plan template 버전을 자동 필터링**. **선택된 associated object · usage type · target object 에 정확히 맞는 버전만** 보여 problem definition · goal definition · care plan template 배정을 안내한다. **Where: [HC-EU] + Health Cloud.** **Who:** `Health Cloud Foundation` · `Integrated Care Management` · `Care Plans Access` |
| **Auto-populate Display Order for Action Plan Template Items**<br>`rn_health_auto_display_order_action_plan_template` | 신규 action plan template item의 **display order 자동 배정** — 순서 번호를 수동으로 추적·입력할 필요가 없다. ⚠️ **Where: Lightning Experience · Unlimited 에디션만 + Health Cloud**(이 절에서 유일하게 Enterprise 제외). ⚠️ **How: 조직에서 켜려면 Salesforce 관리자에게 문의해야 한다**(*"reach out to your Salesforce admin"*) |
| **Upgrade Home Visit Scheduling with Dynamic Calendar and List Views**<br>`rn_health_home_health_list_calendar_views` | **Home Health Visits Lightning 컴포넌트**를 커스터마이즈해 **캘린더·리스트 뷰 양쪽에 핵심 필드 표시**. **day · week · month · year** 레이아웃 전환. **최대 10개의 서로 다른 방문 상태에 커스텀 색상 배정.** 재예약·방문 검증 같은 액션을 **캘린더에서 직접** 처리. **Where: [HC-EU] + Health Cloud · Home Health 애드온.** **Who: `Manage Home Health` 권한 세트 라이선스.** **How:** Lightning App Builder에서 컴포넌트를 **Person Account 또는 Service Resource 레코드 페이지**에 배치하고 구성 |
| **Speed up Medicare Plan Enrollments with a Guided Flow**<br>`rn_health_dhi_medicare_sales` | **Medicare Advantage · Prescription Drug · Special Needs 플랜**을 **하나의 플로우**로 단계별 판매. **Scope of Appointment 동의를 자동 캡처해 CMS 준수** 유지. **처방약 formulary 즉시 확인 · in-network 제공자 tier 검증 · 48시간 규칙 내 상담 예약.** **면책조항부터 서명까지 대화형으로 완료**해 여러 보험사 로그인 전환이 필요 없다. ⚠️ **Where: [HC-EU] + Health Cloud · Digital Insurance Policy Admin · Digital Insurance Product Admin 애드온.** **Who:** `Digital Health Insurance` · `Digital Health Insurance for Partner Community` · `Medicare Sales for Digital Health Insurance` · `Medicare Sales for Partner Community User` · `Health Cloud Foundation` · `Data Cloud User` · `Data Pipelines Base User` **중 하나** + **`Use Medicare Sales` 사용자 권한 필수**. ⚠️ **How: Setup에서 Digital Insurance · Data Pipelines · Person Accounts · Provider Search · Salesforce Scheduler for Health Cloud 를 모두 켠 뒤** Person Account 레코드 페이지에 **Medicare Sales Flow 액션**을 추가 |

#### New and Changed Objects in Agentforce Health (`rn_health_new_objects`) — 원문 전수

**Digital Health Insurance**

| 대상 | 내용 |
|---|---|
| 신규 `HealthPlanFacilityNetwork` | health plan ↔ **지정 healthcare facility network** 연결. 보험사·제공자가 특정 환자 플랜에서 **어느 시설이 in-network인지 정확히 판정**해 자격 확인·서비스 조율을 돕는 핵심 엔터티 |
| 신규 `HealthPlanFormularyItem` | 특정 health plan에서 **정해진 기간 동안 어떤 약·의료기기·서비스가 급여되는지**. 각 레코드가 **`Product2` 보험 플랜 ↔ `FormularyItem`** 관계를 성립 |
| 신규 `OpportunityProductCategory` | **Opportunity ↔ ProductCategory junction**. 레코드 하나가 opportunity에 연결된 **Medicare 제품 카테고리 1개**(예: Part A · Part C · Part D). 보험 에이전트가 어떤 Medicare part가 판매 기회에 포함됐는지 추적 |
| `Formulary` 신규 필드 `UsageType` | 해당 formulary의 **의도된 용도·맥락** 지정 |
| `FormularItem` 신규 필드 `ItemName` | formulary item에 연결된 **약품명** *(원문 오브젝트명 표기 `FormularItem` 그대로)* |

**Document AI for Health**

| 대상 | 내용 |
|---|---|
| `DocumentExtrctDefProcFldr` 신규 필드 `ContentHubRepository` | Document Extraction Definition Process Folder에 연결된 **Content Hub Repository** |
| `DocumentExtractionRequest` 신규 필드 `ExternalFileIdentifier` | 데이터 추출 요청에 사용된 **외부 데이터 소스의 파일 ID** |

**Clinical Data Model**

| 대상 | 내용 |
|---|---|
| `CareObservation`·`CareObservationComponent` 갱신 필드 `ValueDenominatorUnit` | 관측값 **분모의 측정 단위** |
| `CareObservation`·`CareObservationComponent` 갱신 필드 `ValueTime` | 관측값으로 기록된 **하루 중 특정 시각(hh:mm:ss)** |
| `CareObservation`·`CareObservationComponent` 갱신 필드 `DataAbsentReason` | 관측값 데이터가 **없는 이유** |
| 신규 `CareObservationDetail` | care observation의 **상세** — 특정 lab 결과나 임상의의 구체적 소견 등 환자 건강 평가의 상세 소견·맥락 정보 |

### Insurance (33건 전수)

Winter '27 Insurance는 **Group Benefits(단체보험) 라이프사이클의 전면 신설**이 압도적 비중이고, 그 밖에 **Claims Management 3건 · Brokerage 4건 · 상품 레이팅/플랫폼 5건**이 있다.

**Where 약칭**

| 약칭 | 원문 Where |
|---|---|
| **[DI]** | Lightning Experience · **Enterprise·Unlimited** + **Digital Insurance** |
| **[DI-D]** | Lightning Experience · **Enterprise·Unlimited·Developer** + Digital Insurance *(Claims Management 4건)* |
| **[FSC-BRK]** | Lightning Experience · **Professional·Enterprise·Unlimited** + **Financial Services Cloud + Insurance Brokerage 활성** *(Brokerage 2건 — 이 절에서 유일하게 **Professional 포함**)* |

> ⚠️ **가용 시점:** `rn_insurance_design_advisor` 는 **`When: This feature is available starting October 2, 2026.`** (기능 가용 시점 — Release Update 강제와 무관)

#### Group Benefits (`rn_insurance_group_benefits_container` 허브 + 리프 17)

허브 요약: **census · quote · contract · policy 라이프사이클** 전반의 단체보험 역량 강화 — 신규 등록(enrollment), 계약·증권 endorsement, 갱신(renewal)을 지원해 보험사와 고용주가 **중도 변경과 갱신을 대규모로** 처리한다. **아래 17건 전부 [DI].**

**계약(Contract) 라이프사이클**

| 항목 | 내용 |
|---|---|
| **Speed Up Contract Midterm Adjustments and Renewals by Generating a Baseline Census**<br>`rn_insurance_group_benefits_generate_baseline_census` | 기존 단체보험 계약에서 **공유 census**를 만들어 시작. census에는 **선택한 change date에 활성인 증권에서 뽑은** 구성원·피부양자 인구통계 + **employee class와 플랜 선택**이 들어간다. HR 관리자가 확인·업데이트하고 담당자가 그 census로 갱신·endorsement 견적을 준비. **How:** **Generate Census API** 또는 **Generate Census invocable action을 호출하는 screen flow**. ⚠️ **census 생성은 비동기로 실행된다** |
| **Renew Expiring Group Insurance Contracts for a New Term**<br>`rn_insurance_group_benefits_renew_contract` | 만료 예정 계약의 갱신 견적 준비 — **변경되지 않은 계약 조건과 구성원 혜택을 이월**하고 고용주와 합의한 조건을 갱신. **협상된 loyalty pricing과 갱신 시점 세금·수수료 적용.** 승인된 benefit-class 변경 반영, **보험사와의 관계 기간(how long the group has been associated with the carrier)** 과 규제 준수·오퍼링에 따른 보장 적격성 적용. 확정 후 다음 기간 계약 생성을 자동화하고 **감사용으로 이전 계약과 연결**. **How:** **Generate Quote from Insurance Contract API** 또는 **Create Quote from Insurance Contract invocable action** screen flow로 갱신 견적 생성 → 갱신 조건 스테이징·재가격 → **Renew Contract API** 또는 **Renew Insurance Contract invocable action** 으로 확정 |
| **Adjust Group Insurance Contracts Midterm as Customer Needs and Regulations Change**<br>`rn_insurance_group_benefits_midterm_adjustments` | 보장 추가·피부양자 적격성 확대 같은 중도 변경 요청 시 계약에서 **endorsement 견적** 생성. **보험사 요율 조정이나 규제 세금 변경**은 **개정 조건과 발효일**을 견적에 포함. 재가격 후 확정하면 **다음 계약 버전이 생성되고 이전 계약 조건은 컴플라이언스·감사를 위해 보존**된다. **How:** 위와 동일한 API/invocable action 쌍이되 확정은 **Endorse Contract API** 또는 **Endorse Contract invocable action** |
| **Generate Contract Transactions from Policy Transactions On Demand**<br>`rn_insurance_group_benefits_generate_contract_transactions` | 적격 policy transaction과 그 상세를 **contract transaction / contract transaction detail 로 롤업**해 계약 수준의 재무 영향을 포착. ⚠️ **이미 롤업된 policy transaction은 처리하지 않아** 신규 enrollment·endorsement·renewal·cancellation만 포함되고 **중복 회계가 방지**된다. **transaction detail granularity** 를 구성해 요약 리포팅 또는 상세 재무 분해 선택. **How:** **standalone Contract Transaction Rollup API** 를 contract identifier와 함께 호출. granularity는 **quote-to-contract 변환 시점에 설정**하면 enrollment·endorsement·renewal·rollup 전반에 적용된다 |

**Census · 구성원(Member) 처리**

| 항목 | 내용 |
|---|---|
| **Automate Member Plan Assignment for Straight-Through Processing**<br>`rn_insurance_group_benefits_automate_member_plan_assignment` | 계약의 **group class와 플랜 적격성**을 기준으로 구성원·피부양자에게 root plan과 보장을 배정. **staging census에서 member policy를 생성·갱신.** ⚠️ **제약: 자동 플랜 배정을 쓰는 구성원은 각 product category에서 적격 root plan이 정확히 하나여야 한다 — 여러 개가 적격이면 오류를 반환한다.** 플랜 구성 override가 제공되면 **base eligibility보다 우선**한다 |
| **Clone Group Census Data to Compare Plan Configurations**<br>`rn_insurance_group_benefits_deep_clone_census_data` | census와 그 구성원·플랜·플랜 속성을 **하나의 비동기 작업**으로 복제. 정책 라이프사이클 작업 전에 동일 구성원·그룹에 대한 **플랜 구성별 비용 비교**. 같은 그룹의 census 데이터를 여정 후반에 다시 업로드하지 않고 재사용. **quote↔contract 참조 매핑(reference mapping)** 선택 사용. **How:** **Deep Clone API** 로 census 계층 복제. **복제 없이 기존 census의 플랜만 재매핑하려면 Field Mapper API** 사용 |
| **Configure Bespoke Member Plans for Flexible Benefits**<br>`rn_insurance_group_benefits_bespoke_member_plans_flexible_benefits` | **표준 그룹 구성을 바꾸지 않고** 구성원별 혜택 구성을 커스터마이즈. 견적 또는 census 관리 중 **member-level 플랜·속성 override** 적용. enrollment · 중도 변경 · 갱신 전반에서 커스텀 구성이 보존된다. ⚠️ **견적 중에는 같은 root product와 group class 안에서 한 구성원의 override를 다른 구성원에게 복사**할 수 있다 |
| **Adjust Member Policies Mid-Term for Life Events**<br>`rn_insurance_group_benefits_adjust_member_policies_life_events` | 계약 조건을 바꾸거나 그룹 전체를 재처리하지 않고 **생애 이벤트와 인력 변동**을 처리. **원문이 든 이벤트 전수: employee addition · termination · marriage · birth · promotion · 플랜/보장 변경 요청.** **How:** **Member Mid-Term Adjustment** group census 생성 → 필요한 구성원 변경으로 census 갱신 → 제안 변경 rating → 비용 영향 검토 후 처리 |
| **Keep Member Policies Aligned with Contract Endorsements**<br>`rn_insurance_group_benefits_contract_endorsements_member_policies` | 중도 계약 변경(보장 수정·group class 적격성 변경 등)을 **적격 member policy에 적용**. **How:** 계약의 endorsed 버전 생성 → **Contract Mid-Term Adjustment** group census 생성 → census 업로드 후 **Adjust Policies** 클릭. 또는 **Group Endorsement API** 로 비동기 적용 |
| **Renew Member Policies for the Next Contract Term**<br>`rn_insurance_group_benefits_renew_member_policies_contract_term` | 갱신 계약이 있고 **갱신 enrollment 창이 열리면** 적격 member policy를 갱신. renewal census로 구성원 명부·혜택 선택을 갱신한 뒤 **개별 갱신 대신 단일 벌크 작업**으로 신규 증권 생성. **각 갱신 증권은 (해당되는 경우) 이전 증권과 연결**돼 갱신 이력이 보존된다. **How:** 다음 보장 기간의 갱신 계약 생성 → **Renewal** group census 생성·업로드 → **Renew Policies** 클릭. 또는 **Group Renewal API** 로 비동기 처리 |
| **Process Group Enrollments, Endorsements, and Renewals in Parallel at Scale**<br>`rn_insurance_group_benefits_operations_at_scale` | **여러 group account에 걸친 벌크 enrollment·endorsement·renewal을 동시에** 실행하거나, **같은 account에 대해 상호 배타적인 census를 동시에 벌크 생성**. **하나의 census 안의 가족(family)들도 병렬 처리**돼 대규모 온보딩·갱신 주기가 **며칠이 아니라 몇 시간**에 끝난다. ⚠️ **가족이나 그룹 처리가 실패해도 나머지 작업은 완료되고, 실패는 상세 오류 리포트에서 검토**한다 |

**가격·세금·수수료**

| 항목 | 내용 |
|---|---|
| **Calculate Group Taxes and Fees to Meet Regulatory and Operational Costs**<br>`rn_insurance_group_benefits_calculate_taxes_and_fees` | 세금·수수료 surcharge를 보험료 계산에 말아 넣지 않고 **coverage · member · policy line item 수준에서 포착**. 각 surcharge를 **flat amount · percentage · expression set** 으로 정의하고 **sequence · proration · refund 동작**을 설정. ⚠️ **한도: quote line item당 세금 최대 5개 · 수수료 최대 5개.** 정책 작업 **전**에는 **Group Census Member Plan Surcharge**, 성공 **후**에는 **Insurance Policy Surcharge** 에서 분해를 본다. ⚠️ **rating은 class-level surcharge를 제외한다** |
| **Price Group Benefits Quotes and Policies with an External Rating Engine**<br>`rn_insurance_group_benefits_external_rating_engine` | **외부 rating engine**으로 구성원 수준 분해가 포함된 단체 보험료 계산 — **기존 외부 시스템의 로직을 Salesforce에 다시 만들 필요가 없다**. **외부 엔진이 보험료를 반환한 뒤 세금·수수료는 product surcharge 구성에 따라 계산**된다. **How:** 제품의 **external pricing flow** 로 구성원·플랜 정보를 외부 엔진에 전송하고 **named credential** 로 연결 |
| **Review Cost Impact and Make Better Policy Lifecycle Decisions**<br>`rn_insurance_group_benefits_review_cost_impact_lifecycle` | 처리 **전에** 재무 영향 파악 — **census 요약 수준과 개별 구성원 수준에서 이전 비용과 갱신 비용(보험료·세금·수수료)을 비교**. root product·보장의 **속성 수준 변경**을 구성원·피부양자·플랜·보장별 비용 분해와 함께 검토. **How:** Group Census 레코드에서 **Review Cost Impact** 클릭 → 이전/갱신 비용·순변동·이벤트 건수 비교 후 드릴다운 |
| **Review Member-Level Premiums for Greater Pricing Transparency**<br>`rn_insurance_group_benefits_member_premium_persistence` | root product·보장 수준의 집계 총액에만 의존하지 않고 **개별 구성원·피부양자 비용**을 견적 중에 검토. rating 후 **member-level 보험료·세금·수수료가 영속(persist)** 된다. **계약 기간·endorsement의 견적 시작·종료일 기준 비례 배분(prorated) 비용**도 캡처. **How:** **`Member Stored` census rating type** 으로 견적을 rating한 뒤 quote line item에서 **View Member Level Cost** 를 연다 |

**API·액션**

| 항목 | 내용 |
|---|---|
| **New Connect REST APIs in Group Benefits**<br>`rn_insurance_group_benefits_connect_api_resources` | **신규 리소스 12종 전수** (아래) |
| **New Invocable Actions in Group Benefits**<br>`rn_insurance_group_benefits_new_invocable_actions` | **신규 액션 14종 전수** (아래) |

**신규 Connect REST API 12종 — 원문 전수** *(전부 POST, 명시된 경우만 다름)*

| 리소스 | 용도 · 바디 |
|---|---|
| `/connect/insurance/contracts/{contractId}/actions/generate-quote` | 단체보험 계약에서 **endorsement 또는 renewal 견적 생성**. 요청 `Insurance Create Quote From Contract Input` / 응답 `Insurance Create Quote From Contract` |
| `/connect/insurance/quote-line-items/{rootQliId}/overrides` | **member-level 견적 override 적용 또는 되돌리기** — **POST 또는 DELETE**. 요청 `Member Overrides Input` / 응답 `Member Overrides` |
| `/connect/insurance/contracts/{contractId}/actions/generate-census` | 계약의 증권들로부터 census 생성. 요청 `Insurance Generate Census Input` / 응답 `Insurance Generate Census` |
| `/connect/insurance/group-censuses/{censusId}/members-with-plans` | enrollment 중 구성원과 플랜 선택 추가·갱신 — **POST 또는 PATCH**. 요청 `Members With Plans Input` / 응답 `Members With Plans` |
| `/connect/insurance/group-censuses/{censusId}/actions/deep-clone` | 견적 단계 데이터를 enrollment에 재사용하기 위한 **deep clone**. 요청 `Group Census Deep Clone Input` / 응답 `Group Census Deep Clone` |
| `/connect/insurance/group-censuses/{censusId}/actions/map-fields` | census 필드를 매핑해 **quote·contract 참조 재연결**. 요청 `Group Census Field Mapping Input` / 응답 `Group Census Field Mapping` |
| `/connect/insurance/contracts/actions/issue` | 견적에서 **계약 발행**. 요청 `Insurance Issue Contract Input` / 응답 `Insurance Issue Contract` |
| `/connect/insurance/contracts/actions/endorse` | 견적에서 **새 계약 버전을 만들어 endorse**. 요청 `Insurance Contract Endorse Input` / 응답 `Insurance Contract Endorse` |
| `/connect/insurance/contracts/actions/renew` | 견적에서 **갱신 계약 버전 생성**. 요청 `Insurance Contract Renewal Input` / 응답 `Insurance Contract Renewal` |
| `/connect/insurance/group-censuses/{censusId}/policies/member-plan-adjustment` | census 구성원 플랜을 바꾸는 **벌크 중도 조정(MTA)** 제출. 요청 `Insurance Group Adjustment Input` / 응답 `Insurance Group Adjustment` |
| `/connect/insurance/group-censuses/{censusId}/policies/actions/apply-contract-adjustment` | 계약 endorsement 변경을 **영향받는 member policy에 적용**. 요청 `Insurance Group Endorsement Input` / 응답 `Insurance Group Endorsement` |
| `/connect/insurance/group-censuses/{censusId}/policies/actions/renew` | 갱신 계약 하에서 census 구성원 증권 갱신. 요청 `Insurance Group Renewal Input` / 응답 `Insurance Group Renewal` |
| `/connect/insurance/group-censuses/{censusId}/price-comparisons` | census 전반의 **가격 비교(재무 영향 분석)**. 요청 `Insurance Price Comparison Input` / 응답 **`Rate Comparison`**(응답명이 요청명과 다르다) |

**신규 invocable action 14종 — 원문 전수**

| 액션 | 용도 |
|---|---|
| `generateCensus` | 보험 계약에서 group census **비동기 생성** |
| `refreshCensus` | 보험 계약 데이터로 group census **비동기 갱신** |
| `generateRefreshCensusMembers` | 계약 증권 정보 기반으로 census 구성원과 플랜 구성 생성·갱신 |
| `GetApplicAutoAsgnMbrPlans` | 계약 설정 기반의 **결합된 census member plan 컬렉션** 조회 *(원문 대소문자 표기 그대로)* |
| `getCensusPriceComparison` | 플랜·group class·구성원·보장 전반의 비용 비교로 **census 변경의 재무 영향** 조회 |
| `applyCensMemberOverrides` | 단체 견적에 **member-level 플랜·보장·속성 override** 적용 |
| `issueContract` | 견적에서 단체보험 계약 발행 |
| `applyContractAdjToMemberPolicy` | 계약 중도 조정을 census 구성원에게 적용 |
| `renewGroupCensusMemberPolicies` | 계약 갱신에 따라 census 구성원 증권 갱신 |
| `generateInsuranceContractTrxn` | 단체보험 계약의 **계약 수준 재무 트랜잭션 생성** |
| `endorseContract` | 중도 조정 견적 기반으로 기존 계약에서 **endorsed 계약 버전 생성** |
| `renewInsuranceContract` | 갱신 견적 기반으로 다음 기간 계약을 만들어 단체보험 계약 갱신 |
| `procMbrPlansForMidTermAdj` | 증권 중도 조정을 위한 **member plan 처리** |
| `createQuoteFromInsContract` | 기존 단체보험 계약에서 endorsement 또는 renewal 견적 생성 |

#### Claims Management (`rn_insurance_claims_management` 허브 + 리프 3) — 전부 [DI-D]

| 항목 | 내용 |
|---|---|
| **Protect Claim Budgets with Automated Reserve Checks at Payment Time**<br>`rn_insurance_claims_reserve_checks` | 각 claim에 **loss·expense reserve** 를 직접 설정해 청구 전체의 재무 계획을 세운다(조정관이 claim coverage별로 유지하는 reserve와 별개). ⚠️ **지급 시점 동작이 두 갈래:** **표준 지급은 claim 수준과 coverage 수준 양쪽의 loss·expense 한도 안에 머물고**, **ex-gratia 지급은 경고와 함께 완료**돼 예외 처리가 가능하다. 감독자는 모든 reserve 변경을 **금액과 사유**까지 조회할 수 있고, 지급 후 조정관은 **claim·coverage 양쪽의 잔여 reserve**를 본다 |
| **Streamline Claim Payment Approvals with Built-In Financial Authority Controls**<br>`rn_insurance_claims_financial_authority` | 조정관이 지급을 제출할 때 **자기 권한(authority) 범위 안인지 즉시 확인**되고, **고액 승인 요청은 담당 관리자 큐로 직접** 간다. 승인자를 수동으로 찾거나 이메일 체인을 기다릴 필요가 없고 **모든 결정이 기록**된다 |
| **Improve Claim Payouts by Enforcing Policy Terms for an Insured Asset or Person**<br>`rn_insurance_claims_policy_terms` | 지급액 산정 시 **사고에 연루된 특정 피보험 자산·사람에 정의된 정책 조건**을 자동 적용. **원문 예시 2건: 플릿 증권의 차량마다 자기부담금(deductible)이 다르면 그 차량의 deductible이 반영되고, 의료 증권의 구성원마다 copay가 다르면 그 구성원의 copay가 반영된다.** 조정관은 **각 지급이 자산·사람별 한도에 미치는 영향**을 정확히 추적한다 |

#### Brokerage (`rn_insurance_brokerage_container` 허브 + 리프 4)

| 항목 | 내용 |
|---|---|
| **Manage Large Brokerage Policies with up to 40,000 Records**<br>`rn_insurance_brokerage_manage_large_policies_40000_records` | ⚠️ **증권당 지원 레코드 상한이 2,000 → 40,000 으로 상향.** UI 또는 Connect REST API로 **issue · renew · endorse · repurpose · cancel** 전 라이프사이클 처리. **Where: [FSC-BRK]** |
| **Report on Insurance Attributes with Custom Report Types**<br>`rn_insurance_brokerage_report_on_attributes_with_custom_report_types` | 속성 이름·값을 관련 보험 레코드와 **같은 리포트**에 담기 위해 커스텀 리포트 유형을 만들고 **관련 오브젝트 4종을 추가: `Insurance Policy Attribute` · `Insurance Participant Attribute` · `Insurance Asset Attribute` · `Insurance Coverage Attribute`**. **Where: [FSC-BRK]** |
| **New Connect REST APIs in Brokerage**<br>`rn_ins_brokerage_connect_api_resources` | **신규 리소스 4종(전부 POST) 전수** — `/connect/insurance/brokerage/policies/bulk-endorse-draft`(요청 `Insurance Policy Bulk Field Map Input Representation`) · `/bulk-endorse`(요청 `Insurance Policy Bulk Input`) · `/bulk-issue`(요청 `Insurance Policy Bulk Input`) · `/bulk-reinstate`(요청 `Insurance Policy Bulk Field Map Input Representation`). **응답 바디는 4종 모두 `Insurance Policy Bulk Response`** |
| **New Connect in Apex Methods in Brokerage**<br>`rn_ins_brokerage_connect_in_apex_methods` | 기존 **`ConnectApi.InsuranceBrokerageFamily`** 클래스에 추가된 **신규 메서드 9종 전수** (아래) |

**`ConnectApi.InsuranceBrokerageFamily` 신규 메서드 9종 — 원문 시그니처 그대로**

| 메서드 | 입력 클래스 | 출력 클래스 |
|---|---|---|
| `bulkEndorseInsurancePolicy(insurancePolicyBulkInput)` | `ConnectApi.InsurancePolicyBulkInputRepresentation` | `ConnectApi.InsurancePolicyBulkOutputRepresentation` |
| `bulkEndorseDraftInsurancePolicy(insurancePolicyBulkFieldMapInput)` | `ConnectApi.InsurancePolicyBulkFieldMapInputRepresentation` | `ConnectApi.InsurancePolicyBulkOutputRepresentation` |
| `bulkIssueInsurancePolicy(insurancePolicyBulkInput)` | `ConnectApi.InsurancePolicyBulkInputRepresentation` | `ConnectApi.InsurancePolicyBulkOutputRepresentation` |
| `bulkReinstateInsurancePolicy(insurancePolicyBulkFieldMapInput)` | `ConnectApi.InsurancePolicyBulkFieldMapInputRepresentation` | `ConnectApi.InsurancePolicyBulkOutputRepresentation` |
| `cancelInsurancePolicy(insurancePolicyCancelInput, policyId)` | `ConnectApi.InsurancePolicyCancellationInputRepresentation` | `ConnectApi.InsurancePolicyCancellationRepresentation` |
| `endorseInsurancePolicy(policyId)` | *(없음)* | `ConnectApi.InsurancePolicyIssueOutputRepresentation` |
| `endorseDraftInsurancePolicy(insurancePolicyDraftProcessInput, policyId)` | `ConnectApi.InsurancePolicyDraftInputRepresentation` | `ConnectApi.InsurancePolicyDraftOutputRepresentation` |
| `issueInsurancePolicy(policyId)` | *(없음)* | `ConnectApi.InsurancePolicyIssueOutputRepresentation` |
| `reinstateInsurancePolicy(insurancePolicyReinstatementInput, policyId)` | `ConnectApi.InsurancePolicyReinstatementInputRepresentation` | `ConnectApi.InsurancePolicyReinstatementRepresentation` |

> ConnectApi 네임스페이스 자체의 이번 릴리즈 변경(`ManagedContent*` 계열)은 이 노트 소관이 아니다 → [[Winter '27/Development]].

#### 상품 레이팅 · 플랫폼

| 항목 | 내용 |
|---|---|
| **Boost Tax and Fee Evaluation with the Constraint Rules Engine**<br>`rn_insurance_constraint_rules_engine_tax` | **Constraint Modeling Language(CML)** 로 제품 surcharge의 비즈니스 규칙을 더 유연하게 정의(더 많은 기준·액션). ⚠️ **제품 구성 · 언더라이팅 · exclusion과 clause · 제품 surcharge 의 CML 규칙이 하나의 constraint model로 통합**돼 유지보수가 단순해진다. 견적 rating 시 **Constraint Rules Engine이 제품 surcharge 규칙을 단일 패스로 더 빠르게 평가**한다. **Where: [DI]** |
| **Rate Complex Quotes Faster by Processing Quote Line Items in Parallel**<br>`rn_insurance_quote_line_items_parallel` | **dependency graph를 생성**해 번들 안에서 독립적으로 가격을 매길 수 있는 제품을 판별한다. 그래프가 **교차 종속이 없는 제품 그룹**을 식별하면 rating engine이 **각 그룹을 동시에 처리**한 뒤 가격을 롤업해 net unit price를 결정. **원문 예시: 차량 3대가 있는 자동차 증권에서 각 차량과 그 보장을 순차가 아니라 독립 그룹으로 동시에 가격 산정.** **Where: [DI]** |
| **Quote Insurance and Non-Insurance Products from One Org**<br>`rn_insurance_non_insurance_quotes` | ⚠️ **한 조직 안에 두 워크플로가 공존하고 견적 유형에 따라 적용된다.** **비보험 제품** → **Revenue Management 워크플로**(수량 기반 가격 + 외부 세금), 견적이 **계약·주문으로 전환**. **보험 제품** → **Digital Insurance 워크플로**(위험 기반 rating · 보험료 비례 배분 · 내부 세금·수수료 계산), 견적이 **증권(policy)으로 전환**. **Where: Enterprise·Unlimited + Digital Insurance **및** Revenue Management** |
| **Set Up Insurance Products Faster with an Agentic Advisor**<br>`rn_insurance_design_advisor` | **Insurance Design Advisor** 가 제품 구성이 견적·증권 플로우에 필요한 모든 것을 갖췄는지 점검. **검증 대상 전수(원문): selling model · pricebook entry · pricing procedure · attribute · 사용자 권한 · context definition 등.** **구조화된 검증 결과 + 단계별 remediation 가이드**를 반환한다. **Agentforce에서 자연어로 묻거나 원하는 MCP 클라이언트를 쓸 수 있다.** ⚠️ **검증은 독립적으로 실행돼 하나씩 발견하는 대신 단일 패스로 모든 이슈를 보여준다.** **Where: [DI]. When: 2026-10-02** |
| **Migrate More Insurance Setup Data Between Orgs**<br>`rn_insurance_setup_data_migration` | **`sf data setup transfer`** 명령의 **내장 dataset definition이 확대**돼 **clause · underwriting rule · surcharge · group benefits product · CML 규칙**을 조직 간 복제할 수 있다. ⚠️ **이전엔 insurance product model에만 내장 정의가 있어 나머지는 커스텀 정의를 직접 작성해야 했다.** **Where: [DI].** **How:** **`plugin-data-setup-transfer` Salesforce CLI 플러그인**을 설치·업데이트 → source·target 조직에 인증 → 내장 dataset definition 중 하나로 명령 실행 |

```bash
# 원본 릴리즈 노트가 명시한 CLI 표면 (rn_insurance_setup_data_migration)
sf data setup transfer
```

#### New and Changed Objects in Insurance (`rn_insurance_new_changed_objects`) — 원문 전수

**Group Benefits — 신규 오브젝트 4**

| 오브젝트 | 용도 |
|---|---|
| `GrpCensusMemberPlanAttr` | 각 **contract group plan에 선택된 속성** 조회 |
| `GrpCensusMbrPlanSurcharge` | group census member plan의 **세금·수수료 포함 요금 계산** |
| `InsuranceContractTrxn` | 보험 계약에 대해 생성된 **재무 트랜잭션**(보험료·세금·수수료 처리 금액 포함) 추적 |
| `InsuranceContractTrxnDtl` | 계약 트랜잭션을 **group plan·class 별로 보험료·세금·수수료로 분해** |

**Group Benefits — `InsuranceContract` 신규 필드 10**

| 필드 | 의미 |
|---|---|
| `ActualRenewalDate` | 새 갱신 기간이 **실제로 발효된 확정일** |
| `IsContractLocked` | 계약이 **편집·삭제가 잠겼는지** 표시 |
| `OriginalContract` | 중도 endorsement 체인이 거슬러 올라가는 **루트 계약** 식별 |
| `OriginalEndDate` | **단축되기 전** 원래 의도된 기간 만료일 |
| `OriginalStartDate` | **중도 조정 전** 원래 의도된 기간 시작일 |
| `PlannedRenewalDate` | 계약의 **다음 기간 갱신 예정일** |
| `PriorContract` | 계약 버전을 **직전 버전**과 연결 |
| `RenewedFromContract` | 새 갱신 기간을 **원래 계약**과 연결 |
| `ShouldAutoAssignPlan` | 계약의 구성 매핑 규칙에 따라 **플랜을 구성원에게 자동 배정할지** |
| `TransactionDetailLevel` | 계약의 트랜잭션 상세가 생성되는 **granularity**(plan · coverage · charge 수준 등) |

**Group Benefits — 기타 기존 오브젝트 변경**

| 오브젝트 | 신규 필드 |
|---|---|
| `GroupCensusMember` | `EventAction`(Add · Remove · Update 등 이벤트 시 취할 액션) · `EventEffectiveDate` · `EventType` · `OverrideTypeConfiguration`(허용되는 override 수준) |
| `GroupCensusMemberPlan` | `EventAction` · `IsOptional`(플랜이 선택인지 필수인지) · `OverrideTypeStatus` · `ProductCategory` · `QuoteLineItem` · `StandardFeeAmount` · `StandardPremiumAmount` · `StandardTaxAmount` |
| `ContractGroupPlan` · `ContractGroupPlanGroupClass` · `QuoteLineItem` | **`PlanAllocationType`** — 혜택이 그룹 구성원에게 **어떤 방식으로 제공되는지** (세 오브젝트 모두 동일 필드명) |
| `InsurancePolicyParticipant` | `GroupClass` |
| `InsPolicyTransactionDetail` | `GroupClass` · `ContractGroupPlan` |
| `InsurancePolicyTransaction` | `InsuranceContractTrxn`(롤업 대상 계약 트랜잭션과 연결) · `OriginatingProcess`(트랜잭션을 만든 비즈니스 프로세스) |
| `InsuranceAsyncBulkRequestItem` | `ItemType` — 벌크 요청 항목이 **독립 처리되는지 aggregation의 일부인지** |

**Claims Management**

| 대상 | 내용 |
|---|---|
| 신규 `ClaimReserveAdjustment` | 청구의 **loss·expense reserve 금액 조정** 추적 |
| `Claim` 신규 `LossReserveAmount` | claim coverage 전반의 **loss 항목 누적 지급 상한** |
| `Claim` 신규 `ExpenseReserveAmount` | claim coverage 전반의 **expense 항목 누적 지급 상한** |
| `ClaimCoveragePaymentDetail` 신규 `PaymentInitiatedBy` | 지급을 위해 **제출한 사용자** 식별 |

**Product Rating**

| 대상 | 내용 |
|---|---|
| 신규 `ProductRelationshipGraph` | rating·구성용 **보험 제품 ↔ 관련 제품 관계** 포착 |
| `ProductSurcharge` 신규 `RuleEngineType` | 제품 surcharge 평가에 사용되는 **rule engine** 지정 |
| `InsurancePolicySurcharge` 신규 `ConstraintModelDeveloperName` | surcharge 규칙 평가에 쓰는 **constraint model** |
| `QuoteItemTaxItem` 신규 `ConstraintModelDeveloperName` | **세금**용 surcharge 규칙 평가 constraint model |
| `QuoteLinePriceAdjustment` 신규 `ConstraintModelDeveloperName` | **수수료**용 surcharge 규칙 평가 constraint model |

### Life Sciences (Agentforce Life Sciences) — 31건 전수

**Where 약칭**

| 약칭 | 원문 Where |
|---|---|
| **[LSC-CE]** | Lightning Experience · **Enterprise·Unlimited** + **Life Sciences Cloud 라이선스** + **Life Sciences Cloud for Customer Engagement 애드온 라이선스** + **Life Sciences Cloud for Customer Engagement 관리형 패키지 설치** |
| **[+iPad]** | 위에 더해 **Life Sciences Cloud 모바일 앱 for iOS (iPad only)** 에서도 제공 |
| **[LSC-OM]** | [LSC-CE] + **Revenue Lifecycle Management 애드온 라이선스** (Order Management 3건) |

> ⚠️ **원문이 에디션을 아예 적지 않는 2건** — `rn_lsc_customer_engagement_automate_content_ingestion` 과 `rn_lsc_enablement_coaching_view_historical_evaluation_scores` 는 *"This feature is available **with** the Life Sciences Cloud license…"* 로 시작해 **Lightning Experience·에디션 문구가 없다**. 추정하지 않고 원문 그대로 둔다.

#### Engagement Execution (`rn_lsc_customer_engagement_execution` 허브 + 리프 3)

| 항목 | 내용 |
|---|---|
| **Enable Voice-Based Visit Logging (Generally Available)** 🟢GA<br>`rn_lsc_customer_engagement_execution_visit_agent` | **Visit Agent** — HCP(healthcare provider) 방문 상세를 **음성으로 기록**한다. 담당자의 노트를 **기기 위에서(on device)** 처리해 **product detail · message · reaction · presentation · place · time** 을 방문 레코드에 채우며 **인터넷 없이도 동작**한다. 저장 전 담당자가 검토·편집 가능. ⚠️ **Visit Agent는 영어만 지원한다.**<br>⚠️ **이 릴리즈에서 전제 조건이 가장 무거운 기능이다 — 원문 전수:** **Where:** **Life Sciences Cloud 모바일 앱 for iOS(iPad)** · **Enterprise·Unlimited** + **Life Sciences Cloud** + **Agentforce for Life Sciences Cloud 애드온**. **Who:** 현장 담당자에게 **`Access Custom Agents` 권한 세트** 필요. **How:** Setup → Quick Find **`Life Sciences for Customer Engagement Setup`** → **Set Up Custom Agents** → **Visit Agent 켜기** → 담당자에게 `Access Custom Agents` 배정. **로그인 시 앱이 Whisper speech-to-text 모델을 자동 다운로드한다(약 632 MB).** **담당자는 iPad에서 Apple Intelligence를 켜야 한다.** ⚠️ **이전 릴리즈에서 Visit Agent 파일럿을 켰던 조직은 사용자에게 새 `Access Custom Agents` 권한 세트를 다시 배정해야 계속 쓸 수 있다.**<br>**Why(원문):** 전사 정확도를 높이기 위해 Visit Agent가 **녹음 전에 territory에 정렬된 제품명을 자동 로드**한다 — 이 contextual priming에는 **관리자 구성이 필요 없다**.<br>⚠️ **Note 전수 — HCP Reactions의 성격:** HCP Reactions는 담당자의 구술 진술로부터 **기기 위에서 추론된 AI 생성 초안 요약**이며 **positive · negative · neutral 세 라벨 중 하나**다. 저장 전 담당자가 모든 reaction을 검토·편집한다. **의학적 소견도, 심리 평가도, HCP 의도의 권위 있는 기록도 아니며 Salesforce는 이를 다운스트림 의사결정이나 스코어링에 사용하지 않는다.** 원문 결론: *"Treat them as decision-support drafts only."* |
| **Capture Attendee Details Faster in Group Visits**<br>`rn_lsc_customer_engagement_execution_enhanced_group_visits` | **Attendee Visit 액션이 부모 방문의 Attendees 섹션에 바로** 표시된다. Attendee Visit Engagement 페이지 상단의 **참석자 이름 버튼**을 클릭하면 현재 레코드를 저장하고 다음 참석자 방문을 **한 단계로** 연다. **이전엔 다른 참석자로 전환하려면 부모 방문으로 되돌아가야 했다.** **Where: [LSC-CE] [+iPad]** |
| **Capture Consent in More Ways**<br>`rn_lsc_customer_engagement_capture_consent_more_ways` | 동의 수집 방법 **2종 신설 — 구두 동의(verbal consent) · 종이 양식에 대한 문서 참조(document reference).** ⚠️ **최소 1개의 proof를 필수로 지정**해 근거 없는 동의가 남지 않게 하면서 담당자에게 방법 선택권을 준다. **Where: [LSC-CE] [+iPad].** **How:** **Admin Console → Consent Administration** 에서 **모바일과 웹 각각**의 consent proof 설정 구성 |

#### Account Management (`rn_lsc_customer_engagement_account_management` 허브 + 리프 3)

| 항목 | 내용 |
|---|---|
| **Clone Activity Plans Instead of Building Them from Scratch**<br>`rn_lsc_customer_engagement_activity_plan_cloning` | 기존 플랜을 복제해 activity plan을 만든다 — **수천 개 레코드를 수동 생성하거나 데이터 임포트할 필요가 없다**. 선택한 **기간과 territory**에 대해 플랜의 **goal·goal measure 계층 전체**를 복사한 뒤, **현재 territory alignment에 동기화**하고 계정별 목표를 미세 조정해 활성화. **Where: [LSC-CE].** **How:** App Launcher → **Life Sciences Commercial** → **Activity Plans 탭** → **Clone Plan** |
| **Review and Adjust Activity Plans in the Mobile App**<br>`rn_lsc_customer_engagement_activity_plan_review_mobile` | 현장 담당자가 **iPad 모바일 앱에서** 배정 목표 검토, **interaction target 조정**, 계정 추가·제거, 승인 제출을 수행한다. ⚠️ **원문 명시: 인터넷 연결이 필요하다**(*"with an internet connection"*) — 오프라인 지원 기능이 아니다. **Where: [LSC-CE] [+iPad]** |
| **Manage Complex Territory Alignments with Advanced Rules**<br>`rn_lsc_customer_engagement_account_territory_alignment` | Sales Planning에서 **advanced rule** 을 구성하고 **반복 스케줄로 실행**해 alignment를 최신 상태로 유지 — **커스텀 구현이나 외부 alignment 도구가 필요 없다**. **HCP specialty · 지리 정보 · 복수 주소 · 기타 세분화 기준**으로 territory alignment 생성(**주소와 specialty를 지원하는 CRM Analytics 데이터셋** 사용). ⚠️ **Where: [LSC-CE] + Sales Performance Management(SPM)·Territory Planning(TP) 패키지 필요.** **How:** ① CRM Analytics 데이터셋을 생성하는 **Data Processing Engine 템플릿을 복제·활성화** ② **Sales Planning Setup**에서 데이터셋과 사용 가능한 rule field 선택 ③ 플랜 생성 후 **Segment Builder**에서 세그먼트 정의 ④ **`Refresh and Execute Territory Planning Rules` 플로우**를 커스터마이즈·활성화·실행해 배치 잡 트리거 ⑤ **specialty 기반 규칙을 쓰려면 Admin Console에서 `Healthcare Provider Specialty` 트리거 핸들러를 켠다** |

#### Enablement Coaching (`rn_lsc_enablement_coaching` 허브 + 리프 5)

| 항목 | 내용 |
|---|---|
| **Build Standardized Evaluations with the Discovery Framework**<br>`rn_lsc_enablement_coaching_build_standardized_evaluations_with_discovery_framework` | **Discovery Framework와 OmniStudio**로 assessment 템플릿 작성 — 관리자가 **question bank 저작 · 채점 기준 구성 · 역량별 가중치 배정**. 템플릿은 **scoring question**을 지원해 모든 직원이 동일 기준으로 평가된다. **Where: [LSC-CE].** ⚠️ **Who: `Life Sciences Commercial Admin` 권한 세트 + `Assessment Platform User` 권한** |
| **View Historical Evaluation Scores to Track Employee Development**<br>`rn_lsc_enablement_coaching_view_historical_evaluation_scores` | 코칭 세션 시작 시 **동일 assessment 템플릿을 쓴 가장 최근 완료 평가의 점수**를 나란히 조회. **Where: 에디션 미명시 — Life Sciences Cloud 라이선스 + Customer Engagement 애드온 + 관리형 패키지 설치.** **How:** 이전에 쓴 템플릿으로 세션을 만들면 **이전 점수가 자동으로 채워진다**. 이전 점수는 **Evaluation 탭**에 현재 응답과 나란히 표시되며 **`Show Previous Evaluation Score` 토글**로 켜고 끈다 |
| **Link Field Visits with Evaluations**<br>`rn_lsc_enablement_coaching_link_field_visits_with_evaluations` | 코칭 세션에 **현장 활동을 연결**해 **관찰이 언제 어디서 수집됐는지 문서화하는 감사 추적**을 만든다. 개별 또는 복수 방문 연결 가능. **Where: [LSC-CE].** **How:** 세션이 **Planned 또는 Self-Evaluation 상태일 때** 관련 목록에서 방문 레코드를 선택. **연결된 방문은 세션 헤더에 표시되고, 세션이 공유된 뒤에야 coachee에게 보인다** |
| **Complete Coaching Evaluations Anywhere with Offline Support**<br>`rn_lsc_enablement_coaching_complete_evaluations_anywhere_with_offline_support` | **인터넷 연결 없이** 병원 방문·현장 동행 중에 평가 전체를 완료하고 온라인 복귀 시 동기화. **Where: [LSC-CE] [+iPad].** **How:** 코치가 모바일 앱에서 Enablement Coaching 세션에 접근 |
| **Schedule and Track Coaching Sessions from Calendar**<br>`rn_lsc_enablement_coaching_schedule_and_track_from_calendar` | **캘린더 그리드에서 세션을 만들면 즉시 표시**돼 일정 충돌을 예방한다. ⚠️ **직원은 코치가 공유한 뒤에야 세션을 볼 수 있어 계획 단계에서는 평가가 비공개로 유지된다.** **Where: [LSC-CE] [+iPad].** **How:** Admin Console에서 **calendar event metadata**를 구성해 코칭 세션을 캘린더 뷰에 매핑 → 코치가 캘린더 그리드 또는 Enablement Coaching 탭에서 세션 생성 → **Salesforce가 연관 캘린더 이벤트를 자동 생성** |

#### Event Management (`rn_lsc_customer_engagement_event_management` 허브 + 리프 4)

| 항목 | 내용 |
|---|---|
| **Gain Insights into Projected Costs by Using Monetary Caps**<br>`rn_lsc_customer_engagement_event_management_estimated_monetary_caps` | 실제 비용 발생 **전에** 추정 비용을 개별 참가자에게 배분해 지출 거버넌스 강화. **이벤트에 계정을 추가하는 시점에 monetary cap을 검사**하고, 한도 초과 시 즉시 알림, 초과·불일치를 플래그. **Where: [LSC-CE] [+iPad].** ⚠️ **How: Developer Console에서 `Provider Activity Measure Type` 레코드를 만들어 actual · estimated · committed 버킷의 monetary cap을 설정한다** |
| **Stay Compliant by Limiting the Number of Events Each Account Can Attend**<br>`rn_lsc_customer_engagement_event_management_utilization_limits` | 참가자 추가 전 참석 횟수 확인 부담을 줄인다 — **한도를 초과하는 참석자를 추가할 때 실시간 경고·차단**하고 **불일치를 감사·리포팅용으로 자동 로깅**. **신규 `Recalculate Account Utilization Count` 배치 잡**으로 계정을 일괄 처리해 사용 횟수를 빠르게 평가. **Where: [LSC-CE] [+iPad].** **How:** Developer Console에서 `Provider Activity Measure Type` 레코드로 account utilization limit 설정 |
| **Extend Account Merge to Include Estimated Expense Calculations**<br>`rn_lsc_customer_engagement_event_management_extend_account_merge_estimated_expenses` | Account Merge가 **estimated·committed 비용을 포함한 관련 비용 유형**까지 결합한다. ⚠️ **이전엔 Account Merge가 actual 비용만 계산할 수 있었다.** **Where: [LSC-CE]** |
| **Strengthen Data Monitoring by Using the New Event Management Trigger Handlers**<br>`rn_lsc_customer_engagement_event_management_new_trigger_handlers` | **신규 트리거 핸들러**로 ① **Managed Event · Managed Event Participant 변경에 utilization limit를 동기 유지** ② **monetary cap을 우회하는 레코드 갱신을 차단하거나 플래그** ③ **estimated expense나 참가자 배분이 바뀌면 expense bucket을 자동 갱신**. **Where: [LSC-CE] [+iPad].** **How:** **Admin Console의 `Trigger Handler Administration` 타일**에서 트리거 핸들러 활성화 |

#### Order Management (`rn_lsc_order_management_release_highlights` 허브 + 리프 5)

| 항목 | 내용 |
|---|---|
| **Set Up Order Management Features from a Single Location**<br>`rn_lsc_order_management_salesforcego` | Salesforce Go 한곳에서 Order Management 기능을 발견·설정하고 도움말·콘텐츠 리소스에 접근. **Where: [LSC-OM] [+iPad].** **How:** Setup → Salesforce Go → **Agentforce Life Sciences** → **`LSC Order Management` 와 `Store Check` 를 켠다** |
| **Conduct Faster, Accurate In-Store Execution with Store Check**<br>`rn_lsc_customer_engagement_store_check` | 약국 같은 리테일 매장에서 **제품 성과를 평가하는 in-store execution**. Store Check로 측정할 **활동과 KPI**를 정의하면 **매장별 목표와 캡처 값을 비교**해 현장 사용자가 **재고 결품과 컴플라이언스 이슈를 실시간으로** 식별한다. **방문 시작 시 현장 사용자 위치를 캡처하는 geolocation tracking** 구성, 설문으로 실행 가능한 인사이트 생성. ⚠️ **Where: [LSC-CE] + `Agentforce for LifeSciences Cloud` 애드온 라이선스 [+iPad]**(Order Management의 RLM 애드온이 아니라 Agentforce 애드온이다). **How:** Setup → Salesforce Go → **Agentforce Life Sciences** → **Store Check 켜기** |
| **Manage Quoted Orders from Anywhere**<br>`rn_lsc_order_management_create_quotes_from_anywhere` | 현장 담당자가 웹 또는 모바일에서 **오프라인 상태에서도** 견적 주문을 만들고 제품을 추가해 승인 제출. **계정의 마지막 주문이나 assortment에서 주문을 사전 채움**해 수동 입력·라인 아이템 오류를 줄이고 **디지털 서명 캡처**로 현장에서 마감. **제출된 주문에 대한 무단 편집을 제한하는 승인 워크플로**를 구성할 수 있고 **영업 관리자는 여전히 잠금 해제·승인**이 가능하다. **Where: [LSC-OM] [+iPad].** **How:** Setup → Salesforce Go → Agentforce Life Sciences → **LSC Order Management 켜기** |
| **Create Consistent and Transparent Quoted Orders with Pricing Procedures**<br>`rn_lsc_order_management_automate_order_calculations` | 데스크톱 사이트에서 **제품 기본가와 pricing procedure**를 설정해 모든 견적 주문의 가격·할인을 자동 계산(**pricing element와 discount 추가**). **price waterfall** 을 구성하면 담당자가 매장 관리자에게 **라인 수준 net order price와 단계별 가격 분해**를 보여줄 수 있다. ⚠️ **가격 계산을 중앙화하므로 모바일 앱에서 오프라인일 때도 동일한 가격이 나온다.** **Where: [LSC-OM] [+iPad].** **How:** App Launcher → **Pricing Procedure** |
| **New and Changed Invocable Actions in Life Sciences**<br>`rn_lsc_order_management_new_changed_invocable_actions` | **Order Management 신규 액션 4종 전수:** `getQualifiedProducts`(지정 계정·territory에 적격한 제품) · `setLsQuoteDocumentDefaults`(**FlexiPage 템플릿**을 이용해 quote document에 기본값 설정) · `shareQuoteBasedOnAccount`(**account territory alignment 기준**으로 견적 공유) · `evaluateAccess`(지정 access check가 현재 사용자에게 활성인지 반환) |
| **New and Changed Objects for Life Sciences**<br>`rn_lsc_order_management_new_changed_objects` | 아래 표 전수 |

#### Intelligent Content · Patient Engagement · 콘텐츠 수집 · 분석

| 항목 | 내용 |
|---|---|
| **Manage Data Retention for Presentation Interactions**<br>`rn_lsc_customer_engagement_intelligent_content_data_retention`<br>*(컨테이너 `rn_lsc_customer_engagement_intelligent_content`)* | 담당자가 HCP에게 프레젠테이션을 전달하며 쌓이는 상호작용 데이터가 무한히 누적되지 않도록, **페이지 조회·콘텐츠 인게이지먼트를 추적하는 presentation click stream 레코드의 보존 기간**을 정의. **수동 정리 또는 자동 실행 잡 예약**으로 조직 스토리지 고갈을 방지. **Where: [LSC-CE].** **How:** **Intelligent Content Admin Console → Data Retention 탭** |
| **Digital Verification Setup Is Changed for Internal and Portal Users**<br>`rn_lsc_patient_engagement_atm_digital_verification` | ⚠️ **설정 방식 자체가 바뀐 항목.** **이전엔 내부 사용자용으로 connected app을 구성해야 했다.** **Winter '27부터 내부 사용자에게는 connected app이나 external client app 구성이 필요 없다.** **포털 사용자**에 대해서는 이제 **external client app** 을 구성할 수 있다. ⚠️ **Where: Lightning Experience · Enterprise·Unlimited + `Life Sciences Advanced Therapy Management` 애드온 라이선스**(이 절에서 유일하게 Customer Engagement 계열이 아니다). **How:** Setup에서 **필요한 OAuth 설정을 갖춘 external client app 구성** → **Consumer Key·Consumer Secret 으로 연결된 auth provider 생성** → 그 auth provider에 연결된 **named credential 생성** → **커뮤니티 사이트가 게시돼 있고 headless login으로 구성돼 있는지 확인** → **커뮤니티 사이트 도메인을 Remote Site Settings에 추가** |
| **Seamlessly Import External Remediated Content into Life Sciences Cloud**<br>`rn_lsc_customer_engagement_automate_content_ingestion` | **Content Ingestion API** 로 외부 DAM(digital asset management) 시스템의 remediated 콘텐츠를 수집. **source-agnostic REST API** 가 준비된 **ZIP 패키지(CLM 프레젠테이션) · PDF · 사전 구성 이메일 템플릿**을 적재하고 **territory 배포와 활성화를 자동화**한다. **Where: 에디션 미명시 — Life Sciences Cloud + Customer Engagement 애드온 + 관리형 패키지.** ⚠️ **Who: Content Ingestion API는 `MuleSoft Anypoint Platform` 구독이 있는 사용자에게 제공된다.** 통합 사용자는 **`Life Sciences Commercial` 과 `Salesforce API Integration` 라이선스에 기반한 커스텀 권한 세트** + 매핑된 LSC 오브젝트·필드 접근이 필요 |
| **Add Tableau Next Components to Lightning Pages**<br>`rn_lsc_tableau_next_lightning_page_embed` | **Metric · Visualization · Dashboard 컴포넌트**를 Lightning App Builder로 **레코드 페이지와 홈 페이지**에 추가. ⚠️ **이전엔 Tableau Next 콘텐츠가 전용 metrics 탭에서만 제공돼 현장 사용자가 작업에서 이탈해야 했다.** **Where: [LSC-CE] + `Tableau Next` 애드온 라이선스 [+iPad].** **How:** Lightning App Builder의 **Standard 섹션**에서 컴포넌트를 드래그 → 필수 필드 구성 → 페이지 활성화. 현장 사용자는 모바일 앱에서 **데이터 포인트 탭과 드롭다운**으로 임베드 콘텐츠와 상호작용 |

#### New and Changed Objects for Life Sciences (`rn_lsc_order_management_new_changed_objects`) — 원문 전수

**Order Management — 신규 오브젝트 2**

| 오브젝트 | 용도 |
|---|---|
| `DistributionChannel` | 주문·판매의 이행 방식을 지정하는 **유통 채널 목록** — **direct order · transfer order** |
| `QuoteDocumentCreationEvent` | **quote document가 생성될 때 발생하는 이벤트** |

**Order Management — `Quote` 오브젝트 신규 필드 9**

| 필드 | 의미 |
|---|---|
| `Visit` | 견적이 생성된 **방문** |
| `Requested First Delivery Date` | 고객이 요청한 **최초 배송 희망일** |
| `CaptureDate` | 견적 **생성일** |
| `PaymentTerm` | 견적의 **결제 조건** |
| `BillingContactPointAddress` | 견적의 **청구 주소** |
| `TotalFreeQuantity` | 견적의 **무상 제공 총 수량** |
| `TotalQuantity` | 견적 **전 품목의 총 수량** |
| `AdditionalInformation` | 견적 생성 중에 캡처되지 않은 **추가 정보** |
| `AggregationStrategy` | **누적 가격(cumulative pricing)** 에 사용되는 집계 전략 |

> ⚠️ **원문 자체의 불일치 1건:** *"Represent a quote's shipping address — Use the new `ShippingContactPointAddress` field on the existing **Provider Engagement Compliance Cycle** object."* — **설명은 견적의 배송 주소인데 오브젝트명이 `Provider Engagement Compliance Cycle`** 로 적혀 있다. 추정해 고치지 않고 원문 그대로 남긴다.

**Order Management — 기타 오브젝트**

| 오브젝트 | 신규 필드 |
|---|---|
| `Quote Line Item` | `AdditionalFreeItemQty`(quote line item에 **수동으로 추가된 무상 품목 수량**) · `TotalQuantity`(라인 아이템 수준 총 수량) |
| `Quote Line Group` | `ShippingContactPointAddress`(제품 배송 주소) |

**Event Management**

| 오브젝트 | 신규 필드 |
|---|---|
| `Estimated Expense` | `IsAllocationUneven` — 추정 비용이 managed event 참가자들에게 **불균등하게 배분되는지** 표시 |

### Manufacturing (Agentforce Manufacturing) — 16건 전수

**Where 약칭**

| 약칭 | 원문 Where |
|---|---|
| **[MFG-AF]** | Lightning Experience · **Enterprise·Performance·Unlimited** + **Agentforce for Manufacturing 애드온 라이선스** 또는 **Agentforce 1 Manufacturing Edition** 포함 |
| **[MFG-TN]** | Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Agentforce Manufacturing · Einstein For Manufacturing · Data 360** |
| **[MFG-EU]** | Lightning Experience · **Enterprise·Unlimited** + Agentforce Manufacturing |

#### Agentforce for Manufacturing (`rn_mfg_agentforce_parent` 허브 + 리프 4)

| 항목 | 내용 |
|---|---|
| **Accelerate Manufacturing Warranty Claim Adjudication with Agentforce**<br>`rn_mfg_warranty_claim_adjudication_agent` | **Warranty Claims Adjudication 에이전트** — 큐 물량·aging·미결 책임 요약, 미결 청구를 **가치·경과일·복잡도**로 랭킹, **중복 시리얼 번호·반복 자산 고장 등 부정 리스크 플래그**, 누락 필드·커버리지·첨부 감사, **RFI 초안 작성**. *"Human experts stay in full control of every decision."* **Where: [MFG-AF].** **Who:** `Manufacturing Foundation User` · `Claims Management Foundation` · `Warranty Lifecycle Management`. **How:** Agentforce 패널에서 발화 입력(예: *"Show claim history for Acme Partners."*). **Slack에서도 `Warranty Claims Adjudication for Slack` 템플릿으로 작업 가능** <br>*(Automotive의 같은 이름 에이전트와 대응되는 기능이다 — 권한 세트만 `Automotive Foundation User` ↔ `Manufacturing Foundation User` 로 다르다)* |
| **Close Deals Faster in Slack with Industries Sales Assistance**<br>`rn_mfg_industries_sales_assistance_slack` | **Slack 안에서** 대화형 프롬프트로 제품·부품 검색, 가격 확인, 유통사 위치 파악, **opportunity·견적 생성 · trade-in 요청 · 고객 이메일 초안**. **account intelligence와 AI 기반 next best action이 Slack에 직접** 노출된다. **Where: [MFG-AF].** ⚠️ **Who: Industries Sales Concierge 서브에이전트를 쓰려면 `Criteria-Based Search and Filter` · `Inventory Search And Transfer` · `Partner Lead Management` · `Manage Appraisals and Valuations` 권한 세트가 필요하다.** **How:** Slack에서 에이전트를 실행하고 발화 입력(예: *"show me products manufactured by Acme Industries."*) |
| **Build Manufacturing Ready Agents in the New Agentforce Builder**<br>`rn_mfg_agentforce_builder` | 새 빌더에서 제공되는 에이전트 **2종: Asset Service Management · Industries Sales Concierge.** **내장 AI 지원 + Agent Script 기반 워크플로**, **preview · test · trace · debug**. *"More manufacturing agents move to the new builder in upcoming releases."* **Where: [MFG-AF].** **How:** Agentforce Studio **Agents 탭 → New Agent**. ⚠️ **기존 에이전트는 영향받지 않는다** |
| **Set Up Industries Sales Concierge Agent with a Single Click**<br>`rn_mfg_single_click_setup` | **Industries Sales Concierge Agent 번들** 설치 — 선행 기능 활성화, 권한 세트 배정, 필수 메타데이터·샘플 데이터 설치, **모든 설정 단계와 enablement 링크의 단일 뷰** 제공. **Where: Enterprise·Performance·Unlimited + Agentforce Manufacturing.** **Who:** 제조 역량을 설정·구성하는 관리자. **How:** Setup → Salesforce Go → **Initial Setup 탭** → Manufacturing으로 필터 → 번들 설치 |

#### Warranty · Order · Pricing

| 항목 | 내용 |
|---|---|
| **Accelerate Warranty Claim Refunds with Automated Parts Returns**<br>`rn_mfg_warranty_parts_return` | **보증·리콜 부품 반품 요청**을 가이드형 사전 구축 service process로 개시·관리 — **유통사가 결함 부품을 OEM에 반품**할 수 있다. **Where: Enterprise·Performance·Unlimited·Developer + Agentforce Manufacturing + Data 360.** **Who:** `Service Part Return Management` · `Warranty Lifecycle Management` 권한 세트. ⚠️ **How: Warranty Parts Return service process는 기본 제공(out of the box)이지만, 유통사가 반품 요청을 개시하려면 service process configuration에 배정해야 한다** |
| **Calculate Advanced Pricing for Manufacturing Sales Orders**<br>`rn_mfg_advanced_pricing_sales_orders` | **ERP 가격 로직을 미러링하도록 구성 가능한** 엔터프라이즈급 가격 엔진. ⚠️ **엔진이 지원하는 가격 계산 유형은 35종 초과**(*"over 35 pricing calculation types"*) — **고객 계층 · 복수 측정 단위 · 볼륨 기반 할인 · 프로모션 · surcharge** 포함. **가격이 ERP 인보이스와 정확히 일치**해 분쟁과 수동 계산이 사라진다. **Why(원문):** 엔진은 **계층적 검색 시퀀스**로 각 거래에 가장 구체적인 가격을 찾는다 — **고객 특정 규칙과 프로모션 가격에서 시작해 일반 base pricing까지** 내려간다. **Where: [MFG-EU].** ⚠️ **Who — 필요한 라이선스·권한이 특히 많다:** `Advanced Pricing for Manufacturing` · `BRERuntimeAddOn` · `BREDesignerAddOn` · `Salesforce Pricing Admin` · `Salesforce Pricing Design Time User` · `Salesforce Pricing Manager` · `Salesforce Pricing Run Time User` · `Context Service` · `Data Processing Engine` 및 지원 라이선스. **How:** Setup에서 **Advanced Pricing for Manufacturing 켜기 → Context Definitions 활성화 → Salesforce Pricing 구성 → ERP 가격 데이터 적재 → Order 레코드 페이지에 `Pricing Details` 컴포넌트 추가** |
| **Drive Accurate Order Capture with Integrated Pricing**<br>`rn_mfg_order_capture_integrated_pricing` | 가이드형 워크플로로 복잡한 주문을 캡처·관리하며 **가격·할인 지원이 통합**된다. **재사용 가능한 order specification**이 주문 동작·가용 제품·assortment·**복수 측정 단위**를 정의하고 자동 가격 계산이 정확도를 보장한다. **Where: [MFG-EU].** **Who:** `Order Capture for Manufacturing` · `Industries Service Excellence` 및 가격 관련 라이선스. **How:** Setup에서 **Order Capture 켜기** → 참조 데이터 구성 + order specification 생성 → 담당자는 **Service Console for Telesales** 를 열고 계정에서 주문 개요를 보며 생성·갱신 |

#### Tableau Next for Manufacturing (`rn_mfg_tableau_next_parent` 허브 + 리프 5) — 전부 [MFG-TN]

허브 요약: **Manufacturing Insights** 가 계정 성과·제품 수요·가격을 임베디드 분석으로 제공한다. **Account Performance Insights**(수익 격차·이탈 위험·계정 건강도) · **Product Demand Insights**(계획 대비 실제 수요) · **Pricing Insights**(가격 탄력성·할인 범위·가격 민감도).

> **Who 공통:** `Sales Agreement PSL` · `Tableau Next` · **Data 360(일부 항목은 원문이 `Data Cloud`로 표기)** 권한 + **`Sales Agreement` preference 활성**. **How 공통:** Setup → 기어 메뉴에서 **Salesforce Go** → **Tableau Next Apps for Manufacturing** → **Get Started** → 기능 켜고 안내 따르기.

| 대시보드 | 내용 |
|---|---|
| **Keep Manufacturing Orders on Track from Booking to Fulfillment**<br>`rn_mfg_tableau_order_status` | **Account Insights Order Status 대시보드** — 계정에 묶인 모든 주문을 라이프사이클 전반에서 모니터링. **위험·정체 주문 식별**과 우선순위 파악. *(Who에 `Data Cloud` 표기)* |
| **Assess Manufacturing Account Health and Retention Risk**<br>`rn_mfg_tableau_account_health` | 계획된 비즈니스 개관, 후속 조치가 필요한 계정 식별, **고성과 계정과 이탈 위험 계정 분리**. **관계 기간(relationship length)과 고객 생애 가치(CLV)** 로 유지·성장 우선순위 결정. *(Who에 `Data Cloud` 표기)* |
| **Compare Planned vs. Actual Product Demand Across Manufacturing Accounts**<br>`rn_mfg_tableau_product_performance` | 최다 판매 제품 식별, 계정별 상승·하락 추세, 특정 제품 매출에 가장 기여하는 계정 파악. **계획 대비 실제 수요를 비교해 demand realization 측정**하고 미달의 원인 계정을 드러낸다 |
| **Align Demand Plans with Product Demand Insights**<br>`rn_mfg_tableau_product_demand` | **계획·예측 주문량이 가장 큰 제품과 계정**을 보여 재고 배분과 조달을 선제적으로 우선순위화 |
| **Benchmark Manufacturing Pricing and Elasticity Across Accounts**<br>`rn_mfg_tableau_pricing_insights` | 한 계정의 제품 가격을 **전체 계정과 비교**하고 계정 전반의 **가격 탄력성(price elasticity)** 검토. 협상 전에 할인 여지와 가격 변화가 수요에 미치는 영향 파악 |

#### New and Changed Objects for Manufacturing (`rn_mfg_new_changed_objects`) — 신규 11건 전수

| 오브젝트 | 용도 |
|---|---|
| `Trade Mobile Pricing Calculation Schema` | 가격을 결정하는 **계산 단계의 순서** 정의 |
| `Trade Mobile Pricing Calculation Schema Step` | 계산 스키마 안의 **개별 단계**(할인·surcharge·소계 계산 등) |
| `Trade Mobile Pricing Calc Schema Determination` | **sales org · account price type · order pricing type** 기준으로 주문에 적용할 계산 스키마 결정 |
| `Trade Mobile Pricing Specification` | 계산 단계에 쓰이는 **가격 사양**(price · discount · flat rate · free good 등) |
| `Trade Mobile Pricing Search Strategy` | 적용 가능한 **가격 조건 검색 전략** 정의 |
| `Trade Mobile Pricing Search Strategy Step` | 검색 전략 안의 **개별 단계**(account hierarchy 검색·product hierarchy 검색 등) |
| `Trade Mobile Pricing Key Type` | 복잡한 가격 조건 검색에 쓰이는 **key type** |
| `Trade Mobile Pricing Key Attribute` | 복잡한 가격 조건을 결정하는 **개별 key attribute** |
| `External Pricing Key Value` | **외부 가격 소스에서 동기화된 가격 데이터** — **account · product · date range** 를 키로 저장 |
| `External Pricing Key Value Tier` | graduated pricing key value의 **scale·tier 임계값**(볼륨 기반 할인 등) |
| `External Pricing Key Value Consolidated View` | 계정·제품에 대해 계산된 **가격 조건의 통합 집합** 조회 |

#### New Connect REST APIs in Manufacturing (`rn_manufacturing_new_and_changed_connect_apis`) — 원문 전수

**① Flatten Account Internal Organization Unit Hierarchy API** — `POST /connect/industries/retail/flatten-account-iou-hierarchy`

다층 계정 계층 트리를 **평면 레코드**로 바꾼다. 리포트를 돌릴 때마다 부모-자식 링크를 추가할 필요 없이 **각 계정의 전체 lineage를 미리 계산해 한 행에 저장**하므로, 리포트·대시보드가 **단일 인덱스 조회로 어떤 계층 수준이든 필터**할 수 있다.

- ⚠️ **Where:** *"This change applies to **Manufacturing Cloud** in Enterprise, Performance, and Unlimited editions."* (제품명이 Agentforce Manufacturing이 아니라 **Manufacturing Cloud**로 적혀 있다)
- **저장 구조:** 각 계정의 조상 체인을 **최대 15단계**까지 컬럼 **`AccountLevel01` ~ `AccountLevel15`** 에 저장하고, **역할 플래그 2개 — `IsStoreRole` · `IsPromotionRole`** 를 함께 둔다(계정이 리테일 매장인지, 프로모션 참가자인지).
- ⚠️ **호출 규약과 한도:** **internal organization unit ID 1개 + 최대 2,000개의 account ID 목록**으로 호출한다. API는 해당 IOU 안의 각 계정에 대해 조상 체인을 계산하고 기존 평면 레코드와 비교해 **변경된 것만 upsert** 한다. **지정한 business unit에 속하지 않는 계정은 failed record로 반환**된다. **신규 레코드는 insert, 수정된 레코드는 update 하지만 기존 행을 삭제하지는 않는다.**

**② `macz` 리소스 7종 (전부 POST)**

| 리소스 | 용도 |
|---|---|
| `/connect/macz/products/search` | 제품 카탈로그 검색 — **assortment로 선택 필터** |
| `/connect/macz/products` | 카탈로그 브라우즈 — **가격·카테고리 상세 포함**, assortment 선택 필터 |
| `/connect/macz/assortments` | 계정이 사용할 수 있는 **product assortment** 조회 |
| `/connect/macz/historical-product` | 고객이 이전에 주문한 제품 — **측정 단위별로 수량 집계** |
| `/connect/macz/order-delivery-date` | **lead-time 구성 기반의 유효 배송일 범위** 조회 |
| `/connect/macz/place-order` | **제품·가격·세금 선호를 한 요청에 함께 제출**해 주문 실행 |
| `/connect/macz/get-instant-price` | 주문 제품의 **즉시 가격** 조회 |

### Media (Agentforce Media) — 14건 전수 + 오브젝트

**Where 기본형 [MC-ADV]:** Lightning Experience · **Enterprise·Performance·Unlimited** + **Media Cloud — Advanced**. 아래 14건 중 **12건이 이 형태**이고 예외는 2건이다.

| 예외 항목 | 원문 Where |
|---|---|
| `rn_media_rfp_management` | Enterprise·Performance·Unlimited + **Media Cloud — Growth 또는 Media Cloud — Advanced**. ⚠️ **추가로 Agentforce 라이선스 필요** |
| `rn_media_targeting_data_360` | [MC-ADV] + ⚠️ **`Data 360 Provisioning` 또는 `Data 360 Starter`, 그리고 `Customer Data 360 for Marketing — Ad Audience`** 필요 |

#### 광고 판매 · 미디어 플랜

| 항목 | 내용 |
|---|---|
| **Boost Win Rates with Request for Proposal Management (Generally Available)** 🟢GA<br>`rn_media_rfp_management` | **RFP 전 라이프사이클을 Salesforce 안에 중앙화**해 파편화된 수동 워크플로를 대체. **이메일로 RFP를 직접 수신**하고 **최대 10 MB 문서 업로드**, 특정 필드 추출. **생성형 AI가 클라이언트 목표·예산·마감일을 편집 가능한 RFP 요약으로 자동 구조화**한다 |
| **Accelerate Inventory Booking with Bulk Line-Item Creation**<br>`rn_media_bulk_add` | **광고 인벤토리 캘린더에서 여러 제품 행을 선택해 한 번에** 미디어 플랜에 추가. 라인 아이템을 일괄 생성하며 **슬롯을 단일 라인 아이템으로 집계하거나 주별·월별로 분할**할 수 있다 |
| **Expedite Media Plan Delivery with Custom Quote Line Groups**<br>`rn_media_quote_line_grouping` | 복잡한 converged plan을 **media type · flight period · creative strategy** 로 조직화. 전용 인터페이스에서 **커스텀 그룹 컨테이너를 개수 제한 없이 생성·명명·설명·재정렬·삭제**한다 |
| **Increase Campaign Impact with Sponsored Products**<br>`rn_media_sponsored_products` | 광고주가 부각하려는 **리테일 제품을 미디어 플랜 라인 아이템에 직접 연결**. 수동 제품 입력의 오류를 없애고 **매장 내와 디지털 광고 시나리오 양쪽**에서 브랜드 제품↔광고 placement를 명확히 연결 |
| **Maximize Retail Impact with In-Store Media Campaigns**<br>`rn_media_in_store` | 물리적 리테일 환경 안에서 타깃팅 — **매장 위치 매핑**, **end cap 같은 광고 포맷 선택**, sponsored product로 물리 광고 공간↔재고 상품 연결. **foot traffic 또는 인구통계로 매장을 필터링**해 전략적 in-store 캠페인 구축 |
| **Drive Ad Revenue with Out-of-Home Campaigns**<br>`rn_media_out_of_home` | **OOH(out-of-home) 광고** 전용 캠페인. 미디어 플래너가 **billboard · transit shelter · street furniture** 같은 물리 인벤토리를 **POI(point of interest) 근접도로 Quote-to-Order 플로우 안에서 직접 검색**하고, **지도 뷰와 상호작용해 정확한 빌보드 상세·위치를 확인**한다. **실시간 capacity management와 product-level attribution 으로 이중 예약을 방지하고 브랜드 거버넌스를 강제.** ⚠️ **Salesforce Pricing의 옴니채널 번들 할인과 OOH 가격 모델을 결합해 디지털·물리 미디어 패키지를 하나의 통합 카트에서 가격 산정·판매**한다 |
| **Optimize Ad Targeting with Data 360 Audience Segments (Beta)** 🔵Beta<br>`rn_media_targeting_data_360` | **first-party Data 360 audience segment**를 미디어 플랜에 직접 적용. **주문 제출 시 Data 360 Segment ID를 다운스트림 ad server ID로 자동 매핑**해 수동 메타데이터 임포트와 중복 로컬 저장을 없앤다. **Where(추가 전제):** `Data 360 Provisioning` 또는 `Data 360 Starter` **+** `Customer Data 360 for Marketing — Ad Audience`.<br>⚠️ **Beta 고지 전수:** *"Ad targeting with Data 360 audience segments is a pilot or beta service that is subject to the Beta Services Terms at Agreements - Salesforce.com or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion."* |

#### 구독 라이프사이클 관리(SLM) — 프로모션·제품 관계

> 이 4건은 **Communications의 Revenue Cloud for Communications 프로모션 기능군과 같은 계열**이다(같은 Connect API 리소스를 공유한다 — 아래 API 표 참조). 다만 **Where가 Media Cloud — Advanced**로 다르다.

| 항목 | 내용 |
|---|---|
| **Drive Promotions with Coupon Codes**<br>`rn_media_slm_coupon_based_promotions` | 쿠폰 코드를 발행해 사용 시 할인 적용. **하나의 프로모션에 여러 코드**, **구매자별 또는 전체 기준 사용 한도**, 사용량 추적으로 캠페인 범위 통제 |
| **Expand Subscription Sales with Partial-Term Discounts**<br>`rn_media_slm_term_based_promotions` | 구독 제품의 **부분 기간 할인**. 담당자가 **benefit duration**을 정의하고 구독 라이프사이클 전반의 **시간 기반 조정 분해**를 조회. **commitment period** 로 재적용과 **non-stackable 할인 결합**을 방지 |
| **Protect Campaign Profitability with Promotion Groups**<br>`rn_media_slm_stackability_rules` | 같은 제품에 공존 가능한 프로모션과 **우선순위**를 통제. **group·subgroup** 으로 조직해 **스택되는지, 첫 적격 프로모션만 적용되는지** 결정 |
| **Model Product Dependencies Without Bundling**<br>`rn_media_slm_linear_relationships` | **`Relies On` 관계 타입**으로 제품·분류 간 종속을 모델링하되 **각 제품의 가격·기간·라이프사이클을 보존**. 규칙이 있는 제품을 견적·주문에 추가하면 적격 related 제품에 연결되고, **여러 개가 적격이면 담당자가 하나를 고른다**. 관계는 **quote → order → asset 으로 이어지고 amendment를 거쳐도 지속**된다 |

#### 설정

| 항목 | 내용 |
|---|---|
| **Discover Agentforce Media Features with Salesforce Go**<br>`rn_media_salesforce_go` | Salesforce Go 한곳에서 Agentforce Media 기능을 발견하고 **큐레이션된 콘텐츠 리소스·링크를 앱 안에서 직접** 확인 |

#### New Invocable Actions in Agentforce Media (`rn_media_new_invocable_actions`) — 신규 3종 전수

| 액션 | 용도 |
|---|---|
| `getDataCloudSegmentsForTgt` | 미디어 캠페인 오디언스 타깃팅용 **Data 360 세그먼트** 조회 |
| `generateEmailSummaryPdf` | 수신 이메일의 **PDF 요약을 생성해 RFP 레코드에 첨부** |
| `checkEligForAdSpaceCptyAlloc` | 미디어 플랜에 추가하기 전에 **선택한 ad space에 대해 라인 아이템 수량과 산업 적격성을 검증** |

#### New and Changed Connect APIs (`rn_media_new_and_changed_connect_apis`) — 원문 전수 9종

**Media 전용 4종**

| 리소스 | 메서드 · 바디 |
|---|---|
| `/connect/media/asm/action/media-plan/ad-space-locations` | **POST** — 요청 `Ad Space Location Input` / 응답 `Ad Space Location Representation` |
| `/connect/media/asm/action/media-plan/ad-space-location-details` | **POST** — 요청 `Ad Space Location Details Input` / 응답 `Ad Space Location Details Representation` |
| `/connect/media/gates` | **GET** (Media Gate Values) — 요청 `Media Gates Input` / 응답 `Media Gates Response` |
| `/connect/media/asm/lineitem/reorder` | **POST** (Reorder Line Items) — 요청 `Reorder Line Item Input` / 응답 `Reorder Line Item Response` |

**Communications와 공유하는 5종** — 리소스 경로가 `comms-sales`·`promotions` 네임스페이스다. **요청·응답 바디는 위 `### Communications` 절의 표와 동일**하므로 여기서는 목록만 둔다: `GET /connect/comms-sales/product-relationship-rule/{id}` · `CRUD /connect/comms-sales/product-relationship-rule/actions/manage` · `GET /connect/comms-sales/linear-relationships/{lineItemId}/candidates` · `POST /connect/comms-sales/linear-relationships/actions/manage-link` · `GET /connect/promotions/redeemed-coupons`(**필수 파라미터 `transactionId`**).

#### New and Changed Objects in Agentforce Media (`rn_media_objects`) — 신규/변경 전수 (원문 그대로)

*신규 오브젝트:* `RequestForProposal`(클라이언트가 서비스 제공자에게 제출하는 제안 요건) · `RqstForPrpsSumVersion`(복수 문서에 담긴 제안 요건 요약) · `RequestForProposalTeamMbr`(RFP를 관리해 opportunity·proposal을 생성하는 팀원) · `RequestForProposalOpp`(RFP에 대응해 생성된 opportunity) · `AdQuoteLineAdSpcSpecLoc`(광고 견적 라인에 연결된 ad space specification 위치) · `AdSpaceSpecLocation`(ad space specification에 연결된 위치) · `AdQuoteLinePrmtProduct`(라인 아이템에 연결된 광고 공간에서 프로모션되는 SKU) · `AdOrderItemAdSpcSpecLoc`(ad order item ↔ ad space spec location 연결) · `AdOrderItemPrmtProduct`(ad order line item의 일부로 프로모션되는 제품) · `ProductRelationshipRule`(제품 또는 제품 분류 간 관계 규칙)

*신규 필드:* `AdSpaceSpecLocationCount`(**Ad Quote Line** — 광고 견적 라인 아이템에 연결된 ad space spec location 레코드의 **고유 위치 총 수**) · `AdSpaceSpecLocationCount`(**Ad Order Item** — ad order item에 연결된 ad space spec location **레코드 총 수**) · `PlacementZone`(Ad Space Specification — 매장의 광범위한 물리 구역) · `PlacementType`(Ad Space Specification — placement zone 내 fixture·위치 유형) · `IsPhysicalSKURequired`(Ad Space Specification — 물리 SKU 필요 여부 true/false) · `ScreenType`(Ad Space Specification — 광고 표시 화면 유형) · `Illumination`(Ad Space Specification — 광고 표시 화면의 조명 유형) · `AudienceSize`(Ad Target Segment Value — 세그먼트 필터 조건에 부합하는 **고유 개인·엔터티 총 수**) · `DataCloudSegmentIdentifier`(Ad Target Segment Value — **Data 360의 세그먼트 식별자**) · `RelationshipAction`·`ProductRelationshipRule`(기존 `QuoteLineRelationship`) · `RelationshipAction`·`ProductRelationshipRule`(기존 `OrderItemRelationship`) · `ProductRelationshipRule`(기존 `AssetRelationship`) · `AdjCommitmentEndDateTime`·`AdjEffectiveStartDateTime`·`AdjEffectiveEndDateTime`·`AdjustmentAction`·`AppliedAdjustmentAmount`(기존 `CartItemPriceAdjustment`) · 동일 5개 필드(기존 `QuoteLinePriceAdjustment`) · `AdjCommitmentEndDateTime`·`AdjEffectiveStartDateTime`·`AdjEffectiveEndDateTime`·`AppliedAdjustmentAmount` **4개**(기존 `AssetActionSrcPriceAdjustment` — **`AdjustmentAction` 없음**) · 동일 5개 필드(기존 `OrderItemAdjustmentLineItem`)

> 위 필드 묶음에서 `AssetActionSrcPriceAdjustment`만 **`AdjustmentAction`이 빠진 4개 필드**다 — 원문이 다른 세 오브젝트와 다르게 열거한 지점이므로 그대로 구분해 적는다.

### Nonprofit · Net Zero — 랜딩 요약 (개별 리프 page id 없음)

> 이 두 산업은 **Winter '27 Clouds 페이지 목록(988건)에 개별 리프 page id가 등재되지 않았다.** 아래는 산업 랜딩·컨테이너 페이지가 본문에 담은 자식 요약이며, 다른 산업 절과 달리 **에디션·Setup 경로·권한·가용 시점이 원문에 없다.**

**Nonprofit (Agentforce Nonprofit)**

- **Simplify Program and Case Management Feature Setup** (`rn_npc_salesforce_go_configuration`) — Where·Who를 포함한 본문은 아래 `### Industries Common Features` 절의 **그 밖의 공통 항목** 표에 있다(특정 산업 전용 기능이 아니다).
- 공통 기능: **Fundraising**(가구 이름 수식 기반 자동 유지) · **Program and Case Management**(참가자가 프로그램·신청·등록·급여 배정/지급·추천을 **직원 문의 없이 자기 일정대로** 조회. 신규 **Program Participant Portal Experience Cloud 템플릿**이 사전 구성 페이지·내비게이션·컴포넌트 제공).

**Net Zero Cloud (Agentforce Net Zero)** — **Supplier Engagement** 공통 기능: 공급업체가 **데이터 제출·스코어카드 작성·지출/배출/리스크 추적**을 하는 셀프서비스 포털로 **Scope 3 목표 설정**을 지원.

### Public Sector (Agentforce Public Sector) — 46건 전수

> ⚠️ Public Sector는 Winter '27 릴리즈 노트에서 **Industries 하위가 아니라 최상위 랜딩 항목**(`rn_public_sector_solutions`)이다. 이 노트는 산업 성격상 `## Industries` 안에 둔다.

랜딩이 밝힌 축 전수: **Tax and Revenue Management · Benefit Management · Outbound Payments · License, Permit, and Inspection Management · Talent Recruitment Management · Workforce Scheduling** + 단독 항목(**Supply Chain Resiliency(Pilot)** · **External Storage Search** · **Salesforce Go**) + 개발자 표면 4종.

**Where 약칭**

| 약칭 | 원문 Where |
|---|---|
| **[APS]** | Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Agentforce Public Sector 활성** |
| **[APS-EU]** | Lightning Experience · **Enterprise·Unlimited** + Agentforce Public Sector 활성 |
| **[APS-WS]** | Lightning Experience · **Enterprise·Unlimited** + Agentforce Public Sector 활성 + ⚠️ **Workforce Scheduling 애드온 라이선스 필수** (원문: 자세한 내용은 **Salesforce account executive에 문의**) |
| **[APS-D360]** | **Enterprise·Unlimited·Developer** + **Agentforce Public Sector · Data 360 · Experience Cloud** (원문에 *Lightning Experience* 문구가 없다) |

#### Tax and Revenue Management (`rn_ps_tax_rev_container` 허브 + 리프 3) — 전부 [APS-D360]

| 항목 | 내용 |
|---|---|
| **Build a Unified Taxpayer 360 Profile**<br>`rn_264_ps_tax_dmo` | **Taxpayer 360 Data Model** 신설 — **신원·가구 상세 · 소득 요약 · 신고 상태 · 납부 이력**을 포괄해 세무 담당자가 시스템을 오가지 않고 완전한 프로필을 본다. ⚠️ **기존 시스템을 source of record로 유지한 채 Data 360으로 연결**한다. **How:** **Data Space 구성** 후 Data 360의 **Data Stream** 으로 데이터 연결 |
| **Provide Constituents a Self-Service Tax Portal**<br>`rn_264_ps_tax_portal` | 개인 납세자가 **신고 상태 · 환급 상세 · 소득원**을 조회하는 보안 포털. **Taxpayer 360 Data Model 위에 구축**된다. **How:** Data Space 구성 → **Data Governance Policies 설정** → Data 360으로 세무 레코드 연결 → **Identity Resolution 구성** → **Tax & Revenue LWR Experience Template 배포** |
| **Deflect Taxpayer Inquiries Automatically with Agentforce**<br>`rn_264_ps_taxpayer_agentforce` | **Taxpayer Advocate 에이전트** 가 **환급 상태 · 세액 잔액 분해 · 신고 상태** 문의를 처리. 납세자 웹 포털에 직접 임베드하며 **Taxpayer 360 데이터에 grounding된 실시간 개인화 답변**을 준다. **에이전트 범위를 넘어서면 전체 대화 맥락과 함께 사람 담당자에게 자동 이관**된다. **Agentforce Voice가 챗 에이전트와 동일한 구성을 전화 채널로 확장**한다. ⚠️ **원문 제약: *"Agentforce Voice is currently not available in Government Cloud."*** **How:** Agentforce Builder에서 챗 에이전트를 구성하고 사람 담당자 이관 경로 설정 |

#### Benefit Management (`rn_ps_benefit_mgmt_container` 허브 + 리프 5) — 전부 [APS]

| 항목 | 내용 |
|---|---|
| **Apply for Multiple Benefits in a Single Application**<br>`rn_aps_benefit_mgmt_apply_multiple_benefits` | 여러 정부 급여 프로그램을 **하나의 통합 신청서**로 신청. 입력 정보를 적격성 규칙과 대조하고 기존 저장 정보를 prefill한다. **Who:** **Company Community 사용자(Salesforce Platform)는 `Customer Community Plus` 라이선스가 필요**하고 **`Authorized Representative Company Community Access for Public Sector` 권한 세트**를 배정한다. **Why(원문 상세):** 예시 프로그램은 **LIHEAP(Low Income Home Energy Assistance Program)** 와 **SNAP(Supplemental Nutrition Assistance Program)** 이며, 신청서는 **사전 구성 샘플 적격성 규칙을 병렬 처리로 평가**한다. ⚠️ **Form Framework 위에 만들어져 신청 도중 조건부 적격성을 평가**한다 — **소득이 특정 프로그램 자격에 미달하면 관련 없는 필드를 숨기고 폼 단계를 자동으로 재배열**해 자격이 되는 프로그램의 폼만 작성하게 한다. **How:** 사전 구축 또는 커스텀 템플릿으로 **expression set**을 만들어 프로그램에 연결 → 신청자 정보를 신청 레코드에 자동 저장하는 **기본 data flow 설정** → 대리인 신청을 허용하려면 representative access를 구성하고 가이드형 신청 플로우를 Experience Cloud 사이트에 배포 |
| **Evaluate Eligibility Across Benefit Programs Simultaneously**<br>`rn_aps_benefit_mgmt_evaluate_eligibility` | 신청 접수 중 **가구·소득·자산·지출 상세를 병렬 평가**해 자격이 되는 모든 프로그램을 한 번에 보여준다. ⚠️ **Who: 대리 신청하는 authorized representative는 `Public Sector Authorized Representative` · `Authorized Representative Community` · `Authorized Representative Company Community` 권한 세트 라이선스(PSL)가 필요하다.** **How:** 통합 신청서는 **`IntegratedEligibility` Connect API** 로 데이터를 병렬 평가한다 |
| **Accelerate Benefit Application Intake with Automatic AI-based Data Prefilling**<br>`rn_aps_benefit_mgmt_prefill_application_data` | 알려진 정보와 예비 신청 상세를 급여 양식에 자동 적재. **주민이 공식 문서를 양식에 직접 업로드**하면 Agentforce Public Sector가 **여러 파일에서 핵심 인구통계 상세를 추출·검증해 필드를 채운다**. **How:** 급여 신청 **Omniscript 플로우의 기본 Integration Procedure를 구성**해 저장된 신청자 레코드 필드를 폼 요소에 매핑 |
| **Capture Program-Specific Details During Benefit Applications**<br>`rn_aps_benefit_mgmt_capture_program_details` | 가이드형 신청 플로우 중 **프로그램 특화 정보**를 수집 — 표준 접수 양식이 담지 못하는 항목을 **동적 Omniscript 컴포넌트**가 정확히 수집한다. **Why(원문 예시): SNAP은 가구 내 누가 함께 식사를 준비하는지를 알아야 한다.** **How:** 관리자는 **사전 구축 Data Mapper · FlexCard · Integration Procedure**로 추가 응답을 자동 요청·저장 |
| **Capture Authorized Representatives Information**<br>`rn_psc_capture_authorized_representatives_information` | 주민이 **caseworker · 가족 · advocate** 를 대리인으로 지정해 급여·라이선스 신청을 대행하게 한다. ⚠️ **원문 핵심: 대리인은 주민을 사칭(impersonate)하지 않고 신청하며, 주민은 누가 자신을 대리하는지·무엇에 동의했는지 보고 언제든 철회할 수 있다 — 비밀번호를 공유할 필요가 전혀 없다.** **Who — 페르소나 3종별 전제:** ① **내부 관리자·담당자**: `Authorized Representative Access for Public Sector` 권한 세트 ② **Experience Cloud 커뮤니티 사용자**: **`Customer Community Plus` 라이선스 필요** + `Authorized Representative Community Access for Public Sector` ③ **Company Community 사용자(Salesforce Platform)**: **`Customer Community Plus` 라이선스 필요** + `Authorized Representative Company Community Access for Public Sector` |

#### Outbound Payments (`rn_ps_outbound_payments_container` 허브 + 리프 3) — 전부 [APS-EU]

| 항목 | 내용 |
|---|---|
| **Customize Claims Submission Forms and AI-Based Invoice Extraction**<br>`rn_264_ps_customize_claims` | Experience Cloud의 **Claims 제출 양식을 기관 워크플로에 맞게** 조정 — 커스텀 필드 추가, 제공자 접수 단순화, **Unstructured Document Processing으로 인보이스 데이터 추출 자동화**. 제공자가 인보이스를 업로드하면 **line item · 금액 · 날짜 · 기관 특화 식별자** 같은 구조화 청구 데이터가 추출된다. ⚠️ **How: 추출할 필드는 Setup에서 JSON 스키마를 구성해 직접 통제한다** |
| **Catalog Services and Pricing with Product Catalog Management**<br>`rn_264_ps_catalog_services` | **Salesforce Product Catalog Management**로 공공부문의 서비스 오퍼링·요율·제공자 네트워크 관리. 원문이 나열한 가능 항목 4가지: ① **서비스를 한 번 정의해 여러 프로그램에 재사용** ② **표준 fee schedule과 제공자별 협상 요율을 같은 시스템에서 추적** ③ **서비스↔제공자 연결로 어떤 제공자가 어떤 서비스를 제공할 수 있는지 통제**(컴플라이언스를 위한 **effective dating과 exclusion flag** 포함) ④ **서비스↔급여 프로그램 매핑**으로 담당자와 청구 판정자가 승인된 급여를 실제 제공 서비스와 대조 |
| **Authorize and Track Service Delivery Access Across Benefit and Non-Benefit Programs**<br>`rn_264_authorize_track_services` | **Service Authorization과 Service Delivery** 로 급여 외 운영 서비스(**법정 통역사 · 전문가 증인 · 조사 컨설턴트**)와 서비스형 급여(**간병 지원 · 영양 지원**)의 제공을 승인·추적. 제공자가 할 수 있는 것 전수: **비금전적 서비스에 대한 service authorization 발행 · 급여 지급 레코드를 중복 생성하지 않고 비금전 급여 서비스 제공 추적 · service delivery 레코드를 다운스트림 claim adjudication에 연결해 승인자가 인보이스를 실제 제공 서비스와 대조 · Experience Cloud 포털을 통해 제공자에게 미청구 승인 서비스 단위 가시성 제공**(원문 오타 *"Experience Coud"* 그대로) |

#### License, Permit, and Inspection Management (`rn_ps_lpi_mgmt_container` 허브 + 리프 4) — 전부 [APS]

| 항목 | 내용 |
|---|---|
| **Guide License and Permit Applicants with Agentic Application Intake**<br>`rn_psc_guide_license_permit_applicants_agentic_intake` | **에이전트 지원 사이드 패널**이 있는 가이드형 접수가 경직된 폼 전용 플로우를 대체한다. 에이전트가 신청 절차에 대한 맥락 질문에 답하고 자연어로 폼 작성을 돕는다. **여러 라이선스를 하나의 신청으로 통합**하고, **업로드 문서에서 필드를 자동 채우며**, **진행 상황을 잃지 않고 일시 중지·재개**할 수 있다. ⚠️ **Where: [APS] + Agentforce와 Data 360 라이선스 필요.** **Who:** 검토자는 다른 Public Sector 신청에서 쓰던 워크플로를 그대로 쓴다. **구성 관리자 권한 세트 전수:** `Agentforce Default Admin` · `Access Agentforce Default Agent` · `Public Sector Access` · `Document Checklist` · `Dynamic Assessment Access` · `Unstructured Document Processing`. **커뮤니티 사용자 권한 세트 전수:** `Agentforce for Public Sector for Community` · `Industries Assessment` · `Document Checklist` · `Prompt Template User` · `Data Cloud User` |
| **Collect Fees for Public Sector Services with Inbound Payments (Generally Available)** 🟢GA<br>`rn_psc_collect_fees_inbound_payments` | 주민이 라이선스·허가 신청 같은 서비스 비용을 **공개 포털에서 직접 결제**. 기관 직원은 결제 상태를 실시간으로 확인해 수동 대사(reconciliation)를 줄이고 **승인 전에 컴플라이언스를 보장**한다. ⚠️ **Who — 페르소나 3종별 PSL·권한 세트 전수:** ① **비즈니스 관리자**: PSL **`Billing Advanced` · `Billing` · `Public Sector Payments Integration`** + 권한 세트 **`Payment Admin` · `Billing Admin` · `Inbound Payment for Public Sector Access`** ② **기관 직원**: 동일 PSL 3종 + 권한 세트 **`Payment Operations User` · `Billing Operations User` · `Inbound Payment for Public Sector Access`** ③ **주민(Experience Cloud)**: 권한 세트 **`Inbound Payment for Public Sector Access Experience Cloud Users`** |
| **Add Ad Hoc Tasks During Visits**<br>`rn_psc_add_ad_hoc_tasks_during_visits` | 점검관이 **사전 배정되지 않은 태스크를 방문 중에 생성**한다(추가 안전 점검·후속 검증 등). **현장에 다시 방문하거나 Salesforce 밖에서 수동 추적할 필요가 없다.** **How:** Visit 상세 페이지 → **Menu → Add a Task** → action plan 템플릿 선택 → 추가할 태스크 선택 → 저장 |
| **Search for Locations and Addresses by Name**<br>`rn_aps_location_address_picker` | 자동 생성 ID를 뒤지는 대신 **이름으로 위치·주소 레코드 선택**. 신규 **Location Address Picker** 컴포넌트가 플로우·Omniscript 안에서 주소를 찾아주고 **선택 시 지도 표시**. **How:** screen flow에 컴포넌트를 추가하거나 Omniscript에는 **커스텀 LWC `runtime_gov_aps__locationAddressPickerOmni`** 를 추가. **컴포넌트 출력은 Location ID · Address ID · 서식화된 표시 문자열** |

#### Talent Recruitment Management (`rn_ps_trm_container` 허브 + 리프 4)

| 항목 | 내용 |
|---|---|
| **Answer Candidate Questions Instantly with Agentic Self-Service for TRM**<br>`rn_psc_answer_candidate_employee_questions_agentic_self_service_trm` | Applicant Portal의 구직자가 **knowledge article과 정책 매뉴얼에서 뽑은 AI 요약 답변**을 즉시 받는다. **Concierge 챗 패널이 페이지를 가로질러 따라다니며** 텍스트를 하이라이트해 맥락 질문을 하거나, **동적 추천으로 채용 FAQ용 Agentforce service agent를 열거나**, **대화에 따라 포털이 스스로 이동·새로고침**하게 할 수 있다. ⚠️ 원문 명시: **기존 Talent Recruitment Management 설정 경로로 구성하며 별도 설정이 필요 없다.** **Where: [APS]** |
| **Collect Consent from Applicants**<br>`rn_aps_recruitment_set_up_consent` | **커리어 사이트에서 직접 지원자 동의 수집** — 프로필 생성 또는 지원 제출 시 동의를 제공한다. ⚠️ **이전엔 지원 과정에서 커뮤니케이션 선호를 캡처·저장하는 내장 수단이 없었다.** **Where: [APS] + Talent Recruitment Management 활성.** **Who: `Talent Recruitment Management Specialist Access` 권한 세트** |
| **Run Targeted Recruitment Campaigns**<br>`rn_aps_recruitment_campaigns` | **스킬과 과거 지원 이력으로 talent pool을 세분화**해 개인화된 기회로 재참여를 유도. ⚠️ **캠페인은 커뮤니케이션에 동의한 후보에게만 발송된다.** **Where: [APS] + Talent Recruitment Management **및 Marketing Cloud** 활성.** **Who:** `Talent Recruitment Management Specialist Access`. **How:** 기어 메뉴 또는 Setup → **Salesforce Go** → **Recruitment Campaigns** 검색 |
| **Automate Recruitment, Education, and Interaction Workflows with Action Plans**<br>`rn_psc_automate_workflows_action_plans` | Action Plans가 **오브젝트 6종에 신규 지원: `Position` · `Job Position` · `Recruitment Requisitions` · `ContactContactRelation` · `PersonEducation` · `Interaction`.** **Where: [APS].** **Who: `Action Plans` 권한 세트.** **How:** App Launcher → **Action Plan Templates** → 템플릿 생성(우선순위·기한이 있는 태스크 추가, 담당자 배정, **대상 오브젝트를 위 6종 중에서 선택**) → 저장. **레코드가 생성되거나 특정 단계에 도달하면 사전 정의 태스크가 자동 생성**된다 |

#### Workforce Scheduling (`rn_aps_workforce_scheduling_container` 허브 + 하위 컨테이너 4 + 리프 8) — 전부 [APS-WS]

허브 구조: **Set Up Workforce Scheduling** + 하위 컨테이너 4개(**Unified Scheduling** `rn_aps_workforce_scheduling_unified_scheduling` · **Field Scheduling** `rn_aps_workforce_scheduling_field_scheduling` · **Shift Scheduling** `rn_aps_workforce_scheduling_shift_scheduling` · **Field App** `rn_aps_workforce_scheduling_field_app`).

| 항목 | 내용 |
|---|---|
| **Set Up Workforce Scheduling for Your Entire Workforce**<br>`rn_aps_workforce_scheduling_setup` | **How:** Salesforce Go에서 **Workforce Scheduling** 선택 → 사용자 접근 배정 + **work type과 service territory 생성** → Setup → Quick Find **`Workforce Scheduling`** → **Basic Settings** → **Onsite Scheduling과 Field Scheduling 켜기** → Setup에서 scheduling policy·optimization·routing 구성. **정직원 · named contractor · partner worker** 를 스케줄링 결정에 포함할 수 있다 |
| **Manage Onsite and Field Work**<br>`rn_aps_workforce_scheduling_manage_field_work` | 온사이트·현장 업무를 **하나의 스케줄링 솔루션**으로. **Why(원문 유스케이스 전수):** 주민이 caseworker·intake officer와 예약(**가족 전체에 대한 단일 예약 포함**) · **점검·조사·case history 수집을 위한 가정 방문 일정**(**필요 시 여러 명 또는 점검관 팀이 함께 방문**) · **저연결 환경에서 관찰을 기록하고 케이스 데이터에 접근하는 오프라인 모바일 앱** · **모든 주민 상호작용의 추적·감사**. **How:** Setup → Quick Find `Workforce Scheduling` → Basic Settings → On-Site Scheduling·Field Scheduling 켜기 |
| **Schedule Onsite Interactions with Agency Employees**<br>`rn_aps_workforce_scheduling_onsite_interactions` | 케이스·민원 같은 맥락에서 주민↔기관 직원의 **사무실 내 예약**. ⚠️ **온사이트 상호작용은 `Interaction` 오브젝트를 사용**하므로 서드파티 없이 공공부문 워크플로 안에서 동작한다. 주민이 **Experience Cloud 사이트에서 직접 예약**할 수 있고 직원은 **Manager View 컴포넌트**로 검토. **Where: [APS-WS] + 지원되는 Experience Cloud 사이트** |
| **Manage Your Workforce in the Workforce Scheduling Operations Console**<br>`rn_aps_workforce_scheduling_operations_console` | **Gantt · list · map 뷰**를 갖춘 단일 콘솔. 리소스 가용성·이동 시간 검토, **드래그앤드롭 일정 편성**, **scheduling-policy 위반 식별**, 예약 스케줄링·리소스 최적화·자동 배정·현장 업무 적임자 탐색. **How:** App Launcher → **Workforce Scheduling Operations Console** → territory와 기간 선택 |
| **Simplify Appointment Scheduling with Unified Scheduling Flows**<br>`rn_aps_workforce_scheduling_unified_scheduling_flows` | 가이드형 플로우로 visit · interaction · service appointment 를 **예약·재예약·취소**. ⚠️ **게스트는 이메일로 신원을 검증해 계정을 만들지 않고도 예약을 관리**할 수 있고, **참석자는 초대 링크로 그룹 예약에 참여**한다. **Where: [APS-WS] + 지원되는 Experience Cloud 사이트.** **How:** 지원되는 레코드 페이지·액션·Experience Cloud 사이트에 Workforce Scheduling 플로우와 예약 컴포넌트를 추가. **Flow Builder에서 표준 플로우를 복제해 필드·기본값·화면을 커스터마이즈** |
| **Automate Appointment Management with the Workforce Scheduling Agent**<br>`rn_aps_workforce_scheduling_agent` | 에이전트가 **예약·재예약·취소와 예약 정보 제공**을 수행. ⚠️ **When: Workforce Scheduling 에이전트는 Winter '27부터 순차(rolling basis) 제공된다.** **How:** App Launcher → Agentforce Studio → **Agents → New Agent → Workforce Scheduling 에이전트 템플릿** |
| **Schedule and Optimize Field Work with Workforce Scheduling**<br>`rn_aps_workforce_scheduling_schedule_optimize_field_work` | **scheduling policy에 정의된 스킬·가용성·이동 시간** 기준으로 현장 배치. **경로 계획 + 최적화 3종 — resource schedule optimization · in-day optimization · global optimization.** **개발자는 unified scheduling API로 커스텀 앱에 스케줄링·최적화를 추가**할 수 있다. **Why(유스케이스 전수):** 건축 허가·라이선스 컴플라이언스 점검 관리 · 상업 시설의 환경·식품 안전 감사 · 재가 치료와 건강 평가 일정 |
| **Plan Workforce Coverage with Shift Management**<br>`rn_aps_workforce_scheduling_shift_management` | **shift template과 반복 패턴**으로 근무조 생성·관리, **휴일과 연장 근무 반영**, 근무자에게 데스크톱 근무조 뷰 제공. ⚠️ **How — 권한이 두 갈래:** 관리자에게 **`Workforce Management Schedule Manager`** 권한 세트를 배정하면 App Launcher의 **Schedule Manager → Shifts 탭**에서 근무조를 만든다. 근무자에게는 **`Workforce Management Worker`** 권한 세트를 배정하고 **각 User 프로필마다 연관 `Service Resource` 레코드를 생성**해야 하며, 근무자는 App Launcher의 **Schedule** 에서 자기 근무조를 본다 |
| **Complete Field Work Offline in the Salesforce Field Service Mobile App**<br>`rn_aps_workforce_scheduling_mobile_offline` | 모바일 근무자가 **visit · interaction · service appointment 를 하나의 일정 목록**에서 검토하고 **네트워크 없이 계속 작업**한다. **오프라인 접근 대상 공공부문 레코드 전수: regulatory code · violation · public complaint · business license.** 가이드형 워크플로 · 데이터 캡처 폼 · push 알림 지원, **Agentforce pre-work brief** 로 방문 준비. ⚠️ **Where: Salesforce Field Service 모바일 앱 **for iOS** · Enterprise·Unlimited + Agentforce Public Sector용 Workforce Scheduling 애드온 라이선스. pre-work brief에는 Agentforce 접근이 필요하다.** **How:** 모바일 접근·레이아웃 구성, **Briefcase로 오프라인 데이터**, **Discovery Framework로 데이터 캡처 폼**, 가이드형 워크플로·알림·pre-work brief 구성 |

#### 단독 항목

| 항목 | 내용 |
|---|---|
| **Discover Amazon S3 File Content Semantically with Agentforce**<br>`rn_aps_external_storage_search` | 조사관·컴플라이언스 담당자가 **Amazon S3의 페타바이트급 파일**에서 Agentforce 에이전트와 대화하거나 레코드 페이지의 **External Storage Semantic Search 컴포넌트**로 정보를 찾는다. **의미 검색은 AWS 서비스(Amazon Bedrock · Amazon Kendra)로 키워드가 아닌 의도를 이해**한다. ⚠️ **원문 예시 그대로:** *"suspect fled the scene"* 로 검색하면 **"absconded" 를 언급한 파일**이나 **누군가 "ran away" 라고 말하는 영상**까지 찾는다 — **문서의 텍스트, 영상의 음성, 이미지 안의 텍스트**를 가로질러. **Where: [APS].** **How:** 기어 메뉴 또는 Setup → **Salesforce Go** → **Agentforce for Public Sector** 검색 → **External Storage Search Skills** 단계 완료 |
| **Accelerate Setup with Salesforce Go**<br>`rn_aps_salesforce_go_setup` | Salesforce Go가 Agentforce Public Sector 지원을 확대해 **핵심 기능의 단일 설정 위치**를 제공한다. Salesforce Go에서 발견 가능한 신규 역량 3종: **External Storage Search · Licensing and Permitting · Recruitment Campaigns.** **Where: [APS]** |
| **Track Supplier Risk Across Your Multi-Tier Supply Chain (Pilot)** 🟠Pilot<br>`rn_supply_chain_resiliency_pilot` | Public Sector 랜딩이 자기 축으로 나열하지만 **Industries 공통 기능 계열**이라 본문은 아래 `### Industries Common Features` 절에 있다 |

#### 개발자 표면 (4건)

| 항목 | 내용 |
|---|---|
| **New and Changed Connect REST APIs in Agentforce Public Sector**<br>`rn_aps_new_changed_connect_api` | 신규 리소스 **8종 전수** (아래) |
| **New Connect in Apex Class in Benefit Management**<br>`rn_aps_benefit_mgmt_connect_in_apex` | **신규 `ConnectApi.IntegratedEligibilityConnect` 클래스**의 메서드 3종 (아래) |
| **New Connect REST API and Apex Methods in Tax and Revenue Management**<br>`rn_aps_tax_rev_apis` | REST 2종 + **`ConnectApi.MissionforceTaxRevenueApi`** 메서드 2종 (아래) |
| **Public Sector Namespace**<br>`rn_aps_benefit_mgmt_public_sector_namespace` | **`PublicSectrSltn` 네임스페이스** 신규 클래스 2종 (아래) |

**신규 Connect REST API 8종 (`rn_aps_new_changed_connect_api`) — 원문 전수**

| 영역 | 리소스 · 설명 |
|---|---|
| Benefit Management | **`POST /connect/integrated-application/application-data`** — **Context Definition 기반 영속화 전략**으로 급여 신청 데이터 레코드를 생성·갱신·조회. 요청 `Integrated Application Data Input` / 응답 `Integrated Application Data Output` |
| Benefit Management | **`POST /connect/integrated-application/eligible-benefits`** — 신청자가 받을 수 있는 급여와 **각각의 적격성 평가 결과**를 반환. 요청 `Integrated Application Benefits Input` / 응답 `Integrated Application Benefits Output` |
| Benefit Management | **`POST /connect/integrated-application/benefit-amount-calculations`** — **expression set이 계산한 급여 금액** 반환. 요청 `Integrated Application Benefit Amounts Input` / 응답 `Integrated Application Benefit Amounts Output` |
| External Storage (S3) | **`GET /connect/contenthub-externalsearch/status`** — ⚠️ **Search External Storage API를 호출하기 전에 이 리소스를 먼저 호출해 사용자에게 검색을 노출할지 판단한다.** **요청 바디 없음** / 응답 `External Storage Search Status Output` |
| External Storage (S3) | **`POST /connect/contenthub-externalsearch/search`** — **Lambda 미들웨어를 통해** Amazon Bedrock·Kendra 같은 외부 스토리지 제공자의 콘텐츠를 검색하고 **관련도 순으로 정렬된 문서**를 반환. **각 결과에는 Salesforce `ContentVersion` 레코드에 매핑되는 S3 URI가 포함**돼 매치를 Salesforce 콘텐츠로 되짚을 수 있다. **`maxResults` 와 search handle 로 대용량 결과 페이징.** 요청 `External Storage Search Input` / 응답 `External Storage Search Output` |
| Outbound Payments | **`POST /connect/outbound-payments/claims`** — **여러 claim과 그 claim item·문서를 한 요청으로 일괄 생성**. 요청 `Claim Collection Input` / 응답 `Claim Collection Output` |
| Outbound Payments | **`POST /connect/outbound-payments/claims/action/submit-claims`** — **claim의 증빙 문서에서 추출한 데이터로 payment request와 payment request line을 생성**하고 claim 상태를 진행. 요청 `Submit Claims Requests Input` / 응답 **`Submit Claims Requests Ouput`**(원문 오타 그대로) |
| Unstructured Document Processing | **`POST /connect/intelligent-application-processing/extract`** — 지정 **IDP 구성**을 통해 Unstructured Document Processing으로 파일에서 데이터를 추출하고 **Document Checklist Item(DCI) 레코드를 생성**한다. **반환값: 추출 상태, (성공 시) JSON 형식의 추출 데이터, (해당 시) 생성된 DCI 레코드 ID.** 요청 `Intelligent Application Processing Extract Input` / 응답 `Intelligent Application Processing Extract Output` |

**`ConnectApi.IntegratedEligibilityConnect` 신규 메서드 3종**

| 메서드 | 입력 클래스 | 출력 클래스 |
|---|---|---|
| `manageApplicationData(integratedEligibilityApplicationDataInputRepresentation)` | `ConnectApi.IntegratedEligibilityApplicationDataInputRepresentation` | `ConnectApi.IntegratedEligibilityApplicationDataOutputRepresentation` |
| `evaluateBenefits(integratedEligibilityBenefitsInputRepresentation)` | `ConnectApi.IntegratedEligibilityBenefitsInputRepresentation` | `ConnectApi.IntegratedEligibilityBenefitsOutputRepresentation` |
| `calculateBenefitAmounts(integratedEligibilityBenefitAmountsInputRepresentation)` | `ConnectApi.IntegratedEligibilityBenefitAmountsInputRepresentation` | `ConnectApi.IntegratedEligibilityBenefitAmountsOutputRepresentation` |

**Tax and Revenue Management API (`rn_aps_tax_rev_apis`)**

| 종류 | 표면 |
|---|---|
| REST | **`POST /services/data/v68.0/connect/public-sector/tax-revenue/constituents/${constituentId}/activity`** — 단일 **tax year**의 납세자 활동을 **요청한 뷰로 스코프**(**filings · documents · payments · refunds · assessments**). 요청 `Tax Constituent Activity Input` / 응답 `Tax Constituent Activity` |
| REST | **`POST /services/data/v68.0/connect/public-sector/tax-revenue/constituents/${constituentId}/profile`** — **표시명과 신고 기록이 있는 tax year 목록**을 포함한 납세자 프로필. 요청 `Tax Revenue Profile Input` / 응답 `Tax Revenue Profile` |
| Apex (`ConnectApi.MissionforceTaxRevenueApi`) | `getTaxConstituentActivity(constituentId, taxConstituentActivityInput)` — 입력 `ConnectApi.TaxConstituentActivityInput` / 출력 `ConnectApi.TaxConstituentActivity` |
| Apex (`ConnectApi.MissionforceTaxRevenueApi`) | `getTaxRevenueProfile(constituentId, taxRevenueProfileInput)` — 입력 `ConnectApi.TaxRevenueProfileInput` / 출력 `ConnectApi.TaxRevenueProfile` |

**`PublicSectrSltn` 네임스페이스 신규 클래스 2종 (`rn_aps_benefit_mgmt_public_sector_namespace`)**

| 클래스 | 내용 |
|---|---|
| `ManageApplicationDataService` | `manageApplicationData` 메서드로 주민이 급여 신청에 입력한 데이터를 **저장·갱신·삭제**. **통합 신청서를 뒷받침하며 `ConnectApi.IntegratedEligibilityConnect.manageApplicationData` 를 미러링**한다 |
| `BenefitsEligibilityService` | Apex에서 급여 적격성 평가와 급여 금액 계산. ⚠️ **`Callable` 인터페이스를 구현**하며 **`ConnectApi.IntegratedEligibilityConnect.evaluateBenefits` 와 `.calculateBenefitAmounts` 를 래핑**한다 |

#### New and Changed Objects in Agentforce Public Sector (`rn_psc_new_changed_objects`) — 원문 전수

**Benefit Management**

| 대상 | 내용 |
|---|---|
| 신규 `BusinessLicenseCodeSet` | code set ↔ business license 연결 |
| 신규 `BnftAsgntBnftItemCode` | 수급자에게 배정된 **benefit item** 표시 |
| `BenefitAssignment` 신규 필드 6 | `AssignmentDate`(급여가 등록자에게 배정된 날짜) · `TerminationReason` · `TerminationNotificationDate`(급여 종료 통지 전달일) · `EligibilityDeterminationMethod` · `BenefitAssignmentSummary` · `BenefitAssignmentKeywords` |
| `BenefitDisbursement` 신규 `DisbursementMethod` | 급여 지급 방법 |
| `PartyProfile` 신규 `PreferredCommunicationMethod` · `Ethnicity` | 신청자의 선호 커뮤니케이션 방법 · 인종 |
| `PartyRelationshipGroup` 신규 `HousingType` | party relationship group의 주거 유형 |
| ⛔ **`IndividualApplication.ApplicationFormTemplateId` 제거** | 원문: *"The `ApplicationFormTemplateId` field on the `IndividualApplication` object is **removed**. This field is no longer available."* — 이 절 유일의 **파괴적 변경** |

**Outbound Payments**

| 대상 | 내용 |
|---|---|
| 신규 `AuthorizedProductDelivery` | 제공자 ↔ **제공·전달이 승인된 제품·서비스** 연결 |
| 신규 `AuthorizedProductDeliveryDetail` | 단일 authorized product delivery에 연결된 **개별 전달 활동** 추적 |
| 신규 `BenefitProduct` | 급여 ↔ **전달이 승인된 제품** 연결 |
| 신규 `ProviderProduct` | 제공자가 제공·전달할 권한이 있는 **특정 제품과의 연관** |
| 신규 `ProviderProductAuthorization` | **정해진 날짜 범위 안에서 특정 수량의 제품·서비스를 전달할 제공자 권한** |
| `ClaimItem` 신규 필드 5 | `EndDate`(청구 종료 일시) · `Provider`(healthcare provider 연결) · `Quantity` · `StartDate` · `UnitofMeasureId` |

**Tax and Revenue Management · Talent Recruitment Management**

| 대상 | 내용 |
|---|---|
| `Organization` 신규 `PreferencesPublicSectorTaxRevEnabled` | 조직의 **Tax and Revenue Management 기능 활성화** |
| `RecruitmentPosting` 신규 `LastLeadsGenerationDate` | 채용 공고에 대해 **리드가 마지막으로 생성된 일시** |

#### New and Enhanced Common Features for Public Sector (랜딩이 나열한 6축)

랜딩 `rn_public_sector_solutions` 가 *"Public Sector includes access to some features that are available across clouds and products in Industries"* 로 요약한 목록이다 — **본문은 `### Industries Common Features` 절 소관**이므로 여기서는 랜딩의 한 줄만 남긴다: **Action Plans** · **Criteria-Based Search and Filter** · **Discovery Framework** · **Grantmaking** · **Omnistudio** · **Unified Catalog**.

### Industries Common Features (54건 전수 — 13개 축)

여러 Industries 클라우드가 공유하는 기능군이다. **Where가 축마다 완전히 다르므로** 아래에 축별로 원문을 분해했다.

| 축 | 공통 Where (원문) |
|---|---|
| **Business Rules Engine** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Business Rules Engine 활성** (2건은 **Context Service도 활성** 필요, 1건은 **Agentforce도 활성** 필요) |
| **Criteria-Based Search and Filter** | **Lightning Experience 및 Experience Cloud** · **Enterprise·Performance·Unlimited·Developer** + **Criteria-Based Search and Filter 애드온 라이선스**(Experience Cloud 사용자는 **Criteria-Based Search and Filter for Experience Cloud 애드온 라이선스**). **Who: `Criteria-Based Search and Filter` 시스템 권한** |
| **Unified Catalog** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Unified Catalog** (LWR 항목은 *"LWR sites accessed through Lightning Experience"*) |
| **Outbound Engagement** | Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Outbound Engagement 및 Marketing Cloud Next** |
| **Fundraising** | Lightning Experience · **Enterprise·Unlimited·Developer** of **Agentforce Nonprofit 및 Agentforce Education** + **Automatic Household Creation and Naming 애드온** |
| **Timesheets and Labor Cost Optimization (ASLM)** | Lightning Experience · **Enterprise·Performance·Unlimited** + **ASLM(Asset Service Lifecycle Management)** + **Field Service Plus for Energy & Utilities** |
| **Channel Revenue Management** | Lightning Experience · **Professional·Enterprise·Unlimited** + **Channel Revenue Management 애드온 및 Data 360 활성**. **애드온은 Sales Cloud 또는 Industry Anchor Sales 라이선스와 함께 동작**하며 **DPE on Data 360을 쓰려면 해당 Data 360 라이선스가 필요**하다. **Who: `Rebate and Accruals Management Advanced` 권한 세트** |

#### Business Rules Engine (`rn_business_rules_engine_intro` 허브 + 리프 8)

| 항목 | 내용 |
|---|---|
| **Run Business Rules Engine Logic in Agentforce**<br>`rn_bre_agentforce_actions` | 활성화된 expression set·decision table을 **Agentforce의 reference action**으로 연결해 대화 중 적격성 검사·계산을 실행. ⚠️ **Where: BRE **및 Agentforce** 활성.** **How:** BRE에서 expression set·decision table 활성화 → Agentforce Studio에서 agent action 생성 → **action type을 API로 선택** → action category에서 **Expression Sets 또는 Decision Tables** 선택. ⚠️ **원문 제약: *"Only activated expression sets built without a context definition are available as actions."*** (context definition으로 만든 expression set은 액션으로 쓸 수 없다) |
| **Use the Branch Element in Context-Aware Expression Sets**<br>`rn_bre_list_branch_element` | context definition을 쓰는 expression set에 **List Branch 요소**를 추가해 **리스트 데이터 위에 직접 if-then-else 규칙**을 만든다. ⚠️ **들어오는 각 리스트 항목은 조건을 만족하는 첫 번째 branch에서 처리된다.** **Where: BRE + Context Service 활성.** **How:** Expression Set Builder에서 Elements 패널의 List Branch를 캔버스로 드래그 → 각 If branch에 조건 정의 → branch 안에 **계산·lookup table·subexpression** 같은 지원 요소 추가 |
| **Process Multiple Outcomes from Decision Tables in Standard Expression Sets**<br>`rn_bre_multiple_outcomes_standard_expression_sets` | 단일 입력에서 **여러 출력을 반환하는 decision table**을 **표준 expression set**에서도 사용 — **Context Service를 쓰지 않는 조직에서도** 가능. ⚠️ **이전엔 context definition 기반 expression set만 decision table 조회의 복수 매칭 결과를 처리할 수 있었다.** **How:** Expression Set Builder에서 **Lookup Table 스텝**을 추가하고 복수 출력이 구성된 decision table 선택 → **Map Variables** → **복수 decision table 출력 처리 옵션 켜기**. **Expression Set Builder가 필요한 list variable을 생성해 출력을 매핑**한다 |
| **Reduce Errors in Expression Set Conditions with Picklist Value Suggestions**<br>`rn_bre_picklist_value_suggestions` | **List Filter 조건**을 picklist 타입 context variable에 쓸 때 **유효 값 드롭다운**에서 선택. **type-ahead 검색**과 **허용되지 않는 값 입력 시 즉시 경고**. **Where: BRE + Context Service 활성** |
| **Call Decision Tables from Omniscripts**<br>`rn_bre_omniscript_decision_table_action` | 활성 decision table을 **Apex 컨트롤러나 수동 우회 없이** Omniscript에서 직접 호출. **How:** **Omniscript Designer 또는 Integration Procedure Designer**에서 **Decision Table 액션**을 캔버스로 드래그 → 활성 decision table 선택 → **표준 Omnistudio 병합 필드 문법**으로 들어오는 JSON을 테이블 입력 변수에 매핑. **테이블 결과는 Omniscript·Integration Procedure JSON에 다시 병합**된다 |
| **Speed Up Decision Table Refreshes with Parallel Processing and Automatic Incremental Refreshes**<br>`rn_bre_decision_table_parallel_refresh` | ⚠️ **동작 기본값이 바뀌었다** — **첫 활성화 시 full refresh가 끝난 뒤부터는 전체 데이터셋을 재처리하지 않고 변경분만 처리하는 것이 기본**이 된다. 또한 **여러 테이블이 순차 대기 없이 동시에 refresh**된다 |
| **Use More Data Types in CSV-Based Decision Tables**<br>`rn_bre_csv_decision_table_data_types` | CSV 기반 decision table이 **Percentage · Currency · Date/Time** 컬럼을 지원 |
| **See Decision Table Status at a Glance from the List View**<br>`rn_bre_decision_table_status_list_view` | Decision Table 리스트 뷰에 **Status 컬럼**(active/inactive) 추가. **상태로 정렬**해 비활성 테이블을 빠르게 찾는다 |

#### Criteria-Based Search and Filter (`rn_criteria_based_search_and_filter` 허브 + 리프 4)

| 항목 | 내용 |
|---|---|
| **Speed Up Bulk Actions by Selecting Entire Result Sets Instantly**<br>`rn_speed_up_bulk_actions_by_selecting_entire_result_sets_instantly` | ⚠️ **한 번에 최대 2,000개의 매칭 레코드**에 액션 실행. 데이터 테이블의 **Select All 체크박스**로 현재 페이지 로드분을 선택하면 **컨텍스트 배너**가 뜨고, 거기서 **모든 매칭 레코드(최대 2,000)로 선택을 확장**해 **Flow · Omnistudio · 커스텀 LWC** 액션에 바로 전달한다 |
| **Guide Users Through Screen Flows with Criteria-Based Search and Filter Intake**<br>`rn_guide_users_through_screen_flows_with_cbsf` | 신규 **Criteria-Based Search and Filter Intake 컴포넌트**를 Screen 요소에 추가해 **미리 채운 필터 조건**으로 검색을 실행하고, **특정 필터 필드를 읽기 전용으로 잠그고**, **최대 레코드 선택 수를 강제**한다. **How:** Flow Builder에서 컴포넌트를 Screen 요소로 드래그 → **Search Configuration · Search Context(사전 채움/잠금) · Maximum Selection** 구성 |
| **Deploy Search Experiences Faster with Prebuilt Templates**<br>`rn_deploy_search_experiences_faster_with_prebuilt_templates` | **search criteria configuration · searchable object · search result action** 용 사전 구축 템플릿. **How:** Setup → **Criteria-Based Search and Filter** → 구성 탭에서 목록을 **Template 레코드로 필터** → search configuration·searchable object 템플릿은 열어서 **Clone** → **action configuration 템플릿은 드롭다운에서 Clone 선택**(경로가 다르다) |
| **Extend Criteria-Based Search Actions to Experience Cloud Users**<br>`rn_extend_criteria_based_search_actions_to_experience_cloud_users` | **파트너·게스트 사용자**에게 특정 CBSF 액션을 구성·노출. **How:** Setup → Criteria-Based Search and Filter → **Search Result Actions 구성**을 열고 노출할 액션을 선택 → **보안 가이드라인에 따라 partner 또는 guest 사용자 프로필에 대해 활성화** → 저장 후 Experience Cloud 사이트에 게시 |

#### Unified Catalog (4건)

| 항목 | 내용 |
|---|---|
| **Build Reusable Service Intake Forms with Custom Components**<br>`rn_build_reusable_service_intake_forms_with_custom_components` | **`Create Service Catalog Request` 플로우 invocable action**으로 intake form을 한 번 구성하면 시스템이 **조직 간 일관되게 배포**한다(마이그레이션 시 수동 재구성 제거). **커스텀 LWC 지원**, 요청별 **속성 데이터 전수 캡처**. **How:** Flow Builder에서 Action 요소 추가 → Action 필드에서 **Create Service Catalog Request** 검색·선택 |
| **Modify Request Details After Submission**<br>`rn_modify_request_details_after_submission` | 서비스 프로세스 설계 시 **상태(status)별로 어떤 속성을 누가 편집할 수 있는지** 지정해, 요청이 활성인 동안 정해진 경계 안에서만 갱신되게 한다. ⚠️ **How: 이 변경은 요청 기반으로만 제공된다 — *"This change is available by request. Contact your Salesforce account executive."*** |
| **Display Context Attribute Values on Request Records**<br>`rn_display_context_attribute_values_on_request_records` | **부모·자식 수준 속성**을 화면 전환 없이 함께 표시. **원문 예시: 고객 케이스 검토 시 케이스 우선순위와 관련 케이스 코멘트를 함께 본다** |
| **Deploy Components on Lightning Web Runtime Experience Cloud Sites**<br>`rn_deploy_components_on_lightning_web_runtime_lwr_experience_cloud_sites` | **LWR 사이트에 Unified Catalog 컴포넌트** 추가 — 요청자가 카탈로그 카테고리 탐색·항목 검색·요청 제출. **Where: Lightning Experience를 통해 접근하는 LWR 사이트** · Enterprise·Unlimited·Developer + Unified Catalog. **How:** Experience Builder에서 컴포넌트를 페이지로 드래그 → 속성 구성 → 사이트 게시 |

#### Outbound Engagement (5건 + 오브젝트)

| 항목 | 내용 |
|---|---|
| **Create Flexible Outbound Campaigns with Custom Templates**<br>`rn_outbound_engagement_custom_templates` | 기존 플로우·캠페인을 선택하거나 사전 구축 템플릿에서 시작해 커스텀 템플릿 구축. **리스트 뷰에서 사용자가 직접 트리거하는 플로우**를 실행. **How:** Outbound Engagement Templates 홈 → **Create** → **Build from scratch**(적용 플로우·캠페인 선택) 또는 **Use a prebuilt template**(사용자 트리거 메시징용) |
| **Maintain Brand Consistency Across All Outbound Communications with Custom Branding**<br>`rn_outbound_engagement_custom_branding` | ⚠️ **브랜드는 Marketing Cloud Next에서 생성·관리**한다. **발신자 상세와 communication subscription을 outbound engagement 모달에서 직접 구성**해 **플로우를 편집하지 않고** 설정 시간을 줄인다 |
| **Run Outbound Engagements in the Background and Keep Working**<br>`rn_outbound_engagement_async_processing` | 아웃바운드 인게이지먼트와 템플릿이 **백그라운드에서 비동기 생성**되고 완료 시 자동 알림 |
| **Simplify Communications with Generic Events**<br>`rn_outbound_engagement_generic_events` | 플로우에서 **generic event**로 기본 발송 용도의 템플릿 생성 — **복잡한 이벤트별 타입 정의 없이** 리스트 뷰에서 발송(예: 회원이 리워드를 사용했을 때 감사 메시지). **How:** automation event-triggered flow 생성 시 Start 노드 → **Select Event** → Event Library에서 **`Outbound Engagement Content List Send Event`** 선택 |
| **Message Multiple Customers at Once from List Views**<br>`rn_outbound_engagement_list_view_mass_actions` | 지원되는 리스트 뷰의 **Send Message 액션**으로 로열티 회원·컨택 등에게 대량 발송. ⚠️ **How: 리스트 뷰에 Send Message 버튼을 띄우려면 해당 오브젝트에 대해 `List Page` placement를 가진 manual-send outbound engagement 템플릿을 구성해야 한다.** 그다음 **All Loyalty Program Members**·**All Contacts** 같은 리스트 뷰에서 레코드를 선택하고 Send Message |
| **New and Changed Objects in Outbound Engagement**<br>`rn_outbound_engagement_objects` | **신규 `Outbound Engagement Template` 오브젝트**(커스텀 템플릿 생성) · **`Outbound Engagement Template View` 신규 필드 `Custom Template`·`Template Subcategory`·`Status`** · **`Outbound Engagement Content Resource` 신규 필드 `Status`·`Status Reason`** |

#### Fundraising (2건 + 오브젝트)

| 항목 | 내용 |
|---|---|
| **Automatically Generate and Maintain Household Names**<br>`rn_fundraising_auto_household_naming` | **수식 기반 명명 패턴**을 정의하면 멤버 추가·삭제·수정 시 가구 계정명이 자동 재계산된다. **명명 엔진이 가구 멤버십과 멤버 상세 변경을 수신해 실시간 재계산.** **Who:** Agentforce Nonprofit·Agentforce Education **관리자**가 설정. **How:** Setup → **Household** 입력 → **Group Membership** 아래 **Household Naming Settings** → **Automatic Household Naming 켜기** → 가구 명명 템플릿 생성 |
| **Create Households for Person Accounts During Gift Entry**<br>`rn_fundraising_automate_household_gift_entry` | **Gift Entry Grid** 또는 **Business Process API**에서 기부자를 가구에 직접 추가(별도 자동화 불필요). **How(UI):** Gift Entry Grid에서 person account를 기부자로 추가할 때 **Auto Create Household** 선택 — **기부자가 가구에 속해 있지 않으면 Salesforce가 가구를 만들어 추가**한다. **How(API):** Business Process API의 **`/gifts` 또는 `/commitments` 엔드포인트** 호출 시 요청 페이로드에 **`shouldAutoCreateHousehold` 를 `true`** 로 설정 → API가 **household account · party relationship group · account contact relationship** 를 생성한다 |
| **New and Changed Objects for Fundraising**<br>`rn_fundraising_new_changed_objects` | ⚠️ **원문 Note: 기존 고객이 신규·변경 필드를 보지 못하면 Salesforce 관리자에게 해당 오브젝트 페이지 레이아웃에 필드를 추가해 달라고 요청해야 한다.** **신규 오브젝트: `HouseholdNamingConfig`**(가구 명명·인사말 자동화 정의). **변경(전수):** `AccountContactRelation` — **`IsExclFrHshldAutoNaming`**(person account를 자동 명명·인사말에서 제외) · **`HouseholdAutoNamingSequence`**(명명 시 가구 구성원 순서) / `PartyRelationshipGroup` — **`IsExclFrHshldAutoNaming`**(가구 계정을 자동 명명·인사말 갱신에서 제외) / `GiftEntry` — **`IsAutoCreateHousehold`** / `GiftSoftCredit` — **`SoftCreditSource`**(soft credit의 출처, 예: 가구 관계) / `DonorGiftSummary` — **`TotalHouseholdCreditsAmount`**(가구 구성원의 hard credit + soft credit 총액) / `FundraisingConfig` — **`HshldSoftCreditExclFormula`**(불리언 수식으로 가구 계정을 soft credit 생성에서 제외) / `HouseholdUiConfiguration` — **`PrimaryHouseholdField`**(커스텀 account 필드를 primary household account lookup과 동기화) |

#### Action Plans · Stage Management · Discovery Framework · Grantmaking

| 항목 | 내용 |
|---|---|
| **Manage More Complex Business Processes with Action Plans**<br>`rn_manage_more_complex_business_processes` | ① action plan 레코드의 **Owner·Target 필드로 리포트** 실행 ② ⚠️ **액션 플랜당 태스크 상한 100 → 200** ③ **종속 태스크의 `Assigned To` 를 부모 태스크 완료 전에 변경 가능**. ⚠️ **Where가 이 노트에서 가장 모호한 표현 중 하나다 — 원문: *"This change applies to Lightning Experience in multiple Industries clouds where they're available."*** (구체적 에디션·클라우드 목록 없음) |
| **Run Tasks on Demand to Meet Regulatory and Customer Deadlines**<br>`rn_stage_management_on_demand_tasks` | 레코드의 **현재 스테이지에서 적격한 태스크를 하나 이상 선택**하고 **사유와 코멘트를 기록한 뒤 즉시 실행**. **온디맨드 태스크는 1회 실행**되며 **stage transition 레코드에 누가·어떤 태스크를·왜·언제 실행했는지 전부 추적**된다. **Where: Lightning Experience · Enterprise·Unlimited + Stage Management.** ⚠️ **Who — 권한이 두 갈래:** 실행에는 **`Stage Management On-demand User`**, **step definition을 온디맨드 적격으로 표시하고 사유 목록을 관리하려면 `Stage Management Design User`**. **How:** Stage Management builder에서 step definition을 온디맨드 적격으로 표시하고 **선택 가능한 사유(예: Regulatory Requirement · Customer Request · Error Correction)** 를 정의 |
| **Validate Documents During Upload and Prefill Assessment Forms with AI**<br>`rn_validate_uploaded_documents_prefill_assessment_forms_ai` | **AI-Powered Document Upload Validation and Prefill** 로 업로드 문서에서 정보를 추출해 **Discovery Framework assessment form의 연결 필드**를 채운다. **비적합 업로드를 차단하거나 진행 전 경고하는 검증 규칙** 구성. ⚠️ **Where: Lightning Experience · Developer·Enterprise·Unlimited + Discovery Framework**(Performance 없음). **How:** Setup의 **Discovery Framework settings**에서 켜고, **Omniscript builder**에서 검증 규칙 구성 |
| **Standardize and Secure Grant Application Evaluation Stages**<br>`rn_grantmaking_evaluation_action_plan_templates` | 재사용 가능한 **Action Plan Template**으로 다단계 심사를 표준화하고 **Compliant Data Sharing**으로 심사자를 자기 전문 영역 섹션에 제한. **이전엔 보조금 주기마다 수동 심사가 필요해 파편화된 심사 경험과 지연·심사자 편향 위험**이 있었다. **Where: Lightning Experience · Enterprise·Unlimited·Developer — Nonprofit Cloud 및 Agentforce Public Sector 고객 중 Grantmaking 보유.** **How:** App Launcher → **Action Plan Templates** → New → **target object를 `Application Form Evaluation` 로 선택** → 저장 후 evaluation section을 template item으로 추가. 섹션 단위 가시성은 Setup → **Compliant Data Sharing** → **`Application Form Evaluation Section` 엔터티에 대해 활성화** |
| **Updated Objects and Fields in Grantmaking**<br>`rn_grantmaking_updated_objects_and_fields_in_grantmaking` | **신규 `AppFormEvalSectionPtcp` 오브젝트** — application form evaluation section에 접근 권한이 있는 사용자를 식별 |

#### Actionable List with Data 360 (`rn_actionable_list_dmo_overview` 허브 + 리프 1)

| 항목 | 내용 |
|---|---|
| **Build Targeted Client Lists with Data Model Objects (Generally Available)** 🟢GA<br>`rn_actionable_list_dmo` | **Data 360 DMO의 통합 데이터 위에서 직접 필터링**해 actionable list를 만든다 — CRM 필드와 **현금 잔액 · 마케팅 인게이지먼트 점수 · 구매 이력** 같은 외부 데이터를 한 리스트에서 결합. ⚠️ **원문 명시: 외부 필드 값은 필터링에만 쓰이고 CRM 레코드에 절대 기록되지 않는다.**<br>⚠️ **Where: Lightning Experience · Enterprise·Professional·Starter·Unlimited + Agentforce Financial Services, 그리고 Data 360 과 `Industry Sales Excellence` 권한 세트 라이선스 필요**(이 노트에서 **Starter 에디션이 등장하는 유일한 항목**).<br>**Who — 역할별 3단계:** DMO 구성 관리자 = **`Data 360 Architect`** / actionable list 정의 생성 관리자 = **`Data 360 User` + `Actionable Segmentation Admin`** / 리스트를 만들고 다루는 어드바이저 = **`Data 360 User` + `Actionable Segmentation List Manager`**.<br>**Why(원문이 나열한 이점 전수):** ① 사전 구축 segment 대신 **DMO 데이터에 직접 필터** — **segment 기반 리스트에 걸리는 더 낮은 리스트 볼륨 상한에 묶이지 않는다** ② **CRM 필드와 DMO 필드를 한 필터에 나란히** 결합(유스케이스마다 관리자가 segment를 미리 만들 필요 없음) ③ **온디맨드 refresh** 로 최신 Data 360 데이터를 끌어와 멤버십 자동 갱신 ④ 멤버를 **사용자·레코드 소유자·큐**에 배정 ⑤ **커스텀 색상 워크플로 상태**(예: To Contact · Contacted · Re-engaged)로 진행 추적.<br>**How:** Setup → **Actionable List with Data 360 Data Model Objects Settings** → 켜기 → New → **Data Space \| Data Model Object** 선택 → 이름·**CRM 소스 오브젝트(Account 또는 Contact)**·표시 필드·**primary key 매핑**·member status 구성. 리스트 생성은 App Launcher → **Actionable Lists** → New → 소스로 **Data 360 Data Model Objects** 선택(기존 Data 360 segment 옵션과 나란히) → 필터 작성 → CRM·Data 360 컬럼을 함께 미리보기 → 기본 상태 설정 → 저장. **저장된 리스트에서 Refresh 를 눌러 최신 데이터로 멤버십 갱신** |

#### Asset Service Lifecycle Management — 자산·재고·타임시트 (7건)

| 항목 | 내용 |
|---|---|
| **Accelerate Upsell and Cross-Sell Conversions with Efficient, Error-Free Quoting**<br>`rn_asset_management_agentforce_upsell_cross_sell_quote_updates` | **Agentforce Product Upsell and Cross-Sell in Service**(ASLM)에서 에이전트가 **여러 제품을 한 번에 견적에 추가**하고 **신규·기존 quote line item에 직접 할인 적용**. ⚠️ **Where: Lightning Experience — Automotive · Communications · Manufacturing 대상. `Asset Service Lifecycle Management` + `Industries Field Service` 애드온 + **산업별 Agentforce 애드온** 이 모두 활성이어야 한다.** **How:** Setup에서 ASLM 켜기 → 사용자에게 Agentforce 권한 세트 배정 → **Upsell and Cross-sell agent topic 구성** |
| **Track Unusable Inventory to Maintain Accurate Available Stock Levels**<br>`rn_asset_management_track_unusable_inventory` | 입고·재고 이전 중 **손상·만료·분실·도난 등 사용 불가 재고를 캡처·분류**하고 가용 수량에 반영하며, **batch·serialized 제품 포함 수량 변경 이력을 추적 가능하게 보존**. **원문 예시:** 유통사가 1,000개를 입고해 **100개를 damaged, 100개를 expired로 기록**하고 expired 재고를 junk location으로 이전하면 **가용 수량은 사용 불가 200개를 제외**하되 사유와 재고 변동은 추적 가능하게 남는다. **Where: Lightning Experience · ASLM이 활성인 여러 클라우드**(에디션 미명시). **Who:** `Inventory Search and Transfer` 또는 `Inventory Replenishment User` 권한 세트. **How:** Setup → **Inventory Management General Settings** → **Inventory Management for Unusable Quantities 활성화** → 사용자가 입고·이전 시 **Inventory Status** 와 **Status Reason(Damaged · Expired · Lost · Stolen 또는 커스텀 값)** 선택 |
| **New and Changed Objects for Inventory Management**<br>`rn_new_and_changed_objects_for_inventory_management` | `Product Inventory Searchable Field` 신규 필드 3 — **`Total Unusable Quantity`** · **`Replenishment Basis`** · **`Replenishment Basis Quantity`**. `Inventory Replenishment Policy` 신규 필드 **`Replenishment Quantity Basis`**(보충 정책이 **quantity on hand 기준인지 available quantity 기준인지** 지정) |
| **Tailor Vehicle Selection Options by Service Resource Profile for Flexible Timesheet Entry**<br>`rn_aslm_tmsht_timesheets_vehicle_selection_options`<br>*(컨테이너 `rn_aslm_tmsht_timesheets_overview`)* | Service Resource가 **vehicle · vehicle definition · asset 아키텍처 중 프로필에 맞는 것**만 보도록 구성. 차량을 timesheet에 연결해 차량 사용 시간에 배분. ⚠️ **Who: 관리자는 `Labor Cost Optimization Admin` 권한 세트. Salesforce Field Service 모바일 앱에서 차량을 선택하려면 `Labor Cost Optimization Resource` 와 `FieldServiceMobileStandardPermSet` 권한 세트가 필요하다.** **How:** Setup → **Advanced Timesheet and Labor Cost Optimization Settings** → Vehicle selection options에서 **Page Layout Control** 선택 → **Time Sheet Entry Layout을 Service Resource 프로필별로 배정** |
| **Create Timesheets for a Crew Across a Date Range**<br>`rn_aslm_tmsht_timesheets_create_across_date_range` | crew lead가 **여러 crew member의 timesheet를 날짜 범위 단위로 한 번에** 생성. **백그라운드 생성 후 완료 알림.** ⚠️ **한도 전수: 한 요청에 최대 50명, 과거·미래 35일 범위.** **랜딩 페이지에서 최근 3건의 요청**을 바로 조회 |
| **Resolve Date Conflicts When Creating Timesheets Across a Date Range**<br>`rn_aslm_tmsht_timesheets_resolve_date_conflicts` | 이미 timesheet가 있는 날짜가 섞여 있으면 **충돌 날짜만 제외**하고 나머지로 생성. **정확한 충돌 날짜를 나열**하고 **마음이 바뀌면 제외를 되돌린다**. ⚠️ **이전엔 날짜 충돌이 있으면 범위를 수동으로 조정할 때까지 timesheet 생성이 막혔다** |
| **Control Timesheet Entry Item Field Visibility**<br>`rn_aslm_tmsht_timesheets_control_field_visibility` | 기술자가 timesheet entry item을 생성·편집할 때 **표시될 필드를 지정** |

#### Channel Revenue Management (`rn_channel_revenue_management` 허브 + 리프 2)

| 항목 | 내용 |
|---|---|
| **Create Accruals that Align with Your Rebate Programs**<br>`rn_chrm_create_accruals_rebate_programs` | 리베이트 accrual을 **단일 계산 유형에 억지로 맞추지 않고** 실제 프로그램 구조대로 모델링 — **flat · tiered · growth-based** 계산을 **Data 360 위의 DPE** 로 수행. ⚠️ **기중에 요율이 갱신되면 accrual이 자동 조정**되고 갱신 총액이 재무 검토용 accrual 요약에 나타난다. **How:** Setup에서 **Rebate and Accruals Management Advanced** preference 활성화(또는 Salesforce Go에서 설정) → **Rebate Program 수준에서 accrual 구조 구성** → 대량 계산은 DPE on Data 360으로 실행 |
| **Optimize Payout Calculation with Advanced Rebate Payouts**<br>`rn_chrm_optimize_payout_advanced_rebate_payouts` | **flat · tiered · growth-based** 구조를 포함해 실제 상업 계약과 일치하는 **정확하고 감사 가능한 리베이트 지급**을 생성. **혜택이 갱신되면 지급 계산이 자동 조정**돼 수동 재작업 없이 정확도가 유지된다. **How:** 위와 동일하되 **Rebate Program 수준에서 payout 구조 구성** |

#### Supplier Engagement (2건)

| 항목 | 내용 |
|---|---|
| **Accelerate Scope 3 Reporting with Supplier Management**<br>`rn_accelerate_scope_reporting_with_supplier_management` | Supplier Engagement 안의 end-to-end **Supplier Management** 로 **Scope 3 배출량 수집·추적**. **Salesforce Go 원클릭 설정**으로 사전 구축 공급업체 포털 생성. 공급업체는 **브랜드가 적용된 셀프서비스 포털**에서 **가이드형 4단계 마법사**로 지속가능성 스코어카드를 작성하며 **각 단계마다 진행 상황이 저장**된다. **Experience Builder에서 코드 없이 단계별 폼 필드 커스터마이즈.** **`SustainabilityScorecard` 오브젝트의 표준 필드**로 지속가능성·비용·리스크·조달 데이터를 캡처하며 **SBTi 목표**와 **배출량 assurance level** 포함.<br>⚠️ **Where: Lightning Experience · Enterprise·Unlimited·Performance — Manufacturing · Automotive · Consumer Goods 라이선스 + Partner Engagement Management 활성.**<br>⚠️ **Who — 라이선스가 세 겹이다:** ① Supplier Management 사용에는 **`Supplier Management` 애드온 라이선스** ② 조달 관리자·지속가능성 담당자가 공급업체 레코드와 스코어카드를 만들려면 **`Supplier Onboarding` 권한 세트 라이선스** ③ 공급업체 포털 사용자에게는 **`External Supplier Management` 애드온 라이선스 + `Suppliers Onboarding to Site` 권한 세트 라이선스 + `Power Partner` 또는 `Partner Community` base 라이선스**.<br>**How:** Salesforce Go에서 Supplier Management를 켜면 **Digital Experiences가 활성화되고 Supplier Portal 사이트가 하나의 가이드 설정 플로우로 생성**된다. ⚠️ **Salesforce Go를 쓰지 않으면 Setup의 Supplier Preferences에서 `Supplier Onboarding and Data Collection` · `Supplier Program Management` · `Supplier Target Setting` 을 직접 켜야 한다** |
| **New and Changed Objects in Supplier Engagement**<br>`rn_new_and_changed_objects_in_supplier_engagement` | `Supplier` 오브젝트에 **신규 필드 5종 — `Goal` · `Goal Details` · `Cost Unit` · `Emissions Reduction Unit` · `Quality Unit`**(공급업체 레코드에서 직접 지속가능성 목표 설정·추적). `Program` 과 `ProgramInitiative` 는 기존 **Environmental · Social · Governance** 카테고리에 더해 **cost · quality · emissions reduction · risk reduction** 목표로 분류 가능 |

#### 그 밖의 공통 항목

| 항목 | 내용 |
|---|---|
| **Track Supplier Risk Across Your Multi-Tier Supply Chain (Pilot)** 🟠Pilot<br>`rn_supply_chain_resiliency_pilot` | 신규 **Supply Chain Resiliency 데이터 모델**(**highly flexible and extendable**)이 **공급업체 네트워크와 BOM(bill-of-materials) 구조부터 그것이 영향을 주는 프로그램·계약까지** 공급망 **모든 tier의 리스크를 실시간**으로 보여준다. **Where: Lightning Experience · Enterprise·Performance·Unlimited·Developer + Agentforce Public Sector 활성.** ⚠️ **활성화 경로: *"To enable Supply Chain Resiliency, contact your Salesforce account executive."*** — Setup 토글이 아니다.<br>**Pilot 고지 전수:** *"Supply Chain Resiliency for Public Sector is a pilot or beta service that is subject to the Beta Services Terms at Agreements - Salesforce.com or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion."* |
| **Simplify Program and Case Management Feature Setup**<br>`rn_npc_salesforce_go_configuration` | **Salesforce Go**에서 **Program Management · Case Management · Outcome Management** 를 단계별 안내로 구성 — **페이지 이동 없이 한 페이지에서 전 과정 완료**. 기능 사용량 추적과 콘텐츠 자료 접근. ⚠️ **Where: Lightning Experience · Enterprise·Unlimited·Developer** (제품·애드온 조건이 원문에 없다). **Who: Salesforce 관리자** |

### Omnistudio (`rn_omnistudio_for_industries` 허브 + 4건)

> 허브 `rn_omnistudio_for_industries` 원문: *"Many Industries products include access to Omnistudio features. Use these features to extend and customize your product based on your business needs."* — 상시 레퍼런스는 *Latest Release Notes for Omnistudio*.

| 항목 | 내용 |
|---|---|
| **Simplify Omnistudio Component Deployments with Clean Metadata**<br>`rn_omnistudio_clean_metadata_deployment` | **Clean Metadata Deployment** 로 Omnistudio 컴포넌트를 표준 Salesforce 메타데이터와 **같은 도구·프로세스**로 배포 — **Salesforce CLI · change set · 1GP · 2GP 패키지**를 LWC·플로우·Apex와 **동일 파이프라인**에서. ⚠️ **Where: Omnistudio의 표준 런타임·표준 디자이너에만 적용된다. 관리형 패키지 런타임·디자이너를 쓰고 있다면 표준으로 마이그레이션해야 한다.** **Why(원문이 나열한 개선 7가지 전수):** ① **Atomic deployment** — 다른 Salesforce 메타데이터 타입과 한 번에 배포 ② **자동 의존성 탐지**(**이 탐지는 1세대 패키지에 적용**) ③ **단일 버전 관리** — 긴 목록을 훑지 않고 활성 버전만 다루며 배포마다 대상 조직에 버전 생성 ④ **읽을 수 있는 diff** ⑤ **패키징 지원**(1GP·2GP) ⑥ **샌드박스 복사 지원** — full·partial copy 샌드박스 생성 시 컴포넌트 자동 복사 ⑦ **소스 추적** — 로컬 프로젝트와 scratch org·샌드박스 간 변경 추적. ⚠️ **How: Setup → Quick Find `Omnistudio Settings` → Clean Metadata Deployment 를 소스 조직과 대상 조직 양쪽에서 켜야 한다** |
| **Reuse Autolaunched Flow Logic Across Your Flexcards (Generally Available)** 🟢GA<br>`rn_omnistudio_flexcard_autolaunched_flow` | 활성 **autolaunched flow를 Flexcard 데이터 소스**로 설정하거나 **Flexcard 액션에서 플로우를 직접 호출**. **autolaunched flow 데이터 소스는 Omnistudio 표준 디자이너에서 제공.** **Where: Lightning Experience 및 Experience Cloud 사이트 · Enterprise·Performance·Unlimited + Omnistudio 활성.** **How:** App Launcher → Flexcards → 카드 열기/생성 → 표준 디자이너의 **Setup 패널 → Datasource 섹션** → **Data Source Types 드롭다운에서 Autolaunched Flow** 선택 → **Autolaunched Flows 필드**에서 활성 플로우 검색·선택 → **Input Map 섹션에서 Import** → autolaunched flow key-value map 선택 → Import → 저장. **카드 상호작용에서 실행하려면 Action 요소를 추가하고 action type을 `Data` 로, 대상을 `Autolaunched Flow` 로 설정** |
| **Run Flexcards and Omniscripts Offline on Mobile Devices**<br>`rn_omnistudio_flexcard_omniscript_offline_mobile` | 모바일 사용자가 Flexcard·Omniscript를 **완전 오프라인으로 열고 완료·제출**. **데이터 작업·입력 검증·계산이 기기에서 실행**되고 완료된 액션은 **로컬 큐에 쌓였다가 연결 복구 후 순서대로 동기화**된다. **Where: Lightning Experience 및 Experience Cloud 사이트 · Enterprise·Performance·Unlimited + Omnistudio 활성. 오프라인 Flexcard·Omniscript는 Salesforce 모바일 앱 iOS·Android에서 지원된다** |
| **Omnistudio Minor Releases**<br>`rn_omnistudio_updates_minor_releases` | ⚠️ **범위가 이 릴리즈가 아니다** — 원문: *"Find out about bug fixes, minor updates, and known issues about Omnistudio made **after Summer '25 and before Winter '26**."* (Winter '27 노트 안에 있지만 다루는 기간은 Summer '25~Winter '26 사이다) |

> **Omnistudio 파일럿 2건 — 리프 페이지가 아니라 Public Sector 랜딩(`rn_public_sector_solutions`)의 공통 기능 요약에만 등장한다:** ① **Omniscript와 Flexcard를 Lightning Web Runtime(LWR) Experience Cloud 사이트에 추가 (pilot)** ② **Omnistudio 컴포넌트·요소에 대해 즉시 도움을 받는 Omnistudio Assistance AI Agent (pilot)**. 같은 요약이 **UTAM(UI Test Automation Model) 프레임워크로 Omniscript·Flexcard 워크플로를 end-to-end 검증**, **Omniscript·Flexcard 접근성 개선**, **Omnistudio Data Mapper Extract·Turbo Extract 컴포넌트의 `Is Null` 연산자로 빈 레코드 필터링**도 함께 언급한다. **이 5건은 Winter '27 Clouds 카탈로그에 독립 page id가 없어 Where·How를 확보하지 못했다.**

### ⭐ 대표 신기능
1. **Public Sector 46건 — Taxpayer 360 데이터 모델 + 셀프서비스 세무 포털 + Taxpayer Advocate 에이전트**(단 **Agentforce Voice는 Government Cloud 미제공**), **복수 급여 프로그램 단일 신청 + 병렬 적격성 평가**, **Workforce Scheduling 13페이지 신설**.
2. **Insurance 33건 — Group Benefits 라이프사이클 전면 신설**(census→quote→contract→policy, Connect API 12 + invocable action 14) + **Insurance Design Advisor**(2026-10-02) + 보험/비보험 견적을 한 조직에서.
3. **Automotive의 압류(Repossession) 3단계 라이프사이클 신설** — 단 ⚠️ **추천 알림과 Milestone 컴포넌트는 기본 제공이 아니다**.
4. **Life Sciences의 Visit Agent GA** — 이 릴리즈에서 전제가 가장 무거운 GA(**Agentforce for LSC 애드온 + `Access Custom Agents` + Setup 토글 + 로그인 시 약 632 MB Whisper 모델 다운로드 + iPad의 Apple Intelligence**, 파일럿 사용자는 **재배정 필요**).
5. **Media의 OOH·in-store 리테일 미디어 진출** + **RFP Management GA**(10 MB 문서, 생성형 AI 요약).
6. **Industries CPQ의 규모 한계 상향** — mass discount **50,000 라인 아이템**, GetCartItems 응답 trim, `MultiEditStrictValidationMode`. ⚠️ **다섯 개 기능이 커스텀 설정을 직접 추가·설정해야 켜진다.**
7. **Omnistudio Clean Metadata Deployment**(표준 파이프라인 편입) + Flexcard/Omniscript **완전 오프라인 실행**.
8. **Education의 학생 라이프사이클 대확장**(위임 접근·course versioning·전 학점 이관·HESA/MortarCAPS 규제 대응).

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

> *"Use Slack and Salesforce together to connect with customers, track progress, collaborate seamlessly, and deliver team success from anywhere."* Winter '27 Slack Integrations 영역에서 확보된 항목은 **1건**이다.

| 항목 | 내용 |
|---|---|
| **Sell Smarter in Slack — Agentforce Sales and the New Go Page**<br>`rn_slack_agentforce_sales_for_slack` | **Agentforce Sales가 Slackbot에서 직접 사용 가능**해져 Sales 에이전트가 Slack 워크플로로 들어온다. ⚠️ **Where: Sales Cloud Enterprise · Unlimited · Agentforce 1 · Developer 에디션 + `Slack Business+` 이상 에디션 필요.** **When: 2026년 8월.**<br>**Why(원문 상세):** **신규 Agentforce Sales MCP(Model Context Protocol) 서버**가 CRM 데이터·AI 에이전트·비즈니스 컨텍스트를 Slack 워크스페이스에 연결한다. ⚠️ **Slack에서 취한 액션은 Salesforce로 자동 동기화**돼 레코드와 예측이 최신으로 유지된다. **Agentforce Sales in Slack에는 Pipeline Management 기능이 포함**된다. **신규 `Agentforce Sales in Slack` Go 페이지**가 온보딩 요건을 몇 단계로 집약해 **MCP 서버를 수동 구성할 필요가 없다**. **How:** 관리자가 그 Go 페이지에서 켠다 |

---

## Loyalty Management · Real-Time Offer Management · Referral Marketing

> **Referral Marketing 3건은 `## Marketing` 절의 `### Referral Marketing` 에 있다** — Winter '27 릴리즈 노트가 Referral Marketing을 Marketing 영역에 배치했기 때문이다. 이 절은 **Loyalty Management 10건 + Real-Time Offer Management 13건**을 다룬다.

### Loyalty Management (10건 전수)

**Where 기본형 [LOY]:** Lightning Experience · **Enterprise·Performance·Unlimited·Developer** + **Loyalty Management**. **예외 2건** — `rn_loyalty_multiple_milestone_levels` 는 **Loyalty Management - Growth 또는 Loyalty Management - Advanced** 가 필요하고, `rn_loyalty_upgrade_tiers_faster` 는 **Loyalty Management + Data 360** 이 필요하다.

| 항목 | 내용 |
|---|---|
| **Reduce Event Consumption with Smarter Loyalty Transaction Journal Creation**<br>`rn_loyalty_reduce_event_consumption` | 트랜잭션이 **레코드 변경을 유발하거나 프로모션 요건을 충족할 때만** 실시간 처리 중 transaction journal을 만든다. ⚠️ **이 최적화는 Transaction Journals Execution API를 통한 실시간 처리에만 적용되며 배치 처리에는 영향이 없다.** **Why — journal이 생성되는 프로그램 프로세스 동작 전수(9가지):** 포인트 적립·차감 · 바우처 발급·사용 · 배지 배정 · 게임 리워드 발급 · 회원 tier 변경 · **회원 attribute 값 갱신**(engagement attribute 또는 promotion party usage 레코드로 추적) · 레코드 생성·갱신·삭제 · 이메일 발송 · 플로우 실행 · 프로그램 프로세스 실행. **How:** Setup → **Loyalty Management Settings** → **`Transaction Journal Creation for Reward or Write Activities Only` 켜기**. **Where: [LOY]** |
| **Optimize Storage with Just-in-Time Member Currency Record Creation**<br>`rn_loyalty_optimize_storage` | 등록 시점이 아니라 회원이 **처음 포인트를 적립·사용할 때** member currency 레코드를 만든다 — **최초 credit 트랜잭션**에서 생성. ⚠️ **음수 포인트 잔액을 켰고 레코드가 없으면 최초 debit 트랜잭션에서 생성**한다. 회원 기능에 영향 없이 저장 소비 감소·DB 성능 향상. **How:** Setup → **Loyalty Management Settings** → **`On-Demand Member Currency Creation` 켜기**. **Where: [LOY]** |
| **Use Mixed Expiration Models for Subtypes of Activity-Based Currencies**<br>`rn_loyalty_mixed_expiration_subtypes` | **`Activity With Mixed Subcurrencies`** 만료 모델 — **부모 통화는 활동 기반 만료**를 쓰고 **서브타입은 고정 또는 활동 기반**을 각각 쓴다. **이전엔 모든 서브타입이 부모 통화의 만료 모델을 상속**했다. 이 통화들에 **traceability를 구성해 사용(redemption) 트랜잭션을 원 적립(accrual) 트랜잭션과 연결**할 수 있다. **Why(원문 설정 예시 전수):** 부모 통화 **Member Points** 를 `Activity with Mixed Subcurrencies` 로 생성 → 서브타입 **Reward Points** 는 부모의 활동 기반 만료 상속 → 서브타입 **Promotion Points** 와 **Partner Points** 는 고정 기간 만료. ⚠️ **How: 이 기능은 요청 기반으로만 제공된다 — *"This feature is available only on request. Contact your Salesforce account executive."*** **Where: [LOY]** |
| **Increase Engagement by Rewarding Members at Multiple Milestone Targets of an Activity**<br>`rn_loyalty_multiple_milestone_levels` | **engagement trail 프로모션**이 단일 활동의 진척을 추적해 여러 마일스톤 도달 시 보상. **easy · moderate · hard 최대 3개 목표**를 점증적으로 설정하고, ⚠️ **한 트랜잭션으로 여러 목표를 동시 충족하면 해당 마일스톤 보상을 모두 받는다.** 예측 모델로 회원별 개인화 목표 설정 가능. ⚠️ **Where: Enterprise·Performance·Unlimited·Developer + `Loyalty Management - Growth` 또는 `Loyalty Management - Advanced`**(기본 Loyalty Management로는 안 된다). **How:** **Engagement Trail 템플릿**으로 프로모션 생성 → **Configure Promotion Template 단계에서 `Single Activity Mode` 켜기** → 활동·목표·대응 보상 지정 |
| **Maximize Loyalty Promotion ROI with Predictive AI**<br>`rn_loyalty_promotions_predictive_ai` | **Salesforce Predictive AI 모델**로 개인 구매 패턴 기반 목표 설정. **원문 예시: 과거 평균 지출 $50 고객 → easy/moderate/hard = $60 / $75 / $90, $100 지출 고객 → $120 / $150 / $200.** **How:** 로열티 프로그램 페이지에서 **New Personalized Promotion** 클릭 → 가격 프로모션은 **What Customers Do 섹션**에서 값에 개인화 목표 선택 → Engagement Trail 템플릿의 Single Activity Mode에서는 **개인화 목표에 자동 매핑되는 목표를 추가** → 마지막으로 **`Promotion Party Usage` 레코드의 easy·moderate·hard 목표를 내장 Salesforce 예측 AI 모델로 채우거나 외부 모델 예측을 임포트**. **Where: [LOY]** |
| **Apply Discounts and Issue Rewards in a Single API Call**<br>`rn_loyalty_unified_execution` | **Unified Execution API** 로 할인 적용과 보상 발급을 **한 요청**에 처리 — **이전엔 Get Eligible Promotions API와 Transaction Journal API를 따로 호출**해야 했다. **Where: [LOY]** |
| **Analyze Loyalty Programs with More Tableau Next Dashboards**<br>`rn_loyalty_more_tableau_next_dashboards` | ⚠️ **이 대시보드들은 이전엔 CRM Analytics에서만 제공됐다.** **원문이 나열한 7개 대시보드 전수 — In-App 4종:** `Loyalty Member Services`(로열티 회원에게 제공한 지원 유형 인사이트) · `Team Performance`(지원한 회원 수·고객 만족도 등으로 팀 성과 추적) · `Program Manager Home`(회원 추세·트랜잭션·수익·부채로 프로그램 성과 모니터) · `Fraud Analytics`(적립·사용·적립 취소 포인트 인사이트로 **부정 의심 회원·트랜잭션 식별**). **Embedded 3종:** `Member Preferences`(비적격 포인트 사용 시 선호 파트너·제품) · `Member Services Manager Home`(서비스 담당자 성과) · `Member Summary`(회원 수정 인사이트 — **담당자별·트랜잭션별·적립 포인트별·사용 포인트별·포인트 조정 사유별·회원 랭킹별 필터**). **Where: [LOY]** |
| **Simplify Loyalty Widget Deployment with Lightning Out 2.0**<br>`rn_loyalty_simplify_widget_integration` | **자동 생성 HTML 스니펫**으로 외부 사이트·Experience Cloud 사이트에 위젯 임베드. **Lightning Out 2.0 기반**이라 디자인·콘텐츠·동작 변경이 **코드 재배포 없이 즉시 반영**된다. **이전엔 수동 임베드와 변경 시마다 재임베드가 필요했다.** **How:** **Widget Designer 페이지 → Embed** → 생성된 HTML을 사이트에 붙여넣기. **Where: [LOY]** |
| **Save Time with Incremental Data Kit Upgrades for Loyalty Management**<br>`rn_loyalty_upgrade_tiers_faster` | 데이터 킷이 **Starter → Growth → Advanced 순으로 누적**된다. **예: Growth 라이선스면 `Loyalty Management Starter` + `Loyalty Management Growth` 데이터 킷을 설치하고, 나중에 Advanced로 업그레이드하면 `Loyalty Management Advanced` 데이터 킷만 추가**해 추가 컴포넌트만 들어온다. ⚠️ **이전엔 Growth·Advanced 데이터 킷 설치가 하위 컴포넌트를 전부 재설치**했다. ⚠️ **Where: Enterprise·Performance·Unlimited·Developer + Loyalty Management **및 Data 360**** |
| **New and Changed Objects in Loyalty Management**<br>`rn_loyalty_new_and_changed_objects` | **변경 오브젝트만 있고 신규 오브젝트는 없다.** `LoyaltyLedger` — **`SourceIdentifier`**(원 프로세스·외부 시스템과 ledger 레코드 상관). `LoyaltyPgmCurrencySubtype` — **`ExpiryModel` · `ExpiryPeriod` · `ExpiryPeriodUnit` · `ExtendExpiration`**(사용 가능 통화 서브타입의 만료 타이밍 처리 방식). `LoyaltyLedgerTraceability` — **`LoyaltyAggrPointExprLedgerId`**(집계 포인트 만료 ledger 레코드와 연결). `LoyaltyAggrPointExprLedger` — **`HasMixedExprModelSubcurrencies`**(만료 모델이 혼합된 서브통화 보유 여부) · **`LoyaltyPgmCrcySubtypeId`** |

### Real-Time Offer Management (13건 전수)

**Where가 두 제품명으로 갈린다 — 원문 그대로.**

| 약칭 | 원문 Where |
|---|---|
| **[GPM]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Global Promotions Management**(일부 항목은 *"where Global Promotions Management is enabled"*) |
| **[RTOM]** | Lightning Experience · **Enterprise·Unlimited·Developer** + **Real-Time Offer Management**(Agentforce 항목은 **Agentforce도 활성**, WhatsApp/푸시 항목은 **Marketing Cloud Next도 활성**) |

**Global Promotions Management (`rn_rtom_gpm` 계열 7건)**

| 항목 | 내용 |
|---|---|
| **Create Promotions That Adapt to Each Customer's Purchase Behavior**<br>`rn_gpm_personalized_promotions` | 구매 패턴 기반 **고객별 지출 임계값** 설정(전체·카테고리·제품별). **Why — 개인화 목표를 쓸 수 있는 템플릿 범주 2가지:** ① **고객이 특정 제품을 구매할 때 보상하는 모든 템플릿**(예: `Buy X, Get Discount + Rewards`) ② **장바구니가 특정 금액일 때 보상하는 모든 템플릿**(예: `Spend X, Get Discount + Rewards`). **원문 예시:** 외부 예측 AI 모델을 쓰면 과거 지출 $50 고객은 **$60 / $75 / $90**, $100 고객은 **$120 / $150 / $200**. **How:** **Global Promotions Management Settings 화면에서 `Personalized Promotions` 켜기** → **New Personalized Promotion** → **Select Personalization Configuration 화면에서 `External Model` 선택** → 마법사 완료 → ⚠️ **`Promotion Party Usage` 레코드의 개인화 값 필드를 수동으로 채워야 한다**. **Where: [GPM]** |
| **Control How Promotions Stack by Using Custom Evaluation Groups**<br>`rn_gpm_promotion_group_subgroup` | 프로모션을 **커스텀 서브그룹**으로 조직하고 각 서브그룹에 **`First Promotion` · `Highest Discount` · `Stacked Evaluation`** 중 하나를 배정. ⚠️ **이전엔 같은 카테고리(예: 전 line-level 프로모션)가 하나의 평가 방식을 공유**해야 했다. **Where: [GPM]** |
| **Create Industry-Specific Promotions with Decision Tables and Custom Eligibility Rules**<br>`rn_gpm_decision_table_template` | 사전 정의된 리테일 템플릿 대신 **decision table**로 다중 입력 조건의 커스텀 로직을 정의해 보상을 자동 적용. **How:** Decision Table을 만들고 **Application Usage를 `Global Promotions Management` 로 선택** → 조건별 평가·보상 출력 정의 → **`Decision Table-Based Promotion` 템플릿을 선택해** 커스텀 프로모션 템플릿 생성. **런타임에 decision table이 규칙을 평가해 매칭 출력값을 카트 또는 제품 수준으로 GPM에 전달**한다. **Where: [GPM]** |
| **Validate Coupon Codes Before Customers Apply Them**<br>`rn_gpm_coupon_validation` | **신규 Coupon Validation API** 가 **쿠폰 존재 여부 · 활성 기간 · 사용 한도(redemption limit) · 카트 수준 적격성**을 적용 전에 빠르게 평가. **수동 입력 쿠폰 코드를 지원**해 복수 쿠폰 결제 경험을 개선한다. **Where: [GPM]** |
| **Apply Rewards to All Eligible Products or Categories in Buy X, Get Y Promotions**<br>`rn_gpm_eligible_products_category` | 보상을 하나씩 추가하는 대신 **All Eligible Products** 또는 **All Eligible Categories** 선택. ⚠️ **이전엔 Unit Price Discount 템플릿에서만 가능**했고, 이제 **line-level `Buy X, Get Y` 템플릿까지 확장**된다 — **단 `Promotion Evaluation and Execution` 이 꺼져 있을 때만.** **How:** 프로모션 마법사의 **What Customers Get 단계**에서 *All eligible products or categories* 선택. **Where: [GPM]** |
| **Give External Systems Access to Promotion Details with the Promotion Summary API**<br>`rn_gpm_promotion_summary` | 외부 시스템이 **GPM 콘솔을 열지 않고** 프로모션 규칙·적격 기준·구성 상세를 프로그래밍 방식으로 조회. **Where: [GPM]** |
| **New and Changed Objects in Global Promotions Management**<br>`rn_gpm_new_and_changed_object` | **변경 오브젝트만 있다** — `PromotionPartyUsage` 신규 필드 4종: **`PersonalizedTargetInformation`**(마일스톤 프로모션의 개인화 목표·보상 쌍 저장) · **`PersonalizedEasyTarget`**(1차 보상 tier) · **`PersonalizedModerateTarget`**(2차) · **`PersonalizedHardTarget`**(3차) |

**Offer Management (`rn_rtom_offers` 계열 6건)**

| 항목 | 내용 |
|---|---|
| **Create Offers and Promotions from Briefs with Agentforce**<br>`rn_offers_brief_agent` | 캠페인 브리프로부터 Agentforce가 **오디언스 · 적격 기준 · 보상 규칙 · 채널 treatment 를 포함해 프로모션·오퍼의 모든 요소를 초안 작성**한다. 생성 제안을 미리 보고 이해관계자와 조정한 뒤 최종 생성. ⚠️ **Where: Enterprise·Unlimited·Developer + Real-Time Offer Management **및 Agentforce** 활성** (원문에 *"This change applies to This change applies to…"* 중복 오타가 있다) |
| **Personalize SMS, Push Notifications, and WhatsApp Messages with Offer Treatments**<br>`rn_offers_whatsapp_and_push_notification` | **Offer Treatment Designer에서 한 번 구성**하면 SMS·푸시 알림·WhatsApp 메시지에 상세가 반영되고, ⚠️ **이후 offer treatment를 수정하면 모든 메시지가 그 값으로 자동 반영**된다. **Where: Enterprise·Unlimited·Developer + Real-Time Offer Management **및 Marketing Cloud Next** 활성** |
| **Show Personalized, Real-Time Offers in Your Mobile Apps**<br>`rn_offers_mobile_sdk_app` | **Mobile SDK**로 iOS·Android 앱을 RTOM API에 연결해 활성 세션 중 맞춤 프로모션 표시. ⚠️ **Where: 직접 만드는 커스텀 iOS·Android 모바일 앱에 적용된다. Real-Time Offer Management 자체는 Enterprise·Unlimited·Developer에서 제공.** **How:** **RTOM Mobile SDK를 iOS는 Swift Package, Android는 Gradle 의존성**으로 추가 → **connected app을 통해 조직에 인증** → Android·iOS `README.md` 지침에 따라 SDK를 호출해 개인화 오퍼 조회, 또는 **포함된 샘플 앱**으로 시작 |
| **Create and Manage Promotions and Offers from Your Experience Cloud Site**<br>`rn_offers_experience_cloud` | Experience Cloud 사이트 사용자에게 마케팅 매니저와 **동일한 가이드 경험** 제공. 저장하면 **Offer · Offer Treatment · Promotion 레코드 페이지**에 나타나 커뮤니티 사용자가 직접 추적·관리한다. ⚠️ **Where: Lightning Experience를 통해 접근하는 **Aura 및 LWR 사이트** · **Enterprise·Unlimited** 에디션 + **Real-Time Management***(원문 제품명 표기가 이 항목만 "Real-Time Management"이고 Developer 에디션이 없다) |
| **Find Data Kits Easily with the New Real-Time Offer Management Name**<br>`rn_offers_changed_datakit` | **`Global Promotions Management` 데이터 킷 → `Real-Time Offer Management`** 로 개명 — *"to better align with its underlying capabilities."* **이 데이터 킷은 GPM·Offer Management 오브젝트를 Data Cloud에 매핑**한다. ⚠️ **이름만 바뀌는 변경이다.** **Where: [RTOM]** |
| **New and Changed Objects in Offer Management**<br>`rn_offers_new_and_changed_objects` | **신규 `BriefSourceReference`**(브리프를 그 원본 오퍼·프로모션과 연결). **변경 `Brief`** — **`UsageType`**(브리프가 프로모션용인지 오퍼용인지) · **`RelatedBrief`**(관련 브리프 연결) · **`Status`** |

### ⭐ 대표 신기능
1. **Loyalty의 예측 AI 개인화 목표**($50 지출자 → $60/$75/$90) + engagement trail 3단계 마일스톤 — 단 **Growth·Advanced 라이선스 필요**.
2. **Custom Evaluation Groups** — 서브그룹별 stack 정책(First Promotion / Highest Discount / Stacked Evaluation).
3. **Agentforce로 캠페인 브리프 → 오퍼·프로모션 초안 자동 생성**(오디언스·적격 기준·보상 규칙·채널 treatment 전 요소).
4. **Loyalty·Referral 위젯의 Lightning Out 2.0 전환** — Widget Designer의 **Embed** 버튼이 생성한 HTML을 붙여넣으면 이후 변경은 재배포 없이 반영.
5. ⚠️ **Loyalty의 `Activity With Mixed Subcurrencies` 만료 모델은 계정 담당자 요청으로만 열린다.**

---

## 그 밖의 영역

Clouds 추출 배치에 함께 들어온, 특정 클라우드에 속하지 않는 영역들이다.

### Salesforce Suites (3건)

| 항목 | 내용 |
|---|---|
| **Agentforce Now Included in Free Suite**<br>`rn_suites_agentforce_in_free` | **Free Suite에 Agentforce 포함** — 평문 대화로 업무를 처리하고 핵심 인사이트를 확인한다. **Where: Lightning Experience · Free Suite. When: 2026년 8월.** **Why(원문 예시 전수):** *"Summarize the Acme account"* 라고 물으면 **Acme에 연결된 opportunity · 핵심 사실 · 최근 케이스** 등을 요약하고, *"Draft an email to the VP of Marketing of Acme about our upcoming meeting"* 라고 하면 **수신자 이메일 주소를 찾아 메시지를 작성하고 제목까지 생성**한다. ⚠️ **How: 조직에서 AI를 이미 켰다면 Agentforce가 자동으로 제공된다. 아직 켜지 않았다면 페이지 우상단의 Agentforce 로고를 눌러 패널을 열고 `Agree and Enable` 을 선택**해야 한다 |
| **Integrate Your External App Data with Salesforce Suites Using Prebuilt Integrations**<br>`rn_suites_integrate_external_app_data` | **MuleSoft와 Flow 기반 사전 구축 통합**으로 외부 앱을 직접 연결. **원문이 든 앱 예시: QuickBooks Online · Jira.** **양방향 자동 동기화** — 한쪽에서 바꾸면 다른 쪽에 즉시 반영된다. **Where: Lightning Experience · Starter Suite 및 Pro Suite**(Free Suite 제외). **When: 2026년 8월.** **How:** Starter·Pro Suite 조직에서 **Automations 앱 → Integrations 탭** → 가이드 마법사로 외부 계정에 안전하게 연결하고 템플릿 선택 |
| **Skip the Wait When Sending Emails to Contact and Lead Lists in Salesforce Suites**<br>`rn_suites_list_sends` | Contact·Lead 리스트로 프로모션·트랜잭션·관계형 이메일을 **추가 처리 단계 없이** 발송. ⚠️ **이전엔 리스트 발송에 Data 360 세그먼트 생성이 필요해 지연과 간헐적 발송 실패가 있었다** — 이제 **Actionable Lists가 Contact·Lead 리스트에서 직접 오디언스를 처리**한다. 재설계된 List Sends는 **오디언스·메시지 유형·저장 위치를 한 페이지**에 모은다. **Where: Lightning Experience · Free Suite · Starter Suite · Pro Suite. When: 8월 중순부터.** **How:** Marketing 앱 → Leads 또는 Contacts에서 필터 적용 → **Send Email**. ⚠️ **Free Suite에서는 이메일이 즉시 발송되고, Starter·Pro Suite에서는 예약 발송도 가능하다.** List Sends는 Marketing Home에서 접근 |

### Salesforce Scheduler (2건)

| 항목 | 내용 |
|---|---|
| **Create Salesforce Scheduler Agents in the New Agentforce Builder**<br>`rn_ls_create_scheduler_agents_in_agentforce_builder` | 새 Agentforce Builder가 **Salesforce Scheduler 에이전트**를 지원한다. 만든 에이전트는 **Agentforce Studio 앱과 Agentforce Agents Setup 페이지의 목록 뷰**에 나타나며 ⚠️ **어디서 실행하든 항상 Agentforce Builder에서 열린다**. **Where: Lightning Experience · Enterprise·Unlimited + Foundations 또는 Agentforce 1 에디션.** **How:** App Launcher → Agentforce Studio → **Agents → New Agent → `Salesforce Scheduler` 선택**해 첫 **Agent Script 기반 에이전트**를 만든다 |
| **Check Partner Calendar Availability Before Booking**<br>`rn_ls_check_partner_calendar_availability_before_booking` | Scheduler가 **파트너 사용자의 연결된 외부 캘린더**의 busy/free를 확인해 **실제 가능한 슬롯만** 고객에게 보여준다. ⚠️ **이전엔 파트너가 개인 도구로 일정을 관리해 Salesforce 밖에서 잡힌 회의를 예약 플로우가 반영하지 못했다.** ⚠️ **원문에 Where·Who·How가 없고 관련 항목으로 Partner Cloud의 `Track Partner Activity Across Customer Interactions` 를 가리킨다** — 실제 설정 절차는 그 항목 참조(아래 `### Partner Cloud` 절) |

### Partner Cloud (8건 전수)

랜딩 요약: **파트너 연결성 확대와 안전한 레코드 공유·동기화를 통한 데이터 투명성 향상**으로 사업 성장을 가속하고, **Experience Cloud 사이트 안에서 브랜드 규정을 준수하는 마케팅 콘텐츠**로 일관된 고객 경험을 제공한다.

**Where가 세 갈래다 — 원문 그대로.**

| 약칭 | 원문 Where |
|---|---|
| **[PC-SALES]** | Lightning Experience · **Enterprise·Performance·Unlimited** + **Sales** |
| **[PC-AF1]** | Lightning Experience(일부는 **및 Experience Cloud**) · **Enterprise·Performance·Unlimited·Agentforce 1 Sales** 에디션 |
| **[PC-EPUD]** | Lightning Experience · **Enterprise·Performance·Unlimited·Developer** |

#### Joint Business Plans

| 항목 | 내용 |
|---|---|
| **Automate Objective Management and Link Records for Joint Business Plans**<br>`rn_partner_cloud_automate_joint_business_plan_objectives` | joint business plan 목표에 **적격 레코드를 자동 연결·해제**한다. ⚠️ **백그라운드 잡이 24시간마다 또는 온디맨드로 적격 레코드를 갱신**한다. 목표 정의에 쓰는 표준 오브젝트: **Account · Opportunity Line Item · Order · Order Item.** **Where: [PC-SALES].** **How:** App Launcher → **Account Plans** → joint business plan 열기 → objective 생성 후 **calculation definition 선택**. ⚠️ **`Automatic Qualifying Record Management` 는 자동으로 활성화된다.** 저장 후 objective를 편집해 레코드를 수동으로 연결·해제할 수도 있다 |
| **Enable Partners to Create Joint Business Plans**<br>`rn_partner_cloud_partners_create_joint_business_plans` | 파트너가 **Joint Business Plan과 Account Plan을 생성·삭제**할 수 있다. Joint Business Plan 리스트 뷰가 **shared entity 기준으로 파트너 계정의 opportunity를 표시**한다. **Where: [PC-EPUD].** ⚠️ **Who: 생성·삭제에는 커스텀 권한 세트가 필요하다 — 표준 권한 세트는 읽기 전용 접근만 준다.** **How:** **`Account Plans With Partners` 권한 세트를 복제**해 파트너 사용자에게 objective·measure의 create·edit·delete 접근을 부여 |

#### 파트너 캘린더 (Einstein Activity Capture)

| 항목 | 내용 |
|---|---|
| **Track Partner Activity Across Customer Interactions**<br>`rn_partner_cloud_track_partner_customer_activity` | 고객이 파트너 사용자의 가용 시간을 보고 직접 미팅을 예약한다. 캘린더 연결로 채널 매니저가 **파트너의 고객 접촉 시점·빈도**를 파악하고 **지역 규제 준수**를 돕는다. ⚠️ **이전엔 파트너가 개인 도구로 일정을 관리해 채널 매니저가 추적할 수 없었다.** **Where: Enterprise·Performance·Unlimited·Agentforce 1 Sales 에디션**(원문에 *Lightning Experience* 문구 없음). ⚠️ **Who: 파트너 캘린더 연결에는 `PartnerEAC` 애드온 라이선스가 필요하다.** **How:** Partner Portal 사용자에게 **`Partner EAC User` 권한 세트** 배정 → Einstein Activity Capture에서 **모든 sync 옵션을 끄고 잠근 Partner EAC 구성** 생성 후 파트너 배정 → 파트너가 포털에서 Google Calendar 또는 Microsoft Office 365 계정 연결 → **EAC가 OAuth 토큰을 안전하게 저장하고 Salesforce Scheduler가 필요 시 가져와 가용성을 확인**한다 |
| **Book Appointments on Partner Calendars with Einstein Activity Capture**<br>`rn_partner_cloud_connect_partner_calendars` | 파트너의 **Google Calendar 또는 Microsoft 365** 캘린더를 EAC로 Salesforce에 연결하면 **Scheduler가 실시간 가용성을 확인해 파트너 캘린더에 직접 예약**한다. **파트너는 한 번만 인증하면 된다.** **Where: [PC-AF1].** **Who: `PartnerEAC` 애드온 라이선스 + 파트너 사용자에게 `Partner EAC User` 권한 세트.** **How:** 위 항목과 동일한 절차이되 **Partner EAC 구성에 파트너를 배정**한 뒤 파트너가 포털에서 캘린더를 연결 |

#### Partner Central 컴포넌트 · 마케팅 · 에이전트

| 항목 | 내용 |
|---|---|
| **Enhance Partner Experiences with Loyalty and PEM Components in Partner Central**<br>`rn_partner_cloud_loyalty_pem_components` | **Partner Central 템플릿**으로 만든 파트너 사이트에 Loyalty·Referral Management 컴포넌트를 추가. **Where: [PC-SALES].** **How:** Experience Builder에서 아래 컴포넌트를 배치. **원문이 나열한 8개 컴포넌트 전수:** **`Loyalty Program Details`**(프로그램 정보 — **적격 기준 · 리워드 tier · 포인트 적립 규칙 · 사용 옵션**) · **`Joint Business Plans Details`**(공유 목표 · 수익 타깃 · 마일스톤 · 전략) · **`Partner Referral Welcome Container`**(추천 링크로 들어온 파트너용 환영 경험 · 온보딩 맥락 · 다음 단계) · **`Tile Menu Wrapper`**(타일 메뉴의 레이아웃·간격·스타일 일관 정렬) · **`Points Summary`**(현재 포인트 잔액) · **`Benefits Table`**(포인트로 교환 가능한 혜택) · **`Active Promotions Catalogue`** · **`Transaction Ledger`**(로열티 거래 이력) |
| **Enhance Partner Experiences with PEM Components in Partner Central (Enhanced)**<br>`rn_partner_cloud_pem_components_enhanced` | **Partner Central (Enhanced) 템플릿** 사이트용 Partner Experience Manager 컴포넌트. ⚠️ **위 항목의 8개 중 4개만 제공된다: `Points Summary` · `Benefits Table` · `Active Promotions Catalogue` · `Transaction Ledger`.** **Where: [PC-SALES]** |
| **Discover and Enroll in Vendor Campaigns from Campaign Marketplace**<br>`rn_partner_cloud_campaign_marketplace` | 채널 마케팅 매니저가 **파트너 tier · 계정 속성 · 펀딩 예산**을 기준으로 캠페인을 파트너에게 공개한다. ⚠️ **등록하면 마케팅 자산을 상속한 자식 캠페인이 생성**되고, 파트너 담당자는 거기에 **리드를 추가하고 커스터마이즈한 자산 초안을 저장**한다. **Where: Lightning Experience **및 Experience Cloud** · [PC-AF1].** **How:** 기어 메뉴 → **Salesforce Go** → 기능 활성화 + **내부 사용자와 파트너 프로필에 필요한 권한 세트 그룹 배정** → Experience Builder에서 **Campaign Marketplace 컴포넌트**를 사이트 페이지에 추가 → 채널 마케팅 매니저가 파트너 대상 캠페인을 만들고 적격 기준 정의 |
| **Manage Marketing Development Funds with Agentforce Partner Success Agent**<br>`rn_partner_cloud_agentforce_mdf` | **임베디드 채팅 채널**로 예산 문의·자금 요청·클레임 처리를 24시간 지원. 파트너가 **예산 상세를 조회하고 가이드형 필드 작성으로 레코드를 생성**한다. **파트너가 만료 전에 가용 자금을 쓰도록 돕고 재무 감사용 일관 레코드를 만든다.** **Where: [PC-SALES].** **How:** 파트너가 파트너 에이전트로 **자금 잔액과 만료일을 확인**하거나 **가이드형 대화로 MDF 요청을 제출**한다 |

### AI Relationship Research (`rn_airr_ai_relationship_research` 허브 + 리프 2)

> 이 3건은 Winter '27 Clouds 페이지 목록에서 **상위 클라우드가 명시되지 않았다**(`rn_airr_*` 계열). 허브 정의: *"AI Relationship Research is an AI-powered feature that automatically discovers, analyzes, and presents relationship intelligence about the people and organizations connected to your Salesforce records."* — **CRM 레코드 · 공개 웹 콘텐츠 · Data 360을 동시에 스캔**해 **상위 랭킹 커넥션**을 워크플로 안에서 제시한다.

**Where 공통:** Lightning Experience · **Enterprise·Performance·Unlimited·Developer**.
⚠️ **Who 공통 — 조직 수준 전제 3가지:** **AI Relationship Research 라이선스** · **프로비저닝된 Data 360 조직** · **Einstein Generative AI 활성**. 그 위에 관리자에게 **`AI Relationship Research Admin`**, 최종 사용자에게 **`AI Relationship Research User`** 권한 세트를 배정한다.

| 항목 | 내용 |
|---|---|
| **Uncover More Relationships by Choosing Which CRM Objects to Search**<br>`rn_airr_crm_search_enhancements` | 템플릿이 **표준 오브젝트(Interaction Summary · Task · Email Message · Case)** 에 더해 **커스텀 CRM 오브젝트**를 검색하도록 구성한다. **How:** Setup → **AI Relationship Research** → 구성 생성 → **anchor 오브젝트**(예: Account) 선택 → **CRM 데이터 소스**를 선택하면 **소스 오브젝트 그리드**가 나타난다. 그리드는 오브젝트별 **검색 대상 필드 · anchor 오브젝트와의 관계 · 조직 내 현재 레코드 수**를 보여준다. ⚠️ **레코드 수로 성능 영향 가능성을 판단**해 검색 대상을 선택·해제한다. ⚠️ **커스텀 오브젝트를 넣으려면 구성에 추가하고 검색할 필드를 고른 뒤, anchor 오브젝트까지의 관계 경로를 "필드 라벨이 아니라 relationship name" 으로 입력**해야 한다 |
| **Flag and Fix Outdated Employer Data with Secondary Research Data Validation**<br>`rn_airr_post_research_validation` | 컨택·리드의 **현재 고용주가 CRM의 연결된 account와 일치하지 않으면 관계 그래프에 불일치를 플래그**한다. **How:** Setup → AI Relationship Research → **secondary research validation을 포함한 구성 생성** → **anchor 오브젝트로 Contact 또는 Lead 선택** → **CRM과 Web 데이터 소스 선택** → **`Employer Verification` 검증 규칙 활성화** → 검증이 켜진 AI Relationship Research 컴포넌트를 Contact·Lead 레코드 페이지에 추가. **런타임 동작:** 고용주 정보가 불일치하는 관계 그래프 노드에 **경고 아이콘**이 뜨고, 사용자가 노드를 선택해 불일치를 검토한 뒤 **`Review & Resolve`** 를 눌러 올바른 고용주 값을 고르고 갱신을 확정한다 |

### AgentExchange (5건 전수)

| 항목 | 내용 |
|---|---|
| **Install AgentExchange Apps Without Leaving Your Workflow**<br>`rn_agentexchange_track_app_installs` | **Agentforce Builder 안에서** 앱을 하나 또는 여러 개 동시 설치. **진행 스트립**이 각 설치 상태를 백그라운드로 추적하며 **도킹·확장·빌더 어디서나 확인** 가능하고, 설치 완료와 **액션·서브에이전트·에이전트 사용 준비 완료**를 알림으로 알려준다. ⚠️ **Where: Agentforce Builder의 무료 및 무료 체험(free-trial) AgentExchange 리스팅에 한하며, 비프로덕션 조직에서만 제공된다.** **Who: 앱 설치 권한이 있는 Agentforce Builder 사용자.** ⚠️ **원문에 pilot/beta 고지가 붙어 있다**(*"This feature is a pilot or beta service…"*). **How:** App Launcher → Agentforce Studio → 에이전트 열기 → 서브에이전트는 Explorer의 **`+`**, 액션은 서브에이전트 선택 후 **`+`** → **Add from Asset Library → Browse AgentExchange** → **Install App for All Users** |
| **Request App Installs and Updates From Your Admin (Beta)** 🔵Beta<br>`rn_agentexchange_request_app_install` | 설치 권한이 없으면 **비즈니스 정당화(business justification)** 와 함께 Agentforce Builder에서 직접 요청. **관리자가 이메일로 받아 설치 또는 반려**하고 어느 쪽이든 요청자에게 이메일로 통보된다. ⚠️ **Where: 위와 동일 — 무료·무료 체험 리스팅, 비프로덕션 조직.** **Who: 앱 설치 권한이 **없는** Agentforce Builder 사용자.** **Why(원문):** 이전엔 설치 권한이 없는 에이전트 빌더가 **관심 표시(mark interest)만 하고 퍼블리셔의 후속 연락을 기다리는 것 외에 방법이 없었고 상태나 사내 담당자를 알 수 없었다.** **How:** 위와 같은 경로로 리스팅을 열고 **Send Request** |
| **Identify FDE Partner Network Consultants on AgentExchange**<br>`rn_identify_fde_partner_network_consultants_on_agentexchange` | **Forward Deployed Engineering(FDE) Partner Network** 소속 컨설팅 파트너를 리스팅에서 확인. FDE 배지는 Salesforce가 **Agentforce 구현 역량을 인정한 파트너**를 표시하며 **리스팅 상세 헤더와 provider achievements 섹션**에 나타난다. **Where: AgentExchange의 컨설팅 파트너 리스팅** |
| **View the FDE Badge on Your AgentExchange Listing** *(파트너 측)*<br>`rn_show_the_fde_badge_on_your_agentexchange_listing` | **FDE Partner Network 지위에 도달하면 리스팅에 배지가 나타난다.** ⚠️ **원문 명시: 배지는 구성하는 것이 아니다**(*"You don't configure the FDE badge."*). **Where: AgentExchange의 컨설팅 파트너 리스팅** |
| **Identify Trialforce Email-Sending Domains That Need Verification** *(파트너 측)*<br>`rn_appexchange_trialforce_identify_domain_verification` | **Branded Email Sets 설정의 신규 `Verified Email Domain` 필드** 사용. 아웃바운드 이메일 보안 강화로 **Trialforce branded email set에 연결된 발신 도메인을 검증해야** 한다. ⚠️ **기한: 기존 email set이 있으면 2026-11-10 전에 도메인을 검증**해야 커스텀 브랜드 주소로 시스템 환영 메일을 계속 보낼 수 있다. ⚠️ **미검증 시 결과: 기존 email set이 `orgId@sf-customer-mail.com` 과 유사한 대체 주소로 발송하게 되며, 도메인을 검증할 때까지 그 대체 주소를 계속 쓴다.** **이미 DKIM 키 또는 authorized email domain을 설정했다면 관련 email set은 자동 검증되어 추가 조치가 필요 없다.** **Where: Salesforce Classic의 Trialforce branded email set — Trialforce branded email set은 Developer Edition에서 제공된다.** **How:** **Trialforce management org(TMO)** 의 Setup → Quick Find **Branding** → **Email Sets** → 게시된 email set 목록에서 **Verified Email Domain 컬럼** 확인 → 체크되지 않은 항목의 발신 도메인을 **DKIM 키 생성 또는 authorized email domain 설정**으로 검증 |

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
