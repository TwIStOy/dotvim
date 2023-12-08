import { mountRightClickMenu } from "@conf/ui/right-click";
import { Image } from "@core/components/image/image";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
import { BuildContext } from "@glib/widget";
import { Padding } from "@glib/widgets/_utils";
import { Container } from "@glib/widgets/container";
import { Text, toUtfChars } from "@glib/widgets/text/text";
import { AllPlugins } from "./conf/plugins";
import { KittyBackend } from "@core/components/image/backend/kitty";

export * as _ from "@glib/index";
export { AllLspServers } from "./conf/external_tools";
export { AllPlugins, LazySpecs } from "./conf/plugins";

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
  let context = new BuildContext(400, 400);
  let root = Container({
    color: "white",
    border: { width: 2, color: "blue" },
    heightPolicy: "expand",
    widthPolicy: "expand",
    padding: Padding.all(5),
    child: Text({
      text: `When the first paper volume of Donald Knuth's The Art of Computer Programming was published in 1968,[4] it was typeset using hot metal typesetting set by a Monotype Corporation typecaster. This method, dating back to the 19th century, produced a "good classic style" appreciated by Knuth.`,
    }),
  });
  context.build(root);

  let data = context.renderer.toPngBytes();
  vim.schedule(() => {
    KittyBackend.getInstance().deleteAll();
    let image = Image.fromBuffer(data);
    image.render(100, 100);
  });
  return toUtfChars("abcdd我");
}
