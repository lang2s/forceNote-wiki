---
tags: [admin, limits, allocations, custom-objects, custom-fields, relationships, edition-limits, reference]
source: help.salesforce.com (Custom Fields Allowed Per Object / Considerations for Object Relationships / Picklist Limitations / Rich Text Area Field Considerations / Edition Allocations — 라이브 공식 문서, Tier 2, 접속 2026-07-12) · salesforce_app_limits_cheatsheet.pdf (Developer Limits and Allocations Quick Reference, Last updated May 8 2026, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=platform.custom_field_allocations.htm&type=5
created: 2026-07-12
aliases: [Object Field Limits, 오브젝트 필드 한도, custom fields per object, 오브젝트당 커스텀 필드, custom objects per edition, 에디션별 커스텀 오브젝트, relationships per object, 오브젝트당 관계 필드, 정적 설정 한도, static setup limits]
---

# Object & Field Limits (오브젝트·필드 한도)

> "막히는 순간 찾는" **정적 설정 한도** 모음 — 에디션별 커스텀 오브젝트/필드 수, 오브젝트당 관계·Master-Detail·Roll-Up Summary·Field History·Validation/Restriction Rule 한도, Long/Rich Text·Picklist 크기. **런타임 거버너(SOQL 100·DML 150 등)는 범위 밖** → [[Governor Limits]].

> [!note] 범위 구분
> - **이 노트 = 정적 설정(schema/customization) 한도.** org·edition·오브젝트 단위로 고정되며 배포·저장 시점에 걸린다.
> - **[[Governor Limits]] = Apex 트랜잭션 런타임 한도** (실행마다 리셋: SOQL 100/DML 150·Heap·CPU 등).
> - **[[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] = org/플랫폼 API 할당량** (24시간 API 콜·Bulk·Metadata·SOSL·VF).
> - 에디션별 수치 상당수는 SPA 헬프(로그인·라이브 렌더)라 **검색 스니펫으로 교차 확인**했다. 표에 `공식 확인 필요` 표시된 값은 org의 Setup 또는 Salesforce 담당자로 최종 확인한다.

---

## ① 커스텀 오브젝트 수 (에디션별)

| Edition | 생성 가능 커스텀 오브젝트 | 비고 |
|---|---|---|
| Enterprise (EE) | **200** | 확인됨 |
| Unlimited / Performance (UE/PE) | **2,000** 생성 + managed package로 **1,000** 추가 설치 | 확인됨 |
| Professional (PE) | 공식 확인 필요 (edition별 상이) | Setup·담당자 확인 |
| Developer (DE) | 공식 확인 필요 (edition별 상이) | Setup·담당자 확인 |
| **하드 한도 (전 org)** | **3,000** 총 커스텀 오브젝트 | org 내 생성 + 설치 합계. edition·라이선스 무관. Salesforce 지원 요청으로 상향 가능(*Increase the Custom Object Limit*) |

> 커스텀 오브젝트의 개념·생성 흐름은 [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]]. 3,000 하드 한도는 org 전체 합계 기준이라 대형 org·다수 managed package 설치 시 실제로 부딪힌다.

---

## ② 커스텀 필드 수 / 오브젝트 (에디션별)

| Edition | 직접 생성 | Managed Package 추가 설치 | 오브젝트 하드 한도 |
|---|---|---|---|
| Enterprise (EE) | **500** | + **400** (AppExchange certified managed package) | — |
| Unlimited / Performance (UE/PE) | **800** | + **100** (certified managed package) | **900** |
| 그 외 모든 오브젝트 | — | — | **800** |

- EE는 직접 500개까지 만들고, certified managed package가 별도로 400개를 추가할 수 있다(합산 시 오브젝트별 유효 상한은 위 하드 한도를 따른다).
- UE/PE는 직접 800 + package 100 = 하드 상한 **900**.
- 표준·커스텀 오브젝트 모두 **800**이 일반 하드 한도이며, UE/PE의 900은 예외적 상향치다.
- 이 한도 초과가 예상되면 필드 통합·[[Custom Metadata Types]] 이관·별도 오브젝트 분리를 검토한다.

> 근거: Salesforce Help — *Custom Fields Allowed Per Object* / *Increase Maximum Number of Custom Fields per Entity*.

---

## ③ 관계 필드 · Master-Detail

| 항목 | 한도 | 근거 |
|---|---|---|
| **오브젝트당 관계 필드 수** (lookup + master-detail 합계) | 커스텀 오브젝트 **40** | app_limits 치트시트: "A custom object allows up to **40 relationships**". *Increase the maximum relationships*로 상향 요청 가능 |
| **오브젝트당 Master-Detail 관계 수** | 최대 **2** | 오브젝트는 최대 2개의 master를 가질 수 있다(2개면 junction object = many-to-many) |
| **Master-Detail 중첩 깊이** | 최대 **3단계** (custom detail levels) | 기본 2단계, 최대 3단계까지 커스텀 detail 계층 허용 |
| M-D 자식→다른 관계의 부모 | 제약 있음 | 한 master-detail의 detail이 동시에 다른 master-detail의 master가 되는 조합에 제약(중첩 규칙) |

```
// 구조 예시 — 오브젝트당 관계 한도(실제 원본 다이어그램 아님)
CustomObject__c
├── 관계 필드(lookup + master-detail) 합계 ≤ 40
├── Master-Detail ≤ 2   (2개면 Junction = M:N)
│     └── 중첩 detail 계층 ≤ 3단계
└── Roll-Up Summary(master 측) ≤ 25 기본 / 40 지원 상향
```

> Lookup vs Master-Detail 개념·동작 차이는 [[Object Relationships]]. SOQL 관계 쿼리 쪽 한도(child-to-parent 55·parent-to-child 20·depth 5)는 [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]]의 "SOQL·SOSL 검색 한도" 참조 — 스키마 한도와 쿼리 한도는 별개다.

---

## ④ Roll-Up Summary 필드 / 오브젝트

| 항목 | 값 |
|---|---|
| 오브젝트당 Roll-Up Summary 필드 (기본) | **25** |
| 지원(support) 요청으로 상향 가능한 최대 | **40** |
| 전제 조건 | **Master-Detail의 master 측**에만 정의 가능 (lookup 불가) |

> COUNT/SUM/MIN/MAX 계산 유형·집계 불가 필드·재계산 동작 등 상세는 [[Roll-Up Summary 필드]]. 40 초과가 필요하면 DLRS·Flow 우회.

---

## ⑤ Field History 추적 필드 / 오브젝트

| 항목 | 값 |
|---|---|
| 오브젝트당 추적 필드 (기본) | **20** (표준·커스텀 조합) |
| **Field Audit Trail** 구매 시 | **60** |

> multi-select picklist·large text는 "값 변경 여부만" 추적, 보존 기간·Field Audit Trail 상세는 [[Field History Tracking (필드 이력 추적)]].

---

## ⑥ 규칙(Rule) 한도

| 규칙 | 오브젝트당 한도 | 상세 노트 |
|---|---|---|
| **활성(active) Validation Rule** | 대부분 객체 **100** (edition별 상향 가능) | [[Validation Rules 예제]] |
| **활성 Restriction Rule** | EE·Developer **2** / Performance·Unlimited **5** | [[Restriction Rules (제한 규칙)]] |
| **Lookup Filter** | 공식 확인 필요 (오브젝트/필드별) | — |

- Validation Rule 한도 도달 시 **기존 규칙을 비활성화해야** 새 규칙을 켤 수 있다.
- Restriction Rule은 **오브젝트당·사용자당 유효 rule 1개** — 한 사용자에게 2개가 걸리면 하나만 관찰된다.

---

## ⑦ Formula 크기 한도

| 한도 | 값 | 설명 |
|---|---|---|
| Formula **소스** 텍스트 | 3,900 characters | 편집기 입력 상한 |
| Formula **컴파일** 크기 | **5,000 bytes** | 실무에서 저장 막히는 주 원인 — 참조 필드 전개로 폭증 |

> 소스가 3,900자 미만이어도 컴파일 5,000 bytes를 넘으면 `Compiled formula is too big to execute` 오류. 상세·회피책은 [[Formula 필드]] · [[Validation Rules 예제]].

---

## ⑧ Long Text · Rich Text 크기

| 항목 | 값 |
|---|---|
| Long Text Area / Rich Text Area 필드 **최대 크기** | 각 **131,072** characters (~32 페이지) |
| 한 오브젝트 내 **모든** long/rich text 필드 합계 상한 | **1,638,400** characters |
| Rich Text Area 이미지·서식 | 지원 (HTML 저장, 이미지 삽입·하이퍼링크) |

> Rich Text Area 세부 제약(허용 태그·이미지 크기 등)은 Salesforce Help *Rich Text Area Field Considerations*. 오브젝트 하나에 대용량 텍스트 필드를 무제한으로 늘릴 수 없음(합계 상한).

---

## ⑨ Picklist 값 한도

| 항목 | 값 |
|---|---|
| 커스텀 Picklist **값 개수** | 최대 **1,000** |
| Picklist 값 하나의 길이 | 최대 **255** characters |
| Multi-Select Picklist — 한 레코드에서 선택한 값 **합계 길이** | **40,000** characters |
| Multi-Select Picklist 총 값 개수 / 한 번에 선택 가능 수 | 공식 확인 필요 (관례상 값 500·선택 100로 알려짐 — 최종 확인 요) |

> Global Value Set·Dependent Picklist·Controlling↔Dependent 값 매핑 상세는 [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]].

---

## ⑩ 기타 오브젝트/필드 관련 정적 한도

| 항목 | 값 | 출처 |
|---|---|---|
| sObject당 Field Set 수 | **2,000** | app_limits 치트시트(VF 섹션) |
| VF 단일 페이지에 표시 가능한 Field Set | 50 | app_limits 치트시트 |
| Field Set 하나에서 lookup 관계로 가져오는 필드 | 25 | app_limits 치트시트 |

---

## 범위 밖 (여기서 다루지 않음)

| 주제 | 위임 |
|---|---|
| Apex 트랜잭션 런타임 거버너 (SOQL 100·DML 150·Heap·CPU) | [[Governor Limits]] |
| API 콜·Bulk·Metadata·SOQL 쿼리·Visualforce 할당량 | [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] |
| 데이터·파일 Storage 할당량, 이메일 발송 한도 | Salesforce "Features and Edition Allocations" 문서 소관 |

---

## 관련 노트
- [[Governor Limits]] — 런타임 거버너 한도(이 노트의 짝, 범위 상보)
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — org/플랫폼 API 할당량
- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] — 오브젝트·필드 생성 개념
- [[Object Relationships]] — Lookup·Master-Detail 관계 동작
- [[Roll-Up Summary 필드]] — 25/40 한도 상세
- [[Field History Tracking (필드 이력 추적)]] — 20/60 추적 필드 상세
- [[Validation Rules 예제]] — active 100·컴파일 5,000 bytes
- [[Restriction Rules (제한 규칙)]] — 오브젝트당 active rule 2/5
- [[Formula 필드]] — Formula 크기 한도
- [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]] — picklist 값·의존 피클리스트
