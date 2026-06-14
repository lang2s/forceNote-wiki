---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Data Skew in Salesforce]
---

# Salesforce의 Data Skew

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Data Skew란?

특정 레코드나 데이터 세트가 고르지 않게 분포·집중되어, 특히 대용량 데이터에서 성능 문제나 기능 불일치를 일으키는 상황을 말합니다. 세 가지 주요 유형:

**1. Ownership Skew(소유권 편향)**
- 많은 레코드를 단일 사용자가 소유할 때 발생.
- 공유 재계산과 가시성 검사에서 성능 저하 유발.
- 해결책: 여러 사용자에게 소유권 분산, 적극 관리되지 않는 레코드에 "dummy" 사용자 사용.

**2. Lookup Skew(룩업 편향)**
- Lookup 관계에서 많은 자식 레코드가 단일 부모 레코드와 연결될 때 발생.
- 부모 레코드의 충돌 업데이트를 방지하려는 Salesforce 때문에 잠금(locking) 문제 유발.
- 모범 사례: 가능하면 자식 레코드를 여러 부모에 분산, 필요 시 관계 구조 재고.

**3. Foreign Key Skew(외래 키 편향)**
- 많은 레코드가 같은 외래 키를 공유할 때(예: 많은 레코드가 같은 Account와 연결) 발생.
- 업데이트 시 성능 문제, 공유 재계산에 영향.
- 회피: 관련 레코드를 여러 외래 키·Account에 분산.
