import { ActionGroupBuilder } from "@core/model";
import { isNil } from "@core/vim";

const lsp_hover_group = vim.api.nvim_create_augroup("ht_lsp_hover", {
  clear: true,
});

function openDiagnostic() {
  const opts = {
    focusable: false,
    border: "solid",
    source: "if_many",
    prefix: " ",
    focus: false,
    scope: "cursor",
  };

  let [bufnr, win] = vim.diagnostic.open_float(opts);

  if (isNil(bufnr) || isNil(win)) {
    return;
  }

  luaRequire("ht.vim").close_preview_autocmd(
    ["CursorMoved", "InsertEnter", "User ShowHover", "BufLeave", "FocusLost"],
    win,
    [bufnr, vim.api.nvim_get_current_buf()]
  );

  vim.api.nvim_set_option_value("winhl", "FloatBorder:NormalFloat", {
    win: win,
  });
}

function showHover() {
  vim.o.eventignore = "CursorHold";
  vim.api.nvim_exec_autocmds("User", {
    pattern: "ShowHover",
  });
  vim.lsp.buf.hover();
  vim.api.nvim_create_autocmd(["CursorMoved"], {
    group: lsp_hover_group,
    buffer: 0,
    command: 'set eventignore=""',
    once: true,
  });
}

let lspActions = ActionGroupBuilder.start()
  .category("Builtin")
  .from("builtin")
  .condition((buf) => {
    return buf.lspServers.length > 0;
  })
  .addOpts({
    id: "builtin.lsp.goto-declaration",
    title: "Goto declaration",
    callback: () => {
      vim.lsp.buf.declaration();
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-definition",
    title: "Goto definition",
    callback: () => {
      luaRequire("glance").open("definitions");
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-implementation",
    title: "Goto implementation",
    callback: () => {
      luaRequire("glance").open("implementations");
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-type-definition",
    title: "Goto type definition",
    callback: () => {
      luaRequire("glance").open("type_definitions");
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-reference",
    title: "Goto reference",
    callback: () => {
      luaRequire("glance").open("references");
    },
  })
  .addOpts({
    id: "builtin.lsp.rename",
    title: "Rename",
    callback: () => {
      vim.lsp.buf.rename(undefined, {
        filter: (client) => {
          return ["null-ls", "copilot"].includes(client.name);
        },
      });
    },
  })
  .addOpts({
    id: "builtin.lsp.code-action",
    title: "CodeAction",
    callback: () => {
      vim.api.nvim_command("Lspsaga code_action");
    },
  })
  .addOpts({
    id: "builtin.lsp.open-diagnostic",
    title: "Open diagnostic",
    callback: openDiagnostic,
  })
  .addOpts({
    id: "builtin.lsp.show-hover",
    title: "Show hover",
    callback: showHover,
  })
  .addOpts({
    id: "builtin.lsp.goto-prev-diagnostic",
    title: "Goto prev diagnostic",
    callback: () => {
      vim.diagnostic.goto_prev({
        wrap: false,
      });
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-next-diagnostic",
    title: "Goto next diagnostic",
    callback: () => {
      vim.diagnostic.goto_next({
        wrap: false,
      });
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-prev-error-diagnostic",
    title: "Goto prev error diagnostic",
    callback: () => {
      vim.diagnostic.goto_prev({
        wrap: false,
        severity: vim.diagnostic.severity.ERROR,
      });
    },
  })
  .addOpts({
    id: "builtin.lsp.goto-next-error-diagnostic",
    title: "Goto next error diagnostic",
    callback: () => {
      vim.diagnostic.goto_next({
        wrap: false,
        severity: vim.diagnostic.severity.ERROR,
      });
    },
  });

export const builtinActions = [...lspActions.build()] as const;
