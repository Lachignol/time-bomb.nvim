-- S'assurer que le plugin n'est chargé qu'une seule fois
if vim.g.loaded_time_bomb then
	return
end

vim.g.loaded_time_bomb = true


-- Commandes timer
vim.api.nvim_create_user_command("Timer", function(opts)
	require("time-bomb").run_timer(opts.args, "TIMER")
end, {
	nargs = 1,
	desc = "Start custom timer",
	complete = function() return { "5", "10", "15", "25", "30", "45", "60" } end
})

vim.api.nvim_create_user_command("Pomodoro", function()
	require("time-bomb").run_timer(0, "POMODORO")
end, { desc = "Start Pomodoro (default: 25/5/25/5/25/15)" })

vim.api.nvim_create_user_command("StopTimer", function()
	require("time-bomb").stop_timer()
end, { desc = "Stop timer in progress" })


vim.api.nvim_create_user_command("PauseTimer", function()
	require("time-bomb").pause_timer()
end, { desc = "Toggle timer in pause" })
--
--
vim.api.nvim_create_user_command("NextCycle", function()
	require("time-bomb").next_cycle()
end, { desc = "Go to next cycle if exist" })
--
--
vim.api.nvim_create_user_command("PrevCycle", function()
	require("time-bomb").prev_cycle()
end, { desc = "Go to previous cycle if exist" })
