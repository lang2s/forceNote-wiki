---
tags: [slds, starter-kit, agent-skills, github, gh-cli, github-pages, deployment, devops]
source: salesforce-ux/design-system-2-starter-kit (.agent/skills/, 공식 Salesforce UX)
created: 2026-06-26
aliases: [repo-setup 스킬, first-time-deploy 스킬, gh CLI 저장소 생성, GitHub Pages 설정, gh-pages 브랜치, gh api pages, 저장소 백업, 배포 스킬]
---

# SLDS 2 Starter Kit - 저장소 설정과 배포 스킬

> 스타터킷에 동봉되어 git으로 추적되는 2개 에이전트 스킬(`repo-setup`, `first-time-deploy`): 비기술 사용자를 GitHub 저장소 생성부터 GitHub Pages 배포까지 단계별로 안내한다.

---

## 개요

`design-system-2-starter-kit` 저장소의 `.agent/skills/` 폴더에는 에이전트(예: Claude Code 류)가 사용자를 안내하기 위한 SKILL.md 파일들이 들어간다. 그러나 **실제로 git에 커밋되어 ship되는 스킬은 다음 2개뿐**이다.

| 스킬 | 파일 | 역할 |
|---|---|---|
| `repo-setup` | `.agent/skills/repo-setup/SKILL.md` | 프로젝트용 원격 GitHub 저장소를 만들고 초기 push까지 수행 |
| `first-time-deploy` | `.agent/skills/first-time-deploy/SKILL.md` | 프로젝트를 GitHub Pages에 최초로 배포·설정 |

나머지 afv-library 계열 스킬 3종(`applying-slds` 등)은 `npm install` 시점에 동기화되며 `.gitignore`되어 저장소에는 포함되지 않는다. 따라서 git clone만 했을 때 손에 들어오는 스킬은 위 두 개다.

> afv-library 스킬 카탈로그(동기화되는 스킬 표)는 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]를 참조.

### Tone 규칙 — 두 스킬 공통

두 SKILL.md 모두 `## Tone` 섹션에서 동일한 지침을 둔다. 사용자가 비기술자일 수 있으므로, **정확한 기술 용어를 쓰되 곧바로 괄호로 평어 설명을 붙인다.** 첫 등장뿐 아니라 매번 그렇게 한다.

> SKILL.md 원문(repo-setup `## Tone`):
> *"The user may not be technical. Always use the correct technical term but immediately follow it with a plain-language explanation in parentheses, e.g. "commit your changes (save a snapshot of your work)" or "push your code (send your latest changes to GitHub so others can see them)". Do this every time, not just the first mention."*

---

## repo-setup 스킬

SKILL.md frontmatter(원문):

```yaml
name: repo-setup
version: "1.0.0"
description: "Set up a GitHub repo for this project. Detects the GitHub host from the origin remote, covers prerequisites (brew, gh CLI, auth), repo creation, and initial push. Use when the user needs a remote repo, asks about pushing code, or before first-time-deploy."
```

이 프로젝트용 원격 GitHub 저장소를 설정하는 9단계 절차다.

### 1. git 저장소인지 확인

```bash
git rev-parse --git-dir
```

git 저장소가 아니면(예: 사용자가 zip을 내려받은 경우) 초기화하고 첫 커밋을 만든다.

```bash
git init
git add .
git commit -m "Initial commit"
```

### 2. GitHub host 감지

기존 `origin` 리모트를 확인해 이 프로젝트가 쓰는 GitHub host를 판별한다.

```bash
git remote get-url origin
```

URL에서 hostname(예: `github.com` 또는 GitHub Enterprise hostname)을 추출해 이후 모든 단계에서 `<hostname>`으로 사용한다.

- `origin`이 **템플릿 저장소**(`salesforce-ux/design-system-2-starter-kit`)를 가리키면, hostname만 추출하고 사용자의 저장소로 취급하지 않는다. 이 경우 7단계에서 새 저장소를 만들어야 한다.
- `origin`이 아예 설정되어 있지 않으면(zip에서 갓 초기화한 경우 등) 어떤 GitHub host를 쓰는지 사용자에게 묻는다.

### 3. Homebrew 설치 확인

```bash
which brew
```

없으면 설치한다(1분 정도 걸릴 수 있음).

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 4. `gh` CLI 설치 확인

```bash
which gh
```

없으면:

```bash
brew install gh
```

### 5. GitHub 인증

이미 `<hostname>`에 인증되어 있는지 확인한다.

```bash
gh auth status --hostname <hostname>
```

인증되어 있지 않으면 `gh auth login`으로 안내한다.

```bash
gh auth login
```

프롬프트가 나오면:
1. **Where do you use GitHub?** — `<hostname>`이 `github.com`이면 **GitHub.com** 선택. 아니면 **Other**를 고르고 hostname 입력.
2. 이후 브라우저/토큰 프롬프트를 따른다.

### 6. 기존 원격 저장소 확인

`origin`이 설정되어 있고 템플릿 저장소가 아니라면(2단계 기준), 저장소에 도달 가능한지 확인한다.

```bash
gh repo view --json name --hostname <hostname>
```

`origin`이 없거나 저장소가 존재하지 않으면, 원격 저장소를 찾지 못했다고 알리고 새로 만들지 물어본다.

### 7. 저장소 생성(필요 시)

현재 디렉터리 이름을 기본 저장소 이름으로 사용한다. 만약 그 이름이 여전히 `design-system-2-starter-kit`라면, 프로젝트를 어떻게 부를지 사용자에게 묻는다. 진행 전에 이름을 확인받는다.

```bash
gh repo create <repo-name> --internal --source=. --hostname <hostname>
```

이 명령은 사용자 개인 계정 아래에 **internal** 가시성(조직 구성원이 접근 가능)으로 저장소를 만든다. 조직(organization)에 대해서는 묻지 않는다.

### 8. 커밋과 push

커밋되지 않은 변경이 있는지 확인한다.

```bash
git status
```

staged/unstaged 변경이 있으면 사용자가 커밋하도록 돕는다(파일 추가, 커밋 메시지 작성, 커밋). 그런 다음 리모트로 push한다. 이로써 프로젝트가 저장소로 업로드되어 다른 사람이 접근할 수 있다.

```bash
git push -u origin main
```

push 전에 사용자에게 묻는다. 기본 브랜치가 `main`이 아니면 현재 브랜치를 사용한다.

### 9. 확인

저장소가 설정되고 코드가 push되었음을 알리고 저장소 URL을 제공한다.

```bash
gh repo view --json url --hostname <hostname> --jq '.url'
```

---

## first-time-deploy 스킬

SKILL.md frontmatter(원문):

```yaml
name: first-time-deploy
version: "1.0.0"
description: "Publish this project to GitHub Pages. For repeat deploys, just run `npm run deploy`. This skill covers first-time setup: configuring Pages and running the initial deploy. Use when the user asks about deploying, publishing, sharing a link with a PM or stakeholder, or setting up GitHub Pages."
```

핵심 전제: **반복 배포(repeat deploys)는 `npm run deploy` 하나면 끝이다.** 이 스킬은 그 전 단계인 **최초 설정**(저장소 존재 확인, 첫 배포, GitHub Pages 구성)을 다룬다.

### 1. 배포 — `gh-pages` 브랜치 생성

프로젝트의 deploy 스크립트를 실행한다. hash routing으로 사이트를 빌드하고 `dist/`를 `gh-pages` 브랜치로 push한다.

```bash
npm run deploy
```

이 단계는 Pages 설정보다 **먼저** 일어나야 한다. `gh-pages` 브랜치가 먼저 존재해야 하기 때문이다.

> `npm run deploy`의 내부 동작(빌드 → gh-pages push)은 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]를 참조.

### 2. 저장소에 GitHub Pages 설정

원격에 `gh-pages`가 생긴 뒤 저장소를 구성한다. POST로 생성하고, 이미 존재하면 PUT으로 갱신하는 fallback 구조다.

```bash
gh api repos/{owner}/{repo}/pages \
  --hostname <hostname> \
  --method POST \
  --field source='{"branch":"gh-pages","path":"/"}' \
  --silent 2>/dev/null \
  || gh api repos/{owner}/{repo}/pages \
     --hostname <hostname> \
     --method PUT \
     --field source='{"branch":"gh-pages","path":"/"}'
```

`POST`는 Pages 설정을 만들고, 이미 존재하면 `PUT`이 갱신한다.

검증:

```bash
gh api repos/{owner}/{repo}/pages --hostname <hostname> --jq '.source'
```

예상 결과: `{ "branch": "gh-pages", "path": "/" }`.

### 3. 배포 URL 가져오기

```bash
gh api repos/{owner}/{repo}/pages --hostname <hostname> --jq '.html_url'
```

URL을 사용자에게 공유한다. API가 URL을 반환하지 않으면(Pages가 아직 프로비저닝 중일 수 있음), 저장소의 **Settings > Pages**에서 찾을 수 있다고 안내한다.

---

## 두 스킬의 관계

`first-time-deploy`는 `repo-setup`을 **prerequisite로 명시 호출**한다. SKILL.md의 `## Prerequisites` 원문:

> *"Run the **repo-setup** skill first (`.agent/skills/repo-setup/SKILL.md`). It handles brew, `gh` CLI, authentication, repo creation, and initial push. It also detects the GitHub `<hostname>` from the `origin` remote. Use that same `<hostname>` throughout the steps below."*

즉 흐름은 다음과 같다.

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (SKILL.md 서술을 흐름으로 정리)
repo-setup (brew → gh → auth → repo create → push, <hostname> 감지)
        │   감지한 <hostname>을 그대로 인계
        ▼
first-time-deploy (npm run deploy → gh api pages 설정 → URL 공유)
        │
        ▼
이후 반복 배포: npm run deploy 만 실행
```

- `repo-setup`이 감지한 `<hostname>`은 `first-time-deploy`의 모든 `gh api ...` 명령에서 그대로 재사용된다.
- 최초 배포가 끝나면 GitHub Pages 설정이 한 번만 필요하므로, 이후에는 `first-time-deploy` 없이 `npm run deploy`만 반복하면 된다.

---

## 관련 노트
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 개발 도구]]
