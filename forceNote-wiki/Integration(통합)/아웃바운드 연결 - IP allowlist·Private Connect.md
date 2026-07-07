---
tags: [integration, outbound, callout, firewall, ip-allowlist, private-connect, hyperforce, aws-privatelink, security, decision]
source: help.salesforce.com — IP Addresses and Domains to Allow (000384438, Tier 2); help.salesforce.com — Preferred Alternatives to IP Allowlisting on Hyperforce (000394078, Tier 2); help.salesforce.com — Secure Cross-Cloud Integrations with Private Connect (xcloud.private_connect_overview, Tier 2); help.salesforce.com — Considerations for Private Connect with AWS (xcloud.private_connect_considerations, Tier 2); developer.salesforce.com — Using Private Connect to Securely Connect Salesforce and AWS (Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=xcloud.private_connect_overview.htm&type=5
created: 2026-07-07
aliases: [아웃바운드 연결 허용, 아웃바운드 IP allowlist, Salesforce outbound IP ranges, ip-ranges.json, 콜아웃 방화벽 허용, Private Connect, OutboundNetworkConnection, InboundNetworkConnection, AWS PrivateLink, Hyperforce private connectivity, 외부 방화벽 콜아웃 허용]
---

# 아웃바운드 연결 — IP allowlist·Private Connect

> Salesforce가 외부(ERP·API) 시스템으로 나가는 **아웃바운드 콜아웃**을 그쪽 방화벽이 허용하게 하는 두 방식: **① 게시된 Salesforce 아웃바운드 IP 범위 allowlist**(공유·변동 IP, 저비용·저신뢰) vs **② Private Connect**(Hyperforce·AWS PrivateLink 기반 사설 연결, 고신뢰·유료·리전 종속). 인증(Named Credential)과 직교하는 **네트워크 도달성(reachability)** 결정.

> [!note] 근거: Salesforce Help **IP Addresses and Domains to Allow**·**Preferred Alternatives to IP Allowlisting on Hyperforce**·**Secure Cross-Cloud Integrations with Private Connect**·**Considerations for Private Connect with AWS**. 인증(자격증명)은 [[Named Credential]]이 담당하고, 이 노트는 **패킷이 외부 방화벽을 통과하느냐**의 계층을 다룬다.

---

## 0. 무엇을 푸는 문제인가 — 인증 ≠ 도달성

외부 시스템 연동에는 **두 개의 독립 계층**이 있다.

- **인증(누구인가):** OAuth·mTLS·API Key — [[Named Credential]]이 관리.
- **도달성(패킷이 방화벽을 통과하는가):** 외부 시스템이 인터넷에 열려 있지 않고 IP allowlist 또는 사설망 뒤에 있으면, Salesforce의 콜아웃이 **그 방화벽을 통과**해야 한다. 이 노트의 주제.

ERP처럼 인터넷에 완전히 노출하고 싶지 않은 백엔드는 "Salesforce에서 오는 트래픽만" 통과시키려 한다. 방법은 **아웃바운드 IP allowlist**(어디서 오는가로 필터) 또는 **Private Connect**(사설 네트워크 경로 자체를 만듦) 두 가지다.

---

## 1. 방식 ① — 게시된 아웃바운드 IP 범위 allowlist

Salesforce는 Hyperforce의 IP 범위를 **머신-리더블 JSON**으로 게시한다. 외부 방화벽에서 이 IP 범위를 허용(allowlist)하면 Salesforce 콜아웃이 통과한다.

```text
// 실제 스키마 (2026-07 fetch 확인) — https://ip-ranges.salesforce.com/ip-ranges.json
GET https://ip-ranges.salesforce.com/ip-ranges.json

{
  "syncToken":  "...",
  "createDate": "...",
  "prefixes": [
    { "region": "us-east-1", "provider": "aws", "ip_prefix": ["155.226.144.0/22"] },
    ...
  ],
  "ipv6_prefixes": [
    { "region": "us-west-2", "provider": "aws", "ipv6_prefix": ["2a03:5d67:ffd0::/45"] },
    ...
  ]
}
```

- **`direction`(inbound/outbound) 필드는 없다.** 각 항목은 `region`·`provider`·`ip_prefix`(IPv4)만 담고, IPv6는 별도 `ipv6_prefixes` 배열에 `ipv6_prefix`로 들어 있다. 파일이 방향으로 나뉘지 않으므로, 어느 리전 인스턴스에서 콜아웃이 나올지 특정할 수 없다 → 외부 방화벽에서는 **리전·provider별 Hyperforce IP 전 범위를 allowlist**한다.
- Hyperforce 조직은 **모든 공식 Hyperforce IP 범위**를 허용해야 한다(리전·provider별로 다름). 게시본이 정본이며, 이 노트에 구체 CIDR을 적지 않는다(변동성 때문).

### allowlist의 한계 (Salesforce가 명시적으로 경고)

| 한계 | 내용 |
|---|---|
| **공유 IP** | 이 IP들은 **여러 고객·trial org가 함께 사용**한다. 특정 org 전용이 아니다 — "이 IP에서 왔으니 우리 Salesforce다"라는 보장이 없다. |
| **출처만 검증, 진위 아님** | IP allowlist는 요청의 **출처(source)** 만 확인하고 **진위(authenticity)** 는 확인하지 못한다. 인증 계층([[Named Credential]] mTLS·토큰)을 대체하지 못한다. |
| **동적 변동** | 클라우드 특성상 IP가 추가·변경된다. 바뀔 때마다 방화벽 allowlist를 갱신하지 않으면 **연결이 끊긴다**. 유지보수 부담이 크다. |
| **선호되지 않음** | Salesforce는 Hyperforce에서 IP allowlist 대신 **mTLS**(진위까지 검증) 또는 **도메인 기반 허용**을 권장한다. IP allowlist는 규제 준수 등 어쩔 수 없을 때의 최후 수단으로 본다. |

> [!tip] 아웃바운드 IP allowlist를 쓰더라도, 진위는 **[[Named Credential]]의 아웃바운드 mTLS(클라이언트 인증서)** 로 보강하라. IP는 "어디서 왔나"만, mTLS는 "정말 우리 Salesforce인가"를 증명한다.

---

## 2. 방식 ② — Private Connect (Hyperforce · AWS PrivateLink)

Private Connect는 Salesforce 조직과 고객의 **AWS VPC 사이에 완전 관리형 사설 네트워크 경로**를 만든다. 트래픽이 **공용 인터넷을 전혀 타지 않고** Salesforce의 Transit VPC ↔ 고객 VPC를 **AWS PrivateLink**로 직접 연결한다. Hyperforce(AWS 기반)에서 제공된다.

### 인바운드 vs 아웃바운드 (양방향)

| 방향 | 트래픽 시작점 | 쓰는 기능 | 메타데이터 타입 |
|---|---|---|---|
| **Outbound** | Salesforce → 고객 VPC | **Apex 콜아웃·External Services·Flow Action·External Objects** | `OutboundNetworkConnection` |
| **Inbound** | 고객 VPC → Salesforce | 표준 API(REST·Bulk 등)로 VPC 내 잡·서비스가 Salesforce 접근 | `InboundNetworkConnection` |

이 노트의 주제인 "아웃바운드 콜아웃 통과"는 **Outbound Connection + `OutboundNetworkConnection`** 이다.

### 아웃바운드 흐름 — Named Credential에 연결

```text
// 구조 예시 — 실제 설정 화면·필드 배치 아님
1. AWS 쪽에서 VPC Endpoint Service(PrivateLink) 준비 → 서비스 이름 확보
2. Setup에서 Outbound Connection 생성 (OutboundNetworkConnection 메타데이터)
   · 대상 AWS 리전 + VPC Endpoint Service 지정
   · Salesforce가 Transit VPC ↔ 고객 VPC 간 PrivateLink 프로비저닝
3. Named Credential 편집 → OutboundNetworkConnection 필드에 위 연결을 참조
4. Apex는 그대로 callout:{NC}만 사용
   → 이 NC를 쓰는 모든 콜아웃이 사설 연결로 라우팅됨 (인터넷 미경유)
```

- 핵심 통합점: **Named Credential의 `OutboundNetworkConnection` 필드**. 엔드포인트 URL은 Named Credential이, 사설 경로는 이 필드가 지정한다. Apex 코드는 변경 없이 `callout:{NC}` 그대로다.
- **멀티테넌트 격리:** 특정 org가 만든 PrivateLink만 그 org의 Named Credential에 연결된다. IP allowlist의 "공유 IP" 문제가 없다.
- 암호화: Transit VPC ↔ 고객 VPC 사이는 AES-GCM IPSec 터널(다중 AZ·이중화)로 보호된다.

### 지원·미지원 (Considerations)

| 지원 | 미지원 |
|---|---|
| Hyperforce 및 1st-party 데이터센터 org | Developer / Developer Pro 샌드박스(승격용 비활성 placeholder만 생성 가능) |
| Full·Partial Copy 샌드박스 | Tableau · Marketing Cloud · Commerce Cloud |
| CRM Analytics · Data Cloud | MuleSoft CloudHub(고객 VPC 내 on-prem MuleSoft만 가능) |
| PrivateLink 지원 AWS 서비스(S3·Lambda·Redshift·Athena 등)·Amazon AppFlow | 사용자 세션(API 통합만 — 브라우저 세션 라우팅 불가) |

- **리전:** Private Connect는 전 세계 12개+ AWS 리전에서 제공되며(라이선스는 **리전당 1개**, 인바운드·아웃바운드 공용), **같은 리전 연결이 권장·최적**(최저 지연·비용)이다. 대상이 타 리전이면 **고객 AWS 측 peering**으로 도달할 수 있으나, 고급 구성이라 AWS 지원 권장(Considerations).
- **처리량 한도:** 아웃바운드 약 **56.48 GB/시간**(하드 한도), 인바운드는 계약상 동일 수치(기술적 하드 스톱은 아님).
- **비용:** Private Connect는 유료 애드온이다(구체 가격은 영업/계약 기준).

---

## 3. 결정표 — IP allowlist vs Private Connect

| 축 | IP allowlist(방식 ①) | Private Connect(방식 ②) |
|---|---|---|
| **보안 모델** | 공유 IP·출처만 검증(진위 아님) | 전용 사설 경로·인터넷 미경유·org별 격리 |
| **진위 보증** | 없음 — mTLS/토큰으로 별도 보강 필요 | 경로 자체가 사설(멀티테넌트 격리) |
| **유지보수** | IP 변동 시 방화벽 갱신 필요(연결 끊김 위험) | 관리형 — IP 추적 불필요 |
| **비용** | 무료(게시 IP 사용) | 유료 애드온 |
| **인프라 전제** | 외부 방화벽만 있으면 됨 | 고객이 **AWS VPC** 보유 + Hyperforce org |
| **리전** | 제약 없음(공용 인터넷) | **같은 리전 권장·최적**(타 리전은 고객 AWS 측 peering으로 도달 가능) |
| **규제/컴플라이언스** | 데이터가 공용 인터넷 경유(허용됨을 전제) | 인터넷 미노출 요구(HIPAA·금융 등)에 부합 |
| **대상 시스템** | 인터넷에 도달 가능한 엔드포인트 | AWS PrivateLink로 노출 가능한 엔드포인트 |
| **Salesforce 권장도** | 최후 수단(대신 mTLS·도메인 허용 권장) | 사설 연결이 필요한 규제·보안 요건에 권장 |

### 언제 무엇을 고르나

- **IP allowlist가 맞을 때:** 외부 시스템이 AWS VPC가 아니거나, 사설 연결 비용을 감당할 수 없고, 방화벽에서 출처 필터만으로 충분한 저위험 통합. 단 **진위는 mTLS로 반드시 보강**.
- **Private Connect가 맞을 때:** 트래픽이 **공용 인터넷을 절대 타면 안 되는** 규제(금융·의료·정부), 대상이 AWS(S3·Lambda·on-prem MuleSoft in VPC 등), 대상 리전에 Hyperforce가 제공됨(같은 리전 권장, 타 리전은 고객 AWS 측 peering), 공유 IP의 유지보수·신뢰 문제를 없애고 싶을 때.
- **둘 다 아님 — 대안:** Salesforce는 Hyperforce에서 IP allowlist보다 **mTLS**(진위까지) 또는 **도메인 기반 허용**을 먼저 권한다. 사설망이 꼭 필요하지 않으면 이 경로가 IP allowlist보다 견고하다.

> 이들은 **네트워크 도달성** 결정일 뿐, 인증·재시도·멱등성 같은 신뢰성 설계는 별개다. 위상(직결 vs 미들웨어)·재시도·멱등성은 [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]]에서 결정한다.

---

## 관련 노트
- [[Named Credential]] — 아웃바운드 인증(OAuth·mTLS)과 `OutboundNetworkConnection` 필드로 Private Connect 경로 지정
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — 도달성 확보 후 위상·신뢰성(재시도·멱등) 결정
- [[Queueable + Callout 패턴]] — 이 경로 위에서 실행되는 비동기 아웃바운드 콜아웃
- [[통합 MOC]] — Outbound/Inbound·동기/비동기 축 인덱스
