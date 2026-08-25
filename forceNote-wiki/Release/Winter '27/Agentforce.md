---
tags: [release, winter_27, agentforce, einstein, ai]
api_version: v68.0
release_date: 2026-10
created: 2026-08-24
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2)
aliases: [Winter '27 Agentforce, 윈터27 에이전트포스, Agentforce Contact Center, AFCC, Salesforce Voice Native Telephony, Gemini 2.5 리라우트, Gemini 3.5, Approval Agent, 승인 에이전트, Recall Approval Submission, Work Summaries for Case 은퇴, Agentforce Service Assistant, Agentforce IT Service, Agentforce for HR Service, 에이전트포스 보이스]
---

# Winter '27 — Agentforce & Generative AI

> 이 노트는 Agentforce & Generative AI 영역에서 **추출된 31페이지**를 근거로 한다 — **영역 자체는 최소 59페이지**이고, 이 영역 안에 있는 하위 리프 **28개는 미추출**이다. 따라서 아래의 GA 0건 · Release Update 0건 · 신규 모델 0건은 모두 **추출된 31페이지 기준**이다. 확보된 내용은 Gemini 2.5→3.5 리라우트(2026-10-20), Agentforce Voice 3건(2026-09-07 주), Agentforce Contact Center(AFCC)로 편입된 Salesforce Voice, 표준 액션 카탈로그 4항목(전부 승인 관련), Work Summaries for Case (Beta) 은퇴(2026-09-30)다.

---

## 개요 — 이 노트의 근거 범위와 영역의 실제 크기

**31은 이 영역의 크기가 아니라 이 노트가 근거로 삼은 추출 배치의 크기다.** 소스 덤프 자체가 네 곳에서 "이 배치에 할당된 31페이지 목록에 들어 있지 않은 자식 페이지"를 명시한다:

| 부모 페이지 | 배치에 미할당된(=미추출) 자식 리프 |
|---|---|
| `rn_afcc_voice` | **3** |
| `rn_agentforce_it` | **9** |
| `rn_ai_agents_sa` | **12** |
| `rn_einstein_work_summaries` | **4** |
| **합계** | **28** |

이 28개는 Workforce Engagement Management·Partner Contact Center와 **달리** 다른 제품 영역으로 옮겨간 게 아니라 **이 영역 자체의 자식**이다. 따라서 **Agentforce & Generative AI 영역은 최소 59페이지(추출 31 + 미추출 28)** 이고, 이 노트는 그중 31페이지의 추출본 위에 서 있다.

**그래서 이 노트의 모든 "0건"은 범위 한정 진술이다:**

- **추출된 31페이지 안에** **GA(Generally Available) 항목이 하나도 없다.** 미추출 28리프는 미확인.
- **추출된 31페이지 안에** **Release Update(강제 적용) 항목이 하나도 없다.** 미추출 28리프는 미확인.
- **추출된 31페이지 안에** **신규 지원 모델(GA/Beta) 항목이 없다.** 모델 관련 항목은 기존 Gemini 2.5 계열의 **리라우트 공지 1건**뿐이다.
- **추출 범위 안에서** Pilot은 **1건**(Voice Call 레코드 변경 감사 추적), Beta 마커 항목은 **은퇴 대상 1건**(Work Summaries for Case)이다.

**이 한정이 형식적인 게 아니라는 직접 증거가 이 노트 안에 있다.** 유일하게 확인된 Pilot 항목(**Keep an Audit Trail of Voice Call Record Changes**)은 **리프 페이지가 미추출**이라 상위 TOC의 설명문(blurb)에서만 잡혔다. 즉 등급(Pilot/Beta/GA) 표시가 붙은 항목이 미추출 리프 쪽에 더 있을 수 있다.

> **직전 릴리즈와의 규모 비교는 이 노트에서 하지 않는다.** 분모(영역 전체 페이지 수)가 확정되지 않은 상태라 "이번 영역이 작다/크다"는 판정할 수 없다. 미추출 28리프를 확보한 뒤 [[Winter '26/Agentforce]]와 비교하는 것을 **GA 시점 재점검의 열린 과제**로 남긴다.

> 상위 허브: [[Winter '27]]
> 형제 spoke: [[Winter '27/Development]] · [[Winter '27/Platform]] · [[Winter '27/Clouds]] · [[Winter '27/Release Updates]]

**독자 라우팅 — 여기서 못 찾으면 어디로 가야 하나:**

| 찾는 것 | 가야 할 곳 |
|---|---|
| 강제 적용 시점·enforcement 날짜 | [[Winter '27/Release Updates]] — 강제 시점 표의 **단일 출처**(이 노트는 강제 날짜를 재서술하지 않는다) |
| 클라우드별 AI 기능(Sales·Service·Industries 등) | [[Winter '27/Clouds]] |
| Apex/LWC/API 등 개발자 표면의 AI 변경 | [[Winter '27/Development]] |
| Setup·보안·플랫폼 쪽 AI 설정 | [[Winter '27/Platform]] |
| Workforce Engagement Management | **Service Cloud 영역**(진짜 다른 영역) — `rn_afcc` 허브가 그쪽을 가리킨다. 허브가 준 설명은 아래 AFCC 섹션에 기록 |
| 서드파티 텔레포니·CCaaS 컨택센터 | **Partner Contact Center**(Service Cloud 영역) — 소스가 명시적으로 리다이렉트 |
| Agentforce IT Service의 실제 기능 | **이 영역 안의 9개 하위 섹션** — 다만 이 노트의 추출 범위 밖이라 허브 요약만 있다(아래 라우팅 표) |

```text
// 구조 예시 — 실제 동작 코드 아님 (Winter '27 Agentforce 영역 시점 맵)
2026-09-07 주 ──► Agentforce Voice 3건
                   · 통화 후 전사에 전체 대화 이력 표시 (VC1)
                   · 확보(procured) 전화번호 한도 강제 시작
                   · Toolkit API로 통화 녹음 일시정지/재개 (권한 없이)
2026-09-30    ──► Work Summaries for Case (Beta) 은퇴 → 그때까지 maintenance mode
                   · 대체: Enhanced Summaries
2026-10-20    ──► Gemini 2.5 Pro / Flash / Flash-Lite 요청을
                   Gemini 3.5 Pro / Flash / Flash-Lite 로 리라우트
                   (※ 소스 내 문구 불일치 — 아래 "모델" 섹션 참조)
Pilot         ──► VoiceCall 필드 변경 감사 추적 (최대 20필드, Activity 필드 미지원)
GA            ──► (추출 31페이지 내 0건 — 미추출 28리프는 미확인)
Release Update──► (추출 31페이지 내 0건) → [[Winter '27/Release Updates]] 소관
```

---

## 릴리즈 노트 변경 이력 (월별)

소스(`rn_einstein`)가 게시 후 추가·변경한 항목을 월별로 기록한다. 이 영역에서 실제로 "움직인" 항목이 무엇인지 보여준다.

| 월 | 추가/변경된 릴리즈 노트 | 소스가 기록한 추가 시점 |
|---|---|---|
| **October 2026** | Supported Models: Gemini 2.5 Pro, Flash, and Flash-Lite Reroute Date Approaching | Added the week of **August 24, 2026** |
| **September 2026** | Agentforce Voice: Show Full Conversation History in Post-Call Transcripts for Agentforce Voice Calls | Added the week of **August 17, 2026** |
| **September 2026** | Agentforce Voice: Enable Flexible Call Recording Control Within Conversations via Toolkit API | Added the week of **August 17, 2026** |
| **September 2026** | Agentforce Voice: Agentforce Voice Now Enforces the Limit on Procured Phone Numbers | Added the week of **August 17, 2026** |
| **August 2026** | *No changes since the initial publication.* | — |

---

## 모델 — Gemini 2.5 → 3.5 리라우트

**추출된 31페이지 안에서** 유일한 모델 관련 항목이다. **그 범위 안에 신규 모델 GA/Beta는 없다.**

**Gemini 2.5 Pro, Flash, and Flash-Lite Reroute Date Approaching**

- **Gemini 2.5 Pro / Flash / Flash-Lite** 모델 요청이 **Gemini 3.5 Pro / Flash / Flash-Lite** 로 **리라우트**된다.
- Salesforce 권고: **응답이 달라질 수 있으므로**(*"expected responses can change"*) **Prompt Builder**와 **Einstein Studio**에서 신규 모델로 프롬프트·애플리케이션을 **가능한 한 빨리 테스트**하라.
- **Where:** Lightning Experience — Enterprise, Performance, Unlimited editions + **Einstein for Sales**, **Einstein for Platform**, 또는 **Einstein for Service** 애드온.
- **See Also (소스 링크):** Salesforce Help: Large Language Model Support · Agentforce Developer Guide: Supported Models.

> [!warning] **소스 내부 문구 불일치 — 그대로 기록한다**
> 같은 변경에 대해 소스의 두 위치가 다르게 서술한다. 어느 쪽이 정확한지 소스만으로는 판정할 수 없으므로 **양쪽을 모두 남긴다.**
>
> - **월별 변경 이력(`rn_einstein`) 원문:** *"Models will be rerouted **starting the week of October 20, 2026**."* → 10/20이 속한 **주에 걸쳐 순차 적용**으로 읽힌다.
> - **리프 페이지(`rn_einstein_models_gemini_2_5_reroute`)의 When 원문:** *"Gemini 2.5 Pro, Flash, and Flash-Lite requests are rerouted **on October 20, 2026**."* → **당일 일괄 적용**으로 읽힌다. 본문(`rn_einstein_copilot` 요약 포함)도 *"...will be rerouted to Gemini 3.5 Pro, Flash, and Flash-Lite **on October 20, 2026**"* 로 동일하다.
>
> **실무 판단:** 리라우트 대비 테스트는 **2026-10-20 이전에 완료**해 두면 두 해석 어느 쪽이든 안전하다.

---

## New and Changed Standard Agent Actions and Subagents (전수)

> **이것이 Winter '27 표준 에이전트 액션 카탈로그의 전부다.** 소스 페이지(`rn_einstein_copilot_standard_actions`)는 전체 1,748자이고, 월 섹션은 **"September '26" 하나뿐**이며, 접기(accordion)로 숨겨진 콘텐츠가 없음을 추출 시점에 확인했다. 즉 아래 4항목이 축약본이 아니라 **완전한 카탈로그**다. 규모 비교 기준은 [[Winter '26/Agentforce]] 참조.

소스 전제: *"Availability of standard agent actions, subagents, and related prompt templates or flows can vary by edition and license."* — 에디션·라이선스에 따라 제공 여부가 달라진다.

### September '26 — 4항목 (전부 승인(Approval) 관련)

**1. New Agent: Approval Agent**

Approval Agent는 영업 담당자(sales rep)와 리뷰어가 승인 워크플로를 관리하도록 돕는다. 제공 능력:
- 승인 **제출(submit)** 및 **회수(recall)**
- 대기 중인 요청(pending requests) **추적**
- 레코드 **관리**
- 작업 항목(work items) **조회(retrieve)**
- 승인 결정을 앞당기기 위한 **AI 기반 요약·코멘트 생성**

**2. New Subagent: Approval Management**

승인 작업 항목(Approval Work Item)과 제출(submission)을, **요약·승인(approve)·거부(reject)·회수(recall)** 로 관리하도록 돕는 서브에이전트. **선택적 코멘트**를 붙일 수 있다.

이 토픽에는 **신규 액션 1개**가 포함된다.

| 신규 액션 | 동작 |
|---|---|
| **Recall Approval Submission** | 최종 결정 전에 제출된 승인 요청을 **회수**한다. 더 이상 필요 없거나 **착오로 제출된** 진행 중 승인을 취소하며, **선택적 회수 코멘트**와 완료를 확인하는 **성공 지표(success indicator)** 를 제공한다. |

**3. New Subagent: Search Approval Records**

Approval Work Item 또는 Approval Submission 레코드를 **필터링·목록화**한다. 필터 기준: **연관 레코드 타입(related record type)**, **날짜 범위(date ranges)**, **상태(status)**, **담당자 컨텍스트(assignee context)**.

**4. New Subagent: Summarize Multiple Approval Work Items**

Approval Work Item 레코드를 필터링해 **집계 요약(summarize in aggregate)** 한다. **레코드별 상세(per-record details)** 를 함께 제공해 리뷰어가 각 승인의 맥락을 빠르게 파악하게 한다.

> 승인 프로세스 자체의 설정·운영은 [[Approval Process (승인 프로세스)]] 및 [[Approval Process — 운영·엔드유저·레퍼런스]] 소관이다. 여기서는 에이전트 표면만 다룬다.

---

## Agentforce Voice — 3건 (2026-09-07 주 제공)

세 항목 모두 **When: 2026년 9월 7일 주(week of September 7, 2026)** 부터 제공된다.

### Show Full Conversation History in Post-Call Transcripts for Agentforce Voice Calls

Service Console의 **Enhance Conversation** 컴포넌트가 voice-enabled agent가 처리한 통화의 전사를 **통화 중과 통화 후에 일관되게** 표시한다.

- 에이전트가 서비스 담당자(service rep)에게 통화를 넘기면, **rep–customer 대화의 voice call 레코드(VC1)** 가 통화 후에도 **agent–customer 전사와 rep–customer 전사 둘 다** 표시한다 — 통화 중에 보이던 것과 동일하게.
- **이전 동작:** VC1은 통화 **중에는** 두 전사를 모두 보여줬지만 **통화가 끝나면 agent–customer 전사를 누락**시켰다.
- **Where:** Enterprise, Unlimited, Developer Editions + Foundations 또는 Agentforce 1 Editions, 그리고 **Salesforce Voice 애드온**.
- **How:** 통화 후 VC1에 두 전사를 모두 표시하려면 ① **고객을 서비스 담당자에게 전환하기 전에 voice call 레코드를 생성**하고 ② **Connect Related Voice Calls** 를 켜서 VC1을 **에이전트의 voice call 레코드(VC2)** 에 연결한다.
- **See Also (소스 링크):** Salesforce Help: Recommended Call Flow for Handling Calls · Connecting Related Voice Calls.

### Agentforce Voice Now Enforces the Limit on Procured Phone Numbers

Agentforce Voice가 **Salesforce Voice (Native Telephony)** 의 확보(procure) 가능 전화번호 수 한도를 **이제 강제**한다.

> 소스 원문: *"In production orgs, your Agentforce Voice license determines the limit. In sandbox and trial orgs, the limit is 10 phone numbers regardless of your license. Previously, these limits weren't enforced."*

| 조직 유형 | 전화번호 한도 |
|---|---|
| **프로덕션 조직** | **Agentforce Voice 라이선스가 한도를 결정** (고정 숫자 아님) |
| **Sandbox 조직** | **10개** — **라이선스와 무관하게** |
| **Trial 조직** | **10개** — **라이선스와 무관하게** |

- **이전 동작:** 이 한도들은 **강제되지 않았다.**
- **Where:** Enterprise, Unlimited, Developer Editions + Foundations 또는 Agentforce 1 Editions, 그리고 **Agentforce Contact Center 애드온**.
- **Who:** **PSTN 통신 프로토콜**을 쓰고 텔레포니 모델이 **Salesforce Voice (Native Telephony)** 인 Agentforce Voice 고객에게 적용.
- **See Also (소스 링크):** Salesforce Help: Provision a New Phone Number in Salesforce Voice.

### Enable Flexible Call Recording Control Within Conversations via Toolkit API

개발자·어드민이 **Salesforce Voice Toolkit API** 로 통화 녹음을 **일시정지(pause)·재개(resume)** 할 수 있다 — **Control Call Recording 사용자 권한 없이**.

- **이전 동작:** 이 사용자들에게 **Control Call Recording 권한이 필요**했다.
- **여전히 필요한 곳:** **Salesforce UI**의 pause/resume 컨트롤을 쓰려면 이 권한이 **계속 필요**하다. (API 경로만 권한이 면제된다 — 이 구분이 핵심이다.)
- **Where:** Enterprise, Unlimited, Developer Editions + Foundations 또는 Agentforce 1 Editions, 그리고 **Service Cloud Voice 애드온**.
- **How:** Toolkit API로 녹음을 pause/resume 하려면 **먼저 텔레포니 시스템에서 통화 녹음을 켜야 한다.**
- **See Also (소스 링크):** Salesforce Help: Salesforce Voice LWC Toolkit API Telephony Actions.

> **애드온 명칭 주의 (Pattern B-2 — 한 기능군, 세 가지 애드온 표기)** — 위 3건은 같은 "Agentforce Voice" 기능군인데 **Where의 애드온 이름이 각각 다르다**: 전사=**Salesforce Voice 애드온**, 번호 한도=**Agentforce Contact Center 애드온**, Toolkit API=**Service Cloud Voice 애드온**. 소스 원문 그대로이며, 아래 "제품 구조 변화"에서 설명하는 **명칭 전환 과도기**의 흔적으로 보인다. 라이선스 확인 시 세 이름을 같은 계열로 보고 접근할 것.

---

## Agentforce Contact Center (AFCC)

### 제품 구조 변화 — Salesforce Voice가 AFCC로 편입됐다

이번 릴리즈에서 기록해야 할 **명명·제품 구조 사실**이다.

> 소스 원문(`rn_afcc`·`rn_afcc_voice` 양쪽에 동일 Note): *"Salesforce Voice (Native Telephony) is now part of Agentforce Contact Center. You may see references to Salesforce Voice (Native Telephony) in Salesforce applications, documentation, and release notes."*

- **Agentforce Contact Center(AFCC)** = Salesforce 안의 **AI-first 컨택센터**. **내장 텔레포니 제품**과 **Workforce Engagement Management** 등의 역량을 함께 제공한다.
- **Workforce Engagement Management(WEM)** — `rn_afcc` 허브가 자식으로 나열하며, CRM에 네이티브로 내장된 WEM으로 컨택센터를 더 효율적으로 운영하고 근무자 경험을 끌어올린다고 설명한다: **예측형 AI 수요 예측(predictive AI forecasting)** · **인력 수용 계획(capacity planning)** · **스케줄 관리(schedule management)** 로 전 채널의 운영 비용을 낮추고 인력 배치를 최적화하며, **실시간 인트라데이 가시성(real-time intraday visibility)** 으로 수요 변화에 빠르게 대응하고, **객관적 품질 평가(objective quality evaluations)와 성과 인사이트(performance insights)** 로 고객 상호작용을 개선한다. 단 **리프 페이지는 Service Cloud 영역**에 있으므로 세부는 그쪽 소관 — 여기서는 허브가 준 설명까지만 기록한다.
- **Salesforce Voice (Native Telephony)는 이제 AFCC의 일부다.** 다만 애플리케이션·문서·릴리즈 노트 곳곳에 **Salesforce Voice (Native Telephony) 표기가 그대로 남아 있을 수 있다**고 소스가 명시한다.
- 그 결과 **AFCC 리프 페이지들은 자기 범위를 텔레포니 모델로 한정**한다 — Where 항목이 대부분 *"This change is available in Salesforce orgs with this telephony model: **Salesforce Voice (Native Telephony)**"* 형태다.
- **서드파티 텔레포니·CCaaS 사용자는 이 섹션이 아니다.** 소스 원문: *"This section covers voice capabilities for Agentforce Contact Center. To learn about updates for contact centers with third-party telephony and CCaaS providers, see **Partner Contact Center**."* (Partner Contact Center는 Service Cloud 영역)

**권한 세트 지도 (소스에 Who가 명시된 항목만):**

| 권한 세트 | 필요한 기능 |
|---|---|
| **Agentforce Contact Center Admin (Salesforce Voice)** | 녹음 리댁션 설정 · 음성 메시지 캡처 · 아웃바운드 CLI/플로 입력 구성 · In-Queue Experience 플로 · Set End Call Experience + 설문 플로 · Scheduled Callback 플로 · 플로 웜 트랜스퍼 구성 |
| **Agentforce Contact Center Admin (Salesforce Voice)** + **Manage Flow** | 발신자 ID를 다르게 설정하고 플로를 수정 (Call Origination Flows) |
| **Agentforce Contact Center Quality Manager** 또는 **Quality Analyst** | 품질 관리·평가(manage and assess quality) |
| **Agentforce Contact Center Quality Viewer** | 품질 점수 **조회**(view quality scores) |

> **소스 표기 편차 기록** — 대부분의 AFCC 리프는 *"...orgs with **this telephony model**"*(단수)인데, **Reach Emergency Services by Using Bring Your Own Carrier Numbers**, **Control Outbound Call Behavior with Call Origination Flows and Voice Configurations**, **Make Warm Transfers to Flows with Flow Actions** 3건은 *"...orgs with **these telephony models**"*(복수)라고 쓰고도 **나열된 모델은 Salesforce Voice (Native Telephony) 하나뿐**이다. 소스 원문 그대로이며 추가 모델은 소스에 없다.

### AFCC Voice — 기능 전수 (19항목 = TOC 18건 + TOC 밖 1건)

`rn_afcc_voice` 섹션의 TOC는 **18개 항목**을 나열한다. **이 하위 절에 들어 있는 건 16건**이다 — TOC 18건 중 **리프 상세까지 확보된 15건** + TOC에 이름이 없는 리프 **Evaluate Every Interaction 1건**. TOC의 나머지 **3건**(리프 미추출)은 **다음 하위 절**에 따로 둔다. 즉 16 + 3 = **19건**이 이 노트가 기록한 AFCC Voice 항목 전부다.

#### 번호·캐리어

**Bring Your Own Carrier to Your Voice Channel**
선호 캐리어를 AFCC에 가져오면서 기존 캐리어 관계와 전화번호를 유지한다. 번호를 **E.164 형식**으로 **타입·국가·역량(capabilities)·통화 방향(call direction)** 과 함께 추가하고, **트렁크(trunk)** 를 만들어 자사 텔레포니 인프라를 Salesforce에 연결해 인바운드·아웃바운드 음성 트래픽을 실어 나른다. **동기화에 성공한 번호만** voice channel 생성에 쓸 수 있다. 검증된 BYOC 채널과 번호는 기존 채널·번호 목록에 **Bring Your Own Carrier 플래그**와 함께 나타난다.
- **How:** BYOC 번호는 **개별 또는 대량(bulk) 업로드 — 한 번에 최대 10개**, **E.164 형식**. 조직에 번호를 추가한 뒤 voice channel 생성 시 **Bring Your Own Carrier Voice** 를 선택한다.
- **See Also (소스 링크):** Salesforce Help: Bring Your Own Carrier to Agentforce Contact Center *(릴리즈 프리뷰 기간에는 내용이 오래됐거나 접근 불가일 수 있음 — 소스 자체 주석)*.

**Reinforce Brand Identity with Toll-Free Caller ID Numbers**
**수신자부담번호(TFN)** 를 아웃바운드 통화용 **조직 전체 CLI(Caller Line Identification)** 로 설정한다. 고객이 콜백 시 일관되고 알아보기 쉬운 "return to base" 번호를 보게 되어 응답률 개선에 도움이 된다.
- **이전 동작:** 수신자부담번호는 **CLI로 사용이 제한**돼 있어 어드민은 아웃바운드 발신자 ID에 표준 번호만 쓸 수 있었다.
- **How:** 아웃바운드 콜링 설정에서 수신자부담번호를 조직 전체 CLI로 구성한다.

**Control Outbound Number Availability and Protect Privacy with Number Masking**
번호를 확보(procure)할 때 **인바운드·아웃바운드를 모두 지원하는 번호는 Salesforce가 자동으로 아웃바운드 사용 가능으로 표시**하므로, 어드민이 수동 설정 없이 CLI·아웃바운드 플로에 선택할 수 있다. **번호 마스킹**을 켜면 아웃바운드 통화 중 번호를 숨겨 컴플라이언스에 민감한 시나리오에서 담당자·고객 프라이버시를 보호한다.
- **How:** **Number Details** 페이지에서 CLI·아웃바운드 플로에 쓰이지 않게 하려면 **아웃바운드 적격성(outbound eligibility)** 을 끄고, 아웃바운드 통화 시 번호를 마스킹하려면 **Enable Masking** 을 켠다. **실제 사용 중인 번호의 아웃바운드 적격성을 끄면 변경 적용 전에 경고가 표시**된다.

**Reach Emergency Services by Using Bring Your Own Carrier Numbers**
BYOC 음성 번호로 긴급 번호에 전화하면 통화가 **캐리어로 그대로 통과(pass straight through)** 한다. 긴급 번호 통화는 **표준 아웃바운드 통화로 취급**되어 캐리어의 일반 통화 라우팅을 탄다. **긴급 통화 역량과 컴플라이언스 의무는 텔레포니 캐리어와 협의**해 확인해야 한다.

#### IVR·플로

**Support More Callers Across Europe with Extended IVR Language Options**
IVR 프롬프트를 **유럽 4개 언어 추가** 지원: **Finnish, Swedish, Danish, Polish**. 이 언어들은 **TTS(text-to-speech) 프롬프트 재생**과 동작하며 **기존과 동일한 언어 결정(language resolution) 동작**을 따르므로, 기존 IVR 플로는 그대로 작동한다.

**Preview Media Label Audio Before Publishing Your IVR Flow**
미디어 라벨로 IVR 프롬프트를 구성할 때 올바른 오디오가 재생되는지 검증한다. **Flow Builder의 Play Prompt 설정에서 직접** 오디오를 미리 듣는다 — TTS 프롬프트를 미리 듣던 방식과 동일하게.
- **이전 동작:** **TTS 프롬프트만** 미리 듣기가 가능해, 미디어 라벨 오디오를 확인하려면 IVR 플로 전체를 게시하고 테스트해야 했다.
- **How:** Flow Builder에서 **Play Prompt** 액션을 구성하고 프롬프트 소스로 **미디어 라벨**을 선택한 뒤 **Preview** 를 클릭하면 저장·활성화 **전에** 해당 라벨의 오디오를 들을 수 있다.

**Make Warm Transfers to Flows with Flow Actions**
활성 통화나 인바운드 채널에서 **음성 통화를 Omni-Channel 플로로 직접 전환**해 고객 컨텍스트를 보존한다. 자동 IVR 프롬프트로 안내하고, 키패드 입력을 수집하며, **큐·내부 담당자·PSTN 번호**(서드파티 전문가나 PCI Pal 같은 보안 결제 기관 등)로 상호작용을 이어간다. 담당자는 플로로 **웜/콜드 트랜스퍼**를 시작하거나 외부 번호로 자동 라우팅할 수 있다. 결제 정보 수집 중에는 **참가자별로 키패드 톤을 허용/차단하는 세분화된 DTMF 억제(suppression) 규칙**으로 카드 정보를 **담당자·콜 레그·녹음에서 숨긴다**.

#### 아웃바운드

**Route Outbound Calls to Service Reps After Customers Answer**
고객이 아웃바운드 통화를 받은 뒤 **IVR 또는 Agentforce 상호작용으로 자격을 판별(qualify)** 하고, 필요에 따라 가장 적절한 담당자로 라우팅하거나 **계정 담당자에게 직접 연결**한다.
- **이전 동작:** 아웃바운드 플로는 고객을 **IVR 또는 Agentforce 경험에만** 연결할 수 있어 담당자에 도달하려면 우회책이 필요했다.
- **How:** Flow Builder에서 **Initiate Outbound Flow Action** 을 구성하고, 통화 연결 후 고객을 **큐·스킬 기반 라우팅 대상·특정 서비스 담당자**로 연결하는 라우팅 액션을 추가한다. 플로에 오류가 나거나 예기치 않게 종료될 때를 대비해 **fallback 큐**를 설정한다.

**Control Outbound Call Behavior with Call Origination Flows and Voice Configurations**
플로가 **통화 단위로(per-call basis) 기본 발신자 ID를 동적으로 오버라이드**해, 통화 목적·고객 세그먼트·사업부·발신 지역 등에 맞는 번호를 고객에게 보여준다. **커스텀 voice configuration** 으로 표시할 CLI를 지정한다 — 브랜치의 모든 통화에 대한 **정적(static)** 방식이든, 고객 속성 기반 **동적(dynamic)** 방식이든.
- **How:** Flow Builder에서 아웃바운드 통화 플로에 **Set Voice Configuration** 액션을 추가한다. 정적 CLI(이 플로를 타는 모든 통화에 특정 번호)를 쓰거나, 동적 CLI를 쓴다 — 예를 들어 플로가 고객의 **Country 필드를 읽어 커스텀 메타데이터에서 매칭되는 CLI를 찾아** 통화에 적용할 수 있다. **발신자 ID 오버라이드는 이 플로로 시작된 통화에만 적용되고 채널의 기본 CLI를 바꾸지 않는다.**

**Configure Outbound Calls with Outbound CLI Numbers and Flow Inputs**
**사전 승인된 발신자 ID**로 Omni-Channel 플로에서 아웃바운드 음성 통화를 직접 시작한다. 발신자 식별은 **Number Management에서 Outbound CLI로 지정된 번호에서만** 선택하게 해 설정 오류를 줄이고 신원 컴플라이언스를 강제한다. 플로 액션의 **동적 값을 통화의 experience flow에 변수로 그대로 전달**해 고객·케이스 컨텍스트로 상호작용을 즉시 개인화한다.

#### 대기·콜백·피드백

**Engage Callers While They Wait with In-Queue Experience**
반복적인 대기 음악을 **설정 가능한 In-Queue Experience 플로**로 대체한다. 커스텀 프롬프트를 재생하고, 실시간 **대기열 위치(PIQ)** 와 **예상 대기 시간(EWT)** 을 알리거나 콜백을 제안한다 — 이 모든 것이 **대기열 위치·스킬 매칭·우선순위에 영향을 주지 않는다.** 라우팅 경로별로 서로 다른 대기 경험을 구성할 수 있고, **담당자가 가용해지는 즉시 재생이 중단**된다.

**Schedule and Automate Customer Callbacks**
고객이 **특정 날짜·시각으로 콜백을 예약**할 수 있다. 예약된 콜백은 가용한 담당자에게 자동 라우팅되고, 담당자가 콜백 배정을 수락하면 고객에게 통화가 시작된다. **고객의 원래 대기열 위치를 보존**하며, 설정된 재시도 설정에 따라 **실패한 연결을 자동 재시도**한다.

**Collect Customer Feedback Automatically After Calls**
담당자가 통화를 종료하면 **설문을 수동 전환하지 않고도** 고객 피드백을 자동 수집한다. Omni-Channel Flow에 **Set End Call Experience** 플로 액션을 추가하면 **고객이 연결된 상태에서** 어드민이 작성한 IVR 설문이 트리거된다. 설문 플로가 만족도 등급 같은 **DTMF 응답을 수집**하도록 구성하고, 설문 데이터를 **Voice Call 레코드나 커스텀 오브젝트에 저장**하거나 리포트·대시보드 구축에 활용한다.

**Handle Off-Hours and Busy-Hour Calls with Voice Message Capture**
바쁜 시간대나 영업시간 외에 발신자가 음성 메시지를 남기면 **자동으로 녹음·전사·요약되어 전체 컨텍스트와 함께 콜백 요청에 첨부**된다. 메시지 캡처 방법은 두 가지 — **대화형 Agentforce 에이전트**를 쓰거나, Omni-Channel 플로 안에서 **Capture Voice Message 플로 액션**을 쓴다.

#### 컴플라이언스·품질

**Protect Customer Privacy with Automatic Call Recording Redaction**
**신용카드 번호·PII 같은 민감 정보를 통화 녹음에서 자동 리댁션**한다. 수작업 없이 컴플라이언스 리스크를 줄이고 고객 데이터를 보호하며, 교육·리뷰용 통화 품질과 컨텍스트는 보존한 채 **PCI DSS**·**GDPR** 등 규제 요건을 충족한다.
- **How:** Setup → **Recording and Transcription** 페이지 → **Sensitive Data Redaction for Audio Recordings** 를 켠다.
- *소스 원문 주의:* 이 리프 본문 마지막 문장은 *"Reduce Quality Analyst effort with AI-powered automated evaluation of every voice, messaging, and email-to-case interaction."* 로, 내용상 아래 **Evaluate Every Interaction** 항목에 속하는 문장이 리댁션 페이지에 섞여 있다. **소스 원문 그대로 기록**한다.

**Evaluate Every Interaction**
**음성 통화·메시징 대화·email-to-case 교환**에 걸친 모든 고객 서비스 상호작용을 AI로 자동 평가한다. **상호작용 속성에 따라 적절한 평가 폼(evaluation form)이 매칭**된다. QA 팀 업무량을 늘리지 않고 상호작용 **전수 평가 커버리지**를 달성하고, 전 채널의 담당자 코칭 기회를 식별하며, 서비스 품질 추이를 추적한다.
- **Where:** Lightning Experience — **Enterprise, Performance, Unlimited editions**. (다른 AFCC 리프와 달리 **텔레포니 모델이 아니라 에디션 기준**으로 범위가 정해진다.)
- **Who:** 품질 관리·평가에는 **Agentforce Contact Center Quality Manager** 또는 **Quality Analyst** 권한 세트, 품질 점수 조회에는 **Quality Viewer** 권한 세트.
- **How:** Setup → **Quality Management** 페이지 → **Automated Quality Evaluation** 을 켜고 폼 매핑을 설정한다.
- **구조 메모:** 이 리프는 상위 `rn_afcc_voice` TOC의 18개 제목 목록에 **나타나지 않는다**(TOC 밖 리프). 소스 구조 그대로 기록한다.

### AFCC Voice — 이 영역 안이지만 리프가 미추출인 3항목

아래 3건은 `rn_afcc_voice` TOC에 **완전한 설명문이 포함**돼 있으나, **개별 리프 페이지가 이 노트의 추출 31페이지에 들어 있지 않다.** 다른 영역으로 간 게 아니라 **이 영역의 자식인데 미추출**이다(위 28리프 중 3건). **그래서 Where/Who/How 세부가 없다** — 아래 TOC 설명문이 확보 가능한 전부이며, 리프를 확보하면 내용이 늘어날 자리다.

**Find Available Reps Faster During Call Transfers**
통화를 전환할 때 서비스 담당자에게 **Omni-Channel 위젯에서 가용한 담당자만 필터링된 목록**이 보인다. 전체 전화번호부 대신 **통화를 수락할 수 있는 사람만** 표시되어 스크롤이 줄고 전환 속도가 빨라진다. Omni-Channel 설정에서 **Direct-to-Agent Routing** 을 켜면 이 필터가 기본 적용된다.

**Speed Up Rep Actions with Keyboard Shortcuts in Agentforce Contact Centers**
Agentforce Contact Center에서 담당자가 소프트폰의 빠른 컨트롤용 **키보드 단축키를 구성하고 사용**할 수 있다. 생산성 향상·응답 시간 단축·접근성 개선 효과가 있다.
- **이전 동작:** 이 기능은 **Salesforce Voice with Telephony Providers 에서만** 제공됐다.

**Keep an Audit Trail of Voice Call Record Changes (Pilot)** — 이 노트가 확인한 **유일한 Pilot**(리프 미추출 상태에서 TOC 설명문으로만 잡힌 항목이다)
**VoiceCall 오브젝트의 필드 변경을 추적**한다.

| 항목 | 값 |
|---|---|
| 추적 가능 필드 수 | **최대 20개** (*"Select and monitor up to 20 fields."*) |
| 로그 항목이 캡처하는 것 | **이전 값(old value)** · **새 값(new value)** · **변경한 사용자** · **날짜와 시각** |
| 미지원 | **Activity 필드는 이력 추적을 지원하지 않는다** (*"Activity fields aren't supported for history tracking."*) |

> VoiceCall 오브젝트와 통화 데이터 모델 전반은 [[Service Cloud Voice]] 참조.

---

## Einstein Work Summaries

Voice 통화와 Enhanced Messaging 세션의 작업 요약(work summary)을 자동 생성·저장한다. 이번 릴리즈의 핵심은 **자동 생성 기본 활성화**, **5개 언어 추가**, 그리고 **Case용 Beta의 은퇴**다.

> **근거 범위:** 아래 4건은 허브 `rn_einstein_work_summaries` 의 TOC 설명문이 근거다. **4건 모두 개별 리프 페이지는 이 노트의 추출 범위 밖**(위 28리프 중 4건)이므로 Where/Who/How 세부는 확보되지 않았다 — 다른 영역이 아니라 미추출이다.

### Work Summaries for Case (Beta) Is Being Retired — 2026-09-30

> 소스 원문: *"Work Summaries for Case (beta) is scheduled for retirement on **September 30, 2026**, and is in **maintenance mode until then**."*

- **은퇴 예정일: 2026년 9월 30일.** 그때까지는 **maintenance mode** 다.
- 그날까지 계속 사용할 수 있으나, **Enhanced Summaries 로의 전환이 권고**된다.
- **Enhanced Summaries 를 권하는 이유(소스):** **역할별 요약(role-specific summaries)** 과 **더 많은 요약 기능**을 제공해 서비스 담당자의 업무 효율을 높인다.

### Automate Summary Generation for Enhanced Messaging

Enhanced Messaging 세션이 끝나면 작업 요약이 **자동 생성**된다. **자동 생성은 기본값이 ON** 이라 세션 종료 즉시 담당자가 메시징 요약을 본다. 담당자가 세션 직후 검토·저장하거나, **담당자 검토 없이 자동 저장되도록 구성**할 수 있다.

### Automate Summary Generation for Voice Calls

Voice 통화가 끝나면 작업 요약이 **자동 생성**된다. **자동 생성은 기본값이 ON** 이라 통화 종료 즉시 담당자가 통화 요약을 본다. 담당자가 통화 직후 검토·저장하거나, **담당자 검토 없이 자동 저장되도록 구성**할 수 있다.

### Generate Work Summaries for Enhanced Messaging and Voice Calls in Five More Languages

Enhanced Messaging·Voice 통화용 Work Summaries가 기존 지원 언어에 더해 **5개 언어를 추가** 지원한다.

| 추가된 언어 (5개) |
|---|
| **Czech** · **Greek** · **Hungarian** · **Polish** · **Romanian** |

- **요약은 대화가 다른 언어로 진행됐더라도 담당자의 언어로 생성된다.** (*"Summaries are generated in the rep's language even when the conversation takes place in a different language."*)

---

## Einstein Article Recommendations

소스 표기: 섹션 제목은 **Einstein** Article Recommendations, 본문은 **Agentforce** Article Recommendations — 두 표기가 같은 기능을 가리킨다(소스 그대로).

**Resolve Every Issue in a Case with Multi-Intent Article Recommendations**

- Agentforce Article Recommendations for Cases가 하나의 케이스에 문제가 여럿 제기될 때 **최대 3개의 서로 다른 의도(intent)** 를 식별한다.
- **의도마다 별도의 타깃 검색을 구성**하고, 결과를 **하나의 순위 목록(ranked list)** 으로 병합해 담당자가 응답에 활용하게 한다.
- **이전 동작:** 케이스 전체에서 만든 **단일 검색 쿼리** 때문에 가장 두드러진 주제가 다른 이슈의 문서를 밀어냈다.

---

## Agentforce Service Assistant

정적 체크리스트를 넘어, **대화형 실시간 이슈 해결 가이던스**를 제공하는 방향으로 진화한다.

**새 경험이 하는 일:**
- 서비스 담당자를 이슈 해결 단계별로 **대화형으로 안내**한다.
- **레코드를 지속 모니터링**해 새 정보를 감지하고, **지식 정보를 노출하고 에이전트 액션으로 단계 작업을 완료**하며 **계획(plan)을 실시간으로 동적 갱신**한다.
- **전용 에이전트 채팅 경험**을 제공해, 담당자가 필요할 때 액션을 실행하고 지식을 조회할 수 있다.
- **메시징 세션을 지원**해, 빠르게 흐르는 대화 속도에 맞춘 실시간 해결 가이던스를 제공한다.
- **여러 개의 Service Assistant 에이전트를 생성**해 사업부·레코드 타입·큐별로 특화할 수 있다.

### 구현자가 알아야 할 제약 — 새 Agentforce Builder에서 지원되지 않는다

> 소스 원문: *"At this time, Service Assistant isn't supported in the new Agentforce Builder. Starting in July 2026, the requirement that new agents can only be created in the new Agentforce Builder doesn't apply to Service Assistant. Continue to use the legacy builder."*

- **현재 Service Assistant는 새 Agentforce Builder에서 지원되지 않는다.**
- **2026년 7월부터 시작된 "신규 에이전트는 새 Agentforce Builder에서만 생성 가능" 요건이 Service Assistant에는 적용되지 않는다.** → **레거시 빌더를 계속 사용**한다.
- 새 빌더에서 지원될 때는 **사전에 릴리즈 노트로 공지**하겠다고 소스가 밝힌다.
- **레거시 빌더에 접근할 수 없다면:** 새 Agentforce Builder로 가서 **Agentforce Service Assistant** 를 선택하면 **자동으로 레거시 빌더로 라우팅**된다.

### 월간 릴리즈 — 7·8월 노트가 Winter '27로 접혀 들어왔다

Service Assistant는 **월 단위로 기능을 릴리즈**한다. 소스는 **2026년 7·8월에 이미 제공된 기능의 릴리즈 노트를 가시성 확보 목적으로 Winter '27에 함께 싣는다**고 밝히며, 각 노트의 **When 섹션이 실제 제공 시점**을 나타낸다고 안내한다. 아래 **12건**이 그 표다. 12건 모두 **이 영역 안의 개별 리프 페이지이지만 이 노트의 추출 범위 밖**(위 28리프 중 12건)이라 **제목만** 라우팅용으로 기록한다 — 각 항목의 When·Where·상세는 확보되지 않았다.

| 월 | Feature Releases |
|---|---|
| **August '26** (3건) | Catch Up on Active Customer Interactions with Conversation Catch-Up in Service Assistant · Know When Service Plan Creation is in Progress with a Status Indicator · Work With Service Assistant After a Messaging Session Ends |
| **July '26** (9건) | Automate Service Plans with Agent Actions · Get Real-Time Issue Resolution with Dynamic Service Plans · Provide Service Reps Dynamic, Real-Time Issue Resolution Guidance for Messaging Sessions · Start Messaging Service Plans Automatically · Access Resources Linked in Plan Steps with Clickable URLs · Provide Service Reps with Immediate Case and Customer Context with Case Catch-Up & Insights · Use the Service Assistant Chat to Receive Additional Resolution Assistance · Respond Faster and More Accurately to Customers with Service Replies in Service Assistant · Scale Service Assistant Across More of Your Business with Multiple Agents |

---

## AI Agents for Service Cloud — Agentforce for HR Service

`rn_ai_agents_service` 섹션은 **스텁**이다. 자식이 **Agentforce for HR Service 하나뿐**이며 그 외 내용이 없다.

**Automate HR Workflows with Prebuilt HR Agents**

- 사전 구축(prebuilt) Agentforce 에이전트 라이브러리를 확장한다: **payroll(급여) · compensation(보상) · time and scheduling(근태·스케줄링) · onboarding(온보딩)**, 그리고 **goals management(목표 관리) 향상**.
- 커스텀 구축 없이 **빈도가 높은 직원 요청**을 커버한다.
- 직원은 대화를 통해 **급여명세서·total rewards 조회**, **스케줄·출퇴근 기록 확인**, **가이드형 온보딩 작업 완료**를 처리한다.
- 에이전트가 **로스터 리스크를 표시(flag)** 하고 **교대 근무 교환(shift swap) 대상을 매칭**한다.
- 각 에이전트는 **사전 구축된 MuleSoft for Flow 커넥터**로 기존 HR 시스템에 연결되므로, 일상적 요청이 HR 팀의 수작업 없이 해결된다.

---

## Agentforce IT Service — 허브만 추출됐고 하위 9섹션은 미추출

`rn_agentforce_it`은 **허브 페이지**다. 대화 우선(conversation-first) IT 서비스 솔루션으로, AI 기반 자동화로 티켓을 더 빨리 해결하고 직원에게 통합·선제적 서비스 경험을 제공한다는 개요만 있고, **실제 기능은 이 영역 안의 9개 하위 섹션에 있으나, 그 9개는 이 노트의 추출 범위 밖이다**(위 28리프 중 9건 — 다른 영역이 아니라 미추출). 아래는 허브가 제공한 하위 섹션 라우팅 요약이다(허브가 쓴 설명 범위를 넘어 내용을 추정하지 않는다).

| 하위 섹션 | 허브가 밝힌 범위 |
|---|---|
| **Service Management** | 서비스 데스크 운영 최적화 — 고가치 사용자 우선순위화, 이메일·코멘트를 통한 인시던트 해결, 서비스 요청 라이프사이클 관리, 콘솔 향상을 통한 종합 인사이트 |
| **IT Asset Management** | Agentforce AI 에이전트가 직원 문의·소싱 결정·폐기 정산을 대화형으로 처리하는 하드웨어 라이프사이클 자동화. 감사 대응용 **complete double-entry ledger** 로 모든 재고 변경 추적. 모든 액션을 한 페이지로 모으는 **Fast Path fulfillment**, 조직 프로세스에 맞춘 자산 상태 매핑 커스터마이즈 |
| **Configuration Management Database and Service Graph** | 역할에 맞는 세부 정보를 표시하도록 configuration item 목록 뷰 구성. 표준/커스텀 참조 필드 추가, 목록에서 관련 레코드 직접 열기 |
| **Discovery for Salesforce CMDB & Service Graph** | 서버·클라우드 인벤토리와 **Splunk** 운영 이벤트로 CMDB 데이터 최신화. **Dynamic Discovery** 로 Splunk discovery target 생성, 불완전 CI 검토 후 CMDB 추가. Dynamic Discovery를 지원하는 신규 Discovery 오브젝트와 플랫폼 이벤트 |
| **IT Compliance** | 지속적·자동 증거 수집, AI 보조 통제 커버리지, 신뢰할 수 있는 AI 정책 작성. 대량 액션으로 규제·정책 라이프사이클 가속, 사전 구축 **Tableau 대시보드**로 태세 모니터링 |
| **AI for IT Teams and Employees** | IT 티켓용 파일 분석 자동화, 조직 프로세스에 맞춘 AI 프롬프트·필드 매핑 커스터마이즈 |
| **Collaboration Channels** | **Slackbot** 과의 자연어 대화로 IT 이슈 해결(비밀번호 재설정·소프트웨어 접근·계정 프로비저닝 등). **Teams 통합 원클릭 배포**와 Teams 목록 뷰 커스터마이즈 |
| **Self-Service** | Employee Services 포털의 셀프서비스 경험 — 코드 없이 티켓 목록·티켓 상세·승인 목록 페이지의 필드·버튼 제어. 직원 선호 언어 제공, 티켓의 코멘트·피드. Agentforce로 해결된 인시던트·문제·변경 요청을 재사용 가능한 Knowledge 문서로 전환 |
| **Broadcast and Notifications** | 이메일·in-app·Slack·Teams로 한 번에 브로드캐스트 발송(주요 인시던트·변경 요청 시). 평문 Slack 알림을 라벨 구획·액션 버튼이 있는 구조화 알림으로 전환. Agentforce 에이전트를 통해 알림을 전달해 직원이 Slack 스레드 안에서 후속 질문·액션 수행 |

> 소스 자체 주석은 이 하위 섹션들을 "8개"라고 쓰지만 실제 나열은 **9개**다. 나열된 9개를 그대로 기록한다.

---

## 등급별 집계 — **추출된 31페이지 기준**의 부재 기록

"없다"를 남겨야 다음 릴리즈와 비교할 수 있다. 다만 아래 표의 **0건은 영역 전체가 아니라 이 노트가 근거로 삼은 31페이지 안에서의 0건**이다. 미추출 28리프에 해당 등급 항목이 있는지는 **확인되지 않았다** — 유일한 Pilot 항목조차 리프가 미추출이라 TOC 설명문에서만 잡혔다는 사실이 그 위험을 그대로 보여준다.

| 카테고리 | 추출된 31페이지 안 | 비고 |
|---|---|---|
| **GA (Generally Available)** | **0건** (추출 범위 내) | 미추출 28리프 미확인. 직전 릴리즈와의 규모 비교는 분모 미확정이라 **보류** — GA 시점 재추출 후 [[Winter '26/Agentforce]]와 비교 |
| **Release Update (강제 적용)** | **0건** (추출 범위 내) | 미추출 28리프 미확인. 강제 시점은 [[Winter '27/Release Updates]] 소관 |
| **신규 지원 모델 (GA/Beta)** | **0건** (추출 범위 내) | 모델 항목은 Gemini 2.5→3.5 **리라우트 공지 1건**뿐 |
| **Pilot** | **1건** (추출 범위 내) | Keep an Audit Trail of Voice Call Record Changes — **리프는 미추출**, 상위 TOC 설명문에서만 확인 |
| **Beta 마커 항목** | **1건** (추출 범위 내) | Work Summaries for Case (Beta) — **은퇴 대상**이라 신규가 아님 |
| **은퇴(Retirement)** | **1건** (추출 범위 내) | Work Summaries for Case (Beta), 2026-09-30 |
| **표준 에이전트 액션·서브에이전트** | **카탈로그 제목 4건** — 신규 에이전트 1(Approval Agent) + 신규 서브에이전트 3(Approval Management · Search Approval Records · Summarize Multiple Approval Work Items). 이 중 **Approval Management 서브에이전트가 신규 액션 1개(Recall Approval Submission)를 포함** | 이 항목만은 소스 페이지 전체(1,748자)를 확인한 **완전 카탈로그**다. 월 섹션도 **September '26 하나뿐** |

### "여기 없다"의 두 종류 — 반드시 구분한다

**A. 진짜 다른 제품 영역에 있는 것** — 이 영역의 페이지가 명시적으로 다른 영역으로 리다이렉트한다. 이 노트로는 도달할 수 없고, 그쪽 스포크 노트 소관이다.

| 주제 | 실제 위치 | 소스 근거 |
|---|---|---|
| **Workforce Engagement Management** | **Service Cloud 영역** | `rn_afcc` 허브가 자식으로 나열하되 리프는 그쪽 (설명문은 위 AFCC 섹션에 보존) |
| **Partner Contact Center** (서드파티 텔레포니·CCaaS) | **Service Cloud 영역** | `rn_afcc_voice` 본문이 *"...see Partner Contact Center"* 로 명시 리다이렉트 |

**B. 이 영역 안에 있는데 이 노트가 추출하지 않은 것 (28리프)** — 다른 영역으로 간 게 **아니다.** 전부 이 영역의 자식이며, **다음 추출 대상**이다. 여기 있는 등급·날짜·Where/Who/How는 아직 아무것도 확인되지 않았다.

| 부모 페이지 | 미추출 리프 | 이 노트에 남은 근거 |
|---|---|---|
| `rn_afcc_voice` | **3** | TOC 설명문 전문 — Find Available Reps · Keyboard Shortcuts · Audit Trail (Pilot). Where/Who/How 없음 |
| `rn_agentforce_it` | **9** | 허브가 쓴 하위 섹션 요약만 |
| `rn_ai_agents_sa` | **12** | 월별 표의 **제목만** |
| `rn_einstein_work_summaries` | **4** | 허브 TOC 설명문 |
| **합계** | **28** | **추출 31 + 미추출 28 = 영역 최소 59페이지** |

---

## 관련 노트

- [[Winter '27]] — Winter '27 릴리즈 노트 허브
- [[Winter '27/Release Updates]] — 강제 적용 시점 표의 단일 출처 (추출된 31페이지 안에는 Release Update 항목이 없다)
- [[Winter '27/Development]] — 개발자 표면 변경
- [[Winter '27/Platform]] — 플랫폼·Setup·보안 변경
- [[Winter '27/Clouds]] — 클라우드별 변경 (분산 배치된 AI 기능 다수가 여기 소관)
- [[Summer '26/Agentforce]] — 직전 릴리즈의 Agentforce 영역
- [[Winter '26/Agentforce]] — Winter '26 Agentforce 영역 (영역 규모 비교는 미추출 28리프 확보 후 재점검할 열린 과제)
- [[Service Cloud Voice]] — VoiceCall 오브젝트·텔레포니 데이터 모델 (Pilot 감사 추적·Voice 기능 맥락)
- [[Agentforce 개요 — 제품·에이전트 유형·구성요소]] — 에이전트·서브에이전트·빌더 개념
- [[Approval Process (승인 프로세스)]] — Approval Agent가 다루는 승인 프로세스 기반
- [[Approval Process — 운영·엔드유저·레퍼런스]] — 승인 제출·회수 운영 맥락
- [[Messaging for In-App and Web (MIAW)]] — Enhanced Messaging 세션 맥락 (Work Summaries 대상 채널)
- [[Release MOC]] — 전체 릴리즈 노트 목차
