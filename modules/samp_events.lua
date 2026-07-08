function test6()
end
if imgui and vk and fa and requests and encoding and ev then	
	function ev.onShowDialog(id, style, title, button1, button2, text)
		if id == 856 then
			if efir.waitingAction == "enter_efir" then
				sampSendDialogResponse(856, 1, 0, "")
				efir.waitingAction = nil
				return false
			elseif efir.waitingAction == "exit_efir" then
				sampSendDialogResponse(856, 1, 0, "")
				efir.waitingAction = nil
				return false
			elseif efir.waitingAction == "enable_sms" then
				sampSendDialogResponse(856, 1, 3, "")
				efir.waitingAction = nil
				return false
			elseif efir.waitingAction == "disable_sms" then
				sampSendDialogResponse(856, 1, 3, "")
				efir.waitingAction = nil
				return false
			elseif efir.waitingAction == "invite_guest" then
				if not efir.interview.guestId or efir.interview.guestId < 0 then
					AddNotification("[News Helper]", "Ошибка: гость не выбран или неверный ID", "error", 3.0)
					efir.waitingAction = nil
					return true
				end
				sampSendDialogResponse(856, 1, 1, "")
				efir.interview.waitingForInvite = true
				return false
			elseif efir.waitingAction == "kick_guest" then
				if not efir.interview.guestId or efir.interview.guestId < 0 then
					AddNotification("[News Helper]", "Ошибка: гость не выбран или неверный ID", "error", 3.0)
					efir.waitingAction = nil
					return true
				end
				sampSendDialogResponse(856, 1, 2, "")
				efir.interview.waitingForKick = true
				return false
			end
		end
		if id == 857 then
			if efir.waitingAction == "invite_guest" then
				local guestId = efir.interview.guestId
				if guestId and guestId >= 0 then
					sampSendDialogResponse(857, 1, -1, tostring(guestId))
					efir.waitingAction = nil
					efir.interview.waitingForInvite = false
					return false
				else
					sampSendDialogResponse(857, 0, -1, "")
					efir.waitingAction = nil
					efir.interview.waitingForInvite = false
					return false
				end
			end
		end
		if id == 858 then
			if efir.waitingAction == "kick_guest" then
				local guestId = efir.interview.guestId
				if guestId and guestId >= 0 then
					sampSendDialogResponse(858, 1, -1, tostring(guestId))
					efir.waitingAction = nil
					efir.interview.waitingForKick = false
					return false
				else
					sampSendDialogResponse(858, 0, -1, "")
					efir.waitingAction = nil
					efir.interview.waitingForKick = false
					return false
				end
			end
			return true
		end
		if id == 696 then
			settings.autoViewAds.wasDialog696Opened = true
		elseif id == 697 then
			if settings.autoViewAds.enabled[0] and settings.autoViewAds.wasDialog696Opened then
				sampSendDialogResponse(697, 1, 0, "")
				settings.autoViewAds.wasDialog696Opened = false
				return false
			end
			settings.autoViewAds.wasDialog696Opened = false
		else
			if id ~= 696 and id ~= 697 then
				settings.autoViewAds.wasDialog696Opened = false
			end
		end
		if settings.autologin.enabled[0] then
			if id == 40 then
				sampSendDialogResponse(40, 1, _, _)
				return false
			end
			if id == 41 then
				if not settings.autologin.badPassword then
					sampSendDialogResponse(41, 1, _, u8:decode(ffi.string(settings.autologin.password)))
					return false
				end
			end
			if id == 42 then
				sampSendDialogResponse(42, 1, _, u8:decode(ffi.string(settings.autologin.pincode)))
				return false
			end
			if id == 43 then
				sampSendDialogResponse(43, 0, _, _)
				return false
			end
			if id == 44 and flags.autospawnEnabled[0] then
				sampSendDialogResponse(44, 1, 0, _)
				return false
			end
		end
		local cleanTitle = title:gsub("%[%d+%]", ""):gsub("{%x%x%x%x%x%x}", ""):gsub("^%s+", ""):gsub("%s+$", "")
		cleanTitle = encoding.UTF8(cleanTitle)
		if (id == 10 or id == 9403) and cleanTitle:find("Члены фракции") then
			if settings.checker.waiting or settings.checker.detectingRank then
				data.membersList = parseMembers(text)
				if settings.checker.detectingRank then
					local myRank = getMyRankFromMembers()
					if myRank then
						settings.checker.detectingRank = false
						data.mainIni.config.c_rang_b = myRank
						if user.rang then ffi.copy(user.rang, myRank) end
						saveConfig()
						SilentNotification("[News Helper]", "Ранг определен:\n" .. myRank .. " [" .. data.rankNumber .. "]", "success", 3.0)
						settings.checker.waiting = false
						settings.checker.requestAttempts = 0
						settings.checker.requestTime = 0
						settings.checker.currentPage = 0
						sampSendDialogResponse(id, 0, -1, "")
						return false
					else
						settings.checker.currentPage = settings.checker.currentPage + 1
						sampSendDialogResponse(id, 1, -1, "")
						return false
					end
				end
				settings.checker.waiting = false
				settings.checker.requestAttempts = 0
				settings.checker.requestTime = 0
				sampSendDialogResponse(id, 0, -1, "")
				return false
			end
			return true
		end
		if flags.publishingMode and flags.waitingForPublishConfirm then
			if id == 697 then
				flags.publishingMode = false
				sampSendDialogResponse(697, 1, 1, "")
				return false
			end
		end
		if settings.customAd.deleteMode then
			if id == 697 then
				sampSendDialogResponse(697, 1, 2, "")
				return false
			end
			local cleanTitle = title:gsub("%[%d+%]", ""):gsub("{%x%x%x%x%x%x}", ""):gsub("^%s+", ""):gsub("%s+$", "")
			cleanTitle = encoding.UTF8(cleanTitle)
			if id == 32700 and cleanTitle:find("Удаление объявления") then
				local reason = (settings.customAd.deleteReason)
				sampSendDialogResponse(32700, 1, -1, u8:decode(reason))
				AddNotification("[News Helper]", "Объявление удалено\nПричина: " .. reason, "success", 3.0)
				settings.customAd.deleteMode = false
				settings.customAd.deleteReason = ""
				return false
			end
			return true
		end
		if id == 698 then
			local adInfo = cp1251_to_utf8(text or ""):gsub("{%x%x%x%x%x%x}", "")
			local author = adInfo:match("Автор:%s*([%w_]+)") or "N/A"
			local authorId = nil
			local isOnline = false
			if author ~= "N/A" then
				for playerId = 0, sampGetMaxPlayerId() do
					if sampIsPlayerConnected(playerId) then
						local playerNick = sampGetPlayerNickname(playerId)
						if playerNick and playerNick:gsub("%[PC%]", ""):gsub("%[M%]", "") == author then
							authorId = playerId
							isOnline = true
							break
						end
					end
				end
			end
			settings.customAd.data.author = author
			settings.customAd.data.authorId = authorId
			settings.customAd.data.isAuthorOnline = isOnline
			settings.customAd.data.phone = adInfo:match("Номер телефона:%s*(%d+)") or "N/A"
			settings.customAd.data.advertisement = adInfo:match("Объявление:%s*(.-)В поле ниже") or "N/A"
			showCustomAdWindow(settings.customAd.data)
			return false
		end
		return true
	end
	function ev.onServerMessage(clr, message)
		message = decode1251(message)
		if message:find("говорит:") then return true end
		if efir.myNickname then
			local escapedNick = efir.myNickname:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
			if message:find("%[R%]") and message:find(escapedNick) and message:find("вош") and message:find("прямой эфир") then
				efir.inEfir = true
				AddNotification("[News Helper]", "Вы вошли в прямой эфир", "success", 3.0)
			end
			if message:find("%[R%]") and message:find(escapedNick) and message:find("вышел из прямого эфира") then
				efir.inEfir = false
				if efir.smsEnabled then
					efir.smsEnabled = false
					AddNotification("[News Helper]", "Прием СМС автоматически\nвыключен", "info", 2.0)
				end
				AddNotification("[News Helper]", "Вы вышли из прямого эфира", "warn", 3.0)
			end
			if message:find("%[R%]") and message:find(escapedNick) and message:find("включил прием") then
				efir.smsEnabled = true
				AddNotification("[News Helper]", "Прием СМС включен", "success", 3.0)
			end
			if message:find("%[R%]") and message:find(escapedNick) and message:find("выключил прием") then
				efir.smsEnabled = false
				AddNotification("[News Helper]", "Прием СМС выключен", "info", 3.0)
			end
		end
		local cleanMsg = message:gsub("{%x%x%x%x%x%x}", "")
		if cleanMsg:find("Вы пригласили в эфир") then
			efir.interview.isGuestInvited = true
			local guestName = ffi.string(efir.interview.name)
			if guestName and guestName ~= "" then
				local guestNick = guestName:gsub("_", " "):gsub("^%s+", ""):gsub("%s+$", "")
				AddNotification("[News Helper]", "Гость " .. guestNick .. "\nприглашен в эфир", "success", 3.0)
			else
				AddNotification("[News Helper]", "Гость приглашен в эфир", "success", 3.0)
			end
			efir.interview.waitingForInvite = false
		end
		if cleanMsg:find("Вы выпроводили из эфира") then
			efir.interview.isGuestInvited = false
			local guestName = ffi.string(efir.interview.name)
			if guestName and guestName ~= "" then
				local guestNick = guestName:gsub("_", " "):gsub("^%s+", ""):gsub("%s+$", "")
				AddNotification("[News Helper]", "Гость " .. guestNick .. "\nвыпровожен из эфира", "success", 3.0)
			else
				AddNotification("[News Helper]", "Гость выпровожен из эфира", "success", 3.0)
			end
			efir.interview.guestId = nil
			efir.interview.waitingForKick = false
		end
		if cleanMsg:find("Вы должны находиться в прямом эфире") then
			AddNotification("[News Helper]", "Сначала войдите в эфир!", "error", 3.0)
		end
		if cleanMsg:match("Игрок с ID %d+ не подключен") or cleanMsg:find("не подключен") then
			AddNotification("[News Helper]", "Игрок не найден\nна сервере", "error", 3.0)
			efir.interview.guestId = nil
			efir.interview.waitingForInvite = false
			efir.interview.waitingForKick = false
		end
		if message:find("Данное объявление уже кто%-то просматривает") then
			settings.autoViewAds.wasDialog696Opened = false
		end
		if settings.autologin.enabled[0] and message:find("Неверный пароль") then
			settings.autologin.badPassword = true
		end
		if flags.waitingForPublishConfirm then
			if message:find("Проверил объявление") then
				local nickFromMessage = message:match(": (.+)$")
				local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
				local playerNick = sampGetPlayerNickname(myId)
				if nickFromMessage then
					nickFromMessage = nickFromMessage:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):match("^(%S+)")
				end
				playerNick = playerNick:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):match("^(%S+)")
				if nickFromMessage == playerNick then
					flags.waitingForPublishConfirm = false
					flags.publishingMode = false
					return
				end
			end
		end
		if message:find("Вы не состоите во фракции") then
			if flags.autospawnEnabled[0] then
				flags.autospawnEnabled[0] = false
				AddNotification("[News Helper]", "Авто спавн отключен - \nвы не в фракции", "warn", 3.0)
			end
		end
		if message:find("Данное объявление уже кто%-то просматривает") and settings.autoViewAds.wasDialog696Opened then
			settings.autoViewAds.wasDialog696Opened = false
			AddNotification("[News Helper]", "Авто просмотр не\nсработал - объявление\nпросматривает другой игрок", "warn", 3.0)
		end
		local originalMessage = message
		if efir.auto.active and efir.auto.waitingForAnswer then
			local smsText = originalMessage:match("SMS:%s*(.-)%s*Отправитель:")
			local sender = originalMessage:match("Отправитель:%s*([%w_%.%[%]%-]+)")
			if smsText and sender then
				sender = sender:gsub("%[.-]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
				local senderCopy = tostring(sender)
				if senderCopy and #senderCopy > 0 then
					if processAutoAnswer(smsText, senderCopy, senderCopy) then
						local modifiedMsg = addIdToSMS(originalMessage)
						modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", "")
						return {clr, u8:decode(escapeProblematicChars(modifiedMsg))}
					end
				end
			end
		end
		if efir.auto.pausedDuringQuestions and originalMessage:match("SMS:") then
			local smsText = originalMessage:match("SMS:%s*(.-)%s*Отправитель:")
			local sender = originalMessage:match("Отправитель:%s*([%w_%.%[%]%-]+)")
			if smsText and sender then
				sender = sender:gsub("%[.-]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
				local senderCopy = tostring(sender)
				if senderCopy and #senderCopy > 0 then
					if processAutoAnswer(smsText, senderCopy, senderCopy) then
						local modifiedMsg = addIdToSMS(originalMessage)
						modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", "")
						return {clr, u8:decode(escapeProblematicChars(modifiedMsg))}
					end
				end
			end
		end
		if originalMessage:match("SMS:") and originalMessage:match("Отправитель:") then
			local modifiedMsg = addIdToSMS(originalMessage)
			modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", "")
			return {clr, u8:decode(escapeProblematicChars(modifiedMsg))}
		end
		return true
	end
	function ev.onInitGame(playerId)
		chat.myId = playerId
	end
	function ev.onSendChat(message)
		if not autoRP.enabled[0] then return end
		if message:sub(1, 1):match("[/%!%.@]") then return end
		if message:match("^%s*$") then return end
		if message:match("^[%(%)]+$") or message:lower():match("^xd+$") then return end
		local formatted = formatRPMessage(message, true)
		if formatted ~= message then
			sampSendChat(formatted)
			return false
		end
	end
	function ev.onSendCommand(command)
		local cmd = command:match("^/([%w_]+)")
		if not cmd then return end
		local params = command:match("^/[%w_]+%s*(.*)")
		params = params or ""
		if autoRP.enabled[0] and ({me = true, ame = true, ["do"] = true, r = true})[cmd] then
			local formatted = formatRPMessage(params, cmd == "do" or cmd == "r")
			sendRPCCommand("/" .. cmd .. " " .. formatted)
			return false
		end
		local cmdData = getCommandRPData(cmd)
		if not cmdData or not cmdData.enabled then
			return
		end
		executeCommandRP(cmd, params)
		return false
	end
end