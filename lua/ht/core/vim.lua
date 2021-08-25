module('ht.core.vim', package.seeall)

local cmd = vim.api.nvim_command

function AutocmdGroups(groups)
  for name, group in pairs(groups) do
    cmd(string.format("augroup %s", name))
    for _, def in ipairs(group) do
      cmd(table.concat(vim.tbl_flatten {'autocmd', def}, ' '))
    end
    cmd "augroup END"
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

-- vim: et sw=2 ts=2

