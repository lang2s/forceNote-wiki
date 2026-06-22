---
tags: [index, search, navigation, scheduler]
created: 2026-06-22
---

# SEARCH INDEX — Scheduler(스케줄러) (Salesforce Scheduler Developer Guide v67.0 Summer '26)
> Salesforce Scheduler(구 Lightning Scheduler) — 적절한 사람을 적절한 장소·시간에 매칭해 예약(appointment)을 잡는 스케줄링 솔루션의 개발자 레퍼런스. 개요·표준/커스텀 객체·Platform Events·Metadata API·Business(REST/Connect) API·ConnectApi.LightningScheduler Apex·커스텀 예약 시나리오까지 12노트.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
>
> ℹ️ Service Cloud(`_index/service.md`)의 Field Service·Omni-Channel과 객체를 공유한다(ServiceResource·ServiceTerritory·OperatingHours·WorkType 등). 예약(부킹) 흐름은 이 샤드, 옴니채널 라우팅은 service 샤드.

---

## 개요·셋업·데이터모델·인증·SOQL

| 키워드 | 파일 |
|---|---|
| Salesforce Scheduler, Lightning Scheduler, Scheduler 개요, Scheduler 셋업, 선행작업 prerequisites, 데이터 모델, OAuth 인증, toLabel, SOQL 결과 번역, picklist 번역, 개발자 리소스 4종, Salesforce Scheduler가 뭐야, Scheduler 시작하기, Scheduler 인증 방법, SOQL 결과 한국어로 받기 | `Scheduler(스케줄러)/Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL.md` |

## 표준객체 — 핵심 예약

| 키워드 | 파일 |
|---|---|
| ServiceAppointment, ServiceAppointmentAttendee, AssignedResource, Waitlist, WaitlistParticipant, 서비스 약속, 예약 레코드, 그룹 예약 참석자, 리소스 배정, 대기열, 대기열 참가자, 예약에 배정된 리소스 조회, ServiceAppointment 필드 목록, 그룹 예약 참석자 객체 | `Scheduler(스케줄러)/Salesforce Scheduler 표준객체 — 핵심 예약.md` |

## 표준객체 — 리소스·영역·스킬·시프트

| 키워드 | 파일 |
|---|---|
| ServiceResource, ServiceResourceSkill, ServiceTerritory, ServiceTerritoryMember, Shift, RRULE, Skill, SkillRequirement, ResourcePreference, ResourceAbsence, 서비스 리소스, 서비스 영역, 시프트, 스킬, 리소스 부재, 리소스 선호도, 시프트 반복 규칙, 리소스 영역 멤버, 리소스 스킬 객체, 시프트 RRULE 설정 | `Scheduler(스케줄러)/Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트.md` |

## 표준객체 — 정책·운영시간·작업유형

| 키워드 | 파일 |
|---|---|
| WorkType, WorkTypeGroup, WorkTypeGroupMember, AppointmentSchedulingPolicy, AppointmentAssignmentPolicy, OperatingHours, TimeSlot, 작업유형, 스케줄링 정책, 배정 정책, 운영시간, 타임슬롯, 약속 정책, 작업유형 그룹, 운영시간 설정 객체, 스케줄링 정책 필드 | `Scheduler(스케줄러)/Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형.md` |

## 표준객체 — 초대·집계·로그

| 키워드 | 파일 |
|---|---|
| AppointmentInvitation, AppointmentInvitee, AppointmentScheduleAggr, AppointmentScheduleLog, 약속 초대, 셀프 부킹, Load Balancing 배정, 리소스 활용도 집계, 스케줄 로그, 고객 셀프 부킹 객체, 로드밸런싱 활용도, 약속 초대 객체 | `Scheduler(스케줄러)/Salesforce Scheduler 표준객체 — 초대·집계·로그.md` |

## 커스텀객체

| 키워드 | 파일 |
|---|---|
| Scheduler 커스텀객체, EngagementChannelType, ShiftWorkTopic, WaitlistServiceResource, WorkTypeGroupMember, junction 객체, 참여 채널 유형, 중간관계 객체, 커스텀 객체 10종, 시프트 작업 주제, 대기열 서비스 리소스, Scheduler junction 객체 목록 | `Scheduler(스케줄러)/Salesforce Scheduler 커스텀객체.md` |

## Platform Events · Metadata API Types

| 키워드 | 파일 |
|---|---|
| ServiceAppointmentEvent, AppointmentSchedulingEvent, AsgnRsrcApptSchdEvent, SvcApptSchdEvent, IndustriesSettings, Industries.settings, Scheduler 플랫폼 이벤트, Metadata API 타입, 외부 캘린더 이벤트, 조직 설정, Scheduler 설정 메타데이터, 약속 스케줄링 이벤트 구독 | `Scheduler(스케줄러)/Salesforce Scheduler — Platform Events·Metadata API Types.md` |

## Business REST · Connect 엔드포인트

| 키워드 | 파일 |
|---|---|
| getAppointmentCandidates, getAppointmentSlots, available-territory-slots, service-appointments REST, Scheduler Business API, Connect REST 리소스, 예약 후보 조회, 가능한 슬롯 조회, REST 엔드포인트 URI, HTTP 메서드, 예약 가능 시간 API, 후보 리소스 REST 호출 | `Scheduler(스케줄러)/Salesforce Scheduler — Business REST·Connect 엔드포인트.md` |

## Connect API 요청·응답 표현형 · Error Codes

| 키워드 | 파일 |
|---|---|
| Scheduler Connect 표현형, Request Body, Response Body, Service Appointment Input, Available Territory Slots Output, Waitlist Result, Scheduler Error Codes, MISSING_ARGUMENT, 요청 바디 13종, 응답 바디 28종, 에러 코드, Connect API JSON 스키마, Scheduler 에러 코드 목록 | `Scheduler(스케줄러)/Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes.md` |

## ConnectApi LightningScheduler Apex

| 키워드 | 파일 |
|---|---|
| ConnectApi.LightningScheduler, createServiceAppointment, updateServiceAppointment, ServiceAppointmentInput, CreateServiceAppointmentInput, Apex로 예약 생성, Apex에서 서비스 약속 만들기, Scheduler Apex 클래스, static 메서드 예약, Apex 예약 수정, ConnectApi 예약 입출력 | `Scheduler(스케줄러)/Salesforce Scheduler — ConnectApi LightningScheduler Apex.md` |

## 커스텀 예약 시나리오 — 익명·단일리소스

| 키워드 | 파일 |
|---|---|
| 익명 예약, anonymous appointment, 약속 분배, appointment distribution, 위치 우선, location first, 단일 리소스 예약, single-resource appointment, 익명 약속 수정, Scheduler 예약 시나리오, 비로그인 고객 예약, 위치부터 고르는 예약 흐름 | `Scheduler(스케줄러)/Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스).md` |

## 커스텀 예약 시나리오 — 멀티리소스·동시·공유

| 키워드 | 파일 |
|---|---|
| 멀티리소스 예약, multi-resource appointment, 동시 예약, concurrent appointment, Sharing Availability, 초대 URL, dummy resource, 더미 리소스 후 재배정, 여러 리소스 동시 예약, 가용성 공유 링크, 동시 예약 흐름, 멀티리소스 예약 시나리오 | `Scheduler(스케줄러)/Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유).md` |
