---
tags: [index, search, navigation, router]
created: 2026-05-17
---

# SEARCH INDEX (라우터)
> 전체 wiki 키워드 검색의 진입점. 평면 인덱스가 아니라 **도메인 → 샤드 라우터**다.
> 키워드의 도메인을 판단해 아래 샤드 파일 **1개만** 열면 된다.
> (한 번에 읽는 양을 일정하게 유지 — 위키가 아무리 커져도 truncation/컨텍스트 낭비 없음)

---

## 라우팅 — 도메인 → 샤드

| 도메인 | 샤드 파일 | 포함 |
|---|---|---|
| LWC · Aura · Flow · SLDS · Base Components(카탈로그) | `_index/frontend.md` | 프론트엔드 전반 (개별 lightning-* 레퍼런스 제외) |
| LWC 베이스 컴포넌트 — lightning-* 개별 컴포넌트 레퍼런스 | `_index/frontend-basecomponents.md` | `LWC/BaseComponents(베이스컴포넌트)/` 개별 페이지 |
| Apex 언어/코어 — 데이터·SOQL/SOSL·비동기·보안·테스트·System·Schema·트리거·컬렉션·한도·표준클래스 | `_index/apex-core.md` | Apex 개발 핵심 |
| Apex 네임스페이스 — 통합/HTTP·Commerce·Industries·Metadata | `_index/apex-namespaces.md` | 통합 및 산업 네임스페이스 |
| Architecture · Admin · Integration(플랫폼) | `_index/platform.md` | VF·Sites·Canvas·AppLauncher·VisualEditor·Enhanced Domains·Admin·외부연동 등 (DevOps/DX 제외) |
| 플랫폼 DevOps / DX — Salesforce DX · Scratch Org · Unlocked/2GP 패키징 · CI/CD · Metadata API · DevOps Center | `_index/platform-devops.md` | `DevOps(데브옵스)/` 폴더 전반 |
| 릴리즈 노트 — Spring/Summer/Winter (v59~v67) | `_index/release.md` | 릴리즈별 변경 |
| sObject Reference — Field 타입·Object 그룹·Associated Objects·Custom Objects·Object Interfaces·표준 Object 카탈로그 | `_index/sobject-reference.md` | Object Reference v67.0 |
| Service Cloud · Knowledge — 데이터모델·SOAP/REST/Metadata/UI API·아티클·데이터카테고리 | `_index/service.md` | Service(서비스)/ 폴더 전반 |
| Security · 시큐어 코딩 — XSS·SQLi·CSRF·Redirect·TLS·민감데이터·CRUD/FLS·Lightning보안·세션/브라우저통신·MC API·FAQ | `_index/security.md` | Security(보안)/ 폴더 전반 (Secure Coding Guide) |
| CPQ · 견적 — Salesforce CPQ(`SBQQ`) API 모델·Quote/Config/Contract API·기타 API·플러그인(JSQCP·9종) | `_index/cpq.md` | CPQ(견적)/ 폴더 전반 (CPQ Developer Guide, managed package — RLM과 별개) |
| Analytics · CRM Analytics · Data Prep — Recipe REST API(개요·엔드포인트·노드 Input·Response·Enum) | `_index/analytics.md` | Analytics(애널리틱스)/ 폴더 전반 (Data Prep Recipe REST API, Summer '26) |
| 자연어 질문 — "~하는 방법" | `_index/questions.md` | 교차 도메인 질문 라우팅 |

---

## 사용법

1. 키워드/질문의 도메인을 판단 → 위 표에서 샤드 **1개** 선택
2. 그 샤드 파일만 읽어 `키워드 → 경로` 확인 → 해당 파일 바로 읽기
3. 도메인이 애매하면 `_index/questions.md`(자연어 질문)부터 본다
4. 섹션 전체를 훑을 땐 Section MOC(`Apex/Apex MOC.md` 등), 폴더 내 탐색은 `폴더/index.md`

---

## 구조 규칙 (요약 — 상세는 `CLAUDE.md`의 "탐색 인덱스 구조")

- 이 라우터는 **개별 페이지를 나열하지 않는다** — 도메인→샤드만. 그래서 크기가 페이지 수와 무관하게 일정하다.
- 각 샤드 상한 **~300줄 / ~12k 토큰**. 초과 시 하위 샤드로 분할하고 위 표에 1줄만 추가한다.
- 모든 샤드 쓰기는 **index-manager 전담** (1 페이지 = 1 홈 샤드, 중복 키워드 행 금지).
