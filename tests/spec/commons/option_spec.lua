---@diagnostic disable: undefined-global

local option = require("dotvim.commons.option")

describe("dotvim.commons.option", function()
  describe("deep_merge", function()
    describe("with no arguments", function()
      it("should return empty table", function()
        local result = option.deep_merge()

        assert(type(result) == "table")
        assert(vim.tbl_isempty(result))
      end)
    end)

    describe("with single argument", function()
      it("should return deep copy of single table", function()
        local input = { a = 1, b = { c = 2 } }
        local result = option.deep_merge(input)

        assert(vim.deep_equal(input, result))
        -- Verify it's a deep copy, not the same reference
        result.a = 999
        result.b.c = 999
        assert(input.a == 1)
        assert(input.b.c == 2)
      end)

      it("should handle empty table", function()
        local result = option.deep_merge {}

        assert(type(result) == "table")
        assert(vim.tbl_isempty(result))
      end)

      it("should handle array", function()
        local input = { 1, 2, 3 }
        local result = option.deep_merge(input)

        assert(vim.deep_equal(input, result))
        -- Verify it's a deep copy
        result[1] = 999
        assert(input[1] == 1)
      end)
    end)

    describe("with two arguments", function()
      it("should merge two simple tables without overlapping keys", function()
        local t1 = { a = 1, b = 2 }
        local t2 = { c = 3, d = 4 }
        local result = option.deep_merge(t1, t2)

        local expected = { a = 1, b = 2, c = 3, d = 4 }
        assert(vim.deep_equal(expected, result))
      end)

      -- Note: Current implementation has a limitation where it cannot handle
      -- non-table values that overlap between tables
      it("should merge nested tables recursively", function()
        local t1 = {
          a = 1,
          nested = { x = 10, y = 20 },
        }
        local t2 = {
          b = 2,
          nested = { z = 40 },
        }
        local result = option.deep_merge(t1, t2)

        local expected = {
          a = 1,
          b = 2,
          nested = { x = 10, y = 20, z = 40 },
        }
        assert(vim.deep_equal(expected, result))
      end)

      it("should merge deeply nested structures", function()
        local t1 = {
          level1 = {
            level2 = {
              level3 = { a = 1 },
            },
          },
        }
        local t2 = {
          level1 = {
            level2 = {
              level3 = { b = 2 },
            },
          },
        }
        local result = option.deep_merge(t1, t2)

        local expected = {
          level1 = {
            level2 = {
              level3 = { a = 1, b = 2 },
            },
          },
        }
        assert(vim.deep_equal(expected, result))
      end)

      it("should merge arrays by extending", function()
        local t1 = { arr = { 1, 2, 3 } }
        local t2 = { arr = { 4, 5 } }
        local result = option.deep_merge(t1, t2)

        local expected = { arr = { 1, 2, 3, 4, 5 } }
        assert(vim.deep_equal(expected, result))
      end)

      it("should handle empty arrays", function()
        local t1 = { arr = {} }
        local t2 = { arr = { 1, 2 } }
        local result = option.deep_merge(t1, t2)

        local expected = { arr = { 1, 2 } }
        assert(vim.deep_equal(expected, result))
      end)

      it("should handle arrays with empty second array", function()
        local t1 = { arr = { 1, 2 } }
        local t2 = { arr = {} }
        local result = option.deep_merge(t1, t2)

        local expected = { arr = { 1, 2 } }
        assert(vim.deep_equal(expected, result))
      end)

      it("should not mutate original tables", function()
        local t1 = { a = 1, nested = { x = 10 } }
        local t2 = { b = 2, nested = { y = 20 } }
        local t1_copy = vim.deepcopy(t1)
        local t2_copy = vim.deepcopy(t2)

        local result = option.deep_merge(t1, t2)

        -- Original tables should remain unchanged
        assert(vim.deep_equal(t1_copy, t1))
        assert(vim.deep_equal(t2_copy, t2))

        -- Result should be different from originals
        assert(not vim.deep_equal(t1, result))
        assert(not vim.deep_equal(t2, result))
      end)
    end)

    describe("with multiple arguments", function()
      it("should merge three tables", function()
        local t1 = { a = 1 }
        local t2 = { b = 2 }
        local t3 = { c = 3 }
        local result = option.deep_merge(t1, t2, t3)

        local expected = { a = 1, b = 2, c = 3 }
        assert(vim.deep_equal(expected, result))
      end)

      it("should merge nested structures with multiple tables", function()
        local t1 = { config = { ui = { theme = "dark" } } }
        local t2 = { config = { ui = { font = "mono" } } }
        local t3 = { config = { lsp = { enabled = true } } }
        local result = option.deep_merge(t1, t2, t3)

        local expected = {
          config = {
            ui = { theme = "dark", font = "mono" },
            lsp = { enabled = true },
          },
        }
        assert(vim.deep_equal(expected, result))
      end)

      it("should handle many arguments without overlapping values", function()
        local tables = {}
        for i = 1, 10 do
          tables[i] = { ["key" .. i] = i }
        end

        local result = vim.deepcopy(tables[1])
        for i = 2, #tables do
          result = option.deep_merge(result, tables[i])
        end

        for i = 1, 10 do
          assert(result["key" .. i] == i)
        end
      end)
    end)

    describe("error cases", function()
      it("should error when trying to merge array with object", function()
        local t1 = { 1, 2, 3 } -- array
        local t2 = { a = 1 } -- object

        local success = pcall(function()
          option.deep_merge(t1, t2)
        end)
        assert(not success)
      end)

      it("should error when trying to merge object with array", function()
        local t1 = { a = 1 } -- object
        local t2 = { 1, 2, 3 } -- array

        local success = pcall(function()
          option.deep_merge(t1, t2)
        end)
        assert(not success)
      end)

      it("should error when trying to merge non-table with table", function()
        local t1 = { a = 1 }
        local t2 = "not a table"

        local success = pcall(function()
          option.deep_merge(t1, t2)
        end)
        assert(not success)
      end)

      it("should error when trying to merge table with non-table", function()
        local t1 = "not a table"
        local t2 = { a = 1 }

        local success = pcall(function()
          option.deep_merge(t1, t2)
        end)
        assert(not success)
      end)

      it("should error when nested values have type conflicts", function()
        local t1 = { nested = { 1, 2, 3 } } -- array
        local t2 = { nested = { a = 1 } } -- object

        local success = pcall(function()
          option.deep_merge(t1, t2)
        end)
        assert(not success)
      end)

      -- This documents a current limitation of the implementation
      it("should error when trying to override non-table values", function()
        local t1 = { a = 1 } -- number
        local t2 = { a = 2 } -- number (should override, but current implementation errors)

        local success = pcall(function()
          option.deep_merge(t1, t2)
        end)
        assert(not success) -- Current implementation limitation
      end)
    end)

    describe("edge cases", function()
      -- Note: Current implementation cannot handle overlapping non-table values
      it("should handle nil values in tables", function()
        local t1 = { a = nil, b = 1 }
        local t2 = { c = 3 } -- Different key to avoid overlap
        local result = option.deep_merge(t1, t2)

        local expected = { b = 1, c = 3 }
        assert(vim.deep_equal(expected, result))
      end)

      it("should handle tables with only nested table values", function()
        local t1 = {
          tbl1 = { nested = "value1" },
        }
        local t2 = {
          tbl2 = { other = "value2" },
        }
        local result = option.deep_merge(t1, t2)

        assert(vim.deep_equal({ nested = "value1" }, result.tbl1))
        assert(vim.deep_equal({ other = "value2" }, result.tbl2))
      end)

      it("should handle very large nested structures", function()
        local function create_deep_table(depth, value)
          if depth == 0 then
            return { leaf = value }
          end
          return { nested = create_deep_table(depth - 1, value) }
        end

        local t1 = create_deep_table(5, "value1")
        local t2 = { other_branch = create_deep_table(3, "value2") }

        local result = option.deep_merge(t1, t2)

        -- Should be able to access deeply nested values
        local leaf_table = result
        for _ = 1, 5 do
          leaf_table = leaf_table.nested
        end
        assert(leaf_table.leaf == "value1")

        -- Check other branch
        local other_leaf = result.other_branch
        for _ = 1, 3 do
          other_leaf = other_leaf.nested
        end
        assert(other_leaf.leaf == "value2")
      end)
    end)
  end)
end)
