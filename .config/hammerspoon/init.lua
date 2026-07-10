-- Helper: find app window quickly
-- (app:mainWindow() can return nil depending on the app,
--  and hs.window.filter is too slow for one-shot lookups)
local function findAppWindow(bundleID)
    for _, w in ipairs(hs.window.orderedWindows()) do
        local wApp = w:application()
        if wApp and wApp:bundleID() == bundleID then
            return w
        end
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
        local win = findAppWindow(bundleID)

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
        hs.spaces.moveWindowToSpace(win, currentSpace)

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
