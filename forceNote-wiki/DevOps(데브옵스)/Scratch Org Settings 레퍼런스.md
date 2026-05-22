---
tags: [devops, scratch-org, settings, metadata-api, org-settings, configuration]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 6
created: 2026-05-22
aliases: [Scratch Org Settings, settings 블록, org settings, scratch org 설정, project-scratch-def settings]
---

# Scratch Org Settings 레퍼런스

> Scratch org definition file의 `settings` 블록 전수. Metadata API Settings 타입을 그대로 사용하며, 지원되는 모든 항목 수록.

---

## Settings 개요

Scratch org settings는 scratch org definition file의 `settings` 블록에 정의하는 org 환경 설정이다.

```json
{
  "orgName": "Acme",
  "edition": "Enterprise",
  "settings": {
    "<settingKey>": {
      "<fieldName>": <value>
    }
  }
}
```

**핵심 규칙:**
- Metadata API Developer Guide의 Settings 타입에서 지원되는 것은 모두 scratch org에서도 사용 가능
- Metadata API Developer Guide에서는 Upper CamelCase(`CommunitiesSettings`)이지만, scratch org definition file에서는 반드시 **lower camelCase**(`communitiesSettings`)로 작성
- Features보다 세밀한 제어 가능: 단순 on/off가 아니라 필드 값 지정

---

## 자주 사용하는 Settings 블록 전수

### activitiesSettings

```json
"activitiesSettings": {
  "enableCalendarHomeLWC": false,
  "enableTaskReminders": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableCalendarHomeLWC` | Boolean | Lightning Experience 캘린더 홈 LWC 사용 |
| `enableTaskReminders` | Boolean | 작업 미리 알림 활성화 |

---

### apexSettings

```json
"apexSettings": {
  "enableAggregateCodeCoverageOnly": false,
  "enableApexAccessRightsCrucial": false
}
```

---

### billingSettings

```json
"billingSettings": {
  "enableBillingSetup": true
}
```

`BillingAdvanced` feature와 함께 사용.

---

### botSettings

```json
"botSettings": {
  "enableBots": true
}
```

`Chatbot` feature와 함께 사용. Dev Hub에서 Enable Einstein Features 필요.

---

### campaignSettings

```json
"campaignSettings": {
  "enableAIAttribution": true,
  "enableCampaignInfluence2": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableAIAttribution` | Boolean | Einstein Attribution 활성화 (`AIAttribution` feature 필요) |
| `enableCampaignInfluence2` | Boolean | Customizable Campaign Influence 활성화 (`CampaignInfluence2` feature 필요) |

---

### caseSettings

```json
"caseSettings": {
  "systemUserEmail": "support@acme.com"
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `systemUserEmail` | String | 시스템 이메일 주소 |

---

### chatterSettings

```json
"chatterSettings": {
  "enableChatter": true
}
```

---

### communitiesSettings

```json
"communitiesSettings": {
  "enableNetworksEnabled": true,
  "enableOotbProfExtUserOpsEnable": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableNetworksEnabled` | Boolean | Experience Cloud (Communities) 활성화. `Communities` feature와 함께 필수 |
| `enableOotbProfExtUserOpsEnable` | Boolean | 외부 사용자 작업 Out-of-the-Box 활성화 |

---

### currencySettings

```json
"currencySettings": {
  "enableMultiCurrency": true
}
```

`MultiCurrency` feature와 함께 사용.

---

### devHubSettings

```json
"devHubSettings": {
  "enableDevOpsCenterGA": true
}
```

`DevOpsCenter` feature와 함께 사용. 법적 이유로 org shape에서 자동 캡처되지 않으므로 명시적으로 추가 필요.

---

### DocumentChecklistSettings

```json
"DocumentChecklistSettings": {
  "deleteDCIWithFiles": true
}
```

---

### einsteinGptSettings

```json
"einsteinGptSettings": {
  "enableEinsteinGptPlatform": true
}
```

`Einstein1AIPlatform` feature와 함께 사용. Agentforce·Prompt Builder·Model Builder 등 생성형 AI 기능 활성화.

---

### enhancedNotesSettings

```json
"enhancedNotesSettings": {
  "enableEnhancedNotes": true
}
```

Enhanced Notes(Lightning Notes) 활성화.

---

### experienceBundleSettings

```json
"experienceBundleSettings": {
  "enableExperienceBundleMetadata": true
}
```

Experience Bundle 메타데이터 API 지원 활성화. Experience Cloud 사이트 배포 시 필수.

---

### fieldServiceSettings

```json
"fieldServiceSettings": {
  "fieldServiceOrgPref": true,
  "o2EngineEnabled": true,
  "optimizationServiceAccess": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `fieldServiceOrgPref` | Boolean | Field Service 기본 활성화 |
| `o2EngineEnabled` | Boolean | Field Service Enhanced Scheduling and Optimization 활성화 (org shape 시 수동 추가 필요) |
| `optimizationServiceAccess` | Boolean | Field Service Integration 전용 활성화 (o2EngineEnabled 없이 사용) |

> Org Shape 주의: org shape에서 Field Service Enhanced Scheduling/Integration이 활성화된 경우에도 scratch org에는 자동으로 반영되지 않음. 수동으로 추가 필요.

---

### industriesSettings

```json
"industriesSettings": {
  "enableIndustriesAssessment": true,
  "enableDiscoveryFrameworkMetadata": true,
  "enableInteractionSummaryPref": true,
  "enableBenefitManagementPreference": true,
  "enableGroupMembershipPref": true,
  "enableCaseReferralPref": true
}
```

Industries 제품(Public Sector, Health Cloud, Financial Services Cloud 등) 관련 설정.

---

### languageSettings

```json
"languageSettings": {
  "enableTranslationWorkbench": true
}
```

다국어 번역 워크벤치 활성화.

---

### lightningExperienceSettings

```json
"lightningExperienceSettings": {
  "enableS1DesktopEnabled": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableS1DesktopEnabled` | Boolean | Lightning Experience 데스크탑 활성화 |

---

### mobileSettings

```json
"mobileSettings": {
  "enableS1EncryptedStoragePref2": false
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableS1EncryptedStoragePref2` | Boolean | Salesforce 모바일 앱 암호화 저장소. 대부분의 scratch org에서 `false` 권장 |

---

### nameSettings

```json
"nameSettings": {
  "enableMiddleName": true,
  "enableNameSuffix": true
}
```

Contact, Lead, Person Account, User 오브젝트에서 middle name·suffix 활성화.

---

### oauthOidcSettings

```json
"oauthOidcSettings": {
  "blockOAuthUnPwFlow": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `blockOAuthUnPwFlow` | Boolean | OAuth Username-Password 흐름 차단 |

---

### omniChannelSettings

```json
"omniChannelSettings": {
  "enableOmniChannel": true,
  "enableOmniSkillRouting": true
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableOmniChannel` | Boolean | Omni-Channel 활성화 |
| `enableOmniSkillRouting` | Boolean | Skill 기반 라우팅 활성화 |

---

### OmniStudioSettings

```json
"OmniStudioSettings": {
  "enableOmniStudioMetadata": false
}
```

---

### pathAssistantSettings

```json
"pathAssistantSettings": {
  "pathAssistantEnabled": true
}
```

Path (Sales Path) 기능 활성화.

---

### revenueManagementSettings

```json
"revenueManagementSettings": {
  "enableCoreCPQ": true
}
```

`CoreCpq` feature와 함께 사용. Revenue Cloud 기능 활성화.

---

### securitySettings

```json
"securitySettings": {
  "enableAdminLoginAsAnyUser": true,
  "sessionSettings": {
    "sessionTimeout": "TwelveHours"
  },
  "lockerServiceNext": false
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `enableAdminLoginAsAnyUser` | Boolean | 어드민이 다른 사용자로 로그인 가능 |
| `lockerServiceNext` | Boolean | Locker Service Next 활성화 |
| `sessionSettings.sessionTimeout` | String | 세션 타임아웃. 예: `"TwelveHours"` |

---

### userEngagementSettings

```json
"userEngagementSettings": {
  "enableOrchestrationInSandbox": true,
  "enableOrgUserAssistEnabled": true,
  "enableShowSalesforceUserAssist": false
}
```

---

---

## Settings와 Features 조합 패턴

일부 기능은 feature와 setting을 모두 지정해야 정상 작동.

| 기능 | Feature | Setting 필요 |
|---|---|---|
| Experience Cloud (Communities) | `Communities` | `communitiesSettings.enableNetworksEnabled: true` |
| Einstein 1 AI Platform | `Einstein1AIPlatform` | `einsteinGptSettings.enableEinsteinGptPlatform: true` |
| DevOps Center | `DevOpsCenter` | `devHubSettings.enableDevOpsCenterGA: true` |
| Revenue Cloud (CoreCPQ) | `CoreCpq` | `revenueManagementSettings.enableCoreCPQ: true` |
| Chatbot / Einstein Bots | `Chatbot` | `botSettings.enableBots: true` |
| Multi-Currency | `MultiCurrency` | `currencySettings.enableMultiCurrency: true` |
| Einstein Attribution | `AIAttribution` | `campaignSettings.enableAIAttribution: true`, `campaignSettings.enableCampaignInfluence2: true` |
| Customizable Campaign Influence | `CampaignInfluence2` | `campaignSettings.enableCampaignInfluence2: true` |
| Billing Advanced | `BillingAdvanced` | `billingSettings.enableBillingSetup: true` |

---

## 전체 설정 예시 (복합 시나리오)

### Enterprise + Communities + AI + Security

```json
{
  "orgName": "Acme Enterprise",
  "edition": "Enterprise",
  "features": ["Communities", "ServiceCloud", "Chatbot", "Einstein1AIPlatform"],
  "settings": {
    "communitiesSettings": {
      "enableNetworksEnabled": true,
      "enableOotbProfExtUserOpsEnable": true
    },
    "experienceBundleSettings": {
      "enableExperienceBundleMetadata": true
    },
    "lightningExperienceSettings": {
      "enableS1DesktopEnabled": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    },
    "securitySettings": {
      "enableAdminLoginAsAnyUser": true,
      "sessionSettings": {
        "sessionTimeout": "TwelveHours"
      }
    },
    "einsteinGptSettings": {
      "enableEinsteinGptPlatform": true
    },
    "omniChannelSettings": {
      "enableOmniChannel": true
    },
    "chatterSettings": {
      "enableChatter": true
    },
    "enhancedNotesSettings": {
      "enableEnhancedNotes": true
    }
  }
}
```

### OmniStudio + Industries (Health Cloud / Admissions Connect)

```json
{
  "orgName": "Omega - Dev Org",
  "edition": "Partner Developer",
  "hasSampleData": "true",
  "features": [
    "DevelopmentWave",
    "AdmissionsConnectUser",
    "Communities",
    "OmniStudioDesigner",
    "OmniStudioRuntime"
  ],
  "settings": {
    "lightningExperienceSettings": {
      "enableS1DesktopEnabled": true
    },
    "chatterSettings": {
      "enableChatter": true
    },
    "languageSettings": {
      "enableTranslationWorkbench": true
    },
    "enhancedNotesSettings": {
      "enableEnhancedNotes": true
    },
    "pathAssistantSettings": {
      "pathAssistantEnabled": true
    },
    "securitySettings": {
      "enableAdminLoginAsAnyUser": true
    },
    "userEngagementSettings": {
      "enableOrchestrationInSandbox": true,
      "enableOrgUserAssistEnabled": true,
      "enableShowSalesforceUserAssist": false
    },
    "experienceBundleSettings": {
      "enableExperienceBundleMetadata": true
    },
    "communitiesSettings": {
      "enableNetworksEnabled": true,
      "enableOotbProfExtUserOpsEnable": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    }
  }
}
```

### Benefit Management (Public Sector)

```json
{
  "orgName": "BM Org",
  "edition": "Developer",
  "features": ["BenefitManagement:2"],
  "settings": {
    "lightningExperienceSettings": {
      "enableS1DesktopEnabled": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    },
    "IndustriesSettings": {
      "enableIndustriesAssessment": true,
      "enableDiscoveryFrameworkMetadata": true,
      "enableInteractionSummaryPref": true,
      "enableBenefitManagementPreference": true,
      "enableGroupMembershipPref": true,
      "enableCaseReferralPref": true
    },
    "OmniStudioSettings": {
      "enableOmniStudioMetadata": false
    },
    "DocumentChecklistSettings": {
      "deleteDCIWithFiles": true
    }
  }
}
```

### Snapshot 기반 org에 Settings 추가

```json
{
  "orgName": "Salesforce",
  "snapshot": "dhsnapshot",
  "settings": {
    "activitiesSettings": {
      "enableCalendarHomeLWC": false
    },
    "omniChannelSettings": {
      "enableOmniSkillRouting": true,
      "enableOmniChannel": true
    },
    "experienceBundleSettings": {
      "enableExperienceBundleMetadata": true
    },
    "oauthOidcSettings": {
      "blockOAuthUnPwFlow": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    },
    "securitySettings": {
      "lockerServiceNext": false
    }
  }
}
```

---

## 완전한 Settings 목록 참조

Scratch org definition file의 `settings` 블록에는 Metadata API Developer Guide의 **모든 Settings 타입**을 사용할 수 있다. 주요 Settings 타입 목록:

- `accountSettings`
- `activitiesSettings`
- `addressSettings`
- `analyticsSettings`
- `apexSettings`
- `billingSettings`
- `botSettings`
- `briefcaseSettings`
- `businessHoursSettings`
- `campaignSettings`
- `caseSettings`
- `chatterAnswersSettings`
- `chatterEmailMdSettings`
- `chatterSettings`
- `communitiesSettings`
- `contractSettings`
- `currencySettings`
- `devHubSettings`
- `DocumentChecklistSettings`
- `einsteinGptSettings`
- `emailAdministrationSettings`
- `emailIntegrationSettings`
- `emailTemplateSettings`
- `enhancedNotesSettings`
- `experienceBundleSettings`
- `fieldServiceSettings`
- `fileUploadAndDownloadSettings`
- `flowSettings`
- `forecastingSettings`
- `ideasSettings`
- `industriesSettings`
- `iotSettings`
- `knowledgeSettings`
- `languageSettings`
- `lightningExperienceSettings`
- `liveAgentSettings`
- `macroSettings`
- `meetingSettings`
- `mobileSettings`
- `myDomainSettings`
- `nameSettings`
- `oauthOidcSettings`
- `omniChannelSettings`
- `OmniStudioSettings`
- `orderSettings`
- `pathAssistantSettings`
- `platformEncryptionSettings`
- `privacySettings`
- `productSettings`
- `quoteSettings`
- `revenueManagementSettings`
- `searchSettings`
- `securitySettings`
- `serviceCloudVoiceSettings`
- `sharingSettings`
- `surveySettings`
- `territory2Settings`
- `userEngagementSettings`
- `userManagementSettings`
- `voiceSettings`

> 전체 필드 목록과 가능한 값은 Metadata API Developer Guide: Settings 참조.

---

## 관련 노트

- [[Scratch Org 생성과 정의 파일]] — Definition File 옵션 전수, Features 전수, 생성 명령
- [[Scratch Org 패턴]] — Scratch Org 개요·활용 시나리오 (요약)
- [[Org Shape와 Snapshot]] — Org Shape 생성·사용, Snapshot 전수
- [[Scratch Org 배포·유저·에러코드]] — Deploy/Retrieve, Users 관리, Error Codes
