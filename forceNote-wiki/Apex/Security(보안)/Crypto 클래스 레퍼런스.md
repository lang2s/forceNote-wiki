---
tags: [Apex, Security, Crypto, Encryption, AES, Digest, HMAC, Signature, System-Namespace]
source: salesforce_apex_reference_guide.pdf — System Namespace > Crypto Class (Apex Reference Guide)
created: 2026-07-08
aliases: [Crypto Class, System.Crypto, Crypto 클래스, 암호화 클래스, encrypt, decrypt, encryptWithManagedIV, decryptWithManagedIV, generateDigest, generateMac, verifyHMac, sign, signWithCertificate, signXML, verify, generateAesKey, getRandomInteger, getRandomLong, AES256-GCM, 다이제스트, 디지털 서명]
---

# Crypto 클래스 레퍼런스

> `System.Crypto` — 다이제스트(digest)·메시지 인증 코드(MAC)·디지털 서명 생성과 데이터 암호화/복호화를 위한 정적 메서드 모음 (System 네임스페이스, 전 메서드 static)

---

## 개요

`Crypto` 클래스는 Lightning Platform 내부 콘텐츠 보호나 Google·AWS 같은 외부 서비스 연동에 쓰인다. **모든 메서드는 static**이며, 각 메서드는 목적에 따라 지원하는 AES 알고리즘 집합이 다르므로 사용 전 메서드별 허용 값을 반드시 확인한다.

### 지원 암호화 모드

`Crypto`는 **GCM(Galois Counter Mode)** 과 **CBC(Cipher Block Chaining)** 를 지원한다.

| 모드 | 사용 규칙 |
|---|---|
| **CBC** | `encrypt`/`decrypt`에서는 **16바이트(128비트) IV**를 직접 제공. AES / CBC / PKCS7 패딩 사용. |
| **GCM** | `encrypt`/`decrypt`에서는 **IV를 제공하지 않는다**(non-null IV면 에러). 현재 **256비트(AES256-GCM)만** 지원. |
| **CBC + ManagedIV** | Salesforce가 IV 제공. aaData 없는 버전에서만 CBC 사용 가능. |
| **GCM + ManagedIV** | Salesforce가 12바이트 IV 생성. aaData(추가 인증 데이터) 선택적. |

> GCM으로 암호화하면 최종 결과 = IV 길이(항상 12) + Salesforce 생성 12바이트 IV + 암호문.

### 암호화 알고리즘 (`algorithmName`)

| 모드 | 변형(VARIANT) | 설명 |
|---|---|---|
| CBC | `AES128`, `AES128-CBC` | AES 128비트 CBC + PKCS7 패딩 (두 값 중 아무거나) |
| CBC | `AES192`, `AES192-CBC` | AES 192비트 CBC + PKCS7 패딩 |
| CBC | `AES256`, `AES256-CBC` | AES 256비트 CBC + PKCS7 패딩 |
| GCM | `AES256-GCM` | AES 256비트 GCM, 패딩 없음. 현재 256비트만 지원 |

### 서명 알고리즘 (sign/verify 계열)

| 타입 | 변형 | 설명 |
|---|---|---|
| RSA | `RSA`, `RSA-SHA1` | SHA1 해시의 RSA 서명 (두 값 동일) |
| RSA | `RSA-SHA256` | SHA256 해시의 RSA 서명 |
| RSA | `RSA-SHA384` | SHA384 해시의 RSA 서명 |
| RSA | `RSA-SHA512` | SHA512 해시의 RSA 서명 |
| ECDSA (DER) | `ECDSA-SHA256` | SHA256 해시의 ECDSA 서명 |
| ECDSA (DER) | `ECDSA-SHA384` | SHA384 해시의 ECDSA 서명 |
| ECDSA (DER) | `ECDSA-SHA512` | SHA512 해시의 ECDSA 서명 |
| ECDSA (P1363) | `ECDSA-SHA256-P1363` | SHA256 해시의 ECDSA 서명 (P1363 형식) |
| ECDSA (P1363) | `ECDSA-SHA256-PLAIN` | SHA256 해시의 ECDSA 서명(P1363). JWT가 `invalid_client`를 반환할 때 사용 |
| ECDSA (P1363) | `ECDSA-SHA384-P1363` | ECDSA 서명 (P1363 형식) |
| ECDSA (P1363) | `ECDSA-SHA512-P1363` | ECDSA 서명 (P1363 형식) |

> **`invalid_client` 오류:** Shield Platform Encryption에서 P1363 형식 커스텀 JWT + `ECDSA-SHA256`을 쓰면 발생할 수 있다. 해결책은 `ECDSA-SHA256-PLAIN`으로 교체. `ECDSA-SHA256-PLAIN`은 여러 `sign()`/`verify()` 메서드에서 사용 가능하다.

---

## 암호화/복호화 메서드

### `encrypt(algorithmName, secretKey, initializationVector, clearText)` → Blob

IV를 **직접 지정**해 `clearText`를 암호화한다.

```apex
public static Blob encrypt(String algorithmName, Blob secretKey, Blob initializationVector, Blob clearText)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `algorithmName` | String | `AES128`/`AES128-CBC`, `AES192`/`AES192-CBC`, `AES256`/`AES256-CBC`, `AES256-GCM` |
| `secretKey` | Blob | 128/192/256비트 = 16/24/32바이트. `generateAesKey`로 생성 가능 |
| `initializationVector` | Blob | CBC: 128비트(16바이트) 필수 / GCM: 제공 금지(non-null이면 에러) |
| `clearText` | Blob | 암호화할 평문 |

```apex
public class TestEncrypt {
    public void testEncrypt(){
        Blob exampleIv = Blob.valueOf('Example of IV123');   // 16바이트
        Blob key = Crypto.generateAesKey(128);
        Blob data = Blob.valueOf('Encryption Example Text.');
        Blob encrypted = Crypto.encrypt('AES128', key, exampleIv, data);
        Blob decrypted = Crypto.decrypt('AES128', key, exampleIv, encrypted);
        Assert.areEqual('Encryption Example Text.', decrypted.toString());
    }
}
```

### `decrypt(algorithmName, secretKey, initializationVector, cipherText)` → Blob

`encrypt` 또는 서드파티가 만든 `cipherText`를 복호화한다. 파라미터는 `encrypt`와 동일하되 마지막이 `cipherText`(암호문). 반환은 복호화된 Blob.

```apex
public static Blob decrypt(String algorithmName, Blob secretKey, Blob initializationVector, Blob cipherText)
```

### `encryptWithManagedIV(algorithmName, secretKey, clearText)` → Blob

Salesforce가 **IV를 생성**하도록 맡긴다. aaData 없는 버전.

```apex
public static Blob encryptWithManagedIV(String algorithmName, Blob secretKey, Blob clearText)
```

- 허용 알고리즘: `AES128`/`-CBC`, `AES192`/`-CBC`, `AES256`/`-CBC`, `AES256-GCM`.
- 반환 Blob 구조: **CBC** → 앞 128비트(16바이트)가 IV + 암호문. **GCM** → IV 길이(항상 12) + 96비트(12바이트) Salesforce 생성 IV + 암호문.

```apex
Blob key = Crypto.generateAesKey(128);
Blob data = Blob.valueOf('Data to be encrypted');
Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
Blob decrypted = Crypto.decryptWithManagedIV('AES128', key, encrypted);
```

### `encryptWithManagedIV(algorithmName, secretKey, clearText, aaData)` → Blob

추가 인증 데이터(aaData)를 사용하는 버전. **CBC 미지원 — `AES256-GCM`만 허용.** `aaData`는 필수.

```apex
public static Blob encryptWithManagedIV(String algorithmName, Blob secretKey, Blob clearText, Blob aaData)
```

```apex
Blob key = Crypto.generateAesKey(256);
Blob data = Blob.valueOf('Data to be encrypted');
Blob aad  = Blob.valueOf('Additional tag');
Blob encrypted = Crypto.encryptWithManagedIV('AES256-GCM', key, data, aad);
Blob decrypted = Crypto.decryptWithManagedIV('AES256-GCM', key, encrypted, aad);
```

### `decryptWithManagedIV(algorithmName, secretKey, IVAndCipherText)` → Blob

```apex
public static Blob decryptWithManagedIV(String algorithmName, Blob secretKey, Blob IVAndCipherText)
```

`IVAndCipherText` = IV + 암호문 결합값. **CBC** → 앞 16바이트가 IV. **GCM** → IV 길이(12) + 12바이트 IV + 암호문. aaData 없는 버전.

### `decryptWithManagedIV(algorithmName, secretKey, IVAndCipherText, aaData)` → Blob

aaData 사용 버전. **CBC 미지원 — `AES256-GCM`만.** `aaData` 필수. `IVAndCipherText` = IV 길이(12) + 12바이트 IV + 암호문.

```apex
public static Blob decryptWithManagedIV(String algorithmName, Blob secretKey, Blob IVAndCipherText, Blob aaData)
```

---

## 암호화/복호화 예외

`decrypt`·`encrypt`·`decryptWithManagedIV`·`encryptWithManagedIV`에서 발생 가능(System 네임스페이스 예외의 부분집합):

| 예외 | 발생 조건 |
|---|---|
| `InvalidParameterValue` — "Unable to parse the initialization vector…" | managed IV 사용 중 암호문이 16바이트 미만 |
| `InvalidParameterValue` — "Invalid algorithm…" | 알고리즘명이 허용 값이 아님 |
| `InvalidParameterValue` — "Invalid private key. Must be size bytes." | 키 크기가 알고리즘과 불일치 |
| `InvalidParameterValue` — "Invalid initialization vector…" | CBC IV가 16바이트가 아님 (GCM은 12바이트) |
| `InvalidParameterValue` — "AAD can only be used with AESGCM algorithms." | GCM이 아닌데 aaData 제공 |
| `InvalidParameterValue` — "Invalid data. …exceeds the limit of 1,048,576 bytes." | 데이터 1MB 초과 (복호화 시 IV 헤더+패딩 포함 1,048,608바이트 허용) |
| `NullPointerException` | 필수 인자가 null |
| `SecurityException` — "Given final block isn't properly padded." | 블록 정렬 안 됨 등 |
| `SecurityException` — 메시지 가변 | 암호화/복호화 중 일반 오류 |

> **Padding Oracle 공격 방어:** CBC는 AES/CBC/PKCS7 패딩이라 Padding Oracle 공격에 취약하다. **Encrypt-then-MAC** 패턴(암호문 생성 후 별도 키로 `generateMac`으로 MAC을 붙여 전송, 복호화 전 `verifyHMac`로 무결성·진위 먼저 검증 → 실패 시 복호화하지 않고 예외)으로 방어하거나, 아예 **GCM 알고리즘**을 쓴다.

---

## 다이제스트·MAC 메서드

### `generateDigest(algorithmName, input)` → Blob

지정 알고리즘으로 `input`의 안전한 단방향 해시 다이제스트를 계산한다.

```apex
public static Blob generateDigest(String algorithmName, Blob input)
```

허용 `algorithmName`: **`MD5`, `SHA1`, `SHA3-256`, `SHA3-384`, `SHA3-512`, `SHA-256`, `SHA-512`**

```apex
Blob targetBlob = Blob.valueOf('ExampleMD5String');
Blob hash = Crypto.generateDigest('MD5', targetBlob);
String result = EncodingUtil.base64Encode(hash);
```

### `generateMac(algorithmName, input, privateKey)` → Blob

private key와 지정 알고리즘으로 `input`의 MAC(메시지 인증 코드)을 계산한다.

```apex
public static Blob generateMac(String algorithmName, Blob input, Blob privateKey)
```

허용 `algorithmName`: **`hmacMD5`, `hmacSHA1`, `hmacSHA256`, `hmacSHA512`**

> `privateKey`를 Base64 인코딩해 넘겼다면, `verifyHMac` 검증 시에도 반드시 Base64 인코딩된 키를 넘겨야 한다. 키는 **4KB 초과 불가**.

```apex
String salt = String.valueOf(Crypto.getRandomInteger());
Blob data = Crypto.generateMac('HmacSHA256', Blob.valueOf(salt), Blob.valueOf('key'));
```

### `verifyHMac(algorithmName, data, privateKey, macToVerify)` → Boolean

`data`의 HMAC 서명을 알고리즘·private key·mac으로 검증한다. 허용 `algorithmName`은 `generateMac`과 동일(`hmacMD5`/`hmacSHA1`/`hmacSHA256`/`hmacSHA512`).

```apex
public static Boolean verifyHMac(String algorithmName, Blob data, Blob privateKey, Blob macToVerify)
```

- `privateKey`: MAC 생성 시 Base64 인코딩했다면 여기서도 Base64여야 함. 4KB 초과 불가.
- 반환: 검증 성공 여부. **이 메서드는 안전(상수 시간) 비교를 내부에서 수행**하므로 반환 Boolean만 확인하면 된다.

---

## 서명·검증 메서드

### `sign(algorithmName, input, privateKey)` → Blob

private key로 `input`의 디지털 서명을 계산한다.

```apex
public static Blob sign(String algorithmName, Blob input, Blob privateKey)
```

- `algorithmName`: RSA/ECDSA 서명 알고리즘(위 "서명 알고리즘" 표).
- `privateKey`: `EncodingUtil.base64Decode`로 디코드한, RSA PKCS #8 형식 키. 4KB 초과 불가.

```apex
Blob input = Blob.valueOf('Some text.');
Blob privateKey = EncodingUtil.base64Decode('<pkcs8 private key text>'); // BEGIN/END 헤더 제외
Blob signedKey = Crypto.sign('RSA', input, privateKey);
```

### `signWithCertificate(algorithmName, input, certDevName)` → Blob

org의 **Certificate and Key Management**에 저장된 인증서/키 쌍으로 서명한다.

```apex
public static Blob signWithCertificate(String algorithmName, Blob input, String certDevName)
```

- `certDevName`: Setup > Certificate and Key Management의 Unique Name 값.

```apex
Blob input = Blob.valueOf('Test Sign With Certificate.');
Blob signedKey = Crypto.signWithCertificate('RSA', input, 'your-cert-unique-name');
```

### `signXML(algorithmName, node, idAttributeName, certDevName)` → void

서명을 XML 문서에 봉투(envelope)로 삽입한다.

```apex
public Void signXML(String algorithmName, Dom.XmlNode node, String idAttributeName, String certDevName)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `node` | Dom.XmlNode | 서명하고 서명을 삽입할 XML 노드 |
| `idAttributeName` | String | 참조 ID로 쓸 속성의 전체 이름(네임스페이스 포함). null이면 노드의 ID 속성 사용, 없으면 Salesforce가 새 ID 생성·추가 |
| `certDevName` | String | 서명에 쓸 인증서 Unique Name |

반환값 없음 — 서명 봉투가 `node` 안에 삽입된다.

```apex
Dom.Document doc = new Dom.Document();
doc.load('<?xml version="1.0"?><customers><customer id="2"><name>Company One</name></customer></customers>');
System.Crypto.signXML('RSA', doc.getRootElement(), null, 'your-cert-unique-name');
```

### `signXML(algorithmName, node, idAttributeName, certDevName, refChild)` → void

서명 봉투를 지정한 자식 노드 **앞에** 삽입하는 오버로드.

```apex
public static void signXml(String algorithmName, Dom.XmlNode node, String idAttributeName, String certDevName, Dom.XmlNode refChild)
```

- `refChild`: 이 노드 앞에 서명 삽입. null이면 끝에 추가.

### `verify(algorithmName, data, signature, publicKey)` → Boolean

public key로 `data`의 디지털 서명을 검증한다(`sign` 또는 서드파티가 만든 서명 검증).

```apex
public static Boolean verify(String algorithmName, Blob data, Blob signature, Blob publicKey)
```

- `signature`: RSA/ECDSA 호환 서명.
- `publicKey`: `EncodingUtil.base64Decode`로 디코드한 X.509 표준 형식.
- 반환: 서명이 성공적으로 검증되면 `true`.

### `verify(algorithmName, data, signature, certDevName)` → Boolean

org에 저장된 인증서(`certDevName`)에 연결된 public key로 검증한다(`signWithCertificate`로 만든 서명 검증).

```apex
public static Boolean verify(String algorithmName, Blob data, Blob signature, String certDevName)
```

---

## 키·난수 생성 메서드

### `generateAesKey(size)` → Blob

AES 키를 생성한다. `size`(Integer)는 **128 / 192 / 256** 중 하나(비트).

```apex
public static Blob generateAesKey(Integer size)
Blob key = Crypto.generateAesKey(256);
```

### `getRandomInteger()` → Integer

랜덤 **4바이트 정수**. Salesforce가 `java.security.SecureRandom`을 호출해 생성.

```apex
public static Integer getRandomInteger()
```

### `getRandomLong()` → Long

랜덤 **8바이트 long**. 동일하게 `java.security.SecureRandom` 기반.

```apex
public static Long getRandomLong()
```

---

## 상수 시간 비교 관련 주의

`Crypto` 클래스에는 **상수 시간 비교(constant-time comparison) 전용 메서드가 없다.** 다만 `verifyHMac`과 `verify`는 내부적으로 안전 비교를 수행하므로, HMAC·서명 검증 시에는 반환 Boolean만 확인하면 된다.

반면 **직접 재계산한 다이제스트(`generateDigest` 결과)를 수신값과 비교**할 때는 일반 `==`(early-exit로 타이밍 공격에 취약)를 쓰지 말고 **상수 시간 비교 함수**를 직접 구현해 써야 한다. 이 실전 패턴(`areEqualConstantTime`)은 [[Platform Encryption]] 노트에 있다.

---

## 관련 노트
- [[Platform Encryption]] — Shield 선언적 암호화 + 개발자 관리 IV·상수 시간 비교 실전 패턴
- [[민감 데이터 저장]] — at-rest 민감 데이터 저장 위협과 암호화 적용 기준
- [[Auth Namespace]] — JWT·서명 검증이 연계되는 인증 네임스페이스
