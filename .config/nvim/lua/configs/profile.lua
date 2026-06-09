local config = function()
    local should_profile = vim.env.NVIM_PROFILE
    local ok, prof = pcall(require, "profile")
    if not ok then
        vim.notify("profile.nvim is not available: " .. tostring(prof), vim.log.levels.ERROR)
        return
    end

    local source = debug.getinfo(1, "S").source:sub(2)
    local real_source = vim.uv.fs_realpath(source) or source
    local dotfiles_dir = vim.fn.fnamemodify(real_source, ":h:h:h:h:h")
    local profile_dir = dotfiles_dir .. "/.nvim-profiles"
    local profile_file = profile_dir .. "/profile.json"
    local default_patterns = {
        "snacks*",
        "ibl*",
        "lualine*",
        "gitsigns*",
        "vim.lsp*",
        "vim.diagnostic*",
        "vim.treesitter*",
    }
    local unpack = table.unpack or unpack
    local autocmds_instrumented = false

    local function ensure_profile_dir()
        vim.fn.mkdir(profile_dir, "p")
    end

    local function profile_patterns(args)
        if args and args ~= "" then
            return vim.split(args, "%s+", { trimempty = true })
        end
        return default_patterns
    end

    local function instrument_autocmds()
        if autocmds_instrumented then
            return
        end
        prof.instrument_autocmds()
        autocmds_instrumented = true
    end

    local function start_profile(args)
        local patterns = profile_patterns(args)
        instrument_autocmds()
        prof.start(unpack(patterns))
        vim.notify("profile.nvim started: " .. table.concat(patterns, ", "))
    end

    local function stop_and_export()
        prof.stop()
        ensure_profile_dir()
        prof.export(profile_file)
        vim.notify("profile.nvim wrote " .. profile_file)
    end

    if should_profile and should_profile:lower():match("^start") then
        start_profile()
    elseif should_profile then
        instrument_autocmds()
        prof.instrument("*")
        vim.notify("profile.nvim armed. Press <F1> or run :NvimProfileToggle")
    end

    vim.api.nvim_create_user_command("NvimProfileStart", function(opts)
        start_profile(opts.args)
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("NvimProfileStop", function()
        stop_and_export()
    end, {})

    vim.api.nvim_create_user_command("NvimProfileToggle", function(opts)
        if prof.is_recording() then
            stop_and_export()
        else
            start_profile(opts.args)
        end
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("NvimProfilePath", function()
        print(profile_file)
    end, {})

    vim.keymap.set("", "<F1>", function()
        if prof.is_recording() then
            stop_and_export()
        else
            start_profile()
        end
    end, { noremap = true, silent = true, desc = "Toggle Neovim profiling" })
end

return config
