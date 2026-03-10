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
