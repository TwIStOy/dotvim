import * as ts from "typescript";
import * as tstl from "typescript-to-lua";

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
          tstl.createIdentifier("__raw_require"),
          [tstl.createIdentifier(node.arguments[0].getText())],
          node
        );
      }
      return context.superTransformExpression(node);
    },
  },
};

export default plugin;
