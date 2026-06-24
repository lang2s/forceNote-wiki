---
tags: [field-service, fsl, sobject, object-reference, supplementary, history, feed, share, 현장서비스, 보조객체]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [Supplementary Field Service Objects, FSL Supplementary Objects, Field Service History Feed Share, 현장서비스 보조객체, History Feed Share OwnerSharingRule]
---

# 객체 레퍼런스 — Supplementary Objects (History·Feed·Share)

> Field Service의 부수 객체 57개 — 부모 객체에 따라붙는 History / Feed / Share / OwnerSharingRule 패턴 객체로, 가이드에 개별 필드표 없이 이름만 나열된다.

---

## 이 부록의 성격

Field Service Developer Guide의 *Object References* 챕터 말미(물리 p.496–497, "Supplementary Field Service Objects")에는 **이력 추적(history tracking)이나 공유(sharing)를 지원하는 보조 객체 57개**가 이름만 bullet로 나열된다. 가이드 원문 그대로:

> *"A list of Field Service objects that support history tracking or sharing."*

이 57개는 모두 **표준 플랫폼 패턴 객체**로, 자체 비즈니스 필드를 갖지 않고 부모 객체에 자동으로 따라붙는다. 따라서 가이드에 개별 Field/Details 표가 없으며, 본 노트는 이름을 **전수 보존**하는 부록이다. 각 객체의 의미는 그 접미사(suffix)로 결정된다.

| 접미사 패턴 | 의미 |
|---|---|
| `...History` | 부모 레코드의 **필드 변경 이력**을 추적 (field history tracking). |
| `...Feed` | 부모 레코드에 연결된 **Chatter 피드** 항목. |
| `...Share` | 부모 레코드의 **공유(sharing) 엔트리** — 수동/Apex 관리 공유를 표현. |
| `...OwnerSharingRule` | 부모 레코드의 **소유자 기반 공유 규칙**(owner-based sharing rule). |

### asterisk(`*`) 표기의 의미

가이드 원문 Note (PDF p.496):

> *"Most objects are available only if Field Service is enabled. Objects not tied to Field Service enablement are shown with an asterisk (*)."*

즉 **대부분의 보조 객체는 Field Service가 활성화된 경우에만 사용 가능**하며, **asterisk(`*`)가 붙은 객체는 Field Service 활성화와 무관하게 사용 가능**하다. 아래 목록에서 `*` 표기는 원문 그대로 보존한다.

---

## 객체 한눈에 — 부모 객체별 그룹 (전수 57개)

```text
// 구조 예시 — 가이드는 57개를 단일 bullet 리스트로 나열. 아래 트리는 부모 객체별로 재그룹핑한 것(원본 다이어그램 아님).
부모 객체 ─┬─ Feed
           ├─ History
           ├─ OwnerSharingRule
           └─ Share
```

각 행은 "부모 객체 → 따라붙는 보조 객체들"이다. 보조 객체 풀네임 = `부모객체명 + 접미사`.

| # | 부모 객체 | 보조 객체 (접미사) | 개수 |
|---|---|---|---|
| 1 | Asset | AssetOwnerSharingRule\*, AssetShare\* | 2 |
| 2 | LinkedArticle | LinkedArticleHistory | 1 |
| 3 | MaintenanceWorkRule | MaintenanceWorkRuleFeed, MaintenanceWorkRuleHistory, MaintenanceWorkRuleOwnerSharingRule, MaintenanceWorkRuleShare | 4 |
| 4 | OperatingHours | OperatingHoursHistory | 1 |
| 5 | ProductRequest | ProductRequestHistory, ProductRequestOwnerSharingRule, ProductRequestShare | 3 |
| 6 | ProductServiceCampaign | ProductServiceCampaignFeed, ProductServiceCampaignHistory, ProductServiceCampaignOwnerSharingRule, ProductServiceCampaignShare | 4 |
| 7 | ProductServiceCampaignItem | ProductServiceCampaignItemFeed, ProductServiceCampaignItemHistory, ProductServiceCampaignItemOwnerSharingRule, ProductServiceCampaignItemShare | 4 |
| 8 | ProductTransfer | ProductTransferHistory, ProductTransferOwnerSharingRule, ProductTransferShare | 3 |
| 9 | ResourceAbsence | ResourceAbsenceHistory | 1 |
| 10 | ResourcePreference | ResourcePreferenceHistory | 1 |
| 11 | ReturnOrder | ReturnOrderHistory, ReturnOrderOwnerSharingRule, ReturnOrderShare | 3 |
| 12 | ReturnOrderLineItem | ReturnOrderLineItemHistory | 1 |
| 13 | ServiceAppointment | ServiceAppointmentHistory, ServiceAppointmentOwnerSharingRule, ServiceAppointmentShare | 3 |
| 14 | ServiceCrew | ServiceCrewHistory, ServiceCrewOwnerSharingRule, ServiceCrewShare | 3 |
| 15 | ServiceCrewMember | ServiceCrewMemberHistory | 1 |
| 16 | ServiceResourceCapacity | ServiceResourceCapacityHistory | 1 |
| 17 | ServiceResource | ServiceResourceHistory, ServiceResourceOwnerSharingRule, ServiceResourceShare | 3 |
| 18 | ServiceResourceSkill | ServiceResourceSkillHistory | 1 |
| 19 | ServiceTerritory | ServiceTerritoryHistory | 1 |
| 20 | ServiceTerritoryMember | ServiceTerritoryMemberHistory | 1 |
| 21 | SkillRequirement | SkillRequirementHistory | 1 |
| 22 | TimeSheetEntry | TimeSheetEntryHistory | 1 |
| 23 | TimeSheet | TimeSheetHistory, TimeSheetOwnerSharingRule, TimeSheetShare | 3 |
| 24 | TimeSlot | TimeSlotHistory | 1 |
| 25 | WorkOrder | WorkOrderHistory\*, WorkOrderShare\* | 2 |
| 26 | WorkOrderLineItem | WorkOrderLineItemHistory\* | 1 |
| 27 | WorkTypeGroup | WorkTypeGroupHistory, WorkTypeGroupShare | 2 |
| 28 | WorkTypeGroupMember | WorkTypeGroupMemberHistory | 1 |
| 29 | WorkType | WorkTypeHistory, WorkTypeOwnerSharingRule, WorkTypeShare | 3 |
| | **합계** | | **57** |

> `*` = Field Service 활성화와 무관하게 사용 가능한 객체 (가이드 원문 표기 보존).

---

## 원문 bullet 순서 (전수 57개, 가이드 나열 순)

부모별 그룹과 별개로, 가이드 p.496–497의 **원래 알파벳/나열 순서**를 그대로 보존한다.

1. AssetOwnerSharingRule\*
2. AssetShare\*
3. LinkedArticleHistory
4. MaintenanceWorkRuleFeed
5. MaintenanceWorkRuleHistory
6. MaintenanceWorkRuleOwnerSharingRule
7. MaintenanceWorkRuleShare
8. OperatingHoursHistory
9. ProductRequestHistory
10. ProductRequestOwnerSharingRule
11. ProductRequestShare
12. ProductServiceCampaignFeed
13. ProductServiceCampaignHistory
14. ProductServiceCampaignOwnerSharingRule
15. ProductServiceCampaignShare
16. ProductServiceCampaignItemFeed
17. ProductServiceCampaignItemHistory
18. ProductServiceCampaignItemOwnerSharingRule
19. ProductServiceCampaignItemShare
20. ProductTransferHistory
21. ProductTransferOwnerSharingRule
22. ProductTransferShare
23. ResourceAbsenceHistory
24. ResourcePreferenceHistory
25. ReturnOrderHistory
26. ReturnOrderLineItemHistory
27. ReturnOrderOwnerSharingRule
28. ReturnOrderShare
29. ServiceAppointmentHistory
30. ServiceAppointmentOwnerSharingRule
31. ServiceAppointmentShare
32. ServiceCrewHistory
33. ServiceCrewMemberHistory
34. ServiceCrewOwnerSharingRule
35. ServiceCrewShare
36. ServiceResourceCapacityHistory
37. ServiceResourceHistory
38. ServiceResourceOwnerSharingRule
39. ServiceResourceShare
40. ServiceResourceSkillHistory
41. ServiceTerritoryHistory
42. ServiceTerritoryMemberHistory
43. SkillRequirementHistory
44. TimeSheetEntryHistory
45. TimeSheetHistory
46. TimeSheetOwnerSharingRule
47. TimeSheetShare
48. TimeSlotHistory
49. WorkOrderHistory\*
50. WorkOrderLineItemHistory\*
51. WorkOrderShare\*
52. WorkTypeGroupHistory
53. WorkTypeGroupMemberHistory
54. WorkTypeGroupShare
55. WorkTypeHistory
56. WorkTypeOwnerSharingRule
57. WorkTypeShare

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]]
- [[Field Service Objects]]
- [[객체 레퍼런스 — Asset·Attribute·Warranty]]
- [[객체 레퍼런스 — Service Contract·Entitlement·Milestone]]
- [[객체 레퍼런스 — Service Appointment·Resource]]
- [[객체 레퍼런스 — Service Resource·Crew·Skill]]
- [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]]
- [[객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)]]
- [[객체 레퍼런스 — Maintenance·PSC·Location]]
