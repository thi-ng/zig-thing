# zig.thi.ng

## About

Various, still somewhat unstructured, raw-around-the-edges utilities / open
learning with [Zig](https://ziglang.org), at some point hopefully culminating
into a useful toolkit.

**All code in this repo is compatible with Zig v0.14.0**

## Current modules (all WIP)

| Name                                               | Description                                                                 |
| -------------------------------------------------- | --------------------------------------------------------------------------- |
| [`thing.FixedBufferDualList`](./src/dual_list.zig) | Dual-headed linked list for resource IDs allocation (active/available)      |
| [`thing.ndarray`](./src/ndarray.zig)               | Generic nD-Array base implementation                                        |
| [`thing.random`](./src/random.zig)                 | Additional `std.rand.Random`-compatible PRNGs and related utilities.        |
| [`thing.vectors`](./doc/vectors.md)                | SIMD-based generic vector type & operations (incl. type specific additions) |

## Usage with Zig's package manager

Tagged versions of this project are available and can be added as dependency to
your project via `zig fetch`, like so:

```bash
zig fetch --save https://github.com/thi-ng/zig-thing/archive/refs/tags/v0.1.1.tar.gz
```

The `--save` option adds a new dependency called `thing` to your
`build.zig.zon` project file.

You'll also need to update your main `build.zig` with these additions:

```zig
// <standard_boilerplate>
const target = b.standardTargetOptions(.{});
const optimize = b.standardOptimizeOption(.{});
// main build step...
const exe = b.addExecutable(.{ ... });
// </standard_boilerplate>

// declare & configure dependency (via build.zig.zon)
const thing = b.dependency("thing", .{
    .target = target,
    .optimize = optimize,
}).module("thing");

// declare module for importing via given id
exe.root_module.addImport("thing", thing);
```

**Important:** If you're having a test build step configured (or any other build
step requiring separate compilation), you'll also need to add the
`.root_module.addImport()` call for that step too!

With these changes, you can then import the module in your source code like so:

```zig
const thing = @import("thing");
```

## Building & Testing

The package is not meant to be build directly (yet), so currently the build file
only declares a module.

To run all tests:

```bash
zig test src/main.zig
```

## License

&copy; 2021 - 2025 Karsten Schmidt // Apache Software License 2.0
