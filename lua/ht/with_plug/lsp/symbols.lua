local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")

local lsp_type_highlight = {
  ["Class"] = "Structure",
  ["Constant"] = "String",
  ["Field"] = "TelescopeResultsField",
  ["Function"] = "@property",
  ["Method"] = "Function",
  ["Property"] = "@property",
  ["Struct"] = "Structure",
  ["Variable"] = "@parameter",
}

local function entry_maker(opts)
  opts = opts or {}
  local display_items = {
    { width = vim.F.if_nil(opts.fname_width, 30) }, -- path
    { width = opts.symbol_width or 25 }, -- text
    { remaining = true }, -- kind
  }

  local displayer = entry_display.create {
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = display_items,
  }

  local make_display = function(entry)
    return displayer {
      utils.transform_path(opts, entry.filename),
      entry.text,
      { entry.kind:lower(), lsp_type_highlight[entry.kind] },
    }
  end

  return function(entry)
    local prefix = entry.from_prefix or ""
    local res = {
      display = make_display,
      ordinal = prefix .. entry.text,
    }
    res = vim.tbl_extend("error", res, entry)
    return res
  end
end

---@param opts ht.lsp.WorkspaceAndDocumentSymbolsOptions?
local function top_level_workspace_and_document_symbols(opts)
  local CoreLsp = require("ht.core.lsp")

  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  local all_items = {}
  local wg = require("ht.utils.waiting_group"):new(function()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    pickers
      .new(opts, {
        prompt_title = "LSP Top-level Workspace / Document Symbols",
        finder = finders.new_table {
          results = all_items,
          entry_maker = entry_maker(opts),
        },
        previewer = conf.qflist_previewer(opts),
        sorter = conf.generic_sorter(opts),
      })
      :find()
  end)
  wg:wait(
    "textDocument/documentSymbol",
    vim.lsp.buf_request_all(
      opts.bufnr,
      "textDocument/documentSymbol",
      vim.lsp.util.make_position_params(opts.winnr),
      function(results)
        for _, result in pairs(results) do
          if result.error then
            vim.api.nvim_err_writeln(
              "Error when finding document symbols: " .. result.error.message
            )
            wg:fail("textDocument/documentSymbol")
            return
          end
          local items = CoreLsp.utils.symbols_to_items(
            result.result or {},
            opts.bufnr,
            {
              extra = {
                from_prefix = "@",
              },
              depth = 4,
            }
          ) or {}
          all_items = vim.list_extend(all_items, items)
        end
        wg:finish("textDocument/documentSymbol")
      end
    )
  )
  wg:wait(
    "workspace/symbol",
    vim.lsp.buf_request_all(
      opts.bufnr,
      "workspace/symbol",
      { query = opts.query or "" },
      function(results)
        for _, result in pairs(results) do
          if result.error then
            vim.api.nvim_err_writeln(
              "Error when finding workspace symbols: " .. result.error.message
            )
            wg:fail("workspace/symbol")
            return
          end
          local items = CoreLsp.utils.symbols_to_items(
            result.result or {},
            opts.bufnr,
            {
              extra = {
                from_prefix = "#",
              },
            }
          ) or {}
          all_items = vim.list_extend(all_items, items)
        end
        wg:finish("workspace/symbol")
      end
    )
  )
end

return {
  top_level_workspace_and_document_symbols = top_level_workspace_and_document_symbols,
}
