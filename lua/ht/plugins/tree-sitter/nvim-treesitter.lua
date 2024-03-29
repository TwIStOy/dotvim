local Const = require("ht.core.const")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    allow_in_vscode = true,
    lazy = true,
    dependencies = {
      "IndianBoy42/tree-sitter-just",
    },
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
        "cpp",
        "css",
        "dart",
        "diff",
        "dockerfile",
        "dot",
        "ebnf",
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
        "http",
        "ini",
        "java",
        "javascript",
        "json",
        "jsonc",
        "jsonnet",
        "just",
        "latex",
        "llvm",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "matlab",
        "ninja",
        "nix",
        "pascal",
        "perl",
        "php",
        "proto",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "svelte",
        "swift",
        "thrift",
        "toml",
        "tsx",
        "twig",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },
      indent = {
        enable = false,
      },
      highlight = {
        enable = not Const.in_vscode,
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
      local parser = require("nvim-treesitter.parsers").get_parser_configs()
      parser.dart = {
        install_info = {
          url = "https://github.com/UserNobody14/tree-sitter-dart",
          files = { "src/parser.c", "src/scanner.c" },
          revision = "8aa8ab977647da2d4dcfb8c4726341bee26fbce4",
        },
      }
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
