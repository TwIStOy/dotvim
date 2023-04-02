local M = {}

vim.g.global_rime_enabled = false

local default_opts = {
  name = 'rime_ls',
  cmd = { 'rime_ls' },
  init_options = {
    enabled = false, -- 初始关闭, 手动开启
    shared_data_dir = "/usr/share/rime-data", -- rime 公共目录
    user_data_dir = "~/.local/share/rime-ls", -- 指定用户目录, 最好新建一个
    log_dir = "~/.local/share/rime-ls", -- 日志目录
    trigger_characters = {}, -- 为空表示全局开启
    schema_trigger_character = "&", --  当输入此字符串时请求补全会触发 “方案选单”
  },
}

function M.rime_state()
  if vim.g.global_rime_enabled then
    return "ㄓ"
  else
    return ""
  end
end

function M.setup()
  local configs = require('lspconfig.configs')
  if not configs.rime_ls then
    configs.rime_ls = {
      default_config = {
        name = "rime_ls",
        cmd = { 'rime_ls' },
        filetypes = { 'markdown', 'txt' },
        single_file_support = true,
      },
      settings = {},
      docs = {
        description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
      },
    }
  end
end

function M.attach(client, bufnr)
  local toggle_rime = function()
    client.request('workspace/executeCommand',
                   { command = "rime-ls.toggle-rime" },
                   function(_, result, ctx, _)
      if ctx.client_id == client.id then
        vim.g.global_rime_enabled = result
      end
    end)
  end

  local mapping = require 'ht.core.mapping'
  mapping.map({
    keys = { '<M-;>' },
    action = function()
      toggle_rime()
    end,
    mode = { 'n', 'i' },
    desc = 'rime-toggle',
  }, bufnr)

  if vim.api.nvim_buf_get_option(bufnr, 'ft') == 'markdown' then
    local toggle_markdown_code = function()
      if vim.g.previous_markdown_code ~= nil then
        if vim.g.previous_markdown_code ~= vim.g.global_rime_enabled then
          toggle_rime()
        end
        vim.g.previous_markdown_code = nil
      else
        vim.g.previous_markdown_code = vim.g.global_rime_enabled
        if vim.g.global_rime_enabled then
          toggle_rime()
        end
      end
    end
    mapping.map({
      keys = { '`' },
      action = function()
        toggle_markdown_code()
        vim.fn.feedkeys('`', 'n')
      end,
      mode = { 'i' },
    }, bufnr)
  end
end

return M
