# zig.thi.ng

## About

Various, still somewhat unstructured, raw-around-the-edges experiments / open
learning with [Zig](https://ziglang.org), at some point hopefully culminating
into a monorepo of useful libraries.

## Current modules (all WIP)

| Name                                    | Description                                                                 |
| --------------------------------------- | --------------------------------------------------------------------------- |
| [`thing.DualList`](./src/dual-list.zig) | Dual-headed linked list for resource IDs (active/free)                      |
| [`thing.ndarray`](./doc/ndarray.md)     | Generic nD-Array base implementation                                        |
| [`thing.random`](./doc/random.md)       | Additional `std.rand.Random`-compatible PRNGs and related utilities.        |
| [`thing.vectors`](./doc/vectors.md)     | SIMD-based generic vector type & operations (incl. type specific additions) |

## Usage with Zig's package manager

There are no releases of this project available yet, you can refer to a certain
commit and add this to your `build.zig.zon` file:

```zig
.{
    .dependencies = .{
        .thing = .{
            .url = "https://github.com/thi-ng/zig-thing/archive/51e912790d50a8f7f81cb9820ad8d7c69696bb47.tar.gz",
            .hash = "1220234550c34577c708d0779d8eb4d4a2270a188585cb3755208153789407fa7483",
        },
    },
}
```

Then also update your main `build.zig` with these additions:

```zig
// standard stuff...
const target = b.standardTargetOptions(.{});
const optimize = b.standardOptimizeOption(.{});

// main build step...
const exe = b.addExecutable(.{ ... });

// declare & configure dependency (via build.zig.zon)
const thing = b.dependency("thing", .{
    .target = target,
    .optimize = optimize,
}).module("thing");

// declare dependency for importing
exe.addModule("thing", thing);
```

With these changes, you can then import the module in your source code like so:

```zig
const thing = @import("thing");
```

## License

&copy; 2021 - 2023 Karsten Schmidt // Apache Software License 2.0
