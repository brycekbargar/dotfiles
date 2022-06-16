vim.opt.tabstop = 4


return function()
-- https://github.com/pearofducks/ansible-vim/blob/master/ftdetect/ansible.vim
-- TODO: Switch to native nvim ftdetect
vim.cmd([[
function! s:isAnsible()
  let filepath = expand("%:p")
  let filename = expand("%:t")
  if filepath =~ '\v/(tasks|roles|handlers|hostconfig)/.*\.ya?ml$' | return 1 | en
  if filepath =~ '\v/(group|host)_vars/' | return 1 | en
  let s:ftdetect_filename_regex = '\v(playbook|site|main|local|requirements)\.ya?ml$'
  if exists("g:ansible_ftdetect_filename_regex")
    let s:ftdetect_filename_regex = g:ansible_ftdetect_filename_regex
  endif

  if filename =~ s:ftdetect_filename_regex | return 1 | en

  let shebang = getline(1)
  if shebang =~# '^#!.*/bin/env\s\+ansible-playbook\>' | return 1 | en
  if shebang =~# '^#!.*/bin/ansible-playbook\>' | return 1 | en

  return 0
endfunction

augroup ansible_vim_ftyaml_ansible
    au!
    au BufNewFile,BufRead * if s:isAnsible() | set ft=yaml.ansible | en
augroup END
augroup ansible_vim_fthosts
    au!
    au BufNewFile,BufRead hosts set ft=ansible_hosts
	au BufRead,BufNewFile */hostconfig/*.yml set filetype=ansible_hosts
]])

end
