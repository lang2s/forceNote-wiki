---
tags: [admin, security, sharing, owd, organization-wide-defaults, sharing-rules, record-access]
source: help.salesforce.com (Salesforce Help — Set Up and Maintain Your Salesforce Organization; Organization-Wide Sharing Defaults & Sharing Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-02) + Salesforce Security Guide PDF v260 (salesforce_security_impl_guide.pdf, resources.docs.salesforce.com — Manual Sharing pp.72–75 · Create Guest User Sharing Rules p.60, Tier 2, 확인 2026-07-06)
official_doc: https://help.salesforce.com/s/articleView?id=platform.security_sharing_owd_about.htm&type=5
created: 2026-07-02
aliases: [OWD, Organization-Wide Defaults, 조직 전체 기본값, Sharing Rules, 공유 규칙, Owner-Based Sharing Rule, 소유 기반 공유 규칙, Criteria-Based Sharing Rule, 기준 기반 공유 규칙, Grant Access Using Hierarchies, External Sharing Model, Sharing Settings, Manual Sharing, 수동 공유, 레코드 Share 버튼, Guest User Sharing Rule, 게스트 사용자 공유 규칙]
---

# 조직 전체 공유 기본값(OWD)과 공유 규칙

> OWD로 레코드 기본 접근 수준(baseline)을 정하고, 공유 규칙으로 역할 계층과 무관하게 특정 사용자에게 접근을 **확대**하는 선언적 공유 모델의 설정 방법(Setup > Sharing Settings).

---

## 1. 조직 전체 공유 기본값(OWD)이란

**정의** — *"Define the default access that users have to records they don't own with organization-wide sharing settings."* 즉 사용자가 **소유하지 않은 레코드**에 대한 **기본 접근 수준(baseline)** 을 정하는 설정이다.

**핵심 원칙 (baseline은 바닥이다)** — 다른 레코드 접근 기능(역할 계층 · 권한 · 수동 공유 · 공유 규칙)은 **접근을 추가로 부여(grant)만** 할 수 있고, OWD로 정한 것보다 **더 제한(restrict)할 수는 없다**.

> *"Other record access features can only be used to grant additional access—they can't be used to restrict access to records beyond what was originally specified with the organization-wide sharing defaults."*

- 커스텀 오브젝트와 다수 표준 오브젝트에 대해 **오브젝트별로 개별 설정**할 수 있다.
- **내부 사용자**와 **외부 사용자**에게 서로 **다른 수준**을 설정할 수 있다(→ 외부 OWD, 5절).

**Available in:** Professional, Enterprise, Performance, Unlimited, Developer, Database.com Editions. Salesforce Classic + Lightning Experience.

---

## 2. OWD 접근 수준

일반 오브젝트에는 아래 4개 수준이 제공된다(특정 오브젝트 한정 추가 수준은 표 아래 참조).

| 접근 수준 | 정의 (원문 그대로의 의미) |
|---|---|
| **Controlled by Parent** | 사용자가 연결된 **모든 master 레코드**에 대해 어떤 작업을 수행할 수 있으면, detail-side 레코드에도 **동일 작업**을 수행할 수 있다. |
| **Private** | ownership, permissions, role hierarchy, manual sharing, or sharing rules로 접근이 부여된 사용자**만** 레코드에 접근할 수 있다. |
| **Public Read Only** | 모든 사용자가 모든 레코드를 **볼 수 있다(view)**. |
| **Public Read/Write** | 모든 사용자가 모든 레코드를 **보고 편집할 수 있다(view and edit)**. |

> 특정 오브젝트에 한해 **Public Full Access**, **View Only** 같은 추가 수준이 존재한다고 문서가 언급한다. 일반 오브젝트에는 위 4개가 적용된다.

**언제 무엇을** — 협업 폭이 넓을수록(Public Read/Write) 개방적이고, 좁을수록(Private) 명시적 부여에 의존한다. Private로 두고 필요한 사람에게만 공유 규칙·역할 계층·수동 공유로 접근을 여는 것이 최소 권한(least privilege) 설계의 출발점이다.

---

## 3. 내부 OWD 설정 절차 (Set Internal Organization-Wide Sharing Defaults)

1. Setup에서 Quick Find 상자에 **"Sharing Settings"** 를 입력하고 **Sharing Settings** 를 선택한다.
2. **Organization-Wide Defaults** 영역에서 **Edit** 를 클릭한다.
3. 각 오브젝트에 대해 원하는 **기본 내부 접근 수준**(2절의 값)을 선택한다.
4. 커스텀 오브젝트에서 **계층을 통한 자동 접근을 끄려면** **Grant Access Using Hierarchies** 체크박스를 **해제**한다.
   - 이 옵션은 기본값이 **"Controlled by Parent"가 아닌 커스텀 오브젝트에만** 제공된다.
5. **Save** 를 클릭한다.

```
// 구조 예시 — Setup 경로 표기(실제 동작 코드 아님)
Setup → Quick Find: "Sharing Settings" → Sharing Settings
  └ Organization-Wide Defaults → Edit → (오브젝트별 Default Internal/External Access)
  └ Sharing Rules (오브젝트별) → New → Based on record owner | Based on criteria
```

---

## 4. OWD 변경 시 주의 (재계산 · 타이밍 · 제약)

**재계산** — OWD 업데이트는 **sharing recalculation** 을 트리거한다. 데이터가 크면 시간이 걸리며, 완료 시 **이메일 알림**을 받는다. 변경이 반영된 상태를 보려면 페이지를 **새로고침**해야 한다.

**타이밍** — 방향에 따라 적용 시점이 다르다.

- 접근을 **넓히는** 변경(예: Read Only → Read/Write)은 **즉시** 적용된다.
- 접근을 **좁히는** 변경은 **재계산이 완료된 후** 적용된다.

**변경 불가/종속 제약**

- **User provisioning requests** 는 **Private** 를 유지해야 한다.
- **Account** 가 Private이면 **Opportunity 와 Case** 도 Private이어야 한다.
- 표준 오브젝트와의 master-detail 관계에서 **detail-side 커스텀 오브젝트** 는 **"Controlled by Parent"** 로 고정된다.

> 관련: OWD·공유 규칙 변경이 유발하는 **공유 재계산 성능**과 skew 함정은 [[레코드 액세스 설계 (Enterprise Scale)]] 참조.

---

## 5. 외부 OWD (External Organization-Wide Defaults)

**목적** — 외부 인증 사용자(external authenticated users)에게 내부와 **분리된**(보통 더 제한적인) 기본 접근 수준을 설정한다.

**활성화**

- **Spring '20 이후 생성된 모든 org**, 그리고 **Experiences/portals 가 활성화된 모든 org** 에서 **자동 활성화**된다.
- 그 이전 org은 Sharing Settings에서 **수동 활성화**한다.
- ⚠️ **한 번 켜면 External Sharing Model 은 끌 수 없다.** (내부=외부로 동일하게 맞추는 것은 가능하다.)

**기본값**

- Spring '20 이후 org → 모든 오브젝트 **Private**.
- 그 이전 org → 원래 OWD와 동일하되, **User·커스텀 오브젝트는 Private**.

**설정 절차**

1. Setup → **Sharing Settings**.
2. **Organization-Wide Defaults** 의 **Edit**.
3. 각 오브젝트의 **"Default External Access"** 를 선택.
4. **Save**.

**외부 접근 수준** — Controlled by Parent / Private / Public Read Only / Public Read/Write (정의는 내부와 동일, 2절 참조).

**핵심 제약**

- **기본 외부 접근 수준은 기본 내부 접근 수준보다 더 제한적이거나 같아야 한다.**
- **Guest users** 는 external users로 간주되지 않으며, **Private 에서 변경할 수 없다**.

---

## 6. 공유 규칙(Sharing Rules) 개념

공유 규칙은 OWD에 대한 **자동 예외**다. 역할 계층상의 위치와 무관하게 특정 사용자에게 레코드 접근을 **확대**한다. (OWD 원칙과 동일하게, 접근을 **좁히지는 못한다**.)

**유형**

| 유형 | 기준 | 용례 |
|---|---|---|
| **Owner-based** (소유 기반) | 특정 사용자들이 **소유한(owned)** 레코드에 접근을 연다 | 미국 세일즈 팀이 소유한 opportunity를 APAC 세일즈 매니저에게 공유 |
| **Criteria-based** (기준 기반) | **필드 값**에 따라 공유 대상을 정한다 | "Department" 커스텀 피클리스트 = "IT" 인 job application을 모든 IT 매니저와 공유 |
| **Guest user sharing rule** | criteria-based의 **특수형** | 미인증 게스트 사용자에게 레코드 접근을 부여하는 **유일한 방법** |

- ⚠️ **Criteria-based 주의:** **Text·Text Area 는 대소문자를 구분**한다. criteria가 'Manager'이면 'manager'는 매칭되지 않는다.
- ⚠️ **Guest user sharing rule 경고:** 로그인 자격이 없는 게스트에게, 규칙 criteria에 맞는 **모든 레코드에 즉시·무제한 접근**을 줄 수 있다.

**Criteria로 사용 가능한 필드 타입**

Auto Number, Checkbox, Date, Date/Time, Email, **Lookup Relationship**(사용자 ID 또는 큐 ID 대상), Number, Percent, Phone, Picklist, Text, Text Area, URL.

---

## 7. 소유 기반 공유 규칙 생성 절차 (Create Owner-Based Sharing Rules)

1. (public group을 포함하려면 **미리 생성**돼 있어야 한다.)
2. 해당 오브젝트의 **Sharing Rules** 관련 목록에서 **New** 를 클릭한다.
3. **Label**(UI 표시명)과 **Rule Name**(API·managed package용 **고유 식별자**)을 입력한다. 선택적으로 **설명 최대 1,000자**.
4. 규칙 유형에서 **"Based on record owner"** 를 선택한다.
5. **"owned by members of"** 에서 첫 드롭다운 category + 둘째 드롭다운/lookup으로 **소유자 집합**을 지정한다.
6. **"Share with"** 에서 category + **수신 사용자 집합**을 지정한다.
7. **접근 수준**을 선택한다.

| 접근 수준 | 부여 범위 |
|---|---|
| **Private** | view/update 제한 |
| **Read Only** | view만 |
| **Read/Write** | view + update |
| **Full Access** | view · edit · transfer · delete · share |

8. **Save** 한다.

> 생성 후에는 **label, rule name, sharing access level 만 편집**할 수 있다. 나머지 항목은 삭제 후 재생성해야 한다.

---

## 8. 기준 기반 공유 규칙 생성 절차 (Create Criteria-Based Sharing Rules)

**필요 Edition:** Professional, Enterprise, Performance, Unlimited, Developer.
**필요 권한:** **Manage Sharing**. (public group 포함 시 미리 생성.)

1. Setup → Quick Find **"Sharing Settings"** → **Sharing Settings**.
2. 오브젝트의 **Sharing Rules** 관련 목록 → **New**.
3. **Label** + **Rule Name** + 선택적 **설명(≤1,000자)**.
4. 규칙 유형 **"Based on criteria"** 선택.
5. 레코드가 만족해야 할 **field, operator, value** 를 지정한다.
   - value는 **240자 제한**(초과 문자열은 잘림).
   - AND/OR 관계를 바꾸려면 **Add Filter Logic** 을 클릭한다.
6. (제공되는 경우) 역할을 부여할 수 없는 사용자(**high-volume users, system users**)가 소유한 레코드의 **포함 여부**를 선택한다 — **기본 활성**, **저장 후 편집 불가**.
7. **"Share with"** 에서 category + 사용자 집합을 지정한다. (**Portal Roles**, **Portal Roles and Subordinates**, **Roles/Internal Portal Subordinates** 선택 시 알림이 표시된다.)
8. **접근 수준**을 선택한다.

| 접근 수준 | 부여 범위 |
|---|---|
| **Private** | 연결된 **contacts · opportunities · cases** 에만 제공 |
| **Read Only** | view만 |
| **Read/Write** | view + update |
| **Full Access** | **campaigns 한정**, 연결 activity 관리 포함 |

9. **Save** 한다.

> 생성 후 편집 가능: **label, rule name, criteria filters, sharing access level**. 업데이트 시 **재계산이 자동**으로 일어난다. 대규모 업데이트는 **sharing 계산 지연(defer)** 을 고려한다. contacts OWD가 **"Controlled by Parent"** 이면 **Contact Access 를 사용할 수 없다**.

### 8-1. Guest User Sharing Rule 생성 절차 (criteria-based의 특수형)

**전제 조건** — 게스트(미인증) 사용자의 OWD는 **Private 고정**(5절)이므로, guest user sharing rule이 게스트에게 레코드 접근을 부여하는 **유일한 방법**이다(6절). **Read Only 접근만** 부여할 수 있다(Read/Write·Full Access 선택 불가). Share With의 **Guest User** 카테고리는 *"사이트의 모든 미인증 사용자(All unauthenticated users in a site)"* 이므로, 대상 **Experience Cloud/사이트가 존재**해야 사이트별 guest user를 선택할 수 있다. 게스트 update가 왜 불가능한지(**Secure guest user record access** 강제)와 우회 패턴(without sharing 컨트롤러)은 [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] 참조.

**절차** (Security Guide v260, "Create Guest User Sharing Rules" — 필요 권한 **Manage Sharing**)

1. Setup → Quick Find **"Sharing Settings"** → **Sharing Settings**.
2. 해당 오브젝트의 **Sharing Rules** 관련 목록 → **New**.
3. **Label**(UI 표시명) + **Rule Name**(API·managed package용 고유 식별자).
4. 선택적 **설명(≤1,000자)**.
5. 규칙 유형에서 **"Guest user, based on criteria"** 를 선택한다.
6. 레코드가 만족해야 할 **field, operator, value** criteria를 지정한다 — value는 항상 **리터럴 숫자/문자열**, **240자 제한**(초과 시 잘림), AND/OR 변경은 **Add Filter Logic**.
   - criteria-based가 지원하지 않는 필드를 쓰려면 workflow rule/Apex trigger로 값을 text·numeric 필드에 복사한 뒤 그 필드를 criteria로 사용한다.
7. (제공되는 경우) **high-volume community/site 사용자** 소유 레코드의 포함 여부를 선택한다 — 기본적으로 규칙은 인증 사용자·게스트 사용자·큐 소유 레코드만 포함한다.
8. **Share With에서 접근을 받을 guest user(사이트별)** 를 지정한다.
9. **Save**.

**한도** — 오브젝트당 공유 규칙 총 **300개**, 그중 **criteria-based + guest user sharing rule 합계 50개**까지.

> ⚠️ **원문 경고 재확인:** 이 규칙은 로그인 자격 없는 누구에게나 criteria에 맞는 **모든 레코드에 즉시·무제한(immediate and unlimited) 접근**을 준다. 데이터 민감도에 맞는 보안 통제를 함께 구현할 것 — 기본 설정 변경으로 인한 노출은 Salesforce가 책임지지 않는다.
> ⚠️ **적용 타이밍 함정:** 게스트 sharing rule은 **트랜잭션 완료 후에** 적용된다 — 같은 Apex 메서드에서 생성 직후 읽기는 실패한다. 상세 패턴은 [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] 참조.

---

## 9. Owner vs Criteria 공유 규칙 — 선택 기준

| 항목 | Owner-based | Criteria-based |
|---|---|---|
| 공유 대상 결정 기준 | 레코드 **소유자** | 레코드 **필드 값** |
| 대표 용례 | 팀·역할·그룹이 소유한 레코드 일괄 공유 | 특정 필드 조건에 맞는 레코드 공유 |
| 대소문자 | 해당 없음 | **Text·Text Area 는 대소문자 구분** |
| 게스트 사용자 부여 | 불가 | **Guest user sharing rule(특수형)로만 가능** |
| 생성 후 편집 가능 필드 | label, rule name, sharing access level | label, rule name, **criteria filters**, sharing access level |
| value 길이 제한 | 해당 없음 | **240자**(초과 시 잘림) |

---

## 10. Manual Sharing (수동 공유)

공유 규칙(자동·집합 단위)으로 커버할 수 없는 **일회성 예외(one-off access exception)** 를 위해, **개별 레코드 하나**를 다른 사용자·public group·역할과 공유하는 기능. 예: 특정 opportunity 하나만 협업할 동료에게 열기, 휴가 커버·특별 프로젝트 공유. (OWD 원칙과 동일하게 접근을 **확대만** 하며, OWD가 Public Read/Write처럼 이미 넓으면 수동 공유가 의미를 갖지 않는다.)

**공유 모델에서의 층(layer) 위치** — 질문 "Private에서 특정 팀에게만 열기"의 각 층:

| 층 | 범위 | 담당 |
|---|---|---|
| **OWD** | 전 조직 baseline (바닥) | 본 노트 1~5절 |
| **Role Hierarchy** | 수직 — 상위 역할이 하위 소유 레코드에 자동 접근 (Grant Access Using Hierarchies) | [[Roles & Role Hierarchy (역할·역할 계층)]] |
| **Sharing Rules** | 수평·자동 — 그룹/역할/criteria 집합 단위 예외 | 본 노트 6~9절 |
| **Manual Sharing** | 개별 레코드 단위 일회성 예외 | 본 절 |

> Account 접근을 부여하면 그 account에 연결된 **opportunity·case 전부에 자동 접근**이 따라올 수 있다(연관 레코드 접근).

### 10-1. 누가 수동 공유할 수 있나 (Creation of Manual Shares)

다음 중 하나여야 한다.

- **레코드 소유자(record owner)**
- 계층상 **소유자보다 상위 역할**의 사용자 (org의 sharing settings가 계층을 통한 접근을 허용할 때 — Grant Access Using Hierarchies)
- 해당 오브젝트에 **Modify All** 권한이 있는 사용자
- **Salesforce 관리자**

> ⚠️ opportunity·contact·case를 수동 공유하려면, 공유받는 사용자가 **부모 account에 최소 Read 접근**을 이미 갖고 있거나 공유하는 본인이 account도 공유할 수 있어야 한다(account 소유자·관리자·account 소유자 상위 역할·Modify All). account를 공유할 수 있는 경우, 공유받는 사용자에게 **부모 account Read가 자동 부여**된다.
> ⚠️ account를 공유할 때 자식 opportunity·case·contact의 접근 수준은 **account 소유자의 기본 접근(OWD+역할)을 초과할 수 없다** — 관리자·Account Modify All·Modify All Data만 초과 부여 가능.

### 10-2. Lightning Experience에서 수동 공유 절차 (레코드 Share/Sharing 버튼)

```
// 구조 예시 — 경로 표기(실제 동작 코드 아님)
레코드 페이지 → Sharing 버튼 → Search 상자에 대상 입력(드롭다운으로 유형 필터)
  → 접근 수준 선택 → Save
  → Sharing 페이지에서 Edit(공유 대상 요약) · View Sharing Hierarchy(접근자 전체 상세)
```

1. 공유할 레코드에서 **Sharing** 을 클릭한다.
2. **Search 상자**에 추가할 groups, users, roles, territories를 입력한다. 검색 드롭다운으로 유형을 필터링할 수 있다 — org 데이터에 따라 **Managers Groups · Manager Subordinates Groups · Public Groups · Users**(포털 사용자 제외) **· Roles · Roles and Subordinates · Roles and Internal Subordinates · Roles, Internal and Portal Subordinates · Territories · Territories and Subordinates**.
3. 공유하는 레코드(및 본인 소유의 연관 레코드)에 대한 **접근 수준**을 선택한다.
4. **Save** 한다.

| 접근 수준 | 부여 범위 (원문 정의) |
|---|---|
| **Full Access** | view · edit · delete · transfer + **다른 사용자에게 공유 확장 가능**. 단 다른 사용자에게 **Full Access를 부여할 수는 없다** |
| **Read/Write** | view + edit, 연관 레코드·note·attachment 추가 가능 |
| **Read Only** | view + 연관 레코드 추가만. edit·note·attachment 추가 불가 |
| **Private** | 어떤 방식으로도 레코드에 접근 불가 |

> contacts OWD가 **Controlled by Parent** 이면 **Contact Access 를 사용할 수 없다** (공유 규칙과 동일).

### 10-3. 수동 공유 삭제 동작 (Deletion of Manual Shares)

**레코드 소유권을 이전하면, 원래 소유자가 만든 수동 공유는 삭제된다** — 사용자들이 접근을 잃을 수 있다. 추가 고려 사항:

- **account 소유권 이전** 시 원래 account 소유자가 자식 **opportunity·case·contact** 레코드에 만든 수동 공유도 함께 삭제된다.
- opportunity/case의 **부모 account가 바뀔 때**, 변경한 사용자가 새 부모 account를 공유할 수 없으면 해당 수동 공유가 삭제된다. 단 **새 부모 account 소유자·그 상위 역할·관리자**가 변경했거나 **수신자가 이미 부모 account 접근을 갖고 있으면** 삭제되지 않는다.
- 포털/커뮤니티 사용자와 연결된 contact의 부모 account가 바뀌면, 그 사용자와 공유했던 **커스텀 오브젝트 레코드의 수동 공유**가 삭제된다.
- opportunity가 **closed** 상태에서 부모 account 소유자가 바뀌면, **opportunity splits가 켜져 있어도** 해당 opportunity의 수동 공유가 삭제된다.

**Available in:** Professional, Enterprise, Performance, Unlimited, Developer Editions. Salesforce Classic + Lightning Experience (위 절차는 Lightning Experience 기준).

---

## 관련 노트
- [[Roles & Role Hierarchy (역할·역할 계층)]] — Grant Access Using Hierarchies로 역할 계층의 자동 접근 상속을 제어(공유 모델의 수직 축)
- [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] — guest user sharing rule로 연 read 접근의 소비 측: Secure guest user record access·update 불가 우회(without sharing)·트랜잭션 완료 후 적용 함정
- [[레코드 액세스 설계 (Enterprise Scale)]] — OWD·공유 규칙 변경이 유발하는 **공유 재계산 성능**과 skew 함정(본 노트의 성능 짝)
- [[Permission Set 설계]] — 오브젝트/필드 수준 명시적 접근 권한 부여(공유 모델과 상호 보완)
- [[Scoping Rules]] — 접근은 그대로 두고 사용자가 기본으로 보는 레코드만 좁힘(공유가 접근을 확대/제한하는 것과 직교)
- [[Data Skew]] — ownership/parent-child skew(OWD·소유권 설계가 유발)
