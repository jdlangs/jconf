module JuliaRC

export @run, @rl, fwhos, showcache, wipecache

macro run(file)
    fstr = string(file)
    quote
        if "scripts" in readdir()
            include("scripts/" * $fstr * ".jl")
        else
            include($fstr * ".jl")
        end
    end
end

#Reload a module stored in the MOD variable
macro rl(sym...)
    if length(sym) == 0
        esc(:(reload(MOD)))
    else
        modstr = string(sym[1])
        esc(:(MOD = $modstr; reload(MOD)))
    end
end

function fwhos(m::Module, pattern::Regex; filter=[])
    filtertypes = applicable(start, filter) ?
        filter : [filter]
    for ft in filtertypes
        isa(ft, DataType) ||
        throw(ArgumentError("Non-type object given to filter keyword"))
    end
    filtertest(var) = ! any(T -> typeof(var) <: T, filtertypes)
    for n in sort(names(m))
        s = string(n)
        v = eval(m,n)
        if isdefined(m,n) && ismatch(pattern, s) && filtertest(v)
            println(rpad(s, 30), summary(v))
        end
    end
end
fwhos(;filter=Module) = fwhos(r""; filter=filter)
fwhos(m::Module; filter=[]) = fwhos(m, r""; filter=filter)
fwhos(pat::Regex; filter=Module) = fwhos(current_module(), pat; filter=filter)


function cachepath()
    idx = findfirst(x->ismatch(r"/home/.*/\.julia",x), Base.LOAD_CACHE_PATH)
    Base.LOAD_CACHE_PATH[idx]
end
showcache() = readdir(cachepath())

function wipecache()
    cpath = cachepath()
    for file in readdir(cpath)
        endswith(file, ".ji") && run(`rm $(joinpath(cpath,file))`)
    end
end

end

#Allow loading from global projects directory
push!(LOAD_PATH, joinpath(homedir(), "Documents", "Projects"))

#Allow for local module loading without include
isdir("src") && push!(LOAD_PATH, joinpath(pwd(), "src"))

using .JuliaRC
