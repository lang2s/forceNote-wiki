---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Change Sets & Sandboxes in Salesforce]
---

# Salesforce의 Change Set과 Sandbox

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Sandbox란?

Sandbox는 라이브 데이터에 영향을 주지 않고 개발·테스트·교육에 사용하는 운영 환경의 사본입니다.

**유형 사용 예:**
- Developer Sandbox — 커스텀 코드 테스트
- Partial Copy Sandbox — UAT(사용자 인수 테스트)
- Full Sandbox — 실제 데이터로 성능 테스트

**생성 단계:**
1. Setup → Sandboxes 검색
2. New Sandbox 클릭
3. 이름·설명 입력
4. 유형 선택(Developer, Partial, Full 등)
5. 데이터 설정 선택(Metadata, Sample Data, Full Data)
6. Create → 준비될 때까지 대기

## 2. Change Set이란?

한 Salesforce 환경에서 다른 환경으로(예: Sandbox → Production) 커스터마이징을 배포하는 데 사용하는 도구입니다.

**특징:**
- 메타데이터 배포(데이터 아님) — 오브젝트, 필드, 플로우 등 포함
- Outbound 및 Inbound Change Set 사용
- 배포 이력 추적
- 조직 간 연결 필요

**사용 예:** 커스텀 오브젝트·필드를 Sandbox에서 Production으로 이동, Flow나 검증 규칙 배포, 개발 후 Lightning 컴포넌트 마이그레이션.

**배포 방법:**

1단계: Outbound Change Set 생성(소스 조직 - Sandbox)
1. Setup → Outbound Change Sets 검색
2. New → 이름·설명 지정
3. Add Components 클릭
4. 메타데이터 컴포넌트 선택(오브젝트, 필드, 플로우 등)
5. Upload to Destination Org(Production)

2단계: Inbound Change Set 배포(대상 조직 - Production)
1. 대상 조직(Production)에 로그인
2. Inbound Change Sets로 이동
3. Validate & Deploy
4. 배포 상태 검토

## 모범 사례

- 코딩에는 Developer Sandbox 사용(개발 분리)
- 테스트에는 Partial Copy 사용(현실적 테스트용 샘플 데이터 포함)
- 항상 Sandbox에서 먼저 테스트(운영에 직접 배포 금지)
- 작은 배치로 배포(대규모 배포 오류 방지)
- 먼저 Change Set Validation 사용(최종 확정 전 성공 여부 확인)
