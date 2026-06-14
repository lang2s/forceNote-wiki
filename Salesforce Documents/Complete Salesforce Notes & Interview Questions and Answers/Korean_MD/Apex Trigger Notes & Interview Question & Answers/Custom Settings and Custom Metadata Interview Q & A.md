---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Custom Settings and Custom Metadata Interview Q & A]
---

# Custom Settings 및 Custom Metadata 면접 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 대부분의 면접에서 자주 묻는 핵심 질문과 답변

## 기본 개념 질문

**1. Salesforce에서 Custom Setting(커스텀 설정)이란 무엇인가요?**

조직 전체에서 접근할 수 있는 커스텀 데이터 값을 저장할 수 있게 해주는 커스텀 오브젝트입니다. 구성 변수(configuration variables)와 유사하게 애플리케이션 설정을 정의하고 접근하는 방법을 제공합니다.

**2. Custom Setting은 Custom Object와 어떻게 다른가요?**

둘 다 데이터를 저장할 수 있지만, Custom Setting은 사용자 전반에 걸쳐 일관된 데이터를 저장하도록 설계된 반면, Custom Object는 각 레코드나 사용자마다 고유한 데이터를 저장합니다.

**3. Custom Setting에는 어떤 종류가 있나요?**

Salesforce는 두 가지 유형의 Custom Setting을 제공합니다: 계층형(hierarchical) Custom Setting과 목록형(list) Custom Setting입니다.

**4. 계층형(Hierarchical) Custom Setting이란?**

조직(organization), 프로필(profile), 사용자(user) 등 서로 다른 수준에서 다른 값을 정의할 수 있는 유형입니다. 상위 수준에서 정의된 값이 하위 수준에서 정의된 값을 덮어씁니다(override).

**5. 목록형(List) Custom Setting이란?**

Salesforce 조직 내에서 접근하고 참조할 수 있는 값들의 목록을 정의할 수 있는 유형입니다. Custom Object와 유사하지만 미리 정의된 레코드 집합을 가집니다.

**6. Salesforce에서 Custom Metadata(커스텀 메타데이터)란 무엇인가요?**

Custom Setting과 유사하지만, 데이터 대신 메타데이터를 저장하도록 설계되었습니다. 개발자가 자신만의 메타데이터 타입과 레코드를 만들어 환경 간에 배포하고 프로그래밍 방식으로 접근할 수 있게 해줍니다.

**7. Custom Metadata는 Custom Setting과 어떻게 다른가요?**

Custom Metadata는 메타데이터 구성을 저장하는 데 사용되고, Custom Setting은 데이터 값을 저장하는 데 사용됩니다. Custom Metadata는 "커스터마이징 가능한 메타데이터"라고 생각할 수 있습니다.

**8. Custom Metadata를 사용하는 이점은 무엇인가요?**

애플리케이션을 더 구성 가능하고 동적으로 만들어 줍니다. 메타데이터 구성을 쉽게 배포할 수 있고, 특정 설정을 하드코딩할 필요가 없으며, 관리자나 개발자가 코드를 수정하지 않고도 구성을 변경할 수 있는 유연성을 제공합니다.

**9. Apex 코드에서 Custom Setting과 Custom Metadata에 어떻게 접근하나요?**

SOQL 쿼리를 사용해 접근할 수 있습니다. Custom Setting의 경우 Salesforce가 제공하는 내장 `Hierarchy Custom Setting` 메서드를 사용해 접근할 수도 있습니다.

**10. Salesforce에서 Custom Label(커스텀 라벨)이란?**

Apex 코드, Visualforce 페이지, Lightning 컴포넌트, 이메일 템플릿에서 접근할 수 있는 번역 가능한 텍스트를 저장하는 데 사용됩니다. 사용자에게 표시되는 텍스트의 현지화(localization)와 커스터마이징을 쉽게 해줍니다.

**11. Apex 코드에서 Custom Label은 어떻게 참조하나요?**

`Label` 전역 키워드 뒤에 커스텀 라벨의 이름을 붙여 참조합니다. 예: `String myLabel = Label.My_Custom_Label`.

**12. Custom Label을 다른 언어로 번역할 수 있나요?**

네, Salesforce의 Translation Workbench 또는 Lightning Experience Translation Workbench를 사용해 다른 언어로 번역할 수 있습니다.

> 위 질문과 답변을 충분히 익히고 개념을 철저히 이해한 뒤, Salesforce에서 직접 구현해 보며 면접 준비를 강화하세요.

## 시나리오 기반 질문

**1. 시나리오: 특정 구성 가능한 설정이 필요한 관리형 패키지(managed package)를 작업하고 있습니다. 패키지 사용자에게 유연성을 제공하기 위해 Custom Setting을 어떻게 활용할 수 있나요?**

관리형 패키지에서 계층형 Custom Setting을 활용할 수 있습니다. 조직, 프로필, 사용자 수준에서 Custom Setting을 정의하면, 패키지 사용자는 코드를 수정하지 않고도 패키지 동작을 커스터마이징할 수 있습니다. 자신의 필요에 따라 기본 설정을 재정의할 수 있습니다.

**2. 시나리오: 외부 시스템과 통합하는 Salesforce 애플리케이션을 개발했습니다. 외부 시스템의 엔드포인트 URL은 조직마다 다를 수 있습니다. 이 동적 구성을 어떻게 처리하나요?**

Custom Metadata 타입을 사용해 외부 시스템의 엔드포인트 URL을 저장할 수 있습니다. Custom Metadata 레코드를 만들면 관리자나 사용자가 각자의 조직에 맞게 URL을 쉽게 구성할 수 있습니다. 애플리케이션은 이 값을 Custom Metadata 레코드에서 가져와 엔드포인트 URL을 동적이고 구성 가능하게 만들 수 있습니다.

**3. 시나리오: 다국어 Salesforce 애플리케이션을 개발 중이며, 표시되는 모든 텍스트를 쉽게 번역할 수 있도록 하고 싶습니다. Custom Label을 사용해 어떻게 달성하나요?**

Custom Label은 다국어 애플리케이션에 이상적인 솔루션입니다. 번역 가능한 텍스트를 Custom Label에 저장하여 쉽게 현지화하고 커스터마이징할 수 있습니다. Apex 코드, Visualforce 페이지, Lightning 컴포넌트, 이메일 템플릿에서 적절한 Custom Label을 참조하면 사용자에게 표시되는 텍스트를 손쉽게 여러 언어로 번역할 수 있습니다.

**4. 시나리오: Salesforce 조직에 권한 요구사항이 다른 여러 사용자 역할이 있습니다. 애플리케이션 내에서 역할별 동작을 정의하기 위해 Custom Setting을 어떻게 사용하나요?**

목록형 Custom Setting을 활용하면 사용자 역할에 따라 서로 다른 값 집합을 정의할 수 있습니다. 각 역할은 자체 Custom Setting 값 목록을 가질 수 있어 역할별로 애플리케이션 동작을 커스터마이징할 수 있습니다. 애플리케이션은 사용자의 역할에 따라 적절한 Custom Setting 값을 가져와 역할별 동작을 적용합니다.

**5. 시나리오: 시간이 지나면서 변경될 수 있는 라벨과 메시지가 포함된 Visualforce 페이지가 있습니다. 이 페이지의 코드를 수정하지 않고도 라벨과 메시지를 업데이트할 수 있게 하려면 어떻게 하나요?**

Visualforce 페이지에서 사용하는 라벨과 메시지를 Custom Label에 저장할 수 있습니다. Visualforce 페이지에서 Custom Label을 참조하면, 라벨이나 메시지에 대한 변경 사항을 해당 Custom Label만 업데이트하여 페이지 코드를 수정하지 않고도 적용할 수 있습니다. 이는 표시 텍스트 변경이 필요할 때 유연성과 유지보수성을 제공합니다.
