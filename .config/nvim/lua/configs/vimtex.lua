local config = function()
    -- print("Loading vimtex configuration")
    -- vim.g.vimtex_view_method = 'skim'
    --
    -- -- Skim用の設定
    -- vim.g.vimtex_view_skim_sync = 1     -- 前方同期を有効化
    -- vim.g.vimtex_view_skim_activate = 1 -- PDFを開いたときにSkimをアクティブに
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>mm',
                ':wall<CR>:make!<CR>:silent !open -a Preview %:r.pdf<CR>:copen<CR>',
                { noremap = true, silent = true })

            -- texを編集しているとき　一行の長さを制限
            -- vim.opt_local.textwidth = 80
            -- vim.opt_local.formatoptions:append('t')
            -- vim.opt_local.wrap = true
        end
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
            vim.opt_local.colorcolumn = "80"              -- 80文字目に縦線を表示
            vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#006600" }) -- より薄い灰色の例
        end
    })
end
return config
