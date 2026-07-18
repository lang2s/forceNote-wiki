---
tags: [nav, rules, windows, filename]
created: 2026-07-18
---

# Windows 파일명 제한 — 상세 참고

> 파일명 금지 문자·예약어·사전 확인·복구 절차의 상세판. 핵심 3줄 규칙은 vault `CLAUDE.md`에 있고, 여기는 사례·PowerShell 절차 전문(全文). (STRUCT-1로 CLAUDE.md에서 이전)

Windows NTFS는 아래 문자를 파일명에 허용하지 않는다. Linux/macOS에서 만들어진 git 저장소에 해당 문자가 포함된 파일이 있으면 **Windows에서 git checkout/clone 시 해당 파일이 자동으로 건너뛰어져 디스크에 생성되지 않는다.**

## 절대 사용 불가 문자

| 문자 | 설명 |
|---|---|
| `\` | 백슬래시 (경로 구분자) |
| `/` | 슬래시 (경로 구분자) |
| `:` | 콜론 |
| `*` | 애스터리스크 (와일드카드) |
| `?` | 물음표 (와일드카드) |
| `"` | 큰따옴표 |
| `<` | 작은 부등호 |
| `>` | 큰 부등호 |
| `\|` | 파이프 |
| 제어문자 | ASCII 0x00–0x1F |

## 예약 장치 이름 (확장자 무관, 사용 불가)

`CON`, `PRN`, `AUX`, `NUL`, `COM0`–`COM9`, `LPT0`–`LPT9`
예: `NUL.txt`, `CON.md` 모두 불가

## 추가 제한

- 파일명 끝에 `.` 또는 공백 사용 불가
- 전체 경로 260자 제한 (MAX_PATH, 긴 경로 지원 활성화 시 32,767자)

## 사전 확인 명령어

외부 저장소 clone 전에 금지 문자 포함 파일 목록을 미리 확인한다:

```powershell
git ls-tree -r --name-only HEAD | Select-String '[:\\*?"<>|]'
```

## 이미 건너뛰어진 경우 — 내용 읽기

```powershell
git show HEAD:"경로/파일명.md"
```

git 객체 저장소에는 파일이 존재하므로 `git show`로 내용을 읽을 수 있다.

## 실제 발생 사례 (✅ 2026-06-19 해결)

`forceNote-wiki/DevOps(데브옵스)/` 하위 12개 파일이 파일명에 `: ` 포함했었음
예(해결 전): `2GP — App Analytics Part 1: Overview & Setup.md`
→ Windows에서 clone 시 전부 건너뛰어져 디스크에 없었음. `git show HEAD:<경로>`로만 접근 가능했음.

**조치:** 12개 파일명의 `: `를 ` - `(공백+하이픈+공백)로 일괄 rename + 관련 wikilink 152개·샤드 경로 12개 동시 치환.
예(해결 후): `2GP — App Analytics Part 1 - Overview & Setup.md`
**재발 방지 규칙:** 새 파일명에 콜론(`:`) 등 위 금지 문자를 절대 쓰지 않는다. 부제·구분이 필요하면 ` - `(공백+하이픈+공백) 또는 ` — `(em dash)를 쓴다.

## 관련

- [[WIKI_RULES]] — 작성 규칙 상세
- [[NAV_MAP]] — 폴더 로컬 인덱스 지도
