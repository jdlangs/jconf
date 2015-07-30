#Helping macros
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
        :(reload(MOD))
    else
        esc(:(MOD = $(Expr(:quote, sym[1])); reload(MOD)))
    end
end

module FilterWhos

export fwhos

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

end

using FilterWhos
