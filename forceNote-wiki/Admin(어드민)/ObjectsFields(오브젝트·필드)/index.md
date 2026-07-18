---
tags: [index, admin, objects-fields, customization]
created: 2026-07-18
---

# ObjectsFields(오브젝트·필드) — 로컬 인덱스

> 오브젝트·필드 커스터마이제이션 — 커스텀 오브젝트/필드·피클리스트·커스텀 설정/레이블·필드셋·룩업 필터·수식·롤업·레코드 타입·스키마 빌더·한도

**상위:** [[Admin(어드민)/index]] | [[Salesforce 어드민 종합 개요]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] | Object Manager로 커스텀 오브젝트·필드 생성 | #customization |
| [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]] | 피클리스트·전역 값 집합·종속 피클리스트 | #customization |
| [[Custom Settings (커스텀 설정)]] | List vs Hierarchy 커스텀 설정(캐시 접근) | #customization |
| [[Custom Labels (커스텀 레이블)]] | 번역 가능한 커스텀 텍스트 | #customization |
| [[Field Sets (필드 집합)]] | 필드를 논리적으로 묶어 UI(VF·LWC·Apex)가 참조 — 관리자가 필드셋에 추가/제거만으로 코드 수정 없이 화면 노출 필드 변경 | #customization |
| [[Lookup Filters (룩업 필터)]] | 관계 필드(lookup·master-detail)에서 후보 레코드를 조건으로 제한 — Required/Optional·$Source·종속 룩업·참조 무결성 | #customization |
| [[Object & Field Limits (오브젝트·필드 한도)]] | 에디션별 정적 설정 한도(오브젝트당 커스텀 필드 900·관계 40·Roll-Up 25 등) — 한도 수치 레퍼런스 | #customization #reference |
| [[필드 타입 선택 가이드 (어드민 빌드 관점)]] | 커스텀 필드를 만들 때 어떤 타입을 고르나 — 용도·크기·변경 제약(전환 데이터 손실·인덱싱·Encrypted) 결정 가이드 | #customization #decision-guide |
| [[Formula 필드]] | 다른 필드로부터 값을 자동 계산하는 read-only 커스텀 필드 — cross-object formula(최대 10관계), Check Syntax, 계산 필드 | #customization |
| [[Roll-Up Summary 필드]] | master-detail의 master측에서 detail 레코드를 COUNT/SUM/MIN/MAX로 집계하는 필드 | #customization |
| [[Record Types (레코드 타입)]] | 사용자별 다른 비즈니스 프로세스·피클리스트 값·페이지 레이아웃 제공 — sales/support process, 레코드 타입 할당 | #customization |
| [[Schema Builder (스키마 빌더)]] | 오브젝트·관계를 시각적으로 보고 드래그앤드롭으로 커스텀 오브젝트·필드·관계 추가 — 데이터 모델 ERD | #customization |
