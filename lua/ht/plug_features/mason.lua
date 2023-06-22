return {
  FuncSpec("Opens a graphical status window", "Mason"),
  FuncSpec("Updates all managed registries", "MasonUpdate"),
  FuncSpec(
    "Installs/re-installs the provided packages",
    ExecFunc("MasonInstall")
  ),
  FuncSpec("Uninstalls the provided packages", ExecFunc("MasonUninstall")),
  FuncSpec("Uninstalls all packages", "MasonUninstallAll"),
  FuncSpec("Opens the mason.nvim log file in a new tab window", "MasonLog"),
}
