---
tags: [agent-skill, sf-skills, platform, metadata, validation-rule, data-quality]
source: forcedotcom/sf-skills (skills/platform-validation-rule-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-validation-rule-generate, 검증 규칙 생성, ValidationRule, errorConditionFormula, CDATA, 데이터 품질]
---

# platform-validation-rule-generate — 검증 규칙 메타데이터 생성

> 데이터 품질·비즈니스 로직을 데이터 레이어에서 강제하는 Salesforce Validation Rule 메타데이터를 생성·수정·검증한다.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** validation rule, field validation, data quality rule, formula validation, error message, validation logic. validation 오류 발생, formula 갱신, 데이터 레이어 비즈니스 규칙 강제.

이 스킬이 다루는 작업: 데이터 품질 강제 validation rule 생성 · invalid 레코드 저장 방지 · formula 포함 validation metadata 생성 · 객체에 비즈니스 로직 검증 추가 · validation rule 배포 오류 트러블슈팅.

**개념:** Validation Rule은 레코드 저장 시 formula를 평가하는 declarative 메타데이터다. formula가 TRUE를 반환하면 저장을 막는다.

## 워크플로 / 단계

### Required Properties

- **fullName** — validation rule의 고유 API name
  - letter로 시작 · letter/숫자/underscore 포함 가능 · underscore로 끝나지 않음 · 연속 underscore 금지 · 40자 초과 금지
- **active** — 활성화 여부. `true`=강제, `false`=비활성
- **errorConditionFormula** — 레코드 데이터를 평가하는 논리 formula. TRUE/FALSE 반환. TRUE면 오류 트리거
- **errorMessage** — 검증 실패 시 표시 메시지. 최대 255자

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ValidationRule xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>Require_Start_Date</fullName>
    <active>true</active>
    <errorConditionFormula><![CDATA[ISBLANK(Start_Date__c)]]></errorConditionFormula>
    <errorMessage>Start Date is required.</errorMessage>
</ValidationRule>
```
> 위 XML은 SKILL.md의 속성 정의를 바탕으로 구성한 예시 구조다 — `// 구조 예시 — 실제 동작 코드 아님`.

### Specific Function Guidelines
- **TEXT** — Text field에 `TEXT()` 사용 금지. fix: `TEXT()` 제거
- **CASE** — 마지막 파라미터가 default value. admin이 자주 누락하며 파라미터 수는 항상 짝수
- **VALUE** — Text field에만 사용. 숫자가 파라미터면 `VALUE()` 제거
- **DAY** — Date field에만. Datetime이 파라미터면 Date로 먼저 변환
- **MONTH** — Date field에만. Datetime이 파라미터면 Date로 먼저 변환
- **DATEVALUE** — DateTime field에만. Date가 파라미터면 `DATEVALUE()` 제거
- **ISPICKVAL** — picklist 타입 field 동등 검사 시 `ISPICKVAL()` 필수
- **ISCHANGE** — 레코드 값 변경 확인은 `ISCHANGE()` 사용

## 핵심 규칙·가드레일

### Critical Rules
1. **Formula XML Handling (MOST COMMON ERROR)** — XML 태그를 포함하는 어떤 errorConditionFormula든 메타데이터 XML 내 CDATA 섹션 안에 있어야 함.
2. **"Update" 지시 해석** — formula 수정 지시 시 replacement vs addition 구분:
   - "Update the formula to [Action]": 기존 formula 로직을 새 요구로 완전 교체
   - "Update the formula to also [Action]": 기존 로직 유지하고 새 요구 추가(보통 `AND()`/`OR()`로 래핑)
3. **File Format** — validation rule 파일은 항상 `.validationRule-meta.xml` 확장자.

> validation rule을 custom object XML 내부(`<validationRules>`)에 둘 때의 네이밍(예: `__c` suffix 금지)은 [[platform-custom-object-generate]] 참조.

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-object-generate]]
- [[platform-custom-field-generate]]
- [[platform-metadata-api-context-get]]
