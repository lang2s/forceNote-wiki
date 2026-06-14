---
tags: [lwc, experience-cloud, lwr, sites, community, dxp]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud v66.0, Spring '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/
created: 2026-06-14
aliases: [LWR Sites, Experience Cloud LWR, Build Your Own LWR, Microsite, lightningCommunity__Page, dxp styling hooks, --dxp, Experience Builder LWC]
---

# LWR Sites (Experience Cloud)

> **Lightning Web Runtime(LWR)** + LWC 프로그래밍 모델로 만드는 고성능 Experience Cloud 사이트. **Build Your Own (LWR)**·**Microsite (LWR)** 템플릿. Aura 사이트보다 빠르고, 커스텀 LWC·테마/페이지 레이아웃·`--dxp` 브랜딩 훅을 지원.

> [!note] *LWR Sites for Experience Cloud v66.0* 전수. 📖 공식: [LWR Sites for Experience Cloud](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/)

---

## LWR이란

- **Build Your Own (LWR)** · **Microsite (LWR)** 템플릿 = 웹사이트·포털·마이크로사이트를 LWC로 구축. 코어 Web Components 표준 기반이라 경량·고성능.
- Aura 기반 사이트와 다른 런타임 — **새 퍼블리싱 모델·커스텀 URL 경로·Lightning Web Security·캐싱 정책·head markup**.

---

## 컴포넌트 개발 — meta 타깃 (전수)

각 LWC 폴더에 `<component>.js-meta.xml` 필요. Experience Builder용 design 설정값 정의. LWR 템플릿용으로 2개 타깃이 추가됨.

| 타깃 | 용도 |
|---|---|
| `lightningCommunity__Page` | 드래그앤드롭 컴포넌트(LWR·Aura 사이트 페이지). Components 패널에 표시 |
| `lightningCommunity__Page_Layout` | **(LWR 신규)** 페이지 레이아웃으로 사용. Page Layout 창에 표시 |
| `lightningCommunity__Theme_Layout` | **(LWR 신규)** 테마 레이아웃으로 사용. Settings > Theme에 표시 |
| `lightningCommunity__Default` | `Page` 또는 `Theme_Layout`과 함께 사용 — 모든 위치에서 사용 가능하게 |

```xml
<!-- helloSite.js-meta.xml — LWR 사이트 페이지 컴포넌트 -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>67.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>Hello Site</masterLabel>
    <targets>
        <target>lightningCommunity__Page</target>
        <target>lightningCommunity__Default</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightningCommunity__Default">
            <property name="greeting" type="String" label="Greeting" />
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

### LWR 컴포넌트에서 쓸 수 있는 것
- **User Interface API** (레코드 데이터)
- **`@salesforce` 모듈**: `userPermission/`·`customPermission/`·`staticResource/`·`contentAsset/`·일부 `i18n` 속성
- **Lightning Navigation** (사이트 내 페이지 이동)
- **반응형**: 커스텀 LWC를 화면 크기 반응형으로 (`--dxp-c-screensize-property` 등)
- **커스텀 레이아웃·내비게이션 메뉴 컴포넌트** 작성 가능
- ⚠️ **Base Lightning Component Limitations** — 일부 `lightning-*` 베이스 컴포넌트는 LWR 사이트에서 제한/미지원

---

## 브랜딩 — `--dxp` 스타일링 훅

LWR 사이트는 SLDS의 `--slds-*`가 아니라 **`--dxp-*`** (Digital Experience Platform) 훅으로 브랜딩한다. Theme 패널 속성과 매핑됨.

| 분류 | 예시 훅 |
|---|---|
| **전역(Global) `--dxp-g-*`** | `--dxp-g-brand`, `--dxp-g-brand-contrast`, `--dxp-g-brand-1~3` (브랜드 색 팔레트) |
| **컴포넌트(Component) `--dxp-c-*`** | `--dxp-c-section-content-spacing-block-start/end`, `--dxp-c-section-columns-max-width`, `--dxp-c-l/m/s-banner-alignment`(화면 크기별) |

- **색상·텍스트·사이트 간격** 훅으로 테마 제어, 커스텀 컴포넌트에서도 `var(--dxp-...)` 사용
- 커스텀 CSS로 컴포넌트 브랜딩 오버라이드, 색 팔레트(섹션/컬럼), 사이트 로고 컴포넌트, **커스텀 폰트** 추가
- **Remove SLDS** — SLDS 스타일을 제거하고 완전 커스텀 CSS 적용 가능

---

## 차이·제약 (Aura 사이트 대비)

- 새 **퍼블리싱 모델**, **커스텀 URL 경로**, **Lightning Web Security** 적용, **캐싱 정책**, **head markup** 커스터마이즈
- **LWR Template Limitations** — 일부 표준 기능/컴포넌트 미지원(가이드 참조)

## 다국어

- LWR 사이트에 언어 추가 → 멀티링궐 사이트. (`@salesforce/i18n` 일부 속성 활용)

---

## 관련 노트

- 📖 공식: [LWR Sites for Experience Cloud](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/)
- [[LWC API 버전 관리]] — `.js-meta.xml` targets/targetConfigs 구조
- [[SLDS LWC 디자인 시스템]] — `--slds-*` 훅 (LWR은 `--dxp-*` 사용)
- [[NavigationMixin 패턴]] — Lightning Navigation
- [[CRM Analytics 대시보드용 LWC]] — 다른 LWC 타깃 surface
- [[LWC MOC]]
