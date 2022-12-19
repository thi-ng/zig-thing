const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("thing-random", "src/lib.zig");
    lib.setTarget(b.standardTargetOptions(.{}));
    lib.setBuildMode(mode);
    lib.install();

    const tests = b.addTest("src/lib.zig");
    tests.setBuildMode(mode);

    const testStep = b.step("test", "Run library tests");
    testStep.dependOn(&tests.step);
}
