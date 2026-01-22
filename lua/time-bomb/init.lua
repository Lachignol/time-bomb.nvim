local config = require("time-bomb.config")
local utils = require("time-bomb.utils")


local M = {}

M.timer = {
	instance = nil,
	mode = "NEUTRAL",
	state = "STOP",
	window = nil,
	remaining = 0,
	cycle = 0,
	buf = nil,
	opts = nil,
}

-- Fonction setup pour initialiser le plugin
function M.setup(user_options)
	-- Configurer le plugin avec les options utilisateur
	config.setup(user_options)
	-- Creation d'un commande automatique qui s'execute sur l'evenement vimresized donc un redimensionement de fenetre
	vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			if M.timer.window and vim.api.nvim_win_is_valid(M.timer.window) then
				local ok, err = pcall(M.update_window_position, M.timer.window)
				if not ok then vim.notify("Window resize failed: " .. err, vim.log.levels.WARN) end
			end
		end
	})
end

-------------------------------------------------------MAIN FUNCTION---------------------------------------

-- Fonction principal pour lancer timer selon le mode
function M.run_timer(duration, mode)
	if M.timer.instance ~= nil then
		utils.notify("Timer already running. Use :StopTimer")
		-- M.reinitialize_timer_state()
		return
	end
	M.timer.instance = vim.uv.new_timer()
	M.timer.mode = mode
	M.timer.state = "RUNNING"
	if M.timer.mode == "TIMER"
	then
		if not utils.check_if_value_of_timer_is_ok(duration) then
			M.reinitialize_timer_state()
			return
		end
		M.timer.buf, M.timer.opts = utils.set_buffer_and_options()
		local color = utils.set_color(config.options.timer_color)
		local start = vim.uv.now()
		M.timer.remaining = duration * 60
		M.timer.window = utils.edit_and_open_win(M.timer.buf, M.timer.opts, color)
		M.timer.instance:start(0, 1000, vim.schedule_wrap(function()
			local now = vim.uv.now()
			local spending_time = (now - start) / 1000
			M.timer.remaining = math.max(0, duration * 60 - spending_time)
			local format = utils.convert_to_time(M.timer.remaining)
			local padding = string.rep(" ", 10 - vim.fn.strdisplaywidth(format))
			if not M.check_if_buf_is_valid(M.timer.buf) then return end
			vim.api.nvim_buf_set_lines(M.timer.buf, 0, -1, true, { padding .. format })
			if M.timer.remaining <= 0 then
				if config.options.enable_notification then utils.notify("Timeout") end
				M.timer.state = "ENDING"
				M.reinitialize_timer_state()
				return
			end
		end))
	else
		M.timer.cycle = (M.timer.cycle or 0) + 1
		if (M.timer.cycle > #config.options.pomodoro_cycles) then M.timer.cycle = 1 end
		local current_cycle = config.options.pomodoro_cycles[M.timer.cycle]
		local start = vim.uv.now()
		local total_duration_of_current_cycle = tonumber(current_cycle.time)
		M.timer.remaining = total_duration_of_current_cycle * 60
		M.timer.buf, M.timer.opts = utils.set_buffer_and_options(current_cycle)
		local color = utils.set_color(config.options.timer_color)
		local cycle_style = current_cycle.style
		M.timer.window = utils.edit_and_open_win(M.timer.buf, M.timer.opts, color)
		M.timer.instance:start(0, 1000, vim.schedule_wrap(function()
			local now = vim.uv.now()
			local spending_time = (now - start) / 1000
			M.timer.remaining = math.max(0, total_duration_of_current_cycle * 60 - spending_time)
			local format = utils.convert_to_time(M.timer.remaining)
			local progress_bar = utils.create_progress_bar(M.timer.remaining, total_duration_of_current_cycle
				* 60,
				cycle_style)
			local padding = string.rep(" ", utils.set_width(cycle_style) - vim.fn.strdisplaywidth(format))
			local line = { padding .. format }
			if progress_bar then line = { progress_bar, padding .. format } end
			if not M.check_if_buf_is_valid(M.timer.buf) then return end
			vim.api.nvim_buf_set_lines(M.timer.buf, 0, -1, true, line)


			if M.timer.remaining <= 0 then
				if config.options.enable_notification then utils.notify("Timeout") end
				M.prepare_next_cycle()
				M.timer.state = "ENDING"
				vim.defer_fn(function()
					if M.timer.state == "ENDING" then
						M.run_timer("nimportequoi", "POMODORO")
					end
				end, 100)
			end
		end))
	end
end

-- Fonction pour relancer timer qui a ete mis en pause TODO a refacto
function M.restart_timer(duration)
	M.timer.state = "RUNNING"
	if M.timer.mode == "TIMER"
	then
		local start = vim.uv.now()
		M.timer.instance:start(0, 1000, vim.schedule_wrap(function()
			local now = vim.uv.now()
			local spending_time = (now - start) / 1000
			M.timer.remaining = math.max(0, duration - spending_time)
			local format = utils.convert_to_time(M.timer.remaining)
			local padding = string.rep(" ", 10 - vim.fn.strdisplaywidth(format))
			if not M.check_if_buf_is_valid(M.timer.buf) then return end
			vim.api.nvim_buf_set_lines(M.timer.buf, 0, -1, true, { padding .. format })
			if M.timer.remaining <= 0 then
				if config.options.enable_notification then utils.notify("Timeout") end
				M.timer.state = "ENDING"
				M.reinitialize_timer_state()
				return
			end
		end))
	else
		local current_cycle = config.options.pomodoro_cycles[M.timer.cycle]
		local start = vim.uv.now()
		local total_duration_of_current_cycle = config.options.pomodoro_cycles[M.timer.cycle].time
		local cycle_style = current_cycle.style
		M.timer.instance:start(0, 1000, vim.schedule_wrap(function()
			local now = vim.uv.now()
			local spending_time = (now - start) / 1000
			M.timer.remaining = math.max(0, duration - spending_time)
			local format = utils.convert_to_time(M.timer.remaining)
			local progress_bar = utils.create_progress_bar(M.timer.remaining,
				total_duration_of_current_cycle * 60,
				cycle_style)
			local padding = string.rep(" ", utils.set_width(cycle_style) - vim.fn.strdisplaywidth(format))
			local line = { padding .. format }
			if progress_bar then line = { progress_bar, padding .. format } end
			if not M.check_if_buf_is_valid(M.timer.buf) then return end
			vim.api.nvim_buf_set_lines(M.timer.buf, 0, -1, true, line)

			if M.timer.remaining <= 0 then
				if config.options.enable_notification then utils.notify("Timeout") end
				M.prepare_next_cycle()
				M.timer.state = "ENDING"
				vim.defer_fn(function()
					if M.timer.state == "ENDING" then
						M.run_timer("nimportequoi", "POMODORO")
						M.timer.state = "RUNNING"
					end
				end, 100)
			end
		end))
	end
end

--------------------------------------ACTIONS------------------------------------------------------------------

function M.next_cycle()
	if M.timer.instance and M.timer.mode == "POMODORO"
	then
		M.prepare_next_cycle()
		M.run_timer("nimportequoi", "POMODORO")
	else
		utils.notify("No next cycle")
	end
end

function M.prev_cycle()
	if M.timer.instance then
		if M.timer.mode == "POMODORO" then
			if M.timer.cycle - 2 >= 0 then
				M.prepare_prev_cycle()
				M.run_timer("nimportequoi", "POMODORO")
				return
			else
				utils.notify("No previous cycle")
				return
			end
		else
			utils.notify("Simple timer: no cycles")
			return
		end
	end
	utils.notify("No timer is running")
end

function M.restart_timer_in_pause()
	M.restart_timer(M.timer.remaining)
end

function M.stop_timer()
	if M.timer.instance
	then
		M.reinitialize_timer_state()
		if M.timer.mode == "POMODORO" then
			utils.notify("Pomodoro stop")
			return
		else
			utils.notify("Timer stop")
			return
		end
	else
		utils.notify("No timer to stop")
	end
end

function M.pause_timer()
	if M.timer.instance and M.timer.state ~= "PAUSE"
	then
		M.set_timer_in_pause()
		if M.timer.mode == "POMODORO" then
			utils.notify("Pomodoro pause")
			return
		else
			utils.notify("Timer pause")
			return
		end
		return
	end
	if M.timer.instance and M.timer.state == "PAUSE"
	then
		M.restart_timer_in_pause()
		utils.notify("Resume timer")
		return
	end
	utils.notify("No timer to pause")
end

function M.close_window()
	if M.timer.window
	    and vim.api.nvim_win_is_valid(M.timer.window) then
		vim.api.nvim_win_close(M.timer.window, true)
	end
	M.timer.window = nil
end

function M.clear_timer()
	if M.timer.instance then
		M.timer.instance:stop()
		M.timer.instance:close()
		M.timer.instance = nil
	end
end

function M.update_window_position(win)
	if not vim.api.nvim_win_is_valid(win) then return end
	local current_config = vim.api.nvim_win_get_config(win)
	local new_opts = vim.tbl_extend("force", current_config, {
		col = vim.o.columns - 2,
		row = 1,
	})
	vim.api.nvim_win_set_config(win, new_opts)
end

function M.check_if_buf_is_valid(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		M.reinitialize_timer_state()
		return false
	end
	return true
end

--------------------------------STATE-MANAGEMENT-----------------------------------------------------

function M.reinitialize_timer_state()
	M.close_window()
	M.clear_timer()
	M.timer.state = "STOP"
	M.timer.mode = "NEUTRAL"
	M.timer.window = nil
	M.timer.cycle = 0
	M.timer.buf = nil
	M.timer.opts = nil
end

function M.prepare_next_cycle()
	M.close_window()
	M.clear_timer()
	M.timer.state = "STOP"
	M.timer.mode = "NEUTRAL"
	M.timer.window = nil
	M.timer.buf = nil
	M.timer.opts = nil
end

function M.prepare_prev_cycle()
	M.clear_timer()
	M.close_window()
	M.timer.state = "STOP"
	M.timer.mode = "NEUTRAL"
	M.timer.window = nil
	M.timer.buf = nil
	M.timer.opts = nil
	M.timer.cycle = M.timer.cycle - 2
end

function M.set_timer_in_pause()
	if M.timer.instance then
		M.timer.instance:stop()
	end
	M.timer.state = "PAUSE"
end

--------------------------------------------------------------------------------------------------------
return M
