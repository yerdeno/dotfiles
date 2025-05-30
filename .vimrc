" Установка плагинов
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Кодировка UTF-8
set encoding=utf8

" Отключение совместимости с vi. Нужно для правильной работы некоторых опций
set nocompatible

" Включаем поддержку 24-битных цветов
set termguicolors

" Игнорировать регистр при поиске
set ignorecase

" Не игнорировать регистр, если в паттерне есть большие буквы
set smartcase

" Подсвечивать найденный паттерн
set hlsearch

" Интерактивный поиск
set incsearch
set cursorline
set cursorlineopt=line
highlight CursorLine cterm=underline ctermbg=NONE guibg=NONE gui=underline

" Размер табов - 2
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Превратить табы в пробелы
set expandtab

" Таб перед строкой будет вставлять количество пробелов определённое в shiftwidth
set smarttab

" Копировать отступ на новой строке
set autoindent
set smartindent

" Показывать номера строк
" set number

" Автокомплиты в командной строке
set wildmode=longest,list

" Подсветка синтаксиса
syntax on

" Разрешить использование мыши
set mouse=a

" Использовать системный буфер обмена
set clipboard=unnamedplus

" Быстрый скроллинг
set ttyfast

" Курсор во время скроллинга будет всегда в середине экрана
set so=30

" Встроенный плагин для распознавания отступов
filetype plugin indent on

" Сохранение истории команд
set history=1000

" Увеличение размера командной истории
set cmdheight=2

" Увеличение размера истории поиска
set history=1000

" Автоматическое обновление файла при изменении извне
set autoread

" Сохранение позиции курсора
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Уменьшить задержку при выходе из режима вставки
set timeoutlen=300

call plug#begin("~/.vim/plugged")
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Автодополнение
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Подсветка текущего слова
Plug 'RRethy/vim-illuminate'
" Автоматическое закрытие скобок
Plug 'jiangmiao/auto-pairs'
" Подсветка синтаксиса
Plug 'sheerun/vim-polyglot'
" Git интеграция
Plug 'tpope/vim-fugitive'
" Копирование в буфер через SSH
Plug 'haya14busa/vim-poweryank'
call plug#end()

" Включить/выключить NERDTree при нажатии \n
nnoremap <leader>n :NERDTreeToggle<CR>
" Юникодные иконки папок (Работает только с плагином vim-devicons)
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" Показывает количество строк в файлах
let g:NERDTreeFileLines = 1
" Игнорировать указанные папки
let g:NERDTreeIgnore = ['^node_modules$', '^__pycache__$']
" Закрыть vim, если единственная вкладка - это NERDTree
augroup NERDTreeAutoclose
  autocmd!
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup END

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_statusline_ontop=0
let g:airline_theme='deus'
let g:airline#extensions#tabline#formatter = 'default'

" Полезные маппинги
" Быстрое сохранение
nnoremap <C-s> :w<CR>

" Быстрое закрытие без сохранения
nnoremap <C-q> :q!<CR>

" Переключение между буферами
nnoremap <C-h> :bprevious<CR>
nnoremap <C-l> :bnext<CR>

" Перемещение строк вверх/вниз
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==

" Быстрый поиск и замена
nnoremap <leader>s :%s/\<<C-r><C-w>\>/

" Открытие терминала в сплите
nnoremap <leader>t :split term://bash<CR>

" Настройки poweryank
nmap <leader>y <Plug>(operator-poweryank-osc52)
vmap <leader>y <Plug>(operator-poweryank-osc52)

" Настройки CoC
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-python',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css'
  \ ]

" Автодополнение CoC
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
