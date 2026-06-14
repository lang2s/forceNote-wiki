---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [DYNAMIC SOSL IN SALESFORCE]
---

# Salesforce의 동적 SOSL

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## 동적 SOSL이란?
런타임에 Apex 코드로 SOSL 쿼리를 동적 생성. 사용자 입력 기반 검색이나 다른 필드명으로 레코드 수정 등 유연성 제공.

## 참고
동적 SOSL 쿼리는 sObject 목록의 목록을 반환하며, 각 목록은 특정 sObject 유형 검색 결과. 결과는 쿼리에 명시된 순서로 반환(예: Account → Contact → Lead).

`Search.query` 메서드를 일반 SOSL을 쓰는 곳(할당문·for 루프)에서 사용 가능. 결과는 정적 SOSL과 동일하게 처리.
