---
tags: [index, agent-skill, sf-skills, samples]
created: 2026-06-27
---

# sf-skills 샘플 앱 (Reference Apps) — 로컬 인덱스

> `forcedotcom/sf-skills` 레포의 `samples/` 폴더에 동기화된 **5종 공식 레퍼런스 앱**의 홈. 모두 동일한 **부동산/임대 관리(property rental) 도메인**을 서로 다른 전달 방식·대상으로 구현했다 — UI Bundle(b2e 직원·b2x 외부), WebApp(b2e·b2x experimental), Native Mobile. 에이전트 스킬이 실제로 생성하는 앱이 어떤 모습인지 보여주는 참조 구현이다.

**상위:** [[../index|AgentSkills(에이전트스킬)]]

---

## 파일 목록

| 파일 | 한 줄 요약 |
|---|---|
| [[sf-skills 샘플 앱 - 개요]] | 허브 — 5종 레퍼런스 앱(ui-bundle b2e/b2x, webapp b2e/b2x, native mobile)의 전달 방식·대상·구성 비교 |
| [[sf-skills 샘플 앱 - Apex 패턴]] | 트리거 핸들러 2종(자동 워커 배정·권한셋 부여) + B2X 헤드리스 인증 REST 엔드포인트 5종(Site 기반) |
| [[sf-skills 샘플 앱 - 데이터 모델]] | 17개 커스텀 객체·127개 커스텀 필드 — Property__c 허브 + Lease/Tenant/Maintenance 도메인 스키마 |
| [[sf-skills 샘플 앱 - React UI·GraphQL 패턴]] | UI Bundle 안의 Vite + React + TypeScript SPA 구조 + GraphQL(Data SDK)로 조직 데이터 조회 패턴 |

---

## 빠른 선택

- 어떤 샘플 앱들이 있고 뭐가 다른지? → [[sf-skills 샘플 앱 - 개요]]
- 트리거 핸들러·헤드리스 인증 Apex 코드? → [[sf-skills 샘플 앱 - Apex 패턴]]
- 커스텀 객체·필드 스키마(Property__c·Tenant__c·Lease__c)? → [[sf-skills 샘플 앱 - 데이터 모델]]
- React/UI Bundle 프론트엔드 구조·GraphQL 데이터 접근? → [[sf-skills 샘플 앱 - React UI·GraphQL 패턴]]

---

## 관련 폴더

- 샘플 앱을 생성하는 에이전트 스킬 라이브러리 → [[../sf-skills/index|sf-skills 카탈로그]]
