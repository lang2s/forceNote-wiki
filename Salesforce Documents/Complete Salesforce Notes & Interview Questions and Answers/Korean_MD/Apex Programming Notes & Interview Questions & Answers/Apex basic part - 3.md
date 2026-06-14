---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex basic part - 3]
---

# Apex 기초 Part 3 (데이터 구조)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 데이터 구조란?

데이터를 효율적으로 접근·수정하기 위해 조직·저장·관리하는 방법. 데이터 간 관계, 수행 가능한 작업, 그 규칙을 정의합니다. 두 가지 주요 유형:
1. **Primitive 데이터 구조:** 기본·기초(정수, 부동소수점, 문자, Boolean).
2. **Composite 데이터 구조:** primitive를 결합해 구축(배열, 리스트, 스택, 큐, 트리, 그래프, 해시 테이블).

## List

순서가 있는 요소 컬렉션. 요소는 다른 리스트를 포함한 어떤 타입도 가능.
```apex
List<Integer> ListOfNumber = new List<Integer>();
ListOfNumber.add(7); ListOfNumber.add(2); ListOfNumber.add(9);
// (7, 2, 9)
```
요소가 연속된 메모리 위치에 저장되어 인덱스 기반 접근이 쉽습니다. (Apex는 고수준 언어라 변수의 메모리 주소를 직접 얻을 수 없습니다.)

**반복(Iterate):**
- 전통적 for 루프: 인덱스 제어·수정이 필요할 때.
```apex
for (Integer i=0; i<listOfNumbers.size(); i++) {
    System.debug(listOfNumbers.get(i));
}
```
- for-each 루프: 단순히 각 요소 접근 시 더 깔끔. (단, for-each에서 num 값을 바꿔도 원본 리스트는 변경되지 않음. 인덱스로 접근해야 수정 가능.)

**Index vs Size:** Index는 요소의 위치(0부터 시작), Size는 총 요소 수.

**리스트 복제:**
- Shallow copy(얕은 복사): `StockList2 = StockList1;` — 같은 메모리 공유(참조). 한쪽 변경이 다른 쪽에도 반영됨.
- Deep copy(깊은 복사): `StockList2.addAll(StockList1);` — 별도 메모리 공간 생성.

**초기화 확인:**
- `new List<Integer>()`로 초기화하면 빈 리스트 `()` 반환(메모리 할당됨, 값 없음).
- 선언만 하면 `null` 반환(메모리 미할당). 초기화 없이 작업하면 NullPointerException.
- 모범 사례: 리스트가 null이 아닌지 항상 확인.

**List가 중요한 이유:**
- **데이터 조회:** SOQL 쿼리 결과가 레코드 리스트로 반환됨.
- **벌크화:** 거버너 한도를 준수하며 대량 레코드 처리.
- **데이터 조작:** 반복·필터·정렬 등.

## Set

순서 없는 컬렉션, 중복 불가.
```apex
Set<Integer> IntStockSet = new Set<Integer>();
IntStockSet.add(23); IntStockSet.add(20); IntStockSet.add(20);
// {20, 23} (중복 미허용)
```
인덱스로 접근 불가(순서 없음). 제거는 값으로(`remove(20)` → true 반환), List는 인덱스로(`remove(0)`). 주요 용도: List를 Set으로 변환해 중복 제거.
```apex
Set<Integer> StockSet = new Set<Integer>(StockList);
```

## Map

키-값 쌍으로 데이터를 저장(사전·JavaScript 오브젝트와 유사). 키 기반으로 빠르게 조회·업데이트·존재 확인. 키는 보통 String이나 Id, 값은 어떤 타입도 가능.
```apex
Map<Integer, String> Courses = new Map<Integer, String>();
Courses.put(101, 'JAVA');
Courses.put(102, 'Python');
Courses.put(103, 'C++');
System.debug(Courses.get(101)); // Java
```

**Map 검색이 List보다 빠른 이유:** 키-값 구조로 해싱을 사용해 상수 시간(O(1))에 접근. List는 선형 검색으로 평균 O(n).

**키는 중복 불가:** 기존 키에 새 값을 put하면 값이 업데이트됨(103: C++ → Salesforce).

**주요 메서드:**
- `get(key)`: 키의 값 조회
- `keySet()`: 모든 키를 Set으로 반환(키는 고유)
- `containsKey(key)`: 키 존재 여부
- `size()`: 키-값 매핑 수
