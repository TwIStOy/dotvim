module('ht.plugs.dial', package.seeall)

function config()
  local augend = require("dial.augend")

  local function define_custom(strlist)
    return augend.constant.new { elements = strlist }
  end

  require'dial.config'.augends:register_group{
    default = {
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
      -- for cpp files
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

  vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(),
                          { noremap = true })
  vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(),
                          { noremap = true })
  vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(),
                          { noremap = true })
  vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(),
                          { noremap = true })
  vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(),
                          { noremap = true })
  vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(),
                          { noremap = true })
end

-- vim: et sw=2 ts=2

