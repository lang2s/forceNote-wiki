---
tags: [index, omnistudio, 옴니스튜디오]
created: 2026-07-13
---

# OmniStudio(옴니스튜디오) — 로컬 인덱스

> Salesforce OmniStudio — Industries 로우코드 개발 도구 모음. 4개 핵심 도구(OmniScript·FlexCard·Data Mapper(DataRaptor)·Integration Procedure) + 셋업/권한·메타데이터/DataPack 배포·Formula Functions 레퍼런스. Standard(플랫폼 통합) vs Managed Package(Vlocity 레거시) 두 런타임 병기.

**상위:** [[00 Home]]

> ⚠️ **OmniStudio ≠ Omni-Channel.** OmniStudio는 Industries 로우코드 앱 빌더(이 폴더), Omni-Channel(Service Cloud)은 작업 라우팅·큐잉 기능 → [[Service(서비스)/index|Service Cloud]].

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[OmniStudio 개요·오리엔테이션]] | OmniStudio 진입점 — 4개 도구, Standard vs Managed Package 런타임, OmniProcess·OmniUiCard·OmniDataTransformation sObject, 네이밍 규칙, Omni-Channel 구분 | #omnistudio |
| [[OmniStudio 셋업·권한·활성화]] | 권한 세트(Admin/User/Communities)·standard runtime·3개 보안 플래그(ApexClassCheck·EnforceDMFLSAndDataEncryption·EnableQueryWithFLS)·FLS·Fast Activation·Callable | #omnistudio #setup #security |
| [[OmniScript]] | 가이드 프로세스 빌더 — OmniProcess, 엘리먼트 카탈로그(input 21·action 13·group 6·function 2), 커스텀 LWC, 다국어 | #omnistudio #omniscript |
| [[FlexCard]] | 카드 UI(OmniUiCard) — states 모델, display 요소 9·data source 10·action 7, 예약 이벤트 | #omnistudio #flexcard |
| [[Data Mapper (DataRaptor)]] | 데이터 변환 — 4개 타입(Extract/Turbo/Load/Transform), OmniDataTransformation, DRGlobal·executeDataMapper, REST API, 함수 | #omnistudio #datamapper #dataraptor |
| [[Integration Procedure]] | 서버사이드 오케스트레이션 — 액션 카탈로그 19·블록 4, 호출(Apex/REST/Flow/Batch), remote action, 캐싱 | #omnistudio #integration-procedure |
| [[OmniStudio 메타데이터·DataPack 배포]] | 배포 — Salesforce CLI(standard) vs Build Tool/DataPacks(managed), setup/non-setup 제약, LWC 배포, 네임스페이스/버전, Metadata API 네이밍 | #omnistudio #metadata #deploy |
| [[OmniStudio Formula Functions 레퍼런스]] | Formula 함수 54개(7 카테고리), 연산자, 우선순위, 데이터 타입 | #omnistudio #reference #formula |
| [[Enterprise Product Catalog (EPC) — 데이터 모델·명명·번들]] | Industries CPQ(CME) 제품 카탈로그 데이터 모델 — Product2 offer·AttributeMetadata·ProductChildItem 번들·명명 규칙·DataPack·120점 루브릭. 지식↔실행(sf-skill) 짝. (Calculation은 OMNISTUDIO-2b 후속) | #omnistudio #epc #industries-cpq |

---

## 빠른 선택

### 개요·시작
- OmniStudio가 뭔지·4개 도구가 어떻게 나뉘는지 알고 싶다? → [[OmniStudio 개요·오리엔테이션]]
- 권한·보안 플래그·활성화를 설정하고 싶다? → [[OmniStudio 셋업·권한·활성화]]

### 컴포넌트(도구)
- 다단계 가이드 폼/마법사를 만들고 싶다? → [[OmniScript]]
- 카드형 UI를 만들고 싶다? → [[FlexCard]]
- 데이터를 추출·변환·적재하고 싶다? → [[Data Mapper (DataRaptor)]]
- 서버측 통합·오케스트레이션 로직이 필요하다? → [[Integration Procedure]]
- 수식·함수 문법이 필요하다? → [[OmniStudio Formula Functions 레퍼런스]]

### 셋업·배포
- standard vs managed 런타임을 어떻게 배포하나? → [[OmniStudio 메타데이터·DataPack 배포]]
- Callable/System.Callable로 Apex를 연동하려면? → [[OmniStudio 셋업·권한·활성화]]

### Industries CPQ
- EPC 제품 카탈로그(Product2 offer·번들·속성)를 어떻게 모델링하나? → [[Enterprise Product Catalog (EPC) — 데이터 모델·명명·번들]]

---

## 관련 폴더

- Service Cloud Omni-Channel(작업 라우팅·큐잉, OmniStudio와 무관) → [[Service(서비스)/index|Service Cloud]]
- 실행형 스킬 라우팅(omniscript/flexcard/datamapper/integration-procedure 등 sf-skill) → [[스킬 ↔ 위키 토픽 맵]]
