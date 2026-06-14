# Wrapper Class (Salesforce)

## Apex의 Wrapper Class란?

여러 데이터 타입이나 오브젝트를 하나의 단위로 캡슐화하는 커스텀 클래스입니다. 보통 표준·커스텀 오브젝트를 추가 속성(예: 체크박스용 Boolean 플래그)과 결합하는 데 사용됩니다. Visualforce, LWC, Aura 컴포넌트에서 데이터를 동적으로 표시하고 사용자 상호작용을 추적할 때 특히 유용합니다.

## 장점

- **여러 데이터 소스 결합:** 직접 관련 없는 필드·오브젝트를 그룹화해 복잡한 데이터 처리가 쉬움.
- **사용자 상호작용 향상:** 원본 데이터를 수정하지 않고 선택(체크박스) 추적·임시 상태 관리.
- **동적 UI 단순화:** Visualforce 등에서 커스텀 데이터 표시에 유용.
- **유연한 데이터 처리:** 원본 스키마 변경 없이 계산 필드·임시 변수 추가.
- **코드 구성 개선:** 관련 로직·속성을 캡슐화해 모듈식·가독성 높은 코드.

## 단점

- **메모리 사용 증가:** 새 오브젝트 생성으로 대량 작업 시 성능 문제 가능.
- **대량 작업 복잡성:** DML 시 wrapper에서 기반 오브젝트를 추출해야 함.
- **디버깅 복잡성:** 추가 추상화 계층.
- **UI 외 제한적 사용:** 백엔드·비동기 프로세스에는 덜 유용.

## 사용 사례 예시

도서관 관리 시스템에서 책 목록을 이름·저자·상태(Available, Checked Out, Reserved)와 함께 표시하고, 각 책을 체크박스로 선택할 수 있게 합니다.

```apex
public class LibraryManagementController {
    public class BookWrapper {
        public Book__c book { get; set; }
        public Boolean isSelected { get; set; }
        public BookWrapper(Book__c book) {
            this.book = book;
            this.isSelected = false;
        }
    }
    public List<BookWrapper> books { get; set; }
    public LibraryManagementController() {
        books = new List<BookWrapper>();
        for (Book__c book : [SELECT Id, Name, Author__c, Status__c FROM Book__c]) {
            books.add(new BookWrapper(book));
        }
    }
}
```

Visualforce 페이지:
```html
<apex:page controller="LibraryManagementController">
<apex:form>
    <apex:pageBlock title="Books">
        <apex:pageBlockTable value="{!books}" var="bookWrapper">
            <apex:column headerValue="Select">
                <apex:inputCheckbox value="{!bookWrapper.isSelected}" />
            </apex:column>
            <apex:column value="{!bookWrapper.book.Name}" headerValue="Book Name" />
            <apex:column value="{!bookWrapper.book.Author__c}" headerValue="Author" />
            <apex:column value="{!bookWrapper.book.Status__c}" headerValue="Status" />
        </apex:pageBlockTable>
    </apex:pageBlock>
</apex:form>
</apex:page>
```
