---
tags: [release, spring25, v63, apex, lwc, flow, agentforce]
source: salesforce_release_notes_5-17-20264.pdf — Salesforce Spring '25 Release Notes
created: 2026-05-18
aliases: [Spring '25, Spring25, v63.0, API 63, 스프링 25]
---

# Spring '25 Release Notes

> API 버전 63.0 | 2025년 2월 릴리즈

---

## Apex

### Compression Namespace GA
Zip 파일 압축·압축 해제를 Apex 네이티브 라이브러리로 처리. (Summer '24 Beta → GA)

```apex
// 여러 첨부 파일을 Zip으로 압축
Compression.ZipWriter writer = new Compression.ZipWriter();
for (ContentVersion cv : [SELECT PathOnClient, VersionData FROM ContentVersion
                           WHERE ContentDocumentId IN :ids]) {
    writer.addEntry(cv.PathOnClient, cv.VersionData);
}
Blob zipBlob = writer.getArchive();

// Zip에서 특정 항목 추출
Compression.ZipReader reader = new Compression.ZipReader(zipBlob);
ZipEntry entry = reader.getEntry('translations/fr.json');
Blob data = reader.extractEntry(entry);
```

### FormulaEval GA
`FormulaEval` 네임스페이스로 SObject 및 Apex 객체에 동적 수식 평가. 다형성 관계 필드, 표준/커스텀 Lookup 지원. (Summer '24 Beta → GA)

```apex
FormulaEval.FormulaInstance ff = Formula.builder()
    .withType(Schema.Account.class)
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withFormula('name & " (" & website & ")"')
    .build();
String fieldNameList = String.join(ff.getReferencedFields(), ',');
Account a = Database.query('SELECT ' + fieldNameList + ' FROM Account LIMIT 1');
System.debug(ff.evaluate(a));
```

### Scheduled Jobs Pause/Resume
`System` 클래스에 새 메서드로 프로그래밍적으로 스케줄 잡 일시정지·재개.

```apex
// pauseJobByName(), pauseJobById(), resumeJobByName(), resumeJobById()
Id apexClassId = '01p4u000000dVf7AAE';
List<AsyncApexJob> jobs = [SELECT CronTriggerId FROM AsyncApexJob
                            WHERE ApexClassId = :apexClassId];
for (AsyncApexJob j : jobs) {
    System.pauseJobById(j.CronTriggerId);
}
```

### 동시 장기 Apex 요청 한도 — 라이선스 기반 확장
| 라이선스 수 | 동시 Apex 요청 한도 |
|---|---|
| 1,000개 이하 | 10 (기본 최소값) |
| 1,000–5,000개 | 100개당 1 (최대 50) |
| 5,000개 이상 | 50 (최대값) |

### 기타 Apex 변경사항
- **마스터-디테일 리패런팅 제한 강화** (API v63.0+): 리패런팅 미허용 시 `System.DmlException` 발생
- **예외 타입 JSON 직렬화 금지** (API v63.0+): 커스텀/내장 예외 타입 `JSON.serialize()` 시 오류
- **JavaScript Remoting 예외 커버리지 확대**: `@RemoteAction` 트랜잭션 예외를 이벤트 로그에 기록

---

## LWC — API v63.0

### 주요 변경사항

| 변경 | 설명 |
|---|---|
| `apiVersion` 필수화 | 모든 커스텀 컴포넌트의 `.js-meta.xml`에 `apiVersion` 필수. 없으면 자동 추가 |
| Base Components DOM 구조 변경 | Native Shadow DOM 전환 준비 — 내부 DOM 구조 의존 테스트 수정 필요 |
| Wire Adapter 타입 체크 강화 | TypeScript에서 `@wire` 설정값 타입 검사 개선. `$reactiveProp` 반응형 props 타입 해석 |
| JS 셀렉터 공백 처리 변경 | `querySelector` 등 셀렉터에서 불필요한 공백 제거 동작 변경 |
| LWC Stacked Modals (Release Update) | Aura → LWC 모달 마이그레이션. Dynamic Forms 지원 확대 |

### Local Dev GA
Lightning 앱에서 Local Dev(로컬 개발 서버) 정식 출시. 실시간 브라우저 미리보기.

---

## Flow

### Einstein for Flow GA
자연어로 Flow 자동 생성. 정확도 및 속도 개선. 피드백 버튼으로 모델 개선 참여.

### Transform Element — 컬렉션 Join
외부 시스템 컬렉션과 Salesforce 컬렉션을 하나로 결합. 데이터 테이블에 통합 표시.

### Send Email with Attachments in Flow Builder
Send Email 액션에 파일 ID 제공으로 이메일 첨부 파일 지원. 최대 35MB.

### Get Records 레코드 수 제한 옵션
`Get Records` 요소에 상한선 설정(`All records, up to a specified limit`) → 성능 개선, 거버너 한도 리스크 감소.

### Screen Flow 개선

| 기능 | 설명 |
|---|---|
| 자동 트리거 Screen Actions (Beta) | 입력값 변경 시 Autolaunched Flow 자동 실행 (버튼 클릭 불필요) |
| 실시간 유효성 검사 | 포커스 이탈 시 즉시 오류 표시 |
| Built-In Progress Indicator | 단계 표시기 내장 (simple/path 스타일). 코드 없이 진행 상태 표시 |
| 스테이지 할당 간소화 | 화면 속성 에디터에서 직접 스테이지 할당 (별도 Assignment 요소 불필요) |

### Flow URL 파라미터로 특정 요소 포커스
URL 파라미터로 특정 Flow 요소에 바로 이동하는 링크 생성 가능.

### Data Cloud 연동 확장
Data Cloud에서 Email/URL/Phone/Percent/Boolean/Currency 데이터 타입 지원 추가.

---

## Agentforce & Einstein

- **Einstein for Flow GA** — 자연어 Flow 생성
- **Einstein Flow Formula Builder GA** — 자연어로 Flow 수식 작성
- **Einstein Flow Description 생성** — 기존 Flow 요약 자동 생성 (입력/출력 변수, 변경 오브젝트, Subflow 포함)
- **Agentforce 패키징 지원** — Agent Action, Agent Topic, Prompt Template을 1GP/2GP에 패키징 가능

---

## API 변경

### API v21.0–30.0 폐기 일정 변경
Summer '23 → Summer '25로 연기. Summer '25부터 v21.0–30.0 비활성화. **지금 바로 업그레이드 필요.**

### Metadata API 서비스 보호 강화 (Winter '25 이상 신규 org)
`readMetadata()` / `retrieve()` 과부하 시 오류 반환 가능.

### Instance URL → My Domain URL 전환 필수
API 요청의 인스턴스 URL(예: `na44.salesforce.com`) → My Domain URL로 전환.
- 샌드박스: Winter '26(2025년 8월~) 서비스 종료
- 프로덕션: Spring '26(2026년 1월~) 서비스 종료

### Bulk API V2 쿼리 Platform Event (Beta)
`BulkApi2JobEvent`로 Bulk API V2 쿼리 작업 완료/진행 알림 수신. 폴링 불필요.

---

## 개발 환경

### Source Tracking — 특정 Developer Sandbox 활성화 가능
Developer / Developer Pro 샌드박스에서 Source Tracking을 개별적으로 활성화.

### Agentforce 포함 Developer Edition org 제공
신규 Developer Edition에서 Agentforce + Data Cloud 사용 가능.

---

## Release Updates (강제 적용 예정)

| Release Update | 강제 적용 시기 | 설명 |
|---|---|---|
| LWC Stacked Modals | Spring '25 | Aura → LWC 모달 전환 |
| Salesforce 쿠키 first-party 사용 | 미정 | 서드파티 쿠키 차단 대응 |
| 발신자 이메일 주소 인증 | Spring '25 이후 | My Email Settings 이메일 주소 인증 필수 |
| Platform API v21.0–30.0 폐기 | Summer '25 | 레거시 API 버전 요청 차단 |

---

## 관련 노트

- [[Summer '25]] — 다음 릴리즈
- [[Winter '25]] (미작성) — 이전 릴리즈
- [[FormulaEval Namespace]] — GA된 동적 수식 평가
- [[Scheduled Apex]] — pauseJobById/resumeJobById
