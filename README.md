# kakoune-cscope

Cscope integration for Kakoune. Beta. MIT-licensed.

Supported Kakoune version: v2018.10.27

## How to use

Put the main file into your [autoload directory](
https://github.com/mawww/kakoune/blob/master/README.asciidoc#configuration-autoloading
).

Build an index: `:cscope-index`

Make a lookup: `:cscope`

Fuzzy-find a function: `:cscope-find`

Optional mapping: `map -docstring 'cscope menu' global user 'c' '<a-i>w:cscope-menu<ret>'
