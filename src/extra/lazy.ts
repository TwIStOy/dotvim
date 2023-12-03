export function has(plugin: string) {
  return luaRequire("lazy.core.config").spec.plugins[plugin] !== null;
}
