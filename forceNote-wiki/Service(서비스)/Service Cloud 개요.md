---
tags: [service-cloud, agentforce-service, overview, case-management]
source: help.salesforce.com (Salesforce Help — Agentforce Service; What Is Agentforce Service?; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.service_cloud_def.htm&type=5
created: 2026-07-03
aliases: [Service Cloud, Agentforce Service, 서비스 클라우드, Case Management, 케이스 관리]
---

# Service Cloud 개요 (Agentforce Service)

> 고객 서비스·지원을 다루는 Salesforce 제품군. **현재 명칭은 Agentforce Service**(구 Service Cloud). 멀티채널로 들어온 고객 이슈를 **case**로 관리하고 라우팅·SLA·에이전트 워크스페이스로 해결한다. 이 노트는 Service Cloud 기능 맵의 허브다.

---

## 정의 — "Service"는 Agentforce Service를 뜻한다

Salesforce에서 "service"는 **Agentforce Service**(고객 서비스를 위한 강력한 플랫폼)를 가리킨다. Agentforce Service로 고객에게 **즉각적이고 개인화된 서비스**를 제공한다.

> [!note] 브랜딩 변경
> **"Service Cloud is now Agentforce Service."** 제품이 리브랜딩되었으므로 문서·UI에서 여전히 **Service Cloud**라는 표기를 볼 수 있으나, 동일한 제품을 가리킨다.

동작 방식은 두 축으로 요약된다.

- 고객이 **여러 채널**(이메일·웹·채팅·메시징 등)로 소통할 수 있게 한다.
- 고객 이슈는 **case의 lifecycle**을 따라 처리된다: 이슈 발생 → **case** 생성 → 해결.

---

## 케이스 생명주기 (흐름)

```
// 구조 예시 — Service Cloud(Agentforce Service) 흐름(실제 원본 다이어그램 아님)
고객(멀티채널: Email/Web/Chat/Messaging) → Case 생성
   라우팅: Queue · Assignment/Escalation Rules · Omni-Channel
   에이전트: Service Console + Macros + Knowledge + Open CTI(전화)
   SLA: Entitlements & Milestones(첫 응답·해결 시간)
   현장 방문 필요 시 → Field Service
```

---

## 기능 맵 (케이스 관리 중심)

Service Cloud의 기능은 case를 중심으로 조직된다.

### Cases

고객의 **질문·피드백·이슈**를 담는 핵심 오브젝트. 고객 서비스의 모든 흐름이 case를 중심으로 돈다.

### 서비스 채널

고객이 이슈를 제기하는 유입 경로.

- **Email-to-Case** — 이메일을 case로 변환.
- **Web-to-Case** — 웹 폼 제출을 case로 변환.
- **Chat** — 실시간 채팅.
- **Messaging** — 메시징 채널.

### 라우팅

들어온 case를 적절한 담당자/큐로 배분.

- **Queues** — case를 담아두는 대기열.
- **Case Assignment / Escalation Rules** — 배정 규칙 및 에스컬레이션 규칙.
- **Omni-Channel** — 실시간 라우팅 엔진.

### 지식 (Knowledge)

문서·해결책을 관리하는 **Knowledge**. 에이전트와 고객이 해결책을 찾도록 지원.

### SLA

지원 수준·시간 기준을 관리.

- **Entitlements & Milestones** — 지원 수준(entitlement)과 시간 기준 마일스톤(첫 응답·해결 시간 등).

### 에이전트 도구

에이전트가 case를 처리하는 작업 환경.

- **Service Console** — 에이전트 워크스페이스.
- **Macros** — 반복 작업 자동화.
- **Open CTI** — 전화 통합(컴퓨터-전화 통합 인터페이스).

### 현장 (Field Service)

현장 방문이 필요한 서비스 업무를 관리하는 **Field Service**.

---

## 사용 제한 안내

Agentforce Service의 사용 조건·제한(usage restriction)은 공식 문서를 참조한다. 이 노트는 기능 개요이며 라이선스·사용량 제한의 정본이 아니다.

---

## Service Cloud 시리즈 노트

이 허브가 묶는 Service Cloud 기능 노트 맵.

**케이스 코어**
- [[Cases (케이스)]] — 고객 이슈를 담는 핵심 오브젝트
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — 배정·에스컬레이션 규칙
- [[Queues (큐)]] — case를 담아두는 대기열

**채널·라우팅**
- [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]] — 이메일·웹 폼을 case로 변환
- [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] — 실시간 Chat (기존 자산)
- [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] — 실시간 라우팅 엔진 (기존 자산)

**SLA·에이전트 도구**
- [[Entitlements & Milestones (엔타이틀먼트·마일스톤)]] — 지원 수준·시간 기준 마일스톤
- [[Service Console (서비스 콘솔)]] — 에이전트 워크스페이스
- [[Macros (매크로)]] — 반복 작업 자동화
- [[Open CTI & Telephony (전화 통합)]] — 전화 통합(softphone)

**지식·현장·자동화 (기존 자산)**
- [[Lightning Knowledge 개요 — 계획·비교·한계]] — Knowledge(지식 관리)
- [[Field Service 개요와 데이터 모델]] — 현장 서비스
- [[Lightning Flow for Service (Actions & Recommendations)]] — 서비스용 Flow 액션·추천

---

## 관련 노트
- [[Service Cloud Objects]] — Service Cloud 표준 오브젝트(Case 등) 레퍼런스
