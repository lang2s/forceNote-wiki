---
tags: [devops, salesforce-dx, ci-cd, circleci, jenkins, travis-ci, jenkinsfile, jwt, continuous-integration]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [CircleCI, Jenkins, Travis CI, Jenkinsfile, CI integration, 지속적 통합, 연속 통합, CI 자동화, 젠킨스파일]
---

# CI 통합 전수 (CircleCI·Jenkins·Travis)

> Salesforce DX와 CircleCI·Jenkins·Travis CI 통합 전수 — 환경 설정, 서버 키 암호화, Dev Hub 연결, Jenkins 환경변수, Jenkinsfile 전체 코드, Sample CI 레포 전수 표

---

## Continuous Integration 개요

CI(Continuous Integration)는 개발자가 정기적으로 소스 코드 리포지토리에 코드를 통합하는 소프트웨어 개발 방식이다. 새 코드가 버그를 도입하지 않도록 개발자가 코드를 체크인하기 전후에 자동 빌드와 테스트가 실행된다.

Salesforce DX는 다양한 서드파티 CI 도구와 쉽게 통합된다.

---

## Continuous Integration Using CircleCI

CircleCI는 기존 VCS(버전 컨트롤 시스템)와 통합하여 지정한 환경에 증분 업데이트를 푸시하는 통합 도구다. 클라우드 기반 또는 온프레미스로 사용 가능하다. 아래 지침은 GitHub + CircleCI + Dev Hub Org 조합을 설명한다.

### Configure Your Environment for CircleCI

1. GitHub 리포지토리를 CircleCI에 설정한다 (CircleCI 웹사이트에서 가입·연동).
2. Salesforce CLI를 설치한다.
3. Dev Hub Org에 대해 JWT Flow 인증을 설정한다 (미설정 시 먼저 수행).
4. 서버 키를 암호화한다.

   a. `server.key` 파일이 있는 디렉토리에서 암호화 키와 IV(initialization vector) 생성:
   ```bash
   openssl enc -aes-256-cbc -k <passphrase> -P -md sha1 -nosalt
   ```
   출력 예시:
   ```
   key=****24B2
   iv =****DA58
   ```

   b. key와 iv 값을 기록해 둔다 (나중에 필요).

   c. 생성된 key와 iv로 `server.key` 파일 암호화:
   ```bash
   openssl enc -nosalt -aes-256-cbc -in server.key -out server.key.enc -base64 -K <key> -iv <iv>
   ```

   - key/iv는 단 1회만 사용. 동일 쌍으로 다른 것을 암호화하면 보안 위반
   - 매번 새 key/iv가 생성됨 — 분실 시 재생성 필요

   d. CircleCI UI에서 key, iv, `server.key.enc` 내용을 보호된 환경 변수로 저장한다.

### Connect CircleCI to Your Dev Hub

1. Salesforce CLI 설치 확인: `sf version`

2. `server.key` 파일이 있는 디렉토리에서 JWT 인증 테스트:
   ```bash
   sf org login jwt \
     --client-id <your_consumer_key> \
     --jwt-key-file server.key \
     --username <your_username> \
     --set-default-dev-hub
   ```

3. GitHub 계정으로 sfdx-circleci 레포 Fork.

4. 로컬에 클론:
   ```bash
   git clone https://github.com/<git_username>/sfdx-circleci.git
   ```

5. Setup → App Manager → Connected App에서 Consumer Key 조회.

6. CircleCI UI의 프로젝트 설정에서 환경변수 저장:

   | 환경변수명 | 값 |
   |---|---|
   | `HUB_CONSUMER_KEY` | Connected App의 Consumer Key |
   | `HUB_SFDX_USER` | Dev Hub 접근에 사용하는 사용자명 |
   | `DECRYPTION_KEY` | 암호화 시 생성한 key 값 |
   | `DECRYPTION_IV` | 암호화 시 생성한 iv 값 |

7. `server.key.enc` 파일을 리포지토리에 커밋.
8. `rm server.key`로 원본 키 파일 삭제 — **공개 장소에 키 또는 인증서 저장 금지**.

설정 완료 후 변경사항을 커밋·푸시하면 CircleCI 빌드가 자동으로 시작된다.

---

## Continuous Integration Using Jenkins

Jenkins는 CI·CD 구현을 위한 오픈소스 확장형 자동화 서버다. Salesforce DX와 Jenkins를 통합하여 Scratch Org 대상 Salesforce 애플리케이션 테스트를 자동화한다.

전제 조건:
- Jenkins 동작 방식 숙지 (특히 Jenkins Multibranch Pipeline)
- Jenkins 서버 컴퓨터가 VCS 리포지토리에 접근 가능

### Configure Your Environment for Jenkins

1. Dev Hub Org에서 JWT 기반 인증을 위한 Connected App 생성.
   - Consumer Key (= Client ID)와 Private Key 파일 보관

2. Jenkins 서버 컴퓨터에서:

   a. Salesforce CLI 다운로드·설치

   b. Private Key 파일을 Jenkins Secret File로 저장 (Jenkins Admin Credentials 인터페이스 사용), 생성된 ID 기록

   c. Jenkins 환경에 아래 변수 설정:

   | 변수명 | 설명 |
   |---|---|
   | `SF_USERNAME` | Dev Hub Org 사용자명 (예: juliet.capulet@myenvhub.com) |
   | `SF_INSTANCE_URL` | Dev Hub Org 인스턴스 URL (기본: https://login.salesforce.com, My Domain URL 권장) |
   | `SF_CONSUMER_KEY` | Connected App 생성 후 반환된 Consumer Key |
   | `SERVER_KEY_CREDENTALS_ID` | Jenkins Admin Credentials에 저장한 Private Key 파일의 Credentials ID |
   | `PACKAGE_NAME` | 패키지 이름 (예: My Package) |
   | `PACKAGE_VERSION` | 패키지 버전 (04t로 시작) |
   | `TEST_LEVEL` | 테스트 레벨 (예: RunLocalTests) |
   | `SF_AUTOUPDATE_DISABLE` | (선택) true로 설정 시 CLI 자동 업데이트 비활성화 (Jenkins 작업 실행 방해 방지) |

3. Scratch Org 생성 가능한 Salesforce DX 프로젝트 설정

4. (선택) Jenkins Custom Tools Plugin 설치 → `/usr/local/bin` 디렉토리를 참조하는 `toolbelt` Custom Tool 생성

---

## Jenkinsfile Walkthrough

`sfdx-jenkins-package` Jenkinsfile 기반 설명. Jenkins Multibranch Pipeline 사용.

### Define Variables

```groovy
def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
def TEST_LEVEL='RunLocalTests'
def PACKAGE_NAME='0Ho1U000000CaUzSAK'
def PACKAGE_VERSION
def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://MyDomainName.my.salesforce.com"
def SF_USERNAME
def toolbelt = tool 'toolbelt'
// 이후 ${toolbelt}/sf 형태로 CLI 실행
```

### Check Out the Source Code

```groovy
stage('checkout source') {
  checkout scm
}
```

### Wrap All Stages in withCredentials

JWT Private Key 파일을 Jenkins Secret File로 저장했으므로 `withCredentials`로 접근한다. 모든 Stage를 이 블록 안에 넣는다.

```groovy
withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')])
// 모든 stage는 여기에
}
```

- `withCredentials`는 JWT 키 파일을 Jenkins workspace의 임시 위치에 저장하고, 위치를 `server_key_file` 변수에 저장

### Wrap All Stages in withEnv

여러 Jenkins 작업이 동일 Dev Hub 사용자로 실행될 때 인증 파일 충돌을 방지하기 위해 홈 디렉토리를 workspace로 설정한다.

```groovy
withEnv(["HOME=${env.WORKSPACE}"]) {
  // 모든 stage는 여기에
}
```

- 작업마다 고유한 인증 파일 생성 → 보안 강화
- Pipeline 외부에서 실행 시: `export HOME=$WORKSPACE`

### Authorize Your Dev Hub Org and Create a Scratch Org

```groovy
// Dev Hub Org JWT 인증
stage('Authorize DevHub') {
  rc = command "${toolbelt}/sf org login jwt --instance-url ${SF_INSTANCE_URL} \
    --client-id ${SF_CONSUMER_KEY} --username ${SF_USERNAME} \
    --jwt-key-file ${server_key_file} --set-default-dev-hub --alias HubOrg"
  if (rc != 0) {
    error 'Salesforce dev hub org authorization failed.'
  }
}

// Scratch Org 생성
stage('Create Test Scratch Org') {
  rc = command "${toolbelt}/sf org create scratch --target-dev-hub HubOrg \
    --set-default --definition-file config/project-scratch-def.json \
    --alias ciorg --wait 10 --duration-days 1"
  if (rc != 0) {
    error 'Salesforce test scratch org creation failed.'
  }
}
```

- `org login jwt`는 Jenkinsfile에 포함하여 매 Jenkins 작업마다 인증 권장
- `org create scratch`의 JSON 출력에서 Groovy 코드가 자동 생성된 사용자명을 추출하여 `SF_USERNAME` 변수에 저장

### Push Source and Assign a Permission Set

```groovy
stage('Push To Test Scratch Org') {
  rc = command "${toolbelt}/sf project deploy start --target-org ciorg"
  if (rc != 0) {
    error 'Salesforce push to test scratch org failed.'
  }
}
```

- `project deploy start`는 프로젝트의 모든 Salesforce 관련 파일 배포
- `.forceignore` 파일로 제외할 파일 지정 가능

### Run Apex Tests

```groovy
stage('Run Tests In Test Scratch Org') {
  rc = command "${toolbelt}/sf apex run test --target-org ciorg --wait 10 \
    --result-format tap --code-coverage --test-level ${TEST_LEVEL}"
  if (rc != 0) {
    error 'Salesforce unit test run in test scratch org failed.'
  }
}
```

주요 플래그:
- `--test-level ${TEST_LEVEL}`: 설치된 Managed Package 제외 모든 테스트 실행 (RunLocalTests / RunSpecifiedTests / RunAllTestsInOrg)
- `--result-format tap`: TAP(Test Anything Protocol) 형식 출력 (파일 출력은 JUnit·JSON 형식)
- `--code-coverage`: 코드 커버리지 계산

### Delete the Scratch Org

```groovy
stage('Delete Package Install Scratch Org') {
  rc = command "${toolbelt}/sf org delete scratch --target-org installorg --no-prompt"
  if (rc != 0) {
    error 'Salesforce package install scratch org deletion failed.'
  }
}
```

### Create a Package Version

```groovy
stage('Create Package Version') {
  if (isUnix()) {
    output = sh returnStdout: true, script: "${toolbelt}/sf package version create \
      --package ${PACKAGE_NAME} --installation-key-bypass --wait 10 --json --target-dev-hub HubOrg"
  } else {
    output = bat(returnStdout: true, script: "${toolbelt}/sf package version create \
      --package ${PACKAGE_NAME} --installation-key-bypass --wait 10 --json --target-dev-hub HubOrg").trim()
    output = output.readLines().drop(1).join(" ")
  }
  // 패키지 복제를 위해 5분 대기
  sleep 300
  def jsonSlurper = new JsonSlurperClassic()
  def response = jsonSlurper.parseText(output)
  PACKAGE_VERSION = response.result.SubscriberPackageVersionId
  response = null
  echo ${PACKAGE_VERSION}
}
```

### Create a Scratch Org and Display Info

```groovy
// 패키지 설치용 Scratch Org 생성
stage('Create Package Install Scratch Org') {
  rc = command "${toolbelt}/sf org create scratch --target-dev-hub HubOrg \
    --set-default --definition-file config/project-scratch-def.json \
    --alias installorg --wait 10 --duration-days 1"
  if (rc != 0) {
    error 'Salesforce package install scratch org creation failed.'
  }
}

// Scratch Org 정보 표시
stage('Display Install Scratch Org') {
  rc = command "${toolbelt}/sf org display --target-org installorg"
  if (rc != 0) {
    error 'Salesforce install scratch org display failed.'
  }
}
```

### Install Package, Run Unit Tests, and Delete Scratch Org

```groovy
// 패키지 설치
stage('Install Package In Scratch Org') {
  rc = command "${toolbelt}/sf package install --package ${PACKAGE_VERSION} \
    --target-org installorg --wait 10"
  if (rc != 0) {
    error 'Salesforce package install failed.'
  }
}

// 테스트 실행
stage('Run Tests In Package Install Scratch Org') {
  rc = command "${toolbelt}/sf apex run test --target-org installorg \
    --result-format tap --code-coverage --test-level ${TEST_LEVEL} --wait 10"
  if (rc != 0) {
    error 'Salesforce unit test run in pacakge install scratch org failed.'
  }
}

// Scratch Org 삭제
stage('Delete Package Install Scratch Org') {
  rc = command "${toolbelt}/sf org delete scratch --target-org installorg --no-prompt"
  if (rc != 0) {
    error 'Salesforce package install scratch org deletion failed.'
  }
}
```

---

## Sample Jenkinsfile (완전한 코드)

```groovy
#!groovy
import groovy.json.JsonSlurperClassic

node {
  def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
  def SF_USERNAME=env.SF_USERNAME
  def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
  def TEST_LEVEL='RunLocalTests'
  def PACKAGE_NAME='0Ho1U000000CaUzSAK'
  def PACKAGE_VERSION
  def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"
  def toolbelt = tool 'toolbelt'

  // 소스 코드 체크아웃
  stage('checkout source') {
    checkout scm
  }

  withEnv(["HOME=${env.WORKSPACE}"]) {
    withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')]) {

      // Dev Hub Org JWT 인증
      stage('Authorize DevHub') {
        rc = command "${toolbelt}/sf org login jwt --instance-url ${SF_INSTANCE_URL} \
          --client-id ${SF_CONSUMER_KEY} --username ${SF_USERNAME} \
          --jwt-key-file ${server_key_file} --set-default-dev-hub --alias HubOrg"
        if (rc != 0) { error 'Salesforce dev hub org authorization failed.' }
      }

      // 테스트용 Scratch Org 생성
      stage('Create Test Scratch Org') {
        rc = command "${toolbelt}/sf org create scratch --target-dev-hub HubOrg \
          --set-default --definition-file config/project-scratch-def.json \
          --alias ciorg --wait 10 --duration-days 1"
        if (rc != 0) { error 'Salesforce test scratch org creation failed.' }
      }

      // Scratch Org 정보 표시
      stage('Display Test Scratch Org') {
        rc = command "${toolbelt}/sf org display --target-org ciorg"
        if (rc != 0) { error 'Salesforce test scratch org display failed.' }
      }

      // 소스 배포
      stage('Push To Test Scratch Org') {
        rc = command "${toolbelt}/sf project deploy start --target-org ciorg"
        if (rc != 0) { error 'Salesforce push to test scratch org failed.' }
      }

      // Apex 테스트 실행
      stage('Run Tests In Test Scratch Org') {
        rc = command "${toolbelt}/sf apex run test --target-org ciorg --wait 10 \
          --result-format tap --code-coverage --test-level ${TEST_LEVEL}"
        if (rc != 0) { error 'Salesforce unit test run in test scratch org failed.' }
      }

      // 테스트용 Scratch Org 삭제
      stage('Delete Test Scratch Org') {
        rc = command "${toolbelt}/sf org delete scratch --target-org installorg --no-prompt"
        if (rc != 0) { error 'Salesforce test scratch org deletion failed.' }
      }

      // 패키지 버전 생성
      stage('Create Package Version') {
        if (isUnix()) {
          output = sh returnStdout: true, script: "${toolbelt}/sf package version create \
            --package ${PACKAGE_NAME} --installation-key-bypass --wait 10 --json --target-dev-hub HubOrg"
        } else {
          output = bat(returnStdout: true, script: "${toolbelt}/sf package version create \
            --package ${PACKAGE_NAME} --installation-key-bypass --wait 10 --json --target-dev-hub HubOrg").trim()
          output = output.readLines().drop(1).join(" ")
        }
        sleep 300  // 패키지 복제 대기 5분
        def jsonSlurper = new JsonSlurperClassic()
        def response = jsonSlurper.parseText(output)
        PACKAGE_VERSION = response.result.SubscriberPackageVersionId
        response = null
        echo ${PACKAGE_VERSION}
      }

      // 패키지 설치용 Scratch Org 생성
      stage('Create Package Install Scratch Org') {
        rc = command "${toolbelt}/sf org create scratch --target-dev-hub HubOrg \
          --set-default --definition-file config/project-scratch-def.json \
          --alias installorg --wait 10 --duration-days 1"
        if (rc != 0) { error 'Salesforce package install scratch org creation failed.' }
      }

      // Scratch Org 정보 표시
      stage('Display Install Scratch Org') {
        rc = command "${toolbelt}/sf org display --target-org installorg"
        if (rc != 0) { error 'Salesforce install scratch org display failed.' }
      }

      // 패키지 설치
      stage('Install Package In Scratch Org') {
        rc = command "${toolbelt}/sf package install --package ${PACKAGE_VERSION} \
          --target-org installorg --wait 10"
        if (rc != 0) { error 'Salesforce package install failed.' }
      }

      // 패키지 설치 Scratch Org에서 테스트 실행
      stage('Run Tests In Package Install Scratch Org') {
        rc = command "${toolbelt}/sf apex run test --target-org installorg \
          --result-format tap --code-coverage --test-level ${TEST_LEVEL} --wait 10"
        if (rc != 0) { error 'Salesforce unit test run in pacakge install scratch org failed.' }
      }

      // 패키지 설치 Scratch Org 삭제
      stage('Delete Package Install Scratch Org') {
        rc = command "${toolbelt}/sf org delete scratch --target-org installorg --no-prompt"
        if (rc != 0) { error 'Salesforce package install scratch org deletion failed.' }
      }
    }
  }
}

def command(script) {
  if (isUnix()) {
    return sh(returnStatus: true, script: script);
  } else {
    return bat(returnStatus: true, script: script);
  }
}
```

---

## Continuous Integration with Travis CI

Travis CI는 GitHub에 호스팅된 소프트웨어 프로젝트의 빌드·테스트를 위한 클라우드 기반 CI 서비스다.

Travis CI 설정 참고:
- Org Development Model: `sfdx-travisci` sample GitHub repo
- Package Development Model: Travis CI 패키지 개발 모델 sample repo

---

## Sample CI Repos for Org Development Model

Org Development Model(CLI + VCS + Sandbox 기반)을 지원하는 Sample CI 레포:

| Vendor | GitHub Repository |
|---|---|
| AppVeyor | https://github.com/forcedotcom/sfdx-appveyor-org |
| Bamboo | https://github.com/forcedotcom/sfdx-bamboo-org |
| Bitbucket | https://github.com/forcedotcom/sfdx-bitbucket-org |
| CircleCI | https://github.com/forcedotcom/sfdx-circleci-org |
| GitLab | https://github.com/forcedotcom/sfdx-gitlab-org |
| Jenkins | https://github.com/forcedotcom/sfdx-jenkins-org |
| TravisCI | https://github.com/forcedotcom/sfdx-travisci-org |

각 레포에 샘플 설정 파일과 단계별 README.md가 포함되어 있다.

---

## Sample CI Repos for Package Development Model

Package Development Model(CLI + VCS + Scratch Org 개발 + Sandbox 테스트·스테이징)을 지원하는 Sample CI 레포:

| Vendor | GitHub Repository |
|---|---|
| AppVeyor | https://github.com/forcedotcom/sfdx-appveyor-package |
| Bamboo | https://github.com/forcedotcom/sfdx-bamboo-package |
| Bitbucket | https://github.com/forcedotcom/sfdx-bitbucket-package |
| CircleCI | https://github.com/forcedotcom/sfdx-circleci-package |
| GitLab | https://github.com/forcedotcom/sfdx-gitlab-package (+ CI/CD template: https://gitlab.com/sfdx/sfdx-cicd-template) |
| Jenkins | https://github.com/forcedotcom/sfdx-jenkins-package |
| TravisCI | https://github.com/forcedotcom/sfdx-travisci-package |

---

## 관련 노트

- [[Salesforce DX 개요]]
- [[DX 인증 방식]]
- [[Unlocked Package 개발과 버전]]
- [[Unlocked Package 릴리스와 설치]]
- [[CI CD 패턴]]
- [[Scratch Org 생성과 정의 파일]]
