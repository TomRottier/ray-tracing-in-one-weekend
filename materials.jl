# abstract type for materials, materials either scatter a ray with some attenuation or absorb the ray
abstract type AbstractMaterial end

# return albedo (colour) and scattered ray from intersection with object
scatter(obj, r::Ray, rec) = obj.material.albedo, scatter(obj.material, r, rec)


#### materials ####

# lambertian material - diffuse/matte
struct Lambertian{T} <: AbstractMaterial
    albedo::Vector{T} # colour
end

# lambertian materials scatter rays in random directions
function scatter(mat::Lambertian, r::Ray, rec::HitRecord)
    # random point inside unit sphere centred at intersection point + normal
    rand_point = rec.point + rec.normal + random_unit_sphere()

    # scattered ray, normalized for true lambertian reflection
    scattered = normalize(rand_point - rec.point)

    # return ray from intersection point to the random_point
    return Ray(rec.point, scattered)

    ## alternative formulation
    # # random unit vector direction from intersection point
    # rand_dir = normalize(rand(3))

    # return Ray(rec.point, rand_dir)
end

# metal material
struct Metal{T<:AbstractFloat} <: AbstractMaterial
    albedo::Vector{T}
    fuzziness::T
end

# ray scatter for Metal material
function scatter(mat::Metal, r::Ray, rec::HitRecord)
    scattered = reflect(normalize(r.direction), rec.normal) + mat.fuzziness * random_unit_sphere()

    return Ray(rec.point, scattered)
end

