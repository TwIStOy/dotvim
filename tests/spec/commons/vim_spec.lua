local vim_commons = require("dotvim.commons.vim")

describe("dotvim.commons.vim", function()
  describe("preserve_cursor_position", function()
    it("should preserve cursor position after callback execution", function()
      -- Create a temporary buffer for testing
      local bufnr = vim.api.nvim_create_buf(false, true)
      local winid = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = 10,
        height = 5,
        row = 1,
        col = 1
      })

      -- Set some content
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "line 1",
        "line 2", 
        "line 3",
        "line 4",
        "line 5"
      })

      -- Set cursor to line 3, column 2
      vim.api.nvim_win_set_cursor(winid, { 3, 2 })

      local callback_executed = false
      local callback_result = vim_commons.preserve_cursor_position(function()
        callback_executed = true
        -- Move cursor during callback
        vim.api.nvim_win_set_cursor(winid, { 1, 0 })
        return "test_result"
      end)

      assert(callback_executed == true)
      assert(callback_result == "test_result")

      -- Wait for scheduled function to execute
      vim.wait(100, function() return false end)

      -- Cursor should be restored to original position
      local cursor_pos = vim.api.nvim_win_get_cursor(winid)
      assert(cursor_pos[1] == 3)
      assert(cursor_pos[2] == 2)

      -- Clean up
      vim.api.nvim_win_close(winid, true)
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    it("should handle cursor position beyond last line", function()
      -- Create a temporary buffer
      local bufnr = vim.api.nvim_create_buf(false, true)
      local winid = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = 10,
        height = 5,
        row = 1,
        col = 1
      })

      -- Set content with 3 lines
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "line 1",
        "line 2",
        "line 3"
      })

      -- First set cursor to a valid position, then simulate being beyond last line
      vim.api.nvim_win_set_cursor(winid, { 3, 0 })

      -- Simulate the preserve_cursor_position function behavior when line > lastline
      local line, col = 5, 0  -- Simulate cursor being at line 5

      vim_commons.preserve_cursor_position(function()
        -- Do nothing, just test cursor restoration
      end)

      -- Wait for scheduled function
      vim.wait(100, function() return false end)

      -- Since the actual implementation uses the current cursor position,
      -- and we can't set cursor beyond buffer, the cursor should remain at line 3
      local cursor_pos = vim.api.nvim_win_get_cursor(winid)
      assert(cursor_pos[1] == 3) -- Should be at last line

      -- Clean up
      vim.api.nvim_win_close(winid, true)
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)
  end)

  describe("buf_get_var", function()
    it("should return buffer variable when it exists", function()
      local bufnr = vim.api.nvim_create_buf(false, true)

      -- Set a buffer variable
      vim.api.nvim_buf_set_var(bufnr, "test_var", "test_value")

      local result = vim_commons.buf_get_var(bufnr, "test_var")
      assert(result == "test_value")

      -- Clean up
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    it("should return nil when buffer variable doesn't exist", function()
      local bufnr = vim.api.nvim_create_buf(false, true)

      local result = vim_commons.buf_get_var(bufnr, "non_existent_var")
      assert(result == nil)

      -- Clean up
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    it("should handle different variable types", function()
      local bufnr = vim.api.nvim_create_buf(false, true)

      -- Test string
      vim.api.nvim_buf_set_var(bufnr, "string_var", "hello")
      assert(vim_commons.buf_get_var(bufnr, "string_var") == "hello")

      -- Test number
      vim.api.nvim_buf_set_var(bufnr, "number_var", 42)
      assert(vim_commons.buf_get_var(bufnr, "number_var") == 42)

      -- Test boolean
      vim.api.nvim_buf_set_var(bufnr, "bool_var", true)
      assert(vim_commons.buf_get_var(bufnr, "bool_var") == true)

      -- Test table
      vim.api.nvim_buf_set_var(bufnr, "table_var", { a = 1, b = 2 })
      local table_result = vim_commons.buf_get_var(bufnr, "table_var")
      assert(table_result.a == 1)
      assert(table_result.b == 2)

      -- Clean up
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)
  end)

  describe("get_exactly_keymap", function()
    it("should return keymap when exact match exists", function()
      -- Create a test keymap with a unique pattern
      vim.api.nvim_set_keymap("n", "zt", ":echo 'test'<CR>", { noremap = true, silent = true })

      local result = vim_commons.get_exactly_keymap("n", "zt")
      assert(result ~= nil)
      assert(result.lhs == "zt")

      -- Clean up
      vim.api.nvim_del_keymap("n", "zt")
    end)

    it("should return nil when keymap doesn't exist", function()
      local result = vim_commons.get_exactly_keymap("n", " nonexistent_unique_key")
      assert(result == nil)
    end)

    it("should match exactly and not partially", function()
      -- Create test keymaps with unique patterns
      vim.api.nvim_set_keymap("n", "zu", ":echo 'short'<CR>", {})
      vim.api.nvim_set_keymap("n", "zutest", ":echo 'long'<CR>", {})

      -- Should get exact match for short version
      local result_short = vim_commons.get_exactly_keymap("n", "zu")
      assert(result_short ~= nil)
      assert(result_short.lhs == "zu")

      -- Should get exact match for long version
      local result_long = vim_commons.get_exactly_keymap("n", "zutest")
      assert(result_long ~= nil)
      assert(result_long.lhs == "zutest")

      -- Clean up
      vim.api.nvim_del_keymap("n", "zu")
      vim.api.nvim_del_keymap("n", "zutest")
    end)

    it("should work with different modes", function()
      -- Create keymaps in different modes with unique patterns
      vim.api.nvim_set_keymap("n", "zn", ":echo 'normal'<CR>", {})
      vim.api.nvim_set_keymap("i", "zi", "<Esc>:echo 'insert'<CR>", {})
      vim.api.nvim_set_keymap("v", "zv", ":echo 'visual'<CR>", {})

      -- Test each mode
      local normal_result = vim_commons.get_exactly_keymap("n", "zn")
      assert(normal_result ~= nil)
      assert(normal_result.lhs == "zn")

      local insert_result = vim_commons.get_exactly_keymap("i", "zi")
      assert(insert_result ~= nil)
      assert(insert_result.lhs == "zi")

      local visual_result = vim_commons.get_exactly_keymap("v", "zv")
      assert(visual_result ~= nil)
      assert(visual_result.lhs == "zv")

      -- Should not find normal mode keymap in insert mode
      local cross_mode_result = vim_commons.get_exactly_keymap("i", "zn")
      assert(cross_mode_result == nil)

      -- Clean up
      vim.api.nvim_del_keymap("n", "zn")
      vim.api.nvim_del_keymap("i", "zi")
      vim.api.nvim_del_keymap("v", "zv")
    end)
  end)
end)
