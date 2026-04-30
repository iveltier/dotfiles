require "nvchad.autocmds"
--
-- Öffne Oil automatisch, wenn nvim mit einem Verzeichnis gestartet wird
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("Oil " .. arg)
    end
  end,
})

-- BongoCat Job ID speichern
local bongo_job = nil

-- BongoCat beim Öffnen von nvim starten
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    bongo_job = vim.fn.jobstart("sleep 1.5 && bongocat --watch-config", { detach = false })
  end,
})

-- BongoCat beim Schließen von nvim beenden
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    if bongo_job then
      vim.fn.jobstop(bongo_job)
    end
  end,
})

-- Reload theme.lua automatically after saving it
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand "~/.config/nvim/lua/theme.lua",
  callback = function()
    -- NVChad UI Module Cache leeren
    for module, _ in pairs(package.loaded) do
      if module:match "^nvchad" or module:match "^chad" then
        package.loaded[module] = nil
      end
    end

    -- Dein Theme neu laden
    package.loaded["theme"] = nil
    require "theme"

    -- NVChad UI reload
    require("nvchad").reload()

    vim.notify("Theme reloaded!", vim.log.levels.INFO)
  end,
})
