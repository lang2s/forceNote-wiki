---
tags: [devops, metadata, metadata-coverage, scratch-org, source-tracking, unlocked-package]
source: sfdx_dev.pdf v67.0 Summer '26 — Ch.5 (p.71)
created: 2026-05-23
aliases: [Metadata Coverage, 메타데이터 커버리지 보고서, metadata coverage report, 소스 추적 지원 메타데이터]
---

# Metadata Coverage 보고서

> Metadata Coverage 보고서는 각 채널(Metadata API·Scratch Org Source Tracking·Unlocked Package·Managed Package 등)에서 지원되는 메타데이터 타입을 확인하는 공식 소스이다.

---

## 개요

Metadata Coverage 보고서는 Salesforce DX 생태계에서 메타데이터가 **어떤 채널에서 지원되는지** 확인하는 단일 공식 참조점이다.

### 보고서가 커버하는 채널

| 채널 | 설명 |
|---|---|
| Metadata API | SOAP/REST 기반 메타데이터 배포·검색 |
| Scratch Org Source Tracking | sf project deploy/retrieve 소스 추적 |
| Unlocked Packages | 2GP Unlocked Package 포함 가능 여부 |
| Second-Generation Managed Packages (2GP) | 2세대 관리 패키지 포함 가능 여부 |
| Classic (1st-generation) Managed Packages | 1세대 관리 패키지 포함 가능 여부 |
| Other channels | 신규 채널은 보고서에서 지속 업데이트 |

---

## 보고서 접근 방법

```
https://mdcoverage.secure.force.com/docs/metadata-coverage
```

또는 Salesforce 공식 문서 내 "Metadata Coverage report" 링크에서 접근.

- 항상 **최신 API 버전** 기준으로 표시된다.
- 이 보고서는 `Metadata API Developer Guide` > Metadata Types 섹션과 연동된다.

---

## 실무 활용 패턴

```bash
# Scratch Org Source Tracking이 특정 메타데이터 타입을 지원하는지 확인
# → Metadata Coverage Report에서 해당 타입 검색
# → "Scratch Org Source Tracking" 열이 ✓인지 확인

# 예: CustomLabel이 Unlocked Package에 포함 가능한지
# → "Unlocked Packages" 열 확인
```

### Scratch Org에서 지원 여부 확인이 필요한 경우

- `sf project deploy start` 또는 `sf project retrieve start` 실행 시 특정 메타데이터 타입이 무시되거나 오류가 나는 경우
- `project-scratch-def.json`에서 특정 Feature를 활성화했음에도 관련 메타데이터가 추적되지 않는 경우

---

## Hard-Deleted Components (이전 위치)

> 이 챕터에 포함되었던 "Hard-Deleted Components in Unlocked Packages" 정보는 **Unlocked Packages 섹션으로 이동**되었다. 자세한 내용은 [[Unlocked Package 개발과 버전]] → Hard-Deleted Components 참조.

---

## 관련 노트
- [[Salesforce DX 개요]] — DX 전체 개요
- [[DX 도구 개요와 워크플로 전환]] — DX 시작 경로와 워크플로
- [[메타데이터 분해와 forceignore]] — Decomposed Metadata Types 전수
- [[Unlocked Package 개발과 버전]] — Hard-Deleted Components 포함
- [[Source Tracking 변경 추적]] — Scratch Org Source Tracking 동작 방식
- [[MetadataAPI(메타데이터API)/Metadata Types — 개요 및 분류]] — 300+ 메타데이터 타입 전수 목록
