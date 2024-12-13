---@type dotvim.utils
local Utils = require("dotvim.utils")

local function get_lsp_server_name_from_ctx(ctx)
  if ctx.source_name ~= "LSP" then
    return
  end

  local client_id = vim.tbl_get(ctx, "item", "client_id")
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

local function remove_first_space_or_marker(str)
  if str:sub(1, 1) == " " then
    return str:sub(2)
  end
  if str:sub(1, #CLANGD_MARKER) == CLANGD_MARKER then
    return str:sub(#CLANGD_MARKER + 1)
  end
  return str
end

---@type dotvim.core.plugin.PluginOption
return {
  "saghen/blink.cmp",
  lazy = false,
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
  opts_extend = { "sources.default" },
  opts = {
    keymap = {
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
      providers = {},
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
        selection = "auto_insert",
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
            -- { "label", "label_description", gap = 3 },
          },
          align_to_component = "label",
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
              width = { max = 60 },
              text = function(ctx)
                local lsp_client_name = get_lsp_server_name_from_ctx(ctx)
                if lsp_client_name == "clangd" then
                  -- Special handling for clangd.
                  --
                  -- Clangd adds an extra space at the beginning of the label, or a marker to
                  -- indicate the completion item will add the missing include statement at the same time.
                  --
                  -- This is a workaround to remove the extra space or marker. If marker is present, will change
                  -- the label description later.
                  return remove_first_space_or_marker(ctx.label)
                    .. ctx.label_detail
                end
                return ctx.label .. ctx.label_detail
              end,
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  {
                    0,
                    #ctx.label,
                    group = ctx.deprecated and "BlinkCmpLabelDeprecated"
                      or "BlinkCmpLabel",
                  },
                }
                if ctx.label_detail then
                  table.insert(highlights, {
                    #ctx.label,
                    #ctx.label + #ctx.label_detail,
                    group = "BlinkCmpLabelDetail",
                  })
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(
                    highlights,
                    { idx, idx + 1, group = "BlinkCmpLabelMatch" }
                  )
                end

                return highlights
              end,
            },
            label_description = {
              text = function(ctx)
                if ctx.source_name == "LSP" then
                  local menu_text = vim.F.if_nil(
                    require("dotvim.extra.lsp").get_lsp_item_import_location(
                      ctx.item,
                      ctx.source
                    ),
                    ""
                  )
                  if #menu_text > 0 then
                    if get_lsp_server_name_from_ctx(ctx) == "clangd" then
                      if ctx.item.label:sub(1, 1) == " " then
                        return " " .. menu_text
                      elseif
                        ctx.item.label:sub(1, #CLANGD_MARKER) == CLANGD_MARKER
                      then
                        return CLANGD_MARKER .. menu_text
                      end
                    end
                    return menu_text
                  end
                end
                return ctx.label_description
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
