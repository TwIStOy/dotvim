local Const = require("ht.core.const")
local registry = require("mason-registry")

local required_servers = {}

local function listen_on_events()
  registry:on(
    "package:handle",
    vim.schedule_wrap(function(pkg)
      vim.notify("Installing " .. pkg.name .. "...", vim.log.levels.INFO)
    end)
  )

  registry:on(
    "package:install:success",
    vim.schedule_wrap(function(pkg)
      vim.notify(
        string.format("Successfully installed %s", pkg.name),
        vim.log.levels.INFO
      )
    end)
  )
end

local function bin(pkg, executable)
  assert(registry.has_package(pkg))
  if required_servers[pkg] == nil then
    required_servers[pkg] = true
  end
  if executable == nil then
    executable = pkg
  end
  local binary_path = ("%s/%s"):format(Const.mason_bin, executable)
  return { binary_path }
end

local function install_package(pkg)
  if pkg:is_installed() then
    return
  end
  local handle = pkg:install()
  handle:once(
    "closed",
    vim.schedule_wrap(function()
      if pkg:is_installed() then
        vim.notify(("%s was successfully installed"):format(pkg))
      else
        vim.notify(("failed to install %s"):format(pkg), vim.log.levels.ERROR)
      end
    end)
  )
end

local function ensure_installed()
  for package_name, _ in pairs(required_servers) do
    local pkg = registry.get_package(package_name)
    install_package(pkg)
  end
end

return {
  listen_on_events = listen_on_events,
  bin = bin,
  ensure_installed = ensure_installed,
}
