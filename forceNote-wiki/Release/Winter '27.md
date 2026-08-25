---
tags: [release, winter_27]
api_version: v68.0
release_date: 2026-10
created: 2026-08-25
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2)
aliases: [Winter '27, 윈터 27, v68, v68.0, Salesforce Winter 27]
---

# Winter '27 릴리즈 노트

> API v68.0 | 출시: 2026년 10월 — **현재 프리뷰 상태**
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

> [!warning] 이 릴리즈는 **프리뷰(preview)** 다 — 기능이 확정되지 않았다
> 릴리즈 노트 본문이 스스로 *"This release is in preview"* 라고 밝힌다. **Salesforce가 GA를 발표하기 전까지 여기 적힌 기능·수치·시점은 확정이 아니며**, 프리뷰 기간 중 페이지가 추가·수정·철회된다. 실제 사례가 이미 여러 건 확인됐다 — Metadata API·Tooling API 카탈로그가 2026-08-17 주에 **추가**됐고, *Set the Window Size for a Screen Flow Quick Action* 은 같은 주에 *"아직 준비되지 않았다"* 며 **철회**됐으며, Tooling API 헤더 페이지는 본문이 문자 그대로 `TBD` 인 **플레이스홀더**로 게시돼 있다.
> → 이 릴리즈를 근거로 일정을 세우려면 10월 GA 시점에 재확인한다. 재확인 지점 목록은 [[Winter '27/Development]]의 *10월 GA 시점 재확인 목록* 참조.

---

## 하위 노트 (spoke)

영역별 하위 노트로 분할했다. 이 허브는 라우팅·하이라이트·커버리지만 담고, 도메인별 전수·코드·표는 하위 노트에 있다.

| 하위 노트 | 범위 | 분량 |
|---|---|---|
| [[Winter '27/Development]] | Apex · LWC · API · 개발 도구 — GA/Beta/Developer Preview 전수 + New & Changed 카탈로그(ConnectApi 포함) + 거버너 한도 | 1,461줄 |
| [[Winter '27/Platform]] | Security · Automation/Flow · Hyperforce · Mobile · Experience Cloud · CMS · Contracts · Pricing | 679줄 |
| [[Winter '27/Clouds]] | Sales · Revenue · Service · **Agentforce IT Service** · Field Service · Commerce · Marketing · Analytics · Data 360 · Industries — **영역 988페이지 전수** | 3,260줄 |
| [[Winter '27/Agentforce]] | Agentforce & Generative AI (**추출 35페이지 기준 — 잔여 15리프, 아래 주의**) | 544줄 |
| [[Winter '27/Release Updates]] | 강제 적용 항목 · 시점 맵 — **강제 시점의 단일 정본** | 334줄 |

> 폴더 안에서 파일 목록으로 훑으려면 → [[Winter '27/index|폴더 인덱스]]

> [!note] Agentforce 스포크는 **영역 전체가 아니다**
> [[Winter '27/Agentforce]]는 **추출된 35페이지**(최초 31 + Einstein Work Summaries 리프 4)를 근거로 하며, **영역 자체는 최소 59페이지**다. 그 노트의 "GA 0건 · Release Update 0건 · 신규 모델 0건"은 전부 **35페이지 범위 안에서의 진술**이지 영역 전체의 결론이 아니다. **"Winter '27엔 AI 변경이 거의 없다"고 읽으면 안 된다.**
> **잔여 미추출은 15리프다** — `rn_afcc_voice` 3건(AFCC Voice)과 `rn_ai_agents_sa` 12건(Agentforce Service Assistant 월별 릴리즈). 이 15건은 위키 어디에도 본문이 없고 등급·날짜·Where/Who/How가 미확인이다.
> ⚠️ **한때 이 목록의 최대 항목이던 `rn_agentforce_it` 9축은 더 이상 공백이 아니다.** 9개 하위 축과 그 아래 리프를 합친 **51페이지 전문이 [[Winter '27/Clouds]]의 `## Agentforce IT Service` 절**에 실려 있다 — Service Management · IT Asset Management · IT Compliance · Self-Service · Broadcast and Notifications · Collaboration Channels · Discovery for CMDB & Service Graph · AI for IT Teams and Employees · CMDB and Service Graph. **Agentforce IT Service 기능 상세·에디션·활성화 전제의 단일 출처는 그 절이다.**

---

## 커버리지 — 이 위키가 어디까지 담았나

릴리즈 노트 카탈로그 **1,241 페이지 전부가 본문 수준으로 담겨 있다.** **제목만 남은 계층은 이제 없다** — 한때 "722페이지는 Clouds 제목 카탈로그"였던 부분은 후속 추출로 전량 본문 확보됐고, [[Winter '27/Clouds]]의 `## 제목 카탈로그` 절 자체가 삭제됐다. 여기에 카탈로그 밖에서 뒤늦게 확보한 **8페이지**(Development의 ConnectApi 카탈로그 4 + Agentforce의 Work Summaries 리프 4)를 더해, 실제 본문 확보량은 **1,249 페이지**다.

| 영역 | 본문까지 확보 | 근거 (스포크의 자체 진술) |
|---|---|---|
| Development | **66** 페이지 (릴리즈 노트 62 + ConnectApi 카탈로그 4) | [[Winter '27/Development]] "소스와 신뢰도" 표 |
| Platform | **140** 페이지 (리프 + 허브) | [[Winter '27/Platform]] 개요 |
| Clouds | **988 / 988** 페이지 — **영역 전수** | [[Winter '27/Clouds]] "이 노트의 커버리지" — `Tier 상세` 단일 행 |
| Agentforce | **35** 페이지 (최초 31 + Work Summaries 리프 4) | [[Winter '27/Agentforce]] 개요 — 영역 자체는 **최소 59페이지, 잔여 15리프** |
| Release Updates | `rn_ru` 버킷 전수 | [[Winter '27/Release Updates]] — 강제 항목 전수 |
| **합계** | **카탈로그 1,241 전부 + 후속 8 = 1,249 페이지** | **"제목만" 계층 0건** |

> **읽는 법.** **"여기 없다 = 없다"가 이제 Clouds에도 적용된다.** 988페이지 전부의 본문을 봤기 때문에, Clouds에 등급 마커가 없는 항목은 *"몰라서 비어 있다"* 가 아니라 *"원문에 마커가 없다"* 는 확정 사실이다. (다만 **마커 없음을 GA로 읽지는 않는다** — 그 판단은 Clouds 스포크가 명시적으로 유보한다.)
>
> 남은 공백은 정확히 두 곳뿐이다.
> - **Clouds 4페이지는 본문이 앞부분만 확보**됐다 — `rn_feature_impact`(전 제품 활성화 방식 매트릭스) · Field Service 월별 패치 노트 2건 · `rn_communications_cloud`(잘린 부분은 월별 change log stub). **네 건 모두 기능 페이지가 아니며**, 개별 기능의 Where·How·Who·When은 각 리프에서 이미 확보돼 있다. 실질 공백은 "활성화 방식 4분류"뿐이다.
> - **Agentforce 영역의 15리프**(AFCC Voice 3 · Service Assistant 월별 12)는 미추출이다 → 위 주의 박스 참조.

---

## ⭐ 주요 신기능

- **Apex heap 한도 인상** — 동기 6 MB → **10 MB**, 비동기 12 MB → **25 MB**. Winter '27 비프로덕션 org에 한해 구 한도로 되돌리는 임시 설정이 있고, Spring '27부터 전역 강제 → [[Winter '27/Development]]
- **Apex Symbol API (Beta)** — Tooling REST `/services/data/vXX.X/tooling/symbols/`. 내장·커스텀·패키지·동적 Apex 타입의 상세 메타데이터를 반환하는 **v68.0 신설 리소스**로, IDE 코드 완성과 AI 에이전트 그라운딩이 용도다 (org당 동시 1건) → [[Winter '27/Development]]
- **Batch 잡 Elastic Limits (Beta)** — elastic limits가 future·Queueable에 이어 **Batch 잡**까지 확대. 프로덕션 추가 용량 캡은 1,000만 → **min(라이선스 한도, 200만)** 으로 축소 → [[Winter '27/Development]]
- **Apex Integration Tests (Developer Preview)** — External Services·HTTP 콜아웃을 대상으로 하는 통합 테스트(비동기 1건, 동기 실행 미제공) → [[Winter '27/Development]]
- **LWC API 68.0은 버전별 변경이 없다** — 릴리즈 노트가 직접 *"기존 컴포넌트를 일괄 업그레이드하기 좋은 릴리즈"* 라고 안내한다. 커스텀 컴포넌트 API 버전 상향의 적기 → [[Winter '27/Development]]
- **LWC 복합 템플릿 표현식 GA · 서드파티 웹 컴포넌트 `lwc:external` GA** — 템플릿에서 복합 JS 표현식 사용(해당 컴포넌트 `apiVersion` **66.0 이상** 필요), 서드파티 웹 컴포넌트를 재작성 없이 통합 → [[Winter '27/Development]]
- **SOQL 필드 간 비교 `FORMULA()` (Beta)** — `WHERE` 절에서 산술 계산으로 필드끼리 비교. **샌드박스·Developer Edition·스크래치 org 전용이며 프로덕션 미제공** → [[Winter '27/Development]]
- **Flow Builder 전면 개편** — Cosmos 테마, 조밀한 캔버스, **Edit History**(저장 타임라인·복원), 요소 **그룹화**, **Flow Tags** 분류, 자동 생성 라벨, 키보드 내비게이션 → [[Winter '27/Platform]]
- **Flow Test Mode (Beta) · Mock Outputs (Beta)** — 전용 테스트 모드에서 시나리오 저장·다중 실행·assertion·커버리지, Action/Subflow의 mock output으로 콜아웃 없이 격리 테스트 → [[Winter '27/Platform]]
- **`User Context–Enforces User Permissions` 실행 컨텍스트** — 무엇이 호출하든 항상 실행 사용자 권한으로 동작(API 68.0 이상 플로우에만 적용). 기존에는 system context 호출자의 상승 권한을 상속했다 → [[Winter '27/Platform]]
- **Connected App → External Client App 전면 이행** — Salesforce가 connected app 지원을 종료한다(동작은 유지되나 버그 수정·통합 지원 없음). 마이그레이션 도구가 **패키징된(1GP·2GP) / 배포된 connected app**까지 처리하며, 고객의 OAuth 플로·토큰·세션은 업그레이드를 거쳐도 유효 → [[Winter '27/Platform]]
- **Experience Delivery (Beta) for LWR 단종** — **2026년 10월부로 중단**. 사이트를 재게시하면 자동으로 표준 LWR 인프라로 마이그레이션되고, 재게시하지 않으면 계속 이용은 되지만 성능이 저하될 수 있다 → [[Winter '27/Platform]]
- **Gemini 2.5 → 3.5 리라우트** — **2026-10-20**부터 Gemini 2.5 Pro/Flash/Flash-Lite 요청이 Gemini 3.5 Pro/Flash/Flash-Lite로 리라우트된다 → [[Winter '27/Agentforce]]

### 롱테일 전수에서 뒤늦게 드러난 등급 항목

초판 하이라이트는 Clouds 롱테일이 제목만 있던 시점에 쓰였다. 988페이지 본문을 전부 확인한 뒤 **초판이 "없다"고 결론지었던 등급**이 실제로 나왔다. 전수 목록은 [[Winter '27/Clouds]]의 *등급 마커 일람* 절이 정본이다.

- **SLDS 2 Styling API + 컴포넌트 레벨 훅 (Developer Preview)** — `rn_slds_c_level_hooks`. 이 릴리즈의 Developer Preview가 Apex Integration Tests 하나뿐인 줄 알았으나 **두 번째 항목**이 있었다. ⚠️ 다만 **리프 본문은 아직 어느 스포크에도 없다** — Clouds가 등급·page id만 기록하고 Platform 소관으로 위임 표기했고, [[Winter '27/Platform]]은 SLDS를 [[Winter '27/Development]] 소관으로 넘겼는데 그 노트에도 항목이 없다. 현재 확인 가능한 전부는 등급과 page id다 → [[Winter '27/Clouds]]
- **Pilot 3건** — ① **Track Supplier Risk Across Your Multi-Tier Supply Chain** (`rn_supply_chain_resiliency_pilot`, Industries Common Features — Setup 토글이 아니라 **account executive 요청으로만 활성화**) ② **Omniscript·Flexcard를 LWR Experience Cloud 사이트에 추가** ③ **Omnistudio Assistance AI Agent**. ②③은 Public Sector 랜딩의 공통 기능 요약에만 등장하고 **독립 page id가 없어 Where·How가 확보되지 않았다** → [[Winter '27/Clouds]]
- **Release Update — Update Apex Code and Flows for Changed Sharing Recalculation Behavior** (`rn_sharing_apex_recalc`) — 그룹·역할(role)의 **대규모 업데이트 후 일부 sharing 재계산이 비동기로** 수행된다. share 레코드가 **즉시** 갱신됐다고 가정하는 Apex 클래스·테스트·트리거·Flow는 강제 시 깨질 수 있다. **강제 시점은 [[Winter '27/Release Updates]]가 정본이며 이 허브는 날짜를 적지 않는다** (Winter '27 강제 5건에는 포함되지 않는다)

---

## 구조 변화 — Platform 섹션이 6개 영역을 흡수했다

릴리즈 노트 루트 랜딩 페이지가 *"Changes to the Release Notes"* 에서 직접 밝힌다.

> "We consolidated sections so that Platform includes release notes for **Customization, Deployment, Development, Experience Cloud, and Mobile & Salesforce CMS**."
> — Winter '27 릴리즈 노트 루트 랜딩 페이지 원문

즉 이전 릴리즈에서 최상위 섹션이던 **여섯 영역**(Customization · Deployment · Development · Experience Cloud · Mobile · Salesforce CMS)이 Platform 안으로 들어왔다. **없어진 게 아니라 위치가 바뀐 것**이므로, 목차에서 Customization·Deployment가 보이지 않아도 Platform 트리 안에서 찾는다. 개발 도구 쪽에서는 Salesforce CLI · Agentforce Vibes · Agentforce Vibes IDE가 **Headless 360** 섹션으로 이동했다.

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (Winter '27 섹션 재편을 이 위키의 spoke로 매핑한 도식)
이전 릴리즈 최상위 섹션            Winter '27 위치            이 위키의 spoke
──────────────────────────────────────────────────────────────────────────────
Customization ─┐
Deployment ────┤
Development ───┼──► Platform 섹션 ──► 정책·설정·인프라 → [[Winter '27/Platform]]
Experience Cloud ┤                    코드·API·CLI     → [[Winter '27/Development]]
Mobile ─────────┤
Salesforce CMS ─┘
Salesforce CLI · Agentforce Vibes (IDE) ──► Headless 360 → [[Winter '27/Development]]
```

> 이 위키의 spoke 분할선은 릴리즈 노트 섹션이 아니라 **독자의 관점**을 따른다 — 정책·설정·인프라는 Platform, 코드·클래스·API·CLI는 Development. 그래서 릴리즈 노트에서 Platform 섹션에 있는 Apex·API·Lightning Components 항목도 이 위키에서는 [[Winter '27/Development]]에 있다.

---

## 파괴적 변경 / 강제 적용 (요지)

> 전체 표·시점 맵·조치 체크리스트는 → [[Winter '27/Release Updates]] (**강제 시점의 단일 정본** — 이 허브는 날짜를 다시 적지 않는다)

**Winter '27에 강제 적용되는 항목은 정확히 5건**이며, 성격상 **인증·권한 2건 + 접근성(WCAG 2.2 Resize and Reflow) 3건**으로 나뉜다.

- 인증·권한 ① **Enable Profile Filtering**
- 인증·권한 ② **SOAP `login()` 호출에 Use Any API Auth 권한 요구**
- 접근성 ① 페이지 헤더 · 모달 창 (200% 초과 확대)
- 접근성 ② 날짜 선택기 · 팝오버 · 하단 유틸리티 바 · 레코드 헤더
- 접근성 ③ 카드 · 도킹 컨테이너 · 메뉴 리스트 · 패널

그 밖에 **하드 날짜 강제 2건**, **Spring '27 강제 예정 10건**(OAuth 플로 은퇴 2건 포함), **Summer '27 강제 예정 3건**, **취소 1건**이 있다. 각 항목의 강제 시점·Test Run 절차·개발자 조치 목록은 전부 [[Winter '27/Release Updates]]에 있다.

```text
// 구조 예시 — 실제 동작 코드 아님 (Release Update 확인 경로 — 날짜는 Release Updates 스포크가 정본)
Setup → Quick Find: "Release Updates"
  → 항목 선택 → [Get Started] 에서 영향·조치 확인
  → [Test Run] 으로 강제 전 영향 검증
  → "Complete Steps By" 이전에 조치 완료
```

---

## 섹션별 하이라이트

| 도메인 | 하이라이트 (1줄) | 상세 |
|---|---|---|
| Apex | heap 10/25 MB, Batch Elastic Limits(Beta), Apex Integration Tests(Developer Preview), 관리 패키지 SOQL `explicitNamespace` | [[Winter '27/Development]] |
| LWC · Aura | API 68.0 **버전별 변경 없음**(일괄 업그레이드 적기), 복합 템플릿 표현식·`lwc:external` GA | [[Winter '27/Development]] |
| API · 툴링 | Apex Symbol API(Beta), 무효 클래스만 재컴파일 `apexCompileResults`, Test Discovery `testLevel`, REST `latest` 버전 지정 | [[Winter '27/Development]] |
| 개발 도구 | CLI 자격 증명 출력 제거, 비동기 Apex 스캐폴딩 템플릿, DX MCP Server(Beta), ApexGuru 중복 코드 탐지 GA | [[Winter '27/Development]] |
| Flow · Automation | Flow Builder 개편(Cosmos·Edit History·그룹·Tags), Test Mode·Mock Outputs(Beta), 저장 시점 검증, 동적 배치 크기 | [[Winter '27/Platform]] |
| Security · Identity | Connected App 지원 종료 예고, Tenant-Specific Trust Store(조직당 50개), custom CA named credential, Security Health Review 리포트 뷰어 | [[Winter '27/Platform]] |
| Hyperforce · 인프라 | 18개국 가용, **GCP 상 Hyperforce 예고**(미국·2026년 11월), Edge Network 라우팅 셀프서비스, Government Cloud 샌드박스 Quick Create/Clone | [[Winter '27/Platform]] |
| Experience Cloud · Mobile · CMS | Experience Delivery(Beta) 단종, Stable Target Host Name, Agentforce Voice for Employee Agents GA, CMS Brand 콘텐츠 타입·일괄 삭제 | [[Winter '27/Platform]] |
| Contracts · Pricing · Knowledge | Document Playbooks·AI redline 분석, ramp deal 복리 인상·주간 proration, Knowledge Blocks | [[Winter '27/Platform]] |
| Agentforce · Einstein | Gemini 2.5→3.5 리라우트, Agentforce Voice 3건, Salesforce Voice의 AFCC 편입, Work Summaries for Case(Beta) 은퇴 | [[Winter '27/Agentforce]] |
| Sales · Revenue | Sales Cloud→**Agentforce Sales** 리브랜드, 라인 아이템 **15,000건** 대형 트랜잭션, Promotions 신규, Advanced Approval Delegation | [[Winter '27/Clouds]] |
| Service · Field Service | Contact Center 2제품 분리, Service Assistant 동적 서비스 플랜, Workforce Management 21건, 다일 서비스 약속 예약·최적화 | [[Winter '27/Clouds]] |
| Agentforce IT Service | **51페이지 전문**(허브 9 + 리프 42, 9개 축). ⚠️ 신규 조직에서 Incident의 레거시 **Assigned User 필드가 숨김 + API 접근 불가** → Incident Owner로 이행. Assigned Group은 이제 **공개 그룹만** 받는다(큐 불가). 51페이지 전체에 등급 마커 0건 | [[Winter '27/Clouds]] |
| Commerce · Marketing | 구독 커머스 6종·결제 수단 확대, Marketing Goals/Content Agent 신규, RCS 대폭 확장 | [[Winter '27/Clouds]] |
| Analytics · Data 360 · Industries | CRM Analytics Recycle Bin GA, Data 360 Engagement Timeline, Insurance Design Advisor, Omnistudio Clean Metadata Deployment | [[Winter '27/Clouds]] |

---

## 연관 패턴 노트 업데이트 필요

> 이 릴리즈로 인해 수정이 필요한 기존 노트 (릴리즈 콘텐츠가 아닌 후속 작업 목록). 체크된 항목은 v68.0 공식 PDF·치트시트로 이미 반영됐고, 각 노트를 직접 열어 확인했다.

- [x] [[Governor Limits]] — heap 10/25 MB, Elastic Limits 캡·비프로덕션 override 수치 반영 완료 (노트에 *Winter '27 한도 변경 — before / after* 절 존재)
- [x] [[Tooling API — 개요·REST·SOAP 호출 기초]] — Apex Symbol API(`/tooling/symbols/`)·`apexCompileResults` 리소스 반영 완료
- [x] [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 같은 pass에서 v68.0 기준 보완 완료 (*v68.0 신규 REST 리소스* 절)
- [x] **Metadata Types 세트** — `Winter27-v68-Docs/api_meta.pdf` v68.0 대조 반영 완료: [[Metadata Types — 개요 및 분류]](v68.0 변경 판정 기록) · [[Metadata Types — Apex & Code]](`DebugLevel` 신규) · [[Metadata Types — Automation]](Flow 서브타입 신규) · [[Metadata Types — Integration & Platform]](`CurrencySettings` 서브타입) · [[Metadata Types — Security & Access]](`PermissionSetLicenseDefinition` Developer Preview → GA) · [[Metadata Types — UI & Layout]](`UIBundle` Beta → GA)
- [x] [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — `Winter27-v68-Docs/salesforce_app_limits_cheatsheet.pdf`(2026-08-14 판) 대조 완료. ⚠️ 그 판에 `Version 68.0, Winter '27` 문자열이 없어 노트가 **"v68 기준"이라 부르지 않고 "8/14 판 기준"으로만 표기**한다
- [ ] [[LWC API 버전 관리]] — API 68.0 버전별 변경 없음(일괄 업그레이드 권고) 반영
- [ ] [[LWC 템플릿 기초 (데이터 바인딩·표현식)]] — 복합 템플릿 표현식 GA(`apiVersion` 66.0 이상 전제) 추가
- [ ] [[SOQL 문법 레퍼런스]] — `FORMULA()` (Beta, 비프로덕션 전용) 추가
- [ ] [[Batch Apex]] · [[Queueable]] — Batch 잡 Elastic Limits(Beta)와 초과 시 스로틀·동시 1개 제한 반영
- [ ] [[테스트 전략]] — Apex Integration Tests(Developer Preview), Test Discovery `testLevel` 반영
- [ ] [[Apex 버전별 동작 변경 레퍼런스]] — API 9.0–19.0 컴파일러 경고, v68.0 플로우 versioned update 추가
- [ ] [[Flow Tests (플로우 테스트)]] — Test Mode(Beta)·Mock Outputs(Beta)를 기존 Flow Test 위에 얹히는 별개 UI 모드로 정리
- [ ] [[Flow 네이밍 컨벤션]] — Flow Tags 분류 계층 추가 (네이밍의 보완 계층)
- [ ] [[Flow 에러 처리]] — 저장 시점 검증(필드 길이·필수 필드), 레코드 잠금 자동 재시도, 동적 배치 크기 반영
- [ ] [[Flow 설계 베스트 프랙티스]] — `User Context–Enforces User Permissions` 실행 컨텍스트 선택 기준 추가
- [ ] [[Connected App (연결된 앱) — OAuth 클라이언트]] · [[External Client App (외부 클라이언트 앱)]] — 지원 종료 예고와 패키징·배포 앱 마이그레이션 도구 반영
- [ ] [[Named Credential]] · [[Certificate and Key Management (인증서·키 관리)]] — custom CA 인증서 지원, Tenant-Specific Trust Store(조직당 50개·PEM/DER) 추가
- [ ] [[Setup Audit Trail (설정 감사 추적)]] — View Setup Audit Trail 전용 권한 분리 반영
- [ ] [[My Domain (마이 도메인)]] — Edge Network 라우팅 셀프서비스 설정, Stable Target Host Name 추가
- [ ] [[Experience Cloud 개요]] — Experience Delivery(Beta) 단종과 재게시 권고 반영
- [ ] [[System Namespace]] — 새 `Limits` 메서드 반영

---

## 관련 노트

- [[Release MOC]] — 릴리즈 노트 전체 지도
- [[Winter '27/Development]] · [[Winter '27/Platform]] · [[Winter '27/Clouds]] · [[Winter '27/Agentforce]] · [[Winter '27/Release Updates]] — 이 릴리즈의 5개 spoke
- [[Summer '26]] — 이전 릴리즈 (v67.0)
- [[Winter '26]] — 직전 Winter 릴리즈 (v65.0)
