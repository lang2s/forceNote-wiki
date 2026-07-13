---
tags: [integration, outbound-messaging, soap, wsdl, workflow, listener, legacy]
source: Salesforce SOAP API Developer Guide — Outbound Messaging (developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_om_outboundmessaging_understanding.htm 외 5개, API 67.0 Summer '26, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [Outbound Messaging, 아웃바운드 메시지, notifications(), SOAP 콜백, outbound message WSDL, Ack, 리스너, listener, Send Session ID, 세션 ID, 워크플로 SOAP, at-least-once, 재시도]
---

# Outbound Messaging (아웃바운드 메시지) — SOAP 콜백·WSDL·리스너

> 워크플로 규칙이 트리거되면 Salesforce가 지정 엔드포인트로 `notifications()` SOAP 메시지를 push하고, 리스너는 `<Ack>true</Ack>`를 반환해 큐에서 제거시키는 서버-투-서버 콜백 메커니즘.

---

## ⚠️ 레거시 안내

Outbound Messaging은 **워크플로 규칙(Workflow Rule)의 액션**으로 동작하는 기능이며, 워크플로 규칙 자체가 Flow로 이전 중인 레거시 스택에 속한다. **신규 통합 개발**에는 Platform Event / Change Data Capture / Pub-Sub API 등 이벤트 기반 스트리밍이 권장된다.

그러나 Outbound Messaging은 기존 통합에 광범위하게 사용되고 있어, SOAP 콜백 계약(WSDL·Ack·재시도 시맨틱)을 정확히 이해해야 유지보수·리스너 재구축이 가능하다. 이 노트는 그 **SOAP 메커니즘**에 집중한다.

> "언제 Outbound Messaging vs Platform Event / REST를 선택하는가"의 아키텍처 의사결정 비교는 [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]]으로 위임한다. 여기서는 그 비교를 재서술하지 않는다.

---

## 개요 (Understanding Outbound Messaging)

Outbound messaging은 워크플로 규칙에 의해 트리거될 때 `notifications()` 콜을 사용해 SOAP 메시지를 HTTP(S)로 지정 엔드포인트에 전송한다.

Outbound messaging을 설정한 뒤 트리거 이벤트가 발생하면, 아웃바운드 메시지 생성 시 지정한 필드를 담은 메시지가 지정 엔드포인트 URL로 전송된다. 엔드포인트 URL이 메시지를 수신하면 메시지에서 정보를 꺼내 처리할 수 있다. 이를 위해서는 **outbound messaging WSDL**을 검사해야 한다.

`notifications()` 콜의 정의를 포함한 outbound messaging용 메타데이터는 **별도 WSDL**에 들어 있다. 이 WSDL은 워크플로 규칙이 아웃바운드 메시지와 연결된 후 Salesforce UI에서 생성·제공되며, 아웃바운드 메시지에 바인딩되어 엔드포인트 서비스에 도달하는 방법과 전송되는 데이터에 대한 지시를 담는다.

> **폴링 대체:** 이전 릴리스에서 요구되던 폴링(client가 Salesforce를 주기적으로 조회) 대신, 워크플로 규칙이 존재하는 변경은 대부분 결국 워크플로를 트리거하므로, Salesforce가 이벤트를 발생시킬 때 실행 로직을 트리거하는 데 outbound messaging을 쓸 수 있다.

### 처리 흐름 (텍스트 재현)

> ⚠️ 원본 문서에는 process-flow 다이어그램이 **이미지**로 들어 있어 pdftotext/텍스트 추출로 잡히지 않는다. 아래는 본문 서술을 바탕으로 한 텍스트 재현이며, 원본 다이어그램의 박스·화살표 배치를 그대로 옮긴 것이 아니다.

```text
// 구조 예시 — 실제 원본 다이어그램 아님
[레코드 변경] → [워크플로 규칙 평가/트리거]
      → [Outbound Message 큐잉 (로컬 큐)]
      → [백그라운드 프로세스가 notifications() SOAP 메시지 전송]
      → [리스너 엔드포인트(HTTP/HTTPS) 수신 + 처리]
      → [리스너가 <Ack>true</Ack> 반환]
      → [Salesforce가 큐에서 메시지 제거]

  ※ Ack 미반환/false/엔드포인트 불가 시 → 재시도 (지수 백오프, 최대 24h)
```

---

## Notifications 동작 (Understanding Notifications)

- 단일 SOAP 메시지는 **최대 100개의 notification**을 포함할 수 있다. 각 notification은 object ID와 연관된 sObject 데이터에 대한 참조를 담는다.
- notification이 큐에 들어간 후 전송 전에 object 정보가 바뀌면, **최신 데이터만 전달되고 중간 변경은 전달되지 않는다.**
- 여러 개의 개별 콜을 일으키면, 그 콜들이 하나 이상의 SOAP 메시지로 **배치**될 수 있다.
- 메시지는 **로컬 큐**에 적재되고, 별도의 **백그라운드 프로세스**가 실제 전송을 수행한다.

메시지 신뢰성 보존을 위한 규칙:

- **엔드포인트 불가 시:** 메시지는 성공적으로 전송될 때까지, 또는 **24시간이 될 때까지** 큐에 남는다. 24시간이 지나면 큐에서 **드롭**된다.
- **전달 실패 시:** 재시도 간격이 **지수적으로 증가**하며, 재시도 간 **최대 2시간**까지 늘어난다.
- **순서 무보장:** 메시지는 큐 내 순서와 무관하게 독립적으로 재시도된다. 그 결과 **out of order(순서가 뒤바뀐 채)** 전달될 수 있다.
- **at-least-once + audit trail 불가:** outbound messaging으로는 audit trail을 구축할 수 없다. 각 메시지는 보통 1회 전달되지만, **때때로 1회보다 많이(>1)** 전달될 수 있다. 24시간 내에 전달이 안 되면 아예 전달되지 않는다. 소스 object가 notification 큐잉 후 전송 전에 바뀌면 엔드포인트는 최신 데이터만 받고 중간 변경은 못 받는다.
- **중복 체크 필수:** 메시지가 1회보다 많이 전달될 수 있으므로, 리스너 클라이언트에 전달된 notification의 **notification ID를 처리 전에 확인**해 중복 여부를 검사해야 한다.

---

## 설정 (Setting Up Outbound Messaging)

Outbound messaging을 사용하기 전 Salesforce UI에서 설정해야 한다. 단계: (a) User Profile 설정, (b) Outbound Messaging 정의, (c) Salesforce Client Certificate 다운로드, (d) 조회(Viewing), (e) 상태 추적(Tracking).

### (a) User Profile 설정 — 순환 변경 방지

Outbound messaging으로 **순환 변경(circular change)**이 발생할 수 있다. 예: 사용자가 워크플로를 트리거하는 통합을 수행 → 워크플로 액션이 account를 업데이트 → 그 업데이트가 새 워크플로를 트리거 → …

또 다른 순환 시나리오:

1. sessionId를 포함하도록 아웃바운드 메시지를 구성하고 **User to send as** 필드에 사용자를 지정. 이 사용자는 outbound messaging이 비활성화되어 있지 않다.
2. contact 레코드 변경이 지정된 사용자로부터 sessionId를 담은 아웃바운드 메시지를 리스너로 트리거.
3. 리스너가 Lightning Platform API를 호출해, 아웃바운드 메시지를 트리거했던 **같은 contact 레코드**를 업데이트.
4. 그 업데이트가 다시 아웃바운드 메시지를 트리거.
5. 리스너가 레코드를 업데이트 → 업데이트가 아웃바운드 메시지를 트리거 → … (무한 반복)

**대응:** 사용자의 Profile에서 **Send Outbound Messages**를 해제하면 그 사용자의 아웃바운드 메시지 전송 능력을 비활성화할 수 있다. 권장사항은 **아웃바운드 메시지에 응답할 단일 사용자를 지정하고, 그 사용자의 전송 능력을 비활성화**하는 것이다.

### (b) Defining Outbound Messaging

Salesforce UI에서 아웃바운드 메시지 정의 절차:

1. Setup에서 Quick Find에 `Outbound Messages` 입력 → **Workflow Actions** 아래 **Outbound Messages** 선택.
2. **New Outbound Message** 클릭.
3. 아웃바운드 메시지에 포함할 정보를 가진 object를 선택하고 Next.
4. 아웃바운드 메시지 구성:
   - **이름과 설명** 입력.
   - **엔드포인트 URL** 입력 — Salesforce가 이 엔드포인트로 SOAP 메시지를 전송한다. 보안상 지정 가능한 아웃바운드 **포트**는 다음으로 제한된다:
     - **80**: HTTP 연결만 허용.
     - **443**: HTTPS 연결만 허용.
     - **1024–66535 (inclusive)**: HTTP 또는 HTTPS 연결 허용.
   - **User to send as** 필드에 username을 지정해 메시지 전송 시 사용할 Salesforce 사용자 선택. 선택된 사용자가 엔드포인트로 전송되는 메시지의 데이터 가시성(data visibility)을 제어한다.
   - **Send Session ID** 선택 — 아웃바운드 메시지에 sessionId를 포함하려면 선택. 리스너에서 Salesforce로 다시 API 콜을 하려는 경우 포함한다. sessionId는 **이전 단계에서 정의한 사용자**를 나타내며, 워크플로를 트리거한 사용자가 아니다.
   - 포함할 **필드**를 선택하고 **Add**.
5. **Save** 후 아웃바운드 메시지 상세 페이지 검토:
   - **API Version** 필드는 아웃바운드 메시지 생성 시 현재 API 버전으로 자동 생성·설정된다. 이 API 버전은 enterprise 또는 partner WSDL을 사용해 Salesforce로 돌아가는 API 콜에 사용된다. **API Version은 Metadata API로만 수정 가능**하다.
   - **Click for WSDL**을 클릭해 이 메시지에 연결된 WSDL을 본다. WSDL은 아웃바운드 메시지에 바인딩되며, 엔드포인트 서비스 도달 방법과 전송 데이터에 대한 지시를 담는다.

> **Note:** 이 옵션들이 보이지 않으면 org에 outbound messaging이 활성화되지 않은 것이다. Salesforce에 연락해 org에 활성화해야 한다.

### (c) Salesforce Client Certificate 다운로드

애플리케이션(엔드포인트) 서버의 SSL/TLS를 **client certificate를 요구(two-way SSL/TLS)**하도록 구성해, Salesforce 서버가 당신의 서버에 대해 client 역할을 할 때 그 신원을 검증할 수 있다. 이 인증서는 Salesforce가 각 아웃바운드 메시지와 함께 인증용으로 보내는 client certificate다.

1. Setup에서 Quick Find에 `API` 입력 → **API** 선택.
2. API WSDL 페이지에서 **Manage API Client Certificate** 클릭.
3. Certificate and Key Management 페이지의 **API Client Certificate** 섹션에서 API Client Certificate 클릭.
4. Certificates 페이지에서 **Download Certificate** 클릭. `.crt` 파일이 브라우저 다운로드 위치에 저장된다. 이 인증서를 애플리케이션 서버에 import하고, client certificate를 요청하도록 서버를 구성한다. 서버는 SSL/TLS 핸드셰이크에 사용된 인증서가 다운로드한 것과 일치하는지 확인한다.

> **Note — intermediate cert chain 순서:** 애플리케이션(엔드포인트) 서버는 인증서 체인의 **중간 인증서(intermediate certificate)**를 모두 보내야 하며, 체인은 **올바른 순서**여야 한다. 올바른 순서는:
> 1. Server certificate
> 2. Server certificate에 서명한 intermediate certificate (server certificate가 root에 의해 직접 서명되지 않은 경우)
> 3. 2단계 인증서에 서명한 intermediate certificate
> 4. 나머지 모든 intermediate certificate
>
> **root certificate authority certificate는 포함하지 않는다.** root 인증서는 서버가 보내지 않는다. Salesforce는 이미 신뢰하는 인증서 목록을 보유하고 있으며, 체인의 인증서는 그 root CA 인증서 중 하나로 서명되어 있어야 한다.

### (d) Viewing Outbound Messages

Setup에서 Quick Find에 `Outbound Messages` 입력 → **Outbound Messages** 선택. 이 페이지에서:

- **New Outbound Message** — 새 아웃바운드 메시지 정의.
- **View Message Delivery Status** — 아웃바운드 메시지 상태 추적.
- 기존 아웃바운드 메시지 선택 → 상세 보기, 또는 그것을 사용하는 워크플로 규칙·승인 프로세스 보기.
- **Edit** — 기존 아웃바운드 메시지 변경.
- **Del** — 아웃바운드 메시지 삭제.

### (e) Tracking Outbound Message Status

Setup → Quick Find `Outbound Messages` → **Outbound Messages** 선택 → **View Message Delivery Status** 클릭. 이 페이지에서 가능한 작업:

- 아웃바운드 메시지 상태 보기(시도된 총 전달 횟수 포함).
- 워크플로/승인 프로세스 액션 ID를 클릭해 메시지를 트리거한 액션 보기.
- **Retry** 클릭 — Next Attempt 날짜를 지금으로 변경. 메시지 전달이 즉시 재시도된다.
- **Del** 클릭 — 아웃바운드 메시지를 큐에서 영구 제거.

---

## 보안 고려사항 (Considerations for Security)

제3자가 Salesforce인 척 엔드포인트로 메시지를 보낼 수 없도록 다음을 보장한다:

- **Salesforce IP 범위로 제한:** client 애플리케이션의 리스너가 **Salesforce IP 범위**에서 온 요청만 수락하도록 잠근다. 이는 메시지가 Salesforce에서 왔음은 보장하지만, 다른 고객이 당신의 엔드포인트를 가리켜 메시지를 보내지 않는다는 것까지 보장하지는 않는다. 최신 Salesforce IP 범위 목록은 `https://help.salesforce.com/articleView?id=000321501&type=1&mode=1` 참조.
- **SSL/TLS 사용:** SSL/TLS는 인터넷을 통해 데이터가 전송되는 동안 기밀성을 제공한다. 없으면 악의적 제3자가 데이터를 도청할 수 있다. 특히 privacy 요구사항이 있는 데이터나 SessionId를 메시지와 함께 전달할 때 중요하다. 또한 Salesforce는 연결 시 제시된 인증서를 인증하고, 유효한 Certificate Authority에서 발급됐는지 확인하며, 인증서의 도메인이 연결 대상 도메인과 일치하는지 검사한다. 이 검증으로 잘못된 엔드포인트와의 통신을 막는다.
- **Send Session ID는 HTTPS 필수 (Spring '19 규칙):** Send Session ID를 선택하면 세션 ID의 안전한 전송을 위해 엔드포인트 URL에 **HTTPS만 지원**된다. Spring '19 이전에 이 옵션은 있으나 HTTPS 엔드포인트가 없이 만들어진 managed/unmanaged 패키지는 여전히 구독자가 설치할 수 있다. **Spring '19부터는 insecure outbound message 옵션으로 패키지를 만들 수 없다.**
- **SessionId 스코프:** 아웃바운드 메시지에 포함된 SessionId는 **API 요청에 한정**되며 UI 요청에는 적용되지 않는다.
- **Salesforce client cert 검증:** 애플리케이션(엔드포인트) 서버 SSL/TLS 구성이 허용하면, Salesforce가 당신의 서버에 client 역할을 할 때 **Salesforce client certificate**로 그 신원을 검증한다. (다운로드는 위 (c) 참조.)
- **organization Id 검증:** 각 메시지에 **organization Id**가 포함된다. client 애플리케이션에서 메시지에 당신의 organization Id가 담겨 있는지 검증한다.

---

## Outbound Messaging WSDL (Understanding the Outbound Messaging WSDL)

WSDL은 outbound messaging을 특정 object의 특정 event에 대해 설정할 때 선택한 사항에 따라 달라질 수 있다. 아래는 관련 섹션이다.

### `notifications()` element

`notifications()` 콜은 특정 object(들)에 대해 지정된 필드와 값을 담은 아웃바운드 메시지를 생성해 지정 엔드포인트 URL로 전송한다:

```xml
<schema elementFormDefault="qualified" xmlns="http://www.w3.org/2001/XMLSchema"
 targetNamespace="http://soap.sforce.com/2005/09/outbound">
 <import namespace="urn:enterprise.soap.sforce.com" />
 <import namespace="urn:sobject.enterprise.soap.sforce.com" />

 <element name="notifications">
 <complexType>
 <sequence>
 <element name="OrganizationId" type="ent:ID" />
 <element name="ActionId" type="ent:ID" />
 <element name="SessionId" type="xsd:string" nillable="true" />
 <element name="EnterpriseUrl" type="xsd:string" />
 <element name="PartnerUrl" type="xsd:string" />
 <element name="Notification" maxOccurs="100"
 type="tns:OpportunityNotification" />
 </sequence>
 </complexType>
 </element>
 </schema>
```

`notifications` 메서드 정의에 명명된 element:

| Name | Type | Description |
|---|---|---|
| OrganizationId | ID | 메시지를 보내는 organization의 ID. |
| ActionId | string | 메시지를 트리거하는 워크플로 규칙(action). |
| SessionId | string | 선택. 아웃바운드 메시지에 응답하는 엔드포인트 URL client가 사용할 session ID. 수신 코드가 Salesforce로 다시 콜을 하는 데 사용. |
| EnterpriseURL | string | enterprise WSDL을 사용해 Salesforce로 API 콜을 하는 데 사용할 URL. |
| PartnerURL | string | partner WSDL을 사용해 Salesforce로 API 콜을 하는 데 사용할 URL. |
| Notification | Notification | 다음 섹션에서 정의됨. object 데이터타입과 그 Id를 담음 (예: OpportunityNotification 또는 ContactNotification). |

### `OpportunityNotification` complexType (예)

Notification 데이터타입은 WSDL에 정의된다. 아래 예는 `notifications()` 콜 정의의 Notification 항목을 기반으로 한 opportunity용 Notification 정의다:

```xml
<complexType name="OpportunityNotification">
 <sequence>
 <element name="Id" type="ent:ID" />
 <element name="sObject" type="ens:Opportunity" />
 </sequence>
 </complexType>
```

각 object element(예에서는 opportunities)는 아웃바운드 메시지 생성 시 선택한 필드의 subset을 담는다. 각 메시지 Notification은 object ID도 갖는다. **이미 처리한 notification의 재전달(redelivery) 시도를 추적하는 데 object ID를 사용**한다.

### `notificationsResponse` (Ack 스키마)

이 element는 Salesforce에 **acknowledgment(ack) 응답**을 보내기 위한 스키마다:

```xml
<element name="notificationsResponse">
 <complexType>
 <sequence>
 <element name="Ack" type="xsd:boolean" />
 </sequence>
 </complexType>
 </element> //This section is the last in the types definition section.
```

메시지에 notification이 둘 이상이면 **메시지 내 모든 notification을 한 번에 acknowledge**한다.

---

## 리스너 구축 (Building a Listener)

아웃바운드 메시지를 정의하고 엔드포인트를 구성한 뒤, WSDL을 다운로드해 리스너를 만든다:

- **Click for WSDL**을 우클릭 → **Save As**로 적절한 파일명으로 로컬 디렉터리에 저장. 예: lead 관련 아웃바운드 메시지면 `leads.wsdl`.
- enterprise/partner WSDL이 **client가 Salesforce로 보내는** 메시지를 기술하는 것과 달리, 이 WSDL은 **Salesforce가 당신의 client 애플리케이션으로 보내는** 메시지를 정의한다.
- 대부분의 웹 서비스 툴은 server-side stub 옵션을 제공한다. 예를 들어 .NET 2.0:
  - `wsdl.exe /serverInterface leads.wsdl`을 .NET 2.0으로 실행. 이 명령은 notification 인터페이스를 정의하는 `NotificationServiceInterfaces.cs`를 생성한다.
  - `NotificationServiceInterfaces.cs`를 구현하는 class를 만든다.
- 인터페이스를 구현하는 class를 작성해 리스너를 구현한다. 한 가지 간단한 방법은 인터페이스를 먼저 DLL로 컴파일하는 것이다 (ASP.NET에서 DLL은 bin 디렉터리에 있어야 한다):

```bat
mkdir bin
csc /t:library /out:bin\nsi.dll NotificationServiceInterfaces.cs
```

이제 이 인터페이스를 구현하는 ASMX 기반 웹 서비스를 작성한다. 예: `MyNotificationListener.asmx`:

```csharp
<%@WebService class="MyNotificationListener" language="C#"%>
class MyNotificationListener : INotificationBinding
{ public notificationsResponse notifications(notifications n)
 {
 notificationsResponse r = new notificationsResponse();
 r.Ack = true;
 return r;
 }
}
```

이 예는 단순 구현이며, 실제 구현은 더 복잡하다.

- IIS에서 `MyNotificationListener.asmx`가 있는 디렉터리에 새 virtual directory를 만들어 서비스를 배포한다.
- 서비스 페이지를 브라우저로 열어 배포를 테스트할 수 있다. 예: virtual directory를 `salesforce`로 만들면 `http://localhost/salesforce/MyNotificationListener.asmx`로 접속.

다른 웹 서비스 툴의 절차도 유사하다.

### ACK 계약 (핵심)

**리스너는 SOAP 응답으로 `<Ack>true</Ack>`(위 C# 예의 `r.Ack = true`)를 반환해야 Salesforce가 메시지를 큐에서 제거한다.** Ack를 반환하지 않거나 `false`를 반환하면, Salesforce는 그 메시지를 **최대 24시간까지 재시도**(지수 백오프, 최대 2시간 간격)한다.

### 리스너 요건

- **공개 인터넷(public Internet)**에서 도달 가능해야 한다.
- 보안상 지정 가능한 아웃바운드 포트는 다음으로 제한:
  - **80**: HTTP 연결만.
  - **443**: HTTPS 연결만.
  - **1024–66535 (inclusive)**: HTTP 또는 HTTPS.
- 유효하려면 인증서의 **common name(CN)이 엔드포인트 서버의 도메인 이름과 일치**해야 하며, 인증서는 **Java 2 Platform, Standard Edition (J2SE) 5.0 (JDK 1.5)이 신뢰하는 Certificate Authority**가 발급해야 한다.
- 인증서가 **만료되면 메시지 전달이 실패**한다.

> **Warning — 무한 루프 방지:** 아웃바운드 메시지가 변경을 트리거하고 그 변경이 또 아웃바운드 메시지를 트리거하는 무한 루프를 피하려면, object를 업데이트하는 사용자가 **"Send Outbound Messages" 권한을 갖지 않도록** 한다.

---

## 관련 노트
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — 언제 Outbound Messaging vs Platform Event/REST를 선택하는가(아키텍처 비교·재시도·멱등성)
- [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]] — Outbound Message는 워크플로 규칙 액션(레거시, Flow 이전)
- [[Approval Process (승인 프로세스)]] — Outbound Message를 승인 프로세스 액션으로 사용
- [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]] — 반대 방향의 SOAP 소비(Apex가 외부 SOAP 호출) 짝
