# kakoune-cscope

Cscope integration for Kakoune. Beta. Requires FZF and tmux. MIT-licensed.

## How to use

Put the main file into your [autoload directory](
https://github.com/mawww/kakoune/blob/master/README.asciidoc#configuration-autoloading
).

Optionally add this to your kakrc (inspired by [this](
http://cscope.sourceforge.net/cscope_maps.vim
)):

```
map -docstring 'cscope: find this C symbol'                     global user 's' '<a-i>w:cscope-find 0 <c-r>.<ret>'
map -docstring 'cscope: find this function definition'          global user 'g' '<a-i>w:cscope-find 1 <c-r>.<ret>'
map -docstring 'cscope: find functions called by this function' global user 'd' '<a-i>w:cscope-find 2 <c-r>.<ret>'
map -docstring 'cscope: find functions calling this function'   global user 'c' '<a-i>w:cscope-find 3 <c-r>.<ret>'
map -docstring 'cscope: find this text string'                  global user 't' '<a-i>w:cscope-find 4 <c-r>.<ret>'
map -docstring 'cscope: find this egrep pattern'                global user 'e' '<a-i>w:cscope-find 6 <c-r>.<ret>'
map -docstring 'cscope: find this file'                         global user 'f' '<a-i>w:cscope-find 7 <c-r>.<ret>'
map -docstring 'cscope: find files #including this file'        global user 'i' '<a-i>w:cscope-find 8 <c-r>.<ret>'
map -docstring 'cscope: find assignments to this symbol'        global user 'a' '<a-i>w:cscope-find 9 <c-r>.<ret>'
```

## TODO

- colored output
- non-FZF version
