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

-- Alt+F: Toggle Float Terminal mit cd in aktuelles Verzeichnis
map({ "n", "t" }, "<A-f>", function()
  term.toggle {
    pos = "float",
    id = "cd_term",
    cmd = function()
      local dir = vim.fn.expand "%:p:h"
      return "cd '" .. dir .. "'"
    end,
  }
end, { desc = "Toggle cd terminal" })

-- Alt+R: C++ Compile & Run
map({ "n", "t" }, "<A-r>", function()
  term.runner {
    id = "cpp_runner",
    pos = "float",

    cmd = function()
      local file = vim.fn.expand "%:p" -- /home/user/proj/main.cpp
      local dir = vim.fn.expand "%:p:h" -- /home/user/proj
      local name = vim.fn.expand "%:t:r" -- main (ohne .cpp)

      -- cd in Verzeichnis, kompilieren mit g++, ausführen
      return string.format('cd "%s" && cpp "%s" && "./%s"', dir, file, name)
    end,
    clear_cmd = false,
  }
end, { desc = "C++ Compile & Run" })

-- Terminal-Mode: ESC zum Verlassen des Insert-Mode
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
