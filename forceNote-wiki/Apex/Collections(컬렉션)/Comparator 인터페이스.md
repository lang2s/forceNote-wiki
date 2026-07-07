---
tags: [apex, collection, sort, comparator, pattern]
source: apex-recipes/CollectionUtils.cls
created: 2026-05-17
aliases: [Comparator, 정렬, 커스텀 소트]
---

# Comparator 인터페이스

> `Comparator<T>` 구현으로 `List.sort(comparator)`에 커스텀 정렬 로직을 주입. API 59.0 (Winter '24)부터 지원. `Comparable`을 구현할 수 없는 외부 타입 정렬에 유용.

---

## 기본 구현

```apex
// 문자열 대소문자 무시 정렬
public class CaseInsensitiveComparator implements Comparator<String> {
    public Integer compare(String a, String b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
    }
}

List<String> names = new List<String>{ 'Banana', 'apple', 'Cherry' };
names.sort(new CaseInsensitiveComparator());
// 결과: ['apple', 'Banana', 'Cherry']
```

---

## compare() 반환값 규칙

| 반환값 | 의미 |
|---|---|
| 음수 (`< 0`) | a가 b보다 앞에 와야 함 |
| `0` | 같음 (순서 무관) |
| 양수 (`> 0`) | a가 b보다 뒤에 와야 함 |

---

## SObject 복잡한 정렬

```apex
// Account를 Revenue 내림차순, 같으면 Name 오름차순
public class AccountComparator implements Comparator<Account> {
    public Integer compare(Account a, Account b) {
        // 내림차순: b - a
        if (a.AnnualRevenue != b.AnnualRevenue) {
            Decimal diff = (b.AnnualRevenue ?? 0) - (a.AnnualRevenue ?? 0);
            return diff > 0 ? 1 : -1;
        }
        // 이름 오름차순 (null 안전)
        String nameA = a.Name ?? '';
        String nameB = b.Name ?? '';
        return nameA.compareTo(nameB);
    }
}

List<Account> accounts = [SELECT Id, Name, AnnualRevenue FROM Account];
accounts.sort(new AccountComparator());
```

---

## 람다 스타일 (익명 클래스 패턴)

```apex
// 재사용이 필요 없을 때 — 인라인 구현
List<Opportunity> opps = [SELECT Id, Amount FROM Opportunity];
opps.sort(new Comparator<Opportunity>() {
    public Integer compare(Opportunity a, Opportunity b) {
        Decimal diff = (a.Amount ?? 0) - (b.Amount ?? 0);
        return diff > 0 ? 1 : diff < 0 ? -1 : 0;
    }
});
```

---

## Comparable 인터페이스 직접 구현 (래퍼 클래스 관용구)

`Comparator`가 정렬 로직을 **별도 클래스**에 두는 반면, `Comparable`은 정렬 대상 클래스가 **자기 자신의 `compareTo`**를 구현해 기본 정렬 순서를 내장한다. 이때 인수 없는 `List.sort()`가 각 원소의 `compareTo`를 호출한다.

`Comparable`의 유일한 메서드는 `Integer compareTo(Object compareTo)`이며, 반환값 규칙은 `compare()`와 동일하다 — 음수면 자신이 앞, `0`이면 같음, 양수면 자신이 뒤.

> **SObject는 `Comparable`을 직접 구현할 수 없다** (Salesforce 표준/커스텀 오브젝트는 상속·인터페이스 구현 불가). 그래서 정렬하려는 SObject를 **필드로 감싼 래퍼 클래스**를 만들고, 그 래퍼가 `Comparable`을 구현하는 관용구를 쓴다.

```apex
// SObject(Opportunity)를 감싸 Comparable을 구현하는 래퍼 클래스
public class OpportunityWrapper implements Comparable {
    public Opportunity oppy;

    // Constructor — null 래핑 방지
    public OpportunityWrapper(Opportunity op) {
        if (op == null) {
            Exception ex = new NullPointerException();
            ex.setMessage('Opportunity argument cannot be null');
            throw ex;
        }
        oppy = op;
    }

    // Amount 기준 비교 — 반환값 0은 동등을 의미
    public Integer compareTo(Object compareTo) {
        // 인수를 OpportunityWrapper로 캐스팅
        OpportunityWrapper compareToOppy = (OpportunityWrapper)compareTo;
        Integer returnValue = 0;
        if ((oppy.Amount == null) && (compareToOppy.oppy.Amount == null)) {
            returnValue = 0;
        } else if ((oppy.Amount == null) && (compareToOppy.oppy.Amount != null)) {
            returnValue = -1;                       // nulls-first
        } else if ((oppy.Amount != null) && (compareToOppy.oppy.Amount == null)) {
            returnValue = 1;
        } else if (oppy.Amount > compareToOppy.oppy.Amount) {
            returnValue = 1;                        // 양수 → 뒤로
        } else if (oppy.Amount < compareToOppy.oppy.Amount) {
            returnValue = -1;                       // 음수 → 앞으로
        }
        return returnValue;
    }
}

// 인수 없는 sort() 가 각 원소의 compareTo 를 사용
List<OpportunityWrapper> oppyList = new List<OpportunityWrapper>();
oppyList.add(new OpportunityWrapper(new Opportunity(Name='Grand Hotels SLA', Amount=25000)));
oppyList.add(new OpportunityWrapper(new Opportunity(Name='Edge Installation', Amount=50000)));
oppyList.sort();                                    // Comparator 인수 없음 → compareTo 사용
// 결과: Amount 오름차순 (25000 → 50000)
```

핵심 차이: `Comparator`는 `list.sort(new XComparator())`처럼 정렬기를 **넘겨주고**, `Comparable`은 `list.sort()`를 **인수 없이** 호출하면 원소 자신의 `compareTo`가 쓰인다. SObject를 직접 정렬 대상으로 넣을 수 없으므로 위처럼 래퍼로 감싼 뒤 래퍼 리스트를 정렬하고, 정렬 후 `wrapper.oppy`로 원본 SObject를 꺼낸다.

---

## Comparable vs Comparator

| | Comparable | Comparator |
|---|---|---|
| 구현 위치 | 정렬 대상 클래스 내 | 별도 클래스 |
| 정렬 기준 | 단일 (클래스에 내장) | 다중 (여러 Comparator 적용) |
| 외부 타입 정렬 | ❌ | ✅ |
| API 버전 | 오래됨 (레거시) | API 59.0+ (Winter '24) |

> 근거: [Comparator Interface — Apex Reference Guide (developer.salesforce.com)](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_interface_System_Comparator.htm) · Winter '24 Apex Enhancements. `Comparator`·`Collator`는 Winter '24(API 59.0)에서 함께 도입됐다.

---

## 실전 예: 우선순위 기반 정렬

```apex
// 상태별 우선순위 정렬 (closed → open → other)
public class CaseStatusComparator implements Comparator<Case> {

    private static Map<String, Integer> priority = new Map<String, Integer>{
        'Closed' => 2,
        'Open'   => 1,
        'New'    => 0
    };

    public Integer compare(Case a, Case b) {
        Integer pa = priority.get(a.Status) ?? -1;
        Integer pb = priority.get(b.Status) ?? -1;
        return pa - pb;
    }
}
```

---

## Collator 클래스 — 로케일 인식 문자열 정렬 *(Winter '24 추가)*

`Collator`는 로케일에 따라 문자열을 정렬한다. 한국어·일본어 등 다국어 데이터를 올바르게 정렬할 때 사용.

```apex
// 현재 사용자 로케일 기준 정렬
Collator col = Collator.getInstance();

List<String> names = new List<String>{ '나', '가', '다' };
names.sort(col);
// 로케일에 따라 올바른 가나다 순으로 정렬

// 대소문자 무시 비교
col.setStrength(Collator.SECONDARY);
Integer result = col.compare('apple', 'APPLE'); // 0 (같음)
```

`Collator.Strength` 상수:
| 상수 | 의미 |
|---|---|
| `PRIMARY` | 기본 글자 차이만 구분 (a ≠ b, a = á) |
| `SECONDARY` | 악센트 차이 구분 (a = A, a ≠ á) |
| `TERTIARY` | 대소문자 구분 (기본값, a ≠ A) |
| `IDENTICAL` | 완전 일치만 같음으로 처리 |

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| SObject 리스트를 단일 필드 기준으로 정렬 | `List.sort()` + `Comparator` 구현 |
| 복합 기준 정렬 (1차: 금액 내림차순, 2차: 이름 오름차순) | `compare()` 내부에서 다단계 조건 작성 |
| 한국어·다국어 문자열을 유니코드 순이 아닌 자연 순으로 정렬 | `Collator` 조합 |
| 런타임에 정렬 기준을 동적으로 바꿔야 할 때 | `Comparator` 구현 클래스를 교체 |

Winter '24 이전에는 `SObject.getSObjectType().getDescribe()`를 이용한 수동 비교나 Map 기반 임시방편이 필요했다. `Comparator` 도입 후 람다 스타일의 단일 메서드 구현으로 대체 가능하다.

---

## 주의사항

> [!warning] Comparator 구현 시 주의점
> - **null 처리 필수**: `compare()` 메서드에서 두 인자 중 하나가 null이면 NullPointerException 발생. 방어적 null 체크가 필요하다.
> - **삼항 규칙 준수**: `compare(a, b)`가 음수면 a < b, 0이면 같음, 양수면 a > b. 반환값을 Boolean처럼 0/1로만 반환하면 정렬이 불안정해진다.
> - **동등성 일관성**: `compare(a, b) == 0`일 때 `a.equals(b)`와 일관되지 않으면 Set·Map에서 예측 불가 동작 발생.
> - **Collator는 별도 인스턴스**: `Collator.getInstance()`를 매 `compare()` 호출마다 생성하면 성능 저하. 인스턴스를 필드로 캐싱한다.

---

## 관련 노트

- [[Iterable Iterator]]
- [[CollectionUtils]]
- [[Winter '24]] — Comparator·Collator 신규 추가 릴리즈
- [[Apex 언어 기초 — 데이터타입과 변수]] — List.sort() 정렬 동작 등 컬렉션 타입 기초
- [[Apex 언어 기초 — 제어 흐름과 클래스]] — 인터페이스 구현·정렬 로직 클래스 기초

