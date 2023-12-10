import { mountRightClickMenu } from "@conf/ui/right-click";
import { Image } from "@core/components/image/image";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
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
import { MarkupRenderer, parseMarkdownContent } from "@core/format/markdown";

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

export function test() {
  // const text = `When the first paper volume of Donald Knuth's The Art of Computer Programming was published in 1968,[4] it was typeset using hot metal typesetting set by a Monotype Corporation typecaster. This method, dating back to the 19th century, produced a "good classic style" appreciated by Knuth.`;
  //
  // let context = new BuildContext(500, 400);
  // let root = Container({
  //   color: "#1e2030",
  //   border: { width: 4, color: "black", radius: 20 },
  //   height: "expand",
  //   width: "expand",
  //   padding: Padding.all(10),
  //   child: Column({
  //     children: [
  //       Spacing(),
  //       Markup(
  //         `<span foreground="white">${text}</span><span foreground="blue">${text}</span>`
  //       ),
  //       Spacing(),
  //     ],
  //   }),
  // });
  // try {
  //   root.calculateRenderBox(context);
  //   root.build(context);
  // } catch (e) {
  //   error_("build failed, %s", e);
  // }
  //
  // let data = context.renderer.toPngBytes();
  // vim.schedule(() => {
  //   KittyBackend.getInstance().deleteAll();
  //   let image = Image.fromBuffer(data);
  //   image.render(100, 100);
  //   info("=====================================================");
  // });
  // return toUtfChars("abcdd我");

  let [file] = io.open("/tmp/test.md", "r");
  let content = file!.read("*a");
  file!.close();

  info("content: %s", content);

  let render = new MarkupRenderer(content!);
  info("rendered: %s", render.render());

  info("============================================");
}
