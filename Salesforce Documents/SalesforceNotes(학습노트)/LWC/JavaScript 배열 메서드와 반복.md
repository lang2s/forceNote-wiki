---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [JavaScript Array Method and Looping-1]
---

# JavaScript 배열 메서드와 반복

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 배열 메서드
**map()** — 배열을 순회하며 조건 기반 값 반환.
```javascript
let arr = [10,40,60,90,70];
arr.map(function(currentItem, index, arr){
    return currentItem * 20;
});
```
**every()** — 모든 요소가 조건 충족 시 true.
```javascript
[10,20,40,60].every(item => item > 5);
```
**some()** — 일부 요소가 조건 충족 시 true.
```javascript
[10,20,40,60].some(item => item > 5);
```
**sort()** — 배열 요소 정렬.
```javascript
[60,20,10,5].sort((a,b) => a-b);
```
**reduce()** — 단일 값 반환(원본 미변경).
```javascript
[60,20,10,5].reduce((total, currentItem) => total + currentItem, 0);
```

## 반복

**1. for 루프**
```javascript
for(let i=0; i<numArr.length; i++){ console.log(numArr[i].age); }
```
**2. forEach**
```javascript
numArr.forEach(function(currentItem, index, Arr){
    console.log(`${currentItem.name} is ${currentItem.age} year old`);
});
```
**3. for-of** — 인덱스 없이 요소 접근, 읽기 쉬움.
```javascript
for(let num of numArr){ console.log(`${num.name} is ${num.age} year old`); }
```
**4. for-in** — 객체 키 순회.
```javascript
for(let key in numArr){ console.log(numArr[key].name); }
```
**5. while** — 요소 반복.
```javascript
let i = 0;
while(i < numArr.length){ console.log(numArr[i].name); i++; }
```
**6. do-while** — 최소 한 번 실행.
```javascript
let i = 0;
do { console.log(numArr[i].name); i++; } while(i < numArr.length);
```
