# Work Log — LGCNS_Dev

> 작업 로그. 최신 항목이 맨 위. 하루 끝에 3줄이라도 남긴다.
> - **한 일**: 무엇을 했나 (사실)
> - **결정·메모**: 왜 그렇게 했나 / 막힌 점 (나중에 까먹는 부분)
> - **다음**: 이어서 할 것

---

## 2026-07-08

### 한 일
- doc/ 문서 세트 Diátaxis 재구성 — 설명 문서(`ncns-customrelatedlist-explanation.md`)·인덱스(`index.md`) 신설, 전 문서에 유형 배지(하우투/레퍼런스/설명), 설정 가이드의 §5(동작)·§6(Aura 차이)을 설명 문서로 이관, HTML 전체 재생성
- PPT 2종 생성: `teammember-docs-overview.pptx`(신규 LWC 기준 개요 10슬라이드), `aura-teammember-other-object-setup-guide.pptx`(구버전 Aura 방식 다른 오브젝트 적용 가이드 11슬라이드)
- `doc/WORKLOG.md` 신설 + CLAUDE.md에 Work Log Policy 추가, 이후 날짜 단위 템플릿(한 일/결정·메모/다음)으로 전환
- 문서 정책 보완: 기본 md만 작성, HTML/PPT 등 다른 형식은 명시 요청 시에만 (CLAUDE.md)
- `.agents/skills` 13개 스킬 내용 확인 후 **CLAUDE.md에 Skills Policy 추가**(작업별 스킬 매핑 표 + 배포 전 `--dry-run`·테스트 검증 의무, "커버되면 사용" 수준). 기본 org는 `LGCNS_Dev`로 확인됨(검증 시점 잠깐 MCM_Dev였으나 원복) → 관련 MCM_Dev 경고·메모리 정리
- **cmp_interface 재플랫폼 (조사→설계→검증→배포·테스트 완료)** — LGCNS_Dev 배포 성공, 테스트 17/17 그린. 배포 중 실패 3건(json/JSON 충돌·Interface__c 필수·필드 길이) 원인·교훈은 설계서 §11 + 메모리에 기록 — 상세·결정·진행·다음단계 **전부 `doc/cmp-interface-replatform-plan.md` 하나로 통합**(§11 진행 이력). 요약: MCM 패턴을 CMP에 가법 이식(즉시 재시도·PE 로깅·타깃 토글 + Timeout·로그 관측성 필드·appendLog), 팩토리·장기재시도(C) 미도입, `:187` NPE 픽스 포함. 신규 4·수정 5 로컬 작성 완료, **미배포**(사용자 필드 생성 후 배포·테스트)

### 결정·메모
- **CMP 재플랫폼 관련 결정·검증 발견은 전부 `doc/cmp-interface-replatform-plan.md`로 이관**(§1 결정 이력, §3-1 검증 결과, §11). 핵심만: `CMP_InterfaceService.cls:187` NPE 결함 발견·수정 · dev org에 CMP 인터페이스 레코드 사실상 없음 · 기본 org는 `LGCNS_Dev`
- `npm install --no-save`는 실행할 때마다 package.json에 없는 기존 패키지를 지워버림 → marked·pptxgenjs를 **한 명령으로 같이** 설치해야 함 (따로 설치하면 먼저 깐 게 사라짐)
- Aura 버튼(`CNS_LeadTeamMemberEditBtn`) 복제 시 모달 이름이 Helper **두 곳에 하드코딩** — 데스크톱 `"c:"+이름`, 모바일 `force:navigateToComponent`의 `componentDef`. 둘 다 교체해야 함 (Aura 가이드 PPT에 반영)
- Aura 카드는 `buttonComponent` 이름으로 `$A.createComponents` 동적 생성 → **카드 수정 없이** 새 버튼 연결 가능. LWC 카드는 BUTTON_MAP 등록+재배포 필요 — 두 방식의 핵심 차이
- Aura 갱신 경로 확인: 모달 저장 → `force:refreshView` 발행 → 카드의 `aura:handler`가 수신 (외부 트리거는 `c:CNS_CustomRelatedList_evt`)

### 다음
- [ ] 신규 LWC 14개 org 배포 — **사용자 승인 필요**, 명령은 `doc/ncnsCustomRelatedList-deployment-list.md`
- [ ] 배포 후 App Builder 배치 → 기존 Aura 카드와 나란히 비교 검증 (체크리스트: 배포 목록 문서 §3)
- 인터페이스 프레임워크 **핸드오버+사용자 가이드** 문서(Amazon_Pay_V2_Handover 스타일: 사이드바 TOC·다이어그램) — 한글 md + **CDN 없는 오프라인 HTML**(marked 로컬 렌더·정적 다이어그램·바닐라 TOC)
- **NCNS 테스트 인터페이스 2종 작성·배포**(2026-07-08): 아웃바운드 `NCNS_IF_TEST_OS_Echo`(NCNS_InterfaceRealTime, POST, HttpCalloutMock 테스트 3/3·커버 100%) + 인바운드 `NCNS_IF_TEST_IS_Echo`(@RestResource `/ncns/test/inbound`, NCNS_InterfaceWebService, RestContext 주입 테스트 4/4·커버 91%). 라이브 콜아웃은 NC + `NCNS_Interface__c` 정의 레코드(데이터) 필요
- **NCNS_Interface__c 필드 정리**(2026-07-08, 배포·테스트 완료): `URL__c`(Url)→**`EndPoint__c`(Text 255)** 리네임, 미사용 레거시 10필드 파괴적 삭제(Source/Caution/BatchSize/Specification/ClassName/Protocol/Type/Header/Interval/URL). **유지**: `LogRetentionPeriod__c`(로그 `fm_IsAged__c` 공식이 사용) · `InterfaceId__c`(로그 동명 필드+이중용도라 `NamedCredential__c` 리네임 **취소**) · 이메일 클러스터(`EmailReceiver1~10`/`fm_ReceiverList__c`←`EmailCls`+테스트) · NC 표시(`NamedCredentialId__c`/`fm_NamedCredential__c`←LWC). 삭제 전 `NCNS_InterfaceService`/`NCNS_InterfaceWebService` SELECT에서 참조 제거, compactLayout/listView/recordType 참조 정리. 테스트 17/17 그린
- **신형/구형 혼재 혼란 해소 → CMP 프레임워크를 `NCNS_`로 통째 fork**: 신규 객체 4(`NCNS_Interface__c`/`Log__c`/`LogEvent__e`/`CalloutTargetActive__mdt`) + 클래스 11 + 트리거 + 로그뷰어 LWC(`ncns_InterfaceLog`) + 샘플 2. **배포·테스트 17/17 그린**. 공유 유틸(`CMP_HttpUtil`/`CMP_TestDataFactory`/`Core`/`CMP_NamedCredentialController`)은 재사용. 문서도 NCNS판으로 교체(`NCNS_Interface_Framework_Handover`·`ncns-callout-logging-guide`, CMP 핸드오버/가이드 삭제), 설계서 §11 반영. **신규 인터페이스는 NCNS_ 프레임워크로 작성**
- [x] 로그 저장방식 `LogMode__c` config화 → 사용자 요청으로 **2택(`DML`/`PlatformEvent`)으로 확정**(Buffered 제거, manualLogging 레거시 버퍼만 유지). 배포·테스트 17/17. 콜아웃 서브클래스+로그 사용법 가이드 `doc/cmp-callout-logging-guide.md` 작성
- [ ] (사용자) `CMP_Interface__c.LogMode__c` 픽리스트에서 `Buffered` 값 제거 (코드는 이미 2택; 남아 있어도 DML로 처리)
- [ ] **CMP 재플랫폼 콜아웃 파일럿** — **Named Credential 셋팅 후** 진행(현 dev org엔 DART용 NC 없음). 로직은 자동 테스트 17건으로 검증 완료. 상세 §11
- [ ] (요청 시) WORKLOG.html 등 HTML 재생성 — md만 작성 정책으로 현재 HTML은 일부 구버전

### 참고
- 문서 입구: `doc/index.md` · PPT: `doc/teammember-docs-overview.pptx`, `doc/aura-teammember-other-object-setup-guide.pptx`

---

## 2026-07-07

### 한 일
- `/init`으로 CLAUDE.md 생성 + 정책 수립: org 배포는 매번 승인 필수 / 로컬 코드·메타데이터 수정도 승인 필수 / 문서는 외부 게시 금지, `doc/` 로컬 파일로만
- Aura `CNS_CustomRelatedList` 생태계 → 신규 LWC 14개 제작 (`force-app/main/default/lwc/ncns*`): 카드·ViewAll 대형 모달·버튼 5종·모달 5종·`ncnsRecordLookup`·`ncnsRlUtils`(+Jest 59건). Opus 4.8 에이전트 6개, 3개 웨이브로 실행
- 검증: ESLint 0 error · Prettier(신규 파일만) · Jest 59/59 · `@lwc/template-compiler`로 14개 템플릿 컴파일 클린 · 기존 파일 무수정 mtime 검증
- 문서 5종 작성: 배포 목록 3종(신규 LWC / 기존 Aura / Lead 팀멤버 기능 단위), 신규 카드 설정 가이드, 다른 오브젝트 팀멤버 구축 하우투 + md→HTML 변환기(scratchpad `md2html.js`)

### 결정·메모
- **기존 코드 절대 무수정** 원칙(운영 중) — 신규 LWC가 기존 Apex를 같은 시그니처로 imperative 호출, 트리거·검증·공유는 기존 그대로 (병행 운영)
- 컴포넌트 접두사 `cns` → `ncns`로 변경 (기존 `cns*` 컴포넌트와 구분). 기존 Aura 버튼명은 BUTTON_MAP 소문자 키로 하위호환 유지
- Aura 특이 동작 **의도적 패리티 유지**: `hideCheckboxColumn` 의미 반전, `maxRowSelection` no-op, CURRENCY KRW 고정, PERCENT ×0.01 — 기존 flexipage 설정값을 무수정 이전하기 위함
- 알려진 갭(사용자 고지 완료): `force:recordChange` 대응 없음(RefreshView 부분 커버), `title="xxx.Label"` 동적 라벨 미지원(현 페이지 사용처 없음 확인)
- 로컬 LSP의 LWC1188/LWC1071 경고는 js-meta.xml capability를 못 읽는 오탐 — 실제 컴파일러로 검증하여 무시
- 사용자 중간 점검: 전환의 실익 비판적 검토 후 계속 진행 결정 / 재사용 기존 컴포넌트 무수정 mtime으로 증명

### 다음
- [x] 배포 목록·가이드 문서화 (07-07~08 완료)
- [ ] org 배포 (승인 대기 — 07-08 항목으로 이월)

### 참고
- 계획 문서: `C:\Users\B\.claude\plans\floating-yawning-reef.md`

---

<!-- 새 항목은 이 위에 추가 -->
