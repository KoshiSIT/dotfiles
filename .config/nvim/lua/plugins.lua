require("lazy").setup({
    defaults = {
        lazy = true,
        version = nil,
    },
    -- spec = {
    --     require("plugins.nightfox"),
    -- },
    -- {
    --     "xiyaowong/transparent.nvim",
    --     config = require("configs.transparent"),
    -- },
    -- {
    --     "stevearc/aerial.nvim",
    --     config = require("configs.aerial")
    -- },
    {
        "hedyhli/outline.nvim",
        config = require("configs.outline"),
    },
    {
        "EdenEast/nightfox.nvim",
        config = require("configs.nightfox"),
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = require("configs.nvim-colorizer"),
    },
    {
        "nvim-tree/nvim-web-devicons",
        config = require("configs.nvim-web-devions"),
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = require("configs.nvim-tree"),
    },
    -- {
    --     "petertriho/nvim-scrollbar",
    --     config = require("configs.nvim-scrollbar"),
    -- },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = require("configs.telescope"),
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
    },
    {
        "akinsho/toggleterm.nvim",
        config = require("configs.toggleterm"),
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = require("configs.nvim-treesitter"),
    },
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = require("configs.lualine"),
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = require("configs.barbar"),
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup({
                mappings = {
                    basic = true,
                    extra = false,
                },
            })
        end
    },
    {
        'williamboman/mason.nvim',
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            { "williamboman/mason.nvim" },
            { "neovim/nvim-lspconfig" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "nvim-lua/plenary.nvim" },
            { "nvimtools/none-ls.nvim" },
            { "jay-babu/mason-null-ls.nvim" },
        },
        config = require("configs.mason-lspconfig"),
    },
    {
        "L3MON4D3/LuaSnip",
        config = require("configs.luaSnip"),
    },
    {
        "zbirenbaum/copilot.lua",
        config = require("configs.copilot"),
    },
    {
        "AndreM222/copilot-lualine",
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = require("configs.codecompanion"),
    },
    {
        "keaising/im-select.nvim",
        config = function()
            require("im_select").setup({})
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config,
        config = require("configs.indent-blankline"),
        opts = {},
    },
    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- this plugin needs to run before anything else
        opts = {
            rocks = { "magick" },
        },
    },
    -- {
    --     "3rd/image.nvim",
    --     branch = "release-please--branches--master",
    --     dependencies = { "luarocks.nvim" },
    --     config = function()
    --         require("image").setup({
    --             backend = "kitty", -- または "ueberzug"
    --             -- backend = "ueberzug",     -- または "ueberzug"
    --             tmux_show_only_in_active_window = true
    --
    --         })
    --     end
    --
    -- },
    {
        "lervag/vimtex",
        lazy = false,
        config = require("configs.vimtex"),
        -- config = function()
        --     vim.notify("Loading vimtex configuration", vim.log.levels.INFO)
        -- end,

    },
    -- {
    --     "AckslD/nvim-neoclip.lua",
    --     dependencies = {
    --         -- you'll need at least one of these
    --         { 'nvim-telescope/telescope.nvim' },
    --         -- {'ibhagwan/fzf-lua'},
    --     },
    --     config = function()
    --         require('neoclip').setup()
    --         vim.keymap.set("n", "fpp", "<cmd>Telescope neoclip<CR>", { noremap = true, silent = true })
    --     end,
    -- },
    -- {
    --     'VonHeikemen/fine-cmdline.nvim',
    --     dependencies = {
    --         { 'MunifTanjim/nui.nvim' }
    --     },
    --     config = function()
    --         require('fine-cmdline').setup()
    --         vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', { noremap = true })
    --     end,
    -- },
    -- lazy.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        version = "4.4.7",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            {
                "rcarriga/nvim-notify",
                opts = {
                    background_colour = "#000000", -- 背景色を設定
                }
            }
        }
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.icons"
        },
        ft = { "codecompanion" },
        opt = {
            file_types = { "codecompanion" },
        },
    },
    {
        'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup({
            })
        end
    },
    {
        "folke/styler.nvim",
        config = require("configs.styler"),
    },
    {
        "Davidyz/VectorCode",
        version = "*", -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "VectorCode", -- if you're lazy-loading VectorCode
    }                 -- {
    --     "preservim/nerdtree",
    --     dependencies = {
    --     },
    --     config = function()
    --         vim.api.nvim_set_keymap('n', '<C-o>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
    --         vim.api.nvim_set_keymap('n', '<C-n>', '<C-w>w', { noremap = true, silent = true })
    --         vim.g.NERDTreeShowHidden = 1
    --         vim.g.NERDTreeWinSize = 25
    --     end
    -- },
    --
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    -- },
    -- {
    --     "vim-airline/vim-airline",
    --     dependencies = {
    --         "vim-airline/vim-airline-themes",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     config = function()
    --         vim.g.airline_powerline_fonts = 1
    --         vim.g.airline_theme = 'deus'
    --         vim.g.airline_left_sep = ''
    --         vim.g.airline_right_sep = ''
    --         vim.g['airline#extensions#tabline#enabled'] = 1
    --         -- Set the tabline formatter to 'unique_tail'
    --         vim.g['airline#extensions#tabline#formatter'] = 'unique_tail'
    --         vim.api.nvim_set_keymap('n', '<C-y>', '<Plug>AirlineSelectPrevTab', {})
    --         vim.api.nvim_set_keymap('n', '<C-i>', '<Plug>AirlineSelectNextTab', {})
    --     end,
    -- },
})
