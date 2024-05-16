---@class dotvim.extra.hydra
local M = {}

---@class dotvim.extra.hydra.CreateHydraOption
---@field name? string only used in auto-generated hint
---@field mode string|string[] modes where the hydra exists, same as `vim.keymap.set()` accepts
---@field body? string key required to activate the hydra, when excluded, you can use
---@field hint? string
---@field config dotvim.extra.hydra.CreateHydraOption.Config
---@field heads {[1]:string, [2]:string, [3]:dotvim.extra.hydra.CreateHydraOption.Config.Head.Opts}[]

---@class dotvim.extra.hydra.CreateHydraOption.Config
---@field exit? boolean set the default exit value for each head in the hydra
---@field foreign_keys? 'warn' | 'run'  decides what to do when a key which doesn't belong to any head is pressed
---@field color? "red" | "amaranth" | "teal" | "pink"
---@field buffer? number | boolean define a hydra for the given buffer, pass `true` for current buf
---@field invoke_on_body boolean when true, summon the hydra after pressing only the `body` keys
---@field desc? string description used for the body keymap when `invoke_on_body` is true
---@field on_enter? function called when the hydra is activated
---@field on_exit? function called before the hydra is deactivated
---@field on_key? function called after every hydra head
---@field timeout? boolean | number timeout after which the hydra is automatically disabled
---@field hint? boolean | dotvim.extra.hydra.CreateHydraOption.Config.Hint

---@class dotvim.extra.hydra.CreateHydraOption.Config.Hint
---@field type? "window" | "cmdline" | "statusline" | "statuslinemanual"
---@field position? "top-left" | "top" | "top-right" | "middle-left" | "middle" | "middle-right" | "bottom-left" | "bottom" | "bottom-right"
---@field offset? number
---@field float_opts? table
---@field show_name? boolean
---@field hide_on_load? boolean
---@field funcs? table<string, function>

---@class dotvim.extra.hydra.CreateHydraOption.Config.Head.Opts
---@field ["private"]? boolean When the hydra hides, this head does not stick out
---@field exit? boolean When true, stops the hydra after executing this head
---@field exit_before? boolean Like exit, but stops the hydra BEFORE executing the command
---@field ok_key? boolean when set to false, config.on_key isn't run after this head
---@field desc? string  false - value shown in auto-generated hint. When false, this key doesn't show up in the auto-generated hint
---@field expr? boolean :h :map-expression
---@field silent? boolean :h :map-silent
---@field nowait? boolean :h :map-nowait
---@field mode? string|string[] :h :map-mode

function M.create_hydra() end

return M
