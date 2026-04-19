function getFirstPlaceInfo()
	if not efir.counter or not next(efir.counter) then
		return nil, 0
	end
	local firstPlace = nil
	local maxBalls = -1
	for playerName, balls in pairs(efir.counter) do
		if balls > maxBalls then
			maxBalls = balls
			firstPlace = playerName
		end
	end
	return firstPlace, maxBalls
end
function getEfirMessageOrder(efirType)
	if not efir.messages[efirType] then
		return {start = {}, additional = {}, end_messages = {}}
	end
	local messages = efir.messages[efirType]
	local start = {}
	local additional = {}
	local end_messages = {}
	for key, _ in pairs(messages) do
		if key:match("^msg%d+$") then
			table.insert(start, key)
		elseif key == "first" or key == "next" then
			table.insert(start, key)
		elseif key:match("^end%d+$") then
			table.insert(end_messages, key)
		else
			table.insert(additional, key)
		end
	end
	local function compareKeys(a, b)
		local numA = tonumber(a:match("%d+"))
		local numB = tonumber(b:match("%d+"))
		if numA and numB then
			return numA < numB
		end
		return a < b
	end
	table.sort(start, compareKeys)
	table.sort(additional, compareKeys)
	table.sort(end_messages, compareKeys)
	local msgKeys = {}
	local firstKey = nil
	local nextKey = nil
	for _, key in ipairs(start) do
		if key == "first" then
			firstKey = key
		elseif key == "next" then
			nextKey = key
		else
			table.insert(msgKeys, key)
		end
	end
	if firstKey then table.insert(msgKeys, firstKey) end
	if nextKey then table.insert(msgKeys, nextKey) end
	return {
		start = msgKeys,
		additional = additional,
		end_messages = end_messages
	}
end
function getEfirMessageDisplayName(msgKey, efirType)
	if efir.messageDisplayNames and efir.messageDisplayNames[efirType] and efir.messageDisplayNames[efirType][msgKey] then
		return efir.messageDisplayNames[efirType][msgKey]
	end
	local names = {
		msg1 = 'Сообщение 1',
		msg2 = 'Сообщение 2', 
		msg3 = 'Сообщение 3',
		msg4 = 'Сообщение 4',
		msg5 = 'Сообщение 5',
		msg5_2 = 'Сообщение 5.2',
		msg6 = 'Сообщение 6',
		msg7 = 'Сообщение 7',
		msg8 = 'Сообщение 8',
		msg9 = 'Сообщение 9',
		msg10 = 'Сообщение 10',
		msg11 = 'Сообщение 11',
		msg12 = 'Сообщение 12',
		msg13 = 'Сообщение 13',
		msg14 = 'Сообщение 14',
		first = 'Первый вопрос/пример',
		next = 'Следующий вопрос/пример',
		ball1 = '1 балл',
		['ball1.2'] = '1 балл (вариант 2)',
		ball2 = '2-4 балла', 
		['ball2.2'] = '2-4 балла (вариант 2)',
		ball5 = '5-10 баллов',
		['ball5.2'] = '5-10 баллов (вариант 2)',
		winner1 = 'Победитель 1',
		winner2 = 'Победитель 2',
		winner3 = 'Победитель 3',
		end1 = 'Конец 1',
		end2 = 'Конец 2',
		end3 = 'Конец 3',
		end4 = 'Конец 4',
		end5 = 'Конец 5',
		introduce = 'Представление гостя',
		introduce2 = 'Переход к вопросам',
		question1 = 'Вопрос 1',
		question2 = 'Вопрос 2',
		question3 = 'Вопрос 3',
		question4 = 'Вопрос 4',
		stop1 = 'Завершение 1',
		stop2 = 'Завершение 2',
		stop3 = 'Завершение 3',
		stop4 = 'Завершение 4',
		stop5 = 'Завершение 5',
		stop6 = 'Завершение 6',
		stop7 = 'Завершение 7',
		stop8 = 'Завершение 8',
		stop9 = 'Завершение 9',
		stop10 = 'Завершение 10'
	}
	return names[msgKey] or msgKey
end
function getAimedPlayer()
	local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
	if result then
		local result2, id = sampGetPlayerIdByCharHandle(ped)
		if result2 and sampIsPlayerConnected(id) then
			return true, id
		end
	end
	return false, nil
end
function getPlayerNickTranslated()
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if myId then
		local nickname = sampGetPlayerNickname(myId)
		if nickname then
			local cleanNick = nickname:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			if translitExceptions[cleanNick] then
				return translitExceptions[cleanNick]
			end
			local forTranslit = cleanNick:gsub("_", " ")
			return trst(forTranslit)
		end
	end
	return ""
end
function getClosestPlayerId()
	local temp = {}
	local tPeds = getAllChars()
	local me = {getCharCoordinates(playerPed)}
	for i = 1, #tPeds do 
		local result, id = sampGetPlayerIdByCharHandle(tPeds[i])
		if tPeds[i] ~= playerPed and result then
			local pl = {getCharCoordinates(tPeds[i])}
			local dist = getDistanceBetweenCoords3d(me[1], me[2], me[3], pl[1], pl[2], pl[3])
			temp[#temp + 1] = { dist, id }
		end
	end
	if #temp > 0 then
		table.sort(temp, function(a, b) return a[1] < b[1] end)
		return true, temp[1][2]
	end
	return false
end
function getClosestPlayerIdToCenter()
	local screenX, screenY = getScreenResolution()
	local centerX, centerY = screenX / 2, screenY / 2
	local temp = {}
	local tPeds = getAllChars()
	for i = 1, #tPeds do 
		local result, id = sampGetPlayerIdByCharHandle(tPeds[i])
		if tPeds[i] ~= playerPed and result then
			local x, y, z = getCharCoordinates(tPeds[i])
			local screenPosX, screenPosY = convert3DCoordsToScreen(x, y, z)
			if screenPosX and screenPosY then
				local dist = math.sqrt((screenPosX - centerX) ^ 2 + (screenPosY - centerY) ^ 2)
				temp[#temp + 1] = { dist, id }
			end
		end
	end
	if #temp > 0 then
		table.sort(temp, function(a, b) return a[1] < b[1] end)
		return true, temp[1][2]
	end
	return false
end
function getServerTimeComponent(component)
	local success830, timeStr = pcall(sampTextdrawGetString, 830)
	local success829, dateStr = pcall(sampTextdrawGetString, 829)
	if not success830 or not timeStr then timeStr = "" end
	if not success829 or not dateStr then dateStr = "" end
	if component == 'h' then
		if timeStr and timeStr ~= "" then
			local hour = timeStr:match("(%d+):%d+")
			return hour or "00"
		end
	elseif component == 'm' then
		if timeStr and timeStr ~= "" then
			local minute = timeStr:match("%d+:(%d+)")
			return minute or "00"
		end
	elseif component == 'd' then
		if dateStr and dateStr ~= "" then
			local day = dateStr:match("(%d+)%.")
			return day or "01"
		end
	elseif component == 'M' then
		if dateStr and dateStr ~= "" then
			local month = dateStr:match("%d+%.(%d+)")
			return month or "01"
		end
	elseif component == 'y' then
		if dateStr and dateStr ~= "" then
			local year = dateStr:match("(%d+)$")
			return year or "2025"
		end
	end
	return ""
end
function getMyRankFromMembers()
	if not data.membersList or #data.membersList == 0 then
		return nil
	end
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if not myId then 
		return nil 
	end
	local myNick = sampGetPlayerNickname(myId)
	if not myNick then 
		return nil 
	end
	myNick = myNick:gsub("%[PC%]", ""):gsub("%[M%]", "")
	for _, member in ipairs(data.membersList) do
		local memberNick = member.name or ""
		memberNick = memberNick:gsub("%[PC%]", ""):gsub("%[M%]", "")
		if memberNick == myNick then
			local position = member.position or ""
			data.rankNumber = member.rank or 0
			return position
		end
	end
	return nil
end
function getWavePrefixFromBinds()
	if not data.newsHelpBind or #data.newsHelpBind == 0 then
		return "[" .. ffi.string(user.waveTag) .. "] "
	end
	for i = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[i]
		if category[1] ~= settings.bufferCategoryName then
			for j = 2, #category do
				local bind = category[j]
				if bind and bind[2] then
					local prefix = bind[2]:match("^%[(.-)%]")
					if prefix then
						return "[" .. prefix .. "] "
					end
				end
			end
		end
	end
	return "[" .. ffi.string(user.waveTag) .. "] "
end
function getHotkeyDisplayText(keys)
	if not keys or #keys == 0 then
		return "Не назначено"
	end
	local parts = {}
	for _, key in ipairs(keys) do
		table.insert(parts, getKeyName(key))
	end
	return table.concat(parts, " + ")
end
function getCommandRPData(cmdName)
	for _, cmd in ipairs(commandRPSystem.data) do
		if cmd.command == cmdName then
			return cmd
		end
	end
	return nil
end
function getKeyName(vkCode)
	if not vkCode then return "Не назначено" end
	return hotkeyNames[vkCode] or string.format("Key[%d]", vkCode)
end
function getHotkeyString(hotkey)
	if not hotkey or #hotkey == 0 then
		return "Не назначено"
	end
	local parts = {}
	for _, key in ipairs(hotkey) do
		table.insert(parts, getKeyName(key))
	end
	return table.concat(parts, " + ")
end