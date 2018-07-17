# kakoune-cscope

Cscope integration for Kakoune. Beta. MIT-licensed.

## How to use

Put the main file into your [autoload directory](
https://github.com/mawww/kakoune/blob/master/README.asciidoc#configuration-autoloading
).

Build an index: `:cscope-index`

Make a lookup: `:cscope`

Fuzzy-find a function: `:cscope-find`

## Optional bindings

```
map -docstring 'Find this C symbol'                     global user 's' '<a-i>w:cscope 0 <c-r>.<ret>'
map -docstring 'Find this function definition'          global user 'g' '<a-i>w:cscope 1 <c-r>.<ret>'
map -docstring 'Find functions called by this function' global user 'd' '<a-i>w:cscope 2 <c-r>.<ret>'
map -docstring 'Find functions calling this function'   global user 'c' '<a-i>w:cscope 3 <c-r>.<ret>'
map -docstring 'Find this text string'                  global user 't' '<a-i>w:cscope 4 <c-r>.<ret>'
map -docstring 'Find this egrep pattern'                global user 'e' '<a-i>w:cscope 6 <c-r>.<ret>'
map -docstring 'Find this file'                         global user 'f' '<a-i>w:cscope 7 <c-r>.<ret>'
map -docstring 'Find files #including this file'        global user 'i' '<a-i>w:cscope 8 <c-r>.<ret>'
map -docstring 'Find assignments to this symbol'        global user 'a' '<a-i>w:cscope 9 <c-r>.<ret>'
```
