---
tags: [agent-skill, sf-skills, omnistudio, callable-apex, vlocity-open-interface, industries]
source: forcedotcom/sf-skills (skills/omnistudio-callable-apex-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-callable-apex-generate, OmniStudio Callable Apex 생성 스킬, System.Callable, VlocityOpenInterface 마이그레이션, Industries Callable Apex]
---

# omnistudio-callable-apex-generate — OmniStudio용 Callable Apex 생성·검토 스킬

> Salesforce Industries Common Core(OmniStudio/Vlocity) 확장점용 `System.Callable` Apex를 생성·검토·마이그레이션하고 120점 루브릭으로 채점하는 에이전트 스킬.

---

## 목적과 활성화 조건

Salesforce Industries Common Core callable Apex 구현 전문 스킬. OmniStudio·Integration Procedure·DataRaptor 등 Industries 확장점에서 호출되는 안전하고 결정적(deterministic)이며 구성 가능한 Apex를 만든다.

**TRIGGER (활성화):**
- `System.Callable` 클래스를 생성하거나 검토할 때
- `VlocityOpenInterface` / `VlocityOpenInterface2`를 `System.Callable`로 마이그레이션할 때
- OmniStudio·Integration Procedure·DataRaptor에서 쓰는 Industries callable 확장을 만들 때

**DO NOT TRIGGER (비활성화):**
- 일반 Apex 클래스·트리거 → `platform-apex-generate`
- Integration Procedure 빌드 → `omnistudio-integration-procedure-generate`
- OmniScript 작성 → `omnistudio-omniscript-generate`
- Data Mapper 구성 → `omnistudio-datamapper-generate`
- 네임스페이스/의존성 분석 → `omnistudio-dependencies-analyze`
- Apex 클래스 배포 → `platform-metadata-deploy`

**핵심 책무:** Callable 생성 / Callable 검토 / 120점 검증·채점 / Industries 호환성 보장.

---

## 워크플로 / 단계 (4-Phase 패턴)

### Phase 1 — Requirements Gathering
다음을 묻는다: 진입점(OmniScript, Integration Procedure, DataRaptor 등 Industries hook), action 이름(`call`에 넘기는 문자열), 입출력 계약(필수 키·타입·응답 형태), 데이터 접근 요구(객체/필드, CRUD/FLS 규칙), 부수효과(DML, callout, async 요구).

그다음:
1. 기존 callable 클래스 스캔: `Glob: **/*Callable*.cls`
2. Industries 확장에 쓰이는 공유 유틸/베이스 클래스 식별
3. task list 작성

### Phase 2 — Design & Contract Definition
callable 계약 정의: action 목록(명시적·버전된 문자열), input 스키마(필수 키 + 타입), output 스키마(일관된 응답 envelope).

**권장 응답 envelope:**
```
// 구조 예시 — 실제 동작 코드 아님
{
  "success": true|false,
  "data": {...},
  "errors": [ { "code": "...", "message": "..." } ]
}
```

**Action dispatch 규칙:** `switch on action` 사용 / default case는 typed exception throw / 동적 메서드 호출·reflection 금지.

**VlocityOpenInterface 계약 매핑** — 레거시 Open Interface(또는 dual 지원) 설계 시 시그니처를 매핑한다:
```
invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options)
```

| Parameter | Role | Callable equivalent |
|-----------|------|---------------------|
| `methodName` | Action selector (`action`과 동일 의미) | `call(action, args)`의 `action` |
| `inputMap` | 주 입력 데이터 (필수 키·타입) | `args.get('inputMap')` |
| `outputMap` | 결과를 쓰는 가변 맵 (out-by-reference) | 반환값; Callable은 envelope 반환 |
| `options` | 추가 컨텍스트 (부모 DataRaptor/OmniScript 컨텍스트, 호출 메타데이터) | `args.get('options')` |

Open Interface 계약 설계 규칙: `inputMap`·`options`를 결합 입력 스키마로 취급 / action별로 `outputMap`에 쓸 키 정의(성공·오류 케이스) / `methodName` 문자열을 Callable `action` 문자열과 정렬 / action별로 `options`가 필수·선택·미사용인지 문서화.

### Phase 3 — Implementation Pattern
- **Vanilla `System.Callable`**(flat args, Open Interface 결합 없음): `assets/pattern_callable_vanilla.cls`를 먼저 읽고 생성.
- **Callable skeleton**(VlocityOpenInterface와 동일 입력): `assets/pattern_callable_openinterface.cls`를 읽고 `args`에 `inputMap`·`options` 키 사용.

**Input format:** 호출자는 `args`를 `{ 'inputMap' => Map<String,Object>, 'options' => Map<String,Object> }`로 넘긴다. flat 호출자 하위 호환을 위해 `args`에 `'inputMap'`이 없으면 `args` 자체를 inputMap으로 보고 `options`는 빈 맵으로 처리.

**구현 규칙:**
1. `call()`은 얇게 유지하고 private 메서드/서비스 클래스에 위임
2. 입력 타입을 조기에 검증·강제(null-safe)
3. CRUD/FLS·sharing 강제 (`with sharing`, `Security.stripInaccessible()`)
4. args에 레코드 컬렉션이 있으면 bulkify
5. 적절한 경우 SOQL에 `WITH USER_MODE` 사용
6. **네임스페이스 처리:** `System.Callable`은 표준 인터페이스(prefix 불필요), `omnistudio.VlocityOpenInterface2`는 managed `omnistudio` 패키지 네임스페이스 — 항상 한정(qualify). 네임스페이스 managed 패키지 배포 시 사용자에게 prefix를 물어 커스텀 클래스명에 적용(예: `myns__Industries_XxxCallable`)

**VlocityOpenInterface / VlocityOpenInterface2 구현 시그니처:**
```apex
global Boolean invokeMethod(String methodName, Map<String, Object> inputMap,
                           Map<String, Object> outputMap, Map<String, Object> options)
```
`assets/pattern_openinterface.cls`를 먼저 읽는다(`switch on` dispatch + `outputMap` 계약 포함 완전한 `VlocityOpenInterface2` skeleton).

Open Interface 구현 규칙: 결과는 `putAll()`/`put()`으로 `outputMap`에 기록(envelope를 `invokeMethod`에서 반환하지 않음) / 성공 `true`, 미지원·실패 `false` 반환 / Callable과 동일한 내부 private 메서드(`inputMap`·`options`) 사용, 진입점만 다름 / `outputMap`에 동일 envelope 형태(`success`, `data`, `errors`) 채움. Callable·Open Interface 모두 동일 입력을 받고 동일 private 메서드 시그니처에 위임.

### Phase 4 — Testing & Validation
최소 테스트: **Positive**(지원 action 성공 실행), **Negative**(미지원 action 예외), **Contract**(누락·잘못된 입력은 error envelope), **Bulk**(list 입력을 limit 없이 처리). `assets/pattern_test_class.cls`(positive·negative·contract·bulk·null-args 케이스 포함)를 먼저 읽는다.

### Migration: VlocityOpenInterface → System.Callable
action 이름(`methodName`)을 `action` 문자열로 보존 / `inputMap`·`options`를 `args` 키로 전달 / `outMap` 변경 대신 일관 envelope 반환 / `call()`은 얇게, `(inputMap, options)` 시그니처 내부 메서드에 위임 / action별·미지원 action 테스트 추가. `assets/pattern_migration.cls`(VlocityOpenInterface2 → System.Callable before/after 주석 예제)를 먼저 읽는다.

---

## 핵심 규칙·가드레일

### 120-Point Scoring
| Category | Points | Key Rules |
|----------|--------|-----------|
| Contract & Dispatch | 20 | 명시적 action 목록; `switch on`; 버전된 action 문자열 |
| Input Validation | 20 | 필수 키 검증; 타입 안전 coerce; null guard |
| Security | 20 | `with sharing`; CRUD/FLS 체크; `Security.stripInaccessible()` |
| Error Handling | 15 | Typed exception; 일관 error envelope; empty catch 금지 |
| Bulkification & Limits | 20 | 루프 내 SOQL/DML 금지; list 입력 지원 |
| Testing | 15 | Positive/negative/contract/bulk 테스트 |
| Documentation | 10 | 클래스·action 메서드에 ApexDoc (`/** ... */`) |

**Thresholds:** ✅ 90+ (Ready) / ⚠️ 70-89 (Review) / ❌ <70 (Block)

### ⛔ Guardrails (Mandatory)
다음이 도입되려 하면 멈추고 사용자에게 묻는다: 사용자 입력 기반 동적 메서드 실행(reflection 금지) / 루프 내 SOQL·DML / callable 클래스에 `without sharing` / silent failure(empty catch, swallowed exception) / action 간 응답 형태 불일치.

### Gotchas (발췌)
- 호출자가 flat args를 넘기는데 코드가 `inputMap` 키 기대 → `'inputMap'` 없으면 `args` 자체를 input map으로 방어 처리
- `call()`이 `args=null` 수신 → 키 접근 전 항상 null-check, null이면 빈 맵으로 초기화
- 모든 action이 동일 envelope 타입(`Map<String, Object>`) 반환 보장(mixed return은 호출자 깨짐)
- VlocityOpenInterface2 마이그레이션이 `outputMap`을 reference로 읽던 호출자를 깸 → Callable 전환 후 호출자는 반환값을 읽도록 갱신
- `IndustriesCallableException` 클래스 누락 → callable 클래스와 함께 배포(매 배포 패키지에 포함)
- 한 action에 레거시 Open Interface와 새 Callable이 동시에 연결 → 한 진입점만 활성, callable 확인 후 구 인터페이스 비활성화

### Common Anti-Patterns
`call()`에 비즈니스 로직 포함(위임 안 함) / action 이름 미버전·미문서화 / input 맵 키를 검증 없이 가정 / mixed 응답 타입(Map/String 혼용) / 미지원 action 테스트 없음.

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `assets/pattern_callable_vanilla.cls` | Phase 3 — vanilla `System.Callable` skeleton (flat args) |
| `assets/pattern_callable_openinterface.cls` | Phase 3 — `inputMap`/`options` args Callable skeleton (Open Interface 호환) |
| `assets/pattern_openinterface.cls` | Phase 3 — `VlocityOpenInterface2` skeleton (`switch on` + `outputMap`) |
| `assets/pattern_test_class.cls` | Phase 4 — 테스트 클래스 skeleton (positive/negative/contract/bulk/null-args) |
| `assets/pattern_migration.cls` | Migration — VlocityOpenInterface2 → System.Callable before/after 예제 |
| `examples/Test_QuoteByProductCallable/` | `WITH USER_MODE` SOQL·error envelope 완전 구현 + 테스트 + 커스텀 예외 + TRANSCRIPT |
| `examples/Test_VlocityOpenInterfaceConversion/` | 레거시 `VlocityOpenInterface` 마이그레이션 예제 |
| `examples/Test_VlocityOpenInterface2Conversion/` | `VlocityOpenInterface2` 마이그레이션 예제 (remote class 포함) |

**Output (산출물):** `<ClassName>.cls`(switch on action dispatch), `<ClassName>Test.cls`(positive·negative·contract·bulk), `IndustriesCallableException.cls`(없을 경우).

**Reference Skill:** `skills/platform-apex-generate/SKILL.md`의 Apex 표준·테스트 패턴·가드레일을 사용.

---

## 관련 노트
- [[omnistudio-integration-procedure-generate]]
- [[omnistudio-datamapper-generate]]
- [[omnistudio-omniscript-generate]]
- [[omnistudio-dependencies-analyze]]
