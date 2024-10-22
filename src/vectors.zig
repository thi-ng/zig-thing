// SPDX-License-Identifier: Apache-2.0

const std = @import("std");
const swizzles = @import("vectors/swizzle.zig");

/// Returns a zero-size namespace struct defining vector operations for
/// given size `SIZE` (min: 1) and component type `CTYPE` (any int or float).
/// The actual vector type used for these operations is the built-in
/// `@Vector` aka SIMD-capable vectors. The ops defined here merely act
/// as a more unified and comprehensive API.
/// Depending on chosen component type `CTYPE`, some ops might not be
/// available (i.e. float vectors offer much more functionality than
/// their integer-based counterparts)
pub fn Vec(comptime SIZE: u32, comptime CTYPE: type) type {
    const INFO = @typeInfo(CTYPE);
    if (!(INFO == .Int or INFO == .Float)) {
        @compileError("unsupported component type: " ++ CTYPE);
    }
    if (SIZE < 1) {
        @compileError("zero-length vectors not supported");
    }

    return struct {
        /// The resulting vector type: `@Vector(SIZE, CTYPE)`
        pub const V = @Vector(SIZE, CTYPE);
        /// Boolean vector type: `@Vector(SIZE, bool)`
        pub const B = @Vector(SIZE, bool);
        /// The user provided vector component type
        pub const T = CTYPE;
        /// The user provided vector size
        pub const N = SIZE;

        /// Vector w/ all components as 0
        pub const ZERO = of(0);
        /// Vector w/ all components as 1
        pub const ONE = of(1);

        pub usingnamespace swizzles.Vec2Swizzles(N, T);
        pub usingnamespace swizzles.Vec3Swizzles(N, T);
        pub usingnamespace swizzles.Vec4Swizzles(N, T);

        pub usingnamespace VecSizeSpecific(N, T);
        pub usingnamespace VecTypeSpecific(N, T);

        pub inline fn addN(a: V, n: T) V {
            return a + of(n);
        }

        /// Returns index of the smallest component
        pub fn argmin(a: V) usize {
            var res: usize = 0;
            var acc: T = a[0];
            var i: usize = 1;
            while (i < N) : (i += 1) {
                if (a[i] < acc) {
                    acc = a[i];
                    res = i;
                }
            }
            return res;
        }

        /// Returns index of the largest component
        pub fn argmax(a: V) usize {
            var res: usize = 0;
            var acc: T = a[0];
            var i: usize = 1;
            while (i < N) : (i += 1) {
                if (a[i] > acc) {
                    acc = a[i];
                    res = i;
                }
            }
            return res;
        }

        pub fn centroid(a: []const V) V {
            var i: u32 = 0;
            var res: V = ZERO;
            while (i < a.len) : (i += 1) {
                res += a[i];
            }
            return divN(res, @as(T, @floatFromInt(a.len)));
        }

        pub fn clamp(a: V, b: V, c: V) V {
            return min(max(a, b), c);
        }

        pub inline fn distSq(a: V, b: V) T {
            return magSq(a - b);
        }

        pub inline fn divN(a: V, n: T) V {
            return if (INFO == .Int) @divTrunc(a, of(n)) else a / of(n);
        }

        pub inline fn dot(a: V, b: V) T {
            return _dot(T, a, b);
        }

        pub inline fn equal(a: V, b: V) bool {
            return BVec(SIZE).all(a == b);
        }

        pub inline fn fromBVec(a: B) V {
            return select(a, ONE, ZERO);
        }

        pub fn fill(buf: []V, val: V) void {
            for (buf, 0..) |_, i| {
                buf[i] = val;
            }
        }

        pub inline fn isZero(a: V) bool {
            return BVec(SIZE).all(a == ZERO);
        }

        pub inline fn maddN(a: V, n: T, b: V) V {
            return a * of(n) + b;
        }

        pub inline fn magSq(a: V) T {
            return _dot(T, a, a);
        }

        pub inline fn min(a: V, b: V) V {
            return select(a < b, a, b);
        }

        pub inline fn minComp(a: V) T {
            return @reduce(.Min, a);
        }

        pub inline fn max(a: V, b: V) V {
            return select(a > b, a, b);
        }

        pub inline fn maxComp(a: V) T {
            return @reduce(.Max, a);
        }

        pub inline fn mulN(a: V, n: T) V {
            return a * of(n);
        }

        pub inline fn of(n: T) V {
            return @splat(n);
        }

        pub inline fn product(a: V) T {
            return @reduce(.Mul, a);
        }

        pub inline fn select(mask: B, a: V, b: V) V {
            return @select(T, mask, a, b);
        }

        pub inline fn step(edge: V, a: V) V {
            return select(a < edge, ZERO, ONE);
        }

        pub inline fn subN(a: V, n: T) V {
            return a - of(n);
        }

        pub inline fn sum(a: V) T {
            return @reduce(.Add, a);
        }
    };
}

fn VecTypeSpecific(comptime SIZE: u32, comptime T: type) type {
    const V = @Vector(SIZE, T);
    const INFO = @typeInfo(T);
    const eqd = struct {
        pub fn allEqDelta(a: V, b: V, eps: T) bool {
            return BVec(SIZE).all(eqDelta(a, b, eps));
        }

        pub fn eqDelta(a: V, b: V, eps: T) @Vector(SIZE, bool) {
            const delta = a - b;
            const invDelta = -delta;
            return @select(T, delta > invDelta, delta, invDelta) <= @as(V, @splat(eps));
        }
    };
    if (INFO == .Int) {
        const base = struct {
            pub fn fromVec(comptime S: type, a: @Vector(SIZE, S)) V {
                comptime var i = 0;
                const isFloat = @typeInfo(S) == .Float;
                var res: [SIZE]T = undefined;
                inline while (i < SIZE) : (i += 1) {
                    res[i] = if (isFloat) @as(T, @intFromFloat(a[i])) else @as(T, @intCast(a[i]));
                }
                return res;
            }

            pub inline fn _not(a: V) V {
                return ~a;
            }

            pub inline fn _and(a: V, b: V) V {
                return a & b;
            }

            pub inline fn _or(a: V, b: V) V {
                return a | b;
            }

            pub inline fn _xor(a: V, b: V) V {
                return a ^ b;
            }

            pub inline fn pow(a: V, n: T) V {
                return _map(SIZE, T, a, _powi, .{n});
            }
        };
        return if (isSignedInt(T)) struct {
            pub usingnamespace base;
            pub usingnamespace eqd;

            /// Vector w/ all components as -1
            pub const MINUS_ONE: V = @splat(-1);

            pub inline fn abs(a: V) V {
                return @select(T, a >= @as(V, @splat(0)), a, -a);
            }
        } else base;
    } else {
        return struct {
            pub usingnamespace eqd;

            pub const INF: V = @splat(std.math.inf(T));
            pub const NEG_INF: V = @splat(-std.math.inf(T));

            /// Vector w/ all components as -1
            pub const MINUS_ONE: V = @splat(-1);

            pub inline fn fromVec(comptime S: type, a: @Vector(SIZE, S)) V {
                comptime var i = 0;
                const isInt = @typeInfo(S) == .Int;
                var res: [SIZE]T = undefined;
                inline while (i < SIZE) : (i += 1) {
                    res[i] = if (isInt) @as(T, @floatFromInt(a[i])) else @as(T, @floatCast(a[i]));
                }
                return res;
            }

            pub inline fn abs(a: V) V {
                return @abs(a);
            }

            pub inline fn acos(a: V) V {
                return _map(SIZE, T, a, std.math.acos, .{});
            }

            pub inline fn angleBetween(a: V, b: V) T {
                return std.math.acos(_dot(T, a, b));
            }

            pub inline fn asin(a: V) V {
                return _map(SIZE, T, a, std.math.asin, .{});
            }

            pub inline fn atan(a: V) V {
                return _map(SIZE, T, a, std.math.atan, .{});
            }

            pub inline fn atan2(a: V, b: V) V {
                return _map2(SIZE, T, a, b, _atan2, .{});
            }

            pub inline fn ceil(a: V) V {
                return @ceil(a);
            }

            pub inline fn center(a: V) V {
                return a - @as(V, @splat(mean(a)));
            }

            pub inline fn clamp01(a: V) V {
                const zero: V = @splat(0);
                const one: V = @splat(1);
                const res = @select(T, a > zero, a, zero);
                return @select(T, res < one, res, one);
            }

            pub inline fn cos(a: V) V {
                return @cos(a);
            }

            pub inline fn direction(a: V, b: V) T {
                return normalize(b - a);
            }

            pub inline fn dist(a: V, b: V) T {
                return mag(a - b);
            }

            pub inline fn exp(a: V) V {
                return @exp(a);
            }

            pub inline fn exp2(a: V) V {
                return @exp2(a);
            }

            pub inline fn fit(a: V, b: V, c: V, d: V, e: V) V {
                return mix(d, e, (a - b) / (c - b));
            }

            pub inline fn fitN(a: V, b: T, c: T, d: T, e: T) V {
                return mix(
                    @splat(d),
                    @splat(e),
                    (a - @as(V, @splat(b))) / @as(V, @splat(c - b)),
                );
            }

            pub inline fn fitClamped(a: V, b: V, c: V, d: V, e: V) V {
                return mix(d, e, clamp01((a - b) / (c - b)));
            }

            pub inline fn fitNClamped(a: V, b: T, c: T, d: T, e: T) V {
                return mix(
                    @splat(d),
                    @splat(e),
                    clamp01((a - @as(V, @splat(b))) / @as(V, @splat(c - b))),
                );
            }

            pub inline fn fit01(a: V, b: V, c: V) V {
                return mix(b, c, a);
            }

            pub inline fn floor(a: V) V {
                return @floor(a);
            }

            pub inline fn fract(a: V) V {
                return a - @trunc(a);
            }

            pub inline fn invSqrt(a: V) V {
                return @as(V, @splat(1)) / @sqrt(a);
            }

            pub inline fn log(a: V) V {
                return @log(a);
            }

            pub inline fn log2(a: V) V {
                return @log2(a);
            }

            pub inline fn log10(a: V) V {
                return @log10(a);
            }

            pub inline fn mag(a: V) T {
                return @sqrt(_dot(T, a, a));
            }

            pub inline fn mean(a: V) T {
                return @reduce(.Add, a) / @as(T, SIZE);
            }

            pub inline fn mix(a: V, b: V, t: V) V {
                return a + (b - a) * t;
            }

            pub inline fn mixN(a: V, b: V, n: T) V {
                return mix(a, b, @splat(n));
            }

            pub inline fn mod(a: V, b: V) V {
                return _map2(SIZE, T, a, b, _mod, .{});
            }

            pub inline fn modN(a: V, b: T) V {
                return _map2(SIZE, T, a, @splat(b), _mod, .{});
            }

            pub inline fn normalize(a: V) V {
                return normalizeTo(a, 1.0);
            }

            pub inline fn normalizeTo(a: V, n: T) V {
                const m = mag(a);
                return if (m > 1e-6) a * @as(V, @splat(n / m)) else a;
            }

            pub inline fn pow(a: V, b: V) V {
                return _map2(SIZE, T, a, b, _pow, .{});
            }

            pub inline fn powN(a: V, n: T) V {
                return _map(SIZE, T, a, _pow, .{n});
            }

            pub inline fn reflect(a: V, n: V) V {
                return n * @as(V, @splat(-2 * _dot(T, a, n))) + a;
            }

            pub inline fn refract(a: V, n: V, eta: T) V {
                const d = _dot(T, a, n);
                const k = 1.0 - eta * eta * (1.0 - d * d);
                return if (k < 0)
                    @splat(0)
                else
                    n * @as(V, @splat(-(eta * d + @sqrt(k)))) + a * @as(V, @splat(eta));
            }

            pub inline fn round(a: V) V {
                return @round(a);
            }

            pub inline fn sd(a: V) T {
                return @sqrt(_dot(T, a, a) / @as(T, SIZE - 1));
            }

            pub inline fn sdError(a: V) T {
                return sd(a) / @sqrt(@as(T, SIZE));
            }

            pub inline fn sin(a: V) V {
                return @sin(a);
            }

            pub inline fn smoothStep(e0: V, e1: V, a: V) V {
                const x = clamp01((a - e0) / (e1 - e0));
                return (@as(V, @splat(3)) - @as(V, @splat(3)) * x) * x * x;
            }

            pub inline fn sqrt(a: V) V {
                return @sqrt(a);
            }

            pub inline fn standardize(a: V) V {
                const c = center(a);
                const d = sd(c);
                return if (d > 0) c / @as(V, @splat(d)) else c;
            }

            pub inline fn tan(a: V) V {
                return _map(SIZE, T, a, std.math.tan, .{});
            }

            pub inline fn trunc(a: V) V {
                return @trunc(a);
            }

            pub inline fn variance(a: V) T {
                return _dot(T, a, a) / @as(T, SIZE);
            }
        };
    }
}

pub fn BVec(comptime SIZE: u32) type {
    return struct {
        pub const V = @Vector(SIZE, bool);
        pub const T = bool;
        pub const N = SIZE;

        pub const FALSE = @This().of(false);
        pub const TRUE = @This().of(true);

        pub inline fn all(v: V) bool {
            return @reduce(.And, v);
        }

        pub inline fn _not(a: V) V {
            return _map(SIZE, bool, a, _bnot, .{});
        }

        pub inline fn _and(a: V, b: V) V {
            return _map2(SIZE, bool, a, b, _band, .{});
        }

        pub inline fn _or(a: V, b: V) V {
            return _map2(SIZE, bool, a, b, _bor, .{});
        }

        pub inline fn any(v: V) bool {
            return @reduce(.Or, v);
        }

        pub inline fn of(n: bool) V {
            return @splat(n);
        }

        pub inline fn select(mask: V, a: V, b: V) V {
            return @select(bool, mask, a, b);
        }
    };
}

fn VecSizeSpecific(comptime SIZE: u32, comptime T: type) type {
    const V = @Vector(SIZE, T);
    const INFO = @typeInfo(T);
    const isFloat = INFO == .Float;
    if (SIZE == 2) {
        const base = if (isFloat or isSignedInt(T)) struct {
            pub fn perpendicularCCW(a: V) V {
                return [_]T{ -a[1], a[0] };
            }

            pub fn perpendicularCW(a: V) V {
                return [_]T{ a[1], -a[0] };
            }
        } else struct {};
        return if (isFloat) struct {
            pub usingnamespace base;

            pub inline fn cross(a: V, b: V) T {
                return a[0] * b[1] - a[1] * b[0];
            }

            pub inline fn heading(a: V) T {
                return _atanAbs(_atan2(a[1], a[0]));
            }

            pub fn rotate(a: V, theta: T) V {
                const s = @sin(theta);
                const c = @cos(theta);
                return [_]T{
                    a[0] * c - a[1] * s,
                    a[0] * s + a[1] * c,
                };
            }
        } else base;
    } else if (SIZE == 3) {
        return if (isFloat) struct {
            pub fn fromVec2(a: @Vector(2, T), z: T) V {
                return [_]T{ a[0], a[1], z };
            }

            pub fn orthoNormal(a: V, b: V, c: V) V {
                return _normalize(T, cross(b - a, c - a), 1.0);
            }

            pub fn cross(a: V, b: V) V {
                const a1: V = [_]T{ a[1], a[2], a[0] };
                const a2: V = [_]T{ a[2], a[0], a[1] };
                const b1: V = [_]T{ b[2], b[0], b[1] };
                const b2: V = [_]T{ b[1], b[2], b[0] };
                return (a1 * b1) - (a2 * b2);
            }

            pub fn rotateX(a: V, theta: T) V {
                const s = @sin(theta);
                const c = @cos(theta);
                return [_]T{
                    a[0],
                    a[1] * c - a[2] * s,
                    a[1] * s + a[2] * c,
                };
            }

            pub fn rotateY(a: V, theta: T) V {
                const s = @sin(theta);
                const c = @cos(theta);
                return [_]T{
                    a[2] * s + a[0] * c,
                    a[1],
                    a[2] * c - a[0] * s,
                };
            }

            pub fn rotateZ(a: V, theta: T) V {
                const s = @sin(theta);
                const c = @cos(theta);
                return [_]T{
                    a[0] * c - a[1] * s,
                    a[0] * s + a[1] * c,
                    a[2],
                };
            }
        } else struct {
            pub fn fromVec2(a: @Vector(2, T), z: T) V {
                return [_]T{ a[0], a[1], z };
            }
        };
    } else if (SIZE == 4) {
        return struct {
            pub fn fromVec2(a: @Vector(2, T), b: @Vector(2, T)) V {
                return [_]T{ a[0], a[1], b[0], b[1] };
            }

            pub fn fromVec2N(a: @Vector(2, T), z: T, w: T) V {
                return [_]T{ a[0], a[1], z, w };
            }

            pub fn fromVec3(a: @Vector(3, T), w: T) V {
                return [_]T{ a[0], a[1], a[2], w };
            }
        };
    }
    return struct {};
}

fn isSignedInt(comptime a: type) bool {
    const info = @typeInfo(a);
    return info == .Int and info.Int.signedness == std.builtin.Signedness.signed;
}

fn _map(comptime SIZE: u32, comptime T: type, a: @Vector(SIZE, T), comptime f: anytype, args: anytype) @TypeOf(a) {
    comptime var i = 0;
    var res: [SIZE]T = undefined;
    inline while (i < SIZE) : (i += 1) {
        res[i] = @call(.{}, f, .{a[i]} ++ args);
    }
    return res;
}

fn _map2(comptime SIZE: u32, comptime T: type, a: @Vector(SIZE, T), b: @Vector(SIZE, T), comptime f: anytype, args: anytype) @TypeOf(a) {
    comptime var i = 0;
    var res: [SIZE]T = undefined;
    inline while (i < SIZE) : (i += 1) {
        res[i] = @call(.{}, f, .{ a[i], b[i] } ++ args);
    }
    return res;
}

inline fn _dot(comptime T: type, a: anytype, b: anytype) T {
    return @reduce(.Add, a * b);
}

fn _atan2(a: anytype, b: anytype) @TypeOf(a) {
    return std.math.atan2(@TypeOf(a), a, b);
}

fn _mod(a: anytype, b: anytype) @TypeOf(a) {
    return a - b * @floor(a / b);
}

fn _normalize(comptime T: type, a: anytype, n: anytype) @TypeOf(a) {
    const m = @sqrt(_dot(T, a, a));
    return if (m > 1e-6) a * @as(@TypeOf(a), @splat(n / m)) else a;
}

fn _pow(a: anytype, b: anytype) @TypeOf(a) {
    return std.math.pow(@TypeOf(a), a, b);
}

fn _powi(a: anytype, b: anytype) @TypeOf(a) {
    return std.math.powi(@TypeOf(a), a, b);
}

fn _atanAbs(a: anytype) @TypeOf(a) {
    const theta = std.math.mod(@TypeOf(a), a, std.math.tau);
    return if (theta < 0) std.math.tau + theta else theta;
}

inline fn _band(a: bool, b: bool) bool {
    return a and b;
}

inline fn _bor(a: bool, b: bool) bool {
    return a or b;
}

inline fn _bnot(a: bool) bool {
    return !a;
}

pub const vec2 = Vec(2, f32);
pub const vec3 = Vec(3, f32);
pub const vec4 = Vec(4, f32);

pub const ivec2 = Vec(2, i32);
pub const ivec3 = Vec(3, i32);
pub const ivec4 = Vec(4, i32);

pub const uvec2 = Vec(2, u32);
pub const uvec3 = Vec(3, u32);
pub const uvec4 = Vec(4, u32);

pub const bvec2 = BVec(2);
pub const bvec3 = BVec(3);
pub const bvec4 = BVec(4);

const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

test "Vec.argmin" {
    try expectEqual(@as(usize, 0), vec4.argmin([_]f32{ -4, 3, 2, 1 }));
    try expectEqual(@as(usize, 1), vec4.argmin([_]f32{ 4, -3, 2, 1 }));
    try expectEqual(@as(usize, 2), vec4.argmin([_]f32{ 4, 3, -2, 1 }));
    try expectEqual(@as(usize, 3), vec4.argmin([_]f32{ 4, 3, 2, -1 }));
}

test "Vec.argmax" {
    try expectEqual(@as(usize, 0), vec4.argmax([_]f32{ 4, -3, -2, -1 }));
    try expectEqual(@as(usize, 1), vec4.argmax([_]f32{ -4, 3, -2, -1 }));
    try expectEqual(@as(usize, 2), vec4.argmax([_]f32{ -4, -3, 2, -1 }));
    try expectEqual(@as(usize, 3), vec4.argmax([_]f32{ -4, -3, -2, 1 }));
}

test "Vec.centroid" {
    try expect(vec3.equal(vec3.centroid(&[_]vec3.V{
        [_]f32{ 10, 100, 1000 },
        [_]f32{ 20, -200, -500 },
        [_]f32{ -60, 400, -800 },
    }), [_]f32{ -10, 100, -100 }));
}

test "Vec.clamp" {
    try expect(vec3.equal(vec3.clamp([_]f32{ -3, 2, 0.5 }, [_]f32{ -1, -1, -1 }, vec3.ONE), [_]f32{ -1, 1, 0.5 }));
}

test "Vec.distSq" {
    try expectEqual(@as(i32, 75), ivec3.distSq([_]i32{ -4, 3, -2 }, [_]i32{ 1, -2, 3 }));
}

test "Vec.dot" {
    try expectEqual(@as(i32, -10 - 40 - 90), ivec3.dot([_]i32{ -1, 2, -3 }, [_]i32{ 10, -20, 30 }));
}

test "Vec.equal" {
    try expect(vec2.equal([_]f32{ -1, 2 }, [_]f32{ -1, 2 }));
    try expect(!vec2.equal([_]f32{ -1, 2 }, [_]f32{ -1.01, 2.01 }));
}

test "Vec.eqDelta" {
    try expect(vec2.allEqDelta([_]f32{ -1, 2 }, [_]f32{ -1.09, 2.09 }, 0.1));
    try expect(!vec2.allEqDelta([_]f32{ -1, 2 }, [_]f32{ -1.09, 2.09 }, 0.01));
    try expect(Vec(6, f32).allEqDelta([_]f32{ -1, 2, -3, 4, -5, 6 }, [_]f32{ -1.01, 2.01, -3.01, 4.01, -5.01, 6.01 }, 0.011));
    // unsupported for unsigned
    try expect(!@hasDecl(uvec2, "eqDelta"));
    try expect(!@hasDecl(uvec2, "allEqDelta"));
}

test "Vec2.perpendicular" {
    try expect(vec2.allEqDelta(vec2.perpendicularCCW([_]f32{ 1, 2 }), [_]f32{ -2, 1 }, 0));
    try expect(vec2.allEqDelta(vec2.perpendicularCW([_]f32{ 1, 2 }), [_]f32{ 2, -1 }, 0));
    try expect(ivec2.allEqDelta(ivec2.perpendicularCCW([_]i32{ 1, 2 }), [_]i32{ -2, 1 }, 0));
    try expect(ivec2.allEqDelta(ivec2.perpendicularCW([_]i32{ 1, 2 }), [_]i32{ 2, -1 }, 0));
    // unsupported/unimplemented for unsigned
    try expect(!@hasDecl(uvec2, "perpendicularCCW"));
    try expect(!@hasDecl(uvec2, "perpendicularCW"));
}

test "Vec4.swizzle" {
    try expect(vec4.equal(vec4.xxzz([_]f32{ 1, 2, 3, 4 }), [_]f32{ 1, 1, 3, 3 }));
}

test "Vec4.isZero" {
    try expectEqual(
        @as(vec4.V, [_]f32{ 10, 0, -20, 0 }) == vec4.ZERO,
        @as(bvec4.V, [_]bool{ false, true, false, true }),
    );
}
