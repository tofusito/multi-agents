Apply the claude-api skill and help me with the following Claude API task:

$ARGUMENTS

Follow the claude-api skill conventions:
- Use the cheapest model that can reliably handle the task
- Apply prompt caching for any context > 2K tokens that repeats across calls
- Set max_tokens to the lowest value that can contain the expected output
- Load the API key from ANTHROPIC_API_KEY environment variable, never hardcode it
- Use the Batch API for non-interactive workloads (50% discount)
