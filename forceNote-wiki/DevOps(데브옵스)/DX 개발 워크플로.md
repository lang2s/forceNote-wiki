---
tags: [devops, salesforce-dx, sf-cli, apex, lwc, aura, development, debug, testing]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 11 (p.246–261)
created: 2026-05-22
aliases: [DX 개발 워크플로, Develop Against Any Org, sf apex generate class, sf apex generate trigger, sf lightning generate component, sf schema generate, sf apex run, sf apex run test, Debug Apex, Apex Debug Log, anonymous apex]
---

# DX 개발 워크플로

> Salesforce DX Chapter 11 전수 — 소스 파일 생성(Apex·LWC·Aura·Custom Object), Any Org 배포/검색, Permission Set 할당, Anonymous Apex 실행, Apex 테스트 실행, Debug 로그 조회까지 CLI 명령 전수.

---

## 소스 파일 CLI 생성 — 개요

CLI에서 소스 파일을 추가할 때는 올바른 디렉토리에서 작업해야 한다. 패키지 디렉토리가 `force-app`이면 Apex 클래스는 `force-app/main/default/classes`에 생성한다.

- API v45.0 이상에서 LWC와 Aura 두 프로그래밍 모델을 모두 사용할 수 있다.
- Aura 컴포넌트는 반드시 `aura` 디렉토리에, LWC는 반드시 `lwc` 디렉토리에 위치해야 한다.

### 사용 가능한 generate 명령 전수

```
sf apex generate class
sf apex generate trigger
sf cmdt generate object
sf cmdt generate field
sf cmdt generate record
sf cmdt generate records
sf cmdt generate fromorg
sf lightning generate app
sf lightning generate component
sf lightning generate event
sf lightning generate interface
sf lightning generate test
sf schema generate sobject
sf schema generate field
sf schema generate platformevent
sf schema generate tab
sf static-resource generate
sf visualforce generate component
sf visualforce generate page
```

### 공통 옵션 플래그 (대부분의 generate 명령에 공통)

| 플래그 | 단축 | 설명 |
|---|---|---|
| `--output-dir` | `-d` | 생성된 파일을 저장할 디렉토리. 지정하지 않으면 현재 폴더에 저장. 절대경로 또는 상대경로 모두 가능. 디렉토리가 없으면 CLI가 자동 생성 시도. |
| `--template` | `-t` | 파일 생성에 사용할 템플릿 |

> 팁: 명령에 대한 상세 정보는 `--help` 플래그로 확인한다. 예: `sf apex generate class --help`

---

## 소스 파일 편집

즐겨 쓰는 코드 편집기로 Apex 클래스, VF 페이지·컴포넌트, LWC, Aura 컴포넌트를 직접 편집한다. Setup UI에서 편집 후 `project retrieve start`로 로컬 프로젝트에 변경사항을 가져올 수도 있다.

FlexiPage 파일은 `flexipages` 디렉토리에 저장된다. 기본 브라우저에서 FlexiPage를 열려면:

```bash
# flexipages 디렉토리에서 실행
sf org open --source-file Property_Record_Page.flexipage-meta.xml

# 브라우저를 열지 않고 URL만 생성
sf org open --source-file Property_Record_Page.flexipage-meta.xml --url-only
```

---

## Develop Against Any Org

소스 추적이 활성화된 Scratch Org 또는 Sandbox에서 개발한 후, 최종적으로 비소스추적 Org에서 테스트·검증한다.

Salesforce CLI를 사용하면 소스 추적이 없는 Org에서도 Scratch Org와 동일한 방식으로 메타데이터를 배포/검색할 수 있다.

### 시작 전 준비

```bash
# manifest(package.xml)가 포함된 DX 프로젝트 생성
sf project generate --name mywork --output-dir MyProject --manifest

# 비소스추적 Org 인증 (Sandbox 연결 시 sfdx-project.json의 sfdcLoginUrl을 https://test.salesforce.com으로 설정 후 인증)
```

### 메타데이터 이름에 콤마가 있을 때 인코딩

콤마(`%2C`)로 인코딩해야 올바르게 동작한다.

```bash
# 잘못된 방법 (동작하지 않음)
sf project deploy start --metadata "Profile:Standard User" --metadata "Layout:Page,Console"

# 올바른 방법
sf project deploy start --metadata "Profile:Standard User" --metadata "Layout:Page%2CConsole"
```

### Non-Source-Tracked Org에서 소스 검색 (project retrieve start)

비소스추적 Org(Sandbox, Production)에서 소스를 검색할 때 사용한다.

| 검색 대상 | 명령 예시 |
|---|---|
| manifest에 나열된 모든 컴포넌트 | `sf project retrieve start --manifest path/to/package.xml` |
| 디렉토리의 소스 파일 | `sf project retrieve --source-dir path/to/source` |
| 특정 Apex 클래스 + 객체 디렉토리 | `sf project retrieve --source-dir path/to/apex/classes/MyClass.cls --source-dir path/to/source/objects` |
| 공백이 포함된 메타데이터 | `sf project retrieve start --metadata "Profile:Standard User"` |
| 모든 Apex 클래스 | `sf project retrieve --metadata ApexClass` |
| 특정 Apex 클래스 | `sf project retrieve --metadata ApexClass:MyApexClass` |
| 콤마가 포함된 Layout 이름 | `sf project retrieve --metadata "Layout:Page%2CConsole"` |
| 패키지에 속한 모든 메타데이터 | `sf project retrieve --metadata --package-name DreamHouse` |

스코핑 파라미터는 한 번에 하나만 지정 가능: `--metadata`, `--source-dir`, `--manifest` 중 택 1. `--package-name`을 지정하면 추가로 하나 더 포함 가능.

```bash
sf project retrieve start --package-name DreamHouse --manifest manifest/package.xml
```

### Non-Source-Tracked Org에 소스 배포 (project deploy start)

비소스추적 Org(Sandbox, Production)에 소스를 배포할 때 사용한다.

| 배포 대상 | 명령 예시 |
|---|---|
| manifest에 나열된 모든 컴포넌트 | `sf project deploy start --manifest path/to/package.xml` |
| 디렉토리의 소스 파일 | `sf project deploy start --source-dir path/to/source` |
| 특정 Apex 클래스 + 객체 디렉토리 | `sf project deploy start --source-dir path/to/apex/classes/MyClass.cls --source-dir path/to/source/objects` |
| 모든 Apex 클래스 | `sf project deploy start --metadata ApexClass` |
| 특정 Apex 클래스 | `sf project deploy start --metadata ApexClass:MyApexClass` |
| 모든 Custom Object + Apex 클래스 | `sf project deploy start --metadata CustomObject --metadata ApexClass` |
| Apex 클래스 + 공백 포함 Profile | `sf project deploy start --metadata ApexClass --metadata "Profile:Content Experience Profile"` |
| 검증 완료 컴포넌트 빠른 배포 (Quick Deploy) | `sf project deploy quick --job-id JOBID` |
| 경고가 있어도 배포 | `sf project deploy start --ignore-warnings` |
| 오류가 있어도 배포 (Production 비권장) | `sf project deploy start --ignore-errors` |

> Quick Deploy: `project deploy validate` 명령으로 체크온리 배포를 실행하면 job ID가 반환된다. 테스트 통과·코드 커버리지 충족 후 해당 job ID로 실제 배포.

### Non-Tracked Source 삭제 (project delete source)

소스 추적이 없는 Org(Sandbox 등)에서 컴포넌트를 삭제한다.

| 삭제 대상 | 명령 예시 |
|---|---|
| 디렉토리의 소스 파일 | `sf project delete source --source-dir path/to/source` |
| 특정 컴포넌트 (FlexiPage) | `sf project delete source --metadata FlexiPage:Broker_Record_Page` |
| 공백 포함 컴포넌트 | `sf project delete source --metadata "Profile:Content Experience Profile"` |

### 임시 메타데이터 파일 보존 (SF_MDAPI_TEMP_DIR)

일부 CLI 명령 실행 시 임시 디렉토리에 메타데이터가 생성되었다가 완료 후 삭제된다. 보존하려면 환경 변수를 설정한다.

환경 변수가 적용되는 명령:
- `project deploy start`
- `project retrieve start`
- `project delete source`
- `project convert mdapi|source`
- `org create scratch` (scratch org 설정에 org preferences가 아닌 org settings 포함 시)

```bash
SF_MDAPI_TEMP_DIR=/users/myName/myDXProject/metadata
```

---

## Permission Set 할당

Scratch Org를 생성하고 소스를 배포한 후, 앱에 Custom Object가 포함된 경우 사용자에게 앱 접근 권한을 부여해야 한다.

```bash
# 1. 필요한 경우 Scratch Org에서 Permission Set 생성 (Setup UI에서)
sf org open --target-org <scratch org username/alias>
# Setup > Quick Find "Perm" > Permission Sets > New > 생성 > Apps > Assigned Apps > Edit > 앱 추가

# 2. Permission Set을 Scratch Org에서 프로젝트로 검색
sf project retrieve start --target-org <scratch org username/alias>

# 3. 한 명 이상의 Org 사용자에게 Permission Set 할당
sf org assign permset --name <permset_name> --target-org <username/alias>

# 관리자가 아닌 사용자에게 할당 (--on-behalf-of 플래그 사용)
sf org assign permset --name <permset_name> --target-org <admin-user> --on-behalf-of <non-admin-user>

# Permission Set License 할당 (permset과 동일한 방식으로 동작)
sf org assign permsetlicense --name <permsetlicense_name> --target-org <username/alias>
```

---

## Create Lightning Apps and Aura Components

Salesforce CLI로 로컬 DX 프로젝트에 Lightning App 및 Aura 컴포넌트를 생성한다. 생성된 파일은 패키지 디렉토리 내 `aura` 디렉토리에 위치한다.

```bash
# 1. Aura 디렉토리 준비 (기본 패키지 디렉토리 기준)
# force-app/main/default/aura 디렉토리가 없으면 생성

# 2. Lightning App 생성
sf lightning generate app --name myApp --output-dir force-app/main/default/aura

# 3. Aura 컴포넌트 생성 (--type aura 명시)
sf lightning generate component --type aura --name myAuraComponent --output-dir force-app/main/default/aura

# 4. 새 Lightning App과 Aura 컴포넌트를 Org에 배포
sf project deploy start --metadata AuraDefinitionBundle:myApp --metadata AuraDefinitionBundle:myAuraComponent
```

---

## Create Lightning Web Components (LWC)

Salesforce CLI로 로컬 DX 프로젝트에 LWC를 생성한다. 생성된 파일은 패키지 디렉토리 내 `lwc` 디렉토리에 위치한다.

> Local Dev 경험을 사용하면 배포 없이 실시간으로 LWC를 미리 볼 수 있다.

```bash
# 1. lwc 디렉토리 준비
# force-app/main/default/lwc 디렉토리가 없으면 생성

# 2. LWC 생성 (--type lwc 명시)
sf lightning generate component --type lwc --name myLightningWebComponent --output-dir force-app/main/default/lwc

# 3. 새 LWC를 Org에 배포
sf project deploy start --metadata LightningComponentBundle:myLightningWebComponent
```

### lightning generate component 타입 비교

| 옵션 | 타입 | 생성 위치 | 배포 메타데이터 타입 |
|---|---|---|---|
| `--type aura` | Aura 컴포넌트 | `aura/` 디렉토리 | `AuraDefinitionBundle` |
| `--type lwc` | Lightning Web Component | `lwc/` 디렉토리 | `LightningComponentBundle` |

---

## Create an Apex Class

Salesforce CLI로 로컬 DX 프로젝트에 Apex 클래스를 생성한다. 생성된 파일은 패키지 디렉토리 내 `classes` 디렉토리에 위치한다.

```bash
# 1. classes 디렉토리 준비
# force-app/main/default/classes 디렉토리가 없으면 생성

# 2. 기본 Apex 클래스 생성
sf apex generate class --name myClass --output-dir force-app/main/default/classes
```

생성되는 파일:
- `myClass.cls-meta.xml` — 메타데이터 파일
- `myClass.cls` — Apex 소스 파일

### --template 옵션 전수

| 템플릿 | 설명 | Apex Developer Guide 참조 |
|---|---|---|
| `DefaultApexClass` (기본값) | 표준 Apex 클래스 | Classes |
| `ApexException` | Apex 내장 예외 또는 커스텀 예외. 모든 예외는 공통 메서드를 보유 | Exception Class and Built-in Exceptions |
| `ApexUnitTest` | `@isTest` 어노테이션으로 테스트 전용 클래스·메서드 정의 | isTest Annotation |
| `InboundEmailService` | 이메일 서비스: 수신 이메일의 내용·헤더·첨부파일 처리 | Apex Email Service |

```bash
# ApexException 템플릿으로 생성
sf apex generate class --name myException --template ApexException --output-dir force-app/main/default/classes

# 새 Apex 클래스를 Org에 배포
sf project deploy start --metadata ApexClass:myClass
```

---

## Create an Apex Trigger

Salesforce CLI로 로컬 DX 프로젝트에 Apex Trigger를 생성한다. 생성된 파일은 패키지 디렉토리 내 `triggers` 디렉토리에 위치한다.

```bash
# 1. triggers 디렉토리 준비
# force-app/main/default/triggers 디렉토리가 없으면 생성

# 2. 기본 Trigger 생성 (기본: before insert, 대상 sObject: 일반 sObject)
sf apex generate trigger --name myTrigger --output-dir force-app/main/default/triggers

# 3. --event와 --sobject 플래그로 기본값 변경 (before·after insert on Account)
sf apex generate trigger --name myTrigger --event 'before insert,after insert' --sobject Account --output-dir force-app/main/default/triggers
```

### apex generate trigger 플래그

| 플래그 | 설명 | 기본값 |
|---|---|---|
| `--name` | Trigger 이름 | (필수) |
| `--output-dir` / `-d` | 생성 파일 저장 디렉토리 | 현재 폴더 |
| `--event` | Trigger 발생 이벤트 (콤마 구분 목록) | `before insert` |
| `--sobject` | Trigger 대상 sObject | 일반 sObject |
| `--template` / `-t` | 파일 생성 템플릿 | — |

생성되는 파일:
- `myTrigger.trigger-meta.xml` — 메타데이터 파일
- `myTrigger.trigger` — Apex Trigger 소스 파일

```bash
# 새 Apex Trigger를 Org에 배포
sf project deploy start --metadata ApexTrigger:myTrigger --target-org myscratch
```

---

## Create a Custom Object

Salesforce CLI로 새 Custom Object의 메타데이터 파일을 대화형으로 생성한다.

```bash
# 1. sf schema generate sobject 대화형 명령 실행
#    --label 플래그로 새 Custom Object의 레이블을 지정 (API 이름·Plural Label 등을 자동 제안)
sf schema generate sobject --label "New Object"

# 2. 질문 응답 (파일 위치, 객체 속성 활성화 여부 등)

# 3. Custom Object를 Org에 배포
sf project deploy start --metadata CustomObject:NewObject__c --target-org myscratch
```

> Custom Object를 소스추적 Org에 처음 배포하면 Org가 추가 속성을 설정하고 새 기본값을 적용한다. 배포 직후 즉시 retrieve하여 로컬 소스 파일을 업데이트하는 것을 권장한다.

Custom Object 생성 후 추가 작업:

```bash
# Custom Object에 Custom Field 추가 (대화형)
sf schema generate field
# 표준 Object(예: Account)에도 Custom Field 생성 가능

# Custom Object용 Custom Tab 생성
sf schema generate tab
```

---

## Execute Anonymous Apex

`sf apex run` 명령으로 인증된 Org에서 익명 Apex 코드 블록을 실행한다.

### 인터랙티브 모드 (플래그 없이 실행)

```bash
sf apex run --target-org myscratch
```

실행 예시 (대화형 셸에서 `system.debug('Hello world!');` 입력 후 CTRL+D):

```
Start typing Apex code. Press the Enter key after each line, then press CTRL+D when finished.
system.debug ('Hello world!');
Compiled successfully.
Executed successfully.
58.0 APEX_CODE,DEBUG;APEX_PROFILING,INFO
Execute Anonymous: system.debug ('Hello world!');
14:23:06.174 (174742273)|USER_INFO|[EXTERNAL]|0058H000005QWcE|test-ux9lpg9jyyqt@example.com|(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)|GMT-07:00
14:23:06.174 (174785450)|EXECUTION_STARTED
14:23:06.174 (174792639)|CODE_UNIT_STARTED|[EXTERNAL]|execute_anonymous_apex
14:23:06.174 (175417814)|USER_DEBUG|[1]|DEBUG|Hello world!
14:23:06.175 (175529797)|CUMULATIVE_LIMIT_USAGE
...
14:23:06.175 (175529797)|CUMULATIVE_LIMIT_USAGE_END
14:23:06.174 (175598235)|CODE_UNIT_FINISHED|execute_anonymous_apex
14:23:06.174 (175617689)|EXECUTION_FINISHED
```

### 파일 실행 모드

```bash
# --file 플래그로 Apex 코드 파일 실행
sf apex run --file ~/test.apex
```

### Limit 사용량 출력 예시 (익명 Apex 실행 후)

```
Number of SOQL queries: 0 out of 100
Number of query rows: 0 out of 50000
Number of SOSL queries: 0 out of 20
Number of DML statements: 0 out of 150
Number of Publish Immediate DML: 0 out of 150
Number of DML rows: 0 out of 10000
Maximum CPU time: 0 out of 10000
Maximum heap size: 0 out of 6000000
Number of callouts: 0 out of 100
Number of Email Invocations: 0 out of 10
Number of future calls: 0 out of 50
Number of queueable jobs added to the queue: 0 out of 50
Number of Mobile Apex push calls: 0 out of 10
```

---

## Run Apex Tests

Salesforce CLI를 통해 Org에서 Apex 테스트를 실행한다. VS Code Salesforce Extensions 또는 Jenkins·CircleCI 같은 CI 도구에서도 실행 가능하다.

### 최소 사용자 권한 및 설정

테스트 실행 사용자는 다음 권한이 필요하다:
- View Setup and Configuration
- API Enabled

또한 Org UI에서 **Enable Streaming API** 설정이 활성화되어 있어야 한다 (기본 활성화).

### 기본 실행 (비동기, 기본 동작)

```bash
# 모든 Apex 테스트를 비동기로 실행
sf apex run test --target-org myscratch
```

명령 실행 후 job ID와 함께 결과 조회 명령이 출력된다:

```bash
# job ID로 전체 결과 조회
sf apex get test --test-run-id 7078HzRMVV --target-org myscratch
```

### 주요 플래그

```bash
# --result-format: 출력 형식 지정 (human | tap | junit | json)
sf apex run test --result-format human --wait 1

# --wait: 비동기 테스트가 완료될 때까지 대기할 분 수
#   대기 시간 내 완료되면 결과 표시, 초과하면 job ID 명령 출력

# --code-coverage: 코드 커버리지 정보 포함
sf apex run test --code-coverage --target-org myscratch

# --output-dir: 결과 파일 저장 디렉토리
sf apex run test --output-dir test-results --target-org myscratch
```

> 모든 플래그 확인: `sf apex run test --help` 및 `sf apex get test --help`

### 대규모 코드 커버리지 확인

Production Org 배포 또는 AppExchange 관리 패키지 포함 전 Apex 클래스·트리거의 코드 커버리지가 **75% 이상**이어야 한다.

커버리지 확인 방법:
- **Salesforce CLI**: `apex run test` 명령의 `--code-coverage` 플래그 사용
- **VS Code**: `retrieve-test-code-coverage` 설정 확인

#### Store Only Aggregate Code Coverage 설정

Setup > Apex Test Execution > Options... 에서 접근.

| 설정 상태 | 동작 |
|---|---|
| 체크 (활성) | 대규모 Org 성능 향상 — per-class 커버리지 비활성화. Apex Code Coverage by Class 테이블에 현재 테스트 실행과 관계없이 `ApexCodeCoverageAggregate`의 모든 Apex 클래스·트리거 표시. 커버되지 않는 클래스 드릴다운 가능. |
| 미체크 (비활성) | 소수 테스트 실행 시 스크롤 최소화. Apex Code Coverage by Class 테이블에 현재 실행된 테스트 메서드가 직접 건드린 클래스만 표시. |

**사용 패턴 예시:** 야간 빌드(설정 체크)에서 Class032의 커버리지가 57%임을 발견 → 설정 미체크 후 Class032만 테스트 실행 → 해당 클래스 커버리지 정보만 확인 → 단위 테스트 보강.

---

## Debug Apex

VS Code용 Salesforce Extensions를 사용하면 Apex 클래스에 중단점을 설정하고 실행을 단계별로 추적할 수 있다.

### Apex Replay Debugger

추가 라이선스 없이 사용 가능. VS Code에서 `Apex Replay Debugger` 확장을 설치하면 된다.

### Apex Interactive Debugger

Dev Hub Org에 Apex Debugger 세션이 하나 이상 필요하다.

| 에디션 | Apex Debugger 세션 |
|---|---|
| Performance Edition | 1개 포함 |
| Unlimited Edition | 1개 포함 |
| Trial Edition | 사용 불가 |
| Developer Edition | 사용 불가 |
| Enterprise Edition | 구매 가능 |

Scratch Org에서 Apex Debugger를 활성화하려면 Scratch Org 정의 파일에 `DebugApex` feature를 추가한다:

```json
"features": "DebugApex"
```

### ISV Customer Debugger (VS Code 전용)

Apex Interactive Debugger(`salesforcedx-vscode-apex-debugger`) 익스텐션에 포함되어 있으므로 별도 설치 불필요. **Sandbox Org만** 디버그 가능.

---

## Generate and View Apex Debug Logs

Apex debug log는 트랜잭션 실행 또는 단위 테스트 실행 중 발생하는 DB 작업·시스템 프로세스·오류를 인증된 Org에서 기록한다.

### 단계별 절차

```bash
# 1. VS Code Salesforce Extensions에서 Org 로그인 및 설정
#    - Replay Debugger: "SFDX: Turn on Apex Debug Log for Replay Debugger" 실행
#    - Launch configuration 파일 생성 (Replay Debugger 또는 Interactive Debugger용)

# 2. 테스트 실행 후 debug log 목록 조회
sf apex list log --target-org myscratch
```

`sf apex list log` 출력 예시:

```
APPLICATION  DURATION (MS)  ID         LOCATION  SIZE (B)  LOG USER  OPERATION        REQUEST              START TIME          STATUS
──────────── ───────────── ───────     ───────── ────────  ────────  ──────────────── ────────────────────  ──────────────────  ──────
Unknown      1143           07L9Axx    SystemLog 23900     User      User              ApexTestHandler Api   2017-09-05x         Success
```

```bash
# 3. log ID를 apex get log 명령에 전달하여 특정 debug log 조회
sf apex get log --log-id 07L9A000000aBYGUA2
```

`sf apex get log` 출력 예시:

```
38.0
APEX_CODE,FINEST;APEX_PROFILING,INFO;CALLOUT,INFO;DB,INFO;SYSTEM,DEBUG;VALIDATION,INFO;VISUALFORCE,INFO;WAVE,INFO;WORKFLOW,INFO
15:58:57.3 (3717091)|USER_INFO|[EXTERNAL]|0059A000000TwPM|test-ktjauhgzinnp@example.com|Pacific Standard Time|GMT-07:00
15:58:57.3 (3888677)|EXECUTION_STARTED
15:58:57.3 (3924515)|CODE_UNIT_STARTED|[EXTERNAL]|01p9A000000FmMN|RejectDuplicateFavoriteTest.acceptNonDuplicate()
15:58:57.3 (5372873)|HEAP_ALLOCATE|[72]|Bytes:3
...
```

### Debug Log의 Log Category와 Log Level

Debug Log 헤더 라인(예: `APEX_CODE,FINEST;APEX_PROFILING,INFO;...`)에서 각 카테고리의 로그 레벨을 확인할 수 있다.

소스에서 확인된 Log Category 전수:

| Log Category | 설명 |
|---|---|
| `APEX_CODE` | Apex 코드 실행 관련 로그 |
| `APEX_PROFILING` | Apex 프로파일링 정보 |
| `CALLOUT` | 외부 호출(Callout) 정보 |
| `DB` | 데이터베이스 작업 |
| `SYSTEM` | 시스템 프로세스 |
| `VALIDATION` | 유효성 검사 규칙 |
| `VISUALFORCE` | Visualforce 페이지 렌더링 |
| `WAVE` | Einstein Analytics (Wave) |
| `WORKFLOW` | Workflow 규칙 |

Log Level 값 (낮음 → 높음 순):

| 레벨 | 설명 |
|---|---|
| `NONE` | 로그 없음 |
| `ERROR` | 오류만 |
| `WARN` | 경고 이상 |
| `INFO` | 정보 이상 |
| `DEBUG` | 디버그 이상 |
| `FINE` | 상세 정보 이상 |
| `FINER` | 더 상세한 정보 이상 |
| `FINEST` | 가장 상세한 정보 |

---

## 관련 노트

- [[Salesforce DX 개요]] — sf CLI 기본 명령, Source Format, .forceignore, JWT 인증 개요
- [[DX 프로젝트 구조와 소스 포맷]] — DX 프로젝트 생성·디렉토리 구조·소스 포맷·정적 리소스·기존 소스 마이그레이션 전수
- [[DX 인증 방식]] — org login web·JWT Flow·External Client App·Connected App·SFDX Auth URL·Logout 전수
- [[Scratch Org 패턴]] — Scratch Org 생성·관리
- [[CI CD 패턴]] — Jenkins, CircleCI에서 `sf apex run test` 자동화
- [[DX 도구 개요와 워크플로 전환]] — DX 전체 워크플로 개요·3가지 시작 경로
- [[DX MCP Server (Beta)]] — LLM으로 DX 작업 자동화 (deploy_metadata, run_apex_test 등)
