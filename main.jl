using LinearAlgebra, Images, Term.Progress

# abstract type for something a ray can hit
abstract type AbstractHittable end

# holds info on whether something hittable has been hit
struct HitRecord{T<:AbstractFloat}
    point::Vector{T} # location of hit
    normal::Vector{T} # normal vector to hittable object at `point` - always point out from object
    t::T # distance along ray to hit
end

struct Ray{T<:AbstractFloat}
    origin::Vector{T}
    direction::Vector{T}
end

# coordinates of a point `t` along ray
point(r::Ray, t) = r.origin + r.direction * t

struct Sphere{T<:AbstractFloat} <: AbstractHittable
    origin::Vector{T}
    radius::T
end

# location of intersection with ray
function hit(sphere::Sphere, r::Ray, tmin, tmax)
    # solve intersection equation
    ac = r.origin - sphere.origin
    a = r.direction ⋅ r.direction
    halfb = r.direction ⋅ ac
    c = ac ⋅ ac - sphere.radius^2
    discriminant = halfb^2 - a * c

    # return if no hit
    discriminant < 0 && return false

    # check if hit in bounds
    t = (-halfb - √discriminant) / a
    !(tmin ≤ t ≤ tmax) && return false

    # return HitRecord otherwise
    p = point(r, t)
    normal = normalize(p - sphere.origin)
    t = t

    return HitRecord(p, normal, t)
end

# check hit in vector of hittables
function hit(objs::Vector{T}, r::Ray, tmin, tmax) where {T<:AbstractHittable}
    rec = 0.0
    closest_so_far = tmax # will take smallest value along ray
    hit_anything = false

    # loop through hittable objects and return HitRecord for closest object
    for obj in objs
        temp_rec = hit(obj, r, tmin, closest_so_far)
        if temp_rec != false && temp_rec.t < closest_so_far
            closest_so_far = temp_rec.t
            rec = temp_rec
            hit_anything = true
        end
    end

    return hit_anything ? rec : false
end


# determine colour of ray 
function ray_colour(objs::Vector{T}, r::Ray) where {T<:AbstractHittable}
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

function main()
    # image
    aspect_ratio = 16 / 9
    image_width = 400
    image_height = floor(Int, image_width / aspect_ratio)
    output = Matrix{RGB}(undef, image_height, image_width)

    # camera - defines properties of the camera in "real world" coordinates
    # viewport is the space the camera can "see"
    viewport_height = 2.0
    viewport_width = aspect_ratio * viewport_height
    focal_length = 1.0 # distance from camera origin to viewport plane
    origin = [0.0, 0.0, 0.0]
    viewport_origin = origin - [viewport_width / 2, 0, 0] - [0, viewport_height / 2, 0] - [0, 0, focal_length] # lower left corner

    # world
    sphere1 = Sphere([0.0, 0.0, -1.0], 0.5)
    sphere2 = Sphere([0.0, -100.5, -1.0], 100.0)
    world = [sphere1, sphere2]

    # render
    @track for i in 1:image_width
        for j in 1:image_height
            # relative position of pixel in image
            u = (i - 1) / (image_width - 1)
            v = (j - 1) / (image_height - 1)

            # ray from camera origin to point in world coordinates
            p = viewport_origin + u * [viewport_width, 0, 0] + v * [0, viewport_height, 0] # location in real world 
            d = p - origin # vector pointing from origin to point
            r = Ray(origin, d)

            # determine colour of ray
            c = ray_colour(world, r)

            # reverse index to plot in same direction
            jj = reverse(1:image_height)[j]
            output[jj, i] = c
        end
    end

    return output
end

main()