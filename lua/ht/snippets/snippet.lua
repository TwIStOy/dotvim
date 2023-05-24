local luasnip = require("luasnip")
local snip_cond = require("ht.snippets.conditions.conditions")

local function build_snippet(opts)
  local trig = opts[1]
  local name = opts.name or trig
  local dscr = opts.dscr or ("Snippet: " .. name)
  local mode = opts.mode or ""
  local wordTrig = mode:match("w") ~= nil
  local regTrig = mode:match("r") ~= nil
  local hidden = mode:match("h") ~= nil
  local snippetType = mode:match("A") ~= nil and "autosnippet" or "snippet"
  local nodes = opts.nodes
  local priority = opts.priority or nil

  local cond = opts.cond or nil

  if mode:match("b") ~= nil then
    local line_begin = snip_cond.at_line_begin(trig)
    cond = cond and (cond + line_begin) or line_begin
  end
  local trig_arg = {
    trig = trig,
    name = name,
    dscr = dscr,
    workTrig = wordTrig,
    regTrig = regTrig,
    hidden = hidden,
    priority = priority,
    snippetType = snippetType,
    condition = cond and cond.condition,
    show_condition = cond and cond.show_condition,
  }
  return luasnip.s(trig_arg, nodes)
end

local function build_simple_word_snippet(word, expanded)
  return build_snippet {
    word,
    name = expanded,
    dscr = expanded,
    mode = "w",
    nodes = luasnip.text_node(expanded),
  }
end

---@param idx number
---@param placeholder? string
---@param opts? table
local function insert_node(idx, placeholder, opts)
  if idx == 0 then
    return luasnip.insert_node(idx)
  end
  opts = opts or {}
  local extra_opts = {
    node_ext_opts = {
      active = {
        virt_text = {
          {
            " " .. idx .. ": " .. (opts.desc or placeholder or "insert"),
            "Comment",
          },
        },
      },
    },
  }
  opts = vim.tbl_extend("keep", opts, extra_opts)
  return luasnip.insert_node(idx, placeholder, opts)
end

---@param idx number
---@param choices table
---@param opts? table
local function choice_node(idx, choices, opts)
  opts = opts or {}
  local extra_opts = {
    node_ext_opts = {
      active = {
        virt_text = {
          { " " .. idx .. ": " .. (opts.desc or "choice"), "Comment" },
        },
      },
    },
  }
  opts = vim.tbl_extend("keep", opts, extra_opts)
  return luasnip.choice_node(idx, choices, opts)
end

return {
  build_snippet = build_snippet,
  quick_expand = build_simple_word_snippet,
  insert_node = insert_node,
  choice_node = choice_node,
}
