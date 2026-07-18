---
tags: [devops, salesforce-dx, sf-cli, sfdx, command-catalog, migration, cli-mapping]
source: DX 개발 워크플로.md · Scratch Org 생성과 정의 파일.md · Source Tracking 변경 추적.md · DX 프로젝트 구조와 소스 포맷.md · DX 데이터 작업.md · Change Sets 배포.md · Metadata API 빌드·릴리스 워크플로.md · Sandbox 관리.md · DX 인증 방식.md · 메타데이터 분해와 forceignore.md (조합 · 원본 sfdx_dev.pdf v67.0 Tier 2 승계)
created: 2026-07-12
aliases: [sf CLI 명령 카탈로그, sf command catalog, sfdx to sf, sfdx→sf 매핑, sfdx force source push, sf project deploy start 매핑, CLI 마이그레이션, sf command reference]
---

# sf CLI 명령 카탈로그 · sfdx→sf 매핑

> DevOps 도메인 15개 워크플로 노트에 흩어져 있는 `sf` (v2) 명령을 주제별로 한 곳에 색인하고, 레거시 `sfdx` (v1) 문법 → `sf` (v2) 문법의 표준 마이그레이션 매핑을 제공하는 라우팅 노트. 각 명령의 플래그·상세 워크플로는 소관 노트로 위임한다.

---

## sf (v2) vs sfdx (v1) — 맥락

- **`sf` (v2)** — 현재 권장 CLI. `sf <topic> <verb> <object>` 문법. 이 위키의 모든 DevOps 노트가 `sf` 문법으로 일관 작성돼 있다.
- **`sfdx` (v1)** — `sfdx force:<topic>:<verb>` 콜론 네임스페이스 문법. **유지보수 모드**로, 신규 기능은 `sf`에만 추가된다. 기존 스크립트/CI 파이프라인은 아래 매핑표로 전환한다.
- 두 실행 파일은 한동안 공존하지만, 새 프로젝트·문서·자동화는 `sf`를 쓴다.

```bash
// 구조 예시 — 실제 동작 코드 아님 (문법 형태 대조)
# v1 (레거시, 유지보수 모드)
sfdx force:source:push -u myscratch

# v2 (권장) — topic verb object 공백 구분
sf project deploy start --target-org myscratch
```

> 이 노트는 **색인·매핑 전용**이다. 각 명령의 플래그 전수·출력 예시·워크플로 절차는 아래 표의 "상세 노트"가 소관하며, 여기서 재서술하지 않는다.

---

## 명령 카탈로그 (주제별)

수록된 명령은 모두 위 조합 소스 노트에 실재하는 것만 옮겼다(창작 없음). "용도"는 1줄 요약이며, 플래그·예시는 상세 노트를 참조한다.

### 1. 프로젝트 · 소스 파일 생성 (`sf project generate`, `sf apex/lightning/schema generate`)

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf project generate` | DX 프로젝트 생성 (`--template empty/standard/analytics`) | [[DX 프로젝트 구조와 소스 포맷]] |
| `sf project generate manifest` | org에서 `package.xml` 매니페스트 자동 생성 | [[DX 프로젝트 구조와 소스 포맷]] |
| `sf apex generate class` | Apex 클래스 소스 파일 생성 (`--template` 4종) | [[DX 개발 워크플로]] |
| `sf apex generate trigger` | Apex 트리거 생성 (`--event`·`--sobject`) | [[DX 개발 워크플로]] |
| `sf lightning generate component` | LWC/Aura 컴포넌트 생성 (`--type lwc/aura`) | [[DX 개발 워크플로]] |
| `sf lightning generate app` | Lightning App(Aura) 생성 | [[DX 개발 워크플로]] |
| `sf lightning generate event/interface/test` | Aura event·interface·test 생성 | [[DX 개발 워크플로]] |
| `sf schema generate sobject` | Custom Object 메타데이터 대화형 생성 | [[DX 개발 워크플로]] |
| `sf schema generate field` | Custom/표준 Object에 Custom Field 생성 | [[DX 개발 워크플로]] |
| `sf schema generate tab` | Custom Object용 Custom Tab 생성 | [[DX 개발 워크플로]] |
| `sf schema generate platformevent` | Platform Event 정의 생성 | [[DX 개발 워크플로]] |
| `sf cmdt generate object/field/record/records/fromorg` | Custom Metadata Type 오브젝트·필드·레코드 생성 | [[DX 개발 워크플로]] |
| `sf static-resource generate` | Static Resource 생성 | [[DX 개발 워크플로]] |
| `sf visualforce generate component/page` | VF 컴포넌트·페이지 생성 | [[DX 개발 워크플로]] |

### 2. Org 인증 · 관리 (`sf org login/create/display/list`)

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf org login web` | 브라우저(Web Server Flow) 인증. MFA·SSO 지원 | [[DX 인증 방식]] |
| `sf org login jwt` | JWT Bearer Flow 인증 (CI/CD·헤드리스) | [[DX 인증 방식]] |
| `sf org login sfdx-url` | SFDX Auth URL 파일로 재인증 (CI 이식) | [[DX 인증 방식]] |
| `sf org logout` | 특정 org 또는 `--all` 로그아웃 | [[DX 인증 방식]] |
| `sf org display` | 단일 org 인증 정보 조회 (`--verbose`로 Auth URL) | [[DX 인증 방식]] |
| `sf org list` | 인증 org·Scratch Org 목록 (`--verbose`·`--clean`) | [[DX 프로젝트 구조와 소스 포맷]] |
| `sf org open` | 브라우저에서 org 열기 (`--source-file`로 FlexiPage) | [[DX 개발 워크플로]] |
| `sf org create scratch` | Dev Hub에서 Scratch Org 생성 | [[Scratch Org 생성과 정의 파일]] |
| `sf org resume scratch` | 비동기 Scratch Org 생성 상태 재개(job-id) | [[Scratch Org 생성과 정의 파일]] |
| `sf org delete scratch` | Scratch Org 삭제 | [[Scratch Org 생성과 정의 파일]] |
| `sf org create sandbox` | Production Org에서 Sandbox 생성·복제 | [[Sandbox 관리]] |
| `sf org refresh sandbox` | 기존 Sandbox 갱신 | [[Sandbox 관리]] |
| `sf org resume sandbox` | Sandbox 생성/복제 상태 재개(job-id) | [[Sandbox 관리]] |
| `sf org delete sandbox` | Sandbox 삭제 | [[Sandbox 관리]] |
| `sf org assign permset` | 사용자에게 Permission Set 할당 (`--on-behalf-of`) | [[DX 개발 워크플로]] |
| `sf org assign permsetlicense` | Permission Set License 할당 | [[DX 개발 워크플로]] |
| `sf org generate password` | Scratch Org 사용자 비밀번호 생성 | [[Scratch Org 생성과 정의 파일]] |
| `sf limits api display` | API 한도(ActiveScratchOrgs 등) 조회 | [[Scratch Org 생성과 정의 파일]] |

### 3. 배포 · 검색 · 소스 추적 (`sf project deploy/retrieve/convert`)

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf project deploy start` | 로컬 소스를 org에 배포 | [[Source Tracking 변경 추적]] |
| `sf project deploy preview` | 배포될 변경 미리보기(충돌 감지) | [[Source Tracking 변경 추적]] |
| `sf project deploy validate` | 체크온리 검증 배포 → job ID 반환 | [[Metadata API 빌드·릴리스 워크플로]] |
| `sf project deploy quick` | 검증 완료 job ID로 빠른 배포 | [[Metadata API 빌드·릴리스 워크플로]] |
| `sf project deploy cancel` | 진행 중 배포 취소 | [[Metadata API 빌드·릴리스 워크플로]] |
| `sf project deploy report` | 배포 상태 보고 | [[Metadata API 빌드·릴리스 워크플로]] |
| `sf project retrieve start` | org 메타데이터를 로컬로 검색 | [[Source Tracking 변경 추적]] |
| `sf project retrieve preview` | 검색될 변경 미리보기 | [[Source Tracking 변경 추적]] |
| `sf project delete source` | 비소스추적 org에서 컴포넌트 삭제 | [[DX 개발 워크플로]] |
| `sf project convert mdapi` | Metadata 형식 → 소스 포맷 변환 | [[DX 프로젝트 구조와 소스 포맷]] |
| `sf project convert source-behavior` | 선택적 분해(Decompose) Beta 활성화 | [[메타데이터 분해와 forceignore]] |
| `sf project list ignored` | `.forceignore`로 무시되는 파일 목록 | [[메타데이터 분해와 forceignore]] |
| `sf org enable tracking` | 기존 org에서 소스 추적 활성화 | [[Source Tracking 변경 추적]] |
| `sf org disable tracking` | 기존 org에서 소스 추적 비활성화 | [[Source Tracking 변경 추적]] |

### 4. 데이터 (`sf data`)

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf data export tree` / `import tree` | 소규모(<3,000건) JSON tree 내보내기·가져오기 | [[DX 데이터 작업]] |
| `sf data export bulk` / `import bulk` | 대용량 Bulk API 2.0 내보내기·가져오기 | [[DX 데이터 작업]] |
| `sf data update bulk` / `upsert bulk` / `delete bulk` | 대용량 업데이트·업서트·삭제 | [[DX 데이터 작업]] |
| `sf data export/import/update/upsert/delete resume` | 타임아웃된 bulk 작업 재개(job-id) | [[DX 데이터 작업]] |
| `sf data bulk results` | 완료된 bulk 작업 상세 결과 조회 | [[DX 데이터 작업]] |
| `sf data create/get/update/delete record` | 단건 레코드 CRUD (`--use-tooling-api` 지원) | [[DX 데이터 작업]] |
| `sf data query` | SOQL 쿼리 (`--use-tooling-api`·`--result-format`) | [[DX 데이터 작업]] |
| `sf data search` | SOSL 텍스트 검색 | [[DX 데이터 작업]] |
| `sf data create file` | 로컬 파일을 ContentDocument로 업로드 | [[DX 데이터 작업]] |

### 5. Apex 실행 · 테스트 · 로그 (`sf apex`)

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf apex run` | 익명 Apex 실행 (인터랙티브 또는 `--file`) | [[DX 개발 워크플로]] |
| `sf apex run test` | Apex 테스트 실행 (`--code-coverage`·`--result-format`) | [[DX 개발 워크플로]] |
| `sf apex get test` | job ID로 테스트 결과 조회 | [[DX 개발 워크플로]] |
| `sf apex list log` | debug log 목록 조회 | [[DX 개발 워크플로]] |
| `sf apex get log` | log ID로 특정 debug log 조회 | [[DX 개발 워크플로]] |

> `sf apex tail`·`sf apex log`(플랫폼 디버그 로그 스트리밍/조회)는 [[DX 개발 워크플로]]의 관련 노트가 가리키는 Apex Debug Log 노트 소관으로, 이 카탈로그에서는 명령 존재만 표기한다.

### 6. 패키지 (`sf package`)

> 아래 명령의 상세(생성·버전·설치 워크플로)는 이 조합 소스 10개 노트가 아니라 **패키지 전용 노트**가 소관한다. 카탈로그 색인 목적으로만 나열하며 메커니즘은 위임한다.

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf package create` | 패키지(2GP/Unlocked) 정의 생성 | [[Unlocked Package 개발과 버전]] |
| `sf package version create` | 패키지 버전 생성(빌드) | [[Unlocked Package 개발과 버전]] |
| `sf package version promote` | 패키지 버전을 released로 승격 | [[Unlocked Package 릴리스와 설치]] |
| `sf package install` | 대상 org에 패키지 버전 설치 | [[Unlocked Package 릴리스와 설치]] |
| `sf package uninstall` | 패키지 제거 | [[Unlocked Package 릴리스와 설치]] |
| `sf package list` / `version list` | 패키지·버전 목록 조회 | [[Unlocked Package 개발과 버전]] |
| `sf package push` | 관리 패키지 업그레이드 푸시 | [[2GP Managed Package — Workflow]] |

### 7. Config · Alias · 기타

| 명령 | 용도 | 상세 노트 |
|---|---|---|
| `sf config set` / `unset` / `list` | `target-org`·`target-dev-hub`·`org-api-version` 등 설정 | [[DX 프로젝트 구조와 소스 포맷]] |
| `sf alias set` / `unset` / `list` | username에 별칭 부여·관리 | [[DX 프로젝트 구조와 소스 포맷]] |

---

## sfdx (v1) → sf (v2) 마이그레이션 매핑표

아래는 레거시 `sfdx force:*` 명령의 표준 `sf` 대응이다. 대응 명령은 위 카탈로그에 실재하는 `sf` 명령이며, 레거시 `sfdx` 형태는 잘 알려진 표준 매핑을 옮긴 것이다. 단일 대응이 없거나 플래그가 크게 다른 항목은 별도 표기했다.

### 프로젝트 · 소스 배포/검색

| 레거시 `sfdx` (v1) | 현행 `sf` (v2) | 비고 |
|---|---|---|
| `sfdx force:project:create` | `sf project generate` | |
| `sfdx force:source:push` | `sf project deploy start` | 소스 추적 org 대상 |
| `sfdx force:source:pull` | `sf project retrieve start` | 소스 추적 org 대상 |
| `sfdx force:source:deploy` | `sf project deploy start` | `--source-dir`/`--manifest`/`--metadata`로 대상 지정 |
| `sfdx force:source:retrieve` | `sf project retrieve start` | 동일 스코핑 플래그 |
| `sfdx force:source:delete` | `sf project delete source` | |
| `sfdx force:source:status` | `sf project deploy preview` + `sf project retrieve preview` | **단일 대응 없음** — 방향별 preview 2개로 분리 |
| `sfdx force:source:convert` | `sf project convert source` | ⚠️ 확인 필요 — 이 노트 조합 소스에는 `convert mdapi`만 실재, `convert source`는 표준 매핑 |
| `sfdx force:mdapi:convert` | `sf project convert mdapi` | |
| `sfdx force:mdapi:deploy` | `sf project deploy start` | 메타데이터 형식 배포 — `--metadata-dir` 플래그. ⚠️ 플래그 확인 필요 |
| `sfdx force:mdapi:retrieve` | `sf project retrieve start` | 메타데이터 형식 검색 — 대상 디렉토리 플래그 상이. ⚠️ 확인 필요 |

### Org · 인증

| 레거시 `sfdx` (v1) | 현행 `sf` (v2) | 비고 |
|---|---|---|
| `sfdx force:auth:web:login` / `sfdx auth:web:login` | `sf org login web` | |
| `sfdx force:auth:jwt:grant` / `sfdx auth:jwt:grant` | `sf org login jwt` | |
| `sfdx auth:sfdxurl:store` | `sf org login sfdx-url` | |
| `sfdx force:auth:logout` / `sfdx auth:logout` | `sf org logout` | |
| `sfdx force:org:create` (scratch) | `sf org create scratch` | v1은 `-t scratch`가 기본 |
| `sfdx force:org:create` (sandbox) | `sf org create sandbox` | v2에서 object가 분리됨 |
| `sfdx force:org:list` | `sf org list` | |
| `sfdx force:org:open` | `sf org open` | |
| `sfdx force:org:display` | `sf org display` | |
| `sfdx force:org:delete` | `sf org delete scratch` / `sf org delete sandbox` | v2에서 object 분리 |
| `sfdx force:user:permset:assign` | `sf org assign permset` | |
| `sfdx force:user:password:generate` | `sf org generate password` | |
| `sfdx force:limits:api:display` | `sf limits api display` | |

### Apex · 데이터

| 레거시 `sfdx` (v1) | 현행 `sf` (v2) | 비고 |
|---|---|---|
| `sfdx force:apex:execute` | `sf apex run` | |
| `sfdx force:apex:test:run` | `sf apex run test` | |
| `sfdx force:apex:test:report` | `sf apex get test` | |
| `sfdx force:apex:log:list` | `sf apex list log` | |
| `sfdx force:apex:log:get` | `sf apex get log` | |
| `sfdx force:apex:log:tail` | `sf apex tail` | |
| `sfdx force:apex:class:create` | `sf apex generate class` | |
| `sfdx force:apex:trigger:create` | `sf apex generate trigger` | |
| `sfdx force:lightning:component:create` | `sf lightning generate component` | |
| `sfdx force:lightning:app:create` | `sf lightning generate app` | |
| `sfdx force:data:tree:export` / `import` | `sf data export tree` / `sf data import tree` | |
| `sfdx force:data:record:create/get/update/delete` | `sf data create/get/update/delete record` | |
| `sfdx force:data:soql:query` | `sf data query` | |
| `sfdx force:data:bulk:delete` | `sf data delete bulk` | |
| `sfdx force:data:bulk:upsert` | `sf data upsert bulk` | |

### 설정 · 별칭 · 패키지

| 레거시 `sfdx` (v1) | 현행 `sf` (v2) | 비고 |
|---|---|---|
| `sfdx force:config:set` / `list` | `sf config set` / `sf config list` | |
| `sfdx force:alias:set` / `list` | `sf alias set` / `sf alias list` | |
| `sfdx force:package:create` | `sf package create` | |
| `sfdx force:package:version:create` | `sf package version create` | |
| `sfdx force:package:version:promote` | `sf package version promote` | |
| `sfdx force:package:install` | `sf package install` | |

> **일반 규칙:** 대부분 `sfdx force:<topic>:<verb>` → `sf <topic> <verb> [object]`로 콜론이 공백으로 바뀌고 `force:` 접두어가 사라진다. 다만 (1) create/delete류는 v2에서 대상 object(`scratch`/`sandbox`/`source`)가 별도 토큰으로 분리되고, (2) `push`/`pull`/`status` 같은 소스 추적 명령은 `deploy start`/`retrieve start`/`*preview`로 어휘가 바뀌므로 1:1 치환이 아니다. 표기 없는 행은 조합 소스 노트에서 `sf` 형태가 실증됐고 `sfdx` 형태는 표준 매핑이다.

---

## 확인 필요 / 이 노트의 범위 밖

- `sf project convert source`, `sfdx force:mdapi:deploy/retrieve`의 정확한 v2 플래그(예: `--metadata-dir`)는 조합 소스 10개 노트에 command 블록이 없어 표준 매핑으로만 표기했다(⚠️ 표시). 정확 플래그는 각 상세 노트 또는 공식 CLI 레퍼런스에서 확인.
- Change Sets는 **CLI 명령이 아닌 Salesforce UI 절차**이므로 이 카탈로그의 명령 행에 포함하지 않는다 → [[Change Sets 배포]] 참조.
- `sf package` 명령의 세부 옵션·릴리스 흐름은 패키지 전용 노트 소관(위임). 이 노트는 명령 존재와 소관 링크만 제공한다.
- 각 명령의 플래그 전수·출력 예시·워크플로는 표의 상세 노트가 정본이다 — 이 카탈로그에서 재서술하지 않는다.

---

## 관련 노트

- [[Salesforce DX 개요]] — sf CLI 기본 개념·워크플로 진입점
- [[DX 도구 개요와 워크플로 전환]] — DX 전체 워크플로 개요·3가지 시작 경로
- [[DX 프로젝트 구조와 소스 포맷]] — `sf project generate`·`convert`·`config`·`alias` 상세
- [[DX 개발 워크플로]] — `sf apex/lightning/schema/cmdt generate`·`apex run`·`apex test/log` 상세
- [[DX 인증 방식]] — `sf org login web/jwt/sfdx-url`·`org display/logout` 전수
- [[Scratch Org 생성과 정의 파일]] — `sf org create scratch`·정의 파일·Features 전수
- [[Sandbox 관리]] — `sf org create/refresh/resume/delete sandbox` 전수
- [[Source Tracking 변경 추적]] — `sf project deploy/retrieve start/preview`·`org enable/disable tracking` 전수
- [[DX 데이터 작업]] — `sf data` 전 명령(tree·bulk·record·query·search·file) 전수
- [[메타데이터 분해와 forceignore]] — `sf project convert source-behavior`·`project list ignored` 전수
- [[Metadata API 빌드·릴리스 워크플로]] — `sf project deploy validate/quick/cancel/report` 워크플로
- [[Change Sets 배포]] — UI 기반 배포(비-CLI 대안)
- [[Unlocked Package 개발과 버전]] — `sf package create`·`version create` 상세
- [[Unlocked Package 릴리스와 설치]] — `sf package install`·`version promote` 상세
</content>
</invoke>
