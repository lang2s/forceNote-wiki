---
tags: [release, winter_27, release_update, deprecated, security, accessibility, oauth]
api_version: v68.0
release_date: 2026-10
created: 2026-08-24
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2)
aliases: [Winter '27 Release Updates, 윈터27 강제 적용, v68 릴리즈 업데이트, Winter 27 Enforced, Profile Filtering 강제, Use Any API Auth, WCAG 2.2 접근성 릴리즈 업데이트, 릴리즈 업데이트 강제 시점, External Client Apps 마이그레이션, OAuth username-password 은퇴]
---

# Winter '27 — Release Updates (강제 적용 항목 · 시점 맵)

> Winter '27(v68.0) 강제 적용은 **정확히 5건** — 인증·권한 2건(Profile Filtering · SOAP `login()`의 Use Any API Auth) + 접근성(WCAG 2.2 Resize and Reflow) 3건. 그 밖에 하드 날짜 강제 2건(2026-12-01 · 2026-11-30), Spring '27 강제 10건, Summer '27 강제 3건, 취소 1건.
> **이 노트가 Winter '27 릴리즈의 강제 시점(Enforced) 표 단일 출처(authoritative)다.** 허브나 다른 스포크가 강제 시점을 인용할 때는 이 표를 기준으로 한다.

> [!warning] Release Update는 **Setup → Quick Find → "Release Updates"** 페이지에서 확인한다. 강제일(Complete Steps By) 이전에 **Test Run**으로 조직·커스터마이제이션 영향을 검증하고 적용하라. 소스 원문: *"Every time a release update is created, it gets scheduled to be enforced in a future release."* — 즉 모든 업데이트에는 강제 릴리즈가 지정돼 있으며, 일부 항목(OAuth 플로 은퇴·Salesforce to Salesforce 은퇴)은 통합을 완전히 중단시킨다.

```text
// 구조 예시 — 실제 동작 코드 아님 (Winter '27 릴리즈 업데이트 강제 시점 맵)
2026-11-30 ──► OAuth 2.0 Device Flow를 로컬 External Client App으로 제한          (하드 날짜)
2026-12-01 ──► Maintain Your Email Verification Exception                        (하드 날짜)
Winter '27 ──► [강제 5건]  Profile Filtering
                          SOAP login() — Use Any API Auth 권한 필수
                          접근성 ① Page Headers · Modal Windows (>200%)
                          접근성 ② Date Pickers · Popovers · Bottom Utility Bars · Record Headers
                          접근성 ③ Cards · Docked Containers · Menu Lists · Panels
Spring '27 ──► To Do/Dual Listbox 접근성 · Aura 비공개 필드 제거 · Sharing 재계산 비동기
               · Instanced URL · Setup Audit Trail 권한 · Salesforce Connect Cross-Org 레거시 인증
               · Salesforce to Salesforce 은퇴 · SOAP login()(v31.0–64.0) 은퇴
2027-02-20 ──► OAuth user-agent / hybrid user-agent 플로 은퇴                     (하드 날짜)
2027-02-20 ──► OAuth 2.0 username-password 플로 은퇴 (Winter '27에서 연기됨)      (하드 날짜)
Summer '27 ──► 관리 패키지 익명 Apex 차단 · Connected App → External Client App(프로덕션)
               · Revenue Management 성능 최적화
취소       ──► Adopt Authorized Email Domains (→ Maintain Your Email Verification Exception로 대체)
```

```text
// 구조 예시 — 실제 동작 코드 아님 (Setup 탐색 경로)
Setup → Quick Find: "Release Updates"
  → 항목 선택 → [Get Started] 탭에서 영향·조치 확인
  → [Test Run] 으로 강제 전 영향 검증
  → "Complete Steps By" (강제일) 이전에 조치 완료
```

---

## 라우팅

- **상위 허브:** [[Winter '27]] — Winter '27 (v68.0, 2026-10) 릴리즈 노트 전체 진입점
- **형제 스포크:** [[Winter '27/Development]] · [[Winter '27/Platform]] · [[Winter '27/Clouds]] · [[Winter '27/Agentforce]]

---

## 강제 시점 요약표

| 강제 시점 | 항목 수 | 성격 |
|---|---|---|
| **Winter '27 강제됨 (Enforced with This Release)** | **5건** | 인증·권한 2건 + 접근성 3건 — 지금 즉시 영향 |
| **Spring '27 이전 (하드 날짜)** | 2건 | 2026-11-30 · 2026-12-01 — 릴리즈 업그레이드가 아니라 **달력 날짜**로 강제 |
| **Spring '27 강제 예정** | 10건 | 이 중 2건은 2027-02-20 하드 날짜(OAuth 플로 은퇴) |
| **Summer '27 이전 (하드 날짜)** | 0건 | 소스에 항목 없음 (버킷은 존재하나 비어 있음) |
| **Summer '27 강제 예정** | 3건 | 관리 패키지 익명 Apex · Connected App 은퇴 · Revenue Management |
| **취소됨 (Canceled)** | 1건 | Adopt Authorized Email Domains |

> 소스 원문(랜딩 페이지): *"Every time a release update is created, it gets scheduled to be enforced in a future release. We announce each update and its schedule here as soon as that schedule is known, but occasionally, updates are postponed or canceled."* — 아래 "연기·일정 변경 이력"에 이번 릴리즈의 연기 4건을 모았다.

---

## 그룹 1 — Winter '27에 강제 적용됨 (Enforced with This Release) — 5건

> 소스 `rn_ru` "Enforced with This Release" 버킷. **이 5건이 Winter '27 강제의 전부다.** 성격상 **인증·권한 2건 + 접근성(WCAG 2.2) 3건**으로 나뉜다.

### 1-A. 인증·권한 (2건)

| 항목 (정식 제목) | 영향 | Where | 조치 (How) |
|---|---|---|---|
| **Enable Profile Filtering (Release Update)** | 조직 보안 강화를 위해 **Profile Filtering 설정이 기본 활성화**된다. 프로파일 필터링이 켜지면 사용자는 **View All Profiles 권한이 없는 한 자신의 프로파일 이름 외에는 볼 수 없다.** (Summer '26에 처음 제공, Winter '27 강제) | Lightning Experience·Salesforce Classic, **Essentials · Professional · Enterprise · Performance · Unlimited · Developer · Database.com** 에디션 | 업무상 모든 프로파일 이름을 봐야 하는 사용자에게 **강제 전에** `View All Profiles` 권한을 부여. Setup → Release Updates → *Enable Profile Filtering* 의 테스트·활성화 단계 수행 |
| **Assign Use Any API Auth Permission for SOAP login() (Release Update)** | SOAP API `login()` 오퍼레이션으로 인증하려면 **모든 사용자에게 `Use Any API Auth` 사용자 권한이 할당**되어야 한다. 권한이 없는 사용자는 SOAP API `login()`으로 더 이상 인증할 수 없고 **에러가 발생**한다. | Lightning Experience·Salesforce Classic, **API가 활성화된 모든 에디션(all API enabled editions)** | 프로파일 또는 권한 집합(permission set)을 통해 사용자에게 `Use Any API Auth` 사용자 권한을 할당 |

> 소스 원문(Profile Filtering): *"If a user's role requires them to see all profile names, assign them the View All Profiles permission before this release update is enforced."*

> 참고 문서(소스 See Also) — *Salesforce Help: Limit Profile Details to Required Users*

> [!note] `Assign Use Any API Auth Permission for SOAP login()` 리프 페이지(`rn_api_soap_login`)에는 **"When:" 문단이 아예 없다.** Where/How만 있고 강제 시점 기술이 빠져 있어, 이 항목이 Winter '27 강제라는 사실은 랜딩 페이지 `rn_ru`의 "Enforced with This Release" 버킷 배치로만 확인된다. 이 항목은 아래 Spring '27의 *SOAP API login() (v31.0–64.0) 은퇴*와 **별개 항목**이다(전자는 권한 요구, 후자는 호출 자체 은퇴).

### 1-B. 접근성 — WCAG 2.2 Resize and Reflow (3건)

세 건 모두 **고배율(200% 초과) 브라우저 확대 시 Lightning Experience UI 동작을 적응**시키는 업데이트이며, **Where는 모두 "Lightning Experience in all editions"** 다. ②·③은 ①에 **종속(dependent)** 되므로 ①을 먼저 활성화해야 한다.

| # | 항목 (정식 제목) | 대상 UI | 최초 제공 → 강제 |
|---|---|---|---|
| ① | **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200% (Release Update)** | 페이지 헤더 · 모달 창 | Summer '25 제공 → **Summer '26 강제 예정에서 Winter '27로 연기** |
| ② | **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars, Record Headers (Release Update)** | 날짜 선택기 · 팝오버 · 하단 유틸리티 바 · 레코드 헤더 | Winter '26 제공 → **Summer '26 강제 예정에서 Winter '27로 연기** |
| ③ | **Enable Accessibility Enhancements for Cards, Docked Containers, Menu Lists, and Panels (Release Update)** | 카드 · 도킹 컨테이너 · 메뉴 리스트 · 패널 | Summer '26 제공 → Winter '27 강제 |

**① Page Headers · Modal Windows — Why (적용 전/후 동작)**

- 적용하면: 브라우저를 **200% 이상 배율**로 보는 사용자에게 콘텐츠가 보인다. 페이지 헤더가 **페이지와 함께 스크롤되어 콘텐츠를 가리지 않는다.** 모달 창에서는 버튼과 콘텐츠가 **뷰포트 안에** 표시되고 창이 완전히 동작한다.
- 적용하지 않으면: 200% 초과 확대 시 페이지 콘텐츠를 보기 어렵다. 스크롤할 때 **페이지 헤더가 콘텐츠를 가리고**, 모달 창에서는 버튼·콘텐츠가 **뷰포트 밖에 표시되어 가로 스크롤이 필요**해져 모달을 쓸 수 없게 될 수 있다.
- 이 변경은 **300%~400% 확대**를 원하는 사용자를 지원하기 위한 것이다.
- 소스 원문: *"This is the beginning of our effort to comply with WCAG 2.2 Resize and Reflow guidelines. Expect accessibility enhancements to other UI elements in future release updates."*

**② Date Pickers · Popovers · Bottom Utility Bars · Record Headers — Why**

- 적용하면 200% 이상 배율에서 날짜 선택기·팝오버·하단 유틸리티 바·레코드 헤더의 콘텐츠가 올바르게 표시된다. 미적용 시 이 UI들은 WCAG 2.2 Resize and Reflow 가이드라인을 준수하지 않으며 **콘텐츠가 일부만 표시될 수 있다.**
- 구체 목표: 날짜 선택기 · 팝오버 · **레코드 리스트 뷰 헤더**가 **1280px 페이지 너비 · 400% 배율**에서 접근 가능하고 사용 가능해진다.
- 하단 유틸리티 바는 **버튼 레이블을 유틸리티 바 높이에 맞게 잘라내며(truncate)**, 잘린 레이블의 전체 텍스트는 마우스 hover 또는 **키보드 포커스** 시 툴팁으로 표시된다.
- 시각 장애가 있는 사용자를 지원하기 위한 변경이다.

**③ Cards · Docked Containers · Menu Lists · Panels — Why**

- 적용하면 200% 이상 배율에서 카드·도킹 컨테이너·메뉴 리스트·패널의 콘텐츠가 올바르게 표시된다. 미적용 시 WCAG 2.2 Resize and Reflow 미준수이며 콘텐츠가 일부만 표시될 수 있다.
- 구체 목표: 카드·도킹 컨테이너·메뉴 리스트·패널이 **1280px 페이지 너비 · 400% 배율**에서 접근·사용 가능해진다.
- 이 UI 요소들의 **헤더 콘텐츠가 잘리지 않고(clipped) 다음 줄로 줄바꿈(wrap)** 된다.

**How (세 건 공통):** Setup → Quick Find에 `Release Updates` 입력 → Release Updates 선택 → 해당 업데이트의 테스트·활성화 단계를 따른다. 강제 시점 확인은 **Trust Status → 인스턴스 검색 → Maintenance 탭**에서 조직의 메이저 릴리즈 업그레이드 날짜를 본다.

---

## 그룹 2 — Spring '27 이전 강제 (하드 날짜) — 2건

> 소스 `rn_ru` "Scheduled To Be Enforced Before Spring '27" 버킷. **릴리즈 업그레이드가 아니라 달력 날짜로 강제**되므로 인스턴스 업그레이드 일정과 무관하다.

| 강제일 | 항목 (정식 제목) | 최초 제공 |
|---|---|---|
| **2026-11-30** | **Restrict the OAuth 2.0 Device Flow to Local External Client Apps (Release Update)** | late Summer '26 |
| **2026-12-01** | **Maintain Your Email Verification Exception (Release Update)** | Winter '27 |

### Restrict the OAuth 2.0 Device Flow to Local External Client Apps — 2026년 11월 30일

- OAuth 2.0 device flow 보안을 위해 Salesforce는 이 플로를 **localhost 콜백 URL을 가진 로컬 External Client App으로 제한**한다.
- 준비: device flow 사용 현황을 검토하고 connected app·external client app을 새 기준에 맞게 업데이트한다. **Connected App은 device flow를 계속 쓰려면 External Client App으로 마이그레이션해야 한다.**
- 소스 원문: *"This update is available starting in late Summer '26 and is enforced on November 30, 2026."*

### Maintain Your Email Verification Exception — 2026년 12월 1일

- 과거 **Salesforce Customer Support를 통해 사용자 이메일 검증을 비활성화**했던 조직은, 예외를 유지하고 사용자의 이메일 발송 능력을 보존하려면 **authorized email domain 설정을 구성**해야 한다. 이 업데이트가 강제되면 **Salesforce가 이메일 검증을 비활성화하던 기존 도메인 allowlist를 제거**한다.
- **Where:** Lightning Experience·Salesforce Classic, **Database.com을 제외한 모든 에디션**. 영향을 받는 조직에서는 Setup의 Release Update 페이지에 이 항목이 나타난다. (= 페이지에 항목이 보인다면, 과거 프로세스로 최소 1개 도메인의 이메일 검증이 비활성화된 조직이라는 뜻)
- **Why:** 이 업데이트는 **Salesforce에서 이메일을 발송하는 능력에만 영향**을 준다 — 사용자 계정 검증이나 **로그인 능력에는 영향이 없다.**
- authorized email domain의 새 필드 **Require Address Verification to Send Email** 로 Customer Support에 케이스를 열지 않고 Setup에서 직접 이메일 검증 설정을 제어할 수 있다. 하나 이상의 authorized email domain에서 이 필드를 **Never** 로 설정하면 Salesforce는 **사칭(impersonation) 사기 방지를 위해 이메일 주소 업데이트를 제한**한다.
- 조치를 완료하지 않으면 다음 동작이 강제된다.
  - 이메일 주소와 반송(return) 이메일 주소를 검증하지 않은 **기존 사용자는 Salesforce에서 이메일을 발송할 수 없다.**
  - 사용자가 Salesforce에서 이메일 주소나 반송 주소를 변경하면 그 변경은 **새 이메일 주소를 확인(confirm)한 뒤에만** 적용된다.
- **관련:** 이 항목은 아래 "취소됨"의 *Adopt Authorized Email Domains* 를 **대체**한 업데이트다.
- **참고 문서(소스 See Also):** *Salesforce Help: Set Up an Authorized Email Domain* · *Salesforce Help: Use a Verified Domain for User-Level Email Verification* · *Specify Which Email Domains Require Address Verification*

---

## 그룹 3 — Spring '27 강제 예정 — 10건

> 소스 `rn_ru` "Scheduled to Be Enforced in Spring '27" 버킷. 이 중 OAuth 관련 2건은 **2027-02-20 하드 날짜**다.

| 항목 (정식 제목) | 영향 | 준비 사항 | 강제 시점 |
|---|---|---|---|
| **Retirement of OAuth 2.0 Username-Password Flow for Connected Apps (Release Update)** | Connected App의 OAuth 2.0 **username-password 플로 지원 중단**. 이 플로를 쓰는 **모든 connected app 통합이 깨진다.** | OAuth 2.0 **web-server 플로** 또는 **client credentials 플로**로 전환 | **2027-02-20** (Spring '26 최초 제공, **Winter '27 강제 예정에서 연기**) |
| **OAuth User-Agent and Hybrid User-Agent Flows Retirement (Release Update)** | OAuth **user-agent 플로**와 **hybrid user-agent 플로** 은퇴 | 보안을 위해 **PKCE(Proof Key for Code Exchange) 확장을 사용한 web-server 플로 또는 hybrid web-server 플로**로 통합 업데이트 | **2027-02-20** (late Summer '26 최초 제공) |
| **Update Apex Code and Flows for Changed Sharing Recalculation Behavior (Release Update)** | 그룹·역할(role)에 대한 **대규모 업데이트 후 성능 최적화를 위해 일부 sharing 재계산이 비동기(asynchronously)로 수행**된다. share 레코드가 **즉시** 갱신되어야 하는 Apex 코드·Flow는 **강제 시 깨질 수 있다.** | 그룹 멤버십·역할을 업데이트하면서 **동기 sharing 재계산에 의존하는** Apex 클래스·테스트·트리거·Flow를 수정 | Spring '27 (Spring '26 최초 제공) |
| **Remove Non-Public Fields from Custom Object Data in Aura Action Responses (Release Update)** | 보안 강화를 위해 **Aura 액션 응답의 커스텀 오브젝트 데이터에서 비공개 시스템 필드 제거**. 공개 Salesforce API에 속하지 않는 내부 시스템 필드가 응답에서 필터링된다. | 커스텀 오브젝트 데이터를 처리하는 Lightning 컴포넌트를 검토해 **JavaScript 에러·데이터 누락**을 예방. API 지원 필드만 사용 | Spring '27 (Summer '26 최초 제공) |
| **Salesforce Connect Cross-Org Adapter Legacy Authentication Is Being Retired (Release Update)** | Salesforce Connect **cross-org 어댑터의 password·OAuth 2.0 인증 방식 은퇴**. 이 인증 방식들은 **은퇴 예정인 SOAP `login()` 호출에 의존**하기 때문. cross-org 어댑터는 이제 **named credential** 인증을 지원한다. | cross-org 어댑터 external data source를 **named credential** 인증으로 마이그레이션 | Spring '27 |
| **Salesforce to Salesforce Is Being Retired (Release Update)** | Salesforce to Salesforce **완전 은퇴**. | **Partner Cloud · Data Cloud One · MuleSoft Anypoint · MuleSoft for Flow** 중 하나로 통합 마이그레이션 | Spring '27 (단계적 — 아래 참조) |
| **SOAP API login() Call in SOAP API Versions 31.0 Through 64.0 Is Being Retired (Release Update)** | **SOAP API v31.0 ~ v64.0의 `login()` 호출**이 더 이상 지원되지 않고 사용할 수 없게 된다. | — (소스에 조치·준비 안내 없음: `rn_ru` 한 문장 항목이며 전용 리프 페이지가 없다) | 버킷은 Spring '27 / 본문은 Summer '27 (아래 불일치 기록 참조) |
| **Update Instanced URLs in API Traffic (Release Update)** | 잘못된 instanced URL을 쓰는 API 트래픽 지원 종료. 조직 API 트래픽이 조직의 **My Domain 로그인 URL**을 사용해야 한다. **Where:** Lightning Experience·Salesforce Classic(모든 조직에서 제공되지는 않음), **Database.com 제외 모든 에디션** | API 트래픽을 My Domain 로그인 URL로 전환 | Spring '27 (Summer '25 최초 제공, **Spring '26 강제 예정에서 연기**) — **단계적(in phases) 강제**, 구체 날짜는 *End-of-Support Schedule for Incorrect Instanced URLs in API Traffic* 참조 |
| **View Setup Audit Trail Permission to Access Setup Audit Trail (Release Update)** | Setup Audit Trail 접근을 **전용 `View Setup Audit Trail` 권한**으로 제어. 관리자가 더 넓은 `View Setup` 권한을 주지 않고도 접근을 허용할 수 있어 **최소 권한 원칙**을 지원한다. **기존 접근 권한은 자동으로 보존된다.** | Setup Audit Trail 접근이 필요한 **신규 사용자**에게 프로파일 또는 권한 집합으로 권한 할당 | Spring '27 |
| **Enable Accessibility Enhancements for To Do Lists and Lightning Dual Listboxes When Zoom Is Greater Than 200% (Release Update)** | WCAG 2.2 Resize and Reflow 준수를 위해 고배율에서 **To Do 리스트·Lightning dual listbox** 동작을 적응. **Where:** Lightning Experience, 모든 에디션. To Do 리스트 항목이 **1366px 페이지 너비 · 400% 배율**에서 접근·사용 가능해지고, 콘텐츠가 잘리지 않고 줄바꿈된다. | Setup → Quick Find `Release Updates` → *Enable Accessibility Enhancements for To Do Lists and Lightning Dual Listboxes When Zoom Is Greater Than 200%* 의 테스트·활성화 단계 | Spring '27 (Summer '26 최초 제공) |

**Salesforce to Salesforce — 단계적 은퇴 일정**

| 단계 | 동작 |
|---|---|
| Spring '26 | 조직에서 Salesforce to Salesforce를 **새로 켤 수 없게** 됨. 단 Spring '26 이전에 활성화되어 있었다면 계속 동작 |
| Summer '26 | Salesforce to Salesforce **지원 중단(support discontinued)** |
| Spring '27 | **모든 조직에서 완전 은퇴하고 더 이상 동작하지 않음** |

- **Where(S2S):** Salesforce Classic(모든 조직에서 제공되지는 않음), **Contact Manager · Group · Professional · Enterprise · Performance · Unlimited · Developer** 에디션.
- **Where(Salesforce Connect Cross-Org):** Lightning Experience·Salesforce Classic(모든 조직에서 제공되지는 않음), **Enterprise · Performance · Unlimited · Developer** 에디션.
- **Where(Aura 비공개 필드 제거):** Lightning Experience, 모든 에디션. **How:** 지원되고 공식 문서화된 필드만 쓰는지 컴포넌트를 검토하고, **샌드박스에서 릴리즈 업데이트를 활성화해** 커스텀 오브젝트 데이터를 처리하는 모든 Lightning 컴포넌트·페이지를 테스트한다. 에러가 나면 비공개 시스템 필드 참조를 제거한다.

**Update Instanced URLs in API Traffic — Why (이 업데이트가 존재하는 이유)**

- Salesforce는 **API 애플리케이션 트래픽 라우팅에서 잘못된 인스턴스 이름을 하드코딩해 참조하는 것을 지원하던 서비스를 폐기(decommissioning)** 하는 중이다.
- API 트래픽에 **My Domain 로그인 URL을 쓰면, 조직이 다른 Salesforce 인스턴스로 이전된 뒤에도 그 로그인 방식이 계속 동작**한다.
- 또한 **My Domain 이름은 고유(unique)** 하므로, 조직의 My Domain 로그인 URL을 요구하는 것 자체가 **보안 계층을 하나 더 추가**한다.
- **How:** Setup → Quick Find `Release Updates` → *Update Instanced URLs in API Traffic* 의 테스트·활성화 단계.

**To Do Lists · Lightning Dual Listboxes 접근성 — Why**

- 적용하면 200% 이상 배율로 브라우저에서 Salesforce를 보는 사용자에게 **To Do 리스트·Lightning dual listbox의 콘텐츠가 올바르게 표시**된다.
- 적용하지 않으면 이 UI 부분들은 **WCAG 2.2 Resize and Reflow 가이드라인을 준수하지 않으며, 콘텐츠가 일부만 표시될 수 있다.**
- 시각 장애가 있는 사용자를 지원하기 위한 변경이다.

**참고 문서 (소스 See Also)**

- *Salesforce to Salesforce 은퇴* — Knowledge Article: Salesforce to Salesforce Retirement · Decision Guide: Data 360 Provisioning
- *Salesforce Connect Cross-Org 레거시 인증 은퇴* — Knowledge Article: Platform SOAP API login() Retirement

---

## 그룹 4 — Summer '27 이전 강제 (Before Summer '27) — 0건

> 소스 `rn_ru`에 "Scheduled To Be Enforced Before Summer '27" 버킷은 존재하지만 **나열된 항목이 없다** (버킷 자체가 사라진 것이 아니라 비어 있는 상태). 버킷 설명문은 다른 버킷과 동일한 정형 문구다 — 소스 원문: *"These updates are scheduled to be enforced before Summer '27. The list can include new, previously announced, and previously postponed release updates."*

---

## 그룹 5 — Summer '27 강제 예정 — 3건

| 항목 (정식 제목) | 영향 | Where | 준비 사항 |
|---|---|---|---|
| **Block Apex Anonymous Code Execution from Managed Packages (Release Update)** | 구독자(subscriber) 조직 보안 강화를 위해 **관리 패키지 세션 ID가 익명 Apex 코드를 인증하지 못하도록 차단**. 활성화하면 설치된 관리 패키지가 `UserInfo.getSessionId()`로 세션 ID를 얻어 그 세션 ID로 **익명 Apex를 실행할 수 없다.** | Lightning Experience·Salesforce Classic, **Enterprise · Performance · Unlimited · Developer** 에디션. **기존 1GP·2GP 관리 패키지 모두**에 적용 | 아래 "Important" 및 영향 평가(Impact Assessment) 참조 (Summer '26 최초 제공) |
| **Migrate All Connected Apps to External Client Apps (Release Update)** | Summer '27에 Salesforce가 **connected app 지원을 종료**한다. Connected app은 계속 동작하지만 **버그 수정·통합·인증 플로에 대한 지원이 사라진다.** | Lightning Experience, **Enterprise · Unlimited · Developer** 에디션 | **App Manager(Setup) → 해당 connected app 열기 → [Migrate to External Client App] 클릭** → 자동 프로세스가 external client app을 생성. Winter '27부터 사용 가능, **프로덕션 인스턴스는 Summer '27에 강제** |
| **Optimize Performance for Revenue Management (Release Update)** | **Configuration API 최적화**로 Product Configurator 사용 시 구성 처리 시간 단축. configurator 실행, 구성된 제품의 속성·수량 업데이트, 번들 구성 중 옵션 추가·제거 등 핵심 플로의 응답 시간이 빨라진다. **입력·출력·동작은 변하지 않고 성능만 개선**된다(특히 대량 트랜잭션 시나리오). | Lightning Experience, **Revenue Management(구 Revenue Cloud)** 의 Enterprise · Unlimited · Developer 에디션 + **Revenue Cloud Growth 또는 Revenue Cloud Advanced 라이선스** | Winter '27부터 사용 가능하며 **강제일까지는 opt-in**. 샌드박스에서 Test Run으로 검증 후 프로덕션 적용. 문제가 있으면 Test Run을 끄면 이전 구현으로 롤백되며, **강제일 전에 Salesforce Customer Support로 이슈를 신고**한다 |

**Block Apex Anonymous Code Execution — Important (강제와 무관하게 이미 적용되는 부분)**

> 소스 원문: *"This release update controls the behavior of existing managed packages installed in subscriber orgs. New managed packages with namespaces created in Summer '26 and later are blocked from anonymous Apex code execution, regardless of whether the subscriber enables this release update."*

- 즉 이 릴리즈 업데이트는 **구독자 조직에 이미 설치된 기존 관리 패키지의 동작**을 제어한다. **Summer '26 이후에 생성된 네임스페이스의 신규 관리 패키지**는 구독자의 활성화 여부와 **무관하게** 익명 Apex 실행이 차단된다.
- 신규 관리 패키지 코드가 익명 Apex 실행을 시도하면 다음 에러가 발생한다: `Managed package sessions are not authorized to call executeAnonymous.`
- **Why:** 이 보안 업데이트로 관리 패키지 개발자는 **모든 Apex 클래스를 패키지 메타데이터에 정의**해야 구독자 조직에서 실행할 수 있다. 그러면 관리 패키지 코드가 **버전 관리되고, 로깅되며, 접근 제어를 따른다.** 관리 패키지가 구독자 조직 코드와 직접 상호작용해야 한다면 **공유 `global` 인터페이스와 `Type.forName()`** 같은 표준 메커니즘 사용을 권장한다.
- **영향 평가:** 현재 설치된 관리 패키지 중 익명 Apex를 실행할 수 있는 것이 있는지 확인하려면 Setup의 **Apex Settings** 페이지에서 *"Impact Assessment: Block Apex Anonymous Code Execution from Managed Packages"* 노트를 검토한다. 평가 결과는 **익명 Apex를 실행할 수 있는 관리 패키지 목록**이거나, 최근 익명 Apex 실행이 감지된 관리 패키지가 없다는 **확인 메시지**다.

---

## 그룹 6 — 취소됨 (Canceled Updates) — 1건

> 소스 `rn_ru` "Canceled Updates" 버킷: 이전 릴리즈에 발표됐지만 **취소되어 Release Updates 노드에서 제거되었고 강제되지 않는다.**

| 항목 | 상태 | 대체 |
|---|---|---|
| **Adopt Authorized Email Domains (Release Update)** | **취소됨** — Setup의 Release Update 페이지에 더 이상 나타나지 않는다. **Where(참고):** Lightning Experience · Salesforce Classic · Salesforce 모바일 앱, 모든 에디션 | **Maintain Your Email Verification Exception (Release Update)** 로 대체 (→ 그룹 2, 2026-12-01 강제) |

> 소스 원문: *"This update has been canceled and replaced by the Maintain Your Email Verification Exception update."*

---

## 버킷 밖 항목 (rn_ru 버킷에 없으나 릴리즈 노트 Release Updates 영역에 존재)

### Enable ICU Locale Formats — **Winter '27 강제 아님**

> 소스 원문: *"The enablement of this release update is not enforced in Winter '27. If your org is already using ICU locale formats, those locale formats remain enabled. For any org still using JDK, we recommend that they use the release update to manually enable ICU locale formats."*

- ICU(International Components for Unicode) 로케일 형식이 Oracle JDK 로케일 형식을 대체한다. 로케일은 **날짜·시간·통화·주소·이름·숫자 값·주 시작 요일**의 형식을 제어한다. **Winter '20에 최초 제공**되었고, 아직 전환하지 않은 조직은 **수동 업데이트가 권장**된다(강제 아님).
- **Where:** Lightning Experience · Salesforce Classic · Salesforce 모바일 앱, **Group · Essentials · Starter Suite · Pro Suite · Professional · Enterprise · Performance · Unlimited · Developer** 에디션.
- **Who:** 모든 조직에서 활성화할 수 있다. 커스터마이제이션에서 ICU 로케일 형식을 쓰려면 **모든 Apex 클래스·Apex 트리거·Visualforce 페이지가 API 버전 45.0 이상**이어야 한다.
- **How:** Setup → Release Updates → *Enable ICU Locale Formats* 의 테스트·활성화 단계. **English (Canada) 로케일(`en_CA`)은 별도 활성화가 필요**하다 — Setup → Quick Find `User Interface` → **Enable ICU formats for en_CA** 선택 후 저장. 현재 조직이 ICU인지 JDK인지 확인하려면 Setup → **Company Information** → **Locale Formats** 필드를 본다.

### Conceal Personal Information Fields from Guest Users (Release Update)

- 리프 페이지의 **When: Spring '27 강제**. 게스트 사용자에 대한 필드 가시성을 다른 외부 사용자 설정에 영향을 주지 않고 설정한다. **Independent Guest Field Masking**을 켜면 특정 필드를 게스트 사용자에게만 숨길 수 있고, 새 **`Guest_PersonalInfo_EPIM` 필드 집합**이 추가되어 포털 사용자가 보는 내용을 바꾸지 않고 게스트 대상 필드를 보호할 수 있다.
- **Where:** Lightning Experience·Salesforce Classic을 통해 접근하는 **Aura · LWR · Visualforce 사이트**, **Enterprise · Performance · Unlimited · Developer** 에디션.
- **Why:** 인증되지 않은 외부 사용자(게스트 사용자)가 보는 PII가 공유 `PersonalInfo_EPIM` 대신 새 `Guest_PersonalInfo_EPIM` 필드 집합의 통제를 받는다. **인증된 외부 사용자(포털 사용자)는 계속 `PersonalInfo_EPIM` 필드 집합의 통제**를 받는다. 게스트 마스킹이 포털 사용자 마스킹과 분리되어, 외부 사용자 유형별로 어떤 필드를 감출지 정확히 고를 수 있다.
- 게스트 사용자는 인증된 포털 사용자보다 **필요한 사용자 필드 수가 대체로 적다.** 전용 게스트 사용자 필드 집합을 쓰면 **포털 사용자 경험은 그대로 둔 채 게스트에게는 더 많은 PII를 감출 수 있다.**
- **How:** Setup → Quick Find `Release Updates` → *Conceal Personal Information Fields from Guest Users* 의 테스트·활성화 단계.
- **참고 문서(소스 See Also):** *Salesforce Help: Configure Independent Guest Field Masking*
- ⚠️ 이 항목은 **`rn_ru` 랜딩 페이지의 어떤 버킷에도 나타나지 않는다** (아래 불일치 기록 참조).

### Republish Your Marketing Cloud Next Landing Pages (Release Update)

- **When: 2026년 10월.** Marketing Cloud Next 랜딩 페이지가 오래된 인프라에 호스팅되어 있을 수 있다. **페이지를 다시 게시(republish)하면 콘텐츠가 현재 지원되는 인프라로 자동 이동**하며 페이지 콘텐츠는 그대로 유지된다.
- **Where:** Salesforce **Enterprise·Unlimited** 에디션 + 다음 중 하나 — Marketing Cloud Next **Growth·Advanced** 에디션(Salesforce Foundations 애드온 포함) / Marketing Cloud Account Engagement **Growth·Plus·Advanced·Premium** 에디션(Foundations 애드온 포함) / **Marketing Cloud Engagement+** 모든 에디션(Foundations 애드온 포함).
- **Why:** Marketing Cloud Next 랜딩 페이지를 호스팅하는 인프라는 **개선된 인프라가 출시될 때마다 주기적으로 폐기(retired periodically)** 된다. 따라서 **한동안 게시하지 않은 랜딩 페이지는 오래된 인프라에 호스팅될 수 있고, 그 결과 페이지 성능이 저하(degraded page performance)** 될 수 있다 — 아래 "6개월" 기준의 근거다.
- **How:** Marketing Cloud의 Content Workspace에서 **Settings 메뉴 → Publication Calendar**로 마지막 게시일을 확인하고, **6개월보다 오래됐으면 다시 게시**한다.

### Salesforce Platform API Versions 21.0 Through 30.0 Retirement (Release Update) — **Summer '25 강제 (이미 지남)**

- **When:** Salesforce Platform API **v21.0 ~ v30.0 은퇴**는 **Summer '23에 최초 예정**되었다가 **Summer '25로 연기**되었다. **Summer '25부터 이 API 버전들은 지원되지 않고 사용할 수 없다.** 이 버전을 사용하는 애플리케이션은 중단되며, 요청은 **엔드포인트가 비활성화되었다는 에러 메시지와 함께 실패**한다. (→ Winter '27 강제 5건에는 포함되지 않는다. 강제는 이미 Summer '25에 발생했다.)
- **Where (영향받는 API 버전):** **Bulk API** 21.0–30.0 · **SOAP API** 21.0–30.0 · **REST API** v21.0–v30.0. `/services/data/vXX.X/` 아래 URI를 쓰는 **모든 REST API**가 영향을 받는다 — Bulk API · Connect REST API · IoT REST API · Lightning Platform REST API · Metadata API · Place Order REST API · Reports and Dashboards REST API · Tableau CRM REST API · Tooling API.
- **Where (에디션):** **Professional(API 액세스가 활성화된 경우) · Enterprise · Performance · Unlimited · Developer**. **샌드박스·스크래치 조직을 포함한 모든 API 활성 조직**에 영향을 준다.
- **준비 사항 (How):** **Summer '25 릴리즈 전에** 모든 애플리케이션을 현재 API 버전에서 동작하도록 수정·업그레이드한다. SOAP API·REST API·Bulk API의 **오래되었거나 지원되지 않는 API 버전에서 들어온 요청은 `API Total Usage` 이벤트로 식별**한다.
- **Test Run (강제 전 선제 적용):** Summer '25보다 **먼저 은퇴를 강제**할 수 있다 — Setup → Release Updates → *Salesforce Platform API Versions 21.0 Through 30.0 Retirement* → **Get Started** → **Enable Test Run**(은퇴 예정 API 버전으로의 호출을 거부) / **Disable Test Run**(강제 해제).
- ⚠️ 이 항목은 **`rn_ru` 랜딩 페이지의 버킷 표(이번 릴리즈 강제 / Spring '27 이전 / Spring '27 / Summer '27 이전 / Summer '27 / 취소됨) 어디에도 나타나지 않는다.** 강제 시점이 이미 지난(Summer '25) 항목이라 버킷 목록에서 빠진 것으로 보이나, 릴리즈 노트 본문(`rn_api_retirement_delay_256rn`)에는 그대로 남아 있다.

---

## 연기·일정 변경 이력 (이번 릴리즈에서 바뀐 것)

작업 계획을 세울 때 가장 값이 큰 정보다. Winter '27 노트에서 **일정이 바뀐 항목은 5건 — 연기 4건 + 취소 1건**이다.

| 항목 | 원래 일정 | 변경된 일정 | 방향 |
|---|---|---|---|
| **Retirement of OAuth 2.0 Username-Password Flow for Connected Apps** | **Winter '27 강제 예정** | **2027-02-20** | 연기 (이번 릴리즈 강제에서 빠짐) |
| **Update Instanced URLs in API Traffic** | **Spring '26 강제 예정** | **Spring '27** | 연기 |
| **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200%** | **Summer '26 강제 예정** | **Winter '27** | 연기 → 이번 릴리즈에 강제됨 |
| **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars, Record Headers** | **Summer '26 강제 예정** | **Winter '27** | 연기 → 이번 릴리즈에 강제됨 |
| **Adopt Authorized Email Domains** | (발표됨) | **취소** | 취소 → Maintain Your Email Verification Exception로 대체 |

> 소스 원문(username-password): *"This update was first available in Spring '26 and was scheduled to be enforced in Winter '27, but we postponed the enforcement date to February 20, 2027."*
> 소스 원문(Instanced URLs): *"First available in Summer '25, this release update was scheduled to be enforced in Spring '26, but we postponed the enforcement to Spring '27."*

---

## 개발자가 코드를 고쳐야 하는 항목 (조치 체크리스트)

| 항목 | 코드/설정에서 확인할 것 | 마감 |
|---|---|---|
| **Block Apex Anonymous Code Execution from Managed Packages** | 관리 패키지가 `UserInfo.getSessionId()` → 익명 Apex 실행에 의존하는가. 대체: 공유 `global` 인터페이스 + `Type.forName()`. Setup → Apex Settings의 Impact Assessment 확인 | Summer '27 |
| **Remove Non-Public Fields from Custom Object Data in Aura Action Responses** | Aura 액션 응답의 커스텀 오브젝트 데이터에서 **비공개 내부 시스템 필드**를 읽는 Lightning 컴포넌트가 있는가. 샌드박스에서 릴리즈 업데이트 켜고 전 페이지 테스트 | Spring '27 |
| **Update Apex Code and Flows for Changed Sharing Recalculation Behavior** | 그룹 멤버십·역할을 갱신한 뒤 **share 레코드가 즉시 갱신되었다고 가정**하는 Apex 클래스·테스트·트리거·Flow가 있는가 (동기 → 비동기 재계산) | Spring '27 |
| **Salesforce Connect Cross-Org Adapter Legacy Authentication** | cross-org 어댑터 external data source가 password 또는 OAuth 2.0 인증을 쓰는가 → **named credential**로 전환 | Spring '27 |
| **Salesforce to Salesforce 은퇴** | S2S 기반 파트너 연동 → Partner Cloud · Data Cloud One · MuleSoft Anypoint · MuleSoft for Flow로 이전 | Spring '27 (완전 은퇴) |
| **Migrate All Connected Apps to External Client Apps** | 모든 connected app을 App Manager의 **Migrate to External Client App**으로 전환 | Summer '27 (프로덕션 강제) |
| **OAuth 플로 은퇴 2건** | user-agent / hybrid user-agent / username-password 플로를 쓰는 통합 → **PKCE 적용 web-server(또는 hybrid web-server)·client credentials** 플로로 전환 | 2027-02-20 |
| **Restrict OAuth 2.0 Device Flow** | device flow 사용처를 **localhost 콜백 URL의 로컬 External Client App**으로 정리 | 2026-11-30 |
| **SOAP API `login()`** | ① Winter '27부터 호출 사용자에게 `Use Any API Auth` 권한 필요 ② v31.0–64.0의 `login()` 자체가 은퇴 예정 | ① Winter '27 ② Spring '27 버킷 / Summer '27 본문 |
| **Update Instanced URLs in API Traffic** | 하드코딩된 인스턴스 URL → 조직의 **My Domain 로그인 URL** | Spring '27 (단계적) |

---

## 소스 불일치 기록 (원문 그대로 남김)

> [!note] 이번 릴리즈 노트 페이지에는 **자체 모순 2건**이 있어 그대로 기록한다.
> 1. **`rn_experiences_conceal_pii_guests` (Conceal Personal Information Fields from Guest Users)** — 리프 페이지는 *"Salesforce enforces this update in Spring '27"* 이라고 명시하지만, 랜딩 페이지 `rn_ru`의 **어떤 버킷(이번 릴리즈 강제 / Spring '27 이전 / Spring '27 / Summer '27 이전 / Summer '27 / 취소됨)에도 이 항목이 나타나지 않는다.** 버킷 목록만 보면 존재하지 않는 업데이트처럼 보인다.
> 2. **`rn_api_soap_login` (Assign Use Any API Auth Permission for SOAP login())** — 리프 페이지에 **"When:" 문단이 아예 없다.** Where/How만 있어 리프만 읽으면 강제 시점을 알 수 없고, **Winter '27 강제라는 사실은 `rn_ru`의 "Enforced with This Release" 버킷 배치로만** 확인된다.
>
> 추가로, **SOAP API login() (v31.0–64.0) 은퇴**는 `rn_ru`에서 **"Scheduled to Be Enforced in Spring '27" 버킷에 배치**되어 있으나 항목 본문은 *"In Summer '27, the SOAP API `login()` call in SOAP API versions 31.0 through 64.0 will no longer be supported and no longer be available."* 라고 **Summer '27**을 말한다. 두 시점 중 어느 쪽이 정본인지 소스만으로는 확정할 수 없으므로 양쪽을 병기했다.

---

## 관련 노트

- [[Winter '27]] — Winter '27 릴리즈 노트 허브
- [[Winter '27/Development]] — Apex·Aura/LWC·API 개발자 영향 상세
- [[Winter '27/Platform]] — Admin·Security 맥락(Profile Filtering·이메일 검증·감사 추적)
- [[Winter '27/Clouds]] — 클라우드별 변경(Revenue Management·Marketing Cloud Next 등)
- [[Winter '27/Agentforce]] — Agentforce 변경
- [[Summer '26/Release Updates]] — 직전 릴리즈의 강제 시점 표 (Winter '27 예정 항목의 이전 상태)
- [[Winter '26/Release Updates]] — Winter '26 강제 시점 표
- [[Release MOC]] — 릴리즈 노트 전체 목차
- [[Profiles (프로파일)]] — Profile Filtering·View All Profiles 권한 맥락
- [[External Client App (외부 클라이언트 앱)]] — Connected App 대체 · Device Flow 제한 대상
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — Summer '27 지원 종료 대상
- [[Salesforce Connect — 어댑터·Cross-Org·writable·External CDC]] — Cross-Org 어댑터 레거시 인증 은퇴 맥락
- [[Named Credential]] — Cross-Org 어댑터의 대체 인증 방식
- [[SOAP API (표준 오퍼레이션·enterprise·partner WSDL)]] — `login()` 권한 요구·버전 은퇴 맥락
- [[Anonymous Apex 실행]] — 관리 패키지 익명 Apex 차단 맥락
- [[My Domain (마이 도메인)]] — Instanced URL → My Domain 로그인 URL 전환
