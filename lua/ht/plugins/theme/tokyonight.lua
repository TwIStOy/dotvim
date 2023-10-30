return {
  "folke/tokyonight.nvim",
  enabled = false,
  priority = 1000,
  opts = {
    style = "night",
    styles = {
      comments = { italic = true },
    },
    sidebars = {
      "qf",
      "help",
      "NvimTree",
      "Trouble",
      "mason",
      "lazy",
      "neo-tree",
    },
    hide_inactive_statusline = true,
    lualine_bold = false,
    on_highlights = function(hl, c)
      local prompt = "#2d3149"
      hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePromptNormal = {
        bg = prompt,
      }
      hl.TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePromptTitle = {
        bg = c.yellow,
        fg = prompt,
      }
      hl.TelescopePreviewTitle = {
        bg = c.yellow,
        fg = c.bg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.yellow,
        fg = c.bg_dark,
      }
      hl.LspInlayHint = {
        fg = c.comment,
      }
      hl["@lsp.typemod.variable.mutable.rust"] = { underline = true }
      hl["@lsp.typemod.selfKeyword.mutable.rust"] = { underline = true }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    -- load the colorscheme here
    vim.cmd([[colorscheme tokyonight]])
  end,
}
