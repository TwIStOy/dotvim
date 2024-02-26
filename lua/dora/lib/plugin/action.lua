---@class dora.lib.ActionKeySpec: LazyKeysBase
---@field mode? string|string[]

---@alias dora.lib.action.Condition fun(buf:dora.lib.vim.Buffer):boolean

---@class dora.lib.ActionOptions
---@field id string Unique id
---@field title string
---@field callback string|function
---@field icon? string
---@field category? string
---@field description? string Shown description if action hovered
---@field keys? string|(string|dora.lib.ActionKeySpec)[]
---@field plugin? string
---@field condition? dora.lib.action.Condition

---@class dora.lib.Action: dora.lib.ActionOptions
local Action = {}

---@class dora.lib.action._MakeActionOptionsArgs
---@field from? string
---@field category? string
---@field condition? dora.lib.action.Condition
---@field actions? dora.lib.ActionOptions[]

---@param opts dora.lib.action._MakeActionOptionsArgs
---@return dora.lib.ActionOptions[]
local function make_options(opts)
	local common_opts = {
		from = opts.from,
		category = opts.category,
		condition = opts.condition,
	}
	local res = {}
	for _, action in ipairs(opts.actions) do
		res[#res + 1] = vim.tbl_extend("keep", action, common_opts)
	end
	return res
end

function Action:execute()
	if type(self.callback) == "string" then
		vim.cmd(self.callback)
	else
		self.callback()
	end
end

---@return LazyKeysSpec[]
function Action:into_lazy_keys()
	if not self.keys then
		return {}
	end
	local callback = function()
		self:execute()
	end
	if type(self.keys) == "string" then
		return {
			{
				self.keys,
				callback,
			},
		}
	end
	---@param key dora.lib.ActionKeySpec|string
	return vim.tbl_map(function(key)
		if type(key) == "string" then
			return {
				key,
				callback,
			}
		else
			local res = vim.deepcopy(key)
			res[2] = callback
			return res
		end
	end, self.keys --[[@as (string|dora.lib.ActionKeySpec)[] ]])
end

---Returns this action can be used in the given buffer
---@param buffer dora.lib.vim.Buffer
---@return boolean
function Action:enabled(buffer)
	if self.condition then
		return self.condition(buffer)
	end
	return true
end

return {
	---@param opts dora.lib.ActionOptions
	---@return dora.lib.Action
	new_action = function(opts)
		return setmetatable(opts, { __index = Action }) --[[@as dora.lib.Action]]
	end,
	make_options = make_options,
}
