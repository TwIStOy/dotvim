module('walnut.keymap', package.seeall)

local va = vim.api
local keymap = va.nvim_set_keymap

local ft_keymappings = {}

local function generate_desc_map(shortcut, desc) -- {{{
  if #shortcut == 1 then return {[shortcut] = desc} end

  return {[shortcut:sub(1, 1)] = generate_desc_map(shortcut:sub(2), desc)}
end -- }}}

local function merge_element(left, right) -- {{{
  if type(left) == 'string' and type(right) == 'string' then
    return left .. '/' .. right
  end

  if type(left) == 'string' and type(right) == 'table' then
    -- set[key] ~= nil
    local res = {}

    if right['name'] ~= nil then
      res['name'] = left .. '/' .. right['name']
    else
      res['name'] = left
    end
    for k, v in pairs(right) do res[k] = v end

    return res
  end

  if type(left) == 'table' and type(right) == 'string' then
    return merge_element(right, left)
  end

  if type(left) == 'table' and type(right) == 'table' then
    local res = {}
    for k, v in pairs(left) do
      if right[k] ~= nil then
        -- right exists
        res[k] = merge_element(v, right[k])
      else
        res[k] = v
      end
    end

    for k, v in pairs(right) do if left[k] == nil then res[k] = v end end

    return res
  end
end -- }}}

local function update_ft_keymappings(ft, shortcut, desc) -- {{{
  if ft_keymappings[ft] ~= nil then
    ft_keymappings[ft] = merge_element(ft_keymappings[ft],
                                       generate_desc_map(shortcut, desc))
  else
    ft_keymappings[ft] = generate_desc_map(shortcut, desc)
  end
end -- }}}

-- map after <leader>
function ftmap(ft, desc, shortcut, command)
  if ft == '*' then
    keymap('n', '<leader>' .. shortcut, command, {silent = true, noremap = true})
  else
    vim.api.nvim_command(string.format(
                             "au FileType %s nnoremap <buffer><silent><leader>%s %s",
                             ft, shortcut, command))
  end
  update_ft_keymappings(ft, shortcut, desc)
end

function inspect() print(vim.inspect(ft_keymappings)) end

function ftdesc_folder(ft, folder, desc)
  ft_keymappings[ft] = merge_element(ft_keymappings[ft],
                                     generate_desc_map(folder, {name = desc}))
end

function define_keymap_here()
  local ft = vim.api.nvim_buf_get_option(0, 'ft')
  local res
  if ft_keymappings[ft] ~= nil then
    res = merge_element(ft_keymappings['*'], ft_keymappings[ft])
  else
    res = ft_keymappings['*']
  end
  vim.api.nvim_buf_set_var(0, 'which_key_map', res)
end

-- vim: fdm=marker
