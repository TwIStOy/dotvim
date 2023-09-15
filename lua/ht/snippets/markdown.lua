local UtilsTs = require("ht.utils.ts")
local sts = require("ht.snippets._treesitter")

local function resolve_metadata(_, line_to_cursor, match, captures)
  if vim.bo.filetype ~= "markdown" then
    return nil
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  print(row, col, buf)
  ---@param parser LanguageTree
  ---@param source number|string
  return sts.wrap_with_update_buffer(buf, match, function(parser, source)
    local pos = {
      row - 1,
      col - #match,
    }
    local node = parser:named_node_for_range { pos[1], pos[2], pos[1], pos[2] }
    if node == nil then
      return nil
    end
    local metadata_node = UtilsTs.find_first_parent(node, "minus_metadata")
    if metadata_node == nil then
      return nil
    end

    return {
      trigger = match,
      captures = captures,
      env_override = {
        IN_METADATA = true,
      },
    }
  end)
end

return function()
  local hs = require("ht.snippets.snippet")
  local snippet = hs.build_snippet
  local i = hs.insert_node
  local c = hs.choice_node

  local ls = require("luasnip")
  local t = ls.text_node
  local f = ls.function_node
  local sn = ls.snippet_node
  local d = ls.dynamic_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep
  local postfix = require("luasnip.extras.postfix").postfix
  local l = extras.lambda

  return {
    yaml = {
      snippet {
        "now!",
        name = "Now",
        mode = "wA",
        resolveExpandParams = resolve_metadata,
        nodes = {
          f(function(_, parent)
            return os.date("%Y-%m-%d %H:%M:%S")
          end, {}),
        },
      },
    },
  }
end
