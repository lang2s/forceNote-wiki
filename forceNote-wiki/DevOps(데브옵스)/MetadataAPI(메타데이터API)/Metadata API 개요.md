---
tags: [devops, metadata-api, salesforce-api, deploy, retrieve, soap, wsdl, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 1 (Understanding Metadata API)
created: 2026-05-22
aliases: [Metadata API, 메타데이터 API, MDAPI, metadata deploy, metadata retrieve]
---

# Metadata API 개요

> Salesforce 설정·커스터마이징을 XML 파일로 배포·검색하는 SOAP 기반 API. Version 67.0 (Summer '26).

---

## 개념 요약

Metadata API는 Salesforce 조직의 **설정 정보(메타데이터)** — 커스텀 오브젝트, Apex 클래스, 레이아웃, 플로우, 권한 세트 등 — 를 소스 코드처럼 파일 형태로 다루는 API다. 개발자가 환경 간 마이그레이션, 버전 관리, 자동화 배포를 수행하는 데 사용된다.

두 가지 개발 패러다임을 제공한다:

| 방식 | 설명 | 호출 예 |
|---|---|---|
| **File-Based** (선언형) | 메타데이터를 .zip 파일로 패키징하여 일괄 배포/검색 | `deploy()`, `retrieve()` |
| **CRUD-Based** (프로그래밍) | 단일 컴포넌트를 동기 CRUD로 조작 | `createMetadata()`, `readMetadata()` 등 |

---

## 지원 에디션 및 권한

**지원 에디션:** Enterprise, Unlimited, Performance, Developer

**필요 권한:** 다음 중 하나
- "Modify Metadata Through Metadata API Functions"
- "Modify All Data"

---

## API 버전 생명주기

| 버전 범위 | 상태 |
|---|---|
| v7.0–v20.0 | 은퇴 (Summer '22에 지원 종료) |
| v21.0–v30.0 | 은퇴 (Summer '25에 지원 종료) |
| v31.0–v66.0 | 지원 중 |
| v67.0 | 현재 (Summer '26) |

---

## File-Based Metadata API 호출 목록

| 호출 | 설명 |
|---|---|
| `deploy()` | 소스 파일 .zip을 조직에 배포 |
| `checkDeployStatus()` | 배포 상태 폴링 |
| `cancelDeploy()` | 진행 중인 배포 취소 |
| `deployRecentValidation()` | 최근 검증 성공 배포를 빠르게 실제 배포 |
| `retrieve()` | 조직에서 메타데이터를 .zip으로 검색 |
| `checkRetrieveStatus()` | 검색 상태 폴링 |

---

## CRUD-Based Metadata API 호출 목록

| 호출 | 설명 |
|---|---|
| `createMetadata()` | 새 메타데이터 컴포넌트 생성 |
| `readMetadata()` | 메타데이터 컴포넌트 조회 |
| `updateMetadata()` | 기존 컴포넌트 업데이트 |
| `upsertMetadata()` | 없으면 생성, 있으면 업데이트 |
| `deleteMetadata()` | 컴포넌트 삭제 |
| `renameMetadata()` | 컴포넌트 이름 변경 |

> **주의:** v31.0 이전의 비동기 CRUD 호출(`create()`, `delete()`, `update()`)은 폐기됨.

---

## Utility Calls

| 호출 | 설명 |
|---|---|
| `checkStatus()` | 비동기 작업 상태 확인 (폐기 예정) |
| `describeMetadata()` | 현재 API 버전에서 지원되는 메타데이터 타입 목록 조회 |
| `describeValueType()` | 특정 메타데이터 타입의 필드 구조 조회 |
| `listMetadata()` | 특정 메타데이터 타입의 컴포넌트 목록 조회 |

---

## 파일 크기 제한

| 항목 | 제한 |
|---|---|
| 압축(.zip) 최대 크기 | ~39 MB |
| 비압축 최대 크기 | ~600 MB |
| .zip 내 최대 파일 수 | 10,000개 |

---

## 접속 방식

1. **SOAP (WSDL)** — Java/Python/기타 클라이언트에서 WSDL 기반으로 연결 (전통적 방식)
2. **REST** — `POST /services/data/vXX.0/metadata/deployRequest` 엔드포인트 활용
3. **sf CLI** — `sf project deploy start`, `sf project retrieve start` 명령어로 래핑

---

## 관련 노트

- [[Metadata API Quick Start]]
- [[Metadata API File-Based 호출]]
- [[Metadata API CRUD 호출]]
- [[Metadata API REST]]
- [[Metadata API Result Objects]]
- [[Metadata API Headers]]
- [[Salesforce DX 개요]]
- [[Metadata API 에러 처리]]
- [[Metadata API MCP Tool]]
- [[Metadata Types — 개요 및 분류]]
