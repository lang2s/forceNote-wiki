---
tags: [index, lwc, ui-patterns]
created: 2026-05-17
---

# UIPatterns(UI패턴) — 로컬 인덱스

> LWC UI 공통 패턴 — Toast, 모달, 에러 표시, 공유 JS, Static Resource, 파일 처리

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Lightning Base Components 레퍼런스]] | lightning-* 전체 컴포넌트 목록, 속성·이벤트 빠른 참조 | #reference |
| [[Toast & 모달 패턴]] | ShowToastEvent variant, LightningModal open/close | #pattern |
| [[에러 패널 패턴]] | errorPanel, reduceErrors, 에러 타입별 표시 | #pattern |
| [[공유 JS 모듈]] | named export, isExposed: false, c/ 네임스페이스 공유 함수 | #pattern |
| [[Static Resource 로딩]] | loadScript/loadStyle, renderedCallback 3-state | #pattern |
| [[파일 업로드와 이미지 처리]] | processImage, FileReader→base64, ContentVersion URL | #pattern |
| [[SLDS LWC 디자인 시스템]] | SLDS 1·SLDS 2 CSS Styling Hook, Design Token, 다크 모드, 밀도 인식 — Winter '26 GA | #reference |
| [[CRM Analytics 대시보드용 LWC]] | analytics__Dashboard 타깃, step 쿼리 주입, hasStep, bindings 동적 속성 | #reference |
| [[LWR Sites (Experience Cloud)]] | Experience Cloud LWR 사이트, lightningCommunity__ 타깃, --dxp 브랜딩 훅 | #reference |
| [[LWR 다국어 사이트]] | 멀티링궐 LWR — 언어 추가·fallback·자동감지·번역 export/import·제약 | #reference |
| [[LWR Expressions 레퍼런스]] | LWR 표현식 — Data Binding·Other Expressions·제약 | #reference |
| [[LWR 동작·캐싱·제약]] | LWR 퍼블리싱 모델·캐싱·커스텀 URL·head markup·Light DOM·Template Limitations | #reference |
| [[LWR 컴포넌트 개발 심화]] | LWR 컴포넌트 개발 — js-meta.xml targets·targetConfigs·@salesforce 모듈·화면 크기 반응형·커스텀 레이아웃/내비게이션 | #reference |
| [[LWR --dxp 스타일링 훅 레퍼런스]] | LWR 브랜딩 — --dxp-g/-s/-c 스타일링 훅·Theme 패널 속성 매핑·커스텀 폰트·Remove SLDS·컴포넌트 브랜딩 오버라이드 | #reference |
| [[LWR Tag Manager 데이터 관리]] | LWR 데이터 관리 — Experience/Google Tag Manager·experience_interaction·Tag Manager Event Reference·Consent·Website Engagement DMO → Data Cloud | #reference |
| [[Lightning Out 2.0 (외부 앱 임베드)]] | 비-Salesforce 외부 앱에 LWC 임베드 — LWR 기반·frontdoor-url·app-id·closed shadow DOM iframe·lo.application.ready·window.postMessage (Lightning Out beta 대체 GA) | #reference |
| [[LWC 드래그앤드롭 패턴 (HTML5 dataTransfer)]] | HTML5 drag & drop — draggable·ondragstart/ondragover/ondrop·dataTransfer setData/getData·effectAllowed/dropEffect·setDragImage, SObject 직렬화로 컴포넌트 간 레코드 전달 | #pattern |

---

## 빠른 선택

- 어떤 컴포넌트 쓸지 모를 때? → [[Lightning Base Components 레퍼런스]]
- 성공/실패 알림 메시지? → [[Toast & 모달 패턴]]
- 확인 다이얼로그, 모달 창? → [[Toast & 모달 패턴]]
- Apex/LDS 에러 표시 컴포넌트? → [[에러 패널 패턴]]
- 여러 컴포넌트 공통 JS 로직? → [[공유 JS 모듈]]
- 서드파티 라이브러리 (Chart.js 등)? → [[Static Resource 로딩]]
- 이미지 업로드, 파일 처리? → [[파일 업로드와 이미지 처리]]
- SLDS 스타일·디자인 토큰·다크 모드? → [[SLDS LWC 디자인 시스템]]
- CRM Analytics 대시보드에 커스텀 위젯? → [[CRM Analytics 대시보드용 LWC]]
- Experience Cloud LWR 사이트 컴포넌트·브랜딩? → [[LWR Sites (Experience Cloud)]]
- LWR 사이트 다국어·번역? → [[LWR 다국어 사이트]]
- LWR 표현식·{!Route}·동적 데이터? → [[LWR Expressions 레퍼런스]]
- LWR 캐싱·퍼블리싱·제약·미지원 기능? → [[LWR 동작·캐싱·제약]]
- LWR 커스텀 컴포넌트 개발·js-meta.xml targets·반응형·커스텀 레이아웃/내비? → [[LWR 컴포넌트 개발 심화]]
- LWR 사이트 색상·폰트·브랜딩·--dxp 스타일링 훅? → [[LWR --dxp 스타일링 훅 레퍼런스]]
- LWR 사이트 인터랙션 추적·Google Tag Manager·Data Cloud 데이터 전송? → [[LWR Tag Manager 데이터 관리]]
- 외부(비-Salesforce) 사이트/앱에 LWC를 임베드? → [[Lightning Out 2.0 (외부 앱 임베드)]]
- 드래그앤드롭으로 레코드/아이템 옮기기? → [[LWC 드래그앤드롭 패턴 (HTML5 dataTransfer)]]
