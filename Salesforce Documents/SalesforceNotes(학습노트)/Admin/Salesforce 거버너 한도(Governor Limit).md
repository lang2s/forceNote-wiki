---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Governor Limit ]
---

# Salesforce 거버너 한도(Governor Limit)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 거버너 한도란?

Salesforce 거버너 한도는 멀티테넌시 환경에서 데이터베이스 성능을 유지하기 위해 적용되는 런타임 한도입니다.

## 주요 거버너 한도 목록

- 조직에서 한 번에 하나의 Batch Apex 작업 start 메서드만 실행 가능
- Apex에 대기/활성 배치 작업 최대 5개
- 24시간당 최대 250,000개 Batch Apex 메서드 실행
- Batch Apex start 메서드는 사용자당 한 번에 최대 15개 쿼리 커서 열기
- Database.QueryLocator 객체에서 최대 5천만 레코드 반환
- 최대 SOSL 쿼리 수: 20개
- 최대 SOQL 쿼리 수: 100개
- DML 문 수: 150개
- 쿼리로 쓰는 레코드 수: 50,000개
- 최대 DML 행 수: 10,000개
- 최대 스크립트 문 수: 200,000개
- 최대 Heap 크기: 6MB
- 최대 콜아웃 수: 10개
- 최대 future 호출 수: 10개
- 최대 picklist describe 수: 10개
- 최대 record type describe 수: 100개
- 최대 relationship describe 수: 100개
- 최대 fields describe 수: 100개
- 최대 Email invocation 수: 10개

참고: 1,000개 레코드를 scope 200으로 처리하면 5개 배치로 나뉩니다.

## 제한 사항

- future로 선언된 메서드는 Database.Batchable 인터페이스를 구현하는 클래스에서 허용되지 않음
- future 메서드는 Batch Apex 클래스에서 호출할 수 없음
- 공유 재계산의 경우 execute 메서드에서 배치 내 레코드의 Apex managed sharing을 삭제 후 재생성 권장

## 거버너 한도를 극복하는 방법

코드 작성 시 특별한 주의가 필요합니다.
- 루프 안에서 SOQL·DML 작업 절대 금지
- 스크립트 문 수 줄이기
- 50,000개 초과 레코드 작업 시 Batch Apex 사용
- @future 사용
- Batch Apex 사용
- 어노테이션 사용
- for 루프 사용
- 'IN' 절 사용

## 거버너 한도 이메일 경고 설정

사용자가 할당된 거버너 한도의 50%를 초과하는 Apex 코드를 호출할 때 이메일 알림을 받도록 지정할 수 있습니다.
