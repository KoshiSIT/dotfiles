local config = function()
    local telescope = require('telescope')

    local themes = require('telescope.themes')

    -- Telescopeの設定
    telescope.setup({
        defaults = themes.get_dropdown(),
        pickers = {
            find_files = {
                hidden = true
            },
            live_grep = {
                hidden = true
            },
            buffers = {
                hidden = true
            }
        }

    })

    local builtin = require('telescope.builtin')
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#d08770" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#d08770" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#5e81ac" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#5e81ac" })
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#eceff4", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeResultsIdentifier", { fg = "#88c0d0", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeResultsComment", { fg = "#81a1c1" })


    vim.keymap.set('n', 'fff', builtin.find_files, {})
    vim.keymap.set('n', 'ffg', builtin.live_grep, {})
    vim.keymap.set('n', 'ffb', builtin.buffers, {})
    vim.keymap.set('n', 'ffh', builtin.help_tags, {})
end

return config
