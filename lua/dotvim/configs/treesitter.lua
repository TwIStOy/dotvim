require("nvim-treesitter").install {
  "astro",
  "bash",
  "cmake",
  "css",
  "cpp",
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
  "idl",
  "ini",
  "java",
  "javascript",
  "just",
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
  "pidl",
  "proto",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "svelte",
  "thrift",
  "tsx",
  "twig",
  "typescript",
  "vim",
  "vue",
}

if not not vim.g.vscode then
  return
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    local parser = vim.treesitter.get_parser(ev.buf, lang, { error = false })
    if parser ~= nil then
      vim.treesitter.start()
    end
  end,
})
