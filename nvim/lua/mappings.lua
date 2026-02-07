require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>cd", vim.cmd.Oil, { desc = "OIL enable oil tree" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
