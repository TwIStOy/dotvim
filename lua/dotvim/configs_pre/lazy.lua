---@param plug string
---@return string
local function get_installed_plugin_path(plug)
  return _G["dotvim_lazyroot"] .. "/" .. plug
end

local function git_exists(path)
  return vim.fn.isdirectory(path .. "/.git") == 1
end

local function git_clean(path)
  if not git_exists(path) then
    return
  end
  vim.fn.system { "git", "-C", path, "reset", "--hard" }
end

local function clean_plugin(name)
  local path = get_installed_plugin_path(name)
  if vim.fn.isdirectory(path) ~= 1 then
    return
  end
  git_clean(path)
end

local lazy_group =
  vim.api.nvim_create_augroup("DotVimLazyPre", { clear = true })

local plugins_to_clean = { "blink.cmp", "blink.pairs" }

vim.api.nvim_create_autocmd("User", {
  group = lazy_group,
  pattern = { "LazyCheckPre", "LazyUpdatePre", "LazySyncPre" },
  callback = function()
    for _, plugin in ipairs(plugins_to_clean) do
      clean_plugin(plugin)
    end
  end,
})
