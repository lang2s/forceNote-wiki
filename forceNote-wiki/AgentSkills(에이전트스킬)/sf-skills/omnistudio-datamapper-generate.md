---
tags: [agent-skill, sf-skills, omnistudio, data-mapper, dataraptor, omni-data-transform]
source: forcedotcom/sf-skills (skills/omnistudio-datamapper-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-datamapper-generate, OmniStudio Data Mapper 생성 스킬, DataRaptor, Extract Transform Load Turbo Extract, OmniDataTransform]
---

# omnistudio-datamapper-generate — OmniStudio Data Mapper 생성·검증 스킬

> OmniStudio Data Mapper(구 DataRaptor)의 Extract/Transform/Load/Turbo Extract 구성을 생성·검증하고 100점 루브릭으로 채점하는 에이전트 스킬.

---

## 목적과 활성화 조건

Extract·Transform·Load·Turbo Extract 구성에 특화된 OmniStudio Data Mapper 전문가. 적절한 필드 매핑·쿼리 최적화·데이터 무결성 안전장치를 갖춘 production-ready Data Mapper 정의를 생성한다.

**TRIGGER:** Data Mapper 생성, 필드 매핑 구성, OmniDataTransform 메타데이터 작업, DataRaptor/Data Mapper 패턴 질문.
**DO NOT TRIGGER:** Integration Procedure 빌드 → `omnistudio-integration-procedure-generate` / OmniScript 작성 → `omnistudio-omniscript-generate` / FlexCard 설계 → `omnistudio-flexcard-generate` / 교차 의존성 분석 → `omnistudio-dependencies-analyze`.

**핵심 책무:** 생성 / 필드 매핑 설계(타입 처리·lookup 해석·null safety) / 의존성 추적(소비·공급 컴포넌트 식별) / 5개 카테고리 0-100점 채점.

### CRITICAL: Orchestration Order
`omnistudio-dependencies-analyze → omnistudio-datamapper-generate → omnistudio-integration-procedure-generate → omnistudio-omniscript-generate → omnistudio-flexcard-generate` (현 위치: datamapper-generate). Data Mapper는 OmniStudio 스택의 **데이터 접근 계층** — 이를 참조하는 IP/OmniScript보다 먼저 생성·배포되어야 한다. 먼저 `omnistudio-dependencies-analyze`로 기존 의존성을 파악.

### Key Insights
| Insight | Details |
|---------|---------|
| Extract vs Turbo Extract | Extract는 관계 쿼리가 있는 표준 SOQL. Turbo Extract는 read-heavy·고볼륨용 server-side 컴파일 쿼리(10x+ 빠름). Turbo Extract는 formula field·related list·write 미지원. |
| Transform은 in-memory | Transform은 DML·SOQL 없이 메모리에서만 동작. IP 단계 간 데이터 구조 reshape. JSON-to-JSON 변환·필드 rename·flatten용. |
| Load = DML | Load는 insert/update/upsert/delete 수행. FLS 체크·error handling 필수. production 배포 전 FLS 검증 필수. |
| OmniDataTransform 메타데이터 | Data Mapper는 OmniDataTransform·OmniDataTransformItem 레코드로 저장. 레거시 DataRaptor API 이름이 아닌 이 메타데이터 타입명으로 retrieve·deploy. |

---

## 워크플로 / 단계 (5-Phase 패턴)

### Phase 1 — Requirements Gathering
묻는다: Data Mapper 타입(Extract/Transform/Load/Turbo Extract), 대상 SF 객체·필드, target org alias, 소비 컴포넌트(IP/OmniScript/FlexCard 이름), 데이터 볼륨 기대치. 그다음 기존 확인: `Glob: **/OmniDataTransform*`, `Glob: **/omnistudio/**`, task list 작성.

### Phase 2 — Design & Type Selection
| Type | Use Case | Naming Prefix | Supports DML | Supports SOQL |
|------|----------|---------------|--------------|---------------|
| Extract | 관계 쿼리로 1개+ 객체 읽기 | `DR_Extract_` | No | Yes |
| Turbo Extract | 고볼륨 read-only, server-side 컴파일 | `DR_TurboExtract_` | No | Yes (compiled) |
| Transform | 절차 단계 간 in-memory reshape | `DR_Transform_` | No | No |
| Load | write (insert/update/upsert/delete) | `DR_Load_` | Yes | No |

**Naming:** `[Prefix][Object]_[Purpose]` PascalCase. 예: `DR_Extract_Account_Details`, `DR_TurboExtract_Case_List`, `DR_Transform_Lead_Flatten`, `DR_Load_Opportunity_Create`.

### Phase 3 — Generation & Validation
생성: `assets/omni-data-transform-extract.json`(Extract)·`-transform.json`·`-load.json`에서 OmniDataTransform 레코드 템플릿 읽기 → 필드 매핑마다 `assets/omni-data-transform-item.json`(OmniDataTransformItem) 읽기 → Extract는 쿼리 filter·sort·limit 구성 → Load는 lookup 매핑·기본값 설정 → 모든 매핑 필드 FLS 검증. 검토: 기존 구성 읽기 → best-practices 대조 → 구체적 수정안 리포트. 채점 형식: `assets/completion-summary-template.md`.

### Phase 4 — Deployment
1. **Validation:** `platform-metadata-deploy` 스킬로 `--dry-run` 배포 2. **Deploy:** 검증 성공 시에만 실제 배포. **Post-Deploy:** target org에서 Data Mapper 활성화, OmniStudio Designer에서 표시 확인. 배포 실패 시: `Entity cannot be found`(Draft 상태 — 먼저 활성화), namespace prefix mismatch(`sfdx-project.json` 확인), item 배포 시 부모 `OmniDataTransform` 누락. Load DM 런타임 실패 시: `sf apex log list -o <org>`로 디버그 로그, 실행 유저 프로필의 FLS·객체 권한 검증, upsert key 채워짐·고유 확인. SF Load DM은 기본 `allOrNone=false` — 부분 성공 가능, `isSuccess=false` 행 확인.

### Phase 5 — Testing & Documentation
완료 요약: `assets/completion-summary-template.md`. 테스트 체크리스트: Designer에서 데이터 출력 미리보기 / 필드 매핑이 예상 JSON 구조 생성 / 대표 볼륨(1건 아님)으로 테스트 / 제한 프로필 유저로 FLS 강제 검증 / 소비 IP·OmniScript가 올바른 데이터 형태 수신 확인.

### CLI Commands
```bash
# 기존 Data Mapper 조회
sf data query -q "SELECT Id,Name,Type FROM OmniDataTransform LIMIT 200" -o <org>
# 필드 매핑 조회
sf data query -q "SELECT Id,Name,InputObjectName,OutputObjectName,LookupObjectName FROM OmniDataTransformItem WHERE OmniDataTransformationId='<id>' LIMIT 200" -o <org>
# 메타데이터 retrieve / deploy
sf project retrieve start -m OmniDataTransform:<Name> -o <org>
sf project deploy start -m OmniDataTransform:<Name> -o <org>
```

---

## 핵심 규칙·가드레일

### Generation Guardrails (MANDATORY) — anti-pattern 생성 시 STOP 후 사용자 확인
| Anti-Pattern | Detection | Impact |
|--------------|-----------|--------|
| 모든 필드 추출 | 필드 목록 미지정, wildcard 선택 | 성능 저하, 과도한 데이터 전송 |
| lookup 매핑 누락 | Load가 해석 없이 lookup 필드 참조 | DML 실패, null foreign key |
| FLS 체크 없는 write | 보안 검증 없는 Load DM | 보안 위반, 제한 프로필 데이터 손상 |
| 비제한 Extract 쿼리 | Extract에 LIMIT·filter 없음 | governor limit 실패, 대형 객체 timeout |
| 부수효과 있는 Transform | Transform이 DML·callout 시도 | 런타임 오류 (Transform은 in-memory only) |
| 하드코딩 레코드 ID | filter·매핑에 15/18자 ID 리터럴 | 환경 간 배포 실패 |
| 관계 depth >3 | 깊은 부모 traversal Extract | 쿼리 성능 저하, SOQL 복잡도 limit |
| error handling 없는 Load | upsert key·중복 규칙 미고려 | silent 데이터 손상, 중복 레코드 |

명시적 요청이 있어도 anti-pattern을 생성하지 않는다. 예외는 문서화된 정당화로 사용자 확인.

### 100-Point Scoring
| Category | Points | Key Rules |
|----------|--------|-----------|
| Design & Naming | 20 | 올바른 타입 선택; `DR_[Type]_[Object]_[Purpose]` 규칙; single responsibility |
| Field Mapping | 25 | 명시적 필드 목록(no wildcard); 올바른 input/output path; 타입 변환; null-safe 기본값 |
| Data Integrity | 25 | 전 필드 FLS 검증; Load의 lookup 해석; upsert key 정의; 중복 처리 |
| Performance | 15 | LIMIT/filter로 bounded 쿼리; read-heavy는 Turbo Extract; 최소 관계 depth; 인덱스 filter 필드 |
| Documentation | 15 | OmniDataTransform 레코드 description; 매핑 근거; 소비 컴포넌트 식별 |

**Thresholds:** ✅ 90+ (Deploy) / ⚠️ 67-89 (Review) / ❌ <67 (Block)

### Gotchas (발췌)
- 대형 볼륨(>10K) → Turbo Extract + IP 페이지네이션, heap limit 경고
- polymorphic lookup → 구체 객체 타입 지정, 타입별 테스트
- formula field → 표준 Extract는 지원, Turbo Extract 미지원 → 표준 Extract로 fallback
- master-detail cross-object Load → 부모 먼저 insert 후 별도 Load 단계로 child, IP로 순서 orchestrate
- 외래키 필드명: `OmniDataTransformItem`의 부모 lookup은 `OmniDataTransformationId`(full word "Transformation"), `OmniDataTransformId` 아님
- Draft Data Mapper는 retrieve 불가 → 활성화 후 retrieve

### Notes (핵심)
- **메타데이터 타입:** OmniDataTransform (DataRaptor는 레거시·deprecated)
- Turbo Extract 제한: no formula field, no related list, no aggregate query, no polymorphic field
- 활성화: 배포 후 활성화해야 IP에서 호출 가능
- Data API 생성: `sf api request rest --method POST --body @file.json` 사용(JSON을 임시 파일에 먼저 작성). `sf data create record --values`는 textarea JSON 처리 불가.

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `assets/omni-data-transform-extract.json` | Extract 타입 OmniDataTransform 템플릿 |
| `assets/omni-data-transform-transform.json` | Transform 타입 템플릿 |
| `assets/omni-data-transform-load.json` | Load 타입 템플릿 |
| `assets/omni-data-transform-item.json` | OmniDataTransformItem 필드 매핑 템플릿 |
| `assets/completion-summary-template.md` | 채점 출력·완료 요약 형식 |
| `references/best-practices.md` | 필드 매핑·쿼리 최적화·null 처리·성능 상세 패턴 |
| `references/naming-conventions.md` | 전 타입 naming 규칙·필드 매핑 규약 |

**Output:** OmniDataTransform 레코드 / 필드당 OmniDataTransformItem 레코드 / 100점 검증 리포트 / 배포 확인(활성화·Designer 표시).

---

## 관련 노트
- [[omnistudio-dependencies-analyze]]
- [[omnistudio-integration-procedure-generate]]
- [[omnistudio-omniscript-generate]]
- [[omnistudio-flexcard-generate]]
