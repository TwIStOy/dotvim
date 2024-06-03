local hint = [[
^ ^ _k_ ^ ^ ^      _<Up>_         ^ _?_: pick window
_h_ ^ ^ _l_ ^ _<Left>_ _<Right>_    ^ _s_: split horizontal
^ ^ _j_^ ^  ^     _<Down>_        ^ _v_: split vertical
^^focus ^^^ ^   _=_: equalize    ^ _<Esc>_: exit
]]

---@type dotvim.extra.hydra.CreateHydraOpts
return {
  name = "Window Related",
  hint = hint,
  config = {
    color = "amaranth",
    invoke_on_body = false,
    hint = {
      position = "bottom",
    },
  },
  mode = "n",
  body = "<c-w>",
  heads = {
    h = { "<C-w>h", { desc = "Move to the window on the left" } },
    j = { "<C-w>j", { desc = "Move to the window below" } },
    k = { "<C-w>k", { desc = "Move to the window above" } },
    l = { "<C-w>l", { desc = "Move to the window on the right" } },
    s = { "<C-w>s", { desc = "Split the window horizontally" } },
    v = { "<C-w>v", { desc = "Split the window vertically" } },
    ["<Down>"] = "5<C-w>-",
    ["<Up>"] = { "5<C-w>+", { desc = "j/k height" } },
    ["<Left>"] = { "5<C-w><" },
    ["<Right>"] = { "5<C-w>>", { desc = " h/l width" } },
    ["="] = { "<C-w>=", { desc = "Equalize window sizes" } },
    ["?"] = {
      function()
        local picked_window_id = require("window-picker").pick_window()
        if type(picked_window_id) == "number" then
          vim.api.nvim_set_current_win(picked_window_id)
        end
      end,
      { desc = "Pick a window", exit = true },
    },
    ["<Esc>"] = { nil, { exit = true } },
  },
}
