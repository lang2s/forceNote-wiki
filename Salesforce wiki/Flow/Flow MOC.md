---
tags: [flow, moc, index]
created: 2026-05-17
aliases: [Flow MOC, Flow Index]
---

# Flow MOC

> Salesforce Flow 관련 패턴 인덱스.

---

## Apex ↔ Flow 연동

- [[@InvocableMethod 패턴]] — Flow Action 표준 구조, bulkInvoke, Input/Output 파라미터
- [[Flow Screen LWC 패턴]] — FlowAttributeChangeEvent, validate(), Property Editor

## 프로젝트 구조

- [[멀티 패키지 구조]] — sfdx-project.json, 도메인별 패키지 분리, 버전 관리

---

## 핵심 이벤트 & API 요약

| API | 설명 |
|---|---|
| `@InvocableMethod` | Apex → Flow 호출 가능 액션 등록 |
| `@InvocableVariable` | Flow ↔ Apex 파라미터 바인딩 |
| `FlowAttributeChangeEvent` | Flow Screen LWC → Flow 값 변경 통보 |
| `FlowNavigationNextEvent` | 다음 화면 이동 |
| `@api validate()` | Flow Next 클릭 시 검증 |
| `Flow.Interview.createInterview()` | Apex에서 Flow 실행 |
| `configuration_editor_input_value_changed` | Property Editor → Flow Builder |
| `Approval.isLocked/lock/unlock` | 레코드 잠금 (승인 프로세스) |
