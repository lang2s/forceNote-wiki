---
tags: [index, field-service, 현장서비스]
created: 2026-06-23
---

# Field Service(현장서비스) — 로컬 인덱스

> Salesforce Field Service(FSL) 개발자 가이드 기반 — 멀티플랫폼·모바일 서비스 운영의 데이터 모델·오브젝트 레퍼런스·API·Apex·모바일 앱.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Field Service 개요와 데이터 모델]] | Field Service 개요 + 6개 데이터 모델(Core / Inventory / Preventive Maintenance / Product Service Campaign / Warranty / Pricing)의 오브젝트 관계도(ER) | #field-service |
| [[Field Service REST API]] | Field Service 전용 REST 엔드포인트 — Field Service Flow / Mobile Settings / Service Report Template / Appointment Bundling(Create·Unbundle·Start Batch 등 6 서브 리소스) | #field-service #rest-api |
| [[Field Service Metadata·Tooling API]] | Metadata API 타입(FieldServiceSettings · Skill · TimeSheetTemplate)과 Tooling API 오브젝트(CleanRule · TimeSheetTemplate) 전체 필드·enum 레퍼런스 | #field-service #metadata-api #tooling-api |
| [[FSL Apex Namespace]] | managed package `FSL` Apex 네임스페이스 19개 클래스 전수 — appointment booking·scheduling·optimization(OAAS)·recurring appointment | #field-service #apex-namespace |
| [[Field Service Custom Triggers·Code Examples]] | managed package 24개 트리거 동작 가이드(전수) + Apex 코드 예제 4개(서비스 리포트·작업오더 생성·디스패처 콘솔 커스텀 액션 등) | #field-service #apex-trigger |
| [[Field Service Mobile App (LWC)]] | 모바일 앱 LWC 개발·디버그, Document Builder 커스텀 컴포넌트·딥링킹·플러그인(바코드 스캐너·AR SpaceCapture) | #field-service #mobile #lwc |

---

## 빠른 선택

- Field Service가 뭔지·어떤 오브젝트로 구성되는지 알고 싶다? → [[Field Service 개요와 데이터 모델]]
- work order / service appointment / inventory 객체 관계도가 필요하다? → [[Field Service 개요와 데이터 모델]]
- Appointment Bundling·Field Service Flow를 REST로 호출하고 싶다? → [[Field Service REST API]]
- FieldServiceSettings·Skill·TimeSheetTemplate 메타데이터/툴링 필드가 필요하다? → [[Field Service Metadata·Tooling API]]
- Apex로 예약·스케줄링·최적화(OAAS)를 호출하고 싶다? → [[FSL Apex Namespace]]
- managed package 트리거 동작·Apex 코드 예제가 필요하다? → [[Field Service Custom Triggers·Code Examples]]
- 모바일 앱 LWC·딥링킹·플러그인을 개발하고 싶다? → [[Field Service Mobile App (LWC)]]

---

## 관련 폴더

- 예약(부킹) 스케줄링 → [[Scheduler(스케줄러)/index|Scheduler(스케줄러)]] (ServiceResource·ServiceTerritory·OperatingHours·WorkType 등 객체 공유)
- 옴니채널 라우팅 → [[Service(서비스)/index|Service Cloud]]
