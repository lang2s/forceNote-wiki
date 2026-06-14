# Apex의 Null Pointer Exception (NPE)

> (원본은 이미지 PDF로 OCR 추출했습니다.)

NPE는 초기화되지 않아 null인 오브젝트·변수·컬렉션에 접근·조작하려 할 때 발생합니다. Apex에서 null은 오브젝트가 메모리나 데이터를 참조하지 않음을 의미합니다.

## NPE 발생 원인

**1. 초기화되지 않은 변수 사용:** 선언만 하고 값을 할당하지 않은 변수의 속성·메서드 접근. 예: SOQL 결과 확인 없이 레코드 필드 접근.
```apex
Account acc; // 선언만 됨
System.debug(acc.Name); // NPE
```

**2. Null 컬렉션 작업:** 초기화되지 않은 컬렉션에 .size(), .put() 등 호출 시. 예: 트리거에서 초기화되지 않은 리스트를 for 루프에 사용.

**3. Null SObject 필드 접근:** 명시적으로 채워지지 않았거나 쿼리되지 않은 필드는 null. 검증 없이 SOQL로 가져온 필드 사용 시.

**4. 할당 없이 변수 역참조:** String, Integer, Decimal 등도 초기화 없이 사용하면 NPE.

## NPE 방지 방법

**1. 변수·오브젝트 초기화:** 선언 시 항상 초기화. 예: 트리거에서 컬렉션 초기화 `Map<Id, List<Contact>> accountContacts = new Map<Id, List<Contact>>();`

**2. Null 체크:** 필드·메서드 접근 전 검증. 예: 트리거에서 Trigger.oldMap/newMap null 확인.

**3. Safe Navigation Operator (?.):** 오브젝트가 null이면 단락(short-circuit)하여 NPE 방지. 예: `System.debug(opportunity?.Account?.Name);`

**4. 기본값 설정:** 변수에 기본값 할당. 예: before insert 트리거에서 `if (newLead.Status == null) { newLead.Status = 'New'; }`

**5. Try-Catch로 예외 처리:** NPE를 잡아 우아하게 처리.
```apex
try {
    System.debug(acc.Name);
} catch (NullPointerException e) {
    System.debug('Caught an NPE: ' + e.getMessage());
}
```

## Salesforce 시나리오

**트리거:** LeadSource 변경에 따라 체크박스 설정 시 Trigger.oldMap이 null인지 확인.
**API 통합:** 응답이 null이 아닌지 검증 후 처리. `if (response != null && response.getStatusCode() == 200)`
**LWC 컨트롤러:** Apex 메서드에서 레코드 반환 전 null 확인.

## 핵심 정리

NPE는 흔하지만 예방 가능합니다. 항상 변수를 초기화하고, null을 확인하고, safe navigation operator 같은 도구를 사용해 null-safe하고 유지보수 가능한 코드를 작성하세요.
