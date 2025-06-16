---@module "dotvim.plugins.edit"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.comment",
    enabled = not vim.g.vscode,
    version = false,
    opts = {},
    keys = { "gcc", "gc" },
  },
  {
    "mfussenegger/nvim-lint",
    enabled = not vim.g.vscode,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      linters_by_ft = {},
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft

      local used_linters = {}
      for _, linter in pairs(opts.linters_by_ft) do
        if type(linter) == "string" then
          used_linters[#used_linters + 1] = linter
        else
          for _, l in pairs(linter) do
            used_linters[#used_linters + 1] = l
          end
        end
      end

      for _, name in pairs(used_linters) do
        local linter = require("lint").linters[name]
        if linter == nil then
          error("Linter " .. linter .. " not found")
        end
        local exe = dv.which(linter.cmd)
        if exe ~= nil then
          linter.cmd = dv.which(linter.cmd)
        end
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    opts = {
      close = {
        map = "<C-0>",
        cmap = "<C-0>",
      },
      tabout = {
        hopout = true,
      },
      fastwarp = {
        enable = true,
        map = "<C-=>",
        rmap = "<C-->",
        cmap = "<C-=>",
        crmap = "<C-->",
        enable_normal = true,
        enable_reverse = true,
        hopout = false,
        multiline = true,
        nocursormove = true,
        no_nothing_if_fail = false,
      },
      config_internal_pairs = {
        {
          '"',
          '"',
          suround = true,
          cond = function(fn, o)
            -- vim
            if
              fn.get_ft() == "vim"
              and (
                o.line:sub(1, o.col - 1):match("^%s*$") ~= nil
                or o.line:sub(o.col - 1, o.col - 1) == "@"
              )
            then
              return false
            end

            -- luasnip-snippets expands `#"` in cpp
            if
              fn.get_ft() == "cpp"
              and o.line:sub(1, o.col - 1):match("^%s*#$") ~= nil
            then
              return false
            end

            return true
          end,
          multiline = false,
        },
      },
    },
  },
}
