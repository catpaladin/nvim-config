" Error symbol
let g:lsp_signs_error = {'text': '✗'}

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap     <c-space> <Plug>(asyncomplete_force_refresh)

