struct Camera{T<:AbstractFloat}
    origin::Vector{T}
    u::Vector{T} # horizontal axis
    v::Vector{T} # vertical axis
    w::Vector{T} # long axis
    lower_left_corner::Vector{T}
    horizontal::Vector{T}
    vertical::Vector{T}
    lens_radius::T
end

function Camera(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, focus_dist)
    # viewport height
    h = tand(vfov / 2) # shouldnt be multiplied by focal length?
    viewport_height = 2h
    viewport_width = aspect_ratio * viewport_height

    focal_length = 1.0

    # camera axes
    w = normalize!(lookfrom - lookat)
    u = normalize!(vup × w)
    v = w × u

    # determine lower left corner of viewport
    horizontal = focus_dist * viewport_width * u
    vertical = focus_dist * viewport_height * v
    lower_left_corner = lookfrom - horizontal / 2 - vertical / 2 - focus_dist * w

    # lens radius
    lens_radius = aperture / 2

    return Camera(lookfrom, u, v, w, lower_left_corner, horizontal, vertical, lens_radius)
end

# ray from camera to point on image
function get_ray(c::Camera, s, t)
    rd = c.lens_radius * random_in_unit_disk()
    offset = c.u * rd[1] + c.v * rd[2]
    origin = c.origin + offset
    direction = c.lower_left_corner + s * c.horizontal + t * c.vertical - c.origin - offset
    return Ray(c.origin + offset, direction)
end

# mean colour from random samples of rays
function avg_ray()

end