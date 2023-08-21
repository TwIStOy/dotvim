local UtilsTs = require("ht.utils.ts")
local UtilsTbl = require("ht.utils.table")
local ysera = require("ysera")
local sts = require("ht.snippets._treesitter")

local ls = require("luasnip")
local t = ls.text_node
local f = ls.function_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local ms = ls.multi_snippet
local rep = extras.rep
local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local i = ht_snippet.insert_node
local c = ht_snippet.choice_node

local header_ext = {
  "hh",
  "h",
  "hpp",
  "hxx",
  "h++",
  "inl",
  "ipp",
  "tcc",
}

local argument_node_types = {
  "argument_list",
  "parameter_list",
}

local function_body_node_types = {
  "function_definition",
  "lambda_expression",
  "field_declaration",
}

local class_body_node_types = {
  "struct_specifier",
  "class_specifier",
}

---@param node TSNode?
---@return { [1]: number, [2]: number }?
local function start_pos(node)
  if node == nil then
    return nil
  end
  local start_row, start_col, _, _ = vim.treesitter.get_node_range(node)
  return { start_row, start_col }
end

local function in_header_file()
  local ext = vim.fn.expand("%:e")
  if vim.list_contains(header_ext, ext) then
    return true
  end
  return false
end

local lambda_snippet_node = sn(
  nil,
  fmta(
    [[
    [this, &](<>) <> {
      <>
    }
    ]],
    {
      i(2),
      c(1, {
        t("mutable"),
        t(""),
      }),
      i(0),
    }
  )
)

local function make_function_snippet_node(env)
  local fmt_args = {
    body = i(0),
    inline_inline = t(""),
  }
  local storage_specifiers = {
    "",
    "static ",
  }
  if not env.CPP_IN_HEADER_FILE then
    storage_specifiers[#storage_specifiers + 1] = "inline "
    storage_specifiers[#storage_specifiers + 1] = "static inline "
  else
    fmt_args.inline_inline = t("inline ")
  end

  local specifiers = {
    "",
    " noexcept",
  }
  if env.CPP_IN_CLASS_BODY then
    specifiers[#specifiers + 1] = " const"
    specifiers[#specifiers + 1] = " const noexcept"
  end
  fmt_args.storage_specifier = c(
    1,
    UtilsTbl.list_map(storage_specifiers, function(ss)
      return t(ss)
    end),
    { desc = "storage specifier" }
  )
  fmt_args.ret = i(2, "auto", { desc = "return type" })
  fmt_args.name = i(3, "name", { desc = "function name" })
  fmt_args.args = i(4, "args", { desc = "function arguments" })
  fmt_args.specifier = c(
    5,
    UtilsTbl.list_map(specifiers, function(ss)
      return t(ss)
    end),
    { desc = "specifier" }
  )
  return sn(
    nil,
    fmta(
      [[
      <storage_specifier><inline_inline>auto <name>(<args>)<specifier> ->> <ret> {
        <body>
      }
      ]],
      fmt_args
    )
  )
end

local ctor_tpls = {
  ctor = {
    name = "Constructor",
    tpl = [[
      <cls>() = default;
    ]],
  },
  dtor = {
    name = "Destructor",
    tpl = [[
      ~<cls>() = default;
    ]],
  },
  ["cp!"] = {
    name = "Copy constructor",
    tpl = [[
      <cls>(const <cls>& rhs) = default;
    ]],
  },
  ["mv!"] = {
    name = "Move constructor",
    tpl = [[
      <cls>(<cls>&& rhs) = default;
    ]],
  },
  ["ncp!"] = {
    name = "Disallow copy",
    tpl = [[
      <cls>(const <cls>&) = delete;
    ]],
  },
  ["nmv!"] = {
    name = "Disallow move",
    tpl = [[
      <cls>(<cls>&&) = delete;
    ]],
  },
  ["ncm!"] = {
    name = "Disallow both copy and move",
    tpl = [[
      <cls>(const <cls>&) = delete;
      <cls>(<cls>&&) = delete;
    ]],
  },
}

return {
  snippet {
    "in!",
    name = "if (...find)",
    dscr = "Find a member exists in map-like object.",
    mode = "bwh", -- line begin, word, hidden
    nodes = fmta(
      [[
      if (auto it = <object>.find(<key>); it != <object_r>.end()) {
        <body>
      }
      ]],
      {
        object = i(1, "Object"),
        object_r = rep(1),
        key = i(2, "Key"),
        body = i(0),
      }
    ),
  },

  snippet {
    "notin!",
    name = "if (...not find)",
    dscr = "Find a member not exists in map-like object.",
    mode = "bwh", -- line begin, word, hidden
    nodes = fmta(
      [[
      if (auto it = <object>.find(<key>); it == <object_r>.end()) {
        <body>
      }
      ]],
      {
        object = i(1, "Object"),
        object_r = rep(1),
        key = i(2, "Key"),
        body = i(0),
      }
    ),
  },

  function()
    local triggers = {}
    for k, v in pairs(ctor_tpls) do
      triggers[#triggers + 1] = {
        trig = k,
        name = v.name,
      }
    end

    triggers.common = {
      wordTrig = true,
      trigEngine = "plain",
      hidden = true,
      resolveExpandParams = function(_, line_to_cursor, match, captures)
        -- check if at the line begin
        if not line_to_cursor:sub(1, -(#match + 1)):match("^%s*$") then
          return nil
        end

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local buf = vim.api.nvim_get_current_buf()
        return sts.wrap_with_update_buffer(buf, match, function(parser, source)
          local pos = {
            row - 1,
            col - #match,
          }
          local node = parser:named_node_for_range {
            pos[1],
            pos[2],
            pos[1],
            pos[2],
          }

          local class_node =
            UtilsTs.find_first_parent(node, class_body_node_types)
          if class_node == nil then
            return nil
          end

          local name = class_node:field("name")
          if name == nil or #name == 0 then
            return nil
          end

          name = name[1]
          local ret = {
            trigger = match,
            captures = captures,
            env_override = {
              CLASS_NAME = vim.treesitter.get_node_text(name, source),
            },
          }
          return ret
        end)
      end,
    }
    return ms(
      triggers,
      d(1, function(_, parent)
        local env = parent.env
        local tpl = vim.F.if_nil(ctor_tpls[parent.trigger], {})
        tpl = vim.F.if_nil(tpl.tpl, "")
        return sn(
          nil,
          fmta(tpl, {
            cls = t(env.CLASS_NAME),
          })
        )
      end, {})
    )
  end,

  snippet {
    "fn",
    name = "Define a function/lambda",
    dscr = "Define a function/lambda",
    mode = "w",
    resolveExpandParams = function(_, _, match, captures)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local buf = vim.api.nvim_get_current_buf()
      return sts.wrap_with_update_buffer(buf, match, function(parser, _)
        local pos = {
          row - 1,
          col - #match,
        }
        local node = parser:named_node_for_range {
          pos[1],
          pos[2],
          pos[1],
          pos[2],
        }

        local ret = {
          trigger = match,
          capture = captures,
          env_override = {
            CPP_IN_ARGUMENT = start_pos(
              UtilsTs.find_first_parent(node, argument_node_types)
            ),
            CPP_IN_FUNCTION_BODY = start_pos(
              UtilsTs.find_first_parent(node, function_body_node_types)
            ),
            CPP_IN_CLASS_BODY = start_pos(
              UtilsTs.find_first_parent(node, class_body_node_types)
            ),
            CPP_IN_HEADER_FILE = in_header_file(),
          },
        }

        vim.api.nvim_win_set_cursor(0, { row, col })
        return ret
      end)
    end,
    nodes = d(1, function(_, parent)
      local env = parent.env
      local last_type, last_type_row, last_type_col
      local keys = {
        "CPP_IN_ARGUMENT",
        "CPP_IN_FUNCTION_BODY",
        "CPP_IN_CLASS_BODY",
      }
      for _, key in ipairs(keys) do
        if env[key] ~= nil then
          if last_type == nil then
            last_type = key
            last_type_row = env[key][1]
            last_type_col = env[key][2]
          else
            if
              last_type_row < env[key][1]
              or (last_type_row == env[key][1] and last_type_col < env[key][2])
            then
              last_type = key
              last_type_row = env[key][1]
              last_type_col = env[key][2]
            end
          end
        end
      end

      if
        last_type == "CPP_IN_ARGUMENT" or last_type == "CPP_IN_FUNCTION_BODY"
      then
        return lambda_snippet_node
      else
        return make_function_snippet_node(env)
      end
    end, {}),
  },
}

