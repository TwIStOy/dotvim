local utils = require("dotvim.configs.lualine_components.utils")
local Commons = require("dotvim.commons")

-- Component: Copilot status indicator
local function create_component()
  local spinners = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
  }
  local normal_icon = " "
  local disable_icon = " "
  local warning_icon = " "
  local sleeping_icon = "󰒲 "

  local function hl_fg(name)
    local hl = vim.api.nvim_get_hl(0, {
      name = name,
      link = false,
    })
    local fg = hl.fg
    if fg ~= nil and fg ~= "" then
      return string.format("#%x", fg)
    end
    return ""
  end

  local function is_enabled()
    -- Check if Copilot LSP client is attached to the current buffer
    local clients = vim.lsp.get_clients { bufnr = 0 }
    for _, client in ipairs(clients) do
      if client.name == "copilot" then
        return true
      end
    end
    return false
  end

  ---@return 'Disabled' | 'Error' | 'InProgress' | 'Sleeping' | 'Normal'
  local function copilot_status()
    if not is_enabled() then
      return "Disabled"
    end

    -- Use the global getter function that doesn't trigger notifications
    local status = ""
    if _G.dotvim_copilot_get_status then
      status = _G.dotvim_copilot_get_status()
    end

    -- Map status values
    if status == "Warning" or status == "Error" then
      return "Error"
    elseif status == "InProgress" or status == "Processing" then
      return "InProgress"
    elseif status == "Normal" or status == "Enabled" then
      -- Check for sleeping/idle
      local suggestion_ok, suggestion = pcall(require, "copilot.suggestion")
      if suggestion_ok and suggestion.is_auto_trigger and not suggestion.is_auto_trigger() then
        return "Sleeping"
      end
      return "Normal"
    elseif status == "Disabled" then
      return "Disabled"
    elseif status == "Idle" or status == "Sleeping" then
      return "Sleeping"
    end
    return "Normal"
  end

  local component = require("lualine.component"):extend()
  local highlight = require("lualine.highlight")
  local spinner_count = 1

  function component:init(options)
    component.super:init(options)
    
    self.error_hl = highlight.create_component_highlight_group({
      {
        fg = hl_fg("DiagnosticError"),
      },
    }, "copilot_lualine_error", options)
    
    self.in_progress_hl = highlight.create_component_highlight_group({
      {
        fg = hl_fg("DiagnosticHint"),
      },
    }, "copilot_lualine_in_progress", options)
    
    self.sleeping_hl = highlight.create_component_highlight_group({
      {
        fg = hl_fg("Comment"),
      },
    }, "copilot_lualine_sleeping", options)
    
    self.current_icon = spinners[1]
  end

  local update_status = Commons.fn.throttle(1000, function(self)
    local status = copilot_status()
    if status == "Normal" then
      self.current_icon = normal_icon
    elseif status == "Disabled" then
      self.current_icon = disable_icon
    elseif status == "Error" then
      self.current_icon = highlight.component_format_highlight(self.error_hl) .. warning_icon
    elseif status == "InProgress" then
      local icon = spinners[spinner_count]
      spinner_count = (spinner_count + 1) % #spinners + 1
      self.current_icon = highlight.component_format_highlight(self.in_progress_hl) .. icon
    elseif status == "Sleeping" then
      self.current_icon = highlight.component_format_highlight(self.sleeping_hl) .. sleeping_icon
    else
      self.current_icon = normal_icon
    end
  end)

  function component:update_status()
    update_status(self)
    return self.current_icon
  end

  return component
end

return create_component
