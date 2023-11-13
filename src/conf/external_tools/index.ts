import formatters from "./formatters";
import lsp_servers from "./lsp_servers";

export const AllFormatters = formatters;
export const AllLspServers = lsp_servers;
export const AllMaybeMasonPackage = [
  ...formatters,
  ...lsp_servers,
]
