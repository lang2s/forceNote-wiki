# Salesforce Apex 클린 코드 팁

**1. Apex 명명 규칙:** 클래스는 PascalCase(AccountTriggerHandler), 메서드·변수는 camelCase(calculateDiscount), 상수는 UPPER_CASE(MAX_RECORDS).

**2. 루프 안 SOQL/DML 회피:** 컬렉션에 모은 뒤 루프 밖에서 한 번에 처리.
```apex
List<Contact> contacts = new List<Contact>();
for (Account acc : accountList) {
    contacts.add(new Contact(LastName = 'Test', AccountId = acc.Id));
}
insert contacts;
```

**3. Apex 트리거 프레임워크 사용:** 트리거 핸들러 패턴으로 조직화(Trigger는 핸들러 메서드 호출, Handler 클래스가 beforeInsert·afterUpdate 등 로직 관리).

**4. 설명적 주석·문서화:** 메서드 목적·매개변수·반환값 포함.
```apex
/**
 * 주문의 총 할인 계산.
 * @param orderId - 주문 ID.
 * @return Decimal - 총 할인 금액.
 */
```

**5. 하드코딩 회피:** 한도·임계값 같은 구성 값에 Custom Metadata Type·Custom Settings 사용.

**6. 오류 처리:** try-catch로 예외 관리, System.debug나 커스텀 로깅으로 오류 기록.

**7. 거버너 한도 사용 제한:** Limits 클래스로 모니터링.
```apex
System.debug('Queries used: ' + Limits.getQueries());
System.debug('DML statements used: ' + Limits.getDMLStatements());
```

**8. 코드 중복 회피:** 공통 로직을 재사용 가능한 헬퍼 클래스·메서드로 추출.

**9. 비동기 처리 활용:** 장시간 작업에 @future, Queueable, Batch Apex 사용.

**10. 코드 벌크화:** 트리거·메서드에서 항상 여러 레코드 처리. 컬렉션과 SOQL for 루프 사용.

**11. 테스트 주도 개발(TDD):** assertion이 있는 의미 있는 단위 테스트, 긍정·부정·경계 케이스, 75%+ 커버리지.

**12. SOQL 쿼리 최적화:** 필요한 필드만 조회.

**13. 커스텀 예외 사용:** 고유 시나리오를 위한 특정 예외 생성. `public class CustomException extends Exception {}`

**14. 트랜잭션 경계 존중:** 트리거·배치·queueable이 거버너 한도를 초과하지 않게.

**15. 성능 모니터링·로깅:** 디버그 로그로 실행 시간 추적, 느린 프로세스 최적화.
