---
tags: [Admin, InstalledPackages, ManagedPackage, PackageLicense, ManageLicenses, PackageUninstall, AppExchange, Subscriber, 설치된패키지, 패키지관리, 라이선스관리, 패키지제거]
source: help.salesforce.com — Manage Installed Packages (xcloud.distribution_managing_packages.htm) · View Installed Package Details (xcloud.distribution_package_detail.htm) · Manage/Assign/Remove Licenses for Installed Packages (xcloud.distribution_managing_licenses.htm · distribution_assigning_user_licenses.htm · distribution_removing_user_licenses.htm) · Uninstall a Managed Package (xcloud.distribution_uninstalling_packages.htm) · Install a Managed Package (xcloud.distribution_installing_packages.htm) — 확인 2026-07-12
created: 2026-07-12
aliases: [Installed Packages, Manage Installed Packages, Manage Licenses, Package License, Uninstall Package, 설치된 패키지, 패키지 라이선스 관리, 패키지 제거, 구독자 어드민 패키지 관리, subscriber package admin]
---

# Installed Packages 관리 (구독자·어드민 관점)

> 구독자 org의 어드민이 Setup의 **Installed Packages**에서 설치된 관리형/비관리형 패키지를 조회하고, **Manage Licenses**로 사용자에게 seat를 할당하며, 업그레이드·제거(Uninstall)·데이터 export를 수행하는 방법을 정리한다. (패키지를 *만들어 배포*하는 퍼블리셔 관점은 [[2GP — Install · Uninstall]]로 위임)

---

## 0. 이 노트의 범위 — 구독자 vs 퍼블리셔

| 관점 | 하는 일 | 위치 |
|---|---|---|
| **구독자·어드민 (이 노트)** | 남이 만든 패키지를 org에 **설치·라이선스 할당·업그레이드·제거** | Setup › **Installed Packages** |
| 퍼블리셔·개발자 | 패키지를 **생성·버전·promote·배포**, InstallHandler 스크립트 | [[2GP — Install · Uninstall]], `sf package ...` CLI |

> Setup 경로/버튼 라벨은 인용 문서 기준(확인 2026-07-12)이며 릴리스에 따라 미세하게 달라질 수 있다. 실제 org의 화면 라벨을 우선한다.

---

## 1. Installed Packages 페이지 (Setup)

**경로:** Setup › Quick Find에 `Installed Packages` 입력 › **Installed Packages** 선택.

- 사용 가능 에디션: Salesforce Classic(일부 org 제외) · Lightning Experience / Essentials · Group · Professional · Enterprise · Performance · Unlimited · Developer.
- 필요 권한: **Download AppExchange Packages**(설치·제거·export 파일 다운로드/삭제) · **Manage Package Licenses**(라이선스 할당).
- **관리형(managed) 패키지만** 라이선스 정보가 표시된다. 비관리형(unmanaged)은 `Allowed Licenses`·`Used Licenses`·`Expiration Date`가 모두 **"N/A"**.

### 1-1. 목록에서 가능한 작업

| 작업(링크/버튼) | 설명 |
|---|---|
| **Uninstall** | 패키지와 모든 컴포넌트를 org에서 제거 (§4) |
| **Upgrade to Recommended Version** | 퍼블리셔가 권장하는 버전으로 설치(업그레이드) (§3) |
| **Manage Licenses** | org 사용자에게 가용 라이선스 할당 (§2) |
| **Enable for Platform Integrations** / **Disable for Platform Integrations** | 특정 Salesforce 소유 관리형 패키지가 org 외부 데이터에 접근하도록 허용/취소. **Salesforce 소유 패키지의 요청이 있을 때만** 활성화 |
| **Become Primary Contact** | 설치된 패키지의 현재 연락처를 내 사용자명으로 변경. 이 이름은 퍼블리셔의 Push Package Upgrade 페이지에 표시됨. 초기값은 설치한 사람. Download AppExchange Packages 권한이 있고 현재 primary contact가 아니면 활성화 |
| **Configure** | 퍼블리셔가 설정 안내 외부 링크를 포함한 경우 표시 |
| 패키지 이름 클릭 | 상세 페이지로 이동 (§1-3) |

> **site license를 구매했거나** 관리형 패키지가 **라이선스되지 않은** 경우, Salesforce가 모든 사용자에게 자동 할당하며 라이선스를 관리할 수 없다(사용자는 적절한 권한만 있으면 사용 가능).

### 1-2. 목록 컬럼(속성) — 알파벳순

```text
// 구조 예시 — 실제 화면 레이아웃 아님. 문서에 기재된 속성명을 나열.
Action              Uninstall 또는 Manage Licenses
Allowed Licenses    이 패키지로 구매한 총 라이선스 수. site license면 "Unlimited"
Apps                패키지의 custom app 개수
Connected Apps      사용자·앱 검증 후 Salesforce 데이터에 접근 가능한 connected app 목록
Description         패키지 상세 설명
Expiration Date     라이선스 만료일. 만료 없으면 "Does Not Expire". (관리형+라이선스일 때만)
Installed Date      패키지 설치일
Limits              체크되면 패키지의 app/tab/object가 org 한도에 계산됨
Namespace           패키지를 구분하는 1~15자 영숫자 식별자
Objects             패키지의 custom object 개수
Package Name        퍼블리셔가 지정한 패키지 이름
Publisher           패키지 퍼블리셔
Status              Trial / Active / Suspended / Expired / Free (관리형+라이선스일 때만)
Used Licenses       사용자에게 이미 할당된 라이선스 수
Version Number      최신 설치된 패키지 버전 번호 (major.minor.patch)
Version Name        해당 버전의 마케팅 이름(Version Number보다 서술적)
```

> 라이선스된 관리형 패키지를 설치하지 않았다면 `Publisher`·`Status`·`Allowed Licenses`·`Used Licenses`·`Expiration Date` 컬럼은 나타나지 않는다.

### 1-3. 상세 페이지 (패키지 이름 클릭)

목록 속성 외에 추가로 표시:

| 속성 | 설명 |
|---|---|
| **Package Type** | managed / unmanaged 여부 |
| **First Installed Version Number** | org에 처음 설치된 버전(관리형만). 이슈 보고 시 퍼블리셔에게 이 번호를 전달 |
| **Installed By** | 이 패키지를 설치한 사용자 |
| **Post Install Instructions** | 설치 후 설정 정보 링크(외부 URL 권장) |
| **Release Notes** | 릴리스 노트 링크(외부 URL 권장) |
| **Tabs** | custom tab 개수 |

상세 페이지 작업: **Uninstall**, **Manage Licenses**(Lightning Experience에서는 할당 불가 → Salesforce Classic으로 전환), **View Dependencies**(다른 컴포넌트·권한·설정에 의존하는 컴포넌트 목록 검토).

**Unused Components(미사용 컴포넌트):** 현재 버전에서 개발자가 삭제한 컴포넌트 목록. 관리형 패키지의 일부이며 커스텀 통합에서 쓰지 않았다면 삭제해도 안전. 삭제된 컴포넌트는 **15일간** 목록에 남아 undelete(복구)하거나 영구 삭제 가능. 15일 후 필드와 데이터가 영구 삭제. **패키지를 제거하면 미사용 컴포넌트도 함께 삭제**된다. (custom field 삭제 전 Setup › Data Export로 데이터 백업 권장)

---

## 2. 라이선스 관리 (Manage Licenses)

AppExchange에서 라이선스된 관리형 패키지를 설치하면 공급자로부터 일정 수의 라이선스를 구매한다. 각 라이선스를 org 사용자에게 할당하고, 가용 라이선스를 모두 소진했으면 **재할당**하거나 **추가 구매**(공급자에 문의)한다.

- 에디션: Group · Professional · Enterprise · Performance · Unlimited · Developer (Salesforce Classic, 일부 org 제외)
- 권한: **Manage Package Licenses**
- 진입: Setup › **Installed Packages** › 패키지 옆 **Manage Licenses** 링크.

| 화면 요소 | 동작 |
|---|---|
| **Add Users** | 특정 사용자에게 라이선스 할당 (§2-1) |
| **Remove**(사용자 이름 옆) | 단일 사용자 라이선스 회수 |
| **Remove Multiple Users** | 여러 사용자 라이선스 일괄 회수 (§2-2) |
| 컬럼 헤더 클릭 | 오름차순 정렬(다시 클릭 → 내림차순) |
| fewer / more | 표시 목록 길이 조절 |

### 2-1. 라이선스 할당 (Assign — Add Users)

```text
// 절차 — Assign Licenses for Installed Packages
1. Setup › Installed Packages 에서 가용 라이선스가 있는 패키지를 찾는다
   (패키지 접근 권한 + 최소 1개 이상의 가용 라이선스 필요)
2. 패키지 옆 Manage Licenses 링크 클릭
3. Add Users 클릭
4. 드롭다운에서 뷰 선택 또는 Create New View 로 커스텀 뷰 생성
5. 성(last name) 첫 글자로 필터 또는 All 로 전체 표시
6. 사용자 선택:
   · 개별 → 체크박스(선택 시 Selected 목록에 표시) → Add
   · 현재 뷰 전체 → Add All Users → OK
7. (선택) Salesforce 소유 관리형 패키지 요청 시 Enable/Disable for Platform Integrations
```

### 2-2. 라이선스 회수 (Remove)

```text
// 절차 — Remove Licenses for Installed Packages
단일 사용자: Manage Licenses 화면에서 사용자 이름 옆 Remove 클릭
여러 사용자:
1. Setup › Installed Packages › Manage Licenses (패키지 옆)
2. Remove Multiple Users 클릭
3. View 드롭다운/Create New View, 성 첫 글자 필터 또는 All
4. 사용자 선택(선택 시 "Selected for Removal" 목록) → Remove
   또는 현재 뷰 전체 → Remove All Users → OK
```

> **Lightning Experience에서는 라이선스를 할당할 수 없다.** 필요하면 Salesforce Classic으로 전환한다.

패키지 라이선스는 User License / Permission Set License / Feature License 와는 별개 개념이다 → [[User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형)]] 참조.

---

## 3. 업그레이드 (새 버전 설치)

목록에서 **Upgrade to Recommended Version**을 클릭하면 퍼블리셔가 권장하는 버전이 설치된다(= 이전 버전 위에 새 버전 설치). 강제 push 업그레이드는 퍼블리셔 측 기능이다 → 퍼블리셔 관점 [[2GP — Install · Uninstall]].

---

## 4. 제거 (Uninstall)

- 권한: **Download AppExchange Packages**
- 에디션: Classic(일부 제외) · Lightning Experience / Essentials · Group · Professional · Enterprise · Performance · Unlimited · Developer

### 4-1. 절차

```text
// 절차 — Uninstall a Managed Package
1. Setup › Quick Find "Installed Packages" › Installed Packages
2. 제거할 패키지 옆 Uninstall 클릭
3. 패키지 데이터의 사본 저장·export 여부를 라디오 버튼으로 선택
4. "Yes, I want to uninstall" 선택 후 Uninstall 클릭
```

### 4-2. 데이터 보존 (export)

데이터 사본 저장을 선택하면 Salesforce가 **패키지 데이터 + 연관 note + 첨부(attachment)**를 담은 export 파일을 생성한다.
- 대용량 데이터를 export하면 제거 완료까지 시간이 더 걸린다.
- 제거 완료 시 **제거를 수행한 사용자에게 export 파일 링크가 이메일**로 전송된다.
- export 파일·note·attachment는 설치된 패키지 목록 아래에 표시되며 **Download**(열기/저장) · **Del**(삭제) 가능.
- **export 파일은 제거 완료 후 2일 뒤 삭제**되므로 다른 곳에 보관 권장.

### 4-3. 제거 시 데이터·의존성 주의

- custom object를 포함한 패키지를 제거하면 그 object의 **모든 컴포넌트(custom field, validation rule, custom button·link, workflow rule, approval process)**도 함께 삭제된다.
- **아래 경우 제거가 차단된다:**

| 차단 상황 | 예시 |
|---|---|
| 제거 대상 밖 컴포넌트가 패키지 컴포넌트를 참조 | 표준 object의 패키지 custom user field를 트리거하는 workflow rule |
| 서로 무관한 두 패키지가 custom object 컴포넌트를 상호 참조 | expense report 앱의 custom user field를 다른 설치 object의 validation rule이 참조 |
| 설치된 folder에 설치 후 추가한 컴포넌트 존재 | |
| 설치된 letterhead가 설치 후 추가한 email template에 사용 중 | |
| 패키지 custom field를 Einstein Prediction Builder / Case Classification이 참조 | 제거 전 prediction 편집으로 참조 해제 |
| 모든 활성 business·person account record type을 제거하게 됨 | 다른 record type 하나 이상 활성화 후 재시도 |
| background job이 패키지 필드를 갱신 중 | roll-up summary 갱신 등 — job 완료 후 재시도 |

### 4-4. 만료된 관리형 패키지 + 공유 규칙

라이선스가 만료된 관리형 패키지의 필드를 criteria-based sharing rule이 참조하면, Setup의 규칙 정의 필드 드롭다운에서 해당 필드 라벨에 **(expired)**가 붙는다. 만료 필드를 참조하는 규칙은 **재계산되지 않고** 신규 레코드도 공유되지 않지만, **만료 이전에 공유된 기존 레코드의 공유는 유지**된다.

---

## 5. 설치 개요 (AppExchange / URL)

구독자가 패키지를 처음 설치하는 흐름(개요):

```text
// 절차 — Install a Managed Package (AppExchange)
1. AppExchange 이동 → 솔루션 검색/브라우즈
2. 리스팅 페이지에서 Get It Now 클릭
   (Get It Now가 없으면 Salesforce 외부에서 쓰는 솔루션 — 공급자에 문의)
3. 환경 선택: production 또는 sandbox
4. 정보 입력·약관 동의 → Confirm and Install
5. 요청 정보 입력 (password 보호 패키지면 공급자에게 받은 password 입력)
6. View Components 로 구성 컴포넌트 검토
7. (Enterprise/Unlimited/Performance/Developer) 패키지에 접근할 사용자 유형 선택
8. Install 클릭
```

- Apex 포함 컴포넌트 설치 시 **패키지 유닛 테스트 + org 전체 유닛 테스트가 실행**된다. 초기 비활성 컴포넌트에 의존하는 테스트는 실패할 수 있으며, **테스트 실패와 무관하게 설치하도록 선택**할 수 있다.
- 설치 완료 후 post-install instructions가 있으면 표시된다.
- 패키지에 permission set이 포함되면 필요한 사용자에게 할당한다. **관리형 패키지의 permission set은 편집 불가**하지만 clone하거나 직접 생성할 수 있고, 이렇게 만든 permission set은 패키지 업그레이드의 영향을 받지 않는다.
- URL 설치(Installation URL, `04t...`) 방식도 있다 — 퍼블리셔가 제공하는 링크로 설치. 상세는 [[2GP — Install · Uninstall]].

---

## 6. 관리형(managed) vs 비관리형(unmanaged) — 구독자 관점 차이

| 항목 | 관리형(managed) | 비관리형(unmanaged) |
|---|---|---|
| Namespace | 있음(1~15자) — 컴포넌트가 네임스페이스로 격리 | 보통 없음 |
| 라이선스 정보 | Allowed/Used Licenses·Expiration·Status 표시 | 전부 **N/A** |
| 업그레이드 | 퍼블리셔가 새 버전 배포 → 업그레이드 가능 | 업그레이드 경로 없음(1회성 배포) |
| 컴포넌트 편집 | 일부 컴포넌트 잠김(예: 관리형 permission set 편집 불가, clone만) | 설치 후 내 메타데이터로 편집·소유 |
| Version 추적 | Version Number/Name·First Installed Version 표시 | 버전 관리 없음 |

---

## 관련 노트
- [[2GP — Install · Uninstall]] — **퍼블리셔 관점**: `sf package install/uninstall` CLI, Installation URL, InstallHandler·UninstallHandler 스크립트, 업그레이드 메타데이터 동작 (설치를 *만드는* 쪽)
- [[User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형)]] — org의 라이선스 유형 체계(패키지 라이선스와 구분되는 User/PSL/Feature License)
- [[Unlocked Package 릴리스와 설치]] — Unlocked Package 설치·업그레이드·의존성 (2GP 계열 배포)
