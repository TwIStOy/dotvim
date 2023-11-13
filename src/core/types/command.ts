import { VimBuffer } from "../../vim_ext";
import { RightClickOpt, MenubarOpt as MenuBarOpt } from "../components";

type MaybePromise<T> = T | Promise<T>;

type CommandEnabledFn = (buf: VimBuffer) => boolean;

export interface Command {
  /**
   * Dislay name for the command
   */
  name: string;
  /**
   * Description for the command
   */
  description?: string;
  /**
   * Category for the command
   */
  category?: string;

  /**
   * Callbacl when the command is executed
   */
  callback: string | ((this: void) => MaybePromise<void>);

  /**
   * Keys that can be used to trigger the command.
   *
   * This will be automatically added to its plugin's `lazy` field.
   */
  keys?: string | string[];

  /**
   * Short description of the command. To be used in `which-key` panel.
   */
  shortDesc?: string;

  /**
   * Decide if the command is enabled for the current buffer.
   */
  enabled?: boolean | CommandEnabledFn;

  /**
   * Options for right click menu.
   */
  rightClick?: RightClickOpt | true;

  /**
   * Options for menu bar.
   */
  menuBar?: MenuBarOpt | true;
}

export interface CommandGroup {
  /**
   * Default category for all commands in this plugin.
   */
  category?: string;
  /**
   * Decide if all commands are enabled for the current buffer, if not specified.
   */
  enabled?: boolean | CommandEnabledFn;
  /**
   * Commands to be registered for this plugin.
   */
  commands: Command[];
}

export function extendCommandsInGroup(group: CommandGroup): Command[] {
  let result: Command[] = [];
  for (let cmd of group.commands) {
    result.push(
      vim.tbl_extend("keep", cmd, {
        category: group.category,
        enabled: group.enabled,
      }) as Command
    );
  }
  return result;
}
