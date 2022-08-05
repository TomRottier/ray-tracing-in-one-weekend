using LinearAlgebra, Random
using Images, Term.Progress

include("camera.jl")
include("ray.jl")
include("materials.jl")
include("hittable.jl")
include("utils.jl")
include("scene.jl")


function main()
    # image
    aspect_ratio = 3 / 2
    image_width = 200
    image_height = floor(Int, image_width / aspect_ratio)
    output = Matrix{RGB}(undef, image_height, image_width)

    # ray parameters
    n_samples = 100
    max_depth = 50

    # camera
    lookfrom = [13.0, 2.0, 3.0]
    lookat = [0.0, 0.0, 0.0]
    vup = [0.0, 1.0, 0.0]
    focus_dist = 10.0
    aperture = 0.1
    camera = Camera(lookfrom, lookat, vup, 20, aspect_ratio, aperture, focus_dist)

    # world - list of hittable objects
    world = random_scene()

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