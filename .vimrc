set encoding=utf-8
scriptencoding utf-8
filetype on

" vim公式のplugin
call plug#begin('~/.vim/plugged')
Plug 'ryanoasis/vim-devicons'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'ueokande/popupdict.vim'
call plug#end()

" vim prettier設定
" @formatアノテーションを持ったファイルの自動フォーマットを無効にする
let g:prettier#autoformat = 0
" Prettierのパースエラーをquickfixに表示しない
let g:prettier#quickfix_enabled = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" TypeScriptのエラーチェックなどを送るサーバー
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
    s:find_nearest_tsconfig_directory
        \ 'whitelist': ['typescript'],
        \ })
endif

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

" for asyncomplete.vim log
let g:asyncomplete_log_file = expand('~/asyncomplete.log')

" neobundle settings {{{
if has('vim_starting')
    set nocompatible
    " neobundle をインストールしていない場合は自動インストール
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install neobundle..."
        " vim からコマンド呼び出しているだけ neobundle.vim のクローン
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
    " runtimepath の追加は必須
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
" color theme solarized
" NeoBundle 'altercation/vim-colors-solarized'
" paste時にインデント崩れるのを防ぐ
NeoBundle 'ConradIrwin/vim-bracketed-paste'
" fzf
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
NeoBundle 'junegunn/fzf.vim', { 'depends': 'fzf' }
" gitが見やすい tig
NeoBundle 'iberianpig/tig-explorer.vim'
" gitのdiffなどが見やすい
NeoBundle 'tpope/vim-fugitive'
" ファイルツリー
NeoBundle 'scrooloose/nerdtree'
" コメントアウト機能
NeoBundle 'scrooloose/nerdcommenter'
" nerdtreeでのgitの状態表示
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Xuyuanp/nerdtree-git-plugin'
" uniteなどの高速化（installできない）
" NeoBundle 'Shougo/vimproc.vim', {
" \ 'build' : {
" \     'windows' : 'tools\\update-dll-mingw',
" \     'cygwin' : 'make -f make_cygwin.mak',
" \     'mac' : 'make',
" \     'linux' : 'make',
" \     'unix' : 'gmake',
" \    },
" \ }
" NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'Quramy/tsuquyomi'
" 補完
if has('lua')
  " コードの自動補完
  NeoBundle 'Shougo/neocomplete.vim'
  " NeoBundle 'Shougo/neocomplcache.vim'
  " スニペットの補完機能
  NeoBundle "Shougo/neosnippet"
  " スニペット集
  NeoBundle 'Shougo/neosnippet-snippets'
endif
" lint系ツール
NeoBundle 'w0rp/ale'
" 自動カッコ閉じ
NeoBundle 'Townk/vim-autoclose'
" 自動カッコ閉じ
NeoBundle 'osyo-manga/vim-over'
" ctrlpでgitignoreを無視する
" gitの表示をしてくれる
NeoBundle 'airblade/vim-gitgutter'
" gxでgoogle検索ができる
NeoBundle 'tyru/open-browser.vim'

" 言語系 {{{
" オールラウンダー(他の言語系のものがいらない可能性あり)
" NeoBundle 'sheerun/vim-polyglot'
" firestoreのセキュリティルール
NeoBundle 'delphinus/vim-firestore'
" vueのeslintを効かせる
NeoBundle 'posva/vim-vue'

" vueファイルをhtmlに
" autocmd BufNewFile,BufRead *.{html,htm,vue*} set filetype=html
" TSファイルでのESエラー回避
let g:syntastic_typescript_tsc_args = "--experimentalDecorators --target ES5"
" }}}

" nerdtree {{{
" nmap <silent><C-n> :NERDTreeToggle<CR>

" 現在開いているファイルpathでnerdtreeを開く
function! NerdTreeToggleFind()
    if exists("g:NERDTree") && g:NERDTree.IsOpen()
        NERDTreeClose
    elseif filereadable(expand('%'))
        NERDTreeFind
    else
        NERDTree
    endif
endfunction

nnoremap <C-n> :call NerdTreeToggleFind()<CR>
" }}}

" ale {{{
let g:ale_sign_column_always = 1
let g:ale_linters = {
      \ 'html': [],
      \ 'css': ['stylelint'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'vue': ['eslint']
      \ }
let g:ale_linter_aliases = {'vue': 'css'}
let g:ale_fixers = {
        \ 'vue': ['eslint'],
	\ 'python': ['autopep8', 'isort'],
	\ }
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_statusline_format = ['E%d', 'W%d', '']
" }}}

" 置換すぐに出す
nnoremap <S-s> :OverCommandLine<CR>%s/

" tig 設定 {{{
nnoremap <silent> gs :TigOpenCurrentFile<CR>
" }}}

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! MyGF call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --cached --others'}))

" fzfでの全検索とファイル検索 {{{
nnoremap <S-f> :GGrep<Space>
nnoremap <C-p> :MyGF<CR>
nnoremap <C-h> :History<CR>
let g:fzf_layout = { 'up': '40%' }
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), <bang>0)
" }}}



" NERDCommenter vue の設定 {{{
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction
" }}}

" tsuquyomi設定
" 保存時止まるのをなくすために、型チェックをoff
let g:tsuquyomi_disable_quickfix = 1
nnoremap <silent> <C-i> :TsuImport<CR>
" preview非表示
autocmd FileType typescript setlocal completeopt-=preview
" tooltipの設定
set ballooneval
autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>
" rename
autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)

" popup dictionary
function ToggleDict()
    if g:popupdict_enabled == 0
        g:popupdict_enabled = 1
    else
        g:popupdict_enabled = 0
    endif
endfunction
nmap <Leader>d ToggleDict()

" airblade/vim-gitgutterの設定 {{{
set updatetime=250
" highlight GitGutterAdd ctermfg=lightgreen
" highlight GitGutterChangeLine ctermfg=darkblue
" highlight GitGutterDeleteLine ctermfg=lightred
" }}}

" open-browser.vim {{{
" 1. Vim でファイルを開いて、ノーマルモードで URL 文字列にカーソルを置く。
" 2. ノーマルモードで ‘gx’ とタイプすると URL がブラウザで開かれる。
" 3. URL ではない文字列にカーソルを置いて ‘gx’ と打つと、検索エンジンでカーソル上の文字列を検索した結果が表示される。
" 4. 上手く開けない場合は、URL や検索したい文字列をビジュアルモードで選択後に ‘gx’ と打つ。
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-search)
vmap gx <Plug>(openbrowser-search)
"}}}

" neocomplete {{{
" Vim起動時にneocompleteを有効にする
let g:neocomplete#enable_at_startup = 1
" smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplete#enable_smart_case = 1
" 3文字以上の単語に対して補完を有効にする
let g:neocomplete#min_keyword_length = 3
" 区切り文字まで補完する
let g:neocomplete#enable_auto_delimiter = 1
" 1文字目の入力から補完のポップアップを表示
let g:neocomplete#auto_completion_start_length = 1
" バックスペースで補完のポップアップを閉じる
inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

" エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
" タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"

" neocompleteにominiの候補を表示する
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::'

" 最初の補完候補を選択状態にする
set completeopt+=noinsert
" " }}}

" NERD Commenter でコメント後に空白を空ける
let g:NERDSpaceDelims=1

" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double "□や○文字が崩れる問題を解決

set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの位置を表示する

set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop< " 画面上でタブ文字が占める幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set shiftwidth=2 " smartindentで増減する幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ts          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType typescript  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sass        setlocal sw=2 sts=2 ts=2 et
endif

set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

set number " 行番号を表示

" パフォーマンスを上げる
set nocursorline "これをオンにするとjkでの移動でCPUがかなり食われるので明示的に避ける
set synmaxcol=200 "ハイライトの範囲を指定

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nmap j gj
nmap k gk
nmap <down> gj
nmap <up> gk

nmap O :<C-u>call append(expand('.'), '')<Cr>j

" バックスペースキーの有効化
set backspace=indent,eol,start

set showmatch " 括弧の対応関係を一瞬表示する
" source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

"----------------------------------------------------------
" マウスでカーソル移動とスクロール
"----------------------------------------------------------
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" 挿入モードでクリップボードからペーストする時に自動でインデントさせないようにする
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function _XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    imap <special> <expr> <Esc>[200~ _XTermPasteBegin("")
endif

" swapファイルを作らない
set noswapfile
set nobackup
set nowrap

" 自動でコメントをつけない
au FileType * setlocal formatoptions-=ro

"vimgrep をする時に早く表示する
autocmd QuickFixCmdPost vimgrep cwindow

" クリップボードとvimを連携コピペが簡単になる
set clipboard+=unnamed

" ショートカットキー
" leaderをspaceに割り当てる
let mapleader = "\<Space>"
nmap / /\v
nmap f *
" nnoremap x "_x
noremap <S-h>   ^
noremap <S-j>   L
noremap <S-k>   H
nnoremap <S-l>   $
vnoremap <S-l>   $h
map m  %
nmap ; :
nmap <C-k> <Plug>NERDCommenterToggle
vmap <C-k> <Plug>NERDCommenterToggle
map! <C-V> <C-r>0

" omni補完呼び出し
imap <C-o> <C-x><C-o>

set syntax=enable
" 背景がgrayになってしまう対応
let g:solarized_termtrans = 1
colorscheme solarized
set background=dark
" 行を強調表示
set cursorline

set guifont=Cica:h16
set printfont=Cica:h12

" サイズ調整
nnoremap <silent> s+ <C-w>+
nnoremap <silent> s- <C-w>-

" 下に新しいタブを作成
set splitbelow

"termianlサイズ
set termwinsize=12x0


" iconカラー定義のための準備
" g:sol定義
let g:sol = {
      \"gui": {
      \"base03": "#002b36",
      \"base02": "#073642",
      \"base01": "#586e75",
      \"base00": "#657b83",
      \"base0": "#839496",
      \"base1": "#93a1a1",
      \"base2": "#eee8d5",
      \"base3": "#fdf6e3",
      \"yellow": "#b58900",
      \"orange": "#cb4b16",
      \"red": "#dc322f",
      \"magenta": "#d33682",
      \"violet": "#6c71c4",
      \"blue": "#268bd2",
      \"cyan": "#2aa198",
      \"green": "#719e07"
      \},
      \"cterm": {
      \"base03": 8,
      \"base02": 0,
      \"base01": 10,
      \"base00": 11,
      \"base0": 12,
      \"base1": 14,
      \"base2": 7,
      \"base3": 15,
      \"yellow": 3,
      \"orange": 9,
      \"red": 1,
      \"magenta": 5,
      \"violet": 13,
      \"blue": 4,
      \"cyan": 6,
      \"green": 2
      \}
      \}

" vueのicon追加
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = ''


" iconカラー
function! DeviconsColors(config)
  let colors = keys(a:config)
  augroup devicons_colors
    autocmd!
    for color in colors
      if color == 'normal'
        exec 'autocmd FileType nerdtree,startify if &background == ''dark'' | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base01.' ctermfg='.g:sol.cterm.base01.' | '.
              \ 'else | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base1.' ctermfg='.g:sol.cterm.base1.' | '.
              \ 'endif'
      elseif color == 'emphasize'
        exec 'autocmd FileType nerdtree,startify if &background == ''dark'' | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base1.' ctermfg='.g:sol.cterm.base1.' | '.
              \ 'else | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base01.' ctermfg='.g:sol.cterm.base01.' | '.
              \ 'endif'
      else
        exec 'autocmd FileType nerdtree,startify highlight devicons_'.color.' guifg='.g:sol.gui[color].' ctermfg='.g:sol.cterm[color]
      endif
      exec 'autocmd FileType nerdtree,startify syntax match devicons_'.color.' /\v'.join(a:config[color], '|').'/ containedin=ALL'
    endfor
  augroup END
endfunction
let g:devicons_colors = {
      \'normal': ['', '', '', '', ''],
      \'emphasize': ['', '', '', '', '', '', '', '', '', ''],
      \'yellow': ['', '', '', ''],
      \'orange': ['', '', '', 'λ', '', ''],
      \'red': ['', '', '', '', '', '', '', '', '', ''],
      \'magenta': [''],
      \'violet': ['', '', '', ''],
      \'blue': ['', '', '', '', '', '', '', '', '', '', '', '', ''],
      \'cyan': ['', '', '', ''],
      \'green': ['', '', '', '', '']
      \}
call DeviconsColors(g:devicons_colors)

" propetyなどで型などを詳細に表示できる
let g:tsuquyomi_completion_detail = 1

" <C-w> 系を Vim Tmux Navigator に移譲する
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <C-w>\\ :TmuxNavigatePrevious<cr>

" Powerline
" Powerline系フォントを利用する
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'tomorrow'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
