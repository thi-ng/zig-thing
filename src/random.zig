// SPDX-License-Identifier: Apache-2.0

const std = @import("std");
const Random = std.Random;

pub const Sfc32 = @import("random/sfc32.zig");

/// Returns uniformly distributed value in [-n..n) interval
pub fn norm(comptime T: type, rnd: *Random, n: T) T {
    std.debug.assert(@typeInfo(T) == .float);
    return rnd.float(T) * 2.0 * n - n;
}

/// Returns uniformly distributed value in either the
/// [min..max) or the (-max..-min] interval (same odds)
pub fn normMinmax(comptime T: type, rnd: *Random, min: T, max: T) T {
    std.debug.assert(@typeInfo(T) == .float);
    const x = minmax(T, rnd, min, max);
    return if (rnd.int(u1) == 1) x else -x;
}

/// Returns uniformly distributed value in [min..max) interval
pub fn minmax(comptime T: type, rnd: *Random, min: T, max: T) T {
    std.debug.assert(@typeInfo(T) == .float);
    return min + (max - min) * rnd.float(T);
}

pub fn minmaxInt(comptime T: type, rnd: *Random, min: T, max: T) T {
    return rnd.intRangeLessThan(T, min, max);
}

pub fn pick(comptime T: type, rnd: *Random, opts: anytype) T {
    return opts[rnd.uintLessThan(usize, opts.len)];
}

pub fn pickWeighted(comptime T: type, rnd: *Random, opts: anytype, weights: []const f32) T {
    return opts[rnd.weightedIndex(f32, weights)];
}

pub fn chance(rnd: *Random, prob: f32) bool {
    return rnd.float(f32) < prob;
}

test {
    std.testing.refAllDecls(@This());
}

test "norm" {
    var sfc = Sfc32.init(&.{ 1, 2, 3, 4 });
    var rnd = Sfc32.random(&sfc);
    try std.testing.expectApproxEqAbs(-1, norm(f32, &rnd, 1), 0.01);
    try std.testing.expectApproxEqAbs(-0.89, norm(f32, &rnd, 1), 0.01);
    try std.testing.expectApproxEqAbs(-1.06, normMinmax(f32, &rnd, 1, 2), 0.01);
    try std.testing.expectApproxEqAbs(-1.30, normMinmax(f32, &rnd, 1, 2), 0.01);
}
