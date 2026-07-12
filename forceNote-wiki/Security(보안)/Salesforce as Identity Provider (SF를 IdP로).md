---
tags: [security, identity, sso, saml, oidc, identity-provider, connected-app]
source: help.salesforce.com - xcloud.sso_sfdc_idp_parent.htm (외 6개 공식 페이지, 접속 2026-07-11)
created: 2026-07-11
aliases: [Identity Provider, IdP, Salesforce as IdP, SAML Identity Provider, Service Provider SSO, Enable Identity Provider, 아이덴티티 프로바이더, SF를 IdP로]
---

# Salesforce as Identity Provider (SF를 IdP로)

> Salesforce 조직을 **IdP(Identity Provider)** 로 세워, 외부 앱(SP)에 SSO 로그인을 제공한다. 사용자는 Salesforce 자격증명 하나로 여러 앱에 로그인한다. (Salesforce가 SP인 인바운드 SSO와 방향이 반대다.)

---

## 방향 구분 — IdP vs SP (가장 흔한 혼동)

| 역할 | 누가 인증하나 | 대표 설정 | 예 |
|---|---|---|---|
| **Salesforce as Identity Provider (IdP)** | Salesforce가 **다른 앱**을 인증 | Identity Provider 활성화 + Connected App/ECA를 SP로 정의 | Salesforce 계정으로 AWS·사내 웹앱에 로그인 |
| **Salesforce as Service Provider (SP)** | **외부 IdP**가 Salesforce를 인증 | SAML Single Sign-On Settings (Setup) | Okta·ADFS 계정으로 Salesforce에 로그인 |

이 노트는 **IdP 방향**(아웃바운드)이다. SP 방향(인바운드 SAML SSO)은 별도 설정(`Single Sign-On Settings`)이며 방향이 반대다.

Salesforce IdP는 **SAML** 또는 **OpenID Connect(OIDC)** 두 프로토콜을 지원한다.

전체 셋업 흐름(공식 4단계):
```text
// 구조 예시 — 공식 문서 절차 요약(실제 화면 아님)
1. Enable Salesforce as an Identity Provider   (Setup > Identity Provider)
2. Complete prerequisites                        (IdP 메타데이터/인증서를 SP에 전달 + SP 정보 수집)
3. Integrate service provider as a SAML-enabled app  (Connected App 또는 External Client App)
4. Map Salesforce users to the service provider  (Subject Type에 맞춰 사용자 식별자 매핑)
```

---

## 1. IdP 활성화 — Enable Salesforce as a SAML Identity Provider

- **필요 권한:** Customize Application (IdP·SP 정의/수정)
- **에디션:** Developer, Enterprise, Performance, Unlimited, Database.com

**인증서 결정이 먼저.** IdP가 SP와 통신할 때 쓸 인증서를 정한다. 기본 자체서명 인증서를 쓰거나 직접 만든다.
- 기본값: Salesforce IdP는 **SHA-256** 서명 알고리즘으로 생성된 **자체서명(self-signed) 인증서**를 사용한다.
- 직접 만들려면 `Generate a Self-Signed Certificate` 또는 CA 서명 인증서(`Generate a Certificate Signed by a Certificate Authority`) 절차를 먼저 수행한다.

**활성화 절차:**
1. Setup의 Quick Find에서 **Identity Provider** 검색·선택
2. **Enable Identity Provider** 클릭
3. 드롭다운에서 인증서 선택
4. 저장

**활성화 후 Identity Provider 페이지에서 가능한 작업:**

| 작업 | 설명 / 주의 |
|---|---|
| **Edit** (인증서 변경) | ⚠️ 인증서를 바꾸면 외부 앱 접근이 끊길 수 있다. 새 인증서 정보로 모든 외부 앱을 갱신해 검증한다. |
| **Disable** | ⚠️ IdP를 비활성화하면 사용자가 어떤 외부 앱에도 SSO로 접근할 수 없다. |
| **Download Certificate** | SP가 Salesforce에 연결할 때 쓸 IdP 인증서 다운로드 |
| **Download Metadata** | IdP 메타데이터 XML 다운로드(SP가 연결 설정에 사용) |
| Details 섹션 | **Issuer**(Salesforce IdP의 고유 식별자) 확인 |
| SAML Metadata Discovery Endpoints | **Salesforce Identity**(커스텀 도메인 메타데이터 URL), **Community Identity**(특정 Experience Cloud 사이트 메타데이터 URL) 확인 — 예: AWS를 SP로 설정 시 이 메타데이터를 AWS에 업로드 |

**SAML assertion 수명(고정 정책):** Salesforce IdP가 보내는 SAML assertion은 **발급 후 5분간 유효**하며, 시계 오차(clock skew) 대비 **30초 버퍼**가 있다. 예: 12:00:00 GMT 발급 → 11:59:30 ~ 12:05:00 GMT 유효. 이 구간을 벗어나 도착하면 SP는 보통 거부한다.

---

## 2. 사전 준비 — Complete Prerequisites for SAML Service Provider Integration

1. **IdP 정보를 SP에 전달** — SP가 지원하는 형식에 따라 메타데이터 XML(`Download Metadata`) 또는 인증서(`Download Certificate`)로 공유.
2. **SP로부터 설정 정보 수집:**
   - **ACS URL** (Assertion Consumer Service) — IdP가 SAML 응답을 보내는 SP 엔드포인트
   - **Entity ID** — SP의 고유 식별자
   - **Subject Type** — SP가 SAML assertion의 subject에서 기대하는 사용자 식별자 위치
3. **Forced authentication(강제 재인증):** SP가 SAML request에 `ForceAuthn` 파라미터를 추가하면, SSO 시 사용자가 자격증명을 다시 입력해야 한다. Salesforce가 IdP일 때 forced authentication은 **자동 지원**(org 추가 설정 불필요).

SP가 보내는 forced-authn SAML request 예(공식 문서 발췌):
```xml
<!-- 실제 문서 발췌 SAML AuthnRequest (SP → Salesforce IdP) -->
<samlp:AuthnRequest
  AssertionConsumerServiceURL="ACS_URL"
  Destination="IDP_INIT_LOGIN_URL"
  Version="2.0"
  IssueInstant="2011-05-20T13:01:00.000Z"
  ProviderName="..."
  ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
  xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
  ForceAuthn="true">
  <!-- ... -->
</samlp:AuthnRequest>
```

---

## 3. SP를 SAML 앱으로 통합 — Integrate Service Providers as SAML-Enabled Apps

SP는 **External Client App(ECA) 프레임워크** 또는 **Connected App 프레임워크** 중 하나로 통합한다. ECA가 차세대 프레임워크다.

> ⚠️ **Setup 라벨 주의(2026-07-11):** **Connected app 신규 생성은 Spring '26부터 제한**된다. 기존 connected app은 계속 사용 가능하나, Salesforce는 **External Client App 사용을 권장**한다. 부득이 계속 생성해야 하면 Salesforce Support에 문의. (SAML 방향에서 ECA는 현재 **Metadata API 설정만** 지원.)

- **ECA로 통합:** SAML-enabled ECA는 3개 메타데이터 컴포넌트로 구성 — 부모 `ExternalClientApplication`, `ExtlClntAppConfigurablePolicies`, `ExtlClntAppSamlConfigurablePolicies`. (Metadata API로 생성·편집)
- **Connected App으로 통합:** 아래 SAML 필드를 설정.

### Connected App SAML 2.0 설정 필드 (Web App Settings > Enable SAML)

| 필드 | 설명 |
|---|---|
| **Start URL** | 인증 후 사용자를 보낼 위치. 절대 URL 또는 앱 이름 링크. 지정 시 앱 메뉴·App Launcher에 노출 |
| **Entity Id** | SP의 전역 고유 ID. 한 SP에서 여러 앱 접근 시 `RelayState` 파라미터로 로그인 후 앱을 지정 |
| **ACS URL** | (Assertion Consumer Service) SAML assertion을 받는 SP 엔드포인트 |
| **Subject Type** | 앱에 대한 사용자 식별 필드 지정. 옵션: username, federation ID, 15자 user ID, custom attribute, 알고리즘 계산 persistent ID. Custom Attribute는 User 오브젝트의 커스텀 필드(Email·Text·URL·Formula[Text 반환]) |
| **Name ID Format** | SAML 메시지의 format 속성. 기본 **Unspecified**. SP에 따라 email address / persistent / transient. email address 설정 시 org 사용자와 Experience Cloud 사용자를 SAML 메시지에서 다르게 기술 |
| **Issuer** | 기본값은 org의 My Domain 로그인 URL(표준 issuer). SP가 다른 값을 요구하면 지정 |
| **Enable Single Logout** | Salesforce 로그아웃 시 SP에서도 자동 로그아웃. Single Logout Endpoint(SAML Login Information / Discovery Endpoint)와 HTTP binding 타입 지정 |
| **IdP Certificate** | SP가 SAML request 검증에 고유 인증서를 요구하면 업로드, 아니면 **Default IdP Certificate**. 인증서 크기 **4KB 제한** |
| **Verify Request Signatures** | SP가 보안 인증서를 제공하고 SP-initiated 로그인을 쓸 때. ⚠️ 인증서 업로드 시 **모든 SAML request는 서명 필수**, 미업로드 시 모든 request 수락 |
| **Encrypt SAML Response** | (선택) assertion 암호화. 알고리즘: **AES-128** 또는 **AES-256** |
| **Signing Algorithm for SAML Messages** | **SHA1** 또는 **SHA256** — org(IdP)이 SP로 보내는 SSO·SLO 메시지 서명에 적용 |

Name ID Format을 email address로 둔 Experience Cloud 사용자 로그인 SAML 예(공식 발췌):
```xml
<!-- 실제 문서 발췌 — Name ID Format = email address -->
<saml:Subject>
  <saml:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress">00DR00000008fLq@sandy@play-test.com</saml:NameID>
  <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
    <saml:SubjectConfirmationData NotOnOrAfter="2021-02-04T20:17:12.647Z" Recipient="..."/>
  </saml:SubjectConfirmation>
</saml:Subject>
```
SP가 org ID 없이 이메일만 받는다면, 이메일 주소용 **custom attribute**를 만든다(Add Custom Attributes to a Connected App).

---

## 4. 사용자 매핑 — Map Salesforce Users to the SAML Service Provider

어떤 식별자를 쓰는지는 SP가 기대하는 **Subject Type**에 달렸다.
- **Subject Type = Username** → SAML assertion subject에 Salesforce username을 보냄. SP가 그대로 인식.
- **Subject Type = Federation ID** → 각 사용자의 Salesforce 설정에 **Federation ID**를 넣어야 함.

개별 사용자 매핑 절차(Federation ID):
1. Setup > Quick Find > **Users**
2. 대상 사용자 옆 **Edit**
3. **Single Sign On Information** > **Federation ID**에 SP가 인식할 식별자 입력(예: SP 로그인 username)
4. 저장

---

## OpenID Connect IdP (변형)

Salesforce는 **OpenID Connect Identity Provider(OIDC)** 로도 동작한다. SAML 대신 OIDC를 쓰는 relying party에 로그인을 제공한다.
- Connected App을 만들고 `Integrate Service Providers as Connected Apps with OpenID Connect` 절차로 설정.
- 검토·편집: connected app 재설정, 신뢰 IP 범위 제한, custom attribute 추가, 삭제.
- 프로파일·권한 집합: `Manage Access to a Connected App`.

---

## 관련 노트
- [[Connected App (연결된 앱) — OAuth 클라이언트]]
- [[External Client App (외부 클라이언트 앱)]]
- [[Auth Provider (인증 공급자)]]
- [[My Domain (마이 도메인)]]
- [[Login Flows · OAuth Custom Scopes (로그인 흐름·커스텀 스코프)]]

---

### 출처 (Tier 2 · help.salesforce.com · 접속 2026-07-11)
- Salesforce as an Identity Provider — `xcloud.sso_sfdc_idp_parent.htm`
- Enable Salesforce as a SAML Identity Provider — `xcloud.identity_provider_enable.htm`
- Complete Prerequisites for SAML Service Provider Integration — `xcloud.service_provider_prerequisites.htm`
- Integrate Service Providers as SAML-Enabled Apps — `xcloud.service_provider_define.htm`
- Integrate Service Providers as Connected Apps with SAML 2.0 — `xcloud.connected_app_create_saml_sso.htm`
- Map Salesforce Users to the SAML Service Provider — `xcloud.service_provider_map_users.htm`
- Salesforce as an OpenID Connect Identity Provider — `xcloud.service_provider_define_oid.htm`
