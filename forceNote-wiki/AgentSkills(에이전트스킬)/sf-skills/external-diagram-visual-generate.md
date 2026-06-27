---
tags: [agent-skill, sf-skills, diagram, visual, image-generation]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [external-diagram-visual-generate, Salesforce 비주얼 이미지 생성, Nano Banana Pro, PNG SVG mockup wireframe, 비주얼 ERD UI mockup]
---

# external-diagram-visual-generate — Salesforce 비주얼 AI 이미지 생성 스킬

> Nano Banana Pro(Gemini CLI)를 통해 렌더된 PNG/SVG 비주얼 — 비주얼 ERD, UI mockup, wireframe, 아키텍처 일러스트 — 을 AI로 생성하는 스킬.

---

## 목적과 활성화 조건

사용자가 텍스트 다이어그램이 아닌 **렌더된 비주얼**을 원할 때 사용: ERD, UI mockup, 아키텍처 일러스트, 슬라이드용 이미지, 또는 기존 비주얼의 image edit.

**TRIGGER:** PNG/SVG 출력, UI mockup, wireframe, visual ERD 요청, 또는 "generate image" / "create mockup".

**DO NOT TRIGGER:** 텍스트 기반 Mermaid 다이어그램(→ external-diagram-mermaid-generate), 또는 non-visual 문서 작업.

**In scope:** PNG/SVG 스타일 렌더 이미지 출력, 비주얼 ERD·아키텍처 다이어그램, LWC/Experience Cloud mockup·wireframe, 기존 비주얼의 image edit.

**Out of scope (위임):** Mermaid/텍스트 다이어그램 → external-diagram-mermaid-generate. ERD용 object/field 메타데이터 발견 → platform-custom-object/field-generate. mockup 승인 후 LWC 구현 → experience-lwc-generate. Apex 리뷰/구현 → platform-apex-generate.

---

## 워크플로 / 단계

**Hard Gate — Prerequisites First:** 스킬 사용 전 prerequisites 체크를 먼저 실행. 실패 시 중단하고 `references/gemini-cli-setup.md`로 안내.

```bash
scripts/check-prerequisites.sh
```

**Required Inputs (기본값):** Image type → ERD / Subject scope → 사용자에게 질문 / Target quality → Draft (1K) / Preferred style → architect.salesforce.com aesthetic / Aspect ratio → Default / Quick or interview mode → Interview mode.

**Interview-First Workflow:** 사용자가 "quick / simple / just generate"를 요청하지 않는 한 `references/interview-questions.md`의 질문 뱅크로 먼저 질문한다. Quick mode 기본값(트리거: "quick", "simple", "just generate", "fast"): professional style, 1K draft, legend 포함, 한 이미지 먼저 후 iterate.

**Recommended Workflow (8단계):**
1. **prerequisites 체크 실행** — `scripts/check-prerequisites.sh`로 필수 도구 통과 확인.
2. **입력 수집** — object 목록/메타데이터(필요시 platform-custom-object/field-generate 위임), 목적(draft/presentation/documentation), aesthetic(`references/architect-aesthetic-guide.md`), aspect ratio/resolution.
3. **interview 또는 quick-mode 기본값** — `references/interview-questions.md`에서 매칭 질문 세트 로드.
4. **구체적 프롬프트 구성** — subject, composition, color treatment, labels/legends, output quality goal 명시.
5. **1K로 빠른 draft 생성** — 레이아웃 검토 후 고해상도 진행.
6. **edit으로 iterate** — 작은 조정은 `/edit` 사용(재생성보다 저렴).
7. **2K/4K 최종 생성** — 레이아웃 확정 후 Python 스크립트 사용.
8. **에러 복구** — `gemini --yolo`가 이미지 미반환 시 1회 재실행 후 Python 스크립트로 fallback. `GEMINI_API_KEY not found` 시 shell profile 확인. extension 누락 시 `gemini extensions install nanobanana`.

명령 (verbatim):

```bash
gemini --yolo "/generate 'Your prompt here'"
gemini --yolo "/edit 'Specific change instruction'"
uv run scripts/generate_image.py -p "Refined prompt" -f "output.png" -r 4K
```

---

## 핵심 규칙·가드레일

**Rules / Constraints:**

| Rule | Rationale |
|---|---|
| 어떤 생성 전에도 prerequisites 체크 실행 | 도구 누락 시 silent failure 발생 |
| 4K 전에 항상 1K로 draft | 비용·시간 절약. 고해상도에서 구성 변경은 낭비 |
| 작은 변경은 full 재생성 대신 `/edit` 사용 | 작은 조정에 더 싸고 빠름 |
| `GEMINI_API_KEY`를 절대 버전 컨트롤에 commit 금지 | 키는 개인용이며 billing에 연결됨 |
| 텍스트 다이어그램은 external-diagram-mermaid-generate에 위임 | 이 스킬은 렌더 이미지만 담당 |

**Default Style Guidance (ERD):** 사용자가 달리 요청하지 않으면 **architect.salesforce.com** aesthetic — dark border + light fill 카드, cloud별 accent 색상, 깔끔한 라벨/관계선, presentation-ready whitespace/hierarchy. 전체 스펙은 `references/architect-aesthetic-guide.md`.

**Gotchas:**

| Issue | Resolution |
|---|---|
| Edit 미적용 | 기존 요소를 이름으로 참조, 한 번에 하나씩 변경 |
| 4K가 1K draft와 다름 | 정확히 동일한 프롬프트 텍스트 사용. 약간의 변화는 정상 모델 동작 |
| `gemini --yolo` silent fail | Nano Banana extension 설치 확인: `gemini extensions list` |
| 이미지 dimension 오류 | `scripts/generate_image.py`에 `-a "16:9"`로 aspect-ratio 명시 |
| RGBA 이미지가 Python 스크립트 에러 유발 | 스크립트가 RGBA→RGB 자동 변환. `uv`로 Pillow 설치 확인 |

**Cross-Skill Integration:** Mermaid first draft/텍스트 다이어그램 → external-diagram-mermaid-generate. ERD용 object/field 발견 → platform-custom-object/field-generate. mockup → 실제 LWC 컴포넌트 → experience-lwc-generate. Apex 리뷰/구현 → platform-apex-generate.

---

## 번들 파일

**References** — `references/gemini-cli-setup.md`(prerequisites 실패 시 setup), `references/interview-questions.md`(질문 세트), `references/iteration-workflow.md`(draft→final 패턴·cost tips), `references/architect-aesthetic-guide.md`(ERD 색상·box·프롬프트 템플릿), `references/examples-index.md`(예시 프롬프트).

**Assets**
- `assets/erd/` — core-objects.md(Account/Contact/Opportunity/Case), custom-objects.md
- `assets/lwc/` — data-table.md, record-form.md, dashboard-card.md
- `assets/architecture/` — integration-flow.md
- `assets/review/` — apex-review.md, lwc-review.md (Gemini 리뷰 프롬프트 템플릿)

**Scripts** — `scripts/check-prerequisites.sh`(필수 도구 검증), `scripts/generate_image.py`(2K/4K 출력·resolution 제어 image editing).

**기타** — `README.md`, `CREDITS.md`.

---

## 관련 노트

- [[external-diagram-mermaid-generate]]
