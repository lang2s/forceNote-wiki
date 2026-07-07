---
tags: [meta, qa, verification, integration, interface, harness]
source: 위키 자가검증 (2026-07-07 세션, 라우터→샤드→파일 네비게이션 대조)
created: 2026-07-07
aliases: [인터페이스 검증, Interface Coverage Verification, 통합 답변 검증, verification harness, 위키 검증 하네스]
---

# Interface(통합/연결) 답변 커버리지 검증 — Verification Harness

> Salesforce 통합/인터페이스 도메인에 대해 **위키가 실무 질문의 정답을 실제로 추출해 주는가**를 반복 검증하는 QA 하네스. 질문을 바꿔가며 재실행할 수 있다.

---

## 이 노트의 용도

이 문서는 위키 지식 노트가 아니라 **메타/검증 도구**다(`_MOC/WIKI_RULES.md`와 같은 시스템 파일). 목적:

1. 통합/인터페이스 도메인의 "답변 커버리지"를 주기적으로 재측정한다.
2. 질문 세트를 교체하며 새 사각지대를 찾는다.
3. 발견된 갭 → 보충 이력을 남겨 회귀(regression)를 방지한다.

---

## 검증 방법론 (핵심 규율)

```text
// 절차 — 재실행 시 그대로 따른다
1. 질문을 위키에서 역산하지 않는다.  ← 가장 중요
   · 위키에 뭐가 있는지 보고 질문을 만들면 100% 통과라는 착시만 남는다.
   · 질문은 (a) 실무 admin/dev/architect 관점에서 독립 생성 + (b) 웹의 실제 Q&A(Stack Exchange·Trailblazer·Reddit)에서 수집한다.
   · 일부러 "위키에 없을 법한" 질문을 섞는다(아키텍처 판단·운영·거버넌스).
2. 각 질문을 위키 네비게이션 경로로만 답한다:
   00 SEARCH_INDEX.md(라우터) → _index/{샤드}.md → 실제 노트.md 를 열어 섹션을 읽고 판정.
   · 검사관의 외부 지식은 "위키 내용의 정확성/완결성 평가"에만 쓴다. 빈틈을 채워 ✅ 주면 안 된다.
3. 판정: ✅ 정답 명확 / ⚠️ 토픽은 있으나 핵심 답·수치·절차 누락·얕음 / ❌ 위키에 없음.
4. 배치를 토픽 단위로 잘라 병렬 검증(각 에이전트가 관련 샤드 1~2개만 로드).
5. 확정 갭(⚠️·❌)은 출처 Tier(로컬 PDF=Tier1/2, 공식 웹=Tier2)를 지켜 보충 → 재검증.
```

- 범위(이번 라운드): REST/SOAP API · Connected App · Auth Provider · Named Credential · OAuth 플로우 · Apex Callout/REST · External Services · CORS · External Objects · Apex 시스템 인터페이스(Batchable·Schedulable·Queueable·Comparable·Callable·Mock).
- **제외**: Bulk API · Pub/Sub API(gRPC) — 별도 노트로 최근 검증됨.

---

## 라운드 1 결과 — 독립 생성 질문 70개 (2026-07-07)

| 배치 | 주제 | ✅ | ⚠️ | ❌ |
|---|---|---|---|---|
| A | REST API | 7 | 2 | – |
| B | SOAP API + Platform Events/CDC | 11 | – | – |
| C | Connected App / OAuth | 10 | – | – |
| D | Auth Provider / Named Credential | 7 | 1 | – |
| E | Callout / Custom REST / External Services / CORS / External Objects | 11 | 1 | – |
| F | Apex 시스템 인터페이스 | 8 | 2 | – |
| G | 아키텍처 / 어드민 크로스 | 5 | 3 | 2 |
| **합계** | | **59** | **9** | **2** |

## 라운드 2 결과 — 웹 실제 질문 33개 (Stack Exchange·Trailblazer·Reddit, URL 인용)

| 배치 | ✅ | ⚠️ | 대표 실제 에러/질문 |
|---|---|---|---|
| REST/SOAP | 4 | 4 | INVALID_SESSION_ID, sObject tree 본문, 버전 선택 |
| 인증/OAuth | 6 | 2 | invalid_grant 만료 토큰, Invalid JWT Signature |
| Callout/외부연동 | 8 | 1 | Unauthorized endpoint, uncommitted work, CORS 403, External Objects OData |
| Apex 인터페이스 | 4 | 4 | Too many queueable, cron `?`, Comparable, WebServiceMock |
| **합계** | **22** | **11** | |

**총계 103문항: 81✅ / 20⚠️ / 2❌** (중복 제외 시 고유 갭 13건)

### 진단 패턴
- **"무엇을/어떻게"(레퍼런스·시그니처·설정 경로)는 거의 완벽** — API 엔드포인트·수치·OAuth 정책·콜아웃 제약을 공식문서급으로 답한다.
- **갭은 두 축에 집중**: ① "언제 무엇을 고르나"(아키텍처 결정) ② "운영·거버넌스"(라이선스·모니터링·멱등성·에러 진단). 지식 베이스가 "사전"으로는 성숙, "설계 안내서"로는 성장 중이었다.

---

## 확정 갭 → 보충 이력 (2026-07-07 세션, 13건 전부 처리)

| # | 갭(질문) | 처리 | 대상 노트 | 출처 |
|---|---|---|---|---|
| 1 | WebServiceMock(SOAP 콜아웃 테스트) 부재 | **신규** | [[WebServiceMock]] (+[[HttpCalloutMock]] 교차링크) | apex PDF Tier2 |
| 2 | Comparable 직접 구현 코드 없음 | augment | [[Comparator 인터페이스]] | apex PDF |
| 3 | Scheduled cron `?` 상호배타 규칙 | augment | [[Scheduled Apex]] | apex PDF |
| 4 | Batch Stateful의 static 변수 함정 | augment | [[Batch Apex]] | apex PDF |
| 5 | REST 호출 전제/API Enabled 최소권한 | augment | [[REST API]] | api_rest.pdf |
| 6 | REST 버전 하위호환/은퇴(410 GONE) | augment | [[REST API]] | api_rest.pdf |
| 7 | sObject Tree 요청 본문 예시(200·5레벨) | augment | [[REST API]] | api_rest.pdf |
| 8 | INVALID_SESSION_ID(401) 실제 원인 | augment | [[REST API]] | api_rest.pdf + 웹 |
| 9 | invalid_grant 만료 토큰(5-grant 한도·비번변경 폐기) | augment | [[Connected App (연결된 앱) — OAuth 클라이언트]] | help.salesforce.com |
| 10 | Invalid JWT Signature / 외부키 JKS import | augment | [[Connected App (연결된 앱) — OAuth 클라이언트]] | help.salesforce.com |
| 11 | Per-User vs Named Principal + mutual TLS/two-way SSL | augment | [[Named Credential]] · [[Secure Communications (TLS)]] | 공식 웹 |
| 12 | Salesforce Connect vs 복제 결정표 + OData 노코드/트러블슈팅 | augment | [[External Objects]] | 공식 웹 |
| 13 | 미들웨어 vs point-to-point + 재시도·멱등성 / 통합 사용자 라이선스 | **신규 2** | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] · [[Integration User & API-Only User (통합 사용자)]] | architect.salesforce.com |

### 남은 백로그
- **Event Monitoring / EventLogFile 전용 노트** (라운드1 Q65) — API usage 모니터링·`/limits`·Setup 위치는 이미 [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]]에 있으나, EventLogFile(ApiEvent·LoginEvent 로그) 콘텐츠는 별도 이니셔티브 규모라 미착수.
- SOAP `sessionId`를 REST Bearer로 재사용 가능 여부의 명시 서술(웹 REST Q5) — INVALID_SESSION_ID 보충으로 대부분 해소, 경미.

---

---

## 라운드 3 결과 — ERP·미들웨어·포맷·벤더 통신 (2026-07-07, 59문항)

더 구체적/벤더 지향 토픽. 독립 질문 35 + 웹 실제 질문 24.

| 배치 | ✅ | ⚠️ | ❌ | 주제 |
|---|---|---|---|---|
| R3-A | 7 | 1 | 1 | Named Credential(심화) · Remote Site 등록 |
| R3-B | 4 | 3 | 2 | Middleware · WSDL 등록 |
| R3-C | 7 | 2 | – | JSON 형식 · XML 형식 |
| R3-D | 2 | 5 | 1 | ERP/벤더 · 운영 |
| 웹 WSDL/JSON/XML | 3 | 5 | – | 실제 Q&A |
| 웹 NamedCred 콜아웃 | 6 | 1 | 1 | 실제 Q&A |
| 웹 미들웨어/ERP | 4 | 3 | 1 | 실제 Q&A |
| **합계** | **33** | **20** | **6** | |

**누적 3라운드 총계: 162문항 (114✅ / 40⚠️ / 8❌)**

### 라운드 3 진단
- **최근 보충 노트가 앵커로 작동** — JSON·Named Credential·Dom·통합 아키텍처 결정이 실제 질문의 진입점 역할을 잘 했다(라운드1 보충 효과 확인).
- **갭 3축**: ① WSDL2Apex **소비**(위키가 "노출"만 강했음) ② 스트리밍 XML(DOM만 있었음) ③ 서드파티 제품(SAP·Informatica) 연동.
- **정확성 버그 1건 발견·정정** — 웹 검증이 `wsdl2apex-guide.md`의 "RPC/encoded 지원" 오기를 잡음(공식은 document literal wrapped 전용). 커버리지 검증이 정확성 감사를 겸했다.

### 라운드 3 확정 갭 → 보충 이력 (13갭, 7클러스터 전부 처리)

| # | 갭 | 처리 | 대상 노트 | 출처 |
|---|---|---|---|---|
| R3-1 | WSDL2Apex 외부 SOAP 소비(스텁 구조·미지원 스키마·1M자 한도) | **신규** | [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]] | apex PDF |
| R3-2 | `wsdl2apex-guide` rpc "지원" 오기 | **정정** | AgentSkills/…/wsdl2apex-guide.md | apex PDF |
| R3-3 | 스트리밍 XML(XmlStreamReader/Writer 메서드 전수) | **신규** | [[XmlStreamReader·XmlStreamWriter (스트리밍 XML)]] | apex PDF |
| R3-4 | Named Credential Custom 인증 프로토콜·named param + Profile 배포 함정 | augment | [[Named Credential]] | 공식 웹 |
| R3-5 | 아웃바운드 IP allowlist·Private Connect | **신규** | [[아웃바운드 연결 - IP allowlist·Private Connect]] | help.salesforce.com |
| R3-6 | SAP·Oracle·NetSuite·Informatica·MuleSoft 연동 라우팅 + API-led + 실시간/배치 | **신규** | [[ERP·서드파티 제품 연동 지도]] | architect + 벤더(Tier3 격리) |
| R3-7 | JSON 방어적 역직렬화(instanceof·TypeException·typed List) | augment | [[JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌]] | apex PDF |
| R3-8 | Outbound Message vs PE vs REST 비교·실시간vs배치·미들웨어 한도관리 | augment | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] | architect |

### 라운드 3 남은 백로그
- **Event Monitoring / EventLogFile 전용 노트**(라운드1부터 이월) — 별도 이니셔티브 규모.
- **통합 감사 how-to**(Setup Audit Trail·Field History·Login History로 "누가 무엇을 sync") — 통합 사용자 노트에 개념은 있으나 도구별 절차는 미보강.
- **서드파티 제품 내부 설정**(MuleSoft API-led 상세·Informatica IICS 커넥터 옵션·SAP PI/PO) — Salesforce 지식베이스 성격상 **의도된 경계**. [[ERP·서드파티 제품 연동 지도]]가 포인터로 라우팅, 상세는 각 벤더 문서.

---

## 재실행 방법 (질문을 바꿔 재검증)

```text
// 다음 라운드 실행 절차
1. 이 노트의 "검증 방법론"을 그대로 지킨다(위키 역산 금지).
2. 질문 세트를 새로 만든다:
   · 관점 태그 [A]dmin [D]ev [Arch] 를 섞는다.
   · 웹에서 최신 실제 Q&A를 다시 수집한다(에러 문자열·버전 함정 위주).
3. 토픽별 배치로 나눠 검증 에이전트에 위임:
   "위키 네비게이션(라우터→샤드→파일)만으로 답이 나오는가"를 ✅/⚠️/❌ + 파일:섹션 인용으로.
4. 결과표를 이 노트에 라운드로 누적하고, 새 갭은 위 "보충 이력" 표에 이어 기록.
5. 보충은 writer(콘텐츠) → index-manager(탐색 파일) → lint/qa 순서. writer는 탐색 파일 수정 금지.
```

- 직전 질문 세트 전문은 세션 작업 파일(`scratchpad/interface_qset.md`)에 v2로 보존. 다음 라운드는 v3로 교체.

---

## 관련 노트
- [[통합 MOC]] — 통합 도메인 인덱스(방향·동기/비동기)
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — 이번 검증에서 신설된 아키텍처 결정 노트
- [[Integration User & API-Only User (통합 사용자)]] — 통합 실행 주체 설계
- [[WebServiceMock]] — 라운드1에서 신설된 SOAP 콜아웃 테스트 노트
- [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]] · [[XmlStreamReader·XmlStreamWriter (스트리밍 XML)]] · [[아웃바운드 연결 - IP allowlist·Private Connect]] · [[ERP·서드파티 제품 연동 지도]] — 라운드3 신설 노트
- [[REST API]] · [[Connected App (연결된 앱) — OAuth 클라이언트]] · [[Named Credential]] · [[External Objects]] — 보충된 핵심 노트
