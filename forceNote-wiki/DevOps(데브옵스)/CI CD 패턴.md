---
tags: [devops, ci-cd, jenkins, circleci, github-actions, jwt, automation]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 14
created: 2026-05-18
aliases: [CI/CD, 지속적 통합, Jenkinsfile, CircleCI, JWT 인증, 자동화]
---

# CI/CD 패턴

> JWT 인증 + Scratch Org + sf CLI로 Salesforce 배포 파이프라인 자동화.

---

## CI/CD 공통 원칙

```
1. 브라우저 인증(대화형)은 CI에서 불가 → JWT 인증 사용
2. CI 서버에 Connected App 생성 + 개인 키(server.key) 저장
3. scratch org를 1-day 단기로 생성 → 테스트 → 삭제
4. 패키지 버전 ID(04t...)를 아티팩트로 취급
```

---

## JWT 인증 설정 (공통)

### 1. Connected App 생성

Setup → App Manager → New Connected App
- OAuth 활성화
- `Use digital signatures` 체크 → 인증서 업로드
- 범위: `api`, `refresh_token`, `web`

### 2. 개인 키 + 인증서 생성

```bash
openssl genrsa -out server.key 2048
openssl req -new -x509 -nodes \
  -key server.key \
  -out server.crt \
  -days 365
# server.crt → Connected App에 업로드
# server.key → CI 시스템에 비밀로 저장
```

### 3. JWT 인증 명령

```bash
sf org login jwt \
  --client-id <consumer_key> \
  --jwt-key-file server.key \
  --username <dev_hub_username> \
  --instance-url https://login.salesforce.com \
  --set-default-dev-hub \
  --alias HubOrg
```

---

## Jenkins 파이프라인 (샘플 Jenkinsfile)

```groovy
environment {
    toolbelt = tool 'toolbelt'
    SF_USERNAME    = '<dev_hub_username>'
    SF_INSTANCE_URL = 'https://login.salesforce.com'
    SF_CONSUMER_KEY = '<consumer_key>'
    SERVER_KEY_CREDENTALS_ID = '<jenkins_credential_id>'
    PACKAGE_NAME  = 'My Package'
    TEST_LEVEL    = 'RunLocalTests'
}

stages {
    stage('Authorize DevHub') {
        steps {
            withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID,
                                  variable: 'server_key_file')]) {
                sh """${toolbelt}/sf org login jwt \
                    --instance-url ${SF_INSTANCE_URL} \
                    --client-id ${SF_CONSUMER_KEY} \
                    --username ${SF_USERNAME} \
                    --jwt-key-file ${server_key_file} \
                    --set-default-dev-hub \
                    --alias HubOrg"""
            }
        }
    }

    stage('Create Test Scratch Org') {
        steps {
            sh """${toolbelt}/sf org create scratch \
                --target-dev-hub HubOrg \
                --set-default \
                --definition-file config/project-scratch-def.json \
                --alias ciorg \
                --wait 10 \
                --duration-days 1"""
        }
    }

    stage('Push To Test Scratch Org') {
        steps {
            sh "${toolbelt}/sf project deploy start --target-org ciorg"
        }
    }

    stage('Run Tests') {
        steps {
            sh """${toolbelt}/sf apex run test \
                --target-org ciorg \
                --wait 10 \
                --result-format tap \
                --code-coverage \
                --test-level ${TEST_LEVEL}"""
        }
    }

    stage('Create Package Version') {
        steps {
            script {
                def output = sh(returnStdout: true, script: """
                    ${toolbelt}/sf package version create \
                    --package ${PACKAGE_NAME} \
                    --installation-key-bypass \
                    --wait 10 \
                    --json \
                    --target-dev-hub HubOrg
                """)
                def response = new groovy.json.JsonSlurperClassic().parseText(output)
                env.PACKAGE_VERSION = response.result.SubscriberPackageVersionId
            }
        }
    }

    stage('Install Package in Fresh Scratch Org') {
        steps {
            sh """${toolbelt}/sf org create scratch \
                --target-dev-hub HubOrg --set-default \
                --definition-file config/project-scratch-def.json \
                --alias installorg --wait 10 --duration-days 1"""
            sh """${toolbelt}/sf package install \
                --package ${env.PACKAGE_VERSION} \
                --target-org installorg --wait 10"""
            sh """${toolbelt}/sf apex run test \
                --target-org installorg --wait 10 \
                --result-format tap --code-coverage \
                --test-level ${TEST_LEVEL}"""
        }
    }

    stage('Cleanup') {
        steps {
            sh "${toolbelt}/sf org delete scratch --target-org ciorg --no-prompt"
            sh "${toolbelt}/sf org delete scratch --target-org installorg --no-prompt"
        }
    }
}
```

---

## CircleCI 설정 요점

### 서버 키 암호화 (CI 환경 저장용)

```bash
# 1. 암호화 키 생성
openssl enc -aes-256-cbc -k <passphrase> -P -md sha1 -nosalt
# → key=****24B2, iv=****DA58

# 2. server.key 암호화
openssl enc -nosalt -aes-256-cbc \
  -in server.key \
  -out server.key.enc \
  -base64 \
  -K <key> -iv <iv>

# 3. server.key 삭제 (절대 공개 저장소에 올리지 말 것)
rm server.key
```

### CircleCI 환경 변수 설정

| 변수명 | 값 |
|---|---|
| `HUB_CONSUMER_KEY` | Connected App consumer key |
| `HUB_SFDX_USER` | Dev Hub 사용자명 |
| `DECRYPTION_KEY` | 암호화 key |
| `DECRYPTION_IV` | 암호화 iv |

---

## CI/CD 환경 변수 (Jenkins 기준)

| 변수 | 설명 |
|---|---|
| `SF_USERNAME` | Dev Hub org 사용자명 |
| `SF_INSTANCE_URL` | Dev Hub My Domain URL |
| `SF_CONSUMER_KEY` | Connected App Consumer Key |
| `SERVER_KEY_CREDENTALS_ID` | Jenkins Secret File ID |
| `PACKAGE_NAME` | 패키지명 |
| `PACKAGE_VERSION` | 배포할 패키지 버전 ID (04t...) |
| `TEST_LEVEL` | RunLocalTests / RunAllTestsInOrg 등 |

---

## CI/CD 플로 비교

```
소스 중심 (Source-based) CI:
  push → JWT 인증 → scratch org 생성 → deploy → test → 삭제

패키지 기반 (Package-based) CI:
  push → JWT 인증 → scratch org → deploy → test
       → package version create → 설치용 scratch org
       → package install → test → 두 scratch org 삭제
```

---

## 주요 체크리스트

```
□ server.key를 절대 VCS에 커밋하지 않는다
□ JWT 인증 전 sf version으로 CLI 설치 확인
□ Scratch Org는 1-day 단기 사용
□ 테스트 후 반드시 org delete로 정리
□ 패키지 버전 ID는 JSON 파싱으로 자동 추출
□ 패키지 버전 생성 후 5분(300s) sleep — 복제 완료 대기
```

---

## 관련 노트

- [[Salesforce DX 개요]] — JWT 인증, sf CLI 기초
- [[Scratch Org 패턴]] — CI에서 Scratch Org 관리
- [[Unlocked Package 패턴]] — 패키지 버전 생성·설치
