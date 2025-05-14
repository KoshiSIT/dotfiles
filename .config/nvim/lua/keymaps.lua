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

-- Delete current line without yanking with dd
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })

-- Delete character without yanking with x
vim.keymap.set('n', 'x', '"_x', { noremap = true })

-- Delete from cursor to end of line without yanking with D
vim.keymap.set('n', 'D', '"_D', { noremap = true })

-- Delete in visual mode without yanking
vim.keymap.set('v', 'd', '"_d', { noremap = true })
-- Move the cursor to the beginning of the line in normal mode with Shift+h
-- vim.api.nvim_set_keymap('n', '<S-h>', '^', { noremap = true, silent = true })

-- Move to the end of the line in normal mode with Shift+l
-- vim.api.nvim_set_keymap('n', '<S-l>', '$', { noremap = true, silent = true })

