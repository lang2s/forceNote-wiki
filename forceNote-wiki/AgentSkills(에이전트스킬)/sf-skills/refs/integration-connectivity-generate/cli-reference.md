---
tags: [agent-skill, sf-skills, reference, integration, cli]
source: forcedotcom/sf-skills (skills/integration-connectivity-generate/references/cli-reference.md, 공식 Salesforce)
created: 2026-06-27
aliases: [CLI Commands, CLI 명령어, sf 명령어, Helper Scripts]
---

# CLI Commands & Helper Scripts — CLI 명령어와 헬퍼 스크립트

> Named Credential·External Service·Platform Event 배포 및 API 요청을 위한 sf CLI 명령어와 자동화 헬퍼 스크립트 모음.

---

## Named Credentials

```bash
# List Named Credentials
sf org list metadata --metadata-type NamedCredential --target-org {{alias}}

# Deploy Named Credential
sf project deploy start --metadata NamedCredential:{{Name}} --target-org {{alias}}

# Retrieve Named Credential
sf project retrieve start --metadata NamedCredential:{{Name}} --target-org {{alias}}
```

## External Services

```bash
# List External Service Registrations
sf org list metadata --metadata-type ExternalServiceRegistration --target-org {{alias}}

# Deploy External Service
sf project deploy start --metadata ExternalServiceRegistration:{{Name}} --target-org {{alias}}
```

## Platform Events

```bash
# List Platform Events
sf org list metadata --metadata-type CustomObject --target-org {{alias}} | grep "__e"

# Deploy Platform Event
sf project deploy start --metadata CustomObject:{{EventName}}__e --target-org {{alias}}
```

## API Requests (Beta)

```bash
# REST API request
sf api request rest /services/data/v66.0/sobjects/Account/describe --target-org {{alias}}

# REST with POST body
sf api request rest /services/data/v66.0/sobjects/Account --method POST \
  --body '{"Name":"Test Account"}' --target-org {{alias}}

# GraphQL query
sf api request graphql --body '{"query":"{ uiapi { query { Account { edges { node { Name { value } } } } } } }"}' --target-org {{alias}}
```

> **[Beta]** These commands simplify API exploration. For production, use Named Credentials and Apex callouts.

---

## Helper Scripts

integration-connectivity-generate includes automation scripts to configure credentials without manual UI steps.

### Available Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `configure-named-credential.sh` | Set API keys via ConnectApi (Enhanced NC) | `./scripts/configure-named-credential.sh <org-alias>` |
| `set-api-credential.sh` | Store keys in Custom Settings (legacy) | `./scripts/set-api-credential.sh <name> - <org-alias>` |

### Auto-Run Behavior

| File Pattern | Suggested Action |
|--------------|------------------|
| `*.namedCredential-meta.xml` | Run `configure-named-credential.sh` |
| `*.externalCredential-meta.xml` | Run `configure-named-credential.sh` |
| `*.cspTrustedSite-meta.xml` | Deploy endpoint security |

### Example Workflow

```bash
# 1. Deploy metadata first
sf project deploy start --metadata ExternalCredential:WeatherAPI \
  --metadata NamedCredential:WeatherAPI \
  --target-org MyOrg

# 2. Run automation script
./scripts/configure-named-credential.sh MyOrg
# Enter API key when prompted (secure, hidden input)
```

### Prerequisites

- **Salesforce CLI v2+**: `sf` command available
- **Authenticated org**: `sf org login web -a <alias>`
- **Deployed metadata**: External Credential and Named Credential deployed

See [references/named-credentials-automation.md](../references/named-credentials-automation.md) for complete guide.

---

## 관련 노트
- [[integration-connectivity-generate]]
- [[named-credentials-automation]]
- [[named-credentials-guide]]
