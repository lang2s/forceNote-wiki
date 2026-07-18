---
tags: [admin, email, letterheads, mail-merge, email-to-salesforce, classic, legacy]
source: help.salesforce.com (Salesforce Help — Create Classic Letterheads / Extended Mail Merge / How Does Email to Salesforce Work; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
official_doc: https://help.salesforce.com/s/articleView?id=sales.creating_letterheads.htm&type=5
created: 2026-07-12
aliases: [Letterheads, Classic Letterheads, 레터헤드, Mail Merge, Extended Mail Merge, 메일 머지, Email to Salesforce, My Email to Salesforce, 이메일 투 세일즈포스, Enhanced Letterheads]
---

# Letterheads · Mail Merge · Email to Salesforce (Classic 이메일 도구)

> Classic 시대의 이메일 3대 도구 — **Letterhead**(HTML 이메일 템플릿의 브랜딩), **Mail Merge**(Salesforce 데이터를 Word 문서에 병합), **Email to Salesforce**(외부에서 보낸 이메일을 활동으로 자동 로깅). 모두 레거시이며 각각 현대 Lightning 대안이 있다.

> [!note] 레거시 명시
> 이 세 도구는 **Salesforce Classic 중심 기능**이다. Lightning Experience에서는 신규 생성이 제한되거나(Classic Letterhead·Extended Mail Merge) 별도 현대 기능으로 대체되었다(Enhanced Letterheads·Einstein Activity Capture·AppExchange 문서 생성). 시험·기존 org 유지보수에서 여전히 자주 등장하므로 정리한다.

---

## 세 도구 한눈에

```
// 구조 예시 — Classic 이메일 3대 도구 (실제 원본 다이어그램 아님)
Letterhead ─────────▶ HTML Classic 이메일 템플릿의 로고·색상·헤더/푸터   → 현대: Enhanced Letterheads (Lightning)
Mail Merge ─────────▶ Salesforce 레코드 데이터 → Microsoft Word 문서    → 현대: AppExchange 문서 생성 (Conga·S-Docs 등)
Email to Salesforce ─▶ 외부 메일 클라이언트에서 보낸 메일 → 활동 이력 로깅  → 현대: Einstein Activity Capture (EAC)
```

| 도구 | 하는 일 | 실행 컨텍스트 | 현대 대안 |
|---|---|---|---|
| **Classic Letterheads** | HTML 이메일 템플릿의 로고·색상·헤더/푸터 정의 | Classic HTML 템플릿 전제 | **Enhanced Letterheads** (Lightning) |
| **Extended Mail Merge** | 레코드 데이터를 Word 문서(폼레터·봉투·라벨)에 병합 | Classic only | AppExchange 문서 생성 도구 |
| **Email to Salesforce** | BCC로 보낸 이메일을 레코드 활동 이력에 자동 추가 | Classic·Lightning 공통(개인 설정) | Einstein Activity Capture |

---

## 1. Classic Letterheads (레터헤드)

**Letterhead**는 HTML 이메일 템플릿에 **일관된 브랜딩(로고·색상·상하단 라인)**을 입히는 재사용 컴포넌트다. 하나의 letterhead를 만들어 여러 **HTML Classic Letterhead 이메일 템플릿**의 기반으로 쓴다.

### 구성: Properties + Details

| 구분 | 의미 |
|---|---|
| **Properties** | org 내부에서만 보이는 식별용 정보(이름 등). 이메일 수신자에게는 안 보임 |
| **Details** | 실제 이메일에 적용되는 시각 요소(로고·라인·배경색 등) |

### 생성 절차 (Setup)

1. Setup → Quick Find에 **`Classic Letterheads`** 입력 → **Classic Letterheads** 선택. (소개 페이지가 나오면 **Next** 클릭)
2. **New Letterhead** → letterhead의 **Available**(활성) 여부·이름·설명 입력 후 저장.
3. 편집 화면에서 각 요소를 지정:
   - **Logo**: 먼저 로고 이미지를 **Documents 탭에 업로드**하고, 수신자(비-Salesforce 사용자)가 이메일에서 볼 수 있도록 문서를 **Externally Available Image**로 표시한 뒤 header에 추가.
   - **Edit Top Line**: header 아래 가로선의 **색상(color)·높이(height)** 지정(컬러 피커).
   - **Edit Body Colors**: 본문 영역의 **배경색** 지정.
   - **Edit Middle Line**: 중간 경계선의 색상·높이 지정.
   - Header/Footer 영역의 배경색·정렬도 지정 가능.
4. 저장 후, 이 letterhead를 사용하는 **HTML(with letterhead)** 유형 이메일 템플릿을 만든다(Classic 이메일 템플릿 → New Template → HTML with letterhead).

> **Available 체크박스**가 letterhead의 활성화 스위치다. 비활성 letterhead는 새 템플릿에서 선택되지 않는다.

### Lightning과의 관계 (중요)

| 항목 | 동작 |
|---|---|
| HTML Classic Letterhead 이메일 템플릿 **생성** | Lightning Experience에서 **불가**(Classic에서만 생성) |
| 기존 Classic Letterhead 템플릿 **사용** | Lightning Experience에서 **가능** |
| **Lightning 이메일 템플릿**(Email Template Builder) | Classic Letterhead를 **사용하지 않음** — 대신 **Enhanced Letterheads**를 씀 |

**Enhanced Letterheads** (현대 대안): Lightning Experience에서 만드는 letterhead로, **SML(Salesforce Merge Language)을 쓰지 않는** Lightning 이메일 템플릿에 연결된다. letterhead를 한 곳에서 수정하면 연결된 모든 템플릿이 자동 갱신된다. (메타데이터/객체명 `EnhancedLetterhead`, Setup → Quick Find `Enhanced Letterheads`)

---

## 2. Mail Merge / Extended Mail Merge (메일 머지)

**Mail Merge**는 Salesforce 레코드 데이터를 **Microsoft Word 문서**에 병합해 개인화 문서(폼레터·봉투·라벨 등)를 생성하는 Classic 기능이다.

### Extended Mail Merge

- **병합 가능 객체**: accounts, contacts, leads, cases, opportunities, **custom objects**.
- **산출물**: form letters, envelopes, labels, 또는 원하는 Word 문서.
- **단건(Single) vs 대량(Mass)**: 문서를 하나씩 생성하거나, **mass mail merge**로 여러 레코드에 대해 일괄 생성.
- **활동 로깅**: 생성된 mail merge 문서를 관련 레코드의 **활동 이력**에 로그하거나 Documents 탭에 저장할 수 있다.

### 활성화 절차 (Setup)

```
// 구조 예시 — Extended Mail Merge 활성화 경로 (실제 실행 화면 아님)
Setup → Quick Find "User Interface" → User Interface
      → (Advanced 섹션)
        ☑ Activate Extended Mail Merge
        ☑ Always save Extended Mail Merge documents to the Documents tab
      → Save
```

1. Setup → Quick Find에 **`User Interface`** 입력 → **User Interface** 선택.
2. **Advanced** 섹션에서 **Activate Extended Mail Merge** 체크(원하면 **Always save Extended Mail Merge documents to the Documents tab**도 체크) → **Save**.
3. Word에서 **mail merge 템플릿** 작성(또는 샘플 템플릿 다운로드) → Salesforce에 **업로드**해 담당자가 사용하도록 배포.

> 과거 일부 org에서는 Extended Mail Merge가 기본 비활성이라 Salesforce 지원팀에 요청(Case)해야 활성화되던 시기가 있었다.

### 레거시 상태 — 무엇이 은퇴했나

| 기능 | 상태 |
|---|---|
| **Standard Mail Merge** (원조 Word 통합 병합) | 은퇴(retired) |
| **Connect for Office** (Word에서 직접 병합하던 add-in) | 은퇴 |
| **Extended Mail Merge** | Classic 전용으로 **여전히 존재**하나 Lightning 미지원·마이그레이션 경로 없음 |

> Lightning Experience는 기본적으로 Mail Merge를 지원하지 않는다. 문서 생성이 필요하면 **AppExchange 문서 생성 도구**(Conga Composer·S-Docs·Docomotion 등)를 쓴다.

---

## 3. Email to Salesforce / My Email to Salesforce

**Email to Salesforce**는 사용자가 **외부 이메일 클라이언트**(Outlook·Gmail 등)에서 보낸 이메일을, 전용 BCC 주소를 참조로 넣어 **관련 Salesforce 레코드의 활동 이력에 자동 로깅**하는 기능이다.

### 동작 방식

```
// 구조 예시 — Email to Salesforce BCC 흐름 (실제 원본 다이어그램 아님)
사용자가 Outlook/Gmail에서 메일 작성
   └─ BCC: <내 Email to Salesforce 주소>  ────▶ Salesforce가 수신
                                                  └─ To/CC의 이메일 주소를 Lead·Contact와 매칭
                                                     └─ 매칭된 레코드의 Activity History에 이메일 추가
```

- 보내려는 이메일에 **개인 Email to Salesforce 주소를 BCC**로 넣으면, Salesforce가 그 이메일을 받아 **To·CC의 주소를 lead·contact 등과 매칭**해 해당 레코드의 활동 이력에 추가한다.
- **매칭 한도**: 한 이메일에서 최대 **50개**의 이메일 주소만 매칭한다. To·CC에 고유 주소가 50개를 넘으면 **처음 50개**만 고려한다.

### 관리자 활성화 (Setup)

1. Setup → **Email Administration** → **Email to Salesforce** → **Edit**.
2. **Active**를 체크해 org 전체에 대해 활성화 → 저장.
3. (선택) **Advanced Email Security Settings**: 활성화하면 Salesforce가 이메일을 받으려면 발신 서버가 **SPF(Sender Policy Framework)·Sender ID·DKIM(DomainKeys Identified Mail)** 중 최소 하나를 지원해야 한다. 인증되지 않은 메일은 거부될 수 있다.

### 사용자 설정 (My Email to Salesforce)

1. 개인 설정(Personal Settings) → **My Email to Salesforce**로 이동 → 사용자별 **고유 BCC 주소** 확인(기밀 유지).
2. **My Acceptable Email Addresses**: 리드·컨택과 소통에 쓰는 **본인 발신 주소들을 쉼표로 구분**해 등록. 여기에 등록한 주소에서 보낸 이메일만 활동 이력에 기록된다.
3. 실사용 시 이메일 클라이언트의 연락처에 BCC 주소를 저장하거나 **auto-BCC 규칙**을 걸어 자동 로깅.

### 현대 대안

- **Einstein Activity Capture (EAC)**: Outlook·Gmail 이메일과 일정 이벤트를 Salesforce에 **자동 캡처**하는 현대 기능. 수동 BCC 없이 활동 로깅을 대체한다.

---

## 비교 — 언제 무엇을

| 니즈 | 레거시(Classic) | 권장(현대) |
|---|---|---|
| 브랜드 로고·색상이 들어간 HTML 이메일 | Classic Letterhead + HTML 템플릿 | **Enhanced Letterheads** + Lightning 이메일 템플릿 |
| 레코드 데이터로 Word 문서 대량 생성 | Extended Mail Merge | **AppExchange 문서 생성** 도구 |
| 보낸 이메일을 레코드 활동에 로깅 | Email to Salesforce (BCC) | **Einstein Activity Capture** |

---

## 관련 노트
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 이메일 템플릿(Classic HTML with letterhead 유형 포함)·자동화 발송 액션. Letterhead가 실제로 쓰이는 곳
- [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]] — 조직 전체 발신 주소·전달성 설정. Email to Salesforce 발신/수신 신뢰성과 연결
