if imgui and vk and fa and requests and encoding and ev then	
	imgui.OnFrame(function() return commandRPSystem.editWindow[0] or anim.commandRP.editWindow.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.commandRP.editWindow.lastFrameTime then
			anim.commandRP.editWindow.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.commandRP.editWindow.lastFrameTime
		anim.commandRP.editWindow.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if commandRPSystem.editWindow[0] and anim.commandRP.editWindow.isClosing then
			anim.commandRP.editWindow.alpha = 0
			anim.commandRP.editWindow.scale = 0.85
			anim.commandRP.editWindow.offsetY = 30
			anim.commandRP.editWindow.targetAlpha = 1
			anim.commandRP.editWindow.targetScale = 1
			anim.commandRP.editWindow.targetOffsetY = 0
			anim.commandRP.editWindow.spreadProgress = 0
			anim.commandRP.editWindow.targetSpreadProgress = 1
			anim.commandRP.editWindow.isClosing = false
			anim.commandRP.editWindow.fixedTopY = nil
		end
		if not commandRPSystem.editWindow[0] and anim.commandRP.editWindow.alpha > 0.01 and not anim.commandRP.editWindow.isClosing then
			anim.commandRP.editWindow.targetAlpha = 0
			anim.commandRP.editWindow.targetScale = 0.85
			anim.commandRP.editWindow.targetOffsetY = 30
			anim.commandRP.editWindow.targetSpreadProgress = 0
			anim.commandRP.editWindow.isClosing = true
		end
		anim.commandRP.editWindow.alpha = math.min(anim.commandRP.editWindow.alpha + (anim.commandRP.editWindow.targetAlpha - anim.commandRP.editWindow.alpha) * anim.commandRP.editWindow.animSpeed * speedMultiplier, 1)
		anim.commandRP.editWindow.scale = anim.commandRP.editWindow.scale + (anim.commandRP.editWindow.targetScale - anim.commandRP.editWindow.scale) * anim.commandRP.editWindow.animSpeed * speedMultiplier
		anim.commandRP.editWindow.offsetY = anim.commandRP.editWindow.offsetY + (anim.commandRP.editWindow.targetOffsetY - anim.commandRP.editWindow.offsetY) * anim.commandRP.editWindow.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.commandRP.editWindow.isClosing and (anim.commandRP.editWindow.animSpeed * 1.2 * speedMultiplier) or (anim.commandRP.editWindow.animSpeed * 1 * speedMultiplier)
		anim.commandRP.editWindow.spreadProgress = anim.commandRP.editWindow.spreadProgress + (anim.commandRP.editWindow.targetSpreadProgress - anim.commandRP.editWindow.spreadProgress) * spreadAnimSpeed
		anim.commandRP.editWindow.spreadProgress = math.max(0, math.min(anim.commandRP.editWindow.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.commandRP.editWindow.spreadProgress * 0.7
		local scaledWidth = anim.commandRP.editWindow.currentTabWidth * anim.commandRP.editWindow.scale * spreadScale
		local scaledHeight = anim.commandRP.editWindow.currentTabHeight * anim.commandRP.editWindow.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if commandRPSystem.editWindow[0] and not anim.commandRP.editWindow.fixedTopY then
			anim.commandRP.editWindow.fixedTopY = sizeY / 2 - anim.commandRP.editWindow.currentTabHeight / 2
		end
		local animY = anim.commandRP.editWindow.fixedTopY or sizeY / 2
		if anim.commandRP.editWindow.spreadProgress < 1 then
			animY = sizeY / 2 + (anim.commandRP.editWindow.fixedTopY - sizeY / 2) * anim.commandRP.editWindow.spreadProgress
		end
		if anim.commandRP.editWindow.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.commandRP.editWindow.alpha)
		local bg = settings.colors.background
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Редактор команды##commandRPEdit', commandRPSystem.editWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
			imgui.Text('Команда (без /):')
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(400)
				imgui.TextColored(imgui.ImVec4(0.7, 0.3, 1, 1), 'Команды с отыгровками:')
				imgui.Separator()
				imgui.TextWrapped('Позволяет привязать несколько строк текста к команде.')
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Как это работает:')
				imgui.Text('1. Вводишь название команды (например: pay)')
				imgui.Text('2. Добавляешь строки текста для отыгровки')
				imgui.Text('3. При вводе /pay скрипт:')
				imgui.Indent(20)
				if fa_font then imgui.PushFont(fa_font) end
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), fa('check') .. ' Отправляет каждую строку в чат')
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), fa('check') .. ' Ждет задержку между строками')
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), fa('check') .. ' Затем выполняет саму команду')
				if fa_font then imgui.PopFont() end
				imgui.Unindent(20)
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(1, 0.8, 0.3, 1), 'Пример:')
				imgui.Indent(20)
				imgui.TextColored(imgui.ImVec4(0.6, 0.8, 1, 1), 'Команда: pay')
				imgui.TextColored(imgui.ImVec4(0.6, 0.8, 1, 1), 'Строка 1: *взял деньги из кошелька*')
				imgui.TextColored(imgui.ImVec4(0.6, 0.8, 1, 1), 'Строка 2: *вручил вам 500 рублей*')
				imgui.Text('Результат: сначала отыгровка, потом /pay')
				imgui.Unindent(20)
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine(150)
			imgui.PushItemWidth(180)
			imgui.InputText('##commandRPEditName', commandRPSystem.editingCmdName, 64)
			imgui.PopItemWidth()
			imgui.SameLine(350)
			imgui.Text('Задержка (мс):')
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(300)
				imgui.TextColored(imgui.ImVec4(0.7, 0.3, 1, 1), 'Задержка между строками:')
				imgui.Separator()
				imgui.TextWrapped('Время в миллисекундах, которое ждет скрипт перед отправкой каждой следующей строки.')
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'Минимум: 500 мс (0.5 сек)')
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'Максимум: 10000 мс (10 сек)')
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			local delayValue = commandRPSystem.globalDelay or 2000
			local inputWidth = 60
			imgui.PushItemWidth(inputWidth)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button('-##DecDelay', imgui.ImVec2(25, 20)) then
				commandRPSystem.globalDelay = math.max(500, (commandRPSystem.globalDelay or 2000) - 100)
			end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			local delayInput = imgui.new.int(commandRPSystem.globalDelay or 2000)
			if imgui.InputInt('##CommandDelay', delayInput, 0, 0) then
				local value = delayInput[0]
				if value < 500 then value = 500 end
				if value > 10000 then value = 10000 end
				commandRPSystem.globalDelay = value
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button('+##IncDelay', imgui.ImVec2(25, 20)) then
				commandRPSystem.globalDelay = math.min(10000, (commandRPSystem.globalDelay or 2000) + 100)
			end
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			imgui.Spacing()
			imgui.Separator()
			imgui.Spacing()
			local inputBg = imgui.ImVec4(item[0]*0.5, item[1]*0.5, item[2]*0.5, item[3])
			local inputBgHover = imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3])
			local inputBgActive = imgui.ImVec4(item[0]*0.9, item[1]*0.9, item[2]*0.9, item[3])
			local contentHeight = imgui.GetWindowHeight() - 130
			imgui.BeginChild('##CommandRPEditorLines', imgui.ImVec2(0, contentHeight), true)
			if not commandRPSystem.editorLines or #commandRPSystem.editorLines == 0 then
				commandRPSystem.editorLines = {{text = imgui.new.char[512]()}}
			end
			local toDelete = nil
			local lineHeight = 30
			local lineSpacing = 5
			local mousePos = imgui.GetMousePos()
			local childPos = imgui.GetWindowPos()
			local scrollY = imgui.GetScrollY()
			local n = #commandRPSystem.editorLines
			local targetInsertIndex = nil
			local dragOffsetY = nil
			if commandRPSystem.draggingLineIndex and commandRPSystem.draggingLineIndex > 0 and commandRPSystem.draggingLineIndex <= n then
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
				local line = commandRPSystem.editorLines[i]
				if not line then
					commandRPSystem.editorLines[i] = {text = imgui.new.char[512]()}
					line = commandRPSystem.editorLines[i]
				end
				local skipLine = (commandRPSystem.draggingLineIndex == i)
				if commandRPSystem.draggingLineIndex and targetInsertIndex == i and targetInsertIndex ~= commandRPSystem.draggingLineIndex then
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
						dragText = fa.ICON_FA_ARROWS_ALT_V  or '↕'
					end
					if imgui.Button(dragText .. '##drag' .. i, imgui.ImVec2(25, 20)) then
					end
					if fa_font then imgui.PopFont() end
					if imgui.IsItemActive() and imgui.IsMouseDragging(0) then
						if not commandRPSystem.draggingLineIndex then
							commandRPSystem.draggingLineIndex = i
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
					imgui.PushItemWidth(-40)
					imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
					imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
					imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
					if commandRPSystem.focusInput == i then
						imgui.SetKeyboardFocusHere()
						commandRPSystem.focusInput = nil
					end
					local enterPressed = imgui.InputText('##cmdLine' .. i, line.text, 512, imgui.InputTextFlags.EnterReturnsTrue)
					imgui.PopStyleColor(3)
					imgui.PopItemWidth()
					if enterPressed then
						local buf = imgui.new.char[512]()
						table.insert(commandRPSystem.editorLines, i + 1, {text = buf})
						commandRPSystem.focusInput = i + 1
						commandRPSystem.scrollToBottom = true
					end
					imgui.SameLine(0, 2)
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(fa('trash_can') .. '##del' .. i, imgui.ImVec2(25, 20)) then
						if n > 1 then toDelete = i end
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(3)
					imgui.PopID()
				else
					imgui.Dummy(imgui.ImVec2(0, lineHeight))
				end
				imgui.Spacing()
			end
			if commandRPSystem.draggingLineIndex and targetInsertIndex == n + 1 then
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
				imgui.Button('← Вставить в конец →##dropzoneend', imgui.ImVec2(-1, 20))
				imgui.PopStyleColor()
			end
			if commandRPSystem.draggingLineIndex then
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
			if commandRPSystem.draggingLineIndex and commandRPSystem.editorLines[commandRPSystem.draggingLineIndex] then
				local drawList = imgui.GetWindowDrawList()
				local line = commandRPSystem.editorLines[commandRPSystem.draggingLineIndex]
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
			if commandRPSystem.draggingLineIndex and not imgui.IsMouseDown(0) then
				if targetInsertIndex and targetInsertIndex ~= commandRPSystem.draggingLineIndex and
					commandRPSystem.draggingLineIndex > 0 and commandRPSystem.draggingLineIndex <= n then
					local movingLine = table.remove(commandRPSystem.editorLines, commandRPSystem.draggingLineIndex)
					if movingLine then
						local insertPos = targetInsertIndex
						if insertPos > commandRPSystem.draggingLineIndex then
							insertPos = insertPos - 1
						end
						insertPos = math.max(1, math.min(insertPos, #commandRPSystem.editorLines + 1))
						table.insert(commandRPSystem.editorLines, insertPos, movingLine)
					end
				end
				commandRPSystem.draggingLineIndex = nil
				dragOffsetY = nil
			end
			if not commandRPSystem.draggingLineIndex then
				imgui.Dummy(imgui.ImVec2(25, 20))
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0]*0.5, item[1]*0.5, item[2]*0.5, item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*0.9, item[1]*0.9, item[2]*0.9, item[3]))
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.5))
				local buttonWidth = imgui.GetContentRegionAvail().x - 30
				local buttonText = 'Нажмите Enter '
				if fa_font then
					imgui.PushFont(fa_font)
					buttonText = buttonText .. fa('arrow_turn_down_left')
					imgui.PopFont()
				end
				buttonText = buttonText .. ' или кликните чтобы добавить строку.##addcmdline'
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20)) then
					local buf = imgui.new.char[512]()
					table.insert(commandRPSystem.editorLines, {text = buf})
					commandRPSystem.focusInput = #commandRPSystem.editorLines
					commandRPSystem.scrollToBottom = true
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(4)
				imgui.SameLine()
				imgui.Dummy(imgui.ImVec2(25, 20))
			end
			if toDelete and toDelete > 0 and toDelete <= #commandRPSystem.editorLines then
				table.remove(commandRPSystem.editorLines, toDelete)
			end
			if commandRPSystem.scrollToBottom then
				imgui.SetScrollHereY(1.0)
				commandRPSystem.scrollToBottom = false
			end
			imgui.EndChild()
			imgui.Separator()
			local btnWidth = (imgui.GetWindowWidth() - 30) / 2
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(btnWidth, 30)) then
				commandRPSystem.editWindow[0] = false
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(btnWidth, 30)) then
				saveAllNewsButtonsData()
				commandRPSystem.editWindow[0] = false
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.End()
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 46
	imgui.OnFrame(function() return commandRPSystem.newCmdWindow[0] or anim.commandRP.newCmdWindow.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.commandRP.newCmdWindow.lastFrameTime then
			anim.commandRP.newCmdWindow.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.commandRP.newCmdWindow.lastFrameTime
		anim.commandRP.newCmdWindow.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if commandRPSystem.newCmdWindow[0] and anim.commandRP.newCmdWindow.isClosing then
			anim.commandRP.newCmdWindow.alpha = 0
			anim.commandRP.newCmdWindow.scale = 0.85
			anim.commandRP.newCmdWindow.offsetY = 30
			anim.commandRP.newCmdWindow.targetAlpha = 1
			anim.commandRP.newCmdWindow.targetScale = 1
			anim.commandRP.newCmdWindow.targetOffsetY = 0
			anim.commandRP.newCmdWindow.spreadProgress = 0
			anim.commandRP.newCmdWindow.targetSpreadProgress = 1
			anim.commandRP.newCmdWindow.isClosing = false
			anim.commandRP.newCmdWindow.fixedTopY = nil
		end
		if not commandRPSystem.newCmdWindow[0] and anim.commandRP.newCmdWindow.alpha > 0.01 and not anim.commandRP.newCmdWindow.isClosing then
			anim.commandRP.newCmdWindow.targetAlpha = 0
			anim.commandRP.newCmdWindow.targetScale = 0.85
			anim.commandRP.newCmdWindow.targetOffsetY = 30
			anim.commandRP.newCmdWindow.targetSpreadProgress = 0
			anim.commandRP.newCmdWindow.isClosing = true
		end
		anim.commandRP.newCmdWindow.alpha = math.min(anim.commandRP.newCmdWindow.alpha + (anim.commandRP.newCmdWindow.targetAlpha - anim.commandRP.newCmdWindow.alpha) * anim.commandRP.newCmdWindow.animSpeed * speedMultiplier, 1)
		anim.commandRP.newCmdWindow.scale = anim.commandRP.newCmdWindow.scale + (anim.commandRP.newCmdWindow.targetScale - anim.commandRP.newCmdWindow.scale) * anim.commandRP.newCmdWindow.animSpeed * speedMultiplier
		anim.commandRP.newCmdWindow.offsetY = anim.commandRP.newCmdWindow.offsetY + (anim.commandRP.newCmdWindow.targetOffsetY - anim.commandRP.newCmdWindow.offsetY) * anim.commandRP.newCmdWindow.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.commandRP.newCmdWindow.isClosing and (anim.commandRP.newCmdWindow.animSpeed * 1.2 * speedMultiplier) or (anim.commandRP.newCmdWindow.animSpeed * 1 * speedMultiplier)
		anim.commandRP.newCmdWindow.spreadProgress = anim.commandRP.newCmdWindow.spreadProgress + (anim.commandRP.newCmdWindow.targetSpreadProgress - anim.commandRP.newCmdWindow.spreadProgress) * spreadAnimSpeed
		anim.commandRP.newCmdWindow.spreadProgress = math.max(0, math.min(anim.commandRP.newCmdWindow.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.commandRP.newCmdWindow.spreadProgress * 0.7
		local scaledWidth = anim.commandRP.newCmdWindow.currentTabWidth * anim.commandRP.newCmdWindow.scale * spreadScale
		local scaledHeight = anim.commandRP.newCmdWindow.currentTabHeight * anim.commandRP.newCmdWindow.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.commandRP.newCmdWindow.alpha)
		local bg = settings.colors.background
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Новая команда##newCommandRP', commandRPSystem.newCmdWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
			imgui.Text('Название команды (без /):')
			imgui.PushItemWidth(-1)
			local enterPressed = imgui.InputText('##newCmdName', commandRPSystem.newCmdName, 64, imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopItemWidth()
			if enterPressed then
				addNewCommandRP()
			end
			imgui.Spacing()
			local btnWidth = (imgui.GetWindowWidth() - 30) / 2
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button('Отмена', imgui.ImVec2(btnWidth, 30)) then
				commandRPSystem.newCmdWindow[0] = false
				ffi.fill(commandRPSystem.newCmdName, 64)
			end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
			if imgui.Button('Создать', imgui.ImVec2(btnWidth, 30)) then
				addNewCommandRP()
			end
			imgui.PopStyleColor(3)
			imgui.End()
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 46
	imgui.OnFrame(function() return commandRPSystem.window[0] or anim.commandRP.window.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.commandRP.window.lastFrameTime then
			anim.commandRP.window.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.commandRP.window.lastFrameTime
		anim.commandRP.window.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if commandRPSystem.window[0] and anim.commandRP.window.isClosing then
			anim.commandRP.window.alpha = 0
			anim.commandRP.window.scale = 0.85
			anim.commandRP.window.offsetY = 30
			anim.commandRP.window.targetAlpha = 1
			anim.commandRP.window.targetScale = 1
			anim.commandRP.window.targetOffsetY = 0
			anim.commandRP.window.spreadProgress = 0
			anim.commandRP.window.targetSpreadProgress = 1
			anim.commandRP.window.isClosing = false
			anim.commandRP.window.fixedTopY = nil
		end
		if not commandRPSystem.window[0] and anim.commandRP.window.alpha > 0.01 and not anim.commandRP.window.isClosing then
			anim.commandRP.window.targetAlpha = 0
			anim.commandRP.window.targetScale = 0.85
			anim.commandRP.window.targetOffsetY = 30
			anim.commandRP.window.targetSpreadProgress = 0
			anim.commandRP.window.isClosing = true
		end
		anim.commandRP.window.alpha = math.min(anim.commandRP.window.alpha + (anim.commandRP.window.targetAlpha - anim.commandRP.window.alpha) * anim.commandRP.window.animSpeed * speedMultiplier, 1)
		anim.commandRP.window.scale = anim.commandRP.window.scale + (anim.commandRP.window.targetScale - anim.commandRP.window.scale) * anim.commandRP.window.animSpeed * speedMultiplier
		anim.commandRP.window.offsetY = anim.commandRP.window.offsetY + (anim.commandRP.window.targetOffsetY - anim.commandRP.window.offsetY) * anim.commandRP.window.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.commandRP.window.isClosing and (anim.commandRP.window.animSpeed * 1.2 * speedMultiplier) or (anim.commandRP.window.animSpeed * 1 * speedMultiplier)
		anim.commandRP.window.spreadProgress = anim.commandRP.window.spreadProgress + (anim.commandRP.window.targetSpreadProgress - anim.commandRP.window.spreadProgress) * spreadAnimSpeed
		anim.commandRP.window.spreadProgress = math.max(0, math.min(anim.commandRP.window.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.commandRP.window.spreadProgress * 0.7
		local scaledWidth = anim.commandRP.window.currentTabWidth * anim.commandRP.window.scale * spreadScale
		local scaledHeight = anim.commandRP.window.currentTabHeight * anim.commandRP.window.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if commandRPSystem.window[0] and not anim.commandRP.window.fixedTopY then
			anim.commandRP.window.fixedTopY = sizeY / 2 - anim.commandRP.window.currentTabHeight / 2
		end
		local animY = anim.commandRP.window.fixedTopY or sizeY / 2
		if anim.commandRP.window.spreadProgress < 1 then
			animY = sizeY / 2 + (anim.commandRP.window.fixedTopY - sizeY / 2) * anim.commandRP.window.spreadProgress
		end
		if anim.commandRP.window.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.commandRP.window.alpha)
		local bg = settings.colors.background or {0.1, 0.1, 0.1}
		local item = settings.colors.itemButtons or {0.2, 0.2, 0.2}
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 1))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Команды с отыгровками##commandRPMain', commandRPSystem.window, imgui.WindowFlags.NoCollapse) then
			renderCommandRPWindow()
			imgui.End()
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(4)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 50
	imgui.OnFrame(function() return panels.playerMenu.open[0] or anim.panels.playerMenu.alpha > 0.01 end, function(self)
		if panels.playerMenu.open[0] and not panels.playerMenu.initialized then
			panels.playerMenu.initialized = true
			if data.rankNumber >= 9 then
				panels.playerMenu.currentTab = 'management'
			elseif data.rankNumber >= 8 then
				panels.playerMenu.currentTab = 'handbook'
			elseif data.rankNumber >= 2 then
				panels.playerMenu.currentTab = 'interview'
			else
				panels.playerMenu.currentTab = 'custom'
			end
		end
		if not panels.playerMenu.open[0] then
			panels.playerMenu.initialized = false
		end
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.panels.playerMenu.lastFrameTime then
			anim.panels.playerMenu.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.panels.playerMenu.lastFrameTime
		anim.panels.playerMenu.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if not anim.panels.playerMenu.currentTabWidth or anim.panels.playerMenu.currentTabWidth == 0 then
			anim.panels.playerMenu.currentTabWidth = 400
		end
		if not anim.panels.playerMenu.currentTabHeight or anim.panels.playerMenu.currentTabHeight == 0 then
			anim.panels.playerMenu.currentTabHeight = 600
		end
		if anim.panels.playerMenu.spreadProgress == nil then
			anim.panels.playerMenu.spreadProgress = 0
			anim.panels.playerMenu.targetSpreadProgress = 1
		end
		if anim.panels.playerMenu.isClosing then
			self.HideCursor = true
		elseif panels.playerMenu.open[0] then
			self.HideCursor = false
		end
		if panels.playerMenu.open[0] and anim.panels.playerMenu.isClosing then
			anim.panels.playerMenu.alpha = 0
			anim.panels.playerMenu.scale = 0.85
			anim.panels.playerMenu.offsetY = 30
			anim.panels.playerMenu.targetAlpha = 1
			anim.panels.playerMenu.targetScale = 1
			anim.panels.playerMenu.targetOffsetY = 0
			anim.panels.playerMenu.spreadProgress = 0
			anim.panels.playerMenu.targetSpreadProgress = 1
			anim.panels.playerMenu.isClosing = false
			anim.panels.playerMenu.fixedTopY = nil
		end
		if not panels.playerMenu.open[0] and anim.panels.playerMenu.alpha > 0.01 and not anim.panels.playerMenu.isClosing then
			anim.panels.playerMenu.targetAlpha = 0
			anim.panels.playerMenu.targetScale = 0.85
			anim.panels.playerMenu.targetOffsetY = 30
			anim.panels.playerMenu.targetSpreadProgress = 0
			anim.panels.playerMenu.isClosing = true
		end
		anim.panels.playerMenu.alpha = math.min(anim.panels.playerMenu.alpha + (anim.panels.playerMenu.targetAlpha - anim.panels.playerMenu.alpha) * anim.panels.playerMenu.animSpeed * speedMultiplier, 1)
		anim.panels.playerMenu.scale = math.min(anim.panels.playerMenu.scale + (anim.panels.playerMenu.targetScale - anim.panels.playerMenu.scale) * anim.panels.playerMenu.animSpeed * speedMultiplier, 1)
		anim.panels.playerMenu.offsetY = anim.panels.playerMenu.offsetY + (anim.panels.playerMenu.targetOffsetY - anim.panels.playerMenu.offsetY) * anim.panels.playerMenu.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.panels.playerMenu.isClosing and (anim.panels.playerMenu.animSpeed * 1.2 * speedMultiplier) or (anim.panels.playerMenu.animSpeed * 1 * speedMultiplier)
		anim.panels.playerMenu.spreadProgress = anim.panels.playerMenu.spreadProgress + 
			(anim.panels.playerMenu.targetSpreadProgress - anim.panels.playerMenu.spreadProgress) * spreadAnimSpeed
		anim.panels.playerMenu.spreadProgress = math.max(0, math.min(anim.panels.playerMenu.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.panels.playerMenu.spreadProgress * 0.7
		local scaledWidth = anim.panels.playerMenu.currentTabWidth * anim.panels.playerMenu.scale * spreadScale
		local scaledHeight = anim.panels.playerMenu.currentTabHeight * anim.panels.playerMenu.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if panels.playerMenu.open[0] and not anim.panels.playerMenu.fixedTopY then
			anim.panels.playerMenu.fixedTopY = sizeY / 2 - anim.panels.playerMenu.currentTabHeight / 2
		end
		local animY = anim.panels.playerMenu.fixedTopY or sizeY / 2
		if anim.panels.playerMenu.spreadProgress < 1 then
			animY = sizeY / 2 + (anim.panels.playerMenu.fixedTopY - sizeY / 2) * anim.panels.playerMenu.spreadProgress
		end
		if anim.panels.playerMenu.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.panels.playerMenu.alpha)
		local bg = settings.colors.background or {0.1, 0.1, 0.1}
		local item = settings.colors.itemButtons or {0.2, 0.2, 0.2}
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 1))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Действия с игроком##playerMenu', panels.playerMenu.open, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
			imgui.Text('ID игрока: ' .. tostring(panels.playerMenu.targetId))
			imgui.Text('Имя: ' .. panels.playerMenu.targetName)
			imgui.Separator()
			imgui.Spacing()
			local currentThemeColors = settings.themes.list.custom.colors
			if not currentThemeColors or not next(currentThemeColors) then 
				currentThemeColors = settings.themes.list.default.colors 
			end
			local tabColor = currentThemeColors["Tab"] or {0.18, 0.35, 0.58, 0.86}
			local tabActiveColor = {math.min(tabColor[1]*1.3, 1), math.min(tabColor[2]*1.3, 1), math.min(tabColor[3]*1.3, 1), tabColor[4]}
			local tabHoveredColor = {math.min(tabColor[1]*1.15, 1), math.min(tabColor[2]*1.15, 1), math.min(tabColor[3]*1.15, 1), tabColor[4]}
			if not panels.playerMenu.currentTab then
				panels.playerMenu.currentTab = 'custom'
			end
			imgui.BeginChild('##PlayerMenuTabs', imgui.ImVec2(0, 50), true)
			if not anim.panels.playerMenu.tabAnimations then
				anim.panels.playerMenu.tabAnimations = {}
			end
			if not anim.panels.playerMenu.offsetAnimations then
				anim.panels.playerMenu.offsetAnimations = {}
			end
			local tabNames = {
				{icon = fa('sliders'), text = ' Управление', num = 'management', tooltip = 'Управление', visible = data.rankNumber >= 9},
				{icon = fa('comments'), text = ' Собеседование', num = 'interview', tooltip = 'Собеседование', visible = data.rankNumber >= 2},
				{icon = fa('book'), text = ' Справочник', num = 'handbook', tooltip = 'Справочник', visible = data.rankNumber >= 8},
				{icon = fa('plus'), text = ' Своя', num = 'custom', tooltip = 'Своя вкладка', visible = true},
			}
			imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 10)
			local startY = imgui.GetCursorPosY()
			for i, tab in ipairs(tabNames) do
				if tab.visible then
					if not anim.panels.playerMenu.tabAnimations[tab.num] then
						anim.panels.playerMenu.tabAnimations[tab.num] = 0
					end
					if not anim.panels.playerMenu.offsetAnimations[tab.num] then
						anim.panels.playerMenu.offsetAnimations[tab.num] = 0
					end
					local isSelected = panels.playerMenu.currentTab == tab.num
					local targetScale = isSelected and 1 or 0
					local speed = 0.25
					anim.panels.playerMenu.tabAnimations[tab.num] = anim.panels.playerMenu.tabAnimations[tab.num] + (targetScale - anim.panels.playerMenu.tabAnimations[tab.num]) * speed * speedMultiplier
					local animValue = anim.panels.playerMenu.tabAnimations[tab.num]
					local targetOffset = (animValue > 0.01) and 0 or 2.9
					local offsetSpeed = 0.25
					anim.panels.playerMenu.offsetAnimations[tab.num] = anim.panels.playerMenu.offsetAnimations[tab.num] + (targetOffset - anim.panels.playerMenu.offsetAnimations[tab.num]) * offsetSpeed * speedMultiplier
					imgui.PushStyleColor(imgui.Col.Button, tabColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, tabActiveColor)
					imgui.PushStyleColor(imgui.Col.ButtonActive, tabActiveColor)
					if i > 1 then imgui.SameLine(0, 5) end
					local btnHeight = 25 + animValue * 5
					imgui.SetCursorPosY(startY + anim.panels.playerMenu.offsetAnimations[tab.num])
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(tab.icon .. tab.text .. '##pmtab' .. tab.num, imgui.ImVec2(90, btnHeight)) then
						if not panels.editor.open[0] then
							panels.playerMenu.currentTab = tab.num
						end
					end
					if fa_font then imgui.PopFont() end
					if imgui.IsItemHovered() then
						anim.panels.playerMenu.tabAnimations[tab.num] = math.min(anim.panels.playerMenu.tabAnimations[tab.num] + 0.3, 1)
						imgui.BeginTooltip()
						imgui.Text(tab.tooltip)
						imgui.EndTooltip()
					end
					imgui.PopStyleColor(3)
				end
			end
			imgui.PopStyleVar(1)
			imgui.EndChild()
			imgui.Spacing()
			local contentHeight = imgui.GetWindowHeight() - 200
			imgui.BeginChild('##PlayerMenuContent', imgui.ImVec2(0, contentHeight), true)
			if not panels.playerMenu.currentTab then panels.playerMenu.currentTab = 'custom' end
			renderPanelsTab(panels.playerMenu.currentTab)
			imgui.EndChild()
			imgui.Spacing()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
			if imgui.Button('Закрыть', imgui.ImVec2(-1, 30)) then 
				panels.playerMenu.open[0] = false 
			end
			imgui.PopStyleColor(3)
			imgui.End()
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(4)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then popBaseColors(colorCount) else popRgbColors(colorCount) end
		end
	end).Priority = settings.renderPriority + 55
	imgui.OnFrame(function() return panels.main[0] or panels.editor.open[0] or panels.input.open[0] or anim.panels.main.alpha > 0.01 or anim.panels.editor.alpha > 0.01 or anim.panels.input.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.panels.main.lastFrameTime then
			anim.panels.main.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.panels.main.lastFrameTime
		anim.panels.main.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if not anim.panels.main.currentTabWidth or anim.panels.main.currentTabWidth == 0 then
			anim.panels.main.currentTabWidth = 800
		end
		if not anim.panels.main.currentTabHeight or anim.panels.main.currentTabHeight == 0 then
			anim.panels.main.currentTabHeight = 600
		end
		if anim.panels.main.spreadProgress == nil then
			anim.panels.main.spreadProgress = 0
			anim.panels.main.targetSpreadProgress = 1
		end
		if anim.panels.main.isClosing then
			if not panels.input.open[0] then
				self.HideCursor = true
			end
		elseif panels.main[0] then
			self.HideCursor = false
		end
		if panels.main[0] and anim.panels.main.isClosing then
			anim.panels.main.alpha = 0
			anim.panels.main.scale = 0.85
			anim.panels.main.offsetY = 30
			anim.panels.main.targetAlpha = 1
			anim.panels.main.targetScale = 1
			anim.panels.main.targetOffsetY = 0
			anim.panels.main.spreadProgress = 0
			anim.panels.main.targetSpreadProgress = 1
			anim.panels.main.isClosing = false
			anim.panels.main.fixedTopY = nil
		end
		if not panels.main[0] and anim.panels.main.alpha > 0.01 and not anim.panels.main.isClosing then
			anim.panels.main.targetAlpha = 0
			anim.panels.main.targetScale = 0.85
			anim.panels.main.targetOffsetY = 30
			anim.panels.main.targetSpreadProgress = 0
			anim.panels.main.isClosing = true
		end
		anim.panels.main.alpha = math.min(anim.panels.main.alpha + (anim.panels.main.targetAlpha - anim.panels.main.alpha) * anim.panels.main.animSpeed * speedMultiplier, 1)
		anim.panels.main.scale = math.min(anim.panels.main.scale + (anim.panels.main.targetScale - anim.panels.main.scale) * anim.panels.main.animSpeed * speedMultiplier, 1)
		anim.panels.main.offsetY = anim.panels.main.offsetY + (anim.panels.main.targetOffsetY - anim.panels.main.offsetY) * anim.panels.main.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.panels.main.isClosing and (anim.panels.main.animSpeed * 1.2 * speedMultiplier) or (anim.panels.main.animSpeed * 1 * speedMultiplier)
		anim.panels.main.spreadProgress = anim.panels.main.spreadProgress + 
			(anim.panels.main.targetSpreadProgress - anim.panels.main.spreadProgress) * spreadAnimSpeed
		anim.panels.main.spreadProgress = math.max(0, math.min(anim.panels.main.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.panels.main.spreadProgress * 0.7
		local scaledWidth = anim.panels.main.currentTabWidth * anim.panels.main.scale * spreadScale
		local scaledHeight = anim.panels.main.currentTabHeight * anim.panels.main.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if panels.main[0] and not anim.panels.main.fixedTopY then
			anim.panels.main.fixedTopY = sizeY / 2 - anim.panels.main.currentTabHeight / 2
		end
		local animY = anim.panels.main.fixedTopY or sizeY / 2
		if anim.panels.main.spreadProgress < 1 and anim.panels.main.fixedTopY then
			animY = sizeY / 2 + (anim.panels.main.fixedTopY - sizeY / 2) * anim.panels.main.spreadProgress
		end
		if anim.panels.main.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.panels.main.alpha)
		local bg = settings.colors.background or {0.1, 0.1, 0.1}
		local item = settings.colors.itemButtons or {0.2, 0.2, 0.2}
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 1))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Панель заместителя##rsMain', panels.main, imgui.WindowFlags.NoCollapse) then
			local currentThemeColors = settings.themes.list.custom.colors
			if not currentThemeColors or not next(currentThemeColors) then 
				currentThemeColors = settings.themes.list.default.colors 
			end
			local tabColor = currentThemeColors["Tab"] or {0.18, 0.35, 0.58, 0.86}
			local tabActiveColor = {math.min(tabColor[1]*1.3, 1), math.min(tabColor[2]*1.3, 1), math.min(tabColor[3]*1.3, 1), tabColor[4]}
			local tabHoveredColor = {math.min(tabColor[1]*1.15, 1), math.min(tabColor[2]*1.15, 1), math.min(tabColor[3]*1.15, 1), tabColor[4]}
			if not panels.currentTab then
				panels.currentTab = 'management'
			end
			imgui.BeginChild('##RSEditorTabsBar', imgui.ImVec2(0, 50), true)
			if not anim.panels.main.tabAnimations then
				anim.panels.main.tabAnimations = {}
			end
			if not anim.panels.main.offsetAnimations then
				anim.panels.main.offsetAnimations = {}
			end
			local tabNames = {
				{icon = fa('sliders'), text = ' Управление', num = 'management', tooltip = 'Управление', visible = data.rankNumber >= 9},
				{icon = fa('comments'), text = ' Собеседование', num = 'interview', tooltip = 'Собеседование', visible = data.rankNumber >= 2},
				{icon = fa('book'), text = ' Справочник', num = 'handbook', tooltip = 'Справочник', visible = data.rankNumber >= 8},
				{icon = fa('plus'), text = ' Своя', num = 'custom', tooltip = 'Своя вкладка', visible = true},
			}
			imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 10)
			local startY = imgui.GetCursorPosY()
			for i, tab in ipairs(tabNames) do
				if tab.visible then
					if not anim.panels.main.tabAnimations[tab.num] then
						anim.panels.main.tabAnimations[tab.num] = 0
					end
					if not anim.panels.main.offsetAnimations[tab.num] then
						anim.panels.main.offsetAnimations[tab.num] = 0
					end
					local isSelected = panels.currentTab == tab.num
					local targetScale = isSelected and 1 or 0
					local speed = 0.25
					anim.panels.main.tabAnimations[tab.num] = anim.panels.main.tabAnimations[tab.num] + (targetScale - anim.panels.main.tabAnimations[tab.num]) * speed * speedMultiplier
					local animValue = anim.panels.main.tabAnimations[tab.num]
					local targetOffset = (animValue > 0.01) and 0 or 2.9
					local offsetSpeed = 0.25
					anim.panels.main.offsetAnimations[tab.num] = anim.panels.main.offsetAnimations[tab.num] + (targetOffset - anim.panels.main.offsetAnimations[tab.num]) * offsetSpeed * speedMultiplier
					imgui.PushStyleColor(imgui.Col.Button, tabColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, tabActiveColor)
					imgui.PushStyleColor(imgui.Col.ButtonActive, tabActiveColor)
					if i > 1 then imgui.SameLine(0, 5) end
					local btnHeight = 25 + animValue * 5
					imgui.SetCursorPosY(startY + anim.panels.main.offsetAnimations[tab.num])
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(tab.icon .. tab.text .. '##mstab' .. tab.num, imgui.ImVec2(110, btnHeight)) then
						panels.currentTab = tab.num
					end
					if fa_font then imgui.PopFont() end
					if imgui.IsItemHovered() then
						anim.panels.main.tabAnimations[tab.num] = math.min(anim.panels.main.tabAnimations[tab.num] + 0.3, 1)
						imgui.BeginTooltip()
						imgui.Text(tab.tooltip)
						imgui.EndTooltip()
					end
					imgui.PopStyleColor(3)
				end
			end
			imgui.PopStyleVar(1)
			imgui.EndChild()
			imgui.Spacing()
			imgui.BeginChild('##RSEditorContent', imgui.ImVec2(0, 0), true)
			if not panels.currentTab then panels.currentTab = 'management' end
			renderPanelsEditorTab(panels.currentTab)
			imgui.EndChild()
			imgui.End()
		end
		if panels.editor.open[0] or anim.panels.editor.alpha > 0.01 then
			local currentTime = os.clock()
			if not anim.panels.editor.lastFrameTime then
				anim.panels.editor.lastFrameTime = currentTime
			end
			local deltaTime = currentTime - anim.panels.editor.lastFrameTime
			anim.panels.editor.lastFrameTime = currentTime
			local edSpeedMultiplier = math.min(deltaTime * 60, 1)
			if panels.editor.open[0] and anim.panels.editor.isClosing then
				anim.panels.editor.alpha = 0
				anim.panels.editor.scale = 0.85
				anim.panels.editor.targetAlpha = 1
				anim.panels.editor.targetScale = 1
				anim.panels.editor.isClosing = false
			end
			if not panels.editor.open[0] and anim.panels.editor.alpha > 0.01 and not anim.panels.editor.isClosing then
				anim.panels.editor.targetAlpha = 0
				anim.panels.editor.targetScale = 0.85
				anim.panels.editor.isClosing = true
			end
			anim.panels.editor.alpha = math.min(anim.panels.editor.alpha + (anim.panels.editor.targetAlpha - anim.panels.editor.alpha) * anim.panels.editor.animSpeed * edSpeedMultiplier, 1)
			anim.panels.editor.scale = math.min(anim.panels.editor.scale + (anim.panels.editor.targetScale - anim.panels.editor.scale) * anim.panels.editor.animSpeed * edSpeedMultiplier, 1)
			local sizeX, sizeY = getScreenResolution()
			local scaledWidth = anim.panels.editor.currentTabWidth * anim.panels.editor.scale
			local scaledHeight = anim.panels.editor.currentTabHeight * anim.panels.editor.scale
			imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2, sizeY/2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			self.HideCursor = false
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.panels.editor.alpha)
			local item = settings.colors.itemButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Begin('Редактор действия##editor', panels.editor.open, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
				imgui.Text('Название:')
				imgui.SameLine()
				imgui.PushItemWidth(300)
				imgui.InputText('##editName', panels.editor.editingName, 256)
				imgui.PopItemWidth()
				imgui.SameLine(0, 20)
				imgui.Text('Задержка (мс):')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(250)
					imgui.TextColored(imgui.ImVec4(0.7, 0.3, 1, 1), 'Задержка между строками:')
					imgui.Separator()
					imgui.TextWrapped('Время в миллисекундах перед отправкой каждой строки.')
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'Минимум: 500 мс')
					imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'Максимум: 10000 мс')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if not panels.rs.settings.globalDelay then
					panels.rs.settings.globalDelay = 3000
				end
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button('-##DecDelay', imgui.ImVec2(25, 20)) then
					panels.rs.settings.globalDelay = math.max(500, panels.rs.settings.globalDelay - 100)
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				local delayInput = imgui.new.int(panels.rs.settings.globalDelay)
				imgui.PushItemWidth(60)
				if imgui.InputInt('##RSDelay', delayInput, 0, 0) then
					local value = delayInput[0]
					if value < 500 then value = 500 end
					if value > 10000 then value = 10000 end
					panels.rs.settings.globalDelay = value
				end
				imgui.PopItemWidth()
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button('+##IncDelay', imgui.ImVec2(25, 20)) then
					panels.rs.settings.globalDelay = math.min(10000, panels.rs.settings.globalDelay + 100)
				end
				imgui.PopStyleColor(3)
				imgui.SameLine(0, 5)
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button('Переменные##varsBtn', imgui.ImVec2(85, 20)) then
					imgui.OpenPopup('VariablesPopup##edit')
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Доступные переменные для подстановки')
				end
				if imgui.BeginPopup('VariablesPopup##edit', imgui.WindowFlags.AlwaysAutoResize) then
					imgui.Text('Доступные переменные:')
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Игрок:')
					imgui.Spacing()
					local playerVars = {
						{'<myid>', 'Ваш ID'},
						{'<mynick>', 'Ваш ник (с транслитерацией)'},
						{'<mynickeng>', 'Ваш ник (оригинал)'},
						{'<myrang>', 'Ваша должность'},
						{'<closeid>', 'ID ближайшего игрока'},
						{'<closenick>', 'Ник ближайшего (с транслитерацией)'},
						{'<closenickeng>', 'Ник ближайшего (оригинал)'},
					}
					for _, var in ipairs(playerVars) do
						local key, desc = var[1], var[2]
						imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
						if imgui.IsItemClicked(0) then
							imgui.SetClipboardText(key)
							AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip('Нажмите для копирования')
						end
						imgui.SameLine()
						imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
						imgui.Spacing()
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Выбранный игрок:')
					imgui.Spacing()
					local targetVars = {
						{'<targetid>', 'ID выбранного игрока'},
						{'<targetnick>', 'Ник выбранного (с транслитерацией)'},
						{'<targetnickeng>', 'Ник выбранного (оригинал)'},
					}
					for _, var in ipairs(targetVars) do
						local key, desc = var[1], var[2]
						imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
						if imgui.IsItemClicked(0) then
							imgui.SetClipboardText(key)
							AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip('Нажмите для копирования')
						end
						imgui.SameLine()
						imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
						imgui.Spacing()
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Экран:')
					imgui.Spacing()
					local screenVars = {
						{'<closeidtocenter>', 'ID ближайшего к центру экрана'},
						{'<closennicktocenter>', 'Ник ближайшего к центру (с транслитерацией)'},
						{'<closennicktocentereng>', 'Ник ближайшего к центру (оригинал)'},
					}
					for _, var in ipairs(screenVars) do
						local key, desc = var[1], var[2]
						imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
						if imgui.IsItemClicked(0) then
							imgui.SetClipboardText(key)
							AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip('Нажмите для копирования')
						end
						imgui.SameLine()
						imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
						imgui.Spacing()
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Поиск игрока по нику:')
					imgui.Spacing()
					local searchVars = {
						{'<id@NickName>', 'ID игрока по нику (пример: <id@PlayerNick>)'},
					}
					for _, var in ipairs(searchVars) do
						local key, desc = var[1], var[2]
						imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
						if imgui.IsItemClicked(0) then
							imgui.SetClipboardText(key)
							AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip('Нажмите для копирования')
						end
						imgui.SameLine()
						imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
						imgui.Spacing()
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Время (h - час, m - минуты, d - день, M - месяц, y - год):')
					imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Всегда после time идет : затем буквы и разделители.')
					imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Разделители сохраняются: <time:h.m> → 14.30, <time:h:m> → 14:30')
					imgui.Spacing()
					local timeVars = {
						{'<time:h:m>', 'Час и минуты (14:30)'},
						{'<time:h.m>', 'Час и минуты (14.30)'},
						{'<time:d.M.y>', 'Полная дата (12.12.2025)'},
						{'<time:d:M:y>', 'Полная дата (12:12:2025)'},
						{'<time:h>', 'Час'},
						{'<time:m>', 'Минуты'},
						{'<time:d>', 'День'},
						{'<time:M>', 'Месяц'},
						{'<time:y>', 'Год'},
					}
					for _, var in ipairs(timeVars) do
						local key, desc = var[1], var[2]
						imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
						if imgui.IsItemClicked(0) then
							imgui.SetClipboardText(key)
							AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip('Нажмите для копирования')
						end
						imgui.SameLine()
						imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
						imgui.Spacing()
					end
					imgui.EndPopup()
				end
				local inputBg = imgui.ImVec4(item[0]*0.5, item[1]*0.5, item[2]*0.5, item[3])
				local inputBgHover = imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3])
				local inputBgActive = imgui.ImVec4(item[0]*0.9, item[1]*0.9, item[2]*0.9, item[3])
				local contentHeight = imgui.GetWindowHeight() - 130
				imgui.BeginChild('##editorLines', imgui.ImVec2(0, contentHeight), true)
				if not panels.editor.lines or #panels.editor.lines == 0 then
					panels.editor.lines = {{text = imgui.new.char[512]()}}
				end
				local toDelete = nil
				local lineHeight = 30
				local lineSpacing = 5
				local mousePos = imgui.GetMousePos()
				local childPos = imgui.GetWindowPos()
				local scrollY = imgui.GetScrollY()
				local n = #panels.editor.lines
				local targetInsertIndex = nil
				local dragOffsetY = nil
				if panels.editor.draggingLineIndex and panels.editor.draggingLineIndex > 0 and panels.editor.draggingLineIndex <= n then
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
					local line = panels.editor.lines[i]
					if not line then
						panels.editor.lines[i] = { text = imgui.new.char[512]() }
						line = panels.editor.lines[i]
					end
					local skipLine = (panels.editor.draggingLineIndex == i)
					if panels.editor.draggingLineIndex and targetInsertIndex == i and targetInsertIndex ~= panels.editor.draggingLineIndex then
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
							if not panels.editor.draggingLineIndex then
								panels.editor.draggingLineIndex = i
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
						imgui.PushItemWidth(-40)
						imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
						imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
						imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
						if panels.editor.focusInput == i then
							imgui.SetKeyboardFocusHere()
							panels.editor.focusInput = nil
						end
						local enterPressed = imgui.InputText('##line' .. i, line.text, 512, imgui.InputTextFlags.EnterReturnsTrue)
						imgui.PopStyleColor(3)
						imgui.PopItemWidth()
						if enterPressed then
							table.insert(panels.editor.lines, i + 1, {text = imgui.new.char[512]()})
							panels.editor.focusInput = i + 1
							panels.editor.scrollToBottom = true
						end
						imgui.SameLine(0, 2)
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if fa_font then imgui.PushFont(fa_font) end
						if imgui.Button(fa('trash_can') .. '##del' .. i, imgui.ImVec2(25, 20)) then
							if n > 1 then toDelete = i end
						end
						if fa_font then imgui.PopFont() end
						imgui.PopStyleColor(3)
						imgui.PopID()
					else
						imgui.Dummy(imgui.ImVec2(0, lineHeight))
					end
					imgui.Spacing()
				end
				if panels.editor.draggingLineIndex and targetInsertIndex == n + 1 then
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
					imgui.Button('← Вставить в конец →##dropzoneend', imgui.ImVec2(-1, 20))
					imgui.PopStyleColor()
				end
				if panels.editor.draggingLineIndex then
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
				if panels.editor.draggingLineIndex and panels.editor.lines[panels.editor.draggingLineIndex] then
					local drawList = imgui.GetWindowDrawList()
					local line = panels.editor.lines[panels.editor.draggingLineIndex]
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
				if panels.editor.draggingLineIndex and not imgui.IsMouseDown(0) then
					if targetInsertIndex and targetInsertIndex ~= panels.editor.draggingLineIndex and
						panels.editor.draggingLineIndex > 0 and panels.editor.draggingLineIndex <= n then
						local movingLine = table.remove(panels.editor.lines, panels.editor.draggingLineIndex)
						if movingLine then
							local insertPos = targetInsertIndex
							if insertPos > panels.editor.draggingLineIndex then
								insertPos = insertPos - 1
							end
							insertPos = math.max(1, math.min(insertPos, #panels.editor.lines + 1))
							table.insert(panels.editor.lines, insertPos, movingLine)
						end
					end
					panels.editor.draggingLineIndex = nil
					dragOffsetY = nil
				end
				if not panels.editor.draggingLineIndex then
					imgui.Dummy(imgui.ImVec2(25, 20))
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0]*0.5, item[1]*0.5, item[2]*0.5, item[3]))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3]))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*0.9, item[1]*0.9, item[2]*0.9, item[3]))
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.5))
					local buttonWidth = imgui.GetContentRegionAvail().x - 30
					if fa_font then imgui.PushFont(fa_font) end
					local buttonText = 'Нажмите Enter ' .. fa('arrow_turn_down_left') .. ' или кликните чтобы добавить строку.##addline'
					if fa_font then imgui.PopFont() end
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20)) then
						table.insert(panels.editor.lines, {text = imgui.new.char[512]()})
						panels.editor.focusInput = #panels.editor.lines
						panels.editor.scrollToBottom = true
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(4)
					imgui.SameLine()
					imgui.Dummy(imgui.ImVec2(25, 20))
				end
				if toDelete and toDelete > 0 and toDelete <= #panels.editor.lines then
					table.remove(panels.editor.lines, toDelete)
				end
				if panels.editor.scrollToBottom then
					imgui.SetScrollHereY(1.0)
					panels.editor.scrollToBottom = false
				end
				imgui.EndChild()
				imgui.Separator()
				local btnWidth = (imgui.GetWindowWidth() - 30) / 2
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button('Отмена', imgui.ImVec2(btnWidth, 30)) then
					panels.editor.open[0] = false
					if windowState.editorOpenedFrom == 'main' then
						panels.main[0] = true
					elseif windowState.editorOpenedFrom == 'playerMenu' then
						panels.playerMenu.open[0] = true
					end
					windowState.editorOpenedFrom = nil
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if imgui.Button('Сохранить', imgui.ImVec2(btnWidth, 30)) then
					saveAllNewsButtonsData()
					panels.editor.open[0] = false
					if windowState.editorOpenedFrom == 'main' then
						panels.main[0] = true
					elseif windowState.editorOpenedFrom == 'playerMenu' then
						panels.playerMenu.open[0] = true
					end
					windowState.editorOpenedFrom = nil
				end
				imgui.PopStyleColor(3)
				imgui.End()
			end
			imgui.PopStyleVar(1)
			imgui.PopStyleColor(3)
		end
		if panels.input.open[0] or anim.panels.input.alpha > 0.01 then
			local currentTime = os.clock()
			if not anim.panels.input.lastFrameTime then
				anim.panels.input.lastFrameTime = currentTime
			end
			local deltaTime = currentTime - anim.panels.input.lastFrameTime
			anim.panels.input.lastFrameTime = currentTime
			local inpSpeedMultiplier = math.min(deltaTime * 60, 1)
			if panels.input.open[0] and anim.panels.input.isClosing then
				anim.panels.input.alpha = 0
				anim.panels.input.scale = 0.85
				anim.panels.input.targetAlpha = 1
				anim.panels.input.targetScale = 1
				anim.panels.input.isClosing = false
			end
			if not panels.input.open[0] and anim.panels.input.alpha > 0.01 and not anim.panels.input.isClosing then
				anim.panels.input.targetAlpha = 0
				anim.panels.input.targetScale = 0.85
				anim.panels.input.isClosing = true
			end
			anim.panels.input.alpha = math.min(anim.panels.input.alpha + (anim.panels.input.targetAlpha - anim.panels.input.alpha) * anim.panels.input.animSpeed * inpSpeedMultiplier, 1)
			anim.panels.input.scale = math.min(anim.panels.input.scale + (anim.panels.input.targetScale - anim.panels.input.scale) * anim.panels.input.animSpeed * inpSpeedMultiplier, 1)
			local sizeX, sizeY = getScreenResolution()
			local scaledWidth = anim.panels.input.currentTabWidth * anim.panels.input.scale
			local scaledHeight = anim.panels.input.currentTabHeight * anim.panels.input.scale
			imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2, sizeY/2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.panels.input.alpha)
			local item = settings.colors.itemButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Begin('Ввод##input', panels.input.open, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
				imgui.Text(panels.input.title)
				imgui.PushItemWidth(-1)
				local enterPressed = imgui.InputText('##inputText', panels.input.inputText, 256, imgui.InputTextFlags.EnterReturnsTrue)
				imgui.PopItemWidth()
				imgui.Spacing()
				local btnWidth = (imgui.GetWindowWidth() - 30) / 2
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button('Отмена', imgui.ImVec2(btnWidth, 30)) then
					panels.input.open[0] = false
					ffi.fill(panels.input.inputText, 256)
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if imgui.Button('Создать', imgui.ImVec2(btnWidth, 30)) or enterPressed then
					if panels.input.onConfirm then
						panels.input.onConfirm()
					end
					panels.input.open[0] = false
					ffi.fill(panels.input.inputText, 256)
				end
				imgui.PopStyleColor(3)
				imgui.End()
			end
			imgui.PopStyleVar(1)
			imgui.PopStyleColor(3)
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(4)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then popBaseColors(colorCount) else popRgbColors(colorCount) end
		end
	end).Priority = settings.renderPriority + 50
	imgui.OnFrame(function() return efirRecovery.window[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(500, 273), imgui.Cond.Always)
		local windowFlags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin("Восстановление эфира", efirRecovery.window, windowFlags) then
			if efirRecovery.sessionData then
				local mode = efirRecovery.sessionData.mode == "auto" and "автоматического" or "мануального"
				local efirType = efirRecovery.sessionData.efirType or "неизвестный"
				local efirNames = {
					math = "Математика",
					country = "Столицы",
					himia = "Химия",
					zerkalo = "Зеркало",
					annagramm = "Анаграммы",
					zagadki = "Загадки",
					sinonim = "Синонимы",
					inter = "Интервью",
					reklama = "Реклама",
					sobes = "Собеседование"
				}
				local efirName = efirNames[efirType] or efirType
				imgui.Spacing()
				imgui.Spacing()
				imgui.PushTextWrapPos(imgui.GetWindowWidth() - 20)
				imgui.SetWindowFontScale(1.2)
				imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Обнаружен незавершённый эфир!")
				imgui.SetWindowFontScale(1.0)
				imgui.Spacing()
				imgui.TextWrapped('Вы были на сеансе ' .. mode .. ' эфира "' .. efirName .. '" и скрипт был перезапущен.')
				imgui.Spacing()
				imgui.TextWrapped('Хотите продолжить эфир с того момента, на котором остановились?')
				imgui.PopTextWrapPos()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text("Информация о сеансе:")
				imgui.BulletText("Тип: " .. efirName)
				imgui.BulletText("Режим: " .. (efirRecovery.sessionData.mode == "auto" and "Автоматический" or "Мануальный"))
				if efirRecovery.sessionData.mode == "auto" and efirRecovery.sessionData.auto then
					imgui.BulletText("Вопрос: " .. (efirRecovery.sessionData.auto.currentQuestion or 0) .. " из " .. (efirRecovery.sessionData.auto.totalQuestions or 10))
				elseif efirRecovery.sessionData.mode == "manual" and efirRecovery.sessionData.manual then
					imgui.BulletText("Строка: " .. (efirRecovery.sessionData.manual.currentLine or 1))
				end
				local scoreCount = 0
				for _ in pairs(efirRecovery.sessionData.scoreBoard or {}) do
					scoreCount = scoreCount + 1
				end
				imgui.BulletText("Участников в таблице: " .. scoreCount)
				imgui.Spacing()
				imgui.Spacing()
				local buttonWidth = 200
				local spacing = 20
				local totalWidth = buttonWidth * 2 + spacing
				local startX = (imgui.GetWindowWidth() - totalWidth) / 2
				imgui.SetCursorPosX(startX)
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
				if imgui.Button("Нет, начать заново", imgui.ImVec2(buttonWidth, 40)) then
					clearEfirSession()
					efirRecovery.window[0] = false
					efirRecovery.sessionData = nil
					flags.efirRecoveryHandled = true
					windows.mainSettings[0] = true
					AddNotification("[News Helper]", "Сохранённый эфир удалён", "success", 3.0)
				end
				imgui.PopStyleColor(3)
				imgui.SameLine(0, spacing)
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
				if imgui.Button("Да, продолжить", imgui.ImVec2(buttonWidth, 40)) then
					restoreEfirSession(efirRecovery.sessionData)
					efirRecovery.window[0] = false
					efirRecovery.sessionData = nil
					flags.efirRecoveryHandled = true
				end
				imgui.PopStyleColor(3)
			end
			imgui.End()
		end
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 50
	imgui.OnFrame(function() return windows.contextMenu[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		imgui.SetNextWindowPos(imgui.ImVec2(ui.contextMenu.pos.x, ui.contextMenu.pos.y), imgui.Cond.Always)
		imgui.SetNextWindowSize(imgui.ImVec2(200, 100), imgui.Cond.Always)
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.Begin('КОНТЕКСТНОЕ МЕНЮ', rContextMenu)
		imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'НАЖМИТЕ КЛАВИШУ:')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), '[E] - Редактировать')
		imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), '[X] - Удалить')
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '[ESC] - Закрыть')
		imgui.End()
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end)
	imgui.OnFrame(function() return windows.findReplace[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		local windowWidth, windowHeight = 400, 280
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2 - windowWidth / 2, sizeY / 2 - windowHeight / 2), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(windowWidth, windowHeight), imgui.Cond.FirstUseEver)
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Find and Replace', windows.findReplace, imgui.WindowFlags.NoCollapse) then
			imgui.PopStyleColor(colorCount)
			colorCount = pushRgbColors()
			local inputBg = imgui.ImVec4(item[0]*0.5, item[1]*0.5, item[2]*0.5, item[3])
			local inputBgHover = imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3])
			local inputBgActive = imgui.ImVec4(item[0]*0.9, item[1]*0.9, item[2]*0.9, item[3])
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			imgui.Text('Найти:')
			imgui.InputText('##findText', editor.findReplace.findText, 256)
			imgui.Spacing()
			imgui.Text('Заменить на:')
			imgui.InputText('##replaceText', editor.findReplace.replaceText, 256)
			imgui.PopStyleColor(3)
			imgui.Spacing()
			imgui.Text('Категория:')
			imgui.Spacing()
			local categoryName = editor.findReplace.selectedCategory == 0 and 'Все' or (data.newsHelpBind[editor.findReplace.selectedCategory] and data.newsHelpBind[editor.findReplace.selectedCategory][1] or 'Все')
			local item = settings.colors.itemButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
			if fa_font then imgui.PushFont(fa_font) end
			local buttonText = categoryName .. ' ' .. fa('chevron_down')
			local textSize = imgui.CalcTextSize(buttonText)
			if imgui.Button(buttonText .. '##categorySelect', imgui.ImVec2(textSize.x + 20, 20)) then
				imgui.OpenPopup('CategorySelectPopup##findReplace')
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			if imgui.BeginPopup('CategorySelectPopup##findReplace', imgui.WindowFlags.AlwaysAutoResize) then
				if imgui.Selectable('Все', editor.findReplace.selectedCategory == 0) then
					editor.findReplace.selectedCategory = 0
					imgui.CloseCurrentPopup()
				end
				for i = 1, #data.newsHelpBind do
					local category = data.newsHelpBind[i]
					local catName = category[1] or ''
					if catName ~= settings.bufferCategoryName then
						if imgui.Selectable(catName, editor.findReplace.selectedCategory == i) then
							editor.findReplace.selectedCategory = i
							imgui.CloseCurrentPopup()
						end
					end
				end
				imgui.EndPopup()
			end
			imgui.Spacing()
			imgui.Separator()
			local buttonWidth = (imgui.GetWindowWidth() - 15) / 2
			local cat = settings.colors.categoryButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cat[0], cat[1], cat[2], 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cat[0] * 1.2, cat[1] * 1.2, cat[2] * 1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cat[0] * 1.4, cat[1] * 1.4, cat[2] * 1.4, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 25)) then
				windows.findReplace[0] = false
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			local item = settings.colors.itemButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('arrow_right_arrow_left') .. ' Заменить', imgui.ImVec2(buttonWidth, 25)) then
				performFindAndReplace()
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			if editor.findReplace.replacedCount > 0 then
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), 'Заменено: ' .. editor.findReplace.replacedCount .. ' вхождений')
			end
		end
		imgui.End()
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 60
	imgui.OnFrame(function() return windows.editCategory[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(350, 150), imgui.Cond.Always)
		imgui.SetNextWindowFocus()
		local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove +
							imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar +
							imgui.WindowFlags.NoTitleBar + settings.topMostFlags
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.Begin('##EditCategory', nil, windowFlags)
		bringWindowToFront()
		local titleSize = imgui.CalcTextSize('Редактирование категории')
		imgui.SetCursorPosX((imgui.GetWindowWidth() - titleSize.x) / 2)
		imgui.Text('Редактирование категории')
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Название категории:')
		local bg = imgui.GetStyle().Colors[imgui.Col.WindowBg]
		imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
		imgui.InputText('##CategoryName', editor.edit.categoryName, sizeof(editor.edit.categoryName))
		imgui.PopItemWidth()
		imgui.Spacing()
		local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
		local item = settings.colors.itemButtons
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Выйти', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			windows.editCategory[0] = false
		else
			if fa_font then imgui.PopFont() end
		end
		imgui.SameLine()
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			local newName = str(editor.edit.categoryName)
			if newName ~= '' then
				addToHistory()
				local convertedName = newName
				if editor.edit.categoryIndex == 0 then
					table.insert(data.newsHelpBind, {convertedName})
					chatMessage(u8:decode('[News Helper] Категория создана!'), 0x00FF00)
				else
					data.newsHelpBind[editor.edit.categoryIndex][1] = convertedName
					chatMessage(u8:decode('[News Helper] Категория изменена!'), 0x00FF00)
				end
				windows.editCategory[0] = false
			else
				chatMessage(u8:decode('[News Helper] Введите название категории!'), 0xFF0000)
			end
		else
			if fa_font then imgui.PopFont() end
		end
		imgui.End()
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 90
	imgui.OnFrame(function() return windows.editBind[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(450, 250), imgui.Cond.Always)
		imgui.SetNextWindowFocus()
		local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove +
							imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar +
							imgui.WindowFlags.NoTitleBar + settings.topMostFlags
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.Begin('##EditBind', nil, windowFlags)
		bringWindowToFront()
		local titleSize = imgui.CalcTextSize('Редактирование бинда')
		imgui.SetCursorPosX((imgui.GetWindowWidth() - titleSize.x) / 2)
		imgui.Text('Редактирование бинда')
		imgui.Separator()
		imgui.Spacing()
		local bg = imgui.GetStyle().Colors[imgui.Col.WindowBg]
		imgui.Text('Название бинда:')
		imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
		imgui.InputText('##BindName', editor.edit.bindName, sizeof(editor.edit.bindName))
		imgui.PopItemWidth()
		imgui.Spacing()
		imgui.Text('Текст бинда:')
		imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
		imgui.InputTextMultiline('##BindText', editor.edit.bindText, sizeof(editor.edit.bindText), imgui.ImVec2(0, 80))
		imgui.PopItemWidth()
		imgui.Spacing()
		local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
		local item = settings.colors.itemButtons
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Выйти', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			windows.editBind[0] = false
		else
			if fa_font then imgui.PopFont() end
		end
		imgui.SameLine()
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			local newName = str(editor.edit.bindName)
			local newText = str(editor.edit.bindText)
			if newName ~= '' and newText ~= '' then
				addToHistory()
				local convertedName = newName
				local convertedText = newText
				if editor.edit.bindIndex == 0 then
					table.insert(data.newsHelpBind[editor.edit.bindCategoryIndex], {convertedName, convertedText})
					chatMessage(u8:decode('[News Helper] Бинд создан!'), 0x00FF00)
				else
					data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex][1] = convertedName
					data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex][2] = convertedText
					chatMessage(u8:decode('[News Helper] Бинд изменен!'), 0x00FF00)
				end
				windows.editBind[0] = false
			else
				chatMessage(u8:decode('[News Helper] Заполните все поля!'), 0xFF0000)
			end
		else
			if fa_font then imgui.PopFont() end
		end
		imgui.End()
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 80
	imgui.OnFrame(function() return bulkInput.active end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(700, 450), imgui.Cond.Always)
		local bg = settings.colors.background
		local item = settings.colors.itemButtons
		local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin(bulkInput.mode == 'questions' and 'Вставить вопросы' or 'Вставить ответы', nil, windowFlags) then
			local maxLines = efirLineCount[bulkInput.efirType] and efirLineCount[bulkInput.efirType][0] or 10
			imgui.TextWrapped('Введите по одному на строку (максимум ' .. maxLines .. ' строк):')
			imgui.Spacing()
			local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
			imgui.BeginChild('##BulkInputContainer', imgui.ImVec2(-1, 300), false, imgui.WindowFlags.NoScrollbar)
			local currentText = ffi.string(bulkInput.text)
			local lineArray = {}
			for line in (currentText .. "\n"):gmatch("([^\n]*)\n") do
				table.insert(lineArray, line)
			end
			if #lineArray > maxLines then
				lineArray = {table.unpack(lineArray, 1, maxLines)}
				local limited = table.concat(lineArray, "\n")
				ffi.fill(bulkInput.text, 8192)
				ffi.copy(bulkInput.text, limited)
			end
			local lineNumbers = ""
			for i = 1, #lineArray do
				lineNumbers = lineNumbers .. tostring(i) .. "\n"
			end
			imgui.PushItemWidth(30)
			imgui.InputTextMultiline('##LineNumbers', imgui.new.char[512](lineNumbers), 512, imgui.ImVec2(30, 280), imgui.InputTextFlags.ReadOnly)
			imgui.PopItemWidth()
			imgui.SameLine(0, 5)
			imgui.PushItemWidth(-1)
			imgui.InputTextMultiline('##BulkInput', bulkInput.text, 8192, imgui.ImVec2(-1, 280))
			imgui.PopItemWidth()
			imgui.EndChild()
			imgui.Spacing()
			local finalText = ffi.string(bulkInput.text)
			local finalLineCount = 1
			for _ in finalText:gmatch("\n") do
				finalLineCount = finalLineCount + 1
			end
			finalLineCount = math.min(finalLineCount, maxLines)
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Строк: ' .. finalLineCount .. ' / ' .. maxLines)
			local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 30)) then
				if fa_font then imgui.PopFont() end
				bulkInput.active = false
				ffi.fill(bulkInput.text, 8192)
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('check') .. ' Готово', imgui.ImVec2(buttonWidth, 30)) then
				if fa_font then imgui.PopFont() end
				local text = ffi.string(bulkInput.text)
				local lines = {}
				for line in text:gmatch("[^\r\n]+") do
					local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
					if trimmed ~= "" then
						table.insert(lines, trimmed)
					end
				end
				if #lines > 0 then
					local efirType = bulkInput.efirType
					local lineCount = efirLineCount[efirType][0]
					for i = 1, math.min(#lines, lineCount) do
						if bulkInput.mode == 'questions' then
							ffi.copy(efir.examples[efirType][i], lines[i])
							local answer = generateAutoAnswer(efirType, lines[i])
							if answer ~= '' then
								ffi.copy(efir.answers[efirType][i], answer)
							end
						elseif bulkInput.mode == 'answers' then
							ffi.copy(efir.answers[efirType][i], lines[i])
							if efirType == 'zerkalo' then
								local answer = ffi.string(efir.answers[efirType][i])
								if answer ~= '' then
									local reversed = generateAutoAnswer(efirType, answer)
									ffi.copy(efir.examples[efirType][i], reversed)
								end
							end
						end
					end
					saveConfig()
					AddNotification("[News Helper]", "Вставлено " .. math.min(#lines, lineCount) .. "\nстрок", "success", 3.0)
				end
				bulkInput.active = false
				ffi.fill(bulkInput.text, 8192)
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			if imgui.IsKeyPressed(imgui.Key.Escape) then
				bulkInput.active = false
				ffi.fill(bulkInput.text, 8192)
			end
			imgui.End()
		end
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 120
	imgui.OnFrame(function() return windows.help[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		if flags.saveHelpScroll then
			ui.search.scrollPos = imgui.GetScrollY()
			flags.saveHelpScroll = false
		end
		local sizeX, sizeY = getScreenResolution()
		if settings.windowPos.x == -1 or settings.windowPos.y == -1 then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX - 440, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windowPos.x, settings.windowPos.y), imgui.Cond.FirstUseEver)
		end
		imgui.SetNextWindowSize(imgui.ImVec2(settings.windowSize.x, settings.windowSize.y), imgui.Cond.FirstUseEver)
		saveConfig()
		local bufferCount = 0
		for i = 1, #data.newsHelpBind do
			if data.newsHelpBind[i][1] == settings.bufferCategoryName then
				bufferCount = #data.newsHelpBind[i] - 1
				break
			end
		end
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.Begin("News Helper", windows.help, imgui.WindowFlags.NoCollapse + settings.topMostFlags)
		local pos, size = imgui.GetWindowPos(), imgui.GetWindowSize()
		settings.windowPos.x, settings.windowPos.y, settings.windowSize.x, settings.windowSize.y = pos.x, pos.y, size.x, size.y
		if not windows.editor[0] then
			local resetButtonWidth = 60
			local expandButtonWidth = 112
			local settingsButtonWidth = 35
			local spacing = 4
			local inputWidth = imgui.GetWindowWidth() - resetButtonWidth - expandButtonWidth - settingsButtonWidth - spacing * 3 - 30
			local inputStartX = imgui.GetCursorPosX()
			local inputStartY = imgui.GetCursorPosY()
			imgui.PushItemWidth(inputWidth)
			local search_changed = false
			local bg = settings.colors.background
			local helpSearchKeyName = getKeyName(ui.hotkeys.helpSearch and ui.hotkeys.helpSearch[1] or nil)
			local searchHint = string.format("Поиск по биндам • Кликните мышью или нажмите %s", helpSearchKeyName)
			if imgui.InputTextWithHint('##search' .. tostring(ui.search.id), searchHint, ui.search.input, sizeof(ui.search.input) - 1) then
				local s = str(ui.search.input)
				local new_query = s ~= '' and s or ""
				if new_query ~= (ui.search.tmp.helpFind or "") then
					ui.search.tmp.helpFind = new_query
					search_changed = true
					ui.search.debounceTimer = os.clock()
					ui.search.resultsValid = false
				end
			end
			if ui.search.needFocus then
				imgui.SetKeyboardFocusHere(-1)
				ui.search.needFocus = false
			end
			local wasActive = ui.search.isInputActive
			ui.search.isInputActive = imgui.IsItemActive()
			local inputHeight = imgui.GetItemRectSize().y
			local bufferText = string.format("Буферов: %d", bufferCount)
			local textSize = imgui.CalcTextSize(bufferText)
			imgui.SameLine(inputStartX + inputWidth - textSize.x - 10)
			imgui.SetCursorPosY(inputStartY + (inputHeight - textSize.y) / 2 - 3.35)
			imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), bufferText)
			imgui.PopItemWidth()
			imgui.SameLine()
			local buttonStartX = imgui.GetWindowWidth() - resetButtonWidth - expandButtonWidth - settingsButtonWidth - spacing * 3 - 16
			imgui.SetCursorPosX(buttonStartX)
			local itemColor = settings.colors.itemButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('rotate') .. ' Сброс', imgui.ImVec2(resetButtonWidth, 0)) then 
				ui.search.id = ui.search.id + 1
				ui.search.input = imgui.new.char[128]()
				ui.search.tmp.helpFind = nil
				ui.search.resultsValid = false
				ui.search.cachedResults = {}
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('gear'), imgui.ImVec2(settingsButtonWidth, 0)) then 
				if flags.blockWindowsOpenDuringDownload then
					sampAddChatMessage(u8:decode("[News Helper] Нельзя открыть окна во время скачивания!"), 0xFF0000)
				else
					windows.help[0] = false
					resetIO()
					windows.mainSettings[0] = true
					ui.search.resultsValid = false
					ui.search.cachedResults = {}
					ui.search.tmp.helpFind = nil
				end
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Открыть настройки')
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
			if fa_font then imgui.PushFont(fa_font) end
			local expandButtonText = editor.allExpanded and (fa('square_minus') .. ' Свернуть все') or (fa('square_plus') .. ' Развернуть все')
			if imgui.Button(expandButtonText, imgui.ImVec2(expandButtonWidth + 5, 0)) then 
				toggleAllCategories()
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			local current_time = os.clock()
			if not ui.search.resultsValid and (current_time - ui.search.debounceTimer) >= settings.searchDebounceDelay then
				updateSearchResults(ui.search.tmp.helpFind or "")
			end
			imgui.Separator()
			imgui.BeginChild('ScrollArea', imgui.ImVec2(0, -50), false)
			local childHeight = imgui.GetWindowHeight()
			if ui.search.needRestoreScroll and ui.search.savedScrollY then
				if not ui.search.restoreFrame then
					ui.search.restoreFrame = 0
				end
				ui.search.restoreFrame = ui.search.restoreFrame + 1
				if ui.search.restoreFrame == 1 then
					imgui.SetScrollY(ui.search.savedScrollY)
				elseif ui.search.restoreFrame > 1 then
					ui.search.needRestoreScroll = false
					ui.search.restoreFrame = 0
				end
			else
				ui.search.savedScrollY = imgui.GetScrollY()
				ui.search.restoreFrame = 0
			end
			if ui.search.resultsValid then
				for i = 1, #data.newsHelpBind do
					local matchingItems = ui.search.cachedResults[i]
					local category = data.newsHelpBind[i]
					local isBufferCategory = category and category[1] == settings.bufferCategoryName
					local searchQuery = ui.search.tmp.helpFind or ""
					local hasMatchingItems = matchingItems and #matchingItems > 0
					local shouldShow = (isBufferCategory and searchQuery == "") or hasMatchingItems
					if shouldShow then
						local categoryName = category[1] or ''
						if editor.categoryStates[i] ~= nil then
							imgui.SetNextItemOpen(editor.categoryStates[i])
						end
						local isOpen = imgui.CollapsingHeader(categoryName .. '##cat' .. i)
						editor.categoryStates[i] = isOpen
						if isOpen then
							local scrollbarWidth = imgui.GetScrollMaxY() > 0 and 10 or 0
							local hasSearch = (ui.search.tmp.helpFind or "") ~= ""
							local kupluItems = {}
							local prodamItems = {}
							local otherItems = {}
							if #category <= 1 and isBufferCategory then
								imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Буфер пуст')
							else
								if isBufferCategory and settings.bufferSplit.enabled[0] and hasSearch then
									for idx, j in ipairs(matchingItems or {}) do
										if category[j] then
											local item = category[j]
											local editedText = item[2] or ""
											if containsWord(editedText, "куплю") then
												table.insert(kupluItems, {idx = idx, j = j, item = item})
											elseif containsWord(editedText, "продам") then
												table.insert(prodamItems, {idx = idx, j = j, item = item})
											else
												table.insert(otherItems, {idx = idx, j = j, item = item})
											end
										end
									end
								end
							end
							if #kupluItems > 0 or #prodamItems > 0 then
								local baseWidth = scrollbarWidth > 0 and (imgui.GetWindowWidth() - 30) / 4 or (imgui.GetWindowWidth() - 25) / 4
								local columnWidth = baseWidth * 2
								local buttonWidthInCol = baseWidth
								imgui.BeginGroup()
								local kupluTextSize = imgui.CalcTextSize('Куплю')
								imgui.SetCursorPosX(imgui.GetCursorPosX() + (columnWidth - kupluTextSize.x) / 2)
								imgui.TextColored(imgui.ImVec4(0.26, 0.98, 0.59, 1), 'Куплю')
								local kupluButtonsInRow = 0
								if #kupluItems == 0 then
									local noTextSize = imgui.CalcTextSize('Нет')
									imgui.SetCursorPosX(imgui.GetCursorPosX() + (columnWidth - noTextSize.x) / 2)
									imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Нет')
								else
									for _, entry in ipairs(kupluItems) do
										local item = entry.item
										local buttonName = item[1] or ''
										local buttonText = item[2] or ''
										local uniqueID = tostring(i) .. "_" .. tostring(entry.j)
										if kupluButtonsInRow > 0 and kupluButtonsInRow < 2 then
											imgui.SameLine()
										end
										local itemColor = settings.colors.itemButtons
										imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
										imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
										imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
										if imgui.Button(buttonName .. '##kuplu' .. uniqueID, imgui.ImVec2(buttonWidthInCol, 30)) then
											local finalText = buttonText
											if settings.autoPriceExtraction.enabled[0] and windows.customAd[0] then
												local currentAdText = ffi.string(settings.customAd.data.advertisement or '')
												finalText = insertPrice(buttonText, currentAdText)
											end
											if sampIsDialogActive() and not windows.customAd[0] then
												PasteBindWithCursor(finalText, true)
											elseif windows.customAd[0] then 
												PasteBindWithCursor(finalText, false)
											else
												sampAddChatMessage(u8:decode('[News Helper] Откройте диалог редактирования объявления!'), 0xFF0000) 
											end
										end
										if imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
											if not ui.buffer.rightClickTime then
												ui.buffer.rightClickTime = {}
											end
											local currentTime = os.clock()
											local buttonKey = tostring(i) .. "_" .. tostring(entry.j)
											if ui.buffer.rightClickTime[buttonKey] and 
												(currentTime - ui.buffer.rightClickTime[buttonKey]) < ui.buffer.doubleClickThreshold then
												table.remove(category, entry.j)
												local bufferData = {}
												for bufIdx = 2, #category do
													local entry2 = category[bufIdx]
													table.insert(bufferData, {
														advertisement = entry2[1] or "",
														editedText = entry2[2] or "",
														author = entry2[3] or "",
														phone = entry2[4] or ""
													})
												end
												updateBufferCategory(bufferData)
												states.lastSearchedAd = nil
												moveBufferCategoryToEnd()
												updateSearchResults(ui.search.tmp.helpFind or "")
												chatMessage(u8:decode('[News Helper] Буфер удален!'), 0xFF0000)
												ui.buffer.rightClickTime[buttonKey] = nil
											else
												ui.buffer.rightClickTime[buttonKey] = currentTime
											end
										end
										if imgui.IsItemHovered() then 
											imgui.BeginTooltip()
											imgui.Text(buttonText)
											imgui.Separator()
											imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), 'Кликните два раза ПКМ чтобы удалить')
											imgui.EndTooltip()
										end
										imgui.PopStyleColor(3)
										kupluButtonsInRow = kupluButtonsInRow + 1
										if kupluButtonsInRow >= 2 then kupluButtonsInRow = 0 end
									end
								end
								imgui.EndGroup()
								imgui.SameLine(0, 10)
								imgui.BeginGroup()
								local prodamTextSize = imgui.CalcTextSize('Продам')
								imgui.SetCursorPosX(imgui.GetCursorPosX() + (columnWidth - prodamTextSize.x) / 2)
								imgui.TextColored(imgui.ImVec4(0.98, 0.59, 0.26, 1), 'Продам')
								local prodamButtonsInRow = 0
								if #prodamItems == 0 then
									local noTextSize = imgui.CalcTextSize('Нет')
									imgui.SetCursorPosX(imgui.GetCursorPosX() + (columnWidth - noTextSize.x) / 2)
									imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Нет')
								else
									for _, entry in ipairs(prodamItems) do
										local item = entry.item
										local buttonName = item[1] or ''
										local buttonText = item[2] or ''
										local uniqueID = tostring(i) .. "_" .. tostring(entry.j)
										if prodamButtonsInRow > 0 and prodamButtonsInRow < 2 then
											imgui.SameLine()
										end
										local itemColor = settings.colors.itemButtons
										imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
										imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
										imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
										if imgui.Button(buttonName .. '##prodam' .. uniqueID, imgui.ImVec2(buttonWidthInCol, 30)) then
											local finalText = buttonText
											if settings.autoPriceExtraction.enabled[0] and windows.customAd[0] then
												local currentAdText = ffi.string(settings.customAd.data.advertisement or '')
												finalText = insertPrice(buttonText, currentAdText)
											end
											if sampIsDialogActive() and not windows.customAd[0] then
												PasteBindWithCursor(finalText, true)
											elseif windows.customAd[0] then 
												PasteBindWithCursor(finalText, false)
											else
												sampAddChatMessage(u8:decode('[News Helper] Откройте диалог редактирования объявления!'), 0xFF0000) 
											end
										end
										if imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
											if not ui.buffer.rightClickTime then
												ui.buffer.rightClickTime = {}
											end
											local currentTime = os.clock()
											local buttonKey = tostring(i) .. "_" .. tostring(entry.j)
											if ui.buffer.rightClickTime[buttonKey] and 
												(currentTime - ui.buffer.rightClickTime[buttonKey]) < ui.buffer.doubleClickThreshold then
												table.remove(category, entry.j)
												local bufferData = {}
												for bufIdx = 2, #category do
													local entry2 = category[bufIdx]
													table.insert(bufferData, {
														advertisement = entry2[1] or "",
														editedText = entry2[2] or "",
														author = entry2[3] or "",
														phone = entry2[4] or ""
													})
												end
												updateBufferCategory(bufferData)
												moveBufferCategoryToEnd()
												updateSearchResults(ui.search.tmp.helpFind or "")
												chatMessage(u8:decode('[News Helper] Буфер удален!'), 0xFF0000)
												ui.buffer.rightClickTime[buttonKey] = nil
											else
												ui.buffer.rightClickTime[buttonKey] = currentTime
											end
										end
										if imgui.IsItemHovered() then 
											imgui.BeginTooltip()
											imgui.Text(buttonText)
											imgui.Separator()
											imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), 'Кликните два раза ПКМ чтобы удалить')
											imgui.EndTooltip()
										end
										imgui.PopStyleColor(3)
										prodamButtonsInRow = prodamButtonsInRow + 1
										if prodamButtonsInRow >= 2 then prodamButtonsInRow = 0 end
									end
								end
								imgui.EndGroup()
								imgui.Spacing()
								imgui.Separator()
								imgui.Spacing()
								if #otherItems > 0 then
									imgui.Spacing()
									local baseWidth = scrollbarWidth > 0 and (imgui.GetWindowWidth() - 30) / 4 or (imgui.GetWindowWidth() - 25) / 4
									local buttonWidth = baseWidth
									local buttonsInRow = 0
									for _, entry in ipairs(otherItems) do
										local item = entry.item
										local buttonName = item[1] or ''
										local buttonText = item[2] or ''
										local uniqueID = tostring(i) .. "_" .. tostring(entry.j)
										if buttonsInRow > 0 and buttonsInRow < 4 then imgui.SameLine() end
										local itemColor = settings.colors.itemButtons
										imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
										imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
										imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
										if imgui.Button(buttonName .. '##other' .. uniqueID, imgui.ImVec2(buttonWidth, 30)) then
											local finalText = buttonText
											if settings.autoPriceExtraction.enabled[0] and windows.customAd[0] then
												local currentAdText = ffi.string(settings.customAd.data.advertisement or '')
												finalText = insertPrice(buttonText, currentAdText)
											end
											if sampIsDialogActive() and not windows.customAd[0] then
												PasteBindWithCursor(finalText, true)
											elseif windows.customAd[0] then 
												PasteBindWithCursor(finalText, false)
											else
												sampAddChatMessage(u8:decode('[News Helper] Откройте диалог редактирования объявления!'), 0xFF0000) 
											end
										end
										if imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
											if not ui.buffer.rightClickTime then
												ui.buffer.rightClickTime = {}
											end
											local currentTime = os.clock()
											local buttonKey = tostring(i) .. "_" .. tostring(entry.j)
											if ui.buffer.rightClickTime[buttonKey] and 
												(currentTime - ui.buffer.rightClickTime[buttonKey]) < ui.buffer.doubleClickThreshold then
												table.remove(category, entry.j)
												local bufferData = {}
												for bufIdx = 2, #category do
													local entry2 = category[bufIdx]
													table.insert(bufferData, {
														advertisement = entry2[1] or "",
														editedText = entry2[2] or "",
														author = entry2[3] or "",
														phone = entry2[4] or ""
													})
												end
												updateBufferCategory(bufferData)
												moveBufferCategoryToEnd()
												updateSearchResults(ui.search.tmp.helpFind or "")
												chatMessage(u8:decode('[News Helper] Буфер удален!'), 0xFF0000)
												ui.buffer.rightClickTime[buttonKey] = nil
											else
												ui.buffer.rightClickTime[buttonKey] = currentTime
											end
										end
										if imgui.IsItemHovered() then 
											imgui.BeginTooltip()
											imgui.Text(buttonText)
											imgui.Separator()
											imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), 'Кликните два раза ПКМ чтобы удалить')
											imgui.EndTooltip()
										end
										imgui.PopStyleColor(3)
										buttonsInRow = buttonsInRow + 1
										if buttonsInRow >= 4 then buttonsInRow = 0 end
									end
								end
							else
								local baseWidth = scrollbarWidth > 0 and (imgui.GetWindowWidth() - 30) / 4 or (imgui.GetWindowWidth() - 25) / 4
								local buttonWidth = baseWidth
								local buttonsInRow = 0
								for idx, j in ipairs(matchingItems or {}) do
									if not category[j] then goto continue end
									local item = category[j]
									if not item or not item[1] then goto continue end
									if buttonsInRow > 0 and buttonsInRow < 4 then imgui.SameLine() end
									local itemColor = settings.colors.itemButtons
									imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
									imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
									local buttonName = item[1] or ''
									local buttonText = item[2] or ''
									local uniqueID = tostring(i) .. "_" .. tostring(idx)
									if imgui.Button(buttonName .. '##buf' .. uniqueID, imgui.ImVec2(buttonWidth, 30)) then
										local finalText = buttonText
										if settings.autoPriceExtraction.enabled[0] and windows.customAd[0] then
											local currentAdText = ffi.string(settings.customAd.data.advertisement or '')
											finalText = insertPrice(buttonText, currentAdText)
										end
										if sampIsDialogActive() and not windows.customAd[0] then
											PasteBindWithCursor(finalText, true)
										elseif windows.customAd[0] then 
											PasteBindWithCursor(finalText, false)
										else
											sampAddChatMessage(u8:decode('[News Helper] Откройте диалог редактирования объявления!'), 0xFF0000) 
										end
									end
									if isBufferCategory and imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
										if not ui.buffer.rightClickTime then
											ui.buffer.rightClickTime = {}
										end
										local currentTime = os.clock()
										local buttonKey = tostring(i) .. "_" .. tostring(idx)
										if ui.buffer.rightClickTime[buttonKey] and 
											(currentTime - ui.buffer.rightClickTime[buttonKey]) < ui.buffer.doubleClickThreshold then
											table.remove(category, j)
											local bufferData = {}
											for bufIdx = 2, #category do
												local entry = category[bufIdx]
												table.insert(bufferData, {
													advertisement = entry[1] or "",
													editedText = entry[2] or "",
													author = entry[3] or "",
													phone = entry[4] or ""
												})
											end
											updateBufferCategory(bufferData)
											moveBufferCategoryToEnd()
											updateSearchResults(ui.search.tmp.helpFind or "")
											chatMessage(u8:decode('[News Helper] Буфер удален!'), 0xFF0000)
											ui.buffer.rightClickTime[buttonKey] = nil
										else
											ui.buffer.rightClickTime[buttonKey] = currentTime
										end
									end
									if imgui.IsItemHovered() then 
										imgui.BeginTooltip()
										imgui.Text(buttonText)
										if isBufferCategory then
											imgui.Separator()
											imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), 'Кликните два раза ПКМ чтобы удалить буфер')
										end
										imgui.EndTooltip()
									end
									imgui.PopStyleColor(3)
									buttonsInRow = buttonsInRow + 1
									if buttonsInRow >= 4 then buttonsInRow = 0 end
									::continue::
								end
							end
						end
					end
				end
			else
				imgui.Text("Поиск...")
			end
			ui.search.savedScrollY = imgui.GetScrollY()
			imgui.EndChild()
			imgui.Separator()
			local itemColor = settings.colors.itemButtons
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor[0] * 1.4, 1), math.min(itemColor[1] * 1.4, 1), math.min(itemColor[2] * 1.4, 1), itemColor[3]))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor[0] * 1.6, 1), math.min(itemColor[1] * 1.6, 1), math.min(itemColor[2] * 1.6, 1), itemColor[3]))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('pen_to_square') .. ' Редактор', imgui.ImVec2(imgui.GetWindowWidth() - 15, 30)) then
				windows.editor[0] = true
				windows.help[0] = false
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.Text('Редактор биндов')
				imgui.EndTooltip()
			end
		end
		if not windows.help[0] then
			ui.search.resultsValid = false
			ui.search.cachedResults = {}
			ui.search.tmp = ui.search.tmp or {}
			ui.search.tmp.helpFind = nil
			ui.search.savedScrollY = 0
		end
		imgui.End()
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 250
	imgui.OnFrame(function() return windows.sprav[0] or anim.sprav.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.sprav.lastFrameTime then
			anim.sprav.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.sprav.lastFrameTime
		anim.sprav.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if not anim.sprav.currentTabWidth or anim.sprav.currentTabWidth == 0 then
			anim.sprav.currentTabWidth = 1100
		end
		if not anim.sprav.currentTabHeight or anim.sprav.currentTabHeight == 0 then
			anim.sprav.currentTabHeight = 700
		end
		if anim.sprav.spreadProgress == nil then
			anim.sprav.spreadProgress = 0
			anim.sprav.targetSpreadProgress = 1
		end
		if anim.sprav.isClosing then
			self.HideCursor = true
		elseif windows.sprav[0] then
			self.HideCursor = false
		end
		if windows.sprav[0] and anim.sprav.isClosing then
			anim.sprav.alpha = 0
			anim.sprav.scale = 0.85
			anim.sprav.offsetY = 30
			anim.sprav.targetAlpha = 1
			anim.sprav.targetScale = 1
			anim.sprav.targetOffsetY = 0
			anim.sprav.spreadProgress = 0
			anim.sprav.targetSpreadProgress = 1
			anim.sprav.isClosing = false
			anim.sprav.currentTabWidth = 1100
			anim.sprav.currentTabHeight = 700
			anim.sprav.fixedTopY = nil
		end
		if not windows.sprav[0] and anim.sprav.alpha > 0.01 and not anim.sprav.isClosing then
			anim.sprav.targetAlpha = 0
			anim.sprav.targetScale = 0.85
			anim.sprav.targetOffsetY = 30
			anim.sprav.targetSpreadProgress = 0
			anim.sprav.isClosing = true
		end
		anim.sprav.alpha = math.min(anim.sprav.alpha + (anim.sprav.targetAlpha - anim.sprav.alpha) * anim.sprav.animSpeed * speedMultiplier, 1)
		anim.sprav.scale = math.min(anim.sprav.scale + (anim.sprav.targetScale - anim.sprav.scale) * anim.sprav.animSpeed * speedMultiplier, 1)
		anim.sprav.offsetY = anim.sprav.offsetY + (anim.sprav.targetOffsetY - anim.sprav.offsetY) * anim.sprav.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.sprav.isClosing and (anim.sprav.animSpeed * 1.2 * speedMultiplier) or (anim.sprav.animSpeed * 1 * speedMultiplier)
		anim.sprav.spreadProgress = anim.sprav.spreadProgress + 
			(anim.sprav.targetSpreadProgress - anim.sprav.spreadProgress) * spreadAnimSpeed
		anim.sprav.spreadProgress = math.max(0, math.min(anim.sprav.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.sprav.spreadProgress * 0.7
		local scaledWidth = anim.sprav.currentTabWidth * anim.sprav.scale * spreadScale
		local scaledHeight = anim.sprav.currentTabHeight * anim.sprav.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if windows.sprav[0] and not anim.sprav.fixedTopY then
			anim.sprav.fixedTopY = sizeY / 2 - anim.sprav.currentTabHeight / 2
		end
		local animY = anim.sprav.fixedTopY or sizeY / 2
		if anim.sprav.spreadProgress < 1 then
			animY = sizeY / 2 + (anim.sprav.fixedTopY - sizeY / 2) * anim.sprav.spreadProgress
		end
		if anim.sprav.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.sprav.alpha)
		local bg = settings.colors.background or {0.1, 0.1, 0.1}
		local item = settings.colors.itemButtons or {0.2, 0.2, 0.2}
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 1))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.Begin(data.mainIni.config.wave_tag .. ' Справочник', windows.sprav, imgui.WindowFlags.NoCollapse + settings.topMostFlags)
		if windows.sprav[0] then bringWindowToFront() end
		if not flags.autoRankDetected and sampIsLocalPlayerSpawned() then
			flags.autoRankDetected = true
			detectMyRank()
		end
		if not ui.search.sprav then 
			ui.search.sprav = {input = imgui.new.char[256](), results = {}, cachedText = "", selectedTab = nil} 
		end
		if data.rankNumber < 2 then
			imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Доступно со 2-го ранга")
			local rankSuffix = data.rankNumber == 1 and "-ый" or data.rankNumber == 2 and "-ой" or data.rankNumber == 3 and "-ий" or "-ый"
			imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), string.format("Вы сейчас %d%s", data.rankNumber, rankSuffix))
		else
			local currentThemeColors = settings.themes.list.custom.colors
			if not currentThemeColors or not next(currentThemeColors) then
				currentThemeColors = settings.themes.list.default.colors
			end
			local tabColor=currentThemeColors["Tab"] or {0.18,0.35,0.58,0.86}
			local tabActiveColor={math.min(tabColor[1]*1.3,1),math.min(tabColor[2]*1.3,1),math.min(tabColor[3]*1.3,1),tabColor[4]*1.15,1}
			local tabHoveredColor={math.min(tabColor[1]*1.15,1),math.min(tabColor[2]*1.15,1),math.min(tabColor[3]*1.15,1),tabColor[4]*1.15,1}
			imgui.BeginChild('##TabButtons', imgui.ImVec2(0, 48), true)
			local tabNames = {
				{icon = fa('circle_info'), text = ' П.Р.О', num = 0, tooltip = 'Правила Редактирования Объявлений'},
				{icon = fa('scroll'), text = ' Устав', num = 1, tooltip = 'Устав'},
				{icon = fa('users'), text = ' П.П.С', num = 2, tooltip = 'Правила Проведения Собеседований'},
				{icon = fa('car'), text = ' Н.Т.С', num = 3, tooltip = 'Названия Транспортных Средств'},
			}
			if not data.proTabAnimations then
				data.proTabAnimations = {}
			end
			for _, tab in ipairs(tabNames) do
				if not data.proTabAnimations[tab.num] then
					data.proTabAnimations[tab.num] = 0
				end
			end
			if fa_font then imgui.PushFont(fa_font) end
			local totalWidth = 0
			local buttonWidths = {}
			for _, tab in ipairs(tabNames) do
				local btnWidth = 120
				table.insert(buttonWidths, btnWidth)
				totalWidth = totalWidth + btnWidth + 5
			end
			local availableWidth = imgui.GetContentRegionAvail().x
			local scaleFactor = 1.0
			if totalWidth > availableWidth then
				scaleFactor = availableWidth / totalWidth
			end
			local tabButtonColor = imgui.GetStyle().Colors[imgui.Col.Button]
			imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 10)
			local startY = imgui.GetCursorPosY()
			for i, tab in ipairs(tabNames) do
				local isSelected = data.currentProTab == tab.num
				local targetScale = isSelected and 1 or 0
				local speed = 0.25
				data.proTabAnimations[tab.num] = data.proTabAnimations[tab.num] + (targetScale - data.proTabAnimations[tab.num]) * speed * speedMultiplier
				local animValue = data.proTabAnimations[tab.num]
				imgui.PushStyleColor(imgui.Col.Button, tabButtonColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, tabButtonColor)
				imgui.PushStyleColor(imgui.Col.ButtonActive, tabButtonColor)
				if i > 1 then imgui.SameLine(0, 5) end
				local btnHeight = 25 + animValue * 5
				local targetOffset = (animValue > 0.01) and 0 or 2.9
				if not data.proOffsetAnimations then data.proOffsetAnimations = {} end
				if not data.proOffsetAnimations[tab.num] then data.proOffsetAnimations[tab.num] = 0 end
				local offsetSpeed = 0.25
				data.proOffsetAnimations[tab.num] = data.proOffsetAnimations[tab.num] + (targetOffset - data.proOffsetAnimations[tab.num]) * offsetSpeed * speedMultiplier
				imgui.SetCursorPosY(startY + data.proOffsetAnimations[tab.num])
				if imgui.Button(tab.icon .. tab.text .. '##protab' .. tab.num, imgui.ImVec2(buttonWidths[i] * scaleFactor, btnHeight)) then
					data.currentProTab = tab.num
				end
				if imgui.IsItemHovered() then
					data.proTabAnimations[tab.num] = math.min(data.proTabAnimations[tab.num] + 0.3, 1)
					imgui.BeginTooltip()
					imgui.Text(tab.tooltip)
					imgui.EndTooltip()
				end
				imgui.PopStyleColor(3)
			end
			local windowWidth = imgui.GetWindowWidth()
			local searchInputWidth = 250
			local searchButtonWidth = 30
			local totalSearchWidth = searchInputWidth + searchButtonWidth + 15
			imgui.SetCursorPos(imgui.ImVec2(windowWidth - totalSearchWidth - 5, startY))
			imgui.PushItemWidth(searchInputWidth)
			imgui.InputTextWithHint('##ProSearch', 'Поиск...', ui.search.sprav.input, 256)
			imgui.PopItemWidth()
			imgui.SameLine(0, 5)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('xmark') .. '##prosearch', imgui.ImVec2(searchButtonWidth, 0)) then
				ffi.fill(ui.search.sprav.input, 256)
				procache.queries = {}
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.PopStyleVar(1)
			if fa_font then imgui.PopFont() end
			imgui.EndChild()
			imgui.BeginChild('##TabContent', imgui.ImVec2(0, 0), true, imgui.WindowFlags.NoScrollbar)
			imgui.PushItemWidth(0)
			local baseScale = 1.2
			local searchQuery = ffi.string(ui.search.sprav.input)
			local tabContents = {
				{dataText = data.PROtext, title = "П.Р.О"},
				{dataText = data.Ustavtext, title = "Устав"},
				{dataText = data.PPStext, title = "П.П.С"},
				{dataText = data.NTStext, title = "Н.Т.С"},
			}
			local currentTab = tabContents[data.currentProTab + 1]
			if currentTab then
				if searchQuery ~= "" then
					local foundAny = render_pro_text_with_search(currentTab.dataText, searchQuery, baseScale)
					if not foundAny then 
						imgui.TextColored(imgui.ImVec4(0.7,0.7,0.7,1),"Ничего не найдено") 
					end
				else
					if currentTab.dataText ~= "" then 
						render_pro_text(currentTab.dataText, baseScale) 
					else 
						imgui.Text("Файл " .. currentTab.title .. " не загружен.") 
					end
				end
			end
			imgui.EndChild()
		end
		imgui.End()
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(4)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
		if not procache.frameCounter then procache.frameCounter = 0 end
		procache.frameCounter = procache.frameCounter + 1
		if procache.frameCounter > 300 then
			clear_old_cache()
			procache.frameCounter = 0
		end
	end).Priority = settings.renderPriority + 60
	imgui.OnFrame(function() return windows.editor[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windowPos.x, settings.windowPos.y), imgui.Cond.Always)
		imgui.SetNextWindowSize(imgui.ImVec2(settings.windowSize.x, settings.windowSize.y), imgui.Cond.Always)
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		imgui.Begin('Editor', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		local buttonWidth = (imgui.GetWindowWidth() - 30) / 4
		local cat = settings.colors.categoryButtons
		local undoColor = canUndo() and {cat[0], cat[1], cat[2]} or {cat[0] * 0.5, cat[1] * 0.5, cat[2] * 0.5}
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(undoColor[1], undoColor[2], undoColor[3], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(undoColor[1] * 1.2, undoColor[2] * 1.2, undoColor[3] * 1.2, 1))
		local undoButtonText = canUndo() and 'Отменить' or 'Нету действий'
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('rotate_left') .. ' Отменить', imgui.ImVec2(buttonWidth, 25)) then
			if canUndo() then
				undo()
			else
				chatMessage(u8:decode('[News Helper] Нет действий для отмены'), 0xFF0000)
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(2)
		imgui.SameLine()
		local redoColor = canRedo() and {cat[0], cat[1], cat[2]} or {cat[0] * 0.5, cat[1] * 0.5, cat[2] * 0.5}
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(redoColor[1], redoColor[2], redoColor[3], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(redoColor[1] * 1.2, redoColor[2] * 1.2, redoColor[3] * 1.2, 1))
		local redoButtonText = canRedo() and 'Вернуть' or 'Нету действий'
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('arrow_rotate_right') .. ' Вернуть', imgui.ImVec2(buttonWidth, 25)) then
			if canRedo() then
				redo()
			else
				chatMessage(u8:decode('[News Helper] Нет действий для возврата'), 0xFF0000)
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(2)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cat[0], cat[1], cat[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cat[0] * 1.2, cat[1] * 1.2, cat[2] * 1.2, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Выйти', imgui.ImVec2(buttonWidth, 25)) then
			windows.editor[0] = false
			windows.help[0] = true
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(2)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cat[0], cat[1], cat[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cat[0] * 1.2, cat[1] * 1.2, cat[2] * 1.2, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(buttonWidth, 25)) then
			if saveHelpBinds() then
				windows.editor[0] = false
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(2)
		imgui.Separator()
		imgui.Spacing()
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('folder_plus') .. ' Создать категорию', imgui.ImVec2(imgui.GetWindowWidth() - 10, 25)) then
			editor.edit.categoryIndex = 0
			ffi.fill(editor.edit.categoryName, 256)
			windows.editCategory[0] = true
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(2)
		imgui.Spacing()
		imgui.BeginChild('EditorScrollArea', imgui.ImVec2(0, -70), false)
		for i = 1, #data.newsHelpBind do
			local category = data.newsHelpBind[i]
			local categoryName = category[1] or ''
			if categoryName == settings.bufferCategoryName then
				imgui.CollapsingHeader(categoryName .. '##editcat' .. i)
			else
				local isOpen = imgui.CollapsingHeader(categoryName .. '##editcat' .. i)
				if imgui.IsItemClicked(1) then
					local mousePos = imgui.GetMousePos()
					ui.contextMenu.pos.x = mousePos.x
					ui.contextMenu.pos.y = mousePos.y
					editor.edit.categoryIndex = i
					ui.contextMenu.type = 1
					windows.contextMenu[0] = true
				end
				if imgui.IsItemHovered() and not imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.Text('ПКМ для меню действий')
					imgui.EndTooltip()
				end
				if isOpen then
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0] * 0.8, item[1] * 0.8, item[2] * 0.8, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0], item[1], item[2], item[3]))
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(fa('plus') .. ' Добавить бинд##' .. i, imgui.ImVec2(imgui.GetWindowWidth() - 30, 20)) then
						editor.edit.bindCategoryIndex = i
						editor.edit.bindIndex = 0
						ffi.fill(editor.edit.bindName, 256)
						ffi.fill(editor.edit.bindText, 1024)
						windows.editBind[0] = true
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(2)
					imgui.Spacing()
					local bindButtonWidth = (imgui.GetWindowWidth() - 50) / 3
					local bindButtonsInRow = 0
					for j = 2, #category do
						local bind = category[j]
						if bindButtonsInRow > 0 and bindButtonsInRow < 3 then imgui.SameLine() end
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
						local bindName = bind[1] or ''
						if imgui.Button(bindName .. '##editbind' .. i .. j, imgui.ImVec2(bindButtonWidth, 25)) then
						end
						if imgui.IsItemClicked(1) then
							local mousePos = imgui.GetMousePos()
							ui.contextMenu.pos.x = mousePos.x
							ui.contextMenu.pos.y = mousePos.y
							editor.edit.bindCategoryIndex = i
							editor.edit.bindIndex = j
							ui.contextMenu.type = 2
							windows.contextMenu[0] = true
						end
						imgui.PopStyleColor(3)
						if imgui.IsItemHovered() then
							imgui.BeginTooltip()
							imgui.Text(bind[2] or '')
							imgui.Text('ПКМ для меню действий')
							imgui.EndTooltip()
						end
						bindButtonsInRow = bindButtonsInRow + 1
						if bindButtonsInRow >= 3 then bindButtonsInRow = 0 end
					end
				end
			end
		end
		imgui.EndChild()
		imgui.SetCursorPosY(imgui.GetCursorPosY() + 14)
		imgui.Separator()
		imgui.Spacing()
		local itemColor = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor[0] * 1.2, itemColor[1] * 1.2, itemColor[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(itemColor[0] * 1.4, itemColor[1] * 1.4, itemColor[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('magnifying_glass') .. ' Find & Replace##editorFindReplace', imgui.ImVec2(imgui.GetWindowWidth() - 15, 30)) then
			windows.findReplace[0] = true
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.End()
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 70
	imgui.OnFrame(function() return binder.editWindow[0] or anim.binder.editWindow.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.binder.editWindow.lastFrameTime then
			anim.binder.editWindow.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.binder.editWindow.lastFrameTime
		anim.binder.editWindow.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if not anim.binder.editWindow.currentTabWidth or anim.binder.editWindow.currentTabWidth == 0 then
			anim.binder.editWindow.currentTabWidth = 700
		end
		if not anim.binder.editWindow.currentTabHeight or anim.binder.editWindow.currentTabHeight == 0 then
			anim.binder.editWindow.currentTabHeight = 600
		end
		if anim.binder.editWindow.spreadProgress == nil then
			anim.binder.editWindow.spreadProgress = 0
			anim.binder.editWindow.targetSpreadProgress = 1
		end
		if anim.binder.editWindow.isClosing then
			self.HideCursor = true
		elseif binder.editWindow[0] then
			self.HideCursor = false
		end
		if binder.editWindow[0] and anim.binder.editWindow.isClosing then
			anim.binder.editWindow.alpha = 0
			anim.binder.editWindow.scale = 0.85
			anim.binder.editWindow.offsetY = 30
			anim.binder.editWindow.targetAlpha = 1
			anim.binder.editWindow.targetScale = 1
			anim.binder.editWindow.targetOffsetY = 0
			anim.binder.editWindow.spreadProgress = 0
			anim.binder.editWindow.targetSpreadProgress = 1
			anim.binder.editWindow.isClosing = false
			anim.binder.editWindow.currentTabWidth = 700
			anim.binder.editWindow.currentTabHeight = 600
			anim.binder.editWindow.fixedTopY = nil
		end
		if not binder.editWindow[0] and anim.binder.editWindow.alpha > 0.01 and not anim.binder.editWindow.isClosing then
			anim.binder.editWindow.targetAlpha = 0
			anim.binder.editWindow.targetScale = 0.85
			anim.binder.editWindow.targetOffsetY = 30
			anim.binder.editWindow.targetSpreadProgress = 0
			anim.binder.editWindow.isClosing = true
		end
		anim.binder.editWindow.alpha = math.min(anim.binder.editWindow.alpha + (anim.binder.editWindow.targetAlpha - anim.binder.editWindow.alpha) * anim.binder.editWindow.animSpeed * speedMultiplier, 1)
		anim.binder.editWindow.scale = math.min(anim.binder.editWindow.scale + (anim.binder.editWindow.targetScale - anim.binder.editWindow.scale) * anim.binder.editWindow.animSpeed * speedMultiplier, 1)
		anim.binder.editWindow.offsetY = anim.binder.editWindow.offsetY + (anim.binder.editWindow.targetOffsetY - anim.binder.editWindow.offsetY) * anim.binder.editWindow.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.binder.editWindow.isClosing and (anim.binder.editWindow.animSpeed * 1.2 * speedMultiplier) or (anim.binder.editWindow.animSpeed * 1 * speedMultiplier)
		anim.binder.editWindow.spreadProgress = anim.binder.editWindow.spreadProgress + 
			(anim.binder.editWindow.targetSpreadProgress - anim.binder.editWindow.spreadProgress) * spreadAnimSpeed
		anim.binder.editWindow.spreadProgress = math.max(0, math.min(anim.binder.editWindow.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		local spreadScale = 0.3 + anim.binder.editWindow.spreadProgress * 0.7
		local scaledWidth = anim.binder.editWindow.currentTabWidth * anim.binder.editWindow.scale * spreadScale
		local scaledHeight = anim.binder.editWindow.currentTabHeight * anim.binder.editWindow.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if binder.editWindow[0] and not anim.binder.editWindow.fixedTopY then
			anim.binder.editWindow.fixedTopY = sizeY / 2 - anim.binder.editWindow.currentTabHeight / 2
		end
		local animY = anim.binder.editWindow.fixedTopY or sizeY / 2
		if anim.binder.editWindow.spreadProgress < 1 then
			animY = sizeY / 2 + (anim.binder.editWindow.fixedTopY - sizeY / 2) * anim.binder.editWindow.spreadProgress
		end
		if anim.binder.editWindow.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.binder.editWindow.alpha)
		local bg = settings.colors.background
		local item = settings.colors.itemButtons
		local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('Редактор бинда##bindedit', binder.editWindow, windowFlags) then
			local inputBg = imgui.ImVec4(item[0]*0.5, item[1]*0.5, item[2]*0.5, item[3])
			local inputBgHover = imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3])
			local inputBgActive = imgui.ImVec4(item[0]*0.9, item[1]*0.9, item[2]*0.9, item[3])
			imgui.PushItemWidth(420)
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			imgui.InputTextWithHint('##bindname', 'Название бинда', binderEdit.name, 256)
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('sliders') .. '##conditions', imgui.ImVec2(35, 0)) then
				imgui.OpenPopup('ConditionsPopup##edit')
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Условия активации')
			end
			if imgui.BeginPopup('ConditionsPopup##edit', imgui.WindowFlags.AlwaysAutoResize) then
				imgui.Text('Условия активации:')
				imgui.Separator()
				imgui.Spacing()
				if imgui.ToggleButton('##binderEnableOnChat', binderEdit.enableOnChat, nil, 'Запускать при активном чате', true) then end
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text('Бинд сработает даже если открыт чат')
					imgui.EndTooltip()
				end
				imgui.Spacing()
				if imgui.ToggleButton('##binderEnableOnDialog', binderEdit.enableOnDialog, nil, 'Запускать при активном диалоге', true) then end
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text('Бинд сработает даже если открыт диалог')
					imgui.EndTooltip()
				end
				imgui.EndPopup()
			end
			imgui.SameLine()
			local viewModeIcon = binderEdit.mode[0] == 1 and fa('bars') or fa('square')
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(viewModeIcon .. '##viewmode', imgui.ImVec2(35, 0)) then
				if binderEdit.mode[0] == 1 then
					local squareLines = {}
					for _, line in ipairs(binderEdit.lines) do
						if line.text then
							local text = ffi.string(line.text)
							if text ~= "" then
								table.insert(squareLines, text)
							end
						end
					end
					local combinedText = table.concat(squareLines, "\n")
					ffi.fill(binderEdit.squareText, ffi.sizeof(binderEdit.squareText))
					ffi.copy(binderEdit.squareText, combinedText)
					binderEdit.mode[0] = 2
				else
					binderEdit.lines = {}
					local text = ffi.string(binderEdit.squareText)
					for line in text:gmatch("[^\r\n]+") do
						local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
						if trimmed ~= "" then
							table.insert(binderEdit.lines, {
								text = imgui.new.char[512](trimmed),
								delay = imgui.new.int(binderEdit.delay[0])
							})
						end
					end
					if #binderEdit.lines == 0 then
						table.insert(binderEdit.lines, {
							text = imgui.new.char[512](),
							delay = imgui.new.int(binderEdit.delay[0])
						})
					end
					binderEdit.mode[0] = 1
				end
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button('Переменные##varsBtn', imgui.ImVec2(85, 0)) then
				imgui.OpenPopup('VariablesPopup##edit')
			end
			imgui.PopStyleColor(3)
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Доступные переменные для подстановки')
			end
			if imgui.BeginPopup('VariablesPopup##edit', imgui.WindowFlags.AlwaysAutoResize) then
				imgui.Text('Доступные переменные:')
				imgui.Separator()
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Игрок:')
				imgui.Spacing()
				local playerVars = {
					{'<myid>', 'Ваш ID'},
					{'<mynick>', 'Ваш ник (с транслитерацией)'},
					{'<mynickeng>', 'Ваш ник (оригинал)'},
					{'<myrang>', 'Ваша должность'},
					{'<closeid>', 'ID ближайшего игрока'},
					{'<closenick>', 'Ник ближайшего (с транслитерацией)'},
					{'<closenickeng>', 'Ник ближайшего (оригинал)'},
				}
				for _, var in ipairs(playerVars) do
					local key, desc = var[1], var[2]
					imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
					if imgui.IsItemClicked(0) then
						imgui.SetClipboardText(key)
						AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Нажмите для копирования')
					end
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
					imgui.Spacing()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Экран:')
				imgui.Spacing()
				local screenVars = {
					{'<closeidtocenter>', 'ID ближайшего к центру экрана'},
					{'<closennicktocenter>', 'Ник ближайшего к центру (с транслитерацией)'},
					{'<closennicktocentereng>', 'Ник ближайшего к центру (оригинал)'},
				}
				for _, var in ipairs(screenVars) do
					local key, desc = var[1], var[2]
					imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
					if imgui.IsItemClicked(0) then
						imgui.SetClipboardText(key)
						AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Нажмите для копирования')
					end
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
					imgui.Spacing()
				end
				if binderEdit.useRBM[0] then
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Наведение (ПКМ режим):')
					imgui.Spacing()
					local rbmVars = {
						{'<rbmid>', 'ID наведённого игрока'},
						{'<rbmnick>', 'Ник наведённого (с транслитерацией)'},
						{'<rbmnickeng>', 'Ник наведённого (оригинал)'},
					}
					for _, var in ipairs(rbmVars) do
						local key, desc = var[1], var[2]
						imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
						if imgui.IsItemClicked(0) then
							imgui.SetClipboardText(key)
							AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip('Нажмите для копирования')
						end
						imgui.SameLine()
						imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
						imgui.Spacing()
					end
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Поиск игрока по нику:')
				imgui.Spacing()
				local searchVars = {
					{'<id@NickName>', 'ID игрока по нику (пример: <id@PlayerNick>)'},
				}
				for _, var in ipairs(searchVars) do
					local key, desc = var[1], var[2]
					imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
					if imgui.IsItemClicked(0) then
						imgui.SetClipboardText(key)
						AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Нажмите для копирования')
					end
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
					imgui.Spacing()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'Время (h - час, m - минуты, d - день, M - месяц, y - год):')
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Всегда после time идет : затем буквы и разделители.')
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Разделители сохраняются: <time:h.m> → 14.30, <time:h:m> → 14:30')
				imgui.Spacing()
				local timeVars = {
					{'<time:h:m>', 'Час и минуты (14:30)'},
					{'<time:h.m>', 'Час и минуты (14.30)'},
					{'<time:d.M.y>', 'Полная дата (12.12.2025)'},
					{'<time:d:M:y>', 'Полная дата (12:12:2025)'},
					{'<time:h>', 'Час'},
					{'<time:m>', 'Минуты'},
					{'<time:d>', 'День'},
					{'<time:M>', 'Месяц'},
					{'<time:y>', 'Год'},
				}
				for _, var in ipairs(timeVars) do
					local key, desc = var[1], var[2]
					imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), key)
					if imgui.IsItemClicked(0) then
						imgui.SetClipboardText(key)
						AddNotification("[News Helper]", "Скопировано: " .. key, "success", 2.0)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Нажмите для копирования')
					end
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), ' - ' .. desc)
					imgui.Spacing()
				end
				imgui.EndPopup()
			end
			imgui.Spacing()
			imgui.Text('Горячая клавиша:')
			imgui.SameLine()
			local hotkeyText
			if binder.keyCapture.active then
				hotkeyText = 'Нажмите клавиши...'
			else
				local displayText = getHotkeyDisplayText(binderEdit.hotkey)
				if binderEdit.useRBM[0] then
					hotkeyText = 'ПКМ + ' .. displayText
				else
					hotkeyText = displayText
				end
			end
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if imgui.Button(hotkeyText .. '##hotkey', imgui.ImVec2(200, 25)) then
				local cmdText = ffi.string(binderEdit.command)
				if cmdText ~= "" then
					ffi.fill(binderEdit.command, 64)
				end
				binder.keyCapture.oldHotkey = {}
				if binderEdit.hotkey and #binderEdit.hotkey > 0 then
					for _, key in ipairs(binderEdit.hotkey) do
						table.insert(binder.keyCapture.oldHotkey, key)
					end
				end
				binder.keyCapture.active = true
				binder.keyCapture.keys = {}
				binderEdit.tempHotkey = {}
			end
			imgui.PopStyleColor(3)
			if binder.keyCapture.active then
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Отпустите все клавиши для сохранения')
			end
			if #binderEdit.hotkey > 0 then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
				if imgui.Button('X##clearhotkey', imgui.ImVec2(25, 25)) then
					binderEdit.hotkey = {}
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Удалить клавишу')
				end
				imgui.SameLine()
			end
			local currentBinderName = ffi.string(binderEdit.name)
			local conflictInfo = {}
			if #binderEdit.hotkey > 0 then
				if binder.list and type(binder.list) == "table" then
					for _, b in ipairs(binder.list) do
						local bName = ffi.string(b.name)
						if bName ~= currentBinderName 
							and b.useRBM == binderEdit.useRBM[0]
							and b.hotkey 
							and #b.hotkey == #binderEdit.hotkey 
						then
							local match = true
							for i = 1, #b.hotkey do
								if b.hotkey[i] ~= binderEdit.hotkey[i] then
									match = false
									break
								end
							end
							if match then
								table.insert(conflictInfo, bName)
							end
						end
					end
				end
			end
			if #conflictInfo > 0 then
				imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Также используется: ' .. table.concat(conflictInfo, ', '))
			end
			if not binderEdit.useRBM[0] then
				imgui.SameLine(440)
				imgui.Text('Команда:')
				imgui.SameLine(500)
				imgui.PushItemWidth(150)
				imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
				imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
				imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
				if imgui.InputTextWithHint('##command', 'без /', binderEdit.command, 64) then
					if #binderEdit.hotkey > 0 then
						binderEdit.hotkey = {}
					end
				end
				imgui.PopStyleColor(3)
				imgui.PopItemWidth()
				imgui.Spacing()
			else
				imgui.Spacing()
			end
			setupCheckboxStyle()
			if imgui.ToggleButton('##binderUseRBM', binderEdit.useRBM, nil, 'Наведение + ПКМ', true) then end
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.Text('Активировать через наведение на игрока')
				imgui.Text('+ ПКМ + клавиша вместо обычной горячей клавиши')
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'В переменные добавятся:')
				imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), '<rbmid>, <rbmnick>, <rbmnickeng>')
				imgui.EndTooltip()
			end
			cleanupCheckboxStyle()
			imgui.SameLine(450)
			setupCheckboxStyle()
			if imgui.ToggleButton('##binderStrictMode', binderEdit.strictMode, nil, 'Строгий режим', true) then end
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.Text('Если включено - бинд не сработает')
				imgui.Text('если зажаты другие клавиши кроме клавиш бинда')
				imgui.EndTooltip()
			end
			cleanupCheckboxStyle()
			if binderEdit.useRBM[0] and #binderEdit.hotkey > 0 then
				local rsKey = panels.rs and panels.rs.settings and panels.rs.settings.interactionKey or 0
				if rsKey > 0 then
					for _, key in ipairs(binderEdit.hotkey) do
						if key == rsKey then
							imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), '⚠ Конфликт! Эта клавиша используется для взаимодействия (RS)')
							break
						end
					end
				end
			end
			imgui.Spacing()
			imgui.Separator()
			imgui.Spacing()
			imgui.Text('Задержка (мс):')
			imgui.SameLine()
			if binderEdit.mode[0] == 1 then
				imgui.PushItemWidth(40)
			else
				imgui.PushItemWidth(100)
			end
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			if imgui.InputInt('##delay', binderEdit.delay, 0, 0) then
				if binderEdit.delay[0] < 0 then binderEdit.delay[0] = 0 end
				if binderEdit.delay[0] > 100000 then binderEdit.delay[0] = 100000 end
			end
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			if binderEdit.mode[0] == 1 then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				if imgui.Button('Применить##applyDelay', imgui.ImVec2(80, 0)) then
					for _, line in ipairs(binderEdit.lines) do
						line.delay[0] = binderEdit.delay[0]
					end
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Применить задержку (' .. binderEdit.delay[0] .. ' мс) ко всем строкам')
				end
			end
			imgui.SameLine()
			setupCheckboxStyle()
			if imgui.ToggleButton('##binderBlockKey', binderEdit.blockKey, nil, 'Блокировать клавишу', true) then end
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), 'Блокирует клавишу при нажатии')
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'не будет работать в игре и других скриптах')
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.8, 0.8, 0.8, 1), 'Примеры:')
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(1, 1, 0.7, 1), 'Shift + M (порядок не важен)')
				imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), 'M блокируется при зажатом Shift')
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(1, 1, 0.7, 1), 'M')
				imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), 'M всегда блокируется')
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(1, 1, 0.7, 1), 'M + U (важен порядок)')
				imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), 'M всегда блокирована, U блокируется при зажатом M')
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				if binderEdit.hotkey and #binderEdit.hotkey > 0 then
					imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), 'В вашем случае:')
					imgui.Spacing()
					local hasModifier = false
					local regularCount = 0
					local modifierNames = {}
					local regularNames = {}
					for _, key in ipairs(binderEdit.hotkey) do
						local keyName = ""
						if key == vk.VK_LSHIFT or key == vk.VK_RSHIFT then keyName = "Shift"
						elseif key == vk.VK_LCONTROL or key == vk.VK_RCONTROL then keyName = "Ctrl"
						elseif key == vk.VK_LMENU or key == vk.VK_RMENU then keyName = "Alt"
						elseif key == vk.VK_TAB then keyName = "Tab"
						elseif key == vk.VK_CAPITAL then keyName = "Caps"
						elseif key >= vk.VK_F1 and key <= vk.VK_F12 then keyName = "F"..(key - vk.VK_F1 + 1)
						elseif key >= 65 and key <= 90 then keyName = string.char(key)
						elseif key >= 48 and key <= 57 then keyName = string.char(key)
						end
						if modifierKeys and modifierKeys[key] then
							hasModifier = true
							table.insert(modifierNames, keyName)
						else
							regularCount = regularCount + 1
							table.insert(regularNames, keyName)
						end
					end
					if hasModifier and regularCount > 0 then
						local modifierStr = table.concat(modifierNames, " + ")
						local regularStr = table.concat(regularNames, " + ")
						imgui.BulletText(modifierStr.." + "..regularStr.." (порядок не важен)")
						imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Все буквы/цифры блокируются при зажатом "..modifierStr)
					elseif hasModifier and regularCount == 0 then
						local modifierStr = table.concat(modifierNames, " + ")
						imgui.BulletText(modifierStr)
						imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), modifierStr.." всегда блокируется")
					elseif regularCount > 0 then
						if regularCount == 1 then
							imgui.BulletText(regularNames[1])
							imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), regularNames[1].." всегда блокируется")
						else
							local allKeysStr = table.concat(regularNames, " + ")
							imgui.BulletText(allKeysStr.." (важен порядок)")
							if regularCount == 2 then
								imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), regularNames[1].." всегда блокирована, "..regularNames[2].." блокируется при зажатом "..regularNames[1])
							elseif regularCount == 3 then
								imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), regularNames[1].." всегда блокирована")
								imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), regularNames[2].." и "..regularNames[3].." блокируются при зажатом "..regularNames[1])
							end
						end
					end
				end
				imgui.EndTooltip()
			end
			cleanupCheckboxStyle()
			imgui.SameLine()
			setupCheckboxStyle()
			if imgui.ToggleButton('##binderRequireConfirm', binderEdit.requireConfirm, nil, 'Подтверждение активации', true) then end
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.Text('Если включено - для срабатывания биндера')
				imgui.Text('нужно нажать клавишу дважды подряд.')
				imgui.EndTooltip()
			end
			cleanupCheckboxStyle()
			imgui.Spacing()
			if binderEdit.mode[0] == 1 then
				renderBinderLinesMode(inputBg, inputBgHover, inputBgActive, item)
			else
				renderBinderSquareMode(inputBg, inputBgHover, inputBgActive)
			end
			imgui.SetCursorPosY(imgui.GetWindowHeight() - 45)
			imgui.Separator()
			local btnWidth = (imgui.GetWindowWidth() - 30) / 2
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('xmark') .. ' Отменить', imgui.ImVec2(btnWidth, 30)) then
				if fa_font then imgui.PopFont() end
				binder.editWindow[0] = false
				binder.editing = nil
			end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(btnWidth, 30)) then
				if fa_font then imgui.PopFont() end
				saveBinderEdit()
			end
			imgui.PopStyleColor(3)
			imgui.End()
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(3)
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 31
	imgui.OnFrame(function() return windows.mainSettings[0] or anim.mainSettings.alpha > 0.01 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local currentTime = os.clock()
		if not anim.mainSettings.lastFrameTime then
			anim.mainSettings.lastFrameTime = currentTime
		end
		local deltaTime = currentTime - anim.mainSettings.lastFrameTime
		anim.mainSettings.lastFrameTime = currentTime
		local speedMultiplier = math.min(deltaTime * 60, 1)
		if anim.mainSettings.spreadProgress == nil then
			anim.mainSettings.spreadProgress = 0
			anim.mainSettings.targetSpreadProgress = 1
		end
		if windows.mainSettings[0] then
			self.HideCursor = false
		elseif anim.mainSettings.alpha < 0.75 then
			self.HideCursor = true
		end
		if not efirRecovery.window[0] and not efirRecovery.recovering and 
			not (efir.control.running and not efir.control.paused) and 
			not efir.auto.active and
			not efir.auto.finishedQuestions then
			local sessionData = loadEfirSession()
			if sessionData then
				efirRecovery.sessionData = sessionData
				efirRecovery.window[0] = true
				windows.mainSettings[0] = false
				return
			end
		end
		if not flags.autoRankDetected and sampIsLocalPlayerSpawned() then
			flags.autoRankDetected = true
			detectMyRank()
		end
		if windows.mainSettings[0] and anim.mainSettings.isClosing then
			anim.mainSettings.alpha = 0
			anim.mainSettings.scale = 0.85
			anim.mainSettings.offsetY = 30
			anim.mainSettings.targetAlpha = 1
			anim.mainSettings.targetScale = 1
			anim.mainSettings.targetOffsetY = 0
			anim.mainSettings.spreadProgress = 0
			anim.mainSettings.targetSpreadProgress = 1
			anim.mainSettings.isClosing = false
			local currentTabSize = tabWindowSizes[data.currentMainSettingsTab]
			anim.mainSettings.currentTabWidth = currentTabSize.x
			anim.mainSettings.currentTabHeight = currentTabSize.y
			anim.mainSettings.fixedTopY = nil
		end
		if not windows.mainSettings[0] and not anim.mainSettings.isClosing then
			local currentTabSize = tabWindowSizes[data.currentMainSettingsTab]
			anim.mainSettings.currentTabWidth = currentTabSize.x
			anim.mainSettings.currentTabHeight = currentTabSize.y
		end
		if not windows.mainSettings[0] and anim.mainSettings.alpha > 0.01 and not anim.mainSettings.isClosing then
			anim.mainSettings.targetAlpha = 0
			anim.mainSettings.targetScale = 0.85
			anim.mainSettings.targetOffsetY = 30
			anim.mainSettings.targetSpreadProgress = 0
			anim.mainSettings.isClosing = true
		end
		anim.mainSettings.alpha = math.min(anim.mainSettings.alpha + (anim.mainSettings.targetAlpha - anim.mainSettings.alpha) * anim.mainSettings.animSpeed * speedMultiplier, 1)
		anim.mainSettings.scale = math.min(anim.mainSettings.scale + (anim.mainSettings.targetScale - anim.mainSettings.scale) * anim.mainSettings.animSpeed * speedMultiplier, 1)
		anim.mainSettings.offsetY = anim.mainSettings.offsetY + (anim.mainSettings.targetOffsetY - anim.mainSettings.offsetY) * anim.mainSettings.animSpeed * speedMultiplier
		local spreadAnimSpeed = anim.mainSettings.isClosing and (anim.mainSettings.animSpeed * 1.2 * speedMultiplier) or (anim.mainSettings.animSpeed * 1 * speedMultiplier)
		anim.mainSettings.spreadProgress = anim.mainSettings.spreadProgress + 
			(anim.mainSettings.targetSpreadProgress - anim.mainSettings.spreadProgress) * spreadAnimSpeed
		anim.mainSettings.spreadProgress = math.max(0, math.min(anim.mainSettings.spreadProgress, 1))
		local sizeX, sizeY = getScreenResolution()
		tabWindowSizes[0].y = calculateAboutTabHeight()
		tabWindowSizes[3].y = calculateBindsTabHeight()
		if data.currentMainSettingsTab == 7 then
			tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
		end
		local animWindowSize = tabWindowSizes[0]
		local windowSize = tabWindowSizes[0]
		local transitionSpeed = 0.125
		local currentTabSize = tabWindowSizes[data.currentMainSettingsTab]
		anim.mainSettings.currentTabWidth = anim.mainSettings.currentTabWidth + (currentTabSize.x - anim.mainSettings.currentTabWidth) * transitionSpeed * speedMultiplier
		anim.mainSettings.currentTabHeight = anim.mainSettings.currentTabHeight + (currentTabSize.y - anim.mainSettings.currentTabHeight) * transitionSpeed * speedMultiplier
		local spreadScale = 0.3 + anim.mainSettings.spreadProgress * 0.7
		local scaledWidth = anim.mainSettings.currentTabWidth * anim.mainSettings.scale * spreadScale
		local scaledHeight = anim.mainSettings.currentTabHeight * anim.mainSettings.scale * spreadScale
		imgui.SetNextWindowSize(imgui.ImVec2(scaledWidth, scaledHeight), imgui.Cond.Always)
		if windows.mainSettings[0] and not anim.mainSettings.fixedTopY then
			local firstTabHeight = tabWindowSizes[0].y + 48
			local desiredY
			if sizeY < 1250 then
				desiredY = 10
			else
				desiredY = sizeY / 2 - firstTabHeight / 2
			end
			anim.mainSettings.fixedTopY = math.max(desiredY, 10)
		end
		local animY = anim.mainSettings.fixedTopY or sizeY / 2
		if anim.mainSettings.spreadProgress < 1 then
			animY = sizeY / 2 + (anim.mainSettings.fixedTopY - sizeY / 2) * anim.mainSettings.spreadProgress
		end
		if anim.mainSettings.fixedTopY then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, animY), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
		else
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		end
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim.mainSettings.alpha)
		local windowFlags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + settings.topMostFlags
		local isOpen = windows.mainSettings
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.4, 1), math.min(item[2]*1.4, 1), item[3]*1.4))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if imgui.Begin('News Helper - Настройки', isOpen, windowFlags) then
			local item = settings.colors.itemButtons
			local bg = settings.colors.background
			local itemColor = imgui.ImVec4(item[0], item[1], item[2], item[3])
			local itemColorHovered = imgui.ImVec4(math.min(item[0] * 1.2, 1), math.min(item[1] * 1.2, 1), math.min(item[2] * 1.2, 1), item[3])
			local itemColorActive = imgui.ImVec4(math.min(item[0] * 1.4, 1), math.min(item[1] * 1.4, 1), math.min(item[2] * 1.4, 1), item[3])
			local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
			local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
			local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
			local currentThemeColors = settings.themes.list.custom.colors
			if not currentThemeColors or not next(currentThemeColors) then
				currentThemeColors = settings.themes.list.default.colors
			end
			local tabColor=currentThemeColors["Tab"] or {0.18,0.35,0.58,0.86}
			local tabActiveColor={math.min(tabColor[1]*1.3,1),math.min(tabColor[2]*1.3,1),math.min(tabColor[3]*1.3,1),tabColor[4]}
			local tabHoveredColor={math.min(tabColor[1]*1.15,1),math.min(tabColor[2]*1.15,1),math.min(tabColor[3]*1.15,1),tabColor[4]}
			imgui.BeginChild('##TabButtons', imgui.ImVec2(0, 48), true)
			local tabNames = {
				{icon = fa('circle_info'), text = ' О скрипте', num = 0, tooltip = 'О скрипте'},
				{icon = fa('gear'), text = ' Настройки', num = 1, tooltip = 'Настройки'},
				{icon = fa('key'), text = ' Автологин', num = 2, tooltip = 'Автологин'},
				{icon = fa('keyboard'), text = ' Биндер', num = 3, tooltip = 'Биндер'},
				{icon = fa('gamepad'), text = ' Горячие', num = 4, tooltip = 'Горячие клавиши'},
				{icon = fa('users'), text = ' Чекер', num = 5, tooltip = 'Чекер'},
				{icon = fa('microphone'), text = ' Эфиры', num = 6, tooltip = 'Эфиры'},
				{icon = fa('comment'), text = ' Сообщения', num = 7, tooltip = 'Сообщения эфира'},
				{icon = fa('tower_broadcast'), text = ' Свободный', num = 8, tooltip = 'Эфир без вопросов'},
			}
			if not data.tabAnimations then
				data.tabAnimations = {}
			end
			for _, tab in ipairs(tabNames) do
				if not data.tabAnimations[tab.num] then
					data.tabAnimations[tab.num] = 0
				end
			end
			if fa_font then imgui.PushFont(fa_font) end
			local totalWidth = 0
			local buttonWidths = {}
			for _, tab in ipairs(tabNames) do
				local textSize = imgui.CalcTextSize(tab.icon .. tab.text)
				local btnWidth = textSize.x + 16
				table.insert(buttonWidths, btnWidth)
				totalWidth = totalWidth + btnWidth + 5
			end
			local availableWidth = imgui.GetContentRegionAvail().x
			local scaleFactor = 1.0
			if totalWidth > availableWidth then
				scaleFactor = availableWidth / totalWidth
			end
			local tabButtonColor = imgui.GetStyle().Colors[imgui.Col.Button]
			imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 10)
			local startY = imgui.GetCursorPosY()
			for i, tab in ipairs(tabNames) do
				local isSelected = data.currentMainSettingsTab == tab.num
				local targetScale = isSelected and 1 or 0
				local speed = 0.25
				data.tabAnimations[tab.num] = data.tabAnimations[tab.num] + (targetScale - data.tabAnimations[tab.num]) * speed * speedMultiplier
				local animValue = data.tabAnimations[tab.num]
				imgui.PushStyleColor(imgui.Col.Button, tabButtonColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, tabButtonColor)
				imgui.PushStyleColor(imgui.Col.ButtonActive, tabButtonColor)
				if i > 1 then imgui.SameLine(0, 5) end
				local btnHeight = 25 + animValue * 5
				local targetOffset = (animValue > 0.01) and 0 or 2.9
				if not data.offsetAnimations then data.offsetAnimations = {} end
				if not data.offsetAnimations[tab.num] then data.offsetAnimations[tab.num] = 0 end
				local offsetSpeed = 0.25
				data.offsetAnimations[tab.num] = data.offsetAnimations[tab.num] + (targetOffset - data.offsetAnimations[tab.num]) * offsetSpeed * speedMultiplier
				imgui.SetCursorPosY(startY + data.offsetAnimations[tab.num])
				if imgui.Button(tab.icon .. tab.text .. '##tab' .. tab.num, imgui.ImVec2(buttonWidths[i] * scaleFactor, btnHeight)) then
					data.currentMainSettingsTab = tab.num
				end
				if imgui.IsItemHovered() then
					data.tabAnimations[tab.num] = math.min(data.tabAnimations[tab.num] + 0.3, 1)
					imgui.BeginTooltip()
					imgui.Text(tab.tooltip)
					imgui.EndTooltip()
				end
				imgui.PopStyleColor(3)
			end
			imgui.PopStyleVar(1)
			if fa_font then imgui.PopFont() end
			imgui.EndChild()
			imgui.BeginChild('##TabContent', imgui.ImVec2(0, 0), true, imgui.WindowFlags.NoScrollbar)
			imgui.PushItemWidth(0)
			if data.currentMainSettingsTab == 0 then
				imgui.Spacing()
				imgui.Text('Версия: ' .. script_version)
				imgui.Text('News Helper - Помощник для СМИ')
				imgui.Text('Автор: alikhan')
				imgui.SameLine()
				imgui.Text('|')
				imgui.SameLine()
				local linkColor = imgui.ImVec4(0.3, 0.6, 1, 1)
				local hoverColor = imgui.ImVec4(0.5, 0.8, 1, 1)
				if imgui.IsItemHovered() then
					imgui.PushStyleColor(imgui.Col.Text, hoverColor)
				else
					imgui.PushStyleColor(imgui.Col.Text, linkColor)
				end
				imgui.Text('VK: @a.baisultanov')
				imgui.PopStyleColor()
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(168/255, 0/255, 255/255, 1), 'Написать разработчику')
					imgui.EndTooltip()
					if imgui.IsItemClicked(0) then
						os.execute('start "" "https://vk.com/im?sel=654213586"')
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 155, 10))
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.85, 0.4, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if imgui.Button('##updateBtn', imgui.ImVec2(145,50)) then
					checkForUpdates(true)
				end
				imgui.PopStyleColor(3)
				local btnPos = imgui.GetItemRectMin()
				local drawList = imgui.GetWindowDrawList()
				if fa_font then imgui.PushFont(fa_font) end
				local icon = fa('arrows_rotate')
				local iconSize = imgui.CalcTextSize(icon)
				local iconX = btnPos.x + 10
				local iconY = btnPos.y + (50 - iconSize.y) / 2
				drawList:AddText(imgui.ImVec2(iconX, iconY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), icon)
				if fa_font then imgui.PopFont() end
				local text1 = 'Проверить'
				local text2 = 'обновления'
				local textSize1 = imgui.CalcTextSize(text1)
				local textSize2 = imgui.CalcTextSize(text2)
				local textX1 = btnPos.x + (145 - textSize1.x) / 2
				local textY1 = btnPos.y + 8
				local textX2 = btnPos.x + (145 - textSize2.x) / 2
				local textY2 = btnPos.y + 28
				drawList:AddText(imgui.ImVec2(textX1, textY1), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), text1)
				drawList:AddText(imgui.ImVec2(textX2, textY2), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), text2)
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(0.3, 0.85, 0.4, 1), 'Проверить наличие новых версий скрипта')
					imgui.EndTooltip()
				end
				imgui.Spacing()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				local buttonWidth = 145
				local buttonHeight = 25
				local textStartY = imgui.GetCursorPosY()
				imgui.Text('Команды:')
				do
					local windowWidth = imgui.GetWindowWidth()
					local spacing = 5
					imgui.SetCursorPosY(textStartY)
					imgui.SetCursorPosX(windowWidth - (buttonWidth * 2) - spacing + 140)
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.9, 0.5, 0.2, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.0, 0.6, 0.3, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.8, 0.4, 0.1, 1))
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(fa('trash_can') .. ' Очистить буфер', imgui.ImVec2(buttonWidth, buttonHeight)) then
						if fa_font then imgui.PopFont() end
						clearBuffer()
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.TextColored(imgui.ImVec4(1, 0.8, 0.4, 1), 'Полностью очищает буфер объявлений')
						imgui.EndTooltip()
					end
					imgui.SetCursorPosX(windowWidth - (buttonWidth * 2) - spacing + 140)
					imgui.SetCursorPosY(textStartY + buttonHeight + spacing)
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
					if fa_font then imgui.PushFont(fa_font) end
					local panelButtonText = ''
					local panelCommand = ''
					if data.rankNumber >= 9 then
						panelButtonText = fa('user_tie') .. ' Панель РС'
						panelCommand = 'newsrs'
					elseif data.rankNumber >= 8 then
						panelButtonText = fa('user_tie') .. ' Панель СС'
						panelCommand = 'newsss'
					elseif data.rankNumber >= 3 then
						panelButtonText = fa('user_tie') .. ' Панель МС'
						panelCommand = 'newsms'
					else
						panelButtonText = fa('user_tie') .. ' Панель'
						panelCommand = ''
					end
					if imgui.Button(panelButtonText, imgui.ImVec2(buttonWidth, 40)) then
						if panelCommand ~= '' then
							panels.main[0] = true
							windowsState.rsWindowOpenedFromMainSettings = true
							windows.mainSettings[0] = false
							loadAllNewsButtonsData()
						else
							AddNotification("[News Helper]", "Доступно с 3-го ранга!", "warn", 3.0)
						end
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						local tooltipText = ''
						if data.rankNumber >= 9 then
							tooltipText = 'Панель руководящего состава (/' .. panelCommand .. ')'
						elseif data.rankNumber >= 8 then
							tooltipText = 'Панель старшего состава (/' .. panelCommand .. ')'
						elseif data.rankNumber >= 3 then
							tooltipText = 'Панель младшего состава (/' .. panelCommand .. ')'
						else
							tooltipText = 'Доступно с 3-го ранга'
						end
						imgui.BeginTooltip()
						imgui.TextColored(imgui.ImVec4(0.3, 0.85, 0.4, 1), tooltipText)
						imgui.EndTooltip()
					end
					local btnX = imgui.GetWindowWidth() - 155
					local btnY = imgui.GetCursorPosY() + 0
					imgui.SetCursorPos(imgui.ImVec2(btnX, btnY))
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(fa('sliders') .. ' Команды РП', imgui.ImVec2(145, 40)) then
						commandRPSystem.window[0] = true
						commandRPSystem.openedFromMainSettings = true
						windows.mainSettings[0] = false
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.TextColored(imgui.ImVec4(0.3, 0.85, 0.4, 1), 'Система команд с отыгровками')
						imgui.EndTooltip()
					end
					imgui.SetCursorPosX(windowWidth - (buttonWidth * 2) - spacing + 140)
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.85, 0.4, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
					if imgui.Button('##reloadBtn', imgui.ImVec2(buttonWidth, 40)) then
						AddNotification("[News Helper]", "Скрипт перезагружается...", "info", 2.0)
						lua_thread.create(function()
							wait(500)
							thisScript():reload()
						end)
					end
					imgui.PopStyleColor(3)
					local reloadBtnPos = imgui.GetItemRectMin()
					local reloadDrawList = imgui.GetWindowDrawList()
					if fa_font then imgui.PushFont(fa_font) end
					local reloadIcon = fa('rotate_right')
					local reloadIconSize = imgui.CalcTextSize(reloadIcon)
					local reloadIconX = reloadBtnPos.x + 10
					local reloadIconY = reloadBtnPos.y + (40 - reloadIconSize.y) / 2
					reloadDrawList:AddText(imgui.ImVec2(reloadIconX, reloadIconY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), reloadIcon)
					if fa_font then imgui.PopFont() end
					local reloadText1 = 'Перезагрузить'
					local reloadText2 = 'скрипт'
					local reloadTextSize1 = imgui.CalcTextSize(reloadText1)
					local reloadTextSize2 = imgui.CalcTextSize(reloadText2)
					local reloadTextX1 = reloadBtnPos.x + (buttonWidth - reloadTextSize1.x) / 2
					local reloadTextY1 = reloadBtnPos.y + 3
					local reloadTextX2 = reloadBtnPos.x + (buttonWidth - reloadTextSize2.x) / 2
					local reloadTextY2 = reloadBtnPos.y + 20
					reloadDrawList:AddText(imgui.ImVec2(reloadTextX1, reloadTextY1), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), reloadText1)
					reloadDrawList:AddText(imgui.ImVec2(reloadTextX2, reloadTextY2), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), reloadText2)
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.TextColored(imgui.ImVec4(0.3, 0.85, 0.4, 1), 'Перезагрузить скрипт без выхода из игры')
						imgui.EndTooltip()
					end
					imgui.SetCursorPosY(textStartY + imgui.GetTextLineHeightWithSpacing())
				end
				for _, cmd in ipairs(aboutTabContent.commands) do
					imgui.BulletText(cmd)
				end
				imgui.Separator()
				imgui.Text('Горячие клавиши:')
				imgui.BulletText('Delete - помощь')
				imgui.BulletText('Insert - /prav (можно назначить хоткей во вкладке Горячие клавиши)')
				imgui.BulletText('Q - открыть /edit')
				imgui.BulletText('ESC - закрыть окно')
				imgui.Separator()
				imgui.Text('Что нового?:')
				imgui.BulletText('Версия: ' .. script_version)
				for _, item in ipairs(aboutTabWhatsNew) do
					imgui.TextWrapped('- ' .. item)
				end
			elseif data.currentMainSettingsTab == 1 then
				imgui.Text('Данные пользователя:')
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Имя:')
				imgui.SameLine(120)
				local nickText = (data.mainIni.config.c_nick and data.mainIni.config.c_nick ~= "") and data.mainIni.config.c_nick or "Не определено"
				if not data.editingNick then
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.15, 0.15, 0.15, 0.4))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.6))
					if imgui.Button(nickText .. '##UserNameBtn', imgui.ImVec2(200, 0)) then
						local translatedNick = getPlayerNickTranslated()
						if translatedNick and translatedNick ~= "" then
							data.mainIni.config.c_nick = translatedNick
							if user.nick then ffi.copy(user.nick, translatedNick) end
							saveConfig()
							AddNotification("[News Helper]", "Ник определен: " .. translatedNick, "success", 3.0)
						else
							AddNotification("[News Helper]", "Не удалось определить ник", "error", 5.0)
						end
					end
					imgui.PopStyleColor(3)
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.15, 0.15, 0.15, 0.4))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.6))
					if imgui.Button(fa('pencil') .. '##EditNick', imgui.ImVec2(30, 0)) then
						data.editingNick = true
						ffi.copy(user.nickEditBuffer, data.mainIni.config.c_nick or "")
					end
					imgui.PopStyleColor(3)
				else
					imgui.PushItemWidth(170)
					if imgui.InputText('##NickEdit', user.nickEditBuffer, ffi.sizeof(user.nickEditBuffer), imgui.InputTextFlags.EnterReturnsTrue) then
						local newNick = ffi.string(user.nickEditBuffer)
						if newNick and newNick ~= "" then
							data.mainIni.config.c_nick = newNick
							if user.nick then ffi.copy(user.nick, newNick) end
							saveConfig()
							AddNotification("[News Helper]", "Ник изменен: " .. newNick, "success", 3.0)
						end
						data.editingNick = false
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.2, 0.6))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.3, 0.8))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.4, 0.8, 0.4, 1.0))
					if imgui.Button(fa('check') .. '##ApplyNick', imgui.ImVec2(30, 0)) then
						local newNick = ffi.string(user.nickEditBuffer)
						if newNick and newNick ~= "" then
							data.mainIni.config.c_nick = newNick
							if user.nick then ffi.copy(user.nick, newNick) end
							saveConfig()
							AddNotification("[News Helper]", "Ник изменен: " .. newNick, "success", 3.0)
						end
						data.editingNick = false
					end
					imgui.PopStyleColor(3)
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.6, 0.2, 0.2, 0.6))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.7, 0.3, 0.3, 0.8))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.8, 0.4, 0.4, 1.0))
					if imgui.Button(fa('xmark') .. '##CancelNick', imgui.ImVec2(30, 0)) then
						data.editingNick = false
					end
					imgui.PopStyleColor(3)
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then imgui.SetTooltip('Нажмите для определения имени') end
				imgui.Text('Должность:')
				imgui.SameLine(120)
				local rankText = (data.mainIni.config.c_rang_b and data.mainIni.config.c_rang_b ~= "") and data.mainIni.config.c_rang_b or "Не определено"
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.15, 0.15, 0.15, 0.4))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.6))
				if imgui.Button(rankText .. '##UserRankBtn', imgui.ImVec2(200, 0)) then
					detectMyRank()
					AddNotification("[News Helper]", "Определяем ранг...", "info", 3.0)
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then imgui.SetTooltip('Нажмите для определения должности') end
				imgui.Text('Пол:')
				imgui.SameLine(120)
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Мужской', user.gender, 2) then
					data.mainIni.config.c_pol = user.gender[0]
					saveConfig()
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Женский', user.gender, 1) then
					data.mainIni.config.c_pol = user.gender[0]
					saveConfig()
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Префикс:')
				imgui.SameLine(120)
				imgui.PushItemWidth(150)
				if imgui.InputText('##WaveTag', user.waveTag, ffi.sizeof(user.waveTag)) then
				end
				imgui.PopItemWidth()
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(0.2, 1, 1, 1), 'Введите префикс')
					imgui.TextWrapped('или оставьте пустым, чтобы удалить префикс из всех биндов')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.23, 0.74, 0.32, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('check') .. ' Применить ко всем', imgui.ImVec2(140, 0)) then
					if fa_font then imgui.PopFont() end
					replaceWaveTagInAllBinds(ffi.string(user.waveTag))
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'ВНИМАНИЕ!')
					imgui.TextWrapped('Заменит ВСЕ теги в квадратных скобках [] во всех биндах')
					imgui.EndTooltip()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Вариант биндов:')
				imgui.SameLine(120)
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Вариант 1', imgui.new.int(data.selectedBindsVariant), 1) then
					if data.selectedBindsVariant ~= 1 then
						data.selectedBindsVariant = 1
						saveConfig()
						loadHelpBinds()
						loadBuffer()
						AddNotification("[News Helper]", "Вариант биндов изменен!\nБиндов перезагружены.", "success", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Вариант 2', imgui.new.int(data.selectedBindsVariant), 2) then
					if data.selectedBindsVariant ~= 2 then
						data.selectedBindsVariant = 2
						saveConfig()
						loadHelpBinds()
						loadBuffer()
						AddNotification("[News Helper]", "Вариант биндов изменен!\nБиндов перезагружены.", "success", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Вариант 3', imgui.new.int(data.selectedBindsVariant), 3) then
					if data.selectedBindsVariant ~= 3 then
						data.selectedBindsVariant = 3
						saveConfig()
						loadHelpBinds()
						loadBuffer()
						AddNotification("[News Helper]", "Вариант биндов изменен!\nБиндов перезагружены.", "success", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.7, 0.3, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.74, 0.35, 0.25, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.6, 0.2, 0.1, 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('arrow_rotate_right') .. ' Перескачать##redownloadBindsBtn', imgui.ImVec2(130, 0)) then
					if fa_font then imgui.PopFont() end
					if not ui.binds.confirmRedownloadBinds then
						ui.binds.confirmRedownloadBinds = true
						ui.binds.confirmRedownloadBindsTime = os.clock()
					else
						redownloadAllBinds()
						ui.binds.confirmRedownloadBinds = false
					end
				else
					if fa_font then imgui.PopFont() end
				end
				if ui.binds.confirmRedownloadBinds and imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text('Нажмите еще раз для подтверждения')
					imgui.Separator()
					imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), 'ВНИМАНИЕ!')
					imgui.TextWrapped('Все бинды будут перескачаны и перезагружены')
					imgui.EndTooltip()
				end
				imgui.PopStyleColor(3)
				imgui.SameLine(530)
				imgui.Text('Скачать сборку буферов:')
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.23, 0.74, 0.32, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('download') .. ' Скачать', imgui.ImVec2(100, 0)) then
				if fa_font then imgui.PopFont() end
					downloadBufferPack()
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(250)
					imgui.TextWrapped('628 готовых буфера от Максима')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Цвета:')
				imgui.Spacing()
				imgui.Text('Выберите тему:')
				imgui.Spacing()
				local item = settings.colors.itemButtons
				local themeOrder = {"default", "black", "blue", "red", "green", "orange", "purple", "rgb", "custom"}
				local themeColumns = 9
				local windowWidth = imgui.GetContentRegionAvail().x
				local buttonWidth = (windowWidth / themeColumns) - (themeColumns > 1 and 5 or 0)
				for idx, themeKey in ipairs(themeOrder) do
					local theme = settings.themes.list[themeKey]
					if (idx - 1) % themeColumns ~= 0 then
						imgui.SameLine()
					end
					local currentButtonWidth = buttonWidth
					if themeKey == "custom" then
						currentButtonWidth = buttonWidth * 0.80
					end
					local isSelected = settings.themes.current == themeKey
					if isSelected then
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(math.min(itemColor.x * 1.5, 1), math.min(itemColor.y * 1.5, 1), math.min(itemColor.z * 1.5, 1), itemColor.w))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(itemColor.x * 1.7, 1), math.min(itemColor.y * 1.7, 1), math.min(itemColor.z * 1.7, 1), itemColor.w))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(itemColor.x * 1.9, 1), math.min(itemColor.y * 1.9, 1), math.min(itemColor.z * 1.9, 1), itemColor.w))
					else
						imgui.PushStyleColor(imgui.Col.Button, itemColor)
						imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
						imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					end
					if imgui.Button(theme.name .. '##theme' .. themeKey, imgui.ImVec2(currentButtonWidth, 30)) then
						settings.themes.current = themeKey
						if themeKey ~= "custom" then
							settings.themes.list.custom.colors = {}
							for k, v in pairs(theme.colors) do
								settings.themes.list.custom.colors[k] = {v[1], v[2], v[3], v[4]}
							end
							if not theme.colors.Separator and settings.themes.list.default.colors.Separator then
								local sep = settings.themes.list.default.colors.Separator
								settings.themes.list.custom.colors.Separator = {sep[1], sep[2], sep[3], sep[4]}
							end
							if not theme.colors.SeparatorHovered and settings.themes.list.default.colors.SeparatorHovered then
								local sep = settings.themes.list.default.colors.SeparatorHovered
								settings.themes.list.custom.colors.SeparatorHovered = {sep[1], sep[2], sep[3], sep[4]}
							end
							if not theme.colors.SeparatorActive and settings.themes.list.default.colors.SeparatorActive then
								local sep = settings.themes.list.default.colors.SeparatorActive
								settings.themes.list.custom.colors.SeparatorActive = {sep[1], sep[2], sep[3], sep[4]}
							end
						end
						lua_thread.create(function()
							wait(10)
							applyStyle()
							saveConfig()
						end)
					end
					imgui.PopStyleColor(3)
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Настройка цветов:')
				imgui.Spacing()
				imgui.Indent(30)
				local colorElements = {
					{"Text", "Текст:"},
					{"Border", "Границы:"},
					{"WindowBg", "Фон окна:"},
					{"TitleBgActive", "Заголовок:"},
					{"PopupBg", "Всплывающие:"},
					{"ScrollbarGrab", "Скроллбар:"},
					{"Button", "Кнопка:"},
					{"FrameBgHovered", "Поля ввода:"},
					{"FrameBgActive", "Чекбоксы:"},
					{"Tab", "Вкладка:"},
					{"ResizeGrip", "Изменение:"},
					{"CategoryColor", "Цвет категории:"}
				}
				local currentThemeColors = settings.themes.list.custom.colors
				if not currentThemeColors or not next(currentThemeColors) then
					currentThemeColors = settings.themes.list.default.colors
				end
				local itemsPerRow = 3
				local spacingBetweenColumns = 50
				local maxTextWidths = {0, 0, 0}
				for i = 1, #colorElements do
					local col = (i - 1) % itemsPerRow
					local textSize = imgui.CalcTextSize(colorElements[i][2])
					if textSize.x > maxTextWidths[col + 1] then
						maxTextWidths[col + 1] = textSize.x
					end
				end
				for i = 1, #colorElements do
					local element = colorElements[i]
					local col = (i - 1) % itemsPerRow
					if col > 0 then
						imgui.SameLine(0, spacingBetweenColumns)
					end
					imgui.BeginGroup()
					if not currentThemeColors[element[1]] then
						currentThemeColors[element[1]] = {1, 1, 1, 1}
					end
					local color = imgui.new.float[4](
						currentThemeColors[element[1]][1],
						currentThemeColors[element[1]][2],
						currentThemeColors[element[1]][3],
						currentThemeColors[element[1]][4]
					)
					local textSize = imgui.CalcTextSize(element[2])
					local padding = maxTextWidths[col + 1] - textSize.x
					if padding > 0 then
						imgui.Indent(padding)
					end
					imgui.Text(element[2])
					if padding > 0 then
						imgui.Unindent(padding)
					end
					imgui.SameLine(maxTextWidths[col + 1] + 4, 0)
					imgui.PushItemWidth(40)
					if imgui.ColorEdit4('##color' .. element[1], color, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) then
						settings.themes.current = "custom"
						settings.themes.list.custom.colors[element[1]] = {color[0], color[1], color[2], color[3]}
						applyStyle()
						saveConfig()
					end
					imgui.PopItemWidth()
					imgui.EndGroup()
				end
				imgui.Unindent(30)
				imgui.Spacing()
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('rotate_left') .. ' Сбросить тему', imgui.ImVec2(170, 25)) then
					if settings.themes.current ~= "custom" then
						local baseTheme = settings.themes.list[settings.themes.current]
						settings.themes.list.custom.colors = {}
						for k, v in pairs(baseTheme.colors) do
							settings.themes.list.custom.colors[k] = {v[1], v[2], v[3], v[4]}
						end
					else
						settings.themes.list.custom.colors = {}
						for k, v in pairs(settings.themes.list.default.colors) do
							settings.themes.list.custom.colors[k] = {v[1], v[2], v[3], v[4]}
						end
					end
					applyStyle()
					saveConfig()
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(3)
				imgui.Separator()
				imgui.Spacing()
				local windowWidth = imgui.GetWindowWidth()
				local columnWidth = (windowWidth / 2) - 15
				local columnHeight = 422
				imgui.BeginChild('LeftColumn##settings', imgui.ImVec2(columnWidth, columnHeight), true, imgui.WindowFlags.AlwaysAutoResize)
				imgui.Text('Автобуфер:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text('Автоматически сохраняет объявления в буфер')
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##autoBufferEnabled', flags.autoBufferEnabled, nil, 'Включить автосохранение в буфер', true) then
					saveConfig()
					if flags.autoBufferEnabled[0] then
						AddNotification("[News Helper]", "Автобуфер включен", "info", 3.0)
					else
						AddNotification("[News Helper]", "Автобуфер отключен", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Text('Лимит буфера:')
				imgui.SameLine(100)
				imgui.PushItemWidth(150)
				setupSliderStyle()
				local tempBufferLimit = imgui.new.int(settings.maxBufferSize)
				if imgui.SliderInt('##BufferLimit', tempBufferLimit, 1, 1000) then
					settings.maxBufferSize = tempBufferLimit[0]
					saveConfig()
				end
				cleanupSliderStyle()
				imgui.PopItemWidth()
				imgui.SameLine()
				local textSize = imgui.CalcTextSize(tostring(settings.maxBufferSize))
				local inputWidth = textSize.x + 8.7
				imgui.PushItemWidth(inputWidth)
				local bufferLimitInput = imgui.new.int(settings.maxBufferSize)
				if imgui.InputInt('##BufferLimitInput', bufferLimitInput, 0, 0, imgui.InputTextFlags.EnterReturnsTrue) then
					local value = bufferLimitInput[0]
					if value < 1 then value = 1 end
					if value > 1000 then value = 1000 end
					settings.maxBufferSize = value
					saveConfig()
				end
				imgui.PopItemWidth()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Дополнительные настройки:')
				setupCheckboxStyle()
				if imgui.ToggleButton('##silentMode', settings.silentMode, nil, 'Тихий режим (убрать частые уведомления)', true) then
					saveConfig()
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text('Отключает некоторые частые уведомления')
					imgui.EndTooltip()
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Text('Клавиша прыжка по звездочкам:')
				imgui.SameLine()
				local starKeyName = getKeyName(settings.starJumpKey)
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if imgui.Button(starKeyName .. '##starjumpkey', imgui.ImVec2(100, 25)) then
					ui.hotkeys.isSettingStarKey = true
				end
				imgui.PopStyleColor(3)
				if ui.hotkeys.isSettingStarKey then
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Нажмите клавишу...')
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), 'Клавиша для быстрого перемещения между * в тексте')
					imgui.EndTooltip()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Авто-РП:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Автоматически добавляет заглавную букву')
					imgui.Text('в начало и точку в конец каждого сообщения')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##autoRPEnabled', autoRP.enabled, nil, 'Автоматическое форматирование сообщений', true) then
					saveConfig()
					if autoRP.enabled[0] then
						AddNotification("[News Helper]", "Авто-РП включено", "info", 3.0)
					else
						AddNotification("[News Helper]", "Авто-РП отключено", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Публикация объявления:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('При включении Enter будет публиковать объявление вместо простой отправки текста')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##publishOnEnter', settings.publishOnEnter, nil, 'Публиковать по Enter (вместо отправки)', true) then
					saveConfig()
					if settings.publishOnEnter[0] then
						AddNotification("[News Helper]", "Режим публикации включен", "info", 3.0)
					else
						AddNotification("[News Helper]", "Режим публикации отключен", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Авто просмотр объявлений:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Автоматически выбирает "Просмотреть" при открытии диалога выбора объявления')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##autoViewAdsEnabled', settings.autoViewAds.enabled, nil, 'Автоматически выбирать просмотр', true) then
					saveConfig()
					if settings.autoViewAds.enabled[0] then
						AddNotification("[News Helper]", "Авто просмотр включен", "info", 3.0)
					else
						AddNotification("[News Helper]", "Авто просмотр отключен", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Автодополнение:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Автоматически предлагает слова из биндов и буфера при вводе в кавычках')
					imgui.Text('Также поддерживает транслитерацию (например: "дфь" → "Lamborghini")')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##autocompleteEnabled', settings.autocomplete.enabled, nil, 'Включить автодополнение', true) then
					saveConfig()
					if settings.autocomplete.enabled[0] then
						AddNotification("[News Helper]", "Автодополнение включено", "info", 3.0)
					else
						AddNotification("[News Helper]", "Автодополнение отключено", "info", 3.0)
						autocomplete.active = false
						autocomplete.results = {}
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Закрывать Help по ESC:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Позволяет закрывать окно с биндами нажатием клавиши ESC')
					imgui.Text('Если отключено, окно не будет закрываться по ESC, но будет очищать поле поиска')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##closeHelpByEsc', settings.closeHelpByEsc, nil, 'Закрывать Help по ESC', true) then
					saveConfig()
					if settings.closeHelpByEsc[0] then
						AddNotification("[News Helper]", "Окно с биндами будет\nзакрываться по ESC", "info", 3.0)
					else
						AddNotification("[News Helper]", "Окно с биндами не будет\nзакрываться по ESC", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.EndChild()
				imgui.SameLine()
				imgui.BeginChild('RightColumn##settings', imgui.ImVec2(columnWidth, columnHeight), true, imgui.WindowFlags.AlwaysAutoResize)
				imgui.Text('Разделение буфера:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Разделяет буфер объявлений на две колонки')
					imgui.Text('"Куплю" и "Продам" при поиске')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##bufferSplitEnabled', settings.bufferSplit.enabled, nil, 'Разделять буфер на Куплю/Продам', true) then
					saveConfig()
					if settings.bufferSplit.enabled[0] then
						AddNotification("[News Helper]", "Разделение буфера включено", "info", 3.0)
					else
						AddNotification("[News Helper]", "Разделение буфера отключено", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Автоматическое извлечение цены:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Автоматически извлекает цену из текста объявления')
					imgui.Text('и вставляет её вместо *$ при выборе шаблона')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				if imgui.ToggleButton('##autoPriceExtraction', settings.autoPriceExtraction.enabled, nil, 'Автоматически вставлять цену', true) then
					saveConfig()
					if settings.autoPriceExtraction.enabled[0] then
						AddNotification("[News Helper]", "Автовставка цены включена", "info", 3.0)
					else
						AddNotification("[News Helper]", "Автовставка цены отключена", "info", 3.0)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Рекомендуемые варианты:')
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Показывает кнопки с рекомендуемыми вариантами')
					imgui.Text('из буфера на основе текста объявления')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				setupCheckboxStyle()
				local suggestedButtonsToggle = imgui.new.bool(settings.suggestedButtons.enabled[0])
				if imgui.ToggleButton('##suggestedButtonsEnabled', suggestedButtonsToggle, nil, 'Показывать рекомендуемые варианты', true) then
					settings.suggestedButtons.enabled[0] = suggestedButtonsToggle[0]
					states.suggestedButtonsEnabled = suggestedButtonsToggle[0]
					saveConfig()
					if settings.suggestedButtons.enabled[0] then
						AddNotification("[News Helper]", "Рекомендации включены", "info", 3.0)
					else
						AddNotification("[News Helper]", "Рекомендации отключены", "info", 3.0)
					end
				end
				imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), ('функция очень плохо работает :('))
				cleanupCheckboxStyle()
				imgui.Spacing()
				if settings.suggestedButtons.enabled[0] then
					imgui.Text('Количество кнопок:')
					imgui.SameLine(140)
					imgui.PushItemWidth(150)
					setupSliderStyle()
						local tempTotalButtons = imgui.new.int(settings.suggestedButtons.totalButtons[0] / 4)
						if imgui.SliderInt('##TotalButtons', tempTotalButtons, 1, 12, string.format('%d', tempTotalButtons[0] * 4)) then
						local newValue = tempTotalButtons[0] * 4
						settings.suggestedButtons.totalButtons[0] = newValue
						states.totalButtons = newValue
						saveConfig()
					end
					cleanupSliderStyle()
					imgui.PopItemWidth()
				end
				imgui.Spacing()
				imgui.EndChild()
			elseif data.currentMainSettingsTab == 2 then
				imgui.Text('Настройки автологина:')
				imgui.Separator()
				imgui.Spacing()
				setupCheckboxStyle()
				if imgui.ToggleButton('##autologinEnabled', settings.autologin.enabled, nil, 'Включить автологин', true) then
					saveConfig()
					if settings.autologin.enabled[0] then
						AddNotification("[News Helper]", "Автологин включен", "info", 3.0)
					else
						AddNotification("[News Helper]", "Автологин отключен", "info", 3.0)
					end
				end
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text('Автоматически вводит ваши данные при входе в игру')
					imgui.EndTooltip()
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				if settings.autologin.enabled[0] then
					imgui.Text('Пароль от аккаунта:')
					imgui.PushItemWidth(300)
					local passwordFlags = settings.autologin.showPassword[0] and 0 or imgui.InputTextFlags.Password
					if imgui.InputTextWithHint('##AutologinPassword', 'Введите пароль', settings.autologin.password, sizeof(settings.autologin.password), passwordFlags) then
						saveConfig()
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(settings.autologin.showPassword[0] and 'Скрыть##pass' or 'Показать##pass', imgui.ImVec2(80, 0)) then
						settings.autologin.showPassword[0] = not settings.autologin.showPassword[0]
					end
					imgui.PopStyleColor(3)
					imgui.Spacing()
					imgui.Text('Пин-код:')
					imgui.PushItemWidth(150)
					local pincodeFlags = settings.autologin.showPincode[0] and 0 or imgui.InputTextFlags.Password
					if imgui.InputTextWithHint('##AutologinPincode', 'Пин-код', settings.autologin.pincode, sizeof(settings.autologin.pincode), pincodeFlags) then
						local input_string = ffi.string(settings.autologin.pincode)
						local filtered_string = input_string:gsub('%D', '')
						if filtered_string ~= input_string then
							ffi.copy(settings.autologin.pincode, filtered_string, #filtered_string + 1)
						end
						saveConfig()
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(settings.autologin.showPincode[0] and 'Скрыть##pin' or 'Показать##pin', imgui.ImVec2(80, 0)) then
						settings.autologin.showPincode[0] = not settings.autologin.showPincode[0]
					end
					imgui.PopStyleColor(3)
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					setupCheckboxStyle()
					if imgui.ToggleButton('##autospawnEnabled', flags.autospawnEnabled, nil, 'Автоматически появляться в фракции', true) then
						saveConfig()
						if flags.autospawnEnabled[0] then
							AddNotification("[News Helper]", "Автоспавн включен", "info", 3.0)
						else
							AddNotification("[News Helper]", "Автоспавн отключен", "info", 3.0)
						end
					end
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.Text('При входе в игру автоматически выберет спавн на базе фракции')
						imgui.EndTooltip()
					end
					cleanupCheckboxStyle()
					imgui.Spacing()
					imgui.Separator()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Внимание!')
					imgui.TextWrapped('Ваши данные хранятся локально на вашем компьютере и не передаются третьим лицам.')
				else
					imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Включите автологин для настройки параметров')
				end
			elseif data.currentMainSettingsTab == 3 then
				imgui.Text('Менеджер биндов:')
				imgui.Separator()
				imgui.Spacing()
				local windowWidth = imgui.GetWindowWidth() - 40
				local buttonSize = 103.3
				local spacing = 10
				local buttonsPerRow = 7
				local binderCount = #binder.list
				imgui.BeginChild('##BinderList', imgui.ImVec2(0, -10), false, imgui.WindowFlags.NoScrollbar)
				binder.hoveredIndex = nil
				local drawList = imgui.GetWindowDrawList()
				if not anim.mainSettings.binderItemAnimations then
					anim.mainSettings.binderItemAnimations = {}
				end
				local currentTime = os.clock()
				if not anim.mainSettings.lastAnimTime then
					anim.mainSettings.lastAnimTime = currentTime
				end
				local deltaTime = currentTime - anim.mainSettings.lastAnimTime
				anim.mainSettings.lastAnimTime = currentTime
				local speedMultiplier = math.min(deltaTime * 60, 1)
				for i, bind in ipairs(binder.list) do
					if not anim.mainSettings.binderItemAnimations[i] then
						local isEnabled = bind.enabled ~= false
						anim.mainSettings.binderItemAnimations[i] = {
							scale = 1.0,
							alpha = 1.0,
							targetScale = 1.0,
							targetAlpha = 1.0,
							offsetX = 0,
							targetOffsetX = 0,
							colorLerp = isEnabled and 1.0 or 0.0,
							targetColorLerp = isEnabled and 1.0 or 0.0
						}
					else
						local isEnabled = bind.enabled ~= false
						anim.mainSettings.binderItemAnimations[i].targetColorLerp = isEnabled and 1.0 or 0.0
					end
					local anim_item = anim.mainSettings.binderItemAnimations[i]
					local animSpeed = 0.08
					local colorAnimSpeed = 0.05
					anim_item.scale = anim_item.scale + (anim_item.targetScale - anim_item.scale) * animSpeed * speedMultiplier
					anim_item.alpha = anim_item.alpha + (anim_item.targetAlpha - anim_item.alpha) * animSpeed * speedMultiplier
					anim_item.offsetX = anim_item.offsetX + (anim_item.targetOffsetX - anim_item.offsetX) * animSpeed * speedMultiplier
					anim_item.colorLerp = anim_item.colorLerp + (anim_item.targetColorLerp - anim_item.colorLerp) * colorAnimSpeed * speedMultiplier
				end
				for i, bind in ipairs(binder.list) do
					local col = (i - 1) % buttonsPerRow
					if col > 0 then imgui.SameLine(0, spacing) end
					local cursorPos = imgui.GetCursorScreenPos()
					local item = settings.colors.itemButtons
					imgui.PushIDInt(i)
					local isEnabled = bind.enabled ~= false
					local anim_item = anim.mainSettings.binderItemAnimations[i]
					local lerp = anim_item.colorLerp
					local btnColor = imgui.ImVec4(
						item[0] * lerp + 0.4 * (1 - lerp),
						item[1] * lerp + 0.4 * (1 - lerp),
						item[2] * lerp + 0.4 * (1 - lerp),
						item[3]
					)
					local btnHoveredColor = imgui.ImVec4(
						(math.min(item[0]*1.4, 1) * lerp + 0.5 * (1 - lerp)),
						(math.min(item[1]*1.4, 1) * lerp + 0.5 * (1 - lerp)),
						(math.min(item[2]*1.4, 1) * lerp + 0.5 * (1 - lerp)),
						(item[3]*1.2 * lerp + 1 * (1 - lerp))
					)
					local btnActiveColor = imgui.ImVec4(
						(math.min(item[0]*1.6, 1) * lerp + 0.6 * (1 - lerp)),
						(math.min(item[1]*1.6, 1) * lerp + 0.6 * (1 - lerp)),
						(math.min(item[2]*1.6, 1) * lerp + 0.6 * (1 - lerp)),
						(item[3]*1.4 * lerp + 1 * (1 - lerp))
					)
					imgui.PushStyleColor(imgui.Col.Button, btnColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, btnHoveredColor)
					imgui.PushStyleColor(imgui.Col.ButtonActive, btnActiveColor)
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, anim_item.alpha)
					if imgui.Button('##bindbtn', imgui.ImVec2(buttonSize, buttonSize)) then
						if not binder.skipMainButtonClick then
							binder.wasOpenedFromMainSettings = true
							loadBinderEdit(i)
							windows.mainSettings[0] = false
						end
						binder.skipMainButtonClick = false
					end
					imgui.PopStyleVar()
					imgui.PopStyleColor(3)
					local isHovered = imgui.IsItemHovered()
					local buttonText = bind.name or "без названия"
					if #buttonText > 25 then
						buttonText = buttonText:sub(1, 21) .. ".."
					end
					local textSize = imgui.CalcTextSize(buttonText)
					local textX = cursorPos.x + (buttonSize - textSize.x) / 2
					local textY = cursorPos.y + buttonSize + 3
					drawList:AddText(imgui.ImVec2(textX, textY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, anim_item.alpha)), buttonText)
					local statusLines = {}
					local statusColor = imgui.ImVec4(1, 1, 1, 1)
					local isCommand = false
					if bind.hotkey and #bind.hotkey > 0 then
						local modifierNames = {}
						local regularNames = {}
						for _, key in ipairs(bind.hotkey) do
							local keyName = hotkeyNames[key] or "Unknown"
							if modifierKeys and modifierKeys[key] then
								table.insert(modifierNames, keyName)
							else
								table.insert(regularNames, keyName)
							end
						end
						if bind.useRBM then
							table.insert(statusLines, "ПКМ")
							table.insert(statusLines, "+")
						end
						if #modifierNames > 0 and #regularNames > 0 then
							for _, mod in ipairs(modifierNames) do
								table.insert(statusLines, mod)
							end
							table.insert(statusLines, "+")
							table.insert(statusLines, table.concat(regularNames, " + "))
						elseif #modifierNames > 0 then
							for _, mod in ipairs(modifierNames) do
								table.insert(statusLines, mod)
							end
						else
							table.insert(statusLines, table.concat(regularNames, " + "))
						end
						statusColor = imgui.ImVec4(1, 1, 1, 1)
					elseif bind.command and bind.command ~= "" then
						table.insert(statusLines, "Команда")
						local commandText = "/" .. bind.command
						if #commandText > 9 then
							local firstPart = commandText:sub(1, 9)
							local secondPart = commandText:sub(10)
							table.insert(statusLines, firstPart)
							table.insert(statusLines, secondPart)
						else
							table.insert(statusLines, commandText)
						end
						statusColor = imgui.ImVec4(1, 1, 1, 1)
						isCommand = true
					else
						table.insert(statusLines, "не")
						table.insert(statusLines, "назначено")
						statusColor = imgui.ImVec4(0.7, 0.7, 0.7, 1)
					end
					if ui.fonts.binderStatus then imgui.PushFont(ui.fonts.binderStatus) end
					if #statusLines > 0 then
						local totalHeight = #statusLines * 18
						local startY = cursorPos.y + (buttonSize - totalHeight) / 2
						for idx, line in ipairs(statusLines) do
							local lineSize = imgui.CalcTextSize(line)
							local lineX = cursorPos.x + (buttonSize - lineSize.x) / 2
							local lineY = startY + (idx - 1) * 18
							drawList:AddText(imgui.ImVec2(lineX, lineY), imgui.GetColorU32Vec4(imgui.ImVec4(statusColor.x, statusColor.y, statusColor.z, statusColor.w * anim_item.alpha)), line)
						end
					end
					if ui.fonts.binderStatus then imgui.PopFont() end
					if isHovered then
						binder.hoveredIndex = i
						local btnMin = imgui.ImVec2(cursorPos.x, cursorPos.y)
						local btnMax = imgui.ImVec2(cursorPos.x + buttonSize, cursorPos.y + buttonSize)
						drawList:AddRectFilled(btnMin, btnMax, imgui.GetColorU32Vec4(imgui.ImVec4(0, 0, 0, 0.25)))
						local delBtnSize = 30
						local delBtnX = cursorPos.x + buttonSize - delBtnSize - 5
						local delBtnY = cursorPos.y + 5
						local powerBtnSize = 30
						local powerBtnX = cursorPos.x + 5
						local powerBtnY = cursorPos.y + 5
						local mousePos = imgui.GetMousePos()
						local isOnDelete = mousePos.x >= delBtnX and mousePos.x <= delBtnX + delBtnSize and mousePos.y >= delBtnY and mousePos.y <= delBtnY + delBtnSize
						local isOnPower = mousePos.x >= powerBtnX and mousePos.x <= powerBtnX + powerBtnSize and mousePos.y >= powerBtnY and mousePos.y <= powerBtnY + powerBtnSize
						local isConfirming = binder.deleteConfirm == i
						local delColor = isConfirming and imgui.ImVec4(1, 0.3, 0.3, 0.5) or imgui.ImVec4(1, 1, 1, 0)
						drawList:AddRectFilled(imgui.ImVec2(delBtnX, delBtnY), imgui.ImVec2(delBtnX + delBtnSize, delBtnY + delBtnSize), imgui.GetColorU32Vec4(delColor), 4)
						if fa_font then imgui.PushFont(fa_font) end
						local trashIcon = fa('trash')
						local trashSize = imgui.CalcTextSize(trashIcon)
						local trashX = delBtnX + (delBtnSize - trashSize.x) / 2
						local trashY = delBtnY + (delBtnSize - trashSize.y) / 2
						local trashColor = isConfirming and imgui.ImVec4(1, 0.3, 0.3, 1) or imgui.ImVec4(1, 1, 1, 1)
						drawList:AddText(imgui.ImVec2(trashX, trashY), imgui.GetColorU32Vec4(trashColor), trashIcon)
						local powerColor = isEnabled and imgui.ImVec4(0.3, 1, 0.3, 0) or imgui.ImVec4(0.8, 0.2, 0.2, 0)
						drawList:AddRectFilled(imgui.ImVec2(powerBtnX, powerBtnY), imgui.ImVec2(powerBtnX + powerBtnSize, powerBtnY + powerBtnSize), imgui.GetColorU32Vec4(powerColor), 4)
						local powerIcon = fa('power_off')
						local powerSize = imgui.CalcTextSize(powerIcon)
						local powerIconX = powerBtnX + (powerBtnSize - powerSize.x) / 2
						local powerIconY = powerBtnY + (powerBtnSize - powerSize.y) / 2
						local powerIconColor = isEnabled and imgui.ImVec4(1, 1, 1, 1) or imgui.ImVec4(0.8, 0.2, 0.2, 1)
						drawList:AddText(imgui.ImVec2(powerIconX, powerIconY), imgui.GetColorU32Vec4(powerIconColor), powerIcon)
						if fa_font then imgui.PopFont() end
						if isOnDelete then
							drawList:AddRectFilled(imgui.ImVec2(delBtnX, delBtnY), imgui.ImVec2(delBtnX + delBtnSize, delBtnY + delBtnSize), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 0.15)), 4)
							if imgui.IsMouseClicked(0) then
								binder.skipMainButtonClick = true
								if isConfirming then
									local anim_item = anim.mainSettings.binderItemAnimations[i]
									anim_item.targetScale = 0.0
									anim_item.targetAlpha = 0
									anim_item.targetOffsetX = 0
								else
									binder.deleteConfirm = i
								end
							end
							if isConfirming then
								imgui.SetTooltip('Нажмите еще раз для подтверждения')
							else
								imgui.SetTooltip('Удалить бинд')
							end
						end
						if isOnPower then
							drawList:AddRectFilled(imgui.ImVec2(powerBtnX, powerBtnY), imgui.ImVec2(powerBtnX + powerBtnSize, powerBtnY + powerBtnSize), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 0.15)), 4)
							if imgui.IsMouseClicked(0) then
								binder.skipMainButtonClick = true
								local anim_item = anim.mainSettings.binderItemAnimations[i]
								anim_item.targetColorLerp = bind.enabled and 0.0 or 1.0
								bind.enabled = not (bind.enabled ~= false)
								saveBinder()
							end
							local statusText = (bind.enabled ~= false) and "Отключить бинд" or "Включить бинд"
							imgui.SetTooltip(statusText)
						end
					end
					imgui.PopID()
					if (i % buttonsPerRow == 0) and (i ~= binderCount) then
						imgui.Dummy(imgui.ImVec2(0, 25))
					end
				end
				local toDelete = {}
				for i, anim_item in pairs(anim.mainSettings.binderItemAnimations) do
					if anim_item.targetAlpha == 0 and anim_item.alpha < 0.05 then
						table.insert(toDelete, i)
					end
				end
				table.sort(toDelete, function(a, b) return a > b end)
				for _, i in ipairs(toDelete) do
					deleteBinder(i)
					local newAnimations = {}
					for j = 1, #binder.list do
						if anim.mainSettings.binderItemAnimations[j] then
							newAnimations[j] = anim.mainSettings.binderItemAnimations[j]
						end
					end
					anim.mainSettings.binderItemAnimations = newAnimations
					binder.deleteConfirm = nil
				end
				if binder.hoveredIndex == nil and binder.deleteConfirm then
					binder.deleteConfirm = nil
				end
				local addCol = binderCount % buttonsPerRow
				if addCol > 0 then
					imgui.SameLine(0, spacing)
				else
					imgui.Dummy(imgui.ImVec2(0, 25))
				end
				local addCursorPos = imgui.GetCursorScreenPos()
				local item = settings.colors.itemButtons
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, item[3]*0.5))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0], item[1], item[2], item[3]*0.8))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.2, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.4))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('plus') .. '##addnew', imgui.ImVec2(buttonSize, buttonSize)) then
					binder.wasOpenedFromMainSettings = true
					createNewBinder()
					local newIndex = #binder.list
					anim.mainSettings.binderItemAnimations[newIndex] = {
						scale = 0.8,
						alpha = 0,
						targetScale = 1.0,
						targetAlpha = 1.0,
						offsetX = 0,
						targetOffsetX = 0,
						colorLerp = 1.0,
						targetColorLerp = 1.0
					}
					windows.mainSettings[0] = false
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(3)
				local addTextSize = imgui.CalcTextSize('Новый бинд')
				local addTextX = addCursorPos.x + (buttonSize - addTextSize.x) / 2
				local addTextY = addCursorPos.y + buttonSize + 3
				drawList:AddText(imgui.ImVec2(addTextX, addTextY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), 'Новый бинд')
				imgui.EndChild()
			elseif data.currentMainSettingsTab == 4 then
				imgui.Text('Настройка горячих клавиш:')
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Окно помощи:')
				local toRemoveHelp = nil
				for i = 1, #ui.hotkeys.help do
					imgui.SameLine()
					local buttonText = ui.hotkeys.isSettingHelp and ui.hotkeys.currentIndex == i and 
									'Нажмите клавишу...' or getKeyName(ui.hotkeys.help[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##helpkey' .. i, imgui.ImVec2(130, 25)) then
						ui.hotkeys.isSettingHelp = true
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #ui.hotkeys.help > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removehelpkey' .. i, imgui.ImVec2(25, 25)) then
							toRemoveHelp = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemoveHelp then
					table.remove(ui.hotkeys.help, toRemoveHelp)
					saveConfig()
				end
				if #ui.hotkeys.help < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addhelpkey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.help, vk.VK_DELETE)
						ui.hotkeys.isSettingHelp = true
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = #ui.hotkeys.help
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Text('Окно Справочника:')
				local toRemovePro = nil
				if #ui.hotkeys.sprav == 0 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor.x * 0.5, itemColor.y * 0.5, itemColor.z * 0.5, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor.x * 0.7, itemColor.y * 0.7, itemColor.z * 0.7, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(itemColor.x * 0.9, itemColor.y * 0.9, itemColor.z * 0.9, 1))
					if imgui.Button('Не назначено##prokey0', imgui.ImVec2(130, 25)) then
						table.insert(ui.hotkeys.sprav, vk.VK_INSERT)
						ui.hotkeys.isSettingPro = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = 1
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Нажмите, чтобы назначить горячую клавишу')
					end
				else
					for i = 1, #ui.hotkeys.sprav do
						imgui.SameLine()
						local buttonText = ui.hotkeys.isSettingPro and ui.hotkeys.currentIndex == i and 
										'Нажмите клавишу...' or getKeyName(ui.hotkeys.sprav[i])
						imgui.PushStyleColor(imgui.Col.Button, itemColor)
						imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
						imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
						if imgui.Button(buttonText .. '##prokey' .. i, imgui.ImVec2(130, 25)) then
							ui.hotkeys.isSettingPro = true
							ui.hotkeys.isSettingHelp = false
							ui.hotkeys.isSettingEdit = false
							ui.hotkeys.currentIndex = i
							ui.hotkeys.tempBuffer = {}
						end
						imgui.PopStyleColor(3)
						if #ui.hotkeys.sprav > 1 then
							imgui.SameLine()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
							if imgui.Button('X##removeprokey' .. i, imgui.ImVec2(25, 25)) then
								toRemovePro = i
							end
							imgui.PopStyleColor(3)
						elseif #ui.hotkeys.sprav == 1 then
							imgui.SameLine()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
							if imgui.Button('X##removeprokey' .. i, imgui.ImVec2(25, 25)) then
								toRemovePro = i
							end
							imgui.PopStyleColor(3)
						end
					end
				end
				if toRemovePro then
					table.remove(ui.hotkeys.sprav, toRemovePro)
					saveConfig()
				end
				if #ui.hotkeys.sprav > 0 and #ui.hotkeys.sprav < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addprokey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.sprav, vk.VK_INSERT)
						ui.hotkeys.isSettingPro = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = #ui.hotkeys.sprav
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), '(также можно командой /prav)')
				imgui.Spacing()
				imgui.Text('Пауза эфира:')
				local toRemovePause = nil
				for i = 1, #efir.control.pauseHotkey do
					imgui.SameLine()
					local buttonText = efir.control.isSettingPauseKey and ui.hotkeys.currentIndex == i and 
									'Нажмите клавишу...' or getKeyName(efir.control.pauseHotkey[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##pausekey' .. i, imgui.ImVec2(130, 25)) then
						efir.control.isSettingPauseKey = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #efir.control.pauseHotkey > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removepausekey' .. i, imgui.ImVec2(25, 25)) then
							toRemovePause = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemovePause then
					table.remove(efir.control.pauseHotkey, toRemovePause)
					saveConfig()
				end
				if #efir.control.pauseHotkey < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addpausekey', imgui.ImVec2(25, 25)) then
						table.insert(efir.control.pauseHotkey, vk.VK_K)
						efir.control.isSettingPauseKey = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = #efir.control.pauseHotkey
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Text('Окно настроек:')
				local toRemoveSettings = nil
				for i = 1, #ui.hotkeys.settings do
					imgui.SameLine()
					local buttonText = ui.hotkeys.isSettingSettings and ui.hotkeys.currentIndex == i and 
									'Нажмите клавишу...' or getKeyName(ui.hotkeys.settings[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##settingskey' .. i, imgui.ImVec2(130, 25)) then
						ui.hotkeys.isSettingSettings = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						efir.control.isSettingPauseKey = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #ui.hotkeys.settings > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removesettingskey' .. i, imgui.ImVec2(25, 25)) then
							toRemoveSettings = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemoveSettings then
					table.remove(ui.hotkeys.settings, toRemoveSettings)
					saveConfig()
				end
				if #ui.hotkeys.settings < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addsettingskey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.settings, vk.VK_M)
						ui.hotkeys.isSettingSettings = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						efir.control.isSettingPauseKey = false
						ui.hotkeys.currentIndex = #ui.hotkeys.settings
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Text('Фокус на поиск (Help):')
				local toRemoveHelpSearch = nil
				for i = 1, #ui.hotkeys.helpSearch do
					imgui.SameLine()
					local buttonText = ui.hotkeys.isSettingHelpSearch and ui.hotkeys.currentIndex == i and 
									'Нажмите клавишу...' or getKeyName(ui.hotkeys.helpSearch[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##helpsearchkey' .. i, imgui.ImVec2(130, 25)) then
						ui.hotkeys.isSettingHelpSearch = true
						ui.hotkeys.isSettingSettings = false
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						efir.control.isSettingPauseKey = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #ui.hotkeys.helpSearch > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removehelpsearchkey' .. i, imgui.ImVec2(25, 25)) then
							toRemoveHelpSearch = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemoveHelpSearch then
					table.remove(ui.hotkeys.helpSearch, toRemoveHelpSearch)
					saveConfig()
				end
				if #ui.hotkeys.helpSearch < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addhelpsearchkey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.helpSearch, vk.VK_RCONTROL)
						ui.hotkeys.isSettingHelpSearch = true
						ui.hotkeys.isSettingSettings = false
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						efir.control.isSettingPauseKey = false
						ui.hotkeys.currentIndex = #ui.hotkeys.helpSearch
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if imgui.Button('Вернуть по умолчанию', imgui.ImVec2(180, 30)) then
					ui.hotkeys.help = {vk.VK_DELETE}
					ui.hotkeys.sprav = {}
					ui.hotkeys.settings = {vk.VK_CONTROL, vk.VK_M}
					ui.hotkeys.helpSearch = {vk.VK_RCONTROL}
					ui.hotkeys.isSettingHelp = false
					ui.hotkeys.isSettingPro = false
					ui.hotkeys.isSettingEdit = false
					ui.hotkeys.isSettingSettings = false
					ui.hotkeys.isSettingHelpSearch = false
					ui.hotkeys.currentIndex = 0
					ui.hotkeys.tempBuffer = {}
					saveConfig()
					AddNotification("[News Helper]", "Горячие клавиши сброшены", "success", 3.0)
				end
				imgui.PopStyleColor(3)
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Подсказка:')
				imgui.TextWrapped('Нажмите на кнопку с названием клавиши, чтобы изменить её. Используйте кнопку "+", чтобы создать комбинацию из нескольких клавиш (до 3). Нажмите ESC для отмены изменения.')
			elseif data.currentMainSettingsTab == 5 then
				imgui.Text('Чекер сотрудников:')
				setupCheckboxStyle()
				if imgui.Checkbox('Включить чекер', settings.checker.enabled) then
					if settings.checker.enabled[0] then
						windows.checker[0] = true
						settings.checker.waiting = false
						settings.checker.requestAttempts = 0
						settings.checker.lastUpdate = 0
						data.membersList = {}
						lua_thread.create(function()
							wait(100)
							if not sampIsChatInputActive() and not sampIsDialogActive() then
								sampSendChat("/members")
								settings.checker.waiting = true
								settings.checker.requestTime = os.clock()
							end
						end)
					else
						windows.checker[0] = false
						data.membersList = {}
					end
					saveConfig()
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor.x * 1.2, itemColor.y * 1.2, itemColor.z * 1.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(itemColor.x * 1.4, itemColor.y * 1.4, itemColor.z * 1.4, 1))
				imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(4, 3))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('arrows_up_down_left_right') .. ' ##PositionChecker', imgui.ImVec2(20, 20)) then
					if settings.checker.enabled[0] then
						settings.checker.positioning = true
						windows.mainSettings[0] = false
						AddNotification("[News Helper]", "Переместите мышку в\nнужное место и нажмите ЛКМ", "info", 5.0)
					else
						AddNotification("[News Helper]", "Сначала включите чекер", "warn", 3.0)
					end
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleVar()
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Изменить расположение чекера')
				end
				imgui.Spacing()
				imgui.Text('Интервал обновления (сек):')
				imgui.PushItemWidth(200)
				setupSliderStyle()
				if imgui.SliderInt('##CheckerInterval', settings.checker.interval, 3, 30) then
					membersCheckerUpdateInterval = settings.checker.interval[0] * 1000
					saveConfig()
				end
				cleanupSliderStyle()
				imgui.PopItemWidth()
				imgui.Text('Цвет заголовка:')
				imgui.SameLine(150)
				if imgui.ColorEdit4('##CheckerColor', settings.checker.textColor, imgui.ColorEditFlags.NoInputs) then
					saveConfig()
				end
				imgui.Text('Размер шрифта:')
				imgui.PushItemWidth(200)
				setupSliderStyle()
				if imgui.SliderInt('##CheckerFontSize', settings.checker.fontSize, 10, 30) then
					saveConfig()
				end
				cleanupSliderStyle()
				imgui.PopItemWidth()
			elseif data.currentMainSettingsTab == 6 then
				if data.rankNumber < 5 then
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.3)
					imgui.Text('Выберите тип эфира:')
					imgui.Separator()
					imgui.Spacing()
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
					local windowWidth = imgui.GetWindowWidth() - 17
					local buttonWidth = (windowWidth - 40) / 5
					local buttonHeight = 40
					local spacing = 10
					for i, efirType in ipairs(efirTypes) do
						local col = (i - 1) % 5
						if col > 0 then imgui.SameLine(0, spacing) end
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.5, 0.5, 0.5, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.5, 0.5, 0.5, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.5, 0.5, 0.5, 1))
						imgui.Button(efirType.name .. '##' .. efirType.key, imgui.ImVec2(buttonWidth, buttonHeight))
						imgui.PopStyleColor(3)
						if i % 5 == 0 then imgui.Spacing() end
					end
					imgui.PopStyleVar()
					local winWidth = imgui.GetWindowWidth()
					local winHeight = imgui.GetWindowHeight()
					local topOffset = 50
					local overlayHeight = winHeight - topOffset - 10
					imgui.SetCursorPos(imgui.ImVec2(0, topOffset))
					imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0.6))
					imgui.BeginChild('##BlockedEfirOverlay', imgui.ImVec2(winWidth, overlayHeight), false, imgui.WindowFlags.NoScrollbar)
					local rankSuffix = data.rankNumber == 1 and "-ый" or data.rankNumber == 2 and "-ой" or data.rankNumber == 3 and "-ий" or "-ый"
					local text = string.format("Доступно с 5-го ранга\nВы сейчас %d%s", data.rankNumber, rankSuffix)
					imgui.SetWindowFontScale(2.0)
					local textSize = imgui.CalcTextSize(text)
					imgui.SetCursorPos(imgui.ImVec2(winWidth / 2 - textSize.x / 2, overlayHeight / 2 - textSize.y / 2))
					imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), text)
					imgui.SetWindowFontScale(1.0)
					imgui.EndChild()
					imgui.PopStyleColor()
				else
					imgui.Text('Выберите тип эфира:')
					imgui.Separator()
					imgui.Spacing()
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
					local windowWidth = imgui.GetWindowWidth() - 17
					local buttonWidth = (windowWidth - 40) / 5
					local buttonHeight = 40
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
							if efirType.key == 'math' or efirType.key == 'country' or efirType.key == 'himia' 
								or efirType.key == 'zerkalo' or efirType.key == 'annagramm' or efirType.key == 'zagadki' 
								or efirType.key == 'sinonim' then
								tabWindowSizes[6].y = 1040
							else
								tabWindowSizes[6].y = 580
							end
							tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
						end
						imgui.PopStyleColor(3)
						if imgui.IsItemHovered() then imgui.SetTooltip(efirType.desc) end
						if i % 5 == 0 then imgui.Spacing() end
					end
					imgui.Separator()
					imgui.Spacing()
					if efir.selectedType and efir.messages[efir.selectedType] then
						imgui.Text('Выбранный эфир: ' .. efir.selectedType)
						imgui.Spacing()
						imgui.BeginChild('##EfirControl', imgui.ImVec2(0, 0), true)
						if efir.selectedType == 'math' then renderMathEfir()
						elseif efir.selectedType == 'country' then renderCountryEfir()
						elseif efir.selectedType == 'himia' then renderHimiaEfir()
						elseif efir.selectedType == 'zerkalo' then renderZerkaloEfir()
						elseif efir.selectedType == 'annagramm' then renderAnnagrammEfir()
						elseif efir.selectedType == 'zagadki' then renderZagadkiEfir()
						elseif efir.selectedType == 'sinonim' then renderSinonimEfir()
						elseif efir.selectedType == 'inter' then renderInterviewEfir()
						elseif efir.selectedType == 'reklama' then renderReklamaEfir()
						elseif efir.selectedType == 'sobes' then renderSobesEfir() end
						imgui.EndChild()
					else
						imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Выберите тип эфира для начала работы')
					end
				end
			elseif data.currentMainSettingsTab == 7 then
				if data.rankNumber < 5 then
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.3)
					renderEfirMessagesEditor()
					imgui.PopStyleVar()
					local winWidth = imgui.GetWindowWidth()
					local winHeight = imgui.GetWindowHeight()
					local topOffset = 50
					local overlayHeight = winHeight - topOffset - 10
					imgui.SetCursorPos(imgui.ImVec2(0, topOffset))
					imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0.7))
					imgui.BeginChild('##BlockedMessages', imgui.ImVec2(winWidth, overlayHeight), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoInputs)
					local rankSuffix = data.rankNumber == 1 and "-ый" or data.rankNumber == 2 and "-ой" or data.rankNumber == 3 and "-ий" or "-ый"
					local text = string.format("Доступно с 5-го ранга\nВы сейчас %d%s", data.rankNumber, rankSuffix)
					imgui.SetWindowFontScale(2.0)
					local textSize = imgui.CalcTextSize(text)
					imgui.SetCursorPos(imgui.ImVec2(winWidth / 2 - textSize.x / 2, overlayHeight / 2 - textSize.y / 2))
					imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), text)
					imgui.SetWindowFontScale(1.0)
					imgui.EndChild()
					imgui.PopStyleColor()
				else
					renderEfirMessagesEditor()
				end
			elseif data.currentMainSettingsTab == 8 then
				if data.rankNumber < 5 then
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.3)
					renderFreeEfirTab()
					imgui.PopStyleVar()
					local winWidth = imgui.GetWindowWidth()
					local winHeight = imgui.GetWindowHeight()
					local topOffset = 50
					local overlayHeight = winHeight - topOffset - 10
					imgui.SetCursorPos(imgui.ImVec2(0, topOffset))
					imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0.7))
					imgui.BeginChild('##BlockedFreeEfir', imgui.ImVec2(winWidth, overlayHeight), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoInputs)
					local rankSuffix = data.rankNumber == 1 and "-ый" or data.rankNumber == 2 and "-ой" or data.rankNumber == 3 and "-ий" or "-ый"
					local text = string.format("Доступно с 5-го ранга\nВы сейчас %d%s", data.rankNumber, rankSuffix)
					imgui.SetWindowFontScale(2.0)
					local textSize = imgui.CalcTextSize(text)
					imgui.SetCursorPos(imgui.ImVec2(winWidth / 2 - textSize.x / 2, overlayHeight / 2 - textSize.y / 2))
					imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), text)
					imgui.SetWindowFontScale(1.0)
					imgui.EndChild()
					imgui.PopStyleColor()
				else
					tabWindowSizes[8].y = calculateFreeEfirTabHeight()
					renderFreeEfirTab()
				end
			end
			imgui.EndChild()
		end
		imgui.PopStyleVar(1)
		imgui.PopStyleColor(colorCount)
		imgui.End()
	end).Priority = settings.renderPriority + 30
	imgui.OnFrame(function() return windows.customAd[0] end, function()
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		local sizeX, sizeY = getScreenResolution()
		local bg = settings.colors.background
		local windowWidth = settings.customAd.size.x
		local adText = settings.customAd.data.advertisement or 'N/A'
		if not states.adChildHeight then
			states.adChildHeight = 25
		end
		if not states.adExtraHeight then
			states.adExtraHeight = 0
		end
		if not states.searchResults then
			states.searchResults = {}
		end
		if not states.currentSearchPage then
			states.currentSearchPage = 1
		end
		if not states.buttonsPerRow then
			states.buttonsPerRow = 4
		end
		if not states.totalButtons then
			states.totalButtons = settings.suggestedButtons.totalButtons and settings.suggestedButtons.totalButtons[0] or 8
		end
		if states.lastSearchedAd ~= adText then
			states.lastSearchedAd = adText
			states.searchResults = searchByAdvertisement(adText)
			states.currentSearchPage = 1
		end
		local suggestedButtonsHeight = 0
		if settings.suggestedButtons.enabled[0] and #states.searchResults > 0 then
			local buttonsPerRow = 4
			local actualButtonsToShow = math.min(states.totalButtons, #states.searchResults)
			local rowsPerPage = math.ceil(actualButtonsToShow / buttonsPerRow)
			local totalPages = math.ceil(#states.searchResults / actualButtonsToShow)
			suggestedButtonsHeight = 20
			suggestedButtonsHeight = suggestedButtonsHeight + 10
			suggestedButtonsHeight = suggestedButtonsHeight + (rowsPerPage * 30)
			suggestedButtonsHeight = suggestedButtonsHeight + math.max(0, (rowsPerPage - 1) * 5)
			suggestedButtonsHeight = suggestedButtonsHeight + 15
			if totalPages > 1 then
				suggestedButtonsHeight = suggestedButtonsHeight + 35
			end
		end
		if states.lastAdText ~= adText then
			states.lastAdText = adText
			local fullText = 'Объявление: ' .. adText
			local textSize = imgui.CalcTextSize(fullText)
			local childWidth = windowWidth - 20
			local estimatedLines = math.ceil(textSize.x / childWidth)
			local contentHeight = estimatedLines * 15 + 5
			states.adExtraHeight = 0
			states.adChildHeight = 25
			if contentHeight > 25 then
				local requiredHeight = contentHeight
				local additionalHeight = math.ceil((requiredHeight - 25) / 15) * 15
				states.adChildHeight = 25 + additionalHeight
				local expansionCount = math.floor(additionalHeight / 15)
				if expansionCount == 1 then
					states.adExtraHeight = 5
				elseif expansionCount == 2 then
					states.adExtraHeight = 20
				else
					states.adExtraHeight = 20 + (expansionCount - 2) * 15
				end
			else
				states.adExtraHeight = -10
			end
		end
		local windowHeight = settings.customAd.size.y + states.adExtraHeight + suggestedButtonsHeight
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(windowWidth, windowHeight), imgui.Cond.Always)
		local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + settings.topMostFlags
		imgui.Begin('##CustomAd', nil, windowFlags)
		if windows.customAd[0] then
			bringWindowToFront()
		end
		local titleSize = imgui.CalcTextSize('Объявление')
		imgui.SetCursorPosX((imgui.GetWindowWidth() - titleSize.x) / 2)
		imgui.Text('Объявление')
		imgui.SameLine()
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(400)
			imgui.TextColored(imgui.ImVec4(0.7, 0.3, 1, 1), 'Горячие клавиши:')
			imgui.Separator()
			if fa_font then imgui.PushFont(fa_font) end
			imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), fa('arrow_up'))
			imgui.SameLine()
			imgui.Text('- Вставить текст из буфера с совпадающим объявлением')
			imgui.TextColored(imgui.ImVec4(1, 0.5, 0.3, 1), fa('arrow_down'))
			imgui.SameLine()
			imgui.Text('- Вернуть оригинальный введенный текст')
			imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), getKeyName(settings.starJumpKey))
			imgui.SameLine()
			imgui.Text('- Прыгать между звездочками (*) в тексте')
			imgui.TextColored(imgui.ImVec4(0.9, 0.6, 1, 1), 'TAB')
			imgui.SameLine()
			imgui.Text('- Автодополнение слов в кавычках')
			if fa_font then imgui.PopFont() end
			imgui.Separator()
			imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Автоформатирование:")
			imgui.Text('- Текст в двойных кавычках пишется с заглавной буквы')
			imgui.Text('- [ее], [ае], [ые] → [TT], [FT], [ST]')
			imgui.Text('- [tt], [ft], [st] → [TT], [FT], [ST]')
			imgui.Separator()
			if settings.autocomplete.enabled[0] then
				imgui.TextColored(imgui.ImVec4(0.5, 1, 0.9, 1), "Автодополнение слов:")
				imgui.Text('- Начните печатать слово в кавычках: "раб или "Lam')
				imgui.Text('- Подсказки берутся из ваших биндов, буфера и списка машин')
				imgui.Text('- Поддержка транслитерации: "дфь" → "Lamborghini"')
				if fa_font then imgui.PushFont(fa_font) end
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), fa('arrow_up') .. ' / ' .. fa('arrow_down'))
				if fa_font then imgui.PopFont() end
				imgui.SameLine()
				imgui.Text('- Навигация по списку подсказок (когда видно 1/5, 2/5...)')
				imgui.TextColored(imgui.ImVec4(0.9, 0.6, 1, 1), 'TAB')
				imgui.SameLine()
				imgui.Text('- Вставить выбранную подсказку')
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), '- Можно отключить в настройках')
			else
				imgui.TextColored(imgui.ImVec4(1, 0.5, 0.5, 1), "Автодополнение: отключено")
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), '- Можно включить в настройках')
			end
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
		imgui.Separator()
		imgui.Spacing()
		local textColor = imgui.ImVec4(
			settings.themes.list.custom.colors.Text[1],
			settings.themes.list.custom.colors.Text[2],
			settings.themes.list.custom.colors.Text[3],
			settings.themes.list.custom.colors.Text[4]
		)
		local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local myNick = myId and sampGetPlayerNickname(myId) or ""
		myNick = myNick:gsub("%[PC%]", ""):gsub("%[M%]", "")
		local authorNick = (settings.customAd.data.author or ""):gsub("%[PC%]", ""):gsub("%[M%]", "")
		local authorText = ''
		local authorId = nil
		local authorColor = textColor
		local function getPlatform(nick)
			if nick:match("%[PC%]") then
				return "[PC]"
			elseif nick:match("%[M%]") then
				return "[M]"
			end
			return ""
		end
		if authorNick == myNick then
			authorId = myId
			local color = sampGetPlayerColor(myId)
			local r = bit.band(bit.rshift(color, 16), 0xFF)
			local g = bit.band(bit.rshift(color, 8), 0xFF)
			local b = bit.band(color, 0xFF)
			authorColor = imgui.ImVec4(r / 255.0, g / 255.0, b / 255.0, 1)
			local platform = getPlatform(sampGetPlayerNickname(myId))
			authorText = (settings.customAd.data.author or 'N/A') .. '[' .. tostring(myId) .. ']' .. platform
		elseif settings.customAd.data.isAuthorOnline and settings.customAd.data.authorId then
			authorId = settings.customAd.data.authorId
			local color = sampGetPlayerColor(authorId)
			local r = bit.band(bit.rshift(color, 16), 0xFF)
			local g = bit.band(bit.rshift(color, 8), 0xFF)
			local b = bit.band(color, 0xFF)
			authorColor = imgui.ImVec4(r / 255.0, g / 255.0, b / 255.0, 1)
			local platform = getPlatform(sampGetPlayerNickname(authorId))
			authorText = (settings.customAd.data.author or 'N/A') .. '[' .. tostring(settings.customAd.data.authorId) .. ']' .. platform
		else
			authorText = (settings.customAd.data.author or 'N/A') .. '[не в сети]'
		end
		imgui.TextColored(authorColor, 'Автор: ' .. authorText)
		imgui.Text('Номер телефона: ' .. (settings.customAd.data.phone or 'N/A'))
		imgui.BeginChild('##AdText', imgui.ImVec2(-1, states.adChildHeight), false, imgui.WindowFlags.NoScrollbar)
		imgui.TextWrapped('Объявление: ' .. adText)
		imgui.EndChild()
		imgui.Text('Введите ответ:')
		imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
		local inputFlags = imgui.InputTextFlags.EnterReturnsTrue
		if flags.inputRecreateFrame > 0 then
			if flags.inputRecreateFrame == 4 then
				imgui.InvisibleButton('##InputPlaceholder', imgui.ImVec2(imgui.GetWindowWidth() - 20, 20))
				imgui.SetKeyboardFocusHere(-1)
			elseif flags.inputRecreateFrame == 3 then
				if flags.pendingBufferInsert then
					ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
					local len = math.min(#flags.pendingBufferInsert, ffi.sizeof(settings.customAd.responseText) - 1)
					ffi.copy(settings.customAd.responseText, flags.pendingBufferInsert, len)
					if not states.pendingCursorPos then
						states.pendingCursorPos = 0
					end
					flags.pendingBufferInsert = nil
				end
				imgui.InvisibleButton('##InputPlaceholder', imgui.ImVec2(imgui.GetWindowWidth() - 20, 20))
			elseif flags.inputRecreateFrame == 2 then
				imgui.PushFont(inputFont)
				imgui.InputText('##AdResponse', settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText), inputFlags)
				imgui.PopFont()
				imgui.SetKeyboardFocusHere(-1)
				flags.inputFieldActive = imgui.IsItemActive()
			elseif flags.inputRecreateFrame == 1 then
				local inputTextFlags = imgui.InputTextFlags.CallbackAlways
				if #states.starPositions > 0 then
					inputTextFlags = inputTextFlags + imgui.InputTextFlags.CallbackCharFilter
				end
				imgui.PushFont(inputFont)
				imgui.InputText('##AdResponse', settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText), inputTextFlags, 
					function(data)
						states.CustomAdEditCallback(data)
						if states.pendingCursorPos then
							data.CursorPos = states.pendingCursorPos
							data.SelectionStart = states.pendingCursorPos
							data.SelectionEnd = states.pendingCursorPos
							states.pendingCursorPos = nil
						end
						return 0
					end)
				imgui.PopFont()
				flags.inputFieldActive = imgui.IsItemActive()
			end
			flags.inputRecreateFrame = flags.inputRecreateFrame - 1
		elseif flags.updateCursorOnly then
			local inputTextFlags = imgui.InputTextFlags.CallbackAlways
			if #states.starPositions > 0 or settings.autocomplete.enabled[0] then
				inputTextFlags = inputTextFlags + imgui.InputTextFlags.CallbackCharFilter
			end
			imgui.PushFont(inputFont)
			imgui.InputText('##AdResponse', settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText), inputTextFlags, 
				function(data)
					states.CustomAdEditCallback(data)
					if states.pendingCursorPos then
						data.CursorPos = states.pendingCursorPos
						data.SelectionStart = states.pendingCursorPos
						data.SelectionEnd = states.pendingCursorPos
						states.pendingCursorPos = nil
					end
					return 0
				end)
			imgui.PopFont()
			flags.inputFieldActive = imgui.IsItemActive()
			flags.updateCursorOnly = false
		else
			local inputTextFlags = imgui.InputTextFlags.CallbackAlways
			if #states.starPositions > 0 or settings.autocomplete.enabled[0] then
				inputTextFlags = inputTextFlags + imgui.InputTextFlags.CallbackCharFilter
			end
			imgui.PushFont(inputFont)
			imgui.InputText('##AdResponse', settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText), inputTextFlags, states.CustomAdEditCallbackCast)
			imgui.PopFont()
			flags.inputFieldActive = imgui.IsItemActive()
		end
		if flags.focusResponse and flags.inputRecreateFrame == 0 then
			imgui.SetKeyboardFocusHere(-1)
			flags.focusResponse = false
		end
		imgui.PopItemWidth()
		imgui.Spacing()
		local topButtonCount = flags.autoBufferEnabled[0] and 4 or 5
		local spacing = flags.autoBufferEnabled[0] and 10 or 4
		local totalWidth = imgui.GetWindowWidth() - 20
		local totalSpacing = (topButtonCount - 1) * spacing
		local buttons = {}
		if not flags.autoBufferEnabled[0] then
			table.insert(buttons, { label = fa('copy') .. ' В буфер', width = 0 })
		end
		table.insert(buttons, { label = fa('wand_magic_sparkles') .. ' Вставка', width = 0 })
		table.insert(buttons, { label = fa('file_contract') .. ' Цена', width = 0 })
		table.insert(buttons, { label = fa('share') .. ' Опубликовать', width = 0 })
		table.insert(buttons, { label = fa('trash_can') .. ' Удалить', width = 0 })
		for i, btn in ipairs(buttons) do
			local textSize = imgui.CalcTextSize(btn.label)
			btn.width = textSize.x + 20
		end
		local totalTextWidth = 0
		for i, btn in ipairs(buttons) do
			totalTextWidth = totalTextWidth + btn.width
		end
		local availableWidth = totalWidth - totalSpacing
		if totalTextWidth > availableWidth then
			local scale = availableWidth / totalTextWidth
			for i, btn in ipairs(buttons) do
				btn.width = btn.width * scale
			end
		else
			local extraSpace = (availableWidth - totalTextWidth) / #buttons
			for i, btn in ipairs(buttons) do
				btn.width = btn.width + extraSpace
			end
		end
		local item = settings.colors.itemButtons
		if buttonsDisabled then imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5) end
		local buttonIdx = 1
		if not flags.autoBufferEnabled[0] then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
			if fa_font then imgui.PushFont(fa_font) end
			imgui.Button(buttons[buttonIdx].label, imgui.ImVec2(buttons[buttonIdx].width, 25))
			if imgui.IsItemHovered() and imgui.IsMouseReleased(0) then
				if not buttonsDisabled then
					local response = ffi.string(settings.customAd.responseText)
					if response ~= '' and not response:match("^%s*$") then
						saveToAdBuffer(response, true)
						chatMessage(u8:decode('[News Helper] Сохранено в буфер'), 0x00FF00)
					else
						chatMessage(u8:decode('[News Helper] Введите текст ответа!'), 0xFF0000)
					end
				end
			end
			if fa_font then imgui.PopFont() end
			imgui.PopStyleColor(3)
			imgui.SameLine(0, spacing)
			buttonIdx = buttonIdx + 1
		end
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(buttons[buttonIdx].label, imgui.ImVec2(buttons[buttonIdx].width, 25)) then
			if fa_font then imgui.PopFont() end
			if settings.customAd.originalText then
				local processedText = settings.customAd.originalText
				processedText = processedText:gsub('\n', ''):gsub('\r', ''):gsub('\t', ' ')
				ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
				local len = math.min(#processedText, ffi.sizeof(settings.customAd.responseText)-1)
				ffi.copy(settings.customAd.responseText, processedText, len)
				flags.inputRecreateFrame = 4
				states.pendingCursorPos = 0
				flags.focusResponse = true
			else
				chatMessage(u8:decode('[News Helper] Оригинальный текст недоступен!'), 0xFF0000)
			end
		end
		if imgui.IsMouseReleased(1) and imgui.IsItemHovered() then
			local currentText = ffi.string(settings.customAd.responseText)
			local prefix = getWavePrefixFromBinds()
			if not currentText:match("^" .. prefix:gsub("%[", "%%["):gsub("%]", "%%]")) then
				local newText = prefix .. currentText
				ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
				local len = math.min(#newText, ffi.sizeof(settings.customAd.responseText) - 1)
				ffi.copy(settings.customAd.responseText, newText, len)
				flags.inputRecreateFrame = 4
				local cursorPos = #prefix
				states.pendingCursorPos = cursorPos
				flags.focusResponse = true
			end
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'ЛКМ:')
			imgui.SameLine()
			imgui.Text('Вставить оригинальный текст объявления')
			imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'ПКМ:')
			imgui.SameLine()
			imgui.Text('Добавить префикс волны в начало')
			imgui.EndTooltip()
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine(0, spacing)
		buttonIdx = buttonIdx + 1
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(buttons[buttonIdx].label, imgui.ImVec2(buttons[buttonIdx].width, 25)) then
			if fa_font then imgui.PopFont() end
			local currentText = ffi.string(settings.customAd.responseText)
			local newText = currentText:gsub('свободный', ""):gsub('договорная', "")
			local colonPos = newText:find(':')
			if colonPos then
				newText = newText:sub(1, colonPos - 1)
			end
			newText = newText:gsub('%s+$', "") .. ': договорная'
			ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
			local len = math.min(#newText, ffi.sizeof(settings.customAd.responseText) - 1)
			ffi.copy(settings.customAd.responseText, newText, len)
			flags.inputRecreateFrame = 4
			local cursorPos = #newText - #'договорная'
			states.pendingCursorPos = cursorPos
			flags.focusResponse = true
		end
		if imgui.IsMouseReleased(1) and imgui.IsItemHovered() then
			local currentText = ffi.string(settings.customAd.responseText)
			local newText = currentText:gsub('договорная', ""):gsub('свободный', "")
			local colonPos = newText:find(':')
			if colonPos then
				newText = newText:sub(1, colonPos - 1)
			end
			newText = newText:gsub('%s+$', "") .. ': свободный'
			ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
			local len = math.min(#newText, ffi.sizeof(settings.customAd.responseText) - 1)
			ffi.copy(settings.customAd.responseText, newText, len)
			flags.inputRecreateFrame = 4
			local cursorPos = #newText - #'свободный'
			states.pendingCursorPos = cursorPos
			flags.focusResponse = true
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'ЛКМ:')
			imgui.SameLine()
			imgui.Text('Добавить слово "договорная"')
			imgui.TextColored(imgui.ImVec4(1, 0.5, 0.3, 1), 'ПКМ:')
			imgui.SameLine()
			imgui.Text('Добавить слово "свободный"')
			imgui.EndTooltip()
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine(0, spacing)
		buttonIdx = buttonIdx + 1
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.7, 0.15, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(buttons[buttonIdx].label, imgui.ImVec2(buttons[buttonIdx].width, 25)) then
			if not buttonsDisabled then publishAdvertisement() end
		end
		if fa_font then imgui.PopFont() end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), 'Сразу опубликует объявление')
			if not settings.publishOnEnter[0] then
				imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'Опубликовать по Enter можно в настройках')
			end
			imgui.EndTooltip()
		end
		imgui.PopStyleColor(3)
		imgui.SameLine(0, spacing)
		buttonIdx = buttonIdx + 1
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.0, 0.4, 0.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(buttons[buttonIdx].label, imgui.ImVec2(buttons[buttonIdx].width, 25)) then
			if fa_font then imgui.PopFont() end
			if not buttonsDisabled then
				local reason = ffi.string(settings.customAd.responseText)
				if reason ~= '' and not reason:match("^%s*$") then
					settings.customAd.deleteMode = true
					settings.customAd.deleteReason = reason
					closeCustomAd(false)
				else
					chatMessage(u8:decode('[News Helper] Введите причину удаления!'), 0xFF0000)
				end
			end
		end
		if imgui.IsMouseReleased(1) and imgui.IsItemHovered() then
			if not buttonsDisabled then
				settings.customAd.deleteMode = true
				settings.customAd.deleteReason = "Некорректно"
				closeCustomAd(false)
			end
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'ЛКМ:')
			imgui.SameLine()
			imgui.Text('Удалить с введённой причиной')
			imgui.TextColored(imgui.ImVec4(1, 0.5, 0.3, 1), 'ПКМ:')
			imgui.SameLine()
			imgui.Text('Удалить с причиной "Некорректно"')
			imgui.EndTooltip()
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		if buttonsDisabled then imgui.PopStyleVar() end
		imgui.Spacing()
		imgui.Separator()
		local bigButtonWidth = (imgui.GetWindowWidth() - 20 - 5) / 2
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('circle_xmark') .. ' Закрыть', imgui.ImVec2(bigButtonWidth, 35)) then
			if fa_font then imgui.PopFont() end
			if not buttonsDisabled then
				closeCustomAd(false)
			end
		end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.4, 1.0, 0.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('paper_plane') .. ' Отправить', imgui.ImVec2(bigButtonWidth, 35)) then
			if fa_font then imgui.PopFont() end
			if not buttonsDisabled then
				doSendResponse()
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		if settings.suggestedButtons.enabled[0] and #states.searchResults > 0 then
			local buttonsPerRow = 4
			local actualButtonsToShow = math.min(states.totalButtons, #states.searchResults)
			local rowsPerPage = math.ceil(actualButtonsToShow / buttonsPerRow)
			local totalPages = math.ceil(#states.searchResults / actualButtonsToShow)
			local childHeight = 20
			childHeight = childHeight + 10
			childHeight = childHeight + (rowsPerPage * 30)
			childHeight = childHeight + math.max(0, (rowsPerPage - 1) * 5)
			childHeight = childHeight + 15
			if totalPages > 1 then
				childHeight = childHeight + 35
			end
			imgui.BeginChild('##SuggestedButtonsChild', imgui.ImVec2(-1, childHeight), true)
			imgui.Text('Рекомендуемые варианты:')
			imgui.Spacing()
			local windowAvailWidth = imgui.GetContentRegionAvail().x
			local buttonWidth = (windowAvailWidth - (buttonsPerRow - 1) * 5) / buttonsPerRow
			local startIdx = (states.currentSearchPage - 1) * actualButtonsToShow + 1
			local endIdx = math.min(startIdx + actualButtonsToShow - 1, #states.searchResults)
			local item = settings.colors.itemButtons
			for i = startIdx, endIdx do
				local result = states.searchResults[i]
				if result then
					local colIdx = (i - startIdx) % buttonsPerRow
					if colIdx > 0 then
						imgui.SameLine(0, 5)
					end
					local btnLabel = result.text:sub(1, 15)
					if #result.text > 15 then
						btnLabel = btnLabel .. "..."
					end
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
					if imgui.Button(btnLabel .. '##result' .. i, imgui.ImVec2(buttonWidth, 30)) then
						local insertText = insertPrice(result.text, adText)
						ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
						local len = math.min(#insertText, ffi.sizeof(settings.customAd.responseText) - 1)
						ffi.copy(settings.customAd.responseText, insertText, len)
						flags.inputRecreateFrame = 4
						states.pendingCursorPos = 0
						flags.focusResponse = true
					end
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(300)
						local tooltipText = insertPrice(result.text, adText)
						imgui.TextWrapped(tooltipText)
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					imgui.PopStyleColor(3)
				end
			end
			imgui.Spacing()
			if totalPages > 1 then
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], item[3]))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(math.min(item[0]*1.4, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(math.min(item[0]*1.6, 1), math.min(item[1]*1.6, 1), math.min(item[2]*1.6, 1), item[3]*1.6))
				local pageText = string.format("%d/%d", states.currentSearchPage, totalPages)
				local pageTextSize = imgui.CalcTextSize(pageText)
				local navWidth = 25 + 5 + pageTextSize.x + 5 + 25
				local availWidth = imgui.GetContentRegionAvail().x
				local offsetX = (availWidth - navWidth) / 2
				imgui.SetCursorPosX(imgui.GetCursorPosX() + offsetX)
				if states.currentSearchPage > 1 then
					if imgui.Button('<<', imgui.ImVec2(25, 25)) then
						states.currentSearchPage = states.currentSearchPage - 1
					end
					imgui.SameLine(0, 5)
				end
				imgui.Text(pageText)
				if states.currentSearchPage < totalPages then
					imgui.SameLine(0, 5)
					if imgui.Button('>>', imgui.ImVec2(25, 25)) then
						states.currentSearchPage = states.currentSearchPage + 1
					end
				end
				imgui.PopStyleColor(3)
			end
			imgui.EndChild()
		end
		if autocomplete.active and #autocomplete.results > 0 and flags.inputFieldActive then
			if autocomplete.selectedIdx < 1 or autocomplete.selectedIdx > #autocomplete.results then
				autocomplete.selectedIdx = 1
			end
			local vehicle = autocomplete.results[autocomplete.selectedIdx]
			if not vehicle then
				autocomplete.active = false
				autocomplete.results = {}
				goto skip_autocomplete
			end
			local textSize = imgui.CalcTextSize(vehicle)
			local indicator = string.format(" (%d/%d)", autocomplete.selectedIdx, #autocomplete.results)
			local indicatorSize = imgui.CalcTextSize(indicator)
			local popupWidth = textSize.x + indicatorSize.x + 0
			local popupHeight = 22
			local popupX = autocomplete.cursorScreenPos.x
			local popupY = autocomplete.cursorScreenPos.y - 45
			local cursorPosBefore = imgui.GetCursorPos()
			imgui.SetCursorScreenPos(imgui.ImVec2(popupX, popupY))
			local bg = settings.colors.background
			imgui.PushStyleColor(imgui.Col.Header, imgui.ImVec4(bg[0] * 1.3, bg[1] * 1.3, bg[2] * 1.3, 0.9))
			imgui.PushStyleColor(imgui.Col.HeaderHovered, imgui.ImVec4(bg[0] * 1.5, bg[1] * 1.5, bg[2] * 1.5, 1.0))
			imgui.PushStyleColor(imgui.Col.HeaderActive, imgui.ImVec4(bg[0] * 1.7, bg[1] * 1.7, bg[2] * 1.7, 1.0))
			imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(6, 3))
			imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 4)
			if imgui.Selectable(vehicle .. indicator, true, 0, imgui.ImVec2(popupWidth, popupHeight)) then
				insertAutocompleteResult(vehicle)
			end
			imgui.PopStyleVar(2)
			imgui.PopStyleColor(3)
			imgui.SetCursorPos(cursorPosBefore)
			::skip_autocomplete::
		end
		imgui.End()
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority = settings.renderPriority + 110
	imgui.OnFrame(function() return settings.checker.enabled[0] and windows.checker[0] end, function(arg)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		arg.HideCursor=not settings.checker.positioning
		if settings.checker.positioning then
			local mx,my=getCursorPos()
			settings.checker.pos.x,settings.checker.pos.y=mx,my
		end
		imgui.SetNextWindowPos(imgui.ImVec2(settings.checker.pos.x,settings.checker.pos.y),imgui.Cond.Always)
		local windowFlags=imgui.WindowFlags.NoTitleBar+imgui.WindowFlags.NoResize+imgui.WindowFlags.NoScrollbar+imgui.WindowFlags.NoCollapse+imgui.WindowFlags.AlwaysAutoResize+settings.topMostFlags
		if settings.checker.positioning then windowFlags=windowFlags+imgui.WindowFlags.NoInputs end
		imgui.PushStyleColor(imgui.Col.WindowBg,imgui.ImVec4(0,0,0,0))
		imgui.Begin('##MembersChecker',nil,windowFlags)
		local textFont=getCheckerFont(settings.checker.fontSize[0])
		if textFont then imgui.PushFont(textFont) end
		local headerColor=imgui.ImVec4(settings.checker.textColor[0],settings.checker.textColor[1],settings.checker.textColor[2],settings.checker.textColor[3])
		if settings.checker.positioning then
			imgui.TextColored(imgui.ImVec4(1,1,0,1),'Нажмите ЛКМ чтобы закрепить')
			if isKeyJustPressed(vk.VK_LBUTTON) then
				settings.checker.positioning=false
				settings.checker.firstSetup=false
				saveConfig()
				AddNotification("[News Helper]", "Позиция чекера сохранена", "success", 3.0)
			end
		end
		imgui.TextColored(headerColor,'Сотрудники в сети:')
		if settings.checker.waiting and #data.membersList==0 then
			imgui.TextColored(imgui.ImVec4(0.7,0.7,0.7,1),'Загрузка...')
		elseif #data.membersList==0 then
			imgui.TextColored(imgui.ImVec4(0.7,0.7,0.7,1),'Никого нет в сети')
		else
			local onlineCount,noUniformCount,muteCount,afkCount=0,0,0,0
			for _,m in ipairs(data.membersList) do
				if m.online then
					onlineCount=onlineCount+1
					if m.noUniform then noUniformCount=noUniformCount+1 end
					if m.mute then muteCount=muteCount+1 end
					if m.afk then afkCount=afkCount+1 end
					local pos=tostring(m.position or "?")
					local name=tostring(m.name or "?")
					local phone=tostring(m.phone or "N/A")
					local warns=tostring(m.warns or "?")
					local mainText=string.format("%s[%d] | %s [%d]",pos,tonumber(m.rank) or 0,name,tonumber(m.id) or 0)
					local mainColor=m.noUniform and imgui.ImVec4(1,0.27,0.27,1) or imgui.ImVec4(1,1,1,1)
					imgui.TextColored(mainColor,mainText)
					imgui.SameLine(0,3)
					if m.platform then
						imgui.TextColored(mainColor,string.format("[%s]",tostring(m.platform)))
						imgui.SameLine(0,3)
					end
					imgui.TextColored(mainColor,string.format("| %s | %s",phone,warns))
					imgui.SameLine(0,3)
					if m.afk then
						imgui.TextColored(imgui.ImVec4(1,1,0,1),string.format("| AFK: %s",tostring(m.afk)))
						imgui.SameLine(0,3)
					end
					if m.mute then
						imgui.TextColored(imgui.ImVec4(1,0,0,1),string.format("| В муте (%s)",tostring(m.mute)))
						imgui.SameLine(0,3)
					end
					if m.noUniform then imgui.TextColored(imgui.ImVec4(1,0.27,0.27,1),"| БЕЗ ФОРМЫ") else imgui.Text("") end
				end
			end
			imgui.Spacing()
			local total=#data.membersList
			imgui.TextColored(imgui.ImVec4(0,1,0,1),'Всего: ')
			imgui.SameLine(0,0)
			imgui.TextColored(imgui.ImVec4(0,1,0,1),tostring(total))
			imgui.SameLine(0,3)
			imgui.TextColored(imgui.ImVec4(1,1,0,1),'| В АФК: ')
			imgui.SameLine(0,0)
			imgui.TextColored(imgui.ImVec4(1,1,0,1),tostring(afkCount))
			imgui.SameLine(0,3)
			imgui.TextColored(imgui.ImVec4(1,0,0,1),'| В муте: ')
			imgui.SameLine(0,0)
			imgui.TextColored(imgui.ImVec4(1,0,0,1),tostring(muteCount))
		end
		if textFont then imgui.PopFont() end
		imgui.End()
		imgui.PopStyleColor()
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end).Priority=settings.renderPriority + 300
	imgui.OnFrame(function() return #notifications > 0 end, function(self)
		local colorCount = baseTheme.enabled and pushBaseColors() or pushRgbColors()
		if not colorCount then colorCount = 0 end
		RenderNotifications()
		self.HideCursor = true
		if colorCount and colorCount > 0 then
			if baseTheme.enabled then
				popBaseColors(colorCount)
			else
				popRgbColors(colorCount)
			end
		end
	end)
end
