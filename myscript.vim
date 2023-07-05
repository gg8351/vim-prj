function! Cursor()
" Добавяме '-' към символите на 'iskeyword', за да може expand('<cword>') да връща class/id със тирета. След това премахаваме този символ от 'iskeyword', за да може команди като 'w' 'e' и др. да работят както преди. 
" !!! (Необходима е проверка за това дали '-' не е бил 'iskeyword' символ преди да го добавяме/премахваме.)
  set iskeyword+=-
  let selector = expand('<cword>')
  if search('\zs\%(id\|class\)\ze="\(\k+ \)*\k*\%#\k*"') < 0
    return
  endif
  let selector_type = expand('<cword>')
  echo selector. ' ' . selector_type
  set iskeyword-=-
endfunction

nnoremap <F5> :call Cursor()<CR>
