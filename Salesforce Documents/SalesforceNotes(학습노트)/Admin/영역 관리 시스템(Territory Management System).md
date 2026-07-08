---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Territory management  system]
---

# 영역 관리 시스템(Territory Management System)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Salesforce의 영역 관리 시스템은 조직이 영업팀에 영역을 효과적으로 관리·할당하도록 돕는 기능입니다. 지리, 산업, 계정 규모, 기타 커스텀 기준에 따라 영업 담당자·계정·기회를 조직하고 정렬하는 구조화된 방법을 제공합니다. 더 나은 계정 커버리지, 공평한 업무 분배, 더 정확한 예측·리포팅을 보장합니다.

## 주요 구성 요소

1. **영역(Territories):** 유사한 특성·기준(위치, 매출 규모, 산업 등)을 공유하는 계정 그룹. 계정과 영업 담당자가 어떻게 정렬되는지 정의.
2. **영역 계층(Territory Hierarchy):** 조직의 영업 영역을 나타내는 계층 구조(예: Country > Region > City). 여러 영역 관리와 사용자 할당의 유연성 보장.
3. **규칙 기반 할당(Rules-Based Assignment):** 지리, 산업, 매출 같은 규칙에 따라 계정을 영역에 할당. 기준 기반 수식으로 커스터마이징 가능.
4. **사용자(Users):** 영업 담당자·관리자가 특정 영역에 할당. 한 사용자가 역할·책임에 따라 여러 영역에 속할 수 있음.
5. **예측 통합(Forecasting Integration):** 영역 기반 예측으로 영역별 매출 예측. 특정 영역 내 계정의 잠재 매출에 대한 명확한 뷰 제공.

## 기능

1. **유연한 모델링:** 기존 워크플로우에 영향 없이 동적으로 영역 구조 조정. 배포 전 여러 영역 모델 생성·테스트.
2. **계정 할당:** 적절한 영역에 자동·수동 할당. 계정이 여러 영역에 속할 수 있음.
3. **사용자 접근 제어:** 영역 할당에 따라 계정·기회·기타 레코드 접근 정의. 보안·규정 준수 유지.
4. **영역 유형:** 논리적 분류·조직을 위한 커스터마이징 가능 유형(예: Sales Territory, Service Territory).
5. **리포팅·대시보드:** 영역별 성과·기회·예측 인사이트 제공.
6. **Enterprise Territory Management(ETM):** Enterprise Territory Model, 복제, 시뮬레이션 같은 고급 기능을 제공하는 향상된 버전.

## 이점

1. 향상된 영업 커버리지(누락 계정 없음)
2. 최적화된 업무 분배(공평한 기회)
3. 비즈니스 목표와의 정렬(시장 침투, 매출 성장)
4. 향상된 협업(중첩 영역 간 협업)
5. 증가된 유연성(변화하는 요구에 맞춰 조정)

## 사용 사례 예시

**시나리오:**

인도 전역에 제품을 판매하는 회사가 영업 커버리지 최적화를 원함.
- **영역 구조:** Level 1=India, Level 2=North/South/East/West, Level 3=개별 주(예: Maharashtra, Tamil Nadu).
- **할당 규칙:** 주와 매출 규모에 따라 계정 할당.
- **사용자:** "Maharashtra – High Revenue" 또는 "South Region – Small Accounts" 같은 영역에 할당.
- **결과:** 지역별 영업 성과의 명확한 가시성, 중첩·공백이 적은 효율적 계정 관리.

## ETM 활성화 단계

1. Setup에서 ETM 활성화
2. 영역 분류를 위한 Territory Type 생성
3. Territory Model 정의 및 계층 구축
4. 계정 할당을 위한 Assignment Rule 설정
5. 관련 영역에 사용자 할당
6. 변경 적용을 위한 Model 활성화
7. 리포트·대시보드로 성과 추적

## 한계

1. 복잡한 구성(비즈니스 프로세스 깊은 이해 필요)
2. 계정 중심(다른 오브젝트에 대한 범위 제한)
3. 유지보수 노력(비즈니스 성장에 따라 영역 규칙·할당 정기 업데이트 필요)
