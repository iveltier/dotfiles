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

-- run cpp code terminal
local term = require "nvchad.term"

map({ "n", "t" }, "<A-r>", function()
  term.runner {
    pos = "vsp",
    id = "cpp_runner",
    clear_cmd = false,
    cmd = function()
      local dir = vim.fn.expand "%:p:h"
      local file = vim.fn.expand "%:t"
      local name = vim.fn.expand "%:r"

      return string.format("cd '%s' && clear && g++ -std=c++20 '%s' -o '%s' && './%s'", dir, file, name, name)
    end,
  }
end)

map({ "n", "t" }, "<A-f>", function()
  term.toggle {
    pos = "float",
    id = "cd_term",
    cmd = function()
      local dir = vim.fn.expand "%:p:h"
      return "cd '" .. dir .. "'"
    end,
  }
end)
