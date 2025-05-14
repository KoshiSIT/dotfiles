local config = function()
    local transparent = require('transparent')
    transparent.setup({
        enable = true,
        extra_groups = {
            "BufferLineTabClose",
            "BufferlineBufferSelected",
            "BufferLineFill",
            "BufferLineBackground",
            "BufferLineSeparator",
            "BufferLineIndicatorSelected",
        },
    })
    transparent.clear_prefix('BufferLine')
    transparent.clear_prefix('NeoTree')
    transparent.clear_prefix('lualine')
end

return config
