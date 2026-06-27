---
tags: [agent-skill, sf-skills, platform, agentexchange, org-preference, metadata-api]
source: forcedotcom/sf-skills (skills/platform-agentexchange-partner-offers-configure/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-agentexchange-partner-offers-configure, 파트너 오퍼 org 설정, Transactable Marketplace partner offers, TransactableMarketplacePrivateOfferSettings, enableTransactableMarketplaceReceivePartnerOffers, 마켓플레이스 org preference]
---

# platform-agentexchange-partner-offers-configure — TM Partner Offers org preference 설정

> Transactable Marketplace partner offer 수신 여부를 제어하는 `enableTransactableMarketplaceReceivePartnerOffers` org preference를 `TransactableMarketplacePrivateOfferSettings` Metadata API 타입으로 enable/disable.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0`

org이 Transactable Marketplace를 통해 partner offer를 수신할 수 있는지 제어하는 `enableTransactableMarketplaceReceivePartnerOffers` org preference를 구성. TM partner offer 플로우에 참여하는 subscriber org에 필요.

**TRIGGER when:** 사용자가 partner offers enable/disable, `TransactableMarketplaceReceivePartnerOffers`/`enableTransactableMarketplaceReceivePartnerOffers` 구성, marketplace partner offer 수신 설정, TM partner offers 토글, `TransactableMarketplacePrivateOffer.settings` 편집, transactable marketplace 관련 org preference 구성을 요청할 때.

**DO NOT TRIGGER:** partner offer 레코드 자체 생성/관리, marketplace listing 설정 구성, `SfdcPartnerOffer` 오브젝트 작업(→ `platform-metadata-deploy` 또는 `platform-apex-generate`).

### Scope
- **In scope:** pref 현재 값 읽기, Metadata API(`TransactableMarketplacePrivateOfferSettings`)로 enable/disable, 변경 적용 확인.
- **Out of scope:** partner offer 레코드 생성/관리, marketplace listing 구성, offer 처리 관련 Apex/trigger 변경.

### Required Inputs
- **Target org alias/username:** pref 설정할 org. 미제공 시 질문.
- **Desired state:** `true`(enable) 또는 `false`(disable). Default: `true`.

---

## 워크플로 / 단계

### Phase 1 — 현재 상태 확인
1. **현재 preference 값 쿼리** (Tooling API):
```bash
sf data query -q "SELECT Preference, Value FROM OrgPreference WHERE Preference = 'TransactableMarketplaceReceivePartnerOffers'" --target-org <alias> --use-tooling-api
```
레코드 존재 + `Value = true`이면 이미 enable — 진행 전 사용자 confirm. no rows이면 pref 미설정(default `false`).

2. **org의 package directory resolve** (메타데이터 쓸 위치 결정):
```bash
jq -r '.packageDirectories[0].path // "force-app/main/default"' sfdx-project.json
```

### Phase 2 — preference 적용
3. **`TransactableMarketplacePrivateOfferSettings` 메타데이터 파일 작성** — 정확한 XML 구조는 `assets/org-pref-template.md` 로드 후 다음 위치에 작성:
```text
<packageDir>/settings/TransactableMarketplacePrivateOffer.settings
```
`<enableTransactableMarketplaceReceivePartnerOffers>true</enableTransactableMarketplaceReceivePartnerOffers>` 설정(disable 시 `false`).

XML 템플릿 (verbatim — `assets/org-pref-template.md`):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<TransactableMarketplacePrivateOfferSettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <enableTransactableMarketplaceReceivePartnerOffers>true</enableTransactableMarketplaceReceivePartnerOffers>
</TransactableMarketplacePrivateOfferSettings>
```

4. **메타데이터 배포** — 배포 전 confirm:
   - [ ] 사용자와 target org alias 확인(잘못된 org 배포는 쉽게 되돌릴 수 없음)
   - [ ] desired state(`true`/`false`)가 사용자 의도와 일치 확인
```bash
sf project deploy start --metadata TransactableMarketplacePrivateOfferSettings --target-org <alias>
```

### Phase 3 — 검증
5. **변경 확인** — step 1의 Tooling API 쿼리 재실행하여 `Value` 컬럼이 desired state와 일치 확인.
6. **사용자에게 보고** — Output Expectations 참조.

---

## 핵심 규칙·가드레일

### Rules / Constraints
| Rule | Rationale |
|---|---|
| 메타데이터 작성 전 항상 현재 값 쿼리 | 불필요 deploy 회피, 충돌 변경 감지 |
| 메타데이터 타입은 `TransactableMarketplacePrivateOfferSettings` 사용 | 이 pref용으로 플랫폼에 등록된 concrete 타입 — generic `OrgPreferenceSettings` 아님 |
| settings 파일명은 `TransactableMarketplacePrivateOffer.settings` | Metadata API가 파일명을 settings node명과 일치 요구 |
| `force-app/main/default/` 하드코딩 금지 | 항상 `sfdx-project.json`에서 실제 package directory 읽기 |
| org alias confirm 없이 배포 금지 | 잘못된 org 배포는 쉽게 되돌릴 수 없음 |

### Gotchas
| Issue | Resolution |
|---|---|
| Tooling API 쿼리 no rows | pref 미설정(default `false`). 새 settings 파일 생성 안전 |
| Deploy `INVALID_TYPE` 실패 | 타입명은 `TransactableMarketplacePrivateOfferSettings` — `--metadata` flag 값 확인 |
| Deploy 성공인데 값 변화 없음 | 프로젝트의 다른 settings 파일이 override 중일 수 있음 — 다른 `TransactableMarketplacePrivateOffer.settings` 검색 |
| Deploy `INSUFFICIENT_ACCESS_OR_READONLY` | 배포 실행 user에 "Modify All Data" 또는 org preference admin 권한 필요 |
| Pref UI에 안 보임 | `enableTransactableMarketplaceReceivePartnerOffers`는 Setup UI에 노출 안 됨 — Tooling API 쿼리가 유일한 검증 방법 |
| API v67.0+ 에서만 가용 | 타입이 API v67.0부터 — 구 API 버전 배포는 실패 |

> `assets/org-pref-template.md` 노트: 이 타입은 `apiCreateAllowed="false"`·`apiDeleteAllowed="false"`로 등록 — API로 update만 가능(create/delete 불가). 단 pref가 org에 항상 default 값으로 존재하므로, 새 로컬 settings 파일 작성·배포는 Metadata API가 update로 취급하여 항상 유효. `xmlns` 속성 필수(생략 시 parse error). 필드명은 `enable` prefix 포함.

### Output Expectations
모든 phase 완료 후 보고:
```text
Org: <alias>
Preference: enableTransactableMarketplaceReceivePartnerOffers
Previous value: <true|false|unset>
New value: <true|false>
File written: <packageDir>/settings/TransactableMarketplacePrivateOffer.settings
Deploy status: Success
```

---

## 번들 파일

`assets/`:
- `org-pref-template.md` — Phase 2 step 3 — settings 파일의 정확한 XML 구조

`examples/`:
- `org-preference-settings.xml` — 생성 파일이 기대 형식과 일치하는지 검증

`SKILL.md`

---

## 관련 노트
- [[platform-data-manage]]
- [[platform-lightning-app-coordinate]]
