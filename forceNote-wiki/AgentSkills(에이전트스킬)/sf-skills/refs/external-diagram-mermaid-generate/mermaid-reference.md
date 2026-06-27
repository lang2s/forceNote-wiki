---
tags: [agent-skill, sf-skills, reference, diagram, mermaid, syntax]
source: forcedotcom/sf-skills (skills/external-diagram-mermaid-generate/references/mermaid-reference.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Mermaid Quick Reference, Mermaid 빠른 참조, Mermaid 문법]
---

# Mermaid Quick Reference — Mermaid 빠른 참조
> sf-diagram에서 사용하는 Mermaid 다이어그램 문법(시퀀스·ERD·플로우차트·테마·특수문자) 빠른 참조 가이드.

---

<!-- Parent: external-diagram-mermaid-generate/SKILL.md -->
# Mermaid Quick Reference

Quick reference guide for Mermaid diagram syntax used in sf-diagram.

## Sequence Diagrams

### Basic Syntax

```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob

    A->>B: Hello Bob
    B-->>A: Hi Alice
```

### Arrow Types

| Arrow | Meaning | Usage |
|-------|---------|-------|
| `->` | Solid line, no head | Internal processing |
| `-->` | Dotted line, no head | Optional/weak connection |
| `->>` | Solid line, arrowhead | Request/Call |
| `-->>` | Dotted line, arrowhead | Response/Return |
| `-x` | Solid line, X end | Failed/Cancelled |
| `--x` | Dotted line, X end | Failed response |
| `-)` | Solid, open arrow | Async (fire-and-forget) |
| `--)` | Dotted, open arrow | Async response |

### Participants and Actors

```mermaid
sequenceDiagram
    %% Rectangle participant
    participant A as Application

    %% Actor (stick figure)
    actor U as User

    %% With emoji
    participant SF as ☁️ Salesforce
```

### Grouping with Boxes

```mermaid
sequenceDiagram
    box Blue Client Side
        participant B as Browser
        participant A as App
    end

    box Orange Server Side
        participant SF as Salesforce
    end

    B->>A: Request
    A->>SF: API Call
```

### Activation (Lifelines)

```mermaid
sequenceDiagram
    participant A as Client
    participant B as Server

    A->>+B: Request
    Note right of B: Processing...
    B-->>-A: Response
```

Shorthand: `+` activates, `-` deactivates

### Loops and Conditionals

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server

    loop Every 5 seconds
        C->>S: Poll for status
        S-->>C: Status response
    end
```

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server

    C->>S: Request

    alt Success
        S-->>C: 200 OK
    else Client Error
        S-->>C: 400 Bad Request
    else Server Error
        S-->>C: 500 Error
    end
```

### Notes

```mermaid
sequenceDiagram
    participant A as Client
    participant B as Server

    Note left of A: Client prepares request
    Note right of B: Server processes
    Note over A,B: This spans both participants

    A->>B: Request
```

### Autonumber

```mermaid
sequenceDiagram
    autonumber
    participant A as Client
    participant B as Server

    A->>B: First (1)
    B-->>A: Second (2)
    A->>B: Third (3)
```

### Breaks and Critical Sections

```mermaid
sequenceDiagram
    participant A
    participant B

    critical Establish connection
        A->>B: Connect
        B-->>A: Connected
    option Connection failed
        A->>A: Log error
    end

    break When rate limited
        A->>A: Wait 60 seconds
    end
```

---

## Entity Relationship Diagrams

### Basic Syntax

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
```

### Cardinality Notation

| Symbol | Meaning |
|--------|---------|
| `\|o` | Zero or one |
| `\|\|` | Exactly one |
| `}o` | Zero or many |
| `}\|` | One or many |

### Full Cardinality Examples

```mermaid
erDiagram
    A ||--|| B : "one-to-one"
    C ||--o{ D : "one-to-many"
    E }o--o{ F : "many-to-many"
    G |o--o| H : "zero-or-one to zero-or-one"
```

### Entity Attributes

```mermaid
erDiagram
    ACCOUNT {
        Id Id PK "Primary Key"
        Text Name "Required field"
        Lookup OwnerId FK "Foreign Key"
        Currency AnnualRevenue
        Checkbox IsActive
    }
```

### Attribute Keys

| Key | Meaning |
|-----|---------|
| PK | Primary Key |
| FK | Foreign Key |
| UK | Unique Key |

---

## Flowcharts

### Basic Syntax

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 80, "rankSpacing": 70}} }%%
flowchart LR
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E

    style A fill:#a7f3d0,stroke:#047857,color:#1f2937
    style B fill:#fde68a,stroke:#b45309,color:#1f2937
    style C fill:#c7d2fe,stroke:#4338ca,color:#1f2937
    style D fill:#c7d2fe,stroke:#4338ca,color:#1f2937
    style E fill:#a7f3d0,stroke:#047857,color:#1f2937
```

### Direction

| Code | Direction |
|------|-----------|
| `TB` / `TD` | Top to Bottom |
| `BT` | Bottom to Top |
| `LR` | Left to Right |
| `RL` | Right to Left |

### Node Shapes

```mermaid
flowchart LR
    A[Rectangle]
    B(Rounded)
    C([Stadium])
    D&#91;&#91;Subroutine&#93;&#93;
    E[(Database)]
    F((Circle))
    G>Asymmetric]
    H{Diamond}
    I{{Hexagon}}
    J[/Parallelogram/]
    K[\Parallelogram alt\]
    L[/Trapezoid\]
    M[\Trapezoid alt/]
```

> 참고: 위 `D` 노드의 Subroutine(이중 사각형) 셰이프 원본 문법은 대괄호 두 쌍 `[` `[` Subroutine `]` `]` 입니다. 위키 링크 린터의 오탐을 피하려고 HTML 엔티티(`&#91;&#91;...&#93;&#93;`)로 표기했으니, 실제 사용 시 대괄호 두 쌍으로 작성하세요.

### Link Types

```mermaid
flowchart LR
    A --> B
    A --- C
    A -.-> D
    A ==> E
    A --text--> F
    A ---|text| G
```

| Link | Description |
|------|-------------|
| `-->` | Arrow |
| `---` | Line (no arrow) |
| `-.->` | Dotted arrow |
| `==>` | Thick arrow |
| `--text-->` | Arrow with text |

### Subgraphs

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 80, "rankSpacing": 70}} }%%
flowchart TB
    subgraph sf["☁️ SALESFORCE"]
        A[Trigger]
        B[Flow]
    end

    subgraph ext["🏭 EXTERNAL"]
        C[API]
    end

    A --> B
    B --> C

    style sf fill:#ecfeff,stroke:#0e7490,stroke-dasharray:5
    style ext fill:#ecfdf5,stroke:#047857,stroke-dasharray:5
    style A fill:#ddd6fe,stroke:#6d28d9,color:#1f2937
    style B fill:#c7d2fe,stroke:#4338ca,color:#1f2937
    style C fill:#a7f3d0,stroke:#047857,color:#1f2937
```

---

## Theming

### Init Directive

For spacing configuration (recommended):
```mermaid
%%{init: {"flowchart": {"nodeSpacing": 80, "rankSpacing": 70}} }%%
flowchart LR
    A --> B

    style A fill:#a5f3fc,stroke:#0e7490,color:#1f2937
    style B fill:#a5f3fc,stroke:#0e7490,color:#1f2937
```

For theme variables (legacy - prefer individual `style` declarations):
```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#00A1E0',
  'primaryTextColor': '#032D60',
  'lineColor': '#706E6B'
}}}%%
flowchart LR
    A --> B
```

### Available Themes

| Theme | Description |
|-------|-------------|
| `default` | Standard theme |
| `base` | Base for customization |
| `dark` | Dark mode |
| `forest` | Green tones |
| `neutral` | Grayscale |

### Common Theme Variables

**Sequence Diagrams:**
- `actorBkg`, `actorTextColor`, `actorBorder`
- `signalColor`, `signalTextColor`
- `labelBoxBkgColor`, `labelTextColor`
- `noteBkgColor`, `noteTextColor`

**ER Diagrams:**
- `primaryColor`, `primaryTextColor`
- `lineColor`
- `attributeBackgroundColorOdd/Even`

**Flowcharts:**
- `primaryColor`, `primaryTextColor`
- `lineColor`, `nodeBorder`
- `mainBkg`, `clusterBkg`

---

## Special Characters

### Escaping

Use `#` codes for special characters:

| Code | Character |
|------|-----------|
| `#quot;` | " |
| `#amp;` | & |
| `#lt;` | < |
| `#gt;` | > |
| `#59;` | ; |

### Line Breaks in Text

Use `<br/>` for line breaks:

```mermaid
sequenceDiagram
    participant A as Line 1<br/>Line 2
```

---

## Tips and Tricks

### 1. Comments

```mermaid
sequenceDiagram
    %% This is a comment
    A->>B: Hello
```

### 2. Multiline Notes

```mermaid
sequenceDiagram
    Note over A,B: Line 1<br/>Line 2<br/>Line 3
```

### 3. Styling Individual Nodes

Using `style` declarations (sf-skills standard):
```mermaid
%%{init: {"flowchart": {"nodeSpacing": 80, "rankSpacing": 70}} }%%
flowchart LR
    A[Success] --> B[Error]

    style A fill:#a7f3d0,stroke:#047857,color:#1f2937
    style B fill:#fecaca,stroke:#b91c1c,color:#1f2937
```

Using `classDef` (alternative approach):
```mermaid
flowchart LR
    A:::success --> B:::error

    classDef success fill:#a7f3d0,stroke:#047857,color:#1f2937
    classDef error fill:#fecaca,stroke:#b91c1c,color:#1f2937
```

### 4. Click Events (Interactive)

```mermaid
flowchart LR
    A[Salesforce Docs]
    click A "https://developer.salesforce.com" "Open Docs"
```

---

## Resources

- [Mermaid Official Docs](https://mermaid.js.org/intro/)
- [Mermaid Live Editor](https://mermaid.live/)
- [Sequence Diagram Syntax](https://mermaid.js.org/syntax/sequenceDiagram.html)
- [ER Diagram Syntax](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)
- [Flowchart Syntax](https://mermaid.js.org/syntax/flowchart.html)

## 관련 노트
- [[external-diagram-mermaid-generate]]
- [[mermaid-styling]]
- [[diagram-conventions]]
