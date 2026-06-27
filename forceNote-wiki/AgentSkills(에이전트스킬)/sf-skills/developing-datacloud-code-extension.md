---
tags: [agent-skill, sf-skills, data-cloud, data360, code-extension, python]
source: forcedotcom/sf-skills (skills/developing-datacloud-code-extension/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [developing-datacloud-code-extension, 데이터클라우드 코드 익스텐션, Data Cloud Code Extension, datacustomcode, Python transformation, sf data-code-extension]
---

# developing-datacloud-code-extension — Data Cloud 코드 익스텐션 개발

> SF CLI 플러그인으로 Salesforce Data Cloud에 커스텀 Python 변환을 개발·테스트·배포하는 완전한 워크플로. 코드 익스텐션은 DLO/DMO에서 읽고 쓰는 Python 변환을 작성하게 해준다. init·run·scan·deploy 작업 지원.

## 목적과 활성화 조건

이 스킬은 커스텀 Python 코드 익스텐션을 Salesforce Data Cloud에 개발·테스트·배포하는 완전한 워크플로를 제공한다. 코드 익스텐션은 Data Lake Object(DLO)·Data Model Object(DMO)에서 읽고 쓰는 Python 변환을 작성하게 한다.

- **언제 사용:** 새 코드 익스텐션 프로젝트 생성, 로컬 테스트, 필요 권한 스캔, Data Cloud 배포, Data Cloud 변환 작업, DLO/DMO 데이터를 프로그래밍 방식으로 읽기/쓰기.

### 전제조건 확인
코드 익스텐션 명령 실행 전 전제조건을 검증한다:

```bash
# 1. SF CLI + 플러그인
sf plugins --core | grep data-code-extension
sf plugins install @salesforce/plugin-data-codeextension   # 미설치 시

# 2. Python 3.11
python --version   # 3.11.x여야 함

# 3. Data Cloud Custom Code SDK
pip list | grep salesforce-data-customcode
pip install salesforce-data-customcode                       # 미설치 시

# 4. Docker 실행 (deploy 전용)
docker ps

# 5. 인증된 org
sf org display --target-org <org_alias> --json
```

## 워크플로 / 단계

### Phase 1: 프로젝트 초기화
스캐폴딩과 함께 새 코드 익스텐션 프로젝트 생성.

```bash
# script 기반 (배치 변환)
sf data-code-extension script init --package-dir <directory>
# function 기반 (실시간)
sf data-code-extension function init --package-dir <directory>
```
필수 옵션: `--package-dir, -p` — 패키지 생성 디렉터리 경로.

생성 구조:
```text
my-transform/              # 프로젝트 루트
├── payload/               # CRITICAL: deploy 시 --package-dir가 가리켜야 하는 곳
│   ├── entrypoint.py      # 메인 변환 코드
│   └── config.json        # 코드 익스텐션 구성
├── requirements.txt       # Python 의존성
└── README.md
```

### 디렉터리 컨텍스트 (배포 성공에 결정적)

| Command | 실행 위치 | Path/File 인자 |
|---|---|---|
| `init` | 부모 디렉터리 | `<project-name>` 또는 `.` |
| `scan` | 프로젝트 루트 | `./payload/entrypoint.py` |
| `run` | 프로젝트 루트 | `./payload/entrypoint.py` |
| `deploy` | 프로젝트 루트 | `--package-dir ./payload` (**필수**) |

**CRITICAL: deploy 명령의 `--package-dir` 인자는 프로젝트 루트가 아니라 `payload` 디렉터리를 가리켜야 한다.**

### Phase 2: 변환 개발
`payload/entrypoint.py`에 변환 로직을 작성한다.

Script 예제 (배치) — 원본 SKILL.md 발췌:
```python
from datacustomcode import Client

client = Client()

# Read from DLO
df = client.read_dlo('Employee__dll')

# Transform data (uppercase position field)
df['position_upper'] = df['position'].str.upper()

# Write to output DLO
client.write_to_dlo('Employee_Upper__dll', df, 'overwrite')
```

Function 예제 (실시간) — 원본 SKILL.md 발췌:
```python
from datacustomcode import FunctionClient

def transform(event, context):
    client = FunctionClient(context)
    input_data = event['data']
    output = {
        'name': input_data['name'].upper(),
        'status': 'processed'
    }
    return output
```

공통 연산: `client.read_dlo('DLO_Name__dll')` / `client.read_dmo('DMO_Name')` / `client.write_to_dlo('DLO_Name__dll', df, 'overwrite')` / `client.write_to_dmo('DMO_Name', df, 'upsert')`.

### Phase 3: 권한 스캔
entrypoint 파일을 스캔해 필요 권한을 탐지하고 config.json을 생성한다.
```bash
sf data-code-extension script scan --entrypoint ./payload/entrypoint.py
```
탐지 항목: DLO/DMO read·write 권한, Python 패키지 의존성. `config.json`·`requirements.txt` 갱신.

### Phase 4: DLO 스키마 검증 (테스트 전 체크)
**CRITICAL: 로컬 테스트 전 코드에서 사용하는 모든 DLO가 존재하고 기대 필드를 가지는지 검증한다.**

```bash
# 4a. config.json에서 DLO 추출
cat payload/config.json
# 4b. 각 DLO 스키마 검증 (getting-datacloud-schema 스킬 사용)
python3 scripts/get_dlo_schema.py <org_alias> <dlo_name>
```
4c. 검증 체크리스트: config.json의 모든 DLO가 대상 org에 존재 / 코드 사용 필드명이 DLO 스키마에 존재 / 필드 데이터 타입이 변환 로직과 호환 / primary key 필드 올바르게 식별 / write 타겟 DLO 생성·접근 가능. 필드명은 대소문자 구분 정확 일치.

### Phase 5: 로컬 테스트
DLO 스키마 검증 후 Data Cloud org에 대해 로컬 실행.
```bash
sf data-code-extension script run --entrypoint <entrypoint_file> --target-org <org_alias> [options]
```
옵션: `--target-org, -o`(필수), `--config-file, -c`(커스텀 config 경로). 오류 시 DLO 스키마 재검증·필드명 정확 일치·타입 호환 확인.

### Phase 6: Data Cloud 배포
스케줄 또는 온디맨드 실행을 위해 배포.
**CRITICAL: `--package-dir ./payload`로 init이 만든 payload 디렉터리를 반드시 지정.**
```bash
sf data-code-extension script deploy --target-org <org_alias> --name <name> --package-dir ./payload --package-version <version> --description <description> [options]
```
필수 옵션: `--target-org, -o` / `--name, -n` / `--package-dir`(프로젝트 루트에서 `./payload`) / `--package-version`(기본 0.0.1) / `--description`.
선택 옵션: `--cpu-size`(CPU_L, CPU_XL, CPU_2XL(기본), CPU_4XL) / `--function-invoke-opt`(function 타입용) / `--network`(Docker network, 기본 default).
배포 후: Salesforce UI → Data Cloud → Data Transforms 섹션 → 이름으로 배포 찾기 → "Run Now" 실행 → 반복 실행 스케줄.

## 핵심 규칙·가드레일

### 에러 처리 (원본 표)

| Error | Solution |
|---|---|
| `command data-code-extension not found` | `sf plugins install @salesforce/plugin-data-codeextension` |
| `datacustomcode CLI not found` | `pip install salesforce-data-customcode` |
| `Python version mismatch` | pyenv: `pyenv install 3.11.0 && pyenv local 3.11.0` |
| `Cannot connect to Docker daemon` | Docker Desktop 시작 |
| `No org found for alias` | `sf org login web --alias <org_alias>` |
| `config.json not found` | `sf data-code-extension script scan --entrypoint ./payload/entrypoint.py` |
| `DLO not found` | DLO 존재 확인(getting-datacloud-schema 스킬), 철자·`__dll` 접미사 확인 |
| `Permission denied writing` | scan 재실행, 타겟 DLO 존재·쓰기 가능 확인 |
| `Deploy fails - wrong directory` | `--package-dir`가 프로젝트 루트가 아닌 `payload/`를 가리키는지 확인 |

### Best Practices
- **개발:** 테스트 전 항상 scan(코드 변경 후 scan) / deploy 전 `run`으로 로컬 테스트 / 성공 테스트마다 git commit / semantic versioning(1.0.0, 1.1.0) / 프로젝트 루트에서 `--package-dir ./payload`로 배포.
- **성능 (CPU 크기):** CPU_L = 소규모(<1M 레코드) / CPU_2XL = 중규모(1M–10M) / CPU_4XL = 대규모(>10M).
- **보안:** 자격증명 하드코딩 금지(SF CLI 인증만) / 입력 데이터 검증(null·타입) / write 권한 최소화.

### 다른 스킬 연계
- **getting-datacloud-schema 스킬 (검증에 CRITICAL):** 코드 익스텐션 테스트 전 DLO 검증에 필수.
- **Datakit 워크플로:** 1) 코드 익스텐션으로 DLO 생성 → 2) datakit 워크플로로 DLO를 DMO에 매핑 → 3) segment·activation에서 DMO 사용.

### Notes
- 코드 익스텐션은 격리된 Python 3.11 환경에서 실행
- Docker는 배포에만 필요(로컬 테스트엔 불필요)
- SF CLI 인증만 사용(별도 자격증명 파일 없음)
- scan은 코드에서 권한을 자동 탐지
- 로컬 run은 실제 Data Cloud 데이터 사용(mock 아님)
- 배포는 버전 관리되며 UI에서 롤백 가능

## 번들 파일

| 분류 | 파일 |
|---|---|
| references | `references/README.md`, `references/quick-reference.md` (명령 cheat sheet — init/scan(`--dry-run`·`--config`·`--no-requirements` 포함)/run/deploy) |

### Command Reference (원본 표)

| Command | Purpose | Required Args |
|---|---|---|
| `script init` | 새 script 프로젝트 생성 | `--package-dir` |
| `function init` | 새 function 프로젝트 생성 | `--package-dir` |
| `script scan` | config 생성 | entrypoint file |
| `script run` | 로컬 테스트 | entrypoint file, `--target-org` |
| `script deploy` | Data Cloud 배포 | `--target-org`, `--name`, `--package-dir`, `--package-version`, `--description` |

### Resources (원본 링크)
- SF CLI Plugin: https://github.com/salesforcecli/plugin-data-code-extension
- Python SDK: https://github.com/forcedotcom/datacloud-customcode-python-sdk
- Data Cloud Docs: https://help.salesforce.com/s/articleView?id=sf.c360_a_intro.htm
- Python SDK PyPI: https://pypi.org/project/salesforce-data-customcode/

## 관련 노트
- [[getting-datacloud-schema]]
- [[data360-prepare]]
- [[data360-harmonize]]
