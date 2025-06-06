local fn = require("dotvim.commons.fn")

describe("dotvim.commons.fn", function()
  describe("invoke_once", function()
    it("should only invoke the function once", function()
      local call_count = 0
      local test_func = function()
        call_count = call_count + 1
        return "result", 42
      end

      local once_func = fn.invoke_once(test_func)

      -- First call
      local result1, result2 = once_func()
      assert(result1 == "result")
      assert(result2 == 42)
      assert(call_count == 1)

      -- Second call should not invoke original function
      local result3, result4 = once_func()
      assert(result3 == "result")
      assert(result4 == 42)
      assert(call_count == 1) -- Still 1, not 2

      -- Third call
      local result5, result6 = once_func()
      assert(result5 == "result")
      assert(result6 == 42)
      assert(call_count == 1) -- Still 1
    end)

    it("should handle functions with no return values", function()
      local call_count = 0
      local test_func = function()
        call_count = call_count + 1
      end

      local once_func = fn.invoke_once(test_func)

      once_func()
      assert(call_count == 1)

      once_func()
      assert(call_count == 1) -- Should still be 1
    end)

    it("should handle functions with single return value", function()
      local test_func = function()
        return "single"
      end

      local once_func = fn.invoke_once(test_func)

      local result1 = once_func()
      assert(result1 == "single")

      local result2 = once_func()
      assert(result2 == "single")
    end)
  end)

  describe("require_and", function()
    it("should call success callback when module exists", function()
      local success_called = false
      local received_module = nil

      local result = fn.require_and("string", function(module)
        success_called = true
        received_module = module
        return "success_result"
      end, function()
        return "fail_result"
      end)

      assert(success_called == true)
      assert(received_module == string)
      assert(result == "success_result")
    end)

    it("should call fail callback when module doesn't exist", function()
      local fail_called = false

      local result = fn.require_and("non_existent_module_123", function(module)
        return "success_result"
      end, function()
        fail_called = true
        return "fail_result"
      end)

      assert(fail_called == true)
      assert(result == "fail_result")
    end)

    it("should return nil when module exists but no success callback", function()
      local result = fn.require_and("string", nil, function()
        return "fail_result"
      end)

      assert(result == nil)
    end)

    it("should return nil when module doesn't exist and no fail callback", function()
      local result = fn.require_and("non_existent_module_123", function(module)
        return "success_result"
      end, nil)

      assert(result == nil)
    end)
  end)

  describe("bind", function()
    it("should bind arguments correctly", function()
      local test_func = function(a, b, c)
        return a + b + c
      end

      local bound_func = fn.bind(test_func, { 1, nil, 3 })
      local result = bound_func(2)

      assert(result == 6) -- 1 + 2 + 3
    end)

    it("should handle binding with no gaps", function()
      local test_func = function(a, b, c)
        return string.format("%s-%s-%s", a, b, c)
      end

      local bound_func = fn.bind(test_func, { "a", "b", "c" })
      local result = bound_func()

      assert(result == "a-b-c")
    end)

    it("should handle binding with multiple gaps", function()
      local test_func = function(a, b, c, d, e)
        return { a, b, c, d, e }
      end

      local bound_func = fn.bind(test_func, { 1, nil, 3, nil, 5 })
      local result = bound_func(2, 4)

      assert(result[1] == 1)
      assert(result[2] == 2)
      assert(result[3] == 3)
      assert(result[4] == 4)
      assert(result[5] == 5)
    end)

    it("should handle extra input arguments", function()
      local test_func = function(a, b)
        return a + b
      end

      local bound_func = fn.bind(test_func, { 1 })
      local result = bound_func(2, 3, 4) -- Extra arguments should be ignored

      assert(result == 3) -- 1 + 2
    end)

    it("should validate function parameter", function()
      local success = pcall(function()
        fn.bind("not a function", { 1, 2 })
      end)
      assert(not success)
    end)

    it("should validate args parameter", function()
      local test_func = function() end

      local success1 = pcall(function()
        fn.bind(test_func, "not a table")
      end)
      assert(not success1)

      local success2 = pcall(function()
        fn.bind(test_func, { a = 1, b = 2 }) -- Not an array
      end)
      assert(not success2)
    end)
  end)
end)
