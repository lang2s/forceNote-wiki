---
tags: [devops, salesforce-dx, dev-hub, permission-set, license, access-control]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [DX 사용자 권한, Dev Hub 활성화, DX 라이선스, Developer License, Limited Access Free, DX Permission Set]
---

# DX 도구 접근 권한

> Dev Hub 활성화, Source Tracking 활성화, 라이선스 선택, Permission Set 구성까지 — DX 도구를 팀원에게 열어주는 전수 절차.

---

## Dev Hub 선택과 활성화

Dev Hub는 Scratch Org, Unlocked Package, Second-Generation Managed Package를 생성·관리하는 중앙 조직이다. AppExchange 배포를 목표로 하는 Unlocked Package라면 활성 Production Org를 Dev Hub로 지정해야 한다. ISV/OEM 파트너는 반드시 Partner Business Org(PBO)를 Dev Hub로 지정한다.

### 활성화 절차

```
1. System Administrator로 Production / Developer Edition / Trial Org에 로그인
2. Setup > Quick Find: "Dev Hub" 검색 → Dev Hub 선택
3. [Enable] 클릭
   ※ 한 번 활성화하면 비활성화 불가
   ※ Sandbox에서는 Dev Hub 활성화 불가
```

Dev Hub Org의 인스턴스가 Scratch Org 생성 위치를 결정한다.
- Government Cloud Dev Hub → Government Cloud 인스턴스에 Scratch Org 생성
- Hyperforce Dev Hub → Hyperforce 인스턴스에 Scratch Org 생성

### Trial / Developer Edition을 Dev Hub로 선택 시 주의사항

| 항목 | 제한 |
|---|---|
| 일일 Scratch Org 생성 수 | 최대 6개 |
| 동시 활성 Scratch Org | 최대 3개 |
| 일일 Package Version 생성 수 | 최대 6개 |
| Trial Org | 만료일에 삭제됨 |
| Developer Edition | 비활성으로 만료 가능 |
| 패키지 버전 소유 | Dev Hub Org 만료 시 접근 불가 |

### Dev Hub에서 추가 기능 활성화

**Unlocked Packaging 활성화**

```
Setup > Quick Find: "Dev Hub" → Dev Hub
→ "Enable Unlocked Packages and Second-Generation Managed Packages" 체크
※ 한 번 활성화하면 비활성화 불가
```

**Einstein Chatbot Features (Scratch Org용)**

```
Setup > Quick Find: "Dev Hub" → Dev Hub
→ "Enable Einstein Features" 켜기
※ Einstein Terms of Service를 한 번만 수락하면 모든 Scratch Org에 자동 적용
```

**Language Extension Packages (Beta)**

```
Setup > Quick Find: "Dev Hub" → Dev Hub
→ "Enable Language Extension Packages" 켜기
※ Translations · CustomObjectTranslations 포함 컴포넌트만 허용
```

---

## Sandbox에서 Source Tracking 활성화

Developer / Developer Pro Sandbox에서 Source Tracking을 활성화하면, DX 도구가 신규·변경·삭제된 메타데이터를 자동으로 추적한다.

> Source Tracking은 Partial Copy, Full 샌드박스, Developer Edition Org에서는 지원되지 않는다.

### 방법 1 — Production Org에서 모든 샌드박스에 일괄 활성화

```
1. Production(소스) Org에 로그인
2. Setup > Quick Find: "Dev Hub" → Dev Hub
3. "Enable Source Tracking in Developer and Developer Pro Sandboxes" 체크
4. 기존 샌드박스는 Refresh 후 적용됨
```

```
필요 권한:
- 샌드박스 조회: View Setup and Configuration AND Customize Applications
- 샌드박스 생성·갱신·활성화·삭제: Manage Dev Sandboxes (Developer/Developer Pro 전용)
  또는 Manage Sandboxes (전체 샌드박스 유형)
```

적용 범위:
- 새로 생성·갱신된 Developer/Developer Pro Sandbox → 자동 활성화
- 기존 샌드박스 → Refresh 필요
- 기능 비활성화 → 샌드박스 Refresh 시 Source Tracking 정보 삭제

### 방법 2 — 특정 Sandbox에서 개별 활성화

```
1. 해당 Developer / Developer Pro Sandbox에 로그인
2. Setup > Quick Find: "Sandbox Settings" → Sandbox Settings
3. [Enable Source Tracking in This Sandbox] 클릭
```

주의사항:
- 활성화 시점 이후의 메타데이터 변경만 추적됨 (소급 적용 없음)
- Sandbox Refresh 후 Source Tracking 정보 삭제 — 재활성화 필요
- Source Tracking 비활성화 후 레코드 정리에 수일 소요될 수 있음

---

## DX 사용자 추가

System Administrator는 기본으로 Dev Hub Org에 접근 가능하다. 개발자 팀원에게 DX 도구 접근 권한을 부여하는 방법은 라이선스에 따라 다르다.

### 라이선스 종류별 비교

| 라이선스 | 용도 | CRM 접근 | 특징 |
|---|---|---|---|
| **Salesforce** | 표준 CRM + AppExchange | 전체 | 최대 권한 |
| **Salesforce Platform** | 커스텀 앱 전용 | 커스텀 앱만 | CRM 기능 없음 |
| **Developer** | 빌드/개발 전용 | 제한적 | Sandbox 1개 + Scratch Org 1개 포함 |
| **Salesforce Limited Access - Free** | Dev Hub 접근 전용 | 없음 | 요청으로 부여; 표준 오브젝트 접근 불가 |

### Developer 라이선스 세부

- 커스터마이제이션/앱 개발 역할 사용자를 위한 유료 라이선스
- Dev Hub 접근 + Developer Sandbox 1개 + Scratch Org 1개 포함
- Production에서 Account 등 표준 오브젝트 접근 제한 → 커스텀 앱도 접근 불가
- Scratch Org에서는 FSC, Sales Cloud Einstein 등 기능 테스트 가능

### Salesforce Limited Access - Free 라이선스 제한

- Developer Edition Org에서 사용 불가
- Org Shape 생성·관리 불가 (Salesforce 라이선스 필요)
- `sf limits api display` 등 일부 CLI 명령 사용 불가
- `View All Records` 권한 있으면 → Org Shape 기반 Scratch Org 생성 가능
- `View All Records` 권한 있으면 → 타인의 Scratch Org Snapshot 조회 가능

라이선스 수 한도:
- Enterprise Edition → 최대 20개 요청 가능
- Unlimited Edition → 최대 50개 요청 가능

---

## 사용자 추가 절차

### System Administrator / Standard User 추가

```
1. Setup > Users > New User → 양식 작성 → System Administrator 또는 Standard User 프로필 지정 → Save
   (System Administrator라면 여기서 완료)

2. Standard User라면 Permission Set 생성 (아직 없는 경우):
   Setup > Permission Sets > New
   → Label, API Name, Description 입력
   → User License: 여러 라이선스 사용자에게 할당 예정이면 "None" 선택
   → Save

3. Permission Set을 사용자에게 할당:
   Setup > Permission Sets → 해당 Permission Set 선택
   → Manage Assignments → Add Assignments → 사용자 선택 → Assign → Done
```

### Developer 라이선스 사용자 추가

```
1. Setup > Users > New User
   → User License: Developer
   → Profile: Developer
   → Save

2. 사용자 상세 페이지 → Permission Set Assignments → Edit Assignments
   → Available Permission Sets에서 "Developer" 추가 → Save
```

Developer Permission Set은 Scratch Org·Unlocked Package·2GP에 필요한 권한을 포함한다.

### Limited Access - Free 사용자 추가

```
1. Setup > Users > New User
   → User License: Salesforce Limited Access - Free
   → Profile: Limited Access User
   → Save

2. Dev Hub 오브젝트에 접근 가능한 Permission Set 생성 및 할당
   (상세: Create and Assign a Permission Set to Developer Users 참조)
```

---

## Permission Set 구성 — 필수 권한 목록

### Scratch Org 관련 필수 권한

```
Object Settings > Scratch Org Infos > Read, Create, Edit, Delete
Object Settings > Active Scratch Orgs > Read, Edit, Delete
```

### Unlocked Packaging / 2GP 추가 필수 권한

Scratch Org 권한에 더해:

```
Object Settings > Namespace Registries > Read
System Permissions > Create and Update Second-Generation Packages
```

`Create and Update Second-Generation Packages` 시스템 권한이 제공하는 CLI 명령 접근:

| Salesforce CLI 명령 | Tooling API 오브젝트 (Create/Edit) |
|---|---|
| `sf package create` | `Package2` |
| `sf package version create` | `Package2VersionCreateRequest` |
| `sf package version update` | `Package2Version` |

### Standard Developer Permission Set

Developer 라이선스에는 내장 Developer Permission Set이 포함되어 있다. 이 Permission Set은 Scratch Org·Unlocked Package·2GP에 필요한 모든 권한을 포함한다. 직접 생성하거나 제공된 Permission Set을 사용할 수 있다.

---

## 관련 노트

- [[Salesforce DX 개요]] — DX 전체 개요
- [[Scratch Org 생성과 정의 파일]] — Dev Hub 활성화 후 Scratch Org 생성
- [[Unlocked Package 개념과 준비]] — Unlocked Package 활성화 필요
- [[DX 인증 방식]] — Permission Set 부여 후 인증 설정
- [[Source Tracking 변경 추적]] — 샌드박스 Source Tracking 활성화 후 사용
- [[DX 트러블슈팅]] — Dev Hub 관련 오류 해결 (No default dev hub found 등)
- [[DX 도구 개요와 워크플로 전환]] — Dev Hub 활성화 후 전체 DX 워크플로
