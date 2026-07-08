---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Permission Sets & Permission Set Groups]
---

# Permission Set과 Permission Set Group

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Permission Set(권한 집합)

사용자에게 할당할 수 있는 설정과 권한의 모음입니다. 할당된 프로필에서 제공되지 않는 레코드, 오브젝트, 필드, 기능에 대한 추가 접근을 제공합니다.

## Permission Set Group(권한 집합 그룹)

권한 집합의 모음입니다. 관련 권한 집합을 묶어 관리자가 접근을 더 쉽게 관리할 수 있게 하는 좋은 방법입니다.

권한 집합과 권한 집합 그룹 모두 관리자가 사용자의 프로필 권한을 넘어 추가 권한과 접근을 부여할 수 있게 합니다.

## 왜 Permission Set Group을 사용하나요?

- 각 권한 집합은 여러 사용자에게 할당할 수 있습니다.
- 권한 집합 그룹을 사용하면 각 권한 집합을 따로 할당하는 대신, 한 번에 여러 권한 집합을 여러 사용자에게 할당할 수 있습니다.
