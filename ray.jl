struct Ray{T<:AbstractFloat}
    origin::Vector{T}
    direction::Vector{T}
end

# coordinates of a point `t` along ray
point(r::Ray, t) = r.origin + r.direction * t

# determine colour of ray 
function ray_colour(objs::Vector, r::Ray) #where {T<:AbstractHittable}
    # check if ray hits anything
    rec = hit(objs, r, 0.0, Inf)

    # return shaded if hit
    return if rec != false
        RGB(0.5(rec.normal + [1, 1, 1])...)
    else # otherwise colour background normally
        _t = 0.5(normalize(r.direction)[2] + 1)
        RGB((1 - _t) * [1, 1, 1] + _t * [0.5, 0.7, 1.0]...)
    end
end
