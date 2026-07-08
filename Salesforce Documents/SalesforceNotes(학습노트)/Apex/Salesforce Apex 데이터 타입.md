---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Data Types in Salesforce]
---

# Salesforce Apex 데이터 타입

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Apex는 변수 사용 전 선언이 필요한 강타입(tightly coupled) 언어입니다. 변수 정의 시 데이터 타입을 지정해야 하며, 데이터 타입은 1) 변수가 담을 수 있는 데이터 유형과 2) 값 저장에 필요한 메모리를 설명합니다.

**데이터 유형:**

Primitive, sObject, Collection, Enum.

## Primitive 데이터 타입

1. **Integer:** 소수점 없는 숫자. 범위 -2³¹~2³¹-1, 4바이트. Number·Currency·Percent 필드가 기본 참조. `Integer x = 10;`
2. **Long:** 더 큰 값. 범위 -2⁶³~2⁶³-1, 8바이트. 9자리 초과. `Long num = 1234567890123456L;`
3. **Double:** 소수점이 있는 부동소수점. 범위 -1.79E308~1.79E308.
4. **Decimal:** 소수 값, 8바이트. Currency 필드가 기본 참조.
5. **String:** 영숫자+특수문자. Text, Text Area, Email, Phone, URL, Picklist 등이 기본 참조.
6. **Date:** 날짜 값, 8바이트. Date 필드가 기본 참조. `Date.today()`로 오늘 날짜.
7. **ID:** Salesforce가 생성한 18자리 ID. 모든 ID·Lookup·Master-Detail 필드가 기본 참조.
8. **DateTime:** 날짜+시간 타임스탬프, 8바이트.
9. **Boolean:** TRUE/FALSE. Checkbox 필드가 기본 참조.
10. **Blob (Binary Large Objects):** 이미지·오디오·비디오·첨부 등. 바이너리로 변환되어 저장. 최대 2GB.

## sObject 데이터 타입

Salesforce 표준·커스텀 오브젝트를 나타냄. 레코드 저장에 사용. 동적 메모리 할당(런타임), Heap Memory에 위치.

## Collection 데이터 타입

- **List:** 순서 있는 컬렉션. 동질·이질 요소 저장 가능.
- **Set:** 고유 값. 동적 메모리 할당(런타임에 크기 변동).
- **Map:** 키-값 쌍. 키·값은 Primitive/SObject/Apex/Collection/사용자 정의 타입.

## 모범 사례

- 구체적 타입 사용(Object 대신 Integer·Decimal·Boolean)
- 숫자에 String 사용 회피(Integer·Decimal 사용)
- 컬렉션 현명하게 사용(List=순서, Set=고유, Map=키-값)
- 컬렉션 항상 초기화(NullPointerException 방지)
- 쿼리에 sObject 사용(`List<Account>`)
- 플래그에 Boolean 사용
- 대용량 데이터에 Blob 사용
- 고정 값에 final 상수 선언
- 고정 값 집합에 Enum 사용(타입 안전성)
