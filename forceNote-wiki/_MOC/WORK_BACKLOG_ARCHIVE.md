---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-06-20
---

# WORK_BACKLOG_ARCHIVE — 완료 작업 영속 대장

> 완료된(✅) 작업의 append-only 기록이다. **활성 백로그(열린 항목·lint 이력·프로토콜 개선)는 [[WORK_BACKLOG]] 참조.**
> 이 파일은 위에서 아래로 통독하지 않는다 — 특정 완료 항목의 근거(소스 페이지·완료일)를 조회할 때만 본다.

---

## 커버리지 현황 (2026-05-22 재산출 ✅)

| 소스 | 공개 대상 | 커버됨 | 작성 대상 누락 | 커버리지 |
|---|---|---|---|---|
| Apex Reference v67.0 (~70 네임스페이스) | 68개 (내부 전용 2개 제외) | 68개 | 0개 | **~100%** |

> ⚠️ 이전 수치("29개 / 42%")는 낡았음. 2026-05-22 PDF↔위키 재대조 결과 핵심 네임스페이스(System·Database·Schema·Auth·ConnectApi 등) 전부 커버. 누락은 니치 산업/커머스 6개뿐. 상세는 아래 "C — 커버리지 재산출".

---

## 사용 방법

- 새 항목 추가: wiki-retrospective(모드 B)가 추가
- 상태 업데이트: 해당 작업을 완료한 에이전트 또는 PM이 업데이트
- 완료 항목 정리: 분기마다 (약 30개 누적 시) archive 섹션으로 이동

---

## 완료 백로그 (아카이브)

### P1 — 즉시 작성 권장 (Apex Ref v67.0)

| # | 네임스페이스 | PDF 페이지 | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P1-04 | Flow | p.2880 | `Apex/Integration(통합)/Flow Namespace.md` | ✅ 완료(2026-05-19) | 2026-05-19 |
| P1-05 | TxnSecurity | p.4445 | `Apex/Security(보안)/TxnSecurity Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-06 | Support | p.3580 | `Apex/Integration(통합)/Support Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-07 | Context | p.2688 | `Architecture(아키텍처)/Context Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-08 | Datacloud | p.2741 | `Apex/Data(데이터)/Datacloud Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |

---

### P2 — 다음 사이클 (Apex Ref v67.0)

| # | 네임스페이스 | PDF 페이지 | 권장 파일 경로 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|---|
| P2-05 | ApexPages | p.10 | `Architecture(아키텍처)/ApexPages Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-06 | AppLauncher | p.43 | `Architecture(아키텍처)/AppLauncher Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-07 | LxScheduler | p.2980 | `Apex/Integration(통합)/LxScheduler Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-08 | VisualEditor | p.4462 | `Architecture(아키텍처)/VisualEditor Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-09 | Wave | p.4476 | `Apex/Data(데이터)/Wave Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-10 | UserProvisioning | p.4454 | `Apex/Security(보안)/UserProvisioning Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-11 | TerritoryMgmt | p.4441 | `Apex/Integration(통합)/TerritoryMgmt Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-12 | Slack | p.3578 | `Apex/Integration(통합)/Slack Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-13 | PlaceQuote | p.3208 | `Apex/Integration(통합)/PlaceQuote Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |

---

### P3 — 장기 계획 (Apex Ref v67.0 — 특수/Industries)

| # | 네임스페이스 | PDF 페이지 | 대상 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P3-06 | Canvas | p.279 | `Architecture(아키텍처)/Canvas Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-07 | ChatterAnswers | p.299 | `Apex/Integration(통합)/ChatterAnswers Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-08 | CommerceBuyGrp | p.301 | `Apex/Integration(통합)/CommerceBuyGrp Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-09 | CommerceExtension | p.307 | `Apex/Integration(통합)/CommerceExtension Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-10 | CommerceOrders | p.316 | `Apex/Integration(통합)/CommerceOrders Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-11 | CommercePayments | p.317 | `Apex/Integration(통합)/CommercePayments Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-12 | CommerceTax | p.527 | Tax Integration ISV | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-13 | ComplianceMgmt | p.646 | Financial Services Cloud | ✅ 완료(2026-05-20) — 스텁(PDF 클래스 인벤토리만 수록, FSC 가이드 참조 필요) | 2026-05-19 |
| P3-14 | embeddedai | p.2859 | Einstein 내장 개발자 | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-15 | Functions | p.2905 | Salesforce Functions org | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-16 | ise_bots_apex | p.2921 | Einstein Bot 고급 커스텀 | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-17 | IssueCreditMemo | p.2925 | Revenue Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-18 | InvoiceWriteOff | p.2966 | Revenue Cloud | ✅ 완료(2026-05-20) — 스텁(5개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-19 | IsvPartners | p.2966 | AppExchange ISV | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-20 | IndustriesDigitalLending | p.2928 | Financial Services Cloud | ✅ 완료(2026-05-20) — 스텁(5개 callable 클래스 인벤토리, industriesDigitalLending 공식 문서 참조) | 2026-05-19 |
| P3-21 | industriesNlpSvc | p.2926 | Industries AI | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-22 | Pref_center | p.3208 | Privacy Center org | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-23 | RichMessaging | p.3408 | Messaging for Web/In-App | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-24 | RevSignaling | p.3408 | Revenue Lifecycle Mgmt | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-25 | RevSalesTrxn | p.3408 | Revenue Cloud / CPQ | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-26 | RulesAppIn | p.3457 | Revenue Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-27 | runtime_industries_cpq | p.3458 | Industries CPQ | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-28 | runtime_industries_insurance | p.3458 | Insurance Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-29 | Sfc | p.3554 | Files 커스텀 처리 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-30 | Sfdc_Checkout | p.3558 | B2B Commerce 전문 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-31 | Sfdc_Enablement | p.3563 | Enablement 앱 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-32 | sfdc_surveys | p.3573 | Surveys 기능 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-33 | renew_assets_summary | p.3285 | Revenue Cloud | ✅ 완료(2026-05-21) — 스텁(2개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-34 | fsccashflow | p.2894 | Financial Services Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-35 | ind_mfg_sample_mgmt_apex | p.2925 | Manufacturing Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Manufacturing Cloud 개발자 가이드 참조) | 2026-05-19 |

---

### 신규 소스 PDF — 즉시 작성 권장

> **배경:** 2026-05-21 `Salesforce Documents/` 신규 PDF 13개 발견. Apex Reference 외 첫 대규모 소스 확장.

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N1-01 | SOQL/SOSL 기초 문법 (SELECT, WHERE, 관계 쿼리, 집계 함수, SOSL 구문 전체) | `salesforce_soql_sosl.pdf` (v67.0 Summer '26) | `Apex/Data(데이터)/SOQL 문법 레퍼런스.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N1-02 | ~~Governor Limits 빠른 참조~~ | ~~`salesforce_app_limits_cheatsheet.pdf`~~ | ~~`Architecture(아키텍처)/Governor Limits 빠른 참조.md`~~ | ❌ **기록 정정(2026-06-16)** — 아래 주석 참조 | 2026-05-21 |

> **N1-02 정정 (wiki-retrospective 모드 B, 2026-06-16):** 이 행의 완료 기록은 **거짓**이었다. (1) 기록된 파일 `Architecture(아키텍처)/Governor Limits 빠른 참조.md`는 **존재하지 않는다.** (2) 실제 거버너 한도 페이지는 `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md`이며 그 `source`는 **Apex Developer Guide(apex_gov_limits.htm)**이지 `salesforce_app_limits_cheatsheet.pdf`가 **아니다.** 즉 거버너 한도 주제는 다른 소스로 이미 커버됐고, **app_limits_cheatsheet.pdf는 위키화된 적이 없다.** → app_limits_cheatsheet.pdf를 **미착수로 되살려** 활성 백로그(INGEST)에 등록했다(ING-29). (line 142의 "재연결 완료" 메모와 이 행의 완료 기록이 모순됐던 것이 버그의 원인.)

---

### 신규 소스 PDF — 다음 사이클

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N2-01 | Change Data Capture — 변경 이벤트 구독·처리·갭 이벤트 | `salesforce_change_data_capture.pdf` (v66.0 Spring '26) | `Apex/PlatformEvents(플랫폼이벤트)/Change Data Capture.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N2-02 | Validation Rules 예제 모음 (Account, Contact, Opportunity 등 주요 객체) | `salesforce_useful_validation_formulas.pdf` (Spring '26) | `Architecture(아키텍처)/Validation Rules 예제.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N2-03 | UI API 개요 (getRecord, getFieldValue, wire 어댑터 전체 목록 + LWC 통합) | `api_ui.pdf` (v67.0 Summer '26) | `LWC/LDS/UI API 개요.md` | ✅ 완료(2026-05-22) | 2026-05-21 |

---

### PARTIAL — 부분 인용 공식 PDF 보완 (WORK_BACKLOG 🟧 PARTIAL에서 완료 이동)

> 부분 인용으로 분류됐던 공식 PDF를 전수 보완한 항목. 활성 백로그 🟧 PARTIAL 섹션에서 완료 시 이곳으로 이동.

| # | 항목 | 소스 PDF | 산출물 | 상태 | 추가일 |
|---|---|---|---|---|---|
| LDV-1 | LDV 백서 핵심 주제 보완 (쿼리 옵티마이저·selectivity·skinny tables·인덱싱·대량 로드/삭제 전략) | `salesforce_large_data_volumes_bp.pdf` (29p, Tier 2) | **2분할** — `Architecture(아키텍처)/대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱.md`(읽기 경로) + `Architecture(아키텍처)/대용량 데이터 (LDV) — 대량 로드·삭제.md`(쓰기 경로) | ✅ 완료(2026-06-17) — Query Optimizer 6동작·인덱스 selectivity 임계값 전수·Skinny 13필드타입·Divisions·대량 로드/삭제/추출·case study 6건. Data Skew와 양방향. source-verifier 셀단위 ✅·completeness 전수 ✅. 기존 `Data Skew.md`(skew만)와 중복 없음 | 2026-06-16 |
| APEXLANG-1 | Apex 언어 기초 개념 노트 (데이터타입·변수·제어흐름·클래스/객체/인터페이스·예외 처리·예약어) | `salesforce_apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2 — Writing Apex 챕터 p.23-132 / Exceptions p.706-715 / Reserved Keywords p.817-818) | **3분할** — `Apex/Apex 언어 기초 — 데이터타입과 변수.md`(595줄) + `Apex/Apex 언어 기초 — 제어 흐름과 클래스.md`(1373줄) + `Apex/Apex 언어 기초 — 예외 처리와 예약어.md`(334줄) | ✅ 완료(2026-06-17) — Primitive 12종 전수·연산자 전수표·Precedence 15단계·`?.`/`??`·Switch 6패턴·접근제어자 4종·Properties 3종·상속/인터페이스/Custom Iterator·sharing 3종·try/catch/finally·커스텀 예외 4 implicit 생성자·예약어 121개+특수 10개. completeness 깊이 ✅(예약어 기계 대조 IDENTICAL)·source-verifier 셀단위 ✅·qa ✅. namespace/메서드 레퍼런스·async/test/soql 중복 0(위임 링크). webservice 상세·Annotations 카탈로그는 차기. | 2026-06-16 |
| UIAPI-1 | UI API 리소스/요청·응답 바디 필드 스펙 보완 (Ch3 Request Parameters·Ch4 Request Bodies·Ch5 Response Bodies) | `api_ui.pdf` (366p, Tier 2, v67.0 Summer '26 — Ch3 Resources / Ch4 Request Bodies / Ch5 Response Bodies) | **spoke 분리(분할 안 함)** — 신규 `LWC/LDS/UI API 리소스 레퍼런스.md`(1865줄). 기존 `UI API 개요.md`(허브: 엔드포인트·wire 매핑·상태코드)는 보존하고 §2·§3에 레퍼런스 포인터 2줄 + 관련노트 역링크 삽입 | ✅ 완료(2026-06-17) — 157항목 전수: Ch3 Request Parameters 16리소스 + Ch4 Request Bodies 27종 + Ch5 Response Bodies 114종(Top-Level 37·Nested 77). enum 418값 전수(Field.dataType 25·Navigation standardType 35 등)·Filter Group/Available Version 2컬럼 보존·원문 오타 보존·67.0 신규필드(csrfToken·brandImageDarkMode·publicCreatable·sharedCreatable). completeness 깊이 ✅(갭 0, 행수 불일치 0)·source-verifier 셀단위 ✅(Location Field `maybe null` 1건 정정)·qa ✅. 개요 엔드포인트표·wire 매핑·상태코드와 중복 0(레이어 분리). getPicklistValues 패턴↔레퍼런스 역링크. `_index/frontend.md`·`LWC MOC`·`LWC/LDS/index.md` 등록 | 2026-06-16 |

---

### ING — Salesforce Documents 공식 PDF 인제스트 완료 (활성 백로그 🟢 INGEST에서 이동)

> 활성 백로그 INGEST 섹션에서 ✅ 완료된 ING 항목을 이곳으로 이동. 활성 파일에는 🔲/🟡만 남긴다.

| # | PDF (정식 제목) | 산출물 | 상태 |
|---|---|---|---|
| ING-15 | `caf_dev.pdf` (Custom Address Fields Developer Guide, v66.0 Spring '26, Tier 2) — ★ 파일명 약어 `caf`가 백로그에서 "Case Feed"로 오분류됐던 함정. PDF 내용 검증으로 정정 | 신규 `sObject/Custom Address Fields.md`(791줄). 10챕터 전수: 개념·9 custom field 소비·요건/제한 3그룹·State/Country picklist·활성화·geocode 수동 추가·CRUD 5-API(Apex/Metadata/REST/SOAP/Tooling). 교차링크: `Compound Fields`(양방향)·`Field Types`·Future 메서드·`REST API`(단방향). 수정: `Compound Fields`(§Custom Address Fields 역링크)·`_index/sobject-reference.md`(키워드 재지정+신규 행)·`sObject/index.md`(2행). ★ 처리 노하우: Ch6~Ch10이 동일 기능을 5개 API로 반복 시연 — 깊이 부족이 아니라 **중복이 위험인 PDF 유형**. 비교표 + API별 셀 단위 고유 표기(`fieldsToNull` 등) 보존으로 처리. 원문 오타 8건(v54.0·dataa66.0 등) 코드 교정 금지 원칙으로 보존 | ✅ 완료(2026-06-18) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): aliases에 자연어 7표현 보강(주소 필드를 코드로 만들기·커스텀 compound 필드 REST로 생성 등) |
| ING-31 | `secure_coding.pdf` (Secure Coding Guide, v67.0 Summer '26, Tier 2, 97p/15챕터) — Salesforce 위협모델 가이드. 첫 **최상위 `Security(보안)/` 폴더** 신설 | 신규 `Security(보안)/` 폴더 + 위협모델 **12노트**: `Secure Coding 개요`(Ch1+2, ~130줄)·`XSS 방어`(Ch4, ~520줄)·`SOQL Injection 위협`(Ch5, ~240줄)·`CSRF 방어`(Ch6, ~110줄)·`Secure Communications (TLS)`(Ch7, ~115줄)·`민감 데이터 저장`(Ch8, ~165줄)·`Arbitrary Redirect 방어`(Ch9, ~85줄)·`권한과 접근 제어 위협`(Ch10, ~230줄)·`Lightning Security 모델`(Ch11, ~340줄)·`세션 ID와 브라우저 통신 위협`(Ch3+13+14, ~200줄)·`Marketing Cloud API 보안`(Ch12, ~90줄)·`Platform Security FAQ`(Ch15, ~165줄). nav: `Security(보안)/index.md`·신규 샤드 `_index/security.md`(79줄, 11도메인 그룹)·라우터 1줄·Home 보안 섹션(index-manager). 교차링크: 17개 기존 노트 역링크. ★ 중복 회피: 기존 메커니즘 노트(`escapeSingleQuotes`·`AccessLevel`·`stripInaccessible`·`with/without sharing`·`Lightning Web Security`)로 deep-link 재사용 — **위협모델(왜 위험한가) vs 메커니즘 레퍼런스(API 시그니처)** 관점 분리, 재문서화 0. ★ 처리 노하우: scout가 ToC 인쇄번호 vs PDF 물리페이지 **+4 오프셋** 발견(표지/목차 4p) → 추출 페이지 전수 +4 보정. 다단 표 3곳(XSS 인코딩 함수표·CRUD/FLS 매트릭스·HTTP 헤더표) pdftoppm 이미지 검증으로 collapse 방지 | ✅ 완료(2026-06-18) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): 8개 위협 노트 aliases에 시나리오 자연어 표현 보강(내 VF 페이지 XSS 막으려면·guest user 권한 누수·open redirect 피싱·동적 SOQL에 사용자 입력·API 키 어디 저장 등). 차기 ING-43 등록(exp_cloud_lwr LWS 챕터→LWS vs Locker 전용 노트) |
| ING-36 | `chat_dev_guide.pdf` (Service Cloud Chat Developer Guide, v67.0 Summer '26, Tier 2, 61p) — 레거시 Chat(Live Agent) **에이전트/구현 가이드**. **2026-02-14 은퇴** 제품. ING-13a(chat_rest, 방문자측 REST)의 **형제 후속·보완 관계**(중복 아님). resumed 작업(이전 세션 Ch1-5 작성 → 이번 세션 Ch6-8 작성·전체 검증) | 신규 노트 1개 **`커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅`(417줄, Ch6-8)**: 13개 `liveAgent:*` VF 컴포넌트 전수 + "Using clientChatQueuePosition" 3조건·커스텀 chat window VF 코드샘플(waiting/engaged/ended 3-state + CSS)·post-chat 변수 19종 + `disconnectedBy` 5값 enum + 세션 타임아웃 Note·post-chat VF 코드샘플(abandoned 분기 JS)·Deployment API 메서드 4종(베이스 시그니처는 형제 노트로 DEDUP 교차링크)·`agentId_buttonId` 언더스코어 구문·direct-to-agent VF 코드샘플·Fallback Routing(부분 발췌 + char-exact `domainMatcher` 정규식 전체 코드샘플)·Quick Text 링크 패턴. 은퇴 [!warning] 배너. 기존 3노트(Ch1-5, 이전 세션·이번 세션 완결성 검증): `Chat 개발자 가이드 개요 & Deployment API`(Ch1 About/Ch2 Prereq/Ch3 API Versions)·`Deployment API — 레코드 자동 검색·생성·자동 채팅 초대`(Ch4 Deployment API)·`Pre-Chat API — 방문자 정보 수집`(Ch5 Pre-Chat). nav: `_index/service.md` 신규 "Chat — Developer Guide" 서브헤딩 4행·Chat `index.md`(현재 11노트)·Service 허브·`questions.md` 6행(index-manager). 교차링크: REST 백링크 2건(REST 개요→dev-guide 진입, REST 방문자경험 리소스→신규 노트, cross-linker). ★ DEDUP 회피: 방문자측은 ING-13a REST 노트로 교차링크, 베이스 Deployment API 시그니처는 형제 노트로 교차링크, Quick Text는 설명만(미링크) | ✅ 완료(2026-06-18) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. ★ 처리 노하우: (1) **+4 페이지 오프셋**(front matter, AP-05 절차 적용). (2) **char-exact `domainMatcher` 정규식**(비대칭 백슬래시 이스케이프) pdftoppm 이미지 검증으로 보존, 정규화 금지. (3) **원문 오타/ID 불일치 보존[sic]** — 설명문 ID(`005xx...`/`573xx...`) vs 코드 ID(`005D...`/`573D...`) 불일치, `liveagent.prechat.name`(점) vs `:Email`(콜론), `<liveagent:clientChatInput>` 소문자 표기 모두 원문 그대로. (4) Ch6 코드샘플의 "uses" 목록 vs 실제 코드 body 불일치(`clientChatCancelButton` 등 일부 차이) — 원문 그대로 보존. (5) **resumed-pipeline 단일-노트 제약**: 이미 작성된 3노트의 forward-link가 Ch6-8을 단일 노트로 가리키고 있어 1-vs-2노트 분할 자유도가 사전 링크에 의해 제약됨 → resumed 작업에선 기존 forward-link를 먼저 점검해 분할 결정. retrospective(모드 A): 신규 노트 aliases에 시나리오 자연어 보강(VF로 채팅창 커스터마이즈·채팅 끝나고 설문으로 보내기/post-chat 리다이렉트·상담원 직접 채팅 링크 / chat with me 링크·에이전트 오프라인이면 다른 큐로 폴백·abandoned 채팅 처리·Quick Text로 채팅 링크 배포 등) + tags에 PostChat·QuickText 추가. 후속 **ING-44**(Embedded Service SDK·Messaging for In-App and Web 마이그레이션, PDF 입수 게이트) 전용 행으로 승격 |
| ING-13a | `chat_rest.pdf` (Chat REST API Developer Guide, v66.0 Spring '26, Tier 2, 66p) — 레거시 Chat(Live Agent) **방문자측 REST API**. **2026-02-14 은퇴** 제품. 신규 **`Service(서비스)/Chat(채팅)/` 폴더** 신설 | 신규 **7노트(~1,797줄)**: `Chat REST API 개요 & 시작`(~174줄)·`메시지 롱폴링 & 대기시간`(~112)·`리소스 — 세션 생성 & 방문자 세션`(~176)·`리소스 — 채팅 모니터링 & Messages 응답 객체`(~253)·`리소스 — 방문자 경험 커스터마이즈`(~161)·`요청 & 응답 바디`(~729)·`데이터 타입 & 상태 코드`(~192). 7노트 전부 **은퇴 [!warning] 배너**. nav: 신규 `Service(서비스)/Chat(채팅)/index.md`·Service 허브 갱신·`_index/service.md` 샤드 행 추가. 교차링크: `sObject/Service Cloud Objects.md`. ★ 처리 노하우: (1) **TOC가 Ch6 "Messages Response Objects" 14개 하위 리소스를 누락** — scout가 PDF 색인으로 캐치, completeness-validator가 14개 전수 확인 → "최상위 TOC만 신뢰 말고 리소스 하위 중첩 항목 검증" 교훈. (2) **+4 페이지 오프셋**(front matter) scout 실측(AP-05 절차 적용). (3) pdftotext property 표 collapse → Ch6~Ch10 `-layout` 필수. (4) SwitchServer(Ch8 응답 바디)는 heading↔properties 사이 주석 라인이라 누락 쉬움 — coverage-checker 사전 플래그, validator 확인 | ✅ 완료(2026-06-18) — completeness 전수 ✅(Ch6 14객체 포함)·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): 개요·세션 노트 aliases에 `Live Agent REST API`·`Chasitor/채시터`·은퇴/마이그레이션 자연어(`Chat 은퇴`·`Live Agent 마이그레이션`·`Messaging for In-App and Web 마이그레이션`) 보강. 개요 노트의 broken `[[Messaging for In-App and Web]]`·`[[Embedded Service SDK]]` 3건을 plain-text 미작성 마커로 정정(L1 lint 통과). index-manager 권고: service 샤드에 `Live Agent`·`Chasitor`·은퇴/마이그레이션 키워드 행. 형제 후속 ING-36(chat_dev_guide) P1 식별 |
| ING-40 | `api_meta.pdf` (Metadata API Developer Guide, v67.0 Summer '26, Tier 2) — **CustomAddressFieldSettings 메타데이터 타입 상세**. ING-15 후속(source-coverage-checker 2026-06-18 발견, caf_dev 단일 scope 밖). `enableCustomAddressField`(활성화 후 **비활성화 불가**)·샘플 XML·v55.0+ | **in-place 보강**(신규 노트 아님) — 기존 `sObject/Custom Address Fields.md`(ING-15 산출) §활성화에 CustomAddressFieldSettings delta 보강: `CustomAddressFieldSettings` 샘플 XML·`enableCustomAddressField` 비활성화 불가 caveat·`package.xml` v55.0 예시. nav: `_index/sobject-reference.md` 기존 Custom Address Fields 행에 `enableCustomAddressField 비활성화 불가`·`package.xml v55.0`·`커스텀 주소 필드 활성화` 키워드 보강(중복 행 없음, 기존 행 보강). | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. api_meta 후속 묶음(RECON-2·ING-40·42) 동시 closure(RECON-3 ④) |
| ING-42 | `api_meta.pdf` (Metadata API Developer Guide, v67.0 Summer '26, Tier 2) — **AddressSettings + State/Country Picklist 설정**. ING-15 후속(coverage-checker 2026-06-18 발견). State and Country/Territory Picklist 활성화·설정. CAF의 picklist 의존성과 연결 | 신규 `Admin(어드민)/State and Country Picklist.md` — `AddressSettings` 메타데이터 타입: 하위타입 3·필드 15 전수, `CountriesAndStates`/Country/State, isoCode·integrationValue, `Address.settings`(settings 폴더 단일 파일), Metadata API 편집 가능·신규 생성/삭제 불가. CAF picklist 의존성 교차링크. nav: `_index/platform.md` Admin 섹션 신규 키워드 행(AddressSettings·State and Country Picklist·`Settings:Address`·isoCode integrationValue + 국가/주 피클리스트·주소 설정 + 자연어 질문)·`Admin(어드민)/index.md` 파일목록+빠른선택 행. | ✅ 완료(2026-06-19) — completeness 전수 ✅(하위타입 3·필드 15)·source-verifier ✅·qa ✅. Tier 3 노트 0. api_meta 후속 묶음(RECON-2·ING-40·42) 동시 closure(RECON-3 ④) |
| ING-39 | `salesforce_pages_developers_guide.pdf` (Visualforce Developer Guide, v67.0 Summer '26, 819p, Tier 2) — 퍼블리셔·Case Feed VF 컴포넌트 5종 **속성 완전 명세** 추출. ING-14 후속(source-coverage-checker 2026-06-18 발견). ★ 백로그 기재 페이지(ToC p.470/520/670/672/674)는 인쇄 페이지 — scout AP-05 실측으로 **물리 페이지 오프셋 +14** 환산(물리 484-486·534-535·684-686·688-689). | **in-place 보강**(신규 노트 아님) — 기존 `Aura(오라)/Case Feed Visualforce 커스터마이즈.md`(ING-14 산출)의 5개 속성표를 VF Dev Guide 정본으로 보강·교정. 신규 attribute **3행 추가**(`verticalResize` 30.0/emailPublisher·`categoryMappingEnabled` 25.0·`insertLinkToEmail` 25.0/caseArticles). 셀 교정: id·rendered **API Version 14.0**(기존 25.0/26.0)·**Access global**(소문자, 기존 대문자 Global)·Description 정본 문구(action→publisher 등). 5개 표 직전 출처 명시 인용블록·frontmatter source 2소스 병기·CaseFeed 표기 안내. 정본 행수 29/15/23/3/15. ★ 중복 회피: ING-14가 이미 속성표를 가지고 있어 전면 재작성이 아닌 **누락 행 보강 + 셀 교정**으로 처리. 산문·use case·코드샘플·chatter:feed 표는 미변경(보강이 표에만 국한). | ✅ 완료(2026-06-19) — completeness 전수 ✅(갭 0)·source-verifier 셀단위 ✅(90행×6셀 불일치 0)·qa ✅(counting 불일치는 헤더/구분선 카운팅 차이로 확정, 콘텐츠 정확). Tier 3 노트 0. ★ 처리 노하우: (1) **두 Tier-2 공식 소스 충돌** — 사용가이드(Publisher Dev Guide)와 레퍼런스가이드(VF Standard Component Reference)가 같은 attribute를 다른 API Version·Access 대소문자·용어로 기술 → 컴포넌트 스펙 정본은 **레퍼런스 가이드** 채택, 사용가이드는 산문/예제 출처로 종속. source-verifier.md에 규칙 반영. (2) **예제 맥락으로만 다룬 컴포넌트는 attribute 누락 가능** → source-coverage-checker.md 체크리스트에 반영. index-manager: `_index/frontend.md` 행에 신규 attribute 3개+`VF 컴포넌트 속성표` 키워드 보강. retrospective(모드 A): 후속 없음(차기 ING-27/ING-37 동일 PDF 전체 817p 분할은 별건 유지). |
| ING-43 | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, **v66.0 Spring '26**, 106p, Tier 2) — **Lightning Web Security(LWS) 전용 노트**. ING-31(Secure Coding) 후속(source-coverage-checker 2026-06-18 발견, secure_coding 단일 scope 밖). 위키에 LWS 격리 모델이 전무했음 | exp_cloud_lwr Ch2 "Lightning Web Security in LWR Sites"(전체추출 라인 429-451) + "LWS Limitations"(663-670) + Ch6 Privileged Script Tag `<x-oasis-script>`(3540-3733). secure_coding Ch11은 LWS 0건·Locker deep-link만 | 신규 `Security(보안)/Lightning Web Security (LWS).md` — LWS=Locker 대체·namespace별 sandbox로 document/window/element를 secure wrapper 없이 직접 노출·cross-namespace communication(composition/extension import)·third-party(analytics/charting) 용이·LWR 자체 LWS 인스턴스(org-level Session Settings 무효, Experience Builder site-level 제어)·미지원 속성 4종(document.domain·document.location·window.location·window.top)·Privileged Script Tag(별도 H2, shadow DOM 우회·GA/GTM 예제·imported/exported-global-names·hidden·Relaxed CSP). Locker 대비 대조표(함의 셀 라벨링). nav: `_index/security.md` Lightning 보안 섹션 1행·`_index/questions.md` 2행(공식 예외)·`Security(보안)/index.md`. cross-linker: peer 역링크 4건(Lightning Security 모델·LWC Shadow DOM 모드·LWR Sites·공유 JS 모듈) | ✅ 완료(2026-06-20) — completeness 갭 0·**fabricate 0**·source-verifier 불일치 0·qa PASS. Tier 3 노트 0. ★ **제목 정정**: 백로그 권고 "LWS vs Lightning Locker"는 과약속(소스가 Locker 직접 서술 0, 대비 함의뿐) → "Lightning Web Security (LWS)" + 본문 "Locker 대비" 섹션. ★ **백로그 전제 오류 정정**: 보강 대상 `Lightning Web Security` 노트 부재였고 `Lightning Security 모델` L20 deep-link가 LWS 없는 `LWC 보안 패턴`을 가리키던 **깨진 약속** → cross-linker가 신규 노트로 재지정. ★ **소스 제약 정직 처리**: distortion 메커니즘·secure wrapper 내부동작·정식 비교표는 코퍼스 부재(정식 "Security for Lightning Components" 가이드 미보유) → fabricate 금지·"소스 범위" 섹션에서 외부 LWC Dev Guide deep-link. ★ 버전: 본문 텍스트 v66.0 Spring '26 확정("Summer '26"은 표지 그래픽뿐, MEMORY 버전확인 규칙 적용) |
| ING-45 | `api_tooling.pdf` (Tooling API Reference and Developer Guide v67.0 Summer '26, 1006p, Tier 2) — **Tooling API 디버그/로그/리플레이 sObject 묶음**. RECON-4(Apex Debug Log) 후속·RECON-11(Tooling API 배포) line 16 예약 작업. UI/선언적 로그 제어만 있던 위키에 **프로그래밍 방식(SOAP/REST) 로그·리플레이 제어** 신규 | ★ 오프셋 비단조(+10~+11) — 물리 p.123-131(Overlay/ApexLog)·302-308(DebugLevel)·546-548(HeapDump)·922-928(TraceFlag)·14-20(executeAnonymous REST). 다단표/이미지 없음(수직 stacked 필드표) | 신규 `Apex/Logging(로깅)/Tooling API 디버그·로그·리플레이 sObject.md`(~320줄) — 7객체+복합타입 100% 전수: **TraceFlag**(14필드·LogType 4값[CLASS_TRACING/DEVELOPER_LOG/PROFILING/USER_DEBUG]·ExpirationDate 24h·ScopeId deprecated v34-·DebugLevelId→DebugLevel)·**DebugLevel**(11필드·카테고리 8종×picklist 8값[NONE~FINEST] 매트릭스·Language 18값·삭제 시 trace flag 연쇄삭제)·**ApexLog**(9필드·Location[Monitoring 7일/SystemLog 24h]·Request enum·raw 로그 `/sobjects/ApexLog/id/Body/`)·**ApexExecutionOverlayAction**(9필드·ActionScriptType 3값·SOAP 7콜/REST 5메서드)·**ApexExecutionOverlayResult**(11필드·ApexResult/SOQLResult/HeapDump 복합타입 참조)·**HeapDump**(complex type 최상위 4 + TypeExtent 6하위)·**executeAnonymous REST**(`/executeAnonymous/?anonymousBody=` GET v29.0+·managed package 차단·예제) + **ExecuteAnonymousResult**(7필드). 기능 3그룹 H2(로그 활성화/리플레이 디버거/executeAnonymous) + 상단 객체 관계도 ASCII. nav: `_index/apex-core.md` 1행·`_index/questions.md` 2행(공식 예외)·`Apex MOC` 📋 로깅·`Apex/Logging(로깅)/index.md`. cross-linker: peer 역링크 4건(Apex Debug Log·Anonymous Apex 실행·Tooling API 배포·DX 데이터 작업) + Tooling API 배포 line 16 ING-45 예약 주석→실링크 갱신 | ✅ 완료(2026-06-20) — completeness 갭 0(7객체+복합타입 100%·fabricate 없음)·source-verifier 불일치 0(필드·Properties·enum·Language 18값·코드 셀단위 일치·AP-09 절단 없음)·qa PASS. Tier 3 노트 0. ★ **scout 맵 오류 3건 researcher 정정**(silent gap 차단): (a) ApexLog Special Access Rules는 직후 ApexOrgWideCoverage 것 — 오귀속 배제, (b) TraceFlag SAR은 직전 TimeSheetTemplateAssignment 것 — 배제, (c) HeapDump 중첩타입 AttributeDefinition/HeapAddress/TypeExtent 독립정의 **PDF 없음** — fabricate 금지·"PDF 미정의" 명시. 대형 PDF에서 인접 sObject 섹션이 머리에 붙어 보이는 착시를 인접 헤딩 확인으로 차단. ★ RECON-11 line 16 예약 충족·해소 |

---

### RECON — 소스 문서 완전성 재감사 완료 (활성 백로그 🟪 RECONCILE에서 이동)

> 이미 위키화된 PDF의 **미추출 챕터/섹션**을 사후 보완한 항목(AP-08 문서 레벨 커버리지 추적의 산출물). 활성 백로그 🟪 RECONCILE 섹션에서 ✅ 완료 시 이곳으로 이동. 미커버 잔존 챕터는 활성 파일에 RECON-N 🔲로 남긴다.

| # | 항목 | 소스 PDF / 미추출 챕터 | 산출물 | 상태 |
|---|---|---|---|---|
| RECON-1 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Deploying Apex" 챕터 미커버 — **AP-08 문서 레벨 커버리지 추적의 증명 사례**. 이미 위키화된 PDF(APEXLANG-1로 Writing Apex 챕터 등 커버)인데 배포 챕터가 통째로 미추출이었음 | print p.764-765 "Deploying Apex" 챕터(Compile On Deploy + 배포 5종) | 신규 `DevOps(데브옵스)/Apex 배포 방법.md` — Compile On Deploy(org 타입별 자동 활성/비활성·동작·tradeoff·권장) + 배포 5종 비교표 + 4종 본문 전수(Change Sets·VS Code/Code Builder·Metadata API `Operations.enqueueDeployment`·Tooling API `ContainerAsyncRequest`/`ApexTriggerMember`). 5번째 DevOps Center는 기존 [[DevOps Center]]로 위임(중복 회피). nav: `_index/platform-devops.md` L39(Deploying Apex·배포 5종·Compile On Deploy·식별자 전수 키워드 행)·`DevOps(데브옵스)/index.md`. peer 역링크 4건(DevOps Center·Salesforce DX 개요·Metadata API 개요·Metadata API File-Based 호출). ★ 중복 회피: Metadata API/Tooling API 상세는 기존 MetadataAPI 폴더·Metadata Namespace로 deep-link, DevOps Center 흐름은 기존 노트로 위임 — 챕터를 비교 허브로 작성하고 깊은 메커니즘은 위임 | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier 7/7 ✅·qa ✅. Tier 3 노트 0. ★ scope discipline: 챕터-깊이만 커버하고 더 깊은 per-method 단독 자료(Change Sets step-by-step txt 968-998·Tooling API api_tooling.pdf 전용 레퍼런스)는 의도적 비추출 → 활성 백로그 RECON-10·11로 분리 등재. ★ 문서 레벨 커버리지 맵 부수 산출(completeness-validator): apex_developer_guide 미커버/부분 챕터를 RECON-4~9로 등재(Debugging·ApexDoc·Invoking Apex·Introducing·Versioned Behavior·Quick Start/Shipping Invoice). retrospective(모드 A): aliases·tags 충분(index-manager 샤드 키워드 row가 식별자·자연어 질문 모두 포함), 미세 보강만 권고 |
| RECON-4 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Debugging Apex" 챕터 → Debug Log 서브섹션 미커버. completeness-validator 문서 레벨 커버리지 맵(RECON-3 ① 산출물)이 "best ROI"로 판정한 디버깅 전용 노트 공백 | print p.678-719 "Debugging Apex / Debug Log" 서브섹션 | 신규 `Apex/Logging(로깅)/Apex Debug Log.md` — Debug Log 한도 전수, 로그 섹션 해부(Header·Execution Units·Code Units·Log Lines·More Log Data·원문 예시 로그), **로그 카테고리 10종 전수**·**로그 레벨 8종(누적적) 전수**·Developer Console 로그 작업·클래스/트리거 로그 필터·Event Type 매트릭스 전수·DebuggingHeader(backwards compat log level 전수)·Order of Precedence 전수. ★ planner는 PDF 이미지로 카테고리/레벨을 8/7로 추정했으나 pdftotext 텍스트 실측은 **10종/8종**(Database Access·NBA·NONE 누락 발견) → 텍스트 실측 후 정정 반영 | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. ★ 교훈: pdftotext 텍스트 실측 전 enum 개수 단정 금지(이미지 OCR 추정 ≠ 실측). 더 깊은 프로그래밍 로그 제어(Tooling API ApexLog/TraceFlag/DebugLevel·체크포인트·리플레이)는 활성 백로그 신규 항목 ING-45로 분리. retrospective(모드 A): aliases에 "Apex 디버깅"·"디버그 로그 안 보일 때"·"로그 레벨 설정"·System.debug 등 자연어 보강 |
| RECON-5 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Document Your Apex Code / ApexDoc" 챕터 미커버. 자기완결적·커버리지 0이던 doc-comment 레퍼런스 | print p.245-262 "Document Your Apex Code" 챕터 | 신규 `Apex/ApexDoc 주석 작성 가이드.md` — ApexDoc specification 전수: `@description`·`@param`·`@return`·`@throws`·`@see`·`@link` 등 태그·JavaDoc 기반 규약·Apex/Salesforce 특수 가이드라인 | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): aliases에 "@description"·"ApexDoc 주석 다는 법"·doc comment·코드 주석 규약 보강 |
| RECON-6 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Invoking Apex" 챕터 PARTIAL — Anonymous Apex(Anonymous Blocks ①) + @WebService/SOAP(④) + AJAX(⑩) 공백. 호출 표면(트리거·REST·Invocable·async)은 piecemeal 커버됐으나 익명 실행·SOAP 노출이 미작성이었음 | print p.264~ "Invoking Apex" 챕터 ①·④·⑩ | 신규 2노트: `Apex/ExecutionContext(실행컨텍스트)/Anonymous Apex 실행.md`(executeAnonymous·ExecuteAnonymousResult·Author Apex 권한·forward reference·익명 블록 제약) + `Apex/Integration(통합)/SOAP Web Services 노출 (webservice 키워드).md`(webservice 키워드·WSDL 생성·Web Service Method·오버로딩·AJAX Toolkit `sforce.apex.execute`) | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0. ★ **검증 프로토콜 갭 발견·교정:** External Reference 예제에서 researcher dump가 **페이지 브레이크에서 코드 블록을 끊은 채** 끝남 → writer가 "원문 끝"으로 오판, completeness-validator는 dump만 대조해 통과시켰고 **source-verifier가 PDF 원문 추가 추출로 코드 이어짐 발견**. → source-verifier.md §3·completeness-validator.md §7에 "코드 블록 페이지 경계 절단 의심 시 PDF 원문 추가 확인" 규칙 additive 추가(AP-09). ★ Triggers(②) 언어 레퍼런스는 방대 → 활성 백로그 RECON-12로 분리. retrospective(모드 A): 양 노트 aliases에 "익명 블록"·"execute anonymous 실행"·"Apex를 SOAP로 노출"·"@WebService" 등 자연어 보강 |
| RECON-12 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Invoking Apex" 챕터 ② Triggers — 언어 레퍼런스 공백. 기존 `Apex/Trigger(트리거)/` 폴더는 핸들러 패턴·재귀 방지 위주라 트리거 언어 레퍼런스(컨텍스트 변수표·이벤트 매트릭스·실행 순서) 자체가 미작성이었음. RECON-6에서 분량 때문에 의도적 분리 | print "Triggers" 서브섹션(컨텍스트 변수 13종·TriggerOperation enum·이벤트 7×3 매트릭스·정의 문법·merge/recovered) + "Triggers and Order of Execution" 20단계 | 신규 2노트: `Apex/Trigger(트리거)/Trigger 컨텍스트 변수와 이벤트.md`(트리거 문법·컨텍스트 변수 13종 `System.Trigger`·TriggerOperation enum 7종 ordinal[Reference Guide 출처 명시]·컨텍스트 변수 사용 매트릭스 7×3[4종 상태값 Allowed/runtime error/Not applicable/Allowed but unnecessary 셀단위 보존]·Defining 절차·Apex Trigger Editor·Merge/Recovered Records·after undelete 지원 객체 13종) + `Architecture(아키텍처)/Trigger Order of Execution.md`(20단계 save lifecycle 전수·재귀 save 9~17 skip·Additional Considerations 6항·workflow field update와 Trigger.old) | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. ★ Order of Execution을 Apex가 아닌 Architecture 폴더로 배치(저장 lifecycle 전체는 트리거 전용이 아니므로) — source는 Apex Dev Guide지만 도메인은 아키텍처. ★ 다이어그램(Order of Execution Flowchart)은 Data Model Gallery 외부 자료라 임의 순서도 미작성·번호 리스트로만 표현(C 패턴 준수). 기존 핸들러/재귀/System Namespace 노트와 양방향 역링크. retrospective(모드 A): 양 노트 aliases에 매트릭스 자연어 질문("before update에서 update DML 되나"·"트리거에서 런타임 에러"·"after insert에서 update 되나")·"operationType switch"·"저장 순서 트리거 몇 번째"·재귀 save skip·workflow 후 트리거 재실행 보강. validator 경미 갭 2건(SEE ALSO 참조 누락·isValid Note 후속 문장)은 "PDF Note/SEE ALSO 블록 끝문장까지 전수" 패턴 — 작성 시 반영, 기존 깊이 원칙 범위 내라 신규 규칙 불요 |
| 2GP-13 | `pkg2_dev.pdf` (Second-Generation Managed Packaging Developer Guide, v67.0 Summer '26, Tier 2) — 1GP vs 2GP **Feature Gaps** 미커버. RECON-3 ②(pkg2_dev 챕터 커버리지 재감사) 산출물. 4단계 감사 결과 pkg2_dev는 단일 "Chapter 1"에 17개 H2 구조 → 16개 H2는 기존 ~28개 2GP 노트가 전부 커버, **유일 미커버 H2 = "Gaps Between First- and Second-Generation Managed Packaging"** | print **p.505 단일 페이지**(intro + 미지원 기능 갭 3불릿 + Metadata Coverage Report 포인터). ★ 백로그 등재 page "p.505-517"은 과대추정 — p.506-517은 PDF back-matter(App Analytics Cookbook 잔여 + index/glossary), 본문 아님 | thin 신규 노트 대신 도메인 소유 기존 노트 `DevOps(데브옵스)/2GP Managed Package 개념과 1GP 비교.md`에 **§9 "1GP에는 있으나 2GP에 아직 없는 기능 갭"** 추가(중복 회피): 3개 갭 전수(① package version **deprecate** 미지원 · ② Apex **VersionProvider** 미지원 · ③ 레이블 **default language** 지정 불가) + `deprecate ≠ abandon` note(§2-4 abandon과 구분) + `[[Metadata Coverage 보고서]]` deep-link(채널별 지원 메타데이터 타입 최신 소스) | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier 불일치 0 ✅(AP-09 코드/텍스트 페이지경계 절단 없음 확인)·qa ✅. Tier 3 노트 0. nav: `_index/platform-devops.md` L44 기능 갭 키워드 보강(index-manager, 중복 행 없음). cross-linker: 허브 단방향만(의도적), peer 역링크 불필요. **★ 교훈 (a):** 미커버 챕터 page 범위는 ToC/물리 페이지 수가 아니라 **본문 끝 위치로 재확인**할 것 — "p.505-517"은 PDF 총 페이지(back-matter 포함)와 본문 끝을 혼동한 과대추정이었음. **★ 교훈 (b):** thin 섹션(3불릿)은 신규 노트보다 **도메인 소유 기존 노트에 §추가**가 중복 회피·발견성에 유리(고아 thin 노트 양산 방지). **★ RECON-3 ② 닫힘:** pkg2_dev 전 H2 챕터 커버 완료, 새 미커버 잔여 챕터 없음 → 신규 RECON-N 등재 불필요. retrospective(모드 A): aliases에 "2GP 미지원 기능"·"1GP에 있고 2GP에 없는 기능"·"2GP feature gaps"·"패키지 버전 deprecate 2GP" 보강. index-manager 후속 권고: 샤드에 원문 제목 "Gaps Between First- and Second-Generation" 정확 일치 키워드 보강 |
| RECON-2 | `api_meta.pdf` (Metadata API Developer Guide, v67.0 Summer '26, Tier 2) — DevOps Center 메타데이터 설정 플래그(DevHubSettings). 49개 PDF 전수 grep에서 발견(약 136073–136090행) — next-gen Beta / managed package GA 설정 플래그. RECON-3 ④ api_meta 재감사로 closure | **이미 반영 확인**(신규 작성 불요) — `Architecture(아키텍처)/DevOps Center.md`에 DevHubSettings 2필드 `enableALMDevopsCorePref`·`enableDevOpsCenterGA`가 **이미 반영돼 있음**을 api_meta 재감사(RECON-3 ④)로 확인. RECON-1 DevOps Center 노트 활성화/설정 섹션 보완 후보였으나 기존 노트가 이미 커버 → 추가 작성 불필요, 닫힘 처리. nav: 변동 없음(기존 키워드 행 유지) | ✅ 완료(2026-06-19) — api_meta 챕터 커버리지 재감사(RECON-3 ④)의 닫힌 항목. Tier 3 노트 0(read-only 확인). ING-40·42와 함께 api_meta 후속 묶음으로 동시 closure |
| RECON-7 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Introducing Apex" + "Apex Development Process" 개념 개요 미커버. completeness-validator 문서 레벨 커버리지 맵(RECON-3 ① 산출물)이 "둘을 1노트로 결합 가능"으로 판정 | print p.2 "Introducing Apex" + p.11 "Apex Development Process" | 신규 `Apex/Introducing Apex — 개요와 개발 프로세스.md` — What is Apex(강타입·객체지향·멀티테넌트)·언제 쓰는지·동작 방식(개념 프레이밍) + 개발→테스트→배포 개발 프로세스 전반. 언어 문법(변수·문·컬렉션·분기·루프) 세부는 언어 기초 노트로 위임(중복 회피). nav: `_index/apex-core.md` 언어 기초 섹션 키워드 행·`Apex MOC` 언어 기초 섹션 | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0 |
| RECON-8 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Apex Versioned Behavior Changes" 부록 미커버. API-version-gated 동작 변경 레퍼런스(niche/부록) | Appendix print p.794 | 신규 `Apex/Apex 버전별 동작 변경 레퍼런스.md` — `apiVersion`에 따라 달라지는 Apex 동작 변경 version-gated lookup 인덱스(v15~v67, 32버전·API Ref 23행 전수, 버전 내림차순). 개별 동작 상세 메커니즘은 각 항목 deep-link 노트 소관. nav: `_index/apex-core.md` 언어 기초 섹션 키워드 행·`Apex MOC` 언어 기초 섹션 | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0. ⚠️ 본문 자기기술 "22행" → 실제 23행(콘텐츠 누락 아님, 숫자 표기만 writer 후속 정정 예정) |
| RECON-9 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Apex Quick Start"·"Shipping Invoice Example" 튜토리얼/샘플 — **명시적 de-scope** | print p.16 Quick Start / p.805 Shipping Invoice | **신규 노트 없음 (de-scoped)** — 고유 레퍼런스 가치 0: "Deploy to Production" 단계는 RECON-10(Change Sets deep 노트)으로 흡수, 나머지(Quick Start 튜토리얼·Shipping Invoice 샘플 워크스루)는 기존 언어 기초·트리거·테스트 노트가 이미 커버. 튜토리얼/샘플 워크스루 자체는 위키화 가치 최소 → 의도적 비추출 | ✅ de-scoped(2026-06-19) — de-scope 사유 명시 후 closure. RECON-3 ① 잔여에서 제거 |
| RECON-10 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) — Change Sets 단독 deep 노트(outbound/inbound step-by-step·deployment connections·permissions). RECON-1 scope discipline에서 분리(source-coverage-checker 2026-06-19, 튜토리얼 txt 968-998행) | print Change Sets 절차 서브섹션 | 신규 `DevOps(데브옵스)/Change Sets 배포.md` — Salesforce UI outbound change set 생성·컴포넌트 담기·Upload + 연결된(connected) org 사이 배포(sandbox→production)·받는 쪽 awaiting deployment Deploy. deployment connection 설정 등 apex_developer_guide 미수록분은 Salesforce Help SEE ALSO 위임. RECON-1 `Apex 배포 방법`(Change Sets를 챕터-깊이 비교로만 커버)에서 분리한 deep 노트. nav: `_index/platform-devops.md` Salesforce DX 섹션 키워드 행·`DevOps(데브옵스)/index.md` 파일목록+빠른선택 | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0 |
| RECON-13 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Triggers" 챕터 잔여 서브섹션 — Trigger Exceptions(`addError` 레코드 vs 필드·HTML escaping·UI/API/Apex별 동작) + Common Bulk Trigger Idioms(관련 레코드 일괄 쿼리·Map 부모 룩업) + Operations That Don't Invoke Triggers(cascade delete·lead 변환·mass transfer 등). RECON-12 작업 중 회고 전수 grep으로 발견 | print "Triggers" 챕터 잔여 서브섹션 | 신규 `Apex/Trigger(트리거)/Trigger 벌크 관용구·미발생 작업·예외.md` — 벌크 트리거 Map/Set 관용구·트리거 미발생 시스템 작업 전수·before/after 갱신 불가 필드·addError() 예외 마킹과 부분 저장(partial save) 동작. 트리거 정의 문법·컨텍스트 변수·merge/recovered·Order of Execution은 기존 노트(컨텍스트변수·재귀·핸들러·Order of Execution) deep-link 위임(중복 회피). nav: `_index/apex-core.md` 아키텍처/트리거 섹션 키워드 행·`Apex MOC` 트리거 군·`Apex/Trigger(트리거)/index.md` | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0. RECON-16(Triggers for Chatter Objects·Knowledge Articles 트리거 고려사항)은 작업 중 발견 → 활성 백로그 분리 등재 |
| RECON-11 | `api_tooling.pdf` (Tooling API Developer Guide, Tier 2) — **Tooling API 컨테이너 배포 단독 노트**. 위키에 Tooling API 커버리지 0이었음(`apex_developer_guide`는 1줄·`Apex 배포 방법`은 비교표 1행 + 식별자 나열만). RECON-1 scope discipline 분리(source-coverage-checker 2026-06-19), ING-26(api_tooling 대형 분할)의 부분 선추출 | Save Apex Code / MetadataContainer · ContainerAsyncRequest · *Member objects 섹션 | 신규 `DevOps(데브옵스)/Tooling API 배포.md` — **위키 최초 Tooling API 커버리지**. MetadataContainer·ContainerAsyncRequest·**sObject 6종**(ApexClassMember·ApexTriggerMember·ApexComponentMember·ApexPageMember 등 *Member)·**State enum 6값**·working copy 컴파일·비동기 컴파일/저장/State 폴링 배포 워크플로 전수. Metadata API와의 차이(complex type 내 단일 요소 변경)·use case(소스관리·CI·IDE). 배포 경로 전체 비교는 [[Apex 배포 방법]], File-based deploy/retrieve는 [[Metadata API File-Based 호출]]로 deep-link 위임(중복 회피). ★ scope 경계 명시: SymbolTable 내부 구조·디버그/로그 sObject·ApexExecutionOverlayAction·전체 sObject 레퍼런스는 ING-26/ING-45 소관(범위 밖). nav: `_index/platform-devops.md` Salesforce DX 섹션 키워드 행(Tooling API·ContainerAsyncRequest·*Member·State enum·Save Apex via Tooling API + 한국어 + 자연어)·`DevOps(데브옵스)/index.md` 파일목록+빠른선택 | ✅ 완료(2026-06-20) — completeness 전수 ✅·source-verifier 불일치 0 ✅·qa ✅. Tier 3 노트 0. 참고 메모(저우선·정확도 결함 아님): `ApexComponentMember`의 `ManageableState` 한 줄 보강 여지 |
| RECON-14 | `api_meta.pdf` (Metadata API Developer Guide, v67.0 Summer '26, Tier 2) Ch4 "Run Relevant Apex Tests in a Deployment (Beta)" — `Metadata API File-Based 호출` 노트 셀단위 재검증. RECON-3 ④(api_meta 챕터 커버리지 closure) 산출물. "검증 only"로 등재됐으나 재검증 결과 **실제 공백 발견**(현재 커버 추정이 틀림) | api_meta Ch4 DeployOptions 중 Beta 기능(배포 시 관련 Apex 테스트만 실행) | **in-place 보강**(신규 노트 아님) — 기존 `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API File-Based 호출.md`에 **§RunRelevantTests (Beta)** 신설(9 claim 전수: payload+dependencies 자동 선택·class/trigger 개별 75% 요건·`@IsTest(critical/testFor)`·deploy/REST/CLI 설정법·Beta 약관). 동반: `Release/Spring '26/Development.md` 라인 74 정착 갱신. nav: 인덱싱 변경 불필요(기존 행 유지) | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier ✅·qa ✅. Tier 3 노트 0. ★ 교훈: "검증 only" 등재 항목도 셀단위 재검증에서 실제 공백이 드러날 수 있음 — 커버 추정을 확정 검증 없이 닫지 말 것 |
| RECON-17a | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, v66.0 Spring '26, Tier 2) Ch2 "Get to Know the LWR Templates" 비-LWS 부분 — RECON-17 deferred spoke 1/4 | Ch2 전 섹션(LWS 제외): Pages/Components·Differences·Publishing Model·Custom URL·Caching·Head Markup·Accessibility·Template Limitations | 신규 `LWC/UIPatterns(UI패턴)/LWR 동작·캐싱·제약.md`(260줄) — Site Pages 7종·**Light DOM**(Spring '22 shadow→light)·**New Publishing Model**(frozen·Aura dynamic vs LWR publish·Which Features 표 3행)·**Custom URL**(Winter '23 /s 제거·vforcesite·unauth 제약)·**Caching TTL 표 4행**(framework scripts 150d·HTML 1min·Permissions 5min·Org assets 1day, Description 전수)·**Head Markup**(기본 head 코드·{basePath}/{versionKey})·**Accessibility**(F6·Screen Reader SPA/ARIA-Live)·**LWR Template Limitations 8하위절**(Unsupported 16항·Workspaces 4개·Builder 6항·500 routes/250·Referential Integrity·Dynamic Import statically analyzable·LWS properties 4종·Asset Files Sandbox). hub stub "LWR Template Limitations 가이드 참조"→`[[LWR 동작·캐싱·제약]]` 전환. nav: `_index/frontend.md` 1행·questions 2행·LWC MOC·UIPatterns index. cross-linker: peer 역링크 4건(Shadow DOM 모드·LWR 다국어·LWR Expressions·LWS) | ✅ 완료(2026-06-20) — completeness 갭0·fabricate0·source-verifier 불일치0·qa PASS. Tier 3 노트 0. ★ **다단 표 2개(Caching TTL·Which Features) researcher가 `pdftoppm` 이미지화 후 셀 육안 확인** — pdftotext collapse·페이지경계 절단(TTL 표 printed p.10→11) 방지. LWS는 ING-43 위임(중복 회피). RECON-17 진행: 17a✅ → 잔여 17b(컴포넌트 개발 심화)·17c(--dxp 거대표 pdftoppm)·17d(Tag Manager) |
| RECON-17b | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, v66.0 Spring '26, Tier 2) Ch3 "Start Building Your LWR Site" — RECON-17 deferred spoke 2/4. 허브 "컴포넌트 개발" H2의 deep dive | Ch3 전 하위절(14절): 사이트 생성·커스텀 페이지·테마 레이아웃·컴포넌트 생성(js-meta.xml)·Component Properties·@salesforce 모듈·반응형·커스텀 레이아웃·커스텀 내비메뉴·Publish | 신규 `LWC/UIPatterns(UI패턴)/LWR 컴포넌트 개발 심화.md`(468줄) — **js-meta.xml 타깃 4종**(Page/Page_Layout/Theme_Layout/Default)·**targetConfigs property 5종**(string/integer/boolean/color/picklist + data type 5종)·camelCase/default/coercion/expression/translatable 규칙·**@salesforce 모듈 14종 전수**(apex·apexContinuation·client·community·contentAssetUrl·customPermission·i18n·label·messageChannel·resourceUrl·schema·site·user·userPermission)·Base Component 제약·UI API·Lightning Navigation·**화면 크기 반응형**(`--dxp-c-l/m/s-*` CSS 3종·breakpoint 64em/47.9375em·Step 1~4)·**커스텀 레이아웃**(Page/Theme/F6 navigation 코드)·**커스텀 내비메뉴**(Apex 인자 4종 navigationLinkSetMasterLabel/publishStatus/addHomeMenuItem/includeImageUrl)·Publish. nav: `_index/frontend.md` 1행(LWC UI/네비 섹션)·LWC MOC 네비게이션&UI·UIPatterns index 2행. cross-linker: 허브 + 형제 spoke 3건(동작·캐싱·제약·다국어·Expressions) 역링크, NavigationMixin/@api는 의도된 spoke→hub 단방향 면제 | ✅ 완료(2026-06-20) — completeness 14/14절 갭0(noninclusive-terms 법적 boilerplate 1줄만 의도적 생략 — 기술 콘텐츠 아님)·source-verifier 불일치0(모듈 14종·타깃·CSS변수·Apex인자·wikilink 7개 전수 PDF 일치)·qa PASS. Tier 3 노트 0. ★ **중복 회피:** 허브 helloSite 예제(apiVersion 67.0)는 복제 안 함, PDF 원문 myComponent 예제(apiVersion 51.0, 5 property) 정본 사용. 브랜딩 `--dxp` 색/텍스트 훅(Ch4=17c)·record 컴포넌트(Ch6=허브) 미포함. ★ **원문 표기 보존 2건 + 마커:** `lightningCommunity_Default`(언더스코어 1개)·`extends Lightning Element`(공백) PDF 원문 그대로 + 정식 표기 안내 주석. "four properties vs 코드 5개" 원문 불일치도 본문 명시. ★ 검증자 둘이 dump 자체 메타 오기("모듈 13개")를 교차 정정 — 실제 표 14행 확인. RECON-17 진행: 17a✅·17b✅ → 잔여 17c(--dxp 거대표 pdftoppm)·17d(Tag Manager) |
| RECON-17c | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, v66.0 Spring '26, Tier 2) Ch4 "Brand Your LWR Site" — RECON-17 deferred spoke 3/4. ⚠️ 8페이지 거대 다단 매핑표 | Ch4 전 하위절(13절): How Branding Works·Enable·--dxp in LWR Sites·Color/Text/Site Spacing 훅·**거대 매핑표(Theme 패널↔훅)**·Use in Custom Components·Override Custom CSS·Color Palette·Site Logo·Custom Fonts·Remove SLDS | 신규 `LWC/UIPatterns(UI패턴)/LWR --dxp 스타일링 훅 레퍼런스.md`(747줄) — `--dxp-g/-s/-c` 훅 전수·**Color family 30훅**(Root4/Brand4/Success4/Destructive4/Warning2/Info4/Neutral8, PDF 불규칙 번호라벨 보존)·**Theme 패널 속성→훅 매핑표 7 카테고리**(Colors/Images/Text/Site Spacing/Buttons/**Button Colors 3컬럼** Primary/Secondary/Tertiary/Forms, row=속성·col=훅 방향성 보존·transpose 0)·level 플레이스홀더 치환표(Text 8값·Forms 3값)·커스텀 컴포넌트 사용·Override(part/data-component-id)·Color Palette·Site Logo 훅 2종·Custom Fonts(static resource/외부호스팅)·Remove SLDS. ★ **거대 매핑표 pdftoppm r=220 이미지 셀 육안 검증**(8페이지 다단 collapse·페이지경계 절단 방지, AP-09). ★ **researcher 1차 de-scope 정정:** 후반 4절(Color Palette·Site Logo·Custom Fonts·Remove SLDS)을 임의 범위 밖 처리 → 백로그 spec대로 보강 추출(오케스트레이터 캐치). 중복 회피: 반응형 `--dxp-c-screensize`/`-l/m/s-*`는 17b(Ch3) 위임·역링크. fabricate 금지 2건(`--dxp-c-section-*`·`@salesforce/contentAssetUrl` PDF 미정의 부정 명시). 표기 보존: curly→straight quote 정규화·Color 번호라벨 원문·Site Logo `:root` 세미콜론 미표기·미디어ID. nav: `_index/frontend.md` 1행·LWC MOC·UIPatterns index 2행. cross-linker: 허브+peer 2(17b·SLDS 스타일링 훅) 역링크 | ✅ 완료(2026-06-20) — completeness 13/13절 갭0(외부 비디오 SEE ALSO 1건만 의도적 비포함, URL無 학습보조·비차단)·source-verifier 불일치0·**transpose0 매핑표 IDENTICAL**·qa PASS. Tier 3 노트 0. RECON-17 진행: 17a✅·17b✅·17c✅ → 잔여 17d(Tag Manager) |
| RECON-17d | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, v66.0 Spring '26, Tier 2) Ch7 "Manage Data in LWR Sites" + Ch6 "Examples: Use Google Tag Manager" — RECON-17 deferred spoke 4/4 (최종). ⚠️ 9개 이벤트 다단표 + 동명이의 2종 | Ch7 전수(Manage Data·Data Streams·Engagement Data·Consent Opt-In·Track to Data Cloud·**Tag Manager Event Reference 9종**) + Ch6 GTM 예제 | 신규 `LWC/UIPatterns(UI패턴)/LWR Tag Manager 데이터 관리.md`(960줄) — **★ 동명이의 2종 구분**(네이티브 Experience Tag Manager `experience_interaction`→Data Cloud Website Engagement DMO ≠ 3rd-party Google Tag Manager `<x-oasis-script>`+dataLayer). A. 네이티브 5절+공통패턴(Experience Data Layer JSON·Data Streams·Consent Opt-In 3코드·커스터마이즈). B. **Event Reference 9종 전수**(Cart 16 interaction·Catalog·Consent·Email·Engagement·Error·Line Item·Search·Wish-List, 각 Name표+Fields표+예제코드 15개). C. Google TM 예제 2종(폼·클릭 추적). **★ 9 이벤트 다단표 pdftoppm r=200 이미지(p.091-105) 셀 검증.** ★ researcher de-scope 아님 — Ch6 GTM(위키 미커버, x-oasis-script 한 줄 Tip만 존재)을 동명이의 닫기 위해 함께 흡수. 위임: Data Cloud DMO 스키마→`[[Data Cloud Objects]]`·x-oasis-script 상세→`[[Lightning Web Security (LWS)]]`. ★ classifier가 `[[Datacloud Namespace]]` 오링크 차단(Apex Duplicate Mgmt ≠ CDP). PDF 원문 오타 10건 보존+마커(`Analtyics`·닫는따옴표 누락 3·`linkhref`/`linkHref` 불일치·외톨이 `.` 3·`A single-Line` 등). nav: frontend 샤드·LWC MOC·UIPatterns index·questions 2행(교차도메인). cross-linker: 허브+peer `LWR 동작·캐싱·제약`(x-oasis Tip) 역링크 | ✅ 완료(2026-06-20) — completeness 갭0(9이벤트 Name/Fields/코드 셀단위·코드15/15)·source-verifier 불일치0(코드16블록 diff 0라인·표67행 grep 일치·오타10건 보존+마커)·qa PASS. Tier 3 노트 0. **★★ RECON-17 전체(17a~d) 종결 — exp_cloud_lwr.pdf(106p) 완전 위키화 완료. ING-10a "완료" 표기가 H2 단위로는 thin slice였던 것을 4 spoke로 전수 보강.** |
| RECON-15 | `object_reference.pdf` (v67.0 Summer '26, Tier 2) Ch1 "Field and Type Differences in Salesforce Apps and APIs"(doc p.29) — API↔UI 필드 타입 매핑표. RECON-3 ⑤ 감사 산출물(유일 미커버, 저가치) | API 데이터타입(ID/string/boolean/double/Varies) ↔ UI 필드타입 매핑 + UI 전용 타입(BusinessHours time)·label 변경 제약 | **in-place 보강**(신규 노트 아님) — 기존 `sObject/Field Types.md` 말미에 §"Salesforce 앱과 API의 필드·타입 차이" 추가(매핑 5행 + UI전용 타입·label 제약 2항목). writer 셀단위 대조: 원문 "rich text"→"rich text area" 교정 | ✅ 완료(2026-06-20) — RECON-3 ⑤ closure 산출물. Tier 3 노트 0 |
| RECON-16 | `apex_developer_guide.pdf` (v67.0 Summer '26, Tier 2) "Invoking Apex" 챕터 — 'Triggers for Chatter Objects'(FeedItem/FeedComment) + 'Trigger Considerations for Knowledge Articles'(KAV) 트리거 고려사항 미커버. **apex_developer_guide.pdf 문서 마지막 미커버 챕터** — RECON-13 작업 중 completeness-validator 발견 | print p.282-285 / 물리 p.286-289(오프셋 +4). 두 하위절 인접·연속, 이미지/다단표 없음, 코드 2개 | 신규 `Apex/Trigger(트리거)/특정 표준 객체 트리거 고려사항 — Chatter · Knowledge.md` — **① Chatter**: FeedItem·FeedComment triggerable(FeedAttachment는 SOQL 접근)·삽입 가능 type 6종 전수·before insert 미제공 필드(ContentSize·ContentType / ContentData delete 불가)·ConnectApi 영향 메서드 10종·FeedItem update 발화 조건·CollaborationGroup/Member 연쇄·private group 보안·FeedItemTrigger 코드 + SEE ALSO 6 외부 Object Reference 텍스트 명시. **② Knowledge**: KAV 트리거 매핑 4종(create/edit/delete/import)·Publish/Archive 미발화·**액션별 트리거 발화 매트릭스**(Save·Edit/Edit as Draft[하위 4]·Cancel/Delete·Submit for Translation·Assign + 미발화 2종 — 원문 동사 셀별 보존)·Lightning 마이그레이션 영향·KAVTrigger 코드. 일반 트리거 메커니즘(컨텍스트 변수·이벤트 가용성·벌크 관용구)은 RECON-12/13 노트 deep-link 위임(중복 회피). nav: `_index/apex-core.md` 트리거 섹션 키워드 행·`_index/questions.md` 2행(공식 예외, Chatter/Knowledge 자연어)·`Apex MOC` 아키텍처/트리거·`Apex/Trigger(트리거)/index.md`. cross-linker: peer 역링크 4건(컨텍스트변수·벌크관용구·KbManagement·ConnectApi Chatter 패턴), Order of Execution·Knowledge 개요는 hub 단방향 면제 | ✅ 완료(2026-06-20) — completeness 갭 0(SEE ALSO 경미 갭 보강 완료)·source-verifier 불일치 0(API·필드·코드 AP-09 절단 없음·매트릭스 4 sub-row 매핑·tier·wikilink 전부 PDF 일치)·qa PASS. Tier 3 노트 0. ★ **RECON-3 ① 완전 종결: apex_developer_guide.pdf 전 챕터 커버 완료** — 잔여 미커버 챕터 0. ★ scout가 "Edit, Edit as Draft" 하위 3개로 안내했으나 researcher/validator 원문 실측 **4개** 정정 |

---


### L — 깨진 wikilink — 신규 파일 필요 (wiki-linter 2026-05-21)

> 2026-05-21 `/lint` 결과. 6개 링크는 즉시 수정 완료. 아래 9개는 대상 파일 없어 신규 작성 필요.
> `[[Spring '26]]`은 P2-02와 동일 항목.

| # | 깨진 링크 | 참조 위치 | 권장 파일 경로 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|---|
| L-02 | `[[LWC API 버전 관리]]` | `Release/Winter '24.md` | `LWC/ComponentAPI(컴포넌트API)/LWC API 버전 관리.md` | P2 | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-03 | `[[Custom Metadata Types]]` | `Release/Winter '24.md` 외 | `Architecture(아키텍처)/Custom Metadata Types.md` | P2 | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-04 | `[[lightning-tabset]]` | LWC BaseComponents index | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` | P3 (→ P3-05 연관) | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-05 | `[[DevOps Center]]` | Release 노트 | `Architecture(아키텍처)/DevOps Center.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-06 | `[[Enhanced Domains]]` | Release 노트 | `Architecture(아키텍처)/Enhanced Domains.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-07 | `[[External Services]]` | `Release/Winter '26.md` | `Integration(통합)/External Services.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-08 | `[[Platform Encryption]]` | Release 노트 | `Apex/Security(보안)/Platform Encryption.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-09 | `[[SLDS LWC 디자인 시스템]]` | LWC 관련 노트 | `LWC/UIPatterns(UI패턴)/SLDS LWC 디자인 시스템.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |

---

### I — 깨진 인덱스 경로 — 샤드 등재됐으나 파일 없음 (lint 2026-05-21)

> 2026-05-21 `/lint` 결과. 키워드 샤드가 존재하지 않는 파일을 가리키던 8건.
> 2건은 실존 유사 파일로 **재연결 완료**(백로그 불필요): `Governor Limits 빠른 참조` → `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md`, `Change Data Capture` → `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md`.
> 아래 6건은 대상 파일 없어 샤드에서 행 제거 + 신규 작성 대기. (제거된 키워드는 작성 시 복원)

| # | 제거된 항목 | 제거 위치 | 권장 파일 경로 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|---|
| I-01 | Validation Rules 예제 (키워드 7행: REGEX/SSN/우편번호/날짜/숫자/소유자 검증 등) | `_index/apex-core.md` | `Architecture(아키텍처)/Validation Rules 예제.md` | P2 | ✅ 완료(2026-05-22) — 파일 신규 작성 + 키워드 복원 | 2026-05-21 |
| I-02 | fsccashflow Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/fsccashflow Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-03 | renew_assets_summary Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/renew_assets_summary Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-04 | Sfdc_Checkout Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/Sfdc_Checkout Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-05 | Sfdc_Enablement Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/Sfdc_Enablement Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-06 | sfdc_surveys Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/sfdc_surveys Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |

---

### C — 커버리지 재산출 (2026-05-22, wiki-retrospective 모드 B)

> `pdftotext "Salesforce Documents/salesforce_apex_reference_guide.pdf"` → 네임스페이스 헤딩(`^X Namespace$`) 추출 ↔ `find forceNote-wiki -name "*Namespace*.md"` 대조.
> **~70개 중 63개 커버(~93%).** 핵심은 전부 있음. 누락은 니치뿐.

**내부 전용 — 작성 제외** (PDF가 "reserved for internal use only" 명시):
- `flowuiruntime`, `setup_flow_performance`

**작성 대상 누락 네임스페이스 6개:**

| # | 네임스페이스 | 설명 (PDF) | 우선순위 | 권장 경로 | 비고 |
|---|---|---|---|---|---|
| C-01 | DataRetrieval | 상담원-고객 engagement 상세 + 대화 transcript (Engagement·RecordTranscripts 등) | P2 | `Apex/Integration(통합)/DataRetrieval Namespace.md` | ✅ 완료(2026-05-22) — 스텁(PDF p.2761 클래스 인벤토리만 수록, 상세는 Service Cloud 개발자 가이드 참조) |
| C-02 | Sfdc_Checkout | B2B Commerce 체크아웃 (AsyncCartProcessor·B2BCheckoutController 등) | P2 | `Apex/Integration(통합)/Sfdc_Checkout Namespace.md` | ✅ 완료(2026-05-23) — = I-04 |
| C-03 | fsccashflow | FSC CashFlow Flexcard 유틸 (FSCCashFlowUtil) | P3 | `Apex/Integration(통합)/fsccashflow Namespace.md` | ✅ 완료(2026-05-23) — = I-02 |
| C-04 | renew_assets_summary | 갱신 가능 자산 → 갱신 Opportunity (Revenue Cloud) | P3 | `Apex/Integration(통합)/renew_assets_summary Namespace.md` | ✅ 완료(2026-05-23) — = I-03 |
| C-05 | Sfdc_Enablement | Enablement/Sales Programs 학습 평가 (LearningEvaluation 등) | P3 | `Apex/Integration(통합)/Sfdc_Enablement Namespace.md` | ✅ 완료(2026-05-23) — = I-05 |
| C-06 | sfdc_surveys | 설문 초대 링크 단축 (SurveyInvitationLinkShortener) | P3 | `Apex/Integration(통합)/sfdc_surveys Namespace.md` | ✅ 완료(2026-05-23) — = I-06 |

**확인 사항:**
- `industriesNlpSvc`: 위키 커버 확인됨 (헤딩 추출엔 안 잡혔으나 페이지 존재).
- `RulesAppIn Namespace.md`: PDF 표기는 `RulesAppln` (Rules Application). 위키 파일명이 오타(`I`↔`l`)일 수 있음 — 내용은 커버됨. **파일명 검토 권장**.

**배치 실행 계획 (Step 2/3):**
- **배치 A (P2, 2개):** C-01 DataRetrieval, C-02 Sfdc_Checkout
- **배치 B (P3, 4개):** C-03 fsccashflow, C-04 renew_assets_summary, C-05 Sfdc_Enablement, C-06 sfdc_surveys
- 각 페이지: 표준 파이프라인 1회전 (scout→researcher→classifier→writer ∥ coverage-checker→completeness-validator(깊이)→source-verifier→index-manager(샤드 `apex-namespaces`)→cross-linker→qa→wiki-retrospective A). PDF 소스 라인은 위 grep 기준 — DataRetrieval≈98786, Sfdc_Checkout≈117968, fsccashflow≈101997, renew_assets_summary≈111194, Sfdc_Enablement≈118087, sfdc_surveys≈118337.

> ✅ **2026-05-22 깊이 감사 완료:** Database·Schema 두 파일 전수 보완 완료.
> - **Schema** (306 → 692줄): SObjectType·SObjectField·SObjectDescribeOptions·FieldDescribeOptions·SOAPType(전수)·DisplayType(누락 14개)·DescribeSObjectResult 누락 메서드 13개·DescribeFieldResult 누락 메서드 15개·DataCategory·DataCategoryGroupSobjectTypePair·DescribeColorResult·DescribeDataCategoryGroupResult·DescribeDataCategoryGroupStructureResult·DescribeIconResult·DescribeTabResult·DescribeTabSetResult 추가
> - **Database** (519 → 604줄): DMLOptions.localeOptions·AssignmentRuleHeader.assignmentRuleId·DuplicateRuleHeader.runAsCurrentUser·DMLOptions 프로퍼티 전수 표·QueryLocatorIterator 클래스 메서드 문서화 추가
> - System(V-09)·ConnectApi(V-10)·Auth 는 기존 검증 완료로 이번 사이클 스킵.
> 🔎 **다음 권장:** ConnectApi Namespace 개요(V-10)는 2,000페이지 분량 — 깊이보다 breadth 우선이므로 현재 유지. N2-03(UI API 개요), L-02·L-03(깨진 링크) 작성이 다음 P2.

---

### SO — sObject Reference 챕터 세부 페이지 확장 (object_reference.pdf v67.0)

> **배경:** 2026-05-22. 기존 `sObject/Ch1~Ch6` 챕터 요약 페이지를 PDF 원문 기준 세부 서브페이지로 분화.
> Ch1~Ch5는 각 개념·오브젝트별 개별 세부 페이지(문서 많아도 OK), Ch6는 서비스 클라우드 도메인별 분류 페이지.
> 소스: `Salesforce Documents/object_reference.pdf` (v67.0) — 물리 페이지 = 문서 페이지 + 42 (오프셋).
> **작성 순서:** Ch1 → Ch2 → Ch3 → Ch4 → Ch5 순서로 진행. Ch6는 도메인 분류만 (상세 설명 불필요).

---
> #### ▶ 다음 세션 재개 지점
>
> **sObject Reference 전체 완료 (Ch1~Ch6, 31개 서브페이지)**
>
> - Ch1 (10개) ✅ · Ch2 (3개) ✅ · Ch3 (4개) ✅ · Ch4 (3개) ✅ · Ch5 (3개) ✅ · Ch6 (8개) ✅
>
> **다음 권장 작업:** 백로그 N3 시리즈 (Experience Cloud·Reports API·Tooling API 등) 또는 `/lint` 전체 점검
---

#### SO-Ch1 — Overview of Salesforce Objects and Fields (doc pp.1–39 / 물리 pp.43–81)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C1-01 | Primitive Data Types — base64·boolean·byte·date·dateTime·double·int·long·string·time 10개 타입 전수 설명 | p.1–3 | `sObject/Primitive Data Types.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-02 | Field Types — address·anyType·calculated·combobox·currency·DataCategoryGroupReference·email·encryptedstring·ID·JunctionIdList·location·masterrecord·multipicklist·percent·phone·picklist·reference·textarea·url + reserved 2개 전수 | p.4–10 | `sObject/Field Types.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-03 | API Field Properties — Aggregatable·Autonumber·Create·Defaulted on create·Delete·Filter·Group·idLookup·Namepointing·Nillable·Query·Restricted picklist·Retrieve·Sort·Update 15개 전수 | p.11–12 | `sObject/API Field Properties.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-04 | System Fields & Required Fields — Id·IsDeleted·LastReferencedDate·LastViewedDate·CreatedById·CreatedDate·LastModifiedById·LastModifiedDate·SystemModstamp + Audit Fields 규칙 + Frequently Occurring Fields (OwnerId·RecordTypeId·CurrencyIsoCode) | p.12–15 | `sObject/System Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-05 | Compound Fields — Address 복합 필드 (서브필드 전수·SOQL GEOLOCATION 활용·DISTANCE 예제), Geolocation 복합 필드 (Location 타입·`__latitude__s`/`__longitude__s` 표기), 복합 필드 제한사항 전수 | p.15–20 | `sObject/Compound Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-06 | Custom Objects — 이름 규칙·관계(Master-Detail 불가 표준 오브젝트 목록)·Audit Fields 설정 절차·Sharing 오브젝트(__Share)·Tags 오브젝트(__Tag)·Required Fields(nillable)·Managed Packages 네임스페이스 prefix | p.21–23 | `sObject/Custom Objects.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-07 | Custom Fields — 이름 규칙·External ID(text/number/email 전용)·Uniqueness(caseSensitive)·Default Values 수식 제한·Managed Packages prefix 변환 | p.24–25 | `sObject/Custom Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-08 | Object Relationships & Data Access — Master-Detail·Many-to-many(Junction)·Lookup 비교표, 데이터 접근 팩터(OLS·FLS·User Permissions·Sharing·Referential Integrity·Page Layouts 비적용), View All / Modify All 권한 | p.25–29 | `sObject/Object Relationships.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-09 | External Objects — Salesforce Connect 어댑터(Cross-org·OData 2.0·OData 4.0·Custom Apex), Files Connect 어댑터(Google Drive·Box·SharePoint·OneDrive), External Object 관계(External Lookup·Indirect Lookup) | p.29–31 | `sObject/External Objects.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-10 | Big Objects — Standard(__b) vs Custom(__b), Use Cases(360° 뷰·감사·Historical Archive), sObject와 차이(비트랜잭션·분산DB), Metadata 정의 XML 전수(CustomObject·CustomField·Index·IndexField), Deploy·View 절차 | p.31–38 | `sObject/Big Objects.md` | ✅ 완료 | 2026-05-22 |

#### SO-Ch2 — Salesforce Object Behavior (doc pp.40–54 / 물리 pp.82–96)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C2-01 | Object Groups — Common Objects (Original·Base Platform·Setup Platform·Custom), Cloud Objects, High-Scale Objects, External Data; 데이터 도메인별·트랜잭션 유형별(ACID/OLTP/OLAP) 분류 | p.40–44 | `sObject/Object Groups.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C2-02 | Data Cloud Objects — DLO·DMO·UDLO·UDMO·CIO·Data Graphs·Unified Objects·Zero Copy 정의 + DMO/UDMO 생성 흐름(DLO→DMO→Identity Resolution→UDMO→CIO→DG) | p.44–51 | `sObject/Data Cloud Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C2-03 | Object Types Reference & Cheatsheet — suffix 표 전수(__b·__c·__ChangeEvent·__chn·__cio·__dg·__DataCategorySelection·__dlm·__dlo·__dmo·__dso·__e·__Feed·__hd·__History·__mdt·__x 등), 오브젝트 타입별 Cheatsheet(Customizable·Cloud·Packaging·Documentation) | p.51–54 | `sObject/Object Types Reference.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch3 — Associated Objects (doc pp.55–77 / 물리 pp.97–119)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C3-01 | Feed Objects (StandardObjectNameFeed) — 전체 필드 참조표(BestCommentId·Body·CommentCount·ConnectionId·ContentData·ContentFileName·ContentSize·ContentType·FeedPostId·InsertedById·IsRichText 지원 HTML 태그·LikeCount·LinkUrl·NetworkScope·ParentId·RelatedRecordId·Title·Type·Visibility), Type picklist 20+개 값 전수, SOQL 제한 | p.55–62 | `sObject/Feed Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-02 | History Objects (StandardObjectNameHistory) — 필드 참조표(StandardObjectNameId·DataType·Field·NewValue·OldValue), 지원 호출 전수, v42.0+ delete() 활성화 방법 | p.63–64 | `sObject/History Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-03 | Share & OwnerSharingRule Objects — Share 필드(AccessLevel·ParentId·RowCause·UserOrGroupId)·OwnerSharingRule 필드(AccessLevel·Description·DeveloperName·GroupId·Name·UserOrGroupId), RowCause=Manual 전용 쓰기 규칙 | p.65–67 | `sObject/Share Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-04 | ChangeEvent Objects (CDC) — 전체 필드·ChangeEventHeader 상세(entityName·recordIds·changeType·changeOrigin·transactionKey·sequenceNumber·commitTimestamp·commitUser), JSON 이벤트 메시지 예제, CDC 지원 오브젝트 목록 전수(100+개), replayId·schema 필드 | p.68–77 | `sObject/ChangeEvent Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch4 — Custom Objects (doc pp.78–94 / 물리 pp.120–136)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C4-01 | Custom Metadata Type (__mdt) — 전체 필드 참조표(Custom Field__c·DeveloperName·isProtected·Label·Language·MasterLabel·NamespacePrefix·QualifiedApiName·SystemModStamp), isProtected 관리 패키지 접근 규칙(동일 패키지·타 패키지·구독자 코드 규칙) | p.80–82 | `sObject/Custom Metadata Type (__mdt).md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C4-02 | Custom Object Standard Fields (__c) — 전체 표준 필드 참조표(ConnectionReceivedId·ConnectionSentId·CreatedById·CreatedDate·CurrencyIsoCode·Id·IsDeleted·LastActivityDate·LastModifiedDate·LastModifiedById·LastReferencedDate·LastViewedDate·Name·OwnerId·RecordTypeId·SystemModStamp) + 지원 호출 전수 | p.83–87 | `sObject/Custom Object Standard Fields (__c).md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C4-03 | Custom Object Feed (__Feed) — 전체 필드 참조표(BestCommentId·Body·CommentCount·ConnectionId·ContentData·ContentFileName·ContentSize·ContentType·FeedPostId·InsertedById·IsRichText·LikeCount·LinkUrl·NetworkScope·ParentId·RelatedRecordId·Title·Type·Visibility), SOQL 제한, 삭제 접근 규칙 | p.87–94 | `sObject/Custom Object Feed (__Feed).md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch5 — Object Interfaces (doc pp.95–104 / 물리 pp.137–146)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C5-01 | PriceAdjustmentGroup Interface — 전체 필드 참조표(AdjustmentSource·AdjustmentType·AdjustmentValue·Description·ImplementorType·PriceAdjustmentCauseId·Priority·SalesTransactionId·TotalAmount), AdjustmentSource picklist 값(Discretionary·Promotion·Rule·System), 사용 조건(Subscription Management / B2B Commerce) | p.96–97 | `sObject/PriceAdjustmentGroup.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C5-02 | PriceAdjustmentItem Interface — 전체 필드 참조표(AdjustmentAmountScope·AdjustmentSource·AdjustmentType·AdjustmentValue·Description·ImplementorType·PriceAdjustmentCauseId·PriceAdjustmentGroupId·Priority·SalesTransactionItemId·TotalAmount), AdjustmentAmountScope (Total vs Unit) 수식 계산 예제 | p.98–102 | `sObject/PriceAdjustmentItem.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C5-03 | SalesTransaction Interface — 전체 필드 참조표(ImplementorType·TotalAdjustmentAmount·TotalAdjustmentDistAmount·TotalAmount·TotalListAmount·TotalProductAmount), 사용 조건(Subscription Management / B2B Commerce), 구현체 오브젝트 패턴(Order·WebCart 등) | p.103–104 | `sObject/SalesTransaction.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch6 — Standard Objects 도메인 분류 (object_reference.pdf — Ch6 범위)

> Ch6는 각 Standard Object별 상세 설명 없이 **서비스 클라우드 도메인별 오브젝트 목록 분류**만 작성.

| # | 도메인 | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|
| SO-C6-01 | Core CRM — Account·Contact·Lead·Opportunity·Campaign·Case·Contract·Pricebook2·Product2·Quote 등 | `sObject/Core CRM Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-02 | Service Cloud — Entitlement·ServiceContract·SocialPost·LiveChatTranscript·MessagingSession·Knowledge__kav 등 | `sObject/Service Cloud Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-03 | B2B Commerce & Revenue — WebCart·CartItem·WebStore·OrderSummary·PendingOrderSummary 등 | `sObject/B2B Commerce Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-04 | Field Service — ServiceAppointment·ServiceResource·ServiceTerritory·WorkOrder·MaintenancePlan 등 | `sObject/Field Service Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-05 | Platform & Admin — User·Group·Profile·PermissionSet·RecordType·FlowRecord·CustomField·CustomObject 등 | `sObject/Platform Admin Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-06 | Files & Content — ContentDocument·ContentVersion·ContentDocumentLink·ContentFolder 등 | `sObject/Files Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-07 | Analytics & Data Cloud — WaveAutoInstallRequest·DataUsePurpose·DataUseLegalBasis 등 | `sObject/Analytics Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-08 | Experience Cloud & Collaboration — Network·CollaborationGroup·Topic·FeedItem 등 | `sObject/Experience Cloud Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

---

### DX — Salesforce DX Developer Guide 전수 작성 (sfdx_dev.pdf v67.0 Summer '26)

> **배경:** 2026-05-22. 소스: `Salesforce Documents/sfdx_dev.pdf` = *Salesforce DX Developer Guide* Version 67.0 (Summer '26), 364페이지, 16개 챕터. 추출 텍스트 `/tmp/sfdx_dev.txt` (세션 간 미유지 — 재추출은 scout 담당). PDF에 stream length 경고가 있어 일부 페이지는 재추출 필요할 수 있음.
> **오프셋 주의:** 위 페이지(p.)는 모두 **문서(doc) 페이지** 기준. 추출 텍스트 라인 기준 챕터 시작: Ch1≈L231·Ch2≈L897·Ch3≈L1323·Ch4≈L2779·Ch5≈L3479·Ch6≈L3494·Ch7≈L10025·Ch8≈L10463·Ch9≈L10973·Ch10≈L11512·Ch11≈L12335·Ch12≈L13100·Ch13≈L13375·Ch14≈L16765·Ch15≈L17561·Ch16≈L17992.
> **기존 커버리지(중복 분석):** `DevOps(데브옵스)/` 4개 노트(`Salesforce DX 개요`·`Scratch Org 패턴`·`Unlocked Package 패턴`·`CI CD 패턴`)는 모두 **핵심 명령만 발췌한 패턴 요약 수준**으로, 깊이 원칙(전수)을 충족하지 못한다. 전략: 기존 4개 노트는 각 도메인 **허브/요약**으로 유지(중복 키워드 행 금지), 세부는 신규 심층 서브페이지로 분화. `1 페이지 = 1 홈 샤드` 규칙 준수.
> **폴더:** 전부 `DevOps(데브옵스)/` 하위(English(한글) 규칙). 대형 챕터(Ch6 Scratch Orgs, Ch13 Unlocked Packages)는 한 파일이 커지면 아래 제안대로 서브 분할.
> **우선순위:** P1 = 핵심 워크플로우(Project Setup·Authorization·Scratch Orgs·Source Tracking·Development). P2 = 보조 워크플로우(Access·Sandboxes·Data·Build/Release·Packages·CI). P3 = 주변(How DX·Metadata Coverage·MCP Beta·Troubleshoot·Limitations).
> **작성 순서 권장:** P1(DX-C3 → DX-C4 → DX-C6 → DX-C8 → DX-C11) → P2 → P3.

#### DX-C1 — How DX Tooling Changes the Way You Work (doc p.1–14 / ~L231)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C1-01 | DX 도구가 바꾸는 개발 방식 — Get Started/Sample Repo, Create App, Migrate Source, Release Notes 개요. 기존 `Salesforce DX 개요`의 도입부 보완 또는 신규 개요 페이지 | p.1–14 | `DevOps(데브옵스)/DX 도구 개요와 워크플로 전환.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C2 — Provide Developers Access to DX Tools (doc p.15–23 / ~L897)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C2-01 | DX 도구 접근 권한 — Dev Hub 활성화, Source Tracking 활성화, DX 사용자/라이선스/Permission Set 부여 전수 | p.15–23 | `DevOps(데브옵스)/DX 도구 접근 권한.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C3 — Project Setup (doc p.24–56 / ~L1323) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C3-01 | DX Project 구조 & Source Format — 프로젝트 생성, 소스 포맷 개념, 프로젝트 디렉토리 구조. 기존 `Salesforce DX 개요`와 일부 중복(요약 수준) → 심층 신규 | p.24–35 | `DevOps(데브옵스)/DX 프로젝트 구조와 소스 포맷.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C3-02 | Decomposed Metadata Types & .forceignore — 기본/선택 분해(Beta) 전수, decompose 동작 명령, `.forceignore` 문법·예제 전수. 기존 `Salesforce DX 개요` 요약분 → 심층 신규 | p.35–45 | `DevOps(데브옵스)/메타데이터 분해와 forceignore.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C3-03 | sfdx-project.json 전체 설정 — 모든 필드 전수(packageDirectories·namespace·sourceApiVersion·sfdcLoginUrl·plugins·packageAliases 등), Multiple Package Directories, String Replacement, namespace 링크 | p.45–56 | `DevOps(데브옵스)/sfdx-project.json 레퍼런스.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C4 — Authorization (doc p.57–70 / ~L2779) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C4-01 | DX 인증 전수 — 브라우저 로그인, JWT Flow(Private Key/Cert 생성 절차 포함), External Client App, Connected App, SFDX Auth URL, Logout. 기존 `Salesforce DX 개요`·`CI CD 패턴`의 JWT 요약분 → 심층 통합 신규 | p.57–70 | `DevOps(데브옵스)/DX 인증 방식.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C5 — Metadata Coverage (doc p.71 / ~L3479) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C5-01 | Metadata Coverage Report — 메타데이터 커버리지 보고서 사용법(짧은 챕터). DX-C1 개요 페이지에 통합 또는 단독 짧은 페이지 | p.71 | `DevOps(데브옵스)/Metadata Coverage 보고서.md` (신규, 짧음) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C6 — Scratch Orgs (doc p.72–202 / ~L3494) — P1 · 대형 챕터 → 서브 분할

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C6-01 | Scratch Org 개요 & 생성 — Editions/Allocations, 생성 명령, Definition File 전수, Features 전수 목록. 기존 `Scratch Org 패턴`(요약) → 심층 분화/보완 | p.72–120 | `DevOps(데브옵스)/Scratch Org 생성과 정의 파일.md` (신규/보완) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C6-02 | Scratch Org Settings (전수) — project-scratch-def.json `settings` 블록 전체 옵션 전수 (doc p.168 영역) | p.120–180 | `DevOps(데브옵스)/Scratch Org Settings 레퍼런스.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C6-03 | Org Shape & Snapshots — Org Shape 생성/사용, Snapshot 생성/관리/활용 전수. 기존 `Scratch Org 패턴` 요약분 → 심층 신규 | p.180–195 | `DevOps(데브옵스)/Org Shape와 Snapshot.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C6-04 | Scratch Org 배포/유저/에러 — Deploy/Retrieve, Scratch Org Users 관리, Error Codes 전수표 | p.195–202 | `DevOps(데브옵스)/Scratch Org 배포·유저·에러코드.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C7 — Sandboxes (doc p.203–210 / ~L10025) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C7-01 | Sandbox 관리 — Authorize Prod, Sandbox Definition File 전수, Create/Clone/Refresh 전수 | p.203–210 | `DevOps(데브옵스)/Sandbox 관리.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C8 — Track Changes / Source Tracking (doc p.211–220 / ~L10463) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C8-01 | Source Tracking 전수 — Preview, Deploy/Retrieve, Profiles, Conflicts 해결, Best Practices, Performance. 기존 `Salesforce DX 개요`의 Source Tracking 요약분 → 심층 신규 | p.211–220 | `DevOps(데브옵스)/Source Tracking 변경 추적.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C9 — Work with Data (doc p.221–231 / ~L10973) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C9-01 | DX 데이터 작업 — Small/Large Datasets(tree import/export, bulk), Individual Records(data create/get/update/delete record), SOQL/SOSL(data query), Upload File 전수 | p.221–231 | `DevOps(데브옵스)/DX 데이터 작업.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C10 — Salesforce DX MCP Server and Tools (Beta) (doc p.232–245 / ~L11512) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C10-01 | DX MCP Server (Beta) — VS Code+Copilot Quick Start, Install/Configure, Core Tools 전수. (Metadata API MCP Tool과 별개 — DX CLI MCP) | p.232–245 | `DevOps(데브옵스)/DX MCP Server (Beta).md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C11 — Development (doc p.246–261 / ~L12335) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C11-01 | DX 개발 워크플로 — Develop Against Any Org, Permission Set, Lightning/LWC/Apex/Trigger/Custom Object 생성 명령 전수, Anon Apex 실행, Run Tests, Debug Apex, Debug Logs 전수 | p.246–261 | `DevOps(데브옵스)/DX 개발 워크플로.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C12 — Build and Release Your App (doc p.262–268 / ~L13100) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C12-01 | Metadata API 빌드/릴리스 워크플로 — Local Dev, Build/Test Artifact, Staging, Production, Cancel Deployment 전수. (MetadataAPI 서브폴더와 인접하나 소스 다름 — 워크플로 관점) | p.262–268 | `DevOps(데브옵스)/Metadata API 빌드·릴리스 워크플로.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C13 — Unlocked Packages (doc p.269–325 / ~L13375) — P2 · 대형 챕터 → 서브 분할

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C13-01 | Unlocked Package 개념 & 준비 — 개념, Before You Create, Org-Dependent 패키지. 기존 `Unlocked Package 패턴`(요약) → 심층 분화/보완 | p.269–285 | `DevOps(데브옵스)/Unlocked Package 개념과 준비.md` (신규/보완) | ✅ 완료(2026-05-23) | 2026-05-22 |
| DX-C13-02 | 패키지 생성·설정·의존성 — Workflow, Configure, Keywords, Dependencies, Profile Settings 전수 | p.285–300 | `DevOps(데브옵스)/Unlocked Package 생성과 설정.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |
| DX-C13-03 | 패키지 개발·버전·코드커버리지 — Develop, Versions, Code Coverage 전수 | p.300–312 | `DevOps(데브옵스)/Unlocked Package 개발과 버전.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |
| DX-C13-04 | 패키지 릴리스·설치·전환 — Release, Push Upgrade, Install, Migrate Deprecated, Uninstall, Transfer 전수 | p.312–325 | `DevOps(데브옵스)/Unlocked Package 릴리스와 설치.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C14 — Continuous Integration (doc p.326–343 / ~L16765) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C14-01 | CI 통합 전수 — CircleCI, Jenkins+Jenkinsfile, Travis CI, Sample CI Repos 전수. 기존 `CI CD 패턴`(Jenkins/CircleCI 요약) → 심층 분화/보완(Travis·샘플 레포 추가) | p.326–343 | `DevOps(데브옵스)/CI 통합 전수 (CircleCI·Jenkins·Travis).md` (신규/보완) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C15 — Troubleshoot Salesforce DX (doc p.344–353 / ~L17561) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C15-01 | DX 트러블슈팅 — org login web/jwt Errors, No default dev hub, Consumer key taken, CLI Version 문제 전수 | p.344–353 | `DevOps(데브옵스)/DX 트러블슈팅.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C16 — Limitations for Salesforce DX (doc p.354 / ~L17992) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C16-01 | DX 제약사항 — Salesforce DX 한계 전수(짧은 챕터) | p.354–364 | `DevOps(데브옵스)/DX 제약사항.md` (신규, 짧음) | ✅ 완료(2026-05-23) | 2026-05-22 |


---

### 보완 필요 기존 파일

| # | 파일 | 부족한 부분 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| F-01 | `Apex/Integration(통합)/ConnectApi Chatter 패턴.md` | Chatter만 있음. Communities/UserProfiles 미커버 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| F-02 | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` | Apex Cursor(Summer '24 GA)와 비교 없음 | ✅ 완료 | 2026-05-18 | 2026-05-19 |

---

### V — 기존 파일 Apex Reference 검증 대기

> **규칙:** Apex Reference v67.0 PDF **하나만** 보면서 순서대로 검증. 다른 PDF 병행 금지.
> 검증 기준: 클래스 전체 포함 여부 / 메서드 시그니처 정확성 / 예제 코드 원문 수록 여부

| # | 파일 | Apex Ref PDF 페이지 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| V-01 | `Apex/Security(보안)/TxnSecurity Namespace.md` | p.4445~4453 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-02 | `Apex/Integration(통합)/Support Namespace.md` | p.3580~3583 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-03 | `Architecture(아키텍처)/Context Namespace.md` | p.2688 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-04 | `Apex/Data(데이터)/Datacloud Namespace.md` | p.2741~2760 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-05 | `Apex/Integration(통합)/Flow Namespace.md` | p.2880~2884 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-06 | `Apex/Testing(테스트)/Flowtesting Namespace.md` | p.2885~2892 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-07 | `Architecture(아키텍처)/Site Namespace.md` | p.3576~3580 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-08 | `Apex/Integration(통합)/KbManagement Namespace.md` | p.2968~2979 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-09 | `Architecture(아키텍처)/System Namespace.md` | p.3584~4440 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-10 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | p.663~2687 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-11 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` | p.2865~2879 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-12 | `Apex/Integration(통합)/DataWeave Namespace.md` | p.2841~2858 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-13 | `Apex/Integration(통합)/Compression Namespace.md` | p.646~662 | ✅ 완료 | 2026-05-20 | 2026-05-20 |

---

## 상태 범례

| 아이콘 | 의미 |
|---|---|
| 🔲 대기 | 아직 작업 시작 전 |
| 🟡 진행중 | 현재 작업 중 |
| ✅ 완료 | 작업 완료 + wiki 반영 확인 |
| ❌ 보류 | 소스 미확보 등의 이유로 보류 |

---

## 완료 아카이브

| # | 주제 | 완료일 | 비고 |
|---|---|---|---|
| P1-01 | `Apex/Integration(통합)/Compression Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.646 |
| P1-02 | `LWC/Testing(테스트)/` Jest 테스트 3종 | 2026-05-18 | Tier 3 (외부 지식) |
| P1-03 | `Apex/Integration(통합)/DataWeave Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.2841 |
| P2-01 | `Release/Winter '25.md` (v62.0) | 2026-05-18 | Tier 3 (external-knowledge) |
| P2-03 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.2865 |
| P2-04 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | 2026-05-18 | Apex Ref v67.0 p.663 |
| P3-01 | `Architecture(아키텍처)/System Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.3584 |
| P3-02 | `Apex/Integration(통합)/KbManagement Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2968 |
| P3-03 | `Architecture(아키텍처)/Site Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.3576 |
| P3-04 | `Apex/Testing(테스트)/Flowtesting Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2885 |
| F-01 | ConnectApi Communities/UserProfiles 보완 | 2026-05-19 | Apex Ref v67.0 p.1499, 1972 |
| F-02 | 비동기 컨텍스트 선택 — Apex Cursor 추가 | 2026-05-19 | Apex Ref v67.0 p.2692 |
| P1-04 | `Apex/Integration(통합)/Flow Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2880~2884 |
| P1-05 | `Apex/Security(보안)/TxnSecurity Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.4445~4453 |
| P1-06 | `Apex/Integration(통합)/Support Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.3580~3583 |
| P1-07 | `Architecture(아키텍처)/Context Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2688 (Industries Cloud 전용) |
| P1-08 | `Apex/Data(데이터)/Datacloud Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2741~2760 (Duplicate Management) |
| P2-05 | `Architecture(아키텍처)/ApexPages Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.10~42 (Visualforce 컨트롤러 8개 클래스) |
| P2-06 | `Architecture(아키텍처)/AppLauncher Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.43~47 (AppMenu 3개 메서드, 나머지 8개 internal only) |
| P2-07 | `Apex/Integration(통합)/LxScheduler Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2980~3022 (14개 클래스/인터페이스, Salesforce Scheduler 외부 캘린더 연동) |

---

## 관련 에이전트

- [[wiki-retrospective]] — 모드 B에서 이 백로그를 읽고 업데이트하며 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
