function! HtmlToCss()
  let filename = bufname("%")
  let correct_file = match(filename, ".html")
  if correct_file < 0
    echo "The file you've opened is not CSS file."
    return
  endif
  let saved_view = winsaveview()
  defer winrestview(saved_view)

  " Добавяме - към 'iskeyword' за да намиираме класове/ид които съдържат - със <cword>
  set iskeyword+=-
  let selector = expand('<cword>')
  if search('\zs\%(id\|class\)\ze="\(\k\+ \)*\k*\%#\k*\( \k\+\)*"') < 0
    return
  endif
  let selector_type = expand('<cword>')
  set iskeyword-=-
  if selector_type == 'id'
    exe 'vimgrep /^#'.selector.' {/j **/*.css'
  elseif selector_type == 'class'
    exe 'vimgrep /^\.'.selector.' {/j **/*.css'
  else
    return
  endif

  let matches = getqflist()->mapnew({ i, entry -> [bufname(entry.bufnr), entry.text] })
  let texts = matches->mapnew({ i, match -> $"{i + 1} {match[1]} (in file: {match[0]})" })
  let files = matches->mapnew({ _, match -> match[0] })

  let choices = extend(["Pick one"], texts)
  let choice_index = inputlist(choices) - 1
  if choice_index == -1
    return
  elseif
  exe 'vertical split '.files[choice_index]
endfunction

function! CssToHtml()
  let filename = bufname("%")
  let correct_file = match(filename, ".css")
  if correct_file < 0
    echo "The file you've opened is not CSS file."
    return
  endif
  let saved_view = winsaveview()
  defer winrestview(saved_view)

  " Добавяме - към 'iskeyword' за да намиираме класове/ид които съдържат - със <cword>
  set iskeyword+=.
  set iskeyword+=#
  set iskeyword+=-
  let word = expand('<cword>')
  let selector = word[1:]
  let selector_type = word[0]
  set iskeyword-=.
  set iskeyword-=#
  set iskeyword-=-

  if selector_type == '#'
    exe 'vimgrep /id="\(.\+ \)*'.selector.'\( .\+\)*/" **/*.html'
  elseif selector_type == '.'
    exe 'vimgrep /class="\(.\+ \)*'.selector.'\( .\+\)*/" **/*.html'
  else
    return
  endif

  let matches = getqflist()->mapnew({ i, entry -> [bufname(entry.bufnr), entry.text] })
  let texts = matches->mapnew({ i, match -> $"{i + 1} {match[1]} (in file: {match[0]})" })
  let files = matches->mapnew({ _, match -> match[0] })

  let choices = extend(["Pick one"], texts)
  let choice_index = inputlist(choices) - 1
  if choice_index == -1
    exe 'edit '.filename
    return
  elseif
  exe 'vertical split '.files[choice_index]
  endif
endfunction

nnoremap <F5> :call HtmlToCss()<CR>
nnoremap <F6> :call CssToHtml()<CR>
