import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "mfussenegger/nvim-lint",
  lazy: {
    event: ["BufReadPost", "BufNewFile"],
    config: () => {
      (luaRequire("lint").linters_by_ft as any) = {
        cpp: ["cpplint", "cppcheck"],
      };

      vim.api.nvim_create_autocmd(["BufWritePost"], {
        callback: () => {
          luaRequire("lint").try_lint();
        },
      });
    },
  },
});
