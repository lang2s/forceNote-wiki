---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Approval Process]
---

# 승인 프로세스(Approval Process)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했습니다.)

## 소개

Salesforce의 승인 프로세스는 중요한 레코드가 체계적으로 승인되도록 보장하는 자동화 프로세스입니다. 사용자나 Queue가 레코드를 승인/거부하는 단계의 조합이며, 비즈니스를 효율적으로 운영하도록 돕습니다.

## 왜 승인 프로세스인가?

- **적절한 검토:** 중요한 레코드가 올바른 사람에 의해 확인·승인되도록 함.
- **시간 절약:** 프로세스 자동화로 수동 후속 작업 감소.
- **일관성 유지:** 모든 승인이 같은 규칙·단계를 따르도록 함.
- **오류 감소:** 최종 확정 전 추가 검토 계층으로 실수 방지.

## 레코드

1. 레코드가 사전 정의된 승인 프로세스를 통해 라우팅되어 체계적 검토·결정 보장.
2. 거래 규모나 레코드 타입 같은 특정 조건에 따라 승인 트리거 가능.
3. 사용자가 승인 진행 상황을 추적하고 상세 이력 조회 가능.

**참고:**
- **승인자(Approver):** 제출된 요청을 승인하는 사용자.
- **위임 승인자(Delegated Approver):** 승인자가 부재 시 그를 대신해 승인/거부할 사용자.
- 승인 프로세스가 활성화되면 새 승인 단계를 추가할 수 없습니다.

## Submit for Approval

사용자가 Submit for Approval 버튼을 클릭하면 승인 대기 중인 레코드가 자동 표시됩니다. 관리자나 승인자가 레코드를 검색할 필요가 없어 편리합니다. 버튼 클릭 후 메시지 입력과 Submit 버튼이 있는 팝업이 나타납니다.

## 기준(Criteria)

- **Jump Start Wizard:** 사용자 친화적 단계별 가이드로 초기 구성을 간소화. 사전 제작 템플릿 제공.
- **Standard Setup Wizard:** 특정 비즈니스 요구에 맞춘 상세 설정 옵션 안내. 구조화된 워크플로우.

## 최초 제출 액션(Initial Submission Action)

1. **Field Update:** 특정 오브젝트의 승인 프로세스에 대해 필드 업데이트.
2. **Task Creation:** User, Role, Record Owner, Record Creator에게 작업 생성·할당.
3. **Email Alert:** 승인 요청자에게 요청 접수 알림 / 승인자에게 승인 요청 접수 알림.
4. **Outbound Message:** 액션 트리거 시 외부 시스템으로 SOAP 메시지 전송.

## 승인자의 결정

1. **단일 승인자(Single Approver):** 요청이 한 사람에게 감. 승인/거부/재할당 가능. 승인 시 진행, 거부 시 Salesforce가 레코드 업데이트·알림.
2. **다중 승인자(Multiple Approvers):** 요청이 여러 사람에게 감. 두 규칙: First Response Wins(첫 승인/거부가 최종 결정), All Must Approve(모두 승인해야 진행).

**기타 액션:**

Reassign(다른 사람에게 요청 전달), Recall(제출자가 승인 전 변경을 위해 요청 회수).

## 승인 단계(Approval Steps)

1. 레코드 검토·승인에 관여하는 액션과 승인자의 순서 정의.
2. 각 단계는 기준 기반 승인자를 가질 수 있어 레코드가 단계로 진입하도록 허용.
3. 완전 승인되면 필드 업데이트, 알림 전송 같은 추가 액션 정의 가능.

## 최종 제출 액션(Final Submission Action)

- **Field Update:** 특정 레코드 세부 정보 변경·업데이트.
- **Assign Task:** 사용자에게 후속 작업 부여.
- **Email Alert:** 승인 관련 이메일 알림.
- **Notification:** 관련 사용자에게 승인 알림.

## 최종 거부 액션(Final Rejection Action)

- **Field Update:** 거부를 나타내도록 레코드 상태 변경.
- **Email Alert:** 거부 이메일 알림.
- **Assign Task:** 필요 시 후속 작업 생성.
- **Notification:** 관련 사용자에게 거부 알림.

## Recall(회수)

승인 요청을 제출했지만 갑자기 레코드 정보를 업데이트해야 하면 승인 요청을 회수할 수 있습니다. 단, 회수 가능 여부는 관리자가 승인 프로세스를 어떻게 구성했는지에 따라 다릅니다.

## 결론

- 구조화된 워크플로우 보장(승인 자동화로 명확·조직화)
- 시간 절약·효율 증가(자동 승인·알림·업데이트)
- 추적·책임성 개선(모든 승인·거부 기록으로 투명성 향상)
