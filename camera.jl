struct Camera{T<:AbstractFloat}
    aspect_ratio::T
    viewport_height::T
    viewport_width::T
    focal_length::T
    origin::Vector{T}
    viewport_origin::Vector{T}
    u::Vector{T} # horizontal axis
    v::Vector{T} # vertical axis
    w::Vector{T} # long axis
end

# determine camera parameters from vertical field of view angle (degrees)
function Camera(origin, lookat, vup, vfov, aspect_ratio)
    # viewport height
    h = tand(vfov / 2) # shouldnt be multiplied by focal length?
    viewport_height = 2h
    viewport_width = aspect_ratio * viewport_height

    # determine viewport origin - lower left corner
    w = normalize!(origin - lookat)
    u = normalize!(vup × w)
    v = w × u

    horizontal = viewport_width * u
    vertical = viewport_height * v
    viewport_origin = origin - horizontal / 2 - vertical / 2 - w

    focal_length = 0.0 # ???

    return Camera(aspect_ratio, viewport_height, viewport_width, focal_length, origin, viewport_origin, u, v, w)

end

# ray from camera to point on image
get_ray(c::Camera, s, t) =
    Ray(c.origin, c.viewport_origin + s * c.viewport_width * c.u + t * c.viewport_height * c.v - c.origin)

# mean colour from random samples of rays
function avg_ray()

end