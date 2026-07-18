#!/usr/bin/env bash
# L2 결정적 구조 검사 (STRUCT-8)
# wiki-linter의 결정적(deterministic) 하위검사를 스크립트로 분리 — LLM은 의미 검사에 집중.
#
# 검사 항목 (전부 wc/grep 기반, 판단 불필요):
#   A. 샤드 상한        — 각 _index/*.md 가 ~300줄 OR ~40k chars 이내인지
#   B. 라우터↔샤드 정합  — 라우터의 모든 샤드가 실재 + 모든 _index/*.md 가 라우터에 등재
#   C. 고아 후보         — 어느 샤드에도 basename이 안 잡히는 콘텐츠 .md (review 필요, 하드실패 아님)
#
# 사용: 레포 루트 또는 forceNote-wiki/ 에서 실행
#   bash scripts/wiki-structure-check.sh
# 종료코드: 0 = 하드위반 없음(고아 후보는 경고), 1 = 하드위반(샤드초과 or 라우터부정합)
#
# 순수 bash — Mac/Win(git-bash) 공통. lint-md-file.sh 와 동일 스코프 규칙.

set -u

# --- 위키 루트 탐색 ---
if [[ -d "forceNote-wiki/_index" ]]; then
  WIKI="forceNote-wiki"
elif [[ -d "_index" && -f "00 SEARCH_INDEX.md" ]]; then
  WIKI="."
else
  echo "❌ 위키 루트를 찾을 수 없음 (forceNote-wiki/_index 또는 ./_index 필요)" >&2
  exit 1
fi

ROUTER="$WIKI/00 SEARCH_INDEX.md"
LINE_MAX=300
CHAR_MAX=40000
HARD_FAIL=0

echo "=================================================="
echo " L2 결정적 구조 검사  (wiki=$WIKI)"
echo "=================================================="

# ─────────────────────────────────────────────────────────
# A. 샤드 상한
# ─────────────────────────────────────────────────────────
echo
echo "── A. 샤드 상한 (~${LINE_MAX}줄 OR ~${CHAR_MAX}chars) ──"
A_ISSUES=0
for f in "$WIKI"/_index/*.md; do
  [[ -e "$f" ]] || continue
  L=$(wc -l < "$f" | tr -d ' ')
  C=$(wc -c < "$f" | tr -d ' ')
  FLAG=""
  if [[ "$L" -gt "$LINE_MAX" ]]; then FLAG="줄 초과($L)"; fi
  if [[ "$C" -gt "$CHAR_MAX" ]]; then FLAG="${FLAG:+$FLAG · }chars 초과($C)"; fi
  if [[ -n "$FLAG" ]]; then
    echo "  ❌ $(basename "$f") — $FLAG → 하위 샤드 분할 필요"
    A_ISSUES=$((A_ISSUES+1)); HARD_FAIL=1
  fi
done
[[ "$A_ISSUES" -eq 0 ]] && echo "  ✅ 전 샤드 상한 이내"

# ─────────────────────────────────────────────────────────
# B. 라우터 ↔ 샤드 정합성
# ─────────────────────────────────────────────────────────
echo
echo "── B. 라우터↔샤드 정합성 ──"
B_ISSUES=0
# 라우터가 참조하는 샤드 목록 (코드셀 `_index/xxx.md`)
ROUTER_SHARDS=$(grep -oE '_index/[A-Za-z0-9_-]+\.md' "$ROUTER" | sort -u)
# 디스크의 샤드 목록
DISK_SHARDS=$(for f in "$WIKI"/_index/*.md; do basename "$f"; done | sed 's|^|_index/|' | sort -u)

# B1: 라우터에 있으나 디스크에 없음
while IFS= read -r s; do
  [[ -z "$s" ]] && continue
  if [[ ! -f "$WIKI/$s" ]]; then
    echo "  ❌ 라우터가 참조하나 실재 안 함: $s"
    B_ISSUES=$((B_ISSUES+1)); HARD_FAIL=1
  fi
done <<< "$ROUTER_SHARDS"

# B2: 디스크에 있으나 라우터에 없음
while IFS= read -r s; do
  [[ -z "$s" ]] && continue
  if ! grep -qF "$s" "$ROUTER"; then
    echo "  ❌ 샤드가 라우터에 미등재: $s"
    B_ISSUES=$((B_ISSUES+1)); HARD_FAIL=1
  fi
done <<< "$DISK_SHARDS"

[[ "$B_ISSUES" -eq 0 ]] && echo "  ✅ 라우터↔샤드 양방향 정합 ($(echo "$DISK_SHARDS" | grep -c .)개 샤드)"

# ─────────────────────────────────────────────────────────
# C. 고아 후보 (콘텐츠 .md 중 어느 샤드에도 basename 미등재)
#    — 하드실패 아님. 알려진 예외(refs 폴더·nav)는 제외.
# ─────────────────────────────────────────────────────────
echo
echo "── C. 고아 후보 (review 필요 — 하드실패 아님) ──"
# 전 샤드 본문을 하나로 모아 basename 검색 대상 생성
SHARD_BLOB=$(cat "$WIKI"/_index/*.md 2>/dev/null)
C_ISSUES=0

# 콘텐츠 .md 열거 — lint-md-file.sh 스코프 규칙과 동일하게 nav/system 제외
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  base=$(basename "$f")
  stem="${base%.md}"
  # 콘텐츠 스템이 어느 샤드에든 등장하면 등재된 것으로 간주
  if ! printf '%s' "$SHARD_BLOB" | grep -qF "$stem"; then
    echo "  ⚠️  고아 후보: ${f#"$WIKI"/}"
    C_ISSUES=$((C_ISSUES+1))
  fi
done < <(
  find "$WIKI" -type f -name '*.md' \
    -not -path '*/_index/*' \
    -not -path '*/_templates/*' \
    -not -path '*/_MOC/*' \
    -not -path '*/.claude/*' \
    -not -path '*/memory/*' \
    -not -path '*/scripts/*' \
    -not -path '*/_active/*' \
    -not -path '*/문서/*' \
    -not -path '*/sf-skills/refs/*' \
    -not -name 'index.md' \
    -not -name '*MOC.md' \
    -not -name 'CLAUDE.md' -not -name 'CLAUDE.local.md' \
    -not -name 'TEAM_PROTOCOL.md' -not -name 'README.md' \
    -not -name 'WIKI_RULES.md' -not -name 'SEAM_MAP.md' \
    -not -name '00 SEARCH_INDEX.md' -not -name '00 Home.md' \
    | sort
)
if [[ "$C_ISSUES" -eq 0 ]]; then
  echo "  ✅ 고아 후보 없음"
else
  echo "  → 위 후보는 questions.md 재등재·refs 폴더 커버 등 예외일 수 있음. wiki-linter가 최종 판정."
fi

echo
echo "=================================================="
if [[ "$HARD_FAIL" -eq 0 ]]; then
  echo " 결과: ✅ 하드위반 없음 (고아 후보 ${C_ISSUES}건은 review)"
  exit 0
else
  echo " 결과: ❌ 하드위반 있음 (위 A/B 항목 수정 필요)"
  exit 1
fi
