local M = {}


------------------------TODO---------------------------------------------------------
function M.check()
	local health_start = vim.health.start or vim.health.report_start
	local health_ok = vim.health.ok or vim.health.report_ok
	local health_error = vim.health.error or vim.health.report_error
	local health_warn = vim.health.warn or vim.health.report_warn
	health_start("time-bomb.nvim")
	-- Vérifier la version de Neovim
	if vim.fn.has("nvim-0.8") == 1 then
		health_ok("Neovim version 0.8+")
	else
		health_error("Neovim 0.8+ requis")
	end
	-- Vérifier que le plugin est configuré
	local ok, config = pcall(require, "time-bomb.config")
	-- Affichage de toutes les errors warning ou info qu'on a set dans config
	if ok then
		for i = 1, #config.health.errors
		do
			health_error(config.health.errors[i])
		end
		for i = 1, #config.health.warnings
		do
			health_warn(config.health.warnings[i])
		end
		for i = 1, #config.health.info
		do
			health_ok(config.health.info[i])
		end
	end
	-- Faire une autre verif sur les champs de la config donne par l'user
	-- if ok and config.options.pomodorro_cycles then
	-- 	health_ok("Plugin configuré correctement")
	-- 	health_ok(string.format("Message: '%s'", config.options.default_greeting))
	-- else
	-- 	health_warn("Plugin non configuré, utilisation des valeurs par défaut")
	-- end

	-- -- Vérifier les dépendances (si nécessaire)
	-- if vim.fn.executable("whoami") == 1 then
	-- 	health_ok("Commande 'whoami' disponible")
	-- else
	-- 	health_warn("Commande 'whoami' non trouvée")
	-- end
end

return M
