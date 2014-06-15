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
let g:DoxygenToolkit_authorName="Mark Zumbruch" 
let g:DoxygenToolkit_licenseTag="Enter License Here"

map <leader>do :Dox<cr>
map <leader>dl :DoxLic<cr>
