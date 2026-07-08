# 팀멤버 관련 목록 — Lead 외 다른 오브젝트에 구축하는 단계별 가이드

> **문서 유형: 하우투 가이드(How-to)** — 특정 목표를 달성하는 작업 절차입니다. 동작 원리·설계 배경은 [설명 문서](ncns-customrelatedlist-explanation.md), 정확한 속성값·목록은 레퍼런스 문서를 참조하세요.
>
> **목표**: Lead의 "팀멤버" 기능(`LeadTeamMember__c` + 관련 목록 카드 + 추가 모달 + 트리거)을 본떠 **임의의 오브젝트**(예: 커스텀 개체) 레코드 페이지에 동일한 팀멤버 기능을 구축한다.
> 이 가이드에서 부모 개체를 `Parent`(API `Parent__c` 또는 표준 개체)로, 새 팀멤버 개체를 `ParentTeamMember__c`로 표기합니다.
> 작성일: 2026-07-07 · [문서 인덱스](index.md) · 참고 구현: [Lead 기능 목록](lead-teammember-relatedlist-deployment-list.md) · [설정 레퍼런스](ncns-lead-teammember-setup-guide.md)

---

## 시작 전 ①: 이 패턴이 맞는지 확인 (전제조건)

- **대상 개체에 표준 팀 기능이 있으면 이 가이드가 불필요합니다** — Account/Opportunity는 표준 `AccountTeamMember`/`OpportunityTeamMember`가 공유까지 자동 처리하므로 표준을 사용하세요. 이 패턴은 Lead·커스텀 개체처럼 표준 팀이 없는 개체용입니다. ([왜?](ncns-customrelatedlist-explanation.md))
- 대상 org에 신규 LWC 세트(`ncns*` 14개)와 그 의존 Apex가 배포되어 있어야 합니다 — [신규 LWC 배포 목록](ncnsCustomRelatedList-deployment-list.md)으로 확인.
- 개체/필드/트리거/CMDT를 만들고 배포할 수 있는 권한(시스템 관리자 + 배포 파이프라인)이 필요합니다.

## 시작 전 ②: 두 가지 경로 선택

| 경로 | 설명 | 필요 작업 |
|------|------|-----------|
| **A. 코드 없이 (표준 New)** | 관련 목록 표시 + 표준 생성 화면 사용 | 1~3단계만 (개체 + 트리거 + 페이지 배치) — **Apex/LWC 신규 개발 불필요** |
| **B. Lead와 동일 (커스텀 추가 모달)** | "팀 멤버 추가" 버튼 → 다중행 입력 모달 → 권한체크/일괄저장 | 1~7단계 전부 |

간단한 요구라면 A로 시작해서 나중에 B로 확장하는 것을 권장합니다.

---

## 1단계. 팀멤버 개체 생성 (`ParentTeamMember__c`)

Setup → Object Manager → Create → Custom Object. Lead 구현(`objects/LeadTeamMember__c/`)을 기준으로 한 필드 구성:

| 필드 API | 타입 | 설정 | 용도 |
|----------|------|------|------|
| `ParentId__c` | **Lookup(부모 개체)** | 필수 | 부모 레코드 참조 — 관련 목록의 `condition`/`relationField` 기준. Master-Detail로 만들면 공유가 부모를 따라가므로 별도 Share 로직(4단계) 불필요 |
| `User__c` | Lookup(User) | 필수 | 팀 멤버 사용자 |
| `Role__c` | Picklist | 값: 조직 역할 체계에 맞게 (Lead 예: 사업조직 리더 / Main ABD / 공동영업 ABD / Main BD / Sub BD / 기타) | 팀 역할 |
| `Access__c` | Picklist | 값: `Read` / `Edit` (라벨: 읽기 전용 / 읽기·쓰기) | 부모 레코드 공유 수준 결정 (경로 B + 수동공유 시) |
| `CNS_fm_Order__c` | Formula(Number) | 예: `CASE(TEXT(Role__c), "사업조직 리더",1, "Main ABD",2, "공동영업 ABD",3, "기타",9, 0)` | 관련 목록 역할순 정렬 키 (`orderBy`에 사용) |
| `IsSystemUpdate__c` | Checkbox | 기본 false | 트리거의 시스템 처리 중 Validation 우회 플래그 |
| `Department__c` | (선택) | | 소속 부서 표시용 |

추가 확인 사항:
- **Child Relationship Name** 메모 (예: `ParentTeamMembers`) — 카드의 `relationShipName`과 표준 View All에 사용
- 탭/프로필 권한: 사용할 프로필·권한세트에 개체 CRUD + 필드 접근 권한 부여
- 중복 방지를 원하면: `User__c` + `ParentId__c` 조합 — 코드 검증(트리거) 또는 중복 규칙으로 처리

부모 개체에 (선택) 요약 필드: Lead의 `CNS_EmpNoList__c`처럼 팀멤버 사번 목록을 부모에 요약하려면 부모 개체에 Long Text 필드를 추가합니다.

## 2단계. 트리거 + 핸들러 + CMDT 등록 (이 org의 트리거 프레임워크 규약)

이 org의 모든 트리거는 커스텀 메타데이터로 디스패치되므로 새 개체도 같은 규약을 따라야 합니다. (프레임워크가 이렇게 설계된 이유는 [설명 문서 §5](ncns-customrelatedlist-explanation.md) 참조)

### 2-1. 트리거 (한 줄 규약)

`triggers/ParentTeamMember.trigger`:

```apex
trigger ParentTeamMember on ParentTeamMember__c (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {
    CNS_ApexUtil.runTriggerByCustomMeta(this);
}
```

### 2-2. 핸들러 클래스 (`<트리거명>_tr` 네이밍 규약)

`classes/ParentTeamMember_tr.cls` — `TriggerHandler`를 상속하고 필요한 컨텍스트만 오버라이드.
Lead 구현(`classes/LeadTeamMember_tr.cls`)에서 다음 로직을 참고해 필요한 것만 가져옵니다:

| 컨텍스트 | Lead에서 하는 일 (참고) |
|----------|--------------------------|
| `beforeInsert/Update/Delete` | 생성·수정·삭제 권한 검증(`checkModifyValidate`), Owner 역할 보호, 중복 검증, `IsSystemUpdate__c` 초기화 |
| `afterInsert/Update/Delete` | 부모 레코드 수동 공유 생성/수정/삭제 (4단계), 부모 요약 필드 갱신 (`CNS_ApexUtil.triggerBypassForDml`로 재귀 방지) |

### 2-3. CMDT 레코드 — **이걸 등록해야 트리거가 실행됩니다**

`customMetadata/TriggerHandlerSetting.ParentTeamMember_Handler.md-meta.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>ParentTeamMember_Handler</label>
    <protected>false</protected>
    <values><field>SObjectApiName__c</field><value xsi:type="xsd:string">ParentTeamMember__c</value></values>
    <values><field>DefaultHandler__c</field><value xsi:type="xsd:string">ParentTeamMember_tr</value></values>
    <values><field>IsTriggerActive__c</field><value xsi:type="xsd:boolean">true</value></values>
    <values><field>IsMigrationActive__c</field><value xsi:type="xsd:boolean">false</value></values>
</CustomMetadata>
```

- `DefaultHandler__c`를 비우면 `<트리거명>_tr` 규약으로 자동 탐색됩니다
- 특정 메서드만 끄려면 `TriggerSwitch__mdt` 레코드 추가 (HandlerName + MethodName + Active=false)
- Validation 로직 토글이 필요하면 `CNS_ValidationHandlerSetting__mdt` 레코드 추가 (Lead 예: `CNS_ValidationHandlerSetting.CNS_LeadTeamMember_valid`)

## 3단계. 레코드 페이지에 관련 목록 카드 배치

**여기까지만 하면 경로 A 완성** — 개체와 트리거만으로 관련 목록이 동작합니다.

App Builder → 부모 개체 레코드 페이지 편집 → **"NCNS Custom Related List (LWC)"** (또는 기존 Aura `CNS_CustomRelatedList`) 배치:

| 속성 | 값 | 비고 |
|------|-----|------|
| `parentFieldName` | `Id` | 현재 레코드가 부모 |
| `targetObject` | `ParentTeamMember__c` | 1단계에서 만든 개체 |
| `currentObject` | 부모 개체 API명 (예: `Account`) | |
| `columns` | `User__c,Access__c,Role__c` | 표시할 필드 |
| `condition` | `ParentId__c = :parentId` | 1단계의 부모 참조 필드 |
| `orderBy` / `sortDirection` | `CNS_fm_Order__c` / `asc` | 역할순 정렬 |
| `uniqueIdentifier` | 예: `AccountTeamRelatedList` | 페이지 내 고유값 |
| **경로 A**: `useStandardNew` | `true` | 표준 생성 화면 사용 |
| **경로 A**: `relationField` | `ParentId__c` | 표준 New에서 부모 자동 연결 |
| **경로 B**: `useStandardNew` / `buttonComponent` | `false` / 6단계에서 만든 버튼명 | |
| 나머지 | [설정 가이드](ncns-lead-teammember-setup-guide.md) §3 참조 | |

---

*이하 4~7단계는 경로 B(커스텀 추가 모달)를 만들 때만 필요합니다.*

## 4단계. (선택) 부모 레코드 수동 공유 로직

팀멤버 등록 시 부모 레코드를 그 사용자에게 공유해야 한다면:

- **부모가 커스텀 개체** + 1단계에서 Master-Detail을 선택했다면 → 공유가 부모를 따라가므로 **이 단계 생략**
- **부모가 표준 개체(OWD Private)** → `LeadTeamMemberShare.cls`를 본떠 `<Parent>Share` 레코드를 CRUD하는 클래스 작성. 핵심: `Access__c` 값 → Share 레코드의 AccessLevel 매핑, User 변경 시 기존 공유 삭제 후 재생성, RowCause 지정, `afterInsert/Update/Delete`에서 호출

## 5단계. 모달용 Apex 컨트롤러 + 테스트

`classes/CNS_LeadTeamMemberEdit.cls`를 복제해 개체/필드/권한 규칙만 바꿉니다. **신규 LWC 모달이 기대하는 계약을 유지**해야 합니다:

```apex
public without sharing class ParentTeamMemberEdit {

    // 모달 진입 시: 권한 판정 + 피클리스트 옵션(describe) 반환
    @AuraEnabled
    public static Map<String, Object> init(Id parentId) {
        Boolean isPermitUser = /* 부모 Owner / 담당자 / 관리자 프로필 등 조직 규칙 */;
        return new Map<String, Object>{
            'describe'     => SObjectUtil.getDescribedObjectMap(
                                  new List<String>{'ParentTeamMember__c'}).get('ParentTeamMember__c'),
            'isPermitUser' => isPermitUser
        };
    }

    // 일괄 저장: DB 중복 검증 → allOrNone=false insert → 실패 시 rollback + 행별 에러
    @AuraEnabled
    public static Map<String, Object> save(Id parentId, List<WrapperTeamMember> wrapMembers) {
        /* CNS_LeadTeamMemberEdit.save 로직 이식:
           Savepoint → 기존 User__c 중복 조회 → Database.insert(..., false)
           → 행별 SaveResult 반영 → 실패/중복 시 rollback + statusCode/messages 세팅 */
        return new Map<String, Object>{ 'result' => 'SUCCESS', 'wrapMembers' => wrapMembers };
    }

    public class WrapperTeamMember {
        @AuraEnabled public ParentTeamMember__c teamMember { get; set; }
        @AuraEnabled public String username   { get; set; }
        @AuraEnabled public String statusCode { get; set; }
        @AuraEnabled public String fields     { get; set; }
        @AuraEnabled public List<String> messages { get; set; }
    }
}
```

테스트 클래스(`ParentTeamMemberEdit_test`)도 함께 작성 — `CNS_LeadTeamMemberEdit_test` 패턴 참고 (권한자/비권한자, 정상 저장, 중복 저장 롤백).

## 6단계. LWC 버튼 + 모달 생성

신규 LWC 세트에서 Lead용 두 컴포넌트를 복제해 델타만 수정합니다:

### 6-1. 모달: `ncnsLeadTeamMemberEditModal` 복제 → `ncnsParentTeamMemberEditModal`

수정 포인트:

| 항목 | Lead 원본 | 변경 |
|------|-----------|------|
| Apex import | `CNS_LeadTeamMemberEdit.init/save` | `ParentTeamMemberEdit.init/save` |
| Apex 파라미터명 | `{ leadId: ... }` | 5단계 시그니처에 맞춤 (`{ parentId: ... }`) |
| 행 기본값 | `sobjectType:'LeadTeamMember__c', LeadId__c, User__c, LeadRole__c, LeadAccess__c:'Read'` | `sobjectType:'ParentTeamMember__c', ParentId__c, User__c, Role__c, Access__c:'Read'` |
| describe 키 | `leadrole__c` / `leadaccess__c` | `role__c` / `access__c` (소문자 API명) |
| 역할 조건부 User 필터 | `공동영업 ABD` → 직무 LIKE 필터 | 조직 규칙에 맞게 수정 또는 제거 |
| 모달 제목 라벨 | `CNS_lab_LeadAddMember` | 새 커스텀 라벨 생성 |

### 6-2. 버튼: `ncnsLeadTeamMemberEditBtn` 복제 → `ncnsParentTeamMemberEditBtn`

수정 포인트: 모달 import 경로, 버튼 라벨. `@api parentId`와 저장 후 refresh 이벤트 발행 로직은 그대로.
js-meta.xml의 `lightning__dynamicComponent` capability도 그대로 유지 (동적 로딩 필수).

### 6-3. 카드에 버튼 등록 — **잊기 쉬운 단계**

`lwc/ncnsCustomRelatedList/ncnsCustomRelatedList.js`의 `BUTTON_MAP`에 항목 추가:

```js
const BUTTON_MAP = {
  // ...기존 항목...
  ncnsparentteammembereditbtn: () => import("c/ncnsParentTeamMemberEditBtn"),
};
```

키는 **전부 소문자**로 등록합니다 (카드가 `buttonComponent` 값을 toLowerCase 후 조회).

> 기존 Aura 카드를 쓰는 페이지라면 이 단계 대신 Aura 방식(버튼 Aura 컴포넌트 생성)이 필요하지만, 신규 개발은 LWC 세트 기준을 권장합니다.

## 7단계. 배포 및 페이지 설정 마무리

배포 순서 (의존성 순):

1. 개체 `ParentTeamMember__c` (+ 부모 요약 필드)
2. Apex: `ParentTeamMember_tr`(+test), `ParentTeamMemberEdit`(+test), (선택) Share 클래스
3. 트리거 `ParentTeamMember.trigger`
4. CMDT 레코드 `TriggerHandlerSetting.ParentTeamMember_Handler`
5. 커스텀 라벨 (모달 제목 등 신규분)
6. LWC: `ncnsParentTeamMemberEditModal`, `ncnsParentTeamMemberEditBtn`, **수정된 `ncnsCustomRelatedList`**
7. App Builder에서 3단계 속성 중 `useStandardNew=false`, `buttonComponent=ncnsParentTeamMemberEditBtn`으로 변경 → Save/Activation

### 완료 체크리스트

- [ ] 관련 목록에 팀멤버가 역할순으로 표시된다
- [ ] "팀 멤버 추가" 버튼 → 모달 → 저장 → 목록 자동 갱신
- [ ] 권한 없는 사용자는 모달 진입 시 차단된다
- [ ] 같은 사용자 중복 등록이 막힌다 (화면 + 서버)
- [ ] (공유 사용 시) 팀멤버 등록/삭제에 따라 부모 레코드 접근 권한이 생기고 사라진다
- [ ] 행 편집/삭제 동작, 삭제 시 공유도 함께 정리된다
- [ ] 트리거를 꺼야 할 때 `TriggerHandlerSetting__mdt`의 `IsTriggerActive__c`로 제어 가능하다

## 부록 (참조): 기존 구현 대조표

| 구성요소 | Lead 구현 (복제 원본) | Opportunity 구현 (표준개체 예) |
|----------|----------------------|-------------------------------|
| 팀멤버 개체 | `LeadTeamMember__c` (커스텀) | `OpportunityTeamMember` (표준) |
| 모달 Apex | `CNS_LeadTeamMemberEdit` | `CNS_OpportunityTeamEdit` |
| LWC 모달/버튼 | `ncnsLeadTeamMemberEditModal` / `...Btn` | `ncnsOpptyTeamMemberEditModal` / `...Btn` |
| 트리거 핸들러 | `LeadTeamMember_tr` | (표준 팀 기능 활용) |
| 공유 | `LeadTeamMemberShare` (LeadShare 수동) | 표준 OpportunityShare 자동 |

동작 흐름(저장 한 번에 일어나는 일, 자동 갱신 3경로)과 경로 A/B의 설계 배경은 [설명 문서](ncns-customrelatedlist-explanation.md)에 있습니다.
