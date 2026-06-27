---
tags: [agent-skill, sf-skills, reference, omnistudio, datapacks]
source: forcedotcom/sf-skills (skills/omnistudio-datapacks-deploy/references/job-file-template.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Vlocity Build job file, Vlocity 빌드 잡 파일, packExport packDeploy, DataPack 배포]
---

# Vlocity Build Job File Template — Vlocity Build 잡 파일 템플릿

> Vlocity Build Tool 잡 파일(YAML) 베이스라인 템플릿과 packExport/packDeploy/packRetry/packContinue 명령 패턴.

---

Use this as a baseline and keep only settings you need to override.

```yaml
projectPath: .
expansionPath: vlocity

# Optional: narrow export scope
queries:
  - OmniScript
  - IntegrationProcedure
  - DataRaptor
  - FlexCard

# Optional: deterministic targeted scope
# manifest:
#   - Product2/<global-key>
#   - OmniScript/<type>_<subtype>_<language>

# Optional runtime controls
autoUpdateSettings: true
defaultMaxParallel: 1
supportHeadersOnly: true
gitCheck: false
```

## Common command patterns

```bash
# Export
vlocity -sfdx.username <source> -job <job>.yaml packExport

# Deploy
vlocity -sfdx.username <target> -job <job>.yaml packDeploy

# Retry
vlocity -sfdx.username <target> -job <job>.yaml packRetry

# Continue interrupted
vlocity -sfdx.username <target> -job <job>.yaml packContinue
```

## 관련 노트
- [[omnistudio-datapacks-deploy]]
- [[troubleshooting-matrix]]
