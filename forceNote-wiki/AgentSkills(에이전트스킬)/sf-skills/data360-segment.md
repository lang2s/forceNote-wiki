---
tags: [agent-skill, sf-skills, data-cloud, data360, segment, calculated-insight]
source: forcedotcom/sf-skills (skills/data360-segment/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-segment, 데이터클라우드 세그먼트, Data Cloud Segment phase, segment, calculated insight, 오디언스, audience, 세그먼트 SQL]
---

# data360-segment — Data Cloud Segment 단계

> Data Cloud 오디언스·인사이트 작업: segments, calculated insights, publish 워크플로, member counts, Data Cloud segment SQL 트러블슈팅.

## 목적과 활성화 조건

사용자가 **오디언스 및 인사이트 작업**이 필요할 때 사용한다: segments, calculated insights, publish 워크플로, member counts, Data Cloud segment SQL 트러블슈팅.

- **TRIGGER:** segment 생성·publish, calculated insight 관리, segment count·membership 검사, audience SQL 트러블슈팅.
- **DO NOT TRIGGER:** DMO·mapping·identity-resolution([[data360-harmonize]]) / activation([[data360-activate]]) / query·search-index([[data360-query]]) / STDM·세션 트레이싱(agentforce-observe).
- **호환성:** 외부 커뮤니티 `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우
- `sf data360 segment *` · `sf data360 calculated-insight *`
- segment publish 워크플로
- member counts·segment 트러블슈팅
- calculated insight 실행·검증

위임: DMO·mapping·IR 구축 → [[data360-harmonize]] / segment 다운스트림 활성화 → [[data360-activate]] / 읽기 전용 SQL·search-index → [[data360-query]].

### 먼저 수집할 컨텍스트
대상 org alias, 통합 DMO 또는 base entity 이름, 작업이 create·publish·inspect·troubleshoot 중 무엇인지, 자산이 segment인지 calculated insight인지, 기대 성공 지표(member count·aggregate value·publish status).

## 워크플로 / 단계

### 1. segment readiness 분류
```bash
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase segment --json
```

### 2. 현재 상태 검사
```bash
sf data360 segment list -o <org> 2>/dev/null
sf data360 calculated-insight list -o <org> 2>/dev/null
```

### 3. 재사용 가능 JSON 정의로 생성
```bash
sf data360 segment create -o <org> -f segment.json --api-version 64.0 2>/dev/null
sf data360 calculated-insight create -o <org> -f ci.json 2>/dev/null
```

### 4. 명시적으로 publish 또는 run
```bash
sf data360 segment publish -o <org> --name My_Segment 2>/dev/null
sf data360 calculated-insight run -o <org> --name Lifetime_Value 2>/dev/null
```

### 5. count 또는 SQL로 검증
```bash
sf data360 segment count -o <org> --name My_Segment 2>/dev/null
sf data360 query sql -o <org> --sql 'SELECT COUNT(*) FROM "UnifiedssotIndividualMain__dlm"' 2>/dev/null
```

## 핵심 규칙·가드레일

- Data Cloud segment SQL을 CRM SOQL과 구별해서 취급한다.
- 오디언스 자산 변경 전 `data360-orchestrate` 스킬의 공유 readiness 분류기를 실행한다.
- 반복 가능한 segment·CI 생성엔 재사용 가능 JSON 정의를 선호한다.
- 최신 기본값에서 segment 생성 동작이 불안정하면 `--api-version 64.0`을 사용.
- publish/run 단계 후 성공을 가정하지 말고 count·SQL로 검증.
- 읽기 가능한 member 디테일이 필요하면 `segment members` 대신 SQL join을 사용.

### High-Signal Gotchas
- Segment 생성은 `--api-version 64.0`이 필요할 수 있다.
- `segment members`는 불투명 ID를 반환 — 사람이 읽을 member 디테일엔 SQL join 사용.
- Segment SQL은 SOQL이 아니다.
- Calculated insight 자산과 segment SQL은 제약이 서로 다르다.
- publish/run 단계는 명령이 빨리 반환돼도 비동기 작업을 시작할 수 있다.
- 빈 segment·calculated-insight 목록은 보통 모듈이 도달 가능하지만 미구성임을 의미(사용 불가 아님).

### 출력 포맷
```text
Segment task: <segment / calculated-insight>
Action: <create / publish / inspect / troubleshoot>
Target org: <alias>
Artifacts: <definition files / commands>
Verification: <member count / query result / publish state>
Next step: <act / retrieve / follow-up>
```

## 번들 파일

| 분류 | 파일 |
|---|---|
| 공유 참조 (orchestrate) | `README.md`, `references/feature-readiness.md`, `UPSTREAM.md` |
| assets/definitions (2 템플릿) | `calculated-insight.template.json`, `segment.template.json` |

## 관련 노트
- [[data360-orchestrate]]
- [[data360-harmonize]]
- [[data360-activate]]
- [[data360-query]]
