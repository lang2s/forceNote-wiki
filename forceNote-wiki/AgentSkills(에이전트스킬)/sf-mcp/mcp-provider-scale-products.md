---
tags: [sf-mcp, mcp, salesforce-dx, scale-products, tools, apex, antipatterns]
source: salesforcecli/mcp (packages/mcp-provider-scale-products/, 공식 Salesforce)
created: 2026-06-27
aliases: [mcp-provider-scale-products, Apex 안티패턴 스캐너, scan-apex-antipatterns, SOQL 안티패턴, 스케일 분석 MCP]
---

# mcp-provider-scale-products — Apex 안티패턴 스캐너

> Salesforce Scale Products 제품군(ApexGuru · Scale Test · Scale Center)을 위한 MCP provider. `.cls`/`.trigger` 파일을 AST로 분석해 성능 안티패턴(GGD · SOQL no-WHERE/LIMIT · SOQL 미사용 필드)을 탐지하고, org 연결 시 ApexGuru 런타임 지표로 severity를 보정한다.

---

## 역할

`@salesforce/mcp-provider-api`의 `McpProvider`를 구현하는 패키지로, 단일 도구 `scan_apex_class_for_antipatterns`를 제공한다. README상 **내부 사용 전용(For Internal Use Only)** 패키지이며 버전 간 호환 보장이 없다.

- Provider 클래스: `ScaleProductsMcpProvider` (`getName()` → `"ScaleProductsMcpProvider"`)
- `provideTools(services)`는 `ScanApexAntipatternsTool` 하나만 등록한다. `provideResources`/`providePrompts`는 메인 서버가 아직 소비하지 않아 구현하지 않는다.
- 대상 제품군: [ApexGuru](https://help.salesforce.com/s/articleView?id=xcloud.apexguru_overview.htm&type=5), Scale Test, [Scale Center](https://help.salesforce.com/s/articleView?id=xcloud.scale_center_overview.htm&type=5). 성능 병목 식별·Apex 최적화·피크 부하 대비 확장성 확보가 목적.

### 동작 모드 두 가지

| 모드 | 조건 | severity 산정 |
|---|---|---|
| **정적 분석 전용** | org 미연결(`usernameOrAlias` 미제공 또는 연결 실패) | 코드 구조 기반 정적 heuristic (loop 내부 = 높은 severity 등). `severitySource: "static"` |
| **런타임 인식** | org 연결 + ApexGuru/Scale Center 활성 | 실제 프로덕션 실행 지표로 severity 재계산. `severitySource: "runtime"` → 출력에 💡 표시 |

> org가 없어도 **모든 안티패턴은 그대로 탐지**된다. 달라지는 것은 severity 산정 근거뿐이다.

---

## 제공 도구 — `scan_apex_class_for_antipatterns`

- **이름:** `scan_apex_class_for_antipatterns`
- **타이틀:** "Scan Apex Class for Antipatterns"
- **릴리즈 상태:** `ReleaseState.GA`
- **toolset:** `Toolset.SCALE_PRODUCTS` (MCP config에서 `--toolsets scale-products`로 스코프 권장)
- **annotation:** `readOnlyHint: true` (파일을 읽기만 하고 수정하지 않음)
- **설명 요지:** Apex 클래스 파일을 성능 안티패턴 관점에서 분석하고 수정 권고를 제공. loop 내부 사용 등 severity를 구분. 설명에는 "org alias/username이 요청에 없으면 `#get_username` 툴을 호출해 기본 org username을 해석하라"는 지시가 포함됨.

### 입력 파라미터 (zod 스키마)

| 파라미터 | 필수 | 설명 |
|---|---|---|
| `className` | Yes | 스캔할 Apex 클래스 이름 (예: `AccountController`) |
| `apexFilePath` | Yes | 분석할 `.cls` 파일의 **절대 경로** |
| `directory` | Yes | 작업 디렉터리(SFDX 프로젝트 루트) 절대 경로. `shared/params`의 `directoryParam` |
| `usernameOrAlias` | No | 런타임 인사이트용 org username/alias. `shared/params`의 `usernameOrAliasParam` |
| `identifier` | No | 이 스캔의 고유 식별자(예: `orgId:className`). 미제공 시 `className`으로 기본값 |

> README 표는 `.cls` 또는 `.trigger`를 허용한다고 명시(파일 확장자 검증도 `['.cls', '.trigger']` 둘 다 허용). 단 `apexFilePath` 입력 스키마 description은 `.cls`만 언급한다.

### 실행 흐름 (`exec`)

1. `process.chdir(input.directory)`로 작업 디렉터리 이동.
2. `resolveOrgConnection(usernameOrAlias)` — username/alias가 있을 때만 연결 시도. 없으면 `null` 반환 → 정적 전용.
3. 텔레메트리(`ScaleTelemetryService.emitToolInvocation`) 발행.
4. 파일 검증: 존재 여부 → 디렉터리 아님 → 확장자(`.cls`/`.trigger`) 확인. 실패 시 `isError: true` 텍스트 반환.
5. org가 있으면 `fetchRuntimeData`로 ApexGuru Connect 엔드포인트에서 런타임 데이터 조회.
6. 레지스트리의 모든 모듈을 순회하며 `module.scan(className, apexCode, classRuntimeData)` 실행, 탐지가 1건 이상인 결과만 수집.
7. 탐지 0건이면 "No antipatterns detected" 반환. 아니면 `formatResponse`로 LLM용 응답(presentation instructions + severity legend + JSON 결과 + 수정 지침) 생성.

```
// 구조 예시 — 실제 동작 코드 아님 (RuntimeDataService.fetchRuntimeData 호출부 요약)
GET /services/data/v{apiVersion}/scalemcp/apexguru/class-runtime-data
payload = { requestId, orgId, classes: [className] }
config   = { apiPath, timeoutMs: 30000, retryAttempts: 2 }
```

`fetchRuntimeData`는 `connection.getApiVersion()`으로 `{version}`을 `v{apiVersion}`으로 치환한다. 상수 `RUNTIME_API_BASE_PATH = "/services/data/{version}/scalemcp/apexguru/class-runtime-data"`.

### 출력 구조

도구는 안티패턴 타입별로 그룹화된 `ScanResult`를 JSON으로 담아 반환한다. 각 그룹은 `antipatternType`, 타입 전체에 적용되는 `fixInstruction`, 그리고 `detectedInstances[]`를 가진다. (README 발췌 예시)

```json
{
  "antipatternResults": [
    {
      "antipatternType": "GGD",
      "fixInstruction": "## Fix Schema.getGlobalDescribe() ...",
      "detectedInstances": [
        {
          "className": "MyClass",
          "methodName": "myMethod",
          "lineNumber": 5,
          "codeBefore": "Schema.SObjectType t = Schema.getGlobalDescribe().get('Account');",
          "severity": "major"
        }
      ]
    }
  ]
}
```

`DetectedAntipattern` 인터페이스의 필드: `className`, `methodName?`, `lineNumber`, `codeBefore`, `codeAfter?`(실제 fix를 생성하는 안티패턴용 — SOQL 미사용 필드), `severity`, `severitySource`("static"|"runtime"), `entrypoints_impacted_by_method?`, `metadata?`.

> 출력 시 `addSeverityIcons`가 내부 필드 `severitySource`를 제거하고, `severitySource === "runtime"`이면 severity 문자열 앞에 `💡`를 붙인다. presentation instructions에는 severity legend(🟡 minor / 🟠 major / 🔴 critical / 💡 런타임 지표 기반)가 포함된다.

런타임 데이터 상태(`RuntimeDataStatus`)별 안내 문구가 응답에 삽입된다: `SUCCESS`(실제 런타임 지표 기반), `ACCESS_DENIED`(ApexGuru 정적은 활성, 풀 Scale Center는 Support 문의), `NO_ORG_CONNECTION`(정적 인사이트만), `API_ERROR`(런타임 지표 fetch 실패).

---

## 안티패턴 · 리커멘더

아키텍처: **detector + recommender + runtime-enricher**를 `AntipatternModule`이 묶고, `AntipatternRegistry`가 모듈을 관리한다. `module.scan()`은 ① detector로 정적 탐지 → ② (런타임 데이터 + enricher 존재 시) enrich로 severity 보정 → ③ recommender의 `getFixInstruction()`을 fixInstruction으로 첨부, 순으로 동작한다. `AntipatternModule` 생성자는 detector/recommender의 타입 일치와 enricher의 타입 지원 여부를 검증한다.

`AntipatternType` enum 값: `GGD`, `SOQL_NO_WHERE_LIMIT`, `SOQL_UNUSED_FIELDS`.

### 1. GGD — `Schema.getGlobalDescribe()`

| 항목 | 내용 |
|---|---|
| Detector | `GGDDetector` — `@apexdevtools/apex-parser`로 AST 파싱(regex 아님). `GGDVisitor`가 메서드/loop 컨텍스트를 추적 |
| 탐지 대상 | `getGlobalDescribe` 메서드 호출 중 receiver가 `schema.`로 시작(대소문자 무시)하는 것 |
| 정적 severity | **항상 `Severity.CRITICAL`** (코드 주석: 테스트 요구사항상 GGD는 항상 CRITICAL, enricher가 런타임으로 조정 가능) |
| loop 추적 | `for`/`while`/`do-while` 방문 시 `loopDepth` 증감으로 컨텍스트 보유 (README상 loop 내부는 더 높은 severity) |
| Recommender | `GGDRecommender` → `GGD_FIX_INSTRUCTIONS`. `Type.forName()` 또는 직접 SObject 토큰으로 대체 권고 |
| Enricher | `MethodRuntimeEnricher` (메서드명 매칭) |

### 2. SOQL_NO_WHERE_LIMIT — WHERE/LIMIT 없는 SOQL

| 항목 | 내용 |
|---|---|
| Detector | `SOQLNoWhereLimitDetector` — `SOQLAstUtils.extractSOQLQueries()`로 쿼리 추출 |
| 탐지 대상 | `!queryInfo.hasWhere && !queryInfo.hasLimit` — WHERE **와** LIMIT 둘 다 없는 쿼리 |
| 정적 severity | `Severity.MAJOR` |
| Recommender | `SOQLNoWhereLimitRecommender` → `getSOQLNoWhereLimitFixInstructions()`. 필터/행 제한 추가로 governor limit 회피 |
| Enricher | `SOQLRuntimeEnricher` (lineNumber 매칭) |

### 3. SOQL_UNUSED_FIELDS — 미사용 필드를 SELECT하는 SOQL

| 항목 | 내용 |
|---|---|
| Detector | `SOQLUnusedFieldsDetector` — AST 파싱 + `SOQLUnusedFieldsVisitor`로 변수 할당 추적 |
| 탐지 대상 | SELECT했으나 이후 코드에서 한 번도 참조되지 않는 필드 (단, 전체 필드가 미사용이면 제외 — `unusedFields.length < soql.fields.length`) |
| 정적 severity | loop 내부면 `Severity.MAJOR`, 아니면 `Severity.MINOR` |
| 특이점 | 다른 안티패턴과 달리 **실제 수정 코드(`codeAfter`)를 생성**. `metadata`에 `unusedFields[]`·`assignedVariable` 보유 |
| Recommender | `SOQLUnusedFieldsRecommender` → `SOQL_UNUSED_FIELDS_FIX_INSTRUCTION`. `recommend()`가 `SOQLParser.removeUnusedFields()`로 최적화 SOQL 생성 |
| Enricher | `SOQLRuntimeEnricher` (lineNumber 매칭) |

**SOQLUnusedFields의 분석 정교화 로직:**
- **2-line distance rule**: SOQL 직전 변수 선언과 쿼리 라인 거리가 ≤2면 그 변수를 할당 변수로 간주.
- **제외(skip) 조건** (`shouldSkipAnalysis`): ① 할당 변수 없음, ② 변수가 메서드에서 return됨(`isReturnedInCode`), ③ 변수가 클래스 멤버 필드, ④ SOQL 결과 전체가 사용됨(`checkIfCompleteSOQLResultsAreUsed`).
- **시스템 필드 제외**: `Id`, `COUNT()` 등은 `excludeSystemFields`로 제외.
- **사용 판정**: 직접 멤버 접근(`var.Field`, `findDirectFieldAccess`) + 이후 SOQL에서의 사용(`findColumnsUsedInLaterSOQLs`)을 합산.
- **for-each SOQL 처리**: `for (Type var : [SELECT ...])` enhanced-for의 루프 변수를 할당 변수로 추적.
- **fix 생성 안전장치** (`generateFixedSOQL`): 중첩 쿼리(`hasNestedQueries`)면 빈 문자열, 미사용 필드가 전체 필드 이상이면 빈 문자열 반환. FROM/WHERE/LIMIT/ORDER BY 절은 보존.

### Severity 모델

`Severity` enum: `MINOR = "minor"`, `MAJOR = "major"`, `CRITICAL = "critical"`.

README 정의 — Minor: 품질 기준에서 벗어남, 편할 때 수정 / Major: 사용성 저하 또는 핵심 기능 실패 유발 / Critical: 최우선, 소프트웨어 실패를 초래하는 런타임·횟수 등.

### Runtime Enricher 와 severity 재계산

org 연결 + 런타임 데이터가 있으면 정적 severity가 ApexGuru parity 임계값 기준으로 덮어써진다(`severitySource: "runtime"`, 💡 표시).

**`SOQLRuntimeEnricher`** (`SOQL_NO_WHERE_LIMIT`, `SOQL_UNUSED_FIELDS` 지원)
- `uniqueQueryIdentifier`(형식 `ClassName.cls.LINE`)에서 라인 번호를 파싱해 `detection.lineNumber`와 매칭.
- COCOD(= `representativeCount`) 기반 `calculateSOQLSeverity`:
  - COCOD ≤ 1,000 → **MINOR**
  - 1,000 < COCOD ≤ 10,000,000 → **MAJOR**
  - COCOD > 10,000,000 → **CRITICAL**
  - 기본 임계값: `DEFAULT_SOQL_THRESHOLDS = { criticalCocodCount: 10000000, majorCocodCount: 1000 }`
- 표시 문구: `Query executed {representativeCount} times, total execution time: {totalQueryExecutionTime}ms`.

**`MethodRuntimeEnricher`** (`GGD` 지원)
- `detection.methodName`을 `runtimeData.methods[].methodName`과 매칭(소문자 변환 — Apex 메서드명은 대소문자 무시).
- 엔트리포인트 평균 CPU 시간 기반 `calculateMethodSeverity`:
  - 엔트리포인트 매핑 없음 → **MINOR**
  - 매핑 있음 → **MAJOR**
  - 임의 엔트리포인트의 `avgCpuTime > 2,000ms` → **CRITICAL**
  - 기본 임계값: `DEFAULT_METHOD_THRESHOLDS = { criticalAvgCpuTime: 2000 }`
- 표시 문구: 상위 3개 엔트리포인트(sumCpuTime 내림차순) 이름 + 총 CPU/DB 시간(초 단위).

`RuntimeEnricherRegistry`가 enricher를 타입별로 등록·조회한다. 런타임 데이터 모델은 `ClassRuntimeData { methods[], soqlRuntimeData[] }`이며, 메서드는 `MethodRuntimeData { methodName, entrypoints[] }`, 엔트리포인트는 `EntrypointData { entrypointName, avgCpuTime, avgDbTime, sumCpuTime, sumDbTime }`, SOQL은 `SOQLRuntimeData { uniqueQueryIdentifier, representativeCount, totalQueryExecutionTime }`로 구성된다.

---

## 모범 사용 (README)

- **툴 실행 스코프 지정:** MCP config에서 `--toolsets scale-products`로 제한해 호스트의 툴 해석 정확도를 높인다. 등록 툴이 너무 많으면 올바른 툴 선택이 어려움.
- **툴 명시적 참조:** 프롬프트에서 `scan_apex_class_for_antipatterns`를 이름으로 직접 지칭한다.
- **런타임 인사이트용 org 설정:** 기본 타깃 org를 지정(`sf config set target-org ...`)하거나 프롬프트에서 `usernameOrAlias`를 명시. 단 org에 ApexGuru/Scale Center 활성 필요(access-denied 시 Salesforce Support 문의).

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
- [[mcp-provider-code-analyzer]]
