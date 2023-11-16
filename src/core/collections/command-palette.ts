import { Cache } from "@core/cache";
import { Command } from "@core/types";
import { VimBuffer } from "@core/vim";
import { Collection } from "./collection";

export class CommandPaletteCollection implements Collection {
  private _commands: Command[] = [];
  private _cache: Cache = new Cache();

  push(cmd: Command) {
    this._commands.push(cmd);
    this._cache.clear();
  }

  getCommands(buffer: VimBuffer) {
    return this._cache.ensure(buffer.asCacheKey(), () => {
      return this._commands.filter((cmd) => {
        if (cmd.enabled === undefined) {
          return true;
        }
        if (typeof cmd.enabled === "boolean") {
          return cmd.enabled;
        }
        return cmd.enabled(buffer);
      });
    });
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
