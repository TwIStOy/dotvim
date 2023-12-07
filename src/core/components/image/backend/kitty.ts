import { inTmux } from "@core/utils/env";
import { debug_, warn } from "@core/utils/logger";
import { termSyncEnd, termSyncStart, termWrite } from "@core/utils/term";
import { hasPassthrough } from "@core/utils/tmux";
import { isNil } from "@core/vim";
import { encode_bytes } from "ht.utils.base64";
import { Image } from "../image";
import { ImageRenderBackend } from "./base";
import { callOnce } from "@core/utils/fn";

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
    placementId?: number;
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
      ["p", trans.placementId],
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

interface RenderedImage {
  image: Image;
  x?: number;
  y?: number;
  z?: number;
}

export class KittyBackend implements ImageRenderBackend {
  private images: LuaTable<number, RenderedImage> = new LuaTable();

  constructor() {
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback: () => {
        this.deleteAll();
      },
    });
    // TODO(hawtian): other events
  }

  supported(): boolean {
    if (inTmux()) {
      return hasPassthrough();
    }
    return true;
  }

  /*
   * Delete an image from the backend.
   */
  delete(image_id: number, shallow?: boolean) {
    let image = this.images.get(image_id);
    if (isNil(image)) return;
    if (image.image.rendered) {
      this.writeGraphics({
        action: "d",
        quiet: 2,
        deleteImages: "i",
        transmission: {
          imageId: image_id,
        },
      });
    }
    image.image.rendered = false;

    if (isNil(shallow) || !shallow) {
      this.images.delete(image_id);
    }
  }

  deleteAll() {
    this.writeGraphics({
      action: "d",
      // quiet: 2,
    });
    for (let [_, image] of this.images) {
      image.image.rendered = false;
    }
    this.images = new LuaTable();
  }

  writeGraphics(config: KittyControlData, data?: string | any[]) {
    let controlPayload = packControlData(config);
    if (isNil(data)) {
      debug_("controlPayload: %s", controlPayload);
      termWrite(`\x1b_G${controlPayload}\x1b\\`, true);
    } else {
      let encoded;
      if (typeof data === "string") {
        [encoded] = string.gsub(vim.base64.encode(data), "%-", "/");
      } else {
        [encoded] = string.gsub(encode_bytes(data), "%-", "/");
      }
      let chunks = KittyBackend._splitToChunks(encoded);
      for (let i = 0; i < chunks.length; i++) {
        let chunk = chunks[i];
        let m = i < chunks.length - 1 ? 1 : 0;
        if (i == 0) {
          termWrite(`\x1b_G${controlPayload},m=${m};${chunk}\x1b\\`, true);
        } else {
          let q = isNil(config.quiet) ? "" : `,q=${config.quiet}`;
          termWrite(`\x1b_Gm=${m}${q};${chunk}\x1b\\`, true);
        }
      }
    }
  }

  private static _splitToChunks(data: string) {
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

export const kittyBackend = new KittyBackend();
