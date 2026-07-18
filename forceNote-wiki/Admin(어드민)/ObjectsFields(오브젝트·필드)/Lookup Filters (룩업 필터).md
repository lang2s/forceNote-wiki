---
tags: [admin, lookup-filter, relationship, data-integrity, metadata-api, customfield, dependent-lookup]
source: help.salesforce.com — Lookup Filters / Considerations / Limitations (Tier 2) · developer.salesforce.com — Metadata API CustomField.lookupFilter, Tooling API LookupFilter (Tier 2) · 확인일 2026-07-12
created: 2026-07-12
aliases: [Lookup Filter, 룩업 필터, 조회 필터, lookupFilter, Dependent Lookup, 종속 룩업, Filtered Lookup]
---

# Lookup Filters (룩업 필터)

> 관계 필드(lookup·master-detail·hierarchical)에서 **선택 가능한 후보 레코드를 조건으로 제한**하는 선언적 데이터 무결성 도구. 사용자가 아무 레코드나 연결하지 못하도록 조회 대화상자와 저장 값을 걸러낸다.

**상위:** [[Salesforce 어드민 종합 개요]] → [[00 Home]]

---

## 개념

Lookup filter는 lookup, master-detail, hierarchical 관계 필드에 붙어, 그 필드가 참조할 수 있는 **유효한 값과 조회 대화상자(lookup dialog) 결과를 제한**한다. 예를 들어 Case의 Account Name에 특정 Account가 선택됐을 때 Contact 필드에는 그 Account에 속한 Contact만 보이도록 만들 수 있다.

필터 조건은 세 종류의 컬럼을 비교한다.

- **대상(target/related) 오브젝트의 필드** — 후보 레코드가 가진 필드 (예: Contact.AccountId)
- **소스(source) 오브젝트의 필드** — `$Source` (현재 편집 중인 레코드의 필드). 소스 필드를 참조하면 **dependent lookup(종속 룩업)** 이 된다.
- **전역 변수·리터럴 값** — `$User`(현재 사용자), `$Profile`(현재 프로필) 등 전역 변수 또는 고정 값

### Required vs Optional 필터 (핵심 차이)

| | **Required (필수)** | **Optional (선택)** |
|---|---|---|
| 동작 | 조건을 **강제** — 조회 대화상자에 매칭 레코드만 표시되고, 사용자가 직접 입력한 무효 값은 **저장 차단** | 기본으로 필터가 적용되지만, 사용자가 필터를 **끄고 전체 값을 볼 수 있음** |
| 무효 값 저장 시 | 오류 메시지 표시(관리자 커스터마이즈 가능) → 저장 불가 | 저장 허용(경고 성격) |
| cross-object 참조 카운트 | 대상 오브젝트의 **unique relationship 한도에 카운트됨** | 카운트되지 않음 |
| Lightning Experience | 그대로 required | **모두 required로 취급** — Setup에서 optional로 지정해도 Lightning에서는 required로 동작 |

> Classic에서는 관리자가 required/optional을 선택할 수 있으나, **Lightning Experience에서는 모든 lookup filter가 required로 강제**된다(optional 지정도 무시). 무효 값에는 커스터마이즈 가능한 오류 메시지가 뜬다.

---

## 설정 절차 (Setup)

> Setup UI 라벨은 릴리스에 따라 달라질 수 있다(확인일 2026-07-12 기준).

1. Setup → Object Manager → 대상 오브젝트 → **Fields & Relationships** → 관계 필드 편집(Edit).
2. **Lookup Filter** 섹션에서 필터를 활성화한다.
3. **필터 조건(filter criteria)** 을 행 단위로 지정한다:
   - **Field** — 대상(관련) 오브젝트의 필드, 또는 `$Source.<필드>`(소스 레코드 필드)
   - **Operator** — equals, not equal to, less/greater than, contains, starts with, includes, excludes 등
   - **Value/Field** — 리터럴 값, 전역 변수(`$User`, `$Profile`), 또는 비교할 다른 필드
4. **Filter Type** — Required 또는 Optional 선택(Lightning에선 실질 required).
5. **Error message**(required 필터에서 무효 값 저장 시) 와 **Additional Information / info message**(조회 화면에 표시할 도움말) 를 작성.
6. 저장 후 **Active** 상태로 활성화.

여러 조건은 `booleanFilter`(고급 필터 로직, AND/OR/NOT)로 조합할 수 있다.

---

## Metadata API 표현 (`CustomField.lookupFilter`)

API v30.0+에서 lookup filter는 CustomField의 `lookupFilter` 요소로 배포된다. (v17.0~29.0에서는 별도 `NamedFilter` 타입 — v30.0에서 제거됨. 참고: [[Metadata Types — Objects & Fields]])

`LookupFilter` 구조:

| 필드 | 타입 | 설명 |
|---|---|---|
| `active` | boolean (필수) | true면 필터 활성 |
| `isOptional` | boolean (필수) | true면 optional 필터, false면 required |
| `booleanFilter` | string | filterItems에 적용할 불리언 로직(AND/OR/NOT) |
| `filterItems` | FilterItem[] (필수) | 필터 조건 집합. **필터당 최대 10개** |
| `errorMessage` | string | required 필터 검증 실패 시 표시할 오류 메시지 |
| `infoMessage` | string | 조회 화면에 표시할 안내 문구 |
| `description` | string | 필터 설명 |

`FilterItem` 구조:

| 필드 | 타입 | 설명 |
|---|---|---|
| `field` | string | 조건에 쓰는 필드명 |
| `operation` | FilterOperation enum | equals, notEqual, lessThan, greaterThan, lessOrEqual, greaterOrEqual, contains, notContain, startsWith, includes, excludes, within |
| `value` | string | 비교 값(리터럴) |
| `valueField` | string | 값 대신 참조할 필드(예: `$Source.<필드>`, `$User.<필드>`). 승인 프로세스는 `valueField`를 지원하지 않음 |

```xml
<!-- 구조 예시 — 실제 동작 설정 아님. Case.ContactId를 Account에 종속시키는 dependent lookup -->
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>ContactId</fullName>
    <type>Lookup</type>
    <referenceTo>Contact</referenceTo>
    <lookupFilter>
        <active>true</active>
        <isOptional>false</isOptional>
        <booleanFilter>1</booleanFilter>
        <errorMessage>선택한 Account에 속한 Contact만 지정할 수 있습니다.</errorMessage>
        <infoMessage>Account Name에 선택된 계정의 연락처만 표시됩니다.</infoMessage>
        <filterItems>
            <field>Contact.AccountId</field>
            <operation>equals</operation>
            <valueField>$Source.AccountId</valueField>
        </filterItems>
    </lookupFilter>
</CustomField>
```

---

## 한도 (공식 확인)

| 항목 | 값 | 비고 |
|---|---|---|
| 오브젝트당 활성 **required** lookup filter | **최대 5개** | Salesforce 지원 케이스로 상향 요청 가능 |
| 필터당 filter item(조건) | **최대 10개** | Metadata API `filterItems` 기준 |
| Optional 필터의 cross-object 참조 | 카운트 안 됨 | required만 대상 오브젝트의 unique relationship 한도에 카운트 |

- **Cross-object 참조**: required lookup filter가 관련 오브젝트의 필드를 참조하면, 그 필드 각각이 참조 대상 오브젝트의 **unique relationship 허용 수**에 카운트된다(소스 오브젝트에는 카운트 안 됨). optional 필터는 이 한도에 포함되지 않는다.
- **Dependent lookup(종속 룩업)**: 필터가 소스 오브젝트의 필드(`$Source`)를 참조하는 lookup filter. 예 — Case의 Contact를 Account Name에 종속.
- **Lightning 주의**: 조회 필터 조건에 참조된 필드가 **page layout 또는 list view에 추가돼 있지 않으면 Lightning Experience에서 필터가 동작하지 않는다.** 참조 필드를 레이아웃/리스트 뷰에 반드시 노출한다.

---

## 관련 노트

- [[Object Relationships]] — lookup·master-detail·hierarchical 관계 정의(무결성 도구가 붙는 대상 필드)
- [[Validation Rules 예제]] — 저장 시점 데이터 무결성 강제(무결성 짝 — validation rule은 값 검증, lookup filter는 후보 제한)
- [[Metadata Types — Objects & Fields]] — CustomField·NamedFilter 등 필드 메타데이터 타입
- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] — 관계 필드 생성 절차
