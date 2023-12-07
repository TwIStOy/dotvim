import { mountRightClickMenu } from "@conf/ui/right-click";
import { AllPlugins } from "./conf/plugins";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
import { randv4 } from "@core/utils/uuid";
import { Image } from "@core/components/image/image";
import { kittyBackend } from "@core/components/image/backend/kitty";
import { BuildContext } from "@glib/widget";
import { Container } from "@glib/widgets/container";
import { Margin } from "@glib/widgets/_utils";

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
  let root = (
    <Container
      color="red"
      border={{ radius: 10, width: 2, color: "green" }}
      margin={Margin.all(40)}
    />
  );
  context.build(root);

  let data = context.renderer.toPngBytes();
  vim.schedule(() => {
    kittyBackend.deleteAll();
    let image = Image.fromBuffer(data);
    image.render(3, 3);
  });
  return randv4();
}
