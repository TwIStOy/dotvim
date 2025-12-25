---@type LazyPluginSpec
return {
  "nvim-pack/nvim-spectre",
  cmd = { "Spectre" },
  opts = function()
    return {
      mapping = {
        ["toggle_line"] = {
          cmd = false,
        },
        ["send_to_qf"] = {
          cmd = false,
        },
        ["run_current_replace"] = {
          cmd = false,
        },
        ["run_replace"] = {
          cmd = false,
        },
      },
      find_engine = {
        ["rg"] = {
          cmd = dv.which("rg"),
        },
        ["ag"] = {
          cmd = dv.which("ag"),
        },
      },
      replace_engine = {
        ["sed"] = {
          cmd = dv.which("sed"),
        },
        ["oxi"] = {
          cmd = dv.which("oxi"),
        },
        ["sd"] = {
          cmd = dv.which("sd"),
        },
      },
      live_update = true,
    }
  end,
  config = true,
}
