---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [What is Map]
---

# JavaScript 배열 메서드 (map, filter, reduce 등)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 참고: 이 자료는 LWC 개발용 JavaScript 배열 메서드에 관한 내용입니다. (원본은 이미지 PDF로 OCR 추출)

## map()

배열의 각 요소를 변환하여 새 배열을 반환합니다.
시나리오: 배열의 값을 두 배로.

## filter()

특정 조건을 충족하는 요소를 반환합니다.
시나리오: $700 초과 제품 가져오기.
```javascript
const products = [{ name: 'Laptop', price: 1000 }, { name: 'Phone', price: 600 }];
const expensive = products.filter(product => product.price > 700);
// 결과: [{ name: 'Laptop', price: 1000 }]
```

## reduce()

콜백을 반복 적용해 배열을 단일 값으로 줄입니다.
시나리오: 항목의 총 가격 계산.

## some()

배열의 요소 중 하나라도 조건을 충족하는지 확인. 하나라도 충족하면 true.
```javascript
const tasks = [{ id: 1, priority: 'High' }, { id: 2, priority: 'Low' }];
const hasHighPriority = tasks.some(task => task.priority === 'High'); // true
```

## every()

모든 요소가 조건을 충족하는지 확인. 모두 충족할 때만 true.
```javascript
const products = [{ name: 'Laptop', available: true }, { name: 'Phone', available: true }];
const allAvailable = products.every(product => product.available);
```

## 배열 메서드 결합

**map() + filter():**

사용 가능한 제품을 필터링하고 이름을 대문자로 변환.
```javascript
const availableNames = products
    .filter(product => product.available)
    .map(product => product.name.toUpperCase());
```

**filter() + reduce():**

재고가 있는 모든 제품의 총 가격 계산.
```javascript
const total = products
    .filter(product => product.stock > 0)
    .reduce((sum, product) => sum + product.price * product.stock, 0);
```

## 왜 마스터해야 하나요?

- **로직 단순화:** 복잡한 작업을 관리 가능한 재사용 단계로 분해.
- **성능 개선:** LWC 템플릿 렌더링 전 클라이언트 측에서 데이터 처리.
- **깔끔한 코드:** 결합 메서드로 여러 루프 필요성 감소, 가독성 향상.
