# abstract type for materials, materials either scatter a ray with some attenuation or absorb the ray
abstract type AbstractMaterial end

# return albedo (colour) and scattered ray from intersection with object
scatter(obj, r::Ray, rec) = obj.material.attenuation, scatter(obj.material, r, rec)


#### materials ####

# lambertian material - diffuse/matte
struct Lambertian{T} <: AbstractMaterial
    albedo::Vector{T} # colour
    attenuation::Vector{T} # how much of the ray gets absorbed
end

Lambertian(col) = Lambertian(col, col) # defaults to same attenuation as colour

# lambertian materials scatter rays in random directions
function scatter(mat::Lambertian, r::Ray, rec::HitRecord)
    # random direction of scattered ray
    scatter_direction = rec.normal + normalize(random_unit_sphere())

    # catch degenerate rays
    if all(abs.(scatter_direction) .< 1e-8)
        scatter_direction = rec.normal
    end

    # return ray from intersection point to the random_point
    return Ray(rec.point, scatter_direction)

    ## alternative formulation
    # # random unit vector direction from intersection point
    # rand_dir = normalize(rand(3))

    # return Ray(rec.point, rand_dir)
end

# metal material
struct Metal{T<:AbstractFloat} <: AbstractMaterial
    albedo::Vector{T}
    attenuation::Vector{T}
    fuzziness::T
end
Metal(col, fuzziness) = Metal(col, col, fuzziness) # default attenuation

# ray scatter for Metal material
function scatter(mat::Metal, r::Ray, rec::HitRecord)
    reflected = reflect(normalize(r.direction), rec.normal)
    scattered = reflected + mat.fuzziness * random_unit_sphere()

    return scattered ⋅ rec.normal > 0 ? Ray(rec.point, scattered) : false
end


# dielectric material
struct Dielectric{T<:AbstractFloat} <: AbstractMaterial
    attenuation::Vector{T}
    IR::T # refractive index of material
end
Dielectric(ir) = Dielectric([1.0, 1.0, 1.0], ir) # dielectrics absorb nothing

function scatter(mat::Dielectric, r::Ray, rec::HitRecord)
    # ratio of refraction index ray is currently in (air = 1.0) to new material
    refraction_ratio = rec.front_face ? (1.0 / mat.IR) : mat.IR # ir / 1.0 # one(T) / mat.IR

    # check if ray can refract
    unit_direction = normalize(r.direction)
    cosθ = min(-unit_direction ⋅ rec.normal, 1.0) # one(T)
    sinθ = √(1 - cosθ^2)
    cannot_refract = refraction_ratio * sinθ > 1.0

    # reflect if ray cannot refract
    if (cannot_refract || reflectance(cosθ, refraction_ratio) > rand())
        direction = reflect(unit_direction, rec.normal)
    else
        direction = refract(unit_direction, rec.normal, refraction_ratio)
    end

    return Ray(rec.point, direction)
end