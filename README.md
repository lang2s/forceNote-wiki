# forceNote — Salesforce 지식 베이스

Salesforce 개발자·어드민을 위한 **검증된 패턴 위키**와, 그 위키를 작성하는 데 쓰는 **공식 레퍼런스 PDF**를 한 저장소에 모았다. 위키는 Salesforce 공식 오픈소스(apex-recipes, lwc-recipes 등)와 공식 문서 PDF를 직접 분석·추출한 내용이며, [Obsidian](https://obsidian.md) vault로 열도록 구성돼 있다.

**연관 저장소:** [sf-team-framework](https://github.com/lang2s/sf-team-framework) — 위키 분석 결과가 반영되는 팀 스킬 라이브러리

---

## 저장소 구조 (최상위)

```
forceNote-wiki-main/
├── forceNote-wiki/          ← 위키 본체 (Obsidian vault) · 상세는 forceNote-wiki/README.md
│   ├── 00 Home.md               전체 진입점
│   ├── 00 SEARCH_INDEX.md       키워드 라우터 → _index/ 도메인 샤드
│   ├── _index/                  키워드 검색 샤드 (6개)
│   ├── Apex/ LWC/ Flow/ …       섹션별 패턴 노트 (179개)
│   ├── CLAUDE.md                위키 작성 규칙 + 환경 부트스트랩
│   ├── CLAUDE.local.md          로컬 환경 설정 (Mac/Win 경로 확인)
│   └── .claude/agents/          위키 작성 멀티에이전트 (15개)
├── Salesforce Documents/    ← 공식 레퍼런스 PDF 42종 (위키 작성 소스, Tier 2)
├── README.md                ← 이 파일 (저장소 전체 개요)
└── .gitignore
```

---

## 빠른 시작

**위키 읽기 (Obsidian)**
1. Obsidian → **Open folder as vault** → `forceNote-wiki/` 선택
2. `00 Home.md`에서 시작, **Graph View**(Ctrl/Cmd + G)로 노트 연결망 탐색

**위키 보강 (Claude Code 팀)**
- 작업 시작 시 `forceNote-wiki/CLAUDE.md`의 **"작업 전 환경 부트스트랩"** 이 OS(Mac/Windows)를 감지하고 경로·도구를 확인한다. (없으면 `CLAUDE.local.md`를 자동 생성)
- 소스 PDF는 `Salesforce Documents/`, 텍스트 추출은 `pdftotext`(PATH).
- 팀 파이프라인·에이전트 정의는 `forceNote-wiki/TEAM_PROTOCOL.md` 참조.

---

## 더 보기

| 보고 싶은 것 | 파일 |
|---|---|
| 위키 내용·구조·커버리지 현황 | **[forceNote-wiki/README.md](forceNote-wiki/README.md)** |
| 위키 작성 규칙 | `forceNote-wiki/CLAUDE.md` |
| 팀 워크플로우 | `forceNote-wiki/TEAM_PROTOCOL.md` |
| 작업 백로그·커버리지 분석 | `forceNote-wiki/_MOC/WORK_BACKLOG.md` |
