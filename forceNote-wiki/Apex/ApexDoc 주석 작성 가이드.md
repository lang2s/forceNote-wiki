---
tags: [apex, apexdoc, documentation, comment, javadoc, annotation, 코드문서화]
source: salesforce_apex_developer_guide.pdf (Summer '26, v67.0) — Document Your Apex Code (print p.245–262)
created: 2026-06-19
aliases: [ApexDoc, ApexDoc Tags, Apex 주석, 코드 문서화, "@param @return @throws", "@see @link", "@description", JavaDoc Apex, Apex documentation comment, ApexDoc 작성법, ApexDoc 주석 다는 법, Apex 주석 다는 법, doc comment, 코드 주석 규약, Apex 문서화 주석]
---

# ApexDoc 주석 작성 가이드

> ApexDoc는 사람·문서 생성기·AI 에이전트가 코드베이스를 이해하기 쉽게 만드는 표준화된 주석 포맷이다. JavaDoc 표준 기반이며 Apex와 Salesforce 생태계에 맞춰진 specification(특수 태그·가이드라인)을 제공한다.

---

## 개요

ApexDoc는 코드 협업 촉진과 장기 유지보수성 향상을 위해 권장되는 주석 specification이다. JavaDoc 표준을 기반으로 하되 Apex와 Salesforce 생태계에 맞춰진 특수 태그·가이드라인을 정의한다. 문서를 사람뿐 아니라 문서 생성 도구·AI 에이전트가 함께 소비할 수 있도록 구조화하는 것이 목적이다.

> [!important]
> Apex 컴파일러는 기존 Apex 주석 syntax는 강제하지만, **ApexDoc syntax나 주석의 (코드 대비) 정확성은 강제하거나 검사하지 않는다.** ApexDoc 주석이 코드와 일치하는지는 전적으로 작성자의 책임이다.

이 가이드는 공식 가이드의 다음 3개 서브섹션을 다룬다.

1. ApexDoc Comment Structure and Tags — 주석 구조와 태그
2. Document Apex Constructs and Features — Apex 구성요소별 문서화
3. ApexDoc Examples — 전체 예제

---

## 1. 주석 구조와 태그 (Comment Structure and Tags)

### Basic Comment Format — 기본 포맷

- 다른 멀티라인 주석은 `/*` … `*/`로 쓰지만, **ApexDoc 주석은 `/**`로 시작해 `*/`로 끝난다.**
- ApexDoc 주석은 그것이 문서화하는 class/interface/enum/method/constructor/property **선언 바로 앞**에 위치해야 한다. 주석 블록과 대상 요소 사이에 다른 코드나 주석이 있으면 안 된다.
- 여러 줄에 걸치면 각 후속 줄은 `*`로 시작한다. 파서는 선행 `*`와 그 앞의 공백을 무시한다.

```apex
/**
 * This is a simple ApexDoc comment.
 */
public with sharing class MyClass {
    //...
}
```

### Main Description — 메인 설명

- ApexDoc 주석 내 **첫 텍스트 블록이며, 명시적 태그가 없다.** 문서화 대상 요소의 간결한 요약을 제공한다.
- 먼저 **한 문장 요약**을 넣는다. 문서 생성 도구가 요약 표·인덱스용으로 이 첫 문장을 추출하므로, 요약 문장은 반드시 **마침표로 종료**한다.
- 요약 문장 뒤에 추가 컨텍스트(pre/post-condition, 관련 문서 링크, 변수 제약 등)를 기술한다.

### Block and Inline Tags — 블록 태그와 인라인 태그

- **Block tag:** main description **뒤에** 사용한다. `@` + 태그명(`@param`, `@return`, `@author` 등). 각 block tag는 새 줄에서 시작하며, 연관 정보는 같은 줄 또는 후속 줄에 둔다.
- **Inline tag:** main description 안 또는 block tag description 안에서 사용한다. `@` + 태그명을 쓰되 **중괄호로 감싼다(`{@...}`)**.

### ApexDoc 태그 전수표 (Table 3)

표 방향성(원문 그대로): row = 태그, col = (Applicable Apex Elements, Description and Example). 표를 압축하기 전에 PDF가 명시한 unique "Applicable Apex Elements" 값을 먼저 나열한다.

- `Class, Interface, Enum`
- `All`
- `Class, Interface, Enum, Method, Property, Variable`
- `Method, Constructor`
- `Method`
- `ApexDoc comment`

| Tag | Applicable Apex Elements | Description and Example |
|---|---|---|
| `@author value` | Class, Interface, Enum | Specifies the author or authors of the element code. Multiple `@author` tags are allowed. 예: `* @author Marie Hill` / `* @author Ben Stuar` |
| `@deprecated description` | All | Marks an element as deprecated. In the tag description, provide a reason and an alternative. 예: `* @deprecated in 1.3.2.` / `* Use {@link #newFieldName} instead.` |
| `@example example` | All | Provides a usage example. The example is formatted as code if the `{@code … }` inline tag is used. 예: `* @example` / `* {@code` / `* Account a;` / `* try {` / `* a = new AccountManager().createAccount('Acme', 'Agriculture');` / `* } catch (AccountManager.AccountException caught) {` / `*   LOGGER.log(caught);` / `*   // further exception handling` / `* }` / `* }` |
| `@group groupName` | Class, Interface, Enum, Method, Property, Variable | Specifies the element's group in documentation. Grouping elements is useful for generated documentation. 예: `* @group Account` |
| `@param paramName` | Method, Constructor | Describes a method or constructor parameter. It must match the parameter order and name. 예: `* @param accountName The desired name for the new` / `* account. Cannot be null or empty.` |
| `@return description` | Method | Describes the return value of a method. Don't use the `@return` tag for void methods or constructors. 예: `* @return The newly created Account sObject with its` / `* ID populated.` |
| `@see reference` | All | Adds a reference in the See Also section of the documentation. The `@see` tag allows these syntaxes: • `@see class#member` • `@see "text-string"` • `@see <a href="URL">label</a>`. For the `@see class#member` syntax: **class**—The fully-qualified name of the class or interface that you want to link to. **#member**—The specific member within a class. 예: • For fields or properties, use `#fieldName`. • For constructors, use `#ClassName(parameterTypes)`. • For methods, use `#methodName(parameterTypes)`. The parameterTypes are important to distinguish overloaded methods. Use the fully-qualified name for the parameter types if they're from a different package. 예: `* @see GeolocationService#GeocodingException` |
| `@since value` | All | Indicates the version or date that the element was introduced. This tag is particularly useful for package authors. 예: `* @since 0.1.0` |
| `@throws exceptionType description` | Method, Constructor | Documents an exception that can be thrown. 예: `* @throws AccountManager.AccountException if` / `* accountName is invalid or if DML operation fails.` |
| `@version value` | Class, Interface, Enum | Specifies the version of the element. 예: `* @version 0.2.0` |
| `{@code text}` | ApexDoc comment | Formats comment text as inline code. 예: `* {@code` / `* Account a;` / `* try {` / `* a = new AccountManager().createAccount('Acme', 'Agriculture');` / `* } catch (AccountManager.AccountException caught) {` / `*   LOGGER.log(caught);` / `*   // further exception handling` / `* }` / `* }` |
| `{@hidden text}` | All | Prevents an element from appearing in generated docs. 예: `* {@hidden NOTE TO MAINTAINERS: Update this method` / `* if new security threats are identified.` / `* The current regex is designed to handle common XSS` / `* patterns but may not be exhaustive.` / `* The last major update was in v2.1.}` |
| `{@link reference}` | ApexDoc comment | Creates an inline link to another element. The `@link` tag allows these syntaxes: • `@link class#member` • `@link "text-string"` • `@link <a href="URL">label</a>`. For the `@link class#member` syntax: **class**—The fully-qualified name of the class or interface. **#member**—The specific member within a class. 예: • For fields or properties, use `#fieldName`. • For constructors, use `#ClassName(parameterTypes)`. • For methods, use `#methodName(parameterTypes)`. The parameterTypes are important to distinguish overloaded methods. Use the fully-qualified name for the parameter types if they're from a different package. 예: `* Populated after using the {@link AccountService}.` |
| `{@literal text}` | ApexDoc comment | Shows text literally without HTML tag interpretation. 예: `* This string might contain malicious or unexpected characters,` / `* like a {@literal <script>} tag or a backslash {@literal \}.` |

---

## 2. Apex 구성요소별 문서화 (Document Apex Constructs and Features)

### Classes — 클래스

클래스 문서화 시 purpose·responsibility·key characteristic의 종합 개요를 제공한다. summary 문장에 클래스 전체 목적을 기술하고, summary 뒤에 sharing model이 자명하지 않으면 그 rationale을 설명한다(예: 특정 권한 작업에 `without sharing`을 쓰는 이유). `@author`, `@version`, `@since`, `@see`, `@group` 태그를 권장한다.

```apex
/**
 * This service class handles critical data aggregation tasks.
 * It operates using 'without sharing' to ensure access to all necessary
 * records for calculation, irrespective of the running user's sharing rules.
 * Care must be taken when calling methods from this class.
 * @author Jane Doe
 * @since 0.1.0
 */
public without sharing class DataAggregationService {
    //...
}
```

### Interfaces — 인터페이스

인터페이스는 contract를 정의한다(how가 아니라 what). main description에 인터페이스 전체 목적과 정의하는 contract를 문서화한다. `@author`, `@version`, `@since`, `@see`를 적용할 수 있다. 인터페이스 내 각 method 선언을 표준 메서드처럼 문서화하여(expected behavior·parameters·return values를 명확히) implementing 클래스에 대한 기대치를 설정한다. (예시는 아래 [Interface Example](#interface-example) 참조.)

### Enums — 열거형

Enum은 유한한 named constant 집합의 추상 데이터 타입을 정의한다. main description에 enum 목적과 표현하는 개념 집합을 문서화한다. `@author`, `@version`, `@since`, `@see`를 사용할 수 있다. 개별 enum constant가 self-explanatory하지 않으면 명확화한다(enum 타입 ApexDoc main description에 정의를 기술하거나, constant 줄 바로 앞에 표준 block 주석).

**Apex enum은 `values()`, `valueOf(String)`, `name()`, `ordinal()`를 암묵적으로 포함한다 — 이 표준 메서드들은 일반적으로 각 enum의 ApexDoc에 명시적으로 문서화할 필요가 없다.**

```apex
/**
 * Potential seasons of the year
 */
public enum Season {
  WINTER,
  SPRING,
  SUMMER,
  FALL
}
```

### Methods and Constructors — 메서드와 생성자

- **파라미터:** `@param` block tag로 문서화한다. **각 파라미터마다 대응하는 `@param`이 필수이다.** 이름·목적·타입/콘텐츠 기대치를 기술한다("Cannot be null", "A valid 18-character ID" 같은 문장 포함 가능).
- **반환값:** `@return` block tag로 문서화한다. null 조건·특정 데이터 구조 포함을 명시한다("A List of Account sObjects matching the filter criteria; an empty list if no matches are found." 같은 문장 가능).
- **예외:** `@throws` block tag — 메서드가 명시적으로 throw 가능한 모든 중요 checked/unchecked 예외와 그 유발 조건을 나열한다. 에러 핸들링 갭 식별에 중요하다.

### Properties and Variables — 프로퍼티와 변수

클래스 public API의 일부인 public/global property·class member variable을 문서화한다. main description에 property 목적과 (선언에서 불명확하면) 데이터 타입, 중요 usage note(초기화 후 read-only 여부, 기본값 등)를 설명한다. `@see`, `@since`, `@deprecated` block tag를 적용할 수 있다.

```apex
/**
 * Stores the maximum number of retry attempts for an operation.
 * Defaults to 3 if not explicitly set.
 * @since 0.1.1
 */
public Integer maxRetries {
  get {
    return maxRetries ?? 3;
  }
  set { maxRetries = value; }
}
```

### Triggers — 트리거

Apex 트리거는 이벤트 기반이다. 트리거 정의 자체가 상당한 컨텍스트를 제공하므로, **모든 비즈니스 로직을 별도 handler 클래스나 트리거 프레임워크에 위임하는 것을 강력 권장한다. 따라서 ApexDoc에는 트리거 전용 주석 specification이 없다.** 단 `@since`, `@see` 같은 표준 태그는 사용할 수 있다.

```apex
/**
 * @since 1.3.2
 */
trigger OpportunityTrigger on Opportunity (
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  new OpportunityTriggerHandler().run();
}
```

### Annotations — 애노테이션

`@AuraEnabled`, `@Future` 등 애노테이션은 클래스/메서드의 플랫폼 사용 방식을 수정한다. 애노테이션이 있는 요소는 그 애노테이션이 동작·사용에 미치는 함의를 함께 문서화한다.

#### 공통 Apex 애노테이션 문서화 가이드 전수표 (Table 4)

| Apex Annotation | Guidance for the ApexDoc Comment of the Annotated Element |
|---|---|
| `@AuraEnabled` (p.94) | If the element is exposed to Lightning components for client-side access, document whether (cacheable=true). Describe the implications of this cache setting. |
| `@InvocableMethod` (p.96) | If the element is callable from Flow Builder, explain the element's function as an invocable action. Mention label and description attributes from the annotation if they provide important context. Use `@param` and `@return` for the element's specific input and output structure. |
| `@InvocableVariable` (p.102) | Clarify the variable's specific role, data type, and any constraints or expectations for the action. |
| `@RestResource(urlMapping=...)` (p.117) | Describe the overall resource. Also document the annotated Apex REST methods (`@HttpDelete`, `@HttpGet`, `@HttpPatch`, `@HttpPost`, or `@HttpPut`) with their specific roles. |
| `@Deprecated` (p.94) | Include the `@deprecated` tag. Explain the reason for the deprecation and specify the recommended alternative. |
| `@Future` (p.95) | Describe the implications of running the method asynchronously. For example, you can specify whether the method runs in a separate transaction, describe governor limit considerations, and explain callout behavior. |
| `@IsTest` (p.106) | Briefly describe the scenario or functionality being tested. Test documentation is often excluded from public API docs. If seeAllData is true, explain why this setting is necessary. If onInstall is true, explain why this setting is necessary. |
| `@ReadOnly` (p.114) | Explain if the element is used for performance with large query sets or specific APIs. |
| `@TestSetup` (p.115) | Describe the common test data being created. |
| `@TestVisible` (p.116) | Describe the rationale for the element's annotation. For example, on private or protected member methods or variables, document "Visibility modified for testing purposes." |
| `@SuppressWarnings` (p.115) | Specify the warning that the third-party tool suppresses and briefly explain the rationale for the suppression if it's not self-evident. |
| `@NamespaceAccessible` (p.112) | Clarify if this annotation restricts exposure compared to global access or why this level of access is appropriate. |

---

## 3. 전체 예제 (ApexDoc Examples)

아래 예제는 모두 공식 가이드 원문 그대로다.

### Class Example

```apex
/**
 * Manages customer account information and related operations.
 * This class bypasses user record access via 'without sharing' so that it
 * can be used in a batch classes.
 * @author John Developer
 * @since 0.1.0
 * @version 0.3.1
 * @see AccountProcessingBatch
 * @group Account
 * @example
 * {@code
 * Account a;
 * try {
 * a = new AccountManager().createAccount('Acme', 'Agriculture');
 * } catch (AccountManager.AccountException caught) {
 *   LOGGER.log(caught);
 *   // further exception handling
 * }
 * }
 */
public without sharing class AccountManager {

     /**
      * The default region for new accounts if not specified.
      */
     public static final String DEFAULT_REGION = 'North America';

     /**
      * Stores the count of active accounts managed by this instance.
      * Populated after using the {@link AccountService}.
      */
     @TestVisible
     private Integer activeAccountCount;

     /**
      * Creates a new Account sObject with the given name and industry.
      * @param accountName The desired name for the new account. Cannot be null or empty.
      * @param industry The industry classification for the new account.
      * @return The newly created Account sObject with its ID populated.
      * @throws AccountManager.AccountException if accountName is invalid
      * or if DML operation fails.
      */
     public Account createAccount(String accountName, String industry) {
         if (String.isBlank(accountName)) {
             throw new AccountManager.AccountException('Account name cannot be blank.');
         }
         Account acc = new Account(Name = accountName, Industry = industry);
         // Potentially more logic here
         try {
             insert acc;
         } catch (DmlException e) {
             throw new AccountManager.AccountException(
                 'Failed to create account: ' + e.getMessage()
             );
         }
         return acc;
     }

     // more methods...

     /**
      * Represents an exception specific to AccountManager operations.
      * @example
      * {@code
      * throw new AccountManager.AccountException('Account not found with provided Id.');
      * }
      */
     public class AccountException extends Exception {}
}
```

### Packaged Class Example

```apex
/**
 * Provides services for geolocation and address conversion.
 * @author Dennis Smith
 * @version 0.3.0
 * @since 0.1.0
 */
global with sharing class GeolocationService {
  /**
   * Represents geographic coordinates (latitude and longitude).
   */
  global class Coordinates {
    @AuraEnabled
    public Decimal latitude;
    @AuraEnabled
    public Decimal longitude;

       global Coordinates(Decimal lat, Decimal lon) {
         this.latitude = lat;
         this.longitude = lon;
       }
   }

  /**
   * Converts a full address string to approximate latitude
   * and longitude coordinates. This method is deprecated and should no
   * longer be used due to its reliance on an older, less accurate geocoding
   * service and simpler parsing logic. It may not handle all address formats
   * correctly and has a lower success rate.
   * @param fullAddress The complete address string
   * (e.g., "123 Main St, Anytown, CA 90210, USA").
   * @return A `Coordinates` object representing the approximate latitude and longitude.
   * @throws DeprecatedMethodCalledException If this method is invoked,
   * informing the user to migrate to the newer, more robust `geocodeAddress` method.
   * @deprecated in 0.2.0. Use {@link #geocodeAddress(
   * String street,
   * String city,
   * String state,
   * String postalCode,
   * String country)} instead.
   * @since 0.1.0
   */
  @Deprecated
  global static Coordinates convertAddressToCoordinates(String fullAddress) {
    throw new DeprecatedMethodCalledException(
      'The method `GeolocationService.convertAddressToCoordinates(String fullAddress)` is deprecated. ' +
        'Please use `GeolocationService.geocodeAddress(String street, String city, String state, String postalCode, String country)` ' +
        'for all new and existing address-to-coordinate conversions to ensure better accuracy and reliability.'
    );
  }

   /**
    * Geocodes a structured address into precise latitude and longitude coordinates
    * using a robust external geocoding service.
    * This method provides higher accuracy and better handling of diverse address formats.
    * @param street The street address (e.g., "123 Main St").
    * @param city The city (e.g., "Anytown").
    * @param state The state or province abbreviation (e.g., "CA").
    * @param postalCode The postal or ZIP code (e.g., "90210").
    * @param country The country name or code (e.g., "USA").
    * @return A Coordinates object containing the latitude and longitude.
    * @throws GeocodingException If the address cannot be geocoded,
    * if the external service is unavailable, or if required address
    * components are missing.
    * @example
    * {@code
    * try {
    *   GeolocationService.Coordinates coords = GeolocationService.geocodeAddress(
    *     '415 Mission St',
    *     'San Francisco',
    *     'CA',
    *     '94105',
    *     'USA'
    *   );
    * } catch (GeolocationService.GeocodingException e) {
    *   // handle failure
    * }
    * }
    * @since 0.2.0
    */
   global static Coordinates geocodeAddress(
     String street,
     String city,
     String state,
     String postalCode,
     String country
   ) {
     // Implement actual geocoding logic
     return new Coordinates(0, 0);
   }

   /**
    * Exception thrown when a deprecated method is called.
    * This indicates that the caller should migrate to the recommended alternative.
    */
   global class DeprecatedMethodCalledException extends Exception {
   }

   /**
    * Exception thrown when a geocoding operation fails.
    * This provides specific context for issues during address-to-coordinate conversion.
    */
   global class GeocodingException extends Exception {
    }
}
```

### Test Class Example

```apex
/**
 * Specifications for the GeolocationService
 * @author Jane Devington
 * @version 0.2.0
 * @see GeolocationService
 * @since 0.1.0
 */
@IsTest
private class GeolocationServiceTest {
  /**
   * Verifies that known addresses are correctly geocoded to their expected coordinates.
   * @see GeolocationService#geocodeAddress(
   * String street,
   * String city,
   * String state,
   * String postalCode,
   * String country)
   */
  @IsTest
  private static void validAddressShouldReturnCorrectCoordinates() {
    String street = '415 Mission Street';
    String city = 'San Francisco';
    String state = 'CA';
    String postalCode = '94105';
    String country = 'USA';

        GeolocationService.Coordinates coords;
        Test.startTest();
        coords = GeolocationService.geocodeAddress(
          street,
          city,
          state,
          postalCode,
          country
        );
        Test.stopTest();

        Assert.isNotNull(
          coords,
          'Coordinates should not be null for a valid address.'
        );
        Assert.areEqual(
          37.785834,
          coords.latitude,
          'Latitude should match for Salesforce tower.'
        );
        Assert.areEqual(
          -122.406417,
          coords.longitude,
          'Longitude should match for Salesforce tower.'
        );
    }

   /**
    * Verifies that calling the geocodeAddress with missing required parameters
    * throws a GeocodingException.
    * @see GeolocationService#geocodeAddress(
    * String street,
    * String city,
    * String state,
    * String postalCode,
    * String country)
    * @see GeolocationService#GeocodingException
    */
   @IsTest
   private static void missingRequiredParametersShouldThrowGeocodingException() {
     String street = ''; // Missing
     String city = 'San Francisco';
     String state = 'CA';
     String postalCode = 94105;
     String country = 'USA';

       Test.startTest();
       Boolean caughtException = false;
       try {
         GeolocationService.geocodeAddress(
           street,
           city,
           state,
           postalCode,
           country
         );
       } catch (GeolocationService.GeocodingException e) {
         caughtException = true;
         Assert.areEqual(
           'Street, City, and Postal Code are required for geocoding.',
           e.getMessage(),
           'Exception message should indicate missing required fields.'
         );
       }
       Test.stopTest();

       Assert.isTrue(
         caughtException,
         'GeocodingException should have been thrown for missing street.'
       );
   }

   /**
    * Verifies that calling the deprecated method throws a
    * DeprecatedMethodCalledException.
    * @see GeolocationService#convertAddressToCoordinates(String address)
    * @see GeolocationService#DeprecatedMethodCalledException
    */
    @IsTest
    private static void deprecatedMethodCallShouldThrowDeprecatedMethodCalledException() {
      String oldAddress = '123 Deprecated Lane';

        Test.startTest();
        Boolean caughtException = false;
        try {
          GeolocationService.convertAddressToCoordinates(
            oldAddress
          );
        } catch (GeolocationService.DeprecatedMethodCalledException e) {
          caughtException = true;
          Assert.isTrue(
            e.getMessage().contains('is deprecated'),
            'Exception message should indicate deprecation.'
          );
          Assert.isTrue(
            e.getMessage().contains('Please use'),
            'Exception message should suggest new method.'
          );
        }
        Test.stopTest();

        Assert.isTrue(
          caughtException,
          'DeprecatedMethodCalledException should have been thrown.'
        );
    }
}
```

### Interface Example

```apex
/**
 * Defines a contract for objects that can be serialized to a
 * specific format. Implementations must provide logic for converting
 * their state into a string representation.
 * @author Jane Coder
 * @since 0.2.0
 */
public interface ISerializable {
    /**
     * Serializes the object's current state into a String.
     * @return A String representation of the object.
     * @throws SerializationException if the object cannot be serialized.
     */
    String serialize();

        /**
         * Gets the format name this serializer supports (e.g., "JSON", "XML").
         * @return The name of the serialization format.
         */
      String getFormatName();
}
```

### Enum Example

```apex
/**
 * Represents the possible status levels for a support case.
 * Defines standard values for case progression in the customer portal.
 * @author John Developer
 * @since 0.1.5
 */
public enum CaseStatus {
  /* A newly opened case, not yet assigned. */
  BRAND_NEW,
  /* Case is actively being worked on. */
  WORKING,
  /* Case has been escalated to a higher tier. */
  ESCALATED,
  /* Case has been resolved and closed. */
  CLOSED
}
```

### Method Example (with params, return, throws)

```apex
/**
 * Calculates the total price for a list of products, applying a discount.
 * @param productCodes A List of unique product codes to calculate the price for.
 * Each code must correspond to an existing Product2 record.
 * @param discountPercentage The discount percentage to apply (e.g., 10.5 for 10.5%).
 * Must be between 0.0 and 100.0.
 * @return The calculated total price as a Decimal after applying the discount.
 * Returns 0.0 if productCodes is null or empty.
 * @throws InvalidArgumentException if discountPercentage is out of range.
 * @throws ProductNotFoundException if any productCode does not match an
 * existing product.
 */
public Decimal calculateTotalPrice(
  List<String> productCodes,
  Decimal discountPercentage
) {
    if (discountPercentage < 0.0 || discountPercentage > 100.0) {
        throw new IllegalArgumentException(
          'Discount percentage must be between 0.0 and 100.0.'
        );
    }
    if (productCodes == null || productCodes.isEmpty()) {
        return 0.0;
    }
    //... implementation logic to fetch prices and calculate total...
    return 100.0;
}

/**
 * Represents an exception thrown when a requested product cannot be found.
 * This custom exception provides a clear indication that a product lookup failed,
 * allowing calling code to handle the 'not found' scenario specifically.
 * It is typically thrown by methods attempting to retrieve Product2 records.
 * @example
 * {@code
 * List<Product2> products = [
 *   SELECT Id
 *   FROM Product2
 *   WHERE ProductCode = :productCode
 *   LIMIT 1
 * ];
 * if (products.isEmpty()) {
 *   throw new ProductNotFoundException(
 *    'Product with code ' + productCode + ' not found.'
 * );
 * }
 * }
 */
public class ProductNotFoundException extends Exception {}
```

### Annotated Method (@AuraEnabled) Example

```apex
public class OpportunityService {
    /**
     * Retrieves a list of open opportunities for a given account,
     * accessible from Lightning Web Components. If the set of open opportunities
     * can change during interaction with the component, the author will
     * need to use {@code refreshApex()}.
     * @param accountId The ID of the Account to retrieve opportunities for.
     * @return A List of open Opportunity records. Returns an empty list if no
     * open opportunities are found or if accountId is invalid.
     * @see OpportunitySelector
     */
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpenOpportunities(Id accountId) {
        List<Opportunity> result = new List<Opportunity>();
        //... implementation details...
        return result;
    }
}
```

### External Reference Example

`@see` 태그로 외부 URL을 참조하는 예제다.

```apex
/**
 * Provides a service to retrieve current weather conditions from an external API.
 * It utilizes Salesforce Named Credentials for secure endpoint and
 * authentication management.
 * @author John Doe
 * @since 1.0.3
 */
public with sharing class WeatherService {
  /**
    * Retrieves the current weather conditions for a specified city and country.
    * This method makes an HTTP GET callout to an external weather API using a
    * Named Credential.
    * @param city The name of the city (e.g., "London").
    * @param country The name or code of the country (e.g., "UK" or "United Kingdom").
    * @return A JSON string representing the current weather conditions.
    * @throws WeatherServiceException If the HTTP callout fails, returns a non-200 status,
    * or if there's an issue parsing the response.
    * @see <a href="https://example.com/weather-api-docs/current-conditions.html">External
    * Weather API</a>
    */
   public static String getCurrentWeather(
     String city,
     String country
   ) {
     if (String.isBlank(city) || String.isBlank(country)) {
       throw new WeatherServiceException(
         'City and country cannot be blank for weather lookup.'
       );
     }

     String namedCredentialUrl = 'callout:WeatherAPI/current';
     String requestParams =
       '?city=' +
       EncodingUtil.urlEncode(city, 'UTF-8') +
       '&country=' +
       EncodingUtil.urlEncode(country, 'UTF-8');

     HttpRequest req = new HttpRequest();
     req.setEndpoint(namedCredentialUrl + requestParams);
     req.setMethod('GET');
     req.setTimeout(60000);

     Http http = new Http();
     HttpResponse res;

     try {
       res = http.send(req);
     } catch (System.CalloutException e) {
       throw new WeatherServiceException(
         'HTTP Callout Failed: ' + e.getMessage()
       );
     }

     if (res.getStatusCode() == 200) {
       return res.getBody();
     } else {
       throw new WeatherServiceException(
         'Failed to retrieve weather data. Status: ' +
           res.getStatusCode() +
           '. Details: ' +
           res.getBody()
       );
     }
   }
   /**
    * Custom exception for errors during weather data retrieval.
    */
   public class WeatherServiceException extends Exception {
   }
}
```

### Inline Tags Example

여러 인라인 태그(`{@code}`·`{@literal}`·`{@link}`·`{@hidden}`)를 한 메서드 주석에서 함께 시연하는 예제다. 각 인라인 태그의 의미는 위 [ApexDoc 태그 전수표 (Table 3)](#apexdoc-태그-전수표-table-3)를 참조한다.

```apex
/**
 * Sanitizes a given input string by removing or replacing certain
 * characters such as {@code <script>}
 * @param inputString The raw string provided by a user or external source.
 * This string might contain malicious or unexpected characters,
 * like a {@literal <script>} tag or a backslash {@literal \}.
 * @return The sanitized string after processing.
 * @example
 * {@code
 * String badInput = 'Hello, <script>alert(\'xss\')</script> World!';
 * String safeOutput = SecurityUtils.sanitizeInput(badInput);
 * System.debug('Sanitized Output: ' + safeOutput);
 * } * @see {@link String#escapeHtml4} for a similar built-in method.
 * {@hidden NOTE TO MAINTAINERS: This method should be updated if
 * new security threats are identified. The current regex
 * is designed to handle common XSS patterns but may not
 * be exhaustive. The last major update was in v2.1.}
 * @since 2.0
 */
global static String sanitizeInput(String inputString) {
  // simple example for demonstration purposes
  String sanitized = inputString;
  sanitized = sanitized.replace('<script>', '').replace('</script>', '');
  sanitized = sanitized.replace('&#40;','(').replace('&#41;',')');
  return sanitized;
}
```

---

## 관련 노트

- [[Apex 언어 기초 — 제어 흐름과 클래스]]
- [[Apex 언어 기초 — 예외 처리와 예약어]]
- [[Apex 표준 클래스 레퍼런스]]
- [[Apex Best Practices]]
- [[Apex MOC]]
