local config = function()
    require('codecompanion').setup({
        strategies = {
            chat = {
                roles = {
                    llm = function(adapter)
                        return "  CodeCompanion (" .. adapter.formatted_name .. ")"
                    end,
                    user = "󰙄  Koshi",
                },
                adapter = 'copilot',
                keymaps = {
                    send = {
                        modes = { n = "<C-CR>", i = "<C-CR>" },
                    },
                    close = {
                        modes = { n = "ccc", i = "ccc" },
                    },
                },
            },
            inline = {
                adapter = 'copilot',
            },
            agent = {
                adapter = 'copilot',
            },
            cmd = {
                adapter = 'copilot',
            },
        },
        -- extensions = {
        --     vectorcode = {
        --         opts = {
        --             add_tool = true,
        --         }
        --     }
        -- },
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {
                        model = {
                            default = "claude-3.7-sonnet",
                        },
                    }
                })
            end,
        },
        opts = {
            language = "Japanese",
        },
        display = {
            chat = {
                -- Change the default icons
                icons = {
                    pinned_buffer = " ",
                    watched_buffer = "👀 ",
                },
                show_header_separator = true,
                -- Alter the sizing of the debug window
                debug_window = {
                    ---@return number|fun(): number
                    width = vim.o.columns - 5,
                    ---@return number|fun(): number
                    height = vim.o.lines - 2,
                },
                action_palette = {
                    -- プロバイダーの選択（"default", "telescope", "mini_pick"のいずれか）
                    provider = "telescope",

                },
                -- Options to customize the UI of the chat buffer
                window = {
                    layout = "vertical", -- float|vertical|horizontal|buffer
                    position = "right",  -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
                    border = "single",
                    height = 0.8,
                    width = 0.37,
                    relative = "editor",
                    full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
                    opts = {
                        breakindent = true,
                        cursorcolumn = false,
                        cursorline = false,
                        foldcolumn = "0",
                        linebreak = true,
                        list = false,
                        numberwidth = 1,
                        signcolumn = "no",
                        spell = false,
                        wrap = true,
                    },
                },

                ---Customize how tokens are displayed
                ---@param tokens number
                ---@param adapter CodeCompanion.Adapter
                ---@return string
                token_count = function(tokens, adapter)
                    return " (" .. tokens .. " tokens)"
                end,
            },
        },
    })

    -- vim.api.nvim_create_autocmd("FileType", {
    --     pattern = "CodeCompanionChat",
    --     callback = function()
    --         vim.cmd("wincmd L")
    --         vim.cmd("vertical resize 50")
    --     end
    -- })

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            package.loaded["codecompanion.providers.actions.telescope"] = nil
            local telescope_provider = require("codecompanion.providers.actions.telescope")
            local original_picker = telescope_provider.picker

            telescope_provider.picker = function(self, items, opts)
                opts = opts or {}

                -- 名前の最大長を計算
                local max_name = 1
                for _, item in ipairs(items) do
                    max_name = math.max(max_name, #item.name)
                end

                -- 表示レイアウトを作成 - 3列レイアウト
                local displayer = require("telescope.pickers.entry_display").create({
                    separator = " │ ", -- 区切り文字を追加
                    items = {
                        { width = max_name + 1 },
                        { width = 12 },       -- カテゴリ/タイプの列（適宜調整）
                        { remaining = true }, -- 説明用に残りのスペースを使用
                    },
                })

                -- 表示フォーマット関数
                local function make_display(entry)
                    local item = entry.value
                    local description = item.description or ""
                    -- 説明が長すぎる場合は切り詰める
                    if #description > 50 then
                        description = description:sub(1, 47) .. "..."
                    end

                    return displayer({
                        { item.name,                 "TelescopeResultsIdentifier" },
                        { item.strategy or "action", "TelescopeResultsNumber" },
                        { description,               "TelescopeResultsComment" },
                    })
                end

                opts.previewer = false
                opts.theme = "dropdown"
                opts.layout_config = { width = 0.4, height = 0.3 }
                opts.borderchars = {
                    prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                    preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                }

                opts.finder = require("telescope.finders").new_table({
                    results = items,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = make_display,
                            ordinal = entry.name,
                        }
                    end,
                })

                return original_picker(self, items, opts)
            end

            package.loaded["codecompanion.providers.slash_commands.telescope"] = nil
            local slash_telescope = require("codecompanion.providers.slash_commands.telescope")
            local original_new = slash_telescope.new

            slash_telescope.new = function(opts)
                local instance = original_new(opts)

                -- オリジナルのメソッドを保存
                local original_display = instance.display

                -- find_filesの呼び出し部分を直接オーバーライド
                local original_provider = instance.provider
                instance.provider = setmetatable({}, {
                    __index = function(_, key)
                        if key == "find_files" then
                            return function(options)
                                -- オプションにプレビューを無効化する設定を追加
                                options = options or {}
                                options.previewer = false
                                return original_provider.find_files(options)
                            end
                        end
                        return original_provider[key]
                    end
                })

                -- display メソッドをオーバーライド
                instance.display = function(self)
                    local attach_mappings = original_display(self)

                    return function(prompt_bufnr, map)
                        -- オリジナルのマッピングを適用
                        if attach_mappings then
                            attach_mappings(prompt_bufnr, map)
                        end

                        return true
                    end
                end

                return instance
            end
        end,
    })
    vim.keymap.set({ "n", "v" }, "<C-i>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<C-c>", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
end

return config
