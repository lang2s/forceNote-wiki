---
tags: [agent-skill, sf-skills, experience, cms, brand, mcp]
source: forcedotcom/sf-skills (skills/experience-cms-brand-apply/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-cms-brand-apply, CMS 브랜드 적용, brand voice tone 적용, search_brands get_brand_instructions, sfdc_cms__brand, 브랜드 가이드라인]
---

# experience-cms-brand-apply — CMS 브랜드 적용 (voice·tone·스타일 가이드라인)

> Salesforce CMS에 저장된 기존 브랜드 가이드라인(voice, tone, style, color, typography)을 검색·추출해 생성 콘텐츠에 적용하는 스킬. 브랜드 지침을 먼저 가져온 뒤에 콘텐츠를 생성한다.

## 목적과 활성화 조건

**활성화:** branding, brand voice/tone, brand guidelines, brand identity/styling, 또는 브랜드를 콘텐츠에 적용하는 요청. "apply my brand", "use our brand voice", "match our brand guidelines", "find my brand", "get brand instructions", "apply brand tone" 등. 전체 워크플로(Salesforce CMS에서 brand 검색 → brand instruction 추출 → voice/tone/guideline을 생성 콘텐츠에 적용) 처리.

**사용 안 함:** 미디어/이미지 검색(→ [[experience-content-media-search]]), 로고 검색, 새 brand 정의 생성, CMS에서 brand 정의 편집, 로고/시각 brand asset 생성.

**Scope:** 이 스킬은 **CMS의 기존 brand 가이드라인을 생성 콘텐츠에 적용**하기 위한 것이다.

## 시작 전 — CRITICAL

**브랜드 지침은 어떤 brand를 생성/수정하기 전에 반드시 먼저 가져와야 한다.** 사용자가 branded 콘텐츠를 요청하면:

1. 사용 가능한 brand 검색(brand가 아직 식별 안 됐으면)
2. 선택된 brand의 brand instruction 추출
3. 생성하는 모든 콘텐츠에 brand 가이드라인 적용

**콘텐츠를 먼저 생성하고 나중에 branding을 retrofit하지 않는다.** brand instruction이 처음부터 콘텐츠 생성을 inform해야 한다.

## 워크플로 / 단계

```
CMS Branding Progress:
- [ ] Step 1: brand가 이미 식별됐는지 검색이 필요한지 판단
- [ ] Step 2: (필요 시) brand 검색하고 사용자에게 옵션 제시
- [ ] Step 3: 선택된 brand의 brand instruction 추출
```

### Step 1: Brand Context 판단

사용자가 쓸 brand를 이미 지정했는지 확인:
- **Brand 알려짐**(사용자가 이름 댔거나 brand가 하나뿐) → Step 3로
- **Brand 모름**("apply my brand"만 하고 미지정) → Step 2로

### Step 2: Brand 검색 — `search_brands`

1. **search query 결정** — 사용자 description·회사명·일반 keyword
2. **request 구성:**

```json
{
  "inputs": [{
    "searchQuery": "keyword or brand name"
  }]
}
```

3. `search_brands` 호출
4. **response 파싱** — brand 결과 추출:
   - `managedContentId` — unique ID (Step 3 추출에 사용)
   - `managedContentKey` — content key 식별자
   - `title` — brand 표시 이름
   - `contentUrl` — brand 콘텐츠 URL
   - `totalResults` — 찾은 brand 수

**결과 제시:**
- **여러 brand** → `ask_followup_question`으로 옵션 제시: "I found [N] brands in your CMS. Which one should I apply?" 후 번호 목록.
- **하나** → 확인: "I found the brand "[Brand Title]". Should I apply this brand's guidelines to the content?"
- **없음** → CMS에 brand 생성(Content Type: `sfdc_cms__brand`) 또는 가이드라인 직접 제공 안내, branding 없이 진행 vs 수동 제공 질문.

**확인 없이 brand auto-select 금지.** 항상 사용자 선택 대기.

### Step 3: Brand Instruction 추출 — `get_brand_instructions`

1. `get_brand_instructions` 호출 — branding 추출 prompt template을 가져옴
2. **response 파싱:** `promptBody` — 추출·적용 규칙 포함 full brand instruction prompt
3. **`promptBody`의 지침을 따름** — template은 brand 콘텐츠에서 brand property 추출 방법, brand voice/tone 규칙, typography·color 가이드라인, 콘텐츠 포매팅 규칙, guardrail·restriction에 대한 구체 가이드 포함.

**Brand instruction이 포함하는 것(전형적):**

| Property | Description |
|---|---|
| Brand Voice | brand가 말하는 방식(professional, friendly, authoritative 등) |
| Brand Tone | 커뮤니케이션의 감정적 quality(confident, warm, empathetic 등) |
| Key Messages | core messaging pillar·value proposition |
| Content Rules | 콘텐츠 생성 do·don't |
| Style Guidelines | typography, color, spacing 선호 |
| Guardrails | 언어·주제·주장에 대한 hard restriction |

## 핵심 규칙·가드레일

1. **Brand first, content second** — 콘텐츠 생성 전 항상 brand instruction 추출.
2. **brand 가이드라인 추정 금지** — CMS에서 명시적으로 retrieve한 것만 적용.
3. **guardrail 절대 준수** — brand content 규칙은 hard constraint(제안 아님).
4. **brand 선택 확인** — 확인 없이 auto-select 금지.
5. **show your work** — 어떤 가이드라인을 어떻게 적용했는지 사용자에게 알림.
6. **graceful degradation** — 도구 불가 시 branding 없이 진행하지 말고 수동 가이드라인 요청.

### Error Handling

| Error | Response |
|---|---|
| `search_brands` unavailable | "Brand search is unavailable. Please provide your brand name or guidelines directly." |
| `get_brand_instructions` unavailable | "Cannot retrieve brand instructions. Please share your brand guidelines in this conversation and I'll apply them manually." |
| Org lacks Vibes branding | "CMS branding is not enabled for this org. Contact your admin to enable the Agentforce Vibes branding feature." |
| Permission denied | "You don't have permission to access CMS brands. Ensure you have Managed Content Authoring permission." |
| Brand extraction returns empty | "The brand exists but has no configured guidelines. Please add brand properties in CMS or provide guidelines here." |

**silent fail 금지.** 항상 사용자에게 알리고 대안 제시.

## 번들 파일

추가 번들 파일 없음 — 단일 `SKILL.md`. `get_brand_instructions` 및/또는 `search_brands` MCP 도구 필요.

## 관련 노트
- [[experience-content-media-search]]
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-agentforce-client-generate]]
