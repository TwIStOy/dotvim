local hint = [[
^^ _l_: increase width ^^
^^ _h_: decrease width ^^

^^ _L_: next open window ^^
^^ _H_: prev open window ^^

^^ _j_: next loaded window ^^
^^ _k_: prev loaded window ^^

^^ _J_: increase height ^^
^^ _K_: decrease height ^^
^^ _=_: reset all custom sizing ^^

^^ _<c-q>_: hide  ^^
^^ _q_: quit  ^^
^^ _Q_: close ^^

^^ _<esc>_: quit Hydra ^^
]]

return function(win)
  ---@type dotvim.extra.hydra.CreateHydraOpts
  return {
    name = "Edgy",
    hint = hint,
    config = {
      color = "teal",
      invoke_on_body = true,
      hint = {
        position = "bottom-right",
      },
    },
    heads = {
      {
        "<c-q>",
        function()
          win:hide()
        end,
        { exit = true },
      },
      {
        "Q",
        function()
          win.view.edgebar:close()
        end,
        { exit = true },
      },
      {
        "<esc>",
        nil,
        { exit = true, desc = "quit" },
      },
      {
        "q",
        function()
          win:close()
        end,
        { exit = true },
      },

      -- next open window
      {
        "L",
        function()
          win:next { visible = true, focus = true }
        end,
      },
      -- previous open window
      {
        "H",
        function()
          win:prev { visible = true, focus = true }
        end,
      },
      -- next loaded window
      {
        "j",
        function()
          win:next { pinned = false, focus = true }
        end,
      },
      -- prev loaded window
      {
        "k",
        function()
          win:prev { pinned = false, focus = true }
        end,
      },
      -- increase width
      {
        "l",
        function()
          win:resize("width", 2)
        end,
      },
      -- decrease width
      {
        "h",
        function()
          win:resize("width", -2)
        end,
      },
      -- increase height
      {
        "J",
        function()
          win:resize("height", 2)
        end,
      },
      -- decrease height
      {
        "K",
        function()
          win:resize("height", -2)
        end,
      },
      -- reset all custom sizing
      {
        "=",
        function()
          win.view.edgebar:equalize()
        end,
        { exit = true, desc = "equalize" },
      },
    },
  }
end
