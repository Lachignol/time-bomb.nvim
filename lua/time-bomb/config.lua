local m = {}

local utils = require("time-bomb.utils")

m.defaults = {
	-- by default it's at true
	-- set at false if you want disable default_keymap
	enable_default_keymaps = true,
	-- custom keymaps don't desactivate enable_default_keymaps with you want overload your keymaps
	keymaps =
	{
		pomodoro_start = "<leader>tbs",
		timer_custom = "<leader>tbc",
		stop_timer = "<leader>tbe",
		pause_timer = "<leader>tbp",
		next_timer = "<leader>tbn",
		prev_timer = "<leader>tbb",
	},
	-- default cycles but you can add yours
	-- the time is in number of minute
	-- you have only two style for the moment only "normal" by default or "mama-lova"
	pomodoro_cycles = {
		{ title = "work",        time = "25", style = "normal" },
		{ title = "short-break", time = "5",  style = "mama-lova" },
		{ title = "work",        time = "25", style = "normal" },
		{ title = "short-break", time = "5",  style = "mama-lova" },
		{ title = "work",        time = "25", style = "normal" },
		{ title = "long-break",  time = "15", style = "mama-lova" }
	},
	-- default color for timer
	timer_color = "lime",
}

-- style valide
local valid_style = { "mama-lova", "normal", "cyberpunk", "fire", "dots", "music" }


-- couleurs valide
local valid_colors = { "lime", "blue", "black", "gray", "silver", "white", "fuchsia" }

m.health = {
	errors = {},
	warnings = {},
	info = {},
}

m.options = {}


-- fonction pour remplacer valeurs par valeurs si mauvais type
-- local function validate(toTest, type, replaceIfError)
-- 	if type(toTest) ~= type then
-- 		toTest = replaceIfError
-- 		table.insert(m.health.errors,
-- 			"[error] time-bomb " .. toTest .. " is an invalid type: \n \
-- 			All values must be string")
-- 		utils.notify("1 error at least you can see more with :checkhealth time-bomb", 3)
-- 	end
-- end


local function validate_general_type(config)
	return (type(config.enable_default_keymaps) == "boolean" and
		type(config.keymaps) == "table" and
		type(config.pomodoro_cycles) == "table" and
		type(config.timer_color) == "string" and
		type(config.enable_notification) == "boolean")
end

local function validate_type_keymaps(config)
	return (
		type(config.keymaps.pomodoro_start) == "string" and
		type(config.keymaps.timer_custom) == "string" and
		type(config.keymaps.stop_timer) == "string" and
		type(config.keymaps.pause_timer) == "string" and
		type(config.keymaps.next_timer) == "string" and
		type(config.keymaps.prev_timer) == "string")
end


local function validate_type_of_one_cycle_of_pomodoro(cycle)
	return (
		type(cycle.title) == "string" and
		type(cycle.time) == "string" and
		type(cycle.style) == "string")
end


-- fonction pour configurer le plugin
-- permet a l'utilisateur de personaliser le plugin
function m.setup(user_options)
	-- fusionner la configuration utilisateur avec les valeurs par défaut
	m.options = vim.tbl_deep_extend("force", m.defaults, user_options or {})

	-- check general des types de la config si pas bon je remet tout les valeurs par defaults
	if not validate_general_type(m.options) then
		table.insert(m.health.errors,
			"[error] time-bomb config have an invalid type: \n \
			enable_default_keymaps must be boolean \
			keymaps must be table \
			pomodoro_cycles must be table \
			timer_color must be string \
			enable_notification must be boolean")
		utils.notify("1 error at least you can see more with :checkhealth time-bomb", 3)
		m.options = m.defaults
	end

	-- check du tableau des keymaps de la config si pas bon je remet toutes les keymaps par defaults
	if not validate_type_keymaps(m.options) then
		table.insert(m.health.errors,
			"[error] time-bomb config keymaps table have an invalid type: \n \
			All values must be string")
		utils.notify("1 error at least you can see more with :checkhealth time-bomb", 3)
		m.options.keymaps = m.defaults.keymaps
	end


	---------------------------------------------check pomodoro_cycles---------------------------------------------
	for i = 1, #m.options.pomodoro_cycles do
		-- check de tout les type du cycle en cours si pas bon je remplace par le premier cycle par default
		if not validate_type_of_one_cycle_of_pomodoro(m.options.pomodoro_cycles[i]) then
			table.insert(m.health.errors,
				"[error] time-bomb config at pomodoro_cycles number: " ..
				i .. " All value must be string")

			utils.notify("1 error at least you can see more with :checkhealth time-bomb", 3)
			m.options.pomodoro_cycles[i] = m.defaults.pomodoro_cycles[1]
		end
		-- check si titre est pas plus grand que 11 char si oui warning seulement car texte tronquer
		if #m.options.pomodoro_cycles[i].title > 11
		then
			table.insert(m.health.warnings,
				"[WARNING] time-bomb config at pomodoro_cycles number: " .. i .. " " ..
				m.options.pomodoro_cycles[i].title ..
				" title must be less than 10 char it will be truncate ")
		end


		-- check si time est superieur a 24 h si oui error et time mis a moin de 24h
		local time = tonumber(m.options.pomodoro_cycles[i].time)
		if time >= 1440 then
			table.insert(m.health.errors,
				"[error] time-bomb config at pomodoro_cycles number: " .. i .. " " ..
				m.options.pomodoro_cycles[i].time ..
				" must be less than 24h")
			utils.notify("1 error you can see more with :checkhealth time-bomb", 3)
			m.options.pomodoro_cycles[i].time = "1439"

			-- check si time est inferieur a 1 min si oui error et time mis a 1 min
		elseif time < 1 then
			table.insert(m.health.errors,
				"[error] time-bomb config at pomodoro_cycles number: " .. i .. " " ..
				m.options.pomodoro_cycles[i].time ..
				" must be equal or upper than 1 min ")
			utils.notify("1 error you can see more with :checkhealth time-bomb", 3)
			m.options.pomodoro_cycles[i].time = "1"
		end
		-- check si style valide sinon erreur et mis a normal
		if not vim.tbl_contains(valid_style, m.options.pomodoro_cycles[i].style)
		then
			table.insert(m.health.errors,
				"[error] time-bomb config at pomodoro_cycles number: " ..
				i .. " " .. m.options.pomodoro_cycles[i].style .. " it's not valid entry'")
			utils.notify("1 error you can see more with :checkhealth time-bomb", 3)
			m.options.pomodoro_cycles[i].style = "normal"
		end
	end


	----------------------------------------------------------------------------------------------------------------

	-- chek timer_color si valide sinon mis a lime
	if not vim.tbl_contains(valid_colors, m.options.timer_color)
	then
		table.insert(m.health.errors,
			"[error] time-bomb config at timer_color : " .. m.options.timer_color)
		utils.notify("1 error you can see more with :checkhealth time-bomb", 3)
		m.options.timer_color = "lime"
	end
	----------------------------------------------------------------------------
	---------------------si keymaps enable je set les keymaps si oui je met une info ----------------------------------

	if m.options.enable_default_keymaps then
		vim.keymap.set('n', m.options.keymaps.pomodoro_start, ":Pomodoro<cr>", { desc = "Start pomodoro" })
		vim.keymap.set('n', m.options.keymaps.timer_custom, ":Timer", { desc = "Start custom timer" })
		vim.keymap.set('n', m.options.keymaps.stop_timer, ":StopTimer<cr>", { desc = "Stop timer" })
		vim.keymap.set('n', m.options.keymaps.pause_timer, ":PauseTimer<cr>", { desc = "Toggle timer in pause" })
		vim.keymap.set('n', m.options.keymaps.next_timer, ":NextCycle<cr>", { desc = "Go to next cycle" })
		vim.keymap.set('n', m.options.keymaps.prev_timer, ":PrevCycle<cr>", { desc = "Go to previous cycle" })
		table.insert(m.health.info, "keymaps are set")
	end
end

return m
