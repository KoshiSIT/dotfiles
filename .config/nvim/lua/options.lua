-- 基本設定
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- クリップボードの設定
vim.opt.clipboard = "unnamedplus"

-- *での検索時にカーソルを移動しない
vim.api.nvim_set_keymap('n', '*', '*N', { noremap = true })

-- ファイル名の大文字小文字を区別
vim.opt.fileignorecase = false

-- 外観設定
vim.cmd([[
    highlight Normal guibg=none
    highlight NonText guibg=none
]]) -- 追加の括弧で囲む


-- タブラインとステータスラインの設定
vim.opt.laststatus = 3    -- グローバルステータスライン
vim.opt.showtabline = 2   -- タブラインを常に表示

-- barbar.nvimの設定
vim.g.barbar_auto_setup = false

-- タブラインの装飾設定
vim.cmd([[
    hi TabLineFill guibg=#2a2a2a
    hi TabLine guibg=#2a2a2a
    hi TabLineSel guibg=#3a3a3a gui=bold

    " タブライン上部の境界線
    hi TabLineTop gui=underline guifg=#3b3b3b
    
    " カスタムタブライン
    function! CustomTabLine()
        let s = '━' . repeat('━', winwidth(0))
        return s
    endfunction
    
    set tabline=%!CustomTabLine()
]])

-- 境界線とウィンドウの設定
vim.opt.fillchars = {
    stl = '━',      -- アクティブウィンドウのステータスライン
    stlnc = '━',    -- 非アクティブウィンドウのステータスライン
    vert = '┃',     -- 垂直分割線
    horiz = '━',    -- 水平分割線
    horizup = '┻',  
    horizdown = '┳',
    vertleft = '┫', 
    vertright = '┣',
    verthoriz = '╋',
    fold = '·',
    foldsep = '┃',
    foldclose = '›',
    foldopen = '⌄'
}

-- パディングの追加
vim.opt.linespace = 1     -- 行間のスペース


vim.opt.cursorline = true
