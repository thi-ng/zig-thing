// SPDX-License-Identifier: Apache-2.0

const std = @import("std");
const testing = std.testing;

const DualListError = error{
    OutOfMemory,
    InvalidID,
};

/// Fixed size managed buffer which stores two separate implicitly linked
/// lists of integer IDs (e.g. resource identifiers) in the same space.
/// Only uses N+2 ints of configured type. No extra space needed for links
/// between cells. The first list stores IDs currently in use, the other
/// stores currently available IDs.
///
/// Any unsigned int type is supported for IDs. The max. list capacity
/// depends on that chosen type (e.g. 255 for `u8`, 65535 for `u16`...)
///
/// Structural diagram:
/// https://mastodon.thi.ng/@toxi/111449052682849612
pub fn FixedBufferDualList(comptime SIZE: usize, comptime T: type) type {
    const info = @typeInfo(T);
    if (!(info == .int and info.int.signedness == .unsigned)) {
        @compileError("unsupported type: expected an uint, but got: " ++ @typeName(T));
    }
    const sentinel = std.math.maxInt(T);
    if (SIZE > sentinel) {
        var buf: [64]u8 = undefined;
        @compileError(try std.fmt.bufPrint(&buf, "unsupported size: {d} (max allowed {d})", .{ SIZE, sentinel }));
    }
    return extern struct {
        active: T = SENTINEL,
        available: T = 0,
        slots: [SIZE]T = undefined,

        /// Sentinel value used to mark the end of a list
        pub const SENTINEL = sentinel;

        const Self = @This();

        const Iterator = struct {
            parent: *Self,
            nextID: ?T,

            fn init(parent: *Self) Iterator {
                return Iterator{
                    .parent = parent,
                    .nextID = null,
                };
            }

            /// Returns next ID in the active list or null if there're no
            /// further items. Any newly allocated IDs *after* the first
            /// call to this function will *not* be seen by this iterator
            /// instance.
            /// IMPORTANT: Freeing an active ID during iterator processing
            /// is **only** safe to do for the ID most recently returned by
            /// this function. Freeing any other ID will result in
            /// undefined behavior.
            pub fn next(self: *Iterator) ?T {
                const id = self.nextID orelse self.parent.active;
                if (id == SENTINEL) {
                    self.nextID = SENTINEL;
                    return null;
                }
                self.nextID = self.parent.slots[id];
                return id;
            }
        };

        /// Returns a new, fully initialized instance (see `init()`)
        pub fn new() Self {
            var inst = Self{};
            inst.init();
            return inst;
        }

        /// Initializes (or resets) both lists and marks all IDs as available
        pub fn init(self: *Self) void {
            self.active = SENTINEL;
            self.available = 0;
            for (1..SIZE + 1) |i| {
                self.slots[i - 1] = if (i < SIZE) @intCast(i) else SENTINEL;
            }
        }

        /// Creates and returns a copy of the given instance. This can be useful
        /// for some types of iterator processing, where the iterator reads from
        /// a copy and the / original list will be mutated (by freeing/allocating
        /// values).
        pub fn copy(self: *Self) Self {
            var inst = Self{};
            inst.active = self.active;
            inst.available = self.available;
            inst.slots = self.slots;
            return inst;
        }

        /// Attempts to mark the next available ID as active (O(1) op) and if
        /// successful returns it. Otherwise returns an error.
        pub fn alloc(self: *Self) DualListError!T {
            const nextID = self.available;
            if (nextID == SENTINEL) return DualListError.OutOfMemory;
            self.available = self.slots[nextID];
            self.slots[nextID] = self.active;
            self.active = nextID;
            return nextID;
        }

        /// Attempts to mark the given ID as free/available again (O(n) op).
        /// Returns an error if ID is invalid or already freed.
        pub fn free(self: *Self, id: T) DualListError!void {
            if (id >= SIZE) return DualListError.InvalidID;
            var prev: *T = &self.active;
            var nextID = self.active;
            while (true) {
                if (nextID == SENTINEL) return DualListError.InvalidID;
                const curr = &self.slots[nextID];
                if (nextID == id) {
                    nextID = curr.*;
                    prev.* = nextID;
                    curr.* = self.available;
                    self.available = id;
                    return;
                }
                prev = curr;
                nextID = self.slots[nextID];
            }
        }

        /// Returns an iterator of all currently active IDs
        pub fn iterator(self: *Self) Iterator {
            return Iterator.init(self);
        }
    };
}

test "FixedBufferDualList" {
    const ListU8 = FixedBufferDualList(4, u8);
    var list = ListU8.new();
    try testing.expectEqualDeep(
        list,
        ListU8{ .active = 255, .available = 0, .slots = [4]u8{ 1, 2, 3, 255 } },
    );
    try testing.expect(try list.alloc() == 0);
    try testing.expect(try list.alloc() == 1);
    try testing.expect(try list.alloc() == 2);
    var iter = list.iterator();
    while (iter.next()) |i| {
        std.debug.print("active: {d}\n", .{i});
    }
    try testing.expectError(DualListError.InvalidID, list.free(100));
    try list.free(0);
    try testing.expectError(DualListError.InvalidID, list.free(0));
    try list.free(2);
    try testing.expectError(DualListError.InvalidID, list.free(2));
    try list.free(1);
    try testing.expectError(DualListError.InvalidID, list.free(1));
    try testing.expectEqualDeep(
        list,
        ListU8{ .active = 255, .available = 1, .slots = [4]u8{ 3, 2, 0, 255 } },
    );
    try testing.expect(try list.alloc() == 1);
    try testing.expect(try list.alloc() == 2);
    try testing.expect(try list.alloc() == 0);
    try testing.expect(try list.alloc() == 3);
    try testing.expectError(DualListError.OutOfMemory, list.alloc());
}

test "FixedBufferDualList.iterator() basic" {
    const ListU8 = FixedBufferDualList(4, u8);
    var list = ListU8.new();
    try testing.expect(try list.alloc() == 0);
    try testing.expect(try list.alloc() == 1);
    try testing.expect(try list.alloc() == 2);
    var iter = list.iterator();
    try testing.expect(iter.next() == 2);
    try testing.expect(iter.next() == 1);
    try testing.expect(iter.next() == 0);
    try testing.expect(iter.next() == null);
}

test "iterator alloc post creation" {
    const ListU8 = FixedBufferDualList(4, u8);
    var list = ListU8.new();
    try testing.expect(try list.alloc() == 0);
    try testing.expect(try list.alloc() == 1);
    var iter = list.iterator();
    try testing.expect(try list.alloc() == 2);
    try testing.expect(iter.next() == 2);
    // alloc after 1st iter.next() will NOT be seen by iter
    try testing.expect(try list.alloc() == 3);
    try testing.expect(iter.next() == 1);

    // new iterator
    iter = list.iterator();
    // now should see #4...
    try testing.expect(iter.next() == 3);
    try testing.expect(iter.next() == 2);
}

test "iterator free" {
    const ListU8 = FixedBufferDualList(4, u8);
    var list = ListU8.new();
    try testing.expect(try list.alloc() == 0);
    try testing.expect(try list.alloc() == 1);
    try testing.expect(try list.alloc() == 2);
    try testing.expect(try list.alloc() == 3);

    var iter = list.iterator();
    try list.free(3);
    try testing.expect(iter.next() == 2);
    try list.free(2);
    try testing.expect(iter.next() == 1);
    try list.free(1);
    try testing.expect(iter.next() == 0);
    try list.free(0);
    try testing.expect(try list.alloc() == 0);
    try testing.expect(iter.next() == null);
    try testing.expect(try list.alloc() == 1);
    try testing.expect(iter.next() == null);
}

test "iterator empty" {
    const ListU8 = FixedBufferDualList(4, u8);
    var list = ListU8.new();
    var iter = list.iterator();
    try testing.expect(iter.next() == null);
    // once end has been reached, new allocs must not impact iterator
    // checking a special case here since list is empty so next() call is different
    try testing.expect(try list.alloc() == 0);
    try testing.expect(iter.next() == null);
}

test "copy" {
    const ListU8 = FixedBufferDualList(4, u8);
    var list = ListU8.new();
    try testing.expect(try list.alloc() == 0);
    try testing.expect(try list.alloc() == 1);
    var list2 = list.copy();
    try testing.expect(try list.alloc() == 2);
    try testing.expect(try list2.alloc() == 2);
}
