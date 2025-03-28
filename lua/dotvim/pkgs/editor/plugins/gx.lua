---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "TwIStOy/gx.nvim",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "browse-current" },
    },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      ---@diagnostic disable-next-line: undefined-field
      local sysname = vim.loop.os_uname().sysname

      local locate_kitten_executable = function()
        if vim.fn.executable("kitten") == 1 then
          return "kitten"
        end
        if
          vim.fn.filereadable(
            os.getenv("HOME") .. "/.local/kitty.app/bin/kitten"
          ) == 1
        then
          return os.getenv("HOME") .. "/.local/kitty.app/bin/kitten"
        end
        return nil
      end

      local try_kitty_remote_control = function()
        local executable = locate_kitten_executable()
        if executable == nil then
          return nil
        end
        -- try "kitten @ ls" to determine if is running in kitty and remote_control enabled
        ---@type vim.SystemCompleted
        local ret = vim.system({ executable, "@", "ls" }, {}):wait()
        if ret.code == 0 then
          return executable
        else
          return nil
        end
      end

      local function get_open_browser_app_and_args()
        if sysname == "Darwin" then
          return "open", { "--background" }
        elseif sysname == "Linux" then
          local is_SSH = (vim.env.SSH_CLIENT ~= nil) or (vim.env.SSH_TTY ~= nil)
          local kitten = try_kitty_remote_control()
          if is_SSH and kitten ~= nil then
            return kitten, { "@", "run", "open" }
          else
            return "xdg-open", {
              "--background",
            }
          end
        elseif sysname == "Windows_NT" then
          return "powershell.exe",
            {
              "start",
              "explorer.exe",
              "--background",
            }
        end
      end

      local cmd, args = get_open_browser_app_and_args()
      vim.print { cmd, args }

      require("gx").setup {
        open_browser_app = cmd,
        open_browser_args = args,
        open_browser_options = { detach = true },
        handlers = {
          plugin = true,
          rust = { -- custom handler to open rust's cargo packages
            filetype = { "toml" },
            filename = "Cargo.toml",
            handle = function(mode, line, _)
              local crate =
                require("gx.helper").find(line, mode, "([%w_-]+)%s-=%s")
              if crate then
                return "https://docs.rs/" .. crate
              end
            end,
          },
        },
      }
    end,
  },
}
