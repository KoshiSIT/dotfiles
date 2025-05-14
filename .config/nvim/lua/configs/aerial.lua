local config = function()
    require('aerial').setup({
        -- メインレイアウト設定
        layout = {
            default_direction = "prefer_right",
            max_width = { 40, 0.2 },
            width = nil,
            min_width = 15, -- 少し広くして見やすく
        },
        attach_mode = "global",
        resize_to_content = true, -- typo修正

        -- UI関連設定
        highlight_on_hover = true, -- ホバー時にハイライト
        highlight_on_jump = true, -- ジャンプ時にハイライト
        close_on_select = false, -- 選択後も閉じない
        icons = {
            collapsed = "▶", -- 折りたたみアイコン
            expanded = "▼", -- 展開アイコン
        },

        -- 各種キーマップ
        keymaps = {
            ["?"] = "actions.show_help",
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.jump",
            ["<2-LeftMouse>"] = "actions.jump",
            ["<C-v>"] = "actions.jump_vsplit",
            ["<C-s>"] = "actions.jump_split",
            ["p"] = "actions.scroll",
            ["<C-j>"] = "actions.down_and_scroll",
            ["<C-k>"] = "actions.up_and_scroll",
            ["{"] = "actions.prev",
            ["}"] = "actions.next",
            ["[["] = "actions.prev_up",
            ["]]"] = "actions.next_up",
            ["q"] = "actions.close",
            ["o"] = "actions.tree_toggle",
            ["za"] = "actions.tree_toggle",
            ["O"] = "actions.tree_toggle_recursive",
            ["zA"] = "actions.tree_toggle_recursive",
            ["l"] = "actions.tree_open",
            ["zo"] = "actions.tree_open",
            ["L"] = "actions.tree_open_recursive",
            ["zO"] = "actions.tree_open_recursive",
            ["h"] = "actions.tree_close",
            ["zc"] = "actions.tree_close",
            ["H"] = "actions.tree_close_recursive",
            ["zC"] = "actions.tree_close_recursive",
            ["zr"] = "actions.tree_increase_fold_level",
            ["zR"] = "actions.tree_open_all",
            ["zm"] = "actions.tree_decrease_fold_level",
            ["zM"] = "actions.tree_close_all",
            ["zx"] = "actions.tree_sync_folds",
            ["zX"] = "actions.tree_sync_folds",
        },

        float = {
            border = "rounded",

            relative = "editor",
            max_height = 0.8,
            height = nil,
            min_height = { 10, 0.2 },
            -- カスタムオーバーライド
            override = function(conf, source_winid)
                local editor_width = vim.o.columns
                local editor_height = vim.o.lines

                conf.row = math.floor((editor_height - conf.height) / 2)
                conf.col = math.floor((editor_width - conf.width) / 2)

                conf.style = "minimal"
                conf.title = " シンボル一覧 "
                conf.title_pos = "center"

                return conf
            end,
        },

        -- フィルター設定
        filter_kind = false, -- すべての種類のシンボルを表示
    })

    -- キーマッピング
    vim.keymap.set('n', '<leader>a', "<cmd>AerialToggle!<CR>", { noremap = true, silent = true, desc = "Aerial サイドバー切替" })
    vim.keymap.set('n', '<leader>af', "<cmd>AerialToggle float<CR>",
        { noremap = true, silent = true, desc = "Aerial フロート表示" })
    vim.keymap.set("n", "ass", function()
        require("aerial").focus()
    end, { desc = "Focus Aerial window" })

    local function custom_jump()
        -- 現在のカーソル位置を記憶
        local target = require("aerial").get_location(true)
        if target then
            -- ジャンプを実行
            require("aerial.actions").jump()

            -- 少し遅延してからフロートウィンドウを再度開く
            vim.defer_fn(function()
                require("aerial").open({ direction = "float" })
            end, 100)
        end
        return false -- ブロックキーマップの実行を停止
    end

    -- フロートビュー用のカスタムキーマップ
    vim.keymap.set("n", "<leader>aj", custom_jump, { desc = "Aerial ジャンプ後フロート表示" })
end

return config
