---
tags: [agent-skill, sf-skills, commerce, b2b, open-source]
source: forcedotcom/sf-skills (skills/commerce-b2b-open-code-components-integrate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [commerce-b2b-open-code-components-integrate, B2B 오픈코드 컴포넌트 통합, open source B2B commerce components, Experience Builder 컴포넌트, sfdc_cms__lwc]
---

# commerce-b2b-open-code-components-integrate — B2B 오픈코드 컴포넌트 통합 스킬

> 공식 Salesforce 리포지토리(forcedotcom/b2b-commerce-open-source-components)의 모든 오픈소스 B2B Commerce 컴포넌트를 스토어의 site 메타데이터로 복사해 Experience Builder 팔레트에 노출시키는 스킬.

---

## 목적과 활성화 조건

이 스킬은 다음을 할 때 사용한다:
- 모든 오픈소스 B2B Commerce 컴포넌트를 스토어에 통합
- 신규 또는 기존 B2B Commerce 스토어에 오픈소스 컴포넌트 추가
- 오픈코드 컴포넌트를 Experience Builder에서 사용 가능하게 만들기

트리거 표현: "integrate open code components", "open source B2B commerce", "add open code components", "forcedotcom/b2b-commerce-open-source-components".

동작 요약: 공식 repo(https://github.com/forcedotcom/b2b-commerce-open-source-components)의 모든 오픈소스 컴포넌트를 B2B Commerce 스토어의 site 메타데이터로 복사한다. 통합 후 컴포넌트가 Experience Builder 컴포넌트 팔레트에 나타난다.

**allowed-tools:** `Bash(git clone:*)`, `Bash(cp:*)`, `Read`

---

## 워크플로 / 단계

스킬 트리거 시 복사 전에 Startup Flow 체크를 자동 수행한다.

**Check 0 — 패키지 디렉터리 해석:** `sfdx-project.json`을 읽어 active 패키지 디렉터리를 고른다. `packageDirectories[]`에서 `"default": true`인 항목을 사용하고, default 플래그가 없으면 첫 항목을 사용. 이 값을 이후 `<package-dir>`로 사용. 파일이 없거나 `packageDirectories`가 없으면 사용자에게 알리고 중단.

**Check 1 — 오픈소스 리포지토리:** `.tmp/b2b-commerce-open-source-components`에 클론됐는지 확인.
1. 디렉터리 없음 → 사용자에게 알리고 아래 git clone 실행
2. 디렉터리 있고 `force-app/main/default/sfdc_cms__lwc` + `sfdc_cms__label` 포함 → "Reuse existing" / "Re-clone" 옵션 제시
3. 디렉터리 있으나 구조 무효 → 제거 후 재클론
4. clone 실패 → 사용자에게 알리고 중단

**Check 2 — Store 및 Site 메타데이터:**
1. `<package-dir>/main/default/digitalExperiences/site/`에 스토어 디렉터리가 있는지 확인
2. store 메타데이터 존재 → 사용. 여러 개면 사용자 선택
3. 없으면 연결된 org에서 retrieve 시도(`sf org list`로 org 찾기 → `DigitalExperienceBundle` site 번들 나열 → `sf project retrieve start`)
4. **연결된 org 없음 / site 번들 없음 / retrieve 실패일 때만** `commerce-b2b-store-create` 스킬로 위임

**Integration Task — 컴포넌트/라벨 복사:**
- **Source:** `.tmp/b2b-commerce-open-source-components/force-app/main/default/sfdc_cms__lwc/*` 와 `sfdc_cms__label/*` (오픈소스 repo 레이아웃은 항상 `force-app`)
- **Destination:** `<package-dir>/main/default/digitalExperiences/site/<store-name>/sfdc_cms__lwc/` 와 `sfdc_cms__label/`
- 대상에 파일 존재 시 "Overwrite all" / "Copy only new" 옵션 제시
- 컴포넌트 디렉터리 복사 → 라벨 디렉터리 복사 → "Copied X components and Y label sets" 보고

clone 명령 (verbatim):

```
git clone https://github.com/forcedotcom/b2b-commerce-open-source-components .tmp/b2b-commerce-open-source-components
```

완료 출력 (verbatim):

```
✅ Integration Complete!

Copied: X components and Y label sets to <store-name>

Next Steps:
1. Deploy: sf project deploy start -d <package-dir>/main/default/digitalExperiences/site/<store-name>
2. Open Experience Builder and use new components from the palette
3. Publish your site when ready
```

---

## 핵심 규칙·가드레일

**Rule 1 — Always explain before executing.** 어떤 명령을 실행하기 전에 반드시 그 명령이 무엇을 하고 왜 실행하는지 사용자에게 설명해야 한다. 원시 명령만 보여주고 승인을 요청하지 않는다. 사용자가 설명을 읽고 목적을 이해한 뒤 승인할 수 있어야 한다.

**Required state (모든 체크 후):**
- Package dir — Check 0에서 해석된 값 (예: `force-app`)
- Store name — 선택된 `fullName` 값 (예: `My_B2B_Store1`)
- Site metadata path — `<package-dir>/main/default/digitalExperiences/site/<store-name>/`
- Repo path — `.tmp/b2b-commerce-open-source-components/`

**Error Handling:**

| Error | Message | Action |
|---|---|---|
| Store not found | "Store '{name}' not found in org." | List stores again |
| Git clone failed | "Failed to clone repository. Check internet connection." | Retry or abort |
| Invalid repo structure | "Repository structure has changed. Expected sfdc_cms__lwc and sfdc_cms__label." | Warn user, abort |
| File copy failed | "Failed to copy files. Check file permissions." | Show error details |

**Verification Checklist:** Startup Flow 완료(repo clone, store 메타데이터 확보) / 컴포넌트가 `sfdc_cms__lwc/`에 복사됨 / 라벨이 `sfdc_cms__label/`에 복사됨 / 파일 권한 오류 없음 / 배포 명령 제공 및 테스트 안내.

---

## 번들 파일

- `SKILL.md` — 스킬 정의 (Startup Flow, Integration Task, Error Handling, Verification Checklist)

(레퍼런스/스크립트/에셋 번들 파일 없음 — SKILL.md 단일 파일)

---

## 관련 노트

- [[commerce-b2b-store-create]]
