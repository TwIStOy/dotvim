import { AllPlugins } from "./conf/plugins";
import { RightClickPaletteCollection } from "@core/collections/right-click";
import { Command } from "@core/model";
import { VimBuffer, hideCursor } from "@core/vim";

export { AllPlugins, LazySpecs } from "./conf/plugins";
export { AllLspServers } from "./conf/external_tools";

export function getAllCommands(): Command[] {
  let result: Command[] = [];
  for (let plugin of AllPlugins) {
    result.push(...plugin.commands);
  }
  return result;
}

const rightClickCollection = (() => {
  let collection = new RightClickPaletteCollection();
  for (let cmd of getAllCommands()) {
    collection.push(cmd);
  }
  return collection;
})();

export function onRightClick(opts: any) {
  let bufnr = vim.api.nvim_get_current_buf();
  let buffer = new VimBuffer(bufnr);
  hideCursor();
  rightClickCollection.mount(buffer, opts);
}
