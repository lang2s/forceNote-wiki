---
tags: [admin, email, deliverability, dkim, email-relay, bounce-management, spf, email-security, compliance-bcc]
source: help.salesforce.com (Salesforce Help — Deliverability Guidelines / Create a DKIM Key / Set Up Email Relay / Enable Email Bounce Handling / Test Deliverability / Compliance BCC / Email Footers; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
official_doc: https://help.salesforce.com/s/articleView?id=sales.emailadmin_deliverability.htm&type=5
created: 2026-07-12
aliases: [Email Deliverability Infrastructure, 이메일 전달성 인프라, DKIM Keys, DomainKeys Identified Mail, Email Relay, 이메일 릴레이, Bounce Management, 반송 관리, Test Deliverability, Email Security Compliance, Compliance BCC, Email Footers, SPF, 이메일 인증, 스푸핑 방지]
---

# 이메일 전달성 인프라 (Deliverability · DKIM · Email Relay · Bounce)

> Salesforce가 조직 도메인으로 보내는 이메일이 스팸으로 분류되지 않고 수신함에 도달하도록 하는 **발신 인증·전달성 인프라** — DKIM 서명(스푸핑 방지), Email Relay(회사 SMTP 경유), Bounce 관리(반송 처리), Test Deliverability(IP 차단 진단), Compliance BCC·Footer(규정 준수)를 다룬다.

> [!note] 범위 구분 — **Access to Send Email**(No access / System email only / All email 3단계)의 기본 개념·발신 요건(도메인+사용자 인증)은 [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]]에 있다. 이 노트는 그 위의 **인프라 심화**(인증 프로토콜·릴레이·반송·진단)를 다룬다.

---

## Deliverability (Setup → Deliverability)

`Setup → Deliverability` 한 페이지에서 조직의 발신 이메일 허용 수준·보안 준수·TLS를 제어한다. 전달성을 떨어뜨리는 두 요인은 **① 같은 도메인으로의 과거 반송 이력**과 **② 수신자 보안 프레임워크 미준수**다.

### Access to Send Email (발신 접근 수준)

| 값 | 동작 |
|---|---|
| **No access** | 사용자로/부터의 모든 아웃바운드 이메일 차단. 단 **비밀번호 재설정 이메일은 계속 발송**된다. |
| **System email only** | 신규 사용자·비밀번호 재설정 같은 **자동 생성 시스템 이메일만** 발송. 샌드박스에서 테스트·개발 중 실사용자에게 테스트 메일이 안 나가게 할 때 사용. **새로 만든 샌드박스의 기본값**. |
| **All email** | 모든 유형의 아웃바운드 이메일 허용. **신규 비-샌드박스 조직의 기본값**. Spring '13 이전 생성 샌드박스도 이 값이 기본. |

> activity composer의 **Send Email 퀵 액션**(Email 탭)을 보려면 All email이어야 한다.

### Email Security Compliance (표준 이메일 보안 메커니즘 준수)

- **Enable compliance with standard email security mechanisms** 체크 → Salesforce가 보내는 이메일의 **envelope From 주소를 수정**한다(대부분의 SPF 등 보안 프레임워크는 envelope 주소를 검사). **header From 주소는 발신자 주소 그대로** 유지된다. envelope From은 `*.bnc.salesforce.com` 형태가 된다.
- **Enable Sender ID compliance** — Sender ID 인증 프로토콜을 쓰는 수신자용(널리 쓰이지 않음). envelope의 Sender 필드에 `no-reply@salesforce`를 자동 포함하도록 수정. 수신자의 회신은 여전히 발신자 주소로 전달. 수신자 이메일 클라이언트가 From에 "Sent on behalf of"를 붙일 수 있음.
  - ⚠️ **Summer '24 이후 생성된 조직은 Sender ID compliance를 활성화할 수 없다**(Sender ID 지원 종료).

### TLS Setting (전달성 페이지의 아웃바운드 TLS)

아웃바운드 SMTP 세션에 TLS를 어떻게 쓸지 지정한다.

| 값 | 동작 |
|---|---|
| **Off** | TLS 끔. 비암호화 연결로 SMTP 세션 진행. |
| **Preferred** (기본) | 원격 서버가 TLS 지원 시 현재 세션을 TLS로 업그레이드. TLS 불가 시 TLS 없이 계속. |
| **Required** | 원격 서버가 TLS 지원할 때만 세션 계속. TLS 불가 시 이메일 미전달·세션 종료. |
| **Preferred Verify** | TLS 지원 시 인증서 검증(유효 CA 서명 + common name이 도메인/MX 일치) 후 업그레이드. 인증서 미서명·불일치면 세션 끊고 미전달. TLS 불가 시 TLS 없이 계속. |
| **Required Verify** | 원격 서버 TLS 지원 + 유효 CA 서명 + common name 일치 3조건 모두 충족해야 세션 계속. 하나라도 안 맞으면 미전달·세션 종료. |

- Preferred 외의 값을 고르면 **Restrict TLS to these domains**로 콤마 구분 도메인 목록 지정. `*` 와일드카드 허용(`*.subdomains.com` → `john@aco.subdomains.com` 매치, `john@subdomains.com`은 불매치). 도메인 미지정 시 모든 아웃바운드에 TLS 설정 적용 → 미전달 유발 가능.
- **TLS 1.0은 비활성화**되어 있다.

---

## DKIM Keys (Setup → DKIM Keys) — DomainKeys Identified Mail

> 필요 권한: **Customize Application**. Available in: all editions except Database.com.

DKIM은 발신 이메일에 **디지털 서명**을 붙여 "이 메일이 내 도메인에서 왔고 전송 중 변조되지 않았음"을 수신 서버가 검증하게 하는 보안 표준이다. 활성 DKIM 키는 **도메인 소유권을 증명**해 Salesforce가 사용자 대신 발신할 수 있게 하며, **도메인 수준 인증** 요건을 충족한다(단, DKIM 키의 도메인명이 'From' 주소의 전체 도메인과 일치할 때만). 도메인·서브도메인마다 별도 DKIM 키를 만든다.

### Create a DKIM Key 절차

```text
// 구조 예시 — DKIM 키 생성 흐름(실제 동작 코드 아님)
Setup → Quick Find "DKIM Keys" → Create New Key   (생성 시 기본 Inactive)
  ├ RSA key size        : 2048-bit 권장 (특정 앱이 더 작은 키를 요구하지 않는 한)
  ├ Selector            : 고유 문자열 ≤62 (영문/숫자/하이픈, 첫 글자=문자/숫자) 예: example-sf-a
  ├ Alternate Selector  : 또 다른 고유 문자열 ≤62 (키 자동 회전용)          예: example-sf-b
  ├ Domain              : Salesforce 발신 도메인 (저장 후 수정 불가)
  └ Domain match pattern: 콤마 구분 도메인 패턴 (일치해야 이 키로 서명)     예: example.com
→ Save
```

- **RSA key size**: 2048-bit 권장.
- **Selector / Alternate Selector**: 각각 62자 이하 영문·숫자·하이픈, 문자/숫자로 시작. Alternate Selector는 **키 자동 회전(rotation)** 에 사용.
- **Domain**: 저장 후 도메인명 편집 불가. 소유한 서브도메인(예: `mail.example.com`)으로 발신·서명하려면 서브도메인마다 별도 키 생성.
- **Domain match pattern**: 서명 전 도메인명이 일치해야 하는 패턴. 소유 도메인의 DKIM 키에는 **와일드카드 사용 비권장**(허용되지만 더 이상 권장 안 함).

### DNS 게시 · 활성화

1. 저장하면 Salesforce가 **DKIM 공개키 2개(primary + alternate)를 DNS TXT 레코드**로 게시하고, 대응하는 **CNAME 레코드**를 생성한다(보통 15분 내 완료).
2. 생성된 **CNAME + Alternate CNAME** 레코드를 도메인 DNS에 추가한다(DNS 제공자와 협업). TXT Record Status가 "Publishing in progress"면 몇 분 후 재시도.

```text
// 구조 예시 — DKIM CNAME DNS 레코드(공식 문서 예시)
NAME                                  TTL   CLASS TYPE  VALUE
example-sf-a._domainkey.example.com.  3600  IN    CNAME example-sf-a.k4tyd2.custdkim.salesforce.com.
example-sf-b._domainkey.example.com.  3600  IN    CNAME example-sf-b.e6mxu6.custdkim.salesforce.com
```

3. **DNS 전파는 최대 72시간**. 전파 완료 시 DKIM Key Details 페이지에 CNAME·Alternate CNAME 레코드가 표시되고 **Activate** 옵션이 나타난다. CNAME이 DNS에 게시되기 전에는 활성화 불가.
4. **Activate** 클릭. 보안을 위해 Salesforce는 **DKIM 키를 30일마다 자동 회전**한다. 활성화하면 다음 회전용 보조(inactive) 키가 생성되고 두 번째 CNAME이 이를 가리킨다. 활성화 후 회전에는 추가 조치가 필요 없다.

---

## Email Relay (Setup → Email Relays)

> 필요 권한: **Email Administration, Customize Application, View Setup**. Available in: Professional·Enterprise·Performance·Unlimited·Developer.

Salesforce가 생성한 이메일을 **회사의 SMTP 서버를 경유해 자동 라우팅**하도록 구성한다(규정 준수·아카이빙·통합 발신). 여러 도메인으로 보내면 도메인마다 릴레이를 구성할 수 있다.

> bounce management·email compliance management를 함께 켤 계획이면, 회사 이메일 관리자에게 **Salesforce에서 온 이메일의 릴레이를 회사 메일 서버가 허용하는지** 먼저 확인한다.

### Create Email Relay 필드

```text
// 구조 예시 — Email Relay 구성(실제 동작 코드 아님)
Setup → Quick Find "Email Relays" → Create Email Relay
  ├ Host        : 메일 도메인 / 호스트명 / IP  (예: myemaildomain.com | mail.myemaildomain.com | 100.121.20.5)
  │                → 이름 제공 시 DNS MX 먼저 조회, 없으면 A 레코드. TLS 사용 시 IP 아닌 호스트명 입력(인증서 검증용)
  ├ Port        : 회사 SMTP 포트 — 지원: 25, 587, 10025, 11025
  ├ TLS Setting : Off | Preferred(기본) | Required | Preferred Verify | Required Verify
  └ Enable SMTP Auth (선택)
        ├ Auth Type : Auth Plain(기본, PLAIN SASL) | Auth Login(LOGIN SASL)  ← PLAIN·LOGIN만 지원
        ├ Username / Password / Confirm Password
→ Save → Email Domain Filter 설정(필수)
```

- **Host**: 이름 제공 시 Salesforce가 DNS **MX 레코드 먼저, 없으면 A 레코드**를 찾는다. TLS를 쓰려면 인증서 검증 때문에 **IP가 아니라 호스트명**을 입력해야 한다.
- **Port**: 릴레이 지원 포트는 **25, 587, 10025, 11025**.
- **TLS Setting**: Deliverability 페이지와 동일한 5단계(Off / Preferred(기본) / Required / Preferred Verify / Required Verify).
- **Enable SMTP Auth**: 켜면 **Auth Type**(Auth Plain 기본 = PLAIN SASL, Auth Login = LOGIN SASL — **PLAIN·LOGIN만 지원**) + Username/Password/Confirm Password. 활성화 전 **샌드박스에서 테스트** 권장(일부 이메일 서비스는 릴레이 SMTP 인증 미지원). 해제하면 자격증명은 저장되되 SMTP 인증으로 라우팅하지 않는다.

### Email Domain Filter (필수)

- 릴레이가 동작하려면 **반드시 email domain filter를 설정**해야 한다.
- 한 조직에 릴레이가 여러 개면 각 **email domain filter의 우선순위 순서**로 처리된다. 기본적으로 도메인 필터는 **생성된 순서**로 평가된다.

---

## Bounce Management (Setup → Deliverability: Activate bounce management)

> Enable Email Bounce Handling 필요 권한: **Customize Application AND Modify All Data**.

반송 처리를 켜면 담당자가 이메일 미전달과 잘못된 주소를 가진 리드·연락처·개인 계정을 알 수 있다. Salesforce 발신 이메일은 먼저 **MTA(Mail Transfer Agents)** 로 가고 MTA가 수신자에게 전달한다.

| 유형 | 설명 | DSN 코드 |
|---|---|---|
| **Soft bounce** (소프트 반송) | 임시 실패 — 메일함 가득 참, 메일 서버 일시 불가. 재시도 가능, 주소 문제 아님. | **4xx** DSN |
| **Hard bounce** (하드 반송) | 영구 실패 — 유효하지 않거나 존재하지 않는 수신자 주소. | **5xx** DSN |

- 전달 실패 시 수신자 시스템이 **DSN(Delivery Status Notification)** 을 반환. Salesforce가 이를 파싱해 반송 경고를 표시하고 잘못된 주소 레코드를 플래그.
- **In-band(동기) 반송**: Gmail처럼 이메일을 수락하지 않고 즉시 DSN 반환. **Out-of-band(비동기) 반송**: 일단 수락 후 나중에 DSN 반환.
- **반송 관리 활성화 시** return-path 주소가 `...bnc.salesforce.com`으로 끝나는 주소가 되어 DSN을 수신·처리한다. **비활성화 시** return-path는 발신자 주소로 남고 반송 메시지가 발신자에게 직접 전달된다.

### 레코드에 미치는 영향 (필드)

- 이메일 레코드의 **`IsBounced` = True**, activity timeline에 반송 아이콘.
- **하드 반송일 때만** 연락처·리드·개인 계정이 bounced로 표시되고 **`EmailBouncedDate`·`EmailBouncedReason`** 필드가 채워지며 레코드 상세에 반송 아이콘 표시.
- `EmailBouncedReason`(텍스트 필드, 반송 회신의 설명)은 **리스트 뷰·보고서·워크플로우**에서 하드 반송 주소를 찾는 데 사용. 단 **반송 사유 값은 bounce report에는 제공되지 않는다**.
- 상세 페이지 **highlights panel**에 이메일 주소 필드를 두어야 경고 아이콘이 사용자에게 보인다.
- 반송을 확인·해제하려면 레코드를 편집해 주소를 확인/수정한다. **반송 처리는 암호화된 이메일 주소를 지원하지 않는다**.

---

## Test Deliverability (Setup → Test Deliverability)

> 필요 권한: **Modify All Data**. Available in: all editions except Database.

Salesforce 발신 이메일은 여러 Salesforce IP 주소 중 하나를 거친다. 수신자가 그 중 하나라도 차단하면 이메일이 도달하지 못할 수 있다. Test Deliverability는 **가능한 각 Salesforce 발신 IP에서 자기 자신에게 테스트 메일을 보내** 차단 여부를 진단한다.

```text
// 구조 예시 — Test Deliverability 절차(실제 동작 코드 아님)
Setup → Quick Find "Test Deliverability" → 비즈니스 이메일 주소 입력 → Send
→ Salesforce가 모든(발신) IP 주소에서 테스트 메일 발송(각 메일에 발신 IP 명시)
→ 비즈니스 메일함 확인: 전부 수신되면 차단 없음
→ 일부 미수신 시 이메일 관리자가 Salesforce IP 범위를 서버 allowlist에 추가
```

- 모든 테스트 메시지를 다 받으면 어떤 Salesforce IP도 차단하고 있지 않은 것. Hyperforce·비-Hyperforce 조직 모두 동일 절차.
- Salesforce는 **인바운드·아웃바운드 IP를 분리** 유지한다(아웃바운드 IP는 인바운드 연결을 받지 않음).
- **Hyperforce 조직**은 테스트 메시지를 **하나만** 보낸다. 미수신 시 관리자가 **mutual TLS(mTLS)** 를 사용해야 한다.

---

## Compliance BCC Email (Setup → Compliance BCC Email)

> 필요 권한: **Customize Application**. Available in: Professional·Enterprise·Performance·Unlimited·Developer.

모든 아웃바운드 이메일을 규정 준수 목적으로 평가하는 조직용. 각 발신 이메일의 **숨은 사본(hidden copy)을 지정한 주소로 자동 BCC** 발송한다.

- 활성화하면 사용자가 **BCC 필드를 편집할 수 없고**, My Email Settings의 **Automatic Bcc 설정이 비활성화**된다.
- Send Email 액션에서 BCC 필드에 **미리 정의된 값(predefined values)을 사용할 수 없다**.
- 절차: `Setup → Compliance BCC Email` → **Enable** 체크 → 규정 준수 이메일 주소 입력 → Save.
- **제외 대상**: 비밀번호 재설정, 가져오기 완료, Experience Cloud 사이트 환영 메일 등 일부 시스템 이메일은 BCC되지 않는다.

---

## Email Footers (Setup → Email Footers)

조직 전체 이메일 푸터로 모든 Salesforce 발신 이메일에 공통 메시지(면책·규정 문구 등)를 적용한다.

- 푸터를 생성·편집·비활성화하고 **기본 푸터**를 설정할 수 있다.
- **single email · mass email · list email** 각각에 대해 기본 이메일 푸터를 선택. **인코딩별**로 별도 푸터 생성 가능.
- Lightning Experience에서 Gmail·Office 365로 보낸 이메일도 조직 전체 푸터를 포함할 수 있다(포함 여부 선택).

---

## 인프라 한눈에 보기

```text
// 구조 예시 — 발신 전달성 인프라 매핑(실제 동작 코드 아님)
발신 인증(스푸핑 방지)   : DKIM 서명(도메인 소유권) · SPF/Email Security Compliance(envelope From) · Sender ID(Summer'24+ 불가)
발신 경로               : Email Relay(회사 SMTP 경유) · TLS(Off~Required Verify)
수신 실패 처리           : Bounce Management(soft 4xx / hard 5xx · IsBounced·EmailBouncedReason)
진단                   : Test Deliverability(IP 차단 점검 · Hyperforce=mTLS)
규정 준수               : Compliance BCC(숨은 사본) · Email Footers(공통 푸터)
발신 허용 게이트         : Access to Send Email(No/System only/All) — 상세는 Org-Wide 노트
```

## 관련 노트
- [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]] — Access to Send Email 3단계·발신 요건(도메인+사용자 인증)·조직 전체 발신 주소. 이 노트는 그 인프라 심화.
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 실제 발신되는 자동 이메일. DKIM·릴레이·전달성 설정에 의존.
- [[Login History & Email Log Files (로그인·이메일 감사 로그)]] — 발신 이메일의 감사 로그·이메일 로그 파일.
