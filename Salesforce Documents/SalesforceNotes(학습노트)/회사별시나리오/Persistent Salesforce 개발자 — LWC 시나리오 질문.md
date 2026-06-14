---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [Persistent LWC SBQ]
---

# Persistent Salesforce 개발자 — LWC 시나리오 질문

> [!warning] 제3자 학습노트(LWC 시나리오 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 LWC/Salesforce 기능 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요.

> 형식: **Q** = 시나리오·세부 질문, **A** = 표준 해법.

---

**1. 다중 컬럼 정렬 datatable**
- **Q:** LWC 다중 컬럼 정렬 구현? 대용량 정렬 로직 최적화?
- **A:** `lightning-datatable`의 `onsort` 이벤트로 `sortedBy`·`sortedDirection`을 받아 정렬. 다중 컬럼은 정렬 우선순위 배열을 유지해 순차 비교. 대용량은 클라이언트 정렬 대신 **서버측 SOQL `ORDER BY` + 페이지네이션**으로 처리.

```js
// 구조 예시 — 실제 동작 코드 아님
handleSort(event) {
  const { fieldName, sortDirection } = event.detail;
  const dir = sortDirection === 'asc' ? 1 : -1;
  this.data = [...this.data].sort((a, b) =>
    a[fieldName] > b[fieldName] ? dir : -dir);
  this.sortedBy = fieldName;
  this.sortedDirection = sortDirection;
}
```

**2. 커스텀 네비게이션·동적 콘텐츠 탭**
- **Q:** 탭별 동적 렌더링 관리? 부드러운 네비게이션?
- **A:** `lightning-tabset`/`lightning-tab` + 탭 활성화 시점에 데이터 조회(**지연 로딩**), 콘텐츠는 `lwc:if`로 조건부 렌더. 활성 탭 상태를 트랙 변수로 관리해 전환을 매끄럽게.

**3. 카테고리 간 레코드 드래그앤드롭**
- **Q:** 드래그앤드롭 구현? drop 후 데이터 일관성?
- **A:** HTML5 `draggable` + `dragstart`/`dragover`/`drop` 핸들러. drop 시 Apex update로 카테고리 필드 변경 → **낙관적 UI** 갱신 후 실패하면 롤백, `refreshApex`로 정합성 확인.

**4. LWC 오류를 Salesforce에 로깅(감사)**
- **Q:** 커스텀 오브젝트에 오류 캡처·로깅? 재사용 오류 처리 유틸?
- **A:** `Error_Log__c` 커스텀 오브젝트에 Apex `@AuraEnabled` 메서드로 메시지·스택·컨텍스트를 insert. 공통 **errorHandler ES 모듈**을 만들어 모든 컴포넌트가 import해 일관 처리.

**5. 역할별 동일 폼 다른 검증 규칙**
- **Q:** 역할 기반 검증 로직? 구성 가능·유지보수?
- **A:** 검증 규칙을 코드에 하드코딩하지 않고 **Custom Metadata Type**(역할→검증 조건)으로 외부화. 서버측에서 사용자 역할에 맞는 규칙을 조회해 적용 → 재배포 없이 규칙 변경.

**6. 역할·권한 기반 동적 필드·레이아웃 렌더링**
- **Q:** 동적 레이아웃 조회·렌더링? 민감 필드 노출 방지?
- **A:** `getRecordUi`/`getObjectInfo`(uiObjectInfoApi) 또는 Custom Metadata로 역할별 필드 집합 조회해 동적 렌더. 민감 필드는 **FLS 강제**(Apex `Security.stripInaccessible`, `WITH USER_MODE`)로 노출 차단.

**7. 로깅·API 호출 공통 서비스 의존성 주입**
- **Q:** LWC 서비스 클래스 설계·공유? 주입 서비스 컴포넌트 테스트?
- **A:** 순수 함수를 **ES 모듈**(예: `c/logService`)로 export해 여러 컴포넌트가 import(LWC의 모듈 공유 = 사실상 DI). 테스트는 **Jest**에서 해당 모듈을 `jest.mock`으로 대체.

**8. 역할·권한 기반 다른 콘텐츠 표시**
- **Q:** 사용자 권한 판단? 민감 데이터 보안?
- **A:** `@salesforce/userPermission/*` 또는 custom permission import로 권한 판단해 조건부 렌더. 민감 데이터는 클라이언트 숨김만으로는 부족 → **서버측 필터링**으로 애초에 전송하지 않음.

**9. 사용자 선호 기반 동적 테마 변경**
- **Q:** 테마 관리 구현? 새로고침 없는 전환?
- **A:** 루트 요소 `classList` 토글로 즉시 테마 전환(새로고침 불필요), 선택값을 사용자 설정 레코드 또는 `localStorage`에 저장해 유지. CSS 변수로 색상 일괄 관리.

**10. 다국어·지역 형식 지원**
- **Q:** Translation Workbench + LWC? 동적 언어 전환?
- **A:** **Custom Labels + Translation Workbench**로 번역 관리, `@salesforce/i18n/lang`으로 사용자 언어 감지. 숫자·날짜·통화는 `Intl`/`lightning-formatted-*`로 지역 형식 적용.

**11. 서드파티 스크립트 + Locker/Lightning Web Security 준수**
- **Q:** Locker Service 제약? 호환성 테스트·해결?
- **A:** 서드파티 JS는 **Static Resource** + `loadScript`(platformResourceLoader)로 로드. **Lightning Web Security(LWS)**(Locker 후속) 하에서 DOM 직접 접근·전역 변수 제약이 있으니 샌드박스에서 호환성 검증 후 대체 API 사용.

**12. Custom Metadata로 동작 제어**
- **Q:** 효율적 조회·캐싱? 재배포 없이 메타데이터 업데이트?
- **A:** Custom Metadata는 Apex `@AuraEnabled(cacheable=true)` 또는 직접 SOQL(SOQL 한도에 안 잡힘)로 조회. 레코드 값은 **코드 재배포 없이 Setup에서 수정** 가능해 동작을 동적 제어.

**13. 부모가 여러 자식에 복잡 데이터 전달**
- **Q:** 부모-자식 통신 효율 관리? 자식 데이터 업데이트?
- **A:** 부모→자식은 `@api` 프로퍼티(반응형), 자식 목록은 `template for:each` + `key`. 복잡 객체는 불변 패턴(새 참조 할당)으로 전달해야 자식이 재렌더된다.

**14. Aura 래퍼 의존 LWC 무중단 배포**
- **Q:** 배포 계획·실행? Aura-LWC 의존성 처리?
- **A:** LWC API를 **하위 호환**으로 유지(기존 `@api` 시그니처 보존), 단계적 배포(신규 필드 추가는 옵셔널). Aura 래퍼와의 인터페이스(이벤트·속성) 계약을 깨지 않게 버전 관리.

**15. 복잡 조건(역할·레코드 타입) UI 표시/숨김**
- **Q:** 복잡 조건부 렌더링? 대형 DOM 성능 최적화?
- **A:** 조건은 **getter**로 계산해 템플릿을 단순하게(`lwc:if`/`lwc:elseif`). 대형 DOM은 보이는 영역만 렌더(가상화), 불필요한 반복 렌더 방지(`key` 안정화·불변 데이터).

**16. 화면 크기 적응 모달 폼**
- **Q:** 반응형 모달? 동적 입력 검증·오류?
- **A:** `lightning-modal`(또는 SLDS modal 마크업) + CSS media/container query로 반응형. 입력 검증은 `lightning-input`의 `reportValidity()` + 폼 제출 전 일괄 검증, 오류 메시지 인라인 표시.

**17. 다단계 가이드 플로우**
- **Q:** 단계 간 네비게이션? 미완성 진행 저장?
- **A:** 현재 단계를 트랙 변수로 관리하고 `lightning-progress-indicator`로 표시. 미완성 진행은 **draft 레코드**(또는 `localStorage`)에 저장 → 재방문 시 복원.

**18. 로케일 기반 다국어**
- **Q:** i18n 구현? 동적 언어 전환?
- **A:** Custom Labels + Translation Workbench(텍스트), `@salesforce/i18n/*`(로케일·통화·방향), `Intl`(형식). 사용자 언어 설정에 따라 자동 전환(사용자별 재로그인 또는 언어 설정 변경).

**19. 계층 데이터(부모-자식-손자) 표시**
- **Q:** 중첩 루프 구현? 성능 영향?
- **A:** **재귀 컴포넌트**(자기 자신을 참조) 또는 `lightning-tree-grid`로 계층 렌더. 성능은 **지연 확장**(노드 펼칠 때만 자식 조회)으로 초기 DOM·쿼리 부담 축소.

**20. 대량 레코드 성능 영향**
- **Q:** 지연 로딩·무한 스크롤? 효율 로딩 전략?
- **A:** `lightning-datatable`의 `enable-infinite-loading` + `onloadmore`로 **무한 스크롤**, 서버측 페이지네이션(SOQL `LIMIT`/`OFFSET` 또는 키셋). 필요한 필드만 쿼리, `@wire` 캐싱 활용.

**21. 이벤트 생성·수정·삭제 캘린더**
- **Q:** 기능 설계? Salesforce 동기화?
- **A:** FullCalendar 등을 Static Resource로 로드하거나 커스텀 그리드. CRUD는 Apex `@AuraEnabled`(또는 `lightning/uiRecordApi`)로 Salesforce 레코드와 동기화, 변경 후 `refreshApex`.

**22. 다중 오브젝트(Account·Contact·Opportunity) 글로벌 검색바**
- **Q:** 설계? 성능·보안 고려?
- **A:** **SOSL**로 여러 오브젝트를 한 번에 검색(`FIND :term IN ALL FIELDS RETURNING Account(...), Contact(...)`). 성능은 검색어 최소 길이·`LIMIT`, 보안은 `WITH USER_MODE`/`WITH SECURITY_ENFORCED`로 FLS·공유 강제.

```apex
// 구조 예시 — 실제 동작 코드 아님
List<List<SObject>> results = [FIND :searchKey IN ALL FIELDS
  RETURNING Account(Id, Name), Contact(Id, Name), Opportunity(Id, Name)
  LIMIT 50];
```

**23. 오브젝트 선택 목록 값 동적 표시**
- **Q:** Apex로 조회·드롭다운 바인딩?
- **A:** `getPicklistValues`(lightning/uiObjectInfoApi)로 record type별 picklist 조회(권장, 캐시됨). 또는 Apex `Schema.DescribeFieldResult.getPicklistValues()`. `lightning-combobox`에 `options`로 바인딩.

**24. 공유 규칙 기반 민감 데이터 표시**
- **Q:** 레코드 공유·보안 강제? Apex 조회 고려?
- **A:** Apex를 `with sharing`으로 선언하고 쿼리에 `WITH USER_MODE`를 써서 **공유 규칙·FLS**를 강제 → 사용자가 접근 권한 있는 레코드만 반환. `without sharing` 남용 금지.

**25. 여러 LWC가 유틸 로직(날짜·통화 포맷) 공유**
- **Q:** 재사용 코드 구조화?
- **A:** 공통 함수를 **서비스 ES 모듈**(예: `c/formatUtils`)로 만들어 export → 각 컴포넌트가 import. 포맷은 `Intl.DateTimeFormat`/`Intl.NumberFormat` 또는 `lightning-formatted-*` 활용.
