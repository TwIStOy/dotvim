import { inSSH, inTmux } from "./env";
import {
  escape as tmuxEscape,
  getCursorX as tmuxGetCursorX,
  getCursorY as tmuxGetCursorY,
  getPaneTTY as tmuxGetPaneTTY,
} from "@core/utils/tmux";
import { debug_, info } from "./logger";
import { isNil } from "@core/vim";

export function getTTY() {
  let [handle] = io.popen("tty 2>/dev/null");
  if (!handle) return null;
  let result = handle.read("*a");
  handle.close();
  result = result?.trim();
  if (result == "") return null;
  return result;
}

const editorTTY = getTTY()!;
const stdout: LuaFile = vim.uv.new_tty(1, false);

/**
 * Get current destination tty.
 */
export function destinationTTY(): string | null {
  if (!inTmux()) return null;
  let currentTmuxTTY = tmuxGetPaneTTY();
  if (currentTmuxTTY === editorTTY) return null;
  return currentTmuxTTY ?? null;
}

/**
 * Write escape sequence to terminal. If `tty` is specified, write to the
 * specified tty.
 *
 * - Supports tmux.(Requires 'allow-passthrough' enabled)
 * - Support all escape sequence.
 */
export function writeToTTY(data: string, tty: string | null, escape?: boolean) {
  if (data === "") {
    return;
  }
  let payload = data;
  if (escape === true && inTmux()) {
    payload = tmuxEscape(data);
  }
  let [s] = string.gsub(payload, "\x1b", "<Esc>");
  debug_("writeToTTY: %s", s);
  if (tty) {
    let [handle] = io.open(tty, "w");
    if (!handle) {
      throw new Error("failed to open tty");
    }
    handle.write(payload);
    handle.flush();
    handle.close();
  } else {
    stdout.write(payload);
  }
}

let _cache_tty: string | null = null;
let _cached_tty = false;
export function termWrite(data: string, escape?: boolean) {
  if (!_cached_tty) {
    _cached_tty = true;
    _cache_tty = destinationTTY();
  }
  return writeToTTY(data, _cache_tty, escape);
}

export function termSyncStart() {
  writeToTTY("\x1b[?2026h", null);
}

export function termSyncEnd() {
  writeToTTY("\x1b[?2026l", null);
}

export function termMoveCursor(x: number, y: number, save: boolean) {
  if (inTmux() && inSSH()) {
    // When tmux is running over ssh, set-cursor sometimes doesn't actually
    // get sent. I don't know why this fixes the issue...
    tmuxGetCursorX();
    tmuxGetCursorY();
  }
  if (save) {
    writeToTTY("\x1b[s", null);
  }
  writeToTTY(`\x1b[${y};${x}H`, null);
  vim.api.nvim_command("sleep 1m");
}

export function termRestoreCursor() {
  writeToTTY("\x1b[u", null);
}

let _cached_size: {
  screen_x: number;
  screen_y: number;
  screen_cols: number;
  screen_rows: number;
  cell_width: number;
  cell_height: number;
} | null = null;

function updateSize() {
  let ffi = require("ffi") as AnyMod;

  ffi.cdef(`
    typedef struct {
      unsigned short row;
      unsigned short col;
      unsigned short xpixel;
      unsigned short ypixel;
    } winsize;
    int ioctl(int, int, ...);
  `);

  let TIOCGWINSZ = null;
  if (vim.fn.has("linux") == 1) {
    TIOCGWINSZ = 0x5413;
  } else if (vim.fn.has("mac") == 1) {
    TIOCGWINSZ = 0x40087468;
  } else if (vim.fn.has("bsd") == 1) {
    TIOCGWINSZ = 0x40087468;
  }
  let sz: {
    row: number;
    col: number;
    xpixel: number;
    ypixel: number;
  } = ffi.new("winsize");
  assert(ffi.C.ioctl(1, TIOCGWINSZ, sz) == 0, "Failed to get terminal size");
  _cached_size = {
    screen_x: sz.xpixel,
    screen_y: sz.ypixel,
    screen_cols: sz.col,
    screen_rows: sz.row,
    cell_width: sz.xpixel / sz.col,
    cell_height: sz.ypixel / sz.row,
  };
}

updateSize();
vim.api.nvim_create_autocmd("VimResized", {
  callback: () => {
    updateSize();
  },
});

export function termGetSize() {
  return _cached_size!;
}
