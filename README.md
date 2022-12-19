# zig.thi.ng

## About

Various, still somewhat unstructured, raw-around-the-edges experiments / open
learning with [Zig](https://ziglang.org), at some point cumulating into a
monorepo of useful libraries.

## Current packages (all WIP)

| Name                        | Description                                                                 |
| --------------------------- | --------------------------------------------------------------------------- |
| [thing-ndarray](./ndarray/) | Generic nD-Array base implementation                                        |
| [thing-random](./random/)   | Additional `std.rand.Random`-compatible PRNGs and related utilities.        |
| [thing-vectors](./vectors/) | SIMD-based generic vector type & operations (incl. type specific additions) |

## Usage with gyro

All of the above projects are declared as packages in the repo root's
[`gyro.zzz` package
file](https://github.com/thi-ng/zig-thing/blob/main/gyro.zzz) for use with
@mattnite's [gyro](https://github.com/mattnite/gyro) package manager. To use one
(or more) of them:

```text
gyro add -a thing-vectors --src github thi-ng/zig-thing

gyro fetch
```

To integrate gyro with your project's `build.zig` file, follow the [instructions
from the gyro readme](https://github.com/mattnite/gyro#introduction).

## License

&copy; 2021 - 2022 Karsten Schmidt // Apache Software License 2.0
