// SPDX-License-Identifier: Apache-2.0

// const @Vector = @import("std").meta.@Vector;

// codegen (NodeJS):
// import { comp, distinct, map, mapcat, permutations, range, repeat, run, str, trace zip } from "@thi.ng/transducers";
// D = [2, 3, 4];
// run(
//   comp(
//     mapcat(d => zip([d, d, d], D)),
//     mapcat(([d, n]) => [...permutations(...repeat(range(d), n))]),
//     distinct({ key: String }),
//     map(x => `pub fn ${str("", map(a => "xyzw"[a], x))}(a: V) V${x.length} { return [_]T{ ${str(", ", map(a => `a[${a}]`, x))}}; }`),
//     trace()
//   ),
// D);

/// Generated - do not edit!
pub fn Vec2Swizzles(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    const V2 = @Vector(2, T);
    const V3 = @Vector(3, T);
    const V4 = @Vector(4, T);
    return if (N < 2) struct {} else struct {
        pub fn y(a: V) T {
            return a[1];
        }
        pub fn xx(a: V) V2 {
            return [_]T{ a[0], a[0] };
        }
        pub fn xy(a: V) V2 {
            return [_]T{ a[0], a[1] };
        }
        pub fn yx(a: V) V2 {
            return [_]T{ a[1], a[0] };
        }
        pub fn yy(a: V) V2 {
            return [_]T{ a[1], a[1] };
        }
        pub fn xxx(a: V) V3 {
            return [_]T{ a[0], a[0], a[0] };
        }
        pub fn xxy(a: V) V3 {
            return [_]T{ a[0], a[0], a[1] };
        }
        pub fn xyx(a: V) V3 {
            return [_]T{ a[0], a[1], a[0] };
        }
        pub fn xyy(a: V) V3 {
            return [_]T{ a[0], a[1], a[1] };
        }
        pub fn yxx(a: V) V3 {
            return [_]T{ a[1], a[0], a[0] };
        }
        pub fn yxy(a: V) V3 {
            return [_]T{ a[1], a[0], a[1] };
        }
        pub fn yyx(a: V) V3 {
            return [_]T{ a[1], a[1], a[0] };
        }
        pub fn yyy(a: V) V3 {
            return [_]T{ a[1], a[1], a[1] };
        }
        pub fn xxxx(a: V) V4 {
            return [_]T{ a[0], a[0], a[0], a[0] };
        }
        pub fn xxxy(a: V) V4 {
            return [_]T{ a[0], a[0], a[0], a[1] };
        }
        pub fn xxyx(a: V) V4 {
            return [_]T{ a[0], a[0], a[1], a[0] };
        }
        pub fn xxyy(a: V) V4 {
            return [_]T{ a[0], a[0], a[1], a[1] };
        }
        pub fn xyxx(a: V) V4 {
            return [_]T{ a[0], a[1], a[0], a[0] };
        }
        pub fn xyxy(a: V) V4 {
            return [_]T{ a[0], a[1], a[0], a[1] };
        }
        pub fn xyyx(a: V) V4 {
            return [_]T{ a[0], a[1], a[1], a[0] };
        }
        pub fn xyyy(a: V) V4 {
            return [_]T{ a[0], a[1], a[1], a[1] };
        }
        pub fn yxxx(a: V) V4 {
            return [_]T{ a[1], a[0], a[0], a[0] };
        }
        pub fn yxxy(a: V) V4 {
            return [_]T{ a[1], a[0], a[0], a[1] };
        }
        pub fn yxyx(a: V) V4 {
            return [_]T{ a[1], a[0], a[1], a[0] };
        }
        pub fn yxyy(a: V) V4 {
            return [_]T{ a[1], a[0], a[1], a[1] };
        }
        pub fn yyxx(a: V) V4 {
            return [_]T{ a[1], a[1], a[0], a[0] };
        }
        pub fn yyxy(a: V) V4 {
            return [_]T{ a[1], a[1], a[0], a[1] };
        }
        pub fn yyyx(a: V) V4 {
            return [_]T{ a[1], a[1], a[1], a[0] };
        }
        pub fn yyyy(a: V) V4 {
            return [_]T{ a[1], a[1], a[1], a[1] };
        }
    };
}

/// Generated - do not edit!
pub fn Vec3Swizzles(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    const V2 = @Vector(2, T);
    const V3 = @Vector(3, T);
    const V4 = @Vector(4, T);
    return if (N < 3) struct {} else struct {
        pub fn z(a: V) T {
            return a[2];
        }
        pub fn xz(a: V) V2 {
            return [_]T{ a[0], a[2] };
        }
        pub fn yz(a: V) V2 {
            return [_]T{ a[1], a[2] };
        }
        pub fn zx(a: V) V2 {
            return [_]T{ a[2], a[0] };
        }
        pub fn zy(a: V) V2 {
            return [_]T{ a[2], a[1] };
        }
        pub fn zz(a: V) V2 {
            return [_]T{ a[2], a[2] };
        }
        pub fn xxz(a: V) V3 {
            return [_]T{ a[0], a[0], a[2] };
        }
        pub fn xyz(a: V) V3 {
            return [_]T{ a[0], a[1], a[2] };
        }
        pub fn xzx(a: V) V3 {
            return [_]T{ a[0], a[2], a[0] };
        }
        pub fn xzy(a: V) V3 {
            return [_]T{ a[0], a[2], a[1] };
        }
        pub fn xzz(a: V) V3 {
            return [_]T{ a[0], a[2], a[2] };
        }
        pub fn yxz(a: V) V3 {
            return [_]T{ a[1], a[0], a[2] };
        }
        pub fn yyz(a: V) V3 {
            return [_]T{ a[1], a[1], a[2] };
        }
        pub fn yzx(a: V) V3 {
            return [_]T{ a[1], a[2], a[0] };
        }
        pub fn yzy(a: V) V3 {
            return [_]T{ a[1], a[2], a[1] };
        }
        pub fn yzz(a: V) V3 {
            return [_]T{ a[1], a[2], a[2] };
        }
        pub fn zxx(a: V) V3 {
            return [_]T{ a[2], a[0], a[0] };
        }
        pub fn zxy(a: V) V3 {
            return [_]T{ a[2], a[0], a[1] };
        }
        pub fn zxz(a: V) V3 {
            return [_]T{ a[2], a[0], a[2] };
        }
        pub fn zyx(a: V) V3 {
            return [_]T{ a[2], a[1], a[0] };
        }
        pub fn zyy(a: V) V3 {
            return [_]T{ a[2], a[1], a[1] };
        }
        pub fn zyz(a: V) V3 {
            return [_]T{ a[2], a[1], a[2] };
        }
        pub fn zzx(a: V) V3 {
            return [_]T{ a[2], a[2], a[0] };
        }
        pub fn zzy(a: V) V3 {
            return [_]T{ a[2], a[2], a[1] };
        }
        pub fn zzz(a: V) V3 {
            return [_]T{ a[2], a[2], a[2] };
        }
        pub fn xxxz(a: V) V4 {
            return [_]T{ a[0], a[0], a[0], a[2] };
        }
        pub fn xxyz(a: V) V4 {
            return [_]T{ a[0], a[0], a[1], a[2] };
        }
        pub fn xxzx(a: V) V4 {
            return [_]T{ a[0], a[0], a[2], a[0] };
        }
        pub fn xxzy(a: V) V4 {
            return [_]T{ a[0], a[0], a[2], a[1] };
        }
        pub fn xxzz(a: V) V4 {
            return [_]T{ a[0], a[0], a[2], a[2] };
        }
        pub fn xyxz(a: V) V4 {
            return [_]T{ a[0], a[1], a[0], a[2] };
        }
        pub fn xyyz(a: V) V4 {
            return [_]T{ a[0], a[1], a[1], a[2] };
        }
        pub fn xyzx(a: V) V4 {
            return [_]T{ a[0], a[1], a[2], a[0] };
        }
        pub fn xyzy(a: V) V4 {
            return [_]T{ a[0], a[1], a[2], a[1] };
        }
        pub fn xyzz(a: V) V4 {
            return [_]T{ a[0], a[1], a[2], a[2] };
        }
        pub fn xzxx(a: V) V4 {
            return [_]T{ a[0], a[2], a[0], a[0] };
        }
        pub fn xzxy(a: V) V4 {
            return [_]T{ a[0], a[2], a[0], a[1] };
        }
        pub fn xzxz(a: V) V4 {
            return [_]T{ a[0], a[2], a[0], a[2] };
        }
        pub fn xzyx(a: V) V4 {
            return [_]T{ a[0], a[2], a[1], a[0] };
        }
        pub fn xzyy(a: V) V4 {
            return [_]T{ a[0], a[2], a[1], a[1] };
        }
        pub fn xzyz(a: V) V4 {
            return [_]T{ a[0], a[2], a[1], a[2] };
        }
        pub fn xzzx(a: V) V4 {
            return [_]T{ a[0], a[2], a[2], a[0] };
        }
        pub fn xzzy(a: V) V4 {
            return [_]T{ a[0], a[2], a[2], a[1] };
        }
        pub fn xzzz(a: V) V4 {
            return [_]T{ a[0], a[2], a[2], a[2] };
        }
        pub fn yxxz(a: V) V4 {
            return [_]T{ a[1], a[0], a[0], a[2] };
        }
        pub fn yxyz(a: V) V4 {
            return [_]T{ a[1], a[0], a[1], a[2] };
        }
        pub fn yxzx(a: V) V4 {
            return [_]T{ a[1], a[0], a[2], a[0] };
        }
        pub fn yxzy(a: V) V4 {
            return [_]T{ a[1], a[0], a[2], a[1] };
        }
        pub fn yxzz(a: V) V4 {
            return [_]T{ a[1], a[0], a[2], a[2] };
        }
        pub fn yyxz(a: V) V4 {
            return [_]T{ a[1], a[1], a[0], a[2] };
        }
        pub fn yyyz(a: V) V4 {
            return [_]T{ a[1], a[1], a[1], a[2] };
        }
        pub fn yyzx(a: V) V4 {
            return [_]T{ a[1], a[1], a[2], a[0] };
        }
        pub fn yyzy(a: V) V4 {
            return [_]T{ a[1], a[1], a[2], a[1] };
        }
        pub fn yyzz(a: V) V4 {
            return [_]T{ a[1], a[1], a[2], a[2] };
        }
        pub fn yzxx(a: V) V4 {
            return [_]T{ a[1], a[2], a[0], a[0] };
        }
        pub fn yzxy(a: V) V4 {
            return [_]T{ a[1], a[2], a[0], a[1] };
        }
        pub fn yzxz(a: V) V4 {
            return [_]T{ a[1], a[2], a[0], a[2] };
        }
        pub fn yzyx(a: V) V4 {
            return [_]T{ a[1], a[2], a[1], a[0] };
        }
        pub fn yzyy(a: V) V4 {
            return [_]T{ a[1], a[2], a[1], a[1] };
        }
        pub fn yzyz(a: V) V4 {
            return [_]T{ a[1], a[2], a[1], a[2] };
        }
        pub fn yzzx(a: V) V4 {
            return [_]T{ a[1], a[2], a[2], a[0] };
        }
        pub fn yzzy(a: V) V4 {
            return [_]T{ a[1], a[2], a[2], a[1] };
        }
        pub fn yzzz(a: V) V4 {
            return [_]T{ a[1], a[2], a[2], a[2] };
        }
        pub fn zxxx(a: V) V4 {
            return [_]T{ a[2], a[0], a[0], a[0] };
        }
        pub fn zxxy(a: V) V4 {
            return [_]T{ a[2], a[0], a[0], a[1] };
        }
        pub fn zxxz(a: V) V4 {
            return [_]T{ a[2], a[0], a[0], a[2] };
        }
        pub fn zxyx(a: V) V4 {
            return [_]T{ a[2], a[0], a[1], a[0] };
        }
        pub fn zxyy(a: V) V4 {
            return [_]T{ a[2], a[0], a[1], a[1] };
        }
        pub fn zxyz(a: V) V4 {
            return [_]T{ a[2], a[0], a[1], a[2] };
        }
        pub fn zxzx(a: V) V4 {
            return [_]T{ a[2], a[0], a[2], a[0] };
        }
        pub fn zxzy(a: V) V4 {
            return [_]T{ a[2], a[0], a[2], a[1] };
        }
        pub fn zxzz(a: V) V4 {
            return [_]T{ a[2], a[0], a[2], a[2] };
        }
        pub fn zyxx(a: V) V4 {
            return [_]T{ a[2], a[1], a[0], a[0] };
        }
        pub fn zyxy(a: V) V4 {
            return [_]T{ a[2], a[1], a[0], a[1] };
        }
        pub fn zyxz(a: V) V4 {
            return [_]T{ a[2], a[1], a[0], a[2] };
        }
        pub fn zyyx(a: V) V4 {
            return [_]T{ a[2], a[1], a[1], a[0] };
        }
        pub fn zyyy(a: V) V4 {
            return [_]T{ a[2], a[1], a[1], a[1] };
        }
        pub fn zyyz(a: V) V4 {
            return [_]T{ a[2], a[1], a[1], a[2] };
        }
        pub fn zyzx(a: V) V4 {
            return [_]T{ a[2], a[1], a[2], a[0] };
        }
        pub fn zyzy(a: V) V4 {
            return [_]T{ a[2], a[1], a[2], a[1] };
        }
        pub fn zyzz(a: V) V4 {
            return [_]T{ a[2], a[1], a[2], a[2] };
        }
        pub fn zzxx(a: V) V4 {
            return [_]T{ a[2], a[2], a[0], a[0] };
        }
        pub fn zzxy(a: V) V4 {
            return [_]T{ a[2], a[2], a[0], a[1] };
        }
        pub fn zzxz(a: V) V4 {
            return [_]T{ a[2], a[2], a[0], a[2] };
        }
        pub fn zzyx(a: V) V4 {
            return [_]T{ a[2], a[2], a[1], a[0] };
        }
        pub fn zzyy(a: V) V4 {
            return [_]T{ a[2], a[2], a[1], a[1] };
        }
        pub fn zzyz(a: V) V4 {
            return [_]T{ a[2], a[2], a[1], a[2] };
        }
        pub fn zzzx(a: V) V4 {
            return [_]T{ a[2], a[2], a[2], a[0] };
        }
        pub fn zzzy(a: V) V4 {
            return [_]T{ a[2], a[2], a[2], a[1] };
        }
        pub fn zzzz(a: V) V4 {
            return [_]T{ a[2], a[2], a[2], a[2] };
        }
    };
}

/// Generated - do not edit!
pub fn Vec4Swizzles(comptime N: u32, comptime T: type) type {
    const V = @Vector(N, T);
    const V2 = @Vector(2, T);
    const V3 = @Vector(3, T);
    const V4 = @Vector(4, T);
    return if (N < 4) struct {} else struct {
        pub fn w(a: V) T {
            return a[3];
        }
        pub fn xw(a: V) V2 {
            return [_]T{ a[0], a[3] };
        }
        pub fn yw(a: V) V2 {
            return [_]T{ a[1], a[3] };
        }
        pub fn zw(a: V) V2 {
            return [_]T{ a[2], a[3] };
        }
        pub fn wx(a: V) V2 {
            return [_]T{ a[3], a[0] };
        }
        pub fn wy(a: V) V2 {
            return [_]T{ a[3], a[1] };
        }
        pub fn wz(a: V) V2 {
            return [_]T{ a[3], a[2] };
        }
        pub fn ww(a: V) V2 {
            return [_]T{ a[3], a[3] };
        }
        pub fn xxw(a: V) V3 {
            return [_]T{ a[0], a[0], a[3] };
        }
        pub fn xyw(a: V) V3 {
            return [_]T{ a[0], a[1], a[3] };
        }
        pub fn xzw(a: V) V3 {
            return [_]T{ a[0], a[2], a[3] };
        }
        pub fn xwx(a: V) V3 {
            return [_]T{ a[0], a[3], a[0] };
        }
        pub fn xwy(a: V) V3 {
            return [_]T{ a[0], a[3], a[1] };
        }
        pub fn xwz(a: V) V3 {
            return [_]T{ a[0], a[3], a[2] };
        }
        pub fn xww(a: V) V3 {
            return [_]T{ a[0], a[3], a[3] };
        }
        pub fn yxw(a: V) V3 {
            return [_]T{ a[1], a[0], a[3] };
        }
        pub fn yyw(a: V) V3 {
            return [_]T{ a[1], a[1], a[3] };
        }
        pub fn yzw(a: V) V3 {
            return [_]T{ a[1], a[2], a[3] };
        }
        pub fn ywx(a: V) V3 {
            return [_]T{ a[1], a[3], a[0] };
        }
        pub fn ywy(a: V) V3 {
            return [_]T{ a[1], a[3], a[1] };
        }
        pub fn ywz(a: V) V3 {
            return [_]T{ a[1], a[3], a[2] };
        }
        pub fn yww(a: V) V3 {
            return [_]T{ a[1], a[3], a[3] };
        }
        pub fn zxw(a: V) V3 {
            return [_]T{ a[2], a[0], a[3] };
        }
        pub fn zyw(a: V) V3 {
            return [_]T{ a[2], a[1], a[3] };
        }
        pub fn zzw(a: V) V3 {
            return [_]T{ a[2], a[2], a[3] };
        }
        pub fn zwx(a: V) V3 {
            return [_]T{ a[2], a[3], a[0] };
        }
        pub fn zwy(a: V) V3 {
            return [_]T{ a[2], a[3], a[1] };
        }
        pub fn zwz(a: V) V3 {
            return [_]T{ a[2], a[3], a[2] };
        }
        pub fn zww(a: V) V3 {
            return [_]T{ a[2], a[3], a[3] };
        }
        pub fn wxx(a: V) V3 {
            return [_]T{ a[3], a[0], a[0] };
        }
        pub fn wxy(a: V) V3 {
            return [_]T{ a[3], a[0], a[1] };
        }
        pub fn wxz(a: V) V3 {
            return [_]T{ a[3], a[0], a[2] };
        }
        pub fn wxw(a: V) V3 {
            return [_]T{ a[3], a[0], a[3] };
        }
        pub fn wyx(a: V) V3 {
            return [_]T{ a[3], a[1], a[0] };
        }
        pub fn wyy(a: V) V3 {
            return [_]T{ a[3], a[1], a[1] };
        }
        pub fn wyz(a: V) V3 {
            return [_]T{ a[3], a[1], a[2] };
        }
        pub fn wyw(a: V) V3 {
            return [_]T{ a[3], a[1], a[3] };
        }
        pub fn wzx(a: V) V3 {
            return [_]T{ a[3], a[2], a[0] };
        }
        pub fn wzy(a: V) V3 {
            return [_]T{ a[3], a[2], a[1] };
        }
        pub fn wzz(a: V) V3 {
            return [_]T{ a[3], a[2], a[2] };
        }
        pub fn wzw(a: V) V3 {
            return [_]T{ a[3], a[2], a[3] };
        }
        pub fn wwx(a: V) V3 {
            return [_]T{ a[3], a[3], a[0] };
        }
        pub fn wwy(a: V) V3 {
            return [_]T{ a[3], a[3], a[1] };
        }
        pub fn wwz(a: V) V3 {
            return [_]T{ a[3], a[3], a[2] };
        }
        pub fn www(a: V) V3 {
            return [_]T{ a[3], a[3], a[3] };
        }
        pub fn xxxw(a: V) V4 {
            return [_]T{ a[0], a[0], a[0], a[3] };
        }
        pub fn xxyw(a: V) V4 {
            return [_]T{ a[0], a[0], a[1], a[3] };
        }
        pub fn xxzw(a: V) V4 {
            return [_]T{ a[0], a[0], a[2], a[3] };
        }
        pub fn xxwx(a: V) V4 {
            return [_]T{ a[0], a[0], a[3], a[0] };
        }
        pub fn xxwy(a: V) V4 {
            return [_]T{ a[0], a[0], a[3], a[1] };
        }
        pub fn xxwz(a: V) V4 {
            return [_]T{ a[0], a[0], a[3], a[2] };
        }
        pub fn xxww(a: V) V4 {
            return [_]T{ a[0], a[0], a[3], a[3] };
        }
        pub fn xyxw(a: V) V4 {
            return [_]T{ a[0], a[1], a[0], a[3] };
        }
        pub fn xyyw(a: V) V4 {
            return [_]T{ a[0], a[1], a[1], a[3] };
        }
        pub fn xyzw(a: V) V4 {
            return [_]T{ a[0], a[1], a[2], a[3] };
        }
        pub fn xywx(a: V) V4 {
            return [_]T{ a[0], a[1], a[3], a[0] };
        }
        pub fn xywy(a: V) V4 {
            return [_]T{ a[0], a[1], a[3], a[1] };
        }
        pub fn xywz(a: V) V4 {
            return [_]T{ a[0], a[1], a[3], a[2] };
        }
        pub fn xyww(a: V) V4 {
            return [_]T{ a[0], a[1], a[3], a[3] };
        }
        pub fn xzxw(a: V) V4 {
            return [_]T{ a[0], a[2], a[0], a[3] };
        }
        pub fn xzyw(a: V) V4 {
            return [_]T{ a[0], a[2], a[1], a[3] };
        }
        pub fn xzzw(a: V) V4 {
            return [_]T{ a[0], a[2], a[2], a[3] };
        }
        pub fn xzwx(a: V) V4 {
            return [_]T{ a[0], a[2], a[3], a[0] };
        }
        pub fn xzwy(a: V) V4 {
            return [_]T{ a[0], a[2], a[3], a[1] };
        }
        pub fn xzwz(a: V) V4 {
            return [_]T{ a[0], a[2], a[3], a[2] };
        }
        pub fn xzww(a: V) V4 {
            return [_]T{ a[0], a[2], a[3], a[3] };
        }
        pub fn xwxx(a: V) V4 {
            return [_]T{ a[0], a[3], a[0], a[0] };
        }
        pub fn xwxy(a: V) V4 {
            return [_]T{ a[0], a[3], a[0], a[1] };
        }
        pub fn xwxz(a: V) V4 {
            return [_]T{ a[0], a[3], a[0], a[2] };
        }
        pub fn xwxw(a: V) V4 {
            return [_]T{ a[0], a[3], a[0], a[3] };
        }
        pub fn xwyx(a: V) V4 {
            return [_]T{ a[0], a[3], a[1], a[0] };
        }
        pub fn xwyy(a: V) V4 {
            return [_]T{ a[0], a[3], a[1], a[1] };
        }
        pub fn xwyz(a: V) V4 {
            return [_]T{ a[0], a[3], a[1], a[2] };
        }
        pub fn xwyw(a: V) V4 {
            return [_]T{ a[0], a[3], a[1], a[3] };
        }
        pub fn xwzx(a: V) V4 {
            return [_]T{ a[0], a[3], a[2], a[0] };
        }
        pub fn xwzy(a: V) V4 {
            return [_]T{ a[0], a[3], a[2], a[1] };
        }
        pub fn xwzz(a: V) V4 {
            return [_]T{ a[0], a[3], a[2], a[2] };
        }
        pub fn xwzw(a: V) V4 {
            return [_]T{ a[0], a[3], a[2], a[3] };
        }
        pub fn xwwx(a: V) V4 {
            return [_]T{ a[0], a[3], a[3], a[0] };
        }
        pub fn xwwy(a: V) V4 {
            return [_]T{ a[0], a[3], a[3], a[1] };
        }
        pub fn xwwz(a: V) V4 {
            return [_]T{ a[0], a[3], a[3], a[2] };
        }
        pub fn xwww(a: V) V4 {
            return [_]T{ a[0], a[3], a[3], a[3] };
        }
        pub fn yxxw(a: V) V4 {
            return [_]T{ a[1], a[0], a[0], a[3] };
        }
        pub fn yxyw(a: V) V4 {
            return [_]T{ a[1], a[0], a[1], a[3] };
        }
        pub fn yxzw(a: V) V4 {
            return [_]T{ a[1], a[0], a[2], a[3] };
        }
        pub fn yxwx(a: V) V4 {
            return [_]T{ a[1], a[0], a[3], a[0] };
        }
        pub fn yxwy(a: V) V4 {
            return [_]T{ a[1], a[0], a[3], a[1] };
        }
        pub fn yxwz(a: V) V4 {
            return [_]T{ a[1], a[0], a[3], a[2] };
        }
        pub fn yxww(a: V) V4 {
            return [_]T{ a[1], a[0], a[3], a[3] };
        }
        pub fn yyxw(a: V) V4 {
            return [_]T{ a[1], a[1], a[0], a[3] };
        }
        pub fn yyyw(a: V) V4 {
            return [_]T{ a[1], a[1], a[1], a[3] };
        }
        pub fn yyzw(a: V) V4 {
            return [_]T{ a[1], a[1], a[2], a[3] };
        }
        pub fn yywx(a: V) V4 {
            return [_]T{ a[1], a[1], a[3], a[0] };
        }
        pub fn yywy(a: V) V4 {
            return [_]T{ a[1], a[1], a[3], a[1] };
        }
        pub fn yywz(a: V) V4 {
            return [_]T{ a[1], a[1], a[3], a[2] };
        }
        pub fn yyww(a: V) V4 {
            return [_]T{ a[1], a[1], a[3], a[3] };
        }
        pub fn yzxw(a: V) V4 {
            return [_]T{ a[1], a[2], a[0], a[3] };
        }
        pub fn yzyw(a: V) V4 {
            return [_]T{ a[1], a[2], a[1], a[3] };
        }
        pub fn yzzw(a: V) V4 {
            return [_]T{ a[1], a[2], a[2], a[3] };
        }
        pub fn yzwx(a: V) V4 {
            return [_]T{ a[1], a[2], a[3], a[0] };
        }
        pub fn yzwy(a: V) V4 {
            return [_]T{ a[1], a[2], a[3], a[1] };
        }
        pub fn yzwz(a: V) V4 {
            return [_]T{ a[1], a[2], a[3], a[2] };
        }
        pub fn yzww(a: V) V4 {
            return [_]T{ a[1], a[2], a[3], a[3] };
        }
        pub fn ywxx(a: V) V4 {
            return [_]T{ a[1], a[3], a[0], a[0] };
        }
        pub fn ywxy(a: V) V4 {
            return [_]T{ a[1], a[3], a[0], a[1] };
        }
        pub fn ywxz(a: V) V4 {
            return [_]T{ a[1], a[3], a[0], a[2] };
        }
        pub fn ywxw(a: V) V4 {
            return [_]T{ a[1], a[3], a[0], a[3] };
        }
        pub fn ywyx(a: V) V4 {
            return [_]T{ a[1], a[3], a[1], a[0] };
        }
        pub fn ywyy(a: V) V4 {
            return [_]T{ a[1], a[3], a[1], a[1] };
        }
        pub fn ywyz(a: V) V4 {
            return [_]T{ a[1], a[3], a[1], a[2] };
        }
        pub fn ywyw(a: V) V4 {
            return [_]T{ a[1], a[3], a[1], a[3] };
        }
        pub fn ywzx(a: V) V4 {
            return [_]T{ a[1], a[3], a[2], a[0] };
        }
        pub fn ywzy(a: V) V4 {
            return [_]T{ a[1], a[3], a[2], a[1] };
        }
        pub fn ywzz(a: V) V4 {
            return [_]T{ a[1], a[3], a[2], a[2] };
        }
        pub fn ywzw(a: V) V4 {
            return [_]T{ a[1], a[3], a[2], a[3] };
        }
        pub fn ywwx(a: V) V4 {
            return [_]T{ a[1], a[3], a[3], a[0] };
        }
        pub fn ywwy(a: V) V4 {
            return [_]T{ a[1], a[3], a[3], a[1] };
        }
        pub fn ywwz(a: V) V4 {
            return [_]T{ a[1], a[3], a[3], a[2] };
        }
        pub fn ywww(a: V) V4 {
            return [_]T{ a[1], a[3], a[3], a[3] };
        }
        pub fn zxxw(a: V) V4 {
            return [_]T{ a[2], a[0], a[0], a[3] };
        }
        pub fn zxyw(a: V) V4 {
            return [_]T{ a[2], a[0], a[1], a[3] };
        }
        pub fn zxzw(a: V) V4 {
            return [_]T{ a[2], a[0], a[2], a[3] };
        }
        pub fn zxwx(a: V) V4 {
            return [_]T{ a[2], a[0], a[3], a[0] };
        }
        pub fn zxwy(a: V) V4 {
            return [_]T{ a[2], a[0], a[3], a[1] };
        }
        pub fn zxwz(a: V) V4 {
            return [_]T{ a[2], a[0], a[3], a[2] };
        }
        pub fn zxww(a: V) V4 {
            return [_]T{ a[2], a[0], a[3], a[3] };
        }
        pub fn zyxw(a: V) V4 {
            return [_]T{ a[2], a[1], a[0], a[3] };
        }
        pub fn zyyw(a: V) V4 {
            return [_]T{ a[2], a[1], a[1], a[3] };
        }
        pub fn zyzw(a: V) V4 {
            return [_]T{ a[2], a[1], a[2], a[3] };
        }
        pub fn zywx(a: V) V4 {
            return [_]T{ a[2], a[1], a[3], a[0] };
        }
        pub fn zywy(a: V) V4 {
            return [_]T{ a[2], a[1], a[3], a[1] };
        }
        pub fn zywz(a: V) V4 {
            return [_]T{ a[2], a[1], a[3], a[2] };
        }
        pub fn zyww(a: V) V4 {
            return [_]T{ a[2], a[1], a[3], a[3] };
        }
        pub fn zzxw(a: V) V4 {
            return [_]T{ a[2], a[2], a[0], a[3] };
        }
        pub fn zzyw(a: V) V4 {
            return [_]T{ a[2], a[2], a[1], a[3] };
        }
        pub fn zzzw(a: V) V4 {
            return [_]T{ a[2], a[2], a[2], a[3] };
        }
        pub fn zzwx(a: V) V4 {
            return [_]T{ a[2], a[2], a[3], a[0] };
        }
        pub fn zzwy(a: V) V4 {
            return [_]T{ a[2], a[2], a[3], a[1] };
        }
        pub fn zzwz(a: V) V4 {
            return [_]T{ a[2], a[2], a[3], a[2] };
        }
        pub fn zzww(a: V) V4 {
            return [_]T{ a[2], a[2], a[3], a[3] };
        }
        pub fn zwxx(a: V) V4 {
            return [_]T{ a[2], a[3], a[0], a[0] };
        }
        pub fn zwxy(a: V) V4 {
            return [_]T{ a[2], a[3], a[0], a[1] };
        }
        pub fn zwxz(a: V) V4 {
            return [_]T{ a[2], a[3], a[0], a[2] };
        }
        pub fn zwxw(a: V) V4 {
            return [_]T{ a[2], a[3], a[0], a[3] };
        }
        pub fn zwyx(a: V) V4 {
            return [_]T{ a[2], a[3], a[1], a[0] };
        }
        pub fn zwyy(a: V) V4 {
            return [_]T{ a[2], a[3], a[1], a[1] };
        }
        pub fn zwyz(a: V) V4 {
            return [_]T{ a[2], a[3], a[1], a[2] };
        }
        pub fn zwyw(a: V) V4 {
            return [_]T{ a[2], a[3], a[1], a[3] };
        }
        pub fn zwzx(a: V) V4 {
            return [_]T{ a[2], a[3], a[2], a[0] };
        }
        pub fn zwzy(a: V) V4 {
            return [_]T{ a[2], a[3], a[2], a[1] };
        }
        pub fn zwzz(a: V) V4 {
            return [_]T{ a[2], a[3], a[2], a[2] };
        }
        pub fn zwzw(a: V) V4 {
            return [_]T{ a[2], a[3], a[2], a[3] };
        }
        pub fn zwwx(a: V) V4 {
            return [_]T{ a[2], a[3], a[3], a[0] };
        }
        pub fn zwwy(a: V) V4 {
            return [_]T{ a[2], a[3], a[3], a[1] };
        }
        pub fn zwwz(a: V) V4 {
            return [_]T{ a[2], a[3], a[3], a[2] };
        }
        pub fn zwww(a: V) V4 {
            return [_]T{ a[2], a[3], a[3], a[3] };
        }
        pub fn wxxx(a: V) V4 {
            return [_]T{ a[3], a[0], a[0], a[0] };
        }
        pub fn wxxy(a: V) V4 {
            return [_]T{ a[3], a[0], a[0], a[1] };
        }
        pub fn wxxz(a: V) V4 {
            return [_]T{ a[3], a[0], a[0], a[2] };
        }
        pub fn wxxw(a: V) V4 {
            return [_]T{ a[3], a[0], a[0], a[3] };
        }
        pub fn wxyx(a: V) V4 {
            return [_]T{ a[3], a[0], a[1], a[0] };
        }
        pub fn wxyy(a: V) V4 {
            return [_]T{ a[3], a[0], a[1], a[1] };
        }
        pub fn wxyz(a: V) V4 {
            return [_]T{ a[3], a[0], a[1], a[2] };
        }
        pub fn wxyw(a: V) V4 {
            return [_]T{ a[3], a[0], a[1], a[3] };
        }
        pub fn wxzx(a: V) V4 {
            return [_]T{ a[3], a[0], a[2], a[0] };
        }
        pub fn wxzy(a: V) V4 {
            return [_]T{ a[3], a[0], a[2], a[1] };
        }
        pub fn wxzz(a: V) V4 {
            return [_]T{ a[3], a[0], a[2], a[2] };
        }
        pub fn wxzw(a: V) V4 {
            return [_]T{ a[3], a[0], a[2], a[3] };
        }
        pub fn wxwx(a: V) V4 {
            return [_]T{ a[3], a[0], a[3], a[0] };
        }
        pub fn wxwy(a: V) V4 {
            return [_]T{ a[3], a[0], a[3], a[1] };
        }
        pub fn wxwz(a: V) V4 {
            return [_]T{ a[3], a[0], a[3], a[2] };
        }
        pub fn wxww(a: V) V4 {
            return [_]T{ a[3], a[0], a[3], a[3] };
        }
        pub fn wyxx(a: V) V4 {
            return [_]T{ a[3], a[1], a[0], a[0] };
        }
        pub fn wyxy(a: V) V4 {
            return [_]T{ a[3], a[1], a[0], a[1] };
        }
        pub fn wyxz(a: V) V4 {
            return [_]T{ a[3], a[1], a[0], a[2] };
        }
        pub fn wyxw(a: V) V4 {
            return [_]T{ a[3], a[1], a[0], a[3] };
        }
        pub fn wyyx(a: V) V4 {
            return [_]T{ a[3], a[1], a[1], a[0] };
        }
        pub fn wyyy(a: V) V4 {
            return [_]T{ a[3], a[1], a[1], a[1] };
        }
        pub fn wyyz(a: V) V4 {
            return [_]T{ a[3], a[1], a[1], a[2] };
        }
        pub fn wyyw(a: V) V4 {
            return [_]T{ a[3], a[1], a[1], a[3] };
        }
        pub fn wyzx(a: V) V4 {
            return [_]T{ a[3], a[1], a[2], a[0] };
        }
        pub fn wyzy(a: V) V4 {
            return [_]T{ a[3], a[1], a[2], a[1] };
        }
        pub fn wyzz(a: V) V4 {
            return [_]T{ a[3], a[1], a[2], a[2] };
        }
        pub fn wyzw(a: V) V4 {
            return [_]T{ a[3], a[1], a[2], a[3] };
        }
        pub fn wywx(a: V) V4 {
            return [_]T{ a[3], a[1], a[3], a[0] };
        }
        pub fn wywy(a: V) V4 {
            return [_]T{ a[3], a[1], a[3], a[1] };
        }
        pub fn wywz(a: V) V4 {
            return [_]T{ a[3], a[1], a[3], a[2] };
        }
        pub fn wyww(a: V) V4 {
            return [_]T{ a[3], a[1], a[3], a[3] };
        }
        pub fn wzxx(a: V) V4 {
            return [_]T{ a[3], a[2], a[0], a[0] };
        }
        pub fn wzxy(a: V) V4 {
            return [_]T{ a[3], a[2], a[0], a[1] };
        }
        pub fn wzxz(a: V) V4 {
            return [_]T{ a[3], a[2], a[0], a[2] };
        }
        pub fn wzxw(a: V) V4 {
            return [_]T{ a[3], a[2], a[0], a[3] };
        }
        pub fn wzyx(a: V) V4 {
            return [_]T{ a[3], a[2], a[1], a[0] };
        }
        pub fn wzyy(a: V) V4 {
            return [_]T{ a[3], a[2], a[1], a[1] };
        }
        pub fn wzyz(a: V) V4 {
            return [_]T{ a[3], a[2], a[1], a[2] };
        }
        pub fn wzyw(a: V) V4 {
            return [_]T{ a[3], a[2], a[1], a[3] };
        }
        pub fn wzzx(a: V) V4 {
            return [_]T{ a[3], a[2], a[2], a[0] };
        }
        pub fn wzzy(a: V) V4 {
            return [_]T{ a[3], a[2], a[2], a[1] };
        }
        pub fn wzzz(a: V) V4 {
            return [_]T{ a[3], a[2], a[2], a[2] };
        }
        pub fn wzzw(a: V) V4 {
            return [_]T{ a[3], a[2], a[2], a[3] };
        }
        pub fn wzwx(a: V) V4 {
            return [_]T{ a[3], a[2], a[3], a[0] };
        }
        pub fn wzwy(a: V) V4 {
            return [_]T{ a[3], a[2], a[3], a[1] };
        }
        pub fn wzwz(a: V) V4 {
            return [_]T{ a[3], a[2], a[3], a[2] };
        }
        pub fn wzww(a: V) V4 {
            return [_]T{ a[3], a[2], a[3], a[3] };
        }
        pub fn wwxx(a: V) V4 {
            return [_]T{ a[3], a[3], a[0], a[0] };
        }
        pub fn wwxy(a: V) V4 {
            return [_]T{ a[3], a[3], a[0], a[1] };
        }
        pub fn wwxz(a: V) V4 {
            return [_]T{ a[3], a[3], a[0], a[2] };
        }
        pub fn wwxw(a: V) V4 {
            return [_]T{ a[3], a[3], a[0], a[3] };
        }
        pub fn wwyx(a: V) V4 {
            return [_]T{ a[3], a[3], a[1], a[0] };
        }
        pub fn wwyy(a: V) V4 {
            return [_]T{ a[3], a[3], a[1], a[1] };
        }
        pub fn wwyz(a: V) V4 {
            return [_]T{ a[3], a[3], a[1], a[2] };
        }
        pub fn wwyw(a: V) V4 {
            return [_]T{ a[3], a[3], a[1], a[3] };
        }
        pub fn wwzx(a: V) V4 {
            return [_]T{ a[3], a[3], a[2], a[0] };
        }
        pub fn wwzy(a: V) V4 {
            return [_]T{ a[3], a[3], a[2], a[1] };
        }
        pub fn wwzz(a: V) V4 {
            return [_]T{ a[3], a[3], a[2], a[2] };
        }
        pub fn wwzw(a: V) V4 {
            return [_]T{ a[3], a[3], a[2], a[3] };
        }
        pub fn wwwx(a: V) V4 {
            return [_]T{ a[3], a[3], a[3], a[0] };
        }
        pub fn wwwy(a: V) V4 {
            return [_]T{ a[3], a[3], a[3], a[1] };
        }
        pub fn wwwz(a: V) V4 {
            return [_]T{ a[3], a[3], a[3], a[2] };
        }
        pub fn wwww(a: V) V4 {
            return [_]T{ a[3], a[3], a[3], a[3] };
        }
    };
}
