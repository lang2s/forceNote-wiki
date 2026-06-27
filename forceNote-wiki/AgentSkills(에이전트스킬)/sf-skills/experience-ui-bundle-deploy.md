---
tags: [agent-skill, sf-skills, experience, ui-bundle, deploy, graphql-codegen]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-deploy/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-deploy, UI Bundle 배포, deploy ui bundle, post-deploy setup, GraphQL schema fetch codegen, permission set 할당]
---

# experience-ui-bundle-deploy — UI Bundle 배포 (7단계 canonical 시퀀스)

> UI bundle 앱을 Salesforce org에 배포하는 전체 시퀀스 — org 인증, pre-deploy build, metadata 배포, permission set 할당, data import, GraphQL schema fetch, codegen. 작업 순서가 결정적으로 중요하다.

## 목적과 활성화 조건

**활성화(MUST):** `uiBundles/*/src/` 또는 `sfdx-project.json`이 있고 배포·org push·post-deploy setup 작업일 때. `*.uibundle-meta.xml` 또는 `sfdx-project.json`이 있고 사용자가 deploy/push/org setup/post-deploy task를 언급할 때.

org 배포 시 작업 순서가 critical하다. 이 시퀀스는 canonical flow를 반영한다.

## 워크플로 / 단계

### Step 1: Org 인증
org 연결 여부 확인. 미연결이면 인증. 이후 모든 단계는 인증된 org가 필요하다.

### Step 2: Pre-deploy UI Bundle Build
의존성 설치 + UI bundle build로 `dist/` 생성. UI bundle 엔티티 배포 전 필수.
실행 시점: UI bundle 배포 중이고 `dist/`가 없거나 소스가 변경됐을 때.

### Step 3: Deploy Metadata
먼저 manifest(`manifest/package.xml` 또는 `package.xml`)를 확인. 있으면 manifest로 배포, 없으면 프로젝트의 모든 metadata 배포.
object, layout, permission set, Apex class, UI bundle 등 모든 metadata를 배포한다. schema fetch 전 완료돼야 한다 — schema는 org 상태를 반영하기 때문.

### Step 4: Post-deploy Configuration
배포가 곧 할당은 아니다. 배포 후:

- **Permission sets / groups** — custom object·field 접근 위해 사용자에게 할당. GraphQL introspection이 올바른 schema를 반환하려면 필수.
- **Profiles** — 사용자가 올바른 profile을 갖도록.
- **기타 config** — named credentials, connected apps, custom settings, flow activation.

Proactive: 성공적 배포 후 `force-app/main/default/permissionsets/`의 permission set을 발견해 각각 할당(또는 사용자에게 질문).

### Step 5: Data Import (optional)
`data/data-plan.json`이 있을 때만. Delete는 plan 역순(children → parents). Import는 duplicate rule save enabled 상태의 Anonymous Apex 사용.
데이터 import·clean 전 **항상** 사용자에게 질문한다.

### Step 6: GraphQL Schema and Codegen
1. default org 설정
2. schema fetch (GraphQL introspection) — 프로젝트 루트에 `schema.graphql` 작성
3. type 생성 (codegen이 로컬 schema 읽음)

실행 시점: schema 없거나, 마지막 fetch 이후 metadata/permission이 변경됐을 때.

### Step 7: Final UI Bundle Build
Step 2에서 안 했으면 UI bundle을 build.

### Summary: Interaction Order

```
1. org 확인/인증
2. UI bundle build (UI bundle 배포 시)
3. metadata 배포
4. permission 할당 및 config
5. data import (data plan 존재 시, 사용자 확인)
6. GraphQL schema fetch + codegen
7. UI bundle build (필요 시)
```

## 핵심 규칙·가드레일

### Critical Rules

- metadata를 schema fetch **전에** 배포 — custom object/field는 배포 후에야 나타남.
- permission을 schema fetch **전에** 할당 — 사용자가 custom field의 FLS가 없을 수 있음.
- object/field/permission을 바꾸는 metadata 배포 **후마다** schema fetch + codegen 재실행.
- permission set 할당이나 data import를 조용히 건너뛰지 않는다 — 실행하거나 사용자에게 질문.

### Post-deploy Checklist (성공적 metadata 배포 후마다)

```
1. permission set 발견·할당 (또는 사용자에게 질문)
2. data/data-plan.json 있으면 data import 여부 사용자에게 질문
3. UI bundle 디렉터리에서 schema fetch + codegen 재실행
```

## 번들 파일

- `SKILL.md` — 7단계 배포 시퀀스 정의 (별도 참조 파일 없음)

## 관련 노트
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-custom-app-generate]]
