local profile_started = false

vim.api.nvim_create_user_command("StartProfile", function()
  require("plenary.profile").start("/tmp/profile.log", { flame = true })
  profile_started = true
end, {})

vim.api.nvim_create_user_command("StopProfile", function()
  require("plenary.profile").stop()
  profile_started = false
end, {})

vim.api.nvim_create_user_command("ToggleProfile", function()
  if profile_started then
    vim.cmd("StopProfile")
  else
    vim.cmd("StartProfile")
  end
end, {})
