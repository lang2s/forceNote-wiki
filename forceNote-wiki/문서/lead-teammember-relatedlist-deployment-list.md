# Lead 레코드 페이지 "팀멤버" 관련 목록 — 기능 단위 배포 목록

> **문서 유형: 레퍼런스(Reference)** — Lead 팀멤버 기능 단위의 메타데이터 구성·배포 목록을 조회하는 문서입니다.
> `CNS_Lead_Lightning_Record_Page`에 배치된 팀멤버 관련 목록(+ "팀 멤버 추가" 버튼) 기능의 전체 구성.
> **기존(Aura) 컴포넌트와 설정만 다룹니다.** 이 기능을 다른 org에 통째로 배포할 때 필요한 메타데이터 목록.
> 작성일: 2026-07-07 · [문서 인덱스](index.md) · 관련 문서: [Aura 전체 목록](cnsCustomRelatedList-aura-deployment-list.md) · [기술 상세](CNS_CustomRelatedList.html)

---

## 1. 페이지 배치 (flexipage)

| 항목 | 값 |
|------|-----|
| flexipage | `flexipages/CNS_Lead_Lightning_Record_Page.flexipage-meta.xml` |
| 배치 컴포넌트 | `CNS_CustomRelatedList` (Aura) |

### 실제 설정값 (flexipage에 저장된 값 그대로)

| 속성 | 값 |
|------|-----|
| `parentFieldName` | `Id` |
| `targetObject` | `LeadTeamMember__c` |
| `currentObject` | `Lead` |
| `columns` | `User__c,LeadAccess__c,LeadRole__c` |
| `condition` | `LeadId__c = :parentId` |
| `orderBy` / `sortDirection` | `CNS_fm_Order__c` / `asc` |
| `limitRecord` | `30` |
| `buttonComponent` | `CNS_LeadTeamMemberEditBtn` ← "팀 멤버 추가" 버튼 |
| `uniqueIdentifier` | `LeadTeamRelatedList` |
| `relationField` / `relationShipName` | `LeadId__c` / `LeadTeamMembers` |
| `iconName` | `standard:account` |
| `useEdit` / `useDelete` | `true` / `true` |
| `hideCheckboxColumn` / `maxRowSelection` | `false` / `N` |
| `columnWidthsMode` | `auto` |
| `title` / `defaultFieldValues` / `editableField` | (공백) |
| `readOnly` / `withOutSharing` / `useStandardNew` / `useStandardViewAll` | `false` |

## 2. UI 계층 (Aura + LWC)

| 유형 | 항목 | 역할 |
|------|------|------|
| Aura | `CNS_CustomRelatedList` + `CNS_CustomRelatedList_evt` | 관련 목록 카드 |
| Aura | `CNS_LeadTeamMemberEditBtn` | "팀 멤버 추가" 헤더 버튼 |
| Aura | `CNS_LeadTeamMemberEdit` | 팀멤버 다중입력 모달 |
| Aura | `CNS_ConfirmModal` + `CNS_ConfirmModal_evt` | 행 삭제 확인 |
| Aura | `CNS_ViewAll` | 커스텀 전체보기 (`useStandardViewAll=false`) |
| Aura | `DN_Helper` | 모달 베이스 (상속) |
| Aura | `Lookup` + `LookupResult` + `LookupSelected_evt` + `LookupRemoved_evt` + `DN_Paging` + `DN_ViewColumn` | User 룩업 스택 |
| Aura | `CNS_MobileButton` | 모바일 버튼 표현 |
| LWC | `cns_relatedListDatatable` + `cns_datatable` | 데이터 테이블 |

## 3. Apex 클래스 (+ 테스트)

| Apex | 테스트 | 역할 |
|------|--------|------|
| `CNS_CustomRelatedList` | `CNS_CustomRelatedList_test` | 목록 조회/삭제 |
| `CNS_ViewAll` | `CNS_ViewAll_test` | 전체보기 조회 |
| `CNS_LeadTeamMemberEdit` | `CNS_LeadTeamMemberEdit_test` | 모달 권한체크/일괄저장 |
| `DN_LookupController` | `DN_LookupController_test` | Lookup 검색 |
| `LeadTeamMember_tr` | `LeadTeamMember_tr_test` | 트리거 핸들러 (검증·공유·요약) |
| `LeadTeamMemberShare` | `LeadTeamMemberShare_test` | LeadShare 수동공유 CRUD |
| `CNS_LeadTeamMemberByUserActive_ba` | `CNS_LeadTeamMemberByUserActive_ba_test` | User 비활성화 현행화 배치 |
| `CNS_LeadTeamMemberByUserActive_sc` | (배치 테스트에 포함) | 위 배치 스케줄러 (매일 06:40, `0 40 6 * * ?`) |

내부 의존 (대상 org에 선행 필요): `CNS_ApexUtil` (트리거 디스패치 `runTriggerByCustomMeta` + `getRecordAccess`), `SObjectUtil` (describe), `TriggerHandler`/`ITrigger` (트리거 프레임워크 베이스)

## 4. 개체 / 트리거 / 설정 메타데이터

| 유형 | 항목 |
|------|------|
| 개체 | `objects/LeadTeamMember__c/` — 필드 8종: `LeadId__c`, `User__c`, `LeadRole__c`, `LeadAccess__c`, `CNS_fm_Order__c`(정렬 수식), `Department__c`, `TeamRole__c`, `IsSystemUpdate__c` |
| 트리거 | `triggers/LeadTeamMember.trigger` (본문은 `CNS_ApexUtil.runTriggerByCustomMeta(this)` 한 줄) |
| CMDT 레코드 | `customMetadata/TriggerHandlerSetting.LeadTeamMember_Handler.md-meta.xml` (핸들러 매핑/활성) |
| CMDT 레코드 | `customMetadata/CNS_ValidationHandlerSetting.CNS_LeadTeamMember_valid.md-meta.xml` (검증 활성) |
| 커스텀 라벨 | `CNS_btnNewOpptyMember`, `CNS_lab_LeadAddMember`, `CNS_valid_noPermissionOpptyMember`, `CNS_valid_teamMemberDuplicated`, `msg_OpptyTeamUpdated`, `msg_RequiredMissing`, `valid_AddOneRecord`, `msg_NotSupportMobile`, `lab_User` + 카드 공통 라벨(`CNS_btn_Edit/Delete/New`, `CNS_lab_ViewAll`, `CNS_lab_RelatedListRecordCount`, `CNS_msg_Delete*` 등) |

관련 Lead 필드 (트리거가 참조 — Lead 개체에 존재해야 함): `CNS_l_Abd__c`, `CNS_l_BizDeptLeader__c`, `CNS_EmpNoList__c`

## 5. 배포 명령 예시 (기능 단위)

```bash
sf project deploy start \
  --source-dir force-app/main/default/flexipages/CNS_Lead_Lightning_Record_Page.flexipage-meta.xml \
  --source-dir force-app/main/default/aura/CNS_CustomRelatedList \
  --source-dir force-app/main/default/aura/CNS_CustomRelatedList_evt \
  --source-dir force-app/main/default/aura/CNS_LeadTeamMemberEditBtn \
  --source-dir force-app/main/default/aura/CNS_LeadTeamMemberEdit \
  --source-dir force-app/main/default/aura/CNS_ConfirmModal \
  --source-dir force-app/main/default/aura/CNS_ConfirmModal_evt \
  --source-dir force-app/main/default/aura/CNS_ViewAll \
  --source-dir force-app/main/default/aura/DN_Helper \
  --source-dir force-app/main/default/aura/Lookup \
  --source-dir force-app/main/default/aura/LookupResult \
  --source-dir force-app/main/default/aura/LookupSelected_evt \
  --source-dir force-app/main/default/aura/LookupRemoved_evt \
  --source-dir force-app/main/default/aura/DN_Paging \
  --source-dir force-app/main/default/aura/DN_ViewColumn \
  --source-dir force-app/main/default/aura/CNS_MobileButton \
  --source-dir force-app/main/default/lwc/cns_relatedListDatatable \
  --source-dir force-app/main/default/lwc/cns_datatable \
  --source-dir force-app/main/default/objects/LeadTeamMember__c \
  --source-dir force-app/main/default/triggers/LeadTeamMember.trigger \
  --source-dir force-app/main/default/customMetadata/TriggerHandlerSetting.LeadTeamMember_Handler.md-meta.xml \
  --source-dir force-app/main/default/customMetadata/CNS_ValidationHandlerSetting.CNS_LeadTeamMember_valid.md-meta.xml \
  --source-dir force-app/main/default/classes/CNS_CustomRelatedList.cls \
  --source-dir force-app/main/default/classes/CNS_CustomRelatedList_test.cls \
  --source-dir force-app/main/default/classes/CNS_ViewAll.cls \
  --source-dir force-app/main/default/classes/CNS_ViewAll_test.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberEdit.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberEdit_test.cls \
  --source-dir force-app/main/default/classes/DN_LookupController.cls \
  --source-dir force-app/main/default/classes/DN_LookupController_test.cls \
  --source-dir force-app/main/default/classes/LeadTeamMember_tr.cls \
  --source-dir force-app/main/default/classes/LeadTeamMember_tr_test.cls \
  --source-dir force-app/main/default/classes/LeadTeamMemberShare.cls \
  --source-dir force-app/main/default/classes/LeadTeamMemberShare_test.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberByUserActive_ba.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberByUserActive_ba_test.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberByUserActive_sc.cls \
  --target-org <대상org>
```

> ⚠️ flexipage를 배포하면 대상 org의 Lead 레코드 페이지가 **이 페이지 전체 구성으로 덮어써집니다** — 팀멤버 카드만 필요한 경우 flexipage는 제외하고 App Builder에서 수동 배치 권장.
> ⚠️ 배포 후 수동 작업: 스케줄러 등록 — `System.schedule('CNS_LeadTeamMemberByUserActive', '0 40 6 * * ?', new CNS_LeadTeamMemberByUserActive_sc());`
