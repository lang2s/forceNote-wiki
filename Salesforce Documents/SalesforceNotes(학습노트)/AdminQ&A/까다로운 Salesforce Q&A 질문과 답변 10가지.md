---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [10 tricky salesforce questions Admin]
---

# 까다로운 Salesforce Q&A 질문과 답변 10가지

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF였으며 OCR로 텍스트를 추출했습니다.)

**1. Salesforce에서 Schema Builder의 역할은?**

Schema Builder는 개발자가 Salesforce 조직의 오브젝트와 관계를 보고 관리할 수 있는 그래픽 도구입니다. 데이터 모델을 시각적으로 표현하여 스키마를 더 쉽게 이해하고 수정할 수 있게 합니다.

**2. Salesforce에서 데이터 임포트와 익스포트를 어떻게 처리하나요?**

임포트는 Data Import Wizard와 Data Loader 같은 도구로 스프레드시트나 다른 소스의 데이터를 Salesforce로 가져옵니다. 익스포트는 Data Export와 Data Export Service로 Salesforce 데이터를 내보내 저장합니다. 임포트·익스포트를 처리하면 정보를 최신으로 유지하고 다양한 곳의 데이터를 쉽게 다룰 수 있습니다.

**3. Salesforce에서 레코드를 대량 업데이트하려면?**

- **Data Loader:** 업데이트된 정보가 담긴 스프레드시트를 업로드하면 도구가 일치하는 레코드에 변경을 적용합니다.
- **Reports & Dashboards:** 리포트를 만들어 레코드를 필터링한 뒤 Mass Update 옵션으로 여러 레코드를 동시에 변경합니다.
- **Custom List View:** 프로필 UI에서 Mass edit from lists, Inline editing, Enhanced lists 권한을 활성화해 목록에서 대량 편집합니다.

**4. Salesforce에서 Batch Apex 작업을 어떻게 예약하나요?**

- Database.Batchable 인터페이스를 구현하는 Batch Apex 클래스 생성
- 필요한 메서드(start, execute, finish) 구현
- 배치 클래스 인스턴스를 만들어 Apex 작업 생성
- System.schedule 메서드로 작업 예약

**5. SOQL 쿼리 성능을 어떻게 최적화하나요?**

- 쿼리를 선택적으로 만들고 인덱싱된 필드로 필터링
- 단일 쿼리에서 너무 많은 레코드 조회 피하기
- sum, count, avg 같은 집계 함수로 불필요한 필드 회피
- 관계 쿼리(조인)와 커스텀 인덱스 함수 사용
- LIMIT 절 사용
- Apex에서 쿼리 벌크화
- 중첩 쿼리 피하기
- 가능한 경우 데이터 캐싱
- 쿼리 성능 모니터링

**6. 트리거와 워크플로우 규칙의 차이는?**

둘 다 액션 자동화에 사용되지만, 트리거는 복잡하고 커스텀한 자동화에 사용되고, 워크플로우 규칙은 필드 업데이트·이메일 경고 같은 기본 액션으로 제한됩니다.

**7. Roll-up Summary 필드란 무엇이며 어떻게 사용되나요?**

관련 레코드의 값을 계산해 부모 레코드에 결과 요약을 표시합니다. 자식 레코드의 합계·개수·평균·최대·최소 같은 계산을 수행해 부모 레코드에 표시하는 데 흔히 사용됩니다.

**8. Apex에서 @future 어노테이션의 용도는?**

메서드를 비동기적으로 식별하고 실행하는 데 사용합니다. @future로 주석 처리된 메서드는 현재 트랜잭션과 독립적인 별도 스레드에서 실행되어, 즉시가 아닌 나중에 호출·실행됩니다. 주 목적은 시간이 오래 걸리거나 리소스를 많이 사용하는 작업(이메일 알림, 외부 콜아웃, 대용량 데이터 처리)을 메인 트랜잭션에서 분리해 애플리케이션을 더 효율적·반응적으로 만드는 것입니다.

**9. 외부 시스템을 Salesforce와 어떻게 통합하나요?**

API를 통해 Salesforce와 외부 앱 간 데이터 교환·실시간 통신이 가능합니다. 방법: REST/Bulk/SOAP API(주로 데이터 프로토콜), Outbound Messaging, Adapters(OData API), 서드파티 커넥터(Salesforce Connect), Webhooks.

**10. Lookup 관계와 Master-Detail 관계의 차이는?**

Lookup 관계는 두 오브젝트 간 링크를 만들어 한 오브젝트의 레코드를 다른 오브젝트에 연결합니다. Master-Detail 관계는 부모-자식 관계로, 자식 레코드가 부모로부터 동작과 권한을 상속합니다.
