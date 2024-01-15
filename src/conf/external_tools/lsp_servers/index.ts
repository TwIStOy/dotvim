import { server as typescript } from "./typescript";
import { server as clangd } from "./clangd";
import { server as rustaceanvim } from "./rustaceanvim";
import { server as sourcekit } from "./sourcekit";
import { server as pyright } from "./pyright";
import { server as cmake } from "./cmake";
import { server as flutter } from "./flutter";
import { server as luaLs } from "./lua_ls";

export default [
  typescript,
  clangd,
  rustaceanvim,
  sourcekit,
  pyright,
  cmake,
  flutter,
  luaLs,
] as const;
