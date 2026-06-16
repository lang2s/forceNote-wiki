---
tags: [release, winter_25]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf
aliases: [Winter '25, Winter25, v62.0, API 62, 윈터 25, 윈터25 릴리즈 노트, 2024 겨울 릴리즈, Winter 25 허브]
---

# Winter '25 릴리즈 노트

> API v62.0 | 출시: 2024년 10월
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm&release=248)

---

## ⭐ 주요 변경 (v62.0)

> 상세·코드·도메인별 항목은 아래 하위 노트 참조

```text
// PDF 원문 발췌 — salesforce_winter25_release_notes.pdf
Einstein Copilot for Salesforce is Now Agentforce
Einstein Copilot Studio is now Agent Studio
```

- **Agentforce 데뷔** — "Einstein Copilot for Salesforce is Now Agentforce" 리브랜드. Einstein Copilot이 **Agentforce**로 명칭 변경 (2.0 아님 — 단순 리브랜드). → [[Winter '25/Agentforce]]
- **Einstein Copilot Studio → Agent Studio** — 에이전트 구성 도구가 **Agent Studio**로 명칭 변경 ("Agentforce Studio" 아님). → [[Winter '25/Agentforce]]
- **LWC API v62.0** — class object 바인딩, `this.hostElement` / `this.style` 접근, JavaScript 파일 1MB 한도. → [[Winter '25/Development]]
- **Apex 변경** — Free-tier Event Monitoring, SOQL 변경, 외부 객체용 Mock SOQL(`SoqlStubProvider`). → [[Winter '25/Development]]
- **Service Protection Limit on Enqueued Apex Metadata API Deployments** — 대기 중인 Apex 기반 Metadata API 배포에 서비스 보호 한도 적용. → [[Winter '25/Platform]]
- **Platform API v21.0–30.0 폐기 연기** — 폐기 일정이 Summer '25로 연기됨. → [[Winter '25/Release Updates]]
- **Mobile Publisher for LWR GA** — Mobile Publisher의 LWR 지원 정식 출시(GA). → [[Winter '25/Platform]]

---

## 하위 노트 (도메인별 분리)

- [[Winter '25/Development]] — Apex·LWC·API 개발자 변경 (LWC v62.0, SoqlStubProvider, Free-tier Event Monitoring)
- [[Winter '25/Platform]] — Admin·Security·Flow·Mobile·DevOps (Metadata API 서비스 보호, Mobile Publisher LWR GA)
- [[Winter '25/Clouds]] — Sales·Service·Commerce·Analytics·Data Cloud·Experience Cloud GA/Beta
- [[Winter '25/Industries]] — Health·FSC·Public Sector·Manufacturing·Automotive·Communications
- [[Winter '25/Agentforce]] — Agentforce 리브랜드·Agent Studio·Agent Builder
- [[Winter '25/Release Updates]] — 강제 적용 항목 + 시점 매핑 (Platform API v21–30 폐기 연기 포함)
- [[Winter '25/index]] — 로컬 인덱스

---

## 섹션별 GA 하이라이트

| 도메인 | 하이라이트 (1줄) | 상세 |
|---|---|---|
| Development | LWC API v62.0 (class object 바인딩, this.hostElement/this.style, 1MB JS), SoqlStubProvider, Free-tier Event Monitoring | [[Winter '25/Development]] |
| Platform | Enqueued Apex Metadata API 배포 Service Protection Limit, Mobile Publisher for LWR GA | [[Winter '25/Platform]] |
| Clouds | Sales·Service·Commerce·Analytics·Data Cloud·Experience Cloud GA/Beta | [[Winter '25/Clouds]] |
| Industries | Health Cloud·FSC·Public Sector·Manufacturing·Automotive·Communications | [[Winter '25/Industries]] |
| Agentforce | Einstein Copilot → Agentforce 리브랜드, Copilot Studio → Agent Studio | [[Winter '25/Agentforce]] |
| Release Updates | Platform API v21.0–30.0 폐기 → Summer '25로 연기 | [[Winter '25/Release Updates]] |

---

## 관련 노트

- [[Release MOC]]
- [[Spring '25]] — 다음 릴리즈 (v63.0)
- [[Summer '24]] — 이전 릴리즈 (v61.0)
