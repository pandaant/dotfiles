" bufexplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>

" ctrlp
set wildignore+=/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|svn)'
            \   }

" ctrlp + ctags
nnoremap <leader>. :CtrlPTag<cr>

" NERDTree
map <leader>nn :NERDTreeToggle<cr>

"ctags list
map <leader>tl :TlistToggle<cr>

" DoxygenToolkit
let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_briefTag_pre="@brief   " 
let g:DoxygenToolkit_paramTag_pre="@param " 
let g:DoxygenToolkit_returnTag   ="@return " 
let g:DoxygenToolkit_blockHeader="----------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------"
let g:DoxygenToolkit_licenseTag="Enter License Here"

map <leader>do :Dox<cr>
map <leader>dl :DoxLic<cr>

" vimshell
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt =  '$ '

map <leader>vs :VimShellPop<cr>

"neocomplcache
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

"emmet config
let g:user_emmet_settings = {
            \  'indentation' : '  ',
            \  'perl' : {
            \    'aliases' : {
            \      'req' : 'require '
            \    },
            \    'snippets' : {
            \      'use' : "use strict\nuse warnings\n\n",
            \      'warn' : "warn \"|\";",
            \    }
            \  }
            \}

let g:user_emmet_expandabbr_key = '<c-e>'
let g:use_emmet_complete_tag = 1
