local M = {}


------------------------------Fonctions pour la validation-------------------------------

-- Check si aucun autre timer est en cours
function M.ready_to_start(timer_in_progress)
	if timer_in_progress == true then
		M.notify("Timer already in progress\nFor stop enter :StopTimer")
		return false
	end
	return true
end

-- Check si la valeur du timer donne par l'user est ok
function M.check_if_value_of_timer_is_ok(timer)
	if not timer or timer == "" then
		M.notify("No value for timer", "warn")
		return false
	end
	local timer_number = tonumber(timer)
	if not timer_number or timer_number >= 1440 or timer_number < 1 then
		M.notify("Timer must be less than 24h and equal or upper than 1 min", "warn")
		return false
	end
	return true
end

--------------------------------------------------------------------------------


------------------------------Fonctions pour affichage-------------------------------

-- handler pour cree la barre de progression qui correspond
function M.create_progress_bar(timer, total_duration_of_cycle, style)
	local bar = nil
	local progression = timer / total_duration_of_cycle
	if style == "mama-lova" then
		return M.create_mama_lova_progress_bar(progression, timer)
	elseif style == "cyberpunk" then
		return M.create_cyberpunk_progress_bar(progression, timer)
	elseif style == "fire" then
		return M.create_fire_progress_bar(progression, timer)
	elseif style == "dots" then
		return M.create_dots_progress_bar(progression, timer)
	elseif style == "music" then
		return M.create_music_progress_bar(progression, timer)
	end

	return bar
end

-- Fonction pour cree la bar de progression mama-lova
function M.create_mama_lova_progress_bar(progression, timer)
	local width = 10
	local to_fill = math.floor(progression * width)
	if ((to_fill == 0) and not (timer == 0)) then to_fill = to_fill + 1 end
	local to_empty = width - to_fill
	local bar = "[" .. ("❤️"):rep(to_fill) .. ("🩶"):rep(to_empty) .. "]"
	return bar
end

-- Fonction pour cree la bar de progression cyberpunk
function M.create_cyberpunk_progress_bar(progression, timer)
	local width = 10
	local to_fill = math.floor(progression * width)
	if ((to_fill == 0) and not (timer == 0)) then to_fill = to_fill + 1 end
	return "▌" .. string.rep("█", to_fill) .. string.rep("░", width - to_fill) .. "▐"
end

-- Fonction pour cree la bar de progression fire
function M.create_fire_progress_bar(progression, timer)
	local width = 10
	local to_fill = math.floor(progression * width)
	if ((to_fill == 0) and not (timer == 0)) then to_fill = to_fill + 1 end
	local filled = string.rep("🟥", to_fill)
	local empty = string.rep("⬜", width - to_fill)
	return filled .. empty
end

-- Fonction pour cree la bar de progression dots
function M.create_dots_progress_bar(progression, timer)
	local width = 10
	local to_fill = math.floor(progression * width)
	if ((to_fill == 0) and not (timer == 0)) then to_fill = to_fill + 1 end
	local filled = string.rep("●", to_fill)
	local empty = string.rep("○", width - to_fill)
	return filled .. empty
end

-- Fonction pour cree la bar de progression music
function M.create_music_progress_bar(progression, timer)
	local width = 10
	local to_fill = math.floor(progression * width)
	if ((to_fill == 0) and not (timer == 0)) then to_fill = to_fill + 1 end
	local filled = string.rep("♪", to_fill)
	local empty = string.rep("·", width - to_fill)
	return filled .. empty
end

-- Defini la width de la fenetre en fonction du style et donc de la progress_bar
function M.set_width(style)
	local width = 11
	if (style == "mama-lova") then
		width = 22
	elseif (style == "cyberpunk") then
		width = 12
	elseif (style == "fire") then
		width = 20
	elseif (style == "dots") then
		width = 11
	elseif (style == "music") then
		width = 11
	end
	return width
end

-- Defini la height de la fenetre en fonction du style et donc de la progress_bar
function M.set_height(style)
	local height = 1
	if (style == "mama-lova") then
		height = 2
	elseif (style == "cyberpunk") then
		height = 2
	elseif (style == "fire") then
		height = 2
	elseif (style == "dots") then
		height = 2
	elseif (style == "music") then
		height = 2
	end
	return height
end

-- Defini la couleur en fonction du style
function M.set_color(color_of_user)
	local color = "#00ff00"
	if (color_of_user == "lime") then
		color = "#00ff00"
	elseif (color_of_user == "blue") then
		color = "#0000ff"
	elseif (color_of_user == "black") then
		color = "#000000"
	elseif (color_of_user == "gray") then
		color = "#808080"
	elseif (color_of_user == "silver") then
		color = "#C0C0C0"
	elseif (color_of_user == "white") then
		color = "#FFFFFF"
	elseif (color_of_user == "fuchsia") then
		color = "#FF00FF"
	end
	return color
end

-- Prepare le buffer et les options de fenetres en fonction du cas timer (avec ces options selon le style) ou simple timer
function M.set_buffer_and_options(current_pomodoro_cycle)
	local buf, opts
	if current_pomodoro_cycle
	then
		buf = vim.api.nvim_create_buf(false, true)
		opts = {
			title = current_pomodoro_cycle.title,
			title_pos = "right",
			relative = 'editor',
			width = M.set_width(current_pomodoro_cycle.style),
			height = M.set_height(current_pomodoro_cycle.style),
			col = vim.o.columns - 2,
			row = 1,
			anchor = 'NE',
			style = 'minimal',
			zindex = 1000,
			focusable = false
		}
	else
		buf = vim.api.nvim_create_buf(false, true)
		opts = {
			title = "TIME-BOMB",
			title_pos = "right",
			relative = 'editor',
			width = 11,
			height = 1,
			col = vim.o.columns - 2,
			row = 1,
			anchor = 'NE',
			style = 'minimal',
			zindex = 1000,
			focusable = false
		}
	end
	return buf, opts
end

-- Ouvre et stylise la fenetre avec le buffer,les opts et la couleur
function M.edit_and_open_win(buf, opts, color)
	vim.api.nvim_set_hl(0, "TimerNormal", { fg = color, bold = true })
	local win_of_timer = vim.api.nvim_open_win(buf, false, opts)
	vim.api.nvim_set_option_value("winhl", "Normal:TimerNormal", { win = win_of_timer })
	return win_of_timer
end

-- Formatage des minutes
function M.convert_to_time(total_seconds)
	local hh = math.floor(total_seconds / 3600)
	local mm = math.floor((total_seconds % 3600) / 60)
	local ss = total_seconds % 60

	if hh > 0 then
		return string.format("%dH%02dmin%02ds", hh, mm, ss)
	else
		return string.format("%02dmin%02ds", mm, ss)
	end
end

-- Envoyer message avec le niveau d'alerte voulu
function M.notify(message, level)
	local levels = {
		info = vim.log.levels.INFO,
		warn = vim.log.levels.WARN,
		error = vim.log.levels.ERROR,
	}
	vim.notify(message, levels[level] or levels.info, {
		title = "time-bomb.nvim",
	})
end

--------------------------------------------------------------------------------

return M
