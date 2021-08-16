module('ht.core.autocmd', package.seeall)

local cmd = vim.api.nvim_command

--[[
Augroups and autocommands do not have an interface yet but it is being worked on:
    Pull request #12378
    Pull request #14661 (lua: autocmds take 2)
--]]
function CreateAugroups(definitions)
  for group_name,definition in definitions do
    cmd(string.format("augroup %s", group_name))
    for _, def in definition do
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			cmd(command)
    end
    cmd("augroup END")
  end
end

-- vim: et sw=2 ts=2

