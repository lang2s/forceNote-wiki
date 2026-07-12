---
tags: [Security, Certificate, Key-Management, TLS, SAML, JWT, mTLS, 인증서, 키관리, 보안설정]
source: help.salesforce.com — Generate a Self-Signed Certificate (security_keys_creating, Tier 2, 2026-07-11 접속); help.salesforce.com — Generate a Certificate Signed by a Certificate Authority (security_keys_uploading_signed_cert, Tier 2, 2026-07-11 접속); developer.salesforce.com — Certificate (Metadata API, meta_certificate, Tier 2, 2026-07-11 접속); developer.salesforce.com — Using Certificates for two-way SSL callouts (apex_callouts_client_certs, Tier 2, 2026-07-11 접속); help.salesforce.com — Enable Salesforce as a SAML Identity Provider (identity_provider_enable, Tier 2, 2026-07-11 접속); help.salesforce.com — Create or Edit a JWT External Credential (nc_create_edit_jwt_ext_cred, Tier 2, 2026-07-11 접속)
created: 2026-07-11
aliases: [Certificate and Key Management, 인증서 및 키 관리, Self-Signed Certificate, CA-Signed Certificate, 자체 서명 인증서, CA 서명 인증서, Certificate Signing Request, CSR, Exportable Private Key, keySize 2048, 서명 인증서, Signing Certificate, IdP 인증서]
---

# Certificate and Key Management (인증서·키 관리)

> Salesforce가 외부 시스템에 자신을 증명할 때 쓰는 인증서(자체 서명·CA 서명)와 키를 한 곳에서 생성·가져오기·회전하는 Setup 페이지 — 양방향 TLS 클라이언트 인증, SAML 서명, JWT 서명, SSO IdP 인증서의 공통 발급처다.

---

## 개념 — Certificate and Key Management이란

**Setup → Security → Certificate and Key Management** (Quick Find에 `Certificate and Key Management`) 페이지는 Salesforce 조직이 **자신의 신원을 외부에 증명**하는 데 쓰는 디지털 인증서와 그 개인 키(private key)를 관리한다. 여기서 만든/가져온 인증서는 여러 기능이 룩업으로 공유한다:

| 용도 | Salesforce가 인증서로 하는 일 |
|---|---|
| **양방향 TLS(mTLS) 아웃바운드 콜아웃** | TLS handshake 중 Salesforce가 **자신의 클라이언트 인증서를 제시**해 외부 서버가 Salesforce를 검증 |
| **SAML 서명 (Salesforce = IdP)** | SAML assertion에 서명. 기본은 SHA-256으로 생성된 자체 서명 인증서 |
| **SAML 요청 서명 (Salesforce = SP)** | Request Signing Certificate를 업로드해 SP→IdP 요청에 서명 |
| **JWT 서명 (External Credential)** | JWT 인증 프로토콜을 쓰는 External Credential이 JWT를 서명할 Signing Certificate를 참조 |
| **Outbound Message · Delegated Authentication** | 아웃바운드 메시지/위임 인증 요청에 API Client Certificate로 서명 |

> 근거: [Generate a Self-Signed Certificate](https://help.salesforce.com/s/articleView?id=xcloud.security_keys_creating.htm) · [Enable Salesforce as a SAML Identity Provider](https://help.salesforce.com/s/articleView?id=xcloud.identity_provider_enable.htm) · [Create or Edit a JWT External Credential](https://help.salesforce.com/s/articleView?id=sf.nc_create_edit_jwt_ext_cred.htm). SAML IdP는 기본적으로 **SHA-256 서명 알고리즘**의 자체 서명 인증서를 쓴다.

---

## 인증서 종류 — Self-Signed vs CA-Signed

| 구분 | Self-Signed Certificate | CA-Signed Certificate |
|---|---|---|
| 발급자 | Salesforce 자신이 서명 | 외부 인증기관(CA)이 서명 |
| 신뢰 방식 | 상대가 이 인증서를 **명시적으로 truststore/keystore에 등록**해야 신뢰 | 상대가 **CA 체인**으로 검증(공개 신뢰 루트) |
| 생성 흐름 | 즉시 발급(1단계) | ① CSR 생성 → ② CA에 제출 → ③ 서명본 업로드(import)의 3단계 |
| 대표 용도 | 내부/양측 통제 시스템 간 mTLS, SAML IdP 기본 | 공개 신뢰가 필요한 mTLS 상대, 엄격한 파트너 |
| 만료 | keySize로 자동 결정(아래) | 업로드한 서명 체인의 만료일로 자동 갱신 |

> mTLS로 인증하는 외부 상대는 보통 **CA 서명 인증서**를 요구한다(자체 서명은 상대 keystore에 수동 등록이 필요하므로). 근거: [Using Certificates (Apex Developer Guide)](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_client_certs.htm).

### 키 크기(keySize)와 만료

Metadata API의 `Certificate` 타입 기준 `keySize`는 **2048 또는 4096**이며, 자체 서명 인증서의 만료는 키 크기가 자동 결정한다:

| keySize | 자체 서명 만료 |
|---|---|
| **2048** (기본) | 생성일로부터 **1년** |
| 4096 | 생성일로부터 **2년** |

> 헬프 문서(Generate a Self-Signed Certificate)는 추가로 **3072-bit**도 언급하며 2048·3072는 1년, 4096은 2년으로 설명한다. Metadata API 필드 정의는 2048/4096만 열거하므로, org·릴리스에 따라 UI의 Key Size 선택지가 다를 수 있다 — 화면에 표시된 값을 따른다. 근거: [Certificate (Metadata API)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_certificate.htm).

---

## 설정 절차

### A. 자체 서명 인증서 생성 (Create Self-Signed Certificate)

```
// 구조 예시 — 실제 화면 라벨은 org/릴리스에 따라 다를 수 있음
1. Setup → Quick Find "Certificate and Key Management" → Create Self-Signed Certificate
2. 필드 입력:
   · Label            (사람이 읽는 이름, 최대 64자)          ← masterLabel
   · Unique Name      (API 참조용 고유명, 자동 채워짐·수정 가능)
   · Exportable Private Key  (개인 키 내보내기 허용 여부 체크박스)  ← privateKeyExportable
   · Key Size         (2048 기본 / 4096 …)                   ← keySize
   · Platform Encryption (플랫폼 암호화로 키 보호 여부)         ← encryptedWithPlatformEncryption
3. Save → 즉시 발급. 만료일은 Key Size가 자동 결정.
```

- **Unique Name**은 콜아웃·External Credential·SAML 설정이 이 인증서를 참조하는 키다. 생성 후 이 값을 기록해 둔다(예: mTLS에서 `setClientCertificateName('UniqueName')`).
- **Exportable Private Key**는 생성 시점에만 결정된다 — 나중에 org 간 이관(JKS export)이나 재사용이 필요하면 체크한다. 미체크면 키는 org 밖으로 나갈 수 없어 더 안전하다.

### B. CA 서명 인증서 (Create CA-Signed Certificate → CSR → import)

```
// 구조 예시 — 3단계 흐름
1. Setup → Certificate and Key Management → Create CA-Signed Certificate
   · Label / Unique Name / Exportable Private Key / Key Size 입력 (A와 동일 필드)
2. 인증서 목록에서 방금 만든 항목 → "Download Certificate Signing Request" (CSR 다운로드)
   → CSR을 원하는 CA에 제출
3. CA가 서명본을 회신하면 → 같은 페이지에서 해당 인증서 선택 →
   "Upload Signed Certificate" 로 서명된 인증서 체인을 업로드(import)
   · 업로드하는 CA 서명본은 Salesforce에서 만든 인증서와 매칭돼야 함
   · expirationDate 는 업로드한 서명 체인의 만료일로 자동 갱신
```

> 근거: [Generate a Certificate Signed by a Certificate Authority](https://help.salesforce.com/s/articleView?id=xcloud.security_keys_uploading_signed_cert.htm). Metadata API는 CSR 다운로드와 서명 체인 업로드(갱신 워크플로)를 지원하며, 인증서는 `.crt` 접미사로 `certs` 폴더에 저장된다.

### C. 키스토어에서 가져오기 / 내보내기

- 외부에서 만든 키 쌍이 있으면 **Import from Keystore**로 가져올 수 있다(JKS 형식).
- 모든 인증서·개인 키를 **JKS 형식으로 export**해 다른 org에서 재사용할 수 있다(Exportable Private Key가 체크된 경우).

---

## 용도별 배선 (Wiring)

### 1) mTLS 아웃바운드 콜아웃 — 클라이언트 인증서 제시

여기서 만든 인증서의 **Unique Name**을 콜아웃에 붙인다. 두 경로:

| 방법 | 지정 위치 |
|---|---|
| **Named Credential의 `Certificate` 필드** | Legacy Named Credential(및 신형의 mTLS 인증) 편집 화면 룩업에서 인증서 선택 → `callout:{NC}`가 handshake에서 자동 제시 (코드 수정 불필요) |
| **Apex `HttpRequest.setClientCertificateName('UniqueName')`** | 코드에서 직접 인증서 Unique Name 지정 |

> 콜아웃 셋업·코드 예제·Named vs Per-User 차이 등 **사용측 상세는 [[Named Credential]] 노트의 "아웃바운드 상호 TLS" 소절과 [[Secure Communications (TLS)]]로 위임한다.** 이 노트는 인증서를 **만드는 쪽**만 다룬다.

### 2) JWT 서명 (External Credential)

JWT 인증 프로토콜을 쓰는 External Credential은 여기서 만든 **Signing Certificate**를 참조해 JWT에 서명한다.

- 서명 인증서는 **패키지에 포함되지 않는다** — JWT/JWT Bearer 프로토콜을 쓰는 패키지 Named Credential을 설치하면 **구독 org에서 서명 인증서를 재생성**하고 UI 또는 Connect API로 External Credential에 다시 배선해야 한다.
- 필드 카탈로그는 [[Named Credential·External Credential 생성 필드 전수 레퍼런스]]로 위임.

### 3) SAML 서명 · IdP/SP

- **Salesforce = IdP**: assertion 서명에 자체 서명 인증서(기본 SHA-256)를 사용. IdP 설정 화면에서 **Download Certificate**로 SP에 전달, **Download Metadata**로 IdP 메타데이터 XML 제공.
- **Salesforce = SP**: 요청 서명에 쓸 **Request Signing Certificate**를 여기서 만들어 SP 설정에 업로드.

### 4) Key Management — 마스터 암호화 키

Certificate and Key Management 페이지는 **Platform Encryption**의 키 관리(마스터 암호화 키 회전·BYOK용 Tenant Secret/BYOK 인증서 생성) 진입점이기도 하다.

> 데이터 at-rest 암호화의 Tenant Secret·키 파생·회전 등 **암호화 키 관리 상세는 [[Platform Encryption]]으로 위임**한다. 이 노트가 다루는 인증서는 데이터 암호화 키가 아니라 **신원 증명·서명용 인증서**다(별개의 개념).

---

## 회전·만료 운영

- 자체 서명 인증서는 keySize에 따라 1~2년 후 만료되므로 **만료 전 새 인증서 발급 → 참조처(Named Credential·External Credential·SAML·IdP) 재배선**의 회전 절차가 필요하다.
- CA 서명 인증서는 CA 발급 만료일을 따르며, 갱신 시 새 CSR → 재서명 → Upload Signed Certificate.
- 만료된 인증서는 mTLS handshake 실패, SAML 서명 검증 실패, JWT 콜아웃 실패로 이어진다.

---

## 관련 노트
- [[Named Credential]] — 여기서 만든 인증서를 아웃바운드 콜아웃(mTLS `Certificate` 필드·`setClientCertificateName`)·JWT External Credential에 배선하는 사용측
- [[Secure Communications (TLS)]] — 전송 계층 TLS/HTTPS 강제와 단방향 vs 상호 TLS 개념
- [[Platform Encryption]] — 데이터 at-rest 암호화 키(마스터 키·Tenant Secret·BYOK) 관리 위임
- [[Named Credential·External Credential 생성 필드 전수 레퍼런스]] — External Credential의 Signing Certificate 등 필드 카탈로그
- [[Salesforce ID 인증]] — SAML/SSO IdP·SP 인증 흐름에서 인증서 사용 맥락
