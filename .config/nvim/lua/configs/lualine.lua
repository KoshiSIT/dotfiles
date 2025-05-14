local config = function()
    local custom_theme = function()
        local colors = {
            deepskyblue = "#00bfff",
            darkgray = "#000000",
            gray = "#00bfff",
            innerbg = nil,
            outerbg = nil,
            normal = "#f5fffa",
            insert = "#98bb6c",
            visual = "#ffa066",
            replace = "#e46876",
            command = "#e6c384",
        }
        return {
            inactive = {
                a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
                b = { fg = colors.gray, bg = colors.outerbg },
                c = { fg = colors.gray, bg = colors.innerbg },
            },
            visual = {
                a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
                b = { fg = colors.gray, bg = colors.outerbg },
                c = { fg = colors.gray, bg = colors.innerbg },
            },
            replace = {
                a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
                b = { fg = colors.gray, bg = colors.outerbg },
                c = { fg = colors.gray, bg = colors.innerbg },
            },
            normal = {
                a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
                b = { fg = colors.gray, bg = colors.outerbg },
                c = { fg = colors.gray, bg = colors.innerbg },
            },
            insert = {
                a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
                b = { fg = colors.gray, bg = colors.outerbg },
                c = { fg = colors.gray, bg = colors.innerbg },
            },
            command = {
                a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
                b = { fg = colors.gray, bg = colors.outerbg },
                c = { fg = colors.gray, bg = colors.innerbg },
            },
        }
    end
    require('lualine').setup {
        options = {
            theme = custom_theme, -- you can select theme
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            globalstatus = true, -- for neovim 0.7+
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch' },
            lualine_c = {
                'filename',
            },
            lualine_x = {
                {
                    'copilot',
                    -- Copilot の状態に応じたカスタムシンボルと色の設定
                    symbols = {
                        status = {
                            icons = {
                                enabled = " ", -- Copilot が有効な場合のアイコン
                                sleep = " ", -- Copilot がスリープ中のアイコン
                                disabled = " ", -- Copilot が無効な場合のアイコン
                                warning = " ", -- 警告がある場合のアイコン
                                unknown = " " -- 状態が不明な場合のアイコン
                            },
                            hl = {
                                enabled = "#50FA7B",  -- 有効な場合の色
                                sleep = "#50FA7B",    -- スリープ中の色
                                disabled = "#6272A4", -- 無効な場合の色
                                warning = "#FFB86C",  -- 警告がある場合の色
                                unknown = "#FF5555"   -- 状態が不明な場合の色
                            }
                        },
                        spinners = require("copilot-lualine.spinners").dots,
                        spinner_color = "#6272A4" -- スピナーの色
                    },
                    show_colors = true,           -- 色を表示するオプション
                    show_loading = true           -- 読み込み中の表示オプション
                },
                require('lualine/cc-component'),
                'encoding',
                'fileformat',
                'filetype',
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        -- tabline = {
        --     lualine_a = {
        --         {
        --             'buffers',
        --             mode = 4,
        --             icons_enabled = true,
        --             show_filename_only = true,
        --             hide_filename_extensions = false
        --         },
        --     },
        --     lualine_x = { 'tabs' },
        --     lualine_y = {},
        --     lualine_z = {}
        -- },
    }

    -- change to previous buffer
    -- vim.api.nvim_set_keymap('n', '<C-y>', ':bprevious<CR>', { noremap = true, silent = true })
    --
    -- -- change to next buffer
    -- vim.api.nvim_set_keymap('n', '<C-i>', ':bnext<CR>', { noremap = true, silent = true })
end
return config
