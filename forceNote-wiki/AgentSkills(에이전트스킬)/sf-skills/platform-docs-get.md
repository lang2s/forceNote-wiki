---
tags: [agent-skill, sf-skills, platform, documentation, retrieval]
source: forcedotcom/sf-skills (skills/platform-docs-get/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-docs-get, 공식 문서 검색, Salesforce docs retrieval, help.salesforce.com 추출, developer.salesforce.com, 문서 grounding]
---

# platform-docs-get — 공식 Salesforce 문서 검색

> 공식 Salesforce 문서(developer/help/architect/admin/lightningdesignsystem)를 신뢰성 있게 retrieval하여 답변을 ground. JS-heavy·shell-rendered 페이지 처리 playbook.

---

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER when:** 사용자가 공식 Salesforce 문서, Apex/API 레퍼런스, LWC 문서, Agentforce 문서, setup/help 아티클, 또는 Salesforce 소유 도메인의 문서를 요청할 때.

**DO NOT TRIGGER:** 코드 변경, 배포 작업, 문서 retrieval이 필요 없는 작업 — 적절한 `sf-*` 스킬 사용.

### Scope
| | |
|---|---|
| **In scope** | 공식 Salesforce 문서 retrieval: Apex·API·LWC·metadata·Agentforce·setup 아티클·SLDS·architect/admin guidance |
| **Out of scope** | 서드파티 블로그, PDF fallback, 로컬 corpus 인덱싱, benchmark 워크플로, 코드/메타데이터 생성 |

### Required Inputs
fetch 전 식별: 요청된 정확한 concept/identifier/class/method/feature 이름 · 가능성 높은 doc family(developer/help/design system/architect·admin).

### Official Sources Only
`developer.salesforce.com` · `help.salesforce.com` · `architect.salesforce.com` · `admin.salesforce.com` · `lightningdesignsystem.com` 등 Salesforce 소유 문서 우선. 명시 요청 없는 한 서드파티 블로그·영상·요약 회피. **PDF로 fallback 하지 않는다.**

---

## 워크플로 / 단계

### 1. 요청 분류 먼저
fetch 전 doc family 식별.
| Family | Typical Source | Use For |
|---|---|---|
| Developer docs | `developer.salesforce.com/docs/...` | Apex·API·LWC·metadata·Agentforce dev 문서 |
| Help docs | `help.salesforce.com/...` | setup·admin·product 구성 |
| Architect/Admin | `architect.salesforce.com/...`, `admin.salesforce.com/...` | best practice·패턴·well-architected·admin enablement |
| Design system | `lightningdesignsystem.com/...` | SLDS·Cosmos·design token·컴포넌트/스타일링 |
| Legacy atlas | `developer.salesforce.com/docs/atlas.en-us.*` | 구 공식 guide·reference |

### 2. 정확한 concept 식별
검색 전 실제 target 추출: 정확한 API/class/method명 · feature명 · product phrase · setup concept. 예: `Lightning Message Service`, `Wire Service`, `System.StubProvider`, `Agentforce Actions`.

### 3. 타겟된 공식 retrieval 선호 (broad-crawl 금지)
① 가장 가능성 높은 공식 guide root/article 식별 → ② 검색 필요 시 공식 Salesforce 도메인으로만 제한 → ③ 페이지 fetch → ④ **정확한 concept이 실제로 페이지에 나타나는지** 확인 → ⑤ 없으면 관련 공식 child link 1–3개 추적 → ⑥ grounded 증거 확보 시 중단.

### 4. broad landing 페이지에서 멈추지 않기
guide landing 페이지는 정확한 concept을 명확히 포함하지 않는 한 불충분. LWC·Agentforce·broad platform homepage·help landing에서 특히 중요.

### 5. `developer.salesforce.com` playbook
likely guide root 시작 → JS-heavy면 browser-rendered 추출 선호 → concept 존재 확인 → 없으면 child link 1–3개 추적 → broad root보다 exact concept 페이지 선호 → legacy atlas도 진짜 공식 reference면 유효.

### 6. `help.salesforce.com` playbook
naive fetch 자주 실패. 가능 시 `articleView?id=...` URL 선호 → shell content면 browser-rendered 추출 → `Loading`·`Sorry to interrupt`·`CSS Error`·chrome/nav 텍스트는 **failed extraction**으로 취급 → 진짜 article body 탐색 → shell·soft-404("We looked high and low but couldn't find that page") 거부 → 추출 계속 실패 시 찾은 최선의 공식 Help URL 반환 + article-body 추출 실패 명시.

### 추출 스크립트 (선택 — `playwright` 필요)
```bash
# 모든 공식 Salesforce doc URL fetch (help.salesforce.com은 전용 추출기로 자동 라우팅)
python scripts/extract_salesforce_doc.py <url>

# help.salesforce.com articleView URL 직접 타겟
python scripts/extract_help_salesforce.py <articleView-url>
```

---

## 핵심 규칙·가드레일

### Acceptance Rules
다음 중 하나가 참일 때만 답변 가능: 정확한 identifier가 페이지에 나타남 · 정확한 concept phrase가 나타남 · 여러 query-specific phrase가 올바른 공식 컨텍스트에 나타남.
다음일 때 불충분: broad landing 페이지만 · 실 article 텍스트 적은 shell · 잘못된 product area · 요청 identifier/concept 미포함.

### Rejection Rules (최종 증거로 거부)
- exact concept 없는 broad guide homepage
- concept/reference 페이지가 기대될 때의 release note
- developer 문서 요청 시 admin 블로그
- 공식 문서 가용 시 서드파티 블로그
- 실 article body 없는 shell-rendered 페이지
- 제목은 맞지만 body에 요청 concept 없는 페이지

### Grounding / Output Requirements
답변 시 포함: ① guide/article 제목 ② 정확한 공식 URL ③ source type(developer doc / atlas reference / help article) ④ 추출이 partial·browser-rendered면 caveat. 증거 약하면 plainly 명시.

### Non-Goals
로컬 문서 corpus 유지 ✗ · 로컬 인덱스 의존 ✗ · PDF fallback ✗ · benchmark 워크플로 ✗ · repo-specific 스크립트 의존 ✗.

### Examples (요약)
- **Lightning Message Service:** LWC guide root에서 멈추지 말고 정확한 LMS 페이지/child link 추적.
- **Wire Service:** LWC homepage에서 답하지 말고 wire adapter child 문서 추적.
- **Agentforce Actions:** broad landing·블로그 회피, 공식 Agentforce dev actions 페이지.
- **System.StubProvider:** identifier가 나타나는 공식 reference/dev 페이지 선호, broader Apex landing으로 대체 금지.

---

## 번들 파일

`scripts/`:
- `extract_salesforce_doc.py` — 모든 공식 Salesforce doc URL fetch; `help.salesforce.com`은 전용 Help 추출기로 자동 라우팅, 모든 Salesforce 소유 host에 browser-rendered 추출 지원
- `extract_help_salesforce.py` — `help.salesforce.com` `articleView` URL 직접 타겟용
- `runtime_bootstrap.py` — 추출 스크립트가 import; 격리 Python 런타임·Playwright 브라우저 경로 resolve (직접 호출 안 함)

`requirements.txt` — Python 의존성(`playwright`, `playwright-stealth`)

`README.md` · `SKILL.md`

---

## 관련 노트
- [[platform-soql-query]]
- [[platform-apex-generate]]
