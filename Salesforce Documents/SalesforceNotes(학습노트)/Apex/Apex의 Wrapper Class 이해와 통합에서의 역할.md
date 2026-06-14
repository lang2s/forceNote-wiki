---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Understanding Wrapper classes in Apex]
---

# Apex의 Wrapper Class 이해와 통합에서의 역할

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Wrapper class는 여러 변수나 데이터 타입을 하나의 오브젝트로 그룹화하는 커스텀 클래스입니다. 여러 관련 값을 함께 담는 컨테이너로, 복잡한 데이터 구조를 다루기 쉽게 합니다.

## 구조

속성(변수)과 선택적으로 메서드를 가진 사용자 정의 클래스입니다.
```apex
public class WrapperClassExample {
    public String name { get; set; }
    public Integer age { get; set; }
    public WrapperClassExample(String name, Integer age) {
        this.name = name;
        this.age = age;
    }
}
```
여기서 name과 age가 하나의 WrapperClassExample 오브젝트로 묶입니다.

## 통합에서의 역할

Salesforce와 외부 시스템 간 복잡한 데이터를 주고받을 때 중요한 역할을 합니다.

**1. JSON/XML 데이터 파싱:** 많은 API가 JSON/XML로 데이터를 교환합니다. Wrapper class로 그 구조를 표현하며, JSON.deserialize()/serialize()와 잘 작동합니다.
```apex
public class ApiResponseWrapper {
    public String status;
    public String message;
    public List<String> errors;
}
String jsonResponse = '{"status": "success", "message": "Processed", "errors": ["Error1", "Error2"]}';
ApiResponseWrapper response = (ApiResponseWrapper) JSON.deserialize(jsonResponse, ApiResponseWrapper.class);
System.debug(response.message); // Processed
```

**2. 데이터 변환:** 외부 시스템에 보내기 전 Salesforce 데이터를 필요한 구조로 변환하거나, 들어오는 데이터를 Salesforce 오브젝트에 맞게 변환.

**3. 복잡한 요청·응답 처리:** 중첩·계층 데이터 구조를 캡슐화.
```apex
public class ParentWrapper {
    public String parentId;
    public List<ChildWrapper> children;
    public class ChildWrapper {
        public String childId;
        public String childName;
    }
}
```

**4. 배치 처리:** 여러 데이터 요소를 단일 API 요청·응답으로 그룹화.

**5. 코드 가독성 개선:** 데이터를 캡슐화해 코드 정리, 유지보수성 향상.

## 통합에서 언제 사용하나요?

- API가 중첩·계층 데이터 구조를 포함할 때
- 여러 Salesforce 오브젝트·필드를 API 페이로드로 결합할 때
- 복잡한 JSON/XML을 파싱·직렬화할 때
- 외부 시스템과 상호작용하는 동적·커스텀 로직 구현 시
