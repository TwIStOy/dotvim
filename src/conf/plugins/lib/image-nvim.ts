import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "3rd/image.nvim",
  lazy: {
    lazy: true,
    build: "luarocks --local install magick",
    config: true,
    enabled: false,
    opts: {
      backend: "kitty",
      integrations: {
        markdown: {
          enabled: true,
          clear_in_insert_mode: false,
          download_remote_images: true,
          only_render_image_at_cursor: false,
          filetypes: ["markdown", "vimwiki"],
        },
        neorg: {
          enabled: true,
          clear_in_insert_mode: false,
          download_remote_images: true,
          only_render_image_at_cursor: false,
          filetypes: ["norg"],
        },
      },
      max_width: null,
      max_height: null,
      max_width_window_percentage: null,
      max_height_window_percentage: 50,
      window_overlap_clear_enabled: false,
      window_overlap_clear_ft_ignore: ["cmp_menu", "cmp_docs", ""],
      editor_only_render_when_focused: false,
      tmux_show_only_in_active_window: false,
      hijack_file_patterns: ["*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp"],
    },
  },
};

export const plugin = new Plugin(spec);
