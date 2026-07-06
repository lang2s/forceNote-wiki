---
tags: [index, apex, data, dml]
created: 2026-05-17
updated: 2026-05-22
---

# Data(데이터) — 로컬 인덱스

> DML 조작, 페이지네이션, Namespace 레퍼런스. SOQL/SOSL은 [[Apex/SOQL(SOQL)/index|SOQL(SOQL)]] 폴더 참조.

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[DML 패턴]] | insert as user/system, Database.*(accessLevel), 부분 성공 | #pattern |
| [[PagedResult 패턴]] | 페이지네이션 DTO, LIMIT+OFFSET, ?? null coalescing | #pattern |
| [[BusinessHours 패턴]] | BusinessHours.diff(), 영업시간 경과 계산, SLA 초과 여부 | #pattern |
| [[Database Namespace 상세]] | SaveResult/UpsertResult/MergeResult/Cursor/PaginationCursor/QueryLocator/DMLOptions/LeadConvert 전체 | #reference |
| [[Search Namespace]] | SOSL Apex API — Search.find(), Search.suggest(), SearchResult, KnowledgeSuggestionFilter | #reference |
| [[FormulaEval Namespace]] | Formula.builder() 동적 수식 평가 — evaluate(), getReferencedFields(), 템플릿 모드 | #reference |
| [[Reports Namespace]] | Apex에서 보고서 실행·조회 — ReportManager.runReport/runAsyncReport, FactMap, ReportMetadata | #reference |
| [[Datacloud Namespace]] | Duplicate Management API — FindDuplicates/FindDuplicatesByIds, DuplicateResult, MatchRecord (Salesforce Data Cloud 제품과 무관) | #reference |
| [[Wave Namespace]] | CRM Analytics Analytics SDK — QueryBuilder/QueryNode/ProjectionNode로 SAQL 쿼리 빌드·실행, Templates 조회 | #reference |
| [[Apex에서 Salesforce Files 다루기 (ContentVersion·ContentDistribution)]] | ContentVersion으로 파일 생성·ContentDocumentLink로 레코드 첨부·ContentDistribution으로 인증 없는 공개 URL 배포 — VersionData/PathOnClient/ShareType/Visibility | #pattern |
| [[Mixed DML 제약과 우회]] | setup 오브젝트(User·PermissionSet)와 일반 오브젝트를 한 트랜잭션에서 DML 시 MIXED_DML_OPERATION — System.runAs(테스트)·@future/Queueable(런타임) 분리 우회 | #pattern |
| [[JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌]] | JSON 필드명이 Apex 예약어(from·case·currency)일 때 우회 4패턴 + System.JSON/JSONParser/JSONGenerator/JSONToken 전수 레퍼런스 | #reference |

---

## 빠른 선택

- SOQL/SOSL 쿼리·패턴? → **[[Apex/SOQL(SOQL)/index|SOQL(SOQL) 폴더]]**
- 레코드 삽입/수정/삭제? → [[DML 패턴]]
- 목록 페이지에 페이지네이션? → [[PagedResult 패턴]]
- SLA 경과 시간 / 영업시간 기준 계산? → [[BusinessHours 패턴]]
- DML 결과 처리, Cursor, LeadConvert 상세? → [[Database Namespace 상세]]
- SOSL 검색, 자동완성 제안? → [[Search Namespace]]
- 포뮬러 필드 값을 DML 없이 재계산? → [[FormulaEval Namespace]]
- Apex에서 보고서 실행·결과 분석? → [[Reports Namespace]]
- 중복 레코드 탐지·차단 처리? → [[Datacloud Namespace]] (Duplicate Management)
- DML 에러에서 중복 정보 추출? → [[Datacloud Namespace]] → DuplicateResult
- Apex에서 SAQL 쿼리로 CRM Analytics 데이터 조회? → [[Wave Namespace]] → QueryBuilder.load
- CRM Analytics 집계(sum/avg/count)를 Apex로? → [[Wave Namespace]] → ProjectionNode
- CRM Analytics 템플릿 목록 Apex로 가져오기? → [[Wave Namespace]] → Templates.getTemplates
- Apex로 레코드에 파일 첨부·공개 링크 생성? → [[Apex에서 Salesforce Files 다루기 (ContentVersion·ContentDistribution)]]
- MIXED_DML_OPERATION 에러가 날 때 / User·Account를 같이 insert? → [[Mixed DML 제약과 우회]]
- JSON 필드명이 예약어(from·case·currency)라 래퍼로 못 받을 때? → [[JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌]]

## 보안 연동

SOQL 보안 → [[WITH USER_MODE]] | DML 보안 → [[Safely]] (Security(보안) 폴더)
