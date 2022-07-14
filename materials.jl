# abstract type for materials?
abstract type AbstractMaterial end

# pick random point inside a unit sphere
function random_unit_sphere()
    while true
        # random points between -1 and 1
        x = 2rand() - 1
        y = 2rand() - 1
        z = 2rand() - 1

        # continue if not inside unit sphere
        (x^2 + y^2 + z^2) > 1.0 && continue

        return normalize([x, y, z])
    end
end