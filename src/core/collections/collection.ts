import { Cache } from "@core/cache";
import { Command } from "@core/types";
import { VimBuffer } from "@core/vim";

export abstract class Collection {
  protected _commands: Command[] = [];
  protected _cache: Cache = new Cache();

  cosntructor() {}

  push(cmd: Command): void {
    this._commands.push(cmd);
    this._cache.clear();
  }

  getCommands(buffer: VimBuffer): Command[] {
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

  abstract mount(buffer: VimBuffer, opt?: any): void;
}
