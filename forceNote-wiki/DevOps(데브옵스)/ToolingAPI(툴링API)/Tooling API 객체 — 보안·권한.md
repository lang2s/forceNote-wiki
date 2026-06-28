---
tags: [tooling-api, devops, security, permissions, sharing, access]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [AuthorizedEmailDomain, Certificate, ConnectedApplication, CspTrustedSite, DelegateGroup, DelegateGroupGrant, DelegateGroupMember, ExternalAuthIdentityProvider, ExternalAuthIdentityProviderParameter, ExternalClientAppSettings, ExternalCredential, ExternalCredentialParameter, ExternalDataSource, ExternalDataSrcDescriptor, FieldRestrictionRule, Group, InboundNetworkConnection, InboundNetworkConnProperty, IPAddressRange, NamedCredential, NamedCredentialParameter, OutboundNetworkConnection, OutboundNetworkConnProperty, PermissionDependency, PermissionSet, PermissionSetAssignment, PermissionSetGroup, PermissionSetGroupComponent, PermissionSetTabSetting, Profile, ProfileLayout, RemoteProxy, RestrictionRule, SecurityHealthCheck, SecurityHealthCheckRisks, TransactionSecurityPolicy, UserAccessPolicy, UserAccessPolicyAction, UserAccessPolicyFilter, UserEntityAccess, UserFieldAccess, 보안, 권한, 권한집합, 프로파일, 네임드자격증명, 외부자격증명, 제한규칙, 사용자접근정책, 보안상태점검, IP범위, 위임관리, 트랜잭션보안정책]
---

# Tooling API 객체 — 보안·권한

> 접근 제어·외부 인증·네트워크 보안·권한 관리에 쓰는 Tooling API 보안 sObject 38종 전수 — 권한집합·프로파일·네임드/외부 자격증명·제한 규칙·사용자 접근 정책·보안 상태 점검까지 SOQL로 조회·구성한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **보안·권한 도메인 38객체**를 다룬다. 이 군은 access-control(권한집합·프로파일·위임 관리), external-auth(네임드/외부 자격증명·외부 데이터 소스·인증 ID 공급자), network-security(CSP 신뢰 사이트·인바운드/아웃바운드 네트워크 연결·IP 범위·원격 프록시), record/field-restriction(제한·범위 규칙), security-health(상태 점검·위험), user-access(사용자 접근 정책) Tooling sObject로, 대부분 `query()`로 SOQL 조회가 가능하며 상당수는 `create()`/`update()`/`delete()`로 구성도 가능하다.

> [!important] Tooling sObject ≠ Metadata API 동명 타입 (경계)
> `NamedCredential`·`ExternalCredential`·`ExternalDataSource`·`RemoteProxy`·`Profile`·`PermissionSet`·`CspTrustedSite`·`RestrictionRule`·`TransactionSecurityPolicy` 등은 **Tooling API의 (대부분 SOQL 가능한) sObject**다. Metadata API에는 같은 이름의 **declarative metadata 타입**이 따로 있고, 필드 구성·용법이 다르다(전자는 행 기반 조회/구성용, 후자는 파일 기반 배포용). 따라서 여기서는 link-only가 아니라 sObject 필드를 전수 재서술한다. Metadata API 타입 카탈로그는 [[Metadata Types — Objects & Fields]] 참조. 각 객체의 `Metadata` 필드(예: `mns:RestrictionRule`, `mns:TransactionSecurityPolicy`)는 해당 sObject 안에서 Metadata 네임스페이스(mns)의 복합 타입을 노출하는 통로다.

> [!warning] Tooling Ch4에 없는 보안 객체 (Metadata API 전용)
> 아래 객체들은 보안 객체로 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다.** Metadata API 전용이므로 "Tooling API로 다룰 수 있다"고 쓰면 안 된다. 이는 실제 coverage gap 신호이지 누락이 아니다.
> - FieldPermissions, ObjectPermissions, SetupEntityAccess, MutingPermissionSet, AuthProvider, SamlSsoConfig, CorsWhitelistOrigin, OauthToken, OauthCustomScope, SessionSettings, RemoteSiteSetting
> - 단, **RemoteSiteSetting → `RemoteProxy` 라는 이름으로 Tooling에 존재**하며, 이 노트의 [RemoteProxy](#remoteproxy) 섹션에서 다룬다.

> [!note] 도메인 경계 — 다른 그룹/노트 소관
> - **User** → C4-8(User/이벤트 군, 차기 사이클).
> - **UserCriteria** → Experience(차기). 단 `RestrictionRule`/`FieldRestrictionRule`의 `UserCriteria` *필드*는 여기서 다룬다(객체 UserCriteria와는 별개).
> - **CustomHttpHeader · DomainProvision · OrgDomainLog** → 운영 군(C4-7, 차기).
> - **PardotTenant** → 마케팅(이 위키 범위 제외).
> - **ConnectedApplication** 과 **ExternalClientAppSettings** 는 PDF 원문이 "For internal use only." 한 문장뿐인 thin stub다. 필드를 fabricate하지 않고 원문 그대로만 기록한다.

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [AuthorizedEmailDomain](#authorizedemaildomain) | 외부 인증·자격증명 | 7 | 64.0 |
| [Certificate](#certificate) | 외부 인증·자격증명 | 10 | 37.0 (Tooling) |
| [ConnectedApplication](#connectedapplication) | 외부 인증·자격증명 (internal) | 0 | — |
| [CspTrustedSite](#csptrustedsite) | 네트워크 보안 | 13 | 39.0 |
| [DelegateGroup](#delegategroup) | 위임 관리·그룹 | 3 | 57.0 (Tooling) |
| [DelegateGroupGrant](#delegategroupgrant) | 위임 관리·그룹 | 3 | 57.0 (Tooling) |
| [DelegateGroupMember](#delegategroupmember) | 위임 관리·그룹 | 2 | 57.0 (Tooling) |
| [ExternalAuthIdentityProvider](#externalauthidentityprovider) | 외부 인증·자격증명 | 10 (+서브) | (Tooling) |
| [ExternalClientAppSettings](#externalclientappsettings) | 외부 인증·자격증명 (internal) | 0 | — |
| [ExternalCredential](#externalcredential) | 외부 인증·자격증명 | 10 (+서브) | 56.0 |
| [ExternalDataSource](#externaldatasource) | 외부 인증·자격증명 | 22 | 51.0 |
| [ExternalDataSrcDescriptor](#externaldatasrcdescriptor) | 외부 인증·자격증명 | 11 | 55.0 / 56.0 |
| [FieldRestrictionRule](#fieldrestrictionrule) | 레코드/필드 제한 | 14 | 52.0 |
| [Group](#group) | 위임 관리·그룹 | 7 | 38.0 (Tooling) |
| [InboundNetworkConnection](#inboundnetworkconnection) | 네트워크 보안 | 11 | 49.0 |
| [InboundNetworkConnProperty](#inboundnetworkconnproperty) | 네트워크 보안 | 3 | 49.0 |
| [IPAddressRange](#ipaddressrange) | 네트워크 보안 | 10 | — |
| [NamedCredential](#namedcredential) | 외부 인증·자격증명 | 35 (+서브) | 51.0 |
| [OutboundNetworkConnection](#outboundnetworkconnection) | 네트워크 보안 | 11 | 49.0 |
| [OutboundNetworkConnProperty](#outboundnetworkconnproperty) | 네트워크 보안 | 3 | 49.0 |
| [PermissionDependency](#permissiondependency) | 권한 | 4 | 46.0 (Tooling) |
| [PermissionSet](#permissionset) | 권한 | 11 | 28.0 |
| [PermissionSetAssignment](#permissionsetassignment) | 권한 | 8 | 22.0 |
| [PermissionSetGroup](#permissionsetgroup) | 권한 | 8 | 45.0 (Tooling) |
| [PermissionSetGroupComponent](#permissionsetgroupcomponent) | 권한 | 4 | 45.0 (Tooling) |
| [PermissionSetTabSetting](#permissionsettabsetting) | 권한 | 3 | 37.0 (Tooling) |
| [Profile](#profile) | 권한 | 5 | 32.0 |
| [ProfileLayout](#profilelayout) | 권한 | 4 | 32.0 |
| [RemoteProxy](#remoteproxy) | 네트워크 보안 | 9 | 37.0 (Tooling) |
| [RestrictionRule](#restrictionrule) | 레코드/필드 제한 | 12 | 52.0 |
| [SecurityHealthCheck](#securityhealthcheck) | 보안 상태·정책 | 3 | 37.0 (Tooling) |
| [SecurityHealthCheckRisks](#securityhealthcheckrisks) | 보안 상태·정책 | 10 | 37.0 (Tooling) |
| [TransactionSecurityPolicy](#transactionsecuritypolicy) | 보안 상태·정책 | 17 | 35.0 (Tooling) |
| [UserAccessPolicy](#useraccesspolicy) | 사용자 접근 | 10 | 57.0 |
| [UserAccessPolicyAction](#useraccesspolicyaction) | 사용자 접근 | 2 | 57.0 |
| [UserAccessPolicyFilter](#useraccesspolicyfilter) | 사용자 접근 | 5 | 57.0 |
| [UserEntityAccess](#userentityaccess) | 사용자 접근 | 14 | 34.0 (Tooling) |
| [UserFieldAccess](#userfieldaccess) | 사용자 접근 | 8 | 34.0 (Tooling) |

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]` 인라인으로 보존한다. 일부 객체의 필드표는 PDF 원문이 3열(`Field / Field Type / Description`)이거나 Properties 행이 없어 그대로 3열로 옮긴다.

---

## 외부 인증 & 자격증명 (External Auth & Credentials)

> 외부 시스템 호출·SSO·파일 커넥트를 위한 자격증명/데이터 소스 sObject 군. 네임드 자격증명은 [[Named Credential]], CSP/원격 사이트 경계는 [[CSP와 RemoteSite]]도 함께 참조.

### AuthorizedEmailDomain

Represents an authorized domain for email verification. This object is available in API version 64.0 and later.

> Important (원문): Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** To create or modify authorized email domains, users must have the Email Administration permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | The unique name of the record in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated but you can supply your own value if you create the record using the API. Note these important considerations. • When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. • Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| DomainName | string | Create, Filter, Group, idLookup, Sort, Update | The unique domain name. **Example:** example.com |
| Id | ID | Create, Filter, Group, Sort | The ID of this authorized email domain. The ID starts with the string 1TB. **Example:** 1TB00000000000B |
| IsDomainOwnershipVerified | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether Salesforce successfully verified ownership of this domain (true) or not (false). The default value is false. |
| IsEmailRequired | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether email verification is required for new users with an email address on this domain (true) or not (false). The default value is false. When IsEmailRequired is false, IsDomainOwnershipVerified is true, and a new user's email address is on the DomainName, email verification isn't required for Salesforce to send emails from the user account. Changes to an existing user's email address require email verification before the user can send email via Salesforce from the new address. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specifies the language of the authorized email domain. The value for this field is the language value of the org. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Master label for this object. This display value is the internal label that is not translated. |

**Usage:** Domain verification is required to bypass email verification for an authorized email domain. To verify ownership of an authorized email domain, first create an AuthorizedEmailDomain with IsDomainOwnershipVerified set to false. Then determine the verification code for the authorized email domain. Use the format `orgId=AuthorizedEmailDomainId` where orgId is the 15-digit ID for your Salesforce org and AuthorizedEmailDomainId is the authorized email domain Id. You can also find the verification code on the Authorized Email Domains page in Setup. Add a DNS TXT record for the DomainName with or without `_sfdv.` as a prefix that points to a verification code.

### Certificate

Represents a certificate used for digital signatures that verify requests are coming from your org. Certificates are used for either authenticated single sign-on with an external website or when using your org as an identity provider. This object is available in Tooling API version 37.0 and later.

> Important (원문): Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** (명시 없음)

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, Salesforce generates one for each record, which slows performance. |
| ExpirationDate | date | Filter, Group, Nillable, Sort | Read only. The date that this certificate expires and is no longer usable. For self-signed certificates, if KeySize is 2048 bits, the expiration date is automatically 1 year after you create the certificate. If KeySize is 4096 bits, the expiration date is automatically 2 years after you create the certificate. For CA-signed certificates, ExpirationDate is automatically updated to the signed certificate's expiration date when a signed certificate chain is uploaded. The date format is YYYY-MM-DD. |
| KeySize | int | Filter, Group, Nillable, Sort | Certificate keys can be either 2048 bits or 4096 bits. A certificate with 4096-bit keys lasts 2 years, and a certificate with 2048-bit keys lasts 1 year. Certificates with 2048-bit keys are faster than certificates with 4096-bit keys. If KeySize isn't specified when you create a certificate, the key size defaults to 2048 bits. |
| MasterLabel | string | Filter, Group, Sort | Required. A user-friendly name for the certificate that appears in the Salesforce user interface, such as in Certificate and Key Management. Limit: 64 characters. |
| OptionsIsCaSigned | boolean | Filter | Required. Indicates whether this certificate is signed by the issuer (true) or not (false). |
| OptionsIsEncryptedWithPE [sic — truncated label, full likely OptionsIsEncryptedWithPlatformEncryption] | boolean | Filter | Indicates whether this certificate is encrypted with Shield Platform Encryption. |
| OptionsIsNewEncr [sic — truncated label] | boolean | Filter | Indicates whether this certificate is encrypted with the new algorithm for certificate encryption. |
| OptionsIsPrivateKeyExportable | boolean | Filter | Indicates whether this certificate's private key is exportable. |
| OptionsIsUnusable | boolean | Filter | Indicates whether this certificate is waiting for import of the signed certificate chain. |
| OptionIsUsingKMS | boolean | Filter | Indicates whether this certificate is compatible with select BYOK key material that uses the Shield Key Management Service (true) or not (false). This field is available in API version 50.0 and later. These certificates are only compatible with Database tenant secrets as part of the Shield Platform Encryption Database Encryption feature. |

> `OptionsIsEncryptedWithPE`, `OptionsIsNewEncr` 는 PDF 표 셀에서 라벨이 잘려 출력됐다(표 폭 제한으로 인한 줄바꿈). 위 `[sic]` 표기는 잘림을 명시한 것이며 정확한 전체 API명은 PDF 본문에서 더 확인되지 않는다.

### ConnectedApplication

For internal use only.

> (필드표·SOAP/REST 호출·Special Access Rules 모두 없음 — PDF 원문은 단 한 문장이다. 필드를 fabricate하지 않는다.)

### ExternalAuthIdentityProvider

Represents an external authentication (auth) identity provider. An external auth identity provider links to an external credential and obtains OAuth tokens for outbound callouts to external systems.

> 관련: Apex 측 외부 인증 호출은 [[Auth Namespace]], 콜아웃 자격증명은 [[Named Credential]] 참조.

> Important (원문): Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** Only users with the Customize Application permission or the Manage Named Credentials permission can access this object.

| Field | Type | Properties | Description |
|---|---|---|---|
| AuthenticationFlow | picklist | Filter, Group, Restricted picklist, Sort | Authentication flow to get tokens to call protected APIs. Possible values are: • AuthorizationCode • ClientCredentials • SalesforceDefined |
| AuthenticationProtocol | picklist | Filter, Group, Restricted picklist, Sort | The authentication protocol that's required to access the external system. Possible values are: • OAuth • SalesforceDefined |
| Description | string | Filter, Group, Nillable, Sort | A meaningful description of the external auth identity provider. |
| DeveloperName | string | Filter, Group, Sort | The unique internal name for the named credential used in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FullName | string | Create, Group, Nillable | The full name of the associated type in Tooling API. The full name can include a namespace prefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the external auth identity provider. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | Label for the external auth identity provider. In the UI, this field is Label. |
| Metadata | complexvalue | Create, Nillable, Update | Provides access to the associated metadata type and related fields in Tooling API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. |

#### Sub-object: ExternalAuthIdentityProviderParameter

Represents the parameters that configure an external auth identity provider.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | A human-readable description of the external auth identity provider parameter. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| ParameterName | string | Filter, Group, Sort | The name of the external auth identity provider parameter. |
| ParameterType | picklist | Filter, Group, Restricted picklist, Sort | The type of external auth identity provider parameter. The value of this field drives the behavior of the parameter. Possible values are: • AuthorizeRequestQueryParameter • AuthorizeUrl • ClientAuthentication • CreatedByNamespace • IdentityProviderOptions • ManagedByComponent • ManagedByFeature • RefreshRequestBodyParameter • RefreshRequestHttpHeader • RefreshRequestQueryParameter • StandardExternalIdentityProvider • TokenRequestBodyParameter • TokenRequestHttpHeader • TokenRequestQueryParameter • TokenUrl • UserInfoUrl |
| ParameterValue | textarea | Nillable | If the parameterType field describes a literal value then the literal value is stored in this field. |
| SequenceNumber | int | Filter, Group, Nillable, Sort | Specifies the order of parameters to apply when an external auth identity provider has more than one parameter. Priority is from lower to higher numbers (for example, 1 is the highest priority). |

### ExternalClientAppSettings

For internal use only.

> (필드표·호출 모두 없음 — PDF 원문은 단 한 문장이다.)

### ExternalCredential

Represents the details of how Salesforce authenticates to the external system. This object is available in API version 56.0 and later.

> 관련: 콜아웃 자격증명 패턴은 [[Named Credential]] 참조.

> Important (원문): Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.
> Note (원문): All credentials stored within this entity are encrypted under a framework that is consistent with other encryption frameworks on the platform. Salesforce encrypts your credentials by auto-creating org-specific keys. Credentials encrypted using the previous encryption scheme have been migrated to the new framework.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| AuthenticationProtocol | picklist | Filter, Group, Restricted picklist, Sort | Required. The authentication protocol that's required to access the external system. Valid values are: • AwsSv4 — AWS Signature Version 4 • Basic — Authentication using a static username and password • Custom — User-created authentication. Specify the permission set, sequence number, and authentication parameters. Each authentication parameter requires a name and value. • Jwt — Reserved for future use • JwtExchange— Reserved for future use • NoAuthentication — Reserved for future use • Oauth — Oauth 2.0 • Password — Reserved for future use. For connections to Amazon Web Services using Signature Version 4, use AwsSv4. For connections using a direct token system, use Jwt. If using an intermediary authorization provider to process JWTs and return access tokens, use JwtExchange. For Simple URL data sources, select NoAuthentication. For connections using a static username and password, use Basic. For cloud-based Files Connect external systems, select Oauth. For on-premises systems, select Password. |
| Description | string | Filter, Group, Nillable, Sort | A meaningful description of the external credential. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the external credential object. The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. Label is Record Type Name. This field is automatically generated, but you can supply your own value if you create the record using the API. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| ExternalCredentialParameters | ExternalCredentialParameter[] | Nillable | One or more sets of parameters that further configure the external credential. |
| FullName | string | Create, Group, Nillable | The full name of ExternalCredential in Metadata API. The full name can include a namespace prefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the external credential. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | The main label for the external credential. In the UI, this field is Label. |
| Metadata | ExternalCredential | Create, Nillable, Update | The external credential's metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. |

#### Sub-object: ExternalCredentialParameter

Represents the parameters that configure an external credential. External credential parameters are used to configure external credential callouts through a combination of the type, name, and value/lookup fields. Available in API version 56.0 and later. These parameters are used internally to provide a flexible architecture and are exposed here for packaging reasons.

> 이 sub-object 표는 PDF 원문이 `Field / Description` 포맷이며 Type은 Description 셀 안에 Type/Field Type 라벨로 들어가 있어, 아래에서는 3열(`Field / Type / Description`)로 옮긴다.

| Field | Type | Description |
|---|---|---|
| AuthProvider | string | Reference to an authentication provider that the AuthProvider component represents, which defines the service that provides the login process and approves access to the external system. |
| Certificate | string | If the value of the ParameterType field is SigningCertificate, then this field references the certificate. |
| Description | string | A human-readable description of this external credential parameter. |
| ExtlAuthIdentityProvider | string (Field Type) | Reference to an external authentication identity provider that the ExternalAuthIdentityProvider component represents. The ExternalAuthIdentityProvider defines the service that provides the login process and approves access to the external system. To simplify the configuration process for the authentication providers used by your named credentials, use an ExternalAuthIdentityProvider instead of an AuthProvider. Link the external auth identity provider to an external credential. |
| ParameterGroup | string | Groups a parameter along with its respective principal. For example, with dynamic scopes the user can apply a scope AuthParameter only when authenticated against a specific principal with a matching ParameterGroup value. If a value for ParameterGroup isn't provided, ParameterGroup defaults to the ParameterName value for PER_USER and NAMED_PRINCIPAL. For all other parameters ParameterGroup defaults to DEFAULT_GROUP. |
| ParameterName | string | Required. The name of the external credential parameter. |
| ParameterType | ExternalCredentialParamType (enumeration of type string) | Required. The type of external credential parameter. The value of this field drives the behavior of the parameter. Valid values are: (전체 enum 아래 별도 블록 참조) |
| ParameterValue | string | If the ParameterType field describes a literal value then the literal value is stored in this field. |
| Principal | string | If the value of the ParameterType field is either NamedPrincipal or PerUserPrincipal, this field points to a permission set. That value then determines the set of users that are allowed to use credentials provided by the credential provider. The value of the ParameterName field specifies the name of this principal. First available in API version 56.0, this field is removed in API version 58.0 and later. |
| SequenceNumber | int | Specifies the order of principals to apply when a user participates in more than one principal. For example, a user could be part of multiple permission sets that are applicable for a credential provider. Priority is from lower to higher numbers. You can set this field only when ParameterType is NamedPrincipal. |

**ParameterType (ExternalCredentialParamType) 전체 enum 값 (원문 verbatim):**
- **AdditionalRefreshStatusCode**: Allows the user to specify 4xx, 6xx, 7xx, 8xx, and 9xx HTTP status codes that trigger Salesforce to refresh expired or invalid access tokens, in addition to the standard 401 HTTP status code response.
- **AuthHeader**: Allows the user to specify custom authentication headers to be added to the callout at run time. When using AuthHeader, the ParameterName field must be the header name as a string, and ParameterValue must be a formula of a header value that is evaluated at run time. SequenceNumber determines the order in which headers are sent out in the callout. Headers with lower numbers are sent out first.
- **AuthParameter**: Allows the user to add additional authentication settings. ParameterName defines the parameter to set. For example, AwsRegion sets the AWS Region parameter to apply for an AWS Signature V4 authentication protocol and ParameterValue is the value for the AWS Region.
- **AuthProtocolVariant**: Used to specify a variant of an authentication protocol. For example, Aws Sts as a variant when the ParameterName is AwsSv4 and the ParameterValue is AwsSv4_STS.
- **AuthProvider**: Specifies that this parameter configures an authentication provider referenced by the AuthProvider field.
- **AuthProviderUrl**: Specifies the authentication endpoint URL. For example, if the authentication type is OAuth with JWT Bearer Flow, then ParameterValue is an authentication token endpoint.
- **AuthProviderUrlQueryParameter**: Allows the user to specify custom query parameters to be added to the callout to the authentication provider at run time. Currently, supported only for AWS Signature V4 with STS. The allowed AuthProviderUrlQueryParameter values are AwsExternalId and AwsDuration, used with AWS STS.
- **AwsStsPrincipal**: Configures AWS Signature V4 along with STS. ParameterName is AwsStsPrincipal and ParameterValue isn't specified.
- **CreatedByNamespace**: Reserved for internal use.
- **CustomPrincipal**: Reserved for internal use.
- **ExternalAuthIdentityProvider**: Specifies that this parameter configures an authentication provider referenced by the ExtlAuthIdentityProvider field.
- **GlobalNamedPrincipal**: Reserved for internal use.
- **JwtBodyClaim**: Specifies a JWT (JSON Web Token) body claim, where ParameterName is the key and ParameterValue is the value. For example, the parameter name for a JWT audience is aud.
- **JwtHeaderClaim**: Specifies a JWT header claim, where ParameterName is the key and ParameterValue is the value. For example, the parameter name for a JWT key identifier is kid.
- **ManagedByComponent**: Reserved for internal use.
- **ManagedByFeature**: Reserved for internal use.
- **NamedPrincipal**: Specifies that the parameter uses the same set of user credentials for all users who access the external system.
- **PerUserPrincipal**: Provides access control at the individual user level.
- **PrincipalIdentityAlias**: Reserved for internal use.
- **SfHttpRequestExtensionName**: Reserved for internal use.
- **SigningCertificate**: Specifies the certificate used for an authentication signature. Use the Certificate field to specify the certificate name. Used for OAuth with JWT Bearer Flow and AwsSv4 STS with RolesAnywhere authentication.
- **SystemUserPrincipal**: Reserved for internal use.

**SEE ALSO (ExternalCredential):**
- Salesforce Help: Named Credentials
- Named Credentials Developer Guide: Get Started with Named Credentials
- Named Credentials Developer Guide: Named Credential API Links
- Apex Developer Guide: Invoking Callouts Using Apex
- Apex Developer Guide: Named Credentials as Callout Endpoints

### ExternalDataSource

Represents the metadata associated with an external data source. Create external data sources to manage connection details for integration with data and content that are stored outside your Salesforce org. This object is available in API version 51.0 and later.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| CertificateId | reference | Filter, Group, Nillable, Sort | If you specify a certificate, your Salesforce org supplies it when establishing each two-way SSL connection with the external system. The certificate is used for digital signatures, which verify that requests are coming from your Salesforce org. Note: For best performance, verify that your remote HTTPS encrypted sites have OCSP (Online Certificate Status Protocol) stapling turned on. |
| CustomConfiguration | textarea | Nillable | A string of configuration parameters that are specific to the external data source's type. • Custom Configuration for the Salesforce Connect Cross-Org Adapter • Custom Configuration for the Salesforce Connect OData 2.0 or 4.0 Adapter • Custom Configuration for the Salesforce Connect Custom Adapter |
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the external data source used in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record by using the API. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. |
| Endpoint | textarea | Nillable | The URL of the external system, or if that URL is defined in a named credential, the named credential URL. Corresponds to URL in the user interface. A named credential URL contains the scheme callout:, the name of the named credential, and an optional path. For example: callout:My_Named_Credential/some_path. You can append a query string to a named credential URL. Use a question mark (?) as the separator between the named credential URL and the query string. For example: callout:My_Named_Credential/some_path?format=json. |
| FullName | string | Create, Group, Nillable | The full name of the associated type in Tooling API. The full name can include a namespace prefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsWritable | boolean | Defaulted on create, Filter, Group, Sort | Lets the Lightning Platform and users in this org create, update, and delete records for external objects associated with the external data source. The external object data is stored outside the org. By default, external objects are read only. Corresponds to Writable External Objects in the user interface. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the external data source. The value for this field is the language value of the org. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package. Possible values are: • beta—Managed-Beta • deleted—Managed-Proposed-Deleted • deprecated—Managed-Proposed-Deprecated • deprecatedEditable—SecondGen-Installed-Deprecated • installed—Managed-Installed • installedEditable—SecondGen-Installed-Editable • released—Managed-Released • unmanaged—Unmanaged |
| MasterLabel | string | Filter, Group, Sort | A user-friendly name for the external data source. The label is displayed in the Salesforce user interface, such as in list views. Examples include Acme Team Marketing Site, or Acme SharePoint. |
| Metadata | ExternalDataSource | Create, Nillable, Update | Provides access to the associated type and related fields in Tooling API. |
| NamedCredentialId | reference | Filter, Group, Nillable, Sort | The Salesforce ID of the referenced named credential for an external data source. Required for Salesforce Connect adapters for Amazon DynamoDB, Amazon Athena, GraphQL, and OData 4.01. For connecting to other external data sources, the field must be null. This is a relationship field. **Relationship Name:** NamedCredential. **Relationship Type:** Lookup. **Refers To:** NamedCredential |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the external data source. An external data source can be in an extension namespace different than the object. |
| OauthRefreshToken | textarea | Nillable | The OAuth refresh token. Used to obtain a new access token for an end user when a token expires. |
| OauthScope | string | Filter, Nillable, Sort | Specifies the scope of permissions to request for the access token. |
| OauthToken | textarea | Nillable | The access token issued by the external system. |
| Password | textarea | Nillable | The password to be used by your org to access the external system. Ensure that the credentials you use have adequate privileges to access the external system, perform searches, return data, and return information about the external system's metadata. |
| PrincipalType | picklist | Filter, Group, Restricted picklist, Sort | Determines whether you're using one set or multiple sets of credentials to access the external system. Possible values are: • Anonymous • PerUser • NamedUser |
| Protocol | picklist | Filter, Group, Restricted picklist, Sort | The authentication protocol that's required to access the external system. Possible values are: • AwsSv4 • Basic • Custom • Jwt • JwtExchange • NoAuthentication • Oauth • Password |
| Repository | string | Filter, Group, Nillable, Sort | Used for SharePoint Online. If metadata isn't accessible, use this field to create tables and default table fields. |
| Type | picklist | Filter, Group, Restricted picklist, Sort | (전체 enum 아래 별도 블록 참조) |
| Username | string | Filter, Group, Nillable, Sort | The username to be used by your org to access the external system. Ensure that the credentials you use have adequate privileges to access the external system, perform searches, return data, and return information about the external system's metadata. |
| Version | string | Filter, Group, Nillable, Sort | Reserved for future use. |

**Type (ExternalDataSource picklist) 전체 enum 값 (원문 verbatim):**

For Salesforce Connect, specifies the adapter that connects to the external system. The valid values are:
- AmazonAthena—Amazon Athena
- AmazonDynamoDB—Amazon DynamoDB
- GraphQl—GraphQL
- OData—OData 2.0 adapter
- OData4—OData 4.0 adapter
- OData401—OData 4.01 adapter
- SfdcOrg—cross-org adapter
- ApexClassId—DataSource.Provider class that defines the custom adapter created via the Apex Connector Framework

For Files Connect, specifies the data source type. The valid values are:
- ContentHubSharepoint—SharePoint 2010 or 2013
- ContentHubSharepointOffice365—SharePoint Online
- ContentHubSharepointOneDrive—OneDrive for Business
- ContentHubGDrive—Google Drive
- ContenHubIsotope—Isotope [sic — "ContenHub" 원문 오타]

If Chatter is enabled, you can also specify SimpleURL to access data hosted on a web server that doesn't require authentication.
- outgoingemail—A data source used for sending an email through a quick action.

For Digital Lending Configurator, the valid value is:
- AFPPAttribute—The data source name for the Application Form Product Proposal Attribute virtual object.

For the federated search external data source type, the valid value is:
- OpenSearch

For Transaction Management in Revenue Cloud, the valid values are:
- ASPAttribute—The data source name for the Asset State Period Attribute virtual object. Available in API version 63.0 and later.
- OIAttribute—The data source name for the Order Item Attribute virtual object. Available in API version 63.0 and later.
- QLIAttribute—The data source name for the Quote Line Item Attribute virtual object. Available in API version 63.0 and later.

For SalesAgreement in Manufacturing Cloud, the valid values are:
- SAPAttribute—The data source name for the SalesAgreement Product Attribute virtual object. Available in API version 60.0 and later.

These values are reserved for internal use:
- AssetAttribute
- ClaimAttributeDS
- ClaimItemAttributeDS
- CryptoTrEnvChgLogSnp
- CtrtGrpPlnAttr
- CtrtGrpPlnGrpClsAttr
- FAAttribute
- FLAttribute
- IAItemProdtAttr
- Identity
- InsPolicyAttribute
- IPAAttribute
- IPCAttribute
- IPCvrBnftAttribute
- IPPAttribute
- SdbOvenPODataSource
- Wrapper

**코드 예제 (ExternalDataSource Custom Configuration — 원문 그대로):**

Custom Configuration for the Salesforce Connect Cross-Org Adapter — applies when type is `SfdcOrg`:
```json
{"apiVersion":"32.0","environment":"CUSTOM", "searchEnabled":"true","timeout":"120"}
```
The parameters correspond to these fields in the user interface:
- apiVersion—API Version
- environment—Connect to
- searchEnabled—Enable Search
- timeout—Connection Timeout

Custom Configuration for the Salesforce Connect OData 2.0 or 4.0 Adapter — applies when type is `OData` or `OData4`:
```json
{"inlineCountEnabled":"true","csrfTokenName":"X-CSRF-Token",
"requestCompression":"false","pagination":"CLIENT",
"noIdMapping":"false","format":"ATOM",
"searchFunc":"","compatibility":"DEFAULT",
"csrfTokenEnabled":"true","timeout":"120",
"searchEnabled":"true"}
```
The parameters correspond to these fields in the user interface:
- compatibility—Special Compatibility
- csrfTokenEnabled—CSRF Protection
- csrfTokenName—Anti-CSRF Token Name
- format—Format
- inlineCountEnabled—Request Row Counts
- noIdMapping—High Data Volume
- pagination—Server Driven Pagination
- requestCompression—Compress Requests
- searchEnabled—Enable Search
- searchFunc—Custom Query Option for Salesforce Search
- timeout—Connection Timeout

Custom Configuration for the Salesforce Connect Custom Adapter — applies when type is set to the ID of a DataSource.Provider class:
```json
{"noIdMapping":"false"}
```
The noIdMapping parameter corresponds to the High Data Volume field in the user interface.

### ExternalDataSrcDescriptor

Contains the metadata information for the external schema of an external data source. Use the metadata to map attributes from an AWS data source, such as Amazon DynamoDB and Amazon Athena, to Salesforce external object fields. Also, use the metadata to customize the data retrieval queries to an AWS data source. This object is available in API version 55.0 and later for Amazon DynamoDB and in API version 56.0 and later for Amazon Athena.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomObjectId | reference | Filter, Group, Nillable, Sort | If set, the ID of the external object associated with the descriptor. This is a relationship field. **Relationship Name:** CustomObject. **Relationship Type:** Lookup. **Refers To:** CustomObject |
| Descriptor | base64 | Nillable | The descriptor document that contains the metadata information. |
| DescriptorVersion | string | Filter, Group, Nillable, Sort | If the external system supports schema versioning for the data source, the optional descriptor document version tracks the external system's schema version. Several descriptors with different document versions may be active. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the child-level setup entity. |
| ExternalDataSourceId | reference | Filter, Group, Sort | Salesforce ID of the external data source that defines the external system. This is a relationship field. **Relationship Name:** ExternalDataSource. **Relationship Type:** Lookup. **Refers To:** ExternalDataSource |
| FullName | string | Create, Group, Nillable | The full name of the associated type in Tooling API. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the descriptor document. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The manageable state of the descriptor that is contained in a package. Possible values are: • beta—Managed-Beta • deleted—Managed-Proposed-Deleted • deprecated—Managed-Proposed-Deprecated • deprecatedEditable—SecondGen-Installed-Deprecated • installed—Managed-Installed • installedEditable—SecondGen-Installed-Editable • released—Managed-Released • unmanaged—Unmanaged |
| Metadata | complexvalue | Create, Nillable, Update | The external data source descriptor's metadata. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. |
| Subtype | picklist | Filter, Group, Restricted picklist, Sort | The subtype of the descriptor. Possible values are: • SchemaTableDDL—Used to store the metadata for the external data source. • SchemaTableMetadata—Used to cache information about the external system. |

### NamedCredential

Represents a named credential, which specifies the URL of a callout endpoint and its required authentication parameters in one definition. A named credential can be specified as an endpoint to simplify the setup of authenticated callouts. This object is available in API version 51.0 and later.

> 패턴·설계는 [[Named Credential]] 참조.

> Important (원문): Where possible, we changed noninclusive terms to align with our company value of equality. We maintained certain terms to avoid any effect on customer implementations.
> Note (원문): All credentials stored within this entity are encrypted under a framework that is consistent with other encryption frameworks on the platform. Salesforce encrypts your credentials by auto-creating org-specific keys. Credentials encrypted for using the previous encryption scheme have been migrated to the new framework.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

> 일부 필드는 PDF에서 `Field Type` 라벨을 직접 쓰고 Properties 행이 없다. 그런 필드의 Properties 칸은 `—(Field Type만)`으로 표기한다.

| Field | Type | Properties | Description |
|---|---|---|---|
| AllowMergeFieldsinBody | boolean | —(Field Type만) | Specifies whether Apex code can use merge fields to populate the HTTP request body with org data when a callout is made. Corresponds to Allow Merge Fields in HTTP Body in the user interface. Defaults to false. |
| AllowMergeFieldsinHeader | boolean | —(Field Type만) | Specifies whether Apex code can use merge fields to populate the HTTP header with org data when a callout is made. Corresponds to Allow Merge Fields in HTTP Header in the user interface. Defaults to false. |
| AuthProviderId | string | Nillable | The authentication provider that the AuthProviderId component represents. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| AuthTokenEndpointUrl | textarea | Nillable | The URL where JSON Web Tokens (JWTs) are exchanged for access tokens. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| AwsAccessKey | string | Filter, Group, Nillable, Sort | First part of the access key used to sign programmatic requests to Amazon Web Services (AWS). Use when AWS Signature Version 4 is your authentication protocol. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| AwsAccessSecret | textarea | Nillable | The second part of the access key that's used to sign programmatic requests to AWS. Use when AWS Signature Version 4 is your authentication protocol. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| AwsRegion | string | Filter, Group, Nillable, Sort | Specifies which AWS Region the named credential accesses. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| AwsService | string | Filter, Group, Nillable, Sort | Specifies which AWS resource the named credential accesses. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| CalloutStatus | CalloutStatus (enumeration of type string) | —(Field Type만) | Specifies whether the named credential is enabled for callouts. Valid values are: • Disabled: The named credential is disabled for callouts. • Enabled: The named credential is enabled for callouts. This field is available in API version 59.0 and later. |
| CertificateId | reference | Filter, Group, Nillable, Sort | If you specify a certificate, your Salesforce org supplies it when establishing each two-way SSL connection with the external system. The certificate is used for digital signatures, which verify that requests are coming from your Salesforce org. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. **Relationship Name:** Certificate. **Relationship Type:** Lookup. **Refers To:** Certificate |
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the named credential used in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Endpoint | textarea | Nillable | The URL or root URL of the callout endpoint. Corresponds to URL in the user interface. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| FullName | string | Create, Group, Nillable | The full name of the associated type in Tooling API. The full name can include a namespace prefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| GenerateAuthorizationHeader | boolean | —(Field Type만) | Specifies whether Salesforce generates an authorization header and applies it to each callout that references the named credential. Corresponds to Generate Authorization Header in the user interface. Defaults to true. This field is available in API version 41.0 and later. |
| JwtAudience | textarea | Nillable | External service or other allowed recipients for the JWT. Written as JSON, with a quoted string for a single audience and an array of quoted strings for multiple audiences. Single audience example: "aud1". Multiple audiences example: ["aud1", "aud2", "aud3"]. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| JwtFormulaSubject | string | Filter, Group, Nillable, Sort | Formula string calculating the Subject of the JWT. API names and constant strings, in single quotes, can be included. Allows a dynamic Subject unique per user requesting the token. For example, 'User='+$User.Id. Use this field when principalType is set to PerUser. Corresponds to Per User Subject. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| JwtIssuer | string | Filter, Group, Nillable, Sort | Specify who issued the JWT using a case-sensitive string. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| JwtSigningCertificateId | reference | Filter, Group, Nillable, Sort | Certificate verifying the JWT's authenticity to external sites. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. **Relationship Name:** JwtSigningCertificate. **Relationship Type:** Lookup. **Refers To:** Certificate |
| JwtTextSubject | string | Filter, Group, Nillable, Sort | Static text, without quotes, that specifies the JWT Subject. Use this field when principalType is set to NamedUser. Corresponds to Named Principal Subject in the user interface. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| JwtValidityPeriodSeconds | int | Filter, Group, Nillable, Sort | Specify the number of seconds that the token is valid. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Label for the MasterLabel. In the UI, this field is Label. [sic — Language 필드인데 설명이 Label 관련; 원문 그대로] |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package. Possible values are: • beta—Managed-Beta • deleted—Managed-Proposed-Deleted • deprecated—Managed-Proposed-Deprecated • deprecatedEditable—SecondGen-Installed-Deprecated • installed—Managed-Installed • installedEditable—SecondGen-Installed-Editable • released—Managed-Released • unmanaged—Unmanaged |
| MasterLabel | string | Filter, Group, Sort | Important: Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations. The main label for the named credential. This display value is the internal label that doesn't get translated. |
| Metadata | NamedCredential | Create, Nillable, Update | Provides access to the associated metadata type and related fields in Tooling API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamedCredentialParameters | NamedCredentialParameter[] | Nillable | Reference to the (one or more) NamedCredentialParameter used to configure a named credential. This field is available in API version 56.0 and later. |
| NamedCredentialType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Specifies the type or behavior of this named credential. Valid values are: • Legacy: The named credential is a legacy type, which means that it doesn't use the schema introduced in the Winter '23 release. Used for backward compatibility. • PrivateEndpoint: The named credential sends traffic through a private connection, bypassing the public internet. If the credential type is PrivateEndpoint, you must specify the value of OutboundNetworkConnection. • SecuredEndpoint: The named credential is extensible and uses external credentials to control authentication and permissions. • Standard: Reserved for internal use. This field is available in API version 56.0 and later. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. |
| OauthRefreshToken | textarea | Nillable | The OAuth refresh token. Used to obtain a new access token for an end user when a token expires. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| OauthScope | string | Filter, Nillable, Sort | Specifies the scope of permissions to request for the access token. Corresponds to Scope in the user interface. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| OauthToken | textarea | Nillable | The access token that's issued by your authorization server. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| OutboundNetworkConnectionId | reference | Filter, Group, Nillable, Sort | Specifies the outbound network connection that uses the named credential to send callouts to AWS. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. **Relationship Name:** OutboundNetworkConnection. **Relationship Type:** Lookup. **Refers To:** OutboundNetworkConnection |
| Password | textarea | Nillable | The password to be used by your org to access the external system. Ensure that the credentials have adequate privileges to access the external system. Depending on how you set up access, you might need to provide the administrator password. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| PrincipalType | picklist | Filter, Group, Restricted picklist, Sort | Determines whether you're using one set or multiple sets of credentials to access the external system. Corresponds to Identity Type in the user interface. Valid values are: • Anonymous • NamedUser • PerUser. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| Protocol | picklist | Filter, Group, Restricted picklist, Sort | The authentication protocol that's required to access the external system. Valid values are: • AwsSv4 • Jwt • JwtExchange • NoAuthentication • Oauth • Password. For connections to Amazon Web Services using Signature Version 4, use AwsSv4. For connections using a direct token system, select Jwt. If using an intermediary authorization provider to process JWTs and return access tokens, use JwtExchange. For Simple URL data sources, select NoAuthentication. For cloud-based Files Connect external systems, select Oauth. For on-premises systems, select Password. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |
| Username | string | Filter, Group, Nillable, Sort | The username to be used by your org to access the external system. Ensure that the credentials have adequate privileges for performing callouts to the external system. Depending on how you set up access, you might need to provide the administrator username. This field is valid only when NamedCredentialType is set to Legacy. This field is deprecated in API version 56.0. |

#### Sub-object: NamedCredentialParameter

Represents the parameters that configure a named credential. Named credential parameters are used to configure Named Credential callouts through a combination of the type, name, and value/lookup fields. These parameters are used internally to provide a flexible architecture and are exposed here for packaging reasons.

| Field | Type | Properties | Description / Relationship |
|---|---|---|---|
| Certificate | string | Nillable | If the value of the ParameterType field is ClientCertificate then this field references the certificate. **Relationship Name:** Certificate. **Relationship Type:** Lookup. **Refers To:** Certificate |
| Description | string | Nillable | A human-readable description of this named credential parameter. |
| ExternalCredential | string | Nillable | If the value of the ParameterType field is Authentication, then this field references an external credential that in turn references a set of authenticated user credentials. |
| OutboundNetworkConnection | string | Nillable | The lookup field for the OutboundNetworkConnection parameter type. Used when namedCredentialType is PrivateEndpoint. |
| ParameterSettingsGlobalNamedPrincipalCredential | boolean (Field Type) | —(Field Type만) | Reserved for internal use. |
| ParameterSettingsManagedFeatureEnabledCallout | boolean (Field Type) | —(Field Type만) | Reserved for internal use. |
| ParameterSettingsReadOnlyNamedCredential | boolean (Field Type) | —(Field Type만) | Reserved for internal use. |
| ParameterSettingsSystemUserNamedCredential | boolean (Field Type) | —(Field Type만) | Reserved for internal use. |
| ParameterName | string | Nillable | Required. The name of the named credential parameter. |
| ParameterType | NamedCredentialParamType (enumeration of type string) | Nillable | Required. The type of the named credential parameter. (전체 enum 아래 별도 블록 참조) |
| ParameterValue | string | Nillable | If the ParameterType field describes a literal value, such as Url, then the literal value is stored in this field, such as https://iam.amazonaws.com/. |
| SequenceNumber | int | Nillable | Used to order HttpHeader parameters. |

**ParameterType (NamedCredentialParamType) 전체 enum 값 (원문 verbatim):** Valid values are:
- **AllowedManagedPackageNamespaces**: Allows managed packages identified by specified namespaces to use the named credential and make callouts through it.
- **Authentication**: Specifies that this parameter configures authentication using the credentials specified in the external credential, referenced by the ExternalCredential field.
- **ClientCertificate**: Specifies that this parameter configures a client certificate, referenced by the Certificate field.
- **ConnectionStatus**: Reserved for internal use.
- **CreatedByNamespace**: Reserved for internal use.
- **CustomParameter**: Reserved for internal use.
- **HttpHeader**: Allows the user to specify custom headers to be added to the callout at run time. When using HttpHeader, the ParameterName field must be the header name as a string, and ParameterValue must be a formula of a header value that is evaluated at run time.
- **ManagedByComponent**: Reserved for internal use.
- **ManagedByFeature**: Reserved for internal use.
- **ManagedByNamespace**: Specifies the manageability capabilities for a packaged named credential. The ParameterValue field indicates whether the named credential uses subscriber-controlled or developer-controlled manageability.
- **NamedCredentialOptions**: Reserved for internal use.
- **OutboundNetworkConnection**: Specifies a lookup to an outbound network connection. When using this parameter type, the OutboundNetworkConnection field is a string representing the lookup. Used when namedCredentialType is PrivateEndpoint.
- **SfHttpRequestExtensionName**: Reserved for internal use.
- **StandardNamedCredentialType**: Reserved for internal use.
- **Url**: Specifies that this parameter configures the URL of the endpoint. Store the actual URL in the ParameterValue field.

**SEE ALSO (NamedCredential):**
- Salesforce Help: Named Credentials
- Named Credentials Developer Guide: Get Started with Named Credentials
- Named Credentials Developer Guide: Named Credential API Links
- Apex Developer Guide: Invoking Callouts Using Apex
- Apex Developer Guide: Named Credentials as Callout Endpoints

---

## 네트워크 보안 (Network Security)

> CSP 신뢰 사이트·프라이빗 네트워크 연결·IP 범위·원격 사이트 프록시. CSP/원격 사이트 경계는 [[CSP와 RemoteSite]] 참조.

### CspTrustedSite

Represents a trusted URL. For each CspTrustedSite, you can specify Content Security Policy (CSP) directives and permissions policy directives. Each CSP directive allows Lightning components, third-party APIs, and WebSocket connections to access a resource type from the trusted URL. If the Permissions-Policy HTTP header is enabled, each permissions policy directive grants the trusted URL access to a browser feature. In API version 58.0 and earlier, CspTrustedSite included only CSP directives and was referred to as CSP Trusted Sites in Salesforce Setup. Available in API version 39.0 and later.

> CSP/원격 사이트 설계 맥락은 [[CSP와 RemoteSite]] 참조.

- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations on page 38 / SOSL Limitations on page 40

> 이 객체의 필드표는 PDF 원문이 `Field / Field Type / Description` 3열 포맷이며 Properties 행이 없다. 아래도 3열로 옮긴다.

| Field | Field Type | Description |
|---|---|---|
| CanAccessCamera | boolean | Indicates whether this CspTrustedSite can access the user's camera (true) or not (false). The default value is false. This field takes effect only when the enablePermissionsPolicy field equals true and the grantCameraAccess field equals TrustedUrls in the SecuritySettings metadata API type. This field is available in API version 59.0 and later. |
| CanAccessMicrophone | boolean | Indicates whether this CspTrustedSite can access the user's microphone (true) or not (false). The default value is false. This field takes effect only when the enablePermissionsPolicy field equals true and the grantMicrophoneAccess field equals TrustedUrls in the SecuritySettings metadata API type. This field is available in API version 59.0 and later. |
| Context | CspTrustedSiteContext (enumeration of type string) | Declares the scope of the CSP directives for the trusted URL. • All—Apply the CSP directives to all supported context types. • Communities—Apply the CSP directives to Experience Builder sites only. • FieldServiceMobileExtension—Apply the CSP directives to the Field Service Mobile Extensions only. Available in API version 47.0 and later. • LEX—Apply the CSP directives to Lightning Experience only. • LightningOut—Reserved for future use. Available in API version 64.0 and later • VisualForce—Apply the CSP directives to custom Visualforce pages only. Available in API version 55.0 and later. For custom Visualforce pages, content is restricted to trusted URLs only if the page's cspHeader attribute is set to true. This field is available in API version 44.0 and later. |
| Description | string | The description of this trusted URL. |
| EndpointUrl | string | Required. The URL for this CspTrustedSite. This field must include a domain name and can include a port. For example, https://example.com or https://example.com:8080. To reduce repetition, you can use the wildcard character * (asterisk). For example, *.example.com. For a third-party API, the URL must begin with https://. For example, https://example.com. For a WebSocket connection, the URL must begin with wss://. For example, wss://example.com. Before February 2025, it was possible to save a malformed URL. Malformed URLs are excluded from generated CSP HTTP headers. To keep your Trusted URLs list accurate, remove any malformed entries. You can use an Apex class to find all malformed URLs. See the knowledge article, Identify Malformed Trusted URLs. |
| IsActive | boolean | Indicates whether this CspTrustedSite is active (true) or not (false). The default value is true. |
| IsApplicableToConnectSrc | boolean | Indicates whether Lightning components, third-party APIs, and WebSocket connections can load URLs using script interfaces from this trusted URL (true) or not (false). This field has a default value of false. This field is available in API version 48.0 and later. |
| IsApplicableToFontSrc | boolean | Indicates whether Lightning components, third-party APIs, and WebSocket connections can load fonts from this trusted URL (true) or not (false). This field is available in API version 48.0 and later. |
| IsApplicableToFrameSrc | boolean | Indicates whether Lightning components, third-party APIs, and WebSocket connections can load resources contained in <iframe> elements from this trusted URL (true) or not (false). This field has a default value of false. This field is available in API version 48.0 and later. |
| IsApplicableToImgSrc | boolean | Indicates whether Lightning components, third-party APIs, and WebSocket connections can load images from this trusted URL (true) or not (false). This field has a default value of false. This field is available in API version 48.0 and later. |
| IsApplicableToMediaSrc | boolean | Indicates whether Lightning components, third-party APIs, and WebSocket connections can load audio and video from this trusted URL (true) or not (false). This field has a default value of false. This field is available in API version 48.0 and later. |
| IsApplicableToStyleSrc | boolean | Indicates whether Lightning components, third-party APIs, and WebSocket connections can load style sheets from this trusted URL (true) or not (false). This field has a default value of false. This field is available in API version 48.0 and later. |
| MobileExtension | string | Reserved for future use. |

**Usage:** For each CSPTrustedSite, at least one field starting with grantAccess or isApplicableTo must be set to true. In API versions 50.0 to 58.0, if all isApplicable fields are false, the isApplicableToImgSrc field is set to true. In API version 49.0 and earlier, if all isApplicable fields are false, those fields all default to true. To ensure smooth integration across Salesforce products, Salesforce includes URLs in each of the CSP directives that correspond to the isApplicable fields, even though those URLs aren't defined as CspTrustedSite components. Salesforce regularly updates those URLs based on the latest requirements.

### InboundNetworkConnection

Represents the a private connection between a third-party data service and a Salesforce org. The connection is inbound because the callouts are coming into Salesforce.. Available in API version 49.0 and later. [sic — "the a private" 원문 / 마침표 2개 ".."]

- **Supported SOAP Calls:** create(), delete(), describeObject(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETEGETPATCHPOST [sic — 원문에 구분자 없이 붙어있음; 즉 DELETE, GET, PATCH, POST]

| Field | Type | Properties | Description |
|---|---|---|---|
| ConnectionType | picklist | Filter, Group, Restricted picklist, Sort | Required. Specifies the Cloud provider of the connection. The only valid value is AwsPrivateLink. |
| Description | string | Filter, Group, Nillable, Sort | Required. A description of the connection. Maximum of 255 characters. |
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the inbound network connection used in the API. |
| FullName | string | Create, Group, Nillable | The full name of the associated type in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| isActive | boolean | Defaulted on create, Filter, Group, Sort | Required. Specifies whether the connection is active (true) or not(false). The default value is false [sic — 마침표 없음] |
| Language | string | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the connection. The value for this field is the language value of the org. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | The internal label for the connection. |
| Metadata | mns:InboundNetworkConnection | Create, Nillable, Update | Provides access to the associated type and related fields in Metadata API. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the connection. An inbound network connection can be in an extension namespace different than the object. |
| Status | picklist | Filter, Group, Restricted Picklist, Sort | Required. Connection status. The connection is initially Unprovisioned and moves through the other states automatically after an admin performs a provision, sync, or teardown action. The valid values are: • Unprovisioned • Allocating • PendingAcceptance • PendingActivation • RejectedRemotely • DeletedRemotely • TeardownInProgress • Ready |

### InboundNetworkConnProperty

Represents a name-value pair that describes the properties of the inbound network connection. Available in API version 49.0 and later.

- **Supported SOAP Calls:** create(), delete(), describeObject(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, QUERY

| Field | Type | Properties | Description |
|---|---|---|---|
| InboundNetworkConnectionId | reference | Create, Filter, Group, Sort | Required. The ID of the corresponding InboundNetworkConnection (on page 544). |
| PropertyName | picklist | Create, Filter, Group, Restricted picklist, Sort | The name of a property used to establish an InboundNetworkConnection. Valid values are: • AwsVpcEndpointId—The unique endpoint ID for connections to an AWS Virtual Private Cloud (VPC). • Region—The region in which the VPC is hosted. • SourceIpRanges—The ranges of source IP address allocated to this inbound connection by the Salesforce-managed VPC in your cloud provider. |
| PropertyValue | textarea | Create, Nillable, Update | The value of the PropertyName. An example of the PropertyValue of Region is us-west-2. The PropertyValue of SourceIpRanges is a JSON string that lists the start and end IP address for each range. (예제 아래) |

**PropertyValue SourceIpRanges JSON 예제 (원문 그대로 — 두 IP range 예시):**
```json
[
    {
      "startIp":"10.10.10.0",
      "endIp":"10.10.10.3"
    },
    {
      "startIp":"100.100.100.0",
      "endIp":"100.100.100.15"
    }
]
```

### IPAddressRange

Represents a range of IP addresses to include in or exclude from the specified feature.

- **Supported SOAP API Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | Not required. The description of the IP address range. For example, the name of the company that owns the IP address range. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the IP address range. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EndAddress | string | Filter, Group, Sort | The end of the IP address range. |
| FullName | string | Create, Group, Nillable | The unique name used as the event delivery identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. |
| IpAddressFeature | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | The feature that uses the range of IP addresses. Possible values are: • EmailIpFiltering (default) —Filter email engagement activities such as email opens and email clicks. |
| IpAddressUsageScope | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | Whether the specified IP addresses are included or excluded. Possible values are: • Exclusion • Inclusion |
| isProtected | boolean (Field Type) | (Properties 행 없음 — PDF 표기 "Field Type/Description"만) | Whether the specified IP address range is protected. The default is false. |
| MasterLabel | string | Filter, Group, Sort | Master label for the IP address range. This internal label doesn't get translated. |
| Metadata | complexvalue | Create, Nillable, Update | The IP address range metadata. |
| StartAddress | string | Filter, Group, Sort | The start of the IP address range. |

**Usage:** Specify a range of IP addresses, which feature the range applies to, and whether the IP addresses are excluded from or included in the feature.

> Example (원문): Exclude your coworkers' email opens and clicks from your email engagement reports. Use StartAddress and EndAddress to define the range of IP addresses that your company owns. Set IpAddressFeature to EmailIpFiltering, and set IpAddressUsageScope to Exclusion.

### OutboundNetworkConnection

Represents a private connection between a Salesforce org and a third-party data service. The connection is outbound because the callouts are going out of Salesforce.Available in API version 49.0 and later. [sic — "Salesforce.Available" 공백 누락]

- **Supported SOAP Calls:** create(), delete(), describeObject(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETEGETPATCHPOST [sic — 구분자 없이 붙어있음; DELETE, GET, PATCH, POST]

| Field | Type | Properties | Description |
|---|---|---|---|
| ConnectionType | picklist | Filter, Group, Restricted picklist, Sort | Specifies the cloud provider of the connection. The only valid value is AwsPrivateLink. |
| Description | string | Filter, Group, Nillable, Sort | A description of the connection. Maximum of 255 characters. |
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the outbound network connection used in the API. |
| FullName | string | Create, Group, Nillable | The full name of the associated type in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| isActive | boolean | Defaulted on create, Filter, Group, Sort | Required. Specifies whether the connection is active (true) or not(false). The default value is false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the connection. The value for this field is the language value of the org. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | The internal label for the connection. |
| Metadata | mns:OutboundNetworkConnection | Create, Nillable, Update | Provides access to the associated type and related fields in Metadata API. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the connection. An outbound network connection can be in an extension namespace different than the object. |
| Status | picklist | Filter, Group, Restricted Picklist, Sort | Required. Connection status. The connection is initially Unprovisioned and moves through the other states automatically after an admin performs a provision, sync, or teardown action. The valid values are: • Unprovisioned • Allocating • PendingAcceptance • PendingActivation • RejectedRemotely • DeletedRemotely • TeardownInProgress • Ready |

### OutboundNetworkConnProperty

Represents a name-value pair that describes the properties of the outbound network connection. Available in API version 49.0 and later.

- **Supported SOAP Calls:** create(), delete(), describeObject(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETEGETPATCHPOST [sic — 구분자 없이; DELETE, GET, PATCH, POST]

| Field | Type | Properties | Description |
|---|---|---|---|
| OutboundNetworkConnectionId | reference | Create, Filter, Group, Sort | Required. The ID of the corresponding OutboundNetworkConnection. |
| PropertyName | picklist | Create, Filter, Group, Restricted picklist, Sort | The name of a property used to establish to an OutboundNetworkConnection. Valid values are: • AwsVpcEndpointId—The unique endpoint ID provided by Salesforce after an outbound AwsPrivateLink is created. • AwsVpcEndpointServiceName—The name of the customer's endpoint service running in an AWS VPC that's used for private connections with Salesforce. • Region—The region in which the VPC is hosted. Enumerated values DataCloudPrivateNetwork* are reserved for internal use. |
| PropertyValue | textarea | Create, Nillable, Update | The value of PropertyName For example, the PropertyValue of Region might be us-west-2. |

### RemoteProxy

Represents a set of remote site settings that allows you to access an external site from Salesforce. Use RemoteProxy when accessing external sites called by Visualforce pages, Apex callouts, or JavaScript codes using XmlHttpRequest in an s-control or custom button. To be accessible, an external site must have its settings defined with RemoteProxy or registered in the Remote Site Settings page. Available in Tooling API version 37.0 and later.

> 이 객체는 Metadata API의 RemoteSiteSetting에 대응하는 Tooling sObject다. 원격/CSP 사이트 설계는 [[CSP와 RemoteSite]] 참조.

- **Supported SOAP Calls:** create(), query(), retrieve() update()  [원문 그대로 — retrieve()와 update() 사이 콤마 없음]
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** (원문에 별도 Special Access Rules 섹션 없음)

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | The description explaining what this remote site setting is used for. |
| EndpointUrl | string | Filter, Group, Sort | Required. The URL of the remote site. |
| FullName | string | Create, Group, Nillable | The unique name used as the remote site identifier for API access. The name can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Required. Indicates whether the remote site setting is active (true) or not (false). |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| Metadata | complexvalue | Create, Nillable, Update | Metadata that defines the remote site setting. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix of up to 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is set only for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |
| ProtocolMismatch | boolean | Defaulted on create, Filter, Group, Sort | Required. Indicates whether code within Salesforce can access the remote site regardless of whether the user's connection is over HTTP or HTTPS (true) or not (false). When true, code within Salesforce can pass data between HTTPS and HTTP sessions. Warning: Only set to true if you understand the security implications. Note: This field corresponds to the disableProtocolSecurity field in the Metadata API type. |
| SiteName | string | Filter, Group, Sort | Required. The name of the remote site. |

---

## 위임 관리 & 그룹 (Delegated Admin & Groups)

### DelegateGroup

Represents a Delegate Group for queries. This object is available in Tooling API version 57.0 and later.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | The unique developer name for the delegate group. |
| IsLoginAccessEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates login access is enabled for the developer group. The default value is false. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The label for the developer group. |

### DelegateGroupGrant

Represents a Delegate Group Grant, indicating permissions granted to a delegate group. This object is available in Tooling API version 57.0 and later.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description / Relationship |
|---|---|---|---|
| DelegateGroupId | reference | Create, Filter, Group, Sort, Update | The id for the associated delegate group. |
| GrantedId | reference | Create, Filter, Group, Nillable, Sort | The id for the associated object granted to the delegate group. This field is a polymorphic relationship field. **Relationship Name:** null. **Relationship Type:** Lookup. **Refers To:** CustomObject, Group, PermissionSet, PermissionSetGroup, Profile, User, UserRole |
| KeyPrefix | string | Create, Defaulted on create, Filter, Group, Nillable, Sort | The prefix of the object id that designates the object type. |

### DelegateGroupMember

Represents users assigned to the delegate group This object is available in Tooling API version 57.0 and later. [sic — "delegate group This" 원문 마침표 누락]

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description / Relationship |
|---|---|---|---|
| DelegateGroupId | reference | Create, Filter, Group, Sort, Update | The id of the associated delegate group. |
| UserOrGroupId | reference | Create, Filter, Group, Nillable, Sort | The reference indicating the user id of the delegated administrator for the delegate group. Note: User is the only valid value for this field. Group is reserved for future development. This field is a polymorphic relationship field. **Relationship Name:** null. **Relationship Type:** Lookup. **Refers To:** Group, User |

### Group

Represents a set of User records. Groups can contain individual users, other groups, or the users in a particular role or territory. In addition, groups can contain all users below a particular role or territory in the hierarchy. Available in Tooling API version 38.0 and later.

- **Supported SOAP Calls:** describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), search()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** As of Spring '20 and later, only authenticated internal and external users with the View Setup and Configuration permission can access this object.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Nillable, Sort | The description of the group. This field is available in API version 62.0 and later. |
| DeveloperName | string | Filter, Group, Nillable, Sort | The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. Corresponds to Group Name in the user interface. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. Only your Salesforce org's internal users can access this field. |
| DoesIncludeBosses | boolean | Filter, Group, Sort | Indicates whether records shared with users in this group are also shared with users higher in the role hierarchy (true) or not (false). This field is only available for groups of type Regular and Queue. This field corresponds to the Grant Access Using Hierarchies checkbox on the detail pages of public groups and queues. For groups of type Regular, this field available in API version 18.0 and later and has a default value of true. For groups of type Queue, this field is available in API version 67.0 and later. The default value of this field for queues depends on the value of the org-level setting "Grant access using hierarchies by default in new queues." |
| Name | string | Filter, Group, idLookup, Sort | The name of the group. This value corresponds to the value of the Label field in the user interface. |
| OwnerId | reference | Filter, Group, Sort | The ID of the user who owns the group. |
| RelatedId | reference | Filter, Group, Nillable, Sort | Represents the ID of the associated records. For example, for Groups of type "Role," this field is the ID of the associated UserRole. The RelatedId field is polymorphic. |
| Type | picklist | Filter, Group, Restricted picklist, Sort | (전체 enum 아래 별도 블록 참조) |

**Type (Group picklist) 전체 enum 값 (원문 verbatim):** Type of the group. One of the following values:
- AllCustomerPortal—All your Customer Portal or Customer Community Plus users. This type is only available when a Customer Portal or a Customer Site is enabled for your org.
- CollaborationGroup—Chatter group.
- Manager—Public group that includes a user's direct and indirect managers. This Group is read-only.
- ManagerAndSubordinatesInternal—Public group that includes a user and the user's direct and indirect reports. This group is read-only.
- Organization—Public group that includes all the User records in the organization. This group is read-only.
- PRMOrganization—Public group that includes all the partners in an organization that has the partner site or portal feature enabled.
- Queue—Public group that includes all the User records that are members of a queue.
- Regular—Standard public group. When you create a group through the create() call, its type must be Regular, unless a site or partner portal is enabled for the org. If so, the type can be Regular or PRMOrganization.
- Role—Public group that includes all the User records in a particular UserRole.
- RoleAndSubordinates—Public group that includes all the User records in a particular UserRole and all the User records in any subordinate UserRole. Only available when digital experiences is enabled for your org and Experience Cloud site users are created with external account roles other than a shared person account role.
- RoleAndSubordinatesInternal—Public group that includes all the User records in an internal UserRole, excluding customer and partner roles, and all the User records in any subordinate internal UserRole.
- SharingRuleGroup—Group associated with a criteria-based sharing rule.
- Territory—Public group that includes all the User records in a particular Territory.
- TerritoryAndSubordinates—Public group that includes all the User records in a particular Territory and all the User records in any subordinate Territory.

Only Regular can be used when creating a group. The other values are reserved for system-managed groups.

---

## 권한 (Permissions)

> 권한집합·프로파일 설계 패턴은 [[Permission Set 설계]] 참조.

### PermissionDependency

Represents permission dependencies for a specified permission. For example, return all child dependencies for the Modify All Data permission. Available in Tooling API version 46.0 and later.

- **Version:** Tooling API 46.0+
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** Query, GET
- **Special Access Rules:** As of Summer '20 and later, only users with View Setup and Configuration permission can access this object.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Permission | string | Filter | The permission that depends on other permissions to be enabled. For example, the permission might be Modify All Data, which requires View All Data and other permissions to be enabled. |
| PermissionType | string | Filter | The permission type. For example, user permissions, such as View All Data, or object permissions. |
| RequiredPermission | string | Filter | The permission that is required to be enabled for the dependent permission to be enabled. |
| RequiredPermissionType | string | Filter | The permission type. For example, user permissions, such as View All Data, or object permissions. |

**Usage:** Use the PermissionDependency object to find the permissions on which a specified permission is dependent.

### PermissionSet

Represents a set of permissions that's used to grant more access to users without changing their profile or reassigning profiles. Available in API version 28.0 and later.

- **Version:** API 28.0+
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve(), search()
- **Supported REST HTTP Methods:** (원문에 별도 REST methods 섹션 없음 — SOAP Calls만 명시됨)
- **Special Access Rules:**
  As of Summer '20 and later, only users who have one of these permissions can access this object:
  - View Setup and Configuration
  - Manage Session Permission Set Activations
  - Assign Permission Sets
  - Manage Profiles and Permission Sets

  To view the following settings, assignments, and permissions for standard and custom objects in a specified permission set, the View Setup and Configuration permission is required.
  - Client settings
  - Field permissions
  - Layout assignments
  - Object permissions
  - Permission dependencies
  - Permission set tab settings
  - Permission set group components
  - Record types

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Nillable, Group, Sort | A description of the permission set. Limit: 255 characters. |
| HasActivationRequired | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the permission set requires an associated active session (true) or not (false). |
| IsCustom | boolean | Defaulted on create, Filter, Group, Sort | If true, the permission set is custom (created by an admin); if false, the permission set is standard and related to a specific permission set license. |
| IsOwnedByProfile | boolean | Defaulted on create, Filter, Group, Sort | If true, the permission set is owned by a profile. Available in API version 25.0 and later. |
| Label | string | Filter, Group, Sort | The permission set label, which corresponds to Label in the user interface. Limit: 80 characters. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Name | string | Filter, Group, Sort | The permission set group name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. This field is available in API version 30.0 and later. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |
| PermissionSetGroupId | reference | Filter, Group, Nillable, Sort | If the permission set is owned by a permission set group, this field returns the ID of the permission set group. If the permission set isn't owned by a permission set group, this field returns a null value. Available in API version 45.0 and later. |
| ProfileId | reference | Filter, Group, Nillable, Sort | If the permission set is owned by a profile, this field returns the ID of the profile. If the permission set isn't owned by a profile, this field returns a null value. |
| Type | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The permission set type. |

### PermissionSetAssignment

Represents a user's assignment to a permission set or permission set group. This object is available in API version 22.0 and later.

- **Version:** API 22.0+
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:**
  As of Summer '20 and later, only users who have one of these permissions can access this object:
  - View Setup and Configuration
  - Assign Permission Sets
  - Manage User

| Field | Type | Properties | Description (+ relationship info) |
|---|---|---|---|
| AssigneeId | reference | Create, Filter, Group, Sort | The ID of the user that is assigned the permission set indicated in PermissionSetId or the permission set group indicated in PermissionSetGroupId. This field is a relationship field. **Relationship Name:** Assignee · **Relationship Type:** Lookup · **Refers To:** User |
| ExpirationDate | dateTime | Create, Filter, Nillable, Sort, Update | The date that the assignment of the permission set or permission set group expires for the specified user. This field is available in API version 52.0 and later. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the assignment is active (true) or not (false). This field is available in API version 52.0 and later. The default value is false. |
| IsRevoked (Beta) | boolean | Defaulted on create, Filter, Group, Sort, Update | Indicates whether the assignment was revoked (true) or not (false). This field is available in API version 57.0 and later. Note: This feature is a Beta Service. Customer may opt to try such Beta Service in its sole discretion. Any use of the Beta Service is subject to the applicable Beta Services Terms provided at Agreements and Terms. The default value is false. |
| LastCreatedByChangeId (Beta) | reference | Filter, Group, Nillable, Sort | The ID of the user access change record related to this permission set or permission set group assignment. This field is available in API version 57.0 and later. This field is a relationship field. **Relationship Name:** LastCreatedByChange · **Relationship Type:** Lookup · **Refers To:** UserAccessChange. Note: This feature is a Beta Service. (Beta Services Terms 동일 문구) |
| LastDeletedByChangeId (Beta) | reference | Create, Filter, Group, Sort | The ID of the user access change record related to this permission set or permission set group assignment being revoked. This field is available in API version 57.0 and later. This field is a relationship field. **Relationship Name:** LastCreatedByChange [sic — 원문 그대로, LastDeletedByChange가 아니라 LastCreatedByChange로 표기됨] · **Relationship Type:** Lookup · **Refers To:** UserAccessChange. Note: This feature is a Beta Service. (Beta Services Terms 동일 문구) |
| PermissionSetGroupId | reference | Create, Filter, Group, Nillable, Sort | The ID of the permission set group assigned to the user specified in AssigneeId. This field is available in API version 45.0 and later. This field is a relationship field. **Relationship Name:** PermissionSetGroup · **Relationship Type:** Lookup · **Refers To:** PermissionSetGroup |
| PermissionSetId | reference | Create, Filter, Group, Nillable, Sort | The ID of the permission set assigned to the user specified in AssigneeId. This field is a relationship field. **Relationship Name:** PermissionSet · **Relationship Type:** Lookup · **Refers To:** PermissionSet |

### PermissionSetGroup

Represents a group of permission sets and the permissions within them. Use permission set groups to organize permissions based on job functions or tasks. Then, you can package the groups as needed. Available in Tooling API version 45.0 and later.

- **Version:** Tooling API 45.0+
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:**
  As of Summer '20 and later, to view this object, users must have one of these permissions:
  - View Setup and Configuration
  - Manage Session Permission Set Activations
  - Assign Permission Sets

  To edit this object, users must have the Manage Profiles and Permission Sets permission.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Filter, Group, Nillable, Sort, Query, Retrieve Update | The permission set group description. |
| DeveloperName | string | Create, Filter, Group, NameField, Sort, Update | The permission set group name used in the API. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| HasActivationRequired | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the permission set group requires an associated active session (true) or not (false). The default value is false. This field is available in API version 53.0 and later. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The Permission Set Group language. Valid values are: • Chinese (Simplified): zh_CN • Chinese (Traditional): zh_TW • Danish: da • Dutch: nl_NL • English: en_US • Finnish: fi • French: fr • German: de • Italian: it • Japanese: ja • Korean: ko • Norwegian: no • Portuguese (Brazil): pt_BR • Russian: ru • Spanish: es • Spanish (Mexico): es_MX (Spanish (Mexico) defaults to Spanish for customer-defined translations.) • Swedish: sv • Thai: th (The Salesforce user interface is fully translated to Thai, but Help is in English.) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Create, Filter, Group, Sort, Update | The permission set group label for the aggregated permissions. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The permission set group namespace prefix. |
| Status | string | DefaultedOnCreate, Filter, Group, Restricted picklist, Sort | Indicates the permission set group recalculation status. • Updated. The group is current. • Outdated. The group requires recalculation. • Updating. The group is in recalculation mode. • Failed. The group recalculation failed. |

**Usage:** Use the PermissionSetGroup object to query existing permission set groups and to find which aggregated permissions are included in the group.

### PermissionSetGroupComponent

A junction object that relates the PermissionSetGroup and PermissionSet objects via their respective IDs; enables permission set group recalculation to determine the aggregated permissions for the group. Available in Tooling API version 45.0 and later.

- **Version:** Tooling API 45.0+
- **Supported Calls:** create(), delete(), describeSObject() , query(), retrieve()  [원문 그대로 "Supported Calls" 라벨 + describeSObject() 단수형]
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** As of Spring '20 and later, only users with the View Setup and Configuration permission can access this object.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| PermissionSet | sObject | Create, Filter, Group, Sort | The permission set containing the permission set component. |
| PermissionSetGroup | PermissionSetGroup | Create, Filter, Group, Sort | The name of the permission set group. |
| PermissionSetGroupId | ID | Create, Filter, Group, Sort | The ID of the permission set group containing the permission set component. |
| PermissionSetId | ID | Create, Filter, Group, Sort | The ID of the permission set. |

**Usage:** Use the PermissionSetGroupComponent object to add members to or delete members from a permission set group, or to query for group members.

### PermissionSetTabSetting

Represents a tab's settings for a profile or permission set. Use PermissionSetTabSetting for manipulating tab visibility on profiles and permission sets. Available in Tooling API version 37.0 and later.

- **Version:** Tooling API 37.0+
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** As of Spring '20 and later, only users with View Setup and Configuration permission can access this object.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Name | string | Create, Filter, Group | The tab's API name. For standard tabs, the name is in the form "standard-Account". For custom tabs, it's the developer name. |
| ParentId | reference | Create, Filter, Group | The ID of the permission set to which this tab setting belongs. For profile tab settings, ParentId is the ID of the permission set owned by the profile. |
| Visibility | picklist | Create, Filter, Group, Restricted picklist | The default visibility setting for this tab. Valid values are: • Default Off • Default On. Note: There's no hidden value. Instead, a hidden tab is indicated by having no PermissionSetTabSetting row in the database. |

**Usage:** To hide a tab, delete the associated PermissionSetTabSetting object. ParentId and Name fields can't be updated.

This example creates a tab setting to make the custom object tab named CustomObject__c visible for the System Administrator profile.
```java
try {
  // Query for the ID of the permission set owned by the System Administrator profile
  String queryString = "SELECT Id FROM PermissionSet
    + WHERE Profile.Name = 'System Administrator'";
  QueryResult queryResult = connection.query(queryString);
  if (queryResult.getSize() > 0) {
    // Construct the tab setting sObject
    PermissionSetTabSetting tabSetting = new PermissionSetTabSetting();
    tabSetting.setParentId(queryResult.getRecords()[0].getId());
    tabSetting.setName("CustomObject__c");
    tabSetting.setVisibility(TabVisibility.DefaultOn);
    SObject[] sObjects = new SObject[] { tabSetting };
    // Create the tab setting
    SaveResult[] saveResults = connection.create(sObjects);
    for (SaveResult saveResult : saveResults) {
      if (saveResult.isSuccess()) {
        System.out.println("Successfully created the tab setting.");
        System.out.println("ID: " + saveResult.getId());
      } else {
        Error error = saveResult.getErrors()[0];
        System.out.println("Failed to create the tab setting.");
        System.out.println("Status code: " + error.getStatusCode());
        System.out.println("Message: " + error.getMessage());
      }
    }
  } else {
    System.out.println("Failed to find the ID of the permission set.");
  }
} catch (ConnectionException ce) {
  ce.printStackTrace();
}
```

This example updates the existing tab setting to make the Account tab available instead of visible for the Standard User profile.
```java
try {
  // Query for the ID of the tab setting for the Account tab on the Standard User profile
  String queryString = "SELECT Id FROM PermissionSetTabSetting "
      + "WHERE Parent.Profile.Name = 'Standard User' AND Name = 'standard-Account'";
  QueryResult queryResult = connection.query(queryString);
  if (queryResult.getSize() > 0) {
    // Change the visibility
    PermissionSetTabSetting tabSetting =
(PermissionSetTabSetting)queryResult.getRecords()[0];
    tabSetting.setVisibility(TabVisibility.DefaultOff);
    // Update the tab setting
    SObject[] sObjects = new SObject[] { tabSetting };
    SaveResult[] saveResults = connection.update(sObjects);
    for (SaveResult saveResult : saveResults) {
      if (saveResult.isSuccess()) {
        System.out.println("Successfully updated the tab setting.");
        System.out.println("ID: " + saveResult.getId());
      } else {
        Error error = saveResult.getErrors()[0];
        System.out.println("Failed to update the tab setting.");
        System.out.println("Status code: " + error.getStatusCode());
        System.out.println("Message: " + error.getMessage());
      }
    }
  } else {
    System.out.println("Failed to find the ID of the tab setting.");
  }
} catch (ConnectionException ce) {
  ce.printStackTrace();
}
```

The example deletes the existing tab setting to make the Account tab hidden for the Standard User profile.
```java
try {
  // Query for the ID of the tab setting for the Account tab on the Standard User profile
  String queryString = "SELECT Id FROM PermissionSetTabSetting "
      + "WHERE Parent.Profile.Name = 'Standard User' AND Name = 'standard-Account'";
  QueryResult queryResult = connection.query(queryString);
  if (queryResult.getSize() > 0) {
    // Delete the tab setting
    String[] ids = new String[] { queryResult.getRecords()[0].getId() };
    DeleteResult[] deleteResults = connection.delete(ids);
    for (DeleteResult deleteResult : deleteResults) {
      if (deleteResult.isSuccess()) {
        System.out.println("Successfully deleted the tab setting.");
        System.out.println("ID: " + deleteResult.getId());
      } else {
        Error error = deleteResult.getErrors()[0];
        System.out.println("Failed to delete the tab setting.");
        System.out.println("Status code: " + error.getStatusCode());
        System.out.println("Message: " + error.getMessage());
      }
    }
  } else {
    System.out.println("Failed to find the ID of the tab setting.");
  }
} catch (ConnectionException ce) {
  ce.printStackTrace();
}
```

### Profile

Represents a user profile. A profile defines a user's permission to perform different functions within Salesforce. This type extends the Metadata metadata type and inherits its fullName field. This object is available in API version 32.0 and later.

- **Version:** API 32.0+
- **Supported SOAP Calls:** getDeleted(), getUpdated(), query(), retrieve(), search()
- **Supported REST HTTP Methods:** GET, HEAD
- **Special Access Rules:**
  As of Summer '20 and later, Customer Portal and Partner Portal users cannot access this object.
  To view the following settings, assignments, and permissions for standard and custom objects in a specified profile, the View Setup and Configuration permission is required.
  - Client settings
  - Field permissions
  - Layout assignments
  - Object permissions
  - Permission dependencies
  - Permission set tab settings
  - Permission set group components
  - Record types

  As of API version 50.0 and later, only users with correct permissions can view profile names other than their own if the Profile Filtering setting is enabled.

> Important: Profile names are also exposed when users with permissions to perform the following tasks take these actions:
> - Create a tab or record type with a wizard step that includes the assignment of tabs and record types to profiles.
> - Configure a login flow where viewing profile lists is required to make flow associations.
> - Set up delegated admins where looking up profiles is needed to identify assignable profiles.
> - Administer an org as a delegated customer admin.
> - Administer an org as a delegated admin to view and assign profiles of the delegated group.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | The profile description, limited to 255 characters. |
| FullName | string | Create, Group, Nillable | The unique profile name. Use this name when creating the profile, before you have an ID. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Metadata | ProfileMetadata | Create, Nillable, Update | The profile metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Name | string | Filter, Group, idLookup, Sort | The profile name. |
| TimeSheetTemplateAssignments | tns:QueryResult | Nillable | The time sheet template that you assign to a particular profile. Because this field represents a relationship, use it only in subqueries. This field is available in Tooling API version 46.0 and later. |

### ProfileLayout

Represents a profile layout. This object is available in API version 32.0 and later.

- **Version:** API 32.0+
- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** As of Summer '20 and later, only users with the View Setup and Configuration permission can access this object.

| Field | Type | Properties | Description |
|---|---|---|---|
| LayoutId | ID | Filter, Group, Sort | The unique identifier for this layout. |
| ProfileId | ID | Filter, Group, Sort | The unique identifier for this profile. |
| RecordTypeId | ID | Filter, Group, Sort | The unique identifier for the record. |
| TableEnumOrId | string | Filter, Group, Restricted picklist, Sort | The enum (for example, Account) or ID of the object this field is on. |

---

## 레코드/필드 제한 (Record/Field Restriction)

> 제한·범위 규칙의 엔터프라이즈 설계 맥락은 [[레코드 액세스 설계 (Enterprise Scale)]] 참조.

### FieldRestrictionRule

Represents a field visibility rule that controls whether a field is visible to a user, based on the field's inclusion in the PersonalInfo_EPIM field set. If Enhanced Personal Information Management setting was enabled before Spring '22, field visibility is based on the field's compliance categorization. This object is available in API version 52.0 and later.

- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:**
  - To access this object, you must have the Manage Sharing permission.
  - To create and manage Employee field visibility rules, you must be assigned a Workplace Command Center permission set license and the Provides access to Workplace Command Center features system permission.
  - To create and manage User field visibility rules, you must enable Digital Experiences and the Enhanced Personal Information Management feature.

| Field | Type | Properties | Description |
|---|---|---|---|
| Classification | string[] | Filter | Required. The data classification compliance categorization or field set that is targeted by the rule. The rule applies to fields that are marked with this categorization or included in this field set. If you enabled Enhanced Personal Information Management before Spring '22 (API version 54.0), you can use Salesforce's default compliance categorization values or values that you add yourself. If you enabled Enhanced Personal Information Management after Spring '22 (API version 54.0), use the PersonalInfo_EPIM field set or a field set that you add yourself. |
| ClassificationType | ClassificationType (enumeration of type string) | Defaulted on create, Filter, Group, Restricted picklist, Sort | The type of classification method used in your org. If you enabled Enhanced Personal Information Management before Spring '22 (API version 54.0), use ComplianceCategory. If you enabled Enhanced Personal Information Management after Spring '22, use FieldSet. • ComplianceCategory— • FieldSet— The default value is ComplianceCategory. Available in API version 54.0 and later. |
| Description | textarea | Filter, Group, Sort | Required. The description of the rule. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the FieldRestrictionRule object. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EnforcementType | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | Required. The type of rule. Possible values are: • FieldRestrict—Field visibility rule. Only this value is valid. • Restrict—Do not use. • Scoping— Do not use. |
| FullName | string | Create, Group, Nillable | Required. The full name of the associated FieldRestrictionRule in Metadata API. The full name can include a namespaceprefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the rule is active (true) or not (false). The default value is false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the field visibility rule. The value for this field is the language value of the org. |
| MasterLabel | string | Filter, Group, Sort | Required. Label for the field visibility rule. |
| Metadata | mns:FieldRestrictionRule | Create, Nillable, Update | The field visibility rule's metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| RecordFilter | textarea | Create, Filter, Group, Sort, Update | Required. The criteria that determine which fields are visible to the specified users. For example, the field can check if the logged-in user matches the Employee's ID. |
| TargetEntity | picklist | Filter, Group, Restricted picklist, Sort | Required. The object for which you're creating the rule. Only the Employee and User objects are supported. |
| UserCriteria | textarea | Create, Filter, Group, Sort, Update | Required. The users that this rule applies to, such as all active users or users with a specified role or profile. |
| Version | int | Filter, Group, Sort | Required. The rule's version number. |

### RestrictionRule

Represents a restriction rule or a scoping rule. A restriction rule has EnforcementType set to Restrict and controls the access that specified users have to designated records. A scoping rule has EnforcementType set to Scoping and controls the default records that your users see without restricting access. This object is available in API version 52.0 and later.

- **Version:** API 52.0+
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** Only users with the View Restriction and Scoping Rules permission can view restriction rules and scoping rules via the API. Only users with the Manage Sharing permission can view, create, update, and delete restriction rules and scoping rules.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Group, Nillable, Sort | Required. The description of the rule. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the RestrictionRule object. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EnforcementType | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | Required. The type of rule. Possible values are: • FieldRestrict—Don't use. • Restrict—Restriction rule. • Scoping—Scoping rule. |
| FullName | string | Create, Group, Nillable | Required. The full name of the associated RestrictionRule in Metadata API. The full name can include a namespaceprefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the rule is active (true) or not (false). The default value is false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the rule. The value for this field is the language value of the org. |
| MasterLabel | string | Filter, Group, Sort | Label for the rule. |
| Metadata | mns:RestrictionRule | Create, Nillable, Update | The restriction rule's metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| RecordFilter | textarea | Create, Filter, Group, Sort, Update | Required. The criteria that determine which records are accessible via the rule. |
| TargetEntity | picklist | Filter, Group, Restricted picklist, Sort | Required. The object for which you're creating the rule. We recommend that you don't edit this field after the rule is created. If EnforcementType is set to Restrict, custom objects, external objects, and these objects are supported: • Contract • Event • Quote • Task • TimeSheet • TimeSheetEntry. If EnforcementType is set to Scoping, custom objects and these objects are supported: • Account • Case • Contact • Event • Lead • Opportunity • Task |
| UserCriteria | textarea | Create, Filter, Group, Sort, Update | Required. The users that this rule applies to, such as all active users or users with a specified role or profile. |
| Version | int | Filter, Group, Sort | Required. The rule's version number. |

**Usage:**

The following is an example of a RestrictionRule representing a restriction rule.
```json
{
    "FullName":"restriction_rule_tasks_you_own",
    "Metadata": {
        "active":true,
        "description":"Allows users of a specific profile to see only tasks that they own.",
        "enforcementType":"Restrict",
        "masterLabel":"Tasks You Own",
        "recordFilter":"OwnerId = $User.Id",
        "targetEntity":"Task",
        "userCriteria":"$User.ProfileId = '00exxxxxxxxxxxx'",
        "version":1
    }
}
```

The following is an example of a RestrictionRule representing a scoping rule.
```json
{
        "FullName":"Department A contact scoping rule",
        "Metadata": {
             "active":true,
             "description":"View contacts from Department A.",
             "enforcementType":"Scoping",
             "masterLabel":"SR for Department A",
             "recordFilter":"Department=$User.Department",
             "targetEntity":"Contact",
             "userCriteria":"$User.UserRoleId = '00Exxxxxxxxxxxx'",
             "version":1
        }
}
```

SEE ALSO: https://developer.salesforce.com/docs/atlas.en-us.restriction_rules.meta/restriction_rules/restriction_rules_about.htm

---

## 보안 상태 & 정책 (Security Health & Policy)

> 권한·접근 제어 위협 분석은 [[권한과 접근 제어 위협]], 트랜잭션 보안 정책의 Apex 인터페이스는 [[TxnSecurity Namespace]] 참조.

### SecurityHealthCheck

Represents your org's Health Check score. The score indicates how well your org's security settings comply with Salesforce-recommended values in the baseline standard. Only users with the "View Setup and Configuration" user permission can retrieve data from this object. Available in Tooling API version 37.0 and later.

- **Version:** Tooling API 37.0+
- **Supported SOAP Calls:** query()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** (별도 섹션 없음 — 접근 제한은 설명문에 명시: "View Setup and Configuration" user permission)

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomBaselineId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Identifies which baseline is used to import settings and calculate score. |
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| Score | string | Filter, Group, Nillable, Sort | The Health Check score for the org. The score can range from 0 to 100. |

**Usage:** Use this object to query your org's Health Check score.
```sql
SELECT Score FROM SecurityHealthCheck
```
More Health Check information is available by querying the object SecurityHealthCheckRisks on page 849.

### SecurityHealthCheckRisks

Represents your org's security setting values, risks, and Salesforce-recommended setting values. Only users with the "View Setup and Configuration" user permission can retrieve data from this object. Available in Tooling API version 37.0 and later.

- **Version:** Tooling API 37.0+
- **Supported SOAP Calls:** query()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** (별도 섹션 없음 — "View Setup and Configuration" user permission, 설명문에 명시)

> 작업지시서가 예고한 격자형 risk-threshold 매트릭스(RiskType×Setting×Standard/Recommended/High-risk)는 **실제 PDF에 존재하지 않는다.** SecurityHealthCheckRisks는 일반 필드 테이블이며, StandardValue/OrgValue/RiskType 등은 각각 **독립 필드**(cross-tab 격자 아님)다.

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| OrgValue | string | Filter, Nillable, Sort | The org's value for the security setting. |
| OrgValueRaw | string | Filter, Nillable, Sort | The org's value for the security setting as it is stored in the database, usually without units of measure or extra text. For example, if the Minimum Password Length setting's OrgValue is 8 characters, the OrgValueRaw is 8. |
| RiskType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The level of risk of the org's security setting value. Valid values are: • HIGH_RISK • MEDIUM_RISK • MEETS_STANDARD |
| SecurityHealthCheckId | string | Filter, Group, Nillable, Sort | The ID of the Health Check score record associated with this field. |
| Setting | string | Filter, Group, Nillable, Sort | The name of the security setting. For example, Minimum password length. |
| SettingGroup | string | Filter, Group, Nillable, Sort | The name of the security setting group in which the setting resides in the Setup tree. For example, Password Policies. |
| SettingRiskCategory | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The level of risk of the org's security settings. Available in version 40.0 and later. Valid values are: • HIGH_RISK • MEDIUM_RISK • LOW_RISK • INFORMATIONAL |
| StandardValue | string | Filter, Nillable, Sort | Salesforce-recommended standard value for the security setting. |
| StandardValueRaw | string | Filter, Nillable, Sort | Salesforce-recommended standard value for the security setting as it is stored in the database, usually without units of measure or extra text. For example, if the Minimum Password Length setting's StandardValue is 8 characters, the StandardValueRaw is 8. |

**Usage:** Use this object to query your org's security setting values, risks, and Salesforce-recommended setting values. Reading security settings and their security status is useful if you have multiple Salesforce applications that require consistency and compliance in their security posture.

This query gets a list of your org's high risk settings.
```sql
SELECT RiskType, Setting, SettingGroup, OrgValue, StandardValue FROM SecurityHealthCheckRisks where RiskType='HIGH_RISK'
```
This query gets your org's Health Check score and a list of your org's high risk settings.
```sql
SELECT Score, (SELECT RiskType, Setting, SettingGroup, OrgValue, StandardValue FROM SecurityHealthCheckRisks where RiskType='HIGH_RISK') FROM SecurityHealthCheck
```
This query gets your org's Health Check score and the security settings that meet the Salesforce baseline standard.
```sql
SELECT Score, (SELECT RiskType, Setting, SettingGroup, OrgValue, StandardValue FROM SecurityHealthCheckRisks where RiskType='MEETS_STANDARD') FROM SecurityHealthCheck
```
This query lists all the values in the Salesforce baseline standard.
```sql
SELECT Setting, SettingGroup, StandardValue FROM SecurityHealthCheckRisks
```

### TransactionSecurityPolicy

Represents a transaction security policy definition. This object is available in Tooling API version 35.0 and later.

> Apex 측 `TxnSecurity.PolicyCondition`/`TxnSecurity.EventCondition` 인터페이스는 [[TxnSecurity Namespace]] 참조.

- **Version:** Tooling API 35.0+
- **Supported Calls:** create(), delete(), query(), retrieve(), update(), upsert()  [원문 라벨 "Supported Calls"]
- **Supported REST Methods:** Query, DELETE, GET, PATCH, POST  [원문 라벨 "Supported REST Methods"]
- **Special Access Rules:** (별도 섹션 없음)

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionConfig | textarea | Create, Update | Describes the action to take when the matching Transaction Security policy is triggered. Also indicates the type of notifications selected and the ID of the intended recipient. The recipient must be active and assigned the Modify All Data and View Setup user permissions. Multiple actions can be taken. The actions available depend on the EventType field. |
| ApexPolicyId | reference | Filter, Group, Nillable, Sort | Represents the Apex TxnSecurity.PolicyCondition or TxnSecurity.EventCondition interface for this policy. |
| BlockMessage | string | Filter, Nillable, Sort | The custom message a user receives when their action is blocked by a policy. Used in Real-Time Event Monitoring only. Maximum of 1000 characters. This field appears as null when the default message option is selected and is available only when EventName is set to ApiEvent, ListViewEvent, and ReportEvent. Available in API version 49.0 and later. |
| CustomEmailContent | string | Filter, Nillable, Sort, | The administrator-created custom email content sent when a policy is triggered. Used in Real-Time Event Monitoring only. Maximum of 1333 characters. This field is null when the Custom Email Content setting is selected in the UI but no message content is entered. Available in API version 54.0 and later. Custom messages aren't translatable. |
| Description | string | Filter, Nillable, Sort | The description entered for this policy. This field available in API 39.0 and later. |
| DeveloperName | string | Filter, Group, Sort | The API, or program name, for this policy. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EventName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Used in Real-Time Event Monitoring only. Indicates the name of the event the policy monitors. This field is available in API 31.0 and later. Valid values are: • ApiEvent—Tracks these user-initiated read-only API calls: query(), queryMore(), and count(). Captures API requests through SOAP API and Bulk API for the Enterprise and Partner WSDLs. Tooling API calls and API calls originating from a Salesforce mobile app aren't captured. • CredentialStuffingEventStore—Tracks when a user successfully logs into Salesforce during an identified credential stuffing attack. Credential stuffing refers to large-scale automated login requests using stolen user credentials. This value is available in API 49.0 and later. • FileEventStore (beta)—Tracks when a user downloads, previews, or uploads a file. FileEventStore is a big object that stores the event data of FileEvent. This object is available in API version 57.0 and later. • ListViewEvent—Tracks when users access data with list views using Lightning Experience, Salesforce Classic, or the API. It doesn't track list views of Setup entities. • LoginAnomalyEventStore—Stores the records of data access anomalies that are caused by potentially malicious login actions. • LoginAsEvent—Tracks the login activity of admins who log in to Salesforce as other users. This object is available in API version 46.0 and later. • LoginEvent—LoginEvent tracks the login activity of users who log in to Salesforce. • PermissionSetEventStore—Tracks changes to permission sets and permission set groups. • ReportAnomalyEventStore—Tracks anomalies in how users run or export reports, including unsaved reports. This value is available in API 49.0 and later. • ReportEvent—Tracks when reports are run in your org. • SessionHijackingEventStore—Tracks when unauthorized users gain ownership of a Salesforce user's session with a stolen session identifier. To detect such an event, Salesforce evaluates how significantly a user's current browser fingerprint diverges from the previously known fingerprint using a probabilistically inferred significance of change. This value is available in API 49.0 and later. |
| EventType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Used in Legacy Transaction Security only. Indicates the type of event the policy monitors. Valid values are: • AccessResource—Notifies you when the selected resource has been accessed. • AuditTrail—Reserved for future use. • DataExport—Notifies you when any API query is made, such as from the Data Loader API client, or when a Report export occurs. • Entity—Notifies you on use of an object type such as an authentication provider or chatter post. • Login—Notifies you when a user logs in. Note: As of Summer '20, Legacy Transaction Security is a retired feature in all Salesforce orgs. |
| ExecutionUserId | reference | Filter, Group, Nillable, Sort | Used in Legacy Transaction Security only. The ID of an active user who is assigned the Modify All Data and View Setup user permissions. Note: As of Summer '20, Legacy Transaction Security is a retired feature in all Salesforce orgs. |
| FullName | string | Create, Group, Nillable | The full name of the associated object in the Metadata API. Use to avoid race conditions on create, before you have IDs. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| MasterLabel | string | Filter, Group, Sort | The policy's name. Important: Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations. |
| Metadata | mns:TransactionSecurityPolicy | Create, Nillable, Update | The policy's metadata. See the Metadata API Developer Guide for details. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |
| ResourceName | string | Filter, Group, Nillable, Sort | Used in Legacy Transaction Security only. A resource used to narrow down the conditions under which the policy triggers. For example, with a DataExport event, you can select a resource Lead to specifically monitor export activity occurring on your Lead entities. The resources available depend on the EventType field. Note: As of Summer '20, Legacy Transaction Security is a retired feature in all Salesforce orgs. |
| State | picklist | Filter, Group, Restricted picklist, Sort | Indicates whether the policy is active. Valid values are: • Disabled • Enabled |
| Type | picklist | Filter, Group, Restricted picklist, Sort | The type of validation that the policy uses. The valid values are: • CustomApexPolicy— Created with Apex editor. • CustomConditionBuilderPolicy— Created with Condition Builder. The default value is CustomApexPolicy. |

---

## 사용자 접근 (User Access)

### UserAccessPolicy

Represents a user access policy. This object is available in API version 57.0 and later.

> Important (원문): Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Version:** API 57.0+
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update() , upsert()
- **Supported REST API Methods:** GET, POST, PATCH, DELETE, HEAD, Query
- **Special Access Rules:** To create or modify user access policies, users must have the Manage User Access Policies permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| BooleanFilter | string | Filter, Group, Nillable, Sort | Required. The logic that determines how your user criteria filters are applied in the user access policy. For instance, if you have two user access policy filters with the SortOrder equal to 1 and 2, respectively, the BooleanFilter can be 1 AND 2 or 1 OR 2. |
| Description | textarea | Filter, Group, Nillable, Sort | Description of the user access policy. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the user access policy. The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. Label is Name. Note: When creating large sets of data, always specify a unique DeveloperName for each record. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | The language of the user access policy. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Filter, Group, Sort | Label for the user access policy. In the UI, this field is Label. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |
| Order | int | Create, Filter, Group, Nillable, Sort, Update | Indicates the order for which active policy is applied when a user meets the criteria for multiple policies. Must be an integer from 0 to 10,000. Only the active policy with the lowest Order value is applied. This field is required only if the Status field is set to Active. Available in API version 61.0 and later. |
| Status | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status of the user access policy. Possible values are: • Active • Completed • Design • Failed • Migrate • Testing • Updating. The default value is Design. If you deploy a policy with a status of Active, the status is changed to Design. A Salesforce admin can then set the status to Active by automating the policy in Setup. |
| TriggerType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The type of user record trigger for which this user access policy runs. Possible values are: • Create—The user access policy runs when a user who matches the policy criteria is created. • CreateAndUpdate—The user access policy runs when a user who matches the policy criteria is either created or updated. • Update—The user access policy runs when a user who matches the policy criteria is updated. |

**Usage:** For more information, see User Access Policies in Salesforce Help.

### UserAccessPolicyAction

Represents an action applied by the user access policy. This object is available in API version 57.0 and later.

- **Version:** API 57.0+
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update() , upsert()
- **Supported REST API Methods:** GET, POST, PATCH, DELETE, HEAD, Query
- **Special Access Rules:** To create or modify user access policies, users must have the Manage User Access Policies permission.

| Field | Type | Properties | Description (+ relationship info) |
|---|---|---|---|
| Action | picklist | Filter, Group, Restricted picklist, Sort | Indicates whether the user access policy grants access to or removes access from the target access mechanism. Possible values are: • Grant • Revoke |
| TargetId | reference | Filter, Group, Nillable, Sort | The ID of the access mechanism that the user access policy applies. This field is a polymorphic relationship field. **Relationship Name:** Target · **Relationship Type:** Lookup · **Refers To:** Group, Queue, PermissionSet, PermissionSetGroup |

**Usage:** For more information, see User Access Policies in Salesforce Help.

### UserAccessPolicyFilter

Represents a user criteria filter for a user access policy. This object is available in API version 57.0 and later. You can use the UserAccessPolicyFilter Tooling API object to configure more complex user criteria filters for your user access policies.

- **Version:** API 57.0+
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** GET, POST, PATCH, DELETE, HEAD, Query
- **Special Access Rules:** To create or modify user access policies, users must have the Manage User Access Policies permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| ColumnName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | If Target is set to User, the user field that your user criteria filter is based on. Possible values are: • CommunityNickname • Department • Division • Email • FirstName • IsActive • LastName • Title. Some custom fields are also supported, depending on the field type. If you don't set Target to User, then this field isn't used. |
| Operation | picklist | Filter, Group, Restricted picklist, Sort | The operator of the user criteria filter. Possible values are: • equals • equalsIgnoreCase— Available in API version 59.0 and later. • in— Available in API version 58.0 and later. • includes— Available in API version 59.0 and later. • notEquals. Select in if you want to reference multiple profile or role IDs in the same user criteria filter. To do this, create multiple UserAccessPolicyFilter objects with Operation set to in and with the same SortOrder value. The only field that differs between these UserAccessPolicyFilter objects is the Value field, which references the various IDs. All of the IDs referenced in the in expression must be of the same type. |
| SortOrder | int | Filter, Group, Sort | The numeric reference used to identify the specific filter. |
| Target | picklist | Filter, Group, Restricted picklist, Sort | If your user criteria filter is based on a user field, set to User. If your user criteria filter is based on a package license, permission set, permission set group, permission set license, profile, or role, then this field isn't used. |
| Value | string | Filter, Group, Nillable, Sort | If Target is set to User, the value of the user field specified in ColumnName that your user filter is operating on. Otherwise, the ID of the group, package license, permission set, permission set group, permission set license, profile, role, or queue that your user filter is operating on. |

**Usage:** For more information, see User Access Policies in Salesforce Help.

### UserEntityAccess

Represents the access that the current user has to an object. Available in Tooling API version 34.0 and later.

- **Version:** Tooling API 34.0+
- **Supported SOAP Calls:** query(), search()
- **Supported REST HTTP Methods:** GET
- **Limitations:**
  - SOQL Limitations on page 38
  - SOSL Limitations on page 40

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| EntityDefinition | EntityDefinition | Filter, Group, Nillable, Sort | The entity definition for the object associated with this user entity access record. Because this field represents a relationship, use only in subqueries. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | ID of the EntityDefinition. |
| IsActivateable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to activate records of the associated object type if the User owns them. For example, a user owns an Apex trigger or workflow rule, and can activate them if this field is true for ApexTrigger or WorkflowRule. |
| IsCreatable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to create records of the associated object type. |
| IsDeletable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to delete records of the associated object type. |
| IsEditable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to edit records of the associated object type. |
| IsFlsUpdatable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to change field-level security settings on appropriate fields of the associated object type. For example, an administrator could deny a group of users access to the Type field on Account. |
| IsMergeable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to merge records of the associated object type. |
| IsReadable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to view records of the associated object type. |
| IsUndeletable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to undelete records of the associated object type. |
| IsUpdatable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to edit records of the associated object type. |
| User | User | Filter, Group, Nillable, Sort | The user who has the access defined in this user entity access record, for the entity specified in the EntityDefinition field. Because this field represents a relationship, use only in subqueries. |
| UserId | ID | Filter, Group, Nillable, Sort | ID of the user specified in the User field. |

**Usage:** Queries on UserEntityAcces [sic] need filters on both the entity side and the user side.

Example: Entity Side
```sql
SELECT EntityDefinition.QualifiedApiName, EntityDefinition.MasterLabel
FROM UserEntityAccess WHERE UserId={current_user_id}
AND IsCreateable=true AND EntityDefinition.IsCustomizable=true
```
Example: User Side
```sql
UserId={current_user_id}
```

### UserFieldAccess

Represents the access that the current user has to a field. Available in Tooling API version 34.0 and later.

- **Version:** Tooling API 34.0+
- **Supported SOAP Calls:** (원문에 Supported Calls / REST / Special Access Rules 섹션이 **없음** — 설명문 직후 바로 Fields 시작. quirk로 기록.)
- **Supported REST HTTP Methods:** (원문에 없음)
- **Special Access Rules:** (원문에 없음)

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| EntityDefinition | EntityDefinition | Filter, Group, Nillable, Sort | The entity definition for the object associated with this user entity access record. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | ID of the EntityDefinition. |
| IsAccessible | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to view the associated field. |
| IsCreatable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to create records of the associated field. |
| IsUpdatable | boolean | Defaulted on create, Filter, Group, Sort | If true, the user specified in the User field has access to edit the associated field. |
| User | User (on page 924) | Filter, Group, Nillable, Sort | The user who has access defined in this user field access record, for the entity specified in the EntityDefinition field. Because this field represents a relationship, use only in subqueries. |
| UserId | ID | Filter, Group, Nillable, Sort | ID of the user specified in the User field. |

**SOQL Limitations:** This object doesn't support some SOQL operations.
- **GROUP BY** — Example Query: `SELECT COUNT(qualifiedapiname), isfeedenabled FROM EntityDefinition GROUP BY isfeedenabled` — Error Returned: The requested operation is not yet supported by this SObject storage type, contact salesforce.com support for more information.
- **LIMIT, LIMIT OFFSET** — Example Queries: `SELECT qualifiedapiname FROM EntityDefinition LIMIT 5` / `SELECT qualifiedapiname FROM EntityDefinition LIMIT 5 OFFSET 10` — An incorrect result is returned because LIMIT and LIMIT OFFSET are ignored.
- **NOT** — Example Query: `SELECT qualifiedapiname FROM EntityDefinition WHERE qualifiedapiname!='Account'` — Error Returned: Only equals comparisons permitted
- **OR** — Example Query: `SELECT qualifiedapiname, keyprefix FROM EntityDefinition WHERE isdeletable=true OR (isfeedenabled=false AND keyprefix='01j')` — Error Returned: Disjunctions not supported
- **INCLUDES** — Example Query: `SELECT ComplianceGroup FROM FieldDefinition WHERE EntityDefinitionId = 'Account' AND ComplianceGroup includes('GDPR')` — Error Returned: Unsupported filter type

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브. REST/SOQL 쿼리 리소스·헤더·composite·EOL 등 호출 기초.
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체↔네임스페이스 분류, SOQL/SOSL 한도, System Fields, ApiFault.
- [[Tooling API — SOAP·REST 헤더]] — 호출 시 사용하는 SOAP/REST 헤더.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 형제 Ch4 도메인 노트(Apex 코드·테스트 sObject 군).
- [[Tooling API 객체 — Entity·Field·스키마]] — 형제 Ch4 도메인 노트(스키마 메타데이터 sObject 군).
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — 선언적 자동화 sObject 19종(Flow·Workflow·ValidationRule·MatchingRule 등) 형제 Ch4 도메인 노트.
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — UI·레이아웃·페이지·액션 sObject 22종(FlexiPage·Layout·QuickAction·WebLink·Path 등) 형제 Ch4 도메인 노트. 본 노트의 ProfileLayout·PermissionSetTabSetting을 UI(탭·레이아웃) 관점에서 링크.
- [[Metadata Types — Objects & Fields]] — 같은 이름의 Metadata API **타입**(NamedCredential·ExternalCredential·Profile·PermissionSet·RestrictionRule 등) 카탈로그. 본 노트는 Tooling **sObject**(SOQL 조회/구성), 그쪽은 배포용 declarative metadata.
- [[Permission Set 설계]] — 권한집합·권한집합그룹 설계 패턴(PermissionSet·PermissionSetGroup의 응용).
- [[레코드 액세스 설계 (Enterprise Scale)]] — 제한·범위 규칙(RestrictionRule·FieldRestrictionRule)의 엔터프라이즈 레코드 액세스 설계.
- [[Named Credential]] — NamedCredential·ExternalCredential·ExternalDataSource의 콜아웃 자격증명 설계.
- [[CSP와 RemoteSite]] — CspTrustedSite·RemoteProxy의 CSP/원격 사이트 경계.
- [[TxnSecurity Namespace]] — TransactionSecurityPolicy가 참조하는 Apex `TxnSecurity.PolicyCondition`/`EventCondition` 인터페이스.
- [[Auth Namespace]] — ExternalAuthIdentityProvider와 연관된 Apex 인증 네임스페이스.
- [[권한과 접근 제어 위협]] — SecurityHealthCheck·권한 모델의 보안 위협 관점.
