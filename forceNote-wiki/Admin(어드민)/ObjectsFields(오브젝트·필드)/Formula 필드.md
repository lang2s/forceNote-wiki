---
tags: [admin, formula-field, custom-field, cross-object-formula, customization]
source: help.salesforce.com (Salesforce Help — Extend Salesforce with Clicks, Not Code; Build a Formula Field; 라이브 공식 문서, Tier 2, 접속 2026-07-03) + Tips for Reducing Formula Size tip sheet (salesforce_formula_size_tipsheet.pdf, Tier 2 — 컴파일 5,000 bytes 한도)
official_doc: https://help.salesforce.com/s/articleView?id=platform.customize_formulas.htm&type=5
formula_size_doc: https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/salesforce_formula_size_tipsheet.pdf
created: 2026-07-03
aliases: [Formula Field, 수식 필드, 포뮬러 필드, Cross-Object Formula, 크로스오브젝트 수식, Check Syntax]
---

# Formula 필드

> 다른 필드·연산자·함수·리터럴로부터 값을 **자동 계산**하는 read-only 커스텀 필드. 저장 공간 없이 파생 값을 표시하며, cross-object 수식으로 관련 오브젝트의 값도 참조한다.

---

## 개념

커스텀 formula 필드는 다른 필드·연산자·함수·리터럴 값 등으로부터 값을 **자동 계산**한다. 값이 자동 계산되기 때문에 record detail 페이지와 edit 페이지 모두에서 **read-only**로 표시되며, edit 페이지에는 편집 대상 필드로 나타나지 않는다.

| 항목 | 내용 |
|---|---|
| Available in | **All Editions** |
| 사용 환경 | Salesforce Classic + Lightning Experience |
| 값 저장 | 저장 공간을 쓰지 않고 조회 시 파생 값 계산 (read-only) |

### 필요 권한

| 작업 | 필요 권한 |
|---|---|
| formula 필드 상세 **보기** | View Setup and Configuration |
| formula 필드 **생성·변경·삭제** | Customize Application |

---

## 생성 절차

커스텀 필드를 만드는 것과 동일한 흐름으로 시작한 뒤, formula 전용 단계가 이어진다.

1. 커스텀 필드를 만드는 것과 동일하게 시작한다.
2. formula의 **data type**(반환 타입)을 선택한다.
3. 반환 타입이 currency·number·percent이면 **소수 자릿수**를 선택한다.
4. **Next**.
5. formula를 작성한다. formula 필드는 공백을 포함해 **최대 3,900자**까지 가능하다.
6. 오류를 확인하려면 **Check Syntax**를 클릭한다.
7. (선택) 설명을 입력한다.
8. number·currency·percent 필드를 참조하는 경우 **blank 필드 처리 옵션**을 선택한다 — 빈 값을 **0으로 볼지**, **빈 값(blank)으로 볼지** 지정.
9. **Next**.
10. **field-level security**를 설정한다 (특정 프로파일에 노출 여부).
11. 필드를 표시할 **page layout**을 선택한다 (첫 섹션의 마지막 필드로 추가된다).
12. **Save**.

---

## Cross-Object Formula

**Cross-object formula**는 두 개의 관련 오브젝트에 걸쳐, 그 오브젝트들의 merge 필드를 참조하는 formula다. 오브젝트 간 관계를 따라 필드를 참조하며 **최대 10개 관계**까지 거슬러 올라갈 수 있다.

### merge 필드 주의 (person account 예외)

account formula에서는 모든 **business account 필드**를 merge 필드로 사용할 수 있다. 단, **person account 전용 필드**(예: Birthdate, Email)는 예외로 사용할 수 없다.

---

## 한도·주의 (Formula Size)

formula 필드에는 **두 가지 별개의 크기 한도**가 있다. 실무에서 저장이 막히는 원인은 보통 후자(컴파일 크기)다.

| 한도 | 값 | 설명 |
|---|---|---|
| **문자 수** | 최대 **3,900자** (공백 포함) | 편집 화면에 타이핑할 수 있는 원본 텍스트 길이 |
| **컴파일 크기** | 최대 **5,000 bytes** | Salesforce가 formula를 내부적으로 컴파일한 결과의 크기 |

- 컴파일된 formula가 5,000 bytes를 초과하면 저장이 거부되며 **`Compiled formula is too big to execute (max 5,000 bytes)`** 오류가 발생한다.
- 컴파일 크기는 **원본 텍스트 길이와 무관**하다 — 공백·주석 제거, 필드명 짧게 바꾸기 등으로 문자 수를 줄여도 컴파일 크기는 줄지 않는다.
- **여러 formula 필드로 쪼개도 근본 해결이 안 된다** — 하위 formula 필드를 참조하면 그 하위 필드의 컴파일 크기가 참조하는 필드에 **합산**되기 때문이다.
- **회피법(정석):** 로직을 **Flow 또는 워크플로 field update**로 분산해, 계산 결과를 일반 필드에 써 넣고 formula에서는 그 값을 참조한다. 이렇게 하면 컴파일 크기가 합산되지 않는다.

> 컴파일 크기 축소 상세 기법은 공식 **"Tips for Reducing Formula Size"** tip sheet를 참조한다.

---

## 구성 요소 (Elements of a Formula)

formula는 다음 요소로 구성된다.

- **필드 참조** — 같은 오브젝트 또는 관계를 따라간 관련 오브젝트의 필드
- **연산자** — 값 결합·비교
- **함수** — 내장 계산·변환 함수
- **리터럴 값** — 상수(숫자·문자열 등)

> 연산자·함수 카탈로그는 방대하다. 전체 목록은 공식 **"Operators and Functions"** 문서를 참조한다.

---

## 수식 예시

```
// 구조 예시 — formula 필드 예시(실제 동작 검증 전)
반환타입: Currency
formula:  Amount * Discount__c        // 같은 오브젝트 필드 참조
cross-object: Account.AnnualRevenue   // 관계 따라 상위 오브젝트 참조(최대 10관계)
검증: [Check Syntax] → 저장 → detail/edit 페이지에서 read-only 표시
```

---

## 관련 노트
- [[Roll-Up Summary 필드]] — master-detail의 detail 레코드를 집계하는 또 다른 자동 계산 필드
- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] — formula는 커스텀 필드 생성 시 선택하는 필드 타입
