-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+/ 打开终端（当前文件所在目录）
vim.keymap.set("n", "<C-/>", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or dir == "." then
    dir = vim.fn.getcwd()
  end
  -- 先切换到目标目录，再打开新终端
  vim.cmd("lcd " .. vim.fn.fnameescape(dir))
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (Current Dir)" })

-- 在终端模式下用 Ctrl+/ 关闭终端
vim.keymap.set("t", "<C-/>", "<C-\\><C-n>:bd!<CR>", { desc = "Close Terminal" })
