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
  term.toggle {
    id = "cpp_runner",
    pos = "float",

    cmd = function()
      local dir = vim.fn.expand "%:p:h" -- /home/user/proj

      return string.format('cd "%s" && /usr/local/bin/livecpp.sh', dir)
    end,
    clear_cmd = false,
  }
end, { desc = "C++ Compile & Run" })

map({ "n", "t" }, "<A-e>", function()
  term.toggle {
    id = "asm_runner",
    pos = "float",

    cmd = function()
      local dir = vim.fn.expand "%:p:h"
      return string.format('cd "%s" && /usr/local/bin/liveasm.sh', dir)
    end,

    clear_cmd = true,
    on_open = function()
      vim.cmd "startinsert!"
    end,
  }
end, { desc = "Asm Compile & Run" })

-- Terminal-Mode: ESC zum Verlassen des Insert-Mode
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
