local commons = require("dotvim.commons")

describe("dotvim.commons", function()
  describe("array_values_to_lookup", function()
    it("should convert array values to lookup table with default value true", function()
      local array = { "a", "b", "c" }
      local result = commons.array_values_to_lookup(array)

      assert(result.a == true)
      assert(result.b == true)
      assert(result.c == true)
      assert(result.d == nil)
    end)

    it("should convert array values to lookup table with custom value", function()
      local array = { "x", "y", "z" }
      local result = commons.array_values_to_lookup(array, "custom")

      assert(result.x == "custom")
      assert(result.y == "custom")
      assert(result.z == "custom")
      assert(result.w == nil)
    end)

    it("should handle empty array", function()
      local array = {}
      local result = commons.array_values_to_lookup(array)

      -- Should return empty table
      local count = 0
      for _ in pairs(result) do
        count = count + 1
      end
      assert(count == 0)
    end)

    it("should handle array with numeric values", function()
      local array = { 1, 2, 3 }
      local result = commons.array_values_to_lookup(array, "number")

      assert(result[1] == "number")
      assert(result[2] == "number")
      assert(result[3] == "number")
      assert(result[4] == nil)
    end)

    it("should handle array with mixed types", function()
      local array = { "string", 42, true }
      local result = commons.array_values_to_lookup(array)

      assert(result.string == true)
      assert(result[42] == true)
      assert(result[true] == true)
    end)

    it("should throw error for non-array input", function()
      local success1 = pcall(function()
        ---@diagnostic disable-next-line: param-type-mismatch
        commons.array_values_to_lookup({ a = 1, b = 2 }) -- not an array
      end)
      assert(not success1)

      local success2 = pcall(function()
        ---@diagnostic disable-next-line: param-type-mismatch
        commons.array_values_to_lookup("not an array")
      end)
      assert(not success2)
    end)
  end)
end)
