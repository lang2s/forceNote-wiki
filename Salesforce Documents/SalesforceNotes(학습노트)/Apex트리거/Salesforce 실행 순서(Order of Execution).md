---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Order of Execution]
---

# Salesforce 실행 순서(Order of Execution)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했으며, 표준 실행 순서로 정리했습니다.)

레코드가 저장될 때 Salesforce는 다음 순서로 로직을 적용합니다:

1. **원본 레코드 로드(업데이트 시):** DB에서 기존 레코드를 로드하거나 새 레코드 초기화.

2. **새 필드 값 로드:** 요청의 새 값으로 기존 값 덮어쓰기.

3. **시스템 검증 규칙:** 필수 필드, 필드 형식, 최대 길이 등 검증으로 잘못된 데이터 거부. (DB 수준 작업.)

4. **Before-Save Flow(레코드 트리거 플로우):** 저장 전 같은 레코드 필드 업데이트. 많은 경우 Apex보다 효율적. Flow Builder로 관리자가 생성.

5. **Before 트리거:** 레코드 커밋 전 실행. 저장 전 값 수정·검증. 예: 전화번호 형식 재포맷.

6. **시스템 검증 재실행 + 커스텀 검증 규칙:** 필수 필드·레이아웃 규칙 재확인, 사용자 정의 검증 규칙 실행. (검증 실패 시 트랜잭션 롤백 → 트리거 실패 가능.)

7. **레코드 DB 저장(미커밋):** 레코드 저장되나 아직 커밋되지 않음.

8. **After 트리거:** 저장 후 실행. 관련 레코드 업데이트나 알림 전송. 예: Opportunity의 after-insert 트리거가 관련 Task 생성.

9. **할당 규칙(Assignment Rules):** Lead·Case 자동 할당.

10. **자동 응답 규칙(Auto-Response Rules):** Lead·Case 자동 응답.

11. **워크플로우 규칙(Workflow Rules):** 비즈니스 프로세스 자동화. 필드 업데이트 시 before·after 트리거 한 번 더 실행.

12. **프로세스·플로우(Process Builder):** 선언적 자동화 실행. 필드 업데이트 시 트리거 재실행.

13. **에스컬레이션 규칙(Escalation Rules):** Case 에스컬레이션.

14. **부모 롤업 요약 필드·크로스 오브젝트 업데이트:** 부모 레코드 업데이트(추가 워크플로우·트리거 발동 가능).

15. **Criteria 기반 공유 규칙 평가.**

16. **DB 커밋:** 모든 DML 작업을 DB에 커밋. 이후 레코드 잠금·공유 규칙 최종 평가.

17. **커밋 후 로직(Post-Commit):** 이메일 전송, future 메서드 호출, 배치 작업 실행 등 비동기 작업(메인 트랜잭션 차단 방지).
