const std = @import("std");
const Allocator = std.mem.Allocator;

pub const NDError = error{
    BufferTooSmall,
    InvalidPick,
    MissingAllocator,
    OutOfBounds,
    Unsupported,
};

pub const Order = enum {
    Stride,
    Major,
    Minor,
};

pub const IterOpts = struct {
    order: Order = .Major,
};

pub fn NDArray(comptime N: usize, comptime CTYPE: type) type {
    return struct {
        allocator: ?*const Allocator,
        data: []T,
        len: usize,
        offset: isize,
        shape: [N]u32,
        stride: [N]isize,
        order: [N]u8,

        pub const T = CTYPE;
        pub const dim: u32 = N;

        const Self = @This();

        const PositionIterator = struct {
            parent: *const Self,
            order: [N]u8,
            pos: [N]u32 = [_]u32{0} ** N,
            done: bool = false,

            pub fn init(parent: *const Self, order: Order) @This() {
                var iter = @This(){
                    .parent = parent,
                    .order = undefined,
                };
                switch (order) {
                    .Major => {
                        for (iter.order, 0..) |_, i| iter.order[i] = @as(u8, @intCast(N - 1 - i));
                    },
                    .Minor => {
                        for (iter.order, 0..) |_, i| iter.order[i] = @as(u8, @intCast(i));
                    },
                    .Stride => {
                        iter.order = parent.order;
                    },
                }
                return iter;
            }

            pub fn next(self: *@This()) ?[N]u32 {
                if (self.done) return null;
                const res: [N]u32 = self.pos;
                const lastUpdate = for (self.order, 0..) |o, i| {
                    self.pos[o] = (self.pos[o] + 1) % self.parent.shape[o];
                    if (self.pos[o] != 0) break i;
                } else N;
                if (lastUpdate == N) self.done = true;
                return res;
            }
        };

        const IndexIterator = struct {
            pos: PositionIterator,

            pub fn next(self: *@This()) ?usize {
                return if (self.pos.next()) |i| self.pos.parent.index(i) else null;
            }
        };

        const ValueIterator = struct {
            pos: PositionIterator,

            pub fn next(self: *@This()) ?T {
                return if (self.pos.next()) |i| self.pos.parent.at(i) else null;
            }
        };

        pub fn init(opts: struct {
            allocator: ?*const Allocator = null,
            data: ?[]T = null,
            offset: isize = 0,
            shape: [N]u32,
            stride: ?[N]isize = null,
        }) !Self {
            var self = Self{
                .allocator = opts.allocator,
                .data = undefined,
                .len = Self.length(opts.shape),
                .offset = opts.offset,
                .shape = opts.shape,
                .stride = if (opts.stride) |stride| stride else Self.shapeToStride(opts.shape),
                .order = undefined,
            };
            self.order = Self.strideOrder(self.stride);
            if (opts.data) |data| {
                if (data.len >= self.len) {
                    self.data = data;
                } else {
                    return NDError.BufferTooSmall;
                }
            } else {
                if (opts.allocator) |allocator| {
                    self.data = try allocator.alloc(T, self.len);
                    @memset(self.data, 0);
                } else {
                    return NDError.MissingAllocator;
                }
            }
            return self;
        }

        pub fn free(self: *Self) void {
            if (self.allocator) |allocator| {
                allocator.free(self.data);
            }
        }

        pub inline fn index(self: *const Self, pos: [N]u32) usize {
            var idx = self.offset;
            comptime var i = 0;
            inline while (i < N) {
                idx += self.stride[i] * pos[i];
                i += 1;
            }
            return @as(usize, @intCast(idx));
        }

        pub fn positions(self: *const Self, opts: IterOpts) PositionIterator {
            return PositionIterator.init(self, opts.order);
        }

        pub fn indices(self: *const Self, opts: IterOpts) IndexIterator {
            return IndexIterator{ .pos = self.positions(opts) };
        }

        pub fn values(self: *const Self, opts: IterOpts) ValueIterator {
            return ValueIterator{ .pos = self.positions(opts) };
        }

        pub fn at(self: *const Self, pos: [N]u32) T {
            return self.data[self.index(pos)];
        }

        pub fn setAt(self: *const Self, pos: [N]u32, val: T) void {
            self.data[self.index(pos)] = val;
        }

        pub fn fill(self: *const Self, val: T) void {
            var iter = self.indices(.{});
            while (true) {
                if (iter.next()) |i| {
                    self.data[i] = val;
                } else break;
            }
        }

        pub fn sum(self: *const Self) T {
            const info = @typeInfo(T);
            if (!(info == .Int or info == .Float)) @compileError("only supported for int/float types");
            var acc: T = 0;
            var iter = self.values(.{});
            while (true) {
                if (iter.next()) |val| {
                    acc += val;
                } else break;
            }
            return acc;
        }

        pub fn sumAxis(self: *const Self, axis: ?u32) !NDArray(N - 1, T) {
            const K = N - 1;
            var newShape: [K]u32 = undefined;
            var j: usize = 0;
            for (self.shape, 0..) |s, i| {
                if (i != axis) {
                    newShape[j] = s;
                    j += 1;
                }
            }
            const acc = try NDArray(K, T).init(.{
                .shape = newShape,
                .allocator = self.allocator,
            });
            return acc;
        }

        pub fn toOwnedSlice(self: *const Self, opts: struct {
            data: ?[]T = null,
            allocator: ?*const Allocator = null,
            order: Order = .Major,
        }) ![]T {
            var dest: []T = undefined;
            if (opts.data) |data| {
                if (data.len < self.len) return NDError.BufferTooSmall;
                dest = data;
            } else if (opts.allocator) |allocator| {
                dest = try allocator.alloc(T, self.len);
            } else return NDError.MissingAllocator;
            var d: usize = 0;
            var iter = self.values(.{ .order = opts.order });
            while (true) {
                if (iter.next()) |val| {
                    dest[d] = val;
                    d += 1;
                } else break;
            }
            return dest;
        }

        // pub fn dot(self: *const Self, other: *const NDArray(type, T)) bool {}

        pub fn eq(self: *const Self, other: *const Self) bool {
            if (!std.mem.eql(u32, self.shape[0..], other.shape[0..])) return false;
            var ia = self.values(.{});
            var ib = other.values(.{});
            while (true) {
                if (ia.next()) |va| {
                    if (ib.next()) |vb| {
                        if (va != vb) return false;
                    } else return false;
                } else break;
            }
            return true;
        }

        pub fn eqApprox(self: *const Self, other: *const Self, tolerance: T) bool {
            if (@typeInfo(T) != .Float) @compileError("only supported for float types");
            if (!std.mem.eql(u32, self.shape[0..], other.shape[0..])) return false;
            var ia = self.values(.{});
            var ib = other.values(.{});
            while (true) {
                if (ia.next()) |va| {
                    if (ib.next()) |vb| {
                        if (!std.math.approxEqRel(T, va, vb, tolerance)) return false;
                    } else return false;
                } else break;
            }
            return true;
        }

        pub fn hi(self: *const Self, pos: [N]?u32) !Self {
            var newShape: [N]u32 = undefined;
            for (pos, 0..) |p, i| {
                if (p) |q| {
                    if (q < 1 or q > self.shape[i]) return NDError.OutOfBounds;
                    newShape[i] = q;
                } else {
                    newShape[i] = self.shape[i];
                }
            }
            return Self.init(.{
                .allocator = self.allocator,
                .data = self.data,
                .offset = self.offset,
                .shape = newShape,
                .stride = self.stride,
            });
        }

        pub fn lo(self: *const Self, pos: [N]?u32) !Self {
            var off = self.offset;
            var newShape: [N]u32 = undefined;
            for (pos, 0..) |p, i| {
                if (p) |q| {
                    if (q >= self.shape[i]) return NDError.OutOfBounds;
                    off += self.stride[i] * q;
                    newShape[i] = self.shape[i] - q;
                } else {
                    newShape[i] = self.shape[i];
                }
            }
            return Self.init(.{
                .allocator = self.allocator,
                .data = self.data,
                .offset = off,
                .shape = newShape,
                .stride = self.stride,
            });
        }

        /// Picks one or more axes from given ndarray and returns new a ndarray
        /// with / reduced dimensions. The new array is using the same data buffer.
        ///
        /// @param M - the number of axes to pick.
        /// @param axes - partial coordinates defining the picked axes.
        ///     A `null` coord means the respective axis remains unchanged.
        ///     The array MUST contain exactly `M` non-null values.
        pub fn pick(self: *const Self, comptime M: usize, axes: [N]?u32) !NDArray(N - M, T) {
            if (M < 1) @compileError("require at least 1 dimension");
            if (M >= N) @compileError("too many dimensions");
            const K = N - M;
            var newDim: usize = 0;
            for (axes) |a| {
                if (a == null) newDim += 1;
            }
            if (newDim != K) return NDError.InvalidPick;
            var newShape: [K]u32 = undefined;
            var newStride: [K]isize = undefined;
            var off = self.offset;
            var j: usize = 0;
            for (axes, 0..) |axis, i| {
                if (axis) |a| {
                    if (a >= self.shape[i]) return NDError.OutOfBounds;
                    off += self.stride[i] * a;
                } else {
                    newShape[j] = self.shape[i];
                    newStride[j] = self.stride[i];
                    j += 1;
                }
            }
            return NDArray(K, T).init(.{
                .allocator = self.allocator,
                .data = self.data,
                .offset = off,
                .shape = newShape,
                .stride = newStride,
            });
        }

        pub fn reshape(self: *const Self, comptime M: usize, opts: struct {
            shape: [M]u32,
            stride: ?[M]isize = null,
            offset: ?isize = null,
        }) !NDArray(M, T) {
            const A = NDArray(M, T);
            if (A.length(opts.shape) > self.data.len) return NDError.BufferTooSmall;
            return try A.init(.{
                .allocator = self.allocator,
                .data = self.data,
                .offset = if (opts.offset) |x| x else self.offset,
                .shape = opts.shape,
                .stride = opts.stride,
            });
        }

        pub fn step(self: *const Self, steps: [N]?i32) !Self {
            var newShape: [N]u32 = undefined;
            var newStride: [N]isize = undefined;
            var off = self.offset;
            for (steps, 0..) |ss, i| {
                if (ss) |s| {
                    var t = s;
                    if (s < 0) {
                        off += self.stride[i] * (self.shape[i] - 1);
                        t = -s;
                    }
                    newShape[i] = @divTrunc(self.shape[i], @as(u32, @intCast(t)));
                    newStride[i] = self.stride[i] * s;
                } else {
                    newShape[i] = self.shape[i];
                    newStride[i] = self.stride[i];
                }
            }
            return Self.init(.{
                .allocator = self.allocator,
                .data = self.data,
                .offset = off,
                .shape = newShape,
                .stride = newStride,
            });
        }

        pub fn transpose(self: *const Self, order: [N]u32) !Self {
            var newShape: [N]u32 = undefined;
            var newStride: [N]isize = undefined;
            for (order, 0..) |o, i| {
                if (o >= N) return NDError.OutOfBounds;
                newShape[i] = self.shape[o];
                newStride[i] = self.stride[o];
            }
            return Self.init(.{
                .allocator = self.allocator,
                .data = self.data,
                .offset = self.offset,
                .shape = newShape,
                .stride = newStride,
            });
        }

        pub fn print(self: *const Self) void {
            std.debug.print("NDArray({},{})[shape={d} stride={d} offset={d} len={d}]\n", .{
                N,
                T,
                self.shape,
                self.stride,
                self.offset,
                self.len,
            });
        }

        fn length(shape: [N]u32) usize {
            var len: usize = 1;
            for (shape) |s| len *= s;
            return len;
        }

        fn shapeToStride(shape: [N]u32) [N]isize {
            var stride = [_]isize{0} ** N;
            var s: isize = 1;
            for (shape, 0..) |_, i| {
                const j = N - 1 - i;
                stride[j] = s;
                s *= @as(isize, @intCast(shape[j]));
            }
            return stride;
        }

        fn strideOrder(stride: [N]isize) [N]u8 {
            const Item = struct { s: isize, i: usize };
            var res: [N]u8 = undefined;
            var indexed: [N]Item = undefined;
            for (indexed, 0..) |_, i| {
                indexed[i] = .{ .s = stride[i], .i = i };
            }
            const cmp = struct {
                fn inner(_: void, a: Item, b: Item) bool {
                    return iabs(a.s) < iabs(b.s);
                }
            };

            std.sort.insertion(Item, indexed[0..], {}, cmp.inner);
            for (indexed, 0..) |x, i| {
                res[i] = @as(u8, @intCast(x.i));
            }
            return res;
        }
    };
}

fn iabs(x: isize) isize {
    return if (x >= 0) x else -x;
}

pub fn range(n: u32, comptime T: type, allocator: *const Allocator) !NDArray(1, T) {
    const info = @typeInfo(T);
    if (!(info == .Int or info == .Float)) @compileError("only int or float types supported");
    var res = try NDArray(1, T).init(.{
        .allocator = allocator,
        .shape = .{n},
    });
    var iter = res.indices(.{});
    var j: T = 0;
    while (true) {
        if (iter.next()) |i| {
            res.data[i] = j;
            j += 1;
        } else break;
    }
    return res;
}

pub fn ones(comptime N: usize, comptime T: type, shape: [N]u32, allocator: *const Allocator) NDArray(N, T) {
    var res = try NDArray(N, T).init(.{
        .allocator = allocator,
        .shape = shape,
    });
    res.fill(1);
    return res;
}

const __allocator = &std.testing.allocator;

test "nd3 f32 init" {
    var a = try NDArray(3, f32).init(.{
        .shape = .{ 4, 4, 4 },
        .stride = .{ 1, 4, 16 },
        .allocator = __allocator,
    });
    std.debug.print("a.order {d}\n", .{a.order});
    defer a.free();

    try std.testing.expectEqual(f32, @TypeOf(a).T);
    try std.testing.expectEqual(@as(u32, 3), @TypeOf(a).dim);
    try std.testing.expectEqual(@as(usize, 4 * 4 * 4), a.len);
    try std.testing.expectEqual(@as(usize, 16 + 4 + 1), a.index(.{ 1, 1, 1 }));

    var bdata: [64]f32 = [_]f32{0} ** 64;
    var b = try NDArray(3, f32).init(.{
        .data = bdata[0..],
        // .data = try std.heap.page_allocator.alloc(f32, 65),
        // .allocator = std.heap.page_allocator,
        .shape = .{ 4, 4, 4 },
    });
    std.debug.print("b.order {d}\n", .{b.order});
    try std.testing.expectEqual([_]isize{ 16, 4, 1 }, b.stride);

    b.setAt(.{ 0, 1, 1 }, 42);
    try std.testing.expectEqual(@as(f32, 42), b.at(.{ 0, 1, 1 }));
    defer b.free();

    var p = try b.toOwnedSlice(.{ .allocator = __allocator });
    std.debug.print("{d}\n", .{p});
    __allocator.free(p);

    b.stride = .{ 1, 4, 16 };
    p = try b.toOwnedSlice(.{ .allocator = __allocator });
    std.debug.print("{d}\n", .{p});
    __allocator.free(p);
}

test "nd3 f32 iter" {
    var a = try NDArray(3, f32).init(.{
        .shape = .{ 4, 4, 4 },
        .stride = .{ 1, 4, 16 },
        .allocator = __allocator,
    });
    defer a.free();
    std.debug.print("stride {d}, order {d}\n", .{ a.stride, a.order });
    a.setAt(.{ 0, 1, 1 }, 23);
    a.setAt(.{ 1, 1, 1 }, 42);

    try std.testing.expect(a.eqApprox(&a, 1e-9));

    const p = try a.toOwnedSlice(.{ .allocator = __allocator });
    defer __allocator.free(p);
    std.debug.print("{d}\n", .{p});
    var i = a.values(.{});
    while (true) {
        if (i.next()) |pos| {
            std.debug.print("next: {d}\n", .{pos});
        } else break;
    }
}

test "1d reshape" {
    var a = try range(16, u32, __allocator);
    defer a.free();
    var b = try a.reshape(4, .{ .shape = .{ 2, 2, 2, 2 } });
    b = try b.transpose(.{ 1, 0, 3, 2 });
    std.debug.print("{d}", .{b.stride});
    var i = b.values(.{ .order = .Major });
    while (true) {
        if (i.next()) |pos| {
            std.debug.print("next: {d}\n", .{pos});
        } else break;
    }
}

test "2d trunc" {
    var a = try range(16, u32, __allocator);
    defer a.free();
    var b = try a.reshape(2, .{ .shape = .{ 4, 4 } });
    b = try b.lo(.{ 1, 2 });
    b = try b.hi(.{ 2, 2 });
    std.debug.print("{d}", .{b.shape});
    const c = try b.toOwnedSlice(.{ .allocator = __allocator });
    defer __allocator.free(c);
    std.debug.print("{d}\n", .{c});
}

test "3d -> 2d pick" {
    var a = try range(4 * 4 * 4, u32, __allocator);
    defer a.free();
    var b = try a.reshape(3, .{ .shape = .{ 4, 4, 4 } });
    var c = try b.pick(2, .{ 1, null, 1 });
    c.print();
    const d = try c.toOwnedSlice(.{ .allocator = __allocator });
    defer __allocator.free(d);
    std.debug.print("{d}\n", .{d});
}

test "3d step" {
    var a = try range(4 * 4 * 4, u32, __allocator);
    defer a.free();
    var b = try NDArray(3, u32).init(.{
        .data = a.data,
        .shape = .{ 4, 4, 4 },
        // .stride = .{ 1, 4, 16 },
        // .allocator = &std.heap.page_allocator,
    });
    std.debug.print("\n", .{});
    b.print();
    // var b2 = try a2.reshape(3, .{ .shape = .{ 4, 2, 4 } });
    var c = try b.step(.{ 2, -2, -1 });
    c.print();
    const d = try c.toOwnedSlice(.{ .allocator = __allocator });
    defer __allocator.free(d);
    std.debug.print("{d}\n", .{d});
}

test "3d axis iter" {
    var a = try range(4 * 4 * 4, u32, __allocator);
    defer a.free();
    var b = try NDArray(3, u32).init(.{
        .data = a.data,
        .shape = .{ 4, 4, 4 },
    });
    // var b = try a.reshape(3, .{ .shape = .{ 4, 4, 4 } });
    b.print();
    var c = try b.pick(1, .{ 0, null, null });
    c.print();
    std.debug.print("sum {d}\n", .{c.sum()});
    const d = try c.toOwnedSlice(.{ .allocator = __allocator });
    defer __allocator.free(d);
    std.debug.print("{d}\n", .{d});
}
