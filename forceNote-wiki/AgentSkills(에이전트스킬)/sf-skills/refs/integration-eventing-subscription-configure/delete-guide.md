---
tags: [agent-skill, sf-skills, reference, integration, eventing]
source: forcedotcom/sf-skills (skills/integration-eventing-subscription-configure/references/delete-guide.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Delete ManagedEventSubscription, 관리형 이벤트 구독 삭제, destructiveChanges 구독 삭제, Pub/Sub 구독 삭제]
---

# Deleting a ManagedEventSubscription — 관리형 이벤트 구독 삭제

> ManagedEventSubscription을 destructiveChanges.xml로 삭제하는 절차와 replay 위치 손실·재생성 시 propagation 지연 주의사항.

---

## Warning

Deleting a ManagedEventSubscription permanently destroys its stored replay position. If you recreate the subscription, it will start from its `<defaultReplay>` — it will not resume from where it left off.

DELETE is safe to call regardless of the subscription's current state — it atomically stops any running subscription, clears the committed Replay ID, and removes the record. **No prior STOP transition is required.**

After deletion, avoid reusing the same DeveloperName immediately — the Pub/Sub API service can take up to ~2 minutes to reflect the deletion. Create a new record with a different name if immediate re-creation is needed.

## Procedure

### Step 1 — Remove the metadata file

Delete the file from your project:
```
managedEventSubscriptions/<DeveloperName>.managedEventSubscription-meta.xml
```

### Step 2 — Create a destructiveChanges.xml

In your deployment package root, create `destructiveChanges.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members><DeveloperName></members>
        <name>ManagedEventSubscription</name>
    </types>
    <version>67.0</version>
</Package>
```

Replace `<DeveloperName>` with the exact developer name of the subscription to delete.

### Step 3 — Create an empty package.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <version>67.0</version>
</Package>
```

### Step 4 — Deploy

```bash
sf project deploy start --manifest package.xml --post-destructive-changes destructiveChanges.xml --target-org <alias>
```

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `INVALID_CROSS_REFERENCE_KEY` | DeveloperName not found | Confirm the exact name with `sf api request rest "/services/data/v67.0/tooling/query/?q=SELECT+DeveloperName+FROM+ManagedEventSubscription"` |
| Subscription reappears or Pub/Sub returns NOT_FOUND after delete | ~2 minute propagation delay in Pub/Sub API service | Wait 2 minutes before attempting any operation on the same topic |

---

## 관련 노트
- [[integration-eventing-subscription-configure]]
