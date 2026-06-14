---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Validation Rule in Salesforce]
---

# Salesforce의 검증 규칙(Validation Rule)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

검증 규칙은 사용자가 잘못된 데이터를 저장하지 못하게 하여 데이터 품질을 개선합니다. 오류 조건과 그에 해당하는 오류 메시지로 구성된 하나 이상의 검증 규칙을 정의할 수 있습니다.

- 검증 규칙은 레코드 저장 시점에 실행됩니다.
- 오류 메시지는 필드 바로 아래 또는 페이지 상단에 표시할 수 있습니다.
- 하나 이상의 필드 데이터를 평가하여 true 또는 false 값을 반환하는 수식·표현식을 포함할 수 있습니다.

## 검증 규칙의 구성 요소

- **필드(Field):** 검증할 필드 지정
- **기준(Criteria):** 검증을 위해 충족해야 하는 조건 정의
- **오류 메시지(Error Message):** 검증 실패 시 표시할 커스텀 메시지

## 검증 규칙 유형

- **필드 수준:** 개별 필드에 적용
- **레코드 수준:** 전체 레코드 평가
- **오브젝트 간(Cross-object):** 관련 오브젝트 검증

## 생성 방법

Validation Rule 클릭 → 규칙 생성. 생성 후 조직 데이터에서 테스트(true·false 평가 모두 확인). 필요 시 수정. 오류 메시지가 올바르게 표시되는지 확인.

## 모범 사례

1. 단순하게 유지
2. 명확하고 간결한 오류 메시지 사용
3. 올바른 기준 사용
4. 조건부 로직 사용
5. "OR" 함수를 신중하게 사용
6. "ISCHANGED" 함수 사용
7. 검증 규칙에 주석 추가
8. 값 하드코딩 회피
9. 검증 규칙 문서화
10. 비활성화(Deactivation) 활용
