---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Different decorators available in LWC]
---

# LWC의 데코레이터

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## @wire
Apex 메서드 출력을 JS 컨트롤러의 속성·함수에 연결.

## @api
속성·함수를 public으로 표시해 부모가 접근. (Apex의 public 접근 제어자와 유사)

## @track
객체·배열에서 키 값이 변경될 때 객체를 반응형으로 만들 때 사용.
