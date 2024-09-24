using Pkg
Pkg.activate(".")

ver = ["v0.5.3", #1
    "v0.5.2", #2
    "v0.5.1", #3
    "v0.5.0", #4
    "v0.4.53", #5
    "v0.4.52", #6
    "v0.4.51" #7
]

pkg_ver = ver[6]

println("Using JLD2 ver $pkg_ver")

Pkg.add(PackageSpec(
    name="JLD2"
    ,rev= pkg_ver
))

Pkg.status("JLD2")
using JLD2
# using DataFrames

function create_large_dict(levels::Int, items_per_level::Int, item_size::Int)
    # Create a nested dictionary with the specified number of levels
    function create_nested_dict(current_level, max_level)
        if current_level > max_level
            return Dict(random_string(5) => rand(Int, item_size))
        else
            return Dict(
                random_string(5) => create_nested_dict(current_level + 1, max_level)
                for _ in 1:items_per_level
            )
        end
    end

    # Create the top-level dictionary
    return create_nested_dict(1, levels)
end

function random_string(length::Int)
    return join(rand('a':'z', length))
end

pth_sml = "random_dict_sml.jld2"
pth = "random_dict_large.jld2"

# Works
obj_small = create_large_dict(3, 5, 6)
jldsave(pth_sml; obj_small)
io = jldopen(pth_sml)
res_small = io["obj_small"]
close(io)

#Breaks
obj = create_large_dict(3, 30, 6)
jldsave(pth; obj)
io = jldopen(pth)
res = io["obj"]
close(io)

