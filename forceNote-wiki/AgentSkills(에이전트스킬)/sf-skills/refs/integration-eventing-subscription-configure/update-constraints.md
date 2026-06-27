---
tags: [agent-skill, sf-skills, reference, integration, eventing]
source: forcedotcom/sf-skills (skills/integration-eventing-subscription-configure/references/update-constraints.md, 공식 Salesforce)
created: 2026-06-27
aliases: [ManagedEventSubscription Update Constraints, 구독 업데이트 제약, 불변 필드 변경, defaultReplay 변경 경고]
---

# Update Constraints for ManagedEventSubscription — 관리형 이벤트 구독 업데이트 제약

> ManagedEventSubscription에서 변경 가능한 필드·변경 불가(불변) 필드, defaultReplay 변경 경고, 불변 필드 변경 시 delete+recreate 절차.

---

## Fields That Can Be Updated

| Field | Notes |
|-------|-------|
| `<label>` | Can be changed at any time |
| `<state>` | Toggle between `RUN` and `STOP` — `PAUSE` is reserved for internal use and will be rejected |
| `<defaultReplay>` | Can be changed, but see warning below |
| `<errorRecoveryReplay>` | Can be changed at any time |

The updatable fields appear in the subscription metadata as follows:

```xml
<!-- 구조 예시 — 실제 동작 설정 아님 -->
<ManagedEventSubscription xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>My Subscription</label>           <!-- editable -->
    <state>RUN</state>                       <!-- toggle RUN / STOP -->
    <defaultReplay>LATEST</defaultReplay>    <!-- editable (see warning) -->
    <errorRecoveryReplay>STORED</errorRecoveryReplay>  <!-- editable -->
    <topicName>/event/Order_Fulfillment__e</topicName>  <!-- immutable -->
</ManagedEventSubscription>
```

## Fields That Cannot Be Changed After Creation

| Field | Why |
|-------|-----|
| `<topicName>` | Changing the channel requires delete + recreate; the platform ties replay state to the original channel |
| DeveloperName (filename) | Renaming requires delete + recreate; rename-in-place is not supported by the Metadata API |

## defaultReplay Change Warning

Changing `<defaultReplay>` from `LATEST` to `EARLIEST` on an existing subscription will cause it to re-replay all available events from the earliest retained position on the next activation. On high-volume event channels this can create a large backlog. Always confirm intent with the user before making this change.

## Procedure for Immutable Field Changes

If the user needs to change `<topicName>` or DeveloperName:

1. Export current subscription config
2. Delete the existing subscription (see `references/delete-guide.md`)
3. Create a new subscription with the desired values
4. Note: replay tracking state from the old subscription is lost

---

## 관련 노트
- [[integration-eventing-subscription-configure]]
- [[delete-guide]]
- [[topic-name-formats]]
