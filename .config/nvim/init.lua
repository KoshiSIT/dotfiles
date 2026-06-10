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

local function prepend_path(path)
    if vim.fn.isdirectory(path) == 0 then
        return
    end

    local current_path = vim.env.PATH or ""
    for entry in string.gmatch(current_path, "([^:]+)") do
        if entry == path then
            return
        end
    end

    vim.env.PATH = path .. ":" .. current_path
end

prepend_path(vim.fn.expand("~/.local/share/mise/shims"))

require("plugins")
require("options")
require("color_scheme")
-- vim.api.nvim_set_hl(0, "BufferCurrent", {fg = "#000000", bg = "#ffffff"})
