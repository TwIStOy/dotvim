---@type dotvim.extra.hydra.CreateHydraOpts
return {
  body = "<leader>bb",
  mode = "n",
  config = {
    color = "red",
    hint = {
      type = "window",
      position = { "middle" },
      show_name = true,
    },
    invoke_on_body = true,
  },
  heads = {
    l = {
      function()
        vim.cmd("BufferLineCycleNext")
      end,
      { private = true, nowait = true, desc = "Next Buffers", exit = false },
    },
    h = {
      function()
        vim.cmd("BufferLineCyclePrev")
      end,
      { private = true, nowait = true, desc = "Prev Buffers", exit = false },
    },
    p = {
      function()
        vim.cmd("BufferLineTogglePin")
      end,
      { private = true, nowait = true, desc = "Pin Buf" },
    },
    ["-"] = {
      function()
        vim.cmd("BufferLineMovePrev")
      end,
      { private = true, nowait = true, desc = "Move Prev", exit = false },
    },
    ["="] = {
      function()
        vim.cmd("BufferLineMoveNext")
      end,
      { private = true, nowait = true, desc = "Move Next", exit = false },
    },
    ["1"] = {
      function()
        vim.cmd("BufferLineSortByTabs")
      end,
      { private = true, nowait = true, desc = "Sort Tabs" },
    },
    ["2"] = {
      function()
        vim.cmd("BufferLineSortByDirectory")
      end,
      { private = true, nowait = true, desc = "Sort Dir" },
      -- { private = true, nowait = true, desc = "Sort dir", exit = true },
    },
    ["3"] = {
      function()
        vim.cmd("BufferLineSortByRelativeDirectory")
      end,
      { private = true, nowait = true, desc = "Sort RDir" },
    },
  },
}
