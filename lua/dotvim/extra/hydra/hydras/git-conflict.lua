local hint = [[
  Git Conflict
  _b_: Choose both    _n_: Move to next conflict →
  _o_: Choose ours    _p_: Move to prev conflict ←
  _t_: Choose theirs  _q_: Exit
  _x_: Choose none
]]

---@type dotvim.extra.hydra.CreateHydraOpts
return {
  name = "Git conflict",
  color = "blue",
  hint = hint,
  config = {
    color = "pink",
    hint = {
      float_opts = {
        border = true,
      },
    },
  },
  heads = {
    b = {
      "<cmd>GitConflictChooseBoth<CR>",
      { desc = "choose both", exit = false },
    },
    x = {
      "<cmd>GitConflictChooseNone<CR>",
      { desc = "choose none", exit = true },
    },
    n = {
      "<cmd>GitConflictNextConflict<CR>",
      { desc = "move to next conflict", exit = false },
    },
    o = {
      "<cmd>GitConflictChooseOurs<CR>",
      { desc = "choose ours", exit = false },
    },
    p = {
      "<cmd>GitConflictPrevConflict<CR>",
      { desc = "move to prev conflict", exit = false },
    },
    t = {
      "<cmd>GitConflictChooseTheirs<CR>",
      { desc = "choose theirs", exit = false },
    },
    q = {
      nil,
      { exit = true, nowait = true, desc = "exit" },
    },
    ["<Esc>"] = {
      nil,
      { exit = true, nowait = true, desc = "exit" },
    },
  },
}
