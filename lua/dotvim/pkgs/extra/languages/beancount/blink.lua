local format_completion_item = function(line)
  local parts = vim.split(line, " ", { trimempty = true })
  parts = vim.tbl_filter(function(part)
    return part ~= ""
  end, parts)
  local label = parts[1]

  if #parts < 2 then
    return nil
  end

  return {
    label = label,
    label_description = parts[2],
    label_details = parts[2],
    kind = vim.lsp.protocol.CompletionItemKind.Field,
    insertText = label,
    source_id = "beancount",
    source_name = "Beancount",
  }
end

local function get_accounts(context, callback)
  local path = vim.fn.expand("%:p:h")
  local root = vim
    .system({ "git", "rev-parse", "--show-toplevel" }, {
      cwd = path,
    })
    :wait()
  if root.code ~= 0 then
    return
  end
  local root_path = vim.trim(root.stdout)
  local main_file = root_path .. "/main.bean"
  local parts = {}
  vim.system({
    "bean-report",
    "-q",
    main_file,
    "accounts",
  }, {
    cwd = root_path,
    text = true,
    stdout = function(err, data)
      if data ~= nil then
        parts[#parts + 1] = data
        return
      end
      if err ~= nil then
        return
      end
      local lines = vim.split(table.concat(parts, ""), "\n")
      local skip_line = true
      local results = {}
      for _, line in ipairs(lines) do
        if skip_line then
          skip_line = false
        else
          local item = format_completion_item(line)
          if item ~= nil then
            results[#results + 1] = item
          end
        end
      end
      callback {
        is_incomplete_forward = false,
        is_incomplete_backward = false,
        items = results,
      }
    end,
  })
end

local source = {}

function source:new()
  return setmetatable({}, { __index = source })
end

function source.get_trigger_characters()
  return {
    "Ex",
    "In",
    "As",
    "Li",
    "Eq",
    "E:",
    "I:",
    "A:",
    "L:",
    "#",
    "^",
  }
end

function source:get_completions(context, callback)
  get_accounts(context, callback)
end

function source:enabled()
  if vim.bo.filetype ~= "beancount" then
    return false
  end
  return true
end

return source
