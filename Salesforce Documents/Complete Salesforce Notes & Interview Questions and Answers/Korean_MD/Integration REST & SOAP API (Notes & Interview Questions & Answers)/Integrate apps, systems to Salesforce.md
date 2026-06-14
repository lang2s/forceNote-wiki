# 앱·시스템을 Salesforce와 통합하는 단계

외부 앱/시스템을 Salesforce와 연결해 데이터 교환·워크플로우를 가능하게 하는 단계별 가이드.

## 1. 통합 요구사항 파악
비즈니스 사용 사례 정의, 통합 시스템 식별, 유형 결정: Real-time(API), Batch(ETL), Event-driven(webhook).

## 2. 통합 방법 선택
- **API 기반:** Salesforce REST/SOAP API로 push/pull, 시스템 API 활용.
- **미들웨어:** MuleSoft·Dell Boomi·Zapier·Informatica.
- **파일 기반:** CSV/JSON를 FTP·클라우드 스토리지(S3).
- **네이티브 커넥터:** AppExchange.

## 3. Salesforce 준비
- API 접근 활성화(Setup → Users → "API Enabled").
- Connected App 설정(App Manager → New Connected App → OAuth 활성화·스코프 선택 → Client ID·Secret 기록).
- 필요 시 커스텀 필드/오브젝트 생성.

## 4. 외부 시스템 준비
API 접근 활성화, 데이터 모델 파악(JSON·XML), webhook/트리거 설정.

## 5. 통합 구현
- **실시간:** REST/SOAP API + OAuth 2.0·API 키·세션 ID.
- **미들웨어:** 데이터 매핑·변환·워크플로우 구성.
- **배치:** ETL로 자동 export(Informatica로 일일 판매 데이터).
- **파일 기반:** Data Loader·ETL로 파일 생성·업로드.

## 6. 데이터 매핑
Salesforce 필드와 외부 시스템 필드 매칭, 형식·타입 다르면 변환.

## 7. 인증 처리
API 기반은 OAuth 2.0(Connected App으로 액세스 토큰 획득→요청에 사용). 미들웨어는 자격 증명 안전 구성.

## 8. 테스트
소량 데이터로 정확성·오류 처리·성능 확인. Developer Console·Event Monitoring 디버깅.

## 9. 모니터링·유지보수
Platform Events·Apex 예외 로깅, 미들웨어 대시보드. API·Connected App·미들웨어 정기 업데이트.

## 10. 보안
HTTPS/TLS 암호화, IP 화이트리스트, rate-limiting.

## 11. 고급(선택)
Platform Events(실시간), Flow Builder, Apex 트리거·배치.

## 예: ERP 통합
ERP가 판매 주문을 Salesforce로 전송. ① API·Connected App 구성, ② MuleSoft로 매핑·변환, ③ ERP가 주문 생성 시 API 호출, ④ Salesforce가 Account·Opportunity 업데이트.
