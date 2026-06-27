---
tags: [agent-skill, sf-skills, reference, platform, agentexchange]
source: forcedotcom/sf-skills (skills/platform-agentexchange-partner-offers-configure/assets/org-pref-template.md, 공식 Salesforce)
created: 2026-06-27
aliases: [TransactableMarketplacePrivateOfferSettings, AgentExchange 파트너 오퍼 설정, org pref template, settings metadata]
---
# TransactableMarketplacePrivateOfferSettings XML Template — AgentExchange 파트너 오퍼 설정 템플릿

> AgentExchange 파트너 오퍼 수신을 켜고/끄는 `TransactableMarketplacePrivateOfferSettings` 설정 메타데이터 파일의 정확한 XML 구조 템플릿.

---

Use this exact structure when writing the settings metadata file.

## File path

```text
<packageDir>/settings/TransactableMarketplacePrivateOffer.settings
```

## Template

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TransactableMarketplacePrivateOfferSettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <enableTransactableMarketplaceReceivePartnerOffers>true</enableTransactableMarketplaceReceivePartnerOffers>
</TransactableMarketplacePrivateOfferSettings>
```

Replace `true` with `false` to disable.

## Notes

- The metadata type is `TransactableMarketplacePrivateOfferSettings`, available from API version 67.0+.
- This type is registered with `apiCreateAllowed="false"` and `apiDeleteAllowed="false"` — it can only be updated, not created or deleted via the API. This does NOT mean you should skip writing the file: the preference always exists in the org with a default value, so writing a new local settings file and deploying it is treated as an update by the Metadata API and is always valid.
- The `xmlns` attribute is required; omitting it causes a deploy parse error.
- The field name is `enableTransactableMarketplaceReceivePartnerOffers` (note the `enable` prefix).

## 관련 노트
- [[platform-agentexchange-partner-offers-configure]]
