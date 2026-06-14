---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Collections in Apex]
---

# Apex의 컬렉션 (List, Set, Map)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## List

순서가 있는 컬렉션으로 중복 값을 포함하며 인덱스로 요소에 접근합니다.

```apex
List<Integer> exampleList = new List<Integer>();
List<String> exampleList = new List<String>{'a','b','c'};
```

값을 추가하는 방법:
```apex
// 생성 시 초기화
List<Integer> intList = new List<Integer>{1,2,3,4,5};
// add 함수로 마지막에 추가
List<Integer> intList = new List<Integer>();
intList.add(1); intList.add(2);
```

**주요 메서드:**
- `add(element)`: 리스트 끝에 요소 추가
- `add(index, element)`: 지정 인덱스에 삽입
- `contains(element)`: 포함 여부 반환
- `size()`: 요소 수 반환
- `isEmpty()`: 요소가 0개면 true
- `indexOf(element)`: 첫 발생 인덱스 반환(없으면 -1)

## Set

순서 없는 컬렉션으로 중복 값을 포함하지 않습니다.
```apex
Set<String> exampleSet = new Set<String>();
exampleSet.add('a'); exampleSet.add('b'); exampleSet.add('c');
exampleSet.add('c'); // 중복은 추가되지 않음
```
Set은 indexOf를 지원하지 않고 값으로 접근합니다. 나머지 메서드는 List와 같습니다.

## Map

키-값 쌍으로 이루어진 더 복잡한 컬렉션. 키와 값은 어떤 데이터 타입도 가능. 각 키는 고유하지만 값은 반복 가능.

```apex
// Map 선언
Map<String, Integer> myMap = new Map<String, Integer>();
myMap.put('One', 1); myMap.put('Two', 2);

// 값과 함께 초기화
Map<String, String> countryCapitalMap = new Map<String, String>{
    'USA' => 'Washington, D.C.', 'India' => 'New Delhi', 'Japan' => 'Tokyo'
};

// SObject 타입 Map
Map<Id, Account> accountMap = new Map<Id, Account>();
List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 5];
for (Account acc : accounts) { accountMap.put(acc.Id, acc); }
```

**주요 메서드:**
- `get(key)`: 키에 연결된 값 조회
- `containsKey(key)`: 특정 키 포함 여부
- `keySet()`: 모든 키의 Set 반환
- `values()`: 모든 값의 List 반환

**반복(iterate) 예시:**
```apex
for(Account acc : accountMap.values()){ system.debug(acc.Name); }
for(Id key : accountMap.keySet()){ system.debug(key); }
```

## List vs Set vs Map 차이

List는 순서 있음·중복 허용·인덱스 접근, Set은 순서 없음·중복 불가, Map은 키-값 쌍·키 고유.
