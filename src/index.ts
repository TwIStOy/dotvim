import { mountRightClickMenu } from "@conf/ui/right-click";
import { AllPlugins } from "./conf/plugins";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
import { randv4 } from "@core/utils/uuid";
import { info } from "@core/utils/logger";
import { Image } from "@core/components/image/image";
import { kittyBackend } from "@core/components/image/backend/kitty";
import { CairoRender } from "@glib/cairo-render";
import { Color } from "@glib/color";
import { BuildContext } from "@glib/widget";
import { Container } from "@glib/widgets/container";

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
  // let context = new CairoRender(100, 100);
  // context.roundedRectangle(0, 0, 100, 100, 10);
  // context.fillColor = Color.fromRGBA(1, 0, 0, 1);
  // context.fillPreserve();

  let context = new BuildContext(100, 100);
  let root = Container({
    backgroundColor: Color.fromRGBA(1, 0, 0, 1),
    border: {
      radius: 10,
    },
  });
  context.build(root);

  let [file] = io.open("/tmp/test.png", "wb");
  let data = context.renderer.toPngBytes();
  file?.write(string.char(...data));
  file?.close();

  info("start!");
  vim.schedule(() => {
    kittyBackend.deleteAll();
    // let image = Image.fromBuffer(data);
    let image = Image.fromFile(
      "/tmp/test.png"
      // "/home/hawtian/.dotvim/screenshots/start_page.png"
    );
    image.render(3, 3);
  });
  return randv4();
}
