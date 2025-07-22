local hint = [[
^ ^ _r_:  run current replace ^ ^
^ ^ _R_:  replace all ^ ^
^ ^ _t_:  toggle line ^ ^
^ ^ _dd_: delete line ^ ^
]]

return function()
  ---@type dotvim.extra.hydra.CreateHydraOpts
  return {
    name = "Specture",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = false,
      hint = {
        position = "bottom-right",
      },
      buffer = true,
    },
    body = "",
    heads = {
      r = {
        function()
          require("spectre.actions").run_current_replace()
        end,
        {
          desc = "run current replace",
          nowait = true,
          exit = false,
        },
      },
      R = {
        function()
          require("spectre.actions").run_replace()
        end,
        {
          desc = "replace all",
          nowait = true,
          exit = true,
        },
      },
      t = {
        function()
          require("spectre").toggle_line()
        end,
        {
          desc = "toggle line",
          nowait = true,
          exit = false,
        },
      },
      dd = {
        function()
          require("spectre.actions").run_delete_line()
        end,
        {
          desc = "delete line",
          nowait = true,
          exit = false,
        },
      },
    },
  }
end
