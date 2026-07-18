---
tags: [admin, field-set, fieldset, dynamic-forms, object-manager, metadata]
source: developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_fieldset.htm + developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_dynamic_vf_field_sets.htm + help.salesforce.com Creating and Editing Field Sets (2026-07-12)
created: 2026-07-12
aliases: [Field Set, Field Sets, 필드 집합, 필드 세트, 필드셋, FieldSet, availableFields, displayedFields]
---

# Field Sets (필드 집합)

> 오브젝트의 필드를 논리적으로 묶은 **관리자용 필드 그룹**. UI(Visualforce·LWC)가 이 그룹을 참조하면, 관리자가 필드셋에 필드를 추가/제거하는 것만으로 **코드 수정 없이** 화면에 노출 필드가 바뀐다.

---

## 개념 — Field Set이란

**Field set은 필드들의 그룹핑**이다. 공식 예: 사용자의 first name·middle name·last name·business title을 하나의 필드셋으로 묶을 수 있다.

핵심 가치는 **동적 참조(dynamic referencing)** 다. Visualforce 페이지나 LWC가 필드를 하드코딩하는 대신 필드셋을 참조하면, 페이지가 **managed package**로 배포됐을 때 구독 조직의 관리자가 코드를 건드리지 않고 표시 필드를 조정할 수 있다. 이 때문에 필드셋은 "동적 폼(dynamic form)"의 기반 도구로 쓰인다.

> 참고: 여기서 말하는 "동적 폼(코드가 필드셋을 읽어 렌더)"은 Lightning 레코드 페이지의 **Dynamic Forms** 기능과는 별개다. Field Set은 개발자/패키지가 참조하는 메타데이터 컨테이너다.

### available vs. in-the-field-set — 두 컨테이너 구분

필드셋 편집 화면에는 오브젝트 팔레트에서 필드를 끌어다 놓는 **두 개의 컨테이너**가 있다.

| 컨테이너 | 의미 |
|---|---|
| **In the Field Set** (`displayedFields`) | 기본으로 **표시되는** 필드. VF/LWC가 필드셋을 반복(iterate)하면 이 필드들이 렌더된다. **세로 순서 = 렌더 순서.** |
| **Available for the Field Set** (`availableFields`) | 필드셋에 포함되지만 **처음엔 표시되지 않는** 필드. 소비 코드가 조건에 따라 꺼내 쓸 수 있는 예비 필드. |

두 컨테이너 사이로 필드를 드래그해 이동할 수 있다. (Metadata API에서 각각 `displayedFields`·`availableFields`, 항목 타입은 `FieldSetItem`.)

---

## 설정 절차 (Setup)

> ⚠️ Setup 라벨 캐비엇: 아래 UI 라벨/경로는 help.salesforce.com·개발자 문서 기준(2026-07-12 확인). Salesforce는 릴리스마다 Setup UI 라벨을 바꿀 수 있으므로 실제 org에서 문구가 다를 수 있다.

1. **Setup → Object Manager** → 대상 오브젝트 선택 (또는 대상 오브젝트의 management settings로 이동).
2. 좌측 **Field Sets** 클릭 → **New**.
3. 생성 화면 입력:
   - **Field Set Label** — UI에 표시되는 라벨.
   - **Field Set Name** — API 참조에 쓰는 고유 이름(라벨에서 자동 파생, 편집 가능).
   - **Where is this used?** — 이 필드셋이 어떤 페이지에서 어떤 목적으로 쓰이는지 설명. managed package 구독자가 **설치된 필드셋을 자신의 필드로 채울 때** 용도를 이해하도록 돕는 설명이다.
4. **Save** 후 편집기에서 오브젝트 팔레트의 필드를 드래그해 **In the Field Set** / **Available for the Field Set** 컨테이너에 배치.
5. **In the Field Set** 목록의 **세로 순서**가 VF 페이지에서 필드가 렌더되는 순서를 결정한다.

---

## 레퍼런스 — Metadata API `FieldSet` 타입

```xml
<!-- 구조 예시 — 실제 배포 메타데이터는 org 값에 따라 다름 -->
<FieldSet>
  <fullName>properNames</fullName>
  <label>Proper Names</label>
  <description>Contact 이름 표시용 필드 묶음</description>
  <displayedFields>
    <field>Salutation</field>
    <isFieldManaged>false</isFieldManaged>
    <isRequired>false</isRequired>
  </displayedFields>
  <availableFields>
    <field>MiddleName</field>
    <isFieldManaged>false</isFieldManaged>
    <isRequired>false</isRequired>
  </availableFields>
</FieldSet>
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `label` | string | **필수.** 필드셋 참조에 쓰는 라벨. |
| `description` | string | **필수.** 개발자가 적는 필드셋 목적 설명. |
| `displayedFields` | FieldSetItem[] | VF 페이지에 표시되는 필드. **나열 순서 = 표시 순서.** |
| `availableFields` | FieldSetItem[] | 필드셋에서 사용 가능한 모든 필드. |

**FieldSetItem** 서브타입:

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `field` | string | **필수.** 표준/커스텀 오브젝트의 필드명. |
| `isRequired` | boolean | **읽기 전용.** 해당 필드가 보편적으로 필수인지. |
| `isFieldManaged` | boolean | **읽기 전용.** managed/unmanaged 패키지로 추가된 필드인지. |

FieldSet 컴포넌트는 **API v21.0 이상**에서 사용 가능. Metadata API에서 `fieldSets`는 `CustomObject` 타입의 필드로 노출된다 → [[Metadata Types — Objects & Fields]].

---

## 사용측 (위임 — 각 노트 참조)

Field Set을 **읽어 렌더/조회**하는 코드는 각 도메인 노트에 상세가 있다. 이 노트는 필드셋 자체(정의·설정·메타데이터)만 다룬다.

| 사용측 | 참조 방법 | 상세 노트 |
|---|---|---|
| **Visualforce** | `{!$ObjectType.Contact.FieldSets.properNames}` + `<apex:repeat>`/`<apex:pageBlockTable>`. managed package는 namespace 접두(`Spectre__properNames`). | [[동적 Visualforce — 바인딩·동적 컴포넌트]] |
| **Apex** | `Schema.SObjectType.Account.fieldSets.getMap()` 또는 `SObjectType.X.FieldSets.Y`, 각 멤버는 `Schema.FieldSetMember`(`.getFields()`로 순회). custom controller는 필드셋 필드를 SOQL에 직접 추가해야 함(표준 controller는 자동 로드). | [[Schema Namespace 상세]] |

> LWC에서 필드셋을 소비하는 전용 위키 노트는 아직 없다(패턴: Apex `@AuraEnabled`로 `FieldSetMember` 목록을 반환해 `lightning-record-view-form`/동적 필드 렌더에 사용). wiki에 없음 — 필요 시 추가.

---

## 한도

공식 확인된 값(Visualforce Developer Guide · 한도 레퍼런스):

| 항목 | 값 |
|---|---|
| Visualforce 단일 페이지에 표시 가능한 최대 필드셋 수 | **50** |
| sObject당 최대 필드셋 수 | **2,000** |
| 필드셋당 lookup 관계를 통한 최대 필드 수 | **25** (필드는 엔티티에서 **한 단계**까지만 span 가능) |

## 패키징 시 동작

- 필드셋은 **패키징 가능한 메타데이터**다(managed/unmanaged package로 배포).
- managed package로 설치된 필드셋의 필드는 `isFieldManaged = true`로 표시된다. 구독자는 **Available for the Field Set / In the Field Set에 자신의 필드를 추가**해 패키지 UI에 노출할 수 있으며, 이때 개발자가 적은 **Where is this used?** 설명이 용도 파악을 돕는다 — 코드 재배포 없이 UI가 조정되는 것이 필드셋의 핵심 목적이다.

---

## 관련 노트
- [[동적 Visualforce — 바인딩·동적 컴포넌트]] — `$ObjectType.X.FieldSets.Y`, `apex:repeat`로 필드셋 렌더 (VF 사용측)
- [[Schema Namespace 상세]] — `Schema.FieldSet`·`FieldSetMember`·`getFields()`·`getMap()` (Apex 사용측)
- [[Metadata Types — Objects & Fields]] — `CustomObject.fieldSets` / Metadata API `FieldSet` 타입
- [[Page Layouts (페이지 레이아웃)]] — 선언적 필드 배치의 다른 축(레이아웃 vs 필드셋)
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — 필드셋 관련 한도 원본
