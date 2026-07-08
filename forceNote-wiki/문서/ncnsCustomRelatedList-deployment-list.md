# NCNS Custom Related List (LWC) — 배포 목록

> **문서 유형: 레퍼런스(Reference)** — 배포 대상·의존성·명령을 조회하는 문서입니다.
> Aura `CNS_CustomRelatedList` 생태계를 신규 LWC로 재작성한 컴포넌트들의 배포 참조 문서.
> 작성일: 2026-07-07 · [문서 인덱스](index.md) · 기존 Aura/Apex/트리거/flexipage는 **일절 수정하지 않음** (병행 운영)

---

## 1. 배포 대상 — 신규 LWC 14개

전부 `force-app/main/default/lwc/` 하위. 이 14개 폴더만 배포하면 됩니다.

| # | 컴포넌트 | 용도 | App Builder 노출 |
|---|----------|------|:---:|
| 1 | `ncnsRlUtils` | 공용 JS 유틸 (컬럼빌더/평탄화/정렬/검증/toast) + Jest 테스트 | — |
| 2 | `ncnsRecordLookup` | 콤보박스형 레코드 룩업 (Aura `c:Lookup` 대체) | — |
| 3 | `ncnsCustomRelatedList` | **관련 목록 카드 본체** (masterLabel: "NCNS Custom Related List (LWC)") | ✅ RecordPage / Community |
| 4 | `ncnsRelatedListViewAllModal` | 커스텀 전체보기 대형 모달 (Aura `CNS_ViewAll` 대체) | — |
| 5 | `ncnsLeadTeamMemberEditModal` | Lead 팀멤버 다중입력 모달 | — |
| 6 | `ncnsLeadTeamMemberEditBtn` | Lead 팀멤버 추가 버튼 | — (동적 로딩) |
| 7 | `ncnsOpptyTeamMemberEditModal` | Oppty 팀멤버 다중입력 모달 | — |
| 8 | `ncnsOpptyTeamMemberEditBtn` | Oppty 팀멤버 추가 버튼 | — (동적 로딩) |
| 9 | `ncnsOpptyShareByAbdEditModal` | Oppty 지분(ABD) 편집 모달 (합계 ≤100) | — |
| 10 | `ncnsOpptyShareByAbdEditBtn` | 지분(ABD) 편집 버튼 | — (동적 로딩) |
| 11 | `ncnsOpptyShareImpEditModal` | Oppty 지분(수행부서) 편집 모달 (합계 ==100) | — |
| 12 | `ncnsOpptyShareImpEditBtn` | 지분(수행부서) 편집 버튼 | — (동적 로딩) |
| 13 | `ncnsPnfSyncByProjectCodeModal` | 요약P/L 동기화 확인 모달 | — |
| 14 | `ncnsPnfSyncByProjectCodeBtn` | 요약P/L 동기화 버튼 | — (동적 로딩) |

### 배포 명령 (승인 후 실행)

```bash
sf project deploy start \
  --source-dir force-app/main/default/lwc/ncnsRlUtils \
  --source-dir force-app/main/default/lwc/ncnsRecordLookup \
  --source-dir force-app/main/default/lwc/ncnsCustomRelatedList \
  --source-dir force-app/main/default/lwc/ncnsRelatedListViewAllModal \
  --source-dir force-app/main/default/lwc/ncnsLeadTeamMemberEditModal \
  --source-dir force-app/main/default/lwc/ncnsLeadTeamMemberEditBtn \
  --source-dir force-app/main/default/lwc/ncnsOpptyTeamMemberEditModal \
  --source-dir force-app/main/default/lwc/ncnsOpptyTeamMemberEditBtn \
  --source-dir force-app/main/default/lwc/ncnsOpptyShareByAbdEditModal \
  --source-dir force-app/main/default/lwc/ncnsOpptyShareByAbdEditBtn \
  --source-dir force-app/main/default/lwc/ncnsOpptyShareImpEditModal \
  --source-dir force-app/main/default/lwc/ncnsOpptyShareImpEditBtn \
  --source-dir force-app/main/default/lwc/ncnsPnfSyncByProjectCodeModal \
  --source-dir force-app/main/default/lwc/ncnsPnfSyncByProjectCodeBtn \
  --target-org LGCNS_Dev
```

> 사전 검증만 하려면 위 명령에 `--dry-run` 추가.

---

## 2. 의존성 — org에 이미 존재해야 함 (배포 불필요, 존재 확인용)

신규 LWC가 **읽기 전용으로 참조**하는 기존 메타데이터. 현재 LGCNS_Dev org에 전부 존재.
다른 샌드박스/프로덕션에 배포할 때는 아래가 먼저 있는지 확인할 것.

### 2-1. Apex 클래스 (8종 — 시그니처 변경 없이 그대로 호출)

| Apex 클래스 | 호출 메서드 | 호출하는 신규 LWC |
|-------------|-------------|-------------------|
| `CNS_CustomRelatedList` | `init` / `refresh` / `deleteSelectedRow` | ncnsCustomRelatedList |
| `CNS_ViewAll` | `init` / `refresh` / `deleteSelectedRow` | ncnsRelatedListViewAllModal |
| `CNS_LookupController` | `getLookup` | ncnsRecordLookup |
| `CNS_LeadTeamMemberEdit` | `init` / `save` | ncnsLeadTeamMemberEditModal |
| `CNS_OpportunityTeamEdit` | `init` / `save` | ncnsOpptyTeamMemberEditModal |
| `CNS_OpportunityShareByAbdEdit` | `doInit` / `doGetData` / `doSave` | ncnsOpptyShareByAbdEditModal |
| `CNS_OpportunityShareImpEditController` | `doInit` / `doGetData` / `doSave` | ncnsOpptyShareImpEditModal |
| `CNS_PnfSyncByProjectCodeController` | `getProjectCode` / `callPnfSyncByProjectCode` | ncnsPnfSyncByProjectCodeModal |

### 2-2. 기존 LWC (2종 — 태그/모듈 참조)

| 기존 LWC | 참조 방식 | 사용처 |
|----------|-----------|--------|
| `cns_relatedListDatatable` (내부적으로 `cns_datatable` 사용) | `<c-cns_related-list-datatable>` 태그 | ncnsCustomRelatedList, ncnsRelatedListViewAllModal |
| `cnsUtil` | `import { CnsUtil } from "c/cnsUtil"` | ncnsRecordLookup |

### 2-3. 메시지 채널 (1종)

| 채널 | 용도 |
|------|------|
| `CMP_RelatedListMessageChannel__c` | 외부에서 관련 목록 refresh 트리거 (LMS 구독) |

### 2-4. 커스텀 라벨 (45종)

```
btn_AddRow, btn_Cancel, btn_Close, btn_Save,
CNS_btn_Delete, CNS_btn_Edit, CNS_btn_New, CNS_btn_Sync,
CNS_btnNewOpptyMember, CNS_btnShareEdit,
CNS_lab_abdShare, CNS_lab_BizShare, CNS_lab_Delete, CNS_lab_LeadAddMember,
CNS_lab_RelatedListRecordCount, CNS_lab_SyncProjectPL, CNS_lab_ViewAll,
CNS_msg_abdShareInfo, CNS_msg_confirmSyncProjectPL, CNS_msg_Delete,
CNS_msg_DeleteSuccess, CNS_msg_opptyShareAbdEmpty, CNS_msg_opptyShareBizEmpty,
CNS_valid_decimalPoint, CNS_valid_DuplicatedBizDept, CNS_valid_MinusPercent,
CNS_valid_noPermissionOpptyMember, CNS_valid_OpptyShareByAbdDept,
CNS_valid_OpptyShareByBizDept, CNS_valid_opptyShareRequired,
CNS_valid_shareNotPermited, CNS_valid_teamMemberDuplicated,
lab_AddOpptyTeam, lab_EnterLeastChar, lab_NoResultsFound, lab_Search, lab_User,
msg_CannotSave, msg_CompleteThisField, msg_NotSupportMobile,
msg_OpptyTeamUpdated, msg_RequiredMissing, msg_SaveSuccess, msg_SystemError,
valid_AddOneRecord
```

### 2-5. 런타임 연관 (LWC가 직접 참조하지 않지만 동작에 관여)

- 트리거/핸들러: `LeadTeamMember` 트리거 → `LeadTeamMember_tr`, `OpportunityShare`/`OpportunityTeamMember` 관련 핸들러 등 — 저장 시 기존 검증·공유·요약 로직이 그대로 동작
- CMDT: `TriggerHandlerSetting__mdt` (핸들러 매핑), `TriggerSwitch__mdt` (메서드 스위치)
- 통합: `CNS_IF_PNF_OR_ProjectPl` (요약P/L 동기화 콜아웃, `CNS_PnfSyncByProjectCodeController` 내부에서 사용)

---

## 3. 배포 후 설정 방법

1. App Builder에서 레코드 페이지 편집 → Custom 영역의 **"NCNS Custom Related List (LWC)"** 배치
2. 속성은 기존 Aura `CNS_CustomRelatedList`와 1:1 동일 (25개) — 기존 flexipage의 설정값을 그대로 옮기면 됨
3. `buttonComponent` 속성은 **하위호환** — 기존 Aura 이름(`CNS_LeadTeamMemberEditBtn` 등)을 그대로 입력해도 새 ncns 버튼으로 매핑됨. 새 이름(`ncnsLeadTeamMemberEditBtn`)도 동작

### 배포 후 확인 항목 (기존 Aura 카드와 나란히 비교)

- [ ] 컬럼 포맷: REFERENCE 링크 / CURRENCY(KRW) / PERCENT / DATETIME / richText
- [ ] 건수 표기 `(n)` / `(n+)`, 정렬 (클라이언트/서버 경로), 열 너비 재설정
- [ ] 행 액션: 편집(표준 편집 모달) / 삭제(확인 → 삭제 → LeadShare 연동 확인)
- [ ] 버튼 5종: 저장 → 카드 자동 갱신 / 권한 거부 경로 / 검증 메시지
- [ ] View All 모달: 전체 로드, 정렬, 삭제, 닫기 후 카드 갱신 (모달 내 행 편집 네비게이션은 실기기 확인 필요)
- [ ] 표준 New (`useStandardNew=true` + `defaultFieldValues`)
- [ ] 모바일 form factor / Community 페이지 (사용 시)

### 알려진 차이 (Aura 대비) — 요약

- 표준 행편집 후 자동갱신(`force:recordChange`)은 RefreshView API로 부분 커버 — 미갱신 시 새로고침 버튼 사용
- `title="xxx.Label"` 동적 라벨 미지원 (현 flexipage에는 사용처 없음 확인됨)
- 팀멤버 모달의 컬럼 마우스 리사이즈 제외

전체 차이 목록과 그 이유는 [설명 문서 §6~§7](ncns-customrelatedlist-explanation.md) 참조.
