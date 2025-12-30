---
description: Create commit based on current changes with smart type detection
agent: build
---

Generate clear, conventional commit messages following best practices. Automatically detect if changes are agent/AI-related or regular code changes.

## Instructions

Follow these steps to create a well-structured commit message:

1. Run `git status --porcelain` to see changed files.
2. Stage changes using `git add --all`.
3. Review staged changes with `git diff --staged`.
4. **Analyze changes to determine type**:
   
   **Agent/AI-related changes** (use type `agent`):
   - Files in `.opencode/`, `AGENTS.md`, `mcp-servers.json`
   - Changes to prompts, AI commands, or MCP server configurations
   - Agent instructions, guidelines, or automation scripts
   
   **Regular changes** (use appropriate type):
   - Plugin specifications: `lua/dotvim/plugins/`
   - Core configs: `lua/dotvim/configs/`
   - Utilities: `lua/dotvim/commons/`
   - Features: `lua/dotvim/features/`
   - Tests: `tests/spec/`
   
5. Analyze the changes to understand:
   - **What** was modified (specific files, functions, components)
   - **Why** the change was made (purpose, goal, problem solved)
   - **Scope** of the change (single feature, multiple areas, breaking change)
   - **Impact** on users or functionality
   
6. Generate a commit message:
   - **Type**: Choose the most specific type (see types below)
     - If changes span multiple types, use the most significant one
     - If breaking changes exist, append "!" after type (e.g., `feat!`, `refactor!`)
   - **Summary**: Imperative mood, max 50 chars, describe the outcome
     - Focus on WHAT changed and WHY, not HOW
     - Be specific: "add LSP hover support" not "update LSP"
     - Start with a verb: "add", "fix", "update", "remove", "refactor"
   
7. Use `git-add-and-commit` to commit changes.

## Format

The commit message is ALWAYS a single line following this structure:

```
<type>[!]: <summary>
```

Where:
- `type`: One of the commit types listed below
- `!`: Optional, indicates breaking changes
- `summary`: Imperative verb phrase, max 50 characters, no period

### Examples

#### Agent/AI Changes

```
agent: add OpenCode commit command with smart type detection
```

```
agent: update codecompanion prompts for better code analysis
```

```
agent: configure MCP server for GitHub integration
```

#### Feature Changes

```
feat: add LSP semantic token highlighting support
```

```
feat: integrate blink-cmp with custom snippets
```

```
feat!: migrate from telescope to fzf-lua for search
```

#### Bug Fixes

```
fix: resolve null reference in lualine git component
```

```
fix: correct keybinding conflict in insert mode
```

#### Configuration Updates

```
config: optimize LSP client capabilities configuration
```

```
config: enable treesitter folding for Lua files
```

#### Refactoring

```
refactor: extract common LSP handlers to commons.lsp
```

```
refactor!: reorganize plugin specs by category
```

#### Documentation

```
docs: add examples for custom lualine components
```

```
docs: update AGENTS.md with plugin structure guidelines
```

## Best Practices

### General Guidelines
- Use present tense: "add" not "added"
- Use imperative mood: "fix" not "fixes" or "fixed"
- Don't end summary with a period
- Keep summary under 50 characters
- Be specific about what changed, not how it changed

### Type Selection Priority
1. **agent**: Always use for `.opencode/`, prompts, MCP servers
2. **feat**: New user-facing functionality or plugin additions
3. **fix**: Bug fixes that resolve incorrect behavior
4. **config**: Configuration changes that don't add features
5. **refactor**: Code restructuring without functional changes
6. **docs**: Only documentation changes

### Writing Effective Summaries
- ✅ Good: "add jump-to-definition for Lua LSP"
- ❌ Bad: "update LSP stuff"

- ✅ Good: "fix snippet expansion in markdown files"
- ❌ Bad: "fix bug"

- ✅ Good: "refactor keymaps to use lazy.nvim keys"
- ❌ Bad: "change keybindings"

### Handling Mixed Changes
If changes span multiple types:
1. Identify the PRIMARY purpose of the changes
2. Use the type that best represents that purpose
3. If changes are truly unrelated, consider splitting into multiple commits

## Commit Types

### Primary Types
- **agent**: Agent/AI-related changes (OpenCode, prompts, MCP, AI plugins)
- **feat**: New feature or plugin integration
- **fix**: Bug fix that corrects incorrect behavior
- **config**: Configuration updates (settings, options, keymaps)

### Secondary Types
- **refactor**: Code refactoring (improve structure, no functional change)
- **perf**: Performance improvements
- **style**: Code style/formatting changes (no logic change)
- **test**: Adding or updating tests
- **docs**: Documentation changes only

### Build/Maintenance Types
- **chore**: Maintenance tasks (dependencies, tooling)
- **build**: Build system changes (justfile, CI, nix)
- **ci**: CI/CD pipeline changes

### Breaking Changes
Add `!` after type for breaking changes:
- `feat!`: New feature that breaks existing functionality
- `refactor!`: Refactoring that changes public APIs
- `config!`: Config changes that require user action

