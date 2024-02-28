---@class dora.lib.promise
local M = {}

---@type dora.lib.class
local cls = require("dora.lib.class")

local PromiseState = {
	PENDING = 0,
	FULFILLED = 1,
	REJECTED = 2,
}

---@class dora.lib.promise.Promise._Prototype
local PromisePrototype = {}

local Promise = cls.new_class(PromisePrototype)

---@class dora.lib.promise.Promise: dora.lib.promise.Promise._Prototype
---@field state number
---@field value any
---@field on_fulfilled function[]
---@field reject_reason? string
---@field on_rejected (fun(reason:string):any)[]
---@field on_finally (fun():any)[]

---@param self dora.lib.promise.Promise
---@param executor fun(resolve:(fun(data):any:any), reject:(fun(reason):string:any)):any
function PromisePrototype.__init__(self, executor)
	self.state = PromiseState.PENDING
	self.value = nil
	self.on_fulfilled = {}
	self.on_rejected = {}

	local ok, res = pcall(function()
		executor(function(...)
			self:resolve(...)
		end, function(...)
			self:reject(...)
		end)
	end)

	if not ok then
		self:reject(res --[[@as string]])
	end
end

---Create new promise instance
---@param executor fun(resolve:(fun(data):any:any), reject:(fun(reason):string:any)):any
---@return dora.lib.promise.Promise
function M.new_promise(executor)
	return cls.new_instance(Promise, executor)
end

---Create a resolved promise
---@param data any
---@return dora.lib.promise.Promise
function M.resolve(data)
	local res = cls.new_instance(Promise, function() end)
	res.state = PromiseState.FULFILLED
	res.value = data
	return res
end

---Create a rejected promise
---@param reason any
---@return dora.lib.promise.Promise
function M.reject(reason)
	local res = cls.new_instance(Promise, function() end)
	res.state = PromiseState.REJECTED
	res.reject_reason = reason
	return res
end

---@param self dora.lib.promise.Promise
---@param data any
function PromisePrototype.resolve(self, data)
	if cls.instanceof(data, Promise) then
		---@type dora.lib.promise.Promise
		local next = data

		next["then"](data, function(v)
			return self:resolve(v)
		end, function(err)
			return self:reject(err)
		end)

		return
	end
end

---@param self dora.lib.promise.Promise
---@param reason string
function PromisePrototype.reject(self, reason)
	if self.state == 0 then
		self.state = 2
		self.reject_reason = reason
		for _, callback in ipairs(self.on_rejected) do
			callback(reason)
		end
		for _, callback in ipairs(self.on_finally) do
			callback()
		end
	end
end

---@param self dora.lib.promise.Promise
---@param on_fulfilled? function
---@param on_rejected? function
PromisePrototype["then"] = function(self, on_fulfilled, on_rejected)
	local is_fullfilled = self.state == 1
	local is_rejected = self.state == 2

	local resolve
	local reject
	local promise = cls.new_instance(Promise, function(res, rej)
		resolve = res
		reject = rej
	end)

	if on_fulfilled ~= nil then
		local callback = self:create_promise_resolving_callback(on_fulfilled, resolve, reject)
		self.on_fulfilled[#self.on_fulfilled + 1] = callback
		if is_fullfilled then
			callback(self.value)
		end
	else
		self.on_fulfilled[#self.on_fulfilled + 1] = function(v)
			resolve(v)
		end
	end

	if on_rejected ~= nil then
		local callback = self:create_promise_resolving_callback(on_rejected, resolve, reject)
		self.on_rejected[#self.on_rejected + 1] = callback
		if is_rejected then
			callback(self.reject_reason)
		end
	else
		self.on_rejected[#self.on_rejected + 1] = function(err)
			reject(err)
		end
	end

	if is_fullfilled then
		resolve(self.value)
	end
	if is_rejected then
		reject(self.reject_reason)
	end
	return promise
end

---@param self dora.lib.promise.Promise
---@param on_rejected fun(reason:string):any
function PromisePrototype.catch(self, on_rejected)
	return self["then"](self, nil, on_rejected)
end

---@param self dora.lib.promise.Promise
---@param on_finally fun():any
---@return dora.lib.promise.Promise
function PromisePrototype.finally(self, on_finally)
	if on_finally then
		self.on_finally[#self.on_finally + 1] = on_finally
		if self.state ~= 0 then
			on_finally()
		end
	end
	return self
end

---@param self dora.lib.promise.Promise
---@param f any
---@param resolve fun(data:any):any
---@param reject fun(reason:string):any
---@return fun(data:any):any
function PromisePrototype.create_promise_resolving_callback(self, f, resolve, reject)
	return function(value)
		local ok, res = pcall(function()
			self.handle_callback_data(f(value), resolve, reject)
		end)
		if not ok then
			reject(res --[[@as string]])
		end
	end
end

---@param data any
---@param resolve fun(data:any):any
---@param reject fun(reason:string):any
function PromisePrototype.handle_callback_data(data, resolve, reject)
	if cls.instanceof(data, Promise) then
		---@type dora.lib.promise.Promise
		local next_promise = data

		if next_promise.state == 1 then -- fullfilled
			resolve(next_promise.value)
		elseif next_promise.state == 2 then -- rejected
			reject(next_promise.reject_reason)
		end
	else
		resolve(data)
	end
end

return M
