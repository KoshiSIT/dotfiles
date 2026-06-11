local config = function()
    local cmp = require("cmp")
    local null_ls = require("null-ls")
    require("mason").setup()
    vim.opt.pumblend = 0
    vim.opt.winblend = 0
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
        },
        window = {
            completion = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                border = "rounded",
                col_offset = -3,
                side_padding = 0,
            }),
            documentation = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                border = "rounded",
            }),
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "vsnip" },
        }, {
            { name = "buffer" },
        }),
    })

    -- Apply shared capabilities (from cmp) to all servers
    vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- Per-server config for lua_ls (replaces the old lspconfig.lua_ls.setup)
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                },
                diagnostics = {
                    globals = { "vim" },
                    disable = { "undefined-global", "lowercase-global" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                    preloadFileSize = 10000,
                },
                telemetry = {
                    enable = false,
                },
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    })

    require("mason-lspconfig").setup({
        ensure_installed = {
            "pyright", "clangd", "lua_ls", "rust_analyzer",
            "texlab", "html", "ts_ls", "jsonls",
        },
        automatic_enable = true, -- Auto-enable installed servers via vim.lsp.enable()
    })

    require("mason-null-ls").setup({
        ensure_installed = { "black", "prettier", "rustfmt", "hadolint" },
        automatic_installation = true,
    })

    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.prettier.with({
                filetypes = {
                    "html", "htmldjango", "json", "yaml",
                    "markdown", "css", "javascript", "typescript",
                },
            }),
        },
    })

    local function open_lsp_item(item)
        local win = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_get_current_buf()
        local from = vim.fn.getpos(".")
        from[1] = bufnr

        vim.cmd("normal! m'")
        vim.fn.settagstack(vim.fn.win_getid(win), {
            items = {
                { tagname = vim.fn.expand("<cword>"), from = from },
            },
        }, "t")

        local target_buf = item.bufnr or vim.fn.bufadd(item.filename)
        vim.bo[target_buf].buflisted = true

        local ok, err = pcall(vim.api.nvim_win_set_buf, win, target_buf)
        if not ok then
            local err_msg = tostring(err)
            if not err_msg:match("E325") and not err_msg:match("E303") then
                vim.notify(err_msg, vim.log.levels.ERROR)
                return
            end

            vim.bo[target_buf].swapfile = false
            ok, err = pcall(vim.api.nvim_win_set_buf, win, target_buf)
            if not ok then
                vim.notify(tostring(err), vim.log.levels.ERROR)
                return
            end

            vim.notify("Opened without swapfile because a swap file already exists", vim.log.levels.WARN)
        end

        vim.api.nvim_win_set_cursor(win, { item.lnum, math.max((item.col or 1) - 1, 0) })
        vim.cmd("normal! zv")
    end

    local function handle_lsp_list(options)
        if #options.items == 1 then
            open_lsp_item(options.items[1])
            return
        end

        vim.fn.setqflist({}, " ", options)
        vim.cmd("botright copen")
    end

    local function lsp_location_jump(fn)
        return function()
            fn({
                reuse_win = true,
                on_list = handle_lsp_list,
            })
        end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local opts = { buffer = args.buf, noremap = true, silent = true }

            vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gf", function() vim.lsp.buf.format { async = true } end, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "gd", lsp_location_jump(vim.lsp.buf.definition), opts)
            vim.keymap.set("n", "gD", lsp_location_jump(vim.lsp.buf.declaration), opts)
            vim.keymap.set("n", "gi", lsp_location_jump(vim.lsp.buf.implementation), opts)
            vim.keymap.set("n", "gt", lsp_location_jump(vim.lsp.buf.type_definition), opts)
            vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts)
        end,
    })

    vim.diagnostic.config({
        virtual_text = {
            format = function(diagnostic)
                return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
            end,
        },
        virtual_lines = true,
    })
end
return config
