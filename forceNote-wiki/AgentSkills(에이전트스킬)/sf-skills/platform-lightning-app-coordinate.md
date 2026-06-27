---
tags: [agent-skill, sf-skills, platform, lightning-app, orchestration, metadata]
source: forcedotcom/sf-skills (skills/platform-lightning-app-coordinate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-lightning-app-coordinate, Lightning 앱 생성, Lightning app orchestration, end-to-end 솔루션, CustomApplication 빌드, dependency order 빌드]
---

# platform-lightning-app-coordinate — 완전한 Lightning 앱 오케스트레이션

> 자연어 설명으로부터 배포 가능한 완전한 Salesforce Lightning Experience 앱을 빌드 — CustomApplication + 의존 메타데이터 타입을 올바른 dependency 순서로 오케스트레이션.

---

## 목적과 활성화 조건

`metadata.version: 1.0`
`related-skills:` platform-custom-object-generate · platform-custom-field-generate · platform-custom-tab-generate · platform-flexipage-generate · platform-custom-application-generate · automation-flow-generate · platform-validation-rule-generate · platform-list-view-generate · platform-permission-set-generate

### 개요
자연어 설명으로부터 Lightning Custom Application을 정의하고 의존 메타데이터 타입을 올바른 dependency 순서로 오케스트레이션하여 완전·배포가능 앱을 빌드. 가용한 specialized 메타데이터 스킬을 invoke; 스킬이 없으면 직접 메타데이터 생성.

### When to Use
**Use when:**
- 사용자가 "Lightning app" 또는 "end-to-end solution" 요청
- "build an app", "create an application", "build a [type] app"(project management, tracking 등)
- 작업이 단일 오브젝트·페이지·탭이 아닌 custom app(CustomApplication) + 보조 메타데이터를 produce

**트리거해야 할 예시:**
- "Build a project management lightning app with Tasks, Resources, and Supplies objects"
- "Create a LEX app to track vehicles with Lightning pages and permission sets"
- "I need a Space Station management system with multiple objects and relationships"
- "Build an employee onboarding lightning app with custom Lightning Record Pages"

**Do NOT use when:**
- 단일 메타데이터 컴포넌트 생성(specific 스킬 사용)
- 기존 메타데이터 troubleshoot/debug
- Salesforce Classic 앱(LEX 아님)
- 단일 오브젝트/페이지/permission set만(다른 것 없이) 요청
- 다른 메타데이터 없이 app container(기존 탭 grouping)만 생성/구성 → `platform-custom-application-generate` 사용

---

## 메타데이터 타입 레지스트리

LEX 앱에 흔히 필요한 메타데이터 타입·스킬 가용성·API context 요구.

| Metadata Type | Skill Name | API Context | Usage Rule |
|---|---|---|---|
| **Custom Object** | `platform-custom-object-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 |
| **Custom Field** | `platform-custom-field-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 |
| **Custom Tab** | `platform-custom-tab-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 |
| **FlexiPage** | `platform-flexipage-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 |
| **Custom Application** | `platform-custom-application-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 |
| **List View** | `platform-list-view-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 (요청 시) |
| **Validation Rule** | `platform-validation-rule-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 (요청 시) |
| **Flow** | `automation-flow-generate` | `metadata-experts` pipeline | 스킬 로드 AND pipeline 실행. **`salesforce-api-context` 면제** |
| **Permission Set** | `platform-permission-set-generate` | `salesforce-api-context` | 스킬 로드 AND API context 호출 필수 |

### Usage Rules
- **SKILL RULE:** 메타데이터 타입에 스킬이 존재하면 **반드시** 그 스킬을 로드. 스킬 로드 없이 직접 생성 금지.
- **API CONTEXT RULE:** Flow를 제외한 모든 타입은 생성 전 **반드시** `salesforce-api-context` 도구 호출. 스킬은 구조·규칙을, API context는 현재 API 버전에 유효한 것을 확인 — 둘 다 필수.
- **FALLBACK RULE:** 필요 타입에 스킬이 없으면 Salesforce Metadata API 지식·best practice로 직접 생성. API context는 여전히 필수.
- **RATIONALE:** 스킬은 검증된 패턴·제약을, API context는 버전별 정확성을 제공 — 함께 배포 실패를 방지.

---

## 워크플로 / 단계

### Dependency Graph & Build Order

**Phase 1 — Data Model (Foundation):**
```text
Custom Objects (no dependencies)
    ↓
Custom Fields (depends on: Objects exist)
    ↓
Relationships (depends on: Both parent and child objects + fields exist)
```
타입: ① `platform-custom-object-generate`(한 번, 모든 오브젝트) ② `platform-custom-field-generate`(한 번, 모든 필드 — Master-Detail·Lookup·Roll-up Summary 포함).

**Phase 2 — Business Logic (Optional, 요청 시만):**
```text
Validation Rules (depends on: Fields exist)
    ↓
Flows (depends on: Objects, Fields exist)
```
타입(요청 시만): ① `platform-validation-rule-generate`(validation 요구 언급 시) ② `automation-flow-generate`(automation/workflow 요구 언급 시).

**Phase 3 — User Interface:**
```text
List Views (depends on: Objects, Fields exist)
    ↓
Custom Tabs (depends on: Objects exist)
    ↓
FlexiPages (depends on: Objects, Tabs exist)
```
타입: ① `platform-list-view-generate`(요청 시) ② `platform-custom-tab-generate`(모든 오브젝트 탭) ③ `platform-flexipage-generate`(모든 record/home/app 페이지).

**Phase 4 — Application Assembly:**
```text
Custom Application (depends on: Tabs exist)
```
타입: ① `platform-custom-application-generate`(Lightning App container 생성).

**Phase 5 — Security & Access:**
```text
Permission Sets (depends on: Objects, Fields, Tabs, App exist)
```
타입: ① `platform-permission-set-generate`(모든 permission set + Objects(Read/Create/Edit/Delete)·Fields(Read/Edit)·Tabs(Visible)·Custom Application(Visible) 접근).

### Execution Workflow

**STEP 1 — Requirements Analysis & Planning**
Actions: ① 자연어 요청 파싱 ② 비즈니스 entity 추출(→ Custom Objects) ③ attribute/property 추출(→ Custom Fields) ④ relationship 식별(Master-Detail/Lookup) ⑤ validation 요구 감지(→ Validation Rules) ⑥ automation 요구 감지(→ Flows) ⑦ user persona 식별(→ Permission Sets).

Output — Build Plan:
```text
Lightning App Build Plan: [App Name]

DATA MODEL:
- Custom Objects: [list with object names]
- Custom Fields: [list grouped by object]
- Relationships: [list M-D and Lookup relationships]

BUSINESS LOGIC (if applicable):
- Validation Rules: [list with object and rule name]
- Flows: [list with flow name and type]

USER INTERFACE:
- List Views (if requested): [list with object and view name]
- Custom Tabs: [list with object]
- FlexiPages: [list with page name and type]
- Custom Application: [app name]

SECURITY:
- Permission Sets: [list with purpose]

PER-TYPE EXECUTION (skill + API context for each):
- CustomObject: load platform-custom-object-generate + call salesforce-api-context
- CustomField: load platform-custom-field-generate + call salesforce-api-context
- ValidationRule: load platform-validation-rule-generate + call salesforce-api-context (if requested)
- Flow: load automation-flow-generate + run metadata-experts pipeline (if requested)
- ListView: load platform-list-view-generate + call salesforce-api-context (if requested)
- CustomTab: load platform-custom-tab-generate + call salesforce-api-context
- FlexiPage: load platform-flexipage-generate + call salesforce-api-context
- CustomApplication: load platform-custom-application-generate + call salesforce-api-context
- PermissionSet: load platform-permission-set-generate + call salesforce-api-context

STATUS LINES TO EMIT BEFORE FILE WRITES:
- `type=<Type> skill=complete mcp=complete|unavailable mcp_tools=<tool-list|none>`
- Flow exception: `type=Flow skill=complete pipeline=complete`

DEPENDENCY ORDER:
1. Phase 1: Data Model (Objects -> Fields)
2. Phase 2: Business Logic (Validation Rules -> Flows)
3. Phase 3: User Interface (List Views -> Tabs -> Pages)
4. Phase 4: App Assembly (Application)
5. Phase 5: Security (Permission Sets)
```

**STEP 2 — Per-Type Execution**
각 메타데이터 타입마다 4단계를 한 타입씩 실행. 현재 타입의 4단계 모두 완료 후 다음 타입으로. 어떤 단계도 skip 금지.

| Step | 할 일 | 이유 |
|---|---|---|
| **① Load skill** | per-type SKILL.md 검색·읽기 | XML 구조·required 요소·naming 규칙·validation 제약 제공 |
| **② Call API context** | `salesforce-api-context` 도구 호출 — `get_metadata_type_sections`, `get_metadata_type_context`, `get_metadata_type_fields`, `get_metadata_type_fields_properties`, `search_metadata_types` 중 하나 이상 | 현재 유효 값 제공 — 허용 enum·required/optional 필드·이 API 버전 child 타입 |
| **③ Record status** | `type=<Type> skill=complete mcp=complete\|unavailable mcp_tools=<tool-list\|none>` emit | 파일 write 전 두 단계 시도 확인 + 사용한 API context 도구 기록 |
| **④ Generate files** | 이 타입의 모든 파일 생성, 후 checkpoint | ①②③ 완료 후에만. verify 후 다음 타입 |

**①과 ②를 단일 action으로 합치거나 ① 후 ② skip 금지.** 서로 다른 목적의 별개 단계. 스킬 로드 후 생성 준비됐다 느껴도 — 멈추고 ② 먼저. `salesforce-api-context`가 real 시도 후 unavailable이면 `mcp=unavailable` 기록 + 스킬 지식만으로 생성. ② 미시도는 버그.

per-type 실행 순서(각 ①②③④ 적용): 1.Custom Objects → 2.Custom Fields → 3.Validation Rules(요청 시) → 4.Flows(요청 시, ② = `metadata-experts/execute_metadata_action` 3-step pipeline, status `type=Flow skill=complete pipeline=complete`) → 5.List Views(요청 시) → 6.Custom Tabs → 7.FlexiPages → 8.Custom Application → 9.Permission Sets.

**STEP 3 — Final Artifact Assembly**
모든 phase 완료 후 출력을 배포 가능 구조로 consolidate.

---

## 핵심 규칙·가드레일

### Output
완료된 빌드 산출물:
1. **Salesforce DX Project Directory** — 표준 SFDX 구조(`force-app/main/default/`)로 모든 생성 메타데이터.
2. **Metadata Files** — 컴포넌트당 1 파일, 타입별 정리:
```text
force-app/main/default/
├── objects/              # Custom Objects (.object-meta.xml)
├── fields/               # Custom Fields (.field-meta.xml)
├── tabs/                 # Custom Tabs (.tab-meta.xml)
├── flexipages/           # Lightning Pages (.flexipage-meta.xml)
├── applications/         # Custom Applications (.app-meta.xml)
├── permissionsets/       # Permission Sets (.permissionset-meta.xml)
├── flows/                # Flows (.flow-meta.xml) - if applicable
└── objects/.../validationRules/  # Validation Rules (.validationRule-meta.xml) - if applicable
```
3. **Deployment Manifest** (`package.xml`) — 모든 컴포넌트 + 적절 API 버전, 타입별 dependency 순서, CLI/Metadata API 배포 준비.
4. **Build Summary Report** — 생성 컴포넌트·타입·API명·파일 경로·dependency 관계·warning/recommendation 나열 markdown.

### Validation (빌드 제시 전 cross-component 무결성 검증)
- [ ] **Object-Tab Coverage:** 모든 Custom Object에 ≥1 Custom Tab
- [ ] **Relationship Integrity:** relationship에 참조된 모든 Custom Object(parent/child)가 빌드에 존재
- [ ] **Field References in Pages:** FlexiPage 참조 필드가 해당 오브젝트에 존재
- [ ] **Tab References in App:** Custom Application 참조 탭이 모두 성공 생성
- [ ] **Permission Set Completeness:** permission set이 모든 생성 오브젝트·필드·탭·앱 접근 부여
- [ ] **No Orphaned Components:** 오브젝트 없는 탭·탭 없는 페이지·탭 없는 앱 없음
- [ ] **Deployment Manifest Completeness:** `package.xml`이 모든 컴포넌트를 dependency 순서로 포함

**Validation Failure Handling (Category 2):** 실패 시 Build Summary Report의 `VALIDATION WARNINGS` 섹션에 포함; post-generation 이슈이므로 delivery는 차단하지 않되 manual review/correction 필요를 명확히 전달; 각 실패 check에 구체적 remediation step 제공. (예약어·name length·field type 등 개별 컴포넌트 validation은 specialized 스킬 담당 — 여기서 재검증 불필요.)

### Error Handling
**Category 1 — Stop and Ask User:** 요청이 너무 vague하여 오브젝트/필드 추출 불가 · 모순 요구("make it private" + "everyone should see it") · 잘못된 Salesforce naming(예약어 `Order`·`Group`).

**Category 2 — Post-Generation Warnings (로그 후 계속):** cross-component validation 실패 · optional 컴포넌트 생성 실패 · Validation Rule/Flow minor 이슈.
```text
Warning: [Component Type] generation encountered issue
    Component: [Name]
    Issue: [Description]
    Impact: [What won't work]
    Recommendation: [How to fix manually]
    Continuing with remaining components...
```

### Best Practices
1. **항상 Dependency Order 준수** — 스킬을 순서 밖에서 invoke 금지. 필드는 오브젝트, 페이지는 탭, 앱은 탭 필요.
2. **가용 시 스킬 사용** — specialized 스킬에 배포 오류 방지하는 field-specific validation 있음.
3. **Thoughtful Defaults 생성** — 미지정 시: human entity엔 Text name 필드 · transaction엔 AutoNumber · user-facing 오브젝트엔 Search·Reports 활성 · relationship 기반 sharingModel.
4. **빌드 전 검증** — 예약어·relationship limit(오브젝트당 max 2 M-D)·name length·중복 이름 확인.

---

## 번들 파일

`SKILL.md` 단일 파일 오케스트레이터 (자체 assets·scripts 없음 — `related-skills`의 9개 specialized 메타데이터 스킬을 invoke).

---

## 관련 노트
- [[platform-list-view-generate]]
- [[platform-data-manage]]
