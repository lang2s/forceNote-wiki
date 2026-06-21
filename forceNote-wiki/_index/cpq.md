---
tags: [index, search, navigation, cpq]
created: 2026-06-21
---

# SEARCH INDEX — CPQ(견적) (Salesforce CPQ Developer Guide v65.0 Winter '26)
> Salesforce CPQ(managed package, `SBQQ.*` / Advanced Approvals `SBAA.*`) 개발자 API — 데이터 모델·Quote/Configuration/Contract API·기타 API·플러그인 6노트
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
>
> ⚠️ 이 CPQ는 **managed package 제품**(`SBQQ` 네임스페이스)이다. platform-native 후속 제품인 **RLM(Revenue Lifecycle Management / Revenue Cloud, `PlaceQuote`·`RevSalesTrxn` 네임스페이스)과는 별개 제품** — 혼동 주의.

---

## API Models — 데이터 모델 클래스

| 키워드 | 파일 |
|---|---|
| QuoteModel, ProductModel, ConfigurationModel, OptionModel, QuoteLineModel, QuoteLineGroupModel, QuoteProposalModel, QuoteTermModel, ProductOptionModel, SummaryVariableModel, 11개 모델 클래스, SBQQ 모델 클래스, CPQ 데이터 모델, 견적 라인 모델, 번들 구성 모델, CPQ API 모델 만들기, QuoteModel 필드가 뭐야 | `CPQ(견적)/CPQ API Models.md` |

## Quote API — 견적 저장·계산·읽기·검증·제품추가·제안서·약관

| 키워드 | 파일 |
|---|---|
| Save Quote API, Calculate Quote API, Read Quote API, Validate Quote API, Add Products API, Read Product API, Create and Save Quote Proposal API, Quote Term Reader API, QuoteSaver, QuoteCalculator, QuoteReader, QuoteValidator, QuoteProductAdder, ProductLoader, SBQQ.ServiceRouter, CalculateCallback, CPQ 견적 저장 API, CPQ 견적 계산 API, CPQ REST API, CPQ 견적을 API로 저장하려면, ServiceRouter saver loader reader 차이 | `CPQ(견적)/CPQ Quote API.md` |

## Configuration·Contract API — 번들 구성·계약 수정/갱신

| 키워드 | 파일 |
|---|---|
| Configuration Loader API, Configuration Load Rule Executor API, Configuration Validator API, Contract Amender API, Contract Renewer API, SBQQ.ConfigAPI, SBQQ.ContractManipulationAPI, parentProduct 중첩 번들, amendment quote, renewal quote, CPQ 번들 구성 API, CPQ 계약 수정 갱신 API, 계약 수정, 계약 갱신, product rules 검증 | `CPQ(견적)/CPQ Configuration·Contract API.md` |

## 기타 API — Document·Router·Quickstart·Triggers·Approvals

| 키워드 | 파일 |
|---|---|
| Generate Quote Document API, QuoteDocumentAPI.SaveProposal, GenerateQuoteProposal, SBQQ.ServiceRouter, Service Router, CPQ API Quickstart, Disable CPQ Triggers, SBQQ.TriggerControl, TriggerControl, Advanced Approvals API, Reject Approval API, SBAA.ApprovalRestApiProvider, 견적서 문서 생성, CPQ 트리거 비활성화, CPQ 승인 API, 견적 문서 PDF 생성, CPQ 견적서 PDF 만드는 API, CPQ 트리거 끄는 법, CPQ 승인 거부 API | `CPQ(견적)/CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals.md` |

## JavaScript Quote Calculator Plugin (JSQCP)

| 키워드 | 파일 |
|---|---|
| JavaScript Quote Calculator Plugin, Quote Calculator Plugin, JSQCP, onInit, onBeforeCalculate, onBeforePriceRules, onAfterPriceRules, onAfterCalculate, isFieldVisible, isFieldEditable, JavaScript Page Security Plugin, isFieldVisibleForObject, isFieldEditableForObject, Legacy Page Security Plugin, PageSecurityPlugin2, JSForce conn, CPQ 커스텀 계산, CPQ 견적 계산 플러그인, CPQ 필드 가시성, CPQ 필드 편집잠금, CPQ에서 계산 커스터마이즈, onAfterCalculate가 뭐야, CPQ 견적 필드 숨기기 | `CPQ(견적)/JavaScript Quote Calculator Plugin.md` |

## 기타 Plugins — Search·Recommended·Configurator·전자서명 등

| 키워드 | 파일 |
|---|---|
| Product Search Plugin, Recommended Products Plugin, Product Recommendation Plugin, External Configurator, Document Store Plugin, Electronic Signature Plugin, Custom Action Plugin, Legacy Quote Calculator Plugin, Guided Selling Plugin, SBQQ.ProductSearchPlugin, 9개 플러그인, CPQ 플러그인, 제품 검색 플러그인, 제품 추천 플러그인, 외부 컨피규레이터, 전자서명 플러그인, 가이드 셀링, CPQ 확장 지점 | `CPQ(견적)/CPQ Plugins — Search·Recommended·Configurator·기타.md` |
