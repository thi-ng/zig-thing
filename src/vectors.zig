const std = @import("std");
const math = @import("math.zig");

pub const vec2 = Vec(2, f32);
pub const vec3 = Vec(3, f32);
pub const vec4 = Vec(4, f32);

pub const ivec2 = Vec(2, i32);
pub const ivec3 = Vec(3, i32);
pub const ivec4 = Vec(4, i32);

pub const uvec2 = Vec(2, u32);
pub const uvec3 = Vec(3, u32);
pub const uvec4 = Vec(4, u32);

pub const bvec2 = Vec(2, bool);
pub const bvec3 = Vec(3, bool);
pub const bvec4 = Vec(4, bool);

/// Returns a zero-size namespace struct defining vector operations for
/// given size `SIZE` (min: 1) and component type `CTYPE` (any int, float or bool).
/// The actual vector type used for these operations is the built-in
/// `@Vector` aka SIMD-capable vectors. The ops defined here merely act
/// as a more unified and comprehensive API.
/// Depending on chosen component type `CTYPE`, some ops might not be
/// available (i.e. float vectors offer much more functionality than
/// their integer-based counterparts)
pub fn Vec(comptime size: u32, comptime ctype: type) type {
    const info = @typeInfo(ctype);
    if (!(info == .int or info == .float or info == .bool)) {
        @compileError("unsupported component type: " ++ ctype);
    }
    if (size < 1) @compileError("zero-length vectors not supported");
    if (info == .float) {
        return switch (size) {
            2 => Vec2f(ctype),
            3 => Vec3f(ctype),
            else => Vecf(size, ctype),
        };
    } else if (info == .int) {
        return if (info.int.signedness == .signed)
            switch (size) {
                2 => IVec2(ctype),
                3 => IVec3(ctype),
                else => IVec(size, ctype),
            }
        else
            UVec(size, ctype);
    }
    return BVec(size);
}

fn Vecf(comptime size: u32, comptime ctype: type) type {
    const common = CommonOps(size, ctype);
    const float = FloatOps(size, ctype);
    const sw = Swizzle(size, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = size;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const INF = float.INF;
        pub const NEG_INF = float.NEG_INF;
        pub const MINUS_ONE = float.MINUS_ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const z = sw.z;
        pub const w = sw.w;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // float ops

        pub const abs = float.abs;
        pub const acos = float.acos;
        pub const angleBetween = float.angleBetween;
        pub const asin = float.asin;
        pub const atan = float.atan;
        pub const atan2 = float.atan2;
        pub const ceil = float.ceil;
        pub const center = float.center;
        pub const clamp01 = float.clamp01;
        pub const cos = float.cos;
        pub const direction = float.direction;
        pub const dist = float.dist;
        pub const exp = float.exp;
        pub const exp2 = float.exp2;
        pub const fit = float.fit;
        pub const fitN = float.fitN;
        pub const fitClamped = float.fitClamped;
        pub const fitNClamped = float.fitNClamped;
        pub const fit01 = float.fit01;
        pub const floor = float.floor;
        pub const fract = float.fract;
        pub const invSqrt = float.invSqrt;
        pub const log = float.log;
        pub const log2 = float.log2;
        pub const log10 = float.log10;
        pub const mag = float.mag;
        pub const mean = float.mean;
        pub const mix = float.mix;
        pub const mixN = float.mixN;
        pub const mod = float.mod;
        pub const modN = float.modN;
        pub const normalize = float.normalize;
        pub const normalizeTo = float.normalizeTo;
        pub const pow = float.pow;
        pub const powN = float.powN;
        pub const reflect = float.reflect;
        pub const refract = float.refract;
        pub const round = float.round;
        pub const sd = float.sd;
        pub const sdError = float.sdError;
        pub const sin = float.sin;
        pub const smoothStep = float.smoothStep;
        pub const sqrt = float.sqrt;
        pub const standardize = float.standardize;
        pub const tan = float.tan;
        pub const trunc = float.trunc;
        pub const variance = float.variance;
    };
}

fn Vec2f(comptime ctype: type) type {
    const common = CommonOps(2, ctype);
    const float = FloatOps(2, ctype);
    const sw = Swizzle(2, ctype);
    const v2 = Vec2Common(common.V, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = 2;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const INF = float.INF;
        pub const NEG_INF = float.NEG_INF;
        pub const MINUS_ONE = float.MINUS_ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // float ops

        pub const abs = float.abs;
        pub const acos = float.acos;
        pub const angleBetween = float.angleBetween;
        pub const asin = float.asin;
        pub const atan = float.atan;
        pub const atan2 = float.atan2;
        pub const ceil = float.ceil;
        pub const center = float.center;
        pub const clamp01 = float.clamp01;
        pub const cos = float.cos;
        pub const direction = float.direction;
        pub const dist = float.dist;
        pub const exp = float.exp;
        pub const exp2 = float.exp2;
        pub const fit = float.fit;
        pub const fitN = float.fitN;
        pub const fitClamped = float.fitClamped;
        pub const fitNClamped = float.fitNClamped;
        pub const fit01 = float.fit01;
        pub const floor = float.floor;
        pub const fract = float.fract;
        pub const invSqrt = float.invSqrt;
        pub const log = float.log;
        pub const log2 = float.log2;
        pub const log10 = float.log10;
        pub const mag = float.mag;
        pub const mean = float.mean;
        pub const mix = float.mix;
        pub const mixN = float.mixN;
        pub const mod = float.mod;
        pub const modN = float.modN;
        pub const normalize = float.normalize;
        pub const normalizeTo = float.normalizeTo;
        pub const pow = float.pow;
        pub const powN = float.powN;
        pub const reflect = float.reflect;
        pub const refract = float.refract;
        pub const round = float.round;
        pub const sd = float.sd;
        pub const sdError = float.sdError;
        pub const sin = float.sin;
        pub const smoothStep = float.smoothStep;
        pub const sqrt = float.sqrt;
        pub const standardize = float.standardize;
        pub const tan = float.tan;
        pub const trunc = float.trunc;
        pub const variance = float.variance;

        // 2D specifics

        pub const cross = v2.cross;
        pub const perpendicularCCW = v2.perpendicularCCW;
        pub const perpendicularCW = v2.perpendicularCW;

        pub inline fn heading(a: V) T {
            return math.atanAbs(math.atan2(a[1], a[0]));
        }

        pub fn rotate(a: V, theta: T) V {
            const s = @sin(theta);
            const c = @cos(theta);
            return [_]T{
                a[0] * c - a[1] * s,
                a[0] * s + a[1] * c,
            };
        }
    };
}

fn Vec3f(comptime ctype: type) type {
    const common = CommonOps(3, ctype);
    const float = FloatOps(3, ctype);
    const sw = Swizzle(3, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = 3;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const INF = float.INF;
        pub const NEG_INF = float.NEG_INF;
        pub const MINUS_ONE = float.MINUS_ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const z = sw.z;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // float ops

        pub const abs = float.abs;
        pub const acos = float.acos;
        pub const angleBetween = float.angleBetween;
        pub const asin = float.asin;
        pub const atan = float.atan;
        pub const atan2 = float.atan2;
        pub const ceil = float.ceil;
        pub const center = float.center;
        pub const clamp01 = float.clamp01;
        pub const cos = float.cos;
        pub const direction = float.direction;
        pub const dist = float.dist;
        pub const exp = float.exp;
        pub const exp2 = float.exp2;
        pub const fit = float.fit;
        pub const fitN = float.fitN;
        pub const fitClamped = float.fitClamped;
        pub const fitNClamped = float.fitNClamped;
        pub const fit01 = float.fit01;
        pub const floor = float.floor;
        pub const fract = float.fract;
        pub const invSqrt = float.invSqrt;
        pub const log = float.log;
        pub const log2 = float.log2;
        pub const log10 = float.log10;
        pub const mag = float.mag;
        pub const mean = float.mean;
        pub const mix = float.mix;
        pub const mixN = float.mixN;
        pub const mod = float.mod;
        pub const modN = float.modN;
        pub const normalize = float.normalize;
        pub const normalizeTo = float.normalizeTo;
        pub const pow = float.pow;
        pub const powN = float.powN;
        pub const reflect = float.reflect;
        pub const refract = float.refract;
        pub const round = float.round;
        pub const sd = float.sd;
        pub const sdError = float.sdError;
        pub const sin = float.sin;
        pub const smoothStep = float.smoothStep;
        pub const sqrt = float.sqrt;
        pub const standardize = float.standardize;
        pub const tan = float.tan;
        pub const trunc = float.trunc;
        pub const variance = float.variance;

        // 3D specifics

        /// Cross-product of given 3D vectors
        pub fn cross(a: V, b: V) V {
            const a1: V = [_]T{ a[1], a[2], a[0] };
            const a2: V = [_]T{ a[2], a[0], a[1] };
            const b1: V = [_]T{ b[2], b[0], b[1] };
            const b2: V = [_]T{ b[1], b[2], b[0] };
            return (a1 * b1) - (a2 * b2);
        }

        pub fn orthoNormal(a: V, b: V, c: V) V {
            return _normalize(T, cross(b - a, c - a), 1.0);
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
    };
}

fn IVec(comptime size: u32, comptime ctype: type) type {
    const common = CommonOps(size, ctype);
    const int = IntOps(size, ctype);
    const sw = Swizzle(size, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = size;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const z = sw.z;
        pub const w = sw.w;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // type specific

        pub const abs = int.abs;
        pub const _not = int._not;
        pub const _and = int._and;
        pub const _or = int._or;
        pub const _xor = int._xor;
        pub const pow = int.pow;
        pub const powN = int.powN;
    };
}

fn IVec2(comptime ctype: type) type {
    const common = CommonOps(2, ctype);
    const int = IntOps(2, ctype);
    const sw = Swizzle(2, ctype);
    const v2 = Vec2Common(common.V, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = 2;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // type specific

        pub const abs = int.abs;
        pub const _not = int._not;
        pub const _and = int._and;
        pub const _or = int._or;
        pub const _xor = int._xor;
        pub const pow = int.pow;
        pub const powN = int.powN;

        // 2D specifics

        pub const cross = v2.cross;
        pub const perpendicularCCW = v2.perpendicularCCW;
        pub const perpendicularCW = v2.perpendicularCW;
    };
}

fn IVec3(comptime ctype: type) type {
    const common = CommonOps(3, ctype);
    const int = IntOps(3, ctype);
    const sw = Swizzle(3, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = 3;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const z = sw.z;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // type specifics

        pub const abs = int.abs;
        pub const _not = int._not;
        pub const _and = int._and;
        pub const _or = int._or;
        pub const _xor = int._xor;
        pub const pow = int.pow;
        pub const powN = int.powN;

        // 3d specifis

        pub fn cross(a: V, b: V) V {
            const a1: V = [_]T{ a[1], a[2], a[0] };
            const a2: V = [_]T{ a[2], a[0], a[1] };
            const b1: V = [_]T{ b[2], b[0], b[1] };
            const b2: V = [_]T{ b[1], b[2], b[0] };
            return (a1 * b1) - (a2 * b2);
        }
    };
}

fn UVec(comptime size: u32, comptime ctype: type) type {
    const common = CommonOps(size, ctype);
    const int = IntOps(size, ctype);
    const sw = Swizzle(size, ctype);

    return struct {
        pub const V = common.V;
        pub const B = common.B;
        pub const T = ctype;
        pub const N = size;
        pub const ZERO = common.ZERO;
        pub const ONE = common.ONE;

        pub const x = sw.x;
        pub const y = sw.y;
        pub const z = sw.z;
        pub const w = sw.w;
        pub const swizzle = sw.swizzle;

        pub const fromVec = common.fromVec;
        pub const of = common.of;
        pub const add = common.add;
        pub const addN = common.addN;
        pub const div = common.div;
        pub const divN = common.divN;
        pub const mul = common.mul;
        pub const mulN = common.mulN;
        pub const sub = common.sub;
        pub const subN = common.subN;

        pub const argmin = common.argmin;
        pub const argmax = common.argmax;
        pub const centroid = common.centroid;
        pub const clamp = common.clamp;
        pub const clampN = common.clampN;
        pub const distSq = common.distSq;
        pub const dot = common.dot;
        pub const equal = common.equal;
        pub const allEqDelta = common.allEqDelta;
        pub const eqDelta = common.eqDelta;
        pub const fill = common.fill;
        pub const isZero = common.isZero;
        pub const maddN = common.maddN;
        pub const magSq = common.magSq;
        pub const max = common.max;
        pub const maxComp = common.maxComp;
        pub const min = common.min;
        pub const minComp = common.minComp;
        pub const product = common.product;
        pub const step = common.step;
        pub const stepN = common.stepN;
        pub const sum = common.sum;

        // type specific

        pub const _not = int._not;
        pub const _and = int._and;
        pub const _or = int._or;
        pub const _xor = int._xor;
        pub const pow = int.pow;
        pub const powN = int.powN;
    };
}

fn BVec(comptime size: u32) type {
    const sw = Swizzle(size, bool);
    return struct {
        pub const V = @Vector(size, bool);
        pub const T = bool;
        pub const N = size;

        pub const FALSE = @This().of(false);
        pub const TRUE = @This().of(true);

        pub const x = sw.x;
        pub const y = sw.y;
        pub const z = sw.z;
        pub const w = sw.w;
        pub const swizzle = sw.swizzle;

        pub fn fromVec(a: anytype, pad: bool) V {
            const ainfo = @typeInfo(@TypeOf(a));
            const aIsVec = ainfo == .vector;
            if (!(aIsVec or ainfo == .array)) @compileError("expected vector type");
            const atype = if (aIsVec) @typeInfo(ainfo.vector.child) else @typeInfo(ainfo.array.child);
            const aIsBool = atype == .bool;
            if (!(aIsBool or atype == .int or atype == .float)) @compileError("unsupported component type: " ++ @typeName(atype));
            const asize = @min(N, if (aIsVec) ainfo.vector.len else ainfo.array.len);
            comptime var i = 0;
            var res = [_]bool{pad} ** N;
            inline while (i < asize) : (i += 1) {
                res[i] = if (aIsBool) a[i] else a[i] != 0;
            }
            return res;
        }

        pub inline fn all(v: V) bool {
            return @reduce(.And, v);
        }

        pub fn _not(a: V) V {
            return _map(size, bool, a, _bnot, .{});
        }

        pub fn _and(a: V, b: V) V {
            return _map2(size, bool, a, b, _band, .{});
        }

        pub fn _or(a: V, b: V) V {
            return _map2(size, bool, a, b, _bor, .{});
        }

        pub inline fn any(v: V) bool {
            return @reduce(.Or, v);
        }

        pub inline fn equal(a: V, b: V) bool {
            return all(a == b);
        }

        pub fn fill(buf: []V, val: V) void {
            for (buf, 0..) |_, i| {
                buf[i] = val;
            }
        }

        pub inline fn of(n: bool) V {
            return @splat(n);
        }

        pub inline fn select(mask: V, a: V, b: V) V {
            return @select(bool, mask, a, b);
        }
    };
}

fn CommonOps(comptime N: u32, comptime T: type) type {
    const info = @typeInfo(T);
    const isInt = info == .int;
    const isUint = isInt and info.int.signedness == .unsigned;
    return struct {
        /// Vector type: `@Vector(SIZE, CTYPE)`
        pub const V = @Vector(N, T);
        /// Boolean vector type: `@Vector(SIZE, bool)`
        pub const B = @Vector(N, bool);

        /// Vector w/ all components as 0
        pub const ZERO = of(0);
        /// Vector w/ all components as 1
        pub const ONE = of(1);

        pub fn fromVec(a: anytype, x: T) V {
            const ainfo = @typeInfo(@TypeOf(a));
            if (!(ainfo == .vector or ainfo == .array)) @compileError("expected vector type");
            const atype = if (ainfo == .vector) @typeInfo(ainfo.vector.child) else @typeInfo(ainfo.array.child);
            const aIsBool = atype == .bool;
            const aIsInt = atype == .int;
            if (!(aIsBool or aIsInt or atype == .float)) @compileError("unsupported component type: " ++ @typeName(atype));
            const asize = @min(N, if (ainfo == .vector) ainfo.vector.len else ainfo.array.len);
            comptime var i = 0;
            var res = [_]T{x} ** N;
            inline while (i < asize) : (i += 1) {
                res[i] = if (aIsBool)
                    if (a[i]) 1 else 0
                else if (isInt)
                    if (aIsInt)
                        @as(T, @intCast(a[i]))
                    else
                        @as(T, @intFromFloat(a[i]))
                else if (aIsInt)
                    @as(T, @floatFromInt(a[i]))
                else
                    @as(T, @floatCast(a[i]));
            }
            return res;
        }

        // base ops
        pub inline fn of(n: T) V {
            return @as(V, @splat(n));
        }

        pub inline fn add(a: V, b: V) V {
            return a + b;
        }

        pub inline fn addN(a: V, n: T) V {
            return a + of(n);
        }

        pub inline fn div(a: V, b: V) V {
            return if (info == .int) @divTrunc(a, b) else a / b;
        }

        pub inline fn divN(a: V, n: T) V {
            return if (info == .int) @divTrunc(a, of(n)) else a / of(n);
        }

        pub inline fn mul(a: V, b: V) V {
            return a * b;
        }

        pub inline fn mulN(a: V, n: T) V {
            return a * of(n);
        }

        pub inline fn sub(a: V, b: V) V {
            return a - b;
        }

        pub inline fn subN(a: V, n: T) V {
            return a - of(n);
        }

        // eq delta

        pub fn allEqDelta(a: V, b: V, eps: T) bool {
            return BVec(N).all(eqDelta(a, b, eps));
        }

        pub fn eqDelta(a: V, b: V, eps: T) @Vector(N, bool) {
            if (isUint) {
                const iv = IVec(
                    N,
                    @Type(.{ .int = .{
                        .signedness = .signed,
                        .bits = @typeInfo(T).int.bits,
                    } }),
                );
                return iv.eqDelta(@intCast(a), @intCast(b), @intCast(eps));
            }
            const delta = a - b;
            const invDelta = -delta;
            return @select(T, delta > invDelta, delta, invDelta) <= @as(V, @splat(eps));
        }

        //////////// misc (A-Z order)

        pub fn argmin(a: V) u32 {
            var res: u32 = 0;
            var acc: T = a[0];
            var i: u32 = 1;
            while (i < N) : (i += 1) {
                if (a[i] < acc) {
                    acc = a[i];
                    res = i;
                }
            }
            return res;
        }

        pub fn argmax(a: V) u32 {
            var res: u32 = 0;
            var acc: T = a[0];
            var i: u32 = 1;
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

        pub fn clampN(a: V, b: T, c: T) V {
            return min(max(a, of(b)), of(c));
        }

        pub inline fn dot(a: V, b: V) T {
            return _dot(T, a, b);
        }

        pub inline fn distSq(a: V, b: V) T {
            return magSq(a - b);
        }

        pub inline fn equal(a: V, b: V) bool {
            return BVec(N).all(a == b);
        }

        pub fn fill(buf: []V, val: V) void {
            for (buf, 0..) |_, i| {
                buf[i] = val;
            }
        }

        pub inline fn isZero(a: V) bool {
            return BVec(N).all(a == ZERO);
        }

        pub inline fn maddN(a: V, n: T, b: V) V {
            return a * of(n) + b;
        }

        pub inline fn magSq(a: V) T {
            return _dot(T, a, a);
        }

        pub inline fn max(a: V, b: V) V {
            return select(a > b, a, b);
        }

        pub inline fn maxComp(a: V) T {
            return @reduce(.Max, a);
        }

        pub inline fn min(a: V, b: V) V {
            return select(a < b, a, b);
        }

        pub inline fn minComp(a: V) T {
            return @reduce(.Min, a);
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

        pub inline fn stepN(edge: T, a: V) V {
            return select(a < of(edge), ZERO, ONE);
        }

        pub inline fn sum(a: V) T {
            return @reduce(.Add, a);
        }
    };
}

fn FloatOps(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    return struct {
        pub const INF: V = @splat(std.math.inf(T));
        pub const NEG_INF: V = @splat(-std.math.inf(T));

        /// Vector w/ all components as -1
        pub const MINUS_ONE: V = @splat(-1);

        pub inline fn abs(a: V) V {
            return @abs(a);
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
            return _map2(N, T, a, b, math.atan2, .{});
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
            return @reduce(.Add, a) / @as(T, N);
        }

        pub inline fn mix(a: V, b: V, t: V) V {
            return a + (b - a) * t;
        }

        pub inline fn mixN(a: V, b: V, n: T) V {
            return mix(a, b, @splat(n));
        }

        pub inline fn mod(a: V, b: V) V {
            return _map2(N, T, a, b, math.mod, .{});
        }

        pub inline fn modN(a: V, b: T) V {
            return _map2(N, T, a, @splat(b), math.mod, .{});
        }

        pub inline fn normalize(a: V) V {
            return normalizeTo(a, 1.0);
        }

        pub inline fn normalizeTo(a: V, n: T) V {
            const m = mag(a);
            return if (m > 1e-6) a * @as(V, @splat(n / m)) else a;
        }

        pub inline fn pow(a: V, b: V) V {
            return _map2(N, T, a, b, math.pow, .{});
        }

        pub inline fn powN(a: V, n: T) V {
            return _map(N, T, a, math.pow, .{n});
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

fn IntOps(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    return struct {
        pub inline fn abs(a: V) V {
            return @select(T, a >= @as(V, @splat(0)), a, -a);
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

        pub inline fn pow(a: V, b: V) V {
            return _map2(N, T, a, b, math.powi, .{});
        }

        pub inline fn powN(a: V, n: T) V {
            return _map(N, T, a, math.powi, .{n});
        }
    };
}

fn Vec2Common(comptime V: type, comptime T: type) type {
    return struct {
        pub inline fn cross(a: V, b: V) T {
            return a[0] * b[1] - a[1] * b[0];
        }

        pub fn perpendicularCCW(a: V) V {
            return [_]T{ -a[1], a[0] };
        }

        pub fn perpendicularCW(a: V) V {
            return [_]T{ a[1], -a[0] };
        }
    };
}

fn Swizzle(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    return struct {
        pub inline fn x() T {
            return x[0];
        }

        pub inline fn y() T {
            return if (N > 1) x[1] else @compileError("index out of bounds");
        }

        pub inline fn z() T {
            return if (N > 2) x[2] else @compileError("index out of bounds");
        }

        pub inline fn w() T {
            return if (N > 3) x[3] else @compileError("index out of bounds");
        }

        pub fn swizzle(a: V, comptime id: []const u8) @Vector(id.len, T) {
            var res: [id.len]T = undefined;
            comptime var i = 0;
            inline while (i < id.len) : (i += 1) {
                const idx = switch (id[i]) {
                    'x' => 0,
                    'y' => 1,
                    'z' => 2,
                    'w' => 3,
                    else => @compileError("illegal swizzle: " ++ id[i]),
                };
                res[i] = a[idx];
            }
            return res;
        }
    };
}

inline fn _dot(comptime T: type, a: anytype, b: anytype) T {
    return @reduce(.Add, a * b);
}

fn _map(
    comptime size: u32,
    comptime T: type,
    a: @Vector(size, T),
    comptime f: anytype,
    args: anytype,
) @TypeOf(a) {
    comptime var i = 0;
    var res: [size]T = undefined;
    inline while (i < size) : (i += 1) {
        res[i] = @call(.{}, f, .{a[i]} ++ args);
    }
    return res;
}

fn _map2(
    comptime size: u32,
    comptime T: type,
    a: @Vector(size, T),
    b: @Vector(size, T),
    comptime f: anytype,
    args: anytype,
) @TypeOf(a) {
    comptime var i = 0;
    var res: [size]T = undefined;
    inline while (i < size) : (i += 1) {
        res[i] = @call(.{}, f, .{ a[i], b[i] } ++ args);
    }
    return res;
}

fn _normalize(comptime T: type, a: anytype, n: anytype) @TypeOf(a) {
    const m = @sqrt(_dot(T, a, a));
    return if (m > 1e-6) a * @as(@TypeOf(a), @splat(n / m)) else a;
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

test "swizzle" {
    try std.testing.expectEqual([_]f32{1}, vec2.swizzle([_]f32{ 1, 2 }, "x"));
    try std.testing.expectEqual([_]f32{ 2, 1 }, vec2.swizzle([_]f32{ 1, 2 }, "yx"));
    try std.testing.expectEqual([_]f32{ 1, 2, 1 }, vec2.swizzle([_]f32{ 1, 2 }, "xyx"));
    try std.testing.expectEqual([_]f32{ 1, 1, 2, 2 }, vec2.swizzle([_]f32{ 1, 2 }, "xxyy"));
}

test "fromVec" {
    try std.testing.expectEqual([_]f32{ 1, 0, 10 }, vec3.fromVec([_]bool{ true, false }, 10));
    try std.testing.expectEqual([_]f32{ 1, 2, 10 }, vec3.fromVec([_]i8{ 1, 2 }, 10));
    try std.testing.expectEqual([_]f32{ 1, 2, 10 }, vec3.fromVec(@as(@Vector(2, f64), [_]f64{ 1, 2 }), 10));
    try std.testing.expectEqual([_]f32{ 1, 2, 3 }, vec3.fromVec([_]f64{ 1, 2, 3, 4 }, 10));
}

test "vec.add" {
    try std.testing.expectEqual([_]f32{ 11, 22, 33 }, vec3.add([_]f32{ 1, 2, 3 }, [_]f32{ 10, 20, 30 }));
    try std.testing.expectEqual([_]f32{ 11, 12, 13 }, vec3.addN([_]f32{ 1, 2, 3 }, 10));
}

test "vec.div" {
    try std.testing.expectEqual([_]f32{ 1.0 / 10.0, 2.0 / 20.0, 3.0 / 30.0 }, vec3.div([_]f32{ 1, 2, 3 }, [_]f32{ 10, 20, 30 }));
    try std.testing.expectEqual([_]f32{ 1.0 / 10.0, 2.0 / 10.0, 3.0 / 10.0 }, vec3.divN([_]f32{ 1, 2, 3 }, 10));
}

test "vec.mul" {
    try std.testing.expectEqual([_]f32{ 10, 40, 90 }, vec3.mul([_]f32{ 1, 2, 3 }, [_]f32{ 10, 20, 30 }));
    try std.testing.expectEqual([_]f32{ 10, 20, 30 }, vec3.mulN([_]f32{ 1, 2, 3 }, 10));
}

test "vec.sub" {
    try std.testing.expectEqual([_]f32{ 1 - 10, 2 - 20, 3 - 30 }, vec3.sub([_]f32{ 1, 2, 3 }, [_]f32{ 10, 20, 30 }));
    try std.testing.expectEqual([_]f32{ 1 - 10, 2 - 10, 3 - 10 }, vec3.subN([_]f32{ 1, 2, 3 }, 10));
}

test "vec.abs" {
    try std.testing.expectEqual([_]f32{ 1, 2 }, vec2.abs([_]f32{ -1, 2 }));
}

test "vec.angleBetween" {
    try std.testing.expectApproxEqAbs(std.math.pi / 2.0, vec2.angleBetween(vec2.normalize([_]f32{ 1, -1 }), vec2.normalize([_]f32{ 1, 1 })), 1e-3);
    try std.testing.expectApproxEqAbs(std.math.pi, vec2.angleBetween(vec2.normalize([_]f32{ -1, -1 }), vec2.normalize([_]f32{ 1, 1 })), 1e-3);
}

test "vec.ceil" {
    try std.testing.expectEqual([_]f32{ 2, -1 }, vec2.ceil([_]f32{ 1.2, -1.2 }));
}

test "vec.center" {
    try std.testing.expectEqual([_]f32{ -0.5, 0.5 }, vec2.center([_]f32{ 1, 2 }));
}

test "vec.clamp" {
    try std.testing.expectEqual([_]f32{ 0, 1 }, vec2.clamp([_]f32{ -1, 2 }, vec2.ZERO, vec2.ONE));
    try std.testing.expectEqual([_]f32{ 0, 1 }, vec2.clamp01([_]f32{ -1, 2 }));
}

test "perpendicular" {
    try std.testing.expectEqual([_]f32{ -2, 1 }, vec2.perpendicularCCW([_]f32{ 1, 2 }));
    try std.testing.expectEqual([_]f32{ 2, -1 }, vec2.perpendicularCW([_]f32{ 1, 2 }));
}

test "bvec.fromVec" {
    try std.testing.expectEqual([_]bool{ true, false, true }, bvec3.fromVec([_]bool{ true, false }, true));
    try std.testing.expectEqual([_]bool{ false, true, true }, bvec3.fromVec([_]u8{ 0, 1 }, true));
}

test "Vec.argmin" {
    try std.testing.expectEqual(@as(usize, 0), vec4.argmin([_]f32{ -4, 3, 2, 1 }));
    try std.testing.expectEqual(@as(usize, 1), vec4.argmin([_]f32{ 4, -3, 2, 1 }));
    try std.testing.expectEqual(@as(usize, 2), vec4.argmin([_]f32{ 4, 3, -2, 1 }));
    try std.testing.expectEqual(@as(usize, 3), vec4.argmin([_]f32{ 4, 3, 2, -1 }));
}

test "Vec.argmax" {
    try std.testing.expectEqual(@as(usize, 0), vec4.argmax([_]f32{ 4, -3, -2, -1 }));
    try std.testing.expectEqual(@as(usize, 1), vec4.argmax([_]f32{ -4, 3, -2, -1 }));
    try std.testing.expectEqual(@as(usize, 2), vec4.argmax([_]f32{ -4, -3, 2, -1 }));
    try std.testing.expectEqual(@as(usize, 3), vec4.argmax([_]f32{ -4, -3, -2, 1 }));
}

test "Vec.centroid" {
    try std.testing.expect(vec3.equal(vec3.centroid(&[_]vec3.V{
        [_]f32{ 10, 100, 1000 },
        [_]f32{ 20, -200, -500 },
        [_]f32{ -60, 400, -800 },
    }), [_]f32{ -10, 100, -100 }));
}

test "Vec.clamp" {
    try std.testing.expect(vec3.equal(vec3.clamp([_]f32{ -3, 2, 0.5 }, [_]f32{ -1, -1, -1 }, vec3.ONE), [_]f32{ -1, 1, 0.5 }));
}

test "Vec.distSq" {
    try std.testing.expectEqual(@as(i32, 75), ivec3.distSq([_]i32{ -4, 3, -2 }, [_]i32{ 1, -2, 3 }));
}

test "Vec.dot" {
    try std.testing.expectEqual(@as(i32, -10 - 40 - 90), ivec3.dot([_]i32{ -1, 2, -3 }, [_]i32{ 10, -20, 30 }));
}

test "Vec.equal" {
    try std.testing.expect(vec2.equal([_]f32{ -1, 2 }, [_]f32{ -1, 2 }));
    try std.testing.expect(!vec2.equal([_]f32{ -1, 2 }, [_]f32{ -1.01, 2.01 }));
}

test "Vec.eqDelta" {
    try std.testing.expect(vec2.allEqDelta([_]f32{ -1, 2 }, [_]f32{ -1.09, 2.09 }, 0.1));
    try std.testing.expect(!vec2.allEqDelta([_]f32{ -1, 2 }, [_]f32{ -1.09, 2.09 }, 0.01));
    try std.testing.expect(Vec(6, f32).allEqDelta([_]f32{ -1, 2, -3, 4, -5, 6 }, [_]f32{ -1.01, 2.01, -3.01, 4.01, -5.01, 6.01 }, 0.011));
}

test "Vec2.perpendicular" {
    try std.testing.expect(vec2.allEqDelta(vec2.perpendicularCCW([_]f32{ 1, 2 }), [_]f32{ -2, 1 }, 0));
    try std.testing.expect(vec2.allEqDelta(vec2.perpendicularCW([_]f32{ 1, 2 }), [_]f32{ 2, -1 }, 0));
    try std.testing.expect(ivec2.allEqDelta(ivec2.perpendicularCCW([_]i32{ 1, 2 }), [_]i32{ -2, 1 }, 0));
    try std.testing.expect(ivec2.allEqDelta(ivec2.perpendicularCW([_]i32{ 1, 2 }), [_]i32{ 2, -1 }, 0));
}

test "Vec4.isZero" {
    try std.testing.expectEqual(
        @as(vec4.V, [_]f32{ 10, 0, -20, 0 }) == vec4.ZERO,
        @as(bvec4.V, [_]bool{ false, true, false, true }),
    );
}
