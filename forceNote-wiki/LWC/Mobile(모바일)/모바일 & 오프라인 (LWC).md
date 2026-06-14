---
tags: [lwc, mobile, offline, mobile-capabilities, graphql, briefcase]
source: mobile_offline.pdf (Mobile and Offline Developer Guide v67.0, Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.mobile_offline.meta/mobile_offline/
created: 2026-06-14
aliases: [Mobile Offline, LWC Offline, Offline GraphQL, mobileCapabilities, Briefcase, 오프라인 LWC, draft records, 모바일 디바이스 기능]
---

# 모바일 & 오프라인 (LWC)

> Salesforce 모바일 앱용 LWC 개발 — **모바일 디바이스 기능**(`lightning/mobileCapabilities`)과 **LWC Offline**(네트워크 없이 동작). 핵심은 **Offline GraphQL**(코드 변경 없이 온/오프라인 자동 전환) + **Briefcase**(오프라인 데이터 프라이밍).

> [!note] *Mobile and Offline Developer Guide v67.0* 전수(오프라인·디바이스 기능 중심). 📖 공식: [Mobile and Offline Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.mobile_offline.meta/mobile_offline/) · 디바이스 기능 사용 예제는 [[모바일 기능 패턴]](Tier 1).

---

## 모바일 디바이스 기능 — `lightning/mobileCapabilities`

팩토리 함수로 서비스를 얻고 **`isAvailable()`로 가드** 후 사용(데스크톱·미지원 기기에서 graceful fallback).

```javascript
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
export default class Scan extends LightningElement {
    scanner = getBarcodeScanner();
    handleScan() {
        if (this.scanner.isAvailable()) {     // 가드 필수
            this.scanner.beginCapture({ /* options */ })
                .then(result => { /* ... */ })
                .catch(err => { /* 취소/오류 */ })
                .finally(() => this.scanner.endCapture());
        }
    }
}
```

### 서비스 전체 (factory 함수)
| 함수 | 기능 |
|---|---|
| `getBarcodeScanner()` | 바코드/QR 스캔 |
| `getLocationService()` | GPS 위치 |
| `getBiometricsService()` | 지문/얼굴 인증 |
| `getCalendarService()` | 캘린더 접근 |
| `getContactsService()` | 연락처 접근 |
| `getNfcService()` | NFC 태그 |
| `getPaymentsService()` | 결제 |
| `getDocumentScanner()` | 문서 스캔 |
| `getGeofencingService()` | 지오펜싱 |
| `getAppReviewService()` | 앱 리뷰 요청 |

→ 사용 예제·패턴: [[모바일 기능 패턴]]

---

## LWC Offline

LWC Offline은 기존 Salesforce 모바일 앱의 **opt-in 향상 기능**. 컴포넌트가 네트워크 없이도 동작. (단 일부 기능 미지원·성능 저하 가능 — 아래 제약)

### Offline GraphQL (핵심)
- **표준 GraphQL wire 어댑터와 동일** — **코드 변경 불필요**. 온라인이면 표준 어댑터, 오프라인 + LWC Offline 앱이면 **자동으로 Offline GraphQL** 사용.
- 클라이언트(기기)에서 실행, **Offline Cache**의 데이터·메타데이터 사용(프라이밍 또는 일반 사용으로 미리 적재).
- LDS 기반이라 캐싱·요청 최적화 활용. 고급 데이터 조회는 Apex보다 **GraphQL wire 권장**(LWC Data Guidelines).

```javascript
// 동일 코드가 온라인/오프라인 모두 동작 (GraphQL wire 어댑터)
import { gql, graphql } from 'lightning/uiGraphQLApi';
export default class Accounts extends LightningElement {
    @wire(graphql, {
        query: gql`query { uiapi { query {
            Account(first: 10) { edges { node { Id Name { value } } } }
        } } }`
    }) accounts;
}
```

### Briefcase (데이터 프라이밍)
- **Briefcase Builder**로 오브젝트·레코드별 **고급 프라이밍 전략** 정의 — 사용자가 오프라인에서 접근할 데이터를 미리 지정.
- **프라이밍 엔진**이 오프라인 전환 준비 시 레코드를 **선적재(preload)**.

### Draft Records & 충돌
- 오프라인에서 생성/수정한 레코드는 **draft**로 보관 → 온라인 복귀 시 동기화. 동기화 중 **충돌(conflict)** 해소 필요.

---

## 오프라인 고려사항·제약

- **Feature Limitations of Offline GraphQL** — 오프라인에서 일부 GraphQL 기능 미지원(필터·정렬·집계 제약 등, 가이드의 제약 목록 참조).
- 디바이스 기능 일부는 오프라인/플랫폼별 미지원 → `isAvailable()` 가드 + fallback 필수.
- 성능·캐시 용량 제약.

---

## 개발 도구

- 모바일용 개발 환경 설정, **iOS 시뮬레이터·Android 에뮬레이터**용 가상 디바이스 빌드로 Salesforce 모바일 앱에서 컴포넌트 미리보기/테스트.

---

## 관련 노트

- 📖 공식: [Mobile and Offline Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.mobile_offline.meta/mobile_offline/)
- [[모바일 기능 패턴]] — `mobileCapabilities` 사용 예제 (Tier 1, lwc-recipes)
- [[getRecord 패턴]] — LDS 데이터 (Offline Cache 기반)
- [[LWC MOC]]
