const std = @import("std");

pub fn atanAbs(a: anytype) @TypeOf(a) {
    const theta = std.math.mod(@TypeOf(a), a, std.math.tau);
    return if (theta < 0) std.math.tau + theta else theta;
}

pub fn atan2(a: anytype, b: anytype) @TypeOf(a) {
    return std.math.atan2(@TypeOf(a), a, b);
}

pub fn mod(a: anytype, b: anytype) @TypeOf(a) {
    return a - b * @floor(a / b);
}

pub fn pow(a: anytype, b: anytype) @TypeOf(a) {
    return std.math.pow(@TypeOf(a), a, b);
}

pub fn powi(a: anytype, b: anytype) @TypeOf(a) {
    return std.math.powi(@TypeOf(a), a, b);
}
