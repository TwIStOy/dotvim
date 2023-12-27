import { mountRightClickMenu } from "@conf/ui/right-click";
import { Image } from "@core/components/image/image";
import { Command } from "@core/model";
import {
  VimBuffer,
  cursorPositionToClient,
  hideCursor,
  ifNil,
} from "@core/vim";
import { AllPlugins } from "./conf/plugins";
import { KittyBackend } from "@core/components/image/backend/kitty";
import { error_, info } from "@core/utils/logger";
import { MarkupRenderer } from "@core/format/markdown";
import {
  PangoMarkupGenerator,
  RenderedElement,
} from "@core/format/rendered-node";
import { termGetSize } from "@core/utils/term";
import { MarkupContent } from "vscode-languageserver-types";

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
  let chan_id = vim.fn.sockconnect("tcp", "127.0.0.1:7000", {
    rpc: 1,
  });
  vim.print(chan_id);
  vim.fn.rpcnotify(chan_id, "ping");

  // let [file] = io.open("/tmp/test.md", "r");
  // let content = file!.read("*a");
  // file!.close();
  //
  // let data = buildImage({ kind: "markdown", value: content! });
  //
  // vim.schedule(() => {
  //   KittyBackend.getInstance().deleteAll();
  //   let image = Image.fromBuffer(data.data);
  //   info("pos: {%s, %s}", data.width, data.height);
  //   image.render(data.width, data.height);
  //   info("=====================================================");
  // });
  // let termSize = termGetSize();
  // info("term: %s, cursor: %s", termSize, cursorPositionToClient());
  // return toUtfChars("abcdd我");
}
