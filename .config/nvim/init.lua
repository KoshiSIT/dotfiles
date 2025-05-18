require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
require("plugins")
require("options")
require("color_scheme")
require("functions")
-- vim.api.nvim_set_hl(0, "BufferCurrent", {fg = "#000000", bg = "#ffffff"})
