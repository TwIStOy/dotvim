module('ht.core.highlight', package.seeall)

local function validate_value(v)
  if type(v) == 'string' then
    return v
  end
  if type(v) == 'number' then
    return string.format('#%x', v)
  end
  return ''
end

function CreateGroups(groups, default)
  for group_name, highlights in pairs(groups) do
    local options = {}
    for k, v in pairs(highlights) do
      table.insert(options, string.format("%s=%s", k, validate_value(v)))
    end

    vim.cmd(string.format("highlight %s %s %s", default and "default" or "",
                          group_name, table.concat(options, ' ')))
  end
end

function CreateLinks(links)
  for higroup, link_to in pairs(links) do
    if type(link_to) == 'string' then
      vim.cmd(string.format("highlight default link %s %s", higroup, link_to))
    end
    if type(link_to) == 'table' then
      local togroup = link_to[1]
      if togroup == nil then
        error("togoup must exists")
      end
      vim.cmd(string.format("highlight%s link %s %s",
                            link_to.force and "!" or " default", higroup,
                            togroup))
    end
  end
end

function Hi(opts)
  for group_name, definition in pairs(opts) do
    local cmd = 'hi! ' .. group_name
    local count = 0
    for key, arg in pairs(definition) do
      if arg ~= nil then
        if type(arg) == 'string' then
          count = count + 1
          cmd = cmd .. string.format(' %s=%s', key, arg)
        end
        if type(arg) == 'number' then
          count = count + 1
          cmd = cmd .. string.format(' %s=#%x', key, arg)
        end
      end
    end
    if count > 0 then
      vim.api.nvim_command(cmd)
    end
  end
end

function Foreground(group_name)
  return vim.api.nvim_get_hl_by_name(group_name, 1).foreground
end

function Background(group_name)
  return vim.api.nvim_get_hl_by_name(group_name, 1).background
end

-- vim: et sw=2 ts=2

