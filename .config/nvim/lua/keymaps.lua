-- key mapping
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', 'J', '3j', { noremap = true })
vim.keymap.set('n', 'K', '3k', { noremap = true })
-- Move the cursor in insert mode with Ctrl+hjkl, similar to normal mode
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', '<C-w>w', { noremap = true, silent = true })

vim.api.nvim_create_user_command('BufferPath', function(opts)
    local path = vim.fn.expand('%:p')
    if path == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.INFO, { title = "BufferPath" })
        return
    end

    if opts.bang then
        vim.fn.setreg('+', path)
        vim.notify("Copied current buffer path", vim.log.levels.INFO, { title = "BufferPath" })
        return
    end

    vim.notify(path, vim.log.levels.INFO, { title = "BufferPath" })
end, {
    bang = true,
    desc = "Show current buffer path (! to copy)",
})

-- Move to the end of the line in normal mode with Shift+l
-- vim.api.nvim_set_keymap('n', '<S-h>', '^', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<S-h>', '^', { noremap = true, silent = true })
-- Move to the end of the line in normal mode with Shift+l
-- Move to the end of the line in normal mode with Shift+l
-- vim.api.nvim_set_keymap('n', '<S-l>', '$', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<S-h>', '^', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<S-h>', '^', { noremap = true, silent = true })

-- Window resize with Option+hjkl (Mac), relative to the current window.
local resize_step = 1

local function resize_amount()
    return math.max(1, vim.v.count1) * resize_step
end

local function neighbor_winid(direction)
    local current_winnr = vim.fn.winnr()
    local target_winnr = vim.fn.winnr(direction)
    if target_winnr == current_winnr then
        return nil
    end
    return vim.fn.win_getid(target_winnr)
end

local function set_win_width(winid, delta)
    local min_width = math.max(vim.o.winminwidth, 1)
    local width = vim.api.nvim_win_get_width(winid)
    vim.api.nvim_win_set_width(winid, math.max(min_width, width + delta))
end

local function set_win_height(winid, delta)
    local min_height = math.max(vim.o.winminheight, 1)
    local height = vim.api.nvim_win_get_height(winid)
    vim.api.nvim_win_set_height(winid, math.max(min_height, height + delta))
end

local function move_right_edge(direction)
    local amount = resize_amount()
    local current_win = vim.api.nvim_get_current_win()
    local right_win = neighbor_winid('l')

    if not right_win then
        return
    end

    if direction == 'left' then
        set_win_width(current_win, -amount)
    else
        set_win_width(current_win, amount)
    end
end

local function move_left_edge(direction)
    local amount = resize_amount()
    local left_win = neighbor_winid('h')

    if not left_win then
        return
    end

    if direction == 'left' then
        set_win_width(left_win, -amount)
    else
        set_win_width(left_win, amount)
    end
end

local function move_window_edge_vertical(direction)
    local amount = resize_amount()
    local current_win = vim.api.nvim_get_current_win()
    local up_win = neighbor_winid('k')
    local down_win = neighbor_winid('j')

    if direction == 'up' then
        if up_win then
            set_win_height(up_win, -amount)
        elseif down_win then
            set_win_height(current_win, -amount)
        end
        return
    end

    if down_win then
        set_win_height(current_win, amount)
    elseif up_win then
        set_win_height(current_win, -amount)
    end
end

vim.keymap.set('n', '<A-h>', function() move_right_edge('left') end, { noremap = true, silent = true, desc = 'Move right edge left' })
vim.keymap.set('n', '<A-l>', function() move_right_edge('right') end, { noremap = true, silent = true, desc = 'Move right edge right' })
vim.keymap.set('n', '<C-A-h>', function() move_left_edge('left') end, { noremap = true, silent = true, desc = 'Move left edge left' })
vim.keymap.set('n', '<C-A-l>', function() move_left_edge('right') end, { noremap = true, silent = true, desc = 'Move left edge right' })
vim.keymap.set('n', '<A-H>', function() move_left_edge('left') end, { noremap = true, silent = true, desc = 'Move left edge left' })
vim.keymap.set('n', '<A-L>', function() move_left_edge('right') end, { noremap = true, silent = true, desc = 'Move left edge right' })
vim.keymap.set('n', '<A-k>', function() move_window_edge_vertical('up') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', function() move_window_edge_vertical('down') end, { noremap = true, silent = true })
