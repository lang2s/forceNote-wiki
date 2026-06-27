---
tags: [agent-skill, sf-skills, mobile, mobile-sdk, agentforce-sdk]
source: forcedotcom/sf-skills (skills/mobile-apps-create/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [mobile-apps-create, 세일즈포스 모바일 앱 생성, Salesforce mobile app, Mobile SDK, Agentforce SDK, iOS Android 라우팅]
---

# mobile-apps-create — Salesforce 네이티브 모바일 앱 생성 진입점

> iOS(Swift)·Android(Kotlin)용 Salesforce 연결 모바일 앱을 만들 때, 사용자의 의도를 SDK 패밀리(Mobile SDK vs Agentforce SDK)와 플랫폼(iOS vs Android)으로 분기해 올바른 자식 스킬로 라우팅하는 상위(entry) 스킬.

---

## 목적과 활성화 조건

이 스킬은 기능을 직접 구현하지 않는다. **올바른 SDK 패밀리 스킬로 라우팅하는 것**만 담당하며, 시나리오 감지와 단계별 지침은 자식 스킬이 소유한다.

**TRIGGER (활성화)** — 사용자가 다음처럼 말할 때:
- "build a Salesforce iOS app", "add Salesforce login to my Android app"
- "set up Mobile SDK", "add MobileSync / SmartStore offline storage"
- "embed an Agentforce agent in my mobile app", "add Agentforce chat to iOS/Android"
- 그 외 Swift 또는 Kotlin으로 Salesforce 모바일 경험을 생성·확장·통합하려는 요청 (MSDK, Agentforce SDK, 또는 둘 다)

**SKIP (건너뜀)** — 다음의 경우:
- 비(非)Salesforce 모바일 앱을 만들 때
- Salesforce 통합 없이 React Native / Flutter / Ionic을 쓸 때
- 일반적인 모바일 UI 디자인 질문
- Salesforce 인접 web/desktop 표면(LWC, Experience Cloud, Mobile Publisher 브랜딩 전용) 작업

---

## 워크플로 / 단계

### 라우팅 전 — 두 축으로 모호성 제거

**SDK 패밀리**(Mobile SDK vs Agentforce SDK)와 **플랫폼**(iOS vs Android)으로 구분한다. 둘은 상호 배타적이지 않다 — 한 앱이 두 SDK를 모두 쓸 수 있다. 사용자의 의도가 어느 SDK로도 매핑될 수 있으면 **라우팅 전에 물어본다.** 잘못 추측하면 자식 스킬이 플랫폼·SDK 특화이므로 사용자의 시간을 낭비한다.

### 라우팅 — 어떤 SDK 패밀리인가?

| 사용자 상황 | SDK |
|---|---|
| 최종 사용자를 Salesforce에 인증, 레코드 동기화(MobileSync), 오프라인 저장(SmartStore), 생체 로그인, 푸시 알림, REST 통합 | **Mobile SDK** |
| Agentforce 에이전트 임베드 — chat UI, 에이전트 대화, 대화형 기능이 주(primary) 표면 | **Agentforce SDK** |
| 둘 다 (임베드된 에이전트가 있는 데이터 기반 앱) | **Mobile SDK 먼저**, 그 위에 **Agentforce SDK** 적층 |

**둘 다 해당될 때의 타이브레이커:**
- 에이전트가 *주 표면*(chat-first 앱)인가, 아니면 데이터 기반 앱 *안의 기능*인가?
  - 주 표면 → Agentforce SDK
  - 기능 → Mobile SDK; 그 옆에 Agentforce SDK로 에이전트 임베드
- 최종 사용자가 Salesforce 데이터에 인증하는가?
  - Yes → Mobile SDK 필수 (Agentforce SDK는 위에 추가 가능)
  - No → Agentforce SDK 단독으로 충분할 가능성 (guest auth 사용)
- 오프라인 저장/동기화/REST/푸시/생체에 관한 질문? → Mobile SDK
- 에이전트 대화/chat UI/스트리밍 응답에 관한 질문? → Agentforce SDK

여전히 불명확하면 사용자에게 직접 물어본다.

### 라우팅 — 어떤 플랫폼인가?

| 플랫폼 | Mobile SDK 스킬 | Agentforce SDK 스킬 |
|---|---|---|
| iOS (Swift) | `ios-mobile-sdk` | `integrate-agentforce-ios` |
| Android (Kotlin) | `android-mobile-sdk` | `integrate-agentforce-android` |

두 플랫폼을 모두 원하면 각 자식 스킬로 **개별** 라우팅한다 — 서로 독립적이다.

### 결합 워크플로 (Mobile SDK + Agentforce SDK)

앱이 둘 다 필요할 때:

1. 먼저 Mobile SDK 플랫폼 스킬로 라우팅해 스캐폴드 + 인증.
2. Agentforce SDK 플랫폼 스킬로 라우팅해 에이전트 표면을 적층.
3. 각 자식 스킬의 지침을 그 SDK의 권위 있는 출처로 취급하고 **단계를 병합하지 않는다.** 각 SDK는 자체 auth 설정·의존성 설치 순서·초기화 시퀀스를 소유하며, 이를 섞으면 충돌 config와 깨진 init 순서가 생긴다.

이 시퀀싱이 이 스킬이 소유하는 유일한 멀티스킬 로직이다. 나머지는 모두 자식 스킬 안에 있다.

### 자식 스킬 로드

자식 스킬을 harness를 통해 이름으로 호출한다. 로컬에 없으면 `npx skills add <repo>`로 설치하도록 사용자에게 안내한다. 사용자가 확인(또는 사전 승인)하면 명령을 실행하고 자식 스킬을 로드한다 — 사용자가 워크플로 이어가는 법을 스스로 찾게 두지 않는다. 사용자가 거절하면 멈추고, 자식 스킬이 SDK 설정 단계를 소유하므로 워크플로를 계속할 수 없다고 설명한다.

```
| Skill | Repo | Install command |
|---|---|---|
| ios-mobile-sdk | forcedotcom/SalesforceMobileSDK-Templates → skills/ios-mobile-sdk/ | npx --yes skills add forcedotcom/SalesforceMobileSDK-Templates --skill ios-mobile-sdk --yes |
| android-mobile-sdk | forcedotcom/SalesforceMobileSDK-Templates → skills/android-mobile-sdk/ | npx --yes skills add forcedotcom/SalesforceMobileSDK-Templates --skill android-mobile-sdk --yes |
| integrate-agentforce-ios | salesforce/AgentforceMobileSDK-iOS → skills/integrate-agentforce-ios/ | npx --yes skills add salesforce/AgentforceMobileSDK-iOS --skill integrate-agentforce-ios --yes |
| integrate-agentforce-android | salesforce/AgentforceMobileSDK-Android → skills/integrate-agentforce-android/ | npx --yes skills add salesforce/AgentforceMobileSDK-Android --skill integrate-agentforce-android --yes |
```

설치 후 자식 스킬을 로드하고 인계한다. 자식 스킬 콘텐츠를 인라인하지 않는다 — 자식 스킬이 시나리오 감지·전제조건·단계별 지침을 소유한다.

---

## 핵심 규칙·가드레일

- **여기서는 기능을 구현하지 않는다.** 이 스킬은 라우터일 뿐이다.
- SDK 의도가 양쪽으로 매핑 가능하면 **추측하지 말고 물어본다.**
- 두 SDK를 쓸 때 **Mobile SDK 먼저, 그다음 Agentforce SDK** 순서를 지킨다.
- 자식 스킬들의 단계를 **병합하지 않는다** — 각자 자체 auth·의존성 설치 순서·초기화 시퀀스를 가진다.
- 두 플랫폼 요청은 각 자식 스킬로 개별 라우팅 (서로 독립).
- 자식 스킬을 인라인하지 않고, 로드한 뒤 인계한다.

---

## 번들 파일

- `SKILL.md` — 라우팅 로직 본문 (이 스킬은 references/scripts 디렉터리 없음)

자식 스킬은 별도 공개 repo에서 게시되며 `npx skills add`로 설치된다 (위 표 참조).

---

## 관련 노트
- [[mobile-platform-native-capabilities-integrate]]
- [[mobile-platform-offline-validate]]
