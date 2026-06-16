# CFO Multi-Agents Methodology

A standardized multi-agent collaborative research workflow designed for CFO offices — enabling parallel research, cross-review, debate, and report consolidation across multiple domain experts.

> 中文版：[methodology.md](./methodology.md) 记录了完整的6阶段方法论和设计原理。本文档为技能说明。

## Overview

This skill orchestrates multiple specialized agents (legal counsel, tax advisor, auditor, investment banker, banker, COO, editor) through a structured 6-phase workflow:

```
Phase 1: Task Dispatch → Phase 2: Editor Review → Phase 3: Cross Review
→ Phase 4: Debate → Phase 5: Revision → Phase 6: Consolidation
```

Each phase has built-in quality gates, automated checks, and escalation paths for disagreements.

## Structure

```
cfo-multi-agents/
├── SKILL.md                     # Skill entry point — workflow, templates, cheatsheet
├── methodology.md               # Full methodology with principles and rationale
├── README.md                    # This file
├── agents/                      # Agent persona definitions
│   ├── legal-counsel.md         # Legal counsel
│   ├── tax-advisor.md           # Tax advisor
│   ├── auditor.md               # Auditor
│   ├── investment-banker.md     # Investment banker
│   ├── banker.md                # Banker
│   ├── COO.md                   # Chief Operating Officer
│   └── editor.md                # Editor / quality reviewer
└── references/                  # Supporting resources
    ├── check.sh                 # Citation integrity checker
    └── reference-rules.md       # Citation format specification
```

## Quick Start

### Prerequisites

- Claude Code with multi-agent capabilities
- The `agents/` directory added to your Claude Code project

### Workflow

1. **SKILL.md** contains the complete actionable workflow (160+ lines). Load this when you need to run a multi-agent research project.
2. **methodology.md** contains the full rationale (500+ lines). Read this when you need deeper context on why certain steps exist.
3. **Agent files** are loaded per agent when dispatching tasks.

### Key Principles

| Principle | Rationale |
|:----------|:----------|
| 6-phase order is fixed | Cannot skip, merge, or reorder phases |
| Editor review is async-per-report | Each report reviewed immediately upon delivery — no batching |
| Debate is mandatory | Controller cannot admit guilt on behalf of the accused |
| Cross-review opinions must be filed | Written to `cross-review/` directory before being forwarded to the reviewee |
| Citation discipline | New references appended to the end, check.sh run after each section |

## Features

- **Role-based agents**: Each domain expert has a defined persona with core capabilities, input/output specs, and citation rules
- **Default cross-reviewers**: Legal counsel + COO (legal framework + internal execution)
- **Three-color fix priority**: 🔴 P0 (must fix) → 🟡 P1 (should fix) → 🟢 P2 (nice to fix)
- **Debate escalation**: inbox conversation → consensus →分歧 disclosure → Task enforcement
- **Editor triple gate**: initial review → per-report final review → merged report review
- **Citation integrity**: `references/check.sh` validates [N] sequence continuity and bidirectional matching

## License

[MIT](LICENSE)
