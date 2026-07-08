# 개발 노트 · 교훈 · 규칙 (Dev Notes)

> **목적**: 날짜별 작업 로그([WORKLOG.md](WORKLOG.md))와 별개로, **반복되는 교훈·규칙·주의점**을 모은 자립형 문서.
> 어시스턴트 메모리에만 있던 내용을 프로젝트로 이관 — WORKLOG를 다른 곳으로 옮겨도 이 `doc/` 폴더만 있으면 작업 맥락과 주의점을 알 수 있게 함.
> 최종 갱신: 2026-07-08 · [문서 인덱스](index.md)

---

## 1. 작업 규칙 (프로젝트 정책 요약)

| 규칙 | 내용 |
|------|------|
| **승인** | 로컬 코드/메타데이터 수정 **전** 승인, org 배포는 **매번** 승인 (`CLAUDE.md` Approval Policy) |
| **배포 전 검증** | `sf project deploy start --dry-run`으로 컴파일 검증 + 영향 테스트 실행 후 배포 |
| **스킬 사용** | Apex/메타/배포 작업은 `.agents/skills`의 **platform-\*** 스킬 사용 (아래 2·3 함정을 조기 차단) |
| **기본 org** | target org = `LGCNS_Dev` (`.sf/config.json`). 배포·테스트 전 대상 org 확인 |
| **문서** | `doc/`에 **md만** 작성(다른 형식은 그 요청에 한해). **외부 게시·전송 금지**(사내 정보) |
| **WORKLOG** | 의미 있는 작업 후 `doc/WORKLOG.md` 갱신 |
| **기존 코드 무수정** | 운영 스냅샷 — 기존 코드/인터페이스를 깨지 않게 **가법적·기본 OFF**로 |

## 2. Apex 함정 (실제로 겪은 것 → 재발 방지)

### 2-1. `json`/`JSON` 대소문자 충돌
Apex 식별자는 **대소문자 미구분**. 로컬 변수를 `json`으로 지으면 시스템 `JSON` 클래스를 가려서(shadow), `JSON.deserialize(x, T.class)`가 `json.deserialize(...)`(String 메서드)로 파싱 → **"Method does not exist ... from the type String"** 컴파일 에러.
- **적용**: 변수/파라미터를 시스템 클래스명(`json`, `date`, `time`, `system`, `math`, `test`, `database`, `blob`, `schema` 등)으로 짓지 말 것. `payload`, `dt` 등으로. (2026-07-08 PE 핸들러에서 발생 → `payload`로 수정)

### 2-2. 예약어 변수명
`in`, `date` 등 **예약어**를 변수명으로 쓰면 `Expecting ';' but was 'in'`. → `req` 등으로.

### 2-3. 테스트 데이터 — 필수 필드/길이
- **필수 필드**: Master-Detail/필수 룩업 누락 시 `REQUIRED_FIELD_MISSING`. `Database.insert(list, false)`는 **조용히 실패**하므로 테스트에서 명시 세팅 (예: `NCNS_InterfaceLog__c.Interface__c`(MD) 필수).
- **필드 길이**: Long Text(131072) 초과 값 → `STRING_TOO_LONG`. 분할해서 세팅.

### 2-4. 커스텀 필드 삭제 전 — 모든 참조 제거
필드를 파괴적 삭제하려면 **모든 참조**를 먼저 없애야 함(안 그러면 "referenced elsewhere" 로 삭제 실패):
- **Apex SOQL SELECT** — 점 없는 필드명(`SELECT ... URL__c ...`)은 `.field` 패턴 grep으로 **안 잡힘**. SELECT 목록까지 확인.
- **크로스오브젝트 공식** — 예: 로그의 `fm_IsAged__c`가 `Interface__r.LogRetentionPeriod__c` 참조 → 부모 필드 삭제 불가.
- **레이아웃/리스트뷰/레코드타입** — compactLayout `<fields>`, listView `<columns>`, recordType `<picklistValues>`.
- **교훈**: grep만 믿지 말고 `--dry-run`/실제 배포 오류로 의존을 확정. (2026-07-08 필드 정리 때 `LogRetentionPeriod__c`가 공식 의존이라 삭제 취소하여 로그 만료 로직 보존)

### 2-5. 인터페이스 프레임워크 테스트 IS_TEST
- `NCNS_InterfaceRealTime.IS_TEST`/`NCNS_InterfaceService.IS_TEST`는 **각각** `@TestVisible`. 기본 `true`면 서브클래스 `execute()`가 실제 `send()`를 **건너뜀**.
- 실제 콜아웃/로그 경로를 커버하려면 **둘 다 `false`로 세팅 + `Test.setMock(HttpCalloutMock)`**.
- `NCNS_InterfaceWebService.IS_TEST`는 `final`(설정 불가) → 인바운드 테스트는 로그 적재가 스킵되므로 **반환 DTO로 검증**, `RestContext.request/response` 주입.

## 3. 인터페이스 프레임워크 — 현재 상태 (2026-07-08)

- **신규 인터페이스는 `NCNS_` 프레임워크로 작성** (CMP를 통째 fork한 정식 신규 프레임워크). 구형(`InterfaceUtil`/`IF_CD_Util`/`NsInterfaceUtil`, 운영 ~50+ 클래스)은 **병행 운영**(삭제 불가).
- 핵심: `NCNS_InterfaceService` + 베이스(`RealTime`/`Queueable`/`Batch`) + `NCNS_InterfaceWebService`(인바운드) + 객체 `NCNS_Interface__c`/`NCNS_InterfaceLog__c` + PE 로깅.
- 로그 저장 방식: `NCNS_Interface__c.LogMode__c` **2택**(`DML`/`PlatformEvent`).
- 테스트 인터페이스: 아웃 `NCNS_IF_TEST_OS_Echo`, 인 `NCNS_IF_TEST_IS_Echo`.
- 상세: [NCNS 핸드오버](NCNS_Interface_Framework_Handover.md) · [NCNS 콜아웃 가이드](ncns-callout-logging-guide.md) · [재플랫폼 설계·이력](cmp-interface-replatform-plan.md)

---

*이 문서는 어시스턴트 자동 메모리(교훈·규칙)의 프로젝트 이관본입니다. 날짜별 작업 이력은 [WORKLOG.md](WORKLOG.md) 참조.*
