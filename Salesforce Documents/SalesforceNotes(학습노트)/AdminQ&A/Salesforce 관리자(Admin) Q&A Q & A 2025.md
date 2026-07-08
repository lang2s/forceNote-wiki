---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesoforce Admin Interview Q & A 2025]
---

# Salesforce 관리자(Admin) Q&A Q & A 2025

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> ⚠️ 원본은 이미지 PDF로, 일부 답변이 그래픽 이미지에 포함되어 OCR로 완전히 추출되지 않았습니다. 추출된 질문·답변에 표준적인 보충 설명을 더해 정리했습니다.

**1. 조직 전체 기본값(OWD)과 데이터 보안에 미치는 영향**

OWD는 Salesforce의 기준(baseline) 보안 설정으로, 사용자가 소유하지 않은 레코드에 대한 기본 접근 수준을 정의합니다. 공유 규칙, 역할, 수동 공유가 적용되기 전, 레코드에 대한 가장 엄격한 접근 수준을 결정함으로써 데이터 보안에 영향을 줍니다.

**2. Profile과 Permission Set의 차이**

- **Profiles:** 사용자의 기본 권한, 필드 접근, 페이지 레이아웃을 정의합니다. 모든 사용자는 프로필을 할당받아야 합니다.
- **Permission Sets:** 프로필을 변경하지 않고 추가 권한을 부여합니다. 여러 프로필을 만들지 않고 특정 사용자에게 접근을 확장할 때 유용합니다.

**3. Role Hierarchy vs Sharing Rules**

Role Hierarchy는 계층 구조에 따라 상위 사용자가 하위 사용자의 레코드에 접근하도록 하는 수직적 접근 모델입니다. Sharing Rules는 OWD에 대한 예외로, 소유권이나 기준에 따라 특정 그룹·역할에 레코드 접근을 확장합니다(수평적 공유).

**4. Salesforce의 관계 유형**

Lookup 관계(느슨한 결합, 부모 삭제 시 자식 유지), Master-Detail 관계(강한 결합, cascade delete, 롤업 요약 가능), Many-to-Many(정션 오브젝트 사용), Hierarchical(User 오브젝트 전용).

**5. 특정 필드 접근 제한(Restricting Access to Specific Fields)**

필드 수준 보안(Field-Level Security)을 사용해 프로필이나 권한 집합에서 필드 가시성을 Visible/Read-Only/Hidden으로 설정하여 특정 필드 접근을 제한합니다.

**6. 레코드 접근 문제 해결(Troubleshooting Record Access)**

레코드 접근 문제는 다음을 확인하여 진단합니다: OWD 설정, 역할 계층상 위치, 공유 규칙, 수동 공유, 권한 집합의 View All/Modify All, 오브젝트·필드 수준 권한.

**7. Process Builder vs Flow**

Process Builder는 단순한 선언적 자동화 도구(현재는 단종 방향)이며, Flow는 화면 상호작용, 복잡한 로직, 다단계 자동화를 지원하는 더 강력한 도구로 Salesforce가 권장하는 자동화 도구입니다.

**8. Salesforce에서 공유(Sharing)가 작동하는 방식**

OWD가 기준 접근을 설정하고, Role Hierarchy·Sharing Rules·Manual Sharing·Apex Sharing이 그 위에 접근을 확장합니다. OWD가 가장 제한적이며, 다른 메커니즘으로 접근을 넓힐 수 있습니다(좁힐 수는 없음).

**9. Roles vs Profiles**

Profile은 오브젝트·필드 수준 권한(무엇을 할 수 있는지)을 정의하며 필수입니다. Role은 레코드 수준 데이터 가시성(무엇을 볼 수 있는지)을 정의하며 선택 사항입니다.

**10. Lookup 관계에 롤업 요약 필드를 만들 수 있나요?**

아니요. 롤업 요약 필드는 Master-Detail 관계에서만, master 오브젝트에 생성할 수 있습니다. Lookup 관계에서는 코드(Apex)나 Flow, 또는 AppExchange 앱으로 동일한 기능을 구현해야 합니다.
