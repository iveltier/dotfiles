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
    bongo_job = vim.fn.jobstart("sleep 2 && bongocat", { detach = false })
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
