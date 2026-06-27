---
tags: [index, agent-skills, sf-skills, refs, catalog]
created: 2026-06-27
---

# sf-skills 레퍼런스 문서 카탈로그 (refs)

> `forcedotcom/sf-skills` 각 스킬이 동작 중 참조하는 **레퍼런스 문서 252개**(41개 부모 스킬)의 허브. 각 노트 경로 = `AgentSkills(에이전트스킬)/sf-skills/refs/<skill-id>/<basename>.md`.
> 부모 스킬 본체 카탈로그는 [[../index|sf-skills 카탈로그]]. 키워드 검색은 도메인별 refs 샤드(`_index/agent-skills-refs-*.md`).

**상위:** [[../index|sf-skills 카탈로그]] · [[../../index|AgentSkills(에이전트스킬)]]

---

## Diagram (다이어그램) — 45

### external-diagram-mermaid-generate
- [[agent-flow]] · [[api-sequence]] · [[authorization-code-pkce]] · [[authorization-code]] · [[b2b-commerce-erd]] · [[campaigns-erd]] · [[client-credentials]] · [[color-palette]] · [[consent-erd]] · [[device-authorization]] · [[diagram-conventions]] · [[erd-conventions]] · [[files-erd]] · [[forecasting-erd]] · [[fsl-erd]] · [[jwt-bearer]] · [[mermaid-reference]] · [[mermaid-styling]] · [[party-model-erd]] · [[preview-guide]] · [[quote-order-erd]] · [[refresh-token]] · [[revenue-cloud-erd]] · [[sales-cloud-erd]] · [[salesforce-erd]] · [[scheduler-erd]] · [[service-cloud-erd]] · [[system-landscape]] · [[territory-management-erd]] · [[usage-examples]] · [[user-agent-social-sign-on]] · [[user-hierarchy]]

### external-diagram-visual-generate
- [[apex-review]] · [[architect-aesthetic-guide]] · [[core-objects]] · [[custom-objects]] · [[dashboard-card]] · [[data-table]] · [[examples-index]] · [[gemini-cli-setup]] · [[integration-flow]] · [[interview-questions]] · [[iteration-workflow]] · [[lwc-review]] · [[record-form]]

---

## Agentforce (에이전트) — 43

### agentforce-generate
- [[README-legacy]] · [[action-prompt-templates]] · [[actions-reference]] · [[agent-access-guide]] · [[agent-design-and-spec-creation]] · [[agent-metadata-and-lifecycle]] · [[agent-script-core-language]] · [[agent-spec-template]] · [[agent-subagent-map-diagrams]] · [[agent-user-setup]] · [[agent-validation-and-debugging]] · [[agents-README]] · [[architecture-patterns]] · [[complex-data-types]] · [[deploy-reference]] · [[discover-reference]] · [[agentforce-generate/examples|examples]] · [[feature-validity]] · [[instruction-resolution]] · [[known-issues]] · [[minimal-examples]] · [[patterns-README]] · [[production-gotchas]] · [[safety-review-reference]] · [[salesforce-cli-for-agents]] · [[scaffold-reference]] · [[agentforce-generate/scoring-rubric|scoring-rubric]] · [[version-history]]

### agentforce-test
- [[action-execution]] · [[batch-testing]] · [[preview-testing]] · [[test-report-format]] · [[agentforce-test/troubleshooting|troubleshooting]]

### agentforce-observe
- [[improve-reference]] · [[issue-classification]] · [[reproduce-reference]] · [[stdm-queries]] · [[stdm-schema]]

### agentforce-d360-analyze
- [[artifacts]] · [[dc_dmo_fields]] · [[dc_pipeline_contract]]

### agentforce-architecture-analyze
- [[architecture_sections]] · [[soql_fields]]

---

## Platform (Apex · Metadata · 데이터) — 50

### platform-data-manage
- [[anonymous-apex-guide]] · [[bulk-operations-guide]] · [[bulk-testing-example]] · [[cleanup-rollback-example]] · [[cleanup-rollback-guide]] · [[crud-workflow-example]] · [[governor-limits-reference]] · [[platform-data-manage/orchestration|orchestration]] · [[relationship-query-examples]] · [[sf-cli-data-commands]] · [[soql-relationship-guide]] · [[test-data-best-practices]] · [[test-data-factory-usage]] · [[test-data-patterns]]

### platform-soql-query
- [[anti-patterns]] · [[platform-soql-query/cli-commands|cli-commands]] · [[field-coverage-rules]] · [[query-optimization]] · [[selector-patterns]] · [[soql-reference]] · [[soql-syntax-reference]]

### platform-apex-logs-debug
- [[analysis-playbook]] · [[benchmarking-guide]] · [[platform-apex-logs-debug/cli-commands|cli-commands]] · [[common-issues]] · [[debug-log-reference]] · [[log-analysis-tools]] · [[platform-apex-logs-debug/scoring-rubric|scoring-rubric]]

### platform-apex-test-run
- [[platform-apex-test-run/cli-commands|cli-commands]] · [[platform-apex-test-run/mocking-patterns|mocking-patterns]] · [[performance-optimization]] · [[test-fix-loop]] · [[test-patterns]] · [[testing-best-practices]]

### platform-apex-test-generate
- [[assertion-patterns]] · [[async-testing]] · [[platform-apex-test-generate/mocking-patterns|mocking-patterns]] · [[test-data-factory]]

### platform-metadata-deploy
- [[agent-deployment-guide]] · [[deployment-report-template]] · [[deployment-workflows]] · [[platform-metadata-deploy/orchestration|orchestration]] · [[trigger-deployment-safety]]

### platform-trust-archive-manage
- [[archive-activity-entity]] · [[connect-api-operations]]

### platform-metadata-api-context-get
- [[metadata_index_table]] · [[usage_guide]]

### platform-custom-lightning-type-generate
- [[primitive-types-and-constraints]] · [[widget-rendition]]

### platform-agentexchange-partner-offers-configure
- [[org-pref-template]]

---

## Experience (LWC · UI Bundle) — 20

### experience-lwc-generate
- [[accessibility-guide]] · [[advanced-features]] · [[async-notification-patterns]] · [[experience-lwc-generate/cli-commands|cli-commands]] · [[component-patterns]] · [[flow-integration-guide]] · [[jest-testing]] · [[lms-guide]] · [[lwc-best-practices]] · [[performance-guide]] · [[scoring-and-testing]] · [[slds-design-guide]] · [[state-management]] · [[template-anti-patterns]] · [[triangle-pattern]]

### experience-ui-bundle-agentforce-client-generate
- [[agent-id-resolution]] · [[constraints]] · [[experience-ui-bundle-agentforce-client-generate/examples|examples]] · [[style-tokens]] · [[experience-ui-bundle-agentforce-client-generate/troubleshooting|troubleshooting]]

---

## Integration (커넥티비티 · 이벤팅) — 25

### integration-connectivity-generate
- [[callout-patterns]] · [[cdc-guide]] · [[cli-reference]] · [[event-driven-architecture-guide]] · [[event-patterns]] · [[external-service-operations]] · [[external-services-guide]] · [[messaging-api-v2]] · [[named-credentials-automation]] · [[named-credentials-guide]] · [[platform-events-guide]] · [[rest-callout-patterns]] · [[integration-connectivity-generate/scoring-rubric|scoring-rubric]] · [[security-best-practices]] · [[wsdl2apex-guide]]

### integration-connectivity-connected-app-configure
- [[example-usage]] · [[migration-guide]] · [[oauth-flows-reference]] · [[security-checklist]] · [[testing-validation-guide]]

### integration-eventing-subscription-configure
- [[delete-guide]] · [[topic-name-formats]] · [[update-constraints]]

### integration-eventing-cdc-configure
- [[deploy-troubleshooting]] · [[filter-expressions]]

---

## OmniStudio — 17

### omnistudio-datamapper-generate
- [[omnistudio-datamapper-generate/best-practices|best-practices]] · [[completion-summary-template]] · [[omnistudio-datamapper-generate/naming-conventions|naming-conventions]]

### omnistudio-datapacks-deploy
- [[job-file-template]] · [[troubleshooting-matrix]]

### omnistudio-dependencies-analyze
- [[dependency-patterns]] · [[namespace-guide]]

### omnistudio-epc-catalog-generate
- [[epc-field-guide]] · [[omnistudio-epc-catalog-generate/naming-conventions|naming-conventions]] · [[scoring-model]]

### omnistudio-flexcard-generate
- [[omnistudio-flexcard-generate/best-practices|best-practices]] · [[data-binding-guide]] · [[omnistudio-flexcard-generate/scoring-rubric|scoring-rubric]]

### omnistudio-integration-procedure-generate
- [[omnistudio-integration-procedure-generate/best-practices|best-practices]] · [[omnistudio-integration-procedure-generate/element-types|element-types]]

### omnistudio-omniscript-generate
- [[omnistudio-omniscript-generate/best-practices|best-practices]] · [[omnistudio-omniscript-generate/element-types|element-types]]

---

## Design Systems · DX · Mobile · Data 360 · Commerce (기타) — 52

### design-systems-slds-apply
- [[component-selection]] · [[icons-decision-guide]] · [[styling-decision-guide]] · [[utilities-quick-ref]]

### design-systems-slds-validate
- [[quality-checks]] · [[report-format]]

### design-systems-slds2-migrate
- [[color-hooks-decision-guide]] · [[common-patterns]] · [[design-systems-slds2-migrate/examples|examples]] · [[migration-checklist]] · [[non-color-hooks-decision-guide]] · [[rule-lwc-token-to-slds-hook]] · [[rule-no-deprecated-tokens-slds1]] · [[rule-no-hardcoded-values]] · [[rule-no-slds-class-overrides]]

### dx-code-analyzer-configure
- [[ci-cd-templates]] · [[config-schema]] · [[diagnostic-flow]] · [[engine-prerequisites]] · [[rule-name-resolution]] · [[dx-code-analyzer-configure/troubleshooting|troubleshooting]]

### dx-code-analyzer-run
- [[command-examples]] · [[engine-reference]] · [[error-handling]] · [[flag-reference]] · [[post-scan-workflows]] · [[quick-start]] · [[special-behaviors]] · [[vendor-file-handling]]

### mobile-platform-native-capabilities-integrate
- [[app-review]] · [[ar-space-capture]] · [[barcode-scanner]] · [[base-capability]] · [[biometrics]] · [[calendar]] · [[contacts]] · [[document-scanner]] · [[geofencing]] · [[location]] · [[mobile-capabilities]] · [[nfc]] · [[payments]]

### mobile-platform-offline-validate
- [[grounding]] · [[inline-graphql]] · [[komaci-eslint]] · [[lwc-if]]

### data360-orchestrate
- [[feature-readiness]] · [[plugin-setup]]

### developing-datacloud-code-extension
- [[developing-datacloud-code-extension/README|README]] · [[quick-reference]]

### getting-datacloud-schema
- [[getting-datacloud-schema/README|README]]

### commerce-b2b-store-create
- [[store-vs-storefront]]

---

> **등록 완료:** 41개 부모 스킬 **252개 레퍼런스 문서** 전부 등재. 키워드 검색은 `_index/agent-skills-refs-{diagram|agentforce|platform|experience|integration|omnistudio|misc}.md`.
