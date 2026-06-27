---
tags: [agent-skill, sf-skills, omnistudio, integration-procedure, omniprocess, orchestration]
source: forcedotcom/sf-skills (skills/omnistudio-integration-procedure-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-integration-procedure-generate, OmniStudio Integration Procedure 생성 스킬, IP 오케스트레이션, OmniProcess IsIntegrationProcedure, Remote Action DataRaptor]
---

# omnistudio-integration-procedure-generate — OmniStudio Integration Procedure 생성·검증 스킬

> Data Mapper action·Apex Remote Action·HTTP callout·조건부 로직·nested IP를 결합한 server-side 다단계 orchestration(IP)을 생성·검증하고 110점 루브릭(6 category)으로 채점하는 에이전트 스킬.

---

## 목적과 활성화 조건

server-side 프로세스 orchestration에 대한 깊은 지식을 갖춘 OmniStudio Integration Procedure(IP) 빌더. DataRaptor/Data Mapper action·Apex Remote Action·HTTP callout·조건부 로직·nested 절차 호출을 선언적 다단계 작업으로 결합한다.

**TRIGGER:** IP 생성, Data Mapper 단계 추가, Remote Action 구성, 기존 IP 검토.
**DO NOT TRIGGER:** OmniScript 빌드 → `omnistudio-omniscript-generate` / Data Mapper 직접 생성 → `omnistudio-datamapper-generate` / FlexCard 설계 → `omnistudio-flexcard-generate` / 의존성 트리 매핑 → `omnistudio-dependencies-analyze` / 메타데이터 배포 → `platform-metadata-deploy`.

### Required Inputs
Purpose(orchestrate하는 비즈니스 프로세스) / 대상 객체·데이터 소스(SF 객체·외부 API·둘 다) / Type/SubType naming(PascalCase pair, 예: `Type=OrderProcessing`, `SubType=Standard`) / target org alias.

### Quick Reference
**Scoring:** 110점, 6 category. **Thresholds:** ✅ 90+ (Deploy) / ⚠️ 67-89 (Review) / ❌ <67 (Block).

### CRITICAL: Orchestration Order
`omnistudio-dependencies-analyze → omnistudio-datamapper-generate → omnistudio-integration-procedure-generate → omnistudio-omniscript-generate → omnistudio-flexcard-generate` (현 위치). IP가 참조하는 Data Mapper가 **먼저** 존재해야 함. IP는 OmniScript·FlexCard가 호출하기 전 active 되어야 함.

### Key Insights
| Insight | Details |
|---------|---------|
| Chaining | IP는 Integration Procedure Action element로 다른 IP 호출. 한 단계 출력이 다음 입력으로(response mapping). 가능하면 linear data flow. |
| Response Mapping | 각 element 출력은 element 이름 아래 namespaced. downstream 입력에서 `%elementName:keyPath%` 문법으로 upstream 출력 참조. |
| Caching | read-heavy orchestration에 platform cache 지원. PropertySet에 `cacheType`·`cacheTTL` 설정. DML 수행 절차는 캐싱 금지. |
| Versioning | Type/SubType pair가 IP를 고유 식별. SubType으로 버전(예: `SubType=v2`). Type/SubType당 한 버전만 active. |

**Core Namespace Discriminator:** Core는 IP·OmniScript 모두 `OmniProcess` 테이블에 저장. `IsIntegrationProcedure = true`(또는 `OmniProcessType = 'Integration Procedure'`)로 IP 필터. 필터 없으면 mixed 결과.

> **CRITICAL — Data API로 IP 생성:** OmniProcess 레코드 생성 시 `IsIntegrationProcedure = true`로 설정해야 IP가 됨. `OmniProcessType` picklist은 이 boolean에서 **computed**, 직접 set 불가. `Name`은 `OmniProcess`의 required 필드(표준 OmniStudio 문서에 미기재). 생성은 `sf api request rest --method POST --body @file.json` 사용(`sf data create record --values`는 `PropertySetConfig` 같은 JSON textarea 불가).

---

## 워크플로 / 단계 (5-Phase 패턴)

### Phase 1 — Requirements Gathering
**대안 평가 먼저:** 단일 DataRaptor·Apex service·Flow가 나을 때도 있음. IP는 분기·error handling·혼합 데이터 소스가 있는 선언적 다단계 orchestration에 최적. 묻는다: purpose·비즈니스 프로세스, 대상 객체·데이터 소스, Type/SubType naming, target org alias. 그다음 기존 IP CLI 조회, 재사용 가능 DataRaptor 식별, `omnistudio-dependencies-analyze`로 의존 컴포넌트 검토.

### Phase 2 — Design & Element Selection
| Element Type | Use Case | PropertySet Key |
|--------------|----------|-----------------|
| DataRaptor Extract Action | SF 데이터 읽기 | `bundle` |
| DataRaptor Load Action | SF 데이터 쓰기 | `bundle` |
| DataRaptor Transform Action | 데이터 shaping/mapping | `bundle` |
| Remote Action | Apex 클래스 메서드 호출 | `remoteClass`, `remoteMethod` |
| Integration Procedure Action | nested IP 호출 | `ipMethod` (format: `Type_SubType`) |
| HTTP Action | 외부 API callout | `path`, `method` |
| Conditional Block | 분기 로직 | -- |
| Loop Block | 컬렉션 iterate | -- |
| Set Values | 변수/상수 할당 | -- |

**Naming:** `[Type]_[SubType]` PascalCase. element 이름은 action을 명확히(예: `GetAccountDetails`, `ValidateInput`, `CreateOrderRecord`). **Data Flow:** 각 단계 출력이 다음 입력으로 자연스럽게; implicit namespace merge보다 명시적 매핑.

### Phase 3 — Generation & Validation
빌드: 올바른 Type/SubType / 명시적 input/output 매핑이 있는 ordered element chain / 모든 data-modifying element에 error handling / 분기용 conditional block.

**Validation (STRICT MODE):**
- **BLOCK:** Type/SubType 누락, 순환 IP 호출, error handling 없는 DML, 존재하지 않는 DataRaptor/Apex 참조
- **WARN:** LIMIT 없는 unbounded extract, read-only IP의 caching 누락, PropertySetConfig 하드코딩 ID, 미사용 element, element description 누락

리포트 형식(6-Category 0-110): `assets/scoring-report-format.txt`.

**Generation Guardrails (MANDATORY):**
| Anti-Pattern | Impact | Correct |
|--------------|--------|---------|
| 순환 IP 호출(A→B→A) | infinite loop / stack overflow | 의존성 그래프 매핑; cycle 금지 |
| error handling 없는 DML | silent 데이터 손상 | DataRaptor Load를 try/catch·조건부 error check |
| unbounded DataRaptor Extract | governor limit / timeout | extract에 LIMIT; 대형 데이터셋 페이지네이션 |
| PropertySetConfig 하드코딩 ID | org 간 배포 실패 | input 변수·Custom Settings·Custom Metadata |
| parallel 가능한 sequential 호출 | 불필요 latency | 독립 element 그룹화 |
| response validation 누락 | downstream null reference | 다음 단계 전달 전 element response 체크 |

명시적 요청이 있어도 anti-pattern 생성 금지.

### Phase 4 — Deployment
1. 선행 DataRaptor/Data Mapper 먼저 deploy(`platform-metadata-deploy`) 2. IP deploy 3. target org 활성화(`IsActive=true`) 4. CLI 조회로 활성화 검증.

```bash
sf project deploy start -m OmniIntegrationProcedure:<Name> -o <org>
```

### Phase 5 — Testing
full chain 전 element별 테스트: **Unit**(각 DataRaptor 독립 호출, Apex Remote Action 응답) / **Integration**(대표 input JSON으로 full IP, 출력 구조 검증) / **Error paths**(invalid input·missing record·API 실패) / **Bulk**(컬렉션 input으로 loop·batch) / **End-to-end**(소비자 OmniScript/FlexCard/API에서 호출, full round-trip).

---

## 핵심 규칙·가드레일

### Scoring Breakdown (110점, 6 category)
| Category | Points | 주요 criteria |
|----------|--------|---------------|
| Design & Structure | 20 | Type/SubType naming(5)·element naming(5)·data flow clarity(5)·element ordering(5) |
| Data Operations | 25 | DataRaptor 참조 valid(5)·extract bounded(5)·load validated(5)·response mapping(5)·transform accuracy(5) |
| Error Handling | 20 | DML error handling(8)·HTTP error handling(4)·Remote Action error handling(4)·rollback strategy(4) |
| Performance | 20 | no unbounded query(5)·caching applied(5)·parallel execution(5)·no redundant calls(5) |
| Security | 15 | no 하드코딩 ID(5)·no 하드코딩 credential(5)·input validation(5) |
| Documentation | 10 | procedure description(3)·element descriptions(4)·input/output 문서화(3) |

### CLI / Core Namespace Note
`scripts/cli-commands.sh`에 SOQL·`sf project` deploy/retrieve 명령. **`IsIntegrationProcedure=true` 필터 필수**(또는 `OmniProcessType='Integration Procedure'`) — OmniScript·IP가 `OmniProcess` sObject 공유, 필터 없으면 양 타입 반환.

### Edge Cases (발췌)
- 직접 재귀(IP가 자기 호출) → 설계 시 block, 순환 의존성 체크 필수
- 간접 재귀 → full call graph 매핑, `omnistudio-dependencies-analyze`가 cycle 감지
- DataRaptor 미배포 → DataRaptor 먼저 배포, 누락 참조 시 IP 배포 실패
- 외부 API timeout → HTTP Action에 timeout 값, retry·graceful degradation
- Loop Block 대형 컬렉션 → batch size 설정, 현실적 볼륨 테스트(CPU timeout 회피)
- Type/SubType 충돌 → 생성 전 기존 IP 조회, SubType 버전으로 회피
- 혼합 네임스페이스(Vlocity vs Core) → org 네임스페이스 확인, element property 이름이 패키지 간 다름

**Debug:** IP 미실행 → IsActive·Type/SubType 확인 / element skip → conditional block·input shape / timeout → DataRaptor query scope·HTTP timeout / 배포 실패 → 참조 컴포넌트 deploy·active 확인.

### Notes (핵심)
- API: 최신(저작 시 66.0) / Mode: Strict(warning이 block) / 점수 <67이면 배포 block
- **프로그램 생성:** REST API. 필수 필드 `Name`·`Type`·`SubType`·`Language`·`VersionNumber`·`IsIntegrationProcedure=true`. 각 action 단계마다 `OmniProcessElement` child 레코드 생성 후 `IsActive=true`로 활성화.

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `assets/omni-process-ip.json` | Phase 3 — `IsIntegrationProcedure=true` OmniProcess 레코드 템플릿 |
| `assets/omni-process-element-dr-extract.json` | Phase 3 — DataRaptor Extract Action element 템플릿(다른 DR action용 adapt) |
| `assets/omni-process-element-set-values.json` | Phase 3 — Set Values element 템플릿 |
| `assets/scoring-report-format.txt` | Phase 3 — 110점 검증 리포트 출력 layout |
| `references/best-practices.md` | Phase 2-5 — element 구성·error handling·caching·parallel·security 가이드 |
| `references/element-types.md` | Phase 2 — element 선택, PropertySetConfig 구성 전 필독 |
| `scripts/cli-commands.sh` | Phase 1·4 — CLI 조회·deploy/retrieve 명령 |

**Output:** IP JSON / 각 action 단계 OmniProcessElement JSON / 110점 검증 리포트 / 배포 체크리스트.

---

## 관련 노트
- [[omnistudio-datamapper-generate]]
- [[omnistudio-omniscript-generate]]
- [[omnistudio-flexcard-generate]]
- [[omnistudio-dependencies-analyze]]
- [[omnistudio-callable-apex-generate]]
