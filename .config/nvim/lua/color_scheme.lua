-- color_scheme.lua
local M = {}

function M.apply_custom_highlights()
    local current_bg_hl = "white"
    vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#000000", bg = current_bg_hl })
    vim.api.nvim_set_hl(0, "BufferCurrentMod", { fg = "#0000ff", bg = current_bg_hl })
    vim.api.nvim_set_hl(0, "BufferTabpageFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#00bfff', bg = 'NONE' })
    vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", ctermbg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })

    -- Add ClaudeCode background transparency settings
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function()
            vim.opt_local.winhighlight:append("Normal:NvimTreeNormal")
        end,
    })

    -- Add autocommand for ClaudeCode
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = "*",
        callback = function()
            local bufname = vim.api.nvim_buf_get_name(0)
            -- Check ClaudeCode buffer name patterns (adjust to match actual patterns)
            if string.match(bufname, "claude") or string.match(bufname, "ClaudeCode") or string.match(bufname, "codecompanion") then
                vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
                vim.api.nvim_win_set_option(0, "winhl", "Normal:NONE,NormalFloat:NONE")
            end
        end,
    })

    local highlight_groups = vim.fn.getcompletion('DevIcon', 'highlight')
    for _, group in ipairs(highlight_groups) do
        local current_hl = vim.api.nvim_get_hl_by_name(group, true)
        if group:find('Current') then
            vim.api.nvim_set_hl(0, group, { fg = current_hl.foreground, bg = current_bg_hl })
        end
    end
end

-- Execute on initialization
M.setup = function()
    -- ColorScheme autocommand
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("CustomColorSchemeCommands", { clear = true }),
        callback = function()
            -- Execute once immediately after colorscheme is applied
            M.apply_custom_highlights()
            -- Execute again with delay (to handle plugin lazy loading)
            vim.defer_fn(M.apply_custom_highlights, 100)
            -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#171d1f" })
        end,
    })

    -- VimEnter autocommand (for initial startup)
    vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("CustomVimEnterCommands", { clear = true }),
        callback = function()
            -- Execute with longer delay on initial startup
            vim.defer_fn(M.apply_custom_highlights, 100)
            -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#171d1f" })
        end,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("CustomBufWinEnterCommands", { clear = true }),
        callback = function()
            -- Execute when buffer is displayed
            vim.defer_fn(M.apply_custom_highlights, 100)
        end,
    })

    -- Execute immediately to ensure settings are applied
    M.apply_custom_highlights()
end

-- Execute initialization
M.setup()

-- Return module
return M
