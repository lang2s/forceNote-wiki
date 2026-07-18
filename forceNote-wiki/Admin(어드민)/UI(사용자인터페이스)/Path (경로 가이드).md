---
tags: [admin, path, guidance-for-success, picklist, record-type, lightning-experience, sales-path, ux]
source: help.salesforce.com (Salesforce Help — Guide Users with Path / Considerations and Guidelines for Creating Paths; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
official_doc: https://help.salesforce.com/apex/HTViewHelpDoc?id=sf.path_overview.htm&language=en_US
created: 2026-07-12
aliases: [Path, 경로 가이드, Path Assistant, 경로 어시스턴트, Guidance for Success, Sales Path, Path Settings, PathAssistant]
---

# Path (경로 가이드)

> 레코드가 비즈니스 프로세스의 각 **단계(step)** 를 어떻게 진행하는지 레코드 페이지 상단에 시각적으로 안내하는 UX. picklist 필드(Opportunity Stage·Lead Status·Case Status·custom picklist) 값을 단계로 펼치고, 단계마다 **Key Fields**·**Guidance for Success**·**Celebration**을 제공한다.

---

## 개념

**Path**(구 Sales Path / Path Assistant)는 사용자를 비즈니스 프로세스의 단계들로 안내한다 — 예: "fresh lead에서 successfully closed deal까지 opportunity를 진행". 각 단계에서 관리자는 **중요 필드를 강조(highlight key fields)** 하고 **성공을 위한 맞춤 안내(customized guidance for success)** 를 제공할 수 있다.

- 화면상 레코드 페이지 상단에 단계들이 **chevron(꺾쇠) 바** 형태로 표시되고, 사용자는 현재 단계를 보며 다음 단계로 진행한다.
- 단계의 원천은 **picklist 필드의 값**이다. 대표적으로:
  - **Opportunity** → Stage
  - **Lead** → Lead Status
  - **Case** → Case Status
  - 그 외 오브젝트의 **custom picklist** 필드
- 같은 오브젝트·record type·picklist로 구성된 **Kanban 뷰**에도 동일한 key fields·guidance·celebration이 함께 반영된다.

### 지원 범위 / 전제 조건

| 항목 | 값 |
|---|---|
| 필요 환경 | **Lightning Experience** (Salesforce mobile app의 Lightning 레코드 페이지 포함) |
| 에디션 | Professional Edition 이상 |
| 관리 권한 | **Modify All Data** 또는 **Customize Application** |
| 단계 원천 | **picklist 필드** (Record Type별로 유효한 값 집합) |
| 오브젝트당 Path 수 | **record type 하나당 Path 하나** (Each object can have one path per record type) |
| 지원 오브젝트 | 19개 표준/커스텀 오브젝트(Lead·Opportunity·Account·Contact·Campaign·Case·Contract·Quote·Order·Asset·custom object 등) |

> [!note] Setup 라벨 캐비엇 (2026-07-12)
> Setup UI의 메뉴/버튼 라벨(예: "Path Settings", "New Path", "Enable")은 릴리스에 따라 문구·위치가 바뀔 수 있다. 아래 절차는 공식 문서 기준이며, 실제 org의 라벨과 다르면 org 화면을 우선한다.

---

## 설정 절차

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (공식 절차 순서 요약)
Setup → Path Settings
  └─ Enable (Path 기능 활성화)
  └─ New Path
       1) Path Name / API Name 입력
       2) Object 선택        (예: Opportunity)
       3) Record Type 선택   (해당 오브젝트에 record type이 있으면)
       4) Picklist 필드 선택 (예: Stage / Status / custom picklist)
       └─ 단계(step)별 설정 = 선택한 picklist의 각 값
            · Key Fields          — 그 단계에서 강조할 필드 (최대 5개)
            · Guidance for Success — 리치텍스트 안내 (최대 1000자)
            · Celebration          — 특정 값 도달 시 confetti(축하) 애니메이션
       └─ 최종 단계(final step) 지정
       └─ Activate (활성화)
  └─ Lightning App Builder → 레코드 페이지에 "Path" 컴포넌트 배치
```

1. **Path Settings 열기 → Enable.** Setup에서 Path Settings로 이동해 기능을 활성화한다.
2. **New Path.** Path 이름을 입력하고 **Object → Record Type → Picklist 필드**를 차례로 선택한다. picklist의 값들이 곧 Path의 단계가 된다.
3. **단계별 Key Fields 지정.** 각 단계에서 사용자가 채워야 할 필드를 강조한다. **한 단계당 최대 5개.**
   - **Record Type**과 **Owner** 필드는 Key Fields 패널에서 편집 불가. 소유권 이전은 Details 탭, record type 변경은 **Change Record Type** 액션으로 처리한다.
4. **Guidance for Success 작성.** 단계마다 팁·정책·다음 액션을 리치텍스트로 안내한다. **최대 1000자.**
5. **Celebration(선택).** 특정 단계 값(예: Closed Won) 도달 시 **virtual confetti** 애니메이션을 표시한다.
   - API 이름에 콤마(`,`)가 든 필드 값은 celebration 미지원 → API 이름의 콤마를 제거하거나 값을 재생성한다. (label의 콤마는 무방)
6. **최종 단계 지정 후 Activate.**
7. **Lightning 페이지에 배치.** [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]]로 대상 오브젝트의 레코드 페이지를 열어 **Path** 컴포넌트를 추가한다. 이 컴포넌트가 없으면 Path를 활성화해도 화면에 나타나지 않는다.

---

## Metadata 레퍼런스

Path는 Metadata API의 **`PathAssistant`** 타입으로 표현되며(`Metadata` 타입을 extends), 각 단계는 하위 필드로 담긴다.

| Metadata 요소 | 의미 |
|---|---|
| `PathAssistant` | Path 정의 1건 (오브젝트·record type·picklist 필드 바인딩) |
| `PathAssistantStep` | Path의 개별 단계 — picklist 값 하나에 대응, 해당 단계의 key fields·guidance 정보 보유 |

- 관련 위키: [[Metadata Types — UI & Layout]](PathAssistant 타입 목록) · [[2GP — Components - UI & Layout]](PathAssistant 패키징 Manageability Rules)

---

## 관련 노트

- [[Record Types (레코드 타입)]] — Path의 record type 축. record type별로 유효 picklist 값이 달라 Path 단계 구성이 달라진다
- [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]] — Path 단계의 원천이 되는 picklist 필드·값 관리
- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] — 완성한 Path를 레코드 페이지에 Path 컴포넌트로 배치
- [[Metadata Types — UI & Layout]] — `PathAssistant` 메타데이터 타입
