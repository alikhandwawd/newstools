function renderPanelsTab(tabType)
	tabType = tabType or 'management'
	local item = settings.colors.itemButtons
	if tabType == 'management' then
		imgui.BeginChild('##playerActions', imgui.ImVec2(0, -50), true)
		if panels.rs and panels.rs.actions then
			for actionKey, action in pairs(panels.rs.actions) do
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
				if imgui.Button(action.name .. '##action' .. actionKey, imgui.ImVec2(-1, 30)) then
					if panels.playerMenu.targetId then
						executeAction('rs', actionKey, panels.playerMenu.targetId)
					end
				end
				imgui.PopStyleColor(3)
				imgui.Spacing()
			end
		end
		imgui.EndChild()
	elseif tabType == 'interview' then
		imgui.BeginChild('##sobesActions', imgui.ImVec2(0, -50), true)
		imgui.Text('Начало собеседования:')
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('Вы на собеседование?', imgui.ImVec2(-1, 30)) then
			if panels.playerMenu.targetId then
				executeAction('sobes', 'q1', panels.playerMenu.targetId)
			end
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('Спросить об увлечении', imgui.ImVec2(-1, 30)) then
			if panels.playerMenu.targetId then
				executeAction('sobes', 'q2', panels.playerMenu.targetId)
			end
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('Приступить к документам', imgui.ImVec2(-1, 30)) then
			if panels.playerMenu.targetId then
				executeAction('sobes', 'q3', panels.playerMenu.targetId)
			end
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Документы:')
		imgui.Spacing()
		local docButtonWidth = (imgui.GetWindowWidth() - 30) / 2
		local docActions = {
			{key = 'passport_ask', name = 'Попросить паспорт'},
			{key = 'passport_return', name = 'Отдать паспорт'},
			{key = 'medcard_ask', name = 'Попросить медкарту'},
			{key = 'medcard_return', name = 'Отдать медкарту'},
			{key = 'licenses_ask', name = 'Попросить лицензии'},
			{key = 'licenses_return', name = 'Отдать лицензии'},
			{key = 'workbook_ask', name = 'Попросить труд.книгу'},
			{key = 'workbook_return', name = 'Отдать труд.книгу'}
		}
		for i, action in ipairs(docActions) do
			if i % 2 == 0 then imgui.SameLine() end
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button(action.name, imgui.ImVec2(docButtonWidth, 30)) then
				if panels.playerMenu.targetId then
					executeAction('sobes', action.key, panels.playerMenu.targetId)
				end
			end
			imgui.PopStyleColor(3)
			if i % 2 == 0 then imgui.Spacing() end
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Завершение:')
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
		if imgui.Button('Принять', imgui.ImVec2(docButtonWidth, 35)) then
			if panels.playerMenu.targetId then
				executeAction('sobes', 'accept', panels.playerMenu.targetId)
			end
		end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
		if imgui.Button('Отказать', imgui.ImVec2(docButtonWidth, 35)) then
			if panels.playerMenu.targetId then
				executeAction('sobes', 'decline', panels.playerMenu.targetId)
			end
		end
		imgui.PopStyleColor(3)
		imgui.EndChild()
	elseif tabType == 'handbook' then
		imgui.BeginChild('##spravActions', imgui.ImVec2(0, -50), true)
		imgui.Text('Выберите категорию и создайте вопрос в основном окне')
		imgui.TextWrapped('(/newsss - Справочник)')
		imgui.EndChild()
	elseif tabType == 'custom' then
		imgui.BeginChild('##customActionsTab', imgui.ImVec2(0, -50), true)
		if not panels.custom.data or #panels.custom.data == 0 then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Нет созданных действий')
		else
			local docButtonWidth = (imgui.GetWindowWidth() - 30) / 2
			for i, action in ipairs(panels.custom.data) do
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button(action.name .. '##custom' .. i, imgui.ImVec2(docButtonWidth, 30)) then
					if panels.playerMenu.targetId then
						executeAction('custom', i, panels.playerMenu.targetId)
					end
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Выполнить это действие')
				end
			end
		end
		imgui.EndChild()
	end
end
function renderPanelsEditorTab(tabType)
	tabType = tabType or 'management'
	local item = settings.colors.itemButtons
	local keyName = getKeyName(panels.rs.settings.interactionKey)
	if tabType == 'management' then
		imgui.Text('Настройки отыгровок для команд')
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Клавиша взаимодействия:')
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if panels.rs.settings.isSettingKey then
			imgui.Button('Нажмите клавишу...##rskey', imgui.ImVec2(150, 25))
		else
			if imgui.Button(keyName .. '##rskey', imgui.ImVec2(150, 25)) then 
				panels.rs.settings.isSettingKey = true 
			end
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then 
			imgui.SetTooltip('ПКМ + эта клавиша при наведении на игрока') 
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Примечание: команды НЕ нужно добавлять в отыгровки!')
		imgui.TextWrapped('Команда выполнится автоматически после всех /me')
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.BeginChild('##rsActionsList', imgui.ImVec2(0, 0), true)
		if panels.rs and panels.rs.actions then
			for actionKey, action in pairs(panels.rs.actions) do
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
				if imgui.Button(action.name .. '##rs' .. actionKey, imgui.ImVec2(-1, 30)) then 
					panels.editor.type = 'rs'
					panels.editor.lines = {}
					if action.lines then
						for _, line in ipairs(action.lines) do
							table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
						end
					end
					ffi.copy(panels.editor.editingName, action.name)
					panels.editor.data = action
					panels.editor.open[0] = true
					windowState.editorOpenedFrom = 'main'
					panels.main[0] = false
				end
				imgui.PopStyleColor(3)
				imgui.Spacing()
			end
		end
		imgui.EndChild()
	elseif tabType == 'interview' then
		imgui.Text('Управление собеседованием')
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Клавиша взаимодействия:')
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if panels.rs.settings.isSettingKey then
			imgui.Button('Нажмите клавишу...##rskey2', imgui.ImVec2(150, 25))
		else
			if imgui.Button(keyName .. '##rskey2', imgui.ImVec2(150, 25)) then 
				panels.rs.settings.isSettingKey = true 
			end
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then 
			imgui.SetTooltip('ПКМ + эта клавиша при наведении на игрока') 
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
		imgui.Text('Начало:')
		imgui.Spacing()
		local startButtons = {
			{name = '1. Вы на собеседование?', key = 'q1'},
			{name = '2. Спросить об увлечении', key = 'q2'},
			{name = '3. Приступить к документам', key = 'q3'}
		}
		for _, btn in ipairs(startButtons) do
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button(btn.name, imgui.ImVec2(-1, 35)) then
				if panels.sobes and panels.sobes.actions and panels.sobes.actions.start then
					local sobesAction = panels.sobes.actions.start[btn.key]
					if sobesAction then
						panels.editor.type = 'sobes'
						panels.editor.lines = {}
						if sobesAction.lines then
							for _, line in ipairs(sobesAction.lines) do
								table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
							end
						end
						ffi.copy(panels.editor.editingName, btn.name)
						panels.editor.data = sobesAction
						panels.editor.sobesSection = 'start'
						panels.editor.sobesKey = btn.key
						panels.editor.open[0] = true
						windowState.editorOpenedFrom = 'main'
						panels.main[0] = false
					end
				end
			end
			imgui.PopStyleColor(3)
			imgui.Spacing()
		end
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Документы:')
		imgui.Spacing()
		local docActions = {
			{key = 'passport_ask', name = 'Попросить паспорт'},
			{key = 'passport_return', name = 'Отдать паспорт'},
			{key = 'medcard_ask', name = 'Попросить медкарту'},
			{key = 'medcard_return', name = 'Отдать медкарту'},
			{key = 'licenses_ask', name = 'Попросить лицензии'},
			{key = 'licenses_return', name = 'Отдать лицензии'},
			{key = 'workbook_ask', name = 'Попросить труд.книгу'},
			{key = 'workbook_return', name = 'Отдать труд.книгу'}
		}
		for i, action in ipairs(docActions) do
			if i % 2 == 0 then imgui.SameLine() end
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button(action.name, imgui.ImVec2(buttonWidth, 35)) then
				if panels.sobes and panels.sobes.actions and panels.sobes.actions.documents then
					local sobesAction = panels.sobes.actions.documents[action.key]
					if sobesAction then
						panels.editor.type = 'sobes'
						panels.editor.lines = {}
						if sobesAction.lines then
							for _, line in ipairs(sobesAction.lines) do
								table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
							end
						end
						ffi.copy(panels.editor.editingName, action.name)
						panels.editor.data = sobesAction
						panels.editor.sobesSection = 'documents'
						panels.editor.sobesKey = action.key
						panels.editor.open[0] = true
						windowState.editorOpenedFrom = 'main'
						panels.main[0] = false
					end
				end
			end
			imgui.PopStyleColor(3)
			if i % 2 == 0 then imgui.Spacing() end
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Завершение:')
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
		if imgui.Button('Редактировать "Принять"', imgui.ImVec2(buttonWidth, 35)) then
			if panels.sobes and panels.sobes.actions and panels.sobes.actions.finish then
				local sobesAction = panels.sobes.actions.finish.accept
				if sobesAction then
					panels.editor.type = 'sobes'
					panels.editor.lines = {}
					if sobesAction.lines then
						for _, line in ipairs(sobesAction.lines) do
							table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
						end
					end
					ffi.copy(panels.editor.editingName, 'Принять')
					panels.editor.data = sobesAction
					panels.editor.sobesSection = 'finish'
					panels.editor.sobesKey = 'accept'
					panels.editor.open[0] = true
					windowState.editorOpenedFrom = 'main'
					panels.main[0] = false
				end
			end
		end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
		if imgui.Button('Редактировать "Отказать"', imgui.ImVec2(buttonWidth, 35)) then
			if panels.sobes and panels.sobes.actions and panels.sobes.actions.finish then
				local sobesAction = panels.sobes.actions.finish.decline
				if sobesAction then
					panels.editor.type = 'sobes'
					panels.editor.lines = {}
					if sobesAction.lines then
						for _, line in ipairs(sobesAction.lines) do
							table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
						end
					end
					ffi.copy(panels.editor.editingName, 'Отказать')
					panels.editor.data = sobesAction
					panels.editor.sobesSection = 'finish'
					panels.editor.sobesKey = 'decline'
					panels.editor.open[0] = true
					windowState.editorOpenedFrom = 'main'
					panels.main[0] = false
				end
			end
		end
		imgui.PopStyleColor(3)
	elseif tabType == 'handbook' then
		imgui.Text('Справочная информация')
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Клавиша взаимодействия:')
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if panels.rs.settings.isSettingKey then
			imgui.Button('Нажмите клавишу...##rskey3', imgui.ImVec2(150, 25))
		else
			if imgui.Button(keyName .. '##rskey3', imgui.ImVec2(150, 25)) then 
				panels.rs.settings.isSettingKey = true 
			end
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then 
			imgui.SetTooltip('ПКМ + эта клавиша при наведении на игрока') 
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		local currentThemeColors = settings.themes.list.custom.colors
		if not currentThemeColors or not next(currentThemeColors) then 
			currentThemeColors = settings.themes.list.default.colors 
		end
		local tabColor = currentThemeColors["Tab"] or {0.18, 0.35, 0.58, 0.86}
		local tabActiveColor = {math.min(tabColor[1]*1.3, 1), math.min(tabColor[2]*1.3, 1), math.min(tabColor[3]*1.3, 1), tabColor[4]}
		local tabHoveredColor = {math.min(tabColor[1]*1.15, 1), math.min(tabColor[2]*1.15, 1), math.min(tabColor[3]*1.15, 1), tabColor[4]}
		imgui.PushStyleColor(imgui.Col.Tab, imgui.ImVec4(tabColor[1], tabColor[2], tabColor[3], tabColor[4]))
		imgui.PushStyleColor(imgui.Col.TabActive, imgui.ImVec4(tabActiveColor[1], tabActiveColor[2], tabActiveColor[3], tabActiveColor[4]))
		imgui.PushStyleColor(imgui.Col.TabHovered, imgui.ImVec4(tabHoveredColor[1], tabHoveredColor[2], tabHoveredColor[3], tabHoveredColor[4]))
		if imgui.BeginTabBar('##SpravSubTabs') then
			local spravTabs = {'ППЭТ', 'Устав', 'ПРО', 'ППС', 'НТСМ'}
			local spravKeys = {'ppet', 'ustav', 'sprav', 'pps', 'ntsm'}
			for idx, tabName in ipairs(spravTabs) do
				if imgui.BeginTabItem(tabName) then
					panels.sprav.currentTab = idx - 1
					local category = spravKeys[idx]
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(fa('plus') .. ' Добавить вопрос', imgui.ImVec2(-1, 30)) then
						if fa_font then imgui.PopFont() end
						if panels.sprav and panels.sprav.data and panels.sprav.data[category] then
							table.insert(panels.sprav.data[category], {name = 'Вопрос ' .. (#panels.sprav.data[category] + 1), lines = {}})
							saveAllNewsButtonsData()
						end
					else
						if fa_font then imgui.PopFont() end
					end
					imgui.PopStyleColor(3)
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.BeginChild('##SpravItems', imgui.ImVec2(0, 0), true)
					local toDelete = nil
					if panels.sprav and panels.sprav.data and panels.sprav.data[category] then
						for i, item_data in ipairs(panels.sprav.data[category]) do
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
							if imgui.Button(item_data.name .. '##spravitem' .. i, imgui.ImVec2(-35, 30)) then
								panels.editor.type = 'sprav'
								panels.editor.lines = {}
								if item_data.lines then
									for _, line in ipairs(item_data.lines) do
										table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
									end
								end
								ffi.copy(panels.editor.editingName, item_data.name)
								panels.editor.data = item_data
								panels.editor.editingIndex = i
								panels.sprav.editingCategory = category
								panels.sprav.editingItemIndex = i
								panels.editor.open[0] = true
								windowState.editorOpenedFrom = 'main'
								panels.main[0] = false
							end
							imgui.PopStyleColor(3)
							imgui.SameLine()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
							if imgui.Button('X##delsprav' .. i, imgui.ImVec2(30, 30)) then 
								toDelete = i 
							end
							imgui.PopStyleColor(3)
							imgui.Spacing()
						end
					end
					if toDelete then
						table.remove(panels.sprav.data[category], toDelete)
						saveAllNewsButtonsData()
					end
					imgui.EndChild()
					imgui.EndTabItem()
				end
			end
			imgui.EndTabBar()
		end
		imgui.PopStyleColor(3)
	elseif tabType == 'custom' then
		imgui.Text('Пользовательские действия')
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Клавиша взаимодействия:')
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if panels.rs.settings.isSettingKey then
			imgui.Button('Нажмите клавишу...##rskey4', imgui.ImVec2(150, 25))
		else
			if imgui.Button(keyName .. '##rskey4', imgui.ImVec2(150, 25)) then 
				panels.rs.settings.isSettingKey = true 
			end
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then 
			imgui.SetTooltip('ПКМ + эта клавиша при наведении на игрока') 
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
		if fa_font then imgui.PushFont(fa_font) end
		local buttonText = (fa_font and fa('plus') or '+') .. ' Добавить действие##customAdd'
		if imgui.Button(buttonText, imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			panels.input.type = 'new_custom_action'
			panels.input.title = 'Введите название действия:'
			ffi.fill(panels.input.inputText, 256)
			panels.input.onConfirm = function()
				local name = ffi.string(panels.input.inputText)
				if name ~= "" then
					if not panels.custom.data then panels.custom.data = {} end
					table.insert(panels.custom.data, {name = name, lines = {}})
					saveAllNewsButtonsData()
				end
			end
			panels.input.open[0] = true
		else
			if fa_font then imgui.PopFont() end
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.BeginChild('##customActionsList', imgui.ImVec2(0, 0), true)
		local toDelete = nil
		if panels.custom and panels.custom.data then
			for i, action in ipairs(panels.custom.data) do
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
				if imgui.Button(action.name .. '##custom' .. i, imgui.ImVec2(-35, 30)) then
					panels.editor.type = 'custom'
					panels.editor.lines = {}
					if action.lines then
						for _, line in ipairs(action.lines) do
							table.insert(panels.editor.lines, {text = imgui.new.char[512](line)})
						end
					end
					ffi.copy(panels.editor.editingName, action.name)
					panels.editor.data = action
					panels.custom.editingActionIndex = i
					panels.editor.open[0] = true
					windowState.editorOpenedFrom = 'main'
					panels.main[0] = false
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
				if imgui.Button('X##delCustom' .. i, imgui.ImVec2(30, 30)) then 
					toDelete = i 
				end
				imgui.PopStyleColor(3)
				imgui.Spacing()
			end
		end
		if toDelete then
			table.remove(panels.custom.data, toDelete)
			saveAllNewsButtonsData()
		end
		imgui.EndChild()
	end
end
function renderCommandRPWindow()
	local item = settings.colors.itemButtons
	imgui.Text('Команды с отыгровками:')
	imgui.Separator()
	imgui.Spacing()
	imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Совет: ПКМ по кнопке команды для включения/отключения')
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('plus') .. ' Добавить команду', imgui.ImVec2(-1, 30)) then
		commandRPSystem.newCmdWindow[0] = true
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.BeginChild('##commandRPList', imgui.ImVec2(0, 0), true)
	local toDelete = nil
	if not commandRPSystem.data or #commandRPSystem.data == 0 then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Команд не добавлено')
	else
		for i, cmd in ipairs(commandRPSystem.data) do
			if cmd and cmd.command then
				imgui.PushIDInt(i)
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				local cmdDisplay = "/" .. cmd.command
				if imgui.Button(cmdDisplay .. '##cmd' .. i, imgui.ImVec2(-45, 30)) then
					commandRPSystem.editingCmdIndex = i
					commandRPSystem.editorLines = {}
					commandRPSystem.globalDelay = cmd.delay or 2000
					ffi.fill(commandRPSystem.editingCmdName, 64)
					if cmd.command then
						ffi.copy(commandRPSystem.editingCmdName, cmd.command)
					end
					for _, line in ipairs(cmd.lines or {}) do
						table.insert(commandRPSystem.editorLines, {text = imgui.new.char[512](line)})
					end
					commandRPSystem.editWindow[0] = true
				end
				if imgui.IsItemClicked(1) then
					cmd.enabled = not cmd.enabled
					saveAllNewsButtonsData()
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					local lineCount = cmd.lines and #cmd.lines or 0
					imgui.Text('Строк: ' .. lineCount)
					if fa_font then imgui.PushFont(fa_font) end
					if cmd.enabled then
						imgui.Text(fa('circle_check') .. ' Включена')
					else
						imgui.Text(fa('circle_xmark') .. ' Отключена')
					end
					if fa_font then imgui.PopFont() end
					imgui.EndTooltip()
				end
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('trash_can') .. '##del' .. i, imgui.ImVec2(30, 30)) then
					toDelete = i
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(3)
				imgui.PopID()
				imgui.Spacing()
			end
		end
	end
	if toDelete then
		table.remove(commandRPSystem.data, toDelete)
		saveAllNewsButtonsData()
	end
	imgui.EndChild()
end
function renderBinderLinesMode(inputBg, inputBgHover, inputBgActive, item)
	local contentHeight = imgui.GetWindowHeight() - 280
	imgui.BeginChild('##BinderLines', imgui.ImVec2(0, contentHeight), false)
	if not binderEdit.lines or #binderEdit.lines == 0 then
		binderEdit.lines = {{text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0])}}
	end
	local anyPopupOpen = false
	if binder.sendModeOpen then
		for _, isOpen in pairs(binder.sendModeOpen) do
			if isOpen then
				anyPopupOpen = true
				break
			end
		end
	end
	if anyPopupOpen and imgui.IsMouseDown(0) then
		flags.popupClickActive = true
	elseif not imgui.IsMouseDown(0) then
		flags.popupClickActive = false
	end
	local toDelete = nil
	local lineHeight = 30
	local lineSpacing = 5
	local mousePos = imgui.GetMousePos()
	local childPos = imgui.GetWindowPos()
	local scrollY = imgui.GetScrollY()
	local n = #binderEdit.lines
	local targetInsertIndex = nil
	local dragOffsetY = nil
	if flags.draggingLineIndex and flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
		local relativeMouseY = mousePos.y - childPos.y + scrollY
		targetInsertIndex = 1
		local accumulatedHeight = 0
		for i = 1, n do
			local currentLineCenter = accumulatedHeight + (lineHeight / 2)
			if relativeMouseY > currentLineCenter then
				targetInsertIndex = i + 1
			end
			accumulatedHeight = accumulatedHeight + lineHeight + lineSpacing
		end
		targetInsertIndex = math.max(1, math.min(targetInsertIndex, n + 1))
	end
	for i = 1, n do
		local line = binderEdit.lines[i]
		if not line then
			binderEdit.lines[i] = { text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0]) }
			line = binderEdit.lines[i]
		end
		local skipLine = (flags.draggingLineIndex == i)
		if flags.draggingLineIndex and targetInsertIndex == i and targetInsertIndex ~= flags.draggingLineIndex then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
			imgui.Button('← Вставить сюда →##dropzone' .. i, imgui.ImVec2(-1, 20))
			imgui.PopStyleColor()
			imgui.Spacing()
		end
		if not skipLine then
			imgui.PushIDInt(i)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			local dragText = '↕'
			if fa_font then
				imgui.PushFont(fa_font)
				dragText = fa.ICON_FA_ARROWS_ALT_V or '↕'
			end
			if imgui.Button(dragText .. '##drag' .. i, imgui.ImVec2(25, 20)) then
			end
			if fa_font then imgui.PopFont() end
			if imgui.IsItemActive() and imgui.IsMouseDragging(0) then
				if not flags.draggingLineIndex then
					flags.draggingLineIndex = i
					local lineY = childPos.y - scrollY
					local accHeight = 0
					for j = 1, i - 1 do
						accHeight = accHeight + lineHeight + lineSpacing
					end
					lineY = lineY + accHeight
					dragOffsetY = mousePos.y - lineY
					dragOffsetY = math.max(0, math.min(dragOffsetY, lineHeight))
				end
			end
			imgui.PopStyleColor(3)
			imgui.SameLine(0, 1)
			imgui.PushItemWidth(-163.5)
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			if flags.focusLineIndex == i then
				imgui.SetKeyboardFocusHere()
				flags.focusLineIndex = nil
			end
			local enterPressed = false
			if not anyPopupOpen then
				enterPressed = imgui.InputText('##text' .. i, line.text, ffi.sizeof(line.text), imgui.InputTextFlags.EnterReturnsTrue)
			else
				imgui.InputText('##text' .. i, line.text, ffi.sizeof(line.text), 0)
			end
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			if enterPressed and not anyPopupOpen and not flags.popupClickActive then
				table.insert(binderEdit.lines, i + 1, { text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0]) })
				flags.focusLineIndex = i + 1
				flags.needScrollToBottom = true
			end
			imgui.SameLine(0, 2)
			imgui.PushItemWidth(35)
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			if not line.delay then
				line.delay = imgui.new.int(binderEdit.delay[0])
			end
			if imgui.InputInt('##delay' .. i, line.delay, 0, 0) then
				if line.delay[0] < 0 then line.delay[0] = 0 end
				if line.delay[0] > 100000 then line.delay[0] = 100000 end
			end
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			imgui.SameLine(0, 2)
			imgui.Text('мс')
			imgui.SameLine(0, 2)
			local sendModeLabel = 'Отправить'
			if binder.lineSendMode == nil then binder.lineSendMode = {} end
			if binder.lineSendMode[i] == 'chat' then
				sendModeLabel = 'В чат'
			elseif binder.lineSendMode[i] == 'chat_close' then
				sendModeLabel = 'Чат+Закр'
			elseif binder.lineSendMode[i] == 'dialog' then
				sendModeLabel = 'В диалог'
			end
			if binder.sendModeOpen == nil then binder.sendModeOpen = {} end
			local isOpen = binder.sendModeOpen[i] or false
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			local buttonWidth = 85
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(sendModeLabel .. ' ' .. fa('chevron_down') .. '##sendmode' .. i, imgui.ImVec2(buttonWidth, 20)) then
				imgui.OpenPopup('SendModePopup##' .. i)
			end
			if fa_font then imgui.PopFont() end
			if imgui.BeginPopup('SendModePopup##' .. i, imgui.WindowFlags.AlwaysAutoResize) then
				if imgui.Selectable('Отправить', binder.lineSendMode[i] == nil or binder.lineSendMode[i] == 'send') then
					binder.lineSendMode[i] = 'send'
					imgui.CloseCurrentPopup()
				end
				if imgui.Selectable('В чат', binder.lineSendMode[i] == 'chat') then
					binder.lineSendMode[i] = 'chat'
					imgui.CloseCurrentPopup()
				end
				if imgui.Selectable('Чат+Закр', binder.lineSendMode[i] == 'chat_close') then
					binder.lineSendMode[i] = 'chat_close'
					imgui.CloseCurrentPopup()
				end
				if imgui.Selectable('В диалог', binder.lineSendMode[i] == 'dialog') then
					binder.lineSendMode[i] = 'dialog'
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			imgui.PopStyleColor(3)
			imgui.SameLine(0, 2)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('trash_can') .. '##del' .. i, imgui.ImVec2(20, 20)) then
				if fa_font then imgui.PopFont() end
				if n > 1 and not anyPopupOpen and not flags.popupClickActive then toDelete = i end
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.PopID()
		else
			imgui.Dummy(imgui.ImVec2(0, lineHeight))
		end
		imgui.Spacing()
	end
	if flags.draggingLineIndex and targetInsertIndex == n + 1 then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
		imgui.Button('← Вставить в конец →##dropzoneend', imgui.ImVec2(-1, 20))
		imgui.PopStyleColor()
	end
	if flags.draggingLineIndex then
		local windowHeight = imgui.GetWindowHeight()
		local relativeMouseY = mousePos.y - childPos.y
		local scrollZone = 40
		local scrollSpeed = 5
		local scrollMultiplier = 1
		if relativeMouseY < scrollZone and imgui.GetScrollY() > 0 then
			scrollMultiplier = 1 - (relativeMouseY / scrollZone)
			local currentScroll = imgui.GetScrollY()
			local newScroll = math.max(0, currentScroll - (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
		end
		if relativeMouseY > windowHeight - scrollZone and imgui.GetScrollY() < imgui.GetScrollMaxY() then
			scrollMultiplier = (relativeMouseY - (windowHeight - scrollZone)) / scrollZone
			local currentScroll = imgui.GetScrollY()
			local maxScroll = imgui.GetScrollMaxY()
			local newScroll = math.min(maxScroll, currentScroll + (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
		end
	end
	if flags.draggingLineIndex and binderEdit.lines[flags.draggingLineIndex] then
		local drawList = imgui.GetWindowDrawList()
		local line = binderEdit.lines[flags.draggingLineIndex]
		local dragPosX = childPos.x + 10
		local dragPosY = mousePos.y - (dragOffsetY or (lineHeight / 2))
		local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
		if getColorU32 then
			drawList:AddRectFilled(
				imgui.ImVec2(dragPosX, dragPosY),
				imgui.ImVec2(dragPosX + imgui.GetWindowWidth() - 30, dragPosY + lineHeight),
				getColorU32(imgui.ImVec4(inputBg.x, inputBg.y, inputBg.z, 0.97)),
				5
			)
			local text = ""
			if line and line.text then
				local success, result = pcall(ffi.string, line.text)
				if success then
					text = result
				end
			end
			if text == "" then text = "[Пустая строка]" end
			if #text > 50 then text = text:sub(1, 47) .. "..." end
			drawList:AddText(
				imgui.ImVec2(dragPosX + 30, dragPosY + 5),
				getColorU32(imgui.ImVec4(1, 1, 1, 1)),
				text
			)
		end
	end
	if flags.draggingLineIndex and not imgui.IsMouseDown(0) then
		if targetInsertIndex and targetInsertIndex ~= flags.draggingLineIndex and
			flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
			local movingLine = table.remove(binderEdit.lines, flags.draggingLineIndex)
			if movingLine then
				local insertPos = targetInsertIndex
				if insertPos > flags.draggingLineIndex then
					insertPos = insertPos - 1
				end
				insertPos = math.max(1, math.min(insertPos, #binderEdit.lines + 1))
				table.insert(binderEdit.lines, insertPos, movingLine)
			end
		end
		flags.draggingLineIndex = nil
		dragOffsetY = nil
	end
	if not flags.draggingLineIndex then
		imgui.Dummy(imgui.ImVec2(25, 20))
		imgui.SameLine()
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.5))
		local buttonWidth = imgui.GetContentRegionAvail().x - 30
		local buttonText = 'Нажмите Enter ' .. (fa_font and fa('arrow_turn_down_left') or '↵') .. ' или кликните мышью чтобы добавить строку.##addnewline'
		if anyPopupOpen or flags.popupClickActive then
			imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20))
		else
			if imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20)) then
				table.insert(binderEdit.lines, { text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0]) })
				flags.focusLineIndex = #binderEdit.lines
				flags.needScrollToBottom = true
			end
		end
		imgui.PopStyleColor(4)
		imgui.SameLine()
		imgui.Dummy(imgui.ImVec2(25, 20))
	end
	if toDelete and toDelete > 0 and toDelete <= #binderEdit.lines then
		table.remove(binderEdit.lines, toDelete)
		if binder.lineSendMode then
			binder.lineSendMode[toDelete] = nil
		end
	end
	if flags.needScrollToBottom then
		imgui.SetScrollHereY(1.0)
		flags.needScrollToBottom = false
	end
	imgui.EndChild()
end
function renderBinderSquareMode(inputBg, inputBgHover, inputBgActive)
	local contentHeight = imgui.GetWindowHeight() - 280
	imgui.BeginChild('##BinderSquare', imgui.ImVec2(0, contentHeight), false)
	imgui.InputTextMultiline('##squaretext', binderEdit.squareText, 8192, imgui.ImVec2(-1, -1))
	imgui.EndChild()
end
function renderIntervalControl(efirType, label)
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	if not efir.intervals[efirType] then
		efir.intervals[efirType] = imgui.new.int(3000)
	end
	imgui.Text(label .. ':')
	imgui.SameLine()
	local intervalValue = efir.intervals[efirType][0]
	local digitCount = string.len(tostring(intervalValue))
	local inputWidth = math.max(60, digitCount * 10 + 20)
	imgui.PushItemWidth(inputWidth)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('-##Dec' .. efirType, imgui.ImVec2(20, 20)) then
		efir.intervals[efirType][0] = math.max(1000, efir.intervals[efirType][0] - 100)
		saveConfig()
	end
	imgui.SameLine()
	if imgui.InputInt('##Interval' .. efirType, efir.intervals[efirType], 0, 0) then
		if efir.intervals[efirType][0] < 1000 then efir.intervals[efirType][0] = 1000 end
		if efir.intervals[efirType][0] > 10000 then efir.intervals[efirType][0] = 10000 end
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('+##Inc' .. efirType, imgui.ImVec2(20, 20)) then
		efir.intervals[efirType][0] = math.min(10000, efir.intervals[efirType][0] + 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
end
function renderEfirMessageCategory(efirType, messageKeys, categoryName)
	local messages = efir.messages[efirType]
	local item = settings.colors.itemButtons
	local bg = settings.colors.background
	imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Как добавить новое сообщение:')
	imgui.TextWrapped('1. Нажмите "Добавить"')
	imgui.TextWrapped('2. Введите ключ (например: msg9, ball1.2, end6)')
	imgui.TextWrapped('3. Введите отображаемое имя и текст сообщения')
	imgui.TextWrapped('4. Нажмите "Добавить" в окне или Enter')
	imgui.TextWrapped('Все переменные были изменены, пожалуйста введите "/resetefir all" в чат для их сброса.')
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	if categoryName ~= "баллы" then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('circle_plus') .. ' Добавить новое##' .. categoryName, imgui.ImVec2(120, 25)) then
			if fa_font then imgui.PopFont() end
			imgui.OpenPopup('AddMessage##' .. categoryName)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
	end
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('arrow_rotate_right') .. ' Сбросить эфир##' .. categoryName, imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		if not efir.confirmResetEfir then
			efir.confirmResetEfir = true
			efir.confirmResetEfirTime = os.clock()
		else
			resetEfirMessagesToDefault(efir.selectedType)
			AddNotification("[News Helper]", "Эфир \"" .. efir.selectedType .. "\"\nсброшен!", "success", 3.0)
			efir.confirmResetEfir = false
		end
	else
		if fa_font then imgui.PopFont() end
	end
	if efir.confirmResetEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить##' .. categoryName, imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		saveEfirMessagesToFile()
		AddNotification("[News Helper]", "Эфир сохранен!", "success", 3.0)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine(670)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('trash_can') .. ' Сбросить все##resetAll' .. categoryName, imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		resetEfirMessagesToDefault('all')
		AddNotification("[News Helper]", "Все эфиры сброшены!", "success", 3.0)
	else
		if fa_font then imgui.PopFont() end
	end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.BeginChild('##Messages' .. categoryName, imgui.ImVec2(0, -1), false)
	for _, msgKey in ipairs(messageKeys) do
		if messages[msgKey] then
			local displayName = getEfirMessageDisplayName(msgKey, efirType)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.8, 1, 0.8, 1))
			imgui.Text(displayName .. ' [' .. msgKey .. ']:')
			imgui.PopStyleColor()
			imgui.PushItemWidth(-40)
			local msgSize = efir.messageSizes[msgKey] or 512
			local messageBuffer = messages[msgKey]
			if type(messageBuffer) == 'string' then
				messageBuffer = imgui.new.char[msgSize](messageBuffer)
				messages[msgKey] = messageBuffer
			end
			if not messageBuffer then
				messageBuffer = imgui.new.char[msgSize]()
				messages[msgKey] = messageBuffer
			end
			imgui.InputText('##' .. msgKey .. efirType, messageBuffer, msgSize)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('trash_can') .. '##del' .. msgKey .. efirType, imgui.ImVec2(25, 20)) then
				if fa_font then imgui.PopFont() end
				messages[msgKey] = nil
				if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
					efir.messageDisplayNames[efirType][msgKey] = nil
				end
				saveConfig()
				tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.Spacing()
		end
	end
	imgui.EndChild()
	imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(bg[0], bg[1], bg[2], bg[3] or 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0] * 1.1, item[1] * 1.1, item[2] * 1.1, 1))
	if imgui.BeginPopupModal('AddMessage##' .. categoryName, nil, imgui.WindowFlags.AlwaysAutoResize) then
		if not helpers.newMessageKey then
			helpers.newMessageKey = imgui.new.char[64]()
			helpers.newMessageText = imgui.new.char[512]()
			helpers.newMessageDisplayName = imgui.new.char[128]()
		end
		if imgui.IsKeyPressed(imgui.Key.Escape) then
			imgui.CloseCurrentPopup()
			helpers.newMessageKey = nil
			helpers.newMessageText = nil
			helpers.newMessageDisplayName = nil
		end
		imgui.Text('Добавить новое сообщение:')
		imgui.Separator()
		local suggestedKey = ""
		if categoryName == "начать" then
			local maxMsgNum = 0
			for msgKey, _ in pairs(messages) do
				local num = msgKey:match("^msg(%d+)$")
				if num then
					maxMsgNum = math.max(maxMsgNum, tonumber(num))
				end
			end
			suggestedKey = "msg" .. (maxMsgNum + 1)
		elseif categoryName == "завершить" then
			local maxEndNum = 0
			for msgKey, _ in pairs(messages) do
				local num = msgKey:match("^end(%d+)$")
				if num then
					maxEndNum = math.max(maxEndNum, tonumber(num))
				end
			end
			suggestedKey = "end" .. (maxEndNum + 1)
		elseif categoryName == "стоп" then
			local maxStopNum = 0
			for msgKey, _ in pairs(messages) do
				local num = msgKey:match("^stop(%d+)$")
				if num then
					maxStopNum = math.max(maxStopNum, tonumber(num))
				end
			end
			suggestedKey = "stop" .. (maxStopNum + 1)
		else
			suggestedKey = "ball1.2"
		end
		imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Примеры ключей:')
		if categoryName == "начать" then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'msg9, msg10 (для основных сообщений)')
		elseif categoryName == "завершить" then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'end6, end7 (для завершающих)')
		else
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'ball1.2, winner4 (для вариаций)')
		end
		imgui.TextColored(imgui.ImVec4(0.5, 1, 0.5, 1), 'Следующий ключ: ' .. suggestedKey)
		imgui.Spacing()
		imgui.Text('Ключ сообщения:')
		imgui.PushItemWidth(200)
		local keyEnterPressed = imgui.InputText('##NewMsgKey', helpers.newMessageKey, 64, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		imgui.Spacing()
		imgui.Text('Отображаемое имя:')
		imgui.PushItemWidth(400)
		local nameEnterPressed = imgui.InputText('##NewMsgDisplayName', helpers.newMessageDisplayName, 128, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		if imgui.IsItemHovered() then
			imgui.SetTooltip('Как будет отображаться это сообщение в списке')
		end
		imgui.Spacing()
		imgui.Text('Текст сообщения:')
		imgui.InputTextMultiline('##NewMsgText', helpers.newMessageText, 512, imgui.ImVec2(400, 100))
		imgui.Separator()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отмена (ESC)', imgui.ImVec2(120, 30)) then
			if fa_font then imgui.PopFont() end
			imgui.CloseCurrentPopup()
			helpers.newMessageKey = nil
			helpers.newMessageText = nil
			helpers.newMessageDisplayName = nil
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		local shouldAdd = imgui.Button('Добавить Enter ' .. fa('arrow_turn_down_left'), imgui.ImVec2(120, 30))
		if shouldAdd then
			local key = ffi.string(helpers.newMessageKey)
			local text = ffi.string(helpers.newMessageText)
			local displayName = ffi.string(helpers.newMessageDisplayName)
			if key ~= '' and text ~= '' then
				local size = efir.messageSizes[key] or 512
				messages[key] = imgui.new.char[size](text)
				if displayName ~= '' then
					if not efir.messageDisplayNames then
						efir.messageDisplayNames = {}
					end
					if not efir.messageDisplayNames[efirType] then
						efir.messageDisplayNames[efirType] = {}
					end
					efir.messageDisplayNames[efirType][key] = displayName
				end
				saveConfig()
				tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
				SilentNotification("[News Helper]", "Сообщение добавлено!", "success", 1.5)
				imgui.CloseCurrentPopup()
				helpers.newMessageKey = nil
				helpers.newMessageText = nil
				helpers.newMessageDisplayName = nil
			else
				AddNotification("[News Helper]", "Заполните обязательные поля\n(ключ и текст)!", "warn", 3.0)
			end
		end
		imgui.PopStyleColor(3)
		imgui.EndPopup()
	end
	imgui.PopStyleColor(3)
end
function renderEfirMessagesEditor()
	imgui.Text('Редактирование сообщений для эфиров:')
	imgui.Separator()
	imgui.Spacing()
	renderVariablesButton()
	imgui.Spacing()
	imgui.Text('Выберите тип эфира для редактирования:')
	local efirTypes = {
		{key = 'math', name = 'Математика', desc = 'Эфир с математическими примерами'},
		{key = 'country', name = 'Столицы', desc = 'Эфир про столицы стран'},
		{key = 'himia', name = 'Химия', desc = 'Эфир по химии'},
		{key = 'zerkalo', name = 'Зеркало', desc = 'Перевернутые слова'},
		{key = 'annagramm', name = 'Анаграммы', desc = 'Составление слов из букв'},
		{key = 'zagadki', name = 'Загадки', desc = 'Эфир с загадками'},
		{key = 'sinonim', name = 'Синонимы', desc = 'Подбор синонимов'},
		{key = 'inter', name = 'Интервью', desc = 'Интервью с гостем'},
		{key = 'reklama', name = 'Реклама', desc = 'Рекламная пауза'},
		{key = 'sobes', name = 'Собеседование', desc = 'Объявление о собеседовании'}
	}
	local item = settings.colors.itemButtons
	local windowWidth = imgui.GetWindowWidth() - 17
	local buttonWidth = (windowWidth - 40) / 5
	local buttonHeight = 35
	local spacing = 10
	for i, efirType in ipairs(efirTypes) do
		local col = (i - 1) % 5
		if col > 0 then imgui.SameLine(0, spacing) end
		local isSelected = efir.selectedType == efirType.key
		if isSelected then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(math.min(item[0] * 1.5, 1), math.min(item[1] * 1.5, 1), math.min(item[2] * 1.5, 1), item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0] * 1.7, 1), math.min(item[1] * 1.7, 1), math.min(item[2] * 1.7, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0] * 1.9, 1), math.min(item[1] * 1.9, 1), math.min(item[2] * 1.9, 1), item[3]*1.4))
		else
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0] * 1.2, 1), math.min(item[1] * 1.2, 1), math.min(item[2] * 1.2, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0] * 1.4, 1), math.min(item[1] * 1.4, 1), math.min(item[2] * 1.4, 1), item[3]*1.4))
		end
		if imgui.Button(efirType.name .. '##' .. efirType.key, imgui.ImVec2(buttonWidth, buttonHeight)) then
			efir.selectedType = efirType.key
			efir.currentSubTab = 1
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then 
			imgui.SetTooltip(efirType.desc) 
		end
		if i % 5 == 0 then 
			imgui.Spacing() 
		end
	end
	imgui.Separator()
	imgui.Spacing()
	if efir.messages[efir.selectedType] then
		imgui.Text('Сообщения для эфира: ' .. efir.selectedType)
		local currentThemeColors = settings.themes.list.custom.colors
		if not currentThemeColors or not next(currentThemeColors) then
			currentThemeColors = settings.themes.list.default.colors
		end
		local tabColor=currentThemeColors["Tab"] or {0.18,0.35,0.58,0.86}
		local tabActiveColor={math.min(tabColor[1]*1.3,1),math.min(tabColor[2]*1.3,1),math.min(tabColor[3]*1.3,1),tabColor[4]}
		local tabHoveredColor={math.min(tabColor[1]*1.15,1),math.min(tabColor[2]*1.15,1),math.min(tabColor[3]*1.15,1),tabColor[4]}
		imgui.PushStyleColor(imgui.Col.Tab, imgui.ImVec4(tabColor[1], tabColor[2], tabColor[3], tabColor[4]))
		imgui.PushStyleColor(imgui.Col.TabActive, imgui.ImVec4(tabActiveColor[1], tabActiveColor[2], tabActiveColor[3], tabActiveColor[4]))
		imgui.PushStyleColor(imgui.Col.TabHovered, imgui.ImVec4(tabHoveredColor[1], tabHoveredColor[2], tabHoveredColor[3], tabHoveredColor[4]))
		if imgui.BeginTabBar('##EfirSubTabs') then
			tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
			local order = getEfirMessageOrder(efir.selectedType)
			if imgui.BeginTabItem('Начать эфир') then
				efir.currentSubTab = 1
				renderEfirMessageCategory(efir.selectedType, order.start, "начать")
				imgui.EndTabItem()
			end
			if efir.selectedType ~= 'sobes' and #order.additional > 0 then
				if imgui.BeginTabItem('Баллы и награды') then
					efir.currentSubTab = 2
					renderEfirMessageCategory(efir.selectedType, order.additional, "баллы")
					imgui.EndTabItem()
				end
			end
			if imgui.BeginTabItem('Завершить эфир') then
				efir.currentSubTab = 3
				local endOnlyMessages = {}
				for _, key in ipairs(order.end_messages) do
					if not key:match("^stop%d+$") then
						table.insert(endOnlyMessages, key)
					end
				end
				renderEfirMessageCategory(efir.selectedType, endOnlyMessages, "завершить")
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem('Напоминания') then
				efir.currentSubTab = 4
				renderRemindersTab(efir.selectedType)
				imgui.EndTabItem()
			end
			imgui.EndTabBar()
		end
		imgui.PopStyleColor(3)
	else
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Выберите тип эфира для редактирования')
	end
end
function renderFreeEfirVariablesButton()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('code') .. ' Переменные', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		helpers.showVariablesHelp[0] = not helpers.showVariablesHelp[0]
	end
	imgui.PopStyleColor(3)
	if helpers.showVariablesHelp[0] then
		imgui.SameLine()
		imgui.BeginChild('##VariablesHelpFreeEfir', imgui.ImVec2(400, 80), true)
		imgui.Text('Доступные переменные:')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '<mynick> - Ник ведущего')
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '<myrang> - Ранг ведущего')
		imgui.EndChild()
	end
end
function renderSquareMode()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.Text('Введите текст (каждая строка будет отправлена отдельно):')
	local textAreaHeight = imgui.GetWindowHeight() - 120
	imgui.InputTextMultiline('##SquareTextInput', efir.custom.squareText, 
		ffi.sizeof(efir.custom.squareText), 
		imgui.ImVec2(-1, textAreaHeight))
end
function renderFreeEfirTab()
	imgui.Text('Пользовательские эфиры')
	imgui.Separator()
	imgui.Spacing()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.15, 0.6, 0.15, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.2, 0.7, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('circle_plus') .. ' Добавить эфир', imgui.ImVec2(140, 25)) then
	if fa_font then imgui.PopFont() end
		imgui.OpenPopup('AddCustomEfir')
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.Text('Пауза/возобновление:')
	imgui.SameLine()
	local buttonText = getHotkeyString(efir.control.pauseHotkey)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.15, 0.6, 0.15, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.2, 0.7, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.1, 1))
	if imgui.Button(buttonText .. '##pausekey', imgui.ImVec2(120, 25)) then
		data.currentMainSettingsTab = 4
	end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Клавиша для паузы/возобновления эфира')
		imgui.Text('Чтобы поменять перейдите в вкладку Горячие клавиши')
		imgui.EndTooltip()
	end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Text('Интервал отправки (мс):')
	imgui.SameLine()
	if not efir.auto.active then
		local intervalValue = efir.custom.sendInterval[0]
		local digitCount = string.len(tostring(intervalValue))
		local inputWidth = math.max(60, digitCount * 10 + 20)
		imgui.PushItemWidth(inputWidth)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if imgui.Button('-##DecInterval', imgui.ImVec2(20, 20)) then
			efir.custom.sendInterval[0] = math.max(100, efir.custom.sendInterval[0] - 100)
			saveConfig()
		end
		imgui.SameLine()
		if imgui.InputInt('##SendInterval', efir.custom.sendInterval, 0, 0) then
			if efir.custom.sendInterval[0] < 100 then
				efir.custom.sendInterval[0] = 100
			elseif efir.custom.sendInterval[0] > 10000 then
				efir.custom.sendInterval[0] = 10000
			end
			saveConfig()
		end
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if imgui.Button('+##IncInterval', imgui.ImVec2(20, 20)) then
			efir.custom.sendInterval[0] = math.min(10000, efir.custom.sendInterval[0] + 100)
			saveConfig()
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() or imgui.IsItemHovered(-1) then
			imgui.SetTooltip('Интервал между отправкой строк (100-10000 мс)')
		end
	else
		efir.custom.sendInterval[0] = 3000
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(Автоматический режим: 3000 мс)')
	end
	imgui.Spacing()
	if next(efir.custom.list) then
		imgui.Text('Ваши эфиры:')
		imgui.Separator()
		local buttonsPerRow = 4
		local buttonWidth = (imgui.GetWindowWidth() - 40 - (buttonsPerRow - 1) * 5) / buttonsPerRow
		local buttonCount = 0
		for key, efirData in pairs(efir.custom.list) do
			if buttonCount > 0 and buttonCount % buttonsPerRow ~= 0 then
				imgui.SameLine()
			end
			local isSelected = efir.custom.selected == key
			if isSelected then
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
			else
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0] * 1.2, 1), math.min(item[1] * 1.2, 1), math.min(item[2] * 1.2, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0] * 1.4, 1), math.min(item[1] * 1.4, 1), math.min(item[2] * 1.4, 1), item[3]*1.4))
			end
			if imgui.Button(efirData.name .. '##efir_' .. key, imgui.ImVec2(buttonWidth, 30)) then
				efir.custom.selected = key
				loadCustomEfirs(key)
			end
			if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0) then
				efir.custom.list[key] = nil
				if efir.custom.selected == key then
					efir.custom.selected = nil
					efir.custom.lines = {}
				end
				saveCustomEfirs()
				AddNotification("[News Helper]", "Эфир \"" .. efirData.name .. "\"\nудален!", "success", 3.0)
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Двойной клик для удаления')
			end
			imgui.PopStyleColor(3)
			buttonCount = buttonCount + 1
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		if efir.custom.selected and efir.custom.list[efir.custom.selected] then
			renderCustomEfirEditor()
		end
	else
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Нет созданных эфиров. Нажмите "Добавить эфир" для начала.')
	end
	renderAddCustomEfirPopup()
end
function renderCustomEfirEditor()
	local efirData = efir.custom.list[efir.custom.selected]
	if not efirData then return end
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.Text('Редактирование: ' .. efirData.name)
	imgui.Text('/startefir ' .. efir.custom.selected .. ' - для запуска эфира')
	imgui.Text('/stopefir ' .. efir.custom.selected .. ' - для завершения эфира')
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		if efir.custom.viewMode == 'square' then
			convertSquareToLines()
		elseif efir.custom.viewMode == 'bars' then
			convertLinesToSquare()
		end
		saveCustomEfirs()
		AddNotification("[News Helper]", "Эфир сохранен!", "success", 3.0)
		if fa_font then imgui.PushFont(fa_font) end
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.SetCursorPosX(imgui.GetWindowWidth() - 140)
	local viewModeIcon = efir.custom.viewMode == 'bars' and fa('square') or fa('bars')
	local viewModeTooltip = efir.custom.viewMode == 'bars' and 'Переключить на большое поле' or 'Переключить на строки'
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(viewModeIcon .. ' Режим вида', imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		if efir.custom.viewMode == 'bars' then
			convertLinesToSquare()
			efir.custom.viewMode = 'square'
		else
			convertSquareToLines()
			efir.custom.viewMode = 'bars'
		end
		if fa_font then imgui.PushFont(fa_font) end
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.SetTooltip(viewModeTooltip)
	end
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	if efir.custom.viewMode == 'square' then
		renderSquareMode()
		return
	end
	imgui.BeginChild('##CustomEfirLines', imgui.ImVec2(0, -1), false)
	if not efir.custom.lines or #efir.custom.lines == 0 then
		efir.custom.lines = {{ text = imgui.new.char[512]("") }}
	end
	local toDelete = nil
	local mousePos = imgui.GetMousePos()
	local childPos = imgui.GetWindowPos()
	local scrollY = imgui.GetScrollY()
	local lineHeight = 30
	local lineSpacing = 5
	local n = #efir.custom.lines
	local targetInsertIndex = nil
	if not flags.focusLineIndex then flags.focusLineIndex = nil end
	if flags.draggingLineIndex and flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
		local relativeMouseY = mousePos.y - childPos.y + scrollY
		targetInsertIndex = 1
		local accumulatedHeight = 0
		for i = 1, n do
			local currentLineCenter = accumulatedHeight + (lineHeight / 2)
			if relativeMouseY > currentLineCenter then
				targetInsertIndex = i + 1
			end
			accumulatedHeight = accumulatedHeight + lineHeight + lineSpacing
		end
		targetInsertIndex = math.max(1, math.min(targetInsertIndex, n + 1))
	end
	for i = 1, n do
		local line = efir.custom.lines[i]
		if not line then
			efir.custom.lines[i] = { text = imgui.new.char[512]("") }
			line = efir.custom.lines[i]
		end
		local skipLine = (flags.draggingLineIndex == i)
		if flags.draggingLineIndex and targetInsertIndex == i and targetInsertIndex ~= flags.draggingLineIndex then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
			imgui.Button('← Вставить сюда →##dropzone' .. i, imgui.ImVec2(-1, 20))
			imgui.PopStyleColor()
			imgui.Spacing()
		end
		if not skipLine then
			imgui.PushIDInt(i)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			local dragText = '↕'
			if fa_font then
				imgui.PushFont(fa_font)
				dragText = fa.ICON_FA_ARROWS_ALT_V or '↕'
			end
			if imgui.Button(dragText .. '##drag' .. i, imgui.ImVec2(25, 20)) then
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Нажмите и удерживайте для перемещения.')
			end
			if fa_font then imgui.PopFont() end
			if imgui.IsItemActive() and not imgui.IsItemHovered() then
				if not flags.draggingLineIndex then
					flags.draggingLineIndex = i
					local lineY = childPos.y - scrollY
					local accHeight = 0
					for j = 1, i - 1 do
						accHeight = accHeight + lineHeight + lineSpacing
					end
					lineY = lineY + accHeight
					dragOffsetY = mousePos.y - lineY
					dragOffsetY = math.max(0, math.min(dragOffsetY, lineHeight))
				end
			end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushItemWidth(-55)
			if flags.focusLineIndex == i then
				imgui.SetKeyboardFocusHere()
				flags.focusLineIndex = nil
			end
			local enterPressed = imgui.InputText('##text' .. i, line.text, ffi.sizeof(line.text), imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopItemWidth()
			if enterPressed then
				table.insert(efir.custom.lines, i + 1, { text = imgui.new.char[512]("") })
				tabWindowSizes[8].y = calculateFreeEfirTabHeight()
				saveCustomEfirs()
				flags.focusLineIndex = i + 1
				flags.needScrollToBottom = true
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('trash_can') .. '##del' .. i, imgui.ImVec2(25, 20)) then
				if fa_font then imgui.PopFont() end
				if n > 1 then toDelete = i end
			end
			imgui.PopStyleColor(3)
			imgui.PopID()
		else
			imgui.Dummy(imgui.ImVec2(0, lineHeight))
		end
		imgui.Spacing()
	end
	if flags.draggingLineIndex and targetInsertIndex == n + 1 then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
		imgui.Button('← Вставить в конец →##dropzoneend', imgui.ImVec2(-1, 20))
		imgui.PopStyleColor()
	end
	if flags.draggingLineIndex then
		local windowHeight = imgui.GetWindowHeight()
		local relativeMouseY = mousePos.y - childPos.y
		local scrollZone = 40
		local scrollSpeed = 5
		local scrollMultiplier = 1
		if relativeMouseY < scrollZone and imgui.GetScrollY() > 0 then
			scrollMultiplier = 1 - (relativeMouseY / scrollZone)
			local currentScroll = imgui.GetScrollY()
			local newScroll = math.max(0, currentScroll - (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
			local drawList = imgui.GetWindowDrawList()
			local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
			if getColorU32 then
				drawList:AddRectFilled(
					imgui.ImVec2(childPos.x, childPos.y),
					imgui.ImVec2(childPos.x + imgui.GetWindowWidth(), childPos.y + 3),
					getColorU32(imgui.ImVec4(0.3, 0.8, 0.3, 0.3 + scrollMultiplier * 0.4))
				)
			end
		end
		if relativeMouseY > windowHeight - scrollZone and imgui.GetScrollY() < imgui.GetScrollMaxY() then
			scrollMultiplier = (relativeMouseY - (windowHeight - scrollZone)) / scrollZone
			local currentScroll = imgui.GetScrollY()
			local maxScroll = imgui.GetScrollMaxY()
			local newScroll = math.min(maxScroll, currentScroll + (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
			local drawList = imgui.GetWindowDrawList()
			local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
			if getColorU32 then
				drawList:AddRectFilled(
					imgui.ImVec2(childPos.x, childPos.y + windowHeight - 3),
					imgui.ImVec2(childPos.x + imgui.GetWindowWidth(), childPos.y + windowHeight),
					getColorU32(imgui.ImVec4(0.3, 0.8, 0.3, 0.3 + scrollMultiplier * 0.4))
				)
			end
		end
	end
	if flags.draggingLineIndex and efir.custom.lines[flags.draggingLineIndex] then
		local drawList = imgui.GetWindowDrawList()
		local line = efir.custom.lines[flags.draggingLineIndex]
		local dragPosX = childPos.x + 10
		local dragPosY = mousePos.y - (dragOffsetY or (lineHeight / 2))
		local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
		if getColorU32 then
			drawList:AddRectFilled(
				imgui.ImVec2(dragPosX, dragPosY),
				imgui.ImVec2(dragPosX + imgui.GetWindowWidth() - 30, dragPosY + lineHeight),
				getColorU32(imgui.ImVec4(inputBgColor.x, inputBgColor.y, inputBgColor.z, 0.97)),
				5
			)
			local text = ""
			if line and line.text then
				local success, result = pcall(ffi.string, line.text)
				if success then
					text = result
				end
			end
			if text == "" then text = "[Пустая строка]" end
			if #text > 50 then text = text:sub(1, 47) .. "..." end
			drawList:AddText(
				imgui.ImVec2(dragPosX + 30, dragPosY + 5),
				getColorU32(imgui.ImVec4(1, 1, 1, 1)),
				text
			)
		end
	end
	if flags.draggingLineIndex and not imgui.IsMouseDown(0) then
		if targetInsertIndex and targetInsertIndex ~= flags.draggingLineIndex and
			flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
			local movingLine = table.remove(efir.custom.lines, flags.draggingLineIndex)
			if movingLine then
				local insertPos = targetInsertIndex
				if insertPos > flags.draggingLineIndex then
					insertPos = insertPos - 1
				end
				insertPos = math.max(1, math.min(insertPos, #efir.custom.lines + 1))
				table.insert(efir.custom.lines, insertPos, movingLine)
				saveCustomEfirs()
			end
		end
		flags.draggingLineIndex = nil
		dragOffsetY = nil
	end
	if not flags.draggingLineIndex then
		imgui.Dummy(imgui.ImVec2(25, 20))
		imgui.SameLine()
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.5))
		local buttonWidth = imgui.GetContentRegionAvail().x - 30
		local buttonText = 'Нажмите Enter ' .. fa('arrow_turn_down_left') .. ' или кликните мышью чтобы добавить строку.##addnewline'
		if imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20)) then
			table.insert(efir.custom.lines, { text = imgui.new.char[512]("") })
			saveCustomEfirs()
			flags.focusLineIndex = #efir.custom.lines
			flags.needScrollToBottom = true
		end
		imgui.PopStyleColor(4)
		imgui.SameLine()
		imgui.Dummy(imgui.ImVec2(25, 20))
	end
	if toDelete and toDelete > 0 and toDelete <= #efir.custom.lines then
		table.remove(efir.custom.lines, toDelete)
		tabWindowSizes[8].y = calculateFreeEfirTabHeight()
		saveCustomEfirs()
	end
	if flags.needScrollToBottom then
		imgui.SetScrollHereY(1.0)
		flags.needScrollToBottom = false
	end
	imgui.EndChild()
end
function renderAddCustomEfirPopup()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(bg[0], bg[1], bg[2], bg[3] or 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0] * 1.1, item[1] * 1.1, item[2] * 1.1, 1))
	if imgui.BeginPopupModal('AddCustomEfir', nil, imgui.WindowFlags.AlwaysAutoResize) then
		if not efir.custom.newName then
			efir.custom.newName = imgui.new.char[128]()
			efir.custom.newKey = imgui.new.char[64]()
		end
		if imgui.IsKeyPressed(imgui.Key.Escape) then
			imgui.CloseCurrentPopup()
			efir.custom.newName = nil
			efir.custom.newKey = nil
		end
		imgui.Text('Создание нового эфира:')
		imgui.Separator()
		imgui.Text('Название эфира:')
		imgui.PushItemWidth(300)
		local nameEnter = imgui.InputText('##EfirName', efir.custom.newName, 128, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		imgui.Text('Ключ (латиницей):')
		imgui.PushItemWidth(200)
		local keyEnter = imgui.InputText('##EfirKey', efir.custom.newKey, 64, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Например: math, interview, custom1')
		imgui.Separator()
		local winW = imgui.GetWindowWidth() or 400
		local buttonWidth = (winW - 50) / 2
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			imgui.CloseCurrentPopup()
			efir.custom.newName = nil
			efir.custom.newKey = nil
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		local shouldAdd = false
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('circle_plus') .. ' Создать', imgui.ImVec2(buttonWidth, 30)) then
			shouldAdd = true
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		shouldAdd = shouldAdd or nameEnter or keyEnter
		if shouldAdd then
			local name = ffi.string(efir.custom.newName)
			local key = ffi.string(efir.custom.newKey)
			if name ~= '' and key ~= '' and key:match("^[a-zA-Z0-9_]+$") then
				if not efir.custom.list[key] then
					efir.custom.list[key] = {
						name = name,
						lines = {}
					}
					efir.custom.selected = key
					efir.custom.lines = {}
					saveCustomEfirs()
					AddNotification("[News Helper]", "Эфир \"" .. name .. "\"\nсоздан!", "success", 3.0)
					imgui.CloseCurrentPopup()
					efir.custom.newName = nil
					efir.custom.newKey = nil
				else
					AddNotification("[News Helper]", "Эфир с таким ключом\nуже существует!", "error", 3.0)
				end
			else
				AddNotification("[News Helper]", "Заполните все поля!\nКлюч только латиница.", "error", 3.0)
			end
		end
	end
	imgui.PopStyleColor(3)
end
function renderVariablesButton()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('code') .. ' Переменные', imgui.ImVec2(100, 25)) then
	if fa_font then imgui.PopFont() end
		helpers.showVariablesHelp[0] = not helpers.showVariablesHelp[0]
	end
	imgui.PopStyleColor(3)
	if helpers.showVariablesHelp[0] then
		imgui.SameLine()
		imgui.BeginChild('##VariablesHelp', imgui.ImVec2(400, 140), true)
		imgui.Text('Доступные переменные:')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '<mynick> - Ник ведущего')
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '<myrang> - Ранг ведущего')  
		imgui.TextColored(imgui.ImVec4(1, 0.8, 0.8, 1), '<winnernick> - Имя победителя')
		imgui.TextColored(imgui.ImVec4(1, 0.8, 0.8, 1), '<winnerball> - Ник для балла')
		imgui.TextColored(imgui.ImVec4(0.8, 0.8, 1, 1), '<balls> - Количество баллов')
		imgui.TextColored(imgui.ImVec4(1, 1, 0.8, 1), '<prize> - Денежная сумма')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(1, 1, 0.5, 1), 'Вариации:')
		imgui.Text('ball1.2, ball2.3 и т.д. для чередования')
		imgui.EndChild()
	end
end
function renderSaveAndClearQuestionsButtons(efirType)
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить##' .. efirType, imgui.ImVec2(85, 25)) then
		if fa_font then imgui.PopFont() end
		saveAutoEfirQuestions(efirType)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('file_import') .. ' Вопросы##' .. efirType, imgui.ImVec2(75, 25)) then
		if fa_font then imgui.PopFont() end
		bulkInput.active = true
		bulkInput.mode = 'questions'
		bulkInput.efirType = efirType
		ffi.fill(bulkInput.text, 8192)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Вставьте все вопросы')
		imgui.Text('по одному на строку')
		imgui.Text('(максимум 10 строк)')
		imgui.EndTooltip()
	end
	imgui.SameLine()
	if efirType == 'zerkalo' and not efir.mode[0] then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('arrow_right_arrow_left') .. ' Отзеркалить##' .. efirType, imgui.ImVec2(97, 25)) then
			if fa_font then imgui.PopFont() end
			mirrorAllQuestions(efirType)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Отзеркалирование')
			imgui.TextWrapped('Отзеркалит все вопросы в поле ответов')
			imgui.EndTooltip()
		end
		imgui.SameLine()
	end
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('trash_can') .. ' Очистить##' .. efirType, imgui.ImVec2(78, 25)) then
		if fa_font then imgui.PopFont() end
		clearEfirQuestions(efirType)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.SetTooltip('Удалить все вопросы и ответы')
	end
end
function mirrorAllQuestions(efirType)
	if not efir.examples or not efir.examples[efirType] then 
		return 
	end
	local function utf8reverse(s)
		local t = {}
		for uchar in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
			table.insert(t, 1, uchar)
		end
		return table.concat(t)
	end
	local mirrored_count = 0
	for i = 1, efirLineCount[efirType] do
		local text = ffi.string(efir.examples[efirType][i])
		if text and text ~= '' then
			local reversed = utf8reverse(text)
			ffi.fill(efir.examples[efirType][i], 256)
			ffi.copy(efir.examples[efirType][i], reversed)
			mirrored_count = mirrored_count + 1
		end
	end
	AddNotification("[News Helper]", "Отзеркалено " .. mirrored_count .. " вопросов", "success", 1.5)
	saveConfig()
end
function renderRemindersTab(efirType)
	imgui.Text('Напоминания и интригование:')
	imgui.Separator()
	imgui.Spacing()
	imgui.Text('Мануальный режим:')
	imgui.Spacing()
	imgui.Text('Напомнить:')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##ReminderManual', efir.reminders.manual.remind, 512) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Text('Интриговать:')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##IntrigueManual', efir.reminders.manual.intrigue, 512) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Text('Не вижу ответа:')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##NoAnswerManual', efir.reminders.manual.noAnswer, 512) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.Text('Автоматический режим:')
	imgui.Spacing()
	imgui.Text('Напомнить (авто):')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##ReminderAuto', efir.reminders.auto.remind, 512) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Text('Интриговать (авто):')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##IntrigueAuto', efir.reminders.auto.intrigue, 512) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Text('Не вижу ответа (авто):')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##NoAnswerAuto', efir.reminders.auto.noAnswer, 512) then
		saveConfig()
	end
	imgui.PopItemWidth()
end
function renderQuizEfir(efirType, efirName, questionLabel)
	local pluralForms = {
		['Пример'] = 'Примеры',
		['Страна'] = 'Страны',
		['Элемент'] = 'Элементы',
		['Слово'] = 'Слова',
		['Буквы'] = 'Буквы',
		['Загадка'] = 'Загадки',
		['Синонимы'] = 'Синонимы'
	}
	local function getPluralForm(singular)
		return pluralForms[singular] or singular .. 'ы'
	end
	local pluralQuestionLabel = getPluralForm(questionLabel)
	if not efir.examples or not efir.examples[efirType] then return end
	if not efir.answers or not efir.answers[efirType] then return end
	if efir.selectedType == efirType and not (efirType == 'sobes' or efirType == 'inter' or efirType == 'reklama') then
		tabWindowSizes[6].y = 1030
	end
	imgui.Text('Эфир "' .. efirName .. '"')
	imgui.Separator()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.BeginChild('##' .. efirType .. 'LeftPanel', imgui.ImVec2(260, 0), true)
	imgui.Text('Режим:')
	setupCheckboxStyle()
	if imgui.ToggleButton('##' .. efirType .. 'mode', efir.mode, 'Мануальный', 'Автоматический', true) then
	end
	cleanupCheckboxStyle()
	imgui.Spacing()
	if efir.mode[0] then
		imgui.Text('Интервал авто (мс):')
		imgui.SameLine()
		local intervalValue = efir.autoInterval[0]
		local digitCount = string.len(tostring(intervalValue))
		local inputWidth = math.max(60, digitCount * 10 + 20)
		imgui.PushItemWidth(inputWidth)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('-##DecAutoInterval', imgui.ImVec2(20, 20)) then
			efir.autoInterval[0] = math.max(3000, efir.autoInterval[0] - 100)
			saveConfig()
		end
		imgui.SameLine()
		if imgui.InputInt('##AutoInterval', efir.autoInterval, 0, 0) then
			if efir.autoInterval[0] < 3000 then efir.autoInterval[0] = 3000 end
			if efir.autoInterval[0] > 10000 then efir.autoInterval[0] = 10000 end
			saveConfig()
		end
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('+##IncAutoInterval', imgui.ImVec2(20, 20)) then
			efir.autoInterval[0] = math.min(10000, efir.autoInterval[0] + 100)
			saveConfig()
		end
		imgui.PopStyleColor(3)
	else
		renderIntervalControl(efirType, 'Интервал (мс)')
	end
	imgui.Spacing()
	imgui.Text('Приз ($):')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##MoneyPrize' .. efirType, efir.inputs.money, 32) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать', imgui.ImVec2(-1, 30)) then
		if fa_font then imgui.PopFont() end
		clearEfirSession()
		if efir.mode[0] then
			startAutoEfir(efirType)
		else
			startEfir(efirType)
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		if efir.mode[0] then
			imgui.Text('Начинает автоэфир')
		else
			imgui.Text('Начинает эфир и отправляет')
			imgui.Text('начальные сообщения')
		end
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(-1, 30)) then
		if fa_font then imgui.PopFont() end
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
			efir.confirmFinishEfirTime = os.clock()
		else
			clearEfirSession()
			if efir.auto.active then
				stopAutoEfir()
			elseif efir.control.running then
				stopEfir()
			else
				AddNotification("[News Helper]", "Эфир не запущен", "warn", 3.0)
			end
			efir.confirmFinishEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир без сообщений')
		imgui.EndTooltip()
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	imgui.PopStyleColor(3)
	if not efir.mode[0] then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			if not efir.confirmEndEfir then
				efir.confirmEndEfir = true
				efir.confirmEndEfirTime = os.clock()
			else
				if efir.control.paused then
					AddNotification("[News Helper]", "Сначала возобновите эфир!", "warn", 3.0)
				else
					clearEfirSession()
					endEfir()
				end
				efir.confirmEndEfir = false
			end
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.Text('Завершает эфир и отправляет')
			imgui.Text('конечные сообщения')
			imgui.EndTooltip()
		end
		if efir.confirmEndEfir and imgui.IsItemHovered() then
			imgui.SetTooltip('Нажмите еще раз для подтверждения')
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('hand') .. ' СТОП!', imgui.ImVec2(-1, 60)) then
			if fa_font then imgui.PopFont() end
			if efir.control.paused then
				AddNotification("[News Helper]", "Сначала возобновите эфир!", "warn", 3.0)
			else
				sampSendChat(u8:decode("Стоп!"))
			end
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.Text('Отправляет в чат "Стоп!"')
			imgui.EndTooltip()
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.Dummy(imgui.ImVec2(0, 20))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		local efirButtonText = efir.inEfir and (fa('arrow_right_from_bracket') .. ' Выйти из эфира') or (fa('arrow_right_to_bracket') .. ' Войти в эфир')
		if imgui.Button(efirButtonText, imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			if not efir.myNickname then
				local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
				efir.myNickname = sampGetPlayerNickname(myId)
				if efir.myNickname then
					efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
				end
			end
			efir.waitingAction = efir.inEfir and "exit_efir" or "enter_efir"
			sampSendChat("/dial")
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			if efir.inEfir then
				imgui.Text('Выйти из прямого эфира')
			else
				imgui.Text('Войти в прямой эфир')
			end
			imgui.EndTooltip()
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		local smsButtonText = efir.smsEnabled and (fa('envelope_open') .. ' Выключить прием СМС') or (fa('envelope') .. ' Включить прием СМС')
		if imgui.Button(smsButtonText, imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			if not efir.myNickname then
				local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
				efir.myNickname = sampGetPlayerNickname(myId)
				if efir.myNickname then
					efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
				end
			end
			efir.waitingAction = efir.smsEnabled and "disable_sms" or "enable_sms"
			sampSendChat("/dial")
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			if efir.smsEnabled then
				imgui.Text('Выключить прием СМС')
			else
				imgui.Text('Включить прием СМС')
			end
			imgui.EndTooltip()
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.Dummy(imgui.ImVec2(0, 20))
		imgui.Spacing()
		imgui.Text('ID игрока:')
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('-##DecPlayerId', imgui.ImVec2(25, 0)) then
			local currentId = tonumber(ffi.string(efir.inputs.playerId)) or 0
			if currentId > 0 then
				ffi.fill(efir.inputs.playerId, 32)
				ffi.copy(efir.inputs.playerId, tostring(currentId - 1))
			else
				ffi.fill(efir.inputs.playerId, 32)
			end
		end
		imgui.SameLine(0, 5)
		imgui.PopStyleColor(3)
		local inputWidth = imgui.GetWindowWidth() - 80
		imgui.PushItemWidth(inputWidth)
		imgui.InputText('##PlayerID' .. efirType, efir.inputs.playerId, 32)
		imgui.PopItemWidth()
		imgui.SameLine(0, 5)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('+##IncPlayerId', imgui.ImVec2(25, 0)) then
			local currentId = tonumber(ffi.string(efir.inputs.playerId))
			if currentId then
				if currentId < 999 then
					ffi.fill(efir.inputs.playerId, 32)
					ffi.copy(efir.inputs.playerId, tostring(currentId + 1))
				end
			else
				ffi.fill(efir.inputs.playerId, 32)
				ffi.copy(efir.inputs.playerId, "0")
			end
		end
		imgui.PopStyleColor(3)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Button('Добавить балл', imgui.ImVec2(-1, 25)) then
			if not efir.confirmAddBall then
				efir.confirmAddBall = true
				efir.confirmAddBallTime = os.clock()
			else
				addPlayerBall()
				efir.confirmAddBall = false
			end
		end
		if imgui.IsItemHovered() then
			if efir.confirmAddBall then
				imgui.SetTooltip('Нажмите еще раз для подтверждения')
			else
				imgui.BeginTooltip()
				imgui.Text('Добавляет балл в таблицу')
				imgui.Text('и сообщает об этом в чат')
				imgui.EndTooltip()
			end
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		renderScoreBoard()
	else
		imgui.Spacing()
		imgui.Dummy(imgui.ImVec2(0, 118))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		local efirButtonText = efir.inEfir and (fa('arrow_right_from_bracket') .. ' Выйти из эфира') or (fa('arrow_right_to_bracket') .. ' Войти в эфир')
		if imgui.Button(efirButtonText, imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			if not efir.myNickname then
				local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
				efir.myNickname = sampGetPlayerNickname(myId)
				if efir.myNickname then
					efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
				end
			end
			efir.waitingAction = efir.inEfir and "exit_efir" or "enter_efir"
			sampSendChat("/dial")
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			if efir.inEfir then
				imgui.Text('Выйти из прямого эфира')
			else
				imgui.Text('Войти в прямой эфир')
			end
			imgui.EndTooltip()
		end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		local smsButtonText = efir.smsEnabled and (fa('envelope_open') .. ' Выключить прием СМС') or (fa('envelope') .. ' Включить прием СМС')
		if imgui.Button(smsButtonText, imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			if not efir.myNickname then
				local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
				efir.myNickname = sampGetPlayerNickname(myId)
				if efir.myNickname then
					efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
				end
			end
			efir.waitingAction = efir.smsEnabled and "disable_sms" or "enable_sms"
			sampSendChat("/dial")
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			if efir.smsEnabled then
				imgui.Text('Выключить прием СМС')
			else
				imgui.Text('Включить прием СМС')
			end
			imgui.EndTooltip()
		end
		imgui.PopStyleColor(3)
	end
	if efir.mode[0] and efir.auto.active and efir.auto.efirType == efirType then
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), 'Автоматический режим активен')
		imgui.Text('Вопрос: ' .. efir.auto.currentQuestion .. ' / ' .. efirLineCount[efirType][0])
		if efir.auto.waitingForAnswer then
			imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Ожидание ответа...')
		end
		renderAutoEfirScoreBoard()
	end
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginGroup()
	imgui.BeginChild('##' .. efirType .. 'RightPanel', imgui.ImVec2(0, 600), true)
	imgui.Text(questionLabel .. ' и ответы:')
	imgui.Text('Количество строк:')
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('-##DecLineCount', imgui.ImVec2(40, 20)) then
		if efirLineCount[efirType][0] > 10 then
			efirLineCount[efirType][0] = efirLineCount[efirType][0] - 1
			saveConfig()
		end
	end
	imgui.SameLine(0, 5)
	imgui.PushItemWidth(80)
	if imgui.InputInt('##LineCount', efirLineCount[efirType], 0, 0) then
		if efirLineCount[efirType][0] < 10 then efirLineCount[efirType][0] = 10 end
		if efirLineCount[efirType][0] > 500 then efirLineCount[efirType][0] = 500 end
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.SameLine(0, 5)
	if imgui.Button('+##IncLineCount', imgui.ImVec2(40, 20)) then
		if efirLineCount[efirType][0] < 500 then
			efirLineCount[efirType][0] = efirLineCount[efirType][0] + 1
			saveConfig()
		end
	end
	imgui.SameLine(0, 10)
	renderSaveAndClearQuestionsButtons(efirType)
	imgui.PopStyleColor(3)
	imgui.Separator()
	local totalLines = efirLineCount[efirType][0]
	local columnsCount = math.ceil(totalLines / 10)
	local scrollbarHeight = 18
	local availableHeight = imgui.GetContentRegionAvail().y
	imgui.BeginChild('##QuestionsScrollRegion', imgui.ImVec2(-1, availableHeight), false, imgui.WindowFlags.HorizontalScrollbar)
	local mouseWheel = imgui.GetIO().MouseWheel
	if mouseWheel ~= 0 and imgui.IsWindowHovered() then
		local scrollX = imgui.GetScrollX()
		imgui.SetScrollX(scrollX - mouseWheel * 50)
	end
	for col = 0, columnsCount - 1 do
		local startIdx = col * 10 + 1
		local endIdx = math.min(startIdx + 9, totalLines)
		if col > 0 then
			imgui.SameLine(0, 20)
			local cursorY = imgui.GetCursorPosY()
			imgui.BeginGroup()
			local separatorColor = imgui.GetStyle().Colors[imgui.Col.Separator]
			imgui.PushStyleColor(imgui.Col.ChildBg, separatorColor)
			imgui.BeginChild('##separator' .. col, imgui.ImVec2(1, availableHeight - scrollbarHeight - 0), false)
			imgui.EndChild()
			imgui.PopStyleColor()
			imgui.EndGroup()
			imgui.SameLine(0, 20)
		end
		imgui.BeginGroup()
		local headerText = pluralQuestionLabel .. ':'
		local headerWidth = imgui.CalcTextSize(headerText).x
		local inputWidth = 250
		local centerPos = (inputWidth - headerWidth) / 2
		local startY = imgui.GetCursorPosY()
		if centerPos > 0 then
			imgui.Dummy(imgui.ImVec2(centerPos, 0))
			imgui.SameLine(0, 0)
		end
		imgui.Text(headerText)
		imgui.SameLine(0, 10)
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(350)
			if efir.mode[0] then
				imgui.Text('Введите вопросы, которые скрипт будет отправлять автоматически')
			else
				imgui.Text('Введите вопросы, которые скрипт будет отправлять при нажатии кнопки "Отправить"')
			end
			if efirType == 'math' then
				imgui.Separator()
				if efir.mode[0] then
					imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'Ответы рассчитываются автоматически из вопросов')
				else
					imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'Ответ покажется при наведении на кнопку "Отправить"')
				end
			elseif efirType == 'zerkalo' then
				imgui.Separator()
				if efir.mode[0] then
					imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'Вопросы отзеркаливаются в ответы')
				else
					imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'Отзеркаленный ответ покажется при наведении на "Отправить"')
				end
			end
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
		if efir.mode[0] then
			imgui.SetCursorPosY(startY)
			local answerHeaderText = 'Ответы:'
			local answerHeaderWidth = imgui.CalcTextSize(answerHeaderText).x
			local answerInputWidth = 100
			local answerCenterPos = (answerInputWidth - answerHeaderWidth) / 2
			local answerOffset = 250 + centerPos + 10 + answerCenterPos - 80
			imgui.Dummy(imgui.ImVec2(answerOffset, 0))
			imgui.SameLine(0, 0)
			imgui.Text(answerHeaderText)
			imgui.SameLine(0, 10)
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(350)
				imgui.Text('Введите ответы на вопросы, которые скрипт должен принимать в чате')
				imgui.Separator()
				if efirType == 'math' then
					imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'Ответы рассчитываются автоматически из вопросов')
				elseif efirType == 'zerkalo' then
					imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'Ответы отзеркаливаются в вопросы')
				end
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end
		imgui.Spacing()
		for i = startIdx, endIdx do
			if not efir.examples[efirType][i] then
				efir.examples[efirType][i] = imgui.new.char[256]()
			end
			if not efir.answers[efirType][i] then
				efir.answers[efirType][i] = imgui.new.char[256]()
			end
			imgui.PushIDInt(i)
			imgui.Text(questionLabel .. ' ' .. i .. ':')
			if efir.mode[0] then
				local labelWidth = imgui.CalcTextSize(questionLabel .. ' ' .. i .. ':').x
				local spaceBetween = 250 + 30 - labelWidth
				imgui.SameLine(0, spaceBetween)
				imgui.Text('Ответ:')
			end
			imgui.PushItemWidth(250)
			if imgui.InputText('##Example', efir.examples[efirType][i], 256) then
				if efirType == 'math' then
					local example = ffi.string(efir.examples[efirType][i])
					if example ~= '' then
						local result, error = calculateMathExpression(example)
						if result then
							ffi.copy(efir.answers[efirType][i], result)
						else
							ffi.fill(efir.answers[efirType][i], 256)
						end
					else
						ffi.fill(efir.answers[efirType][i], 256)
					end
				elseif efirType == 'zerkalo' then
					local example = ffi.string(efir.examples[efirType][i])
					if example ~= '' then
						local function utf8reverse(s)
							local t = {}
							for uchar in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
								table.insert(t, 1, uchar)
							end
							return table.concat(t)
						end
						local mirrored = utf8reverse(example)
						if not efir.answers[efirType][i] then
							efir.answers[efirType][i] = imgui.new.char[256]()
						else
							ffi.fill(efir.answers[efirType][i], 256)
						end
						ffi.copy(efir.answers[efirType][i], mirrored)
					else
						if efir.answers[efirType][i] then
							ffi.fill(efir.answers[efirType][i], 256)
						end
					end
				end
			end
			imgui.PopItemWidth()
			if efir.mode[0] then
				imgui.SameLine(0, 30)
				imgui.PushItemWidth(100)
				if imgui.InputText('##Answer', efir.answers[efirType][i], 256) then
					if efirType == 'zerkalo' then
						local answer = ffi.string(efir.answers[efirType][i])
						if answer ~= '' then
							local function utf8reverse(s)
								local t = {}
								for uchar in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
									table.insert(t, 1, uchar)
								end
								return table.concat(t)
							end
							local reversed = utf8reverse(answer)
							ffi.copy(efir.examples[efirType][i], reversed)
						else
							ffi.fill(efir.examples[efirType][i], 256)
						end
					end
				end
				imgui.PopItemWidth()
			else
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				local answerText = ffi.string(efir.answers[efirType][i])
				if imgui.Button('Отправить', imgui.ImVec2(80, 20)) then
					local example = ffi.string(efir.examples[efirType][i])
					if example ~= '' then
						efir.type = efirType
						efir.currentQuestion = i
						lua_thread.create(function()
							if i == 1 then
								sampSendChat(u8:decode(ffi.string(efir.messages[efirType].first)))
							else
								sampSendChat(u8:decode(ffi.string(efir.messages[efirType].next)))
							end
							local interval = efir.intervals[efirType] and efir.intervals[efirType][0] or 4000
							wait(interval)
							sampSendChat(u8:decode(example))
							efir.awaitingAnswer = true
						end)
					end
				end
				if imgui.IsMouseClicked(1) and imgui.IsItemHovered() then
					local example = ffi.string(efir.examples[efirType][i])
					if example ~= '' then
						sampSendChat(u8:decode('Напоминаю. ' .. questionLabel .. ': ' .. example))
					end
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					if efirType == 'math' or efirType == 'zerkalo' then
						if efirType == 'math' then
							if answerText ~= '' then
								imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), 'Ответ: ' .. answerText)
							else
								imgui.Text('Введите вопрос для расчета ответа')
							end
						elseif efirType == 'zerkalo' then
							if answerText ~= '' then
								imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), 'Отзеркаленный ответ: ' .. answerText)
							else
								imgui.Text('Введите ответ для отзеркаливания')
							end
						end
					end
					imgui.Separator()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'ПКМ: Напомнить о вопросе')
					imgui.EndTooltip()
				end
				imgui.PopStyleColor(3)
			end
			imgui.PopID()
			imgui.Spacing()
		end
		imgui.EndGroup()
	end
	imgui.EndChild()
	imgui.EndChild()
	imgui.BeginChild('##' .. efirType .. 'BottomPanel', imgui.ImVec2(0, 0), true)
	imgui.Text('Быстрые действия:')
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('Напомнить', imgui.ImVec2(-1, 25)) then
		sendReminderMessage()
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Отправляет сообщение напоминание')
		imgui.EndTooltip()
	end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('Интриговать', imgui.ImVec2(-1, 25)) then
		sendIntrigueMessage()
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Отправляет сообщение интригования')
		imgui.EndTooltip()
	end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('Не вижу ответа', imgui.ImVec2(-1, 25)) then
		if efir.mode[0] then
			if efir.reminders and efir.reminders.auto and efir.reminders.auto.noAnswer then
				local noAnswerText = ffi.string(efir.reminders.auto.noAnswer)
				if noAnswerText and noAnswerText ~= '' then
					sampSendChat(u8:decode(noAnswerText))
				end
			end
		else
			if efir.reminders and efir.reminders.manual and efir.reminders.manual.noAnswer then
				local noAnswerText = ffi.string(efir.reminders.manual.noAnswer)
				if noAnswerText and noAnswerText ~= '' then
					sampSendChat(u8:decode(noAnswerText))
				end
			end
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Отправляет сообщение когда нет ответа')
		imgui.EndTooltip()
	end
	imgui.PopStyleColor(3)
	imgui.EndChild()
	imgui.EndGroup()
end
function renderMathEfir()
	renderQuizEfir('math', 'Математика', 'Пример')
end
function renderCountryEfir()
	renderQuizEfir('country', 'Столицы', 'Страна')
end
function renderHimiaEfir()
	renderQuizEfir('himia', 'Химия', 'Элемент')
end
function renderZerkaloEfir()
	renderQuizEfir('zerkalo', 'Зеркало', 'Слово')
end
function renderAnnagrammEfir()
	renderQuizEfir('annagramm', 'Анаграммы', 'Буквы')
end
function renderZagadkiEfir()
	renderQuizEfir('zagadki', 'Загадки', 'Загадка')
end
function renderSinonimEfir()
	renderQuizEfir('sinonim', 'Синонимы', 'Слово')
end
function renderInterviewEfir()
	imgui.Text('Эфир "Интервью"')
	imgui.Separator()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	if efirType == 'sobes' or efirType == 'inter' or efirType == 'reklama' then
		tabWindowSizes[6].y = 580
	end
	imgui.BeginChild('##IntervyuLeftPanel', imgui.ImVec2(260, 0), true)
	renderIntervalControl('inter', 'Интервал (мс)')
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать эфир', imgui.ImVec2(-1, 30)) then
		startEfir('inter')
		efir.confirmFinishEfir = false
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Начинает эфир и отправляет')
		imgui.Text('начальные сообщения')
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(-1, 30)) then
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
			efir.confirmFinishEfirTime = os.clock()
		else
			if efir.control.running then
				clearEfirSession()
				stopEfir()
			else
				AddNotification("[News Helper]", "Эфир не запущен", "warn", 3.0)
			end
			efir.confirmFinishEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир без сообщений')
		imgui.EndTooltip()
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(-1, 30)) then
		if not efir.confirmEndEfir then
			efir.confirmEndEfir = true
			efir.confirmEndEfirTime = os.clock()
		else
			if efir.control.paused then
				AddNotification("[News Helper]", "Сначала возобновите эфир!", "warn", 3.0)
			else
				clearEfirSession()
				endEfir()
			end
			efir.confirmEndEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир и отправляет')
		imgui.Text('конечные сообщения')
		imgui.EndTooltip()
	end
	if efir.confirmEndEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Dummy(imgui.ImVec2(0, 20))
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	local efirButtonText = efir.inEfir and (fa('arrow_right_from_bracket') .. ' Выйти из эфира') or (fa('arrow_right_to_bracket') .. ' Войти в эфир')
	if imgui.Button(efirButtonText, imgui.ImVec2(-1, 30)) then
		if not efir.myNickname then
			local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			efir.myNickname = sampGetPlayerNickname(myId)
			if efir.myNickname then
				efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			end
		end
		if efir.inEfir and efir.interview.isGuestInvited then
			AddNotification("[News Helper]", "Сначала выпроваживаем гостя...", "info", 2.0)
			efir.waitingAction = "kick_guest"
			sampSendChat("/dial")
		else
			if efir.inEfir then
				efir.waitingAction = "exit_efir"
			else
				efir.waitingAction = "enter_efir"
			end
			sampSendChat("/dial")
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		if efir.inEfir then
			imgui.Text('Выйти из прямого эфира')
		else
			imgui.Text('Войти в прямой эфир')
		end
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	local smsButtonText = efir.smsEnabled and (fa('message_xmark') .. ' Выкл. прием СМС') or (fa('message') .. ' Вкл. прием СМС')
	if imgui.Button(smsButtonText, imgui.ImVec2(-1, 30)) then
		efir.waitingAction = efir.smsEnabled and "disable_sms" or "enable_sms"
		sampSendChat("/dial")
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		if efir.smsEnabled then
			imgui.Text('Выключить прием СМС')
		else
			imgui.Text('Включить прием СМС')
		end
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##IntervyuRightPanel', imgui.ImVec2(0, 0), true)
	imgui.Text('Имя и Фамилия гостя (или ID):')
	imgui.PushItemWidth(imgui.GetWindowWidth() - 100)
	if efir.interview.wasGuestInputActive == nil then
		efir.interview.wasGuestInputActive = false
	end
	imgui.InputTextWithHint('##GuestName', 'Nick_Name или ID (Enter для поиска)', efir.interview.name, 256)
	local isCurrentlyActive = imgui.IsItemActive()
	if efir.interview.wasGuestInputActive and not isCurrentlyActive then
		local inputValue = ffi.string(efir.interview.name):gsub("^%s+", ""):gsub("%s+$", "")
		local playerId = tonumber(inputValue)
		if playerId then
			local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			if playerId == myId then
				AddNotification("[News Helper]", "Вы не можете работать\nс самим собой!", "error", 3.0)
				ffi.copy(efir.interview.name, "")
			elseif sampIsPlayerConnected(playerId) then
				local playerNick = sampGetPlayerNickname(playerId)
				if playerNick then
					local cleanNick = playerNick:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
					ffi.copy(efir.interview.name, cleanNick)
					AddNotification("[News Helper]", "Найден игрок:\n" .. cleanNick, "success", 2.0)
				else
					AddNotification("[News Helper]", "Не удалось получить\nникнейм", "error", 3.0)
				end
			else
				AddNotification("[News Helper]", "Игрок с ID " .. playerId .. "\nне в сети", "error", 3.0)
			end
		end
	end
	efir.interview.wasGuestInputActive = isCurrentlyActive
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	local inviteButtonText = efir.interview.isGuestInvited and 'Выпровод.' or 'Пригласить'
	if imgui.Button(inviteButtonText, imgui.ImVec2(80, 20)) then
		if efir.interview.isGuestInvited then
			if not efir.inEfir then
				AddNotification("[News Helper]", "Сначала войдите в эфир!", "warn", 3.0)
			else
				efir.waitingAction = "kick_guest"
				sampSendChat("/dial")
			end
		else
			local guestNick = ffi.string(efir.interview.name):gsub("^%s+", ""):gsub("%s+$", "")
			if guestNick == "" then
				AddNotification("[News Helper]", "Введите никнейм гостя!", "warn", 3.0)
			elseif not efir.inEfir then
				AddNotification("[News Helper]", "Сначала войдите в эфир!", "warn", 3.0)
			else
				if not efir.myNickname then
					local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
					efir.myNickname = sampGetPlayerNickname(myId)
					if efir.myNickname then
						efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
					end
				end
				if guestNick == efir.myNickname then
					AddNotification("[News Helper]", "Вы не можете пригласить\nсамого себя!", "error", 3.0)
				else
					local guestId = nil
					for playerId = 0, sampGetMaxPlayerId() do
						if sampIsPlayerConnected(playerId) then
							local playerNick = sampGetPlayerNickname(playerId)
							if playerNick then
								local cleanNick = playerNick:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
								if cleanNick == guestNick then
									guestId = playerId
									break
								end
							end
						end
					end
					if not guestId then
						AddNotification("[News Helper]", "Игрок " .. guestNick .. "\nне найден на сервере", "error", 3.0)
					else
						efir.interview.guestId = guestId
						efir.waitingAction = "invite_guest"
						sampSendChat("/dial")
					end
				end
			end
		end
	end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		if efir.interview.isGuestInvited then
			imgui.Text('Выпроводить гостя из эфира')
		else
			imgui.Text('Пригласить гостя в эфир')
			imgui.Separator()
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Введите английский никнейм или ID')
		end
		imgui.EndTooltip()
	end
	imgui.Text('Должность:')
	imgui.InputText('##GuestRank', efir.interview.rang, 256)
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('user_tie') .. ' Представить гостя', imgui.ImVec2(-1, 25)) then
		local name = ffi.string(efir.interview.name):gsub("^%s+", ""):gsub("%s+$", "")
		if name == "" then
			AddNotification("[News Helper]", "Введите имя гостя!", "error", 3.0)
			return
		end
		local guestName = name:gsub("_", " ")
		local translatedName = trst(guestName)
		local guestRank = ffi.string(efir.interview.rang):gsub("^%s+", ""):gsub("%s+$", "")
		local translatedRank = trst(guestRank)
		lua_thread.create(function()
			local messages = efir.messages.inter
			if not messages or not messages.introduce then
				AddNotification("[News Helper]", "Ошибка: сообщения не загружены", "error", 3.0)
				return
			end
			local introduceText = ffi.string(messages.introduce)
			introduceText = introduceText:gsub("<guestrank>", translatedRank)
			introduceText = introduceText:gsub("<guestname>", translatedName)
			sampSendChat(u8:decode(introduceText))
			local interval = efir.intervals.inter[0] or 3000
			wait(interval)
			local introduce2Text = ffi.string(messages.introduce2)
			introduce2Text = introduce2Text:gsub("<guestname>", translatedName)
			sampSendChat(u8:decode(introduce2Text))
		end)
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Представляет гостя в чате')
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Text('Быстрые вопросы:')
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	for i = 1, 4 do
		if fa_font then imgui.PushFont(fa_font) end
		local questionKey = "question"..i
		if efir.messages.inter[questionKey] then
			if imgui.Button(fa('circle_question') .. ' ' .. ffi.string(efir.messages.inter[questionKey]), imgui.ImVec2(-1, 20)) then
				sampSendChat(u8:decode(ffi.string(efir.messages.inter[questionKey])))
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.Text('Отправляет вопрос в чат')
				imgui.EndTooltip()
			end
		end
		if fa_font then imgui.PopFont() end
	end
	imgui.PopStyleColor(3)
	imgui.EndChild()
end
function renderReklamaEfir()
	imgui.Text('Эфир "Реклама"')
	imgui.Separator()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	if efirType == 'sobes' or efirType == 'inter' or efirType == 'reklama' then
		tabWindowSizes[6].y = 580
	end
	imgui.BeginChild('##ReklamaLeftPanel', imgui.ImVec2(260, 0), true)
	imgui.Text('Интервал для начала/конца (мс):')
	local intervalValue = efir.intervals.reklama[0]
	local digitCount = string.len(tostring(intervalValue))
	local inputWidth = math.max(60, digitCount * 10 + 20)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('-##DecIntervalReklama', imgui.ImVec2(20, 20)) then
		efir.intervals.reklama[0] = math.max(1000, efir.intervals.reklama[0] - 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushItemWidth(inputWidth)
	if imgui.InputInt('##IntervalReklama', efir.intervals.reklama, 0, 0) then
		if efir.intervals.reklama[0] < 1000 then efir.intervals.reklama[0] = 1000 end
		if efir.intervals.reklama[0] > 10000 then efir.intervals.reklama[0] = 10000 end
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('+##IncIntervalReklama', imgui.ImVec2(20, 20)) then
		efir.intervals.reklama[0] = math.min(10000, efir.intervals.reklama[0] + 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.Text('Интервал между строками (мс):')
	local linesIntervalValue = efir.intervals.reklamaLines[0]
	local linesDigitCount = string.len(tostring(linesIntervalValue))
	local linesInputWidth = math.max(60, linesDigitCount * 10 + 20)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('-##DecIntervalReklamaLines', imgui.ImVec2(20, 20)) then
		efir.intervals.reklamaLines[0] = math.max(1000, efir.intervals.reklamaLines[0] - 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushItemWidth(linesInputWidth)
	if imgui.InputInt('##IntervalReklamaLines', efir.intervals.reklamaLines, 0, 0) then
		if efir.intervals.reklamaLines[0] < 1000 then efir.intervals.reklamaLines[0] = 1000 end
		if efir.intervals.reklamaLines[0] > 10000 then efir.intervals.reklamaLines[0] = 10000 end
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if imgui.Button('+##IncIntervalReklamaLines', imgui.ImVec2(20, 20)) then
		efir.intervals.reklamaLines[0] = math.min(10000, efir.intervals.reklamaLines[0] + 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать эфир', imgui.ImVec2(-1, 30)) then
		startEfir('reklama')
		efir.confirmFinishEfir = false
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Начинает эфир и отправляет')
		imgui.Text('начальные сообщения')
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(-1, 30)) then
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
			efir.confirmFinishEfirTime = os.clock()
		else
			if efir.control.running then
				clearEfirSession()
				stopEfir()
			else
				AddNotification("[News Helper]", "Эфир не запущен", "warn", 3.0)
			end
			efir.confirmFinishEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир без сообщений')
		imgui.EndTooltip()
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(-1, 30)) then
		if not efir.confirmEndEfir then
			efir.confirmEndEfir = true
			efir.confirmEndEfirTime = os.clock()
		else
			if efir.control.paused then
				AddNotification("[News Helper]", "Сначала возобновите эфир!", "warn", 3.0)
			else
				clearEfirSession()
				endEfir()
			end
			efir.confirmEndEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир и отправляет')
		imgui.Text('конечные сообщения')
		imgui.EndTooltip()
	end
	if efir.confirmEndEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Dummy(imgui.ImVec2(0, 20))
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	local efirButtonText = efir.inEfir and (fa('arrow_right_from_bracket') .. ' Выйти из эфира') or (fa('arrow_right_to_bracket') .. ' Войти в эфир')
	if imgui.Button(efirButtonText, imgui.ImVec2(-1, 30)) then
		if not efir.myNickname then
			local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			efir.myNickname = sampGetPlayerNickname(myId)
			if efir.myNickname then
				efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			end
		end
		efir.waitingAction = efir.inEfir and "exit_efir" or "enter_efir"
		sampSendChat("/dial")
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		if efir.inEfir then
			imgui.Text('Выйти из прямого эфира')
		else
			imgui.Text('Войти в прямой эфир')
		end
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##ReklamaRightPanel', imgui.ImVec2(0, 0), true)
	imgui.Text('Текст рекламы (каждая строка отдельно):')
	if not efir.inputs.reklamaText then efir.inputs.reklamaText = imgui.new.char[1024]() end
	local text = ffi.string(efir.inputs.reklamaText)
	local lineCount = 1
	for _ in text:gmatch("\n") do
		lineCount = lineCount + 1
	end
	local minHeight = 100
	local lineHeight = 18
	local calculatedHeight = math.max(minHeight, lineCount * lineHeight + 20)
	imgui.InputTextMultiline('##ReklamaText', efir.inputs.reklamaText, 1024, imgui.ImVec2(-1, calculatedHeight))
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('bullhorn') .. ' Прочитать рекламу', imgui.ImVec2(-1, 25)) then
		local text = ffi.string(efir.inputs.reklamaText)
		if text ~= "" then
			lua_thread.create(function()
				for line in text:gmatch("[^\r\n]+") do
					local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
					if trimmed ~= "" then
						sampSendChat(u8:decode(trimmed))
						wait(efir.intervals.reklamaLines[0])
					end
				end
			end)
		else
			AddNotification("[News Helper]", "Введите текст рекламы!", "warn", 4.0)
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Отправляет рекламу в чат')
		imgui.Text('со строк')
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.EndChild()
end
function renderSobesEfir()
	imgui.Text('Эфир "Собеседование"')
	imgui.Separator()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	if efirType == 'sobes' or efirType == 'inter' or efirType == 'reklama' then
		tabWindowSizes[6].y = 580
	end
	imgui.BeginChild('##SobesLeftPanel', imgui.ImVec2(260, 0), true)
	renderIntervalControl('sobes', 'Интервал (мс)')
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать эфир', imgui.ImVec2(-1, 30)) then
		startEfir('sobes')
		efir.confirmFinishEfir = false
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Начинает эфир и отправляет')
		imgui.Text('начальные сообщения')
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(-1, 30)) then
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
			efir.confirmFinishEfirTime = os.clock()
		else
			if efir.control.running then
				clearEfirSession()
				stopEfir()
			else
				AddNotification("[News Helper]", "Эфир не запущен", "warn", 3.0)
			end
			efir.confirmFinishEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир без сообщений')
		imgui.EndTooltip()
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(-1, 30)) then
		if not efir.confirmEndEfir then
			efir.confirmEndEfir = true
			efir.confirmEndEfirTime = os.clock()
		else
			if efir.control.paused then
				AddNotification("[News Helper]", "Сначала возобновите эфир!", "warn", 3.0)
			else
				clearEfirSession()
				endEfir()
			end
			efir.confirmEndEfir = false
		end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Завершает эфир и отправляет')
		imgui.Text('конечные сообщения')
		imgui.EndTooltip()
	end
	if efir.confirmEndEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Dummy(imgui.ImVec2(0, 20))
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
	if fa_font then imgui.PushFont(fa_font) end
	local efirButtonText = efir.inEfir and (fa('arrow_right_from_bracket') .. ' Выйти из эфира') or (fa('arrow_right_to_bracket') .. ' Войти в эфир')
	if imgui.Button(efirButtonText, imgui.ImVec2(-1, 30)) then
		if not efir.myNickname then
			local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			efir.myNickname = sampGetPlayerNickname(myId)
			if efir.myNickname then
				efir.myNickname = efir.myNickname:gsub("%[%d+%]", ""):gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			end
		end
		efir.waitingAction = efir.inEfir and "exit_efir" or "enter_efir"
		sampSendChat("/dial")
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		if efir.inEfir then
			imgui.Text('Выйти из прямого эфира')
		else
			imgui.Text('Войти в прямой эфир')
		end
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##SobesRightPanel', imgui.ImVec2(0, 0), true)
	imgui.TextWrapped('Эфир для объявления о собеседовании в СМИ')
	imgui.EndChild()
end
function renderScoreBoard()
	if efir.auto.active then
		imgui.Spacing()
		imgui.BeginChild('##AutoScoreBoard', imgui.ImVec2(-1, 100), true)
		imgui.Text('Таблица баллов:')
		imgui.Separator()
		local sortedScores = {}
		for name, score in pairs(efir.counter) do
			table.insert(sortedScores, {name = name, score = score})
		end
		table.sort(sortedScores, function(a, b) return a.score > b.score end)
		local colors = {
			imgui.ImVec4(1.0, 0.84, 0.0, 1),
			imgui.ImVec4(0.75, 0.75, 0.75, 1),
			imgui.ImVec4(0.8, 0.6, 0.2, 1),
			imgui.ImVec4(1.0, 1.0, 1.0, 1)
		}
		if #sortedScores == 0 then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Пока никто не набрал баллов')
		else
			for place, playerData in ipairs(sortedScores) do
				if place <= 4 then
					imgui.TextColored(colors[place], string.format("%d. %s = %d", place, playerData.name, playerData.score))
				else
					imgui.Text(string.format("%d. %s = %d", place, playerData.name, playerData.score))
				end
			end
		end
		imgui.EndChild()
		return
	end
	if efir.auto.updating then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Обновление данных...')
		return
	end
	imgui.Spacing()
	imgui.BeginChild('##ScoreBoard', imgui.ImVec2(-1, 100), true)
	imgui.Text('Таблица баллов:')
	imgui.Separator()
	local sortedScores = {}
	for name, score in pairs(efir.counter) do
		table.insert(sortedScores, {name = name, score = score})
	end
	table.sort(sortedScores, function(a, b) return a.score > b.score end)
	local colors = {
		imgui.ImVec4(1.0, 0.84, 0.0, 1),
		imgui.ImVec4(0.75, 0.75, 0.75, 1),
		imgui.ImVec4(0.8, 0.6, 0.2, 1),
		imgui.ImVec4(1.0, 1.0, 1.0, 1)
	}
	if #sortedScores == 0 then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Пока никто не набрал баллов')
	else
		for place, playerData in ipairs(sortedScores) do
			if place <= 4 then
				imgui.TextColored(colors[place], string.format("%d. %s = %d", place, playerData.name, playerData.score))
			else
				imgui.Text(string.format("%d. %s = %d", place, playerData.name, playerData.score))
			end
		end
	end
	imgui.EndChild()
	imgui.Spacing()
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('trash_can') .. ' Очистить баллы', imgui.ImVec2(-1, 25)) then
		if fa_font then imgui.PopFont() end
		clearScoreboard()
	end
	imgui.PopStyleColor(3)
end
function renderAutoEfirScoreBoard()
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.Text('Таблица баллов:')
	local sortedScores = {}
	for name, score in pairs(efir.counter) do
		table.insert(sortedScores, {name = name, score = score})
	end
	table.sort(sortedScores, function(a, b) return a.score > b.score end)
	local colors = {
		imgui.ImVec4(1.0, 0.84, 0.0, 1),
		imgui.ImVec4(0.75, 0.75, 0.75, 1),
		imgui.ImVec4(0.8, 0.6, 0.2, 1),
		imgui.ImVec4(1.0, 1.0, 1.0, 1)
	}
	if #sortedScores == 0 then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Пока никто не набрал баллов')
	else
		for place, playerData in ipairs(sortedScores) do
			if place <= 4 then
				imgui.TextColored(colors[place], string.format("%d. %s = %d", place, playerData.name, playerData.score))
			else
				imgui.Text(string.format("%d. %s = %d", place, playerData.name, playerData.score))
			end
		end
	end
end