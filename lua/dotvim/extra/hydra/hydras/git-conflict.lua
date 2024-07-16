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
    invoke_on_body = false,
  },
  body = "<leader>v",
  heads = {
    b = {
      "<cmd>GitConflictChooseBoth<CR>",
      { desc = "conflict - choose both", exit = false },
    },
    x = {
      "<cmd>GitConflictChooseNone<CR>",
      { desc = "conflict - choose none", exit = true },
    },
    n = {
      "<cmd>GitConflictNextConflict<CR>",
      { desc = "conflict - move to next", exit = false },
    },
    o = {
      "<cmd>GitConflictChooseOurs<CR>",
      { desc = "conflict - choose ours", exit = false },
    },
    p = {
      "<cmd>GitConflictPrevConflict<CR>",
      { desc = "conflict - move to prev", exit = false },
    },
    t = {
      "<cmd>GitConflictChooseTheirs<CR>",
      { desc = "conflict - choose theirs", exit = false },
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
