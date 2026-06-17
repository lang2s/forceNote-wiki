---
tags: [Service, Knowledge, 지식, SOAP-API, API호출, describeKnowledge, describeDataCategoryGroups, search, SOSL]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch2 PDF p65–79)
created: 2026-06-17
aliases: [describeKnowledgeSettings, describeDataCategoryGroups, describeDataCategoryGroupStructures, search SOSL call, Knowledge SOAP 호출, data category describe, SearchResult, KnowledgeSettings 호출]
---

# Knowledge SOAP API 호출

> Knowledge 관련 SOAP API 4개 호출 — describeKnowledge(), describeDataCategoryGroups(), describeDataCategoryGroupStructures(), search() — 의 시그니처·인자·반환 타입·Java/C# 예제를 전수 정리한다.

---

## 호출 목록

| 호출 | 설명 |
|---|---|
| `describeKnowledge()` | 조직의 Knowledge 언어 설정을 조회. |
| `describeDataCategoryGroups()` | 요청에 지정된 객체에 대한 사용 가능한 category group 조회. |
| `describeDataCategoryGroupStructures()` | category group과 그 data category 구조를 함께 조회. |
| `search()` | 조직의 데이터에 대해 text 검색을 실행. |

---

## 1. describeKnowledge()

조직의 Knowledge 언어 설정(기본 Knowledge 언어, 지원 언어, 언어 정보 목록)을 조회한다.

**Syntax:**

```
KnowledgeSettings result = _connection.describeKnowledgeSettings();
```

**Usage:** 기존 Knowledge 언어 설정을 describe하는 데 쓴다. Metadata API의 KnowledgeSettings로도 유사 정보를 얻을 수 있다.

**Sample Code — Java:** (기본 Knowledge 언어와 지원 언어 목록을 언어 코드·활성 상태와 함께 반환)

```java
public void describeKnowledgeSettingsSample() {
try {
// Make the describe call for KnowledgeSettings
KnowledgeSettings result = connection.describeKnowledgeSettings();
// Get the properties of KnowledgeSettings
System.out.println("Knowledge default language: " + result.getDefaultLanguage());
for (KnowledgeLanguageItem lang : result.getLanguages()) {
System.out.println("Language: " + lang.getName());
System.out.println("Active: " + lang.isActive());
}
} catch (ConnectionException ex) {
ex.printStackTrace();
}
}
```

**Sample Code — C#:**

```csharp
public void describeKnowledgeSettingsSample() {
try {
// Make the describe call for KnowledgeSettings
KnowledgeSettings result = connection.describeKnowledgeSettings();
// Get the properties of KnowledgeSettings
Console.WriteLine("Knowledge default language: " + result.getDefaultLanguage());
for (KnowledgeLanguageItem lang : result.getLanguages()) {
Console.WriteLine("Language: " + lang.getName());
Console.WriteLine("Active: " + lang.isActive());
}
} catch (SoapException ex) {
ex.printStackTrace();
}
}
```

**Response:** KnowledgeSettings

---

## 2. describeDataCategoryGroups()

요청에 지정된 객체에 대한 사용 가능한 category group을 조회한다.

**Syntax:**

```
DescribeDataCategoryGroupResult[] = connection.describeDataCategoryGroups()(string[] sObjectTypes);
```

**Usage:** 지정 객체에 대한 사용 가능한 category group을 describe한다. `describeDataCategoryGroupStructures()`와 함께 써서 특정 객체에 사용 가능한 모든 category를 describe할 수 있다.

**Sample Code — Java:** (Salesforce Knowledge 아티클과 Answers의 Question에 연관된 data category group을 조회; group의 name·label·description, 연관 sobject 이름, data category 수를 반환)

```java
public void describeDataCategoryGroupsSample() {
try {
// Make the describe call for data category groups
DescribeDataCategoryGroupResult[] results =
connection.describeDataCategoryGroups(new String[] {
"KnowledgeArticleVersion", "Question"});
// Get the properties of each data category group
for (int i = 0; i < results.length; i++) {
System.out.println("sObject: " +
results[i].getSobject());
System.out.println("Group name: " +
results[i].getName());
System.out.println("Group label: " +
results[i].getLabel());
System.out.println("Group description: " +
(results[i].getDescription()==null? "" :
results[i].getDescription()));
System.out.println("Number of categories: " +
results[i].getCategoryCount());
}
} catch (ConnectionException ce) {
ce.printStackTrace();
}
}
```

**Sample Code — C#:**

```csharp
public void describeDataCategoryGroups() {
try {
// Make the describe call for data category groups
DescribeDataCategoryGroupResult[] results =
binding.describeDataCategoryGroups(new String[] {
"KnowledgeArticleVersion", "Question"});
// Get the properties of each data category group
for (int i = 0; i < results.Length; i++) {
Console.WriteLine("sObject: " +
results[i].sobject);
Console.WriteLine("Group name: " +
results[i].name);
Console.WriteLine("Group label: " +
results[i].label);
Console.WriteLine("Group description: " +
(results[i].description==null? "" :
results[i].description));
Console.WriteLine("Number of categories: " +
results[i].categoryCount);
}
} catch (SoapException e) {
Console.WriteLine("An unexpected error has occurred: " +
e.Message + "\n" + e.StackTrace);
}
}
```

**Arguments:**

| Name | Type | Description |
|---|---|---|
| sObjectTypes | string[] | 지정 값: **KnowledgeArticleVersion**(article type에 연관된 category group 조회), **Question**(question에 연관된 category group 조회). |

**Response:** DescribeDataCategoryGroupResult
**Faults:** InvalidSObjectFault, UnexpectedErrorFault

**DescribeDataCategoryGroupResult** — describeDataCategoryGroups()가 반환. 지정 객체에 연관된 category group 목록을 담는다.

| Name | Type | Description |
|---|---|---|
| categoryCount | int | data category group 내 보이는 data category 수. |
| description | string | data category group의 설명. |
| label | string | Salesforce UI에서의 data category group label. |
| name | string | API 접근에 쓰이는 data category group의 고유 이름. |
| sobject | string | data category group에 연관된 객체. |

---

## 3. describeDataCategoryGroupStructures()

요청에 지정된 객체에 대한 category group과 그 data category 구조를 함께 조회한다.

**Syntax:**

```
describeDataCategoryGroupStructures()[] = connection.
describeDataCategoryGroupStructures()(DataCategoryGroupSObjectTypePair[] pairs, boolean topCategoriesOnly)
```

**Usage:** 주어진 객체-category group 쌍에 대해 보이는 data category 구조를 반환한다. 먼저 `describeDataCategoryGroups()`로 객체에 사용 가능한 category group을 찾고, 반환된 목록에서 객체-category group 쌍을 골라 input으로 전달한다. 이 호출은 보이는 모든 category와 data category 구조를 output으로 반환한다.

**Sample Code — Java:** (sObject와 data category group 쌍으로 각 쌍의 data category를 조회; KnowledgeArticleVersion/Regions, Question/Regions 두 쌍으로 호출; top category("All")와 1차 child category를 가져옴. knowledge article·question에 연관된 child category를 가진 "Regions" data category group 필요)

```java
public void describeDataCateogryGroupStructuresSample() {
try {
// Create the data category pairs
DataCategoryGroupSobjectTypePair pair1 =
new DataCategoryGroupSobjectTypePair();
DataCategoryGroupSobjectTypePair pair2 =
new DataCategoryGroupSobjectTypePair();
pair1.setSobject("KnowledgeArticleVersion");
pair1.setDataCategoryGroupName("Regions");
pair2.setSobject("Question");
pair2.setDataCategoryGroupName("Regions");
DataCategoryGroupSobjectTypePair[] pairs =
new DataCategoryGroupSobjectTypePair[] {
pair1,
pair2
};
// Get the list of top level categories using the describe call
DescribeDataCategoryGroupStructureResult[] results =
connection.describeDataCategoryGroupStructures(
pairs,
false
);
// Iterate through each result and get some properties
// including top categories and child categories
for (int i = 0; i < results.length; i++) {
DescribeDataCategoryGroupStructureResult result =
results[i];
String sObject = result.getSobject();
System.out.println("sObject: " + sObject);
System.out.println("Group name: " + result.getName());
System.out.println("Group label: " + result.getLabel());
System.out.println("Group description: " +
result.getDescription());
// Get the top-level categories
DataCategory[] topCategories = result.getTopCategories();
// Iterate through the top level categories and retrieve
// some information
for (int j = 0; j < topCategories.length; j++) {
DataCategory topCategory = topCategories[j];
System.out.println("Category name: " +
topCategory.getName());
System.out.println("Category label: " +
topCategory.getLabel());
DataCategory [] childCategories =
topCategory.getChildCategories();
System.out.println("Child categories: ");
for (int k = 0; k < childCategories.length; k++) {
System.out.println("\t" + k + ". Category name: " +
childCategories[k].getName());
System.out.println("\t" + k + ". Category label: " +
childCategories[k].getLabel());
}
}
}
} catch (ConnectionException ce) {
ce.printStackTrace();
}
}
```

**Sample Code — C#:** (동일 시나리오; C# 예제는 dataCategoryGroupName = "KBArticleCategories"를 쓰며 "Regions" 줄은 주석 처리됨 — PDF 원문 그대로)

```csharp
public void describeDataCateogryGroupStructuresSample() {
try {
// Create the data category pairs
DataCategoryGroupSobjectTypePair pair1 =
new DataCategoryGroupSobjectTypePair();
DataCategoryGroupSobjectTypePair pair2 =
new DataCategoryGroupSobjectTypePair();
pair1.sobject = "KnowledgeArticleVersion";
//pair1.setDataCategoryGroupName("Regions");
pair1.dataCategoryGroupName = "KBArticleCategories";
pair2.sobject = "Question";
//pair2.setDataCategoryGroupName("Regions");
pair2.dataCategoryGroupName = "KBArticleCategories";
DataCategoryGroupSobjectTypePair[] pairs =
new DataCategoryGroupSobjectTypePair[] {
pair1,
pair2
};
// Get the list of top level categories using the describe call
DescribeDataCategoryGroupStructureResult[] results =
binding.describeDataCategoryGroupStructures(
pairs,
false
);
// Iterate through each result and get some properties
// including top categories and child categories
for (int i = 0; i < results.Length; i++) {
DescribeDataCategoryGroupStructureResult result =
results[i];
String sObject = result.sobject;
Console.WriteLine("sObject: " + sObject);
Console.WriteLine("Group name: " + result.name);
Console.WriteLine("Group label: " + result.label);
Console.WriteLine("Group description: " +
result.description);
// Get the top-level categories
DataCategory[] topCategories = result.topCategories;
// Iterate through the top level categories and retrieve
// some information
for (int j = 0; j < topCategories.Length; j++) {
DataCategory topCategory = topCategories[j];
Console.WriteLine("Category name: " +
topCategory.name);
Console.WriteLine("Category label: " +
topCategory.label);
DataCategory [] childCategories =
topCategory.childCategories;
Console.WriteLine("Child categories: ");
for (int k = 0; k < childCategories.Length; k++) {
Console.WriteLine("\t" + k + ". Category name: " +
childCategories[k].name);
Console.WriteLine("\t" + k + ". Category label: " +
childCategories[k].label);
}
}
}
}
catch (SoapException e)
{
Console.WriteLine("An unexpected error has occurred: " +
e.Message + "\n" + e.StackTrace);
}
}
```

**Arguments:**

| Name | Type | Description |
|---|---|---|
| pairs | DataCategoryGroupSObjectTypePair[] | query할 category group과 객체를 지정. 그 객체에 대해 보이는 data category를 조회. |
| topCategoriesOnly | boolean | top category만 반환(true)할지, 사용자의 data category group visibility 설정에 따른 모든 category를 반환(false)할지 표시. |

**DataCategoryGroupSObjectTypePair 필드:**

| Name | Type | Description |
|---|---|---|
| dataCategoryGroupName | string | API 접근에 쓰이는 data category group의 고유 이름. |
| sobject | string | data category group에 연관된 객체. |

**Response:** describeDataCategoryGroupStructures()
**Faults:** InvalidSObjectFault, UnexpectedErrorFault

**describeDataCategoryGroupStructures() (result 객체)** — 지정 객체에 연관된 category group과 category를 담은 DescribeDataCategoryGroupStructureResult 객체 배열을 반환.

| Name | Type | Description |
|---|---|---|
| description | string | data category group의 설명. |
| label | string | Salesforce UI에서의 data category group label. |
| name | string | API 접근에 쓰이는 data category group의 고유 이름. |
| sobject | string | data category group에 연관된 객체. |
| topCategories | DataCategory[] | 사용자의 data category group visibility 설정에 따라 보이는 top level category 목록. |

**DataCategory:**

| Name | Type | Description |
|---|---|---|
| childDataCategories | DataCategory[] | data category 내 보이는 하위 category의 재귀 목록. |
| label | string | Salesforce UI에서의 data category label. |
| name | string | API 접근에 쓰이는 data category의 고유 이름. |

---

## 4. search()

조직의 데이터에 대해 text 검색을 실행한다.

**Syntax:**

```
SearchResult = connection.search(String searchString);
```

**Usage:** search string으로 레코드를 검색한다. search 호출은 custom 객체 검색을 지원한다(구문·규칙은 [[SOSL 패턴]] 참조). Attachment 객체 등 일부 객체는 API로 검색할 수 없다. search() 호출로 객체를 검색하려면 객체가 searchable(isSearchable=true)로 구성되어야 한다. 객체가 검색 가능한지 확인하려면 describeSObjects()를 호출하고 searchable 프로퍼티를 검사한다.

**Sample Code — Java:** (SOSL query를 전달해 전화번호 field에 값이 있는 contact·lead·account를 반환; type별 배열에 레코드 저장 후 콘솔 출력)

```java
public void searchSample() {
try {
// Perform the search using the SOSL query.
SearchResult sr = connection.search(
"FIND {4159017000} IN Phone FIELDS RETURNING "
+ "Contact(Id, Phone, FirstName, LastName), "
+ "Lead(Id, Phone, FirstName, LastName), "
+ "Account(Id, Phone, Name)");
// Get the records from the search results.
SearchRecord[] records = sr.getSearchRecords();
ArrayList<Contact> contacts = new ArrayList<Contact>();
ArrayList<Lead> leads = new ArrayList<Lead>();
ArrayList<Account> accounts = new ArrayList<Account>();
// For each record returned, find out if it's a
// contact, lead, or account and add it to the
// appropriate array, then write the records
// to the console.
if (records.length > 0) {
for (int i = 0; i < records.length; i++) {
SObject record = records[i].getRecord();
if (record instanceof Contact) {
contacts.add((Contact) record);
} else if (record instanceof Lead) {
leads.add((Lead) record);
} else if (record instanceof Account) {
accounts.add((Account) record);
}
}
System.out.println("Found " + contacts.size() + " contacts.");
for (Contact c : contacts) {
System.out.println(c.getId() + ", " + c.getFirstName() + ", "
+ c.getLastName() + ", " + c.getPhone());
}
System.out.println("Found " + leads.size() + " leads.");
for (Lead d : leads) {
System.out.println(d.getId() + ", " + d.getFirstName() + ", "
+ d.getLastName() + ", " + d.getPhone());
}
System.out.println("Found " + accounts.size() + " accounts.");
for (Account a : accounts) {
System.out.println(a.getId() + ", " + a.getName() + ", "
+ a.getPhone());
}
} else {
System.out.println("No records were found for the search.");
}
} catch (Exception ce) {
ce.printStackTrace();
}
}
```

**Sample Code — C#:**

```csharp
public void searchSample()
{
try
{
// Perform the search using the SOSL query.
SearchResult sr = binding.search(
"FIND {4159017000} IN Phone FIELDS RETURNING "
+ "Contact(Id, Phone, FirstName, LastName), "
+ "Lead(Id, Phone, FirstName, LastName), "
+ "Account(Id, Phone, Name)");
// Get the records from the search results.
SearchRecord[] records = sr.searchRecords;
List<Contact> contacts = new List<Contact>();
List<Lead> leads = new List<Lead>();
List<Account> accounts = new List<Account>();
// For each record returned, find out if it's a
// contact, lead, or account and add it to the
// appropriate array, then write the records
// to the console.
if (records.Length > 0)
{
for (int i = 0; i < records.Length; i++)
{
sObject record = records[i].record;
if (record is Contact)
{
contacts.Add((Contact)record);
}
else if (record is Lead)
{
leads.Add((Lead)record);
}
else if (record is Account)
{
accounts.Add((Account)record);
}
}
Console.WriteLine("Found " + contacts.Count + " contacts.");
foreach (Contact c in contacts)
{
Console.WriteLine(c.Id + ", " +
c.FirstName + ", " +
c.LastName + ", " +
c.Phone);
}
Console.WriteLine("Found " + leads.Count + " leads.");
foreach (Lead d in leads)
{
Console.WriteLine(d.Id + ", " +
d.FirstName + ", " +
d.LastName + ", " +
d.Phone);
}
Console.WriteLine("Found " + accounts.Count + " accounts.");
foreach (Account a in accounts)
{
Console.WriteLine(a.Id + ", " +
a.Name + ", " +
a.Phone);
}
}
else
{
Console.WriteLine("No records were found for the search.");
}
}
catch (SoapException e)
{
Console.WriteLine("An unexpected error has occurred: " +
e.Message + "\n" + e.StackTrace);
}
}
```

**Arguments:**

| Name | Type | Description |
|---|---|---|
| search | string | 검색할 text 표현식, 검색 field 범위, 조회할 객체·field 목록, 반환 최대 레코드 수를 지정하는 search string. ([[SOSL 패턴]]) |

**Response:** SearchResult
**Fault:** InvalidFieldFault, InvalidSObjectFault, MalformedSearchFault, UnexpectedErrorFault

### search() 반환 타입 계층

**SearchResult** — search() 호출이 반환.

| Name | Type | Description |
|---|---|---|
| queryId | string | SOSL 검색의 고유 식별자. |
| searchRecords | SearchRecord[] | 각각 sObject를 담은 SearchRecord 객체 배열. |
| searchResultsMetadata | SearchResultsMetadata | SearchRecords에 대한 metadata. |

**SearchRecord** — 검색에서 반환된 개별 레코드.

| Name | Type | Description |
|---|---|---|
| record | sObject | 검색이 반환한 개별 레코드. |
| searchRecordMetadata | SearchRecordMetadata | searchRecords에 대한 metadata. |
| snippet | SearchSnippet | 검색 결과 페이지에서 search string과 일치하는 term을 주변 text 안에 highlight해 보여줌. |

**SearchRecordMetadata** — 레코드 수준 검색 결과 metadata.

| Name | Type | Description |
|---|---|---|
| searchPromoted | boolean | 아티클이 검색 결과에서 promote되었음을 표시. 관리자는 knowledge article에 promoted term을 추가해 promoted search term을 정의. 사용자가 그 keyword로 검색하면 해당 아티클이 먼저 표시됨. API v42.0+. |
| spellCorrected | boolean | 레코드가 spell-corrected search term과 일치함을 표시. true일 때만 응답에 나타남. |

**SearchSnippet** — article·case·feed·idea 검색의 결과 페이지에 보이는 발췌.

| Name | Type | Description |
|---|---|---|
| text | string | search term 일치를 담은 발췌. |
| wholeFields | WholeFields | highlight된 field 목록. |

**WholeFields** — search query와 일치하는 term의 highlight를 담은 각 field의 전체 text. highlight된 term은 `<mark>` 태그로 둘러싸임.

| Name | Type | Description |
|---|---|---|
| name | string | highlight된 field의 이름. |
| value | string | highlight된 text. |

**SearchResultsMetadata** — 검색 결과의 전역 metadata.

| Name | Type | Description |
|---|---|---|
| entityMetadata | EntitySearchMetadata | 객체 수준의 검색 결과 metadata. |

**EntitySearchMetadata** — 객체 수준 검색 결과 metadata.

| Name | Type | Description |
|---|---|---|
| fieldMetadata | FieldLevelSearchMetadata | field 수준 검색 결과 metadata. |
| searchPromotedMetadata | EntitySearchPromotionMetadata | 객체 수준의 search term promotion metadata. API v42.0+. |
| spellCorrectionMetadata | EntitySpellCorrectionMetadata | 객체 수준의 spelling correction metadata. |
| entityName | string | 객체를 식별. |

**FieldLevelSearchMetadata** — field 수준 검색 결과 metadata.

| Name | Type | Description |
|---|---|---|
| name | string | field 이름. |
| label | string | field label. |
| type | string | field 유형. |

**EntitySearchPromotionMetadata** — 객체 수준의 search term promotion metadata. 객체에 대해 최소 한 개 아티클이 promote된 결과일 때만 응답에 나타남. API v42.0+.

| Name | Type | Description |
|---|---|---|
| promotedResultCount | int | 객체 수준에서 promote된 아티클 결과 수. |

**EntitySpellCorrectionMetadata** — 객체 수준의 spelling correction metadata. 객체에 대해 최소 한 개 레코드가 spell-corrected search term과 일치할 때만 응답에 나타남.

| Name | Type | Description |
|---|---|---|
| correctedQuery | string | spell-corrected search term. |
| hasNonCorrectedResults | boolean | true면 사용자가 spell-correct되지 않은 search term과 일치하는 레코드에 최소 하나 접근 가능함을 표시. 객체마다 다른 값을 반환하기도 함. |

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]
- [[Knowledge REST API — Search & Support]]
- [[SOSL 패턴]]
- [[SOQL WITH DATA CATEGORY]]
