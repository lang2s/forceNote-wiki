# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> 이 파일은 **레포 루트(= git 루트)** 가이드다. 위키 콘텐츠를 작성·수정하는 상세 규칙은 한 단계 아래
> **`forceNote-wiki/CLAUDE.md`**(정본)에 있다. 콘텐츠 작업을 시작하기 전 그 파일을 먼저 읽는다.

## 이 저장소의 성격

코드 프로젝트가 아니라 **Salesforce 지식 베이스**다. 빌드/컴파일/런타임 테스트가 없다. 산출물은 검증된 패턴을 담은 Markdown 노트(1,200개 이상 — 정확 수치는 세지 말고 하한으로 표기)이며, 소스 PDF/공식 오픈소스를 직접 추출·대조해 작성한다. 위키는 [Obsidian](https://obsidian.md) vault로 열도록 구성돼 있다 (`forceNote-wiki/`를 vault로 open, `00 Home.md`에서 시작).

## 2층 구조 — 가장 흔한 혼동 지점

```
<레포 루트 = git 루트 = 현재 작업 디렉터리>
├── forceNote-wiki/          ← Obsidian vault = 위키 콘텐츠 트리 (유일). 자체 CLAUDE.md 보유
│   └── 문서/                ← 예외: 비-Salesforce 사내 분석 문서 (.gitignore, lint 스코프 제외 — vault CLAUDE.md 참조)
├── Salesforce Documents/    ← 소스 PDF 50여 종 + 학습노트 (.gitignore — 커밋 안 됨. 예외: AgentScriptDocs/는 커밋됨)
├── _user-docs/              ← 사용자용 참고 문서 출력 위치 (.gitignore, 필요 시 생성)
└── CLAUDE.md                ← 이 파일
```

- **git 루트는 `forceNote-wiki/`가 아니라 그 상위(여기)다.** 위키 콘텐츠 트리는 `forceNote-wiki/` 하나뿐.
- 따라서 위키를 오염시키지 않는 산출물(사용자 참고 문서 등)은 `forceNote-wiki/` **바깥**(`_user-docs/`)에 둔다.
- 위키 콘텐츠를 추가/수정하는 모든 규칙(파일 구조·frontmatter·출처 Tier·인덱스 갱신·탐색 아키텍처)은 `forceNote-wiki/CLAUDE.md`가 정본이다 — 여기서 재서술하지 않는다.

## 핵심 명령

소스 PDF 추출 — `pdftotext`는 PATH에 있다 (Win: `/mingw64/bin`, Mac: `/opt/homebrew/bin`). 절대경로 하드코딩 금지, 레포 루트 기준 상대경로 사용:

```bash
pdftotext "Salesforce Documents/salesforce_apex_reference_guide.pdf" /tmp/apex_ref.txt
pdftoppm  "Salesforce Documents/<file>.pdf" /tmp/out -png   # pdftotext가 다이어그램을 못 잡을 때 이미지화 후 Read
```

콘텐츠 작업 전 환경 부트스트랩(OS 감지 → `forceNote-wiki/CLAUDE.local.md` → `.claude/env/{windows|mac}.md`)을 거친다. 절차는 `forceNote-wiki/CLAUDE.md`의 "작업 전 환경 부트스트랩" 참조.

위키 구조 lint — `forceNote-wiki/.claude/settings.json`의 **PostToolUse 훅**이 `scripts/lint-md-file.sh`를 자동 실행한다. Write/Edit/MultiEdit으로 콘텐츠 `.md`를 건드리면 frontmatter 4필드(tags/source/created/aliases)·한 줄 요약·코드블록·`## 관련 노트`·깨진 wikilink를 검사하고, 문제가 있으면 exit 2로 stderr 피드백을 돌려준다(탐색/시스템 파일은 스코프 제외). 이 훅은 `forceNote-wiki/`를 작업 디렉터리(`$CLAUDE_PROJECT_DIR`)로 열었을 때 발동한다.

## 멀티에이전트 팀 시스템

비자명한 위키 작업은 단발 편집이 아니라 **15개 서브에이전트 파이프라인**으로 처리한다. 정의는 `forceNote-wiki/.claude/agents/`, 파이프라인·핸드오프 계약은 `forceNote-wiki/TEAM_PROTOCOL.md`, 책임 지도는 `forceNote-wiki/SEAM_MAP.md`.

> ⚠️ **pm은 서브에이전트로 스폰하지 않는다** — 서브에이전트는 다른 에이전트를 스폰할 수 없어 파이프라인이 멈춘다(실제 사고 사례 있음). `pm.md`는 **메인 세션이 직접 수행하는 오케스트레이션 플레이북**이고, 메인 세션이 나머지 실무 에이전트들을 스폰해 지휘한다.

- 새 콘텐츠: `pm`(=메인 세션) → planner → scout → researcher → classifier → (writer ∥ source-coverage-checker) → completeness-validator ∥ source-verifier → index-manager → cross-linker → qa → wiki-retrospective
- `/lint` 또는 "위키 점검": `wiki-linter` → `qa`
- "뭐가 없어?"(큰 그림 공백): `wiki-retrospective`(모드 B) → `pm`
- 간단한 질문 답변은 팀 없이 직접 답한다 (위키 내용 우선, 외부 지식과 섞지 않음).

## 작업 시 반드시 지키는 제약 (전체 규칙은 vault CLAUDE.md)

- **Windows 파일명**: `: * ? " < > | \ /` 및 예약어(CON·NUL 등) 금지 — 이 문자가 든 파일은 Windows clone 시 디스크에 생성되지 않는다. 부제 구분은 ` - ` 또는 ` — `(em dash)를 쓴다.
- **폴더명**: `English(한글)` 형식 필수 (예: `Security(보안)`). 순한글·혼합 금지.
- **출처 Tier**: 로컬 소스/공식 PDF = Tier 1·2(그대로 사용), 훈련데이터 기반 = Tier 3(`source: external-knowledge` + 경고 블록). `source: 없음`/`일반 지식` 금지.
- **사용자용 참고 문서**: 사용자가 "위키에 넣지 말고 따로/참고용 문서로 만들어줘"라고 하면 위키 트리에 저장 금지 — 기본 HTML로 `_user-docs/`에 출력하고 경로를 알린다 (vault CLAUDE.md 최상단 "⛔ 절대 규칙" 참조).
- **탐색은 인덱스로**: 키워드 질문은 `forceNote-wiki/00 SEARCH_INDEX.md`(라우터) → `_index/{샤드}.md` → 파일 순. grep/find로 콘텐츠를 훑지 않는다.
