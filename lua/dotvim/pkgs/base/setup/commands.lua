return function()
  vim.api.nvim_create_user_command("StartProfile", function()
    require("plenary.profile").start("/tmp/profile.log", { flame = true })
  end, {})

  vim.api.nvim_create_user_command("StopProfile", function()
    require("plenary.profile").stop()
  end, {})
end
