const std = @import("std");
const testing = std.testing;

/// Fixed size managed buffer which stores two separate linked lists / of
/// integer IDs (e.g. resource identifiers). The first list stores / IDs
/// currently in use, the other stores currently available IDs.
///
/// Any unsigned int type is supported for IDs. The max. list capacity
/// depends on that chosen type (e.g. 255 for `u8`, 65535 for `u16`...)
pub fn DualList(comptime SIZE: u16, comptime T: type) type {
    const info = @typeInfo(T);
    if (!(info == .Int and info.Int.signedness == .unsigned)) {
        @compileError("unsupported type: expected an uint, but got: " ++ @typeName(T));
    }
    const sentinel = std.math.maxInt(T);
    if (SIZE > sentinel) {
        var buf: [64]u8 = undefined;
        @compileError(std.fmt.bufPrint(&buf, "unsupported size: {d} (max allowed {d})", .{ SIZE, sentinel }) catch "");
    }
    return extern struct {
        active: T = SENTINEL,
        available: T = 0,
        slots: [SIZE]T = undefined,

        pub const SENTINEL = sentinel;

        const Self = @This();

        const Iterator = struct {
            parent: *const Self,
            curr: *const T,

            pub fn next(self: *Iterator) ?T {
                const id = self.curr.*;
                if (id == SENTINEL) return null;
                self.curr = &self.parent.slots[id];
                return id;
            }
        };

        pub fn new() Self {
            var inst = Self{};
            inst.init();
            return inst;
        }

        pub fn init(self: *Self) void {
            self.active = SENTINEL;
            self.available = 0;
            for (1..SIZE + 1) |i| {
                self.slots[i - 1] = if (i < SIZE) @intCast(i) else SENTINEL;
            }
        }

        pub fn alloc(self: *Self) ?T {
            const nextID = self.available;
            if (nextID == SENTINEL) return null;
            self.available = self.slots[nextID];
            self.slots[nextID] = self.active;
            self.active = nextID;
            return nextID;
        }

        pub fn free(self: *Self, id: T) bool {
            if (id >= SIZE) return false;
            var prev: *T = &self.active;
            var nextID = self.active;
            while (true) {
                if (nextID == SENTINEL) return false;
                var curr = &self.slots[nextID];
                if (nextID == id) {
                    nextID = curr.*;
                    prev.* = nextID;
                    curr.* = self.available;
                    self.available = id;
                    return true;
                }
                prev = curr;
                nextID = self.slots[nextID];
            }
        }

        pub fn iterateActive(self: *Self) Iterator {
            return Iterator{ .parent = self, .curr = &self.active };
        }

        pub fn iterateFree(self: *Self) Iterator {
            return Iterator{ .parent = self, .curr = &self.available };
        }
    };
}

test "DualList" {
    const ListU8 = DualList(4, u8);
    var list = ListU8.new();
    try testing.expectEqualDeep(
        list,
        ListU8{ .active = 255, .available = 0, .slots = [4]u8{ 1, 2, 3, 255 } },
    );
    try testing.expect(list.alloc() == 0);
    try testing.expect(list.alloc() == 1);
    try testing.expect(list.alloc() == 2);
    var iter = list.iterateActive();
    while (iter.next()) |i| {
        std.debug.print("active: {d}\n", .{i});
    }
    try testing.expect(!list.free(100));
    try testing.expect(list.free(0));
    try testing.expect(!list.free(0));
    try testing.expect(list.free(2));
    try testing.expect(!list.free(2));
    try testing.expect(list.free(1));
    try testing.expect(!list.free(1));
    try testing.expectEqualDeep(
        list,
        ListU8{ .active = 255, .available = 1, .slots = [4]u8{ 3, 2, 0, 255 } },
    );
    iter = list.iterateFree();
    while (iter.next()) |i| {
        std.debug.print("free: {d}\n", .{i});
    }
    try testing.expect(list.alloc() == 1);
    try testing.expect(list.alloc() == 2);
    try testing.expect(list.alloc() == 0);
    try testing.expect(list.alloc() == 3);
    try testing.expect(list.alloc() == null);
}
