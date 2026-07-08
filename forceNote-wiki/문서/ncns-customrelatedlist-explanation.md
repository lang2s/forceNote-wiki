# NCNS Custom Related List — 동작 원리와 설계 배경 (설명)

> **문서 유형: 설명(Explanation)** — 이 기능이 *왜* 이런 구조이고 *어떻게* 동작하는지 이해하기 위한 문서입니다.
> 구체적인 설정값은 [설정 레퍼런스](ncns-lead-teammember-setup-guide.md), 구축 절차는 [하우투 가이드](teammember-other-object-setup-guide.md) 참조.
> 작성일: 2026-07-08 · [문서 인덱스](index.md)

---

## 1. 왜 신규 LWC 세트를 만들었나

기존 관련 목록 카드(`CNS_CustomRelatedList`)와 그 생태계(버튼 5종, 모달 5종, 커스텀 전체보기, Lookup)는 Aura 기반입니다. Aura는 Salesforce가 더 이상 발전시키지 않는 구세대 프레임워크라, 동일 기능을 LWC로 재작성했습니다. 단, **운영 중인 기존 컴포넌트·Apex·트리거는 일절 수정하지 않고** 신규 LWC가 기존 서버 로직을 그대로 호출하는 **병행 운영** 구조를 택했습니다. 서버 계약(Apex 시그니처, 트리거 동작, 검증·공유 로직)이 바뀌지 않으므로 화면 계층만 교체해도 업무 동작은 동일합니다.

## 2. 전체 구조 — 화면 계층만 교체, 서버는 공유

```
[레코드 페이지]
  ncnsCustomRelatedList (카드)         ← App Builder 배치, 속성은 Aura와 1:1
    ├─ buttonComponent 속성 → BUTTON_MAP → 동적 import → ncns*Btn (헤더 버튼)
    │     └─ 클릭 시 ncns*Modal (LightningModal) 열기
    ├─ 행 액션: 편집(표준 화면) / 삭제(LightningConfirm)
    └─ 전체보기: ncnsRelatedListViewAllModal (대형 모달)
                          │ (전부 imperative Apex 호출)
[기존 서버 — 무수정]
  CNS_CustomRelatedList / CNS_ViewAll / CNS_*Edit / CNS_LookupController (Apex)
    └─ 저장 시 트리거 프레임워크 → 검증·수동공유·부모요약 처리
```

핵심 판단: **버튼과 모달은 카드에 하드코딩되지 않습니다.** 카드는 `buttonComponent` 속성 문자열을 소문자로 정규화해 `BUTTON_MAP`에서 생성자를 찾고, `lwc:is`로 동적 로딩합니다. 이 덕분에 ① 기존 flexipage에 저장된 Aura 버튼 이름(`CNS_LeadTeamMemberEditBtn` 등)을 그대로 입력해도 새 LWC 버튼으로 매핑되고(하위호환), ② 새 버튼을 추가할 때 카드 코드는 `BUTTON_MAP` 한 줄만 늘어납니다.

## 3. 저장 한 번에 일어나는 일 (Lead 팀멤버 기준)

1. "팀 멤버 추가" 버튼 → `ncnsLeadTeamMemberEditModal`(LightningModal) 열림. 모달 진입 시 Apex `init`이 **권한 판정**(비권한자는 안내 후 닫힘)과 피클리스트 옵션(describe)을 반환합니다.
2. 그리드에 행 추가 → 역할·사용자·액세스 입력. "공동영업 ABD" 역할을 고르면 User 검색이 해당 직무로 자동 필터링되고, 역할을 바꾸면 선택된 사용자가 초기화됩니다(잘못된 조합 방지).
3. 저장 → 기존 Apex `save`가 Savepoint 안에서 중복 검증 + 일괄 insert. 한 행이라도 실패하면 rollback되고 행별 에러가 그리드에 표시됩니다.
4. insert가 성공하면 **기존 트리거**(`LeadTeamMember_tr`)가 이어서 동작: 검증 → 부모 Lead 수동 공유(LeadShare) 생성 → 부모 요약 필드(사번 목록) 갱신. 화면이 아니라 트리거가 담당하므로, 데이터 로더로 넣어도 같은 규칙이 적용됩니다.
5. 모달이 닫히면서 카드가 자동 갱신됩니다(§4).

행 삭제도 대칭입니다: 확인 다이얼로그 → Apex 삭제 → 트리거가 공유 레코드까지 함께 정리.

## 4. 목록 자동 갱신 — 3경로인 이유

갱신 트리거가 어디서 오느냐에 따라 서로 다른 메커니즘이 필요합니다.

| 경로 | 발신자 | 메커니즘 |
|------|--------|----------|
| ① 모달 저장 후 | 카드 안의 버튼 | 버튼이 `refresh` CustomEvent(카드 직접 갱신) + `RefreshEvent`(페이지 표준 영역 갱신) 동시 발행 |
| ② 페이지의 다른 컴포넌트 | 같은 페이지 | RefreshView API(`registerRefreshHandler`) 수신 |
| ③ 페이지 밖 / 다른 컴포넌트 트리 | 임의 위치 | LMS `CMP_RelatedListMessageChannel__c` 구독 — recordId 또는 `uniqueIdentifier` 매칭 시에만 갱신 |

`uniqueIdentifier` 속성이 존재하는 이유가 ③입니다 — 같은 페이지에 카드를 여러 개 배치했을 때 특정 카드만 갱신 대상으로 지정하기 위한 식별자입니다.

**알려진 갭**: Aura의 `force:recordChange`(표준 행 편집 화면에서 저장하면 자동 감지)는 LWC에 직접 대응물이 없습니다. RefreshView API로 부분 커버되며, 갱신이 안 될 때는 카드의 새로고침 버튼을 사용합니다.

## 5. 트리거 프레임워크 — 왜 트리거가 전부 한 줄인가

이 org의 모든 트리거는 본문이 `CNS_ApexUtil.runTriggerByCustomMeta(this);` 한 줄입니다. 실제 로직 연결은 코드가 아니라 **커스텀 메타데이터**가 담당합니다:

- `TriggerHandlerSetting__mdt` — SObject명 → 핸들러 클래스 매핑. `IsTriggerActive__c`가 **킬 스위치**: 장애·대량 마이그레이션 시 배포 없이 트리거를 끌 수 있습니다. `IsMigrationActive__c`/`MigrationHandler__c`로 마이그레이션 중 대체 핸들러 지정도 가능합니다.
- `TriggerSwitch__mdt` — 핸들러의 특정 메서드만 개별 on/off.
- `CNS_ValidationHandlerSetting__mdt` — 검증 로직 활성 토글.

즉 "동작 변경은 배포가 아니라 설정으로"가 이 org의 규약입니다. 새 개체에 트리거를 붙일 때 CMDT 레코드 등록이 필수인 이유이기도 합니다 — **레코드가 없으면 트리거는 아무 일도 하지 않습니다.**

## 6. Aura 대비 의도적 차이

| 항목 | 기존 Aura | 신규 LWC | 이유 |
|------|-----------|----------|------|
| 삭제 확인 | 커스텀 모달(CNS_ConfirmModal) + APPLICATION 이벤트 | 표준 `LightningConfirm` | 유지보수 부담 제거, 표준 UX |
| 전체보기 | 별도 화면 이동(navigateToComponent) | 대형 모달 — **페이지를 떠나지 않음** | UX 개선 |
| 표준 New의 레코드타입 선택 | 커스텀 오버레이(CNS_RecordTypeSelector) | 표준 New 네비게이션에 위임 | 표준이 이미 처리 |
| 외부 refresh 트리거 | APPLICATION 이벤트 `CNS_CustomRelatedList_evt` | LMS `CMP_RelatedListMessageChannel__c` | LWC 표준 통신 방식 |
| 모바일 팀멤버 모달 | 별도 페이지 이동 | 미지원 안내 후 닫기 (태블릿은 데스크톱 취급) | 사용 빈도 대비 구현 비용 |
| 모달 컬럼 마우스 리사이즈 | 지원 | 제외 | 비핵심 |
| `title="xxx.Label"` 동적 라벨 | 지원 | 미지원 — LWC는 라벨 동적 import 불가 | 현 flexipage 7종에 사용처 없음 확인됨 |

## 7. 일부러 그대로 둔 특이점 (패리티 유지)

새로 만들면서 "고치고 싶은" 동작이라도, 기존 flexipage 설정값을 무수정으로 옮겨 쓸 수 있도록 Aura의 동작을 그대로 재현한 것들입니다:

- **`hideCheckboxColumn` 의미 반전** — Aura 원본이 값을 반전(`not()`)해서 테이블에 전달했기 때문에, 이름과 달리 `false`가 "체크박스 표시"입니다. 신규 카드도 동일하게 반전합니다.
- **`maxRowSelection`은 실동작 없음** — Aura에서 사실상 dead code였으므로 속성만 받고 무시합니다(설정 호환용).
- **통화 컬럼 KRW 고정, PERCENT ×0.01 변환** — Aura 헬퍼의 포맷 로직을 그대로 포팅.
- 열 너비 `auto` 모드일 때 최소 너비 100px 강제 — Aura와 동일.

이 특이점들을 "수정"하면 기존 페이지 설정값을 그대로 옮겼을 때 화면이 달라지므로, 병행 운영이 끝나기 전까지는 유지가 원칙입니다.

## 8. 경로 A / 경로 B — 하우투 가이드의 갈림길 배경

[하우투 가이드](teammember-other-object-setup-guide.md)가 두 경로를 나누는 이유:

- 카드 자체는 **개체와 트리거만 있으면** 표준 New 화면으로 완결됩니다(경로 A). 커스텀 모달(경로 B)이 필요한 경우는 ① 여러 명을 한 화면에서 일괄 등록하거나 ② 진입 시 권한을 판정하거나 ③ 역할에 따라 사용자 검색을 필터링하는 등 **표준 New가 못 하는 요구**가 있을 때뿐입니다.
- 공유 로직(수동 Share)도 선택입니다 — 팀멤버 개체를 Master-Detail로 만들면 공유가 부모를 따라가므로 코드가 필요 없습니다. Lead 구현에 `LeadTeamMemberShare`가 있는 것은 `LeadTeamMember__c`가 Lookup이고 Lead OWD가 Private이기 때문입니다.
- Account/Opportunity처럼 **표준 팀 기능이 내장된 개체**는 이 패턴 자체가 불필요합니다 — 표준 `AccountTeamMember`/`OpportunityTeamMember`가 공유까지 자동 처리합니다. 이 패턴은 Lead·커스텀 개체처럼 표준 팀이 없는 개체를 위한 것입니다.
