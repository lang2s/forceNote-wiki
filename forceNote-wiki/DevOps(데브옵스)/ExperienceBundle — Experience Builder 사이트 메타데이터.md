---
tags: [devops, experience-cloud, experiencebundle, digitalexperiencebundle, metadata-api, salesforce-dx, sf-cli, lwr, enhanced-lwr, deployment, scratch-org]
source: communities_dev.pdf (Experience Cloud Developer Guide, v66.0 Spring '26)
created: 2026-06-21
aliases: [ExperienceBundle, DigitalExperienceBundle, DigitalExperienceConfig, Experience Cloud 메타데이터 배포, Experience Builder 사이트 배포, sf community create, sf community publish, enhanced LWR 마이그레이션, /s URL 배포, SiteDotCom, Experience Cloud 사이트 deploy, ExperienceBundle Metadata API 활성화]
---

# ExperienceBundle — Experience Builder 사이트 메타데이터

> `ExperienceBundle`은 Experience Builder 사이트(pages·branding sets·themes 등)를 사람이 읽을 수 있는 3-레벨 폴더 구조의 텍스트로 표현하는 메타데이터 타입. VS Code Extensions·Salesforce CLI·IDE로 사이트를 프로그래밍 방식으로 배포한다. 이 노트는 ExperienceBundle 구조·활성화·Metadata API/DX 배포와 함께, enhanced LWR 마이그레이션 및 인증 LWR `/s` URL 배포 고려사항을 다룬다.

> [!note] EDITIONS
> Available in: Salesforce Classic (not available in all orgs) and Lightning Experience
> Available in: Enterprise, Developer, Performance, and Unlimited Editions

---

## ExperienceBundle란

`ExperienceBundle` 메타데이터 타입은 Experience Builder 사이트를 구성하는 여러 설정·컴포넌트(pages, branding sets, themes 등)의 **텍스트 기반 표현**을 제공한다. 자체 org이든 컨설팅 파트너·ISV이든, Salesforce Extensions for VS Code·Salesforce CLI·선호하는 IDE/텍스트 에디터로 사이트를 빠르게 업데이트하고 프로그래밍 방식으로 배포할 수 있다.

Summer '19 릴리스(API version 45.0 이하) 이전에는 `Network`·`CustomSite`·`SiteDotCom` 메타데이터 타입을 결합해 Experience Builder 사이트를 정의했다. 그러나 `SiteDotCom` 타입을 retrieve하면 **사람이 읽을 수 없는 binary `.site` 파일**이 생성된다. `SiteDotCom` 대신 `ExperienceBundle` 타입을 retrieve하면, **사람이 읽을 수 있는 3-레벨 폴더 구조**로 세분화된 사이트 메타데이터를 추출·편집할 수 있다.

### Limitations

- Managed packages는 지원되지 않는다.

---

## ExperienceBundle 폴더 구조

`ExperienceBundle`을 retrieve하면 데이터가 3-레벨 폴더 구조로 저장된다.

`experiences` 폴더는 org 내 각 Experience Builder 사이트에 대한 폴더를 포함한다. 각 `site_name` 폴더(아래 예시의 `customer_service`)는 사이트를 정의하고 Experience Builder에서 접근하는 여러 요소를 표현하는 하위 폴더들을 포함한다. 각 하위 폴더에는 로컬 머신이나 scratch org에서 편집한 뒤 배포할 수 있는 프로퍼티가 담긴 `.json` 파일들이 들어 있다.

```text
// 구조 예시 — 실제 PDF 다이어그램(VS Code 스크린샷) 기반 재현
force-app/main/default/
└─ experiences/                       (Level 1)
   └─ customer_service/               (Level 2 — site_name 폴더)
      ├─ brandingSets/                (Level 3)
      ├─ config/
      ├─ routes/
      ├─ themes/
      ├─ variations/
      └─ views/
   customer_service1-meta.xml
```

각 Experience Builder 사이트를 정의하는 파일을 더 자세히 살펴보면 다음과 같다.

| Folder | Contents |
|---|---|
| `brandingSets` | `branding_set_name.json`이 사이트의 branding set 프로퍼티를 정의한다. |
| `config` | `site_name.json`이 일부 사이트 설정(public access, progressive rendering 등)을 정의한다. `languages.json`이 지원 언어를 정의한다. `loginAppPage.json`·`mainAppPage.json`은 single-page application(SPA)이다 — `loginAppPage.json`은 로그인이 필요한 사이트 페이지에, `mainAppPage`는 그 외 모든 페이지에 사용된다. (SPA는 단일 HTML 페이지를 로드하는 웹 앱으로, 사용자가 페이지 간 이동하는 전통적 웹사이트와 달리 사용자 상호작용에 따라 페이지를 동적으로 업데이트하는 여러 view로 구성된다.) |
| `routes` | 페이지당 하나의 파일 `page_name.json`을 포함하며, URL 및 라우트 관련 정보를 정의한다. |
| `themes` | 테마당 하나의 파일 `theme_name.json`을 포함하며, 테마를 정의한다. |
| `variations` | variation당 하나의 파일 `experienceVariation_name.json`을 포함한다. experience variation은 audience에 따라 Experience Builder 사이트의 기본 동작(branding, page variations, component visibility, component attributes 등)을 변경하는 데 사용한다. |
| `views` | view당 하나의 파일 `view_name.json`을 포함한다. 각 파일은 SPA view를 정의하며(최종 사용자에게는 페이지와 동등), view는 렌더링된 페이지에서 다른 region이나 component를 포함하는 region들로 구성된다. |

> [!tip]
> Experience Builder 사이트의 `.json` 파일을 업데이트하기 전에, 사이트 폴더의 복사본을 백업으로 만들어 두는 것을 권장한다.

> ExperienceBundle과 포함 파일의 완전한 정의는 Metadata API Developer Guide를 참조한다.

---

## ExperienceBundle 메타데이터 타입 활성화

Aura 사이트에 대해 ExperienceBundle을 활성화하면, Metadata API 호출(retrieve·deploy)과 Salesforce DX 작업(pull·push·status)이 `SiteDotCom` 대신 `ExperienceBundle` 타입을 사용한다.

change sets로 사이트를 배포하는 경우, dependencies 목록에 `Site.com` 타입 두 항목 — `MySiteName`과 `MySiteName1` — 이 포함된다. 이제 `MySiteName1`이 `SiteDotCom`이 아니라 `ExperienceBundle`을 표현한다.

> [!note]
> LWR 사이트는 ExperienceBundle 메타데이터 타입을 **활성화할 필요가 없다.** LWR 사이트는 기본적으로 ExperienceBundle을 사용한다.

UI 활성화 절차:

1. Setup에서 Quick Find 박스에 `Digital Experiences`를 입력하고 **Settings**를 선택한다.
2. **Enable ExperienceBundle Metadata API**를 선택한다.
3. 변경 사항을 저장한다.

또는 scratch org definition file로 scratch org를 생성할 때 이 기능을 활성화할 수 있다. (Metadata Coverage report 참조.)

```json
{
  "orgName": "Sample Org",
  "edition": "developer",
  "features": [
    "COMMUNITIES"
  ],
  "settings": {
    "experienceBundleSettings": {
      "enableExperienceBundleMetadata": true
    },
    "communitiesSettings": {
      "enableNetworksEnabled": true
    }
  }
}
```

> scratch org definition file과 `settings` 블록의 일반 문법은 [[Scratch Org 생성과 정의 파일]] · [[Scratch Org Settings 레퍼런스]] 참조. 여기서는 `experienceBundleSettings.enableExperienceBundleMetadata`와 `communitiesSettings.enableNetworksEnabled` 설정만 다룬다.

---

## Metadata API로 retrieve·deploy

Metadata API에서는 manifest 파일(package.xml)이 retrieve하려는 components를 정의한다. 아래는 `SiteDotCom` 대신 `ExperienceBundle`을 사용해 Experience Builder 사이트를 retrieve하는 `package.xml` manifest 예제다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>*</members>
        <name>CustomSite</name>
    </types>
    <types>
        <members>*</members>
        <name>ExperienceBundle</name>
    </types>
    <types>
        <members>*</members>
        <name>Network</name>
    </types>
    <version>46.0</version>
</Package>
```

`.zip` 파일을 retrieve한 뒤 unzip하여 파일에 접근·편집한다.

> package.xml `<types>`/`<members>` 기본 문법과 .zip 기반 retrieve/deploy 호출법은 [[Metadata API File-Based 호출]] 참조. 위 예제의 `<version>46.0</version>`은 PDF 원문 예시값을 그대로 둔 것이다 — 실제 사용 시 org의 API 버전에 맞춘다.

---

## Salesforce DX로 retrieve·deploy

Salesforce DX 환경을 설정해 두었다면 다음 작업을 빠르게 수행할 수 있다.

| 작업 | 커맨드 |
|---|---|
| org의 모든 Experience Builder 사이트 retrieve | `sf project retrieve start` |
| 업데이트 deploy | `sf project deploy start` |
| 서버의 conflict/변경 사항 체크 | `sf project deploy preview` 또는 `sf project retrieve preview` |
| 사용 가능한 템플릿 목록 retrieve | `sf community list template` |
| 사이트 생성 | `sf community create` |
| Experience Builder 사이트 publish | `sf community publish` |

> `sf project retrieve start` · `sf project deploy start`의 일반 사용법은 [[DX 개발 워크플로]] · [[Salesforce DX 개요]] 참조. Experience Cloud 전용인 `sf community list template`·`sf community create`·`sf community publish`가 ExperienceBundle 배포에 특화된 커맨드다.

리소스: Salesforce DX Developer Guide · Quick Start: Salesforce DX (Trailhead) · Build Apps Together with Package Development (Trailhead) · Salesforce CLI Command Reference.

---

## enhanced LWR 사이트 마이그레이션 시 배포 이슈 회피

Winter '24부터 **enhanced sites and content platform**(Winter '23에 처음 도입)을 비활성화할 수 없게 되었다. 그 결과 LWR 템플릿으로 만든 모든 사이트는 기본적으로 **enhanced LWR 사이트**가 된다. `ExperienceBundle` 메타데이터 타입을 사용하는 non-enhanced LWR 사이트와 달리, enhanced LWR 사이트는 `DigitalExperienceBundle`과 `DigitalExperienceConfig` 타입을 사용한다.

문제는 다음과 같다 — Winter '24 **이전에** source org(예: sandbox)에서 non-enhanced LWR 사이트를 만들었고, 이제 그 사이트를 target org(예: production)에 처음 배포하려 할 때, 이 메타데이터 타입 차이가 배포 이슈를 일으킬 수 있다.

### 권장 — 배포 프로세스로 사이트를 생성

배포 전에 target org에 사이트를 직접 만들지 말고, **배포 프로세스 자체로 사이트를 생성**하는 것을 권장한다. target org에 먼저 사이트를 만들면 그 새 사이트는 enhanced LWR 사이트(=`DigitalExperienceBundle`+`DigitalExperienceConfig` 사용)가 된다. source org의 non-enhanced LWR 사이트는 `ExperienceBundle`을 사용하므로, 이를 target org에 배포하려 하면 **메타데이터 타입 mismatch로 배포가 실패**한다.

### 이미 target org에 사이트를 만든 경우 — 해결 절차

Experience Cloud 사이트는 삭제할 수 없으므로, 대신 **사이트 이름과 site URL을 변경**해 source org의 값과 더 이상 일치하지 않게 한다. 이렇게 하면 배포 프로세스가 source org의 값으로 target org에 사이트를 다시 생성할 수 있다.

1. target org에서, 사이트의 Administration workspace > **Settings** 페이지에서 사이트 이름을 source org의 사이트와 다르게 rename한다.
2. Setup의 Quick Find 박스에 `Custom URLs`를 입력한다.
3. Custom URLs에서 사이트의 두 URL을 찾는다. 각 사이트는 다음을 포함한다.
   - **Site.com Community URL** — 상황에 따라 `ExperienceBundle` 또는 `DigitalExperienceBundle`+`DigitalExperienceConfig` 메타데이터 타입에 매핑된다.
   - **Community URL** — `CustomSite`에 매핑된다.
4. 두 site URL을 모두 변경해 source org의 site URL과 더 이상 같지 않게 한다.
5. 사이트 이름과 URL을 업데이트한 뒤, change sets 또는 선호하는 배포 도구를 사용한 Metadata API로 사이트를 다시 배포한다.
6. Metadata API를 사용하는 경우, 사이트를 retrieve할 때 `Network`와 `CustomSite` 타입을 포함해 시스템이 target org에 새 non-enhanced LWR 사이트를 자동 생성하도록 한다. change sets를 사용하는 경우, 배포 전에 change set을 다시 생성한다.

> enhanced LWR / enhanced sites and content platform의 개념·전용 기능은 [[LWR Sites (Experience Cloud)]] 참조.

---

## 인증 LWR 사이트 배포 고려사항 (`/s` URL)

Winter '23부터 Experience Builder나 Connect API로 만든 새 LWR 사이트는 URL 끝에 `/s`를 포함하지 않는다. Winter '23 이전에 만든 인증 LWR 사이트의 URL은 여전히 `/s`를 포함하므로, sandbox와 production의 URL이 일치하지 않으면 이 URL 구조 차이가 배포에 영향을 준다.

> [!note]
> 아래 시나리오는 sandbox와 production이 **동일한 Salesforce 버전**이라고 가정한다. 새 버전에서 이전 버전으로 사이트를 배포하는 것은 지원되지 않는다.

### Metadata API Deployments

- **생성** — source 사이트 URL의 `/s` 포함 여부와 무관하게, Metadata API 배포로 사이트를 생성하는 것은 지원된다. source 사이트 URL이 `/s`를 포함하면 새 target 사이트 URL도 `/s`를 포함하고, 포함하지 않으면 target도 포함하지 않는다.
- **업데이트** — Metadata API 배포로 사이트를 업데이트하려면 source 사이트 URL과 target 사이트 URL이 **일치**해야 한다. 두 URL 모두 `/s`를 포함하거나, 둘 다 포함하지 않아야 한다.
- **에러 해결** — `/s` 관련 Metadata API 배포 에러를 해결하려면, metadata bundle에서 source 사이트 URL에 `/s`를 추가하거나 제거해 source 사이트 URL이 target 사이트 URL과 일치하도록 한다. **target 사이트 URL에는 `/s`를 추가하거나 제거할 수 없다.**

### Change Set Deployments

- **생성** — source 사이트 URL의 `/s` 포함 여부와 무관하게, change set 배포로 사이트를 생성하는 것은 지원된다. source 사이트 URL이 `/s`를 포함하면 새 target 사이트 URL도 `/s`를 포함하고, 포함하지 않으면 target도 포함하지 않는다.
- **업데이트** — change set 배포로 사이트를 업데이트하려면 source 사이트 URL과 target 사이트 URL이 일치해야 한다. 두 URL 모두 `/s`를 포함하거나, 둘 다 포함하지 않아야 한다.
- **에러 해결** — `/s` 관련 change set 배포 에러를 해결하려면, API나 Experience Builder로 source 사이트 또는 target 사이트를 rename한다. 사이트 중 하나를 rename하면 target 사이트를 업데이트하는 대신 사이트가 새로 생성된다. **source 사이트 URL이든 target 사이트 URL이든 어느 쪽에도 `/s`를 추가하거나 제거할 수 없다.**

---

## 관련 노트

- [[Experience Builder Aura 사이트 개발]] — Aura 기반 Experience Cloud 사이트 개발. Personalization 등 사이트 구성이 ExperienceBundle로 표현·배포된다.
- [[Experience Builder 사이트 — Pardot·CMS·Deflection]] — Experience Builder 사이트 운영(Pardot·CMS·deflection). head markup·CMS 콘텐츠가 ExperienceBundle로 배포된다 (자매 노트).
- [[LWR Sites (Experience Cloud)]] — LWR/enhanced LWR 사이트 허브. enhanced LWR은 `DigitalExperienceBundle`+`DigitalExperienceConfig`를 사용.
- [[Metadata API File-Based 호출]] — package.xml `<types>`/`<members>` 문법, .zip 기반 retrieve/deploy 호출.
- [[Scratch Org 생성과 정의 파일]] — scratch org definition file과 `features`/`settings` 블록 일반 문법.
- [[Scratch Org Settings 레퍼런스]] — definition file `settings` 블록 전수 레퍼런스.
- [[DX 개발 워크플로]] — `sf project retrieve/deploy start` 등 DX CLI 일반 워크플로.
- [[Salesforce DX 개요]] — Salesforce DX 도구 세트 개요.
