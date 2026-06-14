# Salesforce 통합 패턴

외부 시스템과의 6가지 핵심 통합 패턴.

## 1. Request and Reply
Salesforce가 외부에 요청하고 즉시 응답 대기. 실시간 통합. 예: "재고 확인" 버튼이 외부 재고 시스템에 요청 후 결과 표시. 구현: Apex(SOAP/REST), Outbound Message.

## 2. Fire and Forget
요청 후 응답 대기 없음. 지연·실패를 나중에 처리. 예: 외부 CRM에 데이터 업데이트 전송 후 확인 없이 계속. 구현: Apex Callout, Outbound Message, Platform Events.

## 3. Batch Data Synchronization
대량 데이터를 예약·주기적 동기화. 예: 야간 ERP→Salesforce 고객 데이터 동기화. 구현: Batch Apex, Data Loader, MuleSoft·Jitterbit·Dell Boomi.

## 4. Publish-Subscribe
Salesforce가 이벤트 발행, 외부가 구독(송수신 디커플링). 이벤트 기반. 예: 주문 생성 시 외부 시스템이 배송 처리. 구현: Platform Events·CDC, webhook·API 구독.

## 5. Data Virtualization
저장 없이 외부 데이터 접근(Salesforce 환경의 일부처럼). 예: 외부 주문 상세를 import 없이 표시. 구현: Salesforce Connect(OData·커스텀 어댑터).

## 6. Smart Data Replication
관련·변경 데이터만 주기적 복제. 예: 변경된 레코드만 전송. 구현: Apex Scheduled Job, Informatica·MuleSoft, 증분 배치.

## 통합 방향

### 1. Outbound (Salesforce → 외부)
예: Outbound Message, API 호출, Platform Events, Apex Callout. 도구: Apex(REST/SOAP), Outbound Message, Platform Events, Salesforce Connect, External Services.

### 2. Inbound (외부 → Salesforce)
예: 데이터 import, 외부 API 호출. 도구: REST/SOAP API, Apex Web Services, Salesforce Connect, External Data Sources, Bulk API, CDC.

### 3. Bidirectional (양방향)
실시간·주기 양방향 동기화. 예: Salesforce-ERP 양방향 sync, 마케팅 자동화. 도구: Apex, MuleSoft, Informatica, Jitterbit·Dell Boomi, Salesforce Connect.

### 4. 미들웨어
데이터 변환·라우팅·오케스트레이션. MuleSoft, Jitterbit, Dell Boomi, Informatica.

**요약:** Outbound는 Salesforce→외부, Inbound는 외부→Salesforce, Bidirectional은 양방향. 미들웨어는 복잡·대규모 양방향 통합에 사용.
