import { Command } from "@core/types";
import { VimBuffer } from "@core/vim";
import { Collection } from "./collection";

export class CommandPaletteCollection extends Collection {
  constructor() {
    super();
  }

  mount(buffer: VimBuffer, opts?: any): void {
    let commands = this.getCommands(buffer);
    let categoryWidth = commands.reduce((acc, cmd) => {
      return Math.max(acc, cmd.category?.length ?? 0);
    }, 0);
    let titleWidth = commands.reduce((acc, cmd) => {
      return Math.max(acc, cmd.name.length);
    }, 0);

    luaRequire("telescope.pickers")
      .new(opts, {
        prompt_title: "Command Palette",
        sorter: luaRequire("telescope.config").values.generic_sorter(opts),
        finder: luaRequire("telescope.finders").new_table({
          results: commands,
          entry_maker: generateEntryMaker(categoryWidth, titleWidth),
        }),
        previewer: false,
        attach_mappings: (bufnr: number, map: any) => {
          map("i", "<CR>", () => {
            let entry: TelescopeEntry<Command> = luaRequire(
              "telescope.actions.state"
            ).get_selected_entry();
            luaRequire("telescope.actions").close(bufnr);
            if (entry !== null) {
              if (typeof entry.value.callback === "string") {
                vim.api.nvim_command(entry.value.callback);
              } else {
                entry.value.callback();
              }
            }
            return true;
          });
        },
      })
      .find();
  }
}

function generateEntryMaker(
  categoryWidth: number,
  titleWidth: number
): (cmd: Command) => TelescopeEntry<Command> {
  let displayer = luaRequire("telescope.pickers.entry_display").create({
    separator: " | ",
    items: [
      { width: categoryWidth, right_justify: true },
      { width: titleWidth },
    ],
  });

  let makeDisplay = (entry: TelescopeEntry<Command>) => {
    return displayer([
      [entry.value.category, "@variable.builtin"],
      entry.value.name,
    ]);
  };

  return (entry) => {
    return {
      value: entry,
      display: makeDisplay,
      ordinal: entry.category + entry.name,
    };
  };
}
