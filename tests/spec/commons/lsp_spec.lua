local lsp_commons = require("dotvim.commons.lsp")

describe("dotvim.commons.lsp", function()
  describe("on_lsp_attach", function()
    it("should register LspAttach autocmd", function()
      local callback_called = false
      local received_client = nil
      local received_buffer = nil

      -- Register the callback
      lsp_commons.on_lsp_attach(function(client, buffer)
        callback_called = true
        received_client = client
        received_buffer = buffer
        return true
      end)

      -- Create a test buffer
      local test_bufnr = vim.api.nvim_create_buf(false, true)

      -- Simulate LspAttach event
      vim.api.nvim_exec_autocmds("LspAttach", {
        buffer = test_bufnr,
        data = { client_id = 1 }
      })

      -- Wait a bit for autocmd to process
      vim.wait(10, function() return callback_called end)

      assert(callback_called == true)
      assert(received_buffer == test_bufnr)
      -- Note: received_client might be nil if no LSP client with id 1 exists

      -- Clean up
      vim.api.nvim_buf_delete(test_bufnr, { force = true })
    end)

    it("should handle multiple callbacks", function()
      local callback1_called = false
      local callback2_called = false

      -- Register first callback
      lsp_commons.on_lsp_attach(function(client, buffer)
        callback1_called = true
      end)

      -- Register second callback
      lsp_commons.on_lsp_attach(function(client, buffer)
        callback2_called = true
      end)

      local test_bufnr = vim.api.nvim_create_buf(false, true)

      -- Trigger event
      vim.api.nvim_exec_autocmds("LspAttach", {
        buffer = test_bufnr,
        data = { client_id = 1 }
      })

      vim.wait(10, function() return callback1_called and callback2_called end)

      assert(callback1_called == true)
      assert(callback2_called == true)

      -- Clean up
      vim.api.nvim_buf_delete(test_bufnr, { force = true })
    end)

    it("should pass correct buffer and client information", function()
      local test_buffer = nil
      local test_client_id = nil

      lsp_commons.on_lsp_attach(function(client, buffer)
        test_buffer = buffer
        if client then
          test_client_id = client.id
        end
      end)

      local test_bufnr = vim.api.nvim_create_buf(false, true)
      local mock_client_id = 42

      vim.api.nvim_exec_autocmds("LspAttach", {
        buffer = test_bufnr,
        data = { client_id = mock_client_id }
      })

      vim.wait(10, function() return test_buffer ~= nil end)

      assert(test_buffer == test_bufnr)
      -- Note: test_client_id will be nil if client 42 doesn't exist

      -- Clean up
      vim.api.nvim_buf_delete(test_bufnr, { force = true })
    end)

    it("should handle callback return values", function()
      local return_true_called = false
      local return_false_called = false
      local return_nil_called = false

      -- Callback that returns true
      lsp_commons.on_lsp_attach(function(client, buffer)
        return_true_called = true
        return true
      end)

      -- Callback that returns false  
      lsp_commons.on_lsp_attach(function(client, buffer)
        return_false_called = true
        return false
      end)

      -- Callback that returns nil (implicit)
      lsp_commons.on_lsp_attach(function(client, buffer)
        return_nil_called = true
      end)

      local test_bufnr = vim.api.nvim_create_buf(false, true)

      vim.api.nvim_exec_autocmds("LspAttach", {
        buffer = test_bufnr,
        data = { client_id = 1 }
      })

      vim.wait(50, function() 
        return return_true_called and return_false_called and return_nil_called 
      end)

      assert(return_true_called == true)
      assert(return_false_called == true)
      assert(return_nil_called == true)

      -- Clean up
      vim.api.nvim_buf_delete(test_bufnr, { force = true })
    end)

    it("should handle missing client_id gracefully", function()
      local callback_called = false
      local received_client = "not_set"

      lsp_commons.on_lsp_attach(function(client, buffer)
        callback_called = true
        received_client = client
      end)

      local test_bufnr = vim.api.nvim_create_buf(false, true)

      -- Trigger event without client_id in data
      vim.api.nvim_exec_autocmds("LspAttach", {
        buffer = test_bufnr,
        data = {}
      })

      vim.wait(10, function() return callback_called end)

      assert(callback_called == true)
      assert(received_client == nil) -- Should be nil when no valid client_id

      -- Clean up
      vim.api.nvim_buf_delete(test_bufnr, { force = true })
    end)
  end)
end)
