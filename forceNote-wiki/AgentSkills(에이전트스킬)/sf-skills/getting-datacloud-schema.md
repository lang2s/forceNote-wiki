---
tags: [agent-skill, sf-skills, data-cloud, data360, schema, ssot-rest-api]
source: forcedotcom/sf-skills (skills/getting-datacloud-schema/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [getting-datacloud-schema, 데이터클라우드 스키마 조회, DLO schema, DMO schema, SSOT REST API, 데이터레이크 객체, 데이터모델 객체]
---

# getting-datacloud-schema — Data Cloud 스키마 조회

> SSOT REST API로 Salesforce Data Cloud의 Data Lake Object(DLO)·Data Model Object(DMO) 스키마 정보를 조회한다. org의 모든 DLO/DMO를 나열하거나 특정 DLO/DMO의 상세 스키마를 조회한다.

## 목적과 활성화 조건

이 스킬은 SSOT REST API로 DLO·DMO 스키마 정보를 조회한다. org의 모든 DLO/DMO를 나열하거나 특정 DLO/DMO의 상세 스키마를 조회할 수 있다.

- **언제 사용:** org의 모든 DLO/DMO를 보고 싶을 때, 특정 DLO/DMO 필드 스키마가 필요할 때, Data Cloud 데이터 구조를 탐색할 때, DLO/DMO 필드 타입·메타데이터를 이해해야 할 때.
- **파라미터:** `org_alias`(필수, SF CLI org alias 예: 'afvibe', 'myorg') / `dlo_name`(선택, 예: 'Employee__dll') / `dmo_name`(선택, 예: 'Individual__dlm').

### 전제조건
- SF CLI 설치 및 대상 org 인증됨
- org에 Data Cloud 활성화됨
- 사용자가 적절한 Data Cloud 권한 보유

## 워크플로 / 단계

### Step 1: 연결된 org 발견
먼저 `sf org list`로 연결된 org를 찾아 alias를 추출하고, 이후 모든 호출에 사용한다.
```bash
sf org list
```
출력의 **Alias** 값(예: `myorg`)을 추출해 `<org_alias>`로 사용한다. 만료·삭제된 scratch org까지 보려면 `--all`.

### Step 2: SF CLI 인증 검증
```bash
sf org display --target-org <org_alias> --json
```
연결되지 않았으면 사용자에게 안내:
```bash
sf org login web --alias <org_alias>
```

### Step 3a: DLO 스키마 스크립트 실행
Python 스크립트는 이 스킬과 함께 번들되며 SKILL.md가 있는 디렉터리의 `scripts/` 하위에 있다. **`./scripts/`가 아니라 스킬 디렉터리 절대경로를 사용한다** (`./`는 스킬 디렉터리가 아닌 현재 작업 디렉터리 기준으로 해석되기 때문).

```bash
# 모든 DLO 나열
python3 <skill_dir>/scripts/get_dlo_schema.py <org_alias>
# 특정 DLO 스키마
python3 <skill_dir>/scripts/get_dlo_schema.py <org_alias> <dlo_name>
```

### Step 3b: DMO 스키마 스크립트 실행
```bash
# 모든 DMO 나열
python3 <skill_dir>/scripts/get_dmo_schema.py <org_alias>
# 특정 DMO 스키마
python3 <skill_dir>/scripts/get_dmo_schema.py <org_alias> <dmo_name>
```

### Step 4: 결과 제시
- **DLO List:** DLO name·label·category·ID, 총 개수, 데이터 보유(totalRecords > 0) 강조
- **DLO Schema:** 기본 정보(name·label·category·status), 모든 필드(field name·data type·primary key 표시·nullable), custom 필드 강조(DataSource__c·cdp_sys_* 같은 시스템 필드 제외), record count
- **DMO List:** DMO name·label·category·ID, 총 개수
- **DMO Schema:** 기본 정보(name·label·category·description), 모든 필드(field name·data type·primary key·nullable), dataspace 정보

### Step 5: 다음 단계 제안
DLO 데이터 질의, calculated insight 생성, segment 구축, data stream 셋업, DMO mapping 생성 등.

## 핵심 규칙·가드레일

### 사용 API 엔드포인트 (SSOT REST, v64.0)
```text
GET /services/data/v64.0/ssot/data-lake-objects            # 모든 DLO 나열
GET /services/data/v64.0/ssot/data-lake-objects/{dlo_name} # DLO 스키마
GET /services/data/v64.0/ssot/data-model-objects             # 모든 DMO 나열
GET /services/data/v64.0/ssot/data-model-objects/{dmo_name}  # DMO 스키마
```

DLO list 응답 구조 예:
```json
{
  "dataLakeObjects": [
    {
      "name": "Employee__dll",
      "label": "Employee",
      "category": "Profile",
      "id": "1dlXXXXXXXXXXXXXXX",
      "status": "ACTIVE",
      "totalRecords": 12,
      "fields": [ ]
    }
  ],
  "totalSize": 5
}
```

### 에러 처리
- **Org not connected** → SF CLI로 인증 안내
- **DLO not found** (`DLO 'XYZ__dll' not found`) → 먼저 전체 DLO 나열로 이름 확인
- **DMO not found** (`DMO 'XYZ__dlm' not found`) → 먼저 전체 DMO 나열로 이름 확인
- **Permission issues** (HTTP 403) → Data Cloud 권한 확인
- **API version mismatch** (현재 v64.0) → 스크립트를 최신 API 버전으로 갱신 가능

### 명명 규칙 / Notes
- DLO 이름은 항상 `__dll` 접미사로 끝남
- DMO 이름은 항상 `__dlm` 접미사로 끝남
- 필드 이름은 항상 `__c` 접미사로 끝남
- 시스템 필드(DataSource__c, KQ_*, cdp_sys_*)는 자동 추가됨
- DLO·DMO 질의엔 primary key 필드가 필수
- API는 대용량 결과에 페이지네이션(limit/offset) 지원

## 번들 파일

| 분류 | 파일 |
|---|---|
| scripts | `scripts/get_dlo_schema.py` (DLO 나열/스키마 조회), `scripts/get_dmo_schema.py` (DMO 나열/스키마 조회) |
| references | `references/README.md` |

### 관련 스킬 (SKILL.md 명시)
- **datakit_workflow**: DMO mapping 작업 (이 위키 미수록)
- **datakit_validation**: datakit 구성 검증 (이 위키 미수록)
- DMO mapping 생성 전 이 스킬로 소스 DLO 구조 이해

## 관련 노트
- [[developing-datacloud-code-extension]]
- [[data360-harmonize]]
- [[data360-prepare]]
