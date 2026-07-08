---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Basic PART - 2]
---

# Apex 기초 Part 2 (OOP)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## OOP 개요

객체 지향 프로그래밍(OOP)은 함수·로직이 아닌 데이터·오브젝트를 중심으로 소프트웨어 설계를 조직합니다. 오브젝트는 고유한 속성과 동작을 가진 데이터 필드입니다.

**핵심 구성:**
- **클래스(Class):** 오브젝트의 구조·동작을 정의하는 청사진. 속성(데이터/Attributes)과 함수(메서드/Instructions) 포함. 런타임에 메모리를 차지하지 않음(개념적 청사진).
- **오브젝트(Object):** 클래스의 인스턴스. 메모리를 차지함(실제 데이터·기능 표현).

## 함수(Function)

단일 작업을 수행하는 코드 블록. 재사용 가능하며 디버깅을 쉽게 합니다.
```apex
public Integer Adding(Integer x, Integer y) {
    return x + y;
}
```
- **접근 제어자:** public이면 클래스 외부에서 접근 가능. private이면 외부 접근 불가(Method is not visible 오류).
- **반환 타입:** 선언한 타입의 값을 반환해야 함(불일치 시 Illegal conversion 오류). void(반환 없음), Primitive, 커스텀 클래스, 컬렉션(List/Set/Map), SObject 가능.
- **매개변수(Parameter):** 메서드 시그니처에 선언된 변수(x, y). 호출 시 전달하는 실제 값은 인수(Arguments).

## 함수 오버로딩(Function Overloading)

같은 이름이지만 다른 매개변수를 가진 여러 메서드를 정의.
```apex
public class MathOperations {
    public Integer add(Integer a, Integer b) { return a + b; }
    public Decimal add(Decimal a, Decimal b) { return a + b; }
}
```
가독성 향상, 다양한 매개변수 유형·개수 처리 유연성, 일관된 명명.

## 생성자(Constructor)

인스턴스 생성 시 오브젝트 상태를 초기화하는 특별 메서드. 오브젝트 생성 시 자동 호출. 반환 타입 없음, 오버로딩 지원.

**기본 생성자(no-argument):**

기본값으로 초기화.
```apex
public class ATM {
    private String accountNumber;
    private Decimal balance;
    public ATM() { accountNumber = '123456789'; balance = 1000.00; }
}
```
**매개변수 생성자:**
```apex
public Adder(Integer num1, Integer num2) {
    number1 = num1; number2 = num2; calculateSum();
}
```

## Static 변수와 메서드

**Static 변수:**

인스턴스가 아닌 클래스에 연결된 클래스 수준 변수. 모든 인스턴스가 같은 메모리 공유. 클래스 이름으로 접근, 한 번만 초기화, 마지막 값 유지. 용도: 인스턴스 카운팅, 데이터 공유.
```apex
public class MathOperations { public static Integer staticNumber = 10; }
MathOperations.staticNumber += 10; // 클래스 이름으로 접근
```

**Static 메서드:**

오브젝트가 아닌 클래스에 연결. 인스턴스 생성 없이 호출 가능. 예: `Name.length()`(String 클래스의 메서드). 특정 오브젝트와 무관한 연산(수학 연산 등)에 사용.

## 캡슐화(Encapsulation)

데이터(속성)와 메서드를 클래스라는 단일 단위로 묶음. 일부 컴포넌트 직접 접근 제한, 의도치 않은 간섭·오용 방지.
```apex
public class BankAccount {
    private Decimal balance;
    public BankAccount(Decimal initialBalance) {
        this.balance = initialBalance >= 0 ? initialBalance : 0;
    }
}
```
public 메서드가 private 데이터 접근 인터페이스 역할. 민감 데이터 접근 제한, 검증 로직 구현으로 견고·유지보수·보안성 향상.

## 상속(Inheritance)

자식 클래스가 부모 클래스의 속성·동작을 획득. 코드 재사용·확장성·클래스 계층 촉진. `virtual` 키워드는 확장·재정의 허용을 의미.
```apex
public virtual class BankTransaction {
    protected Decimal balance;
    public BankTransaction(Decimal initialBalance) { this.balance = initialBalance >= 0 ? initialBalance : 0; }
    protected Decimal getBalance() { return balance; }
}
public class Withdrawal extends BankTransaction {
    public Withdrawal(Decimal initialBalance) { super(initialBalance); }
    public void withdraw(Decimal amount) { ... }
}
```
**private vs protected:**

private은 자식 클래스에서 접근 불가, protected는 자식 클래스에서 사용 가능. `super(initialBalance)`는 부모 생성자를 호출해 초기화.

## 다형성(Polymorphism)

변수·함수·오브젝트가 여러 형태를 가질 수 있게 함. 두 유형:
- **컴파일 타임(메서드 오버로딩):** 같은 이름·다른 매개변수의 여러 메서드.
- **런타임(메서드 오버라이딩):** 자식 클래스가 슈퍼클래스 메서드의 특정 구현 제공(같은 시그니처).
```apex
public class Cat extends Animal {
    public override void makeSound() { System.debug('Cat Meows'); }
}
```
다형성·커스터마이징·확장성 촉진, 런타임 동적 디스패치.

## 추상화(Abstraction)

구현 세부사항을 숨기고 기능만 사용자에게 표시. 달성 방법: 추상 클래스, 인터페이스.

**추상 클래스:**

abstract 키워드로 선언. 추상 메서드(본문 없음, 자식이 재정의 필수)와 일반 메서드 모두 가능. 인스턴스 생성 불가.
```apex
public abstract class Employee {
    protected String name;
    public abstract Decimal calculateSalary();
}
public class PartTimeEmployee extends Employee {
    public override Decimal calculateSalary() { return hourlyRate * hoursWorked; }
}
```

**인터페이스:**

추상화·다중 상속 달성 메커니즘. 추상 메서드만 가능(본문 없음). Apex 인터페이스 메서드는 암묵적으로 public·abstract. 변수 선언 불가. 한 클래스가 여러 인터페이스 구현 가능(implements).
```apex
public interface IShape { void draw(); }
public interface IColor { String getColor(); }
public class Rectangle implements IShape, IColor {
    public void draw() { System.debug('Drawing a rectangle'); }
    public String getColor() { return 'Red'; }
}
```
(추상 클래스는 추상·비추상 메서드 모두 지원하나 다중 상속은 미지원.)

## 인터페이스 시나리오

직원의 공통 속성(employeeId, name)과 displayInfo() 메서드는 Developer·Manager 모두 접근하지만, work() 메서드는 Developer만 접근하게 하려면:
- work() 메서드를 가진 Workable 인터페이스 정의
- 공통 속성·displayInfo()를 가진 추상 클래스 CompanyMember 생성
- Developer는 CompanyMember를 extends하고 Workable을 implements
- Manager는 CompanyMember만 extends

```apex
public interface Workable { void work(); }
public abstract class CompanyMember {
    protected Integer employeeId;
    protected String name;
    public abstract void displayInfo();
}
public class Developer extends CompanyMember implements Workable {
    public override void displayInfo() { ... }
    public void work() { System.debug('Developer is working on code.'); }
}
public class Manager extends CompanyMember {
    public override void displayInfo() { ... }
}
```
