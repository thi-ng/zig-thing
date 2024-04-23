# zig.thi.ng

## About

Various, still somewhat unstructured, raw-around-the-edges utilities / open
learning with [Zig](https://ziglang.org), at some point hopefully culminating
into a useful toolkit.

## Current modules (all WIP)

| Name                                               | Description                                                                 |
| -------------------------------------------------- | --------------------------------------------------------------------------- |
| [`thing.FixedBufferDualList`](./src/dual-list.zig) | Dual-headed linked list for resource IDs allocation (active/available)      |
| [`thing.ndarray`](./src/ndarray.zig)               | Generic nD-Array base implementation                                        |
| [`thing.random`](./src/random.zig)                 | Additional `std.rand.Random`-compatible PRNGs and related utilities.        |
| [`thing.vectors`](./doc/vectors.md)                | SIMD-based generic vector type & operations (incl. type specific additions) |

## Usage with Zig's package manager

There are no releases of this project available yet, you can refer to a certain
commit and add something like below to your `build.zig.zon` file.

**Important:** If you're choosing a different (newer) commit, do **omit** the
`.hash` line! `zig build` will first throw an error, but also display the
expected multihash value, which you can paste into the `build.zig.zon` file and
then build again...

```zig
.{
    .dependencies = .{
        .@"thi.ng" = .{
            .url = "https://github.com/thi-ng/zig-thing/archive/fa93bddf035c32b30c910678743b3c0f8065b479.tar.gz",
            .hash = "12209054cb0ca8d7f2478e1f2a66bd2921e4e41a0448dbaa72ad5cbe9e2c1c57b5d1",
        },
    },
}
```

You'll also need to update your main `build.zig` with these additions:

```zig
// <standard_boilerplate>
const target = b.standardTargetOptions(.{});
const optimize = b.standardOptimizeOption(.{});
// main build step...
const exe = b.addExecutable(.{ ... });
// </standard_boilerplate>

// actual additions...

// declare & configure dependency (via build.zig.zon)
const thing = b.dependency("thi.ng", .{}).module("thi.ng");

// declare module for importing via given id
exe.addModule("thi.ng", thing);
```

**Important:** If you're having a test build step configured (or any other build
step requiring separate compilation), you'll also need to add the `.addModule()`
call for that step too!

With these changes, you can then import the module in your source code like so:

```zig
const thing = @import("thi.ng");
```

## Building & Testing

The package is not meant to be build directly (yet), so currently the build file
only declares a module.

To run all tests:

```bash
zig test src/main.zig
```

## License

&copy; 2021 - 2023 Karsten Schmidt // Apache Software License 2.0
