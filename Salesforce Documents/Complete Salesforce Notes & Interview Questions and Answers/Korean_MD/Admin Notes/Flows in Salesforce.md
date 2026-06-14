---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Flows in Salesforce]
---

# Salesforce의 Flow

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Salesforce Flow는 코드 작성 없이 로직 기반 프로세스를 만들 수 있는 강력한 자동화 도구입니다. 사용자 입력 수집, 레코드 업데이트, 이메일 전송 등 다양한 작업을 할 수 있습니다.

## Flow 유형

1. **Screen Flow** — 화면이 있는 사용자 대화형 플로우
2. **Auto-Launched Flow** — 사용자 입력 없이 백그라운드 실행
3. **Record-Triggered Flow** — 레코드 생성/업데이트/삭제 시 실행

## 1. Screen Flow

필드, 버튼, 선택지가 있는 화면을 제시하여 사용자를 프로세스로 안내하는 대화형 플로우입니다.

**특징:** 데이터 수집용 화면 사용, 사용자 입력 필드 지원(텍스트·선택 목록·체크박스 등), 버튼·Lightning 페이지·Quick Action에서 실행 가능, 탐색 지원(Next, Previous, Finish).

**사용 예:** 고객 정보 수집 Lead Capture Form, 단계별 Case 제출 마법사, 피드백 수집 설문 플로우.

**생성 단계:** Setup → Flows 검색 → New Flow → Screen Flow 선택 → 요소 패널에서 "Screen" 드래그 → 필드·컴포넌트 추가 → 버튼 구성 → 로직 추가(Decision, Assignment, Update) → Save & Activate → Lightning 페이지나 Quick Action에 추가.

## 2. Auto-Launched Flow

사용자 상호작용 없이 백그라운드에서 실행됩니다. 보통 Process Builder, Apex, 다른 플로우에 의해 트리거됩니다.

**특징:** 사용자 상호작용 없이 자동 실행, 복잡한 자동화에 사용, Process Builder·REST API·Apex로 트리거 가능, 배치 처리 가능.

**사용 예:** 지역별 Lead 자동 할당, Opportunity 마감 시 관련 레코드 업데이트, 예약 자동화로 Account 레코드 대량 업데이트.

**생성 단계:** Setup → Flows → New Flow → Auto-Launched Flow 선택 → 로직 요소 추가 → Save & Activate → Process Builder·Apex·API로 트리거.

## 3. Record-Triggered Flow

레코드가 생성·업데이트·삭제될 때 자동 실행됩니다. 대부분의 Workflow Rule과 Process Builder 자동화를 대체합니다.

**특징:** Create/Update/Delete 시 트리거, Before-Save 또는 After-Save 실행, 필드 업데이트·레코드 생성·이메일 전송 가능, Process Builder·Workflow Rule보다 빠름.

**사용 예:** 생성 시 Case를 올바른 팀에 자동 할당, 마지막 Opportunity 마감 시 Account 상태 업데이트, 레코드 업데이트 시 이메일 경고 전송.

**생성 단계:** Setup → Flows → New Flow → Record-Triggered Flow 선택 → 오브젝트·트리거 조건 선택 → Before-Save/After-Save 선택 → 로직 요소 추가 → Save & Activate.

## 모범 사례

- 대화형 사용자 프로세스에는 Screen Flow 사용
- 백그라운드 자동화에는 Auto-Launched Flow 사용
- Workflow Rule 대신 Record-Triggered Flow 사용
- 배포 전 샌드박스에서 테스트
- Debug Mode로 문제 식별
- 같은 오브젝트에 너무 많은 플로우 금지(성능 저하)
