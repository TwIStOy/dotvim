import { mountRightClickMenu } from "@conf/ui/right-click";
import { AllPlugins } from "./conf/plugins";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
// import { randv4 } from "@core/utils/uuid";
// import { Context2D } from "@core/components/cairo-render";
// import { Color } from "@core/components/color";
// import { KittyBackend } from "@core/components/image/backend/kitty";

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
  // let context = new Context2D(120, 120);
  // context.rectangle(0, 0, 0.5, 0.5);
  // context.fillColor = Color.fromRGBA(1, 0, 0, 0.8);
  // context.fill();
  //
  // let data = context.toPngBytes();
  // let kitty = new KittyBackend();
  // kitty.writeGraphics(
  //   {
  //     action: "T",
  //     transmission: {
  //       format: 100,
  //     },
  //   },
  //   data
  // );
  //
  // return randv4();
}
