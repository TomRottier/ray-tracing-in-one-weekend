# abstract type for something a ray can hit
abstract type AbstractHittable end

# holds info on whether something hittable has been hit
struct HitRecord{T<:AbstractFloat}
    point::Vector{T} # location of hit
    normal::Vector{T} # normal vector to hittable object at `point` - always point out from object
    t::T # distance along ray to hit
    front_face::Bool # is hit on outside (true) or inside of object
    object::AbstractHittable # the object the ray has hit
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

#### hittable objects ####
struct Sphere{T<:AbstractFloat,M<:AbstractMaterial} <: AbstractHittable
    origin::Vector{T}
    radius::T
    material::M
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
    # !(tmin ≤ t ≤ tmax) && return false
    if t < tmin || tmax < t
        t = (-halfb + √discriminant) / a
        if t < tmin || tmax < t
            return false
        end
    end

    # return HitRecord otherwise
    p = point(r, t)
    out_normal = (p - sphere.origin) / sphere.radius # quicker way to normalise
    front_face = r.direction ⋅ out_normal < 0
    normal = front_face ? out_normal : -out_normal

    return HitRecord(p, normal, t, front_face, sphere)
end
