local M = {}

local fs = require("ht.utils.fs")
local Path = require("plenary.path")

---@class ht.utils.ProjectChecker
---@field markers string|string[]
---@field project_kind string

---@type ht.utils.ProjectChecker[]
local PROJECT_KINDS = {
  {
    markers = "Cargo.toml",
    project_kind = "rust",
  },
  {
    markers = { "CMakeLists.txt", "CMakeCache.txt" },
    project_kind = "cmake",
  },
  {
    markers = {
      ".dart_tool/",
      "pubspec.yaml",
      "pubspec.yml",
      "pubspec.lock",
    },
    project_kind = "dart",
  },
}

function M.get_project_kind(root)
  for _, project_kind in ipairs(PROJECT_KINDS) do
    local markers = project_kind.markers
    if type(markers) == "string" then
      markers = { markers }
    end
    for _, marker in ipairs(markers) do
      local stat = vim.uv.fs_stat(root .. "/" .. marker)
      local found = stat ~= nil
      if stat then
        if marker:byte(#marker) == "/" then
          -- is directory
          if stat.type ~= "directory" then
            found = false
          end
        else
          -- is file
          if stat.type ~= "file" then
            found = false
          end
        end
      end
      if found then
        return project_kind.project_kind
      end
    end
  end
  return nil
end

return M
