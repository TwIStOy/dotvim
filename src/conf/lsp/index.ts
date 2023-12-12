import { KittyBackend } from "@core/components/image/backend/kitty";
import { Image } from "@core/components/image/image";
import { MarkupRenderer } from "@core/format/markdown";
import {
  CodeBlockNode,
  PangoMarkupGenerator,
  RenderedElement,
  SpanNode,
} from "@core/format/rendered-node";
import { termGetSize } from "@core/utils/term";
import { cursorPositionToClient, ifNil, isNil } from "@core/vim";
import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { Container } from "@glib/widgets";
import { Padding } from "@glib/widgets/_utils";
import { Column } from "@glib/widgets/column";
import { Markup } from "@glib/widgets/markup";
import {
  Hover,
  MarkedString,
  MarkupContent,
} from "vscode-languageserver-types";

function isMarkupContent(arg: any): arg is MarkupContent {
  return !isNil(arg.kind);
}

function intoWidget(m: RenderedElement): Widget {
  let hl_normal = vim.api.nvim_get_hl(0, {
    name: "NormalFloat",
  });
  let fg = ifNil(hl_normal.get("guifg"), hl_normal.get("fg"));
  if (m.kind === "line") {
    return Markup(m.markup);
  } else if (m.kind === "lines") {
    return Column({
      children: m.lines.map((p) => intoWidget(p)),
    });
  } else {
    return Container({
      margin: Padding.vertical(4),
      height: m.width,
      width: "expand",
      color: fg,
    });
  }
}

function buildImage(contents: MarkupContent | MarkedString | MarkedString[]) {
  let root;
  if (isMarkupContent(contents)) {
    let markup = new MarkupRenderer(contents.value);
    root = markup.render();
  } else {
    let parts = [];
    if (vim.tbl_islist(contents)) {
      for (let m of contents) {
        if (typeof m === "string") {
          parts.push(new CodeBlockNode(m, null));
        } else {
          parts.push(new CodeBlockNode(m.value, m.language));
        }
      }
    }
    root = new SpanNode(parts);
  }
  let pango = new PangoMarkupGenerator();
  root.intoPangoMarkup(pango);
  let data = pango.done();
  let widgets = data.map((p) => intoWidget(p));

  let hl_normal = vim.api.nvim_get_hl(0, {
    name: "NormalFloat",
  });
  let bg = ifNil(hl_normal.get("guibg"), hl_normal.get("bg"));
  let rootWidget = Container({
    color: bg,
    border: { width: 4, color: "black", radius: 20 },
    height: "shrink",
    width: "shrink",
    padding: Padding.all(10),
    child: Column({
      children: widgets,
    }),
  });

  let context = new BuildContext(800, 600);
  rootWidget.calculateRenderBox(context);
  rootWidget.build(context);
  let imageData = context.renderer.toPngBytes();
  return {
    data: imageData,
    width: rootWidget._renderBox!.width,
    height: rootWidget._renderBox!.height,
  };
}

export function showHover() {
  bufHover();
}

class HoverImage {
  private image: Image;

  constructor(
    data: number[],
    private x: number,
    private y: number
  ) {
    this.image = Image.fromBuffer(data);

    vim.o.eventignore = "CursorHold";
    // close current diagnostic window
    vim.api.nvim_exec_autocmds("User", {
      pattern: "ShowHover",
    });
    vim.api.nvim_create_autocmd(
      ["CursorMoved", "FocusLost", "WinLeave", "WinClosed"],
      {
        once: true,
        callback: () => {
          this.delete();
          return true;
        },
      }
    );
    vim.schedule(() => {
      this.image.render(this.x, this.y);
    });
  }

  delete() {
    vim.schedule(() => {
      KittyBackend.getInstance().delete(this.image.id);
    });
  }
}

function hoverCallback(
  contents: MarkupContent | MarkedString | MarkedString[]
) {
  let { data, width, height } = buildImage(contents);
  vim.o.eventignore = "CursorHold";
  // close current diagnostic window
  vim.api.nvim_exec_autocmds("User", {
    pattern: "ShowHover",
  });
  let termSize = termGetSize();
  let imageWidthCells = Math.ceil(width / termSize.cell_width);
  let imageHeightCells = Math.ceil(height / termSize.cell_height);
  // let image = Image.fromBuffer(data);
  let cursor = cursorPositionToClient();
  let xOffset = Math.min(termSize.screen_cols - cursor.col - imageWidthCells);
  let yOffset = Math.min(termSize.screen_rows - cursor.row - imageHeightCells);
  new HoverImage(data, xOffset, yOffset);
}

function bufHover() {
  let params = luaRequire("vim.lsp.util").make_position_params();
  vim.lsp.buf_request(
    0,
    "textDocument/hover",
    params,
    (_err, res: Hover, _context) => {
      hoverCallback(res.contents);
    }
  );
}
