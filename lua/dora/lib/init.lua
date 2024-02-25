return {
  plugin = {
    plugin = require("dora.lib.plugin.plugin"),
    action = require("dora.lib.plugin.action"),
  },
  vim = {
    buffer = require("dora.lib.vim.buffer"),
    gui = require("dora.lib.vim.gui"),
    input = require("dora.lib.vim.input"),
  },
  tbl = require("dora.lib.tbl"),
  fs = require("dora.lib.fs"),
  cache = require("dora.lib.cache"),
}
