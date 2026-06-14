# "Only variable references are allowed in dynamic SOQL/SOSL" 오류

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
