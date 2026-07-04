---
tags: [agent-skill, sf-skills, commerce, b2b, storefront]
source: forcedotcom/sf-skills (skills/commerce-b2b-store-create/SKILL.md, 공식 Salesforce); help.salesforce.com experience.networks_enable.htm · commerce.comm_intro.htm · commerce.comm_create_store_on_site.htm (Tier 2, 전제조건·에디션 제약)
created: 2026-06-26
aliases: [commerce-b2b-store-create, B2B 커머스 스토어 생성, B2B Commerce Store, Storefront 메타데이터 retrieve, DigitalExperienceBundle]
---

# commerce-b2b-store-create — B2B 커머스 스토어 생성 스킬

> Commerce B2B 스토어를 org에 생성하고 자동 생성된 storefront 메타데이터를 리포지토리로 retrieve하는 대화형(interactive) 워크플로 스킬.

---

## 목적과 활성화 조건

Commerce B2B는 **Store(백엔드 데이터) + Storefront(프런트엔드 메타데이터)** 두 부분으로 구성된다. **Store를 먼저 org에 생성**해야 Storefront가 자동 생성되며, storefront 메타데이터를 수동으로 만들면 안 된다.

다음 요청에서 트리거된다:
- "Create a B2B Commerce store"
- "Build a Commerce storefront"
- "Set up Commerce B2B"
- "Create B2B Commerce"
- "Retrieve Commerce storefront metadata"
- "Deploy B2B storefront"

**호환성(compatibility):** Commerce 라이선스, Experience Cloud, Salesforce CLI 필요.

---

## ⚠️ 전제조건 (Store 마법사 실행 전 필수)

Setup → Commerce → Stores 마법사(Step 2)가 **나타나기 전에** 두 개의 선행 활성화 토글을 켜야 한다. 이걸 켜지 않으면 마법사 자체가 보이지 않아 스킬이 진행되지 않는다.

1. **Digital Experiences 활성화** — Setup → Digital Experiences → Settings → **Enable Digital Experiences** (도메인 설정 포함).
2. **Commerce 활성화** — Setup → Commerce → Settings → **Enable Commerce** → **Launch Commerce**.

**에디션 하드 제약:** B2B Commerce는 **Developer · Enterprise · Unlimited** 에디션에서만 지원된다. 그 외 에디션에서는 아예 막혀 Store를 생성할 수 없다.

> 근거: help.salesforce.com — Enable Digital Experiences(experience.networks_enable.htm), Enable Commerce → Launch Commerce(commerce.comm_intro.htm, comm_create_store_on_site.htm).

---

## 워크플로 / 단계

7단계 대화형 워크플로. 각 단계는 다음 단계로 넘어가기 전 사용자 확인이 필요하다.

1. **Step 1 — Commerce B2B 개념 설명:** Store(데이터) + Storefront(메타데이터) 구조를 설명하고 Store가 먼저 생성돼야 함을 알린다.
2. **Step 2 — 사용자에게 B2B Store 생성 안내:** Setup → Commerce → Stores (또는 App Launcher → Commerce → Create Store)에서 마법사로 WebStore 레코드, 기본 buyer group / entitlement policy, 연관 Digital Experience(LWR site)를 생성하게 안내. 완료 후 사용한 store 이름을 묻는다.
3. **Step 3 — 사용자 확인 수신:** 사용자 확인과 store 이름을 받고, 이름 형식(공백은 underscore로 표시)을 검증한다.
4. **Step 4 — 사용 가능한 LWR 사이트 나열:** 아래 CLI로 사이트 목록을 받아 번호 매긴 리스트로 표시.
5. **Step 5 — 사용자가 storefront 선택:** B2B Store에 해당하는 사이트를 사용자에게 선택받고 검증.
6. **Step 6 — Storefront 메타데이터 retrieve:** 선택한 사이트의 DigitalExperienceBundle을 retrieve.
7. **Step 7 — 다음 단계 안내:** 커스텀 LWC/브랜딩 커스터마이즈, 배포 명령 제공.

Step 4 — LWR 사이트 나열 (verbatim):

```bash
sf org list metadata --metadata-type DigitalExperienceConfig --json
```

```
Available Digital Experience sites:
1. My_B2B_Store1
2. Partner_Portal
3. Customer_Community
```

Step 6 — Storefront 메타데이터 retrieve (verbatim):

```bash
sf project retrieve start -m DigitalExperienceBundle:site/<selected-store-name> --json
```

```
Retrieved: force-app/main/default/digitalExperiences/site/My_B2B_Store1/
├── My_B2B_Store1.digitalExperience-meta.xml
├── sfdc_cms__view/ (home, current_cart, detail_*, list_*, etc.)
├── sfdc_cms__site/
├── sfdc_cms__route/
└── [other sfdc_cms__* directories]
```

Step 7 — 배포 (verbatim):

```bash
sf project deploy start --source-dir force-app/main/default/digitalExperiences/site/My_B2B_Store1/ --json
```

---

## 핵심 규칙·가드레일

SKILL.md "Rules That Always Apply" 전체:

1. **Always follow the interactive flow.** 단계를 건너뛰지 않는다. 각 단계는 진행 전 사용자 확인이 필요하다.
2. **Never create storefront metadata manually.** Commerce 설정 마법사가 수백 개의 구성 값을 생성하므로 수동 생성은 실패한다.
3. **Always list sites before retrieval.** Store 이름은 underscore와 숫자 접미사가 붙는다 (예: "My B2B Store" → "My_B2B_Store1"). 실제 목록에서 사용자가 선택하게 한다.
4. **Always use `--json` flag.** 파싱 가능한 출력을 위해 모든 Salesforce CLI 명령에 `--json`을 포함한다.

**Store vs Storefront 핵심 (references/store-vs-storefront.md):**

| 구분 | Store (백엔드 데이터) | Storefront (프런트엔드 메타데이터) |
|---|---|---|
| 정체 | org의 런타임 데이터/설정 | Digital Experience (LWR site) |
| 소스 컨트롤 | ❌ 메타데이터 아님, 소스 컨트롤 불가 | ✅ ExperienceBundle 메타데이터로 가능 |
| 생성 방법 | Commerce 앱 UI (Setup → Commerce → Stores) | Store 생성 시 자동 생성 |
| 대표 객체/경로 | `WebStore`, `BuyerGroup`, `EntitlementPolicy`, `ProductCatalog`, `Pricebook2` | `force-app/main/default/digitalExperiences/site/<name>/` |
| Metadata API | ❌ SObject 데이터라 배포 불가 | ✅ retrieve/deploy 가능 |

**Storefront를 처음부터 만들 수 없는 이유:** 복잡한 의존성 체인, 수백 개의 자동 생성 구성(컴포넌트 ID·region ID UUID 등), Commerce 관리형 컴포넌트(PLP/PDP/Cart/Checkout/Search), Metadata API는 SObject 데이터(WebStore 레코드)를 생성할 수 없음.

**핵심 순서:** Store first (creates storefront) → Retrieve → Customize. Store 생성을 절대 건너뛰지 말고, Storefront 메타데이터를 절대 처음부터 만들지 않는다.

---

## 번들 파일

- `SKILL.md` — 스킬 정의 (7단계 워크플로, 규칙)
- `references/store-vs-storefront.md` — Store vs Storefront 기술 레퍼런스 (소스 컨트롤, 수동 생성이 실패하는 이유)

---

## 관련 노트

- [[commerce-b2b-open-code-components-integrate]]
