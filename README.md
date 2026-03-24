# TokenSaver AI

> Intent-Augmented Semantic Retrieval (IASR) for LLM Context Optimization

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)

## The Problem

Modern LLM deployments load **200,000+ tokens** per query:
- System prompts (~10k tokens)
- Documentation (~50k tokens)  
- Conversation history (~30k tokens)
- Knowledge base (~100k tokens)

At GPT-4 pricing ($0.003/token), that's **$0.60/query**. For 1M daily queries: **$600,000/day**.

## The Solution

**Intent-Augmented Semantic Retrieval (IASR)** combines:
1. **Intent classification** — Understanding *what the user wants*
2. **Semantic search** — Finding *semantically similar content*
3. **Tag filtering** — Prioritizing *intent-relevant chunks*

### Results

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Tokens/query | 200,000 | 800 | **-99.6%** |
| Cost/query | $0.60 | $0.0024 | **-99.6%** |
| Relevance | 2.4/5 | 4.1/5 | **+71%** |
| Response time | 12-15s | 2-3s | **-80%** |

## Installation

### One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/Jellybean-Systems/tokensaver/main/install.sh | bash
```

### Manual Install

```bash
# Clone
$ git clone https://github.com/Jellybean-Systems/tokensaver.git
$ cd tokensaver

# Install
$ pip install -e .

# Initialize database
$ python -m tokensaver.init

# Run query
$ python -m tokensaver.query "How's the dashboard?"
```

### OpenClaw Install

For OpenClaw instances, copy the full setup from [`SETUP.md`](SETUP.md) — it auto-creates all necessary files.

## Quick Start

```python
from memory.tokensaver_wrapper import tokensaver

# Enhance any prompt
user_query = "What's the status of our projects?"
enhanced = tokensaver.enhance_prompt(user_query)

# Send enhanced prompt to your LLM
# Retrieves ~600 tokens of relevant context vs loading 200k+ tokens

# Get savings report
savings = tokensaver.get_savings_report()
print(f"Saved ${savings['estimated_cost_saved_usd']:.2f} in token costs")
```

## How It Works

```
User Query: "How's the dashboard?"
     ↓
Intent Classifier → "status" (0.1ms)
     ↓
Semantic Search + Intent Boost → Top 5 chunks
     ↓
Result: Dashboard status update (600 tokens vs 18,000)
```

### Intent Patterns

| Intent | Pattern | Example Queries |
|--------|---------|---------------|
| Status | `how('s\| is)\b`, `status\b` | "How's the project?" |
| Technical | `(fix\|debug\|error)\b` | "Fix security issue" |
| Action | `(deploy\|create\|build)\b` | "Create new workflow" |
| Information | `(what is\|explain)\b` | "Explain how this works" |

## Architecture

```python
# Core components
class IASR:
    def classify_intent(self, query: str) -> str
    def semantic_search(self, query: str, intent: str) -> List[Chunk]
    def rerank_results(self, chunks: List[Chunk]) -> List[Chunk]
    def assemble_context(self, chunks: List[Chunk]) -> str
```

### Database Schema

```sql
CREATE TABLE memory_chunks (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,           -- intent category
    content TEXT NOT NULL,        -- actual text
    embedding BLOB,               -- vector embedding
    content_hash TEXT UNIQUE,     -- deduplication
    timestamp DATETIME,
    relevance_score FLOAT,
    tags TEXT                     -- JSON intent tags
);

-- Full-text search
CREATE VIRTUAL TABLE memory_fts USING fts5(
    content, type, tags
);
```

## Documentation

- [`RESEARCH.md`](RESEARCH.md) — Technical paper with full methodology
- [`SETUP.md`](SETUP.md) — OpenClaw copy-paste installation guide
- [`API.md`](API.md) — Python API reference
- [`EXAMPLES.md`](EXAMPLES.md) — Use cases and code samples

## Use Cases

- **Chatbots** — Reduce context from 100k to 800 tokens
- **Document Q&A** — Precise retrieval from large corpora
- **Code Assistants** — Intent-aware code search
- **OpenClaw Agents** — Native integration for AI agents

## Performance

| Metric | Value |
|--------|-------|
| Intent classification | ~0.1ms |
| Semantic search | ~5ms |
| Total retrieval | ~12ms |
| Token reduction | 99.6% |

Tested with 637 chunks, scales to 10,000+ with SQLite.

## Contributing

See [CONTRIBUTING.md](../../.github/blob/main/CONTRIBUTING.md)

## License

MIT — See [LICENSE](LICENSE)

## Research

This project is based on the research paper:  
**"Intent-Augmented Semantic Retrieval for LLM Context Optimization"**

See [`RESEARCH.md`](RESEARCH.md) for the full technical paper.

## About

Built by [Jellybean Systems](https://github.com/Jellybean-Systems) — exploring human-AI collaboration with transparency first.

---

*Built with curiosity, tested with caffeine, deployed with care.*