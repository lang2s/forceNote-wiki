---
tags: [admin, customization, custom-labels, localization, translation]
source: help.salesforce.com (Salesforce Help — Custom Labels; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
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

## 생성 절차

1. Setup → Quick Find에 **"Custom Labels"** 입력 → **Custom Labels** 선택
2. **New**를 눌러 새 레이블 생성 — name, value, categories 지정
3. **Translation Workbench**로 각 언어별 번역을 추가

> 레이블 개수·텍스트 길이 등 세부 한도는 공식 문서를 참조한다: [Custom Labels (help.salesforce.com)](https://help.salesforce.com/s/articleView?id=platform.cl_about.htm&type=5)

## 구조 예시

```
// 구조 예시 — Custom Labels(실제 동작 코드 아님)
Setup → Custom Labels → New(name·value)
   Translation Workbench: 언어별 번역
참조: Apex($Label)·Visualforce·LWC·Flow  (텍스트 하드코딩 대신 → 지역화)
```

## 관련 노트
- [[Custom Settings (커스텀 설정)]] — 또 다른 커스텀 구성(텍스트 vs 데이터).
