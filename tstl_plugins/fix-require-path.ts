import * as ts from "typescript";
import * as tstl from "typescript-to-lua";

const LUA_PREFIX = "tsgen";
const REQUIRE_PATH_REGEX = /require\("(.+)"\)/g;

const isValidLuaRequireExpr = (node: ts.CallExpression) => {
  return (
    node.kind === ts.SyntaxKind.CallExpression &&
    node.expression.getText() === "luaRequire" &&
    node.arguments.length === 1 &&
    node.arguments[0].kind === ts.SyntaxKind.StringLiteral
  );
};

const plugin: tstl.Plugin = {
  visitors: {
    [ts.SyntaxKind.CallExpression]: (node, context) => {
      if (isValidLuaRequireExpr(node)) {
        return tstl.createCallExpression(
          tstl.createIdentifier("__raw_import"),
          [tstl.createIdentifier(node.arguments[0].getText())],
          node
        );
      }
      return context.superTransformExpression(node);
    },
  },
  beforeEmit(
    _program: ts.Program,
    _options: tstl.CompilerOptions,
    _emitHost: tstl.EmitHost,
    result: tstl.EmitFile[]
  ) {
    for (const file of result) {
      file.code = file.code.replaceAll(
        REQUIRE_PATH_REGEX,
        (match: any, path: unknown) => {
          if (typeof path !== "string") {
            return match;
          }
          return `require("${LUA_PREFIX}.${path}")`;
        }
      );
    }
  },
};

export default plugin;
