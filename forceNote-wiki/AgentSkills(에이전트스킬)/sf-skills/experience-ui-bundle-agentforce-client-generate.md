---
tags: [agent-skill, sf-skills, experience, ui-bundle, agentforce, conversation-client]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-agentforce-client-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-agentforce-client-generate, Agentforce 대화 클라이언트 임베드, AgentforceConversationClient, 채팅 위젯 추가, agent chat widget]
---

# experience-ui-bundle-agentforce-client-generate — UI Bundle에 Agentforce 대화 클라이언트 임베드

> UI Bundle 프로젝트에 기존 `<AgentforceConversationClient />` 컴포넌트를 임포트·렌더링해 챗봇/대화형 AI를 추가·설정·스타일링·제거하는 스킬. 커스텀 채팅 컴포넌트는 절대 만들지 않는다.

## 목적과 활성화 조건

UI Bundle 프로젝트(`uiBundles/*/src/` 디렉터리 존재)에서 agent·chatbot·chat widget·conversation client·AI assistant를 추가·임베드·통합·설정·스타일링·제거할 때 활성화한다.

- **TRIGGER:** `uiBundles/*/src/`가 있고 채팅 위젯/챗봇/대화형 AI 추가·수정 작업일 때, 파일이 `AgentforceConversationClient`를 import할 때, 페이지에 채팅/agent 기능 추가 요청 시.
- **DO NOT TRIGGER:** 커스텀 agent/chatbot/chat widget 컴포넌트를 처음부터 만들려 할 때, `uiBundles` 디렉터리가 없을 때.

**HARD CONSTRAINT:** 커스텀 agent/chatbot/chat widget 컴포넌트를 **절대** 만들지 않는다. 모든 요청은 기존 `<AgentforceConversationClient />` (`@salesforce/ui-bundle-template-feature-react-agentforce-conversation-client`)를 import·렌더링해 충족한다. 컴포넌트 props로 지원되지 않는 요구사항이면 대안을 즉흥적으로 만들지 말고 한계를 명시한다.

- 패키지: `@salesforce/ui-bundle-template-feature-react-agentforce-conversation-client`
- SDK 패키지: `@salesforce/agentforce-conversation-client`

### 사전 조건 (Prerequisites)

컴포넌트 임베드 성공 후 **항상** 사전 조건을 안내한다.

**Trusted domains (로컬 개발 시에만 필요):**

- Setup → Session Settings → Trusted Domains for Inline Frames → 도메인 추가
  - 로컬 개발: `localhost:5173` (기본 Vite dev 서버 포트)
  - **경고:** 프로덕션 배포 전 이 trusted domain 항목을 반드시 제거한다.

## 워크플로 / 단계

### Step 1: 컴포넌트가 이미 존재하는지 확인

모든 app 파일(구현 파일 제외)에서 기존 사용을 검색한다.

```bash
grep -r "AgentforceConversationClient" --include="*.tsx" --include="*.jsx" --exclude-dir=node_modules
```

- **중요:** 컴포넌트를 import·USE하는 React 파일(shared shell, route 컴포넌트, feature 페이지 등)을 찾는다. `AgentforceConversationClient.tsx`/`.jsx`로 명명된 파일은 컴포넌트 구현이므로 열지 않는다.
- **다중 파일 발견 시:** 어떤 컴포넌트 파일을 가리키는지 사용자에게 묻고, 확인 전까지 진행하지 않는다.
- **발견 시:** 파일을 읽고 현재 `agentId` 값을 확인한다.

**Agent ID 검증 규칙 (deterministic):**

- 정규식 `^0Xx[a-zA-Z0-9]{15}$`에 일치할 때만 유효 = `0Xx`로 시작하고 총 18자.

**결정:**

- `agentId`가 일치 + 다른 props 갱신 요청 → Step 4 (props 갱신)
- `agentId`가 일치 + "embed"/"add" 요청 → "이미 `<file>`에 agent ID `<agentId>`로 임베드돼 있습니다. agent를 변경하거나 다른 props를 갱신할까요?"
  - agent 변경 → Step 2 / props 갱신 → Step 4b
- `agentId`가 없음/비어있음/불일치 → Step 2 (실제 ID 필요)
- 미발견 → Step 2 (신규 추가)

**사용자가 에러 보고 시:** "작동 안 함"/"에러 표시" 등이면 구체적 에러 메시지를 묻고, Step 2로 가서 설정된 agentId를 org에 대조한다.

### Step 2: Agent ID 해결 및 검증

**사전 조건:**

1. **sf CLI 확인:**
   ```bash
   sf --version
   ```
   실패 시: CLI 미설치 안내 → 설치 의사 질문. Yes → `npm install -g @salesforce/cli`. No → Setup → Agentforce Agents에서 수동 조회 안내(ID 제공 시 포맷 검증 후 Step 3, skip 시 placeholder `<YOUR_AGENT_ID>`로 Step 4).

2. **org 연결 확인:**
   ```bash
   sf org display --json
   ```
   실패 시: 인증 org 없음 안내 → `sf org login web` 권유. 인증 → 재시도. 거부 → 수동 조회 안내.

   **Note:** 사용자가 직접 agentId를 제공해도 런타임에 agent가 작동하려면 org가 연결돼 있어야 한다. org 미연결 상태의 agentId는 작동하지 않는다.

**Employee Agents 조회:** `references/agent-id-resolution.md`에 정의된 SOQL 쿼리를 실행한다.

**결과 처리:**

- **레코드 없음:** "이 org에 Employee Agents가 없습니다. Setup → Agentforce Agents에서 생성하세요." → 수동 제공/skip 질문.
- **전부 비활성:** 발견된 agent 목록 표시 + 활성화 안내(Setup → Agentforce Agents → agent 이름 클릭 → Agent Builder → Activate) → 수동 제공/skip 질문.
- **활성 agent 있음 — Path A (신규 설치/기존 agentId 없음):** 활성 agent만 선택지로 제시. 1개여도 자동 선택 금지, 사용자 확인. 선택 → `Id` 저장. 거부("skip"/"no") → 재질문 금지, Step 4에서 신규 설치는 placeholder `<YOUR_AGENT_ID>`, 기존 프로젝트는 그대로 둔다.
- **활성 agent 있음 — Path B (Step 1의 기존 agentId, 포맷 통과):** 쿼리 결과에 대조.
  - ID 존재 + Active → "agent ID가 '...'에 매핑됨 — org에서 active." 진행.
  - ID 존재 + Inactive → 활성화 안내 또는 다른 active agent 선택.
  - ID 미존재 → "설정된 agent가 이 org에 없음(삭제됐거나 다른 org)." 대체 선택.

**쿼리 에러:** SOQL 실패 시 응답의 에러 메시지를 그대로 사용자에게 전달. 추측 금지.

**이 단계가 하지 않는 것:** GraphQL/Tooling API fallback 없음(SOQL only), 자동 선택 없음(항상 확인), 프로그래밍적 활성화 없음(Setup UI만), 파일 쓰기 없음(Step 4 담당).

### Step 3: Canonical import 전략

app 코드에서 기본으로 이 import 경로를 사용한다.

```tsx
import { AgentforceConversationClient } from "@salesforce/ui-bundle-template-feature-react-agentforce-conversation-client";
```

패키지 미설치 시:

```bash
npm install @salesforce/ui-bundle-template-feature-react-agentforce-conversation-client
```

사용자가 명시적으로 패치된/로컬 컴포넌트 사용을 요청할 때만 로컬 상대 import(`./components/AgentforceConversationClient`)를 쓴다. 파일 탐색만으로 import 경로를 추론하지 않고, 코드베이스 전체에 일관된 패키지 import를 선호한다.

### Step 4: 컴포넌트 추가 또는 갱신

- Step 1에서 미발견 → **4a (신규 설치)**
- Step 1에서 발견 → **4b (기존 갱신)**

**4a — 신규 설치:** 대상 파일 확정 전 진행 금지 → 대상 파일을 읽어 기존 import·TSX 구조 파악 → 상단에 canonical import 추가 → return 블록에 `<AgentforceConversationClient />`를 기존 콘텐츠의 sibling으로 삽입(기존 TSX 래핑·재구조화 금지) → 다른 코드(wrapper, layout, 함수) 추가 금지.

```tsx
<AgentforceConversationClient agentId="0Xx8X00000001AbCDE" />
```

resolved agentId 없으면 placeholder:

```tsx
<AgentforceConversationClient agentId="<YOUR_AGENT_ID>" />
```

**4b — 기존 갱신:** Step 1 파일을 읽고 기존 `<AgentforceConversationClient ... />`를 찾아 **요청된 변경만** 적용.
- 요청한 새 props **추가**, 요청한 prop 값 **변경**, 언급 안 한 prop은 모두 **보존**(삭제·재정렬·재포맷 금지), 컴포넌트 삭제 후 재생성 **절대 금지**.
- Step 2가 트리거돼 새 agent ID 해결됐으면 기존 값 교체. 현재 agentId가 유효+변경 미요청+Step 2가 active 확인이면 그대로 둔다.

**Post-Step-4 에러 처리:** 설정 후 에러 보고 시 Step 2로 가서 org 대조(active 여부, 존재 여부, 연결 org 소속 여부).

### Step 5: Props 설정

**Available props (컴포넌트에 직접 사용):**

- `agentId` (string, required) — Salesforce agent ID
- `inline` (boolean) — `true`면 inline 모드, 생략 시 floating
- `width` (number | string) — 예: `420` 또는 `"100%"`
- `height` (number | string) — 예: `600` 또는 `"80vh"`
- `headerEnabled` (boolean) — header 표시/숨김
- `styleTokens` (object) — 모든 스타일링(색상·폰트·간격)
- `salesforceOrigin` (string) — 자동 해결
- `frontdoorUrl` (string) — 자동 해결
- `agentLabel` (string) — agent header 제목

**예시:**

```tsx
<AgentforceConversationClient agentId="0Xx..." />
<AgentforceConversationClient agentId="0Xx..." inline width="420px" height="600px" />
<AgentforceConversationClient agentId="0Xx..." agentLabel="<dummy-agent-label>" />
```

**스타일링 규칙 (mandatory):**

- 모든 시각 커스터마이징(색상·폰트·간격·border·radii·shadow)은 **반드시** `styleTokens` prop으로. 예외 없음.
- 아래 표(`references/style-tokens.md`)에 나열된 토큰 이름만 사용. 커스텀 토큰 이름 발명 금지.
- CSS 파일·`style` 속성·`className`·wrapper 요소로 스타일링 **절대 금지** — 컴포넌트가 무시한다.
- 토큰에 매핑 안 되는 시각 변경 요청 시 현재 토큰 세트로 지원 불가임을 안내.

## 핵심 규칙·가드레일

- 커스텀 채팅 컴포넌트 절대 생성 금지 — 기존 `<AgentforceConversationClient />`만 사용.
- agentId 포맷은 `^0Xx[a-zA-Z0-9]{15}$` (18자).
- 모든 스타일링은 `styleTokens`만 — CSS/className/wrapper 무시됨.
- Step 2: SOQL only, 자동 선택 없음, 1개 agent여도 사용자 확인 필수.
- 4b 갱신 시 언급 안 한 props 절대 건드리지 않음, 컴포넌트 삭제 후 재생성 금지.
- 임베드 성공 후 항상 trusted domains 사전 조건 안내(프로덕션 배포 전 제거).

## 번들 파일

| 파일 | 언제 읽나 |
|------|-----------|
| `references/agent-id-resolution.md` | Step 2 — SOQL 쿼리 구조, 응답 포맷, 활성화 경로, 수동 조회 |
| `references/style-tokens.md` | Step 5 — 전체 UI 영역의 style token 레퍼런스 |
| `references/examples.md` | Step 5 — 레이아웃 패턴, 사이징, 테마 조합, host 컴포넌트 예시 (sidebar 컨테이너, dark theme, inline w/o header 등) |
| `references/constraints.md` | Step 4 — 잘못된 props(containerStyle/style/className), 잘못된 스타일링 방식, 편집 금지 파일 |
| `references/troubleshooting.md` | 셋업 후 — agent 활성화·배포, localhost trusted domains, cookie 제한 설정 |

## 관련 노트
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-features-generate]]
- [[experience-ui-bundle-file-upload-generate]]
