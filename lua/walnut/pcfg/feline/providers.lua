module('walnut.pcfg.feline.providers', package.seeall)

local get_value = require('utils').get_value
local reverse_list = require('utils').reverse_list

function get_diagnostics_count(t)
  local info = get_value(vim.b, 'coc_diagnostic_info', {})
  return get_value(info, t, 0)
end

function diagnostic_errors()
  return '  ' .. get_diagnostics_count('error')
end

function diagnostic_warnings()
  return '  ' .. get_diagnostics_count('warning')
end


local function get_tail(filename)
    return vim.fn.fnamemodify(filename, ":t")
end

local function split_filename(filename)
    local nodes = {}
    for parent in string.gmatch(filename, "[^/]+/") do
        table.insert(nodes, parent)
    end
    table.insert(nodes, get_tail(filename))
    return nodes
end

local function reverse_filename(filename)
    local parents = split_filename(filename)
    reverse_list(parents)
    return parents
end

local function same_until(first, second)
    for i = 1, #first do
        if first[i] ~= second[i] then
            return i
        end
    end
    return 1
end

local function get_unique_filename(filename, other_filenames)
    local rv = ''

    local others_reversed = vim.tbl_map(reverse_filename, other_filenames)
    local filename_reversed = reverse_filename(filename)
    local same_until_map = vim.tbl_map(function(second) return same_until(filename_reversed, second) end, others_reversed)

    local max = 0
    for _, v in ipairs(same_until_map) do
        if v > max then max = v end
    end
    for i = max, 1, -1 do
        rv = rv .. filename_reversed[i]
    end

    return rv
end

function get_current_ufn()
  local buffers = vim.fn.getbufinfo()
  local listed = vim.tbl_filter(function(buffer) return buffer.listed == 1 end, buffers)
  local names = vim.tbl_map(function(buffer) return buffer.name end, listed)
  local current_name = vim.fn.expand("%")
  return get_unique_filename(current_name, names)
end


function file_os_info()
  local os = vim.bo.fileformat:upper()
  local icon
  if os == 'UNIX' then
    icon = ' '
  elseif os == 'MAC' then
    icon = ' '
  else
    icon = ' '
  end
  return icon .. os
end

