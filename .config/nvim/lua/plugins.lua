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
    -- {
    --     "hedyhli/outline.nvim",
    --     config = require("configs.outline"),
    -- },
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
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
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
    -- {
    --     'nvim-telescope/telescope-ui-select.nvim',
    -- },
    {
        "akinsho/toggleterm.nvim",
        config = require("configs.toggleterm"),
    },
    {
        "nvim-treesitter/nvim-treesitter",
        priority = 1000,
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
        end,
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
        -- tag = "v15.0.0",
        -- tag = "v14.2.0",
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
        opts = {
            -- add any options here
            -- debug = true,
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
                    background_colour = "#000000",
                },
            },
        },
    },
    -- {
    --     "MeanderingProgrammer/render-markdown.nvim",
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "echasnovski/mini.icons"
    --     },
    --     ft = { "codecompanion" },
    --     opt = {
    --         file_types = { "codecompanion" },
    --     },
    -- },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = require("configs.markview"),
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
            'rfc_semicolon',
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim',
        },
    },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup({
            })
        end,
    },
    -- {
    --     "folke/tokyonight.nvim",
    --     config = function()
    --         require("tokyonight").setup({
    --             style = "storm",
    --             light_style = "day",
    --             transparent = true,
    --             terminal_colors = true,
    --             styles = {
    --                 sidebars = "transparent",
    --                 floats = "transparent",
    --             },
    --         })
    --     end
    -- },
    -- Using Lazy
    -- {
    --     "navarasu/onedark.nvim",
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         require('onedark').setup {
    --             style = 'darker'
    --         }
    --         -- Enable theme
    --         require('onedark').load()
    --     end
    -- },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        "folke/styler.nvim",
        config = require("configs.styler"),
    },
    {
        "Davidyz/VectorCode",
        version = "*",      -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "VectorCode", -- if you're lazy-loading VectorCode
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        config = true,
        keys = {
            { "<leader>a",  nil,                              desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                 desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            picker = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- Wrap notifications
                },
            },
        },
        keys = {
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
            { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
            { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
            -- find
            { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
            { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
            { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
            -- git
            { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
            { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
            { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
            -- Grep
            { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
            { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
            -- search
            { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
            { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
            { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
            { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
            { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
            { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
            { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
            { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
            { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
            { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
            { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
            { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
            { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
            { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
            { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
            { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
            { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
            -- LSP
            { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
            { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
            { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
            { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
            { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
            { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
            { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
            -- Other
            { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
            { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
            { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
            { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
            { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
            { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
            { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
            { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
            { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
            { "<c-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
            { "<c-_>",           function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
            { "]]",              function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
            { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },
            {
                "<leader>N",
                desc = "Neovim News",
                function()
                    Snacks.win({
                        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                        width = 0.6,
                        height = 0.6,
                        wo = {
                            spell = false,
                            wrap = false,
                            signcolumn = "yes",
                            statuscolumn = " ",
                            conceallevel = 3,
                        },
                    })
                end,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                        "<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },
})
