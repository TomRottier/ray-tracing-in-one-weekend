# create random scatter_direction    ground = Sphere([0.0, -1000.0, 0.0], 1000.0, Lambertian([0.5, 0.5, 0.5]))
function random_scene(seed=123456)
    Random.seed!(seed)

    ground = Sphere([0, -1000.0, 0], 1000.0, Lambertian([0.5, 0.5, 0.5]))
    world = AbstractHittable[ground]

    for a in -11:10
        for b in -11:10
            d = rand()
            origin = [a + 0.9d, 0.2, b + 0.9d]

            if norm(origin - [4, 0.2, 0]) > 0.9

                if d < 0.8
                    # diffuse
                    albedo = rand(3) .^ 2
                    sphere_material = Lambertian(albedo)
                    sphere = Sphere(origin, 0.2, sphere_material)
                    push!(world, sphere)
                elseif d < 0.95
                    # metal
                    albedo = 0.5rand(3) .+ 0.5 # 0.5:1.0
                    fuzz = 0.5rand()
                    sphere_material = Metal(albedo, fuzz)
                    sphere = Sphere(origin, 0.2, sphere_material)
                    push!(world, sphere)
                else
                    # glass
                    sphere_material = Dielectric(1.5)
                    sphere = Sphere(origin, 0.2, sphere_material)
                    push!(world, sphere)
                end
            end
        end
    end

    material1 = Dielectric(1.5)
    push!(world, Sphere([0.0, 1, 0], 1.0, material1))

    material2 = Lambertian([0.4, 0.2, 0.1])
    push!(world, Sphere([-4.0, 1, 0], 1.0, material2))

    material3 = Metal([0.7, 0.6, 0.5], 0.0)
    push!(world, Sphere([4.0, 1.0, 0], 1.0, material3))

    return world
end


function two_sphere_scene()
    ground = Sphere([0, -1000.0, 0], 1000.0, Lambertian([0.5, 0.5, 0.5]))
    world = AbstractHittable[ground]

    # spheres
    material1 = Dielectric(1.5)
    push!(world, Sphere([0.0, 1, 0], 1.0, material1))

    material2 = Lambertian([0.4, 0.2, 0.1])
    push!(world, Sphere([-4.0, 1, 0], 1.0, material2))

    material3 = Metal([0.7, 0.6, 0.5], 0.0)
    push!(world, Sphere([4.0, 1.0, 0], 1.0, material3))

    return world

end
