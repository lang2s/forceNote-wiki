---
tags: [index, devops, deploy, ci-cd]
created: 2026-07-18
---

# Deploy(배포·CICD) — 로컬 인덱스

> 배포·CI/CD — 배포/패키징 유형 결정 가이드·Change Sets·Metadata API/Tooling API 배포·Apex 배포·CI 파이프라인·Metadata Coverage·ExperienceBundle

**상위:** [[DevOps(데브옵스)/index]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[배포 방법 결정 가이드]] | 6가지 배포 경로(Change Sets·Metadata API·DX·Unlocked Package·Tooling API·DevOps Center)를 결정 축으로 비교·선택 (validation/quick deploy·UI vs CLI·CI) | #decision |
| [[패키징 유형 결정 가이드 (Unlocked·2GP·1GP·Unmanaged)]] | 4개 패키지 모델(Unlocked·2GP·1GP·Unmanaged)을 배포 대상·잠금·IP 보호·의존성 축으로 비교·선택 | #decision |
| [[CI CD 패턴]] | Jenkins Jenkinsfile, CircleCI, JWT 인증 자동화, 패키지 빌드 파이프라인 | #pattern |
| [[Metadata API 빌드·릴리스 워크플로]] | Org Development Model 4단계·배포 검증·빠른 배포·취소 전수 | #reference |
| [[Apex 배포 방법]] | Apex 배포 5가지 경로(Change Sets·VS Code/Code Builder·Metadata API·Tooling API·DevOps Center)·Compile On Deploy·org 타입별 기본값 전수 | #reference |
| [[Change Sets 배포]] | Outbound/Inbound Change Set 단계별 배포 — 컴포넌트 담기·Upload·연결된 org 사이 Deploy(sandbox→production) | #reference |
| [[Tooling API 배포]] | Tooling API 컨테이너 비동기 배포 — MetadataContainer·ContainerAsyncRequest·*Member sObject 6종·State enum 6값·개별 요소(클래스/트리거/VF) 컴파일·배포 워크플로 전수 | #reference |
| [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] | CircleCI 환경 설정·서버키 암호화·Dev Hub 연결, Jenkins Jenkinsfile 전체 코드, Travis CI, Sample CI 레포 전수 표 | #reference |
| [[Metadata Coverage 보고서]] | Metadata API·Scratch Org Source Tracking·Unlocked Package 등 채널별 메타데이터 지원 여부 공식 참조 | #reference |
| [[ExperienceBundle — Experience Builder 사이트 메타데이터]] | ExperienceBundle/DigitalExperienceBundle 폴더 구조·enable·Metadata API/DX 배포·enhanced LWR 마이그레이션·인증 LWR /s URL 배포 고려사항 | #reference |
