import { Plugin, PluginOpts } from "@core/model";
import { highlightFg, isNil } from "@core/vim";

const options = {
  component_separators: { left: "|", right: "|" },
  section_separators: {
    left: "",
    right: "",
  },

  theme: "auto",
  globalstatus: true,
};

function cwd() {
  let cwd = vim.fn.getcwd();
  let home = os.getenv("HOME");
  let [match] = string.find(cwd, home!, 1, true);
  if (match === 1) {
    cwd = `~${string.sub(cwd, home!.length + 1)}`;
  }
  return `  ${cwd}`;
}

function rimeState() {
  if (!isNil(vim.g.get("global_rime_enabled"))) {
    return "ㄓ";
  } else {
    return "";
  }
}

const componentMode = {
  [1]: "mode",
  icons_enabled: true,
  icon: {
    [1]: " ",
    align: "left",
  },
};

function componentFileInfo() {
  let icon = "󰈚 ";
  let currentFile = vim.fn.expand("%");
  let filename;
  if (currentFile === "") {
    filename = "Empty ";
  } else {
    filename = vim.fn.fnamemodify(currentFile, ":.");
    let [deviconsPresent, devicons] = pcall(__raw_import, "nvim-web-devicons");
    if (deviconsPresent) {
      let ftIcon: string | null = (devicons as AnyMod).get_icon(filename);
      if (ftIcon !== null) {
        icon = `${ftIcon} `;
      }
      // fix md icon a little small
      if (vim.fn.expand("%:e") === "md") {
        icon = `${icon} `;
      }
    }
  }
  return `${icon}${filename}`;
}

const spec: PluginOpts = {
  shortUrl: "hoob3rt/lualine.nvim",
  lazy: {
    event: "VeryLazy",
    dependencies: ["nvim-tree/nvim-web-devicons"],
    opts: {
      options,
      sections: {
        lualine_a: [componentMode],
        lualine_b: [cwd],
        lualine_c: [
          {
            [1]: componentFileInfo,
            separator: "",
          },
          {
            [1]: () => {
              let lsp = luaRequire("ht.with_plug.lsp");
              return lsp.progress();
            },
            separator: "",
          },
        ],
        lualine_x: [
          {
            [1]: "diagnostics",
            sources: ["nvim_diagnostic"],
            sections: ["error", "warn", "info", "hint"],
            diagnostics_color: {
              error: { fg: highlightFg("DiagnosticError") },
              warn: { fg: highlightFg("DiagnosticWarn") },
              info: { fg: highlightFg("DiagnosticInfo") },
              hint: { fg: highlightFg("DiagnosticHint") },
            },
            symbols: {
              error: " ",
              warn: " ",
              info: "󰛩 ",
              hint: " ",
            },
            colored: true,
            update_in_insert: false,
            always_visible: false,
          },
          "branch",
          "diff",
        ],
        lualine_y: [
          rimeState,
          {
            [1]: "filetype",
            colored: true,
            icon_only: false,
          },
        ],
        lualine_z: ["progress", "location"],
      },
      tabline: {},
      extensions: {},
    },
  },
};

export const plugin = new Plugin(spec);
