---
tags: [Security, Platform-Encryption, Shield, Encryption, Field-Encryption, Database-Encryption, Data-Cloud]
source: external-knowledge
created: 2026-05-23
aliases: [Platform Encryption, 플랫폼 암호화, Shield Platform Encryption, 필드 암호화, 데이터베이스 암호화]
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

## 설정 방법

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
