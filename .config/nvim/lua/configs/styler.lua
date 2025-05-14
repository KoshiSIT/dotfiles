local config = function()
    -- 元のvim.api.nvim_set_hlを保存（ハイライト保護用）
    -- カラースキーム変更時にbarbarを更新
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            vim.defer_fn(function()
                -- タブラインを再描画
                vim.cmd([[redrawtabline]])

                -- barbar.nvimの更新を試みる
                pcall(function()
                    local barbar = require("barbar")
                    if barbar.update then barbar.update() end
                end)
            end, 100)
        end
    })

    -- stylerの設定
    require("styler").setup({
        themes = {
            codecompanion = {
                colorscheme = "kanagawa",
            },
        },
    })
end

return config
