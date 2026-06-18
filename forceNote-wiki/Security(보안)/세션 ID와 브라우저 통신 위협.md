---
tags: [Security, SecureCoding, SessionID, PostMessage, WebSockets, 보안가이드, 위협모델, 브라우저통신]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Session ID 보안, managed package session, postMessage, Cross-Site WebSocket Hijacking, CSWSH, WSS, Same Origin Policy, JWT ECA, External Client App, targetOrigin, postMessage origin 검증, 세션 ID 노출 위험, iframe 메시지 보안, 웹소켓 하이재킹 막기]
---

# 세션 ID와 브라우저 통신 위협

> managed package의 session ID 오용으로 인한 namespace 보호 우회, 그리고 postMessage·WebSocket을 통한 cross-origin 통신 위협을 한데 다룬다.

---

## Session ID 사용 시 고려사항 (Ch3)

### 위협

managed package에서 session ID를 부적절하게 처리하면 namespace 보호가 우회된다. admin이 managed package를 설치할 때 패키지가 admin의 session ID에 접근해 namespace 보호를 우회하면 → Setup 작업(다른 패키지 제거, org 전역 보안 설정 변경)을 수행할 수 있다. admin에게 통지되지 않고 audit trail이 없어 추적 불가능하다. 규제 산업(금융·정부)에 특히 중요하다.

### Supported Session ID Use Cases (전수)

- Standard UI XHR calls (CometD, AJAX Toolkit 등)
- SOAP/REST Data API calls (org 데이터 접근)
- Metadata API **read** 작업
- Metadata API **write** 작업 — 단 managed package가 소유한 metadata에 한정 (예: field help text, 패키지 custom field의 picklist 값, partner 소유 field·object의 custom layout 업데이트)

> **Note:** write 작업에 session ID 사용 시 Salesforce admin에게 통지한다. Security team에 요청 제출 시 스크린샷과 코드 레퍼런스를 포함한다.

### Prohibited Session ID Use Cases (전수)

- session ID를 third-party 시스템/외부 웹사이트로 export
- Metadata API/Tooling API로 민감한 org 전역 설정(예: password policy) 편집
- Metadata API/Tooling API로 named credential, connected app, external client app 생성/수정
- Outbound Message Actions에서 "Send Session ID" 활성화 ("Outbound Message with Session ID" Security Updates 참조)

### Alternatives to Session IDs (전수)

1. **JWT-Based External Client App (ECA)** — JWT ECA를 솔루션에 패키징. JWT 인증은 callback URL이 불필요(dummy URL 사용 가능). private key는 protected custom metadata/protected custom settings에 안전 저장. sample connected app code, sample ECA code 참조.
   > **Important:** JWT-enabled ECA/CA는 profile/permission set로 명시 인가된 least-privileged 사용자에게만 접근을 부여한다. 운영상 필요 없으면 System Administrator 같은 고권한 profile 할당을 회피한다.
2. **Subscriber-Provided ECA** — admin에게 ECA 생성을 요청하고 client key/secret을 제공받는다. 설정 단계·필요 변경·OAuth scope·권한을 설명하는 setup 페이지를 패키지에 포함한다.
3. **Admin-Driven Manual Configuration** — 민감 변경(예: IP allowlist 항목)은 admin이 수동 수행한다. 보안 민감 작업을 패키지에서 자동화하지 않는다.

> **Note:** 모든 신규 구현은 distribution=Local인 External Client Apps(ECA) 사용이 필수다. 기존 구현은 Connected Apps를 계속 사용할 수 있다.

위 대안의 적용 use case: org 전역 설정 변경(Remote Site Settings 변경 등), managed package가 소유하지 않은 metadata 수정.

> JWT/OAuth/SessionManagement Apex 메커니즘 상세는 [[Auth Namespace]] 참조.

**참고 링크:** External Client Apps / Partner Third-Party Connections Recommended Security Settings / Prepare for Connected App Usage Restrictions Change / Protect Secrets Using Platform Features / Connected App & External Client App Security Requirements for AppExchange.

---

## PostMessage (Ch13)

### 개념

Same Origin Policy(SOP)가 다른 origin 간 데이터 접근을 차단한다. HTML5의 `window.postMessage`가 origin 간 데이터 교환을 도입했다. 개발자가 bridge 보안을 책임진다.

### Sender

syntax: `otherWindow.postMessage(message, targetOrigin);`. 안전 예제(원문):

```javascript
window.postMessage("This is a message", "https://www.salesforce.com");
```

message는 임의 object가 될 수 있다. targetOrigin이 미일치하면 브라우저가 message를 폐기한다(기밀성 보장). **`"*"` target은 insecure하므로 회피**한다(target window가 새 origin으로 navigate하면 악성 domain에 전달됨). 정확한 target origin을 항상 명시한다. `'/'` = receiving origin = sending origin.

### Receiver

어떤 origin이든 message를 전송할 수 있으므로 **allowlist domain만 수락**한다. source origin을 미확인하면 XSS/information leakage/DoS가 발생한다. incoming data 포맷을 검증하고, 받은 message는 악성으로 가정해 defensive programming을 한다. 안전 예제(원문):

```javascript
window.addEventListener("message", processMessages);
function processMessages(event) {
  var sendingOrigin = event.origin || event.originalEvent.origin;
  if (origin !== "https://www.salesforce.com")
    // ignore message or throw error
  if(isIncomingDataValid(event.data)) { // do something }
  else { // ignore message or throw error }
}
```

### General guidelines (전수)

- 전송 시: broadcast가 필요 없으면 specific destination origin을 제공.
- 수신 시: 다른 window에서 message를 기대할 때만 event listener를 설정. source origin을 allowed list와 대조. data 포맷이 기대대로인지 확인, message는 data로만 해석(code로 eval 금지). trusted origin만 reply.

(References: whatwg.org web messaging, Mozilla developer)

---

## WebSockets (Ch14)

### 개념

WebSocket = HTML5 full duplex 프로토콜, 실시간 데이터 교환. HTTP 프로토콜 위의 handshake로 연결한다.

### Countermeasures (전수)

- **CSWSH(Cross-Site WebSocket Hijacking) 방어** — WebSocket은 설계상 SOP에 제한되지 않으며 인증 메커니즘을 규정하지 않는다. ambient credential(cookie, client SSL cert, HTTP auth) 사용 시 cross origin 연결에서 브라우저가 자동 전송 → cross domain 데이터 검색·SOP bypass. **Origin header가 allowlist domain 중 하나와만 일치하도록 강제**한다(modern browser는 모두 cross origin에 Origin header를 추가). custom 인증(OAuth, SAML)을 custom HTTP request header로 전달하면 브라우저의 자동 credential 추가를 방지한다(Origin 검증이 어려울 때).
- **Always use WSS** — `ws`(insecure, 암호화 안 됨) vs `wss`(secure, TLS). **`wss://`를 항상 사용**한다. WebSocket 연결을 수행하는 코드는 HTTPS로 전달한다(sslstrip MiTM 방지). 예제(원문):
  ```javascript
  var webSocket = new WebSocket("wss://www.salesforce.com/OAuthProtectedResource");
  ```

(References: WebSocket, Heroku Websocket Security, Cross Site Web Socket Hijacking - Christian Schneider)

---

## 관련 노트
- [[Auth Namespace]]
- [[Secure Communications (TLS)]]
- [[Lightning Security 모델]]
- [[XSS 방어]]
- [[민감 데이터 저장]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
