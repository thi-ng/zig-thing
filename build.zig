const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("thi.ng", .{
        .root_source_file = .{ .path = "src/main.zig" },
    });
}
