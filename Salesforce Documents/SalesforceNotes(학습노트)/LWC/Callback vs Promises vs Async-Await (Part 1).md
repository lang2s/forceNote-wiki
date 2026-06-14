---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Callback VS Promises VS Async_Await]
---

# Callback vs Promises vs Async/Await (Part 1)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## Callback
콜백은 함수. 어떤 작업 완료 후 작업을 수행하는 데 사용.
> setTimeout 자체는 콜백이 아니며, setTimeout에 인수로 전달되는 함수가 콜백(100ms 후 호출). 예: setToken은 login에 전달되는 콜백으로, login이 나중에 호출.

## Callback Hell
다중 중첩 콜백으로 코드가 읽기 어렵고 유지보수 곤란한 상황.

## Promises
콜백 헬 문제를 해결. 결과에 따라 값을 반환(resolve)하거나 거부(reject)하기로 "약속"하는 객체.
```javascript
new Promise((resolve, reject) => {
    if (a <= 20) resolve('a is less than or equal to 20');
    else reject('a is greater than 20');
});
```
> promise 생성 시 콜백 함수 전달은 피할 수 없으나, 콜백 헬은 피할 수 있다.

**사용:** `.then`(resolve 값)·`.catch`(reject 값).
```javascript
promise
  .then(value => console.log(value))
  .catch(error => console.log(error));
```
> .then은 resolve 값을 첫 인수로, .catch는 reject 값을 첫 인수로 받는 콜백.

## Promise Chaining
여러 promise를 체이닝해 콜백 헬 회피. `.then`에서 promise를 반환하면 여러 `.then` 콜백 체이닝 가능.
> Pro Tip: `.then` 자체가 promise를 반환하므로 원하는 만큼 체이닝 가능.

## Async/Await
(원본 Part 01에 이어지는 내용)
