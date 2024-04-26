---@class dotvim.extra.lsp
local M = {}

-- thanks to https://www.reddit.com/r/neovim/comments/1c9q60s/tip_cmp_menu_with_rightaligned_import_location/
function M.get_lsp_item_import_location(completion, source)
  local ok, source_name = pcall(function()
    return source.source.client.config.name
  end)
  if not ok then
    return nil
  end

  vim.print(source_name, completion)

  if source_name == "tsserver" or source_name == "typescript-tools" then
    return vim.F.if_nil(
      vim.tbl_get(completion, "data", "entryNames", 1, "source"),
      completion.detail
    )
  elseif source_name == "pyright" and completion.labelDetails ~= nil then
    return completion.labelDetails.description
  elseif source_name == "texlab" then
    return completion.detail
  elseif source_name == "clangd" then
    local doc = completion.documentation
    if doc == nil then
      return
    end

    local import_str = doc.value

    local i, j = string.find(import_str, 'From `["<].*[">]`')
    if i == nil then
      return
    end

    return string.sub(import_str, i + 6, j - 1)
  elseif source_name == "rust-analyzer" then
    local imports = vim.tbl_get(completion, "data", "imports")
    if imports == nil or type(imports) ~= "table" or #imports == 0 then
      return
    end
    local import = imports[1]
    local full_import_path = import.full_import_path
    local imported_name = import.imported_name
    local i, _ = full_import_path:find("::" .. imported_name .. "$")
    if i == nil then
      return
    end
    return string.sub(full_import_path, 1, i - 1)
  end
end

return M
