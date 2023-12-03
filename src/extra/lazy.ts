export function has(plugin: string) {
  return luaRequire("lazy.core.config").spec.plugins[plugin] !== null;
}

export function onVeryLazy(fn: () => void) {
  vim.api.nvim_create_autocmd("User", {
    pattern: "VeryLazy",
    callback: () => {
      fn();
    },
  });
}
