---
tags: [index, devops, salesforce-dx, scratch-org]
created: 2026-07-18
---

# DX(DX개발환경) — 로컬 인덱스

> Salesforce DX 코어 — sf CLI·Scratch Org·Sandbox·Source Tracking·DX 인증·프로젝트 구조·개발 워크플로·MCP·트러블슈팅

**상위:** [[DevOps(데브옵스)/index]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce DX 개요]] | sfdx-project.json, sf CLI 기본 명령, Source Format, .forceignore, JWT 인증 | #overview |
| [[개발 환경 선택 (Scratch Org vs Sandbox vs Developer Edition)]] | 3개 개발 환경(Scratch Org·Sandbox·Developer Edition)을 결정 축별로 비교해 상황에 맞는 org 선택 | #decision |
| [[sf CLI 명령 카탈로그 · sfdx→sf 매핑]] | DevOps 워크플로 노트의 sf(v2) 명령 주제별 색인 + 레거시 sfdx(v1)→sf(v2) 마이그레이션 매핑 | #reference |
| [[Scratch Org 패턴]] | Scratch Org 생성·관리, project-scratch-def.json, Org Shape, Snapshot | #pattern |
| [[DX 프로젝트 구조와 소스 포맷]] | DX 프로젝트 생성·디렉토리 구조·소스 포맷·정적 리소스·기존 소스 마이그레이션 전수 | #reference |
| [[메타데이터 분해와 forceignore]] | Decomposed Metadata Types 전수(기본+선택 Beta), .forceignore 문법·예제 전수 | #reference |
| [[sfdx-project.json 레퍼런스]] | 모든 필드·기본값, Multiple Package Dirs, String Replacement 전수 | #reference |
| [[DX 인증 방식]] | org login web·JWT Flow·External Client App·Connected App·SFDX Auth URL·Logout 전수 | #reference |
| [[Scratch Org 생성과 정의 파일]] | Scratch Org 개념·Editions/Allocations·생성 명령 전수·Definition File 옵션 전수·Features 전수 목록 | #reference |
| [[Scratch Org Settings 레퍼런스]] | settings 블록 전수 옵션·주요 Settings 예시·Features와 Settings 조합 패턴 | #reference |
| [[Org Shape와 Snapshot]] | Org Shape 생성·권한·Troubleshoot 전수, Snapshot 생성·관리·릴리즈 버전 결정 전수 | #reference |
| [[Scratch Org 배포·유저·에러코드]] | project deploy/retrieve start 전수, org create user·User Definition File·비밀번호 관리, Error Codes 전수표 | #reference |
| [[Source Tracking 변경 추적]] | Org 에디션별 지원·Manage Tracking·Preview·Deploy/Retrieve·Profile 추적 동작·Conflicts 해결·Best Practices·Performance 전수 | #reference |
| [[DX 개발 워크플로]] | Develop Against Any Org·sf apex generate class/trigger·sf lightning generate component·sf schema generate·Anonymous Apex·Run Tests·Debug Logs 전수 | #reference |
| [[DX 도구 접근 권한]] | Dev Hub 선택·활성화·추가 기능·라이선스·사용자 추가·Permission Set 권한 전수 | #reference |
| [[Sandbox 관리]] | org create/clone/refresh/delete sandbox, sandbox-def.json 전체 옵션 전수 | #reference |
| [[DX 데이터 작업]] | data export/import tree, Bulk API 2.0 전수, record CRUD, SOQL/SOSL CLI, 파일 업로드 | #reference |
| [[DX 도구 개요와 워크플로 전환]] | DX가 개발 방식을 바꾸는 이유·샘플 레포 시작·신규 프로젝트·마이그레이션 3가지 시작 경로 전수 | #reference |
| [[DX MCP Server (Beta)]] | VS Code+Copilot Quick Start·60+ MCP 도구·toolset 14개·Core Tools 12개 전수 | #reference |
| [[DX 트러블슈팅]] | org login web/jwt 오류 전수(12가지)·No default dev hub·포트 점유·consumer key 중복 해결 | #reference |
| [[DX 제약사항]] | CLI·Dev Hub·Source Management·배포·1GP/2GP·Unlocked Package 알려진 제약 13건 전수 | #reference |
