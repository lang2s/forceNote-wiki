---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Record Types & Page Layouts in Salesforce]
---

# Salesforce의 Record Type과 Page Layout

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Record Type이란?

같은 오브젝트에 대해 서로 다른 비즈니스 프로세스, 선택 목록 값, 페이지 레이아웃을 만들 수 있게 합니다.

**왜 사용하나요?**
- 사용자 역할이나 비즈니스 요구에 따라 다른 필드·선택 목록·레이아웃 표시
- 단일 오브젝트 내에서 여러 비즈니스 프로세스 지원(예: B2B와 B2C의 서로 다른 영업 프로세스)
- 사용자별 기본값과 가시성 제어

예: 제품과 서비스를 모두 판매하는 회사에서, 제품 관련 Opportunity는 서비스와 다른 필드가 필요. Record Type으로 각각 다른 레이아웃과 선택 목록 옵션 제공.

## 2. Page Layout이란?

레코드의 UI를 제어합니다: 페이지에 나타나는 필드, 필수 필드, 버튼 가시성(편집·삭제·복제 등), 관련 목록(Contact·Activity·Case 등).

예: 영업팀은 "Lead Source"와 "Opportunity Amount" 필드가 필요하고, 지원팀은 "Case Status"와 "Priority"가 필요. Page Layout으로 팀별 다른 뷰 제공.

## Record Type 생성

1단계 - 오브젝트에 Record Type 활성화: Setup → Object Manager → 오브젝트 선택(예: Opportunity, Lead, Case) → Record Types → New.
2단계 - Record Type 세부 정보 정의: 이름 입력(예: "B2B Opportunity"), 설명 입력, 기존 Record Type 복제(선택), 프로필에 활성화(어떤 사용자가 사용할지 선택), Next.
3단계 - Page Layout 할당: 이 Record Type의 페이지 레이아웃 선택 → Save.

## Page Layout 생성

1단계 - Page Layout으로 이동: Setup → Object Manager → 오브젝트 선택 → Page Layouts → New.
2단계 - 레이아웃 커스터마이징: 필드·섹션·버튼·관련 목록 드래그 앤 드롭, 필요 시 필드를 필수로 표시, 불필요한 필드 제거 → Save.
3단계 - Record Type·Profile에 할당: Page Layout Assignment → Edit Assignment → 어떤 레이아웃이 어떤 Record Type·Profile에 적용되는지 선택 → Save.

## 모범 사례

- 단순하게 유지(필요할 때만 사용해 복잡성 회피)
- 명명 규칙 사용(예: "B2B Lead" vs "B2C Lead")
- 선택 목록 값 제한(Record Type별 커스터마이징으로 데이터 깔끔하게)
- Page Layout 최적화(팀별 관련 필드만 표시)
- 배포 전 샌드박스에서 테스트
