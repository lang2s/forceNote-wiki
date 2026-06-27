---
tags: [agent-skill, sf-skills, integration, managed-event-subscription, pub-sub-api, event-replay]
source: forcedotcom/sf-skills (skills/integration-eventing-subscription-configure/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [integration-eventing-subscription-configure, 관리형 이벤트 구독 구성, ManagedEventSubscription, event replay, topicName, defaultReplay, Pub/Sub API]
---

# integration-eventing-subscription-configure — ManagedEventSubscription 메타데이터 CRUD

> 플랫폼 이벤트 채널을 managed replay 추적과 함께 durable하게 구독하는 `ManagedEventSubscription` 메타데이터를 생성·읽기·수정·삭제한다.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** managed event subscription, platform event subscription, event channel subscriber, `.managedEventSubscription-meta.xml` 파일 작업; platform event 구독, managed subscription 생성, event replay 셋업, event channel subscriber 구성, replay preset 갱신, subscription 활성화/비활성화, subscription 삭제, `ManagedEventSubscription` metadata 관리.

**SKIP:** platform event channel 자체 생성 → `platform-custom-object-generate`; Flow 기반 event 구독 → `automation-flow-generate`.

**In scope:** create/read/update/delete용 `.managedEventSubscription-meta.xml` 생성·수정. **단 하나의 파일만 생성** — `.managedEventSubscription-meta.xml`. 참조하는 platform event object나 다른 metadata type은 생성하지 않음.
**Out of scope:** underlying platform event(`__e`) channel 생성, Flow/Apex 기반 구독, org 배포.

## 워크플로 / 단계

### Required Inputs

| 입력 | 설명 |
|---|---|
| **Operation** | create / read / update / delete |
| **DeveloperName** | Create에 필수(파일명이 됨); `Id`가 있으면 Read/Update/Delete에 optional. label에서 유도하지 않고 사용자에게 질문 |
| **Id** | Tooling API record Id — Read/Update/Delete 시 DeveloperName 대신 사용 가능 |
| **label** | 사람이 읽는 label(공백 허용) |
| **topicName** | event channel path — `references/topic-name-formats.md` 참조 |
| **defaultReplay** | `LATEST` 또는 `EARLIEST` (기본 `LATEST`) |
| **errorRecoveryReplay** | `LATEST` 또는 `EARLIEST` (기본 `LATEST`) |
| **state** | `RUN` 또는 `STOP` (기본 `RUN`) — `PAUSE`는 내부 전용, `INVALID_INPUT`으로 거부 |
| **version** | Metadata API version (기본 org API version과 일치, 예 `67.0`) |

### Create
1. **입력 수집** — DeveloperName, label, topicName, defaultReplay, errorRecoveryReplay, state, version 확인. 누락 필드는 기본값 적용. DeveloperName 미제공 시 사용자에게 질문(label에서 유도 금지).
2. **topic 존재 확인** — event channel이 org에 이미 있는지 사용자에게 확인. platform event object를 직접 생성하지 않음(범위 밖). 없다고 하면 멈추고 `platform-custom-object-generate`로 안내 후 복귀.
3. **템플릿 읽기** — `assets/managed-event-subscription-template.xml`을 시작 구조로 로드.
4. **파일 생성** — `managedEventSubscriptions/<DeveloperName>.managedEventSubscription-meta.xml`을 사용자 값으로 채움.
5. **검증** — 아래 체크리스트 실행.
6. **구독 안내** — 배포 후 Pub/Sub API `ManagedSubscribe` RPC에서 `DeveloperName` 또는 record `Id`로 식별. Id 조회: `SELECT Id, DeveloperName FROM ManagedEventSubscription WHERE DeveloperName='<DeveloperName>'` (Tooling API).

### Read
1. `Id` 또는 `DeveloperName`으로 식별(`Id` 우선).
2. 파일 경로 표시 — `managedEventSubscriptions/<DeveloperName>.managedEventSubscription-meta.xml`.
3. 현재 XML 내용 retrieve·표시.

### Update
1. `Id` 또는 `DeveloperName`으로 식별(`Id` 우선).
2. 기존 파일 로드 후 수정.
3. 지정 필드만 갱신, 나머지 보존.
4. `references/update-constraints.md`에서 생성 후 변경 불가 필드 확인.
5. 체크리스트 실행.

### Delete
1. `Id` 또는 `DeveloperName`으로 식별; 진행 전 사용자 확인.
2. **경고** — 삭제는 replay 추적 state를 영구 제거.
3. 파일 제거 + `destructiveChanges.xml`로 파괴적 변경 배포하는 지시 생성.
4. `references/delete-guide.md`에서 파괴적 배포 절차 확인.

`assets/managed-event-subscription-template.xml`(verbatim):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ManagedEventSubscription xmlns="http://soap.sforce.com/2006/04/metadata">
    <!-- Required: EARLIEST or LATEST — replay position on normal startup -->
    <defaultReplay>{DEFAULT_REPLAY}</defaultReplay>
    <!-- Required: EARLIEST or LATEST — replay position after an error recovery -->
    <errorRecoveryReplay>{ERROR_RECOVERY_REPLAY}</errorRecoveryReplay>
    <!-- Required: Human-readable label -->
    <label>{LABEL}</label>
    <!-- Required: RUN (active) or STOP (inactive) — PAUSE is reserved for internal use and will be rejected -->
    <state>{STATE}</state>
    <!-- Required: Event channel path — see references/topic-name-formats.md for valid formats
         Platform event:            /event/Name__e
         Custom PE channel:         /event/Name__chn
         All-objects change events: /data/ChangeEvents
         Single-object change event:/data/ObjectNameChangeEvent
         Custom change channel:     /data/Name__chn -->
    <topicName>{TOPIC_NAME}</topicName>
    <!-- Required: Metadata API version (e.g. 67.0) -->
    <version>{VERSION}</version>
</ManagedEventSubscription>
```

## 핵심 규칙·가드레일

| 제약 | 근거 |
|---|---|
| `<topicName>`은 유효한 path prefix 사용 | platform event는 `/event/Name__e`; change event는 `/data/Name`; 전체 형식은 `references/topic-name-formats.md` |
| `<defaultReplay>`·`<errorRecoveryReplay>`는 `LATEST` 또는 `EARLIEST` | 유일한 유효 enum; 그 외 값은 metadata validation 실패 |
| `<state>`는 `RUN` 또는 `STOP` | `PAUSE`는 내부 전용 — `INVALID_INPUT: You can create a managed event subscription state field only to RUN or STOP` |
| 6개 required 요소 모두 존재 | `topicName`, `defaultReplay`, `errorRecoveryReplay`, `label`, `state`, `version` — 누락 시 deploy error |
| DeveloperName은 org 내 unique | 중복 시 `DUPLICATE_DEVELOPER_NAME` |
| `<namespacePrefix>`, `<id>`, `<createdDate>` 포함 금지 | read-only 플랫폼 필드; unpackaged org에서 배포 실패 유발 |

### Gotchas

| 이슈 | 해결 |
|---|---|
| `The topicName field is invalid` | 형식 오류 또는 event 미존재 — `references/topic-name-formats.md` 확인 |
| 삭제+재생성 후 replay state 손실 | 삭제는 저장된 replay position 폐기; 재생성은 `defaultReplay`부터 시작 — 삭제 후 동일 DeveloperName 재사용 회피 |
| SOQL 쿼리에 `INVALID_TYPE` | ManagedEventSubscription은 표준 SOQL 아닌 Tooling API로만 쿼리 가능 |
| high-volume channel에 `EARLIEST` replay | 활성화 시 최대 72시간 backlog replay 유발 — 항상 사용자 확인 |
| 옛 org에서 metadata 미지원 | ManagedEventSubscription은 API v60.0+ 필요 |
| 생성 XML의 `eventChannel`·`isActive` | 잘못된 필드명 — `topicName`·`state`(`RUN`/`STOP`) 사용 |
| 생성 XML의 `PAUSE` state | 내부 전용, `INVALID_INPUT` 거부 — `RUN`/`STOP`만 |
| Pub/Sub API 식별 불명확 | `DeveloperName`·record `Id` 둘 다 `ManagedSubscribe` RPC에 사용 가능; Tooling API로 Id 조회 |
| 변경이 Pub/Sub API에 즉시 미반영 | create/update/delete 후 Pub/Sub API 반영에 최대 ~2분; `ManagedSubscribe`가 NOT_FOUND면 대기 후 재시도 |

### Verification Checklist

생성 XML 제시 전:
- [ ] `<topicName>`이 유효 path 형식(`/event/Name__e`, `/data/NameChangeEvent`, `/data/ChangeEvents`, `/event/Name__chn`, `/data/Name__chn`)
- [ ] `<defaultReplay>`가 정확히 `LATEST` 또는 `EARLIEST`
- [ ] `<errorRecoveryReplay>`가 정확히 `LATEST` 또는 `EARLIEST`
- [ ] `<state>`가 정확히 `RUN` 또는 `STOP`
- [ ] `<label>` 채워짐
- [ ] `<version>` 존재(예 `67.0`)
- [ ] read-only 필드(`<id>`, `<createdDate>`, `<namespacePrefix>`) 부재
- [ ] 파일명이 DeveloperName과 정확히 일치

## 번들 파일

- **assets/** — `managed-event-subscription-template.xml`(신규 구독 생성 전 시작 구조)
- **references/** — `topic-name-formats.md`(`<topicName>` 설정 — platform event·change event·custom channel), `update-constraints.md`(Update 시 immutable 필드), `delete-guide.md`(파괴적 변경 배포 절차)

## 관련 노트
- [[integration-eventing-cdc-configure]]
- [[integration-connectivity-generate]]
- [[platform-custom-object-generate]]
