function replaceEfirVariables(text)
	if not text then return "" end
	local result = text
	if data.mainIni and data.mainIni.config then
		result = result:gsub("<myrang>", data.mainIni.config.c_rang_b or "") 
		result = result:gsub("<mynick>", data.mainIni.config.c_nick or "") 
	end
	result = result:gsub("<prize>", ffi.string(efir.inputs.money) or "0")
	return result
end
function queueAddBall(name)
	table.insert(chat.scoreUpdateQueue, {action = "add", name = name})
end
function queueClearScore()
	table.insert(chat.scoreUpdateQueue, {action = "clear"})
end
function processScoreQueue()
	if #chat.scoreUpdateQueue == 0 then return end
	for _, update in ipairs(chat.scoreUpdateQueue) do
		if update.action == "add" then
			if efir.counter[update.name] then
				efir.counter[update.name] = efir.counter[update.name] + 1
			else
				efir.counter[update.name] = 1
			end
		elseif update.action == "clear" then
			efir.counter = {}
			efir.lastBallVariant = {}
		end
	end
	chat.scoreUpdateQueue = {}
end
function resetEfirMessagesToDefault(efirType)
	if efirType == 'all' then
		local allTypes = {'math', 'country', 'himia', 'zerkalo', 'annagramm', 'zagadki', 'sinonim', 'inter', 'reklama', 'sobes'}
		for _, type in ipairs(allTypes) do
			resetEfirMessagesToDefault(type)
		end
		saveEfirMessagesToFile()
		AddNotification("[News Helper]", "Все эфиры сброшены к\nдефолтным значениям", "success", 3.0)
		return
	end
	if not efir.messages then
		efir.messages = {}
	end
	if efir.messages[efirType] then
		for key, _ in pairs(efir.messages[efirType]) do
			efir.messages[efirType][key] = nil
		end
	else
		efir.messages[efirType] = {}
	end
	if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
		efir.messageDisplayNames[efirType] = {}
	end
	local defaults = {
		math = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = " Добрый день, уважаемые радиослушатели! У микрофона <mynick>..",
			msg4 = "Сегодня я проведу эфир на тему \"Математика\"..",
			msg5 = "..я называю пример - Вы ответ в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов!",
			msg8 = "Начинаем!",
			first = "Первый пример..",
			next = "Следующий пример..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo Вот и всё..* выключив микрофон."
		},
		country = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Сегодня я проведу эфир на тему \"Столицы\"..",
			msg5 = "..я называю страну - Вы столицу в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первая страна..",
			next = "Следующая страна..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		himia = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Сегодня я проведу эфир на тему \"Химия\"..",
			msg5 = "..я называю элемент - Вы его название в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первый элемент..",
			next = "Следующий элемент..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		zerkalo = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Сегодня я проведу эфир на тему \"Зеркало\"..",
			msg5 = "..я называю слово - Вы отправляете перевернутый вариант в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первое слово..",
			next = "Следующее слово..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		sobes = {
			msg1 = "/todo Начнем..*включив микрофон.",
			msg2 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Доброе время суток, уважаемые радиослушатели!",
			msg4 = "Вы находитесь на волне AMB.",
			msg5 = "Возможно Вы давно хотели попробовать себя в роли ведущего?",
			msg6 = "Зарабатывать от 100.000$ в день?",
			msg7 = "Стать популярным и узнаваемым человеком в штате?",
			msg8 = "Именно сейчас, у вас есть такая возможность, ведь прямо сейчас...",
			msg9 = "...проходит собеседование в нашу редакцию.",
			msg10 = "Наш радиоцентр лучший из всех, что есть в штате.",
			msg11 = "Чтобы пройти собеседование вам нужно иметь при себе...",
			msg12 = "...паспорт, мед. карту, трудовую книгу и быть законопослушным гражданином.",
			msg13 = "Так-же вы можете подать заявку на оффициальном портале.",
			msg14 = "Не упускай свой шанс заработать, и стать популярной личностью!",
			msg15 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			end1 = "/todo Начнем..*включив микрофон.",
			end2 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			end3 = "Доброе время суток, уважаемые радиослушатели!",
			end4 = "Хочу сказать, что собеседование в редакцию окончено.",
			end5 = "Ждем вас на следующем собеседовании, или же..",
			end6 = "..ждём вашего заявления на оффициальном портале.",
			end7 = "На этом наш эфир подходит к концу.",
			end8 = "До свидания, штат. Оставайтесь на волне AMB.",
			end9 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			end10 = "/todo На этом всё..*выключив микрофон."
		},
		annagramm = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Сегодня я проведу эфир на тему \"Анаграммы\"..",
			msg5 = "..я называю буквы из слова - Вы правильное слово в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первые буквы..",
			next = "Следующие буквы..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		zagadki = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Сегодня я проведу эфир на тему \"Загадки\"..",
			msg5 = "..я загадываю загадку - Вы ответ в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первая загадка..",
			next = "Следующая загадка..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		sinonim = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Сегодня я проведу эфир на тему \"Синонимы\"..",
			msg5 = "..я называю слово, а вы его синоним в СМС по номеру 1-1-1-1!",
			msg5_2 = "Например, я называю слово бежать, а вы - мчаться.",
			msg6 = "Призовой фонд составляет целых <prize>$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первое слово..",
			next = "Следующее слово..",
			ball1 = "<winnerball> зарабатывает <balls> балл!",
			["ball1.2"] = "<winnerball> получает <balls> балл!",
			ball2 = "<winnerball> зарабатывает <balls> балла!",
			["ball2.2"] = "<winnerball> получает <balls> балла!",
			ball5 = "<winnerball> зарабатывает <balls> баллов!",
			["ball5.2"] = "<winnerball> получает <balls> баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает <winnernick> - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		inter = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast °•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Вы находитесь на волне AMB..",
			msg5 = "И сейчас я проведу интервью.",
			introduce = "Сегодня у нас в гостях <guestrank> <guestname>",
			introduce2 = "И сейчас я задам вам несколько вопросов.",
			question1 = "Как ваше настроение?",
			question2 = "Расскажите о себе.",
			question3 = "Есть ли у вас жена, дети?",
			question4 = "Хотели бы вы передать кому-нибудь приветы?",
			end1 = "На этом наше интервью подходит к концу.",
			end2 = "С вами был ведущий <myrang> - <mynick>!",
			end3 = "До свидания, штат. Оставайтесь на волне AMB.",
			end4 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast °•°•°•°•",
			end5 = "/todo Вот и всё..* выключив микрофон."
		},
		reklama = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			msg3 = "Доброе время суток, уважаемые радиослушатели! У микрофона <mynick>",
			msg4 = "Вы находитесь на волне AMB.",
			msg5 = "Сейчас прозвучит рекламная пауза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был <myrang> - <mynick>! До свидания, штат. Оставайтесь на волне AMB.",
			end3 = "•°•°•°•° Музыкальная заставка Apex Media Broadcast •°•°•°•°•",
			end4 = "/todo На этом всё..* выключив микрофон."
		}
	}
	if defaults[efirType] then
		for key, value in pairs(defaults[efirType]) do
			local size = efir.messageSizes[key] or 512
			efir.messages[efirType][key] = imgui.new.char[size](value)
		end
	end
	if not efir.reminders then
		efir.reminders = {
			manual = {
				remind = imgui.new.char[512](),
				intrigue = imgui.new.char[512](),
				noAnswer = imgui.new.char[512]()
			},
			auto = {
				remind = imgui.new.char[512](),
				intrigue = imgui.new.char[512](),
				noAnswer = imgui.new.char[512]()
			}
		}
	end
	ffi.copy(efir.reminders.manual.remind, "Напоминаю, у нас эфир \"<efirtype>\", мы играем до 10 баллов! Приз: <prize>$.")
	ffi.copy(efir.reminders.manual.intrigue, "У <firstplace> уже <leaderballs> баллов! Успейте его обогнать, иначе он получит приз <prize>$!")
	ffi.copy(efir.reminders.manual.noAnswer, "Не вижу правильного ответа.")
	ffi.copy(efir.reminders.auto.remind, "Напоминаю, у нас эфир \"<efirtype>\", мы играем до 10 баллов! Приз: <prize>$.")
	ffi.copy(efir.reminders.auto.intrigue, "У <firstplace> уже <leaderballs> баллов! Успейте его обогнать, иначе он получит приз <prize>$!")
	ffi.copy(efir.reminders.auto.noAnswer, "Не вижу правильного ответа.")
	saveEfirMessagesToFile()
end
function clearSearchCache()
	cache.search = {}
	cache.lower = {}
	ui.search.cachedResults = {}
	ui.search.resultsValid = false
end
function normalizeAnswer(text)
	if not text then return "" end
	text = lower_utf8_optimized(text)
	text = text:gsub("%s+", "")
	text = text:gsub("[%p%c]", "")
	return text
end
function checkSMSAnswer(smsText, correctAnswer)
	local normalized = normalizeAnswer(smsText)
	local correct = normalizeAnswer(correctAnswer)
	return normalized == correct
end
function startEfir(efirType)
	clearEfirSession()
	if not checkUserData() then 
		if not settings.silentMode[0] then
			AddNotification("[News Helper]", "Заполните данные пользователя!", "warn", 3.0)
		end
		return 
	end
	local messages = efir.messages[efirType]
	if not messages then
		if not settings.silentMode[0] then
			AddNotification("[News Helper]", "Неизвестный тип эфира: " .. efirType, "error", 3.0)
		end
		return
	end
	if efirType == 'math' or efirType == 'country' or efirType == 'himia' or 
		efirType == 'zerkalo' or efirType == 'annagramm' or efirType == 'zagadki' or efirType == 'sinonim' then
		local hasExamples = false
		local lineCount = efirLineCount[efirType][0] or 10
		for i = 1, lineCount do
			if ffi.string(efir.examples[efirType][i]) ~= '' then
				hasExamples = true
				break
			end
		end
		if not hasExamples then
			AddNotification("[News Helper]", "Заполните хотя бы\nодин пример!", "warn", 3.0)
			return
		end
	end
	if efirType ~= 'inter' and efirType ~= 'reklama' and efirType ~= 'sobes' then
		if ffi.string(efir.inputs.money) == '' or ffi.string(efir.inputs.money) == '0' then
			AddNotification("[News Helper]", "Укажите призовой фонд!", "warn", 3.0)
			return
		end
	end
	_G.currentEfirType = efirType
	efir.control.running = true
	efir.control.paused = false
	efir.control.shouldEnd = false
	efir.control.currentLine = 1
	saveEfirSession()
	efir.control.thread = lua_thread.create(function()
		local allMessages = {}
		local i = 1
		while messages['msg' .. i] do
			table.insert(allMessages, {
				key = 'msg' .. i,
				text = ffi.string(messages['msg' .. i])
			})
			i = i + 1
		end
		local totalMessages = #allMessages
		while efir.control.currentLine <= totalMessages and efir.control.running do
			while efir.control.paused and efir.control.running and not efir.control.shouldEnd do
				saveEfirSession()
				wait(100)
			end
			if not efir.control.running then 
				saveEfirSession()
				return 
			end
			local currentMsg = allMessages[efir.control.currentLine]
			if currentMsg then
				local msgText = replaceEfirVariables(currentMsg.text)
				sampSendChat(u8:decode(msgText))
				efir.control.currentLine = efir.control.currentLine + 1
				saveEfirSession()
				if efir.control.currentLine <= totalMessages and not efir.control.shouldEnd then
					local delay = (efir.control.currentLine <= 3) and 2000 or 3000
					local interval = efir.intervals[efirType] and efir.intervals[efirType][0] or delay
					for i = 1, math.ceil(interval/100) do
						if not efir.control.running or efir.control.shouldEnd then 
							saveEfirSession()
							break 
						end
						wait(100)
						if efir.control.paused then
							saveEfirSession()
							while efir.control.paused and efir.control.running and not efir.control.shouldEnd do
								wait(100)
							end
							if not efir.control.running then
								return
							end
						end
					end
				end
			end
			if efir.control.shouldEnd then
				break
			end
		end
		if efir.control.currentLine > totalMessages and efir.control.running then
			if efir.control.shouldEnd then
				wait(1000)
				endEfir()
			end
			clearEfirSession()
		end
	end)
end
function stopEfir()
	clearEfirSession()
	if efir.control.running then
		if efir.control.thread then
			efir.control.thread:terminate()
		end
		efir.control.running = false
		efir.control.paused = false
		efir.control.currentLine = 1
	end
	efir.counter = {}
	efir.lastBallVariant = {}
	AddNotification("[News Helper]", "Эфир остановлен", "success", 3.0)
end
function endEfir()
	clearEfirSession()
	local efirType = efir.selectedType or _G.currentEfirType
	if not efirType then
		AddNotification("[News Helper]", "Сначала выберите тип эфира", "warn", 3.0)
		return
	end
	local messages = efir.messages[efirType]
	if not messages then
		AddNotification("[News Helper]", "Сообщения эфира не загружены", "error", 3.0)
		return
	end
	local endCount = 0
	for k, v in pairs(messages) do
		if k:match('^end') then
			endCount = endCount + 1
		end
	end
	if efir.control.running then
		efir.control.paused = true
		efir.control.shouldEnd = true
		saveEfirSession()
	end
	lua_thread.create(function()
		AddNotification("[News Helper]", "Завершаем эфир...", "info", 3.0)
		efir.control.isEnding = true
		local i = 1
		while messages['end' .. i] do
			local msgText = ffi.string(messages['end' .. i])
			if msgText ~= '' then
				msgText = replaceEfirVariables(msgText)
				sampSendChat(u8:decode(msgText))
				wait(efir.intervals[efirType] and efir.intervals[efirType][0] or 3000)
				saveEfirSession()
			end
			i = i + 1
		end
		efir.control.running = false
		efir.control.paused = false
		efir.control.shouldEnd = false
		efir.counter = {}
		efir.lastBallVariant = {}
		clearEfirSession()
		AddNotification("[News Helper]", "Эфир завершен!", "success", 3.0)
		efir.control.isEnding = false
	end)
end
function addPlayerBall()
	local id_string = ffi.string(efir.inputs.playerId)
	id_string = id_string:gsub("%s+", "")
	if id_string == "" then
		AddNotification("[News Helper]", "Введите ID игрока!", "warn", 3.0)
		return
	end
	local id = tonumber(id_string)
	if not id then
		AddNotification("[News Helper]", "ID должен быть числом!", "warn", 3.0)
		return
	end
	if id < 0 or id > 999 then
		AddNotification("[News Helper]", "ID должен быть\nот 0 до 999!", "warn", 3.0)
		return
	end
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if id ~= myId and not sampIsPlayerConnected(id) then
		AddNotification("[News Helper]", "Игрок с ID " .. id .. "\nне подключен к серверу!", "error", 3.0)
		return
	end
	local u_name = sampGetPlayerNickname(id):gsub("_"," ")
	local playerKey = u_name:gsub('%[PC%]',''):gsub('%[M%]','')
	lua_thread.create(function()
		wait(50)
		addball(playerKey)
		local points = efir.counter[playerKey]
		local ru_name = trst(playerKey)
		local currentType = efir.type or efir.selectedType or 'math'
		local messages = efir.messages[currentType]
		local interval = efir.intervals[currentType] and efir.intervals[currentType][0] or 3000
		if messages then
			if points < 10 then
				local ballMessage = ""
				local variantType = ""
				local remainder = points % 3
				if remainder == 1 then
					variantType = "ball1"
				elseif remainder == 2 then
					variantType = "ball2"
				elseif remainder == 0 then
					variantType = "ball5"
				end
				local isSendVersion = (points % 2 == 0)
				if isSendVersion then
					variantType = variantType .. ".2"
				end
				if messages[variantType] then
					ballMessage = ffi.string(messages[variantType])
					ballMessage = replaceEfirVariables(ballMessage)
					ballMessage = ballMessage:gsub("<balls>", tostring(points))
					ballMessage = ballMessage:gsub("<winnerball>", ru_name)
					sampSendChat(u8:decode(ballMessage))
				end
			else
				local winnerMsg1 = messages.winner1 and replaceEfirVariables(ffi.string(messages.winner1)) or "И у нас есть победитель!"
				local winnerMsg2 = messages.winner2 and replaceEfirVariables(ffi.string(messages.winner2)):gsub("<winnernick>", ru_name) or ("Побеждает " .. ru_name .. " - первый набрал 10 баллов и получает приз!")
				local winnerMsg3 = messages.winner3 and replaceEfirVariables(ffi.string(messages.winner3)) or "Просим победителя приехать в нашу редакцию для получения приза."
				sampSendChat(u8:decode(winnerMsg1))
				wait(interval)
				sampSendChat(u8:decode(winnerMsg2))
				wait(interval)
				sampSendChat(u8:decode(winnerMsg3))
			end
		end
	end)
end
function addball(name)
	if efir.counter[name] ~= nil then
		efir.counter[name] = efir.counter[name] + 1
	else
		efir.counter[name] = 1
	end
end
function sendNextQuestion()
	local currentType = efir.type or efir.selectedType or 'math'
	if efir.currentQuestion < 1 then
		efir.currentQuestion = 1
	end
	if efir.currentQuestion <= efirLineCount[currentType] then
		local example = ffi.string(efir.examples[currentType][efir.currentQuestion])
		if example ~= '' then
			lua_thread.create(function()
				local msgKey = efir.currentQuestion == 1 and "first" or "next"
				sampSendChat(u8:decode(ffi.string(efir.messages[currentType][msgKey])))
				local interval = efir.intervals[currentType] and efir.intervals[currentType][0] or 3000
				wait(interval)
				sampSendChat(u8:decode(example))
				efir.awaitingAnswer = true
			end)
		end
	end
end
function sendReminderMessage()
	local reminderText
	if efir.mode[0] then
		reminderText = ffi.string(efir.reminders.auto.remind)
	else
		reminderText = ffi.string(efir.reminders.manual.remind)
	end
	if reminderText ~= '' then
		reminderText = replaceEfirVariables(reminderText)
		local currentType = efir.auto.efirType or efir.selectedType or 'math'
		local efirTypeNames = {
			math = 'Математика',
			country = 'Столицы',
			himia = 'Химия',
			zerkalo = 'Зеркало',
			annagramm = 'Анаграммы',
			zagadki = 'Загадки',
			sinonim = 'Синонимы',
			inter = 'Интервью',
			reklama = 'Реклама',
			sobes = 'Собеседование'
		}
		local efirName = efirTypeNames[currentType] or currentType
		reminderText = reminderText:gsub("<efirtype>", efirName)
		if efir.mode[0] and autoEfirTimers.currentExample then
			local questionLabels = {
				math = 'пример',
				country = 'страна',
				himia = 'элемент',
				zerkalo = 'слово',
				annagramm = 'буквы',
				zagadki = 'загадка',
				sinonim = 'слово'
			}
			local label = questionLabels[currentType] or 'вопрос'
			reminderText = reminderText:gsub("<currentexample>", label .. ": " .. autoEfirTimers.currentExample)
		end
		sampSendChat(u8:decode(reminderText))
	end
end
function sendIntrigueMessage()
	local intrigueText
	if efir.mode[0] then
		intrigueText = ffi.string(efir.reminders.auto.intrigue)
	else
		intrigueText = ffi.string(efir.reminders.manual.intrigue)
	end
	if intrigueText ~= '' then
		intrigueText = replaceEfirVariables(intrigueText)
		local firstPlace, maxBalls = getFirstPlaceInfo()
		if firstPlace then
			local translatedName = trst(firstPlace)
			intrigueText = intrigueText:gsub("<firstplace>", translatedName)
			intrigueText = intrigueText:gsub("<leaderballs>", tostring(maxBalls))
		end
		sampSendChat(u8:decode(intrigueText))
	end
end
function startAutoEfir(efirType)
	clearEfirSession()
	if not checkUserData() then
		AddNotification("[News Helper]", "Заполните данные пользователя!", "warn", 5.0)
		return
	end
	efir.counter = {}
	efir.lastBallVariant = {}
	efir.auto.pausedDuringStartup = false
	efir.auto.pausedDuringQuestions = false
	efir.auto.finishedQuestions = false
	efir.auto.pausedAnswer = nil
	efir.auto.active = false
	if not efir.messages[efirType] then
		AddNotification("[News Helper]", "Сообщения эфира не загружены!", "error", 5.0)
		return
	end
	local messages = efir.messages[efirType]
	if not messages.first or not messages.next then
		AddNotification("[News Helper]", "Отсутствуют необходимые сообщения\nэфира!", "error", 5.0)
		return
	end
	local questionCount = efirLineCount[efirType][0]
	local filledCount = 0
	for i = 1, questionCount do
		local example = ffi.string(efir.examples[efirType][i])
		local answer = ffi.string(efir.answers[efirType][i])
		if example ~= '' and answer ~= '' then
			filledCount = filledCount + 1
		end
	end
	if filledCount < questionCount then
		AddNotification("[News Helper]", "Заполните все " .. questionCount .. "\nпримеров и ответов!\nЗаполнено: " .. filledCount .. "/" .. questionCount, "warn", 3.0)
		return
	end
	if ffi.string(efir.inputs.money) == '' or ffi.string(efir.inputs.money) == '0' then
		AddNotification("[News Helper]", "Укажите призовой фонд!", "warn", 3.0)
		return
	end
	autoEfirTimers.phase = 0
	autoEfirTimers.messageIndex = 0
	autoEfirTimers.startupMessages = {}
	autoEfirTimers.lastActionTime = os.clock() * 1000
	autoEfirTimers.currentQuestionPhase = 0
	autoEfirTimers.questionsAsked = 0
	autoEfirTimers.currentExample = ""
	autoEfirTimers.currentAnswer = ""
	local i = 1
	while messages['msg' .. i] do
		table.insert(autoEfirTimers.startupMessages, {key = 'msg' .. i, delay = efir.autoInterval[0]})
		i = i + 1
	end
	efir.auto.active = true
	efir.auto.paused = false
	efir.auto.pausedManually = false
	efir.auto.finishedQuestions = false
	efir.auto.efirType = efirType
	efir.auto.currentQuestion = 0
	efir.auto.waitingForAnswer = false
	efir.auto.totalQuestions = questionCount
	efir.auto.correctAnswers = {}
	efir.auto.isFirstPassage = true
	efir.auto.cyclingSent = false
	for i = 1, questionCount do
		efir.auto.correctAnswers[i] = ffi.string(efir.answers[efirType][i])
	end
	saveEfirSession()
	AddNotification("[News Helper]", "Автоматический эфир начат!\nВопросов: " .. questionCount, "info", 3.0)
end
function updateAutoEfir()
	if not efir.auto.active then return end
	local now = os.clock() * 1000
	local efirType = efir.auto.efirType
	if not efirType then return end
	if efir.auto.pausedDuringStartup or efir.auto.pausedDuringQuestions or efir.auto.pausedManually then
		return
	end
	if autoEfirTimers.phase == 0 then
		if autoEfirTimers.messageIndex == 0 then
			autoEfirTimers.messageIndex = 1
			autoEfirTimers.lastActionTime = now
			return
		end
		if autoEfirTimers.messageIndex <= #autoEfirTimers.startupMessages then
			local msgConfig = autoEfirTimers.startupMessages[autoEfirTimers.messageIndex]
			local delay = msgConfig.delay
			if now - autoEfirTimers.lastActionTime >= delay then
				sampSendChat(u8:decode(replaceEfirVariables(ffi.string(efir.messages[efirType][msgConfig.key]))))
				saveEfirSession()
				autoEfirTimers.messageIndex = autoEfirTimers.messageIndex + 1
				autoEfirTimers.lastActionTime = now
			end
		else
			autoEfirTimers.phase = 1
			autoEfirTimers.messageIndex = 0
			autoEfirTimers.currentQuestionPhase = 0
			autoEfirTimers.lastActionTime = now
			autoEfirTimers.questionsAsked = 0
			efir.auto.currentQuestion = 0
		end
		return
	end
	if autoEfirTimers.phase == 1 then
		if autoEfirTimers.currentQuestionPhase == 0 then
			if autoEfirTimers.questionsAsked >= (efir.auto.totalQuestions or 10) then
				endAutoEfirQuestions()
				return
			end
			if now - autoEfirTimers.lastActionTime < efir.autoInterval[0] then
				return
			end
			efir.auto.currentQuestion = efir.auto.currentQuestion + 1
			autoEfirTimers.questionsAsked = autoEfirTimers.questionsAsked + 1
			local exampleBuffer = efir.examples[efirType][efir.auto.currentQuestion]
			if not exampleBuffer then
				autoEfirTimers.currentQuestionPhase = 0
				autoEfirTimers.lastActionTime = now
				return
			end
			local example = ffi.string(exampleBuffer)
			if example == '' then
				autoEfirTimers.currentQuestionPhase = 0
				autoEfirTimers.lastActionTime = now
				return
			end
			autoEfirTimers.currentExample = example
			if efir.answers[efirType] and efir.answers[efirType][efir.auto.currentQuestion] then
				autoEfirTimers.currentAnswer = ffi.string(efir.answers[efirType][efir.auto.currentQuestion])
			else
				autoEfirTimers.currentAnswer = ""
			end
			efir.auto.correctAnswers[efir.auto.currentQuestion] = autoEfirTimers.currentAnswer
			local useFirst = efir.auto.isFirstPassage and autoEfirTimers.questionsAsked == 1
			local msgKey = useFirst and "first" or "next"
			sampSendChat(u8:decode(replaceEfirVariables(ffi.string(efir.messages[efirType][msgKey]))))
			saveEfirSession()
			autoEfirTimers.currentQuestionPhase = 1
			autoEfirTimers.lastActionTime = now
			return
		end
		if autoEfirTimers.currentQuestionPhase == 1 then
			if now - autoEfirTimers.lastActionTime >= efir.autoInterval[0] then
				sampSendChat(u8:decode(autoEfirTimers.currentExample))
				efir.auto.waitingForAnswer = true
				efir.reminders.auto.lastReminderTime = now
				saveEfirSession()
				autoEfirTimers.currentQuestionPhase = 2
				autoEfirTimers.lastActionTime = now
			end
			return
		end
		if autoEfirTimers.currentQuestionPhase == 2 then
			return
		end
	end
	if autoEfirTimers.phase == 2 then
		if autoEfirTimers.messageIndex == 0 then
			autoEfirTimers.messageIndex = 1
			autoEfirTimers.lastActionTime = now
			return
		end
		if autoEfirTimers.messageIndex <= #autoEfirTimers.endingMessages then
			local msgConfig = autoEfirTimers.endingMessages[autoEfirTimers.messageIndex]
			local delay = msgConfig.delay
			if now - autoEfirTimers.lastActionTime >= delay then
				sampSendChat(u8:decode(replaceEfirVariables(ffi.string(efir.messages[efirType][msgConfig.key]))))
				saveEfirSession()
				autoEfirTimers.messageIndex = autoEfirTimers.messageIndex + 1
				autoEfirTimers.lastActionTime = now
			end
		else
			clearEfirSession()
			stopAutoEfir()
			AddNotification("[News Helper]", "Автоэфир завершен", "info", 3.0)
		end
		return
	end
end
function updateWinnerSequence()
	if not winnerTimers.active then return end
	if winnerTimers.phase > 3 then return end
	local now = os.clock() * 1000
	local efirType = efir.auto.efirType
	if not efirType then return end
	local messages = efir.messages[efirType]
	if not messages then return end
	if winnerTimers.phase == 0 then
		if messages.winner1 then
			local winner1Msg = ffi.string(messages.winner1)
			if winner1Msg and winner1Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(winner1Msg)))
			end
		end
		winnerTimers.phase = 1
		winnerTimers.lastActionTime = now
		return
	end
	if winnerTimers.phase == 1 then
		if now - winnerTimers.lastActionTime >= efir.autoInterval[0] then
			if messages.winner2 then
				local winner2Msg = ffi.string(messages.winner2)
				if winner2Msg and winner2Msg ~= "" then
					local msg = replaceEfirVariables(winner2Msg):gsub("<winnernick>", winnerTimers.winnerName or "")
					sampSendChat(u8:decode(msg))
				end
			end
			winnerTimers.phase = 2
			winnerTimers.lastActionTime = now
		end
		return
	end
	if winnerTimers.phase == 2 then
		if now - winnerTimers.lastActionTime >= efir.autoInterval[0] then
			if messages.winner3 then
				local winner3Msg = ffi.string(messages.winner3)
				if winner3Msg and winner3Msg ~= "" then
					sampSendChat(u8:decode(replaceEfirVariables(winner3Msg)))
				end
			end
			finishAutoEfir()
			winnerTimers.active = false
			winnerTimers.phase = 4
		end
		return
	end
end
function updateResumeStartup()
	if not resumeStartupTimers.active then return end
	local now = os.clock() * 1000
	local efirType = efir.auto.efirType
	if not efirType then return end
	if resumeStartupTimers.messageIndex == 0 then
		resumeStartupTimers.messageIndex = 1
		resumeStartupTimers.lastActionTime = now
		return
	end
	if resumeStartupTimers.messageIndex <= #resumeStartupTimers.startupMessages then
		local msgConfig = resumeStartupTimers.startupMessages[resumeStartupTimers.messageIndex]
		local delay = msgConfig.delay
		if now - resumeStartupTimers.lastActionTime >= delay then
			if not efir.auto.pausedDuringStartup and not efir.auto.pausedManually then
				sampSendChat(u8:decode(replaceEfirVariables(ffi.string(efir.messages[efirType][msgConfig.key]))))
				saveEfirSession()
			end
			resumeStartupTimers.messageIndex = resumeStartupTimers.messageIndex + 1
			resumeStartupTimers.lastActionTime = now
		end
	else
		resumeStartupTimers.active = false
		if efir.auto.active and not efir.auto.pausedManually and not efir.auto.pausedDuringStartup then
		end
	end
end
function pauseAutoEfirDuringQuestions()
	efir.auto.waitingForAnswer = false
	efir.auto.pausedDuringQuestions = true
	saveEfirSession()
	AddNotification("[News Helper]", "Эфир на паузе", "info", 2.0)
end
function resumeAutoEfirDuringQuestions()
	if not efir.auto.pausedDuringQuestions then return end
	efir.auto.pausedDuringQuestions = false
	windows.mainSettings[0] = false
	local efirType = efir.auto.efirType
	if not efirType then
		AddNotification("[News Helper]", "Тип эфира\nне определен", "error", 5.0)
		stopAutoEfir()
		return
	end
	AddNotification("[News Helper]", "Продолжаю эфир...", "info", 2.0)
	if efir.auto.pausedAnswer then
		local answer = efir.auto.pausedAnswer
		efir.auto.pausedAnswer = nil
		efir.auto.waitingForAnswer = false
		local action = {
			type = "correct_answer",
			senderName = answer.senderName,
			translatedName = answer.translatedName,
			efirType = efir.auto.efirType,
			startTime = os.clock(),
			step = 1,
			points = 1,
			questionId = efir.auto.currentQuestion
		}
		table.insert(efir.auto.actionQueue, action)
	else
		efir.auto.waitingForAnswer = true
	end
	saveEfirSession()
end
function pauseAutoEfir()
	efir.auto.active = false
	efir.auto.waitingForAnswer = false
	efir.auto.pausedManually = true
	saveEfirSession()
	AddNotification("[News Helper]", "Эфир на паузе", "info", 3.0)
end
function resumeAutoEfir()
	if not efir.auto.pausedManually and not efir.auto.finishedQuestions then return end
	efir.auto.finishedQuestions = false
	efir.auto.pausedManually = false
	efir.auto.active = true
	windows.mainSettings[0] = false
	local efirType = efir.auto.efirType
	if not efirType then
		AddNotification("[News Helper]", "Тип эфира\nне определен", "error", 5.0)
		stopAutoEfir()
		return
	end
	AddNotification("[News Helper]", "Эфир возобновлен", "success", 3.0)
	saveEfirSession()
end
function pauseAutoEfirDuringStartup()
	efir.auto.pausedDuringStartup = true
	saveEfirSession()
	AddNotification("[News Helper]", "Эфир на паузе", "info", 3.0)
end
function resumeAutoEfirDuringStartup()
	if not efir.auto.pausedDuringStartup then return end
	efir.auto.pausedDuringStartup = false
	windows.mainSettings[0] = false
	saveEfirSession()
	local efirType = efir.auto.efirType
	if not efirType then
		AddNotification("[News Helper]", "Тип эфира не определен", "error", 5.0)
		stopAutoEfir()
		return
	end
	AddNotification("[News Helper]", "Продолжаю эфир...", "info", 3.0)
end
function endAutoEfirQuestions()
	if efir.auto.finishedQuestions then
		return
	end
	efir.auto.active = false
	efir.auto.waitingForAnswer = false
	efir.auto.finishedQuestions = true
	efir.auto.cyclingSent = false
	saveEfirSession()
	AddNotification("[News Helper]", "Вопросы закончились!", "warn", 3.0)
	AddNotification("[News Helper]", "Измените текущие вопросы\nесли хотите", "info", 3.0)
	AddNotification("[News Helper]", "Нажмите " .. getHotkeyString(efir.control.pauseHotkey) .. "\nчтобы продолжить.", "info", 3.0)
end
function resumeAutoEfirAfterEnd()
	if not efir.auto.finishedQuestions then return end
	efir.auto.finishedQuestions = false
	efir.auto.active = true
	efir.auto.isFirstPassage = false
	windows.mainSettings[0] = false
	local efirType = efir.auto.efirType
	if not efirType then
		AddNotification("[News Helper]", "Тип эфира\nне определен", "error", 5.0)
		stopAutoEfir()
		return
	end
	local totalQuestions = efirLineCount[efirType][0] or 10
	efir.auto.totalQuestions = totalQuestions
	efir.auto.correctAnswers = {}
	if not efir.answers[efirType] then
		AddNotification("[News Helper]", "Данные ответов\nне загружены", "error", 5.0)
		stopAutoEfir()
		return
	end
	for i = 1, totalQuestions do
		if efir.answers[efirType][i] then
			efir.auto.correctAnswers[i] = ffi.string(efir.answers[efirType][i])
		end
	end
	efir.auto.currentQuestion = 0
	autoEfirTimers.phase = 1
	autoEfirTimers.currentQuestionPhase = 0
	autoEfirTimers.questionsAsked = 0
	autoEfirTimers.lastActionTime = os.clock() * 1000
	AddNotification("[News Helper]", "Начинаю циклирование вопросов", "info", 3.0)
	saveEfirSession()
end
function processAutoAnswer(smsText, sender, senderId)
	if not efir.auto.correctAnswers or not efir.auto.correctAnswers[efir.auto.currentQuestion] then 
		return false
	end
	if efir.auto.updating then return false end
	if not efir.auto.active and not efir.auto.pausedDuringQuestions then return false end
	if not efir.auto.waitingForAnswer and not efir.auto.pausedDuringQuestions then return false end
	if not efir.auto.correctAnswers or not efir.auto.correctAnswers[efir.auto.currentQuestion] then return false end
	local correctAnswer = efir.auto.correctAnswers[efir.auto.currentQuestion]
	if not correctAnswer or correctAnswer == '' then return false end
	if checkSMSAnswer(smsText, correctAnswer) then
		local senderName = sender and sender:gsub("_", " ") or "Unknown"
		local translatedName = sender and trst(sender:gsub("_", " ")) or "Unknown"
		AddNotification("[News Helper]", "Правильный ответ от\n" .. translatedName .. "!", "success", 3.0)
		if efir.auto.pausedDuringQuestions then
			if not efir.auto.pausedAnswer then
				efir.auto.pausedAnswer = {
					senderName = senderName,
					translatedName = translatedName
				}
				AddNotification("[News Helper]", "Ответ от " .. translatedName .. "\nпринят, но эфир на паузе.\nНажмите " .. getHotkeyString(efir.control.pauseHotkey) .. " для возобновления", "warn", 5.0)
			end
			return true
		end
		efir.auto.waitingForAnswer = false
		efir.auto.questionStep = 0
		local action = {
			type = "correct_answer",
			senderName = senderName,
			translatedName = translatedName,
			efirType = efir.auto.efirType,
			startTime = os.clock(),
			step = 1,
			points = 1,
			questionId = efir.auto.currentQuestion
		}
		if action.senderName and action.senderName ~= "" then
			table.insert(efir.auto.actionQueue, action)
			return true
		end
	else
		if efir.reminders.auto.noAnswerEnabled and efir.reminders.auto.noAnswerEnabled[0] then
			efir.auto.wrongAnswerCount = efir.auto.wrongAnswerCount + 1
			if efir.auto.wrongAnswerCount >= efir.auto.maxWrongAnswers[0] then
				local noAnswerText = ffi.string(efir.reminders.auto.noAnswer)
				if noAnswerText ~= '' then
					sampSendChat(u8:decode(noAnswerText))
				end
				efir.auto.wrongAnswerCount = 0
			end
		end
		return false
	end
end
function processAutoEfirActionQueue()
	if #efir.auto.actionQueue == 0 then return end
	if not efir.auto.active and not efir.auto.paused then 
		efir.auto.actionQueue = {}
		return 
	end
	if efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then 
		return 
	end
	local action = efir.auto.actionQueue[1]
	if not action then return end
	if action.questionId ~= efir.auto.currentQuestion then
		table.remove(efir.auto.actionQueue, 1)
		return
	end
	local efirType = efir.auto.efirType
	if not efirType then return end
	local currentTime = os.clock()
	local elapsed = (currentTime - action.startTime) * 1000
	if action.type == "correct_answer" then
		if action.step == 1 and elapsed >= 500 then
			sampSendChat(u8:decode("Стоп!"))
			if efir.counter and action.senderName then
				local playerKey = action.senderName:gsub('%[PC%]',''):gsub('%[M%]','')
				if efir.counter[playerKey] then
					efir.counter[playerKey] = efir.counter[playerKey] + 1
				else
					efir.counter[playerKey] = 1
				end
			end
			action.step = 2
			action.stepTime = currentTime
			saveEfirSession()
		end
		if action.step == 2 and (currentTime - action.stepTime) * 1000 >= 50 then
			action.points = (efir.counter and efir.counter[action.senderName]) or 1
			action.step = 3
			action.stepTime = currentTime
			saveEfirSession()
		end
		if action.step == 3 then
			local interval = efir.autoInterval[0]
			if (currentTime - action.stepTime) * 1000 >= interval then
				action.step = 4
				action.stepTime = currentTime
				saveEfirSession()
			end
		end
		if action.step == 4 then
			if efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
			local points = action.points or 1
			if points < 10 then
				local variantType = ""
				if points == 1 then
					variantType = "ball1"
				elseif points <= 4 then
					variantType = "ball2"
				else
					variantType = "ball5"
				end
				local variants = {}
				if efir.messages and efir.messages[efirType] then
					local messages = efir.messages[efirType]
					for msgKey, _ in pairs(messages) do
						if msgKey == variantType or (type(msgKey) == "string" and msgKey:match("^" .. variantType .. "%.%d+$")) then
							table.insert(variants, msgKey)
						end
					end
				end
				if #variants > 0 then
					if not efir.lastBallVariant[action.senderName] then
						efir.lastBallVariant[action.senderName] = 1
					else
						efir.lastBallVariant[action.senderName] = (efir.lastBallVariant[action.senderName] % #variants) + 1
					end
					local selectedVariant = variants[efir.lastBallVariant[action.senderName]]
					if efir.messages and efir.messages[efirType] and selectedVariant then
						local messageBuffer = efir.messages[efirType][selectedVariant]
						if messageBuffer then
							local ballMessage = ffi.string(messageBuffer)
							if ballMessage and ballMessage ~= "" then
								ballMessage = replaceEfirVariables(ballMessage)
								ballMessage = ballMessage:gsub("<balls>", tostring(points))
								ballMessage = ballMessage:gsub("<winnerball>", action.translatedName)
								sampSendChat(u8:decode(ballMessage))
							end
						end
					end
				end
			end
			action.step = 5
			action.stepTime = currentTime
			saveEfirSession()
		end
		if action.step == 5 then
			if efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
			table.remove(efir.auto.actionQueue, 1)
			if action.points and action.points >= 10 then
				finishAutoEfirWithWinner(action.translatedName)
			else
				efir.auto.questionStep = 0
				autoEfirTimers.currentQuestionPhase = 0
				autoEfirTimers.lastActionTime = os.clock() * 1000
			end
			saveEfirSession()
		end
	end
end
function finishAutoEfir()
	if not efir.auto.active then return end
	local efirType = efir.auto.efirType
	if not efirType then
		stopAutoEfir()
		return
	end
	autoEfirTimers.phase = 2
	autoEfirTimers.messageIndex = 0
	autoEfirTimers.endingMessages = {}
	autoEfirTimers.lastActionTime = os.clock() * 1000
	local messages = efir.messages[efirType]
	if messages then
		local i = 1
		while messages['end' .. i] do
			table.insert(autoEfirTimers.endingMessages, {key = 'end' .. i, delay = efir.autoInterval[0]})
			i = i + 1
		end
	end
	saveEfirSession()
end
function finishAutoEfirWithWinner(winnerName)
	if not efir.auto.active then return end
	local efirType = efir.auto.efirType
	if not efirType then
		stopAutoEfir()
		return
	end
	winnerTimers.active = true
	winnerTimers.phase = 0
	winnerTimers.lastActionTime = 0
	winnerTimers.winnerName = winnerName
	saveEfirSession()
end
function stopAutoEfir()
	clearEfirSession()
	if efir.auto.mainThread then
		pcall(function() efir.auto.mainThread:terminate() end)
		efir.auto.mainThread = nil
	end
	if efir.control.running then
		if efir.control.thread then
			pcall(function() efir.control.thread:terminate() end)
		end
		efir.control.running = false
		efir.control.paused = false
		efir.control.currentLine = 1
	end
	local wasActive = efir.auto.active
	local efirType = efir.auto.efirType
	efir.auto.active = false
	efir.auto.paused = false
	efir.auto.efirType = nil
	efir.auto.currentQuestion = 0
	efir.auto.totalQuestions = 0
	efir.auto.waitingForAnswer = false
	efir.auto.questionStep = 0
	efir.counter = {}
	efir.lastBallVariant = {}
	efir.auto.correctAnswers = {}
	if wasActive then
		AddNotification("[News Helper]", "Эфир завершен", "info", 3.0)
		clearEfirSession()
	end
end
function setDialogTextWithEncoding(text)
	if sampIsDialogActive() then
		local convertedText = u8:encode(text)
		sampSetCurrentDialogEditboxText(convertedText)
	end
end
function checkUserData()
	if data.mainIni and data.mainIni.config and data.mainIni.config.c_nick and data.mainIni.config.c_nick ~= '' then
		return true
	end
	return false
end
function saveAutoEfirQuestions(efirType)
	if not efirType or not efir.examples[efirType] then
		AddNotification("[News Helper]", "Эфир не выбран", "warn", 3.0)
		return
	end
	local totalQuestions = efirLineCount[efirType][0]
	local savedCount = 0
	local lastFilledIndex = 0
	for i = 1, totalQuestions do
		local example = ffi.string(efir.examples[efirType][i])
		local answer = ffi.string(efir.answers[efirType][i])
		if example ~= '' and answer ~= '' then
			savedCount = savedCount + 1
			lastFilledIndex = i
		end
	end
	if savedCount == 0 then
		AddNotification("[News Helper]", "Нет вопросов для сохранения!", "warn", 3.0)
		return
	end
	saveConfig()
	AddNotification("[News Helper]", "Сохранено " .. savedCount .. " вопросов\nиз " .. lastFilledIndex, "success", 3.0)
end
function clearEfirQuestions(efirType)
	if not efirType or not efir.examples[efirType] then return end
	for i = 1, 50 do
		if efir.examples[efirType][i] then
			ffi.fill(efir.examples[efirType][i], ffi.sizeof(efir.examples[efirType][i]))
		end
		if efir.answers[efirType][i] then
			ffi.fill(efir.answers[efirType][i], ffi.sizeof(efir.answers[efirType][i]))
		end
	end
	AddNotification("[News Helper]", "Все вопросы и ответы эфира\n\"" .. efirType .. "\" очищены", "success", 3.0)
	saveConfig()
end
function saveEfirSession()
	if not efir.control.running and not efir.auto.active then
		return
	end
	local sessionData = {
		timestamp = os.time(),
		mode = efir.auto.active and "auto" or "manual",
		efirType = efir.auto.active and efir.auto.efirType or _G.currentEfirType,
		selectedType = efir.selectedType,
		paused = efir.auto.active and (efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup or efir.auto.pausedManually) or efir.control.paused,
		userData = {
			nick = data.mainIni.config.c_nick,
			rank = data.mainIni.config.c_rang_b,
			gender = user.gender[0]
		},
		scoreBoard = {},
		lastBallVariant = {},
		prize = ffi.string(efir.inputs.money),
		examples = {},
		winner = nil
	}
	for name, score in pairs(efir.counter) do
		sessionData.scoreBoard[name] = score
		if score >= 10 then
			sessionData.winner = name
		end
	end
	for name, variant in pairs(efir.lastBallVariant) do
		sessionData.lastBallVariant[name] = variant
	end
	local efirType = efir.auto.active and efir.auto.efirType or _G.currentEfirType
	if efirType and efir.examples[efirType] then
		sessionData.examples = {}
		local questionCount = efirLineCount[efirType][0]
		for i = 1, questionCount do
			if efir.examples[efirType][i] then
				local exampleText = ffi.string(efir.examples[efirType][i])
				if exampleText ~= "" then
					sessionData.examples[i] = exampleText
				end
			end
		end
	end
	if efir.auto.active then
		sessionData.auto = {
			currentQuestion = efir.auto.currentQuestion,
			totalQuestions = efir.auto.totalQuestions,
			waitingForAnswer = efir.auto.waitingForAnswer,
			isFirstPassage = efir.auto.isFirstPassage,
			pausedDuringQuestions = efir.auto.pausedDuringQuestions,
			pausedDuringStartup = efir.auto.pausedDuringStartup,
			pausedManually = efir.auto.pausedManually,
			finishedQuestions = efir.auto.finishedQuestions,
			questionsStarted = efir.auto.currentQuestion > 0,
			startupStep = efir.auto.startupStep or 0,
			questionStep = efir.auto.questionStep or 0,
			questionsAsked = autoEfirTimers.questionsAsked or 0,
			correctAnswers = {},
			answers = {},
			actionQueue = efir.auto.actionQueue or {},
			cyclingSent = efir.auto.cyclingSent or false,
			questionPhase = autoEfirTimers.currentQuestionPhase or 0
		}
		if efirType and efir.answers[efirType] then
			for i = 1, (efir.auto.totalQuestions or 10) do
				if efir.answers[efirType][i] then
					local answerText = ffi.string(efir.answers[efirType][i])
					if answerText ~= "" then
						sessionData.auto.answers[i] = answerText
					end
				end
			end
		end
		for i, answer in pairs(efir.auto.correctAnswers) do
			sessionData.auto.correctAnswers[i] = answer
		end
		if efir.auto.pausedAnswer then
			sessionData.auto.pausedAnswer = efir.auto.pausedAnswer
		end
	else
		sessionData.manual = {
			currentLine = efir.control.currentLine,
			awaitingAnswer = efir.awaitingAnswer,
			currentQuestion = efir.currentQuestion or 1,
			shouldEnd = efir.control.shouldEnd,
			isEnding = false
		}
		if efirType and efir.messages[efirType] then
			sessionData.manual.messages = {}
			for key, charPtr in pairs(efir.messages[efirType]) do
				if type(charPtr) == "cdata" then
					sessionData.manual.messages[key] = ffi.string(charPtr)
				elseif type(charPtr) == "string" then
					sessionData.manual.messages[key] = charPtr
				end
			end
		end
	end
	local file = io.open(efirRecovery.filePath, 'w')
	if file then
		file:write(encodeJson(sessionData))
		file:close()
	end
end
function restoreEfirSession(sessionData)
	efirRecovery.recovering = true
	efir.counter = {}
	efir.lastBallVariant = {}
	for name, score in pairs(sessionData.scoreBoard or {}) do
		efir.counter[name] = score
	end
	for name, variant in pairs(sessionData.lastBallVariant or {}) do
		efir.lastBallVariant[name] = variant
	end
	if sessionData.prize then
		ffi.copy(efir.inputs.money, sessionData.prize)
	end
	local efirType = sessionData.efirType
	if efirType and sessionData.examples then
		if not efir.examples[efirType] then
			efir.examples[efirType] = {}
		end
		local questionCount = efirLineCount[efirType][0]
		for i = 1, questionCount do
			if not efir.examples[efirType][i] then
				efir.examples[efirType][i] = imgui.new.char[256]()
			end
			if sessionData.examples[i] then
				ffi.copy(efir.examples[efirType][i], sessionData.examples[i])
			end
		end
	end
	if sessionData.mode then
		if sessionData.mode == "auto" then
			efir.mode[0] = true
		else
			efir.mode[0] = false
		end
	end
	if sessionData.mode == "auto" and sessionData.auto then
		efir.auto.active = true
		efir.auto.efirType = efirType
		efir.auto.currentQuestion = sessionData.auto.currentQuestion or 0
		efir.auto.totalQuestions = sessionData.auto.totalQuestions or 10
		efir.auto.waitingForAnswer = sessionData.auto.waitingForAnswer or false
		efir.auto.isFirstPassage = sessionData.auto.isFirstPassage or false
		efir.auto.finishedQuestions = sessionData.auto.finishedQuestions or false
		efir.auto.startupStep = sessionData.auto.startupStep or 0
		efir.auto.questionStep = sessionData.auto.questionStep or 0
		efir.auto.correctAnswers = {}
		efir.auto.actionQueue = sessionData.auto.actionQueue or {}
		efir.auto.cyclingSent = sessionData.auto.cyclingSent or false
		local questionsStarted = sessionData.auto.questionsStarted or false
		if questionsStarted then
			efir.auto.pausedDuringQuestions = true
			efir.auto.pausedDuringStartup = false
			efir.auto.pausedManually = false
			autoEfirTimers.phase = 1
			autoEfirTimers.currentQuestionPhase = sessionData.auto.questionPhase or sessionData.auto.questionStep or 0
			autoEfirTimers.questionsAsked = sessionData.auto.questionsAsked or 0
			autoEfirTimers.lastActionTime = os.clock() * 1000
			if sessionData.auto.pausedAnswer then
				autoEfirTimers.currentQuestionPhase = 2
			end
		else
			efir.auto.pausedDuringStartup = true
			efir.auto.pausedDuringQuestions = false
			efir.auto.pausedManually = false
			autoEfirTimers.phase = 0
			autoEfirTimers.messageIndex = sessionData.auto.startupStep or 0
			autoEfirTimers.lastActionTime = os.clock() * 1000
			autoEfirTimers.startupMessages = {}
			local messages = efir.messages[efirType]
			if messages then
				local i = 1
				while messages['msg' .. i] do
					table.insert(autoEfirTimers.startupMessages, {key = 'msg' .. i, delay = i <= 2 and 2000 or 3000})
					i = i + 1
				end
			end
		end
		if efirType and sessionData.auto.answers then
			if not efir.answers[efirType] then
				efir.answers[efirType] = {}
			end
			for i = 1, efir.auto.totalQuestions do
				if not efir.answers[efirType][i] then
					efir.answers[efirType][i] = imgui.new.char[256]()
				end
				if sessionData.auto.answers[i] then
					ffi.copy(efir.answers[efirType][i], sessionData.auto.answers[i])
				end
			end
		end
		for i, answer in pairs(sessionData.auto.correctAnswers or {}) do
			efir.auto.correctAnswers[i] = answer
		end
		if sessionData.auto.pausedAnswer then
			efir.auto.pausedAnswer = sessionData.auto.pausedAnswer
		end
		saveEfirSession()
		AddNotification("[News Helper]", "Автоматический эфир\nвосстановлен!", "success", 5.0)
		if sessionData.winner then
			AddNotification("[News Helper]", "Обнаружен победитель: " .. sessionData.winner, "info", 5.0)
		end
		if questionsStarted then
			AddNotification("[News Helper]", "Эфир был на вопросе #" .. efir.auto.currentQuestion .. ",\nшаг " .. efir.auto.questionStep, "info", 5.0)
		else
			AddNotification("[News Helper]", "Эфир был на стартовом\nсообщении #" .. (efir.auto.startupStep + 1), "info", 5.0)
		end
		if not efir.auto.isFirstPassage then
			AddNotification("[News Helper]", "Режим циклирования активен", "warn", 5.0)
		end
		AddNotification("[News Helper]", "Эфир на паузе. Нажмите " .. getHotkeyString(efir.control.pauseHotkey) .. "\nдля продолжения", "info", 5.0)
	elseif sessionData.mode == "manual" and sessionData.manual then
		efir.control.running = true
		efir.control.paused = true
		efir.control.currentLine = sessionData.manual.currentLine or 1
		efir.awaitingAnswer = sessionData.manual.awaitingAnswer or false
		efir.currentQuestion = sessionData.manual.currentQuestion or 1
		efir.type = sessionData.efirType
		efir.control.shouldEnd = sessionData.manual.shouldEnd or false
		if sessionData.efirType and sessionData.manual.messages then
			if not efir.messages[sessionData.efirType] then
				efir.messages[sessionData.efirType] = {}
			end
			for key, messageText in pairs(sessionData.manual.messages) do
				efir.messages[sessionData.efirType][key] = messageText
			end
		end
		_G.currentEfirType = sessionData.efirType
		saveEfirSession()
		AddNotification("[News Helper]", "Мануальный эфир восстановлен!", "success", 5.0)
		if sessionData.winner then
			AddNotification("[News Helper]", "Обнаружен победитель: " .. sessionData.winner, "info", 5.0)
		end
		AddNotification("[News Helper]", "Эфир на строке #" .. efir.control.currentLine, "info", 5.0)
		AddNotification("[News Helper]", "Эфир на паузе. Нажмите " .. getHotkeyString(efir.control.pauseHotkey) .. "\nдля продолжения", "info", 5.0)
		efir.control.thread = lua_thread.create(function()
			local allMessages = {}
			local i = 1
			while efir.messages[sessionData.efirType] and efir.messages[sessionData.efirType]['msg' .. i] do
				table.insert(allMessages, {
					key = 'msg' .. i,
					text = ffi.string(efir.messages[sessionData.efirType]['msg' .. i])
				})
				i = i + 1
			end
			local totalMessages = #allMessages
			while efir.control.currentLine <= totalMessages and efir.control.running do
				while efir.control.paused and efir.control.running and not efir.control.shouldEnd do
					saveEfirSession()
					wait(100)
				end
				if not efir.control.running then 
					saveEfirSession()
					return 
				end
				local currentMsg = allMessages[efir.control.currentLine]
				if currentMsg then
					local msgText = replaceEfirVariables(currentMsg.text)
					sampSendChat(u8:decode(msgText))
					efir.control.currentLine = efir.control.currentLine + 1
					saveEfirSession()
					if efir.control.currentLine <= totalMessages and not efir.control.shouldEnd then
						local delay = (efir.control.currentLine <= 3) and 2000 or 3000
						local interval = efir.intervals[sessionData.efirType] and efir.intervals[sessionData.efirType][0] or delay
						for i = 1, math.ceil(interval/100) do
							if not efir.control.running or efir.control.shouldEnd then 
								saveEfirSession()
								break 
							end
							wait(100)
							if efir.control.paused then
								saveEfirSession()
								while efir.control.paused and efir.control.running and not efir.control.shouldEnd do
									wait(100)
								end
								if not efir.control.running then
									return
								end
							end
						end
					end
				end
				if efir.control.shouldEnd then
					break
				end
			end
			if efir.control.currentLine > totalMessages and efir.control.running then
				if efir.control.shouldEnd then
					wait(1000)
					endEfir()
				end
				clearEfirSession()
			end
		end)
	end
	if sessionData.selectedType then
		efir.selectedType = sessionData.selectedType
		data.currentMainSettingsTab = 6
		windows.mainSettings[0] = true
		AddNotification("[News Helper]", "Эфир типа '" .. sessionData.selectedType .. "' выбран", "info", 3.0)
	end
	efirRecovery.recovering = false
end
function clearScoreboard()
	queueClearScore()
	efir.counter = {}
	efir.lastBallVariant = {}
	AddNotification("[News Helper]", "Таблица баллов очищена", "success", 3.0)
end
function initializeWaveTag()
	if data.newsHelpBind and #data.newsHelpBind > 0 then
		for catIndex = 1, #data.newsHelpBind do
			local category = data.newsHelpBind[catIndex]
			for bindIndex = 2, #category do
				local bind = category[bindIndex]
				if bind and bind[2] then
					local text = bind[2]
					local waveTag = text:match("%[([^%]]+)%]")
					if waveTag and waveTag ~= "" then
						ffi.copy(user.waveTag, waveTag)
						data.mainIni.config.wave_tag = waveTag
						return
					end
				end
			end
		end
	end
	if data.mainIni.config.wave_tag and data.mainIni.config.wave_tag ~= "" then
		ffi.copy(user.waveTag, data.mainIni.config.wave_tag)
	end
end
function replaceWaveTagInAllBinds(newTag)
	local replacedCount = 0
	local isRemovingTag = (not newTag or newTag == "")
	if isRemovingTag then
		AddNotification("[News Helper]", "Удаление префикса...", "info", 2.0)
	end
	for variant = 1, 3 do
		local fileName = variant == 1 and 'news_help_binds.json' or (variant == 2 and 'news_help_binds2.json' or 'news_help_binds3.json')
		local filePath = settings.configFolder .. fileName
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local jsonData = decodeJson(content)
			if jsonData then
				local variantReplacedCount = 0
				for _, category in ipairs(jsonData) do
					for _, item in ipairs(category.items) do
						local oldText = item.text
						local newText = oldText
						if isRemovingTag then
							newText = oldText:gsub("^%[.-%]%s*", "")
							newText = newText:gsub("%[.-%]", "[]")
						else
							local firstBracketStart, firstBracketEnd = oldText:find("^%[.-%]")
							if firstBracketStart then
								local beforeFirst = oldText:sub(1, firstBracketStart - 1)
								local afterFirst = oldText:sub(firstBracketEnd + 1)
								afterFirst = afterFirst:gsub("%[.-%]", "[]")
								newText = beforeFirst .. "[" .. newTag .. "]" .. afterFirst
							else
								afterFirst = oldText:gsub("%[.-%]", "[]")
								newText = "[" .. newTag .. "] " .. afterFirst
							end
						end
						if oldText ~= newText then
							item.text = newText
							variantReplacedCount = variantReplacedCount + 1
							replacedCount = replacedCount + 1
						end
					end
				end
				if variantReplacedCount > 0 then
					local fileWrite = io.open(filePath, 'w+b')
					if fileWrite then
						fileWrite:write(encodeJsonPretty(jsonData))
						fileWrite:close()
					end
				end
			end
		end
	end
	local bufferData = loadBufferFromFile()
	if bufferData and #bufferData > 0 then
		local bufferReplacedCount = 0
		for _, entry in ipairs(bufferData) do
			local oldText = entry.editedText or ""
			local newText = oldText
			if isRemovingTag then
				newText = oldText:gsub("^%[.-%]%s*", "")
				newText = newText:gsub("%[.-%]", "[]")
			else
				local firstBracketStart, firstBracketEnd = oldText:find("^%[.-%]")
				if firstBracketStart then
					local beforeFirst = oldText:sub(1, firstBracketStart - 1)
					local afterFirst = oldText:sub(firstBracketEnd + 1)
					afterFirst = afterFirst:gsub("%[.-%]", "[]")
					newText = beforeFirst .. "[" .. newTag .. "]" .. afterFirst
				else
					afterFirst = oldText:gsub("%[.-%]", "[]")
					newText = "[" .. newTag .. "] " .. afterFirst
				end
			end
			if oldText ~= newText then
				entry.editedText = newText
				bufferReplacedCount = bufferReplacedCount + 1
				replacedCount = replacedCount + 1
			end
		end
		if bufferReplacedCount > 0 then
			saveBufferToFile(bufferData)
		end
	end
	if replacedCount > 0 then
		if isRemovingTag then
			data.mainIni.config.wave_tag = ""
			AddNotification("[News Helper]", string.format('Префикс удален!\nВсего замен: %d', replacedCount), "success", 3.0)
		else
			data.mainIni.config.wave_tag = newTag
			AddNotification("[News Helper]", string.format('Префикс изменен на: %s\nВсего замен: %d', newTag, replacedCount), "success", 3.0)
		end
		saveConfig()
		loadHelpBinds()
		loadBuffer()
		clearSearchCache()
		return true
	else
		if isRemovingTag then
			AddNotification("[News Helper]", "Префиксы уже удалены", "warn", 3.0)
		else
			AddNotification("[News Helper]", "Теги уже совпадают с новым\nзначением", "warn", 4.0)
		end
		return false
	end
end
function generateAutoAnswer(efirType, question)
	if efirType == 'math' then
		local result, error = calculateMathExpression(question)
		return result or ''
	elseif efirType == 'zerkalo' then
		local function utf8reverse(s)
			local t = {}
			for uchar in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
				table.insert(t, 1, uchar)
			end
			return table.concat(t)
		end
		return utf8reverse(question)
	end
	return ''
end
function deepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepCopy(orig_key)] = deepCopy(orig_value)
		end
		setmetatable(copy, deepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end
function addToHistory()
	for i = editor.historyIndex + 1, #editor.history do
		editor.history[i] = nil
	end
	editor.historyIndex = editor.historyIndex + 1
	editor.history[editor.historyIndex] = deepCopy(data.newsHelpBind)
	if #editor.history > 50 then
		table.remove(editor.history, 1)
		editor.historyIndex = editor.historyIndex - 1
	end
	clearSearchCache()
end
function toggleAllCategories()
	editor.allExpanded = not editor.allExpanded
	for i = 1, #data.newsHelpBind do
		editor.categoryStates[i] = editor.allExpanded
	end
end
function canUndo() return editor.historyIndex > 1 end
function canRedo() return editor.historyIndex < #editor.history end
function undo()
	if canUndo() then
		editor.historyIndex = editor.historyIndex - 1
		data.newsHelpBind = deepCopy(editor.history[editor.historyIndex])
		clearSearchCache()
	else
		chatMessage(u8:decode('[News Helper] Нет действий для отмены'), 0xFF0000)
	end
end
function redo()
	if canRedo() then
		editor.historyIndex = editor.historyIndex + 1
		data.newsHelpBind = deepCopy(editor.history[editor.historyIndex])
	else
		chatMessage(u8:decode('[News Helper] Нет действий для возврата'), 0xFF0000)
	end
end
function resetEditorHistory()
	editor.history = {}
	editor.historyIndex = 0
	addToHistory()
end