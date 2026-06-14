# Salesforce의 Lightning App Builder

## 1. Lightning App Builder란?

코드 작성 없이 Lightning 페이지를 만들고 커스터마이징할 수 있는 드래그 앤 드롭 도구입니다. 레이아웃을 구성하고 컴포넌트를 추가해 사용자 경험을 향상시킵니다.

**주요 기능:** 포인트 앤 클릭 커스터마이징(코딩 불필요), 드래그 앤 드롭 컴포넌트, 표준·커스텀 컴포넌트 지원, Lightning Experience·모바일에서 사용 가능.

## 2. Lightning 페이지 유형

필요에 따라 다양한 유형의 Lightning 페이지를 만들 수 있습니다(App Page, Record Page, Home Page).

## 3. Lightning App Builder의 컴포넌트

Lightning 페이지는 컴포넌트로 구성됩니다. Standard, Custom, 또는 Third-Party(AppExchange) 컴포넌트가 있습니다.

**표준 컴포넌트:** Recent Items(최근 접근 레코드), Related Lists(관련 레코드), Report Chart(리포트 차트 임베드), Rich Text(텍스트·이미지), Tabs(섹션 정리).

**커스텀 컴포넌트:** Lightning 컴포넌트(Aura/LWC, 개발자가 구축), 서드파티 컴포넌트(AppExchange에서 설치).

## 4. Lightning 페이지 생성

1단계 - Lightning App Builder 열기: Setup → Lightning App Builder 검색 → New Lightning Page.
2단계 - 페이지 유형 선택: App Page(앱용), Record Page(Account·Lead 등 오브젝트용), Home Page(사용자 대시보드용).
3단계 - 컴포넌트 추가: 컴포넌트 드래그 앤 드롭(표준/커스텀) → 속성 구성 → 동적 가시성을 위한 필터 추가.
4단계 - 페이지 할당 & 활성화: App·Profile·Record Type 선택 → Save & Activate.

## 5. Dynamic Forms & Dynamic Actions

**Dynamic Forms란?** 사용자 프로필, 레코드 값, 기기 유형에 따라 필드를 조건부로 표시해 레코드 페이지를 커스터마이징합니다. 예: "Discount Field"를 영업 관리자에게만 표시, Case가 High Priority일 때만 "Escalation Reason" 표시.

**Dynamic Actions란?** 조건에 따라 버튼을 표시/숨김합니다. 예: "Approve" 버튼을 관리자에게만 표시, 상태가 "Pending"일 때만 "Escalate Case" 표시.

## 모범 사례

- Dynamic Forms & Actions 사용(관련 필드·버튼만 표시)
- Tabs로 컴포넌트 정리(레코드 페이지 정돈)
- 모바일 친화적으로 유지
- 활성화 전 다양한 사용자 역할로 테스트
- Report Chart 사용(대시보드 임베드로 더 나은 인사이트)
