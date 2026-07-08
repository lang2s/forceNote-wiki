# 문서 인덱스 — 팀멤버 관련 목록 / NCNS Custom Related List

> 이 폴더의 문서는 **Diátaxis 프레임워크**로 구성되어 있습니다 — 문서마다 목적이 하나씩이며, 서로 다른 질문에 답합니다.
> 작성일: 2026-07-08

---

## Diátaxis 사분면과 문서 배치

| | **작업 중심** (일하면서 본다) | **지식 중심** (이해하려고 본다) |
|---|---|---|
| **배우기 / 이해하기** | *(튜토리얼 — 현재 없음. 처음이라면 하우투 가이드의 경로 A를 그대로 따라 하는 것을 권장)* | [동작 원리와 설계 배경 (설명)](ncns-customrelatedlist-explanation.md) |
| **문제 해결 / 조회** | [다른 오브젝트에 팀멤버 구축 가이드 (하우투)](teammember-other-object-setup-guide.md) | 레퍼런스 4종 (아래) |

## 문서별 안내

### 🛠 하우투 가이드 — "~하려면 어떻게?"

| 문서 | 답하는 질문 |
|------|-------------|
| [teammember-other-object-setup-guide](teammember-other-object-setup-guide.md) | Lead 외 다른 오브젝트에 팀멤버 기능을 처음부터 구축하려면? (개체 → 트리거/CMDT → 페이지 → Apex → LWC → 배포) |

### 📖 레퍼런스 — "정확한 값/목록/계약은?"

| 문서 | 내용 |
|------|------|
| [ncns-lead-teammember-setup-guide](ncns-lead-teammember-setup-guide.md) | 신규 LWC 카드의 속성 25종과 Lead 팀멤버 설정값, buttonComponent 매핑표, 배치 절차 |
| [ncnsCustomRelatedList-deployment-list](ncnsCustomRelatedList-deployment-list.md) | 신규 LWC 14개 배포 목록 + 의존 Apex/LWC/라벨 + 배포 명령 |
| [cnsCustomRelatedList-aura-deployment-list](cnsCustomRelatedList-aura-deployment-list.md) | 기존 Aura 생태계(28개 번들) 배포 목록 |
| [lead-teammember-relatedlist-deployment-list](lead-teammember-relatedlist-deployment-list.md) | Lead 팀멤버 기능 단위 배포 목록 (개체/트리거/CMDT/배치잡 포함, 기존 구성만) |

### 🧩 설계/계획 — "무엇을 어떻게 바꿀 것인가?"

| 문서 | 내용 |
|------|------|
| [NCNS_Interface_Framework_Handover](NCNS_Interface_Framework_Handover.md) (+ `.html` 오프라인) | **NCNS 신형 인터페이스 프레임워크 핸드오버 + 사용자 가이드** — 구조·구성요소·설정·회복탄력성·아웃바운드/인바운드 작성법·FAQ. **신규 인터페이스는 이 프레임워크(NCNS_Interface__c 계열)로 작성** |
| [ncns-callout-logging-guide](ncns-callout-logging-guide.md) | NCNS 콜아웃 인터페이스 서브클래스 작성 + 로그(`LogMode__c`/`appendLog`) 사용법 하우투 |
| [cmp-interface-replatform-plan](cmp-interface-replatform-plan.md) | (설계 이력) CMP 재플랫폼 설계·결정 기록 — 회복탄력성 패턴 도입. **NCNS 프레임워크는 이 CMP 재플랫폼에서 fork됨**(§11) |

### 💡 설명 — "왜 이렇게 만들어졌나? 어떻게 동작하나?"

| 문서 | 내용 |
|------|------|
| [ncns-customrelatedlist-explanation](ncns-customrelatedlist-explanation.md) | 카드·모달·트리거의 동작 흐름, 자동 갱신 3경로, 트리거 프레임워크 배경, Aura 대비 의도적 차이/유지된 특이점 |
| [CNS_CustomRelatedList.html](CNS_CustomRelatedList.html) | 기존 Aura 생태계 기술 상세 (HTML 전용) |

### 📊 발표 자료

| 파일 | 내용 |
|------|------|
| `teammember-docs-overview.pptx` | 신규 LWC 기준 — 문서 세트/기능 개요 발표 자료 (공유·보고용) |
| `aura-teammember-other-object-setup-guide.pptx` | 구버전(Aura) 기준 — 팀멤버 설정을 다른 오브젝트에 적용하는 단계별 가이드 발표 자료 |

### 📝 작업 기록

| 문서 | 내용 |
|------|------|
| [WORKLOG](WORKLOG.md) | 이 프로젝트에서 수행한 작업 이력 (최신순) — 새 작업 완료 시 항목 추가 (CLAUDE.md Work Log Policy) |

## 상황별 읽기 순서

- **다른 오브젝트에 팀멤버를 만들어야 한다** → 하우투 가이드 하나로 완결 (필요 시 설정값은 레퍼런스 참조)
- **신규 LWC를 다른 org에 배포해야 한다** → ncnsCustomRelatedList-deployment-list → 배포 후 ncns-lead-teammember-setup-guide로 페이지 설정
- **왜 이런 구조인지 팀에 설명해야 한다** → 설명 문서 + PPT
- **기존(Aura) 구성을 파악해야 한다** → aura 배포 목록 + lead-teammember 배포 목록 + CNS_CustomRelatedList.html
