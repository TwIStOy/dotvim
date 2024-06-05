---@class dotvim.extra.search_everywhere.async_job
local M = {}

---@class dotvim.extra.search_everywhere.async_job.AsyncJob
---@field finished boolean
---@field close fun(self)
---@field thread? thread
local async_job = {}
