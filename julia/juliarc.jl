#Helping macros
macro run(file)
    if "scripts" in readdir()
        include("scripts/" * string(file) * ".jl")
    else
        include(string(file) * ".jl")
    end
end
