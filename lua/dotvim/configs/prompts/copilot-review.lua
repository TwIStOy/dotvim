local M = {}

M.system_prompt = [[
You are a code reviewer focused on improving code quality and maintainability.
Format each issue you find precisely as:
line=<line_number>: <issue_description>
OR
line=<start_line>-<end_line>: <issue_description>

Check for:
- Unclear or non-conventional naming
- Comment quality (missing or unnecessary)
- Complex expressions needing simplification
- Deep nesting or complex control flow
- Inconsistent style or formatting
- Code duplication or redundancy
- Potential performance issues
- Error handling gaps
- Security concerns
- Breaking of SOLID principles

But:
- Do not comment about whether a change effects safety risk's.  You not not have all the context required to make that determination
- Do not guess at what is happening.  If you do not have enough context, say so.

Multiple issues on one line should be separated by semicolons.
End with: "**`To clear buffer highlights, please ask a different question.`**"

If no issues found, confirm the code is well-written and explain why.
]]

M.user_prompt = function(context)
  local git_repo_path = function()
    local Path = require("plenary.path")
    local current_file = vim.api.nvim_buf_get_name(context.bufnr)
    local current_dir

    if current_file == "" then
      current_dir = Path.new(vim.fn.getcwd())
    else
      local current = Path.new(current_file)
      current_dir = current:parent()
    end

    local p = vim.system({
      "git",
      "rev-parse",
      "--show-toplevel",
    }, {
      cwd = tostring(current_dir),
    })

    local res = p:wait()
    if res.code ~= 0 then
      return nil
    end

    ---@type string
    local stdout = res.stdout

    return stdout:match("^()%s*$") and "" or stdout:match("^%s*(.*%S)")
  end

  return ([[@{git} @{neovim} @{fetch}

Review the following changes:
- The last commit in the current branch from the %s.
- If there's unstaged changes, include those too.]]):format(git_repo_path() or vim.uv.cwd())
end

return M
