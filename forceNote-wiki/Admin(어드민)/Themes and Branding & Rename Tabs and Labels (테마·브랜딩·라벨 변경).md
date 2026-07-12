---
tags: [admin, themes, branding, rename, labels, lightning-experience, slds, setup]
source: help.salesforce.com — "Personalize Your Org with Themes and Branding" / "Create a Custom Theme" / "Activate a Theme" / "Considerations for Themes and Branding" / "Rename Object, Tab, and Field Labels" / "Considerations for Renaming Tab and Field Labels" (Tier 2, 확인 2026-07-12)
created: 2026-07-12
aliases: [Themes and Branding, Custom Theme, 테마, 브랜딩, Rename Tabs and Labels, Rename Object Tab Field Labels, 탭 이름 변경, 오브젝트 라벨 변경, 라벨 변경, Account를 거래처로]
---

# Themes and Branding & Rename Tabs and Labels (테마·브랜딩·라벨 변경)

> LEX org에 브랜드 테마(색·로고·배경)를 입히는 **Themes and Branding**과, 표준 오브젝트·탭·필드의 화면 라벨을 조직 용어로 바꾸는 **Rename Tabs and Labels** — 둘 다 Setup에서 클릭으로 하는 조직 커스터마이즈 기능이다.

---

## 1. Themes and Branding (테마·브랜딩)

Lightning Experience에서 조직 전체의 시각적 브랜드를 정의한다. 내장 테마(preset 색·이미지)를 그대로 쓰거나, 자사 색·로고·배경을 담은 **커스텀 테마**를 만들어 활성화한다. 테마는 Salesforce Lightning Design System(SLDS) 위에 구축된다.

- **접근:** Setup → Quick Find 상자에 `Themes and Branding` 입력 → **Themes and Branding** 선택.
- **에디션:** Lightning Experience 전용. Group, Essentials, Professional, Enterprise, Performance, Unlimited Edition에서 사용 가능.
- **필요 권한:**
  - 회사 정보 보기 → **View Setup and Configuration**
  - 테마 활성화·생성·편집·미리보기 → **Customize Application**

### 1-1. 내장 테마 (built-in)

공식 문서에서 확인되는 내장 테마 (수정·복제 불가):

| 내장 테마 | 비고 |
|---|---|
| **Lightning Blue** | 기본 테마 중 하나. Chatter External 사용자는 항상 이 테마만 본다. 오래된 조직의 기본값 |
| **Salesforce Cosmos** | 조직 생성 시점에 따라 기본으로 지정되는 테마 (SLDS 2 계열) |
| **Lightning Lite** | 내장 테마. 앱의 brand image·색상이 항상 이 테마와 Lightning Blue를 override |

> 기본으로 어떤 내장 테마가 적용되는지는 **조직이 언제 생성됐는지**에 따라 Lightning Blue 또는 Salesforce Cosmos로 갈린다. (근거: "Salesforce Cosmos Theme and SLDS 2 Availability")
> ⚠️ 위 3종 외의 preset 내장 테마 이름은 이번 소스에서 확인되지 않아 나열하지 않는다.

### 1-2. 커스텀 테마 생성

1. Setup → `Themes and Branding` → **Themes and Branding**.
2. **New Theme** 클릭 → 커스텀 **SLDS 2** 테마 생성. 또는 **New SLDS 1 Theme**를 클릭해 커스텀 SLDS 1 테마 생성.
   - SLDS 2 테마는 최신 디자인 시스템 기반으로 CSS 스타일링 훅·차세대 컴포넌트·최신 웹 표준 등 고급 커스터마이즈로 이어진다.
3. 테마를 커스터마이즈: **브랜드 색상**, **로고**, 기본 **group·user profile 배너** 등을 추가. 커스텀 SLDS 2 테마는 **advanced accent colors**를 설정 가능(→ Manage Custom Configurations for Themes).
4. 변경 사항 **Save**.
5. **Preview**로 미리 보거나 **Activate**로 전체 사용자에게 라이브 적용.

- **최대 300개**의 커스텀 테마를 만들 수 있다. 단 Salesforce 제공 내장 테마는 **수정·복제 불가**.
- (SLDS 1) 링크·브랜드 버튼에 자사 색을 그대로 쓰려면 편집 화면에서 **Override accessibility brand color** 체크박스 선택. 단 접근성 저하로 텍스트 가독성이 나빠질 수 있고, Global Navigation Divider·status·flow 컴포넌트에서는 override 불가.

### 1-3. 테마 활성화

Setup → Themes and Branding에서 커스텀/내장 테마 옆 아이콘 클릭 후:

- **View** — 색·이미지·접근성 설정 등 테마 상세 보기
- **Preview** — 적용 모습 테스트
- **Activate** — 조직에 즉시 적용, 사용자에게 바로 보임

> SLDS 1 ↔ SLDS 2 전환 시: 현재 SLDS 1 테마인데 SLDS 2 테마를 활성화하면 **Activate를 한 번 더 클릭**해 SLDS 2 활성화 의사를 확인해야 한다(반대 방향도 동일 — SLDS 2 비활성화 확인). SLDS 2 테마 활성화 = 조직에 SLDS 2 활성화, SLDS 2→SLDS 1 변경 = SLDS 2 비활성화.

### 1-4. 제약 (Considerations)

- 조직은 **활성 테마를 하나만** 가질 수 있고, 그 테마가 **조직 전체**에 적용된다.
- 테마는 **Salesforce Classic·네이티브 모바일 앱에는 적용되지 않는다**.
- **Chatter External** 사용자는 내장 **Lightning Blue** 테마만 본다.
- App Manager에서 테마 override 옵션을 선택하지 않았더라도, **앱의 brand image·색상은 항상 Lightning Lite·Lightning Blue 테마를 override**한다.
- 일부 앱·영역은 SLDS 2를 지원하지 않는다 — 미지원 영역은 SLDS 2가 비활성 상태로 표시된다.

---

## 2. Rename Tabs and Labels (탭·라벨 변경)

거의 모든 오브젝트·필드·탭의 **화면 라벨**을 조직이 이미 쓰는 용어로 바꿔, 사용자 전환을 돕는다. 예: "Accounts" 오브젝트·탭을 **"Companies"**로, "Account Name" 필드를 **"Company Name"**으로.

- **접근:** Setup → Quick Find 상자에 `Rename Tabs and Labels` 입력 → **Rename Tabs and Labels** 선택.
- **에디션:** Salesforce Classic·Lightning Experience 양쪽. Essentials, Professional, Enterprise, Performance, Unlimited, Developer Edition.
- **필요 권한:** **Customize Application** 또는 **Manage Translation** 또는 (번역자로 지정된 경우) **View Setup and Configuration**.

### 2-1. 변경 절차

1. Setup → `Rename Tabs and Labels`.
2. 페이지 상단 **Select Language** 드롭다운에서 기본 언어 선택.
   - (Hebrew는 동사 성(gender) 일치 문제로 탭 rename을 최소화 권장.)
3. 바꿀 탭 옆 **Edit** 클릭. 원래 이름으로 되돌리려면 **Reset**. (⚠️ **커스텀 오브젝트 탭 이름은 Reset 불가**.)
4. 새 탭 이름의 **단수형·복수형**을 입력.
5. (해당 언어에 적용되면) 라벨이 모음 소리로 시작할 때 **Starts with a vowel sound** 체크 → 영어의 "a/an" 같은 관사가 올바르게 붙는다. **Next**.
6. 표준 필드 라벨·기타 UI 요소의 라벨을 입력. **단수·복수형 모두** 입력.
   - Created By, Last Modified By 등 **시스템 정보를 추적하는 일부 표준 필드는 의도적으로 rename 대상에서 제외**된다.
7. **Save**. 조직에서 쓰는 다른 언어마다 이 절차 반복(= 번역 적용).

- 새 이름은 사용자가 보는 **모든 페이지**, Salesforce for Outlook, Connect Offline에 나타난다.
- 이름 충돌 금지: rename 시 다른 **표준 탭·커스텀 오브젝트·외부 오브젝트·커스텀 탭**의 이름은 쓸 수 없다.
- **사용 불가 문자:** `#`, `$`, `%`, `;`, `<`, `=`, `>`, `[`, `]`, `^`, `` ` ``, `|`, `~`.

### 2-2. rename 불가 / Setup 캐비엇

- **모든 표준 탭·오브젝트가 rename 가능한 것은 아니다.** 예: **Forecasts 탭은 rename 대상에 없다**.
- **Salesforce Help와 대부분의 Setup 페이지는 표준 오브젝트·필드·탭을 항상 원래 이름으로 표시**한다.
- LEX에서 Lightning 기반 Setup 페이지는 **바뀐 라벨**을 쓰지만, **Salesforce Classic Setup 페이지**(Classic이든 LEX Setup에 임베드됐든)는 **기본·원래 라벨**을 쓴다.
- 바뀐 라벨은 Personal Setup 포함 모든 사용자 페이지에 나타난다.

### 2-3. Translation Workbench와의 관계

- **표준 오브젝트는 Translation Workbench에서 다룰 수 없다** — 표준 오브젝트 번역은 **rename tabs and labels 인터페이스**로 한다. (근거: "Metadata Available for Translation")
- 여러 언어로 라벨을 번역하려면 위 절차를 **언어마다 반복**한다.
- 커스텀 리포트·대시보드·프로파일·퍼미션셋·커스텀 필드·리스트뷰 등에 남은 원래 이름은 rename 후 별도로 바꾼다. 라벨은 **Translation Workbench**로 수정 가능. 표준 리포트는 **Save As**로 새 이름 폴더에 저장.

### 2-4. rename 후 수동 업데이트 필요 항목

rename은 화면 라벨만 바꾸므로, 아래는 원래 이름이 남아 있어 **직접 갱신**해야 한다:

- **리스트뷰:** 이름을 수정한 적 없는 built-in 리스트뷰(예: All Accounts)는 자동으로 새 이름 반영. 사용자가 이름을 바꿨던 built-in·사용자 생성 리스트뷰는 원래 오브젝트 이름을 계속 표시.
- 원래 오브젝트·필드 이름을 담은 **이메일 템플릿**의 제목·설명.
- 원래 이름을 담은 **커스텀 필드·페이지 레이아웃·레코드 타입** 등 기타 커스터마이즈 항목.
- 커스텀 오브젝트의 커스텀 탭은 요청 언어 번역이 없으면 커스텀 오브젝트의 기본 언어(오브젝트 생성 당시 조직 기본 언어)로 표시.

> 💡 API 이름은 바뀌지 않는다: rename은 **라벨**만 변경하며, 필드/오브젝트의 API 이름과 이를 참조하는 수식·코드에는 영향이 없다.

---

## 구조 예시 — Setup 경로·라벨 매핑 (실제 UI 값 아님)

```text
// 구조 예시 — 실제 동작 설정 아님 (Setup 내비게이션·rename 매핑 개념도)

Setup ▸ Quick Find ─┬─ "Themes and Branding"   → 테마 생성/활성화 (LEX, Customize Application)
                    └─ "Rename Tabs and Labels" → 라벨 변경 (Classic+LEX, Customize Application)

Rename 매핑 예:
  Object  Account       → 거래처 (Companies)
  Tab     Accounts      → 거래처 (Companies, 단수/복수 별도 입력)
  Field   Account Name  → 거래처명 (Company Name)
  ▸ 표준 오브젝트 번역은 Translation Workbench가 아니라 이 인터페이스로 처리
  ▸ Forecasts 탭·Created By/Last Modified By 필드 = rename 불가
```

---

## 관련 노트
- [[Lightning Apps & Tabs (라이트닝 앱·탭)]]
- [[Custom Labels (커스텀 레이블)]]
