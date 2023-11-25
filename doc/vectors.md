# thing.vectors

```zig
const vectors = @import("thing").vectors;
```

nD vector types & operations

## About

This packages provides a generic `Vec` n-dimensional vector type factory and
several predefined common vector types listed below. Even though most operations
are available for all vectors, depending on chosen size and component type,
additional features are implemented (for boolean vectors obviously only a
reduced subset makes sense).

The generated structs are all zero-size, i.e. they're merely namespaces exposing
size & type-specific type aliases, constants and operations. The vectors
themselves are always pre-configured versions of Zig's built-in `@Vector` type,
which depending on target platform is SIMD capable/optimized.

### Predefined types

-   `vec2` / `vec3` / `vec4` - `f32` based
-   `ivec2` / `ivec3` / `ivec4` - `i32` based
-   `uvec2` / `uvec3` / `uvec4` - `u32` based
-   `bvec2` / `bvec3` / `bvec4` - `bool` vectors

### Vector operations

Type generics used:

-   `B`: Boolean vector type of size `N`
-   `N`: vector size
-   `T`: Vector component type (e.g. `f32`)
-   `V`: Vector type (e.g. `@Vector(N, T)`)

| Op                                               | Sizes | Types       |
| ------------------------------------------------ | ----- | ----------- |
| `abs(a: V) V`                                    | all   | float / int |
| `acos(a: V) V`                                   | all   | float       |
| `allEqDelta(a: V, b: V, eps: T) bool`            | all   | float / int |
| `angleBetween(a: V, b: V) T`                     | all   | float       |
| `asin(a: V) V`                                   | all   | float       |
| `argmin(a: V) usize`                             | all   | all         |
| `argmax(a: V) usize`                             | all   | all         |
| `atan(a: V) V`                                   | all   | float       |
| `atan2(a: V, b: V) V`                            | all   | float       |
| `ceil(a: V) V`                                   | all   | float       |
| `center(a: V) V`                                 | all   | float       |
| `centroid(a: []const V) V`                       | all   | all         |
| `clamp(a: V, b: V, c: V) V`                      | all   | all         |
| `clamp01(a: V) V`                                | all   | float       |
| `cos(a: V) V`                                    | all   | float       |
| `cross(a: V, b: V) V`                            | 2, 3  | float       |
| `direction(a: V, b: V) T`                        | all   | float       |
| `distSq(a: V, b: V) T`                           | all   | all         |
| `dist(a: V, b: V) T`                             | all   | float       |
| `divN(a: V, n: T) V`                             | all   | all         |
| `dot(a: V, b: V) T`                              | all   | all         |
| `eqDelta(a: V, b: V, eps: T) B`                  | all   | float / int |
| `equal(a: V, b: V) bool`                         | all   | all         |
| `exp(a: V) V`                                    | all   | float       |
| `exp2(a: V) V`                                   | all   | float       |
| `fill(buf: []V, val: V) void`                    | all   | all         |
| `fit(a: V, b: V, c: V, d: V, e: V) V`            | all   | float       |
| `fitN(a: V, b: T, c: T, d: T, e: T) V`           | all   | float       |
| `fitClamped(a: V, b: V, c: V, d: V, e: V) V`     | all   | float       |
| `fitNClamped(a: V, b: T, c: T, d: T, e: T) V`    | all   | float       |
| `fit01(a: V, b: V, c: V) V`                      | all   | float       |
| `floor(a: V) V`                                  | all   | float       |
| `fract(a: V) V`                                  | all   | float       |
| `fromBVec(a: B) V`                               | all   | all         |
| `fromVec(comptime S: type, a: @Vector(N, S)) V`  | all   | all         |
| `fromVec2(a: @Vector(2, T), z: T) V`             | 3     | all         |
| `fromVec2(a: @Vector(2, T), b: @Vector(2, T)) V` | 4     | all         |
| `fromVec2N(a: @Vector(2, T), z: T, w: T) V`      | 4     | all         |
| `fromVec3(a: @Vector(3, T), w: T) V`             | 4     | all         |
| `isZero(a: V) bool`                              | all   | all         |
| `heading(a: V) T`                                | 2     | float       |
| `invSqrt(a: V) V`                                | all   | float       |
| `log(a: V) V`                                    | all   | float       |
| `log2(a: V) V`                                   | all   | float       |
| `log10(a: V) V`                                  | all   | float       |
| `maddN(a: V, n: T, b: V) V`                      | all   | all         |
| `mag(a: V) T`                                    | all   | float       |
| `magSq(a: V) T`                                  | all   | all         |
| `mean(a: V) T`                                   | all   | float       |
| `min(a: V, b: V) V`                              | all   | all         |
| `minComp(a: V) T`                                | all   | all         |
| `mix(a: V, b: V, t: V) V`                        | all   | float       |
| `mixN(a: V, b: V, n: T) V`                       | all   | float       |
| `max(a: V, b: V) V`                              | all   | all         |
| `maxComp(a: V) T`                                | all   | all         |
| `mod(a: V, b: V) V`                              | all   | float       |
| `modN(a: V, b: T) V`                             | all   | float       |
| `mulN(a: V, n: T) V`                             | all   | all         |
| `normalize(a: V) V`                              | all   | float       |
| `normalizeTo(a: V, n: T) V`                      | all   | float       |
| `of(n: T) V`                                     | all   | all         |
| `orthoNormal(a: V, b: V, c: V) V`                | 3     | float       |
| `perpendicularCCW(a: V) V`                       | 2     | float / int |
| `perpendicularCW(a: V) V`                        | 2     | float / int |
| `pow(a: V, b: V) V`                              | all   | float       |
| `powN(a: V, n: T) V`                             | all   | float       |
| `product(a: V) T`                                | all   | all         |
| `reflect(a: V, n: V) V`                          | all   | float       |
| `refract(a: V, n: V, eta: T) V`                  | all   | float       |
| `rotate(a: V, theta: T) V`                       | 2     | float       |
| `rotateX(a: V, theta: T) V`                      | 3     | float       |
| `rotateY(a: V, theta: T) V`                      | 3     | float       |
| `rotateZ(a: V, theta: T) V`                      | 3     | float       |
| `round(a: V) V`                                  | all   | float       |
| `sd(a: V) T`                                     | all   | float       |
| `sdError(a: V) T`                                | all   | float       |
| `select(mask: B, a: V, b: V) V`                  | all   | all         |
| `sin(a: V) V`                                    | all   | float       |
| `smoothStep(e0: V, e1: V, a: V) V`               | all   | float       |
| `sqrt(a: V) V`                                   | all   | float       |
| `standardize(a: V) V`                            | all   | float       |
| `step(edge: V, a: V) V`                          | all   | all         |
| `subN(a: V, n: Y) V`                             | all   | all         |
| `sum(a: V) T`                                    | all   | all         |
| `tan(a: V) V`                                    | all   | float       |
| `trunc(a: V) V`                                  | all   | float       |
| `variance(a: V) T`                               | all   | float       |
| `_not(a: V) V`                                   | all   | int / uint  |
| `_and(a: V, b: V) V`                             | all   | int / uint  |
| `_or(a: V, b: V) V`                              | all   | int / uint  |
| `_xor(a: V, b: V) V`                             | all   | int / uint  |
| `pow(a: V, n: T) V`                              | all   | all         |

### Vector swizzling

[Named
swizzles](https://github.com/thi-ng/zig-thing/blob/main/src/vectors/swizzle.zig)
are implemented for 2D, 3D and 4D vectors, e.g. `vec3.zyx()`, `vec4.xxzz()` etc.

### Boolean vector operations

-   `all(v: V) bool`
-   `_not(a: V) V`
-   `_and(a: V, b: V) V`
-   `_or(a: V, b: V) V`
-   `any(v: V) bool`
-   `of(n: bool) V`
-   `select(mask: V, a: V, b: V) V`

## License

© 2021 - 2022 Karsten Schmidt // Apache License 2.0
