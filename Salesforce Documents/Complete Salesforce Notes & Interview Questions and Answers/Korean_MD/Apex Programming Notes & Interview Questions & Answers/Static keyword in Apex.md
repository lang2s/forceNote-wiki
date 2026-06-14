# Apex의 Static 키워드

> (원본은 이미지 PDF로 OCR 추출했습니다.)

Static은 두 가지 경우에만 사용됩니다: 변수(Variables), 메서드(Methods).

**간단히:** Static = 클래스의 모든 인스턴스 간에 공유됨.

- 클래스(Class) = 청사진/개념(예: "Person")
- 오브젝트(Objects) = 실제 인스턴스(실제 사람들)

```apex
public class Person {
    public String name;
    public Integer age;
}
Person p1 = new Person(); p1.name = 'Alex'; p1.age = 25;
Person p2 = new Person(); p2.name = 'John'; p2.age = 30;
```

## Static 변수

모든 사람이 공유하는 것은? 행성(planet)입니다. 만약 planet을 일반 변수로 두면 각 사람이 자신만의 행성을 가질 수 있어(p1.planet='Earth 1', p2.planet='Earth 2') 논리적으로 잘못됩니다.

대신 planet 변수를 static으로 만들면 Person 타입의 모든 오브젝트 간에 공유됩니다.
```apex
public class Person {
    public String name;
    public Integer age;
    public static String planet;
}
Person.planet = 'Earth'; // 클래스 이름으로 접근
```

추가 예시: `Person.planet = 'Earth';`, `Car.carsProduced = 18001;`, `BatchCleanup.contactsRemoved = 319291;` (변수명은 클래스 이름으로 접근).

## Static 메서드

- 메서드 = 오브젝트에 대한 동작
- Static 메서드 = 모든 오브젝트 간에 공유되는 동작

예: 두 사람이 같은 세대인지 확인하는 메서드(특정 사람에게 속하지 않음).
```apex
public class Person {
    public String name;
    public Integer age;
    public static String planet;
    public static Boolean isSameGeneration(Person person1, Person person2) {
        return (person1.age - person2.age) <= 15;
    }
}
```

## Static을 사용해야 하는지 판단

- 메서드가 클래스 인스턴스 없이 존재할 수 있는가? → 아니오면 static 아님.
- 어노테이션이 static을 요구하는가? → 아니오면 static 아님.
