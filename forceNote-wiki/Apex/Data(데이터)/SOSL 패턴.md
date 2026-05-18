---
tags: [apex, sosl, 검색, data, full-text-search]
source: salesforce_soql_sosl.pdf
created: 2026-05-19
aliases: [SOSL, SOSL 패턴, Salesforce Object Search Language, 전문 검색]
---

# SOSL 패턴

> SOSL(Salesforce Object Search Language)은 여러 Object를 동시에 전문 검색(full-text search)하는 쿼리 언어다.

---

## SOSL 전체 문법 구조

```
FIND {SearchQuery}
[ IN SearchGroup ]
[ RETURNING FieldSpec ]
[ WITH DivisionFilter ]
[ WITH DATA CATEGORY DataCategorySpec ]
[ WITH SNIPPET[(target_length=n)] ]
[ WITH NETWORK NetworkIdSpec ]
[ WITH PricebookId ]
[ WITH METADATA ]
[ LIMIT n ]
[ UPDATE [TRACKING], [VIEWSTAT] ]
```

> [!note] OFFSET과 WHERE는 `RETURNING FieldSpec` 안에 포함된다.

---

## FIND 절 — 검색어 지정

```
FIND {SearchQuery}
```

- 검색어를 중괄호 `{}` 로 감싼다
- 대소문자 구분 없음 (case-insensitive)
- 와일드카드 지원: `*` (0개 이상 문자), `?` (정확히 1개 문자)
- 논리 연산자: `AND`, `OR`, `AND NOT`
- 구문 검색: `"John Smith"` (큰따옴표로 순서 일치)

```apex
// Apex에서 SOSL — 반드시 List<List<SObject>> 로 받음
List<List<SObject>> results = [FIND 'Joe Smith' IN NAME FIELDS
                                RETURNING Lead(Name, Phone), Contact(Name, Phone)];
List<Lead> leads = (List<Lead>) results[0];
List<Contact> contacts = (List<Contact>) results[1];
```

---

## IN 절 — 검색 필드 범위

```
IN { ALL FIELDS | NAME FIELDS | EMAIL FIELDS | PHONE FIELDS | SIDEBAR FIELDS }
```

| 값 | 설명 |
|---|---|
| `ALL FIELDS` (기본값) | 모든 텍스트, 이름, 이메일, 전화 필드 |
| `NAME FIELDS` | 이름 필드만 (Name, FirstName, LastName 등) |
| `EMAIL FIELDS` | 이메일 필드만 |
| `PHONE FIELDS` | 전화번호 필드만 |
| `SIDEBAR FIELDS` | 사이드바 검색에 표시되는 필드 |

> [!note] Article, Document, File, Product 등은 IN 절 무시 — 항상 전체 필드 검색

---

## RETURNING 절 — 반환 Object·필드 지정

```apex
// 단순 반환
FIND {Acme} RETURNING Account, Contact

// 특정 필드 지정
FIND {Acme} RETURNING Account(Id, Name, Phone)

// WHERE 조건 포함
FIND {'Joe Smith'} IN NAME FIELDS
RETURNING Lead(Name, Phone WHERE CreatedDate = THIS_FISCAL_QUARTER)

// 여러 Object + ORDER BY + LIMIT
FIND {test}
RETURNING Account(Id, Name ORDER BY Name ASC LIMIT 50),
          Contact(Id, Name)
```

> [!important] Apex에서는 RETURNING 절이 **필수**다 (선택이 아님).

---

## 검색 결과 한도

| 조건 | 최대 결과 수 |
|---|---|
| 단일 Object 조회 | 250건 (WHERE 또는 ORDER BY 포함 시 최대 2,000건) |
| 복수 Object (n개) | min(2000/n, 250) 건 |
| 전체 최대 | 2,000건 (API v28.0+, 기본값) |

---

## WITH 절 — 필터 옵션

```apex
// WITH DATA CATEGORY — Knowledge 카테고리 필터
FIND {error} RETURNING KnowledgeArticleVersion(Id, Title
    WHERE PublishStatus='online')
WITH DATA CATEGORY Geography__c AT usa__c

// WITH NETWORK — Experience Cloud 사이트 ID 필터
FIND {test} RETURNING Account WITH NETWORK = '0DB000000000001'

// WITH SNIPPET — Knowledge 검색 결과에 스니펫 표시
FIND {salesforce} RETURNING KnowledgeArticleVersion(Title)
WITH SNIPPET(target_length=120)
```

---

## Apex에서 SOSL 사용 패턴

```apex
// 기본 패턴 — 여러 Object 동시 검색
public static void searchRecords(String keyword) {
    String searchTerm = '*' + keyword + '*';
    List<List<SObject>> results = [
        FIND :searchTerm IN ALL FIELDS
        RETURNING
            Account(Id, Name, Phone),
            Contact(Id, Name, Email),
            Lead(Id, Name, Company)
        LIMIT 50
    ];

    List<Account> accounts = (List<Account>) results[0];
    List<Contact> contacts = (List<Contact>) results[1];
    List<Lead> leads = (List<Lead>) results[2];
}

// Search Namespace 사용 (동적 SOSL)
Search.SearchResults searchResults = Search.find('FIND {' + keyword + '} IN NAME FIELDS RETURNING Account, Contact');
```

---

## SOQL vs SOSL 비교표

| 기준 | SOQL | SOSL |
|---|---|---|
| 시작 키워드 | `SELECT` | `FIND` |
| 용도 | 특정 Object 구조적 조회 | 여러 Object 전문 검색 |
| Object 지정 | `FROM Object` 필수 | `RETURNING`으로 선택 지정 |
| 검색 필드 | 모든 필드 | 텍스트/이메일/전화 필드 |
| 반환 타입 | `List<SObject>` | `List<List<SObject>>` |
| WHERE 조건 | 직접 사용 | RETURNING 안에 포함 |
| 쿼리 한도 | 100,000건 | 2,000건 |
| 사용 시기 | 조건이 명확한 레코드 조회 | Object 불명확한 키워드 검색 |

### 언제 SOSL을 쓸까?

- 검색어가 어떤 Object/Field에 있는지 모를 때
- 여러 Object를 동시에 검색할 때 (전역 검색 기능 구현)
- 텍스트 검색이 SOQL WHERE LIKE보다 빠른 속도가 필요할 때
- 한국어·중국어·일본어 등 CJK 텍스트 검색 (형태소 분석 지원)

---

## 관련 노트

- [[SOQL 패턴]] — 구조적 쿼리 패턴
- [[Dynamic SOQL]] — 동적 SOQL 패턴
- [[Search Namespace]] — Search Apex 클래스
