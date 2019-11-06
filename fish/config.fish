setxkbmap -option ctrl:nocaps

fish_vi_key_bindings

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
fish_user_key_bindings

set -x JULIA_SHELL /bin/bash
set -x JULIA_PKGDIR ~/Tools/julia-packages

if type -q "bass" and test -f "~/.profile"
    bass source ~/.profile
end
