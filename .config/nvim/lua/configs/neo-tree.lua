local config = function()
    require("neo-tree").setup({
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
            },
            follow_current_file = { enabled = true },
        },
        hijack_netrw_behavior = "open_default",
    })

    vim.api.nvim_set_keymap('n', '<C-o>', ':Neotree toggle<CR>', { noremap = true, silent = true })

    -- Neotreeと他のウィンドウ間でフォーカスを切り替える関数を直接定義
    function toggle_neotree_focus()
        local neotree_win = nil
        local current_win = vim.api.nvim_get_current_win()

        -- 全ウィンドウを確認し、Neotreeウィンドウがあるかを探す
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
            if bufname:match("neo%-tree") then
                neotree_win = win
                break
            end
        end

        if neotree_win then
            if current_win == neotree_win then
                -- Neotreeウィンドウにフォーカスがある場合、他のウィンドウに移動
                vim.cmd('wincmd w')
            else
                -- Neotreeウィンドウにフォーカスを移動
                vim.api.nvim_set_current_win(neotree_win)
            end
        else
            -- Neotreeが開いていない場合は通常のウィンドウ移動
            vim.cmd('wincmd w')
        end
    end

    -- <C-n> キーを押したときに toggle_neotree_focus 関数を呼び出す
    vim.api.nvim_set_keymap('n', '<C-n>', [[:lua toggle_neotree_focus()<CR>]], { noremap = true, silent = true })
    -- copy file
    -- vim.api.nvim_set_keymap('n', 'm p', ':Neotree action=copy<CR>', {noremap = true, silent = true })
    -- -- paste file
    -- vim.api.nvim_set_keymap('n', 'm p', ':Neotree action=paste<CR>', { noremap = true, silent = true })
    -- -- create new file
    -- vim.api.nvim_set_keymap('n', 'm a', ':Neotree action=new_file<CR>', { noremap = true, silent = true })
    -- -- delete file
    -- vim.api.nvim_set_keymap('n', 'm d', ':Neotree action=delete<CR>', { noremap = true, silent = true })
    -- -- create dir
    -- vim.api.nvim_set_keymap('n', 'm f', ':Neotree action=new_directory<CR>', { noremap = true, silent = true })
    -- -- rename
    -- vim.api.nvim_set_keymap('n', 'm r', ':Neotree action=rename<CR>', { noremap = true, silent = true })
end

return config
