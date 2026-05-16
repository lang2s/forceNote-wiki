# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a learning repository for Claude Code features. It contains several independent sub-projects, each in its own directory:

- **`todo-api/`** — FastAPI REST API with in-memory storage
- **`dividend_tracker/`** — Django web app for tracking stock dividends
- **`mcp-server/`** — Example MCP (Model Context Protocol) server
- **`my-first-plugin/`** — Example Claude Code plugin with skills
- **`skills/`** — Standalone skills (e.g., `frontend-design`)
- **`output-styles/`** — Example output style configurations
- **`hook/`** — Example Claude Code hook configs for Stop event sounds
- **`blog/`** — Static HTML blog pages

---

## Todo API (`todo-api/`)

FastAPI app with pure in-memory storage (`TodoStore` in `app/store.py`). **Data resets on restart** — this is intentional.

### Commands

```bash
cd todo-api
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload   # http://localhost:8000, docs at /docs
pytest tests/ -v                # run all tests
pytest tests/test_todos.py::test_create_todo -v  # run a single test
```

### Architecture

- `app/models.py` — Pydantic models: `TodoCreate`, `TodoUpdate`, `TodoResponse`
- `app/store.py` — `TodoStore` class: in-memory dict, auto-incrementing IDs
- `app/main.py` — FastAPI route handlers; all 404 logic lives here
- `tests/conftest.py` — provides `TestClient` fixture with store cleared between tests

---

## Dividend Tracker (`dividend_tracker/`)

Django 5.1 app, server-rendered templates, SQLite backend. Single-user, no authentication.

### Commands

```bash
cd dividend_tracker
uv venv && uv pip install -r requirements.txt
.venv/bin/python manage.py migrate
.venv/bin/python manage.py runserver   # http://127.0.0.1:8000/
.venv/bin/python manage.py test tracker
.venv/bin/python manage.py check
```

### Architecture

- `tracker/models.py` — Three models: `Ticker` → `Position` (FK), `Ticker` → `Dividend` (FK). Key computed properties live on the models (yield, income projections).
- `tracker/views.py` — 17 function-based views for full CRUD on all three models plus dashboard and projection.
- `tracker/templatetags/tracker_filters.py` — custom template filters: `currency`, `percentage`, `currency6`.
- `templates/base.html` — shared layout; all other templates extend it.

### Key Calculations (in `tracker/models.py`)

- `Ticker.annual_dividend_per_share`: sum of dividends with ex-date in trailing 12 months; annualizes proportionally if fewer than 12 months of data exist.
- `Position.projected_monthly_income`: `annual_div_per_share / 12 × total_shares`
- `Position.yield_on_cost`: `annual_div_per_share / cost_basis_per_share × 100`
- Dashboard Portfolio YOC: `total_annual_income / total_cost_basis × 100`

### Vercel Deployment

`vercel.json` and `build_files.sh` are already configured. SQLite does **not** persist on Vercel (ephemeral filesystem) — use a hosted DB for production. Required env vars: `DJANGO_SECRET_KEY`, `DEBUG=False`.

---

## MCP Server (`mcp-server/`)

Minimal example using `fastmcp`. `demo_mcp_server.py` shows a tool (`add`) and a resource (`demo://hello`). Uses `stdio` transport for Claude Code integration.

### Commands

```bash
cd mcp-server
uv run python demo_mcp_server.py
```

---

## Custom Agents (`.claude/agents/`)

Two project-scoped subagents are defined:

- **`code-improver.md`** — Analyzes code for readability, performance, and best practices. Invoked proactively after writing code.
- **`code-reviwer.md`** — Runs `git diff`, reviews modified files immediately after changes.

---

## Skills & Plugins

- **`skills/frontend-design/SKILL.md`** — Guides creation of distinctive frontend UIs; explicitly avoids generic aesthetics (Inter/Roboto fonts, purple gradients, cookie-cutter layouts).
- **`my-first-plugin/`** — Plugin with two skills: `hello` (personalized greeting) and `code-review` (checks organization, error handling, security, test coverage).
- **`output-styles/senior-review-mode.md`** — Output style that enforces strict senior-reviewer persona: asks clarifying questions before giving solutions.

---

## Hooks

`hook/COMMAND.md` contains settings JSON snippets for playing a system sound on the `Stop` event. Configs provided for macOS (`afplay`), Linux (`paplay`), and Windows (`powershell`).
