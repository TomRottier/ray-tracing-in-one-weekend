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
    depth ≤ 0 && returnRGB(0, 0, 0)

    # return shaded if hit
    return if rec != false
        # random point inside unit sphere centred at normal of hit point
        rand_point = rec.point + rec.normal + random_unit_sphere()

        # ray from hit point to random point
        rand_ray = Ray(rec.point, rand_point - rec.point)

        # colour based on new ray
        c = 0.5ray_colour(objs, rand_ray, depth - 1)
        # RGB(0.5(rec.normal + [1, 1, 1])...)

    else # otherwise colour background normally
        _t = 0.5(normalize(r.direction)[2] + 1)
        RGB((1 - _t) * [1, 1, 1] + _t * [0.5, 0.7, 1.0]...)
    end
end
