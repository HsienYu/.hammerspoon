hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

----------------------------------------------------------------------------------------------------
------------------------------------------ configuration  -------------------------------------------------
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
if custom_config then
	print("Loading the custom config file")
	dofile(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
	privatepath = hs.fs.pathToAbsolute(hs.configdir .. "/private/config.lua")
	if privatepath then
		hs.alert("Found custom config file, reloading!")
	end
else
	-- use the default config file
	if not privatepath then
		privatepath = hs.fs.pathToAbsolute(hs.configdir .. "/private")
		-- if without private directory `~/.hammerspoon/private`，create it。
		hs.fs.mkdir(hs.configdir .. "/private")
	end
	privateconf = hs.fs.pathToAbsolute(hs.configdir .. "/private/config.lua")
	if privateconf then
		-- if the private config excist, load it.
		require("private/config")
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
	k = "cursor",
	o = "obsidian",
	v = "Visual Studio Code",
	z = "Zed",
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
	cmodal:bind("", "H", "half screen left", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfleft")
	end)
	cmodal:bind("", "L", "half screen right", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfright")
	end)
	cmodal:bind("", "K", "half screen top", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfup")
	end)
	cmodal:bind("", "J", "half screen bottom", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfdown")
	end)
	cmodal:bind("", "Y", "left top corner", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerNW")
	end)
	cmodal:bind("", "O", "right top corner", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerNE")
	end)
	cmodal:bind("", "U", "left bottom corner", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerSW")
	end)
	cmodal:bind("", "I", "right bottom corner", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerSE")
	end)
	cmodal:bind("", "F", "fullscreen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("fullscreen")
	end)
	cmodal:bind("", "C", "center", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("center")
	end)
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
		"srhink from left",
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
	cmodal:bind("", "left", "move window to left display", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("left")
	end)
	cmodal:bind("", "right", "move window to right display", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("right")
	end)
	cmodal:bind("", "up", "move window to top display", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("up")
	end)
	cmodal:bind("", "down", "move window to bottom display", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("down")
	end)
	cmodal:bind("", "space", "move window to next screen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("next")
	end)

	cmodal:bind("", "[", "left 2/3 screen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("mostleft")
	end)
	cmodal:bind("", "]", "right 2/3 screen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("mostright")
	end)

	cmodal:bind("", ",", "left 1/3 screen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("lesshalfleft")
	end)
	cmodal:bind("", ".", "center 1/3 screen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("onethird")
	end)
	cmodal:bind("", "/", "right 1/3 screen", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("lesshalfright")
	end)

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

	hs.hotkey.bind({ "ctrl", "alt" }, "return", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("fullscreen")
	end)
	hs.hotkey.bind({ "ctrl", "alt" }, "left", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfleft")
	end)
	hs.hotkey.bind({ "ctrl", "alt" }, "right", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfright")
	end)
	hs.hotkey.bind({ "ctrl", "alt" }, "up", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfup")
	end)
	hs.hotkey.bind({ "ctrl", "alt" }, "down", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfdown")
	end)
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
