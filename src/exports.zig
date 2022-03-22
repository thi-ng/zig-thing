const vec = @import("main.zig");

const Vec2 = vec.Vec2;
const Vec3 = vec.Vec3;
const Vec4 = vec.Vec4;

const IVec3 = vec.IVec3;
const IVec4 = vec.IVec4;

const UVec4 = vec.UVec4;

const BVec3 = vec.BVec3;
const BVec4 = vec.BVec4;

export fn addN2(a: *Vec2.T, n: f32) *Vec2.T {
    a.* = Vec2.addN(a.*, n);
    return a;
}

export fn addN3(a: *Vec3.T, n: f32) *Vec3.T {
    a.* = Vec3.addN(a.*, n);
    return a;
}

export fn addN4(a: *Vec4.T, n: f32) *Vec4.T {
    a.* = Vec4.addN(a.*, n);
    return a;
}

export fn divN3(a: *Vec3.T, n: f32) *Vec3.T {
    a.* = Vec3.divN(a.*, n);
    return a;
}

export fn divNI4(a: *IVec4.T, n: i32) *IVec4.T {
    a.* = IVec4.divN(a.*, n);
    return a;
}

export fn divNU4(a: *UVec4.T, n: u32) *UVec4.T {
    a.* = UVec4.divN(a.*, n);
    return a;
}

export fn dot3(a: *const Vec3.T, b: *const Vec3.T) f32 {
    return Vec3.dot(a.*, b.*);
}

export fn normalize3(a: *Vec3.T) *Vec3.T {
    a.* = Vec3.normalize(a.*);
    return a;
}

export fn maddN3(a: *Vec3.T, b: *const Vec3.T, c: f32) *Vec3.T {
    a.* = Vec3.maddN(a.*, b.*, c);
    return a;
}

export fn cross3(a: *Vec3.T, b: *const Vec3.T) *Vec3.T {
    a.* = Vec3.cross(a.*, b.*);
    return a;
}

export fn orthoNormal3(a: *Vec3.T, b: *const Vec3.T, c: *const Vec3.T) *Vec3.T {
    a.* = Vec3.orthoNormal(a.*, b.*, c.*);
    return a;
}

export fn min3(a: *Vec3.T, b: *const Vec3.T) *Vec3.T {
    a.* = Vec3.min(a.*, b.*);
    return a;
}

export fn eqDelta3(a: *const Vec3.T, b: *const Vec3.T) bool {
    return Vec3.allEqDelta(a.*, b.*, 1e-6);
}

export fn isZero3(a: *const Vec3.T) bool {
    return Vec3.isZero(a.*);
}

export fn isZero3E(a: *const Vec3.T) bool {
    return Vec3.allEqDelta(a.*, Vec3.ZERO, 1e-6);
}

export fn swizzle(a: *const IVec3.T, b: *IVec3.T) *IVec3.T {
    b.* = IVec3.zzy(a.*);
    return b;
}

export fn clamp3(a: *Vec3.T, b: *const Vec3.T, c: *const Vec3.T) *Vec3.T {
    a.* = Vec3.clamp(a.*, b.*, c.*);
    return a;
}

export fn clamp3_01(a: *Vec3.T) *Vec3.T {
    a.* = Vec3.clamp01(a.*);
    return a;
}

export fn pow3(a: *Vec3.T, b: *Vec3.T) *Vec3.T {
    a.* = Vec3.pow(a.*, b.*);
    return a;
}

export fn sin3(a: *Vec3.T) *Vec3.T {
    a.* = Vec3.sin(a.*);
    return a;
}

export fn tan3(a: *Vec3.T) *Vec3.T {
    a.* = Vec3.tan(a.*);
    return a;
}

export fn smoothStep3(e0: *Vec3.T, e1: *Vec3.T, a: *Vec3.T) *Vec3.T {
    a.* = Vec3.smoothStep(e0.*, e1.*, a.*);
    return a;
}

export fn reflect3(a: *Vec3.T, b: *Vec3.T) *Vec3.T {
    a.* = Vec3.reflect(a.*, b.*);
    return a;
}

export fn refract3(a: *Vec3.T, b: *Vec3.T, c: f32) *Vec3.T {
    a.* = Vec3.refract(a.*, b.*, c);
    return a;
}

export fn standardize3(a: *Vec3.T) *Vec3.T {
    a.* = Vec3.standardize(a.*);
    return a;
}

export fn mod3(a: *Vec3.T, b: *Vec3.T) *Vec3.T {
    a.* = Vec3.mod(a.*, b.*);
    return a;
}

export fn minComp3(a: *Vec3.T) f32 {
    return Vec3.minComp(a.*);
}

export fn argmin3(a: *Vec3.T) u32 {
    return Vec3.argmin(a.*);
}

export fn fromIVec3(a: *IVec3.T, b: *Vec3.T) *Vec3.T {
    b.* = Vec3.fromIVec(IVec3.C, a.*);
    return b;
}

export fn fromBVec4(a: *BVec4.T, b: *Vec4.T) *Vec4.T {
    b.* = Vec4.fromBVec(a.*);
    return b;
}

export fn and4(a: *IVec4.T, b: *IVec4.T) *IVec4.T {
    a.* = IVec4._and(a.*, b.*);
    return a;
}

export fn andB4(a: *BVec4.T, b: *BVec4.T) *BVec4.T {
    a.* = BVec4._and(a.*, b.*);
    return a;
}

export fn any3(a: *BVec3.T) bool {
    return BVec3.any(a.*);
}

export fn centroid(a: [*]Vec4.T, num: u32) [*]Vec4.T {
    const buf = a[0..num];
    a[0] = Vec4.centroid(buf);
    return a;
}
