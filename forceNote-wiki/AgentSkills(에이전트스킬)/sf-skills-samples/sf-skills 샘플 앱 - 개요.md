---
tags: [agent-skill, sf-skills, samples, reference-app, react, ui-bundle, webapp]
source: forcedotcom/sf-skills (samples/, 공식 Salesforce)
created: 2026-06-27
aliases: [sf-skills 샘플 앱, property rental 레퍼런스 앱, ui-bundle 샘플, webapp 샘플, b2e b2x, native mobile rental, 부동산 임대 앱]
---

# sf-skills 샘플 앱 — 개요

> 동일한 부동산/임대 관리 도메인을 **3가지 전달 방식(UI Bundle · WebApp · Native Mobile)** × **2가지 대상(B2E 직원 · B2X 외부)** 로 구현한 5종의 공식 Salesforce 레퍼런스 앱. `forcedotcom/sf-skills` 레포의 `samples/` 폴더에 동기화되어 있다.

---

## 샘플 앱 목록 (5종)

| 폴더명 | 전달 방식 | 대상 | 앱 표시명 | 동기화 출처 | 한 줄 설명 |
|---|---|---|---|---|---|
| `ui-bundle-template-app-react-sample-b2e` | UI Bundle | B2E (직원) | Property Management App | npm `@salesforce/ui-bundle-template-app-react-sample-b2e` (`.version` 10.2.2) | 플랫폼 내부용 부동산 관리 UI Bundle. 대시보드·유지보수 요청·임차인 신청 + Agentforce 대화 클라이언트 플레이스홀더 |
| `ui-bundle-template-app-react-sample-b2x` | UI Bundle | B2X (외부) | Property Rental App | npm `@salesforce/ui-bundle-template-app-react-sample-b2x` (`.version` 10.2.2) | Experience Cloud 외부 노출용 임대 UI Bundle. 매물 목록·유지보수·대시보드 + 게스트/셀프등록 인증 흐름 |
| `webapp-template-app-react-sample-b2e-experimental` | WebApp (experimental) | B2E (직원) | Property Management App | npm experimental (`.version` 1.116.6) | UI Bundle b2e와 동일 도메인을 `webapplications/` 메타데이터형 React 웹앱으로 구현 |
| `webapp-template-app-react-sample-b2x-experimental` | WebApp (experimental) | B2X (외부) | Property Rental App | npm experimental (`.version` 1.116.6) | UI Bundle b2x와 동일 도메인의 웹앱 버전. Experience Cloud 사이트 + Apex Action 포함 |
| `native-mobile-rental-tenant-app` | Native Mobile (CAMA) | B2X (임차인) | Native Mobile Rental Tenant App | 레포에서 직접 유지관리 (npm 비동기화) — `cama-mcp-server` git에서 동기화 | 임차인용 Custom Agentic Mobile App(CAMA) 메타데이터 스캐폴드. 네이티브 iOS/Android로 확장 |

> 공통 스택: 5종 중 React 앱 4종(UI Bundle·WebApp)은 **React + Vite + TypeScript + Tailwind/shadcn** 기반이며 Salesforce GraphQL API를 codegen으로 타입세이프하게 호출한다. native-mobile은 UI 빌드 없는 메타데이터 우선 프로젝트.

---

## UI Bundle vs WebApp vs Native Mobile (아키텍처 차이)

| 항목 | UI Bundle | WebApp (experimental) | Native Mobile (CAMA) |
|---|---|---|---|
| 메타데이터 위치 | `force-app/main/default/uiBundles/<appName>/` | `force-app/main/default/webapplications/<appName>/` | `force-app/main/default/digitalExperiences/experiencecontainer/rentalApp/` |
| 실행 환경 | Salesforce 플랫폼 안에서 동작하는 독립 Vite+React SPA | 동일 도메인의 메타데이터형 React 웹앱 | Agentic Mobile App(네이티브 iOS/Android 셸) |
| `sourceApiVersion` | 67.0 | 66.0 | 66.0 |
| UI 빌드 단계 | 필요 (`npm run build` → 정적 번들 패키징) | 필요 (`npm install && npm run build`) | 불필요 (metadata-first 배포) |
| 자동 셋업 스크립트 | `npm run setup` (`scripts/org-setup.mjs`) | `node setup-cli.mjs` (빌드 산출물에 포함) | 없음 — `sf project deploy start`만 |
| 성숙도 표기 | 안정형(폴더명에 experimental 없음) | experimental | 샘플 스캐폴드 |
| 미리보기 | dev 서버 `http://localhost:5173` | dev 서버 `http://localhost:5173` | Mobile Playground (`SFDX: Open in Live Preview` → QR 스캔) |

- UI Bundle / WebApp 모두 동일 워크플로(로그인 → 메타데이터 배포 → 권한셋 → 샘플 데이터 import → GraphQL 스키마/codegen → 번들 빌드 → 배포)를 공유한다.
- native-mobile은 Agentforce Vibes 환영 페이지의 **Mobile** 앱 유형으로 노출되며, 마법사 또는 레포에서 직접 클론할 수 있다.

---

## B2E vs B2X (대상 차이)

| 항목 | B2E (Business-to-Employee) | B2X (외부 노출) |
|---|---|---|
| 앱 표시명 | Property Management App | Property Rental App |
| 사용자 | 내부 직원 / 부동산 관리자 | 외부 임차인·잠재고객·게스트(미인증) |
| 권한셋 | `Property_Management_Access`(전체 CRUD) + (ui-bundle b2e) `Tenant_Maintenance_Access`(범위 제한) | 위 2종 + `Property_Rental_Guest_User_Access`(게스트 읽기) |
| Experience Cloud | 없음 | 포함 — `digitalExperiences` · `digitalExperienceConfigs` · `networks` · `sites` · `cspTrustedSites` |
| Apex | (ui-bundle b2e) 없음 / (webapp b2e) 없음 | ui-bundle b2x: 트리거 핸들러 + 인증 Apex(`UIBundleAuthUtils` · `UIBundleChangePassword` · `UIBundleForgotPassword` · `UIBundleLogin` · `UIBundleRegistration`, 트리거 `MaintenanceRequestTriggerHandler` · `TenantTriggerHandler`) / webapp b2x: Action Apex(`MaintenanceRequestListAction` · `MaintenanceRequestUpdatePriorityAction`) |
| 추가 구성 | Agentforce 대화 클라이언트 플레이스홀더(`applayout.tsx`, 유효 `agentId` 필요) | 게스트 프로필 · 셀프등록 · 커뮤니티 프로필 복제 · 게스트 criteria 기반 공유 규칙(`Property_Rental_App_Guest_User_Access`) |

> Apex 클래스·트리거·Action의 시그니처와 동작은 [[sf-skills 샘플 앱 - Apex 패턴]] 참조. 객체·필드·권한셋 매핑 상세는 [[sf-skills 샘플 앱 - 데이터 모델]] 참조.

---

## 동기화 방식 (`samples/README`)

`samples/README.md`는 **세 가지 동기화 메커니즘**을 문서화한다.

1. **UI Bundle b2e / b2x — npm 동기화 (GitHub Action + 로컬)**
   - **GitHub Action** "Sync React samples from npm": 매일 야간 실행 + Actions 탭에서 수동 트리거 가능. **npm 패키지 버전이 바뀐 경우에만** `main`에 PR을 연다.
   - **로컬**: 레포 루트에서 동일 동기화 수행.

```bash
# 레포 루트에서 실행 — npm 패키지를 root node_modules에 설치하고
# 소스만(node_modules 제외) samples/<폴더>/ 로 복사한 뒤 .version 갱신
npm install
npm run sync-react-b2e-sample   # ui-bundle b2e
npm run sync-react-b2x-sample   # ui-bundle b2x
```

   - **버전 추적**: `samples/<폴더>/.version`에 마지막 동기화 npm 버전을 저장(현재 UI Bundle 10.2.2). Action이 최신 npm 버전과 비교해 다를 때만 PR 생성.

2. **WebApp b2e / b2x (experimental)** — 동일하게 `.version`(현재 1.116.6) 마커를 가진 npm 동기화 샘플이지만, `samples/README.md` 본문 및 루트 `package.json`에는 b2e/b2x **UI Bundle** 전용 `sync-react-*` 스크립트만 등재돼 있다(웹앱 전용 명명 스크립트는 문서화되지 않음).

3. **native-mobile-rental-tenant-app — npm 비동기화**: 이 레포에서 직접 유지관리하며, 소스는 `cama-mcp-server` git(branch `apply_metadata_updates`)에서 동기화된다. `digitalExperiences` 메타데이터로 CAMA 앱 구성(`experience__camaAppMetadata` · `experience__camaBuildMetadata` · `experience__camaECDefinition` · `experience__camaScreen` — Home/Tenants/Properties 탭, 테마, 툴바)을 포함한다.

---

## 공통 도메인 (부동산 임대 관리)

5종 샘플 모두 동일한 부동산/임대 관리 데이터 모델을 공유한다(샘플별 **17~18개 커스텀 객체**; ui-bundle b2e만 18개, 나머지 17개). 핵심 객체:

`Property__c`(매물) · `Tenant__c`(임차인) · `Lease__c`(임대계약) · `Agent__c`(중개인) · `Application__c`(임대 신청) · `Maintenance_Request__c`(유지보수 요청) · `Maintenance_Worker__c`(유지보수 작업자) · `Notification__c` · `Payment__c` · `KPI_Snapshot__c` · `Property_Cost__c` · `Property_Feature__c` · `Property_Image__c` · `Property_Listing__c` · `Property_Management_Company__c` · `Property_Owner__c` · `Property_Sale__c`

샘플 데이터는 `force-app/main/default/data/data-plan.json`로 의존성 순서대로 import한다.

```bash
sf data import tree --plan force-app/main/default/data/data-plan.json --target-org <alias>
```

> 객체별 필드·관계, 권한셋 매핑, 데이터 import 순서 상세는 [[sf-skills 샘플 앱 - 데이터 모델]] 소관이다(여기서는 목록 포인터만 제공).

---

## 관련 노트
- [[sf-skills 샘플 앱 - Apex 패턴]]
- [[sf-skills 샘플 앱 - 데이터 모델]]
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-frontend-generate]]
