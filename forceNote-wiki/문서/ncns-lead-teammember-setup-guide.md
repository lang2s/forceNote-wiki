# NCNS Custom Related List (신규 LWC) — 설정 레퍼런스 (Lead 팀멤버 기준)

> **문서 유형: 레퍼런스(Reference)** — 신규 LWC 카드의 속성 25종·설정값·매핑표를 조회하는 문서입니다. §2의 배치 절차만 하우투 성격입니다.
> 동작 원리와 Aura 대비 차이는 [설명 문서](ncns-customrelatedlist-explanation.md) 참조.
> 작성일: 2026-07-07 · [문서 인덱스](index.md) · 관련: [신규 LWC 배포 목록](ncnsCustomRelatedList-deployment-list.md) · [기존 Aura 기능 목록](lead-teammember-relatedlist-deployment-list.md)

---

## 1. 이 구성에 사용되는 신규 컴포넌트

| 신규 LWC | 역할 |
|----------|------|
| `ncnsCustomRelatedList` | 관련 목록 카드 본체 — App Builder에 **"NCNS Custom Related List (LWC)"** 로 표시 |
| `ncnsLeadTeamMemberEditBtn` | "팀 멤버 추가" 헤더 버튼 (`buttonComponent` 속성으로 동적 로딩) |
| `ncnsLeadTeamMemberEditModal` | 팀멤버 다중입력 그리드 모달 (LightningModal) |
| `ncnsRecordLookup` | 모달 내 User 검색 룩업 (역할별 조건부 필터) |
| `ncnsRelatedListViewAllModal` | 전체보기 대형 모달 (`useStandardViewAll=false`일 때) |
| `ncnsRlUtils` | 내부 공용 유틸 (화면에 직접 노출 안 됨) |

> ⚠️ 배포는 위 6개만이 아니라 **신규 14개 전체**가 필요합니다 — 카드가 버튼 5종을 전부 동적 import로 참조하므로 일부만 배포하면 컴파일 오류가 납니다. 전체 목록과 배포 명령은 [신규 LWC 배포 목록](ncnsCustomRelatedList-deployment-list.md) 참조.
> Apex/트리거/개체/CMDT/라벨은 **기존 것을 그대로 사용** (신규 생성 없음).

## 2. App Builder 배치 방법

1. Lead 레코드 페이지 편집 (톱니바퀴 → *Edit Page*)
2. 좌측 Components 팔레트 **Custom** 영역에서 **"NCNS Custom Related List (LWC)"** 를 원하는 영역에 드래그
3. 우측 속성 패널에 아래 §3의 값 입력 → Save → Activation

버튼(`ncnsLeadTeamMemberEditBtn`)과 모달은 별도 배치하지 않습니다 — `buttonComponent` 속성에 이름만 지정하면 런타임에 헤더로 주입됩니다.

## 3. 속성 설정 — Lead 팀멤버 값

기존 Aura 카드와 속성이 1:1 동일하므로 기존 페이지의 값을 그대로 옮기면 됩니다.

| 속성 (라벨) | Lead 팀멤버 설정값 | 설명 |
|-------------|-------------------|------|
| Parent Record 필드 명 (`parentFieldName`) ※필수 | `Id` | 현재 레코드에서 부모 Id를 읽을 필드. `Id`면 현재 레코드 자신이 부모 |
| 조회 대상 개체 (`targetObject`) | `LeadTeamMember__c` | 관련 목록으로 보여줄 자식 개체 |
| 현재 대상 개체 (`currentObject`) | `Lead` | 현재 페이지 개체 (Community 대응용) |
| 검색 필드 (`columns`) | `User__c,LeadAccess__c,LeadRole__c` | 표시 컬럼 (콤마 구분). 참조필드는 자동으로 링크+라벨 처리 |
| WHERE 조건 (`condition`) | `LeadId__c = :parentId` | 부모 참조는 반드시 `:parentId` 사용 |
| 기본 정렬 필드 (`orderBy`) | `CNS_fm_Order__c` | 역할 우선순위 수식 필드로 정렬 |
| 기본 정렬 방향 (`sortDirection`) | `asc` | |
| 데이터 표시 개수 (`limitRecord`) | `30` | 초과 시 건수에 `+` 표기 |
| 버튼 컴포넌트 이름 (`buttonComponent`) | `CNS_LeadTeamMemberEditBtn` **또는** `ncnsLeadTeamMemberEditBtn` | §4 매핑표 참조 — 기존 Aura 이름 그대로 입력해도 동작 |
| 컴포넌트 고유 식별 키워드 (`uniqueIdentifier`) | `LeadTeamRelatedList` | 같은 페이지 다중 배치 시 구분 / LMS refresh 대상 식별 |
| 표준 New 사용 (`useStandardNew`) | `false` | 커스텀 버튼을 쓰므로 표준 New 숨김 |
| 표준 View All 사용 (`useStandardViewAll`) | `false` | 커스텀 전체보기 모달 사용 |
| Relation Field API (`relationField`) | `LeadId__c` | (표준 New 사용 시) 부모 자동연결 필드 |
| Relationship Name (`relationShipName`) | `LeadTeamMembers` | (표준 View All 사용 시) Child Relationship |
| Edit / Delete 액션 (`useEdit` / `useDelete`) | `true` / `true` | 행 액션 노출 (Edit는 레코드 수정권한 있을 때만) |
| 수정가능여부 플래그 필드명 (`editableField`) | (공백) | Boolean 필드 지정 시 그 값과 AND로 편집 제어 |
| 체크 박스 표시 여부 (`hideCheckboxColumn`) | `false` | ※ Aura와 동일하게 **의미가 반전**되어 있음 — `false`=체크박스 표시 |
| 선택 가능한 Row 수 (`maxRowSelection`) | `N` | (Aura와 동일하게 실동작 없음 — 설정 호환용) |
| 열 너비 모드 (`columnWidthsMode`) | `auto` | `auto`/`fixed` |
| 아이콘 이름 (`iconName`) | `standard:account` | SLDS 아이콘 |
| 제목 (`title`) | (공백) | 공백이면 개체 복수 라벨 자동 사용 |
| 표준 New 사전정의 필드값 (`defaultFieldValues`) | (공백) | JSON 문자열 (표준 New 사용 시) |
| Without Sharing 여부 (`withOutSharing`) | `false` | true면 공유규칙 무시 조회 |
| (미사용) Read Only (`readOnly`) | `false` | 호환용 |

## 4. buttonComponent 이름 매핑 (하위호환)

`buttonComponent`에는 **기존 Aura 이름과 새 LWC 이름 둘 다 입력 가능**합니다 (대소문자 무관, 콤마로 다중 지정).

| 기존 Aura 이름 (그대로 입력 가능) | 실제 로딩되는 신규 LWC |
|-----------------------------------|------------------------|
| `CNS_LeadTeamMemberEditBtn` | `ncnsLeadTeamMemberEditBtn` |
| `CNS_OpptyTeamMemberEditBtn` | `ncnsOpptyTeamMemberEditBtn` |
| `CNS_OpptyShareByAbdEditBtn` | `ncnsOpptyShareByAbdEditBtn` |
| `CNS_OpptyShareImpEditBtn` | `ncnsOpptyShareImpEditBtn` |
| `CNS_PnfSyncByProjectCodebtn` | `ncnsPnfSyncByProjectCodeBtn` |

미등록 이름은 콘솔 경고 후 무시됩니다 (화면 오류 없음).

## 5. 동작 원리 / Aura 대비 차이 → 설명 문서로 이동

저장 시 화면·Apex·트리거의 동작 흐름, 자동 갱신 3경로, Aura 대비 의도적 차이와 유지된 특이점(`hideCheckboxColumn` 반전 등)은 [NCNS Custom Related List — 동작 원리와 설계 배경](ncns-customrelatedlist-explanation.md)으로 옮겼습니다.
