---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Important Question on Apex Trigger]
---

# Apex 트리거 핵심 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했습니다.)

**트리거란?**

insert·update·delete·undelete 같은 데이터 조작 이벤트 전후에 실행되는 Apex 코드 블록. 레코드 변경 기반 커스텀 로직·프로세스 자동화.

**두 가지 유형?**

Before(레코드 저장 전, 데이터 수정·검증), After(저장 후, DB에 데이터가 있어야 하는 작업).

**트리거 클래스의 용도?**

트리거 이벤트 발생 시 실행되는 로직을 담아 영향받은 레코드 처리(커스텀 액션·검증·업데이트·관련 레코드 생성).

**트리거 이벤트?**

Before Insert/Update/Delete, After Insert/Update/Delete/Undelete.

**트리거 vs 자동화 사용 시점?**

복잡·커스텀 로직이 필요하면 트리거. 단순 시나리오는 Workflow·Process Builder·Flow.

**모범 사례:**

단일 관심사에 집중, 코드 벌크화, 루프 안 DML 회피, Custom Settings·Custom Metadata로 구성 데이터 저장, 명명 규칙·주석, 트리거 프레임워크.

**Upsert 이벤트에서 트리거 실행 횟수?**

레코드 배치당 한 번(200개 upsert 시 배치 전체에 한 번).

**실행 순서:**

Before 트리거 → 시스템 검증 규칙 → Duplicate 규칙 → After 트리거 → 할당 규칙 → 자동 응답 규칙 → 워크플로우 규칙 → 프로세스 → 에스컬레이션 규칙 → 롤업 요약 필드 → 커밋 후 로직(이메일).

**Before vs After 선택?**

저장 전 검증·수정은 Before, 저장된 데이터가 필요한 작업(이메일·관련 레코드 생성)은 After.

**Trigger.New vs Trigger.newMap?**

New는 삽입·업데이트된 새 버전 레코드 목록, newMap은 sObject ID→레코드 맵.

**Trigger.Old 사용 시점?**

업데이트·삭제 전 이전 버전 레코드 제공. 변경 비교, 이전 상태 기반 작업.

**재귀 방지?**

static 변수로 현재 컨텍스트에서 트리거 실행 여부 추적.

**트리거 프레임워크?**

트리거 개발을 조직·간소화하는 클래스·메서드 집합(예: Trigger Factory 패턴, Kevin O'Hara의 Apex Trigger Framework).

**검증 규칙 vs 트리거?**

검증 규칙은 선언적 설정으로 데이터 품질·무결성 강제(나쁜 데이터 방지). 트리거는 복잡·커스텀 데이터 조작·자동화를 위한 Apex 코드.
