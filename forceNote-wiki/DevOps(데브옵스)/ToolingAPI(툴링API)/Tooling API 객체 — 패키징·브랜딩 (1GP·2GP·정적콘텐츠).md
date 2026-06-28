---
tags: [tooling-api, devops, packaging, 2gp, 1gp, subscriber-package, branding, static-resource]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [MetadataPackage, MetadataPackageVersion, InstalledSubscriberPackage, InstalledSubscriberPackageVersion, SubscriberPackage, SubscriberPackageVersion, SubscriberPackageVersionUninstallRequest, Package2, Package2Member, Package2Version, Package2VersionCreateRequest, Package2VersionCreateRequestError, PackageInstallRequest, PackageUploadRequest, PackageVersionUninstallRequestError, BrandingSet, BrandingSetProperty, ColorDefinition, StaticResource, Scontrol, 패키징, 1GP, 2GP, 구독자 패키지, 패키지 설치, 브랜딩, 정적 리소스]
---

# Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)

> 패키징·브랜딩·정적콘텐츠 Tooling sObject 20종 전수 — 1GP MetadataPackage·2GP Package2·구독자 패키지 설치/제거·브랜딩 세트·StaticResource 등. 1GP(MetadataPackage*)·2GP(Package2*, Dev Hub)·구독자 뷰(SubscriberPackage*·InstalledSubscriberPackage*)와 설치/업로드/제거 요청, 브랜딩 세트, 정적 리소스/s-control을 SOQL로 조회하거나 일부는 create/update로 운영한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **패키징 + 브랜딩 + 정적 콘텐츠 도메인 sObject 군**을 다룬다. 패키징은 세 갈래로 나뉜다 — **1GP**(1세대 관리형/비관리형: `MetadataPackage`·`MetadataPackageVersion`·`PackageUploadRequest`), **2GP**(2세대 관리형/언락드, Dev Hub: `Package2`·`Package2Member`·`Package2Version`·`Package2VersionCreateRequest`·`Package2VersionCreateRequestError`), **구독자 뷰/설치**(1GP·2GP 공통으로 설치된 패키지를 구독자 org에서 보는 관점: `SubscriberPackage`·`SubscriberPackageVersion`·`InstalledSubscriberPackage`·`InstalledSubscriberPackageVersion`(폐기됨)·`PackageInstallRequest`·`SubscriberPackageVersionUninstallRequest`·`PackageVersionUninstallRequestError`). 여기에 Experience Builder의 브랜딩 세트(`BrandingSet`·`BrandingSetProperty`·`ColorDefinition`)와 Visualforce용 정적 리소스/레거시 s-control(`StaticResource`·`Scontrol`)이 더해진다. 대부분 `query()`로 SOQL 조회가 가능하며, 일부(`StaticResource`·`BrandingSet`·`Package2`·`PackageUploadRequest`·`PackageInstallRequest` 등)는 `create()`/`update()`로 패키지 생성·업로드·설치·제거를 수행한다.

> [!important] 1GP vs 2GP vs 구독자 뷰 구분
> 패키징 객체는 어느 세대·어느 관점에 속하는지로 구별한다.
> - **1GP** (1세대): `MetadataPackage` / `MetadataPackageVersion` — 로그인한 org에서 개발/업로드된 패키지와 그 버전. 업로드 액션은 `PackageUploadRequest`.
> - **2GP** (2세대, Dev Hub): `Package2` / `Package2Member` / `Package2Version` / `Package2VersionCreateRequest`(+`Package2VersionCreateRequestError`) — Dev Hub org에서 2세대 관리형·언락드 패키지와 버전을 생성·관리.
> - **구독자 뷰 / 설치된 패키지**: `SubscriberPackage` / `SubscriberPackageVersion` + `InstalledSubscriberPackage` / `InstalledSubscriberPackageVersion` — 구독자 org에 설치된 패키지를 보는 관점(1GP·2GP 공통).
> - **라이프사이클 액션**: `PackageInstallRequest`(설치) / `PackageUploadRequest`(업로드) / `SubscriberPackageVersionUninstallRequest`·`PackageVersionUninstallRequestError`(제거 요청과 그 에러).

> [!warning] Tooling Ch4에 없는 패키징 객체 (fabricate 금지)
> 아래 객체들은 패키징 객체로 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다.** Dev Hub 객체이거나 별도 챕터/Metadata API 소관이므로 "Tooling API로 다룰 수 있다"고 쓰면 안 된다(검색 시 혼동 방지 — 실제 coverage gap 신호이지 누락이 아니다).
> - **PackageLicense**
> - **PackagePushRequest / PackagePushJob** — `MetadataPackageVersion`의 "Next Step" 산문과 `PackageInstallRequest` 코드 샘플("PackagePushRequest created" 출력)이 `PackagePushRequest`를 거론하지만, **객체 자체는 이 챕터에 문서화되지 않았다.** cross-link/언급만 하고 섹션을 만들지 않는다.
> - **ScratchOrgInfo / ActiveScratchOrg / NamespaceRegistry** (Dev Hub 객체)
> - **BrandTemplate**
> - **ScontrolDefinition**
>
> 참고: **IconDefinition**은 이미 [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]]에 작성됨(링크만, 재추출하지 않음).

> [!note] fabricate 금지 — dump 교정 사항
> - **Package2Version에는 `ReleaseState` 필드가 없다.** 작업 힌트의 `ReleaseState`/`AncestorId`/`ValidationSkipped` ENUM은 오류다 — `AncestorId`는 평범한 `reference`, `ValidationSkipped`는 `boolean`이며, Package2Version에서 picklist는 `Language` 하나뿐이다.
> - **Package2에는 별도 `PackageType` 필드가 없다.** 패키지 종류는 `ContainerOptions`(Managed / Unlocked)로만 구분한다.
> - **InstalledSubscriberPackageVersion은 폐기(deprecated)**되어 향후 릴리스에서 제거 예정이다("not currently in use, will be removed").

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]` 인라인으로 보존한다. AP-09 페이지 경계로 절단되었던 필드(`Package2Version.ValidatedAsync`/`ValidationSkipped`, `Scontrol.NamespacePrefix`/`SupportsCaching`, `SubscriberPackageVersion` 28필드 + 8 서브객체)는 인접 페이지에서 stitch해 전부 포함했다.

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [BrandingSet](#brandingset) | 브랜딩 | 9 | 40.0 |
| [BrandingSetProperty](#brandingsetproperty) | 브랜딩 | 3 | 40.0 |
| [ColorDefinition](#colordefinition) | 브랜딩 | 5 | 43.0 |
| [InstalledSubscriberPackage](#installedsubscriberpackage) | 구독자 | 3 | 41.0 |
| [InstalledSubscriberPackageVersion](#installedsubscriberpackageversion) | 구독자(폐기) | 3 | 41.0 |
| [MetadataPackage](#metadatapackage) | 1GP | 3 | 38.0 (Tooling) |
| [MetadataPackageVersion](#metadatapackageversion) | 1GP | 8 | 38.0 (Tooling) |
| [Package2](#package2) | 2GP | 12 | 41.0 |
| [Package2Member](#package2member) | 2GP | 6 | 41.0 |
| [Package2Version](#package2version) | 2GP | 27 | 41.0 |
| [Package2VersionCreateRequest](#package2versioncreaterequest) | 2GP | 17 | 41.0 |
| [Package2VersionCreateRequestError](#package2versioncreaterequesterror) | 2GP | 2 | 41.0 |
| [PackageInstallRequest](#packageinstallrequest) | 구독자 | 12 | 41.0 |
| [PackageUploadRequest](#packageuploadrequest) | 1GP | 12 | 38.0 |
| [PackageVersionUninstallRequestError](#packageversionuninstallrequesterror) | 구독자 | 2 | 41.0 |
| [Scontrol](#scontrol) | 정적 | 8 | — |
| [StaticResource](#staticresource) | 정적 | 5 | 29.0 (Tooling) |
| [SubscriberPackage](#subscriberpackage) | 구독자 | 4 | 41.0 |
| [SubscriberPackageVersion](#subscriberpackageversion) | 구독자 | 28 (+서브) | 41.0 |
| [SubscriberPackageVersionUninstallRequest](#subscriberpackageversionuninstallrequest) | 구독자 | 2 | 41.0 |

> 필드 수 합계(주 객체) = **171**. SubscriberPackageVersion의 8개 서브객체 복합 타입과 PackageInstallRequest의 서브객체 복합 타입 필드는 171에 포함하지 않는다.

---

## 1GP 패키지 (First-Generation Packaging)

> 로그인한 org에서 개발·업로드되는 1세대 관리형/비관리형 패키지(MetadataPackage)와 그 버전(MetadataPackageVersion), 그리고 버전 업로드 요청(PackageUploadRequest). 1GP↔2GP 비교는 [[2GP Managed Package 개념과 1GP 비교]] 참조.

### MetadataPackage

Represents a package that has been developed in the org you're logged in to. Applies to unlocked, unmanaged, first-generation, and second-generation managed packages. Available in Tooling API version 38.0 and later.

- **Version:** Tooling API version 38.0 and later.
- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| Name | string | Filter, Group, idLookup, Sort | The name of the package. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | For first-generation and second-generation managed packages, and unlocked packages with namespaces, this field is the namespace prefix assigned to the package. For unmanaged packages, or no-namespace unlocked packages, this field is blank. |
| PackageCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The type of package. Valid values are: Application (internal use only), Module (internal use only), Package—Represents either an unmanaged package or a first-generation managed package, Package2—Represents either an unlocked package or a second-generation managed package. The default value is Package. This field is available in API version 49.0 and later. |

### MetadataPackageVersion

Represents a package version (managed or unmanaged) that has been uploaded from the org you're logged in to. Available in Tooling API version 38.0 and later.

- **Version:** Tooling API version 38.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| BuildNumber | int | Filter, Group, Nillable, Sort | The build number of the version. For example, if you upload two beta versions, they have build numbers 1 and 2. Then, when you upload a released build of the same version, the build number is 3. When you upload a new version, the build number resets to 1. |
| IsDeprecated | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the package version is deprecated. Available in API version 46.0 and later. |
| MajorVersion | int | Filter, Group, Nillable, Sort | The first number in a package version number. A version number either has an x.y format or an x.y.z format. The x represents the major version, y the minor version, and z the patch version. |
| MetadataPackageId | reference | Filter, Group, Nillable, Sort | The 18-character package ID, which starts with 033. |
| MinorVersion | int | Filter, Group, Nillable, Sort | The second number in a package version number. A version number either has an x.y format or an x.y.z format. The x represents the major version, y the minor version, and z the patch version. |
| Name | string | Filter, Group, idLookup, Sort | The name of the package version. |
| PatchVersion | int | Filter, Group, Nillable, Sort | The third number in a package version number, if present. A version number either has an x.y format or an x.y.z format. The x represents the major version, y the minor version, and z the patch version. |
| ReleaseState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | If the package version is a beta version, the value is Beta. Otherwise, the value is Released. |

#### MetadataPackageVersion — Usage 쿼리 예제 (verbatim)

| Query | String |
|---|---|
| Get all package versions for the package that has a MetadataPackageID of 033D00000001xQlIAI | `SELECT Id, Name, ReleaseState, MajorVersion, MinorVersion, PatchVersion FROM MetadataPackageVersion WHERE MetadataPackageId = '033D00000001xQlIAI'` |
| Get the package version for the package with a specific MetadataPackageID and a major version greater than 1 | `SELECT Id FROM MetadataPackageVersion WHERE MetadataPackageId ='033D00000001xQlIAI' AND MajorVersion > 1` |
| Get released package versions for the package with a specific MetadataPackageID | `SELECT Id FROM MetadataPackageVersion WHERE MetadataPackageId = '033D00000001xQlIAI' AND ReleaseState = 'Released'` |

#### MetadataPackageVersion — Java Code Sample (verbatim)

> Generates the list of subscriber orgs eligible to be upgraded to version 3.4.6 of a package. Uses the Web Services Connector (WSC).

```java
// Finds all Active subscriber orgs that have the package installed
String PACKAGE_SUBSCRIBER_ORG_KEY_QUERY = "Select OrgKey from PackageSubscribers where
OrgStatus = 'Active' and InstalledStatus = 'I'";

// Finds all MetadataPackageVersions lower than the version given, including the list
// of subscribers for each version
String METADATA_PACKAGE_VERSION_QUERY = "Select Id, Name, ReleaseState, (%s) from"
 + " MetadataPackageVersion where MetadataPackageId = '%s' AND ReleaseState = 'Released'"
 + " AND (MajorVersion < 3 OR (MajorVersion = 3 and MinorVersion < 4)"
 + " OR (MajorVersion = 3 and MinorVersion = 4 and PatchVersion < 6))";

// conn is an EnterpriseConnection instance initialized with a ConnectionConfig object
// representing a connection to the developer org of the package
QueryResult results = conn.query(String.format(METADATA_PACKAGE_VERSION_QUERY,
PACKAGE_SUBSCRIBER_ORG_KEY_QUERY));

// This list will hold all of the PackageSubscriber objects that are eligible for upgrade
// to the given version
List<PackageSubscriber> subscribers = new ArrayList<>();
for (SObject mpvso : results.getRecords()) {

   // Cast the sObject to a MetadataPackageVersion
   MetadataPackageVersion mpv = (MetadataPackageVersion) mpvso;

  // Add subscribers to our list
  if (mpv.getPackageSubscribers() != null) {
   for (SObject psso : mpv.getPackageSubscribers().getRecords()) {
    subscribers.add((PackageSubscriber) psso);
   }
 }
}
```

**Next Step:** Create a push request using PackagePushRequest. *(AP-08: `PackagePushRequest` 객체 자체는 Tooling Ch4 범위 밖 — cross-link만. [[2GP — Push Upgrade]] 참조.)*

### PackageUploadRequest

Represents a request to upload a first-generation package version and its components so that subscribers can install it. Available in API version 38.0 and later.

- **Version:** API version 38.0 and later.
- **Supported SOAP Calls:** create(), describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** Query, GET, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable | A description of the package and what this version contains. |
| Errors | complexvalue | Nillable | Errors that occurred during upload, if any. |
| IsReleaseVersion | boolean | Create, Defaulted on create, Filter, Group, Sort | For managed packages only. Indicates whether the managed package is a released version (true) or a beta version (false). The default is false. |
| MajorVersion | int | Create, Filter, Group, Nillable, Sort | The first number in a package version number. A version number either has an x.y format or an x.y.z format. The x represents the major version, y the minor version, and z the patch version. (The patch version can't be specified; it's automatically assigned when a managed beta is uploaded.) If IsReleaseVersion is false, MajorVersion is ignored. If IsReleaseVersion is true, and a managed beta is the latest uploaded version for the package, the major version must match the major version of the last uploaded beta. |
| MetadataPackageId | reference | Create, Filter, Group, Sort | The 18-character package ID, which starts with 033. |
| MetadataPackageVersionId | reference | Filter, Group, Nillable, Sort | The 18-character package version ID representing the non-deprecated package you're uploading. |
| MinorVersion | int | Create, Filter, Group, Nillable, Sort | The second number in a package version number. (x.y or x.y.z; patch auto-assigned for managed beta.) If MinorVersion isn't specified, the default value is 1 more than the minor version of the currently released package (0 if not released). If IsReleaseVersion is false, MinorVersion is ignored. If IsReleaseVersion is true and a managed beta is the latest uploaded version for the package, the minor version must match the minor version of the last uploaded beta. |
| Password | string | Create, Filter, Group, Nillable, Sort | An optional installation key for sharing the package privately with anyone who has the password value. Don't include the password if you want to make the package available to anyone on AppExchange and share your package publicly. |
| PostInstallUrl | textarea | Create, Nillable | The fully qualified URL of the post-installation instructions. Instructions are shown as a link after installation and are available from the package detail view. |
| ReleaseNotesUrl | textarea | Create, Nillable | The fully qualified URL of the package release notes. Release notes are shown as a link during the installation process and are available from the package detail view after installation. |
| Status | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The status of the upload. Valid values are: Error, In Progress, Queued, Success. |
| VersionName | string | Create, Filter, Group, Sort | Required. The name of the package version. Example: Spring 2016. |

**Status enum (verbatim):** Error, In Progress, Queued, Success

#### PackageUploadRequest — Usage code sample (verbatim, create upload request → upload → poll status)

```java
static private final String packageId = "033xx00000007l0";
static private final Integer packageMajorVersionNumber = 1;
static private final Integer packageMinorVersionNumber = 3;
static private final Boolean isReleaseVersion = true;
static private final String packageVersionDescriptionSuffix =
   isReleaseVersion ? "" : "beta";
static private final String packageVersionDescription =
   "r" + packageMinorVersionNumber + packageVersionDescriptionSuffix;
static private final String packageDescription =
   String.format("This is the most amazing package in the world! ",
      "And %s is the most amazing release so far! ",
      packageVersionDescription);
static private final String packageReleaseNotesUrl = "https://www.example.com";
static private final String packagePostInstallUrl = "https://www.example.com";

// Leave blank or null for no password
static private final String packagePassword = "";

static private final String baseUrl = "https://MyDomainName.my.salesforce.com:6109";
```

```java
// Now create the upload request and start the upload. Uses the Web Services Connector (WSC).
PackageUploadRequest packageUploadRequest = new PackageUploadRequest();
packageUploadRequest.setMetadataPackageId(packageId);
packageUploadRequest.setVersionName(packageVersionDescription);
packageUploadRequest.setDescription(packageDescription);
packageUploadRequest.setMajorVersion(packageMajorVersionNumber);
packageUploadRequest.setMinorVersion(packageMinorVersionNumber);
packageUploadRequest.setPostInstallUrl(packagePostInstallUrl);
packageUploadRequest.setReleaseNotesUrl(packageReleaseNotesUrl);
packageUploadRequest.setIsReleaseVersion(isReleaseVersion);
packageUploadRequest.setPassword(packagePassword);

SObject[] argArray = {packageUploadRequest};
SaveResult[] saveResults = connection.create(argArray);

if (saveResults[0].isSuccess()) {
   // The save result contains the ID of the created request.
   // Save it in the local request.
   packageUploadRequest.setId(saveResults[0].getId());
   System.out.println("PackagePushRequest created, ID: "
      + saveResults[0].getId());
} else {
   for (Error error : saveResults[0].getErrors()) {
      System.out.println(error.getMessage());
   }
}
```

```java
// Checking the Status of an Upload Request
// Find the status of the PackageUploadRequest for a given ID
String query = String.format("SELECT Status,MetadataPackageVersionId
   FROM PackageUploadRequest WHERE Id = '%s'", packageUploadRequest.getId());

boolean inProgress = false;
boolean queued = false;
boolean done = false;
while (true) {
   QueryResult queryResult = connection.query(query);

    PackageUploadRequest updatedPackageUploadRequest =
       (PackageUploadRequest) queryResult.getRecords()[0];

    PackageUploadRequestStatus status = updatedPackageUploadRequest.getStatus();
    switch (status) {
       case Success:
          System.out.println(String.format("Package upload %s completed",
             packageUploadRequest.getId()));
          System.out.println(String.format(
             "Package install url: %s/packaging/installPackage.apexp?p0=%s",
             baseUrl,
             updatedPackageUploadRequest.getMetadataPackageVersionId()));
          done = true;
          break;

       case Error:
          PackageUploadErrors errors = updatedPackageUploadRequest.getErrors();

          if (errors.getErrors().length == 0) {
             System.out.println(String.format(
                "%s: For upload of package %s, no further information available",
                updatedPackageUploadRequest.getStatus(),
                packageUploadRequest.getId()));
          }
          else {
             System.out.println(String.format(
                "%s: For upload of package %s",
                updatedPackageUploadRequest.getStatus(),
                packageUploadRequest.getId()));
             for (PackageUploadError error : errors.getErrors()) {
                System.out.println("Error detail: " + error.getMessage());
             }
          }
          assertTrue("Upload failure occurred", false);
          break;

       case Queued:
          if (!queued) {
             System.out.println(String.format("Package upload %s enqueued",
             packageUploadRequest.getId()));
             queued = true;
          }
          break;

       case InProgress:
          if (!inProgress) {
             System.out.println(String.format("Package upload %s started",
                packageUploadRequest.getId()));
             inProgress = true;
          }
          break;

       case Unknown:
          System.out.println("Unexpected package upload status: " +
             updatedPackageUploadRequest.getStatus());
    }

    if (done) break;

    try {
       Thread.sleep(1000);
    } catch (InterruptedException e) {
       // ignore interruptions
    }
}
```

> 주의: 위 코드의 `case` 라벨 Success/Error/Queued/InProgress/Unknown은 WSC의 enum 상수명을 시사하지만, 문서화된 picklist 값은 "Error / In Progress / Queued / Success"이다.

---

## 2GP 패키지 (Second-Generation Packaging, Dev Hub)

> Dev Hub org에서 2세대 관리형·언락드 패키지(Package2)와 버전(Package2Version), 생성 요청(Package2VersionCreateRequest)·그 에러(Package2VersionCreateRequestError), 구독자 org의 패키지 구성요소(Package2Member)를 다룬다. 개념·1GP 비교는 [[2GP Managed Package 개념과 1GP 비교]] 참조.

### Package2

Represents a second-generation managed package or an unlocked package in a Dev Hub org. Values for all fields are visible to the subscriber. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** create(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| AppAnalyticsEnabled | boolean | Defaulted on create, Filter, Group, Sort, Update | If true, AppExchange App Analytics can access package usage logs and subscriber snapshots. The default value is false. |
| ContainerOptions | picklist | Create, Filter, Group, Restricted picklist, Sort | Container options for the second-generation package. These options determine the upgrade and editability rules. The default value is Managed. Valid values include: Managed (developer-managed, subscriber-managed); Unlocked (developer-controlled, subscriber-editable). |
| ConvertedFromPackageId | reference | Create, Filter, Group, Nillable, Sort | The package ID (starts with 033) for the first-generation managed package that was converted. This field is available in API version 64.0 and later. This field is a relationship field. **Relationship Name:** ConvertedFromPackage. **Refers To:** SubscriberPackage. |
| DataCloudPackage | boolean | Create, Defaulted on create, Filter, Group, Sort | If true, this package contains Data 360 metadata. When creating a managed package with Data 360 metadata, you must isolate the Data 360 metadata from the other Salesforce metadata by creating a separate package that contains only Data 360 metadata. Then create a package dependency between your dedicated Data 360 package and any related packages. The default value is false. |
| Description | string | Create, Filter, Nillable, Sort, Update | Description of the package. |
| IsDeprecated | boolean | Defaulted on create, Filter, Group, Sort, Update | Specifies whether this package has been marked as deprecated (true) or not (false). The default value is false. If you set IsDeprecated to true for a package, the package and all of its child package versions are deprecated. If you set IsDeprecated to false for a package, the package and all of its child package versions are undeprecated. However, if IsDeprecated is explicitly set to true for a package version after its parent package is deprecated, the child remains deprecated even if you undeprecate its parent. If you set IsDeprecated to false for a package version whose parent package is deprecated, the package version's IsDeprecated value remains true until its parent is undeprecated. Deprecated package versions that have been installed in subscriber orgs continue to function, but new installations of deprecated package versions are blocked. |
| IsOrgDependent | boolean | Filter, Group, Sort | Indicates whether the package depends on unpackaged metadata in the installation org (true) or not (false). This field only applies to unlocked packages. The default value is false. Available in API version 49.0 and later. |
| Name | string | Create, Filter, Group, Nillable, Sort, Update | Name of the package. Unlike a typical developer name, this value is mutable and can contain special characters. |
| NamespacePrefix | string | Create, Filter, Group, Nillable, Sort | Namespace prefix that identifies the components of your package in the subscriber's org. |
| PackageErrorUsername | string | Create, Filter, Group, Nillable, Sort, Update | The email address for an active user in the Dev Hub org you want to receive email notification regarding package-related errors. You can set the field when creating a package and update it later. |
| SubscriberPackageID | reference | Filter, Group, Sort, Unique | ID that identifies this package across all Salesforce instances (starts with 033). This value is case-sensitive and must be unique. |
| WasTransferred | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the package was previously associated with a different Dev Hub org. For details, see: Transfer a Second-Generation Managed Package to a Different Dev Hub. This field is available in API version 57.0 and later. The default value is false. |

**ContainerOptions enum (verbatim):** Managed (developer-managed, subscriber-managed); Unlocked (developer-controlled, subscriber-editable). 기본값 = Managed.

> Package2에는 별도의 `PackageType` 필드가 **없다** (위 [!note] 참조) — 패키지 종류는 `ContainerOptions`로만 구분한다.

**Usage:** Subscribers install package versions (Package2Version) in their orgs.

### Package2Member

Represents a component in a second-generation managed package in a subscriber's org. Created when the subscriber installs the package. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| CurrentPackageVersionId | reference | Filter, Group, Sort | The ID of the current SubscriberPackageVersion. |
| MaxPackageVersionId | reference | Filter, Group, Nillable, Sort | Indicates the last package version that a metadata component was contained in. It's set if the object is left in the subscriber org after upgrade. For example, if the package developer removes an Apex class, that class and its Package2Member are hard deleted. However, to avoid data loss, we don't delete schema objects. |
| MinPackageVersionId | reference | Filter, Group, Nillable, Sort | The ID of the first SubscriberPackageVersion that contained this Package2Member. Starts with 04t. |
| SubjectId | reference | Filter, Group, Sort, Unique | The ID of the component that this Package2Member is referencing. This value is case-sensitive and must be unique. |
| SubjectKeyPrefix | string | Filter, Group, Sort | The key prefix for the component that this Package2Member is referencing—for example, 01W for an ActionEmail component or 01Q for a WorkflowRule component. |
| SubjectManageableState | picklist | Filter, Group, Restricted picklist, Sort | The manageability state of this Package2Member. References ManageableStateEnum. Valid values below. |

**SubjectManageableState enum (verbatim):**
- beta—Not applicable. (Used only for first-generation packages.)
- deleted—Not applicable. (Used only for first-generation packages.)
- deprecated—Installed as part of a second-generation managed package, and later deprecated from the package.
- deprecatedEditable—Installed as part of an unlocked package, and later deprecated from the package.
- installed—Installed as part of a second-generation managed package.
- installedEditable—Installed as part of an unlocked package. For components in unlocked packages, an admin can make modifications, but all changes are overwritten by the next upgrade.
- released—Not applicable. (Used only for first-generation packages.)
- unmanaged—Not applicable. (Used only for first-generation packages.)

### Package2Version

Represents a second-generation package version in a Dev Hub org. Values for all fields except for Tag and Branch are visible to the subscriber. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** query(), retrieve(), update()
- **Supported REST HTTP Methods:** Query, GET, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| AncestorId | reference | Filter, Group, Nillable, Sort | The ID of the immediate parent of the package version in the package ancestry tree. |
| Branch | string | Filter, Group, Nillable, Sort, Update | The branch associated with this package version. Can be used to create a tree structure of inheritance. This value is auto-populated from Package2VersionCreateRequest, but you can update it. |
| BuildDurationInSeconds | int | Filter, Group, Nillable, Sort | Measured in seconds, this field indicates how long the build for this package version took. This field is new in API version 51.0. |
| BuildNumber | int | Filter, Group, Sort | Part of the version number of a package version. The complete version number format is major.minor.patch (Beta build)—for example, 1.2.0 (Beta 5). For released packages, version numbers contain only major.minor.patch, or, if patch is 0, major.minor—for example, 1.2. |
| CodeCoverage | complexvalue | Nillable | Percentage of lines of Apex code in the package version that are covered by tests. The value is null if code coverage wasn't run when the package version was created. For second-generation managed packages, a minimum 75% code coverage is required for package version promotion. |
| CodeCoveragePercentages | complexvalue | Nillable | Provides code coverage details for each Apex class in the package version. The value is null if code coverage wasn't run when the package version was created, or if there's no Apex code in the package. |
| ConvertedFromVersionId | reference | Filter, Group, Nillable, Sort | The subscriber package version ID (starts with 04t) of the first-generation managed package version that was converted. This field is available in API version 64.0 and later. This field is a relationship field. **Relationship Name:** ConvertedFromVersion. **Refers To:** SubscriberPackageVersion. |
| Description | string | Filter, Nillable, Sort, Update | Description of the package. |
| DeveloperUsePkgZip | base64 | Nillable | The zip file of package metadata for the package version. For converted second-generation managed packages only. |
| HasMetadataRemoved | boolean | Defaulted on create, Filter, Group, Sort | For managed packages only, this field returns true when one or more managed metadata components included in the package version's ancestor aren't included in this package version. This field doesn't apply to unlocked packages. Available in API version 51.0. |
| HasPassedCodeCoverageCheck | boolean | Defaulted on create, Filter, Group, Sort | Returns true if code coverage tests were run when the package version was created, and the resulting code coverage percentage is 75% or greater. Otherwise, returns false. For second-generation managed packages, a minimum 75% code coverage is required for package version promotion. |
| InstallKey | string | Filter, Group, Nillable, Sort, Update | Installation key for creating the key-protected package. The default is null. If you query for this value, the returned value is always null (for security reasons). The value can be set and reset but not read. |
| IsDeprecated | boolean | Defaulted on create, Filter, Group, Sort, Update | Specifies whether this package version has been marked as deprecated (true) or not (false). The default value is false. (Same parent/child deprecation cascade prose as Package2.IsDeprecated.) |
| IsPasswordProtected | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether installation of this package version requires the user to provide an installation key (true) or not (false). The default value is false. |
| IsReleased | boolean | Defaulted on create, Filter, Group, Sort, Update | Indicates whether the package version is released (true) or in beta (false). |
| Language | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | The language for the package. If a language wasn't specified, the language defaults to the language of the Dev Hub user who created the package. This field is available in API version 57.0 and later. |
| MajorVersion | int | Filter, Group, Sort | Part of the version number of a package version. (major.minor.patch (Beta build) format prose.) |
| MinorVersion | int | Filter, Group, Sort | Part of the version number of a package version. (major.minor.patch (Beta build) format prose.) |
| Name | string | Filter, Group, Sort, Update | Name of the package. |
| Package2Id | reference | Filter, Group, Sort | ID of the parent package (starts with 0Ho). |
| PatchVersion | int | Filter, Group, Sort | Part of the version number of a package version. (major.minor.patch (Beta build) format prose.) Currently, the only valid value is 0. |
| ReleaseVersion | double | Filter, Group, Sort | Indicates the Salesforce release version used to create the package version. The value is in the format of a Salesforce API version number, for example, "51.0." This field is new in API version 51.0. |
| SnapshotName | *(no Type/Properties listed in source [sic])* | — | The name of the scratch org snapshot used when creating this package version. |
| SubscriberPackageVersionId | reference | Filter, Group, Sort, Unique | ID that subscribers use to install the package version (starts with 04t). This value is read-only. |
| Tag | string | Filter, Group, Nillable, Sort, Update | The package version's tag. This value is auto-populated from Package2VersionCreateRequest, but you can update it. |
| ValidatedAsync | boolean | Defaulted on create, Filter, Group, Sort | If true, a new package version is created before package validations complete. The default value is false. For more information on async validation, see Create and Update Versions of a Second-Generation Managed Package. |
| ValidationSkipped | boolean | Create, Defaulted on create, Filter, Group, Sort | If true, validation is skipped during package version creation. Skipping validation reduces the time it takes to create a new package version, but package versions created without validation can't be promoted to the released state. This field is available in API version 48.0 and later. The default value is false. You can't specify both skip validation and code coverage, because code coverage is calculated during validation. |

> SOURCE QUIRK [sic]: PDF의 `SnapshotName` 행은 **Description 하위 행만** 있고 Type/Properties 행이 없다. 위 표에 원문 그대로 옮겼다.
>
> 교정(위 [!note] 참조): Package2Version에는 `ReleaseState` 필드가 없으며 `AncestorId`는 `reference`, `ValidationSkipped`는 `boolean`이다 — ENUM이 아니다. 이 객체의 유일한 picklist는 `Language`다.

### Package2VersionCreateRequest

Represents a request to create a second-generation managed package or an unlocked package version in a Dev Hub org. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** create(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| AsyncValidation | boolean | Create, Defaulted on create, Filter, Group, Sort | If true, a new package version is created before package validations complete. The default value is false. For more information on async validation, see Create and Update Versions of a Second-Generation Managed Package. |
| Branch | string | Create, Filter, Group, Nillable, Sort, Update | The branch to associate with this package version. Can be used to create a tree structure of inheritance. Upon successful creation of a Package2Version, this value is copied to the package version's Branch field. The default value is null. |
| CalculateCodeCoverage | boolean | Create, Defaulted on create, Filter, Group, Sort | If true, code coverage is calculated during package version creation. If false, code coverage isn't calculated. For second-generation managed packages, a minimum 75% code coverage is required for package version promotion. This field is available in API version 47.0 and later. |
| CalcTransitiveDependencies | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, the calculation of the package version's indirect dependencies is enabled. A package can have multiple levels of dependencies, where pkgC depends on pkgB, and pkgB depends on pkgA, for example. By default, you list all of a package's dependencies, including indirect (transitive) dependencies. When CalcTransitiveDependencies is set to true, you specify a package's direct dependencies only, and the indirect dependencies are calculated for you. See Create Dependencies Between Second-Generation Managed Packages in the Second-Generation Managed Packaging Developer Guide. CalcTransitiveDependencies also enables you to generate a hierarchical graph of a package version's dependencies. To generate the dependencies graph, run the `package version displaydependencies` CLI command. See package version displaydependencies in the Salesforce CLI Command Reference. The default value is false. |
| DependencyGraphJson | textarea | Create, Nillable, Update | If CalcTransitiveDependencies is set to true, DependencyGraphJson is auto-populated with information about the package's dependencies when you create a new package version. If CalcTransitiveDependencies is false, the default value is null. |
| InstallKey | encryptedstring | Create, Nillable | Installation key for installing a key-protected package. The default is null. Used only on insert. If you query for this value, null is always returned (for security reasons). The default value is null. |
| IsConversionRequest | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, this package version is being converted from a first-generation managed package to a second-generation managed package. The default value is false. This field is available in API version 64.0 and later. |
| IsDevUsePkgZipRequested | boolean | Create, Filter, Group, Sort, Update | If true, a downloadable package zip file containing package metadata is generated when a new package version is created. The default value is false. |
| IsPasswordProtected | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether installation of this package version requires the user to provide an installation key (true) or not (false). The default value is null. |
| Language | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | The language for the package. The picklist values match the Fully Supported Languages listed in Salesforce Help. If no language is specified, the language defaults to the language of the Dev Hub user who created the package. This field is available in API version 57.0 and later. |
| Package2Id | reference | Create, Filter, Group, Sort | A reference to an ID for the Package2 to create a version of. The default value is null. |
| Package2VersionId | reference | Filter, Group, Nillable, Sort | A reference to an ID for the Package2Version that this request creates (starts with 05i). The default value is null. |
| SkipValidation | boolean | Create, Defaulted on create, Filter, Group, Sort | If true, validation is skipped during package version creation. Skipping validation reduces the time it takes to create a new package version, but package versions created without validation can't be promoted to the released state. This field is available in API version 48.0 and later. The default value is false. You can't specify both skip validation and code coverage, because code coverage is calculated during validation. |
| SourceOrg | string | Create, Filter, Group, Nillable, Sort | The ID of the org whose shape (features, settings, limits, and licenses) information is used for creating scratch orgs used to validate metadata during creation of a second-generation managed package or unlocked package. This field is available in API version 50.0 and later. |
| Status | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The status of the Package2Version creation request. Valid values below (listed in the order they appear during a create request). The default value is null. |
| Tag | string | Create, Filter, Group, Nillable, Sort, Update | Optional tags for the package version. The default value is null. |
| VersionInfo | base64 | Create | The blob that stores details about the package version. The default value is null. (Note: When you query Package2VersionCreateRequest, data from VersionInfo isn't returned.) |

**Status enum (verbatim, in display order):**
- Queued
- Initializing
- Verifying Features and Settings
- Verifying Dependencies
- Verifying Metadata
- Finalizing PackageVersion
- Error
- Success

### Package2VersionCreateRequestError

Represents an error encountered while creating a second-generation managed package or an unlocked package version. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| Message | textarea | Filter, Nillable, Sort | The error that was encountered during the creation of a package version. |
| ParentRequestId | reference | Filter, Group, Nillable, Sort | The ID of the Package2VersionCreateRequest that encountered an error. |

---

## 구독자/설치 뷰 (Subscriber-View / Install — 1GP·2GP 공통)

> 설치된 패키지·버전을 구독자 org 관점에서 보는 객체(SubscriberPackage·SubscriberPackageVersion·InstalledSubscriberPackage·InstalledSubscriberPackageVersion(폐기))와, 설치/제거 라이프사이클 액션(PackageInstallRequest·SubscriberPackageVersionUninstallRequest·PackageVersionUninstallRequestError). 설치/제거 절차 일반은 [[2GP — Install · Uninstall]] 참조.

### SubscriberPackage

Represents an installable package (first- or second-generation) across all Salesforce instances. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Nillable, Sort | Description of the package. |
| IsPackageValid | boolean | Defaulted on create, Group, Sort | Indicates whether the package metadata is available consistently across all Salesforce instances. If this value is false, the package is unavailable for installation. |
| Name | string | Group, idLookup, Sort | Name of the package. |
| NamespacePrefix | string | Group, idLookup, Nillable, Sort | Namespace prefix that identifies the components of your package in the subscriber's org. |

**Usage:** Represents a package that can be installed. To query this object, include an ID (begins with 033) in your SOQL WHERE clause.

### SubscriberPackageVersion

Represents a package version (first- or second-generation) across all Salesforce instances. Available in API version 41.0 and later.

> BIG 객체 — 11 페이지 / 28 필드 / 8 서브객체 복합 타입. AP-09 페이지 경계에서 누락 없이 전부 stitch됨.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, Query

> 소스 순서 quirk [sic]: `IsOrgDependent`가 알파벳 순서를 깨고 **맨 마지막**(SubscriberPackageId 뒤)에 나타난다. PDF 순서 그대로 전사한다.

| Field | Type | Properties | Description |
|---|---|---|---|
| AppExchangeDescription | string | Nillable, Sort | The AppExchange description for this package. If the AppExchange listing for the package doesn't contain a value for this field, the field's value is null. |
| AppExchangeLogoUrl | string | Nillable, Sort | The URL that AppExchange uses to display the logo for this package. If the AppExchange listing for the package doesn't contain a value for this field, the field's value is null. |
| AppExchangePackageName | string | Group, Nillable, Sort | The AppExchange name for this package. If the AppExchange listing for the package doesn't contain a value for this field, the field's value is null. |
| AppExchangePublisherName | string | Group, Nillable, Sort | The AppExchange publisher name for this package. If the AppExchange listing for the package doesn't contain a value for this field, the field's value is null. |
| BuildNumber | int | Group, Nillable, Sort | Part of the version number of a package version. The complete version number format is major.minor.patch.build—for example, in 1.2.0.5 the build number is 5. |
| CspTrustedSites | SubscriberPackageCspTrustedSites | Nillable | List of new Trusted URLs (CspTrustedSite) that the user must authorize before installing the package version. Package upgrades don't include previously installed Trusted URLs. |
| Dependencies | SubscriberPackageDependencies | Nillable | Other subscriber package versions that this subscriber package version depends on. Available in API version 44.0 and later. |
| Description | string | Nillable, Sort | Description of the package. |
| InstallationKey | RAW | Not applicable | Installation key for a key-protected package. This field is hidden. It's not queryable, but you can include it in the WHERE clause of SOQL queries. In some queries, it's required. To query unlocked packages that have installation keys, you must include the correct InstallationKey value in your WHERE clause. However, if the unlocked package version is already installed in your org you can query it without specifying an InstallationKey value. For managed packages, an InstallationKey value in the WHERE clause is optional. |
| InstallValidationStatus | picklist | Group, Nillable, Restricted picklist, Sort | Status of the validation tests that are run during the package version install. Valid values below. |
| IsBeta | boolean | Defaulted on create, Group, Sort | Indicates whether the package version is released (false). |
| IsDeprecated | boolean | Defaulted on create, Group, Sort | Specifies whether this package version has been marked as deprecated (true) or not (false). |
| IsManaged | boolean | Defaulted on create, Group, Sort | Specifies whether this package is managed (true) or not (false). |
| IsPasswordProtected | boolean | Defaulted on create, Group, Sort | Specifies whether installation of this package version requires the user to provide an installation key (true) or not (false). |
| IsSecurityReviewed | boolean | Defaulted on create, Group, Sort | Specifies whether the package has passed the security review required for publishing in AppExchange. |
| MajorVersion | int | Group, Nillable, Sort | Part of the version number of a package version. The complete version number format is major.minor.patch.build—for example, in 1.2.0.5 the major version is 1. |
| MinorVersion | int | Group, Nillable, Sort | Part of the version number of a package version. ...in 1.2.0.5 the minor version is 2. |
| Name | string | Group, idLookup, Sort | Name of the package. |
| Package2ContainerOptions | picklist | Group, Nillable, Restricted picklist, Sort | Container options for the second-generation package. These options determine the upgrade and editability rules. Valid values are: Managed, Unlocked. |
| PatchVersion | int | Group, Nillable, Sort | Part of the version number of a package version. ...in 1.2.0.5 the patch version is 0. |
| PostInstallUrl | string | Nillable, Sort | The fully qualified URL of the post-installation instructions. Instructions are shown as a link after installation and are available from the package detail view. |
| Profiles | SubscriberPackageProfiles | Nillable | List of profiles for which the package was installed. |
| PublisherName | string | Group, Nillable, Sort | The name of the publisher of this package. |
| ReleaseNotesUrl | string | Nillable, Sort | The fully qualified URL of the package release notes. Release notes are shown as a link during the installation process and are available from the package detail view after installation. |
| ReleaseState | picklist | Group, Nillable, Restricted picklist, Sort | If the package version is a beta version, the value is Beta. Otherwise, the value is Released. |
| RemoteSiteSettings | SubscriberPackageRemoteSiteSettings | Nillable | List of new Remote Site Settings that the user must authorize before installing the package. Package upgrades don't include previously installed Remote Site Settings. |
| SubscriberPackageId | ID | Group, Nillable, Sort | ID of the parent SubscriberPackage. The ID starts with the string 033. This value is case-sensitive and must be unique. |
| IsOrgDependent | boolean | Defaulted on create, Group, Sort | Indicates whether the package depends on unpackaged metadata in the installation org (true) or not (false). This field applies to unlocked packages only. The default value is false. Available in API version 49.0 and later. *([sic] 알파벳 순서를 깨고 맨 마지막에 위치)* |

**InstallValidationStatus enum (verbatim — FULL 17 values, 절단 없음):**
- NoErrorsDetected
- BetaInstallIntoProductionOrg
- CannotInstallEarlierVersion
- CannotUpgradeBeta
- CannotUpgradeUnmanaged
- DeprecatedInstallPackage
- ExtensionsOnLocalPackages
- PackageNotInstalled
- PackageHasInDevExtensions
- InstallIntoDevOrg
- NoAccess
- PackagingDisabled
- PackagingNoAccess
- PackageUnavailable
- UninstallInProgress
- UnknownError
- NamespaceCollision

**Package2ContainerOptions enum:** Managed, Unlocked
**ReleaseState enum:** Beta, Released

#### SubscriberPackageVersion — 서브객체 복합 타입 (verbatim, pp.891–892)

**SubscriberPackageCspTrustedSites** — Represents the list of new Trusted URLs that the user must authorize before installing the package version. Available in API version 41.0 and later. In API version 58. *([sic] — 원문에서 문장이 중간에 끊김)*

| Field | Type | Description |
|---|---|---|
| settings | SubscriberPackageCspTrustedSite | List of Trusted URLs (CspTrustedSite) that have been added to the package. These sites must be authorized before installation. If the AppExchange listing for the package doesn't contain a value for this field, the field's value is null. |

**SubscriberPackageCspTrustedSite** — Represents a new Trusted URLs (CspTrustedSite) that the user must authorize before installing the package version. Available in API version 41.0 and later.

| Field | Type | Description |
|---|---|---|
| endpointUrl | string | The URL associated with the CspTrustedSite. |

**SubscriberPackageDependencies** — Represents a list of subscriber package version IDs that a subscriber package version depends on. Available in API version 44.0 and later.

| Field | Type | Description |
|---|---|---|
| ids | SubscriberPackageDependency | List of SubscriberPackageDependency IDs: 04t IDs for the package versions that a subscriber package version depends on. |

**SubscriberPackageProfiles** — Represents a mapping between the profiles contained in the package and the profiles that are applied in the target subscriber org. Available in API version 41.0 and later.

| Field | Type | Description |
|---|---|---|
| destinationProfiles | SubscriberPackageDestinationProfile | The profiles that the administrator installing the package in a target subscriber org actually applies. |
| sourceProfiles | SubscriberPackageSourceProfile | The profiles that are contained in the package that is being installed. |

**SubscriberPackageDestinationProfile** — Represents the profile that an administrator applies when installing the package in a target subscriber org. Available in API version 41.0 and later.

| Field | Type | Description |
|---|---|---|
| description | string | The description of the profile. |
| displayName | string | The display name of this profile. |
| name | string | The name of the profile. |
| noAccess | boolean | Returns true if the profile is internal. |
| profileId | string | The ID of the profile. |
| type | string | The API name of the profile. |

**SubscriberPackageSourceProfile** — Represents a profile contained in the package to be installed. Available in API version 41.0 and later.

| Field | Type | Description |
|---|---|---|
| label | string | The profile label. |
| value | string | The name of the profile. |

**SubscriberPackageRemoteSiteSettings** — Represents a list of Remote Site Settings (RSS) that have been added to the package since the last version. Available in API version 41.0 and later.

| Field | Type | Description |
|---|---|---|
| settings | SubscriberPackageRemoteSiteSetting *([sic] — 원문은 layout merge로 "SubscriberPackageRemoteSiteSettingSubscriberPackageRemoteSiteSetting"로 렌더링됨; 올바른 타입은 `SubscriberPackageRemoteSiteSetting`)* | List of RSS added to the package since the last version. |

**SubscriberPackageRemoteSiteSetting** — Defines a URL to an external service. The administrator of the subscriber org must authorize access to these services. Available in API version 41.0 and later.

| Field | Type | Description |
|---|---|---|
| secure | boolean | Returns true if the URL uses the https protocol. Applies only if protocol security is enabled. |
| url | string | The URL of the remote service. |

#### SubscriberPackageVersion — Usage (verbatim SOQL examples)

Represents a version of an installable package. To query this object, include an ID (begins with 04t) in your SOQL WHERE clause.

For subscriber package versions with no installation keys, queries must include an ID value, but an InstallationKey value is not required:

```sql
SELECT Dependencies FROM SubscriberPackageVersion
   WHERE ID = '04txxxxxxxxxxxx'
```

For unlocked package versions that have installation keys, queries must include both an ID value and an InstallationKey value:

```sql
SELECT Dependencies FROM SubscriberPackageVersion
   WHERE ID = '04txxxxxxxxxxxx' AND InstallationKey='password123'
```

For managed first- and second-generation package versions that have installation keys and for unlocked package versions that are installed in your org, queries must include an ID value, but an InstallationKey value is optional:

```sql
SELECT Dependencies FROM SubscriberPackageVersion
   WHERE ID = '04txxxxxxxxxxxx'

SELECT Dependencies FROM SubscriberPackageVersion
   WHERE ID = '04txxxxxxxxxxxx' AND InstallationKey='password123'
```

### SubscriberPackageVersionUninstallRequest

Represents a request to uninstall a Package2Version (second-generation package version). Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** create(), describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Status | picklist | Group, Nillable, Restricted picklist, Sort | The status of the uninstall. Valid values are: Error, InProgress, Queued, Success. |
| SubscriberPackageVersionId | ID | Create, Filter, Group, Sort | The ID of the subscriber Package2 version to uninstall. The ID starts with the string 04t. |

**Status enum:** Error, InProgress, Queued, Success

### InstalledSubscriberPackage

Represents a package (first- or second-generation) that is installed in a subscriber's org. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| MinPackageVersionId | ID | Filter, Group, Nillable, Sort | Package version ID (foreign key) of the first version of the package that was installed in the org. Starts with 04t. |
| SubscriberPackageId | ID | Filter, Group, Nillable, Sort | ID of the subscriber package. Starts with 033. |
| SubscriberPackageVersionId | ID | Filter, Group, Nillable, Sort | ID that shows the currently installed package version. Starts with 04t. |

**Usage:** Query InstalledSubscriberPackage for details about the packages that are installed in your org. Sample SOQL query:

```sql
SELECT Id, SubscriberPackageId, SubscriberPackage.NamespacePrefix,
      SubscriberPackage.Name, SubscriberPackageVersion.Id,
      SubscriberPackageVersion.Name, SubscriberPackageVersion.MajorVersion,
      SubscriberPackageVersion.MinorVersion,
      SubscriberPackageVersion.PatchVersion,
      SubscriberPackageVersion.BuildNumber
   FROM InstalledSubscriberPackage
   ORDER BY SubscriberPackageId
```

### InstalledSubscriberPackageVersion

**Deprecated and slated for removal.** Represents a package version (first- or second-generation) that is installed in a subscriber's org. Available in API version 41.0 and later.

> [!warning] This object is not currently in use. It will be removed in a future release.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| MinPackageVersionId | reference | Filter, Group, Nillable, Sort | Package version ID (foreign key) of the first version of the package that was installed in the org. |
| SubscriberPackageId | reference | Filter, Group, Sort | ID of the subscriber package. |
| SubscriberPackageVersionId | reference | Filter, Group, Sort, Unique | ID of the subscriber package version. |

### PackageInstallRequest

Represents a request to install a package (first- or second-generation) in a target subscriber org. Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** create(), describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexCompileType | string | Create, Filter, Group, Nillable, Sort | For unlocked package installs and upgrades, specifies whether to require successful compilation of all Apex in the org, or only Apex within the package. Valid values are: all, package. For package installs into production orgs, or any org that has Apex Compile on Deploy enabled, the platform compiles all Apex in the org after the package install or upgrade operation completes. This approach assures that package installs and upgrades don't impact the performance of an org, and is done even if --apexcompile package is specified. Available in API version 46.0 and later. |
| EnableRss | boolean | Create, Defaulted on create, Filter, Group, Sort | Specifies whether the package can send and receive Remote Site Settings (RSS) and Content Security Policy (CSP) data from third-party websites (true) or not (false). The default value is false. Available in API version 43.0 and later. |
| Errors | SubscriberPackageInstallErrors | Nillable | Errors that occurred during installation, if any. |
| NameConflictResolution | picklist | Create, Filter, Group, Restricted picklist, Sort | Controls name conflicts between package members in an unmanaged package. Valid values are: Block (Throw an exception on name conflicts), RenameMetadata (Rename only those components that can be renamed, otherwise throw an exception). |
| PackageInstallSource | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | For internal use only. |
| Password | string | Create, Filter, Group, Nillable, Sort | The installation key for the package. Required for packages that are protected by an installation key. |
| ProfileMappings | SubscriberPackageProfileMappings | Create, Nillable | Mappings between profile settings in the package and profiles in the subscriber org. When installing a package, the admin for the subscriber org chooses which profiles in the org to map the profile settings in the package to. |
| SecurityType | picklist | Create, Filter, Group, Restricted picklist, Sort | Users for which this package is installed. Valid values are: Custom (Installed for specified custom profiles), Full (Installed for all users), None (Installed for administrators only). |
| SkipHandlers | string | Create, Filter, Group, Nillable, Sort | Specifies the handlers that are skipped when the package is installed. There's only one valid value: FeatureEnforcement (For package installs in scratch orgs only. Specifying FeatureEnforcement in this field decreases the length of time a package installation takes to complete. The feature enforcement handler adds object and feature validations in the subscriber org that prevent an admin from turning off a feature that can cause your app to malfunction. This enforcement isn't critical in scratch orgs.). Available in API version 61.0 and later. |
| Status | picklist | Group, Nillable, Restricted picklist, Sort | The status of the install request. Valid values are: Error, InProgress, Success, Unknown. |
| SubscriberPackageVersionKey | string | Create, Filter, Group, Sort | Foreign key to the subscriber package version. |
| UpgradeType | string | Create, Filter, Group, Nillable, Sort | For unlocked package upgrades, specifies whether to mark all removed components as deprecated (deprecate-only), delete removed components that can be safely deleted and deprecate the others (mixed-mode), or delete all removed components (delete-only). The default is mixed-mode. Valid values are: delete-only, deprecate-only, mixed-mode. |

**Enum reference:**
- **ApexCompileType:** all, package
- **NameConflictResolution:** Block, RenameMetadata
- **SecurityType:** Custom, Full, None
- **SkipHandlers:** FeatureEnforcement (유일한 값)
- **Status:** Error, InProgress, Success, Unknown
- **UpgradeType:** delete-only, deprecate-only, mixed-mode

#### PackageInstallRequest — 서브객체 복합 타입 (verbatim)

**SubscriberPackageInstallErrors** — Represents the list of errors that occurred during package installation.

| Field | Type | Description |
|---|---|---|
| errors | SubscriberPackageInstallError | The errors that occurred during package install. |

**SubscriberPackageInstallError** — Represents a single error that occurred during package installation.

| Field | Type | Description |
|---|---|---|
| message | string | Required. Describes the error that occurred. |

**SubscriberPackageProfileMappings** — Represents the list of profile mappings for which this package is installed.

| Field | Type | Description |
|---|---|---|
| profileMappings | SubscriberPackageProfileMapping | Name of the profile mapping. |

**SubscriberPackageProfileMapping** — Represents a mapping between a profile in the package that's being installed and the profile in the target subscriber org.

| Field | Type | Description |
|---|---|---|
| source | string | Required. The name of the profile setting in the package that's being installed. |
| target | string | Required. The name of the profile in the target subscriber org. |

> 참고: PackageInstallRequest 코드 샘플에서 출력되는 "PackagePushRequest created"는 PackageUploadRequest 샘플(위)과 같은 산문 잔재이며, `PackagePushRequest` 객체 자체는 Tooling Ch4 범위 밖이다 ([[2GP — Push Upgrade]] 참조).

### PackageVersionUninstallRequestError

Represents an error encountered while requesting an uninstall of a Package2Version (second-generation package version). Available in API version 41.0 and later.

- **Version:** API version 41.0 and later.
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Message | string | Filter, Nillable, Sort | The error that was encountered during the request of an uninstall of the second-generation package version. |
| ParentRequestId | ID | Filter, Group, Nillable, Sort | The ID of the SubscriberPackageVersionUninstallRequest object associated with this error. The ID starts with the string 06y. |

---

## 브랜딩 (Branding)

> Experience Builder의 Theme 패널에서 정의되는 브랜딩 세트(BrandingSet)와 그 속성(BrandingSetProperty), 그리고 탭 색상 메타데이터(ColorDefinition).

### BrandingSet

Represents a set of branding properties for an Experience Builder site, as defined in the Theme panel in Experience Builder. Available in API version 40.0 and later.

- **Version:** API version 40.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Nillable, Sort | A description of the branding set. |
| DeveloperName | string | Filter, Group, Sort | Unique name of the branding set. |
| FullName | string | Create, Group, Nillable | The full name of the branding set in Metadata API. The full name can include a namespace prefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the branding set. Possible values below. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The manageable state of the branding set that is contained in a package. Possible values below. |
| MasterLabel | string | Filter, Group, Sort | The user interface name of the branding set. |
| Metadata | BrandingSet | Create, Nillable, Update | The branding set's metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the `namespacePrefix__componentName` notation. (Standard NamespacePrefix prose: set to org's namespace prefix in DE orgs unless object is in an installed managed package; in non-DE orgs set only for installed managed-package objects.) |
| Type | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The type of branding set. Possible values below. |

**Language possible values (verbatim, 18):**
- da—Danish
- de—German
- en_US—English
- es—Spanish
- es_MX—Spanish (Mexico)
- fi—Finnish
- fr—French
- it—Italian
- ja—Japanese
- ko—Korean
- nl_NL—Dutch
- no—Norwegian
- pt_BR—Portuguese (Brazil)
- ru—Russian
- sv—Swedish
- th—Thai
- zh_CN—Chinese (Simplified)
- zh_TW—Chinese (Traditional)

**ManageableState possible values (verbatim, 8):**
- beta—Managed-Beta
- deleted—Managed-Proposed-Deleted
- deprecated—Managed-Proposed-Deprecated
- deprecatedEditable—SecondGen-Installed-Deprecated
- installed—Managed-Installed
- installedEditable—SecondGen-Installed-Editable
- released—Managed-Released
- unmanaged—Unmanaged

**Type possible values (verbatim, FULL list — 27):**
- b2b:branding-b2b
- b2c-lite-storefront:branding
- citizen:branding-citizen
- cpt:branding-cpt
- cypress:branding-cypress
- ember:branding-ember
- es-channel-menu
- helpCenter:branding-helpCenter
- identity:branding-identity
- insurance:branding-insurance
- jepson:branding-jepson
- koa:branding-koa
- kokua:branding-kokua
- login:branding-login
- login:branding-login2
- lpi:branding-lpi
- mfg:branding-mfg
- mortgage:branding-mortgage
- napili:branding-napili
- napili:branding-napili-merged
- prm:branding-prm-merged
- service:branding-service
- starter:branding-starter
- stella:branding-stella
- survey
- talon-template-byo:branding
- webster:branding-webster

**Usage:** To work with branding set properties, use BrandingSetProperty.

### BrandingSetProperty

Represents a branding set property in the Theme panel in Experience Builder. Available in API version 40.0 and later.

- **Version:** API version 40.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| BrandingSetId | reference | Create, Filter, Group, Sort | The ID of the BrandingSet. |
| PropertyName | string | Create, Filter, Group, Sort, Update | The name of the branding set property, such as TextColor. |
| PropertyValue | textarea | Create, Nillable, Update | The value of the branding set property, such as #333. |

### ColorDefinition

Represents color metadata for a tab. Available in API version 43.0 and later.

> **Note:** In API version 45.0 and later, only users with the "View Setup and Configuration" permission can access ColorDefinition.

- **Version:** API version 43.0 and later.
- **Supported SOAP Calls:** query()
- **Supported REST HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| Color | string | Filter, Group, Nillable, Sort | The color specified in web color RGB format—for example, 00FF00. |
| Context | string | Filter, Group, Nillable, Sort | The color context, which determines whether the color is the main color (or primary) for the tab. |
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| TabDefinitionId | string | Filter, Nillable, Sort | The ID of the tab this definition belongs to. Defaults to null. |
| Theme | string | Filter, Group, Nillable, Sort | The user interface theme this definition is associated with. |

---

## 정적 콘텐츠 (Static Content / Legacy UI Content)

> Visualforce 페이지에서 참조하는 정적 리소스(StaticResource)와 레거시 커스텀 s-control(Scontrol). s-control은 Visualforce에 의해 대체되었으나 객체는 계속 지원된다.

### StaticResource

Represents the working copy of a static resource file for editing or saving. Static resources allow you to upload content that you can reference in a Visualforce page, including images, stylesheets, JavaScript, and other files. Available in Tooling API version 29.0 and later.

- **Version:** Tooling API version 29.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

| Field | Type | Properties | Description |
|---|---|---|---|
| Body | string | Create, Update | The data for the static resource file. |
| ContentType | string | Create, Update | Required. The content type of the file, for example text/plain. |
| CacheControl | string | Create, Update | Required. Indicates whether the static resource is marked with a public caching tag so that a third-party delivery client can cache the content. The valid values are: Private, Public. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| Name | string | Create, Update | The static resource name. The name can only contain characters, letters, and the underscore (_) character, must start with a letter, and cannot end with an underscore or contain two consecutive underscore characters. |

**Usage:** To create, edit, or save a static resource file, create a StaticResource object that references it.

### Scontrol

Represents a custom s-control, which is custom content that our system hosts, but client applications execute. An s-control can contain any type of content that you can display or run in a Web browser.

> **Important:** Visualforce pages supersede s-controls. Organizations that haven't previously used s-controls can't create them. Existing s-controls are unaffected and can still be edited. We recommend that you move your s-controls to Visualforce. We continue to support this object.

- **Supported SOAP Calls:** query()
- **Supported REST Methods:** GET
- **Special Access Rules:**
  - Your organization must be using Enterprise, Developer, or Unlimited Edition and be enabled for custom s-controls.
  - Customer Portal users can't access this object.

| Field | Type | Properties | Description |
|---|---|---|---|
| ContentSource | picklist | Filter, Group, Nillable, Restricted picklist, Sort, Update | Specify the source of the s-control content, either custom HTML, a snippet (s-controls that are included in other s-controls), or a URL. |
| Description | string | Filter, Group, Nillable, Sort, Update | Description of the custom s-control. |
| DeveloperName | string | Filter, Group, Sort, Update | The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. Label is S-Control Name. (Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, Salesforce generates one for each record, which slows performance.) |
| EncodingKey | picklist | Filter, Group, Restricted picklist, Sort, Update | Picklist of character set encodings, including ISO-08859-1, UTF-8, EUC, JIS, Shift-JIS, Korean (ks_c_5601-1987), Simplified Chinese (GB2312), and Traditional Chinese (Big5). |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| Name | string | Filter, Group, Sort, Update | Required. Name of this custom s-control. Label is Label. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the `namespacePrefix__componentName` notation. (Standard NamespacePrefix prose.) |
| SupportsCaching | boolean | Defaulted on create, Filter, Group, Sort, Update | Indicates whether the s-control supports caching (true) or not (false). |

**Usage:** Use custom s-controls to manage custom content that extends application functionality. All users can view custom s-controls, but the "Customize Application" permission is required to create or update custom s-controls.

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브. REST/SOQL 쿼리 리소스·헤더·composite·EOL 등 호출 기초.
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체↔네임스페이스 분류, SOQL/SOSL 한도, System Fields, ApiFault.
- [[Tooling API — SOAP·REST 헤더]] — 호출 시 사용하는 SOAP/REST 헤더.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 형제 Ch4 도메인 노트(Apex 코드·테스트 sObject 군).
- [[Tooling API 객체 — Entity·Field·스키마]] — 형제 Ch4 도메인 노트. RecordType·FieldSet·CompactLayout 필드 컬럼, ValidationRule 관계 언급.
- [[Tooling API 객체 — 보안·권한]] — 형제 Ch4 도메인 노트. ProfileLayout·PermissionSetTabSetting의 정본.
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — 형제 Ch4 도메인 노트(자동화 sObject 군).
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — 형제 Ch4 도메인 노트. IconDefinition의 정본(여기서는 링크만).
- [[Tooling API 객체 — Lightning (Aura·LWC 번들)]] — Aura·LWC 컴포넌트 번들 sObject 5종 형제 Ch4 도메인 노트.
- [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] — 같은 운영 도메인의 Sandbox·배포·릴리즈·소스추적 sObject 18종 형제 노트.
- [[2GP Managed Package 개념과 1GP 비교]] — Package2*(2GP)·MetadataPackage*(1GP)의 개념·세대 비교. 패키징 도메인 허브.
- [[Tooling API 배포]] — MetadataContainer·ContainerAsyncRequest를 통한 Tooling API 배포(패키지 생성/업로드 라이프사이클과 인접).
- [[Scratch Org 패턴]] — Package2VersionCreateRequest의 SourceOrg·검증용 scratch org, Dev Hub 워크플로 맥락.
