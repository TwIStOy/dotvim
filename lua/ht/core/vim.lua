module('ht.core.vim', package.seeall)

local cmd = vim.api.nvim_command

local function gen_event_table(tbl, event)
  local register_function = function(base)
    local func = function(pattern, callback, desc)
      local opt = vim.tbl_extend("keep", {
        event = event,
        pattern = pattern,
        desc = desc
      }, base, tbl.__ex_autocmd_opt)
      if type(callback) == 'string' then
        opt.command = callback
        if desc == nil then
          opt.desc = callback
        end
      else
        opt.callback = callback
      end

      vim.api.nvim_create_autocmd(opt)
    end
    return func
  end

  local v = {
    on = register_function({}),
    once = register_function({once = true})
  }
  tbl[event] = v
  return v
end

local function gen_group_table(tbl, group_name)
  vim.api.nvim_create_augroup({name = group_name, clear = true})
  local v = setmetatable({__ex_autocmd_opt = {group = group_name}},
                         {__index = gen_event_table})
  tbl[group_name] = v
  return v
end

event = setmetatable({__ex_autocmd_opt = {}}, {__index = gen_event_table})
group = setmetatable({__ex_autocmd_opt = {}}, {__index = gen_group_table})

function multi_events(events, pattern, callback, desc)
  for i,e in ipairs(events) do
    event[e].on(pattern, callback, desc)
  end
end

local function color_value(v)
  if type(v) == 'string' then
    return v
  end
  if type(v) == 'number' then
    return string.format('#%x', v)
  end
  return ''
end

--[[
Create a set of highlight groups:
{
  group_name = {
    attributes = "",
    ...
  }
}
--]]
function HighlightGroups(groups, default)
  for group_name, highlights in pairs(groups) do
    local options = {}
    for k, v in pairs(highlights) do
      if v ~= nil then
        table.insert(options, string.format("%s=%s", k, color_value(v)))
      end
    end

    if #options > 0 then
      cmd(string.format("highlight %s %s %s", default and "default" or "",
                        group_name, table.concat(options, ' ')))
    end
  end
end

--[[
Create a set of highlight links
{
  group_name = linked_name,
  group_name = {
    linked_name,
    force = true
  }
}
--]]
function HighlightLinks(links)
  for higroup, link_to in pairs(links) do
    if type(link_to) == 'string' then
      cmd(string.format("highlight default link %s %s", higroup, link_to))
    end
    if type(link_to) == 'table' then
      local togroup = link_to[1]
      if togroup == nil then
        error("togoup must exists")
      end
      cmd(string.format("highlight%s link %s %s",
                        link_to.force and "!" or " default", higroup, togroup))
    end
  end
end

function VisualSelectionRange()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

-- vim: et sw=2 ts=2

