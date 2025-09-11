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
size & type-specific type aliases, constants and functions. The vectors
themselves are always pre-configured versions of Zig's built-in `@Vector` type,
which depending on target platform is SIMD capable/optimized.

### Predefined types

-   `vec2` / `vec3` / `vec4` - `f32` based
-   `ivec2` / `ivec3` / `ivec4` - `i32` based
-   `uvec2` / `uvec3` / `uvec4` - `u32` based
-   `bvec2` / `bvec3` / `bvec4` - `bool` vectors

### Vector creation

All vector type defined expose the following constants:

-   `B`: Boolean vector type of size `N`
-   `N`: vector size
-   `T`: Vector component type (e.g. `f32`)
-   `V`: Vector type (e.g. `@Vector(N, T)`)

```zig
const vec2 = @import("thing").vectors.vec2;
const vec3 = @import("thing").vectors.vec3;

const a: vec2.V = [_]f32{ 1, 2 }; // cast as @Vector(2, f32)

// vector from uniform scalar
const b = vec3.of(1); // [3]f32{ 1, 1, 1 }

// extend vector with pad value
const c = vec3.fromVec(a, 10); // [3]f32{ 1, 2, 10 }

// select sub-vector from larger vec
const d = vec2.fromVec([_]f32{1, 2, 3, 4}, 0); // [2]f32{ 1, 2 }

// coerce to boolean vec
const d = bvec2.fromVec([_]f32{ 1, 0}, false); // [2]bool{ true, false }

// coerce from boolean vec with pad value
const d = vec3.fromVec([_]bool{ true, false }, 10); // [3]f32{ 1, 0, 10 }
```

### Vector operations

| Op                                            | Sizes | Types              |
| --------------------------------------------- | ----- | ------------------ |
| `abs(a: V) V`                                 | all   | float / int        |
| `acos(a: V) V`                                | all   | float              |
| `allEqDelta(a: V, b: V, eps: T) bool`         | all   | float / int / uint |
| `angleBetween(a: V, b: V) T`                  | all   | float              |
| `asin(a: V) V`                                | all   | float              |
| `argmin(a: V) usize`                          | all   | float / int / uint |
| `argmax(a: V) usize`                          | all   | float / int / uint |
| `atan(a: V) V`                                | all   | float              |
| `atan2(a: V, b: V) V`                         | all   | float              |
| `ceil(a: V) V`                                | all   | float              |
| `center(a: V) V`                              | all   | float              |
| `centroid(a: []const V) V`                    | all   | float / int / uint |
| `clamp(a: V, b: V, c: V) V`                   | all   | float / int / uint |
| `clamp01(a: V) V`                             | all   | float              |
| `cos(a: V) V`                                 | all   | float              |
| `cross(a: V, b: V) V`                         | 2, 3  | float              |
| `direction(a: V, b: V) T`                     | all   | float              |
| `distSq(a: V, b: V) T`                        | all   | float / int / uint |
| `dist(a: V, b: V) T`                          | all   | float              |
| `divN(a: V, n: T) V`                          | all   | float / int / uint |
| `dot(a: V, b: V) T`                           | all   | float / int / uint |
| `eqDelta(a: V, b: V, eps: T) B`               | all   | float / int        |
| `equal(a: V, b: V) bool`                      | all   | all                |
| `exp(a: V) V`                                 | all   | float              |
| `exp2(a: V) V`                                | all   | float              |
| `fill(buf: []V, val: V) void`                 | all   | all                |
| `fit(a: V, b: V, c: V, d: V, e: V) V`         | all   | float              |
| `fitN(a: V, b: T, c: T, d: T, e: T) V`        | all   | float              |
| `fitClamped(a: V, b: V, c: V, d: V, e: V) V`  | all   | float              |
| `fitNClamped(a: V, b: T, c: T, d: T, e: T) V` | all   | float              |
| `fit01(a: V, b: V, c: V) V`                   | all   | float              |
| `floor(a: V) V`                               | all   | float              |
| `fract(a: V) V`                               | all   | float              |
| `fromVec(a: V, pad: T) V`                     | all   | all                |
| `isZero(a: V) bool`                           | all   | float / int / uint |
| `heading(a: V) T`                             | 2     | float              |
| `invSqrt(a: V) V`                             | all   | float              |
| `log(a: V) V`                                 | all   | float              |
| `log2(a: V) V`                                | all   | float              |
| `log10(a: V) V`                               | all   | float              |
| `maddN(a: V, n: T, b: V) V`                   | all   | float / int / uint |
| `mag(a: V) T`                                 | all   | float              |
| `magSq(a: V) T`                               | all   | float / int / uint |
| `mean(a: V) T`                                | all   | float              |
| `min(a: V, b: V) V`                           | all   | float / int / uint |
| `minComp(a: V) T`                             | all   | float / int / uint |
| `mix(a: V, b: V, t: V) V`                     | all   | float              |
| `mixN(a: V, b: V, n: T) V`                    | all   | float              |
| `max(a: V, b: V) V`                           | all   | float / int / uint |
| `maxComp(a: V) T`                             | all   | float / int / uint |
| `mod(a: V, b: V) V`                           | all   | float              |
| `modN(a: V, b: T) V`                          | all   | float              |
| `mulN(a: V, n: T) V`                          | all   | float / int / uint |
| `normalize(a: V) V`                           | all   | float              |
| `normalizeTo(a: V, n: T) V`                   | all   | float              |
| `of(n: T) V`                                  | all   | float / int / uint |
| `orthoNormal(a: V, b: V, c: V) V`             | 3     | float              |
| `perpendicularCCW(a: V) V`                    | 2     | float / int        |
| `perpendicularCW(a: V) V`                     | 2     | float / int        |
| `pow(a: V, b: V) V`                           | all   | float              |
| `powN(a: V, n: T) V`                          | all   | float              |
| `product(a: V) T`                             | all   | float / int / uint |
| `reflect(a: V, n: V) V`                       | all   | float              |
| `refract(a: V, n: V, eta: T) V`               | all   | float              |
| `rotate(a: V, theta: T) V`                    | 2     | float              |
| `rotateX(a: V, theta: T) V`                   | 3     | float              |
| `rotateY(a: V, theta: T) V`                   | 3     | float              |
| `rotateZ(a: V, theta: T) V`                   | 3     | float              |
| `round(a: V) V`                               | all   | float              |
| `sd(a: V) T`                                  | all   | float              |
| `sdError(a: V) T`                             | all   | float              |
| `select(mask: B, a: V, b: V) V`               | all   | all                |
| `sin(a: V) V`                                 | all   | float              |
| `smoothStep(e0: V, e1: V, a: V) V`            | all   | float              |
| `sqrt(a: V) V`                                | all   | float              |
| `standardize(a: V) V`                         | all   | float              |
| `step(edge: V, a: V) V`                       | all   | float / int / uint |
| `subN(a: V, n: Y) V`                          | all   | float / int / uint |
| `sum(a: V) T`                                 | all   | float / int / uint |
| `tan(a: V) V`                                 | all   | float              |
| `trunc(a: V) V`                               | all   | float              |
| `variance(a: V) T`                            | all   | float              |
| `_not(a: V) V`                                | all   | int / uint         |
| `_and(a: V, b: V) V`                          | all   | int / uint         |
| `_or(a: V, b: V) V`                           | all   | int / uint         |
| `_xor(a: V, b: V) V`                          | all   | int / uint         |
| `pow(a: V, n: V) V`                           | all   | float / int / uint |
| `powN(a: V, n: T) V`                          | all   | float / int / uint |

### Vector swizzling

Due to the loss of struct merging with the release of Zig 0.15.1, the implementation of
named swizzle functions has become too much of a maintenance burden and swizzling is now
handled via a single `swizzle()` function available for all vector types:

```zig
const vec2 = @import("thing").vectors.vec2;

const a = [_]f32{1, 2};

vec2.swizzle(a, "x");    // [1]f32{1}
vec2.swizzle(a, "xy");   // [2]f32{1, 2}
vec2.swizzle(a, "xyx");  // [3]f32{1, 2, 1}
vec2.swizzle(a, "xxyy"); // [4]f32{1, 1, 2, 2}
```

Swizzle ID strings are `comptime`. The following component IDs are supported
(depending on given input vector size): `x`, `y`, `z`, `w`.

### Boolean vector operations

-   `all(v: V) bool`
-   `_not(a: V) V`
-   `_and(a: V, b: V) V`
-   `_or(a: V, b: V) V`
-   `any(v: V) bool`
-   `of(n: bool) V`
-   `select(mask: V, a: V, b: V) V`

## License

© 2021 - 2025 Karsten Schmidt // Apache License 2.0
