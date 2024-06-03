local hint = [[
 Adjust window size^^^^^^
 ^ ^ _k_ ^ ^
 _h_ ^ ^ _l_
 ^ ^ _j_ ^ ^   _<CR>_ or _<Esc>_ to exit
]]

---@type dotvim.extra.hydra.CreateHydraOpts
return {
  name = "Adjust Window Size",
  hint = hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      float_opts = {
        border = "rounded",
      },
    },
    on_enter = function()
      vim.o.virtualedit = "all"
    end,
  },
  mode = "n",
  body = "<leader>ws",
  heads = {
    k = "5<C-w>-",
    j = { "5<C-w>+", { desc = "j/k height" } },
    h = { "5<C-w><" },
    l = { "5<C-w>>", { desc = " h/l width" } },
    ["<Esc>"] = { nil, { exit = true } },
    ["<CR>"] = { nil, { exit = true } },
  },
}
