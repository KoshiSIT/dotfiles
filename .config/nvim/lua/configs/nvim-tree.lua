local config = function()
    local nvim_tree = require('nvim-tree')

    -- 前回のウィンドウIDを保存する変数
    local last_win = nil


    local function is_excluded_window(win)
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_ft = vim.api.nvim_buf_get_option(buf, "filetype")
        local win_config = vim.api.nvim_win_get_config(win)

        -- notify ウィンドウの検出を追加
        local is_notify = buf_ft == "notify" or
            string.match(buf_name, "notify") or
            (win_config.relative ~= "" and not win_config.focusable)

        -- その他の除外条件（既存のコード）
        local is_tree = buf_ft == "NvimTree" or
            buf_ft == "neo-tree" or
            string.match(buf_name, "NvimTree") or
            string.match(buf_name, "neo%-tree")

        -- local is_outline = buf_ft == "Outline" or
        --     string.match(buf_name, "Outline") or
        --     buf_ft == "outline"
        --
        -- その他の除外したいウィンドウタイプも追加
        return is_tree or is_notify or buf_ft == "qf" or buf_ft == "help"
        -- return is_tree or is_notify or is_outline or buf_ft == "qf" or buf_ft == "help"
    end

    -- ウィンドウの位置を交換する関数
    local function swap_non_tree_windows()
        local wins = vim.api.nvim_list_wins()
        local non_tree_windows = {}

        for _, win in ipairs(wins) do
            if not is_excluded_window(win) then
                table.insert(non_tree_windows, win)
            end
        end

        if #non_tree_windows == 2 then
            local buf1 = vim.api.nvim_win_get_buf(non_tree_windows[1])
            local buf2 = vim.api.nvim_win_get_buf(non_tree_windows[2])

            vim.api.nvim_win_set_buf(non_tree_windows[1], buf2)
            vim.api.nvim_win_set_buf(non_tree_windows[2], buf1)
        end
    end

    -- nvim-tree以外のウィンドウ間を移動する関数
    local function move_between_non_tree_windows()
        local current_win = vim.api.nvim_get_current_win()

        if is_excluded_window(current_win) then
            return
        end

        local non_tree_windows = {}
        local wins = vim.api.nvim_list_wins()
        for _, win in ipairs(wins) do
            if not is_excluded_window(win) then
                table.insert(non_tree_windows, win)
            end
        end

        local current_index = 0
        for i, win in ipairs(non_tree_windows) do
            if win == current_win then
                current_index = i
                break
            end
        end

        local next_index = (current_index % #non_tree_windows) + 1
        if non_tree_windows[next_index] then
            vim.api.nvim_set_current_win(non_tree_windows[next_index])
        end
    end

    -- nvim-treeとその他のウィンドウ間を移動する関数
    local function toggle_tree_focus()
        local current_win = vim.api.nvim_get_current_win()
        local current_buf = vim.api.nvim_win_get_buf(current_win)
        local current_buf_name = vim.api.nvim_buf_get_name(current_buf)

        local is_tree = string.match(current_buf_name, "NvimTree_") ~= nil

        if is_tree then
            if last_win and vim.api.nvim_win_is_valid(last_win) then
                vim.api.nvim_set_current_win(last_win)
            else
                print("No last window found, focusing on the first valid window")
                local wins = vim.api.nvim_list_wins()
                for _, win in ipairs(wins) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    local buf_name = vim.api.nvim_buf_get_name(buf)
                    if not string.match(buf_name, "NvimTree_") then
                        vim.api.nvim_set_current_win(win)
                        return
                    end
                end
            end
        else
            last_win = current_win

            local wins = vim.api.nvim_list_wins()
            for _, win in ipairs(wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.api.nvim_buf_get_name(buf)
                if string.match(buf_name, "NvimTree_") then
                    vim.api.nvim_set_current_win(win)
                    return
                end
            end

            vim.cmd('NvimTreeFocus')
        end
    end

    -- キーマッピングの設定
    vim.keymap.set('n', '<C-s>', swap_non_tree_windows, { noremap = true, silent = true })
    vim.keymap.set('n', '<C-g>', toggle_tree_focus, { noremap = true, silent = true })
    vim.keymap.set('n', '<C-n>', move_between_non_tree_windows, { noremap = true, silent = true })
    vim.keymap.set('n', '<C-o>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

    -- nvim-treeの設定
    nvim_tree.setup({
        actions = {
            open_file = {
                quit_on_open = false,
                window_picker = {
                    enable = false,
                },
            },
        },
        view = {
            width = {
                -- min = function() return math.floor(vim.opt.columns:get() * 0.15) end,
                -- max = function() return math.floor(vim.opt.columns:get() * 0.15) end,
                min = 30,
                max = 30,
            },
            float = {
                enable = false,
            },
        },
        renderer = {
            full_name = true,
            group_empty = true,
            special_files = {},
            symlink_destination = false,
            indent_markers = {
                enable = false,
            },
            icons = {
                git_placement = "signcolumn",
                glyphs = {
                    git = {
                        unstaged = "U",
                        staged = "S",
                        unmerged = "UM",
                        renamed = "R",
                        deleted = "D",
                        untracked = "NT",
                        ignored = "I",
                    },
                },
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                },
            },
        },
        on_attach = function(bufnr)
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- APIをローカルで定義
            local api = require('nvim-tree.api')
            local function set_root_to_cursor_dir()
                -- カーソル位置のノードを取得
                local node = api.tree.get_node_under_cursor()

                -- ノードがディレクトリの場合のみ実行
                if node.type == "directory" then
                    -- ディレクトリパスを取得
                    local path = node.absolute_path

                    -- ルートディレクトリを変更
                    api.tree.change_root(path)

                    vim.notify("Changed root to: " .. path)
                else
                    vim.notify("Not a directory", vim.log.levels.WARN)
                end
            end
            -- デフォルトのキーマッピングを適用
            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', '<CR>', function()
                local node = api.tree.get_node_under_cursor()
                if not node then return end

                local function is_image_file(filename)
                    local image_extensions = { "png", "jpg", "jpeg", "gif", "webp", "svg", "pdf" }
                    local ext = string.lower(string.match(filename, "%.(%w+)$") or "")
                    for _, valid_ext in ipairs(image_extensions) do
                        if ext == valid_ext then
                            return true
                        end
                    end
                    return false
                end

                if node.name == ".." then
                    api.tree.change_root_to_parent()
                elseif node.type == 'file' then
                    if is_image_file(node.name) then
                        api.node.run.system()
                    else
                        -- それ以外のファイルはデフォルトの動作を使用
                        api.node.open.edit()
                    end
                elseif node.type == 'directory' then
                    api.node.open.edit()
                end
            end, opts('Open File, Expand Directory, or Navigate Up'))
            vim.keymap.set('n', '<C-d>', function()
                local node = api.tree.get_node_under_cursor()
                if node and node.type == 'file' then
                    local current_buf = vim.api.nvim_get_current_buf()
                    pcall(function()
                        vim.cmd('vsplit ' .. vim.fn.fnameescape(node.absolute_path))
                        vim.cmd('wincmd L')
                    end)
                end
            end, opts('Open File in Vertical Split on the Far Right')) -- highlight 設定を追加
            vim.keymap.set("n", "<C-h>", set_root_to_cursor_dir, opts("Set Root To Cursor Directory"))
        end,
    })

    -- 起動時の設定
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            local api = require('nvim-tree.api')
            api.tree.open()
            vim.defer_fn(function()
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.bo[bufnr].filetype ~= 'NvimTree' and
                        vim.api.nvim_buf_get_name(bufnr) == '' then
                        vim.cmd('bdelete! ' .. bufnr)
                    end
                end
            end, 10)
        end

    })
end

return config
