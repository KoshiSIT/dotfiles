local config = function()
    require("outline").setup({
    })
    vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>")
end
return config
