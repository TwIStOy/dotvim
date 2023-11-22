import { Plugin, PluginOpts } from "@core/model";

function defineCustom(...elements: string[]) {
  let augend = luaRequire("dial.augend");
  return augend.constant.new({
    elements: elements,
    word: true,
    cyclic: true,
  });
}

const spec: PluginOpts<[]> = {
  shortUrl: "monaqa/dial.nvim",
  lazy: {
    event: ["BufReadPost"],
    config: () => {
      let augend = luaRequire("dial.augend");
      let defaultGroup = [
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.integer.alias.binary,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],
        defineCustom("true", "false"),
        defineCustom("yes", "no"),
        defineCustom("YES", "NO"),
        defineCustom("||", "&&"),
        defineCustom("enable", "disable"),
        defineCustom(
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday"
        ),
        defineCustom(
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ),
      ];

      let filetypeGroups = {
        default: [...defaultGroup],
        cpp: [
          ...defaultGroup,
          // glog levels
          defineCustom("Debug", "Info", "Warn", "Error", "Fatal"),
          // pair
          defineCustom("first", "second"),
          defineCustom("true_type", "false_type"),
          defineCustom("uint8_t", "uint16_t", "uint32_t", "uint64_t"),
          defineCustom("int8_t", "int16_t", "int32_t", "int64_t"),
          defineCustom("htonl", "ntohl"),
          defineCustom("htons", "ntohs"),
          defineCustom("ASSERT_EQ", "ASSERT_NE"),
          defineCustom("EXPECT_EQ", "EXPECT_NE"),
          defineCustom("==", "!="),
          defineCustom("static_cast", "dynamic_cast", "reinterpret_cast"),
          defineCustom("private", "public", "protected"),
        ],
        python: [...defaultGroup, defineCustom("True", "False")],
        lua: [...defaultGroup, defineCustom("==", "~=")],
        cmake: [
          ...defaultGroup,
          defineCustom("on", "off"),
          defineCustom("ON", "OFF"),
        ],
        toml: [...defaultGroup, augend.semver.alias.semver],
      };

      (
        luaRequire("dial.config").augends as any as {
          register_group: (arg0: any) => void;
        }
      ).register_group(filetypeGroups);

      vim.keymap.set(["n", "v"], "<C-a>", luaRequire("dial.map").inc_normal(), {
        desc: "dial inc",
      });
      vim.keymap.set(["n", "v"], "<C-x>", luaRequire("dial.map").dec_normal(), {
        desc: "dial dec",
      });

      for (let [ft, _] of filetypeGroups as any as LuaTable<string, any[]>) {
        vim.api.nvim_create_autocmd("FileType", {
          pattern: ft,
          callback: () => {
            vim.keymap.set(
              ["n", "v"],
              "<C-a>",
              luaRequire("dial.map").inc_normal(ft),
              {
                desc: "dial inc",
              }
            );
            vim.keymap.set(
              ["n", "v"],
              "<C-x>",
              luaRequire("dial.map").dec_normal(ft),
              {
                desc: "dial dec",
              }
            );
          },
        });
      }
    },
    keys: [
      {
        [1]: "<C-a>",
        [2]: null,
        desc: "dial inc",
        mode: ["n", "v"],
      },
      {
        [1]: "<C-x>",
        [2]: null,
        desc: "dial dec",
        mode: ["n", "v"],
      },
    ],
  },
  allowInVscode: true,
};

export const plugin = new Plugin(spec);
