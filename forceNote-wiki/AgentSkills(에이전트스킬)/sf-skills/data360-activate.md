---
tags: [agent-skill, sf-skills, data-cloud, data360, activate, data-action]
source: forcedotcom/sf-skills (skills/data360-activate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-activate, 데이터클라우드 액티베이트, Data Cloud Act phase, activation, activation target, data action, 다운스트림 전달]
---

# data360-activate — Data Cloud Act 단계

> Data Cloud 다운스트림 전달 작업: activations, activation targets, data actions, data action targets — Data Cloud 오디언스·데이터를 다른 시스템으로 푸시.

## 목적과 활성화 조건

사용자가 **다운스트림 전달 작업**이 필요할 때 사용한다: activations, activation targets, data actions, Data Cloud 출력을 다른 시스템으로 푸시.

- **TRIGGER:** activations, activation targets, data actions, Data Cloud 오디언스·데이터의 다운스트림 전달 관리.
- **DO NOT TRIGGER:** segment 생성([[data360-segment]]) / 데이터 검색·search([[data360-query]]) / STDM·세션 트레이싱(agentforce-observe).
- **호환성:** 외부 커뮤니티 `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우
- `sf data360 activation *` · `sf data360 activation-target *` · `sf data360 data-action *` · `sf data360 data-action-target *`
- 다운스트림 전달 셋업 검증

위임: 오디언스·인사이트 구축 중 → [[data360-segment]] / query·search·search index 탐색 → [[data360-query]] / 기본 연결·ingestion 셋업 → [[data360-connect]], [[data360-prepare]].

### 먼저 수집할 컨텍스트
대상 org alias, 목적지 플랫폼/다운스트림 시스템, segment 존재·publish 여부, create·inspect·update·delete 필요 여부, 작업이 activation 중심인지 data-action 중심인지.

## 워크플로 / 단계

### 1. act 작업 readiness 분류
```bash
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase act --json
```

### 2. 목적지 먼저 검사
```bash
sf data360 activation platforms -o <org> 2>/dev/null
sf data360 activation-target list -o <org> 2>/dev/null
sf data360 data-action-target list -o <org> 2>/dev/null
```

### 3. activation 전에 목적지를 먼저 생성
```bash
sf data360 activation-target create -o <org> -f target.json 2>/dev/null
sf data360 data-action-target create -o <org> -f target.json 2>/dev/null
```

### 4. activation 또는 data action 생성
```bash
sf data360 activation create -o <org> -f activation.json 2>/dev/null
sf data360 data-action create -o <org> -f action.json 2>/dev/null
```

### 5. 다운스트림 readiness 검증
```bash
sf data360 activation list -o <org> 2>/dev/null
sf data360 activation data -o <org> --name <activation> 2>/dev/null
```

## 핵심 규칙·가드레일

- 다운스트림 전달 자산 생성 전 업스트림 segment/insight가 건강한지 검증한다.
- activation 자산 변경 전 공유 readiness 분류기를 실행한다.
- activation 셋업 변경 전 사용 가능한 플랫폼·타겟을 검사한다.
- 가능한 한 목적지 정의를 결정적·재사용 가능하게 유지한다.
- 다운스트림 자격증명·플랫폼 제약을 별도 검증 관심사로 취급한다.
- 목적지 상태가 불분명하면 읽기 전용 검사를 먼저 선호한다.

### High-Signal Gotchas
- Activation 설계는 건강한 publish된 업스트림 segment에 의존한다.
- 목적지 구성은 보통 activation 생성보다 먼저 온다.
- 다운스트림 자격증명·플랫폼 제약은 Data Cloud CLI 단독 밖에 존재할 수 있다.
- 목적지 셋업이 불분명할 때 읽기 전용 검사가 가장 안전한 첫 행동.
- `CdpActivationTarget` 또는 `CdpActivationExternalPlatform`는 activation 표면이 현재 org/user에 게이팅됨을 의미 — 맹목적 재시도 대신 activation 셋업·권한·목적지 구성으로 안내.

### 출력 포맷
```text
Act task: <activation / activation-target / data-action / data-action-target>
Destination: <platform or target>
Target org: <alias>
Artifacts: <definition files / commands>
Verification: <listed / created / blocked>
Next step: <destination validation or downstream testing>
```

## 번들 파일

| 분류 | 파일 |
|---|---|
| 공유 참조 (orchestrate) | `README.md`, `UPSTREAM.md`, `references/plugin-setup.md`, `references/feature-readiness.md` |
| assets/definitions (4 템플릿) | `activation-target.template.json`, `activation.template.json`, `data-action-target.template.json`, `data-action.template.json` |

## 관련 노트
- [[data360-orchestrate]]
- [[data360-segment]]
- [[data360-query]]
- [[data360-connect]]
