---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [With Without Inherited Sharing in Apex]
---

# Apex의 with sharing, without sharing, inherited sharing 키워드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

- **With Sharing:** 레코드 권한을 적용합니다. 현재 사용자의 공유 규칙을 강제합니다. 단, with sharing으로 설정해도 오브젝트나 필드 수준 보안 권한은 강제하지 않습니다.

- **Without Sharing:** 이 키워드로 선언된 클래스는 시스템 모드(system mode)에서 실행됩니다. 현재 사용자의 공유 규칙이 강제되지 않습니다.

- **Inherited Sharing:** 호출하는 부모 클래스의 공유 설정을 상속하려면 inherited sharing 키워드로 클래스를 선언합니다.
