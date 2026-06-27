---
tags: [slds, slds2, tools, figma, cli, reference]
source: SLDS2-Docs — lightningdesignsystem.com (SLDS 2 v2.30.4, Tier 2)
created: 2026-06-13
aliases: [SLDS Tools, SLDS 도구, Figma Kit, SLDS Linter, SLDS Validator]
---

# SLDS 2 도구 (Tools)

> 출처: [SLDS 2 · Tools](https://www.lightningdesignsystem.com/2e1ef8501/p/05b46d-tools) 및 하위 2개(Figma Kits, Code Tools)
> 디자이너·엔지니어가 SLDS로 일관된 경험을 효율적으로 만들기 위한 도구 모음입니다.

## 1. Figma Kits (디자이너용)

Figma는 Salesforce 디자인 프로세스의 중심입니다. UI 라이브러리의 컴포넌트를 드래그&드롭해 프로토타이핑하고, 라이브러리 업데이트를 따라가며 시스템 정합성을 유지합니다.

**SLDS 2 라이브러리**
- 🆕 **SLDS 2 Style Guide** — 새 Lightning UI의 시각 언어 가이드(Salesforce를 닮은 커스텀 UI 제작 시 유용).
- 🆕 **SLDS 2 Web Components UI Library** — 웹용 전체 컴포넌트 라이브러리.
- 🆕 **Pattern: Agentic Experience** — 생성형 AI 인터페이스 디자인용.
- 🆕 **Pattern: Builder** — 앱·프로세스 빌더 디자인용.

**SLDS 1 라이브러리(참고)**
- Foundations: SLDS 1 Typography / Color / Icons
- Components for Web (SLDS 1)
- Patterns: Builder, Confetti, Console UI, Charts (모두 Beta)

## 2. Code Tools (개발자용)

SLDS 준수 코드를 일관·확장·접근성 있게 작성하도록 돕는 도구 모음입니다.

- **SLDS Linter** (beta) — 코드를 **SLDS 2 규칙**에 대조 분석하는 설치형 npm 패키지.
  ```bash
  npx @salesforce-ux/slds-linter lint
  ```
- **SLDS Validator** — SLDS 준수 코드를 돕는 **VS Code 확장**.
- **SLDS Scope Customizer** — SLDS 정적 리소스의 CSS scope를 커스터마이즈하는 커맨드.
- **SLDS 2 AI Starter Kit** — Salesforce 경험을 프로토타이핑하는 로컬 개발 템플릿.

**추가 리소스**
- Download SLDS 1 / SLDS 1 Starter Kit — SLDS 1 다운로드·브라우저 프로토타이핑(아직 SLDS 2 다운로드 전략은 준비 중).
- Lightning Web Components — 컴포넌트 JS/HTML/CSS 코드 보기 및 출력 미리보기.
- AI Tools — Agentforce 연동 등 AI 기반 개발.

---

### 관련 문서
- 모범 사례: `SLDS2-Best-Practices.md` · 스타일링 훅: `SLDS2-Styling-Hooks.md`
- 유틸리티/컴포넌트: `SLDS-Utilities.md` · `components.html` · `blueprints-index.html`

### 출처 링크
- [Tools 개요](https://www.lightningdesignsystem.com/2e1ef8501/p/05b46d-tools) · [Figma Kits](https://www.lightningdesignsystem.com/2e1ef8501/p/2963ba-figma-kits) · [Code Tools](https://www.lightningdesignsystem.com/2e1ef8501/p/3427aa-code-tools)

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] — SLDS Linter·Agent Skills 도구 체인을 로컬 프로젝트에 적용한 예
- [[SLDS 2 Starter Kit - 저장소 설정과 배포 스킬]] — `gh` CLI·GitHub Pages 배포를 안내하는 동봉 Agent Skill 2종(repo-setup·first-time-deploy)
- [[LWC MOC]]
