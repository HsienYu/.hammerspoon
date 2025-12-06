hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

----------------------------------------------------------------------------------------------------
------------------------------------------ configuration  -------------------------------------------------
-- Try loading custom config from ~/.config/hammerspoon/private/config.lua first
local custom_config_path = os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua"
if hs.fs.pathToAbsolute(custom_config_path) then
	print("Loading custom config from ~/.config/hammerspoon/private/config.lua")
	dofile(custom_config_path)
else
	-- Fall back to ~/.hammerspoon/private/config.lua
	local private_config_path = hs.configdir .. "/private/config.lua"
	if hs.fs.pathToAbsolute(private_config_path) then
		print("Loading config from ~/.hammerspoon/private/config.lua")
		require("private/config")
	else
		-- Create private directory if it doesn't exist
		hs.fs.mkdir(hs.configdir .. "/private")
		print("No custom config found, using defaults")
	end
end

hsreload_keys = hsreload_keys or { { "cmd", "shift", "ctrl" }, "R" }
if string.len(hsreload_keys[2]) > 0 then
	hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "reloading the config file!", function()
		hs.reload()
	end)
	hs.alert.show(" Config file has been loaded! ")
end

----------------------------------------------------------------------------------------------------
---------------------------------------- Spoons ----------------------------------------------
-- implement Spoon
hs.loadSpoon("ModalMgr")

-- define default Spoons
if not hspoon_list then
	hspoon_list = {
		"AClock",
		"AppLauncher",
		"KSheet",
		"CountDown",
		"WinWin",
	}
end

-- setup Spoons
for _, v in pairs(hspoon_list) do
	hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- AppLauncherM

spoon.AppLauncher:bindHotkeys({
	d = "DuckDuckGo",
	c = "Calendar",
	e = "Mail",
	f = "Fork",
	n = "Notes",
	r = "Reminders",
	w = "Warp",
	o = "obsidian",
	v = "Visual Studio Code",
})

----------------------------------------------------------------------------------------------------
-- countdownM
if spoon.CountDown then
	spoon.ModalMgr:new("countdownM")
	local cmodal = spoon.ModalMgr.modal_list["countdownM"]
	cmodal:bind("", "escape", "Exit from panel", function()
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	cmodal:bind("", "Q", "Exit from panel", function()
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	--cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
	cmodal:bind("", "0", "5 mins", function()
		spoon.CountDown:startFor(5)
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	for i = 1, 9 do
		cmodal:bind("", tostring(i), string.format("%s Mins", 10 * i), function()
			spoon.CountDown:startFor(10 * i)
			spoon.ModalMgr:deactivate({ "countdownM" })
		end)
	end
	cmodal:bind("", "return", "25 mins ", function()
		spoon.CountDown:startFor(25)
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	cmodal:bind("", "space", "Pause & Resume Counter", function()
		spoon.CountDown:pauseOrResume()
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)

	-- define the keybinding for entering panel
	hscountdM_keys = hscountdM_keys or { "alt", "I" }
	if string.len(hscountdM_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hscountdM_keys[1], hscountdM_keys[2], "Enter the countdown panel", function()
			spoon.ModalMgr:deactivateAll()
			-- Show countdown panel
			spoon.ModalMgr:activate({ "countdownM" }, "#FF6347", true)
		end)
	end
end

----------------------------------------------------------------------------------------------------
-- Screen Lock
hslock_keys = hslock_keys or { "alt", "L" }
if string.len(hslock_keys[2]) > 0 then
	spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "Screen lock", function()
		hs.caffeinate.lockScreen()
	end)
end

----------------------------------------------------------------------------------------------------
-- Window management
if spoon.WinWin then
	-- Helper function to stash and perform window operation
	local function stashAndResize(option)
		return function()
			spoon.WinWin:stash()
			spoon.WinWin:moveAndResize(option)
		end
	end

	local function stashAndMove(direction)
		return function()
			spoon.WinWin:stash()
			spoon.WinWin:moveToScreen(direction)
		end
	end

	spoon.ModalMgr:new("resizeM")
	local cmodal = spoon.ModalMgr.modal_list["resizeM"]
	cmodal:bind("", "escape", "Exit ", function()
		spoon.ModalMgr:deactivate({ "resizeM" })
	end)
	cmodal:bind("", "Q", "Exit", function()
		spoon.ModalMgr:deactivate({ "resizeM" })
	end)
	cmodal:bind("", "tab", "Hint", function()
		spoon.ModalMgr:toggleCheatsheet()
	end)
	cmodal:bind(
		"",
		"A",
		"to Left",
		function()
			spoon.WinWin:stepMove("left")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("left")
		end
	)
	cmodal:bind(
		"",
		"D",
		"to Right",
		function()
			spoon.WinWin:stepMove("right")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("right")
		end
	)
	cmodal:bind(
		"",
		"W",
		"to Up",
		function()
			spoon.WinWin:stepMove("up")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("up")
		end
	)
	cmodal:bind(
		"",
		"S",
		"to Down",
		function()
			spoon.WinWin:stepMove("down")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("down")
		end
	)
	cmodal:bind("", "H", "half screen left", stashAndResize("halfleft"))
	cmodal:bind("", "L", "half screen right", stashAndResize("halfright"))
	cmodal:bind("", "K", "half screen top", stashAndResize("halfup"))
	cmodal:bind("", "J", "half screen bottom", stashAndResize("halfdown"))
	cmodal:bind("", "Y", "left top corner", stashAndResize("cornerNW"))
	cmodal:bind("", "O", "right top corner", stashAndResize("cornerNE"))
	cmodal:bind("", "U", "left bottom corner", stashAndResize("cornerSW"))
	cmodal:bind("", "I", "right bottom corner", stashAndResize("cornerSE"))
	cmodal:bind("", "F", "fullscreen", stashAndResize("fullscreen"))
	cmodal:bind("", "C", "center", stashAndResize("center"))
	cmodal:bind(
		"",
		"=",
		"expand",
		function()
			spoon.WinWin:moveAndResize("expand")
		end,
		nil,
		function()
			spoon.WinWin:moveAndResize("expand")
		end
	)
	cmodal:bind(
		"",
		"-",
		"shrink",
		function()
			spoon.WinWin:moveAndResize("shrink")
		end,
		nil,
		function()
			spoon.WinWin:moveAndResize("shrink")
		end
	)
	cmodal:bind(
		"shift",
		"H",
		"shrink from left",
		function()
			spoon.WinWin:stepResize("left")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("left")
		end
	)
	cmodal:bind(
		"shift",
		"L",
		"expand from right",
		function()
			spoon.WinWin:stepResize("right")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("right")
		end
	)
	cmodal:bind(
		"shift",
		"K",
		"shrink from top",
		function()
			spoon.WinWin:stepResize("up")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("up")
		end
	)
	cmodal:bind(
		"shift",
		"J",
		"expand from bottom",
		function()
			spoon.WinWin:stepResize("down")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("down")
		end
	)
	cmodal:bind("", "left", "move window to left display", stashAndMove("left"))
	cmodal:bind("", "right", "move window to right display", stashAndMove("right"))
	cmodal:bind("", "up", "move window to top display", stashAndMove("up"))
	cmodal:bind("", "down", "move window to bottom display", stashAndMove("down"))
	cmodal:bind("", "space", "move window to next screen", stashAndMove("next"))

	cmodal:bind("", "[", "left 2/3 screen", stashAndResize("mostleft"))
	cmodal:bind("", "]", "right 2/3 screen", stashAndResize("mostright"))

	cmodal:bind("", ",", "left 1/3 screen", stashAndResize("lesshalfleft"))
	cmodal:bind("", ".", "center 1/3 screen", stashAndResize("onethird"))
	cmodal:bind("", "/", "right 1/3 screen", stashAndResize("lesshalfright"))

	cmodal:bind("", "t", "move cursor to center", function()
		spoon.WinWin:centerCursor()
	end)

	-- WM keybindings
	hsresizeM_keys = hsresizeM_keys or { "alt", "R" }
	if string.len(hsresizeM_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter the WM Mode", function()
			spoon.ModalMgr:deactivateAll()
			-- show indicator
			spoon.ModalMgr:activate({ "resizeM" }, "#B22222")
		end)
	end

	hs.hotkey.bind({ "ctrl", "alt" }, "return", stashAndResize("fullscreen"))
	hs.hotkey.bind({ "ctrl", "alt" }, "left", stashAndResize("halfleft"))
	hs.hotkey.bind({ "ctrl", "alt" }, "right", stashAndResize("halfright"))
	hs.hotkey.bind({ "ctrl", "alt" }, "up", stashAndResize("halfup"))
	hs.hotkey.bind({ "ctrl", "alt" }, "down", stashAndResize("halfdown"))
end

----------------------------------------------------------------------------------------------------
-- KSheet Panel
if spoon.KSheet then
	spoon.ModalMgr:new("cheatsheetM")
	local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
	cmodal:bind("", "escape", "Deactivate cheatsheetM", function()
		spoon.KSheet:hide()
		spoon.ModalMgr:deactivate({ "cheatsheetM" })
	end)
	cmodal:bind("", "Q", "Deactivate cheatsheetM", function()
		spoon.KSheet:hide()
		spoon.ModalMgr:deactivate({ "cheatsheetM" })
	end)

	-- keybindings
	hscheats_keys = hscheats_keys or { "alt", "S" }
	if string.len(hscheats_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "Show keybindings", function()
			spoon.KSheet:show()
			spoon.ModalMgr:deactivateAll()
			spoon.ModalMgr:activate({ "cheatsheetM" })
		end)
	end
end

----------------------------------------------------------------------------------------------------
-- AClock hotkey
if spoon.AClock then
	hsaclock_keys = hsaclock_keys or { "alt", "T" }
	if string.len(hsaclock_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hsaclock_keys[1], hsaclock_keys[2], "Clock", function()
			spoon.AClock:toggleShow()
		end)
	end
end

----------------------------------------------------------------------------------------------------
-- show Hammerspoon console
hsconsole_keys = hsconsole_keys or { "alt", "Z" }
if string.len(hsconsole_keys[2]) > 0 then
	spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "Hammerspoon Console", function()
		hs.toggleConsole()
	end)
end

----------------------------------------------------------------------------------------------------
-- init modalMgr
spoon.ModalMgr.supervisor:enter()
