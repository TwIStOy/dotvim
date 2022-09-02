module('ht.core.vim', package.seeall)

local cmd = vim.api.nvim_command

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

