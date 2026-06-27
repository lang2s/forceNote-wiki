---
tags: [agent-skill, sf-skills, reference, experience, ui-bundle, agentforce, examples]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-agentforce-client-generate/references/examples.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Additional Examples, 추가 예제, AgentforceConversationClient 레이아웃, 테마 예제]
---

# Additional Examples — 추가 예제

> AgentforceConversationClient의 레이아웃·크기·테마 조합과 호스트 컴포넌트 예제 모음 (모두 flat props API 사용).

Essential examples for common patterns and combinations. All use flat props API.

---

## Layout Patterns

### Sidebar Chat

```tsx
export default function DashboardWithChat() {
  return (
    <div style={{ display: "flex", height: "100vh" }}>
      <main style={{ flex: 1 }}>{/* Main content */}</main>
      <aside style={{ width: 400 }}>
        <AgentforceConversationClient agentId="0Xx..." inline width="100%" height="100%" />
      </aside>
    </div>
  );
}
```

### Full Page Chat

```tsx
export default function SupportPage() {
  return (
    <div>
      <h1>Customer Support</h1>
      <AgentforceConversationClient agentId="0Xx..." inline width="100%" height="600px" />
    </div>
  );
}
```

---

## Size Variations

### Responsive sizing

```tsx
<AgentforceConversationClient agentId="0Xx..." inline width="100%" height="80vh" />
```

### Calculated dimensions

```tsx
<AgentforceConversationClient agentId="0Xx..." inline width="500px" height="calc(100vh - 100px)" />
```

---

## Theming Combinations

### Brand theme with custom sizing

```tsx
<AgentforceConversationClient
  agentId="0Xx..."
  inline
  width="500px"
  height="700px"
  styleTokens={{
    headerBlockBackground: "#0176d3",
    headerBlockTextColor: "#ffffff",
    messageBlockInboundBackgroundColor: "#0176d3",
    messageBlockInboundTextColor: "#ffffff",
    messageInputFooterSendButton: "#0176d3",
  }}
/>
```

### Dark theme

```tsx
<AgentforceConversationClient
  agentId="0Xx..."
  styleTokens={{
    headerBlockBackground: "#1a1a1a",
    headerBlockTextColor: "#ffffff",
    messageBlockInboundBackgroundColor: "#2d2d2d",
    messageBlockInboundTextColor: "#ffffff",
    messageBlockOutboundBackgroundColor: "#3a3a3a",
    messageBlockOutboundTextColor: "#f0f0f0",
  }}
/>
```

### Inline without header

```tsx
<AgentforceConversationClient
  agentId="0Xx..."
  inline
  width="100%"
  height="600px"
  headerEnabled={false}
  styleTokens={{
    messageBlockBorderRadius: "12px",
  }}
/>
```

---

## Complete Host Component Example

```tsx
import { Outlet } from "react-router";
import { AgentforceConversationClient } from "@salesforce/ui-bundle-template-feature-react-agentforce-conversation-client";

export default function AgentChatHost() {
  return (
    <>
      <Outlet />
      <AgentforceConversationClient
        agentId="0Xx..."
        styleTokens={{
          headerBlockBackground: "#0176d3",
          headerBlockTextColor: "#ffffff",
        }}
      />
    </>
  );
}
```

---

For complete style token reference, see `references/style-tokens.md` or `node_modules/@salesforce/agentforce-conversation-client/README.md`.

## 관련 노트
- [[experience-ui-bundle-agentforce-client-generate]]
- [[style-tokens]]
- [[constraints]]
