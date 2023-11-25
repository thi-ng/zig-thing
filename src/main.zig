pub const DualList = @import("dual-list.zig").DualList;

pub const ndarray = @import("ndarray.zig");
pub const random = @import("random.zig");
pub const vectors = @import("vectors.zig");

test {
    _ = @import("dual-list.zig");
    _ = @import("vectors.zig");
}
