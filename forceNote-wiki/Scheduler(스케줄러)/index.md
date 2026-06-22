---
tags: [index, scheduler, salesforce-scheduler]
created: 2026-06-22
---

# Scheduler(스케줄러) — 로컬 인덱스

> Salesforce Scheduler(구 Lightning Scheduler) 개발자 레퍼런스 — 예약(appointment) 스케줄링 솔루션. 개요·표준/커스텀 객체·Platform Events·Metadata API·Business(REST/Connect) API·ConnectApi.LightningScheduler Apex·커스텀 예약 시나리오 12노트. (출처: Salesforce Scheduler Developer Guide v67.0 Summer '26)

**상위:** [[00 Home]] · 키워드 검색은 `_index/scheduler.md`

> ℹ️ Field Service·Omni-Channel(`Service(서비스)/`)과 객체를 공유한다(ServiceResource·ServiceTerritory·OperatingHours·WorkType 등). 예약(부킹) 흐름은 이 폴더, 옴니채널 라우팅은 Service Cloud.

---

## 파일 목록

### 개요

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] | Scheduler란·선행 셋업·데이터 모델·OAuth 인증·SOQL 결과 번역(toLabel) | #overview |

### 표준객체 (4)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce Scheduler 표준객체 — 핵심 예약]] | ServiceAppointment·ServiceAppointmentAttendee·AssignedResource·Waitlist·WaitlistParticipant 필드 전수 | #sobject-reference |
| [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] | ServiceResource·ServiceTerritory·Shift(RRULE)·Skill 등 9객체 필드·picklist | #sobject-reference |
| [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] | SchedulingPolicy·OperatingHours·WorkType 등 10객체 필드·picklist | #sobject-reference |
| [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] | AppointmentInvitation·Invitee·ScheduleAggr·ScheduleLog (셀프 부킹·Load Balancing) | #sobject-reference |

### 커스텀객체

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce Scheduler 커스텀객체]] | EngagementChannelType·ShiftWorkTopic 등 junction(중간관계) 커스텀객체 10종 | #sobject-reference |

### Platform Events · Metadata

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce Scheduler — Platform Events·Metadata API Types]] | ServiceAppointmentEvent·AppointmentSchedulingEvent + IndustriesSettings(Industries.settings) | #platform-events #metadata |

### Business API — 엔드포인트·표현형·Apex

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] | getAppointmentCandidates/Slots REST + Connect REST 리소스 9개 (URI·메서드·버전) | #rest-api #connect-api |
| [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] | Request 13종·Response 28종 표현형 + Error Codes (속성표·JSON·에러 행) | #connect-api |
| [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]] | ConnectApi.LightningScheduler — createServiceAppointment·updateServiceAppointment | #apex #connectapi |

### 예약 시나리오 (2)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)]] | 익명 예약·분배·위치 우선·익명 수정·단일 리소스·수정 6개 시나리오 워크플로우 | #scenario |
| [[Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)]] | Multi-Resource·Concurrent·Sharing Availability·Dummy Resource 5개 시나리오 워크플로우 | #scenario |

---

## 빠른 선택

- Scheduler 처음이고 셋업·인증·데이터 모델부터? → [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]]
- 예약 레코드/참석자/리소스 배정 객체 필드를 찾는다? → [[Salesforce Scheduler 표준객체 — 핵심 예약]]
- 리소스·영역·시프트·스킬 객체 필드? → [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]]
- 작업유형·운영시간·스케줄링 정책 객체? → [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]]
- 셀프 부킹 초대·Load Balancing 집계/로그? → [[Salesforce Scheduler 표준객체 — 초대·집계·로그]]
- junction 커스텀객체(EngagementChannelType 등)? → [[Salesforce Scheduler 커스텀객체]]
- 약속 이벤트 구독·조직 설정 메타데이터? → [[Salesforce Scheduler — Platform Events·Metadata API Types]]
- REST로 예약 후보·가능 슬롯을 조회한다(엔드포인트 URI)? → [[Salesforce Scheduler — Business REST·Connect 엔드포인트]]
- 요청/응답 JSON 스키마·에러 코드를 본다? → [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]]
- Apex에서 예약을 생성/수정한다? → [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]]
- 익명/단일 리소스 예약 앱을 만든다? → [[Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)]]
- 멀티리소스/동시/공유 예약 앱을 만든다? → [[Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)]]

---

## 관련 폴더

- Field Service·Omni-Channel 객체 공유 → [[Service(서비스)/index|Service Cloud]]
- 예약 객체의 sObject 표준 카탈로그 → [[sObject/index|sObject Reference]]
