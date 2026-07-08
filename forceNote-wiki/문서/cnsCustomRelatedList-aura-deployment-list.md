# CNS_CustomRelatedList (기존 Aura) — 배포 목록

> **문서 유형: 레퍼런스(Reference)** — 기존 Aura 생태계의 구성·배포 목록을 조회하는 문서입니다.
> 운영 중인 Aura 기반 커스텀 관련 목록 생태계의 전체 구성 목록.
> 다른 org(샌드박스/프로덕션)에 이 기능을 배포하거나, 신규 LWC 버전과의 구성 비교 시 참조.
> 작성일: 2026-07-07 · [문서 인덱스](index.md) · 신규 LWC 버전 목록은 [ncnsCustomRelatedList-deployment-list.md](ncnsCustomRelatedList-deployment-list.md) 참조

---

## 1. Aura 컴포넌트 번들 (`force-app/main/default/aura/`)

### 1-1. 핵심 (카드/전체보기/공용 다이얼로그)

| 번들 | 용도 |
|------|------|
| `CNS_CustomRelatedList` | 관련 목록 카드 본체 (App Builder 노출, .design 속성 25개) |
| `CNS_CustomRelatedList_evt` | APPLICATION 이벤트 — 외부에서 목록 refresh 트리거 |
| `CNS_ViewAll` | 커스텀 전체보기 화면 (force:navigateToComponent 대상) |
| `CNS_ConfirmModal` | 삭제 확인 모달 |
| `CNS_ConfirmModal_evt` | APPLICATION 이벤트 — 삭제 확인 콜백 |
| `CNS_RecordTypeSelector` | 표준 New 시 레코드 타입 선택 오버레이 |
| `CNS_MobileButton` | 모바일 form factor용 버튼 표현 |

### 1-2. 헤더 버튼 5종 (`buttonComponent`로 동적 주입)

| 번들 | 여는 모달 |
|------|-----------|
| `CNS_LeadTeamMemberEditBtn` | `CNS_LeadTeamMemberEdit` |
| `CNS_OpptyTeamMemberEditBtn` | `CNS_OpportunityTeamEdit` |
| `CNS_OpptyShareByAbdEditBtn` | `CNS_OpptyShareByAbdEdit` |
| `CNS_OpptyShareImpEditBtn` | `CNS_OpptyShareImpEdit` |
| `CNS_PnfSyncByProjectCodebtn` | `CNS_PnfSyncByProjectCode` |

### 1-3. 편집 모달 5종

| 번들 | 용도 | 사용 공용 컴포넌트 |
|------|------|--------------------|
| `CNS_LeadTeamMemberEdit` | Lead 팀멤버 다중입력 그리드 | DN_Helper(상속), Lookup |
| `CNS_OpportunityTeamEdit` | Oppty 팀멤버 다중입력 그리드 | DN_Helper(상속), Lookup |
| `CNS_OpptyShareByAbdEdit` | 지분(ABD) 편집 (합계 ≤100) | TreeGrid |
| `CNS_OpptyShareImpEdit` | 지분(수행부서) 편집 (합계 ==100) | TreeGrid |
| `CNS_PnfSyncByProjectCode` | 요약P/L 동기화 확인 | — |

### 1-4. 공용/기반 번들 (모달들이 의존)

| 번들 | 용도 |
|------|------|
| `DN_Helper` | 확장 가능 공통 베이스 (toast/apex/모달 유틸) |
| `Lookup` | 재사용 룩업 (User 검색 등) |
| `LookupResult`, `LookupSelected_evt`, `LookupRemoved_evt` | Lookup 내부 구성 |
| `DN_Paging`, `DN_ViewColumn` | Lookup 결과 모달 내부 구성 |
| `TreeGrid`, `TreeGrid_evt`, `TreeItem`, `TreeItem_evt` | 지분 편집용 편집형 그리드 (내부에서 Lookup 재사용) |

## 2. LWC (`force-app/main/default/lwc/`)

| 컴포넌트 | 용도 |
|----------|------|
| `cns_relatedListDatatable` | 카드/ViewAll의 데이터 테이블 (sort/rowaction 재발행) |
| `cns_datatable` | LightningDatatable 확장 (richText 컬럼 타입) — 위 컴포넌트의 베이스 |

## 3. Apex 클래스 (`force-app/main/default/classes/`)

### 3-1. 컨트롤러 (본체 + 테스트)

| Apex 클래스 | 테스트 클래스 | 사용처 |
|-------------|---------------|--------|
| `CNS_CustomRelatedList` | `CNS_CustomRelatedList_test` | 카드 (init/refresh/deleteSelectedRow) |
| `CNS_ViewAll` | `CNS_ViewAll_test` | 전체보기 |
| `CNS_RecordTypeSelector` | `CNS_RecordTypeSelector_test` | 표준 New 레코드타입 선택 |
| `DN_LookupController` | `DN_LookupController_test` | Aura Lookup 검색 |
| `CNS_LeadTeamMemberEdit` | `CNS_LeadTeamMemberEdit_test` | Lead 팀멤버 모달 |
| `CNS_OpportunityTeamEdit` | `CNS_OpportunityTeamEdit_test` | Oppty 팀멤버 모달 |
| `CNS_OpportunityShareByAbdEdit` | `CNS_OpportunityShareByAbdEdit_test` | 지분(ABD) 모달 |
| `CNS_OpportunityShareImpEditController` | `CNS_OpportunityShareImpEditCtrl_test` | 지분(수행부서) 모달 |
| `CNS_PnfSyncByProjectCodeController` | `CNS_PnfSyncByProjectcodeController_test` | 요약P/L 동기화 |

### 3-2. 내부 의존 (컨트롤러가 참조 — 교차 org 배포 시 선행 필요)

| Apex 클래스 | 참조 내용 |
|-------------|-----------|
| `CNS_ApexUtil` | `getRecordAccess`(수정권한 판정) 등 — 트리거 프레임워크 포함 대형 유틸 |
| `SObjectUtil` | `getDescribedObjectMap`/`getDescribedObjects` (describe 정보) |
| `CNS_IF_PNF_OR_ProjectPl` | 요약P/L 동기화 외부 인터페이스 콜아웃 |

> ⚠️ `CNS_ApexUtil`은 TriggerHandlerSetting__mdt 등 트리거 프레임워크 전반을 참조하므로, 빈 org에 배포하려면 트리거 프레임워크(§5)까지 딸려갑니다. 기존 org 간 배포에서는 대부분 이미 존재.

## 4. 배포 명령 예시 (Aura 세트 전체)

```bash
sf project deploy start \
  --source-dir force-app/main/default/aura/CNS_CustomRelatedList \
  --source-dir force-app/main/default/aura/CNS_CustomRelatedList_evt \
  --source-dir force-app/main/default/aura/CNS_ViewAll \
  --source-dir force-app/main/default/aura/CNS_ConfirmModal \
  --source-dir force-app/main/default/aura/CNS_ConfirmModal_evt \
  --source-dir force-app/main/default/aura/CNS_RecordTypeSelector \
  --source-dir force-app/main/default/aura/CNS_MobileButton \
  --source-dir force-app/main/default/aura/CNS_LeadTeamMemberEditBtn \
  --source-dir force-app/main/default/aura/CNS_OpptyTeamMemberEditBtn \
  --source-dir force-app/main/default/aura/CNS_OpptyShareByAbdEditBtn \
  --source-dir force-app/main/default/aura/CNS_OpptyShareImpEditBtn \
  --source-dir force-app/main/default/aura/CNS_PnfSyncByProjectCodebtn \
  --source-dir force-app/main/default/aura/CNS_LeadTeamMemberEdit \
  --source-dir force-app/main/default/aura/CNS_OpportunityTeamEdit \
  --source-dir force-app/main/default/aura/CNS_OpptyShareByAbdEdit \
  --source-dir force-app/main/default/aura/CNS_OpptyShareImpEdit \
  --source-dir force-app/main/default/aura/CNS_PnfSyncByProjectCode \
  --source-dir force-app/main/default/aura/DN_Helper \
  --source-dir force-app/main/default/aura/Lookup \
  --source-dir force-app/main/default/aura/LookupResult \
  --source-dir force-app/main/default/aura/LookupSelected_evt \
  --source-dir force-app/main/default/aura/LookupRemoved_evt \
  --source-dir force-app/main/default/aura/DN_Paging \
  --source-dir force-app/main/default/aura/DN_ViewColumn \
  --source-dir force-app/main/default/aura/TreeGrid \
  --source-dir force-app/main/default/aura/TreeGrid_evt \
  --source-dir force-app/main/default/aura/TreeItem \
  --source-dir force-app/main/default/aura/TreeItem_evt \
  --source-dir force-app/main/default/lwc/cns_relatedListDatatable \
  --source-dir force-app/main/default/lwc/cns_datatable \
  --source-dir force-app/main/default/classes/CNS_CustomRelatedList.cls \
  --source-dir force-app/main/default/classes/CNS_CustomRelatedList_test.cls \
  --source-dir force-app/main/default/classes/CNS_ViewAll.cls \
  --source-dir force-app/main/default/classes/CNS_ViewAll_test.cls \
  --source-dir force-app/main/default/classes/CNS_RecordTypeSelector.cls \
  --source-dir force-app/main/default/classes/CNS_RecordTypeSelector_test.cls \
  --source-dir force-app/main/default/classes/DN_LookupController.cls \
  --source-dir force-app/main/default/classes/DN_LookupController_test.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberEdit.cls \
  --source-dir force-app/main/default/classes/CNS_LeadTeamMemberEdit_test.cls \
  --source-dir force-app/main/default/classes/CNS_OpportunityTeamEdit.cls \
  --source-dir force-app/main/default/classes/CNS_OpportunityTeamEdit_test.cls \
  --source-dir force-app/main/default/classes/CNS_OpportunityShareByAbdEdit.cls \
  --source-dir force-app/main/default/classes/CNS_OpportunityShareByAbdEdit_test.cls \
  --source-dir force-app/main/default/classes/CNS_OpportunityShareImpEditController.cls \
  --source-dir force-app/main/default/classes/CNS_OpportunityShareImpEditCtrl_test.cls \
  --source-dir force-app/main/default/classes/CNS_PnfSyncByProjectCodeController.cls \
  --source-dir force-app/main/default/classes/CNS_PnfSyncByProjectcodeController_test.cls \
  --target-org <대상org>
```

> `.cls` 지정 시 같은 이름의 `.cls-meta.xml`이 자동 포함됩니다. 내부 의존(§3-2)은 대상 org에 이미 있어야 하며, 없으면 해당 클래스도 목록에 추가.

## 5. 기타 연관 메타데이터 (참조용)

| 유형 | 항목 | 비고 |
|------|------|------|
| 커스텀 라벨 | 신규 LWC 문서의 45종과 동일 + Aura 전용 일부 (`lab_Loading`, `lab_SearchKeyword` 등 Lookup 계열) | `labels/CustomLabels.labels-meta.xml` |
| 메시지 채널 | — (Aura 버전은 LMS 미사용, APPLICATION 이벤트 사용) | |
| 트리거/핸들러 | `LeadTeamMember` 트리거 → `LeadTeamMember_tr`, `LeadTeamMemberShare` 등 | 저장 시 검증·공유·요약 담당 |
| CMDT | `TriggerHandlerSetting__mdt`, `TriggerSwitch__mdt` 레코드 | 트리거 활성/매핑 |
| 개체 | `LeadTeamMember__c`, `CNS_OpportunityShare__c` (+ RecordType `CNS_AbdType`/`CNS_ImpType`), `CNS_BizDepartment__c` | 데이터 저장 개체 |

## 6. 현재 배치된 flexipage (7종 — 이 카드가 사용 중인 페이지)

| flexipage | 배치 내용 |
|-----------|-----------|
| `CNS_Lead_Lightning_Record_Page` | 팀멤버 (buttonComponent: CNS_LeadTeamMemberEditBtn) |
| `CNS_Opportunity_Record_Page` | 팀멤버/지분 ABD/지분 수행 버튼 3종 |
| `CNS_PrjCd_Opportunity_Record_Page` | 위 3종 + 요약P/L 동기화 |
| `CNS_Sales_Opportunity_Record_Page` | 지분 ABD/수행 버튼 2종 |
| `Weekly_Report_Record_Page` | 관련 목록 (버튼 없음) |
| `AI_Template_Setting` | 관련 목록 |
| `FlexiPage` | 관련 목록 |
