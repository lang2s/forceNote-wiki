---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Schema Builder in Salesforce]
---

# Salesforce의 Schema Builder

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Schema Builder란?

데이터 모델(오브젝트, 필드, 관계)을 대화형 드래그 앤 드롭 인터페이스로 보고, 설계하고, 수정할 수 있는 시각적 도구입니다.

**특징:** 그래픽 표현(오브젝트·관계 시각화), 드래그 앤 드롭 커스터마이징(코딩 없이 오브젝트·필드 생성·수정), 실시간 업데이트, 표준·커스텀 오브젝트 지원, 필터 옵션(특정 오브젝트 표시/숨김).

**사용 예:** 복잡한 조직의 오브젝트 관계 시각화, Object Manager 없이 커스텀 오브젝트·필드 생성, 개발자·관리자를 위한 데이터 구조 이해.

## 2. 접근 방법

1. Setup → Schema Builder 검색
2. Schema Builder 클릭
3. 필터로 표시할 오브젝트 선택
4. 필드·오브젝트를 드래그 앤 드롭해 스키마 수정

## 3. 오브젝트·필드 생성

1단계 - Schema Builder 열기: Setup → Schema Builder 검색 → Elements 패널(왼쪽 사이드바) 선택.
2단계 - 새 오브젝트 생성: New Object를 캔버스로 드래그 → Label, Plural Label, API Name 입력 → Record Name·데이터 타입 설정 → Save.
3단계 - 필드 추가: New Field를 오브젝트로 드래그 → 필드 타입 선택(Text, Number, Picklist 등) → 필드 설정 구성(Required, Unique, Default Value) → Save.

## 모범 사례

- 필터 사용(명확성을 위해 관련 오브젝트만 표시)
- 관계 먼저 계획(불필요한 복잡성 회피)
- 명명 규칙 일관성 유지
- 배포 전 샌드박스에서 테스트
- 너무 많은 Lookup·Master-Detail 회피(성능 영향)
