import { mountRightClickMenu } from "@conf/ui/right-click";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";
import { AllPlugins } from "./conf/plugins";
import { osRelease } from "@core/utils/os-release";

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
  vim.print(osRelease);
}
