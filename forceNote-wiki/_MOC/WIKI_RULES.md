# Wiki 작성 규칙 — 빠른 참조

> ⚠️ **정본은 `forceNote-wiki/CLAUDE.md`다.** 이 파일은 빠른 참조 요약일 뿐이며, 두 문서가 다르면 항상 CLAUDE.md가 우선한다. Step 0 검증(출처 Tier·코드 대조·링크 검증·깊이 원칙)·샤드 아키텍처·nav 파일 면제 규칙 등 상세는 CLAUDE.md 참조.
> (2026-07-17 정비: 구버전이던 이 파일이 "00 SEARCH_INDEX.md에 키워드 행 추가"라는 샤드 이전 시대 규칙을 담고 있어 라우터 불변 원칙과 모순 → 정본 동기화 완료.)

---

## 1. 폴더명 규칙

| 형식 | 예시 |
|---|---|
| 순수 한글 ❌ | `보안`, `비동기`, `통합` |
| **영어(한글) ✅** | `Security(보안)`, `Async(비동기)`, `Integration(통합)` |
| 영어+한글 혼합 ❌ | `Apex통합`, `컴포넌트API` |
| **영어(영어+한글) ✅** | `ApexIntegration(Apex통합)`, `ComponentAPI(컴포넌트API)` |

**예외 (승인됨):** 고유명사·영문 API명 그대로가 이름인 폴더는 괄호 한글을 생략할 수 있다 — `Apex/`, `LWC/`, `Flow/`, `Release/`, `sObject/`, `LWC/LDS/`, `AgentSkills(에이전트스킬)/sf-skills/` 등. 새 폴더는 기본적으로 `English(한글)`을 쓰고, 생략은 위처럼 제품/API 고유명일 때만.

---

## 2. 파일 구조 (콘텐츠 노트)

```markdown
---
tags: [카테고리, 키워드...]
source: 출처_파일.cls 또는 문서명   ← "없음"·"일반 지식" 금지, Tier 3이면 external-knowledge + 경고 블록
created: YYYY-MM-DD
aliases: [영어키워드, 한국어키워드, ...]
---

# 제목

> 한 줄 요약

---

## 개념 설명 + 실제 동작 코드 예제

## 비교표 (선택 기준이 있을 때)

## 관련 노트

- [[파일명]]
```

nav 파일(index.md·MOC·라우터·샤드)은 `source`/`aliases` 면제 (CLAUDE.md "예외 — 탐색 보조(nav) 파일" 참조).

---

## 3. 새 파일 추가 — Step 0 검증 + 4단계 (정본: CLAUDE.md)

```
Step 0. 추가 전 검증 — 출처 Tier / 코드·구조 대조 / wikilink 실재 / 구조 체크리스트
□ 1. 파일 생성 — 위 구조 준수
□ 2. 주 도메인 `_index/{샤드}.md`에 키워드 행 추가   ← 라우터(00 SEARCH_INDEX.md)에는 개별 페이지를 넣지 않는다 (라우터 불변)
□ 3. 해당 섹션 MOC 업데이트 — 링크 추가
□ 4. 폴더 index.md 업데이트 — 파일 목록 행 추가
```

탐색 파일(라우터·샤드·MOC·index.md)의 쓰기는 **index-manager 단독**이다.

### 키워드 행 작성법

한 행에 **영어 API명 + 한국어 표현 + 자연어 질문**을 모두 포함한다. 행은 주 도메인 샤드 한 곳에만 둔다 (1 페이지 = 1 홈 샤드).

```
| deleteRecord, updateRecord, 레코드 삭제, 레코드 수정, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
```

---

## 4. 탐색 파일 위치

| 역할 | 파일 |
|---|---|
| 키워드 라우터 (도메인→샤드) | `00 SEARCH_INDEX.md` |
| 키워드 샤드 | `_index/{도메인}.md` (전체 목록은 라우터 참조) |
| 섹션 MOC | `Apex/Apex MOC.md` · `LWC/LWC MOC.md` · `Flow/Flow MOC.md` · `Integration(통합)/통합 MOC.md` |
| 폴더 로컬 인덱스 | 각 `폴더/index.md` |
