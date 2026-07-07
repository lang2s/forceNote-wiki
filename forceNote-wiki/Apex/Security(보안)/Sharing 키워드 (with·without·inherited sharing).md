---
tags: [apex, security, sharing, with-sharing, without-sharing, inherited-sharing, record-level]
source: salesforce_apex_developer_guide.pdf
created: 2026-07-08
aliases: [with sharing, without sharing, inherited sharing, sharing 키워드, 공유 키워드, 레코드 가시성, 행 수준 보안]
---

# Sharing 키워드 (with·without·inherited sharing)

> 클래스의 `with sharing` / `without sharing` / `inherited sharing` 키워드는 **레코드 가시성(행 수준 필터)** 만 좌우한다 — SOQL이 어떤 **행(레코드)** 을 반환하는지를 결정할 뿐, 필드/오브젝트 권한(FLS/CRUD)과는 별개다.

---

## 개념 — sharing 키워드는 "행"만 거른다

Salesforce의 Apex 보안 모델은 **레코드 수준(record-level)·필드 수준(field-level)·오브젝트 수준(object-level)** 세 축으로 나뉜다. sharing 키워드는 이 중 **레코드 수준(행 가시성)** 하나만 담당한다.

| 보안 축 | 무엇을 거르나 | 제어 수단 |
|---|---|---|
| **레코드 수준 (행)** | 공유 규칙상 접근 불가한 **레코드(행)** 를 SOQL 결과에서 제외 | `with`/`without`/`inherited sharing` 키워드 |
| 오브젝트 수준 (CRUD) | 접근 불가한 **오브젝트** 접근 차단 | user mode / `WITH USER_MODE` / `stripInaccessible` / describe |
| 필드 수준 (FLS) | 접근 불가한 **필드(열)** 를 결과에서 제거 | user mode / `WITH USER_MODE` / `stripInaccessible` / describe |

핵심 오해 방지: 클래스에 `with sharing`이 선언돼 있어도 그것은 **행 필터일 뿐**, 필드나 오브젝트 권한은 적용하지 않는다. 공유 규칙으로 접근 불가한 레코드는 걸러지지만, 통과한 레코드의 **모든 필드**는 여전히 조회된다. FLS/CRUD까지 적용하려면 [[WITH USER_MODE]](또는 `stripInaccessible`, describe 체크)를 별도로 써야 한다.

> 공식 문서: "Sharing declarations don't enforce object-level access or field-level security." (Apex Developer Guide, *Other Implementation Details*)

```apex
// with sharing = 행 필터만. 필드는 여전히 시스템 권한으로 조회됨.
public with sharing class AccountReader {
    public List<Account> getAll() {
        // 현재 사용자가 공유받지 못한 Account "행"은 제외된다.
        // 그러나 AnnualRevenue에 FLS가 걸려 있어도 값은 반환된다(행 필터만 적용).
        return [SELECT Id, Name, AnnualRevenue FROM Account];
    }
}
```

---

## 레퍼런스 — 세 키워드의 의미

### `with sharing`

현재 사용자의 **공유 규칙을 적용(enforce)** 한다. 사용자가 접근 권한이 없는 레코드는 쿼리·DML 결과에서 제외된다. Salesforce는 코드가 현재 사용자 컨텍스트로 돈다는 것을 명확히 하기 위해 **명시적으로 선언할 것을 권장**한다.

```apex
public with sharing class sharingClass {
    // Code here
}
```

### `without sharing`

현재 사용자의 공유 규칙을 **적용하지 않도록(not enforce)** 보장한다. 공유 규칙을 강제하는 다른 클래스에서 호출되더라도 이 클래스는 공유 규칙을 무시한다.

```apex
public without sharing class noSharing {
    // Code here
}
```

> [!important] `without sharing`으로 선언한 클래스는 현재 사용자가 원래 접근 권한이 없는 레코드에도 접근할 수 있다. Salesforce는 **시스템 수준 접근이 반드시 필요한 클래스에만** `without sharing`을 쓰라고 권고한다. 예: 커뮤니티 사용자가 원래 볼 수 없는 레코드를 읽게 하는 **표적화된 권한 상승(targeted elevation)**.

### `inherited sharing`

**호출한 클래스(calling class)의 sharing 모드를 그대로 상속**한다. 런타임에 sharing 모드를 결정하는 고급 기법으로, `with sharing`·`without sharing` 어느 쪽으로도 안전하게 동작하도록 설계된 클래스에 쓴다.

`inherited sharing` 클래스가 아래처럼 **진입점(entry point)** 으로 직접 쓰이면 **`with sharing` 모드로 실행**된다:

- Aura 컴포넌트 컨트롤러
- LWC에서 호출된 `@AuraEnabled` 메서드
- Visualforce 컨트롤러
- Apex REST 서비스
- 비동기 Apex 클래스
- 기타 Apex 트랜잭션의 모든 진입점

`inherited sharing` 클래스가 **`without sharing`으로 실행되는 경우는 오직** 이미 확립된 `without sharing` 컨텍스트에서 **명시적으로 호출될 때뿐**이다.

> [!important] sharing 모드가 런타임에 결정되므로, `with sharing`·`without sharing` **양쪽 모드 모두에서 안전하게 동작하도록** 극도로 주의해서 코드를 작성해야 한다.

#### escalation 방지 — 재사용 클래스의 안전한 기본값

`inherited sharing`은 **권한 상승(privilege escalation) 방지**를 위한 안전 기본값이다. 서비스/유틸 클래스를 `without sharing`으로 두면, 원래 `with sharing`으로 호출됐어야 할 상황에서도 공유 규칙이 무시돼 의도치 않게 데이터가 노출된다. `inherited sharing`으로 선언하면 **호출자의 컨텍스트를 따라가므로**, 여러 곳에서 재사용되는 클래스가 스스로 권한을 상승시키지 않는다. 이 패턴은 다른 적절한 보안 체크와 함께 쓰면 **AppExchange 보안 리뷰 통과**에 도움이 되고, 특권 Apex 코드가 예기치 않게/안전하지 않게 쓰이는 것을 막는다.

---

## 선언이 없을 때(Omitted Sharing)의 기본값

> [!warning] 버전 의존 동작 (API 66.0 → 67.0 변화)
> **선언 없는 클래스의 기본 sharing 모드가 API 버전에 따라 다르다.** (출처: Apex Developer Guide, *Versioned Behavior Changes* — Tier 2)

### API 67.0 이상 (현행)

명시적 sharing 선언이 없는 클래스는 **`with sharing` 모드로 실행**된다. (기본 sharing 모드 = `with sharing`.)

단, 선언 없는 클래스가 **부모 클래스를 상속(extends)** 하면 **부모의 sharing 모드를 채택**한다.

### API 66.0 이하 (구버전 — 레거시)

선언이 없으면 아래 요인들로 모드가 결정된다(대부분 `without sharing`으로 귀결 — 구버전의 위험 지점):

- 상속 체인의 어느 클래스든 API 67.0 이상으로 저장돼 있으면 → **`with sharing`**
- Aura 컨트롤러이거나 LWC에서 호출된 `@AuraEnabled` 메서드이면 → **`with sharing`**
- Apex 진입점이 아니면 → 호출하는 클래스의 sharing 모드를 따름
- 그 외 → **`without sharing`**

> 66.0 이하 클래스는 명시적 선언 없이는 sharing 모드 판별이 어렵다 — 상속 트리·호출 순서·클래스 동작을 전부 조사해야 한다. **그래서 DB 작업/SOQL을 포함하는 모든 클래스에는 항상 명시적 sharing 선언을 넣는 것이 권장된다.** (의도 명확성 + 유지보수성)

---

## inner class·상속 시 적용 규칙

- **inner class ≠ outer class 상속 안 함**: inner class와 outer class **각각에** sharing 모드를 선언할 수 있다. **inner class는 컨테이너(outer) 클래스의 sharing 모드를 채택하지 않는다.** 선언하지 않은 나머지 코드에는 그 클래스의 sharing 설정이 초기화 코드·생성자·메서드 전체에 적용된다.

- **메서드의 sharing = "정의된 곳" 기준**: `inherited sharing` 클래스의 메서드를 제외하면, 메서드의 sharing 모드는 **호출된 곳이 아니라 정의된 곳**에서 결정된다. 예: `with sharing` 클래스에 정의된 메서드는 `without sharing` 클래스에서 호출돼도 여전히 공유 규칙을 적용한다. (단 API 66.0 이하로 컴파일된 클래스는 예외가 있다.)

- **상속 시 기본값 채택**: 선언 없는 클래스가 부모 클래스를 extends 하면 부모의 sharing 모드를 채택한다(위 Omitted Sharing 참조).

```apex
// 구조 예시 — inner class는 outer의 sharing을 상속하지 않는다
public without sharing class OuterClass {
    // 이 outer는 공유 규칙 무시
    public with sharing class InnerClass {
        // inner는 독립적으로 with sharing → 공유 규칙 적용
    }
}
```

---

## sharing이 적용/미적용되는 컨텍스트

| 컨텍스트 | sharing 동작 |
|---|---|
| **Apex 트리거** | 명시적 sharing 선언 **불가**. 항상 **system mode + `without sharing`** 으로 실행 → 공유 규칙·FLS·오브젝트 권한을 모두 우회. 데이터 접근을 강제하려면 로직을 별도 트리거 핸들러에 위임하고 거기서 sharing/접근 모드를 지정한다. |
| **익명 Apex (executeAnonymous)** | 항상 **`with sharing`** (현재 사용자의 공유 규칙으로 실행) |
| **Connect in Apex** | 항상 **`with sharing`** |
| **비동기 Apex (`inherited sharing` 선언 시)** | 비동기 작업에 대해 **항상 `with sharing`** 으로 실행. 각 비동기 작업은 새 진입점이며 sharing 모드는 직렬화되지 않는다. |

> DML을 **system mode**로 실행하면(예: `AccessLevel.SYSTEM_MODE`), 레코드 수준 권한은 여전히 **호출 클래스의 sharing 키워드**가 결정한다. 반대로 **user mode** DML은 항상 사용자의 공유 규칙을 존중한다. 즉 system mode에서도 sharing 키워드는 살아있다.

---

## Best Practices

| Sharing 모드 | 언제 쓰나 |
|---|---|
| `with sharing` | 특별한 이유가 없으면 **기본값**으로 사용. |
| `without sharing` | **주의해서** 사용. 공유 규칙으로 가려진 민감 데이터를 실수로 노출하지 않도록. 현재 사용자에게 **표적화된 권한 상승**을 줄 때 최적(예: 커뮤니티 사용자가 원래 못 보는 레코드를 읽게). |
| `inherited sharing` | 서로 다른 sharing 모드를 지원해야 하는 **유연한 서비스 클래스**에. |

> DB 작업이나 SOQL을 포함하는 Apex 클래스에는 **항상 명시적 sharing 선언**을 넣는다. 의도를 명확히 하고 유지보수성을 높인다.

---

## 관련 노트

- [[WITH USER_MODE]] — sharing 키워드가 못 거르는 FLS/CRUD(필드·오브젝트 권한)를 SOQL 레벨에서 적용. sharing(행) ⊥ USER_MODE(열/오브젝트)의 보완 관계.
- [[Apex MOC]] — Apex 섹션 목차
- [[Apex Managed Sharing (프로그래매틱 공유)]] — 프로그래매틱 공유(코드로 `__Share` 레코드를 DML해 접근 부여). Apex managed sharing은 "누구에게 접근을 주느냐"(레코드 공유), 이 노트의 sharing 키워드는 "실행 중인 코드가 공유 규칙을 적용하느냐"(런타임 강제) — 서로 다른 층의 보완 관계.
