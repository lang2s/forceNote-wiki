---
tags: [agent-skill, sf-skills, diagram, mermaid, erd]
source: forcedotcom/sf-skills (skills/external-diagram-mermaid-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [external-diagram-mermaid-generate, Mermaid 다이어그램 생성, Salesforce 텍스트 다이어그램, ERD sequence flowchart, ASCII fallback 다이어그램]
---

# external-diagram-mermaid-generate — Salesforce Mermaid 다이어그램 생성 스킬

> Salesforce 아키텍처·OAuth 플로우·ERD·통합 시퀀스·Agentforce 구조를 위한 **텍스트 기반(Mermaid + ASCII fallback)** 다이어그램을 생성하는 스킬.

---

## 목적과 활성화 조건

사용자가 **텍스트 기반 다이어그램**을 원할 때 사용: 아키텍처·OAuth·통합 플로우·ERD·Agentforce 구조의 Mermaid 다이어그램, 그리고 plain-text 호환이 필요할 때의 ASCII fallback.

**TRIGGER:** "diagram", "visualize", "ERD", 또는 sequence diagram / flowchart / class diagram / 아키텍처 시각화 요청.

**DO NOT TRIGGER:** PNG/SVG 이미지 출력을 원할 때(→ external-diagram-visual-generate), 또는 non-Salesforce 시스템만 다룰 때.

**In Scope:** Mermaid 출력, ASCII fallback, markdown 친화 형식의 architecture/sequence/flowchart/ERD 뷰, docs·README·issue에 바로 들어갈 다이어그램.

**Out of Scope (위임):** 렌더된 PNG/SVG·정교한 mockup → external-diagram-visual-generate. non-Salesforce 시스템 → 범용 다이어그래밍 스킬. ERD 전 객체 발견 → platform-custom-object-generate / platform-custom-field-generate.

**호환성:** Mermaid 렌더러가 있어야 다이어그램 미리보기 가능.

---

## 워크플로 / 단계

먼저 수집할 컨텍스트: 다이어그램 타입, 범위와 엔티티/시스템, 출력 선호(Mermaid only / ASCII only / both), 스타일(minimal / documentation-first / presentation-friendly), ERD의 경우 org 메타데이터 grounding 가능 여부.

**Recommended Workflow:**
1. **올바른 다이어그램 구조 선택** — 시간 순 상호작용은 `sequenceDiagram`, ERD·capability map은 `flowchart LR`. 가능하면 다이어그램당 하나의 주요 스토리.
2. **데이터 수집** — 실제 스키마 발견이 필요하면 platform-custom-object-generate / platform-custom-field-generate 사용. count/relationship 컨텍스트는 로컬 메타데이터 헬퍼 스크립트 활용.
3. **Mermaid 먼저 생성** — 정확한 라벨, 단순하고 읽기 쉬운 노드 텍스트, 일관된 관계 표기, markdown 뷰어에서 깔끔히 렌더되는 절제된 스타일.
4. **유용할 때 ASCII fallback 추가** — 터미널 호환·plaintext 문서가 필요할 때.
5. **다이어그램 간단 설명** — 핵심 관계, 흐름 방향, 가정.

**Supported Diagram Families:**

| Type | Preferred Mermaid form | Typical use |
|---|---|---|
| OAuth / auth flows | `sequenceDiagram` | Authorization Code, JWT, PKCE, Device Flow |
| ERD / data model | `flowchart LR` | object relationships and sharing context |
| integration sequence | `sequenceDiagram` | request/response or event choreography |
| system landscape | `flowchart` | high-level architecture |
| role / access hierarchy | `flowchart` | users, profiles, permissions |
| Agentforce behavior map | `flowchart` | agent → topic → action relationships |

**Output Format (SKILL.md verbatim):**

````markdown
## <Diagram Title>

### Mermaid Diagram
```mermaid
<diagram>
```

### ASCII Fallback
```text
<ascii>
```

### Notes
- <key point>
- <assumption or limitation>
````

---

## 핵심 규칙·가드레일

**High-Signal Rules:**
- *Sequence diagrams* — 단계 순서가 중요하면 `autonumber` 사용, 요청 vs 응답 명확히 구분, protocol 세부는 notes를 절제해서 사용.
- *ERDs* — `flowchart LR` 선호, object 카드 단순하게, 명확한 관계 화살표, 사용자가 명시적으로 요청하지 않으면 field overload 회피, 가독성을 높일 때만 object 타입 색상 코딩.
- *ASCII output* — width 적정, 화살표/박스 정렬 일관, 장식보다 가독성 최적화.

**Gotchas:**

| Issue | Resolution |
|---|---|
| Mermaid 렌더러 없음 | ASCII fallback 자동 제공. Mermaid 블록은 복붙용으로 그대로 유지 |
| ERD가 객체 과다로 가독성 저하 | 도메인별(Sales, Service 등) 서브 다이어그램으로 분할 후 prose로 링크 |
| Sequence 단계 순서 불명확 | `autonumber` directive로 순서 명시 |
| OAuth 플로우 actor가 grant type별로 다름 | 생성 전 관련 asset 템플릿을 먼저 읽어 actor 불일치 방지 |

**Cross-Skill Integration:** 실제 object/field 정의 → platform-custom-object/field-generate. 렌더 이미지 출력 → external-diagram-visual-generate. connected-app auth 컨텍스트 → integration-connectivity-connected-app-configure. Agentforce 로직 시각화 → agentforce-generate. Flow 동작 다이어그램 → automation-flow-generate.

**Score Guide:** 72–80 production-ready / 60–71 minor polish / 48–59 functional / 35–47 needs structural improvement / <35 inaccurate.

---

## 번들 파일

**Conventions & 레퍼런스** — `references/diagram-conventions.md`, `references/mermaid-reference.md`, `references/usage-examples.md`, `references/mermaid-styling.md`, `references/color-palette.md`(color-blind-friendly), `references/erd-conventions.md`, `references/preview-guide.md`.

**Scripts** — `scripts/README.md`, `scripts/mermaid_preview.py`(live-reload 브라우저 미리보기 서버), `scripts/query-org-metadata.py`(ERD grounding용 org 스키마 쿼리).

**OAuth 플로우 템플릿** (`assets/oauth/`) — authorization-code, authorization-code-pkce, jwt-bearer, client-credentials, device-authorization, refresh-token, user-agent-social-sign-on.

**Data model ERD 템플릿** (`assets/datamodel/`) — salesforce, sales-cloud, service-cloud, b2b-commerce, campaigns, consent, files, forecasting, fsl, party-model, quote-order, revenue-cloud, scheduler, territory-management (총 14개).

**기타 템플릿** — `assets/architecture/system-landscape.md`, `assets/integration/api-sequence.md`, `assets/agentforce/agent-flow.md`, `assets/role-hierarchy/user-hierarchy.md`.

**기타** — `README.md`, `CREDITS.md`.

---

## 관련 노트

- [[external-diagram-visual-generate]]
