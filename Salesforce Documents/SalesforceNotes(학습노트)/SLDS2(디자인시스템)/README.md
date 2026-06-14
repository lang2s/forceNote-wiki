# SLDS 2 한국어 문서 허브

Salesforce Lightning Design System 2(SLDS 2)를 공식 자료 기반으로 한국어로 정리한 통합 문서 모음입니다.

> **시작점:** `index.html` 을 브라우저로 열면 모든 문서로 가는 마스터 인덱스가 나옵니다.

## 폴더 구조

```
SLDS2-Docs/
├─ index.html                 ← 마스터 인덱스 (여기서 시작)
├─ README.md                  ← 이 파일
│
├─ components.html            ← 컴포넌트 카탈로그(86개, 모양 미리보기)
├─ components/                ← 컴포넌트별 상세 86개 (.md)
│     예) lightning-button.md, lightning-datatable.md …
│         (설명 + 예제 + 전체 Specification 표 + 공식 링크)
│
├─ blueprints-index.html      ← 블루프린트 카탈로그(30개, CSS 전용)
├─ blueprints/                ← 블루프린트별 상세 30개 (.md)
│
├─ SLDS-Utilities.md          ← 유틸리티 클래스 24종(실제 CSS + HTML 예시)
├─ SLDS2-Styling-Hooks.md     ← 스타일링 훅(CSS 변수) 종류·사용법
├─ SLDS2-Best-Practices.md    ← SLDS 2 개발 모범 사례(3단계 모델 등)
├─ SLDS2-Tools.md             ← Figma 키트 / 코드 도구
├─ SLDS2-Accessibility.md     ← 접근성(WCAG AA) 체크리스트 + 하위 5주제
│
├─ SLDS2-Patterns.md          ← UX 디자인 패턴 개요(원칙 4 + 21개 색인)
└─ patterns/                  ← 패턴별 상세 21개 (.md)
```

## 구성 요약

| 영역 | 개수 | 위치 |
|---|---|---|
| Lightning Base Components | 86 | `components.html` + `components/` |
| Component Blueprints (CSS) | 30 | `blueprints-index.html` + `blueprints/` |
| Utilities | 24 | `SLDS-Utilities.md` |
| 디자인 패턴 | 21 | `SLDS2-Patterns.md` + `patterns/` |
| 파운데이션 | 4 | Styling Hooks · Best Practices · Tools · (Utilities) |
| 접근성 | 5+ | `SLDS2-Accessibility.md` |

## 기준·출처

- 기준 버전: **SLDS 2** / npm `@salesforce-ux/design-system` **v2.30.4**
- 컴포넌트 명세: Salesforce Lightning Component Reference (cx-router 메타데이터)
- 디자인/패턴/접근성: lightningdesignsystem.com (SLDS 2)
- 본 문서는 공식 자료를 한국어로 정리·요약한 **비공식 참고 자료**입니다. 정확한 최신 정보는 각 문서 내 공식 링크를 확인하세요.
- `.md` 파일은 마크다운 뷰어/편집기에서, `.html` 파일은 브라우저에서 열어 보세요.
