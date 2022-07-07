using LinearAlgebra, Images, Term.Progress

include("camera.jl")
include("hittable.jl")
include("ray.jl")


function main()
    # image
    aspect_ratio = 16 / 9
    image_width = 400
    image_height = floor(Int, image_width / aspect_ratio)
    output = Matrix{RGB}(undef, image_height, image_width)

    # camera
    camera = Camera(aspect_ratio=aspect_ratio, height=2.0, focal_length=1.0, origin=[0.0, 0.0, 0.0])
    n_samples = 100

    # world - list of hittable objects
    sphere1 = Sphere([0.0, 0.0, -1.0], 0.5)
    sphere2 = Sphere([0.0, -100.5, -1.0], 100.0)
    world = [sphere1, sphere2]

    # render
    @track for i in 1:image_width
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
                _c = ray_colour(world, r)
                c += [_c.r, _c.g, _c.b] / n_samples
            end
            # reverse index to plot in same direction
            jj = reverse(1:image_height)[j]
            output[jj, i] = RGB(c...)
        end
    end

    return output
end

main()