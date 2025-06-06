local validator = require("dotvim.commons.validator")

describe("dotvim.commons.validator", function()
  describe("is_array", function()
    it("should return true for valid arrays", function()
      assert(validator.is_array({}) == true)
      assert(validator.is_array({ 1, 2, 3 }) == true)
      assert(validator.is_array({ "a", "b", "c" }) == true)
      assert(validator.is_array({ true, false, nil }) == true)
    end)

    it("should return false for non-arrays", function()
      assert(validator.is_array({ a = 1, b = 2 }) == false)
      assert(validator.is_array("string") == false)
      assert(validator.is_array(42) == false)
      assert(validator.is_array(true) == false)
      assert(validator.is_array(nil) == false)
      assert(validator.is_array(function() end) == false)
    end)

    it("should validate array elements when validator is provided", function()
      local is_number = function(v) return type(v) == "number" end
      local is_string = function(v) return type(v) == "string" end

      -- Valid arrays with validator
      assert(validator.is_array({ 1, 2, 3 }, is_number) == true)
      assert(validator.is_array({ "a", "b", "c" }, is_string) == true)
      assert(validator.is_array({}, is_number) == true) -- Empty array should pass

      -- Invalid arrays with validator
      assert(validator.is_array({ 1, "2", 3 }, is_number) == false)
      assert(validator.is_array({ "a", 2, "c" }, is_string) == false)
      -- Note: { 1, nil, 3 } passes because ipairs stops at first nil, only checking element 1
      assert(validator.is_array({ 1, nil, 3 }, is_number) == true) -- ipairs only sees element 1
    end)

    it("should work with complex validators", function()
      local is_positive_number = function(v)
        return type(v) == "number" and v > 0
      end

      assert(validator.is_array({ 1, 2, 3 }, is_positive_number) == true)
      assert(validator.is_array({ 1, -2, 3 }, is_positive_number) == false)
      assert(validator.is_array({ 0, 1, 2 }, is_positive_number) == false) -- 0 is not positive
    end)
  end)

  describe("all", function()
    it("should return validator that passes when all validators pass", function()
      local is_number = function(v) return type(v) == "number" end
      local is_positive = function(v) return v > 0 end
      local is_integer = function(v) return v % 1 == 0 end

      local combined_validator = validator.all(is_number, is_positive, is_integer)

      assert(combined_validator(5) == true) -- number, positive, integer
      assert(combined_validator(1) == true) -- number, positive, integer
      assert(combined_validator(100) == true) -- number, positive, integer
    end)

    it("should return validator that fails when any validator fails", function()
      local is_number = function(v) return type(v) == "number" end
      local is_positive = function(v) return v > 0 end
      local is_integer = function(v) return v % 1 == 0 end

      local combined_validator = validator.all(is_number, is_positive, is_integer)

      assert(combined_validator("5") == false) -- not a number
      assert(combined_validator(-5) == false) -- not positive
      assert(combined_validator(5.5) == false) -- not integer
      assert(combined_validator(nil) == false) -- not a number
    end)

    it("should work with single validator", function()
      local is_string = function(v) return type(v) == "string" end
      local single_validator = validator.all(is_string)

      assert(single_validator("hello") == true)
      assert(single_validator(123) == false)
    end)

    it("should work with no validators (should always pass)", function()
      local no_validator = validator.all()

      assert(no_validator("anything") == true)
      assert(no_validator(42) == true)
      assert(no_validator(nil) == true)
      assert(no_validator({}) == true)
    end)

    it("should work with custom validators", function()
      local is_table = function(v) return type(v) == "table" end
      local has_key_x = function(v) return v.x ~= nil end
      local has_key_y = function(v) return v.y ~= nil end

      local point_validator = validator.all(is_table, has_key_x, has_key_y)

      assert(point_validator({ x = 1, y = 2 }) == true)
      assert(point_validator({ x = 1, y = 2, z = 3 }) == true) -- extra keys ok
      assert(point_validator({ x = 1 }) == false) -- missing y
      assert(point_validator({ y = 2 }) == false) -- missing x
      assert(point_validator({}) == false) -- missing both
      assert(point_validator("not table") == false) -- not table
    end)

    it("should handle validators that throw errors", function()
      local error_validator = function(v)
        if v == "error" then
          error("test error")
        end
        return true
      end
      local safe_validator = function(v) return type(v) == "string" end

      local combined = validator.all(safe_validator, error_validator)

      assert(combined("good") == true)

      -- When error_validator throws, the all() should fail
      local success = pcall(function()
        return combined("error")
      end)
      assert(not success)
    end)
  end)
end)
