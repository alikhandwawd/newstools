function addIdToSMS(message)
	local beforeSMS = message:match("^(.-)SMS:")
	local smsText = message:match("SMS:%s*(.-)%s*Отправитель:")
	local sender = message:match("Отправитель:%s*([%w_%.%[%]%-]+)")
	local phone = message:match("Тел%.:%s*(%d+)")
	if not smsText or not sender then
		return message
	end
	sender = sender:gsub("%[.-]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
	local cleanNick = cleanNickname(sender)
	local id = nil
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if myId then
		local myNick = sampGetPlayerNickname(myId)
		if myNick then
			local cleanMyNick = cleanNickname(myNick)
			if cleanMyNick == cleanNick then
				id = myId
			end
		end
	end
	if not id then
		for playerId = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(playerId) then
				local playerNick = sampGetPlayerNickname(playerId)
				if playerNick then
					local cleanPlayerNick = cleanNickname(playerNick)
					if cleanPlayerNick == cleanNick then
						id = playerId
						break
					end
				end
			end
		end
	end
	beforeSMS = (beforeSMS or ""):gsub("{.-}", "")
	smsText = (smsText or ""):gsub("{.-}", "")
	local result = beforeSMS .. "SMS: " .. smsText .. " Отправитель: " .. cleanNick
	if id then
		result = result .. "[" .. tostring(id) .. "]"
	end
	if phone then
		result = result .. " Тел.: " .. phone
	end
	result = result:gsub("{.-}", "")
	return result
end
function sendRPCCommand(text)
	local bs = raknetNewBitStream()
	local rn = require 'samp.raknet'
	raknetBitStreamWriteInt32(bs, #text)
	raknetBitStreamWriteString(bs, text)
	raknetSendRpc(rn.RPC.SERVERCOMMAND, bs)
	raknetDeleteBitStream(bs)
end
function publishAdvertisement()
	local response = ffi.string(settings.customAd.responseText)
	if response ~= '' and not response:match("^%s*$") then
		flags.publishingMode = true
		flags.publishingStartTime = os.clock()
		flags.waitingForPublishConfirm = true
		if windows.help[0] and ui.search then
			flags.saveHelpScroll = true
		end
		saveToAdBuffer(response)
		local convertedResponse = u8:decode(response)
		sampSendDialogResponse(698, 1, -1, convertedResponse)
		closeCustomAd(false)
		return true
	else
		SilentNotification("[News Helper]", "Введите ответ!", "warn", 3.0)
		return false
	end
end
function doSendResponse()
	if os.clock() < flags.blockSendUntil then
		return false
	end
	local response = ffi.string(settings.customAd.responseText)
	if response ~= '' and not response:match("^%s*$") then
		if windows.help[0] and ui.search then
			flags.saveHelpScroll = true
		end
		saveToAdBuffer(response)
		local convertedResponse = u8:decode(response)
		sampSendDialogResponse(698, 1, -1, convertedResponse)
		closeCustomAd(false)
		return true
	else
		SilentNotification("[News Helper]", "Введите ответ!", "warn", 3.0)
		return false
	end
end
function showCustomAdWindow(data)
	resetIO()
	settings.customAd.isPreview = false
	settings.customAd.data = data or {}
	settings.customAd.originalText = settings.customAd.data.advertisement or nil
	flags.blockSendUntil = os.clock() + 0.2
	windows.customAd[0] = true
	local io = imgui.GetIO()
	io.WantCaptureKeyboard = false
	io.WantTextInput = false
	io.WantCaptureMouse = false
	flags.inputFieldActive = false
	flags.focusResponse = true
	flags.needUnfocus = false
end
function closeCustomAd(sendResponse, text)
	sampSendDialogResponse(698, 0, -1, "")
	settings.customAd.responseText = imgui.new.char[1024]()
	windows.customAd[0] = false
	settings.autoViewAds.wasDialog696Opened = false
	settings.customAd.originalText = nil
	settings.customAd.data = {}
	flags.lastEnterState = false 
	flags.inputFieldActive = false
	flags.focusResponse = false
	flags.needUnfocus = true
	flags.blockNextEnter = false
	states.enterReleased = false
	states.lastSearchedAd = nil
	states.searchResults = {}
	states.currentSearchPage = 1
	local io = imgui.GetIO()
	io.WantCaptureKeyboard = false
	io.WantCaptureMouse = false
	io.WantTextInput = false
	bufferNavigationState.isNavigating = false
	bufferNavigationState.currentIndex = 0
	bufferNavigationState.lastAdText = nil
	bufferNavigationState.originalText = nil
	states.pendingCursorPos = nil
	states.starPositions = {}
	states.currentStarIndex = 1
end
function createNewBinder()
	local newBind = {
		name = "без названия",
		hotkey = {},
		command = "",
		enableOnChat = false,
		enableOnDialog = false,
		requireConfirm = false,
		blockKey = false,
		mode = 1,
		delay = 3000,
		lines = {},
		lineSendMode = {},
		squareText = "",
		confirmed = false,
		enabled = true
	}
	table.insert(binder.list, newBind)
	saveBinder()
	return #binder.list
end
function deleteBinder(index)
	if binder.list[index] then
		local cmd = binder.list[index].command
		if cmd and cmd ~= "" then
			sampUnregisterChatCommand(cmd)
		end
		table.remove(binder.list, index)
		saveBinder()
	end
end
function saveBinderEdit()
	if not binder.editing or not binder.list[binder.editing] then return end
	local bind = binder.list[binder.editing]
	local oldCmd = bind.command
	bind.name = ffi.string(binderEdit.name)
	bind.hotkey = {}
	for _, key in ipairs(binderEdit.hotkey) do
		table.insert(bind.hotkey, key)
	end
	local newCmd = ffi.string(binderEdit.command)
	bind.command = newCmd
	bind.enableOnChat = binderEdit.enableOnChat[0]
	bind.enableOnDialog = binderEdit.enableOnDialog[0]
	bind.requireConfirm = binderEdit.requireConfirm[0]
	bind.blockKey = binderEdit.blockKey[0]
	bind.useRBM = binderEdit.useRBM[0]
	bind.strictMode = binderEdit.strictMode[0]
	bind.mode = binderEdit.mode[0]
	bind.delay = binderEdit.delay[0]
	if binderEdit.mode[0] == 1 then
		bind.lines = {}
		for _, line in ipairs(binderEdit.lines) do
			table.insert(bind.lines, {
				text = ffi.string(line.text),
				delay = line.delay and line.delay[0] or bind.delay
			})
		end
	else
		local squareLines = {}
		local text = ffi.string(binderEdit.squareText)
		for line in text:gmatch("[^\r\n]+") do
			local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
			if trimmed ~= "" then
				table.insert(squareLines, {
					text = trimmed,
					delay = bind.delay
				})
			end
		end
		if #squareLines > 0 then
			bind.lines = squareLines
		end
	end
	bind.squareText = ffi.string(binderEdit.squareText)
	bind.lineSendMode = {}
	for idx, mode in pairs(binder.lineSendMode) do
		bind.lineSendMode[idx] = mode
	end
	if oldCmd ~= newCmd then
		if oldCmd and oldCmd ~= "" then
			sampUnregisterChatCommand(oldCmd)
		end
		if newCmd and newCmd ~= "" then
			sampRegisterChatCommand(newCmd, function()
				if bind.enabled ~= false then
					executeBinder(bind)
				end
			end)
		end
	end
	saveBinder()
	binder.editWindow[0] = false
	binder.editing = nil
	AddNotification("[News Helper]", "Бинд сохранен!", "success", 3.0)
end
function loadBinderEdit(index)
	if not binder.list[index] then return end
	local bind = binder.list[index]
	binder.editing = index
	ffi.fill(binderEdit.name, 256)
	ffi.copy(binderEdit.name, bind.name or "без названия")
	binderEdit.hotkey = {}
	for _, key in ipairs(bind.hotkey or {}) do
		table.insert(binderEdit.hotkey, key)
	end
	ffi.fill(binderEdit.command, 64)
	if bind.command then
		ffi.copy(binderEdit.command, bind.command)
	end
	binderEdit.enableOnChat[0] = bind.enableOnChat or false
	binderEdit.enableOnDialog[0] = bind.enableOnDialog or false
	binderEdit.requireConfirm[0] = bind.requireConfirm or false
	binderEdit.blockKey[0] = bind.blockKey or false
	binderEdit.useRBM[0] = bind.useRBM or false
	binderEdit.strictMode[0] = bind.strictMode ~= false
	binderEdit.mode[0] = bind.mode or 1
	binderEdit.delay[0] = bind.delay or 3000
	binderEdit.lines = {}
	if bind.lines then
		for _, line in ipairs(bind.lines) do
			table.insert(binderEdit.lines, {
				text = imgui.new.char[512](line.text or ""),
				delay = imgui.new.int(line.delay or bind.delay or 3000)
			})
		end
	end
	if #binderEdit.lines == 0 then
		table.insert(binderEdit.lines, {
			text = imgui.new.char[512](),
			delay = imgui.new.int(bind.delay or 3000)
		})
	end
	ffi.fill(binderEdit.squareText, 8192)
	if bind.squareText then
		ffi.copy(binderEdit.squareText, bind.squareText)
	end
	binder.lineSendMode = {}
	if bind.lineSendMode then
		for idx, mode in pairs(bind.lineSendMode) do
			local numIdx = tonumber(idx) or idx
			binder.lineSendMode[numIdx] = mode
		end
	end
	binder.editWindow[0] = true
end
function executeBinder(bind, rbmTargetId)
	if not bind or bind.enabled == false then 
		return 
	end
	local hasDialogMode = false
	if bind.lines then
		for idx, line in ipairs(bind.lines) do
			if bind.lineSendMode and bind.lineSendMode[idx] == 'dialog' then
				hasDialogMode = true
				break
			end
		end
	end
	if not hasDialogMode and not bind.enableOnDialog and sampIsDialogActive() then 
		return 
	end
	if windows.customAd and windows.customAd[0] then 
		return 
	end
	if windows.mainSettings and windows.mainSettings[0] then 
		return 
	end
	if not rbmTargetId and isCursorActive() and 
	   not (windows.help and windows.help[0]) and 
	   not (windows.sprav and windows.sprav[0]) and 
	   not (windows.mainSettings and windows.mainSettings[0]) and
	   not sampIsChatInputActive() then 
		return 
	end
	if bind.requireConfirm then
		if not bind.confirmed then
			bind.confirmed = true
			AddNotification("[News Helper]", "Нажмите еще раз\nдля подтверждения", "info", 3.0)
			lua_thread.create(function()
				wait(3000)
				bind.confirmed = false
			end)
			return
		end
		bind.confirmed = false
	end
	lua_thread.create(function()
		if bind.lines and #bind.lines > 0 then
			for idx, line in ipairs(bind.lines) do
				if line.text then
					local text = type(line.text) == "string" and line.text or ffi.string(line.text)
					text = variables(text, rbmTargetId)
					if text ~= "" then
						local sendMode = bind.lineSendMode and bind.lineSendMode[idx] or 'send'
						if sendMode == 'chat' then
							sampSetChatInputEnabled(true)
							sampSetChatInputText(u8:decode(text))
						elseif sendMode == 'chat_close' then
							sampSetChatInputText(u8:decode(text))
						elseif sendMode == 'dialog' then
							if sampIsDialogActive() then
								local decodedText = u8:decode(text)
								local convertedText = u8:encode(decodedText)
								sampSetCurrentDialogEditboxText(convertedText)
							end
						else
							sampSendChat(u8:decode(text))
						end
						local delay = bind.delay or 3000
						if line.delay then
							if type(line.delay) == "number" then
								delay = line.delay
							elseif type(line.delay) == "cdata" then
								delay = line.delay[0]
							end
						end
						wait(delay)
					end
				end
			end
		end
	end)
end
function checkBinderHotkeys()
	for i, bind in ipairs(binder.list) do
		if bind.useRBM then
			goto next_bind
		end
		if bind.enabled ~= false and bind.hotkey and #bind.hotkey > 0 then
			local allPressed = true
			for _, key in ipairs(bind.hotkey) do
				if not isKeyPressed(key) then
					allPressed = false
					break
				end
			end
			if allPressed then
				if (bind.strictMode ~= false) and isAnyOtherKeyPressed(bind.hotkey) then
					if not bind.otherKeyWarningShown then
						bind.otherKeyWarningShown = true
					end
					goto next_bind
				end
				bind.otherKeyWarningShown = false
				if not bind.hotkeyPressed then
					bind.hotkeyPressed = true
					local shouldExecute = true
					local hasDialogMode = false
					if bind.lines then
						for idx, line in ipairs(bind.lines) do
							if bind.lineSendMode and bind.lineSendMode[idx] == 'dialog' then
								hasDialogMode = true
								break
							end
						end
					end
					if not bind.enableOnChat and sampIsChatInputActive() then
						shouldExecute = false
					end
					if not hasDialogMode and not bind.enableOnDialog and sampIsDialogActive() then
						shouldExecute = false
					end
					if shouldExecute then
						if bind.blockKey then
							for _, key in ipairs(bind.hotkey) do
								consumeWindowMessage(true, true)
							end
						end
						executeBinder(bind)
					end
				end
			else
				bind.hotkeyPressed = false
				bind.otherKeyWarningShown = false
			end
		end
		::next_bind::
	end
end
function executeAction(actionType, actionKey, targetId)
	local function processText(text)
		local result = variables(text)
		if targetId and targetId > 0 then
			result = result:gsub("<targetid>", tostring(targetId))
			local targetNick = sampGetPlayerNickname(targetId)
			if targetNick then
				local cleanTargetNick = targetNick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
				if translitExceptions[cleanTargetNick] then
					result = result:gsub("<targetnick>", translitExceptions[cleanTargetNick])
				else
					local forTranslit = cleanTargetNick:gsub("_", " ")
					result = result:gsub("<targetnick>", trst(forTranslit))
				end
				result = result:gsub("<targetnickeng>", cleanTargetNick)
			else
				result = result:gsub("<targetnick>", "Unknown")
				result = result:gsub("<targetnickeng>", "Unknown")
			end
		else
			result = result:gsub("<targetid>", "0")
			result = result:gsub("<targetnick>", "Unknown")
			result = result:gsub("<targetnickeng>", "Unknown")
		end
		return result
	end
	if actionType == 'rs' then
		local action = panels.rs.actions[actionKey]
		if not action then return end
		if action.needInput then
			panels.input.type = 'rs_action'
			panels.input.title = action.inputPlaceholder or "Введите данные"
			ffi.fill(panels.input.inputText, 256)
			panels.input.onConfirm = function()
				local inputText = ffi.string(panels.input.inputText)
				local action = panels.rs.actions[actionKey]
				if action then
					lua_thread.create(function()
						local delay = panels.rs.settings.globalDelay or 3000
						for _, line in ipairs(action.lines) do
							local processedLine = processText(u8:decode(line) or line)
							sampSendChat(processedLine)
							wait(delay)
						end
						if actionKey == "uninvite" then
							sampSendChat(string.format("/uninvite %d %s", targetId, inputText))
						elseif actionKey == "rank" then
							sampSendChat(string.format("/rank %d %s", targetId, inputText))
						elseif actionKey == "vig" then
							sampSendChat(string.format("/vig %d %s", targetId, inputText))
						end
					end)
				end
			end
			panels.input.open[0] = true
			panels.playerMenu.open[0] = false
			panels.playerMenu.closedFromInputMenu = true
		else
			lua_thread.create(function()
				local delay = panels.rs.settings.globalDelay or 3000
				for _, line in ipairs(action.lines) do
					local processedLine = processText(u8:decode(line) or line)
					sampSendChat(processedLine)
					wait(delay)
				end
				if actionKey == "invite" then
					sampSendChat(string.format("/invite %d", targetId))
				elseif actionKey == "givedress" then
					sampSendChat(string.format("/givedress %d", targetId))
				elseif actionKey == "unvig" then
					sampSendChat(string.format("/unvig %d", targetId))
				end
			end)
			panels.playerMenu.open[0] = false
		end
	elseif actionType == 'custom' then
		local action = panels.custom.data[actionKey]
		if not action or not action.lines then return end
		lua_thread.create(function()
			local delay = panels.rs.settings.globalDelay or 3000
			for _, line in ipairs(action.lines) do
				local processedLine = processText(u8:decode(line) or line)
				sampSendChat(processedLine)
				wait(delay)
			end
		end)
		panels.playerMenu.open[0] = false
	elseif actionType == 'sobes' then
		local action = nil
		local section = nil
		if panels.sobes.actions.start[actionKey] then
			action = panels.sobes.actions.start[actionKey]
			section = 'start'
		elseif panels.sobes.actions.documents[actionKey] then
			action = panels.sobes.actions.documents[actionKey]
			section = 'documents'
		elseif panels.sobes.actions.finish[actionKey] then
			action = panels.sobes.actions.finish[actionKey]
			section = 'finish'
		end
		if not action or not action.lines then return end
		lua_thread.create(function()
			local delay = panels.rs.settings.globalDelay or 3000
			for _, line in ipairs(action.lines) do
				local processedLine = processText(u8:decode(line) or line)
				sampSendChat(processedLine)
				wait(delay)
			end
		end)
		panels.playerMenu.open[0] = false
	end
end
function executeRSActionWithInput(actionKey, targetId, inputText)
	local action = panels.rs.actions[actionKey]
	if not action then return end
	lua_thread.create(function()
		local delay = panels.rs.settings.globalDelay or 3000
		for _, line in ipairs(action.lines) do
			local processedLine = variables(u8:decode(line) or line)
			sampSendChat(processedLine)
			wait(delay)
		end
		if actionKey == "uninvite" then
			sampSendChat(string.format("/uninvite %d %s", targetId, inputText))
		elseif actionKey == "rank" then
			sampSendChat(string.format("/rank %d %s", targetId, inputText))
		elseif actionKey == "vig" then
			sampSendChat(string.format("/vig %d %s", targetId, inputText))
		end
	end)
end
function transliterate(text)
	local translitMap = {
		а='a', б='b', в='v', г='g', д='d', е='e', ё='yo', ж='zh', з='z', и='i',
		й='y', к='k', л='l', м='m', н='n', о='o', п='p', р='r', с='s', т='t',
		у='u', ф='f', х='h', ц='ts', ч='ch', ш='sh', щ='sch', ъ='', ы='y', ь='',
		э='e', ю='yu', я='ya'
	}
	local result = ""
	local i = 1
	while i <= #text do
		local byte = text:byte(i)
		local char
		if byte < 128 then
			char = text:sub(i, i)
			i = i + 1
		elseif byte >= 192 and byte < 224 then
			char = text:sub(i, i + 1)
			i = i + 2
		elseif byte >= 224 and byte < 240 then
			char = text:sub(i, i + 2)
			i = i + 3
		elseif byte >= 240 then
			char = text:sub(i, i + 3)
			i = i + 4
		else
			char = text:sub(i, i)
			i = i + 1
		end
		local mapped = translitMap[char]
		if mapped then
			result = result .. mapped
		else
			result = result .. char
		end
	end
	return result
end
function trst(name)
	if translitExceptions[name] then
		return translitExceptions[name]
	end
	if name:match('%a+') then
		for k, v in pairs(trstl1) do
			name = name:gsub(k, v) 
		end
		for k, v in pairs(trstl) do
			name = name:gsub(k, v) 
		end
		return name
	end
	return name
end
function variables(text, rbmTargetId)
	if not text or text == "" then
		return text
	end
	local result = text
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	result = result:gsub("<myid>", myId and tostring(myId) or "0")
	local myNick = (data.mainIni.config.c_nick and data.mainIni.config.c_nick ~= "") and data.mainIni.config.c_nick or ""
	if myNick == "" then
		AddNotification("[News Helper]", "Ник не определён!\nОпределите ник в настройках", "error", 5.0)
		myNick = "Unknown"
	end
	result = result:gsub("<mynick>", myNick)
	local _, myIdEng = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if myIdEng then
		local nickname = sampGetPlayerNickname(myIdEng)
		if nickname then
			local cleanNick = nickname:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			result = result:gsub("<mynickeng>", cleanNick)
		else
			result = result:gsub("<mynickeng>", "Unknown")
		end
	else
		result = result:gsub("<mynickeng>", "Unknown")
	end
	local myRang = (data.mainIni.config.c_rang_b and data.mainIni.config.c_rang_b ~= "") and data.mainIni.config.c_rang_b or "Не определено"
	result = result:gsub("<myrang>", myRang)
	local closestResult, closestId = getClosestPlayerId()
	result = result:gsub("<closeid>", closestResult and tostring(closestId) or "0")
	if closestResult then
		local closestNick = sampGetPlayerNickname(closestId)
		if closestNick then
			local cleanClosestNick = closestNick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			if translitExceptions[cleanClosestNick] then
				result = result:gsub("<closenick>", translitExceptions[cleanClosestNick])
			else
				local forTranslit = cleanClosestNick:gsub("_", " ")
				result = result:gsub("<closenick>", trst(forTranslit))
			end
			result = result:gsub("<closenickeng>", cleanClosestNick)
		else
			result = result:gsub("<closenick>", "Unknown")
			result = result:gsub("<closenickeng>", "Unknown")
		end
	else
		result = result:gsub("<closenick>", "Unknown")
		result = result:gsub("<closenickeng>", "Unknown")
	end
	local centerResult, centerId = getClosestPlayerIdToCenter()
	result = result:gsub("<closeidtocenter>", centerResult and tostring(centerId) or "0")
	if centerResult then
		local centerNick = sampGetPlayerNickname(centerId)
		if centerNick then
			local cleanCenterNick = centerNick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			if translitExceptions[cleanCenterNick] then
				result = result:gsub("<closennicktocenter>", translitExceptions[cleanCenterNick])
			else
				local forTranslit = cleanCenterNick:gsub("_", " ")
				result = result:gsub("<closennicktocenter>", trst(forTranslit))
			end
			result = result:gsub("<closennicktocentereng>", cleanCenterNick)
		else
			result = result:gsub("<closennicktocenter>", "Unknown")
			result = result:gsub("<closennicktocentereng>", "Unknown")
		end
	else
		result = result:gsub("<closennicktocenter>", "Unknown")
		result = result:gsub("<closennicktocentereng>", "Unknown")
	end
	if rbmTargetId ~= nil and rbmTargetId > 0 then
		result = result:gsub("<rbmid>", tostring(rbmTargetId))
		local rbmNick = sampGetPlayerNickname(rbmTargetId)
		if rbmNick then
			local cleanRBMNick = rbmNick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			if translitExceptions[cleanRBMNick] then
				result = result:gsub("<rbmnick>", translitExceptions[cleanRBMNick])
			else
				local forTranslit = cleanRBMNick:gsub("_", " ")
				result = result:gsub("<rbmnick>", trst(forTranslit))
			end
			result = result:gsub("<rbmnickeng>", cleanRBMNick)
		else
			result = result:gsub("<rbmnick>", "Unknown")
			result = result:gsub("<rbmnickeng>", "Unknown")
		end
	else
		result = result:gsub("<rbmid>", "0")
		result = result:gsub("<rbmnick>", "Unknown")
		result = result:gsub("<rbmnickeng>", "Unknown")
	end
	result = result:gsub("<time:([^>]+)>", function(pattern)
		local output = ""
		for i = 1, #pattern do
			local char = pattern:sub(i, i)
			if char == 'h' then
				output = output .. getServerTimeComponent('h')
			elseif char == 'm' then
				output = output .. getServerTimeComponent('m')
			elseif char == 'd' then
				output = output .. getServerTimeComponent('d')
			elseif char == 'M' then
				output = output .. getServerTimeComponent('M')
			elseif char == 'y' then
				output = output .. getServerTimeComponent('y')
			else
				output = output .. char
			end
		end
		return output
	end)
	result = result:gsub("<id@([^>]+)>", function(nickName)
		for i = 0, 999 do
			if sampIsPlayerConnected(i) then
				local playerNick = sampGetPlayerNickname(i)
				if playerNick then
					local cleanNick = playerNick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
					if cleanNick == nickName then
						return tostring(i)
					end
				end
			end
		end
		return "0"
	end)
	return result
end
function detectMyRank()
	if not sampIsLocalPlayerSpawned() then
		AddNotification("[News Helper]", "Сначала заспавньтесь в игре!", "warn", 2.0)
		return
	end
	if settings.checker.waiting or settings.checker.detectingRank then
		AddNotification("[News Helper]", "Уже идет определение ранга!", "warn", 2.0)
		return
	end
	settings.checker.detectingRank = true
	settings.checker.waiting = true
	settings.checker.requestTime = os.clock()
	settings.checker.currentPage = 0
	data.membersList = {}
	lua_thread.create(function()
		wait(500)
		if not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/members")
		else
			settings.checker.waiting = false
			settings.checker.detectingRank = false
		end
		wait(5000)
		if settings.checker.waiting then
			settings.checker.waiting = false
			settings.checker.detectingRank = false
			AddNotification("[News Helper]", "Диалог не открыл,\nпопробуй позже", "warn", 2.0)
		end
	end)
end
function initUserVariables()
	if not user then user = {} end
	local function safeChar(v)
		if type(v) ~= "cdata" then
			return ffi.new("char[256]", "")
		end
		return v
	end
	user.nick = safeChar(user.nick)
	user.rang = safeChar(user.rang)
end
function performFindAndReplace()
	local findText = str(editor.findReplace.findText)
	local replaceText = str(editor.findReplace.replaceText)
	local selectedCategory = editor.findReplace.selectedCategory
	if not findText or findText == "" then
		chatMessage(u8:decode('[News Helper] Введите текст для поиска!'), 0xFF0000)
		return
	end
	if not data.newsHelpBind or type(data.newsHelpBind) ~= "table" then
		chatMessage(u8:decode('[News Helper] Данные биндов не загружены!'), 0xFF0000)
		return
	end
	local escapedFind = findText:gsub("([^%w])", "%%%1")
	local replacedCount = 0
	for catIndex = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[catIndex]
		if category[1] == settings.bufferCategoryName then
			goto skip_category
		end
		if selectedCategory ~= 0 and catIndex ~= selectedCategory then
			goto skip_category
		end
		for bindIndex = 2, #category do
			local bind = category[bindIndex]
			if bind and bind[2] then
				local oldText = bind[2]
				local newText = oldText:gsub(escapedFind, replaceText)
				if oldText ~= newText then
					bind[2] = newText
					replacedCount = replacedCount + 1
				end
			end
		end
		::skip_category::
	end
	if replacedCount > 0 then
		clearSearchCache()
		editor.findReplace.replacedCount = replacedCount
		chatMessage(u8:decode(string.format('[News Helper] Заменено %d вхождений!', replacedCount)), 0x00FF00)
		windows.findReplace[0] = false
	else
		chatMessage(u8:decode('[News Helper] Не найдено совпадений!'), 0xFFFF00)
		editor.findReplace.replacedCount = 0
	end
end
function calculateMathExpression(expression)
	if not expression or expression == "" then
		return nil, "Пустое выражение"
	end
	expression = expression:gsub("=%s*$", "")
	local cleanExpr = expression:gsub("%s+", "")
	cleanExpr = cleanExpr:gsub("sqrt", "math.sqrt")
	cleanExpr = cleanExpr:gsub("(%d+)!", "factorial(%1)")
	if not cleanExpr:match("^[%d%+%*/%(.%)%.%-^%a!.]+$") then
		return nil, "Недопустимые символы"
	end
	local function addImplicitMultiplication(expr)
		local result = expr
		result = result:gsub("([%d%.])%(", "%1*(")
		result = result:gsub("%)([%d])", ")*%1")
		result = result:gsub("%)%(", ")*(")
		return result
	end
	cleanExpr = addImplicitMultiplication(cleanExpr)
	if cleanExpr:match("[%+%-*/][%+%-*/]") then
		if not (cleanExpr:match("%-%-") or cleanExpr:match("%+%-") or cleanExpr:match("%-%+")) then
			return nil, "Последовательные операторы"
		else
			cleanExpr = cleanExpr:gsub("%-%-", "+")
			cleanExpr = cleanExpr:gsub("%+%-", "-")
			cleanExpr = cleanExpr:gsub("%-%+", "-")
			cleanExpr = cleanExpr:gsub("%+%+", "+")
		end
	end
	if cleanExpr:match("^[%+%*/]") or cleanExpr:match("[%+%-*/]$") then
		return nil, "Оператор в начале или конце"
	end
	local openCount = 0
	for char in cleanExpr:gmatch(".") do
		if char == "(" then
			openCount = openCount + 1
		elseif char == ")" then
			openCount = openCount - 1
			if openCount < 0 then
				return nil, "Несбалансированные скобки"
			end
		end
	end
	if openCount ~= 0 then
		return nil, "Несбалансированные скобки"
	end
	if cleanExpr:match("[%+%-*/(]$") or cleanExpr:match("sqrt%($") then
		return nil, "Неполное выражение"
	end
	if cleanExpr:match("%(%)") then
		return nil, "Пустые скобки"
	end
	if cleanExpr:match("%([%+%*/]") then
		return nil, "Оператор после открывающей скобки"
	end
	if cleanExpr:match("[%+%-*/]%)") then
		return nil, "Оператор перед закрывающей скобкой"
	end
	local func, err = loadstring("return " .. cleanExpr)
	if not func then
		return nil, "Ошибка в выражении"
	end
	local env = {
		math = math,
		factorial = function(n)
			if n < 0 then return 0 end
			if n == 0 or n == 1 then return 1 end
			local result = 1
			for i = 2, n do
				result = result * i
			end
			return result
		end
	}
	setfenv(func, env)
	local success, result = pcall(func)
	if success then
		if type(result) == "number" then
			if result == math.huge or result == -math.huge then
				return nil, "Деление на ноль"
			elseif result ~= result then
				return nil, "Неопределенный результат"
			end
			if math.floor(result) == result then
				return tostring(math.floor(result)), nil
			else
				local formatted = string.format("%.2f", result)
				formatted = formatted:gsub("%.?0+$", "")
				return formatted, nil
			end
		else
			return nil, "Неверный результат"
		end
	else
		return nil, "Ошибка вычисления"
	end
end
function PasteBindWithCursor(bindText, isDialog)
	states.enterReleased = false
	states.starPositions = {}
	states.currentStarIndex = 0
	states.lastTextLength = 0
	for i = 1, #bindText do
		if bindText:sub(i, i) == '*' then
			table.insert(states.starPositions, i)
		end
	end
	local processedText = bindText:gsub("%*", "")
	local cursorPosition = nil
	if #states.starPositions > 0 then
		states.currentStarIndex = 1
		for i = 1, #states.starPositions do
			states.starPositions[i] = states.starPositions[i] - (i - 1) - 1
		end
		cursorPosition = states.starPositions[1]
	end
	if isDialog and sampIsDialogActive() then
		setDialogTextWithEncoding(processedText)
		if cursorPosition then
			states.pendingCursorPos = cursorPosition
		end
	elseif not isDialog and windows.customAd[0] then
		flags.pendingBufferInsert = processedText
		flags.inputRecreateFrame = 4
		if cursorPosition then
			states.pendingCursorPos = cursorPosition
		end
		flags.focusResponse = true
	end
	states.lastTextLength = #processedText
end
function executeCommandRP(cmdName, cmdParams)
	local cmd = getCommandRPData(cmdName)
	if not cmd or not cmd.enabled or not cmd.lines or #cmd.lines == 0 then
		return false
	end
	lua_thread.create(function()
		local delay = cmd.delay or 2000
		for _, line in ipairs(cmd.lines) do
			local processedLine = variables(line)
			if cmdParams and cmdParams ~= "" then
				processedLine = processedLine:gsub("{params}", cmdParams)
				processedLine = processedLine:gsub("{args}", cmdParams)
			end
			sampSendChat(u8:decode(processedLine))
			wait(delay)
		end
		if cmdParams and cmdParams ~= "" then
			sendRPCCommand("/" .. cmdName .. " " .. cmdParams)
		else
			sendRPCCommand("/" .. cmdName)
		end
	end)
	return true
end
function addNewCommandRP()
	local cmdName = ffi.string(commandRPSystem.newCmdName)
	if cmdName == "" then
		AddNotification("[News Helper]", "Введите название команды!", "error", 2.0)
		return
	end
	for _, cmd in ipairs(commandRPSystem.data) do
		if cmd.command == cmdName then
			AddNotification("[News Helper]", "Команда уже существует!", "error", 2.0)
			return
		end
	end
	table.insert(commandRPSystem.data, {
		command = cmdName,
		lines = {},
		enabled = true,
		delay = 2000
	})
	commandRPSystem.newCmdWindow[0] = false
	ffi.fill(commandRPSystem.newCmdName, 64)
	saveAllNewsButtonsData()
end
function formatRPMessage(text, capitalize)
	if not text or text == "" then return text end
	text = text:gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" then return text end
	if capitalize then
		local firstByte = text:byte(1)
		if firstByte >= 0xE0 and firstByte <= 0xFF then
			text = string.char(firstByte - 0x20) .. text:sub(2)
		elseif firstByte == 0xB8 then
			text = string.char(0xA8) .. text:sub(2)
		elseif firstByte and firstByte >= 0x61 and firstByte <= 0x7A then
			text = string.char(firstByte - 0x20) .. text:sub(2)
		end
	end
	if not text:match("[%.%!%?]$") then
		text = text .. "."
	end
	return text
end
function navigateBufferUp()
	local bufferData = loadBufferFromFile()
	local currentAdText = normalizeForBufferCompare(settings.customAd.data.advertisement or "")
	if bufferNavigationState.lastAdText ~= currentAdText then
		bufferNavigationState.isNavigating = false
		bufferNavigationState.currentIndex = 0
		bufferNavigationState.originalText = nil
		bufferNavigationState.lastAdText = currentAdText
	end
	if not bufferNavigationState.isNavigating then
		bufferNavigationState.isNavigating = true
		bufferNavigationState.originalText = ffi.string(settings.customAd.responseText)
		bufferNavigationState.currentIndex = 0
	end
	local found = false
	for i = bufferNavigationState.currentIndex + 1, #bufferData do
		local bufferAdText = normalizeForBufferCompare(bufferData[i].advertisement or "")
		if bufferAdText == currentAdText then
			local textToSet = bufferData[i].editedText or ""
			flags.pendingBufferInsert = textToSet
			flags.inputRecreateFrame = 4
			bufferNavigationState.currentIndex = i
			found = true
			break
		end
	end
	if not found then
		bufferNavigationState.currentIndex = 0
		chatMessage(u8:decode('[News Helper] Больше нет вариантов'), 0xFFFF00)
	end
end
function navigateBufferDown()
	if bufferNavigationState.isNavigating and bufferNavigationState.originalText then
		flags.pendingBufferInsert = bufferNavigationState.originalText
		flags.inputRecreateFrame = 4
		bufferNavigationState.isNavigating = false
		bufferNavigationState.currentIndex = 0
		bufferNavigationState.lastAdText = nil
	end
end
function extractPrice(text)
	if not text or text == "" then return nil end
	if lower_utf8_optimized then
		text = lower_utf8_optimized(text)
	else
		text = text:lower()
	end
	text = text:gsub("k", "к")
	local candidates = {}
	for num, suffix in text:gmatch("([%d%.,]+)%s*([к]+)") do
		if num and suffix then
			local lastCommaPos = 0
			local lastDotPos = 0
			for i = #num, 1, -1 do
				if num:sub(i, i) == "," and lastCommaPos == 0 then
					lastCommaPos = i
				end
				if num:sub(i, i) == "." and lastDotPos == 0 then
					lastDotPos = i
				end
			end
			local lastSepPos = math.max(lastCommaPos, lastDotPos)
			local processedNum = num
			if lastSepPos > 0 and (#num - lastSepPos) <= 2 then
				processedNum = num:sub(1, lastSepPos - 1):gsub("[%.,]", "") .. "." .. num:sub(lastSepPos + 1)
			else
				processedNum = num:gsub("[%.,]", "")
			end
			processedNum = tonumber(processedNum)
			if processedNum then
				local kCount = 0
				for _ in suffix:gmatch("к") do
					kCount = kCount + 1
				end
				local multiplier = 1000 ^ kCount
				local finalPrice = math.floor(processedNum * multiplier)
				table.insert(candidates, {price = finalPrice, orig = num .. suffix})
			end
		end
	end
	for numStr in text:gmatch("(%d+[%.,%d]+)%$") do
		local cleanNum = numStr:gsub("[%.,]", "")
		local num = tonumber(cleanNum)
		if num and num > 10000 then
			table.insert(candidates, {price = num, orig = numStr})
		end
	end
	for numStr in text:gmatch("(%d+)%$") do
		local num = tonumber(numStr)
		if num and num > 10000 then
			local alreadyFound = false
			for _, cand in ipairs(candidates) do
				if tostring(cand.orig):match(tostring(num)) then
					alreadyFound = true
					break
				end
			end
			if not alreadyFound then
				table.insert(candidates, {price = num, orig = tostring(num)})
			end
		end
	end
	for numStr in text:gmatch("(%d+)") do
		local num = tonumber(numStr)
		if num and num > 100000 then
			local alreadyFound = false
			for _, cand in ipairs(candidates) do
				if cand.price == num then
					alreadyFound = true
					break
				end
			end
			if not alreadyFound then
				table.insert(candidates, {price = num, orig = tostring(num)})
			end
		end
	end
	if #candidates > 0 then
		table.sort(candidates, function(a, b) return a.price > b.price end)
		local finalPrice = candidates[1].price
		local str = tostring(finalPrice)
		local result = ""
		local count = 0
		for i = #str, 1, -1 do
			if count == 3 then
				result = "." .. result
				count = 0
			end
			result = str:sub(i, i) .. result
			count = count + 1
		end
		return result .. "$"
	end
	return nil
end
function insertPrice(template, adText)
	if not template then return template end
	if not adText then return template end
	local price = extractPrice(adText)
	if price then
		price = price:gsub("%$", "")
		price = price:gsub("%.", "")
		local str = tostring(price)
		local formattedPrice = ""
		local count = 0
		for i = #str, 1, -1 do
			if count == 3 then
				formattedPrice = "." .. formattedPrice
				count = 0
			end
			formattedPrice = str:sub(i, i) .. formattedPrice
			count = count + 1
		end
		local result = template
		result = result:gsub("%*[%d%.]*%$", formattedPrice .. "$")
		result = result:gsub("[%d%.]+%$", formattedPrice .. "$")
		result = result:gsub("%*%$", formattedPrice .. "$")
		result = result:gsub("(Цена:%s*).*", "%1" .. formattedPrice .. "$")
		result = result:gsub("(Бюджет:%s*).*", "%1" .. formattedPrice .. "$")
		result = result:gsub("(единицу:%s*).*", "%1" .. formattedPrice .. "$")
		result = result:gsub("(%$)([^%.])", "%1.%2")
		result = result:gsub("(%$)$", "%1.")
		return result
	end
	return template
end
function searchByAdvertisement(searchText)
	if not searchText or searchText == "" then
		return {}
	end
	local searchLower = lower_utf8_optimized(searchText)
	local searchType = nil
	local searchWords = {}
	for word in searchLower:gmatch("%S+") do
		table.insert(searchWords, word)
	end
	if #searchWords == 0 then
		return {}
	end
	local firstWord = searchWords[1]
	if firstWord == "куплю" or firstWord == "куп" or firstWord == "купил" then
		searchType = "buy"
	elseif firstWord == "продам" or firstWord == "прод" or firstWord == "продаю" or firstWord == "продал" then
		searchType = "sell"
	end
	local searchPrice = extractPrice(searchLower)
	local stopWords = {
		на = true, в = true, и = true, или = true, а = true, о = true,
		с = true, у = true, к = true, за = true, то = true,
		цена = true, бюджет = true, договорная = true,
		куплю = true, куп = true, купил = true,
		продам = true, прод = true, продаю = true, продал = true,
		свободный = true, единиц = true, шт = true, штук = true,
		это = true, что = true, не = true, по = true, из = true
	}
	local queryKeywords = {}
	for _, word in ipairs(searchWords) do
		local cleaned = word:gsub("[%p%d]", "")
		if #cleaned >= 2 and not stopWords[cleaned] then
			table.insert(queryKeywords, cleaned)
		end
	end
	if #queryKeywords == 0 then
		return {}
	end
	local bufferData = loadBufferFromFile()
	local results = {}
	for idx, entry in ipairs(bufferData) do
		if (not entry.advertisement or entry.advertisement == "") and 
		   (not entry.editedText or entry.editedText == "") then
			goto skip_entry
		end
		local adText = entry.editedText ~= "" and entry.editedText or entry.advertisement
		local adLower = lower_utf8_optimized(adText)
		local adWords = {}
		for word in adLower:gmatch("%S+") do
			table.insert(adWords, word)
		end
		local adFirstWord = nil
		if #adWords > 0 then
			if adWords[1]:find("^%[") and #adWords > 1 then
				adFirstWord = adWords[2]
			else
				adFirstWord = adWords[1]
			end
		end
		local adType = nil
		if adFirstWord then
			local cleanWord = adFirstWord:gsub("[%p]", "")
			if cleanWord == "куплю" or cleanWord == "куп" or cleanWord == "купил" then
				adType = "buy"
			elseif cleanWord == "продам" or cleanWord == "прод" or cleanWord == "продал" or cleanWord == "продаю" then
				adType = "sell"
			end
		end
		if searchType and adType then
			if searchType ~= adType then
				goto skip_entry
			end
		end
		local matchCount = 0
		local exactMatches = 0
		local bestScores = {}
		for _, keyword in ipairs(queryKeywords) do
			local bestScore = 0
			local isExact = false
			if adLower:find(keyword, 1, true) then
				bestScore = 100
				isExact = true
				exactMatches = exactMatches + 1
				matchCount = matchCount + 1
			else
				local len1, len2 = #keyword, 0
				local minSim = 70
				for adWord in adLower:gmatch("%S+") do
					local cleanAdWord = adWord:gsub("[%p%d]", "")
					if #cleanAdWord >= 2 then
						len2 = #cleanAdWord
						if len1 == 0 then 
							bestScore = (len2 == 0) and 100 or 0
						elseif len2 == 0 then 
							bestScore = 0
						else
							local matches = 0
							for i = 1, math.min(len1, len2) do
								if keyword:sub(i, i) == cleanAdWord:sub(i, i) then
									matches = matches + 1
								end
							end
							local similarity = (matches / math.max(len1, len2)) * 100
							if keyword:sub(1, 2) == cleanAdWord:sub(1, 2) then
								similarity = similarity + 15
							end
							similarity = math.min(similarity, 100)
							if similarity > bestScore then
								bestScore = similarity
							end
						end
					end
				end
				if bestScore >= minSim then
					matchCount = matchCount + 1
				end
			end
			table.insert(bestScores, {score = bestScore, exact = isExact})
		end
		local matchPercentage = (matchCount / #queryKeywords) * 100
		if matchPercentage < 50 then
			goto skip_entry
		end
		local adPrice = extractPrice(adText)
		local priceMatch = false
		if searchPrice and adPrice then
			local searchPriceNum = tonumber((searchPrice:gsub("[%.$]", "")))
			local adPriceNum = tonumber((adPrice:gsub("[%.$]", "")))
			if searchPriceNum and adPriceNum then
				local priceDiff = math.abs(searchPriceNum - adPriceNum) / math.max(searchPriceNum, adPriceNum)
				priceMatch = priceDiff <= 0.1
			end
		end
		if searchPrice and not adPrice then
			goto skip_entry
		end
		local relevance = 0
		relevance = relevance + (exactMatches * 35)
		relevance = relevance + (matchPercentage / 100) * 40
		local avgScore = 0
		for _, scoreData in ipairs(bestScores) do
			avgScore = avgScore + scoreData.score
		end
		avgScore = avgScore / #bestScores
		relevance = relevance + (avgScore / 100) * 20
		if searchPrice and priceMatch then
			relevance = relevance + 25
		end
		if entry.editedText ~= "" then
			relevance = relevance + 10
		end
		if relevance < 25 then
			goto skip_entry
		end
		table.insert(results, {
			text = adText,
			advertisement = entry.advertisement,
			author = entry.author,
			phone = entry.phone,
			relevance = relevance,
			matchCount = matchCount,
			exactMatches = exactMatches,
			price = adPrice
		})
		::skip_entry::
	end
	local searchHasPrice = searchLower:find("%d")
	table.sort(results, function(a, b)
		if not searchHasPrice then
			if (a.price == nil) ~= (b.price == nil) then
				return a.price == nil
			end
		end
		if a.relevance ~= b.relevance then
			return a.relevance > b.relevance
		end
		if a.exactMatches ~= b.exactMatches then
			return a.exactMatches > b.exactMatches
		end
		return a.matchCount > b.matchCount
	end)
	local topResults = {}
	for i = 1, math.min(20, #results) do
		table.insert(topResults, results[i])
	end
	return topResults
end
