import {
  termGetSize,
  termMoveCursor,
  termRestoreCursor,
  termSyncEnd,
  termSyncStart,
} from "@core/utils/term";
import { ifNil, isNil } from "@core/vim";
import { debug_, info } from "@core/utils/logger";
import { KittyBackend } from "./backend/kitty";
import {
  escape as tmuxEscape,
  getCursorX as tmuxGetCursorX,
  getCursorY as tmuxGetCursorY,
  getPaneTop as tmuxGetPeneTop,
  getPaneLeft as tmuxGetPaneLeft,
} from "@core/utils/tmux";
import { inTmux } from "@core/utils/env";

let _nextInternalId = 110;

export type ImageFormat = "rgba" | "rgb" | "png";

function toFormatCode(format: ImageFormat) {
  switch (format) {
    case "rgba":
      return 32;
    case "rgb":
      return 24;
    case "png":
      return 100;
    default:
      throw new Error(`unknown format: ${format}`);
  }
}

/**
 * Represents an image.
 */
export class Image {
  public id: number;
  public format: ImageFormat;
  public data: string | number[];
  public rendered = false;

  private constructor(data: string | number[], format: ImageFormat = "png") {
    _nextInternalId = (_nextInternalId + 1) & 0x7fffffff;
    this.id = _nextInternalId;
    this.format = format;
    this.data = data;
    info("Image id: %d, size: %d, f: %s", this.id, data.length, this.format);
  }

  static fromFile(path: string) {
    // read content
    if (!path.endsWith(".png")) {
      throw new Error("only png is supported");
    }
    let [file] = io.open(path);
    if (isNil(file)) {
      throw new Error(`failed to open file: ${path}`);
    }
    let data = file.read("*a");
    file.close();
    if (isNil(data)) {
      throw new Error(`failed to read file: ${path}`);
    }
    return new Image(data);
  }

  static fromBuffer(buf: number[]) {
    return new Image(buf);
  }

  _transmit() {
    KittyBackend.getInstance().writeGraphics(
      {
        action: "t",
        quiet: 2,
        transmission: {
          imageId: this.id,
          format: toFormatCode(this.format),
          placementId: this.id,
        },
        display: {
          cursorMovementPolicy: 1,
        },
      },
      this.data
    );
  }

  /**
   * Renders the image to the terminal.
   */
  render(x?: number, y?: number, z?: number) {
    if (this.rendered) {
      this.clear();
    }
    // termSyncStart();
    if (inTmux()) {
      // relative position is not supported in tmux, calculate current cursor pos
      let pane_left = tonumber(tmuxGetPaneLeft())!;
      let pane_top = tonumber(tmuxGetPeneTop())!;
      let cursor_x = tonumber(tmuxGetCursorX())!;
      let cursor_y = tonumber(tmuxGetCursorY())!;
      debug_(
        "pane_left: %d, pane_top: %d, cursor_x: %d, cursor_y: %d",
        pane_left,
        pane_top,
        cursor_x,
        cursor_y
      );
      let left_cells = pane_left + cursor_x;
      let top_cells = pane_top + cursor_y;
      let termSize = termGetSize();
      x = (ifNil(x, 0) + left_cells) * termSize.cell_width;
      y = (ifNil(y, 0) + top_cells) * termSize.cell_height;
      debug_("termSize: %s", vim.inspect(termSize));
    }
    debug_("render image at (%s, %s)", x, y);
    this._transmit();
    vim.wait(10, () => {
      return false;
    });
    KittyBackend.getInstance().writeGraphics({
      action: "p",
      quiet: 2,
      transmission: {
        imageId: this.id,
        placementId: this.id,
      },
      display: {
        xOffset: ifNil(x, 0),
        yOffset: ifNil(x, 0),
        z: ifNil(z, 0),
        cursorMovementPolicy: 1,
      },
    });
    this.rendered = true;
  }

  clear() {
    if (!this.rendered) {
      return;
    }
    termSyncStart();
    KittyBackend.getInstance().writeGraphics({
      action: "d",
      quiet: 2,
      deleteImages: "i",
      transmission: {
        imageId: this.id,
      },
    });
    termSyncEnd();
    this.rendered = false;
  }
}
