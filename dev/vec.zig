const std = @import("std");

pub fn Vec(comptime T: type, comptime size: u32) type {
    if (@typeInfo(T) != .Float and @typeInfo(T) != .Int) {
        @compileError("Unsupported Vec element type " ++ @typeName(T));
    }

    return struct {
        data: [size]T = [_]T{0} ** size,

        const Self = @This();

        pub inline fn x(self: *const Self) T {
            return self.data[0];
        }

        pub inline fn y(self: *const Self) T {
            return self.data[1];
        }

        pub inline fn z(self: *const Self) T {
            return self.data[2];
        }

        pub inline fn w(self: *const Self) T {
            return self.data[3];
        }

        pub fn fromSlice(slice: []const T) Self {
            var res = Self{};
            for (slice) |v, i| {
                res.data[i] = v;
            }
            return res;
        }

        pub fn zero(self: *Self) *Self {
            return self.setN(0);
        }

        pub fn one(self: *Self) *Self {
            return self.setN(1);
        }

        pub fn set(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = a.data[i];
            }
            return self;
        }

        pub fn setN(self: *Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = n;
            }
            return self;
        }

        pub fn swizzle2(self: *const Self, a: u32, b: u32) Vec(T, 2) {
            return Vec(T, 2){
                .data = [_]T{ self.data[a], self.data[b] },
            };
        }

        pub fn swizzle3(self: *const Self, a: u32, b: u32, c: u32) Vec(T, 3) {
            return Vec(T, 3){
                .data = [_]T{
                    self.data[a],
                    self.data[b],
                    self.data[c],
                },
            };
        }

        pub fn swizzle4(self: *const Self, a: u32, b: u32, c: u32, d: u32) Vec(T, 4) {
            return Vec(T, 4){
                .data = [_]T{
                    self.data[a],
                    self.data[b],
                    self.data[c],
                    self.data[d],
                },
            };
        }

        pub fn copy(self: *const Self) Self {
            return Self{
                .data = self.data,
            };
        }

        pub fn eq(self: *const Self, a: *const Self) bool {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                if (self.data[i] != a.data[i]) return false;
            }
            return true;
        }

        pub fn eqDelta(self: *const Self, a: *const Self, eps: T) bool {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                const v = self.data[i] - a.data[i];
                if (v < eps or v > eps) return false;
            }
            return true;
        }

        pub fn add(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] += a.data[i];
            }
            return self;
        }

        pub fn addN(self: *Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] += n;
            }
            return self;
        }

        pub fn sub(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] -= a.data[i];
            }
            return self;
        }

        pub fn subN(self: *Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] -= n;
            }
            return self;
        }

        pub fn mul(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] *= a.data[i];
            }
            return self;
        }

        pub fn mulN(self: *Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] *= n;
            }
            return self;
        }

        pub fn div(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] /= a.data[i];
            }
            return self;
        }

        pub fn divN(self: *Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] /= n;
            }
            return self;
        }

        pub fn madd(self: *Self, a: *const Self, b: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] += a.data[i] * b[i];
            }
            return self;
        }

        pub fn maddN(self: *Self, a: *const Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = std.math.fma(T, a.data[i], n, self.data[i]);
            }
            return self;
        }

        pub fn mix(self: *Self, a: *const Self, t: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                // self.data[i] += (a.data[i] - self.data[i]) * t.data[i];
                self.data[i] = std.math.fma(a.data[i] - self.data[i], t.data[i], self.data[i]);
            }
            return self;
        }

        pub fn mixN(self: *Self, a: *const Self, t: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                //  self.data[i] += (a.data[i] - self.data[i]) * t;
                self.data[i] = std.math.fma(a.data[i] - self.data[i], t, self.data[i]);
            }
            return self;
        }

        pub fn dot(self: *const Self, a: *const Self) T {
            var i: usize = 0;
            var res: T = 0;
            while (i < size) : (i += 1) {
                res += self.data[i] * a.data[i];
            }
            return res;
        }

        pub fn magSq(self: *const Self) T {
            return self.dot(self);
        }

        pub fn mag(self: *const Self) T {
            return @sqrt(self.dot(self));
        }

        pub fn normalize(self: *Self) *Self {
            return self.normalizeN(1);
        }

        pub fn normalizeN(self: *Self, n: T) *Self {
            var m: T = self.dot(self);
            if (m > 1e-12) {
                _ = self.mulN(n / @sqrt(m));
            }
            return self;
        }

        pub fn limit(self: *Self, n: T) *Self {
            var m: T = self.dot(self);
            if (m > n * n) {
                _ = self.mulN(n / @sqrt(m));
            }
            return self;
        }

        pub fn vsum(self: *const Self) T {
            var sum: T = 0;
            for (self.data) |v| {
                sum += v;
            }
            return sum;
        }

        pub fn abs(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                if (@typeInfo(T) == .Float) {
                    self.data[i] = @fabs(self.data[i]);
                } else {
                    if (self.data[i] < 0) self.data[i] *= -1;
                }
            }
            return self;
        }

        pub fn neg(self: *Self) *Self {
            return self.mulN(-1);
        }

        pub fn min(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @minimum(self.data[i], a.data[i]);
            }
            return self;
        }

        pub fn max(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @maximum(self.data[i], a.data[i]);
            }
            return self;
        }

        pub fn minId(self: *const Self) u32 {
            var id: u32 = 0;
            var acc: T = self.data[0];
            var i: usize = 1;
            while (i < size) : (i += 1) {
                if (self.data[i] < acc) {
                    id = i;
                    acc = self.data[i];
                }
            }
            return id;
        }

        pub fn maxId(self: *const Self) u32 {
            var id: u32 = 0;
            var acc: T = self.data[0];
            var i: usize = 1;
            while (i < size) : (i += 1) {
                if (self.data[i] > acc) {
                    id = i;
                    acc = self.data[i];
                }
            }
            return id;
        }

        pub fn clamp(self: *Self, a: *const Self, b: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                if (self.data[i] < a.data[i]) {
                    self.data[i] = a.data[i];
                } else if (self.data[i] > b.data[i]) {
                    self.data[i] = b.data[i];
                }
            }
            return self;
        }

        pub fn clamp01(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                if (self.data[i] < 0) {
                    self.data[i] = 0;
                } else if (self.data[i] > 1) {
                    self.data[i] = 1;
                }
            }
            return self;
        }

        pub fn fit(self: *Self, a: *const Self, b: *const Self, c: *const Self, d: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                const aa = a.data[i];
                const bb = b.data[i];
                const cc = c.data[i];
                const dd = d.data[i];
                var norm: T = if (bb != aa) 1 / (bb - aa) else 0;
                self.data[i] = cc + (dd - cc) * (self.data[i] - aa) * norm;
            }
        }

        pub fn fitClamped(self: *Self, a: *const Self, b: *const Self, c: *const Self, d: *const Self) *Self {
            return self.clamp(a, b).fit(a, b, c, d);
        }

        pub fn fit01(self: *Self, a: *const Self, b: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = a.data[i] + (b.data[i] - a.data[i]) * self.data[i];
            }
            return self;
        }

        pub fn floor(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @floor(self.data[i]);
            }
            return self;
        }

        pub fn ceil(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @ceil(self.data[i]);
            }
            return self;
        }

        pub fn round(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @round(self.data[i]);
            }
            return self;
        }

        pub fn roundTo(self: *Self, n: T) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @round(self.data[i] / n) * n;
            }
            return self;
        }

        pub fn step(self: *Self, a: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = if (self.data[i] >= a.data[i]) 1 else 0;
            }
            return self;
        }

        pub fn smoothStep(self: *Self, a: *const Self, b: *const Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                var v: T = (self.data[i] - a.data[i]) / (b.data[i] - a.data[i]);
                v = if (v < 0) 0 else if (v > 1) 1 else v;
                self.data[i] = (3 - 2 * v) * v * v;
            }
            return self;
        }

        pub fn exp(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @exp(self.data[i]);
            }
            return self;
        }

        pub fn exp2(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @exp2(self.data[i]);
            }
            return self;
        }

        pub fn log(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @log(self.data[i]);
            }
            return self;
        }

        pub fn log2(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @log2(self.data[i]);
            }
            return self;
        }

        pub fn log10(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @log10(self.data[i]);
            }
            return self;
        }

        pub fn sqrt(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @sqrt(self.data[i]);
            }
            return self;
        }

        pub fn invSqrt(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = 1 / @sqrt(self.data[i]);
            }
            return self;
        }

        pub fn sin(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @sin(self.data[i]);
            }
            return self;
        }

        pub fn cos(self: *Self) *Self {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                self.data[i] = @cos(self.data[i]);
            }
            return self;
        }

        pub fn isZero(self: *const Self) bool {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                if (self.data[i] != 0) return false;
            }
            return true;
        }

        pub fn any(self: *const Self) bool {
            return !self.isZero();
        }

        pub fn every(self: *const Self) bool {
            var i: usize = 0;
            while (i < size) : (i += 1) {
                if (self.data[i] == 0) return false;
            }
            return true;
        }
    };
}

const Vec2f = Vec(f32, 2);
const Vec3f = Vec(f32, 3);
const Vec4f = Vec(f32, 4);

const Vec3i = Vec(i32, 3);

fn vec3(x: f32, y: f32, z: f32) Vec3f {
    return Vec3f{ .data = [_]f32{ x, y, z } };
}

export fn add3(a: *Vec3f, b: *Vec3f, c: *Vec3f) *Vec3f {
    c.* = a.copy().add(b).*;
    return c;
}

export fn add4(a: *Vec4f, b: *Vec4f, c: *Vec4f) *Vec4f {
    c.* = a.copy().add(b).*;
    return c;
}

export fn normalize3(a: *Vec3f, b: *Vec3f) *Vec3f {
    b.* = a.copy().normalize().*;
    return b;
}

export fn zero4(a: *Vec4f, b: *Vec4f) *Vec4f {
    b.* = a.copy().zero().*;
    return b;
}

export fn exp3(a: *Vec3f) *Vec3f {
    a.* = a.copy().exp().*;
    return a;
}

export fn testAdd(c: *Vec3f) *Vec3f {
    const a = vec3(1, 2, 3);
    var b = Vec3f{};
    _ = b.zero();
    c.* = a.copy().add(&b).*;
    return c;
}

export fn testSwizzle(c: *Vec4f) *Vec4f {
    var a = vec3(1, 2, 3);
    a.data[0] = a.dot(&a);
    c.* = a.swizzle4(2, 2, 1, 0);
    return c;
}

pub fn main() void {
    var a = Vec3f{ .data = [_]f32{ 1, 2, 3 } };
    const b = a.copy();
    const c = a.add(&b);
    std.debug.print("a: {}\n", .{a});
    std.debug.print("b: {}\n", .{b});
    std.debug.print("c: {} {}\n", .{ c, &c });
    std.debug.print("a: {}\n", .{a});
    _ = a.add(c);
    std.debug.print("a: {}\n", .{a});
}
