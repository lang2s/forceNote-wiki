---
tags: [agent-skill, sf-skills, reference, experience, ui-bundle, agentforce, troubleshooting]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-agentforce-client-generate/references/troubleshooting.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Troubleshooting, 문제 해결, Agentforce Conversation Client 오류, agentId 오류]
---

# Troubleshooting — 문제 해결

> Agentforce Conversation Client 사용 시 흔한 오류(agentId 누락, 위젯 미표시, 인증 오류, 빈 iframe)와 해결책.

Common issues when using the Agentforce Conversation Client.

---

### Component throws "requires agentId"

**Cause:** `agentId` was not passed.

**Solution:** Pass `agentId` directly as a flat prop:

```tsx
<AgentforceConversationClient agentId="0Xx000000000000AAA" />
```

---

### Chat widget does not appear

**Cause:** Invalid `agentId` or inactive agent.

**Solution:**

1. Confirm the id is correct (18-char Salesforce id, starts with `0Xx`).
2. Ensure the agent is Active in **Setup → Agentforce Agents**.
3. Verify the agent is deployed to the target channel.

---

### Authentication error on localhost

**Cause:** `localhost:<PORT>` is not trusted for inline frames.

**Solution:**

1. Go to **Setup → Session Settings → Trusted Domains for Inline Frames**.
2. Add `localhost:<PORT>` (example: `localhost:3000`).

**Important:**

- This setting should be **temporary for local development only**.
- **Remove `localhost:<PORT>` from trusted domains after development**.
- **Recommended:** Test the Agentforce conversation client in a deployed app instead of relying on localhost trusted domains for extended periods.

---

### Blank iframe / auth session issues

**Possible cause:** First-party Salesforce cookie restriction may block embedded auth flow in some environments.

**Solution:**

1. Go to **Setup → Session Settings**.
2. Find **Require first party use of Salesforce cookies**.
3. Disable it **only if needed and approved by your security/admin team**.
4. Save and reload.

## 관련 노트
- [[experience-ui-bundle-agentforce-client-generate]]
- [[agent-id-resolution]]
- [[constraints]]
