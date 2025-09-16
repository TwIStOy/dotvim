-- Minimal helper to get the Tree‑sitter node at the current cursor position
local function _ts_node_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0) -- {line, col}, 1-based line
  local row = pos[1] - 1
  local col = pos[2]
  local ok_ts, _ = pcall(require, "nvim-treesitter")
  if not ok_ts then
    return nil, bufnr
  end
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  local parser = vim.treesitter.get_parser(bufnr, lang, { error = false })
  if not parser then
    return nil, bufnr
  end
  local tree = parser:parse()[1]
  if not tree then
    return nil, bufnr
  end
  local root = tree:root()
  if not root then
    return nil, bufnr
  end
  -- Use descendant_for_range (includes unnamed). Fallback to named descendant if needed.
  local node = root:descendant_for_range(row, col, row, col)
  if not node then
    node = root:named_descendant_for_range(row, col, row, col)
  end
  return node, bufnr
end

local function find_preproc_ifdef_from_cursor()
  local node, bufnr = _ts_node_at_cursor()
  if not node then
    return {}
  end

  local result = {}
  -- Climb the ancestor chain collecting preproc_ifdef nodes.
  while node do
    local node_type = node:type()
    if node_type == "preproc_ifdef" then
      -- Tree-sitter C uses a single node type 'preproc_ifdef' for both #ifdef and #ifndef.
      -- We detect which one by inspecting the source line text.
      local directive = "ifdef"
      local sr = node:start() -- start row (0-based)
      local line = vim.api.nvim_buf_get_lines(bufnr, sr, sr + 1, false)[1]
      if line and line:find("#ifndef") then
        directive = "ifndef"
      end
      local name_node
      -- Try field accessor first (some grammars expose a field named 'name').
      local by_field = node:field("name")
      if by_field and by_field[1] then
        name_node = by_field[1]
      else
        -- Fallback: scan children for identifier token.
        for child in node:iter_children() do
          if child:type() == "identifier" then
            name_node = child
            break
          end
        end
      end
      if name_node then
        local text = vim.treesitter.get_node_text(name_node, bufnr)
        if text and text ~= "" then
          -- Insert at the front so outermost ends up first after full traversal.
          -- We now distinguish between #ifdef and #ifndef returning a table entry.
          table.insert(result, 1, { directive = directive, macro = text })
        end
      end
    elseif node_type == "preproc_if" then
      -- Covers both #if and #elif (tree-sitter uses the same node type 'preproc_if').
      local sr = node:start()
      local line = vim.api.nvim_buf_get_lines(bufnr, sr, sr + 1, false)[1]
      local directive = "if"
      if line and line:find("#%s*elif") then
        directive = "elif"
      end
      local cond_field = node:field("condition")
      local expr = nil
      if cond_field and cond_field[1] then
        expr = vim.treesitter.get_node_text(cond_field[1], bufnr)
      end
      if expr and expr ~= "" then
        -- Normalize whitespace a bit.
        expr = expr:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
        table.insert(result, 1, { directive = directive, expr = expr })
      end
    end
    node = node:parent()
  end

  return result
end

return {
  find_preproc_ifdef_from_cursor = find_preproc_ifdef_from_cursor,
}
