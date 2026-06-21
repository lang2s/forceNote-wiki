---
tags: [index, cpq, salesforce-cpq, sbqq]
created: 2026-06-21
---

# CPQ(견적) — 로컬 인덱스

> Salesforce CPQ(managed package, `SBQQ.*` / Advanced Approvals `SBAA.*`) 개발자 가이드(v65.0 Winter '26) 기반 — 11개 API 데이터 모델·Quote/Configuration/Contract API·기타 API(Document·Router·Quickstart·Triggers·Approvals)·플러그인(JSQCP + 9개) 6노트
>
> ⚠️ 이 CPQ는 **managed package 제품**(`SBQQ` 네임스페이스)이다. platform-native 후속 제품인 **RLM(Revenue Lifecycle Management / Revenue Cloud, `PlaceQuote`·`RevSalesTrxn` 네임스페이스)과는 별개 제품**이므로 혼동하지 않는다.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[CPQ API Models]] | CPQ API가 사용하는 11개 데이터 모델(QuoteModel·ProductModel·ConfigurationModel·OptionModel 등) 필드 전수 — org에 Apex 클래스로 직접 정의 | #reference |
| [[CPQ Quote API]] | Save/Calculate/Read/Validate/Add Products/Read Product/Quote Proposal/Quote Term Reader 8개 하위 API + `SBQQ.ServiceRouter` 단일 진입점·QuoteSaver·QuoteCalculator | #reference |
| [[CPQ Configuration·Contract API]] | Configuration Loader/Load Rule Executor/Validator(번들 구성·가격) + Contract Amender/Renewer(계약 수정·갱신) | #reference |
| [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]] | Generate Quote Document·ServiceRouter·API Quickstart·Disable Triggers(`SBQQ.TriggerControl`)·Advanced Approvals(`SBAA.*`) | #reference |
| [[JavaScript Quote Calculator Plugin]] | JSQCP 7개 메서드(onInit~onAfterCalculate)·Page Security Plugin·Legacy Apex — quote line editor 커스텀 계산·필드 가시성 제어 | #pattern |
| [[CPQ Plugins — Search·Recommended·Configurator·기타]] | 9개 플러그인(Product Search·Recommended Products·External Configurator·Legacy QCP·Guided Selling·Document Store·Custom Action·E-Signature) 인터페이스·시그니처 | #reference |

---

## 빠른 선택

- CPQ API에 넘길 데이터 모델(어떤 필드가 있나)·org에 만들 Apex 모델 클래스 → [[CPQ API Models]]
- 견적을 API로 저장·계산·읽기·검증·제품 추가·제안서 생성·약관 조회 / ServiceRouter saver·loader·reader → [[CPQ Quote API]]
- 제품 번들 구성·가격(Loader/Executor/Validator) / 계약 수정·갱신(amendment·renewal) → [[CPQ Configuration·Contract API]]
- 견적서 PDF 생성·트리거 비활성화·승인 거부·통합 Quickstart → [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]]
- quote line editor 계산 커스터마이즈·필드 숨김/잠금 (JavaScript) → [[JavaScript Quote Calculator Plugin]]
- 제품 검색·추천·외부 컨피규레이터·가이드 셀링·전자서명 등 확장 지점 → [[CPQ Plugins — Search·Recommended·Configurator·기타]]

---

## 관련 폴더

- platform-native 후속 제품 RLM/Revenue Cloud Apex(`PlaceQuote`·`RevSalesTrxn`) — 별개 제품, wiki에 별도 등재 시 참조
- B2B/B2C Commerce 주문·결제 → [[Commerce(커머스)/index|Commerce(커머스)]]
- 가격·견적 표준 sObject 인터페이스(PriceAdjustmentGroup·SalesTransaction) → [[sObject/index|sObject Reference]]
