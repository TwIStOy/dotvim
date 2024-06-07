return {
  name = "Just Test",
  builder = function()
    return {
      cmd = { "just" },
      args = { "test" },
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
  ---@type overseer.SearchCondition
  condition = {
    callback = function(s)
      local _shared = require("overseer.template.dotvim._shared")
      return _shared.just_summary(s) ~= nil, s.dir
    end,
  },
}
