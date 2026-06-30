---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-06-27
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
| ING-26 | `api_tooling.pdf` (= **Tooling API Reference & Developer Guide v67.0 Summer '26**, 1006p, Tier 2) — 대형 단일-PDF 멀티사이클 인제스트. 신규 폴더 `DevOps(데브옵스)/ToolingAPI(툴링API)/` | **콘텐츠 노트 17종 전수 위키화 완료**(N1~N3 경계구역 + Ch4 객체 14노트). 경계: N1 개요·REST·SOAP(d44c446)·N2 Objects&Namespaces(8783e10)·N3 SOAP·REST 헤더(963c084). Ch4: C4-1 Apex(9966613)·C4-6 Entity·Field(ec365ae)·C4-5 보안·권한 38+3서브(4dba7a2)·C4-3 자동화 19(55f46a9)·C4-4 UI·레이아웃 22(2a88873)·C4-2 Lightning 5(97c08c4)·C4-7 운영/패키징 2노트 38(5ae267a)·C4-8 User·플랫폼이벤트 7(6bd258a). **C4-9 롱테일 5노트**(scout 실측 104객체→3계획을 5분할): 9a-1 Embedded Service 13(f139f68)·9a-2 Service·OmniChannel 25(c0ce875)·9b 세일즈·예측·AI 25/240필드(f14a5ab)·9c-1 Experience·콘텐츠·커머스 14/150(85cbcac)·9c-2 통합·데이터·결제·마케팅 22+복합3(a61acee). 전 사이클 completeness 갭0·source-verifier 불일치0·qa PASS. ★ DELEGATE(기존 노트 링크): 배포 패밀리 6→`DevOps/Tooling API 배포.md`(RECON-11 기작성)·디버그 6→`Apex/Logging/Tooling API 디버그·로그·리플레이 sObject.md`·FSL변형(CleanRule·TimeSheetTemplate)→FieldService 노트. ★ 복합타입 3(QueryResult·SOQLResult·CompactLayoutItemInfo) 9c-2 부록+본체 노트 facet 분리. 메모리 [[project_tooling_api_ingest]] | ✅ 완료(2026-06-30) — 17노트 갭0·불일치0·깨진링크0·네비 3자 정합. ★교훈: (1) running-header artifact—객체경계는 "Represents…"줄·필드설명·알파벳순으로 판정(C4-9b EngagementInsightType 12→15 복원, 검증 2개 교차확정) (2) 계획 객체수는 신호일 뿐 scout 실측 우선(전 사이클 양방향 빗나감) (3) 매 사이클 위키 전체 grep-제외(서브폴더 한정시 흩어진 위임노트 누락→중복; 9a-1 착수시 배포노트 중복 생성·롤백 실증) (4) dump 합산수치 신뢰말고 객체별 실측(9b 244→240) (5) 대형 Language picklist 2종은 값집합 다르면 합치지 말고 collapsible 전수 |
| ING-23 | `salesforce_mobile_push_notifications_implementation.pdf` (= **Salesforce Mobile Notifications Implementation Guide**, Summer '26, Tier 2, 57p) | 신규 `Apex/Messaging(메시징)/Mobile Notifications.md`(614줄). 2 서버측 시스템(**Notification Builder** UI/invocable·조회 vs **Apex** 레거시 push-only) 비교표·`Messaging.PushNotification`(생성자 2·메서드 send/setPayload/setTtl)·`PushNotificationPayload.apple()`(4-param·8-param 오버로드 전수)·Connect REST `/connect/notifications/push`·**customNotificationAction**(invocable REST, 입력 8필드·recipientIds 5종·curl GET/POST·JSON)·Notifications Resources(Notification/Status/App Setting(s)/Setting(s)/CustomNotificationType)·Apex Limits 함수 2(`getLimitMobilePushApexCalls`/`getMobilePushApexCalls`)·Debug Log 6종. ★ **동명이의 구분**: `customNotificationAction`(invocable REST) ≠ `Messaging.CustomNotification`(Apex 클래스) — 차이표. ★ 한도 위임: push 시간당 한도(iOS 20,000/Android 10,000)는 `[[Governor Limits]]` 기존 보유 → 재작성 0. nav: `_index/apex-core.md`·Apex MOC 메시징·Messaging index. cross-linker: Messaging Namespace의 PushNotification/Payload 행→상세 본거지 역링크·CustomNotification peer | ✅ 완료(2026-06-20) — source-verifier 불일치0(8-param 오버로드·curl 헤더 중복 원문 보존)·completeness 갭0(Notifications Resources 7리소스 셀단위)·qa PASS. Tier 3 0 |
| ING-19 | `service_presence_developer_guide.pdf` (= **Omni-Channel Developer Guide**, v67.0 Summer '26, Tier 2, 23p) — ★ 파일명 함정(service_presence ≠ 실제 Omni-Channel 전체 가이드). **위키 첫 `Service(서비스)/OmniChannel(옴니채널)/` 폴더** | ★ **Standard Omni-Channel EOL Summer '26** — 두 노트 상단 `[!warning]` 은퇴 배너(Enhanced Omni-Channel 마이그레이션, 단 전용노트 부재라 링크 없이 텍스트). **2노트 분할**(참조형 vs 구현형, depth 10배 차): ① `Omni-Channel 객체·메타데이터·콘솔 컴포넌트`(215줄 — API 객체 24·Metadata 타입 11·Lightning Console JS API 메서드 12+이벤트 10·Classic Console Integration Toolkit 메서드 10·표 4개[Standard/Omni Console Events·channel object·Methods]) ② `Omni-Channel External Routing`(499줄 — Technical Architecture 5단계·CDC 객체 추가[PSR/AgentWork/USP·IsPushed/IsCurrentState/Status 모니터링 규칙]·**Pub/Sub XML 4개·Apex trigger 3개**·AgentWork 생성 Apex·PreferredUserId·**Expected Behavior 5시나리오**·Troubleshooting). ★ 중복 회피: 객체/메서드는 이름만(PDF 스키마 미정의→fabricate 0), 필드는 `[[Service Cloud Objects]]`·일반 콘솔은 `[[Lightning Console JS API]]`(ING-24, Omni 메서드는 신규) deep-link. ★ 원문 불일치 각주 2건: 채널명 `ExternalRoutingChannel__chn`(밑줄2) vs setting `_chn`(밑줄1)·본문 `AgentWorkPresenceChangeEvent` vs 코드 `AgentWorkChangeEvent`(코드가 정확). 다이어그램(p.8) 추출불가→추측 금지. nav: 신규 OmniChannel index·`_index/service.md` Omni-Channel 서브헤딩·Service 허브·questions·Home. cross-linker: 형제 양방향·Lightning Console JS API/Service Cloud Objects 역링크. **잔여: `_administrators` 124p admin 가이드(ING-30)** | ✅ dev guide 완료(2026-06-20) — source-verifier 불일치0(Pub/Sub XML 4·Apex trigger 3 byte-identical)·completeness 갭0·qa PASS. Tier 3 0 |
| ING-21 | `salesforce_guided_engagement.pdf` (= **Lightning Flow for Service Developer Guide**, Spring '26, Tier 2, 40p) — ★ 파일명 `guided_engagement`는 레거시명 | 신규 `Service(서비스)/Lightning Flow for Service (Actions & Recommendations).md`(451줄). 핵심 = **Actions & Recommendations 컴포넌트** + **RecordAction junction 객체**. 8챕터 전수: 개요·지원객체 3분류·RecordAction(필드·Sharing)·deployment(`RecordActionDeployment`)·**Enhance 7옵션**(추천/재개/Pin/Mandatory/HideRemove/FindAnother/History[`RecordActionHistory` big object])·액션 연결 4경로(Deployment·**Process Builder 필드표 7행**·SOAP·**Apex 예제 VERBATIM**)·페이지 커스터마이즈·Chat/Open CTI 통합·Considerations·**권한표 5종(A~E, BLANK 셀 보존)**. ★ **fabricate 가드**: 백로그 가정 용어 `deploymentChannel`·Guided Action List·Flow Orchestration·embeddedService는 PDF 부재→본문 0건. RecordAction 필드 관찰분만(전체 스키마는 Object Reference 위임). ★ deep-link 多(고유 콘텐츠=컴포넌트+deployment+RecordAction만): Flow·NBA·Open CTI·Big object·Packaging 8 위임. nav: `_index/service.md`·Service index·Home. | ✅ 완료(2026-06-20) — source-verifier 불일치0(Apex byte-level·권한표 BLANK)·completeness 갭0(Enhance 7·권한표 5)·qa PASS. Tier 3 0 |
| ING-33 | `order_management_developer_guide_html.pdf` (Salesforce Order Management Developer Guide, v66.0 Spring '26, Tier 2, 69p) — **위키 첫 Commerce 도메인**. 신규 `Commerce(커머스)/` 폴더 | **4노트 분할**(69p 중형, B2C Commerce Order Data Map이 p.5-38 33p 거대 매핑표라 전용 패스): ① `Order Management 개요와 데이터 모델`(138줄, 허브 — Developer Resources 카탈로그[Connect Apex 8·Platform Events 7·Commerce Payment 8객체]·Entity Relationships[다이어그램 추출불가→추측 금지]) ② `B2C Commerce Storefront Order Data Map`(671줄 — Integration Notes·Payment Gateway 설정·Create Custom Payment Methods·**21객체 매핑표 225행** 3컬럼 XSD→SF필드) ③ `Order Management — Import·Fulfillment·Taxation`(362줄 — 레코드 생성순서 14단계·Required Fields 12객체·OrderSummary 생성 비교·High-Scale dedup 8·Fulfillment·Location Capacity 4동작·Tax net/gross·Price Adjustments 예제) ④ `Order Management — Exchanges·Payment Sequencing·확장`(618줄 — Exchanges RMA Preview/Submit Cart API·**Payment Sequencing Apex 예제 2종**·Lightning Components·Order on Behalf Of·**ProductExpandService 확장**[commerce_ordermanagement, override/super/external·sfdx CLI]·API End-of-Life). ★ 처리 노하우: 3 researcher 병렬 추출(데이터맵/운영/API)·4 writer 병렬. ★ 중복 회피: ConnectApi/CommercePayments 네임스페이스 메서드 재작성 0(deep-link). ★ 다이어그램 PDF 스트림 손상(`Missing endstream`)으로 pdftoppm 렌더 실패→fabricate 금지 정직 처리. ★ 원문 오타 다수 보존+마커(regex `*` 누락·`giftcertifcate`·`orderremoteHost`·`catalog-ID` 대소문자·JSON 콤마누락·`Aray`/`opitona)l`/`ar[yA`·`response` 외부선언). ★ **병렬 작성 부작용**: 형제 노트 동시생성으로 상호 `[[ ]]` 링크가 lint 차단→plain-text 폴백→cross-linker가 사후 복원. nav: 신규 `Commerce(커머스)/index.md`·`_index/apex-namespaces.md` "Order Management — B2C Commerce" 4행(신규 commerce 샤드 미생성, Commerce 네임스페이스 응집)·questions 3행·Home Commerce 섹션·CLAUDE.md 폴더표 1행. cross-linker: 형제 링크 복원 + CommercePayments→노트1·CommerceExtension→노트4 역링크 | ✅ 완료(2026-06-20) — 8검증(4 completeness 갭0 + 4 source-verifier 불일치0·**21객체 transpose0**·Apex 코드 문자단위·Price Adjustments 9수치·카탈로그 50항목)·qa PASS. Tier 3 0. 경미: 노트4 setter 반환타입 `void`는 원문 미명시 추론(본문 statement 호출로 확인, fabricate 아님). ★ 교훈: 페이지 수만으로 "소형" 추정 금지 — ToC 실측해야 데이터맵 밀도 파악(초기 소형 배치서 중형 재분류) |
| ING-34 | `scoping_rules_dev_guide.pdf` (Scoping Rules Developer Guide, v66.0 Spring '26, Tier 2, 31p) — record visibility 좁히기 기능 | 신규 `Architecture(아키텍처)/Scoping Rules.md`(694줄). ★ **핵심 정정:** 별도 `ScopingRule`/`ScopingRuleService` API 타입 **없음** — Scoping Rule과 Restriction Rule이 **동일 `RestrictionRule`**(Tooling object + Metadata type)을 공유하고 `enforcementType` enum(Scoping/Restrict/FieldRestrict)으로만 구분. Restriction Rule 전용 노트 부재라 이 노트가 RestrictionRule API 레퍼런스(Tooling 12필드·Metadata 8필드·SOAP 7콜·REST 6메서드) **첫 본거지**. 내용: 개념(지원객체 Scoping 7표준+custom·접근권한 불변·List View/Report/SOQL 적용)·**Scoping≠Restriction≠Sharing 구분표**·recordFilter 문법(EQUALS 전용·SOQL Operator USING SCOPE EVERYTHING·미지원객체 8·데이터타입 9·Owner:User·dot 1-level·다중값)·생성 Tooling/Metadata API 코드 전수·Branch/Wealth Management 예제·Example Scenarios 4종·Considerations 5그룹. 폴더 판단: `Security(보안)/`은 Secure Coding 전용이라 record-access는 `Architecture(아키텍처)/`(형제 레코드 액세스 설계·Permission Set 설계와 일관). nav: `_index/platform.md`·Architecture MOC·index·questions. cross-linker: Metadata Types 카탈로그→본거지 역링크·레코드 액세스 설계·Permission Set 설계 peer. SOQL callout 그림→3요소 표 재현(마커). PDF 원문 오타 7건 보존+마커(`of of Advisor1`·URI `66.0` v누락·masterLabel 불일치·곡선따옴표 닫힘 누락·package.xml `55.0` 등) | ✅ 완료(2026-06-20) — completeness 갭0(Considerations 5그룹·RestrictionRule 12/8필드 전수)·source-verifier 불일치0(ScopingRule fabricate 0·필드/enum 철자 전수)·qa PASS. Tier 3 0 |
| ING-29 | `salesforce_app_limits_cheatsheet.pdf` (Salesforce Developer Limits and Allocations Quick Reference, Last updated May 8 2026, Tier 2, 23p) — org/플랫폼 레벨 정적 할당량. ARCHIVE N1-02 거짓 완료 정정(2026-06-16 되살림) 후 실제 위키화 | 신규 `Architecture(아키텍처)/Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF).md`(284줄). ★ **백로그 가정 정정:** PDF엔 Storage/Email/Custom Object/Sandbox 한도 **없음**(Salesforce "Features and Edition Allocations" 별도 문서 소관 — fabricate 0, 범위 밖 명시). 실제 = ②API 요청(동시 5/25·타임아웃·**총 할당량 edition표 라이선스 13종 전수**·모니터링·요청크기 16,384bytes)·③Connect REST·④Bulk API/2.0(General/Ingest/Query 3표 2열·비수치 셀 N/A·"Same as Bulk API" 보존)·⑤Query Cursor(v56.0)·⑥SOAP 7콜·⑦Metadata(10,000파일·39MB/50MB·600MB)·⑧SOQL/SOSL(relationship 55/20/5 levels 등)·⑨Visualforce 20행. **①Apex Governor 섹션→`[[Governor Limits]]` 위임(재작성 0)·⑩Platform Event→위임.** 폴더: `Architecture(아키텍처)/`(플랫폼 레퍼런스, 제목에 "Governor" 미사용으로 Governor Limits.md와 구별). nav: `_index/platform.md`·Architecture MOC·index·questions. cross-linker: Governor Limits·Bulk API 2.0·REST API·Metadata API 개요·SOQL 문법 레퍼런스 역링크 5건. ★ 후속(별건 LINT): 기존 `Governor Limits.md`에 `DailyAsyncApexElasticExecutions`(beta) 1행 누락 발견→보강 권고. cross-linker가 `Metadata API 개요.md`(코드블록 0 결함→기존 명령 인코딩)·`SOQL 문법 레퍼런스.md`(1행 BOM) 기존 결함 발견 | ✅ 완료(2026-06-20) — completeness 갭0(②~⑨ 전 셀)·source-verifier 불일치0(**edition표 transpose0**·Bulk 2열·VF 20행 전수)·qa PASS. Tier 3 0 |
| ING-15 | `caf_dev.pdf` (Custom Address Fields Developer Guide, v66.0 Spring '26, Tier 2) — ★ 파일명 약어 `caf`가 백로그에서 "Case Feed"로 오분류됐던 함정. PDF 내용 검증으로 정정 | 신규 `sObject/Custom Address Fields.md`(791줄). 10챕터 전수: 개념·9 custom field 소비·요건/제한 3그룹·State/Country picklist·활성화·geocode 수동 추가·CRUD 5-API(Apex/Metadata/REST/SOAP/Tooling). 교차링크: `Compound Fields`(양방향)·`Field Types`·Future 메서드·`REST API`(단방향). 수정: `Compound Fields`(§Custom Address Fields 역링크)·`_index/sobject-reference.md`(키워드 재지정+신규 행)·`sObject/index.md`(2행). ★ 처리 노하우: Ch6~Ch10이 동일 기능을 5개 API로 반복 시연 — 깊이 부족이 아니라 **중복이 위험인 PDF 유형**. 비교표 + API별 셀 단위 고유 표기(`fieldsToNull` 등) 보존으로 처리. 원문 오타 8건(v54.0·dataa66.0 등) 코드 교정 금지 원칙으로 보존 | ✅ 완료(2026-06-18) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): aliases에 자연어 7표현 보강(주소 필드를 코드로 만들기·커스텀 compound 필드 REST로 생성 등) |
| ING-31 | `secure_coding.pdf` (Secure Coding Guide, v67.0 Summer '26, Tier 2, 97p/15챕터) — Salesforce 위협모델 가이드. 첫 **최상위 `Security(보안)/` 폴더** 신설 | 신규 `Security(보안)/` 폴더 + 위협모델 **12노트**: `Secure Coding 개요`(Ch1+2, ~130줄)·`XSS 방어`(Ch4, ~520줄)·`SOQL Injection 위협`(Ch5, ~240줄)·`CSRF 방어`(Ch6, ~110줄)·`Secure Communications (TLS)`(Ch7, ~115줄)·`민감 데이터 저장`(Ch8, ~165줄)·`Arbitrary Redirect 방어`(Ch9, ~85줄)·`권한과 접근 제어 위협`(Ch10, ~230줄)·`Lightning Security 모델`(Ch11, ~340줄)·`세션 ID와 브라우저 통신 위협`(Ch3+13+14, ~200줄)·`Marketing Cloud API 보안`(Ch12, ~90줄)·`Platform Security FAQ`(Ch15, ~165줄). nav: `Security(보안)/index.md`·신규 샤드 `_index/security.md`(79줄, 11도메인 그룹)·라우터 1줄·Home 보안 섹션(index-manager). 교차링크: 17개 기존 노트 역링크. ★ 중복 회피: 기존 메커니즘 노트(`escapeSingleQuotes`·`AccessLevel`·`stripInaccessible`·`with/without sharing`·`Lightning Web Security`)로 deep-link 재사용 — **위협모델(왜 위험한가) vs 메커니즘 레퍼런스(API 시그니처)** 관점 분리, 재문서화 0. ★ 처리 노하우: scout가 ToC 인쇄번호 vs PDF 물리페이지 **+4 오프셋** 발견(표지/목차 4p) → 추출 페이지 전수 +4 보정. 다단 표 3곳(XSS 인코딩 함수표·CRUD/FLS 매트릭스·HTTP 헤더표) pdftoppm 이미지 검증으로 collapse 방지 | ✅ 완료(2026-06-18) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): 8개 위협 노트 aliases에 시나리오 자연어 표현 보강(내 VF 페이지 XSS 막으려면·guest user 권한 누수·open redirect 피싱·동적 SOQL에 사용자 입력·API 키 어디 저장 등). 차기 ING-43 등록(exp_cloud_lwr LWS 챕터→LWS vs Locker 전용 노트) |
| ING-36 | `chat_dev_guide.pdf` (Service Cloud Chat Developer Guide, v67.0 Summer '26, Tier 2, 61p) — 레거시 Chat(Live Agent) **에이전트/구현 가이드**. **2026-02-14 은퇴** 제품. ING-13a(chat_rest, 방문자측 REST)의 **형제 후속·보완 관계**(중복 아님). resumed 작업(이전 세션 Ch1-5 작성 → 이번 세션 Ch6-8 작성·전체 검증) | 신규 노트 1개 **`커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅`(417줄, Ch6-8)**: 13개 `liveAgent:*` VF 컴포넌트 전수 + "Using clientChatQueuePosition" 3조건·커스텀 chat window VF 코드샘플(waiting/engaged/ended 3-state + CSS)·post-chat 변수 19종 + `disconnectedBy` 5값 enum + 세션 타임아웃 Note·post-chat VF 코드샘플(abandoned 분기 JS)·Deployment API 메서드 4종(베이스 시그니처는 형제 노트로 DEDUP 교차링크)·`agentId_buttonId` 언더스코어 구문·direct-to-agent VF 코드샘플·Fallback Routing(부분 발췌 + char-exact `domainMatcher` 정규식 전체 코드샘플)·Quick Text 링크 패턴. 은퇴 [!warning] 배너. 기존 3노트(Ch1-5, 이전 세션·이번 세션 완결성 검증): `Chat 개발자 가이드 개요 & Deployment API`(Ch1 About/Ch2 Prereq/Ch3 API Versions)·`Deployment API — 레코드 자동 검색·생성·자동 채팅 초대`(Ch4 Deployment API)·`Pre-Chat API — 방문자 정보 수집`(Ch5 Pre-Chat). nav: `_index/service.md` 신규 "Chat — Developer Guide" 서브헤딩 4행·Chat `index.md`(현재 11노트)·Service 허브·`questions.md` 6행(index-manager). 교차링크: REST 백링크 2건(REST 개요→dev-guide 진입, REST 방문자경험 리소스→신규 노트, cross-linker). ★ DEDUP 회피: 방문자측은 ING-13a REST 노트로 교차링크, 베이스 Deployment API 시그니처는 형제 노트로 교차링크, Quick Text는 설명만(미링크) | ✅ 완료(2026-06-18) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. ★ 처리 노하우: (1) **+4 페이지 오프셋**(front matter, AP-05 절차 적용). (2) **char-exact `domainMatcher` 정규식**(비대칭 백슬래시 이스케이프) pdftoppm 이미지 검증으로 보존, 정규화 금지. (3) **원문 오타/ID 불일치 보존[sic]** — 설명문 ID(`005xx...`/`573xx...`) vs 코드 ID(`005D...`/`573D...`) 불일치, `liveagent.prechat.name`(점) vs `:Email`(콜론), `<liveagent:clientChatInput>` 소문자 표기 모두 원문 그대로. (4) Ch6 코드샘플의 "uses" 목록 vs 실제 코드 body 불일치(`clientChatCancelButton` 등 일부 차이) — 원문 그대로 보존. (5) **resumed-pipeline 단일-노트 제약**: 이미 작성된 3노트의 forward-link가 Ch6-8을 단일 노트로 가리키고 있어 1-vs-2노트 분할 자유도가 사전 링크에 의해 제약됨 → resumed 작업에선 기존 forward-link를 먼저 점검해 분할 결정. retrospective(모드 A): 신규 노트 aliases에 시나리오 자연어 보강(VF로 채팅창 커스터마이즈·채팅 끝나고 설문으로 보내기/post-chat 리다이렉트·상담원 직접 채팅 링크 / chat with me 링크·에이전트 오프라인이면 다른 큐로 폴백·abandoned 채팅 처리·Quick Text로 채팅 링크 배포 등) + tags에 PostChat·QuickText 추가. 후속 **ING-44**(Embedded Service SDK·Messaging for In-App and Web 마이그레이션, PDF 입수 게이트) 전용 행으로 승격 |
| ING-13a | `chat_rest.pdf` (Chat REST API Developer Guide, v66.0 Spring '26, Tier 2, 66p) — 레거시 Chat(Live Agent) **방문자측 REST API**. **2026-02-14 은퇴** 제품. 신규 **`Service(서비스)/Chat(채팅)/` 폴더** 신설 | 신규 **7노트(~1,797줄)**: `Chat REST API 개요 & 시작`(~174줄)·`메시지 롱폴링 & 대기시간`(~112)·`리소스 — 세션 생성 & 방문자 세션`(~176)·`리소스 — 채팅 모니터링 & Messages 응답 객체`(~253)·`리소스 — 방문자 경험 커스터마이즈`(~161)·`요청 & 응답 바디`(~729)·`데이터 타입 & 상태 코드`(~192). 7노트 전부 **은퇴 [!warning] 배너**. nav: 신규 `Service(서비스)/Chat(채팅)/index.md`·Service 허브 갱신·`_index/service.md` 샤드 행 추가. 교차링크: `sObject/Service Cloud Objects.md`. ★ 처리 노하우: (1) **TOC가 Ch6 "Messages Response Objects" 14개 하위 리소스를 누락** — scout가 PDF 색인으로 캐치, completeness-validator가 14개 전수 확인 → "최상위 TOC만 신뢰 말고 리소스 하위 중첩 항목 검증" 교훈. (2) **+4 페이지 오프셋**(front matter) scout 실측(AP-05 절차 적용). (3) pdftotext property 표 collapse → Ch6~Ch10 `-layout` 필수. (4) SwitchServer(Ch8 응답 바디)는 heading↔properties 사이 주석 라인이라 누락 쉬움 — coverage-checker 사전 플래그, validator 확인 | ✅ 완료(2026-06-18) — completeness 전수 ✅(Ch6 14객체 포함)·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. retrospective(모드 A): 개요·세션 노트 aliases에 `Live Agent REST API`·`Chasitor/채시터`·은퇴/마이그레이션 자연어(`Chat 은퇴`·`Live Agent 마이그레이션`·`Messaging for In-App and Web 마이그레이션`) 보강. 개요 노트의 broken `[[Messaging for In-App and Web]]`·`[[Embedded Service SDK]]` 3건을 plain-text 미작성 마커로 정정(L1 lint 통과). index-manager 권고: service 샤드에 `Live Agent`·`Chasitor`·은퇴/마이그레이션 키워드 행. 형제 후속 ING-36(chat_dev_guide) P1 식별 |
| ING-40 | `api_meta.pdf` (Metadata API Developer Guide, v67.0 Summer '26, Tier 2) — **CustomAddressFieldSettings 메타데이터 타입 상세**. ING-15 후속(source-coverage-checker 2026-06-18 발견, caf_dev 단일 scope 밖). `enableCustomAddressField`(활성화 후 **비활성화 불가**)·샘플 XML·v55.0+ | **in-place 보강**(신규 노트 아님) — 기존 `sObject/Custom Address Fields.md`(ING-15 산출) §활성화에 CustomAddressFieldSettings delta 보강: `CustomAddressFieldSettings` 샘플 XML·`enableCustomAddressField` 비활성화 불가 caveat·`package.xml` v55.0 예시. nav: `_index/sobject-reference.md` 기존 Custom Address Fields 행에 `enableCustomAddressField 비활성화 불가`·`package.xml v55.0`·`커스텀 주소 필드 활성화` 키워드 보강(중복 행 없음, 기존 행 보강). | ✅ 완료(2026-06-19) — completeness 전수 ✅·source-verifier 셀단위 ✅·qa ✅. Tier 3 노트 0. api_meta 후속 묶음(RECON-2·ING-40·42) 동시 closure(RECON-3 ④) |
| ING-42 | `api_meta.pdf` (Metadata API Developer Guide, v67.0 Summer '26, Tier 2) — **AddressSettings + State/Country Picklist 설정**. ING-15 후속(coverage-checker 2026-06-18 발견). State and Country/Territory Picklist 활성화·설정. CAF의 picklist 의존성과 연결 | 신규 `Admin(어드민)/State and Country Picklist.md` — `AddressSettings` 메타데이터 타입: 하위타입 3·필드 15 전수, `CountriesAndStates`/Country/State, isoCode·integrationValue, `Address.settings`(settings 폴더 단일 파일), Metadata API 편집 가능·신규 생성/삭제 불가. CAF picklist 의존성 교차링크. nav: `_index/platform.md` Admin 섹션 신규 키워드 행(AddressSettings·State and Country Picklist·`Settings:Address`·isoCode integrationValue + 국가/주 피클리스트·주소 설정 + 자연어 질문)·`Admin(어드민)/index.md` 파일목록+빠른선택 행. | ✅ 완료(2026-06-19) — completeness 전수 ✅(하위타입 3·필드 15)·source-verifier ✅·qa ✅. Tier 3 노트 0. api_meta 후속 묶음(RECON-2·ING-40·42) 동시 closure(RECON-3 ④) |
| ING-39 | `salesforce_pages_developers_guide.pdf` (Visualforce Developer Guide, v67.0 Summer '26, 819p, Tier 2) — 퍼블리셔·Case Feed VF 컴포넌트 5종 **속성 완전 명세** 추출. ING-14 후속(source-coverage-checker 2026-06-18 발견). ★ 백로그 기재 페이지(ToC p.470/520/670/672/674)는 인쇄 페이지 — scout AP-05 실측으로 **물리 페이지 오프셋 +14** 환산(물리 484-486·534-535·684-686·688-689). | **in-place 보강**(신규 노트 아님) — 기존 `Aura(오라)/Case Feed Visualforce 커스터마이즈.md`(ING-14 산출)의 5개 속성표를 VF Dev Guide 정본으로 보강·교정. 신규 attribute **3행 추가**(`verticalResize` 30.0/emailPublisher·`categoryMappingEnabled` 25.0·`insertLinkToEmail` 25.0/caseArticles). 셀 교정: id·rendered **API Version 14.0**(기존 25.0/26.0)·**Access global**(소문자, 기존 대문자 Global)·Description 정본 문구(action→publisher 등). 5개 표 직전 출처 명시 인용블록·frontmatter source 2소스 병기·CaseFeed 표기 안내. 정본 행수 29/15/23/3/15. ★ 중복 회피: ING-14가 이미 속성표를 가지고 있어 전면 재작성이 아닌 **누락 행 보강 + 셀 교정**으로 처리. 산문·use case·코드샘플·chatter:feed 표는 미변경(보강이 표에만 국한). | ✅ 완료(2026-06-19) — completeness 전수 ✅(갭 0)·source-verifier 셀단위 ✅(90행×6셀 불일치 0)·qa ✅(counting 불일치는 헤더/구분선 카운팅 차이로 확정, 콘텐츠 정확). Tier 3 노트 0. ★ 처리 노하우: (1) **두 Tier-2 공식 소스 충돌** — 사용가이드(Publisher Dev Guide)와 레퍼런스가이드(VF Standard Component Reference)가 같은 attribute를 다른 API Version·Access 대소문자·용어로 기술 → 컴포넌트 스펙 정본은 **레퍼런스 가이드** 채택, 사용가이드는 산문/예제 출처로 종속. source-verifier.md에 규칙 반영. (2) **예제 맥락으로만 다룬 컴포넌트는 attribute 누락 가능** → source-coverage-checker.md 체크리스트에 반영. index-manager: `_index/frontend.md` 행에 신규 attribute 3개+`VF 컴포넌트 속성표` 키워드 보강. retrospective(모드 A): 후속 없음(차기 ING-27/ING-37 동일 PDF 전체 817p 분할은 별건 유지). |
| ING-43 | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, **v66.0 Spring '26**, 106p, Tier 2) — **Lightning Web Security(LWS) 전용 노트**. ING-31(Secure Coding) 후속(source-coverage-checker 2026-06-18 발견, secure_coding 단일 scope 밖). 위키에 LWS 격리 모델이 전무했음 | exp_cloud_lwr Ch2 "Lightning Web Security in LWR Sites"(전체추출 라인 429-451) + "LWS Limitations"(663-670) + Ch6 Privileged Script Tag `<x-oasis-script>`(3540-3733). secure_coding Ch11은 LWS 0건·Locker deep-link만 | 신규 `Security(보안)/Lightning Web Security (LWS).md` — LWS=Locker 대체·namespace별 sandbox로 document/window/element를 secure wrapper 없이 직접 노출·cross-namespace communication(composition/extension import)·third-party(analytics/charting) 용이·LWR 자체 LWS 인스턴스(org-level Session Settings 무효, Experience Builder site-level 제어)·미지원 속성 4종(document.domain·document.location·window.location·window.top)·Privileged Script Tag(별도 H2, shadow DOM 우회·GA/GTM 예제·imported/exported-global-names·hidden·Relaxed CSP). Locker 대비 대조표(함의 셀 라벨링). nav: `_index/security.md` Lightning 보안 섹션 1행·`_index/questions.md` 2행(공식 예외)·`Security(보안)/index.md`. cross-linker: peer 역링크 4건(Lightning Security 모델·LWC Shadow DOM 모드·LWR Sites·공유 JS 모듈) | ✅ 완료(2026-06-20) — completeness 갭 0·**fabricate 0**·source-verifier 불일치 0·qa PASS. Tier 3 노트 0. ★ **제목 정정**: 백로그 권고 "LWS vs Lightning Locker"는 과약속(소스가 Locker 직접 서술 0, 대비 함의뿐) → "Lightning Web Security (LWS)" + 본문 "Locker 대비" 섹션. ★ **백로그 전제 오류 정정**: 보강 대상 `Lightning Web Security` 노트 부재였고 `Lightning Security 모델` L20 deep-link가 LWS 없는 `LWC 보안 패턴`을 가리키던 **깨진 약속** → cross-linker가 신규 노트로 재지정. ★ **소스 제약 정직 처리**: distortion 메커니즘·secure wrapper 내부동작·정식 비교표는 코퍼스 부재(정식 "Security for Lightning Components" 가이드 미보유) → fabricate 금지·"소스 범위" 섹션에서 외부 LWC Dev Guide deep-link. ★ 버전: 본문 텍스트 v66.0 Spring '26 확정("Summer '26"은 표지 그래픽뿐, MEMORY 버전확인 규칙 적용) |
| ING-45 | `api_tooling.pdf` (Tooling API Reference and Developer Guide v67.0 Summer '26, 1006p, Tier 2) — **Tooling API 디버그/로그/리플레이 sObject 묶음**. RECON-4(Apex Debug Log) 후속·RECON-11(Tooling API 배포) line 16 예약 작업. UI/선언적 로그 제어만 있던 위키에 **프로그래밍 방식(SOAP/REST) 로그·리플레이 제어** 신규 | ★ 오프셋 비단조(+10~+11) — 물리 p.123-131(Overlay/ApexLog)·302-308(DebugLevel)·546-548(HeapDump)·922-928(TraceFlag)·14-20(executeAnonymous REST). 다단표/이미지 없음(수직 stacked 필드표) | 신규 `Apex/Logging(로깅)/Tooling API 디버그·로그·리플레이 sObject.md`(~320줄) — 7객체+복합타입 100% 전수: **TraceFlag**(14필드·LogType 4값[CLASS_TRACING/DEVELOPER_LOG/PROFILING/USER_DEBUG]·ExpirationDate 24h·ScopeId deprecated v34-·DebugLevelId→DebugLevel)·**DebugLevel**(11필드·카테고리 8종×picklist 8값[NONE~FINEST] 매트릭스·Language 18값·삭제 시 trace flag 연쇄삭제)·**ApexLog**(9필드·Location[Monitoring 7일/SystemLog 24h]·Request enum·raw 로그 `/sobjects/ApexLog/id/Body/`)·**ApexExecutionOverlayAction**(9필드·ActionScriptType 3값·SOAP 7콜/REST 5메서드)·**ApexExecutionOverlayResult**(11필드·ApexResult/SOQLResult/HeapDump 복합타입 참조)·**HeapDump**(complex type 최상위 4 + TypeExtent 6하위)·**executeAnonymous REST**(`/executeAnonymous/?anonymousBody=` GET v29.0+·managed package 차단·예제) + **ExecuteAnonymousResult**(7필드). 기능 3그룹 H2(로그 활성화/리플레이 디버거/executeAnonymous) + 상단 객체 관계도 ASCII. nav: `_index/apex-core.md` 1행·`_index/questions.md` 2행(공식 예외)·`Apex MOC` 📋 로깅·`Apex/Logging(로깅)/index.md`. cross-linker: peer 역링크 4건(Apex Debug Log·Anonymous Apex 실행·Tooling API 배포·DX 데이터 작업) + Tooling API 배포 line 16 ING-45 예약 주석→실링크 갱신 | ✅ 완료(2026-06-20) — completeness 갭 0(7객체+복합타입 100%·fabricate 없음)·source-verifier 불일치 0(필드·Properties·enum·Language 18값·코드 셀단위 일치·AP-09 절단 없음)·qa PASS. Tier 3 노트 0. ★ **scout 맵 오류 3건 researcher 정정**(silent gap 차단): (a) ApexLog Special Access Rules는 직후 ApexOrgWideCoverage 것 — 오귀속 배제, (b) TraceFlag SAR은 직전 TimeSheetTemplateAssignment 것 — 배제, (c) HeapDump 중첩타입 AttributeDefinition/HeapAddress/TypeExtent 독립정의 **PDF 없음** — fabricate 금지·"PDF 미정의" 명시. 대형 PDF에서 인접 sObject 섹션이 머리에 붙어 보이는 착시를 인접 헤딩 확인으로 차단. ★ RECON-11 line 16 예약 충족·해소 |
| ING-07 | `salesforce_recipes_api.pdf` (실제 제목 **Data Prep Recipe REST API Developer Guide**, Summer '26, 표면 180p지만 16,953줄 초밀도, Tier 2) — CRM Analytics/Data 360 레시피 REST API **전수 위키화**(사용자가 "전수" 스코프 명시). 파일명≠제목(recipes_api→Data Prep Recipe REST API). | scout AP-06 ToC(라인 11–327)+본문+색인 교차검증: Input 144·Response 137·Enum 47 표현형 전수 인벤토리. 5열 Properties 표가 pdftotext 세로 stack + 페이지경계 column-collapse(running-header가 표 소유자 오인 유발) → researcher가 거의 전 표를 pdftoppm 이미지로 셀 검증. | **신규 최상위 폴더 `Analytics(애널리틱스)` + 10노트**(10 researcher·10 writer·검증 병렬): 개요·인증·엔드포인트(허브: 엔드포인트 6·Examples 워크플로·OAuth·EOL)·Bucket/Cluster Input(26)·Aggregate/Append/Join/Compute/Pivot Input(20)·Formula/Format/Typecast/Update Input(23)·Filter/Flatten/Extract/Schema Input(23)·Load/Save/Output/ML Input(38)·Recipe 구성 Input(11)·Response (Bucket~Output)(86)·Response (Recipe~Update)(50)·Enums(47). Type명은 code(280 표현형 wikilink 노이즈 회피), 노트간 링크는 관련노트 레벨. nav: 신규 샤드 `_index/analytics.md`+`Analytics(애널리틱스)/index.md`+라우터+Home(후속 ING-08 Dashboards REST API 수용). cross-linker: "(미작성)" 잔재0·허브↔9spoke·Input↔Response·Wave Namespace 역링크. | ✅ 완료(2026-06-21) — completeness(writer dump 대조)·source-verifier 4노트(N1·N6·N8a·N8b) 집중·qa PASS. Tier 3 노트 0. ★ **교훈(column-collapse)**: pdftotext가 페이지경계에서 4·5열 값을 다음 페이지로 흘려보내 writer가 `runMode`/`fieldMappings`를 "원문 미표기"로 오판하고 nodes에 없던 "(v57.0 추가)" fabricate → source-verifier `pdftotext -layout` 재추출로 셀 복원·정정. **layout 재추출이 collapse 최종 방어선.** ★ 교훈(스코프 게이트): 표면 페이지수(180p)로 "중형" 추정 금지 — 실측 16,953줄·280표현형 대형 카탈로그. 전수 vs 고가치서브셋 스코프를 사용자에게 확인(사용자 전수 선택). ★ 교훈(파일명≠제목 반복): recipes_api=Data Prep Recipe REST API, analytics_rest=Dashboards REST API. ★ index↔콘텐츠 정합: N6 카운트 37→38 정정이 본문엔 반영됐으나 index.md 누락 → qa가 적발·수정. |
| ING-22 | `cpq_developer_guide.pdf` (**Salesforce CPQ Developer Guide**, v65.0 Winter '26, 108p, Tier 2) — managed-package CPQ(SBQQ) API·플러그인 레퍼런스. 위키 전무한 신규 도메인. ⚠️ RLM/Revenue Cloud(`PlaceQuote`·`RevSalesTrxn` 네임스페이스)와 **별개 제품**. | scout AP-06 ToC+본문+색인 교차검증으로 ToC 누락 Page Security Plugin(본문 4934) 발굴. 모델 필드표 세로 stack·Table 4-7은 pdftoppm 셀 검증. 단일 Chapter 1 아래 2대분류. | **신규 최상위 폴더 `CPQ(견적)` + 6노트** (5 researcher·6 writer·12 검증 병렬): `CPQ API Models`(11모델 전 필드+Apex class — optionConfigurations/features 타입 불일치 Apex authoritative 각주·ConfigAttributeModel 객체명 오타 교정·colmnOrder [sic])·`CPQ Quote API`(8 하위 API+9 클래스, ServiceRouter 단일진입점·곡선따옴표 교정·JSON 닫는괄호 누락 [sic]·HTTP Method 불일치 [sic])·`CPQ Configuration·Contract API`(Loader/LoadRuleExecutor/Validator+Amender/Renewer)·`CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals`(SBAA Advanced Approvals·페이지경계 코드 재결합)·`JavaScript Quote Calculator Plugin`(7메서드+Page Security 4함수+Legacy Apex+샘플 5코드, Table 4-7=파라미터표[브리프 매트릭스 오인 정정])·`CPQ Plugins — Search·Recommended·Configurator·기타`(9 플러그인·p.90-91 스크린샷 산문화). nav: 신규 샤드 `_index/cpq.md`+`CPQ(견적)/index.md`+라우터 CPQ 도메인+Home 신설. cross-linker: "(미작성)" stale 라벨 7건 복원+형제 양방향+PlaceQuote 역링크(별개제품). | ✅ 완료(2026-06-21) — completeness 6노트 전부 갭0(11모델·8API·9플러그인 100% 전수)·source-verifier 불일치0(N2·N6 "(미작성)" 깨진링크만→cross-linker 복원)·qa PASS. Tier 3 노트 0. ★ **교훈**: (a) 필드표 세로 stack은 Apex `public class` 코드를 권위 소스로 + 긴 모델은 pdftoppm. (b) PDF 자체 결함(곡선따옴표·JSON 괄호·타입 불일치·HTTP Method)을 fabricate 아닌 [sic]+정상값 병기로 정직 처리. (c) 브리프 가정(Table=매트릭스)을 researcher가 이미지로 정정(파라미터표). (d) 신규 제품 도메인은 기존 유사 네임스페이스(RLM)와 혼동 차단 cross-link 필수. |
| ING-10b | `communities_dev.pdf` (**Experience Cloud Developer Guide**, v66.0 Spring '26, 105p, Tier 2) — 11챕터(Aura 기반 Experience Builder 사이트 개발·브랜딩·게스트 보안·CSP/Locker/LWS·Pardot/CMS/Deflection·ExperienceBundle 메타데이터). LWR 전용 가이드(exp_cloud_lwr.pdf=RECON-17 완전 위키화·ING-43 LWS)의 **Aura 사이트 짝**. | scout AP-06 ToC+본문+INDEX 교차검증으로 ToC 미표시 중첩항목 발굴(Migrate CSS 11컴포넌트 sub·Ch11 4 H3). 다단표 4종(Expressions·Deflection Payload·ExperienceBundle Folder/Contents·LWS org/site 매트릭스)·p.97 폴더트리는 pdftoppm 셀 검증. 물리=인쇄+4. | **신규 5노트** (3 researcher·5 writer·11 검증 병렬): **A** `Aura(오라)/Experience Builder Aura 사이트 개발.md`(Ch1도입·2·3 — forceCommunity 인터페이스 4종[availableForAllPageTypes·themeLayout·searchInterface·profileMenuInterface]·테마레이아웃·Aura expressions 13행·Personalization·PII 가시성 4메서드). **B** `Security(보안)/Experience Cloud 사이트 보안 — 인증·게스트 사용자.md`(Ch4 — 게스트 access·Encrypt Record IDs·Apex 5클래스 with/without sharing·SOQL injection). **C** `Security(보안)/Experience Cloud 사이트 — CSP·Locker·LWS.md`(Ch5 — org/site 매트릭스 8행·Locker 충돌 워크어라운드 3·allowInRelaxedCSP/RelaxedCSP·Adobe Analytics). **D** `Aura(오라)/Experience Builder 사이트 — Pardot·CMS·Deflection.md`(Ch6-8 — Pardot SPA·CMS 2옵션·lightningcommunity:deflectionSignal·Payload 4행·코드 4예제). **E** `DevOps(데브옵스)/ExperienceBundle — Experience Builder 사이트 메타데이터.md`(Ch9-11 — ExperienceBundle 폴더구조 6행·scratch JSON·package.xml·sf community CLI·enhanced LWR 마이그레이션·/s URL). nav: `_index/frontend.md`(A·D)·`_index/security.md`(B·C, Experience Cloud 보안 신규섹션)·`_index/platform-devops.md`(E) + 3 index.md. cross-linker: 형제 6쌍 양방향 + 기존노트 역링크 4건(LWS·Lightning Security 모델·LWR 허브←A·E). | ✅ 완료(2026-06-21) — completeness: A 초기 ❌(PII silent gap[Ch2 "Comply with Personal Information Visibility", 4메서드]→보강), B·C·D·E ✅. source-verifier: A·E ✅ / B·C·D 경미 1건씩 수정([sic] caseIDAND·매트릭스 ✗기호·async_load 정규화 각주). qa PASS. Tier 3 노트 0. ★ **boundary gap 교훈**: 병렬 writer 2명이 한 섹션(Ch2 PII)을 서로 상대 노트 소관으로 추정→양쪽 누락. completeness-validator가 ToC 챕터 귀속 직접 확인으로 적발. ★ **[sic] 일관성**: OCR 아티팩트 정규화 시 마커 누락을 source-verifier가 pdftoppm 이미지 대조로 적발. ★ 폴더 결정: Experience Cloud 전용 폴더 미생성 — 기존 Aura/Security/DevOps 도메인 폴더 배치 + LWR 허브 양방향. |

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
| VERIFY-1 | `Release/Winter '24/Development.md`·`Architecture(아키텍처)/DevOps Center.md`가 서술하는 `sf project deploy pipeline`(="Deploy Changes Using Salesforce CLI (Beta)")이 **로컬 52개 PDF grep 0건**으로 fabrication 의심됐던 항목(DevOps Center 조사 중 source-verifier 발견). RECON 프로젝트 파생 | `salesforce_winter24_release_notes.pdf`(ReleaseNote/ 서브폴더) **p.227** "Deploy Changes Using Salesforce CLI (Beta)" 섹션 — 셀단위 대조 | **fabrication 아님 — 출처 확인됨(Tier 2).** 명령 이름·기능명·핵심 디테일(plugin **package v6.0+** 호환·**Beta**·**DevOps Center Release Manager** 권한·Validate-Only in Bundling Stage **v6.3.0+**) 전부 PDF 원문과 정확 일치. `Development.md`는 무변경(이미 정확). `DevOps Center.md` 조치: ① source frontmatter에 `salesforce_winter24_release_notes.pdf` 추가, ② "Salesforce CLI로 파이프라인 배포 (Winter '24 Beta)" 경고를 **거짓 진술 정정**("49개 PDF 0건"→ false negative였음·명령/기능 Tier 2 검증) + **플래그 구문은 여전히 external-knowledge**(릴리즈 노트는 "the commands"만 언급, 개별 플래그는 CLI Command Reference[로컬 미보유] 소관)로 표시, ③ "CLI 연동 명령" 블록 경고도 동일 nuance로 갱신 | ✅ 완료(2026-06-21) — ★ **"게이트(PDF 미보유)" 가정이 false였음**: PDF는 `Salesforce Documents/ReleaseNote/` 하위에 실재. 초기 "52개 grep 0건"의 진짜 원인은 fabrication이 아니라 **검색 범위가 `ReleaseNote/` 서브폴더를 누락한 false negative**. ★ 교훈: source-verifier 위험신호는 정확했으나 그 **해석**(미보유)이 틀림 — 게이트로 적힌 항목도 직접 디스크 재확인 필요(RECON "백로그 가정 ≠ 디스크 실제" 재현). ★ nuance 보존: 명령/기능은 검증, 플래그 구문은 미검증 — 경고 통째 제거가 아닌 외과적 정정 |

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

### 2026-06-27 백로그 정합화 — 활성 "열린 항목"에서 이관/추가 (wiki-retrospective 모드 B)

> 활성 백로그 "열린 항목" 표가 실재와 어긋나 있던 stale 행(✅ 마킹됐으나 잔존 / 🔲 마킹됐으나 파일 실재) + 이번 세션(2026-06-27) 완료분을 파일 실재 검증 후 이관/추가. 8개 항목 그룹.

| # | 항목 | 산출물/근거 | 상태 |
|---|---|---|---|
| LINT-ELASTIC | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` Platform Apex 한도 표에 `DailyAsyncApexElasticExecutions`(elastic executions beta) 1행 보강 | ING-29가 app_limits 치트시트(p.5-6) 대조 중 발견. `pdftotext -layout`로 원문 셀 재추출(컬럼 collapse 우회), elastic 행 + 기존 `DailyAsyncApexExecutions` org 한도명 parity 보강. source frontmatter app_limits_cheatsheet 추가(Tier 2). **2026-06-27 정합화: L98 행 실재 재확인 후 이관**(활성 P0에 ✅ 잔존하던 행) | ✅ 완료(2026-06-22) |
| LINT-BOM | `Apex/SOQL(SOQL)/SOQL 문법 레퍼런스.md` UTF-8 BOM 제거 + `_index/*.md` 일괄 BOM 점검 | ING-29 cross-linker가 발견(lint false positive 유발). 점검 결과 2건(SOQL 노트 + `_index/sobject-reference.md`), `perl -pe s/^\xEF\xBB\xBF//`로 제거·검증. wiki-linter BOM 검사 추가는 retrospective 권고로 잔존. **2026-06-27 정합화: BOM 제거 재확인 후 이관** | ✅ 완료(2026-06-22) |
| LINT-1~4 | (1) 깨진 wikilink MetadataAPI 경로 prefix 누락 20건 수정 (2) MOC 누락 항목 SLDS·Enhanced Domains 추가 (3) peer 노트 역링크 3건 (4) `questions.md` 보조 샤드 예외 명문화(→AP-07) | 2026-05-25 lint 발견 → 2026-06-18 lint 수정 워크리스트에서 index-manager·cross-linker가 해소. LINT-2는 재확인 결과 기해소(LWC MOC L136·138, Architecture MOC L44). **2026-06-27 정합화: 4건 모두 ✅ 마킹됐으나 활성 P0에 잔존하던 행 이관** | ✅ 완료(2026-06-18) |
| 2GP-3 | `DevOps(데브옵스)/2GP Managed Package — Workflow.md` (pkg2_dev.pdf p.23-25) | **2026-06-27 정합화: 활성 P0에 🔲 대기로 stale했으나 파일 실재(399줄/32KB) 검증 → ✅ 마킹 후 이관** | ✅ 완료(검증 2026-06-27) |
| 2GP-4a~h | `DevOps(데브옵스)/2GP — Components - {Apex & Code / Automation / Einstein & Analytics / Integration & Platform / Objects & Fields / Security & Access / UI & Layout / Other}.md` 8노트 (pkg2_dev.pdf p.25-313 도메인 8분할, DEC-1 전략) | **2026-06-27 정합화: 활성 P2에 8행 전부 🔲 대기로 stale했으나 8파일 전부 실재(394~1747줄, 20~44KB) 검증 → ✅ 마킹 후 이관** | ✅ 완료(검증 2026-06-27) |
| ING-DC | **DevOps Center Developer Guide v67.0 전수 위키화** — 신규 폴더 `DevOps(데브옵스)/DevOpsCenter(데브옵스센터)/` 6노트: 데이터 모델 개요 + 객체 레퍼런스 4(파이프라인·프로젝트·환경 / Work Item·프로모션 / 비동기·결과 / 변경 추적) + User 필드·플랫폼 이벤트 | 23커스텀객체+5플랫폼이벤트+1User필드 ≈213필드 전수. completeness·source-verifier 각 2명 통과·cross-linker 6×5·qa PASS·Tier3 0. PDF force-add git 추적. 커밋 f3e9e58. **2026-06-27 신규 완료분 추가** | ✅ 완료(2026-06-27) |
| LINT-SHARD-DEVOPS | `_index/platform-devops.md` 토큰 상한 초과(111줄/~14k) 해소 — 2GP/패키징 클러스터 32행을 신규 `_index/platform-devops-2gp.md`로 이동 | 원본 81줄/~8.5k, 신규 63줄/~7k. 라우터·CLAUDE.md L133/L347 갱신. **2026-06-27 신규 완료분 추가**(샤드 건강 lint 후속) | ✅ 완료(2026-06-27) |
| LINT-SLDS-CATALOG | `LWC/SLDS(디자인시스템)/SLDS 블루프린트 카탈로그.md` 코드블록 0→2 — 포인터 카탈로그에 "블루프린트 사용 패턴(구조 예시)" 섹션 추가(HTML 골격+JS, fabricate 회피 마커) | CLAUDE.md "코드 블록 최소 1개" 구조 요건 충족. **2026-06-27 신규 완료분 추가** | ✅ 완료(2026-06-27) |

---

### 2026-06-27 백로그 정합화 (확장) — 활성 "열린 항목"의 ✅/⛔ 행 일괄 이관

> 정합화 범위를 "열린 항목" 전체로 확장. "열린 항목"에는 🔲/🟡만 남기고 ✅·⛔ 상태 행을 전부 이곳으로 이관(2026-06-27). 🟡 부분(ADMIN-4·ADMIN-6)은 active 유지.
> ※ 이미 ARCHIVE에 상세 항목이 있던 ✅ 행(ING-13a/15/19/21/23/29/31/33/34/36/39/43/45 · APEXLANG-1·UIAPI-1 · RECON-1/4/5/6/7/8/9/10/12/13)은 중복 보존하지 않고 활성에서 제거만 함(상세는 위 ING/RECON/PARTIAL 섹션 참조). 아래는 활성에만 inline으로 있던 행을 verbatim 보존한 것.

#### ✅ 완료 — P1/P2/P3 전략·갭 항목 (verbatim 이관)

| # | 항목 | 소스 | 상태 | 추가일 |
|---|---|---|---|---|
| DEC-1 | ~~Components Available 카탈로그(288쪽) 분할 전략 결정~~ | **✅ 결정 완료 (2026-05-23)**: 도메인 8분할 — MetadataAPI/Metadata Types 구조 미러. 파일명: `2GP — Components - Apex & Code.md` 등 8개. MetadataAPI는 API 구조, 2GP Components는 패키징 동작(Manageability+Editable Properties) 역할 분업. | ✅ 완료 | 2026-05-23 |
| 2GP-5 | `2GP — Specific Metadata Behavior` (Apex/Protected/Permission Sets/Profile) | pkg2_dev.pdf p.314-333 | ✅ 완료 | 2026-05-23 |
| 2GP-6 | `2GP — Develop (Apex·버전 생성)` | pkg2_dev.pdf p.334-347 | ✅ 완료 | 2026-05-23 |
| 2GP-7 | `2GP — Install · Uninstall` | pkg2_dev.pdf p.348-359 | ✅ 완료 | 2026-05-23 |
| 2GP-8 | `2GP — Prepare to Distribute` | pkg2_dev.pdf p.360-363 | ✅ 완료 | 2026-05-23 |
| 2GP-9 | `2GP — Push Upgrade` | pkg2_dev.pdf p.364-373 | ✅ 완료 | 2026-05-23 |
| 2GP-10 | `2GP — Advanced Features` | pkg2_dev.pdf p.374-406 | ✅ 완료 | 2026-05-23 |
| 2GP-11 | `2GP — Best Practices + License Management + Feature Management` | pkg2_dev.pdf p.407-427 | ✅ 완료 | 2026-05-23 |
| 2GP-12 | `2GP — AppExchange App Analytics` (~76쪽 — 분할 검토) | pkg2_dev.pdf p.428-504 | ✅ 완료 | 2026-05-23 |
| 기존 P2-02 | ~~`Release/Spring '26.md` (v66.0) 작성~~ | **✅ 완료 (2026-06-14)**: salesforce_spring26_release_notes.pdf(Spring '26, v66.0, Tier 2)에서 개발자 섹션 발췌. 댕글링 링크 3건 해소. | ✅ 완료 | 2026-05-18 |
| 기존 P3-05 | ~~LWC BaseComponents 확장 (lightning-tree·tab·pill 등)~~ | **✅ 완료 (2026-06-13)**: SLDS2-Docs cx-router 메타데이터(Tier 2)로 신규 55 + 기존 11 패밀리 명세 병합 = 66개. 카탈로그 역링크 + SLDS 디자인시스템 폴더 27노트도 함께. | ✅ 완료 | 2026-05-18 |
| DEV-GAP-1 | ~~**Data Skew** (account/lookup/ownership skew)~~ | **✅ 완료 (2026-06-14)**: `Architecture(아키텍처)/Data Skew.md` — LDV 가이드(Tier 2)에서 account data/ownership skew 1만 건 임계값·record-locking·defer sharing·케이스 스터디 추출. lookup skew는 메커니즘만(가이드 미명시 명시). | ✅ 완료 | 2026-06-14 |
| DEV-GAP-2 | ~~**Trigger 재귀 방지** 전용 노트~~ | **✅ 완료 (2026-06-14)**: `Apex/Trigger(트리거)/Trigger 재귀 방지.md` — Apex Dev Guide(Tier 2)의 static 변수 재귀 제어(firstRun 원문 예제)·스택 깊이 16·롤백 캐비엇 + TriggerHandler setMaxLoopCount(Tier 1) 교차참조. | ✅ 완료 | 2026-06-14 |

#### ✅ 완료 — INGEST 인제스트 행 (verbatim 이관, 활성 inline-only)

| # | PDF | 도메인 | 상태/비고 |
|---|---|---|---|
| ING-01 | ~~salesforce_data_loader (58)~~ | Admin/Data | **✅ 완료 (2026-06-14)** → `Admin(어드민)/Data Loader.md` |
| ING-02 | ~~Salesforce-Flow-Best-Practices 백서 (19)~~ | Flow | **✅ 이미 완료(기존)** — `Flow 설계 베스트 프랙티스`·`Flow 네이밍 컨벤션`·`Flow 에러 처리` 3노트가 이 백서 출처. (※ source에 `.pdf` 미기재라 초기 탐지서 누락됐던 거짓양성) |
| ING-03 | platform_events (628) | Apex/PlatformEvents (분할) | **✅ 전수 완료 (2026-06-14)** — 3노트 심화: 정의와구독에 Pub/Sub API(gRPC·Avro·Publish/PublishStream·11언어)·CometD·이벤트 스트림 그룹/필터(커스텀 채널) 추가, 한도노트에 표준 PE 객체(EventUuid/ReplayId/LoginKey)·발행 상태코드(OPERATION_ENQUEUED) 추가. 7노트 전부 공식 링크 |
| ING-04 | api_rest (430) = REST API Developer Guide | Integration | **✅ 전수 완료 (2026-06-14)** → `REST API.md` 119→177줄. 헤더 10종·sObject 리소스 전체·Composite(25/500 subreq)·Graph/Batch/Tree/Collections·status codes·날짜형식 + 공식 링크. (Composite 세부가 더 커지면 분할 여지) |
| ING-05 | api_action (151) = Actions Developer Guide | Integration/Actions | **✅ 전수 완료 (2026-06-14)** → `Actions API.md` — 액션 유형·호출 프레임워크·**표준 액션 50+종 전수 목록**(카테고리별)·Apex 액션 + 공식 링크. (개별 액션 입력필드 전체는 공식 가이드 각 페이지) |
| ING-06 | api_asynch (182) = Bulk API 2.0 and Bulk API | Integration/Bulk·Async | **✅ 전수 완료 (2026-06-14)** → `Bulk API 2.0.md` 99→196줄. Create Job 요청/응답 전 필드·enum, 잡 상태 6종, Job Info 메트릭, 결과 3종 엔드포인트, Query Locator 헤더, limits 수치, status/error codes |
| ING-08 | ~~salesforce_analytics_rest_api (310)~~ = **Reports and Dashboards REST API Developer Guide v67.0 Summer '26** | Analytics | **✅ 전수 완료 (2026-06-22)** → [[WORK_BACKLOG_ARCHIVE]] ING-08. ING-07이 만든 `Analytics(애널리틱스)/`·`_index/analytics.md` 재사용 + **신규 11노트**(22,979줄 전수, 사용자 "전수" 스코프). **예제 2:** 개요·Reports 예제(Ch1+Ch2 Reports: Create/Run sync·async/Filter/Fact Map/Save/Clone/Delete)·Dashboards·Downloads·Notifications 예제. **표현형 Reference 9:** Report·**Describe(reportMetadata)**·Execute·Instances·Report List·Query·Report Fields·Error Codes(47행)·Report Types·Dashboards·Folders·Analytics Download·Notifications·Filter Operators. ★ **dedup 핵심**: reportMetadata 34속성+12중첩+reportTypeMetadata+reportExtendedMetadata 정본은 **N4 Describe 1곳**, Report/Execute/Query/Report Type이 N4 deep-link(복제 0) — 동일 스키마가 6 resource 반복되는 REST 카탈로그에서 drift 방지. 9 researcher(전 대형표 pdftoppm 셀검증)·11 writer·source-verifier(N4/N9/N10 셀·enum·[sic] 정확)·cross-linker·qa PASS·Tier3 0. ★ **교훈**: (a) **Write 도구 가드** — 파일명에 "report/error/표현형/예제" 포함 시 harness가 참고문서로 오인 차단 → writer가 Bash 단일인용 heredoc 우회(JSON `\"` 보존). (b) reportMetadata 카운트 라벨이 노트마다 35/32/34로 갈림 → source-verifier 실측 34로 통일(정본 1곳 카운트 일관성). (c) 파일명≠제목 또 반복(analytics_rest=Reports and Dashboards REST API, CRM Analytics 아님). nav: 샤드 11행(73줄)·폴더 index 섹션. cross-link: 형제 승격 + N1↔Execute/Query 양방향 + `Apex/Data(데이터)/Reports Namespace`(REST↔Apex peer) 역링크 | ✅ 완료 | 2026-06-22 |
| ING-09 | ~~salesforce_knowledge_dev_guide (209)~~ | Service/Knowledge (신규 폴더) | **✅ 전수 완료 (2026-06-17)** → 신규 `Service(서비스)/Knowledge(지식)/` 9노트(4,297줄): 데이터모델&API개요·SOAP객체(핵심6/주변8=14종)·SOAP호출4종·REST(Actions+Manage19)·REST(Search7+Support4)·Metadata타입(아티클설정5/데이터카테고리외부5=10종)·UI API제약. 신규 샤드 `_index/service.md`·라우터·Home·역링크 5건. Ch5 SOQL/SOSL·Ch6 PublishingService는 기존 노트(SOQL WITH DATA CATEGORY·SOSL 패턴·KbManagement) 역링크로 중복 회피. completeness/source-verifier 셀단위 통과 |
| ING-10a | ~~exp_cloud_lwr (106)~~ = LWR Sites for Experience Cloud | LWC/Experience | **✅ 전수 완료 (2026-06-14)** → `LWC/UIPatterns(UI패턴)/LWR Sites (Experience Cloud).md` (LWR 템플릿·lightningCommunity__ 타깃 4종·@salesforce 모듈·--dxp 훅·다국어) + 공식 링크 |
| ING-11 | mobile_offline (258) = Mobile and Offline Developer Guide | Mobile | **✅ 전수 완료 (2026-06-14)** → `LWC/Mobile(모바일)/모바일 & 오프라인 (LWC).md` (mobileCapabilities 10종·LWC Offline·Offline GraphQL·Briefcase·draft records·제약) + 공식 링크. 기존 모바일 기능 패턴(Tier1)과 상호 링크 |
| ING-12 | ~~lightning_knowledge_guide (91)~~ = Lightning Knowledge Guide (Spring '26) | Service/Knowledge (admin) | **✅ 전수 완료 (2026-06-17)** → 기존 `Service(서비스)/Knowledge(지식)/`에 admin-facing 7노트(~1,936줄, ING-09의 9개 개발자/API 노트와 viewpoint 구분): 개요(계획·Lightning vs Classic 비교·한계 6하위그룹)·셋업&구성(가이드/수동·권한표)·사용(작성액션 가용성·검색·스마트링크/영구링크·채널 액션)·아티클 리포팅(9필드표)·아티클 임포트(csv/zip·.properties 파라미터)·다국어&번역(ArticleManagement 25행 컬럼표·발행/번역/아카이브/나란히보기)·데이터카테고리&공유(선언적·공유 모델). 다단 표 6개 pdftoppm 이미지검증. **중복 회피:** Metadata 데이터카테고리 스키마·데이터모델·SOAP 통계객체·REST Search/Actions·UI API 제약은 ING-09 노트로 역링크(스키마 재작성 0). cross-linker가 기존 API 노트 6개에 역링크 7건. nav: `_index/service.md` 7행·`_index/questions.md` 어드민 자연어 7행·Service/Knowledge index.md A/B 그룹 재편·Service 허브 갱신. completeness/source-verifier/qa 통과, Tier 3 노트 0 |
| ING-14 | ~~case_feed_dev_guide (45)~~ = **Publisher and Quick Action Developer Guide** (Summer '26) | LWC/Aura·Visualforce (Quick Action JS API) | **✅ 전수 완료 (2026-06-18)** → 신규 2노트: `Aura(오라)/Quick Action·Publisher JS API 레퍼런스.md`(~530줄, p.5-22 — `lightning:quickActionAPI` 8메서드[getAvailableActions·getAvailableActionFields·getCustomAction·getSelectedActions·invokeAction·selectAction·setActionFieldValues 등] + `Sfdc.canvas.publisher` 5메서드[selectAction·setActionInputValues·invokeAction·customActionMessage·refresh] + LEX↔Classic 패리티 표) + `Aura(오라)/Case Feed Visualforce 커스터마이즈.md`(~670줄, p.23-45 — VF 컴포넌트 6개 속성표 89행[`apex:emailPublisher`·`apex:logCallPublisher`·`support:portalPublisher`·`support:caseArticles`·`support:CaseFeed`·`chatter:feed`] + Apex 4클래스). source: `case_feed_dev_guide.pdf` Tier 2. **★ 정체 정정:** 파일명 `case_feed`는 함정 — 실제 내용은 Quick Action JS API·Publisher API·VF 액션 커스터마이즈. **동명이의 3구분 명시:** 이 JS API ≠ Apex `QuickAction` 네임스페이스(서버측 performQuickAction) ≠ Lightning Console JS API(workspaceAPI). 교차링크 양방향: QuickAction Namespace·Lightning Console JS API(ING-24, 별개 명시)·Lightning Knowledge 사용(ING-12)·ApexPages Namespace·Support Namespace(coverage-checker 발견). completeness/source-verifier/qa ✅, Tier 3 노트 0. retrospective(모드 A): 양 노트 aliases에 `case feed`·동명이의 구분·VF 컴포넌트 속성 자연어 표현 보강 |
| ING-16 | ~~bi_dev_guide_lwc_in_db (23)~~ = LWC in CRM Analytics Dashboards | Analytics/LWC | **✅ 완료 (2026-06-14)** → `LWC/UIPatterns(UI패턴)/CRM Analytics 대시보드용 LWC.md` |
| ING-17 | ~~draes (15)~~ = Designing Record Access for Enterprise Scale | Architecture/Security | **✅ 완료 (2026-06-14)** → `Architecture(아키텍처)/레코드 액세스 설계 (Enterprise Scale).md`. ADMIN-4 부분 충족 |
| ING-24 | api_console (346) = Salesforce Console Developer Guide | LWC/Navigation | **✅ 전수 완료 (2026-06-14)** → `LWC/Navigation(네비게이션)/Lightning Console JS API.md` (Lightning Console API: workspaceAPI/utilityBarAPI/navigationItemAPI 메서드 전수·Aura/LWC·LMS 탭이벤트·Classic 레거시) + 공식 링크 |
| ING-27 | ~~salesforce_pages_developers_guide (817, 분할)~~ = **Visualforce Developer Guide v67.0 Summer '26** | Visualforce | **✅ 전수 완료 (2026-06-22)** → [[WORK_BACKLOG_ARCHIVE]] ING-27. **위키 첫 `Visualforce(비주얼포스)/` 폴더 신설 + 16노트** (Part A 개념 11 + Part B 컴포넌트 레퍼런스 5). **Part A(11):** 개요·퀵스타트 / 페이지 출력 제어(PDF·SLDS·doctype) / 표준·표준리스트 컨트롤러 / 커스텀 컨트롤러·확장 / 버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트 / 동적 VF(바인딩·동적 컴포넌트) / 이메일·차트·맵·Flow·템플릿 / LEX·모바일·AppExchange / JavaScript·Remoting·LMS / 베스트 프랙티스 / Global Variables·함수·연산자(Appendix A). **Part B(5, Ch24 표준 컴포넌트 152개 attribute 표 전수):** 페이지·레이아웃(23)·입력/폼(27)·출력·데이터·반복·차트(28)·AJAX·액션·Remote Objects(17)·비-apex(chatter/liveAgent/messaging/knowledge/wave 57). 6열 표(Name·Type·Desc·Required?·API·Access) 전수, pdftoppm 셀 검증으로 6열 collapse 우회. ★ 중복 회피: emailPublisher·logCallPublisher·support:caseArticles/caseFeed/portalPublisher 5개는 [[Case Feed Visualforce 커스터마이즈]](ING-14/39) deep-link만. **source-verifier 정정 다수:** B1(Access 양방향 오류·속성행 누락6·cspHeader↔deferLastCommandUntilReady 혼입·printLink→printUrl 정정), B2(legacy global 행 5건), B4·B5 각1건. qa 적발 docType `xhtml-1.1-basic`·"If not specified" 의미반전 정정. Tier 3 0. nav: 신규 `_index/visualforce.md` 샤드·라우터·Home·CLAUDE.md 표(MOC는 폴더 index.md 갈음). cross-linker: 형제 plain-text 폴백 승격 + Case Feed VF·ApexPages Namespace·이메일 노트 역링크. ★ ING-37·ING-39 흡수(동일 PDF) | ✅ 완료 | 2026-06-22 |
| ING-46 | `field_service_dev.pdf` (687p / **실측 39,439줄**, 분할 필수) = **Field Service Developer Guide v67.0 Summer '26** | Service/Field Service | ✅ **완료 (2026-06-22 착수~2026-06-24 종료, 사용자 "전수" 스코프, 4사이클 20노트)** — ★ **백로그 미등재였던 진짜 미착수 PDF**(grep 0건·아카이브 무관·기존 `sObject/Field Service Objects.md`는 object_reference.pdf 출처라 별개). **위키 최대 단일 PDF**(ING-08 22,979줄 초과). 구조: ①Get Ready+EOL Policy ②**Field Service Data Objects(p.2–497)**=6데이터모델(Core·Inventory·PreventiveMaintenance·PSC·Warranty·Pricing)+**Object References(p.13–497 ~485p 필드 전수 거대 카탈로그)** ③REST API(p.498–543: Flow·MobileSettings·ServiceReportTemplate·ApptBundling) ④Metadata API(p.544: FieldServiceSettings·Skill·TimeSheetTemplate) ⑤Tooling API(p.556: CleanRule·TimeSheetTemplate) ⑥**FSL Apex Namespace(p.565–622, LxScheduler와 별개제품 혼동차단)** ⑦Custom Triggers(p.623) ⑧Code Examples(p.636) ⑨Mobile App LWC(p.644–682). dedup: 기존 FS Objects 요약카탈로그↔본 가이드 필드전수 보완(deep-link, 복제0). 멀티사이클. **★ scout 인벤토리 완료(2026-06-22): 오프셋 +4 고정, Object References=주객체 108개+표준객체 커스텀필드 9+보조객체 49, FSL Apex 19클래스, FSL↔LxScheduler 클래스충돌 0.** **★ Cycle 1 완료(2026-06-23): 신규 `FieldService(현장서비스)/` 폴더 + 뒷부분 6노트** — 개요·데이터모델(허브, ER 6종 pdftoppm 판독)·REST API(Flow·MobileSettings·ServiceReportTemplate·ApptBundling 6엔드포인트)·Metadata·Tooling API(FieldServiceSettings40·Skill·CleanRule·동명 TimeSheetTemplate 2종 구분·enum8)·FSL Apex Namespace(19클래스·[sic]9 원문불일치 보존)·Custom Triggers·Code Examples(Table6 24행·예제4·[sic]9)·Mobile App LWC(URI스킴12·플러그인7·바코드11). 6노트 전부 completeness 갭0·source-verifier 불일치0·qa PASS·Tier3 0. nav: 신규 샤드 `_index/field-service.md`·폴더index·라우터·Home. cross-link 11건. ★ crunch 근본수정: researcher/writer/검증 전부 `/tmp` dump+5줄 요약 반환계약으로 메인 컨텍스트 절약. **★ Cycle 2 완료(2026-06-23)**: planner가 109객체→14노트(주카탈로그12+커스텀필드1+보조1) 클러스터 설계(`/tmp/fsdev_C2_plan.md`). C2 = 객체 레퍼런스 4노트(31객체 전수): Appointment Bundling(8객체89필드)·Asset·Attribute·Warranty(12객체~175필드)·Service Contract·Entitlement·Milestone(6객체138필드)·Service Appointment·Resource(5객체85필드). 4노트 completeness 갭0·source-verifier 불일치0·qa PASS·Tier3 0. nav: 샤드 "객체 레퍼런스" 그룹+폴더index. cross-link: N1 누락 `[[Field Service Objects]]` 복원 + 요약 카탈로그↔4상세 양방향. ★ researcher 1명 연결끊김(API) 1회→재실행 성공. ★ N1 writer가 실재하는 `[[Field Service Objects]]`를 "없음" 오판→cross-linker 복원(wikilink basename 해석 인지 필요). **★ Cycle 3 완료(2026-06-23)**: 객체 레퍼런스 4노트(43객체): Service Resource·Crew·Skill(10)·Service Territory·OperatingHours·Shift(10/110필드)·Inventory(Product·ReturnOrder·Shipment)(15)·Maintenance·PSC·Location(8). completeness 갭0(초기갭2건 writer 보완: SkillRequirement Associated Objects·Usage, ProductTransfer→ProductTransferShare)·source-verifier 불일치0·qa PASS. nav+cross-link(허브 Object References placeholder→deep-link 8). **★ Cycle 4 완료(2026-06-24)**: 잔여 35객체+커스텀필드+보조객체 8노트(2184줄): Work Order·LineItem·Status(4/130)·WorkPlan·WorkStep·WorkType(10/93)·Service Report·Layout·DigitalSignature(3)·Expense·TimeSheet(5)·WorkCapacity·RecordsetFilterCriteria(6)·Mobile·Geo·LinkedArticle·ObjChange(7, FieldServiceMobileSettings 53필드)·Custom Fields on Standard Objects(9객체 FSL__ 외부58+Internal12)·Supplementary Objects(57 보조객체). completeness 8/8 갭0(G Internal 15→12 정정)·source-verifier 8/8(★H가 PDF원본 대조로 51→57 누락 발견·보완 — 파생추출물 절단은 completeness엔 거짓PASS로 통과했고 1차원본 재독 검증만이 잡아냄, source-verifier PDF직결의 가치 입증)·qa PASS·Tier3 0. nav 등록+라우터/샤드 stale문구 "전 객체 전수 완료"로 정정. **★ ING-46 종료: 챕터 109객체 전수(C2 31+C3 43+C4 35)+커스텀필드 9+보조객체 57. v67.0 전수 위키화 완료(C1 6노트+C2~4 14노트=20노트).** | ✅ **완료** (2026-06-24, 20노트) | 2026-06-22 |
| ING-32 | ~~salesforce_scheduler_dev_guide (434, 분할)~~ = **Salesforce Scheduler Developer Guide v67.0 Summer '26** | Sales/Scheduler | **✅ 전수 완료 (2026-06-22)** → [[WORK_BACKLOG_ARCHIVE]] ING-32. **신규 `Scheduler(스케줄러)/` 폴더 + 12노트** (434p/25,284줄, 사용자 "전수" 스코프). 개요·셋업·인증·toLabel(Ch1-3·8·9) / 표준객체 4노트(Ch4 28객체 필드 전수: 핵심예약·리소스영역스킬시프트·정책운영시간작업유형·초대집계로그) / 커스텀객체(Ch5 10 junction) / Platform Events·Metadata(Ch6·7+Ch13 PE: ServiceAppointmentEvent·AppointmentSchedulingEvent·IndustriesSettings) / Business REST·Connect 엔드포인트(Ch10a) / Connect 요청·응답 표현형·Error Codes(Ch10b, Req13·Resp28) / ConnectApi LightningScheduler Apex(Ch11) / 커스텀 예약 시나리오 2노트(Ch12 11시나리오). ★ **dedup**: Ch11 LxScheduler 9클래스 + Ch13 클래스는 기존 `Apex/Integration(통합)/LxScheduler Namespace.md`가 완전 커버 → 복제 0, N10은 **ConnectApi(LightningScheduler 2메서드)만** 신규. 3 scout 정정(LightningScheduler 4→2메서드·WorkTypeGroup 13→8·…Translation 4→5필드). 13 researcher(대형표 pdftoppm/-layout 셀검증, IndustriesSettings horizontal collapse·필드명 [sic] `ServiceApptSchduleEvent` 보존)·12 writer·index-manager·cross-linker. Tier3 0. ★ **교훈**: (a) heredoc cwd 사고(`cd forceNote-wiki` 중복→중첩폴더) → 절대경로 heredoc로 해결. (b) Ch12는 LWC 아닌 API 시나리오 가이드(제목 함정). nav: 신규 `_index/scheduler.md`(51줄)·폴더 index·라우터·Home·CLAUDE.md. cross-link: 형제 승격 + LxScheduler·Field Service Objects 역링크 + N8 깨진 wikilink 수정 | ✅ 완료 | 2026-06-22 |
| ING-37 | ~~salesforce_pages_developers_guide (817, 분할)~~ | Visualforce | **✅ 종결 (2026-06-22)** — ING-27과 동일 PDF 중복 행. ING-27 전수 완료로 **흡수 종결**(별도 작업 없음). → [[WORK_BACKLOG_ARCHIVE]] ING-27 참조 |
| ING-41 | `object_reference.pdf` — **표준 Address compound 서브필드 전수표 + Compound Field Considerations/Limitations** | Data/Schema (sObject) | ✅ **기실재 검증(2026-06-19, RECON-3 ⑤ 감사)** — object_reference.pdf Ch1 Compound Fields 섹션 셀단위 대조 결과 `sObject/Compound Fields.md`가 **표준 Address 서브필드 10행(Accuracy·City·Country·CountryCode·Latitude·Longitude·PostalCode·State·StateCode·Street)·Geolocation·Considerations/Limitations를 이미 전수 보유**. "반쪽 비어있음"은 2026-06-18 coverage-checker 오판정(또는 ING-15로 백필됨). 신규/보강 불필요 → ARCHIVE 이관 권고 |

#### ✅ 완료 — RECONCILE 재감사 행 (verbatim 이관, 활성 inline-only)

| # | 항목 | 소스/판정 근거 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|
| RECON-3 | **대형/멀티토픽 PDF 챕터 커버리지 재감사 — 우선순위 초안** | 위 4단계 방법론을 source 자주 인용되는 대형 PDF에 순차 적용. **진행:** ①✅·②✅·③✅·④✅·⑤✅ — **RECON-3 전체 마감(2026-06-19).** 대형 5종 챕터 커버리지 재감사 완료. **① `apex_developer_guide.pdf`** ✅ — 다도메인 언어 가이드(Deploying Apex 외 Debugging/ApexDoc/Invoking/Triggers 챕터 점검). RECON-1 첫 발견, **RECON-4~9·12·13이 이 ① 산출물 — completeness-validator 문서 레벨 커버리지 맵 2026-06-19**(고가치 챕터 RECON-1/4/5/6/12 닫힘; RECON-7/8/10/13 ✅·RECON-9 de-scoped 2026-06-19·RECON-11[Tooling API 배포] ✅ 2026-06-20·RECON-16[Chatter/Knowledge 트리거 고려사항] ✅ 2026-06-20 → **apex_developer_guide.pdf 전 챕터 커버 완료, 잔여 미커버 0**). **② `pkg2_dev.pdf`** ✅ (2GP, **2026-06-19 닫힘**) — 4단계 감사 결과 단일 "Chapter 1"에 17개 H2 구조, 16개 H2는 기존 ~28개 2GP 노트가 전부 커버, **유일 미커버 H2 "Gaps Between First- and Second-Generation Managed Packaging"(print p.505)** = 2GP-13으로 닫음(`2GP Managed Package 개념과 1GP 비교.md` §9 추가). **이 PDF에서 새로 발견된 미커버 잔여 챕터 없음 → 전 H2 닫힘, 신규 RECON-N 등재 불필요.** (★ 백로그 page "p.505-517"은 과대추정 — 실측 print p.505 단일 페이지뿐, p.506-517은 PDF back-matter/index였음.) **③ `sfdx_dev.pdf`** ✅ (2026-06-19 닫힘) — v67.0 Summer '26 ToC 실측 16챕터, H2 레벨 전수 grep 대조 결과 28노트가 전 H2 커버. "16챕터 완료" 표기 **참 검증**. DevOps Center scratch feature/setting·Org Shape 활성화·DX MCP `devops` 툴셋·source tracking 규칙 모두 기존 노트 커버 확인. 신규 미커버 0 → RECON-N 등재 불필요(read-only 감사). **④ `api_meta.pdf`** ✅ (2026-06-19 닫힘) — 메타데이터 타입 전수 vs 위키 인용 재감사 + closure. (a) 메커니즘 챕터(Ch0 — File-Based/CRUD 호출 등) 미커버 0, (b) Metadata Types 도메인그룹 미커버 0, (c) RECON-2(DevOps Center DevHubSettings 2필드 `enableALMDevopsCorePref`/`enableDevOpsCenterGA` — `DevOps Center.md`에 이미 반영, 재감사 확인) / ING-40(CustomAddressFieldSettings delta) / ING-42(AddressSettings) 전부 닫힘. 신규 미커버 잔여는 저위험 1건(RECON-14, Ch4 Run Relevant Apex Tests in a Deployment Beta)으로 분리 등재 후 ✅ 완료(2026-06-19, 재검증 결과 실제 공백 발견 → File-Based 호출 노트에 §RunRelevantTests Beta 신설). **⑤ `object_reference.pdf`** ✅ (2026-06-19 닫힘) — v67.0 Summer '26, Ch1-6 "완료" 표기 **참 검증**(32 서브페이지 전수 커버). ING-41(표준 Address compound)은 **기실재**(Compound Fields.md가 이미 전수 보유 — 오판정). 유일 미커버는 Ch1 "Field and Type Differences"(저가치) → RECON-15 분리. **→ RECON-3 ①~⑤ 전부 완료, 항목 마감.** 잔여 저가치 챕터(RECON-7/8/9/10/11/13/14/15)는 별도 P3 sweep. | **P2** | ✅ 완료 (①~⑤) | 2026-06-19 |
| RECON-17 | ~~**`exp_cloud_lwr.pdf` (LWR Sites, 106p) 챕터 커버리지 — ING-10a "완료"였으나 H2 단위 대부분 미커버**~~ | **✅ 전체 완료 (2026-06-20)** → [[WORK_BACKLOG_ARCHIVE]] RECON-17·17a~d. ING-43(LWS) scout 발견(ToC 위키화됨이나 H2 단위 완전커버 0·부분 6·미커버 2). 1차(허브 확장+spoke 2: 다국어·Expressions) + **deferred 4 spoke 전수**: 17a `LWR 동작·캐싱·제약`(Ch2)·17b `LWR 컴포넌트 개발 심화`(Ch3)·17c `LWR --dxp 스타일링 훅 레퍼런스`(Ch4, 8p 거대표 pdftoppm)·17d `LWR Tag Manager 데이터 관리`(Ch7+Ch6, 이벤트 9종 pdftoppm·동명이의 2종). **exp_cloud_lwr.pdf(106p) 완전 위키화 완료.** ★ 교훈: "ING 완료" 표기도 H2 단위로는 thin slice일 수 있음(ToC 레벨 ≠ H2 레벨). 4 spoke 전부 completeness 갭0·source-verifier 불일치0·qa PASS·Tier3 0 | **P3** | ✅ 완료 | 2026-06-20 |

#### ⛔ de-scoped — 위키화 부적합 (활성 INGEST에서 이동)

> 개발 위키 스코프 밖/노후/저가치로 de-scope된 PDF. 재개 조건은 각 행에 기재. (RECON-9 de-scoped는 위 RECON 섹션에 기보존.)

| # | PDF | 도메인 | de-scope 근거·재개 조건 |
|---|---|---|---|
| ING-20 | omnichannel_supervisor (32) | Service | ⛔ **de-scoped (2026-06-20)** — "Omni Supervisor" Spring '26 = **슈퍼바이저 UI 사용 가이드**(에이전트 모니터링·큐 백로그·Agents 탭). API/Apex/metadata 개발 콘텐츠 0. + Standard Omni-Channel EOL Summer '26. 개발 위키 스코프 밖(슈퍼바이저 UI 사용법). 재개 조건: ADMIN 갭 이니셔티브(선언적 어드민 도메인) 진행 시 함께 검토 |
| ING-30 | service_presence_administrators (124) | Service (Omni-Channel admin) | ⛔ **de-scoped (2026-06-20)** — "Omni-Channel for Administrators" Spring '26, 124p = **선언적 어드민 설정 가이드**(Configure Routing Rules·Set Up Omni-Channel·Create Service Channels·Set Up Agents/Queues·Custom Report Types). 3중 근거: **(1)** dev guide(=ING-19 Omni-Channel Developer Guide)로 **개발 표면 이미 커버**(객체·메타데이터·External Routing·Apex AgentWork 생성). 이 admin 가이드의 잔여는 선언적 UI 설정(라우팅 룰·서비스 채널·큐). **(2)** Standard Omni-Channel **EOL Summer '26**(Enhanced 권장). **(3)** 선언적 어드민 = 개발 위키 스코프 밖(ADMIN 갭 도메인). 재개 조건: ADMIN 갭 이니셔티브 진행 시 ADMIN 항목으로 재평가(개발 INGEST 아님) |
| ING-35 | salesforce1_admin_guide (86) | Admin/Mobile | ⛔ **de-scoped (2026-06-20)** — 내용 검증 결과 위키화 부적합 3중 근거: **(1) 노후** = "Salesforce App Admin Guide" **Version 13, Summer '19**(7년 전), 본문에 폐기된 "Salesforce1/Salesforce App" 브랜딩 100회. **(2) 어드민 포커스** = 모바일 페이지 레이아웃·네비게이션 메뉴·커스텀 브랜딩·액션 설정(개발 위키 스코프 밖, ADMIN 갭 영역). **(3) 모순/중복** = 개발 관련 슬라이스가 이미 **더 최신** 노트로 커버 — Offline은 `LWC/Mobile(모바일)/모바일 & 오프라인 (LWC)`(mobile_offline.pdf **Summer '26**), Quick Actions는 `Aura/Quick Action·Publisher JS API`(ING-14)·`QuickAction Namespace`·`lightning-quick-action-panel`, Compact Layouts는 UI API 노트. 2019 Offline 섹션을 위키화하면 2026 Offline 노트와 정면 모순. ★ MEMORY "PDF 버전 확인 규칙" + RECON-9/ING-18/ING-20 de-scope 선례 적용. 재개 조건: 최신 버전 "Salesforce App Admin Guide" 또는 현행 Mobile 개발자 가이드 입수 시 재평가 |
| ING-38 | salesforce_reports_enhanced_reports_tab_tipsheet (3) | Reports | ⛔ **de-scoped (2026-06-20)** — 내용 확인: "USING THE REPORTS TAB" = 3p **엔드유저 UI 팁시트**(리포트 탭에서 리포트 찾기·정리·관리·접근성 모드). API/개발 콘텐츠 0, 어드민 설정도 아닌 순수 UI 사용 팁. 개발 위키 가치 없음. 재개 조건: Reports/Dashboards 정식 가이드 확보 시 ADMIN-5(Reports & Dashboards) 항목으로 진행 |

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
