struct Camera{T<:AbstractFloat}
    aspect_ratio::T
    viewport_height::T
    viewport_width::T
    focal_length::T
    origin::Vector{T}
end

Camera(; aspect_ratio, height, focal_length, origin, fov) = Camera(aspect_ratio, height, height * aspect_ratio, focal_length, origin)

# determine camera parameters from vertical field of view angle (degrees)
function Camera(aspect_ratio, focal_length, vfov, origin=[0.0, 0.0, 0.0])
    # viewport height
    h = focal_length * tand(vfov / 2)
    viewport_height = 2h
    viewport_width = aspect_ratio * viewport_height

    return Camera(aspect_ratio, viewport_height, viewport_width, focal_length, origin)

end
# Camera(; aspect_ratio, width, focal_length, origin) = Camera(aspect_ratio, width / aspect_ratio, width, focal_length, origin)


# origin of viewport - lower left corner
viewport_origin(c::Camera) = c.origin - [c.viewport_width / 2, 0, 0] - [0, c.viewport_height / 2, 0] - [0, 0, c.focal_length]

# ray from camera to point on image
get_ray(c::Camera, u, v) = Ray(c.origin, viewport_origin(c) + u * [c.viewport_width, 0, 0] + v * [0, c.viewport_height, 0] - c.origin)

# mean colour from random samples of rays
function avg_ray()

end