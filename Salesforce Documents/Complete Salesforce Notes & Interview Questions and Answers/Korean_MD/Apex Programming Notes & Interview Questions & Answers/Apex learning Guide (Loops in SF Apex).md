---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex learning Guide (Loops in SF Apex)]
---

# Apex 학습 가이드 — Salesforce Apex의 루프 (Part 2)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했습니다.)

## 루프의 유형

1. **Do-While 루프:** 조건 확인 전 최소 한 번 실행. `do { statement } while (Boolean_condition);`
2. **While 루프:** 조건이 참인 동안 실행. `while (Boolean_condition) { statement; }`
3. **For 루프(Primitive):** 초기화, 종료 조건, 증감. `for (initialization; Boolean_exit_condition; increment) { statement; }`
4. **For 루프(Collection):** 리스트·셋·맵 반복. `for (variable : array_or_set) { statement; }`
5. **For 루프(Inline SOQL):** 쿼리 결과 직접 반복. `for (variable : [inline_SOQL_query]) { statement; }`

## Do-While 루프

조건이 참/거짓과 무관하게 본문이 최소 한 번 실행됩니다(조건이 본문 실행 후 확인되기 때문).
```apex
Integer counter = 1;
do {
    System.debug('Counter = ' + counter);
    counter++;
} while (counter <= 3);
```

## While 루프

조건이 시작 시 참일 때만 실행됩니다. 처음부터 거짓이면 전체를 건너뜁니다.
```apex
Integer counter = 1;
while (counter <= 3) {
    System.debug('Counter = ' + counter);
    counter++;
}
```

## For 루프 (Primitive)
```apex
for (Integer counter = 1; counter <= 5; counter++) {
    System.debug('Counter = ' + counter);
}
```

## For 루프 (Collection)

인덱스 없이 컬렉션의 각 요소를 반복합니다.
```apex
List<String> fruits = new List<String>{'Apple', 'Banana', 'Mango'};
for (String fruit : fruits) {
    System.debug('Fruit = ' + fruit);
}
```
sObject 예시:
```apex
for (Account acc : accountList) {
    System.debug('Account Name = ' + acc.Name);
}
```

## For 루프 (Inline SOQL)
```apex
for (Account acc : [SELECT Name, Phone FROM Account LIMIT 3]) {
    System.debug('Account Name = ' + acc.Name + ', Phone = ' + acc.Phone);
}
```
