" Cài đặt font chữ
GuiFont! JetBrainsMono NFM ExtraBold:h16

" Tắt GUI tabline (để dùng plugin khác như bufferline.nvim)
GuiTabline 0

" Tắt GUI popupmenu (để dùng nvim-cmp hoặc các plugin gợi ý khác)
GuiPopupmenu 0

" Tắt GUI scrollbar vì không cần thiết
GuiScrollBar 0

" Tắt chuông báo lỗi GUI
GuiRenderLigatures 1

" Bật chế độ toàn màn hình khi khởi động
"call GuiWindowMaximized(1)

" Điều chỉnh độ trong suốt
GuiWindowOpacity 0.92

" Cấu hình màu nền và độ trong suốt (màu xám xanh nhẹ nhàng)
autocmd ColorScheme * highlight Normal guibg=#1a1b26 guifg=#a9b1d6
autocmd ColorScheme * highlight NonText guibg=#1a1b26
autocmd ColorScheme * highlight LineNr guibg=#1a1b26
autocmd ColorScheme * highlight Folded guibg=#1a1b26
autocmd ColorScheme * highlight EndOfBuffer guibg=#1a1b26
autocmd ColorScheme * highlight SignColumn guibg=#1a1b26
autocmd ColorScheme * highlight VertSplit guibg=#1a1b26
autocmd ColorScheme * highlight StatusLine guibg=#1a1b26
autocmd ColorScheme * highlight StatusLineNC guibg=#1a1b26
autocmd ColorScheme * highlight NormalFloat guibg=#1a1b26

" Đặt alpha cho background
set winblend=15
set pumblend=15


