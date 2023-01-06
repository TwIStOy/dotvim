local M = {}

-- util functions to build right-click-like menu

local F = vim.fn
local A = vim.api
local _MENU_VAR_ = '_dotvim_menu_info'

M.menus = {}

--[[
Simple menu item
{
  "text", -- text to display
  {
    action = function() end, -- function to call when item is selected
  }
}

Complex menu item with sub-menu
{
  "text", -- text to display
  {
    items = {
      -- sub-menu items
    }
  }
}

--]]

local function add_section(ctx, new_section)
  local Menu = require "nui.menu"
  if #ctx > 0 then
    vim.list_extend(ctx, { Menu.separator(nil, { '-' }) })
  end
  vim.list_extend(ctx, new_section)
  return ctx
end

local function get_buffer_var(bufnr)
  if F['exists']('b:' .. _MENU_VAR_) == 0 then
    A.nvim_buf_set_var(bufnr, _MENU_VAR_, {})
  end
  return A.nvim_buf_get_var(bufnr, _MENU_VAR_) or {}
end

M.append_section = function(self, ft, ctx)
  if self.menus[ft] == nil then
    self.menus[ft] = {}
  end
  vim.list_extend(self.menus[ft], { ctx })
end

M.get_ft_sections = function(self, ft)
  local ctx = {}

  if self.menus['*'] ~= nil then
    for _, v in ipairs(self.menus['*']) do
      ctx = add_section(ctx, v)
    end
  end

  if self.menus[ft] ~= nil then
    for _, v in ipairs(self.menus[ft]) do
      ctx = add_section(ctx, v)
    end
  end

  return ctx
end

M.set_buf_context = function(bufnr, new_section)
  local ctx = get_buffer_var(bufnr)
  A.nvim_buf_set_var(bufnr, _MENU_VAR_, add_section(ctx, new_section))
end

local function background(hi)
  return string.format("#%x", vim.api.nvim_get_hl_by_name(hi, 1).background)
end

local function foreground(hi)
  return string.format("#%x", vim.api.nvim_get_hl_by_name(hi, 1).foreground)
end

local function display_menu(_sections, winnr, r, c, previous)
  local Menu = require "nui.menu"

  vim.cmd("highlight MenuSel gui=bold guibg=" .. background('IncSearch') ..
              " guifg=" .. foreground('IncSearch'))
  local popup_options = {
    relative = { type = "win", winid = winnr },
    focusable = false,
    buf_options = { modifiable = false, readonly = true, filetype = 'nuipopup' },
    position = { row = r, col = c },
    border = {
      style = "rounded",
      highlight = "FloatBorder",
      padding = { top = 0, bottom = 0, left = 1, right = 1 },
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:MenuSel",
    },
  }

  local max_width = 0
  local has_sub = false;

  local sections = vim.deepcopy(_sections)

  for _, v in ipairs(sections) do
    if v.text ~= nil then
      max_width = math.max(max_width, #v.text)
    end
    if v.items ~= nil then
      has_sub = true
    end
  end
  if has_sub then
    max_width = max_width + 2
  end

  for _, v in ipairs(sections) do
    if v.items ~= nil then
      -- append (max_width - #v.text) spaces
      for i = 1, max_width - #v.text do
        v.text = v.text .. ' '
      end
      v.text = v.text .. ' ▶'
    end
  end

  local menu = Menu(popup_options, {
    lines = sections,
    max_width = 40,
    keymap = {
      focus_next = { "j", "<DOWN>", "<C-n>", "<TAB>" },
      focus_prev = { "k", "<UP>", "<C-p>", "<S-TAB>" },
      close = { "<ESC>", "<C-c>", "h" },
      submit = { "<CR>" },
    },
    on_close = function()
      if previous == nil then
        vim.api.nvim_set_current_win(winnr)
      end
    end,
    on_change = function(item, m)
      -- complex menu item, open sub-menu
      local pos = nil
      for i, val in ipairs(m._tree.nodes.root_ids) do
        if val == item._id then
          pos = i
        end
      end

      if item.items ~= nil then
        display_menu(item.items, winnr, r + pos - 1, c + m.win_config.width + 4,
                     { m })
      end
    end,
    on_submit = function(item)
      if item.action ~= nil then
        -- close previous menus
        if previous ~= nil then
          for _, v in ipairs(previous) do
            v:unmount()
          end
        end

        -- action field exists, simple menu item, call action
        vim.api.nvim_set_current_win(winnr)
        item.action()
      end
    end,
  })

  menu:mount()
end

M.show_menu = function(self)
  local first_line = F.line('w0')
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local winnr = vim.api.nvim_get_current_win()
  display_menu(self:get_ft_sections(vim.bo.filetype), winnr,
               r - first_line + 1 + 1, c + 8)
end

return M

