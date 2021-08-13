module('ht.keymap.keymap', package.seeall)

local set_keymap = vim.api.nvim_set_keymap
local __keymap_actions_storage = {}
local __keymap_description = {}

function ExecuteAction(key)
  __keymap_actions_storage[key]()
end

local function keymap_description_table(key, description)
  if #key == 1 then
    return {
      [key] = description,
    }
  end

  return {
    [key:sub(1, 1)] = keymap_description_table(key:sub(2), description),
  }
end

local function merge_description_table(left, right)
  if type(left) == 'string' and type(right) = 'string' then
    return left .. '/' .. right
  end

  if type(left) == 'string' and type(right) == 'table' then
    local result = {}

    if right.name ~= nil then
      right.name = left .. '/' .. right.name
    else
      right.name = left
    end

    for k,v in pairs(right) do
      result[k] = v
    end

    return result
  end

  if type(left) == 'table' and type(right) == 'string' then
    return merge_description_table(right, left)
  end

  if type(left) == 'table' and type(right) == 'table' then
    local result = {}

    for k,v in pairs(left) do
      if right[k] ~= nil then
        result[k] = merge_description_table(v, right[k])
      else
        result[k] = v
      end
    end

    for k,v in pairs(right) do
      if left[k] == nil then
        result[k] = v
      end
    end

    return result
  end
end

local function register_keymap_description(ft, key, description)
  if __keymap_description[ft] == nil then
    __keymap_description[ft] = keymap_description_table(key, description)
  else
    __keymap_description[ft] = merge_description_table(
      __keymap_description[ft], keymap_description_table(key, description))
  end
end

local function create_keymap(mode, key, action, opts)
  if type(action) == "string" then
    set_keymap(mode, key, action, opts)
  else
    if type(action) == "function" then
      local storage_key = #__keymap_actions_storage
      __keymap_actions_storage[storage_key] = action
      set_keymap(mode, key,
                 string.format([[<cmd>lua require('ht.keymap.base').ExecuteAction(%d)<CR>]], storage_key), opts)
    else
      print('Not supported action type')
    end
  end

  -- try to register descriptions for shortcuts which start with '<leader>
  if opts ~= nil and mode == 'n' and type(opts) == "table"
    and opts.description ~= nil and key:find("^<leader>") then
    local ft
    if opts.ft == nil then
      ft = '*'
    else
      ft = opts.ft
    end
    register_keymap_description(ft, key, opts.description)
  end
end

function nnoremap(key, action)
  create_keymap('n', key, action, {
    silent = true,
    noremap = true
  })
end

function vnoremap(key, action)
  create_keymap('v', key, action, {
    silent = true,
    noremap = true
  })
end

function xnoremap(key, action)
  create_keymap('x', key, action, {
    silent = true,
    noremap = true
  })
end

function SetFolderName(ft, folder, name)
  __keymap_description[ft] = merge_description_table(
    __keymap_description[ft], keymap_description_table(folder, { name = name })
end

-- returns keymap description table for vim-which-key of current buffer
function SetKeymapDescriptionToBuffer()
  local ft = vim.api.nvim_buf_get_option(0, 'ft')
  local res = {}
  if __keymap_description['*'] ~= nil then
    res = merge_description_table(res, __keymap_description['*'])
  end
  if __keymap_description[ft] ~= nil then
    res = merge_description_table(res, __keymap_description[ft])
  end

  vim.api.nvim_buf_set_var(0, 'which_key_map', res)
end

-- vim: et sw=2 ts=2

