require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- debug
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "DEBUGGER toggle debugger" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "DEBUGGER start or continue debugger" })

-- oil
map("n", "<leader>cd", vim.cmd.Oil, { desc = "OIL enable oil tree" })

-- idk
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

vim.keymap.set({ "n", "t" }, "<A-c>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end)
