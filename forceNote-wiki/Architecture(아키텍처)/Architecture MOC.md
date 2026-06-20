---
tags: [moc, architecture, pattern, namespace, reference]
source: wiki-navigation
created: 2026-05-22
aliases: [Architecture MOC, 아키텍처 목차, Architecture Map of Content]
---

# Architecture MOC

> Architecture(아키텍처) 섹션 전체 목차 — Salesforce 설계 패턴, 설정 관리, 검증 규칙, 네임스페이스 레퍼런스 모음.

**상위:** [[00 Home]]

---

## 설계 패턴

- [[서비스 레이어 패턴]] — TriggerHandler → ServiceLayer 브로커 분리, 비즈니스 로직 재사용 설계
- [[Permission Set 설계]] — objectPermissions, fieldPermissions, classAccesses 구성 표준

---

## 설정·메타데이터 관리

- [[Custom Metadata Types]] — CMDT 읽기·쓰기(Metadata.Operations), getInstance, SOQL 조회, isProtected 보호 설정
- [[Schema Namespace 상세]] — DescribeSObjectResult/DescribeFieldResult/RecordTypeInfo/PicklistEntry/ChildRelationship 전체
- [[DevOps Center]] — 선언적 변경 추적·배포 관리 UI(Work Item, Bundle, 파이프라인 스테이지) — sandbox→prod 릴리스 흐름. DevHubSettings(enableALMDevopsCorePref Beta / enableDevOpsCenterGA), scratch org feature DevOpsCenter, DX MCP devops 툴셋

---

## 검증·수식

- [[Validation Rules 예제]] — REGEX, ISBLANK, ISNUMBER, ISCHANGED, PRIORVALUE, VLOOKUP, ISPICKVAL 예제 모음

---

## 플랫폼 개요

- [[Salesforce 플랫폼 개요]] — Org/Object/Record/Field/App, Cloud 종류, 거버너 한도, 환경 분리
- [[Data Skew]] — 데이터 편중(부모당/사용자당 1만 건 초과) → 레코드 잠금·공유 재계산 병목, LDV 모범 사례
- [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] — LDV 읽기 경로: Lightning Platform Query Optimizer·selectivity 임계값·Custom Index·Skinny/Index Tables·Divisions·SOQL/SOSL 최적화
- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — LDV 쓰기 경로: Bulk API 2.0 대량 로드·getUpdated/getDeleted 추출·soft/hard/truncate 삭제·defer sharing·PK chunking
- [[레코드 액세스 설계 (Enterprise Scale)]] — 그룹 멤버십·공유 재계산, ownership skew, implicit sharing, deferred sharing calc
- [[Scoping Rules]] — RestrictionRule로 공유를 줄이지 않고 사용자가 기본 표시되는 레코드 범위를 좁힘 — enforcementType, recordFilter, targetEntity, USING SCOPE EVERYTHING
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — org 레벨 정적 할당량 모음 — 일일/동시 API 콜, Bulk·SOAP·Metadata API 한도, SOQL 검색·Visualforce view state 한도
- [[Enhanced Domains]] — Winter '24 강제 적용 도메인 정책, 모든 URL에 My Domain 포함, 서드파티 쿠키 차단 대응·URL 영향 점검

---

## 네임스페이스 레퍼런스

- [[Approval Namespace]] — Apex에서 승인 프로세스 제출·처리·잠금 — ProcessSubmitRequest, ProcessWorkitemRequest
- [[System Namespace]] — System 전체 클래스 레퍼런스 — AccessLevel, Assert, AsyncOptions, UserInfo, UUID, Callable, FeatureManagement
- [[Site Namespace]] — Force.com Sites URL 재작성 — UrlRewriter (generateUrlFor, mapRequestUrl)
- [[Context Namespace]] — Industries Cloud Context Service Apex — IndustriesContext
- [[ApexPages Namespace]] — Visualforce 컨트롤러 클래스 전체 — StandardController, StandardSetController, Message, Action
- [[AppLauncher Namespace]] — App Launcher 앱 가시성·정렬 제어 — AppMenu.setAppVisibility
- [[VisualEditor Namespace]] — Lightning App Builder 동적 피클리스트 — DynamicPickList, DesignTimePageContext
- [[Canvas Namespace]] — 외부 웹 앱 임베드 Apex SDK — CanvasLifecycleHandler, RenderContext, Canvas.Test

---

## 관련 섹션 MOC

- [[Apex MOC]] — Apex 전체 목차
- [[LWC MOC]] — LWC 전체 목차
- [[Flow MOC]] — Flow 전체 목차
