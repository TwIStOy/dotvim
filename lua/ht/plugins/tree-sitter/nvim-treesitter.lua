return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    build = function()
      if #vim.api.nvim_list_uis() ~= 0 then
        vim.api.nvim_command("TSUpdate")
      end
    end,
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSConfigInfo",
      "TSDisable",
      "TSEditQuery",
      "TSEditQueryUserAfter",
      "TSEnable",
      "TSInstall",
      "TSInstallFromGrammar",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSToggle",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "dockerfile",
        "dart",
        "fish",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "glimmer",
        "go",
        "graphql",
        "html",
        "javascript",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "php",
        "proto",
        "python",
        "regex",
        "rust",
        "scss",
        "svelte",
        "toml",
        "tsx",
        "twig",
        "typescript",
        "vim",
        "vue",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
        disable = function(lang, bufnr)
          if lang == "html" and vim.api.nvim_buf_line_count(bufnr) > 500 then
            return true
          end
          for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 3, false)) do
            if #line > 500 then
              return true
            end
          end
          return false
        end,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-=>",
          node_incremental = "<C-=>",
          scope_incremental = false,
          node_decremental = "<C-->",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
