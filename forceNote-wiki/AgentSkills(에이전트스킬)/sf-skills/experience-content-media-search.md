---
tags: [agent-skill, sf-skills, experience, cms, media-search, mcp]
source: forcedotcom/sf-skills (skills/experience-content-media-search/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-content-media-search, CMS 미디어 검색, 이미지 로고 검색, search_media_cms_channels search_electronic_media, Data 360 hybrid search, 라우팅 스킬]
---

# experience-content-media-search — CMS 미디어 검색 (이미지·로고·그래픽 라우팅)

> Salesforce CMS·Data 360 등에서 기존 시각 미디어(이미지·로고·아이콘·배너·hero·배경)를 검색·조회하는 라우팅 스킬. 사용자가 검색 소스를 먼저 선택하게 한 뒤에만 검색 도구를 호출한다.

## 목적과 활성화 조건

**활성화(PRIORITY·FIRST):** 미디어를 찾기/검색/가져오기/조회/locate하는 모든 요청. "search for logo", "find hero image", "get company logo", "fetch background image" 등. 미디어 검색/조회가 언급되면 이후 미디어로 무엇을 하든 **최우선·최초**로 활성화. **`search_media_cms_channels`·`search_electronic_media` 도구를 직접 호출하지 말 것 — 항상 이 스킬을 먼저 거친다.**

**사용 안 함:** brand 검색(→ [[experience-cms-brand-apply]]), AI로 새 이미지 생성, 그래픽/디자인 새로 만들기, 기존 이미지 편집.

## 워크플로 / 단계

**이것은 라우팅 스킬이지 직접 검색 스킬이 아니다.** 사용자가 검색 소스를 반드시 선택해야 하며 이 단계를 건너뛸 수 없다.

```
Media Search Progress:
- [ ] Step 1: 사용 가능한 검색 도구를 자신의 tool list에서 확인 (도구 호출 없음 — 컨텍스트만 inspect)
- [ ] Step 2: 사용 가능한 옵션만 번호 매긴 목록으로 제시 (plain text, 도구 호출 없음)
- [ ] Step 3: 사용자의 선택 응답 대기
- [ ] Step 4: 선택된 검색 방법 실행 (이것이 첫 도구 호출)
- [ ] Step 5: 모든 결과를 사용자에게 제시해 선택
- [ ] Step 6: 선택된 이미지를 코드에 적용
```

Step 4 전에 도구를 호출하면 이 스킬을 올바르게 따르지 않은 것이다.

### Step 1: 자신의 tool list 확인 (도구 호출 없음)

**MCP descriptor를 읽거나 외부 요청으로 가용 도구를 판단하지 않는다.** 도구는 이미 컨텍스트에 로드되어 있다 — 이름을 inspect(introspection)한다.

- `search_media_cms_channels` 있으면 → **"Search using keywords"** 포함
- `search_electronic_media` 있으면 → **"Search using Data 360 hybrid search"** 포함
- 항상 마지막 옵션으로 **"Other"** 포함

**하지 말 것:** 사용자가 소스 고르기 전 어떤 도구든 호출, "어떤 MCP 도구 있는지 확인", `search_electronic_media`/`search_media_cms_channels` 즉시 호출, MCP descriptor/schema 읽기, 묻지 않고 소스 결정.

**할 것:** text만으로 응답(검색 소스 번호 목록), "Which option would you like to use?" 질문, 사용자 응답 대기, 그 후에만 도구 호출.

**이 스킬이 트리거되면 첫 응답은 반드시 검색 소스를 제시하는 text-only 메시지여야 한다. 도구 호출 없음. 예외 없음.**

### Step 2: 응답 구성 (예시)

실제 보유한 소스만 포함, 순차 번호.

```
I can help you find that image. Where would you like to search?

1. Search using Data 360 hybrid search — Semantic search across Salesforce CMS and connected DAMs
2. Search using keywords — Search Salesforce CMS by keywords and taxonomies
3. Other — Provide your own URL or path

Which option would you like to use?
```

도구가 하나뿐이면 그 옵션 + Other만. 둘 다 없으면: "No automated media search sources are currently configured. Please provide a direct URL or asset library path." 제시 후 **사용자 선택 대기.**

### Step 4: 선택된 검색 방법 실행

⚠️ 사용자가 번호 목록에서 명시적으로 옵션을 선택한 경우에만 이 단계 도달.

#### Search using keywords — `search_media_cms_channels`

1. query 분석 (subject, attribute, domain)
2. **keyword 추출** — 이미지 메타데이터에 나올 concrete noun. domain별 synonym, 최대 10개. 예: "luxury apartments" → apartment, villa, penthouse, residence, condo. "bright room" → (concrete noun 없으면 empty)
3. **taxonomy 추출** — descriptive quality/style/mood/category. 형용사·attribute만. 예: "luxury apartment with river view" → Luxury, Premium, Waterfront, Riverside, Panoramic. "car" → (descriptive term 없으면 empty)
4. **locale 결정** — `en_US`, `es_MX`, `fr_FR` (default `en_US`)
5. **JSON payload 구성** — 정확히 이 구조:

```json
{
  "inputs": [{
    "searchKeyword": "keyword1 OR keyword2 OR keyword3",
    "taxonomyExpression": "{\"OR\": [\"Taxonomy1\", \"Taxonomy2\"]}",
    "searchLanguage": "en_US",
    "channelIds": "",
    "channelType": "PublicUnauthenticated",
    "contentTypeFqn": "sfdc_cms__image",
    "pageOffset": 0,
    "searchLimit": 5
  }]
}
```

**Field 규칙:**
- `searchKeyword`: keyword를 ` OR `(space-OR-space)로 join. keyword 없으면 empty string.
- `taxonomyExpression`: `{"OR": ["term1", "term2"]}` JSON 객체 stringify. taxonomy 없으면 `"{}"`.
- `searchLanguage`: underscore locale(예: `en_US`)
- `channelIds`: 항상 empty string
- `channelType`: 항상 `"PublicUnauthenticated"`
- `contentTypeFqn`: 항상 `"sfdc_cms__image"`
- `pageOffset`: `0`에서 시작, pagination 시 `searchLimit`만큼 증가
- `searchLimit`: default `5`, 사용자가 더 요청하면 조정

6. 정확한 JSON payload로 도구 호출.

#### Search using Data 360 hybrid search — `search_electronic_media`

1. 사용자 query를 **as-is** 사용 — keyword 추출/변환 불필요
2. `search_electronic_media` 호출
3. query를 도구의 `searchQuery` 파라미터로 전달. 예: `search_electronic_media(searchQuery="modern luxury apartment with natural lighting")`

#### Other (사용자 제공 URL)

직접 URL, asset library 경로, 확인할 특정 시스템/위치를 사용자에게 요청.

### Step 5: 검색 결과 제시

**`ask_followup_question` 도구로 결과를 선택지로 제시.** tool response 파싱(image 결과의 title·source 추출) → ALL 결과를 선택 가능 옵션으로(title만, URL 표시 안 함) → 사용자 선택 수신 → 선택 이미지 적용.

```
I found 4 images. Which one would you like to use?

1. Luxury Apartment Exterior
   Source: Salesforce CMS
2. Modern High-Rise Building
   Source: Salesforce CMS
3. Waterfront Residence
   Source: Salesforce CMS
4. Premium Condominium
   Source: Salesforce CMS
```

**이미지 auto-select 금지.** 항상 사용자 선택 대기.

### Step 6: 선택된 이미지 적용

1. image 이름·URL로 선택 확인
2. **도구가 반환한 완전한 URL을 모든 query parameter 포함해 사용.** CMS·DAM URL은 인증·resize·CDN routing에 query parameter를 의존 — 빼면 이미지가 깨진다. 예: `https://cms.example.com/media/img.jpg?oid=00D&refid=0EM&v=2`를 전체 사용.
3. URL을 코드/컴포넌트에 적용
4. 변경 내용 표시(file path·line number)

## 핵심 규칙·가드레일

- 첫 응답은 항상 text-only — 도구 호출 없이 검색 소스 제시. MCP descriptor/schema 읽기 금지.
- 보유한 소스만 제시(introspection, 도구 호출 아님). `search_media_cms_channels`/`search_electronic_media` 직접 호출 금지 — 항상 이 스킬 경유.
- 소스·이미지 auto-select 금지, 사용자 선택 대기. 모든 결과 표시.
- keyword 검색 payload field 고정값 준수(channelType `PublicUnauthenticated`, contentTypeFqn `sfdc_cms__image`, channelIds empty).
- 적용 시 query parameter 포함 완전 URL 사용. silent fail 금지 — 에러 시 대안 제시.

### Error Handling

| Error | Response |
|---|---|
| Tool unavailable | "The [source name] tool is unavailable. Would you like to try a different source?" |
| Tool returns error | 에러 메시지 표시, 다른 용어/소스로 retry 제안 |
| No results found | "No results found. Try broader keywords, removing descriptive terms, or a different source." |
| Invalid user selection | 옵션 재표시 후 재질문 |

### Search Behavior Notes

- **keywords:** keyword+taxonomy → keyword OR (keyword+taxonomy) 매칭; empty keyword → taxonomy only; empty taxonomy → keyword only; `pageOffset`로 pagination(`searchLimit`만큼 증가).
- **Data 360 hybrid:** 자연어 query 처리, semantic 유사도 매칭, 다중 연결 시스템 검색.

## 번들 파일

추가 번들 파일 없음 — 단일 `SKILL.md`. `search_media_cms_channels` 및/또는 `search_electronic_media` MCP 도구 필요.

## 관련 노트
- [[experience-cms-brand-apply]]
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-file-upload-generate]]
