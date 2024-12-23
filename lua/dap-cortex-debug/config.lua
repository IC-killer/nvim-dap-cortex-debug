local M = {}

-- Use a function to always get a new table, even if some deep field is modified,
-- like `config.commands.save = ...`. Returning a "constant" still seems to allow
-- the LSP completion to work.
local function defaults()
    -- stylua: ignore
    return {
        debug = false,
        extension_path = nil,
        lib_extension = nil,
        node_path = 'node',
        dapui_rtt = true,
        dap_vscode_filetypes = { 'c', 'cpp' },
        rtt = {
            buftype = 'Terminal',
        },
    }
end

local config = defaults()

function M.setup(opts)
    local new_config = vim.tbl_deep_extend('force', {}, defaults(), opts or {})
    -- Do _not_ replace the table pointer with `config = ...` because this
    -- wouldn't change the tables that have already been `require`d by other
    -- modules. Instead, clear all the table keys and then re-add them.
    for _, key in ipairs(vim.tbl_keys(config)) do
        config[key] = nil
    end
    for key, val in pairs(new_config) do
        config[key] = val
    end
end

-- Return the config table (getting completion!) but fall back to module methods.
return setmetatable(config, { __index = M })
