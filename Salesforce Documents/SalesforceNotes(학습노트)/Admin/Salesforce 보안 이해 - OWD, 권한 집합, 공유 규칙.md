---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Understanding Sharing Security OWD , Permissions sets, Sharing Rules]
---

# Salesforce 보안 이해: OWD, 권한 집합, 공유 규칙

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## OWD(조직 전체 기본값)란?

OWD는 조직 내 레코드에 대한 기준 접근 수준을 제어하는 보안 기능입니다. 사용자가 소유하지 않은 레코드에 대한 기본 가시성(읽기·생성·편집·삭제)을 정의합니다. Role Hierarchy, Sharing Rules, Manual Sharing 같은 다른 공유 설정과 함께 세밀한 접근 제어를 제공합니다.

## OWD 작동 방식

각 오브젝트(Account, Opportunity, Contact 등)에 설정되며 다음과 같이 구성할 수 있습니다:
- **Public Read/Write(전체 접근):** 모든 사용자가 모든 레코드 보기·편집.
- **Public Read Only:** 모든 사용자가 보기 가능, 소유자(및 상위 접근 사용자)만 편집.
- **Private:** 레코드 소유자와 역할 계층상 상위 사용자만 보기·편집.
- **Controlled by Parent:** 자식 레코드 접근이 부모 레코드의 가시성에 따라 결정(관련 레코드용).

OWD 설정 후 Role Hierarchy, Sharing Rules, Manual Sharing으로 접근을 더 다듬을 수 있습니다.

## 예시 시나리오

Account 오브젝트의 OWD가 **Private**인 조직. 사용자는 자신이 소유한 Account만 보고 편집할 수 있으며, 명시적으로 공유되지 않으면 다른 사람은 접근할 수 없습니다.

- User A(영업 담당자): Account1, Account2 소유
- User B(영업 담당자): Account3 소유
- User C(영업 관리자): 계층상 상위 역할

→ User A는 Account1·2 접근(Account3 불가), User B는 Account3 접근(Account1·2 불가), User C는 계층 상위라 모든 Account 보기·편집 가능.

## 질문과 답변

**1. User A가 Account3(User B 소유)를 볼 수 있나요?**
아니요. OWD가 Private이므로 User A는 자신의 레코드만 보며, 명시적으로 공유되지 않으면 다른 사람 레코드를 볼 수 없습니다.

**2. User C(영업 관리자)가 Account1(User A 소유)을 볼 수 있나요?**
네. 영업 관리자 역할이 계층상 상위이고, OWD가 그보다 더 제한적이지 않은 한 상위 역할은 하위 사용자 레코드에 자동으로 접근합니다.

**3. User A가 Account2를 편집할 수 있나요?**
네. User A가 소유자이므로 자신의 레코드를 완전히 제어할 수 있습니다.

**4. User A가 Account3를 봐야 한다면 어떻게 하나요?**
- **Manual Sharing:** User B(소유자)가 허용하면 User A와 수동 공유.
- **Sharing Rules:** 관리자가 특정 사용자·그룹 간 접근을 여는 공유 규칙 생성(예: Account3를 영업팀과 공유).

**5. User A가 조직의 모든 Account를 봐야 한다면?**
Account 오브젝트의 OWD를 Private에서 Public Read Only 또는 Public Read/Write로 변경하거나, 공유 규칙 구현 또는 역할 계층 업데이트로 더 넓은 접근 부여.

## 핵심 정리

- OWD는 레코드의 기준 가시성을 설정.
- Private OWD는 사용자가 자신의 레코드나 공유된 레코드만 접근.
- 역할 계층상 상위 역할은 하위 사용자 레코드에 접근.
- Sharing Rules, Manual Sharing, Role Hierarchy로 접근을 추가로 다듬을 수 있음.
