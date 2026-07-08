---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Relationships in Salesforce]
---

# Salesforce의 관계(Relationships)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Lookup 관계

1. 기본적으로 두 오브젝트 간 일대다(One-Many) 연관 제공(부모 1, 자식 다수).
2. 자식 레코드 생성 시 Lookup 필드는 기본적으로 선택 사항(부모를 선택하지 않아도 됨).
3. 기본적으로 Re-Parenting 옵션 사용 가능(자식의 부모 변경 가능).
4. 부모 레코드 삭제 시 자식 레코드는 자식 오브젝트에 그대로 남음.
5. 관계 필드 생성 시 "Required" 체크박스로 Lookup 필드를 필수로 만들 수 있음.
6. Lookup 필드가 필수이면, 자식이 연결된 부모를 삭제하려 할 때 모든 자식이 제거될 때까지 부모 삭제가 허용되지 않음.
7. 오브젝트당 최대 40개의 Lookup 관계.
8. 부모·자식 레코드 모두 "Owner 필드"를 가짐.
9. 공유·보안 설정이 서로 독립적.
10. Lookup 관계에서는 표준 오브젝트를 커스텀 오브젝트의 자식으로 만들 수 있음.
11. Lookup 관계 오브젝트에는 Rollup Summary 필드를 적용할 수 없음.

## Master-Detail 관계

1. 기본적으로 일대다 연관 제공(부모는 0개 이상의 자식 가능).
2. 자식 오브젝트에 레코드가 있으면 Master-Detail 관계를 생성할 수 없음.
3. 자식 레코드 생성 시 부모 선택이 필수(Lookup 필드가 필수).
4. 기본적으로 Re-Parenting 불가. "Allow Re-Parenting" 체크박스로 수동 활성화 필요.
5. 오브젝트당 최대 2개의 Master-Detail 관계 필드.
6. 부모는 "Owner" 필드를 갖고 자식은 갖지 않음(자식이 완전히 부모의 통제 하에 들어감).
7. 자식 레코드의 공유·보안 설정이 부모에 의존.
8. 부모 삭제 시 연결된 모든 자식이 자동 삭제.
9. Master-Detail에서 표준 오브젝트를 커스텀 오브젝트의 자식으로 만들 수 없음.
10. 부모 오브젝트에 Rollup Summary 필드 추가 가능.

## Many-to-Many 관계

Salesforce는 다대다 관계를 직접 지원하지 않습니다. 정션 오브젝트(Junction Object)를 두 오브젝트 사이의 "다리"로 사용해 두 개의 일대다 관계를 만들어 구현합니다.

## Hierarchical 관계

단일 오브젝트 내에서 계층 구조를 만드는 데 사용됩니다. 예: User 오브젝트에 계층 관계를 설정해 보고 구조를 표현.

## External Lookup 관계

External ID 필드를 사용해 Salesforce 오브젝트를 외부 시스템의 외부 오브젝트와 연관시킵니다. Salesforce와 다른 시스템 간 데이터 통합이 가능합니다.

## Self-Relationship

오브젝트가 자기 자신과 관련될 때 발생합니다. 예: User 오브젝트에 self-relationship을 만들어 사용자 계층 설정.

## 표준 오브젝트 간 관계

- **Account ↔ Contact:** Lookup 관계(Account=부모, Contact=자식). Contact에 "AccountID" 공통 필드. Account 삭제 시 연결된 Contact도 자동 삭제(트리거로 방지 가능 — 삭제 전 AccountID를 비움).
- **Account ↔ Opportunity:** Lookup(Account=부모, Opportunity=자식). "AccountID" 공통 필드.
- **Account ↔ Case:** Lookup(Account=부모, Case=자식). "AccountID" 공통 필드.

참고: 일단 Lookup 또는 Master-Detail로 매핑하면, 이후 Lookup ↔ Master-Detail로 관계 유형을 변경할 수 있습니다.

## Junction Object와 생성 방법

두 오브젝트 간 다대다 연관을 직접 매핑할 수 없으므로, 두 부모와 각각 Master-Detail로 연관된 Junction Object를 만들어 구현합니다.

**표준 정션 오브젝트:**
1. Campaign ↔ Contact: "CampaignMember"
2. Contact ↔ Opportunity: "OpportunityContactRoles"
3. Opportunity ↔ Product(Product2): "OpportunityLineItem"
4. Product ↔ Pricebook(Pricebook2): "PricebookEntry"
5. User ↔ PermissionSet: "PermissionSetAssignment"

## Rollup Summary 필드

부모 레코드의 상세 페이지에 표시되는 읽기 전용 필드입니다. detail 오브젝트 관련 목록의 관련 레코드 값을 계산하며, 관련 레코드 업데이트에 따라 자동 계산됩니다. Master-Detail 관계의 Master 테이블에만 생성 가능(Lookup 불가). 예: Account의 Contact 수 계산.

**집계 함수:**
1. **Count():** 각 부모의 자식 레코드 수(정수) 반환.
2. **Sum():** 자식 레코드 필드의 합계(Number/Percent/Currency 타입에만).
3. **Max():** 자식 레코드 중 최고값(Number/Percent/Currency/Date 타입).
4. **Min():** 자식 레코드 중 최저값(Number/Percent/Currency/Date 타입).

참고: 오브젝트당 최대 25개의 Rollup Summary 필드. 모든 레코드 또는 특정 기준에 맞는 레코드만 요약 가능. Master 레코드 상세 페이지에만 표시.

## Cross Object Formula Field란?

관련 오브젝트의 필드를 참조하여 계산하거나 값을 표시하는 수식 필드 유형입니다.

핵심:
- **관계:** 오브젝트 간 관계를 활용. 부모 오브젝트(lookup/master-detail) 또는 자식 오브젝트(master-detail) 필드 참조 가능.
- **필드 참조:** 점 표기법(dot notation) 사용. 예: Account의 수식 필드에서 `Contact.Field_Name__c`로 Contact 필드 참조.
- **수식 함수:** 다양한 함수로 계산·비교·변환 수행.
- **데이터 타입:** 로직에 따라 다른 타입 반환(숫자, 텍스트, 날짜 계산 등).
- **읽기 전용:** 사용자가 직접 편집 불가.
