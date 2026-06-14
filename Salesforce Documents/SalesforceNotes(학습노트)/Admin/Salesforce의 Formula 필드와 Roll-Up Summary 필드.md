---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Formula & Roll-Up Summary Fields in Salesforce]
---

# Salesforce의 Formula 필드와 Roll-Up Summary 필드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Formula 필드란?

다른 필드, 레코드, 함수를 기반으로 값을 자동 계산하는 읽기 전용 필드입니다.

**특징:**

값을 동적으로 계산(참조 필드 변경 시 자동 업데이트), 오브젝트 간 작동(관련 오브젝트 필드 참조 가능), 논리·수학 함수 지원(계산·텍스트 연결·IF 문), 사용자 편집 불가(읽기 전용).

**사용 예:**
1. 생년월일로 나이 계산: `TODAY() - Birthdate`
2. 전체 이름 표시: `FirstName & " " & LastName`
3. 금액 > $50,000이면 "High Value": `IF(Amount > 50000, "High Value", "Normal")`

## 2. Roll-Up Summary 필드란?

관련 자식 레코드의 데이터를 집계하는 읽기 전용 필드입니다(Master-Detail 관계에서만 작동).

**특징:**

자식 레코드 데이터 집계(Master-Detail 관계), SUM·COUNT·MIN·MAX 계산, 자식 레코드 변경 시 자동 업데이트, 오브젝트 간 참조 불가(같은 관계 내에서만).

**사용 예:**
1. Account의 총 Case 수: COUNT(관련 Case 수)
2. 모든 Opportunity의 총 매출: SUM(모든 Opportunity 금액 합)
3. 고객의 가장 빠른 주문 날짜: MIN(가장 빠른 주문 날짜)
4. Account의 최근 결제 날짜: MAX(가장 최근 결제 날짜)

## 3. Formula 필드 생성

1단계 - Object Manager: Setup → Object Manager → 오브젝트 선택 → Fields & Relationships → New.
2단계 - Formula 타입 선택: Formula 선택 → Next → 필드 이름·설명 입력 → 반환 타입 선택(Text, Number, Date 등).
3단계 - 수식 작성: 함수·연산자 사용(IF, TODAY, TEXT 등) → Check Syntax로 검증 → Save.

## 4. Roll-Up Summary 필드 생성

1단계 - Object Manager: Setup → Object Manager → 부모 오브젝트 선택 → Fields & Relationships → New.
2단계 - Roll-Up Summary 타입 선택: Roll-Up Summary 선택 → Next → 필드 이름·설명 입력.
3단계 - 자식 오브젝트·계산 타입 선택: 관련 자식 오브젝트 선택(Master-Detail 관계여야 함) → 계산 타입 선택(SUM, COUNT, MIN, MAX) → Save.

## 모범 사례

- 단순한 수식 우선(성능 저하 방지)
- 리포트 대신 Roll-Up 필드 사용(데이터 자동 계산으로 시간 절약)
- 너무 많은 수식 필드 금지(레코드 저장 속도 영향)
- 배포 전 샌드박스에서 테스트
- 오브젝트 간 롤업에는 Workflow나 Flow 사용(Roll-Up Summary는 Master-Detail에서만 작동하므로 Lookup 관계에는 Flow 사용)
