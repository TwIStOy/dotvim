module('walnut.init', package.seeall)

local wp = require 'walnut.plugin'
local cmd = vim.api.nvim_command

require('walnut.plugins')
require('walnut.settings')

