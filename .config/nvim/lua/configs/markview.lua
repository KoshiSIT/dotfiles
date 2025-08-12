local config = function()
    local markview = require("markview")
    markview.setup({
        preview = {
            filetypes = { "codecompanion" },
        },
    })
end

return config
