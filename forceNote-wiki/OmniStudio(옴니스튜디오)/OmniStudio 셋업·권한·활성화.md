---
tags: [omnistudio, setup, permissions, runtime, security, fls, activation]
source: help.salesforce.com — OmniStudio Setup & Permissions (xcloud.os_standard_omnistudio_content_and_runtime·os_enable_standard_omnistudio_designer·os_enable_fast_activation_on_omnistudio_content·os_omnistudio_permission_sets_licenses_std·os_setup_omnistudio_standard_user_permission_sets_6542_std·os_permissions_for_an_omnistudio_agent_user_std·os_perm_omniintaccessconfig_std·os_omnistudio_security_updates_overview·os_callable_implementations·os_standard_add_an_apex_class_permissions_checker·os_omnistudio_on_experience_cloud, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [OmniStudio 셋업, OmniStudio 권한, permission sets, Omnistudio Admin, Omnistudio User, standard runtime, Managed Package Runtime, FLS, ApexClassCheck, EnableQueryWithFLS, EnforceDMFLSAndDataEncryption, Fast Activation, Omni Interaction Configuration, Callable]
---

# OmniStudio 셋업·권한·활성화

> Standard runtime 전환·디자이너 활성화·권한 세트 카탈로그·FLS/보안 플래그·Callable 확장점 — OmniStudio를 org에 올바르게 셋업하는 관리자 관점의 정리.

---

## 1. Standard vs Managed Package Runtime

**Standard Omnistudio 콘텐츠는 Omnistudio 권한 세트 라이선스(PSL)가 있으면 standard runtime에서 실행된다.** Lightning App Builder / Experience Builder에서 standard Omniscript·Flexcard 컴포넌트로 콘텐츠를 Lightning 또는 Experience Cloud 사이트에 추가한다. Health Cloud·Financial Services Cloud 등 Salesforce Industries가 만든 standard 컴포넌트를 그대로 쓸 수 있고, custom 콘텐츠도 custom-generated 컴포넌트 대신 standard 컴포넌트로 standard runtime에서 실행할 수 있다.

### Managed Package Runtime 비활성화

Salesforce는 Omnistudio for Managed Package 컴포넌트를 Salesforce standard 컴포넌트로 **재구축**할 것을 권장한다.

- Omnistudio for Managed Package에서 만든 컴포넌트가 Omnistudio Standard에서 항상 기대대로 동작하지 않는다.
- standard runtime으로 전환한 후 Managed Package 컴포넌트를 편집하면, 변경 사항이 사이트에 반영되지 않는다.

활성화 후에는 Lightning App Builder 또는 Experience Builder에서 standard Flexcard/Omniscript 컴포넌트를 Lightning 페이지나 Aura 기반 Experience 사이트에 추가한다. Omniscript는 **LWR 사이트에도** 추가할 수 있다.

> **Important** — LWR Experience 사이트에 Flexcard를 임베드하려면 **Managed Package Runtime 설정을 켠 채로 두고 생성된 LWC를 사용**해야 한다. (Omniscript는 LWR 지원, Flexcard 임베드는 여전히 managed package runtime 필요)

### FLS 전제 (전환 전 필수)

> **Important** — Standard runtime은 managed package runtime보다 **FLS(field-level security)를 더 엄격하게 적용**한다. Managed Package Runtime을 비활성화하기 **전에**, 다음 3개 객체에 FLS가 명시적으로 설정돼 있는지 확인한다:
> - **Omni Process Compilation**
> - **Omni Data Transformation**
> - **Omniscript Saved Sessions**
>
> (구체적 FLS 값은 아래 [7. 보안 체크](#7-보안-체크-fls--feature-flag) FLS 표 참조)

### 기존 LWC의 하위 호환

Omniscript·Flexcard LWC를 참조하는 기존 페이지와의 하위 호환을 위해, **Managed Package Runtime 비활성화(구 "Standard Omnistudio Runtime 활성화") 이전에 존재하던 LWC는 다음에 재활성화될 때 standard runtime으로 실행**된다.

### 표준 콘텐츠 보기·수정 요건

| 목적 | 필요 조건 |
|---|---|
| 최종 사용자가 Lightning 페이지/Experience 사이트에서 standard Flexcard·Omniscript **보기** | Managed Package Runtime 비활성화 + Omnistudio PSL 보유 |
| 관리자가 디자이너에서 standard 콘텐츠 **보기·수정** | Managed Package Runtime 비활성화 + Winter '23 이상 managed package 설치 |
| Salesforce Industries 라이선스와 함께 배포되는 standard 컴포넌트 수정 | **버전 생성** 필요. 릴리스 업데이트는 Version 1에 push되며 Version 1은 편집 불가. 생성한 버전은 새 릴리스로 업데이트되지 않음 |

> **Note** — Omnistudio는 Setup > User > Edit의 **Load Lightning Experience in LWR** 체크박스를 지원하지 않는다. org에서 Omnistudio를 쓰면 이 설정을 끈다. (끄더라도 LWR 사이트에 임베드된 Omniscript·Flexcard에는 영향 없음.)

---

## 2. Standard Designer 활성화

Standard designer는 org의 Omnistudio 라이선스·버전에 따라 신규/기존 사용자 모두에게 **기본 제공**된다. 필요하면 managed package designer로 전환할 수 있으나, **managed package designer로 전환하면 standard designer로 만들거나 수정한 컴포넌트를 편집할 수 없다.**

시작 전, org가 Omnistudio standard runtime 상태여야 한다.

1. Setup에서 **Omnistudio Settings**를 찾아 선택한다.
2. **Managed Package Designer** 설정을 끈다.
   - managed package designer에 Omnistudio 컴포넌트가 열려 있는 상태로 standard designer로 전환하면 오류가 표시된다.

### 업그레이드 시 디자이너 설정 유지

org의 패키지 설치를 업그레이드할 때, standard runtime + package designer를 쓰고 있으면 업그레이드 후 designer가 standard designer로 전환된다. 원하는 designer를 유지하려면 **`RetainDesignerSettingOnUpgrade`** Omni Interaction Configuration을 활성화한다.

---

## 3. Fast Activation (뷰·수정·빠른 활성화)

Managed Package Runtime 설정을 비활성화하면 Salesforce Industries 라이선스와 함께 배포되는 standard Omnistudio 콘텐츠를 디자이너에서 보고 수정할 수 있고, **더 빠른 Omniscript·Flexcard 활성화**도 활성화된다.

- **관리자** — 디자이너에서 콘텐츠를 보고 수정하려면 Managed Package Runtime을 비활성화하고 **Winter '23 이상** 패키지를 설치한다. Winter '23 이상으로 업그레이드하기 전까지는 디자이너에서 컴포넌트를 활성화할 때 **LWC가 생성**되어 fast activation 이점을 받지 못한다. Winter '23 이상 패키지 없이는 Salesforce Industries 라이선스로 배포되는 standard 콘텐츠를 수정할 수 없다(수정하려면 버전 생성 필요; 릴리스 업데이트는 편집 불가한 Version 1에 push).
- **최종 사용자** — Lightning 페이지/Experience 사이트에서 standard Flexcard·Omniscript를 보려면 Managed Package Runtime을 비활성화하고 Omnistudio PSL 보유를 확인한다.

> Flexcard·Omniscript standard 컴포넌트에서 지원되지 않는 함수·기능은 "Omnistudio and Omnistudio for Managed Packages Features Support" 문서 참조.

### 런타임 매트릭스 — "Which Runtime Am I Using?"

Flexcard/Omniscript LWC가 Lightning 또는 Experience 페이지에 **published(active)** 된 경우:

| package-based runtime | 사용되는 런타임 |
|---|---|
| **비활성화(disable)** | 활성화 시점에 켜져 있던 런타임을 사용. **deactivate 후 reactivate** 하면 LWC가 자동으로 standard runtime 사용 |
| **활성화(enabled)** | managed package runtime 사용 |

Flexcard/Omniscript가 **inactive** 인 경우:

| package-based runtime | Preview | 활성화 후 | 페이지 추가 방식 |
|---|---|---|---|
| **비활성화(disable)** | standard runtime | LWC 생성 안 됨, standard runtime | Lightning App/Experience Site Builder에서 **standard 컴포넌트**로 추가 |
| **활성화(enabled)** | managed package runtime | LWC 생성됨, managed package runtime | Lightning App/Experience Site Builder에서 **custom 컴포넌트**로 추가 |

---

## 4. Permission Sets (권한 세트 카탈로그)

관리자에게는 Flexcard·Omniscript·Integration Procedure·Data Mapper 등 Omnistudio 객체를 만들고 관리할 권한을, 소비자(consumer)에게는 Omniscript 객체 **읽기만** 부여한다.

> **Important** — **Omnistudio Admin 권한 세트 라이선스(PSL)가 "Omnistudio"로 이름이 변경**되었고, 이제 두 개의 권한 세트를 포함한다: **Omnistudio Admin**, **Omnistudio User**.

### 권한 세트별 객체 권한

| Permission Set | 설명 | 객체 권한 |
|---|---|---|
| **Omnistudio Admin** | 관리자·디자이너에게 Omnistudio 객체 full **CRUD** 부여 | **Create, Read, Update, Delete**: Flexcards(Omni UI Card), Omniscripts(Omni Process), Data Mappers(Omni Data Transformation), Integration Procedures(Omni Process), OmniGlobalAutoNumber |
| **Omnistudio User** | 소비자에게 Omnistudio 객체 **Read**, Omniscript Saved Sessions **Create** 부여. (Spring '22·Summer '22에서는 기본 제공 안 될 수 있음 → "Create a Profile for an Omnistudio Standard User" 참조) | **Read**: Flexcards(Omni UI Card), Omniscripts(Omni Process), Data Mappers(Omni Data Transformation), Integration Procedures(Omni Process), OmniInteractionAccessConfiguration. **Read and Update**: OmniGlobalAutoNumber. **Create, Read, Update, Delete**: Omniscript Saved Session |

### 콘텐츠 접근별 라이선스·권한 세트

| Omnistudio 콘텐츠 접근 | 필요한 라이선스·권한 세트 |
|---|---|
| Omnistudio 콘텐츠 생성·관리 | **Omnistudio PSL** + **Omnistudio Admin** 권한 세트 |
| Lightning Experience에서 콘텐츠 보기 | **Omnistudio PSL** + **Omnistudio User** 권한 세트 |
| Experience Builder Aura 사이트에서 **authenticated** 사용자로 보기 | **Omnistudio Runtime for Communities PSL** + authenticated 사용자용 **custom 권한 세트** |
| Experience Builder Aura 사이트에서 **unauthenticated/guest** 사용자로 보기 | **Omnistudio PSL** + guest 사용자용 **custom 권한 세트** |

### 관련 셋업 하위 토픽

- **Set Up Permissions for an Omnistudio Standard User** — standard 사용자는 Omniscript 컴포넌트를 보고 설계할 수 있어야 함. 프로파일 + 권한 세트로 접근 제공(하위: Create a Permission Set / Create a Profile).
- **Set Up Permissions for an Omnistudio Guest User** — object/field-level 보안을 유지하면서 public-facing 컴포넌트 접근 제공.
- **Set Up Permissions for an Omnistudio Experience Cloud Site User**.
- **Set Up Permissions for an Omnistudio Partner Experience Cloud Site User**.
- **Set Up Permissions for an Omnistudio Agent User** — Omnistudio용 Agentforce 기능 접근 제공. 권한 세트·공유 규칙으로 Agentforce 및 Salesforce 제공 MCP와의 AI 연동 접근 부여(하위: Create a Profile for an Omnistudio Agent User).

---

## 5. Enhanced Runtime Performance 권한 세트

Omnistudio settings에서 **Enhanced Runtime Performance**를 활성화한 경우, standard 사용자가 권한에 따라 Omnistudio 컴포넌트에 접근하도록 별도 권한 세트를 만든다. 이 세트는 standard 사용자에게 컴포넌트 접근에 필요한 **Omni Interaction Access Configurations** 객체를 제공한다. **관리자 사용자에게는 필요 없다.**

시작 전:
- Enhanced Runtime Performance Omnistudio Setting이 활성화돼 있어야 함.
- Omnistudio PSL 보유 확인(Setup > Permission Sets에서 목록에 Omnistudio Admin 존재 확인).

1. Setup에서 Quick Find에 `Perm` 입력 → **Permission Sets** 선택.
2. **New** 클릭.
3. Label 입력(예: `Omnistudio Additional Permissions`). 기본적으로 API Name은 동일.
4. **License 드롭다운은 그대로 두고 아무것도 선택하지 않는다.**
5. **Save**.
6. **Object Settings** → **Omni Interaction Access Configurations** 클릭.
7. **Edit** → Enabled 체크박스에서 사용자 접근 요건에 맞는 필드 선택. **read-only 사용자용이면 Read, View All Records, View All Fields**를 선택.
8. 권한 세트 저장 후 필요한 사용자에게 할당.

---

## 6. 보안 체크 — FLS + Feature Flag

Omnistudio 보안 체크는 접근·권한에 대한 더 엄격한 검증을 강제한다. guest·authenticated·non-authenticated 사용자 모두가 Omnistudio 컴포넌트에서 사용되는 객체·필드에 적절한 접근을 갖도록 보장한다.

### Standard Runtime FLS 요건

Standard runtime은 managed package runtime보다 FLS를 더 엄격히 적용한다. LWC 컴파일 오류·컴포넌트 가시성 문제를 막으려면, Omnistudio 컴포넌트를 실행하는 **모든 사용자 프로파일**에 대해 다음 객체에 field-level 권한을 **명시적으로** 부여해야 한다:

| Object | Required FLS |
|---|---|
| **Omni Process Compilation** | **Read, Edit** |
| **Omni Data Transformation** | **Read** |
| **Omniscript Saved Sessions** | **Read, Edit** |

> 이 요건은 standard runtime에 적용되며, 아래 보안 feature flag와는 **별개**다.

### 3개 보안 Feature Flag

Feature flag는 Omnistudio 보안 체크를 제어한다. **보안 체크는 flag가 활성화된 경우에만 적용**된다.

- **ApexClassCheck** — Omniscript·Flexcard에서 호출되는 **모든 remote action**에 대해 사용자가 명시적 Apex 클래스 접근을 갖도록 요구. → [8. Apex Class Permissions Checker](#8-apex-class-permissions-checker) 참조.
- **EnforceDMFLSAndDataEncryption** — **모든 Data Mapper**에 대해 Object 및 field-level 보안(FLS)을 자동 강제. **View Encrypted Data** 권한이 없는 사용자는 암호화 필드를 평문으로 볼 수 없음.
- **EnableQueryWithFLS** — **Flexcard 내 모든 SOSL·SOQL 쿼리**에 FLS 강제, 데이터 가시성이 사용자 권한을 따르도록 보장.

이전에 발표된 이 보안 flag들에 **동작 변경은 없다.** 활성화하면 Omnistudio 컴포넌트 전반에 걸쳐 데이터 접근·보안 통제의 일관된 강제가 계속 지원된다.

**활성화 절차:**

1. Setup > Quick Find에 `Omni Interaction Configuration` 입력 → **Omni Interaction Configuration** 선택.
2. **New Omni Interaction Configuration** 클릭.
3. **Label** 필드에 flag 이름을 위와 **정확히 동일하게** 입력(예: `ApexClassCheck`). Name 필드는 label에서 자동 채워짐.
4. **Value** 필드에 `true` 입력. 값은 **대소문자 구분 안 함**.

> **Important** — **2026년 2월 2일 주(during the week of February 2, 2026)에 Salesforce가 ApexClassCheck·EnforceDMFLSAndDataEncryption·EnableQueryWithFLS 3개 설정을 org 보안 강화를 위해 기본으로 활성화**한다. 원활한 전환과 잠재적 서비스 중단 방지를 위해 구성을 검토·준비한다.

---

## 7. Apex Class Permissions Checker

remote action API가 사용하는 클래스에 대해 각 사용자 프로파일·권한 세트·권한 세트 그룹별로 **명시적 접근**을 부여한다. Apex class permissions checker를 구성하면, Omniscript·Flexcard·Integration Procedure·REST API에서 호출되는 remote action을 관리하는 Apex 클래스에 사용자가 명시적 접근을 요구하도록 보장한다.

예: Lightning Platform 사이트를 만들면 프로파일의 Apex 클래스 접근에 따라 Site User 프로파일에 대해 공개 API가 활성화된다. Apex class permissions checker를 추가하면 **guest user 같은 미인가 사용자가 Callable 인터페이스를 구현하는 ApexRemote 호출로 클래스에 접근하는 것을 차단**한다.

> **Important** — 최소 권한 원칙(principle of least privilege)을 보장하고 guest user에게 의도치 않은 미인가 접근이 제공되지 않도록 **ApexClassCheck** 설정을 활성화한다.

> **Note** — Integration Procedure에서 Remote Action을 쓰는 사용자는 action으로 호출하는 객체·레코드에 접근 권한이 있어야 한다. 접근 오류가 나면 프로파일·권한 세트·권한 세트 그룹 수준에서 객체·레코드 접근을 부여받아야 한다.

**ApexClassCheck 활성화:**

1. Setup > Quick Find에 `Omni Interaction Configuration` 입력 → **Omni Interaction Configuration** 선택.
2. **New** 클릭.
3. Name·Label에 `ApexClassCheck` 입력.
4. Value에 `true` 입력.
5. 저장.

> **Important** — 2026년 2월 2일 주에 Salesforce가 org 보안 강화를 위해 **ApexClassCheck** 설정을 기본 활성화한다.

---

## 8. Callable 확장점

**Vlocity Apex 클래스**와 **Omniscript·Integration Procedure의 Remote Action**은 `Callable` 인터페이스를 지원한다.

`VlocityOpenInterface`·`VlocityOpenInterface2` 인터페이스는 균일한 시그니처로 유연한 구현을 가능하게 하지만, Vlocity managed package에 속하며 진정한 Salesforce 표준은 아니다. 그러나 **`VlocityOpenInterface` 또는 `VlocityOpenInterface2`를 구현하는 클래스는 Salesforce 표준인 `Callable` 인터페이스도 함께 구현**한다.

또한 Omniscript·Integration Procedure의 Remote Action은 `VlocityOpenInterface`/`VlocityOpenInterface2` 구현 여부와 무관하게 **`Callable`을 구현하는 어떤 클래스든 호출**할 수 있다. Remote Class·Remote Method·Additional Input 속성은 이 인터페이스들 중 무엇을 구현하든 동일한 방식으로 지정한다.

`VlocityOpenInterface`/`VlocityOpenInterface2`를 구현하는 custom 클래스를 Callable 구현으로 바꾸려면 시그니처를 몇 줄로 변환한다(공식 문서 발췌):

```apex
global with sharing class ClassName implements Callable
{
    public Object call(String action, Map<String, Object> args) {

        // ⚠️ input·output 두 줄(args.get('input')·args.get('output') 캐스팅 대입)은
        //    안전 필터로 인해 이 dump에서 제공되지 않음 — 예시 코드는 공식 문서 참조.
        //    (아래 options 줄과 동일 패턴: (Map<String, Object>)args.get('...'))
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }
    private Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        ...
    }
    ...
}
```

전체 예제는 공식 문서 "Make a Long-Running Remote Call Using Omnistudio.OmniContinuation" 참조.

---

## 9. Experience Cloud에서의 OmniStudio

Omnistudio로 Experience Cloud 사이트에 핵심 컨텍스트 정보를 보여주고 동적 상호작용을 만든다. Omnistudio 셋업 외에도 사용자 접근 프로비저닝, 컴포넌트 설계·배포 등 특정 작업을 완료해야 한다.

### 권한 설정 (authenticated vs guest)

authenticated·guest 사용자 모두 Experience Cloud에서 Omnistudio를 쓸 수 있으나, 각 사용자 유형에 필요한 **권한·공유 규칙이 다르다**:

- 접근에 필요한 라이선스·권한 세트 → [4. Permission Sets](#4-permission-sets-권한-세트-카탈로그) 참조.
- **Authenticated 사용자 접근** → "Setup Omnistudio Standard Permission Sets for Experience Site Users".
- **Guest 사용자 접근** → "Grant Digital Experience Guest Users Omnistudio Access".

### Flexcard 고려사항

- Apex remote·Data Mapper·Integration Procedure 데이터 소스에서 데이터를 가져오는 대부분의 Flexcard는 input map의 **`{recordId}` context variable**로 표현되는 context ID를 사용한다.
- Experience Cloud 페이지의 Flexcard 이미지는 **static resource**여야 한다.
- **Navigate·Omniscript action은 preview에서 동작하지 않는다** → Lightning 또는 Experience Builder 페이지에 추가해야 확인 가능.
- Flexcard는 **LWR 사이트**에서도 사용 가능(단 임베드는 [1. 런타임](#1-standard-vs-managed-package-runtime)의 Managed Package Runtime 유지 조건 참조).

### Omniscript 고려사항

- Experience Cloud 사용자와 상호작용하는 UI 컴포넌트 구축.
- **LWR 사이트**에서 Omniscript 사용 가능("Add Your Omniscript to an Experience Cloud Page").
- Omniscript ↔ Experience Cloud 페이지 간 링크 등 기능은 **page reference types** 사용.

---

## 관련 노트

- [[OmniStudio 개요·오리엔테이션]]
- [[FlexCard]]
- [[OmniScript]]
- [[Integration Procedure]]
- [[Data Mapper (DataRaptor)]]
- [[Scratch Org Settings 레퍼런스]] — scratch org에서 OmniStudioSettings 등 org 설정 활성화
