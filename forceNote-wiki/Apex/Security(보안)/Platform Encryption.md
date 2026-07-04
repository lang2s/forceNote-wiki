---
tags: [Security, Platform-Encryption, Shield, Encryption, Field-Encryption, Database-Encryption, Data-Cloud]
source: external-knowledge; apex-recipes-main/force-app/main/default/classes/Encryption Recipes/EncryptionRecipes.cls; help.salesforce.com security_pe_permissions (Tier 2)
created: 2026-05-23
aliases: [Platform Encryption, 플랫폼 암호화, Shield Platform Encryption, 필드 암호화, 데이터베이스 암호화, constant-time comparison, 타이밍 공격, areEqualConstantTime, 초기화 벡터, developer-managed IV]
---

# Platform Encryption

> Salesforce Shield의 핵심 기능 — 데이터를 저장(at rest) 시 암호화하여 규정 준수 요건을 충족한다

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.
> 공식 문서: https://help.salesforce.com/s/articleView?id=sf.security_pe_overview.htm

---

## 개념 설명

Platform Encryption은 **Salesforce org의 데이터를 AES-256 암호화로 저장**하는 Salesforce Shield 기능이다. 필드 레벨 암호화와 파일/첨부 암호화를 지원하며, HIPAA·GDPR·금융 규정 준수에 활용된다.

### 암호화 계층

| 계층 | 설명 |
|---|---|
| **필드 레벨 암호화 (Field Encryption)** | 특정 sObject 필드를 개별 암호화 |
| **파일·첨부 암호화 (File & Attachment Encryption)** | Files, Attachments, ContentVersion 암호화 |
| **데이터베이스 암호화 (Database Encryption, GA Winter '26)** | 전체 데이터베이스 레코드 저장소 암호화 |
| **Tableau Next 지원 (Data Cloud, Winter '26)** | Tableau Personal Org 암호화 |

---

## 키 관리 (Key Management)

Platform Encryption은 **Tenant Secret**과 **Master Secret**을 결합해 데이터 암호화 키(DEK)를 생성한다.

```
Master Secret (Salesforce 관리)
    +
Tenant Secret (고객 관리 — BYOK 가능)
    ↓
Data Encryption Key (DEK)
    ↓
암호화된 필드 데이터
```

### BYOK (Bring Your Own Key)

```
고객이 외부 HSM 또는 로컬에서 키 생성
    → Salesforce에 Tenant Secret 업로드
    → 기존 Salesforce 관리 키 대체
    → 고객이 키 교체(rotation) 제어 가능
```

### 키 관련 Apex — Crypto 클래스 활용

```apex
// 플랫폼 암호화는 선언적(Setup)이므로 Apex 직접 제어 불가
// 단, 추가 커스텀 암호화는 Crypto 클래스 사용

// AES-256 키 생성
Blob key = Crypto.generateAesKey(256);

// 암호화
String plainText = 'Sensitive Data';
Blob encrypted = Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(plainText));
String encryptedBase64 = EncodingUtil.base64Encode(encrypted);

// 복호화
Blob decrypted = Crypto.decryptWithManagedIV('AES256', key, 
    EncodingUtil.base64Decode(encryptedBase64));
String decryptedText = decrypted.toString();
System.assertEquals(plainText, decryptedText);

// HMAC 서명 (데이터 무결성 검증)
Blob hmacKey = Crypto.generateAesKey(256);
Blob mac = Crypto.generateMac('HmacSHA256', Blob.valueOf(plainText), hmacKey);
```

---

## 실전 Crypto 패턴 — 개발자 관리 IV & 상수 시간 비교

> 출처: `apex-recipes-main` `EncryptionRecipes.cls` (Salesforce Apex Recipes, Tier 1 로컬 소스)

위의 `encryptWithManagedIV`는 IV(초기화 벡터)를 Salesforce가 내부적으로 관리하므로 같은 org 안에서 복호화할 때만 유효하다. **외부 수신자와 암호문을 주고받을 때**는 발신자가 IV를 직접 생성해 암호문과 함께 전송해야 한다. Apex Recipes는 이 두 가지 실전 문제를 다룬다.

### 1. 개발자 관리 IV — 암호문 앞 16바이트에 IV를 붙여 전송

`Crypto.encrypt(algorithm, key, iv, data)`는 IV를 직접 넘긴다. IV는 **16바이트(128비트) 랜덤값**이어야 하고 AES 키와 같은 값을 쓰면 안 된다. 수신자가 복호화하려면 IV를 알아야 하므로, 암호문 **앞에 IV를 이어 붙여** 하나의 Blob으로 전송하는 패턴을 쓴다.

```apex
// IV 생성 — Apex에 전용 메서드가 없어 generateAesKey(128)로 128비트 랜덤값을 만든다
// (IV와 AES 키에 같은 값을 절대 쓰지 말 것)
public static Blob generateInitializationVector() {
    return Crypto.generateAesKey(128);
}

// 암호화: encrypt한 뒤 IV를 암호문 앞에 이어 붙인다
public static Blob encryptAES256Recipe(Blob dataToEncrypt, Blob initializationVector) {
    Blob encryptedData = Crypto.encrypt(
        AESAlgorithm.AES256.name(),   // 'AES256'
        AES_KEY,
        initializationVector,
        dataToEncrypt
    );
    // IV(hex) + 암호문(hex)을 이어 붙여 하나의 Blob으로 반환 → 수신자에게 IV까지 함께 전달
    String blobsAsHex =
        EncodingUtil.convertToHex(initializationVector) +
        EncodingUtil.convertToHex(encryptedData);
    return EncodingUtil.convertFromHex(blobsAsHex);
}
```

복호화 측은 받은 Blob의 **앞 16바이트(hex 32자)를 IV로, 나머지를 암호문**으로 분리한다.

```apex
public static Blob decryptAES256Recipe(Blob dataToDecrypt) {
    String blobsAsHex = EncodingUtil.convertToHex(dataToDecrypt);
    // 앞 32 hex 문자 = 16바이트 = 128비트 IV
    String initializationVectorString = blobsAsHex.substring(0, 32);
    // 나머지 = 암호문
    String encryptedDataString = blobsAsHex.substring(32);
    Blob initializationVector = EncodingUtil.convertFromHex(initializationVectorString);
    Blob encryptedData = EncodingUtil.convertFromHex(encryptedDataString);
    return Crypto.decrypt(
        AESAlgorithm.AES256.name(),
        AES_KEY,
        initializationVector,
        encryptedData
    );
}
```

| 방식 | IV 관리 | 용도 |
|---|---|---|
| `encryptWithManagedIV` / `decryptWithManagedIV` | Salesforce가 IV 자동 관리 | 같은 org 내부 저장·복호화 |
| `encrypt` / `decrypt` (developer-managed IV) | 발신자가 IV 생성 후 암호문에 동봉 | 외부 수신자와 암호문 교환 |

### 2. 상수 시간 비교 — 타이밍 공격 방어

해시·HMAC·서명을 검증할 때 재계산한 값과 수신한 값을 **일반 `==`로 비교하면 안 된다.** `==`는 첫 불일치 바이트에서 즉시 반환(early exit)하므로, 비교에 걸리는 시간 차이로 공격자가 정답을 한 바이트씩 추측할 수 있다([타이밍 공격](https://en.wikipedia.org/wiki/Timing_attack)). 방어책은 **입력 내용과 무관하게 항상 전체를 끝까지 순회하는 상수 시간 비교**다.

```apex
/**
 * 암호학 관련 비교는 타이밍 공격을 피하기 위해 상수 시간으로 수행해야 한다.
 */
public static boolean areEqualConstantTime(String first, String second) {
    Boolean result = true;
    if (first.length() != second.length()) {
        result = false;
    }
    Integer max = first.length() > second.length()
        ? second.length()
        : first.length();
    // 불일치를 찾아도 break하지 않고 항상 끝까지 순회 → 비교 시간이 내용에 의존하지 않음
    for (Integer i = 0; i < max; i++) {
        if (first.substring(i, i + 1) != second.substring(i, i + 1)) {
            result = false;
        }
    }
    return result;
}
```

해시 검증 시 이 함수를 사용한다 (HMAC은 `Crypto.verifyHMAC`, 서명은 `Crypto.verify`가 내부적으로 안전 비교를 수행하므로 직접 비교가 불필요하다).

```apex
public static void checkSHA512HashRecipe(Blob hash, Blob dataToCheck) {
    Blob recomputedHash = Crypto.generateDigest(HashAlgorithm.SHA512.name(), dataToCheck);
    // 일반 == 대신 상수 시간 비교
    if (!areEqualConstantTime(
            EncodingUtil.base64Encode(hash),
            EncodingUtil.base64Encode(recomputedHash))) {
        throw new CryptographicException('Wrong hash!');
    }
}
```

> 핵심: **직접 재계산한 해시를 비교할 때만** `areEqualConstantTime`가 필요하다. HMAC/서명 검증은 플랫폼 API(`verifyHMAC`, `verify`)가 안전 비교까지 담당하므로 그 반환 Boolean만 확인하면 된다.

---

## 설정 방법

### ⚠️ 전제조건 (Encryption Policy 설정 전 필수)

Encryption Policy에서 필드를 선택하기 **전에** 아래 선행 단계를 반드시 완료해야 한다. Setup의 Encryption Policy로 바로 진입하는 것이 아니다.

```
1. 권한 확인 — 다음 두 권한이 모두 필요하다:
   - Manage Encryption Keys
   - Customize Application

2. Tenant Secret 생성 (Key Management)
   Setup > Platform Encryption > Key Management > Generate Tenant Secret
   → 활성(active) 테넌트 시크릿이 없으면 암호화 정책 적용 불가
   → 테넌트 시크릿 생성 후에야 필드/파일 암호화 활성화 가능
```

> 위 [키 관리 (Key Management)](#키-관리-key-management) 섹션의 Tenant Secret은 개념 설명이고, 여기서는 **정책 설정의 선행 필수 순서**로서 명시한다. 활성 테넌트 시크릿 → 그다음 Encryption Policy에서 필드 선택 순서.

### 필드 암호화 활성화

```
1. Setup > Platform Encryption > Encryption Policy
2. 암호화할 sObject 선택 (Account, Contact, Lead 등)
3. 암호화할 필드 선택 (예: SSN, 신용카드 번호)
4. 암호화 스키마 선택:
   - Deterministic (검색 가능, 보안 낮음)
   - Probabilistic (검색 불가, 보안 높음)
5. Save → 새 데이터부터 암호화 적용

# 기존 데이터 암호화 (Encrypt Existing Data)
Setup > Platform Encryption > Encrypt Existing Data
```

### Deterministic vs Probabilistic

| 항목 | Deterministic | Probabilistic |
|---|---|---|
| **검색 가능** | ✅ (exact match) | ❌ |
| **GROUP BY** | ✅ | ❌ |
| **ORDER BY** | ✅ | ❌ |
| **보안 강도** | 중간 | 높음 |
| **용도** | 검색·필터 필요한 필드 | 순수 저장용 |

---

## Field Audit Trail 선언적 보존 정책 (Winter '26)

Winter '26부터 Field Audit Trail의 보존 기간을 선언적으로 설정 가능:

```
Setup > Field Audit Trail > Retention Policy
    → 필드별 보존 기간 설정 (최대 10년)
    → 이전: API 또는 Support 요청으로만 설정 가능했음
```

---

## 암호화 제약 사항

### 암호화 필드의 SOQL 제한

```apex
// ❌ 암호화된 Probabilistic 필드로 WHERE 절 사용 불가
List<Contact> contacts = [
    SELECT Id, Name FROM Contact 
    WHERE SSN__c = '123-45-6789'  // Probabilistic 필드
];

// ✅ Deterministic 암호화 필드는 exact match 검색 가능
List<Contact> contacts = [
    SELECT Id, Name FROM Contact 
    WHERE TaxId__c = 'AB123456'  // Deterministic 필드
];

// ✅ 암호화된 필드는 SELECT로 조회 가능 (복호화는 자동)
Contact c = [SELECT Id, SSN__c FROM Contact WHERE Id = :contactId];
String ssn = c.SSN__c;  // 자동 복호화 값 반환
```

### 기타 제한 사항

- 암호화된 필드는 **Formula 필드**에서 참조 불가
- 암호화된 필드는 **Process Builder / Flow의 Formula 조건**에서 일부 제한
- 외부 검색(SOSL)에서 암호화된 필드 검색 불가
- 리포트의 Group By, Sort By는 Probabilistic 필드에서 불가
- `LIKE` 연산자 Probabilistic 필드에서 불가

---

## Data Cloud 암호화 (Winter '26)

```
지원 범위:
- Data Lake Objects (DLO)
- Data Model Objects (DMO)
- Tableau Personal Org (신규 — Winter '26)

설정:
Setup > Data Cloud > Security > Encryption
    → Tenant Secret 연결
    → 암호화 대상 선택
```

---

## Shield Platform Encryption vs Classic Encryption

| 항목 | Shield Platform Encryption | Classic Encryption |
|---|---|---|
| 암호화 방식 | AES-256 | AES-128 |
| 키 관리 | 고객 제어 가능 | Salesforce 관리 |
| 파일 암호화 | ✅ | ❌ |
| BYOK | ✅ | ❌ |
| Field Audit Trail | ✅ | ❌ |
| 라이선스 | Shield (별도 구매) | 기본 포함 |
| SOQL 제한 | Probabilistic에서 있음 | 없음 |

---

## 관련 노트
- [[TxnSecurity Namespace]]
- [[Auth Namespace]]
- [[WITH USER_MODE]]
- [[StripInaccessible]]
- [[민감 데이터 저장]] — at-rest 민감 데이터 저장 위협과 암호화 적용 기준
