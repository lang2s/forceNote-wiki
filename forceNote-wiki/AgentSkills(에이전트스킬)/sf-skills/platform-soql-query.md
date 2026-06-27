---
tags: [agent-skill, sf-skills, platform, soql, query-optimization]
source: forcedotcom/sf-skills (skills/platform-soql-query/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-soql-query, SOQL 쿼리 생성, SOQL optimization, relationship query, aggregate query, selectivity 분석, SOSL]
---

# platform-soql-query — Salesforce SOQL 쿼리 전문가

> SOQL/SOSL 작성·최적화: 자연어→쿼리 생성, relationship 쿼리, aggregate, query-plan 분석, 성능/안전 개선. 100점 채점.

---

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER when:** 사용자가 SOQL/SOSL을 작성·최적화·디버그하거나, `.soql` 파일을 다루거나, relationship 쿼리·aggregate·query 성능을 물을 때.

**DO NOT TRIGGER:** 대량 데이터 작업(→ `platform-data-manage`), Apex DML 로직(→ `platform-apex-generate`), report/dashboard 쿼리.

### 이 스킬이 작업을 소유할 때
- `.soql` 파일
- 자연어로부터 쿼리 생성
- relationship 쿼리와 aggregate 쿼리
- query 최적화·selectivity 분석
- SOQL/SOSL 구문과 governor-aware 설계

### 다른 곳에 위임
- 대량 데이터 작업 → `platform-data-manage`
- 더 넓은 Apex 구현 안에 쿼리 로직 임베딩 → `platform-apex-generate`
- 쿼리 shape가 아닌 로그로 디버깅 → `platform-apex-logs-debug`

### 먼저 수집할 컨텍스트
대상 오브젝트 · 필요한 필드 · 필터 기준 · sort/limit 요구 · 쿼리 용도(display/automation/reporting-like/Apex usage) · 성능·selectivity가 이미 우려인지.

---

## 워크플로 / 단계

### 1. 가장 단순한 올바른 쿼리 생성
필요한 필드만 · 명확한 WHERE · 적절 시 합리적 LIMIT · 필요한 만큼만 relationship 깊이.

### 2. 올바른 쿼리 shape 선택
| 필요 | 기본 패턴 |
|---|---|
| child에서 parent 데이터 | child-to-parent traversal |
| parent에서 child 행 | subquery |
| count / rollup | aggregate query |
| 관련 행 유무 레코드 | semi-join / anti-join |
| 오브젝트 간 텍스트 검색 | SOSL |

### 3. selectivity·안전 최적화
indexed/selective 필터 · 불필요 필드 없음 · 회피 가능한 wildcard·scan-heavy 패턴 없음 · 보안 enforcement 기대 확인.

### 4. 필요 시 실행 경로 검증
런타임 검증이 필요하면 실행을 `platform-data-manage`에 위임.

### CLI 명령 (verbatim — `references/cli-commands.md`)
```bash
# Run a query
sf data query \
  --query "SELECT Id, Name, Industry FROM Account LIMIT 10" \
  --target-org my-sandbox

# Child-to-parent
sf data query \
  --query "SELECT Id, Name, Account.Name FROM Contact LIMIT 10" \
  --target-org my-sandbox

# Parent-to-child
sf data query \
  --query "SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account LIMIT 5" \
  --target-org my-sandbox

# Query plan (selectivity 분석)
sf api request rest '/query/?explain=<SOQL>' --target-org alias
```

---

## 핵심 규칙·가드레일

### High-Signal Rules
- `SELECT *` 식 사고 금지 — 필요한 필드만 쿼리.
- Apex 컨텍스트에서 loop 안 쿼리 금지.
- Apex post-filtering 대신 SOQL에서 필터링 선호.
- count·grouped 요약엔 불필요 레코드 로드 대신 aggregate 사용.
- wildcard 사용 신중 평가 — leading wildcard는 인덱스를 무력화하는 경우가 많다.
- 쿼리가 Apex로 들어갈 때 security mode / field access 요구사항 고려.

### Output Format
순서: ① 쿼리 목적 ② 최종 SOQL/SOSL ③ 이 shape를 택한 이유 ④ 최적화/보안 노트 ⑤ 필요 시 실행 제안. 정확한 구문은 `references/soql-syntax-reference.md` 사용.

```text
Query goal: <summary>
Query: <soql or sosl>
Design: <relationship / aggregate / filter choices>
Notes: <selectivity, limits, security, governor awareness>
Next step: <run in platform-data-manage or embed in Apex>
```

### Score Guide (100점)
| Score | 의미 |
|---|---|
| 90+ | production-optimized 쿼리 |
| 80–89 | minor 개선 여지 있는 good 쿼리 |
| 70–79 | 동작하나 성능 우려 잔존 |
| < 70 | 프로덕션 전 수정 필요 |

---

## 번들 파일

`references/`:
- `soql-syntax-reference.md` — 구문, 연산자, date literal, relationship 쿼리 패턴
- `query-optimization.md` — selectivity 규칙, 인덱싱 전략, governor limit, 보안 패턴
- `soql-reference.md` — quick ref(연산자·date 함수·aggregate 함수·WITH 절)
- `anti-patterns.md` — 흔한 SOQL 실수와 수정 — 쿼리 확정 전 필독
- `selector-patterns.md` — Apex selector layer 패턴 — Apex 클래스 임베딩 시
- `field-coverage-rules.md` — field coverage 검증 — Apex 내부 SOQL 생성 시
- `cli-commands.md` — sf CLI 쿼리 실행·bulk export·query plan 명령

`assets/`:
- `basic-queries.soql` · `relationship-queries.soql` · `aggregate-queries.soql` · `optimization-patterns.soql`
- `bulkified-query-pattern.cls` — trigger 컨텍스트용 Map 기반 bulk 쿼리 패턴
- `selector-class.cls` — 전체 selector 클래스 구현 템플릿

`scripts/post-tool-validate.py` — post-write hook: `.soql` 편집 후 static SOQL 검증 + live query plan 분석

`README.md` · `CREDITS.md` · `SKILL.md`

### Cross-Skill Integration
| 필요 | 위임 | 이유 |
|---|---|---|
| org에 쿼리 실행 | `platform-data-manage` | 실행·export |
| service/selector에 쿼리 임베딩 | `platform-apex-generate` | 구현 컨텍스트 |
| 로그로 slow-query 증상 분석 | `platform-apex-logs-debug` | 런타임 증거 |
| query-backed UI 연결 | `experience-lwc-generate` | 프론트엔드 통합 |

---

## 관련 노트
- [[platform-data-manage]]
- [[platform-apex-generate]]
- [[platform-apex-logs-debug]]
- [[SOQL 문법 레퍼런스]] — SELECT 전체 문법 위키 레퍼런스
- [[Dynamic SOQL]] — 동적 쿼리·인젝션 방어
- [[SOQL 패턴]] — selectivity·벌크 쿼리 패턴
