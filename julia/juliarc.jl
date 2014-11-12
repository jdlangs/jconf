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
