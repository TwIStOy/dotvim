---@module "dotvim.configs.fzf_lua"

-- FZF-lua specific configurations that need to be loaded after plugin setup
if not vim.g.vscode then
  local function setup_fzf_autocmds()
    local group = vim.api.nvim_create_augroup("FzfLuaConfig", { clear = true })
    
    -- Auto-close fzf when buffer is hidden
    vim.api.nvim_create_autocmd("BufHidden", {
      group = group,
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "fzf" then
          vim.cmd("close")
        end
      end,
    })
  end
  
  -- Set up autocmds for fzf-lua
  setup_fzf_autocmds()
end
