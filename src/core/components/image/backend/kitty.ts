import { inSSH, inTmux } from "@core/utils/env";
import { ImageRenderBackend } from "./base";
import { hasPassthrough } from "@core/utils/tmux";
import {
  escape as tmuxEscape,
  getCursorX as tmuxGetCursorX,
  getCursorY as tmuxGetCursorY,
  getPaneTTY as tmuxGetPaneTTY,
} from "@core/utils/tmux";
import { isNil, sleep } from "@core/vim";
import { Image } from "../image";
import { getTTY } from "@core/utils/term";

const stdout: LuaFile = vim.uv.new_tty(1, false);
const editorTTY = getTTY()!;

async function getClearTTY() {
  if (inTmux()) return undefined;
  let currentTmuxTTY = await tmuxGetPaneTTY();
  if (currentTmuxTTY === editorTTY) return undefined;
  return currentTmuxTTY ?? undefined;
}

export class KittyBackend implements ImageRenderBackend {
  private images: LuaTable<number, Image> = new LuaTable();

  async supported(): Promise<boolean> {
    if (inTmux()) {
      return await hasPassthrough();
    }
    return true;
  }

  /*
   * Delete an image from the backend.
   */
  async delete(image_id: number, shallow?: boolean) {
    let image = this.images.get(image_id);
    if (isNil(image)) return;
    if (image.hasRendered) {
      this._writeGraphics(
        {
          action: "d",
          quiet: 2,
          deleteImages: "i",
          transmission: {
            imageId: image_id,
          },
        },
        undefined,
        await getClearTTY()
      );
    }
    image.hasRendered = false;

    if (isNil(shallow) || !shallow) {
      this.images.delete(image_id);
    }
  }

  async deleteAll() {
    this._writeGraphics(
      {
        action: "d",
        quiet: 2,
        deleteImages: "a",
      },
      undefined,
      await getClearTTY()
    );
    for (let [_, image] of this.images) {
      image.hasRendered = false;
    }
    this.images = new LuaTable();
  }

  private _write(data: string, tty?: string, escape?: boolean) {
    if (data === "") {
      return;
    }
    let payload = data;
    if (escape && inTmux()) {
      payload = tmuxEscape(data);
    }
    if (tty) {
      let [handle] = io.open(tty, "w");
      if (!handle) {
        throw new Error("failed to open tty");
      }
      handle.write(payload);
      handle.close();
    } else {
      stdout.write(payload);
      stdout.flush();
    }
  }

  private _restore_cursor() {
    this._write("\x1b[u");
  }

  private async _move_cursor(x: number, y: number, save: boolean) {
    if (inTmux() && inSSH()) {
      // When tmux is running over ssh, set-cursor sometimes doesn't actually get sent
      // I don't know why this fixes the issue...
      await tmuxGetCursorX();
      await tmuxGetCursorY();
    }

    if (save) {
      this._write("\x1b[s");
    }
    this._write(`\x1b[${y};${x}H`);
    await sleep(1);
  }

  private _update_sync_start() {
    this._write("\x1b[?2026h");
  }

  private _update_sync_end() {
    this._write("\x1b[?2026l");
  }

  private _writeGraphics(
    config: KittyControlData,
    data?: string,
    tty?: string
  ) {
    let controlPayload = packControlData(config);
    if (isNil(data)) {
      this._write(`\x1b_G${controlPayload}\x1b\\`, tty, true);
    } else {
      let [encoded] = string.gsub(vim.base64.encode(data), "%-", "/");
      let chunks = this._splitToChunks(encoded);
      for (let i = 0; i < chunks.length; i++) {
        let chunk = chunks[i];
        let m = i < chunks.length - 1 ? 1 : 0;
        this._write(`\x1b_G${controlPayload},m=${m};${chunk}\x1b\\`, tty, true);
      }
    }
  }

  private _splitToChunks(data: string) {
    let chunks = [];
    // split data into 4k
    for (let i = 0; i < data.length; i += 4096) {
      let slice = data.slice(i, i + 4096);
      if (slice.length > 0) {
        chunks.push(slice);
      }
    }
    return chunks;
  }
}

interface KittyControlData {
  /// The overall action this graphics command is performing.
  /// t - transmit data,
  /// T - transmit data and display image,
  /// q - query terminal,
  /// p - put (display) previous transmitted image,
  /// d - delete image,
  /// f - transmit data for animation frames,
  /// a - control animation,
  /// c - compose animation frames
  action?: "t" | "T" | "q" | "p" | "d" | "f" | "a" | "c";
  /// Suppress responses from the terminal to this graphics command.
  quiet?: 0 | 1 | 2;
  /// What to delete.
  deleteImages?:
    | "a"
    | "A"
    | "c"
    | "C"
    | "n"
    | "N"
    | "i"
    | "I"
    | "p"
    | "P"
    | "q"
    | "Q"
    | "x"
    | "X"
    | "y"
    | "Y"
    | "z"
    | "Z";
  transmission?: {
    /// The format in which the image data is sent.
    format?: 24 | 32 | 100;
    /// The transmission medium used.
    medium?: "d" | "f" | "t" | "s";
    /// The width of the image being sent.
    width?: number;
    /// The height of the image being sent.
    height?: number;
    /// The size of data to read from a file.
    fileSize?: number;
    /// The offset from which to read data from a file.
    fileOffset?: number;
    /// Image id
    imageId?: number;
    /// The image number
    imageNumber?: number;
    /// The placement id
    placement?: number;
    /// The type of data compression.
    compression?: "z";
    /// Whether there is more chunked data available.
    more?: 0;
  };
  display?: {
    /// The left edge (in pixels) of the image area to display
    x?: number;
    /// The top edge (in pixels) of the image area to display
    y?: number;
    /// The width (in pixels) of the image area to display. By default, the entire width is used.
    width?: number;
    /// The height (in pixels) of the image area to display. By default, the entire height is used
    height?: number;
    /// The x-offset within the first cell at which to start displaying the image
    xOffset?: number;
    /// The y-offset within the first cell at which to start displaying the image
    yOffset?: number;
    /// The number of columns to display the image over
    columns?: number;
    /// The number of rows to display the image over
    rows?: number;
    /// Cursor movement policy.
    ///   0 is the default, to move the cursor to after the image.
    ///   1 is to not move the cursor at all when placing the image.
    cursorMovementPolicy?: 0 | 1;
    /// Set to 1 to create a virtual placement for a Unicode placeholder.
    /// 1 is to not move the cursor at all when placing the image.
    virtualPlacehoder?: 0 | 1;
    /// The z-index vertical stacking order of the image
    z?: number;
  };
}

function packControlData(data: KittyControlData): string {
  let parts: string[] = [];

  let tryPart = (k: string, v: any) => {
    if (!isNil(v)) {
      parts.push(`${k}=${v}`);
    }
  };
  let tryParts = (values: [string, any][]) => {
    for (let value of values) {
      tryPart(value[0], value[1]);
    }
  };

  tryParts([
    ["a", data.action],
    ["q", data.quiet],
    ["d", data.deleteImages],
  ]);

  if (!isNil(data.transmission)) {
    let trans = data.transmission;
    tryParts([
      ["f", trans.format],
      ["t", trans.medium],
      ["s", trans.width],
      ["v", trans.height],
      ["S", trans.fileSize],
      ["O", trans.fileOffset],
      ["i", trans.imageId],
      ["I", trans.imageNumber],
      ["p", trans.placement],
      ["o", trans.compression],
      ["m", trans.more],
    ]);
  }

  if (!isNil(data.display)) {
    let display = data.display;
    tryParts([
      ["x", display.x],
      ["y", display.y],
      ["w", display.width],
      ["h", display.height],
      ["X", display.xOffset],
      ["Y", display.yOffset],
      ["c", display.columns],
      ["r", display.rows],
      ["C", display.cursorMovementPolicy],
      ["U", display.virtualPlacehoder],
      ["z", display.z],
    ]);
  }

  return parts.join(",");
}
