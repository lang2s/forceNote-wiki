---
tags: [Apex, 언어기초, 제어흐름, 클래스, 인터페이스, 생성자, 접근제어자, 상속, sharing, switch, 키워드]
source: salesforce_apex_developer_guide.pdf (v67.0 Summer '26, Writing Apex 챕터 — Control Flow Statements p.57-64 / Classes, Objects, and Interfaces p.65-132)
created: 2026-06-17
aliases: [Apex Control Flow, Apex Switch, Apex Classes, Apex Interfaces, Access Modifiers, with sharing, Apex Constructor, Apex Properties, Apex 제어흐름, Apex 클래스, 접근제어자, 인터페이스]
---

# Apex 언어 기초 — 제어 흐름과 클래스

> if-else·switch·loop 제어문과 클래스·생성자·접근제어자·상속·인터페이스·sharing 키워드까지 Apex 객체지향 기초 전수. (Apex Developer Guide v67.0 — Control Flow + Classes/Objects/Interfaces)

---

## 개요

Apex는 if-else·switch·loop 제어 흐름과 Java 유사한 클래스·인터페이스 객체지향 모델을 제공한다. 데이터 타입·변수·연산자 기초는 [[Apex 언어 기초 — 데이터타입과 변수]], 예외 처리·예약어는 [[Apex 언어 기초 — 예외 처리와 예약어]]를 참조한다.

---

## 제어 흐름 — 조건문 (If-Else)

Java와 유사하다. else는 선택적이며, 가장 가까운 if와 그룹된다.

```apex
if ([Boolean_condition])
// Statement 1
else
// Statement 2
```

중첩 예:

```apex
Integer x, sign;
if (x <= 0) if (x == 0) sign = 0; else sign = -1;
```

는 다음과 동등하다.

```apex
Integer x, sign;
if (x <= 0) {
if (x == 0) {
sign = 0;
} else {
sign = -1;
}
}
```

else if 반복 허용:

```apex
if (place == 1) {
medal_color = 'gold';
} else if (place == 2) {
medal_color = 'silver';
} else if (place == 3) {
medal_color = 'bronze';
} else {
medal_color = null;
}
```

---

## 제어 흐름 — Switch Statements

표현식이 여러 값 중 하나와 일치하는지 테스트하고 분기한다.

```apex
switch on expression {
when value1 { // when block 1
// code block 1
}
when value2 { // when block 2
// code block 2
}
when value3 { // when block 3
// code block 3
}
when else {
// default block, optional
// code block 4
}
}
```

when 값 형태:

```apex
when value1 {
}
when value2, value3 {
}
when TypeName VariableName {
}
```

> **Note:** fall-through 없음. 코드 블록 실행 후 switch 종료.

**switch 표현식 가능 타입:** Integer, Long, sObject, String, Enum.

**When Blocks 형태:**

- `when literal {}` (comma 구분 multiple literal 가능)
- `when SObjectType identifier {}`
- `when enum_value {}`
- null은 모든 타입에 유효한 값. 각 when 값은 unique해야 함.

**When Else Block:** 일치 없으면 실행. enum 사용 시 권장(managed package 신규 enum 값 대비). 포함 시 반드시 마지막 블록.

### Single Value

```apex
switch on i {
when 2 {
System.debug('when block 2');
}
when -3 {
System.debug('when block -3');
}
when else {
System.debug('default');
}
}
```

### Null Value

```apex
switch on i {
when 2 {
System.debug('when block 2');
}
when null {
System.debug('bad integer');
}
when else {
System.debug('default ' + i);
}
}
```

### Multiple Values

```apex
switch on i {
when 2, 3, 4 {
System.debug('when block 2 and 3 and 4');
}
when 5, 6 {
System.debug('when block 5 and 6');
}
when 7 {
System.debug('when block 7');
}
when else {
System.debug('default');
}
}
```

### Method

```apex
switch on someInteger(i) {
when 2 {
System.debug('when block 2');
}
when 3 {
System.debug('when block 3');
}
when else {
System.debug('default');
}
}
```

### sObject (implicit instanceof + casting)

```apex
switch on sobject {
when Account a {
System.debug('account ' + a);
}
when Contact c {
System.debug('contact ' + c);
}
when null {
System.debug('null');
}
when else {
System.debug('default');
}
}
```

> **Note:** when 블록당 sObject 타입은 하나만.

### Enum

```apex
switch on season {
when WINTER {
System.debug('boots');
}
when SPRING, SUMMER {
System.debug('sandals');
}
when else {
System.debug('none of the above');
}
}
```

---

## 제어 흐름 — Loops

Apex는 5종 procedural loop를 지원한다.

- `do {statement} while (Boolean_condition);`
- `while (Boolean_condition) statement;`
- `for (initialization; Boolean_exit_condition; increment) statement;`
- `for (variable : array_or_set) statement;`
- `for (variable : [inline_soql_query]) statement;`

루프 제어: `break;`(전체 루프 종료), `continue;`(다음 iteration으로).

### Do-While

Boolean 조건이 true인 동안 반복. 첫 루프 실행 후 조건 체크 → 최소 1회 실행. `{}` 항상 필수.

```apex
Integer count = 1;
do {
System.debug(count);
count++;
} while (count < 11);
```

### While

첫 루프 전 조건 체크 → 0회 실행 가능. `{}`는 다중 statement일 때만 필수.

```apex
Integer count = 1;
while (count < 11) {
System.debug(count);
count++;
}
```

### For (3종)

- Traditional: `for (init_stmt; exit_condition; increment_stmt) { code_block }`
- List/Set iteration: `for (variable : list_or_set) { code_block }` (variable은 list_or_set과 같은 primitive/sObject 타입)
- SOQL: `for (variable : [soql_query]) { code_block }` 또는 `for (variable_list : [soql_query]) { code_block }`

**Traditional For 실행 순서:** 1. init_stmt 실행(콤마로 복수 변수 가능) → 2. exit_condition 체크(true면 계속, false면 종료) → 3. code_block 실행 → 4. increment_stmt 실행 → 5. Step 2 복귀.

```apex
for (Integer i = 0, j = 0; i < 10; i++) {
System.debug(i+1);
}
```

**List/Set Iteration For:**

```apex
Integer[] myInts = new Integer[]{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
for (Integer i : myInts) {
System.debug(i);
}
```

### Iterating Collections 주의

iteration 중 컬렉션 요소 수정은 미지원(에러)이다.

- **추가:** 임시 컬렉션에 보관 후 iteration 종료 후 원본에 추가.
- **제거:** 새 list 생성해 유지할 요소를 복사하거나, 임시 list에 제거 대상을 보관 후 종료 후 제거. (`List.remove`는 linear 동작.)
- map/set은 제거할 키를 임시 list에 보관 후 종료 후 제거.

---

## 클래스 정의

top-level(outer) 클래스와 inner 클래스(한 단계 깊이만)를 정의할 수 있다.

```apex
public class myOuterClass {
// Additional myOuterClass code here
class myInnerClass {
// myInnerClass code here
}
}
```

**클래스 정의 요소:** 1. Access modifier(top-level은 public/global 필수, inner는 선택) 2. 선택적 definition modifier(virtual, abstract 등) 3. `class` 키워드 + 이름 4. 선택적 extends/implements.

**구문:**

```apex
private | public | global
[virtual | abstract | with sharing | without sharing]
class ClassName [implements InterfaceNameList] [extends ClassName]
{
// The body of the class
}
```

- **private** — 로컬에서만 알려짐. inner 클래스 기본값. inner 클래스 또는 @IsTest top-level 테스트 클래스에만 사용.
- **public** — 애플리케이션/네임스페이스 내 가시.
- **global** — 모든 Apex 코드에서 알려짐. webservice 메서드 포함 클래스는 global 필수. 메서드/inner가 global이면 outer top-level도 global.
- **with sharing / without sharing** — 클래스 sharing 모드 지정.
- **virtual** — extension·override 허용.
- **abstract** — abstract 메서드 포함(시그니처만, body 없음).

> **Note:** Managed-Released 패키지 업로드 후 global 클래스에 abstract 메서드 추가 불가. virtual이면 추가 메서드도 virtual·구현 필요. 설치된 managed package의 global 클래스의 public/protected virtual 메서드 override 불가.

다중 인터페이스 구현 가능, 단 하나의 클래스만 extend(다중 상속 미지원).

**Versioned Behavior:** API 65.0+ abstract/override 메서드는 protected/public/global 필요(없으면 private 기본 → 컴파일 에러 "Abstract methods require at least one of the following: global, public, protected"). API 61.0+ private 메서드는 subclass의 동일 시그니처 instance 메서드로 override 안 됨(60.0 이하는 override됨).

---

## 클래스 변수와 메서드

### Class Variables

**구문:** `[public | private | protected | global] [final] [static] data_type variable_name [= value]`

```apex
private static final Integer MY_INT;
private final Integer i = 1;
```

### Class Methods

**요소:** 선택적 modifier, 반환 타입(없으면 void), 콤마 구분 입력 파라미터(최대 32개, 각 타입 명시, 없으면 빈 괄호), `{}` body.

> **Note:** 모든 Apex 타입은 Object 클래스 메서드를 구현한다.

**구문:**

```apex
[public | private | protected | global] [override] [static] data_type method_name (input parameters) {
// The body of the method
}
```

예:

```apex
public static Integer getInt() {
return MY_INT;
}
```

**User-defined 메서드 특성:** system 메서드 위치에서 사용 가능, recursive 가능, side effect 가능(DML insert로 ID 초기화), 자기/이후 메서드 참조 가능(2단계 파싱, forward declaration 불필요), **overload 가능**(파라미터 다르면), void 반환은 standalone statement로 호출. 모든 user-defined 타입은 `clone` 메서드 지원(Java 기반).

### Passing by Value (primitive)

Integer·String 등은 by value. 메서드 내 변경은 scope 내에만 존재한다.

```apex
public class PassPrimitiveTypeExample {
public static void debugStatusMessage() {
String msg = 'Original value';
processString(msg);
System.assertEquals(msg, 'Original value');
}
public static void processString(String s) {
s = 'Modified value';
}
}
```

### Passing by Reference (non-primitive)

sObject 등은 by reference. 메서드 내에서 다른 object를 가리키게는 못 바꾸지만 필드 값은 변경 가능하다.

```apex
public class PassNonPrimitiveTypeExample {
public static void createTemperatureHistory() {
List<Integer> fillMe = new List<Integer>();
reference(fillMe);
System.assertEquals(fillMe.size(),5);
List<Integer> createMe = new List<Integer>();
referenceNew(createMe);
System.assertEquals(createMe.size(),0);
}
public static void reference(List<Integer> m) {
m.add(70);
m.add(68);
m.add(75);
m.add(80);
m.add(82);
}
public static void referenceNew(List<Integer> m) {
m = new List<Integer>{55, 59, 62, 60, 63};
}
}
```

---

## 생성자 (Using Constructors)

객체 생성 시 호출되는 코드. 모든 클래스에 필요한 건 아니며 — 없으면 default no-argument 생성자(클래스와 동일 visibility)가 생성된다. 명시적 반환 타입 없음, 상속 안 됨. `new` 키워드로 인스턴스화한다.

```apex
public class TestObject {
// The no argument constructor
public TestObject() {
// more code here
}
}
```

```apex
TestObject myTest = new TestObject();
```

인자 있는 생성자를 작성하면 no-arg 생성자를 쓰려면 직접 작성해야 한다.

### Constructor Chaining (`this(...)`)

```apex
public class TestObject2 {
private static final Integer DEFAULT_SIZE = 10;
Integer size;
public TestObject2() {
this(DEFAULT_SIZE); // Using this(...) calls the one argument constructor
}
public TestObject2(Integer ObjectSize) {
size = ObjectSize;
}
}
```

### Overloading (각 생성자는 다른 인자 리스트)

```apex
public class Leads {
public Leads () {}
public Leads (Boolean call) {}
public Leads (String email, Boolean call) {}
public Leads (Boolean call, String email) {}  // 순서 다르므로 legal
}
```

---

## 접근 제어자 (Access Modifiers)

private, protected, public, global을 사용할 수 있다.

| Modifier | 의미 |
|---|---|
| **private** | 기본값. 정의된 Apex 클래스 내에서만 접근 가능. modifier 미지정 시 private. |
| **protected** | 정의 클래스의 inner 클래스·extend 클래스에서 가시. instance 메서드·멤버 변수에만 사용. private보다 더 permissive. |
| **public** | 특정 패키지 내 모든 Apex가 접근. 2GP managed package 공유는 `@NamespaceAccessible` 사용. no-namespace 패키지에서 public 사용 시 암시적으로 @NamespaceAccessible. (Java의 public과 다름 — Java식 public을 원하면 global 사용.) |
| **global** | 클래스 접근 가능한 모든 Apex가 사용. SOAP API/외부 Apex 참조 메서드에 필수. global 메서드/변수면 클래스도 global. (드물게 사용 권장.) |

구문: `[(none)|private|protected|public|global] declaration`

```apex
private string s1 = '1';
public string getsz() {
...
}
```

> **Note:** 인터페이스 메서드는 인터페이스와 동일 modifier(public/global).

---

## Static·Instance·Initialization Code

Apex는 static 메서드·변수·초기화 코드를 지원한다(단 Apex 클래스 자체는 static 불가). instance 메서드·멤버 변수·초기화 코드(modifier 없음)·로컬 변수도 가능하다.

- **Static 특성:** 클래스와 연관, outer 클래스에만 허용, 클래스 로드 시에만 초기화, Visualforce view state로 전송 안 됨.
- **Instance 특성:** 특정 object와 연관, definition modifier 없음, 모든 인스턴스 생성마다 생성.
- **Local 특성:** 선언된 코드 블록과 연관, 사용 전 초기화 필수.

```apex
Boolean myCondition = true;
if (myCondition) {
integer localVariable = 10;
}
```

**Static 사용:** outer 클래스만. instance 불필요. object 생성 전 모든 static 멤버 변수 초기화·static init 블록 실행(등장 순서). static 메서드는 utility — instance 멤버 변수 값 접근 불가. **static 변수는 Apex transaction scope 내에서만 static**(서버/org 전체 아님), transaction 경계에서 reset. trigger 다중 fire 시 static 변수 persist. 인스턴스로 static 접근 불가 → `MyClass.myStaticVariable` / `MyClass.myStaticMethod()`. 로컬 변수명이 클래스명 평가보다 우선(같은 이름 시 shadow).

```apex
public class P {
public static boolean firstRun = true;
}
```

```apex
trigger T1 on Account (before delete, after delete, after undelete) {
if(Trigger.isBefore){
if(Trigger.isDelete){
if(p.firstRun){
Trigger.old[0].addError('Before Account Delete Error');
p.firstRun=false;
}
}
}
}
```

> trigger 내 static 변수는 다른 trigger context(before/after) 간 값 유지 안 됨 → 클래스에 static 정의.
> **Note:** API 20.0 이하 Bulk API trigger는 200 → 100 chunk 분할. 21.0+ 추가 분할 없음. governor limit는 trigger 호출 간 reset되나 static 변수는 동일 Bulk API 요청 다중 호출 간 reset 안 됨.

inner 클래스는 static Java inner처럼 동작(static 키워드 불필요), outer 인스턴스로의 implicit pointer 없음(this).

### Using Instance Methods and Variables (Plotter)

```apex
public class Plotter {
class Point {
Double x;
Double y;
Point(Double x, Double y) {
this.x = x;
this.y = y;
}
Double getXCoordinate() {
return x;
}
Double getYCoordinate() {
return y;
}
}
List<Point> points = new List<Point>();
public void plot(Double x, Double y) {
points.add(new Point(x, y));
}
public void render() {
}
}
```

### Using Initialization Code

- **Instance init 코드** `{ //code body }` — 객체 인스턴스화마다 실행, 생성자 전.
- **Static init 코드** `static { //code body }` — 클래스 첫 사용 시 1회만.
- 클래스는 임의 개수의 static/instance init 블록 가능, 등장 순서대로 실행.

```apex
public class MyClass {
class RGB {
Integer red;
Integer green;
Integer blue;
RGB(Integer red, Integer green, Integer blue) {
this.red = red;
this.green = green;
this.blue = blue;
}
}
static Map<String, RGB> colorMap = new Map<String, RGB>();
static {
colorMap.put('red', new RGB(255, 0, 0));
colorMap.put('cyan', new RGB(0, 255, 255));
colorMap.put('magenta', new RGB(255, 0, 255));
}
}
```

---

## Apex Properties

변수와 유사하나 접근/반환 전 코드를 실행할 수 있다. get accessor(읽기 시)·set accessor(할당 시) 코드 블록을 한두 개 포함한다. get만 있으면 read-only, set만 있으면 write-only, 둘 다면 read-write.

**구문:**

```apex
Public class BasicClass {
access_modifier return_type property_name {
get {
//Get accessor code block
}
set {
//Set accessor code block
}
}
}
```

access_modifier: public, private, global, protected. 추가 definition modifier: static, transient.

```apex
public class BasicProperty {
public integer prop {
get { return prop; }
set { prop = value; }
}
}
```

```apex
BasicProperty bp = new BasicProperty();
bp.prop = 5;       // Calls set accessor
System.assertEquals(5, bp.prop);  // Calls get accessor
```

> **Note:** get accessor는 property 타입 값 반환, return으로 끝나야 함. set은 void 반환 메서드 유사, 암시적 `value` 인자(property와 동일 타입). API 42.0+ set에서 값 설정 안 하면 get에서 업데이트 불가. property는 interface에 정의 불가. C# 기반(차이: 직접 저장 제공, automatic property 가능).

### Automatic Properties (get/set 블록 비움)

```apex
public class AutomaticProperty {
public integer MyReadOnlyProp { get; }
public double MyReadWriteProp { get; set; }
public string MyWriteOnlyProp { set; }
}
```

```apex
AutomaticProperty ap = new AutomaticProperty();
ap.MyReadOnlyProp = 5;   // compile error: not writable
ap.MyReadWriteProp = 5;  // No error
System.assertEquals(5, ap.MyWriteOnlyProp);  // compile error: not readable
```

### Static Properties (static context, non-static 멤버 접근 불가)

```apex
public class StaticProperty {
private static integer StaticMember;
private integer NonStaticMember;
public static integer MyGoodStaticProp {
get {return StaticMember;}
set { StaticMember = value; }
}
public integer MyGoodNonStaticProp {
get {return NonStaticMember;}
set { NonStaticMember = value; }
}
}
```

```apex
StaticProperty sp = new StaticProperty();
StaticProperty.MyGoodStaticProp = 5;  // 인스턴스로는 접근 불가
```

### Access Modifiers on Accessors (accessor가 property보다 더 restrictive)

```apex
global virtual class PropertyVisibility {
public integer X { private get; set; }      // private read, public write
global integer Y { get; public set; }        // global read, write within class
public integer Z { get; protected set; }     // read within class, subclass set
}
```

---

## 상속 — Extending a Class

클래스를 extend하여 특화 동작을 추가한다. 모든 메서드·property가 상속된다. `override` 키워드로 virtual 메서드를 override(polymorphism). `extends` 키워드는 하나의 클래스만 extend 가능, 다중 interface 구현 가능.

```apex
public virtual class Marker {
public virtual void write() {
System.debug('Writing some text.');
}
public virtual Double discount() {
return .05;
}
}
```

```apex
public class YellowMarker extends Marker {
public override void write() {
System.debug('Writing some text using the yellow marker.');
}
}
```

### Polymorphism

```apex
Marker obj1, obj2;
obj1 = new Marker();
obj1.write();    // 'Writing some text.'
obj2 = new YellowMarker();
obj2.write();    // 'Writing some text using the yellow marker.'
Double d = obj2.discount();   // inherited
```

### 추가 메서드 (RedMarker)

```apex
public class RedMarker extends Marker {
public override void write() {
System.debug('Writing some text in red.');
}
public Double computePrice() {
return 1.5;
}
}
```

```apex
RedMarker obj = new RedMarker();
Double price = obj.computePrice();
```

인터페이스도 다른 인터페이스를 extend할 수 있다.

---

## 종합 예제 (Extended Class Example)

```apex
public class OuterClass {
private static final Integer MY_INT;
public static String sharedState;
public static Integer getInt() { return MY_INT; }
static {
MY_INT = 2;
}
private final String m;
{
m = 'a';
}
// implicit no-argument public constructor exists
public virtual interface MyInterface {
void myMethod();
}
interface MySecondInterface extends MyInterface {
Integer method2(Integer i);
}
public virtual class InnerClass implements MySecondInterface {
private final String s;
private final String s2;
{
this.s = 'x';
}
private final Integer i = s.length();
InnerClass() {
this('none');
}
public InnerClass(String s2) {
this.s2 = s2;
}
public virtual void myMethod() { /* does nothing */ }
public Integer method2(Integer i) { return this.i + s.length(); }
}
public abstract class AbstractChildClass extends InnerClass {
public override void myMethod() { /* do something else */ }
protected void method2() {}
public abstract Integer abstractMethod();
}
public class ConcreteChildClass extends AbstractChildClass {
public override Integer abstractMethod() { return 5; }
}
public class AnotherChildClass extends InnerClass {
AnotherChildClass(String s) {
super(s);
}
}
public virtual class MyException extends Exception {
public Double d;
MyException(Double d) {
this.d = d;
}
protected void doIt() {}
}
public abstract class MySecondException extends Exception implements MyInterface {
}
}
```

**호출 예제:**

```apex
OuterClass.InnerClass ic = new OuterClass.InnerClass('x');
System.assertEquals(2, ic.method2(1));
OuterClass.MyInterface mi = ic;
OuterClass.InnerClass ic2 = mi instanceof OuterClass.InnerClass ?
(OuterClass.InnerClass)mi : null;
System.assert(ic2 != null);
OuterClass o = new OuterClass();
System.assertEquals(2, OuterClass.getInt());
System.assertEquals(5, new OuterClass.ConcreteChildClass().abstractMethod());
// new OuterClass.AbstractChildClass();  // Illegal - abstract
// o.getInt();  // Illegal - static via instance
// new OuterClass.ConcreteChildClass().method2();  // Illegal - protected externally
```

---

## Interfaces

메서드가 구현되지 않은 클래스 — 시그니처만 있고 body는 비어 있다. 다른 클래스가 모든 메서드 body를 제공해 implement한다. 추상화 레이어를 제공한다.

```apex
public interface PurchaseOrder {
Double discount();
}
```

```apex
public class CustomerPurchaseOrder implements PurchaseOrder {
public Double discount() {
return .05; // Flat 5% discount
}
}
```

```apex
public class EmployeePurchaseOrder implements PurchaseOrder {
public Double discount() {
return .10; // 10% discount
}
}
```

- 인터페이스 메서드는 access modifier 없음, 시그니처만. implement 클래스는 모든 메서드 정의 필수. 인터페이스는 새 데이터 타입.

> **Note:** Managed-Released 패키지 업로드 후 global 인터페이스에 메서드 추가 불가. API 61.0+ private 메서드 override 변경(60.0 이하와 다름).

### Custom Iterators

**Iterator 인터페이스 instance 메서드:**

| Name | Arguments | Returns | Description |
|---|---|---|---|
| `hasNext` | | Boolean | 컬렉션에 다음 항목 있으면 true |
| `next` | | Any type | 컬렉션의 다음 항목 반환 |

> 모든 Iterator 메서드는 global 또는 public 선언 필수.

```apex
IterableString x = new IterableString('This is a really cool test.');
while(x.hasNext()){
system.debug(x.next());
}
```

**Iterable 인터페이스 메서드:**

| Name | Arguments | Returns | Description |
|---|---|---|---|
| `iterator` | | Iterator class | 이 인터페이스의 iterator 참조 반환 |

> iterator 메서드는 global/public 선언 필수.

```apex
public class CustomIterator
implements Iterator<Account>{
private List<Account> accounts;
private Integer currentIndex;
public CustomIterator(List<Account> accounts){
this.accounts = accounts;
this.currentIndex = 0;
}
public Boolean hasNext(){
return currentIndex < accounts.size();
}
public Account next(){
if(hasNext()) {
return accounts[currentIndex++];
} else {
throw new NoSuchElementException('Iterator has no more elements.');
}
}
}
public class CustomIterable implements Iterable<Account> {
public Iterator<Account> iterator(){
List<Account> accounts =
[SELECT Id, Name,
NumberOfEmployees
FROM Account
LIMIT 10];
return new CustomIterator(accounts);
}
}
```

**batch job with iterator:**

```apex
public class BatchClass implements Database.Batchable<Account>{
public Iterable<Account> start(Database.BatchableContext info){
return new CustomIterable();
}
public void execute(Database.BatchableContext info, List<Account> scope){
List<Account> accsToUpdate = new List<Account>();
for(Account acc : scope){
acc.Name = 'changed';
acc.NumberOfEmployees = 69;
accsToUpdate.add(acc);
}
update accsToUpdate;
}
public void finish(Database.BatchableContext info){
}
}
```

> Custom Iterator/Iterable의 더 깊은 활용·패턴은 [[Iterable Iterator]] 참조.

---

## 키워드 (Keywords)

Apex 키워드: final, instanceof, super, this, transient, with sharing, without sharing.

### final

- final 변수는 1회만 할당. static final은 static init 블록 또는 정의 시. member final은 init 블록·생성자·정의 시.
- 상수 정의 = static + final.
- non-final static 변수는 클래스 레벨 state 통신(요청 간 공유 안 됨).
- 메서드·클래스는 기본 final(override 불가). 선언에 final 키워드 사용 불가. override 필요 시 virtual.
- property에 final 사용 불가.

### instanceof

런타임에 객체가 특정 클래스 인스턴스인지 검증한다.

```apex
if (Reports.get(0) instanceof CustomReport) {
CustomReport c = (CustomReport) Reports.get(0);
} else {
// Do something with the non-custom-report.
}
```

- 좌변이 항상 target 타입 인스턴스면 컴파일 실패(always true):

```apex
Account acc = new Account();
if(acc instanceOf Account) {  // 컴파일 에러
}
```

- String→ID 암시 캐스팅 시 예상 외 동작 가능.
- **Versioned:** API 60.0+ List가 Iterable 구현 시 컴파일 실패(always true). API 32.0+ 좌변 null이면 false 반환(31.0 이하는 true).

```apex
Object o = null;
Boolean result = o instanceof Account;
System.assertEquals(false, result);  // API 32.0+
```

### super

virtual/abstract에서 extend한 클래스가 사용. 부모 생성자·메서드를 override한다.

```apex
public virtual class SuperClass {
public String mySalutation;
public String myFirstName;
public String myLastName;
public SuperClass() {
mySalutation = 'Mr.';
myFirstName = 'Carl';
myLastName = 'Vonderburg';
}
public SuperClass(String salutation, String firstName, String lastName) {
mySalutation = salutation;
myFirstName = firstName;
myLastName = lastName;
}
public virtual void printName() {
System.debug('My name is ' + mySalutation + myLastName);
}
public virtual String getFirstName() {
return myFirstName;
}
}
```

```apex
public class Subclass extends Superclass {
public override void printName() {
super.printName();
System.debug('But you can call me ' + super.getFirstName());
}
}
```

super로 생성자 호출:

```apex
public Subclass() {
super('Madam', 'Brenda', 'Clapentrap');
}
```

**Best Practices:** virtual/abstract에서 extend한 클래스만 super 사용. override 키워드 메서드에서만 super 사용.

### this

두 가지 용법이 있다.

(1) dot notation(괄호 없음) — 현재 인스턴스의 instance 변수·메서드 접근:

```apex
public class myTestThis {
string s;
{
this.s = 'TestString';
}
}
```

(2) 괄호 포함 — constructor chaining:

```apex
public class testThis {
public testThis(string s2) {
}
public testThis() {
this('None');
}
}
```

> chaining 시 this()는 생성자의 첫 statement여야 한다.

### transient

저장 불가·Visualforce view state로 전송 안 되는 instance 변수를 선언한다.

```apex
Transient Integer currentTotal;
```

- serializable Apex 클래스(controller, controller extension, Batchable/Schedulable 구현)에서 사용 가능.
- view state 크기 감소.
- **자동 transient 객체:** PageReferences, XmlStream 클래스, transient 객체 보유 컬렉션(예 Savepoint 컬렉션), system 메서드 생성 객체 대부분(예 Schema.getGlobalDescribe), JSONParser 인스턴스. static 변수도 view state로 전송 안 됨.

```apex
public class ExampleController {
DateTime t1;
transient DateTime t2;
public String getT1() {
if (t1 == null) t1 = System.now();
return '' + t1;
}
public String getT2() {
if (t2 == null) t2 = System.now();
return '' + t2;
}
}
```

### with sharing, without sharing, inherited sharing

with/without sharing은 sharing rule 적용 여부를 지정한다. inherited sharing은 calling 클래스의 sharing 모드로 실행한다. **기본 sharing 모드는 with sharing.**

- **With Sharing:** 현재 user의 sharing rule 적용. 명시 권장. 명시 안 하면 with sharing 기본.

```apex
public with sharing class sharingClass {
// Code here
}
```

- **Without Sharing:** sharing rule 미적용. system-level 접근 필요 클래스만 사용 권장.

```apex
public without sharing class noSharing {
// Code here
}
```

> **Important:** without sharing은 현재 user가 접근 권한 없는 레코드에도 접근할 수 있다.

- **Inherited Sharing:** calling 클래스 sharing rule 적용. 런타임에 sharing 모드 결정. **with sharing 모드로 실행되는 진입점:** Aura component controller, LWC에서 호출된 @AuraEnabled 메서드, Visualforce controller, Apex REST service, 비동기 Apex 클래스, 기타 Apex transaction 진입점. inherited sharing 클래스는 이미 확립된 without sharing context에서 명시적 호출 시에만 without sharing으로 실행.
- **Omitted Sharing:** 명시 선언 없으면 기본 with sharing. 단 부모 클래스 extend 시 부모와 동일 모드 채택.

> **Important:** DB 작업·SOQL 포함 클래스엔 항상 명시 선언 권장.

- **Triggers:** 명시적 sharing 선언 불가. 항상 system 모드·without sharing(sharing rule·FLS·object 권한 우회). business logic을 trigger handler에 위임.
- **기타:** sharing 선언은 object-level/FLS를 강제하지 않는다. inherited sharing 외 메서드의 sharing 모드는 정의 위치 기준(호출 위치 아님). inner/outer 클래스 모두 sharing 모드 선언 가능(inner는 container 모드 미채택). 비동기 inherited sharing 클래스는 항상 with sharing. Anonymous Apex·Connect in Apex는 항상 with sharing.

**Best Practices:**

| Sharing Mode | When to Use |
|---|---|
| with sharing | use case가 달리 요구하지 않는 한 기본으로 |
| without sharing | 주의해 사용. sharing rule이 숨긴 민감 데이터 노출 주의. targeted elevation에 최적 (예 community user에게 레코드 읽기 허용) |
| inherited sharing | 다양한 sharing 모드 지원이 필요한 유연한 service 클래스 |

**Versioned Behavior:** API 67.0+ 명시 선언 없는 클래스는 with sharing 모드로 실행. API 66.0 이하: inheritance chain의 어떤 클래스가 67.0+면 with sharing / Aura controller·LWC @AuraEnabled면 with sharing / 그 외 without sharing / 진입점 아니면 calling 클래스 모드.

> sharing은 sharing rule 적용 여부만 결정하며 object-level 권한·FLS·CRUD 강제 메커니즘은 별도다. 이 보안 강제(예 USER_MODE, stripInaccessible)는 Apex의 Security(보안) 폴더 노트를 참조한다.

### webservice (규칙만)

`webservice` 키워드 자체의 본문은 이 챕터의 Keywords 절에 없다(SOAP Services 챕터에서 별도 문서화). 본 챕터에서 확인되는 관련 규칙만 정리한다.

- webservice 메서드를 포함한 클래스는 **global 선언 필수**.
- webservice 메서드는 **deprecate 불가**.
- **enum은 webservice 시그니처로 사용 가능**(WSDL에 enum·값 정의 포함).
- `webservice`는 예약어 목록에 포함된다([[Apex 언어 기초 — 예외 처리와 예약어]] 참조).

---

## Casting (Classes and Casting)

런타임에 모든 타입 정보가 가용하므로 한 클래스 타입을 다른 클래스 타입에 할당할 수 있다(한쪽이 다른 쪽의 subclass일 때만).

```apex
public virtual class Report {
}
public class CustomReport extends Report {
}
```

```apex
Report[] Reports = new Report[5];
CustomReport a = new CustomReport();
Reports.add(a);
// CustomReport c = Reports.get(0);  // 불법
CustomReport c = (CustomReport) Reports.get(0);
```

- interface 타입은 sub-interface 또는 구현 클래스 타입으로 cast 가능.

**Classes and Collections:** list·map을 클래스·인터페이스와 사용 가능. interface의 child 타입을 컬렉션에 넣기 가능.

**Collection Casting:** 런타임 declared 타입을 보유하므로 collection casting을 허용한다. CustomerPurchaseOrder가 PurchaseOrder의 child면 `List<CustomerPurchaseOrder>`를 `List<PurchaseOrder>`에 할당 가능.

```apex
public virtual class PurchaseOrder {
Public class CustomerPurchaseOrder extends PurchaseOrder {
}
{
List<PurchaseOrder> POs = new PurchaseOrder[] {};
List<CustomerPurchaseOrder> CPOs = new CustomerPurchaseOrder[]{};
POs = CPOs;
}
}
```

> PurchaseOrder로 인스턴스화된 list는 CustomerPurchaseOrder list로 cast 불가(런타임 declared 타입). non-Customer subclass 삽입 시 런타임 예외. Map은 value 측에서 list와 동일 동작.

---

## 보조 규칙

### Apex 클래스와 Java 클래스의 차이

- inner 클래스·인터페이스는 outer 안에 한 단계만.
- static 메서드·변수는 top-level에만(inner 불가).
- inner는 static Java inner처럼 동작(static 키워드 불필요), outer 인스턴스 implicit pointer 없음.
- private가 기본. no modifier = private 동의어.
- public = 애플리케이션/네임스페이스 내 사용.
- global = 접근 가능한 모든 Apex 사용(SOAP API/외부 참조). global 메서드/변수면 클래스도 global.
- 메서드·클래스 기본 final. virtual로 extension·override 허용. override 키워드 명시 필수.
- 인터페이스 메서드는 인터페이스와 동일 modifier(public/global).
- **예외 클래스는 Exception 또는 다른 user-defined exception을 extend해야 함. 이름은 "exception"으로 끝나야 함. 4개의 implicit 생성자 built-in(다른 것 추가 가능).** (상세는 [[Apex 언어 기초 — 예외 처리와 예약어]].)
- 클래스·인터페이스는 trigger·anonymous block에 정의 가능하나 local만.

### Naming Conventions

- Java 표준 권장: 클래스 대문자 시작, 메서드 소문자 동사 시작, 의미 있는 변수명.
- 같은 클래스 내 class·interface 동일 이름 불법. inner가 outer와 동일 이름 불법. 단 변수·메서드·class는 자체 namespace 보유 → 셋이 동일 이름 가능(legal).

### Name Shadowing

- member 변수는 로컬 변수(함수 인자)로 shadow 가능:

```apex
Public Class Shadow {
String s;
Shadow(String s) { this.s = s; } // Same name ok
setS(String s) { this.s = s; } // Same name ok
}
```

- 한 클래스 member 변수가 부모 클래스 동일 이름 member 변수를 shadow 가능. 부모 P의 member M 접근하려면 reference를 P로 먼저 할당.
- static 변수는 클래스 계층 간 shadow 가능. P의 static S 참조하려면 `P.S`.
- static 클래스 변수는 인스턴스로 참조 불가. raw 변수명 또는 클래스명 prefix.

```apex
public class p1 {
public static final Integer CLASS_INT = 1;
public class c { };
}
p1.c c = new p1.c();
// Integer i = c.CLASS_INT;  // illegal
Integer i = p1.CLASS_INT;    // correct
```

### Namespace Precedence

**Namespace Prefix:** managed AppExchange 패키지에서 custom object/field명을 구분한다. 형식: `namespace_prefix__obj_or_field_name__c`. 패키지 메서드 호출: `namespace_prefix.class.method(args)`.

**Using the System Namespace:** Apex 기본 namespace. system 클래스/메서드 호출 시 namespace 생략 가능. (상세는 [[System Namespace]].)

```apex
System.URL url1 = new System.URL('https://MyDomainName.my.salesforce.com/');
// ==
URL url1 = new URL('https://MyDomainName.my.salesforce.com/');
```

**Disambiguation:** custom 클래스가 built-in과 동일 이름이면 System prefix로 구분.

```apex
public class Database {
public static String query() {
return 'wherefore art thou namespace?';
}
}
```

```apex
sObject[] acct = System.Database.query('SELECT Name FROM Account LIMIT 1');
System.debug(acct[0].get('Name'));
```

**Using the Schema Namespace:** schema metadata 클래스/메서드. Schema.* 암시 import. naming conflict 시 fully qualify.

```apex
Schema.DescribeSObjectResult d = Account.sObjectType.getDescribe();
Map<String, Schema.FieldSet> FSMap = d.fieldSets.getMap();
```

```apex
public class Account {
public Integer myInteger;
}
Schema.Account myAccountSObject = new Schema.Account();
Account accountClassInstance = new Account();
```

**Namespace, Class, and Variable Name Precedence** — `name1.name2.[...].nameN` 평가:

1. name1=로컬 변수, name2-nameN=필드 참조 가정.
2. 안 되면 name1=클래스명, name2=static 변수, name3-nameN=필드.
3. 안 되면 name1=namespace, name2=클래스, name3=static 변수, name4-nameN=필드.
4. 안 되면 에러.

괄호로 끝나면(`...nameN()`): 1. name1=로컬, ..., nameN=메서드 호출. 2. 안 되면 (2 identifier면 name1=클래스/name2=메서드, 그 이상이면 name1=클래스/name2=static/...) 3. namespace... 4. 에러.

**Type Resolution:** TypeN 평가: 1. scalar 타입 → 2. locally defined → 3. 클래스 → 4. system 타입(sObject). T1.T2는 inner 타입 T2 또는 namespace T1의 top-level T2(이 우선순위).

### Apex Code Versions

backwards-compatibility를 위해 클래스·trigger는 특정 API 버전과 저장된다. version 미지정 시 latest installed.

- **Versioning:** 추가된 클래스·메서드는 모든 API 버전에서 사용 가능(예외: ConnectApi는 문서 명시 버전만). 가이드라인: latest 권장, 최근 3년 내 버전 사용, 최소 버전 수로 통합.
- **Setting API Version:** Edit → Version Settings → API 버전 선택 → Save. C1→C2 호출 시 필드는 C2 version 기준.

```apex
// Saved using Salesforce API version 13.0 (no Idea.categories field)
global class C2
{
global Idea insertIdea(Idea a) {
insert a;
Idea insertedIdea = [SELECT title FROM Idea WHERE Id =:a.Id];
return insertedIdea;
}
}
```

```apex
@IsTest
// API version 16.0
private class C1
{
static testMethod void testC2Method() {
Idea i = new Idea();
i.CommunityId = '09aD000000004YCIAY';
i.Title = 'Testing Version Settings';
i.Body = 'Categories field is included in API version 16.0';
i.Categories = 'test';
C2 c2 = new C2();
Idea returnedIdea = c2.insertIdea(i);
Idea ideaMoreFields = [SELECT title, categories FROM Idea
WHERE Id = :returnedIdea.Id];
System.assert(i.Categories != null);
System.assert(ideaMoreFields.Categories == null);
}
}
```

- **Setting Package Versions:** managed package subscriber가 버전 지정. (Summer '25+ migrated 2GP도 가능.)

### Custom Types in Map Keys and Sets

custom 클래스를 map 키/값·set 요소로 추가 가능. 키/요소로 쓰면 `equals`·`hashCode` 제공이 필수다.

> **Warning:** 컬렉션 추가 후 object 변경 시 필드 값 변경으로 못 찾는다.

```apex
public Boolean equals(Object obj) {
// Your implementation
}
```

```apex
public Integer hashCode() {
// Your implementation
}
```

**Sample (PairNumbers):**

```apex
public class PairNumbers {
Integer x,y;
public PairNumbers(Integer a, Integer b) {
x=a;
y=b;
}
public Boolean equals(Object obj) {
if (obj instanceof PairNumbers) {
PairNumbers p = (PairNumbers)obj;
return ((x==p.x) && (y==p.y));
}
return false;
}
public Integer hashCode() {
return (31 * x) ^ y;
}
}
```

```apex
Map<PairNumbers, String> m = new Map<PairNumbers, String>();
PairNumbers p1 = new PairNumbers(1,2);
PairNumbers p2 = new PairNumbers(3,4);
PairNumbers p3 = new PairNumbers(1,2);  // Duplicate key
m.put(p1, 'first');
m.put(p2, 'second');
m.put(p3, 'third');
System.assertEquals(2, m.size());
if (p1 == p3) {
System.debug('p1 and p3 are equal.');
}
System.assertEquals(true, m.containsKey(p1));
System.assertEquals(true, m.containsKey(p2));
System.assertEquals(false, m.containsKey(new PairNumbers(5,6)));
for(PairNumbers pn : m.keySet()) {
System.debug('Key: ' + pn);
}
List<String> mValues = m.values();
System.debug('m.values: ' + mValues);
Set<PairNumbers> s1 = new Set<PairNumbers>();
s1.add(p1);
s1.add(p2);
s1.add(p3);
```

> user-defined 타입 list 정렬은 `Comparator` 구현해 `List.sort` 파라미터로 전달하거나 `Comparable` 구현으로 처리한다. locale-sensitive 정렬은 `Collator` 클래스(trigger·특정 순서 기대 코드에선 비권장). 정렬 인터페이스 상세는 [[Comparator 인터페이스]] 참조.

---

## 관련 노트

- [[Apex MOC]]
- [[Apex 언어 기초 — 데이터타입과 변수]]
- [[Apex 언어 기초 — 예외 처리와 예약어]]
- [[Iterable Iterator]]
- [[System Namespace]]
- [[Comparator 인터페이스]]
- [[ApexDoc 주석 작성 가이드]] — 클래스·메서드 선언에 다는 문서화 주석 규칙
- [[Trigger 컨텍스트 변수와 이벤트]] — static 변수 예제에 쓰인 `Trigger.isBefore`·`Trigger.old` 등 트리거 컨텍스트 변수 전체 레퍼런스
- [[platform-apex-generate]] (sf-skill — 실행형) — Apex 클래스·제어 흐름 코드 생성 실행형 스킬
