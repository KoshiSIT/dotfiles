local config = function()
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- NvimTreeとの連携設定を追加
    local nvim_tree_events = require('nvim-tree.events')
    local barbar_api = require('barbar.api')


    -- barbartabの基本設定
    vim.g.barbar_auto_setup = false
    require 'barbar'.setup({
        animation = true,
        insert_at_end = true,
        minimum_padding = 3, -- より大きな値に設定
        maximum_padding = 3,
        clickable = false,
        sidebar_filetypes = {
            NvimTree = {
                enable = true,
                text = '󰦄 Nvim-Tree',
            },
            ['neo-tree'] = { event = 'BufWinLeave' },
        },
        icons = {
            button = '',
        },
    })
 
    vim.cmd([[
        hi BufferOffset guifg=#ff0000 guibg=#121212 gui=bold
        hi BufferOffsetSeparator guifg=#3b4261 gui=none
    ]])
    -- 必要なモジュールを明示的に読み込む
    local nvim_tree_events = require('nvim-tree.events')
    local barbar_api = require('barbar.api')

    vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "NvimTree*",
        callback = function()
            -- ステータスラインの設定
            vim.cmd("setlocal statusline=\\ \\ Explorer")
        end,
    })
    -- nvim-treeとbarbarの連携設定
    local function update_barbar_offset()
        local tree = require('nvim-tree.view')
        if tree.is_visible() then
            local tree_width = vim.api.nvim_win_get_width(tree.get_winnr())
            barbar_api.set_offset(tree_width)
        end
    end

    -- イベント登録
    nvim_tree_events.subscribe('TreeOpen', function()
        update_barbar_offset()
    end)

    nvim_tree_events.subscribe('TreeClose', function()
        barbar_api.set_offset(0)
    end)

    -- ウィンドウサイズ変更時にoffsetを更新
    vim.api.nvim_create_autocmd('VimResized', {
        callback = function()
            update_barbar_offset()
        end,
    })


    -- 既存のキーマップ設定
    map('n', '<Space>,', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<Space>.', '<Cmd>BufferNext<CR>', opts)
    -- （以下、既存のキーマップ設定をそのまま維持）
    map('n', '<Space><', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<Space>>', '<Cmd>BufferMoveNext<CR>', opts)
    map('n', '<Space>1', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<Space>2', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<Space>3', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<Space>4', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<Space>5', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<Space>6', '<Cmd>BufferGoto 6<CR>', opts)
    map('n', '<Space>7', '<Cmd>BufferGoto 7<CR>', opts)
    map('n', '<Space>8', '<Cmd>BufferGoto 8<CR>', opts)
    map('n', '<Space>9', '<Cmd>BufferGoto 9<CR>', opts)
    map('n', '<Space>0', '<Cmd>BufferLast<CR>', opts)
    map('n', '<Space>p', '<Cmd>BufferPin<CR>', opts)
    map('n', '<Space>c', '<Cmd>BufferClose<CR>', opts)
    map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
    map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
    map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
end

return config
