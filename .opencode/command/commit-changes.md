---
description: Create commit base on current changes
agent: build
---

Generate clear, conventional commit messages following best practices.

## Instructions

Follow these steps to create a well-structured commit message:

1. Run `git status --porcelain` to see changed files.
2. Stage changes using `git add --all`.
3. Review staged changes with `git diff --staged`.
4. Analyze the changes to understand:
   - What was modified (files, functions, components)
   - Why the change was made (purpose, goal)
   - Impact of the change
5. Generate a commit message with:
   - **Type**: feat, fix, docs, style, refactor, test, chore, etc. If there are
     breaking changes, append "!" after the type (e.g., feat!, fix!).
   - **Summary**: imperative mood, max 50 characters
6. Use `git-add-and-commit` to commit changes.

## Format

The commit message is ALWAYS a single line and should follow this structure:

```
<type>: <summary>
```

### Examples

#### Example 1: Feature
```
feat: add JWT token refresh mechanism
```

#### Example 2: Bug fix
```
fix: handle null values in user profile endpoint
```

#### Example 3: Documentation
```
docs: update installation instructions
```

## Best Practices

- Use present tense ("add feature" not "added feature")
- Don't end summary with a period
- Explain **what** and **why**, not **how**
- Use imperative mood ("fix" not "fixes" or "fixed")

## Commit Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no logic change)
- **refactor**: Code refactoring (no feature or bug fix)
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks (dependencies, config)
- **ci**: CI/CD changes
- **build**: Build system changes

