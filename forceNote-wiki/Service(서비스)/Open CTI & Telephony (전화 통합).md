---
tags: [service-cloud, open-cti, telephony, cti, softphone, salesforce-voice]
source: help.salesforce.com (Salesforce Help — Service; Salesforce Open CTI; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=cloud_cti_api_overview.htm&type=0
created: 2026-07-03
aliases: [Open CTI, Telephony, 전화 통합, CTI, Softphone, Salesforce Voice, Call Center]
---

# Open CTI & Telephony (전화 통합)

> 서드파티 전화 시스템(CTI)을 Salesforce Call Center와 통합하는 JavaScript API. Service Console의 softphone으로 통화를 처리한다. ⚠️ **유지보수 모드이며 2028-02-28 은퇴 예정 — 신규 구축은 Salesforce Voice 권장.**

---

> [!warning] 은퇴 예정 (Retirement Notice)
> **Open CTI는 maintenance mode(유지보수 모드)이며 2028년 2월 28일 은퇴(retirement) 예정이다.**
> 신규 기능·개선이 추가되지 않는다. 장기 호환성과 최신 혁신을 위해 Salesforce는 **Salesforce Voice로의 마이그레이션**을 권장한다. 신규 CTI 구축은 Open CTI가 아니라 Salesforce Voice를 우선 검토한다.

---

## 개념 — Open CTI란

**Open CTI**는 서드파티 **computer-telephony integration(CTI)** 시스템을 **Salesforce Call Center**와 통합·구축하기 위한 **JavaScript API**다. 전화 시스템 벤더는 이 API를 사용해 Salesforce 내부에서 통화를 걸고 받는 인터페이스를 만든다.

핵심은 서드파티 전화 시스템과 Salesforce 사이를 JavaScript API가 매개한다는 점이다. 통합 결과물은 Salesforce **Call Center**로 노출되어, 상담원이 CRM 데이터와 통화 제어를 한 화면에서 다룰 수 있다.

## Lightning Experience에서의 사용

Lightning Experience에서 통화하려면 **Open CTI for Lightning Experience**를 Lightning 앱에서 사용한다. 이때 사용하는 Lightning 앱은 기본 제공 **Service Console** 앱 같은 콘솔 앱을 예로 들 수 있다.

## Softphone

**Softphone** utility는 Lightning console 사용자가 Salesforce에서 직접 통화를 처리하게 해 주는 통화 제어판이다. utility bar에 배치되어 상담원이 화면 전환 없이 통화를 걸고 받는다.

softphone을 추가할 수 있는 대상:

- **Sales Dialer** 를 쓰는 Lightning console 앱
- **Open CTI** 를 쓰는 Lightning console 앱

> softphone이 붙는 워크스페이스 자체에 대한 상세는 [[Service Console (서비스 콘솔)]] 참조.

## 구성 개요

```
// 구조 예시 — Open CTI & Telephony(실제 원본 다이어그램 아님)
서드파티 CTI 시스템 ──(Open CTI JavaScript API)──▶ Salesforce Call Center
   Service Console 앱 utility bar: Softphone (Sales Dialer / Open CTI)
   Lightning: Open CTI for Lightning Experience
⚠️ Open CTI = maintenance mode · 2028-02-28 은퇴 → Salesforce Voice 이관 권장
```

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Service Console (서비스 콘솔)]] — softphone이 붙는 워크스페이스
