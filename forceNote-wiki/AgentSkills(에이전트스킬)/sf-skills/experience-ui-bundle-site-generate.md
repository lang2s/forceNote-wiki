---
tags: [agent-skill, sf-skills, experience, ui-bundle, digital-experience-site, network]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-site-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-site-generate, Digital Experience Site 생성, React UI bundle 호스팅, appContainer appSpace, Network CustomSite DigitalExperienceBundle, urlPathPrefix 갱신]
---

# experience-ui-bundle-site-generate — Digital Experience Site 생성 (React UI bundle 호스팅)

> React UI bundle을 Salesforce에서 서빙하기 위한 Digital Experience Site 인프라(Network, CustomSite, DigitalExperienceConfig, DigitalExperienceBundle, `sfdc_cms__site` 콘텐츠 타입)를 최소 단위로 생성·구성하는 스킬.

## 목적과 활성화 조건

**활성화(MUST):** 프로젝트에 `uiBundles/*/src/` 디렉터리가 있고 site 인프라 생성/구성 작업일 때. UI bundle 호스팅용 Salesforce Digital Experience Site를 만들거나 구성, `digitalExperiences/`·`networks/`·`customSite/`·`DigitalExperienceBundle` 파일 수정, 또는 앱 publish/host/guest access 구성 시 활성화.

React site는 표준 LWR site와 다르다 — route, view, theme layout, branding set이 필요 없다. site는 얇은 컨테이너(`appContainer: true`)로 동작하며 렌더링을 `appSpace`가 참조하는 React UI bundle에 위임한다.

## 워크플로 / 단계

### Step 1 — 필수 5개 프로퍼티 resolve

메타데이터 생성 전 5개 프로퍼티를 모두 resolve한다. 각각 fallback chain이 있으며 값이 나올 때까지 순서대로 시도한다.

| Property | Format | Resolve 방법 |
|----------|--------|--------------|
| **siteName** | `UpperCamelCase` (예: `MyCommunity`) | 사용자에게 묻거나 컨텍스트에서 도출 |
| **siteUrlPathPrefix** | `소문자` (예: `mycommunity`) | 사용자 제공, 또는 siteName을 영숫자만 소문자로 변환 |
| **appNamespace** | String | `sfdx-project.json`의 `namespace` → `sf data query -q "SELECT NamespacePrefix FROM Organization" --target-org ${usernameOrAlias}` → default `c` |
| **appDevName** | String | 프로젝트의 `UIBundle` 메타데이터 → `sf data query -q "SELECT DeveloperName FROM UIBundle" --target-org ${usernameOrAlias}` → default는 siteName |
| **enableGuestAccess** | Boolean | 비인증 guest user의 site API 접근 허용 여부 → default `false` |

`appNamespace`와 `appDevName`은 site를 올바른 React 앱에 연결한다. 틀리면 site는 배포되지만 빈 페이지가 나오므로 실제 프로젝트 데이터에서 신중히 resolve한다.

### Step 2 — 프로젝트 구조 생성

`Network`, `CustomSite`, `DigitalExperienceConfig`, `DigitalExperienceBundle`에 대해 유효한 Salesforce 메타데이터 스키마/필드 컨텍스트를 사용해 각 파일이 유효 구조를 갖도록 한다. 없는 파일·디렉터리를 다음 경로로 생성:

| Metadata Type | Path |
|--------------|------|
| Network | `networks/{siteName}.network-meta.xml` |
| CustomSite | `sites/{siteName}.site-meta.xml` |
| DigitalExperienceConfig | `digitalExperienceConfigs/{siteName}1.digitalExperienceConfig-meta.xml` |
| DigitalExperienceBundle | `digitalExperiences/site/{siteName}1/{siteName}1.digitalExperience-meta.xml` |
| DigitalExperience (sfdc_cms__site) | `digitalExperiences/site/{siteName}1/sfdc_cms__site/{siteName}1/*` |

DigitalExperience 디렉터리에는 `_meta.json`과 `content.json`만 있다. bundle 내부에 `sfdc_cms__site` 외 다른 디렉터리를 만들지 않는다.

### Step 3 — 모든 메타데이터 필드 채우기

아래 docs의 default 템플릿을 사용한다. `{braces}` 값은 resolve된 프로퍼티 참조 — Step 1의 실제 값으로 치환.

| Metadata Type | Template Reference |
|--------------|-------------------|
| Network | `docs/configure-metadata-network.md` |
| CustomSite | `docs/configure-metadata-custom-site.md` |
| DigitalExperienceConfig | `docs/configure-metadata-digital-experience-config.md` |
| DigitalExperienceBundle | `docs/configure-metadata-digital-experience-bundle.md` |
| DigitalExperience (sfdc_cms__site) | `docs/configure-metadata-digital-experience.md` |

URL 업데이트는 `docs/update-site-urls.md`.

**실행 노트:** agent는 Step 3 참조 docs/*.md 전체를 메타데이터 필드 채우기 전에 반드시 읽어야 한다. file-read 도구로 전체 로드 후 `{braces}` placeholder를 Step 1 resolve 값으로 치환해 expanded 템플릿으로 XML/JSON 콘텐츠를 채운다.

### Step 4 — non-templated 프로퍼티 수정 금지

`Network`, `CustomSite`, `DigitalExperience`, `DigitalExperienceConfig`, `DigitalExperienceBundle`에서 `{braces}` 변수로 표현되지 않은 default 프로퍼티 값은 수정하지 않는다.

### Verification Checklist

배포 전 확인:
- [ ] 5개 필수 프로퍼티 모두 resolve됨
- [ ] 모든 메타데이터 디렉터리·파일이 프로젝트 구조대로 존재
- [ ] 모든 메타데이터 필드가 Step 3 템플릿과 일치(`{braces}`만 치환); 다른 default 값 추가·변경 없음
- [ ] `content.json`의 `appSpace`가 기존 `UIBundle` 메타데이터 레코드와 일치
- [ ] 배포 validate 성공:

```bash
sf project deploy validate --metadata Network CustomSite DigitalExperienceConfig DigitalExperienceBundle DigitalExperience --target-org ${usernameOrAlias}
```

### Common Workflow — Experience Site URL 업데이트

**언제:** 사용자가 site URL(urlPathPrefix)을 변경하려 할 때.
- [ ] `docs/update-site-urls.md`를 읽고 three-component 아키텍처와 URL 업데이트 워크플로 이해
- [ ] doc의 단계별 워크플로를 따라 세 컴포넌트(DigitalExperienceConfig, Network, CustomSite) 전반에 URL을 일관되게 업데이트

## 핵심 규칙·가드레일

- React site는 `appContainer: true`인 얇은 컨테이너 — route/view/theme/branding 불필요, 렌더링은 `appSpace`가 가리키는 UI bundle에 위임.
- 메타데이터 생성 전 5개 프로퍼티 모두 resolve. `appNamespace`·`appDevName`을 실제 프로젝트 데이터에서 정확히 — 틀리면 빈 페이지.
- DigitalExperience bundle에는 `sfdc_cms__site`만, 그 안엔 `_meta.json`·`content.json`만.
- `{braces}` placeholder 외 default 프로퍼티 값 수정 금지.
- `appSpace`는 기존 `UIBundle` 레코드와 일치해야 함. 배포 전 `sf project deploy validate`.

## 번들 파일

| 파일 | 내용 |
|------|------|
| `docs/configure-metadata-network.md` | Network meta XML 템플릿 |
| `docs/configure-metadata-custom-site.md` | CustomSite meta XML 템플릿 |
| `docs/configure-metadata-digital-experience-config.md` | DigitalExperienceConfig 템플릿 |
| `docs/configure-metadata-digital-experience-bundle.md` | DigitalExperienceBundle 템플릿 |
| `docs/configure-metadata-digital-experience.md` | DigitalExperience(`sfdc_cms__site`) `_meta.json`·`content.json` 템플릿 |
| `docs/update-site-urls.md` | three-component URL 업데이트 워크플로 |

## 관련 노트
- [[experience-ui-bundle-metadata-generate]]
- [[experience-ui-bundle-custom-app-generate]]
- [[experience-ui-bundle-deploy]]
- [[experience-ui-bundle-app-coordinate]]
