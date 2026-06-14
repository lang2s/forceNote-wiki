# Apex의 컬렉션(Collections)

## 컬렉션이란?

여러 값을 저장하는 데 사용되는 데이터 구조입니다. 관련 데이터를 효율적으로 저장·관리할 수 있게 해줍니다. 다른 언어의 컬렉션과 유사하지만 Salesforce의 멀티테넌트 아키텍처에 맞게 설계되었습니다.

## 컬렉션의 유형

세 가지 주요 유형:

- **List:** 순서가 있는 인덱스 기반 컬렉션. 중복 허용. 예: `List<String> names = new List<String>();`
- **Set:** 고유 값의 순서 없는 컬렉션. 중복 불가. 예: `Set<Integer> numbers = new Set<Integer>();`
- **Map:** 키-값 쌍 컬렉션. 키는 고유, 값은 중복 가능. 예: `Map<String, Integer> map = new Map<String, Integer>();`

## List

순서가 있고 중복 값을 포함할 수 있는 컬렉션. 주요 작업: 추가 `list.add(value)`, 접근 `list.get(index)`, 제거 `list.remove(index)`.

## Set

중복 값을 허용하지 않는 컬렉션. 주요 작업: 추가 `set.add(value)`, 제거 `set.remove(value)`, 포함 확인 `set.contains(value)`.

## Map

키-값 쌍 컬렉션. 키는 고유, 값은 반복 가능. 주요 작업: 추가 `map.put(key, value)`, 접근 `map.get(key)`, 제거 `map.remove(key)`.

## 컬렉션 작업

생성:
- List: `List<Type> name = new List<Type>();`
- Set: `Set<Type> name = new Set<Type>();`
- Map: `Map<KeyType, ValueType> name = new Map<KeyType, ValueType>();`

요소 접근: List는 `list.get(index)`, Set은 반복(iterate), Map은 `map.get(key)`.

## 이점과 사용 사례

- 동적 데이터 처리(동적인 레코드 수 처리)
- 효율적 데이터 조작(쉬운 추가·제거·접근)
- 일반 사용 사례: 쿼리 결과 저장, 트리거의 레코드 관리, 데이터 집합 복잡한 계산.

## 결론

컬렉션은 여러 레코드를 관리·처리하는 강력한 도구입니다. 유형과 사용 사례를 이해하면 효율적이고 확장 가능한 코드를 작성할 수 있습니다. 컬렉션 작업 시 항상 성능과 거버너 한도를 염두에 두세요.
