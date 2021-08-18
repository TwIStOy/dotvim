module('ht.plugs.dial', package.seeall)

local __augends = {}

function config()
  local dial = require("dial")

  local function define_custom(strlist)
    local name = table.concat(strlist, '/')
    dial.augends["custom#" .. name] = dial.common.enum_cyclic {
      name = name,
      strlist = strlist
    }
    return "custom#" .. name
  end

  __augends['*'] = {
    "number#decimal", "number#hex", "number#binary", "date#[%Y/%m/%d]",
    define_custom {"true", "false"}, define_custom {"True", "False"},
    define_custom {'on', 'off'}, define_custom {'ON', 'OFF'},
    define_custom {'yes', 'no'}, define_custom {'YES', 'NO'},
    define_custom {'||', '&&'}, define_custom {'enable', 'disable'},
    define_custom {
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday'
    }, define_custom {
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    }
  }

  __augends['cpp'] = {
    define_custom {'Debug', 'Info', 'Warn', 'Error', 'Fatal'},
    define_custom {'first', 'second'},
    define_custom {'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t'},
    define_custom {'htonl', 'ntohl'}, define_custom {'htons', 'ntohs'},
    define_custom {'ASSERT_EQ', 'ASSERT_NE'},
    define_custom {'EXPECT_EQ', 'EXPECT_NE'}, define_custom {'==', '!='},
    define_custom {'static_cast', 'dynamic_cast', 'reinterpret_cast'}
  }

  vim.api.nvim_set_keymap('n', '<C-a>',
                          [[<cmd>lua require'dial'.cmd.increment_normal(vim.v.count1, require'ht.plugs.dial'.GenerateOverwriteList())<CR>]],
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<C-x>',
                          [[<cmd>lua require'dial'.cmd.increment_normal(-vim.v.count1, require'ht.plugs.dial'.GenerateOverwriteList())<CR>]],
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('v', '<C-a>',
                          [[<cmd>lua require'dial'.cmd.increment_visual(vim.v.count1, require'ht.plugs.dial'.GenerateOverwriteList())<CR>]],
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('v', '<C-x>',
                          [[<cmd>lua require'dial'.cmd.increment_visual(-vim.v.count1, require'ht.plugs.dial'.GenerateOverwriteList())<CR>]],
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('v', 'g<C-a>',
                          [[<cmd>lua require'dial'.cmd.increment_visual(vim.v.count1, require'ht.plugs.dial'.GenerateOverwriteList(), true)<CR>]],
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('v', 'g<C-x>',
                          [[<cmd>lua require'dial'.cmd.increment_visual(-vim.v.count1, require'ht.plugs.dial'.GenerateOverwriteList(), true)<CR>]],
                          {silent = true, noremap = true})
end

function GenerateOverwriteList()
  local mp = {}
  local ft = vim.api.nvim_buf_get_option(0, 'ft')
  local bt = vim.api.nvim_buf_get_option(0, 'buftype')

  vim.list_extend(mp, __augends['*'])
  if ft ~= nil and __augends[ft] ~= nil then
    vim.list_extend(mp, __augends[ft])
  end
  if bt ~= nil and __augends[bt] ~= nil and not bt == ft then
    vim.list_extend(mp, __augends[bt])
  end

  return mp
end

-- vim: et sw=2 ts=2

