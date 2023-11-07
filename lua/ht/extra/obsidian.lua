local Curl = require("plenary.curl")
local hv = require("ht.vim")

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

---@class ObsidianNote
---@field path string
---@field basename string
---@field cachedMetadata ObsidianNoteCachedMetadata
local ObsidianNote = {}

---@return string
function ObsidianNote:id()
  return hv.if_nil(self.cachedMetadata.frontmatter.id, "")
end

---@return string[]
function ObsidianNote:aliases()
  return hv.if_nil(self.cachedMetadata.frontmatter.aliases, {})
end

---@return string[]
function ObsidianNote:tags()
  local ret = {}
  for _, tag in ipairs(hv.if_nil(self.cachedMetadata.tags, {})) do
    ret[#ret + 1] = tag
  end
  for _, tag in ipairs(hv.if_nil(self.cachedMetadata.frontmatter.tags, {})) do
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
  return hv.if_nil(
    self:aliases()[1],
    self.cachedMetadata.frontmatter.id,
    self.basename
  )
end

---@class ObsidianNoteCachedMetadata
---@field frontmatter table<string, any>
---@field links ObsidianNoteCachedMetadataLink[]
---@field tags string[]
---@field backlinks_count number

---@class ObsidianNoteCachedMetadataLink
---@field link string
---@field path string?

---@return ObsidianNote[]
local function get_all_markdown_files()
  local response = Curl.post(graphql_url, {
    headers = {
      content_type = "application/json",
    },
    body = vim.fn.json_encode { query = all_markdown_files },
  })
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
      if hv.is_nil(link.linkPath) then
        link.linkPath = {}
      end
      table.insert(note.cachedMetadata.links, {
        link = link.link,
        path = link.linkPath.path,
      })
      if not hv.is_nil(link.linkPath.path) then
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

return {
  get_all_markdown_files = get_all_markdown_files,
}
