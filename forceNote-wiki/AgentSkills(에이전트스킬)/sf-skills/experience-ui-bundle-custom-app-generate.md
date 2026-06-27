---
tags: [agent-skill, sf-skills, experience, ui-bundle, custom-application, metadata]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-custom-app-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-custom-app-generate, UI Bundle용 Custom Application 생성, CustomApplication metadata, App Launcher 등록, Lightning Experience 호스팅]
---

# experience-ui-bundle-custom-app-generate — React UI Bundle용 Custom Application 생성

> React UI bundle을 Lightning Experience에서 호스팅하는 Custom Application metadata를 생성·설정해, 앱이 Lightning App Launcher에 나타나 내부 사용자가 접근하도록 하는 스킬.

## 목적과 활성화 조건

**활성화(MUST):** `uiBundles/*/src/` 디렉터리가 있고 UI bundle을 Lightning Experience에서 호스팅할 Custom Application을 생성·설정하는 작업일 때. `applications/*.app-meta.xml` 파일이 존재해 수정 필요할 때, 또는 Digital Experience Site 없이 Lightning App Launcher로 앱을 노출하려 할 때.

**사용 안 함:** `platform-custom-application-generate`는 쓰지 않는다 — UI bundle 앱은 tab·action override·flexipage를 쓰지 않는다.

Custom Application은 Experience Site와 다르다: Network, CustomSite, DigitalExperienceConfig, DigitalExperienceBundle metadata가 필요 없다. Custom Application은 `uiBundle`이 참조하는 React UI bundle에 렌더링을 위임하는 얇은 launcher 엔트리로 동작한다.

### Required Properties

metadata 생성 전 모든 property를 해결한다. 각 property는 fallback chain을 순서대로 따른다.

| Property | Format | 해결 방법 |
|----------|--------|-----------|
| **appName** | `lowercamelcase` (예: `myInternalApp`) | `uiBundles/<name>/` 디렉터리의 UI bundle 이름 |
| **appNamespace** | String | `sfdx-project.json`의 `namespace` → `sf data query -q "SELECT NamespacePrefix FROM Organization" --target-org ${usernameOrAlias}` → 기본값 `c` |
| **appLabel** | Human-readable | 사용자 제공, 또는 appName을 camelCase→Title Case 변환 |

`appNamespace`와 `appName`이 Custom Application을 올바른 React UI bundle에 연결한다. 최신 API 버전은 `<uiBundle>{appNamespace}__{appName}</uiBundle>`, 구버전은 `<webApplication>{appName}</webApplication>`. 잘못하면 launcher 엔트리는 있지만 blank page가 뜬다. 어느 필드를 쓸지는 Step 2가 결정한다.

## 워크플로 / 단계

### Step 1: 모든 Required Property 해결
위 표의 전략으로 무엇이든 구성하기 전에 모든 property 값을 결정한다.

### Step 2: API Context 쿼리 (버전 인식 필드 탐색)
`salesforce-api-context` MCP tool을 호출해 대상 org API 버전에 존재하는 필드를 탐색한다.

**Required calls:**
1. `CustomApplication`에 대해 `get_metadata_type_fields` 호출 — `uiBundle` 필드 존재 확인
2. `UIBundle`에 대해 `get_metadata_type_fields` 호출 — `target` 필드 존재 확인

**API 응답 기반 필드 해결:**

| 필드 체크 | 존재 시 | 부재 시 (구버전 API) |
|-----------|---------|----------------------|
| `CustomApplication.uiBundle` | `<uiBundle>{appNamespace}__{appName}</uiBundle>` | `<webApplication>{appName}</webApplication>` (namespace 없음) |
| `UIBundle.target` | `<target>CustomApplication</target>` | `<target>` 요소 전체 생략 |

`salesforce-api-context`가 실제 시도 후에도 사용 불가면 최신 필드명(`uiBundle` + `target`)으로 fallback.

### Step 3: 프로젝트 구조 생성
없는 파일·디렉터리를 생성한다.

| Metadata Type | Path |
|---------------|------|
| CustomApplication | `<sourceDir>/applications/{appName}.app-meta.xml` |

**Note:** `<sourceDir>`는 `sfdx-project.json`에서 결정 — `packageDirectories[]`에서 `"default": true`인 항목을 읽고 전체 소스 디렉터리는 `<path>/main/default`. default가 없으면 첫 항목. 보통 `force-app/main/default`이나 경로는 설정 가능.

### Step 4: 모든 Metadata 필드 채우기
아래 doc의 기본 template을 사용한다. `{braces}` 값은 Step 1의 실제 값으로 치환하고, Step 2의 필드 해결을 적용한다.

| Metadata Type | Template Reference |
|---------------|--------------------|
| CustomApplication | `docs/configure-metadata-custom-application.md` |

**실행 노트:** Step 4의 `docs/*.md` 파일 전체를 반드시 먼저 읽고, placeholder(예: `{appName}`)를 해결된 값으로 치환한 뒤 확장된 template으로 metadata XML을 채운다. Step 2가 구버전 필드명을 결정했으면 출력에서 `<uiBundle>`을 `<webApplication>`으로 치환한다.

### Step 5: UI Bundle Meta XML 갱신
Step 2가 `UIBundle`에 `target` 필드 존재를 확인했으면 `.uibundle-meta.xml`에 `<target>CustomApplication</target>`을 추가한다(org API 버전에 필드 없으면 생략).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<UIBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>{appName}</masterLabel>
    <description>A Salesforce UI Bundle.</description>
    <isActive>true</isActive>
    <version>1</version>
    <target>CustomApplication</target>
</UIBundle>
```

### Step 6: 비-templated property 수정 금지
`{braces}` 변수로 표현되지 않은 `CustomApplication` metadata 기본값은 수정하지 않는다.

### Verification Checklist (배포 전)

```
[ ] 모든 required property 해결됨
[ ] 사용 가능 필드 판별 위해 API context 쿼리됨 (Step 2)
[ ] applications/{appName}.app-meta.xml 존재 + 올바른 내용
[ ] bundle 참조 필드가 org API 버전과 일치 (<uiBundle> 또는 <webApplication>)
[ ] target 필드 지원 시: .uibundle-meta.xml에 <target>CustomApplication</target>
[ ] 배포 검증 성공:
```

```bash
sf project deploy validate --metadata CustomApplication UIBundle --target-org ${usernameOrAlias}
```

## 핵심 규칙·가드레일

- `platform-custom-application-generate`를 쓰지 않는다 — UI bundle 앱은 tab/action override/flexipage 미사용.
- bundle 참조 필드를 API 버전에 맞게 선택(`uiBundle` vs `webApplication`) — 틀리면 blank page.
- metadata 채우기 전 `docs/configure-metadata-custom-application.md` 전체를 반드시 읽는다.
- `{braces}` 변수가 아닌 기본 property는 수정 금지.

## 번들 파일

| 파일 | 용도 |
|------|------|
| `docs/configure-metadata-custom-application.md` | Step 4 — CustomApplication metadata XML 기본 template (placeholder 치환용) |

## 관련 노트
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-deploy]]
