//! Ported from:
//! https://github.com/thi-ng/umbrella/blob/develop/packages/random/src/sfc32.ts
//!
//! Original implementation:
//! http://pracrand.sourceforge.net/

const std = @import("std");

const Sfc32 = @This();

a: u32 = undefined,
b: u32 = undefined,
c: u32 = undefined,
d: u32 = undefined,

pub fn init(initialSeed: *const [4]u32) Sfc32 {
    var rnd = Sfc32{};
    rnd.seed(initialSeed);
    return rnd;
}

pub fn seed(self: *Sfc32, vals: *const [4]u32) void {
    self.a = vals[0];
    self.b = vals[1];
    self.c = vals[2];
    self.d = vals[3];
}

fn next(self: *Sfc32) u32 {
    const t = self.a +% self.b +% self.d;
    self.d = self.d +% 1;
    self.a = self.b ^ self.b >> 9;
    self.b = self.c +% (self.c << 3);
    self.c = self.c << 21 | self.c >> 11;
    self.c = self.c +% t;
    return t;
}

// adapted from:
// https://github.com/ziglang/zig/blob/master/lib/std/rand/Sfc64.zig
pub fn fill(self: *Sfc32, buf: []u8) void {
    var i: usize = 0;
    const aligned_len = buf.len - (buf.len & 3);
    // 4 byte chunks
    while (i < aligned_len) : (i += 4) {
        var n = self.next();
        comptime var j: usize = 0;
        inline while (j < 4) : (j += 1) {
            buf[i + j] = @truncate(u8, n);
            n >>= 8;
        }
    }
    if (i != buf.len) {
        var n = self.next();
        while (i < buf.len) : (i += 1) {
            buf[i] = @truncate(u8, n);
            n >>= 8;
        }
    }
}

pub fn random(self: *Sfc32) std.rand.Random {
    return std.rand.Random.init(self, fill);
}
