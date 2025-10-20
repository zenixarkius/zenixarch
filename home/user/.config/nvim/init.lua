-- ========== LAZY SETUP ==========

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ========== OPTIONS ==========

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- ========== PLUGINS ==========

require("lazy").setup({
    spec = {
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            dependencies = "nvim-tree/nvim-web-devicons",
            config = function()
                require("nvim-tree").setup {}
            end,
        },
        {
            "akinsho/bufferline.nvim",
            version = "*",
            dependencies = "nvim-tree/nvim-web-devicons",
            config = function()
                require("bufferline").setup {}
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            version = "*",
            dependencies = "nvim-tree/nvim-web-devicons",
            config = function()
                require('lualine').setup { options = { globalstatus = true } }
            end,
        },
    },
    install = { colorscheme = { "default" } },
})
