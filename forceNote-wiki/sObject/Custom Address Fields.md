---
tags: [sobject-reference, custom-address-fields, compound-fields, address, geocode, metadata-api, rest-api, soap-api, tooling-api, apex]
source: caf_dev.pdf (Custom Address Fields Developer Guide, v66.0 Spring '26)
created: 2026-06-18
aliases: [Custom Address Fields, 커스텀 주소 필드, Address custom field, Mailing_Address__City__s, __s 서브필드, enableCustomAddressField, CustomAddressFieldSettings, AddressSettings, Use custom address fields, fieldsToNull, GeoCodeExample, geocode, 지오코드, CustomField Tooling API, MailingAddress__c, caf__c, 주소 필드를 코드로 만들기, 커스텀 주소 필드 생성, 커스텀 compound 필드 REST로 생성, Address 타입 커스텀 필드, 커스텀 주소 필드에 geocode 추가, 커스텀 주소 필드 Apex 쿼리, create custom Address field via API]
---

# Custom Address Fields

> `Address` 필드 타입의 **커스텀 compound 필드**. 표준 주소 필드 동작을 모방하며 표준·커스텀 오브젝트 모두에 추가 가능. 단일 구조 필드 또는 개별 컴포넌트 필드(`__s` 서브필드)로 접근. **커스텀 주소 필드 1개 = 커스텀 필드 9개 소비.** 표준 주소 필드와 달리 자동 지오코딩·DISTANCE·다수 기능이 제한됨.

---

## 개요 (Ch1)

`Address` 필드 타입으로 주소 데이터를 **구조화된 compound 데이터 타입**으로 저장하는 커스텀 필드를 만든다. Compound 필드는 값을 다루는 애플리케이션 코드를 단순화하는 추상화로, 더 간결하고 이해하기 쉬운 코드로 이어진다. Custom Address Fields를 사용하면 커스텀 주소가 **단일 구조 필드** 또는 **개별 컴포넌트 필드**로 접근 가능하다.

- **Available in: all editions**
- Address compound 필드는 원래 표준 오브젝트의 표준 필드로 제공된다. Custom Address Fields를 통해 이제 **커스텀 필드가 표준 주소 필드 동작을 모방(mirror)** 할 수 있다.
- 최종 사용자는 표준·커스텀 오브젝트의 커스텀 Address 필드를 통해 주소 데이터를 추가·조회할 수 있다. 레코드에서 커스텀 주소 필드 데이터를 편집하고, list view·report에서 커스텀 주소 데이터를 볼 수 있다.

> [!note] 활성화 전 [[#요구사항 및 제한 (Ch2) — 3그룹 전수|Custom Address Fields Requirements and Limitations]]를 검토하라. 기능 논의·질문은 Trailblazer Community의 Custom Address Fields Discussion 그룹에서 가능.

### 9 custom field 소비

> [!important] 커스텀 compound 필드의 경우 **각 컴포넌트가 org allocation에서 커스텀 필드 1개로 계산된다.** 따라서 **커스텀 주소 필드 하나는 9개의 커스텀 필드로 계산**된다 — street, city, postal code, country code, state code, geocode accuracy level, longitude, latitude 각 1개 + 내부 사용(internal use) 1개. org의 allocation 정보는 Salesforce Help의 *Salesforce Features and Edition Allocations* 참조.

---

## 요구사항 및 제한 (Ch2) — 3그룹 전수

Custom Address Fields를 활성화하기 전에 State·Country/Territory 피클리스트를 구성하고 이 기능의 제한을 검토한다. **Available in: all editions.**

### 요구사항 (Requirements)

**Requirement: State and Country/Territory Picklists**
Custom Address Fields는 State·Country 주소 필드에 **피클리스트를 사용**한다. 자세한 내용은 [[#State·Country Picklist 설정 (Ch3)|Configure State and Country/Territory Picklists]] 참조.

**Requirement: Package Deployment**
패키지에 `Address` 필드 타입의 커스텀 필드가 포함되어 있으면, **패키지 배포 시 대상 org에서 Custom Address Fields가 활성화되어 있어야 한다.**

**Custom Address Fields and Org Limits**
커스텀 compound 필드의 경우 각 컴포넌트가 org allocation에서 커스텀 필드 1개로 계산된다. 따라서 각 커스텀 주소 필드는 **9개의 커스텀 필드로 계산**된다 — street, city, postal code, country code, state code, geocode accuracy level, longitude, latitude 각 1개 + 내부 사용 1개.

### 그룹 ① — 지원 안 됨 (not supported, 14항목)

> These items aren't supported with custom address fields.

| # | 지원 안 되는 항목 |
|---|---|
| 1 | The conversion of address data into custom fields of type Address from custom fields of other types. (다른 타입의 커스텀 필드를 `Address` 타입 커스텀 필드로 주소 데이터 변환) |
| 2 | Approvals |
| 3 | Data Import Wizard |
| 4 | Fuzzy matching |
| 5 | Composite API |
| 6 | Field Encryption |
| 7 | Field Sets |
| 8 | Flow Screen Input Component: Address |
| 9 | Lead Conversion |
| 10 | Lightning Web Components |
| 11 | Merge Fields |
| 12 | Search, including global search, lookup search, SOSL queries, and Search Manager |
| 13 | Visualforce pages |
| 14 | Workflow |

### 그룹 ② — 검증 안 됨 (not validated, 6항목)

> Salesforce hasn't validated custom address fields with these items.

| # | 검증되지 않은 항목 |
|---|---|
| 1 | Schema Builder |
| 2 | Web-to-Case and Email-to-Case |
| 3 | Generating Leads from Your Website |
| 4 | Filtering in a related list |
| 5 | Bulk API 1.0 |
| 6 | Data Loader |

### 그룹 ③ — 불가·제한 (unavailable or limited, 14항목)

> This functionality is either unavailable or limited with Custom Address Fields.

| # | 불가·제한 항목 |
|---|---|
| 1 | As with standard address fields, you can't mark a custom address field as required. (표준 주소 필드처럼 커스텀 주소 필드를 required로 표시할 수 없다.) |
| 2 | **You can't use the DISTANCE function with a custom address field.** |
| 3 | To export data stored in custom fields of type Address, use API or SOQL queries. Bulk API doesn't support the export of custom compound fields. |
| 4 | The error message when you attempt to export a custom address field with Bulk API incorrectly states that the functionality isn't enabled. Bulk API doesn't support the export of custom compound fields. |
| 5 | To populate a custom address field with imported data, use REST API or Bulk API 2.0. |
| 6 | Search queries only support the data stored within the Street component of custom fields of type Address. The State, City, Postal Code, and Country components aren't supported for search. |
| 7 | In Skinny Tables, you can't select a component of a custom address field as partition column. |
| 8 | When configuring search results for an object, custom address fields aren't supported in Search Filter Fields (only available in Salesforce Classic). If you specify a custom address field as a Search Filter Field in a search layout, package installation and Metadata deploy() fails. |
| 9 | Compound address fields aren't supported in reports. To include a custom address field in a report, add the individual address components, such as street, city, state, and zip. |
| 10 | When using a custom address field in a Data Integration Rule, the Country and State components are unavailable for field mapping. |
| 11 | You can't rename the labels for the individual components of a custom address field. |
| 12 | You can localize the label of a custom address field. However, you can't localize the labels of the individual components within a custom address field. |
| 13 | The word "Address" isn't appended to the section label for a custom address field. If you include the word "Address" in the field label, it's included in the label for every component. For example, "Warehouse Address (State)" instead of "Warehouse (State)". These labels are inconsistent with the label behavior for standard address fields. |
| 14 | **The length of the GeoCodeAccuracy field for custom fields of data type Address isn't consistent with standard field of type Address.** |

### 표준 vs 커스텀 주소 필드 — 3대 차이

위 제한에서 도출되는, 표준 주소 필드 대비 커스텀 주소 필드의 핵심 차이 3가지:

| # | 차이 | 근거 |
|---|---|---|
| 1 | **DISTANCE 함수 불가** | 그룹 ③-2 — 커스텀 주소 필드에는 `DISTANCE` 함수를 쓸 수 없다. (표준 주소 필드는 가능) |
| 2 | **자동 지오코딩 없음** | Ch5 — geocode를 얻는 방법이 표준과 다르며, 커스텀 주소 필드는 Apex·Visualforce·map API로 **수동** 추가해야 한다. |
| 3 | **GeoCodeAccuracy 길이 불일치** | 그룹 ③-14 — `Address` 데이터 타입 커스텀 필드의 `GeoCodeAccuracy` 필드 길이가 표준 `Address` 타입 필드와 일치하지 않는다. |

---

## State·Country Picklist 설정 (Ch3)

Custom Address Fields는 State·Country 주소 필드에 피클리스트를 사용한다. 커스텀 주소 필드를 활성화하기 전에 State·Country/Territory 피클리스트를 구성한다.

- **Available in: all editions except Database.com.** (Database.com 제외)
- State·Country/Territory 피클리스트가 **이미 활성화되어 있으면**, 그 피클리스트 값이 표준 주소 필드에 사용된다. Custom Address Fields에서는 **같은 피클리스트 값이 커스텀 주소 필드에 자동으로 사용 가능**해진다. 표준과 커스텀 주소 필드에 **별도의 피클리스트 값을 지정할 수 없다.**
- State·Country/Territory 피클리스트가 **활성화되어 있지 않으면**, Custom Address Fields로 커스텀 주소 필드에 대해 그 피클리스트들이 활성화된다. 기본적으로 모든 국가·영토와 그 주·도가 사용자에게 표시된다. Salesforce에서 사용 가능한 피클리스트 값을 지정하려면 State·Country/Territory 피클리스트를 구성한다.
- 이 피클리스트 값을 구성해도, **Setup을 통해 표준 필드용 State·Country/Territory 피클리스트를 활성화하지 않는 한 표준 주소 필드의 동작은 영향받지 않는다.** Custom Address Fields를 사용하기 위해 표준 필드용 피클리스트를 활성화할 필요는 없다.
- 피클리스트 구성은 **`AddressSettings` Metadata API**([[State and Country Picklist]] 참조)를 사용하거나, Salesforce Help의 *Configure State and Country/Territory Picklists* 참조.
- 표준 주소 필드용 피클리스트 활성화 세부는 Salesforce Help의 *Let Users Select States, Countries, and Territories from Picklists* 참조.

---

## 활성화 (Ch4)

기능 제한을 검토하고 State·Country/Territory 피클리스트를 구성한 후 Custom Address Fields 기능을 활성화한다.

- **Available in:** both Salesforce Classic (not available in all orgs) and Lightning Experience
- **Available in: all editions**
- **USER PERMISSIONS** — To modify user interface settings: **Customize Application**

**Setup에서 활성화:**

1. Setup의 Quick Find 박스에 **User Interface**를 입력하고 **User Interface**를 선택한다.
2. Setup 섹션에서 **Use custom address fields**를 선택하고 변경 사항을 저장한다.
   - 활성화 후에는 Object Manager로 필드를 추가할 때 **`Address` 데이터 타입을 사용할 수 있다.**

> [!warning] **This feature can't be disabled.** (이 기능은 비활성화할 수 없다.)

**Metadata API로 활성화:** `CustomAddressFieldSettings` 메타데이터 타입의 **`enableCustomAddressField`** 필드를 사용한다.

`CustomAddressFieldSettings`는 `Metadata` 메타데이터 타입을 확장(extends)하며 `fullName`을 상속한다. 값은 settings 폴더의 단일 파일 **`CustomAddressField.settings`**에 저장되며(settings 컴포넌트당 파일 1개), **API 버전 55.0 이상**에서 사용 가능하다. package manifest에서는 다른 settings 타입과 마찬가지로 `Settings` 이름으로 접근한다.

| 필드 | 필드 타입 | 설명 |
|---|---|---|
| `enableCustomAddressField` | `boolean` | Address Field Type을 커스텀 필드에 사용할 수 있는지(`true`) 여부. **기본값 `false`.** Custom Address Fields는 비활성화할 수 없다 — `true`로 설정한 뒤에는 `false`로 되돌릴 수 없다. (활성화 전 Salesforce Help의 *Custom Address Fields Requirements and Limitations* 검토 필요) |

**선언적 메타데이터 샘플** (`CustomAddressField.settings`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomAddressFieldSettings xmlns="http://soap.sforce.com/2006/04/metadata">
<enableCustomAddressField>true</enableCustomAddressField>
</CustomAddressFieldSettings>
```

**package.xml** — 위 정의를 참조하는 매니페스트. member는 `CustomAddressField`, name은 `Settings`, version은 **55.0**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
<types>
<members>CustomAddressField</members>
<name>Settings</name>
</types>
<version>55.0</version>
</Package>
```

> [!note] **State·Country 피클리스트 구성**은 [[State and Country Picklist]]의 `AddressSettings` 메타데이터 타입을 참조한다 — 활성화 전 선행 요구사항.

---

## Geocode 수동 추가 (Ch5)

geocode를 얻는 방법은 표준과 커스텀 주소 필드 간에 다르다. 사용자에게 정밀한 지리 정보를 제공하려면 **Apex, Visualforce, map API**로 커스텀 주소 필드에 geocode 정보를 추가한다.

- **Available in:** both Salesforce Classic (not available in all orgs) and Lightning Experience
- **Available in: all editions**
- **User Permissions Needed** — To modify user interface settings: **Customize Application**

**1. Apex 클래스 생성** — 선호하는 map API에서 위도·경도를 조회한다. 이 예제는 `String` 변수 `endpoint`에 정의된 Google Map API를 호출한다.

```apex
public class GeoCodeExample {
    @future(callout=true)
    public static void parseJSONResponse() {
        double lat;
        double lng;
        String city = null;
        String street = null;
        String stateCode = null;
        String countryCode = null;

        Account record = [SELECT Mailing_Address__c FROM Account
        WHERE Id = 'Account ID'];
        Address customAddress = record.Mailing_Address__c;

        //Remove white spaces from address components
        if(customAddress.getCity() != null){
            city = customAddress.getCity().deleteWhitespace();
        }
        if(customAddress.getStreet() != null){
            street = customAddress.getStreet().deleteWhitespace();

        }
        if(customAddress.getStateCode() != null){
            stateCode = customAddress.getStateCode();
        }
        if(customAddress.getCountryCode() != null){
            countryCode = customAddress.getCountryCode();
        }

        //concatenate strings
        String address = street+city+stateCode+countryCode;

        String key='API key';
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        // USING GOOGLE MAP API
        String endpoint =
'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key;

        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);

        // Parse JSON response to get all the totalPrice field values.
        // ↑ 원문 오타: geocode 응답과 무관한 "totalPrice" 잔존 주석(원문 그대로)
        JSONParser parser = JSON.createParser(response.getBody());

        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)
              &&
                (parser.getText() == 'lat')) {
                parser.nextToken();
                // Get latitude
                lat = parser.getDoubleValue();

                parser.nextToken();
                parser.nextToken();
                //Get longitude
                lng = parser.getDoubleValue();
            }
        }
        // Update lat long of account record
        record.Mailing_Address__Latitude__s=lat;
        record.Mailing_Address__Longitude__s=lng;
        update record;
    }
}
```

핵심 동작:
- `@future(callout=true)` — 외부 map API callout을 위한 비동기 future 메서드 (→ [[Future 메서드]])
- compound 필드 `Mailing_Address__c`를 `Address` 타입으로 조회 후 `getCity()` / `getStreet()` / `getStateCode()` / `getCountryCode()` 게터로 컴포넌트 접근
- `deleteWhitespace()`로 city·street 공백 제거 후 문자열 연결
- `JSONParser`로 `lat` 필드를 찾아 위도·경도 파싱
- write-back: `Mailing_Address__Latitude__s` / `Mailing_Address__Longitude__s`에 값 대입 후 `update record;`

**2. Visualforce 페이지 생성** — map API의 geocode 서비스를 트리거한다.

```html
<apex:page id="pg" controller="GeoCodeExample">
<apex:form >
    <apex:pageBlock id="pb">
        <apex:pageBlockButtons >
            <apex:commandButton value="Get GeoCode For Custom Address Field"
            action="{!parseJSONResponse}"/>
        </apex:pageBlockButtons>
    </apex:pageBlock>
</apex:form>
</apex:page>
```

**3.** Visualforce 페이지에서 **Get GeoCode For Custom Address Field**를 클릭해 코드를 트리거한다. 위도·경도 값이 채워진 것을 보려면 Developer Console에서 account 정보를 쿼리한다.

커스텀 주소 필드를 위도·경도로 자동 업데이트하려면, **trigger를 설정**해 Apex 클래스를 호출한다.

> [!note] 이 토픽의 예제는 위도·경도 조회에 **서드파티 map API**를 사용한다. Salesforce trigger로 이 Apex 클래스를 호출하면 클래스가 호출될 때마다 map API를 호출하므로 **API 제공자로부터 요금이 발생할 수 있다.**

---

## API별 CRUD 예제 (Ch6–10)

5개 API가 커스텀 주소 필드를 다루는 방식은 표기·메커니즘이 서로 다르다. 먼저 비교표로 차이를 잡고, 각 API별 전체 예제를 본다.

### API 비교표

각 API의 실제 표기·메커니즘을 셀에 그대로 보존(✅/❌ 압축 아님):

| API | 서브필드 표기 / 핵심 식별자 | 생성 | 업데이트 | **주소 데이터 삭제** (레코드 유지) | 레코드 삭제 |
|---|---|---|---|---|---|
| **Apex** | `Mailing_Address__City__s` 등 `__s` 접미사 서브필드 (8개) | `insert a;` | `update o;` | 8개 서브필드에 `= null` 대입 후 `update` | `delete a;` |
| **Metadata** | `<fullName>MailingAddress__c</fullName>` (**언더스코어 없음**), `<type>Address</type>` | CustomObject `<fields>`로 필드 자체 생성 (레코드 아님) | — | — | — |
| **REST** | JSON `"Mailing_Address__City__s"` 등 / 엔드포인트 `/services/data/66.0/sobjects/Account[/{id}]` | POST `newaccount.json` | PATCH `patchaccount.json` | **각 서브필드 `null` PATCH** (8개) | DELETE method |
| **SOAP** | `<Mailing_Address__City__s>` 엘리먼트 / namespace 4종 | `<urn:create>` Envelope | `<urn:update>` Envelope | **`<urn:fieldsToNull>` 7개 엘리먼트** (GeocodeAccuracy 제외) | `<urn:delete>` Envelope |
| **Tooling** | **레코드가 아니라 `CustomField` 메타데이터** 조회 / `FullName:"Account.caf__c"`, `Metadata.type:"Address"`, `DeveloperName` | — | — | — | — (조회 전용: describe + query) |

> [!important] **주소 데이터 삭제 방식이 REST와 SOAP에서 다르다.**
> - **REST**: request body의 각 서브필드를 `null`로 PATCH한다 (`"Mailing_Address__City__s" : null` 등, **8개** — GeocodeAccuracy 포함).
> - **SOAP**: `<urn:fieldsToNull>` 엘리먼트로 null 처리할 필드명을 나열한다 (**7개** — Street/City/PostalCode/StateCode/CountryCode/Latitude/Longitude. **GeocodeAccuracy는 원문에서 제외**됨).

### Apex 예제 (Ch6)

Apex 예제는 커스텀 주소 데이터로 레코드를 생성하고, 기존 레코드의 커스텀 주소를 업데이트하고, 커스텀 주소 데이터를 포함한 레코드를 삭제한다. **Available in: all editions.**

8개 서브필드: `Mailing_Address__City__s` · `__StateCode__s` · `__CountryCode__s` · `__Street__s` · `__PostalCode__s` · `__Latitude__s` · `__Longitude__s` · `__GeocodeAccuracy__s` (모두 `__s` 접미사).

**Insert a Record** — 커스텀 주소 필드 "Mailing Address"에 주소 데이터를 저장한 Opportunity 레코드 생성.

```apex
Opportunity a = new Opportunity();
a.StageName='Prospecting';
a.CloseDate=System.today();
a.Name = 'Dublin Order';
a.Mailing_Address__StateCode__s='CA';
a.Mailing_Address__CountryCode__s='US';
a.Mailing_Address__Street__s='1234 Dublin Blvd';
a.Mailing_Address__PostalCode__s='12345';
a.Mailing_Address__City__s='Dublin';
a.Mailing_Address__Latitude__s=80.34;
a.Mailing_Address__Longitude__s=80.35;
a.Mailing_Address__GeocodeAccuracy__s='Address';
insert a;
```

커스텀 오브젝트 "Gas Station" (`Gas_Station__c`)에 레코드를 추가. 새 레코드는 커스텀 주소 필드 "Mailing Address"에 주소 데이터를 포함한다. (원문: "the the custom address field" — 오타 그대로)

```apex
Gas_Station__c a = new Gas_Station__c();
a.Name = 'Amador Valley';
a.Mailing_Address__StateCode__s='CA';
a.Mailing_Address__CountryCode__s='US';
a.Mailing_Address__Street__s='1234 Dublin Blvd';
a.Mailing_Address__PostalCode__s='12345';
a.Mailing_Address__City__s='Dublin';
a.Mailing_Address__Latitude__s=80.34;
a.Mailing_Address__Longitude__s=80.35;
a.Mailing_Address__GeocodeAccuracy__s='Address';
insert a;
```

**Update an Existing Record** — ID `006XXXXXXXXXXXXXXX`인 Opportunity 레코드의 커스텀 주소 필드 "Mailing Address" 업데이트.

```apex
Opportunity o = [select Id from Opportunity where
Id='006XXXXXXXXXXXXXXX'];
o.Mailing_Address__StateCode__s='CA';
o.Mailing_Address__CountryCode__s='US';
o.Mailing_Address__Street__s='1234 Dublin Blvd';
o.Mailing_Address__PostalCode__s='12345';
o.Mailing_Address__City__s='Dublin';
o.Mailing_Address__Latitude__s=80.34;
o.Mailing_Address__Longitude__s=80.35;
o.Mailing_Address__GeocodeAccuracy__s='Address';
update o;
```

ID `aIsXXXXXXXXXXXXXXX`인 커스텀 오브젝트 "Gas Station" (`Gas_Station__c`)의 기존 레코드 업데이트.

```apex
Gas_Station__c a = [select Id from Gas_Station__c where
Id='aIsXXXXXXXXXXXXXXX'];
a.Mailing_Address__StateCode__s='CA';
a.Mailing_Address__CountryCode__s='US';
a.Mailing_Address__Street__s='1234 Dublin Blvd';
a.Mailing_Address__PostalCode__s='12345';
a.Mailing_Address__City__s='Dublin';
a.Mailing_Address__Latitude__s=80.34;
a.Mailing_Address__Longitude__s=80.35;
a.Mailing_Address__GeocodeAccuracy__s='Address';
update a;
```

**Delete Data Within a Custom Address Field from a Record** — 커스텀 주소 필드의 데이터를 삭제하려면 레코드를 **업데이트**한다. ID `006XXXXXXXXXXXXXXX`인 Opportunity의 "Mailing Address" 데이터 제거. (8개 서브필드 모두 `null`)

```apex
Opportunity o = [select Id from Opportunity where
Id='006XXXXXXXXXXXXXXX'];
o.Mailing_Address__StateCode__s= null;
o.Mailing_Address__CountryCode__s= null;
o.Mailing_Address__Street__s=null;
o.Mailing_Address__PostalCode__s=null;
o.Mailing_Address__City__s=null;
o.Mailing_Address__Latitude__s=null;
o.Mailing_Address__Longitude__s=null;
o.Mailing_Address__GeocodeAccuracy__s=null;
update o;
```

**Delete a Record** — ID `aIsXXXXXXXXXXXXXXX`인 커스텀 오브젝트 "Gas Station" (`Gas_Station__c`) 레코드 삭제. 레코드 삭제 시 커스텀 주소 필드 정보를 포함한 그 레코드의 모든 데이터가 삭제된다.

```apex
Gas_Station__c a = [select Id from Gas_Station__c where
Id='aIsXXXXXXXXXXXXXXX'];
delete a;
```

### Metadata API 예제 (Ch7)

오브젝트에 커스텀 주소 필드를 **생성**하려면 Metadata API를 사용한다. 이 예제는 Account 오브젝트에 `Address` 타입 커스텀 필드를 생성한다.

- `<fullName>MailingAddress__c</fullName>` — **언더스코어 없음** (`Mailing_Address`가 아님)
- `<type>Address</type>`
- namespace: `http://soap.sforce.com/2006/04/metadata`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">

    <fields>
        <fullName>MailingAddress__c</fullName>
        <externalId>false</externalId>
        <label>Mailing Address</label>
        <required>false</required>
        <type>Address</type>
        <unique>false</unique>
   </fields>
 </CustomObject>
```

### REST API 예제 (Ch8)

REST API로 Custom Address Fields 데이터를 가진 레코드를 생성·업데이트·삭제한다. 엔드포인트는 `/services/data/66.0/sobjects/Account[/{id}]`.

**Create a New Account** — sObject 리소스를 사용해 새 레코드를 생성한다. request data에 필수 필드 값을 넣고 **POST** HTTP method로 전송한다. 성공 시 response body에 새 레코드 ID가 담긴다.

```bash
curl
https://MyDomainName.my.salesforce.com/services/data/66.0/sobjects/Account
 -H "Authorization: Bearer token" -H "Content-Type:
application/json" -d "@newaccount.json"
```

`newaccount.json` request body:

```json
{
"Name" : "Acme Incorporated",
"Mailing_Address__City__s" : "Ahmedabad",
"Mailing_Address__CountryCode__s" : "IN",
"Mailing_Address__Street__s" : "102 Suryakoti",
"Mailing_Address__PostalCode__s" : "380022",
"Mailing_Address__StateCode__s": "GJ",
"Mailing_Address__Latitude__s" : "37.775",
"Mailing_Address__Longitude__s" : "-122.418",
"Mailing_Address__GeocodeAccuracy__s" : "Address"
}
```

성공 응답:

```json
{
    "id" : "001XXXXXXXXXXXXXXX",
    "errors" : [ ],
    "success" : true
}
```

**Update Data Within a Custom Address Field on a Record** — sObject Rows 리소스를 사용한다. 특정 레코드 ID로 **PATCH** method를 사용한다. 한 파일의 레코드는 동일 오브젝트 타입이어야 한다. ID `001XXXXXXXXXXXXXXX` 업데이트.

```bash
curl
https://MyDomainName.my.salesforce.com/services/data/66.0/sobjects/Account/001XXXXXXXXXXXXXXX
 -H "Authorization: Bearer token" -H "Content-Type:
application/json" -d @patchaccount.json -X PATCH
```

`patchaccount.json` request body:

```json
{
"Mailing_Address__City__s" : "Surendranagar",
"Mailing_Address__CountryCode__s" : "IN",
"Mailing_Address__Street__s" : "20 Udhyog Nagar",
"Mailing_Address__PostalCode__s" : "363001",
"Mailing_Address__StateCode__s": "GJ",
"Mailing_Address__Latitude__s" : "22.757580",
"Mailing_Address__Longitude__s" : "71.619350",
"Mailing_Address__GeocodeAccuracy__s" : "Address"
}
```

성공 응답: **None returned**

**Delete Data Within a Custom Address Field on a Record** — 커스텀 주소 필드의 주소 데이터를 삭제하려면 sObject Rows 리소스로 레코드를 **업데이트(PATCH)** 한다. ID `001XXXXXXXXXXXXXXX`. (curl은 update와 동일)

```bash
curl
https://MyDomainName.my.salesforce.com/services/data/66.0/sobjects/Account/001XXXXXXXXXXXXXXX
 -H "Authorization: Bearer token" -H "Content-Type:
application/json" -d @patchaccount.json -X PATCH
```

`patchaccount.json` request body — **각 서브필드를 `null`로 PATCH** (8개):

```json
{
"Mailing_Address__City__s" : null,
"Mailing_Address__CountryCode__s" : null,
"Mailing_Address__Street__s" : null,
"Mailing_Address__PostalCode__s" : null,
"Mailing_Address__StateCode__s": null,
"Mailing_Address__Latitude__s" : null,
"Mailing_Address__Longitude__s" : null,
"Mailing_Address__GeocodeAccuracy__s" : null
}
```

성공 응답: **None returned**

**Delete a Record That Contains Data in a Custom Address Field** — sObject Rows 리소스로 레코드 ID를 지정하고 **DELETE** method를 사용한다. 레코드 삭제 시 커스텀 주소 필드 정보를 포함한 모든 데이터가 삭제된다. ID `001XXXXXXXXXXXXXXX`.

```bash
curl
https://MyDomainName.my.salesforce.com/services/data/66.0/sobjects/Account/001XXXXXXXXXXXXXXX
   -H "Authorization: Bearer token" -X DELETE
```

request body: **None needed** / 성공 응답: **200 OK**

### SOAP API 예제 (Ch9)

SOAP API로 Custom Address Fields 데이터를 가진 레코드를 생성·업데이트·삭제한다. namespace 4종:
- `soapenv` → `http://schemas.xmlsoap.org/soap/envelope/`
- `urn` → `urn:enterprise.soap.sforce.com`
- `urn1` → `urn:sobject.enterprise.soap.sforce.com`
- `xsi` → `http://www.w3.org/2001/XMLSchema-instance`

**Create a New Account** — Mailing Address 커스텀 주소 필드에 주소 데이터를 저장한 Account 레코드 생성.

```xml
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:urn="urn:enterprise.soap.sforce.com"
    xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
        <urn:SessionHeader>
            <urn:sessionId>$0XXXXXXXXXXXXXXX</urn:sessionId>
        </urn:SessionHeader>
    </soapenv:Header>
    <soapenv:Body>
        <urn:create>
            <urn:sObjects xsi:type="urn1:Account"> <!--Zero or more
repetitions:-->
                <Name>Puneet Ahmedabad Account</Name>
                <Mailing_Address__City__s>Ahmedabad</Mailing_Address__City__s>
                <Mailing_Address__Street__s>102
Suryakoti</Mailing_Address__Street__s>
                <Mailing_Address__PostalCode__s>380022</Mailing_Address__PostalCode__s>
                <Mailing_Address__StateCode__s>GJ</Mailing_Address__StateCode__s>
                <Mailing_Address__CountryCode__s>IN</Mailing_Address__CountryCode__s>
                <Mailing_Address__Latitude__s>37.775</Mailing_Address__Latitude__s>
                <Mailing_Address__Longitude__s>-122.418</Mailing_Address__Longitude__s>
            </urn:sObjects>
        </urn:create>
    </soapenv:Body>
</soapenv:Envelope>
```

**Update Data Within a Custom Address Field on a Record** — ID `001XXXXXXXXXXXXXXX`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:urn="urn:enterprise.soap.sforce.com"
    xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
        <urn:SessionHeader>
            <urn:sessionId>$0XXXXXXXXXXXXXXX</urn:sessionId>
        </urn:SessionHeader>
    </soapenv:Header>
    <soapenv:Body>
        <urn:update>
            <urn:sObjects xsi:type="urn1:Account">
                <Id>$001XXXXXXXXXXXXXXX</Id>
                <Mailing_Address__Street__s>20 Udhyog
Nagar</Mailing_Address__Street__s>
                <Mailing_Address__City__s>Surendranagar</Mailing_Address__City__s>
                <Mailing_Address__PostalCode__s>363001</Mailing_Address__PostalCode__s>
                <Mailing_Address__StateCode__s>GJ</Mailing_Address__StateCode__s>
                <Mailing_Address__CountryCode__s>IN</Mailing_Address__CountryCode__s>
                <Mailing_Address__Latitude__s>22.757580</Mailing_Address__Latitude__s>
                <Mailing_Address__Longitude__s>71.619350</Mailing_Address__Longitude__s>
            </urn:sObjects>
        </urn:update>
    </soapenv:Body>
</soapenv:Envelope>
```

**Delete Data Within a Custom Address Field from a Record** — 주소 데이터를 삭제하려면 레코드를 **업데이트**한다. ID `001XXXXXXXXXXXXXXX`. 삭제는 **`<urn:fieldsToNull>` 7개 엘리먼트**로 처리한다 — Street/City/PostalCode/StateCode/CountryCode/Latitude/Longitude. **GeocodeAccuracy는 원문에서 제외**(7개 그대로)이며, 이는 REST의 8개 `null` PATCH 방식과 다르다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:urn="urn:enterprise.soap.sforce.com"
    xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
        <urn:SessionHeader>
            <urn:sessionId>$0XXXXXXXXXXXXXXX</urn:sessionId>
        </urn:SessionHeader>
    </soapenv:Header>
    <soapenv:Body>
        <urn:update>
            <urn:sObjects xsi:type="urn1:Account">
                <Id>$001XXXXXXXXXXXXXXX</Id>
                <Name>Acc updated</Name>
                <urn:fieldsToNull>Mailing_Address__Street__s</urn:fieldsToNull>
                <urn:fieldsToNull>Mailing_Address__City__s</urn:fieldsToNull>
                <urn:fieldsToNull>Mailing_Address__PostalCode__s</urn:fieldsToNull>
                <urn:fieldsToNull>Mailing_Address__StateCode__s</urn:fieldsToNull>
                <urn:fieldsToNull>Mailing_Address__CountryCode__s</urn:fieldsToNull>
                <urn:fieldsToNull>Mailing_Address__Latitude__s</urn:fieldsToNull>
                <urn:fieldsToNull>Mailing_Address__Longitude__s</urn:fieldsToNull>
            </urn:sObjects>
        </urn:update>
    </soapenv:Body>
</soapenv:Envelope>
```

**Delete a Record That Contains Data in a Custom Address Field** — ID `001XXXXXXXXXXXXXXX`. 레코드 삭제 시 커스텀 주소 필드 정보를 포함한 모든 데이터가 삭제된다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:urn="urn:enterprise.soap.sforce.com"
    xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
        <urn:SessionHeader>
           <urn:sessionId>$0XXXXXXXXXXXXXXX</urn:sessionId>
        </urn:SessionHeader>
  </soapenv:Header>
  <soapenv:Body>
      <urn:delete>
          <Id>$001XXXXXXXXXXXXXXX</Id>
      </urn:delete>
   </soapenv:Body>
</soapenv:Envelope>
```

### Tooling API 예제 (Ch10)

Custom Address Fields로 생성된 필드의 정보(예: developer name)를 조회하려면 Tooling API를 사용한다. **레코드가 아니라 `CustomField` 메타데이터를 조회**한다는 점이 다른 API와 다르다.

**Get Information About a Custom Address Field (describe)** — `CustomField` REST HTTP **GET** method로 `Mailing_Address__c` 커스텀 주소 필드(CustomField ID `00NXXXXXXXXXXXXXXX`) 정보를 조회한다.

```bash
curl
https://MyDomainName.my.salesforce.com/services/data/66.0/tooling/sobjects/CustomField/00NXXXXXXXXXXXXXXX
  -H "Authorization: Bearer token
```

> [!warning] **원문 오타 2건 (describe 요청):**
> - 마지막 헤더 `"Authorization: Bearer token` 의 **닫는 따옴표 `"` 누락** (원문 그대로)
> - 그 외 요청 URL은 `data/66.0`으로 정상이나, 아래 **응답 body의 `url`은 `dataa66.0` (data 뒤 `a`)** 오타 (원문 그대로)

응답:

```json
{
   "attributes": {
       "type": "CustomField",
       "url":
"https://MyDomainName.my.salesforce.com/services/dataa66.0/tooling/sobjects/CustomField/00NXXXXXXXXXXXXXXX"

    },
    "Id": "00NXXXXXXXXXXXXXXX",
    "TableEnumOrId": "Account",
    "DeveloperName": "caf",
    "Description": null,
    "Length": null,
    "Precision": 18,
    "Scale": 15,
    "RelationshipLabel": null,
    "SummaryOperation": null,
    "InlineHelpText": null,
    "MaskType": null,
    "MaskChar": null,
    "NamespacePrefix": null,
    "ManageableState": "unmanaged",
    "CreatedDate": "2021-04-07T06:57:22.000+0000",
    "CreatedById": "005XXXXXXXXXXXXXXX",
    "LastModifiedDate": "2021-04-07T06:57:22.000+0000",
    "LastModifiedById": "005XXXXXXXXXXXXXXX",
    "EntityDefinitionId": "Account",
    "Metadata": {
      "businessOwnerGroup": null,
      "businessOwnerUser": null,
      "businessStatus": null,
      "caseSensitive": null,
      "complianceGroup": null,
      "customDataType": null,
      "defaultValue": null,
      "deleteConstraint": null,
      "deprecated": null,
      "description": null,
      "displayFormat": null,
      "displayLocationInDecimal": null,
      "encryptionScheme": null,
      "escapeMarkup": null,
      "externalDeveloperName": null,
      "externalId": false,
      "formula": null,
      "formulaTreatBlanksAs": null,
      "inlineHelpText": null,
      "isAIPredictionField": null,
      "isConvertLeadDisabled": null,
      "isFilteringDisabled": null,
      "isNameField": null,
      "isSortingDisabled": null,
      "label": "caf",
      "length": null,
      "lookupFilter": null,
      "maskChar": null,
      "maskType": null,
      "metadataRelationshipControllingField": null,
      "mktDataLakeFieldAttributes": null,
      "mktDataModelFieldAttributes": null,
      "populateExistingRows": null,
      "precision": null,
      "readOnlyProxy": null,
      "referenceTargetField": null,
      "referenceTo": null,
      "relationshipLabel": null,
      "relationshipName": null,
      "relationshipOrder": null,
      "reparentableMasterDetail": null,
      "required": null,
      "restrictedAdminField": null,
      "scale": null,
      "securityClassification": null,
      "startingNumber": null,
      "stripMarkup": null,
      "summarizedField": null,
      "summaryFilterItems": null,
      "summaryForeignKey": null,
      "summaryOperation": null,
      "trackFeedHistory": false,
      "trackHistory": null,
      "trackTrending": null,
      "translateData": null,
      "type": "Address",
      "unique": null,
      "urls": null,
      "valueSet": null,
      "visibleLines": null,
      "writeRequiresMasterRead": null
    },
    "FullName": "Account.caf__c"
}
```

응답 핵심: `Metadata.type: "Address"`, `FullName: "Account.caf__c"`, `DeveloperName: "caf"`.

**Query Information About a Custom Address Field (query)** — `CustomField` REST HTTP **Query** method로 `Mailing_Address__c` 커스텀 주소 필드(CustomField ID `00NXXXXXXXXXXXXXXX`)의 developer name을 조회한다.

쿼리:

```text
Select+id,DeveloperName+from+CustomField+where+Id='00NXXXXXXXXXXXXXXX'
```

HTTP 요청:

```bash
curl
https://MyDomainName.my.salesforce.com/services/data/66.0/tooling/query?q=Select+id,DeveloperName+from+CustomField+where+Id='00NXXXXXXXXXXXXXXX
  -H "Authorization: Bearer token"
```

응답:

```json
{
  "size": 1,
  "totalSize": 1,
  "done": true,
  "queryLocator": null,
  "entityTypeName": "CustomField",
  "records": [
    {
      "attributes": {
         "type": "CustomField",
         "url":
"/services/data/v54.0/tooling/sobjects/CustomField/00NXXXXXXXXXXXXXXX"

      },
      "Id": "00NXXXXXXXXXXXXXXX",
      "DeveloperName": "Mailing_Address"
    }
  ]
}
```

> [!warning] **원문 오타 1건 (query 응답):** `attributes.url`의 버전이 **`v54.0`** 으로, 이 문서의 다른 모든 엔드포인트(`66.0`)와 다르다. PDF 원문 그대로이며 교정하지 않았다.

---

## 관련 노트

- [[State and Country Picklist]] — `AddressSettings` 메타데이터 타입. Custom Address Fields 활성화 전 선행 요구사항인 State·Country/Territory 피클리스트 구성
- [[Compound Fields]] — `Address`·`Geolocation` 등 compound 필드 일반 개념과 컴포넌트 접근 패턴
- [[Field Types]] — 커스텀 필드 데이터 타입 전반 (`Address` 타입 포함)
- [[Future 메서드]] — Ch5 GeoCodeExample의 `@future(callout=true)` map API callout
- [[REST API]] — `/services/data/vXX.0/sobjects/` 표준 REST CRUD (Ch8 예제의 기반)
