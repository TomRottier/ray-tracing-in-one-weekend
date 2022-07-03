using LinearAlgebra, Images, Term.Progress

struct Ray{T<:AbstractFloat}
    origin::Vector{T}
    direction::Vector{T}
end

point(r::Ray, t) = r.origin + r.direction * t

# check if ray hits sphere
function hit_sphere(centre, radius, r::Ray)
    ac = r.origin - centre
    a = r.direction ⋅ r.direction
    b = 2(r.direction ⋅ ac)
    c = ac ⋅ ac - radius^2

    return (b^2 - 4 * a * c) > 0
end


# determine colour of ray 
function ray_colour(r::Ray)
    # colour red if ray hits sphere
    hit_sphere([0, 0, -1], 0.5, r) && return RGB(1, 0, 0)

    # scale y component of direction between 0 and 1
    t = 0.5(normalize(r.direction)[2] + 1)

    # linearly interpolate between white and blue depending on scaled height
    c = RGB((1 - t) * [1, 1, 1] + t * [0.5, 0.7, 1.0]...)

    return c
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
            c = ray_colour(r)

            # reverse index to plot in same direction
            jj = reverse(1:image_height)[j]
            output[jj, i] = c
        end
    end

    return output
end

main()