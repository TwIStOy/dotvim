import { VimBuffer } from "@core/vim";
import { RightClickOpt, MenuBarOpt as MenuBarOpt } from "@core/components";
import { tblExtend } from "@core/utils";

type MaybePromise<T> = T | Promise<T>;

export type CommandEnabledFn = (buf: VimBuffer) => boolean;

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

  rightClick?: Required<Pick<RightClickOpt, "path">>;

  menuBar?: Required<Pick<MenuBarOpt, "path">>;
}

export function extendCommandsInGroup(
  group: CommandGroup,
  defaultValues: Omit<CommandGroup, "commands" | "rightClick"> = {}
): Command[] {
  let result: Command[] = [];
  for (let cmd of group.commands) {
    let ret = tblExtend(
      "keep",
      cmd,
      {
        category: group.category,
        enabled: group.enabled,
      },
      defaultValues
    );
    if (group.rightClick && ret.rightClick !== undefined) {
      if (ret.rightClick === true) {
        ret.rightClick = tblExtend(
          "keep",
          {
            title: cmd.name,
            index: 1000, // a large number
          },
          group.rightClick
        );
      } else {
        ret.rightClick = tblExtend("keep", ret.rightClick, group.rightClick);
      }
    }
    result.push(ret);
  }
  return result;
}

export function invokeCommand(cmd: Command) {
  if (typeof cmd.callback === "string") {
    vim.api.nvim_command(cmd.callback);
  } else {
    cmd.callback();
  }
}

export function buildSimpleCommand(
  name: string,
  callback: string | (() => void),
  description?: string
): Command {
  return {
    name,
    callback,
    description,
  };
}
