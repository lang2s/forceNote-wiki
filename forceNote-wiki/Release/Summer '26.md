---
tags: [release, summer_26]
api_version: v67.0
release_date: 2026-06
created: 2026-05-17
source: salesforce_release_notes_5-17-2026.pdf
aliases: [Summer '26, 서머 26, v67.0, 서머26 릴리즈 노트, 2026 여름 릴리즈, Summer 26 허브]
---

# Summer '26 릴리즈 노트

> API v67.0 | 출시: 2026년 06월
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 파괴적 변경 (v67.0) — 요지 3줄

> 상세·코드·이관 가이드는 → [[Summer '26/Development]]

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// v67.0: DB 작업이 기본 user mode. 명시 권장.
Account acc = [SELECT Id FROM Account WHERE Name = 'Singha' WITH USER_MODE LIMIT 1];
```

- **SOQL/DML/Database 기본 USER_MODE** — API v67.0+의 데이터베이스 작업이 시스템 모드가 아닌 **사용자 모드** 기본 (공유 룰·FLS·객체 권한 자동 적용). 시스템 모드가 필요하면 명시해야 한다.
- **공유 미선언 클래스 → `with sharing` 기본값** — v67.0+로 컴파일된 클래스는 sharing 선언이 없으면 `with sharing`이 기본. 공유 룰 우회는 명시적 `without sharing` 필요.
- **`WITH SECURITY_ENFORCED` 제거** — v67.0+ 클래스에서 컴파일 오류. `WITH USER_MODE`로 교체 필수.

---

## 하위 노트 (이 릴리즈는 분량이 커서 도메인별로 분리)

- [[Summer '26/Development]] — Apex·LWC·API GA 전수 + 코드 + New/Changed 개발자 항목 + 거버너 한도
- [[Summer '26/Platform]] — Admin·Security·Flow·Mobile·DevOps·Architecture (Hyperforce·Edge·TLS·Chatter)
- [[Summer '26/Clouds]] — Data360·Analytics·Field Service·Education·Service 등 클라우드 GA/Beta
- [[Summer '26/Agentforce]] — MCP Servers GA·Orchestrate Agents Beta·Apex 통합 테스트
- [[Summer '26/Release Updates]] — 강제 적용 항목 + 시점 매핑

---

## 섹션별 GA 하이라이트

| 도메인 | 하이라이트 (1줄) | 상세 |
|---|---|---|
| Apex | 멀티라인 문자열 + `String.template()`, 기본 USER_MODE/with sharing 전환 | [[Summer '26/Development]] |
| LWC | State Managers GA, Single Component Live Preview GA, Live Preview VS Code GA | [[Summer '26/Development]] |
| API | Hosted MCP Servers GA, GraphQL mutation field reference, Reports Download 파라미터 추가 | [[Summer '26/Development]] |
| Agentforce | MCP Servers GA, Named Query API Agent Actions GA, OpenAI Search Provider GA | [[Summer '26/Agentforce]] |
| Platform | Salesforce Edge Network 강제(7/11), TLS 인증서 수명 단축, Chatter 신규 org 기본 OFF | [[Summer '26/Platform]] |
| Release Updates | SAML 다중구성 마이그레이션, X(Twitter) Auth 폐기, Blob.toPdf() Visualforce 렌더링 | [[Summer '26/Release Updates]] |

---

## 연관 패턴 노트 업데이트 필요

> 이 릴리즈로 인해 수정이 필요한 기존 노트

- [x] [[WITH USER_MODE]] — `WITH SECURITY_ENFORCED` 폐기, v67.0 기본 USER_MODE 변경 내용 추가
- [ ] [[SOQL 패턴]] — 기본 모드 변경(USER_MODE) 및 `WITH SECURITY_ENFORCED` 제거 내용 반영
- [ ] [[DML 패턴]] — `insert as user`, `AccessLevel.USER_MODE` 기본 적용 설명 추가
- [ ] [[Safely]] — 공유 선언 기본값 변경(v67.0 with sharing) 업데이트
- [ ] [[StripInaccessible]] — USER_MODE 기본 적용으로 인한 대안 패턴 재검토
- [ ] [[Queueable]] — Elastic Limits (Beta) 내용 추가
- [ ] [[@InvocableMethod 패턴]] — no-arg 생성자 필수 요건, `InvocableActionExtension` 메타데이터 추가

---

## 관련 노트

- [[Release MOC]]
- [[Spring '26]] — 이전 릴리즈 (v66.0)
- [[Winter '26]] — 이전이전 릴리즈
</content>
</invoke>
