import { Command } from "@core/types";
import { AllPlugins } from "./conf/plugins";
import { RightClickPaletteCollection } from "@core/collections/right-click";
import { VimBuffer } from "@core/vim";

export { AllPlugins, LazySpecs } from "./conf/plugins";

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
  rightClickCollection.mount(buffer, opts);
}
