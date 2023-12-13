import { KittyBackend } from "@core/components/image/backend/kitty";
import { Image } from "@core/components/image/image";
import { MarkupRenderer } from "@core/format/markdown";
import {
  CodeBlockNode,
  PangoMarkupGenerator,
  RenderedElement,
  SpanNode,
} from "@core/format/rendered-node";
import { info } from "@core/utils/logger";
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

const lsp_hover_group = vim.api.nvim_create_augroup("ht_lsp_hover", {
  clear: true,
});

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

export function buildImage(
  contents: MarkupContent | MarkedString | MarkedString[]
) {
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
    border: { width: 1, color: "black", radius: 4 },
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
  // try to write to file
  context.renderer.writePng();
  return {
    data: imageData,
    width: rootWidget._renderBox!.width,
    height: rootWidget._renderBox!.height,
  };
}

function hoverImage(data: number[], x: number, y: number) {
  let image = Image.fromBuffer(data);

  vim.o.eventignore = "CursorHold";
  // close current diagnostic window
  vim.api.nvim_exec_autocmds("User", {
    pattern: "ShowHover",
  });
  vim.api.nvim_create_autocmd(
    ["CursorMoved", "FocusLost", "WinLeave", "WinClosed"],
    {
      once: true,
      group: lsp_hover_group,
      buffer: 0,
      callback: () => {
        KittyBackend.getInstance().delete(image.id);
        vim.o.eventignore = "";
        return true;
      },
    }
  );

  KittyBackend.getInstance().render(image, x, y);
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
  let xOffset = Math.min(
    termSize.screen_cols - cursor.col - imageWidthCells,
    0
  );
  let yOffset = Math.min(
    termSize.screen_rows - cursor.row - imageHeightCells - 1,
    1
  );
  info(
    "cursor: %s, image: %s, offset: {%s, %s}, %s, %s",
    cursor,
    termSize,
    xOffset,
    yOffset,
    imageWidthCells,
    imageHeightCells
  );
  hoverImage(
    data,
    xOffset * termSize.cell_width,
    yOffset * termSize.cell_height
  );
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

export function showHover() {
  bufHover();
}
