fish_vi_key_bindings

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
fish_user_key_bindings

set -x JULIA_SHELL /bin/bash
set -x JULIA_PKGDIR ~/Tools/julia-packages

# Fixes bad RViz scaling
set -x QT_AUTO_SCREEN_SCALE_FACTOR ""
set -x QT_SCREEN_SCALE_FACTORS ""

# Use local Qt install
set -x CMAKE_PREFIX_PATH ~/Qt/5.15.2/gcc_64/lib/cmake $CMAKE_PREFIX_PATH
set -x LD_LIBRARY_PATH ~/Qt/5.15.2/gcc_64/plugins ~/Qt/5.15.2/gcc_64/lib $LD_LIBRARY_PATH

#if type -q "bass" and test -f "~/.profile"
#bass source ~/.profile
#end
