import { mountRightClickMenu } from "@conf/ui/right-click";
import { Image } from "@core/components/image/image";
import { Command } from "@core/model";
import { VimBuffer, hideCursor, ifNil } from "@core/vim";
import { Padding } from "@glib/widgets/_utils";
import { Container } from "@glib/widgets/container";
import { Text } from "@glib/widgets/text/text";
import { AllPlugins } from "./conf/plugins";
import { KittyBackend } from "@core/components/image/backend/kitty";
import { Column } from "@glib/widgets/column";
import { Spacing } from "@glib/widgets/spacing";
import { error_, info } from "@core/utils/logger";
import { BuildContext } from "@glib/build-context";
import { toUtfChars } from "@glib/widgets/text/common";
import { TextSpan } from "@glib/widgets/text/text-span";
import { Markup } from "@glib/widgets/markup";
import { MarkupRenderer } from "@core/format/markdown";
import {
  PangoMarkupGenerator,
  RenderedElement,
} from "@core/format/rendered-node";
import { Widget } from "@glib/widget";

export * as _ from "@glib/index";
export { AllLspServers } from "./conf/external_tools";
export { AllPlugins, LazySpecs } from "./conf/plugins";
export { showHover } from "./conf/lsp";

export function getAllCommands(): Command[] {
  let result: Command[] = [];
  for (let plugin of AllPlugins.flat()) {
    result.push(...plugin.commands);
  }
  return result;
}

export function onRightClick(opts: any) {
  let bufnr = vim.api.nvim_get_current_buf();
  let buffer = new VimBuffer(bufnr);
  hideCursor();
  mountRightClickMenu(buffer, opts);
}

function intoWidget(m: RenderedElement, fg: number): Widget[] {
  if (m.kind === "line") {
    info("line: %s", vim.inspect(m.markup));
    return [
      Markup({
        markup: m.markup,
        margin: Padding.from({
          // top: 4,
        }),
      }),
    ];
  } else if (m.kind === "lines") {
    return m.lines.map((p) => intoWidget(p, fg)).flat();
  } else {
    return [
      Container({
        margin: Padding.vertical(4),
        height: m.width,
        width: "expand",
        color: fg,
      }),
    ];
  }
}

export function test() {
  let [file] = io.open("/tmp/test.md", "r");
  let content = file!.read("*a");
  file!.close();

  info("content: %s", content);

  let render = new MarkupRenderer(content!);
  let rr = render.render();
  let generator = new PangoMarkupGenerator();

  let context = new BuildContext(1000, 400);

  rr.intoPangoMarkup(generator);

  let paragraphs = generator.done();

  let hl_normal = vim.api.nvim_get_hl(0, {
    name: "NormalFloat",
  });
  let background = ifNil(hl_normal.get("guibg"), hl_normal.get("bg"));
  let foreground = ifNil(hl_normal.get("guifg"), hl_normal.get("fg"));

  let root = Container({
    color: background,
    border: { width: 4, color: "black", radius: 20 },
    height: "shrink",
    width: "shrink",
    padding: Padding.all(10),
    child: Column({
      children: [
        ...paragraphs
          .map((m) => {
            return intoWidget(m, foreground);
          })
          .flat(),
        Spacing(),
      ],
    }),
  });
  try {
    root.calculateRenderBox(context);
    root.build(context);
  } catch (e) {
    error_("build failed, %s", e);
  }

  let data = context.renderer.toPngBytes();
  vim.schedule(() => {
    KittyBackend.getInstance().deleteAll();
    let image = Image.fromBuffer(data);
    image.render(0, 0);
    info("=====================================================");
  });
  return toUtfChars("abcdd我");
}
