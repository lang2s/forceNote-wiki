---
tags: [index, flow]
created: 2026-05-17
---

# Flow — 로컬 인덱스

> Salesforce Flow 자동화 패턴 — 개념, 타입별 설계, Apex·LWC 연동

**상위:** [[Flow MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Flow 종류와 변수]] | processType 결정, isInput/isOutput 변수, $Flow 전역 변수 | #concept |
| [[Flow 요소 참조]] | XML 요소 전체 참조 — recordLookups/decisions/assignments/actionCalls | #reference |
| [[Screen Flow 설계]] | 다단계 마법사 UI, flowruntime 내장 컴포넌트, LWC 삽입, faultConnector | #pattern |
| [[Autolaunched Flow 패턴]] | 헤드리스 로직, 레코드 CRUD, Apex/Agent에서 호출 | #pattern |
| [[@InvocableMethod 패턴]] | Flow Action 표준 구조, bulkInvoke, JSON 우회, Queueable 연동 | #pattern |
| [[Flow Screen LWC 패턴]] | FlowAttributeChangeEvent, @api validate(), Custom Property Editor | #pattern |
| [[멀티 패키지 구조]] | sfdx-project.json, 도메인별 독립 Unlocked Package 구성 | #pattern |

---

## 빠른 선택

- Flow 종류를 처음 파악할 때? → [[Flow 종류와 변수]]
- XML 요소 이름이 기억 안 날 때? → [[Flow 요소 참조]]
- 사용자 화면 있는 다단계 Flow? → [[Screen Flow 설계]]
- 레코드 처리·백그라운드 자동화? → [[Autolaunched Flow 패턴]]
- Flow에서 Apex 로직 호출? → [[@InvocableMethod 패턴]]
- Flow 화면 안에 LWC 삽입? → [[Flow Screen LWC 패턴]]
- 멀티 패키지 프로젝트 구성? → [[멀티 패키지 구조]]

---

## 읽기 순서 (처음 공부할 때)

```
Flow 종류와 변수 → Flow 요소 참조 → Screen Flow 설계 or Autolaunched Flow 패턴 → @InvocableMethod 패턴
```
