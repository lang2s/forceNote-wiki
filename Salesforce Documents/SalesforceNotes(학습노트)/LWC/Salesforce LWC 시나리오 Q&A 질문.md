---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SALESFORCE LWC INTERVIEW QUESTION SCENARIO BASED]
---

# Salesforce LWC 시나리오 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**시나리오 1: 입력 필드 값에 따라 버튼 표시/숨김?** 조건부 렌더링으로 특정 값일 때만 버튼 표시. `if:true` 디렉티브로 조건부 렌더링.

**시나리오 2: @wire로 Account 상세 조회?** getRecord에 recordId·필드를 전달해 @wire로 데이터 조회. @wire는 비동기 자동 조회.

**시나리오 3: 입력 변경을 실시간 표시?** 입력 필드를 속성에 바인딩하고 이벤트 핸들러로 타이핑 시 업데이트. onchange 핸들러로 속성 업데이트.

**시나리오 4: 외부 REST API 데이터 조회·표시?** fetch로 HTTP 요청 후 응답 표시. fetch()로 외부 서버 요청.

**시나리오 5: 버튼 클릭 시 사용자 입력 데이터 저장?** @track로 데이터 바인딩, handleClick으로 저장. @track은 변수 변경 추적·DOM 업데이트.
