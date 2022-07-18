# Ray Tracing in One Weekend

Implementation of [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) in Julia.

- Commit after each chapter so you can look as the code so far by restoring to that version
- Differences to C++ version:
  - Julia has vectors and vector algebra built in so no need to create own library. I therefore skip chapter three
  - outputs to an Matrix{RGB} and saves to file using [Images.jl](https://github.com/JuliaImages/Images.jl)

## Latest image
![latest image](img.png)
