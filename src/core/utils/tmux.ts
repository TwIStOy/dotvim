import { system } from "@core/vim";
import { inTmux } from "./env";

function generateInvokeDisplayMessage(name: string) {
  return async () => {
    if (!inTmux()) {
      return null;
    }
    try {
      let cmd = ["tmux", "display-message", "-p", `#{${name}}`];
      let result = await system(cmd);
      if (result.stdout !== null) {
        return result.stdout.trim();
      }
      return null;
    } catch (e) {
      vim.print(e);
      return null;
    }
  };
}

/// Returns if current neovim instance is running in tmux, and the option
/// `allow-passthrough` is enabled.
export async function hasPassthrough(): Promise<boolean> {
  if (!inTmux()) {
    return false;
  }
  try {
    let result = await system(["tmux", "show", "-Apv", "allow-passthrough"]);
    return result.stdout?.endsWith("on\n") ?? false;
  } catch (e) {
    return false;
  }
}

export const getTmuxPid = generateInvokeDisplayMessage("pid");
export const getSocketPath = generateInvokeDisplayMessage("socket_path");
export const getWindowId = generateInvokeDisplayMessage("window_id");
export const getWindowName = generateInvokeDisplayMessage("window_name");
export const getPaneId = generateInvokeDisplayMessage("pane_id");
export const getPanePid = generateInvokeDisplayMessage("pane_pid");
export const getPaneTTY = generateInvokeDisplayMessage("pane_tty");
export const getCursorX = generateInvokeDisplayMessage("cursor_x");
export const getCursorY = generateInvokeDisplayMessage("cursor_y");

export function escape(data: string): string {
  let replaced = data.replaceAll("\x1b", "\x1b\x1b");
  return `\x1bPtmux;${replaced}\x1b\\`;
}
