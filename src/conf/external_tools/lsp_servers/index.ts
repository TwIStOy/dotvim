import { server as typescript } from "./typescript";
import { server as clangd } from "./clangd";
import { server as rustaceanvim } from "./rustaceanvim";
import { server as sourcekit } from "./sourcekit";
import { server as pyright } from "./pyright";
import { server as cmake } from "./cmake";
import { server as flutter } from "./flutter";
import { server as luaLs } from "./lua_ls";
import { server as nil } from "./nil";
import { server as gopls } from "./gopls";

export default [
  typescript,
  clangd,
  rustaceanvim,
  sourcekit,
  pyright,
  cmake,
  flutter,
  luaLs,
  nil,
  gopls,
] as const;
