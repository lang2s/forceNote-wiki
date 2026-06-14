---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Sandbox and Deployment]
---

# Sandbox와 Deployment

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Sandbox란?

운영(라이브) 인스턴스에 영향을 주지 않고 새 구성, 코드, 자동화를 테스트할 수 있게 해주는 테스트·개발 환경입니다. 일부 또는 모든 메타데이터·데이터를 가진 운영 조직의 복제본입니다.

- **메타데이터:** 오브젝트의 구조와 구성(필드, 타입, 관계, 권한, 속성).
- **데이터:** 오브젝트에 저장된 실제 레코드(고객 정보, 영업 데이터 등).

라이프사이클: 계획(Plan) → 구축(Build) → 테스트(Test) → 배포(Deploy) → 릴리스(Release).

**사용 사례:** 개발(앱·자동화 구축·테스트), 테스트(단위·통합·UAT), 교육(안전한 직원 교육 환경), 데이터 마이그레이션(운영 적용 전 임포트·통합 테스트).

**환경 유형:** Production → 라이브(login.salesforce.com), 개발·테스트 → test.salesforce.com(샌드박스).

## 샌드박스 유형

- **Developer Sandbox:** 개발·테스트용 기본 샌드박스.
- **Developer Pro Sandbox:** Developer와 유사하나 더 큰 데이터 저장 용량.
- **Partial Copy Sandbox:** 메타데이터와 데이터 일부 포함(샌드박스 템플릿 사용).
- **Full Sandbox:** 운영의 정확한 복제본.

## Sandbox 새로 고침(Refresh)

현재 운영 메타데이터와 선택적으로 데이터를 샌드박스로 복사해 운영 환경의 복제본으로 만드는 것입니다. 샌드박스의 org ID는 매번 변경됩니다. 최신 운영 데이터·메타데이터로 업데이트하려면 새로 고침이 필요합니다. 빈도: Developer는 하루 1회, Developer Pro도 하루 1회.

## Partial Copy Sandbox에 포함되는 것

- **구성(Configuration):** 워크플로우 규칙, 검증 규칙, 오브젝트 스키마(커스텀 오브젝트·필드·관계), 페이지 레이아웃, 프로필.
- **메타데이터:** Apex 클래스·트리거·Visualforce 페이지, Lightning 컴포넌트, Custom Settings, 리포트·대시보드.
- **Apex 클래스:** 모든 코드 복사(현실적 환경에서 코드 변경 테스트에 유용).
- **사용자:** 운영의 모든 사용자 레코드 포함(비밀번호 없이 복사 — 로그인하려면 재설정 필요).
- **레코드(선택 오브젝트의 샘플):** 샌드박스 템플릿이 정의한 데이터 일부 복사(예: Account 10,000개). 템플릿에 포함된 오브젝트의 레코드 간 관계 유지.

참고: 샌드박스 템플릿이 하나도 없으면 Partial Copy Sandbox 생성 시 NEXT 버튼이 보이지 않습니다.

## Deployment Setting이란?

개발 완료 후 한 환경에서 다른 환경으로 변경을 이동합니다. Deployment Settings는 한 조직의 변경·컴포넌트를 다른 조직으로 어떻게 배포할지 결정합니다.

## 연결(Connection) 유형

Change Set과 관련된 두 개념:

1. **Allow Inbound Changes:** 샌드박스나 운영 조직이 다른 조직으로부터 change set을 받을 수 있게 함. 특정 조직이 변경을 보낼 수 있도록 배포 설정 구성 필요(예: Sandbox → Production). 보통 Deployment Connections에서 관리. 예: QA 샌드박스가 Developer 샌드박스로부터 변경 수신.

2. **Accept Outbound Changes:** 샌드박스나 조직이 연결된 다른 조직으로 change set을 보냄. 보내는 조직은 받는 조직과 유효한 배포 연결이 있어야 함. 예: UAT 샌드박스가 QA 샌드박스로부터 변경 수신.
