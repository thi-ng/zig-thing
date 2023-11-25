const std = @import("std");
const testing = std.testing;

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
    return struct {
        active: T = SENTINEL,
        free: T = 0,
        slots: [SIZE]T = undefined,

        pub const SENTINEL = sentinel;

        const Self = @This();

        pub fn new() Self {
            var inst = Self{};
            inst.init();
            return inst;
        }

        pub fn init(self: *Self) void {
            self.active = SENTINEL;
            self.free = 0;
            for (1..SIZE + 1) |i| {
                self.slots[i - 1] = if (i < SIZE) @intCast(i) else SENTINEL;
            }
        }

        pub fn allocSlot(self: *Self) T {
            const nextID = self.free;
            if (nextID != SENTINEL) {
                self.free = self.slots[nextID];
                self.slots[nextID] = self.active;
                self.active = nextID;
            }
            return nextID;
        }

        pub fn freeSlot(self: *Self, slot: T) bool {
            if (slot >= SIZE) return false;
            var prev: *T = &self.active;
            var nextID = self.active;
            while (true) {
                if (nextID == SENTINEL) return false;
                var curr = &self.slots[nextID];
                if (nextID == slot) {
                    nextID = curr.*;
                    prev.* = nextID;
                    curr.* = self.free;
                    self.free = slot;
                    return true;
                }
                prev = curr;
                nextID = self.slots[nextID];
            }
        }
    };
}

test "DualList" {
    const ListU8 = DualList(4, u8);
    var list = ListU8.new();
    try testing.expectEqualDeep(
        list,
        ListU8{ .active = 255, .free = 0, .slots = [4]u8{ 1, 2, 3, 255 } },
    );
    try testing.expect(list.allocSlot() == 0);
    try testing.expect(list.allocSlot() == 1);
    try testing.expect(list.allocSlot() == 2);
    try testing.expect(list.freeSlot(0));
    try testing.expect(!list.freeSlot(0));
    try testing.expect(list.freeSlot(2));
    try testing.expect(!list.freeSlot(2));
    try testing.expect(list.freeSlot(1));
    try testing.expect(!list.freeSlot(1));
    try testing.expectEqualDeep(
        list,
        ListU8{ .active = 255, .free = 1, .slots = [4]u8{ 3, 2, 0, 255 } },
    );
    try testing.expect(list.allocSlot() == 1);
    try testing.expect(list.allocSlot() == 2);
    try testing.expect(list.allocSlot() == 0);
    try testing.expect(list.allocSlot() == 3);
    try testing.expect(list.allocSlot() == 255);
}
