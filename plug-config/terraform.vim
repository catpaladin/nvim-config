"Terraform Language Server
if executable('terraform-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'terraform-lsp',
        \ 'cmd': {server_info->['terraform-lsp', 'serve']},
        \ 'whitelist': ['terraform'],
        \ })
endif

let g:terraform_fmt_on_save=1
let g:terraform_align=1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 0

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 0
