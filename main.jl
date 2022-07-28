using LinearAlgebra, Images, Term.Progress

include("camera.jl")
include("ray.jl")
include("materials.jl")
include("hittable.jl")
include("utils.jl")


function main()
    # image
    aspect_ratio = 16 / 9
    image_width = 400
    image_height = floor(Int, image_width / aspect_ratio)
    output = Matrix{RGB}(undef, image_height, image_width)

    # camera
    # camera = Camera(aspect_ratio=aspect_ratio, height=2.0, focal_length=1.0, origin=[0.0, 0.0, 0.0])
    camera = Camera([-2.0, 2.0, 1.0], [0.0, 0.0, -1.0], [0.0, 1.0, 0.0], 90, aspect_ratio)
    n_samples = 100
    max_depth = 50

    # world - list of hittable objects
    ground = Sphere([0.0, -1000.0, 0.0], 1000.0, Lambertian([0.5, 0.5, 0.5]))
    sphere_centre = Sphere([0.0, 0.0, -1.0], 0.5, Lambertian([0.1, 0.2, 0.5]))
    # sphere_left = Sphere([-1.0, 0.0, -1.0], 0.5, Metal([0.8, 0.8, 0.8], 0.3))
    sphere_left = Sphere([-1.0, 0.0, -1.0], -0.4, Dielectric(1.5))
    sphere_right = Sphere([1.0, 0.0, -1.0], 0.5, Metal([0.8, 0.6, 0.2], 0.0))

    world = [ground, sphere_centre, sphere_left, sphere_right]

    # render
    pb = ProgressBar()
    job = addjob!(pb; N=image_width)
    with(pb) do
        Threads.@threads for i in 1:image_width
            for j in 1:image_height
                c = zeros(3)

                # repeat to get average pixel colour
                for _ in 1:n_samples
                    # relative position of pixel in image
                    u = (i - 1 + rand()) / (image_width - 1)
                    v = (j - 1 + rand()) / (image_height - 1)

                    # ray from camera origin to point in world coordinates
                    r = get_ray(camera, u, v)

                    # determine colour of ray
                    _c = RGB(ray_colour(world, r, max_depth)...)
                    c += [_c.r, _c.g, _c.b] / n_samples
                end
                # reverse index to plot in same direction
                jj = reverse(1:image_height)[j]
                output[jj, i] = RGB(sqrt.(c)...)
            end
            update!(job)
        end
    end

    return output
end

img = @time main()
save("image.png", img)