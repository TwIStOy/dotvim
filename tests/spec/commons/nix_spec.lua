---@diagnostic disable: undefined-global

local nix = require("dotvim.commons.nix")

describe("dotvim.commons.nix", function()
  local original_vim_system

  before_each(function()
    -- Store original vim.system function
    original_vim_system = vim.system
    -- Clear cache before each test
    nix.clear_vimplugin_cache()
  end)

  after_each(function()
    -- Restore original vim.system function
    vim.system = original_vim_system
    -- Clear cache after each test
    nix.clear_vimplugin_cache()
  end)

  describe("get_all_vimplugin_packages", function()
    it("should return empty table when nix-store command fails", function()
      -- Mock vim.system to return failure
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 1,
              stdout = nil,
              stderr = "Command failed"
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      
      assert(type(result) == "table")
      local count = 0
      for _ in pairs(result) do
        count = count + 1
      end
      assert(count == 0)
    end)

    it("should return empty table when nix-store returns no output", function()
      -- Mock vim.system to return success but no output
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      
      assert(type(result) == "table")
      local count = 0
      for _ in pairs(result) do
        count = count + 1
      end
      assert(count == 0)
    end)

    it("should parse vim plugins from nix-store output correctly", function()
      -- Mock vim.system to return sample nix-store output
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-telescope-nvim-1.0.0\n" ..
                      "/nix/store/def456-vimplugin-nvim-tree-lua-2.1.0\n" ..
                      "/nix/store/ghi789-some-other-package-3.0.0\n" ..
                      "/nix/store/jkl012-vimplugin-lualine-nvim-4.2.1\n",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      
      assert(type(result) == "table")
      
      -- Should contain parsed vim plugins
      assert(result["telescope-nvim"] ~= nil)
      assert(result["telescope-nvim"].path == "/nix/store/abc123-vimplugin-telescope-nvim-1.0.0")
      
      assert(result["nvim-tree-lua"] ~= nil)
      assert(result["nvim-tree-lua"].path == "/nix/store/def456-vimplugin-nvim-tree-lua-2.1.0")
      
      assert(result["lualine-nvim"] ~= nil)
      assert(result["lualine-nvim"].path == "/nix/store/jkl012-vimplugin-lualine-nvim-4.2.1")
      
      -- Should not contain non-vimplugin packages
      assert(result["some-other-package"] == nil)
    end)

    it("should handle malformed vimplugin entries gracefully", function()
      -- Mock vim.system to return output with malformed entries
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-telescope-nvim-1.0.0\n" ..
                      "/nix/store/def456-vimplugin-\n" ..                     -- Missing plugin name
                      "/nix/store/ghi789-vimplugin\n" ..                      -- No dash after vimplugin
                      "/nix/store/jkl012-vimplugin-valid-plugin-2.0.0\n",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      
      assert(type(result) == "table")
      
      -- Should contain valid entries
      assert(result["telescope-nvim"] ~= nil)
      assert(result["valid-plugin"] ~= nil)
      
      -- Should not contain malformed entries
      assert(result[""] == nil)
      assert(result[nil] == nil)
    end)

    it("should cache results to avoid repeated nix-store calls", function()
      local call_count = 0
      
      -- Mock vim.system to count calls
      vim.system = function(cmd, opts)
        call_count = call_count + 1
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-test-plugin-1.0.0\n",
              stderr = nil
            }
          end
        }
      end

      -- First call should execute nix-store
      local result1 = nix.get_all_vimplugin_packages()
      assert(call_count == 1)
      assert(result1["test-plugin"] ~= nil)

      -- Second call should use cache, not call nix-store again
      local result2 = nix.get_all_vimplugin_packages()
      assert(call_count == 1) -- Should still be 1
      assert(result2["test-plugin"] ~= nil)

      -- Results should be identical
      assert(result1["test-plugin"].path == result2["test-plugin"].path)
    end)

    it("should call nix-store with correct command and options", function()
      local captured_cmd = nil
      local captured_opts = nil
      
      -- Mock vim.system to capture arguments
      vim.system = function(cmd, opts)
        captured_cmd = cmd
        captured_opts = opts
        return {
          wait = function()
            return {
              code = 0,
              stdout = "",
              stderr = nil
            }
          end
        }
      end

      nix.get_all_vimplugin_packages()
      
      -- Check that correct command was called
      assert(captured_cmd ~= nil)
      assert(type(captured_cmd) == "table")
      assert(captured_cmd[1] == "nix-store")
      assert(captured_cmd[2] == "--query")
      assert(captured_cmd[3] == "--requisites")
      assert(captured_cmd[4] == "/run/current-system")
      
      -- Check that correct options were passed
      assert(captured_opts ~= nil)
      assert(captured_opts.text == true)
    end)

    it("should handle plugins with complex names containing dashes and numbers", function()
      -- Mock vim.system to return plugins with complex names
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-nvim-lsp-installer-1.2.3\n" ..
                      "/nix/store/def456-vimplugin-vim-airline-themes-0.5.0\n" ..
                      "/nix/store/ghi789-vimplugin-alpha-nvim-2023-11-15\n",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      
      assert(result["nvim-lsp-installer"] ~= nil)
      assert(result["vim-airline-themes"] ~= nil)
      assert(result["alpha-nvim-2023-11"] ~= nil)
    end)

    it("should handle empty lines and whitespace in nix-store output", function()
      -- Mock vim.system to return output with empty lines and whitespace
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "\n\n/nix/store/abc123-vimplugin-test-plugin-1.0.0\n\n  \n" ..
                      "/nix/store/def456-vimplugin-another-plugin-2.0.0\n\n",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      
      assert(result["test-plugin"] ~= nil)
      assert(result["another-plugin"] ~= nil)
    end)
  end)

  describe("clear_vimplugin_cache", function()
    it("should clear the cache and force re-query on next call", function()
      local call_count = 0
      
      -- Mock vim.system to count calls
      vim.system = function(cmd, opts)
        call_count = call_count + 1
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-test-plugin-1.0.0\n",
              stderr = nil
            }
          end
        }
      end

      -- First call should execute nix-store
      nix.get_all_vimplugin_packages()
      assert(call_count == 1)

      -- Second call should use cache
      nix.get_all_vimplugin_packages()
      assert(call_count == 1)

      -- Clear cache
      nix.clear_vimplugin_cache()

      -- Next call should execute nix-store again
      nix.get_all_vimplugin_packages()
      assert(call_count == 2)
    end)

    it("should be safe to call multiple times", function()
      -- Should not error when called multiple times
      nix.clear_vimplugin_cache()
      nix.clear_vimplugin_cache()
      nix.clear_vimplugin_cache()
      
      -- Should still work normally after multiple clears
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-test-plugin-1.0.0\n",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      assert(result["test-plugin"] ~= nil)
    end)

    it("should be safe to call when cache is already empty", function()
      -- Should not error when called on empty cache
      nix.clear_vimplugin_cache()
      
      -- Should work normally after clearing empty cache
      vim.system = function(cmd, opts)
        return {
          wait = function()
            return {
              code = 0,
              stdout = "/nix/store/abc123-vimplugin-test-plugin-1.0.0\n",
              stderr = nil
            }
          end
        }
      end

      local result = nix.get_all_vimplugin_packages()
      assert(result["test-plugin"] ~= nil)
    end)
  end)

  describe("integration scenarios", function()
    it("should handle mixed scenarios with cache operations", function()
      local call_count = 0
      
      vim.system = function(cmd, opts)
        call_count = call_count + 1
        if call_count == 1 then
          return {
            wait = function()
              return {
                code = 0,
                stdout = "/nix/store/abc123-vimplugin-first-plugin-1.0.0\n",
                stderr = nil
              }
            end
          }
        else
          return {
            wait = function()
              return {
                code = 0,
                stdout = "/nix/store/def456-vimplugin-second-plugin-2.0.0\n",
                stderr = nil
              }
            end
          }
        end
      end

      -- First query
      local result1 = nix.get_all_vimplugin_packages()
      assert(call_count == 1)
      assert(result1["first-plugin"] ~= nil)
      assert(result1["second-plugin"] == nil)

      -- Cached query
      local result2 = nix.get_all_vimplugin_packages()
      assert(call_count == 1) -- Still cached
      assert(result2["first-plugin"] ~= nil)
      assert(result2["second-plugin"] == nil)

      -- Clear and query again
      nix.clear_vimplugin_cache()
      local result3 = nix.get_all_vimplugin_packages()
      assert(call_count == 2) -- New query
      assert(result3["first-plugin"] == nil)
      assert(result3["second-plugin"] ~= nil)
    end)
  end)
end)
