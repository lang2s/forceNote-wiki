---
tags: [Security, Platform-Encryption, Shield, Encryption, Field-Encryption, Database-Encryption, Data-Cloud]
source: external-knowledge; apex-recipes-main/force-app/main/default/classes/Encryption Recipes/EncryptionRecipes.cls; help.salesforce.com security_pe_permissions (Tier 2); Salesforce Shield Platform Encryption Implementation Guide 2025-03-28판 — Differences Between Classic Encryption and Shield Platform Encryption (Tier 2)
created: 2026-05-23
aliases: [Platform Encryption, 플랫폼 암호화, Shield Platform Encryption, 필드 암호화, 데이터베이스 암호화, constant-time comparison, 타이밍 공격, areEqualConstantTime, 초기화 벡터, developer-managed IV, Classic Encryption, 클래식 암호화, Encrypted Text 필드]
---

# Platform Encryption

> Salesforce Shield의 핵심 기능 — 데이터를 저장(at rest) 시 암호화하여 규정 준수 요건을 충족한다

> [!warning] 이 노트의 **선언적 암호화 개념부**(개념 설명·키 관리 개요·설정 방법·Deterministic vs Probabilistic·SOQL 제한·Data Cloud·Field Audit Trail)는 외부 지식 기반으로 작성되었으며 공식 소스와 아직 대조되지 않았습니다.
> 공식 문서: https://help.salesforce.com/s/articleView?id=sf.security_pe_overview.htm
> 단, 아래는 검증된 부분입니다:
> - **[Shield Platform Encryption vs Classic Encryption](#shield-platform-encryption-vs-classic-encryption) 섹션**과 **설정 전제조건(권한)** — 공식 소스(Tier 2)와 셀 단위 대조 완료.
> - **Crypto 클래스 관련 내용** — [[Crypto 클래스 레퍼런스]](Apex Reference Guide 원문 대조, Tier 1/2)로 위임. 이 노트의 개발자 관리 IV 패턴은 `apex-recipes` 로컬 소스(Tier 1) 발췌.

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

플랫폼 암호화는 선언적(Setup)이라 Apex로 직접 제어하지 않는다. 다만 **추가 커스텀 암호화**가 필요하면 `System.Crypto` 클래스를 쓴다(키 생성·AES 암복호화·MAC·서명 등).

```apex
// AES-256 키 생성 → managed IV 암복호화 (org 내부 저장용)
Blob key = Crypto.generateAesKey(256);
Blob encrypted = Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('Sensitive Data'));
Blob decrypted = Crypto.decryptWithManagedIV('AES256', key, encrypted);
```

> `System.Crypto`의 전 메서드 시그니처·파라미터·예외·알고리즘 목록은 **[[Crypto 클래스 레퍼런스]]** 참조(Tier 1/2, Apex Reference Guide 원문 대조). 아래는 그중 외부 수신자와 암호문을 교환할 때 필요한 실전 패턴만 발췌한다.

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

> ✅ **Tier 2 검증 완료** — 아래 표는 Salesforce Shield Platform Encryption Implementation Guide(2025-03-28판)의 "Differences Between Classic Encryption and Shield Platform Encryption" 공식 비교표와 **셀 단위 대조**를 마쳤다(원본 3열 방향 그대로 유지). Shield는 **Field-Level Encryption**과 **Database Encryption** 두 갈래이므로 공식 표도 3열이다.
>
> ⚠️ 이전 버전 표의 **"SOQL 제한: Classic = 없음"은 오류**였다. 공식 표에서 Classic Encryption의 *Search, Filters, and Queries* 는 **불가(❌)** — Classic 암호화 필드는 필터·쿼리·정렬 모두 안 된다.

| 기능 | Classic Encryption | Shield — Field-Level Encryption | Shield — Database Encryption |
|---|---|---|---|
| 가격 | 기본 사용자 라이선스 포함 | 추가 비용 (add-on) | 추가 비용 (add-on) |
| 저장 시 암호화 (at rest) | ✅ | ✅ | ✅ |
| 네이티브 솔루션 (별도 HW/SW 불필요) | ✅ | ✅ | ✅ |
| 암호화 알고리즘 | 128-bit AES | 256-bit AES (CBC) | 256-bit AES (GCM) |
| HSM 기반 키 유도 | ❌ | ✅ | ✅ |
| Manage Encryption Keys 권한 | ❌ | ✅ | ✅ |
| 키 생성 | ✅ | ✅ | ✅ |
| 키 내보내기·가져오기·파기 | ✅ | ✅ | ❌ |
| 고급 키 옵션 | ❌ | BYOK · Cache-Only Keys · External Key Management | BYOK |
| PCI-DSS L1 준수 | ✅ | ✅ | ✅ |
| 마스킹 (저장값 마스크 표시) | ✅ | ❌ | ❌ |
| 마스크 타입·마스크 문자 지정 | ✅ | ❌ | ❌ |
| 평문 조회에 View Encrypted Data 권한 필요 | ✅ | ❌ | ❌ |
| 표준 필드 암호화 | ❌ | ✅ (지원 표준 필드 한정) | ✅ (모든 표준 필드) |
| 첨부·파일·콘텐츠 암호화 | ❌ | ✅ | ✅ |
| 커스텀 필드 암호화 | 전용 커스텀 필드 타입(Encrypted Text), **175자 제한** | ✅ (지원 커스텀 필드 타입 한정) | ✅ (모든 커스텀 필드) |
| 기존 커스텀 필드를 암호화로 전환 | ❌ | ✅ | ✅ |
| 커스텀 메타데이터·Apex 암호화 | ✅ | ✅ | ✅ |
| 검색·필터·쿼리 | ❌ | ✅ deterministic 스킴 필드에서 UI·부분 검색·룩업·일부 SOSL | ✅ 모든 SOSL·SOQL (field-level로 중복 암호화된 필드 제외) |
| 정렬 (Sorting) | ❌ | ❌ | ✅ (field-level로 중복 암호화된 필드 제외) |
| 전체 DB(표준+커스텀 필드·메타데이터·Apex) 암호화 | ❌ | ❌ | ✅ |
| API 액세스 | ✅ | ✅ | ✅ |
| 워크플로 규칙·워크플로 필드 업데이트 사용 | ❌ | ✅ | ✅ |
| 승인 프로세스 진입 조건·단계 조건 사용 | ❌ | ✅ | ✅ |

### Classic Encryption 실무 특성 (선택 전 반드시 알 것)

Classic Encryption은 "무료 Shield"가 아니라 **범위가 완전히 다른 별개 기능**이다.

- **전용 필드 타입으로만 제공** — 커스텀 필드 생성 시 **Encrypted Text** 타입을 선택해야 한다. 기존 필드를 암호화로 전환할 수 없고(위 표 "기존 커스텀 필드를 암호화로 전환 ❌"), 표준 필드·파일·첨부는 아예 암호화 대상이 아니다.
- **최대 175자** — Encrypted Text 필드 길이 상한.
- **마스킹 내장** — 마스크 타입(예: 마지막 4자만 표시)과 마스크 문자를 지정해 화면에 마스크된 값을 보여준다. 반대로 Shield는 마스킹 기능이 없다(암호화는 저장 계층에서만, 화면 표시는 FLS로 제어).
- **평문 조회 = View Encrypted Data 권한** — 이 권한이 없는 사용자는 마스크된 값만 본다. Shield는 이 권한이 아니라 일반 **필드 레벨 보안(FLS)** 으로 접근을 제어한다.
- **필터·쿼리·정렬 전부 불가** — Classic 암호화 필드는 SOQL WHERE·SOSL·리포트 필터·정렬에 쓸 수 없고, 워크플로 규칙·승인 프로세스 조건에서도 못 쓴다. (Shield Field-Level은 deterministic 스킴이면 exact-match 필터 가능, Database Encryption은 대부분의 쿼리 가능.)

### 언제 Shield를 사야 하나 — 결정 기준

| 요구사항 | 선택 |
|---|---|
| **표준 필드**(이메일·전화·이름 등)나 **파일/첨부**를 암호화해야 함 | Shield (Classic은 불가) |
| 175자 초과 텍스트, 다양한 커스텀 필드 타입, **기존 필드** 암호화 | Shield |
| **키 통제** 요구 — BYOK·Cache-Only Keys·External Key Management·HSM 기반 키 유도 | Shield |
| 암호화 필드를 **필터·검색**에 써야 함 (deterministic) 또는 쿼리·정렬까지 (Database Encryption) | Shield |
| HIPAA·GDPR 등 규정으로 **256-bit AES + 감사 가능한 키 수명주기** 필요 | Shield |
| 소수의 커스텀 텍스트 필드(≤175자)만 가리면 되고, **마스크 표시**가 필요하며, 추가 예산이 없음 | Classic으로 충분 |

> 비용 관점: Classic은 기본 라이선스 포함, Shield는 Enterprise·Performance·Unlimited에서 add-on 구매(Developer Edition은 무료 제공).

---

## 관련 노트
- [[Crypto 클래스 레퍼런스]] — System.Crypto 전 메서드 시그니처·알고리즘·예외 (Apex Reference Guide)
- [[TxnSecurity Namespace]]
- [[Auth Namespace]]
- [[WITH USER_MODE]]
- [[StripInaccessible]]
- [[민감 데이터 저장]] — at-rest 민감 데이터 저장 위협과 암호화 적용 기준
