# pick random point inside a unit sphere
function random_unit_sphere()
    while true
        # random points between -1 and 1
        x = 2rand() - 1
        y = 2rand() - 1
        z = 2rand() - 1

        # continue if not inside unit sphere
        (x^2 + y^2 + z^2) > 1.0 && continue

        return [x, y, z] #normalize!([x, y, z])
    end
end

function random_in_unit_disk()
    while true
        p = [2rand() - 1, 2rand() - 1, 0.0]
        sum(abs2, p) ≤ 1.0 && return p
    end
end

# ray reflection for incoming ray v and normal n at intersection point
reflect(v, n) = v - 2 * (v ⋅ n) * n

# ray refraction for incoming UNIT ray r, normal n and refraction indicies ratio
function refract(r, n, η_over_η′)
    cosθ = min(-r ⋅ n, 1.0)
    rperp = η_over_η′ * (r + cosθ * n)
    rpara = -√(1.0 - sum(abs2, rperp)) * n

    return rperp + rpara
end

# Schlick approximation of reflectance of glass
function reflectance(cosine, ref_idx)
    r0 = (1 - ref_idx) / (1 + ref_idx)
    r0 = r0^2
    return r0 + (1 - r0) * (1 - cosine)^5
end