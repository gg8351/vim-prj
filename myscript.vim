function! Cursor()
  echo expand('<cword>')
endfunction

nnoremap <F5> :call Cursor()<CR>
