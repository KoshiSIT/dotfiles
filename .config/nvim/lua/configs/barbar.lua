local config = function()
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Basic barbar tab configuration
    vim.g.barbar_auto_setup = false
    require 'barbar'.setup({
        animation = true,
        insert_at_end = true,
        minimum_padding = 3,
        maximum_padding = 3,
        clickable = false,
        sidebar_filetypes = {
            NvimTree = {
                enable = true,
                text = '󰦄 Nvim-Tree',
            },
            ['neo-tree'] = { event = 'BufWinLeave' },
        },
        hide = {
            inactive = true,
        },
        icons = {
            button = '',
        },
    })

    vim.cmd([[
        hi BufferOffset guifg=#ff0000 guibg=#121212 gui=bold
        hi BufferOffsetSeparator guifg=#3b4261 gui=none
    ]])

    -- Safer nvim-tree integration
    local function setup_nvim_tree_integration()
        -- Try multiple ways to load nvim-tree APIs
        local nvim_tree_api = nil
        local nvim_tree_events = nil
        local barbar_api = nil

        -- Try to load nvim-tree.api
        local success_api, api = pcall(require, 'nvim-tree.api')
        if success_api then
            nvim_tree_api = api
        end

        -- Try to load nvim-tree.events
        local success_events, events = pcall(require, 'nvim-tree.events')
        if success_events then
            nvim_tree_events = events
        end

        -- Try to load barbar.api
        local success_barbar, bapi = pcall(require, 'barbar.api')
        if success_barbar then
            barbar_api = bapi
        end

        -- Check if integration is possible
        if not (nvim_tree_api and barbar_api) then
            -- vim.notify("nvim-tree integration disabled: missing API", vim.log.levels.INFO)
            return
        end

        local function update_barbar_offset()
            -- Check if nvim-tree is visible
            local tree_wins = vim.tbl_filter(function(win)
                local buf = vim.api.nvim_win_get_buf(win)
                local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
                return filetype == 'NvimTree'
            end, vim.api.nvim_list_wins())

            if #tree_wins > 0 then
                local tree_width = vim.api.nvim_win_get_width(tree_wins[1])
                barbar_api.set_offset(tree_width)
            else
                barbar_api.set_offset(0)
            end
        end

        -- Event registration (when nvim-tree.events is available)
        if nvim_tree_events then
            local success_open = pcall(nvim_tree_events.subscribe, 'TreeOpen', function()
                vim.defer_fn(update_barbar_offset, 10)
            end)

            local success_close = pcall(nvim_tree_events.subscribe, 'TreeClose', function()
                barbar_api.set_offset(0)
            end)

            if not (success_open and success_close) then
                -- vim.notify("Failed to register nvim-tree events", vim.log.levels.WARN)
            end
        end

        -- Alternative: Monitor NvimTree buffer changes with autocmd
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
            pattern = 'NvimTree*',
            callback = function()
                vim.defer_fn(update_barbar_offset, 10)
            end,
        })

        vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWinLeave' }, {
            pattern = 'NvimTree*',
            callback = function()
                vim.defer_fn(function()
                    -- Check if NvimTree window still exists
                    local tree_exists = false
                    for _, win in pairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
                        if filetype == 'NvimTree' then
                            tree_exists = true
                            break
                        end
                    end
                    if not tree_exists then
                        barbar_api.set_offset(0)
                    end
                end, 10)
            end,
        })

        -- Handle window resize
        vim.api.nvim_create_autocmd('VimResized', {
            callback = function()
                update_barbar_offset()
            end,
        })
    end

    -- NvimTree statusline configuration
    vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "NvimTree*",
        callback = function()
            vim.cmd("setlocal statusline=\\ \\ Explorer")
        end,
    })

    -- Setup nvim-tree integration
    setup_nvim_tree_integration()

    -- Existing keymap settings
    map('n', '<Space>,', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<Space>.', '<Cmd>BufferNext<CR>', opts)
    map('n', '<Space><', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<Space>>', '<Cmd>BufferMoveNext<CR>', opts)
    map('n', '<Space>1', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<Space>2', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<Space>3', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<Space>4', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<Space>5', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<Space>6', '<Cmd>BufferGoto 6<CR>', opts) -- Fixed: 5→6
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
