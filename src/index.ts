import { mountRightClickMenu } from "@conf/ui/right-click";
import { AllPlugins } from "./conf/plugins";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
import { randv4 } from "@core/utils/uuid";
import { Image } from "@core/components/image/image";
import { kittyBackend } from "@core/components/image/backend/kitty";
import { BuildContext } from "@glib/widget";
import { Container } from "@glib/widgets/container";
import { Color, Margin, Padding } from "@glib/widgets/_utils";
import { Text, toUtfChars } from "@glib/widgets/text/text";

export * as _ from "@glib/index";
export { AllPlugins, LazySpecs } from "./conf/plugins";
export { AllLspServers } from "./conf/external_tools";

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
  let context = new BuildContext(100, 100);
  let root = Container({
    color: "white",
    border: { width: 2, color: "blue" },
    heightPolicy: "expand",
    widthPolicy: "expand",
    padding: Padding.all(10),
    child: Text({
      text: "ag teasd asdkfj asdkfj asdkj asdkfj asdfiasdfj asdkfj asdkfj askdfj askdfjiasd jfaskdljf alskdjfoiasjdf laskjdf lkasdjf l",
    }),
  });
  context.build(root);

  let data = context.renderer.toPngBytes();
  vim.schedule(() => {
    kittyBackend.deleteAll();
    let image = Image.fromBuffer(data);
    image.render(3, 3);
  });
  return toUtfChars("abcdd我");
}
