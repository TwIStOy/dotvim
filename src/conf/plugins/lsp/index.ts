import { plugin as mason } from "./mason";
import { plugin as aerial } from "./aerial";
import { plugin as typescriptToolsNvim } from "./typescript-tools-nvim";
import { plugin as glanceNvim } from "./glance-nvim";
import { plugin as lspkindNvim } from "./lspkind-nvim";
import { plugin as troubleNvim } from "./trouble-nvim";
import { plugin as clangdExtensionsNvim } from "./clangd_extensions-nvim";

export const plugins = [
  mason,
  aerial,
  typescriptToolsNvim,
  glanceNvim,
  lspkindNvim,
  troubleNvim,
  clangdExtensionsNvim,
] as const;
