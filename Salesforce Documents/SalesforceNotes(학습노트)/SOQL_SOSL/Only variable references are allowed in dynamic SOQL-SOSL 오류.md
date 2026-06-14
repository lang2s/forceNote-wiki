---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Only variable references are allowed in dynamic SOQL Vs SOSL]
---

# "Only variable references are allowed in dynamic SOQL/SOSL" 오류

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## 오류 발생 이유
동적 SOQL/SOSL에서 단순 변수 참조 대신 복잡한 표현식·메서드 호출·비변수 구문을 쓸 때 발생. Salesforce가 코드 인젝션 공격을 막고 DB 작업 안전을 위해 강제.

## 예
`fieldName.toLowerCase()`는 직접 변수 참조가 아닌 메서드 호출 → 보안상 쿼리 문자열에 메서드 호출·표현식 불가.

## 해결
bind 변수를 직접 사용. 메서드 호출·표현식 없이 `fieldName`을 변수로 직접.

## 매개변수화 쿼리
동적 쿼리(특히 WHERE 절)는 bind 변수로 매개변수화. 보안 보장·SOQL 인젝션 방지.

## 피할 것
사용자 입력을 쿼리 문자열에 직접 연결하지 말 것. `nameValue`에 악의적 입력이 있으면 SOQL 인젝션 위험.
