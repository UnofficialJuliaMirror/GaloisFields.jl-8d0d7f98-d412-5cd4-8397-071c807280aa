
show(io::IO, a::PrimeField) = show(io, a.n)

function show(io::IO, a::AbstractExtensionField)
    show(io, Poly(collect(expansion(a)), genname(typeof(a))))
end

"""
    defaultshow(io, t)

Overloading display of types can be a bit hairy; I've seen a declaration
like

    show(..., ::Type{<:Val{B}}) where B

being called for non-concrete types. (I haven't dug deep enough to find
a nice minimal example.)

That's why all `show` overloads for types do

    !isconcretetype(t) && return defaultshow(io, t)
"""
function defaultshow(io, t)
    if t isa DataType
        invoke(show, Tuple{IO, DataType}, io, t)
    elseif t isa UnionAll
        invoke(show, Tuple{IO, UnionAll}, io, t)
    else
        print(io, "<undisplayable>")
    end
end

function show(io::IO, t::Type{PrimeField{I,p}}) where {I,p}
    !isconcretetype(t) && return defaultshow(io, t)

    number = replace("$p", r"[0-9]" => x->['₀','₁','₂','₃','₄','₅','₆','₇','₈','₉'][parse(Int,x) + 1])
    write(io, "𝔽$number")
end


function show(io::IO, F::Type{<:AbstractExtensionField})
    !isconcretetype(F) && return defaultshow(io, F)

    q = BigInt(char(F)) ^ n(F)
    number = replace("$q", r"[0-9]" => x->['₀','₁','₂','₃','₄','₅','₆','₇','₈','₉'][parse(Int,x) + 1])
    write(io, "𝔽$number")
end
