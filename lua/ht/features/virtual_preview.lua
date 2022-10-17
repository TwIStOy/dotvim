local middleclass = require 'middleclass'

local object_count = 0
local VirtualPreview = middleclass('VirtualPreview')

-- vim.cmd([[ hi def TSCppHighlight guifg=#808080 ctermfg=244 ]])

function VirtualPreview:initialize(hl_group)
  self.ns_name = string.format('VirtualPreview_instance_%d', object_count)
  object_count = object_count + 1

  self.ns_id = vim.api.nvim_create_namespace(self.ns_name)

  self.mark_id = nil
  self.last_buffer = nil
  self.hl_group = hl_group
  self.cached_lines = {}
end

function VirtualPreview:remove_vt()
  if self.mark_id ~= nil then
    assert(self.last_buffer ~= nil)
    assert(self.ns_id ~= nil)

    if self.mark_id and vim.api.nvim_buf_is_valid(self.last_buffer) then
      vim.api.nvim_buf_del_extmark(self.last_buffer, self.ns_id, self.mark_id)
    end

    self.mark_id = nil
    self.last_buffer = nil
  end
end

function VirtualPreview:draw(lines, row)
  self:remove_vt()

  if lines ~= nil then
    self.cached_lines = {}
  end

  self.last_buffer = vim.fn.bufnr('%')

  local line_num = row - 1
  local col_num = 0

  local opts = { id = 1, virt_lines = {} }
  for _, line in ipairs(self.cached_lines) do
    table.insert(opts.virt_lines, { { line, self.hl_group } })
  end

  self.mark_id = vim.api.nvim_buf_set_extmark(self.last_buffer, self.ns_id,
                                              line_num, col_num, opts)
end

function VirtualPreview:release()
  self:remove_vt()
end

local M = {}

M.VirtualPreview = VirtualPreview

return M
