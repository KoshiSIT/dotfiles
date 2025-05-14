-- color_scheme.luaを以下のように修正
local M = {}

function M.apply_custom_highlights()
    local current_bg_hl = "white"
    vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#000000", bg = current_bg_hl })
    vim.api.nvim_set_hl(0, "BufferCurrentMod", { fg = "#0000ff", bg = current_bg_hl })
    vim.api.nvim_set_hl(0, "BufferTabpageFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#00bfff', bg = 'NONE' })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function()
            vim.opt_local.winhighlight:append("Normal:NvimTreeNormal")
        end
    })
    local highlight_groups = vim.fn.getcompletion('DevIcon', 'highlight')
    for _, group in ipairs(highlight_groups) do
        local current_hl = vim.api.nvim_get_hl_by_name(group, true)
        if group:find('Current') then
            vim.api.nvim_set_hl(0, group, { fg = current_hl.foreground, bg = current_bg_hl })
        end
    end
end

-- 初期化時に実行
M.setup = function()
    -- ColorScheme自動コマンド
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("CustomColorSchemeCommands", { clear = true }),
        callback = function()
            -- カラースキーム適用直後に一度実行
            M.apply_custom_highlights()
            -- 少し遅延させてもう一度実行（プラグインの遅延読み込みに対応）
            vim.defer_fn(M.apply_custom_highlights, 100)
            -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#171d1f" })
        end
    })

    -- VimEnter自動コマンド（初回起動時用）
    vim.api.nvim_create_autocmd("VimEnter", {

        group = vim.api.nvim_create_augroup("CustomVimEnterCommands", { clear = true }),
        callback = function()
            -- 初回起動時は少し長めの遅延で実行
            vim.defer_fn(M.apply_custom_highlights, 300)
            -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#171d1f" })
        end
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("CustomBufWinEnterCommands", { clear = true }),
        callback = function()
            -- バッファ表示時にも実行
            M.apply_custom_highlights()
        end
    })

    -- 設定適用を確実にするため即時実行も行う
    M.apply_custom_highlights()
end

-- 初期化を実行
M.setup()

-- モジュールを返す
return M -- vim.defer_fn(function()
--     -- ここにプラグインのロード後に実行したい処理を書く
--     local current_bg_hl = "#ffffff"
--     vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#000000", bg = current_bg_hl })    -- すべてのDevIcon関連のハイライトグループを取得
--     local highlight_groups = vim.fn.getcompletion('DevIcon', 'highlight')
--
--     -- 取得したハイライトグループに対してループ処理
--     for _, group in ipairs(highlight_groups) do
--         -- 'Current'を含むハイライトグループを対象に背景色をnoneに設定
--         local current_hl = vim.api.nvim_get_hl_by_name(group, true)
--         if group:find('Current') then
--             vim.api.nvim_set_hl(0, group, {fg = current_hl.foreground, bg = current_bg_hl})
--         end
--     end
-- end, 1000) -- 100ミリ秒後に実行
