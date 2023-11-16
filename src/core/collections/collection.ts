import { Command } from "@core/types";
import { VimBuffer } from "@core/vim";

export interface Collection {
  push(cmd: Command): void;

  getCommands(buffer: VimBuffer): Command[];

  mount(buffer: VimBuffer, opt?: any): void;
}
