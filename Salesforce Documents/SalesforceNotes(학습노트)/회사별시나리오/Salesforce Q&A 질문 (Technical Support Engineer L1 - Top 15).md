---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce TSE Interview Questions & Answers Part 2]
---

# Salesforce Q&A 질문 (Technical Support Engineer L1 - Top 15)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. 트리거와 자동화 규칙 실행 순서?**
DB에서 이전 레코드 로드 → 새 값 덮어쓰기 → 시스템 검증 규칙 → before 트리거 → 커스텀 검증 → 레코드 저장(미커밋) → after 트리거 → 할당 규칙 → 자동 응답 규칙 → 워크플로우 규칙 → 에스컬레이션 → 부모 롤업 요약 → DB 커밋.

**2. 한 오브젝트에 before insert 트리거 2개. 실행 순서 제어?** 트리거 순서는 미리 정할 수 없음. 오브젝트당 트리거 하나 + 주석으로 로직 분리 권장.

**3. User 삭제?** 삭제 불가, 비활성화만 가능.

**4. User 데이터 삭제?** Setup → Data Management → Mass Delete Record에서 오브젝트·사용자 기준 선택 후 삭제.

**5. 특정 레코드(Opportunity) 사용자 접근 제한?** OWD에서 Opportunity를 Private로. 단 양쪽이 Admin·View All 권한이면 Private 무효화.

**6. trigger.new vs trigger.old?** new는 DB에 삽입될 sObject 목록(insert·update, before에서 수정 가능). old는 이미 DB에 있는 레코드(update·delete).

**7. 트리거 1회만 실행?** 트리거는 워크플로우 전후 두 번 발동 가능. 클래스에 static boolean으로 제어.

**8. Task의 WhoId vs WhatId?** WhoId는 사람(Lead·Contact), WhatId는 오브젝트(Account·Opportunity).

**9. Visualforce 오류 메시지 표시?**
```apex
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required fields are missing.'));
```
VF: `<apex:pageMessages></apex:pageMessages>`

**10. render vs rerender vs renderAs?** render는 CSS display처럼 표시/숨김, rerender는 부분 새로고침, renderAs는 PDF·doc·excel 변환(`renderAs="pdf"`).

**11. External ID vs Unique ID?** External ID는 외부 시스템 ID 참조(사이드바 검색 가능, upsert에 사용, Text/Number/Email). Unique ID는 같은 값 중복 방지 설정.

**12. with sharing인데 왜 without sharing이 필요?** classA(with sharing)가 classB 호출 시 classB가 키워드 없으면 with sharing 적용됨. 이를 피하려면 classB에 without sharing 명시.

**13. COUNT() vs COUNT(fieldName)?** COUNT()는 SELECT의 유일 요소, LIMIT 가능, ORDER BY·GROUP BY 불가. COUNT(fieldName)는 ORDER BY·GROUP BY 가능.

**14. GROUP BY와 WHERE?** GROUP BY에는 WHERE 대신 HAVING.
```sql
SELECT COUNT(Id), Name FROM Opportunity GROUP BY Name HAVING COUNT(Id) > 1 AND Name LIKE '%ABC%'
```

**15. 필드 필수화 방법?** 필드 생성 시, 검증 규칙, 페이지 레이아웃.

**16. 코딩 모범 사례?** 코드 벌크화, FOR 루프 안 SOQL 회피, 오브젝트당 단일 트리거, Limits 메서드 활용, ID 하드코딩 금지.
