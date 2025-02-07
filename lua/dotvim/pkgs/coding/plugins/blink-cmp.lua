---@type dotvim.utils
local Utils = require("dotvim.utils")

local function get_lsp_server_name_from_item(item)
  local client_id = vim.tbl_get(item, "client_id")
  if client_id == nil then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if client == nil then
    return
  end

  return client.name
end

local CLANGD_MARKER = "•"

local function update_clangd_completion_item(item)
  local label = item.label
  if label:sub(1, 1) == " " then
    item.label = label:sub(2)
  elseif label:sub(1, #CLANGD_MARKER) == CLANGD_MARKER then
    item.label = label:sub(#CLANGD_MARKER + 1)
    item.clangd_marker = true
  end
end

---@type dotvim.core.plugin.PluginOption
return {
  "saghen/blink.cmp",
  version = false,
  build = (function()
    if Utils.nix.is_nix_managed() then
      return "nix run .#build-plugin"
    else
      return "cargo build --release"
    end
  end)(),
  enabled = function()
    return vim.g.dotvim_completion_engine == "blink-cmp"
  end,
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
  dependencies = {
    {
      "xzbdmw/colorful-menu.nvim",
      opts = {},
    },
  },
  opts_extend = { "sources.default" },
  opts = {
    fuzzy = {
      prebuilt_binaries = {
        download = false,
      },
    },
    keymap = {
      preset = "none",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    appearance = {
      -- use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "buffer" },
      cmdline = {},
      transform_items = function(_, items)
        for _, item in ipairs(items) do
          if
            item.kind == require("blink.cmp.types").CompletionItemKind.Snippet
          then
            item.score_offset = item.score_offset - 3
          end

          local lsp_client_name = get_lsp_server_name_from_item(item)
          if lsp_client_name == "clangd" then
            -- Special handling for clangd.
            --
            -- Clangd adds an extra space at the beginning of the label, or a marker to
            -- indicate the completion item will add the missing include statement at the same time.
            --
            -- This is a workaround to remove the extra space or marker. If marker is present, will change
            -- the label description later.
            update_clangd_completion_item(item)
          end
        end
        return items
      end,
    },
    snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
      menu = {
        scrolloff = 2,
        scrollbar = true,
        -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        border = "none",
        draw = {
          gap = 1,
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
          align_to = "label",
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. " " .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return require("blink.cmp.completion.windows.render.tailwind").get_hl(
                  ctx
                ) or ("BlinkCmpKind" .. ctx.kind)
              end,
            },
            label = {
              -- text = function(ctx)
              --   return require("colorful-menu").blink_components_text(ctx)
              -- end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
            label_description = {
              text = function(ctx)
                local res = (function()
                  if ctx.source_name == "LSP" then
                    local menu_text = vim.F.if_nil(
                      require("dotvim.extra.lsp").get_lsp_item_import_location(
                        ctx.item,
                        ctx.source
                      ),
                      ""
                    )
                    if #menu_text > 0 then
                      if ctx.item.clangd_marker then
                        return CLANGD_MARKER .. menu_text
                      end
                      return menu_text
                    end
                  end
                  if
                    ctx.item ~= nil
                    and ctx.item.label_description ~= nil
                    and ctx.item.label_description ~= ""
                  then
                    return ctx.item.label_description
                  elseif
                    ctx.item ~= nil
                    and ctx.item.label_details ~= nil
                    and ctx.item.label_details ~= ""
                  then
                    return ctx.item.label_details
                  end
                  return ctx.label_description
                end)()
                if res == nil then
                  return ""
                end
                res = res:gsub("\n", "")
                return res
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
          -- winhighlight = "FloatBorder:FloatBorder",
          scrollbar = true,
        },
      },
    },
    signature = { enabled = true },
  },
}
