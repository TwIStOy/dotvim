---@class dotvim.extra.obsidian.graphql
local M = {}

---@type dora.lib
local lib = require("dora.lib")

--[[
Expect https://github.com/TwIStOy/obsidian-local-graphql
]]

local graphql_url = "http://localhost:28123"

local all_markdown_files = [[
query {
  vault {
    allMarkdownFiles {
      path
      basename
      cachedMetadata {
        tags {
          tag
        }
        frontmatter {
          key
          value
        }
        links {
          link
          linkPath {
            path
          }
        }
      }
    }
  }
}
]]

---@async
---@return table?
local function request_obsidian(url, query)
  local cmd = {
    "curl",
    "--location",
    "--request",
    "POST",
    url,
    "--header",
    "Content-Type: application/json",
    "--data-raw",
    vim.fn.json_encode { query = query },
  }
  ---@type vim.SystemCompleted
  local ret =
      lib.async.wrap(vim.system)(cmd, { text = true, timeout = 10 * 1000 })
  if ret.code == 0 then
    local ok, data = pcall(vim.fn.json_decode, ret.stdout)
    if ok then
      return data
    end
  end
end

---@class dotvim.extra.obsidian.ObsidianNoteCachedMetadata
---@field frontmatter table<string, any>
---@field links dotvim.extra.obsidian.ObsidianNoteCachedMetadataLink[]
---@field tags string[]
---@field backlinks_count number

---@class dotvim.extra.obsidian.ObsidianNoteCachedMetadataLink
---@field link string
---@field path string?

---@class dotvim.extra.obsidian.ObsidianNote
---@field path string
---@field basename string
---@field cachedMetadata dotvim.extra.obsidian.ObsidianNoteCachedMetadata
local ObsidianNote = {}

---@return string
function ObsidianNote:id()
  return vim.F.if_nil(self.cachedMetadata.frontmatter.id, "")
end

---@return string[]
function ObsidianNote:aliases()
  return vim.F.if_nil(self.cachedMetadata.frontmatter.aliases, {})
end

---@return string[]
function ObsidianNote:tags()
  local ret = {}
  for _, tag in ipairs(vim.F.if_nil(self.cachedMetadata.tags, {})) do
    ret[#ret + 1] = tag
  end
  for _, tag in ipairs(vim.F.if_nil(self.cachedMetadata.frontmatter.tags, {})) do
    ret[#ret + 1] = "#" .. tag
  end
  return ret
end

---@return string
function ObsidianNote:link_count()
  return ("L%d B%d"):format(
    #self.cachedMetadata.links,
    self.cachedMetadata.backlinks_count
  )
end

---@return string
function ObsidianNote:title()
  return vim.F.if_nil(
    self:aliases()[1],
    self.cachedMetadata.frontmatter.id,
    self.basename
  )
end

local function is_nil(v)
  return v == nil or v == vim.NIL
end

---@async
---@return dotvim.extra.obsidian.ObsidianNote[]
function M.get_all_markdown_files()
  local response = request_obsidian(graphql_url, all_markdown_files)
  if response == nil then
    return {}
  end
  local data = vim.fn.json_decode(response.body)
  local files = data.data.vault.allMarkdownFiles
  local ret = {}
  local backlinks_count = {}
  for _, file in ipairs(files) do
    local note = {}
    note.path = file.path
    note.cachedMetadata = {}
    note.cachedMetadata.frontmatter = {}
    note.cachedMetadata.links = {}
    note.cachedMetadata.tags = {}
    for _, tag in ipairs(file.cachedMetadata.tags) do
      table.insert(note.cachedMetadata.tags, tag.tag)
    end
    for _, link in ipairs(file.cachedMetadata.links) do
      if is_nil(link.linkPath) then
        link.linkPath = {}
      end
      table.insert(note.cachedMetadata.links, {
        link = link.link,
        path = link.linkPath.path,
      })
      if not is_nil(link.linkPath.path) then
        backlinks_count[link.linkPath.path] = (
          backlinks_count[link.linkPath.path] or 0
        ) + 1
      end
    end
    for _, frontmatter in ipairs(file.cachedMetadata.frontmatter) do
      note.cachedMetadata.frontmatter[frontmatter.key] = frontmatter.value
    end
    ret[#ret + 1] = setmetatable(note, { __index = ObsidianNote })
  end
  for _, note in ipairs(ret) do
    note.cachedMetadata.backlinks_count = backlinks_count[note.path] or 0
  end
  return ret
end

return M
