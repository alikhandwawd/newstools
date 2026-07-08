function applyStyle()
	if settings.themes.current == "rgb" then
		baseTheme.enabled = false
		baseTheme.colors = nil
		rgbTheme.enabled = true
		return
	end
	rgbTheme.enabled = false
	baseTheme.enabled = true
	baseTheme.colors = {}  
	local success = pcall(function()
		local style = imgui.GetStyle()
		style.WindowRounding = 8
		style.FrameRounding = 4
		style.ScrollbarRounding = 4
		style.WindowBorderSize = 0
	end)
	if not success then
	end
	local currentColors = settings.themes.list.custom.colors
	if not currentColors or not next(currentColors) then
		currentColors = settings.themes.list.default.colors
	end
	if currentColors.TitleBgActive then
		currentColors.TitleBg = {
			currentColors.TitleBgActive[1] * 0.7,
			currentColors.TitleBgActive[2] * 0.7,
			currentColors.TitleBgActive[3] * 0.7,
			currentColors.TitleBgActive[4]
		}
	end
	if currentColors.ScrollbarGrab then
		currentColors.ScrollbarGrabHovered = {
			math.min(currentColors.ScrollbarGrab[1] * 1.2, 1),
			math.min(currentColors.ScrollbarGrab[2] * 1.2, 1),
			math.min(currentColors.ScrollbarGrab[3] * 1.2, 1),
			currentColors.ScrollbarGrab[4]
		}
		currentColors.ScrollbarGrabActive = {
			math.min(currentColors.ScrollbarGrab[1] * 1.4, 1),
			math.min(currentColors.ScrollbarGrab[2] * 1.4, 1),
			math.min(currentColors.ScrollbarGrab[3] * 1.4, 1),
			currentColors.ScrollbarGrab[4]
		}
		currentColors.ScrollbarBg = {
			currentColors.ScrollbarGrab[1] * 0.2,
			currentColors.ScrollbarGrab[2] * 0.2,
			currentColors.ScrollbarGrab[3] * 0.2,
			currentColors.ScrollbarGrab[4]
		}
	end
	if currentColors.FrameBgHovered then
		currentColors.FrameBg = {
			currentColors.FrameBgHovered[1] * 0.85,
			currentColors.FrameBgHovered[2] * 0.85,
			currentColors.FrameBgHovered[3] * 0.85,
			currentColors.FrameBgHovered[4]
		}
	end
	if currentColors.Border then
		currentColors.Separator = {
			currentColors.Border[1],
			currentColors.Border[2],
			currentColors.Border[3],
			0.5
		}
		currentColors.SeparatorHovered = {
			math.min(currentColors.Border[1] * 1.2, 1),
			math.min(currentColors.Border[2] * 1.2, 1),
			math.min(currentColors.Border[3] * 1.2, 1),
			0.78
		}
		currentColors.SeparatorActive = {
			math.min(currentColors.Border[1] * 1.4, 1),
			math.min(currentColors.Border[2] * 1.4, 1),
			math.min(currentColors.Border[3] * 1.4, 1),
			1
		}
	end
	local validImGuiColors = {
		"Text", "TextDisabled", "WindowBg", "ChildBg", "PopupBg", "Border", "BorderShadow",
		"FrameBg", "FrameBgHovered", "FrameBgActive", "TitleBg", "TitleBgActive", "TitleBgCollapsed",
		"MenuBarBg", "ScrollbarBg", "ScrollbarGrab", "ScrollbarGrabHovered", "ScrollbarGrabActive",
		"CheckMark", "SliderGrab", "SliderGrabActive", "Button", "ButtonHovered", "ButtonActive",
		"Header", "HeaderHovered", "HeaderActive", "Separator", "SeparatorHovered", "SeparatorActive",
		"ResizeGrip", "ResizeGripHovered", "ResizeGripActive", "Tab", "TabHovered", "TabActive",
		"TabUnfocused", "TabUnfocusedActive", "PlotLines", "PlotLinesHovered", "PlotHistogram",
		"PlotHistogramHovered", "TextSelectedBg", "DragDropTarget", "NavHighlight", "NavWindowingHighlight",
		"NavWindowingDimBg", "ModalWindowDimBg"
	}
	for _, colorName in ipairs(validImGuiColors) do
		if currentColors[colorName] then
			baseTheme.colors[colorName] = currentColors[colorName]
		end
	end
	if currentColors.Button then
		settings.colors.itemButtons[0] = currentColors.Button[1]
		settings.colors.itemButtons[1] = currentColors.Button[2]
		settings.colors.itemButtons[2] = currentColors.Button[3]
		settings.colors.itemButtons[3] = currentColors.Button[4]
	end
	if currentColors.CategoryColor then
		settings.colors.categoryButtons[0] = currentColors.CategoryColor[1]
		settings.colors.categoryButtons[1] = currentColors.CategoryColor[2]
		settings.colors.categoryButtons[2] = currentColors.CategoryColor[3]
		settings.colors.categoryButtons[3] = currentColors.CategoryColor[4]
		baseTheme.colors.Header = {
			currentColors.CategoryColor[1],
			currentColors.CategoryColor[2],
			currentColors.CategoryColor[3],
			currentColors.CategoryColor[4] * 0.31
		}
		baseTheme.colors.HeaderHovered = {
			math.min(currentColors.CategoryColor[1] * 1.2, 1),
			math.min(currentColors.CategoryColor[2] * 1.2, 1),
			math.min(currentColors.CategoryColor[3] * 1.2, 1),
			currentColors.CategoryColor[4] * 0.8
		}
		baseTheme.colors.HeaderActive = {
			math.min(currentColors.CategoryColor[1] * 1.4, 1),
			math.min(currentColors.CategoryColor[2] * 1.4, 1),
			math.min(currentColors.CategoryColor[3] * 1.4, 1),
			currentColors.CategoryColor[4]
		}
	end
	if currentColors.WindowBg then
		settings.colors.background[0] = currentColors.WindowBg[1]
		settings.colors.background[1] = currentColors.WindowBg[2]
		settings.colors.background[2] = currentColors.WindowBg[3]
		settings.colors.background[3] = currentColors.WindowBg[4]
	end
end
function pushBaseColors()
	if not baseTheme.enabled or not baseTheme.colors then return 0 end
	local colorsToPush = {
		{imgui.Col.Text, baseTheme.colors.Text},
		{imgui.Col.TextDisabled, baseTheme.colors.TextDisabled},
		{imgui.Col.WindowBg, baseTheme.colors.WindowBg},
		{imgui.Col.ChildBg, baseTheme.colors.ChildBg},
		{imgui.Col.PopupBg, baseTheme.colors.PopupBg},
		{imgui.Col.Border, baseTheme.colors.Border},
		{imgui.Col.BorderShadow, baseTheme.colors.BorderShadow},
		{imgui.Col.FrameBg, baseTheme.colors.FrameBg},
		{imgui.Col.FrameBgHovered, baseTheme.colors.FrameBgHovered},
		{imgui.Col.FrameBgActive, baseTheme.colors.FrameBgActive},
		{imgui.Col.TitleBg, baseTheme.colors.TitleBg},
		{imgui.Col.TitleBgActive, baseTheme.colors.TitleBgActive},
		{imgui.Col.TitleBgCollapsed, baseTheme.colors.TitleBgCollapsed},
		{imgui.Col.MenuBarBg, baseTheme.colors.MenuBarBg},
		{imgui.Col.ScrollbarBg, baseTheme.colors.ScrollbarBg},
		{imgui.Col.ScrollbarGrab, baseTheme.colors.ScrollbarGrab},
		{imgui.Col.ScrollbarGrabHovered, baseTheme.colors.ScrollbarGrabHovered},
		{imgui.Col.ScrollbarGrabActive, baseTheme.colors.ScrollbarGrabActive},
		{imgui.Col.CheckMark, baseTheme.colors.CheckMark},
		{imgui.Col.SliderGrab, baseTheme.colors.SliderGrab},
		{imgui.Col.SliderGrabActive, baseTheme.colors.SliderGrabActive},
		{imgui.Col.Button, baseTheme.colors.Button},
		{imgui.Col.ButtonHovered, baseTheme.colors.ButtonHovered},
		{imgui.Col.ButtonActive, baseTheme.colors.ButtonActive},
		{imgui.Col.Header, baseTheme.colors.Header},
		{imgui.Col.HeaderHovered, baseTheme.colors.HeaderHovered},
		{imgui.Col.HeaderActive, baseTheme.colors.HeaderActive},
		{imgui.Col.Separator, baseTheme.colors.Separator},
		{imgui.Col.SeparatorHovered, baseTheme.colors.SeparatorHovered},
		{imgui.Col.SeparatorActive, baseTheme.colors.SeparatorActive},
		{imgui.Col.ResizeGrip, baseTheme.colors.ResizeGrip},
		{imgui.Col.ResizeGripHovered, baseTheme.colors.ResizeGripHovered},
		{imgui.Col.ResizeGripActive, baseTheme.colors.ResizeGripActive},
		{imgui.Col.Tab, baseTheme.colors.Tab},
		{imgui.Col.TabHovered, baseTheme.colors.TabHovered},
		{imgui.Col.TabActive, baseTheme.colors.TabActive},
		{imgui.Col.TabUnfocused, baseTheme.colors.TabUnfocused},
		{imgui.Col.TabUnfocusedActive, baseTheme.colors.TabUnfocusedActive},
		{imgui.Col.PlotLines, baseTheme.colors.PlotLines},
		{imgui.Col.PlotLinesHovered, baseTheme.colors.PlotLinesHovered},
		{imgui.Col.PlotHistogram, baseTheme.colors.PlotHistogram},
		{imgui.Col.PlotHistogramHovered, baseTheme.colors.PlotHistogramHovered},
		{imgui.Col.TextSelectedBg, baseTheme.colors.TextSelectedBg},
		{imgui.Col.DragDropTarget, baseTheme.colors.DragDropTarget},
		{imgui.Col.NavHighlight, baseTheme.colors.NavHighlight},
		{imgui.Col.NavWindowingHighlight, baseTheme.colors.NavWindowingHighlight},
		{imgui.Col.NavWindowingDimBg, baseTheme.colors.NavWindowingDimBg},
		{imgui.Col.ModalWindowDimBg, baseTheme.colors.ModalWindowDimBg}
	}
	local pushedCount = 0
	for _, colorData in ipairs(colorsToPush) do
		if colorData[2] then
			local col = colorData[2]
			if col[1] and col[2] and col[3] and col[4] then
				imgui.PushStyleColor(colorData[1], imgui.ImVec4(col[1], col[2], col[3], col[4]))
				pushedCount = pushedCount + 1
			end
		end
	end
	return pushedCount
end
function popBaseColors(count)
	if count and count > 0 then
		imgui.PopStyleColor(count)
	end
end
function hsvToRgb(h, s, v)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	i = i % 6
	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end
	return r, g, b
end
function updateRgbTheme()
	if not rgbTheme.enabled then return end
	local currentTime = os.clock()
	if currentTime - rgbTheme.lastUpdate < rgbTheme.updateInterval then return end
	rgbTheme.lastUpdate = currentTime
	rgbTheme.hue = (rgbTheme.hue + (rgbTheme.speed * rgbTheme.updateInterval)) % 360
	local h = rgbTheme.hue / 360
	local r, g, b = hsvToRgb(h, 0.7, 1)
	local buttonR, buttonG, buttonB = r * 0.65, g * 0.65, b * 0.65
	local buttonHoverR, buttonHoverG, buttonHoverB = r * 0.75, g * 0.75, b * 0.75
	local buttonActiveR, buttonActiveG, buttonActiveB = r * 0.85, g * 0.85, b * 0.85
	local textR, textG, textB = 0.98 + (r - 0.98) * 0.3, 0.98 + (g - 0.98) * 0.3, 0.98 + (b - 0.98) * 0.3
	local rVeryDark, gVeryDark, bVeryDark = r * 0.15, g * 0.15, b * 0.15
	local rDark, gDark, bDark = r * 0.3, g * 0.3, b * 0.3
	local rMedium, gMedium, bMedium = r * 0.4, g * 0.4, b * 0.4
	local rLight, gLight, bLight = math.min(r * 1.2, 1), math.min(g * 1.2, 1), math.min(b * 1.2, 1)
	local rVeryLight, gVeryLight, bVeryLight = math.min(r * 1.4, 1), math.min(g * 1.4, 1), math.min(b * 1.4, 1)
	settings.themes.list.custom.colors.Text = {textR, textG, textB, 1}
	settings.themes.list.custom.colors.WindowBg = {rVeryDark, gVeryDark, bVeryDark, 0.94}
	settings.themes.list.custom.colors.ChildBg = {rVeryDark * 0.9, gVeryDark * 0.9, bVeryDark * 0.9, 0.0}
	settings.themes.list.custom.colors.PopupBg = {rVeryDark, gVeryDark, bVeryDark, 0.94}
	settings.themes.list.custom.colors.Border = {r * 0.7, g * 0.7, b * 0.7, 0.5}
	settings.themes.list.custom.colors.BorderShadow = {0, 0, 0, 0}
	settings.themes.list.custom.colors.TitleBgActive = {rMedium, gMedium, bMedium, 1}
	settings.themes.list.custom.colors.TitleBg = {rMedium * 0.7, gMedium * 0.7, bMedium * 0.7, 1}
	settings.themes.list.custom.colors.TitleBgCollapsed = {rMedium * 0.5, gMedium * 0.5, bMedium * 0.5, 0.51}
	settings.themes.list.custom.colors.MenuBarBg = {rDark, gDark, bDark, 0.57}
	settings.themes.list.custom.colors.ScrollbarBg = {rDark, gDark, bDark, 0.53}
	settings.themes.list.custom.colors.ScrollbarGrab = {r, g, b, 1}
	settings.themes.list.custom.colors.ScrollbarGrabHovered = {rLight, gLight, bLight, 1}
	settings.themes.list.custom.colors.ScrollbarGrabActive = {rVeryLight, gVeryLight, bVeryLight, 1}
	settings.themes.list.custom.colors.CheckMark = {r, g, b, 1}
	settings.themes.list.custom.colors.SliderGrab = {r * 0.88, g * 0.88, b * 0.88, 1}
	settings.themes.list.custom.colors.SliderGrabActive = {r, g, b, 1}
	settings.themes.list.custom.colors.Button = {buttonR, buttonG, buttonB, 0.8}
	settings.themes.list.custom.colors.ButtonHovered = {buttonHoverR, buttonHoverG, buttonHoverB, 1}
	settings.themes.list.custom.colors.ButtonActive = {buttonActiveR, buttonActiveG, buttonActiveB, 1}
	settings.themes.list.custom.colors.FrameBg = {r * 0.45, g * 0.45, b * 0.45, 0.54}
	settings.themes.list.custom.colors.FrameBgHovered = {r * 0.55, g * 0.55, b * 0.55, 0.54}
	settings.themes.list.custom.colors.FrameBgActive = {r * 0.65, g * 0.65, b * 0.65, 0.54}
	settings.themes.list.custom.colors.Tab = {rMedium, gMedium, bMedium, 0.86}
	settings.themes.list.custom.colors.TabActive = {r, g, b, 1}
	settings.themes.list.custom.colors.TabHovered = {rLight, gLight, bLight, 0.8}
	settings.themes.list.custom.colors.TabUnfocused = {rDark, gDark, bDark, 0.97}
	settings.themes.list.custom.colors.TabUnfocusedActive = {rMedium * 0.8, gMedium * 0.8, bMedium * 0.8, 1}
	settings.themes.list.custom.colors.CategoryColor = {buttonR, buttonG, buttonB, 1}
	settings.themes.list.custom.colors.Header = {buttonR, buttonG, buttonB, 0.31}
	settings.themes.list.custom.colors.HeaderHovered = {buttonHoverR, buttonHoverG, buttonHoverB, 0.8}
	settings.themes.list.custom.colors.HeaderActive = {buttonActiveR, buttonActiveG, buttonActiveB, 1}
	settings.themes.list.custom.colors.Separator = {r * 0.5, g * 0.5, b * 0.5, 0.5}
	settings.themes.list.custom.colors.SeparatorHovered = {r * 0.7, g * 0.7, b * 0.7, 0.78}
	settings.themes.list.custom.colors.SeparatorActive = {r * 0.9, g * 0.9, b * 0.9, 1}
	settings.themes.list.custom.colors.ResizeGrip = {r, g, b, 0.25}
	settings.themes.list.custom.colors.ResizeGripHovered = {rLight, gLight, bLight, 0.67}
	settings.themes.list.custom.colors.ResizeGripActive = {rVeryLight, gVeryLight, bVeryLight, 0.95}
	settings.themes.list.custom.colors.PlotLines = {r, g, b, 1}
	settings.themes.list.custom.colors.PlotLinesHovered = {rLight, gLight, bLight, 1}
	settings.themes.list.custom.colors.PlotHistogram = {r * 0.9, g * 0.9, b * 0.9, 1}
	settings.themes.list.custom.colors.PlotHistogramHovered = {r, g, b, 1}
	settings.themes.list.custom.colors.TextSelectedBg = {r * 0.7, g * 0.7, b * 0.7, 0.35}
	settings.themes.list.custom.colors.DragDropTarget = {r, g, b, 0.9}
	settings.themes.list.custom.colors.NavHighlight = {r, g, b, 1}
	settings.themes.list.custom.colors.NavWindowingHighlight = {r, g, b, 0.7}
	settings.themes.list.custom.colors.NavWindowingDimBg = {r * 0.2, g * 0.2, b * 0.2, 0.2}
	settings.themes.list.custom.colors.ModalWindowDimBg = {r * 0.2, g * 0.2, b * 0.2, 0.35}
	rgbTheme.colors = settings.themes.list.custom.colors
	if settings.themes.list.custom.colors.Button then
		settings.colors.itemButtons[0] = settings.themes.list.custom.colors.Button[1]
		settings.colors.itemButtons[1] = settings.themes.list.custom.colors.Button[2]
		settings.colors.itemButtons[2] = settings.themes.list.custom.colors.Button[3]
		settings.colors.itemButtons[3] = settings.themes.list.custom.colors.Button[4]
	end
	if settings.themes.list.custom.colors.CategoryColor then
		settings.colors.categoryButtons[0] = settings.themes.list.custom.colors.CategoryColor[1]
		settings.colors.categoryButtons[1] = settings.themes.list.custom.colors.CategoryColor[2]
		settings.colors.categoryButtons[2] = settings.themes.list.custom.colors.CategoryColor[3]
	end
	if settings.themes.list.custom.colors.WindowBg then
		settings.colors.background[0] = settings.themes.list.custom.colors.WindowBg[1]
		settings.colors.background[1] = settings.themes.list.custom.colors.WindowBg[2]
		settings.colors.background[2] = settings.themes.list.custom.colors.WindowBg[3]
	end
	settings.checker.textColor[0] = r
	settings.checker.textColor[1] = g
	settings.checker.textColor[2] = b
	settings.checker.textColor[3] = 1
end
function pushRgbColors()
	if not rgbTheme.enabled or not rgbTheme.colors then return 0 end
	local colorsToPush = {
		{imgui.Col.Text, rgbTheme.colors.Text},
		{imgui.Col.WindowBg, rgbTheme.colors.WindowBg},
		{imgui.Col.ChildBg, rgbTheme.colors.ChildBg},
		{imgui.Col.PopupBg, rgbTheme.colors.PopupBg},
		{imgui.Col.Border, rgbTheme.colors.Border},
		{imgui.Col.BorderShadow, rgbTheme.colors.BorderShadow},
		{imgui.Col.TitleBg, rgbTheme.colors.TitleBg},
		{imgui.Col.TitleBgActive, rgbTheme.colors.TitleBgActive},
		{imgui.Col.TitleBgCollapsed, rgbTheme.colors.TitleBgCollapsed},
		{imgui.Col.MenuBarBg, rgbTheme.colors.MenuBarBg},
		{imgui.Col.ScrollbarBg, rgbTheme.colors.ScrollbarBg},
		{imgui.Col.ScrollbarGrab, rgbTheme.colors.ScrollbarGrab},
		{imgui.Col.ScrollbarGrabHovered, rgbTheme.colors.ScrollbarGrabHovered},
		{imgui.Col.ScrollbarGrabActive, rgbTheme.colors.ScrollbarGrabActive},
		{imgui.Col.CheckMark, rgbTheme.colors.CheckMark},
		{imgui.Col.SliderGrab, rgbTheme.colors.SliderGrab},
		{imgui.Col.SliderGrabActive, rgbTheme.colors.SliderGrabActive},
		{imgui.Col.Button, rgbTheme.colors.Button},
		{imgui.Col.ButtonHovered, rgbTheme.colors.ButtonHovered},
		{imgui.Col.ButtonActive, rgbTheme.colors.ButtonActive},
		{imgui.Col.FrameBg, rgbTheme.colors.FrameBg},
		{imgui.Col.FrameBgHovered, rgbTheme.colors.FrameBgHovered},
		{imgui.Col.FrameBgActive, rgbTheme.colors.FrameBgActive},
		{imgui.Col.Tab, rgbTheme.colors.Tab},
		{imgui.Col.TabActive, rgbTheme.colors.TabActive},
		{imgui.Col.TabHovered, rgbTheme.colors.TabHovered},
		{imgui.Col.TabUnfocused, rgbTheme.colors.TabUnfocused},
		{imgui.Col.TabUnfocusedActive, rgbTheme.colors.TabUnfocusedActive},
		{imgui.Col.Header, rgbTheme.colors.Header},
		{imgui.Col.HeaderHovered, rgbTheme.colors.HeaderHovered},
		{imgui.Col.HeaderActive, rgbTheme.colors.HeaderActive},
		{imgui.Col.Separator, rgbTheme.colors.Separator},
		{imgui.Col.SeparatorHovered, rgbTheme.colors.SeparatorHovered},
		{imgui.Col.SeparatorActive, rgbTheme.colors.SeparatorActive},
		{imgui.Col.ResizeGrip, rgbTheme.colors.ResizeGrip},
		{imgui.Col.ResizeGripHovered, rgbTheme.colors.ResizeGripHovered},
		{imgui.Col.ResizeGripActive, rgbTheme.colors.ResizeGripActive},
		{imgui.Col.PlotLines, rgbTheme.colors.PlotLines},
		{imgui.Col.PlotLinesHovered, rgbTheme.colors.PlotLinesHovered},
		{imgui.Col.PlotHistogram, rgbTheme.colors.PlotHistogram},
		{imgui.Col.PlotHistogramHovered, rgbTheme.colors.PlotHistogramHovered},
		{imgui.Col.TextSelectedBg, rgbTheme.colors.TextSelectedBg},
		{imgui.Col.DragDropTarget, rgbTheme.colors.DragDropTarget},
		{imgui.Col.NavHighlight, rgbTheme.colors.NavHighlight},
		{imgui.Col.NavWindowingHighlight, rgbTheme.colors.NavWindowingHighlight},
		{imgui.Col.NavWindowingDimBg, rgbTheme.colors.NavWindowingDimBg},
		{imgui.Col.ModalWindowDimBg, rgbTheme.colors.ModalWindowDimBg}
	}
	for _, colorData in ipairs(colorsToPush) do
		local col = colorData[2]
		imgui.PushStyleColor(colorData[1], imgui.ImVec4(col[1], col[2], col[3], col[4]))
	end
	return #colorsToPush
end
function pushRgbColors()
	if not rgbTheme.enabled or not rgbTheme.colors then return 0 end
	local colorsToPush = {
		{imgui.Col.Text, rgbTheme.colors.Text},
		{imgui.Col.WindowBg, rgbTheme.colors.WindowBg},
		{imgui.Col.ChildBg, rgbTheme.colors.ChildBg},
		{imgui.Col.PopupBg, rgbTheme.colors.PopupBg},
		{imgui.Col.Border, rgbTheme.colors.Border},
		{imgui.Col.BorderShadow, rgbTheme.colors.BorderShadow},
		{imgui.Col.TitleBg, rgbTheme.colors.TitleBg},
		{imgui.Col.TitleBgActive, rgbTheme.colors.TitleBgActive},
		{imgui.Col.TitleBgCollapsed, rgbTheme.colors.TitleBgCollapsed},
		{imgui.Col.MenuBarBg, rgbTheme.colors.MenuBarBg},
		{imgui.Col.ScrollbarBg, rgbTheme.colors.ScrollbarBg},
		{imgui.Col.ScrollbarGrab, rgbTheme.colors.ScrollbarGrab},
		{imgui.Col.ScrollbarGrabHovered, rgbTheme.colors.ScrollbarGrabHovered},
		{imgui.Col.ScrollbarGrabActive, rgbTheme.colors.ScrollbarGrabActive},
		{imgui.Col.CheckMark, rgbTheme.colors.CheckMark},
		{imgui.Col.SliderGrab, rgbTheme.colors.SliderGrab},
		{imgui.Col.SliderGrabActive, rgbTheme.colors.SliderGrabActive},
		{imgui.Col.Button, rgbTheme.colors.Button},
		{imgui.Col.ButtonHovered, rgbTheme.colors.ButtonHovered},
		{imgui.Col.ButtonActive, rgbTheme.colors.ButtonActive},
		{imgui.Col.FrameBg, rgbTheme.colors.FrameBg},
		{imgui.Col.FrameBgHovered, rgbTheme.colors.FrameBgHovered},
		{imgui.Col.FrameBgActive, rgbTheme.colors.FrameBgActive},
		{imgui.Col.Tab, rgbTheme.colors.Tab},
		{imgui.Col.TabActive, rgbTheme.colors.TabActive},
		{imgui.Col.TabHovered, rgbTheme.colors.TabHovered},
		{imgui.Col.TabUnfocused, rgbTheme.colors.TabUnfocused},
		{imgui.Col.TabUnfocusedActive, rgbTheme.colors.TabUnfocusedActive},
		{imgui.Col.Header, rgbTheme.colors.Header},
		{imgui.Col.HeaderHovered, rgbTheme.colors.HeaderHovered},
		{imgui.Col.HeaderActive, rgbTheme.colors.HeaderActive},
		{imgui.Col.Separator, rgbTheme.colors.Separator},
		{imgui.Col.SeparatorHovered, rgbTheme.colors.SeparatorHovered},
		{imgui.Col.SeparatorActive, rgbTheme.colors.SeparatorActive},
		{imgui.Col.ResizeGrip, rgbTheme.colors.ResizeGrip},
		{imgui.Col.ResizeGripHovered, rgbTheme.colors.ResizeGripHovered},
		{imgui.Col.ResizeGripActive, rgbTheme.colors.ResizeGripActive},
		{imgui.Col.PlotLines, rgbTheme.colors.PlotLines},
		{imgui.Col.PlotLinesHovered, rgbTheme.colors.PlotLinesHovered},
		{imgui.Col.PlotHistogram, rgbTheme.colors.PlotHistogram},
		{imgui.Col.PlotHistogramHovered, rgbTheme.colors.PlotHistogramHovered},
		{imgui.Col.TextSelectedBg, rgbTheme.colors.TextSelectedBg},
		{imgui.Col.DragDropTarget, rgbTheme.colors.DragDropTarget},
		{imgui.Col.NavHighlight, rgbTheme.colors.NavHighlight},
		{imgui.Col.NavWindowingHighlight, rgbTheme.colors.NavWindowingHighlight},
		{imgui.Col.NavWindowingDimBg, rgbTheme.colors.NavWindowingDimBg},
		{imgui.Col.ModalWindowDimBg, rgbTheme.colors.ModalWindowDimBg}
	}
	for _, colorData in ipairs(colorsToPush) do
		local col = colorData[2]
		imgui.PushStyleColor(colorData[1], imgui.ImVec4(col[1], col[2], col[3], col[4]))
	end
	return #colorsToPush
end
function popRgbColors(count)
	if count and count > 0 then
		imgui.PopStyleColor(count)
	end
end
function getCheckerFont(size)
	size = math.floor(math.max(8, math.min(30, tonumber(size) or 16)))
	if not ui.fonts.checkerFonts[size] then
		local closest = 16
		local min_diff = math.abs(size - 16)
		for loaded_size, font in pairs(ui.fonts.checkerFonts) do
			local diff = math.abs(size - loaded_size)
			if diff < min_diff then
				min_diff = diff
				closest = loaded_size
			end
		end
		size = closest
	end
	return ui.fonts.checkerFonts[size] or ui.fonts.checkerFonts[16]
end
function setupSliderStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local sliderBgColor = currentThemeColors["FrameBg"] or {0.16, 0.29, 0.48, 0.54}
	local sliderBgHoveredColor = {
		math.min(sliderBgColor[1] * 1.2, 1),
		math.min(sliderBgColor[2] * 1.2, 1),
		math.min(sliderBgColor[3] * 1.2, 1),
		sliderBgColor[4]
	}
	local sliderBgActiveColor = {
		math.min(sliderBgColor[1] * 1.4, 1),
		math.min(sliderBgColor[2] * 1.4, 1),
		math.min(sliderBgColor[3] * 1.4, 1),
		sliderBgColor[4]
	}
	local sliderGrabColor = {
		math.min(sliderBgColor[1] * 2.2, 1),
		math.min(sliderBgColor[2] * 2.2, 1),
		math.min(sliderBgColor[3] * 2.2, 1),
		1
	}
	local sliderGrabActiveColor = {
		math.min(sliderBgColor[1] * 2.5, 1),
		math.min(sliderBgColor[2] * 2.5, 1),
		math.min(sliderBgColor[3] * 2.5, 1),
		1
	}
	imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 8)
	imgui.PushStyleVarFloat(imgui.StyleVar.GrabRounding, 8)
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(sliderBgColor[1], sliderBgColor[2], sliderBgColor[3], sliderBgColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(sliderBgHoveredColor[1], sliderBgHoveredColor[2], sliderBgHoveredColor[3], sliderBgHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(sliderBgActiveColor[1], sliderBgActiveColor[2], sliderBgActiveColor[3], sliderBgActiveColor[4]))
	imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(sliderGrabColor[1], sliderGrabColor[2], sliderGrabColor[3], sliderGrabColor[4]))
	imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(sliderGrabActiveColor[1], sliderGrabActiveColor[2], sliderGrabActiveColor[3], sliderGrabActiveColor[4]))
end
function cleanupSliderStyle()
	imgui.PopStyleVar(2)
	imgui.PopStyleColor(5)
end
function setupInputFieldStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local frameBgColor = currentThemeColors["FrameBg"] or {0.16, 0.29, 0.48, 0.54}
	local frameBgHoveredColor = {
		math.min(frameBgColor[1] * 1.15, 1),
		math.min(frameBgColor[2] * 1.15, 1),
		math.min(frameBgColor[3] * 1.15, 1),
		frameBgColor[4]
	}
	local frameBgActiveColor = {
		math.min(frameBgColor[1] * 1.3, 1),
		math.min(frameBgColor[2] * 1.3, 1),
		math.min(frameBgColor[3] * 1.3, 1),
		frameBgColor[4]
	}
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(frameBgColor[1], frameBgColor[2], frameBgColor[3], frameBgColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(frameBgHoveredColor[1], frameBgHoveredColor[2], frameBgHoveredColor[3], frameBgHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(frameBgActiveColor[1], frameBgActiveColor[2], frameBgActiveColor[3], frameBgActiveColor[4]))
end
function cleanupInputFieldStyle()
	imgui.PopStyleColor(3)
end
function setupCheckboxStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local frameBgActiveColor = currentThemeColors["FrameBgActive"] or {0.16, 0.29, 0.48, 0.54}
	local frameBgActiveLighter = {
		math.min(frameBgActiveColor[1] * 1.2, 1),
		math.min(frameBgActiveColor[2] * 1.2, 1),
		math.min(frameBgActiveColor[3] * 1.2, 1),
		frameBgActiveColor[4]
	}
	local checkMarkColor = {
		math.min(frameBgActiveColor[1] * 2.2, 1),
		math.min(frameBgActiveColor[2] * 2.2, 1),
		math.min(frameBgActiveColor[3] * 2.2, 1),
		1
	}
	imgui.PushStyleColor(imgui.Col.CheckMark, imgui.ImVec4(checkMarkColor[1], checkMarkColor[2], checkMarkColor[3], checkMarkColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(frameBgActiveLighter[1], frameBgActiveLighter[2], frameBgActiveLighter[3], frameBgActiveLighter[4]))
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(frameBgActiveColor[1], frameBgActiveColor[2], frameBgActiveColor[3], frameBgActiveColor[4]))
end
function cleanupCheckboxStyle()
	imgui.PopStyleColor(3)
end
function setupScrollbarStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local scrollbarGrabColor = currentThemeColors["ScrollbarGrab"] or {0.31, 0.31, 0.31, 1}
	local scrollbarBgColor = {
		scrollbarGrabColor[1] * 0.3,
		scrollbarGrabColor[2] * 0.3,
		scrollbarGrabColor[3] * 0.3,
		0.53
	}
	local scrollbarGrabHoveredColor = {
		math.min(scrollbarGrabColor[1] * 1.2, 1),
		math.min(scrollbarGrabColor[2] * 1.2, 1),
		math.min(scrollbarGrabColor[3] * 1.2, 1),
		scrollbarGrabColor[4]
	}
	local scrollbarGrabActiveColor = {
		math.min(scrollbarGrabColor[1] * 1.4, 1),
		math.min(scrollbarGrabColor[2] * 1.4, 1),
		math.min(scrollbarGrabColor[3] * 1.4, 1),
		scrollbarGrabColor[4]
	}
	imgui.PushStyleColor(imgui.Col.ScrollbarBg, imgui.ImVec4(scrollbarBgColor[1], scrollbarBgColor[2], scrollbarBgColor[3], scrollbarBgColor[4]))
	imgui.PushStyleColor(imgui.Col.ScrollbarGrab, imgui.ImVec4(scrollbarGrabColor[1], scrollbarGrabColor[2], scrollbarGrabColor[3], scrollbarGrabColor[4]))
	imgui.PushStyleColor(imgui.Col.ScrollbarGrabHovered, imgui.ImVec4(scrollbarGrabHoveredColor[1], scrollbarGrabHoveredColor[2], scrollbarGrabHoveredColor[3], scrollbarGrabHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.ScrollbarGrabActive, imgui.ImVec4(scrollbarGrabActiveColor[1], scrollbarGrabActiveColor[2], scrollbarGrabActiveColor[3], scrollbarGrabActiveColor[4]))
end
function cleanupScrollbarStyle()
	imgui.PopStyleColor(4)
end
function setupHeaderStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local titleBgActiveColor = currentThemeColors["TitleBgActive"] or {0.16, 0.29, 0.48, 1}
	local titleBgColor = {
		titleBgActiveColor[1] * 0.7,
		titleBgActiveColor[2] * 0.7,
		titleBgActiveColor[3] * 0.7,
		titleBgActiveColor[4]
	}
	local headerColor = {
		titleBgActiveColor[1] * 0.5,
		titleBgActiveColor[2] * 0.5,
		titleBgActiveColor[3] * 0.5,
		0.55
	}
	local headerHoveredColor = {
		math.min(headerColor[1] * 1.3, 1),
		math.min(headerColor[2] * 1.3, 1),
		math.min(headerColor[3] * 1.3, 1),
		0.8
	}
	local headerActiveColor = {
		math.min(headerColor[1] * 1.5, 1),
		math.min(headerColor[2] * 1.5, 1),
		math.min(headerColor[3] * 1.5, 1),
		1
	}
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(titleBgColor[1], titleBgColor[2], titleBgColor[3], titleBgColor[4]))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(titleBgActiveColor[1], titleBgActiveColor[2], titleBgActiveColor[3], titleBgActiveColor[4]))
	imgui.PushStyleColor(imgui.Col.Header, imgui.ImVec4(headerColor[1], headerColor[2], headerColor[3], headerColor[4]))
	imgui.PushStyleColor(imgui.Col.HeaderHovered, imgui.ImVec4(headerHoveredColor[1], headerHoveredColor[2], headerHoveredColor[3], headerHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.HeaderActive, imgui.ImVec4(headerActiveColor[1], headerActiveColor[2], headerActiveColor[3], headerActiveColor[4]))
end
function cleanupHeaderStyle()
	imgui.PopStyleColor(5)
end
if imgui and vk and fa and requests and encoding and ev then
	function imgui.ToggleButton(str_id, bool, leftText, rightText, useCustomStyle)
		local rBool = false
		if LastActiveTime == nil then
			LastActiveTime = {}
		end
		if LastActive == nil then
			LastActive = {}
		end
		local function ImSaturate(f)
			return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
		end
		if leftText then
			imgui.Text(leftText)
			imgui.SameLine()
		end
		local p = imgui.GetCursorScreenPos()
		local dl = imgui.GetWindowDrawList()
		local height = imgui.GetTextLineHeightWithSpacing()
		local width = height * 1.70
		local radius = height * 0.50
		local ANIM_SPEED = 0.15
		if useCustomStyle and setupCheckboxStyle then
			setupCheckboxStyle()
		end
		if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
			bool[0] = not bool[0]
			rBool = true
			LastActiveTime[tostring(str_id)] = os.clock()
			LastActive[tostring(str_id)] = true
		end
		if useCustomStyle and cleanupCheckboxStyle then
			cleanupCheckboxStyle()
		end
		if rightText then
			imgui.SameLine()
			imgui.Text(rightText)
		end
		local t = bool[0] and 1.0 or 0.0
		if LastActive[tostring(str_id)] then
			local time = os.clock() - LastActiveTime[tostring(str_id)]
			if time <= ANIM_SPEED then
				local t_anim = ImSaturate(time / ANIM_SPEED)
				t = bool[0] and t_anim or 1.0 - t_anim
			else
				LastActive[tostring(str_id)] = false
			end
		end
		local frameBgColor = imgui.GetStyle().Colors[imgui.Col.FrameBg]
		local col_circle
		if bool[0] then
			local lightColor = imgui.ImVec4(
				math.min(frameBgColor.x * 1.8, 1),
				math.min(frameBgColor.y * 1.8, 1),
				math.min(frameBgColor.z * 1.8, 1),
				1
			)
			col_circle = imgui.ColorConvertFloat4ToU32(lightColor)
		else
			col_circle = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
		end
		local alpha = 1.0
		dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(
			imgui.GetStyle().Colors[imgui.Col.FrameBg].x,
			imgui.GetStyle().Colors[imgui.Col.FrameBg].y,
			imgui.GetStyle().Colors[imgui.Col.FrameBg].z,
			imgui.GetStyle().Colors[imgui.Col.FrameBg].w * alpha
		)), height * 0.5)
		local circleColor = imgui.ImVec4(
			col_circle % 256 / 255,
			(col_circle / 256) % 256 / 255,
			(col_circle / 65536) % 256 / 255,
			((col_circle / 16777216) % 256 / 255) * alpha
		)
		dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, imgui.ColorConvertFloat4ToU32(circleColor))
		return rBool
	end
end