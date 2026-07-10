-- Helper: find app windows without hs.window.filter
-- (app:mainWindow() can miss some windows, while allWindows() includes
--  minimized and cross-space windows without a global ordered scan)
local function findAppWindow(app)
    local wins = app:allWindows()
    if wins and #wins > 0 then
        return wins[1]
    end
    return nil
end

local function bindAppToggle(mods, key, appName, bundleID)
    hs.hotkey.bind(mods, key, function()
        local app = hs.application.find(appName)

        -- Case 1: not running -> launch
        if app == nil then
            hs.application.launchOrFocus(appName)
            return
        end

        -- Case 2: app is frontmost -> hide
        local frontApp = hs.application.frontmostApplication()
        if frontApp and frontApp:bundleID() == app:bundleID() then
            app:hide()
            return
        end

        -- Find app window
        local win = findAppWindow(app)

        -- Case 3: no window found -> just activate
        if win == nil then
            app:activate()
            return
        end

        -- Case 4: minimized -> unminimize
        if win:isMinimized() then
            win:unminimize()
        end

        -- Case 5: move to current space
        local currentSpace = hs.spaces.focusedSpace()
        if currentSpace then
            hs.spaces.moveWindowToSpace(win, currentSpace)
        end

        -- Finalize
        app:activate()
        win:focus()
    end)
end

-- =========================================
-- WezTerm Toggle (Ctrl + Cmd + J)
-- =========================================
bindAppToggle({ "ctrl", "cmd" }, "J", "WezTerm", "com.github.wez.wezterm")

-- =========================================
-- Codex Toggle (Ctrl + Cmd + C)
-- =========================================
bindAppToggle({ "ctrl", "cmd" }, "C", "Codex", "com.openai.codex")

-- =========================================
-- Claude Toggle (Ctrl + Cmd + L)
-- =========================================
bindAppToggle({ "ctrl", "cmd" }, "L", "Claude", "com.anthropic.claudefordesktop")
