import * as ts from "typescript";
import * as tstl from "typescript-to-lua";

const REQUIRE_PATH_REGEX = /require\("(.+)"\)/g;
const RAW_IMPORT_REGEX = /(.+)-raw-nvim/g;

const plugin: tstl.Plugin = {
  beforeEmit(
    _program: ts.Program,
    _options: tstl.CompilerOptions,
    _emitHost: tstl.EmitHost,
    result: tstl.EmitFile[]
  ) {
    for (const file of result) {
      file.code = file.code.replaceAll(
        REQUIRE_PATH_REGEX,
        (match, path: unknown) => {
          if (typeof path !== "string") {
            return match;
          }

          let res = RAW_IMPORT_REGEX.exec(path as string);
          if (res !== null) {
            return `require("${res[1]}")`;
          }

          return `require("${path}")`;
        }
      );
    }
  },
};

export default plugin;
