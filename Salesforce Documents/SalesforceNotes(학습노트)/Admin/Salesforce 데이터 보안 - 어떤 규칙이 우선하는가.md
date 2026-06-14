---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Data Security Which Rule Takes Priority]
---

# Salesforce 데이터 보안: 어떤 규칙이 우선하는가?

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

| 보안 유형 | 재정의(Overrides) | 예시 |
|---|---|---|
| OWD(조직 전체 기본값) | 기준 보안. 공유 규칙·역할·수동 공유로 재정의됨 | OWD=Private이나 공유 규칙이 접근 허용 |
| Role Hierarchy | 상위 사용자에게 하위 사용자 레코드 접근 부여 | 관리자가 부하 직원 리포트 조회 |
| Sharing Rules | OWD를 재정의해 더 넓은 접근 제공 | OWD=Private이나 공유 규칙이 팀에 Read-Only 부여 |
| Manual Sharing | 특정 사용자에게 레코드 접근 부여 | 사용자가 다른 사용자와 레코드 공유 |
| Apex Managed Sharing | 코드로 정의된 커스텀 공유 로직 | 비즈니스 요구에 따라 접근 부여 |
| Profile & Permission Sets | 오브젝트·필드 수준 접근 제어(공유 설정은 재정의 안 함) | 프로필이 오브젝트를 읽을 수 있어도 레코드 접근은 공유 규칙에 의존 |

## 다양한 수준의 보안 구현

**1. 오브젝트 수준 보안(Profile & Permission Set):** 누가 오브젝트를 보기·생성·편집·삭제할 수 있는지 제어. 프로필이 기본 권한 정의, 권한 집합이 프로필 변경 없이 추가 권한 부여. 예: 영업 담당자 프로필이 Opportunity 접근하지만, 권한 집합으로 선택된 사용자만 'Amount' 필드 편집.

**2. 필드 수준 보안:** 오브젝트 내 특정 필드 접근 제어. 사용자가 오브젝트는 보지만 모든 필드는 못 봄. 예: 영업 담당자가 레코드는 보지만 'Opportunity Amount' 필드는 숨겨짐.

**3. 레코드 수준 보안(누가 특정 레코드를 보는가?):**
- **OWD:** 기준 수준 정의(Private, Public Read Only, Public Read/Write).
- **Role Hierarchy:** 상위 역할이 하위 역할의 레코드 접근 상속.
- **Sharing Rules:** 기준에 따라 추가 레코드 접근 부여. 두 유형:
  - 레코드 소유자 기반: 특정 역할/Public Group이 소유한 레코드를 다른 역할·그룹·사용자와 공유. 예: 인도 영업팀이 미국 영업팀과 Opportunity 공유(Read-Only 또는 Read/Write).
  - 레코드 기준 기반: 특정 필드 조건을 충족하는 레코드를 공유. 예: 모든 고가치 Opportunity(Amount > 200,000)를 다른 영업팀과 공유.
- **Manual Sharing:** 사용자가 수동으로 레코드 공유.
- **Apex Managed Sharing:** 코드로 제어되는 커스텀 공유 로직.

예: Case의 OWD가 Private이나 공유 규칙이 지원팀원에게 서로의 Case를 볼 수 있게 허용.

## 4. 프로필과 권한 집합 보안

| 항목 | 프로필 | 권한 집합 |
|---|---|---|
| 기능 | 기본 수준 접근 | 프로필 너머 접근 확장 |
| 할당 | 사용자당 1개 프로필 | 사용자당 여러 개 |
| 사용 사례 | 표준 권한 | 임시 또는 추가 권한 |

예: 영업 담당자가 Opportunity에 Read/Write 프로필을 갖고, 시스템 관리자가 Opportunity Amount 승인·수정 권한 집합을 받음.

## 5. 권한 집합이 프로필 보안을 재정의하는 방식

프로필이 초기 접근을 정의하고, 권한 집합은 추가 권한을 부여합니다(기존 프로필 권한을 제거·축소할 수 없음). 예: 영업 담당자 프로필이 Opportunity에 Read-Only인데, 권한 집합이 Edit 접근을 부여하면 프로필 제한에도 불구하고 레코드 편집 가능.

## 6. 공유 설정이 프로필·권한 집합 보안을 재정의하는 방식

프로필·권한 집합은 오브젝트·필드 수준 접근을 제어하지만 레코드 수준 접근은 결정하지 않습니다. 공유 설정(OWD, Role Hierarchy, Sharing Rules)이 오브젝트 내 특정 레코드를 누가 볼 수 있는지 제어합니다.

예: 프로필이 Opportunity에 Read/Write이지만 OWD가 Private이고 공유 규칙이 Read-Only만 부여하면, 사용자는 다른 사용자의 Opportunity를 편집할 수 없습니다.

**핵심 정리:** 공유 규칙이 Read-Only이면 프로필이 전체 오브젝트 권한을 가져도 보기만 가능. Read/Write로 업데이트하면 편집 가능. 레코드 삭제는 해당 오브젝트의 View All 또는 Modify All 권한 필요.
