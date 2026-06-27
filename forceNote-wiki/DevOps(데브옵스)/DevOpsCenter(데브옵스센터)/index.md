---
tags: [index, devops, devops-center, object-reference, data-model]
created: 2026-06-27
---

# DevOps Center(데브옵스 센터) — 로컬 인덱스

> Salesforce DevOps Center 매니지드 패키지의 커스텀 객체 데이터 모델 — Project 최상위 계층, Work Item·프로모션, Heroku 기반 비동기 작업, 사용자 변경 추적, 플랫폼 이벤트 전수 레퍼런스 (DevOps Center Developer Guide v67.0)

**상위:** [[DevOps(데브옵스)/index]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[DevOps Center 데이터 모델 개요]] | DevOps Center 객체 모델 개념 — Project 최상위·Heroku 비동기 작업·사용자 변경 추적·프로모션(unbundled/bundled) 동작 | #overview |
| [[DevOps Center 객체 — 파이프라인·프로젝트·환경]] | Project·Pipeline·Pipeline Stage·Environment·Repository·VCS·Branch 7객체 필드 전수(55필드) | #reference |
| [[DevOps Center 객체 — Work Item·프로모션]] | Work Item·Work Item Promote·Change Submission·Change Bundle·Change Bundle Install·Deploy Component·Submit Component 7객체(60필드) | #reference |
| [[DevOps Center 객체 — 비동기·결과]] | Async Operation Result·Deployment Result·Merge Result·Back Sync·VCS Synch State 5객체(41필드) | #reference |
| [[DevOps Center 객체 — 변경 추적]] | Remote Change·Hidden Remote Change·Source Member Reference·Object Activity 4객체(30필드) | #reference |
| [[DevOps Center — User 필드·플랫폼 이벤트]] | User GitHub_Primary_Email 커스텀 필드 + 플랫폼 이벤트 5종(Deployment·Work Item Commit·Merged/Open Change Request·State Change) | #reference |

---

## 빠른 선택

- DevOps Center 객체 모델이 전체적으로 어떻게 생겼나? Project가 최상위인 이유? → [[DevOps Center 데이터 모델 개요]]
- 비동기 작업이 Heroku에서 어떻게 처리되나? → [[DevOps Center 데이터 모델 개요]] → 비동기 동작
- unbundled vs bundled 프로모션 차이? → [[DevOps Center 데이터 모델 개요]] → 프로모션
- Project·Pipeline·Pipeline Stage·Environment 객체 필드? → [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- Repository·VCS·Branch 객체 필드와 관계? → [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- Work Item·Work Item Promote 객체 필드? → [[DevOps Center 객체 — Work Item·프로모션]]
- Change Submission·Change Bundle·Change Bundle Install 객체? → [[DevOps Center 객체 — Work Item·프로모션]]
- Deploy Component·Submit Component 객체? → [[DevOps Center 객체 — Work Item·프로모션]]
- Async Operation Result·Deployment Result·Merge Result 객체? → [[DevOps Center 객체 — 비동기·결과]]
- Back Sync·VCS Synch State 객체 필드? → [[DevOps Center 객체 — 비동기·결과]]
- DevOps Center가 환경 변경을 어떻게 추적하나? Remote Change·Source Member Reference? → [[DevOps Center 객체 — 변경 추적]]
- Hidden Remote Change·Object Activity 객체? → [[DevOps Center 객체 — 변경 추적]]
- User 객체에 추가되는 GitHub Primary Email 커스텀 필드? → [[DevOps Center — User 필드·플랫폼 이벤트]]
- DevOps Center 플랫폼 이벤트 5종(Deployment·Work Item Commit·Change Request·State Change)? → [[DevOps Center — User 필드·플랫폼 이벤트]]

---

## 관련 폴더

- 상위 DevOps/DX 전반 → [[DevOps(데브옵스)/index]]
- Metadata API(배포·검색·타입) → [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/index]]
- Apex 배포 방법(DevOps Center 포함 5경로) → [[Apex 배포 방법]]
- DevOps Center 메타데이터 설정·Beta vs GA → [[DevOps Center]]
