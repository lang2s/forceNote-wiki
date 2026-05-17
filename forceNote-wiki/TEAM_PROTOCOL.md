# forceNote-wiki 팀 프로토콜

> 이 문서는 PM 에이전트가 작업 시작 시 반드시 읽는다. 모든 에이전트의 역할, 파이프라인, 핸드오프 규칙을 정의한다.

---

## 팀 구성

| 역할 | 에이전트 ID | 핵심 책임 | 파일 쓰기 권한 |
|---|---|---|---|
| PM | `pm` | 작업 분해, 에이전트 조율, 최종 보고 | ❌ |
| 질문 명확화 | `question-clarifier` | 모호한 요청 → 명확한 스펙 | ❌ |
| 리서치 플래너 | `planner` | 소스 파악, 리서치 플랜 생성 | ❌ |
| 소스 탐색 | `scout` | 소스 위치 탐색 (파일 경로, 라인 번호) | ❌ |
| 자료 조사 | `researcher` | 소스에서 모든 내용 추출 | ❌ |
| 자료 분류 | `classifier` | 폴더·Tier·구조·wikilink 결정 | ❌ |
| 작성 | `writer` | 위키 .md 파일 생성/수정 | ✅ (콘텐츠 파일만) |
| 완전성 검증 | `completeness-validator` | 누락된 클래스/메서드 탐지 | ❌ |
| 출처 검증 | `source-verifier` | API명·코드·Tier 정확성 검증 | ❌ |
| 인덱스 관리 | `index-manager` | SEARCH_INDEX·MOC·index.md 업데이트 | ✅ (탐색 파일만) |
| 위키 점검 | `wiki-linter` | 전체 위키 건강 검사 | ❌ |
| QA | `qa` | 최종 검토 및 승인/반려 | ❌ |

---

## 파이프라인

### A. 표준 파이프라인 — 새 콘텐츠 추가

```
question-clarifier (요청 모호시)
        ↓
      pm (작업 분해)
        ↓
    planner (리서치 플랜)
        ↓
     scout (소스 위치 탐색)
        ↓
  researcher (전체 내용 추출)
        ↓
  classifier (분류·구조 결정)
        ↓
    writer (파일 작성)
        ↓
completeness-validator (누락 검사)
        ↓
  [누락 있으면 → writer 재작업]
        ↓
source-verifier (정확성 검사)
        ↓
  [오류 있으면 → writer 수정]
        ↓
 index-manager (탐색 파일 업데이트)
        ↓
       qa (최종 검토)
        ↓
      pm (사용자 보고)
```

### B. 빠른 파이프라인 — 기존 파일 보완

```
planner → scout → researcher → writer → completeness-validator → source-verifier → index-manager
```

### C. 점검 파이프라인 — 위키 건강 검사 (/lint)

```
wiki-linter → qa → pm (보고)
```

### D. 답변 파이프라인 — 위키 내용 질문

```
question-clarifier (필요시) → (PM이 직접 위키 읽고 답변)
```

---

## 에이전트 간 핸드오프 규칙

### 1. 입력 명세 포함

에이전트를 호출할 때 반드시 다음을 포함한다:
- 이전 에이전트의 출력 결과 (요약 또는 전체)
- 작업 범위 제약 (사용자가 "~빼고" 말한 것 등)
- 완료 기준

### 2. 재작업 루프

```
completeness-validator ❌ → writer에게 갭 리포트 전달 → writer 수정 → 재검증
source-verifier ❌        → writer에게 오류 목록 전달 → writer 수정 → 재검증
qa ❌                     → 해당 에이전트에게 구체적 지시 → 재작업 → qa 재검토
```

재작업은 최대 2회. 그래도 해결 안 되면 PM이 사용자에게 보고하고 판단 요청.

### 3. 건너뛰기 규칙

PM이 판단하여 에이전트를 건너뛸 수 있는 조건:

| 건너뛰는 에이전트 | 조건 |
|---|---|
| `question-clarifier` | 요청이 명확하고 구체적인 경우 |
| `scout` | 소스 위치가 이미 알려진 경우 (이전 작업에서 확인됨) |
| `classifier` | 같은 파일을 보완하는 경우 (폴더/구조 이미 결정됨) |
| `completeness-validator` | 단순 오타 수정 등 내용 추가 없는 경우 |

---

## 고정 제약 (모든 에이전트 공통)

1. **Metadata 네임스페이스** — 사용자 명시 승인 없이 작업 금지
2. **DevOps 네임스페이스** — 사용자 명시 승인 없이 작업 금지
3. **Tier 3 출처** — 항상 경고 블록 추가 필수
4. **폴더명** — English(한글) 형식 필수, 순한글 금지
5. **wikilink** — 존재 확인 없이 추가 금지

---

## 소스 위치 참조

```
PDF 소스:
/Users/a/Desktop/Study/Salesforce Documents/salesforce_apex_reference_guide.pdf
/Users/a/Desktop/Study/Salesforce Documents/lightningAura.pdf
/Users/a/Desktop/Study/Salesforce Documents/salesforce_soql_sosl.pdf

TrailheadApp 소스:
/Users/a/Desktop/Study/ (하위 폴더 확인)

PDF 추출 도구:
/opt/homebrew/bin/pdftotext

임시 파일 저장:
/tmp/ (세션 간 유지되지 않음 — Scout가 매번 새로 추출)
```

---

## 버전

- 프로토콜 버전: 1.0
- 최초 작성: 2026-05-18
- 다음 검토: 10개 이상 새 작업 완료 후
