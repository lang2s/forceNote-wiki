---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Personal Labels]
---

# Salesforce 개인 라벨(Personal Labels)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 소개

Salesforce에서 데이터를 효과적으로 관리·정리하는 것은 생산성 유지에 필수적입니다. 개인 라벨은 이를 단순화하는 유용한 방법으로, 사용자가 필요에 따라 레코드를 분류·정리하는 커스텀 태그를 만들 수 있게 합니다. 조직 전체에 균일하게 적용되는 일반 라벨과 달리, 개인 라벨은 각 사용자에게 고유하여 데이터 관리에 개인화된 측면을 더합니다.

## 개인 라벨

Lead, Account, Contact, Opportunity 등 다양한 레코드에 할당할 수 있는 사용자 생성 태그입니다. 개인 기준과 선호에 따라 레코드를 빠르게 식별·그룹화하는 데 도움이 됩니다. 예: 영업 담당자가 "High Priority", "Needs Follow Up", "New Lead" 같은 라벨로 워크플로우 개선.

**사용 사례:** Lead 상태가 "Working & Contacted"인 Lead를 빠르고 효율적으로 분류.

## 개인 라벨 생성 단계

1. App Launcher로 이동
2. Labels 선택
3. New를 눌러 새 라벨 생성 시작
4. 명확하고 알아보기 쉬운 라벨 이름 입력

## 특정 Lead 레코드에 라벨 할당

1. Lead List 뷰에서 라벨을 붙일 항목 선택
2. 목록 드롭다운 메뉴 클릭 → "Assign Label" 선택
3. 프롬프트에서 검색창에 개인 라벨 이름 입력해 찾기
4. 원하는 라벨 선택 후 "Save" 클릭

라벨 레코드 페이지에서 해당 라벨에 할당된 레코드 모음을 볼 수 있습니다.

## Lightning Record 페이지에서 개인 라벨 구성

1. Settings 아이콘 클릭 → "Edit Page" 선택
2. Components 섹션에서 라벨 찾기(Standard Components 아래)
3. Lightning Record Page의 원하는 위치에 컴포넌트 배치
4. "Save" 후 페이지 "Activate"

## 이점

- **향상된 정리:** 데이터를 잘 정리하는 개인화된 솔루션으로 핵심 정보를 쉽게 찾고 관리.
- **향상된 생산성:** 관련 라벨로 태그하여 필요한 데이터를 빠르게 필터링·접근, 검색 시간 절약.
- **커스터마이징:** 사용자가 라벨을 정의하여 워크플로우와 우선순위에 맞춤.
- **사용 편의성:** 개인 라벨 생성·관리가 간단.

## 제한 사항

- 각 사용자는 오브젝트당 최대 20개, 총 200개 라벨 생성 가능.
- 각 라벨은 최대 500개 레코드에 적용 가능.
- 개인 라벨은 to-do 목록 항목에 사용되는 라벨과 다름.
- 라벨은 조직의 데이터 저장 한도에 영향을 주지 않음.

## 결론

Salesforce 개인 라벨은 데이터 정리, 생산성, 개인화를 개선하는 단순하면서도 효과적인 방법입니다. 레코드에 커스텀 태그를 만들 수 있어 워크플로우가 간소화되고 정보 접근이 쉬워집니다.
