local M = { 'monaqa/dial.nvim', event = 'BufReadPost' }

M.config = function() -- code to run after plugin loaded
  local augend = require 'dial.augend'

  local function define_custom(strlist)
    return
        augend.constant.new { elements = strlist, word = true, cyclic = true }
  end

  local default_group = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    define_custom { "true", "false" },
    define_custom { "True", "False" },
    define_custom { 'on', 'off' },
    define_custom { 'ON', 'OFF' },
    define_custom { 'yes', 'no' },
    define_custom { 'YES', 'NO' },
    define_custom { '||', '&&' },
    define_custom { 'enable', 'disable' },
    define_custom {
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    },
    define_custom {
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    },
  }
  local filetype_groups = {
    cpp = {
      -- glog levels
      define_custom { 'Debug', 'Info', 'Warn', 'Error', 'Fatal' },
      -- pair
      define_custom { 'first', 'second' },
      define_custom { 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t' },
      define_custom { 'int8_t', 'int16_t', 'int32_t', 'int64_t' },
      define_custom { 'htonl', 'ntohl' },
      define_custom { 'htons', 'ntohs' },
      define_custom { 'ASSERT_EQ', 'ASSERT_NE' },
      define_custom { 'EXPECT_EQ', 'EXPECT_NE' },
      define_custom { '==', '!=' },
      define_custom { 'static_cast', 'dynamic_cast', 'reinterpret_cast' },
    },
  }

  local build_group = function()
    local res = {}
    res.default = vim.deepcopy(default_group)
    for k, v in pairs(filetype_groups) do
      local tmp = vim.deepcopy(default_group)
      vim.list_extend(tmp, v)
      res[k] = tmp
    end
    return res
  end

  local groups = build_group()
  require'dial.config'.augends:register_group(groups)

  local mapping = require 'ht.core.mapping'

  mapping.map {
    mode = 'n',
    keys = { '<C-a>' },
    action = require'dial.map'.inc_normal(),
    desc = 'dial inc',
  }
  mapping.map {
    mode = "n",
    keys = { "<C-x>" },
    action = require("dial.map").dec_normal(),
    desc = 'dial dec',
  }

  mapping.ft_map('cpp', {
    mode = 'n',
    keys = { '<C-a>' },
    action = require'dial.map'.inc_normal('cpp'),
    desc = 'dial inc',
  })
  mapping.ft_map('cpp', {
    mode = "n",
    keys = { "<C-x>" },
    action = require("dial.map").dec_normal('cpp'),
    desc = 'dial dec',
  })

  mapping.map {
    mode = "v",
    keys = { "<C-a>" },
    action = require("dial.map").inc_visual(),
    desc = 'dial inc',
  }
  mapping.map {
    mode = "v",
    keys = { "<C-x>" },
    action = require("dial.map").dec_visual(),
    desc = 'dial dec',
  }
  mapping.map {
    mode = "v",
    keys = { "g", "<C-a>" },
    action = require("dial.map").inc_gvisual(),
    desc = 'dial inc',
  }
  mapping.map {
    mode = "v",
    keys = { "g", "<C-x>" },
    action = require("dial.map").dec_gvisual(),
    desc = 'dial dec',
  }

  for _, nr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(nr, 'ft') == 'cpp' then
      mapping.map({
        mode = 'n',
        keys = { '<C-a>' },
        action = require'dial.map'.inc_normal('cpp'),
        desc = 'dial inc',
      }, nr)
      mapping.map({
        mode = "n",
        keys = { "<C-x>" },
        action = require("dial.map").dec_normal('cpp'),
        desc = 'dial dec',
      }, nr)
    end
  end
end

M.mappings = function() -- code for mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

