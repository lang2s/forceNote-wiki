---
tags: [admin, customization, custom-labels, localization, translation]
source: help.salesforce.com (Salesforce Help — Custom Labels; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · help.salesforce.com — Translation Workbench(platform.workbench.htm, Tier 2, 접속 2026-07-04)
official_doc: https://help.salesforce.com/s/articleView?id=platform.cl_about.htm&type=5
created: 2026-07-03
aliases: [Custom Labels, 커스텀 레이블, 사용자 정의 레이블, Localization, 지역화, Translation]
---

# Custom Labels (커스텀 레이블)

> 앱에서 참조하는 커스텀 텍스트로, Salesforce가 지원하는 어떤 언어로도 **번역**할 수 있다. Apex·Visualforce·LWC·Flow에서 텍스트를 하드코딩하지 않고 참조해 지역화한다.

---

## 개념

**Custom label**은 앱이 접근할 수 있는 **커스텀 텍스트**다. 가장 큰 장점은 그 텍스트를 **Salesforce가 지원하는 어떤 언어로도 번역**할 수 있다는 것이다 — 즉 각 사용자에게 자신의 언어로 표시된다.

용도는 **지역화(localization)**다. Apex·Visualforce·Lightning Web Component·Flow 등에서 화면에 표시할 문자열을 코드에 하드코딩하는 대신, custom label을 참조하도록 만든다. 그러면 한 번 정의한 텍스트를 여러 언어로 번역해 다국어 사용자를 지원할 수 있다.

## ⚠️ 전제조건 — 번역하려면 Translation Workbench 먼저 활성화

Custom label을 여러 언어로 번역하려면 아래 3단계 절차의 **3단계(번역 추가)에 앞서 Translation Workbench가 활성화돼 있어야 한다.** Translation Workbench는 **기본 비활성** 상태라, 활성화하지 않으면 번역 탭 자체가 없어 3단계에서 막힌다.

1. Setup → **Translation Workbench** → **Translation Settings** → **Enable**
2. 지원할 언어를 **추가하고 활성(Active)** 상태로 만든다 — 언어를 활성화하지 않으면 해당 언어의 번역 UI가 열리지 않는다.

> 활성화·언어 추가 상세: [Translation Workbench (help.salesforce.com)](https://help.salesforce.com/s/articleView?id=platform.workbench.htm&type=5)

## 생성 절차

1. Setup → Quick Find에 **"Custom Labels"** 입력 → **Custom Labels** 선택
2. **New**를 눌러 새 레이블 생성 — name, value, categories 지정
3. **Translation Workbench**로 각 언어별 번역을 추가 (위 "전제조건" — Translation Workbench 활성화 + 언어 활성이 선행돼야 함)

## 한도

| 항목 | 한도 |
|---|---|
| org당 custom label 개수 | **5,000개** |
| label 하나의 텍스트 길이 | **각 1,000자** |

> 세부 한도 원문: [Custom Labels (help.salesforce.com)](https://help.salesforce.com/s/articleView?id=platform.cl_about.htm&type=5)

## 구조 예시

```
// 구조 예시 — Custom Labels(실제 동작 코드 아님)
Setup → Custom Labels → New(name·value)
   Translation Workbench: 언어별 번역
참조: Apex($Label)·Visualforce·LWC·Flow  (텍스트 하드코딩 대신 → 지역화)
```

## 관련 노트
- [[Custom Settings (커스텀 설정)]] — 또 다른 커스텀 구성(텍스트 vs 데이터).
