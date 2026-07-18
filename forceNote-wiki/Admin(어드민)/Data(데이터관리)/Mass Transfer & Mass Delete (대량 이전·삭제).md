---
tags: [admin, data-management, mass-transfer, mass-delete, ownership]
source: help.salesforce.com (Salesforce Help — Mass Transfer Records / Delete Multiple Records and Reports; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.admin_transfer.htm&type=5
created: 2026-07-03
aliases: [Mass Transfer, 대량 이전, Mass Delete, 대량 삭제, 소유권 이전, 레코드 재배정]
---

# Mass Transfer & Mass Delete (대량 이전·삭제)

> Setup 도구로 여러 레코드의 **소유권을 한 번에 이전(Mass Transfer)**하거나 **여러 레코드를 한 번에 삭제(Mass Delete)**한다. 지원 밖 오브젝트는 Data Loader를 쓴다.

---

## 개요

Salesforce는 레코드를 하나씩 다루지 않고 **여러 건을 한 번에 처리**하는 두 가지 Setup 유틸리티를 제공한다.

| 도구 | 하는 일 | Setup 경로 |
|---|---|---|
| **Mass Transfer Records** | 여러 레코드의 **소유권(ownership)을 한 사용자에서 다른 사용자로 일괄 재배정** | Setup → Quick Find `Mass Transfer` → **Mass Transfer Records** |
| **Mass Delete Records** | 여러 레코드·리포트를 **한 번에 삭제** | Setup → Quick Find `Mass Delete` → **Mass Delete Records** |

두 Setup 도구가 지원하지 않는 오브젝트나 더 큰 규모의 대량 작업은 [[Data Loader]]로 처리한다.

---

## Mass Transfer Records (대량 이전)

여러 레코드의 **소유권을 한 사용자에서 다른 사용자로 한 번에 재배정**한다. account·lead 등 지원 오브젝트를 대상으로, 소유자가 바뀌는 상황(담당자 퇴사·영업 구역 재편 등)에서 레코드를 하나씩 열지 않고 일괄 이전할 수 있다.

- **경로:** Setup → Quick Find `Mass Transfer` → **Mass Transfer Records**
- **동작:** 소유권을 사용자 A → 사용자 B로 일괄 재배정한다.
- 이전 대상이 되는 사용자 관리는 [[Users (사용자 관리)]] 참조.

---

## Mass Delete Records (대량 삭제)

여러 레코드·리포트를 한 번에 삭제한다. 지원 오브젝트에는 **account·lead·activity·case·solution·product·report** 등이 포함된다.

- **경로:** Setup → Quick Find `Mass Delete` → **Mass Delete Records**
- **삭제 후 위치:** 삭제된 레코드는 **Recycle Bin(휴지통)**으로 이동한다.
- **cascade 주의:** 레코드 간 관계에 따라 **cascade 삭제**(연관 레코드까지 함께 삭제)가 발생할 수 있다. 삭제 전 영향 범위를 검토하는 것이 좋다. (cascade 세부 규칙은 공식 문서에 위임)

---

## Mass Reassign Account Teams (계정 팀 일괄 재배정)

계정 팀(그리고 대응 도구로 기회 팀)의 **팀 멤버를 여러 계정에 걸쳐 일괄 재배정**한다. 소유권(owner)을 옮기는 Mass Transfer와 달리, 이쪽은 **레코드에 딸린 팀(team) 멤버 구성**을 바꾼다. 담당자 교체·역할 재편 시 계정을 하나씩 열지 않고 한 번에 처리한다.

- **경로:** Setup → Quick Find `Mass Reassign` → **Mass Reassign Account Teams** (기회 팀은 **Mass Reassign Opportunity Teams**)
- **선행 조건:** account teams 기능이 활성화돼 있어야 이 도구가 노출된다.
- **할 수 있는 것:** 기존 팀 멤버를 새 멤버로 **교체** · 기존 멤버의 **역할(role) 변경** · 여러 계정에 새 팀 멤버 **추가** · 여러 계정에서 기존 멤버 **제거**.

> 출처: Salesforce Help — help.salesforce.com (Mass Reassign Account Teams / Maintain Your Users' Account Teams). Setup 라벨은 시점에 따라 달라질 수 있음(캐비엇 2026-07-12).

---

## Mass Update Addresses (주소 일괄 표준화)

표준 주소(address) 필드를 가진 레코드의 **국가/지역(country/territory) 또는 주/도(state/province) 값을 일괄 업데이트**한다. State and Country/Territory 픽리스트로 전환하거나 흩어진 주소 표기를 표준값으로 정리할 때 쓴다.

- **경로:** Setup → Quick Find `Mass Update Addresses` → **Mass Update Addresses** → **Countries** 또는 **State/Province** 선택 (State/Province 선택 시 대상 국가를 먼저 지정)
- **지원 대상(표준 주소 필드 보유):** accounts · contacts · contracts(activated) · contracts(not activated) · leads · orders(activated) · orders(draft).
- **모범 순서:** 국가/지역을 먼저 표준화한 뒤, 각 국가 안에서 주/도를 표준화한다.

> 출처: Salesforce Help — help.salesforce.com (`sf.data_updateaddresses.htm` Mass Update Addresses / Tips for Mass Updating Addresses). 지원 오브젝트 목록·모범 순서는 공식 스니펫 기준(접속 2026-07-12).

---

## Data Loader로 넘어가야 할 때

위 두 Setup 도구가 **지원하지 않는 오브젝트**이거나 처리 규모가 큰 경우, [[Data Loader]]를 사용해 mass delete / mass transfer를 수행한다.

```
// 구조 예시 — Mass Transfer & Mass Delete(실제 동작 코드 아님)
Setup → Mass Transfer Records: 소유권 A→B 일괄 재배정(지원 오브젝트)
Setup → Mass Delete Records: 다중 레코드 삭제 → Recycle Bin (cascade 주의)
지원 밖 오브젝트·대량 → Data Loader
```

---

## 관련 노트
- [[Data Loader]] — 지원 밖 오브젝트의 대량 삭제·이전
- [[Users (사용자 관리)]] — 소유권 이전 대상 사용자 관리
