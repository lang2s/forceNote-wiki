---
tags: [admin, org-setup, company-information, fiscal-year, org-defaults]
source: help.salesforce.com (Salesforce Help — Company Information / Set the Fiscal Year; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.setting_the_fiscal_year.htm&type=5
created: 2026-07-03
aliases: [Company Information, 회사 정보, Fiscal Year, 회계연도, Standard Fiscal Year, Custom Fiscal Year, Org Default]
---

# Company Information & Fiscal Year (회사 정보·회계연도)

> **Company Information** 페이지는 조직의 기본값(default locale·language·timezone·통화)·라이선스·스토리지·조직 ID를 담는 중앙 설정. **Fiscal Year**는 예측·리포트의 기간 기준을 정한다(표준/커스텀).

---

## Company Information — 조직 수준 기본값의 중앙 페이지

**Setup → Company Information** 페이지는 조직 전체에 적용되는 기본값과 정보를 한곳에서 보고·설정하는 중앙 페이지다. 여기에 담기는 항목:

- **Primary contact** — 조직의 대표 연락처.
- **Default locale · language · time zone · 통화(currency)** — 새 사용자·레코드에 적용되는 조직 기본값. (locale은 날짜·숫자 서식, language는 UI 언어, time zone은 기본 시간대에 영향.)
- **User license · feature license** — 조직에서 사용 중인 라이선스 종류와 수량.
- **데이터/파일 storage** — 사용 중인 데이터 스토리지·파일 스토리지 용량.
- **조직 ID(Organization ID)** — 조직을 고유하게 식별하는 ID.

이 페이지의 값들은 조직 전역 기본값이므로, 개별 사용자·레코드 수준에서 별도로 재정의되지 않는 한 조직 전체 동작의 기준선이 된다.

## Fiscal Year (회계연도)

회계연도 설정은 **Forecasting(예측)·리포트의 기간 기준**에 영향을 준다. 두 가지 유형이 있다.

### Standard Fiscal Year (표준 회계연도)

- **Gregorian(그레고리력) 달력을 그대로 따르는** 회계연도.
- 다만 **회계연도 시작 월(start month)을 변경**할 수 있다. (예: 1월이 아닌 다른 월을 회계연도 시작으로 지정.)

### Custom Fiscal Year (커스텀 회계연도)

- 표준 회계연도를 따르지 않는 조직이, **더 복잡한 회계연도 구조(분기·기간 정의)**를 만들 때 **활성화**한다.
- 활성화하면 분기·기간을 조직의 회계 구조에 맞게 정의할 수 있다.

> 커스텀 회계연도의 분기·기간 세부 설정은 이 노트 범위 밖 — 공식 문서(위 `official_doc`) 참조.

### 설정 경로

```
// 구조 예시 — Company Info & Fiscal Year(실제 동작 코드 아님)
Setup → Company Information: default locale·language·timezone·통화 · 라이선스 · storage · 조직 ID
Setup → Fiscal Year:
   Standard(시작 월 변경)  또는  Custom(복잡한 분기·기간 구조)
   → Forecasting·리포트 기간 기준에 영향
```

- Company Information: **Setup → Company Information**.
- Fiscal Year: **Setup → Quick Find "Fiscal Year" → Fiscal Year → Standard Fiscal Year 또는 Custom Fiscal Year 선택**.

## 관련 노트
- [[Collaborative Forecasts (예측)]] — 회계연도가 예측·리포트 기간의 기준이 됨(fiscal year 설정이 예측 기간을 규정).
