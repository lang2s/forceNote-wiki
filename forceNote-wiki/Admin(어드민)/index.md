---
tags: [index, admin, salesforce-basics]
created: 2026-05-19
---

# Admin(어드민) — 로컬 인덱스

> Salesforce 플랫폼 기초 — 어드민·개발자가 알아야 할 핵심 개념, 네비게이션, 보안 인증

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce 네비게이션]] | App Launcher, 탐색바, 전역 검색, 리스트뷰, 레코드 페이지 구조 | #navigation |
| [[Salesforce ID 인증]] | MFA, Authenticator App, 인증 방식 종류와 설정 | #security |
| [[Data Loader]] | CSV 대량 insert/update/upsert/delete/export, Bulk API, CLI 배치(Windows), 최대 1.5억 건 | #data |
| [[Data Import Wizard]] | Setup 웹 마법사 — 표준/커스텀 오브젝트 CSV 임포트(추가·업데이트·중복 매칭), 최대 5만 건, Data Loader의 웹 보완재 | #data |
| [[State and Country Picklist]] | AddressSettings 메타데이터 타입 — 국가/주 피클리스트 구성, isoCode/integrationValue, Metadata API 편집 | #metadata-api |
| [[조직 전체 공유 기본값(OWD)과 공유 규칙]] | OWD로 레코드 기본 접근 수준을 정하고 공유 규칙(소유 기반/기준 기반)으로 접근 확대, Sharing Settings 설정법 | #security |
| [[Approval Process (승인 프로세스)]] | 레코드 승인 단계·승인자·시점별 자동 액션을 정의하는 선언적 승인 워크플로 — Jump Start/Standard 마법사, 용어 15종, 액션 4타입, Flow 대안 | #automation |

---

## 빠른 선택

- Lightning Experience 화면 구조 이해? → [[Salesforce 네비게이션]]
- MFA 설정 방법? → [[Salesforce ID 인증]]
- 대량 데이터 적재·내보내기? → [[Data Loader]]
- 웹 마법사로 CSV 데이터 임포트(최대 5만 건)? → [[Data Import Wizard]]
- OWD·공유 규칙으로 레코드 접근 설계? → [[조직 전체 공유 기본값(OWD)과 공유 규칙]]
- 레코드 승인 워크플로(단계·승인자·자동 액션) 만들기? → [[Approval Process (승인 프로세스)]]
- 국가/주 피클리스트를 메타데이터로 설정? → [[State and Country Picklist]]
- Salesforce란 무엇인가? → [[Architecture(아키텍처)/Salesforce 플랫폼 개요]]

---

## 관련 폴더

- 플랫폼 개요 → [[Architecture(아키텍처)/index|Architecture(아키텍처)]]
- 보안 설계 → [[Apex/Security(보안)/index|Security(보안)]]
