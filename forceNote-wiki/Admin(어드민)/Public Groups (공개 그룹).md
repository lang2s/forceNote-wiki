---
tags: [admin, user-management, public-groups, sharing, groups]
source: help.salesforce.com (Salesforce Help — Public Groups; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.creating_and_editing_groups.htm&type=5
created: 2026-07-03
aliases: [Public Groups, 공개 그룹, 공용 그룹, Group, 사용자 그룹]
---

# Public Groups (공개 그룹)

> 사용자·역할·역할과 부하·다른 그룹을 묶은 재사용 가능한 집합. 공유 규칙·폴더/리스트뷰 공유·수동 공유 등에서 "대상"으로 쓴다.

---

## 정의

Public group은 다음을 조합한 **재사용 가능한 집합**이다.

- **Users** — 개별 사용자
- **Roles** — 특정 역할에 속한 사용자
- **Roles and Subordinates** — 특정 역할과 그 계층 **하위(부하) 역할**까지 포함
- **다른 Public Group** — 그룹을 다른 그룹의 멤버로 **중첩(nesting)** 가능

개별 사용자를 매번 일일이 지정하는 대신, 자주 함께 다루는 대상을 그룹으로 한 번 정의해 두고 여러 곳에서 재사용한다.

## 용도 — 공유 대상(target)

Public group은 접근을 부여하는 여러 기능에서 **"누구에게 공유할지"의 대상**으로 쓰인다.

- **Sharing Rule** — 그룹과 레코드를 공유(share with group)
- **Folder 공유** — 리스트뷰·리포트·대시보드 폴더를 그룹과 공유
- **Manual Sharing (수동 공유)** — 개별 레코드를 그룹에 수동 공유

> 공유 규칙이 조직 전체 공유 기본값(OWD)을 어떻게 확장/보완하는지는 [[조직 전체 공유 기본값(OWD)과 공유 규칙]] 참조.

## 설정 위치

```
// 구조 예시 — 설정 경로(실제 화면 아님)
Setup → Quick Find "Public Groups" → Public Groups → New
```

멤버 유형·중첩 규칙 등 세부 설정은 공식 문서에 위임한다.

## 구성 (구조)

```
// 구조 예시 — Public Group(실제 원본 다이어그램 아님)
Public Group "West Sales"
  ├─ Users (개별)
  ├─ Roles / Roles and Subordinates
  └─ 다른 Public Group (중첩)
사용처: Sharing Rule 대상 · Folder/List View 공유 · Manual Sharing
```

## 관련 노트
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]] — 공유 규칙의 공유 대상으로 public group 사용
- [[Roles & Role Hierarchy (역할·역할 계층)]] — 그룹 멤버로 role/부하 포함
