---
tags: [admin, data-import-wizard, data-import, csv, data-management]
source: help.salesforce.com (Salesforce Help — Salesforce Data Import; Import Data with the Data Import Wizard & Import Limits; 라이브 공식 문서, Tier 2, 접속 2026-07-02)
official_doc: https://help.salesforce.com/s/articleView?id=xcloud.data_import_wizard.htm&type=5
created: 2026-07-02
aliases: [Data Import Wizard, 데이터 임포트 마법사, 데이터 가져오기, CSV 임포트, Import Wizard, 임포트 마법사, Launch Wizard]
---

# Data Import Wizard

> Setup의 웹 기반 마법사로 표준/커스텀 오브젝트 레코드를 **CSV로 한 번에 최대 50,000건** 추가·업데이트·중복 매칭 임포트하는 도구. Data Loader의 웹 기반 보완재.

---

## 개요

**Data Import Wizard**는 Setup에 있는 웹 기반 마법사로, 데이터 필드를 매핑하고 임포트를 실행한다.

- **Available in:** Salesforce Classic + Lightning Experience. **All Editions except Database.com and Personal Editions.**
- **필요 권한:** 무엇을 임포트하는지에 따라 다르다(아래 [한도·필요 권한 표](#레코드-타입별-한도--필요-권한-import-limits) 참조).
- **할 수 있는 것:**
  - 신규 레코드 추가
  - 기존 레코드 업데이트
  - 추가 + 업데이트 동시
  - 매칭으로 **중복 방지**
- **데이터 출처:** "You can import data from ACT!, Outlook, and any program that can save data in the CSV (comma-separated values) format." (ACT!·Outlook 및 CSV 저장 가능한 모든 프로그램에서 임포트 가능.)

> 도구 선택("언제 Data Loader vs Data Import Wizard를 쓰나") 비교는 이 노트에서 재현하지 않는다 → [[Data Loader]] 노트의 비교표 참조.

---

## 지원 객체 vs 미지원 객체

| 구분 | 오브젝트 |
|---|---|
| ✅ 임포트 가능 | accounts, contacts, leads, solutions, person accounts, campaign members, **custom objects**, (articles as standard objects) |
| ❌ 임포트 불가 (Data Loader 필요) | Assets, Cases, Campaigns, Contracts, Documents, Opportunities, Products |

> 원문: *"Assets, cases, campaigns, contracts, documents, opportunities, and products can't be imported… You can't import these records via the Data Import Wizard."* → 이 오브젝트들은 [[Data Loader]]로 임포트한다.

---

## 임포트 절차 (Import Data with the Data Import Wizard)

1. **데이터 준비 및 CSV 파일 생성** — 임포트할 데이터를 준비하고 CSV 임포트 파일을 만든다. 이 단계를 먼저 하면 문제를 예방할 수 있다. (참고 FAQ: "How do I prepare my data for import?")
2. **마법사 시작** — Setup에서 Quick Find 상자에 `Data Import Wizard`를 입력한 뒤 **Data Import Wizard**를 선택한다.
3. **Launch Wizard** — welcome 페이지 정보를 검토한 후 **Launch Wizard**를 클릭한다. (오브젝트별 홈 페이지의 **Tools** 목록에서도 실행 가능.)
4. **임포트할 데이터 선택**
   - a. accounts·contacts·leads·solutions·person accounts·articles를 임포트하려면 **Standard Objects**를 클릭한다. 커스텀 오브젝트는 **Custom Objects**를 클릭한다.
   - b. 신규 추가 / 기존 업데이트 / **추가 + 기존 업데이트 동시** 중에서 선택한다.
   - c. 필요에 따라 **matching 및 기타 기준**을 지정한다. 물음표(?)에 마우스를 올리면 설명이 표시된다.
   - d. 임포트 레코드가 기준을 만족할 때 **workflow rules·processes 트리거 여부**를 지정한다.
   - e. **CSV 파일**을 업로드 영역에 드래그(또는 찾아보기)로 지정한다.
   - f. 파일의 **character encoding**을 선택한다(대개 변경 불필요).
   - g. 값 구분자로 **comma 또는 tab**을 선택한다.
   - h. **Next**를 클릭한다.
5. **필드 매핑** — 데이터 필드를 Salesforce 필드에 매핑한다. 마법사가 최대한 자동 매핑한다.
   - a. 매핑된 목록을 훑어 **매핑 안 된 필드**를 찾는다.
   - b. 각 미매핑 필드 왼쪽의 **Map**을 클릭한다.
   - c. Map Your Field 대화상자에서 검색해 **최대 10개**의 Salesforce 필드를 매핑한다(예: Account Note, Contact Note).
   - d. 자동 매핑을 바꾸려면 필드 왼쪽 **Change**를 클릭한다.
   - e. **Next**를 클릭한다.
6. **Review** — Review 페이지에서 임포트 정보를 검토한다. 미매핑 필드가 남아 매핑하려면 **Previous**를 클릭한다.
7. **Start Import**를 클릭한다.
8. **상태 확인** — 임포트 상태를 확인한다. Data Import Wizard 홈 페이지 차트가 상태·지표를 표시한다(**Recent Import Jobs** / **Bulk Data Load Jobs**).

### Setup 경로

```
// 구조 예시 — Setup 내비게이션 경로(실제 동작 데이터 아님)
Setup → Quick Find: "Data Import Wizard" → Data Import Wizard → Launch Wizard
       → Standard/Custom Objects → (Add/Update/Both + matching) → CSV 업로드
       → Next → 필드 매핑 → Next → Review → Start Import
```

### CSV 임포트 파일 예시

```
// 구조 예시 — CSV 임포트 파일 형태(실제 동작 데이터 아님)
First Name,Last Name,Email,Account Name
Ada,Lovelace,ada@example.com,Analytical Engines
```

---

## 레코드 타입별 한도 · 필요 권한 (Import Limits)

모든 레코드 타입은 **한 번에 50,000건**("50,000 at a time")까지 임포트 가능하다. 오브젝트별 필요 권한은 아래와 같다.

| 레코드 타입 | 한도 | 필요 권한 |
|---|---|---|
| Business accounts and contacts **owned by you** | 50,000 at a time | **Import Personal Contacts** |
| Business accounts and contacts **owned by other users** | 50,000 | **Modify All Data** |
| Person accounts **owned by you** | 50,000 | **Create on accounts** AND **Edit on accounts** AND **Import Personal Contacts** |
| Person accounts **owned by other users** | 50,000 | **Create on accounts** AND **Edit on accounts and contacts** AND **Modify All Data** |
| Leads | 50,000 | **Import Leads** |
| Campaign members | 50,000 | 임포트 대상에 따라 다름: Campaign member statuses / Existing contacts / Existing leads / Existing person accounts / New contacts / New leads |
| Custom object | 50,000 | **Import Custom Objects** AND **Create on the custom object** AND **Edit on the custom object** |
| Solutions | 50,000 | **Import Solutions** |
| Assets, Cases, Campaigns, Contracts, Documents, Opportunities, Products | — | DIW로 임포트 불가 |

### 파일 · 레코드 한도

- 임포트 파일은 **최대 100 MB**, 단 파일 내 각 레코드는 **400 KB**를 초과할 수 없다.
- 레코드당 **최대 90개 필드**를 임포트할 수 있다.
- 각 임포트되는 note와 description은 **32 KB**를 초과할 수 없다(32 KB 초과 텍스트는 잘림).
- 기타 **Bulk API limits**가 적용된다. 레코드 누락 또는 필드 잘림 시 Bulk API Limits를 참조한다.

---

## 관련 노트
- [[Data Loader]] — 50,000건 초과·미지원 객체(Assets·Cases·Opportunities 등)·정기/CLI 적재용 보완 도구. 도구 선택 비교표("언제 Data Loader vs Data Import Wizard")는 그 노트에 있음.
