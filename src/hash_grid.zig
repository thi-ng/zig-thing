const std = @import("std");

const H1 = 0xcc9e2d51;
const H2 = 0xe6546b64;

pub fn HashGrid2(comptime TYPE: type) type {
    const INFO = @typeInfo(TYPE);
    if (!(INFO == .float)) {
        @compileError("require float type");
    }
    return struct {
        allocator: *const std.mem.Allocator,
        indices: []u32,
        entries: []u32,
        tableSize: u32,
        cellSize: TYPE,

        const Self = @This();

        /// Returns a new grid instance pre-initialized using provided allocator.
        /// The allocator is stored in the struct.
        pub fn init(cellSize: TYPE, capacity: u32, allocator: *const std.mem.Allocator) !Self {
            const size = capacity << 1;
            return Self{
                .allocator = allocator,
                .indices = try allocator.alloc(u32, size + 1),
                .entries = try allocator.alloc(u32, capacity),
                .tableSize = size,
                .cellSize = cellSize,
            };
        }

        pub fn free(self: *Self) void {
            self.allocator.free(self.indices);
            self.allocator.free(self.entries);
        }

        inline fn asGridPos(self: *const Self, x: TYPE) isize {
            return if (INFO == .float) @intFromFloat(x / self.cellSize) else @as(isize, x / self.cellSize);
        }

        pub inline fn hashPoint(self: *const Self, point: *const [2]TYPE) usize {
            return self.hashGridPos(
                self.asGridPos(point[0]),
                self.asGridPos(point[1]),
            );
        }

        pub inline fn hashGridPos(self: *const Self, x: isize, y: isize) usize {
            const h = ((@as(usize, @bitCast(x)) *% H1) ^ (@as(usize, @bitCast(y)) *% H2)) % self.tableSize;
            // std.debug.print("hash: {d} {d} => {d}\n", .{ x, y, h });
            return h;
        }

        /// (Re)build the hash grid by indexing provided points. The data structure does NOT
        /// support incremental point additions, only full (re)builds.
        pub fn build(self: *Self, points: []const [2]TYPE) void {
            std.debug.assert(points.len <= self.entries.len);
            @memset(self.indices, 0);
            @memset(self.entries, 0);
            for (points) |p| {
                self.indices[self.hashPoint(&p) % self.tableSize] += 1;
            }
            var prefixSum: u32 = 0;
            for (self.indices, 0..) |_, i| {
                prefixSum += self.indices[i];
                self.indices[i] = prefixSum;
            }
            self.indices[self.tableSize] = prefixSum;
            for (points, 0..) |p, i| {
                const h = self.hashPoint(&p);
                self.indices[h] -= 1;
                self.entries[self.indices[h]] = @intCast(i);
            }
        }

        /// Neighborhood query for indexed points around given `pos` and radius `r`. IDs
        /// of matching neighbors are written to `results` and a slice of it will be returned.
        /// The size of `results` defines the max. number of neighors returned. IDs are NOT
        /// sorted by distance. The radius is only used to determine the query area in terms of
        /// grid cells. Some of the selected points might lie outside the query circle defined
        /// by `pos` and `r`.
        pub fn query(self: *const Self, pos: *const [2]TYPE, r: TYPE, results: []u32) []u32 {
            const xmin = self.asGridPos(pos[0] - r);
            const xmax = self.asGridPos(pos[0] + r);
            const ymin = self.asGridPos(pos[1] - r);
            const ymax = self.asGridPos(pos[1] + r);
            var k: usize = 0;
            var x = xmin;
            while (x <= xmax) : (x += 1) {
                var y = ymin;
                while (y <= ymax) : (y += 1) {
                    const h = self.hashGridPos(x, y);
                    var i = self.indices[h];
                    const j = self.indices[h + 1];
                    while (i < j and k < results.len) : (i += 1) {
                        results[k] = self.entries[i];
                        k += 1;
                    }
                    if (k >= results.len) return results;
                }
            }
            return results[0..k];
        }
    };
}

const __allocator = &std.testing.allocator;

test "HashGrid2" {
    var grid = try HashGrid2(f32).init(2, 16, __allocator);
    defer grid.free();

    std.debug.assert(grid.cellSize == 2.0);
    std.debug.assert(grid.indices.len == 33);
    std.debug.assert(grid.entries.len == 16);

    grid.build(&.{
        [_]f32{ 1, 2 },
        [_]f32{ 3, 4 },
        [_]f32{ 5, 6 },
        [_]f32{ 7, 8 },
    });
    // std.debug.print("{}\n", .{grid});

    var ids = [_]u32{0} ** 8;
    const results = grid.query(&[_]f32{ 1, 2 }, 3, &ids);
    // std.debug.print("{d}\n", .{results});
    std.debug.assert(std.mem.eql(u32, results, &[_]u32{ 0, 1 }));
}
