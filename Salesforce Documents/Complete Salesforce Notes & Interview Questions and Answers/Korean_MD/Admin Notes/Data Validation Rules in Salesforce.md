---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Data Validation Rules in Salesforce]
---

# Salesforce의 데이터 검증 규칙(Validation Rule)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Validation Rule이란?

레코드에 입력된 데이터를 확인하여 특정 조건을 충족하지 않으면 저장을 막는 규칙입니다.

**특징:**
- 데이터 정확성과 일관성 보장
- 표준 및 커스텀 오브젝트에서 작동
- 검증에 수식 로직 사용
- 커스텀 오류 메시지 표시
- 레코드 저장 전 발동

**사용 예:** 과거 날짜의 Close Date로 Opportunity 생성 방지, 전화번호를 항상 올바른 형식으로 입력하도록 보장, 10% 초과 할인에 관리자 승인 요구.

## 2. 작동 방식

검증 규칙은 다음으로 구성됩니다:
1. **수식 조건(TRUE/FALSE 반환)** — 규칙이 발동할 시점 정의
2. **오류 메시지** — 조건이 충족될 때(검증 실패 시) 표시

**예시 수식:**
- Close Date가 미래인지 확인: `CloseDate < TODAY()`
- 전화번호가 10자리인지: `LEN(Phone) <> 10`
- 할인이 20%를 초과하지 않는지: `Discount__c > 0.2`

## 3. 생성 단계

1단계 - Object Manager로: Setup → Object Manager → 오브젝트 선택(예: Account, Opportunity) → Validation Rules → New.

2단계 - 규칙 정의: 규칙 이름 입력, 수식 조건 작성(예: `ISBLANK(Phone)`), 오류 메시지 입력(예: "Phone Number is required"), 오류 위치 선택(필드 또는 페이지 상단).

3단계 - 저장 & 테스트: Save → 유효하지 않은 데이터를 입력해 오류 메시지 확인.

## 4. 모범 사례

- 검증 규칙은 단순하게 유지(복잡한 수식은 저장을 느리게 함)
- 의미 있는 오류 메시지 사용(명확하고 친절하게)
- 배포 전 샌드박스에서 테스트
- AND/OR로 조건 결합(더 나은 성능)
- 여러 오브젝트가 관련된 복잡한 검증에는 Flow 사용 고려
