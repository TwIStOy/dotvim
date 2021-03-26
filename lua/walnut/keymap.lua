module('walnut.keymap', package.seeall)

local ft_keymappings = {}

-- map after <leader>
function ftmap(ft, desc, mode, shortcut, ...)
  -- ft_keymappings[ft] =
end

function ftdesc(ft, folder, name)
  ft_keymappings[ft]
end

local function generate_desc_map(shortcut, desc)
  if #shortcut == 1 then
    return { [shortcut] = desc }
  end
  for i = 1, #shortcut do
    res = 
  end
  return res
end

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
    for k, v in pairs(right) do
      res[k] = v
    end

    return res
  end

  if type(left) == 'table' and type(right) == 'string' then
    return merge_element(right, left)
  end

  if type(left) == 'table' and type(right) == 'table' then
    -- TODO
    local res = {}
    for k, v in pairs(left) do
      if right[k] ~= nil then
        -- right exists
        res[k] = merge_element(v, right[k])
      else
        res[k] = v
      end
    end

    for k, v in pairs(right) do
      if left[k] == nil then
        res[k] = v
      end
    end

    return res
  end
end -- }}}

local function update_ft_keymappings(ft, shortcut)
end

-- for i = 1, #str do
--     local c = str:sub(i,i)
--     -- do something with c
-- end

-- vim: fdm=marker
