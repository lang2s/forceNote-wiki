---
tags: [admin, release-updates, setup, maintenance, salesforce]
source: help.salesforce.com — Manage Release Updates (xcloud.release_updates_manage.htm) + Release Updates (release-notes.rn_ru.htm), Tier 2, 확인 2026-07-12
created: 2026-07-12
aliases: [Release Updates 처리, 릴리스 업데이트 관리, Manage Release Updates, Test Run, 테스트 실행, Complete Steps By, Get Started, Critical Updates 대체, 릴리스 업데이트 강제 적용, Release Update lifecycle]
---

# Release Updates 처리 (테스트 실행 · 기한 활성화)

> Salesforce가 org를 개선하지만 **기존 커스터마이제이션에 영향을 줄 수 있는 변경**을 어드민이 **Setup → Release Updates** 페이지에서 어떻게 처리하는지 — Test Run으로 미리 검증하고, **Complete Steps By(기한)** 전에 단계를 완료하며, 기한이 지나면 Salesforce가 강제 적용하는 라이프사이클을 다룬다. (버전별 "무엇이 강제되나" 콘텐츠는 [[Release MOC]] 산하 릴리스 노트에 위임)

---

## Release Update란 — 개념

> 공식 원문 (rn_ru.htm): *"Salesforce periodically provides release updates that improve the performance, logic, security, and usability of our products. The Release Updates page provides a list of updates that can be necessary for your organization to enable. Some release updates affect existing customizations."*

- Release Update = Salesforce가 제품의 **성능·로직·보안·사용성**을 개선하는 변경. 일부는 **기존 커스터마이제이션에 영향**을 주므로 어드민이 사전에 검토·적용해야 한다.
- **Critical Updates(레거시)를 대체한다.** 공식 원문 (Manage Release Updates): *"Release updates replace the Critical Updates console and include more detailed information about upcoming changes."* 이전의 Critical Updates 콘솔보다 예정 변경에 대한 상세 정보를 더 제공한다.
- 모든 Release Update는 생성될 때 **향후 어느 릴리스에 강제(enforced)될지** 스케줄이 잡힌다. 공식 원문: *"Every time a release update is created, it gets scheduled to be enforced in a future release. We announce each update and its schedule here as soon as that schedule is known, but occasionally, updates are postponed or canceled."* → 일정이 정해지면 릴리스 노트에 공지하되 **간혹 연기(postponed)·취소(canceled)**될 수 있고, 그 경우 해당 update 설명에 고지된다.

### 필요 권한 · 사용 가능 에디션 (공식)

| 항목 | 값 |
|---|---|
| Release Updates **조회** | `View Setup and Configuration` |
| Release Updates **활성화/비활성화** | `Manage Release Updates` **또는** `Customize Application` |
| 사용 가능 | Salesforce Classic(일부 org 제외) + Lightning Experience / **모든 에디션** |

---

## 처리 절차 (Manage Release Updates — 공식 단계)

> 접근 경로: **Setup → Quick Find 박스에 `Release Updates` 입력 → Release Updates 선택.**

```
// 구조 예시 — 실제 화면 흐름 요약 (원본 UI 다이어그램 아님)
Setup ▸ Quick Find "Release Updates" ▸ Release Updates
        │
        ▼
  [Release Updates 페이지] — org에 영향을 주는 업데이트 목록
        │  update 선택
        ▼
  View Details ── 확장 섹션에서 변경 내용·기대 개선점·org 영향 확인
        │
        ▼
  Get Started ── 이 페이지에서:
        ├─ Enable Test Run  (제공되는 경우) — 미리 켜서 영향 검증
        │      └─ 문제 발견 시 Disable Test Run — Complete Steps By 전까지 반복 토글 가능
        ├─ 구체적 단계(step) 검토·수행
        ▼
  Done ── 단계 완료 후 클릭
        ▼
  검토·완료 확인(Confirm)
```

공식 절차 (원문 요지):

1. **From Setup, in the Quick Find box, enter `Release Updates`, and then select Release Updates.**
2. **On the Release Updates page, select an update.**
3. **View Details** — 홈 페이지를 벗어나지 않고 빠른 정보를 얻는다. 확장 섹션(expandable sections)에서 *changes, improvements you can expect, impact on your org*를 본다.
4. **Get Started** — 업데이트에 대해 조치한다. 이 페이지에서 (제공되는 경우) **test run을 활성화**하고, 수행할 **구체적 단계(steps)**를 검토한다.
5. **Disable Test Run** — 테스트 중 업데이트를 꺼야 한다면 클릭. *"You can enable or disable test runs as often as needed until the Complete Steps By date on your update."* — **Complete Steps By 날짜 전까지 필요한 만큼 반복**해서 켜고 끌 수 있다.
6. **Done** — 단계를 마친 뒤 클릭.
7. **검토·완료 확인** — 업데이트 단계를 검토·완료했음을 확인한다.

---

## Test Run — 미리 적용해 영향 확인

> 공식 원문 (rn_ru.htm): *"Often, release updates provide a Test Run option so you can enable an update and examine any changes to your org, including changes to customizations, before that update's Complete Steps By date."*
>
> 공식 원문 (Manage Release Updates): *"Use the test run option to activate or deactivate an update before the Complete Steps By date so that you can evaluate its impact on your org."*

- **대부분의**(many / often) Release Update가 **Test Run** 옵션을 제공한다 — 강제(enforced) 전에 update를 켜서 org(커스터마이제이션 포함)에 미치는 변화를 **미리** 확인.
- **Test Run은 토글**이다: `Enable Test Run` ↔ `Disable Test Run`을 **Complete Steps By 날짜 전까지 필요한 만큼 반복**할 수 있다.
- **⚠️ 샌드박스 주의**: *"On sandbox orgs, the test run periods can end earlier than the Complete Steps By date."* — 샌드박스에서는 test run 기간이 Complete Steps By 날짜보다 **더 일찍 끝날 수 있다.**
- **어디서 테스트하나 (공식 WARNING)**: *"Salesforce recommends testing each update by activating it in either your developer sandbox or your production environment during off-peak hours."* — **개발자 샌드박스** 또는 **프로덕션의 off-peak(비혼잡) 시간대**에서 활성화해 테스트할 것을 권장.
- Test Run을 지원하지 않는 update는, 해당 update에 대해 Salesforce가 제공하는 개별 테스트 지침을 따른다.

---

## 기한(Complete Steps By)과 자동 강제(Enforced)

- 각 update에는 **`Complete Steps By` 날짜**가 있다 — 이 날짜 전에 어드민이 단계를 완료해 org를 준비시켜야 한다.
- **기한이 지나면 Salesforce가 해당 릴리스에서 자동으로 강제 적용(enforced)한다.** Release Update는 생성 시점에 이미 "향후 어느 릴리스에 enforced"라는 스케줄이 잡혀 있으므로, 어드민이 손대지 않아도 해당 릴리스가 오면 강제된다. → 그래서 Test Run으로 **강제 전에** 영향을 확인하는 것이 핵심이다.
- 릴리스 노트에서는 강제 시점별로 그룹핑된다. 예: **"Enforced with This Release"** 섹션 — 공식 원문: *"These updates are scheduled to be enforced this release."* (이후 릴리스 강제 예정 항목, 연기된 항목도 각각 별도 그룹으로 표기)
- 강제(enforcement)는 **연기(postponed)되거나 취소(canceled)**될 수 있으며, 그 경우 해당 update 설명에 고지된다.

### 라이프사이클 요약

```
// 구조 예시 — 라이프사이클 개요 (원본 다이어그램 아님)
발표(Announce)           → 릴리스 노트 + Release Updates 페이지에 등장, enforced 릴리스 스케줄 공지
   │
테스트(Test Run)         → Complete Steps By 전, 샌드박스/프로덕션(off-peak)에서 Enable/Disable 반복
   │
적용(Get Started ▸ Done) → 단계 수행 후 완료 확인 (조기 채택 = adopt early 가능)
   │
강제(Enforced)           → Complete Steps By/예정 릴리스 도달 시 Salesforce가 자동 적용
                           (도중 postponed/canceled 가능)
```

---

## 모니터링 · 필터

- **Release Updates 페이지가 단일 모니터링 지점**이다 — org에 영향을 주는 모든 업데이트, 각 update의 상태, 남은 단계, `Complete Steps By` 날짜, Test Run 가능 여부를 한 곳에서 본다.
- 각 update는 **View Details**의 확장 섹션으로 *변경 내용 / 기대 개선점 / org 영향*을 페이지 이동 없이 빠르게 파악할 수 있다.
- update 목록은 **강제 시점 기준으로 분류**되어(이번 릴리스 강제 / 향후 릴리스 강제 / 연기), 기한이 임박한 항목을 우선 처리하도록 돕는다.

> ⚠️ 참고: Release Updates 홈의 세부 **필터 탭 라벨**(예: *Needs Action · Due Soon · Overdue · Archived*)은 커뮤니티 가이드에서 보고되나, 위에서 인용한 공식 help 문서 본문에는 명시 라벨로 확인되지 않았다. 위키에는 **공식 확인된 메커니즘**(Complete Steps By 기준 정렬·강제 시점 그룹핑·View Details)만 단정 서술한다. (라이브 org의 실제 탭 라벨은 릴리스에 따라 달라질 수 있음 — Setup 라벨 캐비엇, 2026-07-12)

---

## 릴리스 노트와의 관계 (역할 분리)

| 질문 유형 | 어디를 보나 |
|---|---|
| **"어떻게 처리하나"** — 절차·Test Run·기한·권한·라이프사이클 | **이 노트** (처리 메커니즘) |
| **"이번(특정) 릴리스에 무엇이 강제되나"** — 버전별 항목·강제 시점 목록 | [[Release MOC]] → 각 릴리스의 Release Updates 노트 (예: [[Spring '26/Release Updates]]) |

- 이 노트는 **버전 비종속(메커니즘)**이다. 특정 릴리스에서 강제되는 개별 항목 목록은 릴리스 노트 폴더의 `*/Release Updates.md`가 정본이다.
- 예: Spring '26에서 실제 강제되는 2건 + 이후 강제 예정 12건 + 연기 1건의 시점 맵은 [[Spring '26/Release Updates]]에 전수 정리돼 있다.

---

## 관련 노트

- [[Release MOC]] — 릴리스 노트 전체 목차 (버전별 강제 항목의 진입점)
- [[Spring '26/Release Updates]] — 특정 릴리스의 강제 항목·시점 맵 예시 (버전 콘텐츠 위임)
- [[Salesforce 어드민 종합 개요]] — 어드민 정기 태스크 맥락
- [[Setup Audit Trail (설정 감사 추적)]] — 설정 변경(업데이트 적용 포함) 추적
