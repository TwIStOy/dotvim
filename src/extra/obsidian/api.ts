const graphqlUrl = "http://localhost:28123";

const curl = luaRequire("plenary.curl");

export function executeOpration<R>(
  operation: string,
  variables: LuaTable<string, string> = new LuaTable()
) {
  try {
    const response = curl.post(graphqlUrl, {
      headers: {
        "Content-Type": "application/json",
      },
      data: vim.json.encode({
        query: operation,
        variables: variables,
      }),
    });

    let body: R = vim.json.decode(response.body);
    return body;
  } catch (e) {
    vim.print(e);
    return null;
  }
}
