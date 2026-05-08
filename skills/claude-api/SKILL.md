---
name: claude-api
description: Claude API and Anthropic SDK patterns — model selection, prompt caching, tool use, streaming, the Messages API, and cost optimization for Claude-powered applications.
compatibility: opencode
version: "1.0.0"
metadata:
  audience: workers
  domain: claude-api
---

## Model selection

| Model | ID | Use for |
|-------|----|---------|
| Haiku 4.5 | `claude-haiku-4-5-20251001` | Fast, cheap — simple tasks, summaries, classification |
| Sonnet 4.6 | `claude-sonnet-4-6` | Balanced — general implementation, debugging, reviews |
| Opus 4.7 | `claude-opus-4-7` | Best reasoning — architecture, security, complex multi-step |

Always use the cheapest model that can reliably handle the task.

## Messages API — basic request

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Hello"}]
)
print(response.content[0].text)
```

## Prompt caching

Cache large, stable context to cut input costs. Cache prefix must be ≥1024 tokens (Haiku) or ≥2048 tokens (Sonnet/Opus).

```python
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    system=[{
        "type": "text",
        "text": "<large stable system prompt>",
        "cache_control": {"type": "ephemeral"}
    }],
    messages=[{"role": "user", "content": "Question about the above"}]
)
```

Check `response.usage` for `cache_creation_input_tokens` and `cache_read_input_tokens`.

## Tool use

```python
tools = [{
    "name": "get_weather",
    "description": "Get current weather for a location",
    "input_schema": {
        "type": "object",
        "properties": {
            "location": {"type": "string", "description": "City name"}
        },
        "required": ["location"]
    }
}]

response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    tools=tools,
    messages=[{"role": "user", "content": "What's the weather in Madrid?"}]
)

# Check for tool use
if response.stop_reason == "tool_use":
    tool_block = next(b for b in response.content if b.type == "tool_use")
    # Execute the tool, then continue the conversation
```

## Streaming

```python
with client.messages.stream(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Write a long story"}]
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
```

## Extended thinking

For complex reasoning tasks with Sonnet or Opus:

```python
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=16000,
    thinking={"type": "enabled", "budget_tokens": 10000},
    messages=[{"role": "user", "content": "Solve this complex problem..."}]
)
```

## Cost optimization rules

1. **Cache first** — any context > 2K tokens that repeats across calls should be cached.
2. **Right-size the model** — use Haiku for classification, routing, simple extraction.
3. **Limit max_tokens** — set the lowest value that can contain the expected output.
4. **Batch API** for non-interactive workloads — 50% discount, 24h window.
5. **Minimize context** — do not pass the full conversation history if only recent turns are needed.

## Batch API

```python
response = client.messages.batches.create(
    requests=[
        {"custom_id": "req-1", "params": {"model": "claude-haiku-4-5-20251001", "max_tokens": 256, "messages": [...]}},
        {"custom_id": "req-2", "params": {"model": "claude-haiku-4-5-20251001", "max_tokens": 256, "messages": [...]}}
    ]
)
# Poll until processing_status == "ended"
```

## Error handling

| Error | Cause | Fix |
|-------|-------|-----|
| `overloaded_error` | API overloaded | Retry with exponential backoff |
| `rate_limit_error` | Too many requests | Reduce request rate, use batch API |
| `invalid_request_error` | Bad request shape | Check model ID, max_tokens > 0 |
| `authentication_error` | Bad API key | Check `ANTHROPIC_API_KEY` env var |

## Environment setup

```bash
pip install anthropic
export ANTHROPIC_API_KEY="sk-ant-..."
```

Always load the API key from an environment variable, never hardcode it.
