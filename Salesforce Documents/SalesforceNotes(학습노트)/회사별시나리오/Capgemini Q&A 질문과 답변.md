---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Capgemini Interview Questions]
---

# Capgemini Q&A 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Q1. Cascade 삭제란?** 부모 레코드 삭제 시 관련·자식 레코드를 삭제하는 기능. 데이터 무결성 유지·고아 레코드 방지.

**동기 vs 비동기?** 동기는 순차적 — 스레드가 작업 완료를 기다린 후 다음 작업으로(단일 스레드). 예: 트리거. 비동기는 작업 완료를 기다리지 않고 다른 스레드에서 실행(시스템이 한가할 때). 예: @future.

**Batch Apex에서 Future 호출?** 불가. 단, @future가 포함된 웹서비스를 Batch에서 호출하는 대안 가능.

**시나리오: Batch 실행 중 실패·성공 레코드 ID 얻기?** Database.Stateful 구현으로 처리된 레코드 상태 유지.

**트리거 이벤트 / 컨텍스트 변수?** 모든 트리거는 System.Trigger 클래스의 암시적 변수로 런타임 컨텍스트에 접근.

**Web-to-Case?** 회사 웹사이트에서 고객 지원 요청을 수집해 자동으로 새 Case 생성.

**비동기 유형?** Batch, Queueable, Scheduled, Future.
