---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages.ui",
  deps = {
    "dora.packages.ui",
  },
  plugins = {
    {
      "colorful-winsep.nvim",
      enabled = function()
        return not vim.g.neovide
      end,
    },
    {
      "alpha-nvim",
      opts = function(_, opts)
        ---@type dora.lib
        local lib = require("dora.lib")

        ---@param sc string
        ---@param txt string|fun(): string
        ---@param callback string|fun():any
        ---@param bopts? table
        local function make_button(sc, txt, callback, bopts)
          bopts = bopts or {}
          local on_press = lib.func.normalize_callback(
            callback,
            vim.F.if_nil(bopts.feedkeys, true)
          )
          bopts = vim.tbl_extend("force", {
            position = "center",
            shortcut = sc,
            cursor = 3,
            width = 50,
            align_shortcut = "right",
            hl_shortcut = "Keyword",
            keymap = {
              "n",
              sc,
              "",
              {
                noremap = true,
                silent = true,
                nowait = true,
                callback = function()
                  on_press()
                end,
              },
            },
          }, bopts)
          return {
            type = "button",
            val = txt,
            on_press = bopts.keymap[4].callback,
            opts = bopts,
          }
        end

        table.insert(
          opts.layout[6].val,
          4,
          make_button("u", "󰚰  Update Plugins", ":Lazy update<CR>")
        )

        local function make_fortune_text()
          local stats = require("lazy").stats()
          return string.format(
            "󱐌 %d/%d plugins loaded in %dms",
            stats.loaded,
            stats.count,
            stats.startuptime
          )
        end

        local vault_dir = function()
          return vim.F.if_nil(
            lib.lazy.opts("obsidian.nvim").dir,
            vim.fn.expand("~/obsidian-data")
          )
        end

        if vim.uv.fs_stat(vault_dir()) then
          table.insert(
            opts.layout[6].val,
            5,
            make_button("t", "󱨰  Today Note", ":ObsidianToday<CR>")
          )
        end

        opts.layout[8].val = make_fortune_text
        opts.layout[8].opts.hl = "Function"
      end,
    },
  },
}
