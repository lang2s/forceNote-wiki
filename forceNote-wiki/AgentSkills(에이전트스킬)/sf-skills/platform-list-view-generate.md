---
tags: [agent-skill, sf-skills, platform, list-view, metadata]
source: forcedotcom/sf-skills (skills/platform-list-view-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-list-view-generate, 리스트 뷰 생성, List View metadata, ListView XML, filterScope, booleanFilterLogic, 필터 레코드 목록]
---

# platform-list-view-generate — Salesforce List View 메타데이터 생성

> 오브젝트 탭의 필터·컬럼 기반 레코드 목록(List View) 메타데이터를 생성·검증. ListView XML 작성·visibility·배포 트러블슈팅.

---

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER when:** 사용자가 list view 생성·생성·검증, 필터된 레코드 목록, 레코드 컬럼 설정, 기준별 레코드 필터링, list view visibility를 언급하거나 ListView XML 파일을 다루며 검증/트러블슈팅이 필요할 때. "...를 보여주는 view 필요", "...로 레코드 필터", "...용 list view 생성" 같은 표현 포함.

### 이 스킬을 쓸 때
- 오브젝트용 list view 생성
- 필터·컬럼 기반 레코드 목록 생성
- list view visibility·sharing 구성
- List View 관련 배포 오류 트러블슈팅

### 개요
List View는 오브젝트 탭에 표시되는 필터·컬럼 기반 레코드 목록을 정의한다. role·task별 curated 레코드 subset을 제공하고, 팀 간 공통 필터·표시 필드를 표준화한다.

---

## 워크플로 / 단계

### 저장 위치
별도 inline 요청이 없는 한:
```text
force-app/main/default/objects/<ObjectName>/listViews/<fullName>.listView-meta.xml
```
사용자가 요청할 때만 오브젝트 메타데이터 파일에 inline 포함:
```text
force-app/main/default/objects/<ObjectName>/<ObjectName>.object-meta.xml
```

### 핵심 요소
- `label` — UI 표시명 (40자 미만)
- `fullName` — 메타데이터·파일명에 쓰는 API 식별자
- `filterScope` — `Everything` | `Mine` | `Queue`
- `filters` — field/operation/value triple
- `booleanFilterLogic` — 다중 필터 논리 결합 (예: `"1 AND (2 OR 3)"`)
- `columns` — 표시할 field API명 순서 목록

> listView는 entity 탭에 나타나며, flexipage에서 `filterListCard` 컴포넌트로 참조 가능.

### Generation Workflow
1. **메타데이터 정보 수집** — 대상 오브젝트 API명, 비즈니스 요구(목적·audience·필드·필터), 값·연산자-필드타입 호환성 검증.
2. **기존 예시 검토** — 레포 `listViews/` 디렉토리 + org의 기존 list view로 검증된 패턴(필터·로직·컬럼) 확인.
3. **명세 작성** — Name(fullName+Label), Audience(visibility), Filter scope, Filter items(+booleanFilterLogic), Columns, Acceptance criteria.
4. **메타데이터 파일 작성** — Lightning 호환 템플릿, 유효 XML.
5. **로컬 검증** — well-formed XML·네임스페이스, 필드 존재·연산자·값 타입 일치, path/fullName 정렬, 다중 필터 시 booleanFilterLogic.
6. **배포·org 검증** — 컴포넌트 경로/오브젝트 배포 후 UI에서 레코드·컬럼·visibility 확인.

### 메타데이터 파일 템플릿 (verbatim — SKILL.md Step 4)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ListView xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>OpenMine</fullName>
    <label>Open - My Records</label>
    <filterScope>Mine</filterScope>
    <columns>NAME</columns>
    <columns>Status__c</columns>
    <columns>OWNER.ALIAS</columns>
    <columns>LAST_UPDATE</columns>
    <filters>
        <field>Status__c</field>
        <operation>equals</operation>
        <value>Open</value>
    </filters>
    <sharedTo>
        <role>CEO</role>
        <roleAndSubordinatesInternal>COO</roleAndSubordinatesInternal>
    </sharedTo>
</ListView>
```
- "My" view는 `filterScope="Mine"`.
- 컬럼은 tight·purposeful하게.
- 모든 사용자 대상이면 `sharedTo` 섹션 생략.

---

## 핵심 규칙·가드레일

### Critical Decision: Visibility Strategy
- **Visible to all users:** profile/role 전반 유용 · source control로 관리할 governed 공유 artifact · 데이터가 broad visibility에 적절.
- **Owner-only/Restricted:** 실험적/niche iteration 중 · User/Group/Role로 제한 요청 · governance/security review 대기.
- **애매하면:** "Visible to all users" 기본.

### Critical Decision: Columns Density
- **minimal·high-signal:** at-a-glance 스캔 · 모바일/반응형 성능 중요.
- **richer set:** 데스크톱 heavy 워크플로 · work queue로 클릭 절감.
- **애매하면:** primary task를 직접 지원하는 4–6 컬럼으로 시작.

### Critical Rules (먼저 읽기)
- **Rule 1 — 커스텀 필드 API명:** label 아닌 정확한 API명 (`Status__c`, not `Status`).
- **Rule 2 — 표준 필드명:** Custom Object의 standard 필드는 정의된 이름 사용 — `NAME`(not `Name`). 목록: `NAME`, `RECORDTYPE`, `OWNER.ALIAS`, `OWNER.FIRST_NAME`, `OWNER.LAST_NAME`, `CREATEDBY_USER.ALIAS`, `CREATEDBY_USER`, `CREATED_DATE`, `UPDATEDBY_USER.ALIAS`, `UPDATEDBY_USER`, `LAST_UPDATE`, `LAST_ACTIVITY`.
- **Rule 3 — 연산자는 필드 타입과 일치:** picklist는 equals/notEqual; date 필드는 date 연산자; boolean 값은 `0`/`1`; text-only 연산자를 non-text 필드에 혼용 금지. (❌ picklist에 `contains`, boolean에 `value=True` / ✅ `equals`+유효 picklist 값, boolean `value=1`)
- **Rule 4 — Name과 Path 정렬:** 파일명·fullName(=DeveloperName)·uniqueness 정렬. (❌ 파일 `My_List`, fullName `MyList` / ✅ 파일 `MyList`, fullName `MyList`)
- **Rule 5 — Folder Placement:** 오브젝트의 listViews 디렉토리에 배치하지 않으면 배포가 컴포넌트 resolve 실패.

### Common Deployment Errors
| Error | 원인 | Fix |
|---|---|---|
| "Invalid field Status" | label 사용, 또는 standard 필드에 API명 사용 | `Status__c`(올바른 API명) 또는 `NAME` 사용 |
| "Invalid filter operator" | 필드 타입에 맞지 않는 연산자 | 호환 연산자 선택(예: picklist엔 equals) |
| "Component not found at path" | 잘못된 폴더/파일명 | `objects/<Object>/listViews`에 배치, 파일명-fullName 정렬 |
| "Malformed booleanFilterLogic" | 구문/인덱스 불일치 | `"1 AND 2"` 스타일, filters 인덱스 순서 일치 |

### Verification Checklist
- [ ] 필수 필드(fullName/label/filterScope/columns) 채워짐
- [ ] 속성값 필요 시 XML-encode
- [ ] 커스텀 필드는 API명, standard 필드는 정의된 이름
- [ ] 연산자가 필드 타입과 일치, picklist 값 유효
- [ ] booleanFilterLogic이 filters 순서·개수와 일치
- [ ] 파일 경로와 fullName/developerName 정렬
- [ ] deprecated/Classic-only 속성 없음
- [ ] 배포 성공·의도대로 visible
- [ ] 레코드·컬럼·필터링 명세대로 동작

---

## 번들 파일

`SKILL.md` 단일 파일 스킬 (별도 references·assets·scripts 없음).

---

## 관련 노트
- [[platform-lightning-app-coordinate]]
- [[platform-soql-query]]
