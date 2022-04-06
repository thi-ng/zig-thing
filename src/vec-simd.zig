const std = @import("std");
const swizzles = @import("swizzle.zig");

/// Returns a zero-size namespace struct defining vector operations for
/// given size `N` (min: 1) and component type `C` (any integer or float).
/// The actual vector type used for these operations is the built-in
/// `std.meta.Vector` aka SIMD-optimized vectors. The ops defined here
/// merely act as a more unified and comprehensive API.
/// Depending on chosen component type `C`, some ops might not be
/// available (i.e. float vectors offer much more functionality than
/// their integer-based counterparts)
pub fn Vec(comptime N: u32, comptime C: type) type {
    const INFO = @typeInfo(C);
    if (!(INFO == .Int or INFO == .Float)) {
        @compileError("unsupported component type: " ++ C);
    }
    if (N < 1) {
        @compileError("zero-length vectors not supported");
    }

    const V = @Vector(N, C);
    const B = @Vector(N, bool);

    return struct {
        /// The resulting vector type: `@Vector(N, C)`
        pub const T = V;
        /// The user provided vector component type: C
        pub const C = C;
        /// The user provided vector size: N
        pub const N = N;

        /// Vector w/ all components as 0
        pub const ZERO = of(0);
        /// Vector w/ all components as 1
        pub const ONE = of(1);

        pub usingnamespace swizzles.Vec2Swizzles(N, C);
        pub usingnamespace swizzles.Vec3Swizzles(N, C);
        pub usingnamespace swizzles.Vec4Swizzles(N, C);

        pub usingnamespace VecSizeSpecific(N, C);
        pub usingnamespace VecTypeSpecific(N, C);

        pub inline fn x(a: V) C {
            return a[0];
        }

        pub inline fn addN(a: V, n: C) V {
            return a + of(n);
        }

        /// Returns index of the smallest component
        pub fn argmin(a: V) u32 {
            var res: u32 = 0;
            var acc: C = a[0];
            comptime var i = 1;
            inline while (i < N) : (i += 1) {
                if (a[i] < acc) {
                    acc = a[i];
                    res = i;
                }
            }
            return res;
        }

        /// Returns index of the largest component
        pub fn argmax(a: V) u32 {
            var res: u32 = 0;
            var acc: C = a[0];
            comptime var i = 1;
            inline while (i < N) : (i += 1) {
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
            return divN(res, @intToFloat(C, a.len));
        }

        pub fn clamp(a: V, b: V, c: V) V {
            return min(max(a, b), c);
        }

        pub inline fn distSq(a: V, b: V) C {
            return magSq(a - b);
        }

        pub inline fn divN(a: V, n: C) V {
            return if (INFO == .Int) @divTrunc(a, of(n)) else a / of(n);
        }

        pub inline fn dot(a: V, b: V) C {
            return _dot(C, a, b);
        }

        pub inline fn equal(a: V, b: V) bool {
            return BVec(N).all(a == b);
        }

        pub fn fill(buf: []V, val: V) void {
            for (buf) |_, i| {
                buf[i] = val;
            }
        }

        pub inline fn fromBVec(a: B) V {
            return select(a, ONE, ZERO);
        }

        pub inline fn isZero(a: V) bool {
            return BVec(N).all(a == ZERO);
        }

        /// computes a * b + c, where `a` and `c` are vectors and `b` is a scalar
        pub inline fn maddN(a: V, n: C, b: V) V {
            return a * of(n) + b;
        }

        pub inline fn magSq(a: V) C {
            return _dot(C, a, a);
        }

        pub inline fn min(a: V, b: V) V {
            return select(a < b, a, b);
        }

        pub inline fn minComp(a: V) C {
            return @reduce(.Min, a);
        }

        pub inline fn max(a: V, b: V) V {
            return select(a > b, a, b);
        }

        pub inline fn maxComp(a: V) C {
            return @reduce(.Max, a);
        }

        pub inline fn mulN(a: V, n: C) V {
            return a * of(n);
        }

        pub inline fn of(n: C) V {
            return @splat(N, n);
        }

        pub inline fn product(a: V) C {
            return @reduce(.Mul, a);
        }

        pub inline fn select(mask: B, a: V, b: V) V {
            return @select(C, mask, a, b);
        }

        pub inline fn step(e0: V, a: V) V {
            return select(a < e0, ZERO, ONE);
        }

        pub inline fn subN(a: V, n: C) V {
            return a - of(n);
        }

        pub inline fn sum(a: V) C {
            return @reduce(.Add, a);
        }
    };
}

fn VecTypeSpecific(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    const INFO = @typeInfo(T);
    const eqd = struct {
        pub fn allEqDelta(a: V, b: V, eps: T) bool {
            return BVec(N).all(eqDelta(a, b, eps));
        }

        pub fn eqDelta(a: V, b: V, eps: T) @Vector(N, bool) {
            const delta = a - b;
            const invDelta = -delta;
            return @select(T, delta > invDelta, delta, invDelta) <= @splat(N, eps);
        }
    };
    if (INFO == .Int) {
        const base = struct {
            pub inline fn fromVec(comptime S: type, a: @Vector(N, S)) V {
                comptime var i = 0;
                var res: [N]T = undefined;
                inline while (i < N) : (i += 1) {
                    res[i] = @floatToInt(T, a[i]);
                }
                return res;
            }

            pub inline fn fromIVec(comptime S: type, a: @Vector(N, S)) V {
                comptime var i = 0;
                var res: [N]T = undefined;
                inline while (i < N) : (i += 1) {
                    res[i] = @intCast(T, a[i]);
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
                return _map(N, T, a, _powi, .{n});
            }
        };
        return if (isSignedInt(T)) struct {
            pub usingnamespace base;
            pub usingnamespace eqd;

            /// Vector w/ all components as -1
            pub const MINUS_ONE = @splat(N, -1);

            pub inline fn abs(a: V) V {
                return @select(T, a >= @splat(N, 0), a, -a);
            }
        } else base;
    } else {
        return struct {
            pub usingnamespace eqd;

            pub const INF = @splat(N, std.math.inf(T));
            pub const NEG_INF = @splat(N, -std.math.inf(T));

            /// Vector w/ all components as -1
            pub const MINUS_ONE = @splat(N, -1);

            pub inline fn fromIVec(comptime S: type, a: @Vector(N, S)) V {
                comptime var i = 0;
                var res: [N]T = undefined;
                inline while (i < N) : (i += 1) {
                    res[i] = @intToFloat(T, a[i]);
                }
                return res;
            }

            pub inline fn abs(a: V) V {
                return @fabs(a);
            }

            pub inline fn acos(a: V) V {
                return _map(N, T, a, std.math.acos, .{});
            }

            pub inline fn angleBetween(a: V, b: V) T {
                return std.math.acos(_dot(T, a, b));
            }

            pub inline fn asin(a: V) V {
                return _map(N, T, a, std.math.asin, .{});
            }

            pub inline fn atan(a: V) V {
                return _map(N, T, a, std.math.atan, .{});
            }

            pub inline fn atan2(a: V, b: V) V {
                return _map2(N, T, a, b, _atan2, .{});
            }

            pub inline fn ceil(a: V) V {
                return @ceil(a);
            }

            pub inline fn center(a: V) V {
                return a - @splat(N, mean(a));
            }

            pub inline fn clamp01(a: V) V {
                const zero = _splat(N, T, 0);
                const one = _splat(N, T, 1);
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

            pub inline fn fitClamped(a: V, b: V, c: V, d: V, e: V) V {
                return mix(d, e, clamp01((a - b) / (c - b)));
            }

            pub inline fn fit01(a: V, b: V, c: V) V {
                return mix(b, c, a);
            }

            pub inline fn floor(a: V) V {
                return @floor(a);
            }

            pub inline fn invSqrt(a: V) V {
                return _splat(N, T, 1) / @sqrt(a);
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
                return @reduce(.Add, a) / @as(T, N);
            }

            pub inline fn mix(a: V, b: V, t: V) V {
                return a + (b - a) * t;
            }

            pub inline fn mixN(a: V, b: V, n: T) V {
                return mix(a, b, @splat(N, n));
            }

            pub inline fn mod(a: V, b: V) V {
                return _map2(N, T, a, b, _mod, .{});
            }

            pub inline fn normalize(a: V) V {
                return normalizeTo(a, 1.0);
            }

            pub inline fn normalizeTo(a: V, n: T) V {
                const m = mag(a);
                return if (m > 1e-6) a * @splat(N, n / m) else a;
            }

            pub inline fn pow(a: V, b: V) V {
                return _map2(N, T, a, b, _pow, .{});
            }

            pub inline fn powN(a: V, n: T) V {
                return _map(N, T, a, _pow, .{n});
            }

            pub inline fn reflect(a: V, n: V) V {
                return n * @splat(N, -2 * _dot(T, a, n)) + a;
            }

            pub inline fn refract(a: V, n: V, eta: T) V {
                const d = _dot(T, a, n);
                const k = 1.0 - eta * eta * (1.0 - d * d);
                return if (k < 0)
                    _splat(N, T, 0)
                else
                    n * @splat(N, -(eta * d + @sqrt(k))) + a * @splat(N, eta);
            }

            pub inline fn round(a: V) V {
                return @round(a);
            }

            pub inline fn sd(a: V) T {
                return @sqrt(_dot(T, a, a) / @as(T, N - 1));
            }

            pub inline fn sdError(a: V) T {
                return sd(a) / @sqrt(@as(T, N));
            }

            pub inline fn sin(a: V) V {
                return @sin(a);
            }

            pub inline fn smoothStep(e0: V, e1: V, a: V) V {
                const x = clamp01((a - e0) / (e1 - e0));
                return (_splat(N, T, 3) - _splat(N, T, 2) * x) * x * x;
            }

            pub inline fn sqrt(a: V) V {
                return @sqrt(a);
            }

            pub inline fn standardize(a: V) V {
                const c = center(a);
                const d = sd(c);
                return if (d > 0) c / @splat(N, d) else c;
            }

            pub inline fn tan(a: V) V {
                return _map(N, T, a, std.math.tan, .{});
            }

            pub inline fn trunc(a: V) V {
                return @trunc(a);
            }

            pub inline fn variance(a: V) T {
                return _dot(T, a, a) / @as(T, N);
            }
        };
    }
}

pub fn BVec(comptime N: u32) type {
    const V = @Vector(N, bool);
    return struct {
        pub const T = V;
        pub const C = bool;
        pub const N = N;

        pub const FALSE = @This().of(false);
        pub const TRUE = @This().of(true);

        pub inline fn all(v: V) bool {
            return @reduce(.And, v);
        }

        pub inline fn _not(a: V) V {
            return _map(N, bool, a, _bnot, .{});
        }

        pub inline fn _and(a: V, b: V) V {
            return _map2(N, bool, a, b, _band, .{});
        }

        pub inline fn _or(a: V, b: V) V {
            return _map2(N, bool, a, b, _bor, .{});
        }

        pub inline fn any(v: V) bool {
            return @reduce(.Or, v);
        }

        pub inline fn of(n: bool) V {
            return @splat(N, n);
        }

        pub inline fn select(mask: V, a: V, b: V) V {
            return @select(bool, mask, a, b);
        }
    };
}

fn VecSizeSpecific(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    const INFO = @typeInfo(T);
    const isFloat = INFO == .Float;
    if (N == 2) {
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
        } else base;
    } else if (N == 3) {
        return if (isFloat) struct {
            pub fn orthoNormal(a: V, b: V, c: V) V {
                return _normalize(T, cross(b - a, c - a), 1.0);
            }

            pub fn cross(a: V, b: V) V {
                const a1: V = [_]T{ a[1], a[2], a[0] };
                const a2: V = [_]T{ a[2], a[0], a[1] };
                const b1: V = [_]T{ b[2], b[0], b[1] };
                const b2: V = [_]T{ b[1], b[2], b[0] };
                return a1 * b1 - a2 * b2;
            }
        } else struct {
            pub fn fromVec2(a: @Vector(2, T), z: T) V {
                return [_]T{ a[0], a[1], z };
            }
        };
    } else if (N == 4) {
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

fn _map(comptime N: u32, comptime T: type, a: @Vector(N, T), comptime f: anytype, args: anytype) @TypeOf(a) {
    comptime var opts: std.builtin.CallOptions = .{};
    comptime var i = 0;
    var res: [N]T = undefined;
    inline while (i < N) : (i += 1) {
        res[i] = @call(opts, f, .{a[i]} ++ args);
    }
    return res;
}

fn _map2(comptime N: u32, comptime T: type, a: @Vector(N, T), b: @Vector(N, T), comptime f: anytype, args: anytype) @TypeOf(a) {
    comptime var opts: std.builtin.CallOptions = .{};
    comptime var i = 0;
    var res: [N]T = undefined;
    inline while (i < N) : (i += 1) {
        res[i] = @call(opts, f, .{ a[i], b[i] } ++ args);
    }
    return res;
}

inline fn _splat(comptime N: u32, comptime T: type, n: T) @Vector(N, T) {
    return @splat(N, n);
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
    return if (m > 1e-6) a * @splat(@typeInfo(@TypeOf(a)).Vector.len, n / m) else a;
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

pub const Vec2 = Vec(2, f32);
pub const Vec3 = Vec(3, f32);
pub const Vec4 = Vec(4, f32);

pub const IVec2 = Vec(2, i32);
pub const IVec3 = Vec(3, i32);
pub const IVec4 = Vec(4, i32);

pub const UVec2 = Vec(2, u32);
pub const UVec3 = Vec(3, u32);
pub const UVec4 = Vec(4, u32);

pub const BVec2 = BVec(2);
pub const BVec3 = BVec(3);
pub const BVec4 = BVec(4);

const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

test "Vec.argmin" {
    try expectEqual(@as(u32, 0), Vec4.argmin([_]f32{ -4, 3, 2, 1 }));
    try expectEqual(@as(u32, 1), Vec4.argmin([_]f32{ 4, -3, 2, 1 }));
    try expectEqual(@as(u32, 2), Vec4.argmin([_]f32{ 4, 3, -2, 1 }));
    try expectEqual(@as(u32, 3), Vec4.argmin([_]f32{ 4, 3, 2, -1 }));
}

test "Vec.argmax" {
    try expectEqual(@as(u32, 0), Vec4.argmax([_]f32{ 4, -3, -2, -1 }));
    try expectEqual(@as(u32, 1), Vec4.argmax([_]f32{ -4, 3, -2, -1 }));
    try expectEqual(@as(u32, 2), Vec4.argmax([_]f32{ -4, -3, 2, -1 }));
    try expectEqual(@as(u32, 3), Vec4.argmax([_]f32{ -4, -3, -2, 1 }));
}

test "Vec.centroid" {
    try expect(Vec3.equal(Vec3.centroid(&[_]Vec3.T{
        [_]f32{ 10, 100, 1000 },
        [_]f32{ 20, -200, -500 },
        [_]f32{ -60, 400, -800 },
    }), [_]f32{ -10, 100, -100 }));
}

test "Vec.clamp" {
    try expect(Vec3.equal(Vec3.clamp([_]f32{ -3, 2, 0.5 }, [_]f32{ -1, -1, -1 }, Vec3.ONE), [_]f32{ -1, 1, 0.5 }));
}

test "Vec.distSq" {
    try expectEqual(@as(i32, 75), IVec3.distSq([_]i32{ -4, 3, -2 }, [_]i32{ 1, -2, 3 }));
}

test "Vec.dot" {
    try expectEqual(@as(i32, -10 - 40 - 90), IVec3.dot([_]i32{ -1, 2, -3 }, [_]i32{ 10, -20, 30 }));
}

test "Vec.equal" {
    try expect(Vec2.equal([_]f32{ -1, 2 }, [_]f32{ -1, 2 }));
    try expect(!Vec2.equal([_]f32{ -1, 2 }, [_]f32{ -1.01, 2.01 }));
}

test "Vec.eqDelta" {
    try expect(Vec2.allEqDelta([_]f32{ -1, 2 }, [_]f32{ -1.09, 2.09 }, 0.1));
    try expect(!Vec2.allEqDelta([_]f32{ -1, 2 }, [_]f32{ -1.09, 2.09 }, 0.01));
    try expect(Vec(6, f32).allEqDelta([_]f32{ -1, 2, -3, 4, -5, 6 }, [_]f32{ -1.01, 2.01, -3.01, 4.01, -5.01, 6.01 }, 0.011));
    // unsupported for unsigned
    try expect(!@hasDecl(UVec2, "eqDelta"));
    try expect(!@hasDecl(UVec2, "allEqDelta"));
}

test "Vec2.perpendicular" {
    try expect(Vec2.allEqDelta(Vec2.perpendicularCCW([_]f32{ 1, 2 }), [_]f32{ -2, 1 }, 0));
    try expect(Vec2.allEqDelta(Vec2.perpendicularCW([_]f32{ 1, 2 }), [_]f32{ 2, -1 }, 0));
    try expect(IVec2.allEqDelta(IVec2.perpendicularCCW([_]i32{ 1, 2 }), [_]i32{ -2, 1 }, 0));
    try expect(IVec2.allEqDelta(IVec2.perpendicularCW([_]i32{ 1, 2 }), [_]i32{ 2, -1 }, 0));
    // unsupported/unimplemented for unsigned
    try expect(!@hasDecl(UVec2, "perpendicularCCW"));
    try expect(!@hasDecl(UVec2, "perpendicularCW"));
}
