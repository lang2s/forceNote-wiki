---
tags: [field-service, fsl, mobile, lwc, 현장서비스, offline, deep-linking, mobile-capabilities, barcode-scanner, ar-spacecapture, document-builder]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [Field Service Mobile, FS Mobile LWC, Field Service LWC, Deep Linking, Plug-Ins, BarcodeScanner, AR SpaceCapture, Document Builder LWC, Field Service 모바일 앱, 딥링킹, 바코드 스캐너, 공간 캡처]
---

# Field Service Mobile App (LWC)

> Field Service 모바일 앱에서 Lightning Web Component를 개발·디버그하고, Document Builder용 커스텀 컴포넌트·딥링킹·플러그인(바코드 스캐너·AR SpaceCapture)을 추가하는 방법.

이 가이드(Field Service Developer Guide의 "Field Service Mobile App" 챕터)는 **Mobile and Offline Developer Guide**의 동반 문서다. 먼저 Mobile and Offline Developer Guide의 내용을 익힌 뒤 이 노트로 돌아와 Field Service 모바일 앱 특화 설정을 학습한다. LWC Offline의 일반 메커니즘(Briefcase 프라이밍, GraphQL wire, draft records 등)은 [[모바일 & 오프라인 (LWC)]] 참조.

> [!note] 제목 [sic] 보존
> PDF 원문은 섹션 ④ 제목을 "Add **Lighting** Web Components for Plug-Ins"로 표기한다(모든 페이지 헤더에서 동일하게 "Lightning"이 아니라 "Lighting"). 이 노트는 원문 오타·apiVersion·코드 중복 키 등을 `[sic]`으로 보존한다. 화면 캡처는 `(이미지: 화면 캡처)`로 표기한다.

---

## ① Get Started — LWC in the Field Service Mobile App

> Field Service 모바일 앱에서 LWC를 생성·사용하는 방법. LWC는 UI 강화부터 기능 확장까지 Field Service 운영 요구를 충족하는 다재다능하고 효율적인 프레임워크를 제공한다.

> Note: Lightning web component 개발은 숙련된 개발자에게 가장 적합하다. 다만 코딩 경험이 있는 매우 고급 어드민도 성공할 수 있다.

### 1-A. Considerations for LWC Offline

Field Service 모바일 앱에서 컴포넌트를 실행할 때 적용되는 고려사항이다.

- **Global quick action**은 Actions 메뉴가 있는 모든 페이지에서 사용 가능하다. 단, record detail 페이지에서 호출될 때 현재 레코드의 record ID를 받지 못한다.
- **Community license 사용자**가 service appointment를 열면 missing record 오류가 발생할 수 있다. 이 특정 사용자 유형의 알려진 이슈다.
- Briefcase에 추가된 **Task 객체는 오프라인용으로 프라이밍되지 않는다.** Briefcase에 Task 객체가 있으면 priming 시도 시 오류 메시지가 표시되지만, briefcase 내 다른 객체는 프라이밍된다. 오류를 해결하려면 briefcase에서 Task 객체를 제거한다.
- **Appointment Assistant**와 LWC Offline 사이에 충돌이 있어 URL이 누락될 수 있다. 자세한 내용은 해당 known issue 참조.
- **(iOS 전용)** Lightning web component 변경은 앱을 완전히 종료한 뒤 재실행(cold start)할 때만 앱에 로드된다.

### 1-B. Field Service Org Setup — Permission Set

> 필수 permission set을 정의하고 할당한다.

> Note: 이 단계는 Field Service org에 필수다. Salesforce 모바일 앱에서 LWC Offline을 사용하는 경우 이 단계를 건너뛴다.

LWC Offline 지원 모바일 앱용 Lightning web component는 **opt-in 기능**이다. org에서 활성화하려면 아래 권한을 정의·할당해야 한다. 이는 Field Service 모바일 앱 내에서 LWC에 접근·실행하는 데 필수다(컴포넌트를 실행할 수 없으면 개발이 어렵다).

**Define a Permission Set for Your Org** — Lightning Data Service 활성화 권한을 적용하는 permission set 생성:
1. Setup에서 Quick Find에 `Permission Sets`를 입력하고 **Permission Sets** 선택.
2. **New** 클릭.
   - Label: `Field Service - Lightning Data Service`
   - Description: `Assign to Field Service Mobile users to give them permission to use features that use Lightning Data Service.`
   - License: **Field Service Mobile** 선택.
3. **Save** 클릭.
4. Find Settings 박스에 `Lightning SDK for Field Service Mobile`을 입력하고 클릭.
5. **Edit** 클릭.
6. **Lightning SDK for Field Service Mobile**을 선택하고 저장.

**Assign the Permission Set to a Mobile User** — Field Service 모바일 앱 사용자에게 Lightning Data Service 권한 할당:
1. Setup에서 Quick Find에 입력 후 **Permission Sets** 선택.
2. 생성한 permission set(여기서는 Field Service - Lightning Data Service)으로 스크롤하여 클릭.
3. **Manage Assignments** → **Add Assignments** 클릭.
4. 할당할 사용자 선택.
   > Note: 만료일(expiration date)을 지정하면 그 시점에 permission set이 제거된다. 무기한 할당하려면 No expiration date를 선택된 채로 둔다.
5. **Assign** 클릭.
6. Assignment Summary 화면에서 **Done** 클릭.

### 1-C. iOS Simulator Setup

> 개발 중에는 가상 디바이스에서 코드를 테스트하는 것이 편리하다. Xcode로 device simulator를 만들고 모바일 앱의 virtual device 빌드를 설치한다.

**Configure Minimum Required iOS Simulator Settings** — 최소 디바이스·iOS 버전 요구사항 충족 확인(Field Service Mobile App Requirements / Salesforce Mobile App Requirements 참조):
1. 최신 Xcode를 다운로드·설치한다(이미 설치돼 있으면 재설치 불필요).
2. Xcode 실행.
3. 메뉴바에서 **Xcode > Open Developer Tool > Simulator** 선택. Simulator 프로그램이 모바일 화면을 표시하며 열린다.
4. **File > Open Simulator**로 원하는 디바이스 선택. simulator를 만들려면 **File > New Simulator**로 진행.

device simulator가 실행된 뒤 Xcode는 닫아도 되지만, 다음 섹션에서 Field Service 앱을 설치할 수 있도록 Simulator 앱 창은 열어둔다.

**Install the Field Service App for iOS** — 앱의 virtual device 빌드 다운로드·설치:
1. Salesforce Field Service 모바일 앱의 iOS virtual device 빌드(zip)를 다운로드한다. 최신 버전 링크는 Trailblazer Community 게시물에 있다. insufficient permissions 페이지가 나오면 Trailhead에 로그인 후 다시 시도.
2. 다운로드한 zip을 더블클릭해 app 파일 추출.
3. 추출된 `.app` 파일을 Simulator 창으로 드래그.
4. Simulator에서 새로 설치된 Field Service 앱을 클릭(시뮬레이션 탭)해 연다. 첫 페이지에 없으면 다른 앱 페이지에 설치된 것이므로 페이지를 스와이프해 찾는다.
5. Field Service 앱 클릭 → **Get Started** 클릭.
6. 화면을 클릭해 튜토리얼을 진행하거나 **Skip** 클릭.
7. **Log In** 클릭.
8. **I Agree**를 클릭해 Order Form Supplement 동의.
9. [icon]을 클릭하고 연결(connection)을 선택.
   > Warning: community 사용자로 처음 로그인하는 경우 [icon]을 클릭해 새 연결을 추가한다.
   > - Host: org URL을 `https://[yourURL].my.salesforce.com` 형식으로 입력.
   > - Label: 연결의 별칭 입력.
10. **Done** 클릭.
11. org의 username·password 입력.
12. **Log In** 클릭.
13. **Allow**를 클릭해 앱이 Salesforce 정보에 접근하도록 허용.
14. 각 권한 화면을 진행하며 적절한 접근을 허용한다. 완료되면 앱 홈 화면에 도달한다.

### 1-D. Android Emulator Setup

> 개발 중에는 가상 디바이스에서 테스트하는 것이 편리하다. Android Studio로 device emulator를 만들고 모바일 앱의 virtual device 빌드를 설치한다.

**Configure Minimum Required Android Emulator Settings** — 최소 디바이스·Android API 버전 요구사항 충족 확인:
1. 최신 Android Studio 다운로드·설치(이미 설치돼 있으면 재설치 불필요).
2. Android Studio 실행.
3. 좌측 상단의 **More Actions** 또는 [icon](버전에 따라 다름)을 클릭하고 드롭다운에서 **Virtual Device Manager** 선택.
4. 편집할 디바이스의 Actions 열에서 [icon] 클릭. emulator를 만들려면 **Create Device**로 진행.
5. 버전 번호가 표시된 줄에서 **Change** 클릭. `(이미지: 화면 캡처)`
6. 팝업 창에서 **API 30 version or later** 선택.
7. **OK** 클릭.
8. Memory and Storage 섹션으로 스크롤. `(이미지: 화면 캡처)`
9. RAM 필드에 `4096` 입력. RAM 값을 바꿀 수 없으면 더 새 디바이스를 사용한다.
10. **Finish** 클릭.
11. 디바이스 Actions 열의 [icon]을 클릭해 Android Emulator 실행.

**Install the Field Service App for Android** — APK 빌드 다운로드·설치:
1. Salesforce Field Service 모바일 앱의 Android virtual device 빌드(APK)를 다운로드. 최신 버전 링크는 Trailblazer Community 게시물에 있다.
2. 다운로드한 `.apk` 파일을 Android Emulator 창으로 드래그.
3. Emulator 화면의 빈 공간을 클릭하고 위로 드래그해 설치된 앱 보기.
4. 새로 설치된 Field Service 앱 클릭.
5. **I Agree**를 클릭해 Order Form Supplement 동의.
6. 우측 상단 세로 점 버튼을 클릭하고 **Change Server** 선택. `(이미지: 화면 캡처)`
7. 연결 선택.
   > Warning: community 사용자로 처음 로그인하는 경우 **Add New Connection**을 클릭하고 폼을 채운 뒤 **Apply**로 저장.
   > - Name: 연결의 별칭 입력.
   > - URL: org URL을 `https://[yourURL].my.salesforce.com` 형식으로 입력.
8. 좌측 상단 화살표를 클릭해 로그인 화면으로 돌아간다.
9. org의 username·password 입력.
10. **Log In** 클릭.
11. **Allow** 클릭.
12. 각 권한 화면을 진행하며 허용. 완료되면 앱 홈 화면에 도달한다.

### 1-E. Debug LWC in the Field Service Mobile App

> LWC를 개발·디버그하는 최선의 방법은 HTML·CSS·JavaScript로 만든 것을 다루는 방식과 동일하다 — 웹 브라우저에 내장된 디버깅 도구를 사용한다.

- **Android 디버깅** → **Chrome DevTools**
- **iOS 디버깅** → **Safari Web Inspector**

데스크톱 브라우저의 개발자 도구를 Field Service 모바일 앱 내의 WebView에 연결하면, 모바일 디바이스에서 실행 중인 LWC를 디버깅하는 것이 일반 웹 앱 디버깅과 동일해진다.

**Install Local Development Server Plugin** — iOS·Android 어느 쪽이든 먼저 mobile용 LWC Development Server를 설치한다:
1. 터미널에서 Salesforce CLI 최신 버전 확인:
   ```
   sf update
   ```
   > Note: Salesforce CLI 업데이트 중 오류가 발생하면 Update Salesforce CLI의 트러블슈팅 참조.
2. mobile용 LWC Development Server 설치:
   ```
   sf plugins install @salesforce/lwc-dev-server
   ```

**Debug in iOS** — Safari Web Inspector를 Field Service 모바일 앱의 WebView에 연결:
> Note: iOS 디버깅은 현재 Big Sur 이상에서만 동작하며, Safari Technology Preview 브라우저를 사용해야 한다.
1. 데스크톱에서 Safari 실행.
2. **Safari > Preferences** 선택.
3. **Advanced** 선택.
4. **Show Develop menu in menu bar** 활성화 후 Preferences 패널 닫기.
5. **Develop > Simulator - device - version** 선택(Simulator는 새 LWC 테스트를 위해 Field Service 앱과 함께 연 것).

Safari Web Inspector 개발자 도구가 시뮬레이터에 연결된 창이 나타난다. `(이미지: Safari Web Inspector 화면 캡처)` 자세한 내용은 **Apple Web Development Tools** 참조.

**Debug in Android** — Chrome DevTools를 WebView에 연결:
1. 에뮬레이트된 Android 디바이스에서 Settings 앱 열기.
2. 검색창에 `About emulated device` 입력 후 클릭.
3. 페이지 맨 아래로 스크롤하여 **Build number**를 7번 클릭. "You are now a developer!" 메시지가 나오면 developer mode 활성화 완료.
4. 데스크톱에서 Chrome 실행.
5. 주소창에 `chrome://inspect/#devices` 입력.
6. 사용 중인 Remote Target emulator의 WebView에 대해 **Inspect** 클릭.

Chrome DevTools가 연결된 emulator 창이 나타난다. `(이미지: Chrome DevTools 화면 캡처)` LWC element 검사, breakpoint 설정, console 출력 확인이 가능하다. 자세한 내용은 **Remote debugging WebViews** 및 **Debugging embedded JavaScript in an Android app using Chrome DevTools** 참조.

### 1-F. What Can I Do with LWC in the Field Service Field Service Mobile App? [sic — "Field Service" 중복]

> Actions 메뉴에서 접근하는 커스텀 컴포넌트를 만들 수 있다. LWC로 만든 action은 단순할 수도, 복잡할 수도 있으며, 모바일 디바이스가 오프라인일 때도 동작한다. 이미지 추가·주석을 service report에 첨부, 부품 주문, SME 연락, 모바일 워커용 커스텀 대시보드 생성 등에 사용한다. Field Service에서 LWC로 Salesforce가 할 수 있는 거의 모든 것을 할 수 있다.

**Work with LWCs** (표 — 열: Task | Where to Find It):

| Task | Where to Find It |
|---|---|
| Learn about and develop with LWCs. | Salesforce Developers: **Lightning Web Components Developer Guide** |
| open-source LWC로 근처 리소스 찾기, 약속 재예약, 이미지 업로드·주석. | GitHub: **LWC-Mobile-Samples** — FindNearby · RescheduleAppointments · UploadAndAnnotateImages |
| unlocked package로 후속 약속 예약, 모바일 대시보드 보기. | GitHub: **LWC-Mobile-Samples** — FollowupAppointment · MobileDashboard |
| 플러그인을 사용하는 LWC 생성. | Field Service Developer Guide: **Add Lighting [sic] Web Components for Plug-Ins to the Field Service Mobile App** (이 노트 섹션 ④) |
| LWC 개발을 도울 파트너 찾기. | Find the right Salesforce expertise: **Salesforce Partners** |

### 1-G. Configure Offline Mode

> Field Service 모바일 앱에서 Automatic Offline Mode가 켜졌을 때 무엇을 기대할 수 있고 설정을 어떻게 조정하는지.

앱은 셀룰러 신호와 wifi 연결이 모두 없을 때 오프라인으로 전환된다. 오프라인 모드에서는 캐시된 데이터를 사용하고, 온라인으로 돌아오면 데이터를 새로고침한다. 앱은 Salesforce API에 정기적으로 연결 요청을 보내 오프라인 유지 여부를 판단한다. 반복적으로 실패하면 오프라인으로 진입/유지한다. 따라서 셀룰러 신호·wifi가 있어도 특정 상황에서 오프라인 모드가 될 수 있다.

1. 어드민으로 Setup의 **Manage Connected Apps** 페이지로 이동.
2. **Salesforce Field Service for iOS** 또는 **Salesforce Field Service for Android** 클릭. 두 플랫폼을 모두 사용하면 각각 구성을 추가한다.
3. custom attribute 목록에서 **New** 클릭.
4. 오프라인 모드 동작을 구성하는 custom attribute 추가.
5. attribute 추가 후, 변경이 적용되도록 모바일 워커에게 앱 로그아웃 후 재로그인 요청.

**Offline Mode Settings** (표 — 열: Setting | Default Value | Setting Name):

| Setting | Default Value | Setting Name |
|---|---|---|
| 온라인 상태에서 성공적인 체크 후 다음 Salesforce API 연결 체크까지의 간격 | 15 seconds | `AO_DELAY_FOR_ONLINE_STATUS` |
| 앱이 오프라인으로 가기 전 허용되는 최대 실패 요청 수 | 3 | `AO_CONNECTION_FAILURE_THRESHOLD` |
| 앱이 온라인으로 복귀하기 위한 최대 성공 요청 수 | 3 | `AO_CONNECTION_SUCCESS_THRESHOLD` |
| 실패한 체크 후 다음 Salesforce API 연결 체크까지의 간격 | 1 second | `AO_DELAY_FOR_CHANGING_STATUS` |
| 연결 요청이 실패로 간주되기 전까지 걸릴 수 있는 시간 | 5 seconds | `AO_CONNECTION_CHECK_TIMEOUT` |

**Considerations:**
- 설정에 따라 앱이 온라인↔오프라인을 자주 전환할 수 있다. 예를 들어 API 연결 체크를 매초 ping하고 한 번 실패 시 오프라인으로 가도록 구성하면 반복적으로 전환될 수 있다.
- 연결 체크는 데이터 검색 호출을 정확히 반영하지 않는다. 즉 이 기능은 앱을 온라인으로 유지하지만 데이터 검색 호출은 여전히 느릴 수 있다.
- flow 진행 중 앱이 오프라인↔온라인 전환되면 flow가 중단될 수 있다.
- 앱이 온라인이고 네트워크 연결이 약한 지역에서 사용하면 일부 사용자는 데이터 새로고침에 오랜 대기 시간을 경험한다.

### 1-H. Design with LWC to Look Like Salesforce

> Field Service 모바일 앱은 아래 11개 Lightning web component를 Salesforce UI 스타일과 매끄럽게 통합한다. 각 컴포넌트별로 커스터마이즈 가능한 스타일 속성은 다음과 같다.

- **Labels for Lightning elements** — font size / Max length of label is three lines
- **lightning-input** (Text + Number) — width, height, background-color-focus, border-color-focus, border-width, caret-color-focus, margin, padding, background-color-error-focus
- **Datetime Picker** — width, height, background-color-focus, border-color
- **Checkbox Toggle** — background-color-checked-focus, background-color-checked, shadow
- **Checkbox Button** — background-color
- **lightning-textarea** — width, height, background-color-focus, border-color-focus, border-width, caret-color-focus, margin, padding, background-color-error-focus, font size
- **lightning-combobox (picklist)** — width, height, background-color-focus, border-color-focus, border-width, margin, padding
- **lightning-checkbox-group** — border around checkbox, label font size, checkbox size, checkbox color border, checkbox color background, checkbox mark color, error state background focus
- **lightning-radio-group** — border around checkbox, label font size, radio size, radio color border thickness, radio mark color
- **lightning-progress-bar** — progress bar color
- **lightning-progress-indicator** — progress indicator bar color
- **lightning-button (variant - base, neutral, brand)** — border, background-color, background-color-focus

> 위 11개 base 컴포넌트 외에, Document Builder용 컴포넌트가 지원하는 base/유틸리티 목록은 섹션 ②-B 참조.

---

## ② Build Custom LWC for Service Documents (Document Builder)

> 비즈니스·브랜딩 요구에 맞춰 LWC로 커스텀 컴포넌트를 만들어 템플릿을 커스터마이즈한다.

Document Builder 표준 컴포넌트에 없는 컴포넌트가 필요하면 LWC로 쉽게 만든다. Document Builder용 LWC는 특정 print styling이 필요하므로, Field Service Mobile 등 다른 플랫폼용 커스텀 컴포넌트를 이미 만들었더라도 Document Builder용으로 별도로 만들어야 한다.

### 2-A. Requirements

**SLDS wire adapter 사용:**
- aura controller를 쓰지 않는다.
- **Apex를 쓰지 않는다.** Apex는 온라인에서는 동작하지만 오프라인에서는 빈 배열을 반환한다.
- 데이터 검색을 위한 third-party 데이터 소스 호출은 오프라인에서 동작하지 않는다.

**create/update/delete용 wire adapter 사용** — 논리적으로 프라이밍되는 다음 작업만 사용 가능: **create, update, delete, getRecord, getRecords, getObjectInfo, graphQL**. graphQL 사용을 권장한다. **getRelatedListRecords는 오프라인 사용에 완전히 지원되지 않는다.** 사용 가능한 wire adapter import:
```javascript
import { getRecord } from 'lightning/uiRecordApi'
import { createRecord } from 'lightning/uiRecordApi'
import { deleteRecord } from 'lightning/uiRecordApi'
import { updateRecord } from 'lightning/uiRecordApi'
import { getObjectInfo } from 'lightning/uiObjectInfoApi'
import { gql, graphql } from 'lightning/uiGraphQLApi'
```

**Aura 의존성 제거** — **Lightning Software Developers Kit (LSDK)**를 사용하는 Field Service 개발자는 Aura에 의존하는 코드를 쓸 수 없다(Field Service는 오프라인 실행이 가능해야 하므로). LWC만 사용하고, 컴포넌트 의존성 체인을 끝까지 평가하여 어떤 코드도 Aura를 쓰지 않도록 한다.

**LWC가 정적 분석 가능(Statically Analyzable)하도록 보장** — LWC가 정적 분석 가능(=**Komaci-friendly**)하지 않으면 Komaci가 LWC를 프라이밍하지 않는다. Komaci는 data flow graph 생성·처리 기능을 제공하는 패키지 모음으로, data flow graph의 직렬화 가능한 메타데이터 표현인 **Abstract Data Graph (ADG)** 스키마를 정의한다. ADG 생성 서비스, ADG를 읽고/처리/변환하는 플러그인 빌드 프레임워크, live input과 full reactivity로 ADG를 호스팅하는 runtime engine을 포함한다. Komaci는 LWC component tree를 통한 data flow의 추상화 계층을 제공하며, LWC 모듈을 분석해 ADG를 생성하는 유틸리티와 LWC wire와 통합하는 runtime helper를 포함한다.

> Important: 커스텀 LWC가 모바일 document preview에 나타나려면 js-meta.xml에 다음 코드를 포함해야 한다:
> ```xml
> <supportedFormFactor type="Small" />
> ```

### 2-B. Considerations — Supported / Unsupported

**Supported Utilities** (Document Builder용 LWC 지원 유틸리티 14종):
Borders · Box · Description List · Grid · Horizontal List · Hyphenation · Layout · Margin · Name Value List · Padding · Print · Text · Themes · Vertical List

**Supported Base Components** (지원 base 컴포넌트 16종):
Combobox · Formatted Date-Time · Formatted Location · Formatted Phone · Formatted Time · Formatted URL · Relative Date-Time · Formatted Address · Formatted Name · Formatted Number · Formatted Rich Text · Formatted Text · Progress Indicator · Progress Ring · Tile
> Tip: Formatted Address에서는 `showMapLink`로 iframe에 Google maps를 표시할 수 없다.

**Unsupported Salesforce APIs** — 데스크톱·모바일·print 간 일관성을 위해 **Form Factor GVP** 또는 **Width Aware** Salesforce API를 쓰지 않는다.

**Unsupported HTML Concepts:**
- **iframe 사용 금지.** 오프라인에서 동작하지 않고 페이지 번호가 제대로 표시되지 않는다.
- **CSS Screen media query 사용 금지.** 데스크톱·모바일에서 컴포넌트 모양에 불일치를 일으킨다.
- **CSS `position:fixed` 사용 금지.** print 시 fixed positioning은 무의미하다. 반복 요소가 필요하면 canvas의 header/footer 섹션에 객체를 드래그한다.
- **CSS로 객체를 나란히 배치 금지.** 나란히 배치하려면 표준 grid 컴포넌트를 쓴다. `float`, `display: flex`, `display: inline`, `display: inline-block`, `display: inline-flex`, `display: grid`, `display: inline-grid`, `display: table`, `display: table-row` 같은 CSS 속성을 피한다.
- **`:nth-of-*` CSS Selector 사용 금지.** 여러 페이지에 걸친 콘텐츠에서 `:nth-of-type`·`:nth-child` 같은 pseudo-selector는 보통 동작하지 않는다. 대안으로 `lwc:if` 템플릿과 클래스 적용을 사용한다.

**Pagination Considerations:**
- service document는 **250 pages**로 제한된다. Document Builder는 250페이지를 초과하는 문서를 PDF로 처리할 수 없다.
- CSS page 선언을 피한다. 커스텀 컴포넌트에 `@page`를 선언하지 않는다. print용 page formatting 수정 기능은 Document Builder에 내장돼 있다.
- 이미지가 페이지 남은 공간에 맞지 않으면 다음 페이지로 밀린다. 한 페이지에 단독으로 있는 이미지가 여전히 너무 크면 한 페이지에 맞게 리사이즈된다.
- page number 컴포넌트를 body 섹션에 드래그하면 자신이 표시되는 페이지 번호를 보여준다. header/footer 영역에서 사용하기를 권장한다.
- 표준 signature 컴포넌트는 페이지에 걸쳐 분할되지 않는다.
- field 컴포넌트가 페이지에 걸치면 field label이 inline으로 반복된다.
- related list 콘텐츠가 페이지에 걸치면 column header가 반복된다.
- 레이아웃은 표준 grid 컴포넌트를 사용한다. SLDS grid 클래스를 써야 한다면 `slds-col`과 `slds-grid`를 한 요소에 함께 적용하지 말고 각각 별도 요소에 적용한다:
  ```html
  <!-- Bad --><div class="slds-col slds-grid"></div><!-- Good --><div class="slds-col"><div class="slds-grid">
  ```
  grid는 단순할수록 좋다. column wrapping, reordering, gutters, vertical grid 같은 기능은 지원되지 않는다.
- PDF 변환은 static resource를 압축하지 않는다. 큰 static resource(contentAssets)를 페이지에 두지 말고 사용 전에 리사이즈·압축한다.

### 2-C. Offline Priming — Komaci ESLint Plug-in

> 커스텀 LWC가 모바일 워커가 오프라인일 때 동작하도록 보장한다.

오프라인 지원을 위해 **Komaci VS Code Plug-in**을 설치한다. 이 플러그인으로 어떤 커스텀 LWC를 오프라인에서 사용할 수 있는지 분석·식별할 수 있다. 플러그인이 없으면 컴포넌트의 오프라인 동작 여부를 알 수 없다. 오프라인 사용 가능한 컴포넌트는 사용자가 오프라인으로 가기 전 필요한 데이터를 캐시하고, 무선 접속이 복구되면 오프라인에서 캡처한 데이터를 동기화한다.

**Install the Komaci ESLint VS Code Plug-in** — VS Code 사용을 권장한다. VS Code라면 ESLint VS Code 플러그인을 설치하고 `CTRL+SHIFT+P`로 command palette를 열어 **ESLint: Restart ESLint Server** 실행. 하단 output 탭(ESLint 선택)에서 디버그할 수 있다. VS Code 터미널에서 `yarn lint:lwc`도 실행 가능하다. VS Code를 쓰지 않으면 ESLint Komaci Plug-in의 public repository를 확인한다. 구현 준비가 됐으면 두 명령 중 하나를 사용:
- **Command 1:** `yarn add --dev @salesforce/eslint-plugin-lwc-graph-analyzer`
- **Command 2:** `npm install —save-dev @salesforce/eslint-plugin-lwc-graph-analyzer` *(em dash 원문 그대로 [sic])*

코드 입력 후 프로젝트 디렉터리를 확인하고 `.eslintrc` 파일을 권장 구성을 참조하도록 업데이트한다. Komaci engine은 모든 JavaScript 런타임 환경에 완전히 portable하며 DOM 같은 웹 기술/API에 의존성이 없다. Web Worker, JavaScriptCore, V8 host 같은 runtime window 밖 환경에서 LWC 모듈을 분석해 데이터 의존성을 prefetch할 수 있다.

### 2-D. Build Custom Tables for Service Documents

> Document Builder용 커스텀 table을 LWC로 만든다.

Document Builder는 related record용 table 표준 컴포넌트를 제공하지만, 회사 요구에 맞는 커스텀 table도 만들 수 있다. **HTML table을 사용해 LWC를 빌드**한다. 올바른 HTML table formatting은 table이 overflow되거나 페이지 사이에서 끊겨도 데이터를 제대로 정리한다. table이 overflow되면 column header가 다음 페이지에 반복된다. header row를 호출하여 페이지에 걸쳐 header가 반복되게 하는 샘플 markup:
```html
<table>
  <thead>
       <tr>
           <th>Company</th>
           <th>Contact</th>
           <th>Country</th>
       </tr>
   </thead>
   <tbody>
       <tr>
           <td>Alfreds Futterkiste</td>
           <td>Maria Anders</td>
           <td>Germany</td>
       </tr>
       <tr>
           <td>Centro comercial Moctezuma</td>
           <td>Francisco Chang</td>
           <td>Mexico</td>
       </tr>
   </tbody>
</table>
```

### 2-E. Code Examples for Document Builder

> Document Builder용 커스텀 컴포넌트를 LWC로 빌드한다.

> Important: 커스텀 LWC가 모바일 document preview에 나타나려면 js-meta.xml에 다음을 포함해야 한다:
> ```xml
> <supportedFormFactor type="Small" />
> ```

**Static Text** — header·medium header base 컴포넌트는 color·padding 구성을 제공한다. 다음 코드는 medium header 컴포넌트를 만든다.
```html
// Below is the code for the HTML block:
<template>
   <h2 class="slds-text-heading_medium" style={inlineStyle}>{text}</h2>
</template>
```
```javascript
// Below is the code for the javascript block:
import { LightningElement, api } from "lwc";

export default class MediumHeaderText extends LightningElement {
   @api text;
   @api colorhex;
   @api topPadding;
   @api leftPadding;
   @api rightPadding;
   @api bottomPadding;

   get inlineStyle() {
       return `color:#${this.colorhex};
padding:${this.topPadding}px ${this.rightPadding}px ${this.bottomPadding}px
${this.leftPadding}px`;
   }
}
```
```xml
// Below is the extensible markup language block
<?xml version="1.0" encoding="UTF-8" ?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
   <apiVersion>57.0</apiVersion>
   <isExposed>true</isExposed>
   <targets>
       <target>lightning__ServiceDocument</target>
   </targets>
   <targetConfigs>
       <targetConfig targets="lightning__ServiceDocument">
           <supportedFormFactors>
               <supportedFormFactor type="Large" />
           </supportedFormFactors>

           <property name="text" type="string" default="A medium header" />
           <property name="colorhex" type="string" default="1B3971" />
           <property name="topPadding" type="string" default="0" />
           <property name="rightPadding" type="string" default="0" />
           <property name="leftPadding" type="string" default="0" />
           <property name="bottomPadding" type="string" default="0" />
       </targetConfig>
   </targetConfigs>

</LightningComponentBundle>
```

**Static Images** — 커스텀 static image 생성 샘플.
> Important: static resource를 쓰지 않는다(오프라인 미지원·deprecated). LWC에서는 **ContentAsset만** 사용한다. Using Assets in LWC, How to Create Assets, Viewing and Editing Assets 참조.
```html
// Below is the HTML block
<template>
   <div>
       <div class="image" style={inlineStyle}>
           <img src={salesforceUrl} />
       </div>
   </div>
</template>
```
```javascript
// Below is the JavaScript block
import { LightningElement, api } from "lwc";
import SALESFORCE_LOGO from "@salesforce/contentAssetUrl/salesforce";

export default class DemoSalesforceLogo extends LightningElement {
   @api width;
   @api height;

    // Expose the static resource URL for use in the template
    get salesforceUrl() {
        return SALESFORCE_LOGO;
    }

    get inlineStyle() {
        return `width: ${this.width}px;height: ${this.height}px`;
    }
}
```
```xml
// Below is the Extensible Markup Language block
<?xml version="1.0" encoding="UTF-8" ?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
   <apiVersion>54.0</apiVersion>
   <isExposed>true</isExposed>
   <targets>
       <target>lightning__ServiceDocument</target>
   </targets>
   <targetConfigs>
       <targetConfig targets="lightning__ServiceDocument">
           <supportedFormFactors>
               <supportedFormFactor type="Large" />
               <supportedFormFactor type="Small" />
           </supportedFormFactors>

           <property name="width" type="integer" />
           <property name="height" type="integer" />
       </targetConfig>
   </targetConfigs>

</LightningComponentBundle>
```
**ContentAsset** — SFDX로 contentAsset을 배포하는 코드:
```xml
// Below is the XML block:
<?xml version="1.0" encoding="UTF-8" ?>
<ContentAsset xmlns="http://soap.sforce.com/2006/04/metadata">
   <isVisibleByExternalUsers>true</isVisibleByExternalUsers>
   <language>en_US</language>
   <masterLabel>salesforce</masterLabel>
   <relationships>
       <organization>
           <access>VIEWER</access>
       </organization>
       <workspace>
           <access>INFERRED</access>
           <isManagingWorkspace>true</isManagingWorkspace>
           <name>sfdc_asset_company_assets</name>
       </workspace>
   </relationships>
   <versions>
       <version>
           <number>1</number>
           <pathOnClient>salesforce.png</pathOnClient>
       </version>
   </versions>
</ContentAsset>
```

---

## ③ Configure Deep Linking

> field technician은 모바일 디바이스로 복잡한 작업을 수행하며, 일부 작업은 여러 탭·flow·action 간 이동을 요구한다. deep linking으로 사용자를 앱의 정확한 위치로 직접 보낼 수 있다.

deep linking은 **URI(Uniform Resource Identifier)**라는 링크로 모바일 앱이 서로 상호작용하게 한다. Field Service에는 사전 정의된 URI scheme이 있어 이메일·웹사이트·third-party 앱의 링크에서 Field Service 앱을 실행할 수 있다. 어드민·개발자는 커스텀 URI를 만들어 특정 탭을 표시할 수 있다(예: field technician이 청구에 사용하는 third-party 앱 통합).

> 인증되지 않은 사용자가 Field Service URI를 탭하면 로그인 화면으로 이동한다. 로그인 후 링크된 페이지를 보려면 URI를 다시 탭해야 한다.

### 3-A. Deep Linking Schema

**URI Schema Format** — 사용 가능한 두 가지 형식:
- `<com.salesforce.fieldservice>://v1/sObject/<id>/<action>?<params>`
- `<com.salesforce.fieldservice>://v1/globalaction/<api_name>?<params>`

각 파라미터:
- **com.salesforce.fieldservice** — 지원되는 Salesforce schema name.
- **v1** — deep linking의 현재 버전(static value).
- **sObject** — Salesforce 객체의 single instance. Field Service 앱이 지원하는 모든 객체 타입(work order, service appointment, asset 등)을 지원한다.
- **id** — 객체의 고유 single instance. **15자·18자** 길이 ID가 지원된다.
- **action** — 지원되는 URI schema 작업. 유효한 action은 아래 Supported URI Schemes에 나열. action을 지정하지 않으면 work order·service appointment 등을 Overview 또는 Details 탭으로 보낸다.
- **globalaction** — global quick action의 이름.
- **api_name** — 일부 deep link는 기능 수행에 API name이 필요하다(예: quick action URI는 quick action API name, flow URI는 flow API name).
- **params** — global quick action에 사용되는 field·value 쌍.

**Supported URI Schemes** (URI 스킴 12종 전수, 각 example URL 포함):

1. **`com.salesforce.fieldservice://v1/sObject/<id>`** — Overview 또는 Details 탭으로 링크.
   - work order·work order line item ID → **Overview** 탭.
   - service appointment ID → **Details** 탭(예외: SA의 parent가 work order면 iOS는 work order Overview, Android는 SA Details / parent가 work order line item이면 iOS는 work order line item Overview, Android는 SA Details).
   - 그 외 모든 객체 타입 → 객체의 **Details** 탭.
   - 예: `com.salesforce.fieldservice://v1/sObject/0WO5500000001UZGAA` — work order의 Overview 탭으로 링크.
2. **`.../sObject/<id>/details`** — 모든 객체 타입의 Details 탭.
   - 예: `.../sObject/0WO5500000001UZGAA/details`
3. **`.../sObject/<id>/related`** — 모든 객체 타입의 Related 탭.
   - 예: `.../sObject/0WO5500000001UZGAA/related`
4. **`.../sObject/<id>/products`** — 해당되는 모든 객체의 Products 탭. Products 탭이 없으면 Details 탭으로 링크.
   - 예: `.../sObject/0WO5500000001UZGAA/products`
5. **`.../sObject/<id>/feed`** — 해당되는 객체의 Feed 탭. 없으면 Details 탭.
   - 예: `.../sObject/0WO5500000001UZGAA/feed`
6. **`.../sObject/<id>/location`** — 해당되는 객체의 Location 탭. 없으면 Details 탭.
   - 예: `.../sObject/0WO5500000001UZGAA/location`
7. **`.../sObject/<id>/edit`** — 지정 레코드의 edit 페이지로 링크.
   - 예: `.../sObject/0WO5500000001UZGAA/edit?Subject=Example%20Subject` — edit 페이지로 링크하고 Subject 필드에 "Example Subject"를 채운다.
8. **`.../sObject/<id>/flow/<api_name>`** — 모바일 앱 내에서 Field Service Mobile Flow를 실행(예: 커스텀 service closure flow). 사용하려면 app extension이 이 flow를 참조해야 한다. Setup의 Field Service Mobile Settings에서 App Extension 섹션이 이 flow를 포함하는지 확인한다. URI에는 extension의 URL-encoded name을 사용한다.
   - 예: `.../sObject/0WO5500000001UZGAA/flow/service_response_flow?Subject=Example%20Subject` — "service_response_flow"를 실행하고 "Subject" input 변수에 "Example Subject"를 전달.
9. **`.../sObject/<id>/quickaction/<api_name>`** — 모바일 앱 내에서 quick action 실행. 지원 타입: **Create a Record, Update a Record, Field Service Mobile Extension**. URL 파라미터로 input 전달 가능.
   - 예: `.../sObject/0WO5500000001UZGAA/quickaction/close_order` — close_order quick action 실행.
10. **`com.salesforce.fieldservice://v1/globalaction/<api_name>?<params>`** — 모바일 앱 내에서 global quick action 실행. 지원 타입: **Create a Record, Update a Record, Field Service Mobile Extension**.
    - 예: `.../globalaction/Create_Work_Order?Subject=Example%20Subject` — work order 생성 global quick action 실행.
11. **`com.salesforce.fieldservice://v1/login/<server_name>/<server_url>`** — 제공된 URL로 server에 연결을 추가한다. 사용자가 deep link를 클릭하고 기존 로그인 자격을 입력하면 server에 접근한다. server는 Change Server 목록에 저장되어 반복 로그인이 불필요해진다.
    - Parameters: `<server_name>`은 server 식별용 친숙한 이름(공백·구두점·"illegal" 문자 피함). `<server_url>`은 로그인에 사용하는 URL("http"/"https" 미포함).
    - 예: `com.salesforce.fieldservice://v1/login/employee/my.site.com/contractor/login` — 사용자를 `https://my.site.come/contractor/login`[sic — "come" 오타 원문]로 보내고 Change Server 목록에 employee로 저장.
    - Security Considerations: username·password를 추가할 때는 특히 링크 출처를 신뢰하는지 확인한다. 로그인 링크는 이메일로 직접 보내지 말고 워커가 best practice 교육을 받도록 권장한다. 많은 이메일 클라이언트·메시징 앱은 OS와 무관하게 본문에서 모바일 앱으로의 active link를 지원하지 않는다. 링크 문제 시 먼저 웹 브라우저에서 테스트한다 — 앱에서 열리면 형식이 올바른 것이다. 웹 링크는 되지만 배포 방법이 안 되면 다른 공유 방법(QR 코드, 웹사이트 링크, PDF, 문자 메시지 등)을 찾는다. 모든 third-party 앱이 iOS·Android에서 링크 열기를 지원한다고 보장되지 않는다.
12. **`__signature` 서명 파라미터** — 보안 다이얼로그를 숨기는 서명(섹션 3-B 참조).

### Parameter Passing for Deep Linking

quick action·flow URL 같은 deep linking schema에 파라미터를 전달할 때 유효한 4가지 타입:
- **URL-encoded text 파라미터.** 예: `Short%20text%20input`.
- **숫자 또는 통화.** 예: `1` 또는 `1.45`.
- **Boolean 값.** 예: `true` 또는 `false`. 대소문자 구분 없음. 파라미터를 전달하지 않으면 기본값은 false.
- **URL-encoded date·dateTime 파라미터.** 예: `2019-12-11T17%3A01%3A00.000%2B0000`. URL-encoded timezone 포함(GMT는 `+0000`, AST는 `-0400`).

그 외 파라미터는 지원되지 않는다. 둘 이상의 파라미터를 전달하려면 ampersand(`&`)로 구분한다(예: `firstname=John&lastname=Doe`). 파라미터 개수에 제한은 없으며, 각 파라미터 값은 최대 **100,000자**까지 가능하다. deep link는 최대 **1 MB**까지 인코딩 가능하지만, 더 적은 데이터를 인코딩하는 것이 best practice다.

### 3-B. Hide Deep Linking Security Dialog

> 사용자가 Field Service 모바일 앱에서 action으로의 deep link를 열 때마다 보안 다이얼로그가 action 확인을 요청한다. deep link URL을 security key로 구성하면 이 **Launch action?** 다이얼로그를 숨길 수 있다.

`(이미지: 화면 캡처 — Field Service Settings UI)`

**Step 1: private·public key 생성**
> Note: 키 서명에 Apex를 공식 지원하지 않지만, Apex로 deep link를 서명한다면 **ECDSA-SHA256** 알고리즘을 시도한다.
1. Linux/Mac에서 터미널에 다음 명령을 실행하면 명령을 실행한 폴더에 `.pem` 키 파일이 생성된다:
   ```
   openssl ecparam -genkey -name prime256v1 -noout -out private.pem
   openssl ec -in private.pem -pubout -out public.pem
   ```
2. private.pem·public.pem 사본을 보관해 새 key pair 생성 없이 향후 URL을 서명한다. private.pem이 security key를 포함한다.
3. public.pem을 열고 header·footer를 제외하고 공백·개행 없이 public key를 복사한다. 샘플 public key:
   ```
   MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEkvkDcFieJenYABN8wOLlE2VomNt2
   9/tcTyj+B06ZndRkTjs7+XwrjHe/wOZvjkdYvewhIByLI6uDTYZixDhO1A==
   ```
4. public key를 Field Service Settings UI의 **Advanced Permissions** 섹션에 복사한다. 이 단계는 기능 활성화에 필수다. `(이미지: 화면 캡처)`

**Step 2: deep link URL 서명**
1. 터미널에서 private.pem이 있는 폴더로 이동.
2. deep link URL을 생성하고 클립보드에 복사:
   ```
   // Base URL.
   com.salesforce.fieldservice://v1/sObject/<id>/<action>

   // URL with additional query parameters.
   com.salesforce.fieldservice://v1/sobject/<id>/<action>?param1=value1&param1=value2
   ```
   *(두 번째 줄 `param1` 키가 value1·value2 둘 다에 중복 — 원문 그대로 [sic])*
3. private key로 signature를 생성:
   ```
   pbpaste | openssl dgst -sha256 -sign private.pem | openssl base64 | tr '/+' '_-' | tr -d '=' | tr -d '\n' | pbcopy
   ```
   명령 부분 설명: `pbpaste`는 pasteboard에서 붙여넣기, `openssl dgst`는 sha256으로 private key 서명 해시 생성, `openssl`은 출력을 base64 인코딩, `tr`은 "/+"를 "_-"로 치환 후 "="·개행("\n") 삭제, `pbcopy`는 출력을 pasteboard로 복사.
   > dynamic deep link URL을 쓰면 고유한 URL 파라미터 값 집합마다 새 signature를 생성한다. signature는 URL 문자열에 고유하다(예: `<id>`가 dynamic이면 `<id>` 값이 바뀔 때 새 signature 생성).
4. URL 끝에 query 파라미터 `__signature=<sig>`를 추가해 서명한다(추가 query 파라미터가 있으면 signature 파라미터를 그 뒤에 둔다):
   ```
   // Signed URL.
   com.salesforce.fieldservice://v1/sObject/<id>/<action>?__signature=<sig>

   // Signed URL with additional query parameters.
   com.salesforce.fieldservice://v1/sobject/<id>/<action>?param1=value1&param1=value2&__signature=<sig>
   ```

technician이 URL을 클릭하면 deep link가 Field Service 앱에서 열리고 앱은 public key로 signature를 검증한다. public key hash가 일치하면 **Launch action?** 다이얼로그 없이 URL이 로드된다. 일치하지 않으면 사용자가 action을 확인해야 한다.

### 3-C. Pass Data to an LWC with Deep Linking

> deep linking으로 LWC 간 또는 외부 앱에서 LWC로 데이터를 전달한다(Android·iOS 모두 지원).

deep linking으로 파라미터를 전달하려면(예: LWC form에 데이터 전달) quick actions URI schema를 사용하고 `<api_name>`에 LWC quick action을 넣은 뒤 파라미터 key·value 쌍을 붙인다:
```
com.salesforce.fieldservice://v1/sObject/<id>/quickaction/<api_name>?<parameterKey1>=<parameterValue1>&<parameterKey2>=<parameterValue2>&...
```
`LWC_Pass_Fields` quick action으로 Jane Doe의 first/last name을 LWC에 전달하는 예:
```
/quickaction/LWC_Pass_Fields?FirstName=Jane&LastName=Doe
```
데이터를 받으려면 deep link가 여는 LWC의 current page reference 소스 코드도 업데이트한다:
```javascript
import {CurrentPageReference} from 'lightning/navigation';

// Declare the variable for the parameter value.
parameterValue;

// Call the page reference that describes the current LWC page.
@wire(CurrentPageReference)
setCurrentPageReference(currentPageReference) {
  // Pass parameter values using the currentPageReference state attribute.
  // Replace <parameterKey> with the parameter key name used in the deep link URL.
  this.parameterValue = currentPageReference.state.<parameterKey>;
}
```

---

## ④ Add Lighting [sic] Web Components for Plug-Ins

> Field Service 모바일 앱을 LWC 플러그인으로 강화한다.

> [!note] [sic] PDF 원문은 모든 페이지 헤더에서 이 섹션 제목을 "Add **Lighting** Web Components"로 표기한다(올바른 표기는 "Lightning").

### 플러그인 목록 (7종)

아래 5개 플러그인은 **Mobile and Offline Developer Guide**의 해당 가이드로 연결되며, Field Service 가이드에서는 외부 참조만 한다. (모바일 기능 플러그인의 일반 메커니즘은 [[모바일 기능 패턴]] 참조.)

- **Access a Mobile Device's Biometrics Capabilities** — LWC가 디바이스 biometrics 기능으로 사용자 신원 확인을 요청한다. 결과는 호출한 LWC로 반환된다. biometrics 체크는 디바이스에서 로컬로 관리되어 네트워크 연결이 불필요하다. 단 **BiometricsService**는 호환 Salesforce 모바일 앱 내에서만 사용 가능한 platform-specific API 접근이 필요하다.
- **Scan Documents on a Mobile Device** — LWC가 디바이스 카메라·OCR로 문서를 스캔한다. 성공 시 추출된 text 데이터가 호출 LWC로 반환된다. **DocumentScanner**는 machine printed text를 인식하며 handwriting은 인식하지 않는다.
- **Monitor Geofence Regions on a Mobile Device** — LWC가 디바이스 location 기능으로 사용자의 관심 영역 근접도를 판단하거나 location 작업을 수행한다. longitude·latitude·radius가 관심 영역 주변 geofence를 정의한다. geofence는 로컬로 판단되어 네트워크 연결이 불필요하다. 단 **GeofencingService**는 디바이스 GPS 신호가 필요하고, Android는 system settings에서 Google Location Accuracy가 활성화돼야 한다. platform-specific API 접근도 필요하다.
- **Use Location on a Mobile Device** — LWC가 디바이스 location 기능으로 현재 위치(및 소지자)를 판단한다. 특정 시점의 현재 위치에 접근하거나, location 변경을 subscribe해 의미 있는 변경 시 업데이트를 받는다. location은 로컬로 판단되어 네트워크 연결이 불필요하다. **LocationService**는 platform-specific API 접근이 필요하다.
- **Interact with NFC Tags on a Mobile Device** — LWC가 디바이스 native NFC 기능으로 NFC 태그를 read·erase·write한다. 성공 시 추출된 text 데이터 또는 success 메시지가 호출 LWC로 반환된다.
- **Accept On-Site Payments with Tap-to-Pay** — LWC가 Payments 플러그인의 Tap-to-Pay 기능으로 고객이 모바일 워커에게 직접 결제하게 한다. Field Service 모바일 앱이 Pay Now와 통합되어 LWC를 안전한 결제 시스템에 연결한다. **PaymentsService** 플러그인은 Tap to Pay로 결제 수집을 가능하게 하며, Salesforce Payments와 결제 provider로 Stripe와 통합된다. Tap to Pay는 Stripe를 provider로 하는 iOS·Android 디바이스에서 지원된다.

아래 2개는 **Field Service 가이드에서 직접 다룬다** (4-A, 4-B):
- **Scan Barcodes on a Mobile Device** — UPC symbol·QR code 등 바코드 스캔.
- **Capture a Space on a Mobile Device** — AR SpaceCapture로 방의 2D/3D 모델 생성.

### 4-A. Scan Barcodes on a Mobile Device

> LWC가 디바이스 카메라·모바일 OS 기능으로 UPC symbol·QR code 같은 바코드를 스캔한다. 성공 시 바코드에서 읽은 데이터가 호출 LWC로 반환된다.

스캔은 디바이스에서 로컬로 수행되어 네트워크 연결이 불필요하다. **BarcodeScanner**는 호환 Salesforce 모바일 앱 내에서만 사용 가능한 platform-specific API 접근이 필요하다.

> Important: BarcodeScanner는 desktop·mobile을 막론하고 웹 브라우저에서 실행될 때 동작하지 않으며 동작할 수 없다.

BarcodeScanner는 스캔된 바코드에 인코딩된 데이터의 string 값을 컴포넌트에 제공한다. 디코딩된 값을 해석·처리하지 않는다.

> Note: 이 바코드 스캐너 플러그인은 Field Service 모바일 앱 전용이다.

**Use the BarcodeScanner API:**
- BarcodeScanner를 컴포넌트 정의에 import해 API 함수를 코드에서 사용 가능하게 한다.
- scanning lifecycle 함수를 호출하기 전 BarcodeScanner 사용 가능 여부를 테스트한다.
- scanning lifecycle 함수로 스캔을 start·continue·stop한다.

> Note: LWC 스캔 코드에서는 modern **scan()**·**dismiss()** API 사용을 권장한다. legacy API **beginCapture(), resumeCapture(), endCapture()**는 아직 사용 가능하지만 향후 릴리즈에서 retire된다.

**Add BarcodeScanner to an LWC** — **lightning/mobileCapabilities** 모듈에서 `getBarcodeScanner` factory 함수를 import:
```javascript
import { getBarcodeScanner } from "lightning/mobileCapabilities";
```
import 후 factory 함수로 BarcodeScanner 인스턴스를 얻고, 유틸리티 함수·상수로 스캐너 가용성 확인 및 스캔 구성을 하며, scanning lifecycle 함수로 스캔을 수행한다.

**Test BarcodeScanner Availability** — BarcodeScanner는 물리 하드웨어·플랫폼 기능에 의존한다. desktop에서는 오류 없이 렌더링되지만 scanning 함수는 실패한다. 사용 전 가용성을 테스트한다:
```javascript
import { LightningElement } from 'lwc';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
export default class ImplementBarcodeScanner extends LightningElement {
  const myScanner = getBarcodeScanner();

   barcodeResults = 'Nothing scanned yet!';

   handleBeginScanClick(event) {
    if(myScanner.isAvailable()) {
      // Perform scanning operations
      let scanningOptions = {
        "barcodeTypes": ["code128","code39", "code93", "ean13", "ean8", "upca", "upce", "qr", "datamatrix", "itf", "pdf417"], "instructionText":"Position barcode in the scanner view.\nPress x to stop.",
"successText":"Successful Scan!"
      };
      myScanner.scan(scanningOptions)
        .then((results) => {
          // Do something with the results of the scan
          this.barcodeResults = '';
          results.forEach(result => {
            this.barcodeResults += 'type: ' + result.type + ', value: ' + result.value + '\n';
          });
        })
        .catch((error) => {
          // Handle cancellation and scanning errors here
          this.barcodeResults = 'Error code: ' + error.code + '\nError message: ' + error.message;
        })
        .finally(() => {
          myScanner.dismiss();
        });
  } else {
      // Scanner not available
      // Not running on hardware with a scanner
      // Handle with message, error, beep, and so on
      this.barcodeResults = 'Problem initiating scanner. Are you using a mobile device?';
        }
    }
}
```
> [sic] 위 코드 내 `scanningOptions.barcodeTypes`(code128/code39/code93/ean13/ean8/upca/upce/qr/datamatrix/itf/pdf417)는 아래 공식 "Supported Barcode Types" 목록과 표기·구성이 다르다 — 원문 그대로 보존.

**Supported Barcode Types** (지원 바코드 타입 11종 전수):
aztec · code39 · code93 · code128 · dataMatrix · ean8 · ean13 · interleaved2of5 · pdf417 · qr · upce

**Scan a Barcode** — scanning lifecycle 함수로 스캔: `scan(options)`로 시작, promise로 반환되는 결과 처리, `dismiss()`로 종료.
```javascript
myScanner
  .scan(scanningOptions)
  .then((result) => {
    // Do something with the result of the scan
    console.log(result);
    this.scannedBarcode = result.value;
  })
  .catch((error) => {
    // Handle cancellation and scanning errors here
    console.error(error);
  })
  .finally(() => {
    myScanner.dismiss();
  });
```
SEE ALSO: **BarcodeScanner API**

### 4-B. Capture a Space on a Mobile Device (AR SpaceCapture)

> AR SpaceCapture 플러그인을 사용하는 LWC를 만들어 방의 2D/3D 모델을 생성한다. 디바이스의 Lidar 기능으로 물리 환경을 대화형으로 스캔하여 모델을 만든다.

> Note: AR SpaceCapture 플러그인은 Lidar를 갖춘 iOS 디바이스(iPhone 12 pro+, iPad Pro 이상)에서, iOS 16.0+·iPadOS 16.0+에서만 지원된다.

> Note: 이 AR SpaceCapture 플러그인은 Field Service 모바일 앱 전용이다.

SEE ALSO: **Apple's RoomPlan**

**1. Add AR SpaceCapture to an LWC** — **lightning/mobileCapabilities**에서 `getARSpaceCapture()` factory 함수 import:
```javascript
import {getARSpaceCapture} from 'lightning/mobileCapabilities';
```
import 후 factory 함수로 ARSpaceCapture 인스턴스를 얻고, 유틸리티 함수·상수로 가용성을 확인한 뒤 feature 함수로 기능을 수행한다.

**2. Test AR SpaceCapture Availability** — desktop·mobile browser에서는 오류 없이 렌더링되지만 함수는 실패한다. 사용 전 가용성 테스트:
```javascript
handleCheckARSpaceCaptureClick(event) {
    const myARSpaceCapture = getARSpaceCapture();
    if(myARSpaceCapture.isAvailable()) {
  // Perform next operations
  } else {
 // AR SpaceCapture isn't available, or consuming app hasn't implemented it
 // Not running on hardware with AR functionality, etc.
 // Handle with message, error, beep, and so on
  }
}
```

**3. Start an AR SpaceCapture Scan** — `scanRoom()` 함수로 방 스캔을 시작하고, USDZ 파일을 나타내는 JSON 파일을 처리한다:
```javascript
handleScanRoomClicked(event) {
    if (this.myARSpaceCapture != null && this.myARSpaceCapture.isAvailable()) {
        this.myARSpaceCapture.scanRoom()
            .then((arSpaceCaptureResult) => {
                console.log(JSON.stringify(arSpaceCaptureResult, undefined, 2))
            })
            .catch((error) => {
                console.log(error);
            });
      }
}
```
Considerations: 스캔 시작 시 바닥이 평평해야 한다. 스캔된 공간은 같은 레벨의 항목만 포함한다.

**AR SpaceCapture User Experience** — 컴포넌트는 원하는 UX를 제공할 수 있지만, AR SpaceCapture 스캔을 호출하는 컴포넌트는 공통 flow를 따라야 한다. 사용자가 space capture 스캔을 트리거하는 action을 수행하면, OS가 카메라를 올바른 방향으로 향하도록 메시지를 제공하고 바닥·천장으로 카메라를 이동하도록 지시한다. 스캔 실패 시 OS가 오류 메시지를 제공한다. `(이미지: 화면 캡처 — AR scan UX)`

**AR SpaceCapture Example** — 컴포넌트의 HTML 템플릿은 최소한이며 방 스캔을 시작하는 버튼을 포함한다:
```html
<template>
  <div style="height: 100%; padding: 0px;margin: 0px;">
    <table class="rootTable" style="width: 100%; height: 100%; padding: 0px; border-spacing: 5px">
       <thead>
         <tr>
            <th colspan="3">
              <h1>AR SpaceCapture Demo</h1>
            </th>
         </tr>
       </thead>
       <tbody>
         <tr style="height: 1px;">
          <td><input type="button" class="lightningButton" onclick={handleBeginScanRoomClick} value='Scan Room' style="width: 100%; height: 50px; border: none; color: white; background: #0072d9; border-radius: 6px; font-size: medium; white-space: normal; word-wrap: break-word;"/></td>
        </tr>
        <tr>
          <td colspan="3">
            <div lwc:ref="previewDivSummary" class="previewDivSummary" style="width: 100%; height: 100%; border: 1px solid #c3c3c3; border-radius: 6px;">
               Summary: <br>
               <div lwc:ref="outputDivSummary" id="outputDivSummary" style="margin: 10px;">Results will be shown here soon...</div>
             </div>
          </td>
        </tr>
        <tr>
          <td colspan="3">
            <div lwc:ref="previewDiv" class="previewDiv" style="width: 100%; height: 100%; border: 1px solid #c3c3c3; border-radius: 6px;">
               Full JSON: <br>
               <div lwc:ref="outputDiv" id="outputDiv" style="margin: 10px;">Results will be shown here soon...</div>
             </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
```
다음 예는 AR SpaceCapture로 방을 스캔하게 한다:
```javascript
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getARSpaceCapture } from 'lightning/mobileCapabilities';

export default class ArSpaceCaptureNew extends LightningElement {
 myARSpaceCaptureScanner;
 scanRoomDisabled = false;
 capturedRoomsData = '';

 // When the component is initialized, determine whether to enable the Scan Room button
 connectedCallback() {
  this.myARSpaceCaptureScanner = getARSpaceCapture();
  if (this.myARSpaceCaptureScanner?.isAvailable() != true) {
   this.scanRoomDisabled = true;
  }
 }

 handleBeginScanRoomClick() {
  // Reset capturedRoomsData to empty string before starting a new scan
  this.capturedRoomsData = '';

  // Make sure AR SpaceCapture is available before trying to use it.
  // Scan Room button also disabled when scanner unavailable
  if (this.myARSpaceCaptureScanner?.isAvailable()) {
   let options = {};

   // Starting the scanning process
   this.myARSpaceCaptureScanner.scanRoom(options)
    .then((results) => {
     try {
      this.refs.outputDiv.innerHTML = "";
     } catch (ex) {
      }

      const capturedRooms = results.capturedRooms ?? [];
      if (capturedRooms) {
       // Array of Rooms
       let summary = {};

       try {
        summary.isSuccess = results.isSuccess;
        summary.wallsCount = results.capturedRooms[0].walls.length;
        summary.floorsCount = results.capturedRooms[0].floors.length;
        summary.openingsCount = results.capturedRooms[0].openings.length;
        summary.doorsCount = results.capturedRooms[0].doors.length;
        summary.windowsCount = results.capturedRooms[0].windows.length;

          if (results.capturedRooms[0].floors.length > 0) {
           summary.roomSizeWidth = results.capturedRooms[0].floors[0].dimensions[0];
           summary.roomSizeHeight = results.capturedRooms[0].floors[0].dimensions[1];
           summary.roomVolume = summary.roomSizeWidth * summary.roomSizeHeight;
          }

          if (results.capturedRooms[0].openings.length > 0) {
           summary.openingSizeWidth = results.capturedRooms[0].openings[0].dimensions[0];
           summary.openingSizeHeight = results.capturedRooms[0].openings[0].dimensions[1];
           summary.openingVolume = summary.openingSizeWidth * summary.openingSizeHeight;
          }

          if (results.capturedRooms[0].doors.length > 0) {
           summary.doorSizeWidth = results.capturedRooms[0].doors[0].dimensions[0];
           summary.doorSizeHeight = results.capturedRooms[0].doors[0].dimensions[1];
           summary.openingVolume = summary.doorSizeWidth * summary.doorSizeHeight;
          }

          this.refs.outputDivSummary.innerHTML = "<pre><code>" + JSON.stringify(summary, undefined, 2) + "</code></pre>";
       this.refs.outputDiv.innerHTML = "<pre><code>" + JSON.stringify(results, undefined, 2) + "</code></pre>";
      } catch (ex) {
       this.refs.outputDivSummary.innerHTML = ex.code + "<br>" + ex.message;
      }
     } else {
// Single Room
       try {
         let summary = {};

         summary.isSuccess = results.isSuccess;
         summary.wallsCount = results.capturedRoom.walls.length;
         summary.floorsCount = results.capturedRoom.floors.length;
         summary.openingsCount = results.capturedRoom.openings.length;
         summary.doorsCount = results.capturedRoom.doors.length;
         summary.windowsCount = results.capturedRoom.windows.length;

         if (results.capturedRoom.floors.length > 0) {
          summary.roomSizeWidth = results.capturedRoom.floors[0].dimensions[0];
          summary.roomSizeHeight = results.capturedRoom.floors[0].dimensions[1];
          summary.roomVolume = summary.roomSizeWidth * summary.roomSizeHeight;
         }

         if (results.capturedRoom.openings.length > 0) {
          summary.openingSizeWidth = results.capturedRoom.openings[0].dimensions[0];
          summary.openingSizeHeight = results.capturedRoom.openings[0].dimensions[1];
          summary.openingVolume = summary.openingSizeWidth * summary.openingSizeHeight;
         }

         if (results.capturedRoom.doors.length > 0) {
          summary.doorSizeWidth = results.capturedRoom.doors[0].dimensions[0];
          summary.doorSizeHeight = results.capturedRoom.doors[0].dimensions[1];
          summary.doorVolume = summary.doorSizeWidth * summary.doorSizeHeight;
         }

       this.refs.outputDivSummary.innerHTML = "<pre><code>" + JSON.stringify(summary, undefined, 2) + "</code></pre>";
       this.refs.outputDiv.innerHTML = "<pre><code>" + JSON.stringify(results, undefined, 2) + "</code></pre>";
      } catch (ex) {
       this.refs.outputDivSummary.innerHTML = ex.code + "<br>" + ex.message;
      }
     }
    })
    .catch((error) => {
      // There was an error while scanning
      this.refs.outputDivSummary.innerHTML = error.code + "<br>" + error.message;
    })
    .finally({
      // Close capture process regardless of whether we completed successfully or had an error
      // this.myARSpaceCaptureScanner.dismiss();
    });
  } else {
   this.refs.outputDivSummary.innerHTML = 'AR SpaceCapture is not available on your device.';
  }
 }
}
```
> [sic/주의] 결과 객체는 `capturedRooms`(복수, 배열)와 `capturedRoom`(단수) 두 형태를 모두 처리한다. summary 필드: isSuccess, wallsCount, floorsCount, openingsCount, doorsCount, windowsCount, roomSizeWidth/Height, roomVolume, openingSizeWidth/Height, openingVolume, doorSizeWidth/Height, doorVolume. floors/openings/doors의 각 dimensions[0]=width, [1]=height. 첫 분기의 doors 블록에서 `openingVolume`에 잘못 대입(원문 버그 그대로). `finally`에 콜백이 아닌 객체 `{}`를 넘김(원문 그대로). `dismiss()`는 주석 처리됨.

**AR SpaceCapture API** — LWC에서 디바이스 카메라·AR 기능에 접근:
```javascript
function scanRoom(options) {
 return new Promise((resolve, reject) => {
  // Implement the logic to scan the room using the provided options
  // and return the ARSpaceCaptureResult
  // When the scan is complete, resolve the promise with the result
  resolve({
   // Populate the ARSpaceCaptureResult object with the appropriate data
  });
 });
}
```

---

## @salesforce 모듈 / 타깃 요약

**@salesforce 모듈 / wire 어댑터:**
- `lightning/uiRecordApi` — getRecord, createRecord, deleteRecord, updateRecord
- `lightning/uiObjectInfoApi` — getObjectInfo
- `lightning/uiGraphQLApi` — gql, graphql
- `lightning/navigation` — CurrentPageReference (deep link 데이터 수신)
- `lightning/mobileCapabilities` — getBarcodeScanner, getARSpaceCapture (factory 함수)
- `lightning/platformShowToastEvent` — ShowToastEvent
- `@salesforce/contentAssetUrl/<name>` — ContentAsset URL import

**js-meta.xml 타깃:** `lightning__ServiceDocument`(Document Builder용) · `<supportedFormFactor type="Small" />`(모바일 preview 표시 필수) · `<supportedFormFactor type="Large" />`(데스크톱)

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Field Service 데이터 모델·개요 허브. 이 모바일 앱 노트의 상위 컨텍스트.
- [[모바일 & 오프라인 (LWC)]] — LWC Offline 일반 메커니즘(Briefcase 프라이밍·GraphQL wire·draft records). 이 노트의 동반 가이드(보완 관계).
- [[모바일 기능 패턴]] — `lightning/mobileCapabilities` 모바일 기능 플러그인(BarcodeScanner·BiometricsService·LocationService 등) 일반 패턴.
- [[Tooling API 객체 — Experience·콘텐츠·커머스 (사이트·모더레이션·관리형콘텐츠·웹스토어)]] — BriefcaseDefinition 등의 Tooling API sObject facet
