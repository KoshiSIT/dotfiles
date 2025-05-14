local config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    ls.setup({
    })
    -- ls.add_snippets = {
    --     -- rust = require(snippet_path .. "/rust_snippets"),
    --     -- rust = require("snippets.rust_snippets"),
    --     all = require("snippets.rust_snippets"),
    -- }
    -- ls.add_snippets("all", {
    --     require("snippets.rust_snippets"),
    -- })
    ls.add_snippets("rust", require("snippets.rust_snippets"))
    vim.keymap.set({ "i" }, "<C-s>", function() ls.expand() end, { silent = true })
end

return config
