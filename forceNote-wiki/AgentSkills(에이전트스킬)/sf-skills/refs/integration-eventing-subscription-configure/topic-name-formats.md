---
tags: [agent-skill, sf-skills, reference, integration, eventing]
source: forcedotcom/sf-skills (skills/integration-eventing-subscription-configure/references/topic-name-formats.md, 공식 Salesforce)
created: 2026-06-27
aliases: [topicName Formats, 토픽 이름 형식, 이벤트 채널 경로, ManagedEventSubscription topicName]
---

# topicName Formats for ManagedEventSubscription — 토픽 이름 형식

> ManagedEventSubscription `<topicName>`에 들어가는 채널 타입별 전체 경로 형식(플랫폼 이벤트·CDC·커스텀 채널)과 규칙·오류.

---

The `<topicName>` field requires a full channel path, not just an API name. The correct format depends on the type of event channel.

## Valid Formats

| Channel type | Format | Example |
|---|---|---|
| Platform event | `/event/<Name>__e` | `/event/Order_Fulfillment__e` |
| Custom platform event channel | `/event/<Name>__chn` | `/event/MyChannel__chn` |
| All-objects change event channel | `/data/ChangeEvents` | `/data/ChangeEvents` |
| Single-object change event | `/data/<Object>ChangeEvent` | `/data/AccountChangeEvent` |
| Custom change event channel | `/data/<Name>__chn` | `/data/MyChangeChannel__chn` |

## Usage in metadata

The full channel path goes into the `<topicName>` element of the subscription file:

```xml
<!-- 구조 예시 — 실제 동작 설정 아님 -->
<!-- managedEventSubscriptions/MySub.managedEventSubscription-meta.xml -->
<ManagedEventSubscription xmlns="http://soap.sforce.com/2006/04/metadata">
    <topicName>/event/Order_Fulfillment__e</topicName>
</ManagedEventSubscription>
```

## Rules

- The path prefix (`/event/` or `/data/`) is required — omitting it causes `"The topicName field is invalid"` deploy error
- The referenced event or channel must exist in the org before deploying the subscription
- `topicName` is immutable after creation — to change it, delete and recreate the subscription

## Common Errors

| Error | Cause | Fix |
|---|---|---|
| `The topicName field is invalid` | Missing `/event/` or `/data/` prefix, or wrong suffix | Use the full path format from the table above |
| `The topicName field is invalid` | Referenced event/channel does not exist in the org | Create the platform event or channel first |

---

## 관련 노트
- [[integration-eventing-subscription-configure]]
- [[update-constraints]]
