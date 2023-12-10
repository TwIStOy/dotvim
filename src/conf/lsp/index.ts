import { MarkupRenderer } from "@core/format/markdown";
import { info } from "@core/utils/logger";
import { isNil } from "@core/vim";
import { Hover, MarkupContent } from "vscode-languageserver-types";

export function showHover() {
  // vim.o.eventignore = "CursorHold";
  // vim.api.nvim_exec_autocmds("User", {
  //   pattern: "ShowHover",
  // });
  bufHover();
}

function isMarkupContent(arg: any): arg is MarkupContent {
  return !isNil(arg.kind);
}

function bufHover() {
  let params = luaRequire("vim.lsp.util").make_position_params();
  vim.lsp.buf_request(0, "textDocument/hover", params, (err, res, _context) => {
    let result = res as Hover;
    result.contents;
    if (isMarkupContent(result.contents)) {
      info("markup content! %s", result.contents.value);
      let markup = new MarkupRenderer(result.contents.value);
    }
    info("%s %s", err, res);
  });
}
