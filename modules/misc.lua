function parse_bb_text(text)
	local hash = get_text_hash(text)
	if procache.parsed[hash] and procache.parsed[hash].text == text then
		return procache.parsed[hash].blocks
	end
	local blocks = {}
	local pos = 1
	local len = #text
	while pos <= len do
		local s_sp, e_sp, sp_title = text:find('%[%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*=%s*"(.-)"%s*%]', pos)
		local s_ctr, e_ctr = text:find('%[%s*[Cc][Ee][Nn][Tt][Ee][Rr]%s*%]', pos)
		local s_qt, e_qt = text:find('%[%s*[Qq][Uu][Oo][Tt][Ee]%s*%]', pos)
		local next_start, tag_type, tag_end, tag_title
		if s_sp and (not s_ctr or s_sp < s_ctr) and (not s_qt or s_sp < s_qt) then
			next_start = s_sp; tag_type = 'spoiler'; tag_end = e_sp; tag_title = sp_title
		elseif s_qt and (not s_ctr or s_qt < s_ctr) then
			next_start = s_qt; tag_type = 'quote'; tag_end = e_qt
		elseif s_ctr then
			next_start = s_ctr; tag_type = 'center'; tag_end = e_ctr
		else
			next_start = nil
		end
		if not next_start then
			local rest = text:sub(pos)
			for line in rest:gmatch("[^\r\n]+") do
				if line:match("%S") then
					table.insert(blocks, {type = 'text', content = line})
				end
			end
			break
		else
			if next_start > pos then
				local before = text:sub(pos, next_start - 1)
				for line in before:gmatch("[^\r\n]+") do
					if line:match("%S") then
						table.insert(blocks, {type = 'text', content = line})
					end
				end
			end
			if tag_type == 'spoiler' then
				local close_s, close_e = text:find('%[%s*/%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*%]', tag_end + 1)
				if not close_s then close_s = len; close_e = len end
				local inner = text:sub(tag_end + 1, close_s - 1)
				table.insert(blocks, {type = 'spoiler', title = tag_title or "Спойлер", content = inner})
				pos = close_e + 1
			elseif tag_type == 'quote' then
				local close_s, close_e = text:find('%[%s*/%s*[Qq][Uu][Oo][Tt][Ee]%s*%]', tag_end + 1)
				if not close_s then close_s = len; close_e = len end
				local inner = text:sub(tag_end + 1, close_s - 1)
				table.insert(blocks, {type = 'quote', content = inner, pos = pos})
				pos = close_e + 1
			else
				local close_s, close_e = text:find('%[%s*/%s*[Cc][Ee][Nn][Tt][Ee][Rr]%s*%]', tag_end + 1)
				if not close_s then close_s = len; close_e = len end
				local inner = text:sub(tag_end + 1, close_s - 1)
				table.insert(blocks, {type = 'center', content = inner})
				pos = close_e + 1
			end
		end
	end
	procache.parsed[hash] = {text = text, blocks = blocks}
	return blocks
end
function cleanNickname(nick)
	if not nick then return "" end
	nick = nick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", "")
	nick = nick:gsub("^%s+", ""):gsub("%s+$", "")
	nick = nick:gsub("[а-яёА-ЯЁ]", function(c)
		local cyrillic = {а="a", б="b", в="v", г="g", д="d", е="e", ё="yo", ж="zh", з="z", и="i", й="y", к="k", л="l", м="m", н="n", о="o", п="p", р="r", с="s", т="t", у="u", ф="f", х="kh", ц="ts", ч="ch", ш="sh", щ="sch", ъ="", ы="y", ь="", э="e", ю="yu", я="ya"}
		return cyrillic[c:lower()] or c
	end)
	return nick
end
function calculateAboutTabHeight()
	local baseHeight = 50
	local lineHeight = 20
	local titleAndVersion = 1
	local buttons = 110
	local commands = 8 * lineHeight
	local hotkeys = 5 * lineHeight
	local whatsNew = (#aboutTabWhatsNew + 2) * lineHeight * 1.15
	return baseHeight + titleAndVersion + buttons + commands + hotkeys + whatsNew
end
function calculateBindsTabHeight()
	local baseHeight = 150
	local buttonsPerRow = 7
	local binderCount = #binder.list
	local perRowHeight = 130
	if binderCount == 0 then
		return baseHeight + perRowHeight
	end
	local rows = math.ceil(binderCount / buttonsPerRow)
	local buttonsInLastRow = ((binderCount - 1) % buttonsPerRow) + 1
	local totalHeight = rows * perRowHeight
	if buttonsInLastRow == buttonsPerRow then
		totalHeight = totalHeight + perRowHeight
	end
	return baseHeight + totalHeight
end
function calculateEfirMessagesTabHeight()
	if not efir.selectedType or not efir.messages[efir.selectedType] then
		return 500
	end
	local tabHeights = {
		[1] = 940,
		[2] = 890,
		[3] = 710,
		[4] = 670
	}
	local currentHeight = tabHeights[efir.currentSubTab] or 650
	return currentHeight
end
function calculateFreeEfirTabHeight()
	if efir.custom.viewMode == 'square' then
		return 800
	end
	local baseHeight = 180  
	local lineHeight = 30
	local paddingAndSpacing = 50
	local lineCount = 0
	if efir.custom.selected and efir.custom.lines and #efir.custom.lines > 0 then
		lineCount = #efir.custom.lines
	end
	local addButtonHeight = 40
	local linesHeight = lineCount * lineHeight
	local totalHeight = baseHeight + linesHeight + addButtonHeight + paddingAndSpacing
	local minHeight = 600
	local maxHeight = 800
	if totalHeight < minHeight then
		totalHeight = minHeight
	elseif totalHeight > maxHeight then
		totalHeight = maxHeight
	end
	return totalHeight
end
function bringWindowToFront()
	if imgui.IsWindowFocused() then
		return
	end
	imgui.SetWindowFocus()
end
function clear_old_cache()
	local count = 0
	for _ in pairs(procache.normalized) do count = count + 1 end
	if count > 1000 then procache.normalized = {} end
	count = 0
	for _ in pairs(procache.queries) do count = count + 1 end
	if count > 100 then procache.queries = {} end
end
function cp1251_to_utf8(str)
	if not str then return "" end
	local res, pos = {}, 1
	while pos <= #str do
		local b = str:byte(pos)
		if b < 128 then
			table.insert(res, string.char(b))
		else
			local c1, c2
			if b >= 192 then
				c1 = 0xD0; c2 = b - 0xC0 + 0x90
				if b >= 240 then
					c1 = 0xD1; c2 = b - 0xF0 + 0x80
				end
			else
				c1, c2 = 0xD1, 0x91
			end
			table.insert(res, string.char(c1, c2))
		end
		pos = pos + 1
	end
	return table.concat(res)
end
function render_bb_text(line, baseScale, highlight, search_word)
	if not line or line == "" then return end
	local center_inner = line:match("%[CENTER%](.-)%[/CENTER%]")
	if center_inner then
		render_centered_block(center_inner, baseScale)
		return
	end
	function strip_bb_tags(str)
		if not str then return "" end
		return (str:gsub("%[/?%s*%a+[^%]]*%]", ""))
	end
	local chunks = {}
	function find_next_tag(str, start_pos)
		local patterns = {
			{open = "%[B%]", close = "%[/B%]", name = "B"},
			{open = "%[I%]", close = "%[/I%]", name = "I"},
			{open = "%[COLOR=rgb%((%d+),%s*(%d+),%s*(%d+)%)%]", close = "%[/COLOR%]", name = "COLOR"},
			{open = "%[SIZE=(%d+)%]", close = "%[/SIZE%]", name = "SIZE"},
			{open = "%[FONT=([%w_]+)%]", close = "%[/FONT%]", name = "FONT"}
		}
		local nearest = nil
		local nearest_pos = #str + 1
		for _, p in ipairs(patterns) do
			local s, e, c1, c2, c3 = str:find(p.open, start_pos)
			if s and s < nearest_pos then
				nearest_pos = s
				nearest = {pattern = p, start_pos = s, end_pos = e, captures = {c1, c2, c3}}
			end
		end
		return nearest
	end
	function parse_with_style(text, style)
		local tag = find_next_tag(text, 1)
		if not tag then
			local clean = strip_bb_tags(text)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
			return
		end
		if tag.start_pos > 1 then
			local before = text:sub(1, tag.start_pos - 1)
			local clean = strip_bb_tags(before)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
		end
		local close_start, close_end = text:find(tag.pattern.close, tag.end_pos + 1)
		if not close_start then
			local rest = text:sub(tag.end_pos + 1)
			local clean = strip_bb_tags(rest)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
			return
		end
		local inner = text:sub(tag.end_pos + 1, close_start - 1)
		local new_style = {}
		for k, v in pairs(style) do new_style[k] = v end
		if tag.pattern.name == "B" then
			new_style.bold = true
		elseif tag.pattern.name == "I" then
			new_style.italic = true
		elseif tag.pattern.name == "COLOR" then
			local r, g, b = tonumber(tag.captures[1]), tonumber(tag.captures[2]), tonumber(tag.captures[3])
			new_style.color = {r/255, g/255, b/255, 1}
		elseif tag.pattern.name == "SIZE" then
			new_style.scale = (tonumber(tag.captures[1]) or 5) / 5 * baseScale
		elseif tag.pattern.name == "FONT" then
			if ui.fonts.custom and ui.fonts.custom[tag.captures[1]:lower()] then
				new_style.font = ui.fonts.custom[tag.captures[1]:lower()]
			end
		end
		parse_with_style(inner, new_style)
		local rest = text:sub(close_end + 1)
		if rest ~= "" then
			parse_with_style(rest, style)
		end
	end
	parse_with_style(line, {scale = baseScale})
	if #chunks == 0 then return end
	function apply_style(style, is_search_match)
		if is_search_match then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.2, 0.9, 0.2, 1))
		elseif highlight then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.2, 0.9, 0.2, 1))
		elseif style.color then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(
				style.color[1], style.color[2], style.color[3], style.color[4]
			))
		end
		if style.font then
			imgui.PushFont(style.font)
		elseif style.bold and ui.fonts.sprav and ui.fonts.sprav.bold then
			imgui.PushFont(ui.fonts.sprav.bold)
		elseif ui.fonts.sprav and ui.fonts.sprav.regular then
			imgui.PushFont(ui.fonts.sprav.regular)
		end
	end
	function reset_style(style, is_search_match)
		if style.font or (style.bold and ui.fonts.sprav and ui.fonts.sprav.bold) or (ui.fonts.sprav and ui.fonts.sprav.regular) then
			imgui.PopFont()
		end
		if is_search_match or highlight or style.color then
			imgui.PopStyleColor()
		end
	end
	function get_text_width(text, style)
		apply_style(style, false)
		local width = imgui.CalcTextSize(text).x
		reset_style(style, false)
		return width
	end
	function split_by_search_word(text, search_word)
		if not search_word or search_word == "" then
			return {{text = text, is_match = false}}
		end
		local result = {}
		local search_norm = lower_utf8_optimized(search_word):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		local text_lower = lower_utf8_optimized(text)
		local pos = 1
		while pos <= #text_lower do
			local match_start, match_end = text_lower:find(search_norm, pos, true)
			if not match_start then
				if pos <= #text then
					table.insert(result, {text = text:sub(pos), is_match = false})
				end
				break
			end
			if match_start > pos then
				table.insert(result, {text = text:sub(pos, match_start - 1), is_match = false})
			end
			table.insert(result, {text = text:sub(match_start, match_end), is_match = true})
			pos = match_end + 1
		end
		return result
	end
	local total_width = 0
	for _, chunk in ipairs(chunks) do
		if type(chunk.text) == "string" then
			total_width = total_width + get_text_width(chunk.text, chunk.style)
		end
	end
	local available_width = imgui.GetContentRegionAvail().x
	if total_width <= available_width then
		for i, chunk in ipairs(chunks) do
			if search_word and search_word ~= "" then
				local parts = split_by_search_word(chunk.text, search_word)
				for j, part in ipairs(parts) do
					apply_style(chunk.style, part.is_match)
					if i > 1 or j > 1 then
						imgui.SameLine(0, 0)
					end
					imgui.Text(part.text)
					reset_style(chunk.style, part.is_match)
				end
			else
				apply_style(chunk.style, false)
				if i > 1 then
					imgui.SameLine(0, 0)
				end
				imgui.Text(chunk.text)
				reset_style(chunk.style, false)
			end
		end
		return
	end
	local current_line_width = 0
	local is_first_in_line = true
	for _, chunk in ipairs(chunks) do
		if type(chunk.text) ~= "string" then goto continue end
		local text = chunk.text
		local i = 1
		while i <= #text do
			local word_start = i
			while word_start <= #text and text:sub(word_start, word_start):match("%s") do
				word_start = word_start + 1
			end
			if word_start > #text then break end
			local word_end = word_start
			while word_end <= #text and not text:sub(word_end, word_end):match("%s") do
				word_end = word_end + 1
			end
			local spaces_before = text:sub(i, word_start - 1)
			local word = text:sub(word_start, word_end - 1)
			local text_to_render = word
			if not is_first_in_line and spaces_before ~= "" then
				text_to_render = spaces_before .. word
			end
			local word_width = get_text_width(text_to_render, chunk.style)
			if current_line_width + word_width > available_width and not is_first_in_line then
				current_line_width = 0
				is_first_in_line = true
				text_to_render = word
				word_width = get_text_width(word, chunk.style)
			end
			if search_word and search_word ~= "" then
				local parts = split_by_search_word(text_to_render, search_word)
				for j, part in ipairs(parts) do
					apply_style(chunk.style, part.is_match)
					if not is_first_in_line or j > 1 then
						imgui.SameLine(0, 0)
					end
					imgui.Text(part.text)
					reset_style(chunk.style, part.is_match)
				end
			else
				apply_style(chunk.style, false)
				if not is_first_in_line then
					imgui.SameLine(0, 0)
				end
				imgui.Text(text_to_render)
				reset_style(chunk.style, false)
			end
			current_line_width = current_line_width + word_width
			is_first_in_line = false
			i = word_end
		end
		::continue::
	end
end
function render_centered_block(text, baseScale)
	if not text or text == "" then return end
	function strip_bb_tags(str)
		if not str then return "" end
		return (str:gsub("%[/?%s*%a+[^%]]*%]", ""))
	end
	local chunks = {}
	function find_next_tag(str, start_pos)
		local patterns = {
			{open = "%[B%]", close = "%[/B%]", name = "B"},
			{open = "%[I%]", close = "%[/I%]", name = "I"},
			{open = "%[COLOR=rgb%((%d+),%s*(%d+),%s*(%d+)%)%]", close = "%[/COLOR%]", name = "COLOR"},
			{open = "%[SIZE=(%d+)%]", close = "%[/SIZE%]", name = "SIZE"},
			{open = "%[FONT=([%w_]+)%]", close = "%[/FONT%]", name = "FONT"}
		}
		local nearest = nil
		local nearest_pos = #str + 1
		for _, p in ipairs(patterns) do
			local s, e, c1, c2, c3 = str:find(p.open, start_pos)
			if s and s < nearest_pos then
				nearest_pos = s
				nearest = {pattern = p, start_pos = s, end_pos = e, captures = {c1, c2, c3}}
			end
		end
		return nearest
	end
	function parse_with_style(text, style)
		local tag = find_next_tag(text, 1)
		if not tag then
			local clean = strip_bb_tags(text)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
			return
		end
		if tag.start_pos > 1 then
			local before = text:sub(1, tag.start_pos - 1)
			local clean = strip_bb_tags(before)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
		end
		local close_start, close_end = text:find(tag.pattern.close, tag.end_pos + 1)
		if not close_start then
			local rest = text:sub(tag.end_pos + 1)
			local clean = strip_bb_tags(rest)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
			return
		end
		local inner = text:sub(tag.end_pos + 1, close_start - 1)
		local new_style = {}
		for k, v in pairs(style) do new_style[k] = v end
		if tag.pattern.name == "B" then
			new_style.bold = true
		elseif tag.pattern.name == "I" then
			new_style.italic = true
		elseif tag.pattern.name == "COLOR" then
			local r, g, b = tonumber(tag.captures[1]), tonumber(tag.captures[2]), tonumber(tag.captures[3])
			new_style.color = {r/255, g/255, b/255, 1}
		elseif tag.pattern.name == "SIZE" then
			new_style.scale = (tonumber(tag.captures[1]) or 5) / 5 * baseScale
		elseif tag.pattern.name == "FONT" then
			if ui.fonts.custom and ui.fonts.custom[tag.captures[1]:lower()] then
				new_style.font = ui.fonts.custom[tag.captures[1]:lower()]
			end
		end
		parse_with_style(inner, new_style)
		local rest = text:sub(close_end + 1)
		if rest ~= "" then
			parse_with_style(rest, style)
		end
	end
	function apply_style(style)
		if style.color then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(
				style.color[1], style.color[2], style.color[3], style.color[4]
			))
		end
		if style.font then
			imgui.PushFont(style.font)
		elseif style.bold and ui.fonts.sprav and ui.fonts.sprav.bold then
			imgui.PushFont(ui.fonts.sprav.bold)
		elseif ui.fonts.sprav and ui.fonts.sprav.regular then
			imgui.PushFont(ui.fonts.sprav.regular)
		end
	end
	function reset_style(style)
		if style.font or (style.bold and ui.fonts.sprav and ui.fonts.sprav.bold) or (ui.fonts.sprav and ui.fonts.sprav.regular) then
			imgui.PopFont()
		end
		if style.color then
			imgui.PopStyleColor()
		end
	end
	function get_text_width(text, style)
		apply_style(style)
		local width = imgui.CalcTextSize(text).x
		reset_style(style)
		return width
	end
	local winW = imgui.GetWindowWidth()
	for paragraph in text:gmatch("[^\r\n]+") do
		chunks = {}
		local clean = paragraph:gsub("^%s+", ""):gsub("%s+$", "")
		if clean == "" then
			imgui.Text("")
		else
			parse_with_style(clean, {scale = baseScale})
			local total_width = 0
			for _, chunk in ipairs(chunks) do
				if type(chunk.text) == "string" then
					total_width = total_width + get_text_width(chunk.text, chunk.style)
				end
			end
			local x = (winW - total_width) / 2
			if x < 0 then x = 0 end
			imgui.SetCursorPosX(x)
			for i, chunk in ipairs(chunks) do
				apply_style(chunk.style)
				if i > 1 then
					imgui.SameLine(0, 0)
				end
				imgui.Text(chunk.text)
				reset_style(chunk.style)
			end
		end
	end
end
function render_pro_text(text, baseScale)
	if not text or text == "" then return end
	local blocks = parse_bb_text(text)
	for _, block in ipairs(blocks) do
		if block.type == 'text' then
			render_bb_text(block.content, baseScale)
		elseif block.type == 'spoiler' then
			if imgui.CollapsingHeader(block.title) then
				local dark = imgui.ImVec4(settings.colors.background[0] * 0.5, settings.colors.background[1] * 0.5, settings.colors.background[2] * 0.5, 1)
				local renderLines = {}
				for line in block.content:gmatch("[^\r\n]+") do
					if line:match("%S") then
						table.insert(renderLines, line)
					end
				end
				imgui.PushFont(ui.fonts.sprav.regular)
				local lineHeight = imgui.GetTextLineHeight()
				local spacing = imgui.GetStyle().ItemSpacing.y
				imgui.PopFont()
				local contentHeight = lineHeight * #renderLines + spacing * math.max(0, #renderLines - 1)
				local padding = imgui.GetStyle().WindowPadding.y * 2
				local childH = contentHeight + padding
				imgui.PushStyleColor(imgui.Col.ChildBg, dark)
				imgui.BeginChild("spoiler_" .. block.title, imgui.ImVec2(-1, childH), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar)
				imgui.PushFont(ui.fonts.sprav.regular)
				for _, line in ipairs(renderLines) do
					render_bb_text(line, baseScale)
				end
				imgui.PopFont()
				imgui.EndChild()
				imgui.PopStyleColor()
			end
		elseif block.type == 'quote' then
			local dark = imgui.ImVec4(settings.colors.background[0] * 0.5, settings.colors.background[1] * 0.5, settings.colors.background[2] * 0.5, 1)
			local renderLines = {}
			for line in block.content:gmatch("[^\r\n]+") do
				if line:match("%S") then
					table.insert(renderLines, line)
				end
			end
			imgui.PushFont(ui.fonts.sprav.regular)
			local lineHeight = imgui.GetTextLineHeight()
			local spacing = imgui.GetStyle().ItemSpacing.y
			imgui.PopFont()
			local contentHeight = lineHeight * #renderLines + spacing * math.max(0, #renderLines - 1)
			local padding = imgui.GetStyle().WindowPadding.y * 2
			local borderSize = imgui.GetStyle().ChildBorderSize * 2
			local childH = contentHeight + padding + borderSize + 1
			imgui.PushStyleColor(imgui.Col.ChildBg, dark)
			imgui.BeginChild("quote_" .. tostring(block.pos), imgui.ImVec2(-1, childH), true, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar)
			imgui.PushFont(ui.fonts.sprav.regular)
			for _, line in ipairs(renderLines) do
				render_bb_text(line, baseScale)
			end
			imgui.PopFont()
			imgui.EndChild()
			imgui.PopStyleColor()
		elseif block.type == 'center' then
			render_centered_block(block.content, baseScale)
		end
	end
end
function render_pro_text_with_search(dataText, searchQuery, baseScale)
	local blocks = parse_bb_text(dataText)
	local foundAny = false
	local firstFoundBlockIndex = nil
	local search_changed = spravsearch.last_search_query ~= searchQuery
	spravsearch.last_search_query = searchQuery
	local current_scroll_y = imgui.GetScrollY()
	if current_scroll_y ~= spravsearch.last_scroll_y then
		spravsearch.user_scrolling = true
		spravsearch.scroll_check_timer = 0.5
	end
	spravsearch.scroll_check_timer = spravsearch.scroll_check_timer - (1/60)
	if spravsearch.scroll_check_timer <= 0 then
		spravsearch.user_scrolling = false
	end
	spravsearch.last_scroll_y = current_scroll_y
	if searchQuery and searchQuery ~= "" then
		for idx, block in ipairs(blocks) do
			local result = search_in_pro_text(searchQuery, block.content, block.type)
			if result.found then
				foundAny = true
				if not firstFoundBlockIndex then
					firstFoundBlockIndex = idx
				end
			end
		end
	end
	for blockIdx, block in ipairs(blocks) do
		local result = search_in_pro_text(searchQuery, block.content, block.type)
		if block.type == 'text' then
			if firstFoundBlockIndex == blockIdx and search_changed and not spravsearch.user_scrolling then
				imgui.SetScrollHereY(0.2)
			end
			render_bb_text(block.content, baseScale, false, searchQuery)
			imgui.Spacing()
		elseif block.type == 'spoiler' then
			if imgui.CollapsingHeader(block.title) then
				local dark = imgui.ImVec4(settings.colors.background[0] * 0.5, settings.colors.background[1] * 0.5, settings.colors.background[2] * 0.5, 1)
				local renderLines = {}
				for line in block.content:gmatch("[^\r\n]+") do
					if line:match("%S") then table.insert(renderLines, line) end
				end
				imgui.PushFont(ui.fonts.sprav.regular)
				local lineHeight = imgui.GetTextLineHeightWithSpacing()
				imgui.PopFont()
				local childH = lineHeight * #renderLines + imgui.GetStyle().ItemSpacing.y * 2
				imgui.PushStyleColor(imgui.Col.ChildBg, dark)
				imgui.BeginChild("spoiler_" .. block.title, imgui.ImVec2(-1, childH), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar)
				imgui.PushFont(ui.fonts.sprav.regular)
				for _, line in ipairs(renderLines) do 
					render_bb_text(line, baseScale, result.found and result.location == "spoiler")
				end
				imgui.PopFont()
				imgui.EndChild()
				imgui.PopStyleColor()
			end
		elseif block.type == 'quote' then
			if firstFoundBlockIndex == blockIdx and search_changed and not spravsearch.user_scrolling then
				imgui.SetScrollHereY(0.2)
			end
			local renderLines = {}
			for line in block.content:gmatch("[^\r\n]+") do
				if line:match("%S") then table.insert(renderLines, line) end
			end
			imgui.PushFont(ui.fonts.sprav.regular)
			local lineHeight = imgui.GetTextLineHeightWithSpacing()
			imgui.PopFont()
			local padding = imgui.GetStyle().WindowPadding.y * 2
			local childH = lineHeight * #renderLines + padding + imgui.GetStyle().ItemSpacing.y
			local dark = imgui.ImVec4(settings.colors.background[0] * 0.5, settings.colors.background[1] * 0.5, settings.colors.background[2] * 0.5, 1)
			imgui.PushStyleColor(imgui.Col.ChildBg, dark)
			imgui.BeginChild("quote_" .. tostring(block.pos), imgui.ImVec2(-1, childH), true, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar)
			imgui.PushFont(ui.fonts.sprav.regular)
			if result.location == "quote" and result.found then
				local cacheKey = searchQuery
				local cached = procache.queries[cacheKey]
				local queryNorm = cached.norm
				local queryAlt = cached.alt
				for _, line in ipairs(renderLines) do
					local lineNorm = lower_utf8_optimized(line):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
					local isMatch = lineNorm:find(queryNorm, 1, true) or lineNorm:find(queryAlt, 1, true)
					render_bb_text(line, baseScale, isMatch)
				end
			else
				for _, line in ipairs(renderLines) do render_bb_text(line, baseScale) end
			end
			imgui.PopFont()
			imgui.EndChild()
			imgui.PopStyleColor()
		end
	end
	return foundAny
end
function updateSearchResults(query)
	if query == ui.search.lastQuery and ui.search.resultsValid then
		return
	end
	ui.search.cachedResults = {}
	ui.search.lastQuery = query
	for i = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[i]
		local matchingItems = {}
		local isBufferCategory = category and category[1] == settings.bufferCategoryName
		if query == "" then
			for j = 2, #category do
				table.insert(matchingItems, j)
			end
			ui.search.cachedResults[i] = matchingItems
		else
			for j = 2, #category do 
				local bind = category[j] or {}
				local bindName = bind[1] or ''
				local bindText = bind[2] or ''
				local bindAuthor = bind[3] or ''
				if search_in_help_binds(query, bindName) or 
					search_in_help_binds(query, bindText) or
					search_in_help_binds(query, bindAuthor) then
					table.insert(matchingItems, j)
				end
			end
			if #matchingItems > 0 then
				ui.search.cachedResults[i] = matchingItems
			end
		end
	end
	ui.search.resultsValid = true
end
function trim(s)
	return (s or ""):match("^%s*(.-)%s*$")
end
function getPlayerPlatform(playerId)
	if not sampIsPlayerConnected(playerId) then return nil end
	local fullNick = sampGetPlayerNickname(playerId)
	if not fullNick then return nil end
	if fullNick:find("%[PC%]") then
		return "PC"
	elseif fullNick:find("%[M%]") then
		return "M"
	end
	return nil
end
function parseMembers(raw_text)
	local members = {}
	if type(raw_text) ~= "string" then return members end
	local lines = {}
	for line in raw_text:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	for i = 1, #lines do
		local raw = lines[i]
		local cleanLine = raw:gsub("{%x%x%x%x%x%x}", "")
		cleanLine = trim(cleanLine)
		if cleanLine ~= "" and cleanLine:match("^%d+%.") then
			local parts = {}
			for part in cleanLine:gmatch("[^|]+") do
				table.insert(parts, trim(part))
			end
			if #parts >= 4 then
				local num, pos, rank = parts[1]:match("^(%d+)%.%s*(.-)%[(%d+)%]")
				local name, id = parts[2]:match("^([%w_]+)%s*%[(%d+)%]")
				local phone = parts[3] or "N/A"
				local warns = parts[4] or "0/0"
				local afk, mute, noUniform = nil, nil, false
				local extra = ""
				if #parts > 4 then
					for j = 5, #parts do
						extra = extra .. " " .. parts[j]
					end
				end
				extra = trim(extra:gsub("{%x%x%x%x%x%x}", ""))
				extra = cp1251_to_utf8(extra)
				local afkMatch = extra:match("[Aa][Ff][Kk]:?%s*([%w:%s]+)")
				if afkMatch then
					afk = trim(afkMatch)
					extra = extra:gsub("[Aa][Ff][Kk]:?%s*[%w:%s]+", "")
					extra = trim(extra)
				end
				local muteMatch = extra:match("[Вв]%s*муте%s*%(*%s*([%d:]+)%s*%)")
				if not muteMatch then
					muteMatch = extra:match("муте%s*%(*%s*([%d:]+)%s*%)")
				end
				if not muteMatch then
					muteMatch = extra:match("[Mm][Uu][Tt][Ee]%s*%(*%s*([%d:]+)%s*%)")
				end
				if muteMatch then
					mute = trim(muteMatch)
					extra = extra:gsub("[Вв]%s*муте%s*%(*%s*[%d:]+%s*%)", "")
					extra = trim(extra)
				end
				if extra:lower():find("без формы") then
					noUniform = true
					extra = extra:gsub("[Бб]ез формы", "")
					extra = trim(extra)
				end
				local isOffline = false
				if pos and pos:find("^%-") then
					isOffline = true
				end
				local platform = nil
				if num and name and id then
					local playerId = tonumber(id)
					if playerId then
						platform = getPlayerPlatform(playerId)
					end
					table.insert(members, {
						num = tonumber(num) or 0,
						position = cp1251_to_utf8(pos or "N/A"),
						rank = tonumber(rank) or 0,
						name = cp1251_to_utf8(name),
						id = tonumber(id) or 0,
						phone = phone or "N/A",
						warns = warns or "0/0",
						afk = afk,
						mute = mute,
						online = not isOffline,
						noUniform = noUniform,
						platform = platform
					})
				end
			end
		end
	end
	return members
end
function decode1251(str)
	local t = {
		[0xC0]='А',[0xC1]='Б',[0xC2]='В',[0xC3]='Г',[0xC4]='Д',[0xC5]='Е',[0xC6]='Ж',[0xC7]='З',[0xC8]='И',[0xC9]='Й',
		[0xCA]='К',[0xCB]='Л',[0xCC]='М',[0xCD]='Н',[0xCE]='О',[0xCF]='П',[0xD0]='Р',[0xD1]='С',[0xD2]='Т',[0xD3]='У',
		[0xD4]='Ф',[0xD5]='Х',[0xD6]='Ц',[0xD7]='Ч',[0xD8]='Ш',[0xD9]='Щ',[0xDA]='Ъ',[0xDB]='Ы',[0xDC]='Ь',[0xDD]='Э',
		[0xDE]='Ю',[0xDF]='Я',[0xE0]='а',[0xE1]='б',[0xE2]='в',[0xE3]='г',[0xE4]='д',[0xE5]='е',[0xE6]='ж',[0xE7]='з',
		[0xE8]='и',[0xE9]='й',[0xEA]='к',[0xEB]='л',[0xEC]='м',[0xED]='н',[0xEE]='о',[0xEF]='п',[0xF0]='р',[0xF1]='с',
		[0xF2]='т',[0xF3]='у',[0xF4]='ф',[0xF5]='х',[0xF6]='ц',[0xF7]='ч',[0xF8]='ш',[0xF9]='щ',[0xFA]='ъ',[0xFB]='ы',
		[0xFC]='ь',[0xFD]='э',[0xFE]='ю',[0xFF]='я'
	}
	local out = {}
	for i = 1, #str do
		local b = string.byte(str, i)
		if b < 128 then
			out[#out+1] = string.char(b)
		else
			out[#out+1] = t[b] or '?'
		end
	end
	return table.concat(out)
end
function escapeProblematicChars(text)
	text = text:gsub("w", "w​"):gsub("W", "W​")
	text = text:gsub("u", "u​"):gsub("U", "U​")
	return text
end
function resetIO()
	for i = 0, 511 do
		imgui.GetIO().KeysDown[i] = false
	end
	for i = 0, 4 do
		imgui.GetIO().MouseDown[i] = false
	end
	imgui.GetIO().KeyCtrl = false
	imgui.GetIO().KeyShift = false
	imgui.GetIO().KeyAlt = false
	imgui.GetIO().KeySuper = false
end
function convertSquareToLines()
	local text = ffi.string(efir.custom.squareText)
	if text == '' then
		return
	end
	if efir.custom.selected then
		efir.custom.lines = {}
		for line in text:gmatch("[^\r\n]+") do
			local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
			table.insert(efir.custom.lines, {
				text = imgui.new.char[512](trimmed)
			})
		end
		saveCustomEfirs()
	else
		AddNotification("[News Helper]", "Сначала выберите эфир!", "error", 3.0)
	end
end
function convertLinesToSquare()
	if not efir.custom.lines or #efir.custom.lines == 0 then
		return
	end
	local squareText = {}
	for _, line in ipairs(efir.custom.lines) do
		if line.text then
			local text = ffi.string(line.text)
			if text ~= "" then
				table.insert(squareText, text)
			end
		end
	end
	local combinedText = table.concat(squareText, "\n")
	ffi.fill(efir.custom.squareText, ffi.sizeof(efir.custom.squareText))
	ffi.copy(efir.custom.squareText, combinedText)
	saveCustomEfirs()
end
function countTable(tbl)
	local count = 0
	for _ in pairs(tbl) do count = count + 1 end
	return count
end
function getTableKeys(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	table.sort(keys, function(a, b)
		if type(a) == "number" and type(b) == "number" then
			return a < b
		elseif type(a) == "number" then
			return true
		elseif type(b) == "number" then
			return false
		else
			return tostring(a) < tostring(b)
		end
	end)
	return keys
end
function encodeJsonPretty(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local nextIndentStr = string.rep("  ", indent + 1)
	if type(obj) == "table" then
		local isArray = true
		local maxIndex = 0
		for k in pairs(obj) do
			if type(k) ~= "number" then
				isArray = false
				break
			end
			maxIndex = math.max(maxIndex, k)
		end
		if isArray and maxIndex == #obj then
			if #obj == 0 then return "[]" end
			local result = "[\n"
			for i, v in ipairs(obj) do
				result = result .. nextIndentStr .. encodeJsonPretty(v, indent + 1)
				if i < #obj then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "]"
			return result
		else
			if not next(obj) then return "{}" end
			local result = "{\n"
			local count = 0
			for k, v in pairs(obj) do
				count = count + 1
				result = result .. nextIndentStr .. '"' .. tostring(k) .. '": ' .. encodeJsonPretty(v, indent + 1)
				if count < countTable(obj) then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "}"
			return result
		end
	elseif type(obj) == "string" then
		return '"' .. obj:gsub('"', '\\"') .. '"'
	elseif type(obj) == "number" then
		return tostring(obj)
	elseif type(obj) == "boolean" then
		return obj and "true" or "false"
	else
		return "null"
	end
end
function encodeJsonPrettySorted(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local nextIndentStr = string.rep("  ", indent + 1)
	if type(obj) == "table" then
		local isArray = true
		local maxIndex = 0
		for k in pairs(obj) do
			if type(k) ~= "number" then
				isArray = false
				break
			end
			maxIndex = math.max(maxIndex, k)
		end
		if isArray and maxIndex == #obj then
			if #obj == 0 then return "[]" end
			local result = "[\n"
			for i, v in ipairs(obj) do
				result = result .. nextIndentStr .. encodeJsonPrettySorted(v, indent + 1)
				if i < #obj then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "]"
			return result
		else
			if not next(obj) then return "{}" end
			local result = "{\n"
			local keys = getTableKeys(obj)
			for idx, k in ipairs(keys) do
				result = result .. nextIndentStr .. '"' .. tostring(k) .. '": ' .. encodeJsonPrettySorted(obj[k], indent + 1)
				if idx < #keys then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "}"
			return result
		end
	elseif type(obj) == "string" then
		return '"' .. obj:gsub('"', '\\"') .. '"'
	elseif type(obj) == "number" then
		return tostring(obj)
	elseif type(obj) == "boolean" then
		return obj and "true" or "false"
	else
		return "null"
	end
end
function encodeJsonPrettyBuffer(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local nextIndentStr = string.rep("  ", indent + 1)
	if type(obj) == "table" then
		local isArray = true
		local maxIndex = 0
		for k in pairs(obj) do
			if type(k) ~= "number" then
				isArray = false
				break
			end
			maxIndex = math.max(maxIndex, k)
		end
		if isArray and maxIndex == #obj then
			if #obj == 0 then return "[]" end
			local result = "[\n"
			for i, v in ipairs(obj) do
				result = result .. nextIndentStr .. encodeJsonPrettyBuffer(v, indent + 1)
				if i < #obj then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "]"
			return result
		else
			if not next(obj) then return "{}" end
			local result = "{\n"
			local count = 0
			local totalKeys = 0
			for _ in pairs(obj) do totalKeys = totalKeys + 1 end
			for k, v in pairs(obj) do
				count = count + 1
				result = result .. nextIndentStr .. '"' .. tostring(k) .. '": '
				if type(v) == "string" then
					result = result .. '"' .. v:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
				else
					result = result .. encodeJsonPrettyBuffer(v, indent + 1)
				end
				if count < totalKeys then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "}"
			return result
		end
	elseif type(obj) == "string" then
		return '"' .. obj:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
	elseif type(obj) == "number" then
		return tostring(obj)
	elseif type(obj) == "boolean" then
		return obj and "true" or "false"
	else
		return "null"
	end
end
function encodeJsonAutoFill(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local nextIndentStr = string.rep("  ", indent + 1)
	if type(obj) == "table" then
		local isArray = true
		local maxIndex = 0
		for k in pairs(obj) do
			if type(k) ~= "number" then
				isArray = false
				break
			end
			maxIndex = math.max(maxIndex, k)
		end
		if isArray and maxIndex == #obj then
			if #obj == 0 then return "[]" end
			local result = "[\n"
			for i, v in ipairs(obj) do
				result = result .. nextIndentStr .. encodeJsonAutoFill(v, indent + 1)
				if i < #obj then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "]"
			return result
		else
			if not next(obj) then return "{}" end
			local result = "{\n"
			local count = 0
			local totalKeys = 0
			for _ in pairs(obj) do totalKeys = totalKeys + 1 end
			for k, v in pairs(obj) do
				count = count + 1
				result = result .. nextIndentStr .. '"' .. tostring(k) .. '": '
				if type(v) == "string" then
					result = result .. '"' .. v:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
				else
					result = result .. encodeJsonAutoFill(v, indent + 1)
				end
				if count < totalKeys then result = result .. "," end
				result = result .. "\n"
			end
			result = result .. indentStr .. "}"
			return result
		end
	elseif type(obj) == "string" then
		return '"' .. obj:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
	elseif type(obj) == "number" then
		return tostring(obj)
	elseif type(obj) == "boolean" then
		return obj and "true" or "false"
	else
		return "null"
	end
end
