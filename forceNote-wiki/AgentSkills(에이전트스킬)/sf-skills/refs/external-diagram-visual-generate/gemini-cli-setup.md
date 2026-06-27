---
tags: [agent-skill, sf-skills, reference, diagram, visual, setup]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/references/gemini-cli-setup.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Gemini CLI Setup, Gemini CLI 설치, Nano Banana 설정]
---
# Gemini CLI Setup for external-diagram-visual-generate — Gemini CLI 설정
> Gemini CLI 인증, Nano Banana 확장·timg 설치, 환경 변수 구성 및 검증 절차.

<!-- Parent: external-diagram-visual-generate/SKILL.md -->

## Prerequisites

### 1. Authenticate with Google

```bash
# Start Gemini CLI - opens browser for OAuth
gemini

# Select "Login with Google" when prompted
# Credentials cached at ~/.gemini/oauth_creds.json
```

### 2. Install Nano Banana Extension

```bash
gemini extensions install nanobanana
```

### 3. Install timg for Image Display

```bash
brew install timg
```

### 4. Configure Environment

Add to `~/.zshrc`:

```bash
export NANOBANANA_MODEL=gemini-3-pro-image-preview
export PATH="$HOME/.local/bin:$PATH"
```

---

## Verification

```bash
# Check Gemini CLI
gemini --version

# Check Nano Banana
gemini extensions list

# Check timg
which timg

# Test image generation
gemini "/generate 'A blue circle on white background'"
timg ~/gemini-images/*.png
```

---

## File Locations

| File | Purpose |
|------|---------|
| `~/.gemini/settings.json` | Gemini CLI settings |
| `~/.gemini/oauth_creds.json` | OAuth tokens |
| `~/.gemini/extensions/nanobanana/` | Nano Banana extension |
| `~/gemini-images/` | Generated images |

## 관련 노트
- [[external-diagram-visual-generate]]
- [[iteration-workflow]]
- [[examples-index]]
