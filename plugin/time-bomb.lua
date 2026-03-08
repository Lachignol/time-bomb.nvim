-- S'assurer que le plugin n'est chargé qu'une seule fois
if vim.g.loaded_time_bomb then
	return
end

vim.g.loaded_time_bomb = true


-- Autocompletion des commandes
-- signature complete des func d'autocompletion function(arglead, cmdline, cursorpos)
-- arglead type string >>  le morceau d’argument que l’utilisateur est en train de taper
-- cmdline type string >>  la ligne de commande complète
-- cursorpos type number >> la position du curseur dans cmdline

local function timebomb_completion(arglead, cmdline)
	local args = vim.split(cmdline, "%s+")

	local commands = { "timer", "pomodoro", "stop", "pause", "next", "prev" }
	local times = { "5", "10", "15", "20", "25", "30", "45", "60" }

	if #args == 2 then
		return vim.tbl_filter(function(v)
			return v:find(arglead) == 1
		end, commands)
	end

	if args[2] == "timer" then
		return vim.tbl_filter(function(v)
			return v:find(arglead) == 1
		end, times)
	end

	return {}
end

-- Commandes Sous le namespace TimeBomb
vim.api.nvim_create_user_command("TimeBomb", function(opts)
		local args = vim.split(opts.args or "", "%s+")
		local cmd = table.remove(args, 1)
		local time_bomb = require("time-bomb")

		-- je fait un tableau des fonctions
		local map = {
			timer = function() time_bomb.run_timer(args[1] or "25", "TIMER") end,
			pomodoro = function() time_bomb.run_timer(0, "POMODORO") end,
			stop = function() time_bomb.stop_timer() end,
			pause = function() time_bomb.pause_timer() end,
			next = function() time_bomb.next_cycle() end,
			prev = function() time_bomb.prev_cycle() end,
			help = function() print("Time-Bomb {timer|pomodoro|stop|pause|next|prev}") end
		}
		-- j'apelle la fonction qui correspond a la commande (key de ma map de fonction): ex: Time-Bomb stop (cmd = stop)
		-- si pas de fonction trouver a partir de la commande donc non presente dan mon tableau de fonctions
		-- j'apelle la fonction help pour print les cmds qui existe
		(map[cmd] or map.help)()
	end,
	{
		nargs = "*",
		complete = timebomb_completion
	})


-- -- Creation d'un alias plus rapide TB  ou autre >> meme comportement que pour TimeBomb
-- vim.api.nvim_create_user_command("TB", function(opts)
-- 	vim.cmd("TimeBomb " .. opts.args)
-- end, { nargs = "*", complete = timebomb_completion })


-- -- Commandes timer commande par commande (surcharge la cmd)
-- vim.api.nvim_create_user_command("Timer", function(opts)
-- 	require("time-bomb").run_timer(opts.args, "TIMER")
-- end, {
-- 	nargs = 1,
-- 	desc = "Start custom timer",
-- 	complete = function() return { "5", "10", "15", "25", "30", "45", "60" } end
-- })
--
-- vim.api.nvim_create_user_command("Pomodoro", function()
-- 	require("time-bomb").run_timer(0, "POMODORO")
-- end, { desc = "Start Pomodoro (default: 25/5/25/5/25/15)" })
--
-- vim.api.nvim_create_user_command("StopTimer", function()
-- 	require("time-bomb").stop_timer()
-- end, { desc = "Stop timer in progress" })
--
--
-- vim.api.nvim_create_user_command("PauseTimer", function()
-- 	require("time-bomb").pause_timer()
-- end, { desc = "Toggle timer in pause" })
-- --
-- --
-- vim.api.nvim_create_user_command("NextCycle", function()
-- 	require("time-bomb").next_cycle()
-- end, { desc = "Go to next cycle if exist" })
-- --
-- --
-- vim.api.nvim_create_user_command("PrevCycle", function()
-- 	require("time-bomb").prev_cycle()
-- end, { desc = "Go to previous cycle if exist" })
