---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Learning Guide ( SObject in SF Apex)]
---

# Apex 학습 가이드 — Salesforce Apex의 sObject (Part 3)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했습니다.)

## sObject란?

sObject는 "Salesforce Object"를 의미합니다. Salesforce에서 데이터베이스 오브젝트(표준: Account, Contact / 커스텀: Patient__c, Invoice__c)를 나타내는 기본 데이터 타입입니다. Apex에서 Salesforce에 저장된 레코드를 다루는 데 사용됩니다.

## sObject의 유형

1. **표준 오브젝트:** Salesforce가 사전 정의. 접미사 없음. 예: Account, Contact, Opportunity, Case.
2. **커스텀 오브젝트:** 비즈니스 요구로 사용자가 생성. 항상 `__c` 접미사. 예: Invoice__c, Order__c, Patient__c.

## 핵심 포인트

**1. 선언:**

sObject는 해당 오브젝트 타입으로 명시적 선언.
```apex
Account ac;       // 표준 오브젝트
Contact con;      // 표준 오브젝트
Patient__c pt;    // 커스텀 오브젝트
```

**2. 초기화:**
- **수동 초기화:** 새 레코드 삽입 시 `new` 키워드로 초기화(heap에 메모리 할당).
- **쿼리 결과는 초기화 불필요:** SOQL로 기존 레코드 로드 시 시스템이 자동으로 메모리 할당.
```apex
Account ac = new Account(Name = 'Santosh'); // 새 레코드
Account ac = [SELECT Name FROM Account WHERE Name = 'Santosh' LIMIT 1]; // 기존 레코드
```

## sObject로 레코드 삽입

방법 1 — 인라인 초기화:
```apex
Account ac = new Account(Name = 'Santosh Corp', Phone = '1234567890', Industry = 'Technology');
insert ac;
```
방법 2 — 단계별 초기화:
```apex
Account ac = new Account();
ac.Name = 'Santosh Corp';
ac.Phone = '1234567890';
ac.Industry = 'Technology';
insert ac;
```

**초기화가 중요한 이유:**

오브젝트가 데이터를 저장할 메모리 위치를 생성. 초기화 없이는 sObject 레코드를 삽입할 수 없습니다.

## 초기화가 필요 없는 경우

**1. 기존 레코드 쿼리:**

SOQL이 반환한 sObject는 이미 초기화됨.
```apex
Account acc = [SELECT Name FROM Account WHERE Name = 'Santosh' LIMIT 1];
System.debug(acc.Name);
```

**2. Insert 외 DML 작업:**

SOQL로 조회한 레코드는 이미 초기화되어 있어 직접 수행 가능.
```apex
Account acc = [SELECT Name, Phone FROM Account LIMIT 1];
acc.Phone = '9876543210';
update acc;
```
