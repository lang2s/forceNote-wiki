---
tags: [Apex, Integration, XML, Streaming, System, XmlStreamReader, XmlStreamWriter, StAX]
source: salesforce_apex_developer_guide, salesforce_apex_reference_guide
created: 2026-07-07
aliases: [XmlStreamReader, XmlStreamWriter, 스트리밍 XML, StAX Apex, XML 스트림 파싱, XML 스트림 생성, getEventType, writeStartElement, setCoalescing]
---

# XmlStreamReader·XmlStreamWriter (스트리밍 XML)

> `System` 네임스페이스의 스트리밍 XML 클래스 — `XmlStreamReader`는 forward, read-only 커서로 XML을 순차 파싱하고, `XmlStreamWriter`는 XML 문서를 순차 생성한다. StAX(Streaming API for XML)의 Apex 대응이며 주로 HTTP 콜아웃 응답 파싱·요청 본문 구성에 쓴다.

---

## 개요

- 두 클래스 모두 네임스페이스 **`System`**. Java의 `XMLStreamReader`/`XMLStreamWriter`(StAX)에 기반한다.
- `XmlStreamReader`는 **forward, read-only** 접근 — 커서가 XML 이벤트를 앞으로만 이동하며, 뒤로 가거나 임의 노드에 랜덤 접근할 수 없다. 최대 **50노드 깊이**의 중첩 XML을 파싱할 수 있다.
- `next`/`hasNext`로 이벤트를 순회하고 `get*` 메서드로 현재 이벤트의 데이터를 읽는다. **`next` 호출 전 항상 `hasNext`로 스트림 끝을 확인**해야 데이터 끝을 넘어 읽는 오류를 피한다.
- `XmlStreamWriter`는 시작 태그·속성·문자·종료 태그를 순서대로 써서 XML을 만들고 `getXmlString()`으로 결과 문자열을 얻은 뒤 `close()`로 자원을 해제한다.

### XML 이벤트 유형

리더가 커서로 가리키는 XML 이벤트:

| 이벤트 | 설명 |
|---|---|
| attribute | 특정 엘리먼트의 속성. 예: `<book title="...">`의 `title` |
| start element | 엘리먼트 여는 태그. 예: `<book>` |
| end element | 엘리먼트 닫는 태그. 예: `</book>` |
| start document | 문서 여는 태그 |
| end document | 문서 닫는 태그 |
| entity reference | 코드 내 엔티티 참조. 예: `!ENTITY title = "My Book Title"` |
| characters | 텍스트 문자 |
| comment | XML 파일 내 주석 |

---

## XmlStreamReader

### 생성자

| 생성자 | 시그니처 | 설명 |
|---|---|---|
| `XmlStreamReader(xmlInput)` | `public XmlStreamReader(String xmlInput)` | 지정한 XML 문자열 입력으로 새 인스턴스 생성. `xmlInput`: XML 문자열 |

```apex
String xmlString = '<books><book>My Book</book><book>Your Book</book></books>';
XmlStreamReader xsr = new XmlStreamReader(xmlString);
```

### 커서 이동 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `next()` | `public Integer next()` | Integer | 다음 XML 이벤트를 읽는다. 프로세서는 연속 문자 데이터를 한 덩어리로 반환하거나 여러 덩어리로 나눌 수 있다. 이벤트 유형을 나타내는 정수 반환 |
| `hasNext()` | `public Boolean hasNext()` | Boolean | 더 읽을 XML 이벤트가 있으면 `true`, 없으면 `false`. 현재 이벤트가 end document면 `false` |
| `nextTag()` | `public Integer nextTag()` | Integer | white space·comment·processing instruction 이벤트를 건너뛰고 start element/end element에 도달할 때까지 이동. 해당 이벤트 인덱스 반환. 그 외 엘리먼트를 만나면 오류 throw |

### 현재 이벤트 조회 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getEventType()` | `public System.XmlTag getEventType()` | System.XmlTag | 커서가 가리키는 XML 이벤트 유형 반환 (아래 XmlTag enum) |
| `getLocalName()` | `public String getLocalName()` | String | 현재 이벤트의 로컬 이름. start/end element면 엘리먼트 로컬 이름, entity reference면 엔티티 이름. 현재 이벤트가 start element·end element·entity reference여야 함 |
| `getLocation()` | `public String getLocation()` | String | 커서의 현재 위치. 알 수 없으면 -1. 위치 정보는 `next` 호출 전까지만 유효 |
| `getPrefix()` | `public String getPrefix()` | String | 현재 XML 이벤트의 prefix, prefix가 없으면 null |
| `getText()` | `public String getText()` | String | 현재 XML 이벤트 값을 문자열로. character 값·comment 값·entity reference 대체값·CDATA 값·space 값·DTD 내부 subset 값 |
| `getVersion()` | `public String getVersion()` | String | XML 선언에 명시된 XML 버전. 없으면 null |

`getText()`의 entity reference 처리 예: `<!ENTITY Title "Salesforce For Dummies">` 아래 `Name &Title;`을 읽으면 `getText`는 `&Title`이 아니라 `Salesforce for Dummies`를 반환한다.

#### XmlTag Enum (getEventType 반환값)

`System.XmlTag`의 값:

- `ATTRIBUTE`
- `CDATA`
- `CHARACTERS`
- `COMMENT`
- `DTD`
- `END_DOCUMENT`
- `END_ELEMENT`
- `ENTITY_DECLARATION`
- `ENTITY_REFERENCE`
- `NAMESPACE`
- `NOTATION_DECLARATION`
- `PROCESSING_INSTRUCTION`
- `SPACE`
- `START_DOCUMENT`
- `START_ELEMENT`

### 속성(attribute) 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getAttributeCount()` | `public Integer getAttributeCount()` | Integer | start element의 속성 개수 (namespace 정의 제외). start element·attribute 이벤트에서만 유효. attribute 이벤트의 카운트는 0부터 시작 |
| `getAttributeLocalName(index)` | `public String getAttributeLocalName(Integer index)` | String | 지정 인덱스 속성의 로컬 이름. 이름이 없으면 빈 문자열. start element·attribute 이벤트에서만 유효 |
| `getAttributeNamespace(index)` | `public String getAttributeNamespace(Integer index)` | String | 지정 인덱스 속성의 namespace URI. namespace가 없으면 null. start element·attribute 이벤트에서만 유효 |
| `getAttributePrefix(index)` | `public String getAttributePrefix(Integer index)` | String | 지정 인덱스 속성의 prefix. prefix가 없으면 null. start element·attribute 이벤트에서만 유효 |
| `getAttributeType(index)` | `public String getAttributeType(Integer index)` | String | 지정 인덱스 속성의 XML 타입 (예: id). start element·attribute 이벤트에서만 유효 |
| `getAttributeValue(namespaceUri, localName)` | `public String getAttributeValue(String namespaceUri, String localName)` | String | 지정 URI의 지정 localName 속성 값. 없으면 null. `localName`은 반드시 지정. start element·attribute 이벤트에서만 유효 |
| `getAttributeValueAt(index)` | `public String getAttributeValueAt(Integer index)` | String | 지정 인덱스 속성의 값. start element·attribute 이벤트에서만 유효 |

### 네임스페이스 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getNamespace()` | `public String getNamespace()` | String | 현재 이벤트가 start/end element면 prefix의 URI 또는 default namespace 반환. prefix가 없으면 null |
| `getNamespaceCount()` | `public Integer getNamespaceCount()` | Integer | start/end element에 선언된 namespace 개수. start element·end element·namespace 이벤트에서만 유효 |
| `getNamespacePrefix(index)` | `public String getNamespacePrefix(Integer index)` | String | 인덱스에 선언된 namespace의 prefix. default namespace 선언이면 null. start/end element·namespace 이벤트에서만 유효 |
| `getNamespaceURI(prefix)` | `public String getNamespaceURI(String prefix)` | String | 주어진 prefix의 URI. 반환 URI는 프로세서의 현재 상태에 따름 |
| `getNamespaceURIAt(index)` | `public String getNamespaceURIAt(Integer index)` | String | 인덱스에 선언된 namespace의 URI. start/end element·namespace 이벤트에서만 유효 |

### Processing Instruction 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getPIData()` | `public String getPIData()` | String | processing instruction의 data 섹션 |
| `getPITarget()` | `public String getPITarget()` | String | processing instruction의 target 섹션 |

### 상태 판별(boolean) 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `hasName()` | `public Boolean hasName()` | Boolean | 현재 이벤트에 이름이 있으면 true. start element·stop element 이벤트에서만 유효 |
| `hasText()` | `public Boolean hasText()` | Boolean | 현재 이벤트에 텍스트가 있으면 true. characters·entity reference·comment·space가 텍스트를 가짐 |
| `isCharacters()` | `public Boolean isCharacters()` | Boolean | 커서가 character data 이벤트를 가리키면 true |
| `isEndElement()` | `public Boolean isEndElement()` | Boolean | 커서가 end tag를 가리키면 true |
| `isStartElement()` | `public Boolean isStartElement()` | Boolean | 커서가 start tag를 가리키면 true |
| `isWhiteSpace()` | `public Boolean isWhiteSpace()` | Boolean | 커서가 전부 white space인 character data 이벤트를 가리키면 true |

### 파서 설정·기타 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `setCoalescing(returnAsSingleBlock)` | `public Void setCoalescing(Boolean returnAsSingleBlock)` | Void | `true`면 텍스트를 한 블록으로 반환(start element부터 첫 end element 또는 다음 start element까지, 먼저 오는 것). `false`면 파서가 여러 블록으로 나눠 반환할 수 있음 |
| `setNamespaceAware(isNamespaceAware)` | `public Void setNamespaceAware(Boolean isNamespaceAware)` | Void | `true`면 파서가 namespace를 인식, `false`면 인식 안 함. 기본값 `true` |
| `toString()` | `public String toString()` | String | XmlStreamReader에 준 입력 XML의 길이와 첫 50자를 담은 문자열 반환 |

---

## XmlStreamWriter

### 생성자

| 생성자 | 시그니처 | 설명 |
|---|---|---|
| `XmlStreamWriter()` | `public XmlStreamWriter()` | 새 인스턴스 생성 (인자 없음) |

### 문서·엘리먼트 작성 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `writeStartDocument(encoding, version)` | `public Void writeStartDocument(String encoding, String version)` | Void | 지정 XML encoding·version으로 XML 선언 작성 |
| `writeStartElement(prefix, localName, namespaceUri)` | `public Void writeStartElement(String prefix, String localName, String namespaceUri)` | Void | `localName`으로 지정한 시작 태그 작성 |
| `writeEmptyElement(prefix, localName, namespaceUri)` | `public Void writeEmptyElement(String prefix, String localName, String namespaceUri)` | Void | 빈 엘리먼트 태그 작성. `localName`은 쓸 태그 이름 |
| `writeEndElement()` | `public Void writeEndElement()` | Void | 종료 태그 작성. writer 내부 상태로 prefix·local name 결정 |
| `writeEndDocument()` | `public Void writeEndDocument()` | Void | 열린 start 태그를 모두 닫고 대응하는 end 태그 작성 |

### 속성·내용 작성 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `writeAttribute(prefix, namespaceUri, localName, value)` | `public Void writeAttribute(String prefix, String namespaceUri, String localName, String value)` | Void | 속성 작성. `localName`은 속성 이름 |
| `writeCharacters(text)` | `public Void writeCharacters(String text)` | Void | 지정 텍스트를 출력 스트림에 작성 |
| `writeCData(data)` | `public Void writeCData(String data)` | Void | 지정 CData를 출력 스트림에 작성 |
| `writeComment(comment)` | `public Void writeComment(String comment)` | Void | 지정 주석 작성 |
| `writeProcessingInstruction(target, data)` | `public Void writeProcessingInstruction(String target, String data)` | Void | 지정 processing instruction 작성 |

### 네임스페이스 작성 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `writeNamespace(prefix, namespaceUri)` | `public Void writeNamespace(String prefix, String namespaceUri)` | Void | 지정 namespace 작성 |
| `writeDefaultNamespace(namespaceUri)` | `public Void writeDefaultNamespace(String namespaceUri)` | Void | 지정 default namespace 작성 |
| `setDefaultNamespace(uri)` | `public Void setDefaultNamespace(String uri)` | Void | 지정 URI를 default namespace에 바인딩. 현재 START_ELEMENT–END_ELEMENT 쌍 범위에 바인딩됨 |

### 출력·종료 메서드

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getXmlString()` | `public String getXmlString()` | String | XmlStreamWriter 인스턴스가 작성한 XML 반환 |
| `close()` | `public Void close()` | Void | 인스턴스를 닫고 연관 자원 해제 |

---

## 예제 1 — 스트리밍 파싱 (XmlStreamReader)

HTTP 응답 등의 XML 문자열을 순회하며 `<book>` 엘리먼트를 파싱한다. `getEventType`으로 이벤트 종류를 판별하고 `hasNext`→`next`로 안전하게 전진한다.

```apex
public class XmlStreamReaderDemo {
    // Create a class Book for processing
    public class Book {
        String name;
        String author;
    }

    public Book[] parseBooks(XmlStreamReader reader) {
        Book[] books = new Book[0];
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            // Start at the beginning of the book and make sure that it is a book
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('Book' == reader.getLocalName()) {
                    // Pass the book to the parseBook method (below)
                    Book book = parseBook(reader);
                    books.add(book);
                }
            }
            // Always use hasNext() before calling next() to confirm
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return books;
    }

    // Parse through the XML, determine the author and the characters
    Book parseBook(XmlStreamReader reader) {
        Book book = new Book();
        book.author = reader.getAttributeValue(null, 'author');
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                book.name = reader.getText();
            }
            // Always use hasNext() before calling next() to confirm
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return book;
    }
}

@isTest
private class XmlStreamReaderDemoTest {
    // Test that the XML string contains specific values
    static testMethod void testBookParser() {
        XmlStreamReaderDemo demo = new XmlStreamReaderDemo();
        String str = '<books><book author="Chatty">Alpha beta</book>' +
            '<book author="Sassy">Baz</book></books>';
        XmlStreamReader reader = new XmlStreamReader(str);
        XmlStreamReaderDemo.Book[] books = demo.parseBooks(reader);
        System.debug(books.size());
        for (XmlStreamReaderDemo.Book book : books) {
            System.debug(book);
        }
    }
}
```

---

## 예제 2 — 스트리밍 생성 (XmlStreamWriter)

XML 문서를 순차로 구성해 문자열로 얻는다. HTTP 콜아웃 요청 본문 구성에 쓴다.

```apex
public class XmlWriterDemo {
    public String getXml() {
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeProcessingInstruction('target', 'data');
        w.writeStartElement('m', 'Library', 'http://www.book.com');
        w.writeNamespace('m', 'http://www.book.com');
        w.writeComment('Book starts here');
        w.setDefaultNamespace('http://www.defns.com');
        w.writeCData('<Cdata> I like CData </Cdata>');
        w.writeStartElement(null, 'book', null);
        w.writedefaultNamespace('http://www.defns.com');
        w.writeAttribute(null, null, 'author', 'Manoj');
        w.writeCharacters('This is my book');
        w.writeEndElement(); //end book
        w.writeEmptyElement(null, 'ISBN', null);
        w.writeEndElement(); //end library
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
        return xmlOutput;
    }
}

@isTest
private class XmlWriterDemoTest {
    static TestMethod void basicTest() {
        XmlWriterDemo demo = new XmlWriterDemo();
        String result = demo.getXml();
        String expected = '<?xml version="1.0"?><?target data?>' +
            '<m:Library xmlns:m="http://www.book.com">' +
            '<!--Book starts here-->' +
            '<![CDATA[<Cdata> I like CData </Cdata>]]>' +
            '<book xmlns="http://www.defns.com" author="Manoj">This is my ' +
            'book</book><ISBN/></m:Library>';
        System.assert(result == expected);
    }
}
```

> 위 예제는 커스텀 오브젝트가 필요하다. AppExchange의 **Apex Tutorials Package**(비관리 패키지)를 설치하면 예제용 코드·오브젝트를 얻을 수 있다.

---

## 언제 스트리밍 vs DOM (Dom.Document)

Apex의 XML 처리는 두 방식이 있다. 스트리밍(`XmlStreamReader`/`XmlStreamWriter`)과 DOM([[Dom Namespace]] — `Dom.Document`/`Dom.XmlNode`).

| 기준 | 스트리밍 (XmlStream*) | DOM (Dom.Document) |
|---|---|---|
| 접근 방식 | forward, read-only 커서 — 앞으로만 이동 | 전체 트리를 메모리에 로드, 노드 랜덤 접근 |
| 적합한 크기 | 대용량·순차 처리 (이벤트 단위로 소비) | 트리 전체가 메모리에 올라감 |
| 랜덤 접근 | 불가 — 지나간 노드로 되돌아갈 수 없음 | 가능 — 부모/자식/형제 노드 자유 탐색 |
| 특정 노드 골라 읽기 | 순회하며 조건 판별 필요 | `getRootElement`·`getChildElement` 등으로 직접 접근 |
| 중첩 깊이 한계 | 최대 50노드 깊이 | Dom도 중첩 노드 최대 50단계 |
| 주 용도 | HTTP 콜아웃 응답을 순차 파싱 / 요청 본문을 순차 생성 | HTTP 요청·응답 본문을 트리로 조작 |

선택 기준:
- **큰 XML을 앞에서부터 훑으며 필요한 값만 뽑거나 건너뛴다** → 스트리밍 (`XmlStreamReader`). 전체를 메모리에 올리지 않아 대용량에 유리하다.
- **문서 여기저기의 노드를 자유롭게 오가며 읽거나 수정한다** → DOM ([[Dom Namespace]]). 트리 탐색·랜덤 접근이 필요할 때.
- **선언적으로 XML↔JSON↔CSV 변환**만 하면 스트림/DOM 대신 [[DataWeave Namespace]]가 더 간결하다.

---

## 관련 노트
- [[Dom Namespace]] — `Dom.Document`/`Dom.XmlNode` DOM 방식 XML 생성·파싱 (스트리밍의 대안)
- [[DataWeave Namespace]] — 선언적 XML/JSON/CSV 변환 (StAX/DOM 없이 포맷 변환)
- [[Http·HttpRequest·HttpResponse 레퍼런스]] — 콜아웃 요청·응답 본문에 스트리밍 XML을 실어보내고 받는 표준 클래스
