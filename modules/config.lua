local function jsonEscape(s)
	if not s then return "" end
	s = tostring(s)
	s = s:gsub('\\', '\\\\')
	s = s:gsub('"', '\\"')
	s = s:gsub('\n', '\\n')
	s = s:gsub('\r', '\\r')
	s = s:gsub('\t', '\\t')
	return s
end
local function asyncHttpRequest(method, url, args, resolve, reject)
	local request_thread = effil.thread(function(method, url, args)
		local requests = require 'requests'
		local result, response = pcall(requests.request, method, url, args)
		if result and response then
			return true, tostring(response.status_code or 0), tostring(response.text or "")
		else
			return false, tostring(response)
		end
	end)(method, url, args)
	if not resolve then resolve = function() end end
	if not reject then reject = function() end end
	lua_thread.create(function()
		local runner = request_thread
		while true do
			local status, err = runner:status()
			if not err then
				if status == 'completed' then
					local result, statusCodeOrErr, text = runner:get()
					if result then
						resolve({status_code = tonumber(statusCodeOrErr) or 0, text = text})
					else
						reject(statusCodeOrErr)
					end
					return
				elseif status == 'cancelled' then
					return reject(status)
				end
			else
				return reject(err)
			end
			wait(0)
		end
	end)
end
function saveAllNewsButtonsData()
	local filePath = settings.configFolder .. 'NewsPanels.json'
	if not panels.sprav then panels.sprav = {} end
	if not panels.sprav.data then panels.sprav.data = {ppet = {}, ustav = {}, sprav = {}, pps = {}, ntsm = {}} end
	if not panels.sobes then panels.sobes = {} end
	if not panels.sobes.actions then panels.sobes.actions = {start = {}, documents = {}, finish = {}} end
	if not panels.custom then panels.custom = {} end
	if not panels.custom.data then panels.custom.data = {} end
	if not panels.rs then panels.rs = {} end
	if not panels.rs.actions then panels.rs.actions = {} end
	if not panels.rs.settings then panels.rs.settings = {} end
	if not panels.editor then panels.editor = {} end
	if panels.editor.type == 'sobes' and panels.editor.sobesSection and panels.editor.sobesKey then
		local section = panels.sobes.actions[panels.editor.sobesSection]
		if section and section[panels.editor.sobesKey] then
			section[panels.editor.sobesKey].lines = {}
			for _, line in ipairs(panels.editor.lines or {}) do
				local text = ffi.string(line.text)
				if text ~= "" then table.insert(section[panels.editor.sobesKey].lines, text) end
			end
		end
	end
	if panels.editor.type == 'sprav' and panels.sprav.editingCategory and panels.sprav.editingItemIndex then
		if panels.sprav.data[panels.sprav.editingCategory] then
			local item = panels.sprav.data[panels.sprav.editingCategory][panels.sprav.editingItemIndex]
			if item then
				item.name = ffi.string(panels.editor.editingName)
				item.lines = {}
				for _, line in ipairs(panels.editor.lines or {}) do
					local text = ffi.string(line.text)
					if text ~= "" then table.insert(item.lines, text) end
				end
			end
		end
	end
	if panels.editor.type == 'custom' and panels.custom.editingActionIndex then
		local action = panels.custom.data[panels.custom.editingActionIndex]
		if action then
			action.name = ffi.string(panels.editor.editingName)
			action.lines = {}
			for _, line in ipairs(panels.editor.lines or {}) do
				local text = ffi.string(line.text)
				if text ~= "" then table.insert(action.lines, text) end
			end
		end
	end
	if panels.editor.type == 'rs' and panels.editor.data then
		panels.editor.data.name = ffi.string(panels.editor.editingName)
		panels.editor.data.lines = {}
		for _, line in ipairs(panels.editor.lines or {}) do
			local text = ffi.string(line.text)
			if text ~= "" then table.insert(panels.editor.data.lines, text) end
		end
	end
	if not commandRPSystem then commandRPSystem = {} end
	if not commandRPSystem.data then commandRPSystem.data = {} end
	if commandRPSystem.editingCmdIndex and commandRPSystem.editingCmdIndex > 0 then
		local cmd = commandRPSystem.data[commandRPSystem.editingCmdIndex]
		if cmd then
			cmd.command = ffi.string(commandRPSystem.editingCmdName)
			cmd.lines = {}
			for _, line in ipairs(commandRPSystem.editorLines or {}) do
				local text = ffi.string(line.text)
				if text ~= "" then
					table.insert(cmd.lines, text)
				end
			end
			cmd.delay = commandRPSystem.globalDelay or 2000
			cmd.enabled = cmd.enabled ~= nil and cmd.enabled or true
		end
	end
	local commandRPToSave = {}
	if commandRPSystem.data then
		for i, cmd in ipairs(commandRPSystem.data) do
			commandRPToSave[i] = {
				command = cmd.command or "",
				lines = cmd.lines or {},
				enabled = cmd.enabled ~= nil and cmd.enabled or true,
				delay = cmd.delay or 2000
			}
		end
	end
	local allData = {
		spravData = panels.sprav.data or {},
		sobesData = panels.sobes.actions or {},
		commandRP = commandRPToSave,
		customActionsRS = panels.custom.data or {},
		rsSettings = {
			interactionKey = panels.rs.settings.interactionKey or 0,
			globalDelay = panels.rs.settings.globalDelay or 3000,
			actions = panels.rs.actions or {}
		}
	}
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJsonPretty(allData))
		file:close()
		AddNotification("[News Helper]", "Данные сохранены!", "success", 2.0)
		return true
	else
		AddNotification("[News Helper]", "Ошибка сохранения данных", "error", 3.0)
		return false
	end
end
function loadAllNewsButtonsData()
	local filePath = settings.configFolder .. 'NewsPanels.json'
	if not panels.sprav then panels.sprav = {} end
	if not panels.sprav.data then panels.sprav.data = {ppet = {}, ustav = {}, sprav = {}, pps = {}, ntsm = {}} end
	if not panels.sobes then panels.sobes = {} end
	if not panels.sobes.actions then panels.sobes.actions = {start = {}, documents = {}, finish = {}} end
	if not panels.custom then panels.custom = {} end
	if not panels.custom.data then panels.custom.data = {} end
	if not panels.rs then panels.rs = {} end
	if not panels.rs.actions then panels.rs.actions = {} end
	if not panels.rs.settings then panels.rs.settings = {} end
	if not commandRPSystem then commandRPSystem = {} end
	if not commandRPSystem.data then commandRPSystem.data = {} end
	if doesFileExist(filePath) then
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local success, data = pcall(function()
				return decodeJson(content)
			end)
			if success and data then
				if data.spravData then
					panels.sprav.data = data.spravData
				end
				if data.sobesData then
					panels.sobes.actions = data.sobesData
				end
				if data.commandRP and type(data.commandRP) == 'table' then
					commandRPSystem.data = data.commandRP
				end
				if data.customActionsRS then
					panels.custom.data = data.customActionsRS
				end
				if data.rsSettings then
					if data.rsSettings.interactionKey then
						panels.rs.settings.interactionKey = data.rsSettings.interactionKey
					end
					if data.rsSettings.globalDelay then
						panels.rs.settings.globalDelay = data.rsSettings.globalDelay
					else
						panels.rs.settings.globalDelay = 3000
					end
					if data.rsSettings.actions then
						for key, actionData in pairs(data.rsSettings.actions) do
							if panels.rs.actions[key] then
								panels.rs.actions[key].name = actionData.name or panels.rs.actions[key].name
								panels.rs.actions[key].lines = actionData.lines or panels.rs.actions[key].lines
								panels.rs.actions[key].delay = actionData.delay or panels.rs.actions[key].delay
								panels.rs.actions[key].needInput = actionData.needInput or panels.rs.actions[key].needInput
								panels.rs.actions[key].inputPlaceholder = actionData.inputPlaceholder or panels.rs.actions[key].inputPlaceholder
							end
						end
					end
				end
				return true
			end
		end
	end
	return false
end
function saveCustomEfirs()
	if efir.custom.selected and efir.custom.list[efir.custom.selected] then
		efir.custom.list[efir.custom.selected].lines = {}
		for _, line in ipairs(efir.custom.lines) do
			table.insert(efir.custom.list[efir.custom.selected].lines, {
				name = line.name,
				text = ffi.string(line.text)
			})
		end
	end
	local data = {}
	for key, efirData in pairs(efir.custom.list) do
		data[key] = {
			name = efirData.name,
			lines = efirData.lines or {}
		}
	end
	local filePath = settings.configFolder .. 'NewsCustomEfirs.json'
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJsonPretty(data))
		file:close()
		return true
	end
	return false
end
function loadCustomEfirs()
	local filePath = settings.configFolder .. 'NewsCustomEfirs.json'
	if doesFileExist(filePath) then
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local data = decodeJson(content)
			if data then
				efir.custom.list = data
				if efir.custom.selected and efir.custom.list[efir.custom.selected] and efir.custom.list[efir.custom.selected].lines then
					efir.custom.lines = {}
					for _, line in ipairs(efir.custom.list[efir.custom.selected].lines) do
						table.insert(efir.custom.lines, {
							name = line.name,
							text = imgui.new.char[512](line.text or "")
						})
					end
				else
					efir.custom.lines = {}
				end
				tabWindowSizes[8].y = calculateFreeEfirTabHeight()
				return true
			end
		end
	end
	efir.custom.list = {}
	efir.custom.lines = {}
	return false
end
function clearEfirSession()
	if doesFileExist(efirRecovery.filePath) then
		os.remove(efirRecovery.filePath)
	end
end
function loadEfirSession()
	if not doesFileExist(efirRecovery.filePath) then
		return nil
	end
	local file = io.open(efirRecovery.filePath, 'r')
	if not file then
		return nil
	end
	local content = file:read('*a')
	file:close()
	if not content or content == '' or content == '{}' then
		return nil
	end
	local sessionData = decodeJson(content)
	if not sessionData or not sessionData.timestamp then
		return nil
	end
	if os.time() - sessionData.timestamp > 3600 then
		clearEfirSession()
		return nil
	end
	return sessionData
end
function saveBinder()
	local data = {}
	for _, bind in ipairs(binder.list) do
		local bindData = {
			name = bind.name or "без названия",
			hotkey = bind.hotkey or {},
			command = bind.command or "",
			enableOnChat = bind.enableOnChat or false,
			enableOnDialog = bind.enableOnDialog or false,
			requireConfirm = bind.requireConfirm or false,
			blockKey = bind.blockKey or false,
			delay = bind.delay or 3000,
			lines = {},
			lineSendMode = {},
			enabled = bind.enabled ~= false,
			useRBM = type(bind.useRBM) == "cdata" and bind.useRBM[0] or (bind.useRBM or false),
			strictMode = bind.strictMode ~= false
		}
		if bind.lines then
			for idx, line in ipairs(bind.lines) do
				table.insert(bindData.lines, {
					text = line.text or "",
					delay = line.delay or 0
				})
				if bind.lineSendMode and bind.lineSendMode[idx] then
					bindData.lineSendMode[idx] = bind.lineSendMode[idx]
				else
					bindData.lineSendMode[idx] = 'send'
				end
			end
		end
		table.insert(data, bindData)
	end
	local path = settings.configFolder .. 'NewsBinder.json'
	local file = io.open(path, 'w')
	if file then
		file:write(encodeJsonPretty(data))
		file:close()
		return true
	end
	return false
end
function loadBinder()
	local path = settings.configFolder .. 'NewsBinder.json'
	if doesFileExist(path) then
		local file = io.open(path, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local data = decodeJson(content)
			if data then
				binder.list = data
				for _, bind in ipairs(binder.list) do
					if not bind.lineSendMode then
						bind.lineSendMode = {}
					end
					if bind.lines then
						for idx, line in ipairs(bind.lines) do
							if not bind.lineSendMode[idx] then
								bind.lineSendMode[idx] = 'send'
							end
						end
					end
					if bind.useRBM == nil then
						bind.useRBM = false
					end
					if bind.strictMode == nil then
						bind.strictMode = true
					end
					if bind.command and bind.command ~= "" then
						sampRegisterChatCommand(bind.command, function()
							if bind.enabled ~= false then
								executeBinder(bind)
							end
						end)
					end
				end
				return true
			end
		end
	end
	binder.list = {
		{
			name = "Редактор",
			hotkey = {vk.VK_Q},
			command = "",
			enableOnChat = false,
			enableOnDialog = false,
			requireConfirm = false,
			blockKey = false,
			delay = 0,
			lines = {
				{text = "/edit", delay = 0}
			},
			lineSendMode = {[1] = 'send'},
			enabled = true,
			useRBM = false,
			strictMode = true
		}
	}
	saveBinder()
	return false
end
function saveEfirMessagesToFile()
	local efirData = {}
	for efirType, messages in pairs(efir.messages) do
		if type(messages) == "table" then
			efirData[efirType] = {
				messages = {},
				displayNames = {}
			}
			for key, charPtr in pairs(messages) do
				if type(charPtr) == "cdata" then
					efirData[efirType].messages[key] = ffi.string(charPtr)
				elseif type(charPtr) == "string" then
					efirData[efirType].messages[key] = charPtr
				else
					efirData[efirType].messages[key] = tostring(charPtr) or ""
				end
			end
			if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
				efirData[efirType].displayNames = efir.messageDisplayNames[efirType]
			end
		end
	end
	efirData.reminders = {
		manual = {
			remind = ffi.string(efir.reminders.manual.remind),
			intrigue = ffi.string(efir.reminders.manual.intrigue),
			noAnswer = ffi.string(efir.reminders.manual.noAnswer)
		},
		auto = {
			remind = ffi.string(efir.reminders.auto.remind),
			intrigue = ffi.string(efir.reminders.auto.intrigue),
			noAnswer = ffi.string(efir.reminders.auto.noAnswer)
		}
	}
	local filePath = settings.configFolder .. 'NewsEfirMessages.json'
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJsonPretty(efirData))
		file:close()
		return true
	else
		AddNotification("[News Helper]", "Ошибка сохранения сообщений эфиров", "error", 5.0)
		return false
	end
end
function loadEfirMessages()
	local filePath = settings.configFolder .. 'NewsEfirMessages.json'
	if doesFileExist(filePath) then
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			content = content:gsub('\r\n', '\n'):gsub('\r', '\n')
			local success, data = pcall(function()
				return decodeJson(content)
			end)
			if success and data and next(data) then
				efir.messages = {}
				for efirType, efirData in pairs(data) do
					if type(efirData) == "table" and efirData.messages then
						efir.messages[efirType] = {}
						for key, value in pairs(efirData.messages) do
							if type(value) == "string" then
								local size = math.max(#value + 1, efir.messageSizes[key] or 512)
								efir.messages[efirType][key] = imgui.new.char[size](value)
							else
								efir.messages[efirType][key] = value
							end
						end
					end
				end
				efir.messageDisplayNames = {}
				for efirType, efirData in pairs(data) do
					if type(efirData) == "table" and efirData.displayNames then
						efir.messageDisplayNames[efirType] = efirData.displayNames
					end
				end
				if data.reminders then
					if data.reminders.manual then
						if data.reminders.manual.remind then ffi.copy(efir.reminders.manual.remind, data.reminders.manual.remind) end
						if data.reminders.manual.intrigue then ffi.copy(efir.reminders.manual.intrigue, data.reminders.manual.intrigue) end
						if data.reminders.manual.noAnswer then ffi.copy(efir.reminders.manual.noAnswer, data.reminders.manual.noAnswer) end
					end
					if data.reminders.auto then
						if data.reminders.auto.remind then ffi.copy(efir.reminders.auto.remind, data.reminders.auto.remind) end
						if data.reminders.auto.intrigue then ffi.copy(efir.reminders.auto.intrigue, data.reminders.auto.intrigue) end
						if data.reminders.auto.noAnswer then ffi.copy(efir.reminders.auto.noAnswer, data.reminders.auto.noAnswer) end
					end
				end
				return true
			else
				AddNotification("[News Helper]", "Ошибка чтения файла\nсообщений", "error", 3.0)
				resetEfirMessagesToDefault('all')
				return true
			end
		end
	else
		resetEfirMessagesToDefault('all')
		return true
	end
	return true
end
function saveHelpBinds()
	if not data.newsHelpBind or type(data.newsHelpBind) ~= "table" then
		chatMessage(u8:decode('[News Helper] Данные биндов не загружены!'), 0xFF0000)
		return false
	end
	local jsonData = {}
	for _, category in ipairs(data.newsHelpBind) do
		if #category >= 1 and category[1] ~= settings.bufferCategoryName then
			local categoryData = {
				category = u8:decode(category[1]), 
				items = {}
			}
			for i = 2, #category do
				if category[i] and #category[i] >= 2 then
					local item = {
						name = u8:decode(category[i][1]), 
						text = u8:decode(category[i][2])
					}
					if category[i][3] then
						item.searchText = u8:decode(category[i][3])
					end
					table.insert(categoryData.items, item)
					addWordsToAutoFill(category[i][2])
				end
			end
			table.insert(jsonData, categoryData)
		end
	end
	local fileName = data.selectedBindsVariant == 1 and 'news_help_binds.json' or (data.selectedBindsVariant == 2 and 'news_help_binds2.json' or 'news_help_binds3.json')
	local filePath = settings.configFolder .. fileName
	local file = io.open(filePath, 'w+b')
	if file then
		local jsonText = encodeJsonPretty(jsonData)
		file:write(u8:encode(jsonText))     
		file:close()
		resetEditorHistory()
		clearSearchCache()
		chatMessage(u8:decode('[News Helper] Бинды сохранены в ' .. fileName), 0x00FF00)
		return true
	else
		chatMessage(u8:decode('[News Helper] Ошибка сохранения в ' .. filePath), 0xFF0000)
		return false
	end
end
function loadHelpBinds()
	if not data.devConfig.filesInitialized then
		return
	end
	local fileName = data.selectedBindsVariant == 1 and 'news_help_binds.json' or (data.selectedBindsVariant == 2 and 'news_help_binds2.json' or 'news_help_binds3.json')
	local filePath = settings.configFolder .. fileName
	local file = io.open(filePath, 'r')
	if file then
		local content = file:read('*a')
		file:close()
		local jsonData = decodeJson(content)
		if jsonData then
			data.newsHelpBind = {}
			for _, category in ipairs(jsonData) do
				local categoryData = { category.category } 
				for _, item in ipairs(category.items) do
					local bindData = { item.name, item.text }
					if item.searchText then
						bindData[3] = item.searchText
					end
					table.insert(categoryData, bindData)
				end
				table.insert(data.newsHelpBind, categoryData)
			end
			SilentNotification("[News Helper]", string.format("Загружено %d категорий биндов\n(Вариант %d)", #data.newsHelpBind, data.selectedBindsVariant), "success", 3.0)
			clearSearchCache()
		end
	else
		AddNotification("[News Helper]", "Файл " .. fileName .. "\nне найден!", "error", 5.0)
	end
	ensureBufferCategory()
	moveBufferCategoryToEnd()
	initializeWaveTag()
end
function saveToAdBuffer(editedText, force)
	if not flags.autoBufferEnabled[0] and not force then
		return 
	end
	if not settings.customAd or not settings.customAd.data then
		return
	end
	if not settings.customAd.data.advertisement or settings.customAd.data.advertisement == "N/A" then
		return
	end
	local adData = {
		advertisement = settings.customAd.data.advertisement,
		author = settings.customAd.data.author or "",
		phone = settings.customAd.data.phone or ""
	}
	local maxSize = settings.maxBufferSize
	lua_thread.create(function()
		wait(50)
		addWordsToAutoFill(editedText)
		local bufferData = loadBufferFromFile()
		local resText = normalizeText(editedText)
		local resTextNormalized = normalizeForBufferCompare(resText)
		local found = false
		for _, entry in ipairs(bufferData) do
			local entryEditedNormalized = normalizeForBufferCompare(entry.editedText or "")
			if entryEditedNormalized == resTextNormalized and entry.author == adData.author then
				entry.editedText = resText
				entry.advertisement = adData.advertisement
				entry.phone = adData.phone
				found = true
				break
			end
		end
		if not found then
			local cleanAd = adData.advertisement
				:gsub('\r\n', ' ')
				:gsub('\n', ' ')
				:gsub('%s+', ' ')
				:gsub('%s+$', '')
				:gsub('^%s+', '')
			local newEntry = {
				advertisement = cleanAd,
				author = adData.author,
				phone = adData.phone,
				editedText = resText
			}
			table.insert(bufferData, 1, newEntry)
		end
		while #bufferData > maxSize do
			table.remove(bufferData, #bufferData)
		end
		saveBufferToFile(bufferData)
		local indexEntry = nil
		if not found then
			indexEntry = bufferData[1]
		else
			for _, e in ipairs(bufferData) do
				if e.author == adData.author and normalizeForBufferCompare(e.editedText or "") == resTextNormalized then
					indexEntry = e
					break
				end
			end
		end
		if indexEntry and indexEntry.advertisement and indexEntry.advertisement ~= "" and settings.suggestedButtons.enabled[0] then
			local entryId = (indexEntry.author or "") .. "_" .. (indexEntry.phone or "") .. "_" .. tostring(math.floor(os.clock() * 1000))
			local adText = jsonEscape(indexEntry.advertisement or "")
			local edText = jsonEscape(indexEntry.editedText or "")
			local auText = jsonEscape(indexEntry.author or "")
			local phText = jsonEscape(indexEntry.phone or "")
			local idText = jsonEscape(entryId)
			local jsonBody = '{"id":"' .. idText .. '","text":"' .. adText .. ' | ' .. edText .. '","author":"' .. auText .. '","phone":"' .. phText .. '"}'
			asyncHttpRequest("POST",
				"http://x3.qwertyx.host:25962/index",
				{timeout = 10, headers = {["Content-Type"] = "application/json", ["X-Auth-Token"] = "myNewsHelper2026SecretXyz789"}, data = jsonBody}
			)
		end
		ui.search.needRestoreScroll = true
		updateBufferCategory(bufferData)
		ui.search.resultsValid = false
	end)
end
function saveBufferToFile(bufferData)
	local filePath = settings.configFolder .. 'news_help_buffer.json'
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJsonPrettyBuffer(bufferData))
		file:close()
		return true
	else
		AddNotification("[News Helper]", "Ошибка сохранения буфера", "error", 3.0)
		return false
	end
end
function loadBufferFromFile()
	local file = io.open(settings.bufferFilePath, 'r')
	if not file then
		return {}
	end
	local content = file:read('*a')
	file:close()
	local data = decodeJson(content)
	return data or {}
end
function updateBufferCategory(bufferData)
	local path = settings.bufferFilePath
	local file = io.open(path, "w")
	if file then
		file:write(encodeJsonPrettyBuffer(bufferData))
		file:close()
	end
	local bufferCategoryIndex
	for i = 1, #data.newsHelpBind do
		if data.newsHelpBind[i][1] == settings.bufferCategoryName then
			bufferCategoryIndex = i
			break
		end
	end
	if not bufferCategoryIndex then
		table.insert(data.newsHelpBind, {settings.bufferCategoryName})
		bufferCategoryIndex = #data.newsHelpBind
	end
	for i = #data.newsHelpBind[bufferCategoryIndex], 2, -1 do
		table.remove(data.newsHelpBind[bufferCategoryIndex], i)
	end
	for idx, entry in ipairs(bufferData) do
		local bindData = {
			entry.advertisement or "",
			entry.editedText or "",
			entry.author or "",
			entry.phone or ""
		}
		table.insert(data.newsHelpBind[bufferCategoryIndex], bindData)
	end
end
function ensureBufferCategory()
	local path = settings.bufferFilePath
	if not doesFileExist(path) then
		local file = io.open(path, "w")
		if file then
			file:write("[]")
			file:close()
		end
	end
end
function moveBufferCategoryToEnd()
	local bufferCategoryIndex = nil
	local bufferCategory = nil
	for i = 1, #data.newsHelpBind do
		if data.newsHelpBind[i][1] == settings.bufferCategoryName then
			bufferCategoryIndex = i
			bufferCategory = data.newsHelpBind[i]
			break
		end
	end
	if not bufferCategory then
		table.insert(data.newsHelpBind, {settings.bufferCategoryName})
	elseif bufferCategoryIndex and bufferCategoryIndex < #data.newsHelpBind then
		table.remove(data.newsHelpBind, bufferCategoryIndex)
		table.insert(data.newsHelpBind, bufferCategory)
	end
end
function loadBufferOnStart()
	local bufferData = loadBufferFromFile()
	if bufferData and #bufferData > 0 then
		updateBufferCategory(bufferData)
		AddNotification("[News Helper]", string.format("Загружено %d записей из\nбуфера", #bufferData), "success", 3.0)
	end
end
function uploadBufferToServer()
	if data.devConfig.serverSynced then return end
	lua_thread.create(function()
		wait(3000)
		local bufferData = loadBufferFromFile()
		if not bufferData or #bufferData == 0 then
			data.devConfig.serverSynced = true
			saveConfig()
			return
		end
		local entries = {}
		for idx, entry in ipairs(bufferData) do
			local adText = entry.advertisement or ""
			local edText = entry.editedText or ""
			if adText ~= "" and adText ~= "+" and #adText >= 5 and not adText:match("^%a%a%a?%a?$") then
				local entryId = "buf_" .. tostring(idx) .. "_" .. tostring(math.floor(os.clock() * 1000))
				local combined = jsonEscape(adText .. " | " .. edText)
				local cleanAuthor = jsonEscape(entry.author or "")
				local cleanPhone = jsonEscape(entry.phone or "")
				local cleanId = jsonEscape(entryId)
				table.insert(entries, '{"id":"' .. cleanId .. '","text":"' .. combined .. '","author":"' .. cleanAuthor .. '","phone":"' .. cleanPhone .. '"}')
			end
		end
		if #entries == 0 then
			data.devConfig.serverSynced = true
			saveConfig()
			return
		end
		local batchSize = 50
		local totalBatches = math.ceil(#entries / batchSize)
		local done = 0
		for i = 1, totalBatches do
			local from = (i - 1) * batchSize + 1
			local to = math.min(i * batchSize, #entries)
			local batch = {}
			for j = from, to do table.insert(batch, entries[j]) end
			local jsonBody = '{"entries":[' .. table.concat(batch, ",") .. ']}'
			asyncHttpRequest("POST",
				"http://x3.qwertyx.host:25962/bulk-index",
				{timeout = 30, headers = {["Content-Type"] = "application/json", ["X-Auth-Token"] = "myNewsHelper2026SecretXyz789"}, data = jsonBody},
				function()
					done = done + 1
					if done == totalBatches then
						data.devConfig.serverSynced = true
						saveConfig()
						AddNotification("[News Helper]", string.format("Синхронизировано %d\nзаписей с сервером", #entries), "success", 3.0)
					end
				end,
				function()
					done = done + 1
					if done == totalBatches then
						data.devConfig.serverSynced = true
						saveConfig()
					end
				end
			)
			wait(100)
		end
	end)
end
function loadBuffer()
	local bufferData = loadBufferFromFile()
	if bufferData and #bufferData > 0 then
		updateBufferCategory(bufferData)
	end
end
function clearBuffer()
	local path = settings.bufferFilePath
	local file = io.open(path, "w")
	if file then
		file:write("[]")
		file:close()
	end
	for i = #data.newsHelpBind, 1, -1 do
		local category = data.newsHelpBind[i]
		if category and category[1] == settings.bufferCategoryName then
			for j = #category, 2, -1 do
				table.remove(category, j)
			end
		end
	end
	ui.search.resultsValid = false
	ui.search.cachedResults = {}
	AddNotification("[News Helper]", "Буфер объявлений очищен!", "success", 2.0)
end
function saveAutoFillData(data)
	local filePath = settings.configFolder .. 'news_auto_fill.json'
	if not data or not data.russian or not data.english or not data.mixed then
		data = {russian = {}, english = {}, mixed = {}}
	end
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJsonAutoFill(data))
		file:close()
		return true
	else
		AddNotification("[News Helper]", "Ошибка сохранения автозаполнения", "error", 3.0)
		return false
	end
end
function loadAutoFillData()
	local filePath = settings.configFolder .. 'news_auto_fill.json'
	local file = io.open(filePath, 'r')
	if not file then
		return {russian = {}, english = {}, mixed = {}}
	end
	local content = file:read('*a')
	file:close()
	if not content or #content == 0 then
		return {russian = {}, english = {}, mixed = {}}
	end
	local ok, data = pcall(decodeJson, content)
	if not ok then
		return {russian = {}, english = {}, mixed = {}}
	end
	if not data then
		return {russian = {}, english = {}, mixed = {}}
	end
	return {
		russian = data.russian or {},
		english = data.english or {},
		mixed = data.mixed or {}
	}
end
function initAutoFill()
	local filePath = settings.configFolder .. 'news_auto_fill.json'
	os.remove(filePath)
	local initialData = {russian = {}, english = {}, mixed = {}}
	saveAutoFillData(initialData)
	rescanAllBindsAndBuffer()
end
function loadAllQuoteWords()
	local bindsData = {
		variant1 = nil,
		variant2 = nil,
		variant3 = nil
	}
	local bindsVariants = {
		{ name = "news_help_binds.json", key = "variant1" },
		{ name = "news_help_binds2.json", key = "variant2" },
		{ name = "news_help_binds3.json", key = "variant3" }
	}
	for _, bindVariant in ipairs(bindsVariants) do
		local filePath = settings.configFolder .. bindVariant.name
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local jsonData = decodeJson(content)
			if jsonData then
				local binds = {}
				for _, category in ipairs(jsonData) do
					local categoryData = { category.category }
					for _, item in ipairs(category.items) do
						local bindData = { item.name, item.text }
						if item.searchText then
							bindData[3] = item.searchText
						end
						table.insert(categoryData, bindData)
					end
					table.insert(binds, categoryData)
				end
				bindsData[bindVariant.key] = binds
			end
		end
	end
	return bindsData
end
function reloadAllBinds()
	local bindsData = {
		variant1 = nil,
		variant2 = nil,
		variant3 = nil
	}
	local bindsVariants = {
		{ name = "news_help_binds.json", key = "variant1" },
		{ name = "news_help_binds2.json", key = "variant2" },
		{ name = "news_help_binds3.json", key = "variant3" }
	}
	for _, bindVariant in ipairs(bindsVariants) do
		local filePath = settings.configFolder .. bindVariant.name
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local jsonData = decodeJson(content)
			if jsonData then
				local binds = {}
				for _, category in ipairs(jsonData) do
					local categoryData = { category.category }
					for _, item in ipairs(category.items) do
						local bindData = { item.name, item.text }
						if item.searchText then
							bindData[3] = item.searchText
						end
						table.insert(categoryData, bindData)
					end
					table.insert(binds, categoryData)
				end
				bindsData[bindVariant.key] = binds
			end
		end
	end
	loadHelpBinds()
	AddNotification("[News Helper]", "Все вариации биндов\nперескачаны!", "success", 3.0)
	initializeWaveTag()
end
function encryptString(str)
	if not str or str == "" then 
		return "" 
	end
	str = tostring(str)
	local encrypted = ""
	for i = 1, #str do
		local charCode = string.byte(str, i)
		local shifted = charCode + 5
		encrypted = encrypted .. string.char(shifted)
	end
	local hexEncrypted = ""
	for i = 1, #encrypted do
		hexEncrypted = hexEncrypted .. string.format("%02X", string.byte(encrypted, i))
	end
	return hexEncrypted
end
function decryptString(encrypted)
	if not encrypted or encrypted == "" then 
		return "" 
	end
	encrypted = tostring(encrypted)
	if not encrypted:match("^[0-9A-Fa-f]+$") or #encrypted % 2 ~= 0 then
		return encrypted
	end
	local decrypted = ""
	for i = 1, #encrypted, 2 do
		local hexByte = encrypted:sub(i, i + 1)
		local charCode = tonumber(hexByte, 16)
		if charCode then
			decrypted = decrypted .. string.char(charCode)
		end
	end
	local result = ""
	for i = 1, #decrypted do
		local charCode = string.byte(decrypted, i)
		local shifted = charCode - 5
		result = result .. string.char(shifted)
	end
	return result
end
function encryptRankNumber(num)
	if not num then return "" end
	num = tonumber(num)
	if not num then return "" end
	local shifted = num + RANK_OFFSET
	return encryptString(tostring(shifted))
end
function decryptRankNumber(encrypted)
	if not encrypted or encrypted == "" then
		return 0
	end
	local decrypted = decryptString(encrypted)
	local num = tonumber(decrypted)
	if not num then return 0 end
	return num - RANK_OFFSET
end
function saveConfig()
	local config = {
		windowPos = settings.windowPos,
		windowSize = settings.windowSize,
		selectedTheme = settings.themes.current,
		customThemeColors = settings.themes.list.custom.colors,
		colors = {
			background = {settings.colors.background[0], settings.colors.background[1], settings.colors.background[2]},
			categoryButtons = {settings.colors.categoryButtons[0], settings.colors.categoryButtons[1], settings.colors.categoryButtons[2]},
			itemButtons = {settings.colors.itemButtons[0], settings.colors.itemButtons[1], settings.colors.itemButtons[2]}
		},
		hotkeys = {
			help = ui.hotkeys.help,
			sprav = ui.hotkeys.sprav,
			edit = ui.hotkeys.edit,
			settings = ui.hotkeys.settings,
			helpSearch = ui.hotkeys.helpSearch,
			pauseEfir = efir.control.pauseHotkey,
			starJump = settings.starJumpKey
		},
		membersChecker = {
			pos = settings.checker.pos,
			firstSetup = settings.checker.firstSetup,
			enabled = settings.checker.enabled[0],
			interval = settings.checker.interval[0],
			textColor = {settings.checker.textColor[0], settings.checker.textColor[1], settings.checker.textColor[2], settings.checker.textColor[3]},
			fontSize = settings.checker.fontSize[0]
		},
		maxBufferSize = settings.maxBufferSize,
		autoBufferEnabled = flags.autoBufferEnabled[0],
		autospawnEnabled = flags.autospawnEnabled[0],
		autoRPEnabled = autoRP.enabled[0],
		silentMode = settings.silentMode[0],
		publishOnEnter = settings.publishOnEnter[0],
		closeHelpByEsc = settings.closeHelpByEsc[0],
		autoViewAdsEnabled = settings.autoViewAds.enabled[0],
		autocompleteEnabled = settings.autocomplete.enabled[0],
		bufferSplitEnabled = settings.bufferSplit.enabled[0],
		autoPriceExtractionEnabled = settings.autoPriceExtraction.enabled[0],
		suggestedButtons = {
			enabled = settings.suggestedButtons.enabled[0],
			totalButtons = settings.suggestedButtons.totalButtons[0]
		},
		autologin = {
			enabled = settings.autologin.enabled[0],
			password = ffi.string(settings.autologin.password),
			pincode = ffi.string(settings.autologin.pincode)
		},
		efir = {autoInterval = efir.autoInterval[0], intervals = {}, lineCount = {}, settings = {lastPrize = ffi.string(efir.inputs.money), userGender = user.gender[0]}, questions = {}},
		userSettings = {
			c_nick = data.mainIni.config.c_nick,
			c_rang_b = encryptString(data.mainIni.config.c_rang_b),
			c_cnn = data.mainIni.config.c_cnn,
			c_city_n = data.mainIni.config.c_city_n,
			c_pol = data.mainIni.config.c_pol,
			wave_tag = data.mainIni.config.wave_tag,
			rankNumber = encryptRankNumber(data.rankNumber)
		},
		customBinds = data.customBinds,
		selectedBindsVariant = data.selectedBindsVariant,
		devConfig = {
			last_pro_version = data.devConfig.last_pro_version,
			last_ustav_version = data.devConfig.last_ustav_version,
			last_pps_version = data.devConfig.last_pps_version,
			last_nts_version = data.devConfig.last_nts_version,
			filesInitialized = data.devConfig.filesInitialized or false,
			serverSynced = data.devConfig.serverSynced or false
		}
	}
	local efirIntervals = {}
	for key, value in pairs(efir.intervals) do
		efirIntervals[key] = value[0]
	end
	config.efir.intervals = efirIntervals
	local efirLineCountData = {}
	for key, value in pairs(efirLineCount) do
		efirLineCountData[key] = value[0]
	end
	config.efir.lineCount = efirLineCountData
	for efirType, examples in pairs(efir.examples) do
		if examples then
			config.efir.questions[efirType] = {
				examples = {},
				answers = {}
			}
			local maxIndex = 0
			for i, ex in pairs(examples) do
				if ex then
					local exStr = ffi.string(ex)
					if exStr ~= "" then
						maxIndex = math.max(maxIndex, i)
					end
				end
			end
			if efir.answers[efirType] then
				for i, ans in pairs(efir.answers[efirType]) do
					if ans then
						local ansStr = ffi.string(ans)
						if ansStr ~= "" then
							maxIndex = math.max(maxIndex, i)
						end
					end
				end
			end
			for i = 1, maxIndex do
				if examples[i] then
					local exStr = ffi.string(examples[i])
					if exStr ~= "" then
						table.insert(config.efir.questions[efirType].examples, exStr)
					else
						table.insert(config.efir.questions[efirType].examples, false)
					end
				else
					table.insert(config.efir.questions[efirType].examples, false)
				end
				if efir.answers[efirType] and efir.answers[efirType][i] then
					local ansStr = ffi.string(efir.answers[efirType][i])
					if ansStr ~= "" then
						table.insert(config.efir.questions[efirType].answers, ansStr)
					else
						table.insert(config.efir.questions[efirType].answers, false)
					end
				else
					table.insert(config.efir.questions[efirType].answers, false)
				end
			end
		end
	end
	local jsonText = encodeJsonPrettySorted(config)
	if not jsonText then
		AddNotification("[News Helper]", "Ошибка кодирования конфига\nв JSON!", "error", 5.0)
		return false
	end
	local file = io.open(settings.configFolder .. 'news_helper_config.json', 'w')
	if file then
		file:write(jsonText)
		file:close()
		return true
	else
		AddNotification("[News Helper]", "Не удалось открыть\nфайл конфига!", "error", 5.0)
		return false
	end
end
function loadConfig()
	local file = io.open(settings.configFolder .. 'news_helper_config.json', 'r')
	if file then
		local content = file:read('*a')
		file:close()
		local config = decodeJson(content)
		if config then
			if config.windowPos then settings.windowPos = config.windowPos end
			if config.windowSize then settings.windowSize = config.windowSize end
			if config.selectedTheme then
				settings.themes.current = config.selectedTheme
			end
			if settings.themes.current == "rgb" then
				rgbTheme.enabled = true
				rgbTheme.hue = 0
			end
			if config.customThemeColors then
				settings.themes.list.custom.colors = config.customThemeColors
			end
			if config.colors then
				if config.colors.background then
					settings.colors.background[0], settings.colors.background[1], settings.colors.background[2] =
						config.colors.background[1], config.colors.background[2], config.colors.background[3]
				end
				if config.colors.categoryButtons then
					settings.colors.categoryButtons[0], settings.colors.categoryButtons[1], settings.colors.categoryButtons[2] =
						config.colors.categoryButtons[1], config.colors.categoryButtons[2], config.colors.categoryButtons[3]
				end
				if config.colors.itemButtons then
					settings.colors.itemButtons[0], settings.colors.itemButtons[1], settings.colors.itemButtons[2] =
						config.colors.itemButtons[1], config.colors.itemButtons[2], config.colors.itemButtons[3]
				end
			end
			if config.maxBufferSize then settings.maxBufferSize = config.maxBufferSize end
			if config.membersChecker then
				if config.membersChecker.pos then settings.checker.pos = config.membersChecker.pos end
				if config.membersChecker.firstSetup ~= nil then settings.checker.firstSetup = config.membersChecker.firstSetup end
				if config.membersChecker.enabled ~= nil then
					settings.checker.enabled[0] = config.membersChecker.enabled
					windows.checker[0] = config.membersChecker.enabled
				end
				if config.membersChecker.interval then
					settings.checker.interval[0] = config.membersChecker.interval
					membersCheckerUpdateInterval = config.membersChecker.interval * 1000
				end
				if config.membersChecker.textColor then
					settings.checker.textColor[0] = config.membersChecker.textColor[1]
					settings.checker.textColor[1] = config.membersChecker.textColor[2]
					settings.checker.textColor[2] = config.membersChecker.textColor[3]
					settings.checker.textColor[3] = config.membersChecker.textColor[4]
				end
				if config.membersChecker.fontSize then
					settings.checker.fontSize[0] = config.membersChecker.fontSize
					if ui.fonts.checker and type(renderDeleteFont) == "function" then
						renderDeleteFont(ui.fonts.checker)
					end
					ui.fonts.checker = renderCreateFont("Tahoma", settings.checker.fontSize[0], 200, 0)
				end
			end
			if config.hotkeys then
				if config.hotkeys.help and type(config.hotkeys.help) == "table" then ui.hotkeys.help = config.hotkeys.help end
				if config.hotkeys.sprav and type(config.hotkeys.sprav) == "table" then ui.hotkeys.sprav = config.hotkeys.sprav end
				if config.hotkeys.edit and type(config.hotkeys.edit) == "table" then ui.hotkeys.edit = config.hotkeys.edit end
				if config.hotkeys.settings and type(config.hotkeys.settings) == "table" then ui.hotkeys.settings = config.hotkeys.settings end
				if config.hotkeys.helpSearch and type(config.hotkeys.helpSearch) == "table" then ui.hotkeys.helpSearch = config.hotkeys.helpSearch end
				if config.hotkeys.pauseEfir and type(config.hotkeys.pauseEfir) == "table" then efir.control.pauseHotkey = config.hotkeys.pauseEfir end
				if config.hotkeys.starJump then settings.starJumpKey = config.hotkeys.starJump end
			end
			if config.autoBufferEnabled ~= nil then flags.autoBufferEnabled[0] = config.autoBufferEnabled end
			if config.autospawnEnabled ~= nil then flags.autospawnEnabled[0] = config.autospawnEnabled end
			if config.autoRPEnabled ~= nil then autoRP.enabled[0] = config.autoRPEnabled end
			if config.silentMode ~= nil then settings.silentMode[0] = config.silentMode end
			if config.publishOnEnter ~= nil then settings.publishOnEnter[0] = config.publishOnEnter end
			if config.closeHelpByEsc ~= nil then settings.closeHelpByEsc[0] = config.closeHelpByEsc end
			if config.autoViewAdsEnabled ~= nil then settings.autoViewAds.enabled[0] = config.autoViewAdsEnabled end
			if config.autocompleteEnabled ~= nil then settings.autocomplete.enabled[0] = config.autocompleteEnabled end
			if config.bufferSplitEnabled ~= nil then settings.bufferSplit.enabled[0] = config.bufferSplitEnabled end
			if config.autoPriceExtractionEnabled ~= nil then settings.autoPriceExtraction.enabled[0] = config.autoPriceExtractionEnabled end
			if config.suggestedButtons then
				if config.suggestedButtons.enabled ~= nil then
					settings.suggestedButtons.enabled[0] = config.suggestedButtons.enabled
				end
				if config.suggestedButtons.totalButtons then
					settings.suggestedButtons.totalButtons[0] = config.suggestedButtons.totalButtons
				end
			end
			if config.autologin then
				if config.autologin.enabled ~= nil then settings.autologin.enabled[0] = config.autologin.enabled end
				if config.autologin.password then ffi.copy(settings.autologin.password, config.autologin.password) end
				if config.autologin.pincode then ffi.copy(settings.autologin.pincode, config.autologin.pincode) end
			end
			if config.efir then
				if config.efir.autoInterval then efir.autoInterval[0] = config.efir.autoInterval end
				if config.efir.intervals then
					for key, value in pairs(config.efir.intervals) do
						if efir.intervals[key] then
							efir.intervals[key][0] = value
						end
					end
				end
				if config.efir.settings then
					if config.efir.settings.lastPrize then ffi.copy(efir.inputs.money, config.efir.settings.lastPrize) end
					if config.efir.settings.userGender then
						user.gender[0] = config.efir.settings.userGender
						user.radioInt[0] = config.efir.settings.userGender
					end
				end
				if config.efir.lineCount then
					for key, value in pairs(config.efir.lineCount) do
						if efirLineCount[key] then
							efirLineCount[key][0] = value
						end
					end
				end
				if config.efir.questions then
					for efirType, qdata in pairs(config.efir.questions) do
						if not efir.examples[efirType] then
							efir.examples[efirType] = {}
						end
						if not efir.answers[efirType] then
							efir.answers[efirType] = {}
						end
						local maxIndex = 0
						if qdata.examples and type(qdata.examples) == "table" then
							maxIndex = math.max(maxIndex, #qdata.examples)
						end
						if qdata.answers and type(qdata.answers) == "table" then
							maxIndex = math.max(maxIndex, #qdata.answers)
						end
						for i = 1, maxIndex do
							if not efir.examples[efirType][i] then
								efir.examples[efirType][i] = imgui.new.char[256]()
							end
							if not efir.answers[efirType][i] then
								efir.answers[efirType][i] = imgui.new.char[256]()
							end
						end
						if qdata.examples and type(qdata.examples) == "table" then
							for i, example in ipairs(qdata.examples) do
								if example and example ~= false and example ~= "" then
									if efir.examples[efirType][i] then
										ffi.copy(efir.examples[efirType][i], example)
									end
								end
							end
						end
						if qdata.answers and type(qdata.answers) == "table" then
							for i, answer in ipairs(qdata.answers) do
								if answer and answer ~= false and answer ~= "" then
									if efir.answers[efirType][i] then
										ffi.copy(efir.answers[efirType][i], answer)
									end
								end
							end
						end
					end
				end
			end
			if config.customBinds then
				data.customBinds = config.customBinds
				for cmd, text in pairs(data.customBinds) do
					sampRegisterChatCommand(cmd, function()
						sampSendChat(data.customBinds[cmd])
					end)
				end
			end
			if config.selectedBindsVariant then
				data.selectedBindsVariant = config.selectedBindsVariant
			end
			if config.userSettings then
				data.mainIni.config.c_nick = config.userSettings.c_nick or ""
				local c_rang_b_encrypted = config.userSettings.c_rang_b or ""
				if type(decryptString) == "function" and c_rang_b_encrypted ~= "" then
					data.mainIni.config.c_rang_b = decryptString(c_rang_b_encrypted) or ""
				else
					data.mainIni.config.c_rang_b = c_rang_b_encrypted
				end
				data.mainIni.config.c_cnn = config.userSettings.c_cnn or ""
				data.mainIni.config.c_city_n = config.userSettings.c_city_n or ""
				data.mainIni.config.c_pol = config.userSettings.c_pol or 2
				data.mainIni.config.wave_tag = config.userSettings.wave_tag or ""
				ffi.copy(user.waveTag, data.mainIni.config.wave_tag)
				if data.mainIni.config.c_rang_b and data.mainIni.config.c_rang_b ~= "" then
					if user.rang then
						ffi.fill(user.rang, ffi.sizeof(user.rang))
						ffi.copy(user.rang, data.mainIni.config.c_rang_b)
					end
				end
				if config.userSettings.rankNumber then
					local myRankNumberEncrypted = config.userSettings.rankNumber or ""
					if type(decryptRankNumber) == "function" and myRankNumberEncrypted ~= "" then
						data.rankNumber = decryptRankNumber(myRankNumberEncrypted) or 0
					else
						data.rankNumber = 0
					end
				end
			end
			if config.devConfig then
				data.devConfig.last_pro_version = config.devConfig.last_pro_version or 0
				data.devConfig.last_ustav_version = config.devConfig.last_ustav_version or 0
				data.devConfig.last_pps_version = config.devConfig.last_pps_version or 0
				data.devConfig.last_nts_version = config.devConfig.last_nts_version or 0
				data.devConfig.filesInitialized = config.devConfig.filesInitialized or false
				data.devConfig.serverSynced = config.devConfig.serverSynced or false
			end
		end
	end
end
function downloadBufferPack()
	lua_thread.create(function()
		local dlstatus = require('moonloader').download_status
		local bufferPath = settings.configFolder .. 'news_help_buffer.json'
		local dl_complete = false
		local dl_failed = false
		AddNotification("[News Helper]", "Загружаем сборник буферов...", "info", 3.0)
		downloadUrlToFile("https://github.com/alikhandwawd/newstools/raw/refs/heads/main/news_help_buffer.json", bufferPath, function(id, status, p1, p2)
			if status == dlstatus.STATUSEX_ENDDOWNLOAD then
				dl_complete = true
			elseif status == dlstatus.STATUS_DOWNLOADFAILED then
				dl_failed = true
			end
		end)
		local timeout = 0
		while not dl_complete and not dl_failed and timeout < 360 do
			wait(50)
			timeout = timeout + 1
		end
		if dl_failed or timeout >= 360 then
			AddNotification("[News Helper]", "Ошибка загрузки буфера", "error", 3.0)
			return
		end
		if doesFileExist(bufferPath) then
			local fileHandle = io.open(bufferPath, "rb")
			if fileHandle then
				local fileSize = fileHandle:seek("end")
				fileHandle:close()
				if fileSize > 0 then
					loadBufferOnStart()
					AddNotification("[News Helper]", "Сборник буферов успешно\nзагружен!", "success", 3.0)
					rescanAllBindsAndBuffer()
					settings.maxBufferSize = 1000
					uploadBufferToServer()
				else
					AddNotification("[News Helper]", "Файл буфера пуст", "error", 3.0)
				end
			end
		else
			AddNotification("[News Helper]", "Файл буфера не найден", "error", 3.0)
		end
	end)
end
function redownloadAllBinds()
	lua_thread.create(function()
		AddNotification("[News Helper]", "Перескачиваем все бинды...", "info", 2.0)
		wait(500)
		local bindsToDownload = {
			{ name = "news_help_binds.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds.json" },
			{ name = "news_help_binds2.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds2.json" },
			{ name = "news_help_binds3.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds3.json" }
		}
		local downloadComplete = {}
		for _, bindFile in ipairs(bindsToDownload) do
			local filePath = settings.configFolder .. bindFile.name
			if doesFileExist(filePath) then
				os.remove(filePath)
			end
			downloadUrlToFile(bindFile.url, filePath, function(id, status_code, p1, p2)
				downloadComplete[bindFile.name] = true
			end)
		end
		local timeout = os.clock() + 30
		local downloadedCount = 0
		while downloadedCount < #bindsToDownload and os.clock() < timeout do
			downloadedCount = 0
			for _, bindFile in ipairs(bindsToDownload) do
				if downloadComplete[bindFile.name] then
					downloadedCount = downloadedCount + 1
				end
			end
			wait(100)
		end
		wait(1000)
		reloadAllBinds()
		ui.binds.confirmRedownloadBinds = false
	end)
end
function loadAllDocuments()
	if not data.devConfig.filesInitialized then
		return
	end
	local docs = {
		{key = 'sprav', file = 'NewsPRO.json', var = 'PROtext'},
		{key = 'ustav', file = 'NewsUstav.json', var = 'Ustavtext'},
		{key = 'pps', file = 'NewsPPS.json', var = 'PPStext'},
		{key = 'nts', file = 'NewsNTS.json', var = 'NTStext'}
	}
	for _, doc in ipairs(docs) do
		local filePath = settings.configFolder .. doc.file
		if doesFileExist(filePath) then
			local f = io.open(filePath, "r")
			local content = f:read("*a")
			f:close()
			if content then
				data[doc.var] = content
			end
		else
			AddNotification("[News Helper]", "Файл " .. doc.file .. "\nне найден!", "error", 5.0)
		end
	end
end
if imgui and vk and fa and requests and encoding and ev then
	function checkAllDocVersions()
		if not (data.devConfig.filesInitialized or update_available) then
			return
		end
		local docs = {
			{key = 'pro', file = 'NewsPRO.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPRO.json'},
			{key = 'ustav', file = 'NewsUstav.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsUstav.json'},
			{key = 'pps', file = 'NewsPPS.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPPS.json'},
			{key = 'nts', file = 'NewsNTS.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsNTS.json'}
		}
		for _, doc in ipairs(docs) do
			local versionKey = doc.key .. '_version'
			local lastVersionKey = 'last_' .. doc.key .. '_version'
			data.devConfig[versionKey] = data.devConfig[versionKey] or 0
			data.devConfig[lastVersionKey] = data.devConfig[lastVersionKey] or 0
			if data.devConfig[versionKey] > data.devConfig[lastVersionKey] then
				AddNotification("[News Helper]", "Обнаружена новая версия\n" .. doc.file .. ". Обновление...", "info", 3.0)
				flags.blockWindowsOpenDuringDownload = true
				local docFilePath = settings.configFolder .. doc.file
				if doesFileExist(docFilePath) then
					os.remove(docFilePath)
				end
				local downloadStarted = false
				downloadUrlToFile(doc.url, docFilePath, function(id, status_code, p1, p2)
					downloadStarted = true
				end)
				local startTimeout = os.clock() + 10
				while not downloadStarted and os.clock() < startTimeout do
					wait(100)
				end
				if not downloadStarted then
					AddNotification("[News Helper]", "Ошибка загрузки " .. doc.file, "error", 3.0)
					flags.blockWindowsOpenDuringDownload = false
					goto continue
				end
				local maxWait = os.clock() + 180
				local lastSize = 0
				local noChangeCount = 0
				while os.clock() < maxWait do
					wait(500)
					if doesFileExist(docFilePath) then
						local fileHandle = io.open(docFilePath, "rb")
						if fileHandle then
							local fileSize = fileHandle:seek("end")
							fileHandle:close()
							if fileSize == lastSize and fileSize > 0 then
								noChangeCount = noChangeCount + 1
								if noChangeCount >= 3 then
									data.devConfig[lastVersionKey] = data.devConfig[versionKey]
									saveConfig()
									loadAllDocuments()
									AddNotification("[News Helper]", doc.file .. " обновлен\nдо версии " .. data.devConfig[versionKey] .. "!", "success", 3.0)
									flags.blockWindowsOpenDuringDownload = false
									break
								end
							else
								noChangeCount = 0
							end
							lastSize = fileSize
						end
					end
				end
				::continue::
			end
		end
	end
	function ensureJsonFiles()
		local files = {
			{ name = "NewsPRO.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPRO.json" },
			{ name = "NewsUstav.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsUstav.json" },
			{ name = "NewsPPS.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPPS.json" },
			{ name = "NewsNTS.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsNTS.json" },
			{ name = "news_help_binds.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds.json" },
			{ name = "news_help_binds2.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds2.json" },
			{ name = "news_help_binds3.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds3.json" },
			{ name = "news_help_buffer.json", url = "https://github.com/alikhandwawd/newstools/raw/refs/heads/main/news_help_buffer.json" }
		}
		local filesToDownload = {}
		if not data.devConfig.filesInitialized then
			filesToDownload = files
		else
			for _, file in ipairs(files) do
				local filePath = settings.configFolder .. file.name
				if not doesFileExist(filePath) then
					table.insert(filesToDownload, file)
				end
			end
		end
		if update_available or #filesToDownload == 0 then
			return
		end
		lua_thread.create(function()
			if update_available then
				return
			end
			AddNotification("[News Helper]", "Загружаем файлы\nконфигурации...", "info", 3.0)
			local downloadedCount = 0
			for _, file in ipairs(filesToDownload) do
				if update_available then
					AddNotification("[News Helper]", "Загрузка отменена:\nдоступно обновление", "info", 2.0)
					return
				end
				local filePath = settings.configFolder .. file.name
				local downloadStarted = false
				downloadUrlToFile(file.url, filePath, function(id, status_code, p1, p2)
					downloadStarted = true
				end)
				local startTimeout = os.clock() + 10
				while not downloadStarted and os.clock() < startTimeout do
					if update_available then
						AddNotification("[News Helper]", "Загрузка отменена:\nдоступно обновление", "info", 2.0)
						return
					end
					wait(100)
				end
				if update_available then
					AddNotification("[News Helper]", "Загрузка отменена:\nдоступно обновление", "info", 2.0)
					return
				end
				local maxWait = os.clock() + 180
				local lastSize = 0
				local noChangeCount = 0
				while os.clock() < maxWait do
					if update_available then
						AddNotification("[News Helper]", "Загрузка отменена:\nдоступно обновление", "info", 2.0)
						return
					end
					wait(500)
					if doesFileExist(filePath) then
						local fileHandle = io.open(filePath, "rb")
						if fileHandle then
							local fileSize = fileHandle:seek("end")
							fileHandle:close()
							if fileSize == lastSize and fileSize > 0 then
								noChangeCount = noChangeCount + 1
								if noChangeCount >= 3 then
									downloadedCount = downloadedCount + 1
									break
								end
							else
								noChangeCount = 0
							end
							lastSize = fileSize
						end
					end
				end
				if doesFileExist(filePath) then
					local fileHandle = io.open(filePath, "rb")
					if fileHandle then
						local fileSize = fileHandle:seek("end")
						fileHandle:close()
						if fileSize == 0 then
							AddNotification("[News Helper]", "[ОШИБКА] " .. file.name .. " пуст!", "error", 3.0)
						end
					end
				end
			end
			if downloadedCount == #filesToDownload then
				AddNotification("[News Helper]", "Все файлы успешно загружены!", "success", 3.0)
				loadConfig()
				loadHelpBinds()
				loadBufferOnStart()
				ensureBufferCategory()
				moveBufferCategoryToEnd()
				data.devConfig.filesInitialized = true
				saveConfig()
				uploadBufferToServer()
				wait(500)
				thisScript():reload()
			else
				AddNotification("[News Helper]", "[ОШИБКА] Загружено " .. downloadedCount .. "\nиз " .. #filesToDownload .. " файлов!", "error", 3.0)
			end
		end)
	end
end