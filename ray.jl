struct Ray{T<:AbstractFloat}
    origin::Vector{T}
    direction::Vector{T}
end

# coordinates of a point `t` along ray
point(r::Ray, t) = r.origin + r.direction * t

# determine colour of ray 
function ray_colour(objs::Vector, r::Ray, depth) #where {T<:AbstractHittable}
    # check if ray hits anything
    rec = hit(objs, r, 0.001, Inf)

    # return black if depth limit reached
    depth ≤ 0 && return (0, 0, 0)

    # return shaded if hit
    return if rec != false
        # scatter ray
        attenuation, scattered_ray = scatter(rec.object, r, rec)

        if scattered_ray isa Ray
            # colour based on new ray
            (attenuation .* ray_colour(objs, scattered_ray, depth - 1))
        else
            (0.0, 0.0, 0.0)
        end

    else # otherwise colour background normally
        _t = 0.5(normalize(r.direction)[2] + 1)
        ((1 - _t) * [1, 1, 1] + _t * [0.5, 0.7, 1.0])
    end
end
