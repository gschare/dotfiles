vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd("source ~/.vimrc")

local function new_note()
  -- Create a new file and open it in a buffer
  local filename = os.date("%y.%m.%d-%H.%M.md")
  vim.cmd("edit " .. filename)

  -- Insert "hello world" at the top of the file
  local timestamp = os.date("%Y-%m-%d %H:%M %Z")
  vim.api.nvim_buf_set_lines(0, 0, 0, false,
    {"<meta time=\"" .. timestamp .. "\" tag=\"note nectry\">"})

  -- Optionally save the file
  -- vim.cmd("write")
end

_G.new_note = new_note

vim.api.nvim_set_keymap('n', '<leader>oN', ':lua new_note()<CR>', { noremap = true, silent = true })

local function copy_file_name()
    vim.fn.setreg('"', vim.fn.expand('%:t'))
end
_G.copy_file_name = copy_file_name

vim.api.nvim_set_keymap('n', '<leader>yn', ':lua copy_file_name()<CR>', { noremap = true, silent = true })
