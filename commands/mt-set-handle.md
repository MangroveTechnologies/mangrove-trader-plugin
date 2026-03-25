---
name: mt-set-handle
description: Set your Twitter handle for this session (used by all other commands)
---

# mt-set-handle

Set your Twitter handle so other commands don't have to ask every time.

## Steps

1. The user provides their Twitter handle (with or without @)
2. Remember this handle for the rest of the conversation
3. Confirm: "Handle set to @{handle}. All commands will use this as your identity."
4. From now on, when any `/mt-*` command needs `twitter_handle` or `requester_handle`, use this handle automatically instead of asking.

## Notes

- This is session-scoped — it resets when you start a new conversation
- You can change it anytime by running `/mt-set-handle` again
- Commands that look up OTHER traders (e.g., `/mt-stats someoneelse`) still accept an explicit handle
