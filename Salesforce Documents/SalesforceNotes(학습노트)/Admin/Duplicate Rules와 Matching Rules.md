---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Duplicate Rules and Matching Rule]
---

# Duplicate Rules와 Matching Rules

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Salesforce Duplicate Rules(중복 규칙)

- 사용자가 중복 레코드를 편집하거나 생성하려 할 때 Salesforce가 취할 조치를 정의하는 데 사용됩니다.
- 예: 표준 매칭 규칙 기준을 충족하는 레코드 저장을 차단하거나, 단순히 중복 가능성이 있다고 사용자에게 경고하도록 커스터마이징할 수 있습니다.

## Salesforce Matching Rules(매칭 규칙)

- 사용자가 생성·편집 중인 레코드가 실제로 중복인지 판단하는 데 사용됩니다.
- 예: 두 Contact가 같은 이메일 주소를 가지면, 이메일 매칭 규칙이 'exact' 또는 'fuzzy'일 때 중복으로 분류됩니다.

## 알아둘 점

**규칙 개수**
- 오브젝트당 최대 5개의 활성 중복 규칙 사용 가능.
- 각 중복 규칙에 최대 3개의 매칭 규칙 추가 가능(오브젝트당 활성 매칭 규칙은 1개). 여러 중복 규칙 사용 시 오브젝트당 최대 5개의 활성 매칭 규칙 포함 가능.

**Report 옵션으로 생성되는 Duplicate Record Set**
중복 규칙에서 Report 옵션을 선택하고 사용자가 중복으로 식별된 레코드를 저장하면:
- 저장된 레코드와 최대 개수의 중복이 새/기존 duplicate record set에 재할당됩니다(레코드에 실행된 각 매칭 규칙당 최대 100개 중복).
- 저장된 레코드와 각 중복이 duplicate record set의 항목으로 나열됩니다.
- 중복 규칙이 오브젝트 간 중복을 찾으면(예: Lead와 중복되는 Contact) duplicate record set에 다른 오브젝트의 중복도 포함됩니다.
- duplicate record set 생성 전에 중복 Lead가 전환되면 전환된 Lead는 포함되지 않습니다.

**100개 초과 매치가 있는 레코드**
Match key는 예비 비교로 매치를 가장 가능성 높은 100개 중복 레코드로 좁혀 중복 규칙 성능을 높입니다. 그런 다음 규칙이 그 후보들에만 매칭 방정식을 적용합니다.

**사용자 접근이 규칙에 미치는 영향**
레코드를 업데이트하는 사용자가 매칭 규칙에서 참조하는 필드에 접근 권한이 없으면 중복 규칙이 예상대로 작동하지 않습니다. 예: 표준 사용자가 account name 필드에 접근할 수 없는데 관리자가 그 필드에 의존하는 매칭 규칙을 만들면, 관리자가 업데이트할 때는 작동하지만 표준 사용자가 같은 레코드를 업데이트할 때는 중복을 식별하지 못합니다.

**편집된 필드에 대한 규칙 작동**
레코드 생성·편집 시 조치를 수행하도록 중복 규칙을 구성할 수 있지만, 편집된 필드가 연결된 매칭 규칙에 포함된 경우에만 편집된 레코드에 규칙이 실행됩니다.

**Global Picklist Value Set:**

중복 규칙에서 지원되지 않습니다.

**Custom Picklist:**

오브젝트 간 중복 규칙에 사용되는 매칭 규칙에서 커스텀 선택 목록 필드는 지원되지 않습니다.

**Rollup Summary 필드 값 변경:**

롤업 요약 필드 값이 변경되면 중복 규칙이 실행되며, Allow 옵션(중복 레코드 저장)은 지원되지 않습니다.

**중복 규칙이 실행되지 않는 조건**
- Quick Create나 Community Self-Registration으로 레코드 생성
- Lead가 Account/Contact로 전환되고 Use Apex Lead Convert가 비활성화된 경우
- Undelete 버튼으로 레코드 복원
- Lightning Sync나 Einstein Activity Capture로 추가
- 레코드 수동 병합
- Self-Service 사용자가 User 오브젝트 기반 조건이 포함된 규칙으로 레코드 생성
- lookup 관계 필드 조건이 설정되었으나 값이 저장되지 않은 경우

**중복 규칙 설정이 무시되는 조건**(경고 없이 저장 불가)
- 데이터 임포트 도구로 레코드 추가
- person account가 business account로 전환되어 기존 business account와 일치
- Salesforce API로 레코드 추가·편집
