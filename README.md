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

TODO

## License

&copy; 2021 - 2023 Karsten Schmidt // Apache Software License 2.0
