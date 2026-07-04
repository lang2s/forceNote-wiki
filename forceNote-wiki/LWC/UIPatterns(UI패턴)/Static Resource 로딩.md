---
tags: [lwc, static-resource, loadScript, loadStyle, pattern]
source: [dreamhouse-lwc/propertyListMap, "Salesforce LWC Guide — Create Static Resources (developer.salesforce.com/docs/platform/lwc/guide/create-resources.html) — Tier 2"]
created: 2026-05-17
aliases: [loadScript, loadStyle, Static Resource, 서드파티 라이브러리]
---

# Static Resource 로딩 패턴

> 서드파티 JS/CSS 라이브러리(Leaflet, Chart.js 등)를 LWC에서 로드하는 패턴. `renderedCallback`에서 3-state 상태 기계를 사용해 중복 로드를 방지.

---

## 3-State 상태 기계

```javascript
const LEAFLET_NOT_LOADED = 0;
const LEAFLET_LOADING    = 1;
const LEAFLET_READY      = 2;
```

중복 로드 방지 핵심: `renderedCallback`은 매 렌더링마다 호출되므로 상태 체크가 필수.

---

## 전체 패턴

```javascript
import { LightningElement, wire } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LEAFLET from '@salesforce/resourceUrl/leafletjs';

const NOT_LOADED = 0, LOADING = 1, READY = 2;

export default class PropertyListMap extends LightningElement {
    leafletState = NOT_LOADED;
    map;

    async renderedCallback() {
        if (this.leafletState === NOT_LOADED) {
            await this.initializeLeaflet();
        }
    }

    async initializeLeaflet() {
        try {
            this.leafletState = LOADING;

            // JS + CSS 동시 로드
            await Promise.all([
                loadScript(this, `${LEAFLET}/leaflet.js`),
                loadStyle(this, `${LEAFLET}/leaflet.css`)
            ]);

            // DOM 요소에 라이브러리 초기화
            const mapElement = this.template.querySelector('.map');
            this.map = L.map(mapElement, { zoomControl: true, tap: false });
            this.map.setView([37.5665, 126.978], 12);

            // OpenStreetMap 타일 레이어
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '© OpenStreetMap'
            }).addTo(this.map);

            this.leafletState = READY;
            this.displayData(); // 데이터 렌더링
        } catch (error) {
            const message = error.message || error.body?.message;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error loading library',
                message,
                variant: 'error'
            }));
        }
    }

    displayData() {
        if (this.leafletState !== READY) return; // 로드 전 호출 방어
        // ... 라이브러리 API 사용
    }
}
```

---

## 경로 구성

```javascript
import LEAFLET from '@salesforce/resourceUrl/leafletjs';
// LEAFLET = '/resource/leafletjs'

// 폴더형 Static Resource는 경로 이어붙이기
loadScript(this, `${LEAFLET}/leaflet.js`);   // /resource/leafletjs/leaflet.js
loadStyle(this,  `${LEAFLET}/leaflet.css`);   // /resource/leafletjs/leaflet.css
```

| 구조 | 경로 |
|---|---|
| 단일 파일 | `import LIB from '@salesforce/resourceUrl/mylib'` → LIB 그대로 사용 |
| ZIP 폴더 | `${LIB}/path/to/file.js` |

---

## 전역 변수 접근

서드파티 라이브러리가 전역 변수(`L`, `Chart` 등)를 등록하면:

```javascript
/* global L */   // ESLint 경고 억제
import { LightningElement } from 'lwc';

// loadScript 완료 후 전역 사용 가능
const marker = L.marker([lat, lng]);
```

---

## ⚠️ 한도 — Static Resource 크기 (업로드 블로커)

| 한도 | 값 |
|---|---|
| 단일 Static Resource 최대 크기 | **5 MB** |
| org 전체 Static Resource 합계 | **250 MB** |

> 공식 문서: *"The maximum file size is 5 MB. An org can have up to 250 MB of static resources."*

Leaflet·Chart.js처럼 큰 라이브러리를 업로드할 때, 특히 소스맵·에셋을 포함한 배포용 zip은 **5 MB를 넘어 업로드 자체가 막히는** 경우가 많다. 회피책:

- **minify된 배포본만** 사용 (`.min.js` / `.min.css`) — 개발용 비압축 버전·소스맵 제외
- zip에는 **런타임에 실제로 필요한 파일만** 포함 (docs·examples·테스트·`.map` 파일 제거)
- 라이브러리를 여러 개 올릴 경우 org 합계 **250 MB** 상한도 함께 관리 (초과 시 신규 업로드 실패)
- CDN을 대체 수단으로 쓸 수 없으므로(외부 CDN 직접 사용 불가), 필수 파일만 추린 zip으로 5 MB 이내를 맞추는 것이 유일한 경로

---

## 주의사항

| 항목 | 내용 |
|---|---|
| CSP Trusted Site | 외부 URL 타일/API 사용 시 필요 (`isApplicableToImgSrc` 등) |
| Static Resource 업로드 | 외부 CDN 직접 사용 불가 — 항상 Static Resource로 업로드 후 사용 |
| Static Resource 크기 한도 | 단일 5 MB / org 합계 250 MB (위 "한도" 소절 참조) |
| `this.template.querySelector` | `renderedCallback` 이후에만 DOM 접근 가능 |
| 오류 처리 | `error.message` 또는 `error.body?.message` 둘 다 확인 |

---

## 관련 노트

- [[CSP와 RemoteSite]]
- [[LWC 보안 패턴]]
- [[Toast & 모달 패턴]]
- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] — Visualforce 관점의 static resource(`$Resource`/`URLFOR`, 마크업 시점) 및 VF 오버라이드/커스텀 컴포넌트
