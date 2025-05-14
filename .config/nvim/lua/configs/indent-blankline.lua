local config = function()
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#00ffff" })
        vim.api.nvim_set_hl(0, "IblScopeUnderline", { fg = "#E06C75", underline = true })
    end)
    require("ibl").setup {
        scope = {
            enabled = true,
            highlight = "IblScope",
            priority = 1000,
        }
    }
end

return config
