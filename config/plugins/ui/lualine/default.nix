{
  lib,
  utils,
  ...
}: let
  comp = name: {__raw = "_G.dotvim_lualine_${name}";};
in {
  imports = utils.path.listModules ./.;

  extraConfigLuaPre = lib.mkBefore ''
    do
      local function resolve_hl_attr(group, attr)
        local info = vim.api.nvim_get_hl(0, {
          name = group,
          create = false,
        })
        if info == nil then return "NONE" end
        if info.link then return resolve_hl_attr(info.link, attr) end
        if info[attr] == nil then return "NONE" end
        return string.format("#%06x", info[attr])
      end
      _G.dotvim_resolve_fg = function(group) return resolve_hl_attr(group, "fg") end
      _G.dotvim_resolve_bg = function(group) return resolve_hl_attr(group, "bg") end

      local function throttle(delay, callback)
        local running = false
        return function(...)
          if running then return end
          local args = { ... }
          local wrapped = function()
            running = false
            callback(unpack(args))
          end
          vim.defer_fn(wrapped, delay)
          running = true
        end
      end
      _G.dotvim_throttle = throttle

      local function hl_fg(name)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        local fg = hl.fg
        if fg ~= nil and fg ~= "" then
          return string.format("#%x", fg)
        end
        return ""
      end
      _G.dotvim_hl_fg = hl_fg
    end
  '';

  plugins.lualine = {
    enable = true;
    autoLoad = true;

    settings = {
      options = {
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
        theme = "auto";
        globalstatus = true;
        disabled_filetypes = {
          statusline = ["snacks_dashboard" "dashboard" "alpha" "starter"];
        };
        always_divide_middle = true;
        padding = 0;
      };

      sections = {
        lualine_a = [(comp "space") (comp "mode")];
        lualine_b = [(comp "space")];
        lualine_c = [
          (comp "cwd")
          (comp "file")
          (comp "space")
          (comp "branch")
          (comp "diff")
          (comp "space")
          (comp "macro")
          (comp "search_count")
          (comp "c_preproc")
        ];
        lualine_x = [
          (comp "lsp_progress")
          (comp "space")
          (comp "diagnostics")
        ];
        lualine_y = [
          (comp "empty")
        ];
        lualine_z = [(comp "lsp_servers")];
      };

      inactive_sections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = [(comp "file")];
        lualine_x = ["location"];
        lualine_y = [];
        lualine_z = [];
      };

      tabline = {};

      extensions = [
        {
          filetypes = ["neo-tree"];
          sections = {
            lualine_a = [
              {
                __raw = ''
                  {
                    function()
                      return " " .. "Neo-tree"
                    end,
                    separator = { left = "", right = "" },
                  }
                '';
              }
            ];
            lualine_b = [(comp "space")];
            lualine_c = [(comp "cwd")];
          };
        }
        {
          filetypes = ["toggleterm"];
          sections = {
            lualine_a = [
              {
                __raw = ''
                  {
                    function()
                      return "ToggleTerm #" .. vim.b.toggle_number
                    end,
                    separator = { left = "", right = "" },
                  }
                '';
              }
            ];
            lualine_b = [(comp "space")];
            lualine_c = [
              (comp "cwd")
              {
                __raw = ''
                  {
                    function()
                      return vim.fn.getcwd()
                    end,
                    color = {
                      bg = _G.dotvim_resolve_bg("CursorLine"),
                      fg = _G.dotvim_resolve_fg("Normal"),
                    },
                    separator = { left = "", right = "" },
                    padding = { left = 1 },
                  }
                '';
              }
            ];
          };
        }
      ];
    };
  };
}
