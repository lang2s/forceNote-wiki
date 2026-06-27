---
tags: [agent-skill, sf-skills, devops, testing, recommendation, commit-diff]
source: forcedotcom/sf-skills (skills/recommending-devops-tests/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [recommending-devops-tests, 데브옵스 테스트 추천, commit diff suite recommendation, 커밋 변경 테스트 추천, coverage gap]
---

# recommending-devops-tests — 데브옵스 테스트 추천

> 커밋 diff와 사용 가능한 DevOps Center 테스트 스위트 메타데이터를 분석해 가장 관련 있는 기존 스위트를 추천하고, 어떤 스위트도 신규 메서드를 커버하지 않는 coverage gap을 플래그하는 순수 추론(pure reasoning) 스킬. prerequisite 쿼리 외에 system call이 없다.

---

## 목적과 활성화 조건

커밋 diff와 사용 가능한 스위트 메타데이터를 분석해 Review 파이프라인 스테이지에 할당된 가장 관련 있는 기존 테스트 스위트를 추천한다. 어떤 스위트도 신규 메서드를 커버하지 않는 coverage gap을 플래그한다.

**Type:** Pure reasoning — 아래 문서화된 prerequisite data-fetch 쿼리 외에는 system call이 없다.

**TRIGGER:** 특정 커밋/diff에 어떤 테스트 스위트를 실행할지 물을 때 / 변경사항을 무엇이 커버하는지 물을 때 / 승격 전 스위트 추천을 요청할 때.

**DO NOT TRIGGER:** 새 테스트 작성 시(`platform-apex-test-generate`) / `sf apex run test`를 직접 실행할 때(`platform-apex-test-run`).

`version: 1.0`, `minApiVersion: 67.0`.

## 워크플로 / 단계

### Prerequisites

`checking-devops-prerequisites`를 먼저 로드·수행한다(Prerequisites 1–4). 확인된 DevOps Center org alias와 pipeline Id가 필요하다.

### Step 1 — Fetch suite metadata

추론 시작 전, Review 파이프라인 스테이지에 할당된 테스트 스위트 메타데이터를 가져온다. 두 개의 쿼리가 필요하다.

**1a — Review 파이프라인 스테이지 trigger 찾기:**

```bash
sf data query \
  --query "SELECT Id FROM DevopsPipelineStageTrigger WHERE TriggerType = 'Review' AND RelatedRecordId = '<pipelineId>'" \
  --target-org <doce-org-alias> \
  --json
```

반환된 `Id`를 `<reviewTriggerId>`로 기록.

**1b — 해당 trigger에 할당된 스위트 가져오기:**

```bash
sf data query \
  --query "SELECT Id, TestSuiteId, TestSuite.Name, IsQualityGateEnabled, DevopsQualityGateId FROM DevopsTestSuiteStage WHERE DevopsPipelineStageTriggerId = '<reviewTriggerId>'" \
  --target-org <doce-org-alias> \
  --json
```

각 행은 `TestSuiteId`, `TestSuite.Name`, `IsQualityGateEnabled`, `DevopsQualityGateId`(gate 구성 시)를 제공한다.

> Note: beta `/connect/devops/.../testSuites` 엔드포인트를 사용하지 말 것 — 빈 결과를 반환한다. 위와 같이 `DevopsTestSuiteStage`를 직접 쿼리한다.

raw API 에러나 raw JSON을 사용자에게 절대 노출하지 않는다. 쿼리 실패 시 평이한 언어로 보고하고 중단한다. 커밋 diff는 사용자 또는 주변 컨텍스트에서 온다.

### Reasoning steps

**1 — diff를 change type으로 분류:** diff 파일 확장자·경로를 파싱한다.

| File pattern | Change type |
|---|---|
| `*.cls`, `*.trigger` | Apex |
| `*.flow-meta.xml`, `*.flow` | Flow |
| `*.java` | Java |
| `*.js`, `*.html` (LWC paths) | LWC / JavaScript |

단일 커밋은 여러 change type을 포함할 수 있다. 전부 식별한다.

**2 — change type을 test provider에 매핑:** 식별된 각 change type을 가져온 스위트의 `testProviderName`과 매칭한다.

| Change type | Match suites whose `testProviderName` contains |
|---|---|
| Apex | `Apex` |
| Flow | `Flow` |
| Java | `Java` |
| LWC / JavaScript | `LWC` or `JavaScript` |
| Code Analyzer (any) | `Code Analyzer` — 그 다음 suite name convention으로 sub-filter: `recommended` → Apex/general rules (Apex·Java 변경에 제안), `html` → HTML/LWC 템플릿 변경에 제안, `css` → CSS 변경에 제안. convention에 맞는 suite name이 없으면 모든 Code Analyzer 스위트를 제안하고 ambiguity를 표기. |

diff 내 최소 하나의 change type과 provider가 매칭되는 스위트만 추천한다. 매칭되지 않는 provider의 스위트는 추천에서 제외된다.

**3 — 매칭된 스위트 순위:** 각 매칭 provider 그룹 내에서:
1. `triggerType` 정렬 — commit-time 검사에는 `Pre-Promote` 스위트 우선
2. quality gate 존재 — `qualityGateRuleName`이 있는 스위트가 우선순위 높음 (승격을 gate)
3. suite name 관련성 — suite name이 수정된 파일명의 용어를 포함하면 부스트

**4 — 커버리지 없는 신규 메서드 플래그:** diff에 추가된 신규 메서드는 provider 매칭과 무관하게 gap으로 플래그한다.
> "⚠ `processRefund()` in `OrderService.cls` is a new method. No existing suite can confirm it's covered until tests are authored and linked."

**5 — 추천 목록 반환:** 각 스위트가 왜 제안됐는지 명확하도록 change type별로 그룹화한다.

### Output format

```text
Recommended suite(s) for this commit:

Apex changes detected (OrderService.cls, InvoiceService.cls):
1. <SuiteName> — Apex Test Provider | Trigger: Pre-Promote | Gate: <gateName or none>
2. <SuiteName2> — Apex Test Provider | Trigger: Post-Promote | Gate: <gateName or none>

Flow changes detected (OrderApproval.flow):
1. <SuiteName3> — Flow Test Provider | Trigger: Pre-Promote | Gate: <gateName or none>

Code Analyzer — Apex rules:
1. <SuiteName4> — Code Analyzer | Trigger: Pre-Promote | Gate: <gateName or none>

No matching suite found for:
- LWC changes — no LWC test suite is assigned to this stage

Coverage gaps (new methods — manual authoring required):
- `processRefund()` in `OrderService.cls` — new method, not yet covered by any suite
```

## 핵심 규칙·가드레일

- **순수 추론** — prerequisite data-fetch 쿼리 외 system call 없음.
- **beta `testSuites` 엔드포인트 사용 금지** — 빈 결과. `DevopsTestSuiteStage` 직접 쿼리.
- **raw API 에러/JSON 노출 금지** — 실패 시 평이한 언어로 보고 후 중단.
- **v1 constraint:** 기존 스위트만 추천한다. 새 테스트 생성을 절대 제안하지 않는다. gap이 있으면 개발자에게 수동 작성을 안내하고 정확히 어떤 메서드에 커버리지가 필요한지 설명한다.

## 번들 파일

- `SKILL.md` — 단일 파일 스킬 (추가 번들 리소스 없음)

## 관련 노트
- [[running-devops-test-suite]] — 추천된 스위트를 실제 실행할 때
- [[managing-suite-assignments]] — 추천 스위트를 스테이지에 할당/매핑할 때
- [[syncing-test-providers]] — 추천 대상 신규 스위트를 provider 싱크로 끌어올 때
- [[analyzing-test-failures]] — 실행 실패 분석
